return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "markdownlint-cli2" },
        python = { "ruff_organize_imports", "ruff_format" },
      },
    },
  },
}
