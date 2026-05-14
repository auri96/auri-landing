---
name: create-hook
description: Crea custom hooks en React Native con TypeScript, separando lógica de presentación, manejo de estado, side effects, memoización, y testing. Incluye hooks para API, forms, animations, y business logic.
---

# Create Hook Skill

Este skill te ayuda a crear custom hooks reutilizables que encapsulan lógica compleja y la separan de los componentes de presentación.

## Cuándo usar este skill

- Lógica reutilizable entre múltiples componentes
- Manejo complejo de estado
- Integración con APIs
- Formularios con validaciones
- Animaciones
- Side effects complejos
- Business logic que no pertenece en componentes

## Ubicación de hooks

```
src/presentation/hooks/
├── useAuth.ts           # Autenticación y sesión
├── useExpenses.ts       # Gestión de gastos
├── useIncomes.ts        # Gestión de ingresos
├── useForm.ts           # Formularios genéricos
├── useDebounce.ts       # Utilitarios
├── useTheme.ts          # Tema y estilos
└── useAnalytics.ts      # Tracking y métricas
```

## Estructura base de un custom hook

```typescript
import { useState, useEffect, useCallback, useMemo } from 'react';

interface UseHookNameOptions {
  // Opciones de configuración
  initialValue?: string;
  onSuccess?: () => void;
  onError?: (error: Error) => void;
}

interface UseHookNameReturn {
  // Valores de retorno
  data: SomeType | null;
  isLoading: boolean;
  error: string | null;
  // Métodos
  refetch: () => Promise<void>;
  reset: () => void;
}

/**
 * useHookName - Descripción del propósito
 * 
 * @param options - Opciones de configuración
 * @returns Estado y métodos para [descripción]
 * 
 * @example
 * const { data, isLoading, error, refetch } = useHookName({
 *   initialValue: 'test',
 *   onSuccess: () => console.log('Success!'),
 * });
 */
export const useHookName = (
  options: UseHookNameOptions = {}
): UseHookNameReturn => {
  const { initialValue, onSuccess, onError } = options;

  // State
  const [data, setData] = useState<SomeType | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Methods
  const refetch = useCallback(async () => {
    try {
      setIsLoading(true);
      setError(null);
      // Lógica aquí
      const result = await fetchData();
      setData(result);
      onSuccess?.();
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Error desconocido';
      setError(errorMessage);
      onError?.(err as Error);
    } finally {
      setIsLoading(false);
    }
  }, [onSuccess, onError]);

  const reset = useCallback(() => {
    setData(null);
    setError(null);
    setIsLoading(false);
  }, []);

  // Effects
  useEffect(() => {
    // Setup inicial
    refetch();
  }, [refetch]);

  return {
    data,
    isLoading,
    error,
    refetch,
    reset,
  };
};
```

## Patrones comunes

### 1. Hook para API (Data Fetching)

```typescript
import { useState, useEffect, useCallback } from 'react';
import { expenseService } from '../../core/services/expenseService';
import type { Expense, CreateExpenseDto } from '../../core/types';

interface UseExpensesReturn {
  expenses: Expense[];
  isLoading: boolean;
  error: string | null;
  fetchExpenses: () => Promise<void>;
  createExpense: (expense: CreateExpenseDto) => Promise<Expense>;
  updateExpense: (id: string, expense: Partial<Expense>) => Promise<void>;
  deleteExpense: (id: string) => Promise<void>;
}

export const useExpenses = (): UseExpensesReturn => {
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
      setError(err instanceof Error ? err.message : 'Error al cargar gastos');
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
      setError(err instanceof Error ? err.message : 'Error al crear gasto');
      throw err;
    } finally {
      setIsLoading(false);
    }
  }, []);

  const updateExpense = useCallback(async (id: string, expense: Partial<Expense>) => {
    try {
      setIsLoading(true);
      await expenseService.updateExpense(id, expense);
      setExpenses(prev => prev.map(e => e.id === id ? { ...e, ...expense } : e));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error al actualizar gasto');
      throw err;
    } finally {
      setIsLoading(false);
    }
  }, []);

  const deleteExpense = useCallback(async (id: string) => {
    try {
      setIsLoading(true);
      await expenseService.deleteExpense(id);
      setExpenses(prev => prev.filter(e => e.id !== id));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error al eliminar gasto');
      throw err;
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchExpenses();
  }, [fetchExpenses]);

  return {
    expenses,
    isLoading,
    error,
    fetchExpenses,
    createExpense,
    updateExpense,
    deleteExpense,
  };
};
```

