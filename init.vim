se nocp
se nu ai nowrap path+=** wildmenu ttyfast ts=8 sw=8
se relativenumber
se noet
se mouse=a

function ShowInvisibles()
	setlocal list listchars=tab:➝ ,space:·,eol:↵,extends:↪,precedes:↩
endfunction

syntax on
let g:mapleader=';'

" let g:python3_host_prog='/usr/bin/python3'

if has('win32')
	let g:python3_host_prog='D:\Python3\python.exe'

	let &shell = 'powershell'
	se shellquote= shellpipe=\| shellxquote=
	se shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
	se shellredir=\|\ Out-File\ -Encoding\ UTF8
endif

" se laststatus=2
se statusline=%f\ %m\ %r\ %h\ %w\ File:\ %p%%\ Win:\ %P\ %l/%L@%c%=%=%{g:colors_name}\ %y\ %q\ Character:\ %b\ (%B)

"se guifont=Cascadia\ Code\ PL:h16
"se guifont=Consolas:h16
se guifont=DelugiaCode\ NF:h16

": Treat asm files as NASM files
autocmd FileType asm setlocal syntax=nasm
": Treat Matlab files (.m) as Objective-C
autocmd FileType matlab setlocal filetype=objc
": Treat MMA files (.m) as Objective-C
autocmd FileType mma setlocal filetype=objc

nnoremap <C-P> :FZF<CR>

" vim-plug auto-install
if !has('win32')
	let data_dir = stdpath('data') . '/site'
	if empty(glob(data_dir . '/autoload/plug.vim'))
		silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		autocmd VimEnter * PlugInstall --sync | source '~/.config/nvim/init.vim'
	endif
endif
"
" autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
" 	\| PlugInstall --sync | source '~/.config/nvim/init.vim'
" \| endif

": Plugins have moved to home/home.nix!

filetype plugin indent on

se completeopt=noinsert,menuone,noselect
se shortmess+=c
inoremap <C-c> <ESC>
inoremap <expr> <CR> (pumvisible() ? "\<C-y>\<CR>" : "\<CR>")

lua << EOF
function on_attach2(client, bufnr)
	require'lsp_signature'.on_attach()
end

require'lspconfig'.clangd.setup{cmd={"clangd","--background-index"}, on_attach=on_attach2}
require'lspconfig'.gopls.setup{on_attach=on_attach2}
require'lspconfig'.rust_analyzer.setup{
	--cmd = { "C:/Users/anirudh/AppData/Roaming/Code/User/globalStorage/matklad.rust-analyzer/rust-analyzer-x86_64-pc-windows-msvc.exe" },
	--cmd = { "rustup", "run", "nightly", "rust-analyzer" },
	cmd = { "rust-analyzer" },
	settings = {
		["rust-analyzer"] = {
			cargo = {
				loadOutDirsFromCheck = true
			},
			procMacro = {
				enable = true
			},
			experimental = {
				procAttrMacros = true
			}
		}
	},
	on_attach = on_attach2
}
require'lspconfig'.tsserver.setup{on_attach=on_attach2}
require'lspconfig'.vimls.setup{on_attach=on_attach2}

require'recents'.set_art([[
888b    888                            d8b
8888b   888                            Y8P
88888b  888
888Y88b 888  .d88b.   .d88b.  888  888 888 88888b.d88b.
888 Y88b888 d8P  Y8b d88""88b 888  888 888 888 "888 "88b
888  Y88888 88888888 888  888 Y88  88P 888 888  888  888
888   Y8888 Y8b.     Y88..88P  Y8bd8P  888 888  888  888
888    Y888  "Y8888   "Y88P"    Y88P   888 888  888  888

out of the box
]])
EOF

" let g:float_preview#max_width = 30
let g:float_preview#auto_close = 1

