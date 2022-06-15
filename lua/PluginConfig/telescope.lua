local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local telescope = require("telescope")
local pickers = require("telescope.pickers")

local custom_actions = {}
M = {}

local function run_selection(prompt_bufnr, map)
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    vim.cmd([[!git log ]]..selection[1])
  end)
  return true
end

M.git_log = function()
  -- example for running a command on a file
  local opts = {
    attach_mappings = run_selection
  }
  require('telescope.builtin').find_files(opts)
end

function custom_actions._multiopen( prompt_bufnr, open_cmd )
  local picker = action_state.get_current_picker( prompt_bufnr )
  local num_selections = #picker:get_multi_selection()
  -- telescopeのbuiltin pickerでは、どうやら複数選択時の処理と無選択時の処理が分かれているらしい。
  -- 選択モードと無選択モードの2つがあると考えたらわかりやすいかも...?
  -- (情報源 : telescopeのlua/telescope/pickers/multi.luaのソースを読んだ)
  -- そのため、同じ「ファイルオープン」という処理であっても、
  -- 選択しているのか/いないのか(選択モード/非選択モード)で処理を分ける必要があるっぽい。
  --
  -- もしかしたら、is_multi_selected関数を使った方がいいかも...?
  --
  -- この状態でnum_selectionsのif文を外すと、無選択のときはファイルが開かれない。
  if num_selections >= 1 then
    -- 選択エントリ中に、ディレクトリが含まれていたらどうなるのだろう?
    vim.cmd("bw!")
    for _, entry in ipairs( picker:get_multi_selection() ) do
      vim.cmd( string.format("%s %s", open_cmd, entry.value) )
    end
    vim.cmd("stopinsert")
  else
    -- 無選択モードだった場合は、デフォルトの選択関数をそのまま使えばいい
    actions.select_default( prompt_bufnr )
  end
end

function custom_actions.open_to_buffer( prompt_bufnr )
  custom_actions._multiopen( prompt_bufnr, "edit" )
end

-- local actions = require( "telescope.actions" )
require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        -- ["<c-[>"] = actions.close,
        ["<CR>"] = custom_actions.open_to_buffer,
      },
      n = {
        ["<CR>"] = custom_actions.open_to_buffer,
      },
    },
    path_display = { "truncate" },
  },
}

vim.api.nvim_set_keymap("n", "[telescope]", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "[telescope]", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", ",", "[telescope]", {})
vim.api.nvim_set_keymap("v", ",", "[telescope]", {})

local opts = { noremap=true, silent=true }
local keymap_telescope_func = {
  ["[telescope]f"] = "require'telescope.builtin'.find_files()",
  ["[telescope]tr"] = "require'telescope.builtin'.grep_string()",
  ["[telescope]ll"] = "require'telescope.builtin'.live_grep()",
  ["[telescope]%"] = "require'telescope.builtin'.live_grep({grep_open_files=true})",
  ["[telescope]:"] = "require'telescope.builtin'.command_history{}",
  ["[telescope]b"] = "require'telescope.builtin'.buffers{show_all_buffers = true}",
  ["[telescope]ts"] = "require'telescope.builtin'.treesitter()",
  ["[telescope]cb"] = "require'telescope.builtin'.current_buffer_fuzzy_find()",
  ["[telescope]h"] = "require'telescope.builtin'.help_tags()",
  ["[telescope]s"] = "require'telescope.builtin'.lsp_document_symbols()",
  ["[telescope]r"] = "require'telescope.builtin'.lsp_references()",
  ["[telescope]d"] = "require'telescope.builtin'.diagnostics()",
  ["[telescope]o"] = "require'telescope.builtin'.oldfiles()",
  ["[telescope]gl"] = "M.git_log()",
  -- ["[telescope]g"] = "require'telescope.builtin'.git_files()",
  -- ["<Leader>st"] = "require'telescope.builtin'.git_status()",
  -- ["<Leader>bc"] = "require'telescope.builtin'.git_bcommits()",
  -- ["<Leader>c"] = "require'telescope.builtin'.git_commits()",
}
for k, v in pairs(keymap_telescope_func) do
  vim.api.nvim_set_keymap('n', k, string.format("<cmd> lua %s<CR>", v), opts)
end

require("project_nvim").setup({})
telescope.load_extension('projects') -- integrate to telescope
