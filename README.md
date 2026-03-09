# NSF - New Script File Creator

[![Version](https://img.shields.io/badge/version-3.1.0-blue)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Bash](https://img.shields.io/badge/bash-4.0%2B-brightgreen)](https://www.gnu.org/software/bash/)
[![Status](https://img.shields.io/badge/status-stable-success)](docs/)

A **lightweight**, **production-ready** Bash utility for creating boilerplate script files instantly. Generate properly structured scripts with metadata, error handling, and best practices for 9+ programming languages.

## ✨ Features

### 🚀 **Quick Start**
```bash
nsf script.py    # Create Python script
nsf app.js       # Create JavaScript file
nsf main.go      # Create Go program
```

### 📚 **Multi-Language Support**
- **Shell** (.sh, .bash)
- **Python 3** (.py)
- **JavaScript** (.js)
- **TypeScript** (.ts)
- **Go** (.go)
- **Rust** (.rs)
- **Ruby** (.rb)
- **PHP** (.php)

### ⚡ **Smart Features**
✅ Auto metadata (author, date)  
✅ Make files executable  
✅ Comprehensive error handling  
✅ Configuration file support  
✅ Template preview  
✅ Debug mode for troubleshooting  
✅ Modular, maintainable architecture  

## 📋 Installation

### Prerequisites
- Bash 4.0 or higher
- Unix-like system (Linux, macOS, WSL)
- No external dependencies required

### Quick Install (System-wide)

```bash
# Clone repository
git clone https://github.com/Varenya-Sawant/nsf.git
cd nsf

# Run installer
./install.sh

# Verify installation
nsf --version
```

### User Installation (Home directory)

```bash
./install.sh --user

# Add to PATH if needed:
export PATH="$HOME/.local/bin:$PATH"
```

### Manual Installation

```bash
# Copy script to desired location
mkdir -p ~/.local/bin
ln -s "$(pwd)/bin/nsf" ~/.local/bin/nsf

# Add to PATH
export PATH="$HOME/.local/bin:$PATH"
```

## 🎯 Usage

### Basic Usage

```bash
# Create a new script file
nsf filename.sh       # Bash script
nsf script.py         # Python script
nsf app.js            # JavaScript file
nsf main.go           # Go program
```

### Command Options

```bash
nsf script.sh          # Create script with auto-detected language
nsf --help, -h         # Show help message
nsf --version, -v      # Display version information
nsf --list, -l         # List all supported file types
nsf --preview EXT, -p  # Preview template for extension
nsf --config, -c       # Show current configuration
nsf --debug FILE, -d   # Create script with verbose debugging
```

### Examples

```bash
# Create various files
nsf deploy.sh          # Bash deployment script
nsf analyze.py         # Python data analysis script
nsf server.js          # Node.js server
nsf api.go             # Go REST API

# Preview templates before creating
nsf --preview py       # See Python template
nsf --preview ts       # See TypeScript template

# List all supported languages
nsf --list

# View configuration
nsf --config

# Debug mode (verbose output)
nsf --debug myapp.rs
```

## 🔧 Configuration

### Configuration File

NSF looks for configuration at: `~/.config/nsf/nsf.conf`

Create it with:
```bash
mkdir -p ~/.config/nsf
# Copy example config
cp config/nsf.conf ~/.config/nsf/
```

### Common Settings

```bash
# Set default author name
NSF_AUTHOR="Your Name"

# Set date format (strftime syntax)
NSF_DATE_FORMAT="%Y-%m-%d"

# Set preferred editor
NSF_EDITOR="vim"

# Enable debug mode
NSF_DEBUG="true"
```

### Environment Variables

You can also set options via environment variables:

```bash
# Override author per session
export NSF_AUTHOR="John Developer"

# Use specific editor
export NSF_EDITOR="nano"

# Enable debug mode
export NSF_DEBUG="true"

# Create a script
nsf application.py
```

## 📖 Generated Script Examples

### Bash Script
```bash
#!/usr/bin/env bash

set -euo pipefail

# Color codes & error handling included
# Ready for production use
```

### Python Script
```python
#!/usr/bin/env python3

import logging
logger = logging.getLogger(__name__)

# Proper logging setup included
```

### JavaScript/TypeScript
```javascript
'use strict';

async function main() {
    try {
        // Your code here
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}
```

### Go Program
```go
package main

import (
    "fmt"
    "log"
)

func main() {
    if err := run(); err != nil {
        log.Fatalf("Error: %v", err)
    }
}
```

## 🧪 Testing

Run the test suite:

```bash
bash tests/test_nsf.sh
```

This runs comprehensive tests including:
- Command parsing and help
- File creation for all supported languages
- Template validation
- Configuration handling
- Error cases and edge conditions

## 📁 Project Structure

```
nsf/
├── bin/
│   └── nsf                 # Main executable
├── lib/
│   ├── constants.sh        # Global constants
│   ├── logger.sh           # Logging functions
│   ├── utils.sh            # Utility functions
│   ├── templates.sh        # Template definitions
│   └── core.sh             # Core logic
├── config/
│   └── nsf.conf            # Configuration template
├── tests/
│   └── test_nsf.sh         # Test suite
├── docs/                   # Documentation
├── install.sh              # Installation script
├── uninstall.sh            # Uninstallation script
├── CHANGELOG.md            # Version history
├── LICENSE                 # MIT License
└── README.md               # This file
```

## 🐛 Troubleshooting

### NSF command not found
```bash
# Check if installed correctly
which nsf

# If not found, add to PATH
export PATH="/usr/local/bin:$PATH"

# Or reinstall
cd /path/to/nsf && ./install.sh
```

### Permission denied errors
```bash
# Make scripts executable
chmod +x bin/nsf lib/*.sh

# For system installation, use sudo
sudo ./install.sh
```

### Configuration not loaded
```bash
# Verify config file exists
ls -la ~/.config/nsf/nsf.conf

# Check configuration syntax
cat ~/.config/nsf/nsf.conf

# Enable debug mode to see what's loaded
NSF_DEBUG=true nsf --config
```

### Debug mode
```bash
# Run with verbose output
nsf --debug myscript.sh

# Or set environment variable
export NSF_DEBUG=true
nsf myscript.sh
```

## 🚀 Performance

- **Small footprint**: ~50KB total
- **No dependencies**: Pure Bash implementation
- **Fast execution**: < 100ms average
- **Memory efficient**: Minimal resource usage

## 🔐 Security

- No network connections
- No external downloads
- No user data collection
- All operations local to user's machine
- MIT Licensed - completely transparent

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## 📚 Documentation

- [CHANGELOG.md](CHANGELOG.md) - Version history and updates
- [LICENSE](LICENSE) - License information
- [config/nsf.conf](config/nsf.conf) - Configuration template

## 🙋 Support

### Getting Help
```bash
# View help
nsf --help

# See supported languages
nsf --list

# Preview a template
nsf --preview py
```

### Reporting Issues

Please report bugs at: https://github.com/Varenya-Sawant/nsf/issues

Include:
- Output of `nsf --version`
- Steps to reproduce the issue
- Expected vs actual behavior

## 🎉 Acknowledgments

NSF was created to simplify script creation and promote best practices in scripting across multiple languages.

---

**Made with ❤️ for developers everywhere**

# Verify
nsf --version
```

See [Installation Guide](docs/INSTALL.md) for detailed instructions.

### Basic Usage

```bash
# Create a new script
nsf my_script.py

# List available templates
nsf --list

# Preview a template
nsf --preview py

# Show help
nsf --help
```

See [Usage Guide](docs/USAGE.md) for complete documentation.

## 📁 Project Structure

```
nsf/
├── bin/
│   └── nsf                 # Main executable
├── lib/
│   ├── core.sh            # Core functionality
│   ├── templates.sh       # Template system
│   ├── logger.sh          # Logging & colors
│   ├── utils.sh           # Utilities
│   └── constants.sh       # Configuration
├── templates/             # Boilerplate templates
│   ├── bash.tmpl
│   ├── python.tmpl
│   ├── javascript.tmpl
│   ├── typescript.tmpl
│   ├── go.tmpl
│   ├── rust.tmpl
│   ├── ruby.tmpl
│   └── php.tmpl
├── config/
│   └── nsf.conf          # User configuration
├── docs/
│   ├── INSTALL.md        # Installation guide
│   ├── USAGE.md          # Usage documentation
│   └── CONTRIBUTING.md   # Contribution guidelines
├── tests/                 # Test suite
├── install.sh            # Installation script
├── uninstall.sh          # Uninstallation script
├── CHANGELOG.md          # Version history
├── LICENSE               # MIT License
└── README.md             # This file
```

## 🎯 Example Workflow

```bash
$ nsf data_processor.py
Using .py template
Creating py template...
✓ Template generated successfully
✓ File made executable
Add to git? (y/N): y
✓ Added to git

════════════════════════════════════════════════════════
✓ Script Created Successfully

  File:     /home/user/data_processor.py
  Language: py
  Author:   john
  Created:  2026-03-09
════════════════════════════════════════════════════════

Open with (1=Vim, 2=Nano, 3=Skip)? [3]: 1
# Vim opens with your new script
```

## 🔧 Commands

| Command | Description |
|---------|-------------|
| `nsf <filename>` | Create new script |
| `nsf --list` | List templates |
| `nsf --preview <ext>` | Preview template |
| `nsf --help` | Show help |
| `nsf --version` | Show version |
| `nsf --config` | Show configuration |
| `nsf --debug <file>` | Debug mode |

## 🛠️ Configuration

Edit `~/.local/nsf/config/nsf.conf`:

```bash
# Default author name
DEFAULT_AUTHOR="Your Name"

# Auto-make executable (true/false)
DEFAULT_MAKE_EXECUTABLE=true

# Auto git add (true/false)
ENABLE_GIT_INTEGRATION=true

# Show editor prompt (true/false)
ENABLE_EDITOR_SELECTION=true

# Input timeout seconds
TIMEOUT_SECONDS=5

# Date format
DEFAULT_DATE_FORMAT="%Y-%m-%d"
```

## 📦 Requirements

- **Bash 4.0+** (for associative arrays)
- **Unix/Linux/macOS** or WSL on Windows
- **Git** (optional, for git integration)
- **Vim/Nano** (optional, for editing)

## 🚀 Performance

| Metric | Value |
|--------|-------|
| Size | ~50KB |
| Load Time | <100ms |
| Memory Usage | ~2MB |
| CPU Usage | Minimal |

Lightweight and responsive - won't slow down your workflow.

## 📚 Documentation

- **[Installation Guide](docs/INSTALL.md)** - Setup instructions
- **[Usage Guide](docs/USAGE.md)** - Complete usage documentation
- **[Contributing Guide](docs/CONTRIBUTING.md)** - How to contribute
- **[Changelog](CHANGELOG.md)** - Version history

## 🤝 Contributing

We welcome contributions! Please:

1. Read [Contributing Guide](docs/CONTRIBUTING.md)
2. Fork the repository
3. Create a feature branch
4. Make your changes
5. Test thoroughly
6. Submit a pull request

## 🐛 Bug Reports

Found a bug? Please:

1. Check [existing issues](https://github.com/Varenya-Sawant/nsf/issues)
2. Provide OS, Bash version, and exact command
3. Include error message and expected behavior
4. Create detailed issue report

## ✨ Feature Requests

Have an idea? Please:

1. Check [existing issues](https://github.com/Varenya-Sawant/nsf/issues)
2. Describe the use case
3. Suggest implementation if possible
4. Open feature request issue

## 📄 License

This project is licensed under the **MIT License**.

See [LICENSE](LICENSE) for details.

## 👥 Authors & Contributors

- **Original Author** - Initial development
- **Contributors** - Community improvements

See [Changelog](CHANGELOG.md) for contribution history.

## 🙏 Acknowledgments

- Inspired by modern script scaffolding tools
- Community feedback and suggestions
- Open source contributors

## 📞 Support

### Getting Help

```bash
# View command help
nsf --help

# Show version
nsf --version

# List templates
nsf --list

# Debug mode
nsf --debug script.sh
```

### Resources

- 📖 [Documentation](docs/)
- 🐛 [Issue Tracker](https://github.com/Varenya-Sawant/nsf/issues)
- 💬 [Discussions](https://github.com/Varenya-Sawant/nsf/discussions)
- 📝 [Wiki](https://github.com/Varenya-Sawant/nsf/wiki)

## 🗺️ Roadmap

### v3.2
- [ ] C/C++ templates
- [ ] Java template
- [ ] Shell completion
- [ ] Template search

### v3.3
- [ ] GitHub integration
- [ ] Template marketplace
- [ ] Project scaffolding

### v4.0
- [ ] Go rewrite
- [ ] Web UI
- [ ] Plugin system

## 💡 Tips & Tricks

### Batch Creation

```bash
nsf script1.py script2.py script3.py
```

### Skip Configuration

```bash
ENABLE_GIT_INTEGRATION=false nsf script.sh
```

### Custom Author

```bash
DEFAULT_AUTHOR="Alice Smith" nsf script.py
```

### Shell Alias

```bash
alias newscript="nsf"
newscript app.js
```

## 🎓 Learning Resources

- **Shell Scripting** - See template examples
- **Best Practices** - Built-in code patterns
- **Error Handling** - See error_exit function
- **Architecture** - Modular library design

## 🔐 Security

- No external dependencies
- No network calls
- No data collection
- Local file operations only
- Open source for transparency

## ❤️ Show Your Support

- ⭐ Star this repository
- 🐛 Report bugs
- 💡 Suggest features
- 🙋 Contribute code
- 📢 Share with others

---

**Made with ❤️ for developers who value time and code quality.**

For more information, visit the [project homepage](https://github.com/Varenya-Sawant/nsf).

## Quick Links

| Link | Description |
|------|-------------|
| [Installation](docs/INSTALL.md) | How to install |
| [Usage](docs/USAGE.md) | How to use |
| [Contributing](docs/CONTRIBUTING.md) | How to contribute |
| [Changelog](CHANGELOG.md) | Version history |
| [License](LICENSE) | MIT License |

---

**Last Updated:** 2026-03-09  
**Current Version:** 3.1.0  
**Status:** ✅ Production Ready
