# Clean and Rebuild Script for React Native
# Performs thorough cleaning and rebuild to resolve cache issues

param(
    [switch]$NuclearOption = $false
)

$ErrorActionPreference = "Continue"

Write-Host "🧹 React Native Clean & Rebuild" -ForegroundColor Cyan
Write-Host ('=' * 60)

# Set Java 17
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
Write-Host "`n☕ Java: $env:JAVA_HOME"

# Stop Gradle daemon
Write-Host "`n🛑 Stopping Gradle daemon..." -ForegroundColor Yellow
Push-Location android
.\gradlew --stop
Pop-Location
Start-Sleep -Seconds 2

# Clean Android build artifacts
Write-Host "`n🗑️  Cleaning Android build artifacts..." -ForegroundColor Yellow
Remove-Item -Recurse -Force "android\.gradle" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "android\app\build" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "android\build" -ErrorAction SilentlyContinue
Write-Host "   ✅ Local Gradle cache cleared"

if ($NuclearOption) {
    Write-Host "`n☢️  NUCLEAR OPTION: Cleaning everything..." -ForegroundColor Red
    
    # Clear global Gradle cache
    Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle\caches" -ErrorAction SilentlyContinue
    Write-Host "   ✅ Global Gradle cache cleared"
    
    # Clear node_modules
    Remove-Item -Recurse -Force "node_modules" -ErrorAction SilentlyContinue
    Remove-Item -Force "package-lock.json" -ErrorAction SilentlyContinue
    Write-Host "   ✅ node_modules cleared"
    
    # Reinstall dependencies
    Write-Host "`n📦 Reinstalling dependencies..." -ForegroundColor Yellow
    npm install --legacy-peer-deps
    Write-Host "   ✅ Dependencies reinstalled"
}

# Gradle clean
Write-Host "`n🧼 Running Gradle clean..." -ForegroundColor Yellow
Push-Location android
.\gradlew clean
Pop-Location

# Build
Write-Host "`n🔨 Building Android app..." -ForegroundColor Yellow
Write-Host "This may take 3-5 minutes..." -ForegroundColor Gray

$buildStart = Get-Date
npx react-native run-android

$buildEnd = Get-Date
$duration = ($buildEnd - $buildStart).TotalMinutes

Write-Host "`n"
Write-Host ('=' * 60)
Write-Host "Build completed in $([math]::Round($duration, 2)) minutes" -ForegroundColor Cyan
Write-Host "Check above for any errors or warnings" -ForegroundColor Yellow
