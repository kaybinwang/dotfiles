--[[
================================================================================
init.lua - neovim configuration
================================================================================
Changes will be made to the appropriate files so that we minimize start up
time by only loading functionality when needed. For example Python
functionality will only be loaded when opening up a Python file for the first
time.

   nvim/
   ├── ftplugin/           - filetype specific configuration
   │   └── python.lua      - python filetype configuration
   ├── lua/                - lua modules that are loaded on-demand at runtime
   │   └── statusline.lua  - loaded via `require("statusline")`
   └── init.lua            - personal configuration that's always loaded

Sections:
1. Plugins
2. Editor Settings
3. Key Mappings
4. Prompt
5. Run Commands

================================================================================
--]]

--==============================================================================
-- 1. Plugins
--==============================================================================

--------------------------------------------------------------------------------
-- 1.1 Bootstrap
--
-- First time configuration and loading of plugins.
--------------------------------------------------------------------------------

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
   is_bootstrap = true
   vim.fn.system({
      "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path
   })
   vim.cmd "packadd packer.nvim"
end


--------------------------------------------------------------------------------
-- 1.2 Plugin List
--------------------------------------------------------------------------------

require("packer").startup(function(use)
   -- make sure to add this line to let packer manage itself
   use "wbthomason/packer.nvim"

   -- 1.2.1 User Interface
   use "projekt0n/github-nvim-theme"
   use { "catppuccin/nvim", as = "catppuccin" }
   use "kyazdani42/nvim-web-devicons"     -- accessors for dev icons
   use "f-person/auto-dark-mode.nvim"     -- automatically change light/dark

   -- 1.2.2 Text Editing & Navigation
   use "tpope/vim-surround"      -- wrap text objects with ({[
   use "tpope/vim-commentary"    -- toggle comments
   use "tpope/vim-unimpaired"    -- pairwise mappings e.g. ]q and [q,
   use "tpope/vim-repeat"        -- make custom and commands repeatable

   -- 1.2.3 Search
   use {
      "ibhagwan/fzf-lua",        -- FZF integration for fuzzy searching
      -- optional for icon support
      requires = { "kyazdani42/nvim-web-devicons" }
   }

   -- 1.2.4 Language Support
   use "neovim/nvim-lspconfig"   -- Configurations for Nvim LSP
   use {                         -- Semantic syntax highlighting
      "nvim-treesitter/nvim-treesitter",
      run = function()
         require("nvim-treesitter.install").update({ with_sync = true })
      end,
   }

   -- 1.2.5 Completion
   use "hrsh7th/nvim-cmp"        -- Completion engine
   use "hrsh7th/cmp-buffer"      -- Completions for text in buffers
   use "hrsh7th/cmp-nvim-lsp"    -- Completions for Neovim LSP
   use "hrsh7th/cmp-nvim-lua"    -- Completions for Neovim Lua API
   use "hrsh7th/cmp-path"        -- Completions for system paths
   use "saadparwaiz1/cmp_luasnip"  -- Completions for luasnip

   -- 1.2.6 Developer Tools
   use "tpope/vim-eunuch"        -- Vim sugar for UNIX commands

   -- 1.2.7 Git
   use "tpope/vim-fugitive"      -- Wrapper around Git
   use "tpope/vim-rhubarb"       -- GitHub extension for vim-fugitive
   use "lewis6991/gitsigns.nvim" -- Show/stage/reset git hunks

   -- 1.2.8 Testing
   use "vim-test/vim-test"

   -- 1.2.9 Snippets
   use "L3MON4D3/LuaSnip"        -- Snippets

   -- Automatically set up your configuration after cloning packer.nvim
   -- Put this at the end after all plugins
   if is_bootstrap then
      require("packer").sync()
   end
end)

-- When we are bootstrapping a configuration, it doesn't make sense to execute
-- the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
   print "=================================="
   print "    Plugins are being installed"
   print "    Wait until Packer completes,"
   print "       then restart nvim"
   print "=================================="
   return
end


--==============================================================================
-- 2. Editor Settings
--==============================================================================

--------------------------------------------------------------------------------
-- 2.1 General
--------------------------------------------------------------------------------

vim.opt.mouse = ""                                    -- diasable mouse interactions
vim.opt.hidden = true                                 -- allow buffer to go into background
vim.opt.ttyfast = true                                -- indicates a fast terminal connection
vim.opt.backspace = "indent,eol,start"                -- allow backspace, ^W, ^U over these chars
vim.opt.history = 200                                 -- store last 200 commands as history
vim.opt.errorbells = false                            -- no error bells please
vim.opt.path = vim.opt.path:append("**")              -- recursive searching
vim.opt.complete:remove("i")                          -- don't include all files, it's slow
vim.opt.shortmess:append("aAIsT")                     -- disable welcome screen and other messages
vim.opt.startofline = false                           -- keeps cursor in place when switching buffers

-- 2.1.1 Backups
vim.opt.backup = false                                -- don't save backups
vim.opt.swapfile = false                              -- no swapfiles
vim.opt.writebackup = false                           -- don't save a backup while editing

-- 2.1.2 Undo History
vim.opt.undofile = true                               -- maintain undo history between sessions
vim.opt.undolevels = 10000                            -- store 10000 undos

-- 2.1.3 Auto Save
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {   -- auto read
   pattern = "*",
   command = ":checktime",
})
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {   -- auto write
   pattern = "*",
   command = ":silent! noautocmd w",
})


--------------------------------------------------------------------------------
-- 2.2 User Interface
--------------------------------------------------------------------------------

-- 2.2.1 Theme
vim.cmd.colorscheme("catppuccin")
-- require("auto-dark-mode").setup({
--    "f-person/auto-dark-mode.nvim",     -- automatically change light/dark
--    set_dark_mode = function()
--       vim.opt.background = "dark"
--       vim.cmd.colorscheme("github_dark_dimmed")
--    end,
--    set_light_mode = function()
--       vim.opt.background = "light"
--       vim.cmd.colorscheme("github_light")
--    end,
--    update_interval = 3000,
--    fallback = "dark"
-- })

-- 2.2.2 Buffers
vim.opt.number = true                         -- line numbers
vim.opt.cursorline = true                     -- highlight current line
vim.opt.list = true                           -- show invisible characters
vim.opt.listchars = "tab:>·,trail:·,nbsp:¬"   -- but only show useful characters
vim.opt.lazyredraw = true                     -- don't draw everything

-- 2.2.3 Status Line
vim.opt.laststatus = 3                        -- global status line

require("statusline").setup()                 -- configure statusline


--------------------------------------------------------------------------------
-- 2.3 Text Editing & Navigation
--------------------------------------------------------------------------------

-- 2.3.1 Tabs & Indentation
vim.opt.expandtab = true            -- convert tabs into spaces
vim.opt.tabstop = 2                 -- number of spaces a \t takes up
vim.opt.softtabstop = 2             -- number of spaces to insert/remove on tab/backspace
vim.opt.shiftwidth = 2              -- number of spaces to use for auto-indention, e.g. gq, >, <
vim.opt.shiftround = true           -- indents like > < round to nearest multiple of 'shiftwidth'

-- 2.3.2 Word Wrapping
vim.opt.colorcolumn = "80"          -- vertical line marker at 80 chars
vim.opt.wrap = true                 -- enable visual text wrapping
vim.opt.textwidth = 80              -- line break after 80 chars
vim.opt.linebreak = true            -- don't break lines in the middle of word

-- 2.3.3 Search
vim.opt.hlsearch = true             -- highlight search results
vim.opt.incsearch = true            -- incrementally jump to search results
vim.opt.ignorecase = true           -- search queries are case-insensitive
vim.opt.smartcase = true            -- search queries are case-sensitive when cased


--==============================================================================
-- 3. Key Mappings
--==============================================================================

--------------------------------------------------------------------------------
-- 3.0 Training Wheels
--
-- Experimental or deprecated keybindings.
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 3.1 General
--------------------------------------------------------------------------------

vim.g.mapleader = " "

-- Open vimrc
vim.keymap.set("n", "<leader>ov", ":edit $MYVIMRC<cr>", { noremap = true, silent = true })

-- Edit vimrc
vim.keymap.set("n", "<leader>ev", ":vsplit $MYVIMRC<cr>", { noremap = true, silent = true })

-- Source vimrc
vim.keymap.set("n", "<leader>sv", ":source $MYVIMRC<cr>", { noremap = true, silent = true })

-- Clear search
vim.keymap.set("n", "<return>", ":noh<cr>", { noremap = true, silent = true })


--------------------------------------------------------------------------------
-- 3.2 Navigation
--------------------------------------------------------------------------------

-- Move into line wraps
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })

