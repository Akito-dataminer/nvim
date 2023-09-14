local fn = vim.fn
local cmd = vim.cmd

local util = require("utils")

local lazypath = util.join_paths(util.plugin_dir, "/lazy.nvim")
local lazyurl = "https://github.com/folke/lazy.nvim.git"
local lazy_clone_cmd = { "git", "clone", "--filter=blob:none", lazyurl, "--branch=stable", lazypath }
util.clone_plugin(lazypath, lazyurl, lazy_clone_cmd)
vim.opt.rtp:prepend(lazypath)

local plugin_list = {
  { "vim-denops/denops.vim",   event = 'VimEnter' },
  { 'preservim/nerdcommenter', event = 'InsertEnter' },
  {
    "nvim-treesitter/nvim-treesitter",
    event = 'BufReadPost',
    build = ':TSUpdateSync',
    config = function()
      require("PluginConfig/nvim-treesitter")
    end,
  },
  ----------------
  -- find & jump
  ----------------
  {
    "nvim-telescope/telescope.nvim",
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim', 'ahmedkhalf/project.nvim' },
    config = function()
      require("PluginConfig/telescope")
    end,
  },
  { "ahmedkhalf/project.nvim", },
  {
    'phaazon/hop.nvim',
    event = { "VimEnter" },
    branch = 'v2', -- optional but strongly recommended
    config = function()
      require("PluginConfig/hop")
    end
  },
  ----------------
  -- enclosing behaviors
  ----------------
  { 'tpope/vim-surround',      event = "InsertEnter" },
  { 'windwp/nvim-ts-autotag',  event = "InsertEnter" },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("PluginConfig/nvim-autopairs")
    end,
  },
  ----------------
  -- colorscheme
  ----------------
  {
    'cocopon/iceberg.vim',
    lazy = false,
    config = function()
      cmd([[colorscheme iceberg]])
    end
  },
  ----------------
  -- git
  ----------------
  { 'tpope/vim-fugitive',                  event = 'VimEnter' },
  ------------------
  -- completion
  ------------------
  { "Shougo/pum.vim", },
  { "Shougo/ddc-ui-native", },
  { "Shougo/ddc-ui-pum", },
  { "Shougo/ddc-around", },
  { "Shougo/ddc-matcher_head", },
  { "Shougo/ddc-sorter_rank", },
  { "Shougo/ddc-cmdline", },
  { "Shougo/ddc-cmdline-history", },
  { "Shougo/ddc-converter_remove_overlap", },
  { "Shougo/ddc-line", },
  { "LumaKernel/ddc-file", },
  {
    "uga-rosa/ddc-source-vsnip",
    dependencies = {
      "vim-denops/denops.vim",
      "hrsh7th/vim-vsnip",
    },
  },
  {
    "Shougo/ddc-source-nvim-lsp",
    dependencies = {
      "vim-denops/denops.vim",
      "hrsh7th/vim-vsnip",
    },
    -- config = function()
    --   local capabilities = require("ddc_nvim_lsp").make_client_capabilities()
    --   require("lspconfig").denols.setup({
    --     capabilities = capabilities,
    --   })
    -- end,
  },
  {
    "Shougo/ddc.vim",
    event = 'VeryLazy',
    dependencies = {
      "vim-denops/denops.vim",
      -- UIs
      "Shougo/pum.vim",
      "Shougo/ddc-ui-pum",
      "Shougo/ddc-ui-native",
      -- sources
      "Shougo/ddc-around",
      "Shougo/ddc-matcher_head",
      "Shougo/ddc-sorter_rank",
      "Shougo/ddc-cmdline",
      "Shougo/ddc-cmdline-history",
      "Shougo/ddc-converter_remove_overlap",
      "Shougo/ddc-line",
      "LumaKernel/ddc-file",
      "uga-rosa/ddc-source-vsnip",
      "Shougo/ddc-source-nvim-lsp",
    },
    config = function()
      require("PluginConfig/ddc/ddc")
    end,
  },
  {
    "vim-skk/skkeleton",
    dependencies = {
      "vim-denops/denops.vim",
      "Shougo/ddc.vim",
    },
    event = 'VeryLazy',
    config = function()
      require("PluginConfig/skkeleton")
    end,
  },
  -- { "Matts966/skk-vconv.vim", after = { "ddc.vim", "skkeleton" }, },
  ------------------
  -- lsp
  ------------------
  {
    "neovim/nvim-lspconfig",
    event = 'BufReadPost',
    dependencies = {
      "williamboman/mason.nvim",
      "Shougo/ddc-source-nvim-lsp",
    },
    config = function()
      require("PluginConfig/nvim-lspconfig")
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("PluginConfig/mason")
    end
  },
  ------------------
  -- Snippet
  ------------------
  {
    "hrsh7th/vim-vsnip",
    event = 'InsertEnter',
    config = function()
      require("PluginConfig/vsnip")
    end,
  },
  ------------------
  -- for markdown
  ------------------
  {
    'preservim/vim-markdown',
    event = 'VeryLazy',
  },
  {
    'tyru/open-browser.vim',
  },
  {
    'previm/previm',
    dependencies = { 'tyru/open-browser.vim' },
    lazy = false,
  },
}

require("lazy").setup(plugin_list, {
  root = util.plugin_dir,
  defaults = {
    lazy = true, -- should plugins be lazy-loaded?
  },
  lockfile = util.join_paths(vim.fn.stdpath("config"), "/lazy-lock.json"),
})
