-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local lspconfig = require('lspconfig')

-- join_pathsの参照元 : https://github.com/neovim/nvim-lspconfig/blob/master/test/minimal_init.lua
local function join_paths(...)
  local path_sep = on_windows and '\\' or '/'
  local result = table.concat({ ... }, path_sep)
  return result
end

-- get_lspconfig関数の参考元 : https://github.com/williamboman/nvim-lsp-installer/blob/main/scripts/autogen_metadata.lua
local function official_config( lsp )
  local config_root = "lspconfig.server_configurations."
  local config = require( config_root .. lsp )
  return config
end

-- 使いたいLSPサーバの名前をキーにして、cmdなどを列挙する
local lsp_settings = {}

---- LSP Key Mappings
local my_on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<Space>h", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>td", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>co", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>d", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
my_capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- C/C++
lsp_settings["clangd"] = {
  cmd = {
    join_paths( "C:", "msys64", "mingw64", "bin", "clangd" ),
    -- "C:/msys64/mingw64/bin/clangd",
    -- "--compile-commands-dir=${workspaceFolder}",
    "--background-index",
    -- "--clang-tidy",
    "--all-scopes-completion",
    "--cross-file-rename",
    "--completion-style=detailed",
    "--header-insertion=never",
    "--header-insertion-decorators",
    "-j=8",
    "--offset-encoding=utf-8",
    "--log=verbose"
  },
}

-- Lua
lsp_settings["sumneko_lua"] = {
  cmd = {
    join_paths( vim.fn.stdpath("data"), "lsp_servers", "sumneko_lua", "extension", "server", "bin", "lua-language-server" )
  }
}

-- cmake
lsp_settings["cmake"] = {
  cmd = {
    join_paths( "C:", "msys64", "mingw64", "bin", "cmake-language-server" )
  }
}

-- LSPサーバーの設定
for lsp, settings in pairs( lsp_settings ) do
  -- cmdがnilでなければ(iff. ユーザ設定がされていれば)、そちらを適用し、
  -- cmdがnilなら(iff. ユーザが独自設定をしていなければ)、デフォルト設定を適用する
  local config = official_config(lsp)
  -- 現状ではcmd以外の設定をするつもりはないので、とりあえずこの実装にしておく(以下のcmdの文)。
  -- ただ、他にも設定したいことが出てきたらこの実装を変更する必要がある。
  local cmd = settings.cmd or config.default_config.cmd

  lspconfig[lsp].setup {
    on_attach = my_on_attach,
    capabilities = my_capabilities,
    cmd = cmd,
  }
end
