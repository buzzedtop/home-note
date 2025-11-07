#!/bin/bash
# Build script for Home Note application
# Compatible with Docker, Podman, and other container runtimes

set -e

# Detect container runtime
if command -v podman &> /dev/null; then
    RUNTIME="podman"
elif command -v docker &> /dev/null; then
    RUNTIME="docker"
else
    echo "Error: No container runtime found."
    echo "Please install one of: Docker, Podman, OrbStack, Rancher Desktop, or Colima"
    echo "See CONTAINER_SETUP.md for installation instructions"
    exit 1
fi

echo "Using container runtime: $RUNTIME"
echo ""
echo "Building Home Note container image..."

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
    if [ "$RUNTIME" = "docker" ]; then
        echo "Or use docker-compose:"
        echo "  docker-compose up -d"
    elif [ "$RUNTIME" = "podman" ]; then
        echo "Or use podman-compose:"
        echo "  podman-compose -f podman-compose.yml up -d"
    fi
    echo ""
    echo "Access the application at http://localhost:8080"
else
    echo ""
    echo "Build failed!"
    exit 1
fi
