---------------------------------------------------------------
-- LOOK & FEEL
---------------------------------------------------------------
-- Onedark setup
require('onedark').setup {
    style = 'warm'
}
require('onedark').load()
-- Scrollbar setup
require("scrollbar").setup({
	handle = {
		color = '#5c6370', -- Adjust to match onedark's scrollbar handle color
	},
	marks = {
		Search = { color = '#98c379' }, -- Adjust to match onedark's search highlight color
		Error = { color = '#e06c75' },  -- Adjust to match onedark's error color
--		Warn = { color = '#e5c07b' }, -- Adjust to match onedark's warning color
		Info = { color = '#56b6c2' },   -- Adjust to match onedark's info color
		Hint = { color = '#c678dd' },   -- Adjust to match onedark's hint color
		Misc = { color = '#56b6c2' },   -- Adjust to match onedark's misc (like git changes) color
	},
})

-- Configure Telescope
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
	},
}

-- Enable telescope fzf native, if installed on OS (otherwise, install it)
pcall(require('telescope').load_extension, 'fzf')

-- load file browser extension for telescope
require('telescope').load_extension('file_browser')

-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})


---------------------------------------------------------------
-- CODE HELPERS
---------------------------------------------------------------
-- Configure LSP
--	This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'format current buffer with LSP' })
end


-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
-- for csharp_ls to install, we need dotnet installed
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { "lua_ls", "html", "csharp_ls", "clangd" },
    automatic_installation = true,
})

-- Enable the following language servers
--	Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--	Add any additional override configuration in the following tables. They will be passed to
--	the `settings` field of the server config. You must look up that documentation yourself.
--
--	If you want to override the default filetypes that your language server will attach to you can
--	define the property 'filetypes' to the map in question.
local servers = {
	 clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	-- tsserver = {}
    csharp_ls = {},
	html = { filetypes = { 'html', 'twig', 'hbs' } },
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}


for server, config in pairs(servers) do
    require('lspconfig')[server].setup(config)
end
-- Configure Treesitter
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
	require('nvim-treesitter.configs').setup {
		-- Add languages to be installed here that you want installed for treesitter
		ensure_installed = { 'c', 'cpp', 'c_sharp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'html' },

		-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
		auto_install = false,

		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = '<c-space>',
				node_incremental = '<c-space>',
				scope_incremental = '<c-s>',
				node_decremental = '<M-space>',
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					['aa'] = '@parameter.outer',
					['ia'] = '@parameter.inner',
					['af'] = '@function.outer',
					['if'] = '@function.inner',
					['ac'] = '@class.outer',
					['ic'] = '@class.inner',
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					[']m'] = '@function.outer',
					[']]'] = '@class.outer',
				},
				goto_next_end = {
					[']M'] = '@function.outer',
					[']['] = '@class.outer',
				},
				goto_previous_start = {
					['[m'] = '@function.outer',
					['[['] = '@class.outer',
				},
				goto_previous_end = {
					['[M'] = '@function.outer',
					['[]'] = '@class.outer',
				},
			},
		},
	}
end, 0)

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		}
	end,
}

-- Configure nvim-cmp, auto completion
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete {},
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		['<A-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<A-S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),

        -- Ctrl-L for Copilot suggestion
        ['<C-l>'] = cmp.mapping(function(fallback)
            cmp.complete({
                config = {
                    sources = {
                        { name = 'copilot' }
                    }
                }
            })
        end, { 'i', 's' }),

	},
	sources = {
		{ name = "nvim_lsp", group_index = 1 },
		{ name = "path", group_index = 2 },
		{ name = "luasnip", group_index = 2 },
		{ name = "copilot", group_index = 3 },
	},
}

-- Configure copliot
require("copilot").setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
})

-- nvim-dap configuration
local dap = require('dap')

