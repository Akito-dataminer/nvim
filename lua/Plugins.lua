local fn = vim.fn
local cmd = vim.cmd

local util = require( "utils" )

-- 第一引数のパスにファイルが無ければ、
-- 第二引数で指定した場所からファイルをgit cloneする
local function clonePlugin( path, url )
  if util.isInstalled( path ) ~= 1 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', url, path})
  end
end

local data_path = fn.stdpath( "data" )
local packer_path = util.join_paths( data_path, "site", "pack", "packer" )
local start_path = util.join_paths( packer_path, "start" )
local opt_path = util.join_paths( packer_path, "opt" )
local installed_packer_path = util.join_paths( opt_path, "packer.nvim" )

-- まだPackerがダウンロードされていなければ
-- githubからダウンロードする
clonePlugin( installed_packer_path, "https://github.com/wbthomason/packer.nvim" )

-- Only required if you have packer configured as `opt`
cmd[[packadd packer.nvim]]

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
    run = require("PluginConfig/colorscheme")
  }

  -- deno
  use { "vim-denops/denops.vim", }

  use { "Shougo/pum.vim", }
  use { "Shougo/ddc-ui-native", opt = true }
  use { "Shougo/ddc-ui-pum", opt = true }

  -- Completion
  use {
    "Shougo/ddc.vim",
    requires = { "Shougo/ddc-ui-native", "Shougo/pum.vim", "vim-skk/skkeleton" },
    config = function()
      require("PluginConfig/ddc")
    end,
  }

  use { "Shougo/ddc-around", after = { "ddc.vim" }, }
  use { "Shougo/ddc-matcher_head", after = { "ddc.vim" }, }
  use { "Shougo/ddc-sorter_rank", after = { "ddc.vim" }, }
  use { "Shougo/ddc-nvim-lsp", after = { "ddc.vim" }, }
  use { "Shougo/ddc-cmdline", after = { "ddc.vim" }, }
  use { "Shougo/ddc-cmdline-history", after = { "ddc.vim" }, }
  use { "Shougo/ddc-converter_remove_overlap", after = { "ddc.vim" }, }
  use { "Shougo/ddc-line", after = { "ddc.vim" }, }
  use { "LumaKernel/ddc-file", after = { "ddc.vim" }, }
  use { "vim-skk/skkeleton",
    requires = { "vim-denops/denops.vim", event = {'InsertEnter'} },
    config = function()
      require("PluginConfig/skkeleton")
    end,
  }
  use { "Matts966/skk-vconv.vim", after = { "ddc.vim", "skkeleton" }, }

  -- Snippet
  use { "hrsh7th/vim-vsnip-integ", }
  use {
    "hrsh7th/vim-vsnip",
    requires = { "vim-vsnip-integ" },
    config = function()
      require( "PluginConfig/vsnip" )
    end,
  }
  -- use {
  --   "L3MON4D3/LuaSnip",
  --   config = function()
  --     require("PluginConfig/LuaSnip")
  --   end,
  -- }

  use {
    "williamboman/mason.nvim",
    config = function()
      require("PluginConfig/mason")
    end
  }

  -- tree-sitter interface to simplificate
  use {
    "nvim-treesitter/nvim-treesitter",
    -- after = { colorscheme },
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

  -- like easymotion for nvim
  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      require("PluginConfig/hop")
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

