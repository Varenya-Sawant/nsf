# UNIX PUSH QUICK REFERENCE

**Quick commands to run on your Unix VM before pushing**

```bash
# 1. Navigate to project
cd /path/to/nsf

# 2. Make all scripts executable
chmod +x bin/nsf lib/*.sh install.sh uninstall.sh tests/test_nsf.sh

# 3. Verify it works
./bin/nsf --version

# 4. Run quick test
bash tests/test_nsf.sh

# 5. Setup git locally (if not done yet)
git init
git config user.name "Varenya Sawant"
git config user.email "your.email@example.com"

# 6. Stage everything
git add .

# 7. Create initial commit
git commit -m "Initial commit: NSF v3.1.0 - Professional script file creator"

# 8. Add GitHub remote
git remote add origin https://github.com/Varenya-Sawant/nsf.git

# 9. Push to GitHub
git branch -M main
git push -u origin main

# Done! ✅
```

## If anything fails:

### Scripts not executable:
```bash
chmod +x bin/nsf lib/*.sh *.sh tests/*.sh
```

### Test nsf directly:
```bash
./bin/nsf test.py
```

### Check git status:
```bash
git status
```

### Verify files are tracked:
```bash
git ls-files
```

### View commit log:
```bash
git log
```

---

**That's it! You're done!** 🚀
