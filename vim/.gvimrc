colorscheme badwolf
set linespace=2
set guifont=DejaVu\ Sans\ Mono\ 12
"set guifont=Monaco:h18


highlight Normal guifg=#A39AA7 guibg=#000000
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)
highlight CursorColumn term=bold ctermbg=235 guibg=#4c5e99
highlight Cursor term=underline ctermbg=235 guibg=#f7a379 gui=bold
"highlight CursorLine term=underline gui=underline
highlight CursorLine guibg=#403C00

highlight DiffText gui=bold guifg=#ffffff guibg=#994ea0
" Limit column width
highlight ColorColumn cterm=bold ctermbg=magenta ctermfg=black gui=bold guibg=#584c5d guifg=black

