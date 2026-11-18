-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.env.PATH = vim.env.HOME .. "/.local/bin:" .. vim.env.PATH
