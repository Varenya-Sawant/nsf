# NSF Setup Guide for Unix - Step by Step

**Goal**: Transform the advanced NSF tool into a working command on your Unix system

---

## 📋 What You're Going From → To

### **Before (Simple Version)**
```bash
nsf name              # Simple command
# → Check overwrite
# → Ask permission
# → Add shebang
# → Make executable
# → Done
```

### **Now (Advanced Version)**
```bash
nsf script.py         # Advanced with 9 languages
nsf --help            # Full help
nsf --version         # Version info
nsf --list            # List templates
nsf --preview py      # Preview templates
nsf --config          # Show configuration
nsf --debug app.sh    # Debug mode
```

---

## 🎯 STEP 1: Prepare Your Unix Machine

### 1.1 Check Your Shell
```bash
# What shell are you using?
echo $SHELL

# NSF requires bash 4.0+
bash --version
```

**If you don't have bash 4.0+**, update it:
```bash
# macOS
brew install bash

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install bash

# CentOS/RHEL
sudo yum install bash
```

### 1.2 Create NSF Directory
```bash
# Create a directory for NSF (choose one location)

# Option A: System-wide (recommended)
sudo mkdir -p /usr/local/nsf
cd /usr/local/nsf

# Option B: User home directory
mkdir -p ~/.local/nsf
cd ~/.local/nsf

# Option C: Custom location
mkdir -p ~/projects/nsf
cd ~/projects/nsf
```

**We'll use `~/.local/nsf` for this guide (user installation, no sudo needed)**

---

## 🎯 STEP 2: Transfer Files to Unix

### 2.1 Copy NSF Project
```bash
# From your Windows machine to Unix
# Use scp or copy files manually

mkdir -p ~/.local/nsf
cd ~/.local/nsf

# If using scp from Windows:
# scp -r d:\nsf\* user@unix-machine:~/.local/nsf/

# Or copy each directory:
# Copy bin/ lib/ config/ docs/ tests/ and all .md, .sh files
```

### 2.2 Verify Structure
```bash
# Check everything is there
cd ~/.local/nsf
ls -la

# Should see:
# bin/
# lib/
# config/
# tests/
# docs/
# *.md files
# *.sh files
```

---

## 🎯 STEP 3: Make Scripts Executable

**IMPORTANT**: On Unix, scripts need executable permission!

```bash
cd ~/.local/nsf

# Make main script executable
chmod +x bin/nsf

# Make all library scripts executable
chmod +x lib/*.sh

# Make installer executable
chmod +x install.sh uninstall.sh

# Make test script executable
chmod +x tests/test_nsf.sh

# Verify permissions
ls -la bin/nsf
ls -la lib/

# Should see 'x' in permissions: -rwxr-xr-x
```

---

## 🎯 STEP 4: Test Locally First

### 4.1 Run From Directory
```bash
cd ~/.local/nsf

# Test version
./bin/nsf --version
# Should output: NSF - New Script File Creator, Version 3.1.0

# Test help
./bin/nsf --help
# Should show help message with all options

# Test list
./bin/nsf --list
# Should list all 9 supported languages
```

### 4.2 Test Script Creation
```bash
cd ~/.local/nsf

# Create a test script
./bin/nsf test_script.sh
# Should create test_script.sh with bash template

# Verify it was created
ls -la test_script.sh

# Check the content
head -20 test_script.sh
# Should see proper shebang and structure

# Clean up
rm test_script.sh
```

### 4.3 Run Test Suite
```bash
cd ~/.local/nsf

# Run all tests
bash tests/test_nsf.sh

# Should show test results with colors
```

---

## 🎯 STEP 5: Add to PATH

**Goal**: Use `nsf` command from anywhere

### Option A: User PATH (No sudo needed) ⭐ RECOMMENDED

```bash
# 1. Check your shell config
echo $SHELL

# 2. Edit your shell configuration file
# If bash: ~/.bashrc
# If zsh: ~/.zshrc

nano ~/.bashrc
# OR
nano ~/.zshrc

# 3. Add this line at the END of the file
export PATH="$HOME/.local/nsf/bin:$PATH"

# 4. Save and exit (Ctrl+O, Enter, Ctrl+X for nano)

# 5. Reload shell config
source ~/.bashrc
# OR
source ~/.zshrc

# 6. Verify NSF is in PATH
echo $PATH
# Should include $HOME/.local/nsf/bin

# 7. Test from anywhere
cd ~
nsf --version
# Should work! ✅
```

### Option B: System PATH (Requires sudo)

```bash
# 1. Create symlink in /usr/local/bin
sudo ln -s ~/.local/nsf/bin/nsf /usr/local/bin/nsf

# 2. Verify
nsf --version
# Should work from anywhere ✅
```

### Option C: Install Using Script (Automated)

```bash
cd ~/.local/nsf

# Make installer executable
chmod +x install.sh

# Run installer (choose option)
# For user installation
./install.sh --user

# For system installation (uses sudo)
./install.sh --system

# Verify
nsf --version
```

---

## 🎯 STEP 6: Create Configuration

```bash
# Create config directory
mkdir -p ~/.config/nsf

# Copy config template
cp ~/.local/nsf/config/nsf.conf ~/.config/nsf/

# Edit configuration (optional)
nano ~/.config/nsf/nsf.conf

# Customize these (uncomment and edit):
# NSF_AUTHOR="Your Name"
# NSF_EDITOR="vim"        (or nano, emacs, etc.)
# NSF_DATE_FORMAT="%Y-%m-%d"
```

