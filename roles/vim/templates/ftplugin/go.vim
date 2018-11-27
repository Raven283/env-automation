let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"

augroup filetype_golang
    autocmd!
    autocmd FileType go setl noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
augroup END
