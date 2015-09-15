"
" My vimrc
" Russell Bryant <russell@russellbryant.net>
"
" Other setup:
"
" install: powerline, vim-plugin-powerline
"
" mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
" cd ~/.vim/bundle
" git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline
" git clone git://github.com/tpope/vim-sensible.git
" git clone https://github.com/airblade/vim-gitgutter
" git clone https://github.com/python-rope/ropevim.git
" cd ropevim && sudo pip install .
" http://jedi.jedidjah.ch/en/latest/
"
" Other plugins to consider:
"
" https://github.com/kien/ctrlp.vim
" https://github.com/alfredodeza/pytest.vim
" https://github.com/scrooloose/nerdcommenter
" https://github.com/alfredodeza/coveragepy.vim
" https://github.com/rking/ag.vim
"

execute pathogen#infect()
let g:jedi#use_splits_not_buffers = "right"

" powerline, can be used instead of vim-airline
"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup

set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

" Enable vim (not old school vi) defaults
" replaced by vim-sensible
"set nocompatible

" Include the ruler that tells the cursor position
" handled by powerline
"set ruler

" Show vim commands as they are typed
set showcmd

" Search behavior
set incsearch
set hlsearch
set ignorecase
set smartcase

" Make colors friendly to terminals with a dark background 
" (like white on black)
set background=dark
"colorscheme solarized

" Enable spell check
"set spell

" Always keep 8 lines of context at the top or bottom when scrolling
set scrolloff=8

" Enable support for using a mouse when available
"set mouse=a

" Show matching brackets
set showmatch

" Automatically save before commands like :next and :make
set autowrite

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" Syntax Highlighting stuff.
let python_highlight_all=1
syntax on

" Common formatting settings
set ts=4 sw=4
set textwidth=80
set expandtab
set autoindent

au FileType gitcommit set tw=70
au BufRead,BufNewFile */COMMIT_EDITMSG set tw=70

au BufRead,BufNewFile *.c set noexpandtab ts=8 sw=8
au BufRead,BufNewFile *.h set noexpandtab ts=8 sw=8

au BufRead,BufNewFile */ovs/*.c set expandtab ts=4 sw=4
au BufRead,BufNewFile */ovs/*.h set expandtab ts=4 sw=4
au BufRead,BufNewFile */ovs/datapath/*.c set noexpandtab ts=8 sw=8
au BufRead,BufNewFile */ovs/datapath/*.h set noexpandtab ts=8 sw=8

" Python specific formatting settings
"  - http://svn.python.org/projects/python/trunk/Misc/Vim/vimrc
au BufRead,BufNewFile *.py,*.pyw set sw=4 ts=4 expandtab textwidth=79
au BufNewFile *.py,*.pyw set fileformat=unix

" Highlight any leading tabs in python code
highlight BadWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/

au BufRead,BufNewFile *.py,*.pyw map <C-]> :call RopeGotoDefinition() <CR>

au BufRead,BufNewFile *.spec,*.spec.in set noexpandtab

" Show trailing whitespace and spaces before tabs
"hi link localWhitespaceError Error
"au Syntax * syn match localWhitespaceError /\(\zs\%#\|\s\)\+$/ display
"au Syntax * syn match localWhitespaceError / \+\ze\t/ display
let c_space_errors=1

" Map 'f' to showing what function you're in, but only for C and C++ source
" and headers
fun! ShowFuncName()
        let lnum = line(".")
        let col = col(".")
        echohl ModeMsg
        echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
        echohl None
        call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
au BufRead,BufNewFile *.c,*.cc,*.cpp,*.cxx,*.h map f :call ShowFuncName() <CR>

" Tell vim to remember certain things when we exit
"  '10 : marks will be remembered for up to 10 previously edited files
"  "100 : will save up to 100 lines for each register
"  :20 : up to 20 lines of command-line history will be remembered
"  % : saves and restores the buffer list
"  n... : where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" when we reload, tell vim to restore the cursor to the saved position
augroup JumpCursorOnEdit
 au!
 autocmd BufReadPost *
 \ if expand("<afile>:p:h") !=? $TEMP |
 \ if line("'\"") > 1 && line("'\"") <= line("$") |
 \ let JumpCursorOnEdit_foo = line("'\"") |
 \ let b:doopenfold = 1 |
 \ if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
 \ let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
 \ let b:doopenfold = 2 |
 \ endif |
 \ exe JumpCursorOnEdit_foo |
 \ endif |
 \ endif
 " Need to postpone using "zv" until after reading the modelines.
 autocmd BufWinEnter *
 \ if exists("b:doopenfold") |
 \ exe "normal zv" |
 \ if(b:doopenfold > 1) |
 \ exe "+".1 |
 \ endif |
 \ unlet b:doopenfold |
 \ endif
augroup END

