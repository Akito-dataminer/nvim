---- HELPERS ----
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g      -- a table to access global variables

--- Map Leader to Space ----
g.mapleader = ' '

require'autocmds'

---- Set Neovim Options ----
require'Options'

---- Loading Plugins ----
require'Plugins'

cmd [[packadd packer.nvim]]
cmd 'autocmd BufWritePost Plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

---- nerdcommenter settings ----
g.NERDSpaceDelims = 1
g.NERDDefaultAlign = 'left'

---- Set Neovim Keymaps ----
require'KeyMappings'
