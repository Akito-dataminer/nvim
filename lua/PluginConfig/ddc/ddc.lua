local api = vim.api
local fn = vim.fn
local g = vim.g
local utils = require('utils')
local ddc_conf = require('PluginConfig/ddc/helper')

----------------
-- configs
----------------
local ddc_sources = { 'vsnip', 'nvim-lsp', 'file', 'around' }
local ddc_ui = 'pum'
local cmdline_sources = {
  [':'] = { 'cmdline-history', 'cmdline', 'around' },
  ['@'] = { 'cmdline-history', 'input', 'file', 'around' },
  ['>'] = { 'cmdline-history', 'input', 'file', 'around' },
  ['/'] = { 'around', 'line' },
  ['?'] = { 'around', 'line' },
  ['-'] = { 'around', 'line' },
  ['='] = { 'input' },
}
local auto_complete_events = {
  'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineEnter', 'CmdlineChanged', 'TextChangedT'
}
local source_options = {
  _ = {
    ignoreCase = true,
    matchers = { 'matcher_head' },
    sorters = { 'sorter_rank' },
    dup = 'force'
  },
  ['around'] = {
    mark = 'A',
    matchers = { 'matcher_head' },
  },
  ['cmdline'] = {
    mark = 'cmdline',
    forceCompletionPattern = '\\S/\\S*',
    dup = 'force'
  },
  ['cmdline-history'] = {
    mark = 'history',
    sorters = { 'sorter_rank' },
  },
  ['file'] = {
    mark = 'F',
    isVolatile = true,
    forceCompletionPattern = '\\S/\\S*',
  },
  ['vsnip'] = {
    mark = 'SNIP',
    keywordPattern = "\\S*",
    dup = 'keep',
  },
  ['nvim-lsp'] = {
    mark = 'LSP',
    forceCompletionPattern = '\\.\\w*|::\\w*|->\\w*',
    sorters = { 'sorter_lsp-kind' },
    dup = 'force',
  },
  ['skkeleton'] = {
    mark = 'SKK',
    matchers = 'skkeleton',
    sorters = {},
    minAutoCompleteLength = 2,
    isVolatile = true,
  },
}
local source_params = {
  ['nvim-lsp'] = {
    snippetEngine = fn["denops#callback#register"](function(body) fn["vsnip#anonymous"](body) end),
    enableResolveItem = true,
    enableAdditionalTextEdit = true,
    confirmBehavior = 'replace',
  }
}
local pum_option = {
  item_orders = { "menu", "space", "abbr", "space", "kind", },
  scrollbar_char = "┃",
}

----------------
-- keymaps
----------------
local ddc_keymaps = {
  {
    mode = { 'i', 'c' },
    key_pattern = '<C-n>',
    action = function()
      if fn['pum#visible']() == true then
        fn['pum#map#insert_relative'](1)
      else
        fn['ddc#map#manual_complete']()
        -- fn.nr2char(vim.opt.wildcharm)
        -- if fn.exests('b:ddc_cmdline_completion') == true then
        -- else
        --   fn.nr2char(vim.opt.wildcharm)
        -- end
      end
    end,
    option = { noremap = true, silent = true }
  },
  {
    mode = { 'i', 'c' },
    key_pattern = '<C-p>',
    action = function() fn['pum#map#insert_relative'](-1) end,
    option = { noremap = true, silent = true }
  },
  {
    mode = { 'i', 'c' },
    key_pattern = '<Tab>',
    action = function()
      if fn['vsnip#jumpable'](1) == 1 then
        fn['<Plug>(vsnip-jump-next)']()
      else
        fn['<Tab>']()
      end
    end,
    option = { noremap = true, silent = true },
  },
  {
    mode = { 'i', 'c' },
    key_pattern = '<S-Tab>',
    action = function()
      if (fn['vsnip#jumpable'](-1) == 1) then
        fn['<Plug>(vsnip-jump-prev)']()
      else
        fn['<S-Tab>']()
      end
    end,
    option = { noremap = true, silent = true },
  },
  {
    mode = { 'i', 'c' },
    key_pattern = '<C-y>',
    action = function() fn['pum#map#confirm']() end,
    option = { noremap = true, silent = true }
  },
  {
    mode = { 'i', 'c' },
    key_pattern = '<C-c>',
    action = function() fn['pum#map#cancel']() end,
    option = { noremap = true, silent = true }
  },
}
utils.add_keymaps(ddc_keymaps)

local commandLinePost = function()
  vim.keymap.del('c', '<C-n>')
  vim.keymap.del('c', '<C-p>')
  vim.keymap.del('c', '<C-y>')
  vim.keymap.del('c', '<C-e>')
end

local commandLinePre = function()
  vim.keymap.set('c', '<C-n>', function() fn['pum#map#insert_relative'](1) end, { noremap = true, silent = true })
  vim.keymap.set('c', '<C-p>', function() fn['pum#map#insert_relative'](-1) end, { noremap = true, silent = true })
  vim.keymap.set('c', '<C-y>', function() fn['pum#map#confirm']() end, { noremap = true, silent = true })
  vim.keymap.set('c', '<C-e>', function() fn['pum#map#cancel']() end, { noremap = true, silent = true })

  api.nvim_create_autocmd('User', {
    pattern = 'DDCCmdlineLeave',
    callback = function() commandLinePost() end,
    once = true,
  })

  -- Enable command line completion for next command line session
  ddc_conf.enable_cmdline()
end

vim.keymap.set('n', ':',
  function()
    commandLinePre()
    fn.feedkeys(api.nvim_replace_termcodes(':', true, true, true), 'n')
  end,
  { noremap = true, silent = true }
)

----------------
-- apply configs
----------------
ddc_conf.patch_global('ui', ddc_ui)
ddc_conf.patch_global('sources', ddc_sources)
ddc_conf.patch_global('cmdlineSources', cmdline_sources)
ddc_conf.patch_global('autoCompleteEvents', auto_complete_events)
ddc_conf.patch_global('sourceOptions', source_options)
ddc_conf.patch_global('sourceParams', source_params)
fn["pum#set_option"](pum_option)

-- Enable ddc completion
ddc_conf.enable()
