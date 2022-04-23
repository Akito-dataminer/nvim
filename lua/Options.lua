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
line = '%<'-- 行が長すぎるときに切り詰める位置
line = line .. '%m' -- %m 修正フラグ
line = line .. "%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}"  -- fencとffを表示
line = line .. "%{expand('%:~:.')}" -- カレントディレクトリ以降のファイル名を表示
line = line .. "%{fugitive#statusline()}"  -- Gitのブランチ名を表示
line = line .. '%=' -- 左寄せ項目と右寄せ項目の区切り
line = line .. '%1l-' -- 何行目にカーソルがあるか
line = line .. '%c'    -- 何列目にカーソルがあるか

opt.statusline = line -- ステータスラインを設定
