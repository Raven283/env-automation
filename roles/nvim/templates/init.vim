"---------------------------------------------
" General configuration
"---------------------------------------------
syntax on                  " enable sytax highlight
filetype indent plugin on  " enable loading of ident files
set nocompatible           " nvim is nocompatible by default
set fileformat=unix        " always use unix <EOL>
set langmenu=en_US         " use en as language menu
set hidden                 " be able to switch buffers without file save
set showcmd                " shows command in the last line
set nostartofline          " some command move to the first non-blank line
set number                 " line number on
set clipboard=unnamedplus  " allow copy paste system <-> nvim
set exrc                   " enable project specific .nvimrc files
set secure                 " disable write/shell commands in those files
set splitbelow             " put the new window below the current one
set splitright             " put the new window right of the current one
set incsearch              " search as you type
set cursorline             " highlight current line
set shortmess+=c           " don't give completion messages
set updatetime=50
set noswapfile             " don't create swap files
set nobackup               " don't create backup files
set nowritebackup          " for more info see backup table
set signcolumn="yes:[1]"   " always show sign column
set undodir=~/.config/nvim/undodir
set completeopt=menuone,noinsert,noselect

" Color
set termguicolors          " use gui 24-bit colors, gui attrs instead of cterm
set t_Co=256
set background=dark

" Identation
set autoindent             " copy indent from current line when starting a new line
set smarttab               " <Tab> in front of a line inserts blanks according to 'shiftwidth'
set expandtab              " spaces instead of tabs
set softtabstop=2          " the number of spaces to use when expanding tabs
set shiftwidth=2           " the number of spaces to use when indenting -- or de-indenting -- a line
set tabstop=2              " the number of spaces that a tab equates to

" Folding
set foldmethod=expr        " fold is defined by treesiter expressions
set foldexpr=nvim_treesitter#foldexpr()
set foldcolumn=0           " width of fold column
set foldlevelstart=99      " don't close folds
set colorcolumn=80         " visualize max line width

let g:AutoPairsFlyMode = 1
let g:indentLine_color_gui = '#abaa98' " set color of identation symbols |
let g:indentLine_fileTypeExclude = ['json', 'markdown']

let mapleader="\<space>"
let maplocalleader="\<tab>"

"---------------------------------------------
" Plugins
"---------------------------------------------
call plug#begin('{{ plug_path }}')
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'mbbill/undotree'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'preservim/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'jiangmiao/auto-pairs'
Plug 'Olical/conjure', {'tag': 'v4.3.1'}
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/LargeFile'
Plug 'iamcco/markdown-preview.nvim', { 'for': 'markdown' }
Plug 'junegunn/goyo.vim'
Plug 'cocopon/colorswatch.vim'
Plug 'crusoexia/vim-monokai'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'romgrk/nvim-treesitter-context'

Plug 'rust-lang/rust.vim', { 'for': 'rust' }
call plug#end()

silent! colorscheme monokai
silent! color monokai

" autocomplete
let g:completion_enable_auto_popup = 0 " disable automatic autocomplete popup
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" remap ctrl-x ctrl-o to ctrl space
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
inoremap <silent><expr> <C-space> completion#trigger_completion()

autocmd CompleteDone * pclose

nnoremap <silent> g[ <cmd>PrevDiagnosticCycle<cr>
nnoremap <silent> g] <cmd>NextDiagnosticCycle<cr>

function! s:definition()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'tjump '.expand('<cword>')
  else
    lua vim.lsp.buf.definition()
  endif
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    lua vim.lsp.buf.hover()
  endif
endfunction

"---------------------------------------------
" Treesitter
"---------------------------------------------
lua <<EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    ident = {
      enable = true,
    },
    highlight = {
      enable = true,  -- false will disable the whole extension
    },
  }
EOF

"---------------------------------------------
" Python provider
"---------------------------------------------
let g:python_host_prog = '{{ python_venv_path | expanduser }}/bin/python'
let g:python3_host_prog = '{{ python3_venv_path | expanduser }}/bin/python'
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

"---------------------------------------------
" Nerd tree
"---------------------------------------------
let g:NERDTreeShowHidden=1 " show hidden files
let g:NERDTreeAutoDeleteBuffer = 1 " delete buffer when delete file
let g:NERDTreeMinimalUI=1

nmap <leader>fe :NERDTreeToggle<cr>
nmap <leader>ff :NERDTreeFind<cr>

autocmd FileType nerdtree setlocal colorcolumn& " fixes colorcolumn with open nerdtree

"---------------------------------------------
" Airline
"---------------------------------------------
let g:airline_section_c = '%t'
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#show_close_button = 0

"---------------------------------------------
" FZF
"---------------------------------------------
nmap <c-p> :Files<cr>
nmap <c-b> :Buffers<cr>
nmap <c-f> :Rg<cr>

command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --color=never --smart-case '.shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 showtabline=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showtabline=1 showmode ruler

" Nvim colorizer
lua require'colorizer'.setup()

let g:polyglot_disabled=['clojure', 'json', 'yaml']
let g:AutoPairsShortcutToggle = ''
let g:clojure_highlight_local_vars = 0

"---------------------------------------------
" Mappings
"---------------------------------------------

" File test
function! g:CopyFilepathToClipboard()
  let path = expand("%")
  let @+ = path
  echo path
endfunction

function! g:CopyFilenameToClipboard()
  let path = expand("%:t")
  let @+ = path
  echo path
endfunction

nmap <leader>cfn :call g:CopyFilenameToClipboard()<CR>
nmap <leader>cfp :call g:CopyFilepathToClipboard()<CR>

" Splits
nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l
nmap <c-\> <c-w>w
" close all splits except focused one
nmap <c-w>o <c-w><c-o>

" Tabs mappings
nmap <leader>tt :tabnew<CR>
nmap <leader>tp :tabprev<CR>
nmap <leader>tn :tabnext<CR>
nmap <leader>to :tabonly<CR>
nmap <leader>tc :tabclose<CR>

" Space 1 -> focus tab 1
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" Splits resizing
map <silent> <A-h> <C-w>>
map <silent> <A-j> <C-W>+
map <silent> <A-k> <C-W>-
map <silent> <A-l> <C-w><

" Git mappings
nmap <leader>gs :Gstatus<CR>
nmap <leader>gc :Gcommit<CR>
nmap <leader>gp :Gpush<CR>
nmap <leader>gb :Gblame<CR>
nmap <leader>gpr :Gpull -r<CR>
nmap <leader>gl :GV!<CR>
nmap <leader>gd :Gvdiffsplit<CR>
nmap <leader>gm :Gvdiffsplit!<CR>

" Navigation
" go to the beginning of the line
nmap H ^
" go to the end of the line
nmap L g_

vnoremap <silent> <leader>s :'<,'>sort<cr>

" Dispay syntax tree
map <leader>sx :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <leader>tx :echo nvim_treesitter#statusline(90)<CR>

nmap <leader>u :UndotreeShow<CR>

autocmd BufRead,BufNewFile *.mdx set filetype=markdown

" Clojure
nnoremap <leader>pb :Piggieback (figwheel.main.api/repl-env "dev")

nnoremap <leader>wm :Goyo<CR>
