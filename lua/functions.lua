-- these are my own functions
local M = {}


function M.reload_lua_config()
  for name, _ in pairs(package.loaded) do
    if name:match("^c") and not name:match("^core") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
end


function M.search_in_current_buffer()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end


function M.open_popup(lines, width_pct, height_pct)
	local buf = vim.api.nvim_create_buf(false, true) -- create new buffer

	-- calculate size
	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")
	local win_width = math.ceil(width * width_pct)
	local win_height = math.ceil(height * height_pct)
	local win_row = math.ceil((height - win_height) / 2)
	local win_col = math.ceil((width - win_width) / 2)

	-- create a nice frame around the popup
	local border_buf = vim.api.nvim_create_buf(false, true)
	local border_opts = {
		style = "minimal",
		relative = "editor",
		width = win_width + 2,
		height = win_height + 2,
		row = win_row - 1,
		col = win_col - 1
	}
	local border_lines = {"╔" .. string.rep("═", win_width) .. "╗"}
	for i = 1, win_height do
		table.insert(border_lines, "║" .. string.rep(" ", win_width) .. "║")
	end
	table.insert(border_lines, "╚" .. string.rep("═", win_width) .. "╝")
	vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)
	local border_win = vim.api.nvim_open_win(border_buf, false, border_opts)

	-- configure the popup window
	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = win_row,
		col = win_col
	}
	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.api.nvim_win_set_option(win, 'cursorline', true)
	vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
	vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
	vim.api.nvim_buf_set_option(buf, 'swapfile', false)

	-- set the predefined lines
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- close popup with ESC
	local close_cmd = string.format(":lua require'functions'.close_popup(%d, %d)<CR>", win, border_win)
	vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', close_cmd, {noremap = true, silent = true})
	vim.api.nvim_buf_set_keymap(buf, 'n', '<C-m>', close_cmd, {noremap = true, silent = true})
end


function M.close_popup(win, border_win)
	vim.api.nvim_win_close(win, true)
	vim.api.nvim_win_close(border_win, true)
end


function M.load_lines_from_file(filepath)
    local lines = {}
    local file = io.open(filepath, "r")
    if file then
        for line in file:lines() do
            table.insert(lines, line)
        end
        file:close()
    else
        error("Cannot open file: " .. filepath)
    end
    return lines
end


function M.open_myhelp_popup()
	local lines = M.load_lines_from_file(vim.fn.stdpath('config') .. '/README.md')
    M.open_popup(lines, 0.6, 0.8)
end

function M.toggle_theme()
    if vim.g.current_theme == "light" then
        require("onedark").setup({style = "warm"})
        require("onedark").load()
        vim.opt.background = "dark"
        vim.g.current_theme = "warm"
    else
        -- Sätt till "light" tema
        require("onedark").setup({
          style = "light"
        })
        vim.opt.background = "light"
        vim.g.current_theme = "light"
    end
end

return M
