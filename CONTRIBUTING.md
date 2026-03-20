# Contributing to nsf

Thank you for contributing. This guide covers everything you need to know
to get a PR merged cleanly.

---

## Development setup

```bash
git clone https://github.com/Varenya-Sawant/nsf.git
cd nsf
chmod +x bin/nsf install.sh uninstall.sh tests/test_nsf.sh
```

Install for development (user mode — no sudo):

```bash
./install.sh --user
export PATH="$HOME/.local/bin:$PATH"
```

## Running tests

```bash
bash tests/test_nsf.sh
```

All tests must pass before a PR can be merged. CI runs the suite
automatically on Ubuntu and macOS.

## Code quality

Run shellcheck on any file you modify:

```bash
shellcheck bin/nsf
shellcheck lib/your_changed_file.sh
```

CI enforces shellcheck with zero warnings. Fix every warning — do not
add suppressions without a comment explaining why.

## Adding a new language template

1. Create `templates/EXT.tmpl` with your template content
2. Add the extension to `NSF_SUPPORTED_EXTENSIONS` in `lib/constants.sh`
3. Add the extension to all three completion scripts in `completions/`
4. Add test cases to `tests/test_nsf.sh` (file creation + content check)
5. Update `CHANGELOG.md` under `[Unreleased]`

Available tokens in templates:

| Token | Example value |
|---|---|
| `{{NSF_AUTHOR}}` | `Varenya Sawant` |
| `{{NSF_DATE}}` | `2026-03-19` |
| `{{NSF_FILENAME}}` | `api.go` |
| `{{NSF_BASENAME}}` | `api` |
| `{{NSF_BASENAME_PASCAL}}` | `Api` (Java only) |
| `{{NSF_LICENSE}}` | `MIT` |
| `{{NSF_DESCRIPTION}}` | `HTTP REST API server` |

## PR checklist

Before submitting a pull request, confirm every item:

- [ ] `bash tests/test_nsf.sh` passes with zero failures
- [ ] `shellcheck` reports zero warnings on any modified `.sh` files
- [ ] `CHANGELOG.md` has a new entry under `[Unreleased]` describing the change
- [ ] New language templates include test cases covering file creation and content
- [ ] New flags are documented in `--help` output in `lib/logger.sh`
- [ ] New flags are added to all three completion scripts in `completions/`

## Commit message format

```
type: short description (max 72 chars)

Optional longer explanation if needed.
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

Examples:
```
feat: add --dry-run flag showing resolved template output
fix: preserve original file when --backup fails mid-write
docs: update README with correct project tree
test: add batch creation tests for mixed success/fail cases
```

## Reporting bugs

Open an issue and include:
- Output of `nsf --version`
- Your OS and Bash version (`bash --version`)
- The exact command you ran
- What you expected vs what happened
