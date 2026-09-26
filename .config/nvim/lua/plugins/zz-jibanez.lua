return {
  -- Keep Kanagawa even when the OS theme changes.
  { "theme-hotreload", enabled = false },
  { "rebelot/kanagawa.nvim", priority = 1000 },

  {
    "folke/snacks.nvim",
    keys = {
      { "<C-p>", function() Snacks.picker.files() end, desc = "Find files" },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "kanagawa" },
    init = function()
      vim.opt.expandtab = true
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.smartindent = true
      vim.opt.colorcolumn = "80"
      vim.opt.cursorline = false
      vim.opt.scrolloff = 4
      vim.opt.list = true
      vim.opt.listchars = { tab = "»·", trail = "·" }
      vim.g.c_syntax_for_h = 1
    end,
  },
}
