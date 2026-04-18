local functions = require('functions')
--------------------------------------------------------------------------
-- BEHAVIOUR
--------------------------------------------------------------------------
-- lets override vims weird register switching when pasting in visual mode...
vim.keymap.set("x", "p", function() return 'pgv"' .. vim.v.register .. "y" end, { remap = false, expr = true })

-- remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- remap ; to : in normal mode
vim.keymap.set('n', ';', ':', { noremap = true })

-- move line
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- redo also on alt+r
vim.keymap.set('n', '<A-r>', '<C-r>', { noremap = true, silent = true, desc = 'Redo (same as Ctrl-r)' })
--------------------------------------------------------------------------
-- YANKING
--------------------------------------------------------------------------
-- yank into separate registers on x, c
vim.keymap.set({"n", "v"}, "x", '"xx', { noremap = true })

-- Yank into separate register on change commands
vim.keymap.set({"n", "v"}, "c", '"cc', { noremap = true })
vim.keymap.set("n", "cc", '"ccc', { noremap = true })
vim.keymap.set("n", "ci", '"cci', { noremap = true })
vim.keymap.set("n", "cw", '"ccw', { noremap = true })
vim.keymap.set("n", "cW", '"ccW', { noremap = true })
vim.keymap.set("n", "ct", '"cct', { noremap = true })
vim.keymap.set("n", "cf", '"ccf', { noremap = true })

-- don't yank on <C-d>/<C-dd>
vim.keymap.set({"v"}, "<C-d>", '"dd', { noremap = true })
vim.keymap.set("n", "<C-d><C-d>", '"ddd', { noremap = true })


--------------------------------------------------------------------------
-- TEXT NAVIGATION
--------------------------------------------------------------------------
-- prevent the default LSP K mapping:
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    pcall(vim.keymap.del, 'n', 'K', { buffer = args.buf })
    -- Re-add your custom K mapping for this buffer
    vim.keymap.set({"n", "v"}, "K", "10k", { noremap = true, silent = true, buffer = args.buf })
  end,
})


vim.keymap.set({"n", "v"}, "K", "10k", { noremap = true })
vim.keymap.set({"n", "v"}, "J", "10j", { noremap = true })
vim.keymap.set({"n", "v", "o"}, "H", "^", { noremap = true })
vim.keymap.set({"n", "v", "o"}, "L", "$", { noremap = true })
-- use hop
vim.keymap.set('n', '<C-h>', require'hop'.hint_char1, { noremap = true, silent = true, desc = 'Hop to char' })


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
local normal_mappings = {
    -- Grouped prefixes (have sub-keys underneath)
    { "<leader>b", group = "Buffer" },
    { "<leader>b_", hidden = true },
    { "<leader>c", group = "Code" },
    { "<leader>c_", hidden = true },
    { "<leader>g", group = "Diagnostics" },
    { "<leader>g_", hidden = true },
    { "<leader>d", group = "Debug" },
    { "<leader>d_", hidden = true },
    { "<leader>f", group = "Find" },
    { "<leader>f_", hidden = true },
    { "<leader>p", group = "Persistence" },
    { "<leader>p_", hidden = true },
    { "<leader>l", group = "Latex" },
    { "<leader>l_", hidden = true },
    -- Standalone leader keys (labels just for the which-key popup)
    { "<leader>a",        desc = "Focus aerial (symbol outline)" },
    { "<leader>e",        desc = "Focus file tree" },
    { "<leader>h",        desc = "Help / tips" },
    { "<leader>q",        desc = "Smart quit (all)" },
    { "<leader>t",        desc = "Terminal here" },
    { "<leader>r",        desc = "Reload config" },
    { "<leader>/",        desc = "Buffer fuzzy search" },
    { "<leader>.",        desc = "Browse files" },
    { "<leader>,",        desc = "Browse files (incl. hidden)" },
    { "<leader><leader>", desc = "Find file" },
  }


require('which-key').add(normal_mappings, { mode = "n" })

