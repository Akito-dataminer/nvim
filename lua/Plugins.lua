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
-- local start_path = util.join_paths( packer_path, "start" )
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
  use { "Shougo/ddc-ui-native", }
  use { "Shougo/ddc-ui-pum", }

  -- Completion
  use {
    "Shougo/ddc.vim",
    requires = { "Shougo/pum.vim", "vim-skk/skkeleton" },
    config = function()
      require("PluginConfig/ddc")
    end,
  }

  use { "Shougo/ddc-around", }
  use { "Shougo/ddc-matcher_head", }
  use { "Shougo/ddc-sorter_rank", }
  use {
    "Shougo/ddc-source-nvim-lsp",
    config = function ()
      local capabilities = require("ddc_nvim_lsp").make_client_capabilities()
      require("lspconfig").denols.setup({
        capabilities = capabilities,
      })
    end
  }
  use { "Shougo/ddc-cmdline", }
  use { "Shougo/ddc-cmdline-history", }
  use { "Shougo/ddc-converter_remove_overlap", }
  use { "Shougo/ddc-line", }
  use { "LumaKernel/ddc-file", }
  use { "uga-rosa/ddc-source-vsnip", }
  use { "vim-skk/skkeleton",
    requires = { "vim-denops/denops.vim", event = {'InsertEnter'} },
    config = function()
      require("PluginConfig/skkeleton")
    end,
  }
  use { "Matts966/skk-vconv.vim", after = { "ddc.vim", "skkeleton" }, }

  -- Snippet
  use {
    "hrsh7th/vim-vsnip",
    requires = { "ddc-source-vsnip" },
    config = function()
      require( "PluginConfig/vsnip" )
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
    requires = { 'autotag' },
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

  -- タグの自動補完
  use({
    'windwp/nvim-ts-autotag',
    opt = true,
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
