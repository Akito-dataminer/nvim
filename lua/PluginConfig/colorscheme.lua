local fn = vim.fn
local cmd = vim.cmd

local utils = require('utils')
local packer_config = require('packer').config

-- icebergがダウンロードされていなければダウンロードする
local packer_path = utils.join_paths( packer_config.package_root, packer_config.plugin_package )
local start_path = utils.join_paths( packer_path, "start" )
local opt_path = utils.join_paths( packer_path, "opt" )
local candidate_directory_list = { start_path, opt_path }

local iceberg_exist_path = ''
for _, path in pairs( candidate_directory_list ) do
  local iceberg_path = utils.join_paths( path, "iceberg.vim" )

  -- if the colorscheme is found, copy the directory
  -- print( iceberg_path .. ' : ' .. fn.isdirectory( iceberg_path ) )

  if fn.isdirectory( iceberg_path ) == 1 then
    iceberg_exist_path = iceberg_path
    break
  end
end

if iceberg_exist_path == '' then
  local iceberg_github_url = "https://github.com/cocopon/iceberg.vim.git"
  print( 'install iceberg.vim' )
  fn.system({'git', 'clone', '--depth', '1', iceberg_github_url, iceberg_exist_path})
else
  cmd( [[colorscheme iceberg]] )
end
