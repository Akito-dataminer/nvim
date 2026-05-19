local keymap = vim.keymap

local augend = require("dial.augend")
require("dial.config").augends:register_group({
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.integer.alias.binary,
    augend.date.alias["%Y/%m/%d"],
    augend.constant.alias.bool,
    augend.constant.alias.alpha,
    augend.constant.alias.Alpha,
  },
})

keymap.set("n", "<C-a>", function()
  require("dial.map").manipulate("increment", "normal")
end)
keymap.set("n", "<C-x>", function()
  require("dial.map").manipulate("decrement", "normal")
end)
keymap.set("n", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gnormal")
end)
keymap.set("n", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gnormal")
end)
keymap.set("v", "<C-a>", function()
  require("dial.map").manipulate("increment", "visual")
end)
keymap.set("v", "<C-x>", function()
  require("dial.map").manipulate("decrement", "visual")
end)
keymap.set("v", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gvisual")
end)
keymap.set("v", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gvisual")
end)
