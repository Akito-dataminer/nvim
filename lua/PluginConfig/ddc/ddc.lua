local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local log = vim.log
local utils = require("utils")
local ddc_conf = require("PluginConfig/ddc/helper")

----------------
-- configs
----------------
local ddc_sources = { "vsnip", "lsp", "file", "around" }
local ddc_ui = "pum"
local cmdline_sources = {
  [":"] = { "cmdline_history", "cmdline", "around" },
  ["@"] = { "cmdline_history", "file", "around" },
  [">"] = { "cmdline_history", "file", "around" },
  ["/"] = { "around", "line" },
  ["?"] = { "around", "line" },
  ["-"] = { "around", "line" },
}
local auto_complete_events = {
  "InsertEnter",
  "TextChangedI",
  "TextChangedP",
  "CmdlineEnter",
  "CmdlineChanged",
  "TextChangedT",
}
local source_options = {
  _ = {
    ignoreCase = true,
    matchers = { "matcher_head" },
    sorters = { "sorter_rank" },
    dup = "keep",
  },
  ["around"] = {
    mark = "A",
    matchers = { "matcher_head" },
    dup = "keep",
  },
  ["cmdline"] = {
    mark = "cmdline",
    forceCompletionPattern = "\\S/\\S*",
    dup = "keep",
  },
  ["cmdline_history"] = {
    mark = "history",
    sorters = { "sorter_rank" },
  },
  ["file"] = {
    mark = "F",
    isVolatile = true,
    forceCompletionPattern = "\\S/\\S*",
  },
  ["vsnip"] = {
    mark = "SNIP",
    keywordPattern = "\\S*",
    dup = "keep",
  },
  ["lsp"] = {
    mark = "LSP",
    forceCompletionPattern = "\\.\\w*|::\\w*|->\\w*",
    sorters = { "sorter_rank" },
    dup = "keep",
  },
}
local source_params = {
  ["lsp"] = {
    snippetEngine = fn["denops#callback#register"](function(body)
      fn["vsnip#anonymous"](body)
    end),
    enableResolveItem = true,
    enableAdditionalTextEdit = true,
    confirmBehavior = "replace",
  },
}
local pum_option = {
  item_orders = { "menu", "space", "abbr", "space", "kind" },
  scrollbar_char = "┃",
}

----------------
-- keymaps
----------------
local ddc_keymaps = {
  {
    mode = { "i", "c" },
    key_pattern = "<C-n>",
    action = function()
      fn["pum#map#insert_relative"](1)
    end,
    option = { noremap = true, silent = true },
  },
  {
    mode = { "i", "c" },
    key_pattern = "<Down>",
    action = function()
      fn["pum#map#insert_relative"](1)
    end,
    option = { noremap = true, silent = true },
  },
  {
    mode = { "i", "c" },
    key_pattern = "<C-p>",
    action = function()
      fn["pum#map#insert_relative"](-1)
    end,
    option = { noremap = true, silent = true },
  },
  {
    mode = { "i", "c" },
    key_pattern = "<Up>",
    action = function()
      fn["pum#map#insert_relative"](-1)
    end,
    option = { noremap = true, silent = true },
  },
  {
    mode = { "i", "c" },
    key_pattern = "<C-y>",
    action = function()
      fn["pum#map#confirm"]()
    end,
    option = { noremap = true, silent = true },
  },
  {
    mode = { "i", "c" },
    key_pattern = "<C-c>",
    action = function()
      fn["pum#map#cancel"]()
    end,
    option = { noremap = true, silent = true },
  },
}
utils.add_keymaps(ddc_keymaps)

local function start_cmdline(key)
  -- Enable command line completion for next command line session
  ddc_conf.enable_cmdline()
  fn.feedkeys(api.nvim_replace_termcodes(key, true, true, true), "n")
end

local function set_cmdline(keys)
  if type(keys) ~= "table" then
    vim.notify("[ddc-config]key has to be table", log.levels.ERROR)
  end

  for _, k in ipairs(keys) do
    keymap.set("n", k, function()
      start_cmdline(k)
    end, { noremap = true, silent = true })
  end
end

set_cmdline({ ":", "/", "?" })

----------------
-- apply configs
----------------
ddc_conf.patch_global("ui", ddc_ui)
ddc_conf.patch_global("sources", ddc_sources)
ddc_conf.patch_global("cmdlineSources", cmdline_sources)
ddc_conf.patch_global("autoCompleteEvents", auto_complete_events)
ddc_conf.patch_global("sourceOptions", source_options)
ddc_conf.patch_global("sourceParams", source_params)
fn["pum#set_option"](pum_option)

-- Enable ddc completion
ddc_conf.enable()
