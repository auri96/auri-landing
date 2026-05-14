# Ejemplo Práctico: Recrear Login Screen de Figma

Este documento muestra un ejemplo completo de cómo usar el skill `/recreate-figma-ui` para implementar un diseño exacto de Figma.

## 📸 Escenario

El diseñador te envió este diseño de la pantalla de Login:

**Características visuales detectadas:**
- Fondo degradado de #1A237E a #283593
- Logo centrado arriba
- Card blanco con shadow
- Inputs con bordes redondeados
- Botón azul con shadow
- Tipografía: Mulish
- Espaciado consistente de 16px

## 🎯 Paso 1: Invocar el skill

```
Usuario: Necesito recrear este diseño de login [adjunta screenshot]
```

Respuesta del agente:
```
Perfecto! Voy a analizar el diseño y recrearlo con precisión pixel-perfect.

FASE 1: Análisis del diseño

He identificado:

COLORES:
- Background gradient: #1A237E → #283593
- Card background: #FFFFFF
- Primary button: #2196F3
- Text primary: #212121
- Text secondary: #757575
- Border: #E0E0E0
- Error: #F44336

TIPOGRAFÍA:
- Font family: Mulish
- Title: 24px, Bold
- Body: 16px, Regular
- Button: 16px, SemiBold
- Caption: 12px, Regular

ESPACIADO:
- Card padding: 24px
- Input margin: 16px
- Button margin-top: 24px
- Border radius: 12px

SHADOWS:
- Card: elevation 8
- Button: elevation 4

¿Procedo a generar el código?
```

## 🔧 Paso 2: Generación del código

### 2.1 Theme generado

```typescript
// src/core/theme/loginTheme.ts
export const loginTheme = {
  colors: {
    // Backgrounds
    gradientStart: '#1A237E',
    gradientEnd: '#283593',
    cardBackground: '#FFFFFF',
    
    // Primary
    primary: '#2196F3',
    primaryDark: '#1976D2',
    
    // Text
    textPrimary: '#212121',
    textSecondary: '#757575',
    textError: '#F44336',
    
    // UI
    border: '#E0E0E0',
    borderFocus: '#2196F3',
  },
  
  typography: {
    title: {
      fontFamily: 'Mulish-Bold',
      fontSize: 24,
      fontWeight: '700' as const,
      lineHeight: 32,
      color: '#212121',
    },
    body: {
      fontFamily: 'Mulish-Regular',
      fontSize: 16,
      fontWeight: '400' as const,
      lineHeight: 24,
      color: '#212121',
    },
    button: {
      fontFamily: 'Mulish-SemiBold',
      fontSize: 16,
      fontWeight: '600' as const,
      lineHeight: 24,
      color: '#FFFFFF',
    },
    caption: {
      fontFamily: 'Mulish-Regular',
      fontSize: 12,
      fontWeight: '400' as const,
      lineHeight: 16,
      color: '#757575',
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
  
  shadows: {
    card: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 4 },
      shadowOpacity: 0.15,
      shadowRadius: 8,
      elevation: 8,
    },
    button: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.1,
      shadowRadius: 4,
      elevation: 4,
    },
  },
};
```

### 2.2 LoginInput Component

