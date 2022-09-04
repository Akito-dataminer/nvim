---- HELPERS ----
local api = vim.api
local fn = vim.fn
local opt = vim.opt  -- to set options
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local vg = vim.g

---- Body ----
local my_shell = 'cmd'
opt.encoding = 'utf-8'
opt.fileencodings = 'utf-8'
opt.shell = my_shell
if my_shell == 'powershell' then
  opt.shellcmdflag = '-Command'
  opt.shellxquote = ''
  opt.shellpipe = '2>&1 | Out-File -Encoding default'
  opt.shellredir = '2>&1 | Out-File -Encoding default'
end
cmd("set cpoptions+=+")
-- opt.clipboard='unnamed' -- ヤンクした内容が、"*レジスタにも自動で格納されるようにする?
-- opt.ambiwidth='double' -- 全角文字の表示に2文字分を使うようにする
-- opt.syntax = true -- 構文ごとに文字色を変化させる
-- opt.swapfile = false  -- NOT use swapfile
opt.ignorecase = false -- 大文字と小文字を区別する
opt.expandtab = true   -- Use spaces instead of tabs
opt.scrolloff = 4      -- Lines of context
opt.shiftround = true  -- Round indent
opt.shiftwidth = 2     -- Size of an indent
opt.tabstop = 2        -- Number of spaces tabs count for
opt.autoindent = true
opt.wildmenu = true -- コマンドラインモードで<Tab>キーによる補完を有効にする
opt.smarttab = true
opt.showcmd = true
opt.ruler = true -- カーソルが置かれている行を表示する
opt.title = true
opt.termguicolors = true
opt.pumblend = 17
vg.loaded_netrw = false -- disable netrw
vg.loaded_netrwPlugin = false -- disable netrw plugins

opt.list = true        -- Show some invisible characters
opt.listchars = {tab = '>>', trail = '*', nbsp = '+'}

opt.grepprg = 'rg'

---- title settings ----
-- cmd('autocmd BufEnter * let &titlestring = getcwd()') -- display the current directory in title bar
api.nvim_create_autocmd( { "BufEnter" }, {
  pattern = {"*"},
  command = "let &titlestring = getcwd()",
})

---- statusline settings ----
opt.laststatus = 2 -- 常にステータスラインを表示する
local line_components = {
  '%<',   -- 行が長すぎるときに切り詰める位置
  '%m',   -- %m 修正フラグ
  "%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}",  -- fencとffを表示
  "%{expand('%:~:.')}", -- カレントディレクトリ以降のファイル名を表示
  "%{fugitive#statusline()}",  -- Gitのブランチ名を表示
  '%=', -- 左寄せ項目と右寄せ項目の区切り
  '%1l-', -- 何行目にカーソルがあるか
  '%c',  -- 何列目にカーソルがあるか
}

local line = ''
for _, value in ipairs( line_components ) do
  line = line .. value
end

opt.statusline = line -- ステータスラインを設定
