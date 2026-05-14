# Ejemplo Práctico: Convertir Stitch HTML a React Native

Este documento muestra cómo usar el skill `/convert-stitch-html` con un ejemplo real del proyecto Auri.

## 📋 Escenario

Has usado Stitch AI para generar la pantalla de "Selección de Planes" usando el prompt de `/docs/product/stitch-plan-selection-prompt.md`. Stitch generó el HTML/CSS y lo exportaste a `stitch-plan-selection.txt`.

## 📂 Archivo de input (stitch-plan-selection.txt)

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <style>
    .container {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 16px;
      background-color: #FFFFFF;
      min-height: 100vh;
    }

    .header {
      width: 100%;
      padding: 16px 0;
      margin-bottom: 24px;
    }

    .title {
      font-size: 24px;
      font-weight: 700;
      color: #2D3436;
      text-align: center;
      margin-bottom: 8px;
    }

    .subtitle {
      font-size: 14px;
      font-weight: 400;
      color: #636E72;
      text-align: center;
    }

    .billing-toggle {
      display: flex;
      flex-direction: row;
      background-color: #F8F9FA;
      border-radius: 12px;
      padding: 4px;
      margin-bottom: 24px;
      width: 100%;
      max-width: 300px;
    }

    .toggle-button {
      flex: 1;
      padding: 12px;
      background-color: transparent;
      border: none;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 600;
      color: #636E72;
      cursor: pointer;
      transition: all 0.2s;
    }

    .toggle-button.active {
      background-color: #FFFFFF;
      color: #2D3436;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .savings-badge {
      background-color: #D5F4E6;
      color: #00B894;
      padding: 8px 16px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      margin-bottom: 16px;
    }

    .plans-container {
      width: 100%;
      overflow-x: auto;
      display: flex;
      gap: 16px;
      padding-bottom: 16px;
    }

    .plan-card {
      min-width: 300px;
      background-color: #FFFFFF;
      border: 1px solid #E5E5E5;
      border-radius: 16px;
      padding: 24px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    }

    .plan-card.featured {
      border: 2px solid #6BCB77;
      background-color: #F0FFF4;
      transform: scale(1.02);
    }

    .plan-badge {
      background-color: #6BCB77;
      color: #FFFFFF;
      padding: 6px 12px;
      border-radius: 12px;
      font-size: 11px;
      font-weight: 600;
      display: inline-block;
      margin-bottom: 16px;
    }

    .plan-icon {
      font-size: 32px;
      margin-bottom: 12px;
    }

    .plan-name {
      font-size: 20px;
      font-weight: 700;
      color: #2D3436;
      margin-bottom: 16px;
    }

    .plan-price {
      font-size: 36px;
      font-weight: 700;
      color: #2D3436;
      margin-bottom: 4px;
    }

    .plan-period {
      font-size: 14px;
      color: #636E72;
      margin-bottom: 16px;
    }

    .plan-description {
      font-size: 14px;
      color: #636E72;
      margin-bottom: 20px;
    }

    .plan-features {
      list-style: none;
      padding: 0;
      margin: 0 0 24px 0;
    }

    .feature-item {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 12px;
      font-size: 14px;
      color: #2D3436;
    }

    .feature-check {
      color: #6BCB77;
      font-weight: 700;
    }

    .plan-button {
      width: 100%;
      padding: 16px;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 600;
      border: none;
      cursor: pointer;
      transition: all 0.2s;
    }

    .button-primary {
      background-color: #6BCB77;
      color: #FFFFFF;
      box-shadow: 0 2px 4px rgba(107, 203, 119, 0.3);
    }

    .button-outlined {
      background-color: transparent;
      color: #6BCB77;
      border: 2px solid #6BCB77;
    }

    .compare-link {
      text-align: center;
      margin-top: 24px;
      font-size: 14px;
      color: #6BCB77;
      text-decoration: underline;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <div class="container">
    <!-- Header -->
    <div class="header">
      <h1 class="title">Elige tu plan</h1>
      <p class="subtitle">Puedes cambiar en cualquier momento</p>
    </div>

    <!-- Billing Toggle -->
    <div class="billing-toggle">
      <button class="toggle-button active">Mensual</button>
      <button class="toggle-button">Anual</button>
    </div>

    <!-- Savings Badge (mostrar solo si Anual) -->
    <div class="savings-badge" style="display: none;">
      💰 Ahorra hasta $14/año con plan anual
    </div>

    <!-- Plans Container -->
    <div class="plans-container">
      <!-- Plan FREE -->
      <div class="plan-card">
        <div class="plan-icon">🎁</div>
        <h2 class="plan-name">Plan FREE</h2>
        <div class="plan-price">$0</div>
        <div class="plan-period">/mes</div>
        <p class="plan-description">Perfecto para empezar</p>
        <ul class="plan-features">
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Últimos 30 días</span>
          </li>
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>7 categorías</span>
          </li>
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Balance básico</span>
          </li>
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Registro ilimitado</span>
          </li>
        </ul>
        <button class="plan-button button-outlined">Empezar gratis</button>
      </div>

      <!-- Plan BÁSICO (Featured) -->
      <div class="plan-card featured">
        <span class="plan-badge">Más Popular</span>
        <div class="plan-icon">🌟</div>
        <h2 class="plan-name">Plan BÁSICO</h2>
        <div class="plan-price">$3.99</div>
        <div class="plan-period">/mes</div>
        <p class="plan-description">Control total</p>
        <ul class="plan-features">
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Historial ilimitado</span>
          </li>
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Suscripciones</span>
          </li>
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Exportar datos</span>
          </li>
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Hasta 20 categorías</span>
          </li>
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Análisis tendencias</span>
          </li>
        </ul>
        <button class="plan-button button-primary">Probar 7 días gratis</button>
      </div>

      <!-- Plan PRO -->
      <div class="plan-card">
        <span class="plan-badge" style="background-color: #4ECDC4;">Más Completo</span>
        <div class="plan-icon">🚀</div>
        <h2 class="plan-name">Plan PRO</h2>
        <div class="plan-price">$6.99</div>
        <div class="plan-period">/mes</div>
        <p class="plan-description">Automatización con IA</p>
        <ul class="plan-features">
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Todo de Básico +</span>
          </li>
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>IA clasificación</span>
          </li>
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Entrada por voz</span>
          </li>
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Predicciones gasto</span>
          </li>
          <li class="feature-item">
            <span class="feature-check">✓</span>
            <span>Alertas inteligentes</span>
          </li>
        </ul>
        <button class="plan-button button-outlined">Probar 7 días gratis</button>
      </div>
    </div>

    <!-- Compare Link -->
    <div class="compare-link">Ver comparación completa de planes</div>
  </div>
</body>
</html>
```

## 🚀 Usando el Skill

### Paso 1: Invocar el skill

```
Usuario: Tengo el HTML de Stitch para la pantalla de planes
[Adjunta archivo stitch-plan-selection.txt]

/convert-stitch-html
```

### Paso 2: El skill analiza

El asistente responde:
```
Analizando HTML de Stitch...

✅ Estructura detectada:
- Container principal
- Header (título + subtítulo)
- Billing toggle (Mensual/Anual)
- 3 Plan cards (FREE, BÁSICO featured, PRO)
- Compare link

✅ Componentes identificados:
- PlanCard (reutilizable)
- BillingToggle
- FeatureList
- Badge

✅ Theme extraído:
- Colores: 6 colores principales
- Tipografía: 8 variantes
- Spacing: Sistema 4pt grid
- Border radius: 8, 12, 16, 20px

Generando código React Native...
```

### Paso 3: Código generado

#### 3.1 Theme

```typescript
// src/core/theme/planSelectionTheme.ts
export const planSelectionTheme = {
  colors: {
    background: '#FFFFFF',
    backgroundSecondary: '#F8F9FA',
    textPrimary: '#2D3436',
    textSecondary: '#636E72',
    primary: '#6BCB77',
    primaryLight: '#F0FFF4',
    accent: '#4ECDC4',
    border: '#E5E5E5',
    success: '#00B894',
    successLight: '#D5F4E6',
  },
  
  typography: {
    title: { fontSize: 24, fontWeight: '700' as const },
    subtitle: { fontSize: 14, fontWeight: '400' as const },
    planName: { fontSize: 20, fontWeight: '700' as const },
    planPrice: { fontSize: 36, fontWeight: '700' as const },
    planPeriod: { fontSize: 14, fontWeight: '400' as const },
    feature: { fontSize: 14, fontWeight: '400' as const },
    button: { fontSize: 16, fontWeight: '600' as const },
    badge: { fontSize: 11, fontWeight: '600' as const },
  },
  
  spacing: { xs: 4, sm: 8, md: 12, lg: 16, xl: 24 },
  borderRadius: { sm: 8, md: 12, lg: 16, xl: 20 },
};
```

#### 3.2 Componente: BillingToggle

```typescript
// src/presentation/components/molecules/BillingToggle.tsx
import React, { memo } from 'react';
import { StyleSheet, View, TouchableOpacity, Text } from 'react-native';
import { planSelectionTheme as theme } from '../../../core/theme/planSelectionTheme';

interface BillingToggleProps {
  selectedPeriod: 'monthly' | 'annual';
  onChangePeriod: (period: 'monthly' | 'annual') => void;
}

const BillingToggle: React.FC<BillingToggleProps> = memo(({
  selectedPeriod,
  onChangePeriod,
}) => {
  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={[styles.button, selectedPeriod === 'monthly' && styles.buttonActive]}
        onPress={() => onChangePeriod('monthly')}
      >
        <Text style={[styles.text, selectedPeriod === 'monthly' && styles.textActive]}>
          Mensual
        </Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={[styles.button, selectedPeriod === 'annual' && styles.buttonActive]}
        onPress={() => onChangePeriod('annual')}
      >
        <Text style={[styles.text, selectedPeriod === 'annual' && styles.textActive]}>
          Anual
        </Text>
      </TouchableOpacity>
    </View>
  );
});

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    backgroundColor: theme.colors.backgroundSecondary,
    borderRadius: theme.borderRadius.md,
    padding: theme.spacing.xs,
    maxWidth: 300,
  },
  button: {
    flex: 1,
    paddingVertical: theme.spacing.md,
    borderRadius: theme.borderRadius.sm,
    alignItems: 'center',
  },
  buttonActive: {
    backgroundColor: theme.colors.background,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  },
  text: {
    ...theme.typography.subtitle,
    fontWeight: '600',
    color: theme.colors.textSecondary,
  },
  textActive: {
    color: theme.colors.textPrimary,
  },
});

