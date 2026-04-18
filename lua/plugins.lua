require('lazy').setup({
	---------------------------------------------------------------
	-- LOOK & FEEL
	---------------------------------------------------------------
	{
	    'trangius/onedarkbleak.nvim',
	    priority = 1000,
	    config = function()
	        require('onedarkbleak').setup({
	            colors = { bg0 = "#0e0e0e", bg_d = "#0a0a0a" },
	        })
	        vim.cmd.colorscheme 'onedarkbleak'
	    end,
	},

	-- File icons (used by telescope, lualine, etc.)
	'nvim-tree/nvim-web-devicons',

	-- Nice scrollbar
	{
		'petertriho/nvim-scrollbar',
		config = function()
			require("scrollbar").setup({
				handle = {
					color = '#5c6370', -- Adjust to match onedark's scrollbar handle color
				},
				marks = {
					Search = { color = '#98c379' }, -- Adjust to match onedark's search highlight color
			--		Warn = { color = '#e5c07b' }, -- Adjust to match onedark's warning color
					Error = { color = '#e06c75' },  -- Adjust to match onedark's error color
					Info = { color = '#56b6c2' },   -- Adjust to match onedark's info color
					Hint = { color = '#c678dd' },   -- Adjust to match onedark's hint color
					Misc = { color = '#56b6c2' },   -- Adjust to match onedark's misc (like git changes) color
				},
			})
		end,
	},

	-- a sidebar with class/function list to step trough
	{
		"stevearc/aerial.nvim",
		config = function()
			local icon = function(hex) return vim.fn.nr2char(hex) end
			require('aerial').setup({
                focus_on_open = false,
                close_automatic_events = {},
                -- Auto-open aerial only when the buffer has a working backend
                -- (treesitter/LSP/markdown symbols). Empty buffer or plain text
                -- files don't spawn an empty outline.
                open_automatic = true,
                -- Default nerd icons ship with a trailing space AND render.lua
                -- adds another space, creating a double gap. This table replaces
                -- the defaults with trimmed Codicon glyphs — render's one space
                -- is the only gap between icon and name. Swap any codepoint if
                -- it shows as a box in FiraCode.
                icons = {
                    Array         = icon(0xea8a),
                    Boolean       = icon(0xea8f),
                    Class         = icon(0xeb5b),
                    Constant      = icon(0xeb5d),
                    Constructor   = icon(0xf0871),
                    Enum          = icon(0xea95),
                    EnumMember    = icon(0xeb5e),
                    Event         = icon(0xea86),
                    Field         = icon(0xeb5f),
                    File          = icon(0xeaeb),
                    Function      = icon(0xf0295),
                    Interface     = icon(0xeb61),
                    Key           = icon(0xeb62),
                    Method        = icon(0xf0295),
                    Module        = icon(0xf0573),
                    Namespace     = icon(0xea8b),
                    Null          = icon(0xea86),
                    Number        = icon(0xea93),
                    Object        = icon(0xea8b),
                    Operator      = icon(0xeb64),
                    Package       = icon(0xeb29),
                    Property      = icon(0xeb65),
                    String        = icon(0xeb8d),
                    Struct        = icon(0xea91),
                    TypeParameter = icon(0xea92),
                    Variable      = icon(0xea88),
                    Collapsed     = icon(0xeab6),
                },
                layout = {
                    -- These control the width of the aerial window.
                    -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                    -- min_width and max_width can be a list of mixed types.
                    -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
                    max_width = 20,
                    width = 20,
                    min_width = 20,

                    -- key-value pairs of window-local options for aerial window (e.g. winhl)
                    win_opts = {},

                    -- Determines the default direction to open the aerial window. The 'prefer'
                    -- options will open the window in the other direction *if* there is a
                    -- different buffer in the way of the preferred direction
                    -- Enum: prefer_right, prefer_left, right, left, float
                    -- Force "right" (not prefer_right) so neo-tree on the right doesn't
                    -- make aerial fall back to the left.
                    default_direction = "right",

                    -- Determines where the aerial window will be opened
                    --   edge   - open aerial at the far right/left of the editor
                    --   window - open aerial to the right/left of the current window
                    placement = "window",

                    -- When the symbols change, resize the aerial window (within min/max constraints) to fit
                    resize_to_content = false,

                    -- Preserve window size equality with (:help CTRL-W_=)
                    preserve_equality = false,
                  },
            })
		end
	},

	-- Persistent project file tree on the far-right edge
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = false,
				-- Never open files into these window types; keeps aerial as a
				-- visible sidebar instead of getting replaced by the picked file.
				open_files_do_not_replace_types = { "terminal", "trouble", "qf", "aerial" },
				window = {
					position = "right",
					width = 28,
				},
				filesystem = {
					follow_current_file = { enabled = true },
					use_libuv_file_watcher = true,
					hijack_netrw_behavior = "disabled",
				},
			})

			-- Neo-tree always opens on startup; aerial is handled by its own
			-- open_automatic config and only shows up for supported buffers.
			-- When launched with no file, land inside neo-tree so we can pick one.
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if vim.fn.argc() == 0 then
						vim.cmd('Neotree focus')
					else
						vim.cmd('Neotree show')
					end
				end,
			})
		end,
	},

	{
	  'nvim-lualine/lualine.nvim',
	  opts = {
	    options = {
	      icons_enabled = false,
	      theme = 'onedarkbleak',
	      component_separators = '|',
	      section_separators = '',
	    },
	    sections = {
	      lualine_a = {'mode'},
	      lualine_b = {
	{
	  'buffers',
	  symbols = { alternate_file = '' },
	  buffers_color = {
	            active = { fg = '#e5e9f0', bg = '#3b4252' },  -- Ljusgrå text på mörkgrå bakgrund för aktiv buffer
	            inactive = { fg = '#4c566a', bg = '#2e3440' },  -- Mörkare grå text på mörkare bakgrund för inaktiv buffer
	  },
	}
	      },
	      lualine_c = {}, -- do not print name of current buffer, since we already see which one since lualine_b shows buffers
	    },
	  },
	},

	-- Useful plugin to show you pending keybinds.
	{ 'folke/which-key.nvim', opts = {} },


	---------------------------------------------------------------
	-- NAVIGATION
	---------------------------------------------------------------
	-- Telescope
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				-- NOTE: If you are having trouble with this installation,
				--			 refer to the README for telescope-fzf-native for more instructions.
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
		},
		config = function()
			local ignore_filetypes_list = {
			    "venv", "__pycache__", "node_modules", "build", "dist", "target", ".git", ".hg", ".svn", ".cache",
			    "%.png", "%.jpg", "%.jpeg", "%.webp", "%.gif", "%.svg", "%.ico", "%.psd", "%.xcf", "%.bmp", "%.tiff",
			    "%.pdf", "%.doc", "%.docx", "%.odt", "%.xls", "%.xlsx", "%.ppt", "%.pptx",
			    "%.o", "%.so", "%.a", "%.out", "%.class", "%.pyc", "%.pyo", "%.exe", "%.dll", "%.dylib", "%.wasm", "%.elf",
			    "%.zip", "%.tar", "%.tar.gz", "%.tgz", "%.bz2", "%.7z", "%.rar", "%.xz", "%.zst", "%.apk", "%.deb", "%.rpm", "%.iso",
			    "%.aux", "%.bbl", "%.blg", "%.dvi", "%.log", "%.synctex.gz", "%.toc", "%.fdb_latexmk", "%.fls",
			    "%.swp", "%.swo", "%.bak", "%.tmp", "~$", "%.DS_Store", "Thumbs.db",
			    "%.mp3", "%.wav", "%.ogg", "%.flac", "%.mp4", "%.mkv", "%.mov", "%.avi", "%.wmv",
			}

			-- See `:help telescope` and `:help telescope.setup()`
			require('telescope').setup {
				defaults = {
					mappings = {
						i = {
							['<C-u>'] = false,
							['<C-d>'] = false,
						},
					},
			        file_ignore_patterns = ignore_filetypes_list
				},
				extensions = {
					file_browser = {
						git_status = true,
					},
				},
			}

			-- Enable telescope fzf native, if installed on OS (otherwise, install it)
			pcall(require('telescope').load_extension, 'fzf')

			-- load file browser extension for telescope
			require('telescope').load_extension('file_browser')

			-- Git status colors for telescope file browser (OneDark theme)
			vim.api.nvim_set_hl(0, "TelescopeResultsDiffChange", { fg = "#E5C07B" })   -- modified: orange/yellow
			vim.api.nvim_set_hl(0, "TelescopeResultsDiffAdd", { fg = "#98C379" })      -- added: green
			vim.api.nvim_set_hl(0, "TelescopeResultsDiffDelete", { fg = "#E06C75" })   -- deleted: red
			vim.api.nvim_set_hl(0, "TelescopeResultsDiffUntracked", { fg = "#C678DD" }) -- untracked: purple
		end,
	},

	-- use telescope as a file browser
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	},

	{
		'phaazon/hop.nvim',
		branch = 'v2', -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
		end
	},


	-- Undo tree visualizer
	'mbbill/undotree',

	-- Pretty diagnostics / quickfix / LSP list panel
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		cmd = "Trouble",
	},

	---------------------------------------------------------------
	-- GIT PLUGINS
	---------------------------------------------------------------
	'tpope/vim-fugitive', -- so we can run :Git from vim
	'tpope/vim-rhubarb',

	-- persistence, tool to save/load vim sessions
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {
		-- add any custom options here
		}
	},

	-- Adds git related signs to the gutter, as well as utilities for managing changes
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				--vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

				-- don't override the built-in and fugitive keymaps
				local gs = package.loaded.gitsigns
				vim.keymap.set({ 'n', 'v' }, ']c', function()
					if vim.wo.diff then
						return ']c'
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return '<Ignore>'
				end, { expr = true, buffer = bufnr, desc = 'jump to next hunk' })
				vim.keymap.set({ 'n', 'v' }, '[c', function()
					if vim.wo.diff then
						return '[c'
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return '<Ignore>'
				end, { expr = true, buffer = bufnr, desc = 'jump to previous hunk' })
			end,
		},
	},


	---------------------------------------------------------------
	-- LSP / COMPLETION
	---------------------------------------------------------------
	-- LSP Configuration & Plugins
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
		config = function()
			-- This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(_, bufnr)
				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
					vim.lsp.buf.format()
				end, { desc = 'format current buffer with LSP' })
			end

			-- mason-lspconfig requires that these setup functions are called in this order
			-- before setting up the servers.
			-- for omnisharp to install, we need dotnet installed
			require('mason').setup()
			require('mason-lspconfig').setup({
			    ensure_installed = { "lua_ls", "html", "omnisharp", "clangd" },
			    automatic_installation = true,
			})

			-- Enable the following language servers
			local servers = {
				 clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- tsserver = {}
			    omnisharp = {},
				html = { filetypes = { 'html', 'twig', 'hbs' } },
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			}

			-- === NEW LSP SETUP (Nvim 0.11+) ===
			-- nvim-cmp capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			pcall(function()
			  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
			end)

			-- Use a single LspAttach autocmd for formatting
			vim.api.nvim_create_autocmd("LspAttach", {
			  callback = function(args)
			    local bufnr = args.buf
			    -- keep your on_attach Format command available
			    pcall(on_attach, nil, bufnr)

			    -- Auto-trigger signature help in insert mode on the server's trigger
			    -- characters (typically "(" and ","). Replaces the old `gs`/`<leader>cs`
			    -- mappings which only worked in normal mode, where they're useless.
			    local client = vim.lsp.get_client_by_id(args.data.client_id)
			    local triggers = client
			      and vim.tbl_get(client.server_capabilities or {}, 'signatureHelpProvider', 'triggerCharacters')
			    if triggers and not vim.tbl_isempty(triggers) then
			      vim.api.nvim_create_autocmd('TextChangedI', {
			        buffer = bufnr,
			        callback = function()
			          local col = vim.api.nvim_win_get_cursor(0)[2]
			          if col == 0 then return end
			          local ch = vim.api.nvim_get_current_line():sub(col, col)
			          if vim.tbl_contains(triggers, ch) then
			            vim.lsp.buf.signature_help()
			          end
			        end,
			      })
			    end
			  end,
			})

			-- Define per-server configs using the new API
			vim.lsp.config('clangd', {
			  capabilities = capabilities,
			})

			vim.lsp.config('omnisharp', {
			  capabilities = capabilities,
			  handlers = {
			    -- Slå av spamloggar
			    ["window/logMessage"] = function() end,
			    -- Visa bara fel, ignorera INFO/WARN
			    ["window/showMessage"] = function(_, result, ctx)
			      local mt = vim.lsp.protocol.MessageType
			      if result.type == mt.Error then
			        return vim.lsp.handlers["window/showMessage"](_, result, ctx)
			      end
			      -- annars: tyst
			    end,
			  },
			  -- Omnisharp occasionally emits malformed RPC messages; LSP
			  -- flags them as INVALID_SERVER_MESSAGE. Server keeps running,
			  -- so the error is just noise. Swallow only that specific code.
			  on_error = function(code, err)
			    if code == vim.lsp.client_errors.INVALID_SERVER_MESSAGE then
			      return
			    end
			    vim.notify(
			      ("LSP[omnisharp]: %s"):format(vim.inspect(err)),
			      vim.log.levels.ERROR
			    )
			  end,
			})

			vim.lsp.config('html', {
			  capabilities = capabilities,
			  filetypes = { 'html', 'twig', 'hbs' },
			})

			vim.lsp.config('lua_ls', {
			  capabilities = capabilities,
			  settings = {
			    Lua = {
			      workspace = { checkThirdParty = false },
			      telemetry = { enable = false },
			      diagnostics = { globals = { 'vim' } },
			    },
			  },
			})

			-- Setup neovim lua configuration
			require('neodev').setup()

			-- Ensure the servers above are installed
			local mason_lspconfig = require 'mason-lspconfig'

			mason_lspconfig.setup {
				ensure_installed = vim.tbl_keys(servers),
			  automatic_enable = true,
			}
		end,
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
		config = function()
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
		end,
	},

	-- Github Copilot, we need node.js for this -> "brew install node"
    {
        "zbirenbaum/copilot.lua",
        event = "VimEnter",
        config = function()
            vim.defer_fn(function()
                require("copilot").setup({
                    suggestion = { enabled = false },
                    panel = { enabled = false },
                })
            end, 30) -- delay to make sure everything loads correctly
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        after = "copilot.lua",
        config = function()
            require("copilot_cmp").setup()
        end
    },


	---------------------------------------------------------------
	-- EDITING
	---------------------------------------------------------------
	-- Add indentation guides even on blank lines
	{
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {},
	},

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },

	-- Highlight, edit, and navigate code
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		config = function()
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
		end,
	},

	{
		'p00f/clangd_extensions.nvim',
		config = function()
			require("clangd_extensions").setup {}
		end,
	},


	---------------------------------------------------------------
	-- DEBUG
	---------------------------------------------------------------
	{
	  "mfussenegger/nvim-dap",  -- Core DAP plugin
	  dependencies = {
		{
		  "rcarriga/nvim-dap-ui",  -- DAP UI plugin
		  dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",  -- Additional dependency for nvim-dap-ui
		  },
		},
		{
		  "Weissle/persistent-breakpoints.nvim",  -- Persistent breakpoints plugin
		  config = function()
			require("persistent-breakpoints").setup{
			  load_breakpoints_event = { "BufReadPost" },  -- Load breakpoints when opening files
			}
		  end,
		},
	  },
	  config = function()
		local dap = require('dap')
		local dapui = require("dapui")

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

		-- Breakpoint sign
		vim.cmd('highlight DapBreakpointColor guifg=#ff5555')
		vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpointColor', linehl = '', numhl = '' })

		-- nvim-dap-ui configuration
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

		-- Customize colors for nvim-dap-ui to fit OneDark theme
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
	  end,
	}

})
