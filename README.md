# Bienestar Laboral — Vercel + Supabase

Esta versión conserva el diseño HTML actual y guarda los estudios y el catálogo en Supabase, por lo que los registros se comparten entre equipos.

## Activación

1. En Supabase abre **SQL Editor → New query**.
2. Copia el contenido completo de `supabase-schema.sql` y ejecuta **Run**.
3. Sube los archivos de esta carpeta a la raíz de tu repositorio de GitHub.
4. En Vercel importa ese repositorio con **Framework: Other**, sin variables ambientales, sin comando de compilación y con directorio de salida `.`.

La versión actual utiliza permisos compartidos para que los equipos autorizados puedan capturar estudios con el mismo enlace. Para un entorno productivo con datos sensibles, el siguiente paso recomendado es sustituir el acceso demo por Supabase Auth y aplicar reglas por usuario/rol.
