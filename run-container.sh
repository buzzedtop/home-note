#!/bin/bash
# Run script compatible with Docker, Podman, and other container runtimes

set -e

# Detect container runtime
if command -v podman &> /dev/null; then
    RUNTIME="podman"
elif command -v docker &> /dev/null; then
    RUNTIME="docker"
else
    echo "Error: No container runtime found. Please install Docker or Podman."
    exit 1
fi

echo "Using container runtime: $RUNTIME"

# Check if image exists
if ! $RUNTIME image exists home-note:latest 2>/dev/null; then
    echo "Image 'home-note:latest' not found. Building..."
    ./build-container.sh
fi

# Stop and remove existing container if running
if $RUNTIME ps -a --format "{{.Names}}" | grep -q "^home-note-app$"; then
    echo "Stopping existing container..."
    $RUNTIME stop home-note-app
    $RUNTIME rm home-note-app
fi

# Run the container
echo "Starting home-note container..."
$RUNTIME run -d \
    --name home-note-app \
    -p 8080:8080 \
    --restart unless-stopped \
    home-note:latest

if [ $? -eq 0 ]; then
    echo ""
    echo "Container started successfully!"
    echo ""
    echo "Access the application at http://localhost:8080"
    echo ""
    echo "To view logs:"
    echo "  $RUNTIME logs -f home-note-app"
    echo ""
    echo "To stop the container:"
    echo "  $RUNTIME stop home-note-app"
else
    echo ""
    echo "Failed to start container!"
    exit 1
fi
