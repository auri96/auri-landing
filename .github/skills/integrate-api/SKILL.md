---
name: integrate-api
description: Integra endpoints del backend con el frontend React Native. Incluye configuración de servicios, manejo de autenticación, errores, retries, caching, y TypeScript. Referencia api-reference-frontend.md para endpoints disponibles.
---

# Integrate API Skill

Este skill te ayuda a integrar endpoints del backend con React Native de forma segura, eficiente y con manejo robusto de errores.

## Antes de comenzar

**SIEMPRE lee estos archivos primero:**
1. `/docs/architecture/api-reference-frontend.md` - Endpoints disponibles
2. `/docs/product/frontend-integration-guide.md` - Guía de integración
3. `/docs/product/BACKEND_PROGRESS.md` - Estado actual del backend

## Estructura de servicios

```
src/core/services/
├── api/
│   ├── client.ts           # Cliente HTTP configurado (axios/fetch)
│   ├── interceptors.ts     # Interceptors para auth, errors, retry
│   └── types.ts            # Tipos de request/response
├── authService.ts          # Autenticación
├── expenseService.ts       # Gastos
├── incomeService.ts        # Ingresos
├── subscriptionService.ts  # Suscripciones
└── userService.ts          # Usuario y perfil
```

## 1. Configuración del cliente HTTP

```typescript
// src/core/services/api/client.ts
import axios, { AxiosInstance, AxiosError } from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { API_CONFIG } from '../../config';

class ApiClient {
  private client: AxiosInstance;

  constructor() {
    this.client = axios.create({
      baseURL: API_CONFIG.baseURL,
      timeout: API_CONFIG.timeout,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    this.setupInterceptors();
  }

  private setupInterceptors() {
    // Request interceptor - Add auth token
    this.client.interceptors.request.use(
      async (config) => {
        const token = await AsyncStorage.getItem('authToken');
        if (token) {
          config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
      },
      (error) => Promise.reject(error)
    );

    // Response interceptor - Handle errors
    this.client.interceptors.response.use(
      (response) => response,
      async (error: AxiosError) => {
        if (error.response?.status === 401) {
          // Token expirado, intentar refresh
          try {
            await this.refreshToken();
            // Retry original request
            return this.client.request(error.config!);
          } catch (refreshError) {
            // Refresh falló, logout
            await this.handleLogout();
            throw refreshError;
          }
        }
        
        return Promise.reject(this.normalizeError(error));
      }
    );
  }

  private normalizeError(error: AxiosError): Error {
    if (error.response) {
      // Server respondió con error
      const message = (error.response.data as any)?.message || 'Error del servidor';
      return new Error(message);
    } else if (error.request) {
      // Request enviado pero sin respuesta
      return new Error('Sin conexión al servidor');
    } else {
      // Error en setup del request
      return new Error(error.message);
    }
  }

  private async refreshToken() {
    const refreshToken = await AsyncStorage.getItem('refreshToken');
    const response = await this.client.post('/auth/refresh', { refreshToken });
    const { token } = response.data;
    await AsyncStorage.setItem('authToken', token);
  }

  private async handleLogout() {
    await AsyncStorage.multiRemove(['authToken', 'refreshToken']);
    // Navigate to login (implement navigation service)
  }

  // HTTP Methods
  async get<T>(url: string, config = {}): Promise<T> {
    const response = await this.client.get<T>(url, config);
    return response.data;
  }

  async post<T>(url: string, data?: any, config = {}): Promise<T> {
    const response = await this.client.post<T>(url, data, config);
    return response.data;
  }

  async put<T>(url: string, data?: any, config = {}): Promise<T> {
    const response = await this.client.put<T>(url, data, config);
    return response.data;
  }

  async patch<T>(url: string, data?: any, config = {}): Promise<T> {
    const response = await this.client.patch<T>(url, data, config);
    return response.data;
  }

  async delete<T>(url: string, config = {}): Promise<T> {
    const response = await this.client.delete<T>(url, config);
    return response.data;
  }
}

export const apiClient = new ApiClient();
```

## 2. Crear un servicio específico

