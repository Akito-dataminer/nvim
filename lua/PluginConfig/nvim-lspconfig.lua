local api = vim.api
local lsp = vim.lsp
local keymap = vim.keymap

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local lspconfig = require('lspconfig')
local util = require( 'utils' )

-- get_lspconfig関数の参考元 : https://github.com/williamboman/nvim-lsp-installer/blob/main/scripts/autogen_metadata.lua
local function official_config( lsp_kind )
  local config_root = "lspconfig.server_configurations."
  local config = require( config_root .. lsp_kind )
  return config
end

-- Reference highlight
local highlight_color = {
  fg = '#c6c8d1',
  bg = '#104040',
}

local hl_target_extension = { "*.c", "*.h", "*.cpp", "*.hpp", "*.lua" }

api.nvim_set_hl( 0, "LspReferenceText", highlight_color )
api.nvim_set_hl( 0, "LspReferenceRead", highlight_color )
api.nvim_set_hl( 0, "LspReferenceWrite", highlight_color )

api.nvim_create_autocmd( { "CursorHold", "CursorHoldI" }, {
  pattern = hl_target_extension,
  callback = lsp.buf.document_highlight,
})

api.nvim_create_autocmd( { "CursorMoved", "CursorMovedI" }, {
  pattern = hl_target_extension,
  callback = lsp.buf.clear_references,
})

---- LSP Key Mappings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
keymap.set('n', 'ge', vim.diagnostic.open_float, opts)
keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
keymap.set('n', 'gq', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local my_on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  keymap.set('n', 'gD', lsp.buf.declaration, bufopts)
  keymap.set('n', 'gd', lsp.buf.definition, bufopts)
  keymap.set('n', 'K', lsp.buf.hover, bufopts)
  keymap.set('n', 'gi', lsp.buf.implementation, bufopts)
  keymap.set('n', 'gh', lsp.buf.signature_help, bufopts)
  keymap.set('n', '<space>wa', lsp.buf.add_workspace_folder, bufopts)
  keymap.set('n', '<space>wr', lsp.buf.remove_workspace_folder, bufopts)
  keymap.set('n', '<space>wl', function()
    print(vim.inspect(lsp.buf.list_workspace_folders()))
  end, bufopts)
  keymap.set('n', '<space>D', lsp.buf.type_definition, bufopts)
  keymap.set('n', 'gn', lsp.buf.rename, bufopts)
  keymap.set('n', '<space>ca', lsp.buf.code_action, bufopts)
  keymap.set('n', 'gr', lsp.buf.references, bufopts)
  keymap.set('n', '<space>f', function() lsp.buf.format { async = true } end, bufopts)
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

local my_capabilities = lsp.protocol.make_client_capabilities()
my_capabilities.textDocument.completion.completionItem.snippetSupport = true

-- LSPサーバーの設定
for lsp_kind, my_settings in pairs( lsp_settings ) do
  -- cmdがnilでなければ(iff. ユーザ設定がされていれば)、そちらを適用し、
  -- cmdがnilなら(iff. ユーザが独自設定をしていなければ)、デフォルト設定を適用する
  local config = official_config(lsp_kind)

  lspconfig[lsp_kind].setup {
    on_attach = my_on_attach,
    capabilities = my_capabilities,
    buildDirectory = my_settings.buildDirectory or config.default_config.buildDirectory,
    root_dir = my_settings.root_dir,
    settings = my_settings.settings or config.default_config.settings,
  }
end
