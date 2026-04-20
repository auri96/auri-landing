# 🚀 Auri Landing Page

Landing page oficial de **Auri** - La aplicación fintech que revoluciona las finanzas personales en Colombia.

## 📋 Descripción

Landing page de una sola página (one-page) diseñada para capturar la atención, transmitir confianza financiera y motivar la descarga de la app mediante código QR prominente.

## 🎨 Design System

- **Paleta de Colores:**
  - Primary (Neon Cyan): `#00F2FF`
  - Secondary (Royal Purple): `#8A2BE2`
  - Success (Green): `#8EFF71`
  - Background: `#051631`
  - Surface: `#121829`

- **Tipografía:** Mulish (única fuente del sistema)
- **Border Radius:** 24px para containers principales
- **Efectos:** Ambient glows, gradientes cyan-purple, glassmorphism

## 🛠️ Stack Tecnológico

- **HTML5** - Estructura semántica
- **CSS3** - Estilos personalizados con gradientes y efectos
- **TailwindCSS** - Framework CSS vía CDN
- **Google Fonts** - Mulish y Material Symbols
- **JavaScript Vanilla** - Interacciones básicas

## 📁 Estructura de Archivos

```
auri-landing/
├── index.html          # Página principal
├── README.md           # Este archivo
├── .gitignore          # Archivos ignorados por Git
├── CNAME               # Dominio personalizado (opcional)
└── .github/
    └── workflows/
        └── deploy.yml  # GitHub Actions para deployment
```

## 🚀 Deployment

### GitHub Pages (Recomendado)

1. **Crear repositorio en GitHub:**
   ```bash
   # Inicializar Git
   git init
   git add .
   git commit -m "Initial commit: Auri Landing Page"
   
   # Crear repositorio en GitHub (desde la web o CLI)
   # Luego conectar y subir:
   git remote add origin https://github.com/tu-usuario/auri-landing.git
   git branch -M main
   git push -u origin main
   ```

2. **Configurar GitHub Pages:**
   - Ve a **Settings** → **Pages**
   - En **Source**, selecciona `main` branch y carpeta `/ (root)`
   - Guarda los cambios
   - Tu sitio estará disponible en: `https://tu-usuario.github.io/auri-landing/`

3. **Dominio Personalizado (Opcional):**
   - Edita el archivo `CNAME` con tu dominio: `landing.auri.app`
   - Configura el DNS de tu dominio:
     - **Tipo A** → Apunta a las IPs de GitHub:
       - `185.199.108.153`
       - `185.199.109.153`
       - `185.199.110.153`
       - `185.199.111.153`
     - **O Tipo CNAME** → `tu-usuario.github.io`

### Netlify (Alternativa)

1. Arrastra la carpeta `auri-landing` a [Netlify Drop](https://app.netlify.com/drop)
2. Configura dominio personalizado desde el dashboard
3. SSL automático incluido

### Vercel (Alternativa)

1. Instala Vercel CLI:
   ```bash
   npm i -g vercel
   ```
2. Deploy:
   ```bash
   cd auri-landing
   vercel --prod
   ```

## 📝 Tareas Pendientes

- [ ] Generar código QR real con URL de descarga
- [ ] Reemplazar placeholders de imágenes con screenshots reales de la app
- [ ] Agregar analytics (Google Analytics, Plausible, etc.)
- [ ] Implementar meta tags Open Graph completos
- [ ] Optimizar imágenes (WebP, lazy loading)
- [ ] Agregar favicon y app icons
- [ ] Crear páginas legales (privacy.html, terms.html, support.html)
- [ ] Implementar formulario de contacto (opcional)

## 🔗 Links

- **App Store:** (Próximamente)
- **Google Play:** (Próximamente)
- **Sitio Web:** [https://auri.app](https://auri.app) (pendiente)
- **Soporte:** support@auri.app (pendiente)

## 📊 SEO

- **Title:** "Auri - Control Financiero Inteligente | App Fintech Colombia"
- **Description:** "Gestiona tus finanzas personales con Auri. Registra gastos, crea presupuestos y recibe insights automáticos."
- **Keywords:** fintech, finanzas personales, control de gastos, presupuestos, app financiera Colombia

## 🤝 Contribuciones

Este es un proyecto privado de Auri. Para reportar problemas o sugerencias, contacta al equipo de desarrollo.

## 📄 Licencia

© 2026 Auri. Todos los derechos reservados.

---

**Creado con ❤️ por el equipo de Auri**
