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
set shortmess=atql " no annoying start screen
set linebreak
set nolist  " list disables linebreak
set textwidth=80
set wrapmargin=0
set cryptmethod=blowfish2

" CtrlP stuff
"let g:ctrlp_match_func = {'match' : 'cpsm#CtrlPMatch' }
"let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
let g:ctrlp_by_filename = 0
:map <expr> <space> ":CtrlP ".getcwd()."<cr>"
":set wildignore+=*/tmp/*,*/node_modules/*,*/migrations*,*.min.*,*.so,*.swp,*.zip,*.pyc,*.hi,*.o,*.dyn_hi,*.dyn_o,*.jsexe/*,*/dist/*,*/bin/*,*.js_hi,*.js_o,*.agdai,*/.git/*,*/elm-stuff/*,*/sprites/* " MacOSX/Linux

:noremap j gj
:noremap k gk

:nnoremap <expr> r ':<C-u>!clear<cr>:w!<cr>'.(
    \ &ft=='caramel'    ? ':!time mel main<cr>' :
    \ &ft=='ocaml'      ? ':!ocamlc -o %:r %<cr>:!./%:r<cr>' :
    \ &ft=='factor'     ? ':!~/factor/factor %<cr>' :
    \ &ft=='python'     ? ':!time python3 %<cr>' :
    \ &ft=='coc'        ? ':!time (coc type %:r; coc norm %:r)<cr>' :
    \ &ft=='scheme'     ? ':!time scheme --script %<cr>' :
    \ &ft=='elm'        ? '<esc>:!clear<cr>:w!<cr>:!elm % -r elm-runtime.js<cr>:!osascript ~/.vim/refresh.applescript &<cr>' :
    \ &ft=='racket'     ? ':!racket %<cr>' :
    \ &ft=='haskell'    ? ':!time runghc --ghc-arg=-freverse-errors %<cr>' :
    \ &ft=='sway'       ? ':!time forc test --release --offline<cr>' :
    \ &ft=='rust'       ? ':!time RUST_BACKTRACE=1 cargo lrun<cr>' :
    \ &ft=='go'         ? ':!time go run %<cr>' :
    \ &ft=='purescript' ? ':!pulp run <cr>' :
    \ &ft=='dvl'        ? ':!dvl run %<cr>' :
    \ &ft=='ultimate'   ? ':!time ult %<cr>' :
    \ &ft=='lambda'     ? ':!time absal %<cr>' :
    \ &ft=='javascript' ? ':!time node %<cr>' :
    \ &ft=='typescript' ? ':!time deno --unstable run --allow-all %<cr>' :
    \ &ft=='moon'       ? ':!time moon run %:r<cr>' :
    \ &ft=='escoc'      ? ':!time escoc %:r<cr>' :
    \ &ft=='eatt'       ? ':!time eatt -itneTNRx %:r<cr>' :
    \ &ft=='eac'        ? ':!time eac %:r<cr>' :
    \ &ft=='fmfm'       ? ':!time fmjs %<cr>' :
    \ &ft=='formality'  ? ':!time fmjs %<cr>' :
    \ &ft=='formcore'   ? ':!time fmc %<cr>' :
    \ &ft=='kind'       ? ':!time kind %<cr>' :
    \ &ft=='kind2'      ? ':!time kind2 check %<cr>' :
    \ &ft=='type'       ? ':!time kind2 derive %<cr>' :
    \ &ft=='kindelia'   ? ':!time kindelia test %<cr>' :
    \ &ft=='lambolt'    ? ':!time hvm % ts<cr>' :
    "\ &ft=='hvm'        ? ':!/usr/bin/time -l -h hvm run -t 1 -c -f % "(Main '.v:count1.')"<cr>' :
    \ &ft=='hvm'        ? ':!/usr/bin/time -l -h hvm run -t 1 -c -f % "(Main)"<cr>' :
    \ &ft=='sic'        ? ':!time sic -s %<cr>' :
    \ &ft=='ic'        ? ':!time ic %<cr>' :
    \ &ft=='itt'       ? ':!time itt %<cr>' :
    \ &ft=='morte'      ? ':!time echo $(cat %) \| morte<cr>' :
    \ &ft=='swift'      ? ':!time swift %<cr>' :
    \ &ft=='solidity'   ? ':!run_solidity %<cr>' :
    \ &ft=='idris2'     ? ':!time idris2 % -o %:r<cr>:!time ./build/exec/%:r<cr>' :
    \ &ft=='lean'       ? ':!time lean %<cr>' :
    \ &ft=='coq'        ? ':!time coqc %<cr>' :
    \ &ft=='c'          ? ':!clang % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='cuda'       ? ':!echo "Sending to Windows..."; rsync % windows:~/cuda<CR>:!echo "Compiling..."; ssh windows /usr/local/cuda/bin/nvcc -arch=sm_70 -O3 /home/v/cuda/% -o /home/v/cuda/%:r<CR>:!echo "Running..."; ssh windows time /home/v/cuda/%:r<cr>' :
    \ &ft=='cpp'        ? ':!clang++ -std=c++11 -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='agda'       ? ':!time agda -i src %<cr>' :
    \ &ft=='ls'         ? ':!lsc -c %<cr>:!node %:r.js<cr>' :
    \ &ft=='sh'         ? ':!time ./%<cr>' :
    \ &ft=='lispell'    ? ':!node ~/Viclib/lispedia/bin/lis.js reduce %:r<cr>' :
    \ ':!time cc %<cr>')

