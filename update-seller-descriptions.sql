-- Script para actualizar las descripciones de los vendedores con descripciones más profesionales
-- Basado en mejores prácticas de plataformas como Upwork y Fiverr
-- Ejecutar este script en el SQL Editor de Supabase

-- Actualizar descripciones de electricistas
UPDATE public.users
SET description = 'Carlos Rodríguez — 15 años en electricidad residencial y comercial, certificado RETIE, especialista en instalaciones de baja y media tensión. Empecé mi negocio en 2009 después de trabajar para grandes constructoras donde vi cómo se descuidaban los detalles que importan a las familias. Mi filosofía es simple: cada instalación debe ser segura, eficiente y duradera. Ofrezco garantía escrita en todos mis trabajos y fotos de antes y después para tu tranquilidad. Disponible para urgencias 24/7.'
WHERE email = 'carlos_electricista1@servicenter.com';

UPDATE public.users
SET description = 'Juan Martínez — electricista certificado con especialización en iluminación LED y domótica, 12 años de experiencia. Certificado en sistemas de seguridad eléctrica y automatización hogareña. Me convertí en independiente en 2016 porque quería ofrecer soluciones tecnológicas que las empresas grandes ignoraban. Mi fuerte es transformar hogares tradicionales en espacios inteligentes sin complicaciones. Cada cliente recibe un manual personalizado de su sistema. Servicio urgente disponible día y noche.'
WHERE email = 'juan_electricista1@servicenter.com';

UPDATE public.users
SET description = 'Pedro López — técnico electricista con 8 años de experiencia en reparaciones rápidas y diagnósticos precisos. Especialista en cortocircuitos, sobrecargas y fallas complejas. Comencé como aprendiz en mi barrio y ahora atiendo toda la zona de Cali. Me caracterizo por diagnósticos rápidos y soluciones permanentes, no parches temporales. Mis clientes saben que si algo falla después de mi trabajo, vuelvo sin costo adicional.'
WHERE email = 'pedro_electricista1@servicenter.com';

UPDATE public.users
SET description = 'Luis Torres — electricista especializado en edificios y apartamentos, 10 años de experiencia. Certificado en instalaciones para propiedades horizontales. Trabajé 6 años en la administración de edificios antes de emprender, lo que me da una perspectiva única de las necesidades comunitarias. Entiendo la importancia de minimizar interrupciones en edificios. Coordino directamente con administradores para trabajos programados.'
WHERE email = 'luis_electricista1@servicenter.com';

UPDATE public.users
SET description = 'María García — electricista en Cartagena con especialización en instalaciones en zonas históricas y modernas. 9 años de experiencia adaptando instalaciones a reglamentaciones de patrimonio. Me dedico a preservar la integridad arquitectónica mientras modernizo sistemas eléctricos. Cada proyecto en el centro histórico requiere permisos especiales que gestiono para mis clientes. También trabajo en zonas modernas con tecnología de punta.'
WHERE email = 'maria_electricista1@servicenter.com';

-- Actualizar descripciones de plomeros
UPDATE public.users
SET description = 'Juliana Giraldo — plomera profesional con 18 años de experiencia, certificada en instalaciones de gas y agua potable. Licencia municipal #PL-BOG-4521. Pasé 11 años en una empresa de servicios públicos antes de independizarme en 2011. Cansada de ver clientes sin respuestas, creé mi propio servicio con atención personalizada. Mi regla: cada fuga encontrada se explica con fotos antes de reparar. No cobro por diagnósticos si realizo el trabajo.'
WHERE email = 'juliana_plomera1@servicenter.com';

UPDATE public.users
SET description = 'Martha Arango — plomera en Medellín con especialización en remodelaciones de baños y cocinas. 14 años de experiencia. Certificada en sistemas de calefacción solar y ecológicos. Comencé este camino remodelando la casa de mis padres y descubrí mi pasión. Me especializo en proyectos completos desde el diseño hasta la instalación. Cada cliente recibe un cronograma detallado y actualizaciones diarias por WhatsApp.'
WHERE email = 'martha_plomera1@servicenter.com';

UPDATE public.users
SET description = 'Stephanie Romero — plomera en Cali, experta en sistemas de agua y gas con 10 años de experiencia. Certificada en detección de fugas con tecnología no invasiva. Mi fuerte es encontrar problemas ocultos sin romper paredes innecesariamente. Utilizo cámaras de inspección y equipos de ultrasonido. Mis clientes ahorran dinero en reparaciones porque encuentro la raíz del problema desde el principio.'
WHERE email = 'stephanie_plomera1@servicenter.com';

UPDATE public.users
SET description = 'Cristina Benítez — plomera en Barranquilla con 12 años de experiencia en instalaciones y reparaciones. Especialista en sistemas de desagüe para climas húmedos. Trabajé en mantenimiento de hoteles antes de emprender, lo que me enseñó a prevenir problemas antes de que ocurran. Ofrezco planes de mantenimiento preventivo que ahorran dolores de cabeza a largo plazo. Disponible para emergencias.'
WHERE email = 'cristina_plomera1@servicenter.com';

UPDATE public.users
SET description = 'Samuel Giraldo — plomero en Cartagena, experto en instalaciones y reparaciones en clima tropical. 15 años de experiencia tratando corrosión y salinidad. Desarrollé técnicas propias para proteger tuberías en zonas costeras. Cada instalación incluye tratamientos anticorrosión de fábrica. Mis clientes en zonas costeras tienen sistemas que duran el doble que el promedio.'
WHERE email = 'samuel_plomero1@servicenter.com';

