local api = vim.api
local bo = vim.bo
local fn = vim.fn
local ts = vim.treesitter
local wo = vim.wo

require("nvim-treesitter").setup({})

api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "tsx", "typescript", "typescriptreact", "python", "markdown", "cpp", "cmake", "lua", "bash" },
  callback = function()
    ts.start()
    wo.foldmethod = "expr"
    wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
