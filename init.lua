-- If you are new to vim and neovim in general, then before you
-- do anything, I strongly- very strongly- suggest you type
-- `:Tutor` and then press the enter key. That will run the
-- standard tutorial for neovim, which will teach you all the
-- basics of movements, operators, etc. 
-- Beyond that, you should be able to learn more about almost 
-- anything in this file by typing `:help KEYWORD` (where 
-- KEYWORD is the function or option or whatever). You can 
-- close the resulting window by pressing CTRL+w and then 
-- pressing c. type just `:help` to learn more about neovim's 
-- helpfiles (Highly recommended!)
-- examples:
-- :help window
-- :help hidden
-- :help vim.cmd()
-- :help :options

-- this little 12 line section here is to help
-- you bootstrap your plugin manager. There is
-- no need to touch it.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- this syncs neovim's clipboard with the
-- system clipboard. If you are on Linux,
-- you need to install a clipboard
-- provider for this to work--
-- wl-clipboard for wayland or xclip for
-- X11. It will work out of the box on
-- MacOS-- not sure about Windows though.
vim.o.clipboard = 'unnamedplus'

-- show line numbers
vim.o.number = true

-- this is what's known as the "leader key"
-- (usually referenced as <Leader>) and 
-- can be used as a way to separate user 
-- defined keybinds from builtin keybinds.
-- in this case we are setting it to the
-- spacebar, as the default functionality
-- for spacebar in neovim is generally
-- not all that useful.
vim.g.mapleader = ' '

