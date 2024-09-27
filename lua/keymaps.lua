local functions = require('functions')
--------------------------------------------------------------------------
-- BEHAVIOUR
--------------------------------------------------------------------------
-- lets override vims weird register switching when pasting in visual mode...
vim.keymap.set("x", "p", function() return 'pgv"' .. vim.v.register .. "y" end, { remap = false, expr = true })

-- ..and dont yank on x
vim.keymap.set({"n", "v"}, "x", '"_x', { noremap = true })

-- don't yank on <C-d>/<C-dd>
vim.keymap.set({"v"}, "<C-d>", '"_d', { noremap = true })
vim.keymap.set("n", "<C-d><C-d>", '"_dd', { noremap = true })

-- remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- remap ; to : in normal mode
vim.keymap.set('n', ';', ':', { noremap = true })
--------------------------------------------------------------------------
-- TEXT NAVIGATION
--------------------------------------------------------------------------
vim.keymap.set({"n", "v"}, "J", "10j", { noremap = true })
vim.keymap.set({"n", "v"}, "K", "10k", { noremap = true })
vim.keymap.set({"n", "v", "o"}, "H", "^", { noremap = true })
vim.keymap.set({"n", "v", "o"}, "L", "$", { noremap = true })
-- use hop
vim.keymap.set('n', '<C-o>', require'hop'.hint_char1, { noremap = true, silent = true, desc = 'Hop to char' })


--------------------------------------------------------------------------
-- TAB INDENTATION...
--------------------------------------------------------------------------
-- indent with tab
vim.keymap.set('v', '<Tab>', '>gv', { noremap = true, silent = true, desc = 'Indent and reselect in visual mode' })
vim.keymap.set('v', '<S-Tab>', '<gv', { noremap = true, silent = true, desc = 'Unindent and reselect in visual mode' })
-- make these behave
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true, desc = 'Unindent and reselect in visual mode' })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true, desc = 'Indent and reselect in visual mode' })


--------------------------------------------------------------------------
-- WHICH-KEY SETTINGS (FANCY HELPER FOR <LEADER>)
--------------------------------------------------------------------------
-- Genvägar tillgängliga i normalt läge
local normal_mappings = {
--	['<leader>a'] = { name = '[a]eral', _ = 'which_key_ignore' },
	['<leader>b'] = { name = '[b]buffer', _ = 'which_key_ignore' },
	['<leader>c'] = { name = '[c]ode', _ = 'which_key_ignore' },
	['<leader>d'] = { name = '[d]iagnostics', _ = 'which_key_ignore' },
	['<leader>f'] = { name = '[f]ind', _ = 'which_key_ignore' },
	['<leader>p'] = { name = '[p]ersistence', _ = 'which_key_ignore' },
--	['<leader>w'] = { name = '[w]orkspace', _ = 'which_key_ignore' },
}

-- Registrera för normalt läge
require('which-key').register(normal_mappings, { mode = "n" })

--------------------------------------------------------------------------
-- BUFFER KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>bc', ':bd<CR>', { noremap = true, silent = true, desc = '[c]lose buffer (Ctrl-x)' })
vim.keymap.set('n', '<C-x>', ':bd<CR>', { noremap = true, silent = true, desc = 'Close buffer' })
vim.keymap.set('n', '<leader>bn', ':enew<CR>', { noremap = true, silent = true, desc = '[n]ew buffer' })
vim.keymap.set('n', '<leader>bh', ':new<CR>', { noremap = true, silent = true, desc = '[h]orizontal split with new buffer' })
vim.keymap.set('n', '<leader>bv', ':vnew<CR>', { noremap = true, silent = true, desc = '[v]ertical split with new buffer' })
vim.keymap.set('n', 'gh', '<C-w>h', {desc = 'Move to left split'})
vim.keymap.set('n', 'gj', '<C-w>j', {desc = 'Move to lower split'})
vim.keymap.set('n', 'gk', '<C-w>k', {desc = 'Move to upper split'})
vim.keymap.set('n', 'gl', '<C-w>l', {desc = 'Move to right split'})
-- vim.keymap.set('n', '<A-C-h>', ':vertical resize -2<CR>', {desc = 'Decrease width'})
-- vim.keymap.set('n', '<A-C-l>', ':vertical resize +2<CR>', {desc = 'Increase width'})
-- vim.keymap.set('n', '<A-C-j>', ':resize +2<CR>', {desc = 'Increase height'})
-- vim.keymap.set('n', '<A-C-k>', ':resize -2<CR>', {desc = 'Decrease height'})
vim.keymap.set('n', '<C-h>', ':bprevious<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<C-l>', ':bnext<CR>', {noremap = true, silent = true})


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