--------------------------------------------------------------------------
-- BUFFER KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>bu', vim.cmd.UndotreeToggle, { noremap = true, silent = true, desc = 'Undo tree' })
vim.keymap.set({'n', 'v'}, '<leader>bc', require('functions').buffer_close_with_aerial, { noremap = true, silent = true, desc = 'Close buffer (C-x)' })
vim.keymap.set({'n', 'v'}, '<C-x>', require('functions').buffer_close_with_aerial, { noremap = true, silent = true, desc = 'Close buffer (C-x)' })
vim.keymap.set('n', '<leader>bn', ':enew<CR>', { noremap = true, silent = true, desc = 'New buffer' })
vim.keymap.set('n', '<leader>bh', ':new<CR>', { noremap = true, silent = true, desc = 'Horizontal split with new buffer' })
vim.keymap.set('n', '<leader>bv', ':vnew<CR>', { noremap = true, silent = true, desc = 'Vertical split with new buffer' })
vim.keymap.set('n', 'gh', '<C-w>h', {desc = 'Move to left split'})
vim.keymap.set('n', 'gj', '<C-w>j', {desc = 'Move to lower split'})
vim.keymap.set('n', 'gk', '<C-w>k', {desc = 'Move to upper split'})
vim.keymap.set('n', 'gl', '<C-w>l', {desc = 'Move to right split'})
vim.keymap.set('n', '<A-C-h>', ':vertical resize -2<CR>', {desc = 'Decrease width'})
vim.keymap.set('n', '<A-C-l>', ':vertical resize +2<CR>', {desc = 'Increase width'})
vim.keymap.set('n', '<A-C-j>', ':resize +2<CR>', {desc = 'Increase height'})
vim.keymap.set('n', '<A-C-k>', ':resize -2<CR>', {desc = 'Decrease height'})
vim.keymap.set({"n", "v"}, 'T', ':bprevious<CR>', {noremap = true, silent = true})
vim.keymap.set({"n", "v"}, 't', ':bnext<CR>', {noremap = true, silent = true})


--------------------------------------------------------------------------
-- TELESCOPE KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Files' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').grep_string, { desc = 'String (under cursor)' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>fe', require('telescope.builtin').resume, { desc = 'Resume' })
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').git_files, { desc = 'Git files' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = 'Recently opened files' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<C-b>', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader><leader>', require('telescope.builtin').find_files, { desc = 'Find file' })
--vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Help' })

vim.keymap.set('n', '<leader>/', functions.search_in_current_buffer, { desc = 'Fuzzily buffer search (Ctrl-f)' })
vim.keymap.set('n', '<C-f>', functions.search_in_current_buffer, { desc = 'Fuzzily buffer search' })

vim.keymap.set('n', '<leader>.', require('telescope').extensions.file_browser.file_browser, { desc = 'Browse files' })
vim.keymap.set('n', '<leader>,', function()
  require('telescope').extensions.file_browser.file_browser({
    hidden = true,
    respect_gitignore = false,
    file_ignore_patterns = {},
    use_fd = false,
    cwd = '.',
  })
end, { desc = 'Browse files' })


--------------------------------------------------------------------------
-- CODE KEYMAPS (requires LSP, telescope)
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>cd', require('telescope.builtin').lsp_definitions, { desc = 'Goto definition (gd)' })
vim.keymap.set('n', '<leader>cf', require('telescope.builtin').lsp_references, { desc = 'Goto references (gr)' })
vim.keymap.set('n', '<leader>ci', require('telescope.builtin').lsp_implementations, { desc = 'Goto implementation (gi)' })
vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, { desc = 'Hover documentation (go)' })
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename symbol (F2)' })
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { desc = 'Rename symbol (F2)' })
vim.keymap.set('n', '<leader>ct', ':retab!<CR>', { desc = ':retab!' })
vim.keymap.set('n', '<leader>cc', require('functions').toggle_chars, { desc = 'Toggle invisible characters' })
-- non leader ones...
vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'Goto definition' })
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'Goto references' })
vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'go', vim.lsp.buf.hover, { desc = 'Hover documentation' })
-- diagnostic keymaps
vim.keymap.set('n', '<leader>gp', vim.diagnostic.goto_prev, { desc = 'Previous message' })
vim.keymap.set('n', '<leader>gn', vim.diagnostic.goto_next, { desc = 'Next message' })
vim.keymap.set('n', '<leader>gf', vim.diagnostic.open_float, { desc = 'Floating diagnostic message' })
vim.keymap.set('n', '<leader>gl', vim.diagnostic.setloclist, { desc = 'List' })
vim.keymap.set('n', '<leader>gt', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Toggle trouble panel' })

-- workspace stuff, would we ever care about this?
--vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = 'Symbols' })
--vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Add folder' })
--vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Remove Folder' })
--vim.keymap.set('n', '<leader>wl', function()
--	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--end, { desc = 'List folders' })

--------------------------------------------------------------------------
-- DEBUGGER KEYMAPS (requires dap)
--------------------------------------------------------------------------
local dap = require('dap')

