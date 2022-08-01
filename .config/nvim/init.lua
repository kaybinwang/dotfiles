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
   use {
      "sonph/onehalf",
      rtp = "vim",
      -- need to delay setting colorscheme since plugin isn't added RTP until
      -- the plugin loads
      config = "vim.cmd 'colorscheme onehalflight'"
   }
   use "kyazdani42/nvim-web-devicons"     -- accessors for dev icons
   use {
      "nvim-treesitter/nvim-treesitter",  -- semantic syntax highlighting
      run = function()
         require("nvim-treesitter.install").update({ with_sync = true })
      end,
   }

   -- 1.2.2 Text Editing & Navigation
   use "tpope/vim-surround"      -- wrap text objects with ({[
   use "tpope/vim-commentary"    -- toggle comments
   use "tpope/vim-unimpaired"    -- pairwise mappings e.g. ]q and [q,
   use "tpope/vim-repeat"        -- repeat tpope's mappings

   -- 1.2.3 Search
   use {
      "ibhagwan/fzf-lua",        -- FZF integration for fuzzy searching
      -- optional for icon support
      requires = { "kyazdani42/nvim-web-devicons" }
   }

   -- 1.2.4 Developer Tools
   use "neovim/nvim-lspconfig"   -- Configurations for Nvim LSP
   use "tpope/vim-fugitive"
   use "tpope/vim-rhubarb"       -- GitHub extension for vim-fugitive
   use "airblade/vim-gitgutter"  -- show modified hunks in column margins
   use "tpope/vim-eunuch"        -- Vim sugar for UNIX commands
   use "janko-m/vim-test"

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
vim.opt.complete = vim.opt.complete:remove("i")       -- don't include all files, it's slow
vim.opt.shortmess = vim.opt.shortmess:append("aAIsT") -- disable welcome screen and other messages
vim.opt.startofline = false                           -- keeps cursor in place when switching buffers

-- 2.1.1 Backups
vim.opt.backup = false                                -- don't save backups
vim.opt.swapfile = false                              -- no swapfiles
vim.opt.writebackup = false                           -- don't save a backup while editing

-- 2.1.2 Undo History
vim.opt.undofile = true                               -- maintain undo history between sessions
vim.opt.undolevels = 10000                            -- store 10000 undos

-- 2.1.3 Auto Save

--------------------------------------------------------------------------------
-- 2.2 User Interface
--------------------------------------------------------------------------------

-- 2.2.1 Theme
-- vim.cmd "colorscheme onehalflight"
vim.opt.background = "light"

-- 2.2.2 Buffers
vim.opt.number = true                        -- line numbers
vim.opt.cursorline = true                    -- highlight current line
vim.opt.list = true                          -- show invisible characters
vim.opt.listchars = "tab:>·,trail:·,nbsp:¬"  -- but only show useful characters
vim.opt.lazyredraw = true                    -- don't draw everything
vim.opt.updatetime = 100                     -- faster updates, used for git gutter

-- 2.2.3 Status Line

statusline = require("statusline")

vim.opt.statusline = table.concat({
   " ",
   "%-{luaeval('statusline.mode()')}",
   "%-{luaeval('statusline.paste()')}",
   "%#Pmenu#",
   "| ",
   "%-{luaeval('statusline.git_branch()')}",
   "| ",
   "%-{luaeval('statusline.readonly()')}",
   "%f ",
   "%-{luaeval('statusline.modified()')}",
   " ",
   "%#Visual#",
   "%=",
   "%-{luaeval('statusline.file_format()')}",
   " | ",
   "%-{luaeval('statusline.file_encoding()')}",
   " | ",
   "%-{luaeval('statusline.file_type()')}",
   " | ",
   "%3p%%",                                        -- percentage through file in lines
   " | ",
   "%4l:%-4c",                                     -- line number : column number
})


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
vim.api.nvim_set_keymap("n", "<leader>ov", ":edit $MYVIMRC<cr>", { noremap = true, silent = true })

-- Edit vimrc
vim.api.nvim_set_keymap("n", "<leader>ev", ":vsplit $MYVIMRC<cr>", { noremap = true, silent = true })

-- Source vimrc
vim.api.nvim_set_keymap("n", "<leader>sv", ":source $MYVIMRC<cr>", { noremap = true, silent = true })

-- Clear search
vim.api.nvim_set_keymap("n", "<return>", ":noh<cr>", { noremap = true, silent = true })


--------------------------------------------------------------------------------
-- 3.2 Navigation
--------------------------------------------------------------------------------

-- Move into line wraps
vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true })

-- Nagivate window splits
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true })


--------------------------------------------------------------------------------
-- 3.3 Editing
--------------------------------------------------------------------------------

-- make Y like D
vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true })


--------------------------------------------------------------------------------
-- 3.4 Terminal
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 3.5 File Searching
--------------------------------------------------------------------------------

vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><leader>", ":Files<cr>", { noremap = true, silent = true })
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

-- Move to next git modification
vim.api.nvim_set_keymap("n", "<leader>gp", ":GitGutterPreviewHunk<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gu", ":GitGutterUndoHunk<cr>", { noremap = true, silent = true })

-- Fugitive Git commands
vim.api.nvim_set_keymap("n", "<leader>gbr", ":GBrowse master:%<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gbl", ":Git blame<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gd", ":Gdiffsplit<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gs", ":Git<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit<cr>", { noremap = true, silent = true })


--------------------------------------------------------------------------------
-- 3.7 File Browser
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

local lspconfig = require("lspconfig")

lspconfig.bashls.setup({on_attach = on_attach})

lspconfig.kotlin_language_server.setup({on_attach = on_attach})

lspconfig.pylsp.setup({on_attach = on_attach})

lspconfig.sumneko_lua.setup({
   on_attach = on_attach,
   settings = {
      Lua = {
         runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
         },
         diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {"vim"},
         },
         workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
         },
         -- Do not send telemetry data containing a randomized but unique identifier
         telemetry = {
            enable = false,
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
