---
name: recreate-figma-ui
description: '**DISEÑO VISUAL** — Recrea diseños de Figma con precisión pixel-perfect en React Native. Analiza imágenes, extrae colores/tipografía/espaciado, genera código TypeScript con StyleSheet, implementa componentes responsivos. USE PARA: convertir mockups a código, replicar diseños exactos, crear componentes visuales desde capturas de pantalla o código de referencia.'
---

# Recreate Figma UI Skill

Este skill te permite recrear diseños visuales de Figma en React Native con precisión pixel-perfect, extrayendo todos los detalles de diseño y generando código limpio y mantenible.

## Cuándo usar este skill

- Tienes una imagen/screenshot de un diseño de Figma
- Necesitas replicar un diseño visual exactamente
- Quieres convertir mockups a código React Native
- Tienes código de referencia de otro proyecto que quieres adaptar
- El diseñador te compartió un visual que debes implementar

## Proceso de análisis y recreación

### 1. Análisis del diseño

Cuando te proporcionen una imagen o código de referencia, analiza:

#### Colores
- **Fondos:** Identificar colores de fondo (backgrounds)
- **Textos:** Colores primarios, secundarios, terciarios
- **Accents:** Colores de acción (botones, links, highlights)
- **Bordes:** Colores de separadores, borders, shadows
- **Estados:** Hover, pressed, disabled, active

**Extracción de colores:**
```typescript
// Theme colors extraídos del diseño
const COLORS = {
  // Backgrounds
  background: '#FFFFFF',
  backgroundSecondary: '#F8F9FA',
  surface: '#FFFFFF',
  
  // Text
  textPrimary: '#1A1A1A',
  textSecondary: '#6B6B6B',
  textTertiary: '#9E9E9E',
  textDisabled: '#CCCCCC',
  
  // Brand
  primary: '#007AFF',
  primaryLight: '#4DA3FF',
  primaryDark: '#0056B3',
  
  // Semantic
  success: '#34C759',
  warning: '#FF9500',
  error: '#FF3B30',
  info: '#5AC8FA',
  
  // Accents
  accent: '#FF2D55',
  
  // Borders & Shadows
  border: '#E5E5E5',
  shadow: 'rgba(0, 0, 0, 0.1)',
};
```

#### Tipografía
- **Font family:** ¿Qué fuente se usa? (San Francisco, Roboto, custom)
- **Font sizes:** Identificar jerarquía (H1, H2, Body, Caption, etc.)
- **Font weights:** 300, 400, 500, 600, 700, 800
- **Line heights:** Espaciado entre líneas
- **Letter spacing:** Espaciado entre caracteres

**Extracción de tipografía:**
```typescript
const TYPOGRAPHY = {
  // Headings
  h1: {
    fontFamily: 'Mulish-Bold',
    fontSize: 32,
    fontWeight: '700' as const,
    lineHeight: 40,
    letterSpacing: -0.5,
  },
  h2: {
    fontFamily: 'Mulish-Bold',
    fontSize: 24,
    fontWeight: '700' as const,
    lineHeight: 32,
    letterSpacing: -0.3,
  },
  h3: {
    fontFamily: 'Mulish-SemiBold',
    fontSize: 20,
    fontWeight: '600' as const,
    lineHeight: 28,
  },
  
  // Body
  bodyLarge: {
    fontFamily: 'Mulish-Regular',
    fontSize: 16,
    fontWeight: '400' as const,
    lineHeight: 24,
  },
  body: {
    fontFamily: 'Mulish-Regular',
    fontSize: 14,
    fontWeight: '400' as const,
    lineHeight: 20,
  },
  bodySmall: {
    fontFamily: 'Mulish-Regular',
    fontSize: 12,
    fontWeight: '400' as const,
    lineHeight: 16,
  },
  
  // Special
  caption: {
    fontFamily: 'Mulish-Regular',
    fontSize: 11,
    fontWeight: '400' as const,
    lineHeight: 14,
    letterSpacing: 0.3,
  },
  button: {
    fontFamily: 'Mulish-SemiBold',
    fontSize: 16,
    fontWeight: '600' as const,
    lineHeight: 24,
    letterSpacing: 0.5,
  },
};
```

#### Espaciado y Layout
- **Padding:** Espacios internos de contenedores
- **Margin:** Espacios entre elementos
- **Gap:** Espaciado en Flexbox
- **Grid:** Sistema de columnas (8pt, 4pt grid)

**Sistema de espaciado:**
```typescript
const SPACING = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
};

// Uso en componentes
style={{
  padding: SPACING.md,
  marginVertical: SPACING.lg,
  gap: SPACING.sm,
}}
```

#### Borders & Radius
- **Border width:** 1px, 2px, etc.
- **Border radius:** Esquinas redondeadas (4, 8, 12, 16, full)
- **Border color:** Color del borde

```typescript
const BORDERS = {
  radius: {
    none: 0,
    sm: 4,
    md: 8,
    lg: 12,
    xl: 16,
    full: 9999,
  },
  width: {
    thin: 1,
    medium: 2,
    thick: 3,
  },
};
```

