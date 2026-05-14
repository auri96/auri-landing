# Skills para React Native Development

Este directorio contiene skills especializados para el desarrollo de la aplicación Auri en React Native.

## 🎯 Skills Disponibles

### 1. `/create-component`
**Propósito:** Crear componentes React Native siguiendo Clean Architecture  
**Usa cuando:** Necesites componentes UI reutilizables (buttons, inputs, cards, etc.)  
**Output:** Componente con TypeScript, StyleSheet, memo, tests, y documentación

---

### 2. `/create-screen`
**Propósito:** Crear pantallas completas con navegación y lógica  
**Usa cuando:** Implementes nuevas screens en la app  
**Output:** Screen con navegación, estado, validaciones, y manejo de API

---

### 3. `/create-hook`
**Propósito:** Crear custom hooks para encapsular lógica  
**Usa cuando:** Necesites separar lógica de presentación  
**Output:** Hook con TypeScript, memoización, tests, y ejemplos de uso

---

### 4. `/recreate-figma-ui` ⭐
**Propósito:** Recrear diseños de Figma con precisión pixel-perfect  
**Usa cuando:** Tengas mockups o diseños visuales a implementar  
**Output:** Componentes que replican exactamente el diseño, con theme system  
**Especial:** Extrae colores, tipografía, espaciado, shadows, y borders automáticamente

---

### 5. `/integrate-api`
**Propósito:** Integrar endpoints del backend  
**Usa cuando:** Necesites consumir APIs REST  
**Output:** Servicio + custom hook + tipos TypeScript + manejo de errores

---

### 6. `/add-tests`
**Propósito:** Generar tests unitarios y de integración  
**Usa cuando:** Necesites coverage de tests  
**Output:** Tests con Jest + React Testing Library, mocks, y assertions

---

### 7. `/optimize-performance`
**Propósito:** Analizar y optimizar rendimiento  
**Usa cuando:** La app tenga lags, re-renders innecesarios, o memory leaks  
**Output:** Análisis + código optimizado con memo, useCallback, useMemo

---

### 8. `/convert-stitch-html` 🎨
**Propósito:** Convertir archivos .txt con HTML de Stitch a React Native  
**Usa cuando:** Tengas código generado por Stitch AI que necesites adaptar  
**Output:** Theme + componentes + screen completa en TypeScript  
**Especial:** Lee HTML/CSS de Stitch y genera código optimizado para tu arquitectura

---

## 📝 Cómo usar los skills

En el chat con el agente de React Native, simplemente escribe:

```
/create-component
```

El skill te guiará paso a paso para implementar lo que necesitas.

## 🏗️ Estructura del proyecto

Los skills generan código siguiendo esta estructura:

```
src/
├── presentation/
│   ├── components/
│   │   ├── atoms/       ← Componentes básicos
│   │   ├── molecules/   ← Combinaciones
│   │   └── organisms/   ← Complejos
│   ├── screens/         ← Pantallas completas
│   └── hooks/           ← Custom hooks
├── core/
│   ├── services/        ← Servicios de API
│   ├── types/           ← TypeScript types
│   └── theme/           ← Theme system
└── __tests__/           ← Tests
```

## 🎨 Skill destacado: recreate-figma-ui

Este skill es especialmente útil para el proyecto Auri, ya que:

- ✅ Analiza capturas de pantalla o código de Figma
- ✅ Extrae automáticamente el design system (colores, fuentes, espaciado)
- ✅ Genera componentes pixel-perfect
- ✅ Crea un theme centralizado
- ✅ Implementa todos los estados (pressed, disabled, etc.)
- ✅ Hace los componentes responsive

**Ejemplo de uso:**
```
Usuario: Tengo este diseño de Figma [adjunta imagen]
Agente: /recreate-figma-ui
```

El skill analizará la imagen y generará:
1. Theme con colores, tipografía, spacing extraídos
2. Componentes que replican el diseño
3. Código optimizado y mantenible

## 🤝 Contribuir

Para agregar nuevos skills:

1. Crea una carpeta en `.github/skills/nombre-skill/`
2. Crea `SKILL.md` con frontmatter YAML y contenido
3. Actualiza este README
4. Prueba el skill con el agente

## 📚 Referencias

- [React Native Docs](https://reactnative.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Testing Library](https://testing-library.com/docs/react-native-testing-library/intro/)
- [React Navigation](https://reactnavigation.org/)

---

**Última actualización:** 2026-03-25  
**Mantenedor:** Equipo Auri Development
