# Fix Gradle Cache Issues
# Clears all Gradle caches to resolve stubborn build problems

param(
    [switch]$IncludeGlobal = $false
)

Write-Host "🧹 Gradle Cache Cleaner" -ForegroundColor Cyan
Write-Host ('=' * 60)

$ErrorActionPreference = "Continue"

# Set Java 17
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot"
Write-Host "`n☕ Using Java: $env:JAVA_HOME"

# Stop all Gradle daemons
Write-Host "`n🛑 Stopping Gradle daemons..." -ForegroundColor Yellow
Push-Location android
.\gradlew --stop
Pop-Location

$stopped = $?
if ($stopped) {
    Write-Host "   ✅ Gradle daemons stopped" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  No daemons were running" -ForegroundColor Yellow
}

Start-Sleep -Seconds 3

# Clear local project caches
Write-Host "`n🗑️  Clearing local Gradle caches..." -ForegroundColor Yellow

$localPaths = @(
    "android\.gradle",
    "android\app\build",
    "android\build"
)

foreach ($path in $localPaths) {
    if (Test-Path $path) {
        Remove-Item -Recurse -Force $path -ErrorAction SilentlyContinue
        Write-Host "   ✅ Deleted: $path" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  Not found: $path" -ForegroundColor Gray
    }
}

# Clear global Gradle cache (optional)
if ($IncludeGlobal) {
    Write-Host "`n☢️  Clearing GLOBAL Gradle cache..." -ForegroundColor Red
    Write-Host "   This will affect all projects on your system!" -ForegroundColor Yellow
    
    $globalCache = "$env:USERPROFILE\.gradle\caches"
    if (Test-Path $globalCache) {
        $size = (Get-ChildItem $globalCache -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
        Write-Host "   Cache size: $([math]::Round($size, 2)) MB" -ForegroundColor Gray
        
        Remove-Item -Recurse -Force $globalCache -ErrorAction SilentlyContinue
        Write-Host "   ✅ Global cache cleared" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  No global cache found" -ForegroundColor Gray
    }
    
    # Also clear build service cache
    $buildService = "$env:USERPROFILE\.gradle\daemon"
    if (Test-Path $buildService) {
        Remove-Item -Recurse -Force $buildService -ErrorAction SilentlyContinue
        Write-Host "   ✅ Build service cache cleared" -ForegroundColor Green
    }
}

# Verify clean state
Write-Host "`n✅ Verification" -ForegroundColor Cyan
Write-Host "   Local .gradle: $(if (Test-Path 'android\.gradle') { '❌ Still exists' } else { '✅ Cleared' })"
Write-Host "   Local build: $(if (Test-Path 'android\build') { '❌ Still exists' } else { '✅ Cleared' })"
Write-Host "   App build: $(if (Test-Path 'android\app\build') { '❌ Still exists' } else { '✅ Cleared' })"

if ($IncludeGlobal) {
    Write-Host "   Global cache: $(if (Test-Path "$env:USERPROFILE\.gradle\caches") { '❌ Still exists' } else { '✅ Cleared' })"
}

Write-Host "`n"
Write-Host ('=' * 60)
Write-Host "✅ Cache cleaning complete!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "   1. cd android"
Write-Host "   2. .\gradlew clean"
Write-Host "   3. cd .."
Write-Host "   4. npx react-native run-android"

if (-not $IncludeGlobal) {
    Write-Host "`nℹ️  To clear global Gradle cache, run:" -ForegroundColor Yellow
    Write-Host "   .\fix-gradle-cache.ps1 -IncludeGlobal" -ForegroundColor Gray
}
