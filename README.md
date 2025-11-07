# home-note

[![Flutter CI/CD](https://github.com/buzzedtop/home-note/actions/workflows/flutter-ci-cd.yml/badge.svg)](https://github.com/buzzedtop/home-note/actions/workflows/flutter-ci-cd.yml)
[![PR Testing](https://github.com/buzzedtop/home-note/actions/workflows/pr-testing.yml/badge.svg)](https://github.com/buzzedtop/home-note/actions/workflows/pr-testing.yml)

A simple Flutter application designed to track notes with drag-and-drop reordering

🚀 **[Live Demo](https://buzzedtop.github.io/home-note/)** - Try it now on GitHub Pages!

## Features
- Add notes with a paragraph text field
- List view of all notes
- Drag and drop reordering (touch and mouse support)
- Up/Down arrow buttons for manual reordering
- Delete button for each note
- Persistent storage using shared_preferences
- Cross-platform support (Web, iOS, Android, Desktop)
- Docker containerization for web deployment
- Python processing examples for future integration

## Storage
Notes are stored using `shared_preferences` which provides cross-platform persistent storage. The data is stored in JSON format for easy access and future database migration. This approach allows for:
- Web: Browser localStorage
- Mobile: Native platform storage (SharedPreferences/NSUserDefaults)
- Desktop: Platform-appropriate storage
- Easy processing with Python scripts
- Simple database integration in the future

## Running the Application

### Local Development
```bash
# Get dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Build for web
flutter build web
```

### Docker Deployment

**Using Auto-Detection Scripts (Recommended):**
```bash
# Works with Docker, Podman, Finch, nerdctl, OrbStack, Rancher Desktop, Colima, Lima
./build-container.sh
./run-container.sh
```

**Using Docker/Podman/Finch directly:**
```bash
# Build the image
docker build -t home-note .
# Or with Podman
podman build -t home-note .
# Or with Finch (AWS)
finch build -t home-note .
# Or with Lima + nerdctl
lima nerdctl build -t home-note .

# Run the container on port 8080
docker run -p 8080:8080 home-note
# Or with Podman
podman run -p 8080:8080 home-note
```

**Using Docker Compose / Podman Compose:**
```bash
docker-compose up -d
# Or
podman-compose -f podman-compose.yml up -d
```

Access the application at `http://localhost:8080`

📦 **[Container Setup Guide](CONTAINER_SETUP.md)**: Setup without Docker Desktop (Podman, OrbStack, Rancher Desktop, Colima)

## Future Enhancements
- Database connection for persistent storage
- Python processing integration for content transformation
- Advanced note features (categories, search, etc.)

## Documentation
- **[Getting Started Guide](GETTING_STARTED.md)**: Detailed setup and usage instructions
- **[Architecture Documentation](ARCHITECTURE.md)**: Technical design and implementation details
- **[UI Design](UI_DESIGN.md)**: Interface layout and interaction patterns
- **[Deployment Guide](DEPLOYMENT.md)**: GitHub Actions CI/CD and GitHub Pages setup
- **[Python Example](example_processor.py)**: Sample script for note processing
