" This configuration script is inspired by
" ddc help and
" https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/ddc.toml
"
" Thank you for sharing very nice plugins and scripts!!

" Customize global settings
call ddc#custom#patch_global('sources', ['vsnip', 'nvim-lsp', 'file', 'around'])

call ddc#custom#patch_global('cmdlineSources', {
      \ ':': ['cmdline-history', 'cmdline', 'around'],
      \ '@': ['cmdline-history', 'input', 'file', 'around'],
      \ '>': ['cmdline-history', 'input', 'file', 'around'],
      \ '/': ['around', 'line'],
      \ '?': ['around', 'line'],
      \ '-': ['around', 'line'],
      \ '=': ['input'],
      \ })

call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'ignoreCase': v:true,
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank'],
      \   'dup': v:true,
      \ },
      \ 'around': {
      \   'mark': 'A',
      \   'matchers': ['matcher_head'],
      \ },
      \ 'cmdline': {
      \   'mark': 'cmdline',
      \   'forceCompletionPattern': '\S/\S*',
      \   'dup': v:true,
      \ },
      \ 'cmdline-history': {
      \   'mark': 'history',
      \   'sorters': [],
      \ },
      \ 'file': {
      \   'mark': 'F',
      \   'isVolatile': v:true,
      \   'forceCompletionPattern': '\S/\S*',
      \ },
      \ 'nvim-lsp': {
      \   'mark': 'LSP',
      \   'forceCompletionPattern': '\\.\\w*|::\\w*|->\\w*',
      \   'sorters': ['sorter_lsp-kind']
      \ },
      \ 'vsnip': {
      \   'mark': 'SNIP',
      \   'dup': v:true,
      \ },
      \ 'skkeleton': {
      \   'mark': 'SKK',
      \   'matchers': ['skkeleton'],
      \   'sorters': [],
      \   'minAutoCompleteLength': 2,
      \   'isVolatile': v:true,
      \ },
      \ })

" Register snippet engine (vim-vsnip)
call ddc#custom#patch_global('sourceParams', #{
      \   nvim-lsp: #{
      \     snippetEngine: denops#callback#register({ body -> vsnip#anonymous(body) }),
      \     enableResolveItem: v:true,
      \     confirmBehavior: 'replace',
      \   }
      \ })

" Use pum.vim
call ddc#custom#patch_global('autoCompleteEvents', [
      \ 'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineEnter', 'CmdlineChanged', 'TextChangedT',
      \ ])
call ddc#custom#patch_global('ui', 'pum')

" Mappings
" <C-n>: into completionMenu or select next item.
" <C-p>: completion back
inoremap <C-n> <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-p> <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <silent><expr> <C-n>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ '<Cmd>call ddc#map#manual_complete()<CR>'
inoremap <C-p> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-e> <Cmd>call pum#map#cancel()<CR>
inoremap <C-y> <Cmd>call pum#map#confirm()<CR>

" For command line mode completion
cnoremap <silent><expr> <C-n>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ exists('b:ddc_cmdline_completion') ?
      \ ddc#map#manual_complete() : nr2char(&wildcharm)
cnoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <C-c>   <Cmd>call pum#map#cancel()<CR>
cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>

" Use ddc.
call ddc#enable()

" For command line completion
nnoremap :       <Cmd>call CommandlinePre( ':' )<CR>:
nnoremap /       <Cmd>call CommandlinePre( '/' )<CR>/
nnoremap ?       <Cmd>call CommandlinePre( '/' )<CR>?

function! CommandlinePre( mode ) abort
  " Overwrite sources
  if !exists('b:prev_buffer_config')
    let b:prev_buffer_config = ddc#custom#get_buffer()
  endif
  " call ddc#custom#patch_buffer('cmdlineSources', ['around'])

  " Switch sources according to purpose
  if a:mode ==# ':'
    call ddc#custom#patch_buffer('cmdlineSources',
          \ ['cmdline-history', 'cmdline', 'around'])
    call ddc#custom#patch_buffer('keywordPattern', '[0-9a-zA-Z_:#]*')
  else
    call ddc#custom#patch_buffer('cmdlineSources',
          \ ['around', 'line'])
  endif

  autocmd User DDCCmdlineLeave ++once call CommandlinePost()
  autocmd InsertEnter <buffer> ++once call CommandlinePost()

  " Enable command line completion
  call ddc#enable_cmdline_completion()
endfunction

function! CommandlinePost() abort
  " Restore sources
  if exists('b:prev_buffer_config')
    call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  else
    call ddc#custom#set_buffer({})
  endif
endfunction

" For skkeleton
let g:skkeleton#debug = v:true
call skkeleton#register_kanatable('rom', {
      \ "xn": ['ん'],
      \ 'jj': 'escape',
      \ '~': ['〜', ''],
      \ "z\<Space>": ["\u3000", ''],
      \ }, {})
call skkeleton#register_keymap('henkan', "\<BS>", 'henkanBackward')
call skkeleton#register_keymap('henkan', "x", '')

autocmd User skkeleton-enable-pre call s:skkeleton_pre()
function! s:skkeleton_pre() abort
  " Overwrite sources
  let s:prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer('sources', ['skkeleton'])
endfunction
autocmd User skkeleton-disable-pre call s:skkeleton_post()
function! s:skkeleton_post() abort
  " Restore sources
  call ddc#custom#set_buffer(s:prev_buffer_config)
endfunction
