# Servicios del Hogar Colombia

Plataforma web para conectar usuarios con profesionales del hogar (electricistas, plomeros, cerrajeros, etc.) en Colombia.

## Características

- 🏠 **Dos roles de usuario**: Usuario normal y Vendedor/Profesional
- 📍 **Geolocalización**: Selección de ciudad en Colombia para recomendaciones locales
- ⭐ **Sistema de calificaciones**: Reviews y estrellas para construir confianza
- 💬 **Chat interno**: Comunicación directa entre usuarios y vendedores
- 📱 **Integración WhatsApp**: Opción de contacto vía WhatsApp
- ✅ **Verificación**: Sistema de suscripción para vendedores verificados
- 🎨 **UI Glassmorphism**: Diseño moderno con efecto "liquid glass"
- 📊 **Anuncios**: Espacios para publicidad

## Stack Tecnológico

- **Frontend**: Next.js 14 (App Router) + TypeScript
- **Estilos**: Tailwind CSS
- **Backend/Database**: Supabase (PostgreSQL, Auth, Realtime)
- **UI Components**: Lucide React (iconos)

## Instalación

### 1. Clonar el repositorio

```bash
git clone <tu-repo-url>
cd servicios-hogar
```

### 2. Instalar dependencias

```bash
npm install
```

### 3. Configurar Supabase

1. Crea un proyecto nuevo en [Supabase](https://supabase.com)
2. Ve a Settings > API y copia:
   - Project URL
   - anon public key
3. Crea un archivo `.env.local` en la raíz del proyecto:

```env
NEXT_PUBLIC_SUPABASE_URL=tu_url_aqui
NEXT_PUBLIC_SUPABASE_ANON_KEY=tu_anon_key_aqui
```

### 4. Ejecutar el schema de la base de datos

1. Ve al SQL Editor en tu dashboard de Supabase
2. Copia y ejecuta el contenido del archivo `supabase-schema.sql`

### 5. Configurar autenticación en Supabase

1. Ve a Authentication > Providers
2. Habilita Email provider
3. Deshabilita "Confirm email" (para no requerir OTP/confirmación)
4. En Site URL, pon: `http://localhost:3000`
5. En Redirect URLs, añade: `http://localhost:3000/auth/callback`

### 6. Ejecutar la aplicación

```bash
npm run dev
```

Abre [http://localhost:3000](http://localhost:3000) en tu navegador.

## Estructura del Proyecto

```
servicios-hogar/
├── src/
│   ├── app/
│   │   ├── auth/          # Página de login/registro
│   │   ├── categories/   # Listado de categorías
│   │   ├── chat/          # Sistema de mensajería
│   │   ├── profile/       # Perfil de usuario
│   │   ├── sellers/       # Listado de vendedores
│   │   ├── layout.tsx     # Layout principal
│   │   ├── page.tsx       # Página de inicio
│   │   └── globals.css    # Estilos globales + glassmorphism
│   ├── components/        # Componentes reutilizables
│   ├── lib/
│   │   ├── supabase.ts    # Cliente de Supabase
│   │   └── data.ts        # Datos estáticos (ciudades, categorías)
│   └── types/
│       └── index.ts       # Definiciones de TypeScript
├── public/                # Archivos estáticos
├── supabase-schema.sql    # Schema de la base de datos
└── package.json
```

## Funcionalidades Principales

### Registro y Login
- Registro con email y contraseña (sin OTP)
- Selección de ciudad durante el registro
- Elección de rol (usuario o vendedor)

### Categorías
- 12 categorías de servicios del hogar
- Filtros por ubicación
- Visualización de vendedores por categoría

### Sistema de Vendedores
- Perfil con descripción y categorías
- Configuración de método de contacto (WhatsApp, Chat, ambos)
- Sistema de verificación y suscripción
- Calificaciones y reviews

### Chat
- Chat en tiempo real entre usuarios y vendedores
- Listado de conversaciones
- Ordenamiento por urgencia (mensajes más antiguos primero)

### Perfil
- Edición de información personal
- Para vendedores: configuración de servicios y contacto
- Cambio de ubicación

## Despliegue

### Vercel (Recomendado)

1. Conecta tu repositorio a Vercel
2. Configura las variables de entorno:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
3. Deploy automático

## Próximas Mejoras

- [ ] Sistema de pagos para suscripción de vendedores
- [ ] Notificaciones push
- [ ] Búsqueda avanzada de vendedores
- [ ] Filtros por calificación y precio
- [ ] Sistema de favoritos
- [ ] Reporte de usuarios
- [ ] Analytics dashboard para vendedores

## Licencia

MIT
