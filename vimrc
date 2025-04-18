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
    \ &ft=='bend'       ? ':!/usr/bin/time bend run-rs % -s<cr>' :
    "\ &ft=='c'          ? ':!clang % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='c'          ? ':call RunCFile(0)<cr>' :
    \ &ft=='cuda'       ? ':!echo "Sending to Higher Order Computer."; rsync % taelin@HOC:/home/taelin/cuda/hvm.cu<CR>:!echo "Compiling..."; ssh taelin@HOC /usr/local/cuda-12.4/bin/nvcc -w -O3 /home/taelin/cuda/hvm.cu -o /home/taelin/cuda/hvm<CR>:!echo "Running..."; ssh taelin@HOC time /home/taelin/cuda/hvm<cr>' :
    "\ &ft=='haskell'    ? ':!time runghc --ghc-arg=-freverse-errors %<cr>' :
    \ &ft=='haskell'    ? ':call RunHaskellFile()<cr>' :
    \ &ft=='absal'      ? ':!/usr/bin/time absal %<cr>' :
    "\ &ft=='hvm3'       ? ':!/usr/bin/time hvm3 run % -C -s<cr>' :
    \ &ft=='ic'         ? ':!/usr/bin/time ic run %<cr>' :
    \ &ft=='hvmn'       ? ':!/usr/bin/time hvmn run %<cr>' :
    \ &ft=='hvm'        ? ':!/usr/bin/time cabal run -v0 hvm --project-dir=/Users/v/vic/dev/HVM -- run % -C -s<cr>' :
    \ &ft=='hvms'       ? ':!/usr/bin/time hvms run % -s<cr>' :
    \ &ft=='hvm1'       ? ':!/usr/bin/time -l -h hvm1 run -t 1 -c -f % "(Main)"<cr>' :
    \ &ft=='hvmc'       ? ':!/usr/bin/time hvmc run % -s -m 32G<cr>' :
    \ &ft=='supgen'     ? ':!/usr/bin/time /Users/v/vic/dev/superposed_enumerator/supgen.sh gen % -c -C -Q<cr>' :
    \ &ft=='icc'        ? ':!/usr/bin/time icc check %:r<cr>' :
    \ &ft=='idris2'     ? ':!time idris2 % -o %:r<cr>:!time ./build/exec/%:r<cr>' :
    \ &ft=='javascript' ? ':!time node --no-deprecation %<cr>' :
    \ &ft=='kind'       ? ':!time kind check %<cr>' :
    \ &ft=='kindc'      ? ':!time kindc check %<cr>' :
    \ &ft=='kind2'      ? ':!/usr/bin/time kind2 check ' . substitute(substitute(expand("%"), ".kind2", "", "g"), "/_", "", "g") . '<cr>' :
    \ &ft=='kind2hs'    ? ':!time kind2hs check %<cr>' :
    \ &ft=='tt'         ? ':!time /Users/v/vic/dev/program_search/tt check %<cr>' :
    \ &ft=='lean'       ? ':!time lean --run %<cr>' :
    \ &ft=='markdown'   ? ':StartPresenting<cr>' :
    \ &ft=='python'     ? ':!time python3 %<cr>' :
    \ &ft=='rust'       ? ':!time RUST_BACKTRACE=1 cargo run<cr>' :
    \ &ft=='sh'         ? ':!time ./%<cr>' :
    \ &ft=='typescript' ? ':call RunTypeScriptFile()<cr>' :
    "\ &ft=='typescript' ? ':!time bun run %<cr>' :
    \ ':!time cc %<cr>')

