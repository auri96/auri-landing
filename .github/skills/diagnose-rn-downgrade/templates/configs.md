# React Native Configuration Templates

Proven, tested configurations for different React Native versions.

## React Native 0.71.x (Firebase Compatible)

### android/build.gradle
```groovy
buildscript {
    ext {
        buildToolsVersion = "31.0.0"
        minSdkVersion = 21
        compileSdkVersion = 31
        targetSdkVersion = 31
        kotlinVersion = "1.6.21"
        ndkVersion = "23.1.7779620"
    }
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.3.1")
        classpath("com.facebook.react:react-native-gradle-plugin")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
        // For Firebase
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

### android/gradle.properties
```properties
org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m -Xss4m
android.useAndroidX=true
android.enableJetifier=true
newArchEnabled=false
hermesEnabled=true
reactNativeArchitectures=armeabi-v7a,arm64-v8a,x86,x86_64
org.gradle.configureondemand=false
```

### android/gradle/wrapper/gradle-wrapper.properties
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5.1-all.zip
```

### package.json (compatible dependencies)
```json
{
  "dependencies": {
    "react": "18.2.0",
    "react-native": "0.71.19",
    "@react-native-firebase/app": "^17.5.0",
    "@react-native-firebase/messaging": "^17.5.0",
    "@react-navigation/native": "^6.1.9",
    "@react-navigation/stack": "^6.3.20",
    "@react-native-async-storage/async-storage": "^1.19.0",
    "@react-native-clipboard/clipboard": "^1.11.2",
    "@react-native-community/blur": "^4.3.2",
    "@react-native-community/datetimepicker": "^7.6.2",
    "@react-native-google-signin/google-signin": "^10.1.1",
    "axios": "^1.6.0",
    "jail-monkey": "^2.8.5",
    "react-native-config": "^1.5.1",
    "react-native-device-info": "^10.13.1",
    "react-native-gesture-handler": "^2.9.0",
    "react-native-keychain": "^8.2.0",
    "react-native-linear-gradient": "^2.8.3",
    "react-native-reanimated": "3.0.2",
    "react-native-safe-area-context": "^4.5.0",
    "react-native-screens": "^3.20.0",
    "react-native-skeleton-placeholder": "^5.2.4",
    "react-native-svg": "^13.4.0",
    "react-native-vector-icons": "^10.0.3",
    "sanitize-html": "^2.11.0"
  },
  "devDependencies": {
    "@babel/core": "^7.20.0",
    "@babel/preset-env": "^7.20.0",
    "@babel/runtime": "^7.20.0",
    "@react-native-community/cli": "^10.0.0",
    "@react-native-community/cli-platform-android": "^10.0.0",
    "@react-native-community/cli-platform-ios": "^10.0.0",
    "@react-native-community/eslint-config": "^3.2.0",
    "@testing-library/jest-native": "^5.4.3",
    "@testing-library/react-native": "^12.0.0",
    "@tsconfig/react-native": "^2.0.2",
    "@types/jest": "^29.2.1",
    "@types/react": "^18.0.24",
    "@types/react-test-renderer": "^18.0.0",
    "babel-jest": "^29.2.1",
    "eslint": "^8.19.0",
    "jest": "^29.2.1",
    "metro-react-native-babel-preset": "0.73.10",
    "prettier": "^2.4.1",
    "react-test-renderer": "18.2.0",
    "typescript": "^4.8.4"
  }
}
```

## React Native 0.72.x

### android/build.gradle
```groovy
buildscript {
    ext {
        buildToolsVersion = "33.0.0"
        minSdkVersion = 21
        compileSdkVersion = 33
        targetSdkVersion = 33
        kotlinVersion = "1.7.22"
        ndkVersion = "23.1.7779620"
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.4.2")
        classpath("com.facebook.react:react-native-gradle-plugin")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

### android/gradle/wrapper/gradle-wrapper.properties
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.0.1-all.zip
```

## Common Issues & Solutions

### StackOverflowError
**Cause**: Circular dependencies in Gradle resolution
**Solution**: Increase stack size in gradle.properties
```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=1024m -Xss16m
```

### AndroidX version conflicts
**Cause**: Modern dependencies require newer androidx than available
**Solution**: Force specific versions in root build.gradle
```groovy
subprojects {
    configurations.all {
        resolutionStrategy {
            force 'androidx.core:core:1.9.0'
            force 'androidx.lifecycle:lifecycle-runtime:2.5.1'
        }
    }
}
```

### Manifest merger failures
**Cause**: Placeholder values not defined
**Solution**: Replace placeholders with actual values in AndroidManifest.xml
```xml
<!-- Change this: -->
android:usesCleartextTraffic="${usesCleartextTraffic}"

<!-- To this: -->
android:usesCleartextTraffic="true"
```

### react-native-reanimated issues
**Cause**: Version too new for RN version
**Solution**: Use exact version without ^
```json
"react-native-reanimated": "3.0.2"
```

Add to babel.config.js:
```javascript
module.exports = {
  presets: ['module:metro-react-native-babel-preset'],
  plugins: ['react-native-reanimated/plugin'],
};
```
