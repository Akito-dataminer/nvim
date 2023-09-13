local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local util = require('utils')

local data_path = fn.stdpath('data')
local dictionary_source_path = util.join_paths(data_path, 'SKK-JISYO.L')

-- exist check

local my_dictionary_path = util.join_paths(data_path, 'SKK-JISYO.MY')

fn['skkeleton#config'] {
  debug = true,
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

fn['skkeleton#register_keymap']('henkan', '\\<BS>', 'henkanBackward')
fn['skkeleton#register_keymap']('henkan', "x", '')

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

-- function _G.skkeleton_enable_pre()
--   fn['ddc#custom#get_buffer']()
--   fn['ddc#custom#patch_buffer']{
--     completionMenu = 'native',
--     sources = {'skkeleton'},
--   }
-- end

-- cmd[[
-- autocmd MyAutoCmd User skkeleton-enable-pre call s:skkeleton_pre()
--   function! s:skkeleton_pre() abort
--     " Overwrite sources
--     let s:prev_buffer_config = ddc#custom#get_buffer()
--     call ddc#custom#patch_buffer('sources', ['skkeleton'])
--   endfunction
--   autocmd MyAutoCmd User skkeleton-disable-pre call s:skkeleton_post()
--   function! s:skkeleton_post() abort
--     " Restore sources
--     call ddc#custom#set_buffer(s:prev_buffer_config)
--   endfunction
-- ]]

-- cmd[[
--   augroup skkeleton_callbacks
--     autocmd!
--     autocmd User skkeleton-enable-pre call v:lua.skkeleton_enable_pre()
--     autocmd User skkeleton-disable-pre call v:lua.skkeleton_disable_pre()
--   augroup END
-- ]]



-- cmd[[
--   augroup skkeleton_karabiner_elements
--     autocmd!
--     autocmd InsertEnter,CmdlineEnter * call v:lua.set_karabiner(1)
--     autocmd InsertLeave,CmdlineLeave,FocusLost * call v:lua.set_karabiner(0)
--     autocmd FocusGained * call v:lua.set_karabiner_if_in_insert_mode()
--   augroup END
-- ]]
