---
name: create-component
description: Crea componentes React Native siguiendo Clean Architecture, TypeScript strict, separación de responsabilidades, optimización de renders, y estándares del proyecto fintech.
---

# Create Component Skill

Este skill te ayuda a crear componentes React Native que siguen las mejores prácticas del proyecto Auri.

## Cuándo usar este skill

- Crear nuevos componentes UI reutilizables
- Implementar componentes de presentación sin lógica de negocio
- Crear componentes atómicos, moleculares o de organismo
- Necesitas un componente con TypeScript strict y optimizado

## Proceso de creación

### 1. Análisis del componente

Antes de crear el componente, pregunta:
- ¿Qué tipo de componente es? (atómico, molecular, organismo)
- ¿Acepta props? ¿Cuáles son obligatorias y opcionales?
- ¿Necesita estado interno?
- ¿Tiene lógica compleja que debería estar en un custom hook?
- ¿Necesita memo para optimización?

### 2. Ubicación en el proyecto

```
src/presentation/components/
├── atoms/          # Componentes básicos (Button, Input, Text, Icon)
├── molecules/      # Combinación de átomos (FormField, Card, ListItem)
├── organisms/      # Componentes complejos (Header, TransactionList, Chart)
└── templates/      # Layouts de páginas
```

### 3. Estructura del componente

```typescript
import React, { memo } from 'react';
import { StyleSheet, View, Text } from 'react-native';

// Types/Interfaces
interface ComponentNameProps {
  title: string;
  onPress?: () => void;
  isActive?: boolean;
  // Siempre documenta props complejas
}

/**
 * ComponentName - Descripción breve del propósito
 * 
 * @example
 * <ComponentName title="Ejemplo" onPress={handlePress} />
 */
const ComponentName: React.FC<ComponentNameProps> = memo(({
  title,
  onPress,
  isActive = false,
}) => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{title}</Text>
    </View>
  );
});

ComponentName.displayName = 'ComponentName';

const styles = StyleSheet.create({
  container: {
    padding: 16,
    backgroundColor: '#FFFFFF',
  },
  title: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1A1A1A',
  },
});

export default ComponentName;
```

### 4. Reglas obligatorias

✅ **HACER:**
- Usar TypeScript con interfaces explícitas
- Usar `memo()` para componentes de presentación
- Extraer estilos a `StyleSheet.create()`
- Documentar componentes con JSDoc
- Usar valores por defecto en destructuring
- Nombrar componentes con PascalCase
- Exportar como default
- Agregar `displayName` al componente

❌ **NO HACER:**
- Mezclar lógica de negocio en componentes de presentación
- Inline styles (usar StyleSheet)
- Usar `any` en TypeScript
- Props opcionales sin valores por defecto
- Re-renders innecesarios (usar memo, useMemo, useCallback)
- Componentes gigantes (máximo 200 líneas, refactorizar)

### 5. Optimización de renders

**Cuándo usar `memo()`:**
- Componentes de presentación pura
- Componentes que reciben las mismas props frecuentemente
- Listas con muchos items

**Cuándo NO usar `memo()`:**
- Componentes que siempre reciben props diferentes
- Component simple sin re-renders problemáticos
- Optimización prematura

### 6. Testing

Siempre crea un test básico:

```typescript
// __tests__/components/ComponentName.test.tsx
import React from 'react';
import { render } from '@testing-library/react-native';
import ComponentName from '../ComponentName';

describe('ComponentName', () => {
  it('renders correctly', () => {
    const { getByText } = render(<ComponentName title="Test" />);
    expect(getByText('Test')).toBeTruthy();
  });

  it('calls onPress when pressed', () => {
    const mockOnPress = jest.fn();
    const { getByText } = render(
      <ComponentName title="Test" onPress={mockOnPress} />
    );
    // Add press test
  });
});
```

### 7. Documentación

Agrega comentarios JSDoc:
```typescript
/**
 * Button component for primary actions
 * 
 * @param {string} label - Button text
 * @param {function} onPress - Callback when pressed
 * @param {boolean} disabled - Whether button is disabled
 * @param {string} variant - Button style variant (primary, secondary, outline)
 * 
 * @example
 * <Button 
 *   label="Guardar" 
 *   onPress={handleSave}
 *   variant="primary"
 * />
 */
```

## Checklist de entrega

Antes de finalizar, verifica:
- [ ] Componente creado en la carpeta correcta (atoms/molecules/organisms)
- [ ] TypeScript sin errores
- [ ] Interfaces/Types definidos correctamente
- [ ] Props documentadas con JSDoc
- [ ] Estilos en StyleSheet
- [ ] memo() aplicado si es necesario
- [ ] displayName configurado
- [ ] Test básico creado
- [ ] Ejemplo de uso documentado

## Patrones comunes

### Componente con children
```typescript
interface ContainerProps {
  children: React.ReactNode;
  padding?: number;
}

const Container: React.FC<ContainerProps> = memo(({ children, padding = 16 }) => (
  <View style={[styles.container, { padding }]}>
    {children}
  </View>
));
```

### Componente con variantes
```typescript
interface ButtonProps {
  variant: 'primary' | 'secondary' | 'outline';
  label: string;
  onPress: () => void;
}

const Button: React.FC<ButtonProps> = memo(({ variant, label, onPress }) => (
  <TouchableOpacity 
    style={[styles.button, styles[variant]]}
    onPress={onPress}
  >
    <Text style={styles.label}>{label}</Text>
  </TouchableOpacity>
));
```

### Componente con estado interno
```typescript
const ExpandableCard: React.FC<ExpandableCardProps> = memo(({ title, children }) => {
  const [isExpanded, setIsExpanded] = useState(false);

  const toggleExpanded = useCallback(() => {
    setIsExpanded(prev => !prev);
  }, []);

  return (
    <View style={styles.card}>
      <TouchableOpacity onPress={toggleExpanded}>
        <Text>{title}</Text>
      </TouchableOpacity>
      {isExpanded && children}
    </View>
  );
});
```

## Integración con el sistema

Después de crear el componente:
1. Exportarlo desde `index.ts` de su categoría
2. Agregar storybook entry si existe
3. Actualizar documentación de componentes
4. Notificar al equipo de diseño

## Referencias

- [docs/architecture/project-structure.md](../../../docs/architecture/project-structure.md)
- [React Native Performance](https://reactnative.dev/docs/performance)
- [TypeScript Best Practices](https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html)
