#!/bin/bash
# Build script compatible with Docker, Podman, and other container runtimes

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
echo ""

# Build the image
echo "Building home-note container image..."
$RUNTIME build -t home-note:latest .

if [ $? -eq 0 ]; then
    echo ""
    echo "Build successful!"
    echo ""
    echo "To run the application:"
    echo "  $RUNTIME run -p 8080:8080 home-note:latest"
    echo ""
    echo "Or use the run script:"
    echo "  ./run-container.sh"
    echo ""
    echo "Access the application at http://localhost:8080"
else
    echo ""
    echo "Build failed!"
    exit 1
fi
