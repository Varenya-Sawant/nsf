# Changelog

All notable changes to nsf are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Version numbers follow [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

---

## [3.2.0] — 2026-03-19

This release completes the foundation — every gap between "it works" and
"it's production ready" has been addressed before feature work continues.

### Added
- `templates/` directory — all language templates are now plain `.tmpl` files
  instead of hardcoded heredocs in `lib/templates.sh`
- Variable substitution engine — `{{NSF_AUTHOR}}`, `{{NSF_DATE}}`,
  `{{NSF_FILENAME}}`, `{{NSF_BASENAME}}`, `{{NSF_LICENSE}}`,
  `{{NSF_DESCRIPTION}}` tokens replaced at file creation time
- User template override — place `EXT.tmpl` in `~/.config/nsf/templates/`
  to override any built-in template without touching the source
- `--dry-run` / `-n` flag — shows fully resolved file content without creating
  anything; also shows which post-creation actions would run
- `--force` / `-f` flag — allows overwriting an existing file (prompts for
  confirmation)
- `--backup` / `-b` flag — backs up an existing file to `filename.bak` before
  overwriting; implies `--force`
- `--desc` / `-D` flag — sets the description injected into `{{NSF_DESCRIPTION}}`
  directly from the command line
- Overwrite protection — attempting to create a file that already exists now
  aborts with a clear error message by default
- Batch creation — multiple filenames in one call now properly tracked
  per-file with a summary table (created / skipped / failed)
- Shell tab completion — `completions/nsf.bash`, `completions/nsf.zsh`,
  `completions/_nsf.fish`; installed automatically by `install.sh`
- C, C++, Java templates — three new languages (`c.tmpl`, `cpp.tmpl`,
  `java.tmpl`); Java class name auto-converted to PascalCase
- GitHub Actions CI pipeline — shellcheck + tests on ubuntu + macos on
  every push and PR; CHANGELOG enforcement on PRs that change code
- GitHub Actions release pipeline — auto-creates a GitHub Release with
  tarball and SHA256 checksum on version tag push
- Bash version preflight check — clear error on Bash < 4.0 with fix
  instructions for macOS users
- `--config` now shows template directory paths
- Expanded test suite — covers all 11 languages, variable substitution,
  overwrite protection, backup, dry-run, batch, user template override

### Changed
- `lib/templates.sh` is now a loader, not a template store — no more
  hardcoded heredoc strings
- `--help` output restructured into sections (USAGE / OPTIONS / EXAMPLES /
  CONFIGURATION) with two-column aligned flags
- `install.sh` now verifies Bash version, installs completions, and
  verifies the install succeeded before exiting
- `uninstall.sh` now removes completions and explicitly preserves user config
- README updated to match actual project structure (phantom `templates/`
  directory documented as existing — now it actually does)

### Fixed
- README project tree showed `templates/*.tmpl` files that did not exist
- Batch creation was hinted at in tips but not properly implemented
- No confirmation or error when attempting to overwrite an existing file

---

## [3.1.0] — 2026-03-09

### Added
- Modular architecture: split into `lib/constants.sh`, `lib/logger.sh`,
  `lib/utils.sh`, `lib/templates.sh`, `lib/core.sh`
- `--preview EXT` flag to show template before creating
- `--debug FILE` flag for verbose output during creation
- `--config` flag to display active configuration
- Git integration: auto `git add` after file creation
- Editor prompt after creation (Vim / Nano / Skip)
- Configuration file support at `~/.config/nsf/nsf.conf`
- Test suite: `tests/test_nsf.sh`
- `install.sh` and `uninstall.sh`

### Supported languages
Bash, Python, JavaScript, TypeScript, Go, Rust, Ruby, PHP

---

## [3.0.0] — initial modular rewrite

Initial structured release. Replaced single-file script with modular
library approach. Added colour output, metadata injection (author, date),
and `chmod +x` for script files.

---

[Unreleased]: https://github.com/Varenya-Sawant/nsf/compare/v3.2.0...HEAD
[3.2.0]: https://github.com/Varenya-Sawant/nsf/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/Varenya-Sawant/nsf/compare/v3.0.0...v3.1.0
