execute pathogen#infect()

set foldmethod=expr
set foldexpr=GetPotionFold(v:lnum)
set foldminlines=0
set foldopen=mark " what movements open folds

function! s:NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1
    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif
        let current += 1
    endwhile
    return -2
endfunction

function! s:IndentLevel(lnum)
    if &ft == 'chaos'
        if (a:lnum == 1)
            return 0
        else
            return (getline(a:lnum)=~?'\v^::' ? 0 : indent(a:lnum) / &shiftwidth + 1)
        endif
    else
        return indent(a:lnum) / &shiftwidth + (getline(a:lnum)=~?'^\s*}' ? 1 : 0)
    endif
endfunction

function! GetPotionFold(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif
    let this_indent = <SID>IndentLevel(a:lnum)
    let next_indent = <SID>IndentLevel(<SID>NextNonBlankLine(a:lnum))
    let prev_indent = <SID>IndentLevel(<SID>PrevNonBlankLine(a:lnum))
    if next_indent == this_indent
        return this_indent
    elseif next_indent < this_indent
        return this_indent
    elseif next_indent > this_indent
        return '>' . next_indent
    endif
endfunction

function! NeatFoldText()
    let line = getline(v:foldstart)
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
    let foldchar = ' '
    let foldtextstart = strpart(line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 6)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
    "return repeat('  ',v:foldlevel) . foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

hi Folded ctermbg=231 ctermfg=2
hi FoldColumn ctermbg=white ctermfg=darkred

set ruler
"set colorcolumn=80
set ttyfast
set ttyscroll=3
set lazyredraw
set hidden
set nowrap
set autoread
"set nosmartindent                        " TODO: remove this line if things go wrong
set nolisp                               " stops annoying auto-indenting on .scm file
set tabstop=2                            " a tab is four spaces
set expandtab                            "
set backspace=indent,eol,start           " allow backspacing over everything in insert mode
set autoindent                           " always set autoindenting on
set number                               " always show line numbers
set shiftwidth=2                         " number of spaces to use for autoindenting
set shiftround                           " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch                            " set show matching parenthesis
set ignorecase                           " ignore case when searching
set smartcase                            " ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab                             " insert tabs on the start of a line according to shiftwidth, not tabstop
set hlsearch                             " highlight search terms
set incsearch                            " show search matches as you type
set history=1000                         " remember more commands and search history
set undolevels=1000                      " use many muchos levels of undo
set title                                " change the terminal's title
set novisualbell                         " don't flash
set noerrorbells                         " don't beep
set nobackup
set noswapfile
set nocompatible
set viminfo='1000,f1,<500,:100,/100,h  "
set shortmess=atqlFI " no annoying start screen
set linebreak
set nolist  " list disables linebreak
set textwidth=80
set wrapmargin=0
set cryptmethod=blowfish2

" CtrlP stuff
"let g:ctrlp_match_func = {'match' : 'cpsm#CtrlPMatch' }
"let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
let g:ctrlp_by_filename = 0
":map <expr> <space> ":CtrlP ".getcwd()."<cr>"
":set wildignore+=*/tmp/*,*/node_modules/*,*/migrations*,*.min.*,*.so,*.swp,*.zip,*.pyc,*.hi,*.o,*.dyn_hi,*.dyn_o,*.jsexe/*,*/dist/*,*/bin/*,*.js_hi,*.js_o,*.agdai,*/.git/*,*/elm-stuff/*,*/sprites/* " MacOSX/Linux

:noremap j gj
:noremap k gk

:nnoremap <expr> r ':<C-u>!clear<cr>:w!<cr>'.(
    \ &ft=='agda'       ? ':call AgdaCheck()<cr>' :
    \ &ft=='bend'       ? ':!/usr/bin/time bend run-c % -s<cr>' :
    \ &ft=='c'          ? ':!clang % -o %:r -lSDL2<cr>:!time ./%:r<cr>' :
    \ &ft=='cpp'        ? ':!clang++ -std=c++11 -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='cuda'       ? ':!echo "Sending to Higher Order Computer."; rsync % taelin@HOC:/home/taelin/cuda/hvm.cu<CR>:!echo "Compiling..."; ssh taelin@HOC /usr/local/cuda-12.4/bin/nvcc -w -O3 /home/taelin/cuda/hvm.cu -o /home/taelin/cuda/hvm<CR>:!echo "Running..."; ssh taelin@HOC time /home/taelin/cuda/hvm<cr>' :
    \ &ft=='haskell'    ? ':!time runghc --ghc-arg=-freverse-errors %<cr>' :
    \ &ft=='hvm'        ? ':!/usr/bin/time hvm run-c %<cr>' :
    \ &ft=='hvm1'       ? ':!/usr/bin/time -l -h hvm1 run -t 1 -c -f % "(Main)"<cr>' :
    \ &ft=='hvmc'       ? ':!/usr/bin/time hvmc run % -s -m 32G<cr>' :
    \ &ft=='icc'        ? ':!/usr/bin/time icc check %:r<cr>' :
    \ &ft=='idris2'     ? ':!time idris2 % -o %:r<cr>:!time ./build/exec/%:r<cr>' :
    \ &ft=='javascript' ? ':!time node %<cr>' :
    \ &ft=='kind'       ? ':!time kind %<cr>' :
    \ &ft=='kindc'      ? ':!time kindc check %<cr>' :
    \ &ft=='kind2'      ? ':!/usr/bin/time kind2 check ' . substitute(substitute(expand("%"), ".kind2", "", "g"), "/_", "", "g") . '<cr>' :
    \ &ft=='lean'       ? ':!time lean --run %<cr>' :
    \ &ft=='markdown'   ? ':StartPresenting<cr>' :
    \ &ft=='python'     ? ':!time python3 %<cr>' :
    \ &ft=='rust'       ? ':!time RUST_BACKTRACE=1 cargo run<cr>' :
    \ &ft=='sh'         ? ':!time ./%<cr>' :
    \ &ft=='typescript' ? ':!time tsc --noEmit %; tsx %<cr>' :
    \ ':!time cc %<cr>')

:nnoremap <expr> R ':<C-u>!clear<cr>:w!<cr>'.(
    \ &ft=='agda'       ? ':!agda -i src %<cr>' :
    \ &ft=='bend'       ? ':!bend gen-hvm % > %:r.hvm<cr>' :
    \ &ft=='c'          ? ':!clang -O2 % -o %:r -lSDL2<cr>:!time ./%:r<cr>' :
    \ &ft=='cpp'        ? ':!clang++ -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='cuda'       ? ':!rm %:r; nvcc -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='haskell'    ? ':!time ghc -O2 % -o .tmp; time ./.tmp 0; rm %:r.hi %:r.o .tmp<cr>' :
    \ &ft=='hvm'        ? ':!hvm gen-c % > %:r.c; hvm gen-cu % > %:r.cu<cr>' :
    \ &ft=='hvm1'       ? ':!hvm1 compile %; cd %:r1; cargo build --release; /usr/bin/time -l -h ./target/release/%:r run -c true "(Main)"<cr>' :
    \ &ft=='hvmc'       ? ':!/usr/bin/time hvmc compile %; time ./%:r -s<cr>' :
    \ &ft=='icc'        ? ':!/usr/bin/time icc run %:r<cr>' :
    \ &ft=='idris2'     ? ':!idris2 % -o %:r<cr>:!time ./build/exec/%:r<cr>' :
    \ &ft=='javascript' ? ':!npm run build<cr>' :
    \ &ft=='kind2'      ? ':!/usr/bin/time kind2 normal ' . substitute(substitute(expand("%"), ".kind2", "", "g"), "/_", "", "g") . '<cr>' :
    \ &ft=='kindc'      ? ':!time kindc run %<cr>' :
    "\ &ft=='kind2'      ? ':!/usr/bin/time kind2 normal %:r<cr>' :
    \ &ft=='rust'       ? ':!time cargo run --release<cr>' :
    \ &ft=='typescript' ? ':!time tsx %<cr>' :
    \ ':!time cc %<cr>')

:nnoremap <expr> <leader>r ':<C-u>!clear<cr>:w!<cr>'.(
    \ &ft=='hvm' ? ':!echo "Sending to Higher Order Computer."; rsync % taelin@HOC:/home/taelin/cuda/main.hvm<CR>:!echo "Running..."; ssh taelin@HOC time /home/taelin/.cargo/bin/hvm run-cu /home/taelin/cuda/main.hvm<cr>' :
    \ ':!time cc %<cr>')

:nnoremap <expr> <leader>m ':w!<cr>:!clear; cargo install --path .<cr>'

":nnoremap <expr> <leader>m ':!clear<cr>:w!<cr>'.(
    "\ &ft=='rust'       ? ':!cargo install --path .<cr>' :
    "\ &ft=='typescript' ? ':!tsc<cr>' :
    "\ ':!time cc %<cr>')

:nnoremap <expr> <leader>M ':w!<cr>:!clear; cargo install --debug --path .<cr>'
:nnoremap <expr> <leader>w ':w!<cr>:!clear; node /Users/v/vic/dev/Kind/web/build.js<cr>:!osascript ~/vic/dev/refresh_chrome.applescript &<cr>'
:nnoremap <expr> <leader>x ':x!<cr>'
:nnoremap <expr> <leader>q ':q!<cr>'
:nnoremap <leader>b :put!='----------'<cr>:put!=strftime('%Y-%m-%d')<cr>


" --------------------------------------------------------------------------

"" Calls GPT-4 to fill holes in the current file,
"" omitting collapsed folds to save prompt space

function! SaveVisibleLines(dest)
  let l:visibleLines = []
  let lnum = 1
  while lnum <= line('$')
    if foldclosed(lnum) == -1
      call add(l:visibleLines, getline(lnum))
      let lnum += 1
    else
      call add(l:visibleLines, getline(foldclosed(lnum)))
      call add(l:visibleLines, "...")
      call add(l:visibleLines, getline(foldclosedend(lnum)))
      let lnum = foldclosedend(lnum) + 1
    endif
  endwhile
  call writefile(l:visibleLines, a:dest)
endfunction

function! FillHoles(model)
  if expand('%:e') == 'pwd' || expand('%:e') == 'pvt'
    echo "Cannot fill holes in .pwd or .pvt files."
    return
  endif

  if (bufname('%') == '')
      let l:tmpFile = tempname()
      exec "w " . l:tmpFile
  else
      exec 'w'
      let l:tmpFile = expand('%:p') 
  endif
  call SaveVisibleLines('.fill.tmp')
  exec '!NODE_NO_WARNINGS=1 holefill ' . l:tmpFile . ' .fill.tmp ' . a:model
  exec '!rm .fill.tmp'
  exec 'edit!'
endfunction

nnoremap <leader>g :!clear<CR>:call FillHoles('g')<CR>
nnoremap <leader>G :!clear<CR>:call FillHoles('G')<CR>
nnoremap <leader>h :!clear<CR>:call FillHoles('s')<CR>
nnoremap <leader>H :!clear<CR>:call FillHoles('o')<CR>
nnoremap <leader>l :!clear<CR>:call FillHoles('l')<CR>
nnoremap <leader>L :!clear<CR>:call FillHoles('L')<CR>
nnoremap <leader>i :!clear<CR>:call FillHoles('i')<CR>
nnoremap <leader>I :!clear<CR>:call FillHoles('I')<CR>
":nmap z :!clear<CR>:call FillHoles('h')<CR>
"nnoremap <space> :!clear<CR>:call FillHoles('h')<CR>

" Checks an Agda file
" It replaces all question marks ('?') in the current file by ('{!!}'). Then, it
" calls the 'agda-check <file>' system command.
function! AgdaCheck()
  " Save the current file
  exec 'w'

  " Replace all '?' with '{!!}'
  exec '%s/?/{!!}/g'

  " Save the file again
  exec 'w'

  " Run the agda-check command
  exec '!agda-check ' . expand('%:p')

  " Reload the file to show the changes
  exec 'e!'
endfunction

" --------------------------------------------------------------------------

" GPT-3 binding from https://github.com/tom-doerr/vim_codex
":nmap <leader>g :<C-U>exe "CreateCompletion ".v:count1<CR>
":map <leader>g :AI<cr>
let g:vim_ai_chat = {
\  "options": {
\    "model": "gpt-4",
\    "temperature": 0.2,
\  },
\}

" NERDTree stuff
:let NERDTreeIgnore = ['\.idr\~$','\.ibc$','\.min.js$','\.agdai','\.pyc$','\.hi$','\.o$','\.js_o$','\.js_hi$','\.dyn_o$','\.dyn_hi$','\.jsexe','.*dist\/.*','.*bin\/.*']
:let NERDTreeChDirMode = 2
:let NERDTreeWinSize = 16
:let NERDTreeShowHidden=1
:nmap <expr> <enter> v:count1 <= 1 ? "<C-h>C<C-w>p" : "@_<C-W>99h". v:count1 ."Go<C-w>l"

:nmap <leader>n :NERDTree<CR>
au VimEnter * NERDTree
" au VimEnter * set nu "enable to always set nu
au VimEnter * wincmd l

:nmap <expr> <leader>t ":ClearCtrlPCache<cr>:NERDTree<cr>:set nu<cr><C-w>l"

" Can I solve the ESC out of home problem?
:inoremap ☮ <esc>
:vnoremap ☮ <esc>
:cnoremap ☮ <esc>

:set clipboard=unnamed,unnamedplus,autoselect

" PBufferWindows
:map <left> 1<C-w><
:map <right> 1<C-w>>
:map <up> 1<C-w>-
:map <down> 1<C-w>+
:noremap <C-j> <esc><C-w>j
":noremap <C-k> <esc><C-w>k
:noremap <C-h> <esc><C-w>h
:noremap <C-l> <esc><C-w>l
:map! <C-j> <esc><C-w>j
":map! <C-k> <esc><C-w>k
:map! <C-h> <esc><C-w>h
:map! <C-l> <esc><C-w>l

" Change Color when entering Insert Mode
"hi cursorline cterm=none ctermbg=white
au InsertEnter * set cursorline
au InsertLeave * set nocursorline

" vim-ls
" call pathogen#runtime_append_all_bundles()
hi link lsSpaceError NONE
hi link lsReservedError NONE

" Vim can automatically change the current working directory to the directory where the file you are editing lives. 
" set autochdir*/

" space to enter command
" :nnoremap <space> :
:syntax on

" cursor always in middle of screen
:set scrolloff=99999 " vertically keep cursor on the middle of the screen
:set sidescrolloff=0 " only scroll horizontally when out of bounds

:map , <leader>

" join
:nnoremap <leader>j J

" default the statusline to green when entering Vim
hi StatusLine ctermfg=lightblue ctermbg=black
hi StatusLineNC ctermfg=lightgray ctermbg=black
hi VertSplit ctermfg=lightgray ctermbg=black

" NERDComment
:map ! <leader>c<space>

" d/ to unhighlight search matches
:nnoremap d/ :nohl<cr>

" R to search&replace
" :nnoremap R :%s/*/

" macros
:nnoremap q qa<esc>
:nnoremap Q @a

" previous and next location
:nnoremap <C-u> <C-o>
":nnoremap <C-i> <C-i>
":nnoremap <TAB> <C-i>

" quit

" navigates through marks (if exist), if not, moves fast
:nnoremap <S-j> 6gj
:nnoremap <S-k> 6gk
:vnoremap <S-j> 6gj
:vnoremap <S-k> 6gk

" line join (because <S-j> is taken)
:nnoremap <leader>j J

" go to previous location
:nmap <D-h>    <C-o>

" :inoremap <S-space> <tab>
:nmap ( <<
:nmap ) >>
":nmap <tab> >>
":nmap <S-tab> << 
:map U <C-r>
:nmap <C-j> <C-w>j
":nmap <C-k> <C-w>k
:nmap <C-l> <C-w>l
:nmap <C-h> <C-w>h

" begin/end of line
:nnoremap H ^
:nnoremap L $
:vnoremap H ^
:vnoremap L $

" idris ft
"au BufNewFile,BufRead *.ls set filetype=LLivescript
au BufNewFile,BufRead *.cu set filetype=cuda
au BufNewFile,BufRead *.cu set syntax=c
au BufNewFile,BufRead *.purs set filetype=purescript
au BufNewFile,BufRead *.chaos set filetype=chaos
au BufNewFile,BufRead *.chaos set syntax=javascript
au BufNewFile,BufRead *.moon set filetype=moon
au BufNewFile,BufRead *.escoc set filetype=escoc
au BufNewFile,BufRead *.escoc set syntax=javascript
au BufNewFile,BufRead *.itt set filetype=itt
au BufNewFile,BufRead *.sic set filetype=sic
au BufNewFile,BufRead *.ic set filetype=ic
au BufNewFile,BufRead *.moon set syntax=javascript
au BufNewFile,BufRead *.mt set filetype=morte
au BufNewFile,BufRead *.sw set filetype=sway
au BufNewFile,BufRead *.sw set syntax=rust
"au BufNewFile,BufRead *.idr set filetype=idris
au BufNewFile,BufRead *.lean set filetype=lean
au BufNewFile,BufRead *.v set filetype=coq
au BufNewFile,BufRead *.coc set filetype=coc
au BufNewFile,BufRead *.ult set filetype=ultimate
au BufNewFile,BufRead *.lc set filetype=lambda
au BufNewFile,BufRead *.lc set syntax=elm
au BufNewFile,BufRead *.lam set filetype=lambda
au BufNewFile,BufRead *.lam set syntax=elm
au BufNewFile,BufRead *.mel set filetype=caramel
au BufNewFile,BufRead *.mel set syntax=elm
au BufNewFile,BufRead *.dvl set filetype=dvl
au BufNewFile,BufRead *.lis set filetype=lispell
au BufNewFile,BufRead *.lscm set filetype=lispell
au BufNewFile,BufRead *.sol set filetype=solidity
au BufNewFile,BufRead *.eatt set filetype=eatt
au BufNewFile,BufRead *.eatt set syntax=javascript
au BufNewFile,BufRead *.fmc set filetype=formcore
au BufNewFile,BufRead *.fmc set syntax=javascript
au BufNewFile,BufRead *.fm set filetype=formality
au BufNewFile,BufRead *.fm set syntax=javascript
au BufNewFile,BufRead *.fmfm set filetype=fmfm
au BufNewFile,BufRead *.fmfm set syntax=javascript
au BufNewFile,BufRead *.ifm set filetype=informality
au BufNewFile,BufRead *.ifm set syntax=javascript
au BufNewFile,BufRead *.eac set filetype=eac
au BufNewFile,BufRead *.eac set syntax=javascript
au BufNewFile,BufRead *.fmc set filetype=formcore
au BufNewFile,BufRead *.fmc set syntax=javascript
au BufNewFile,BufRead *.kind2 set filetype=kind2
au BufNewFile,BufRead *.kind2 set syntax=javascript
au BufNewFile,BufRead *.kindc set filetype=kindc
au BufNewFile,BufRead *.kindc set syntax=javascript
au BufNewFile,BufRead *.type set filetype=type
au BufNewFile,BufRead *.type set syntax=javascript
au BufNewFile,BufRead *.bend set filetype=bend
au BufNewFile,BufRead *.bend set syntax=python
au BufNewFile,BufRead *.kind set filetype=kind
au BufNewFile,BufRead *.kind set syntax=javascript
au BufNewFile,BufRead *.kindelia set filetype=kindelia
au BufNewFile,BufRead *.kindelia set syntax=javascript
au BufNewFile,BufRead *.kdl set filetype=kindelia
au BufNewFile,BufRead *.kdl set syntax=javascript
au BufNewFile,BufRead *.bolt set filetype=lambolt
au BufNewFile,BufRead *.bolt set syntax=javascript
au BufNewFile,BufRead *.hvm set filetype=hvm
au BufNewFile,BufRead *.hvm set syntax=javascript
au BufNewFile,BufRead *.hvm syntax region Password start=/^\/\/\~/ end=/$/ " HVM hidden comments
au BufNewFile,BufRead *.hvm highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.hvm1 set filetype=hvm1
au BufNewFile,BufRead *.hvm1 set syntax=javascript
au BufNewFile,BufRead *.hvm1 syntax region Password start=/^\/\/\~/ end=/$/ " HVM hidden comments
au BufNewFile,BufRead *.hvm1 highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.hvmc set filetype=hvmc
au BufNewFile,BufRead *.hvmc set syntax=javascript
au BufNewFile,BufRead *.hvml set filetype=hvml
au BufNewFile,BufRead *.hvml set syntax=javascript
au BufNewFile,BufRead *.hvml syntax region Password start=/^\/\/\~/ end=/$/ " hvml hidden comments
au BufNewFile,BufRead *.hvml highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.hvm2 set filetype=hvm2
au BufNewFile,BufRead *.hvm2 set syntax=javascript
au BufNewFile,BufRead *.hvm2 syntax region Password start=/^\/\/\~/ end=/$/ " hvm2 hidden comments
au BufNewFile,BufRead *.hvm2 highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.tl set filetype=taelang
au BufNewFile,BufRead *.tl set syntax=javascript
au BufNewFile,BufRead *.icc set filetype=icc
au BufNewFile,BufRead *.icc set syntax=javascript
au BufNewFile,BufRead *.pwd set syntax=javascript
au BufNewFile,BufRead *.pvt set syntax=javascript

" EVERYTHING MANAGER
au BufNewFile,BufRead *.pvt set filetype=javascript
au BufNewFile,BufRead *.pvt set syntax=javascript
au BufNewFile,BufRead *.pvt syntax region Password start=/^/ end=/$/
au BufNewFile,BufRead *.pvt highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.pvt set colorcolumn=0
au BufNewFile,BufRead *.pvt set noundofile
au BufNewFile,BufRead *.pvt :nmap <leader>g :<C-U>echo "NOT ALLOWED, THIS IS A PVT FILE! ".v:count1<CR>
filetype plugin on

" PASSWORD MANAGER
au BufNewFile,BufRead *.pwd set filetype=javascript
au BufNewFile,BufRead *.pwd set syntax=javascript
au BufNewFile,BufRead *.pwd syntax region Password start=/"{/ end=/}"/
au BufNewFile,BufRead *.pwd highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.pwd set colorcolumn=0
au BufNewFile,BufRead *.pwd set noundofile
au BufNewFile,BufRead *.pwd :nmap <leader>g :<C-U>echo "NOT ALLOWED, THIS IS A PWD FILE! ".v:count1<CR>
au BufNewFile,BufRead *.pwd :nmap <leader>G :<C-U>echo "NOT ALLOWED, THIS IS A PWD FILE! ".v:count1<CR>
filetype plugin on

" Presentation
au BufNewFile,BufRead *.talk set filetype=javascript
au BufNewFile,BufRead *.talk set syntax=javascript
au BufNewFile,BufRead *.talk syntax region Password start=/^/ end=/$/
au BufNewFile,BufRead *.talk highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.talk set colorcolumn=0
filetype plugin on

" Presentation
au BufNewFile,BufRead *.talk set filetype=javascript
au BufNewFile,BufRead *.talk set syntax=javascript
au BufNewFile,BufRead *.talk syntax region Password start=/^/ end=/$/
au BufNewFile,BufRead *.talk highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.talk set colorcolumn=0
filetype plugin on


" Scheme
au BufNewFile,BufRead *.scm set nolisp
 

"filetype on
"filetype plugin indent on

" C++11 syntax
"au BufNewFile,BufRead *.cpp set syntax=cpp11

" More fold stuff
:nnoremap + zr:echo 'foldlevel: ' . &foldlevel<cr>
:nnoremap - zm:echo 'foldlevel: ' . &foldlevel<cr>
:nnoremap <leader>f zO
:nnoremap <leader>d zo
:nnoremap <leader>s zc
:nnoremap <leader>a zC

" relative lines on/off
"nnoremap <silent><leader>n :set relativenumber!<cr>

:set comments+=:--

set undofile
set undodir=~/.vim/undo
set foldlevel=12
au Syntax * normal zR

set formatoptions=cql
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction








" call current line as a terminal command, paste below
map <leader>, 0y$:r!<C-r>"<CR>

" CtrlP auto cache clearing.
" ----------------------------------------------------------------------------
function! SetupCtrlP()
  if exists("g:loaded_ctrlp") && g:loaded_ctrlp
    augroup CtrlPExtension
      autocmd!
      autocmd FocusGained  * CtrlPClearCache
      autocmd BufWritePost * CtrlPClearCache
    augroup END
  endif
endfunction

if has("autocmd")
  autocmd VimEnter * :call SetupCtrlP()
endif

:noremap m %

set runtimepath^=~/.vim/bundle/ag


" https://gist.github.com/bignimbus/1da46a18416da4119778
" Set the title of the Terminal to the currently open file
function! SetTerminalTitle()
    let titleString = expand('%:t')
    if len(titleString) > 0
        let &titlestring = expand('%:t')
        " this is the format iTerm2 expects when setting the window title
        let args = "\033];".&titlestring."\007"
        let cmd = 'silent !echo -e "'.args.'"'
        execute cmd
        redraw!
    endif
endfunction
autocmd BufEnter * call SetTerminalTitle()

let g:markdown_fenced_languages = ['javascript', 'typescript', 'python', 'haskell', 'c']

" ###################################

" https://vi.stackexchange.com/questions/2232/how-can-i-use-vim-as-a-hex-editor
" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.wasm let &bin=1
  au BufReadPost *.wasm if &bin | %!xxd
  au BufReadPost *.wasm set ft=xxd | endif
  au BufWritePre *.wasm if &bin | %!xxd -r
  au BufWritePre *.wasm endif
  au BufWritePost *.wasm if &bin | %!xxd
  au BufWritePost *.wasm set nomod | endif
augroup END

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

let maplocalleader = "\\"

" markdown indenting
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2

" clear the console whenever we perform a ! command
" so, for example, when we do: ":!ls<CR>"
" it will clear the screen before showing the files
" :nnoremap ! :!clear && 

" that doesn't work. why?
" :nnoremap ! :!clear && 

" Map space to open a terminal
:nnoremap <enter> :term<CR>

" Map <leader><space> to open a terminal and enter the 'csh' command
:nnoremap <leader><enter> :term<CR>csh<CR>

" Map <C-z> on the terminal window to quit it
:tnoremap <C-z> <C-\><C-n>:q!<CR>

" Map <leader>F to open a terminal and enter the 'csh s <file_name>' command
:nnoremap <leader>F :execute 'term csh s ' . expand('%:t')<CR>

" Refactors the file using AI
function! RefactorFile()
  let l:current_file = expand('%:p')
  call inputsave()
  let l:user_text = input('Enter refactor request: ')
  call inputrestore()
  
  " Save the file before refactoring
  write

  if expand('%:e') == 'kind2'
    let l:cmd = 'kindcoder "' . l:current_file . '" "' . l:user_text . '" s'
  else
    let l:cmd = 'refactor "' . l:current_file . '" "' . l:user_text . '" s'
  endif
  
  " Add --check flag if user_text starts with '-' or is empty
  if l:user_text =~ '^-' || empty(l:user_text)
    let l:cmd .= ' --check'
  endif
  
  execute '!clear && ' . l:cmd
  edit!
endfunction

nnoremap <space> :call RefactorFile()<CR>
