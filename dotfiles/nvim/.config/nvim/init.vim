"Do not wrap text
set nowrap

"Always yank to clipboard
set clipboard+=unnamedplus

"Line numbers
set relativenumber

"Indentation
set expandtab
set autoindent

autocmd FileType make,python,java,javascript,typescript setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80
autocmd FileType json,markdown,html,htmldjango,css,vue,c,sh,yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
