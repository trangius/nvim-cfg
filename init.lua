-- Set <space> as the leader key
--	NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager, lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

-- make nvim start from last position
vim.api.nvim_create_augroup("RememberLastPosition", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
	group = "RememberLastPosition",
	pattern = "*",
	callback = function()
		local last_line = vim.fn.line("'\"")
		local last_line_in_buffer = vim.fn.line("$")
		if last_line > 0 and last_line <= last_line_in_buffer then
			vim.api.nvim_win_set_cursor(0, { last_line, 0 })
		end
	end,
})

-- require these ones
require('plugins')
require('pluginscfg')
require('options')
require('keymaps')


-- Always-on right-side chrome: aerial (symbol outline) + neo-tree (file tree).
-- When launched with no file, land inside neo-tree so we can pick one.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require('aerial').open({ focus = false })
    if vim.fn.argc() == 0 then
      vim.cmd('Neotree focus')
    else
      vim.cmd('Neotree show')
    end
  end,
})

-- `:q` / `:q!` override for the sidebar setup.
--
-- Problem: aerial's WinEnter/BufEnter autocmd self-quits (`vim.cmd.quit()`)
-- whenever focus lands on its window with a missing source_win and the last
-- command history entry starts with `q`. So during a normal `:q` on main,
-- vim closes main → focus lands on aerial → aerial fires its own :quit →
-- nested inside the user's :q/:qa → state collapses (fullscreen neo-tree).
--
-- Fix: force-close every non-current window ourselves (nvim_win_close skips
-- WinEnter on aerial, so its self-quit logic never runs) before handing off
-- to vim's native `:q` / `:q!` on the one window left. That way vim's own
-- E37 fires cleanly on modifications, and `:q!` tears everything down in
-- one step without the autocmd race.
--
-- Modified check scans every editable buffer in the tab (buftype "") because
-- `:q` can be invoked from a sidebar where `vim.bo.modified` would be false
-- even though the main window has unsaved work.
vim.api.nvim_create_user_command("Q", function(opts)
  if not opts.bang then
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(w)
      if vim.bo[buf].buftype == "" and vim.bo[buf].modified then
        vim.api.nvim_echo({ { "E37: No write since last change (add ! to override)", "ErrorMsg" } }, true, {})
        return
      end
    end
  end
  local cur = vim.api.nvim_get_current_win()
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if w ~= cur and vim.api.nvim_win_is_valid(w) then
      pcall(vim.api.nvim_win_close, w, true)
    end
  end
  -- qall (not quit) is required because after the close loop, the main
  -- file's buffer is hidden-but-modified. :quit! only discards the *current*
  -- buffer's changes — a hidden modified buffer would still block the exit
  -- with E37. :qall! discards everything.
  vim.cmd(opts.bang and "qall!" or "qall")
end, { bang = true })
vim.cmd([[cnoreabbrev <expr> q (getcmdtype() == ':' && getcmdline() == 'q') ? 'Q' : 'q']])


vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.textwidth = 0
    vim.opt_local.autoindent = false
    vim.opt_local.smartindent = false
    vim.opt_local.cindent = false
    vim.opt_local.indentexpr = ""
  end,
})
