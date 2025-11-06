# Getting Started with Home Note

This guide will help you get the Home Note application up and running.

## Prerequisites

### For Container Deployment (Recommended)

Choose one of these container runtimes (**Docker Desktop NOT required**):

- **Podman** (Recommended - works on all platforms)
- **OrbStack** (macOS only - fastest)
- **Rancher Desktop** (all platforms)
- **Colima** (macOS only)
- **Docker** (if you already have it)

See **[Container Setup Guide](CONTAINER_SETUP.md)** for detailed installation instructions.

### For Local Development
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- A web browser (Chrome recommended)

## Quick Start with Containers

### Option 1: Using Auto-Detection Scripts (Easiest) ⭐

Works with Docker, Podman, OrbStack, Rancher Desktop, and Colima:

```bash
# Clone the repository
git clone https://github.com/buzzedtop/home-note.git
cd home-note

# Build the container image (auto-detects runtime)
./build-container.sh

# Run the application (auto-detects runtime)
./run-container.sh
```

Access the application at: http://localhost:8080

### Option 2: Using Docker/Podman Compose

```bash
# With Docker Compose
docker-compose up -d

# With Podman Compose
podman-compose -f podman-compose.yml up -d

# View logs
docker-compose logs -f
# or
podman-compose logs -f

# Stop the application
docker-compose down
# or
podman-compose down
```

### Option 3: Using Docker/Podman CLI

```bash
# Build the image
docker build -t home-note:latest .
# or
podman build -t home-note:latest .

# Run the container
docker run -d -p 8080:8080 --name home-note home-note:latest
# or
podman run -d -p 8080:8080 --name home-note home-note:latest

# View logs
docker logs -f home-note
# or
podman logs -f home-note

# Stop and remove
docker stop home-note
docker rm home-note
```

## Local Development Setup

### 1. Install Flutter

Follow the official Flutter installation guide for your OS:
- **Windows**: https://docs.flutter.dev/get-started/install/windows
- **macOS**: https://docs.flutter.dev/get-started/install/macos
- **Linux**: https://docs.flutter.dev/get-started/install/linux

Verify installation:
```bash
flutter doctor
```

### 2. Get Dependencies

```bash
cd home-note
flutter pub get
```

### 3. Run the Application

#### Web (Recommended for this project)
```bash
# Run in Chrome
flutter run -d chrome

# Or build for production
flutter build web
```

#### Mobile Simulators
```bash
# List available devices
flutter devices

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android
```

#### Desktop
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## Development Workflow

### 1. Making Code Changes

The main application code is in `lib/main.dart`. After making changes:

```bash
# Hot reload (press 'r' in the terminal)
# or
# Hot restart (press 'R' in the terminal)
```

### 2. Running Tests

```bash
flutter test
```

### 3. Code Analysis

```bash
flutter analyze
```

### 4. Formatting Code

```bash
flutter format lib/
```

## Project Structure

```
home-note/
├── lib/
│   └── main.dart              # Main application code
├── test/
│   └── widget_test.dart       # Tests
├── web/
│   ├── index.html             # Web entry point
│   ├── manifest.json          # PWA manifest
│   └── icons/                 # App icons
├── pubspec.yaml               # Dependencies
├── Dockerfile                 # Container definition
├── docker-compose.yml         # Docker orchestration
└── README.md                  # This file
```

## Using the Application

### Adding Notes
1. Type your note in the text field at the top
2. Click the "Add" button or press Enter
3. Your note appears in the list below

### Reordering Notes

**Method 1: Drag and Drop**
- Click and hold the ≡ icon on the left
- Drag the note to desired position
- Release to drop

**Method 2: Arrow Buttons**
- Click ↑ to move note up
- Click ↓ to move note down

### Deleting Notes
- Click the 🗑 (trash) icon on the right

### Data Persistence
- Notes are automatically saved
- Data persists across browser sessions (web)
- Data persists across app restarts (mobile/desktop)

## Storage Location

### Web
- Browser's localStorage
- Key: `notes`
- Format: JSON string

### Mobile/Desktop
- SharedPreferences
- Location varies by platform:
  - **iOS**: NSUserDefaults
  - **Android**: SharedPreferences XML
  - **Windows**: Registry or local file
  - **macOS**: NSUserDefaults
  - **Linux**: Local file

### Exporting Data

To export your notes (web):
```javascript
// Open browser console (F12) and run:
console.log(localStorage.getItem('notes'));
// Copy the output
```

## Troubleshooting

### Docker Issues

**Problem**: Port 8080 already in use
```bash
# Use a different port
docker run -p 8081:8080 home-note:latest
```

**Problem**: Build fails
```bash
# Clear Docker cache and rebuild
docker system prune -a
docker build --no-cache -t home-note:latest .
```

### Flutter Issues

**Problem**: Dependencies not resolving
```bash
flutter pub cache repair
flutter clean
flutter pub get
```

**Problem**: Web build fails
```bash
# Ensure web support is enabled
flutter config --enable-web
flutter create .
```

**Problem**: Hot reload not working
```bash
# Do a hot restart instead
# Press 'R' in the terminal
```

## Advanced Configuration

### Changing the Port (Docker)

Edit `nginx.conf`:
```nginx
server {
    listen 8081;  # Change port here
    # ...
}
```

Update `Dockerfile`:
```dockerfile
EXPOSE 8081  # Change port here
```

Update `docker-compose.yml`:
```yaml
ports:
  - "8081:8081"  # Change host port here
```

### Custom Theme

Edit `lib/main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,  // Change color here
  ),
  useMaterial3: true,
),
```

### Adding More Fields to Notes

1. Update the `Note` class in `lib/main.dart`
2. Update `toJson()` and `fromJson()` methods
3. Update UI to display new fields
4. Clear existing storage or migrate data

## Python Integration (Future)

See `example_processor.py` for an example of how to process notes with Python.

Basic workflow:
1. Export notes from the app
2. Process with Python script
3. Import back to app

Future API integration:
```python
import requests

# Get notes
response = requests.get('http://localhost:8080/api/notes')
notes = response.json()

# Process notes
processed = process_notes(notes)

# Update notes
requests.put('http://localhost:8080/api/notes', json=processed)
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `flutter test`
5. Submit a pull request

## Support

For issues and questions:
- Check existing GitHub issues
- Create a new issue with detailed description
- Include logs and error messages

## License

This project is open source and available under the MIT License.
