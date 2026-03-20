#compdef nsf
# =============================================================================
# nsf.zsh — Zsh tab completion for nsf
# Install: place in a directory listed in $fpath, e.g. ~/.zsh/completions/
# Then add to ~/.zshrc:  fpath=(~/.zsh/completions $fpath)
#                        autoload -Uz compinit && compinit
# =============================================================================

_nsf() {
    local context state state_descr line
    typeset -A opt_args

    # -------------------------------------------------------------------------
    # Top-level argument spec
    # Each entry is: flag[description]:argument type
    # -------------------------------------------------------------------------
    _arguments -C \
        '(-h --help)'{-h,--help}'[Show help message]' \
        '(-v --version)'{-v,--version}'[Show version number]' \
        '(-l --list)'{-l,--list}'[List all supported file types]' \
        '(-c --config)'{-c,--config}'[Show active configuration]' \
        '(-n --dry-run)'{-n,--dry-run}'[Show what would be created without creating it]' \
        '(-f --force)'{-f,--force}'[Overwrite existing file]' \
        '(-b --backup)'{-b,--backup}'[Back up existing file before overwriting]' \
        '(-p --preview)'{-p,--preview}'[Preview template for extension]:extension:->ext' \
        '(-d --debug)'{-d,--debug}'[Create file with verbose debug output]:filename:_files' \
        '(-D --desc)'{-D,--desc}'[Description to inject into template]:description: ' \
        '*:filename:_files'

    # -------------------------------------------------------------------------
    # State handling — when --preview is used, complete with extensions
    # -------------------------------------------------------------------------
    case "${state}" in
        ext)
            local extensions
            extensions=(
                'sh:Bash script'
                'bash:Bash script'
                'py:Python 3'
                'js:JavaScript'
                'ts:TypeScript'
                'go:Go'
                'rs:Rust'
                'rb:Ruby'
                'php:PHP'
                'c:C'
                'cpp:C++'
                'java:Java'
            )
            _describe 'extension' extensions
            ;;
    esac
}

_nsf "$@"
