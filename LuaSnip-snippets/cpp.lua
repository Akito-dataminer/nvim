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

ls.add_snippets("cpp", {
  s("class", {
    t({"class "}), i(1), t({" {"}),
    t({"", "private:"}),
    t({"", "public:"}),
    t({"", "\t"}), f(copy, 1), t({"();"}),
    t({"", "\t"}), t({"~"}), f(copy, 1), t({"();"}),
    t({"", "};"}),
  }),
  s("copy-ctor", {
    i(1, {"CLASS_NAME"}), t({"( const "}), f(copy, 1), t({" & rhs )"}), i(0),
  }),
  s("copy-assignment-operator", {
    i(1, {"CLASS_NAME"}), t({" & operator = ( const "}), f(copy, 1), t({" & rhs )"}), i(0),
  }),
  s("move-ctor", {
    i(1, {"CLASS_NAME"}), t({"( "}), f(copy, 1), t({" && rhs )"}), i(0),
  }),
  s("move-assignment-operator", {
    i(1, {"CLASS_NAME"}), t({" & operator = ( "}), f(copy, 1), t({" && rhs )"}), i(0),
  }),
}, {
    key = "cpp",
  })
