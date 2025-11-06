# Run script for Windows PowerShell
# Compatible with Docker, Podman, Finch, nerdctl, and other container runtimes

$ErrorActionPreference = "Stop"

# Detect container runtime
$runtime = $null
if (Get-Command podman -ErrorAction SilentlyContinue) {
    $runtime = "podman"
} elseif (Get-Command finch -ErrorAction SilentlyContinue) {
    $runtime = "finch"
} elseif (Get-Command nerdctl -ErrorAction SilentlyContinue) {
    $runtime = "nerdctl"
} elseif (Get-Command docker -ErrorAction SilentlyContinue) {
    $runtime = "docker"
} else {
    Write-Host "Error: No container runtime found." -ForegroundColor Red
    Write-Host "Please install one of: Docker, Podman, Finch, or Rancher Desktop"
    Write-Host "See CONTAINER_SETUP.md for installation instructions"
    exit 1
}

Write-Host "Using container runtime: $runtime" -ForegroundColor Green

# Check if image exists (different methods for different runtimes)
$imageExists = $false
if ($runtime -eq "finch" -or $runtime -eq "nerdctl") {
    $images = & $runtime images 2>$null
    if ($images -match "home-note.*latest") {
        $imageExists = $true
    }
} else {
    & $runtime image exists home-note:latest 2>$null
    if ($LASTEXITCODE -eq 0) {
        $imageExists = $true
    }
}

if (-not $imageExists) {
    Write-Host "Image 'home-note:latest' not found. Building..." -ForegroundColor Yellow
    .\build-container.ps1
}

# Stop and remove existing container if running
$containerExists = & $runtime ps -a --format "{{.Names}}" 2>$null | Select-String -Pattern "^home-note-app$" -Quiet
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
