---- HELPERS ----
local api = vim.api
local fn = vim.fn
local vg = vim.g
local cmd = vim.cmd

local utils = require('utils')

local data_path = fn.stdpath( "data" )
local packer_path = utils.join_paths( data_path, "site", "pack", "packer" )
local start_path = utils.join_paths( packer_path, "start" )
local opt_path = utils.join_paths( packer_path, "opt" )
local candidate_directory_list = { start_path, opt_path }

for _, path in ipairs( candidate_directory_list ) do
  local vsnip_path = utils.join_paths( path, "vim-vsnip", "autoload", "vsnip.vim" )

  -- if vim-vsnip is found, load the source
  if utils.isInstalled( vsnip_path ) == 1 then
    cmd( "source " .. vsnip_path )
  end
end

-- configure the snippet directory
local vsnip_dir = utils.join_paths( fn.stdpath( "data" ), ".vsnip" )
vg.vsnip_snippet_dir = vsnip_dir

cmd([[
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.cppreact = ['cpp']
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']
]])

-- Key Mappings
-- imap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'
-- smap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'
cmd([[
imap <expr> <Tab> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
]])

-- local function map( mode, lhs, rhs, opts )
--   local options = {noremap = true}
--   if opts then options = vim.tbl_extend('force', options, opts) end
--   api.nvim_set_keymap( mode, lhs, rhs, options )
-- end

-- local function termcode(str)
--   return api.nvim_replace_termcodes(str, true, true, true)
-- end

-- function _G.smartNext( key )
--   return fn.pumvisible() == 1 and termcode'<C-n>' or termcode( key )
-- end

-- function _G.expandable( key )
--   return fn['vsnip#expandable()'] == 1 and termcode'<Plug>(vsnip-expand)' or termcode( key )
-- end

-- local opts = { expr = true, noremap = true }
-- map( 'i', 'C-j', expandable('C-j'), opts )
