local cmd = vim.cmd
local fn = vim.fn

local utils = require( 'utils' )

-- get the directory which has init.lua
local config_directory = fn.stdpath( "config" )
-- print( config_directory )

local ddc_config_path = utils.join_paths( config_directory, "vim", "ddc.vim" )
-- print( ddc_config_path )

-- VimScriptのパスにあるファイルを、VimScriptとして実行
cmd( "source " .. ddc_config_path )

