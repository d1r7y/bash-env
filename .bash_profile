# Add paths to search path.

# I want /usr/local/bin to be ahead of /usr/bin

export PATH="/usr/local/bin:$PATH"

declare -ra SEARCH_PATHS=("$HOME/bin" "$HOME/work/arcanist/bin")
for dir in "${SEARCH_PATHS[@]}"; do
    if [ -d "$dir" ]; then
        export PATH="$PATH:$dir"
    fi
done

# Start SSH Key Agent

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
}

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

comm -3 <(ssh-add -l | sed -n '/no identities/!p' | cut -d' ' -f3) <(find ~/.ssh \( -name "*id_rsa*" -not -name "*.pub" \) -type f) | xargs -o ssh-add -t 7200

# Add bash extensions.

declare -ra BASH_EXTENSIONS_PATHS=(
"$HOME/work/arcanist/resources/shell/bash-completion"
"$HOME/.bash_extensions"
)
for extension in "${BASH_EXTENSIONS_PATHS[@]}"; do
    if [ -f "$extension" ]; then
        . "$extension"
    fi
    if [ -d "$extension" ]; then
        for file in "$extension"/*.bash; do
            test -f "$file" || continue
            . "$file"
        done
    fi
done

prompt_command () {
    # If it exists, we need to call update_terminal_cwd for Terminal to correctly restore our CWD.
    if declare -F update_terminal_cwd > /dev/null; then
        update_terminal_cwd
    fi

    if declare -F __git_ps1 > /dev/null; then
        # if we're in a Git repo, show current branch
        BRANCH="\$(__git_ps1 ' (%s)')"
    fi
    local GREEN="\[\033[0;32m\]"
    local BLUE="\[\033[0;34m\]"
    local DEFAULT="\[\033[0;39m\]"
    local TITLEBAR=`echo -ne "\033]0; ${PWD##*/}\007"`
    export PS1="\[${TITLEBAR}\][\u@\h ${BLUE}\W${GREEN}${BRANCH}${DEFAULT}]\$ "
}

PROMPT_COMMAND=prompt_command

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend 			 # append to history, don't overwrite it

export EDITOR=vim

# Save and reload the history after each command finishes. Stop doing this, it makes things weird...
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

