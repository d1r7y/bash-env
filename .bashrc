# Source system-wide bashrc

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Make sure we're starting as interactive.

[[ $- == *i* ]] || return 0

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

function add_ssh_keys {
    comm -3 <(ssh-add -l | sed -n '/no identities/!p' | cut -d' ' -f3 | sort) <(find ~/.ssh \( -name "*id_rsa*" -not -name "*.pub" \) -type f | sort) | xargs bash -c '</dev/tty ssh-add -t 7200 "$@"'
}

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
