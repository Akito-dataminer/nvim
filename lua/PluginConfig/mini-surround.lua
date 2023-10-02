require('mini.surround').setup({
  n_lines = 100,
  -- Let the first character is 'c', from "Closure".
  -- When it is 's', I felt it was not user-friendly.
  mappings = {
    add = 'ca',            -- Add surrounding in Normal and Visual modes
    delete = 'cd',         -- Delete surrounding
    find = 'c<',           -- Find surrounding (to the right)
    find_left = 'c>',      -- Find surrounding (to the left)
    highlight = 'ch',      -- Highlight surrounding
    replace = 'cs',        -- Replace surrounding
    update_n_linec = 'cn', -- Update `n_lines`
    update_n_lines = '',

    suffix_last = '', -- Suffix to search with "prev" method
    suffix_next = '', -- Suffix to search with "next" method
  },
  custom_surroundings = {
    ['j'] = {
      input = function()
        local ok, val = pcall(vim.fn.getchar)
        if not ok then return end
        local char = vim.fn.nr2char(val)

        local dict = {
          ['('] = { '（().-()）' },
          ['{'] = { '｛().-()｝' },
          ['['] = { '「().-()」' },
          [']'] = { '『().-()』' },
          ['<'] = { '＜().-()＞' },
          ['"'] = { '”().-()”' },
        }

        if char == 'b' then
          local ret = {}
          for _, v in pairs(dict) do table.insert(ret, v) end
          return { ret }
        end

        if dict[char] then return dict[char] end

        error('%s is unsupported surroundings in Japanese')
      end,
      output = function()
        local ok, val = pcall(vim.fn.getchar)
        if not ok then return end
        local char = vim.fn.nr2char(val)

        local dict = {
          ['('] = { left = '（', right = '）' },
          ['{'] = { left = '｛', right = '｝' },
          ['['] = { left = '「', right = '」' },
          [']'] = { left = '『', right = '』' },
          ['<'] = { left = '＜', right = '＞' },
          ['"'] = { left = '”', right = '”' },
        }

        if not dict[char] then error('%s is unsupported surroundings in Japanese') end

        return dict[char]
      end
    }
  },
})
