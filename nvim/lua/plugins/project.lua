local exclude = { ".git", "node_modules" }

local function file_dir()
  return vim.fn.expand("%:p:h")
end

return {
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        manual_mode = true,
      })
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = { hidden = true, ignored = true, exclude = { ".git" } },
        },
      },
    },
    keys = {
      { "<leader>f.", function() Snacks.picker.files({ cwd = file_dir() }) end, desc = "Find Files (file dir)" },
      { "<leader>s.", function() Snacks.picker.grep({ cwd = file_dir() }) end, desc = "Grep (file dir)" },
      {
        "<leader>fa",
        function() Snacks.picker.files({ cwd = LazyVim.root(), hidden = true, ignored = true, exclude = exclude }) end,
        desc = "Find All Files (hidden + ignored)",
      },
      {
        "<leader>sA",
        function() Snacks.picker.grep({ cwd = LazyVim.root(), hidden = true, ignored = true, exclude = exclude }) end,
        desc = "Grep All (hidden + ignored)",
      },
    },
  },
}
