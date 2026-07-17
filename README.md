# Bienestar Laboral — Vercel + Supabase Auth

Esta versión conserva el diseño HTML y agrega usuarios reales, cambio de contraseña, roles Administrador/RH y una administración de usuarios protegida.

## Activación inicial

1. En Supabase abre **SQL Editor → New query**, pega `supabase-schema.sql` y pulsa **Run**.
2. En **Authentication → Users → Add user**, crea tu primer usuario administrador con correo y contraseña.
3. En SQL Editor ejecuta, sustituyendo el correo:

```sql
update public.profiles set role = 'ADMIN' where email = 'tu-correo@empresa.com';
```

4. Sube el contenido de esta carpeta a la raíz del repositorio GitHub.
5. En Vercel configura estas variables en **Settings → Environment Variables**:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
```

El valor de `SUPABASE_SERVICE_ROLE_KEY` se obtiene en Supabase en **Project Settings → API**. Nunca lo pongas en `supabase-config.js` ni lo compartas: solo se usa en las funciones seguras de Vercel.

6. Redepliega. En Vercel selecciona **Framework: Other**, sin build command y output directory `.`.

## Uso

- Cada usuario inicia sesión con el correo y contraseña creados en Supabase.
- Cada persona puede pulsar **Cambiar contraseña** en el menú lateral.
- Solo el rol Administrador ve **Usuarios**, donde puede crear cuentas y restablecer contraseñas.
