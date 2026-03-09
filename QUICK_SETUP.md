# Unix Setup - Copy & Paste Commands

**Run these commands in order on your Unix machine**

---

## Phase 1: Setup Directory & Transfer Files

```bash
# 1. Create NSF directory in home
mkdir -p ~/.local/nsf
cd ~/.local/nsf

# 2. Copy all NSF files here
# (If using scp from Windows machine:)
# scp -r C:\Users\YourName\nsf\* username@unix-server:~/.local/nsf/

# 3. Verify files are there
ls -la
# Should show: bin/ lib/ config/ docs/ tests/ plus .md and .sh files
```

---

## Phase 2: Make Scripts Executable

```bash
cd ~/.local/nsf

# Make all scripts executable
chmod +x bin/nsf
chmod +x lib/*.sh
chmod +x install.sh uninstall.sh
chmod +x tests/test_nsf.sh

# Verify (should show 'x' in output)
ls -la bin/nsf
ls -la lib/
```

---

## Phase 3: Test Locally

```bash
cd ~/.local/nsf

# Test 1: Version
./bin/nsf --version

# Test 2: Help
./bin/nsf --help

# Test 3: List languages
./bin/nsf --list

# Test 4: Create a test script
./bin/nsf test_script.sh

# Test 5: Check what was created
ls -la test_script.sh
cat test_script.sh | head -10

# Test 6: Clean up test
rm test_script.sh

# Test 7: Run full test suite
bash tests/test_nsf.sh
```

---

## Phase 4: Add to PATH (Choose ONE)

### **Option A: Edit .bashrc (Simplest)**

```bash
# 1. Open your shell config
nano ~/.bashrc

# 2. Go to END of file (Ctrl+End or hold Down arrow)

# 3. Add this line:
export PATH="$HOME/.local/nsf/bin:$PATH"

# 4. Save: Ctrl+O, then Enter, then Ctrl+X

# 5. Reload
source ~/.bashrc

# 6. Test from home directory
cd ~
nsf --version
# Should work! ✅
```

### **Option B: Use symlink (Fastest)**

```bash
# One command does it all
sudo ln -s ~/.local/nsf/bin/nsf /usr/local/bin/nsf

# Test
nsf --version
```

---

## Phase 5: Setup Configuration

```bash
# Create config directory
mkdir -p ~/.config/nsf

# Copy template
cp ~/.local/nsf/config/nsf.conf ~/.config/nsf/

# (Optional) Edit config
# nano ~/.config/nsf/nsf.conf
```

---

## Phase 6: Verify Everything Works

```bash
# Test from HOME directory
cd ~

# Run these
nsf --version
nsf --help
nsf --list
nsf --preview sh

# Create a real script
nsf demo.py
ls -la demo.py
cat demo.py | head -20

# Clean up
rm demo.py

echo "✅ Everything is working!"
```

---

## Phase 7: Push to GitHub

```bash
cd ~/.local/nsf

# Initialize git
git init

# Configure git (use your actual email)
git config user.name "Varenya Sawant"
git config user.email "your.email@example.com"

# Add all files
git add .

# Create first commit
git commit -m "Initial commit: NSF v3.1.0 - Advanced script creator"

# Add GitHub remote
git remote add origin https://github.com/Varenya-Sawant/nsf.git

# Push to GitHub
git branch -M main
git push -u origin main

# Verify it's on GitHub
# Visit: https://github.com/Varenya-Sawant/nsf
```

---

## ⚡ Quick Summary

```bash
# 1. Create dir and enter
mkdir -p ~/.local/nsf && cd ~/.local/nsf

# 2. Make scripts executable
chmod +x bin/nsf lib/*.sh install.sh uninstall.sh tests/test_nsf.sh

# 3. Test
./bin/nsf --version

# 4. Add to PATH
echo 'export PATH="$HOME/.local/nsf/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc

# 5. Test from anywhere
cd ~ && nsf --version

# 6. Push to GitHub
git init
git config user.name "Varenya Sawant"
git config user.email "your@email.com"
git add .
git commit -m "Initial commit: NSF v3.1.0"
git remote add origin https://github.com/Varenya-Sawant/nsf.git
git push -u origin main
```

---

## 🆘 Common Issues

**"nsf: command not found"**
```bash
# Fix: Make sure PATH is updated
source ~/.bashrc
echo $PATH | grep nsf  # Should show path
```

**"Permission denied"**
```bash
# Fix: They need execute permission
chmod +x ~/.local/nsf/bin/nsf
```

**"Failed to load config"**
```bash
# Fix: Create config directory
mkdir -p ~/.config/nsf
cp ~/.local/nsf/config/nsf.conf ~/.config/nsf/
```

---

**You're ready! Follow Phase 1-7 in order.** 🚀