-- Nagivate window splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })


--------------------------------------------------------------------------------
-- 3.3 Editing
--------------------------------------------------------------------------------

-- make Y like D
vim.keymap.set("n", "Y", "y$", { noremap = true })


--------------------------------------------------------------------------------
-- 3.4 Terminal
--------------------------------------------------------------------------------

-- Removed navigation remaps like <c-h> so that they work in the terminal.
-- Instead, return to normal mode in order to access the window navigation
-- mappings

--------------------------------------------------------------------------------
-- 3.5 File Searching
--------------------------------------------------------------------------------

require("fzf-lua").setup({
   winopts = {
      preview = { default = "bat" }
   },
   files = {
      git_icons = false, -- disable since this degrades performance the most
      file_icons = true,
   }
})

vim.keymap.set("n", "<leader>p", ":lua require('fzf-lua').files()<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader><leader>", ":Files<cr>", { noremap = true, silent = true })
vim.api.nvim_create_user_command(
   "Rg",
   function(opts)
      require("fzf-lua").grep({
         search = opts.args,
         rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!{.git,node_modules}/*'",
      })
   end,
   { nargs = "*" }
)


--------------------------------------------------------------------------------
-- 3.6 Git
--------------------------------------------------------------------------------

-- Manage Git hunks
require("gitsigns").setup({
   on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
         opts = opts or {}
         opts.buffer = bufnr
         vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function()
         if vim.wo.diff then return "]c" end
         vim.schedule(function() gs.next_hunk() end)
         return "<Ignore>"
      end, {expr=true})

      map("n", "[c", function()
         if vim.wo.diff then return "[c" end
         vim.schedule(function() gs.prev_hunk() end)
         return "<Ignore>"
      end, {expr=true})

      -- Actions
      map({"n", "v"}, "<leader>hs", ":Gitsigns stage_hunk<CR>")
      map({"n", "v"}, "<leader>hr", ":Gitsigns reset_hunk<CR>")
      map("n", "<leader>hS", gs.stage_buffer)
      map("n", "<leader>hu", gs.undo_stage_hunk)
      map("n", "<leader>hR", gs.reset_buffer)
      map("n", "<leader>hp", gs.preview_hunk)
      map("n", "<leader>hb", function() gs.blame_line{full=true} end)
      map("n", "<leader>tb", gs.toggle_current_line_blame)
      map("n", "<leader>hd", gs.diffthis)
      map("n", "<leader>hD", function() gs.diffthis("~") end)
      map("n", "<leader>td", gs.toggle_deleted)

      -- Text object
      map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
   end
})

-- Fugitive Git commands
vim.keymap.set("n", "<leader>gbr", ":GBrowse master:%<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>gbr", ":GBrowse master:%<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gbl", ":Git blame<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gs", ":Git<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gc", ":Git commit<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gp", ":Git push<cr>", { noremap = true, silent = true })


--------------------------------------------------------------------------------
-- 3.7 Completion
--------------------------------------------------------------------------------

local cmp = require("cmp")

cmp.setup({
   snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
         require("luasnip").lsp_expand(args.body)
      end,
   },
   window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
   },

   mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      -- Accept currently selected item. Set `select` to `false` to only
      -- confirm explicitly selected items.
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
   }),

   sources = cmp.config.sources({
      -- priority of completions are based on array order
      -- completions are defined in fallback groups
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
   }, {
      { name = "buffer" },
   })
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
   sources = cmp.config.sources({
      { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
   }, {
      { name = "buffer" },
   })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {
      { name = "buffer" }
   }
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
   mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources({
      { name = "path" }
   }, {
      { name = "cmdline" }
   })
})


--------------------------------------------------------------------------------
-- 3.7 File Browser
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 3.8 Testing
--------------------------------------------------------------------------------

vim.g["test#python#runner"] = "nose"
vim.g["test#strategy"] = "neovim"
vim.keymap.set("n", "<leader>tn", ":TestNearest<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tl", ":TestLast<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tf", ":TestFile<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ts", ":TestSuite<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tv", ":TestVisit<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ti", ":TestInfo<cr>", { noremap = true, silent = true })


--------------------------------------------------------------------------------
-- 3.9 Snippets
--------------------------------------------------------------------------------

-- TODO: only keep snippet mappings and move configuration
local ls = require("luasnip")
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node
local date = function() return {os.date('%Y-%m-%d')} end
ls.add_snippets(nil, {
    all = {
        snip({
            trig = "date",
            namr = "Date",
            dscr = "Date in the form of YYYY-MM-DD",
        }, {
            func(date, {}),
        }),
    },
})


--------------------------------------------------------------------------------
-- 3.10 Semantic Analysis
--------------------------------------------------------------------------------


-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
   -- Enable completion triggered by <c-x><c-o>
   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

   -- Mappings.
   -- See `:help vim.lsp.*` for documentation on any of the below functions
   local bufopts = { noremap=true, silent=true, buffer=bufnr }
   vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
   vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
   vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
   vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
   vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
   vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
   vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
   vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
   end, bufopts)
   vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
   vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
   vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
   vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
   vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)
end

vim.lsp.enable("lua_ls")
vim.lsp.enable("bashls")
vim.lsp.enable("kotlin_language_server")
vim.lsp.enable("pyright")
vim.lsp.config("pylsp", {
   -- requires installing python-language-server, flake8, and pylint
   pylsp = {
      plugins = {
         flake8 = {
            enabled = false,
         },
         pycodestyle = {
            enabled = true,
            -- ignore = {'W391'},
            maxLineLength = 120,
         },
         pylint = {
            enabled = true,
            args = {"py3k", "score=n", "disable=F0001", "--max-line-length=120"},
         },
      },
   },
})

require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all"
  ensure_installed = { "python", "lua" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

return