-- we are using lazy.nvim as our plugin manager.
-- A plugin manager helps download plugins and
-- insert them into your runtimepath 
-- (`:help runtimepath`). Technically, you can
-- install and source the plugins yourself using
-- native neovim functionality 
-- (`:help packages`), but plugin managers like
-- lazy.nvim get rid of this boilerplate and
-- also add on the ability to *lazy load* your
-- plugins. Lazy loading is very important if
-- you are looking to get neovim to load fast
-- despite using a plethora of plugins.
-- you can use `:help lazy.nvim` to discover
-- more about lazy.nvim.
require("lazy").setup({
  -- here is a basic plugin spec. the first part
  -- is the 'username/reponame' part of a github
  -- link to the actual plugin (so for this one,
  -- the link would be 
  -- https://github.com/rmehri01/onenord.nvim)
  -- and the second part (opts) represents the
  -- options that would be passed to the 
  -- setup() call that lazy does under the hood.
  -- this is often all you really need to get
  -- a plugin working for you, but if not
  -- they usually will tell you how to
  -- properly configure and download that plugin
  -- in the README of the repo. This specific
  -- plugin is our colorscheme (you do want
  -- your IDE to look good, right?)
  { 'rmehri01/onenord.nvim', opts = {} },

  -- some plugins, like older vim plugins,
  -- do not need to even have something like
  -- setup called to be usable. for these
  -- you can just specify the link like so:
  'tpope/vim-sleuth',

  -- one of the most popular ways to navigate
  -- your codebase, files, etc is using fuzzy
  -- finding (`:help fuzzy-matching`). I
  -- highly recommend looking it up and
  -- giving it a try. Telescope is one of the
  -- most common fuzzy finders for neovim,
  -- and a lot of plugins integrate
  -- with it.
  {
    'nvim-telescope/telescope.nvim',
    -- you'll notice that you can specify if
    -- a plugin depends on another right here
    -- vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- the config attribute allows you to run
    -- a function to configure a plugin,
    -- rather than just having lazy call
    -- setup with some options directly.
    -- Here, I simply add some basic keymaps
    -- using vim.keymap.set() (you can learn
    -- more about vim.keymap.set() by typing
    -- `:help vim.keymap.set()` and then
    -- pressing enter)
    config = function()
      local builtin = require('telescope.builtin')
      -- in normal mode, pressing the leader
      -- key twice will run the function
      -- builtin.buffers, which allows you
      -- navigate to one of your already
      -- opened files.
      vim.keymap.set('n', '<Leader><Leader>', builtin.buffers)
      -- the same, but for any file in the current directory
      vim.keymap.set('n', '<Leader>f', builtin.find_files)
    end,
  },

  -- sort of a similar situation to telescope-- lots
  -- of people like to have a statusline plugin, but
  -- do note it is NOT needed like almost at all, 
  -- its just to be fancy half the time AFIK XD
  -- (I like the colors hehe), so I would suggest
  -- looking at `:help statusline` if you're looking
  -- to drop some plugins or something, it's really
  -- suprisingly easy to do.
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '╲', right = '╲' }
      }
    },
    -- sometimes, having a bunch of plugins
    -- slows down neovim's startup. To
    -- mitigate this, you can have some
    -- plugins load a bit later on.
    -- here we are loading on the
    -- VeryLazy event. Do note that
    -- lazy.nvim comes with a profiler
    -- (`:Lazy profile`) which is very
    -- helpful for diagnosing which
    -- specific plugins are doing the most
    -- damage.
    lazy = true, event = 'VeryLazy',
  },

  -- nvim-lspconfig is a slightly nicer way
  -- to work with neovim's LSP client. The
  -- LSP is the thing that provides most of
  -- the features when you think of an IDE.
  -- you can learn more about LSPs by
  -- looking in the neovim docs 
  -- (`:help lsp`)
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- this isn't *actually* a dependency
      -- of nvim-lspconfig, but it's useful
      -- if you want to download an LSP to
      -- use.
      'williamboman/mason.nvim'
    },
    config = function()
      require('mason').setup({})
      local configs = require('lspconfig')

      -- setup the clangd server for C++
      -- Make sure you have the LSP
      -- present on your machine before
      -- you go configuring it or you
      -- are gonna get some annoying
      -- error messages. I'm using mason
      -- on its own right now to ensure 
      -- this, but there's also the 
      -- mason-lspconfig plugin, which 
      -- is more convenient.
      if not require('mason-registry').is_installed('clangd') then
        require('mason-registry').get_package('clangd'):install()
      end
      configs.clangd.setup({})

      -- vim.api.nvim_create_autocmd() is one of
      -- the ways you can run code on an event
      -- (called an "autocmd" in vim/neovim)
      -- you can look at `:help autocmd` or
      -- `:help LspAttach` for more information.
      -- In this case, we are reacting to when
      -- an lsp has been started and attached to
      -- a specific buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local map = function(mapping, action)
            -- providing a buffer value to the options object will
            -- restrict a keymap to that specific buffer (in this
            -- case, the buffer that the lsp just attached to, of
            -- course)
            vim.keymap.set('n', mapping, action, { buffer = ev.buf })
          end
          -- some example mappings. A lot of things will already
          -- be mapped for you-- check `:help lsp-defaults` to 
          -- see those (things like go-to-definition & 
          -- formatting)
          map('<Leader>ca', vim.lsp.buf.code_action)
          map('<Leader>rn', vim.lsp.buf.rename)
        end
      })
    end
  },
  -- neovim has an extremely powerful set of
  -- builtin manual completions 
  -- (`:help ins-completion`),
  -- but not *auto* completion, like you may
  -- be used to. The more robust solution to
  -- this is hrsh7th/nvim-cmp, but 
  -- mini.completion is a lot simpler to
  -- setup, and I've found that a 
  -- combination of mini.completion and the
  -- occasional use of neovim's builtin
  -- completions is more than sufficient.
  { 'echasnovski/mini.completion', opts = {} },

  -- nvim-treesitter is sort of in the same realm as
  -- nvim-lspconfig; its mostly a wrapper around
  -- core neovim features-- that being treesitter,
  -- which helps with getting higher quality syntax
  -- highlighting, among other things. More
  -- specifically, extra textobjects and incremental
  -- selection and such, which come as extensions to
  -- nvim-treesitter. you can go to
  -- https://github.com/nvim-treesitter to see some
  -- more of the main extensions. There is a lot of
  -- potential here :)
  -- Also if you want to learn more about treesitter
  -- you can check out `:help treesitter` and
  -- `:help lsp-vs-treesitter`.
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'lua', 'vimdoc', 'cpp' },
        auto_install = true,
        highlight = { enable = true }
      })
    end
  },
})

-- If you are looking for more plugins to use, you can
-- always check out sites like: 
--   https://dotfyle.com/
--   https://vimawesome.com/
-- or a list like:
--   https://github.com/rockerBOO/awesome-neovim/
-- and you've also seen some of the bigshots from the
-- plugins I've provided to you:
--   https://github.com/folke
--   https://github.com/echasnovski
--   https://github.com/tpope
-- there are a LOT of awesome plugin developers out
-- there. A lot of them also frequent the neovim
-- subreddit:
--   https://reddit.com/r/neovim
-- and they will often make a post when they make
-- exciting new plugins or updates.
