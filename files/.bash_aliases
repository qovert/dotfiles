alias lt='ls --human-readable --size -1 -S --classify'
alias vi='vim'
alias build-blog='hugo -D && rsync -Pav public/ root@143.198.76.223:/usr/local/bastille/jails/nginx/root/usr/local/www/blog.harkreader.me/ --delete'
