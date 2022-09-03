-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "C:\\Users\\akito\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?.lua;C:\\Users\\akito\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?\\init.lua;C:\\Users\\akito\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?.lua;C:\\Users\\akito\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?\\init.lua"
local install_cpath_pattern = "C:\\Users\\akito\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\lua\\5.1\\?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    config = { "\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25PluginConfig/LuaSnip\frequire\0" },
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["ddc-around"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\ddc-around",
    url = "https://github.com/Shougo/ddc-around"
  },
  ["ddc-matcher_head"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\ddc-matcher_head",
    url = "https://github.com/Shougo/ddc-matcher_head"
  },
  ["ddc-sorter_rank"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\ddc-sorter_rank",
    url = "https://github.com/Shougo/ddc-sorter_rank"
  },
  ["ddc.vim"] = {
    after = { "ddc-matcher_head", "ddc-around", "ddc-sorter_rank" },
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21PluginConfig/ddc\frequire\0" },
    loaded = true,
    only_config = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\ddc.vim",
    url = "https://github.com/Shougo/ddc.vim"
  },
  ["denops.vim"] = {
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\denops.vim",
    url = "https://github.com/vim-denops/denops.vim"
  },
  ["hop.nvim"] = {
    config = { "\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tkeys\28etovxqpdygfblzhckisuran\nsetup\bhop\frequire\0" },
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  ["iceberg.vim"] = {
    after = { "nvim-treesitter", "telescope.nvim" },
    loaded = false,
    needs_bufread = false,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\iceberg.vim",
    url = "https://github.com/cocopon/iceberg.vim"
  },
  ["mason.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23PluginConfig/mason\frequire\0" },
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  nerdcommenter = {
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nerdcommenter",
    url = "https://github.com/preservim/nerdcommenter"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n;\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0 PluginConfig/nvim-autopairs\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n;\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0 PluginConfig/nvim-lspconfig\frequire\0" },
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!PluginConfig/nvim-treesitter\frequire\0" },
    load_after = {
      ["iceberg.vim"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["open-browser.vim"] = {
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\open-browser.vim",
    url = "https://github.com/tyru/open-browser.vim"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  previm = {
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\previm",
    url = "https://github.com/previm/previm"
  },
  ["project.nvim"] = {
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\project.nvim",
    url = "https://github.com/ahmedkhalf/project.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27PluginConfig/telescope\frequire\0" },
    load_after = {
      ["iceberg.vim"] = true
    },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-markdown"] = {
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-markdown",
    url = "https://github.com/preservim/vim-markdown"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "C:\\Users\\akito\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-surround",
    url = "https://github.com/tpope/vim-surround"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: mason.nvim
time([[Config for mason.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23PluginConfig/mason\frequire\0", "config", "mason.nvim")
time([[Config for mason.nvim]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25PluginConfig/LuaSnip\frequire\0", "config", "LuaSnip")
time([[Config for LuaSnip]], false)
-- Config for: ddc.vim
time([[Config for ddc.vim]], true)
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21PluginConfig/ddc\frequire\0", "config", "ddc.vim")
time([[Config for ddc.vim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0 PluginConfig/nvim-lspconfig\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: hop.nvim
time([[Config for hop.nvim]], true)
try_loadstring("\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tkeys\28etovxqpdygfblzhckisuran\nsetup\bhop\frequire\0", "config", "hop.nvim")
time([[Config for hop.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd ddc-around ]]
vim.cmd [[ packadd ddc-sorter_rank ]]
vim.cmd [[ packadd ddc-matcher_head ]]
time([[Sequenced loading]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'nvim-treesitter', 'telescope.nvim', 'nvim-autopairs'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
