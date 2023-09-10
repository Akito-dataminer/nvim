local fn = vim.fn

local util = {}

-- join_pathsの参照元 : https://github.com/neovim/nvim-lspconfig/blob/master/test/minimal_init.lua
local on_windows = vim.loop.os_uname().version:match 'Windows'

-- join the arguments with the OS-appropriate delimiter.
util.join_paths = function(...)
  local path_sep = on_windows and '\\' or '/'
  local result = table.concat({ ... }, path_sep)
  return result
end

-- 与えられたパスにファイルがあるかどうかを確かめる
-- check if the file exists at the given path
util.isInstalled = function(path)
  -- empty(...) == 1 means there isn't the path.
  return fn.empty(fn.glob(path)) == 0 and 1 or 0
end

util.plugin_dir = fn.stdpath("data") .. "/lazy"

function util.clone_plugin(path, url, command)
  command = command or { 'git', 'clone', '--depth', '1', url, path }
  if util.isInstalled(path) ~= 1 then
    return fn.system(command)
  end
end

return util
