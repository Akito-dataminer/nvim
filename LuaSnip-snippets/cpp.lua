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

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
  return args[1]
end

ls.add_snippets("cpp", {
  s("class", {
    t({"class "}), i(1),
    c(2, {
      t(""),
      sn( nil, { t(" : "), i(1) } ),
    } ), t({" {"}),
    t({"", "public:"}),
    t({"", "\t"}), f(copy, 1), t({"();"}),
    t({"", "\t"}), t({"~"}), f(copy, 1), t({"();"}),
    t({"", ""}),
    t({"", "private:"}),
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