:nnoremap <expr> R ':<C-u>!clear<cr>:w!<cr>'.(
    \ &ft=='agda'       ? ':!agda-compile %<cr>:!time ./%:r<cr>' :
    \ &ft=='bend'       ? ':!/usr/bin/time bend run-c % -s<cr>' :
    "\ &ft=='bend'       ? ':!bend gen-hvm % > %:r.hvm<cr>' :
    \ &ft=='c'          ? ':call RunCFile(1)<cr>' :
    \ &ft=='cpp'        ? ':!clang++ -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='cuda'       ? ':!rm %:r; nvcc -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='haskell'    ? ':!time ghc -O2 % -o .tmp; time ./.tmp 0; rm %:r.hi %:r.o .tmp<cr>' :
    \ &ft=='ic'         ? ':!/usr/bin/time ic run % -C<cr>' :
    \ &ft=='hvmn'       ? ':!/usr/bin/time hvmn run % -c<cr>' :
    "\ &ft=='hvm'        ? ':!hvm gen-c % > %:r.c; hvm gen-cu % > %:r.cu<cr>' :
    \ &ft=='hvm'        ? ':!/usr/bin/time hvm run % -c -C1 -s<cr>' :
    \ &ft=='hvm3'       ? ':!/usr/bin/time hvm3 run % -c -C1 -s<cr>' :
    \ &ft=='hvms'       ? ':!/usr/bin/time hvms run % -c -s<cr>' :
    \ &ft=='hvm1'       ? ':!hvm1 compile %; cd %:r1; cargo build --release; /usr/bin/time -l -h ./target/release/%:r run -c true "(Main)"<cr>' :
    \ &ft=='hvmc'       ? ':!/usr/bin/time hvmc compile %; time ./%:r -s<cr>' :
    \ &ft=='supgen'     ? ':!/usr/bin/time /Users/v/vic/dev/superposed_enumerator/supgen.sh gen % -c -C1 -Q -s<cr>' :
    \ &ft=='icc'        ? ':!/usr/bin/time icc run %:r<cr>' :
    \ &ft=='idris2'     ? ':!idris2 % -o %:r<cr>:!time ./build/exec/%:r<cr>' :
    \ &ft=='javascript' ? ':!time bun %<cr>' :
    \ &ft=='kind'       ? ':!time kind run %<cr>' :
    \ &ft=='kind2'      ? ':!/usr/bin/time kind2 normal ' . substitute(substitute(expand("%"), ".kind2", "", "g"), "/_", "", "g") . '<cr>' :
    \ &ft=='kindc'      ? ':!time kindc run %<cr>' :
    \ &ft=='kind2hs'    ? ':!time kind2hs run %<cr>' :
    \ &ft=='tt'         ? ':!time /Users/v/vic/dev/program_search/tt run %<cr>' :
    "\ &ft=='kind2'      ? ':!/usr/bin/time kind2 normal %:r<cr>' :
    \ &ft=='rust'       ? ':!time cargo run --release<cr>' :
    "\ &ft=='typescript' ? ':!time tsx %<cr>' :
    \ &ft=='typescript' ? ':!time bun run %<cr>' :
    \ ':!time cc %<cr>')

:nnoremap <expr> <leader>r ':<C-u>!clear<cr>:w!<cr>'.(
    \ &ft=='hvm'    ? ':!/usr/bin/time hvm run % -s<cr>' :
    "\ &ft=='hvm'    ? ':!echo "Sending to Higher Order Computer."; rsync % taelin@HOC:/home/taelin/cuda/main.hvm<CR>:!echo "Running..."; ssh taelin@HOC time /home/taelin/.cargo/bin/hvm run-cu /home/taelin/cuda/main.hvm -s<cr>' :
    \ &ft=='ic'     ? ':!/usr/bin/time ic bench %<cr>' :
    \ &ft=='hvmn'   ? ':!/usr/bin/time hvmn bench %<cr>' :
    \ &ft=='supgen' ? ':!/usr/bin/time /Users/v/vic/dev/superposed_enumerator/supgen.sh chk % -c -C1 -Q<cr>' :
    \ &ft=='bend'   ? ':!echo "Sending to Higher Order Computer."; bend gen-hvm % > %:r.hvm  2>/dev/null; rsync %:r.hvm taelin@HOC:/home/taelin/main.hvm<CR>:!echo "Running..."; ssh taelin@HOC time /home/taelin/.cargo/bin/hvm run-cu /home/taelin/main.hvm<cr>' :
    \ &ft=='kind'   ? ':!kind to-js %:r \| prettier --parser babel > %:r.js<cr>' :
    \ ':!time cc %<cr>')

:nnoremap <expr> <leader>m ':w!<cr>:!clear; ' . (
    \ &ft=='rust'       ? 'time cargo install --path .' :
    \ &ft=='haskell'    ? 'time cabal install --global --overwrite-policy=always' :
    \ &ft=='typescript' ? 'time npm run build' :
    \ &ft=='javascript' ? 'time npm run build' :
    \ 'echo "No build command defined for this filetype"'
    \ ) . '<cr>'

