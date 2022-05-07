---- HELPERS ----
local opt = vim.opt  -- to set options

---- Body ----
opt.encoding = 'utf-8'

-- opt.ambiwidth='double' -- 全角文字の表示に2文字分を使うようにする
-- opt.syntax = true -- 構文ごとに文字色を変化させる
opt.swapfile = false  -- スワップファイルを使わないようにする
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

opt.list = true        -- Show some invisible characters
opt.listchars="eol:$,tab:>>,trail:-,nbsp:%" -- 不可視文字の表示方法を決定する

---- statusline settings ----
opt.laststatus = 2 -- 常にステータスラインを表示する
local line = ''
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

for _, value in ipairs( line_components ) do
  line = line .. value
end

opt.statusline = line -- ステータスラインを設定
