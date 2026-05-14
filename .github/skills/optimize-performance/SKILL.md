---
name: optimize-performance
description: Analiza y optimiza el rendimiento de componentes React Native. Identifica re-renders innecesarios, memory leaks, navigation lags, list performance issues. Usa React DevTools, Flipper, y profiling tools.
---

# Optimize Performance Skill

Este skill te ayuda a identificar y solucionar problemas de performance en React Native, desde re-renders innecesarios hasta optimización de listas y navegación.

## Herramientas de profiling

### 1. React DevTools Profiler
- Identifica componentes que re-renderizan frecuentemente
- Mide tiempo de render
- Detecta cascadas de renders

### 2. Flipper + React Native Performance Plugin
- Monitorea FPS en tiempo real
- Detecta frame drops
- Analiza bridge traffic

### 3. Performance Monitor (Dev Menu)
- FPS counter
- JS thread utilization
- Native thread utilization
- Memory usage

## Problemas comunes y soluciones

### 1. Re-renders innecesarios

#### Problema: Componente renderiza aunque props no cambiaron

```typescript
// ❌ MAL - Re-renderiza en cada parent render
const ExpenseItem = ({ expense }) => {
  return (
    <View>
      <Text>{expense.description}</Text>
      <Text>${expense.amount}</Text>
    </View>
  );
};
```

#### Solución: Usar React.memo

```typescript
// ✅ BIEN - Solo renderiza si props cambian
const ExpenseItem = React.memo(({ expense }) => {
  return (
    <View>
      <Text>{expense.description}</Text>
      <Text>${expense.amount}</Text>
    </View>
  );
});
```

#### Solución avanzada: Custom comparison

```typescript
// ✅ MEJOR - Comparación personalizada
const ExpenseItem = React.memo(
  ({ expense }) => {
    return (
      <View>
        <Text>{expense.description}</Text>
        <Text>${expense.amount}</Text>
      </View>
    );
  },
  (prevProps, nextProps) => {
    // Return true si props son iguales (NO renderizar)
    return (
      prevProps.expense.id === nextProps.expense.id &&
      prevProps.expense.amount === nextProps.expense.amount &&
      prevProps.expense.description === nextProps.expense.description
    );
  }
);
```

### 2. Funciones recreadas en cada render

#### Problema: Handler recreado causa re-render de children

```typescript
// ❌ MAL - Nueva función en cada render
const ExpenseList = () => {
  const [expenses, setExpenses] = useState([]);

  const handleDelete = (id) => {  // ← Nueva función cada vez
    setExpenses(prev => prev.filter(e => e.id !== id));
  };

  return (
    <FlatList
      data={expenses}
      renderItem={({ item }) => (
        <ExpenseItem expense={item} onDelete={handleDelete} />
      )}
    />
  );
};
```

#### Solución: useCallback

```typescript
// ✅ BIEN - Función memoizada
const ExpenseList = () => {
  const [expenses, setExpenses] = useState([]);

  const handleDelete = useCallback((id) => {
    setExpenses(prev => prev.filter(e => e.id !== id));
  }, []); // ← Dependencias vacías, función nunca cambia

  return (
    <FlatList
      data={expenses}
      renderItem={({ item }) => (
        <ExpenseItem expense={item} onDelete={handleDelete} />
      )}
    />
  );
};
```

### 3. Cálculos costosos en cada render

#### Problema: Cálculo complejo se ejecuta siempre

```typescript
// ❌ MAL - Calcula total en cada render
const ExpenseSummary = ({ expenses }) => {
  const total = expenses.reduce((sum, e) => sum + e.amount, 0); // ← Se ejecuta siempre
  const average = total / expenses.length;
  const max = Math.max(...expenses.map(e => e.amount));

  return (
    <View>
      <Text>Total: ${total}</Text>
      <Text>Average: ${average}</Text>
      <Text>Max: ${max}</Text>
    </View>
  );
};
```

#### Solución: useMemo

```typescript
// ✅ BIEN - Memoiza cálculos costosos
const ExpenseSummary = ({ expenses }) => {
  const stats = useMemo(() => {
    const total = expenses.reduce((sum, e) => sum + e.amount, 0);
    const average = total / expenses.length;
    const max = Math.max(...expenses.map(e => e.amount));
    return { total, average, max };
  }, [expenses]); // ← Solo recalcula si expenses cambia

  return (
    <View>
      <Text>Total: ${stats.total}</Text>
      <Text>Average: ${stats.average}</Text>
      <Text>Max: ${stats.max}</Text>
    </View>
  );
};
```

