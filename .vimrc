set nocompatible              " be iMproved, required
filetype off                  " required

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'

" Initialize plugin system
call plug#end()

filetype plugin indent on    " required

syntax enable           " enable syntax processing
set backspace=indent,eol,start  " make backspce work reasonably
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set number              " show line numbers
set cursorline          " highlight current line
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
let mapleader=","       " leader is comma

set laststatus=2

