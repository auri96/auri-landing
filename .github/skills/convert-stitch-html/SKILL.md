---
name: convert-stitch-html
description: '**STITCH CONVERTER** — Convierte archivos .txt con HTML generado por Stitch a componentes React Native. Transforma HTML/CSS a JSX/StyleSheet, adapta a TypeScript strict, organiza según Clean Architecture, y genera componentes optimizados listos para producción.'
---

# Convert Stitch HTML Skill

Este skill convierte código HTML generado por Stitch AI (en archivos .txt) a componentes React Native siguiendo la arquitectura del proyecto Auri.

## Cuándo usar este skill

- Tienes un archivo .txt con HTML/CSS generado por Stitch
- Necesitas convertir diseños de Stitch a React Native
- Quieres adaptar código de Stitch a tu arquitectura (Clean Architecture + TypeScript)
- Tienes prompts en `/docs/product/stitch-*.md` y Stitch generó el código

## Proceso de conversión

### 1. Input esperado

**Formato del archivo .txt de Stitch:**
```html
<!-- archivo: output-stitch-login.txt -->
<!DOCTYPE html>
<html>
<head>
  <style>
    .container {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 20px;
      background: linear-gradient(180deg, #1A237E 0%, #283593 100%);
      min-height: 100vh;
    }
    
    .card {
      background: white;
      border-radius: 16px;
      padding: 24px;
      width: 90%;
      max-width: 400px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    
    .title {
      font-size: 24px;
      font-weight: 700;
      color: #212121;
      text-align: center;
      margin-bottom: 8px;
    }
    
    /* ... más CSS ... */
  </style>
</head>
<body>
  <div class="container">
    <img src="logo.png" class="logo" />
    <div class="card">
      <h1 class="title">Iniciar Sesión</h1>
      <p class="subtitle">Ingresa tus credenciales para continuar</p>
      
      <div class="input-group">
        <label class="label">Email</label>
        <input type="email" class="input" placeholder="ejemplo@correo.com" />
      </div>
      
      <div class="input-group">
        <label class="label">Contraseña</label>
        <input type="password" class="input" placeholder="••••••••" />
      </div>
      
      <button class="button-primary">Iniciar Sesión</button>
    </div>
  </div>
</body>
</html>
```

### 2. Análisis del HTML

El skill analiza:

**Estructura HTML:**
- Elementos: `<div>`, `<input>`, `<button>`, `<img>`, etc.
- Jerarquía de componentes
- Clases CSS aplicadas
- Atributos (type, placeholder, src, etc.)

**Estilos CSS:**
- Layout: `display: flex`, `flex-direction`, `align-items`, etc.
- Dimensiones: `width`, `height`, `min-height`, `max-width`
- Espaciado: `padding`, `margin`
- Colores: `background`, `color`, `border-color`
- Tipografía: `font-size`, `font-weight`, `text-align`
- Efectos: `border-radius`, `box-shadow`, `linear-gradient`

### 3. Mapeo HTML → React Native

#### Elementos HTML a React Native

| HTML | React Native | Notas |
|------|--------------|-------|
| `<div>` | `<View>` | Contenedor genérico |
| `<span>`, `<p>`, `<h1>` | `<Text>` | Texto |
| `<input>` | `<TextInput>` | Inputs de texto |
| `<button>` | `<TouchableOpacity>` + `<Text>` | Botones |
| `<img>` | `<Image>` | Imágenes |
| `<a>` | `<TouchableOpacity>` | Links |
| `<ul>`, `<ol>` | `<FlatList>` o `<ScrollView>` | Listas |

#### CSS a StyleSheet

| CSS Property | React Native Style | Conversión |
|--------------|-------------------|------------|
| `display: flex` | Implícito en `<View>` | No necesario |
| `flex-direction: column` | `flexDirection: 'column'` | Camel case |
| `align-items: center` | `alignItems: 'center'` | Camel case |
| `background: #FFF` | `backgroundColor: '#FFFFFF'` | backgroundColor |
| `linear-gradient(...)` | `<LinearGradient>` | Componente externo |
| `box-shadow: ...` | `shadowColor, shadowOffset, shadowOpacity, shadowRadius, elevation` | Múltiples props |
| `border-radius: 16px` | `borderRadius: 16` | Sin unidad |
| `padding: 20px` | `padding: 20` | Sin unidad |
| `font-size: 24px` | `fontSize: 24` | Camel case, sin unidad |
| `font-weight: 700` | `fontWeight: '700'` | String |
| `text-align: center` | `textAlign: 'center'` | Camel case |

