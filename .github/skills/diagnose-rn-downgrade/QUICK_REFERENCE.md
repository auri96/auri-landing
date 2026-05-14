# Quick Reference: React Native Downgrade

## 🚨 Common Errors & Solutions

### StackOverflowError during Gradle build

```
CAUSE: Circular dependency resolution in Gradle
FIX: Increase stack size in android/gradle.properties
```

```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=1024m -Xss16m
```

---

### Failed to transform android.jar

```
CAUSE: AGP/Gradle/SDK version mismatch
FIX: Align versions for your RN version
```

**RN 0.71.x:**
- Gradle: 7.5.1
- AGP: 7.3.1
- SDK: 31

---

### Manifest merger failed

```
CAUSE: Placeholder not defined (e.g., ${usesCleartextTraffic})
FIX: Replace with actual value in AndroidManifest.xml
```

```xml
<!-- Before -->
android:usesCleartextTraffic="${usesCleartextTraffic}"

<!-- After -->
android:usesCleartextTraffic="true"
```

---

### androidx.core:core:1.16.0 requires SDK 35

```
CAUSE: Modern dependency pulling new AndroidX
FIX: Downgrade the dependency or force older AndroidX
```

Check which package is pulling it:
```bash
cd android
./gradlew :app:dependencies | grep androidx.core
```

---

### react-native-reanimated 3.19.5 installed instead of 3.0.2

```
CAUSE: npm interpreted ^3.0.2 as "latest 3.x"
FIX: Use exact version without ^
```

```json
"react-native-reanimated": "3.0.2"
```

Then:
```bash
rm -rf node_modules/react-native-reanimated
npm install --legacy-peer-deps
```

---

## 📋 Version Matrix

| React Native | Gradle  | AGP   | SDK | Kotlin | Java  |
|--------------|---------|-------|-----|--------|-------|
| 0.71.x       | 7.5.1   | 7.3.1 | 31  | 1.6.21 | 11/17 |
| 0.72.x       | 8.0.1   | 7.4.2 | 33  | 1.7.22 | 17    |
| 0.73.x       | 8.3     | 8.1.1 | 34  | 1.8.0  | 17    |

---

## 🎯 Compatible Dependencies for RN 0.71.x

```json
{
  "react": "18.2.0",
  "react-native": "0.71.19",
  "@react-navigation/native": "^6.1.9",      // NOT 7.x
  "@react-navigation/stack": "^6.3.20",      // NOT 7.x
  "react-native-reanimated": "3.0.2",        // exact, no ^
  "react-native-svg": "^13.4.0",             // NOT 13.14+
  "react-native-screens": "^3.20.0",         // NOT 4.x
  "react-native-safe-area-context": "^4.5.0", // NOT 5.x
  "react-native-gesture-handler": "^2.9.0",  // NOT 2.30.x
  "@react-native-google-signin/google-signin": "^10.1.1", // NOT 16.x
  "react-native-device-info": "^10.13.1",    // NOT 15.x
  "@react-native-firebase/app": "^17.5.0",
  "@react-native-firebase/messaging": "^17.5.0"
}
```

---

## ⚡ Quick Commands

### Check what's installed
```bash
npm list --depth=0
```

### Check actual version in node_modules
```bash
cat node_modules/package-name/package.json | grep version
```

### Gradle dependency tree
```bash
cd android
./gradlew :app:dependencies --configuration debugCompileClasspath
```

### Find AndroidX conflicts
```bash
cd android
./gradlew :app:dependencies | grep androidx
```

### Nuclear clean
```bash
# Stop Gradle
cd android && ./gradlew --stop && cd ..

# Clean everything
rm -rf android/.gradle android/app/build android/build node_modules package-lock.json

# Reinstall
npm install --legacy-peer-deps

# Clean build
cd android && ./gradlew clean && cd ..

# Build
npx react-native run-android
```

---

## 🔧 Essential Files to Check

1. **package.json** - Dependency versions
2. **android/build.gradle** - SDK, AGP, Kotlin versions
3. **android/gradle.properties** - Build settings, memory, flags
4. **android/gradle/wrapper/gradle-wrapper.properties** - Gradle version
5. **android/app/build.gradle** - App config, dependencies

---

## 🚀 Invoke Tools

### Agent
```
@rn-downgrade-stabilizer [describe issue]
```

### Skill
```
/diagnose-rn-downgrade
```

### Scripts
```powershell
# Check compatibility
.\.github\skills\diagnose-rn-downgrade\scripts\check-compatibility.ps1

# Audit dependencies
.\.github\skills\diagnose-rn-downgrade\scripts\dependency-audit.ps1

# Clean & rebuild
.\.github\skills\diagnose-rn-downgrade\scripts\clean-rebuild.ps1

# Nuclear clean
.\.github\skills\diagnose-rn-downgrade\scripts\clean-rebuild.ps1 -NuclearOption

# Fix Gradle cache
.\.github\skills\diagnose-rn-downgrade\scripts\fix-gradle-cache.ps1 -IncludeGlobal
```

---

## 💊 When Nothing Works

1. **Verify Java version**
   ```bash
   java -version  # Should be 11 or 17 for RN 0.71
   ```

2. **Check JAVA_HOME**
   ```bash
   echo $JAVA_HOME  # Should point to JDK 11 or 17
   ```

3. **Clear EVERYTHING**
   ```bash
   rm -rf node_modules package-lock.json
   rm -rf android/.gradle android/app/build android/build
   rm -rf ~/.gradle/caches  # Nuclear option
   npm install --legacy-peer-deps
   ```

4. **Verify file structure matches working project**
   - Compare against firebaseTest or templates

5. **Ask the agent**
   ```
   @rn-downgrade-stabilizer He probado todo y aún falla con [error]
   ```

---

## 📚 Resources

- **Templates**: `.github/skills/diagnose-rn-downgrade/templates/configs.md`
- **Full Docs**: `.github/skills/diagnose-rn-downgrade/README.md`
- **Agent**: `.github/agents/rn-downgrade-stabilizer.agent.md`
