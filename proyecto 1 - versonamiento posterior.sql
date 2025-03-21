-- Todas las claves primarias se cambiaron a Serial para hacerlas autoincrementales.

-- Nueva tabla usuarios: nueva tabla para gestión de usuarios del sistema
CREATE TABLE Usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL CHECK (POSITION('@' IN email) > 0),
    password TEXT NOT NULL, -- Debe almacenarse encriptada para evitar hackeos
    rol TEXT CHECK (rol IN ('ONG', 'Voluntario', 'Líder Comunitario')),
    fecha_registro DATE DEFAULT CURRENT_DATE,
    ultimo_acceso TIMESTAMP,
    estado BOOLEAN DEFAULT TRUE,
    id_referencia INT, -- ID de la entidad relacionada (ONG, voluntario, lider) segun el tipo_referencia.
    tipo_referencia TEXT CHECK (tipo_referencia IN ('ONG', 'Voluntario', 'Comunidad'))
);

-- Nueva tabla niños: para seguimiento detallado de niños en riesgo
CREATE TABLE Ninos (
    id_nino SERIAL PRIMARY KEY,
    id_familia INT NOT NULL,
    nombre TEXT NOT NULL,
    fecha_nacimiento DATE NOT NULL CHECK (fecha_nacimiento <= CURRENT_DATE),
    genero CHAR(1) CHECK (genero IN ('M', 'F')),
    peso DOUBLE PRECISION CHECK (peso > 0),
    talla DOUBLE PRECISION CHECK (talla > 0),
    imc DOUBLE PRECISION GENERATED ALWAYS AS (peso / (talla * talla)) STORED,  -- Cálculo automático IMC
    estado_nutricional TEXT CHECK (estado_nutricional IN ('Normal', 'Desnutrición Leve', 'Desnutrición Moderada', 'Desnutrición Severa')),
    fecha_evaluacion DATE DEFAULT CURRENT_DATE,
    alergias TEXT,
    observaciones TEXT,
    estado BOOLEAN DEFAULT TRUE
);

