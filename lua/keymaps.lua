local functions = require('functions')
--------------------------------------------------------------------------
-- BEHAVIOUR
--------------------------------------------------------------------------
-- lets override vims weird register switching when pasting in visual mode...
vim.keymap.set("x", "p", function() return 'pgv"' .. vim.v.register .. "y" end, { remap = false, expr = true })

-- ..and dont yank on x
vim.keymap.set("n", "x", '"_x', { noremap = true })
vim.keymap.set("v", "x", '"_x', { noremap = true })

-- don't yank on <leader>d
vim.keymap.set("n", "<leader>d", '"_d', { noremap = true })
vim.keymap.set("v", "<leader>d", '"_d', { noremap = true })

-- remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


--------------------------------------------------------------------------
-- TEXT NAVIGATION
--------------------------------------------------------------------------
vim.keymap.set("n", "J", "10j", { noremap = true })
vim.keymap.set("v", "J", "10j", { noremap = true })
vim.keymap.set("n", "K", "10k", { noremap = true })
vim.keymap.set("v", "K", "10k", { noremap = true })
vim.keymap.set("n", "H", "0", { noremap = true })
vim.keymap.set("v", "H", "0", { noremap = true })
vim.keymap.set("n", "L", "$", { noremap = true })
vim.keymap.set("v", "L", "$", { noremap = true })
-- use hop
vim.api.nvim_set_keymap('n', '<C-o>', "<cmd>lua require'hop'.hint_char1()<cr>", {noremap = true, silent = true})

--------------------------------------------------------------------------
-- TAB INDENTATION...
--------------------------------------------------------------------------
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<lt>Tab>', '<gv', {noremap = true, silent = true})
-- ...and make these behave
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true })



--------------------------------------------------------------------------
-- WHICH-KEY SETTINGS (FANCY HELPER FOR <LEADER>)
--------------------------------------------------------------------------
require('which-key').register {
--	['<leader>a'] = { name = '[a]eral', _ = 'which_key_ignore' },
	['<leader>b'] = { name = '[b]buffer',_ = 'which_key_ignore' },
	['<leader>c'] = { name = '[c]ode', _ = 'which_key_ignore' },
	['<leader>d'] = { name = '[d]iagnostics', _ = 'which_key_ignore' },
	['<leader>f'] = { name = '[f]ind', _ = 'which_key_ignore' },
	['<leader>p'] = { name = '[p]ersistence', _ = 'which_key_ignore' },
	['<leader>r'] = { name = 'search & [r]eplace', _ = 'which_key_ignore' },
--	['<leader>w'] = { name = '[w]orkspace', _ = 'which_key_ignore' },
}


--------------------------------------------------------------------------
-- BUFFER KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>bc', ':bd<CR>', { noremap = true, silent = true, desc = '[c]lose buffer (Ctrl-x)' })
vim.keymap.set('n', '<C-x>', ':bd<CR>', { noremap = true, silent = true, desc = 'Close buffer' })
vim.keymap.set('n', '<leader>bn', ':enew<CR>', { noremap = true, silent = true, desc = '[n]ew buffer' })
vim.keymap.set('n', '<leader>bh', ':new<CR>', { noremap = true, silent = true, desc = '[h]orizontal split with new buffer' })
vim.keymap.set('n', '<leader>bv', ':vnew<CR>', { noremap = true, silent = true, desc = '[v]ertical split with new buffer' })
vim.keymap.set('n', '<leader>h', '<C-w>h', {desc = 'Move to left split'})
vim.keymap.set('n', '<leader>j', '<C-w>j', {desc = 'Move to lower split'})
vim.keymap.set('n', '<leader>k', '<C-w>k', {desc = 'Move to upper split'})
vim.keymap.set('n', '<leader>l', '<C-w>l', {desc = 'Move to right split'})
-- vim.keymap.set('n', '<A-C-h>', ':vertical resize -2<CR>', {desc = 'Decrease width'})
-- vim.keymap.set('n', '<A-C-l>', ':vertical resize +2<CR>', {desc = 'Increase width'})
-- vim.keymap.set('n', '<A-C-j>', ':resize +2<CR>', {desc = 'Increase height'})
-- vim.keymap.set('n', '<A-C-k>', ':resize -2<CR>', {desc = 'Decrease height'})
vim.keymap.set('n', '<A-h>', ':bprevious<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<A-l>', ':bnext<CR>', {noremap = true, silent = true})


--------------------------------------------------------------------------
-- TELESCOPE KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set('n', '<space>fb', function()
  require('telescope').extensions.file_browser.file_browser({
    path = vim.fn.expand('%:p:h'),
    select_buffer = true
  })
end, { noremap = true, silent = true, desc = 'browser' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[f]iles' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[w]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[g]rep' })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').grep_string, { desc = '[s]tring (under cursor)' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[d]iagnostics' })
vim.keymap.set('n', '<leader>fe', require('telescope.builtin').resume, { desc = 'r[e]sume' })
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').git_files, { desc = 'gi[t] files' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = '[r]ecently opened files' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'find existing [b]uffers' })
vim.keymap.set('n', '<C-b>', require('telescope.builtin').buffers, { desc = 'find existing b[u]ffers' })
vim.keymap.set('n', '<leader><leader>', require('telescope.builtin').find_files, { desc = 'find file' })
--vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'help' })

