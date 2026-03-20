# nsf — New Script File

[![Version](https://img.shields.io/badge/version-3.2.0-blue)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Bash](https://img.shields.io/badge/bash-4.0%2B-brightgreen)](https://www.gnu.org/software/bash/)
[![CI](https://github.com/Varenya-Sawant/nsf/actions/workflows/ci.yml/badge.svg)](https://github.com/Varenya-Sawant/nsf/actions)

A lightweight, zero-dependency CLI tool that creates properly structured
boilerplate script files instantly — with metadata headers, error handling,
and language best practices baked in.

```bash
nsf deploy.sh          # Bash script with set -euo pipefail and trap cleanup
nsf api.go             # Go program with run()/main() error pattern
nsf handler.go middleware.go router.go   # Three files at once
nsf --dry-run server.py                  # Preview output before creating
```

---

## Requirements

- **Bash 4.0+** — macOS ships Bash 3.2 by default; see [macOS note](#macos)
- Unix-like system: Linux, macOS, WSL
- No external dependencies

## Installation

```bash
git clone https://github.com/Varenya-Sawant/nsf.git
cd nsf
./install.sh --user          # installs to ~/.local/bin (no sudo needed)

# Add to PATH if not already there:
export PATH="$HOME/.local/bin:$PATH"

# Verify:
nsf --version
```

System-wide install (requires sudo):

```bash
./install.sh
```

### macOS

macOS ships with Bash 3.2. nsf requires 4.0+. Install a newer version:

```bash
brew install bash
/opt/homebrew/bin/bash install.sh --user
```

---

## Usage

```
nsf [options] <filename> [filename ...]
```

### Options

| Flag | Short | Description |
|---|---|---|
| `--help` | `-h` | Show help message |
| `--version` | `-v` | Show version number |
| `--list` | `-l` | List all supported file types |
| `--preview EXT` | `-p` | Show raw template for extension |
| `--config` | `-c` | Show active configuration |
| `--debug FILE` | `-d` | Create file with verbose output |
| `--dry-run` | `-n` | Show resolved output, create nothing |
| `--force` | `-f` | Overwrite existing file (prompts) |
| `--backup` | `-b` | Back up existing file then overwrite |
| `--desc TEXT` | `-D` | Set description in template header |

### Examples

```bash
# Create a single file
nsf myscript.sh

# Create multiple files at once
nsf handler.go middleware.go router.go

# See exactly what would be created before committing
nsf --dry-run analysis.py

# Set a description in the file header
nsf --desc "Nightly data sync job" sync.py

# Overwrite an existing file safely
nsf --backup config.sh          # saves config.sh.bak first
nsf --force existing.go          # prompts for confirmation

# Preview the raw template (with {{TOKENS}} visible)
nsf --preview ts

# Debug template resolution
nsf --debug myapp.rs
```

---

## Supported languages

| Extension | Language |
|---|---|
| `.sh` `.bash` | Bash |
| `.py` | Python 3 |
| `.js` | JavaScript |
| `.ts` | TypeScript |
| `.go` | Go |
| `.rs` | Rust |
| `.rb` | Ruby |
| `.php` | PHP |
| `.c` | C |
| `.cpp` | C++ |
| `.java` | Java |

---

## Configuration

nsf looks for a config file at `~/.config/nsf/nsf.conf`.
Install creates one automatically. All settings are optional.

```bash
# ~/.config/nsf/nsf.conf

NSF_AUTHOR="Your Name"
NSF_LICENSE="MIT"
NSF_DATE_FORMAT="%Y-%m-%d"
NSF_EDITOR="vim"
DEFAULT_MAKE_EXECUTABLE="true"
ENABLE_GIT_INTEGRATION="true"
```

Run `nsf --config` to see all active values and where they resolve from.

### Environment variables

Any config value can be overridden per-command with an environment variable:

```bash
NSF_AUTHOR="Alice" nsf deploy.sh
ENABLE_GIT_INTEGRATION=false nsf script.py
```

---

## Custom templates

Place a `EXT.tmpl` file in `~/.config/nsf/templates/` to override any
built-in template. nsf checks the user directory first.

```bash
mkdir -p ~/.config/nsf/templates
cp templates/python.tmpl ~/.config/nsf/templates/py.tmpl
# edit it however you like
nsf myfile.py   # uses your custom template
```

Available tokens in templates:

| Token | Description |
|---|---|
| `{{NSF_AUTHOR}}` | Author name from config |
| `{{NSF_DATE}}` | Creation date |
| `{{NSF_FILENAME}}` | Full filename (e.g. `api.go`) |
| `{{NSF_BASENAME}}` | Filename without extension (e.g. `api`) |
| `{{NSF_BASENAME_PASCAL}}` | PascalCase basename (used in Java) |
| `{{NSF_LICENSE}}` | License from config |
| `{{NSF_DESCRIPTION}}` | Description from `--desc` or config |

---

## Shell completion

Tab completion is installed automatically by `install.sh` for any shell
it detects (bash, zsh, fish).

For zsh, add to `~/.zshrc` if not already present:

```zsh
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit
```

---

## Project structure

```
nsf/
├── bin/
│   └── nsf                  Main executable — arg parsing + dispatch
├── lib/
│   ├── constants.sh         Global constants and defaults
│   ├── logger.sh            All terminal output and --help text
│   ├── utils.sh             Variable substitution, config loading, helpers
│   ├── templates.sh         Template loader (reads .tmpl files)
│   └── core.sh              File creation, batch, dry-run logic
├── templates/               Plain text template files — one per language
│   ├── sh.tmpl
│   ├── python.tmpl
│   ├── go.tmpl
│   └── ...                  (11 total)
├── completions/
│   ├── nsf.bash
│   ├── nsf.zsh
│   └── _nsf.fish
├── config/
│   └── nsf.conf             User config template
├── tests/
│   └── test_nsf.sh          Full test suite
├── .github/workflows/
│   ├── ci.yml               Runs on every push + PR
│   └── release.yml          Runs on version tag push
├── .shellcheckrc
├── install.sh
├── uninstall.sh
├── CHANGELOG.md
├── CONTRIBUTING.md
└── LICENSE
```

---

## Running tests

```bash
bash tests/test_nsf.sh
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide, including
how to add new language templates and the PR checklist.

## License

MIT — see [LICENSE](LICENSE).