-- Tabla familias: sirve para registrar a las familias de las comunidades.
CREATE TABLE Familias (
    id_familia SERIAL PRIMARY KEY,
    nombre_esposo TEXT, 
    nombre_esposa TEXT,
    dpi_esposo VARCHAR(13) UNIQUE CHECK (LENGTH(dpi_esposo) = 13), -- El DPI debe ser único y verificado que sean 13 dígitos.
    dpi_esposa VARCHAR(13) UNIQUE CHECK (LENGTH(dpi_esposa) = 13),
    fecha_nacimiento_esposo DATE CHECK (fecha_nacimiento_esposo <= CURRENT_DATE), -- Verificar que sea fecha.
    fecha_nacimiento_esposa DATE CHECK (fecha_nacimiento_esposa <= CURRENT_DATE),
    embarazada BOOLEAN,
    hijos_0_2 INT CHECK (hijos_0_2 >= 0), -- Verificar que la cantidad de hijos sea 0 o mayor (no #negativos).
    hijos_2_5 INT CHECK (hijos_2_5 >= 0),
    hijos_6_17 INT CHECK (hijos_6_17 >= 0),
    area_siembra_maiz DOUBLE PRECISION CHECK (area_siembra_maiz >= 0), -- Verifica que solo sean #positovos y 0.
    rendimiento_maiz DOUBLE PRECISION  CHECK (rendimiento_maiz >= 0),
    area_siembra_frijol DOUBLE PRECISION CHECK (area_siembra_frijol >= 0),
    rendimiento_frijol DOUBLE PRECISION CHECK (rendimiento_frijol >= 0),
    personal_encargado TEXT DEFAULT '100'
);

--Tabla voluntarios: Registara la información de los voluntarios quienes brindarán su apoyo a las comunidades.
CREATE TABLE Voluntarios (
    id_voluntario SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL, -- Obligatorio
    apellido TEXT NOT NULL,
    dpi VARCHAR(13) UNIQUE CHECK (LENGTH(dpi) = 13), --Registra que # de DPI sea unico y de 13 dígitos.
    fecha_nacimiento DATE CHECK (fecha_nacimiento <= CURRENT_DATE), --Verifica que sea una fecha.
    telefono VARCHAR(15) CHECK (LENGTH(telefono) BETWEEN 8 AND 15), --Verifica que el largo del # de telefono sea de 8 a 15 dígitos.
    email TEXT UNIQUE CHECK (POSITION('@' IN email) > 0), -- Para verificar que es correo electronico debe incluir un arroba.
    direccion TEXT,
    experiencia TEXT,
    disponibilidad TEXT CHECK (disponibilidad IN ('Baja', 'Media', 'Alta')), -- Se agrega valores opciones para indicar el nivel de disponibilidad.
    tipo_voluntario TEXT,
    institucion TEXT,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    estado BOOLEAN DEFAULT TRUE,
	comentarios TEXT,
	habilidades TEXT -- Validar cuales son las habilidades de los voluntarios para un mejor impacto en sus labores.
);


CREATE TABLE ONGs (
    id_ong SERIAL PRIMARY KEY NOT NULL,
    nombre_ong TEXT NOT NULL, -- Obligatorio
    direccion TEXT NOT NULL,
    telefono VARCHAR(15) CHECK (LENGTH(telefono) BETWEEN 8 AND 15), -- verifica que el #telefonico tenga un largo de 8 a 15 digitos.
    email TEXT UNIQUE CHECK (POSITION('@' IN email) > 0), -- si es un correo electronico debe tener un arroba.
    representante TEXT NOT NULL,
    tipo_ong TEXT CHECK (tipo_ong IN ('Salud', 'Educación', 'Nutrición', 'Otro')), -- Brinda opciones más especificas.
    fecha_fundacion DATE CHECK (fecha_fundacion <= CURRENT_DATE), -- verifica que sea fecha.
    mision TEXT,
    vision TEXT,
    estado BOOLEAN DEFAULT TRUE,
    fecha_registro DATE CHECK (fecha_registro<= CURRENT_DATE),
    sitio_web TEXT DEFAULT '100',
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100'
);

CREATE TABLE Comunidades (
    id_comunidad SERIAL PRIMARY KEY NOT NULL,
    nombre_comunidad TEXT DEFAULT '100',
    codigo_ine TEXT DEFAULT '10',
    departamento TEXT DEFAULT '100',
    municipio TEXT DEFAULT '100',
    numero_familias INT,
    grupo_etnico TEXT DEFAULT '50',
    tipo_comunidad TEXT DEFAULT '50',
    fecha_registro DATE,
    estado BOOLEAN,
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100',
    proyectos_en_comunidad TEXT,
    recursos_disponibles TEXT,
    necesidades_comunidad TEXT,
	coordenadas_gps TEXT -- Nueva columna para una mejor ubicación de la cominidad
);

CREATE TABLE Registros (
    id_registro SERIAL PRIMARY KEY,
    cantidad_ayuda NUMERIC(10,2) CHECK (cantidad_ayuda >= 0), -- Numero positivo.
    id_familia INT REFERENCES Familias(id_familia) ON DELETE CASCADE,
    id_voluntario INT REFERENCES Voluntarios(id_voluntario) ON DELETE SET NULL,
    id_ong INT REFERENCES ONGs(id_ong) ON DELETE SET NULL,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    tipo_ayuda TEXT CHECK (tipo_ayuda IN ('Alimentación', 'Salud', 'Educación', 'Otro')), -- Brinda opciones segun el tipo de ayuda.
    descripcion_ayuda TEXT,
    estado BOOLEAN DEFAULT TRUE,
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100'
);

CREATE TABLE CResultados (
    id_capacidad SERIAL PRIMARY KEY NOT NULL,
    id_familia INT REFERENCES Familias(id_familia),
    resultado_evaluacion TEXT NOT NULL, --Obligatorio
    descripcion_capacidad TEXT,
    nivel_capacidad TEXT DEFAULT '50',
    fecha_registro DATE,
    estado BOOLEAN,
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100',
    tipo_capacidad TEXT DEFAULT '50',
    observaciones TEXT,
    fecha_actualizacion DATE,
    metodo_evaluacion TEXT DEFAULT '100',
    recomendaciones TEXT,
    seguimiento TEXT,
    tipo_registro TEXT DEFAULT '50'
);

CREATE TABLE Actividades (
    id_actividad SERIAL PRIMARY KEY NOT NULL,
    id_familia INT REFERENCES Familias(id_familia),
    descripcion_actividad TEXT,
    fecha_actividad DATE,
    duracion TEXT DEFAULT '50',
    responsable TEXT NOT NULL,
    estado BOOLEAN DEFAULT TRUE,
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100',
    tipo_actividad TEXT CHECK (tipo_actividad IN ('Capacitación', 'Evaluación', 'Entrega de Ayuda', 'Seguimiento', 'Otro')), -- Opciones para el tipo de actividad
    resultado TEXT,
    fecha_registro DATE,
    metodo_evaluacion TEXT DEFAULT '100',
    observaciones TEXT,
    seguimiento TEXT,
    tipo_registro TEXT DEFAULT '50'
);

CREATE TABLE Evaluaciones (
    id_evaluacion SERIAL PRIMARY KEY NOT NULL,
    id_familia INT REFERENCES Familias(id_familia),
    fecha_evaluacion DATE DEFAULT CURRENT_DATE,
    descripcion_evaluacion TEXT NOT NULL,
    resultado TEXT NOT NULL, -- obligatorio
    recomendaciones TEXT,
    estado BOOLEAN DEFAULT TRUE,
    comentarios TEXT,
    personal_encargado TEXT,
    metodo_evaluacion TEXT,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    tipo_evaluacion TEXT CHECK (tipo_evaluacion IN ('Nutricional', 'Socioeconómica', 'Salud', 'Educación', 'Otro')), -- Opciones
    observaciones TEXT,
    seguimiento TEXT,
    tipo_registro TEXT,
    metodo_recoleccion TEXT
);

CREATE TABLE Reportes (
    id_reporte SERIAL PRIMARY KEY NOT NULL,
    id_familia INT REFERENCES Familias(id_familia),
    fecha_reporte DATE DEFAULT CURRENT_DATE,
    descripcion_reporte TEXT NOT NULL, -- obligatorio
    estado BOOLEAN DEFAULT TRUE,
    comentarios TEXT,
    personal_encargado TEXT,
    tipo_reporte TEXT CHECK (tipo_reporte IN ('Alerta', 'Seguimiento', 'Evaluación', 'Estadístico', 'Otro')), -- opciones
    fecha_registro DATE DEFAULT CURRENT_DATE,
    metodo_recoleccion TEXT,
    observaciones TEXT,
    seguimiento TEXT,
    tipo_registro TEXT,
    resultado TEXT,
    recomendaciones TEXT,
    metodo_evaluacion TEXT,
    nivel_urgencia TEXT CHECK (nivel_urgencia IN ('Bajo', 'Medio', 'Alto', 'Crítico'))  -- Nueva columna para validar la grabedar del afectado
);

CREATE TABLE Donaciones (
    id_donacion SERIAL PRIMARY KEY,
    id_ong INT REFERENCES ONGs(id_ong) ON DELETE SET NULL, -- si se elimina un registro de la tabla se establecera como null.
    id_voluntario INT REFERENCES Voluntarios(id_voluntario) ON DELETE SET NULL,
    fecha_donacion DATE DEFAULT CURRENT_DATE, 
    tipo_donacion TEXT CHECK (tipo_donacion IN ('Efectivo', 'Víveres', 'Ropa', 'Otros')), -- brinda opciones según que donación sea.
    cantidad NUMERIC(10,2) CHECK (cantidad > 0),
    unidad_medida TEXT CHECK (unidad_medida IN ('Kilogramos', 'Libras', 'Onzas', 'Litros', 'Unidades', 'Otros')), -- brinda opciones segun la unidad de medida de la donación.
    estado BOOLEAN DEFAULT TRUE,
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100',
    Seguimiento INT,
    Capacitaciones INT,
    Proyectos INT,
	destinatario TEXT,  
	fecha_entrega DATE,
	comprobante TEXT
);

-- Nueva tabla Casos Criticos: sirve para las alertas y seguimiento de casos urgentes
CREATE TABLE Casos_Criticos (
    id_caso SERIAL PRIMARY KEY,
    id_nino INT,                      
    id_familia INT NOT NULL,
    fecha_deteccion DATE DEFAULT CURRENT_DATE,
    descripcion TEXT NOT NULL,
    nivel_urgencia TEXT CHECK (nivel_urgencia IN ('Alto', 'Crítico')) NOT NULL,
    sintomas TEXT,
    acciones_tomadas TEXT,
    estado TEXT CHECK (estado IN ('Detectado', 'En Atención', 'Derivado', 'Resuelto', 'Seguimiento')) NOT NULL,
    id_responsable INT NOT NULL,      -- ID del responsable (voluntario, ONG)
    tipo_responsable TEXT CHECK (tipo_responsable IN ('Voluntario', 'ONG')),
    fecha_ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_resolucion DATE,
    observaciones TEXT,
    requiere_traslado BOOLEAN DEFAULT FALSE
);

-- columna id_comunidad a Familias
ALTER TABLE Familias ADD COLUMN id_comunidad INT;
ALTER TABLE Familias ADD CONSTRAINT FK_Familias_Comunidades FOREIGN KEY (id_comunidad) REFERENCES Comunidades(id_comunidad);

-- Claves foráneas
ALTER TABLE Registros ADD CONSTRAINT FK_Registros_Familias FOREIGN KEY (id_familia) REFERENCES Familias(id_familia);
ALTER TABLE Registros ADD CONSTRAINT FK_Registros_Voluntarios FOREIGN KEY (id_voluntario) REFERENCES Voluntarios(id_voluntario);
ALTER TABLE Registros ADD CONSTRAINT FK_Registros_ONGs FOREIGN KEY (id_ong) REFERENCES ONGs(id_ong);

ALTER TABLE CResultados ADD CONSTRAINT FK_CResultados_Familias FOREIGN KEY (id_familia) REFERENCES Familias(id_familia);

ALTER TABLE Actividades ADD CONSTRAINT FK_Actividades_Familias FOREIGN KEY (id_familia) REFERENCES Familias(id_familia);

ALTER TABLE Evaluaciones ADD CONSTRAINT FK_Evaluaciones_Familias FOREIGN KEY (id_familia) REFERENCES Familias(id_familia);

ALTER TABLE Reportes ADD CONSTRAINT FK_Reportes_Familias FOREIGN KEY (id_familia) REFERENCES Familias(id_familia);

ALTER TABLE Donaciones ADD CONSTRAINT FK_Donaciones_ONGs FOREIGN KEY (id_ong) REFERENCES ONGs(id_ong);
ALTER TABLE Donaciones ADD CONSTRAINT FK_Donaciones_Voluntarios FOREIGN KEY (id_voluntario) REFERENCES Voluntarios(id_voluntario);

ALTER TABLE Ninos ADD CONSTRAINT FK_Ninos_Familias 
    FOREIGN KEY (id_familia) REFERENCES Familias(id_familia) ON DELETE CASCADE;

ALTER TABLE Casos_Criticos ADD CONSTRAINT FK_Casos_Criticos_Familias 
    FOREIGN KEY (id_familia) REFERENCES Familias(id_familia) ON DELETE CASCADE;

ALTER TABLE Casos_Criticos ADD CONSTRAINT FK_Casos_Criticos_Ninos 
    FOREIGN KEY (id_nino) REFERENCES Ninos(id_nino) ON DELETE SET NULL;


-- columna id_comunidad a ONGs
ALTER TABLE ONGs ADD COLUMN id_comunidad INT;
ALTER TABLE ONGs ADD CONSTRAINT FK_ONGs_Comunidades FOREIGN KEY (id_comunidad) REFERENCES Comunidades(id_comunidad);
