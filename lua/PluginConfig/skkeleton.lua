local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local util = require('utils')
local ddc_conf = require('PluginConfig/ddc/helper')

local data_path = fn.stdpath('data')
local dictionary_source_path = util.join_paths(data_path, 'SKK-JISYO.L')
local my_dictionary_path = util.join_paths(data_path, 'SKK-JISYO.MY')

fn['skkeleton#config'] {
  -- debug = true,
  eggLikeNewline = true,
  globalJisyo = dictionary_source_path,
  markerHenkan = '<>',
  markerHenkanSelect = '>>',
  registerConvertResult = true,
  userJisyo = my_dictionary_path,
}

fn['skkeleton#register_kanatable'](
  'rom',
  {
    xn = { 'ん' },
    jj = { 'escape' },
    ['~'] = { '〜', '' },
    ['z\\<Space>'] = { '\\u3000', '' },
  },
  {}
)

fn['skkeleton#register_keymap']('henkan', util.tcode('<BS>'), 'henkanBackward')
fn['skkeleton#register_keymap']('henkan', util.tcode('x'), '')

----------------
-- keymap
----------------
local skkeleton_keymap = {
  {
    mode = { 'i', 'c' },
    key_pattern = '<C-l>',
    action = function()
      fn.feedkeys(api.nvim_replace_termcodes('<Plug>(skkeleton-enable)', true, true, true), fn.mode())
    end,
    option = { noremap = true, silent = true }
  }
}
util.add_keymaps(skkeleton_keymap)

----------------
-- for ddc
----------------
local source_options = {
  ['skkeleton'] = {
    mark = 'SKK',
    matchers = { 'skkeleton' },
    sorters = {},
    minAutoCompleteLength = 2,
    isVolatile = true,
  },
}

ddc_conf.patch_global('sourceOptions', source_options)

----------------
-- autocmd
----------------
api.nvim_create_autocmd('User', {
  pattern = 'skkeleton-enable-pre',
  callback = function()
    ddc_conf.patch_global('sources', { 'skkeleton' })
  end,
})
api.nvim_create_autocmd('User', {
  pattern = 'skkeleton-disable-pre',
  callback = function()
    ddc_conf.patch_global('sources', { 'vsnip', 'lsp', 'file', 'around' })
  end,
})
