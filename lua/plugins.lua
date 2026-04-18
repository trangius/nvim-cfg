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
	'petertriho/nvim-scrollbar',

	-- a sidebar with class/function list to step trough
	{
		"stevearc/aerial.nvim",
		config = function()
			local icon = function(hex) return vim.fn.nr2char(hex) end
			require('aerial').setup({
                focus_on_open = false,
                close_automatic_events = {},
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

			-- require('aerial').open() --TODO: this one breaks tabstop and sets it to 8 always. can this be fixed?
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
				-- Never open files into these window types; without "aerial"
				-- here, neo-tree would sometimes replace the aerial sidebar
				-- with the opened file.
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
	-- CODE HELPERS
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
	},

	-- Github Copilot, we need node.js for this -> "brew install node" 
    {
        "zbirenbaum/copilot.lua",
        event = "VimEnter",
        config = function()
            vim.defer_fn(function()
                require("copilot").setup()
            end,
			30) -- delay to make sure everything loads correctly
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        after = "copilot.lua",
        config = function()
            require("copilot_cmp").setup()
        end
    },


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
	},

	{
		'p00f/clangd_extensions.nvim',
		config = function()
			require("clangd_extensions").setup {}
		end,
	},

	-- {
	-- 	"smoka7/multicursors.nvim",
	-- 	event = "VeryLazy",
	-- 	dependencies = {
	-- 		'smoka7/hydra.nvim',
	-- 	},
	-- 	opts = {},
	-- 	cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
	-- },
	--
	-- vim-visual-multi
	-- {
	-- 	"mg979/vim-visual-multi",
	-- 	setup = function()
	-- 		vim.g.VM_maps = {
	-- 			["Find Under"] = "g*",
	-- 			["Select Under"] = "g#",
	-- 			["Select Till"] = "g,",
	-- 			["Swap With Down"] = "<C-Down>",
	-- 			["Swap With Up"] = "<C-Up>",
	-- 			["Remove Under"] = "gX",
	-- 			["Remove Selection Under"] = "gx",
	-- 		}
	-- 	end,
	-- 	config = function()
	-- 		vim.api.nvim_command("let g:vm_mouse = 1") -- Enable mouse support
	-- 	end
	-- },
	--
	--
	--
	{
	  "mfussenegger/nvim-dap",  -- Core DAP plugin
	  dependencies = {
		{
		  "rcarriga/nvim-dap-ui",  -- DAP UI plugin
		  dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",  -- Additional dependency for nvim-dap-ui
		  },
		  config = function()
			require("dapui").setup()  -- Setup DAP UI
		  end,
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
		-- Any additional configuration for nvim-dap can be added here
	  end,
	}

})
