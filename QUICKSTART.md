# Quick Start Guide for Unix/Linux

**NSF - New Script File Creator v3.1.0**

This guide will help you get started with NSF on your Unix/Linux system.

## Installation (On Your Unix VM)

### Option 1: System-wide Installation (Recommended)

```bash
cd nsf
./install.sh
```

This will:
- Install NSF to `/usr/local/bin/`
- Create configuration directory at `~/.config/nsf/`
- Set up default configuration file
- Make nsf command globally available

### Option 2: User Installation (No sudo required)

```bash
cd nsf
./install.sh --user
```

This will:
- Install NSF to `~/.local/bin/`
- Add to your user PATH
- Create same configuration as system install

### Option 3: Manual Installation

```bash
# Create symlink
mkdir -p ~/.local/bin
ln -s "$(pwd)/bin/nsf" ~/.local/bin/nsf

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.local/bin:$PATH"

# Setup configuration
mkdir -p ~/.config/nsf
cp config/nsf.conf ~/.config/nsf/
```

## Verify Installation

```bash
# Check version
nsf --version

# View help
nsf --help

# List supported languages
nsf --list
```

## Basic Usage

### Create a Python script
```bash
nsf my_script.py
```

### Create a Bash script
```bash
nsf deploy.sh
```

### Create a JavaScript file
```bash
nsf app.js
```

### Create a Go program
```bash
nsf main.go
```

### Supported extensions:
- `.sh`, `.bash` - Bash/Shell
- `.py` - Python 3
- `.js` - JavaScript
- `.ts` - TypeScript
- `.go` - Go
- `.rs` - Rust
- `.rb` - Ruby
- `.php` - PHP

## Configuration

### Edit configuration file

```bash
nano ~/.config/nsf/nsf.conf
```

### Common configurations:

```bash
# Set your name as default author
NSF_AUTHOR="Your Name"

# Set date format (strftime syntax)
NSF_DATE_FORMAT="%Y-%m-%d"

# Set preferred editor
NSF_EDITOR="vim"

# Enable debug mode
NSF_DEBUG="false"
```

### Or use environment variables

```bash
# Set author for single session
export NSF_AUTHOR="John Developer"

# Create a script
nsf myapp.py

# Reset
unset NSF_AUTHOR
```

## Advanced Commands

### Preview a template before creating
```bash
nsf --preview py    # Shows Python template
nsf --preview js    # Shows JavaScript template
nsf --preview sh    # Shows Bash template
```

### View current configuration
```bash
nsf --config
```

### Debug mode (see detailed logs)
```bash
nsf --debug myapp.sh
```

## Testing

Run the test suite to verify everything works:

```bash
bash tests/test_nsf.sh
```

This will:
- Test all language templates
- Verify file creation
- Check error handling
- Validate configuration
- Report test results

## Examples

### Example 1: Create and customize a Python script

```bash
# Create new Python script
nsf data_analyzer.py

# Edit it with your editor
vim data_analyzer.py

# Make changes and save
```

### Example 2: Create bash deployment script

```bash
# Create shell script
nsf deploy.sh

# Script will include:
# - Proper shebang (#!./usr/bin/env bash)
# - Error handling (set -euo pipefail)
# - Color codesd
# - Example error function
# - Author and date metadata
```

### Example 3: Create multiple scripts at once

```bash
# Create several scripts with different languages
nsf server.js
nsf config.py
nsf main.go
nsf utils.rb

# All follow their language's best practices!
```

## Troubleshooting

### NSF command not found

```bash
# Check if installed
which nsf

# If not found, verify installation
./install.sh --user

# Or add to PATH manually
export PATH="$HOME/.local/bin:$PATH"
```

### Permission denied on scripts

```bash
# Make nsf executable
chmod +x bin/nsf

# Make all lib scripts executable
chmod +x lib/*.sh
```

### Configuration not loading

```bash
# Check if config file exists
ls -la ~/.config/nsf/nsf.conf

# Verify syntax (no special characters)
cat ~/.config/nsf/nsf.conf

# Enable debug to see what loads
NSF_DEBUG=true nsf --config
```

### Test failures

```bash
# Run tests with verbose output
NSF_DEBUG=true bash tests/test_nsf.sh

# Check test results for specific errors
```

## Getting Help

```bash
# Show help message
nsf --help

# Show all options
nsf --help

# See version
nsf --version

# See all templates
nsf --list

# Preview a template
nsf --preview py
```

## Uninstallation

If you need to remove NSF:

```bash
# For system installation
./uninstall.sh

# For manual/user installation
rm ~/.local/bin/nsf
```

## Adding to Git

If you want to track scripts in Git:

```bash
# Initialize git repo (if not already done)
git init

# Create first script
nsf myapp.sh

# Add to git
git add myapp.sh
git commit -m "Add myapp shell script"

# Push to GitHub
git push origin main
```

## Next Steps

1. ✅ Install NSF on your Unix VM
2. ✅ Configure your preferences in `~/.config/nsf/nsf.conf`
3. ✅ Run tests to verify: `bash tests/test_nsf.sh`
4. ✅ Create your first script: `nsf example.py`
5. ✅ Check the README for more detailed documentation
6. ✅ Review docs/API.md if you want to extend NSF

## Tips & Tricks

### Tip 1: Use environment variables for quick customization
```bash
NSF_AUTHOR="Project Bot" nsf script.sh
```

### Tip 2: Chain with editor for immediate editing
```bash
nsf myapp.py && vim myapp.py
```

### Tip 3: Generate multiple files at once
```bash
for lang in sh py js go rb; do
  nsf "example.$lang"
done
```

### Tip 4: Use in shell scripts
```bash
#!/bin/bash
# Generate scripts programmatically
nsf server.js
nsf handler.py
nsf config.sh
```

## Support

If you encounter any issues:

1. Check the [README.md](README.md) for detailed documentation
2. Review [docs/API.md](docs/API.md) for internal details
3. Read [CONTRIBUTING.md](CONTRIBUTING.md) for development info
4. Run tests: `bash tests/test_nsf.sh`
5. Enable debug: `NSF_DEBUG=true nsf --help`

---

**Created:** March 10, 2026  
**Version:** 3.1.0  
**License:** MIT  
**Status:** Production Ready ✅