-- Breakpoint toggles always make sense (whether or not a session is running).
vim.keymap.set("n", "<leader>db", ":PBToggleBreakpoint<CR>", { noremap = true, silent = true, desc = "Toggle a breakpoint" })
vim.keymap.set("n", "<leader>dB", ":PBSetConditionalBreakpoint<CR>", { noremap = true, silent = true, desc = "Conditional breakpoint" })

-- Stepping/quit keys only do something while debugging; wrap them so we print
-- "Debugger is not running" instead of throwing dap errors.
local function is_debugging() return dap.session() ~= nil end

local function conditional_keymap(mode, key, command, options)
  options = options or { noremap = true, silent = true }
  vim.keymap.set(mode, key, function()
    if is_debugging() then
      command()
    else
      print("Debugger is not running")
    end
  end, options)
end

local function quit_debugger()
  dap.terminate()
  require('dapui').close()
end

-- `<leader>d*` is the "intentional" debug menu; `<C-*>` is the quick chord.
-- Both go through conditional_keymap so they share the same "not running"
-- behaviour.
conditional_keymap('n', '<leader>dr', dap.continue,   { desc = 'Run/Continue debugging (C-c)' })
conditional_keymap('n', '<leader>do', dap.step_over,  { desc = 'Step over (C-o)' })
conditional_keymap('n', '<leader>di', dap.step_into,  { desc = 'Step into (C-i)' })
conditional_keymap('n', '<leader>du', dap.step_out,   { desc = 'Step out (C-u)' })
conditional_keymap('n', '<leader>dq', quit_debugger,  { desc = 'Quit debugger (C-q)' })
conditional_keymap('n', '<C-c>',      dap.continue,   { desc = 'Continue debugging' })
conditional_keymap('n', '<C-o>',      dap.step_over,  { desc = 'Step over' })
conditional_keymap('n', '<C-i>',      dap.step_into,  { desc = 'Step into' })
conditional_keymap('n', '<C-u>',      dap.step_out,   { desc = 'Step out' })
conditional_keymap('n', '<C-q>',      quit_debugger,  { desc = 'Quit debugger' })


--------------------------------------------------------------------------
-- AERIAL KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set({'n', 'v'}, '<leader>a', function()
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == 'aerial' then
      vim.api.nvim_set_current_win(w)
      return
    end
  end
  require('aerial').open({ focus = true })
end, { desc = 'Focus aerial (open if needed)' })
vim.keymap.set({'n', 'v', 'i'}, '<C-j>', function() require('aerial').next() end, { desc = 'Aerial next' })
vim.keymap.set({'n', 'v', 'i'}, '<C-k>', function() require('aerial').prev() end, { desc = 'Aerial previous' })


--------------------------------------------------------------------------
-- NEO-TREE KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>e', '<cmd>Neotree focus<CR>', { desc = 'Focus file tree (open if needed)' })
vim.keymap.set('n', '<leader>fl', '<cmd>Neotree reveal<CR>', { desc = 'Reveal current file in tree' })


--------------------------------------------------------------------------
-- PERSISTENCE KEYMAPS
--------------------------------------------------------------------------
-- restore the session for the current directory
vim.keymap.set("n", "<leader>pl", [[<cmd>lua require("persistence").load()<cr>]], { desc = "Load lasts local session (current directory)" })
vim.keymap.set("n", "<leader>pg", [[<cmd>lua require("persistence").load({ last = true })<cr>]], { desc = "Load last global session" })
vim.keymap.set("n", "<leader>pd", [[<cmd>lua require("persistence").stop()<cr>]], { desc = "Stop persistence" })


--------------------------------------------------------------------------
-- LATEX KEYMAPS
--------------------------------------------------------------------------
-- normal
vim.keymap.set('n', '<leader>lc', 'i\\begin{csharp}[caption={},label={}]<CR>\\end{csharp}<CR><ESC>k', { desc = 'Insert C# block' })
vim.keymap.set('n', '<leader>lp', 'i\\begin{pseudo}[caption={},label={}]<CR>\\end{pseudo}<CR><ESC>k', { desc = 'Insert pseudo code block' })
vim.keymap.set('n', '<leader>lt', 'i\\begin{console}[caption={},label={}]<CR>\\end{console}<CR><ESC>k', { desc = 'Insert terminal/console block' })
vim.keymap.set('n', '<leader>lh', 'i\\boxteknisk{<CR>}<CR><ESC>k', { desc = 'Insert technical box' })
vim.keymap.set('n', '<leader>ll', 'i\\boxlinks{<CR>}<CR><ESC>k', { desc = 'Insert link box' })