" TODO: create a RunCFile function that will be triggered when I'm in a C file.
" if there is a Makefile locally, we'll make, and then run the binary on bin/
" otherwise, we do the same as we do now
" it must work for both r and R (i.e., it must receive a flag to enalbe -O3)
" NOTE: the bin name will ALWAYS be 'main'. i.e., you must run bin/main
" implement it below:

function! RunCFile(optimize)
  let l:src = expand('%')
  let l:bin = expand('%:r')
  if filereadable('Makefile') || filereadable('makefile')
    execute '!rm -rf obj/ && clear && make clean && make && time ./bin/main'
  else
    if a:optimize
      execute '!clear && clang -O3 ' . l:src . ' -o ' . l:bin . ' && time ./' . l:bin
    else
      execute '!clear && clang ' . l:src . ' -o ' . l:bin . ' && time ./' . l:bin
    endif
  endif
endfunction

function! RunTypeScriptFile()
  let l:tsconfig_exists = filereadable('tsconfig.json')
  if l:tsconfig_exists
    execute '!clear && tsc --target esnext --noEmit --skipLibCheck && time bun run %'
  else
    execute '!clear && tsc --target esnext --noEmit --skipLibCheck % && time bun run %'
  endif
endfunction

function! RunHaskellFile()
  "let l:cabal_exists = filereadable('cabal.project')
  "this is wrong. it should check if there is any .cabal file locally.
  let l:cabal_exists = !empty(glob('*.cabal'))
  if l:cabal_exists
    "execute '!clear && cabal run'
    "-- TODO: if HVML is in this dir's name, run 'cabal run hvml'
    "-- TODO: if HVMS is in this dir's name, run 'cabal run hvms'
    "-- otherwise, run just 'cabal run'
    let l:dir_name = expand('%:p:h')
    if l:dir_name =~ 'HVM'
      execute '!clear && time cabal run hvm -- +RTS -N -RTS'
    elseif l:dir_name =~ 'HVMS'
      execute '!clear && time cabal run hvms -- +RTS -N -RTS'
    else
      execute '!clear && time cabal run'
    endif
  else
    execute '!clear && ghc -O2 % -o .tmp_hs && time ./.tmp_hs && rm .tmp_hs'
  endif
endfunction

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
  exec '!time NODE_NO_WARNINGS=1 holefill ' . l:tmpFile . ' .fill.tmp ' . a:model
  exec '!rm .fill.tmp'
  exec 'edit!'
endfunction

nnoremap <leader>o :!clear<CR>:call FillHoles('o')<CR>
nnoremap <leader>O :!clear<CR>:call FillHoles('O')<CR>
nnoremap <leader>g :!clear<CR>:call FillHoles('g')<CR>
nnoremap <leader>G :!clear<CR>:call FillHoles('G')<CR>
nnoremap <leader>l :!clear<CR>:call FillHoles('l')<CR>
nnoremap <leader>L :!clear<CR>:call FillHoles('L')<CR>
nnoremap <leader>i :!clear<CR>:call FillHoles('i')<CR>
nnoremap <leader>I :!clear<CR>:call FillHoles('I')<CR>
nnoremap <leader>x :!clear<CR>:call FillHoles('x')<CR>
nnoremap <leader>X :!clear<CR>:call FillHoles('X')<CR>
"<leader>d is taken
nnoremap <leader>k :!clear<CR>:call FillHoles('d')<CR>
nnoremap <leader>K :!clear<CR>:call FillHoles('D')<CR>
"<leader>c is taken
nnoremap <leader>h :!clear<CR>:call FillHoles('c')<CR>
nnoremap <leader>H :!clear<CR>:call FillHoles('C')<CR>

":nmap z :!clear<CR>:call FillHoles('h')<CR>
"nnoremap <space> :!clear<CR>:call FillHoles('h')<CR>

" Checks an Agda file
" It replaces all question marks ('?') in the current file by ('{!!}'). Then, it
" calls the 'agda-cli check <file>' system command.
function! AgdaCheck()
  " Save the current file
  exec 'w'

  " Replace all '?' with '{!!}'
  exec '%s/?/{!!}/g'

  " Save the file again
  exec 'w'

  " Run the agda-cli command
  exec '!agda-cli check ' . expand('%:p') . '; echo ""; time agda-cli run ' . expand('%:p')

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
:let NERDTreeWinSize = 24
:let NERDTreeShowHidden=1
:nmap <expr> <enter> v:count1 <= 1 ? "<C-h>C<C-w>p" : "@_<C-W>99h". v:count1 ."Go<C-w>l"