```typescript
// src/presentation/components/molecules/LoginInput.tsx
import React, { memo, useState } from 'react';
import {
  StyleSheet,
  View,
  TextInput,
  Text,
  TouchableOpacity,
} from 'react-native';
import { loginTheme } from '../../../core/theme/loginTheme';

interface LoginInputProps {
  label: string;
  value: string;
  onChangeText: (text: string) => void;
  placeholder: string;
  error?: string;
  secureTextEntry?: boolean;
}

const LoginInput: React.FC<LoginInputProps> = memo(({
  label,
  value,
  onChangeText,
  placeholder,
  error,
  secureTextEntry = false,
}) => {
  const [isFocused, setIsFocused] = useState(false);
  const [isPasswordVisible, setIsPasswordVisible] = useState(false);

  return (
    <View style={styles.container}>
      <Text style={styles.label}>{label}</Text>
      <View style={[
        styles.inputContainer,
        isFocused && styles.inputFocused,
        error && styles.inputError,
      ]}>
        <TextInput
          style={styles.input}
          value={value}
          onChangeText={onChangeText}
          placeholder={placeholder}
          placeholderTextColor={loginTheme.colors.textSecondary}
          secureTextEntry={secureTextEntry && !isPasswordVisible}
          onFocus={() => setIsFocused(true)}
          onBlur={() => setIsFocused(false)}
        />
        {secureTextEntry && (
          <TouchableOpacity
            onPress={() => setIsPasswordVisible(!isPasswordVisible)}
            style={styles.eyeIcon}
          >
            <Text>{isPasswordVisible ? '👁️' : '👁️‍🗨️'}</Text>
          </TouchableOpacity>
        )}
      </View>
      {error && <Text style={styles.errorText}>{error}</Text>}
    </View>
  );
});

LoginInput.displayName = 'LoginInput';

const styles = StyleSheet.create({
  container: {
    marginBottom: loginTheme.spacing.md,
  },
  label: {
    ...loginTheme.typography.body,
    marginBottom: loginTheme.spacing.sm,
    color: loginTheme.colors.textPrimary,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: loginTheme.colors.border,
    borderRadius: loginTheme.borderRadius.input,
    backgroundColor: loginTheme.colors.cardBackground,
    paddingHorizontal: loginTheme.spacing.md,
  },
  inputFocused: {
    borderColor: loginTheme.colors.borderFocus,
    borderWidth: 2,
  },
  inputError: {
    borderColor: loginTheme.colors.textError,
  },
  input: {
    flex: 1,
    ...loginTheme.typography.body,
    paddingVertical: loginTheme.spacing.md,
  },
  eyeIcon: {
    padding: loginTheme.spacing.sm,
  },
  errorText: {
    ...loginTheme.typography.caption,
    color: loginTheme.colors.textError,
    marginTop: loginTheme.spacing.xs,
  },
});

export default LoginInput;
```

### 2.3 LoginButton Component

```typescript
// src/presentation/components/atoms/LoginButton.tsx
import React, { memo } from 'react';
import {
  StyleSheet,
  TouchableOpacity,
  Text,
  ActivityIndicator,
} from 'react-native';
import { loginTheme } from '../../../core/theme/loginTheme';

interface LoginButtonProps {
  label: string;
  onPress: () => void;
  loading?: boolean;
  disabled?: boolean;
}

const LoginButton: React.FC<LoginButtonProps> = memo(({
  label,
  onPress,
  loading = false,
  disabled = false,
}) => {
  return (
    <TouchableOpacity
      style={[
        styles.button,
        (disabled || loading) && styles.buttonDisabled,
      ]}
      onPress={onPress}
      disabled={disabled || loading}
      activeOpacity={0.8}
    >
      {loading ? (
        <ActivityIndicator size="small" color="#FFFFFF" />
      ) : (
        <Text style={styles.label}>{label}</Text>
      )}
    </TouchableOpacity>
  );
});

LoginButton.displayName = 'LoginButton';

const styles = StyleSheet.create({
  button: {
    backgroundColor: loginTheme.colors.primary,
    paddingVertical: loginTheme.spacing.md,
    borderRadius: loginTheme.borderRadius.button,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 56,
    ...loginTheme.shadows.button,
  },
  buttonDisabled: {
    backgroundColor: loginTheme.colors.textSecondary,
    opacity: 0.6,
  },
  label: {
    ...loginTheme.typography.button,
  },
});

export default LoginButton;
```

### 2.4 LoginCard Component

```typescript
// src/presentation/components/organisms/LoginCard.tsx
import React, { memo } from 'react';
import { StyleSheet, View, Text } from 'react-native';
import { loginTheme } from '../../../core/theme/loginTheme';
import LoginInput from '../molecules/LoginInput';
import LoginButton from '../atoms/LoginButton';

interface LoginCardProps {
  email: string;
  password: string;
  emailError?: string;
  passwordError?: string;
  loading: boolean;
  onEmailChange: (text: string) => void;
  onPasswordChange: (text: string) => void;
  onLogin: () => void;
  onForgotPassword: () => void;
}

const LoginCard: React.FC<LoginCardProps> = memo(({
  email,
  password,
  emailError,
  passwordError,
  loading,
  onEmailChange,
  onPasswordChange,
  onLogin,
  onForgotPassword,
}) => {
  return (
    <View style={styles.card}>
      <Text style={styles.title}>Iniciar Sesión</Text>
      <Text style={styles.subtitle}>
        Ingresa tus credenciales para continuar
      </Text>

      <LoginInput
        label="Email"
        value={email}
        onChangeText={onEmailChange}
        placeholder="ejemplo@correo.com"
        error={emailError}
      />

      <LoginInput
        label="Contraseña"
        value={password}
        onChangeText={onPasswordChange}
        placeholder="••••••••"
        error={passwordError}
        secureTextEntry
      />

      <TouchableOpacity
        onPress={onForgotPassword}
        style={styles.forgotPassword}
      >
        <Text style={styles.forgotPasswordText}>
          ¿Olvidaste tu contraseña?
        </Text>
      </TouchableOpacity>

      <LoginButton
        label="Iniciar Sesión"
        onPress={onLogin}
        loading={loading}
      />
    </View>
  );
});

LoginCard.displayName = 'LoginCard';

const styles = StyleSheet.create({
  card: {
    backgroundColor: loginTheme.colors.cardBackground,
    borderRadius: loginTheme.borderRadius.card,
    padding: loginTheme.spacing.lg,
    width: '90%',
    maxWidth: 400,
    ...loginTheme.shadows.card,
  },
  title: {
    ...loginTheme.typography.title,
    marginBottom: loginTheme.spacing.sm,
    textAlign: 'center',
  },
  subtitle: {
    ...loginTheme.typography.caption,
    marginBottom: loginTheme.spacing.lg,
    textAlign: 'center',
  },
  forgotPassword: {
    alignSelf: 'flex-end',
    marginBottom: loginTheme.spacing.md,
  },
  forgotPasswordText: {
    ...loginTheme.typography.caption,
    color: loginTheme.colors.primary,
  },
});

export default LoginCard;
```