```typescript
// src/core/services/expenseService.ts
import { apiClient } from './api/client';
import type { 
  Expense, 
  CreateExpenseDto, 
  UpdateExpenseDto,
  PaginatedResponse,
  ExpenseFilters 
} from '../types';

class ExpenseService {
  private readonly basePath = '/expenses';

  /**
   * Obtener todos los gastos con filtros opcionales
   */
  async getExpenses(filters?: ExpenseFilters): Promise<PaginatedResponse<Expense>> {
    const params = new URLSearchParams();
    
    if (filters?.startDate) params.append('startDate', filters.startDate);
    if (filters?.endDate) params.append('endDate', filters.endDate);
    if (filters?.categoryId) params.append('categoryId', filters.categoryId);
    if (filters?.page) params.append('page', filters.page.toString());
    if (filters?.limit) params.append('limit', filters.limit.toString());

    const queryString = params.toString();
    const url = queryString ? `${this.basePath}?${queryString}` : this.basePath;

    return apiClient.get<PaginatedResponse<Expense>>(url);
  }

  /**
   * Obtener un gasto por ID
   */
  async getExpenseById(id: string): Promise<Expense> {
    return apiClient.get<Expense>(`${this.basePath}/${id}`);
  }

  /**
   * Crear un nuevo gasto
   */
  async createExpense(expense: CreateExpenseDto): Promise<Expense> {
    return apiClient.post<Expense>(this.basePath, expense);
  }

  /**
   * Actualizar un gasto existente
   */
  async updateExpense(id: string, expense: UpdateExpenseDto): Promise<Expense> {
    return apiClient.patch<Expense>(`${this.basePath}/${id}`, expense);
  }

  /**
   * Eliminar un gasto
   */
  async deleteExpense(id: string): Promise<void> {
    return apiClient.delete<void>(`${this.basePath}/${id}`);
  }

  /**
   * Obtener estadísticas de gastos
   */
  async getExpenseStats(startDate: string, endDate: string) {
    return apiClient.get(`${this.basePath}/stats`, {
      params: { startDate, endDate },
    });
  }

  /**
   * Clasificar gastos automáticamente con IA
   */
  async classifyExpense(description: string): Promise<{ categoryId: string }> {
    return apiClient.post(`${this.basePath}/classify`, { description });
  }
}

export const expenseService = new ExpenseService();
```

## 3. Definir tipos TypeScript

```typescript
// src/core/types/expense.ts
export interface Expense {
  id: string;
  userId: string;
  amount: number;
  description: string;
  categoryId: string;
  category?: Category;
  paymentMethodId: string;
  paymentMethod?: PaymentMethod;
  date: string;
  isRecurring: boolean;
  recurrencePattern?: RecurrencePattern;
  tags?: string[];
  notes?: string;
  createdAt: string;
  updatedAt: string;
}

export interface CreateExpenseDto {
  amount: number;
  description: string;
  categoryId: string;
  paymentMethodId: string;
  date: string;
  isRecurring?: boolean;
  recurrencePattern?: RecurrencePattern;
  tags?: string[];
  notes?: string;
}

export interface UpdateExpenseDto extends Partial<CreateExpenseDto> {}

export interface ExpenseFilters {
  startDate?: string;
  endDate?: string;
  categoryId?: string;
  page?: number;
  limit?: number;
}

export interface PaginatedResponse<T> {
  data: T[];
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}
```

## 4. Usar en custom hook

```typescript
// src/presentation/hooks/useExpenses.ts
import { useState, useCallback } from 'react';
import { expenseService } from '../../core/services/expenseService';
import type { Expense, CreateExpenseDto, ExpenseFilters } from '../../core/types';

export const useExpenses = () => {
  const [expenses, setExpenses] = useState<Expense[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchExpenses = useCallback(async (filters?: ExpenseFilters) => {
    try {
      setIsLoading(true);
      setError(null);
      const response = await expenseService.getExpenses(filters);
      setExpenses(response.data);
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

  return {
    expenses,
    isLoading,
    error,
    fetchExpenses,
    createExpense,
  };
};
```

## 5. Usar en componente

```typescript
// src/presentation/screens/expenses/ExpensesScreen.tsx
import React, { useEffect } from 'react';
import { View, FlatList, ActivityIndicator } from 'react-native';
import { useExpenses } from '../../hooks/useExpenses';
import { ExpenseCard } from '../../components';

const ExpensesScreen: React.FC = () => {
  const { expenses, isLoading, error, fetchExpenses } = useExpenses();

  useEffect(() => {
    fetchExpenses({
      startDate: '2026-03-01',
      endDate: '2026-03-31',
    });
  }, [fetchExpenses]);

  if (isLoading) {
    return <ActivityIndicator size="large" />;
  }

  if (error) {
    return <Text>Error: {error}</Text>;
  }

  return (
    <FlatList
      data={expenses}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => <ExpenseCard expense={item} />}
    />
  );
};
```