:nmap <leader>n :NERDTree<CR>
au VimEnter * NERDTree
" au VimEnter * set nu "enable to always set nu
au VimEnter * wincmd l

" NERDTREE
" --------

:nmap <expr> <leader>t ":NERDTreeRefreshRoot<cr>"

" --------

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
au BufNewFile,BufRead *.moon set syntax=javascript
au BufNewFile,BufRead *.mt set filetype=morte
au BufNewFile,BufRead *.sw set filetype=sway
au BufNewFile,BufRead *.sw set syntax=rust
"au BufNewFile,BufRead *.idr set filetype=idris
au BufNewFile,BufRead *.lean set filetype=agda
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
au BufNewFile,BufRead *.kind set filetype=kind
au BufNewFile,BufRead *.kind set syntax=javascript
au BufNewFile,BufRead *.kind2 set filetype=kind2
au BufNewFile,BufRead *.kind2 set syntax=javascript
au BufNewFile,BufRead *.kindc set filetype=kindc
au BufNewFile,BufRead *.kindc set syntax=javascript
au BufNewFile,BufRead *.kind2hs set filetype=kind2hs
au BufNewFile,BufRead *.kind2hs set syntax=javascript
au BufNewFile,BufRead *.kindelia set filetype=kindelia
au BufNewFile,BufRead *.kindelia set syntax=javascript
au BufNewFile,BufRead *.tt set filetype=tt
au BufNewFile,BufRead *.tt set syntax=javascript
au BufNewFile,BufRead *.type set filetype=type
au BufNewFile,BufRead *.type set syntax=javascript
au BufNewFile,BufRead *.bend set filetype=bend
au BufNewFile,BufRead *.bend set syntax=python
au BufNewFile,BufRead *.kdl set filetype=kindelia
au BufNewFile,BufRead *.kdl set syntax=javascript
au BufNewFile,BufRead *.bolt set filetype=lambolt
au BufNewFile,BufRead *.bolt set syntax=javascript
au BufNewFile,BufRead *.ic set filetype=ic
au BufNewFile,BufRead *.ic set syntax=javascript
au BufNewFile,BufRead *.ic syntax region Password start=/^\/\/\~/ end=/$/ " ic hidden comments
au BufNewFile,BufRead *.ic highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.hvmn set filetype=hvmn
au BufNewFile,BufRead *.hvmn set syntax=javascript
au BufNewFile,BufRead *.hvmn syntax region Password start=/^\/\/\~/ end=/$/ " hvmn hidden comments
au BufNewFile,BufRead *.hvmn highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
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
au BufNewFile,BufRead *.hvm3 set filetype=hvm3
au BufNewFile,BufRead *.hvm3 set syntax=javascript
au BufNewFile,BufRead *.hvm3 syntax region Password start=/^\/\/\~/ end=/$/ " hvm3 hidden comments
au BufNewFile,BufRead *.hvm3 highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.hvms set filetype=hvms
au BufNewFile,BufRead *.hvms set syntax=javascript
au BufNewFile,BufRead *.hvms syntax region Password start=/^\/\/\~/ end=/$/ " hvms hidden comments
au BufNewFile,BufRead *.hvms highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.hvm2 set filetype=hvm2
au BufNewFile,BufRead *.hvm2 set syntax=javascript
au BufNewFile,BufRead *.hvm2 syntax region Password start=/^\/\/\~/ end=/$/ " hvm2 hidden comments
au BufNewFile,BufRead *.hvm2 highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.sg set filetype=supgen
au BufNewFile,BufRead *.sg set syntax=javascript
au BufNewFile,BufRead *.sg syntax region Password start=/^\/\/\~/ end=/$/ " supgen hidden comments
au BufNewFile,BufRead *.sg highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.absal set filetype=absal
au BufNewFile,BufRead *.absal set syntax=javascript
au BufNewFile,BufRead *.absal syntax region Password start=/^\/\/\~/ end=/$/ " absal hidden comments
au BufNewFile,BufRead *.absal highlight Password ctermfg=red guifg=red ctermbg=red guifg=red
au BufNewFile,BufRead *.tl set filetype=taelang
au BufNewFile,BufRead *.tl set syntax=javascript
au BufNewFile,BufRead *.icc set filetype=icc
au BufNewFile,BufRead *.icc set syntax=javascript
au BufNewFile,BufRead *.pwd set syntax=javascript
au BufNewFile,BufRead *.pvt set syntax=javascript
au BufNewFile,BufRead *.h set filetype=c

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

