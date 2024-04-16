local fn = vim.fn

local util = {}

-- join_pathsの参照元 : https://github.com/neovim/nvim-lspconfig/blob/master/test/minimal_init.lua
local on_windows = vim.loop.os_uname().version:match("Windows")

-- join the arguments with the OS-appropriate delimiter.
util.join_paths = function(...)
  local path_sep = on_windows and "\\" or "/"
  local result = table.concat({ ... }, path_sep)
  return result
end

function util.tcode(code)
  return vim.api.nvim_replace_termcodes(code, true, true, true)
end

-- 与えられたパスにファイルがあるかどうかを確かめる
-- check if the file exists at the given path
util.isInstalled = function(path)
  -- empty(...) == 1 means there isn't the path.
  return fn.empty(fn.glob(path)) == 0 and 1 or 0
end

util.plugin_dir = fn.stdpath("data") .. "/lazy"

function util.clone_plugin(path, url, command)
  command = command or { "git", "clone", "--depth", "1", url, path }
  if util.isInstalled(path) ~= 1 then
    return fn.system(command)
  end
end

-- input : map type
-- parameter :
--   mode
--   key_pattern
--   action
--   option
local function add_keymap(keymap)
  local option = keymap.option or { noremap = true, silent = true }
  for _, m in pairs(keymap.mode) do
    vim.keymap.set(m, keymap.key_pattern, keymap.action, option)
  end
end

function util.add_keymaps(keymaps)
  for _, map in pairs(keymaps) do
    add_keymap(map)
  end
end

return util
