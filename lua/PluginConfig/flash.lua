local api = vim.api
local fn = vim.fn

local M = {}

api.nvim_set_keymap("n", "[flash]", "<Nop>", { noremap = true, silent = true })
api.nvim_set_keymap("x", "[flash]", "<Nop>", { noremap = true, silent = true })
api.nvim_set_keymap("o", "[flash]", "<Nop>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "\\", "[flash]", {})
api.nvim_set_keymap("x", "\\", "[flash]", {})
api.nvim_set_keymap("o", "\\", "[flash]", {})

-- 前提: Lazy.nvimのkeysから参照される。
M.keys = {
  {
    "[flash]w",
    mode = { "n", "x", "o" },
    function()
      require("flash").jump()
    end,
    desc = "Flash",
  },
  {
    "[flash]W",
    mode = { "n", "x", "o" },
    function()
      require("flash").treesitter()
    end,
    desc = "Flash Treesitter",
  },
  {
    "[flash]r",
    mode = "o",
    function()
      require("flash").remote()
    end,
    desc = "Remote Flash",
  },
  {
    "[flash]R",
    mode = { "o", "x" },
    function()
      require("flash").treesitter_search()
    end,
    desc = "Treesitter Search",
  },
  -- {
  --   "<c-s>",
  --   mode = "c",
  --   function() require("flash").toggle() end,
  --   desc = "Toggle Flash Search",
  -- },
  -- kensakuによる日本語も含めたジャンプ
  {
    "[flash];",
    mode = { "n", "x", "o" },
    function()
      require("flash").jump({
        search = {
          mode = function(str)
            return fn["kensaku#query"](str)
          end,
        },
      })
    end,
    desc = "Flash (Kensaku: JP jump)",
  },
}

function M.setup()
  local ok, flash = pcall(require, "flash")
  if not ok then
    return
  end

  flash.setup({
    search = {
      multi_window = true,
      wrap = true,
    },
  })
end

return M
