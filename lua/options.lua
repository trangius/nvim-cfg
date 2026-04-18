-- use tabs as 4 spaces
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.modeline = false

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.o.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Relative line number
vim.wo.relativenumber = false

-- Mark cursor line
vim.wo.cursorline = true

-- Ignore files in command line
vim.o.wildignore = '*.o,*.rej,*.so'

-- So status is not shown twice
vim.o.showmode = false


-- Undotree takes up half the screen
vim.g.undotree_SplitWidth = math.ceil(vim.o.columns / 2)

-- Prompt to save on :q with unsaved changes instead of erroring
vim.o.confirm = true

-- Scroll by screen-row on wrapped lines
vim.o.smoothscroll = true

-- Automatically check if a file has changed outside of Neovim and reload it
vim.o.autoread = true

vim.cmd([[
  autocmd FocusGained,BufEnter,CursorHold * checktime
]])

vim.cmd([[
  autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
]])

-- Briefly highlight the yanked region
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
})

-- Restore last cursor position when reopening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- LaTeX: turn off auto-indenting that fights with \begin/\end blocks
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
