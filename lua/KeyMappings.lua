---- HELPERS ----
local api = vim.api

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

--------------
---- Body
--------------
for k, v in pairs({
  ["<C-h>"] = "<C-w>h", -- ペイン移動
  ["<C-j>"] = "<C-w>j", -- ペイン移動
  ["<C-k>"] = "<C-w>k", -- ペイン移動
  ["<C-l>"] = "<C-w>l", -- ペイン移動
}) do
  map("", k, v)
end

---- Normal Mode ----
for k, v in pairs({
  ["<C-s>"] = ":w<CR>", -- 保存
  ["<C-q>"] = ":q<CR>", -- 終了
  ["<UP>"] = "",
  ["<Down>"] = "",
  ["<Left>"] = "",
  ["<Right>"] = "",
  ["[b"] = ":bp<CR>",
  ["]b"] = ":bn<CR>",
  ["*"] = ":%s/\\v",
  -- ["<Space>b"] = ":%!xxd<CR>",
  ["<Space><CR>"] = ":.!bash<CR>",
  ["<C-p>"] = '"*p',
  -- vim-fugitive
  ["<Space>gc"] = ":G checkout",
  ["<Space>gb"] = ":G branch",
  ["<Space>gt"] = ":G tag",
  ["<Space>gl"] = ":G log",
  ["<Space>gh"] = ":G log --graph --oneline", -- git 'h'istory
  ["<Space>gr"] = ":G rebase --rebase-merge",
  ["<Space>gs"] = ":G",
  ["<Space>gm"] = ":G merge --no-ff",
  ["<Space>gi"] = ":G commit -m",
}) do
  map("n", k, v)
end

---- Terminal Mode ----
map("t", "<Esc>", "<C-\\><C-n>")

---- Neovim built-in LSP settings ----
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- local opts = { noremap=true, silent=true }
-- api.nvim_set_keymap('n', '<space>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
-- api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
-- api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
