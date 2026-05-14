---
name: add-tests
description: Genera tests unitarios, de integración y de componentes para React Native con Jest y React Testing Library. Incluye mocks, coverage, y best practices para aplicaciones fintech.
---

# Add Tests Skill

Este skill te ayuda a crear tests completos y robustos para componentes, hooks, servicios y lógica de negocio en React Native.

## Setup del proyecto

```json
// package.json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  },
  "jest": {
    "preset": "react-native",
    "setupFilesAfterEnv": ["<rootDir>/jest.setup.js"],
    "transformIgnorePatterns": [
      "node_modules/(?!(react-native|@react-native|@react-navigation)/)"
    ],
    "collectCoverageFrom": [
      "src/**/*.{ts,tsx}",
      "!src/**/*.d.ts",
      "!src/**/index.ts"
    ]
  }
}
```

```javascript
// jest.setup.js
import '@testing-library/jest-native/extend-expect';

// Mock AsyncStorage
jest.mock('@react-native-async-storage/async-storage', () =>
  require('@react-native-async-storage/async-storage/jest/async-storage-mock')
);

// Mock navigation
jest.mock('@react-navigation/native', () => ({
  useNavigation: () => ({
    navigate: jest.fn(),
    goBack: jest.fn(),
  }),
  useRoute: () => ({
    params: {},
  }),
}));
```

## Estructura de tests

```
__tests__/
├── components/
│   ├── atoms/
│   │   └── Button.test.tsx
│   ├── molecules/
│   │   └── FormField.test.tsx
│   └── organisms/
│       └── TransactionList.test.tsx
├── hooks/
│   ├── useAuth.test.ts
│   └── useExpenses.test.ts
├── services/
│   └── expenseService.test.ts
└── screens/
    └── LoginScreen.test.tsx
```

## 1. Testing de componentes

### Componente simple (Button)

```typescript
// __tests__/components/atoms/Button.test.tsx
import React from 'react';
import { render, fireEvent } from '@testing-library/react-native';
import Button from '../../../src/presentation/components/atoms/Button';

describe('Button', () => {
  it('renders correctly with label', () => {
    const { getByText } = render(<Button label="Click me" onPress={() => {}} />);
    expect(getByText('Click me')).toBeTruthy();
  });

  it('calls onPress when pressed', () => {
    const mockOnPress = jest.fn();
    const { getByText } = render(<Button label="Click me" onPress={mockOnPress} />);
    
    fireEvent.press(getByText('Click me'));
    
    expect(mockOnPress).toHaveBeenCalledTimes(1);
  });

  it('is disabled when disabled prop is true', () => {
    const mockOnPress = jest.fn();
    const { getByText } = render(
      <Button label="Click me" onPress={mockOnPress} disabled={true} />
    );
    
    const button = getByText('Click me').parent;
    expect(button).toBeDisabled();
    
    fireEvent.press(getByText('Click me'));
    expect(mockOnPress).not.toHaveBeenCalled();
  });

  it('shows loading indicator when loading', () => {
    const { getByTestId, queryByText } = render(
      <Button label="Click me" onPress={() => {}} loading={true} />
    );
    
    expect(queryByText('Click me')).toBeNull();
    expect(getByTestId('loading-indicator')).toBeTruthy();
  });

  it('applies correct styles for variant', () => {
    const { getByText } = render(
      <Button label="Primary" onPress={() => {}} variant="primary" />
    );
    
    const button = getByText('Primary').parent;
    expect(button).toHaveStyle({ backgroundColor: '#007AFF' });
  });
});
```

### Componente con estado (Input)

```typescript
// __tests__/components/atoms/Input.test.tsx
import React from 'react';
import { render, fireEvent } from '@testing-library/react-native';
import Input from '../../../src/presentation/components/atoms/Input';

describe('Input', () => {
  it('renders with placeholder', () => {
    const { getByPlaceholderText } = render(
      <Input placeholder="Enter email" value="" onChangeText={() => {}} />
    );
    expect(getByPlaceholderText('Enter email')).toBeTruthy();
  });

  it('calls onChangeText when text changes', () => {
    const mockOnChangeText = jest.fn();
    const { getByPlaceholderText } = render(
      <Input placeholder="Email" value="" onChangeText={mockOnChangeText} />
    );
    
    fireEvent.changeText(getByPlaceholderText('Email'), 'test@example.com');
    
    expect(mockOnChangeText).toHaveBeenCalledWith('test@example.com');
  });

  it('displays error message when error prop is provided', () => {
    const { getByText } = render(
      <Input 
        placeholder="Email" 
        value="" 
        onChangeText={() => {}} 
        error="Invalid email"
      />
    );
    
    expect(getByText('Invalid email')).toBeTruthy();
  });

  it('toggles password visibility', () => {
    const { getByPlaceholderText, getByTestId } = render(
      <Input 
        placeholder="Password" 
        value="" 
        onChangeText={() => {}} 
        secureTextEntry={true}
      />
    );
    
    const input = getByPlaceholderText('Password');
    const toggleButton = getByTestId('toggle-password');
    
    expect(input.props.secureTextEntry).toBe(true);
    
    fireEvent.press(toggleButton);
    
    expect(input.props.secureTextEntry).toBe(false);
  });
});
```

