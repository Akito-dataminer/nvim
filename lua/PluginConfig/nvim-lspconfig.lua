local api = vim.api

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local lspconfig = require('lspconfig')
local util = require( 'utils' )

-- get_lspconfig関数の参考元 : https://github.com/williamboman/nvim-lsp-installer/blob/main/scripts/autogen_metadata.lua
local function official_config( lsp )
  local config_root = "lspconfig.server_configurations."
  local config = require( config_root .. lsp )
  return config
end

-- Reference highlight
vim.cmd [[
set updatetime=200
highlight LspReferenceText  ctermfg=1 ctermbg=8 guifg=#c6c8d1 guibg=#104040
highlight LspReferenceRead  ctermfg=1 ctermbg=8 guifg=#c6c8d1 guibg=#104040
highlight LspReferenceWrite ctermfg=1 ctermbg=8 guifg=#c6c8d1 guibg=#104040
augroup lsp_document_highlight
  autocmd!
  autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
augroup END
]]

---- LSP Key Mappings
api.nvim_set_keymap("n", "[lsp]", "<Nop>", { noremap = true, silent = true })
api.nvim_set_keymap("v", "[lsp]", "<Nop>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<space>", "[lsp]", {})
api.nvim_set_keymap("v", "<space>", "[lsp]", {})

local my_on_attach = function(client, bufnr)
  local function buf_set_keymap(...) api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "[lsp]h", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "[lsp]wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "[lsp]wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "[lsp]wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "[lsp]td", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "[lsp]rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "[lsp]co", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "[lsp]d", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "[lsp]q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  -- buf_set_keymap("n", "[lsp]f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- 使いたいLSPサーバの名前をキーにして、cmdなどを列挙する
local lsp_settings = {}

-- /C++
lsp_settings["clangd"] = {
  settings = {
    cmd = {
      util.join_paths( "C:", "msys64", "mingw64", "bin", "clangd" ),
      -- "C:/msys64/mingw64/bin/clangd",
      -- "--compile-commands-dir=${workspaceFolder}",
      -- "--background-index",
      -- "--clang-tidy",
      -- "--all-scopes-completion",
      -- "--cross-file-rename",
      -- "--completion-style=detailed",
      -- "--header-insertion=never",
      -- "--header-insertion-decorators",
      -- "-j=8",
      -- "--offset-encoding=utf-8",
      -- "--log=verbose"
    },
    root_pattern = { ".git", "build" },
  }
}

-- Lua
lsp_settings["sumneko_lua"] = {
--   settings = {
--     cmd = {
--       util.join_paths( vim.fn.stdpath("data"), "mason", "packages", "lua-language-server", "extension", "server", "bin", "lua-language-server" )
--     }
--   }
}

-- cmake
lsp_settings["cmake"] = {
  settings = {
    cmd = {
      util.join_paths( "C:", "msys64", "mingw64", "bin", "cmake-language-server" ),
    },
  },
  root_dir = lspconfig.util.root_pattern('.git', 'build'),
  buildDirectory = "build",
}

local my_capabilities = vim.lsp.protocol.make_client_capabilities()
my_capabilities.textDocument.completion.completionItem.snippetSupport = true

-- LSPサーバーの設定
for lsp, my_settings in pairs( lsp_settings ) do
  -- cmdがnilでなければ(iff. ユーザ設定がされていれば)、そちらを適用し、
  -- cmdがnilなら(iff. ユーザが独自設定をしていなければ)、デフォルト設定を適用する
  local config = official_config(lsp)

  lspconfig[lsp].setup {
    on_attach = my_on_attach,
    capabilities = my_capabilities,
    buildDirectory = my_settings.buildDirectory or config.default_config.buildDirectory,
    root_dir = my_settings.root_dir,
    settings = my_settings.settings or config.default_config.settings,
  }
end
