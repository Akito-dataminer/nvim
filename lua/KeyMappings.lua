---- HELPERS ----
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local api = vim.api

local function map( mode, lhs, rhs, opts )
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap( mode, lhs, rhs, options )
end

--------------
---- Body
--------------
for k, v in pairs({
  ['<C-h>'] = '<C-w>h', -- ペイン移動
  ['<C-j>'] = '<C-w>j', -- ペイン移動
  ['<C-k>'] = '<C-w>k', -- ペイン移動
  ['<C-l>'] = '<C-w>l', -- ペイン移動
}) do
  map('', k, v)
end

---- Normal Mode ----
for k, v in pairs({
  ['<C-s>'] = ':w<CR>', -- 保存
  ['<C-q>'] = ':q<CR>', -- 終了
  ['<UP>'] = '',
  ['<Down>'] = '',
  ['<Left>'] = '',
  ['<Right>'] = '',
  ['[b'] = ':bp<CR>',
  [']b'] = ':bn<CR>',
  ['*'] = ':%s/\\v',
  ['<Space>b'] = ':%!xxd<CR>',
  -- hop
  ['<Space><Space>w'] = ':HopWord<CR>',
  ['<Space><Space>l'] = ':HopLine<CR>',
  ['<Space><Space>r'] = ':HopChar1<CR>',
  ['<Space><Space>h'] = ':HopChar2<CR>',
  -- Telescope
  ['<C-p>'] = ':Telescope projects<CR>',
  -- vim-fugitive
  ['<Space>gc'] = ':G checkout',
  ['<Space>gb'] = ':G branch',
  ['<Space>gt'] = ':G tag',
  ['<Space>gl'] = ':G log',
  ['<Space>a'] = ':G add',
  ['<Space>gs'] = ':G',
  ['<Space>gm'] = ':G merge --squash',
  ['<Space>gi'] = ':G commit -m',
}) do
  map('n', k, v)
end

---- Terminal Mode ----
-- map('t', '<C-[>', '<C-\\><C-n>')

---- Neovim built-in LSP settings ----
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

---- vim-vsnip
-- local opts = { expr = true, noremap = true }
-- for k, v in paires({
--   ['<Tab>'] = 'v:lua.smart_tab()',
-- }) do
--   map('i', k, v, opts)
-- end

