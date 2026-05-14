# Agentes Especializados — Auri Project

Este directorio contiene agentes especializados diseñados para diferentes aspectos del desarrollo del proyecto Auri (fintech mobile app).

---

## 📋 Lista de Agentes

| # | Agente | Especialización | Invocación | Archivo |
|---|--------|----------------|------------|---------|
| **Orquestador** | Chief AI Officer | Clasificación y delegación de tareas | `@Orquestador` | [Orquestador.agent.md](./Orquestador.agent.md) |
| **1** | Fintech Product Strategist | Visión estratégica del producto | `@1-Fintech Product Strategist` | [1-Product Strategist.agent.md](./1-Product%20Strategist.agent.md) |
| **2** | Growth & Market Strategist | Crecimiento y mercado | `@2-Growth & Market Strategist` | [2-Growth & Market Agent.agent.md](./2-Growth%20&%20Market%20Agent.agent.md) |
| **3** | Product Owner (PO) | Priorización y roadmap | `@3-Product Owner (PO)` | [3-Product Owner (PO).agent.md](./3-Product%20Owner%20(PO).agent.md) |
| **4** | Mobile & Backend Architect | Arquitectura de sistemas | `@4-Mobile & Backend Architect` | [4-Mobile & Backend Architect.agent.md](./4-Mobile%20&%20Backend%20Architect.agent.md) |
| **5** | Security & Risk Auditor | Seguridad y compliance | `@5-Security & Risk Auditor` | [5-Security Auditor.agent.md](./5-Security%20Auditor.agent.md) |
| **6** | Data & Analytics Strategist | Métricas y análisis | `@6-Data & Analytics Strategist` | [6-Data y Analytics Agent.agent.md](./6-Data%20y%20Analytics%20Agent.agent.md) |
| **7** | AI & Automation Architect | IA y automatización | `@7-AI & Automation Architect` | [7-AI & Automation Agent.agent.md](./7-AI%20&%20Automation%20Agent.agent.md) |
| **8** | React Native Specialist | Desarrollo mobile | `@8-React Native Specialist` | [8-React Native Specialist.agent.md](./8-React%20Native%20Specialist.agent.md) |
| **9** | Backend Specialist | Desarrollo backend | `@9-Backend Specialist` | [8.1-Agente Backend Specialist.agent.md](./8.1-Agente%20Backend%20Specialist.agent.md) |
| **9.1** | Senior Code Reviewer | Code review y auditoría | `@9-Senior Code Reviewer` | [9-Senior Code Reviewer.agent.md](./9-Senior%20Code%20Reviewer.agent.md) |
| **10** | UI/UX Designer | Diseño de interfaces | `@10-UI-UX Designer` | [10-UI-UX Designer.agent.md](./10-UI-UX%20Designer.agent.md) |
| **11** | Legal & Compliance Specialist | Documentos legales y compliance | `@11-Legal & Compliance Specialist` | [11-Legal & Compliance Specialist.agent.md](./11-Legal%20&%20Compliance%20Specialist.agent.md) |
| **12** 🆕 | Social Media & Content Strategist | Contenido viral y crecimiento orgánico | `@12-Social Media & Content Strategist` | [12-Social Media & Content Strategist.agent.md](./12-Social%20Media%20&%20Content%20Strategist.agent.md) |

---

## 🆕 Nuevo: Legal & Compliance Specialist Agent

El agente **Legal & Compliance Specialist** es un abogado especializado en derecho digital, protección de datos y derecho del consumidor en Colombia.

### Casos de Uso

✅ Crear y actualizar Términos y Condiciones  
✅ Redactar Políticas de Privacidad conformes con Ley 1581/2012  
✅ Generar consentimientos de tratamiento de datos  
✅ Evaluar riesgos legales en nuevas funcionalidades  
✅ Asegurar cumplimiento con Ley 1480/2011 (Estatuto del Consumidor)  
✅ Redactar cláusulas de limitación de responsabilidad  
✅ Revisar políticas de pagos y suscripciones  
✅ Documentar obligaciones regulatorias fintech  

### Normatividad Cubierta

