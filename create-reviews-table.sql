-- Crear tabla de reseñas
CREATE TABLE IF NOT EXISTS public.reviews (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  seller_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_reviews_seller_id ON public.reviews(seller_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON public.reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON public.reviews(created_at DESC);

-- Habilitar RLS (Row Level Security)
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

-- Políticas de RLS
-- Cualquiera puede leer las reseñas
CREATE POLICY "Las reseñas son visibles para todos"
  ON public.reviews FOR SELECT
  USING (true);

-- Solo usuarios autenticados pueden crear reseñas
CREATE POLICY "Solo usuarios autenticados pueden crear reseñas"
  ON public.reviews FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Solo el autor puede actualizar su reseña
CREATE POLICY "Solo el autor puede actualizar su reseña"
  ON public.reviews FOR UPDATE
  USING (auth.uid() = user_id);

-- Solo el autor puede eliminar su reseña
CREATE POLICY "Solo el autor puede eliminar su reseña"
  ON public.reviews FOR DELETE
  USING (auth.uid() = user_id);
