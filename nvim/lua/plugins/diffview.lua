-- Resolve the repo's default branch: origin/HEAD, then local main or master
local function default_branch()
  local ref = vim.fn.systemlist({ "git", "rev-parse", "--abbrev-ref", "origin/HEAD" })[1]
  if vim.v.shell_error == 0 and ref and ref ~= "origin/HEAD" then
    return ref
  end
  for _, branch in ipairs({ "main", "master" }) do
    vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", branch })
    if vim.v.shell_error == 0 then
      return branch
    end
  end
end

local function diff_vs_default_branch()
  local branch = default_branch()
  if not branch then
    vim.notify("Couldn't find a default branch (origin/HEAD, main or master)", vim.log.levels.WARN)
    return
  end
  vim.cmd("DiffviewOpen " .. branch .. "...HEAD --imply-local")
end

local PANEL_WIDTH = 35

-- While focused, the file panel widens to its longest line (capped so the diff
-- keeps most of the screen); otherwise it stays compact
local function size_file_panel(panel)
  if not (panel:is_open() and panel.state.form == "column") then
    return
  end
  local width = PANEL_WIDTH
  if vim.api.nvim_get_current_win() == panel.winid then
    local longest = 0
    for _, line in ipairs(vim.api.nvim_buf_get_lines(panel.bufid, 0, -1, false)) do
      longest = math.max(longest, vim.fn.strdisplaywidth(line))
    end
    width = math.max(PANEL_WIDTH, math.min(longest + 2, math.floor(vim.o.columns * 0.4)))
  end
  vim.api.nvim_win_set_width(panel.winid, width)
end

-- Keep files that diffview opens out of the buffer list (and bufferline); files
-- already open stay listed, and opening one normally lists it again
vim.api.nvim_create_autocmd("BufAdd", {
  group = vim.api.nvim_create_augroup("diffview_unlist_buffers", { clear = true }),
  callback = function(ev)
    local lib = package.loaded["diffview.lib"]
    if lib and lib.get_current_view() then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ev.buf) then
          vim.bo[ev.buf].buflisted = false
        end
      end)
    end
  end,
})

return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    opts = {
      file_panel = {
        win_config = { width = PANEL_WIDTH },
      },
      hooks = {
        view_opened = function(view)
          if not (view.panel and view.emitter) then
            return
          end
          local panel = view.panel
          local resize = function() vim.schedule(function() size_file_panel(panel) end) end
          view.emitter:on("files_updated", resize)
          vim.api.nvim_create_autocmd("WinEnter", {
            group = vim.api.nvim_create_augroup("diffview_panel_width_" .. view.tabpage, { clear = true }),
            callback = function()
              if vim.api.nvim_get_current_tabpage() == view.tabpage then
                resize()
              end
            end,
          })
        end,
        view_closed = function(view)
          pcall(vim.api.nvim_del_augroup_by_name, "diffview_panel_width_" .. view.tabpage)
        end,
      },
    },
    keys = {
      { "<leader>gvv", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gvm", diff_vs_default_branch, desc = "Diffview vs default branch" },
      { "<leader>gvq", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
      { "<leader>gvh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
      { "<leader>gvh", ":DiffviewFileHistory<cr>", mode = "v", desc = "Diffview Line History" },
      { "<leader>gvH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview Repo History" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>gv", group = "diffview" },
      },
    },
  },
}
