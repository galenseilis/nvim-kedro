local M = {}

-- Function to get the dataset name under the cursor
local function get_dataset_name()
	local line = vim.fn.getline(".")
	local col = vim.fn.col(".")
	-- Search for a word under the cursor
	local dataset_name = string.match(line:sub(1, col - 1), "(%w+)$")
	return dataset_name
end

-- Function to check if dataset exists in data catalog
local function dataset_exists_in_catalog(dataset_name)
	local catalog_path = "conf/base/catalog.yml" -- Adjust path if necessary
	local file = io.open(catalog_path, "r")
	if not file then
		print("Data catalog file not found.")
		return false
	end

	local content = file:read("*a")
	file:close()

	-- Check if dataset_name exists in the data catalog
	if content:find(dataset_name) then
		return true
	else
		return false
	end
end

-- Function to open the data catalog at the dataset name
local function open_data_catalog()
	local dataset_name = get_dataset_name()

	if dataset_exists_in_catalog(dataset_name) then
		local catalog_path = "conf/base/catalog.yml" -- Adjust path if necessary
		vim.cmd("e " .. catalog_path) -- Open the data catalog file
		vim.cmd("normal! g/\\<" .. dataset_name .. "\\>") -- Move cursor to the dataset name
	else
		print(dataset_name .. " is not defined in the data catalog.")
	end
end

-- Keybinding function
function M.setup()
	-- Using `<leader>kd` as a keymap
	vim.api.nvim_set_keymap(
		"n",
		"<leader>kd",
		':lua require("kedro_plugin.kedro").open_data_catalog()<CR>',
		{ noremap = true, silent = true }
	)
end

print("Hello, from Kedro!")

return M