:nnoremap <expr> R ':<C-u>!clear<cr>:w!<cr>'.(
    \ expand('%:p')=='/Users/v/mist/main.js' ? ':!electron . --rpc ~/Library/Ethereum/testnet/geth.ipc<cr>' :
    \ expand('%:t')=='test.js' ? ':!mocha<cr>' :
    \ &ft=='caramel'    ? ':!time mel main<cr>' :
    \ &ft=='ocaml'      ? ':!ocamlc -o %:r %<cr>:!./%:r<cr>' :
    \ &ft=='factor'     ? ':!~/factor/factor %<cr>' :
    \ &ft=='python'     ? ':!time python %<cr>' :
    \ &ft=='coc'        ? ':!time (coc type %:r; coc norm %:r)<cr>' :
    \ &ft=='scheme'     ? ':!csc %<cr>:!time ./%:r<cr>' :
    \ &ft=='elm'        ? '<esc>:!clear<cr>:w!<cr>:!elm % -r elm-runtime.js<cr>:!osascript ~/.vim/refresh.applescript &<cr>' :
    \ &ft=='racket'     ? ':!racket %<cr>' :
    "\ &ft=='haskell'    ? ':!stack run<cr>' :
    \ &ft=='haskell'    ? ':!time ghc -O2 % -o .tmp; time ./.tmp 0; rm %:r.hi %:r.o .tmp<cr>' :
    \ &ft=='rust'       ? ':!time cargo lrun --release<cr>' :
    \ &ft=='go'         ? ':!time go run %<cr>' :
    \ &ft=='purescript' ? ':!pulp run <cr>' :
    \ &ft=='dvl'        ? ':!dvl run %<cr>' :
    \ &ft=='lambda'     ? ':!time absal -s %<cr>' :
    \ &ft=='javascript' ? ':!npm run build<cr>' :
    \ &ft=='typescript' ? ':!time deno --unstable run --reload --allow-all %<cr>' :
    "\ &ft=='typescript' ? ':!npm run build<cr>' :
    \ &ft=='html'       ? ':!npm run build<cr>' :
    \ &ft=='eatt'       ? ':!time eatt %:r<cr>' :
    \ &ft=='fmfm'       ? ':!time fmjs %:r --run<cr>' :
    \ &ft=='formality'  ? ':!time fmjs %:r --run<cr>' :
    \ &ft=='kind'       ? ':!time kind ' . substitute(expand("%:r"),"/",".","g") . ' --norm<cr>' :
    \ &ft=='kind2'      ? ':!time kind2 eval %<cr>' :
    \ &ft=='kindelia'   ? ':!time kindelia serialize %<cr>' :
    \ &ft=='lambolt'    ? ':!time lam % c<cr>' :
    "\ &ft=='hvm'        ? ':!hvm compile %; cd %:r; cargo build --release; /usr/bin/time -l -h ./target/release/%:r run -c true "(Main '.v:count1.')"<cr>' :
    \ &ft=='hvm'        ? ':!hvm compile %; cd %:r; cargo build --release; /usr/bin/time -l -h ./target/release/%:r run -c true "(Main)"<cr>' :
    "\ &ft=='formality'  ? ':!time fmio %:r<cr>' :
    \ &ft=='eac'        ? ':!time eac %:r<cr>' :
    \ &ft=='formcore'   ? ':!time fmio %:r<cr>' :
    \ &ft=='moon'       ? ':!time moon run %:r<cr>' :
    \ &ft=='sic'        ? ':!time sic -s -B %<cr>' :
    \ &ft=='ic'         ? ':!time ic %<cr>' :
    \ &ft=='morte'      ? ':!time echo $(cat %) \| morte<cr>' :
    \ &ft=='swift'      ? ':!time swift %<cr>' :
    \ &ft=='solidity'   ? ':!truffle deploy<cr>' :
    \ &ft=='idris2'     ? ':!idris2 % -o %:r<cr>:!time ./build/exec/%:r<cr>' :
    \ &ft=='c'          ? ':!clang -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='cuda'       ? ':!rm %:r; nvcc -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='cpp'        ? ':!clang++ -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='agda'       ? ':!agda -i src %<cr>' :
    \ &ft=='ls'         ? ':!lsc -c %<cr>:!node %:r.js<cr>' :
    \ &ft=='lispell'    ? ':!node ~/Viclib/lispedia/bin/lis.js reduce %:r<cr>' :
    \ ':!time cc %<cr>')