## 2. Testing de hooks

### Hook con API (useExpenses)

```typescript
// __tests__/hooks/useExpenses.test.ts
import { renderHook, act, waitFor } from '@testing-library/react-native';
import { useExpenses } from '../../src/presentation/hooks/useExpenses';
import { expenseService } from '../../src/core/services/expenseService';

// Mock del servicio
jest.mock('../../src/core/services/expenseService');

const mockExpenses = [
  {
    id: '1',
    description: 'Grocery',
    amount: 50,
    date: '2026-03-20',
    categoryId: 'cat1',
  },
  {
    id: '2',
    description: 'Gas',
    amount: 30,
    date: '2026-03-21',
    categoryId: 'cat2',
  },
];

describe('useExpenses', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('fetches expenses on mount', async () => {
    (expenseService.getExpenses as jest.Mock).mockResolvedValue({
      data: mockExpenses,
      meta: { total: 2, page: 1, limit: 10, totalPages: 1 },
    });

    const { result } = renderHook(() => useExpenses());

    expect(result.current.isLoading).toBe(true);

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false);
    });

    expect(result.current.expenses).toEqual(mockExpenses);
    expect(result.current.error).toBeNull();
  });

  it('handles error when fetching fails', async () => {
    const errorMessage = 'Network error';
    (expenseService.getExpenses as jest.Mock).mockRejectedValue(
      new Error(errorMessage)
    );

    const { result } = renderHook(() => useExpenses());

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false);
    });

    expect(result.current.error).toBe(errorMessage);
    expect(result.current.expenses).toEqual([]);
  });

  it('creates expense successfully', async () => {
    const newExpense = {
      description: 'Coffee',
      amount: 5,
      date: '2026-03-22',
      categoryId: 'cat3',
    };

    const createdExpense = { id: '3', ...newExpense };

    (expenseService.createExpense as jest.Mock).mockResolvedValue(createdExpense);

    const { result } = renderHook(() => useExpenses());

    await act(async () => {
      await result.current.createExpense(newExpense);
    });

    expect(result.current.expenses).toContainEqual(createdExpense);
    expect(expenseService.createExpense).toHaveBeenCalledWith(newExpense);
  });

  it('deletes expense successfully', async () => {
    (expenseService.getExpenses as jest.Mock).mockResolvedValue({
      data: mockExpenses,
      meta: { total: 2, page: 1, limit: 10, totalPages: 1 },
    });
    (expenseService.deleteExpense as jest.Mock).mockResolvedValue(undefined);

    const { result } = renderHook(() => useExpenses());

    await waitFor(() => {
      expect(result.current.expenses).toEqual(mockExpenses);
    });

    await act(async () => {
      await result.current.deleteExpense('1');
    });

    expect(result.current.expenses).not.toContainEqual(mockExpenses[0]);
    expect(result.current.expenses.length).toBe(1);
  });
});
```

## 3. Testing de servicios

```typescript
// __tests__/services/expenseService.test.ts
import { expenseService } from '../../src/core/services/expenseService';
import { apiClient } from '../../src/core/services/api/client';

jest.mock('../../src/core/services/api/client');

const mockExpenses = [
  { id: '1', description: 'Test', amount: 100 },
];

describe('ExpenseService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('getExpenses', () => {
    it('calls API with correct endpoint', async () => {
      (apiClient.get as jest.Mock).mockResolvedValue({
        data: mockExpenses,
        meta: { total: 1 },
      });

      await expenseService.getExpenses();

      expect(apiClient.get).toHaveBeenCalledWith('/expenses');
    });

    it('passes filters as query params', async () => {
      (apiClient.get as jest.Mock).mockResolvedValue({
        data: mockExpenses,
        meta: { total: 1 },
      });

      await expenseService.getExpenses({
        startDate: '2026-03-01',
        endDate: '2026-03-31',
        categoryId: 'cat1',
      });

      expect(apiClient.get).toHaveBeenCalledWith(
        '/expenses?startDate=2026-03-01&endDate=2026-03-31&categoryId=cat1'
      );
    });
  });

  describe('createExpense', () => {
    it('calls API with correct data', async () => {
      const newExpense = {
        description: 'New expense',
        amount: 50,
        categoryId: 'cat1',
        paymentMethodId: 'pm1',
        date: '2026-03-20',
      };

      (apiClient.post as jest.Mock).mockResolvedValue({
        id: '1',
        ...newExpense,
      });

      const result = await expenseService.createExpense(newExpense);

      expect(apiClient.post).toHaveBeenCalledWith('/expenses', newExpense);
      expect(result).toEqual({ id: '1', ...newExpense });
    });
  });
});
```

