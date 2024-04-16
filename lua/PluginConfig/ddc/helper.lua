local fn = vim.fn

local M = {}

function M.patch_global(...)
  fn["ddc#custom#patch_global"](...)
end

function M.patch_filetype(...)
  fn["ddc#custom#patch_filetype"](...)
end

function M.enable(...)
  fn["ddc#enable"](...)
end

function M.enable_cmdline()
  fn["ddc#enable_cmdline_completion"]()
end

return M
