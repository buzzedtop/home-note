# Container Runtime Setup Guide

This guide covers setting up the Home Note application using various container runtimes, **without requiring Docker Desktop**.

## Container Runtime Options

### Recommended Options (No Docker Desktop Required)

1. **Podman** (Recommended for macOS, Linux, Windows)
   - Free and open source
   - Drop-in replacement for Docker
   - Rootless by default (more secure)
   - No daemon required

2. **OrbStack** (macOS only)
   - Fast and lightweight
   - Drop-in replacement for Docker Desktop
   - Free for personal use

3. **Rancher Desktop** (macOS, Linux, Windows)
   - Open source
   - Uses containerd or dockerd
   - Free for all uses

4. **Colima** (macOS only)
   - Lightweight alternative to Docker Desktop
   - Uses Lima VMs
   - Free and open source

---

## Installation Instructions

### Option 1: Podman (All Platforms) ⭐ RECOMMENDED

#### macOS
```bash
# Install via Homebrew
brew install podman

# Initialize and start Podman machine
podman machine init
podman machine start

# Verify installation
podman --version
podman ps
```

#### Windows
```powershell
# Install via Winget
winget install -e --id RedHat.Podman

# Or download from: https://podman.io/getting-started/installation

# Verify installation
podman --version
```

#### Linux (Ubuntu/Debian)
```bash
# Update package list
sudo apt-get update

# Install Podman
sudo apt-get -y install podman

# Verify installation
podman --version
```

#### Linux (Fedora/RHEL/CentOS)
```bash
# Install Podman
sudo dnf -y install podman

# Verify installation
podman --version
```

---

### Option 2: OrbStack (macOS only)

```bash
# Install via Homebrew
brew install orbstack

# Or download from: https://orbstack.dev

# Verify installation
docker --version  # OrbStack provides docker CLI
```

---

### Option 3: Rancher Desktop

Download from: https://rancherdesktop.io/

1. Download installer for your platform
2. Install and launch Rancher Desktop
3. Select container runtime (containerd recommended)
4. Verify: `docker --version` or `nerdctl --version`

---

### Option 4: Colima (macOS only)

```bash
# Install via Homebrew
brew install colima docker

# Start Colima
colima start

# Verify installation
docker --version
docker ps
```

---

## Building and Running Home Note

### Using Auto-Detection Scripts (Recommended)

The repository includes scripts that automatically detect your container runtime:

```bash
# Build the container image
./build-container.sh

# Run the container
./run-container.sh

# Access the app at http://localhost:8080
```

These scripts work with:
- Docker
- Podman
- OrbStack (uses Docker CLI)
- Rancher Desktop (uses Docker CLI)
- Colima (uses Docker CLI)

---

### Using Podman Directly

```bash
# Build the image
podman build -t home-note:latest .

# Run the container
podman run -d \
    --name home-note-app \
    -p 8080:8080 \
    home-note:latest

# View logs
podman logs -f home-note-app

# Stop the container
podman stop home-note-app

# Remove the container
podman rm home-note-app
```

---

### Using Podman Compose

```bash
# Install podman-compose (if not already installed)
pip3 install podman-compose

# Build and start
podman-compose -f podman-compose.yml up -d

# View logs
podman-compose -f podman-compose.yml logs -f

# Stop
podman-compose -f podman-compose.yml down
```

---

### Using Docker (if you have it)

```bash
# Using docker-compose
docker-compose up -d

# Or using docker directly
docker build -t home-note:latest .
docker run -d -p 8080:8080 --name home-note-app home-note:latest
```

---

## Platform-Specific Notes

### macOS (Apple Silicon M1/M2/M3)

All options work on Apple Silicon:

**Podman** (Recommended):
```bash
brew install podman
podman machine init --cpus 2 --memory 4096
podman machine start
```

**OrbStack** (Fastest):
- Native Apple Silicon support
- Fastest startup time
- Uses minimal resources

**Colima**:
```bash
brew install colima docker
colima start --cpu 2 --memory 4 --arch aarch64
```

### Windows (Without Docker Desktop)

**Podman** (Recommended):
1. Install from: https://podman.io/getting-started/installation
2. Run Podman Desktop for GUI (optional): https://podman-desktop.io/
3. Use PowerShell or Windows Terminal

