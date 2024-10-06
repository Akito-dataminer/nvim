local cmd = vim.cmd

local util = require("utils")

local lazypath = util.join_paths(util.plugin_dir, "/lazy.nvim")
local lazyurl = "https://github.com/folke/lazy.nvim.git"
local lazy_clone_cmd = { "git", "clone", "--filter=blob:none", lazyurl, "--branch=stable", lazypath }
util.clone_plugin(lazypath, lazyurl, lazy_clone_cmd)
vim.opt.rtp:prepend(lazypath)

local plugin_list = {
  { "vim-denops/denops.vim", event = "VimEnter" },
  { "preservim/nerdcommenter", event = "InsertEnter" },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
    build = ":TSUpdateSync",
    dependencies = { "windwp/nvim-ts-autotag" },
    config = function()
      require("PluginConfig/nvim-treesitter")
    end,
  },
  ----------------
  -- find & jump
  ----------------
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim", "ahmedkhalf/project.nvim" },
    config = function()
      require("PluginConfig/telescope")
    end,
  },
  { "ahmedkhalf/project.nvim" },
  {
    "smoka7/hop.nvim",
    event = { "VimEnter" },
    version = "*",
    opts = {},
    config = function()
      require("PluginConfig/hop")
    end,
  },
  -- For Japanese
  {
    "lambdalisue/kensaku.vim",
    event = { "VimEnter" },
    dependencies = { "vim-denops/denops.vim" },
  },
  {
    "lambdalisue/kensaku-search.vim",
    event = { "VimEnter" },
    dependencies = { "vim-denops/denops.vim", "lambdalisue/kensaku.vim" },
    config = function()
      vim.keymap.set("c", "<CR>", "<Plug>(kensaku-search-replace)<CR>")
    end,
  },
  {
    "yuki-yano/fuzzy-motion.vim",
    dependencies = { "vim-denops/denops.vim", "lambdalisue/kensaku.vim" },
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<Space>/", "<cmd>FuzzyMotion<CR>")
      vim.g.fuzzy_motion_matchers = { "kensaku", "fzf" }
    end,
  },
  ----------------
  -- enclosing behaviors
  ----------------
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    version = false,
    config = function()
      require("PluginConfig.mini-surround")
    end,
  },
  -- { 'tpope/vim-surround',      event = "InsertEnter" },
  { "windwp/nvim-ts-autotag" },
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
    "cocopon/iceberg.vim",
    lazy = false,
    config = function()
      cmd([[colorscheme iceberg]])
    end,
  },
  ----------------
  -- git
  ----------------
  { "tpope/vim-fugitive", event = "VimEnter" },
  {
    "lewis6991/gitsigns.nvim",
    event = "VimEnter",
    config = function()
      require("PluginConfig.gitsigns")
    end,
  },
  ------------------
  -- completion
  ------------------
  { "Shougo/pum.vim" },
  { "Shougo/ddc-ui-native" },
  { "Shougo/ddc-ui-pum" },
  { "Shougo/ddc-around" },
  { "Shougo/ddc-matcher_head" },
  { "Shougo/ddc-sorter_rank" },
  { "Shougo/ddc-cmdline" },
  { "Shougo/ddc-cmdline-history" },
  { "Shougo/ddc-converter_remove_overlap" },
  { "Shougo/ddc-line" },
  { "LumaKernel/ddc-file" },
  {
    "uga-rosa/ddc-source-vsnip",
    dependencies = {
      "vim-denops/denops.vim",
      "hrsh7th/vim-vsnip",
    },
  },
  {
    "Shougo/ddc-source-lsp",
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
    event = "VeryLazy",
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
      "Shougo/ddc-source-lsp",
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
    event = "VimEnter",
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
    event = "BufReadPost",
    dependencies = {
      "williamboman/mason.nvim",
      "Shougo/ddc-source-lsp",
      "mhartington/formatter.nvim",
    },
    config = function()
      require("PluginConfig/nvim-lspconfig")
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
    },
    config = function()
      require("PluginConfig/mason")
    end,
  },
  {
    "mhartington/formatter.nvim",
    event = "BufReadPost",
    config = function()
      require("PluginConfig.formatter")
    end,
  },
  ------------------
  -- Snippet
  ------------------
  {
    "hrsh7th/vim-vsnip",
    event = "InsertEnter",
    config = function()
      require("PluginConfig/vsnip")
    end,
  },
  ------------------
  -- for markdown
  ------------------
  {
    "preservim/vim-markdown",
    event = "VeryLazy",
  },
  {
    "tyru/open-browser.vim",
  },
  {
    "previm/previm",
    dependencies = { "tyru/open-browser.vim" },
    lazy = false,
  },
}

require("lazy").setup(plugin_list, {
  root = util.plugin_dir,
  defaults = {
    lazy = true, -- should plugins be lazy-loaded?
  },
  lockfile = util.join_paths(vim.fn.stdpath("config"), "lazy-lock.json"),
})
