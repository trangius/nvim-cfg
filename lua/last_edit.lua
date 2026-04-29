-- Per-folder "where was I" marker. On exit, records the active buffer's
-- file + cursor position; on startup with no args, reopens it. Keyed by
-- cwd so each project remembers its own last spot.

local M = {}

local state_dir = vim.fn.stdpath("state") .. "/last_edit"
vim.fn.mkdir(state_dir, "p")

local function marker_path()
	local slug = vim.fn.getcwd():gsub("[^%w%-_]", "_")
	return state_dir .. "/" .. slug .. ".json"
end

local function save()
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo[buf].buftype ~= "" then return end
	local name = vim.api.nvim_buf_get_name(buf)
	if name == "" or vim.fn.filereadable(name) == 0 then return end
	local pos = vim.api.nvim_win_get_cursor(0)
	local f = io.open(marker_path(), "w")
	if not f then return end
	f:write(vim.fn.json_encode({ file = name, line = pos[1], col = pos[2] }))
	f:close()
end

function M.load()
	local f = io.open(marker_path(), "r")
	if not f then return end
	local raw = f:read("*a")
	f:close()
	local ok, data = pcall(vim.fn.json_decode, raw)
	if not ok or type(data) ~= "table" or not data.file then return end
	if vim.fn.filereadable(data.file) == 0 then return end
	vim.cmd("edit " .. vim.fn.fnameescape(data.file))
	pcall(vim.api.nvim_win_set_cursor, 0, { data.line or 1, data.col or 0 })
end

function M.clear()
	os.remove(marker_path())
end

function M.setup()
	vim.api.nvim_create_autocmd("VimLeavePre", { callback = save })
end

return M
