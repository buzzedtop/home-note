# Run script for Windows PowerShell
# Compatible with Docker, Podman, and other container runtimes

$ErrorActionPreference = "Stop"

# Detect container runtime
$runtime = $null
if (Get-Command podman -ErrorAction SilentlyContinue) {
    $runtime = "podman"
} elseif (Get-Command docker -ErrorAction SilentlyContinue) {
    $runtime = "docker"
} else {
    Write-Host "Error: No container runtime found." -ForegroundColor Red
    Write-Host "Please install one of: Docker, Podman, or Rancher Desktop"
    Write-Host "See CONTAINER_SETUP.md for installation instructions"
    exit 1
}

Write-Host "Using container runtime: $runtime" -ForegroundColor Green

# Check if image exists
$imageExists = & $runtime image exists home-note:latest 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Image 'home-note:latest' not found. Building..." -ForegroundColor Yellow
    .\build-container.ps1
}

# Stop and remove existing container if running
$containerExists = & $runtime ps -a --format "{{.Names}}" | Select-String -Pattern "^home-note-app$" -Quiet
if ($containerExists) {
    Write-Host "Stopping existing container..." -ForegroundColor Yellow
    & $runtime stop home-note-app
    & $runtime rm home-note-app
}

# Run the container
Write-Host "Starting home-note container..."
& $runtime run -d `
    --name home-note-app `
    -p 8080:8080 `
    --restart unless-stopped `
    home-note:latest

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Container started successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Access the application at http://localhost:8080"
    Write-Host ""
    Write-Host "To view logs:"
    Write-Host "  $runtime logs -f home-note-app"
    Write-Host ""
    Write-Host "To stop the container:"
    Write-Host "  $runtime stop home-note-app"
} else {
    Write-Host ""
    Write-Host "Failed to start container!" -ForegroundColor Red
    exit 1
}