:nnoremap <expr> <leader>r ':!clear<cr>:w!<cr>'.(
    \ expand('%:p')=='/Users/v/mist/main.js' ? ':!electron . --rpc ~/Library/Ethereum/testnet/geth.ipc<cr>' :
    \ expand('%:t')=='test.js' ? ':!mocha<cr>' :
    \ &ft=='caramel'    ? ':!time mel main<cr>' :
    \ &ft=='ocaml'      ? ':!ocamlc -o %:r %<cr>:!./%:r<cr>' :
    \ &ft=='factor'     ? ':!~/factor/factor %<cr>' :
    \ &ft=='python'     ? ':!time python %<cr>' :
    \ &ft=='coc'        ? ':!time (coc type %:r; coc norm %:r)<cr>' :
    \ &ft=='scheme'     ? ':!csc %<cr>:!time ./%:r<cr>' :
    \ &ft=='elm'        ? '<esc>:!clear<cr>:w!<cr>:!elm % -r elm-runtime.js<cr>:!osascript ~/.vim/refresh.applescript &<cr>' :
    \ &ft=='racket'     ? ':!racket %<cr>' :
    \ &ft=='haskell'    ? ':!stack run<cr>' :
    \ &ft=='rust'       ? ':!time cargo +nightly lrun --release<cr>' :
    \ &ft=='go'         ? ':!time go run %<cr>' :
    \ &ft=='purescript' ? ':!pulp run <cr>' :
    \ &ft=='dvl'        ? ':!dvl run %<cr>' :
    \ &ft=='lambda'     ? ':!time absal -s %<cr>' :
    \ &ft=='javascript' ? ':!npm run build<cr>' :
    \ &ft=='typescript' ? ':!npm run build<cr>' :
    \ &ft=='html'       ? ':!npm run build<cr>' :
    \ &ft=='eatt'       ? ':!time eatt %:r<cr>' :
    \ &ft=='formality'  ? ':!time fm %<cr>' :
    \ &ft=='formcore'   ? ':!time fmcjs %:r<cr>' :
    \ &ft=='hvm'        ? ':!cargo install --path .<cr>' :
    \ &ft=='kind'       ? ':!node /Users/v/vic/dev/Kind/web/build.js %:r<cr>' :
    \ &ft=='kind2'      ? ':!time kind2 run %<cr>' :
    \ &ft=='eac'        ? ':!time eac %:r<cr>' :
    \ &ft=='moon'       ? ':!time moon run %:r<cr>' :
    \ &ft=='sic'        ? ':!time sic -s -B %<cr>' :
    \ &ft=='ic'         ? ':!time ic %<cr>' :
    \ &ft=='morte'      ? ':!time echo $(cat %) \| morte<cr>' :
    \ &ft=='swift'      ? ':!time swift %<cr>' :
    \ &ft=='solidity'   ? ':!truffle deploy<cr>' :
    \ &ft=='idris2'     ? ':!idris2 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='c'          ? ':!clang -O3 -Wall % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='cuda'       ? ':!rm %:r; nvcc -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='cpp'        ? ':!clang++ -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='agda'       ? ':!agda -i src %<cr>' :
    \ &ft=='ls'         ? ':!lsc -c %<cr>:!node %:r.js<cr>' :
    \ &ft=='lispell'    ? ':!node ~/Viclib/lispedia/bin/lis.js reduce %:r<cr>' :
    \ ':!time cc %<cr>')