### 4. Código generado

#### 4.1 Extraer theme de CSS

```typescript
// src/core/theme/stitchTheme.ts
export const stitchTheme = {
  colors: {
    // Extraídos del CSS
    gradientStart: '#1A237E',
    gradientEnd: '#283593',
    cardBackground: '#FFFFFF',
    textPrimary: '#212121',
    textSecondary: '#757575',
    primary: '#2196F3',
    border: '#E0E0E0',
  },
  
  typography: {
    title: {
      fontSize: 24,
      fontWeight: '700' as const,
      color: '#212121',
      textAlign: 'center' as const,
    },
    subtitle: {
      fontSize: 14,
      fontWeight: '400' as const,
      color: '#757575',
      textAlign: 'center' as const,
    },
    label: {
      fontSize: 16,
      fontWeight: '400' as const,
      color: '#212121',
    },
  },
  
  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
  },
  
  borderRadius: {
    input: 12,
    button: 12,
    card: 16,
  },
};
```

#### 4.2 Crear componentes atómicos

```typescript
// src/presentation/components/atoms/StitchInput.tsx
import React, { memo } from 'react';
import { StyleSheet, View, TextInput, Text } from 'react-native';
import { stitchTheme } from '../../../core/theme/stitchTheme';

interface StitchInputProps {
  label: string;
  value: string;
  onChangeText: (text: string) => void;
  placeholder: string;
  secureTextEntry?: boolean;
  error?: string;
}

const StitchInput: React.FC<StitchInputProps> = memo(({
  label,
  value,
  onChangeText,
  placeholder,
  secureTextEntry = false,
  error,
}) => {
  return (
    <View style={styles.inputGroup}>
      <Text style={styles.label}>{label}</Text>
      <TextInput
        style={[styles.input, error && styles.inputError]}
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        placeholderTextColor={stitchTheme.colors.textSecondary}
        secureTextEntry={secureTextEntry}
      />
      {error && <Text style={styles.error}>{error}</Text>}
    </View>
  );
});

StitchInput.displayName = 'StitchInput';

const styles = StyleSheet.create({
  inputGroup: {
    marginBottom: stitchTheme.spacing.md,
  },
  label: {
    ...stitchTheme.typography.label,
    marginBottom: stitchTheme.spacing.sm,
  },
  input: {
    borderWidth: 1,
    borderColor: stitchTheme.colors.border,
    borderRadius: stitchTheme.borderRadius.input,
    paddingHorizontal: stitchTheme.spacing.md,
    paddingVertical: stitchTheme.spacing.md,
    fontSize: 16,
    color: stitchTheme.colors.textPrimary,
    backgroundColor: stitchTheme.colors.cardBackground,
  },
  inputError: {
    borderColor: '#FF3B30',
  },
  error: {
    fontSize: 12,
    color: '#FF3B30',
    marginTop: stitchTheme.spacing.xs,
  },
});

export default StitchInput;
```

```typescript
// src/presentation/components/atoms/StitchButton.tsx
import React, { memo } from 'react';
import { StyleSheet, TouchableOpacity, Text, ActivityIndicator } from 'react-native';
import { stitchTheme } from '../../../core/theme/stitchTheme';

interface StitchButtonProps {
  label: string;
  onPress: () => void;
  variant?: 'primary' | 'secondary' | 'outlined';
  loading?: boolean;
  disabled?: boolean;
}

const StitchButton: React.FC<StitchButtonProps> = memo(({
  label,
  onPress,
  variant = 'primary',
  loading = false,
  disabled = false,
}) => {
  return (
    <TouchableOpacity
      style={[
        styles.button,
        styles[variant],
        (disabled || loading) && styles.disabled,
      ]}
      onPress={onPress}
      disabled={disabled || loading}
      activeOpacity={0.7}
    >
      {loading ? (
        <ActivityIndicator size="small" color="#FFFFFF" />
      ) : (
        <Text style={[styles.label, variant === 'outlined' && styles.labelOutlined]}>
          {label}
        </Text>
      )}
    </TouchableOpacity>
  );
});

StitchButton.displayName = 'StitchButton';

const styles = StyleSheet.create({
  button: {
    paddingVertical: stitchTheme.spacing.md,
    paddingHorizontal: stitchTheme.spacing.lg,
    borderRadius: stitchTheme.borderRadius.button,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 56,
  },
  primary: {
    backgroundColor: stitchTheme.colors.primary,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 4,
  },
  secondary: {
    backgroundColor: stitchTheme.colors.textSecondary,
  },
  outlined: {
    backgroundColor: 'transparent',
    borderWidth: 2,
    borderColor: stitchTheme.colors.primary,
  },
  disabled: {
    opacity: 0.5,
  },
  label: {
    fontSize: 16,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  labelOutlined: {
    color: stitchTheme.colors.primary,
  },
});

export default StitchButton;
```

