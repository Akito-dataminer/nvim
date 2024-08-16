local api = vim.api

local hop = require("hop")

-- you can configure Hop the way you like here; see :h hop-config
hop.setup({ keys = "etovxqpdygfblzhckisuran" })

-- place this in one of your configuration file(s)
api.nvim_set_keymap("n", "[hop]", "<Nop>", { noremap = true, silent = true })
api.nvim_set_keymap("v", "[hop]", "<Nop>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<Space>o", "[hop]", {})
api.nvim_set_keymap("v", "<Space>o", "[hop]", {})

-- Normal Mode
local hint = require("hop.hint")

for k, v in pairs({
  ["[hop]w"] = hop.hint_words,
  ["[hop]e"] = function()
    hop.hint_words({ hint_position = hint.HintPosition.END })
  end,
  ["[hop]0"] = hop.hint_lines,
  ["[hop]k"] = function()
    hop.hint_vertical({ direction = hint.HintDirection.BEFORE_CURSOR })
  end,
  ["[hop]j"] = function()
    hop.hint_vertical({ direction = hint.HintDirection.AFTER_CURSOR })
  end,
  ["[hop]lk"] = function()
    hop.hint_lines({ direction = hint.HintDirection.BEFORE_CURSOR })
  end,
  ["[hop]lj"] = function()
    hop.hint_lines({ direction = hint.HintDirection.AFTER_CURSOR })
  end,
  ["[hop]/"] = hop.hint_patterns,
  ["[hop]r"] = hop.hint_char1,
  ["[hop]h"] = hop.hint_char2,
  ["f"] = function()
    hop.hint_char1({ direction = hint.HintDirection.AFTER_CURSOR, current_line_only = true })
  end,
  ["F"] = function()
    hop.hint_char1({ direction = hint.HintDirection.BEFORE_CURSOR, current_line_only = true })
  end,
  ["t"] = function()
    hop.hint_char1({ direction = hint.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
  end,
  ["T"] = function()
    hop.hint_char1({ direction = hint.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
  end,
}) do
  vim.keymap.set("", k, v)
end
