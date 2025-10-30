local bo = vim.bo
local cmd = vim.cmd
local lsp = vim.lsp

local lang_formatter_pair = {
  python = require("formatter.filetypes.python").black,
}

local required_config = function(filetype)
  return "formatter.filetypes." .. filetype
end

local lang_supported_prettier = {
  "css",
  "html",
  "java",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "markdown",
  "json",
  "yaml",
  "xml",
  "svelte",
}

for _, lang in ipairs(lang_supported_prettier) do
  lang_formatter_pair[lang] = require(required_config(lang)).prettier
end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = lang_formatter_pair,
})

-- LSPクライアントがフォーマット機能をサポートしているかチェック
local function has_lsp_formatter()
  local clients = lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.server_capabilities.documentFormattingProvider then
      return true
    end
  end
  return false
end

local function try_format()
  local filetype = bo.filetype

  if lang_formatter_pair[filetype] then
    -- lang_formatter_pair[filetype]が定義されていれば、そちらを優先的に使用
    cmd("FormatWrite")
  elseif has_lsp_formatter() then
    -- LSPフォーマッタが利用可能な場合は、LSPを使用
    lsp.buf.format({ async = false })
    cmd("write")
  else
    -- フォーマッタが見つからない場合
    vim.notify("No formatter found for filetype: " .. filetype, vim.log.levels.WARN)
  end
end

-- "<Space>f"でフォーマットを実行する。
vim.keymap.set("n", "<Space>f", try_format, { desc = "Format and save buffer" })