### 4. FlatList lenta con muchos items

#### Problema: Renderiza todos los items

```typescript
// ❌ MAL - Sin optimizaciones
<FlatList
  data={expenses}
  renderItem={({ item }) => <ExpenseItem expense={item} />}
/>
```

#### Solución: Optimizaciones de FlatList

```typescript
// ✅ BIEN - Optimizado
const ExpenseList = ({ expenses }) => {
  const keyExtractor = useCallback((item) => item.id, []);

  const renderItem = useCallback(({ item }) => (
    <ExpenseItem expense={item} />
  ), []);

  const getItemLayout = useCallback((data, index) => ({
    length: ITEM_HEIGHT,
    offset: ITEM_HEIGHT * index,
    index,
  }), []);

  return (
    <FlatList
      data={expenses}
      renderItem={renderItem}
      keyExtractor={keyExtractor}
      getItemLayout={getItemLayout}  // ← Mejora scroll performance
      initialNumToRender={10}         // ← Renderiza solo 10 iniciales
      maxToRenderPerBatch={10}        // ← Renderiza 10 por batch
      windowSize={5}                  // ← Mantiene 5 pantallas en memoria
      removeClippedSubviews={true}    // ← Remueve views fuera de viewport
      updateCellsBatchingPeriod={50}  // ← Batch updates cada 50ms
    />
  );
};
```

### 5. Images sin optimización

#### Problema: Imágenes grandes ralentizan la app

```typescript
// ❌ MAL - Sin optimización
<Image source={{ uri: imageUrl }} style={{ width: 100, height: 100 }} />
```

#### Solución: Técnicas de optimización

```typescript
// ✅ BIEN - Optimizado
import FastImage from 'react-native-fast-image';

<FastImage
  source={{
    uri: imageUrl,
    priority: FastImage.priority.normal,
  }}
  style={{ width: 100, height: 100 }}
  resizeMode={FastImage.resizeMode.cover}
/>

// Para imágenes locales, usa diferentes resoluciones
<Image 
  source={require('./image@2x.png')}  // @2x, @3x para diferentes densidades
  style={{ width: 100, height: 100 }}
/>
```

### 6. Animaciones janky

#### Problema: Animaciones corren en JS thread

```typescript
// ❌ MAL - Animated en JS thread
const fadeAnim = useRef(new Animated.Value(0)).current;

Animated.timing(fadeAnim, {
  toValue: 1,
  duration: 500,
  useNativeDriver: false,  // ← JS thread!
}).start();
```

#### Solución: useNativeDriver

```typescript
// ✅ BIEN - Corre en native thread
const fadeAnim = useRef(new Animated.Value(0)).current;

Animated.timing(fadeAnim, {
  toValue: 1,
  duration: 500,
  useNativeDriver: true,  // ← Native thread! 60fps garantizado
}).start();

// O usar Reanimated 2
import Animated, { 
  useSharedValue, 
  useAnimatedStyle, 
  withTiming 
} from 'react-native-reanimated';

const MyComponent = () => {
  const opacity = useSharedValue(0);

  const animatedStyle = useAnimatedStyle(() => ({
    opacity: withTiming(opacity.value, { duration: 500 }),
  }));

  return <Animated.View style={animatedStyle} />;
};
```

### 7. Navigation lenta

#### Problema: Screen tarda en cargar

```typescript
// ❌ MAL - Carga todo de inmediato
const HomeScreen = () => {
  const [expenses, setExpenses] = useState([]);
  const [incomes, setIncomes] = useState([]);
  const [stats, setStats] = useState(null);

  useEffect(() => {
    // Carga todo en paralelo, bloquea render
    fetchExpenses();
    fetchIncomes();
    fetchStats();
  }, []);

  return <View>...</View>;
};
```

#### Solución: Progressive loading

```typescript
// ✅ BIEN - Carga progresiva
const HomeScreen = () => {
  const [expenses, setExpenses] = useState([]);
  const [incomes, setIncomes] = useState([]);
  const [stats, setStats] = useState(null);

  useEffect(() => {
    // Datos críticos primero
    fetchExpenses();
  }, []);

  useEffect(() => {
    // Datos secundarios después
    const timer = setTimeout(() => {
      fetchIncomes();
      fetchStats();
    }, 100);
    return () => clearTimeout(timer);
  }, []);

  return <View>...</View>;
};
```

### 8. Memory leaks

#### Problema: Subscriptions y listeners no limpios

