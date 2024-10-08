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
local normal_mappings = {
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
  }


require('which-key').add(normal_mappings, { mode = "n" })

--------------------------------------------------------------------------
-- BUFFER KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>bc', ':bd<CR>', { noremap = true, silent = true, desc = 'Close buffer (Ctrl-x)' })
vim.keymap.set('n', '<C-x>', ':bd<CR>', { noremap = true, silent = true, desc = 'Close buffer' })
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
vim.keymap.set({"n", "v"}, '<A-h>', ':bprevious<CR>', {noremap = true, silent = true})
vim.keymap.set({"n", "v"}, '<A-l>', ':bnext<CR>', {noremap = true, silent = true})
vim.keymap.set({"n", "v"}, '<C-h>', ':bprevious<CR>', {noremap = true, silent = true})
vim.keymap.set({"n", "v"}, '<C-l>', ':bnext<CR>', {noremap = true, silent = true})


--------------------------------------------------------------------------
-- TELESCOPE KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set('n', '<space>fb', function()
  require('telescope').extensions.file_browser.file_browser({
    path = vim.fn.expand('%:p:h'),
    select_buffer = true
  })
end, { noremap = true, silent = true, desc = 'Browser' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Files' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = 'Word' })
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
    use_fd = false,  -- Use 'find' instead of 'fd'
    cwd = '.',       -- Set current directory
    find_command = { 'find', '.', '-type', 'f', '-or', '-type', 'l', '-print' },
  })
end, { desc = 'Browse files' })


--------------------------------------------------------------------------
-- CODE KEYMAPS (requires LSP, telescope)
--------------------------------------------------------------------------
vim.keymap.set('n', '<leader>cd', require('telescope.builtin').lsp_definitions, { desc = 'Goto definition (gd)' })
vim.keymap.set('n', '<leader>cr', require('telescope.builtin').lsp_references, { desc = 'Goto references (gr)' })
vim.keymap.set('n', '<leader>ci', require('telescope.builtin').lsp_implementations, { desc = 'Goto implementation (gi)' })
vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, { desc = 'Hover documentation (gh)' })
vim.keymap.set('n', '<leader>cs', vim.lsp.buf.signature_help, { desc = 'Signature documentation (gk)' })
-- non leader ones...
vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'Goto definition' })
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'Goto references' })
vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'go', vim.lsp.buf.hover, { desc = 'Hover documentation' })
vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { desc = 'Signature documentation' })
-- diagnostic keymaps
vim.keymap.set('n', '<leader>gp', vim.diagnostic.goto_prev, { desc = 'Previous message' })
vim.keymap.set('n', '<leader>gn', vim.diagnostic.goto_next, { desc = 'Next message' })
vim.keymap.set('n', '<leader>gf', vim.diagnostic.open_float, { desc = 'Floating diagnostic message' })
vim.keymap.set('n', '<leader>gl', vim.diagnostic.setloclist, { desc = 'List' })

vim.keymap.set('n', '<leader>cn', vim.lsp.buf.rename, { desc = 'Rename symbol' })

-- Keymap to run :retab!
vim.keymap.set('n', '<leader>ct', ':retab!<CR>', { desc = ':retab!' })

-- Keymap to show invisible characters (like tabs and trailing spaces)
vim.keymap.set('n', '<leader>cc', require('functions').toggle_chars, { desc = 'Toggle invisible characters' })

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
vim.keymap.set("n", "<leader>db", ":PBToggleBreakpoint<CR>", { noremap = true, silent = true, desc = "Toggle a breakpoint" })
vim.keymap.set("n", "<leader>dB", ":PBSetConditionalBreakpoint<CR>", { noremap = true, silent = true, desc = "Conditional brealpoint" })
vim.keymap.set('n', '<leader>dr', dap.continue, { noremap = true, silent = true, desc = 'Run/Continue debugging (C-c)' })
vim.keymap.set('n', '<leader>do', dap.step_over, { noremap = true, silent = true, desc = 'Step over (C-o)' })
vim.keymap.set('n', '<leader>di', dap.step_into, { noremap = true, silent = true, desc = 'Step into (C-i)' })
vim.keymap.set('n', '<leader>du', dap.step_out, { noremap = true, silent = true, desc = 'Step out (C-u)' })

-- Create a keymap to disconnect debugger and close DAP UI
vim.keymap.set('n', '<leader>dq (C-q)', function()
  require('dap').terminate()  -- Terminate the debugging session
  require('dapui').close()    -- Close the DAP UI
end, { noremap = true, silent = true, desc = 'Quit debugger' })


-- Function to check if the debugger is active
local function is_debugging()
  return dap.session() ~= nil  -- Returns true if a debugging session is active
end

-- Create a conditional keymap function
local function conditional_keymap(mode, key, command, options)
  options = options or { noremap = true, silent = true }
  
  -- Wrap the command with a check for active debugging
  vim.keymap.set(mode, key, function()
    if is_debugging() then
      command()  -- Execute the command if debugging is active
    else
      print("Debugger is not running")  -- Optionally notify if not debugging
    end
  end, options)
end

-- Example: Set keymaps that only work when the debugger is active
conditional_keymap('n', '<C-c>', dap.continue, { desc = 'Continue debugging' })
conditional_keymap('n', '<C-o>', dap.step_over, { desc = 'Step over' })
conditional_keymap('n', '<C-i>', dap.step_into, { desc = 'Step into' })
conditional_keymap('n', '<C-u>', dap.step_out, { desc = 'Step out' })
conditional_keymap('n', '<C-q>', function()
  dap.terminate()
  require('dapui').close()
end, { desc = 'Quit debugger' })


--------------------------------------------------------------------------
-- AERIAL KEYMAPS
--------------------------------------------------------------------------
vim.keymap.set({'n', 'v', 'i'}, '<C-a>', function() require('aerial').toggle() end, { desc = 'Aerial toggle' })
vim.keymap.set({'n', 'v', 'i'}, '<C-j>', function() require('aerial').next() end, { desc = 'Aerial next' })
vim.keymap.set({'n', 'v', 'i'}, '<C-k>', function() require('aerial').prev() end, { desc = 'Aerial previous' })


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
vim.keymap.set('n', '<leader>n', functions.reload_lua_config, { noremap = true, silent = true, desc = 'Reload nvim config' })
vim.keymap.set('n', '<leader>h', require('functions').open_myhelp_popup, { noremap = true, silent = true, desc = 'Help/Tips' })
vim.keymap.set('n', '<leader>t', require('functions').terminal_here, { noremap = true, silent = true, desc = 'Terminal here' })
vim.keymap.set('t', '<C-q>', require('functions').terminal_close, { noremap = true, silent = true, desc = 'Close terminal split' })

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
