# React Native Compatibility Checker
# Analyzes project configuration and identifies version mismatches

param(
    [string]$ProjectRoot = "."
)

Write-Host "🔍 React Native Compatibility Checker" -ForegroundColor Cyan
Write-Host ('=' * 60)

# Read package.json
$packageJson = Get-Content "$ProjectRoot\package.json" -Raw | ConvertFrom-Json
$rnVersion = $packageJson.dependencies.'react-native' -replace '\^|~', ''

Write-Host "`n📦 React Native Version: $rnVersion" -ForegroundColor Green

# Determine required versions based on RN version
$requirements = @{}
if ($rnVersion -match '^0\.71') {
    $requirements = @{
        Gradle = "7.5.1"
        AGP = "7.3.1"
        SDK = "31"
        Kotlin = "1.6.21"
        Java = "11 or 17"
    }
} elseif ($rnVersion -match '^0\.72') {
    $requirements = @{
        Gradle = "8.0.1"
        AGP = "7.4.2"
        SDK = "33"
        Kotlin = "1.7.22"
        Java = "17"
    }
} elseif ($rnVersion -match '^0\.73') {
    $requirements = @{
        Gradle = "8.3"
        AGP = "8.1.1"
        SDK = "34"
        Kotlin = "1.8.0"
        Java = "17"
    }
}

Write-Host "`n✅ Required Versions for RN $rnVersion" -ForegroundColor Yellow
$requirements.GetEnumerator() | ForEach-Object {
    Write-Host "   $($_.Key): $($_.Value)"
}

# Read Android build.gradle
$buildGradle = Get-Content "$ProjectRoot\android\build.gradle" -Raw

# Extract current versions
$currentSDK = if ($buildGradle -match 'compileSdkVersion\s*=?\s*(\d+)') { $matches[1] } else { "Not found" }
$currentKotlin = if ($buildGradle -match 'kotlinVersion\s*=\s*"([^"]+)"') { $matches[1] } else { "Not found" }
$currentAGP = if ($buildGradle -match 'com\.android\.tools\.build:gradle:([0-9.]+)') { $matches[1] } else { "Not found" }

# Read Gradle wrapper
$gradleWrapper = Get-Content "$ProjectRoot\android\gradle\wrapper\gradle-wrapper.properties" -Raw
$currentGradle = if ($gradleWrapper -match 'gradle-([0-9.]+)') { $matches[1] } else { "Not found" }

Write-Host "`n📊 Current Configuration" -ForegroundColor Cyan
Write-Host "   Gradle: $currentGradle" $(if ($currentGradle -eq $requirements.Gradle) { "(✅)" } else { "(❌ Should be $($requirements.Gradle))" })
Write-Host "   AGP: $currentAGP" $(if ($currentAGP -eq $requirements.AGP) { "(✅)" } else { "(❌ Should be $($requirements.AGP))" })
Write-Host "   SDK: $currentSDK" $(if ($currentSDK -eq $requirements.SDK) { "(✅)" } else { "(❌ Should be $($requirements.SDK))" })
Write-Host "   Kotlin: $currentKotlin" $(if ($currentKotlin -eq $requirements.Kotlin) { "(✅)" } else { "(❌ Should be $($requirements.Kotlin))" })

# Check high-risk dependencies
Write-Host "`n⚠️  High-Risk Dependencies (may need downgrade)" -ForegroundColor Yellow

$highRiskPackages = @{
    '@react-navigation/native' = '6.1.9'
    '@react-navigation/stack' = '6.3.20'
    'react-native-reanimated' = '3.0.2'
    'react-native-svg' = '13.4.0'
    'react-native-screens' = '3.20.0'
    'react-native-gesture-handler' = '2.9.0'
    '@react-native-google-signin/google-signin' = '10.1.1'
    'react-native-device-info' = '10.13.1'
}

$issues = @()
foreach ($pkg in $highRiskPackages.GetEnumerator()) {
    $installed = $packageJson.dependencies.($pkg.Key)
    if ($installed) {
        $installedClean = $installed -replace '\^|~', ''
        $recommended = $pkg.Value
        $major = ($installedClean -split '\.')[0]
        $recommendedMajor = ($recommended -split '\.')[0]
        
        if ([int]$major -gt [int]$recommendedMajor) {
            Write-Host "   ❌ $($pkg.Key): $installedClean (recommend ≤ $recommended)" -ForegroundColor Red
            $issues += $pkg.Key
        } else {
            Write-Host "   ✅ $($pkg.Key): $installedClean" -ForegroundColor Green
        }
    }
}

# Summary
Write-Host "`n"
Write-Host ('=' * 60)
if ($issues.Count -eq 0 -and $currentGradle -eq $requirements.Gradle -and $currentAGP -eq $requirements.AGP -and $currentSDK -eq $requirements.SDK) {
    Write-Host "✅ Configuration looks compatible!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Issues detected - see above for details" -ForegroundColor Yellow
    if ($issues.Count -gt 0) {
        Write-Host "`nConsider downgrading these packages:" -ForegroundColor Yellow
        foreach ($pkg in $issues) {
            Write-Host "   npm install $pkg --legacy-peer-deps"
        }
    }
}
