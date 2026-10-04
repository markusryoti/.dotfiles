local width, use_tab, tab_width = 4, false, 4

local file = vim.api.nvim_buf_get_name(0)
local dir = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
if #vim.fs.find({ ".clang-format", "_clang-format" }, { upward = true, path = dir }) > 0 then
  -- --dump-config resolves BasedOnStyle and any per-language sections for us.
  local ok, res = pcall(function()
    return vim
      .system({ "clang-format", "--dump-config", "--assume-filename=" .. (file ~= "" and file or "x.cpp") }, { cwd = dir })
      :wait()
  end)
  if ok and res.code == 0 then
    width = tonumber(res.stdout:match("\nIndentWidth:%s*(%d+)")) or width
    tab_width = tonumber(res.stdout:match("\nTabWidth:%s*(%d+)")) or width
    use_tab = (res.stdout:match("\nUseTab:%s*(%a+)") or "Never") ~= "Never"
  end
end

vim.bo.expandtab = not use_tab
vim.bo.shiftwidth = width
vim.bo.softtabstop = width
vim.bo.tabstop = use_tab and tab_width or width
