-- ⚠️ ADVERTENCIA: Este script eliminará TODOS los datos de la base de datos
-- Ejecutar solo si estás seguro de que quieres limpiar toda la base de datos

-- Eliminar todas las conversaciones
DELETE FROM public.conversations;

-- Eliminar todos los mensajes
DELETE FROM public.messages;

-- Eliminar todas las reseñas
DELETE FROM public.reviews;

-- Eliminar todos los usuarios (vendedores y usuarios normales)
DELETE FROM public.users;

-- Confirmación
SELECT 'Base de datos limpiada exitosamente' as status;