vim.keymap.set('n', '<leader>lw', 'a\\cw{}<ESC>i', { desc = 'Insert inline code' })
vim.keymap.set('n', '<leader>lk', 'a\\chapter{}<ESC>i', { desc = 'Insert chapter' })
vim.keymap.set('n', '<leader>ls', 'a\\section{}<ESC>i', { desc = 'Insert section' })
vim.keymap.set('n', '<leader>le', 'a\\emph{}<ESC>i', { desc = 'Insert emphasis' })
vim.keymap.set('n', '<leader>l-', 'a–<ESC>', { desc = 'Insert – symbol' })

vim.keymap.set('v', '<leader>lt', 'di\\boxteknisk{<CR>}<CR><ESC>kP', { desc = 'Insert technical box' })
vim.keymap.set('v', '<leader>ll', 'di\\boxlinks{<CR>}<CR><ESC>kP', { desc = 'Insert link box' })

vim.keymap.set('v', '<leader>lk', 'di\\chapter{}<ESC>P', { desc = 'Insert chapter' })
vim.keymap.set('v', '<leader>ls', 'di\\section{}<ESC>P', { desc = 'Insert section' })
vim.keymap.set('v', '<leader>le', 'di\\emph{}<ESC>P', { desc = 'Insert emphasis' })
vim.keymap.set('v', '<leader>lw', 'di\\cw{}<ESC>P', { desc = 'Insert inline code' })


vim.keymap.set('v', '<leader>li', 'c(*@\\textcolor{black}{<C-R>"}@*)<Esc>', { noremap = true, silent = true, desc = "Wrap selection with LaTeX formatting" })

vim.keymap.set('n', '<leader>lx', function()
  pcall(vim.cmd, [[%s/C\\\#/Python/g]])
  pcall(vim.cmd, [[%s/\<csharp\>/python/g]])
  pcall(vim.cmd, [[%s/\<true\>/True/g]])
  pcall(vim.cmd, [[%s/\<false\>/False/g]])
  pcall(vim.cmd, [[%s/\(\w\+\)\s*&&\s*\(\w\+\)/\1 and \2/g]])
  pcall(vim.cmd, [[%s/\(\w\+\)\s*||\s*\(\w\+\)/\1 or \2/g]])
  pcall(vim.cmd, [[%s/\<else if\>/elif/g]])
end, { desc = 'Convert C# to Python-style syntax' })


--------------------------------------------------------------------------
-- MISC FUNCTIONS (defined in functions.lua or here directley) KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>h', require('functions').open_myhelp_popup, { noremap = true, silent = true, desc = 'Help/Tips' })
vim.keymap.set('n', '<leader>q', require('functions').smart_quit, { noremap = true, silent = true, desc = 'Smart quit (all)' })
vim.keymap.set('n', '<leader>t', require('functions').terminal_here, { noremap = true, silent = true, desc = 'Terminal here' })
vim.keymap.set('t', '<C-q>', require('functions').terminal_close, { noremap = true, silent = true, desc = 'Close terminal split' })

local function reload_config()
  vim.cmd('source $MYVIMRC')
  print("Config reloaded!")
end

-- Mappar <leader>r för att reloada konfigurationen
vim.keymap.set('n', '<leader>r', reload_config, { noremap = true, silent = true, desc = 'Reload config' })



-- Move to the end of the previous line in visual mode when pressing 'h' at the beginning
vim.keymap.set('x', 'h', function()
    local col = vim.fn.col('.')
    if col == 1 then
        return 'k$'
    else
        return 'h'
    end
end, { expr = true, noremap = true })

-- Move to the beginning of the next line in visual mode when pressing 'l' at the end
vim.keymap.set('x', 'l', function()
    local col = vim.fn.col('.')
    local line_length = vim.fn.col('$') - 1 -- Last column in the current line

    if col == line_length then
        return 'j0'
    else
        return 'l'
    end
end, { expr = true, noremap = true })

-- Execute code
vim.keymap.set('n', '<F5>', functions.run_file, { noremap = true, silent = true, desc = 'Run file' })
vim.keymap.set('n', '<leader>cx', functions.run_file, { noremap = true, silent = true, desc = 'Run file' })

--------------------------------------------------------------------------
-- FIX COMMON TYPOS
--------------------------------------------------------------------------
vim.cmd([[
    cnoreabbrev W! w!
    cnoreabbrev W1 w!
    cnoreabbrev w1 w!
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
    cnoreabbrev Qa qa
    cnoreabbrev Qall qall
]])
