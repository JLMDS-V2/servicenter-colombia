-- Crear usuarios de prueba en auth.users primero
-- Nota: Esto requiere que el trigger no se active, así que desactivamos el trigger temporalmente

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Crear usuarios en auth.users
DO $$
DECLARE
  user_id UUID;
BEGIN
  -- Electricista en Bogotá
  user_id := gen_random_uuid();
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
  VALUES (user_id, 'carlos_electricista@email.com', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW());
  
  -- Plomero en Medellín
  user_id := gen_random_uuid();
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
  VALUES (user_id, 'maria_plomera@email.com', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW());
  
  -- Cerrajero en Cali
  user_id := gen_random_uuid();
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
  VALUES (user_id, 'juan_cerrajero@email.com', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW());
  
  -- Carpintero en Barranquilla
  user_id := gen_random_uuid();
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
  VALUES (user_id, 'pedro_carpintero@email.com', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW());
  
  -- Pintor en Cartagena
  user_id := gen_random_uuid();
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
  VALUES (user_id, 'ana_pintora@email.com', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW());
  
  -- Albañil en Bucaramanga
  user_id := gen_random_uuid();
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
  VALUES (user_id, 'luis_albanil@email.com', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW());
  
  -- Jardinero en Pereira
  user_id := gen_random_uuid();
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
  VALUES (user_id, 'roberto_jardinero@email.com', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW());
  
  -- Limpieza en Manizales
  user_id := gen_random_uuid();
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
  VALUES (user_id, 'laura_limpieza@email.com', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW());
  
  -- Aire Acondicionado en Cúcuta
  user_id := gen_random_uuid();
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
  VALUES (user_id, 'diego_ac@email.com', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW());
  
  -- Refrigeración en Ibagué
  user_id := gen_random_uuid();
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
  VALUES (user_id, 'carmen_refrigeracion@email.com', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW());
END $$;

-- Reactivar el trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Ahora insertar los perfiles en public.users con los mismos IDs
INSERT INTO public.users (id, email, role, city, location, full_name, phone, description, whatsapp, preferred_contact, categories, is_verified, rating, review_count, created_at)
SELECT
  au.id,
  au.email,
  'seller',
  u.city,
  u.city,
  u.full_name,
  u.phone,
  u.description,
  u.whatsapp,
  u.preferred_contact,
  u.categories,
  u.is_verified,
  u.rating,
  u.review_count,
  NOW()
FROM (
  VALUES
  ('carlos_electricista@email.com', 'Bogotá', 'Carlos Rodríguez', '+573012345678', 'Electricista con 15 años de experiencia. Instalaciones, reparaciones, cableado residencial y comercial. Servicio garantizado.', '+573012345678', 'both', ARRAY['1'], true, 4.8, 23),
  ('maria_plomera@email.com', 'Medellín', 'María González', '+573109876543', 'Plomera profesional especializada en reparaciones de fugas, instalaciones de tuberías y baños completos. Atención 24/7.', '+573109876543', 'both', ARRAY['2'], true, 4.9, 31),
  ('juan_cerrajero@email.com', 'Cali', 'Juan Martínez', '+573115678901', 'Cerrajero experto en apertura de puertas, cambio de cerraduras, llaves duplicadas y sistemas de seguridad. Servicio rápido.', '+573115678901', 'whatsapp', ARRAY['3'], true, 4.7, 18),
  ('pedro_carpintero@email.com', 'Barranquilla', 'Pedro López', '+573114567890', 'Carpintero con más de 20 años de experiencia. Muebles a medida, reparaciones, puertas, ventanas y trabajos en madera.', '+573114567890', 'chat', ARRAY['4'], false, 4.5, 12),
  ('ana_pintora@email.com', 'Cartagena', 'Ana Silva', '+573123456789', 'Pintora profesional con experiencia en interiores y exteriores. Trabajos de calidad, acabados perfectos y colores que transforman espacios.', '+573123456789', 'both', ARRAY['5'], true, 4.9, 27),
  ('luis_albanil@email.com', 'Bucaramanga', 'Luis Torres', '+573112345678', 'Albañil experto en construcción, reparaciones estructurales, paredes, techos y acabados generales. Trabajo serio y garantizado.', '+573112345678', 'both', ARRAY['6'], true, 4.6, 15),
  ('roberto_jardinero@email.com', 'Pereira', 'Roberto Castro', '+573109876123', 'Jardinero profesional especializado en mantenimiento de jardines, poda, diseño de paisajes y cuidado de plantas.', '+573109876123', 'whatsapp', ARRAY['7'], false, 4.4, 9),
  ('laura_limpieza@email.com', 'Manizales', 'Laura Ramírez', '+573107654321', 'Servicio de limpieza del hogar profundo y aseo regular. Personal confiable, productos de calidad y resultados impecables.', '+573107654321', 'both', ARRAY['8'], true, 4.8, 22),
  ('diego_ac@email.com', 'Cúcuta', 'Diego Morales', '+573105432109', 'Técnico especializado en instalación, mantenimiento y reparación de aires acondicionados. Certificado y con garantía.', '+573105432109', 'both', ARRAY['9'], true, 4.7, 19),
  ('carmen_refrigeracion@email.com', 'Ibagué', 'Carmen Vega', '+573103210987', 'Experta en reparación de neveras, refrigeradores, lavadoras y electrodomésticos. Diagnóstico preciso y precios justos.', '+573103210987', 'chat', ARRAY['10'], false, 4.5, 11)
) AS u(email, city, full_name, phone, description, whatsapp, preferred_contact, categories, is_verified, rating, review_count)
JOIN auth.users au ON au.email = u.email
ON CONFLICT (id) DO UPDATE SET
  role = EXCLUDED.role,
  city = EXCLUDED.city,
  location = EXCLUDED.location,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  description = EXCLUDED.description,
  whatsapp = EXCLUDED.whatsapp,
  preferred_contact = EXCLUDED.preferred_contact,
  categories = EXCLUDED.categories,
  is_verified = EXCLUDED.is_verified,
  rating = EXCLUDED.rating,
  review_count = EXCLUDED.review_count;
