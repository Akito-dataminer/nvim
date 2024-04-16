local fn = vim.fn
local cmd = vim.cmd

local util = require("utils")
local packer_config = require("packer").config

-- icebergがダウンロードされていなければダウンロードする
local iceberg_exist_path = util.join_paths(util.plugin_dir, "iceberg.vim")
local iceberg_url = "https://github.com/cocopon/iceberg.vim.git"
util.clone_plugin(iceberg_exist_path, iceberg_url, { "git", "clone", "--depth", "1", iceberg_url, iceberg_exist_path })

cmd([[colorscheme iceberg]])
