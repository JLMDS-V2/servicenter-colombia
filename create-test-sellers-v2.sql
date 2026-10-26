-- Desactivar temporalmente el constraint de foreign key
ALTER TABLE public.users DROP CONSTRAINT users_id_fkey;

-- Crear vendedores de prueba
INSERT INTO public.users (id, email, role, city, location, full_name, phone, description, whatsapp, preferred_contact, categories, is_verified, rating, review_count, created_at)
VALUES
-- Electricista en Bogotá
(
  gen_random_uuid(),
  'carlos_electricista@email.com',
  'seller',
  'Bogotá',
  'Bogotá',
  'Carlos Rodríguez',
  '+573012345678',
  'Electricista con 15 años de experiencia. Instalaciones, reparaciones, cableado residencial y comercial. Servicio garantizado.',
  '+573012345678',
  'both',
  ARRAY['1'],
  true,
  4.8,
  23,
  NOW()
),
-- Plomero en Medellín
(
  gen_random_uuid(),
  'maria_plomera@email.com',
  'seller',
  'Medellín',
  'Medellín',
  'María González',
  '+573109876543',
  'Plomera profesional especializada en reparaciones de fugas, instalaciones de tuberías y baños completos. Atención 24/7.',
  '+573109876543',
  'both',
  ARRAY['2'],
  true,
  4.9,
  31,
  NOW()
),
-- Cerrajero en Cali
(
  gen_random_uuid(),
  'juan_cerrajero@email.com',
  'seller',
  'Cali',
  'Cali',
  'Juan Martínez',
  '+573115678901',
  'Cerrajero experto en apertura de puertas, cambio de cerraduras, llaves duplicadas y sistemas de seguridad. Servicio rápido.',
  '+573115678901',
  'whatsapp',
  ARRAY['3'],
  true,
  4.7,
  18,
  NOW()
),
-- Carpintero en Barranquilla
(
  gen_random_uuid(),
  'pedro_carpintero@email.com',
  'seller',
  'Barranquilla',
  'Barranquilla',
  'Pedro López',
  '+573114567890',
  'Carpintero con más de 20 años de experiencia. Muebles a medida, reparaciones, puertas, ventanas y trabajos en madera.',
  '+573114567890',
  'chat',
  ARRAY['4'],
  false,
  4.5,
  12,
  NOW()
),
-- Pintor en Cartagena
(
  gen_random_uuid(),
  'ana_pintora@email.com',
  'seller',
  'Cartagena',
  'Cartagena',
  'Ana Silva',
  '+573123456789',
  'Pintora profesional con experiencia en interiores y exteriores. Trabajos de calidad, acabados perfectos y colores que transforman espacios.',
  '+573123456789',
  'both',
  ARRAY['5'],
  true,
  4.9,
  27,
  NOW()
),
-- Albañil en Bucaramanga
(
  gen_random_uuid(),
  'luis_albanil@email.com',
  'seller',
  'Bucaramanga',
  'Bucaramanga',
  'Luis Torres',
  '+573112345678',
  'Albañil experto en construcción, reparaciones estructurales, paredes, techos y acabados generales. Trabajo serio y garantizado.',
  '+573112345678',
  'both',
  ARRAY['6'],
  true,
  4.6,
  15,
  NOW()
),
-- Jardinero en Pereira
(
  gen_random_uuid(),
  'roberto_jardinero@email.com',
  'seller',
  'Pereira',
  'Pereira',
  'Roberto Castro',
  '+573109876123',
  'Jardinero profesional especializado en mantenimiento de jardines, poda, diseño de paisajes y cuidado de plantas.',
  '+573109876123',
  'whatsapp',
  ARRAY['7'],
  false,
  4.4,
  9,
  NOW()
),
-- Limpieza en Manizales
(
  gen_random_uuid(),
  'laura_limpieza@email.com',
  'seller',
  'Manizales',
  'Manizales',
  'Laura Ramírez',
  '+573107654321',
  'Servicio de limpieza del hogar profundo y aseo regular. Personal confiable, productos de calidad y resultados impecables.',
  '+573107654321',
  'both',
  ARRAY['8'],
  true,
  4.8,
  22,
  NOW()
),
-- Aire Acondicionado en Cúcuta
(
  gen_random_uuid(),
  'diego_ac@email.com',
  'seller',
  'Cúcuta',
  'Cúcuta',
  'Diego Morales',
  '+573105432109',
  'Técnico especializado en instalación, mantenimiento y reparación de aires acondicionados. Certificado y con garantía.',
  '+573105432109',
  'both',
  ARRAY['9'],
  true,
  4.7,
  19,
  NOW()
),
-- Refrigeración en Ibagué
(
  gen_random_uuid(),
  'carmen_refrigeracion@email.com',
  'seller',
  'Ibagué',
  'Ibagué',
  'Carmen Vega',
  '+573103210987',
  'Experta en reparación de neveras, refrigeradores, lavadoras y electrodomésticos. Diagnóstico preciso y precios justos.',
  '+573103210987',
  'chat',
  ARRAY['10'],
  false,
  4.5,
  11,
  NOW()
);

-- Reactivar el constraint de foreign key
ALTER TABLE public.users ADD CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;