vim.keymap.set('n', '<leader>/', functions.search_in_current_buffer, { desc = 'fuzzily search in current buffer (Ctrl-f)' })
vim.keymap.set('n', '<C-f>', functions.search_in_current_buffer, { desc = 'fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>.', require('telescope').extensions.file_browser.file_browser, { desc = 'Browse files' })
vim.keymap.set('n', '<leader>,', function()
	require('telescope').extensions.file_browser.file_browser({
		hidden = true, -- show hidden
		respect_gitignore = false,})
end, {desc = 'Browse files (show all)'})


--------------------------------------------------------------------------
-- Spectre search/replace
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>rr', require('spectre').toggle, { desc = 'toggle spect[r]e' })
vim.keymap.set('n', '<leader>rw', function() require('spectre').open_visual({select_word=true}) end, { desc = "Replace current [w]ord" })
vim.keymap.set('n', '<leader>rf', function() require('spectre').open_file_search({select_word=true}) end, { desc = "Replace in current [f]ile" })
vim.keymap.set('v', '<leader>rw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
--------------------------------------------------------------------------
-- CODE KEYMAPS (requires LSP, telescope)
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>cd', require('telescope.builtin').lsp_definitions, { desc = 'goto [d]efinition (gd)' })
vim.keymap.set('n', '<leader>cr', require('telescope.builtin').lsp_references, { desc = 'goto [r]eferences (gr)' })
vim.keymap.set('n', '<leader>ci', require('telescope.builtin').lsp_implementations, { desc = 'goto [i]mplementation (gi)' })
vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, { desc = '[h]over documentation (gh)' })
vim.keymap.set('n', '<leader>cs', vim.lsp.buf.signature_help, { desc = '[s]ignature documentation (gk)' })
-- non leader ones... do we need these?
vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'goto definition' })
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'goto references' })
vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, { desc = 'goto Implementation' })
vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { desc = '[h]over documentation' })
vim.keymap.set('n', 'gk', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })
-- diagnostic keymaps
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = '[p]revious message' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = '[n]ext message' })
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = '[f]loating diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = '[l]ist' })

-- workspace stuff, would we ever care about this?
--vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = 'symbols' })
--vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'add folder' })
--vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'remove Folder' })
--vim.keymap.set('n', '<leader>wl', function()
--	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--end, { desc = 'list folders' })


--------------------------------------------------------------------------
-- AERAL KEYMAPS
--------------------------------------------------------------------------
--vim.keymap.set('n', '<leader>a', function() require('aerial').toggle() end, { desc = '[a]erial toggle (alt-a)' })
--vim.keymap.set('n', '<leader>j', function() require('aerial').next() end, { desc = '[a]erial [n]ext (alt-k)' })
--vim.keymap.set('n', '<leader>k', function() require('aerial').prev() end, { desc = '[a]erial [p]revious (alt-j)' })
vim.keymap.set('n', '<A-a>', function() require('aerial').toggle() end, { desc = 'aerial toggle' })
vim.keymap.set('n', '<A-j>', function() require('aerial').next() end, { desc = 'aerial next' })
vim.keymap.set('n', '<A-k>', function() require('aerial').prev() end, { desc = 'aerial previous' })



--------------------------------------------------------------------------
-- PERSISTENCE KEYMAPS
--------------------------------------------------------------------------
-- restore the session for the current directory
vim.keymap.set("n", "<leader>ps", [[<cmd>lua require("persistence").load()<cr>]], { desc = "Load session" })
vim.keymap.set("n", "<leader>pl", [[<cmd>lua require("persistence").load({ last = true })<cr>]], { desc = "Load last session" })
vim.keymap.set("n", "<leader>pd", [[<cmd>lua require("persistence").stop()<cr>]], { desc = "Stop persistence" })


--------------------------------------------------------------------------
-- MISC FUNCTIONS (defined in functions.lua) KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>n', functions.reload_lua_config, { noremap = true, silent = true, desc = 'reload [n]vim config' })
vim.api.nvim_set_keymap('n', '<C-m>', ':lua require("functions").open_myhelp_popup()<CR>', {noremap = true, silent = true})


--------------------------------------------------------------------------
-- FIX COMMON TYPOS
--------------------------------------------------------------------------
vim.cmd([[
    cnoreabbrev W! w!
    cnoreabbrev W1 w!
    cnoreabbrev w1 w!
    cnoreabbrev Q! q!
    cnoreabbrev Q1 q!
    cnoreabbrev q1 q!
    cnoreabbrev Qa! qa!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wa wa
    cnoreabbrev Wq wq
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev wq1 wq!
    cnoreabbrev Wq1 wq!
    cnoreabbrev wQ1 wq!
    cnoreabbrev WQ1 wq!
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qa qa
    cnoreabbrev Qall qall
]])