**WSL2 with Podman**:
```bash
# In WSL2 Ubuntu
sudo apt-get update
sudo apt-get install -y podman
```

### Linux

**Podman** is the best choice on Linux:
- Native support
- Rootless by default
- No daemon required
- Better security

---

## Comparison Table

| Runtime | macOS | Windows | Linux | Free | GUI | Rootless |
|---------|-------|---------|-------|------|-----|----------|
| Podman | ✅ | ✅ | ✅ | ✅ | Optional | ✅ |
| OrbStack | ✅ | ❌ | ❌ | ✅* | ✅ | ✅ |
| Rancher Desktop | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Colima | ✅ | ❌ | ❌ | ✅ | ❌ | ✅ |
| Docker Desktop | ✅ | ✅ | ✅ | ❌** | ✅ | ❌ |

\* Free for personal use  
\** Requires license for commercial use in larger companies

---

## Troubleshooting

### Podman: "Cannot connect to Podman"

**macOS/Windows:**
```bash
# Start the Podman machine
podman machine start

# Check status
podman machine list
```

**Linux:**
```bash
# Start Podman service (if needed)
systemctl --user start podman.socket
```

### Port Already in Use

```bash
# Find process using port 8080
# macOS/Linux:
lsof -i :8080

# Windows:
netstat -ano | findstr :8080

# Use a different port
podman run -d -p 8081:8080 home-note:latest
```

### Permission Denied (Linux)

```bash
# Add your user to podman group (if exists)
sudo usermod -aG podman $USER

# Or run rootless (default for Podman)
podman run --rm -it -p 8080:8080 home-note:latest
```

### Image Build Fails

```bash
# Clear build cache
podman system prune -a

# Rebuild without cache
podman build --no-cache -t home-note:latest .
```

---

## Migrating from Docker Desktop

If you're migrating from Docker Desktop:

### 1. Export Existing Images (Optional)
```bash
# With Docker Desktop still installed
docker save home-note:latest -o home-note.tar

# Import to Podman
podman load -i home-note.tar
```

### 2. Use Alias (Optional)
Add to your `~/.bashrc`, `~/.zshrc`, or PowerShell profile:

```bash
# Make 'docker' command use Podman
alias docker=podman
alias docker-compose=podman-compose
```

### 3. Install New Runtime
Follow installation instructions above for your preferred runtime.

### 4. Uninstall Docker Desktop
- macOS: Drag Docker.app to Trash
- Windows: Use "Add or Remove Programs"
- Remove Docker CLI symlinks if needed

---

## Performance Tips

### Podman on macOS/Windows
```bash
# Allocate more resources to VM
podman machine stop
podman machine rm
podman machine init --cpus 4 --memory 8192 --disk-size 50
podman machine start
```

### Reduce Build Time
```bash
# Use BuildKit (if available)
export DOCKER_BUILDKIT=1  # For Docker/Colima
export BUILDAH_FORMAT=docker  # For Podman

# Build with cache
podman build --layers -t home-note:latest .
```

---

## Recommended Setup by Platform

### macOS (Apple Silicon)
1. **First choice**: OrbStack (fastest, easiest)
2. **Second choice**: Podman (most compatible)
3. **Third choice**: Colima (lightweight)

### macOS (Intel)
1. **First choice**: Podman
2. **Second choice**: Colima
3. **Third choice**: OrbStack

### Windows 11
1. **First choice**: Podman with Podman Desktop
2. **Second choice**: Rancher Desktop
3. **Third choice**: WSL2 + Podman

### Linux
1. **First choice**: Podman (native)
2. **Second choice**: Docker CE (if already installed)

---

## Additional Resources

- **Podman**: https://podman.io/
- **Podman Desktop**: https://podman-desktop.io/
- **OrbStack**: https://orbstack.dev/
- **Rancher Desktop**: https://rancherdesktop.io/
- **Colima**: https://github.com/abiosoft/colima

---

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Verify your container runtime is running: `podman ps` or `docker ps`
3. Check logs: `podman logs home-note-app`
4. Open an issue on GitHub with:
   - Your OS and version
   - Container runtime and version
   - Error messages and logs