```typescript
// ❌ MAL - Memory leak
const MyComponent = () => {
  useEffect(() => {
    const subscription = eventEmitter.on('update', handleUpdate);
    // ← No limpia subscription!
  }, []);

  return <View />;
};
```

#### Solución: Cleanup en useEffect

```typescript
// ✅ BIEN - Limpia correctamente
const MyComponent = () => {
  useEffect(() => {
    const subscription = eventEmitter.on('update', handleUpdate);

    return () => {
      subscription.remove();  // ← Cleanup
    };
  }, []);

  useEffect(() => {
    const timer = setInterval(() => {
      console.log('tick');
    }, 1000);

    return () => {
      clearInterval(timer);  // ← Cleanup timer
    };
  }, []);

  return <View />;
};
```

## Checklist de optimización

### Componentes
- [ ] Usar `React.memo` en componentes que reciben props estables
- [ ] Verificar que props son primitivos o memoizados
- [ ] Extraer componentes pesados para memoización selectiva

### Hooks
- [ ] Usar `useCallback` para handlers pasados como props
- [ ] Usar `useMemo` para cálculos costosos
- [ ] Verificar arrays de dependencias correctos

### Listas
- [ ] `keyExtractor` optimizado
- [ ] `getItemLayout` si items tienen altura fija
- [ ] `initialNumToRender` ajustado
- [ ] `removeClippedSubviews={true}`
- [ ] `renderItem` memoizado
- [ ] Items con `React.memo`

### Navegación
- [ ] Lazy loading de screens
- [ ] Progressive data loading
- [ ] Optimistic UI updates

### Media
- [ ] Imágenes comprimidas y optimizadas
- [ ] Diferentes resoluciones (@2x, @3x)
- [ ] FastImage para remote images
- [ ] Lazy loading de imágenes

### Animaciones
- [ ] `useNativeDriver: true` siempre que sea posible
- [ ] Considerar Reanimated 2 para animaciones complejas
- [ ] Evitar layout animations en JS thread

### Estado
- [ ] Estado local vs global bien distribuido
- [ ] No re-renderizar todo el árbol por cambios pequeños
- [ ] Selector memoization en estado global

### Memory
- [ ] Cleanup de subscriptions en useEffect
- [ ] Cleanup de timers
- [ ] Cleanup de event listeners
- [ ] No almacenar grandes objetos en estado si no es necesario

## Herramientas de debugging

### Why Did You Render

```typescript
// whyDidYouRender.js
import whyDidYouRender from '@welldone-software/why-did-you-render';
import React from 'react';

if (__DEV__) {
  whyDidYouRender(React, {
    trackAllPureComponents: true,
    trackHooks: true,
    logOwnerReasons: true,
  });
}

// En componente
MyComponent.whyDidYouRender = true;
```

### Performance Monitoring

```typescript
import { InteractionManager, Platform } from 'react-native';
import perf from '@react-native-firebase/perf';

// Trace custom operations
const trace = await perf().startTrace('load_expenses');
await fetchExpenses();
await trace.stop();

// Monitor screen transitions
InteractionManager.runAfterInteractions(() => {
  // Código que puede esperar a que terminen animaciones
  loadHeavyData();
});
```

### Bundle size analysis

```bash
# Analizar tamaño del bundle
npx react-native-bundle-visualizer

# Ver qué librerías ocupan más espacio
npm run bundle-report
```

## Patrones anti-performance

❌ **EVITAR:**
- Inline objects/arrays como props: `<Comp style={{ flex: 1 }} />`
- Inline functions: `<Button onPress={() => handleClick()} />`
- Index como key en listas: `key={index}`
- Componentes gigantes (>300 líneas)
- Estado global para todo
- Re-renders de todo el árbol
- Animaciones complejas en JS thread

✅ **PREFERIR:**
- StyleSheet.create() o styled-components
- useCallback para handlers
- IDs únicos como keys
- Componentes pequeños y focused
- Estado local cuando sea posible
- Memoización estratégica
- useNativeDriver o Reanimated 2

## Métricas objetivo

- **FPS:** Mantener 60fps (o 120fps en dispositivos capaces)
- **TTI (Time to Interactive):** <3 segundos
- **Bundle size:** <10MB
- **Memory usage:** <200MB en uso normal
- **JS thread:** <50% utilización promedio

## Referencias

- [React Native Performance](https://reactnative.dev/docs/performance)
- [Reanimated 2](https://docs.swmansion.com/react-native-reanimated/)
- [FastImage](https://github.com/DylanVann/react-native-fast-image)
- [Flipper](https://fbflipper.com/)
