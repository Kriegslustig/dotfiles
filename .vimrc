" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

execute pathogen#infect()

source ~/.vim/dragvisuals.vim

let g:vim_markdown_folding_disabled=1

command! -nargs=* Wrap set wrap linebreak nolist

" Set to auto read when a file is changed from the outside
set autoread

set number
set relativenumber

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

let g:ctrlp_map = '<leader>l'
let g:ctrlp_cmd = 'CtrlP'

" Fast saving
nmap <leader>w :w!<cr>
nmap <leader>q :w<cr>
inoremap jk <ESC>

" Close a buffer with ,bd
map <leader>bd :Bclose<cr>

map <leader>n :bn<cr>
map <leader>p :bp<cr>
nnoremap <C-j> 10gj
nnoremap <C-k> 10gk

noremap <Space> :

nnoremap <esc> :noh<return><esc>

" Moving whole blocks and lines around using dragvisuals.vim
map <expr> <Left> DVB_Drag('Left')
map <expr> <Right> DVB_Drag('Right')
map <expr> <Up> DVB_Drag('Up')
map <expr> <Down> DVB_Drag('Down')

" Bells
set novisualbell

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <leader>r :redo<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
" set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*/node_modules/*,*/elm-stuff/*

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

au BufNewFile,BufRead *.tag setlocal ft=html

colorscheme desert

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

highlight LineNr ctermfg=white
" set cursorline
highlight CursorLine cterm=NONE ctermbg=235

highlight SpellBad ctermbg=88
highlight Search ctermbg=240
highlight Search ctermbg=242
highlight SpellLocal ctermbg=NONE ctermfg=248

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
set expandtab

" Linebreak on 500 characters
set lbr

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Set Display some characters if there are trailing spaces or tabs
set listchars=tab:~~,trail:-,nbsp:_
set list
set sbr=…

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

map <leader>u :call Fsucks()<cr>
fu! Fsucks ()
  w!
  execute("!~/Software/nodejs/fsucks/index.js put ".bufname(''))
endfunction

