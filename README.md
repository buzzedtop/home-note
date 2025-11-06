# home-note
A simple Flutter application designed to track notes with drag-and-drop reordering

## Features
- Add notes with a paragraph text field
- List view of all notes
- Drag and drop reordering
- Up/Down arrow buttons for reordering
- Delete button for each note
- Persistent storage using JSON files
- Web support with containerization

## Storage
Notes are stored in a JSON file (`notes.json`) for easy access and future database migration. The JSON format allows for easy processing with Python scripts and database integration.

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
