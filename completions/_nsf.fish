# =============================================================================
# _nsf.fish — Fish shell completion for nsf
# Install: place in ~/.config/fish/completions/
# Fish loads all files in that directory automatically on shell start.
# =============================================================================

# Disable file completion by default — we re-enable it selectively below
complete -c nsf -f

# -----------------------------------------------------------------------------
# Flags
# -----------------------------------------------------------------------------
complete -c nsf -s h -l help       -d 'Show help message'
complete -c nsf -s v -l version    -d 'Show version number'
complete -c nsf -s l -l list       -d 'List all supported file types'
complete -c nsf -s c -l config     -d 'Show active configuration'
complete -c nsf -s n -l dry-run    -d 'Show what would be created, create nothing'
complete -c nsf -s f -l force      -d 'Overwrite existing file'
complete -c nsf -s b -l backup     -d 'Back up existing file before overwriting'
complete -c nsf -s p -l preview    -d 'Preview template for extension'
complete -c nsf -s d -l debug      -d 'Create file with verbose debug output'
complete -c nsf -s D -l desc       -d 'Description to inject into template'

# -----------------------------------------------------------------------------
# Extension completions for --preview
# Only offered when the previous token is --preview or -p
# -----------------------------------------------------------------------------
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'sh'   -d 'Bash'
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'bash' -d 'Bash'
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'py'   -d 'Python 3'
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'js'   -d 'JavaScript'
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'ts'   -d 'TypeScript'
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'go'   -d 'Go'
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'rs'   -d 'Rust'
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'rb'   -d 'Ruby'
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'php'  -d 'PHP'
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'c'    -d 'C'
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'cpp'  -d 'C++'
complete -c nsf -n '__fish_seen_subcommand_from --preview -p' \
    -a 'java' -d 'Java'

# -----------------------------------------------------------------------------
# Filename completion for regular usage (when no flag is active)
# Re-enable file completion for positional filename arguments
# -----------------------------------------------------------------------------
complete -c nsf -n 'not __fish_seen_subcommand_from --preview -p --debug -d' -F
