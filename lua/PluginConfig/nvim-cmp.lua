---- HELPERS ----
local api = vim.api
local fn = vim.fn
local g = vim.g      -- a table to access global variables
local opt = vim.opt

-- `termcodes` 専用の `tc` 関数です
-- この名前で呼ばなくてもいいですが、この簡潔さが便利です
local function tc(str)
    -- 必要に応じてboolean引数で調整します
    return api.nvim_replace_termcodes(str, true, true, true)
end

---------------------------------
---- lsp-cmp series settings ----
---------------------------------
opt.completeopt = 'menu,menuone,noselect'

local luasnip = require('luasnip')
local cmp = require'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-b>"] = cmp.mapping( cmp.mapping.scroll_docs(-4), { 'i', 'c' } ),
    ["<C-f>"] = cmp.mapping( cmp.mapping.scroll_docs(4), { 'i', 'c' } ),
    ["<C-Space>"] = cmp.mapping( cmp.mapping.complete(), { 'i', 'c' } ),
    ["<C-e>"] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },

    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "treesitter" },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
      { name = "buffer" },
    }),
})

cmp.setup.cmdline('/', {
  mapping = {
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "c" }),

    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "c" }),

    ["<C-Space>"] = {
      c = cmp.mapping.confirm({ select = false }),
    },

    ["<C-q>"] = {
      c = cmp.mapping.abort(),
    },
  },
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(":", {
  mapping = {
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "c" }),

    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "c" }),

    ["<C-Space>"] = {
      c = cmp.mapping.confirm({ select = false }),
    },

    ["<C-q>"] = {
      c = cmp.mapping.abort(),
    },
  },
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

-- autopairs
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
