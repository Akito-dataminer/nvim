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
  ['nvim-lsp'] = {
    mark = 'LSP',
    forceCompletionPattern = '\\k*',
    sorters = { 'sorter_lsp-kind' }
  },
  ['vsnip'] = {
    mark = 'SNIP',
    dup = true,
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

----------------
-- keymaps
----------------
local commandLinePost = function()
  -- vim.keymap.del('c', '<C-n>')
  -- vim.keymap.del('c', '<C-p>')
  -- vim.keymap.del('c', '<C-y>')
  -- vim.keymap.del('c', '<C-e>')
end

local commandLinePre = function()
  print('set')
  vim.keymap.set('c', '<C-n>', fn['pum#map#insert_relative'](1), { noremap = true, silent = true })
  vim.keymap.set('c', '<C-p>', fn['pum#map#insert_relative'](-1), { noremap = true, silent = true })
  vim.keymap.set('c', '<C-y>', fn['pum#map#confirm'](), { noremap = true, silent = true })
  vim.keymap.set('c', '<C-e>', fn['pum#map#cancel'](), { noremap = true, silent = true })

  api.nvim_create_autocmd('User', {
    pattern = 'DDCCmdlineLeave',
    callback = commandLinePost,
    once = true,
  })

  -- Enable command line completion for next command line session
  ddc_conf.enable_cmdline()
end

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

vim.keymap.set( 'n', ':', function() commandLinePre() fn.feedkeys( api.nvim_replace_termcodes( ':', true, true, true ), 'n' ) end, { noremap = true, silent = true } )

----------------
-- apply configs
----------------
ddc_conf.patch_global('ui', ddc_ui)
ddc_conf.patch_global('sources', ddc_sources)
ddc_conf.patch_global('cmdlineSources', cmdline_sources)
ddc_conf.patch_global('autoCompleteEvents', auto_complete_events)
ddc_conf.patch_global('sourceOptions', source_options)
ddc_conf.patch_global('sourceParams', source_params)
g.vsnip_filetypes = {}

ddc_conf.enable()
