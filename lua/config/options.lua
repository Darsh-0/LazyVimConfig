-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.shiftwidth = 4 -- Number of spaces for each step of autoindent
opt.tabstop = 4 -- Number of spaces that a <Tab> counts for
opt.softtabstop = 4 -- Number of spaces inserted when pressing <Tab>
opt.expandtab = true -- Use spaces instead of literal tab characters

vim.opt.number = true
vim.opt.relativenumber = false
