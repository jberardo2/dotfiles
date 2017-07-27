set nocompatible

"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'jlanzarotta/bufexplorer'
Plugin 'godlygeek/csapprox'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-markdown'
Plugin 'henrik/vim-indexed-search'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-ragtag'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'mbbill/undotree'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'majutsushi/tagbar'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'Valloric/MatchTagAlways'
Plugin 'EinfachToll/DidYouMean'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'vim-utils/vim-ruby-fold'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'chrisbra/csv.vim'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'airblade/vim-gitgutter'
Plugin 'godlygeek/tabular'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'mzlogin/vim-markdown-toc'
Plugin 'aklt/plantuml-syntax'
Plugin 'AndrewRadev/sideways.vim'
Plugin 'kassio/neoterm'
Plugin 'janko-m/vim-test'
Plugin 'flazz/vim-colorschemes'
call vundle#end()

"show incomplete cmds down the bottom
set showcmd
"show current mode down the bottom
set showmode
"show line numbers
set number

"display tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

"find the next match as we type the search
set incsearch
"hilight searches by default
set hlsearch

"default indent settings
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

"folding settings
"fold based on indent
set foldmethod=indent
"deepest fold is 3 levels
set foldnestmax=3
"dont fold by default
set nofoldenable

"set wildmode=list:longest   "make cmdline tab completion similar to bash
"enable ctrl-n and ctrl-p to scroll thru matches
set wildmenu
"stuff to ignore when tab completing
set wildignore=*.o,*.obj,*~

" easy switch between buffers (don't need to save between tabs)
set hidden

"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on

colorscheme github

iabbrev teh the
set ignorecase
set smartcase

" Set the command window height to 2 lines, to avoid many cases of having to
" " "press <Enter> to continue"
set cmdheight=2

"statusline setup
set statusline =%#identifier#
set statusline+=[%f]
"tail of the filename
set statusline+=%*

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

"help file flag
set statusline+=%h
"filetype
set statusline+=%y

"read only flag
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*

"modified flag
set statusline+=%#warningmsg#
set statusline+=%m
set statusline+=%*

set statusline+=%{fugitive#statusline()}

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*
"
set statusline+=%{StatuslineTrailingSpaceWarning()}

"set statusline+=%{StatuslineLongLineWarning()}

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

"left/right separator
set statusline+=%=
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
"cursor column
set statusline+=%c,
"cursor line/total lines
set statusline+=%l/%L

"percent through file
set statusline+=\ %P
set laststatus=2

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
           let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)
    let line_lens = map(getline(1,'$'), 'len(substitute(v:val, "\\t", spaces, "g"))')
    return filter(line_lens, 'v:val > threshold')
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
   let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

"add new words (via zg) here
setlocal spellfile+=~/.vim/spell/en.utf-8.add

"syntastic settings
let syntastic_stl_format = '[Syntax: %E{line:%fe }%W{#W:%w}%B{ }%E{#E:%e}]'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"nerdtree settings
let g:NERDTreeMouseMode = 2
let g:NERDTreeWinSize = 40
let g:NERDTreeMinimalUI=1

"tagbar settings
let g:tagbar_sort = 0

"explorer mappings
nnoremap <leader>bb :BufExplorer<cr>
nnoremap <leader>bs :BufExplorerHorizontalSplit<cr>
nnoremap <leader>bv :BufExplorerVerticalSplit<cr>
nnoremap <leader>nt :NERDTreeToggle<cr>
nnoremap <leader>nf :NERDTreeFind<cr>
nnoremap <leader>nn :e .<cr>
nnoremap <leader>nd :e %:h<cr>
nnoremap <leader>] :TagbarToggle<cr>
nnoremap <c-f> :CtrlP<cr>
nnoremap <c-b> :CtrlPBuffer<cr>

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"tmux-vim-navigator setup
"let g:tmux_navigator_no_mappings = 1
"nnoremap <silent> <m-h> :TmuxNavigateLeft<cr>
"nnoremap <silent> <m-j> :TmuxNavigateDown<cr>
"nnoremap <silent> <m-k> :TmuxNavigateUp<cr>
"nnoremap <silent> <m-l> :TmuxNavigateRight<cr>
"nnoremap <silent> <m-w> :TmuxNavigatePrevious<cr>

"spell check when writing commit logs
"autocmd filetype svn,*commit*,*.txt setlocal spell

"nnoremap <leader><space> :nohlsearch<CR>

" Allow us to use Ctrl-s and Ctrl-q as keybinds
silent !stty -ixon    
" Restore default behaviour when leaving Vim.
autocmd VimLeave * silent !stty ixon

" " Ctrl+S for save
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>
" " Ctrl-q for save and quit
nmap <c-q> :wqa<CR>
imap <c-q> <Esc>:wqa<CR>
"
nmap q :qa<CR> " q -> quit
"
map <leader>nu :set number <cr>
map <leader>nuo :set nonumber <cr>
" " Toggle NERDTree
map <F2> :NERDTreeToggle<CR>
map <F3> :set mouse=a <CR>
map <F4> :set mouse= <CR>
map <F5> :set number <CR>
map <F6> :set nonumber <CR>
map <F7> :set relativenumber <CR>
map <F8> :set norelativenumber <CR>
" " tagbar shortcut
nmap <F9> :TagbarToggle<CR>
nmap F :NERDTreeFind <CR>


" automatically close a tab if the only remaining window is NerdTree
"autocmd BufEnter * if (winnr(“$”) == 1 && exists(“b:NERDTreeType”) && b:NERDTreeType == “primary”) | q | endif

"let NERDTreeShowHidden=1  "Show hidden files in NerdTree
"let NERDTreeQuitOnOpen = 1 " automatically close NerdTree when you open a file
autocmd VimEnter * NERDTree
"autopen NERDTreea
autocmd VimEnter * wincmd p

let NERDTreeAutoDeleteBuffer = 1 " Automatically delete the buffer of the file you just deleted with NerdTree
let NERDTreeMinimalUI = 1 " disable that old “Press ? for help”
let NERDTreeDirArrows = 1 " make it looks nicer


" focus cursor in new document
"
" " TAB and Shift-TAB in normal mode cycle buffers
nmap <Tab> :bn<CR>
nmap <S-Tab> :bp<CR>

" " highlight current line
set cursorline
"
" " status bar
"set laststatus=2
" set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]

"autocmd VimLeave * SessionSaveAs vim_auto_saved_session " leaving commands

" Set up scrolling winding one line up and down  
nnoremap <S-Up> <C-Y>
nnoremap <S-Down> <C-E>

" navigation
nnoremap <C-left> <C-w>h
nnoremap <C-down> <C-w>j
nnoremap <C-up> <C-w>k
nnoremap <C-right> <C-w>l

augroup configgroup
    autocmd!
        autocmd VimEnter * highlight clear SignColumn
        autocmd BufWrite call StripWhiteSpace()
        autocmd BufEnter *.cls setlocal filetype=java
        autocmd BufEnter *.sh setlocal tabstop=2
        autocmd BufEnter *.sh setlocal shiftwidth=2
        autocmd BufEnter *.sh setlocal softtabstop=2
augroup END

function StripWhiteSpace()
   %s/\s\+$//e
endfunction

" GIT
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

nmap \e :NERDTreeToggle<CR>


" You don't know what you're missing if you don't use this.
nmap <C-e> :e#<CR>

" Move between open buffers.
map <C-n> :bnext<CR>
map <C-p> :bprev<CR>

" Why not use the space or return keys to toggle folds?
nnoremap <space> za
"nnoremap <CR>    za
vnoremap <space> zf

set colorcolumn=85