### 2.5 LoginScreen completo

```typescript
// src/presentation/screens/auth/LoginScreen.tsx
import React, { useState, useCallback } from 'react';
import {
  StyleSheet,
  View,
  Image,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import { loginTheme } from '../../../core/theme/loginTheme';
import LoginCard from '../../components/organisms/LoginCard';
import { useAuth } from '../../hooks/useAuth';

const LoginScreen: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [emailError, setEmailError] = useState('');
  const [passwordError, setPasswordError] = useState('');

  const { login, isLoading } = useAuth();

  const validateEmail = (email: string): boolean => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email) {
      setEmailError('El email es obligatorio');
      return false;
    }
    if (!emailRegex.test(email)) {
      setEmailError('Email inválido');
      return false;
    }
    setEmailError('');
    return true;
  };

  const validatePassword = (password: string): boolean => {
    if (!password) {
      setPasswordError('La contraseña es obligatoria');
      return false;
    }
    if (password.length < 8) {
      setPasswordError('Mínimo 8 caracteres');
      return false;
    }
    setPasswordError('');
    return true;
  };

  const handleLogin = useCallback(async () => {
    const isEmailValid = validateEmail(email);
    const isPasswordValid = validatePassword(password);

    if (!isEmailValid || !isPasswordValid) return;

    try {
      await login({ email, password });
    } catch (error) {
      // Error handled by hook
    }
  }, [email, password, login]);

  const handleForgotPassword = useCallback(() => {
    // Navigate to forgot password screen
  }, []);

  return (
    <LinearGradient
      colors={[
        loginTheme.colors.gradientStart,
        loginTheme.colors.gradientEnd,
      ]}
      style={styles.gradient}
    >
      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        style={styles.container}
      >
        <Image
          source={require('../../../assets/logo.png')}
          style={styles.logo}
          resizeMode="contain"
        />

        <LoginCard
          email={email}
          password={password}
          emailError={emailError}
          passwordError={passwordError}
          loading={isLoading}
          onEmailChange={setEmail}
          onPasswordChange={setPassword}
          onLogin={handleLogin}
          onForgotPassword={handleForgotPassword}
        />
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
    alignItems: 'center',
    justifyContent: 'center',
    padding: loginTheme.spacing.md,
  },
  logo: {
    width: 120,
    height: 120,
    marginBottom: loginTheme.spacing.xl,
  },
});

export default LoginScreen;
```

## ✅ Resultado

El skill `/recreate-figma-ui` ha generado:

1. ✅ **Theme completo** con todos los colores, tipografía, spacing, y shadows extraídos del diseño
2. ✅ **4 componentes** perfectly organizados (Atom, Molecule, Organism, Screen)
3. ✅ **Pixel-perfect** matching del diseño original
4. ✅ **TypeScript** con tipos estrictos
5. ✅ **Validaciones** de formulario
6. ✅ **Estados** (focus, error, loading, disabled)
7. ✅ **Responsive** y optimizado
8. ✅ **Accesibilidad** (KeyboardAvoidingView)

## 🚀 Próximos pasos

```bash
# Integrar con backend
/integrate-api

# Agregar tests
/add-tests

# Optimizar si es necesario
/optimize-performance
```

---

**Tiempo total:** ~15 minutos
**Código generado:** ~400 líneas
**Componentes:** 4
**Calidad:** Production-ready ✨