vim.keymap.set('n', '<leader>/', functions.search_in_current_buffer, { desc = 'fuzzily buffer search (Ctrl-f)' })
vim.keymap.set('n', '<C-f>', functions.search_in_current_buffer, { desc = 'fuzzily buffer search' })

vim.keymap.set('n', '<leader>.', require('telescope').extensions.file_browser.file_browser, { desc = 'Browse files' })
vim.keymap.set('n', '<leader>,', function()
  require('telescope').extensions.file_browser.file_browser({
    hidden = true,
    respect_gitignore = false,
    use_fd = false,  -- Använd 'find' istället för 'fd'
    cwd = '.',       -- Sätt nuvarande katalog
    find_command = { 'find', '.', '-type', 'f', '-or', '-type', 'l', '-print' },
  })
end)


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
vim.keymap.set('n', 'go', vim.lsp.buf.hover, { desc = 'hover d[o]cumentation' })
vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { desc = '[s]ignature documentation' })
-- diagnostic keymaps
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = '[p]revious message' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = '[n]ext message' })
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = '[f]loating diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = '[l]ist' })

vim.keymap.set('n', '<leader>rs', vim.lsp.buf.rename, { desc = '[r]ename [s]ymbol' })
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
vim.keymap.set('n', '<C-a>', function() require('aerial').toggle() end, { desc = 'aerial toggle' })
vim.keymap.set('n', '<C-j>', function() require('aerial').next() end, { desc = 'aerial next' })
vim.keymap.set('n', '<C-k>', function() require('aerial').prev() end, { desc = 'aerial previous' })


--------------------------------------------------------------------------
-- PERSISTENCE KEYMAPS
--------------------------------------------------------------------------
-- restore the session for the current directory
vim.keymap.set("n", "<leader>ps", [[<cmd>lua require("persistence").load()<cr>]], { desc = "Load session" })
vim.keymap.set("n", "<leader>pl", [[<cmd>lua require("persistence").load({ last = true })<cr>]], { desc = "Load last session" })
vim.keymap.set("n", "<leader>pd", [[<cmd>lua require("persistence").stop()<cr>]], { desc = "Stop persistence" })


--------------------------------------------------------------------------
-- MULTI CURSOR KEYMAPS
--------------------------------------------------------------------------
-- vim.keymap.set('n', '<leader>m', ':MCstart<CR>', { noremap = true, silent = true, desc = '[m]ulti cursor' })
-- vim.keymap.set('v', '<leader>m', ':MCstart<CR>', { noremap = true, silent = true, desc = '[m]ulti cursor' })
--------------------------------------------------------------------------
-- MISC FUNCTIONS (defined in functions.lua) KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>n', functions.reload_lua_config, { noremap = true, silent = true, desc = 'reload [n]vim config' })
vim.keymap.set('n', '<leader>h', require('functions').open_myhelp_popup, { noremap = true, silent = true, desc = 'Help/Tips' })
vim.keymap.set('n', '<leader>t', require('functions').toggle_theme, { noremap = true, silent = true, desc = 'Toggle theme' })

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
