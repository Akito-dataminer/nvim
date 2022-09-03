local cmd = vim.cmd
local fn = vim.fn

local on_windows = vim.loop.os_uname().version:match 'Windows'

local function join_paths(...)
  local path_sep = on_windows and '\\' or '/'
  local result = table.concat({ ... }, path_sep)
  return result
end

-- get the directory which has init.lua
local config_directory = fn.stdpath( "config" )
-- print( config_directory )

local ddc_config_path = join_paths( config_directory, "vim", "ddc.vim" )
print( ddc_config_path )

-- VimScriptのパスにあるファイルを、VimScriptとして実行
cmd( "source " .. ddc_config_path )
-- cmd( "source " .. fn.stdpath( 'config' ) .. "\\vim\\ddc.vim" )

