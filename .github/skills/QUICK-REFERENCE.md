# Quick Reference - React Native Skills

## 🚀 Comandos Rápidos

| Necesito... | Comando | Tiempo estimado |
|------------|---------|-----------------|
| Botón, Input, Card | `/create-component` | 5-10 min |
| Pantalla completa | `/create-screen` | 15-30 min |
| Lógica reutilizable | `/create-hook` | 10-15 min |
| Clonar diseño de Figma ⭐ | `/recreate-figma-ui` | 10-20 min |
| Convertir HTML de Stitch 🎨 | `/convert-stitch-html` | 5-15 min |
| Conectar con API | `/integrate-api` | 10-15 min |
| Tests para código | `/add-tests` | 10-20 min |
| Optimizar performance | `/optimize-performance` | 15-30 min |

## 📋 Workflows Comunes

### Workflow 1: Implementar nueva feature desde Figma

```bash
1. /recreate-figma-ui          # Crear componentes visuales
2. /create-screen              # Crear la screen que los usa
3. /integrate-api              # Conectar con backend
4. /add-tests                  # Agregar tests
```

### Workflow 2: Crear formulario completo

```bash
1. /create-component           # Crear inputs personalizados
2. /create-hook                # Hook de validación
3. /create-screen              # Screen con formulario
4. /add-tests                  # Tests de validación
```

### Workflow 3: Optimizar screen lenta

```bash
1. /optimize-performance       # Analizar y optimizar
2. /add-tests                  # Tests de performance
```

## 🎯 Decision Tree

```
¿Qué necesitas?
│
├─ 🎨 Implementar diseño visual
│  ├─ Desde Figma (imagen/mockup) → /recreate-figma-ui
│  └─ Desde Stitch (archivo .txt) → /convert-stitch-html 🆕
│
├─ 🧩 Crear componente UI
│  ├─ Simple (Button, Input) → /create-component
│  └─ Complejo (Pantalla) → /create-screen
│
├─ ⚙️ Lógica de negocio
│  ├─ Reutilizable → /create-hook
│  └─ Llamada API → /integrate-api
│
├─ ✅ Calidad de código
│  ├─ Tests → /add-tests
│  └─ Performance → /optimize-performance
│
└─ 📦 Todo lo anterior → Combinar skills!
```

## ⚡ Tips Pro

### 1. Combinar skills
No uses solo un skill. Combínalos para mejores resultados:

```bash
/recreate-figma-ui → /create-screen → /add-tests
```

### 2. Skill estrella para Figma
El skill `/recreate-figma-ui` es el más potente. Puede:
- Analizar screenshots
- Extraer design system completo
- Generar theme centralizado
- Crear componentes pixel-perfect

**Ejemplo:**
```
Usuario: Tengo este diseño [imagen adjunta]
/recreate-figma-ui
```

### 3. Siempre terminar con tests
Después de crear componentes/screens/hooks, usa:
```bash
/add-tests
```

### 3. Skill especial para Stitch AI
El skill `/convert-stitch-html` es perfecto para tu workflow con Stitch:

**Workflow Stitch:**
```bash
1. Creas prompt basado en tus plantillas en /docs/product/stitch-*.md
2. Pegas prompt en Stitch AI
3. Stitch genera HTML/CSS
4. Exportas a archivo .txt
5. Ejecutas: /convert-stitch-html
6. Adjuntas el .txt
7. Obtienes código React Native listo! ✨
```

**Ventajas:**
- Conversión automática HTML → React Native
- Extracción de theme (colores, tipografía, spacing)
- Componentes organizados (atoms, molecules, organisms)
- TypeScript strict
- Optimizado y production-ready

**Ejemplo:**
```
Usuario: Tengo este HTML de Stitch [adjunta stitch-login.txt]
/convert-stitch-html

Skill analiza y genera:
✅ stitchTheme.ts con design system
✅ StitchInput.tsx
✅ StitchButton.tsx
✅ LoginScreen.tsx completa
✅ Todo adaptado a tu arquitectura
```

## 📝 Patrones de código generados

### Componente típico
```typescript
// Generado por /create-component
import React, { memo } from 'react';
import { StyleSheet, View, Text } from 'react-native';

interface Props {
  title: string;
}

const Component: React.FC<Props> = memo(({ title }) => {
  return <View style={styles.container}>...</View>;
});

Component.displayName = 'Component';

export default Component;
```

### Screen típica
```typescript
// Generado por /create-screen
import { useNavigation } from '@react-navigation/native';

const Screen: React.FC = () => {
  const navigation = useNavigation();
  const [state, setState] = useState();

  return <View>...</View>;
};
```

### Hook típico
```typescript
// Generado por /create-hook
export const useCustomHook = () => {
  const [data, setData] = useState();
  
  const action = useCallback(() => {
    // ...
  }, []);

  return { data, action };
};
```

## 🔍 Troubleshooting

| Problema | Solución |
|----------|----------|
| Skill no aparece | Verifica que escribiste `/` antes del nombre |
| Código no compila | Verifica TypeScript errors con `/add-tests` |
| App lenta | Ejecuta `/optimize-performance` |
| Diseño no se ve igual | Usa `/recreate-figma-ui` con imagen de referencia |
| API no funciona | Revisa con `/integrate-api` y docs del backend |

## 📚 Archivos de referencia

Antes de usar skills, los archivos que debes leer están documentados en cada SKILL.md:

- `/docs/architecture/api-reference-frontend.md` ← API endpoints
- `/docs/architecture/project-structure.md` ← Estructura del proyecto  
- `/docs/product/frontend-integration-guide.md` ← Guía de integración
- `/docs/security/` ← Requerimientos de seguridad

## 🎓 Learning Path

Para nuevos desarrolladores en el proyecto:

1. **Semana 1:** Familiarízate con `/create-component` y `/create-screen`
2. **Semana 2:** Domina `/recreate-figma-ui` para implementar diseños
3. **Semana 3:** Aprende `/integrate-api` y `/create-hook`
4. **Semana 4:** Master `/optimize-performance` y `/add-tests`

## 💡 Casos de uso reales

### Caso 1: Login screen desde cero
```bash
1. /recreate-figma-ui        # Crear inputs y botón personalizados
2. /create-hook              # useLoginForm con validaciones
3. /create-screen            # LoginScreen completo
4. /integrate-api            # Conectar con /auth/login
5. /add-tests                # Tests de validación y flujo
```

### Caso 2: Lista de transacciones
```bash
1. /create-component         # TransactionCard
2. /create-screen            # TransactionsScreen con FlatList
3. /integrate-api            # Fetch de /transactions
4. /optimize-performance     # Optimizar FlatList
5. /add-tests                # Tests de lista
```

### Caso 3: Gráficos de analytics
```bash
1. /recreate-figma-ui        # Recrear diseño del chart
2. /create-hook              # useChartData para procesar stats
3. /create-component         # Chart component con react-native-chart-kit
4. /add-tests                # Tests de cálculos
```

---

**Pro tip:** Guarda este archivo como referencia rápida. Los skills están diseñados para trabajar juntos, no de forma aislada.
