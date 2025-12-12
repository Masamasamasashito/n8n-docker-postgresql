# Playwright Docker Two-Stage Build & Startup Script
# Usage: .\build-and-start.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Playwright Docker Two-Stage Startup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Build Playwright image
Write-Host "[Step 1/2] Building Playwright image..." -ForegroundColor Yellow
Write-Host "Duration: 5-15 min initially, seconds with cache" -ForegroundColor Gray
Write-Host ""

$buildStart = Get-Date
docker-compose build playwright

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Playwright build failed" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Check your network connection" -ForegroundColor Gray
    Write-Host "  2. View detailed logs with:" -ForegroundColor Gray
    Write-Host "     docker-compose build playwright --progress=plain" -ForegroundColor Cyan
    Write-Host "  3. Clear cache and retry:" -ForegroundColor Gray
    Write-Host "     docker-compose build --no-cache playwright" -ForegroundColor Cyan
    exit 1
}

$buildEnd = Get-Date
$buildDuration = $buildEnd - $buildStart

Write-Host ""
Write-Host "✅ Playwright build complete!" -ForegroundColor Green
Write-Host "   Duration: $($buildDuration.ToString('mm\:ss'))" -ForegroundColor Gray
Write-Host ""

# Step 2: Start all services
Write-Host "[Step 2/2] Starting all services..." -ForegroundColor Yellow
Write-Host ""

$startTime = Get-Date
docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Service startup failed" -ForegroundColor Red
    Write-Host ""
    Write-Host "Check logs:" -ForegroundColor Yellow
    Write-Host "  docker-compose logs" -ForegroundColor Cyan
    exit 1
}

$endTime = Get-Date
$startDuration = $endTime - $startTime

Write-Host ""
Write-Host "✅ All services started!" -ForegroundColor Green
Write-Host "   Duration: $($startDuration.ToString('mm\:ss'))" -ForegroundColor Gray
Write-Host ""

# Display service status
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Service Status" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker-compose ps

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Access URLs" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  n8n:        http://localhost:5678" -ForegroundColor Green
Write-Host "  Playwright: http://localhost:3000/healthz" -ForegroundColor Green
Write-Host "  SearXNG:    http://localhost:8080" -ForegroundColor Green
Write-Host ""

# Health check
Write-Host "Checking Playwright health..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/healthz" -TimeoutSec 5 -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Playwright is running" -ForegroundColor Green
    }
}
catch {
    Write-Host "⚠️  Playwright is still starting. Wait a few seconds and check again." -ForegroundColor Yellow
    Write-Host "   Check command: docker-compose logs -f playwright" -ForegroundColor Gray
}

Write-Host ""
Write-Host "🎉 Startup complete!" -ForegroundColor Cyan
