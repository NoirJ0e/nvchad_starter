require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>fm", "<cmd>Neoformat <cr>", { desc = "Format file with Neoformat" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
