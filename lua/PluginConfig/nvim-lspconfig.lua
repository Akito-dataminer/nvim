local api = vim.api
local bo = vim.bo
local diagnostic = vim.diagnostic
local keymap = vim.keymap
local lsp = vim.lsp

-- LSP log setting
lsp.set_log_level("off")

api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    -- Disable default keymaps
    bo[ev.buf].omnifunc = nil
    bo[ev.buf].tagfunc = nil
    bo[ev.buf].formatexpr = nil

    -- Set Keymaps
    local client = assert(lsp.get_client_by_id(ev.data.client_id))
    local keyopts = { remap = true, silent = true }
    if client:supports_method("textDocument/implementation") then
      keymap.set("n", "gD", lsp.buf.implementation, keyopts)
    end
    if client:supports_method("textDocument/definition*") then
      keymap.set("n", "gd", lsp.buf.definition, keyopts)
    end
    if client:supports_method("textDocument/typeDefinition*") then
      keymap.set("n", "gt", lsp.buf.type_definition, keyopts)
    end
    if client:supports_method("textDocument/references") then
      keymap.set("n", "gr", lsp.buf.references, keyopts)
    end
    if client:supports_method("textDocument/rename") then
      keymap.set("n", "gn", lsp.buf.rename, keyopts)
    end
    if client:supports_method("textDocument/codeAction") then
      keymap.set("n", "ga", lsp.buf.code_action, keyopts)
    end
  end,
})

lsp.enable({ "lua_ls", "pyright", "ts_ls", "clangd", "cmake", "coq_lsp", "jdtls", "bashls", "cssls" })

---- Key Mappings for diagnostic
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
keymap.set("n", "gq", diagnostic.setloclist, { desc = "Set diagnostic to loclist" }, opts)