### 2. Hook para Forms con validación

```typescript
import { useState, useCallback } from 'react';

interface FormErrors<T> {
  [K in keyof T]?: string;
}

interface UseFormOptions<T> {
  initialValues: T;
  validate: (values: T) => FormErrors<T>;
  onSubmit: (values: T) => Promise<void>;
}

interface UseFormReturn<T> {
  values: T;
  errors: FormErrors<T>;
  isSubmitting: boolean;
  setFieldValue: (field: keyof T, value: any) => void;
  setFieldError: (field: keyof T, error: string) => void;
  handleSubmit: () => Promise<void>;
  reset: () => void;
}

export const useForm = <T extends Record<string, any>>(
  options: UseFormOptions<T>
): UseFormReturn<T> => {
  const { initialValues, validate, onSubmit } = options;

  const [values, setValues] = useState<T>(initialValues);
  const [errors, setErrors] = useState<FormErrors<T>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const setFieldValue = useCallback((field: keyof T, value: any) => {
    setValues(prev => ({ ...prev, [field]: value }));
    // Clear error when user edits
    setErrors(prev => ({ ...prev, [field]: undefined }));
  }, []);

  const setFieldError = useCallback((field: keyof T, error: string) => {
    setErrors(prev => ({ ...prev, [field]: error }));
  }, []);

  const handleSubmit = useCallback(async () => {
    // Validate
    const validationErrors = validate(values);
    
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors);
      return;
    }

    // Submit
    try {
      setIsSubmitting(true);
      await onSubmit(values);
    } catch (err) {
      // Handle submission error
      console.error('Form submission error:', err);
    } finally {
      setIsSubmitting(false);
    }
  }, [values, validate, onSubmit]);

  const reset = useCallback(() => {
    setValues(initialValues);
    setErrors({});
    setIsSubmitting(false);
  }, [initialValues]);

  return {
    values,
    errors,
    isSubmitting,
    setFieldValue,
    setFieldError,
    handleSubmit,
    reset,
  };
};

// Uso en componente
const MyForm = () => {
  const { values, errors, isSubmitting, setFieldValue, handleSubmit } = useForm({
    initialValues: {
      email: '',
      password: '',
    },
    validate: (values) => {
      const errors: FormErrors<typeof values> = {};
      if (!values.email) errors.email = 'Email requerido';
      if (!values.password) errors.password = 'Contraseña requerida';
      return errors;
    },
    onSubmit: async (values) => {
      await authService.login(values);
    },
  });

  return (
    <View>
      <Input
        value={values.email}
        onChangeText={(text) => setFieldValue('email', text)}
        error={errors.email}
      />
      <Button onPress={handleSubmit} loading={isSubmitting} />
    </View>
  );
};
```

### 3. Hook utilitario (Debounce)

```typescript
import { useState, useEffect } from 'react';

/**
 * useDebounce - Debouncea un valor
 * 
 * @param value - Valor a debouncer
 * @param delay - Delay en ms
 * @returns Valor debouncedSeñal
 * 
 * @example
 * const debouncedSearch = useDebounce(searchTerm, 500);
 * 
 * useEffect(() => {
 *   // Search con el valor debounced
 *   search(debouncedSearch);
 * }, [debouncedSearch]);
 */
export const useDebounce = <T>(value: T, delay: number = 500): T => {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(timer);
    };
  }, [value, delay]);

  return debouncedValue;
};
```

### 4. Hook para autenticación