:nnoremap <expr> <leader>R ':!clear<cr>:w!<cr>'.(
    \ expand('%:p')=='/Users/v/mist/main.js' ? ':!electron . --rpc ~/Library/Ethereum/testnet/geth.ipc<cr>' :
    \ expand('%:t')=='test.js' ? ':!mocha<cr>' :
    \ &ft=='caramel'    ? ':!time mel main<cr>' :
    \ &ft=='ocaml'      ? ':!ocamlc -o %:r %<cr>:!./%:r<cr>' :
    \ &ft=='factor'     ? ':!~/factor/factor %<cr>' :
    \ &ft=='python'     ? ':!time python %<cr>' :
    \ &ft=='coc'        ? ':!time (coc type %:r; coc norm %:r)<cr>' :
    \ &ft=='scheme'     ? ':!csc %<cr>:!time ./%:r<cr>' :
    \ &ft=='elm'        ? '<esc>:!clear<cr>:w!<cr>:!elm % -r elm-runtime.js<cr>:!osascript ~/.vim/refresh.applescript &<cr>' :
    \ &ft=='racket'     ? ':!racket %<cr>' :
    \ &ft=='haskell'    ? ':!stack run<cr>' :
    \ &ft=='rust'       ? ':!time cargo +nightly run --release<cr>' :
    \ &ft=='go'         ? ':!time go run %<cr>' :
    \ &ft=='purescript' ? ':!pulp run <cr>' :
    \ &ft=='dvl'        ? ':!dvl run %<cr>' :
    \ &ft=='lambda'     ? ':!time absal -s %<cr>' :
    \ &ft=='javascript' ? ':!npm run build<cr>' :
    \ &ft=='typescript' ? ':!npm run build<cr>' :
    \ &ft=='html'       ? ':!npm run build<cr>' :
    \ &ft=='eatt'       ? ':!time eatt %:r<cr>' :
    \ &ft=='formality'  ? ':!time fmio %:r<cr>' :
    \ &ft=='formcore'   ? ':!time fmcrun main<cr>' :
    \ &ft=='kind'       ? ':!node /Users/v/vic/dev/Kind/web/build.js %:r<cr>' :
    \ &ft=='eac'        ? ':!time eac %:r<cr>' :
    \ &ft=='moon'       ? ':!time moon run %:r<cr>' :
    \ &ft=='sic'        ? ':!time sic -s -B %<cr>' :
    \ &ft=='ic'         ? ':!time ic %<cr>' :
    \ &ft=='morte'      ? ':!time echo $(cat %) \| morte<cr>' :
    \ &ft=='swift'      ? ':!time swift %<cr>' :
    \ &ft=='solidity'   ? ':!truffle deploy<cr>' :
    \ &ft=='idris2'     ? ':!idris2 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='c'          ? ':!clang -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='cuda'       ? ':!rm %:r; nvcc -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='cpp'        ? ':!clang++ -O3 % -o %:r<cr>:!time ./%:r<cr>' :
    \ &ft=='agda'       ? ':!agda -i src %<cr>' :
    \ &ft=='ls'         ? ':!lsc -c %<cr>:!node %:r.js<cr>' :
    \ &ft=='lispell'    ? ':!node ~/Viclib/lispedia/bin/lis.js reduce %:r<cr>' :
    \ ':!time cc %<cr>')