---

## 🎯 STEP 7: Test the Complete Setup

### 7.1 Test From Home Directory
```bash
cd ~

# Test basic commands
nsf --help
nsf --version
nsf --list
nsf --preview py
nsf --config
```

### 7.2 Create a Real Script
```bash
# Create a new script
nsf my_script.py

# Or any supported language
nsf deploy.sh
nsf server.js
nsf main.go
nsf app.rb

# Check they were created
ls -la my_script.py

# Test the created script
bash deploy.sh
python3 my_script.py  # (with code, otherwise error is OK)
```

### 7.3 Verify All Features
```bash
# 1. Version
nsf --version

# 2. Help
nsf --help

# 3. List templates
nsf --list

# 4. Preview (choose any language)
nsf --preview sh
nsf --preview py

# 5. Configuration
nsf --config

# 6. Debug mode
nsf --debug test.sh

# 7. Create scripts in different directories
mkdir ~/test_nsf
cd ~/test_nsf
nsf script.js
nsf app.go
ls -la
```

---

## 🎯 STEP 8: Verify Everything Works

```bash
# Run complete test suite
bash ~/.local/nsf/tests/test_nsf.sh

# Expected output:
# ✓ All tests passed
# Tests run: 14+
# Tests passed: 14+
# Tests failed: 0
```

---

## 📝 Comparison: Simple vs Advanced

### **Simple Version (What You Had)**
```bash
nsf name
# ↓ Check overwrite
# ↓ Ask permission  
# ↓ Add shebang (bash only!)
# ↓ Make executable
# ✓ Done
```

### **Advanced Version (What You Have Now)**
```
nsf script.py              ← 9 languages!
nsf --help                 ← Full help
nsf --version              ← Version info
nsf --list                 ← See templates
nsf --preview py           ← Preview before create
nsf --config               ← Show settings
nsf --debug app.sh         ← Debug mode

Plus:
✓ Configuration system
✓ Professional templates
✓ Error handling
✓ Logging system
✓ Complete documentation
✓ Test suite
```

---

## 🐛 Troubleshooting

### "nsf: command not found"
```bash
# Problem: Not in PATH
# Solution:

# 1. Check PATH
echo $PATH

# 2. Check if .bashrc has the export
cat ~/.bashrc | grep PATH

# 3. Reload shell
source ~/.bashrc

# 4. Test
nsf --version
```

### "Permission denied"
```bash
# Problem: Scripts not executable
# Solution:

chmod +x ~/.local/nsf/bin/nsf
chmod +x ~/.local/nsf/lib/*.sh

# Verify
ls -la ~/.local/nsf/bin/nsf
# Should show: -rwxr-xr-x
```

### "Failed to load constants"
```bash
# Problem: Library files not found
# Solution: Check directory structure

# Verify these exist:
ls ~/.local/nsf/lib/constants.sh
ls ~/.local/nsf/lib/logger.sh
ls ~/.local/nsf/lib/utils.sh
ls ~/.local/nsf/lib/templates.sh
ls ~/.local/nsf/lib/core.sh

# If missing, recopy the files
```

### "Failed to create template"
```bash
# Problem: Config directory missing
# Solution:

mkdir -p ~/.config/nsf
cp ~/.local/nsf/config/nsf.conf ~/.config/nsf/
```

---

## ✅ Verification Checklist

Before moving to GitHub, verify:

```bash
# 1. Scripts are executable
ls -la ~/.local/nsf/bin/nsf
# Should show: -rwxr-xr-x ... bin/nsf

# 2. Can run from anywhere
cd ~
nsf --version
# Should work ✅

# 3. Can create scripts
nsf test.py
cat test.py | head -5
# Should show proper template ✅

# 4. Help works
nsf --help
# Should show help ✅

# 5. List works
nsf --list
# Should show 9 languages ✅

# 6. Preview works
nsf --preview js
# Should show JavaScript template ✅

# 7. Tests pass
bash ~/.local/nsf/tests/test_nsf.sh
# Should show all tests passed ✅
```

---

## 🚀 Next: Push to GitHub

Once everything works locally:

```bash
cd ~/.local/nsf

# Initialize git (if not done)
git init

# Configure git
git config user.name "Varenya Sawant"
git config user.email "your.email@example.com"

# Add all files
git add .

# Commit
git commit -m "Initial commit: NSF v3.1.0 - Advanced script creator tool"

# Add GitHub remote
git remote add origin https://github.com/Varenya-Sawant/nsf.git

# Push
git branch -M main
git push -u origin main
```

---

## 📚 Quick Reference

```bash
# Setup
mkdir -p ~/.local/nsf
chmod +x ~/.local/nsf/bin/nsf ~/.local/nsf/lib/*.sh

# Add to PATH
echo 'export PATH="$HOME/.local/nsf/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Test
nsf --version
nsf --help
nsf test.py

# Push
git init
git add .
git commit -m "Initial: NSF v3.1.0"
git remote add origin https://github.com/Varenya-Sawant/nsf.git
git push -u origin main
```

---

**You're now ready to use NSF on your Unix machine!** 🎉

Any issues? Check the troubleshooting section above.
