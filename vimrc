set nocompatible              
filetype off                  
set number
set tabstop=2
set shiftwidth=2
set complete+=kspell
filetype plugin indent on    " required
:color murphy 
syntax on
filetype plugin indent on
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set shellcmdflag=-ic
set t_Co=256
call plug#begin()
Plug 'vimwiki/vimwiki'
let wiki = {}
let wiki.path = '/media/brian/Data/vimwiki_enetics/'
let wiki.syntax = 'markdown'
let wiki.ext = '.md'
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
call plug#end()
" File templates
au BufNewFile postmortem-*.md 0r ~/dotfiles/templates/postmortem-template.md
au BufNewFile sow-*.md 0r ~/dotfiles/templates/sow-template.md

