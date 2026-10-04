local map = vim.keymap.set
local o = { silent = true }

-- Harpoon
map("n", "<leader>a", "<cmd>lua require('harpoon'):list():add()<cr>", o)
map("n", "<C-e>", "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>", o)
map("n", "<C-h>", "<cmd>lua require('harpoon'):list():select(1)<cr>", o)
map("n", "<C-j>", "<cmd>lua require('harpoon'):list():select(2)<cr>", o)
map("n", "<C-k>", "<cmd>lua require('harpoon'):list():select(3)<cr>", o)
map("n", "<C-l>", "<cmd>lua require('harpoon'):list():select(4)<cr>", o)

-- File explorer
map("n", "<leader>pv", ":Ex<Enter>", o)

-- Typst preview toggle
map("n", "<leader>tp", ":lua if vim.g.typst_preview_active then vim.cmd('TypstPreviewStop'); vim.g.typst_preview_active = false else vim.cmd('TypstPreview'); vim.g.typst_preview_active = true end<CR>", o)

-- Move selected lines
map("v", "<C-j>", ":m +1<CR>", o)
map("v", "<C-k>", ":m -2<CR>", o)

-- Cursor/scroll fixes
map("n", "J", "mzJ`z", o)
map("n", "<C-d>", "<C-d>zz", o)
map("n", "<C-u>", "<C-u>zz", o)
map("n", "n", "nzzzv", o)
map("n", "N", "Nzzzv", o)

-- Clipboard-preserving edits
map("x", "<leader>p", "\"_dP", o)
map({ "n", "v" }, "Y", "\"+y", o)
map({ "n", "v" }, "P", "\"+p", o)
map({ "n", "v" }, "<leader>d", "\"_d", o)
