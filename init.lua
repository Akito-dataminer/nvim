---- HELPERS ----
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables

--- Map Leader to Space ----
g.mapleader = ' '

---- Autocmd Settings ----
-- Neovim0.7でluaから直接autocmdを叩けるようになるらしい
-- 出典:https://github.com/neovim/neovim/pull/14661
cmd('autocmd QuickFixCmdPost make,grep,grepadd,vimgrep cwindow')

-- 新しいファイルを保存するときに、ディレクトリが存在しなければ、
-- ユーザーに確認を取ってから新しくディレクトリを作る
cmd([[
  augroup AutoMkdir
    autocmd!
    function! s:auto_mkdir(dir, force)  " {{{
      if !isdirectory(a:dir) && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
      endif
    endfunction
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  augroup END
]])

---- Set Neovim Options ----
require'Options'

---- Loading Plugins ----
require'Plugins'

cmd [[packadd packer.nvim]]
cmd 'autocmd BufWritePost Plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

---- nerdcommenter settings ----
g.NERDSpaceDelims = 1
g.NERDDefaultAlign = 'left'

---- Set Neovim Keymaps ----
require'KeyMappings'
