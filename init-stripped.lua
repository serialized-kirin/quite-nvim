
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

vim.o.clipboard = 'unnamedplus'

vim.o.number = true

vim.g.mapleader = ' '

require("lazy").setup({
  { 'rmehri01/onenord.nvim', opts = {} },

  'tpope/vim-sleuth',

  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<Leader><Leader>', builtin.buffers)
      vim.keymap.set('n', '<Leader>f', builtin.find_files)
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '╲', right = '╲' }
      }
    },
    lazy = true, event = 'VeryLazy',
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason-lspconfig.nvim',
        dependencies = {'williamboman/mason.nvim'} }
    },
    config = function()
      local configs = require('lspconfig')
      configs.clangd.setup({})
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {'clangd'}
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local map = function(mapping, action)
            vim.keymap.set('n', mapping, action, { buffer = ev.buf })
          end
          map('<Leader>ca', vim.lsp.buf.code_action)
          map('<Leader>rn', vim.lsp.buf.rename)
        end
      })
    end
  },
  { 'echasnovski/mini.completion', opts = {} },

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

