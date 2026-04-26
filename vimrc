" ==========================================
" 基本设置 (General Settings)
" ==========================================
set nocompatible               " 禁用与老版 vi 的兼容模式
set backspace=indent,eol,start " 允许退格键删除缩进、换行和插入前的内容
set hidden                     " 允许在有未保存修改时切换缓冲区(Buffer)而不报错
set mouse=a                    " 开启鼠标支持（支持鼠标点击定位、滚动和调整分屏，强烈推荐）
set encoding=utf-8             " 设置内部编码为 UTF-8

" ==========================================
" 界面与显示 (UI & Display)
" ==========================================
syntax on                      " 开启语法高亮
set background=dark            " 针对暗色终端优化高亮颜色
set number                     " 显示绝对行号
set relativenumber             " (可选) 开启相对行号，配合 number 使用在代码跳转时极佳
set cursorline                 " 高亮突出显示当前行
set showcmd                    " 在右下角显示正在输入的未完成命令
set wildmenu                   " 命令行模式下（输入 : 时）提供类似 IDE 的按 Tab 补全菜单
set noerrorbells               " 关闭错误提示音
set novisualbell               " 关闭可视闪屏提示
set t_vb=                      " 置空终端的响铃代码

" ==========================================
" 缩进与排版 (Indentation)
" ==========================================
filetype plugin indent on      " 开启文件类型检测，并加载对应的插件和缩进规则
set autoindent                 " 换行时继承上一行的缩进
set smartindent                " 针对 C/Java 等语言智能缩进
set tabstop=8                  " 文件中 Tab 字符显示的宽度为 8
set shiftwidth=8               " 自动缩进（如 >> 或 <<）的宽度为 8
set expandtab                  " 将输入的 Tab 自动转换为空格（避免不同编辑器下的排版混乱）

" ==========================================
" 搜索设置 (Search)
" ==========================================
set ignorecase                 " 搜索时默认忽略大小写
set smartcase                  " 智能大小写：若搜索词包含大写字母，则开启精确匹配
set incsearch                  " 增量搜索：输入搜索词时即时跳转并高亮
set hlsearch                   " 搜索完成后保留高亮显示所有结果
" 实用快捷键：双击 Esc 键清除搜索后的高亮显示
nnoremap <ESC><ESC> :nohlsearch<CR>

" ==========================================
" 状态栏设置 (Status Line)
" ==========================================
set laststatus=2               " 始终显示底部的状态栏（即使只有一个窗口）
" 保持你原有的精美状态栏配置
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ Ln\ %l,\ Col\ %c/%L%)

" ==========================================
" 自动化与实用脚本 (Automations)
" ==========================================
" 重新打开文件时，自动跳转到上次退出时的光标位置
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" ==========================================
" WSL 剪贴板打通 (使用 win32yank)
" ==========================================
if has("autocmd")
  augroup WslClipboard
    autocmd!
    " 只要触发了 y (yank) 复制操作，且使用的是默认寄存器，就自动同步到 Windows 剪贴板
    autocmd TextYankPost * if v:event.operator ==# 'y' && v:event.regname ==# '' | call system('win32yank.exe -i --crlf', @") | endif
  augroup END
endif

" 允许 h, l, 左右方向键, Backspace 和 Space 键跨越行边界
set whichwrap+=b,s,h,l,<,>,[,]

" 普通模式按下Enter 插入空行
nnoremap <Enter> o<Esc>
nnoremap <S-Enter> O<Esc>

" 减少缩进
inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<

" alias :wq == :Wq
command! Wq wq

set clipboard=unnamedplus

" 降低快捷键的等待时间
set timeoutlen=300
set ttimeoutlen=50
