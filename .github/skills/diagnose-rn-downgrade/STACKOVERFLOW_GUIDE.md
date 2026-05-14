# StackOverflowError Troubleshooting Guide

## Síntoma

```
BUILD FAILED
java.lang.StackOverflowError
    at org.gradle.execution.plan.FinalizerGroup.isCanCancel(FinalizerGroup.java:XX)
    at org.gradle.execution.plan.CompositeNodeGroup.isCanCancel(CompositeNodeGroup.java:XX)
    at org.gradle.execution.plan.Node.isCanCancel(Node.java:XX)
    ... (infinite loop)
```

## Causa Raíz

Gradle 7.5.1 tiene un bug conocido donde grafos de dependencias muy complejos pueden causar recursión infinita durante la resolución de dependencias.

En nuestro caso:
- **firebaseTest**: 4 dependencias → ✅ BUILD SUCCESSFUL
- **Auri**: 1058 dependencias → ❌ StackOverflowError

El problema NO es la configuración (que es idéntica), sino la complejidad del grafo.

## Estrategias de Solución

### Estrategia 1: Aumentar Stack Size (Ya probado - No funcionó)

```properties
# android/gradle.properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=1024m -Xss16m
```

**Resultado**: ❌ No resuelve el problema. El error es de lógica, no de memoria.

---

### Estrategia 2: Simplificar Dependencias (Recomendado)

**Objetivo**: Reducir complejidad del grafo eliminando dependencias innecesarias.

#### Paso 1: Identificar dependencias no críticas

```powershell
# Ver árbol completo de dependencias
cd android
.\gradlew :app:dependencies --configuration debugCompileClasspath > deps.txt
```

Busca en `deps.txt`:
- Dependencias duplicadas
- Versiones conflictivas
- Paquetes no usados

#### Paso 2: Comentar dependencias no esenciales

En `package.json`, comenta temporalmente:
- Paquetes de desarrollo/debugging
- Features no críticas (analytics, crashlytics opcional)
- UI libraries que no se usan en MVP

```json
{
  "dependencies": {
    // "react-native-skeleton-placeholder": "^5.2.4",  // Comentar si no es crítico
    // "react-native-blur": "^4.3.2",  // Comentar si no es crítico
  }
}
```

#### Paso 3: Reinstalar y compilar

```bash
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps
.\.github\skills\diagnose-rn-downgrade\scripts\clean-rebuild.ps1
```

---

### Estrategia 3: Upgrade Gradle a 7.6.x (Requiere pruebas)

Gradle 7.6+ tiene fixes para bugs de recursión, pero requiere ajustes.

#### Modificar `android/gradle/wrapper/gradle-wrapper.properties`

```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-7.6.4-all.zip
```

#### Posibles issues al usar Gradle 7.6+

1. **Error de transformación de android.jar**
   - Solución: Forzar versiones de AndroidX en `android/build.gradle`

   ```groovy
   subprojects {
       configurations.all {
           resolutionStrategy {
               force 'androidx.core:core:1.9.0'
               force 'androidx.lifecycle:lifecycle-runtime:2.5.1'
               force 'androidx.appcompat:appcompat:1.5.1'
           }
       }
   }
   ```

2. **Incompatibilidad con AGP 7.3.1**
   - Puede requerir AGP 7.4.2
   - Pero AGP 7.4.2 causa conflictos con google-services

**Riesgo**: Alta probabilidad de nuevos errores. Solo intentar si Estrategia 2 falla.

---

### Estrategia 4: Enfoque Incremental (Más seguro pero lento)

**Objetivo**: Encontrar exactamente qué dependencia causa el StackOverflow.

#### Proceso

1. **Base de firebaseTest** (funciona)
   ```bash
   cp -r d:\Proyectos\auris\Auri-App\firebaseTest\package.json package.json.minimal
   ```

2. **Agregar dependencias de Auri una por una**
   - Empieza con las más críticas
   - Compila después de cada adición
   - Cuando falle, encontraste la culpable