- 📜 **Ley 1581 de 2012** — Protección de Datos Personales
- 📜 **Decreto 1377 de 2013** — Régimen de protección de datos
- 🛒 **Ley 1480 de 2011** — Estatuto del Consumidor (derecho de retracto, PQR)
- 🏛️ **SIC** — Superintendencia de Industria y Comercio
- 🤖 **Regulación de IA** — Disclaimers sobre uso de automatización
- 💳 **FinTech** — Servicios financieros no vigilados por Superfinanciera

### Output Estructurado

El agente siempre responde con documentos en Markdown que incluyen:

1. **📄 Documento Legal Completo** — Texto legal con todas las cláusulas
2. **⚠️ Riesgos Legales Identificados** — Normatividad afectada y nivel de riesgo
3. **💡 Recomendaciones de Implementación** — Técnicas, operativas, comunicacionales
4. **✅ Nivel de Cumplimiento** — Estado de compliance con cada ley
5. **📊 Control de Versiones** — Historial de cambios del documento

### Ejemplo de Invocación

```
@11-Legal & Compliance Specialist

Necesito los Términos y Condiciones completos para Auri.

Contexto:
- App fintech de gestión de gastos
- Planes: Free, Básico ($3.99/mes), Pro ($6.99/mes)
- Usa IA para clasificación automática
- Integración futura con WhatsApp
- Usuarios en Colombia

Prioridades:
- Cumplimiento Ley 1581/2012
- Limitación de responsabilidad financiera
- Derecho de retracto
- Disclaimer sobre uso de IA
```

**Documentación completa:** Dentro del agente en [11-Legal & Compliance Specialist.agent.md](./11-Legal%20&%20Compliance%20Specialist.agent.md)

---

## 📱 Nuevo: Social Media & Content Strategist Agent

El agente **Social Media & Content Strategist** es un especialista en crecimiento orgánico, contenido viral y posicionamiento de productos fintech en redes sociales. **Incluye herramientas de IA gratuitas** y workflows completos para crear contenido profesional sin experiencia previa.

### Misión

Hacer crecer la marca **Auri/Auri** en redes sociales, atrayendo usuarios, generando engagement y convirtiendo audiencia en usuarios activos de la app, **democratizando la creación de contenido con herramientas de IA gratuitas.**

### Casos de Uso

✅ Crear ideas de contenido educativo y viral  
✅ Generar guiones para Reels y TikToks con herramientas de edición IA  
✅ Escribir copies y captions optimizados  
✅ Diseñar calendarios editoriales (semanal/mensual) con herramientas específicas  
✅ **Proporcionar prompts exactos** para Canva AI, Leonardo.ai, Runway ML  
✅ **Workflows paso-a-paso** para crear carruseles, videos y posts con IA  
✅ **Herramientas gratuitas documentadas** (CapCut, ElevenLabs, RemoveBG, etc.)  
✅ Proponer estrategias de lanzamiento con assets visuales  
✅ Analizar y mejorar contenido existente  
✅ Identificar tendencias virales adaptables a fintech  
✅ Crear scripts para anuncios pagados con herramientas de IA  
✅ Diseñar dinámicas de engagement (retos, encuestas)  
✅ Proponer respuestas a comentarios

### 🤖 Herramientas de IA Incluidas (GRATIS)

Cada contenido que genera el agente incluye las herramientas exactas a usar:

| Categoría | Herramientas | Uso |
|-----------|-------------|-----|
| 🎨 **Diseño Gráfico** | Canva AI, Leonardo.ai, Playground AI | Carruseles, posts, imágenes |
| 🎥 **Videos** | CapCut, Runway ML, Descript | Reels, TikToks, edición con IA |
| ✍️ **Copywriting** | ChatGPT, Copy.ai | Captions, scripts, hooks |
| 🎵 **Audio** | ElevenLabs, Epidemic Sound | Voiceovers IA, música |
| 📊 **Infografías** | Piktochart, Visme | Estadísticas, datos visuales |
| 🎭 **Avatares** | D-ID, HeyGen | Presentadores IA (opcional) |
| 🔧 **Complementarias** | RemoveBG, Upscale.media, Unscreen | Edición de fondo, upscaling |

