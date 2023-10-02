-- Utilities for creating configurations
local formatter_util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    python = require("formatter.filetypes.python").black,
  }
}

local util = require("utils")
local fn = vim.fn
local api = vim.api

local format_keymap = {
  {
    mode = { 'n' },
    key_pattern = '<space>f',
    action = function()
      fn.feedkeys(api.nvim_replace_termcodes(':Format<CR>', true, true, true), fn.mode())
    end,
    option = { noremap = true, silent = true }
  }
}

util.add_keymaps( format_keymap )
