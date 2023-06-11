-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.colorscheme = "retrobox"

local h = require("null-ls.helpers")
local cmd_resolver = require("null-ls.helpers.command_resolver")
local methods = require("null-ls.methods")
local u = require("null-ls.utils")
local FORMATTING = methods.internal.FORMATTING

local pe = h.make_builtin({
  name = "prettier_eslint",
  meta = {
    url = "https://github.com/prettier/prettier-eslint-cli",
    description = "Eslint + Prettier",
  },
  method = FORMATTING,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "jsx"
  },
  factory = h.formatter_factory,
  generator_opts = {
    command = "prettier-eslint",
    args = { "--stdin", "--parser", "babel", "--resolve-plugins-relative-to", "~/.nvm/versions/node/v16.16.0/lib" },
    to_stdin = true,
  },
})

local nls = require("null-ls")
nls.setup {
  on_attach = require("lvim.lsp").common_on_attach,
  sources = {
    pe,
    pejson
  }
}


local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "prettier",
    filetypes = { "typescript", "typescriptreact" },
  },
}

lvim.format_on_save = true

lvim.plugins = {
  { "folke/neodev.nvim" },
  { "ellisonleao/gruvbox.nvim" },
}
