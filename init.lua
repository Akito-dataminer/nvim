---- HELPERS ----
local g = vim.g -- a table to access global variables

--- Map Leader to Space ----
g.mapleader = " "

require("autocmds")

---- Set Neovim Options ----
require("Options")

---- Set Neovim Keymaps ----
require("KeyMappings")

---- Loading Plugins ----
require("plugins")

---- nerdcommenter settings ----
g.NERDSpaceDelims = 1
g.NERDDefaultAlign = "left"
