# React Native Downgrade Stabilization Tools

Sistema completo de herramientas para diagnosticar y resolver problemas al hacer downgrade de React Native.

## 📁 Estructura Creada

```
.github/
├── agents/
│   └── rn-downgrade-stabilizer.agent.md    # Agente especializado
└── skills/
    └── diagnose-rn-downgrade/
        ├── SKILL.md                          # Skill de diagnóstico
        ├── scripts/
        │   ├── README.md
        │   ├── check-compatibility.ps1       # Verificar compatibilidad
        │   ├── clean-rebuild.ps1             # Limpiar y recompilar
        │   ├── dependency-audit.ps1          # Auditar dependencias
        │   └── fix-gradle-cache.ps1          # Limpiar cache de Gradle
        └── templates/
            └── configs.md                    # Configuraciones probadas
```

## 🤖 Agente: RN Downgrade Stabilizer

**Archivo**: `.github/agents/rn-downgrade-stabilizer.agent.md`

### Cuándo Invocar

El agente se activa cuando mencionas:
- "downgrade de React Native"
- "problemas de compatibilidad"
- "errores de Gradle"
- "conflictos de AndroidX"
- "StackOverflowError en build"
- "incompatibilidad de dependencias"

### Capacidades

1. **Análisis de Compatibilidad**
   - Identifica versiones incompatibles
   - Conoce matrices de compatibilidad RN/Gradle/AGP/SDK
   - Detecta conflictos de AndroidX

2. **Diagnóstico de Errores**
   - StackOverflowError en Gradle
   - Errores de transformación de android.jar
   - Fallos de manifest merger
   - Conflictos de dependencias

3. **Soluciones Específicas**
   - Downgrades selectivos de dependencias
   - Configuración de build.gradle
   - Ajustes de gradle.properties
   - Limpieza de caches

### Uso

```
@rn-downgrade-stabilizer tengo un error de StackOverflow al compilar
```

O simplemente menciona el problema y el agente se invocará automáticamente si detecta palabras clave.

## 🔍 Skill: Diagnose RN Downgrade

**Archivo**: `.github/skills/diagnose-rn-downgrade/SKILL.md`

### Cuándo Usar

Invoca con `/diagnose-rn-downgrade` cuando necesites:
- Análisis completo de compatibilidad
- Reporte de estado del proyecto
- Plan de acción para estabilización
- Auditoría de dependencias

### Proceso de Diagnóstico

1. Lee configuración actual (package.json, build.gradle, etc.)
2. Compara con requisitos de la versión RN
3. Identifica incompatibilidades
4. Genera reporte con plan de acción

### Output

Genera un reporte estructurado con:
- Estado actual vs requerido
- Issues críticos y warnings
- Cambios necesarios específicos
- Plan de ejecución paso a paso

## 🛠️ Scripts PowerShell

### check-compatibility.ps1

**Propósito**: Verificar compatibilidad de versiones

**Uso**:
```powershell
.\.github\skills\diagnose-rn-downgrade\scripts\check-compatibility.ps1
```

**Qué hace**:
- Lee versión de React Native
- Determina versiones requeridas (Gradle, AGP, SDK, Kotlin)
- Compara con configuración actual
- Identifica paquetes de alto riesgo
- Genera reporte con ✅/❌

**Output Ejemplo**:
```
📦 React Native Version: 0.71.19
✅ Required Versions for RN 0.71.19
   Gradle: 7.5.1
   AGP: 7.3.1
   SDK: 31

📊 Current Configuration
   Gradle: 7.5.1 (✅)
   AGP: 7.4.2 (❌ Should be 7.3.1)
   SDK: 33 (❌ Should be 31)
```

### clean-rebuild.ps1

**Propósito**: Limpieza completa y rebuild

**Uso**:
```powershell
# Limpieza normal
.\.github\skills\diagnose-rn-downgrade\scripts\clean-rebuild.ps1

# Opción nuclear (incluye node_modules)
.\.github\skills\diagnose-rn-downgrade\scripts\clean-rebuild.ps1 -NuclearOption
```

**Qué hace**:
- Para Gradle daemon
- Limpia .gradle, app/build, build
- Opción nuclear: limpia node_modules y reinstala
- Ejecuta gradlew clean
- Compila app con npx react-native run-android

### dependency-audit.ps1

**Propósito**: Auditoría de versiones instaladas

**Uso**:
```powershell
.\.github\skills\diagnose-rn-downgrade\scripts\dependency-audit.ps1
```

