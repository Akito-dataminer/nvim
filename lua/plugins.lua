-- local fn = vim.fn
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
  { 'tpope/vim-surround' },
  { 'windwp/nvim-ts-autotag', },
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
  { "Shougo/pum.vim",                      event = 'InsertEnter' },
  { "Shougo/ddc-ui-native",                event = 'InsertEnter' },
  { "Shougo/ddc-ui-pum",                   event = 'InsertEnter' },
  { "Shougo/ddc-around",                   event = 'InsertEnter' },
  { "Shougo/ddc-matcher_head",             event = 'InsertEnter' },
  { "Shougo/ddc-sorter_rank",              event = 'InsertEnter' },
  { "Shougo/ddc-cmdline",                  event = 'InsertEnter' },
  { "Shougo/ddc-cmdline-history",          event = 'InsertEnter' },
  { "Shougo/ddc-converter_remove_overlap", event = 'InsertEnter' },
  { "Shougo/ddc-line",                     event = 'InsertEnter' },
  { "LumaKernel/ddc-file",                 event = 'InsertEnter' },
  {
    "Shougo/ddc.vim",
    event = 'InsertEnter',
    dependencies = {
      "vim-denops/denops.vim",
      "Shougo/pum.vim",
      "Shougo/ddc-ui-pum",
    },
    config = function()
      require("PluginConfig/ddc/ddc")
    end,
  },
  {
    "uga-rosa/ddc-source-vsnip",
    event = 'InsertEnter',
    dependencies = {
      "Shougo/ddc.vim",
      "hrsh7th/vim-vsnip",
    },
  },
  {
    "Shougo/ddc-source-nvim-lsp",
    event = 'InsertEnter',
    dependencies = { "ddc.vim", },
    config = function()
      local capabilities = require("ddc_nvim_lsp").make_client_capabilities()
      require("lspconfig").denols.setup({
        capabilities = capabilities,
      })
    end,
  },
  {
    "vim-skk/skkeleton",
    dependencies = { "vim-denops/denops.vim" },
    event = { 'InsertEnter' },
    config = function()
      require("PluginConfig/skkeleton")
    end,
  },
  { "Matts966/skk-vconv.vim", after = { "ddc.vim", "skkeleton" }, },
  ------------------
  -- lsp
  ------------------
  {
    "neovim/nvim-lspconfig",
    event = 'BufReadPost',
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
  { 'preservim/vim-markdown' },
  { 'previm/previm' },
}

require("lazy").setup(plugin_list, {
  root = util.plugin_dir,
  defaults = {
    lazy = true, -- should plugins be lazy-loaded?
  },
  lockfile = util.join_paths(vim.fn.stdpath("config"), "/lazy-lock.json"),
})
