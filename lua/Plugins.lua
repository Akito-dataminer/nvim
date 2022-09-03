local fn = vim.fn
local cmd = vim.cmd

-- 与えられたパスにファイルがあるかどうかを確かめる
local function isInstalled( path )
  return fn.empty( fn.glob( path ) )
end

-- 第一引数のパスにファイルが無ければ、
-- 第二引数で指定した場所からファイルをgit cloneする
local function clonePlugin( path, url )
  if isInstalled( path ) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', url, path})
  end
end

-- join_pathsの参照元 : https://github.com/neovim/nvim-lspconfig/blob/master/test/minimal_init.lua
local on_windows = vim.loop.os_uname().version:match 'Windows'

local function join_paths(...)
  local path_sep = on_windows and '\\' or '/'
  local result = table.concat({ ... }, path_sep)
  return result
end

local data_path = fn.stdpath( "data" )
local packer_path = join_paths( data_path, "site", "pack", "packer" )
local start_path = join_paths( packer_path, "start" )
local opt_path = join_paths( packer_path, "opt" )
local installed_packer_path = join_paths( opt_path, "packer.nvim" )

-- まだPackerがダウンロードされていなければ
-- githubからダウンロードする
clonePlugin( installed_packer_path, "https://github.com/wbthomason/packer.nvim" )

-- Only required if you have packer configured as `opt`
cmd[[packadd packer.nvim]]

-- icebergがダウンロードされていなければダウンロードする
local iceberg_path = join_paths( opt_path, "iceberg.vim" )
clonePlugin( iceberg_path, "https://github.com/cocopon/iceberg.vim.git" )

local use = require('packer').use

require('packer').startup(function()
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim', opt = true }

  -- 公式のビルトインLSP設定集
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require("PluginConfig/nvim-lspconfig")
    end
  }

  -- color scheme
  local colorscheme = "iceberg.vim"
  use {
    'cocopon/iceberg.vim',
    opt = true,
    run = cmd[[colorscheme iceberg]]
    -- config = function()
    --   local ok, _ = pcall( require( colorscheme ), 'iceberg is not downloaded' )

    --   if ok then
    --     cmd[[colorscheme iceberg]] -- iceberg.vimを読み込んだ後にcolorschemeをicebergに変える
    --   else
    --     -- icebergがダウンロードされていなければダウンロードする
    --     local iceberg_path = join_paths( opt_path, "iceberg.vim" )
    --     clonePlugin( iceberg_path, "https://github.com/cocopon/iceberg.vim.git" )
    --   end
    -- end
  }

  -- deno
  use { "vim-denops/denops.vim", }

  -- Completion
  use {
    "Shougo/ddc.vim",
    requires = { "vim-denops/denops.vim" },
    -- opt = true,
    config = function()
      require("PluginConfig/ddc")
    end,
  }

  use { "Shougo/ddc-around", after = { "ddc.vim" }, }
  use { "Shougo/ddc-matcher_head", after = { "ddc.vim" }, }
  use { "Shougo/ddc-sorter_rank", after = { "ddc.vim" }, }

  -- Snippet
  use {
    "L3MON4D3/LuaSnip",
    config = function()
      require("PluginConfig/LuaSnip")
    end,
  }

  use {
    "williamboman/mason.nvim",
    config = function()
      require("PluginConfig/mason")
    end
  }

  -- tree-sitter interface to simplificate
  use {
    "nvim-treesitter/nvim-treesitter",
    after = { colorscheme },
    run = ':TSUpdate',
    event = "VimEnter",
    config = function()
      require("PluginConfig/nvim-treesitter")
    end,
  }

  -- fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'ahmedkhalf/project.nvim',
      'nvim-lua/plenary.nvim',
    },
    event = "VimEnter",
    after = { colorscheme },
    config = function()
      require("PluginConfig/telescope")
    end,
  }

  use 'tpope/vim-fugitive' -- gitを統合するためのプラグイン

  use 'tpope/vim-surround' -- 括弧を付けるためのプラグイン

  -- 括弧の自動補完
  use({
    "windwp/nvim-autopairs",
    event = "VimEnter",
    config = function()
      require("PluginConfig/nvim-autopairs")
    end,
  })

  use 'preservim/nerdcommenter' -- コメントアウトのサポート

  -- easymotion for nvim
  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- for markdown
  use {
    'preservim/vim-markdown'
  }

  use {
    'previm/previm'
  }

  use {
    'tyru/open-browser.vim'
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)

