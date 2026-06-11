local ensure_installed = {
  "tsx",
  "typescript",
  "python",
  "markdown",
  "cpp",
  "cmake",
  "lua",
  "bash",
  "dockerfile",
}
local already_installed = require("nvim-treesitter.config").get_installed()
local to_install = vim.tbl_filter(function(p)
  return not vim.tbl_contains(already_installed, p)
end, ensure_installed)
if #to_install > 0 then
  require("nvim-treesitter").install(to_install)
end
