# Dependency Audit for React Native Projects
# Checks installed versions against node_modules actual versions

Write-Host "📋 React Native Dependency Audit" -ForegroundColor Cyan
Write-Host ('=' * 60)

# Read package.json
$packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json
$dependencies = $packageJson.dependencies

Write-Host "`n🔍 Checking actual installed versions..." -ForegroundColor Yellow

$results = @()

foreach ($dep in $dependencies.PSObject.Properties) {
    $pkgName = $dep.Name
    $declaredVersion = $dep.Value
    
    $pkgJsonPath = "node_modules\$pkgName\package.json"
    
    if (Test-Path $pkgJsonPath) {
        $installedPkg = Get-Content $pkgJsonPath -Raw | ConvertFrom-Json
        $actualVersion = $installedPkg.version
        
        $declaredClean = $declaredVersion -replace '\^|~', ''
        
        $match = if ($actualVersion -eq $declaredClean) { "✅" } 
                 elseif ($actualVersion -like "$declaredClean*") { "⚠️" }
                 else { "❌" }
        
        $results += [PSCustomObject]@{
            Package = $pkgName
            Declared = $declaredVersion
            Installed = $actualVersion
            Status = $match
        }
    } else {
        $results += [PSCustomObject]@{
            Package = $pkgName
            Declared = $declaredVersion
            Installed = "NOT INSTALLED"
            Status = "❌"
        }
    }
}

# Display results
$results | Sort-Object Status | Format-Table -AutoSize

# Summary
$exact = ($results | Where-Object { $_.Status -eq "✅" }).Count
$similar = ($results | Where-Object { $_.Status -eq "⚠️" }).Count
$mismatch = ($results | Where-Object { $_.Status -eq "❌" }).Count

Write-Host "`n📊 Summary" -ForegroundColor Cyan
Write-Host "   ✅ Exact matches: $exact"
Write-Host "   ⚠️  Similar versions: $similar"
Write-Host "   ❌ Mismatches/Missing: $mismatch"

if ($mismatch -gt 0) {
    Write-Host "`n⚠️  Consider running: npm install --legacy-peer-deps" -ForegroundColor Yellow
}

# Check for known problematic versions
Write-Host "`n🚨 Checking for known problematic versions..." -ForegroundColor Yellow

$problematic = @{
    'react-native-reanimated' = @('3.10.0', '3.11.0', '3.12.0', '3.19.5')
    'react-native-svg' = @('13.14.0', '15.0.0')
    '@react-navigation/native' = @('7.0.0', '7.1.0', '7.2.0')
}

foreach ($pkg in $problematic.GetEnumerator()) {
    $installed = $results | Where-Object { $_.Package -eq $pkg.Key }
    if ($installed -and $pkg.Value -contains $installed.Installed) {
        Write-Host "   ⚠️  $($pkg.Key) v$($installed.Installed) may cause issues with RN 0.71" -ForegroundColor Red
    }
}

Write-Host "`n"
Write-Host ('=' * 60)
