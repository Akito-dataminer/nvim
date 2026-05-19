local api = vim.api
local bo = vim.bo
local diagnostic = vim.diagnostic
local fn = vim.fn
local keymap = vim.keymap
local log = vim.log
local lsp = vim.lsp
local opt = vim.opt

opt.updatetime = 100

-- LSP log setting
lsp.set_log_level("off")

--- Returns the root directory detected by an active LSP client for the current buffer.
--- Returns nil when no client is running on the buffer or none has a root directory set.
local function get_lsp_root()
  for _, client in ipairs(lsp.get_clients({ bufnr = 0 })) do
    if client.root_dir then
      return client.root_dir
    end
  end
  return nil
end

--- Changes the current directory to the LSP root directory obtained via get_lsp_root().
local function cd_to_lsp_root()
  local root = get_lsp_root()
  if root then
    fn.chdir(root)
    vim.notify("cd -> " .. root, log.levels.INFO)
  else
    vim.notify("No LSP root directory found for the current buffer", log.levels.WARN)
  end
end

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

    -- cursor word highlight
    if client:supports_method("textDocument/documentHighlight") then
      local hl_group = api.nvim_create_augroup("lsp_cword_highlight_" .. ev.buf, { clear = true })
      api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = hl_group,
        buffer = ev.buf,
        callback = lsp.buf.document_highlight,
      })
      api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
        group = hl_group,
        buffer = ev.buf,
        callback = lsp.buf.clear_references,
      })
    end
  end,
})

lsp.enable({ "lua_ls", "pyright", "ts_ls", "clangd", "cmake", "coq_lsp", "jdtls", "bashls", "cssls" })

---- Key Mappings
keymap.set("n", "gp", cd_to_lsp_root, { desc = "Change the current directory to LSP root directory" })
keymap.set("n", "gq", diagnostic.setloclist, { desc = "Set diagnostic to loclist" }, { noremap = true, silent = true })
keymap.set("n", "gK", function()
  local new_config = not diagnostic.config().virtual_lines
  diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })

diagnostic.handlers.loclist = {
  show = function(_, _, _, opts)
    -- Generally don't want it to open on every update
    opts.loclist.open = opts.loclist.open or false
    local winid = api.nvim_get_current_win()
    diagnostic.setloclist(opts.loclist)
    api.nvim_set_current_win(winid)
  end,
}

-- Autocmds registered in LspAttach are not torn down automatically when the client detaches.
-- Explicitly delete the augroup and any residual highlights to avoid stale state on the buffer.
api.nvim_create_autocmd("LspDetach", {
  callback = function(ev)
    pcall(lsp.buf.clear_references)
    pcall(api.nvim_del_augroup_by_name, "lsp_cword_highlight_" .. ev.buf)
  end,
})
