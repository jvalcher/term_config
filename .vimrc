
""""""""""""""""""
" Local settings "
""""""""""""""""""

let MYVIMRC=expand("%HOME/.vimrc")
let MYVIMINFO=expand("%HOME/.viminfo")

" set <localleader>     ( <space> )
nnoremap <Space> <Nop>
let maplocalleader = " "

" set <leader>            ( , )
noremap , <Nop>
let mapleader=","

let &fillchars ..= ',eob: '

:set runtimepath=/home/jvalcher/.vim,$VIMRUNTIME



"""""""""""
" Plugins "
"""""""""""

" vim-plug plugins
call plug#begin('~/.vim/plugged')
    Plug 'joshdick/onedark.vim'                 " Color scheme: One Dark
    Plug 'dracula/vim', { 'as': 'dracula' }     " Color scheme: Dracula
    Plug 'morhetz/gruvbox'
    """""
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'scrooloose/nerdtree'                  " File manager
    Plug 'ryanoasis/vim-devicons'               " add NERDTree devicons
    Plug 'bryanmylee/vim-colorscheme-icons'     " colorize NERDTree devicons
    Plug 'sheerun/vim-polyglot'                 " Collection of Vim language packs 
    Plug 'nvie/vim-flake8'                      " Python Flake8 linter
    Plug 'junegunn/goyo.vim'                    " distraction-free screen
    Plug 'preservim/tagbar'                     " ctags menu
call plug#end()
filetype plugin on

" Coc.nvim
  " List current extensions
    " :CocList extensions
  " coc extensions list
    " https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions 
"
" dropdown menu matching character(s) color
hi CocSearch ctermfg=2
"
" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"
" Select menu item  (tab)
inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<TAB>"
inoremap <silent><expr> <cr> "\<c-g>u\<CR>"


" Open/close NERDTree (<localleader> + n)
function! OpenNERDTree()
    if g:NERDTree.IsOpen()
        execute "NERDTreeToggle"
        execute "NERDTreeRefreshRoot"
    else
        execute "NERDTreeFind " . expand('%')
    endif
endfunction
nnoremap <localleader>n :call OpenNERDTree() <CR>

" NERDTree
let g:NERDTreeChDirMode=1  " make pwd the parent directory
let NERDTreeQuitOnOpen=1   " close menu after opening file
let NERDTreeShowHidden=0   " show hidden files in NERDTree

" disable line wrapping in quickfix window (vim-bookmarks)
augroup quickfix
    autocmd!
    autocmd FileType qf setlocal nowrap
augroup END

" vim-flake8        (F7)
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=0
nnoremap <F7> :call flake8#Flake8() <CR>

" quit goyo without using :qa or :q twice
function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction
function! s:goyo_leave()
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction
autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()

" tagbar
nnoremap <localleader>t :TagbarOpenAutoClose <CR>



"""""""""""""""""
" Misc settings "
"""""""""""""""""

set number
set confirm
set mouse=a
set noswapfile
set clipboard=unnamedplus
set encoding=utf-8
set fileencodings=utf-8
set autoindent
set shiftround
set tabstop=4
set shiftwidth=4
set softtabstop=4 
set expandtab
set showmatch
set nohlsearch
set wrap
set nowrapscan
set nolist
set textwidth=0
set incsearch
set ignorecase
set smartcase
set autoread
set linebreak
set nopaste
set ruler
set wildmenu
set noerrorbells
set backspace=indent,eol,start
set ttymouse=xterm2
set laststatus=2
set nobackup
set nowritebackup
set updatetime=10
set timeoutlen=100
set ttimeoutlen=100

" map 'jk' to Esc
inoremap jk <Esc>
vnoremap jk <Esc>

" jump to last position when opening file
if has("autocmd")
    augroup LastPosition
        autocmd!
        autocmd BufReadPost * normal! '"
    augroup END
endif

" toggle autosave     (<localleader> w)
function! ToggleAutoSave()
    if !exists('#AutoSave#InsertLeave')
        augroup AutoSave
            autocmd!
            autocmd InsertLeave,TextChanged,FocusLost * silent! write
            autocmd FocusGained,BufEnter * :redraw!
        augroup END
        echo "AutoSave on"
    else
        augroup AutoSave
            autocmd!
        augroup END
        echo "AutoSave off"
    endif
endfunction
augroup AutoSave
    autocmd!
    autocmd InsertLeave,TextChanged,FocusLost * silent! write
    autocmd FocusGained,BufEnter * :redraw!
augroup END
nnoremap <localleader>w :call ToggleAutoSave() <CR>

" change without yanking
nnoremap c "_c

" toggle paste/nopaste		(<localleader> p)
function! TogglePaste()
    if &paste == 0
		set paste
		echo "paste"
	else
		set nopaste
		echo "nopaste"
	endif
endfunction
noremap <localleader>p :call TogglePaste() <CR>

" remap recorder        (<localleader> r)
nnoremap <localleader>r  q

" disable auto-commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" rename tmux pane to filename
if exists('$TMUX')
    augroup TmuxRename
        autocmd!
        autocmd BufEnter * call system("tmux select-pane -T '" . expand("%:t") . "'")
        "autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
    augroup END
endif

" reselect visual block for multiple indents
vnoremap < <gv
vnoremap > >gv

" Preserve copied data when replacing with visual mode
xnoremap <expr> p '"_d"'.v:register.'p'

" unmap K (exits vim to man page for term under cursor)
nnoremap K <Nop>

" enable mouse wheel scrolling
map <ScrollWheelDown> gj
map <ScrollWheelUp> gk

" open .vimrc in vertical, horizontal pane   (<localleader> v,h)
nnoremap <localleader>v :vsplit $MYVIMRC <cr> :normal! '" <cr>
nnoremap <localleader>b :split $MYVIMRC <cr> :normal! '" <cr>

" source .vimrc,.viminfo file	(<localleader> s)
nnoremap <localleader>s :source $MYVIMRC <cr> :echo "Sourced vimrc" <cr>
nnoremap <localleader>i :wviminfo <cr> :echo "Wrote viminfo" <cr>

" change cursor from block to line in insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" set persistent undo, target directory
set undofile
if !isdirectory(expand("$HOME/.vim/undodir"))
    call mkdir(expand("$HOME/.vim/undodir"), "p")
endif
set undodir=$HOME/.vim/undodir

" copy word under cursor  (<localleader> w)
set iskeyword+=-
function! Copy_word()
    normal! viwy
    echo "\"" . @+ . "\"  copied"
endfunction
nnoremap <localleader>y :call Copy_word() <CR>

" increase history limit
set history=1000



"""""""""""
" Styling "
"""""""""""

" set background
set background=dark

" set colorscheme
colorscheme gruvbox  
hi MatchParen ctermbg=none ctermfg=yellow
hi LineNr ctermfg=23

" fix gruvbox comment issues:
  " comment out `hi clear` in gruvbox.vim to fix status line issue
" wait to apply Comment styling
autocmd VimEnter * hi Comment term=bold ctermfg=8

" status line formatting
func! STL()

  " save state ... scrollbar
  let stl = '%{((exists("+bomb") && &bomb)?"B":"")}%M %=%'
  let barWidth = 20
  if line('$') > 1
    let progress = (line('.')-1) * (barWidth-1) / (line('$')-1)
  else
    let progress = barWidth/2
  endif

  " line + vcol + %
  let pad = strlen(line('$'))-strlen(line('.')) + 3 - strlen(virtcol('.')) + 3 - strlen(line('.')*100/line('$'))
  let bar = repeat(' ',pad).' %1*%'.barWidth.'.'.barWidth.'('
        \.repeat('-',progress )
        \.'%2*|%1*'
        \.repeat('-',barWidth - progress - 1).'%0*%)%< '
  return stl.bar
endfun

" status line coloring
hi Normal cterm=bold ctermbg=none
hi StatusLine cterm=bold ctermbg=none ctermfg=172
hi User1 ctermfg=24
hi User2 ctermfg=172

" render status line
autocmd VimEnter * set stl=%!STL()




""""""""""""""
" Navigation "
""""""""""""""

" move cursor up/down (including wrapped lines)
nnoremap j gj
nnoremap k gk

" scroll up/down  (ctrl + m/n)
nnoremap <C-m> kzz<Esc>
nnoremap <C-n> jzz<Esc>

" map t to T for jumping back to character
nnoremap t T
vnoremap t T

" navigate buffers  (<leader> a/s)
nnoremap <leader>a :bprevious<CR>
nnoremap <leader>s :bnext<CR>

" open terminal     (<leader> t)
nnoremap <leader>t :shell <CR>

" toggle centering cursor vertically   (<localleader> c)
function Center_cursor()
    let pos = getpos(".")
    normal! zz
    call setpos(".", pos)
endfunction
let g:cursor_centered=1
augroup CenterCursor
    autocmd!
    autocmd CursorMoved,CursorMovedI * call Center_cursor()
augroup END
function Toggle_center_cursor()
    if g:cursor_centered==0
        augroup CenterCursor
            autocmd!
            autocmd CursorMoved,CursorMovedI * call Center_cursor()
        augroup END
        let g:cursor_centered=1
        echo "Cursor centered"
    else
        augroup CenterCursor
            autocmd!
        augroup END
        let g:cursor_centered=0
        echo "Cursor free"
    endif
endfunction
nnoremap <localleader>c :call Toggle_center_cursor() <CR>

" open pane     (<localleader> o,e)
nnoremap <localleader>o :split <CR>
nnoremap <localleader>e :vsplit <CR>

" exit pane
nnoremap <localleader>q :wq <CR>

" adjust pane size   (<localleader> up/down/right/left)
nnoremap <localleader><up>      2<C-W>+
nnoremap <localleader><down>    2<C-W>-
nnoremap <localleader><right>   2<C-W>>
nnoremap <localleader><left>    2<C-W><    

" navigate panes    (<localleader> h,j,k,l)
nnoremap <localleader>h <C-W><C-H>
nnoremap <localleader>j <C-W><C-J>
nnoremap <localleader>k <C-W><C-K>
nnoremap <localleader>l <C-W><C-L>



""""""""""""""""""""""""""
" File-specific settings "
""""""""""""""""""""""""""

" insert superscripts    (^n)
func! SetSuperscripts()
  iabbrev ^1 ¹
  iabbrev ^2 ²
  iabbrev ^3 ³
  iabbrev ^4 ⁴
  iabbrev ^5 ⁵
  iabbrev ^6 ⁶
  iabbrev ^7 ⁷
  iabbrev ^8 ⁸
  iabbrev ^9 ⁹
  iabbrev ^0 ⁰
  iabbrev ^n ⁿ
  iabbrev ^N ᴺ
endfunc

augroup FILETYPES
  autocmd!

  " set superscripts
  autocmd Filetype markdown call SetSuperscripts()

  " 2-space tabs
  autocmd BufRead,BufNewFile *.vimrc,*.htm,*.html,*.yml,*.yaml,*.json,*.js,*.jsx,*.md,*.spec,*.css,*.scss setlocal tabstop=2 shiftwidth=2 softtabstop=2
 
  " em dash
  autocmd FileType markdown iabbrev <buffer> -- —

  " view binary data 
  "nnoremap <localleader>b :%!xxd<CR>

  " turn off newline indentation in markdown
  let g:vim_markdown_new_list_item_indent = 0

  " turn on spellchecker inside...
  autocmd BufRead,BufNewFile *.md,*.txt setlocal spell

  " create GDB breakpoint string from current line  (Ctrl+x  --> 'break src/file.c:123')
  function! CopyBreakpoint()
      let l:filename = expand('%:t')
      let l:linenumber = line('.')
      let l:breakpoint = 'break src/' . l:filename . ':' . l:linenumber
      let @+ = l:breakpoint
      echo l:breakpoint
  endfunction
  nnoremap <leader>b :call CopyBreakpoint()<CR>

augroup END



"""""""""""""
" Skeletons "
"""""""""""""

" Bash      ( :Bash )
command Bash 0r ~/.vim/skeletons/bash
" C         ( :C )
command C 0r ~/.vim/skeletons/c
" C debug   ( :Cd )
command Cd 0r ~/.vim/skeletons/c_debug
" C++       ( :Cpp )
command Cpp 0r ~/.vim/skeletons/cpp
" HTML      ( :Html )
command Html 0r ~/.vim/skeletons/html
" CSS       ( :Css )
command Scss 0r ~/.vim/skeletons/scss
" C Makefile  ( :Makec )
command Makec 0r ~/.vim/skeletons/makec
" Python bash  ( :Makec )
command Pybash 0r ~/.vim/skeletons/pybash
" Leetcode  ( :Leet )
command Leet 0r ~/.vim/skeletons/leet
" Ncurses C  ( :Leet )
command Nc 0r ~/.vim/skeletons/ncurses_c
" Week meal planning template
command Meals 0r ~/.vim/skeletons/meals



"""""""""""""
" Compilers "
"""""""""""""

" Cal in Tmux pane to right

" C		(F5)
let g:c_compile = 'gcc -g -Wall -Wextra'
function! CompileC()
    execute "silent !tmux send-keys -t right " . shellescape(g:c_compile) . "' '% Enter"
    call system('tmux send-keys -t right "./a.out" Enter')
    execute "silent redraw!"
    echo "$ " . g:c_compile . " " . expand('%')
endfunction
nnoremap <F5> :call CompileC() <CR>

" C++   (F6)
 let g:cpp_compile = 'g++ -g -Wall -Wextra'
"let g:cpp_compile = 'g++ -g -Wall -Wextra -o %:r'
function! CompileCPP()
    execute "silent !tmux send-keys -t right " . shellescape(g:cpp_compile) . "' '% Enter"
    call system('tmux send-keys -t right "./a.out" Enter')
    execute "silent redraw!"
    echo "$ " . g:cpp_compile . " " . expand('%')
endfunction
nnoremap <F6> :call CompileCPP() <CR>