**Qué hace**:
- Compara package.json con node_modules/*/package.json
- Identifica versiones reales instaladas
- Detecta discrepancias (npm pudo instalar versión diferente por ^)
- Alerta sobre versiones problemáticas conocidas

**Output**:
```
Package                    Declared    Installed   Status
-------                    --------    ---------   ------
react-native-reanimated    ^3.0.2      3.19.5      ❌
react-native-svg           ^13.4.0     13.4.0      ✅
```

### fix-gradle-cache.ps1

**Propósito**: Resolver problemas de cache de Gradle

**Uso**:
```powershell
# Cache local solamente
.\.github\skills\diagnose-rn-downgrade\scripts\fix-gradle-cache.ps1

# Incluir cache global (afecta todos los proyectos)
.\.github\skills\diagnose-rn-downgrade\scripts\fix-gradle-cache.ps1 -IncludeGlobal
```

**Qué hace**:
- Para todos los daemons de Gradle
- Limpia .gradle, app/build, build locales
- Opción -IncludeGlobal: limpia ~/.gradle/caches
- Verifica estado final
- Provee next steps

## 📝 Templates

**Archivo**: `.github/skills/diagnose-rn-downgrade/templates/configs.md`

### Contenido

- Configuraciones probadas para RN 0.71.x
- Configuraciones para RN 0.72.x
- Versiones compatibles de dependencias comunes
- Soluciones a problemas conocidos:
  - StackOverflowError
  - Conflictos de AndroidX
  - Manifest merger failures
  - Problemas de react-native-reanimated

### Uso

Consulta este archivo cuando necesites:
- Configuración base para un proyecto RN 0.71
- Versiones exactas de dependencias compatibles
- Soluciones rápidas a errores comunes

## 🎯 Flujo de Trabajo Recomendado

### 1. Diagnóstico Inicial

```powershell
# Ejecutar check de compatibilidad
.\.github\skills\diagnose-rn-downgrade\scripts\check-compatibility.ps1
```

### 2. Auditar Dependencias

```powershell
# Ver qué está realmente instalado
.\.github\skills\diagnose-rn-downgrade\scripts\dependency-audit.ps1
```

### 3. Aplicar Correcciones

Edita `package.json` con versiones correctas (consulta templates/configs.md)

### 4. Reinstalar

```powershell
npm install --legacy-peer-deps
```

### 5. Limpiar y Compilar

```powershell
# Limpieza normal
.\.github\skills\diagnose-rn-downgrade\scripts\clean-rebuild.ps1

# Si persisten problemas, opción nuclear
.\.github\skills\diagnose-rn-downgrade\scripts\clean-rebuild.ps1 -NuclearOption
```

### 6. Si Aún Falla

```powershell
# Limpiar cache de Gradle (incluir global si es necesario)
.\.github\skills\diagnose-rn-downgrade\scripts\fix-gradle-cache.ps1 -IncludeGlobal

# Rebuild
cd android
.\gradlew clean
cd ..
npx react-native run-android
```

## 💡 Tips

1. **Usa versiones exactas** en package.json para paquetes críticos:
   ```json
   "react-native-reanimated": "3.0.2"  // Sin ^
   ```

2. **Limpia cache regularmente** cuando cambies dependencias

3. **Consulta templates** antes de adivinar versiones compatibles

4. **Invoca al agente** cuando tengas dudas sobre compatibilidad

5. **Ejecuta scripts** en el orden recomendado: check → audit → fix → clean

## 🔧 Mantenimiento

### Actualizar Versiones Compatibles

Edita estos archivos cuando encuentres nuevas versiones compatibles:
- `rn-downgrade-stabilizer.agent.md` - Sección "Common Dependencies"
- `templates/configs.md` - package.json examples

### Agregar Nuevos Scripts

Coloca scripts en `scripts/` y documenta en `scripts/README.md`

### Reportar Problemas Nuevos

Agrega soluciones a `templates/configs.md` en "Common Issues & Solutions"

## ⚡ Atajos

Para agregar al PATH o crear aliases:

```powershell
# En PowerShell profile
function Check-RNCompat { .\.github\skills\diagnose-rn-downgrade\scripts\check-compatibility.ps1 }
function Clean-RNBuild { .\.github\skills\diagnose-rn-downgrade\scripts\clean-rebuild.ps1 }
function Audit-RNDeps { .\.github\skills\diagnose-rn-downgrade\scripts\dependency-audit.ps1 }
function Fix-GradleCache { .\.github\skills\diagnose-rn-downgrade\scripts\fix-gradle-cache.ps1 }
```

Uso:
```powershell
Check-RNCompat
Audit-RNDeps
Clean-RNBuild -NuclearOption
Fix-GradleCache -IncludeGlobal
```
