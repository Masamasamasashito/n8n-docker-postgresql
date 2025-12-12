# 🚀 Docker Compose Two-Stage Startup Guide

## 📋 Overview

Building the Playwright container takes time (5-15 minutes initially), so we use a two-stage startup process for reliable control.

---

## ⚡ Quick Start (Normal Usage)

If the Playwright image is already built:

```powershell
docker-compose up -d
```

---

## 🔨 Two-Stage Startup Procedure (Initial Setup or Image Update)

### Step 1: Build Playwright First

```powershell
# Build only the Playwright image (other services won't start)
docker-compose build playwright
```

**Duration**: 5-15 minutes initially, seconds on subsequent builds (cached)

**Verification**:
```powershell
# Check if the image was created
docker images | Select-String "playwright"
```

### Step 2: Start All Services

```powershell
# Start all services (Playwright is already built)
docker-compose up -d
```

**Duration**: 10-30 seconds (Playwright starts instantly)

---

## 🛠️ Useful Commands

### Rebuild & Restart Playwright Only

```powershell
# Build and start in one command
docker-compose up -d --build playwright
```

### Start Other Services Excluding Playwright

```powershell
# Start without Playwright
docker-compose up -d postgres redis searxng n8n
```

### Monitor Build Progress

```powershell
# Show real-time build logs
docker-compose build playwright --progress=plain
```

### Check Playwright Logs

```powershell
# Real-time logs
docker-compose logs -f playwright

# Last 100 lines
docker-compose logs --tail=100 playwright
```

---

## 📊 Scenario-Based Guide

### Scenario 1: Initial Setup

```powershell
# 1. Build Playwright first (coffee break ☕)
docker-compose build playwright

# 2. Start all services
docker-compose up -d
```

### Scenario 2: After Dockerfile Changes

```powershell
# 1. Rebuild Playwright only
docker-compose build playwright

# 2. Restart Playwright only
docker-compose up -d playwright
```

### Scenario 3: After server.js Changes

```powershell
# Rebuild & restart (fast with Docker cache)
docker-compose up -d --build playwright
```

### Scenario 4: Playwright Version Update

```powershell
# 1. Complete rebuild without cache
docker-compose build --no-cache playwright

# 2. Restart
docker-compose up -d playwright
```

---

## 🎯 Health Check Verification

Verify all services started correctly:

```powershell
# Check service status
docker-compose ps

# Playwright health check
curl http://localhost:3000/healthz
```

Expected output:
```json
{"status":"ok"}
```

---

## ⚠️ Troubleshooting

### Playwright Build is Slow

**Cause**: Browser downloads (~400MB) take time

**Solution**:
1. Use a better network connection
2. Monitor progress with `--progress=plain`

```powershell
docker-compose build playwright --progress=plain
```

### Build Hangs

**Cause**: Timeout or network error

**Solution**:
```powershell
# Clear build cache and retry
docker-compose build --no-cache playwright
```

### Old Images Remain

**Solution**:
```powershell
# Remove unused images
docker image prune -f

# Completely remove Playwright image and rebuild
docker-compose down
docker rmi n8n-docker-postgresql-playwright
docker-compose build playwright
```

---

## 💡 Best Practices

1. **Use two-stage startup initially**: Build Playwright first, then start all services
2. **Monitor logs**: Use `docker-compose logs -f playwright` to track build progress
3. **Leverage cache**: `docker-compose build` completes in seconds if Dockerfile unchanged
4. **Regular cleanup**: Use `docker system prune` to remove unused images

---

## 📝 Environment Variables (.env)

Playwright-related environment variables:

```env
# Playwright container port
DOCKER_HOST_PORT_PLAYWRIGHT=3000
PLAYWRIGHT_CONTAINER_LISTEN_PORT=3000

# Playwright volume name
PLAYWRIGHT_VOLUME_NAME=ecwPlaywrightDataVolume
```
