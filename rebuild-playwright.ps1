# Rebuild & Restart Playwright Only
# Usage: .\rebuild-playwright.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Playwright Rebuild & Restart" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Option: Complete rebuild without cache
$noCache = $false
if ($args -contains "--no-cache") {
    $noCache = $true
    Write-Host "⚠️  Performing complete rebuild without cache" -ForegroundColor Yellow
    Write-Host ""
}

# Step 1: Stop existing container
Write-Host "[Step 1/3] Stopping Playwright container..." -ForegroundColor Yellow
docker-compose stop playwright

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to stop container" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Stopped" -ForegroundColor Green
Write-Host ""

# Step 2: Rebuild image
Write-Host "[Step 2/3] Rebuilding Playwright image..." -ForegroundColor Yellow

if ($noCache) {
    Write-Host "Duration: 5-15 minutes (no cache)" -ForegroundColor Gray
    docker-compose build --no-cache playwright
}
else {
    Write-Host "Duration: seconds to minutes (with cache)" -ForegroundColor Gray
    docker-compose build playwright
}

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Build failed" -ForegroundColor Red
    Write-Host ""
    Write-Host "View detailed logs:" -ForegroundColor Yellow
    Write-Host "  docker-compose build playwright --progress=plain" -ForegroundColor Cyan
    exit 1
}

Write-Host "✅ Build complete" -ForegroundColor Green
Write-Host ""

# Step 3: Restart container
Write-Host "[Step 3/3] Starting Playwright container..." -ForegroundColor Yellow
docker-compose up -d playwright

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Startup failed" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Started" -ForegroundColor Green
Write-Host ""

# Display logs
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Startup Logs (Last 10 Lines)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker-compose logs --tail=10 playwright

Write-Host ""
Write-Host "To view real-time logs:" -ForegroundColor Gray
Write-Host "  docker-compose logs -f playwright" -ForegroundColor Cyan
Write-Host ""

# Health check
Write-Host "Checking health..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/healthz" -TimeoutSec 5 -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Playwright is running" -ForegroundColor Green
        Write-Host "   URL: http://localhost:3000/healthz" -ForegroundColor Gray
    }
}
catch {
    Write-Host "⚠️  Still starting. Wait a few seconds and check again." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 Rebuild & restart complete!" -ForegroundColor Cyan
