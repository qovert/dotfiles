set nocompatible              
filetype off                  

set number
set tabstop=4
filetype plugin indent on    " required
:color murphy 
syntax on
filetype plugin indent on
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256
call plug#begin()
Plug 'vimwiki/vimwiki'
call plug#end()
" File templates
au BufNewFile postmortem-*.md 0r ~/Documents/postmortem-templates/templates/postmortem-template-srebook.md

