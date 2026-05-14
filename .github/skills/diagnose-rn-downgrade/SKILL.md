---
name: diagnose-rn-downgrade
description: "Diagnose React Native downgrade issues — USE WHEN: analyzing build failures after RN downgrade, checking dependency compatibility, generating compatibility reports, auditing package versions, identifying AndroidX conflicts, troubleshooting Gradle errors"
---

# React Native Downgrade Diagnostics

You are a diagnostic expert for React Native version downgrades. Your job is to analyze the current state of a project and identify all compatibility issues.

## Diagnostic Process

### 1. Gather Project Information

Read these files in order:
1. `package.json` → React Native version and all dependencies
2. `android/build.gradle` → SDK, AGP, Gradle, Kotlin versions
3. `android/gradle/wrapper/gradle-wrapper.properties` → Gradle version
4. `android/gradle.properties` → Build settings
5. `android/app/build.gradle` → App-specific configuration

### 2. Version Analysis

Compare installed versions against compatibility requirements:

**React Native 0.71.x requires:**
- Gradle: 7.5.1
- Android Gradle Plugin: 7.3.1
- compileSdk: 31
- targetSdk: 31
- Kotlin: 1.6.21
- Java: 11 or 17

**React Native 0.72.x requires:**
- Gradle: 8.0.1
- Android Gradle Plugin: 7.4.2
- compileSdk: 33
- targetSdk: 33
- Kotlin: 1.7.22

**React Native 0.73.x requires:**
- Gradle: 8.3
- Android Gradle Plugin: 8.1.1
- compileSdk: 34
- targetSdk: 34
- Kotlin: 1.8.0

### 3. Dependency Audit

Check each dependency in `package.json` against known compatibility:

**High-Risk Packages (often incompatible after downgrade):**
- `@react-navigation/*` → Version 7.x requires RN 0.73+
- `react-native-reanimated` → Version 3.10+ may require newer RN
- `react-native-svg` → Version 13.14+ requires RN 0.73+
- `react-native-screens` → Version 4.x requires RN 0.73+
- `react-native-gesture-handler` → Version 2.20+ may have issues
- `@react-native-google-signin/google-signin` → Version 13+ requires newer SDK
- `react-native-device-info` → Version 13+ requires newer SDK

### 4. AndroidX Conflict Detection

Look for these indicators:
- Build errors mentioning `androidx.core:core:1.13.0` or higher
- Errors about `androidx.lifecycle` requiring SDK 33+
- "compileSdkVersion" mismatch errors
- AGP version incompatibility warnings

### 5. Generate Report

Create a structured report with:

```markdown
## React Native Downgrade Compatibility Report

### Current Configuration
- React Native: [version]
- Gradle: [version]
- AGP: [version]
- compileSdk: [version]
- targetSdk: [version]

### Issues Detected

#### Critical Issues (prevents build)
1. [Issue description]
   - Current: [current value]
   - Required: [required value]
   - Fix: [specific action]

#### Warnings (may cause runtime issues)
1. [Warning description]
   - Impact: [what could break]
   - Recommendation: [action]

### Required Changes

#### package.json
```json
{
  "dependency-name": "required-version",
  ...
}
```

#### android/build.gradle
```groovy
compileSdkVersion = XX
...
```

#### android/gradle.properties
```properties
key=value
```

### Execution Plan

1. **Backup**: Create backup of package.json and android/ folder
2. **Clean**: Remove node_modules, package-lock.json, android/.gradle
3. **Update Dependencies**: Apply package.json changes
4. **Install**: npm install --legacy-peer-deps
5. **Update Android Config**: Apply build.gradle changes
6. **Clean Build**: gradlew clean
7. **Build**: npx react-native run-android
8. **Verify**: Test core app functionality
```

## Tools Usage

Use these diagnostic commands:

```bash
# Check installed package versions
npm list --depth=0

# Gradle dependency tree
cd android && ./gradlew :app:dependencies --configuration debugCompileClasspath

# Find specific dependency version
cat node_modules/[package]/package.json | grep version

# Check for AndroidX conflicts
cd android && ./gradlew :app:dependencies | grep androidx.core
```

## Output Format

Always provide:
1. **Current State Summary**: What's currently configured
2. **Compatibility Analysis**: What's wrong and why
3. **Change Checklist**: Exact changes needed with file paths
4. **Risk Assessment**: What could break, what's safe
5. **Rollback Plan**: How to undo if things go wrong

## Validation

After generating report:
- Verify all version numbers are exact (not ranges)
- Ensure all referenced files exist in project
- Check that fixes are compatible with each other
- Confirm no circular dependency issues in proposed changes
