# Contributing to NSF

Thank you for your interest in contributing to NSF! We appreciate all contributions, whether they're bug reports, feature suggestions, or code improvements.

## Code of Conduct

Please be respectful and constructive in all interactions. We're committed to providing a welcoming and inclusive environment for all contributors.

## Getting Started

### Prerequisites
- Bash 4.0 or higher
- Git
- Basic understanding of shell scripting

### Setting Up Your Development Environment

1. **Fork the repository**
   ```bash
   # Visit https://github.com/Varenya-Sawant/nsf and click "Fork"
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/nsf.git
   cd nsf
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make your changes**
   ```bash
   # Edit files, test thoroughly
   ```

5. **Test your changes**
   ```bash
   bash tests/test_nsf.sh
   ```

6. **Commit your changes**
   ```bash
   git commit -m "Add feature: description of changes"
   ```

7. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request**
   - Visit your fork on GitHub
   - Click "New Pull Request"
   - Provide a clear description of your changes

## Contribution Guidelines

### Code Style

- **Naming**: Use descriptive names for functions and variables
- **Comments**: Add comments for complex logic
- **Formatting**: Use consistent indentation (4 spaces)
- **Error Handling**: Always handle errors gracefully
- **Logging**: Use the logging functions from `logger.sh`

### Example Code Style

```bash
# Function naming: descriptive_verb
my_function() {
    local param1="$1"
    local param2="$2"
    
    # Validate inputs
    if [[ -z "$param1" ]]; then
        error_exit "param1 is required"
    fi
    
    # Do work
    local result
    result=$(some_operation "$param1") || return 1
    
    # Log and return
    debug "Function completed: $result"
    echo "$result"
}
```

### Commit Message Guidelines

Write clear, concise commit messages:

```
Add fix: Brief description (50 chars or less)

More detailed explanation if needed. Explain why this change is needed
and what problem it solves. Keep lines under 72 characters.

Fixes #123  # Reference related issues
```

### Types of Contributions

#### Bug Reports
```bash
Title: [BUG] Brief description

Environment:
- Bash version: (output of `bash --version`)
- OS: (Linux/macOS/WSL, etc.)
- NSF version: (output of `nsf --version`)

Steps to reproduce:
1. ...
2. ...
3. ...

Expected behavior:
- What should happen

Actual behavior:
- What actually happened

Error message:
- (if applicable, run with NSF_DEBUG=true for details)
```

#### Feature Requests
```bash
Title: [FEATURE] Brief description

Problem statement:
- Why is this needed?

Proposed solution:
- How should it work?

Alternatives considered:
- Other approaches?
```

### Adding New Language Support

If adding a new language template:

1. Add extension to `SUPPORTED_EXTENSIONS` in `constants.sh`
2. Create template function in `templates.sh`
3. Add test case in `tests/test_nsf.sh`
4. Update documentation in `README.md`
5. Update this guide with the new language

Example template structure:
```bash
# Add to constants.sh
declare -rA SUPPORTED_EXTENSIONS=(
    ...
    [ext]="Language Name"
)

# Add to templates.sh
get_template_language() {
    local author="$1"
    local date="$2"
    
    cat << 'EOF'
#!/usr/bin/env language

# Template content
# Author: AUTHOR
# Date: DATE

EOF
}

# Add to templates.sh get_template() switch
ext)
    get_template_language "$author" "$date"
    ;;
```

### Testing

Before submitting a pull request:

```bash
# Run full test suite
bash tests/test_nsf.sh

# Test specific functionality
NSF_DEBUG=true nsf test.py
```

### Documentation Updates

- Update README.md for user-facing changes
- Update CHANGELOG.md with your changes
- Add comments to complex code sections
- Update code examples if behavior changes

## Review Process

1. **Automated checks**: Tests must pass
2. **Code review**: Maintainers will review your changes
3. **Discussion**: We may ask questions or request changes
4. **Approval**: Once approved, your PR will be merged

## Release Process

Releases follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes

## Questions?

- Open an issue for questions
- Check existing issues for answers
- Review the documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thanks for contributing to NSF! 🎉