**Todas las herramientas tienen planes gratuitos** con límites generosos para crear contenido profesional.  

### Plataformas Principales

- 📸 **Instagram** — Reels, Stories, Posts, Carruseles
- 🎵 **TikTok** — Videos cortos, trends, challenges
- 💼 **LinkedIn** — Contenido profesional (opcional)

### Tipo de Contenido

| Categoría | Descripción | Objetivo |
|-----------|-------------|----------|
| 🎓 **Educación financiera** | Conceptos complejos explicados simple | Educar + Posicionar |
| 😰 **Problemas comunes** | Gastos hormiga, deudas, ansiedad financiera | Identificación emocional |
| 💡 **Hacks y tips** | Trucos para ahorrar y controlar gastos | Engagement + Saves |
| ⚖️ **Antes vs Después** | Con Auri vs Sin Auri, Plan Free vs PRO | Conversión |
| ❤️ **Contenido emocional** | Alivio al tener control del dinero | Viralidad |
| 🔥 **Contenido viral** | Hooks impactantes, datos sorprendentes | Alcance |
| 🎯 **Promoción indirecta** | Mostrar beneficios sin vender directamente | Conversión sutil |

### Formato de Respuesta Estructurada

Cada pieza de contenido incluye:

1. **💡 Idea de contenido** — Resumen corto
2. **📱 Plataforma** — Instagram / TikTok / LinkedIn
3. **📽️ Formato** — Reel / Carrusel / Story / Video corto
4. **🎣 Hook** — Primeros 3 segundos que enganchan
5. **📝 Desarrollo** — Guion completo del contenido
6. **✍️ Caption** — Texto listo para publicar con emojis y hashtags
7. **👆 CTA** — Llamado a la acción específico
8. **🎯 Objetivo** — Engagement / Viralidad / Conversión
9. **📊 Métricas esperadas** — Alcance, saves, shares, clicks
10. **🤖 Herramientas IA** — Software específico + prompts exactos + workflow paso-a-paso
11. **⏱️ Tiempo estimado** — Duración de creación del contenido

### Estilo de Comunicación

| Enfoque | Descripción |
|---------|-------------|
| **Cercano** | Como un amigo que da consejos, no una marca corporativa |
| **Directo** | Sin rodeos ni fluff, al grano |
| **Educativo ligero** | Enseña sin aburrir, evita tecnicismos |
| **Problemas reales** | Habla de lo que duele: ansiedad, desorden, gastos invisibles |
| **Urgencia sutil** | FOMO: "Estás perdiendo dinero y no lo sabes" |

### Ejemplos de Tono Correcto

❌ **Tono corporativo (evitar):**  
_"Nuestra aplicación ofrece una solución integral de gestión financiera con capacidades de IA..."_

✅ **Tono Auri (usar):**  
_"Si no sabes en qué se te va el dinero, esto es para ti."_

---

❌ **Tono genérico (evitar):**  
_"Optimiza tus finanzas personales con tecnología de punta."_

✅ **Tono Auri (usar):**  
_"¿Y si dejaras de adivinar dónde están tus gastos?"_

### Capacidades Adicionales

Cuando el usuario lo solicite, el agente puede:

| Capacidad | Output |
|-----------|--------|
| 🤖 **Contenido con IA (OBLIGATORIO)** | Texto + Prompts + Herramientas + Workflow completo paso-a-paso |
| 📅 **Calendario editorial** | Plan semanal/mensual de contenido balanceado con herramientas específicas |
| 🚀 **Estrategia de lanzamiento** | Secuencia pre-lanzamiento → lanzamiento → post con assets visuales IA |
| 🔍 **Análisis de contenido** | Revisar posts previos y sugerir mejoras con herramientas IA |
| 📈 **Investigación de trends** | Identificar tendencias virales adaptables + workflows de creación |
| 💰 **Scripts de anuncios** | Copy para ads, landing pages, email marketing con herramientas de edición |
| 🎮 **Dinámicas de engagement** | Retos, encuestas, concursos con assets visuales profesionales creados con IA |
| 📝 **Templates de prompts** | Prompts reutilizables optimizados para Canva, Leonardo, Runway |

### Workflows de IA Documentados

