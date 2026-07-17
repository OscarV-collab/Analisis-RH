# Versión HTML estática

No requiere Node.js, PHP ni base de datos. Abre `index.html` directamente con Chrome, Edge o Firefox, o súbelo a GitHub Pages, Netlify, Cloudflare Pages o cualquier hosting estático.

Los estudios se guardan con `localStorage`: permanecen en el mismo navegador y dispositivo, pero no se comparten con otras personas ni se respaldan en un servidor. Para uso empresarial con usuarios y datos compartidos, utiliza la versión `../php-mysql`.

El menú **Catálogo de preguntas** permite activar, dar de baja, eliminar o agregar preguntas. El formulario utiliza siempre las preguntas activas. En **Reportes** y en el catálogo está disponible la plantilla Excel `assets/Plantilla_Cuestionario_CR3.xlsx`.

Acceso de demostración: `admin@empresa.com` / `admin123`.

## Publicar en InfinityFree

1. En InfinityFree abre **File Manager** y entra a la carpeta `htdocs`.
2. Sube **el contenido** de esta carpeta (no una carpeta contenedora): `index.html`, `styles.css`, `app.js`, `assets/` y este README.
3. Conserva la estructura de `assets/`, ya que contiene los logotipos y la plantilla Excel descargable.
4. Abre tu dominio. El archivo `index.html` se cargará automáticamente.

No necesitas crear una base de datos ni configurar PHP para esta versión. Los datos se guardan únicamente en el navegador de cada usuario.
