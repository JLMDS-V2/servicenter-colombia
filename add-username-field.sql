-- Agregar campo username a la tabla users
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS username TEXT;

-- Crear índice para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_users_username ON public.users(username);
