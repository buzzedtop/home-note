#!/bin/bash

# Build script for Home Note application

echo "Building Home Note Docker image..."
docker build -t home-note:latest .

if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo ""
    echo "To run the application:"
    echo "  docker run -p 8080:8080 home-note:latest"
    echo ""
    echo "Or use docker-compose:"
    echo "  docker-compose up -d"
    echo ""
    echo "Access the application at http://localhost:8080"
else
    echo "Build failed!"
    exit 1
fi
