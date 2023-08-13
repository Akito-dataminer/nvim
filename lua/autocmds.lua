local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

-- quickfixが変更されたとき、自動でquickfixを開く
api.nvim_create_autocmd('QuickFixCmdPost', {
  group = api.nvim_create_augroup('auto_open_quickfix', {}),
  pattern = { "make", "grep", "grepadd", "vimgrep", },
  callback = function()
    cmd('copen')
  end
})

-- 新しいファイルを保存するときに、ディレクトリが存在しなければ、
-- ユーザーに確認を取ってから新しくディレクトリを作る
api.nvim_create_autocmd('BufWritePre', {
  group = api.nvim_create_augroup('auto_mkdir', {}),
  callback = function(info_table)
    local target_dir = fn.fnamemodify(info_table.file, ':p:h')
    if fn.isdirectory(target_dir) == 0 then
      print(target_dir .. '/ is created')
      fn.mkdir(target_dir, 'p')
    end
  end,
})

-- Vimの画面サイズが変更されたとき、
-- 各ウィンドウの大きさを同じくらいに変更しなおす
api.nvim_create_autocmd('VimResized', {
  group = api.nvim_create_augroup('resize_splits', {}),
  callback = function()
    cmd('wincmd =')
  end,
})
