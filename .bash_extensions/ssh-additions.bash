function add_ssh_keys {
    comm -3 <(ssh-add -l | sed -n '/no identities/!p' | cut -d' ' -f3 | sort) <(find ~/.ssh \( -name "*id_rsa*" -not -name "*.pub" \) -type f | sort) | tr -d [:blank:] | xargs bash -c '</dev/tty ssh-add -t 7200 "$@"' bash
}

