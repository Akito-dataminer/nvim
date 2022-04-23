local ls = require("luasnip")
local types = require("luasnip.util.types")

-- If you're reading this file for the first time, best skip to around line 190
-- where the actual snippet-definitions start.

-- Every unspecified option will be set to the default.
ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = "TextChanged,TextChangedI",
	-- Snippets aren't automatically removed if their text is deleted.
	-- `delete_check_events` determines on which events (:h events) a check for
	-- deleted snippets is performed.
	-- This can be especially useful when `history` is enabled.
	delete_check_events = "TextChanged",
	ext_opts = { [types.choiceNode] = { active = { virt_text = { { "choiceNode", "Comment" } } } } },
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	enable_autosnippets = true,
	-- mapping for cutting selected text so it's usable as SELECT_DEDENT,
	-- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
	store_selection_keys = "<Tab>",
	-- luasnip uses this function to get the currently active filetype. This
	-- is the (rather uninteresting) default, but it's possible to use
	-- eg. treesitter for getting the current filetype by setting ft_func to
	-- require("luasnip.extras.filetype_functions").from_cursor (requires
	-- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
	-- the current filetype in eg. a markdown-code block or `vim.cmd()`.
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})

-- in a cpp file: search cpp-snippets, c-snippets, then all-snippets.
ls.filetype_extend("cpp", { "c" })

require("luasnip.loaders.from_lua").lazy_load({ paths = "./LuaSnip-snippets" })
require("luasnip.loaders.from_lua").lazy_load({ paths = "./non-program-snippets" })

-- You can also use lazy loading so snippets are loaded on-demand, not all at once (may interfere with lazy-loading luasnip itself).
-- require("luasnip.loaders.from_vscode").lazy_load() -- You can pass { paths = "./my-snippets/"} as well
-- require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/nvim/vscode-snippets" } }) -- You can pass { paths = "./my-snippets/"} as well

-- You can also use snippets in snipmate format, for example <https://github.com/honza/vim-snippets>.
-- The usage is similar to vscode.

-- One peculiarity of honza/vim-snippets is that the file with the global snippets is _.snippets, so global snippets
-- are stored in `ls.snippets._`.
-- We need to tell luasnip that "_" contains global snippets:
ls.filetype_extend("all", { "_" })

-- require("luasnip.loaders.from_snipmate").load({include = {"c"}}) -- Load only python snippets

-- require("luasnip.loaders.from_snipmate").load({path = {"./my-snippets"}}) -- Load snippets from my-snippets folder
-- If path is not specified, luasnip will look for the `snippets` directory in rtp (for custom-snippet probably
-- `~/.config/nvim/snippets`).

-- require("luasnip.loaders.from_snipmate").lazy_load() -- Lazy loading

-- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
-- vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
-- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
-- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
-- vim.api.nvim_set_keymap("i", "<C-Down>", "<Plug>luasnip-next-choice", {})
-- vim.api.nvim_set_keymap("s", "<C-Down>", "<Plug>luasnip-next-choice", {})
