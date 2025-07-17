-- Basic Neovim settings
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.helplang = "en"
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Auto-install lazy.nvim if needed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup with error handling
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  vim.notify("Failed to load lazy.nvim", vim.log.levels.ERROR)
  return
end

lazy.setup({
  { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-tree/nvim-tree.lua" },
  { "lewis6991/gitsigns.nvim" },
})

-- Key mappings
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")

-- Plugin configurations with error handling
local function safe_require(module, config)
  local status_ok, plugin = pcall(require, module)
  if not status_ok then
    vim.notify("Failed to load " .. module, vim.log.levels.ERROR)
    return
  end
  if config then
    plugin.setup(config)
  else
    plugin.setup()
  end
end

safe_require("nvim-tree")
safe_require("gitsigns")

-- Setup mason first
require("mason").setup()

-- Setup LSP servers
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "lua_ls", "pyright", "bashls", "jsonls" }
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities
  }
end

-- Autocompletion
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = { { name = 'nvim_lsp' } }
})

-- Treesitter
require("nvim-treesitter.configs").setup {
  ensure_installed = { "lua", "python", "bash", "json", "yaml", "markdown", "vim", "vimdoc" },
  highlight = { enable = true },
}

-- Generate helptags for all plugins
vim.cmd([[silent! helptags ALL]])

-- Configure help window behavior
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
  end,
})

