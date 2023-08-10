local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local opt = vim.opt

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
    if not fn.isdirectory(target_dir) then
      local input_string = fn.input(target_dir .. ' does not exist. Create? [y/N]')
      if input_string == 'y' or 'yes' then
        -- print( 'There isn\'t the directory' )
        fn.mkdir(fn.iconv(target_dir, opt.encoding, opt.termencoding), 'p')
      end
    end
  end,
})