-- Configure dap for C/C++ debugging with clang using lldb
dap.adapters.lldb = {
  type = 'executable',
  command = '/opt/homebrew/opt/llvm/bin/lldb-dap', -- use lldb-dap, needs to be installed
  name = 'lldb'
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = true, -- Kör i terminal för att kunna se utdata
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.objcpp = dap.configurations.cpp
dap.configurations.swift = dap.configurations.cpp

-- Add mappings for debugging
vim.cmd('highlight DapBreakpointColor guifg=#ff5555')  -- Definiera färg (röd i detta exempel)
vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpointColor', linehl = '', numhl = '' })

-- nvim-dap-ui configuration
local dapui = require("dapui")

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },  -- Icons for tree structure
  mappings = {
    -- Navigation keys in DAP UI
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Layouts and sizes for DAP UI windows
  layouts = {
    {
      elements = {
        { id = "breakpoints", size = 0.5 }, -- Breakpoints section, smaller
        { id = "stacks", size = 0.20 },      -- Call stacks section, moderate
        { id = "scopes", size = 0.15 },      -- Scope section, smaller
        { id = "watches", size = 0.15 },     -- Watches section, larger
      },
      size = 40,  -- Width or height of the panel depending on position
      position = "left",  -- Panel position ("left", "right", "top", "bottom")
    },
    {
      elements = {
        { id = "repl", size = 0.5 },  -- Repl section
        { id = "console", size = 0.5 },  -- Debugger console
      },
      size = 14,  -- Height or width depending on position
      position = "bottom",  -- Position for REPL and console panels
    },
  },
  floating = {
    max_height = nil,  -- Maximum height for floating windows
    max_width = nil,  -- Maximum width for floating windows
    border = "single",  -- Border style for floating windows
    mappings = {
      close = { "q", "<Esc>" },  -- Keys to close floating windows
    },
  },
  windows = { indent = 1 },  -- Indentation for windows in DAP UI
  render = {
    max_type_length = nil,  -- Maximum type length in variable list
  }
})

-- Automatically open and close DAP UI on debugging events
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Customize colors for nvim-dap-ui to fit OneDark theme using vim.api.nvim_set_hl
vim.api.nvim_set_hl(0, "DapUIVariable", { fg = "#E5C07B" })          -- For variables (yellow)
vim.api.nvim_set_hl(0, "DapUIScope", { fg = "#61AFEF" })             -- For scope (blue)
vim.api.nvim_set_hl(0, "DapUIType", { fg = "#C678DD" })              -- For data types (purple)
vim.api.nvim_set_hl(0, "DapUIValue", { fg = "#98C379" })             -- For values (green)
vim.api.nvim_set_hl(0, "DapUIModifiedValue", { fg = "#E06C75", bold = true })  -- For modified values (red)
vim.api.nvim_set_hl(0, "DapUIDecoration", { fg = "#56B6C2" })        -- For decorations (cyan)
vim.api.nvim_set_hl(0, "DapUIThread", { fg = "#61AFEF" })            -- For threads (blue)
vim.api.nvim_set_hl(0, "DapUIStoppedThread", { fg = "#98C379" })     -- For stopped threads (green)
vim.api.nvim_set_hl(0, "DapUIFrameName", { fg = "#E5C07B" })         -- For function frames (yellow)
vim.api.nvim_set_hl(0, "DapUISource", { fg = "#61AFEF" })            -- For source files (blue)
vim.api.nvim_set_hl(0, "DapUILineNumber", { fg = "#ABB2BF" })        -- For line numbers (light gray)
vim.api.nvim_set_hl(0, "DapUIFloatBorder", { fg = "#56B6C2" })       -- For borders in floating windows (cyan)
vim.api.nvim_set_hl(0, "DapUIWatchesEmpty", { fg = "#E06C75" })      -- For empty watches (red)
vim.api.nvim_set_hl(0, "DapUIWatchesValue", { fg = "#98C379" })      -- For watch values (green)
vim.api.nvim_set_hl(0, "DapUIWatchesError", { fg = "#E06C75" })      -- For watch errors (red)
vim.api.nvim_set_hl(0, "DapUIBreakpointsPath", { fg = "#E5C07B" })   -- For breakpoint paths (yellow)
vim.api.nvim_set_hl(0, "DapUIBreakpointsInfo", { fg = "#61AFEF" })   -- For breakpoint info (blue)
vim.api.nvim_set_hl(0, "DapUIBreakpointsCurrentLine", { fg = "#98C379", bold = true })  -- For breakpoints on the current line (green, bold)
vim.api.nvim_set_hl(0, "DapUIStop", { fg = "#E06C75", bold = true }) -- For stopped debugging steps (red, bold)
vim.api.nvim_set_hl(0, "DapUIPlayPause", { fg = "#61AFEF" })         -- For play/pause buttons (blue)
vim.api.nvim_set_hl(0, "DapUIStepOver", { fg = "#E5C07B" })          -- For step over button (yellow)
vim.api.nvim_set_hl(0, "DapUIStepInto", { fg = "#98C379" })          -- For step into button (green)
vim.api.nvim_set_hl(0, "DapUIStepOut", { fg = "#56B6C2" })           -- For step out button (cyan)
vim.api.nvim_set_hl(0, "DapUIRestart", { fg = "#C678DD" })           -- For restart button (purple)
vim.api.nvim_set_hl(0, "DapUITerminate", { fg = "#E06C75", bold = true }) -- For terminate button (red, bold)
