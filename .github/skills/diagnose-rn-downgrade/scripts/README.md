# React Native Downgrade Diagnostic Scripts

PowerShell scripts to help diagnose and fix React Native version downgrade issues.

## Scripts

### check-compatibility.ps1
Analyzes project configuration and identifies compatibility issues.

### clean-rebuild.ps1
Performs complete clean and rebuild with proper sequence.

### dependency-audit.ps1
Audits all dependencies against RN version compatibility matrix.

### fix-gradle-cache.ps1
Clears all Gradle caches (local and global) to resolve cache-related issues.

## Usage

Run from project root:

```powershell
# Check compatibility
.\.github\skills\diagnose-rn-downgrade\scripts\check-compatibility.ps1

# Clean and rebuild
.\.github\skills\diagnose-rn-downgrade\scripts\clean-rebuild.ps1

# Audit dependencies
.\.github\skills\diagnose-rn-downgrade\scripts\dependency-audit.ps1

# Fix Gradle cache issues
.\.github\skills\diagnose-rn-downgrade\scripts\fix-gradle-cache.ps1
```