#### 4.3 Crear screen completa

```typescript
// src/presentation/screens/auth/StitchLoginScreen.tsx
import React, { useState, useCallback } from 'react';
import {
  StyleSheet,
  View,
  Text,
  Image,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import { stitchTheme } from '../../../core/theme/stitchTheme';
import StitchInput from '../../components/atoms/StitchInput';
import StitchButton from '../../components/atoms/StitchButton';

const StitchLoginScreen: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [emailError, setEmailError] = useState('');
  const [passwordError, setPasswordError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = useCallback(async () => {
    // Validaciones
    let hasError = false;

    if (!email) {
      setEmailError('El email es obligatorio');
      hasError = true;
    } else if (!/\S+@\S+\.\S+/.test(email)) {
      setEmailError('Email inválido');
      hasError = true;
    } else {
      setEmailError('');
    }

    if (!password) {
      setPasswordError('La contraseña es obligatoria');
      hasError = true;
    } else if (password.length < 8) {
      setPasswordError('Mínimo 8 caracteres');
      hasError = true;
    } else {
      setPasswordError('');
    }

    if (hasError) return;

    // Login logic
    setLoading(true);
    try {
      // await authService.login({ email, password });
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  }, [email, password]);

  return (
    <LinearGradient
      colors={[stitchTheme.colors.gradientStart, stitchTheme.colors.gradientEnd]}
      style={styles.gradient}
    >
      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        style={styles.container}
      >
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          keyboardShouldPersistTaps="handled"
        >
          <Image
            source={require('../../../assets/logo.png')}
            style={styles.logo}
            resizeMode="contain"
          />

          <View style={styles.card}>
            <Text style={styles.title}>Iniciar Sesión</Text>
            <Text style={styles.subtitle}>
              Ingresa tus credenciales para continuar
            </Text>

            <StitchInput
              label="Email"
              value={email}
              onChangeText={setEmail}
              placeholder="ejemplo@correo.com"
              error={emailError}
            />

            <StitchInput
              label="Contraseña"
              value={password}
              onChangeText={setPassword}
              placeholder="••••••••"
              secureTextEntry
              error={passwordError}
            />

            <StitchButton
              label="Iniciar Sesión"
              onPress={handleLogin}
              loading={loading}
            />
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  gradient: {
    flex: 1,
  },
  container: {
    flex: 1,
  },
  scrollContent: {
    flexGrow: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: stitchTheme.spacing.md,
  },
  logo: {
    width: 120,
    height: 120,
    marginBottom: stitchTheme.spacing.xl,
  },
  card: {
    backgroundColor: stitchTheme.colors.cardBackground,
    borderRadius: stitchTheme.borderRadius.card,
    padding: stitchTheme.spacing.lg,
    width: '100%',
    maxWidth: 400,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.15,
    shadowRadius: 8,
    elevation: 8,
  },
  title: {
    ...stitchTheme.typography.title,
    marginBottom: stitchTheme.spacing.sm,
  },
  subtitle: {
    ...stitchTheme.typography.subtitle,
    marginBottom: stitchTheme.spacing.lg,
  },
});

export default StitchLoginScreen;
```

## Reglas de conversión

### ✅ SÍ convertir

