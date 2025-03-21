CREATE TABLE Familias (
    id_familia INT PRIMARY KEY NOT NULL,
    nombre_esposo TEXT DEFAULT '100',
    nombre_esposa TEXT DEFAULT '100',
    dpi_esposo TEXT DEFAULT '13',
    dpi_esposa TEXT DEFAULT '13',
    fecha_nacimiento_esposo DATE,
    fecha_nacimiento_esposa DATE,
    embarazada BOOLEAN,
    hijos_0_2 INT,
    hijos_2_5 INT,
    hijos_6_17 INT,
    area_siembra_maiz DOUBLE PRECISION,
    rendimiento_maiz DOUBLE PRECISION,
    area_siembra_frijol DOUBLE PRECISION,
    rendimiento_frijol DOUBLE PRECISION,
    personal_encargado TEXT DEFAULT '100'
);

CREATE TABLE Voluntarios (
    id_voluntario INT PRIMARY KEY NOT NULL,
    nombre TEXT DEFAULT '100',
    apellido TEXT DEFAULT '100',
    dpi TEXT DEFAULT '13',
    fecha_nacimiento DATE,
    telefono TEXT DEFAULT '15',
    email TEXT DEFAULT '100',
    direccion TEXT DEFAULT '255',
    experiencia TEXT,
    disponibilidad TEXT DEFAULT '50',
    tipo_voluntario TEXT DEFAULT '50',
    institucion TEXT DEFAULT '100',
    fecha_registro DATE,
    estado BOOLEAN,
    comentarios TEXT
);

CREATE TABLE ONGs (
    id_ong INT PRIMARY KEY NOT NULL,
    nombre_ong TEXT DEFAULT '100',
    direccion TEXT DEFAULT '255',
    telefono TEXT DEFAULT '15',
    email TEXT DEFAULT '100',
    representante TEXT DEFAULT '100',
    tipo_ong TEXT DEFAULT '50',
    fecha_fundacion DATE,
    mision TEXT,
    vision TEXT,
    proyectos TEXT,
    estado BOOLEAN,
    fecha_registro DATE,
    sitio_web TEXT DEFAULT '100',
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100'
);

CREATE TABLE Comunidades (
    id_comunidad INT PRIMARY KEY NOT NULL,
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
    necesidades_comunidad TEXT
);

CREATE TABLE Registros (
    id_registro INT PRIMARY KEY NOT NULL,
    cantidad_ayuda DOUBLE PRECISION,
    id_familia INT REFERENCES Familias(id_familia),
    id_voluntario INT REFERENCES Voluntarios(id_voluntario),
    id_ong INT REFERENCES ONGs(id_ong),
    fecha_registro DATE,
    tipo_ayuda TEXT DEFAULT '100',
    descripcion_ayuda TEXT,
    estado BOOLEAN,
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100',
    fecha_actualizacion DATE,
    metodo_entrega TEXT DEFAULT '100',
    unidad_medida TEXT DEFAULT '50',
    observaciones TEXT,
    tipo_registro TEXT DEFAULT '50'
);

CREATE TABLE CResultados (
    id_capacidad INT PRIMARY KEY NOT NULL,
    id_familia INT REFERENCES Familias(id_familia),
    resultado_evaluacion TEXT DEFAULT '100',
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
    id_actividad INT PRIMARY KEY NOT NULL,
    id_familia INT REFERENCES Familias(id_familia),
    descripcion_actividad TEXT,
    fecha_actividad DATE,
    duracion TEXT DEFAULT '50',
    responsable TEXT DEFAULT '100',
    estado BOOLEAN,
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100',
    tipo_actividad TEXT DEFAULT '50',
    resultado TEXT,
    fecha_registro DATE,
    metodo_evaluacion TEXT DEFAULT '100',
    observaciones TEXT,
    seguimiento TEXT,
    tipo_registro TEXT DEFAULT '50'
);

CREATE TABLE Evaluaciones (
    id_evaluacion INT PRIMARY KEY NOT NULL,
    id_familia INT REFERENCES Familias(id_familia),
    fecha_evaluacion DATE,
    descripcion_evaluacion TEXT,
    resultado TEXT DEFAULT '100',
    recomendaciones TEXT,
    estado BOOLEAN,
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100',
    metodo_evaluacion TEXT DEFAULT '100',
    fecha_registro DATE,
    tipo_evaluacion TEXT DEFAULT '50',
    observaciones TEXT,
    seguimiento TEXT,
    tipo_registro TEXT DEFAULT '50',
    metodo_recoleccion TEXT DEFAULT '100'
);

CREATE TABLE Reportes (
    id_reporte INT PRIMARY KEY NOT NULL,
    id_familia INT REFERENCES Familias(id_familia),
    fecha_reporte DATE,
    descripcion_reporte TEXT,
    estado BOOLEAN,
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100',
    tipo_reporte TEXT DEFAULT '50',
    fecha_registro DATE,
    metodo_recoleccion TEXT DEFAULT '100',
    observaciones TEXT,
    seguimiento TEXT,
    tipo_registro TEXT DEFAULT '50',
    resultado TEXT DEFAULT '100',
    recomendaciones TEXT,
    metodo_evaluacion TEXT DEFAULT '100'
);

CREATE TABLE Donaciones (
    id_donacion INT PRIMARY KEY NOT NULL,
    id_ong INT REFERENCES ONGs(id_ong),
    id_voluntario INT REFERENCES Voluntarios(id_voluntario),
    fecha_donacion DATE,
    tipo_donacion TEXT DEFAULT '100',
    cantidad DOUBLE PRECISION,
    unidad_medida TEXT DEFAULT '50',
    estado BOOLEAN,
    comentarios TEXT,
    personal_encargado TEXT DEFAULT '100',
    metodo_donacion TEXT DEFAULT '100',
    fecha_registro DATE,
    observaciones TEXT,
    tipo_registro TEXT DEFAULT '50',
    resultado TEXT DEFAULT '100',
    recomendaciones INT,
    Seguimiento INT,
    Capacitaciones INT,
    Proyectos INT,
    Evaluaciones_Proyectos INT,
    Donantes INT,
    Recursos INT,
    Tipos_Ayuda INT
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

-- columna id_comunidad a ONGs
ALTER TABLE ONGs ADD COLUMN id_comunidad INT;
ALTER TABLE ONGs ADD CONSTRAINT FK_ONGs_Comunidades FOREIGN KEY (id_comunidad) REFERENCES Comunidades(id_comunidad);
