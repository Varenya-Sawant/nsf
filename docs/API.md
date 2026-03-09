# NSF API Reference

**NSF - New Script File Creator v3.1.0**

---

## Table of Contents

1. [Main Script (bin/nsf)](#main-script)
2. [Library Functions](#library-functions)
   - [constants.sh](#constantssh)
   - [logger.sh](#loggersh)
   - [utils.sh](#utilssh)
   - [templates.sh](#templatessh)
   - [core.sh](#coresh)
3. [Configuration](#configuration)
4. [Exit Codes](#exit-codes)

---

## Main Script

### `bin/nsf [OPTIONS] [filename]`

Main entry point for NSF tool.

**Usage:**
```bash
nsf script.py                    # Create Python script
nsf --help                       # Show help
nsf --version                    # Show version
nsf --list                       # List supported languages
nsf --preview python             # Preview Python template
nsf --config                     # Show configuration
nsf --debug script.sh            # Debug mode
```

**Options:**
- `--help, -h` - Display help message
- `--version, -v` - Display version information
- `--list, -l` - List all supported languages
- `--preview LANG, -p LANG` - Preview template for language
- `--config, -c` - Show current configuration
- `--debug, -d` - Enable debug mode

**Exit Codes:**
See [Exit Codes](#exit-codes) section

---

## Library Functions

### constants.sh

Global constants and configuration values.

#### Variables

**Version**
```bash
NSF_VERSION="3.1.0"
```

**Supported Extensions**
```bash
SUPPORTED_EXTENSIONS=(sh bash py js ts go rs rb php)
```

**Color Codes**
```bash
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_BLUE='\033[0;34m'
COLOR_NC='\033[0m'  # No Color
```

**Exit Codes**
```bash
ERROR_SUCCESS=0
ERROR_GENERAL=1
ERROR_UNSUPPORTED_LANGUAGE=2
ERROR_FILE_EXISTS=3
ERROR_PERMISSION_DENIED=4
ERROR_INVALID_ARGUMENT=5
ERROR_LIBRARY_NOT_FOUND=6
ERROR_TEMPLATE_NOT_FOUND=7
ERROR_CONFIG_NOT_FOUND=8
```

**Paths**
```bash
NSF_CONFIG_DIR="${HOME}/.config/nsf"
NSF_CONFIG_FILE="${NSF_CONFIG_DIR}/nsf.conf"
NSF_LOG_DIR="${HOME}/.local/share/nsf"
```

---

### logger.sh

Logging and output functions with color support.

#### Functions

**init_logger()**
```bash
init_logger
```
Initialize logging system. Call this at script startup.

**debug(message)**
```bash
debug "Variable value is: $var"
```
Print debug message (only if DEBUG_MODE=1).

**log_info(message)**
```bash
log_info "Creating script file..."
```
Print informational message in blue.

**log_warn(message)**
```bash
log_warn "File already exists!"
```
Print warning message in yellow.

**log_error(message)**
```bash
log_error "Failed to create file"
```
Print error message in red (does NOT exit).

**error_exit(message, [exit_code])**
```bash
error_exit "Failed to load config" 5
```
Print error and exit with code (default: 1).

**success(message)**
```bash
success "Script created successfully!"
```
Print success message in green with checkmark.

**show_header(title)**
```bash
show_header "NSF - New Script File Creator"
```
Display formatted header.

**show_section(title)**
```bash
show_section "Supported Languages"
```
Display formatted section title.

**show_help()**
```bash
show_help
```
Display help message (built-in).

**show_version()**
```bash
show_version
```
Display version information (built-in).

---

### utils.sh

Utility and helper functions.

#### File Operations

**check_file_exists(filename)**
```bash
if check_file_exists "script.py"; then
    echo "File exists"
fi
```
Return 0 if file exists, 1 otherwise.

**make_executable(filename)**
```bash
make_executable "script.sh"
```
Make file executable (chmod +x).

**ensure_dir(dirpath)**
```bash
ensure_dir "${HOME}/.config/nsf"
```
Create directory if it doesn't exist.

#### Extension & Language

**get_extension(filename)**
```bash
ext=$(get_extension "script.py")  # Returns: py
```
Extract file extension from filename.

**validate_extension(extension)**
```bash
if validate_extension "py"; then
    echo "Python is supported"
fi
```
Check if extension is supported (0=success, 1=fail).

**get_supported_extensions()**
```bash
exts=$(get_supported_extensions)
echo "$exts"  # sh bash py js ts go rs rb php
```
Return space-separated list of supported extensions.

#### Configuration

**load_config()**
```bash
load_config
```
Load configuration from ~/.config/nsf/nsf.conf.

**init_config()**
```bash
init_config
```
Initialize config from template if not exists.

**create_default_config()**
```bash
create_default_config
```
Create default configuration file.

#### Validation & System

**command_exists(command)**
```bash
if command_exists "git"; then
    echo "Git is installed"
fi
```
Check if command is available in PATH.

**validate_syntax(filename, language)**
```bash
if validate_syntax "script.py" "py"; then
    echo "Syntax is valid"
fi
```
Validate script syntax (basic check).

**prompt_input(message)**
```bash
name=$(prompt_input "Enter your name: ")
```
Prompt user for input string.

---

### templates.sh

Language-specific template generation.

#### Main Functions

**generate_script(filename, language)**
```bash
generate_script "myapp.py" "py"
```
Generate script with specified language template.

**get_template(language)**
```bash
template=$(get_template "javascript")
echo "$template"
```
Return template string for language.

**list_templates()**
```bash
list_templates
```
Display formatted list of all templates.

**preview_template(language)**
```bash
preview_template "go"
```
Display template preview for language.

#### Language-Specific Functions

**get_template_sh()**
```bash
get_template_sh  # Bash template
```

**get_template_py()**
```bash
get_template_py  # Python 3 template
```

**get_template_js()**
```bash
get_template_js  # JavaScript template
```

**get_template_ts()**
```bash
get_template_ts  # TypeScript template
```

**get_template_go()**
```bash
get_template_go  # Go template
```

**get_template_rs()**
```bash
get_template_rs  # Rust template
```

**get_template_rb()**
```bash
get_template_rb  # Ruby template
```

**get_template_php()**
```bash
get_template_php  # PHP template
```

#### Template Functions

**show_configuration()**
```bash
show_configuration
```
Display NSF configuration settings.

**ask_open_editor(filename)**
```bash
if ask_open_editor "script.py"; then
    # User said yes, open with editor
fi
```
Prompt user to open file in editor (return 0=yes, 1=no).

---

### core.sh

Core script creation logic.

#### Main Functions

**init_nsf()**
```bash
init_nsf
```
Initialize NSF system:
- Load logger
- Load configuration
- Initialize config if needed

**create_script(filename, language)**
```bash
create_script "myapp.py" "python"
```
Create new script:
1. Validate extension
2. Check if file exists
3. Get template
4. Inject metadata (author, date)
5. Create file
6. Make executable
7. Summary

**show_summary(filename, language)**
```bash
show_summary "script.py" "python"
```
Display summary of created script.

---

## Configuration

NSF uses `~/.config/nsf/nsf.conf` for user configuration.

### Configuration Variables

```bash
NSF_AUTHOR="Your Name"              # Author name for scripts
NSF_EMAIL="your@email.com"          # Author email
NSF_DATE_FORMAT="%Y-%m-%d"          # Date format
NSF_EDITOR="nano"                   # Text editor
NSF_DEBUG=0                         # Debug mode
NSF_USE_COLORS=1                    # Color output
NSF_AUTO_EXECUTABLE=1               # Auto chmod +x
NSF_LOG_FILE=""                     # Log file (optional)
NSF_DEFAULT_LANGUAGE="sh"           # Default language
NSF_CREATE_BACKUP=1                 # Backup before overwrite
NSF_CUSTOM_TEMPLATES=""             # Custom template dir
NSF_QUIET_MODE=0                    # Quiet mode
NSF_PROMPT_TIMEOUT=30               # Prompt timeout (seconds)
```

---

## Exit Codes

| Code | Name | Meaning |
|------|------|---------|
| 0 | SUCCESS | Operation completed successfully |
| 1 | GENERAL | General/unspecified error |
| 2 | UNSUPPORTED_LANGUAGE | Language not supported |
| 3 | FILE_EXISTS | File already exists (no overwrite) |
| 4 | PERMISSION_DENIED | Permission denied |
| 5 | INVALID_ARGUMENT | Invalid arguments |
| 6 | LIBRARY_NOT_FOUND | Required library file not found |
| 7 | TEMPLATE_NOT_FOUND | Template not found |
| 8 | CONFIG_NOT_FOUND | Configuration file not found |

**Usage:**
```bash
nsf script.py
result=$?
if [[ $result -ne 0 ]]; then
    echo "NSF failed with code: $result"
fi
```

---

## Examples

### Create a Python Script
```bash
nsf app.py
```

### Create and View Template
```bash
nsf --preview go
```

### List All Languages
```bash
nsf --list
```

### Enable Debug Mode
```bash
NSF_DEBUG=1 nsf script.sh
```

### Custom Configuration
```bash
cat ~/.config/nsf/nsf.conf
# Edit to customize
nano ~/.config/nsf/nsf.conf
```

---

## Troubleshooting

**Failed to load library:**
```bash
# Check library files exist
ls -la ~/.local/nsf/lib/
```

**Failed to load config:**
```bash
# Initialize config
mkdir -p ~/.config/nsf
cp ~/.local/nsf/config/nsf.conf ~/.config/nsf/
```

**Permission denied:**
```bash
# Make main script executable
chmod +x ~/.local/nsf/bin/nsf
```

---

**For more information, see [README.md](../README.md) and [CONTRIBUTING.md](../CONTRIBUTING.md)**
