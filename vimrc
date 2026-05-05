" ==========================================
" General Settings
" ==========================================
set nocompatible               " disable legacy vi compatibility
set backspace=indent,eol,start " allow backspace over indent, eol, and insert start
set hidden                     " allow switching buffers without saving
set mouse=a                    " enable mouse support
set encoding=utf-8             " use UTF-8 encoding

" ==========================================
" UI & Display
" ==========================================
syntax on                      " enable syntax highlighting
set background=dark            " optimize colors for dark terminals
set number                     " show absolute line numbers
set relativenumber             " show relative line numbers
set cursorline                 " highlight the current line
set showcmd                    " show incomplete commands in the corner
set wildmenu                   " tab-completion menu in command mode
set noerrorbells               " suppress error sounds
set novisualbell               " suppress visual flash
set t_vb=                      " clear terminal bell code

" ==========================================
" Indentation
" ==========================================
filetype plugin indent on      " enable filetype detection, plugins, and indentation
set autoindent                 " inherit indentation from previous line
set smartindent                " smart indentation for C-like languages
set tabstop=8                  " tab character display width
set shiftwidth=8               " auto-indent width
set expandtab                  " convert tabs to spaces

" ==========================================
" Search
" ==========================================
set ignorecase                 " ignore case by default
set smartcase                  " case-sensitive search if pattern contains uppercase
set incsearch                  " incremental search
set hlsearch                   " highlight all search matches
nnoremap <ESC><ESC> :nohlsearch<CR>

" ==========================================
" Status Line
" ==========================================
set laststatus=2               " always show the status line
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ Ln\ %l,\ Col\ %c/%L%)

" ==========================================
" Automations
" ==========================================
" Restore cursor position when reopening a file
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" ==========================================
" WSL Clipboard (win32yank)
" ==========================================
if has("autocmd")
  augroup WslClipboard
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' && v:event.regname ==# '' | call system('win32yank.exe -i --crlf', @") | endif
  augroup END
endif

" Allow h/l/arrows/backspace/space to cross line boundaries
set whichwrap+=b,s,h,l,<,>,[,]

" Insert blank lines with Enter in normal mode
nnoremap <Enter> o<Esc>
nnoremap <S-Enter> O<Esc>

" Shift-Tab to decrease indentation
inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<

" :Wq alias for :wq
command! Wq wq

set clipboard=unnamedplus

" Reduce keybinding latency
set timeoutlen=300
set ttimeoutlen=50
