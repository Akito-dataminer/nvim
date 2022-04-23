local telescope = require('telescope')

local actions = require("telescope.actions")
require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        ["<c-[>"] = actions.close
      },
    },
  }
}

local opts = { noremap=true, silent=true }
local keymap_telescope_func = {
  [",f"] = "require'telescope.builtin'.find_files()",
  -- [",f"] = "require'telescope.builtin'.git_files()",
  [",s"] = "require'telescope.builtin'.grep_string()",
  [",l"] = "require'telescope.builtin'.live_grep({grep_open_files=true})",
  [",ch"] = "require'telescope.builtin'.command_history{}",
  [",b"] = "require'telescope.builtin'.buffers{show_all_buffers = true}",
  [",h"] = "require'telescope.builtin'.help_tags()",
  -- [",s"] = "require'telescope.builtin'.lsp_document_symbols()",
  -- [",r"] = "require'telescope.builtin'.lsp_references()",
  [",d"] = "require'telescope.builtin'.diagnostics()",
  [",o"] = "require'telescope.builtin'.oldfiles()",
  -- ["<Leader>st"] = "require'telescope.builtin'.git_status()",
  -- ["<Leader>bc"] = "require'telescope.builtin'.git_bcommits()",
  -- ["<Leader>c"] = "require'telescope.builtin'.git_commits()",
}
for k, v in pairs(keymap_telescope_func) do
  vim.api.nvim_set_keymap('n', k, string.format("<cmd> lua %s<CR>", v), opts)
end

require("project_nvim").setup({})
telescope.load_extension('projects') -- integrate to telescope
