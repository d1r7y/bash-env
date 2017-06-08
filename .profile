export PATH="$PATH:/usr/local/bin"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

export EDITOR=vim

declare -ra SEARCH_PATHS=("$HOME/bin" "$HOME/work/arcanist/bin")
for dir in "${SEARCH_PATHS[@]}"; do
    if [ -d "$dir" ]; then
        export PATH="$PATH:$dir"
    fi
done

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend 			 # append to history, don't overwrite it

if [ "$BASH" ] && [ -f "$HOME/.bashrc" ]; then
   . "$HOME/.bashrc"
fi
