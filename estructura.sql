
-- Inicialmente basada en ingenier�a inversa de datos a la base empleada en el 
-- "Banco de Datos de derechos humanos y violencia pol�tica" de 2000 a 2004. 
-- Dominio p�blico. Sin garantias. vtamara@pasosdeJesus.org. 2004. 


-- Nombres de tablas deber�an ser sin _
-- llave foranea a la tabla t deber�a ser id_t

SET client_encoding = 'LATIN1';


CREATE TABLE actualizacionbase (
	id VARCHAR(10) PRIMARY KEY,
	fecha DATE NOT NULL,
	descripcion VARCHAR(500) NOT NULL
);

CREATE SEQUENCE antecedente_seq;

CREATE TABLE antecedente (
	id INTEGER PRIMARY KEY DEFAULT(nextval('antecedente_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion	DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
); 


-- CREATE SEQUENCE intervalo_seq;

CREATE SEQUENCE intervalo_seq;

-- Mejor inicio, fin (?)
CREATE TABLE intervalo (
	id INTEGER PRIMARY KEY DEFAULT (nextval('intervalo_seq')),
	nombre VARCHAR(25) NOT NULL,
	rango VARCHAR(25) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE caso_seq;

CREATE TABLE caso (
	id INTEGER PRIMARY KEY DEFAULT(nextval('caso_seq')),
	titulo VARCHAR(50),
	fecha DATE NOT NULL,
	hora VARCHAR(10),
	duracion VARCHAR(10),
	memo	TEXT NOT NULL,
	gr_confiabilidad VARCHAR(5), 
	gr_esclarecimiento VARCHAR(5),
	gr_impunidad VARCHAR(5),
	gr_informacion VARCHAR(5),
	bienes TEXT,
	id_intervalo INTEGER REFERENCES intervalo
); 

CREATE SEQUENCE pconsolidado_seq;

CREATE TABLE pconsolidado (
	no_columna INTEGER PRIMARY KEY DEFAULT (nextval('parametros_reporte_consolidado_seq')),
	rotulo VARCHAR(25) NOT NULL,
	 VARCHAR(25) NOT NULL,
	clasificacion VARCHAR(25) NOT NULL,
	peso	INTEGER DEFAULT '0',
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE TABLE  (
	id CHAR(1) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	nomcorto VARCHAR(10) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE TABLE supracategoria (
	id INTEGER NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion), 
	id_ VARCHAR(1) REFERENCES tviolencia NOT NULL,
	PRIMARY KEY (id, id_)
);


CREATE TABLE categoria (
	id INTEGER PRIMARY KEY,
	nombre VARCHAR(500) NOT NULL,
	fechacreacion	DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion),
	id_supracategoria INTEGER NOT NULL,
	id_ VARCHAR(1) NOT NULL REFERENCES tviolencia,
	col_rep_consolidado INTEGER REFERENCES parametros_reporte_consolidado (no_columna),
	contada_en INTEGER REFERENCES categoria,
	tipocat	CHAR DEFAULT 'I' CHECK (tipocat='I' OR tipocat='C' OR tipocat='O') ,
	FOREIGN KEY (id_supracategoria, id_) 
	REFERENCES supracategoria (id, id_)
);


CREATE TABLE tclase (
	id VARCHAR(3) PRIMARY KEY,
	nombre VARCHAR(500) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);


CREATE SEQUENCE departamento_seq;


CREATE TABLE departamento (
	id INTEGER PRIMARY KEY DEFAULT(nextval('departamento_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion	DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);


CREATE SEQUENCE municipio_seq;

CREATE TABLE municipio (
	id INTEGER NOT NULL DEFAULT(nextval('municipio_seq')),
	nombre VARCHAR(500) NOT NULL,
	id_departamento INTEGER NOT NULL REFERENCES departamento 
		ON DELETE CASCADE,
	fechacreacion	DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion),
	PRIMARY KEY (id, id_departamento)
);


CREATE SEQUENCE clase_seq;

CREATE TABLE clase (
	id INTEGER NOT NULL DEFAULT(nextval('clase_seq')),
	nombre VARCHAR(500) NOT NULL,
	id_municipio INTEGER,
	id_tipo_clase VARCHAR(3) REFERENCES tipoclase, 
	id_departamento INTEGER REFERENCES departamento ON DELETE CASCADE,
	fechacreacion	DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion),
	FOREIGN KEY (id_municipio, id_departamento) REFERENCES 
	municipio (id, id_departamento) ON DELETE CASCADE,
	PRIMARY KEY (id, id_municipio, id_departamento)
);


CREATE SEQUENCE contexto_seq;

CREATE TABLE contexto (
	id INTEGER PRIMARY KEY DEFAULT(nextval('contexto_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion	DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE etnia_seq;

CREATE TABLE etnia (
        id INTEGER PRIMARY KEY DEFAULT(nextval('etnia_seq')),
        nombre VARCHAR(200) NOT NULL,
        descripcion VARCHAR(1000),
	fechacreacion	DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE iglesia_seq;

CREATE TABLE iglesia (
    id INTEGER PRIMARY KEY DEFAULT(nextval('iglesia_seq')),
    nombre VARCHAR(200) NOT NULL,
    descripcion VARCHAR(1000),
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE filiacion_seq;

CREATE TABLE filiacion (
	id INTEGER PRIMARY KEY DEFAULT(nextval('filiacion_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE frontera_seq;

CREATE TABLE frontera (
	id INTEGER PRIMARY KEY DEFAULT(nextval('frontera_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE fotra_seq;

CREATE TABLE fotra (
	id INTEGER PRIMARY KEY DEFAULT(nextval('fotra_seq')),
	nombre VARCHAR(500) NOT NULL
);

CREATE SEQUENCE funcionario_seq;

-- Podria dejarse solo usuario con un campo para indicar que usuarios
-- pueden entrar en el momento y cuales ya no (?).
CREATE TABLE funcionario (
	id INTEGER PRIMARY KEY DEFAULT(nextval('funcionario_seq')),
	anotacion VARCHAR(50),
	nombre 	VARCHAR(15) NOT NULL UNIQUE
);

CREATE SEQUENCE organizacion_seq;

CREATE TABLE organizacion (
	id INTEGER PRIMARY KEY DEFAULT(nextval('organizacion_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE ffrecuente_seq;

CREATE TABLE ffrecuente (
	id INTEGER PRIMARY KEY DEFAULT(nextval('ffrecuente_seq')),
	nombre VARCHAR(500) NOT NULL,
	tipo_fuente VARCHAR(25) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE presponsable_seq;

CREATE TABLE presponsable (
	id INTEGER PRIMARY KEY DEFAULT(nextval('presponsable_seq')),
	nombre VARCHAR(500) NOT NULL,
	id_papa INTEGER REFERENCES presponsable,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE rangoedad_seq;

-- Deber�a tener edad inicia y edad final para poder chequear bien en
-- interfaz (ver PagVictimaIndividual).  Sobre nombre.
CREATE TABLE rangoedad ( 
	id INTEGER PRIMARY KEY DEFAULT(nextval('rangoedad_seq')),
	nombre VARCHAR(20) NOT NULL,
	rango VARCHAR(20) NOT NULL,
	limiteinferior INTEGER NOT NULL DEFAULT '0',
	limitesuperior INTEGER NOT NULL DEFAULT '0',
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE region_seq;

CREATE TABLE region (
	id INTEGER PRIMARY KEY DEFAULT(nextval('region_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)

); 

CREATE SEQUENCE resagresion_seq;

CREATE TABLE resagresion (
	id INTEGER PRIMARY KEY DEFAULT(nextval('resagresion_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
); 

CREATE SEQUENCE sectorsocial_seq;

CREATE TABLE sectorsocial (
	id INTEGER PRIMARY KEY DEFAULT(nextval('sectorsocial_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
); 

CREATE SEQUENCE tsitio_seq; 

CREATE TABLE tsitio (
	id INTEGER PRIMARY KEY DEFAULT(nextval('tsitio_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion	DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE ubicacion_seq;

CREATE TABLE ubicacion (
	id INTEGER PRIMARY KEY DEFAULT (nextval('ubicacion_seq')),
	lugar VARCHAR(260),
	sitio VARCHAR(260),
	id_clase INTEGER,
	id_municipio INTEGER,
	id_departamento INTEGER REFERENCES departamento,
	id_tipo_sitio INTEGER REFERENCES tsitio NOT NULL,
	id_caso INTEGER NOT NULL REFERENCES caso,
	latitud FLOAT,
	longitud FLOAT,

	FOREIGN KEY (id_municipio, id_departamento) REFERENCES
	municipio (id, id_departamento),
	FOREIGN KEY (id_clase, id_municipio, id_departamento) REFERENCES
	clase (id, id_municipio, id_departamento)
); 

CREATE TABLE usuario (
	id_usuario VARCHAR(15) PRIMARY KEY,
	password VARCHAR(64) NOT NULL,
	nombre VARCHAR(50),
	descripcion VARCHAR(50),
	id_rol INTEGER CHECK (id_rol>='1' AND id_rol<='4'),
	dias_edicion_caso INTEGER,
	idioma VARCHAR(6) NOT NULL DEFAULT 'es_CO'
);

CREATE SEQUENCE vinculoestado_seq;

CREATE TABLE vinculoestado (
	id INTEGER PRIMARY KEY DEFAULT(nextval('vinculo_estado_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);

CREATE SEQUENCE profesion_seq;

CREATE TABLE profesion (
	id INTEGER PRIMARY KEY DEFAULT(nextval('profesion_seq')),
	nombre VARCHAR(500) NOT NULL,
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);


CREATE SEQUENCE persona_seq;

CREATE TABLE persona (
	id INTEGER PRIMARY KEY DEFAULT(nextval('persona_seq')),
	nombres VARCHAR(100) NOT NULL,
	apellidos VARCHAR(100) NOT NULL,
	anionac         INTEGER,
	mesnac          INTEGER CHECK (mesnac IS NULL OR (mesnac>='1' AND mesnac<='12')),
	dianac          INTEGER CHECK (dianac IS NULL OR (dianac>='1' AND (((mesnac='1' OR mesnac='3' OR mesnac='5' OR mesnac='7' OR mesnac='8' OR mesnac='10' OR mesnac='12') AND dianac<='31')) OR ((mesnac='4' OR mesnac='6' OR mesnac='9' OR mesnac='11') AND dianac<='30') OR (mesnac='2' AND dianac<='29'))),
	sexo CHAR(1) NOT NULL CHECK (sexo='S' OR sexo='F' OR sexo='M'),
	id_departamento INTEGER REFERENCES departamento ON DELETE CASCADE,
	id_municipio    INTEGER,
	id_clase        INTEGER,
	-- Verificar en interfaz
	tipodocumento VARCHAR(2),
	numerodocumento VARCHAR(50)
);


CREATE TABLE trelacion (
	id      CHAR(2) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	dirigido BOOLEAN NOT NULL, ---false significa que persona2 tambi�n se re laciona con persona1 de la misma forma e.g papa ser�a true mientras que hermanos ser�a false.
	observaciones VARCHAR(200),
	fechacreacion DATE NOT NULL,
	fechadeshabilitacion DATE CHECK (fechadeshabilitacion IS NULL OR fechadeshabilitacion>=fechacreacion)
);


CREATE TABLE persona_trelacion (
	id_persona1 INTEGER NOT NULL REFERENCES persona,
	id_persona2 INTEGER NOT NULL REFERENCES persona,
	id_tipo CHAR(2) NOT NULL REFERENCES trelacion,
	observaciones VARCHAR(200),
	PRIMARY KEY(id_persona1, id_persona2, id_tipo)
);


-- Victima depende de caso.  Podr�a hacerse una tabla persona relacionada
-- con esta. 
CREATE TABLE victima (
	id_persona INTEGER REFERENCES persona NOT NULL,
	id_caso	INTEGER REFERENCES caso NOT NULL,
	hijos INTEGER CHECK (hijos IS NULL OR (hijos>='0' AND hijos<='100')),
	id_profesion INTEGER REFERENCES profesion NOT NULL,
	id_rango_edad INTEGER REFERENCES rangoedad NOT NULL,
	id_filiacion INTEGER REFERENCES filiacion NOT NULL,
	id_sector_social INTEGER REFERENCES sectorsocial NOT NULL,
	id_organizacion	INTEGER REFERENCES organizacion NOT NULL,
	id_vinculo_estado INTEGER REFERENCES vinculoestado NOT NULL,
	id_organizacion_armada INTEGER REFERENCES presponsable NOT NULL,
	anotaciones	VARCHAR(1000),
	id_etnia INTEGER REFERENCES etnia,
	id_iglesia INTEGER REFERENCES iglesia,
	orientacionsexual CHAR(1) NOT NULL DEFAULT 'H'
		CHECK (orientacionsexual='L' 
		OR orientacionsexual='G' 
		OR orientacionsexual='B'
	        OR orientacionsexual='T'
	        OR orientacionsexual='I'
	        OR orientacionsexual='H'
       	),
	PRIMARY KEY(id_persona, id_caso)
);

CREATE SEQUENCE grupoper_seq;

CREATE TABLE grupoper (
	id INTEGER PRIMARY KEY DEFAULT(nextval('grupoper_seq')),
	nombre VARCHAR(150) NOT NULL,
	anotaciones VARCHAR(1000)
);

CREATE TABLE victimacolectiva (
	id_grupoper INTEGER REFERENCES grupoper,
	id_caso INTEGER REFERENCES caso,
	personas_aprox INTEGER,
	id_organizacion_armada INTEGER REFERENCES presponsable,
	PRIMARY KEY(id_grupoper, id_caso)
);

CREATE TABLE vinculoestado_comunidad (
	id_vinculo_estado INTEGER REFERENCES vinculoestado,
	id_grupoper INTEGER REFERENCES grupoper,
	id_caso INTEGER REFERENCES caso,
	FOREIGN KEY (id_grupoper, id_caso) REFERENCES victimacolectiva(id_grupoper, id_caso),
	PRIMARY KEY(id_vinculo_estado, id_grupoper, id_caso)
);

CREATE TABLE comunidad_profesion (
	id_profesion INTEGER REFERENCES profesion,
	id_grupoper INTEGER REFERENCES grupoper,
	id_caso INTEGER REFERENCES caso,
	FOREIGN KEY (id_grupoper, id_caso) REFERENCES victimacolectiva(id_grupoper, id_caso),
	PRIMARY KEY(id_profesion, id_grupoper, id_caso)
);


CREATE TABLE antecedente_caso (
	id_antecedente INTEGER REFERENCES antecedente,
	id_caso INTEGER REFERENCES caso,
	PRIMARY KEY(id_antecedente, id_caso)
);

-- Los antecedentes de la victima no deben ser subconjunto de los del caso
CREATE TABLE antecedente_victima (
	id_antecedente INTEGER REFERENCES antecedente,
	id_persona INTEGER NOT NULL REFERENCES persona,
	id_caso INTEGER NOT NULL REFERENCES caso,
	FOREIGN KEY(id_persona, id_caso) REFERENCES 
	victima (id_persona, id_caso),

	PRIMARY KEY(id_antecedente, id_persona, id_caso)
);

-- Si se quisieran reusan victimas_colectivas tal vez esta tabla
-- deber�a tener id_caso
CREATE TABLE antecedente_comunidad (
	id_antecedente INTEGER REFERENCES antecedente,
	id_grupoper INTEGER REFERENCES grupoper,
	id_caso INTEGER REFERENCES caso,
	FOREIGN KEY (id_grupoper, id_caso) REFERENCES victimacolectiva(id_grupoper, id_caso),
	PRIMARY KEY(id_antecedente, id_grupoper, id_caso)
);


-- Por uniformidad mejor llamarlo contexto_caso
CREATE TABLE caso_contexto (
	id_caso INTEGER REFERENCES caso,
	id_contexto INTEGER REFERENCES contexto,
	PRIMARY KEY(id_caso, id_contexto)
);

CREATE TABLE presponsable_caso (
	id_caso INTEGER REFERENCES caso,
	id_p_responsable INTEGER REFERENCES presponsable,
	tipo	INTEGER	NOT NULL,
	bloque	VARCHAR(50),
	frente	VARCHAR(50),
	brigada	VARCHAR(50),
	batallon VARCHAR(50),
	division VARCHAR(50),
	otro VARCHAR(500),
	id INTEGER NOT NULL,
	PRIMARY KEY (id_caso, id_p_responsable, id)
);


CREATE TABLE categoria_presponsable_caso (
	id_ VARCHAR(1) REFERENCES tviolencia,
	id_supracategoria INTEGER,
	id_categoria INTEGER REFERENCES categoria, 
	--En interfaz verificar que categoria es de tipocat Otra ('O')
	id INTEGER NOT NULL,
	id_caso INTEGER REFERENCES caso,
	id_p_responsable INTEGER REFERENCES presponsable,
	PRIMARY KEY(id_, id_supracategoria, id_categoria,
		id, id_caso, id_p_responsable),
	FOREIGN KEY (id_supracategoria, id_) 
	REFERENCES supracategoria (id, id_),
	FOREIGN KEY (id, id_caso, id_p_responsable)
	REFERENCES presponsable_caso (id, id_caso, 
		id_p_responsable)
);


-- Algunos campos ubicaci�n, clasificacion y ubicacion_fisica son NULL (no pueden ser llave).
-- Puede mejorarse clasificacion, para que est� relacionada con clasificacion
-- del caso
CREATE TABLE caso_ffrecuente (
	fecha DATE,
	ubicacion VARCHAR(100),  -- En interfaz descripci�n p�gina
	clasificacion VARCHAR(100), -- Categoria que esta fuente clasifica 
	ubicacion_fisica VARCHAR(100),
	id_prensa INTEGER REFERENCES ffrecuente,
	id_caso	INTEGER REFERENCES caso,
	PRIMARY KEY(fecha, id_prensa,id_caso)
);

CREATE TABLE comunidad_filiacion (
	id_filiacion INTEGER REFERENCES filiacion,
	id_grupoper INTEGER REFERENCES grupoper,
	id_caso INTEGER REFERENCES caso,
	FOREIGN KEY (id_grupoper, id_caso) REFERENCES victimacolectiva(id_grupoper, id_caso),
	PRIMARY KEY(id_filiacion, id_grupoper, id_caso)
);

CREATE TABLE caso_frontera (
	id_frontera INTEGER REFERENCES frontera,
	id_caso INTEGER REFERENCES caso,
	PRIMARY KEY(id_frontera, id_caso)
);

-- Tambien hay fuentes indirectas (pero no frecuentes).
CREATE TABLE caso_fotra (
	id_caso INTEGER REFERENCES caso,
	id_fuente_directa INTEGER REFERENCES fotra,
	anotacion VARCHAR(200),
	fecha DATE,
	ubicacion_fisica VARCHAR(100),
	tipo_fuente VARCHAR(25),
	PRIMARY KEY(id_caso, id_fuente_directa, fecha)
);

CREATE TABLE caso_funcionario (
	id_funcionario INTEGER REFERENCES funcionario,
	id_caso INTEGER REFERENCES caso,
	fecha_inicio DATE,
	PRIMARY KEY(id_funcionario, id_caso)
);

CREATE TABLE comunidad_organizacion (
	id_organizacion INTEGER REFERENCES organizacion,
	id_grupoper INTEGER REFERENCES grupoper,
	id_caso INTEGER REFERENCES caso,
	FOREIGN KEY (id_grupoper, id_caso) REFERENCES victimacolectiva(id_grupoper, id_caso),
	PRIMARY KEY(id_organizacion, id_grupoper, id_caso)
);

-- id_rango_edad en lugar de id_rango
CREATE TABLE comunidad_rangoedad (
	id_rango INTEGER REFERENCES rangoedad,
	id_grupoper INTEGER REFERENCES grupoper,
	id_caso INTEGER REFERENCES caso,
	FOREIGN KEY (id_grupoper, id_caso) REFERENCES victimacolectiva(id_grupoper, id_caso),
	PRIMARY KEY(id_rango, id_grupoper, id_caso)
);


CREATE TABLE caso_region (
	id_region INTEGER REFERENCES region,
	id_caso INTEGER REFERENCES caso,
	PRIMARY KEY(id_region, id_caso)
);


CREATE TABLE comunidad_sectorsocial (
	id_sector INTEGER REFERENCES sectorsocial,
	id_grupoper INTEGER REFERENCES grupoper,
	id_caso INTEGER REFERENCES caso,
	FOREIGN KEY (id_grupoper, id_caso) REFERENCES victimacolectiva(id_grupoper, id_caso),
	PRIMARY KEY(id_sector, id_grupoper, id_caso)
);


CREATE TABLE acto (
	id_p_responsable INTEGER REFERENCES presponsable,
	id_categoria INTEGER REFERENCES categoria,
	id_persona INTEGER REFERENCES persona,
	id_caso INTEGER REFERENCES caso,
	FOREIGN KEY (id_persona, id_caso) REFERENCES 
	victima(id_persona, id_caso),
	PRIMARY KEY(id_p_responsable, id_categoria, id_persona, id_caso)
);

CREATE TABLE actocolectivo (
	id_p_responsable INTEGER REFERENCES presponsable,
	id_categoria INTEGER REFERENCES categoria,
	id_grupoper INTEGER REFERENCES grupoper,
	id_caso INTEGER REFERENCES caso,
	FOREIGN KEY (id_grupoper, id_caso) REFERENCES victimacolectiva(id_grupoper, id_caso),
	PRIMARY KEY(id_p_responsable, id_categoria, id_grupoper, id_caso)
);


