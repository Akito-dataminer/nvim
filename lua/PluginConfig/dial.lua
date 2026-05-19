local keymap = vim.keymap

local augend = require("dial.augend")

-- in Japanese
local japanese_weekdays = augend.constant.new({
  elements = {
    "月",
    "火",
    "水",
    "木",
    "金",
    "土",
    "日",
  },
  word = false,
  cyclic = true,
})
local japanese_weekdays_full = augend.constant.new({
  elements = {
    "月曜日",
    "火曜日",
    "水曜日",
    "木曜日",
    "金曜日",
    "土曜日",
    "日曜日",
  },
  word = true,
  cyclic = true,
})

-- in English
local english_weekdays_lower = augend.constant.new({
  elements = {
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  },
  word = true,
  cyclic = true,
})
local english_weekdays_upper = augend.constant.new({
  elements = {
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  },
  word = true,
  cyclic = true,
})
local english_weekdays_short_lower = augend.constant.new({
  elements = {
    "mon",
    "tue",
    "wed",
    "thu",
    "fri",
    "sat",
    "sun",
  },
  word = true,
  cyclic = true,
})
local english_weekdays_short_upper = augend.constant.new({
  elements = {
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  },
  word = true,
  cyclic = true,
})

local markdown_header = augend.user.new({
  find = require("dial.augend.common").find_pattern("^#+"),
  add = function(text, addend, cursor)
    local current_level = #text
    local new_level = math.max(1, math.min(6, current_level + addend))
    local new_text = string.rep("#", new_level)
    return {
      text = new_text,
      cursor = cursor + (new_level - current_level),
    }
  end,
})

require("dial.config").augends:register_group({
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.integer.alias.binary,
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%m/%d"],
    augend.constant.alias.bool,

    -- day of the week
    japanese_weekdays,
    japanese_weekdays_full,
    english_weekdays_lower,
    english_weekdays_upper,
    english_weekdays_short_lower,
    english_weekdays_short_upper,

    -- header level on Markdown
    markdown_header,
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
