" ==========================================
" 基本设置 (General Settings)
" ==========================================
set nocompatible               " 禁用与老版 vi 的兼容模式
set backspace=indent,eol,start " 允许退格键删除缩进、换行和插入前的内容
set hidden                     " 允许在有未保存修改时切换缓冲区
set mouse=a                    " 开启鼠标支持
set encoding=utf-8             " 设置内部编码为 UTF-8
set clipboard=unnamedplus      " 使用系统剪贴板（与 + 寄存器共享）
set whichwrap+=b,s,h,l,<,>,[,] " 允许部分按键跨越行边界
set timeoutlen=300             " 快捷键序列等待时间（毫秒）
set ttimeoutlen=50             " 按键码序列等待时间（毫秒）

" ==========================================
" 界面与显示 (UI & Display)
" ==========================================
syntax on                      " 开启语法高亮
set background=dark            " 针对暗色终端优化高亮颜色
set number                     " 显示绝对行号
set relativenumber             " 显示相对行号，便于代码跳转
set cursorline                 " 高亮当前行
set showcmd                    " 在右下角显示正在输入的命令
set wildmenu                   " 命令行模式下提供 Tab 补全菜单
set noerrorbells               " 关闭错误提示音
set novisualbell               " 关闭可视闪屏提示
set t_vb=                      " 置空终端响铃代码

" ==========================================
" 缩进与排版 (Indentation)
" ==========================================
filetype plugin indent on      " 开启文件类型检测，加载对应的插件和缩进规则
set autoindent                 " 换行时继承上一行的缩进
set smartindent                " 针对 C/Java 等语言智能缩进
set tabstop=8                  " Tab 字符显示的宽度
set shiftwidth=8               " 自动缩进宽度
set expandtab                  " 将输入的 Tab 转换为空格

" ==========================================
" 搜索设置 (Search)
" ==========================================
set ignorecase                 " 搜索时默认忽略大小写
set smartcase                  " 若搜索词包含大写字母，则开启精确匹配
set incsearch                  " 增量搜索：输入时即时跳转并高亮
set hlsearch                   " 搜索完成后保留高亮显示所有结果
nnoremap <ESC><ESC> :nohlsearch<CR>      " 双击 Esc 清除搜索高亮

" ==========================================
" 快捷键 (Key Mappings)
" ==========================================
nnoremap <Enter> o<Esc>        " 普通模式下 Enter 在下方插入空行
nnoremap <S-Enter> O<Esc>      " 普通模式下 Shift+Enter 在上方插入空行
inoremap <S-Tab> <C-d>         " 插入模式下 Shift+Tab 减少缩进
nnoremap <S-Tab> <<            " 普通模式下 Shift+Tab 减少缩进
command! Wq wq                 " Wq 等同于 wq

" ==========================================
" 状态栏设置 (Status Line)
" ==========================================
set laststatus=2               " 始终显示状态栏
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ Ln\ %l,\ Col\ %c/%L%)

" ==========================================
" 自动化 (Automations)
" ==========================================
if has("autocmd")
  " 重新打开文件时，自动跳转到上次退出时的光标位置
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" ==========================================
" WSL 剪贴板 (WSL Clipboard)
" ==========================================
if has("autocmd")
  augroup WslClipboard
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' && v:event.regname ==# '' | call system('win32yank.exe -i --crlf', @") | endif
  augroup END
endif
