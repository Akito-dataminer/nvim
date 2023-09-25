local opt = vim.opt

require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = "all",
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  auto_install = false,
  indent = {
    enable = true
  },
  autotag = {
    enable = true,
  }
  -- pairs = {
  --   enable = false,
  --   disable = {},
  --   highlight_pair_events = { "CursorMoved" }, -- when to highlight the pairs, use {} to deactivate highlighting
  --   highlight_self = true,
  --   goto_right_end = false, -- whether to go to the end of the right partner or the beginning
  --   fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
  --   keymaps = { goto_partner = "'%" },
  -- },
}

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
