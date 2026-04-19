-- Set <space> as the leader key
--	NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager, lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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

-- require these ones
require('plugins')
require('options')
require('keymaps')
require('scrollbar').setup()
require('last_edit').setup()

-- Copy :messages output to the system clipboard.
vim.api.nvim_create_user_command("CopyMessages", function()
  vim.cmd("redir @+ | silent messages | redir END")
  vim.notify("Messages copied to clipboard")
end, { desc = "Copy :messages output to system clipboard" })
