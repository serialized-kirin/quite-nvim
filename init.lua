-- you should be able to learn more about anything in this file by
-- typing `:help KEYWORD` (where KEYWORD is the function or option or whatever)
-- examples: 
-- `:help mini.nvim`, `:help mini.basics`, `:help hidden`, `:help vim.cmd()`

-- auto-install and setup our package manager. (pulls entire mini.nvim library, which comes with a bunch of extra goodies :])
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })


-- pkg registers plugins.
local pkg = MiniDeps.add
--  use these if you feel neovim's startup is slow
--  doLater lets you load less important/slower plugins later/lazily for better startup times.
--  vim.loader.enable() does... something. idk. caching, I think?
-- local doNow = MiniDeps.now, doLater = MiniDeps.later
-- vim.loader.enable()


-- set all sorts of options for a bit nicer experience,
-- like mapleader=<Space> & set number & such..
-- WARNING: 
--  since this sets the mapleader, you want it to run 
--  BEFORE you make any new keymaps.
require('mini.basics').setup({})

-- a start screen with recent files, etc for you when u open nvim without opening a file :]
require('mini.starter').setup({})

-- 

-- register package
pkg(
  -- this is commonly called a "short url". it's just the 
  -- tail end of a github url, so to find this plugin, 
  -- you could just search
  -- "https://github.com/rmehri01/onenord.nvim"
  'rmehri01/onenord.nvim'
)
-- setup/configure package
require('onenord').setup()

--[[ might put in..
-- use vim.cmd() to execute vimscript commands
vim.cmd([[
  set mouse=a " always be able to use the mouse
  set hidden " lets us close a window without writing it.
  set number " gives you line numbers
  set tabstop=2 shiftwidth=2 " sets how big tabs look
  set expandtab smarttab " used to replace tabs with spaces (tabs act weird in vim)
  set wrap linebreak breakindent " adds visual word-wrap.
  set ttimeoutlen=300 " makes neovim register mappings faster

  let mapleader=' ' " this sets what the <Leader> key will be. it must be set BEFORE any mappings are made.
] ])
]]
