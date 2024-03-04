-- set ',' as the leader key
vim.g.mapleader = "."
vim.g.maplocalleader = "."

-- set line numbers default
vim.opt.number = true
-- show the line numbers relative to the current line
vim.opt.relativenumber = true

-- Don't show the mode, since it is in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = 'unnamedplus'

-- Case-insenstive searching unless \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display whitespace in the editor.
-- `:help 'list'`
-- `:help `listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = ">> ", trail = '.', nbsp = '_'}

-- Show which line cursor is on
vim.opt.cursorline = true

-- Minimal number of lines above and below the cursor
vim.opt.scrolloff = 10

-- Options for indentation and spacing
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true

-- No swapfile needed when opening a buffer
vim.opt.swapfile = false

-- More characters before redrawing
vim.opt.ttyfast = true

-- Spell Checker settings
vim.opt.spelllang=en_us
vim.opt.spell = true

-- [[ Keymaps ]]
-- `:help vim.keymap.set()`

-- Set highlight on search, but clear on <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>db', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', '<leader>df', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Keybinds for nvim split navigation
-- Use CTRL+<hjkl> to switch between windows
-- `:help wincmd`
-- Sets Ctrl+h to what would normally be Ctrl-w, then Control-h. Likewise for the others.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = "Move focus to the left window" })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = "Move focus to the right window" })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = "Move focus to the lower window" })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = "Move focus to the upper window" })


-- NerdTree Bindings
vim.keymap.set('n', '<C-g>', ':NERDTreeFocus<CR>', {noremap = true })
vim.keymap.set('n', '<C-t>', ':NERDTreeToggle<CR>', {noremap = true })

-- Buffer bindings

-- Telescope Mappings
vim.keymap.set('n', '<C-p>', ":Telescope find_files<CR>", {noremap = true })


-- [[Vim Plugins]]
local Plug = vim.fn['plug#']
vim.call('plug#begin')

-- Status Bar Info
Plug 'vim-airline/vim-airline'

-- Nerd Tree
Plug 'preservim/nerdtree'

-- Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug ('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make'})

-- Color Scheme Plugs
-- Plug 'sts10/vim-pink-moon'
Plug ('luisiacc/gruvbox-baby', { ['branch'] = 'main'})

-- Mason for LSP
Plug ('williamboman/mason.nvim', { ['do'] = ':MasonUpdate'} )
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

-- LSP
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
vim.call('plug#end')

-- NerdTree Settings
vim.g.NERDTreeDirArrowExpandable="+"
vim.g.NERDTreeDirArrowCollapsible="-"

-- Color Scheme Settings
vim.opt.termguicolors = true
vim.opt.background=dark
vim.cmd([[colorscheme gruvbox-baby]])

-- Package Setups
require('mason').setup()
require("mason-lspconfig").setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

lspconfig.pyright.setup {}
lspconfig.gopls.setup {
    on_attach = function()
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
    end
}
-- Use LspAttach autocommand to map following keys
-- after attaching the language server to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
    
    -- Buffer local mappings
    -- `:help vim.lsp.*`
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
    end
})

-- Setup nvim-cmp
vim.opt.completeopt={"menu", "menuone", "noselect"}
local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
    },
    mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Telescope Setup
local action_state = require('telescope.actions.state')
require("telescope").setup{
    defaults = {
        prompt_prefix = "> ",
        mappings = {
            i = {
            }
        }
    }
}
require("telescope").load_extension("fzf")

curr_buf = function()
    local opt = require('telescope.themes').get_dropdown({sorting_strategy="ascending", height=10, previewer=false})
    require('telescope.builtin').current_buffer_fuzzy_find(opt)
end

vim.keymap.set('n', '<C-_>', '<cmd>lua curr_buf()<CR>', { noremap = true })
