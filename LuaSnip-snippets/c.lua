local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
  return args[1]
end

ls.add_snippets("c", {
  s({trig = "comment_block_short"}, {
    t({"/* "}), i(1), t({" */"}),
  }),
  s({trig = "comment_block"}, {
    t({"/****************************************"}),
    t({"", " * "}), i(1),
    t({"", " ****************************************/"}),
  }),
  s({trig = "ipv4_config"}, {
    i(1, {"sockaddr_in"}), t({".sin_family = AF_INET;"}),
    t({"", ""}), f(copy, 1), t({".sin_port = htons("}), i(2), t({");"}),
    t({"", ""}), f(copy, 1), t({".sin_addr.S_un.S_addr = "}), i(3), t({";"}),
    i(0),
  }),
}, {
    key = "c",
  })

