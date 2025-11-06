# Build script for Windows PowerShell
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
Write-Host ""
Write-Host "Building Home Note container image..."

& $runtime build -t home-note:latest .

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Build successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To run the application:"
    Write-Host "  $runtime run -p 8080:8080 home-note:latest"
    Write-Host ""
    Write-Host "Or use the run script:"
    Write-Host "  .\run-container.ps1"
    Write-Host ""
    if ($runtime -eq "docker") {
        Write-Host "Or use docker-compose:"
        Write-Host "  docker-compose up -d"
    } elseif ($runtime -eq "podman") {
        Write-Host "Or use podman-compose:"
        Write-Host "  podman-compose -f podman-compose.yml up -d"
    }
    Write-Host ""
    Write-Host "Access the application at http://localhost:8080"
} else {
    Write-Host ""
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}
