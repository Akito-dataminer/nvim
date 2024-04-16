---- HELPERS ----
local api = vim.api
local fn = vim.fn
local vg = vim.g
local cmd = vim.cmd

local utils = require("utils")

-- configure the snippet directory
local data_path = fn.stdpath("data")
local vsnip_dir = utils.join_paths(data_path, ".vsnip")
vg.vsnip_snippet_dir = vsnip_dir

-- Key Mappings
api.nvim_create_autocmd("InsertEnter", {
  callback = function(ev)
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      return vim.fn["vsnip#jumpable"](1) == 1 and "<Plug>(vsnip-jump-next)" or "<Tab>"
    end, { expr = true, noremap = false })
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      return vim.fn["vsnip#jumpable"](-1) == 1 and "<Plug>(vsnip-jump-prev)" or "<S-Tab>"
    end, { expr = true, noremap = false })
  end,
})

-- local function termcode(str)
--   return api.nvim_replace_termcodes(str, true, true, true)
-- end
