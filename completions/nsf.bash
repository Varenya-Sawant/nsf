#!/usr/bin/env bash
# =============================================================================
# nsf.bash — Bash tab completion for nsf
# Install: source this file from ~/.bashrc or place in /etc/bash_completion.d/
# =============================================================================

_nsf_complete() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # All available flags
    local flags="--help --version --list --preview --config --debug \
                 --dry-run --force --backup --desc \
                 -h -v -l -p -c -d -n -f -b -D"

    # Supported file extensions for filename completion hints
    local extensions="sh bash py js ts go rs rb php c cpp java"

    # If previous word was --preview or -p, complete with extensions
    case "${prev}" in
        --preview|-p)
            # shellcheck disable=SC2207
            COMPREPLY=( $(compgen -W "${extensions}" -- "${cur}") )
            return 0 ;;
        --debug|-d|--desc|-D)
            # These expect a value next — fall through to default file completion
            return 0 ;;
    esac

    # If current word starts with -, complete flags
    if [[ "${cur}" == -* ]]; then
        # shellcheck disable=SC2207
        COMPREPLY=( $(compgen -W "${flags}" -- "${cur}") )
        return 0
    fi

    # Otherwise complete with filenames from the current directory
    # shellcheck disable=SC2207
    COMPREPLY=( $(compgen -f -- "${cur}") )
}

complete -F _nsf_complete nsf
