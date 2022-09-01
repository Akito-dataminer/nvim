-- 新しいPCに買い替えたときなど、まだPackerが入っていないときでも、
-- このluaファイル群だけで作業を完結できるようにするためのスクリプト。
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.api.nvim_command("silent !git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd[[packadd packer.nvim]]

local use = require('packer').use

require('packer').startup(function()
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim', opt = true }

  -- 補完プラグイン
  use {
    "hrsh7th/nvim-cmp", -- LSPによる補完プラグイン
    requires = {
      { "L3MON4D3/LuaSnip", opt = true, event = "VimEnter" },
      { "windwp/nvim-autopairs", opt = true, event = "VimEnter" },
    },
    after = { "LuaSnip", "nvim-autopairs" },
    config = function()
      require("PluginConfig/nvim-cmp")
    end,
  }
  use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
  use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" })

  -- 公式のビルトインLSP設定集
  use {
    "neovim/nvim-lspconfig",
    after = "cmp-nvim-lsp",
    config = function()
      require("PluginConfig/nvim-lspconfig")
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
    config = function()
      require("PluginConfig/telescope")
    end,
  }

  -- スニペット
  use {
    "L3MON4D3/LuaSnip",
    config = function()
      require("PluginConfig/LuaSnip")
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

  -- color scheme
  use {
    'cocopon/iceberg.vim',
    opt = true,
    run = vim.cmd 'colorscheme iceberg' -- iceberg.vimを読み込んだ後にcolorschemeをicebergに変える
  }

  -- easymotion for nvim
  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
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

