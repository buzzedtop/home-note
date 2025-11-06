# Architecture Documentation

## Overview
Home Note is a Flutter web application for managing notes with drag-and-drop reordering capabilities. The application is designed with future extensibility in mind for database integration and Python processing.

## Application Structure

### Components

#### 1. Main UI (`lib/main.dart`)
- **MyApp**: Root application widget with Material Design theme
- **MyHomePage**: Main page with stateful management
- **Note Model**: Data structure for note items with JSON serialization

#### 2. Features

##### Input Section
- Multi-line text field for paragraph input
- Add button to create new notes
- Input validation (non-empty check)

##### Notes List
- ReorderableListView for drag-and-drop functionality
- Each note displays:
  - Drag handle icon
  - Note content
  - Up arrow button (disabled for first item)
  - Down arrow button (disabled for last item)
  - Delete button (red)

##### Storage
- **Web Platform**: Uses browser's localStorage for persistent storage
- **Mobile/Desktop**: Uses JSON file via path_provider package
- Data format: JSON array of note objects

### Data Model

```json
[
  {
    "id": "1699281234567",
    "content": "This is a note"
  },
  {
    "id": "1699281234568",
    "content": "Another note"
  }
]
```

Each note has:
- `id`: Unique timestamp-based identifier
- `content`: The note text

## File Structure

```
home-note/
├── lib/
│   └── main.dart           # Main application code
├── test/
│   └── widget_test.dart    # Widget and unit tests
├── web/
│   ├── index.html          # Web entry point
│   ├── manifest.json       # PWA manifest
│   └── icons/              # App icons
├── pubspec.yaml            # Dependencies and project config
├── Dockerfile              # Container definition
├── docker-compose.yml      # Container orchestration
├── nginx.conf              # Web server config
└── README.md               # User documentation
```

## Docker Deployment

The application uses a multi-stage Docker build:

1. **Build Stage**: Uses `cirrusci/flutter:stable` to compile Flutter web app
2. **Runtime Stage**: Uses `nginx:alpine` to serve the built application

The container exposes port 8080 and can be deployed with:
```bash
docker-compose up -d
```

## Future Enhancements

### Database Integration
The JSON storage format is designed for easy migration to a database:
- Add database connector (PostgreSQL, MySQL, MongoDB, etc.)
- Replace file/localStorage operations with database queries
- Keep the Note model structure for compatibility

### Python Processing
The architecture supports Python integration:
- Expose REST API endpoints for note CRUD operations
- Python scripts can process notes via API calls
- Use message queues (RabbitMQ, Redis) for async processing
- Example use cases:
  - NLP analysis of note content
  - Automated categorization
  - Content summarization
  - Action extraction

### Recommended Architecture for Production

```
┌─────────────┐
│  Flutter    │
│  Web App    │
│  (Port 8080)│
└──────┬──────┘
       │
       │ REST API
       │
┌──────▼──────┐
│   Backend   │
│   API       │
│  (FastAPI/  │
│   Flask)    │
└──────┬──────┘
       │
       ├─────────┐
       │         │
┌──────▼──────┐  │
│  Database   │  │
│ (PostgreSQL)│  │
└─────────────┘  │
                 │
          ┌──────▼──────┐
          │   Python    │
          │  Processing │
          │   Workers   │
          └─────────────┘
```

## Development Guidelines

### Adding New Features
1. Update the Note model if data structure changes
2. Modify storage methods to handle new fields
3. Update UI components as needed
4. Add tests for new functionality
5. Update documentation

### Code Style
- Follow Flutter/Dart style guidelines
- Use const constructors where possible
- Handle errors gracefully with user feedback
- Maintain responsive design principles

## Testing

Run tests with:
```bash
flutter test
```

Current test coverage:
- Widget rendering tests
- Note addition functionality
- JSON serialization/deserialization
- UI element verification
