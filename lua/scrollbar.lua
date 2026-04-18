-- Minimal flicker-free scrollbar for the active code window.
--
-- Strategy: one floating window pinned to the right edge of the current
-- window. On events (scroll / cursor move / diag change / git change /
-- buf enter / resize) we only UPDATE the window's content and position
-- via nvim_win_set_config + buf_set_extmark — never close & reopen.
-- That's what eliminates flicker.
--
-- Marks (highest priority wins per row):
--   cursor > error > warning > git-delete > git-change > git-add
-- Viewport ("thumb") is rendered as a bg highlight over the range of
-- scrollbar rows that correspond to currently-visible file lines.

local M = {}

local sb_buf
local sb_win
local ns = vim.api.nvim_create_namespace("scrollbar_marks")
local aug

local HL = {
  handle    = "ScrollbarHandle",
  thumb     = "ScrollbarThumb",
  cursor    = "ScrollbarCursor",
  error     = "ScrollbarError",
  git_add   = "ScrollbarGitAdd",
  git_chg   = "ScrollbarGitChange",
  git_del   = "ScrollbarGitDelete",
}

-- Priority: higher index = higher priority (overwrites lower)
local PRIO = {
  [HL.git_add] = 1,
  [HL.git_chg] = 2,
  [HL.git_del] = 3,
  [HL.error]   = 4,
  [HL.cursor]  = 5,
}

local SIDEBAR_FT = { aerial = true, ["neo-tree"] = true, NvimTree = true, trouble = true, qf = true, help = true }

local function setup_highlights()
  -- Linked bases for the "no mark" rows.
  vim.api.nvim_set_hl(0, HL.handle, { link = "NonText", default = true })
  vim.api.nvim_set_hl(0, HL.thumb,  { link = "PmenuThumb", default = true })
  -- Solid bg for marks so a 1-column scrollbar still pops instead of
  -- showing a dim foreground glyph. fg is kept dark for readability on
  -- top of the bright bg.
  local dark_fg = "#1e1e1e"
  -- Cursor: a bright dot drawn directly onto whatever is behind it
  -- (thumb or handle). Using fg-only so the "●" reads as a point, not
  -- a filled cell.
  vim.api.nvim_set_hl(0, HL.cursor,  { fg = "#e0e0e0", default = true })
  vim.api.nvim_set_hl(0, HL.error,   { bg = "#e06c75", fg = dark_fg, default = true })
  -- Muted git marks — the scrollbar is ambient info, not something you
  -- need to decode at a glance. Error stays vivid (urgent); git is calmer.
  -- Delete is purple (not red) so urgency remains visually distinct.
  vim.api.nvim_set_hl(0, HL.git_add, { bg = "#4e6842", fg = dark_fg, default = true })
  vim.api.nvim_set_hl(0, HL.git_chg, { bg = "#3d5770", fg = dark_fg, default = true })
  vim.api.nvim_set_hl(0, HL.git_del, { bg = "#594263", fg = dark_fg, default = true })
end

local function is_excluded(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local bt = vim.bo[buf].buftype
  local ft = vim.bo[buf].filetype
  if bt ~= "" then return true end
  if SIDEBAR_FT[ft] then return true end
  local cfg = vim.api.nvim_win_get_config(win)
  if cfg.relative ~= "" then return true end -- skip floating windows
  return false
end

local function ensure_buf()
  if sb_buf and vim.api.nvim_buf_is_valid(sb_buf) then return end
  sb_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[sb_buf].buftype   = "nofile"
  vim.bo[sb_buf].bufhidden = "hide"
  vim.bo[sb_buf].swapfile  = false
  vim.bo[sb_buf].filetype  = "scrollbar"
end

local function close()
  if sb_win and vim.api.nvim_win_is_valid(sb_win) then
    pcall(vim.api.nvim_win_close, sb_win, true)
  end
  sb_win = nil
end

-- Map file line (1-indexed) → scrollbar row (0-indexed).
local function line_to_row(line, total, height)
  if total <= 1 or height <= 1 then return 0 end
  local row = math.floor((line - 1) * height / total)
  if row < 0 then row = 0 end
  if row > height - 1 then row = height - 1 end
  return row
end

local function place(row, hl, marks)
  local prev = marks[row]
  if not prev or PRIO[hl] > PRIO[prev] then
    marks[row] = hl
  end
end

local function collect(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local total = vim.api.nvim_buf_line_count(buf)
  local height = vim.api.nvim_win_get_height(win)
  local marks = {}

  -- Diagnostics (errors only — warnings are noisy for scrollbar view)
  for _, d in ipairs(vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })) do
    place(line_to_row(d.lnum + 1, total, height), HL.error, marks)
  end

  -- Git hunks via gitsigns
  local ok, gs = pcall(require, "gitsigns")
  if ok and gs.get_hunks then
    local hunks = gs.get_hunks(buf) or {}
    for _, h in ipairs(hunks) do
      local hl = HL.git_chg
      if h.type == "add" then hl = HL.git_add
      elseif h.type == "delete" then hl = HL.git_del end
      local start = (h.added and h.added.start) or h.start or 1
      place(line_to_row(start, total, height), hl, marks)
    end
  end

  -- Thumb (viewport range): top row .. bottom row
  local top = vim.fn.line("w0", win)
  local bot = vim.fn.line("w$", win)
  local thumb_top = line_to_row(top, total, height)
  local thumb_bot = line_to_row(bot, total, height)

  -- Cursor
  local cur = vim.api.nvim_win_get_cursor(win)[1]
  local cursor_row = line_to_row(cur, total, height)
  place(cursor_row, HL.cursor, marks)

  return marks, height, thumb_top, thumb_bot, total > height, cursor_row
