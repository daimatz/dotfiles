local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nanotech/jellybeans.vim",
    priority = 1000, -- ← 重要：テーマは最優先で読み込む
  },
})

vim.opt.background = "dark"

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.cmd("highlight Comment guifg=#888888 guibg=NONE ctermfg=245 ctermbg=NONE cterm=NONE gui=NONE")
  end,
})

vim.cmd("colorscheme jellybeans")

vim.g.mapleader = " "

-- 起動時 cwd を $P に固定（:tabedit $P/... で参照）
vim.env.P = vim.fn.getcwd()

-- ===== 基本設定 =====
vim.opt.encoding = "utf-8"
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.scrolloff = 10

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.undofile = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.laststatus = 2
vim.opt.showcmd = true
vim.opt.display = "lastline"
vim.opt.foldlevel = 10000

vim.opt.list = true
vim.opt.listchars = { tab = "^ ", trail = " " }

vim.opt.textwidth = 80
vim.opt.colorcolumn = "81,82"

vim.opt.backspace = "indent,eol,start"
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"

vim.opt.shortmess:append("I")

vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

-- ===== 診断は静かに =====
vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- ===== ヘルパー =====
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ===== 基本キーマップ（維持価値高いもの） =====

-- 誤爆防止
map("n", "ZZ", "<Nop>", opts)

-- 表示行移動
map({ "n", "v" }, "j", "gj", opts)
map({ "n", "v" }, "k", "gk", opts)
map({ "n", "v" }, "<Down>", "gj", opts)
map({ "n", "v" }, "<Up>", "gk", opts)

-- x / X はブラックホール
map({ "n", "v" }, "x", '"_x', opts)
map({ "n", "v" }, "X", '"_X', opts)

-- 行頭へ
map({ "n", "v" }, "<BS>", "^", opts)
map({ "n", "v" }, "<C-h>", "^", opts)

-- jj で抜ける
map("i", "jj", "<Esc>", opts)
map("c", "jj", "<Esc>", opts)

-- ; と : を交換
map({ "n", "v" }, ";", ":", { noremap = true })
map({ "n", "v" }, ":", ";", { noremap = true })

-- 検索後は中央寄せ
map("n", "#", "*Nzz", opts)
map("n", "n", "nzz", opts)
map("n", "N", "Nzz", opts)

-- insert mode のカーソル移動・編集
map("i", "<C-f>", "<Right>", opts)
map("i", "<C-b>", "<Left>", opts)
map("i", "<C-n>", "<Down>", opts)
map("i", "<C-p>", "<Up>", opts)
map("i", "<C-a>", "<Home>", opts)
map("i", "<C-e>", "<End>", opts)
map("i", "<C-d>", "<Delete>", opts)
map("i", "<C-h>", "<BS>", opts)
map("i", "<C-m>", "<CR>", opts)
map("i", "<C-o>", "<CR><Up>", opts)

-- cmdline mode のカーソル移動・編集
map("c", "<C-f>", "<Right>", opts)
map("c", "<C-b>", "<Left>", opts)
map("c", "<C-n>", "<Down>", opts)
map("c", "<C-p>", "<Up>", opts)
map("c", "<C-a>", "<Home>", opts)
map("c", "<C-e>", "<End>", opts)
map("c", "<C-d>", "<Delete>", opts)
map("c", "<C-h>", "<BS>", opts)
map("c", "<C-m>", "<CR>", opts)
map("c", "<C-o>", "<CR><Up>", opts)

-- ===== prefix キー系 =====
-- Space を prefix 的に使うため、素の Space を無効化
map({ "n", "v" }, "<Space>", "<Nop>", opts)

-- タブ/ウィンドウ操作のうち plugin 非依存なものだけ維持
map("n", "tn", "<Cmd>tabnext<CR>", opts)
map("n", "tp", "<Cmd>tabprevious<CR>", opts)
map("n", "te", ":tabedit ", { noremap = true })
map("n", "tc", ":tabedit ", { noremap = true })
map("n", "td", "<Cmd>split<CR><C-w>T", opts)
map("n", "th", "<C-w>h", opts)
map("n", "tj", "<C-w>j", opts)
map("n", "tk", "<C-w>k", opts)
map("n", "tl", "<C-w>l", opts)
map("n", "ts", "<Cmd>split<CR>", opts)
map("n", "tv", "<Cmd>vsplit<CR>", opts)
map("n", "t<Space>", "<Cmd>split<CR>", opts)
map("n", "tm", "<Cmd>vsplit<CR>", opts)
map("n", "t<CR>", "<Cmd>vsplit<CR>", opts)
map("n", "t=", "<C-w>=", opts)
map("n", "tN", "<Cmd>tabmove +1<CR>", opts)
map("n", "tP", "<Cmd>tabmove -1<CR>", opts)
map("n", "tf", "<Cmd>tabedit .<CR>", opts)

-- ===== 保存前処理 =====
local function trim_trailing_whitespace()
  local view = vim.fn.winsaveview()
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.winrestview(view)
end

local function tab_to_space()
  local blacklist = { make = true, go = true }
  if blacklist[vim.bo.filetype] then
    return
  end
  local view = vim.fn.winsaveview()
  vim.cmd([[%s/\t/  /ge]])
  vim.fn.winrestview(view)
end

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    trim_trailing_whitespace()
    tab_to_space()
  end,
})

-- markdown 扱い
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.txt",
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- pane フラッシュ（tmux-pop が nvim 上で効かない問題の補完）
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local orig = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    vim.api.nvim_set_hl(0, "Normal", { fg = orig.fg, bg = "#333333" })
    vim.defer_fn(function()
      vim.api.nvim_set_hl(0, "Normal", orig)
    end, 100)
  end,
})

-- 前回カーソル位置へ復帰
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local line = vim.fn.line([['"]])
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- バッファのあるディレクトリへ移動
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local dir = vim.fn.expand("%:p:h")
    if dir ~= "" then
      vim.cmd("lcd " .. vim.fn.fnameescape(dir))
    end
  end,
})

-- 見た目
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 52, bg = "darkred" })
vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 235 })
vim.api.nvim_set_hl(0, "CursorColumn", { ctermbg = 236 })
vim.api.nvim_set_hl(0, "Visual", { ctermbg = 95, bg = "#87435a" })
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#e8e8d3", bg = "#455178", ctermfg = 187, ctermbg = 61 })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#909090", bg = "#333555", ctermfg = 246, ctermbg = 60 })

vim.opt.cursorline = true
vim.opt.cursorcolumn = true
