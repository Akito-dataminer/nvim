local api = vim.api
local lsp = vim.lsp
local fn = vim.fn
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

-- LSP log setting
vim.lsp.set_log_level( "off" )

---- LSP Key Mappings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
keymap.set('n', 'ge', vim.diagnostic.open_float, opts)
keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
keymap.set('n', 'gq', vim.diagnostic.setloclist, opts)

-- Reference highlight
local highlight_color = {
  fg = '#c6c8d1',
  bg = '#104040',
}

api.nvim_set_hl( 0, "LspReferenceText", highlight_color )
api.nvim_set_hl( 0, "LspReferenceRead", highlight_color )
api.nvim_set_hl( 0, "LspReferenceWrite", highlight_color )

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

  -- Find the clients capabilities
  local doc_light = client.server_capabilities.documentHighlightProvider

  -- Only highlight if compatible with the language
  if doc_light then
    api.nvim_create_augroup( "LspHighlight", { clear = true, } )
    api.nvim_clear_autocmds { buffer = bufnr, group = "LspHighlight" }

    api.nvim_create_autocmd( { "CursorHold", "CursorHoldI" }, {
      callback = lsp.buf.document_highlight,
      group = "LspHighlight",
      buffer = bufnr,
    })

    api.nvim_create_autocmd( { "CursorMoved", "CursorMovedI" }, {
      callback = lsp.buf.clear_references,
      group = "LspHighlight",
      buffer = bufnr,
    })
  end
end

-- 使いたいLSPサーバの名前をキーにして、cmdなどを列挙する
local lsp_settings = {}
local mason_package_root = util.join_paths( fn.stdpath('data'), 'mason', 'packages' )

-- /C++
lsp_settings["clangd"] = {
  cmd = {
    "clangd.exe",
    -- "--compile-commands-dir=${workspaceFolder}",
    -- "--background-index",
    -- "--clang-tidy",
    "--all-scopes-completion",
    -- "--cross-file-rename",
    -- "--completion-style=detailed",
    "--header-insertion=never",
    -- "--header-insertion-decorators",
    -- "-j=8",
    "--offset-encoding=utf-8",
    "--log=verbose"
  },
  filetype = { "cpp", "cppm", "hpp" },
  -- settings = {},
  -- root_pattern = { ".git", "build" },
}

-- Lua
local lua_lsp_root = util.join_paths( mason_package_root, 'lua-language-server', 'extension', 'server' )

lsp_settings["sumneko_lua"] = {
  cmd = {
    util.join_paths( lua_lsp_root, 'bin', 'lua-language-server.exe' ),
    '-E',
    util.join_paths( lua_lsp_root, 'main.lua' ),
  },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- cmake
lsp_settings["cmake"] = {}

-- python
lsp_settings["pyright"] = {}

-- bash
lsp_settings["bashls"] = {}

local my_capabilities = lsp.protocol.make_client_capabilities()
my_capabilities.textDocument.completion.completionItem.snippetSupport = true

-- LSPサーバーの設定
for lsp_kind, my_config in pairs( lsp_settings ) do
  -- my_configがnilでなければ(iff. ユーザ設定がされていれば)、そちらを適用し、
  -- my_configがnilなら(iff. ユーザが独自設定をしていなければ)、デフォルト設定を適用する
  lspconfig[lsp_kind].setup {
    config = official_config( lsp_kind ).default_config,
    cmd = my_config.cmd or official_config( lsp_kind ).default_config.cmd,
    root_dir = my_config.root_dir or official_config( lsp_kind ).docs.root_dir,
    settings = my_config.settings or official_config( lsp_kind ).default_config.settings,
    on_attach = my_on_attach,
    capabilities = my_capabilities,
  }
end