end

local function render(target)
  ensure_buf()
  local marks, height, thumb_top, thumb_bot, scrollable, cursor_row = collect(target)

  if not scrollable then
    -- File fits entirely on screen; no need for a scrollbar.
    close()
    return
  end

  -- Window config (create or update without closing)
  local win_w = vim.api.nvim_win_get_width(target)
  local cfg = {
    relative = "win",
    win = target,
    row = 0,
    col = win_w - 1,
    width = 1,
    height = height,
    focusable = false,
    zindex = 20,
    style = "minimal",
    noautocmd = true,
  }

  if sb_win and vim.api.nvim_win_is_valid(sb_win) then
    pcall(vim.api.nvim_win_set_config, sb_win, cfg)
  else
    sb_win = vim.api.nvim_open_win(sb_buf, false, cfg)
    vim.wo[sb_win].winhighlight = "Normal:NormalFloat"
    vim.wo[sb_win].wrap = false
  end

  -- Buffer content: "│" on most rows, "●" on the cursor row so the cursor
  -- reads as a point instead of a filled cell.
  local lines = {}
  for i = 1, height do lines[i] = "│" end
  if cursor_row and cursor_row + 1 >= 1 and cursor_row + 1 <= height then
    lines[cursor_row + 1] = "•"
  end
  vim.bo[sb_buf].modifiable = true
  vim.api.nvim_buf_set_lines(sb_buf, 0, -1, false, lines)
  vim.bo[sb_buf].modifiable = false

  -- Extmarks
  vim.api.nvim_buf_clear_namespace(sb_buf, ns, 0, -1)

  -- Thumb: bg highlight over viewport range
  for r = thumb_top, thumb_bot do
    vim.api.nvim_buf_set_extmark(sb_buf, ns, r, 0, {
      end_col = 3, -- covers the 3-byte "│" glyph
      hl_group = HL.thumb,
      priority = 100,
    })
  end

  -- Point marks (overwrite thumb color where they exist)
  for row, hl in pairs(marks) do
    vim.api.nvim_buf_set_extmark(sb_buf, ns, row, 0, {
      end_col = 3,
      hl_group = hl,
      priority = 200,
    })
  end
end

local function update()
  local win = vim.api.nvim_get_current_win()
  if sb_win and win == sb_win then return end -- ignore events from our own window
  if is_excluded(win) then
    close()
    return
  end
  render(win)
end

-- Debounce updates via a single libuv timer. Without this, CursorMoved and
-- WinScrolled each schedule their own update; the first runs with "cursor at
-- new row, viewport still at old range" and we flash a frame where the
-- cursor mark sits outside the thumb. With debouncing, rapid events collapse
-- to one render at the final settled state.
local timer = vim.uv.new_timer()
local function schedule_update()
  timer:stop()
  timer:start(10, 0, vim.schedule_wrap(update))
end

function M.setup()
  setup_highlights()
  ensure_buf()

  aug = vim.api.nvim_create_augroup("CustomScrollbar", { clear = true })

  vim.api.nvim_create_autocmd({
    "WinScrolled", "CursorMoved", "CursorMovedI",
    "BufEnter", "WinEnter", "WinResized",
    "DiagnosticChanged",
  }, { group = aug, callback = schedule_update })

  vim.api.nvim_create_autocmd("User", {
    group = aug,
    pattern = "GitSignsUpdate",
    callback = schedule_update,
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    group = aug,
    callback = function(args)
      local closing = tonumber(args.match)
      if sb_win and closing == sb_win then sb_win = nil end
      vim.schedule(update)
    end,
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = aug,
    callback = setup_highlights,
  })

  schedule_update()
end

return M
