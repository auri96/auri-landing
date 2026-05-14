---
name: create-screen
description: Crea screens completas en React Native con navegación, manejo de estado, integración con API, validaciones, y arquitectura Clean. Incluye setup de navegación y paso de parámetros.
---

# Create Screen Skill

Este skill te ayuda a crear screens completas en React Native siguiendo la arquitectura del proyecto Auri.

## Cuándo usar este skill

- Crear nuevas pantallas en la app
- Implementar flujos de navegación
- Screens con integración de API
- Pantallas con formularios o lógica compleja

## Proceso de creación

### 1. Análisis de la screen

Antes de crear, responde:
- ¿En qué flujo de navegación está? (Onboarding, Auth, Main, Settings)
- ¿Necesita autenticación?
- ¿Qué datos consume de la API?
- ¿Tiene formularios? ¿Qué validaciones?
- ¿Recibe parámetros de navegación?
- ¿Necesita estado global o local?

### 2. Ubicación en el proyecto

```
src/presentation/screens/
├── onboarding/     # SplashScreen, OnboardingScreen
├── auth/           # LoginScreen, RegisterScreen, ForgotPasswordScreen
├── main/           # HomeScreen, TransactionsScreen, AnalyticsScreen
├── profile/        # ProfileScreen, SettingsScreen
├── expenses/       # AddExpenseScreen, ExpenseDetailScreen
└── subscriptions/  # SubscriptionsScreen, AddSubscriptionScreen
```

### 3. Estructura de una screen

```typescript
import React, { useState, useEffect, useCallback } from 'react';
import {
  StyleSheet,
  View,
  Text,
  ScrollView,
  ActivityIndicator,
} from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import type { RouteProp } from '@react-navigation/native';

// Types
import { RootStackParamList } from '../../core/navigation/types';

// Components
import { Button, Header } from '../../components';

// Hooks
import { useAuth } from '../../hooks/useAuth';
import { useExpenses } from '../../hooks/useExpenses';

// Navigation types
type ScreenNavigationProp = NativeStackNavigationProp<
  RootStackParamList,
  'ScreenName'
>;
type ScreenRouteProp = RouteProp<RootStackParamList, 'ScreenName'>;

/**
 * ScreenName - Descripción del propósito de la pantalla
 * 
 * Funcionalidades:
 * - Feature 1
 * - Feature 2
 * - Feature 3
 */
const ScreenName: React.FC = () => {
  const navigation = useNavigation<ScreenNavigationProp>();
  const route = useRoute<ScreenRouteProp>();
  const { user } = useAuth();

  // State
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Handlers
  const handleAction = useCallback(async () => {
    try {
      setIsLoading(true);
      setError(null);
      // API call or business logic
      navigation.navigate('NextScreen');
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  }, [navigation]);

  // Effects
  useEffect(() => {
    // Load initial data
  }, []);

  if (isLoading) {
    return (
      <View style={styles.centerContainer}>
        <ActivityIndicator size="large" color="#007AFF" />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Header title="Screen Title" />
      <ScrollView style={styles.content}>
        <Text style={styles.title}>Welcome</Text>
        {error && <Text style={styles.error}>{error}</Text>}
        <Button label="Action" onPress={handleAction} />
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF',
  },
  centerContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  content: {
    flex: 1,
    padding: 16,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
    color: '#1A1A1A',
  },
  error: {
    color: '#E63946',
    marginBottom: 16,
  },
});

export default ScreenName;
```

### 4. Navegación - Setup

**Registrar en navigator:**

```typescript
// src/core/navigation/RootNavigator.tsx
import ScreenName from '../../presentation/screens/category/ScreenName';

const Stack = createStackNavigator<RootStackParamList>();

export const RootNavigator = () => (
  <Stack.Navigator>
    {/* Existing screens */}
    <Stack.Screen 
      name="ScreenName" 
      component={ScreenName}
      options={{ headerShown: false }}
    />
  </Stack.Navigator>
);
```

**Agregar tipos de navegación:**

```typescript
// src/core/navigation/types.ts
export type RootStackParamList = {
  // Existing screens
  ScreenName: { id: string; mode: 'edit' | 'view' } | undefined;
};
```

**Navegar a la screen:**

```typescript
// Navegar sin parámetros
navigation.navigate('ScreenName');

// Navegar con parámetros
navigation.navigate('ScreenName', { 
  id: '123', 
  mode: 'edit' 
});

// Reemplazar (sin posibilidad de volver)
navigation.replace('ScreenName');

// Volver atrás
navigation.goBack();
```