| HTML/CSS | React Native |
|----------|--------------|
| `class="container"` | `style={styles.container}` |
| `<div>` | `<View>` |
| `<h1>`, `<p>` | `<Text>` |
| `<input type="text">` | `<TextInput>` |
| `<button>` | `<TouchableOpacity>` + `<Text>` |
| `background: linear-gradient(...)` | `<LinearGradient>` |
| `padding: 20px` | `padding: 20` |
| `font-size: 24px` | `fontSize: 24` |

### ❌ NO soportado (requiere alternativas)

| HTML/CSS | Alternativa React Native |
|----------|--------------------------|
| `<table>` | Custom component con `<View>` + `<FlatList>` |
| `:hover`, `:active` | `activeOpacity` o `Pressable` con estados |
| `position: fixed` | `position: 'absolute'` + ajustes |
| CSS Grid | Flexbox equivalente |
| `overflow: scroll` | `<ScrollView>` |
| Media queries | `Dimensions` + responsive logic |

## Proceso paso a paso

### Paso 1: Recibir archivo .txt

```
Usuario: Tengo este archivo de Stitch [adjunta stitch-output.txt]
```

### Paso 2: Analizar HTML y CSS

El skill:
1. Lee el archivo .txt
2. Extrae estructura HTML
3. Extrae estilos CSS
4. Identifica componentes reutilizables
5. Detecta colores, tipografía, spacing

### Paso 3: Generar código React Native

El skill genera:
1. **Theme file** con colores, tipografía, spacing extraídos
2. **Componentes atómicos** (Button, Input, Card, etc.)
3. **Componentes moleculares** si hay combinaciones
4. **Screen completa** ensamblando todo
5. **Types TypeScript** para props

### Paso 4: Optimizar y adaptar

- Aplicar `memo()` a componentes
- Usar `useCallback` para handlers
- Añadir validaciones
- Implementar estados (loading, error, success)
- Adaptar a navegación del proyecto

## Dependencias necesarias

```bash
# Si usa gradientes
npm install react-native-linear-gradient

# Si usa iconos
npm install react-native-vector-icons

# Si usa imágenes optimizadas
npm install react-native-fast-image
```

## Checklist de conversión

- [ ] HTML parseado correctamente
- [ ] CSS convertido a StyleSheet
- [ ] Gradientes convertidos a `<LinearGradient>`
- [ ] Shadows convertidos (iOS + Android)
- [ ] Theme extraído y centralizado
- [ ] Componentes separados por responsabilidad
- [ ] TypeScript sin errores
- [ ] Props tipadas correctamente
- [ ] Código optimizado (memo, useCallback)
- [ ] Responsive (funciona en diferentes tamaños)
- [ ] Navegación integrada
- [ ] Estados manejados (loading, error)

## Ejemplo de uso completo

```bash
1. Generas diseño en Stitch
2. Stitch exporta HTML a archivo .txt
3. Ejecutas: /convert-stitch-html
4. Adjuntas el archivo .txt
5. Skill analiza y genera:
   ✅ Theme
   ✅ Componentes atómicos
   ✅ Screen completa
   ✅ TypeScript strict
   ✅ Optimizado y listo para producción
```

## Tips avanzados

### Personalizar conversión

Si el HTML de Stitch usa clases específicas, puedes crear mapeos personalizados:

```typescript
// Mapeo de clases CSS a componentes custom
const CLASS_TO_COMPONENT = {
  'btn-primary': StitchButton,
  'input-field': StitchInput,
  'card-container': StitchCard,
};
```

### Componentes especiales

**Para carousels/sliders:**
```typescript
import Carousel from 'react-native-snap-carousel';
// Convertir slider HTML a Carousel component
```

**Para modals:**
```typescript
import Modal from 'react-native-modal';
// Convertir overlays a Modal
```

## Limitaciones conocidas

1. **Animaciones CSS** → Usar `Animated` o `Reanimated`
2. **CSS Grid** → Convertir a Flexbox
3. **Pseudo-elementos** (::before, ::after) → Implementar manualmente
4. **Z-index complejo** → Reorganizar jerarquía de componentes
5. **Responsive breakpoints** → Usar `Dimensions` API

## Referencias

- [React Native Components](https://reactnative.dev/docs/components-and-apis)
- [StyleSheet API](https://reactnative.dev/docs/stylesheet)
- [Linear Gradient](https://github.com/react-native-linear-gradient/react-native-linear-gradient)
- [Stitch Prompts originales](../../../docs/product/stitch-ui-prompts.md)