export default BillingToggle;
```

[... más componentes generados ...]

## ✅ Resultado Final

El skill `/convert-stitch-html` te habrá generado:

1. ✅ **planSelectionTheme.ts** - Theme completo extraído del CSS
2. ✅ **BillingToggle.tsx** - Componente de toggle mensual/anual
3. ✅ **PlanCard.tsx** - Card reutilizable para cada plan
4. ✅ **PlanBadge.tsx** - Badge "Más Popular", "Más Completo"
5. ✅ **FeatureList.tsx** - Lista de features del plan
6. ✅ **PlanSelectionScreen.tsx** - Screen completa ensamblada
7. ✅ **Tipos TypeScript** - Interfaces para Plan, Feature, etc.
8. ✅ **Hooks** - usePlanSelection con lógica de state
9. ✅ **Tests básicos** - Tests de componentes principales

## 🎯 Tiempo total

- **Stitch generando HTML:** 2-3 minutos
- **Exportar a .txt:** 30 segundos
- **Skill convirtiendo:** 5-10 minutos
- **Total:** ~15 minutos

vs. Codear manualmente: **2-3 horas** ⏱️

## 💡 Próximos pasos

```bash
# Integrar con estado global
/create-hook  # Para manejo de planes y billing

# Conectar con backend
/integrate-api  # Para endpoints de subscriptions

# Agregar tests
/add-tests

# Optimizar si es necesario
/optimize-performance
```

---

**Resultado:** Pantalla de selección de planes production-ready en ~15 minutos! ✨