-- Actualizar descripciones de cerrajeros
UPDATE public.users
SET description = 'David Castillo — cerrajero profesional disponible 24/7, 20 años de experiencia. Certificado en sistemas de seguridad electrónica y cerraduras de alta seguridad. Empecé en 2004 después de que mi propia casa fue asaltada; entiendo la urgencia y el miedo que sienten mis clientes. Mi promesa: nunca cobro más por llamadas nocturnas o fines de semana. Llego en 30 minutos o menos en Bogotá. Trabajo con todas las marcas principales.'
WHERE email = 'david_cerrajero1@servicenter.com';

UPDATE public.users
SET description = 'Alejandro Navarro — especialista en cerraduras inteligentes y biométricas, 8 años de experiencia. Certificado en sistemas de acceso controlado y domótica. Fui técnico en sistemas de seguridad corporativa antes de enfocarme en residencias. Llevo la tecnología de edificios inteligentes a hogares Colombianos. Instalo huellas digitales, reconocimiento facial y control por celular. Cada cliente recibe capacitación personalizada.'
WHERE email = 'alejandro_cerrajero1@servicenter.com';

UPDATE public.users
SET description = 'Javier Valle — cerrajero en Cali con 14 años de experiencia en apertura de puertas y cambio de cerraduras. Tradición familiar: mi padre fue cerrajero y me enseñó el oficio desde los 16 años. Mantengo la ética de los viejos tiempos: trabajo honesto, precios justos, sin sorpresas. Especialista en cerraduras antiguas que otros no pueden abrir. Preservo la originalidad de puertas antiguas cuando es posible.'
WHERE email = 'javier_cerrajero1@servicenter.com';

UPDATE public.users
SET description = 'José María Barros — cerrajero en Barranquilla, especialista en apertura urgente y cambio de cerraduras. 11 años de experiencia. Entiendo que en climas calurosos las cerraduras se desgastan más rápido. Ofrezco mantenimiento preventivo para extender la vida de sus cerraduras. Mi celular está encendido día y noche para emergencias. No cobro por desplazamiento dentro de la ciudad.'
WHERE email = 'jose_cerrajero1@servicenter.com';

UPDATE public.users
SET description = 'Oscar Paredes — cerrajero en Cartagena, experto en seguridad costera y cerraduras anticorrosión. 13 años de experiencia. Desarrollé métodos propios para proteger cerraduras de la salinidad del mar. Instalo cerraduras marinas de grado industrial en residencias costeras. Mis clientes en zonas cercanas al mar no tienen problemas de oxidación. Ofrezco garantía extendida en zonas de alta salinidad.'
WHERE email = 'oscar_cerrajero1@servicenter.com';

-- Actualizar descripciones de carpinteros
UPDATE public.users
SET description = 'Humberto Sánchez — carpintero con 25 años de experiencia en muebles a medida, puertas y ventanas. Maestro carpintero certificado. Aprendí el oficio de mi abuelo y perfeccioné técnicas tradicionales con herramientas modernas. Cada pieza que creo es única, diseñada específicamente para el espacio del cliente. Utilizo maderas certificadas y acabados ecológicos. Mi taller está abierto para visitas.'
WHERE email = 'humberto_carpintero1@servicenter.com';

UPDATE public.users
SET description = 'Gilberto Torres — especialista en muebles de diseño moderno, 18 años de experiencia. Certificado en diseño de interiores y fabricación de muebles. Mi fuerte son cocinas integrales, closets inteligentes y librerías a medida. Combino funcionalidad con estética contemporánea. Cada proyecto incluye renderizados 3D antes de fabricar. Trabajo con maderas importadas y materiales sostenibles.'
WHERE email = 'gilberto_carpintero1@servicenter.com';

UPDATE public.users
SET description = 'William Valencia — pintor profesional en Cali con 15 años de experiencia en interiores y exteriores. Certificado en técnicas de pintura decorativa y acabados especiales. Especialista en texturas, esponjados y estucos venecianos. Mi filosofía: la preparación es más importante que la pintura misma. Cada superficie se lija, sella y prepara meticulosamente. Los resultados hablan por sí mismos.'
WHERE email = 'william_carpintero1@servicenter.com';

UPDATE public.users
SET description = 'Ernesto Rodríguez — carpintero en Barranquilla con 12 años de experiencia en muebles resistentes al clima húmedo. Desarrollé tratamientos especiales para proteger madera de la humedad tropical. Mis muebles en zonas costeras duran años sin deformarse. Utilizo maderas tropicales resistentes y sellantes de grado marino. Cada pieza viene con instrucciones de mantenimiento para climas húmedos.'
WHERE email = 'ernesto_carpintero1@servicenter.com';

UPDATE public.users
SET description = 'Gregorio Paredes — carpintero en Cartagena, especialista en maderas resistentes a la salinidad. 14 años de experiencia. Trabajo exclusivamente con maderas tratadas para zonas costeras. Conozco qué especies resisten el mar y cuáles no. Mis clientes en Cartagena tienen muebles que no se pudren ni se deforman. Ofrezco servicio de mantenimiento anual incluido en mis trabajos principales.'
WHERE email = 'gregorio_carpintero1@servicenter.com';
