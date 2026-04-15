local function is_macos_dark()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if not handle then
    return true
  end
  local result = handle:read("*a")
  handle:close()
  return result:match("Dark") ~= nil
end

local function apply(mode)
  if mode == "dark" then
    vim.o.background = "dark"
    vim.cmd.colorscheme("kanso-zen")
  else
    vim.o.background = "light"
    vim.cmd.colorscheme("kanso-pearl")
  end
end

return {
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      apply(is_macos_dark() and "dark" or "light")
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 999,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        apply("dark")
      end,
      set_light_mode = function()
        apply("light")
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = is_macos_dark() and "kanso-zen" or "kanso-pearl"
    end,
  },
}