## Manejo de errores avanzado

```typescript
// src/core/services/api/errorHandler.ts
export class ApiError extends Error {
  constructor(
    message: string,
    public statusCode?: number,
    public code?: string
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

export const handleApiError = (error: any): never => {
  if (error.response) {
    const { status, data } = error.response;
    
    switch (status) {
      case 400:
        throw new ApiError(data.message || 'Solicitud inválida', 400, 'BAD_REQUEST');
      case 401:
        throw new ApiError('No autorizado', 401, 'UNAUTHORIZED');
      case 403:
        throw new ApiError('Prohibido', 403, 'FORBIDDEN');
      case 404:
        throw new ApiError('Recurso no encontrado', 404, 'NOT_FOUND');
      case 422:
        throw new ApiError(data.message || 'Validación fallida', 422, 'VALIDATION_ERROR');
      case 500:
        throw new ApiError('Error del servidor', 500, 'SERVER_ERROR');
      default:
        throw new ApiError(data.message || 'Error desconocido', status);
    }
  }
  
  if (error.request) {
    throw new ApiError('Sin conexión al servidor', undefined, 'NETWORK_ERROR');
  }
  
  throw new ApiError(error.message || 'Error desconocido');
};
```

## Caching con React Query (Opcional pero recomendado)

```typescript
// src/presentation/hooks/useExpenses.ts (con React Query)
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { expenseService } from '../../core/services/expenseService';

export const useExpenses = (filters?: ExpenseFilters) => {
  const queryClient = useQueryClient();

  // GET expenses
  const {
    data: expenses,
    isLoading,
    error,
    refetch,
  } = useQuery({
    queryKey: ['expenses', filters],
    queryFn: () => expenseService.getExpenses(filters),
    staleTime: 5 * 60 * 1000, // 5 minutos
  });

  // CREATE expense
  const createExpenseMutation = useMutation({
    mutationFn: expenseService.createExpense,
    onSuccess: () => {
      // Invalidar cache para refetch automático
      queryClient.invalidateQueries({ queryKey: ['expenses'] });
    },
  });

  // DELETE expense
  const deleteExpenseMutation = useMutation({
    mutationFn: expenseService.deleteExpense,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['expenses'] });
    },
  });

  return {
    expenses: expenses?.data || [],
    isLoading,
    error,
    refetch,
    createExpense: createExpenseMutation.mutate,
    deleteExpense: deleteExpenseMutation.mutate,
  };
};
```

## Configuración de ambiente

```typescript
// src/core/config/api.ts
const ENV = {
  development: {
    baseURL: 'http://localhost:3000/api',
    timeout: 10000,
  },
  staging: {
    baseURL: 'https://staging-api.auri.app/api',
    timeout: 15000,
  },
  production: {
    baseURL: 'https://api.auri.app/api',
    timeout: 15000,
  },
};

const currentEnv = __DEV__ ? 'development' : 'production';

export const API_CONFIG = ENV[currentEnv];
```

## Checklist de integración

- [ ] Cliente HTTP configurado con interceptors
- [ ] Autenticación con tokens implementada
- [ ] Refresh token automático
- [ ] Tipos TypeScript completos (request + response)
- [ ] Servicio específico creado
- [ ] Custom hook para usar el servicio
- [ ] Manejo de errores robusto
- [ ] Loading y error states
- [ ] Tested en componente real
- [ ] Documentado con JSDoc

## Errores comunes

❌ **NO hacer:**
- Llamadas API directamente en componentes
- Ignorar manejo de errores
- No tipar requests/responses
- No manejar estados de loading
- Hardcodear URLs

✅ **SÍ hacer:**
- Centralizar lógica de API en servicios
- Manejar todos los casos de error
- Tipar todo con TypeScript
- Usar custom hooks
- Configuración por ambiente

## Referencias

- [docs/architecture/api-reference-frontend.md](../../../docs/architecture/api-reference-frontend.md)
- [docs/product/frontend-integration-guide.md](../../../docs/product/frontend-integration-guide.md)
- [Axios Documentation](https://axios-http.com/)
- [React Query](https://tanstack.com/query/latest)
