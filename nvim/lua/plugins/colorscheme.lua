return {
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
      local is_dark = true
      if handle then
        local result = handle:read("*a")
        handle:close()
        is_dark = result:match("Dark") ~= nil
      end
      vim.cmd.colorscheme(is_dark and "kanso-ink" or "kanso-pearl")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanso-ink",
    },
  },
}