#### Shadows & Elevation
- **Shadow color:** usualmente rgba(0, 0, 0, x)
- **Shadow offset:** { width, height }
- **Shadow opacity:** 0.05 - 0.3
- **Shadow radius:** blur del shadow
- **Elevation (Android):** 2, 4, 8, 16

```typescript
const SHADOWS = {
  sm: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 2,
    elevation: 2,
  },
  md: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 4,
  },
  lg: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.15,
    shadowRadius: 8,
    elevation: 8,
  },
};
```

### 2. Creación del theme base

Antes de crear componentes, crea el archivo de theme:

```typescript
// src/core/theme/index.ts
export const theme = {
  colors: {
    // Backgrounds
    background: '#FFFFFF',
    backgroundSecondary: '#F8F9FA',
    surface: '#FFFFFF',
    
    // Text
    textPrimary: '#1A1A1A',
    textSecondary: '#6B6B6B',
    textTertiary: '#9E9E9E',
    
    // Brand
    primary: '#007AFF',
    primaryLight: '#4DA3FF',
    primaryDark: '#0056B3',
    
    // Semantic
    success: '#34C759',
    warning: '#FF9500',
    error: '#FF3B30',
    
    // UI
    border: '#E5E5E5',
    shadow: 'rgba(0, 0, 0, 0.1)',
  },
  
  typography: {
    h1: { fontSize: 32, fontWeight: '700', lineHeight: 40 },
    h2: { fontSize: 24, fontWeight: '700', lineHeight: 32 },
    h3: { fontSize: 20, fontWeight: '600', lineHeight: 28 },
    body: { fontSize: 14, fontWeight: '400', lineHeight: 20 },
    caption: { fontSize: 11, fontWeight: '400', lineHeight: 14 },
  },
  
  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
  },
  
  borderRadius: {
    sm: 4,
    md: 8,
    lg: 12,
    xl: 16,
    full: 9999,
  },
  
  shadows: {
    sm: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 1 },
      shadowOpacity: 0.05,
      shadowRadius: 2,
      elevation: 2,
    },
    md: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.1,
      shadowRadius: 4,
      elevation: 4,
    },
  },
};

export type Theme = typeof theme;
```

### 3. Recreación del componente

#### Ejemplo 1: Button con diseño de Figma

**Análisis visual:**
- Fondo: Azul #007AFF
- Texto: Blanco, 16px, SemiBold
- Padding: 16px vertical, 24px horizontal
- Border radius: 12px
- Shadow: ligera
- Estados: normal, pressed, disabled

**Implementación:**
```typescript
import React, { memo } from 'react';
import {
  TouchableOpacity,
  Text,
  StyleSheet,
  ActivityIndicator,
  ViewStyle,
  TextStyle,
} from 'react-native';
import { theme } from '../../core/theme';

interface PrimaryButtonProps {
  label: string;
  onPress: () => void;
  disabled?: boolean;
  loading?: boolean;
  fullWidth?: boolean;
}

const PrimaryButton: React.FC<PrimaryButtonProps> = memo(({
  label,
  onPress,
  disabled = false,
  loading = false,
  fullWidth = false,
}) => {
  return (
    <TouchableOpacity
      style={[
        styles.button,
        fullWidth && styles.fullWidth,
        disabled && styles.disabled,
      ]}
      onPress={onPress}
      disabled={disabled || loading}
      activeOpacity={0.7}
    >
      {loading ? (
        <ActivityIndicator size="small" color={theme.colors.background} />
      ) : (
        <Text style={styles.label}>{label}</Text>
      )}
    </TouchableOpacity>
  );
});

PrimaryButton.displayName = 'PrimaryButton';

const styles = StyleSheet.create({
  button: {
    backgroundColor: theme.colors.primary,
    paddingVertical: theme.spacing.md,
    paddingHorizontal: theme.spacing.lg,
    borderRadius: theme.borderRadius.lg,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 56,
    ...theme.shadows.sm,
  },
  fullWidth: {
    width: '100%',
  },
  disabled: {
    backgroundColor: theme.colors.textTertiary,
    opacity: 0.5,
  },
  label: {
    color: theme.colors.background,
    fontSize: 16,
    fontWeight: '600',
    letterSpacing: 0.5,
  },
});

export default PrimaryButton;
```

#### Ejemplo 2: Card completo

**Análisis visual:**
- Fondo: Blanco
- Border radius: 16px
- Shadow: media elevation
- Padding: 20px
- Contenido: Icon + Title + Subtitle + Badge

