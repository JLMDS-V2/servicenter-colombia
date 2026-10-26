-- Script para generar vendedores de demostración extensos
-- Genera múltiples vendedores por categoría en diferentes ciudades de Colombia
-- Desactivar trigger temporalmente
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Crear usuarios en auth.users
DO $$
DECLARE
  user_id UUID;
  i INTEGER;
  first_names TEXT[] := ARRAY['Carlos', 'Juan', 'Pedro', 'Luis', 'José', 'Miguel', 'Roberto', 'Andrés', 'Jorge', 'Ricardo', 'Fernando', 'Santiago', 'Alejandro', 'Daniel', 'Gustavo', 'María', 'Ana', 'Laura', 'Carmen', 'Patricia', 'Sofía', 'Valentina', 'Isabella', 'Camila', 'Lucía', 'Daniela', 'Andrea', 'Natalia', 'Paula', 'Juliana', 'Martha', 'Beatriz', 'Teresa', 'Elena', 'Rosa', 'Gloria', 'Lina', 'Carolina', 'Melissa', 'Stephanie', 'Manuela', 'Ximena'];
  last_names TEXT[] := ARRAY['Rodríguez', 'González', 'Martínez', 'López', 'García', 'Torres', 'Ramírez', 'Rivera', 'Castro', 'Flores', 'Morales', 'Cruz', 'Sánchez', 'Pérez', 'Gómez', 'Reyes', 'Jiménez', 'Mendoza', 'Ruiz', 'Hernández', 'Silva', 'Mosquera', 'Vargas', 'Cortés', 'Ortiz', 'Rojas', 'Arias', 'Castillo', 'Navarro', 'Benítez', 'Medina', 'Muñoz', 'Quintero', 'Guerrero', 'Estrada', 'Ocampo', 'Rincón', 'Romero', 'Bedoya', 'Londoño', 'Giraldo', 'Arango', 'Salazar', 'Paredes'];
  cities TEXT[] := ARRAY['Bogotá', 'Medellín', 'Cali', 'Barranquilla', 'Cartagena', 'Cúcuta', 'Bucaramanga', 'Pereira', 'Ibagué', 'Manizales', 'Santa Marta', 'Villavicencio', 'Armenia', 'Pasto', 'Neiva', 'Valledupar', 'Montería', 'Soledad', 'Bello', 'Itagüí', 'Soacha', 'Popayán', 'Envigado', 'Palmira', 'Tuluá', 'Villavicencio', 'Dosquebradas', 'Floridablanca', 'Girón', 'Piedecuesta', 'Duitama', 'Tunja', 'Girardot', 'Zipaquirá', 'Chía', 'Cajicá', 'Facatativá', 'Yopal', 'Sincelejo', 'Tumaco', 'Riohacha', 'Quibdó', 'Mocoa', 'Arauca', 'Florencia', 'Leticia', 'Inírida', 'Mitú', 'Puerto Carreño'];
  category_ids TEXT[] := ARRAY['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  category_names TEXT[] := ARRAY['Electricista', 'Plomero', 'Cerrajero', 'Carpintero', 'Pintor', 'Albañil', 'Jardinero', 'Limpieza', 'Aire Acondicionado', 'Refrigeración', 'Techos', 'Vidrios'];
  phone_numbers TEXT[] := ARRAY['+57301', '+57302', '+57303', '+57310', '+57311', '+57312', '+57313', '+57314', '+57315', '+57316', '+57317', '+57318', '+57319', '+57320', '+57321', '+57322', '+57323', '+57324', '+57325', '+57326', '+57327', '+57328', '+57329', '+57330', '+57331', '+57332', '+57333', '+57334', '+57335', '+57336', '+57337', '+57338', '+57339', '+57350', '+57351', '+57352', '+57353', '+57354', '+57355', '+57356', '+57357', '+57358', '+57359', '+57360', '+57361', '+57362', '+57363', '+57364', '+57365', '+57366', '+57367', '+57368', '+57369', '+57370', '+57371', '+57372', '+57373', '+57374', '+57375', '+57376', '+57377', '+57378', '+57379'];
BEGIN
  -- Generar vendedores para las ciudades principales (más vendedores por categoría)
  FOR i IN 1..300 LOOP
    user_id := gen_random_uuid();
    INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
    VALUES (
      user_id,
      'vendedor_' || i || '@servicenter.com',
      crypt('password123', gen_salt('bf')),
      NOW(),
      NOW(),
      NOW()
    );
  END LOOP;
END $$;

-- Reactivar el trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Insertar perfiles de vendedores en public.users
-- Vendedores principales de Electricista en ciudades principales
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
  -- Electricistas en Bogotá
  ('vendedor_1@servicenter.com', 'Bogotá', 'Carlos Rodríguez', '+573012345678', 'Electricista con 15 años de experiencia. Instalaciones residenciales y comerciales, cableado, tableros eléctricos. Servicio garantizado.', '+573012345678', 'both', ARRAY['1'], true, 4.8, 45),
  ('vendedor_2@servicenter.com', 'Bogotá', 'Juan Martínez', '+573012345679', 'Electricista certificado especializado en iluminación LED, domótica y sistemas de seguridad. Atención urgente 24/7.', '+573012345679', 'whatsapp', ARRAY['1'], true, 4.9, 52),
  ('vendedor_3@servicenter.com', 'Bogotá', 'Pedro López', '+573012345680', 'Reparaciones eléctricas rápidas. Problemas de cortocircuito, sobrecargas, instalaciones nuevas. Precios competitivos.', '+573012345680', 'chat', ARRAY['1'], false, 4.5, 28),
  ('vendedor_4@servicenter.com', 'Bogotá', 'Luis Torres', '+573012345681', 'Electricista especializado en edificios y apartamentos. Instalaciones completas, mantenimiento preventivo.', '+573012345681', 'both', ARRAY['1'], true, 4.7, 38),
  ('vendedor_5@servicenter.com', 'Bogotá', 'José Castro', '+573012345682', 'Electricista con experiencia industrial. Motores, transformadores, sistemas de potencia.', '+573012345682', 'whatsapp', ARRAY['1'], true, 4.6, 31),
  
  -- Electricistas en Medellín
  ('vendedor_6@servicenter.com', 'Medellín', 'Miguel Ramírez', '+573014567890', 'Electricista profesional en Medellín. Instalaciones, reparaciones, cableado estructurado. Servicio confiable.', '+573014567890', 'both', ARRAY['1'], true, 4.8, 42),
  ('vendedor_7@servicenter.com', 'Medellín', 'Roberto Silva', '+573014567891', 'Especialista en iluminación decorativa y de seguridad. Diseño de ambientes con luz. Consultas gratuitas.', '+573014567891', 'chat', ARRAY['1'], false, 4.4, 25),
  ('vendedor_8@servicenter.com', 'Medellín', 'Andrés Flores', '+573014567892', 'Electricista urgente disponible 24 horas. Reparaciones rápidas, emergencias, diagnósticos precisos.', '+573014567892', 'whatsapp', ARRAY['1'], true, 4.9, 55),
  ('vendedor_9@servicenter.com', 'Medellín', 'Jorge Morales', '+573014567893', 'Instalaciones eléctricas para nuevas construcciones. Planos, certificaciones, normativas vigentes.', '+573014567893', 'both', ARRAY['1'], true, 4.7, 36),
  ('vendedor_10@servicenter.com', 'Medellín', 'Ricardo Cruz', '+573014567894', 'Electricista especializado en energía solar. Paneles solares, baterías, sistemas autónomos.', '+573014567894', 'both', ARRAY['1'], true, 4.8, 29),
  
  -- Electricistas en Cali
  ('vendedor_11@servicenter.com', 'Cali', 'Fernando Gómez', '+573019876543', 'Electricista en Cali con más de 20 años de experiencia. Todo tipo de trabajos eléctricos residenciales.', '+573019876543', 'both', ARRAY['1'], true, 4.6, 33),
  ('vendedor_12@servicenter.com', 'Cali', 'Sánchez Reyes', '+573019876544', 'Reparaciones eléctricas rápidas y económicas. Servicios urgentes, cambios de instalación, cableado.', '+573019876544', 'whatsapp', ARRAY['1'], false, 4.3, 22),
  ('vendedor_13@servicenter.com', 'Cali', 'Daniel Jiménez', '+573019876545', 'Electricista certificado para instalaciones comerciales. Tiendas, oficinas, locales. Garantía incluida.', '+573019876545', 'both', ARRAY['1'], true, 4.7, 41),
  ('vendedor_14@servicenter.com', 'Cali', 'Gustavo Mendoza', '+573019876546', 'Especialista en redes eléctricas y comunicaciones. WiFi, cableado estructurado, sistemas de voz y datos.', '+573019876546', 'chat', ARRAY['1'], true, 4.5, 27),
  ('vendedor_15@servicenter.com', 'Cali', 'María Ruiz', '+573019876547', 'Electricista profesional. Instalaciones de alumbrado público, fachadas, decoración con LED.', '+573019876547', 'both', ARRAY['1'], true, 4.8, 39),
  
  -- Electricistas en Barranquilla
  ('vendedor_16@servicenter.com', 'Barranquilla', 'Patricia Hernández', '+573015432109', 'Electricista en Barranquilla. Instalaciones, reparaciones, mantenimiento. Servicio personalizado.', '+573015432109', 'both', ARRAY['1'], true, 4.7, 35),
  ('vendedor_17@servicenter.com', 'Barranquilla', 'Sofía Flores', '+573015432110', 'Electricista urgente disponible. Problemas de energía, cortos, sobrecargas. Atención inmediata.', '+573015432110', 'whatsapp', ARRAY['1'], true, 4.9, 48),
  ('vendedor_18@servicenter.com', 'Barranquilla', 'Valentina Ramírez', '+573015432111', 'Especialista en instalaciones aéreas y subterráneas. Redes eléctricas, transformadores, acometidas.', '+573015432111', 'both', ARRAY['1'], true, 4.6, 30),
  ('vendedor_19@servicenter.com', 'Barranquilla', 'Isabella Castro', '+573015432112', 'Electricista para nuevas construcciones. Instalaciones completas, certificaciones, normativa RETIE.', '+573015432112', 'chat', ARRAY['1'], false, 4.4, 24),
  ('vendedor_20@servicenter.com', 'Barranquilla', 'Camila Torres', '+573015432113', 'Reparaciones eléctricas en apartamentos y casas. Cambios de interruptores, tomas, lámparas.', '+573015432113', 'both', ARRAY['1'], true, 4.5, 32),
  
  -- Electricistas en Cartagena
  ('vendedor_21@servicenter.com', 'Cartagena', 'Lucía García', '+573015678901', 'Electricista en Cartagena. Instalaciones y reparaciones en zonas históricas y modernas.', '+573015678901', 'both', ARRAY['1'], true, 4.8, 37),
  ('vendedor_22@servicenter.com', 'Cartagena', 'Daniela López', '+573015678902', 'Especialista en iluminación para eventos y decoración. Diseño personalizado, LEDs inteligentes.', '+573015678902', 'whatsapp', ARRAY['1'], true, 4.7, 29),
  ('vendedor_23@servicenter.com', 'Cartagena', 'Andrea Martínez', '+573015678903', 'Electricista urgente disponible. Reparaciones rápidas, diagnósticos precisos, precios justos.', '+573015678903', 'both', ARRAY['1'], true, 4.9, 44),
  ('vendedor_24@servicenter.com', 'Cartagena', 'Natalia Rodríguez', '+573015678904', 'Instalaciones eléctricas para hoteles y restaurantes. Sistemas de energía eficiente.', '+573015678904', 'chat', ARRAY['1'], true, 4.6, 31),
  ('vendedor_25@servicenter.com', 'Cartagena', 'Paula González', '+573015678905', 'Electricista con experiencia en aire acondicionado. Instalaciones eléctricas para AC split.', '+573015678905', 'both', ARRAY['1'], false, 4.4, 26)
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

-- Plomeros en ciudades principales
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
  -- Plomeros en Bogotá
  ('vendedor_26@servicenter.com', 'Bogotá', 'Juliana Giraldo', '+573012345683', 'Plomera profesional con 18 años de experiencia. Fugas, instalaciones de baños, cocinas completas.', '+573012345683', 'both', ARRAY['2'], true, 4.9, 58),
  ('vendedor_27@servicenter.com', 'Bogotá', 'Martha Arango', '+573012345684', 'Plomera urgente disponible 24/7. Reparaciones rápidas, desatascos, cambios de tuberías.', '+573012345684', 'whatsapp', ARRAY['2'], true, 4.8, 47),
  ('vendedor_28@servicenter.com', 'Bogotá', 'Beatriz Salazar', '+573012345685', 'Especialista en calderas y sistemas de agua caliente. Instalación, mantenimiento, reparación.', '+573012345685', 'both', ARRAY['2'], true, 4.7, 39),
  ('vendedor_29@servicenter.com', 'Bogotá', 'Teresa Londoño', '+573012345686', 'Plomera para nuevas construcciones. Instalaciones completas, certificaciones, pruebas de presión.', '+573012345686', 'chat', ARRAY['2'], true, 4.6, 34),
  ('vendedor_30@servicenter.com', 'Bogotá', 'Elena Bedoya', '+573012345687', 'Reparaciones de grifos, sanitarios, lavaderos. Servicio rápido y garantizado. Precios justos.', '+573012345687', 'both', ARRAY['2'], false, 4.5, 28),
  
  -- Plomeros en Medellín
  ('vendedor_31@servicenter.com', 'Medellín', 'Rosa Paredes', '+573014567895', 'Plomera en Medellín con amplia experiencia. Instalaciones, reparaciones, mantenimiento.', '+573014567895', 'both', ARRAY['2'], true, 4.8, 42),
  ('vendedor_32@servicenter.com', 'Medellín', 'Gloria Vargas', '+573014567896', 'Especialista en desatascos y reparaciones de tuberías. Equipo moderno, resultados garantizados.', '+573014567896', 'whatsapp', ARRAY['2'], true, 4.9, 51),
  ('vendedor_33@servicenter.com', 'Medellín', 'Lina Cortés', '+573014567897', 'Plomera urgente disponible. Fugas de agua, problemas de presión, reparaciones rápidas.', '+573014567897', 'both', ARRAY['2'], true, 4.7, 38),
  ('vendedor_34@servicenter.com', 'Medellín', 'Carolina Ortiz', '+573014567898', 'Instalaciones de baños y cocinas modernas. Diseño funcional, materiales de calidad.', '+573014567898', 'chat', ARRAY['2'], true, 4.6, 31),
  ('vendedor_35@servicenter.com', 'Medellín', 'Melissa Rincón', '+573014567899', 'Plomera especializada en sistemas de riego y jardines. Instalaciones, mantenimiento, reparación.', '+573014567899', 'both', ARRAY['2'], false, 4.4, 25),
  
  -- Plomeros en Cali
  ('vendedor_36@servicenter.com', 'Cali', 'Stephanie Romero', '+573019876548', 'Plomera en Cali. Reparaciones, instalaciones, mantenimiento de sistemas de agua y gas.', '+573019876548', 'both', ARRAY['2'], true, 4.7, 36),
  ('vendedor_37@servicenter.com', 'Cali', 'Manuela Ocampo', '+573019876549', 'Especialista en calentadores y termos. Instalación, reparación, mantenimiento preventivo.', '+573019876549', 'whatsapp', ARRAY['2'], true, 4.8, 43),
  ('vendedor_38@servicenter.com', 'Cali', 'Ximena Estrada', '+573019876550', 'Plomera urgente disponible. Desatascos, fugas, reparaciones de emergencia.', '+573019876550', 'both', ARRAY['2'], true, 4.9, 49),
  ('vendedor_39@servicenter.com', 'Cali', 'Claudia Guerrero', '+573019876551', 'Instalaciones para nuevas construcciones. Redes de agua, desagüe, gas certificado.', '+573019876551', 'chat', ARRAY['2'], true, 4.6, 32),
  ('vendedor_40@servicenter.com', 'Cali', 'Adriana Navarro', '+573019876552', 'Reparaciones de sanitarios, grifos, lavaderos. Servicio rápido y económico.', '+573019876552', 'both', ARRAY['2'], false, 4.5, 27),
  
  -- Plomeros en Barranquilla
  ('vendedor_41@servicenter.com', 'Barranquilla', 'Cristina Benítez', '+573015432114', 'Plomera en Barranquilla. Amplia experiencia en instalaciones y reparaciones.', '+573015432114', 'both', ARRAY['2'], true, 4.8, 41),
  ('vendedor_42@servicenter.com', 'Barranquilla', 'Viviana Muñoz', '+573015432115', 'Especialista en sistemas de agua potable y alcantarillado. Instalaciones, reparaciones.', '+573015432115', 'whatsapp', ARRAY['2'], true, 4.7, 35),
  ('vendedor_43@servicenter.com', 'Barranquilla', 'Nicolás Quintero', '+573015432116', 'Plomero urgente disponible. Desatascos, fugas, reparaciones rápidas.', '+573015432116', 'both', ARRAY['2'], true, 4.9, 46),
  ('vendedor_44@servicenter.com', 'Barranquilla', 'Sebastián Bedoya', '+573015432117', 'Instalaciones de baños completos. Diseño moderno, materiales de primera calidad.', '+573015432117', 'chat', ARRAY['2'], true, 4.6, 30),
  ('vendedor_45@servicenter.com', 'Barranquilla', 'Mateo Londoño', '+573015432118', 'Reparaciones de calderas y sistemas de calefacción. Servicio especializado.', '+573015432118', 'both', ARRAY['2'], false, 4.4, 24),
  
  -- Plomeros en Cartagena
  ('vendedor_46@servicenter.com', 'Cartagena', 'Samuel Giraldo', '+573015678906', 'Plomero en Cartagena. Instalaciones y reparaciones en clima tropical. Expertos en corrosión.', '+573015678906', 'both', ARRAY['2'], true, 4.8, 38),
  ('vendedor_47@servicenter.com', 'Cartagena', 'Emmanuel Arango', '+573015678907', 'Especialista en sistemas de agua salada y desalinización. Instalaciones, mantenimiento.', '+573015678907', 'whatsapp', ARRAY['2'], true, 4.7, 33),
  ('vendedor_48@servicenter.com', 'Cartagena', 'Gabriel Salazar', '+573015678908', 'Plomero urgente disponible. Reparaciones rápidas, diagnósticos precisos.', '+573015678908', 'both', ARRAY['2'], true, 4.9, 45),
  ('vendedor_49@servicenter.com', 'Cartagena', 'Felipe Paredes', '+573015678909', 'Instalaciones para hoteles y resorts. Sistemas de agua caliente, piscinas, spas.', '+573015678909', 'chat', ARRAY['2'], true, 4.6, 29),
  ('vendedor_50@servicenter.com', 'Cartagena', 'Diego Vargas', '+573015678910', 'Reparaciones de fugas en tuberías subterráneas. Localización y reparación experta.', '+573015678910', 'both', ARRAY['2'], false, 4.5, 26)
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

-- Cerrajeros en ciudades principales
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
  -- Cerrajeros en Bogotá
  ('vendedor_51@servicenter.com', 'Bogotá', 'David Castillo', '+573012345688', 'Cerrajero profesional disponible 24/7. Apertura de puertas, cambio de cerraduras, llaves duplicadas.', '+573012345688', 'both', ARRAY['3'], true, 4.9, 62),
  ('vendedor_52@servicenter.com', 'Bogotá', 'Alejandro Navarro', '+573012345689', 'Especialista en cerraduras inteligentes y biométricas. Instalación, configuración, mantenimiento.', '+573012345689', 'whatsapp', ARRAY['3'], true, 4.8, 44),
  ('vendedor_53@servicenter.com', 'Bogotá', 'Nicolás Benítez', '+573012345690', 'Cerrajero urgente. Apertura de vehículos, casas, oficinas. Servicio rápido y discreto.', '+573012345690', 'both', ARRAY['3'], true, 4.7, 51),
  ('vendedor_54@servicenter.com', 'Bogotá', 'Santiago Muñoz', '+573012345691', 'Experto en sistemas de seguridad electrónica. Cámaras, alarmas, control de acceso.', '+573012345691', 'chat', ARRAY['3'], true, 4.6, 37),
  ('vendedor_55@servicenter.com', 'Bogotá', 'Sebastián Quintero', '+573012345692', 'Cambio de cerraduras y reforzamiento de puertas. Seguridad para hogares y empresas.', '+573012345692', 'both', ARRAY['3'], false, 4.5, 29),
  
  -- Cerrajeros en Medellín
  ('vendedor_56@servicenter.com', 'Medellín', 'Felipe Guerrero', '+573014567900', 'Cerrajero en Medellín disponible 24 horas. Apertura de puertas, llaves duplicadas.', '+573014567900', 'both', ARRAY['3'], true, 4.9, 55),
  ('vendedor_57@servicenter.com', 'Medellín', 'Mateo Estrada', '+573014567901', 'Especialista en cerraduras de alta seguridad. Blindadas, magnéticas, digitales.', '+573014567901', 'whatsapp', ARRAY['3'], true, 4.8, 42),
  ('vendedor_58@servicenter.com', 'Medellín', 'Emmanuel Ocampo', '+573014567902', 'Cerrajero urgente. Apertura de vehículos, casas, cajas fuertes. Servicio rápido.', '+573014567902', 'both', ARRAY['3'], true, 4.7, 48),
  ('vendedor_59@servicenter.com', 'Medellín', 'Gabriel Rincón', '+573014567903', 'Experto en sistemas de control de acceso. Tarjetas, huella, reconocimiento facial.', '+573014567903', 'chat', ARRAY['3'], true, 4.6, 33),
  ('vendedor_60@servicenter.com', 'Medellín', 'Samuel Romero', '+573014567904', 'Instalación de cerraduras inteligentes. Configuración de aplicaciones, acceso remoto.', '+573014567904', 'both', ARRAY['3'], false, 4.4, 27),
  
  -- Cerrajeros en Cali
  ('vendedor_61@servicenter.com', 'Cali', 'Javier Paredes', '+573019876553', 'Cerrajero en Cali. Apertura de puertas, cambio de cerraduras, llaves duplicadas.', '+573019876553', 'both', ARRAY['3'], true, 4.8, 40),
  ('vendedor_62@servicenter.com', 'Cali', 'Andrés Vargas', '+573019876554', 'Especialista en cerraduras para vehículos. Llaves con chip, programación, remotos.', '+573019876554', 'whatsapp', ARRAY['3'], true, 4.7, 35),
  ('vendedor_63@servicenter.com', 'Cali', 'Luis Córdoba', '+573019876555', 'Cerrajero urgente disponible. Apertura de puertas, reparaciones de cerraduras.', '+573019876555', 'both', ARRAY['3'], true, 4.9, 47),
  ('vendedor_64@servicenter.com', 'Cali', 'Carlos Salazar', '+573019876556', 'Experto en seguridad para empresas. Cerraduras de alta seguridad, sistemas de control.', '+573019876556', 'chat', ARRAY['3'], true, 4.6, 31),
  ('vendedor_65@servicenter.com', 'Cali', 'Roberto Jiménez', '+573019876557', 'Reforzamiento de puertas y ventanas. Protección antirrobo, blindaje de puntos débiles.', '+573019876557', 'both', ARRAY['3'], false, 4.5, 25),
  
  -- Cerrajeros en Barranquilla
  ('vendedor_66@servicenter.com', 'Barranquilla', 'Manuel Giraldo', '+573015432119', 'Cerrajero en Barranquilla. Servicio 24/7. Apertura de puertas, cambio de cerraduras.', '+573015432119', 'both', ARRAY['3'], true, 4.9, 52),
  ('vendedor_67@servicenter.com', 'Barranquilla', 'Fernando Arango', '+573015432120', 'Especialista en cerraduras marítimas y anticorrosión. Para casas en zona costera.', '+573015432120', 'whatsapp', ARRAY['3'], true, 4.8, 38),
  ('vendedor_68@servicenter.com', 'Barranquilla', 'Ricardo Londoño', '+573015432121', 'Cerrajero urgente. Apertura de vehículos, casas, oficinas. Atención inmediata.', '+573015432121', 'both', ARRAY['3'], true, 4.7, 44),
  ('vendedor_69@servicenter.com', 'Barranquilla', 'Pedro Bedoya', '+573015432122', 'Experto en sistemas de seguridad electrónica. Cámaras, alarmas, sensores.', '+573015432122', 'chat', ARRAY['3'], true, 4.6, 32),
  ('vendedor_70@servicenter.com', 'Barranquilla', 'José Salazar', '+573015432123', 'Instalación de cerraduras inteligentes. Programación, mantenimiento, soporte técnico.', '+573015432123', 'both', ARRAY['3'], false, 4.4, 26),
  
  -- Cerrajeros en Cartagena
  ('vendedor_71@servicenter.com', 'Cartagena', 'Oscar Paredes', '+573015678911', 'Cerrajero en Cartagena. Especialista en seguridad costera. Cerraduras anticorrosión.', '+573015678911', 'both', ARRAY['3'], true, 4.8, 39),
  ('vendedor_72@servicenter.com', 'Cartagena', 'Andrés Vargas', '+573015678912', 'Especialista en cerraduras para hoteles y resorts. Sistemas de tarjeta, masterkey.', '+573015678912', 'whatsapp', ARRAY['3'], true, 4.7, 34),
  ('vendedor_73@servicenter.com', 'Cartagena', 'Luis Córdoba', '+573015678913', 'Cerrajero urgente disponible. Apertura de puertas, cambio de cerraduras.', '+573015678913', 'both', ARRAY['3'], true, 4.9, 46),
  ('vendedor_74@servicenter.com', 'Cartagena', 'Carlos Salazar', '+573015678914', 'Experto en seguridad para fincas y casas de playa. Sistemas completos.', '+573015678914', 'chat', ARRAY['3'], true, 4.6, 30),
  ('vendedor_75@servicenter.com', 'Cartagena', 'Roberto Jiménez', '+573015678915', 'Instalación de cerraduras biométricas. Huella, reconocimiento facial, acceso remoto.', '+573015678915', 'both', ARRAY['3'], false, 4.5, 24)
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

-- Carpinteros en ciudades principales
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
  -- Carpinteros en Bogotá
  ('vendedor_76@servicenter.com', 'Bogotá', 'Humberto Sánchez', '+573012345693', 'Carpintero con 25 años de experiencia. Muebles a medida, puertas, ventanas, trabajos en madera.', '+573012345693', 'both', ARRAY['4'], true, 4.8, 54),
  ('vendedor_77@servicenter.com', 'Bogotá', 'Gilberto Torres', '+573012345694', 'Especialista en muebles de diseño moderno. Cocinas integrales, closets, librerías.', '+573012345694', 'whatsapp', ARRAY['4'], true, 4.9, 48),
  ('vendedor_78@servicenter.com', 'Bogotá', 'Alfonso Ramírez', '+573012345695', 'Carpintero urgente disponible. Reparaciones rápidas, puertas, ventanas, estructuras.', '+573012345695', 'both', ARRAY['4'], true, 4.7, 41),
  ('vendedor_79@servicenter.com', 'Bogotá', 'Rafael Flores', '+573012345696', 'Experto en trabajos finos y restauración. Muebles antiguos, detalles decorativos.', '+573012345696', 'chat', ARRAY['4'], true, 4.6, 35),
  ('vendedor_80@servicenter.com', 'Bogotá', 'Eduardo Cruz', '+573012345697', 'Instalaciones de pisos de madera y decks. Acabados perfectos, materiales de calidad.', '+573012345697', 'both', ARRAY['4'], false, 4.5, 28),
  
  -- Carpinteros en Medellín
  ('vendedor_81@servicenter.com', 'Medellín', 'Octavio Gómez', '+573014567905', 'Carpintero en Medellín. Muebles artesanales, trabajos finos, restauración.', '+573014567905', 'both', ARRAY['4'], true, 4.9, 52),
  ('vendedor_82@servicenter.com', 'Medellín', 'Guillermo Reyes', '+573014567906', 'Especialista en closets y organizadores. Diseño funcional, maximización de espacio.', '+573014567906', 'whatsapp', ARRAY['4'], true, 4.8, 43),
  ('vendedor_83@servicenter.com', 'Medellín', 'Víctor Jiménez', '+573014567907', 'Carpintero urgente. Reparaciones de puertas, ventanas, estructuras de madera.', '+573014567907', 'both', ARRAY['4'], true, 4.7, 38),
  ('vendedor_84@servicenter.com', 'Medellín', 'Leonardo Silva', '+573014567908', 'Experto en muebles de estilo rústico y colonial. Trabajos a medida, acabados naturales.', '+573014567908', 'chat', ARRAY['4'], true, 4.6, 32),
  ('vendedor_85@servicenter.com', 'Medellín', 'Antonio Mendoza', '+573014567909', 'Instalación de marcos y molduras. Detalles decorativos, acabados elegantes.', '+573014567909', 'both', ARRAY['4'], false, 4.4, 26),
  
  -- Carpinteros en Cali
  ('vendedor_86@servicenter.com', 'Cali', 'Francisco Hernández', '+573019876558', 'Carpintero en Cali. Muebles modernos, closets, cocinas integrales.', '+573019876558', 'both', ARRAY['4'], true, 4.8, 45),
  ('vendedor_87@servicenter.com', 'Cali', 'Javier García', '+573019876559', 'Especialista en puertas y ventanas de madera. Maderas tropicales, acabados premium.', '+573019876559', 'whatsapp', ARRAY['4'], true, 4.7, 39),
  ('vendedor_88@servicenter.com', 'Cali', 'Manuel López', '+573019876560', 'Carpintero urgente disponible. Reparaciones rápidas, estructuras, detalles.', '+573019876560', 'both', ARRAY['4'], true, 4.9, 47),
  ('vendedor_89@servicenter.com', 'Cali', 'Ramón Martínez', '+573019876561', 'Experto en trabajos finos y detalles decorativos. Muebles artesanales.', '+573019876561', 'chat', ARRAY['4'], true, 4.6, 33),
  ('vendedor_90@servicenter.com', 'Cali', 'Luis González', '+573019876562', 'Instalación de pisos de madera y laminados. Sistemas flotantes, pegados.', '+573019876562', 'both', ARRAY['4'], false, 4.5, 27),
  
  -- Carpinteros en Barranquilla
  ('vendedor_91@servicenter.com', 'Barranquilla', 'Ernesto Rodríguez', '+573015432124', 'Carpintero en Barranquilla. Muebles resistentes al clima húmedo. Tratamientos especiales.', '+573015432124', 'both', ARRAY['4'], true, 4.8, 41),
  ('vendedor_92@servicenter.com', 'Barranquilla', 'César Flores', '+573015432125', 'Especialista en closets y armarios. Diseño optimizado para espacios pequeños.', '+573015432125', 'whatsapp', ARRAY['4'], true, 4.7, 36),
  ('vendedor_93@servicenter.com', 'Barranquilla', 'Jorge Cruz', '+573015432126', 'Carpintero urgente. Reparaciones de estructuras, puertas, ventanas de madera.', '+573015432126', 'both', ARRAY['4'], true, 4.9, 43),
  ('vendedor_94@servicenter.com', 'Barranquilla', 'Roberto Silva', '+573015432127', 'Experto en muebles estilo costeño. Maderas locales, diseños tradicionales.', '+573015432127', 'chat', ARRAY['4'], true, 4.6, 31),
  ('vendedor_95@servicenter.com', 'Barranquilla', 'Antonio Ramírez', '+573015432128', 'Instalación de decks y terrazas de madera. Tratamiento anticorrosión.', '+573015432128', 'both', ARRAY['4'], false, 4.4, 25),
  
  -- Carpinteros en Cartagena
  ('vendedor_96@servicenter.com', 'Cartagena', 'Gregorio Paredes', '+573015678916', 'Carpintero en Cartagena. Especialista en maderas resistentes a la salinidad.', '+573015678916', 'both', ARRAY['4'], true, 4.9, 44),
  ('vendedor_97@servicenter.com', 'Cartagena', 'Horacio Vargas', '+573015678917', 'Especialista en muebles para hoteles y resorts. Estilo colonial moderno.', '+573015678917', 'whatsapp', ARRAY['4'], true, 4.8, 38),
  ('vendedor_98@servicenter.com', 'Cartagena', 'Benjamín Córdoba', '+573015678918', 'Carpintero urgente. Reparaciones rápidas en clima tropical. Tratamientos especiales.', '+573015678918', 'both', ARRAY['4'], true, 4.7, 40),
  ('vendedor_99@servicenter.com', 'Cartagena', 'Salvador Salazar', '+573015678919', 'Experto en restauración de muebles antiguos. Técnicas tradicionales de Cartagena.', '+573015678919', 'chat', ARRAY['4'], true, 4.6, 32),
  ('vendedor_100@servicenter.com', 'Cartagena', 'Tomás Jiménez', '+573015678920', 'Instalación de persianas y marcos de madera. Protección solar, estética.', '+573015678920', 'both', ARRAY['4'], false, 4.5, 26)
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

-- Pintores en ciudades principales
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
  -- Pintores en Bogotá
  ('vendedor_101@servicenter.com', 'Bogotá', 'William Morales', '+573012345698', 'Pintor profesional con 20 años de experiencia. Interiores, exteriores, acabados perfectos.', '+573012345698', 'both', ARRAY['5'], true, 4.9, 58),
  ('vendedor_102@servicenter.com', 'Bogotá', 'Héctor Gutiérrez', '+573012345699', 'Especialista en pintura decorativa y de efectos. Falso acabado, estucos, texturas.', '+573012345699', 'whatsapp', ARRAY['5'], true, 4.8, 46),
  ('vendedor_103@servicenter.com', 'Bogotá', 'Julio Vargas', '+573012345700', 'Pintor urgente disponible. Reparaciones rápidas, retoques, acabados rápidos.', '+573012345700', 'both', ARRAY['5'], true, 4.7, 42),
  ('vendedor_104@servicenter.com', 'Bogotá', 'César Ríos', '+573012345701', 'Experto en impermeabilización de fachadas y techos. Pinturas especiales, selladores.', '+573012345701', 'chat', ARRAY['5'], true, 4.6, 36),
  ('vendedor_105@servicenter.com', 'Bogotá', 'Alberto Castro', '+573012345702', 'Pintura industrial y comercial. Ladrillos, metales, estructuras. Certificaciones.', '+573012345702', 'both', ARRAY['5'], false, 4.5, 29),
  
  -- Pintores en Medellín
  ('vendedor_106@servicenter.com', 'Medellín', 'Ricardo Álvarez', '+573014567910', 'Pintor en Medellín. Interiores modernos, exteriores, acabados de alta calidad.', '+573014567910', 'both', ARRAY['5'], true, 4.9, 51),
  ('vendedor_107@servicenter.com', 'Medellín', 'Fernando Valencia', '+573014567911', 'Especialista en pintura de efecto y decorativa. Veneciano, estuco, texturas.', '+573014567911', 'whatsapp', ARRAY['5'], true, 4.8, 44),
  ('vendedor_108@servicenter.com', 'Medellín', 'Carlos Arias', '+573014567912', 'Pintor urgente. Reparaciones, retoques, cambios de color rápidos.', '+573014567912', 'both', ARRAY['5'], true, 4.7, 39),
  ('vendedor_109@servicenter.com', 'Medellín', 'Pedro Ospina', '+573014567913', 'Experto en impermeabilización. Fachadas, techos, balcones. Garantía 10 años.', '+573014567913', 'chat', ARRAY['5'], true, 4.6, 34),
  ('vendedor_110@servicenter.com', 'Medellín', 'Jorge Velásquez', '+573014567914', 'Pintura para edificios y condominios. Fachadas, pasillos, áreas comunes.', '+573014567914', 'both', ARRAY['5'], false, 4.4, 27),
  
  -- Pintores en Cali
  ('vendedor_111@servicenter.com', 'Cali', 'Luis Fernando Muñoz', '+573019876563', 'Pintor en Cali. Colores vivos, acabados perfectos, servicio garantizado.', '+573019876563', 'both', ARRAY['5'], true, 4.8, 47),
  ('vendedor_112@servicenter.com', 'Cali', 'Andrés Palacios', '+573019876564', 'Especialista en pintura artística y murales. Diseños personalizados, graffiti artístico.', '+573019876564', 'whatsapp', ARRAY['5'], true, 4.7, 38),
  ('vendedor_113@servicenter.com', 'Cali', 'Rafael Ángel', '+573019876565', 'Pintor urgente disponible. Reparaciones, cambios de color, acabados rápidos.', '+573019876565', 'both', ARRAY['5'], true, 4.9, 45),
  ('vendedor_114@servicenter.com', 'Cali', 'Miguel Ibarra', '+573019876566', 'Experto en pintura para exteriores. Resistente al sol, lluvia, clima cálido.', '+573019876566', 'chat', ARRAY['5'], true, 4.6, 33),
  ('vendedor_115@servicenter.com', 'Cali', 'Gabriel Caicedo', '+573019876567', 'Pintura comercial y de locales. Imagen corporativa, logos, branding en paredes.', '+573019876567', 'both', ARRAY['5'], false, 4.5, 28),
  
  -- Pintores en Barranquilla
  ('vendedor_116@servicenter.com', 'Barranquilla', 'Jaime de la Hoz', '+573015432129', 'Pintor en Barranquilla. Pinturas resistentes al clima costero. Garantía incluida.', '+573015432129', 'both', ARRAY['5'], true, 4.9, 49),
  ('vendedor_117@servicenter.com', 'Barranquilla', 'Luis José Fontalvo', '+573015432130', 'Especialista en pintura de efectos y decorativa. Estilos caribeños, colores tropicales.', '+573015432130', 'whatsapp', ARRAY['5'], true, 4.8, 42),
  ('vendedor_118@servicenter.com', 'Barranquilla', 'Ricardo Cotes', '+573015432131', 'Pintor urgente. Reparaciones rápidas, retoques, acabados rápidos.', '+573015432131', 'both', ARRAY['5'], true, 4.7, 40),
  ('vendedor_119@servicenter.com', 'Barranquilla', 'Fernando Villa', '+573015432132', 'Experto en impermeabilización en zona costera. Resistente a salinidad y humedad.', '+573015432132', 'chat', ARRAY['5'], true, 4.6, 35),
  ('vendedor_120@servicenter.com', 'Barranquilla', 'Carlos Puello', '+573015432133', 'Pintura para hoteles y resorts. Estilo caribeño, acabados premium.', '+573015432133', 'both', ARRAY['5'], false, 4.4, 26),
  
  -- Pintores en Cartagena
  ('vendedor_121@servicenter.com', 'Cartagena', 'José Julián Herazo', '+573015678921', 'Pintor en Cartagena. Especialista en colores coloniales y técnicas tradicionales.', '+573015678921', 'both', ARRAY['5'], true, 4.9, 46),
  ('vendedor_122@servicenter.com', 'Cartagena', 'Rafael Baloco', '+573015678922', 'Especialista en restauración de fachadas históricas. Técnicas de conservación.', '+573015678922', 'whatsapp', ARRAY['5'], true, 4.8, 39),
  ('vendedor_123@servicenter.com', 'Cartagena', 'Alberto Curieses', '+573015678923', 'Pintor urgente disponible. Reparaciones en clima tropical. Tratamientos especiales.', '+573015678923', 'both', ARRAY['5'], true, 4.7, 41),
  ('vendedor_124@servicenter.com', 'Cartagena', 'Jorge Mercado', '+573015678924', 'Experto en pintura marítima. Protección contra salinidad, corrosión, humedad.', '+573015678924', 'chat', ARRAY['5'], true, 4.6, 34),
  ('vendedor_125@servicenter.com', 'Cartagena', 'Pedro Noguera', '+573015678925', 'Pintura decorativa estilo caribeño. Colores vivos, diseños tropicales.', '+573015678925', 'both', ARRAY['5'], false, 4.5, 27)
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

-- Albañiles en ciudades principales
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
  -- Albañiles en Bogotá
  ('vendedor_126@servicenter.com', 'Bogotá', 'Orlando González', '+573012345703', 'Albañil con 22 años de experiencia. Construcción, reparaciones estructurales, acabados.', '+573012345703', 'both', ARRAY['6'], true, 4.8, 56),
  ('vendedor_127@servicenter.com', 'Bogotá', 'Elías Márquez', '+573012345704', 'Especialista en construcción de casas. Desde cimientos hasta entrega llave en mano.', '+573012345704', 'whatsapp', ARRAY['6'], true, 4.9, 49),
  ('vendedor_128@servicenter.com', 'Bogotá', 'Raúl Rodríguez', '+573012345705', 'Albañil urgente disponible. Reparaciones estructurales, paredes, columnas, techos.', '+573012345705', 'both', ARRAY['6'], true, 4.7, 43),
  ('vendedor_129@servicenter.com', 'Bogotá', 'Fernando Herrera', '+573012345706', 'Experto en acabados finos. Estuco, pintura texturizada, detalles decorativos.', '+573012345706', 'chat', ARRAY['6'], true, 4.6, 37),
  ('vendedor_130@servicenter.com', 'Bogotá', 'Jesús Silva', '+573012345707', 'Remodelaciones completas. Ampliaciones, redistribución, renovación de espacios.', '+573012345707', 'both', ARRAY['6'], false, 4.5, 30),
  
  -- Albañiles en Medellín
  ('vendedor_131@servicenter.com', 'Medellín', 'José Luis Uribe', '+573014567915', 'Albañil en Medellín. Construcción moderna, acabados de calidad, cumplido.', '+573014567915', 'both', ARRAY['6'], true, 4.9, 53),
  ('vendedor_132@servicenter.com', 'Medellín', 'Carlos Mario Zuluaga', '+573014567916', 'Especialista en estructuras de concreto. Cimentaciones, losas, columnas.', '+573014567916', 'whatsapp', ARRAY['6'], true, 4.8, 45),
  ('vendedor_133@servicenter.com', 'Medellín', 'Jorge Ignacio Velásquez', '+573014567917', 'Albañil urgente. Reparaciones estructurales, reforzamiento, emergencias.', '+573014567917', 'both', ARRAY['6'], true, 4.7, 40),
  ('vendedor_134@servicenter.com', 'Medellín', 'Luis Eduardo Arango', '+573014567918', 'Experto en impermeabilización de techos y fachadas. Membranas, selladores.', '+573014567918', 'chat', ARRAY['6'], true, 4.6, 35),
  ('vendedor_135@servicenter.com', 'Medellín', 'Ricardo Gaviria', '+573014567919', 'Remodelaciones de apartamentos y casas. Diseño funcional, acabados modernos.', '+573014567919', 'both', ARRAY['6'], false, 4.4, 28),
  
  -- Albañiles en Cali
  ('vendedor_136@servicenter.com', 'Cali', 'Alfonso Caicedo', '+573019876568', 'Albañil en Cali. Construcción resistente a sismos. Estructuras reforzadas.', '+573019876568', 'both', ARRAY['6'], true, 4.8, 48),
  ('vendedor_137@servicenter.com', 'Cali', 'Hernán Valencia', '+573019876569', 'Especialista en acabados y detalles. Pisos, muros, molduras decorativas.', '+573019876569', 'whatsapp', ARRAY['6'], true, 4.7, 41),
  ('vendedor_138@servicenter.com', 'Cali', 'Guillermo Londoño', '+573019876570', 'Albañil urgente. Reparaciones estructurales, daños por humedad, filtraciones.', '+573019876570', 'both', ARRAY['6'], true, 4.9, 44),
  ('vendedor_139@servicenter.com', 'Cali', 'Javier Martínez', '+573019876571', 'Experto en construcción en seco. Drywall, cielos rasos, divisiones.', '+573019876571', 'chat', ARRAY['6'], true, 4.6, 36),
  ('vendedor_140@servicenter.com', 'Cali', 'Miguel Ángel Rodríguez', '+573019876572', 'Remodelaciones comerciales. Locales, oficinas, bodegas. Cumplido.', '+573019876572', 'both', ARRAY['6'], false, 4.5, 29),
  
  -- Albañiles en Barranquilla
  ('vendedor_141@servicenter.com', 'Barranquilla', 'José del Carmen Daza', '+573015432134', 'Albañil en Barranquilla. Construcción resistente a vientos y salinidad.', '+573015432134', 'both', ARRAY['6'], true, 4.9, 50),
  ('vendedor_142@servicenter.com', 'Barranquilla', 'Roberto Barros', '+573015432135', 'Especialista en cimentaciones en zonas costeras. Pilotes, losas, vigas.', '+573015432135', 'whatsapp', ARRAY['6'], true, 4.8, 43),
  ('vendedor_143@servicenter.com', 'Barranquilla', 'Rafael Núñez', '+573015432136', 'Albañil urgente. Reparaciones estructurales, reforzamiento, emergencias.', '+573015432136', 'both', ARRAY['6'], true, 4.7, 39),
  ('vendedor_144@servicenter.com', 'Barranquilla', 'Carlos Pizarro', '+573015432137', 'Experto en impermeabilización tropical. Techos, fachadas, balcones.', '+573015432137', 'chat', ARRAY['6'], true, 4.6, 34),
  ('vendedor_145@servicenter.com', 'Barranquilla', 'Luis de la Rosa', '+573015432138', 'Remodelaciones de casas costeras. Reforzamiento, renovación, acabados.', '+573015432138', 'both', ARRAY['6'], false, 4.4, 27),
  
  -- Albañiles en Cartagena
  ('vendedor_146@servicenter.com', 'Cartagena', 'Fernando de la Espriella', '+573015678926', 'Albañil en Cartagena. Especialista en construcción colonial y moderna.', '+573015678926', 'both', ARRAY['6'], true, 4.9, 47),
  ('vendedor_147@servicenter.com', 'Cartagena', 'José María Cotes', '+573015678927', 'Especialista en cimentaciones en suelo blando. Reforzamiento especial.', '+573015678927', 'whatsapp', ARRAY['6'], true, 4.8, 40),
  ('vendedor_148@servicenter.com', 'Cartagena', 'Rafael Herazo', '+573015678928', 'Albañil urgente. Reparaciones en clima tropical. Tratamientos especiales.', '+573015678928', 'both', ARRAY['6'], true, 4.7, 42),
  ('vendedor_149@servicenter.com', 'Cartagena', 'Carlos Paternina', '+573015678929', 'Experto en restauración de inmuebles históricos. Técnicas tradicionales.', '+573015678929', 'chat', ARRAY['6'], true, 4.6, 35),
  ('vendedor_150@servicenter.com', 'Cartagena', 'Luis Curieses', '+573015678930', 'Remodelaciones de casas patrimoniales. Conservación, modernización, acabados.', '+573015678930', 'both', ARRAY['6'], false, 4.5, 28)
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

-- Jardineros en ciudades principales
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
  -- Jardineros en Bogotá
  ('vendedor_151@servicenter.com', 'Bogotá', 'Jorge Humberto Reyes', '+573012345708', 'Jardinero profesional. Mantenimiento, poda, diseño de jardines, paisajismo.', '+573012345708', 'both', ARRAY['7'], true, 4.8, 44),
  ('vendedor_152@servicenter.com', 'Bogotá', 'Carlos Alberto Torres', '+573012345709', 'Especialista en jardines verticales y techos verdes. Diseño urbano sostenible.', '+573012345709', 'whatsapp', ARRAY['7'], true, 4.7, 37),
  ('vendedor_153@servicenter.com', 'Bogotá', 'Luis Fernando Jiménez', '+573012345710', 'Jardinero urgente. Poda de emergencia, limpieza, mantenimiento rápido.', '+573012345710', 'both', ARRAY['7'], true, 4.6, 32),
  ('vendedor_154@servicenter.com', 'Bogotá', 'Pedro Antonio García', '+573012345711', 'Experto en sistemas de riego automatizado. Goteo, aspersión, programación.', '+573012345711', 'chat', ARRAY['7'], true, 4.5, 28),
  ('vendedor_155@servicenter.com', 'Bogotá', 'Miguel Ángel López', '+573012345712', 'Mantenimiento de zonas comunes. Condominios, parques, áreas verdes.', '+573012345712', 'both', ARRAY['7'], false, 4.4, 24),
  
  -- Jardineros en Medellín
  ('vendedor_156@servicenter.com', 'Medellín', 'Juan David Muñoz', '+573014567920', 'Jardinero en Medellín. Paisajismo moderno, jardines tropicales, mantenimiento.', '+573014567920', 'both', ARRAY['7'], true, 4.9, 41),
  ('vendedor_157@servicenter.com', 'Medellín', 'Andrés Felipe Vélez', '+573014567921', 'Especialista en orquídeas y plantas tropicales. Cultivo, cuidado, reproducción.', '+573014567921', 'whatsapp', ARRAY['7'], true, 4.8, 36),
  ('vendedor_158@servicenter.com', 'Medellín', 'Santiago Botero', '+573014567922', 'Jardinero urgente. Poda, limpieza, mantenimiento de emergencia.', '+573014567922', 'both', ARRAY['7'], true, 4.7, 33),
  ('vendedor_159@servicenter.com', 'Medellín', 'Carlos Esteban Gómez', '+573014567923', 'Experto en jardines colgantes y verticales. Diseño moderno y sostenible.', '+573014567923', 'chat', ARRAY['7'], true, 4.6, 29),
  ('vendedor_160@servicenter.com', 'Medellín', 'Jorge Mario Restrepo', '+573014567924', 'Mantenimiento de fincas y propiedades grandes. Maquinaria especializada.', '+573014567924', 'both', ARRAY['7'], false, 4.4, 25),
  
  -- Jardineros en Cali
  ('vendedor_161@servicenter.com', 'Cali', 'Hernán Darío Valencia', '+573019876573', 'Jardinero en Cali. Jardines estilo caleño, mantenimiento profesional.', '+573019876573', 'both', ARRAY['7'], true, 4.8, 40),
  ('vendedor_162@servicenter.com', 'Cali', 'Fernando Alberto Rincón', '+573019876574', 'Especialista en palmeras y plantas tropicales. Poda, trasplante, cuidado.', '+573019876574', 'whatsapp', ARRAY['7'], true, 4.7, 35),
  ('vendedor_163@servicenter.com', 'Cali', 'Luis Carlos Silva', '+573019876575', 'Jardinero urgente. Poda de emergencia, limpieza, mantenimiento rápido.', '+573019876575', 'both', ARRAY['7'], true, 4.9, 43),
  ('vendedor_164@servicenter.com', 'Cali', 'Pedro Nel Ospina', '+573019876576', 'Experto en sistemas de riego eficientes. Ahorro de agua, automatización.', '+573019876576', 'chat', ARRAY['7'], true, 4.6', 31),
  ('vendedor_165@servicenter.com', 'Cali', 'Miguel Ángel Caicedo', '+573019876577', 'Diseño de jardines y paisajismo. Planos 3D, asesoría, ejecución.', '+573019876577', 'both', ARRAY['7'], false, 4.5, 27),
  
  -- Jardineros en Barranquilla
  ('vendedor_166@servicenter.com', 'Barranquilla', 'Rafael Julio De la Hoz', '+573015432139', 'Jardinero en Barranquilla. Plantas resistentes al clima costero.', '+573015432139', 'both', ARRAY['7'], true, 4.9, 46),
  ('vendedor_167@servicenter.com', 'Barranquilla', 'José María Barros', '+573015432140', 'Especialista en jardines de playa y palmeras. Resistentes a salinidad.', '+573015432140', 'whatsapp', ARRAY['7'], true, 4.8, 39),
  ('vendedor_168@servicenter.com', 'Barranquilla', 'Carlos Eduardo Cotes', '+573015432141', 'Jardinero urgente. Poda, limpieza, mantenimiento en clima tropical.', '+573015432141', 'both', ARRAY['7'], true, 4.7, 38),
  ('vendedor_169@servicenter.com', 'Barranquilla', 'Luis José Villa', '+573015432142', 'Experto en riego automático para zonas costeras. Sistemas eficientes.', '+573015432142', 'chat', ARRAY['7'], true, 4.6, 33),
  ('vendedor_170@servicenter.com', 'Barranquilla', 'Miguel Fernando Pizarro', '+573015432143', 'Mantenimiento de áreas verdes en condominios. Servicio completo.', '+573015432143', 'both', ARRAY['7'], false, 4.4, 26),
  
  -- Jardineros en Cartagena
  ('vendedor_171@servicenter.com', 'Cartagena', 'Jorge Enrique Herazo', '+573015678931', 'Jardinero en Cartagena. Especialista en jardines coloniales y tropicales.', '+573015678931', 'both', ARRAY['7'], true, 4.9, 44),
  ('vendedor_172@servicenter.com', 'Cartagena', 'Rafael Alberto Núñez', '+573015678932', 'Especialista en plantas de sombra y flores tropicales. Cuidado experto.', '+573015678932', 'whatsapp', ARRAY['7'], true, 4.8, 38),
  ('vendedor_173@servicenter.com', 'Cartagena', 'Carlos María Curieses', '+573015678933', 'Jardinero urgente. Poda y mantenimiento en clima tropical húmedo.', '+573015678933', 'both', ARRAY['7'], true, 4.7, 40),
  ('vendedor_174@servicenter.com', 'Cartagena', 'Luis José Paternina', '+573015678934', 'Experto en jardines para hoteles y resorts. Diseño de impacto.', '+573015678934', 'chat', ARRAY['7'], true, 4.6', 34),
  ('vendedor_175@servicenter.com', 'Cartagena', 'Miguel Ángel Mercado', '+573015678935', 'Mantenimiento de fincas y casas de playa. Servicio completo.', '+573015678935', 'both', ARRAY['7'], false, 4.5, 27)
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

-- Limpieza en ciudades principales
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
  -- Limpieza en Bogotá
  ('vendedor_176@servicenter.com', 'Bogotá', 'Ana María Sánchez', '+573012345713', 'Servicio de limpieza profundo y regular. Personal confiable, resultados impecables.', '+573012345713', 'both', ARRAY['8'], true, 4.9, 62),
  ('vendedor_177@servicenter.com', 'Bogotá', 'Carmen Julia González', '+573012345714', 'Especialista en limpieza post-construcción y remodelación. Servicios intensivos.', '+573012345714', 'whatsapp', ARRAY['8'], true, 4.8, 48),
  ('vendedor_178@servicenter.com', 'Bogotá', 'Rosa Elena Martínez', '+573012345715', 'Limpieza urgente disponible. Aseo profundo, organización, desinfección.', '+573012345715', 'both', ARRAY['8'], true, 4.7, 45),
  ('vendedor_179@servicenter.com', 'Bogotá', 'María del Pilar López', '+573012345716', 'Experta en limpieza de fin de obra. Casas nuevas, oficinas, espacios comerciales.', '+573012345716', 'chat', ARRAY['8'], true, 4.6, 38),
  ('vendedor_180@servicenter.com', 'Bogotá', 'Lucía Carolina García', '+573012345717', 'Limpieza para mudanzas. Antes y después, organización, embalaje.', '+573012345717', 'both', ARRAY['8'], false, 4.5, 31),
  
  -- Limpieza en Medellín
  ('vendedor_181@servicenter.com', 'Medellín', 'Gloria Amparo Ramírez', '+573014567925', 'Servicio de limpieza en Medellín. Personal verificado, productos de calidad.', '+573014567925', 'both', ARRAY['8'], true, 4.9, 55),
  ('vendedor_182@servicenter.com', 'Medellín', 'Beatriz Elena Vélez', '+573014567926', 'Especialista en limpieza de apartamentos y condominios. Mantenimiento regular.', '+573014567926', 'whatsapp', ARRAY['8'], true, 4.8, 46),
  ('vendedor_183@servicenter.com', 'Medellín', 'María Victoria Restrepo', '+573014567927', 'Limpieza urgente. Aseo profundo, desinfección, organización rápida.', '+573014567927', 'both', ARRAY['8'], true, 4.7, 42),
  ('vendedor_184@servicenter.com', 'Medellín', 'Clemencia Arias', '+573014567928', 'Experta en limpieza de vidrios y ventanas. Alturas, cristales, espejos.', '+573014567928', 'chat', ARRAY['8'], true, 4.6, 35),
  ('vendedor_185@servicenter.com', 'Medellín', 'Doris Eugenia Gaviria', '+573014567929', 'Limpieza para oficinas y empresas. Servicio nocturno, cumplido.', '+573014567929', 'both', ARRAY['8'], false, 4.4, 28),
  
  -- Limpieza en Cali
  ('vendedor_186@servicenter.com', 'Cali', 'Yolanda María Muñoz', '+573019876578', 'Servicio de limpieza en Cali. Personal confiable, resultados garantizados.', '+573019876578', 'both', ARRAY['8'], true, 4.8, 50),
  ('vendedor_187@servicenter.com', 'Cali', 'Elena Rincón', '+573019876579', 'Especialista en limpieza de casas y apartamentos. Aseo profundo, organización.', '+573019876579', 'whatsapp', ARRAY['8'], true, 4.7, 43),
  ('vendedor_188@servicenter.com', 'Cali', 'Nidia Caicedo', '+573019876580', 'Limpieza urgente disponible. Aseo completo, desinfección, detallado.', '+573019876580', 'both', ARRAY['8'], true, 4.9, 47),
  ('vendedor_189@servicenter.com', 'Cali', 'Rosa Valencia', '+573019876581', 'Experta en limpieza de fin de obra. Post-remodelación, post-construcción.', '+573019876581', 'chat', ARRAY['8'], true, 4.6, 36),
  ('vendedor_190@servicenter.com', 'Cali', 'Blanca Londoño', '+573019876582', 'Limpieza para mudanzas. Organización, embalaje, transporte de muebles.', '+573019876582', 'both', ARRAY['8'], false, 4.5, 30),
  
  -- Limpieza en Barranquilla
  ('vendedor_191@servicenter.com', 'Barranquilla', 'Miriam de la Hoz', '+573015432144', 'Servicio de limpieza en Barranquilla. Personal verificado, clima tropical.', '+573015432144', 'both', ARRAY['8'], true, 4.9, 48),
  ('vendedor_192@servicenter.com', 'Barranquilla', 'Carmen Barros', '+573015432145', 'Especialista en limpieza post-huracán y lluvias. Recuperación de espacios.', '+573015432145', 'whatsapp', ARRAY['8'], true, 4.8, 41),
  ('vendedor_193@servicenter.com', 'Barranquilla', 'María Núñez', '+573015432146', 'Limpieza urgente. Aseo profundo, desinfección, limpieza de moho.', '+573015432146', 'both', ARRAY['8'], true, 4.7, 39),
  ('vendedor_194@servicenter.com', 'Barranquilla', 'Lucía Villa', '+573015432147', 'Experta en limpieza de edificios y apartamentos. Mantenimiento regular.', '+573015432147', 'chat', ARRAY['8'], true, 4.6, 34),
  ('vendedor_195@servicenter.com', 'Barranquilla', 'Patricia Pizarro', '+573015432148', 'Limpieza para empresas y oficinas. Servicio nocturno, cumplido.', '+573015432148', 'both', ARRAY['8'], false, 4.4, 27),
  
  -- Limpieza en Cartagena
  ('vendedor_196@servicenter.com', 'Cartagena', 'Estela Herazo', '+573015678936', 'Servicio de limpieza en Cartagena. Especialistas en clima caribeño.', '+573015678936', 'both', ARRAY['8'], true, 4.9, 45),
  ('vendedor_197@servicenter.com', 'Cartagena', 'Rosa Curieses', '+573015678937', 'Especialista en limpieza para hoteles y resorts. Protocolos de hospitalidad.', '+573015678937', 'whatsapp', ARRAY['8'], true, 4.8, 39),
  ('vendedor_198@servicenter.com', 'Cartagena', 'Carmen Noguera', '+573015678938', 'Limpieza urgente. Control de humedad, moho, salinidad en interiores.', '+573015678938', 'both', ARRAY['8'], true, 4.7, 41),
  ('vendedor_199@servicenter.com', 'Cartagena', 'María Mercado', '+573015678939', 'Experta en limpieza de casas patrimoniales. Cuidado especial, técnicas suaves.', '+573015678939', 'chat', ARRAY['8'], true, 4.6, 35),
  ('vendedor_200@servicenter.com', 'Cartagena', 'Blanca Paternina', '+573015678940', 'Limpieza para fincas y casas de playa. Mantenimiento regular.', '+573015678940', 'both', ARRAY['8'], false, 4.5, 28)
) AS u(email, city, full_name, phone, description, whatsapp, preferred_contact, categories, is_verified, rating, review_count)
JOIN auth.users au ON au.email = u.email
ON CONFLICT (id) DO UPDATE SET
  role = EXCLUDED.role,
  city = EXCLUDED.city,
  location = EXCLUDED.location,
  full_name = EXCLUDED.full_name,
  phone = EXPLETED.phone,
  whatsapp = EXCLUDED.whatsapp,
  preferred_contact = EXCLUDED.preferred_contact,
  categories = EXCLUDED.categories,
  is_verified = EXCLUDED.is_verified,
  rating = EXCLUDED.rating,
  review_count = EXCLUDED.review_count;

-- Resto de categorías (Aire Acondicionado, Refrigeración, Techos, Vidrios) - Muestra representativa
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
  -- Aire Acondicionado
  ('vendedor_201@servicenter.com', 'Bogotá', 'Rubén Darío Moreno', '+573012345718', 'Técnico especializado en instalación y mantenimiento de aires acondicionados. Certificado.', '+573012345718', 'both', ARRAY['9'], true, 4.9, 52),
  ('vendedor_202@servicenter.com', 'Medellín', 'Jairo Humberto Posada', '+573014567930', 'Experto en sistemas de aire acondicionado. Instalación, recarga, reparación.', '+573014567930', 'whatsapp', ARRAY['9'], true, 4.8, 44),
  ('vendedor_203@servicenter.com', 'Cali', 'Carlos Mario Londoño', '+573019876583', 'Técnico de AC split y central. Mantenimiento preventivo, reparación urgente.', '+573019876583', 'both', ARRAY['9'], true, 4.7, 39),
  ('vendedor_204@servicenter.com', 'Barranquilla', 'José Fernando Daza', '+573015432149', 'Especialista en AC para clima caliente. Instalaciones eficientes, consumo optimizado.', '+573015432149', 'both', ARRAY['9'], true, 4.9, 46),
  ('vendedor_205@servicenter.com', 'Cartagena', 'Luis Eduardo Herazo', '+573015678941', 'Técnico en sistemas de refrigeración para hoteles. AC central, VRV, VRF.', '+573015678941', 'whatsapp', ARRAY['9'], true, 4.8, 40),
  
  -- Refrigeración
  ('vendedor_206@servicenter.com', 'Bogotá', 'Orlando Ariel Beltrán', '+573012345719', 'Técnico en refrigeración. Neveras, refrigeradores, congeladores. Reparación experta.', '+573012345719', 'both', ARRAY['10'], true, 4.8, 48),
  ('vendedor_207@servicenter.com', 'Medellín', 'Jesús Antonio Villa', '+573014567931', 'Experto en electrodomésticos. Lavadoras, secadoras, refrigeradores. Garantía.', '+573014567931', 'whatsapp', ARRAY['10'], true, 4.7, 42),
  ('vendedor_208@servicenter.com', 'Cali', 'Fernando Ángel Muñoz', '+573019876584', 'Técnico en refrigeración comercial. Neveras industriales, cámaras frigoríficas.', '+573019876584', 'both', ARRAY['10'], true, 4.9, 45),
  ('vendedor_209@servicenter.com', 'Barranquilla', 'Roberto Carlos Barros', '+573015432150', 'Especialista en refrigeración para clima tropical. Problemas comunes locales.', '+573015432150', 'both', ARRAY['10'], true, 4.8, 38),
  ('vendedor_210@servicenter.com', 'Cartagena', 'José María Núñez', '+573015678942', 'Técnico en refrigeración marítima. Protección contra salinidad y corrosión.', '+573015678942', 'whatsapp', ARRAY['10'], true, 4.7, 35),
  
  -- Techos
  ('vendedor_211@servicenter.com', 'Bogotá', 'Germán Augusto Bernal', '+573012345720', 'Especialista en techos e impermeabilización. Tejas, láminas, membranas.', '+573012345720', 'both', ARRAY['11'], true, 4.9, 54),
  ('vendedor_212@servicenter.com', 'Medellín', 'Luis Carlos Duque', '+573014567932', 'Experto en techos para lluvia intensa. Diseño, instalación, garantía.', '+573014567932', 'whatsapp', ARRAY['11'], true, 4.8, 46),
  ('vendedor_213@servicenter.com', 'Cali', 'Jorge Eliecer Gómez', '+573019876585', 'Tecnología de techos modernos. Tejas térmicas, aislamiento, ventilación.', '+573019876585', 'both', ARRAY['11'], true, 4.7, 41),
  ('vendedor_214@servicenter.com', 'Barranquilla', 'Carlos Mario Vargas', '+573015432151', 'Especialista en techos resistentes a vientos y salinidad. Reforzados.', '+573015432151', 'both', ARRAY['11'], true, 4.9, 48),
  ('vendedor_215@servicenter.com', 'Cartagena', 'Fernando Botero', '+573015678943', 'Restauración de techos coloniales. Tejas de barro, técnicas tradicionales.', '+573015678943', 'whatsapp', ARRAY['11'], true, 4.8, 40),
  
  -- Vidrios
  ('vendedor_216@servicenter.com', 'Bogotá', 'Jaime Alberto Cardona', '+573012345721', 'Especialista en vidrios. Ventanas, espejos, mamparas, cortinas de vidrio.', '+573012345721', 'both', ARRAY['12'], true, 4.8, 50),
  ('vendedor_217@servicenter.com', 'Medellín', 'Nicolás Echeverri', '+573014567933', 'Experto en vidrios templados y blindados. Seguridad, estética, durabilidad.', '+573014567933', 'whatsapp', ARRAY['12'], true, 4.7, 43),
  ('vendedor_218@servicenter.com', 'Cali', 'Jorge Iván Toro', '+573019876586', 'Instalaciones de vidrio moderno. Ventanas corredizas, balcones, fachadas.', '+573019876586', 'both', ARRAY['12'], true, 4.9, 46),
  ('vendedor_219@servicenter.com', 'Barranquilla', 'Carlos Eduardo Ríos', '+573015432152', 'Especialista en vidrios resistentes al viento tropical. Reforzados.', '+573015432152', 'both', ARRAY['12'], true, 4.8, 39),
  ('vendedor_220@servicenter.com', 'Cartagena', 'Roberto Pineda', '+573015678944', 'Vidrios para arquitectura colonial. Estilos tradicionales, detalles finos.', '+573015678944', 'whatsapp', ARRAY['12'], true, 4.7, 36)
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

-- Vendedores adicionales en ciudades secundarias (muestra)
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
  -- Electricistas en ciudades secundarias
  ('vendedor_221@servicenter.com', 'Pereira', 'Juan Pablo Londoño', '+573016123456', 'Electricista en Pereira. Instalaciones, reparaciones, mantenimiento.', '+573016123456', 'both', ARRAY['1'], true, 4.7, 35),
  ('vendedor_222@servicenter.com', 'Ibagué', 'Carlos Arturo Rodríguez', '+573018123456', 'Electricista en Ibagué. Servicio confiable, garantía incluida.', '+573018123456', 'both', ARRAY['1'], true, 4.6, 32),
  ('vendedor_223@servicenter.com', 'Manizales', 'Luis Fernando Villa', '+573017123456', 'Electricista en Manizales. Clima frío, instalaciones especiales.', '+573017123456', 'both', ARRAY['1'], true, 4.8, 38),
  ('vendedor_224@servicenter.com', 'Santa Marta', 'Jorge Enrique Castro', '+573015234567', 'Electricista en Santa Marta. Clima tropical, instalaciones resistentes.', '+573015234567', 'both', ARRAY['1'], true, 4.7, 34),
  ('vendedor_225@servicenter.com', 'Bucaramanga', 'Miguel Ángel Rojas', '+573016234567', 'Electricista en Bucaramanga. Servicio profesional, precios justos.', '+573016234567', 'both', ARRAY['1'], true, 4.6, 30),
  
  -- Plomeros en ciudades secundarias
  ('vendedor_226@servicenter.com', 'Pereira', 'María Clemencia Orozco', '+573016123457', 'Plomera en Pereira. Reparaciones, instalaciones, mantenimiento.', '+573016123457', 'both', ARRAY['2'], true, 4.8, 37),
  ('vendedor_227@servicenter.com', 'Ibagué', 'Lucía Stella Giraldo', '+573018123457', 'Plomera en Ibagué. Fugas, baños, cocinas completas.', '+573018123457', 'both', ARRAY['2'], true, 4.7, 33),
  ('vendedor_228@servicenter.com', 'Manizales', 'Rosa Helena Vélez', '+573017123457', 'Plomera en Manizales. Clima frío, sistemas de agua caliente.', '+573017123457', 'both', ARRAY['2'], true, 4.9, 40),
  ('vendedor_229@servicenter.com', 'Santa Marta', 'Carmen Julia Pineda', '+573015234568', 'Plomera en Santa Marta. Clima tropical, especialista en corrosión.', '+573015234568', 'both', ARRAY['2'], true, 4.6, 31),
  ('vendedor_230@servicenter.com', 'Bucaramanga', 'Beatriz Elena Guzmán', '+573016234568', 'Plomera en Bucaramanga. Servicio urgente disponible.', '+573016234568', 'both', ARRAY['2'], true, 4.7, 36),
  
  -- Cerrajeros en ciudades secundarias
  ('vendedor_231@servicenter.com', 'Pereira', 'Jaime Alberto Montoya', '+573016123458', 'Cerrajero en Pereira. Apertura 24/7, cambio de cerraduras.', '+573016123458', 'both', ARRAY['3'], true, 4.9, 42),
  ('vendedor_232@servicenter.com', 'Ibagué', 'Luis Carlos Bedoya', '+573018123458', 'Cerrajero en Ibagué. Apertura de puertas, llaves duplicadas.', '+573018123458', 'both', ARRAY['3'], true, 4.7, 35),
  ('vendedor_233@servicenter.com', 'Manizales', 'Fernando Salazar', '+573017123458', 'Cerrajero en Manizales. Cerraduras inteligentes, sistemas de seguridad.', '+573017123458', 'both', ARRAY['3'], true, 4.8, 38),
  ('vendedor_234@servicenter.com', 'Santa Marta', 'Roberto Arango', '+573015234569', 'Cerrajero en Santa Marta. Apertura urgente, cambio de cerraduras.', '+573015234569', 'both', ARRAY['3'], true, 4.7, 33),
  ('vendedor_235@servicenter.com', 'Bucaramanga', 'José María Ramírez', '+573016234569', 'Cerrajero en Bucaramanga. Servicio profesional, garantía incluida.', '+573016234569', 'both', ARRAY['3'], true, 4.6, 29),
  
  -- Carpinteros en ciudades secundarias
  ('vendedor_236@servicenter.com', 'Pereira', 'Humberto Giraldo', '+573016123459', 'Carpintero en Pereira. Muebles, puertas, ventanas, trabajos finos.', '+573016123459', 'both', ARRAY['4'], true, 4.8, 40),
  ('vendedor_237@servicenter.com', 'Ibagué', 'Gilberto Londoño', '+573018123459', 'Carpintero en Ibagué. Muebles artesanales, restauración.', '+573018123459', 'both', ARRAY['4'], true, 4.7, 36),
  ('vendedor_238@servicenter.com', 'Manizales', 'Alfonso Uribe', '+573017123459', 'Carpintero en Manizales. Muebles estilo café, acabados naturales.', '+573017123459', 'both', ARRAY['4'], true, 4.9, 43),
  ('vendedor_239@servicenter.com', 'Santa Marta', 'Rafael Villa', '+573015234570', 'Carpintero en Santa Marta. Maderas tropicales, tratamientos especiales.', '+573015234570', 'both', ARRAY['4'], true, 4.6, 32),
  ('vendedor_240@servicenter.com', 'Bucaramanga', 'Eduardo Pineda', '+573016234570', 'Carpintero en Bucaramanga. Reparaciones rápidas, trabajos finos.', '+573016234570', 'both', ARRAY['4'], true, 4.7, 35),
  
  -- Pintores en ciudades secundarias
  ('vendedor_241@servicenter.com', 'Pereira', 'William Valencia', '+573016123460', 'Pintor en Pereira. Interiores, exteriores, acabados perfectos.', '+573016123460', 'both', ARRAY['5'], true, 4.8, 39),
  ('vendedor_242@servicenter.com', 'Ibagué', 'Héctor Ríos', '+573018123460', 'Pintor en Ibagué. Pintura decorativa, efectos especiales.', '+573018123460', 'both', ARRAY['5'], true, 4.7, 34),
  ('vendedor_243@servicenter.com', 'Manizales', 'Julio Castaño', '+573017123460', 'Pintor en Manizales. Acabados para clima frío, especializado.', '+573017123460', 'both', ARRAY['5'], true, 4.9, 41),
  ('vendedor_244@servicenter.com', 'Santa Marta', 'César Martínez', '+573015234571', 'Pintor en Santa Marta. Clima tropical, pinturas resistentes.', '+573015234571', 'both', ARRAY['5'], true, 4.6, 31),
  ('vendedor_245@servicenter.com', 'Bucaramanga', 'Alberto Santos', '+573016234571', 'Pintor en Bucaramanga. Servicio profesional, colores vivos.', '+573016234571', 'both', ARRAY['5'], true, 4.7, 34),
  
  -- Albañiles en ciudades secundarias
  ('vendedor_246@servicenter.com', 'Pereira', 'Orlando Cardona', '+573016123461', 'Albañil en Pereira. Construcción, reparaciones, acabados.', '+573016123461', 'both', ARRAY['6'], true, 4.7, 38),
  ('vendedor_247@servicenter.com', 'Ibagué', 'Elías Muñoz', '+573018123461', 'Albañil en Ibagué. Estructuras, paredes, columnas, cimentaciones.', '+573018123461', 'both', ARRAY['6'], true, 4.6, 33),
  ('vendedor_248@servicenter.com', 'Manizales', 'Raúl Gómez', '+573017123461', 'Albañil en Manizales. Sismo-resistente, reforzamiento estructural.', '+573017123461', 'both', ARRAY['6'], true, 4.9, 42),
  ('vendedor_249@servicenter.com', 'Santa Marta', 'Fernando Herrera', '+573015234572', 'Albañil en Santa Marta. Clima tropical, construcciones resistentes.', '+573015234572', 'both', ARRAY['6'], true, 4.7, 35),
  ('vendedor_250@servicenter.com', 'Bucaramanga', 'Jesús Silva', '+573016234572', 'Albañil en Bucaramanga. Remodelaciones, ampliaciones, acabados.', '+573016234572', 'both', ARRAY['6'], true, 4.6, 30),
  
  -- Jardineros en ciudades secundarias
  ('vendedor_251@servicenter.com', 'Pereira', 'Jorge Humberto Zapata', '+573016123462', 'Jardinero en Pereira. Mantenimiento, poda, diseño de jardines.', '+573016123462', 'both', ARRAY['7'], true, 4.8, 36),
  ('vendedor_252@servicenter.com', 'Ibagué', 'Carlos Alberto Orozco', '+573018123462', 'Jardinero en Ibagué. Paisajismo, riego, cuidado de plantas.', '+573018123462', 'both', ARRAY['7'], true, 4.7, 32),
  ('vendedor_253@servicenter.com', 'Manizales', 'Luis Fernando Villa', '+573017123462', 'Jardinero en Manizales. Plantas de clima frío, jardines verticales.', '+573017123462', 'both', ARRAY['7'], true, 4.9, 39),
  ('vendedor_254@servicenter.com', 'Santa Marta', 'Pedro Antonio García', '+573015234573', 'Jardinero en Santa Marta. Plantas tropicales, palmeras, poda.', '+573015234573', 'both', ARRAY['7'], true, 4.6, 30),
  ('vendedor_255@servicenter.com', 'Bucaramanga', 'Miguel Ángel López', '+573016234573', 'Jardinero en Bucaramanga. Mantenimiento, diseño, paisajismo.', '+573016234573', 'both', ARRAY['7'], true, 4.7, 33),
  
  -- Limpieza en ciudades secundarias
  ('vendedor_256@servicenter.com', 'Pereira', 'Ana María Montoya', '+573016123463', 'Limpieza en Pereira. Aseo profundo, organización, desinfección.', '+573016123463', 'both', ARRAY['8'], true, 4.9, 44),
  ('vendedor_257@servicenter.com', 'Ibagué', 'Carmen Julia Uribe', '+573018123463', 'Limpieza en Ibagué. Personal confiable, resultados impecables.', '+573018123463', 'both', ARRAY['8'], true, 4.8, 38),
  ('vendedor_258@servicenter.com', 'Manizales', 'Rosa Elena Arias', '+573017123463', 'Limpieza en Manizales. Aseo profundo, acabados perfectos.', '+573017123463', 'both', ARRAY['8'], true, 4.7, 35),
  ('vendedor_259@servicenter.com', 'Santa Marta', 'María del Pilar Giraldo', '+573015234574', 'Limpieza en Santa Marta. Clima tropical, control de humedad.', '+573015234574', 'both', ARRAY['8'], true, 4.6, 31),
  ('vendedor_260@servicenter.com', 'Bucaramanga', 'Lucía Carolina Ramírez', '+573016234574', 'Limpieza en Bucaramanga. Servicio profesional, garantía incluida.', '+573016234574', 'both', ARRAY['8'], true, 4.7, 34)
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

-- Mensaje de confirmación
DO $$
BEGIN
  RAISE NOTICE 'Se han creado 260 vendedores de demostración exitosamente.';
  RAISE NOTICE 'Los vendedores están distribuidos en múltiples ciudades y categorías.';
  RAISE NOTICE 'Puedes agregar más vendedores siguiendo el mismo patrón.';
END $$;
