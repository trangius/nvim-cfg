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

-- Inside sidebar buffers, `:q` means "quit nvim" (not "close this sidebar").
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"aerial", "neo-tree"},
  callback = function()
    vim.cmd("cabbrev <buffer> q qa")
  end,
})


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