El agente proporciona workflows completos como:

**📸 Carrusel de Instagram (15-20 min):**
1. ChatGPT → Generar textos de 5 slides
2. Canva → Diseñar con prompts específicos
3. Leonardo.ai → Generar ilustraciones custom (opcional)
4. Exportar → 1080x1350px PNG

**🎥 Reel de Instagram/TikTok (30-45 min):**
1. ChatGPT → Script completo con timing
2. Pexels/grabación → Videos base
3. CapCut → Edición con Auto Captions + música trending
4. ElevenLabs → Voiceover IA (opcional)
5. Canva → Thumbnail impactante
6. Exportar → 1080x1920px MP4

**📱 Post estático (10-15 min):**
1. ChatGPT → Caption con hashtags
2. Leonardo.ai/Playground → Imagen impactante
3. Canva → Edición final + overlays
4. Exportar → 1080x1080px PNG

### Ejemplo de Invocación

```
@12-Social Media & Content Strategist

Necesito crear un reel para Instagram que explique por qué la gente 
pierde dinero sin darse cuenta.

Contexto:
- Público objetivo: jóvenes 22-35 años
- Problema: gastos hormiga invisibles
- Objetivo: engagement + conversión a app

Quiero:
- Hook impactante (primeros 3 segundos)
- Contenido educativo pero viral
- CTA al final para descargar Auri
- Herramientas de IA para crearlo (prompts + workflow completo)
```

**El agente responderá con:**
- ✅ Script completo con timing
- ✅ Caption con hashtags
- ✅ Herramientas específicas (CapCut, ElevenLabs, Canva)
- ✅ Prompts exactos para cada herramienta
- ✅ Workflow paso-a-paso detallado
- ✅ Configuraciones (colores, tipografía, dimensiones)
- ✅ Tiempo estimado de creación (ej: 45-60 minutos)
- ✅ Métricas esperadas

### ⚠️ REGLA OBLIGATORIA

**Ningún contenido se entrega sin incluir:**
- Las herramientas de IA específicas a usar
- Los prompts exactos para cada herramienta
- El workflow paso-a-paso documentado
- El tiempo estimado de creación

Esto asegura que cualquier persona, **sin experiencia previa**, pueda crear contenido profesional usando IA gratuita.

### Documentación Generada

El agente crea y mantiene:
- `/docs/growth/content-strategy.md` — Estrategia de contenido general
- `/docs/growth/social-media-calendar.md` — Calendario editorial

Cada documento incluye:
- ✅ Fecha de creación/actualización
- ✅ Versión (vX.Y)
- ✅ Periodo que cubre
- ✅ Plataformas
- ✅ Métricas objetivo
- ✅ Responsable: Social Media & Content Strategist

### Restricciones

- ❌ **NO edita código** — Solo crea contenido estratégico
- ❌ **NO ejecuta comandos** — Sin acceso a terminal
- ✅ **SOLO herramientas de lectura y web** — Para investigar producto y tendencias
- ✅ **Enfoque exclusivo:** Estrategia de contenido y growth en redes sociales

**Documentación completa:** Dentro del agente en [12-Social Media & Content Strategist.agent.md](./12-Social%20Media%20&%20Content%20Strategist.agent.md)

---

## 🎨 UI/UX Designer Agent

El agente **UI/UX Designer** es un especialista en evaluación y mejora de diseños mobile fintech.

### Casos de Uso

✅ Evaluar diseños de Stitch AI o Figma  
✅ Revisar consistencia con el design system "The Luminous Vault"  
✅ Validar experiencia de usuario (UX) y proponer mejoras  
✅ Verificar implementabilidad en React Native  
✅ Rediseñar pantallas completas  
✅ Proponer wireframes para nuevas features  

### Entrada Aceptada

- 🖼️ **Imágenes PNG/JPG** de mockups o prototipos
- 📄 **Archivos HTML** generados por Stitch AI
- 🎨 **Links de Figma** (describe el diseño manualmente)
- 📝 **Descripciones textuales** de pantallas a diseñar

### Output Estructurado

El agente siempre responde con:

