" Configuration stolen from defaults.vim
set nocompatible
set backspace=indent,eol,start
set history=500		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line
set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key
set display=truncate
set scrolloff=5
set incsearch
set nrformats-=octal
set mouse=a
set nolangremap

filetype plugin indent on

augroup vimStartup
	autocmd!
	autocmd BufReadPost *
				\ let line = line("'\"")
				\ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
				\      && index(['xxd', 'gitrebase'], &filetype) == -1
				\ |   execute "normal! g`\""
				\ | endif
augroup END

syntax on

" General configuration
set matchtime=0 ic nu laststatus=2 hidden

" Colorscheme
set bg=dark
let g:gruvbox_contrast_dark="hard"
colo gruvbox

" Style/code
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
set ts=8 sw=8 sts=8 cc=80
autocmd BufEnter *.html set ts=4 sts=4 sw=4

" Mappings
let g:mapleader=","

"" Window commands
"" Some useful ones:
"" cw + and cw -: increase and decrease window height.
"" cw > and cw <: increase and decrease window width.
"" cw =: make all windows the same height and width.
"" cw H: move current window to the left.
"" cw J: move current window to the bottom.
"" cw K: move current window to the top.
"" cw L: move current window to the right.
"" cw w: go to previous windows.
"" cw b: go to bottom window.
"" cw c: close current window.
"" cw f: split window and edit file under cursor.
"" cw h: go to the left window.
"" cw j: go to the bottom window.
"" cw k: go to the top window.
"" cw l: go to the right window.
map <leader>w <C-w>

"" Buffer commands
map <leader>bn :bn<CR>
map <leader>bp :bp<CR>

"" Movement
map <leader>cd <C-d>
map <leader>cu <C-u>

"" Undo/redo
map <leader>cr <C-r>

"" Buffers
map <leader><leader> :ls<cr>:b<space>

" C indent
set cino=t0,l1,(0

" Persistent Undo
let target_path = expand('~/.vim/persistent-undo/')
if !isdirectory(target_path)
	call system('mkdir -p ' . target_path)
endif
let &undodir = target_path
set undofile

" Emmet
autocmd BufEnter *.html packadd emmet-vim

" LSP
" abuse neovim
def! SetupLSP(): void
	var masonpath = expand('$HOME') .. '/.local/share/nvim/mason/bin/'
	var lspservers = [
		{
			name: 'clangd',
			filetype: ['c', 'cpp'],
			path: masonpath .. 'clangd',
			args: ['--background-index'],
		},
		{
			name: 'pyright',
			filetype: ['python'],
			path: masonpath .. 'pyright-langserver',
			args: ['--stdio'],
		},
		{
			name: 'tsserver',
			filetype: ['javascript', 'typescript'],
			path: masonpath .. 'typescript-language-server',
			args: ['--stdio'],
		},
		{
			name: 'jinja_lsp',
			filetype: ['htmldjango'],
			path: masonpath .. 'jinja-lsp',
			args: [''],
		},
		{
			name: 'html',
			filetype: ['html'],
			path: masonpath .. 'vscode-html-language-server',
			args: ['--stdio'],
		},
		{
			name: 'cssls',
			filetype: ['css'],
			path: masonpath .. 'vscode-css-language-server',
			args: ['--stdio'],
		}
	]

	packadd lsp
	g:LspAddServer(lspservers)
	inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
	nmap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
	nmap <leader>gd :LspGotoDefinition<cr>
	nmap <leader>gD :LspGotoDeclaration<cr>
	nmap <leader>gi :LspGotoImpl<cr>
	nmap <leader>gt :LspGotoTypeDef<cr>
	nmap <leader>d  :LspDiagCurrent<cr>
enddef

autocmd BufEnter *.c,*.cpp,*.py call SetupLSP()
