local aerial = require("aerial")
local keymaps = {
  ["aerial"] = {
    ["?"] = "actions.show_help",
    ["<CR>"] = function()
      aerial.select()
      aerial.open({ focus = false, direction = "float" })
    end,
    ["<Esc>"] = function()
      aerial.close()
      aerial.open({ focus = false, direction = "float" })
    end,
    ["<C-v>"] = "actions.jump_vsplit",
    ["<C-s>"] = "actions.jump_split",
    ["p"] = "actions.scroll",
    ["<C-j>"] = "actions.down_and_scroll",
    ["<C-k>"] = "actions.up_and_scroll",
    ["<Down>"] = "actions.down_and_scroll",
    ["<Up>"] = "actions.up_and_scroll",
    ["{"] = false,
    ["}"] = false,
    ["("] = "actions.prev",
    [")"] = "actions.next",
    ["[["] = "actions.prev_up",
    ["]]"] = "actions.next_up",
    ["q"] = "actions.close",
    ["o"] = "actions.tree_toggle",
    ["za"] = "actions.tree_toggle",
    ["O"] = "actions.tree_toggle_recursive",
    ["zA"] = "actions.tree_toggle_recursive",
    ["l"] = "actions.tree_open",
    ["zo"] = "actions.tree_open",
    ["L"] = "actions.tree_open_recursive",
    ["zO"] = "actions.tree_open_recursive",
    ["h"] = "actions.tree_close",
    ["zc"] = "actions.tree_close",
    ["H"] = "actions.tree_close_recursive",
    ["zC"] = "actions.tree_close_recursive",
    ["zr"] = "actions.tree_increase_fold_level",
    ["zR"] = "actions.tree_open_all",
    ["zm"] = "actions.tree_decrease_fold_level",
    ["zM"] = "actions.tree_close_all",
    ["zx"] = "actions.tree_sync_folds",
    ["zX"] = "actions.tree_sync_folds",
    ["<2-LeftMouse>"] = false,
  },
  ["nav"] = {
    ["<CR>"] = "actions.jump",
    ["<C-v>"] = "actions.jump_vsplit",
    ["<C-s>"] = "actions.jump_split",
    ["h"] = "actions.left",
    ["l"] = "actions.right",
    ["q"] = "actions.close",
  },
  ["on_attach"] = {
    ["("] = aerial.prev,
    [")"] = aerial.next,
    ["[["] = aerial.prev_up,
    ["]]"] = aerial.next_up,
  },
}

require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- for key, maybeExcutable in pairs(keymaps["on_attach"]) do
    for key, action in pairs(keymaps["on_attach"]) do
      -- local action = type(maybeExcutable == 'string' and )
      vim.keymap.set("n", key, action, { buffer = bufnr })
    end
    vim.keymap.set("n", "<Space>ai", function()
      local is_open = aerial.is_open({ bufnr = bufnr })
      if is_open == true then
        aerial.focus()
      else
        aerial.open({ focus = true }, { direction = "float" })
      end
    end, { buffer = bufnr })
  end,

  layout = {
    -- These control the width of the aerial window.
    -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a list of mixed types.
    -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
    max_width = { 40, 0.2 },
    width = nil,
    min_width = 10,

    -- key-value pairs of window-local options for aerial window (e.g. winhl)
    win_opts = {},

    -- Determines the default direction to open the aerial window. The 'prefer'
    -- options will open the window in the other direction *if* there is a
    -- different buffer in the way of the preferred direction
    -- Enum: prefer_right, prefer_left, right, left, float
    default_direction = "float",

    -- When the symbols change, resize the aerial window (within min/max constraints) to fit
    resize_to_content = true,

    -- Preserve window size equality with (:help CTRL-W_=)
    preserve_equality = false,
  },

  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
    "Variable",
  },

  float = {
    relative = "win",
    override = function(conf, source_winid)
      local padding = 1
      conf.anchor = "NE"
      conf.row = padding
      conf.col = vim.api.nvim_win_get_width(source_winid) - padding
      return conf
    end,
  },

  -- Determines how the aerial window decides which buffer to display symbols for
  --   window - aerial window will display symbols for the buffer in the window from which it was opened
  --   global - aerial window will display symbols for the current window
  attach_mode = "window",

  -- List of enum values that configure when to auto-close the aerial window
  --   unfocus       - close aerial when you leave the original source window
  --   switch_buffer - close aerial when you change buffers in the source window
  --   unsupported   - close aerial when attaching to a buffer that has no symbol source
  close_automatic_events = { "unsupported" },

  keymaps = keymaps["aerial"],

  -- When true, don't load aerial until a command or function is called
  -- Defaults to true, unless `on_attach` is provided, then it defaults to false
  lazy_load = false,

  nav = {
    keymaps = keymaps["nav"],
  },
})

vim.keymap.set("n", "<Space>ax", "<cmd>AerialToggle!<CR>")
vim.keymap.set("n", "<Space>an", "<cmd>AerialNavToggle<CR>")