1. **🔍 Análisis** — Propósito y contexto de la pantalla
2. **❌ Problemas Detectados** — UX, UI, producto, implementación
3. **✅ Recomendaciones UX** — Mejoras funcionales concretas
4. **🎨 Recomendaciones UI** — Ajustes visuales específicos
5. **💡 Ajustes para Desarrollo** — Cómo implementarlo en React Native
6. **📊 Nivel de Prioridad** — Alta / Media / Baja
7. **🎯 Siguiente Paso** — Acción recomendada

### Ejemplo de Invocación

```
@10-UI-UX Designer 

Analiza esta pantalla de login que diseñé en Figma.
[Adjunta: login-screen.png]

Prioridades:
- Claridad sobre estética
- Incluir OAuth (Google/Apple)
- Implementable en React Native
```

**Documentación completa:** [UI-UX-AGENT-GUIDE.md](../../docs/product/UI-UX-AGENT-GUIDE.md)

---

## 🎯 ¿Qué Agente Usar?

### Estrategia y Producto

| Necesitas | Agente |
|-----------|--------|
| Definir modelo de negocio o monetización | **1 - Product Strategist** |
| Estrategia de crecimiento o marketing | **2 - Growth & Market** |
| Priorizar features o crear roadmap | **3 - Product Owner** |
| Diseñar arquitectura del sistema | **4 - Mobile & Backend Architect** |
| Auditar seguridad o compliance | **5 - Security Auditor** |
| Diseñar métricas o tracking | **6 - Data & Analytics** |
| Evaluar oportunidades de IA | **7 - AI & Automation** |
| **Crear documentos legales o evaluar riesgos regulatorios** | **11 - Legal & Compliance** |
| **Crear contenido para redes sociales o estrategia de crecimiento orgánico** 🆕 | **12 - Social Media & Content** |

### Desarrollo e Implementación

| Necesitas | Agente |
|-----------|--------|
| Crear componentes, screens, hooks en React Native | **8 - React Native Specialist** |
| Desarrollar endpoints o lógica de backend | **9 - Backend Specialist** |
| Revisar código o detectar code smells | **9.1 - Code Reviewer** |
| **Evaluar o mejorar diseños UI/UX** 🆕 | **10 - UI/UX Designer** |

### Orquestación

| Necesitas | Agente |
|-----------|--------|
| No sé qué agente usar | **Orquestador** (clasifica y delega automáticamente) |

---

## 🔄 Workflow Típico

### Feature Nueva (Ejemplo: Pantalla de Resumen Mensual)

1. **Product Owner** — Define user story y criterios de aceptación
2. **UI/UX Designer** — Propone diseño de la pantalla
3. **Mobile Architect** — Valida arquitectura y componentes
4. **React Native Specialist** — Implementa (con skills `/create-screen`, `/recreate-figma-ui`)
5. **UI/UX Designer** — Valida resultado vs diseño original
6. **Code Reviewer** — Audita código implementado
7. **Security Auditor** — Valida si maneja datos sensibles

### Rediseño de Pantalla Existente

1. **UI/UX Designer** — Analiza pantalla actual y propone mejoras
2. **Product Owner** — Prioriza mejoras vs otras features
3. **React Native Specialist** — Implementa cambios
4. **UI/UX Designer** — Valida resultado
5. **Code Reviewer** — Audita refactoring

### Pre-Lanzamiento o Feature con Implicaciones Legales 🆕

1. **Legal & Compliance** — Identifica requisitos legales (consentimientos, disclaimers, T&C)
2. **Product Owner** — Integra requisitos legales en user stories
3. **UI/UX Designer** — Diseña flujos de aceptación de términos
4. **React Native Specialist** — Implementa consentimientos y políticas
5. **Legal & Compliance** — Valida implementación de textos legales
6. **Security Auditor** — Valida cumplimiento de protección de datos

**Ejemplos de uso del agente legal:**
- Lanzamiento inicial de la app (T&C, Política de Privacidad)
- Nueva feature de suscripciones (Política de Pagos, derecho de retracto)
- Implementación de IA (Disclaimers de automatización)
- Integración con WhatsApp o APIs externas (Consentimientos adicionales)
- Cambio de modelo de negocio o pricing (Actualización de T&C)