let g:ale_linters = {
	\ 'rust': ['cargo'],
	\ 'cpp': [],
	\ 'objc': [],
	\ 'objcpp': [],
	\ 'python': [],
	\ 'javascript': [],
	\ 'typescript': [],
\ }
let g:ale_fix_on_save = 1
let g:ale_fixers = {
	\ 'rust': ['rustfmt'],
\ }
let g:ale_sign_error = '!'
let g:ale_sign_warning = '-'
" let g:ale_rust_cargo_use_clippy = 1

let g:deoplete#enable_at_startup = 1

" VSnip setup
" -----------------------------------------------------------------------------
" XXX: UNSAFE - not using nore, be careful
imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)'      : '<Tab>'
smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)'           : '<S-Tab>'
smap <expr> <S-Tab> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)'           : '<S-Tab>'

": FIXME: replace with native neovim lsp mappings
" nnoremap <leader>ca <cmd>call LanguageClient#textDocument_codeAction()<CR>
" nnoremap <leader>cdh <cmd>call LanguageClient#clearDocumentHighlight()<CR>
" nnoremap <leader>cl <cmd>call LanguageClient#handleCodeLensAction()<CR>
" nnoremap <leader>cm <cmd>call LanguageClient_contextMenu()<CR>
" nnoremap <leader>df <cmd>call LanguageClient#textDocument_definition()<CR>
" nnoremap <leader>dh <cmd>call LanguageClient#textDocument_documentHighlight()<CR>
" nnoremap <leader>ds <cmd>call LanguageClient#textDocument_documentSymbol()<CR>
" nnoremap <leader>ee <cmd>call LanguageClient#explainErrorAtPoint()<CR>
" nnoremap <leader>f <cmd>call LanguageClient#textDocument_formatting()<CR>
" nnoremap <leader>h <cmd>call LanguageClient#textDocument_hover()<CR>
" nnoremap <leader>i <cmd>call LanguageClient#textDocument_implementation()<CR>
" nnoremap <leader>rf <cmd>call LanguageClient#textDocument_references()<CR>
" nnoremap <leader>rn <cmd>call LanguageClient#textDocument_rename()<CR>
" nnoremap <leader>td <cmd>call LanguageClient#textDocument_typeDefinition()<CR>
" nnoremap <leader>ws <cmd>call LanguageClient#workspace_symbol()<CR>

nnoremap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>df <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader>ds <cmd>lua vim.lsp.buf.document_highlight()<CR>
nnoremap <leader>ds <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <leader>f  <cmd>lua vim.lsp.buf.formatting_sync()<CR>
nnoremap <leader>h  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>i  <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>rf <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>sh <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>td <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>ws <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

vnoremap <leader>ca <cmd>lua vim.lsp.buf.range_code_action()<CR><C-c>
vnoremap <leader>f  <cmd>lua vim.lsp.buf.range_formatting()<CR><C-c>

" Color scheme (Unikitty)
" -----------------------------------------------------------------------------
se termguicolors
color base16-snazzy

" Airline config
" -----------------------------------------------------------------------------
let g:airline_powerline_fonts=1
"let g:airline_symbols_ascii = 1
"let g:airline_skip_empty_sections=1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#languageclient#enabled = 1

" Preferred indentation for certain filetypes
au FileType python se ts=4 sw=4 et smarttab
au FileType haskell se ts=4 sw=4 et smarttab
au FileType dart se ts=2 sw=2 et smarttab
au FileType rust se ts=8 sw=8 noet smarttab

" Format on save
" FIXME: use native neovim lsp
au FileType dart au BufWritePost * call LanguageClient#textDocument_formatting()|w

" Setup float-preview
au FileType go au BufEnter * let g:float_preview#docked = 0
au FileType go au BufLeave * let g:float_preview#docked = 1

" Closes float-preview when completion is done
au InsertLeave,CompleteDone * if pumvisible() != 0 | call float_preview#close() | endif

nnoremap <C-K> :make<CR>

" Neovide configuration
let g:neovide_cursor_antialiasing = v:true
