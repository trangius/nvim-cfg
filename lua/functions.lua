local M = {}

function M.search_in_current_buffer()
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end

function M.open_popup(lines, width_pct, height_pct)
	local buf = vim.api.nvim_create_buf(false, true) -- create new buffer

	-- calculate size
	local width = vim.o.columns
	local height = vim.o.lines
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
	vim.wo[win].cursorline = true
	vim.bo[buf].buftype = 'nofile'
	vim.bo[buf].bufhidden = 'hide'
	vim.bo[buf].swapfile = false

	-- set the predefined lines
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- close popup with ESC
	local close_cmd = string.format(":lua require'functions'.close_popup(%d, %d)<CR>", win, border_win)
	vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', close_cmd, {noremap = true, silent = true})
	vim.api.nvim_buf_set_keymap(buf, 'n', '<C-m>', close_cmd, {noremap = true, silent = true})
end

function M.close_popup(win, border_win)
    if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_win_is_valid(border_win) then
        vim.api.nvim_win_close(border_win, true)
    end
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
        error("Cannot open file" .. filepath)
    end
    return lines
end

function M.open_myhelp_popup()
    local lines = M.load_lines_from_file(vim.fn.stdpath('config') .. '/help')
    M.open_popup(lines, 0.6, 0.8)
end

function M.terminal_here()
	vim.cmd("vsplit | terminal")
	vim.cmd("startinsert")
end

function M.terminal_close()
	vim.api.nvim_command('stopinsert')
	vim.api.nvim_command('q')
end

function M.toggle_chars()
  if vim.opt.list:get() then
    vim.opt.list = false
  else
    vim.opt.list = true
    vim.opt.listchars = { tab = '»-', trail = '·' }
  end
end


function M.buffer_close_with_aerial()
  local bd = vim.bo.buftype == 'terminal' and 'bd!' or 'bd'
  if require('aerial').is_open() then
    require('aerial').toggle()
    vim.cmd(bd)
    require('aerial').toggle({ focus = false })
  else
    vim.cmd(bd)
  end
end

function M.run_file()
  local file = vim.fn.expand('%:p')
  local ext = vim.fn.expand('%:e')
  local cmd
  if ext == 'py' then
    cmd = 'python3 ' .. file
  elseif ext == 'c' then
    local out = vim.fn.expand('%:p:r')
    cmd = 'gcc ' .. file .. ' -o ' .. out .. ' && ' .. out
  elseif #vim.fn.glob('*.csproj', false, true) > 0
      or #vim.fn.glob('*.sln', false, true) > 0 then
    cmd = 'dotnet run'
  elseif ext == 'cs' then
    cmd = 'dotnet run ' .. file
  else
    print('No runner for filetype: ' .. ext)
    return
  end
  local tmpfile = '~/tmp/nvim_run_out.txt'
  vim.fn.system('zsh -c "' .. cmd .. ' >' .. tmpfile .. ' 2>&1"')
  if vim.v.shell_error ~= 0 then
    local sr = vim.o.splitright
    vim.o.splitright = true
    vim.cmd('vsplit | terminal zsh -c "cat ' .. tmpfile .. '; echo \'--- press any key ---\'; read -q"')
    vim.o.splitright = sr
  end
end

return M
