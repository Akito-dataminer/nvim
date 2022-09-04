local cmd = vim.cmd
local fn = vim.fn

local prev_buffer_config
--local pum_close_timer

function _G.skkeleton_enable_pre()
  fn['ddc#custom#get_buffer']()
  fn['ddc#custom#patch_buffer']{
    completionMenu = 'native',
    sources = {'skkeleton'},
  }
end

cmd[[
  augroup skkeleton_callbacks
    autocmd!
    autocmd User skkeleton-enable-pre call v:lua.skkeleton_enable_pre()
    autocmd User skkeleton-disable-pre call v:lua.skkeleton_disable_pre()
  augroup END
]]



cmd[[
  inoremap <C-i> <Plug>(skkeleton-disable)
  inoremap <C-,> <Plug>(skkeleton-enable)

  augroup skkeleton_karabiner_elements
    autocmd!
    autocmd InsertEnter,CmdlineEnter * call v:lua.set_karabiner(1)
    autocmd InsertLeave,CmdlineLeave,FocusLost * call v:lua.set_karabiner(0)
    autocmd FocusGained * call v:lua.set_karabiner_if_in_insert_mode()
  augroup END
]]