### Campaña de Contenido en Redes Sociales 🆕

1. **Product Owner** — Define objetivo de campaña (lanzamiento, feature nueva, hito)
2. **Growth & Market Strategist** — Define estrategia de adquisición y segmento objetivo
3. **Social Media & Content Strategist** — Crea calendario editorial y contenido (hooks, guiones, captions)
4. **UI/UX Designer** — Propone assets visuales o mockups para contenido
5. **Social Media & Content Strategist** — Ajusta contenido con assets visuales
6. **Data & Analytics** — Define métricas de tracking (alcance, engagement, conversión)
7. **Legal & Compliance** — Valida disclaimers si se menciona IA o rendimiento financiero

**Ejemplos de uso del agente de social media:**
- Pre-lanzamiento de la app (teaser content, countdown)
- Lanzamiento de nueva feature (educación + demostración)
- Calendario mensual de contenido educativo
- Repurposing de user stories en contenido viral
- Respuesta a tendencias emergentes en fintech
- Creación de ads orgánicos para Instagram/TikTok

---

## 📚 Recursos Complementarios

### Design System

- **Design System Completo:** [/docs/architecture/DESIGN.md](../../docs/architecture/DESIGN.md)
- **Guía del Agente UI/UX:** [/docs/product/UI-UX-AGENT-GUIDE.md](../../docs/product/UI-UX-AGENT-GUIDE.md)
- **Design Tokens (código):** [/src/core/theme/](../../src/core/theme/)

### Skills de Implementación

Los agentes de desarrollo tienen acceso a skills especializados:

- **`/create-component`** — Crear componentes React Native
- **`/create-screen`** — Crear screens completas
- **`/create-hook`** — Crear custom hooks
- **`/recreate-figma-ui`** ⭐ — Convertir mockups a código React Native
- **`/convert-stitch-html`** — Convertir HTML Stitch a React Native
- **`/integrate-api`** — Integrar endpoints del backend
- **`/add-tests`** — Generar tests
- **`/optimize-performance`** — Optimizar rendimiento

**Documentación de skills:** [/.github/skills/](../skills/)

### Arquitectura y Producto

- **Estructura del Proyecto:** [/docs/architecture/project-structure.md](../../docs/architecture/project-structure.md)
- **API Reference:** [/docs/architecture/api-reference-frontend.md](../../docs/architecture/api-reference-frontend.md)
- **MVP Definition:** [/docs/product/mvp-definition.md](../../docs/product/mvp-definition.md)
- **Implementation Log:** [/docs/product/implementation-log.md](../../docs/product/implementation-log.md)

---

## 🚀 Inicio Rápido

### Opción 1: Invocar Agente Directamente

```
@10-UI-UX Designer 

[Tu solicitud aquí]
```

### Opción 2: Usar Orquestador (Recomendado)

```
[Tu solicitud sin mencionar agente]

Evalúa este diseño de login.
[Adjunta imagen]
```

El Orquestador analizará la solicitud y delegará automáticamente al agente correcto.

---

## 🔧 Crear Agente Nuevo

Si necesitas un agente especializado adicional:

1. **Crea archivo:** `.github/agents/[Número]-[Nombre].agent.md`
2. **Usa frontmatter YAML:**
   ```yaml
   ---
   name: [Número]-[Nombre]
   description: [Descripción corta]
   argument-hint: [Qué tipo de tarea recibe]
   tools: ['vscode', 'read', 'edit', 'search']
   ---
   ```
3. **Define:**
   - Responsabilidades
   - Reglas estrictas
   - Flujo de trabajo
   - Output esperado
4. **Actualiza:**
   - Este README
   - [Orquestador.agent.md](./Orquestador.agent.md) (tabla de agentes)

---

## 📞 Soporte

**Documentación:**
- Agentes: Este directorio
- Skills: `/.github/skills/`
- Proyecto: `/docs/`

**Actualizaciones:**
- Este documento se actualiza cuando se agregan nuevos agentes
- Última actualización: Abril 2026 (Agente Legal & Compliance Specialist agregado)

---

**¿Preguntas?** Consulta la documentación de cada agente en los archivos `.agent.md` correspondientes.