"set formatoptions=ql
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
":nnoremap <enter> :term<CR>

" Map <leader><space> to open a terminal
:nnoremap <leader><enter> :term<CR>

" Map <C-z> on the terminal window to quit it
:tnoremap <C-z> <C-\><C-n>:q!<CR>

" Map <leader>F to open a terminal and enter the 'csh s <file_name>' command
:nnoremap <leader>F :execute 'term csh s ' . expand('%:t')<CR>

"" Refactors the file using AI

"function! RefactorFile()
  "let l:current_file = expand('%:p')
  "call inputsave()
  "let l:user_text = input('λ: ')
  "call inputrestore()
  
  "" Save the file before refactoring
  "write

  "" Command to call the Koder refactorer
  "let l:cmd = 'koder "' . l:current_file . '" "' . l:user_text . '"'
  
  "" Add --check flag if user_text starts with '-' or is empty
  "if l:user_text =~ '^-' || empty(l:user_text)
    "let l:cmd .= ' c --check'
  "endif
  
  "execute '!clear && ' . l:cmd
  "edit!
"endfunction

""nnoremap <space> :call RefactorFile()<CR>

" TODO: let's refactor teh functionality above to use the new refactoring tool, called 'aoe'
" when the user types space, it must call 'aoe <user_message_here>'
" no need to check if the text starts with - or is empty
" all else the same

"function! RefactorFile()
  "let l:current_file = expand('%:p')
  "call inputsave()
  "let l:user_text = input('λ: ')
  "call inputrestore()
  
  "" Save the file before refactoring
  "write

  "" Command to call the aoe refactorer
  "let l:cmd = 'aoe "' . l:user_text . '"'
  
  "execute '!clear && ' . l:cmd
  "edit!
"endfunction

"nnoremap <space> :call RefactorFile()<CR>

" TODO: edit the code above so that, if the user text ends in '?', we will call 'ask' instead of 'aoe'

function! RefactorFile()
  let l:current_file = expand('%:p')
  call inputsave()
  let l:user_text = input('λ: ')
  call inputrestore()
  
  " Save the file before refactoring
  write

  " Command to call the aoe refactorer or ask
  let l:cmd = l:user_text =~ '?$' ? 'ask "' . l:user_text . '"' : 'aoe "' . l:user_text . '"'
  
  execute '!clear && ' . l:cmd
  edit!
endfunction

nnoremap <space> :call RefactorFile()<CR>




"nnoremap <leader>T :!clear<CR>:w!<cr>:!agda2ts %<CR>
"nnoremap <leader>K :!clear<CR>:w!<cr>:!agda2kind %<CR>


" FormatOptions:
" 1. t: Auto-wrap text using textwidth
" 2. c: Auto-wrap comments using textwidth
" 3. r: Automatically insert comment leader after <Enter> in Insert mode
" 4. o: Automatically insert comment leader after 'o' or 'O' in Normal mode
" 5. q: Allow formatting of comments with "gq"
" 6. w: Trailing white space indicates a paragraph continues in the next line
" 7. a: Automatic formatting of paragraphs
" 8. n: Recognize numbered lists
" 9. 2: Use the indent of the second line of a paragraph for the rest of the paragraph
" 10. v: Only break a line at a blank that you have entered during the current insert command
" 11. b: Like 'v', but only auto-wrap if you enter a blank at or before the wrap margin
" 12. l: Long lines are not broken in insert mode
" 13. m: Also break at a multi-byte character above 255
" 14. M: When joining lines, don't insert a space before or after a multi-byte character
" 15. B: When joining lines, don't insert a space between two multi-byte characters
" 16. j: Where it makes sense, remove a comment leader when joining lines

" Set formatoptions globally to only 'cl'
set formatoptions=ql

" Ensure these settings apply to all filetypes
augroup FormatOptions
    autocmd!
    autocmd FileType * setlocal formatoptions=ql
augroup END

autocmd BufRead,BufNewFile *.agda setfiletype agda
