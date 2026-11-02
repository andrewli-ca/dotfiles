return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              tsserver = {
                -- Default 3072MB OOMs on large monorepos
                maxTsServerMemory = 8192,
              },
            },
          },
        },
      },
    },
  },
}
