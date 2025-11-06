# home-note
A simple Flutter application designed to track notes with drag-and-drop reordering

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
```bash
# Build the Docker image
docker build -t home-note .

# Run the container on port 8080
docker run -p 8080:8080 home-note
```

Access the application at `http://localhost:8080`

## Future Enhancements
- Database connection for persistent storage
- Python processing integration for content transformation
- Advanced note features (categories, search, etc.)

## Documentation
- **[Getting Started Guide](GETTING_STARTED.md)**: Detailed setup and usage instructions
- **[Architecture Documentation](ARCHITECTURE.md)**: Technical design and implementation details
- **[UI Design](UI_DESIGN.md)**: Interface layout and interaction patterns
- **[Python Example](example_processor.py)**: Sample script for note processing