### 5. Manejo de estado

**Estado local (useState):**
```typescript
const [formData, setFormData] = useState({
  email: '',
  password: '',
});

const updateField = (field: string, value: string) => {
  setFormData(prev => ({ ...prev, [field]: value }));
};
```

**Custom hook para lógica compleja:**
```typescript
// src/presentation/hooks/useExpenseForm.ts
export const useExpenseForm = () => {
  const [expense, setExpense] = useState<Expense | null>(null);
  const [errors, setErrors] = useState<FormErrors>({});

  const validate = () => {
    // Validation logic
  };

  const submit = async () => {
    // Submit logic
  };

  return { expense, errors, validate, submit };
};

// En la screen
const { expense, errors, validate, submit } = useExpenseForm();
```

### 6. Integración con API

```typescript
// src/presentation/hooks/useExpenses.ts
import { useState, useCallback } from 'react';
import { expenseService } from '../../core/services/expenseService';

export const useExpenses = () => {
  const [expenses, setExpenses] = useState<Expense[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchExpenses = useCallback(async () => {
    try {
      setIsLoading(true);
      setError(null);
      const data = await expenseService.getExpenses();
      setExpenses(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const createExpense = useCallback(async (expense: CreateExpenseDto) => {
    try {
      setIsLoading(true);
      const newExpense = await expenseService.createExpense(expense);
      setExpenses(prev => [newExpense, ...prev]);
      return newExpense;
    } catch (err) {
      setError(err.message);
      throw err;
    } finally {
      setIsLoading(false);
    }
  }, []);

  return { expenses, isLoading, error, fetchExpenses, createExpense };
};
```

### 7. Validación de formularios

```typescript
interface FormErrors {
  [key: string]: string;
}

const validateForm = (): boolean => {
  const newErrors: FormErrors = {};

  if (!formData.email) {
    newErrors.email = 'El email es obligatorio';
  } else if (!isValidEmail(formData.email)) {
    newErrors.email = 'Email inválido';
  }

  if (!formData.password || formData.password.length < 8) {
    newErrors.password = 'La contraseña debe tener al menos 8 caracteres';
  }

  setErrors(newErrors);
  return Object.keys(newErrors).length === 0;
};

const handleSubmit = async () => {
  if (!validateForm()) return;
  
  try {
    await submitForm(formData);
    navigation.navigate('Success');
  } catch (err) {
    setError(err.message);
  }
};
```

### 8. Manejo de loading y errores

```typescript
// Loading state
{isLoading ? (
  <ActivityIndicator size="large" color="#007AFF" />
) : (
  <Content />
)}

// Error handling
{error && (
  <View style={styles.errorContainer}>
    <Text style={styles.errorText}>{error}</Text>
    <Button label="Reintentar" onPress={handleRetry} />
  </View>
)}

// Empty state
{!isLoading && expenses.length === 0 && (
  <View style={styles.emptyContainer}>
    <Text style={styles.emptyText}>No hay gastos registrados</Text>
    <Button label="Agregar primero" onPress={handleAdd} />
  </View>
)}
```

## Reglas obligatorias

✅ **HACER:**
- Tipo strict para navigation y route
- Separar lógica compleja en custom hooks
- Manejar estados: loading, error, empty, success
- Validar formularios antes de submit
- Usar useCallback para handlers
- Limpiar efectos con cleanup
- Documentar la screen con JSDoc

❌ **NO HACER:**
- Lógica de negocio directamente en la screen
- Llamadas API sin manejo de errores
- Navigation sin tipos
- State management desorganizado
- Inline handlers complejos

## Checklist de entrega

- [ ] Screen creada en la carpeta correcta
- [ ] Tipos de navegación definidos
- [ ] Screen registrada en navigator
- [ ] Manejo de loading, error, empty states
- [ ] Custom hooks para lógica compleja
- [ ] Validaciones de formularios (si aplica)
- [ ] Integración con API (si aplica)
- [ ] Estilos responsive
- [ ] Documentación JSDoc
- [ ] Test básico de renderizado

## Referencias

- [docs/product/frontend-integration-guide.md](../../../docs/product/frontend-integration-guide.md)
- [docs/architecture/api-reference-frontend.md](../../../docs/architecture/api-reference-frontend.md)
- [React Navigation](https://reactnavigation.org/docs/getting-started)
