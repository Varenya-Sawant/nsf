# nsf — New Script File

Stop typing this every time:

```bash
touch script
echo '#!/usr/bin/env bash' > script
chmod +x script
```

Just run:

```bash
nsf script
```

Done.

---

## What is nsf?

`nsf` is a tiny Unix utility that creates an executable Bash script with a proper shebang — instantly.

No boilerplate. No repetition. No nonsense.

---

## Features

- Adds `#!/usr/bin/env bash`
- Makes the file executable
- Prevents overwriting existing files
- Lightweight and dependency-free
- Works on Linux and macOS

---

## Installation

### Global (recommended)

```bash
git clone https://github.com/Varenya-Sawant/nsf.git
cd nsf
chmod +x bin/nsf
sudo mv bin/nsf /usr/local/bin/

```

### Local (no sudo)

```bash
git clone https://github.com/Varenya-Sawant/nsf.git
cd nsf
mkdir -p ~/bin
cp bin/nsf ~/bin/
chmod +x ~/bin/nsf
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

```

---

## Usage

Create a new script:

```bash
nsf mytool
```

That’s it.

Open it:

```bash
nano mytool
```

It already contains:

```bash
#!/usr/bin/env bash
```

Now write your logic and run:

```bash
./mytool
```

---

## Why?

Because small tools should remove small friction.

`nsf` exists to make shell scripting effortless.

---



