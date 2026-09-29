-- Basic
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"

-- UI
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.errorbells = false
vim.opt.visualbell = false

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })

-- Status line
vim.opt.laststatus = 2
vim.opt.statusline = [[ %<%F[%1*%M%*%n%R%H]%= %y %0(%{&fileformat} %{&encoding} Ln %l, Col %c/%L%)]]

-- Restore cursor position when reopening a file
local restore_cursor_group = vim.api.nvim_create_augroup("RestoreCursor", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = restore_cursor_group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Restore cursor position when reopening a file",
})

-- Allow h/l/arrows/backspace/space to cross line boundaries
vim.opt.whichwrap:append("b,s,h,l,<,>,[,]")

-- Key mappings
-- 删除时不污染剪贴板 (重定向至黑洞寄存器 "_)
vim.keymap.set({ "n", "x" }, "d", '"_d', { desc = "Delete without overwriting clipboard" })
vim.keymap.set({ "n", "x" }, "D", '"_D', { desc = "Delete to end of line without overwriting clipboard" })

vim.keymap.set("n", "<CR>", "o<Esc>", { desc = "Insert blank line below" })
vim.keymap.set("n", "<S-CR>", "O<Esc>", { desc = "Insert blank line above" })
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Outdent in insert mode" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Outdent current line" })
vim.api.nvim_create_user_command("Wq", "wq", { desc = "Alias for wq" })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("v", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("v", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Reduce keybinding latency
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 50

-- 关闭自动添加注释的行为
local no_auto_comment_group = vim.api.nvim_create_augroup("NoAutoComment", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = no_auto_comment_group,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable auto-commenting on newline",
})

-- 增强型 URL 打开功能 (增强 gx 快捷键)
local function extract_url(str)
  local text = vim.trim(str or "")
  -- 优先匹配完整协议 URL
  local url = vim.fn.matchstr(text, [[\%(\%(https\?\|ftp\|file\)://\S\{-}\ze[^A-Za-z0-9/]*$\)]])
  if url ~= "" then
    return url
  end

  -- 去除两侧的括号、引号、尖括号等常见包裹字符
  local cleaned = vim.fn.substitute(text, [[^[("'<\[]\+\|[)'">\]\.,;:]\+$]], "", "g")
  url = vim.fn.matchstr(cleaned, [[\%(\%(https\?\|ftp\|file\)://\S\+\)]])
  if url ~= "" then
    return url
  end

  -- 针对缺少协议头的常见 Web 地址自动补全 https://
  if vim.fn.match(cleaned, [[^\%(www\.\k\+\|github\.com\|\k\+\.\%(com\|org\|net\|cn\|io\|dev\|edu\|cc\|me\|info\)\%(/.*\|\>\)\)]]) ~= -1 then
    return "https://" .. cleaned
  end

  return nil
end

local function open_url(target)
  if not target or target == "" then
    return false
  end
  local url = extract_url(target)
  if url then
    vim.ui.open(url)
    vim.notify("Opening: " .. url, vim.log.levels.INFO)
    return true
  end
  return false
end

vim.keymap.set("n", "gx", function()
  local cword = vim.fn.expand("<cWORD>")
  if open_url(cword) then
    return
  end
  vim.ui.open(vim.fn.expand("<cfile>"))
end, { silent = true, desc = "Open URL under cursor" })

vim.keymap.set("x", "gx", function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getregion(start_pos, end_pos, { type = vim.fn.visualmode() })
  local selected = table.concat(lines, "\n")
  if open_url(selected) then
    return
  end
  vim.ui.open(selected)
end, { silent = true, desc = "Open selected URL" })
