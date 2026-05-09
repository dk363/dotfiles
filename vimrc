" Basic
set nocompatible
set backspace=indent,eol,start
set hidden                     " allow switching buffers without saving
set noswapfile
set mouse=a
set encoding=utf-8
set clipboard=unnamedplus

" UI
syntax on
set background=dark
set number
set relativenumber
set cursorline
set showcmd
set wildmenu
set noerrorbells novisualbell
set t_vb=

" Indentation
filetype plugin indent on
set autoindent
set smartindent
set tabstop=8
set shiftwidth=8
set expandtab

" Search
set ignorecase
set smartcase                  " case-sensitive when pattern has uppercase
set incsearch
set hlsearch
nnoremap <ESC><ESC> :nohlsearch<CR>

" Status line
set laststatus=2
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ Ln\ %l,\ Col\ %c/%L%)

" Restore cursor position when reopening a file
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Allow h/l/arrows/backspace/space to cross line boundaries
set whichwrap+=b,s,h,l,<,>,[,]

" Key mappings
nnoremap <Enter> o<Esc>
nnoremap <S-Enter> O<Esc>
inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<
command! Wq wq

" Reduce keybinding latency
set timeoutlen=300
set ttimeoutlen=50
