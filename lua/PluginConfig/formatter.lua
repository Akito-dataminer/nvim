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
