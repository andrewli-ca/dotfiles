return {
  -- Point nvim-lint's markdownlint-cli2 at the global config
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            vim.fn.expand("~/.markdownlint-cli2.yaml"),
            "--",
          },
        },
      },
    },
  },

  -- Use markdownlint-cli2 as the markdown formatter with format-on-save
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "markdownlint-cli2" },
        ["markdown.mdx"] = { "markdownlint-cli2" },
      },
      formatters = {
        ["markdownlint-cli2"] = {
          prepend_args = {
            "--config",
            vim.fn.expand("~/.markdownlint-cli2.yaml"),
          },
        },
      },
    },
  },
}
