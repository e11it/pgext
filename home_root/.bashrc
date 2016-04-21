export TERM=xterm
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Bash history
HISTSIZE=2500
HISTFILESIZE=2500
shopt -s histappend
# correct minor spelling errors in cd
shopt -s cdspell
#include dotfiles in wildcard expansion, and match case-insensitively
shopt -s dotglob
shopt -s nocaseglob

export YELLOW=`echo -e '\033[1;33m'`
export LIGHT_CYAN=`echo -e '\033[1;36m'`
export NOCOLOR=`echo -e '\033[0m'`

export LESS="-iMSx4 -FXR"

PAGER="sed \"s/\([[:space:]]\+[0-9.\-]\+\)$/${LIGHT_CYAN}\1$NOCOLOR/;" 
PAGER+="s/\([[:space:]]\+[0-9.\-]\+[[:space:]]\)/${LIGHT_CYAN}\1$NOCOLOR/g;" 
PAGER+="s/|/$YELLOW|$NOCOLOR/g;s/^\([-+]\+\)/$YELLOW\1$NOCOLOR/\" 2>/dev/null  | less"
export PAGER

export PGUSER=postgres
export PGDATABASE=postgres
export BACKUP_PATH=/share/pg_rman/backup

alias psql-connect='psql -U postgres -d postgres'
alias rman-full='/root/rman_full.sh'
alias rman-inc='/root/rman_inc.sh'
alias rman-ls='pg_rman show'
