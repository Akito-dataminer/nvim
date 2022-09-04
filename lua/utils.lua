local fn = vim.fn

local util = {}

-- join_pathsの参照元 : https://github.com/neovim/nvim-lspconfig/blob/master/test/minimal_init.lua
local on_windows = vim.loop.os_uname().version:match 'Windows'

util.join_paths = function( ... )
  local path_sep = on_windows and '\\' or '/'
  local result = table.concat({ ... }, path_sep)
  return result
end

-- 与えられたパスにファイルがあるかどうかを確かめる
-- check if the file exists at the given path
util.isInstalled = function( path )
  return fn.empty( fn.glob( path ) )
end

return util