```typescript
import { useState, useEffect, useCallback } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { authService } from '../../core/services/authService';
import type { User, LoginDto, RegisterDto } from '../../core/types';

interface UseAuthReturn {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (credentials: LoginDto) => Promise<void>;
  register: (data: RegisterDto) => Promise<void>;
  logout: () => Promise<void>;
  refreshToken: () => Promise<void>;
}

export const useAuth = (): UseAuthReturn => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const loadUser = useCallback(async () => {
    try {
      const token = await AsyncStorage.getItem('authToken');
      if (token) {
        const userData = await authService.getCurrentUser();
        setUser(userData);
      }
    } catch (err) {
      console.error('Error loading user:', err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const login = useCallback(async (credentials: LoginDto) => {
    try {
      const { user, token } = await authService.login(credentials);
      await AsyncStorage.setItem('authToken', token);
      setUser(user);
    } catch (err) {
      throw err;
    }
  }, []);

  const register = useCallback(async (data: RegisterDto) => {
    try {
      const { user, token } = await authService.register(data);
      await AsyncStorage.setItem('authToken', token);
      setUser(user);
    } catch (err) {
      throw err;
    }
  }, []);

  const logout = useCallback(async () => {
    try {
      await AsyncStorage.removeItem('authToken');
      setUser(null);
    } catch (err) {
      console.error('Error logging out:', err);
    }
  }, []);

  const refreshToken = useCallback(async () => {
    try {
      const { token } = await authService.refreshToken();
      await AsyncStorage.setItem('authToken', token);
    } catch (err) {
      // Token refresh failed, logout
      await logout();
    }
  }, [logout]);

  useEffect(() => {
    loadUser();
  }, [loadUser]);

  return {
    user,
    isAuthenticated: !!user,
    isLoading,
    login,
    register,
    logout,
    refreshToken,
  };
};
```

## Reglas obligatorias

✅ **HACER:**
- Tipar correctamente con TypeScript (params, return, state)
- Usar useCallback para funciones que se pasan como deps
- Usar useMemo para cálculos costosos
- Documentar con JSDoc
- Manejar cleanup en useEffect cuando sea necesario
- Exportar interfaces de tipos
- Nombrar hooks con prefijo "use"

❌ **NO HACER:**
- Hooks que llaman a otros hooks condicionalmente
- Hooks con demasiadas responsabilidades
- Estado global innecesario
- Lógica de UI dentro de hooks
- Efectos sin array de dependencias
- any en TypeScript

## Testing de hooks

```typescript
// __tests__/hooks/useExpenses.test.ts
import { renderHook, act } from '@testing-library/react-hooks';
import { useExpenses } from '../useExpenses';
import { expenseService } from '../../core/services/expenseService';

jest.mock('../../core/services/expenseService');

describe('useExpenses', () => {
  it('should fetch expenses on mount', async () => {
    const mockExpenses = [{ id: '1', amount: 100 }];
    (expenseService.getExpenses as jest.Mock).mockResolvedValue(mockExpenses);

    const { result, waitForNextUpdate } = renderHook(() => useExpenses());

    expect(result.current.isLoading).toBe(true);

    await waitForNextUpdate();

    expect(result.current.expenses).toEqual(mockExpenses);
    expect(result.current.isLoading).toBe(false);
  });

  it('should create expense', async () => {
    const newExpense = { description: 'Test', amount: 50 };
    const createdExpense = { id: '2', ...newExpense };
    
    (expenseService.createExpense as jest.Mock).mockResolvedValue(createdExpense);

    const { result } = renderHook(() => useExpenses());

    await act(async () => {
      await result.current.createExpense(newExpense);
    });

    expect(result.current.expenses).toContain(createdExpense);
  });
});
```

## Checklist de entrega

- [ ] Hook tipado correctamente con TypeScript
- [ ] Documentación JSDoc completa
- [ ] useCallback/useMemo donde corresponda
- [ ] Manejo de errores robusto
- [ ] Cleanup de effects cuando sea necesario
- [ ] Tests unitarios básicos
- [ ] Ejemplo de uso documentado
- [ ] Exportado desde index.ts

## Referencias

- [React Hooks Documentation](https://react.dev/reference/react)
- [TypeScript with React Hooks](https://react-typescript-cheatsheet.netlify.app/docs/basic/getting-started/hooks)
- [Testing Hooks](https://react-hooks-testing-library.com/)