3. **Categorías en orden de prioridad**:
   - Navegación (react-navigation/*)
   - Autenticación (google-signin, keychain)
   - Firebase (messaging ya está)
   - UI core (gesture-handler, reanimated, svg)
   - Utils (device-info, async-storage)
   - Nice-to-have (blur, skeleton-placeholder)

#### Ejemplo iterativo

**Iteración 1**: Solo navegación
```json
{
  "dependencies": {
    // ... firebaseTest base
    "@react-navigation/native": "^6.1.9",
    "@react-navigation/stack": "^6.3.20",
    "react-native-gesture-handler": "^2.9.0",
    "react-native-screens": "^3.20.0",
    "react-native-safe-area-context": "^4.5.0"
  }
}
```

Compilar:
```bash
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps
.\.github\skills\diagnose-rn-downgrade\scripts\clean-rebuild.ps1
```

- ✅ Si funciona: continúa agregando
- ❌ Si falla: uno de esos 5 paquetes es el problema, subdivide

**Iteración 2**: Agregar autenticación
```json
// + navegación anterior
"@react-native-google-signin/google-signin": "^10.1.1",
"react-native-keychain": "^8.2.0"
```

... y así sucesivamente.

---

### Estrategia 5: Usar otro Build Tool (Extremo)

Si todo falla, considerar:
- Migrar a Gradle 8.x con React Native 0.72+
- Usar Expo (requiere reescritura significativa)

**No recomendado** a menos que sea absolutamente necesario.

---

## Recomendación Actual

**Orden de ejecución**:

1. **PRIMERO**: Estrategia 2 - Simplificar Dependencias
   - Menor riesgo
   - Más rápido de probar
   - Beneficio: app más ligera

2. **SEGUNDO**: Estrategia 4 - Enfoque Incremental
   - Si Estrategia 2 no suficiente
   - Identifica exactamente el paquete problemático
   - Permite decisión informada sobre qué eliminar

3. **ÚLTIMO RECURSO**: Estrategia 3 - Upgrade Gradle
   - Alto riesgo de nuevos problemas
   - Solo si 1 y 2 no funcionan

**NO HACER**: Estrategia 5 (cambiar build tool) sin agotar 1-3.

---

## Script Helper: Dependency Bisect

Crear un script para automatizar búsqueda binaria:

```powershell
# bisect-dependencies.ps1
param(
    [string]$MinimalPackageJson = "package.json.minimal",
    [string]$FullPackageJson = "package.json.full"
)

# Backup current
Copy-Item package.json package.json.backup

# Start with minimal
Copy-Item $MinimalPackageJson package.json

# Test minimal
npm install --legacy-peer-deps
.\.github\skills\diagnose-rn-downgrade\scripts\clean-rebuild.ps1

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Minimal config fails - base is broken" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Minimal config works" -ForegroundColor Green

# Read full dependencies
$fullDeps = (Get-Content $FullPackageJson | ConvertFrom-Json).dependencies

# Binary search would go here
# For now, manual iteration recommended
```

---

## Logging para Debug

Aumentar verbosidad de Gradle:

```bash
cd android
.\gradlew :app:dependencies --debug > debug-deps.log 2>&1
```

Buscar en `debug-deps.log`:
- Circular dependency warnings
- Versiones en conflicto
- Dependency resolution failures

---

## Estado Actual (Resumen)

- ✅ Configuración Android idéntica a firebaseTest funcionando
- ✅ Versiones de dependencias compatibles con RN 0.71
- ✅ Java 17, Gradle 7.5.1, AGP 7.3.1, SDK 31 correctos
- ❌ 1058 dependencias causan StackOverflowError en Gradle
- ⚠️ Solución requiere simplificar grafo de dependencias

**Próximo paso recomendado**: Ejecutar Estrategia 2 - Comentar dependencias no esenciales y probar iterativamente.