:nnoremap <expr> <leader>p ':!clear<cr>:w!<cr>'.(
    \ &ft=='kind2'      ? ':!time kindai %<cr>' :
    \ ':!time cc %<cr>')



:nnoremap <expr> <leader>m ':w!<cr>:!clear; time fixit %<cr>'
:nnoremap <expr> <leader>M ':w!<cr>:!clear; time fixit % 4<cr>'
":nnoremap <expr> <leader>G ':w!<cr>:!clear; time chatgpt % 4<cr>'

":nnoremap <expr> <leader>m ':w!<cr>:!clear; cargo install --path .<cr>'
":nnoremap <expr> <leader>M ':w!<cr>:!clear; cargo install --debug --path .<cr>'
":nnoremap <expr> <leader>M ':w!<cr>:!clear; ./bootstrap.sh<cr>'
":nnoremap <expr> <leader>w ':w!<cr>:!clear; npm run build<cr>:!osascript ~/dev/me/refresh_chrome.applescript &<cr>'
:nnoremap <expr> <leader>w ':w!<cr>:!clear; node /Users/v/vic/dev/Kind/web/build.js<cr>:!osascript ~/vic/dev/refresh_chrome.applescript &<cr>'
:nnoremap <expr> <leader>x ':x!<cr>'
:nnoremap <expr> <leader>q ':q!<cr>'
:nnoremap <leader>b :put!='----------'<cr>:put!=strftime('%Y-%m-%d')<cr>
":map <leader>q :xa!<cr>


":nmap <leader>g :<C-U>exe "CreateCompletion ".v:count1<CR>


" --------------------------------------------------------------------------

" Calls GPT-4 to fill holes in the current file,
" omitting collapsed folds to save prompt space

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

function! FillHoles()
  " If buffer is not named, then save content to a uniquely named temporary file.
  if (bufname('%') == '')
      let l:tmpFile = tempname()
      " Write current buffer to the temporary file
      exec "w " . l:tmpFile
  else
      exec 'w'
      let l:tmpFile = expand('%:p') 
  endif

  " Save visible lines of current file to '.fill.tmp'
  call SaveVisibleLines('.fill.tmp')

  " Executes 'holefill' on the source file, and '.fill.tmp'
  exec '!holefill ' . l:tmpFile . ' .fill.tmp'

  " Delete temporary file
  exec '!rm .fill.tmp'

  " Reload the file
  exec 'edit!'
endfunction

" Set key mapping to the new function
nnoremap <leader>g :!clear<CR>:call FillHoles()<CR>

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
au BufNewFile,BufRead *.type set filetype=type
au BufNewFile,BufRead *.type set syntax=javascript
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








" purescript
":map <leader>mt :PSCIDEtype<CR>
":map <leader>mi :PSCIDEimportIdentifier<CR>
":map <leader>mat :PSCIDEaddTypeAnnotation<CR>
":map <leader>mai :PSCIDEaddImportQualifications<CR>
":map <leader>mri :PSCIDEremoveImportQualifications<CR>
":map <leader>ms :PSCIDEapplySuggestion<CR>
":map <leader>mc :PSCIDEcaseSplit<CR>
":map <leader>mp :PSCIDEpursuit<CR>
":map <leader>mr :PSCIDEload<CR>
":map <leader>mf :PSCIDEaddClause<CR>


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


" agda
let maplocalleader = "\\"
let g:agda_extraincpaths = ["/Users/v/vic/dev/agda"]
