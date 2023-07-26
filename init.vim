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

if has('win32')
	let g:python3_host_prog='D:\Python3\python.exe'

	let &shell = 'powershell'
	se shellquote= shellpipe=\| shellxquote=
	se shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
	se shellredir=\|\ Out-File\ -Encoding\ UTF8
endif

se guifont=DelugiaCode\ NF:h16

": Treat asm files as NASM files
autocmd FileType asm setlocal syntax=nasm
": Treat Matlab files (.m) as Objective-C
autocmd FileType matlab setlocal filetype=objc
": Treat MMA files (.m) as Objective-C
autocmd FileType mma setlocal filetype=objc

nnoremap <C-P> :FZF<CR>

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

function ra_update_server_status(err, result, ctx, config)
	local status = result["message"]
	if status == nil then
		status = "ready"
	end
	local health = result["health"]
	local status_string
	if result["quiescent"] then
		status_string = "[" .. health .. "*" .. status .. "] rust-analyzer"
	else
		status_string = "[" .. health .. "." .. status .. "] rust-analyzer"
	end
	vim.g["ra_status"] = status_string
end

function ra_update_analysis_status(err, result, ctx, config)
	if string.match(result["token"], "^rustAnalyzer/") == nil then
		return
	end
	local res = result["value"]
	if res["kind"] == "begin" then
		vim.g["ra_analysis_title"] = res["title"]
		if res["message"] ~= nil then
			vim.g["ra_analysis_message"] = res["message"]
		end
	end
	if res["kind"] == "report" then
		if res["message"] ~= nil then
			vim.g["ra_analysis_message"] = res["message"]
		end
	end
	if res["kind"] == "end" then
		vim.g["ra_analysis_title"] = ""
		vim.g["ra_analysis_message"] = ""
	end
end

require'lspconfig'.clangd.setup{cmd={"clangd","--background-index"}, on_attach=on_attach2}
require'lspconfig'.gopls.setup{on_attach=on_attach2}
require'lspconfig'.rust_analyzer.setup{
	cmd = { "rust-analyzer" },
	settings = {
		["rust-analyzer"] = {
			lruCapacity = 16384
		}
	},
	on_attach = on_attach2,
	capabilities = {
		window = {
			workDoneProgress = true
		},
		experimental = {
			serverStatusNotification = true
		}
	},
	handlers = {
		["experimental/serverStatus"] = ra_update_server_status,
		["$/progress"] = ra_update_analysis_status
	}
}
require'lspconfig'.tsserver.setup{on_attach=on_attach2}
require'lspconfig'.vimls.setup{on_attach=on_attach2}
require'lspconfig'.pyright.setup{on_attach=on_attach2}
require'lspconfig'.sourcekit.setup{cmd={"xcrun","sourcekit-lsp"},on_attach=on_attach2,root_dir=require'lspconfig'.util.root_pattern("Package.swift")}
if vim.fn.executable('stack') then
	require'lspconfig'.hls.setup{cmd={"stack","exec","--","haskell-language-server-wrapper","--lsp"},on_attach=on_attach2}
else
	require'lspconfig'.hls.setup{on_attach=on_attach2}
end

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

let g:deoplete#enable_at_startup = 1

" VSnip setup
" -----------------------------------------------------------------------------
" XXX: UNSAFE - not using nore, be careful
imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)'      : '<Tab>'
smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)'           : '<S-Tab>'
smap <expr> <S-Tab> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)'           : '<S-Tab>'

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
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#nvimlsp#enabled = 1

let g:ra_status = ''
let g:ra_analysis_title = ''
let g:ra_analysis_message = ''
function GetRAStatus()
	return g:ra_status . " / " . g:ra_analysis_title . " (" . g:ra_analysis_message . ")"
endfunction

call airline#parts#define_function('ra_status', 'GetRAStatus')
let g:airline_section_y = airline#section#create_right(['ffenc', 'ra_status'])

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
