set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')

" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Nerd Tree
Plugin 'scrooloose/nerdtree'
let g:NERDTreeChDirMode=2


" comment plugin
Plugin 'scrooloose/nerdcommenter'

" TagList
" Plugin 'vim-scripts/taglist.vim.git'
" Airline
Plugin 'bling/vim-airline.git'
" YCM
"if has("gui_macvim")
    "Plugin 'https://github.com/Valloric/YouCompleteMe.git'
    "let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"endif

"
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin


" Color scheme
colorscheme badwolf

syntax enable           " shortname for a command
set tabstop=4           " Tab convert rule when open a file
set softtabstop=4
set cursorline          " highlight current cursor line
set wildmenu            " autocompletes
filetype indent on      " load filetype-specific indent files
filetype plugin on

set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]

" Font setting
if has('gui_running')
    set guioptions-=T  " no toolbar
    colorscheme elflord
    set lines=60 columns=100 linespace=-4
    if has('gui_win32')
        set guifont=DejaVu_Sans_Mono:h10:cANSI
    else
        set guifont=Andale\ Mono\ 12
    endif
endif

exec ":set nu!"
exec ":set expandtab"
exec ":set shiftwidth=4"

set cindent

set encoding=utf-8
set fileencodings=utf-8,chinese,latin-1
if has("win32")
set fileencoding=chinese
else
set fileencoding=utf-8
endif
"解决菜单乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"解决consle输出乱码
language messages zh_CN.utf-8

" gpf def
map <F9> :w <CR> :! python %<CR>
map <F8> :w <CR> :! g++ -g  % -std=c++11 -o %< <CR> :! ./%< 
map J $
map F <ESC>:!python ~/PythonTidy-1.22.python % % <cr>
map <F2> :cd %:p:h<cr> :NERDTreeCWD<cr><cr> :set columns=100<cr>
map <F3> :TlistToggle<CR>
imap <S-Tab> <C-N>
map <C-f> q:p0i/<CR>
map <C-s> <Esc>:w<CR>
map <C-x> <Esc>:q<CR>

" Copy & paste
map <c-p> "+p<cr>
map <c-y> "+y<cr>
imap <c-p> <esc>"+p<cr>
imap <c-y> <esc>"+y<cr>

nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>
nmap S :w<cr>
map <C-a> ggvG
map <C-k> :pyf /usr/local/Cellar/clang-format/2015-09-01/share/clang/clang-format.py<cr>
imap <C-k> :pyf /usr/local/Cellar/clang-format/2015-09-01/share/clang/clang-format.py<cr>

"  map for recording
nnoremap Q @q
vnoremap Q :norm :@q

highlight ColorColumn ctermbg=magenta guibg=#584c5d guifg=#000000
call matchadd('ColorColumn', '\%81v', 100)
set colorcolumn=81

set cursorcolumn
set cursorline

" Airline display for single file
set laststatus=2
set backupdir=/tmp,.
set directory=/tmp,.

"open nerdtree

" autocmd VimEnter * NERDTree
