-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        "rebelot/kanagawa.nvim",
        { "neovim/nvim-lspconfig" },
        {
            "lewis6991/gitsigns.nvim",
            opts = {},
        },
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = {
                "nvim-lua/plenary.nvim",
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            },
            config = function()
                            end,
        },
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        { "ThePrimeagen/99" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true, notify = false },
})

-- Custom config

-- Indent
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

-- UI
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.opt.ruler = true
vim.opt.wrap = false
vim.opt.colorcolumn = "80"
vim.opt.cursorline = false
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 4

-- Search
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.keymap.set("n", "<leader><Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- Editing
vim.opt.errorbells = false
vim.opt.backspace = "2"
vim.opt.encoding = "utf-8"

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

-- Display useless whitespaces
vim.opt.list = true
vim.opt.listchars = { tab = "»·", trail = "·" }
vim.cmd("highlight SpecialKey ctermfg=darkred")

vim.g.c_syntax_for_h = 1

-- Style
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd("syntax on")
vim.cmd("colorscheme kanagawa")

-- Completion
vim.opt.completeopt = { "fuzzy", "menu" }
vim.keymap.set("i", "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    end
    local col = vim.fn.col(".")
    local line = vim.fn.getline(".")
    if col <= 1 or line:sub(1, col - 1):match("^%s*$") then
        return "<Tab>"
    end
    return "<C-n>"
end, { expr = true, silent = true })

-- Telescope
local telescope = require("telescope")
telescope.setup({
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
})
pcall(telescope.load_extension, "fzf")
local ok, builtin = pcall(require, "telescope.builtin")
if ok then
    vim.keymap.set("n", "<C-p>", builtin.find_files, { silent = true, desc = "Find files" })
end

-- Harpoon
local harpoon = require("harpoon")
harpoon:setup({
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
    },
    cmd = {
        create_list_item = function(_, value)
            return { value = value, context = {} }
        end,
        select = function(item)
            if item == nil or item.value == nil or item.value == "" then
                return
            end
            vim.cmd("!" .. item.value)
        end,
    },
})
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add file" })
vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
vim.keymap.set("n", "<leader>ca", function()
    local cmd = vim.fn.input("Harpoon cmd: ")
    vim.cmd("redraw")
    vim.cmd("echo ''")
    if cmd ~= "" then
        harpoon:list("cmd"):add({ value = cmd, context = {} })
    end
end, { desc = "Harpoon add cmd" })
vim.keymap.set("n", "<leader>ce", function() harpoon.ui:toggle_quick_menu(harpoon:list("cmd")) end,
    { desc = "Harpoon cmd menu" })
vim.keymap.set("n", "<leader>c1", function() harpoon:list("cmd"):select(1) end, { desc = "Harpoon cmd 1" })
vim.keymap.set("n", "<leader>c2", function() harpoon:list("cmd"):select(2) end, { desc = "Harpoon cmd 2" })
vim.keymap.set("n", "<leader>c3", function() harpoon:list("cmd"):select(3) end, { desc = "Harpoon cmd 3" })
vim.keymap.set("n", "<leader>c4", function() harpoon:list("cmd"):select(4) end, { desc = "Harpoon cmd 4" })
vim.keymap.set("n", "<leader>5", function() vim.cmd("!ls") end, { desc = "Test cmd" })

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.bo[args.buf].tagfunc = "v:lua.vim.lsp.tagfunc"
    end,
})
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
-- Rust
vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            procMacro = { enable = false },
            cargo = { buildScripts = { enable = false } },
        },
    },
})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
vim.lsp.enable("rust_analyzer")
-- C
vim.lsp.enable("clangd")

-- 99
local _99 = require("99")
_99.setup({
    provider = _99.OpenCodeProvider,
    model = "openai/gpt-5.3-codex",
    tmp_dir = vim.fn.stdpath("state"),
})
vim.keymap.set("v", "<leader>99", function()
    _99.visual()
end, { desc = "99" })
vim.keymap.set("n", "<leader>9s", function()
    _99.search()
end, { desc = "99 search request" })
vim.keymap.set("n", "<leader>9x", function()
    _99.stop_all_requests()
end, { desc = "99 stop requests" })
-- Open window to change model
vim.keymap.set("n", "<leader>9m", function()
  require("99.extensions.telescope").select_model()
end)