**Implementación:**
```typescript
import React, { memo } from 'react';
import { View, Text, StyleSheet, Image } from 'react-native';
import { theme } from '../../core/theme';

interface TransactionCardProps {
  icon: string;
  title: string;
  subtitle: string;
  amount: string;
  type: 'income' | 'expense';
  category: string;
}

const TransactionCard: React.FC<TransactionCardProps> = memo(({
  icon,
  title,
  subtitle,
  amount,
  type,
  category,
}) => {
  const amountColor = type === 'income' 
    ? theme.colors.success 
    : theme.colors.error;

  return (
    <View style={styles.card}>
      {/* Icon */}
      <View style={styles.iconContainer}>
        <Text style={styles.icon}>{icon}</Text>
      </View>

      {/* Content */}
      <View style={styles.content}>
        <Text style={styles.title}>{title}</Text>
        <Text style={styles.subtitle}>{subtitle}</Text>
      </View>

      {/* Amount */}
      <View style={styles.amountContainer}>
        <Text style={[styles.amount, { color: amountColor }]}>
          {type === 'income' ? '+' : '-'} ${amount}
        </Text>
        <View style={styles.badge}>
          <Text style={styles.badgeText}>{category}</Text>
        </View>
      </View>
    </View>
  );
});

TransactionCard.displayName = 'TransactionCard';

const styles = StyleSheet.create({
  card: {
    backgroundColor: theme.colors.surface,
    borderRadius: theme.borderRadius.xl,
    padding: theme.spacing.lg,
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: theme.spacing.md,
    ...theme.shadows.md,
  },
  iconContainer: {
    width: 48,
    height: 48,
    borderRadius: theme.borderRadius.lg,
    backgroundColor: theme.colors.backgroundSecondary,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: theme.spacing.md,
  },
  icon: {
    fontSize: 24,
  },
  content: {
    flex: 1,
  },
  title: {
    fontSize: 16,
    fontWeight: '600',
    color: theme.colors.textPrimary,
    marginBottom: 4,
  },
  subtitle: {
    fontSize: 13,
    color: theme.colors.textSecondary,
  },
  amountContainer: {
    alignItems: 'flex-end',
  },
  amount: {
    fontSize: 18,
    fontWeight: '700',
    marginBottom: 4,
  },
  badge: {
    backgroundColor: theme.colors.backgroundSecondary,
    paddingHorizontal: theme.spacing.sm,
    paddingVertical: 4,
    borderRadius: theme.borderRadius.sm,
  },
  badgeText: {
    fontSize: 11,
    color: theme.colors.textSecondary,
    fontWeight: '500',
  },
});

export default TransactionCard;
```

### 4. Responsividad y adaptación

```typescript
import { Dimensions, Platform } from 'react-native';

const { width, height } = Dimensions.get('window');

// Breakpoints
const BREAKPOINTS = {
  small: 375,
  medium: 768,
  large: 1024,
};

// Responsive sizing
const scale = (size: number) => (width / 375) * size;
const verticalScale = (size: number) => (height / 812) * size;
const moderateScale = (size: number, factor = 0.5) => 
  size + (scale(size) - size) * factor;

// En estilos
const styles = StyleSheet.create({
  title: {
    fontSize: moderateScale(24),
    marginBottom: verticalScale(16),
  },
  container: {
    paddingHorizontal: width > BREAKPOINTS.medium ? 32 : 16,
  },
});
```

## Checklist de recreación

- [ ] Colores extraídos y documentados en theme
- [ ] Tipografía identificada (family, sizes, weights, line heights)
- [ ] Espaciado medido con precisión (padding, margin, gap)
- [ ] Borders y radius correctos
- [ ] Shadows configuradas (iOS + Android)
- [ ] Componente responsive
- [ ] Estados visuales implementados (pressed, disabled, active)
- [ ] Props tipadas correctamente
- [ ] Código limpio y mantenible
- [ ] Verificado visualmente vs diseño original

## Herramientas de ayuda

**Para extraer colores de imágenes:**
- Usa herramientas como ColorZilla o Figma Inspector
- Si solo tienes screenshot, analiza pixel por pixel
- Documenta códigos hex exactos

**Para medir espaciado:**
- Usa la herramienta de medición de Figma
- Regla: si no estás seguro, usa múltiplos de 4 (4, 8, 12, 16, 24, 32, 48)

**Para tipografía:**
- Identifica la font family primero
- Extrae todos los font sizes que veas
- Documenta weights usados
- Calcula line height (generalmente 1.2x - 1.5x del font size)

## Anti-patrones a evitar

❌ **NO hacer:**
- Hardcodear colores directamente en componentes
- Usar valores mágicos sin documentar
- Ignorar estados (pressed, disabled, etc.)
- No considerar responsividad
- Mezclar estilos inline
- Aproximar medidas "a ojo"

✅ **SÍ hacer:**
- Crear theme centralizado
- Documentar todos los valores de diseño
- Implementar TODOS los estados visuales
- Hacer componentes responsive
- Usar StyleSheet.create()
- Medir con precisión

## Referencias

- [React Native StyleSheet](https://reactnative.dev/docs/stylesheet)
- [Responsive Design in React Native](https://reactnative.dev/docs/dimensions)
- [Color Theory](https://www.interaction-design.org/literature/topics/color-theory)