## 4. Testing de screens

```typescript
// __tests__/screens/LoginScreen.test.tsx
import React from 'react';
import { render, fireEvent, waitFor } from '@testing-library/react-native';
import LoginScreen from '../../src/presentation/screens/auth/LoginScreen';
import { useAuth } from '../../src/presentation/hooks/useAuth';

jest.mock('../../src/presentation/hooks/useAuth');

const mockNavigate = jest.fn();
jest.mock('@react-navigation/native', () => ({
  useNavigation: () => ({ navigate: mockNavigate }),
}));

describe('LoginScreen', () => {
  const mockLogin = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
    (useAuth as jest.Mock).mockReturnValue({
      login: mockLogin,
      isLoading: false,
      error: null,
    });
  });

  it('renders login form', () => {
    const { getByPlaceholderText, getByText } = render(<LoginScreen />);

    expect(getByPlaceholderText('Email')).toBeTruthy();
    expect(getByPlaceholderText('Password')).toBeTruthy();
    expect(getByText('Iniciar Sesión')).toBeTruthy();
  });

  it('validates email format', async () => {
    const { getByPlaceholderText, getByText, findByText } = render(<LoginScreen />);

    fireEvent.changeText(getByPlaceholderText('Email'), 'invalid-email');
    fireEvent.changeText(getByPlaceholderText('Password'), 'password123');
    fireEvent.press(getByText('Iniciar Sesión'));

    expect(await findByText('Email inválido')).toBeTruthy();
    expect(mockLogin).not.toHaveBeenCalled();
  });

  it('validates required fields', async () => {
    const { getByText, findByText } = render(<LoginScreen />);

    fireEvent.press(getByText('Iniciar Sesión'));

    expect(await findByText('El email es obligatorio')).toBeTruthy();
    expect(await findByText('La contraseña es obligatoria')).toBeTruthy();
  });

  it('calls login with correct credentials', async () => {
    const { getByPlaceholderText, getByText } = render(<LoginScreen />);

    fireEvent.changeText(getByPlaceholderText('Email'), 'test@example.com');
    fireEvent.changeText(getByPlaceholderText('Password'), 'password123');
    fireEvent.press(getByText('Iniciar Sesión'));

    await waitFor(() => {
      expect(mockLogin).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
      });
    });
  });

  it('displays error message on login failure', async () => {
    const errorMessage = 'Invalid credentials';
    (useAuth as jest.Mock).mockReturnValue({
      login: mockLogin,
      isLoading: false,
      error: errorMessage,
    });

    const { getByText } = render(<LoginScreen />);

    expect(getByText(errorMessage)).toBeTruthy();
  });

  it('navigates to home on successful login', async () => {
    mockLogin.mockResolvedValue({ success: true });

    const { getByPlaceholderText, getByText } = render(<LoginScreen />);

    fireEvent.changeText(getByPlaceholderText('Email'), 'test@example.com');
    fireEvent.changeText(getByPlaceholderText('Password'), 'password123');
    fireEvent.press(getByText('Iniciar Sesión'));

    await waitFor(() => {
      expect(mockNavigate).toHaveBeenCalledWith('Home');
    });
  });
});
```

## Best practices

✅ **HACER:**
- Test behavior, no implementation
- Usar data-testid para elementos complejos
- Limpiar mocks en beforeEach
- Test casos edge: empty states, errors, loading
- Alcanzar >80% code coverage en lógica crítica
- Test user flows completos

❌ **NO HACER:**
- Test implementation details
- Snapshots sin justificación
- Ignorar async operations
- Hardcodear datos de test
- Test todo (focus en lógica crítica)

## Checklist de testing

- [ ] Tests de componentes (render, interacción, states)
- [ ] Tests de hooks (lifecycle, side effects, state changes)
- [ ] Tests de servicios (API calls, error handling)
- [ ] Tests de screens (user flows, navigation, validación)
- [ ] Mocks configurados correctamente
- [ ] Coverage >80% en lógica crítica
- [ ] Tests pasan en CI/CD

## Referencias

- [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)
- [Jest Documentation](https://jestjs.io/docs/getting-started)
- [Testing React Native](https://reactnative.dev/docs/testing-overview)
