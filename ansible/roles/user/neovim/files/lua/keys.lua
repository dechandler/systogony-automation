
--[[ keys.lua ]]
local map = vim.api.nvim_set_keymap

-- remap the key used to leave insert mode
-- map('i', 'jk', '', {})

map('n', 'n', [[:NvimTreeToggle]], {})
map("n", "<Leader>n", ":set number!<CR>:set colorcolumn=<CR>", {})
