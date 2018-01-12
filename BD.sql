DROP DATABASE `cetpro`;

CREATE DATABASE `cetpro`;

USE `cetpro`;

CREATE TABLE `departamento`
(
	`iddepartamento`	INT(6)		NOT NULL AUTO_INCREMENT,
	`nombre`		VARCHAR(13)	COLLATE utf8_unicode_ci NOT NULL,
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0 
PRIMARY KEY (`iddepartamento`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `provincia`
(
	`idprovincia`		INT(6)		NOT NULL AUTO_INCREMENT,
	`iddepartamento`	INT(6)		NOT NULL,
	`nombre`		VARCHAR(25)	COLLATE utf8_unicode_ci NOT NULL,
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0  
PRIMARY KEY (`idprovincia`),
CONSTRAINT `iddepartamento_fk_pro` FOREIGN KEY (`iddepartamento`) REFERENCES `departamento`(`iddepartamento`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `distrito`
(
	`iddistrito`		INT(6)		NOT NULL AUTO_INCREMENT,
	`idprovincia`		INT(6)		NOT NULL,
	`nombre`		VARCHAR(36)	COLLATE utf8_unicode_ci NOT NULL,
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0  
PRIMARY KEY (`iddistrito`),
CONSTRAINT `idprovincia_fk_dis` FOREIGN KEY (`idprovincia`) REFERENCES `provincia`(`idprovincia`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `persona`
(
	`idpersona`		INT(6)		NOT NULL AUTO_INCREMENT,
	`iddistrito`		INT(6)		NOT NULL,
	`nombres`		VARCHAR(30)	COLLATE utf8_unicode_ci NOT NULL,
	`apellidopa`		VARCHAR(20)	COLLATE utf8_unicode_ci NOT NULL,
	`apellidoma`		VARCHAR(20)	COLLATE utf8_unicode_ci NOT NULL,
	`fecha_nacimiento`	DATE 		NOT NULL, 				-- YYYY-MM-DD 
	`sexo`			CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- F,M 
	`dni`			VARCHAR(8)	COLLATE utf8_unicode_ci NOT NULL, 	-- modificado 
	`telefono`		VARCHAR(9)	COLLATE utf8_unicode_ci NOT NULL, 	-- para evitar errores de ingreso
	`correo`		NVARCHAR(30)	COLLATE utf8_unicode_ci NULL,
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0 
PRIMARY KEY (`idpersona`),
CONSTRAINT `iddistrito_fk_per` FOREIGN KEY (`iddistrito`) REFERENCES `distrito`(`iddistrito`),
CONSTRAINT `persona_uk_per` UNIQUE (`nombres`,`apellidopa`,`apellidoma`),
CONSTRAINT `dni_uk_per` UNIQUE (`dni`),
CONSTRAINT `telefono_uk_per` UNIQUE (`telefono`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `personal`
(
	`idpersonal`		INT(6)		NOT NULL AUTO_INCREMENT,
	`idpersona`		INT(6)		NOT NULL,
	`cargo`			VARCHAR(13)	COLLATE utf8_unicode_ci NOT NULL, 	-- secretaria, director, administrador, docente 
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0 
PRIMARY KEY (`idpersonal`),
CONSTRAINT `idpersona_fk_psl` FOREIGN KEY (`idpersona`) REFERENCES `persona`(`idpersona`),
CONSTRAINT `persona_uk_psl` UNIQUE (`idpersona`,`cargo`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `usuario`
(
	`idusuario`		INT(6)		NOT NULL AUTO_INCREMENT,
	`idpersonal`		INT(6)		NOT NULL,
	`usuario`		NVARCHAR(10)	COLLATE utf8_unicode_ci NOT NULL,
	`contrasenia`		NVARCHAR(15)	COLLATE utf8_unicode_ci NOT NULL,
	`tipo`			CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- a = registra, modifica y verifica a la informacion, b = crea usuarios y edita todo 
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0  
PRIMARY KEY (`idusuario`),
CONSTRAINT `idpersonal_fk_usu` FOREIGN KEY (`idpersonal`) REFERENCES `personal`(`idpersonal`),
CONSTRAINT `idpersonal_uk_usu` UNIQUE (`idpersonal`),
CONSTRAINT `usuario_uk_usu` UNIQUE (`usuario`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `alumno`
(
	`idalumno`		INT(6)		NOT NULL AUTO_INCREMENT,
	`idpersona` 		INT(6)		NOT NULL,
	`iddistrito`		INT(6)		COLLATE utf8_unicode_ci NOT NULL, 	-- lugar donde nacio o lugar de nacimiento
	`descripcion`		VARCHAR(100)	COLLATE utf8_unicode_ci NOT NULL, 	-- cursos interesados
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- e = espera, 1 = activo ,0 = eliminado 
PRIMARY KEY (`idalumno`),
CONSTRAINT `idpersona_fk_alu` FOREIGN KEY (`idpersona`) REFERENCES `persona`(`idpersona`),
CONSTRAINT `iddistrito_fk_alu` FOREIGN KEY (`iddistrito`) REFERENCES `distrito`(`iddistrito`),
CONSTRAINT `idpersona_uk_alu` UNIQUE (`idpersona`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `curso`
(
	`idcurso`		INT(6)		NOT NULL AUTO_INCREMENT,
	`nombre` 		VARCHAR(30)	COLLATE utf8_unicode_ci NOT NULL,	-- nombre del curso
	`ciclo`			VARCHAR(10)	COLLATE utf8_unicode_ci NOT NULL,	-- basico, intermedio, avanzado
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0  
PRIMARY KEY (`idcurso`),
CONSTRAINT `nombre_uk_cur` UNIQUE (`nombre`,`ciclo`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `capacidad_terminal`
(
	`idcapacidad`		INT(6)		NOT NULL AUTO_INCREMENT,
	`idcurso`		INT(6)		NOT NULL,
	`nombre`		VARCHAR(45)	COLLATE utf8_unicode_ci NOT NULL,	-- nombre de la capacidad terminal
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL,
PRIMARY KEY (`idcapacidad`),
CONSTRAINT `idcurso_fk_cap` FOREIGN KEY (`idcurso`) REFERENCES `curso`(`idcurso`),
CONSTRAINT `nombre_uk_cap` UNIQUE (`idcurso`,`nombre`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `pago`
(
	`idpago`		INT(6)		NOT NULL AUTO_INCREMENT,
	`idpersonal`		INT(6)		NOT NULL,
	`cantidad`		DECIMAL(6,2)	COLLATE utf8_unicode_ci NOT NULL, 	-- 1000.20 
	`forma` 		VARCHAR(11)	COLLATE utf8_unicode_ci NOT NULL, 	-- efectivo, cheque, transacción 
	`fecha`			DATE 		NOT NULL, 				-- YYYY-MM-DD 
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0 
PRIMARY KEY (`idpago`),
CONSTRAINT `idpersonal_fk_pag` FOREIGN KEY (`idpersonal`) REFERENCES `personal`(`idpersonal`),
CONSTRAINT `fecha_uk_pag` UNIQUE (`idpersonal`,`fecha`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `horario`
(
	`idhorario`		INT(6)		NOT NULL AUTO_INCREMENT,
	`r_d_`			VARCHAR(15)	COLLATE utf8_unicode_ci NOT NULL,	-- N°XXXX-YY
	`r_d_r_`		VARCHAR(15)	COLLATE utf8_unicode_ci NOT NULL,	-- N°XXXX-YY
	`aula`			CHAR(2)		COLLATE utf8_unicode_ci NOT NULL,	-- A1, A2
	`imagen`		LONGBLOB 	NULL,					-- imagen del horario, por mientras es null
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL,	-- 1,0
PRIMARY KEY (`idhorario`)-- la imagen debe ser el unique para evitar que se registre 2 veces el mismo dato y debe ser not null
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/* update horario set 
	r_d_ = 'N°1064-01',
	r_d_r_ = 'N°1416-06',
	aula = 'A2',
	imagen = 'VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw',
	estado = '1'
where idhorario = 2;
						
select * from horario; */ 

CREATE TABLE `grupo`
(
	`idgrupo`		INT(6)		NOT NULL AUTO_INCREMENT,
	`idcurso`		INT(6)		NOT NULL,
	`idpersonal`		INT(6)		NOT NULL,
	`resolucion_modulo`	VARCHAR(15)	COLLATE utf8_unicode_ci NOT NULL,	-- N°XXXXX-YYYY
	`anio`			YEAR 		COLLATE utf8_unicode_ci NOT NULL, 	-- 2015 - 2016 - 2017 - YYYY
	`turno`			VARCHAR(6)	COLLATE utf8_unicode_ci NOT NULL,	-- mañana, tarde, noche 
	`seccion`		VARCHAR(5)	COLLATE utf8_unicode_ci NOT NULL,	-- única, a, b, c, etc. 
	`duracion`		VARCHAR(4)	COLLATE utf8_unicode_ci NOT NULL,	-- 180h, 200h, 300h  
	`fecha_inicio`		DATE 		NOT NULL, 				-- YYYY-MM-DD 
	`fecha_fin`		DATE 		NOT NULL, 				-- YYYY-MM-DD
	`idhorario`		INT(6)		NOT NULL,
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0 
PRIMARY KEY (`idgrupo`),
CONSTRAINT `idcurso_fk_gru` FOREIGN KEY (`idcurso`) REFERENCES `curso`(`idcurso`),
CONSTRAINT `idpersonal_fk_gru` FOREIGN KEY (`idpersonal`) REFERENCES `personal`(`idpersonal`),
CONSTRAINT `idhorario_fk_gru` FOREIGN KEY (`idhorario`) REFERENCES `horario`(`idhorario`),
CONSTRAINT `curso_uk_gru` UNIQUE (`idcurso`,`resolucion_modulo`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `matricula`
(
	`idmatricula`		INT(6)		NOT NULL AUTO_INCREMENT,
	`idalumno`		INT(6)		NOT NULL,
	`idgrupo`		INT(6)		NOT NULL,
	`codigo_inscripcion`	VARCHAR(15)	COLLATE utf8_unicode_ci NULL,		-- XXXXXXXXXXXX-YY 
	`edad`			INT(2)		COLLATE utf8_unicode_ci NOT NULL,	-- XX 
	`direccion` 		NVARCHAR(100)	COLLATE utf8_unicode_ci NOT NULL,
	`ocupacion` 		VARCHAR(20)	COLLATE utf8_unicode_ci NOT NULL, 	-- empleado, desempleado, Estudiante 
	`trabaja`		CHAR(2)		COLLATE utf8_unicode_ci NOT NULL,	-- si, no  
	`estado_civil`		VARCHAR(10)	COLLATE utf8_unicode_ci NOT NULL, 	-- soltero, casado, viudo, divorciado   
	`fecha` 		DATE 		NOT NULL, 				-- YYYY-MM-DD 
	`condicion`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL,	-- G = Gratuito, P = Pagante, B = Becario 
	`estado`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0 
PRIMARY KEY (`idmatricula`),
CONSTRAINT `idalumno_fk_mat` FOREIGN KEY (`idalumno`) REFERENCES `alumno`(`idalumno`),
CONSTRAINT `idgrupo_fk_mat` FOREIGN KEY (`idgrupo`) REFERENCES `grupo`(`idgrupo`),
CONSTRAINT `alumno_uk_mat` UNIQUE (`idalumno`,`idgrupo`),
CONSTRAINT `codigo_inscripcion_uk_mat` UNIQUE (`codigo_inscripcion`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `recibo_pago`
(
	`idrecibo`		INT(6)		NOT NULL AUTO_INCREMENT,
	`idmatricula`		INT(6)		NOT NULL,
	`numero_boleta`		VARCHAR(6)	COLLATE utf8_unicode_ci NOT NULL, 	-- numero de la boleta de venta  
	`cantidad`		DECIMAL(5,2)	COLLATE utf8_unicode_ci NOT NULL, 	-- 100.00 
	`concepto`		VARCHAR(11)	COLLATE utf8_unicode_ci NOT NULL,	-- matricula, pagoN, certificado
	`fecha` 		DATE 		NOT NULL, 				-- YYYY-MM-DD 
	`estado`  		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0 
PRIMARY KEY (`idrecibo`),
CONSTRAINT `idmatricula_fk_rec` FOREIGN KEY (`idmatricula`) REFERENCES `matricula`(`idmatricula`),
CONSTRAINT `concepto_uk_rec` UNIQUE (`idmatricula`,`concepto`),
CONSTRAINT `numero_boleta_uk_rec` UNIQUE (`numero_boleta`) 
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `nota`
(
	`idnota`		INT(6)		NOT NULL AUTO_INCREMENT,
	`idcapacidad`		INT(6)		NOT NULL,
	`idmatricula`		INT(6)		NOT NULL,
	`nota`			INT(2)		COLLATE utf8_unicode_ci NOT NULL, 	-- 01 o 20 
	`fecha` 		DATE 		NOT NULL, 				-- YYYY-MM-DD 
	`estado`		CHAR(1) 	COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0  
PRIMARY KEY (`idnota`),
CONSTRAINT `idcapacidad_fk_not` FOREIGN KEY (`idcapacidad`) REFERENCES `capacidad_terminal`(`idcapacidad`),
CONSTRAINT `idmatricula_fk_not` FOREIGN KEY (`idmatricula`) REFERENCES `matricula`(`idmatricula`),
CONSTRAINT `concepto_uk_not` UNIQUE (`idcapacidad`,`idmatricula`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `certificado`
(
	`idcertificado`		INT(6)		NOT NULL AUTO_INCREMENT,
	`idmatricula`		INT(6)		NOT NULL,
	`situacion`		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL,	-- A = aprobado, D = desaprobado, R = retirado
	`numero_registro`	CHAR(9)		COLLATE utf8_unicode_ci NOT NULL, 	-- 0000-YYYY 
	`imagen`		LONGBLOB 	NULL,					-- la imagen escaneada del certificado
	`estado` 		CHAR(1)		COLLATE utf8_unicode_ci NOT NULL, 	-- 1,0 
PRIMARY KEY (`idcertificado`),
CONSTRAINT `idmatricula_fk_cer` FOREIGN KEY (`idmatricula`) REFERENCES `matricula`(`idmatricula`),
CONSTRAINT `matricula_uk_cer` UNIQUE (`idmatricula`),
CONSTRAINT `numero_registro_uk_cer` UNIQUE (`numero_registro`)
)ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- Departamentos del Perú

INSERT INTO departamento VALUES ('1','Amazonas','1');
INSERT INTO departamento VALUES ('2','Áncash','1');
INSERT INTO departamento VALUES ('3','Apurímac','1');
INSERT INTO departamento VALUES ('4','Arequipa','1');
INSERT INTO departamento VALUES ('5','Ayacucho','1');
INSERT INTO departamento VALUES ('6','Cajamarca','1');
INSERT INTO departamento VALUES ('7','Cusco','1');
INSERT INTO departamento VALUES ('8','Huancavelica','1');
INSERT INTO departamento VALUES ('9','Huánuco','1');
INSERT INTO departamento VALUES ('10','Ica','1');
INSERT INTO departamento VALUES ('11','Junín','1');
INSERT INTO departamento VALUES ('12','La Libertad','1');
INSERT INTO departamento VALUES ('13','Lambayeque','1');
INSERT INTO departamento VALUES ('14','Lima','1');
INSERT INTO departamento VALUES ('15','Loreto','1');
INSERT INTO departamento VALUES ('16','Madre de Dios','1');
INSERT INTO departamento VALUES ('17','Moquegua','1');
INSERT INTO departamento VALUES ('18','Pasco','1');
INSERT INTO departamento VALUES ('19','Piura','1');
INSERT INTO departamento VALUES ('20','Puno','1');
INSERT INTO departamento VALUES ('21','San Martín','1');
INSERT INTO departamento VALUES ('22','Tacna','1');
INSERT INTO departamento VALUES ('23','Tumbes','1');
INSERT INTO departamento VALUES ('24','Ucayali','1');

-- Provincias del Perú

-- Amazonas
INSERT INTO provincia VALUES ('1','1','Chachapoyas','1');
INSERT INTO provincia VALUES ('2','1','Bagua','1');
INSERT INTO provincia VALUES ('3','1','Bongará','1');
INSERT INTO provincia VALUES ('4','1','Condorcanqui','1');
INSERT INTO provincia VALUES ('5','1','Luya','1');
INSERT INTO provincia VALUES ('6','1','Rodríguez de Mendoza','1');
INSERT INTO provincia VALUES ('7','1','Utcubamba','1');

-- Áncash
INSERT INTO provincia VALUES ('8','2','Huaraz','1');
INSERT INTO provincia VALUES ('9','2','Aija','1');
INSERT INTO provincia VALUES ('10','2','Antonio Raymondi','1');
INSERT INTO provincia VALUES ('11','2','Asunción','1');
INSERT INTO provincia VALUES ('12','2','Bolognesi','1');
INSERT INTO provincia VALUES ('13','2','Carhuaz','1');
INSERT INTO provincia VALUES ('14','2','Carlos Fermín Fitzcarrald','1');
INSERT INTO provincia VALUES ('15','2','Casma','1');
INSERT INTO provincia VALUES ('16','2','Corongo','1');
INSERT INTO provincia VALUES ('17','2','Huari','1');
INSERT INTO provincia VALUES ('18','2','Huarmey','1');
INSERT INTO provincia VALUES ('19','2','Huaylas','1');
INSERT INTO provincia VALUES ('20','2','Mariscal Luzuriaga','1');
INSERT INTO provincia VALUES ('21','2','Ocros','1');
INSERT INTO provincia VALUES ('22','2','Pallasca','1');
INSERT INTO provincia VALUES ('23','2','Pomabamba','1');
INSERT INTO provincia VALUES ('24','2','Recuay','1');
INSERT INTO provincia VALUES ('25','2','Santa','1');
INSERT INTO provincia VALUES ('26','2','Sihuas','1');
INSERT INTO provincia VALUES ('27','2','Yungay','1');

-- Apurímac
INSERT INTO provincia VALUES ('28','3','Abancay','1');
INSERT INTO provincia VALUES ('29','3','Andahuaylas','1');
INSERT INTO provincia VALUES ('30','3','Antabamba','1');
INSERT INTO provincia VALUES ('31','3','Aymaraes','1');
INSERT INTO provincia VALUES ('32','3','Cotabambas','1');
INSERT INTO provincia VALUES ('33','3','Chincheros','1');
INSERT INTO provincia VALUES ('34','3','Grau','1');

-- Arequipa
INSERT INTO provincia VALUES ('35','4','Arequipa','1');
INSERT INTO provincia VALUES ('36','4','Camaná','1');
INSERT INTO provincia VALUES ('37','4','Caravelí','1');
INSERT INTO provincia VALUES ('38','4','Castilla','1');
INSERT INTO provincia VALUES ('39','4','Caylloma','1');
INSERT INTO provincia VALUES ('40','4','Condesuyos','1');
INSERT INTO provincia VALUES ('41','4','Islay','1');
INSERT INTO provincia VALUES ('42','4','La Unión','1');

-- Ayacucho
INSERT INTO provincia VALUES ('43','5','Huamanga','1');
INSERT INTO provincia VALUES ('44','5','Cangallo','1');
INSERT INTO provincia VALUES ('45','5','Huanca Sancos','1');
INSERT INTO provincia VALUES ('46','5','Huanta','1');
INSERT INTO provincia VALUES ('47','5','La Mar','1');
INSERT INTO provincia VALUES ('48','5','Lucanas','1');
INSERT INTO provincia VALUES ('49','5','Parinacochas','1');
INSERT INTO provincia VALUES ('50','5','Páucar del Sara Sara','1');
INSERT INTO provincia VALUES ('51','5','Sucre','1');
INSERT INTO provincia VALUES ('52','5','Víctor Fajardo','1');
INSERT INTO provincia VALUES ('53','5','Vilcas Huamán','1');

-- Cajamarca
INSERT INTO provincia VALUES ('54','6','Cajamarca','1');
INSERT INTO provincia VALUES ('55','6','Cajabamba','1');
INSERT INTO provincia VALUES ('56','6','Celendín','1');
INSERT INTO provincia VALUES ('57','6','Chota','1');
INSERT INTO provincia VALUES ('58','6','Contumazá','1');
INSERT INTO provincia VALUES ('59','6','Cutervo','1');
INSERT INTO provincia VALUES ('60','6','Hualgayoc','1');
INSERT INTO provincia VALUES ('61','6','Jaén','1');
INSERT INTO provincia VALUES ('62','6','San Ignacio','1');
INSERT INTO provincia VALUES ('63','6','San Marcos','1');
INSERT INTO provincia VALUES ('64','6','San Miguel','1');
INSERT INTO provincia VALUES ('65','6','San Pablo','1');
INSERT INTO provincia VALUES ('66','6','Santa Cruz','1');

-- Cusco
INSERT INTO provincia VALUES ('67','7','Cusco','1');
INSERT INTO provincia VALUES ('68','7','Acomayo','1');
INSERT INTO provincia VALUES ('69','7','Anta','1');
INSERT INTO provincia VALUES ('70','7','Calca','1');
INSERT INTO provincia VALUES ('71','7','Canas','1');
INSERT INTO provincia VALUES ('72','7','Canchis','1');
INSERT INTO provincia VALUES ('73','7','Chumbivilcas','1');
INSERT INTO provincia VALUES ('74','7','Espinar','1');
INSERT INTO provincia VALUES ('75','7','La Convención','1');
INSERT INTO provincia VALUES ('76','7','Paruro','1');
INSERT INTO provincia VALUES ('77','7','Paucartambo','1');
INSERT INTO provincia VALUES ('78','7','Quispicanchi','1');
INSERT INTO provincia VALUES ('79','7','Urubamba','1');

-- Huancavelica
INSERT INTO provincia VALUES ('80','8','Huancavelica','1');
INSERT INTO provincia VALUES ('81','8','Acobamba','1');
INSERT INTO provincia VALUES ('82','8','Angaraes','1');
INSERT INTO provincia VALUES ('83','8','Castrovirreyna','1');
INSERT INTO provincia VALUES ('84','8','Churcampa','1');
INSERT INTO provincia VALUES ('85','8','Huaytará','1');
INSERT INTO provincia VALUES ('86','8','Tayacaja','1');

-- Huánuco
INSERT INTO provincia VALUES ('87','9','Huánuco','1');
INSERT INTO provincia VALUES ('88','9','Ambo','1');
INSERT INTO provincia VALUES ('89','9','Dos de Mayo','1');
INSERT INTO provincia VALUES ('90','9','Huacaybamba','1');
INSERT INTO provincia VALUES ('91','9','Huamalíes','1');
INSERT INTO provincia VALUES ('92','9','Leoncio Prado','1');
INSERT INTO provincia VALUES ('93','9','Marañón','1');
INSERT INTO provincia VALUES ('94','9','Pachitea','1');
INSERT INTO provincia VALUES ('95','9','Puerto Inca','1');
INSERT INTO provincia VALUES ('96','9','Lauricocha','1');
INSERT INTO provincia VALUES ('97','9','Yarowilca','1');

-- Ica
INSERT INTO provincia VALUES ('98','10','Ica','1');
INSERT INTO provincia VALUES ('99','10','Chincha','1');
INSERT INTO provincia VALUES ('100','10','Nazca','1');
INSERT INTO provincia VALUES ('101','10','Palpa','1');
INSERT INTO provincia VALUES ('102','10','Pisco','1');

-- Junín
INSERT INTO provincia VALUES ('103','11','Huancayo','1');
INSERT INTO provincia VALUES ('104','11','Concepción','1');
INSERT INTO provincia VALUES ('105','11','Chanchamayo','1');
INSERT INTO provincia VALUES ('106','11','Jauja','1');
INSERT INTO provincia VALUES ('107','11','Junín','1');
INSERT INTO provincia VALUES ('108','11','Satipo','1');
INSERT INTO provincia VALUES ('109','11','Tarma','1');
INSERT INTO provincia VALUES ('110','11','Yauli','1');
INSERT INTO provincia VALUES ('111','11','Chupaca','1');

-- La Libertad
INSERT INTO provincia VALUES ('112','12','Trujillo','1');
INSERT INTO provincia VALUES ('113','12','Ascope','1');
INSERT INTO provincia VALUES ('114','12','Bolívar','1');
INSERT INTO provincia VALUES ('115','12','Chepén','1');
INSERT INTO provincia VALUES ('116','12','Julcán','1');
INSERT INTO provincia VALUES ('117','12','Otuzco','1');
INSERT INTO provincia VALUES ('118','12','Pacasmayo','1');
INSERT INTO provincia VALUES ('119','12','Pataz','1');
INSERT INTO provincia VALUES ('120','12','Sánchez Carrión','1');
INSERT INTO provincia VALUES ('121','12','Santiago de Chuco','1');
INSERT INTO provincia VALUES ('122','12','Gran Chimú','1');
INSERT INTO provincia VALUES ('123','12','Virú','1');

-- Lambayeque
INSERT INTO provincia VALUES ('124','13','Chiclayo','1');
INSERT INTO provincia VALUES ('125','13','Ferreñafe','1');
INSERT INTO provincia VALUES ('126','13','Lambayeque','1');

-- Lima
INSERT INTO provincia VALUES ('127','14','Lima','1');
INSERT INTO provincia VALUES ('128','14','Barranca','1');
INSERT INTO provincia VALUES ('129','14','Cajatambo','1');
INSERT INTO provincia VALUES ('130','14','Canta','1');
INSERT INTO provincia VALUES ('131','14','Callao','1');
INSERT INTO provincia VALUES ('132','14','Cañete','1');
INSERT INTO provincia VALUES ('133','14','Huaral','1');
INSERT INTO provincia VALUES ('134','14','Huarochirí','1');
INSERT INTO provincia VALUES ('135','14','Huaura','1');
INSERT INTO provincia VALUES ('136','14','Oyón','1');
INSERT INTO provincia VALUES ('137','14','Yauyos','1');

-- Loreto
INSERT INTO provincia VALUES ('138','15','Maynas','1');
INSERT INTO provincia VALUES ('139','15','Alto Amazonas','1');
INSERT INTO provincia VALUES ('140','15','Loreto','1');
INSERT INTO provincia VALUES ('141','15','Mariscal Ramón Castilla','1');
INSERT INTO provincia VALUES ('142','15','Requema','1');
INSERT INTO provincia VALUES ('143','15','Ucayali','1');
INSERT INTO provincia VALUES ('144','15','Datem del Marañón','1');
INSERT INTO provincia VALUES ('145','15','Putumayo','1');

-- Madre de Dios
INSERT INTO provincia VALUES ('146','16','Tambopata','1');
INSERT INTO provincia VALUES ('147','16','Manu','1');
INSERT INTO provincia VALUES ('148','16','Tahuamanu','1');

-- Moquegua
INSERT INTO provincia VALUES ('149','17','Mariscal Nieto','1');
INSERT INTO provincia VALUES ('150','17','General Sánchez Cerro','1');
INSERT INTO provincia VALUES ('151','17','Ilo','1');

-- Pasco
INSERT INTO provincia VALUES ('152','18','Pasco','1');
INSERT INTO provincia VALUES ('153','18','Daniel Alcides Carrión','1');
INSERT INTO provincia VALUES ('154','18','Oxapampa','1');

-- Piura
INSERT INTO provincia VALUES ('155','19','Piura','1');
INSERT INTO provincia VALUES ('156','19','Ayabaca','1');
INSERT INTO provincia VALUES ('157','19','Huancabamba','1');
INSERT INTO provincia VALUES ('158','19','Morropón','1');
INSERT INTO provincia VALUES ('159','19','Paita','1');
INSERT INTO provincia VALUES ('160','19','Sullana','1');
INSERT INTO provincia VALUES ('161','19','Talara','1');
INSERT INTO provincia VALUES ('162','19','Sechura','1');

-- Puno
INSERT INTO provincia VALUES ('163','20','Puno','1');
INSERT INTO provincia VALUES ('164','20','Azángaro','1');
INSERT INTO provincia VALUES ('165','20','Carabaya','1');
INSERT INTO provincia VALUES ('166','20','Chucuito','1');
INSERT INTO provincia VALUES ('167','20','El Collao','1');
INSERT INTO provincia VALUES ('168','20','Huancané','1');
INSERT INTO provincia VALUES ('169','20','Lampa','1');
INSERT INTO provincia VALUES ('170','20','Melgar','1');
INSERT INTO provincia VALUES ('171','20','Moho','1');
INSERT INTO provincia VALUES ('172','20','San Antonio de Putina','1');
INSERT INTO provincia VALUES ('173','20','San Román','1');
INSERT INTO provincia VALUES ('174','20','Sandia','1');
INSERT INTO provincia VALUES ('175','20','Yunguyo','1');

-- San Martín
INSERT INTO provincia VALUES ('176','21','Moyobamba','1');
INSERT INTO provincia VALUES ('177','21','Bellavista','1');
INSERT INTO provincia VALUES ('178','21','El Dorado','1');
INSERT INTO provincia VALUES ('179','21','Huallaga','1');
INSERT INTO provincia VALUES ('180','21','Lamas','1');
INSERT INTO provincia VALUES ('181','21','Mariscal Cáceres','1');
INSERT INTO provincia VALUES ('182','21','Picota','1');
INSERT INTO provincia VALUES ('183','21','Rioja','1');
INSERT INTO provincia VALUES ('184','21','San Martín','1');
INSERT INTO provincia VALUES ('185','21','Tocache','1');

-- Tacna
INSERT INTO provincia VALUES ('186','22','Tacna','1');
INSERT INTO provincia VALUES ('187','22','Candarave','1');
INSERT INTO provincia VALUES ('188','22','Jorge Basadre','1');
INSERT INTO provincia VALUES ('189','22','Tarata','1');

-- Tumbes
INSERT INTO provincia VALUES ('190','23','Tumbes','1');
INSERT INTO provincia VALUES ('191','23','Contralmirante Villar','1');
INSERT INTO provincia VALUES ('192','23','Zarumilla','1');

-- Ucayali
INSERT INTO provincia VALUES ('193','24','Coronel Portillo','1');
INSERT INTO provincia VALUES ('194','24','Atalaya','1');
INSERT INTO provincia VALUES ('195','24','Padre Abad','1');
INSERT INTO provincia VALUES ('196','24','Purús','1');

-- Distritos del Perú

-- Amazonas - Chachapoyas (1)
INSERT INTO distrito VALUES ('1','1','Chachapoyas','1');
INSERT INTO distrito VALUES ('2','1','Asunción','1');
INSERT INTO distrito VALUES ('3','1','Balsas','1');
INSERT INTO distrito VALUES ('4','1','Cheto','1');
INSERT INTO distrito VALUES ('5','1','Chiliquin','1');
INSERT INTO distrito VALUES ('6','1','Chuquibamba','1');
INSERT INTO distrito VALUES ('7','1','Granada','1');
INSERT INTO distrito VALUES ('8','1','Huancas','1');
INSERT INTO distrito VALUES ('9','1','La Jalca','1');
INSERT INTO distrito VALUES ('10','1','Leimebamba','1');
INSERT INTO distrito VALUES ('11','1','Levanto','1');
INSERT INTO distrito VALUES ('12','1','Magdalena','1');
INSERT INTO distrito VALUES ('13','1','Mariscal Castilla','1');
INSERT INTO distrito VALUES ('14','1','Molinopampa','1');
INSERT INTO distrito VALUES ('15','1','Montevideo','1');
INSERT INTO distrito VALUES ('16','1','Olleros','1');
INSERT INTO distrito VALUES ('17','1','Quinjalca','1');
INSERT INTO distrito VALUES ('18','1','San Francisco de Daguas','1');
INSERT INTO distrito VALUES ('19','1','San Isidro de Maino','1');
INSERT INTO distrito VALUES ('20','1','Soloco','1');
INSERT INTO distrito VALUES ('21','1','Sonche','1');
-- Amazonas - Bagua (2)
INSERT INTO distrito VALUES ('22','2','Bagua','1');
INSERT INTO distrito VALUES ('23','2','Aramango','1');
INSERT INTO distrito VALUES ('24','2','Copallin','1');
INSERT INTO distrito VALUES ('25','2','El Parco','1');
INSERT INTO distrito VALUES ('26','2','Imaza','1');
INSERT INTO distrito VALUES ('27','2','La Peca','1');
-- Amazonas - Bongará (3)
INSERT INTO distrito VALUES ('28','3','Jumbilla','1');
INSERT INTO distrito VALUES ('29','3','Chisquilla','1');
INSERT INTO distrito VALUES ('30','3','Churuja','1');
INSERT INTO distrito VALUES ('31','3','Corosha','1');
INSERT INTO distrito VALUES ('32','3','Quispes','1');
INSERT INTO distrito VALUES ('33','3','Florida','1');
INSERT INTO distrito VALUES ('34','3','Jazan','1');
INSERT INTO distrito VALUES ('35','3','Recta','1');
INSERT INTO distrito VALUES ('36','3','San Carlos','1');
INSERT INTO distrito VALUES ('37','3','Shipasbamba','1');
INSERT INTO distrito VALUES ('38','3','Valera','1');
INSERT INTO distrito VALUES ('39','3','Yambrasbamba','1');
-- Amazonas - Condorcanqui (4)
INSERT INTO distrito VALUES ('40','4','Nieva','1');
INSERT INTO distrito VALUES ('41','4','El Cenepa','1');
INSERT INTO distrito VALUES ('42','4','Río Santiago','1');
-- Amazonas - Luya (5)
INSERT INTO distrito VALUES ('43','5','Lamud','1');
INSERT INTO distrito VALUES ('44','5','Camporredondo','1');
INSERT INTO distrito VALUES ('45','5','Cocabamba','1');
INSERT INTO distrito VALUES ('46','5','Colcamar','1');
INSERT INTO distrito VALUES ('47','5','Conila','1');
INSERT INTO distrito VALUES ('48','5','Inguilpata','1');
INSERT INTO distrito VALUES ('49','5','Longuita','1');
INSERT INTO distrito VALUES ('50','5','Lonya Chico','1');
INSERT INTO distrito VALUES ('51','5','Luya','1');
INSERT INTO distrito VALUES ('52','5','Luya Viejo','1');
INSERT INTO distrito VALUES ('53','5','María','1');
INSERT INTO distrito VALUES ('54','5','Ocalli','1');
INSERT INTO distrito VALUES ('55','5','Ocumal','1');
INSERT INTO distrito VALUES ('56','5','Pisuquia','1');
INSERT INTO distrito VALUES ('57','5','Providencia','1');
INSERT INTO distrito VALUES ('58','5','San Cristóbal','1');
INSERT INTO distrito VALUES ('59','5','San Francisco de Yeso','1');
INSERT INTO distrito VALUES ('60','5','San Jerónimo','1');
INSERT INTO distrito VALUES ('61','5','San Juan de Lopecancha','1');
INSERT INTO distrito VALUES ('62','5','Santa Catalina','1');
INSERT INTO distrito VALUES ('63','5','Santo Tomas','1');
INSERT INTO distrito VALUES ('64','5','Tingo','1');
INSERT INTO distrito VALUES ('65','5','Trita','1');
-- Amazonas - Rodríguez de Mendoza (6)
INSERT INTO distrito VALUES ('66','6','San Nicolás','1');
INSERT INTO distrito VALUES ('67','6','Chirimoto','1');
INSERT INTO distrito VALUES ('68','6','Cochamal','1');
INSERT INTO distrito VALUES ('69','6','Huambo','1');
INSERT INTO distrito VALUES ('70','6','Limabamba','1');
INSERT INTO distrito VALUES ('71','6','Longar','1');
INSERT INTO distrito VALUES ('72','6','Mariscal Benavides','1');
INSERT INTO distrito VALUES ('73','6','Milpuc','1');
INSERT INTO distrito VALUES ('74','6','Omia','1');
INSERT INTO distrito VALUES ('75','6','Santa Rosa','1');
INSERT INTO distrito VALUES ('76','6','Totora','1');
INSERT INTO distrito VALUES ('77','6','Vista Alegre','1');
-- Amazonas - Utcubamba (7)
INSERT INTO distrito VALUES ('78','7','Bagua Grande','1');
INSERT INTO distrito VALUES ('79','7','Cajaruro','1');
INSERT INTO distrito VALUES ('80','7','Cumba','1');
INSERT INTO distrito VALUES ('81','7','El Milagro','1');
INSERT INTO distrito VALUES ('82','7','Jamalca','1');
INSERT INTO distrito VALUES ('83','7','Lonya Grande','1');
INSERT INTO distrito VALUES ('84','7','Yamon','1');

-- Áncash - Huaraz (8)
INSERT INTO distrito VALUES ('85','8','Huaraz','1');
INSERT INTO distrito VALUES ('86','8','Cochabamba','1');
INSERT INTO distrito VALUES ('87','8','Colcabamba','1');
INSERT INTO distrito VALUES ('88','8','Huanchay','1');
INSERT INTO distrito VALUES ('89','8','Independencia','1');
INSERT INTO distrito VALUES ('90','8','Jangas','1');
INSERT INTO distrito VALUES ('91','8','La Libertad','1');
INSERT INTO distrito VALUES ('92','8','Olleros','1');
INSERT INTO distrito VALUES ('93','8','Pampas Grande','1');
INSERT INTO distrito VALUES ('94','8','Pariacoto','1');
INSERT INTO distrito VALUES ('95','8','Pira','1');
INSERT INTO distrito VALUES ('96','8','Tarica','1');
-- Áncash - Aija (9)
INSERT INTO distrito VALUES ('97','9','Aija','1');
INSERT INTO distrito VALUES ('98','9','Coris','1');
INSERT INTO distrito VALUES ('99','9','Huacllan','1');
INSERT INTO distrito VALUES ('100','9','La Merced','1');
INSERT INTO distrito VALUES ('101','9','Succha','1');
-- Áncash - Antonio Raymondi (10)
INSERT INTO distrito VALUES ('102','10','Llamellin','1');
INSERT INTO distrito VALUES ('103','10','Aczo','1');
INSERT INTO distrito VALUES ('104','10','Chaccho','1');
INSERT INTO distrito VALUES ('105','10','Chingas','1');
INSERT INTO distrito VALUES ('106','10','Mirgas','1');
INSERT INTO distrito VALUES ('107','10','San Juan de Rontoy','1');
-- Áncash - Asunción (11)
INSERT INTO distrito VALUES ('108','11','Chacas','1');
INSERT INTO distrito VALUES ('109','11','Acochaca','1');
-- Áncash - Bolognesi (12)
INSERT INTO distrito VALUES ('110','12','Chiquian','1');
INSERT INTO distrito VALUES ('111','12','Abelardo Pardo Lezameta','1');
INSERT INTO distrito VALUES ('112','12','Antonio Raymondi','1');
INSERT INTO distrito VALUES ('113','12','Aquia','1');
INSERT INTO distrito VALUES ('114','12','Cajacay','1');
INSERT INTO distrito VALUES ('115','12','Canis','1');
INSERT INTO distrito VALUES ('116','12','Colquioc','1');
INSERT INTO distrito VALUES ('117','12','Huallanca','1');
INSERT INTO distrito VALUES ('118','12','Huasta','1');
INSERT INTO distrito VALUES ('119','12','Huayllacayan','1');
INSERT INTO distrito VALUES ('120','12','La Primavera','1');
INSERT INTO distrito VALUES ('121','12','Mangas','1');
INSERT INTO distrito VALUES ('122','12','Pacllon','1');
INSERT INTO distrito VALUES ('123','12','San Miguel de Corpanqui','1');
INSERT INTO distrito VALUES ('124','12','Ticllos','1');
-- Áncash - Carhuaz (13)
INSERT INTO distrito VALUES ('125','13','Carhuaz','1');
INSERT INTO distrito VALUES ('126','13','Acopampa','1');
INSERT INTO distrito VALUES ('127','13','Amashca','1');
INSERT INTO distrito VALUES ('128','13','Anta','1');
INSERT INTO distrito VALUES ('129','13','Ataquero','1');
INSERT INTO distrito VALUES ('130','13','Marcara','1');
INSERT INTO distrito VALUES ('131','13','Parihuanca','1');
INSERT INTO distrito VALUES ('132','13','San Miguel de Aco','1');
INSERT INTO distrito VALUES ('133','13','Shilla','1');
INSERT INTO distrito VALUES ('134','13','Tinco','1');
INSERT INTO distrito VALUES ('135','13','Yungar','1');
-- Áncash - Carlos Fermín Fitzcarrald (14)
INSERT INTO distrito VALUES ('136','14','San Luis','1');
INSERT INTO distrito VALUES ('137','14','San Nicolás','1');
INSERT INTO distrito VALUES ('138','14','Yauya','1');
-- Áncash - Casma (15)
INSERT INTO distrito VALUES ('139','15','Casma','1');
INSERT INTO distrito VALUES ('140','15','Buena Vista Alta','1');
INSERT INTO distrito VALUES ('141','15','Comandante Noel','1');
INSERT INTO distrito VALUES ('142','15','Yautan','1');
-- Áncash - Corongo (16)
INSERT INTO distrito VALUES ('143','16','Corongo','1');
INSERT INTO distrito VALUES ('144','16','Aco','1');
INSERT INTO distrito VALUES ('145','16','Bambas','1');
INSERT INTO distrito VALUES ('146','16','Cusca','1');
INSERT INTO distrito VALUES ('147','16','La Pampa','1');
INSERT INTO distrito VALUES ('148','16','Yanac','1');
INSERT INTO distrito VALUES ('149','16','Yupan','1');
-- Áncash - Huari (17)
INSERT INTO distrito VALUES ('150','17','Huari','1');
INSERT INTO distrito VALUES ('151','17','Anra','1');
INSERT INTO distrito VALUES ('152','17','Cajay','1');
INSERT INTO distrito VALUES ('153','17','Chavin de Huantar','1');
INSERT INTO distrito VALUES ('154','17','Huacachi','1');
INSERT INTO distrito VALUES ('155','17','Huacchis','1');
INSERT INTO distrito VALUES ('156','17','Huachis','1');
INSERT INTO distrito VALUES ('157','17','Huantar','1');
INSERT INTO distrito VALUES ('158','17','Masin','1');
INSERT INTO distrito VALUES ('159','17','Paucas','1');
INSERT INTO distrito VALUES ('160','17','Ponto','1');
INSERT INTO distrito VALUES ('161','17','Rahuapampa','1');
INSERT INTO distrito VALUES ('162','17','Rapayan','1');
INSERT INTO distrito VALUES ('163','17','San Marcos','1');
INSERT INTO distrito VALUES ('164','17','San Pedro de Chana','1');
INSERT INTO distrito VALUES ('165','17','Uco','1');
-- Áncash - Huarmey (18)
INSERT INTO distrito VALUES ('166','18','Huarmey','1');
INSERT INTO distrito VALUES ('167','18','Cochapeti','1');
INSERT INTO distrito VALUES ('168','18','Culebras','1');
INSERT INTO distrito VALUES ('169','18','Huayan','1');
INSERT INTO distrito VALUES ('170','18','Malvas','1');
-- Áncash - Huaylas (19)
INSERT INTO distrito VALUES ('171','19','Caraz','1');
INSERT INTO distrito VALUES ('172','19','Huallanca','1');
INSERT INTO distrito VALUES ('173','19','Huata','1');
INSERT INTO distrito VALUES ('174','19','Huaylas','1');
INSERT INTO distrito VALUES ('175','19','Mato','1');
INSERT INTO distrito VALUES ('176','19','Pamparomas','1');
INSERT INTO distrito VALUES ('177','19','Pueblo Libre','1');
INSERT INTO distrito VALUES ('178','19','Santa Cruz','1');
INSERT INTO distrito VALUES ('179','19','Santo Toribio','1');
INSERT INTO distrito VALUES ('180','19','Yuracmarca','1');
-- Áncash - Mariscal Luzuriaga (20)
INSERT INTO distrito VALUES ('181','20','Piscobamba','1');
INSERT INTO distrito VALUES ('182','20','Casca','1');
INSERT INTO distrito VALUES ('183','20','Eleazar Guzmán Barron','1');
INSERT INTO distrito VALUES ('184','20','Fidel Olivas Escudero','1');
INSERT INTO distrito VALUES ('185','20','Llama','1');
INSERT INTO distrito VALUES ('186','20','Llumpa','1');
INSERT INTO distrito VALUES ('187','20','Lucma','1');
INSERT INTO distrito VALUES ('188','20','Musga','1');
-- Áncash - Ocros (21)
INSERT INTO distrito VALUES ('189','21','Ocros','1');
INSERT INTO distrito VALUES ('190','21','Acas','1');
INSERT INTO distrito VALUES ('191','21','Cajamarquilla','1');
INSERT INTO distrito VALUES ('192','21','Carhuapampa','1');
INSERT INTO distrito VALUES ('193','21','Cochas','1');
INSERT INTO distrito VALUES ('194','21','Congas','1');
INSERT INTO distrito VALUES ('195','21','Llipa','1');
INSERT INTO distrito VALUES ('196','21','San Cristóbal de Rajan','1');
INSERT INTO distrito VALUES ('197','21','San Pedro','1');
INSERT INTO distrito VALUES ('198','21','Santiago de Chilcas','1');
-- Áncash - Pallasca (22)
INSERT INTO distrito VALUES ('199','22','Cabana','1');
INSERT INTO distrito VALUES ('200','22','Bolognesi','1');
INSERT INTO distrito VALUES ('201','22','Conchucos','1');
INSERT INTO distrito VALUES ('202','22','Huacaschuque','1');
INSERT INTO distrito VALUES ('203','22','Huandoval','1');
INSERT INTO distrito VALUES ('204','22','Lacabamba','1');
INSERT INTO distrito VALUES ('205','22','Llapo','1');
INSERT INTO distrito VALUES ('206','22','Pallasca','1');
INSERT INTO distrito VALUES ('207','22','Pampas','1');
INSERT INTO distrito VALUES ('208','22','Santa Rosa','1');
INSERT INTO distrito VALUES ('209','22','Tauca','1');
-- Áncash - Pomabamba (23)
INSERT INTO distrito VALUES ('210','23','Pomabamba','1');
INSERT INTO distrito VALUES ('211','23','Huayllan','1');
INSERT INTO distrito VALUES ('212','23','Parobamba','1');
INSERT INTO distrito VALUES ('213','23','Quinuabamba','1');
-- Áncash - Recuay (24)
INSERT INTO distrito VALUES ('214','24','Recuay','1');
INSERT INTO distrito VALUES ('215','24','Catac','1');
INSERT INTO distrito VALUES ('216','24','Cotaparaco','1');
INSERT INTO distrito VALUES ('217','24','Huayllapampa','1');
INSERT INTO distrito VALUES ('218','24','Llacllin','1');
INSERT INTO distrito VALUES ('219','24','Marca','1');
INSERT INTO distrito VALUES ('220','24','Pampas Chico','1');
INSERT INTO distrito VALUES ('221','24','Pararin','1');
INSERT INTO distrito VALUES ('222','24','Tapacocha','1');
INSERT INTO distrito VALUES ('223','24','Ticapampa','1');
-- Áncash - Santa (25)
INSERT INTO distrito VALUES ('224','25','Chimbote','1');
INSERT INTO distrito VALUES ('225','25','Cáceres del Perú','1');
INSERT INTO distrito VALUES ('226','25','Coishco','1');
INSERT INTO distrito VALUES ('227','25','Macate','1');
INSERT INTO distrito VALUES ('228','25','Moro','1');
INSERT INTO distrito VALUES ('229','25','Nepeña','1');
INSERT INTO distrito VALUES ('230','25','Samanco','1');
INSERT INTO distrito VALUES ('231','25','Santa','1');
INSERT INTO distrito VALUES ('232','25','Nuevo Chimbote','1');
-- Áncash - Sihuas (26)
INSERT INTO distrito VALUES ('233','26','Sihuas','1');
INSERT INTO distrito VALUES ('234','26','Acobamba','1');
INSERT INTO distrito VALUES ('235','26','Alfonso Ugarte','1');
INSERT INTO distrito VALUES ('236','26','Cashapampa','1');
INSERT INTO distrito VALUES ('237','26','Chingalpo','1');
INSERT INTO distrito VALUES ('238','26','Huayllabamba','1');
INSERT INTO distrito VALUES ('239','26','Quiches','1');
INSERT INTO distrito VALUES ('240','26','Ragash','1');
INSERT INTO distrito VALUES ('241','26','San Juan','1');
INSERT INTO distrito VALUES ('242','26','Sicsibamba','1');
-- Áncash - Yungay (27)
INSERT INTO distrito VALUES ('243','27','Yungay','1');
INSERT INTO distrito VALUES ('244','27','Cascapara','1');
INSERT INTO distrito VALUES ('245','27','Mancos','1');
INSERT INTO distrito VALUES ('246','27','Matacoto','1');
INSERT INTO distrito VALUES ('247','27','Quillo','1');
INSERT INTO distrito VALUES ('248','27','Ranrahirca','1');
INSERT INTO distrito VALUES ('249','27','Shupluy','1');
INSERT INTO distrito VALUES ('250','27','Yanama','1');

-- Apurímac - Abancay (28)
INSERT INTO distrito VALUES ('251','28','Abancay','1');
INSERT INTO distrito VALUES ('252','28','Chacoche','1');
INSERT INTO distrito VALUES ('253','28','Circa','1');
INSERT INTO distrito VALUES ('254','28','Curahuasi','1');
INSERT INTO distrito VALUES ('255','28','Huanipaca','1');
INSERT INTO distrito VALUES ('256','28','Lambrama','1');
INSERT INTO distrito VALUES ('257','28','Pichirhua','1');
INSERT INTO distrito VALUES ('258','28','San Pedro de Cachora','1');
INSERT INTO distrito VALUES ('259','28','Tamburco','1');
-- Apurímac - Andahuaylas (29)
INSERT INTO distrito VALUES ('260','29','Andahuaylas','1');
INSERT INTO distrito VALUES ('261','29','Andarapa','1');
INSERT INTO distrito VALUES ('262','29','Chiara','1');
INSERT INTO distrito VALUES ('263','29','Huancarama','1');
INSERT INTO distrito VALUES ('264','29','Huancaray','1');
INSERT INTO distrito VALUES ('265','29','Huayana','1');
INSERT INTO distrito VALUES ('266','29','Kishuara','1');
INSERT INTO distrito VALUES ('267','29','Pacobamba','1');
INSERT INTO distrito VALUES ('268','29','Pacucha','1');
INSERT INTO distrito VALUES ('269','29','Pampachiri','1');
INSERT INTO distrito VALUES ('270','29','Pomacocha','1');
INSERT INTO distrito VALUES ('271','29','San Antonio de Cachi','1');
INSERT INTO distrito VALUES ('272','29','San Jerónimo','1');
INSERT INTO distrito VALUES ('273','29','San Miguel de Chaccrampa','1');
INSERT INTO distrito VALUES ('274','29','Santa María de Chicmo','1');
INSERT INTO distrito VALUES ('275','29','Talavera','1');
INSERT INTO distrito VALUES ('276','29','Tumay Huaraca','1');
INSERT INTO distrito VALUES ('277','29','Turpo','1');
INSERT INTO distrito VALUES ('278','29','Kaquiabamba','1');
INSERT INTO distrito VALUES ('279','29','José María Arguedas','1');
-- Apurímac - Antabamba (30)
INSERT INTO distrito VALUES ('280','30','Antabamba','1');
INSERT INTO distrito VALUES ('281','30','El Oro','1');
INSERT INTO distrito VALUES ('282','30','Huaquirca','1');
INSERT INTO distrito VALUES ('283','30','Juan Espinoza Medrano','1');
INSERT INTO distrito VALUES ('284','30','Oropesa','1');
INSERT INTO distrito VALUES ('285','30','Pachaconas','1');
INSERT INTO distrito VALUES ('286','30','Sabaino','1');
-- Apurímac - Aymaraes (31)
INSERT INTO distrito VALUES ('287','31','Chalhuanca','1');
INSERT INTO distrito VALUES ('288','31','Capaya','1');
INSERT INTO distrito VALUES ('289','31','Caraybamba','1');
INSERT INTO distrito VALUES ('290','31','Chapimarca','1');
INSERT INTO distrito VALUES ('291','31','Colcabamba','1');
INSERT INTO distrito VALUES ('292','31','Cotaruse','1');
INSERT INTO distrito VALUES ('293','31','Huayllo','1');
INSERT INTO distrito VALUES ('294','31','Justo Apu Sahuaraura','1');
INSERT INTO distrito VALUES ('295','31','Lucre','1');
INSERT INTO distrito VALUES ('296','31','Pocohuanca','1');
INSERT INTO distrito VALUES ('297','31','San Juan de Chacña','1');
INSERT INTO distrito VALUES ('298','31','Sañayca','1');
INSERT INTO distrito VALUES ('299','31','Sorayca','1');
INSERT INTO distrito VALUES ('300','31','Tapairihua','1');
INSERT INTO distrito VALUES ('301','31','Tintay','1');
INSERT INTO distrito VALUES ('302','31','Toraya','1');
INSERT INTO distrito VALUES ('303','31','Yanaca','1');
-- Apurímac - Cotabambas (32)
INSERT INTO distrito VALUES ('304','32','Tambobamba','1');
INSERT INTO distrito VALUES ('305','32','Cotabambas','1');
INSERT INTO distrito VALUES ('306','32','Coyllurqui','1');
INSERT INTO distrito VALUES ('307','32','Haquira','1');
INSERT INTO distrito VALUES ('308','32','Mara','1');
INSERT INTO distrito VALUES ('309','32','Challhuahuacho','1');
-- Apurímac - Chincheros (33)
INSERT INTO distrito VALUES ('310','33','Chincheros','1');
INSERT INTO distrito VALUES ('311','33','Anco Huallo','1');
INSERT INTO distrito VALUES ('312','33','Cocharcas','1');
INSERT INTO distrito VALUES ('313','33','Huaccana','1');
INSERT INTO distrito VALUES ('314','33','Ocobamba','1');
INSERT INTO distrito VALUES ('315','33','Ongoy','1');
INSERT INTO distrito VALUES ('316','33','Uranmarca','1');
INSERT INTO distrito VALUES ('317','33','Ranracancha','1');
-- Apurímac - Grau (34)
INSERT INTO distrito VALUES ('318','34','Chuquibambilla','1');
INSERT INTO distrito VALUES ('319','34','Curpahuasi','1');
INSERT INTO distrito VALUES ('320','34','Gamarra','1');
INSERT INTO distrito VALUES ('321','34','Huayllati','1');
INSERT INTO distrito VALUES ('322','34','Mamara','1');
INSERT INTO distrito VALUES ('323','34','Micaela Bastidas','1');
INSERT INTO distrito VALUES ('324','34','Pataypampa','1');
INSERT INTO distrito VALUES ('325','34','Progreso','1');
INSERT INTO distrito VALUES ('326','34','San Antonio','1');
INSERT INTO distrito VALUES ('327','34','Santa Rosa','1');
INSERT INTO distrito VALUES ('328','34','Turpay','1');
INSERT INTO distrito VALUES ('329','34','Vilcabamba','1');
INSERT INTO distrito VALUES ('330','34','Virundo','1');
INSERT INTO distrito VALUES ('331','34','Curasco','1');

-- Arequipa - Arequipa (35)
INSERT INTO distrito VALUES ('332','35','Arequipa','1');
INSERT INTO distrito VALUES ('333','35','Alto Selva Alegre','1');
INSERT INTO distrito VALUES ('334','35','Cayma','1');
INSERT INTO distrito VALUES ('335','35','Cerro Colorado','1');
INSERT INTO distrito VALUES ('336','35','Characato','1');
INSERT INTO distrito VALUES ('337','35','Chiguata','1');
INSERT INTO distrito VALUES ('338','35','Jacobo Hunter','1');
INSERT INTO distrito VALUES ('339','35','La Joya','1');
INSERT INTO distrito VALUES ('340','35','Mariano Melgar','1');
INSERT INTO distrito VALUES ('341','35','Miraflores','1');
INSERT INTO distrito VALUES ('342','35','Mollebaya','1');
INSERT INTO distrito VALUES ('343','35','Paucarpata','1');
INSERT INTO distrito VALUES ('344','35','Pocsi','1');
INSERT INTO distrito VALUES ('345','35','Polobaya','1');
INSERT INTO distrito VALUES ('346','35','Quequeña','1');
INSERT INTO distrito VALUES ('347','35','Sabandia','1');
INSERT INTO distrito VALUES ('348','35','Sachaca','1');
INSERT INTO distrito VALUES ('349','35','San Juan de Siguas','1');
INSERT INTO distrito VALUES ('350','35','San Juan de Tarucani','1');
INSERT INTO distrito VALUES ('351','35','Santa Isabel de Siguas','1');
INSERT INTO distrito VALUES ('352','35','Santa Rita de Siguas','1');
INSERT INTO distrito VALUES ('353','35','Socabaya','1');
INSERT INTO distrito VALUES ('354','35','Tiabaya','1');
INSERT INTO distrito VALUES ('355','35','Uchumayo','1');
INSERT INTO distrito VALUES ('356','35','Vitor','1');
INSERT INTO distrito VALUES ('357','35','Yanahuara','1');
INSERT INTO distrito VALUES ('358','35','Yarabamba','1');
INSERT INTO distrito VALUES ('359','35','Yura','1');
INSERT INTO distrito VALUES ('360','35','José Luis Bustamante y Rivero','1');
-- Arequipa - Camaná (36)
INSERT INTO distrito VALUES ('361','36','Camaná','1');
INSERT INTO distrito VALUES ('362','36','José María Quimper','1');
INSERT INTO distrito VALUES ('363','36','Mariano Nicolás Valcárcel','1');
INSERT INTO distrito VALUES ('364','36','Mariscal Cáceres','1');
INSERT INTO distrito VALUES ('365','36','Nicolás de Pierola','1');
INSERT INTO distrito VALUES ('366','36','Ocoña','1');
INSERT INTO distrito VALUES ('367','36','Quilca','1');
INSERT INTO distrito VALUES ('368','36','Samuel Pastor','1');
-- Arequipa - Caravelí (37)
INSERT INTO distrito VALUES ('369','37','Caravelí','1');
INSERT INTO distrito VALUES ('370','37','Acarí','1');
INSERT INTO distrito VALUES ('371','37','Atico','1');
INSERT INTO distrito VALUES ('372','37','Atiquipa','1');
INSERT INTO distrito VALUES ('373','37','Bella Unión','1');
INSERT INTO distrito VALUES ('374','37','Cahuacho','1');
INSERT INTO distrito VALUES ('375','37','Chala','1');
INSERT INTO distrito VALUES ('376','37','Chaparra','1');
INSERT INTO distrito VALUES ('377','37','Huanuhuanu','1');
INSERT INTO distrito VALUES ('378','37','Jaqui','1');
INSERT INTO distrito VALUES ('379','37','Lomas','1');
INSERT INTO distrito VALUES ('380','37','Quicacha','1');
INSERT INTO distrito VALUES ('381','37','Yauca','1');
-- Arequipa - Castilla (38)
INSERT INTO distrito VALUES ('382','38','Aplao','1');
INSERT INTO distrito VALUES ('383','38','Andagua','1');
INSERT INTO distrito VALUES ('384','38','Ayo','1');
INSERT INTO distrito VALUES ('385','38','Chachas','1');
INSERT INTO distrito VALUES ('386','38','Chilcaymarca','1');
INSERT INTO distrito VALUES ('387','38','Choco','1');
INSERT INTO distrito VALUES ('388','38','Huancarqui','1');
INSERT INTO distrito VALUES ('389','38','Machaguay','1');
INSERT INTO distrito VALUES ('390','38','Orcopampa','1');
INSERT INTO distrito VALUES ('391','38','Pampacolca','1');
INSERT INTO distrito VALUES ('392','38','Tipan','1');
INSERT INTO distrito VALUES ('393','38','Uñon','1');
INSERT INTO distrito VALUES ('394','38','Uraca','1');
INSERT INTO distrito VALUES ('395','38','Viraco','1');
-- Arequipa - Caylloma (39)
INSERT INTO distrito VALUES ('396','39','Chivay','1');
INSERT INTO distrito VALUES ('397','39','Achoma','1');
INSERT INTO distrito VALUES ('398','39','Cabanaconde','1');
INSERT INTO distrito VALUES ('399','39','Callalli','1');
INSERT INTO distrito VALUES ('400','39','Caylloma','1');
INSERT INTO distrito VALUES ('401','39','Coporaque','1');
INSERT INTO distrito VALUES ('402','39','Huambo','1');
INSERT INTO distrito VALUES ('403','39','Huanca','1');
INSERT INTO distrito VALUES ('404','39','Ichupampa','1');
INSERT INTO distrito VALUES ('405','39','Lari','1');
INSERT INTO distrito VALUES ('406','39','Lluta','1');
INSERT INTO distrito VALUES ('407','39','Maca','1');
INSERT INTO distrito VALUES ('408','39','Madrigal','1');
INSERT INTO distrito VALUES ('409','39','San Antonio de Chuca','1');
INSERT INTO distrito VALUES ('410','39','Sibayo','1');
INSERT INTO distrito VALUES ('411','39','Tapay','1');
INSERT INTO distrito VALUES ('412','39','Tisco','1');
INSERT INTO distrito VALUES ('413','39','Tuti','1');
INSERT INTO distrito VALUES ('414','39','Yanque','1');
INSERT INTO distrito VALUES ('415','39','Majes','1');
-- Arequipa - Condesuyos (40)
INSERT INTO distrito VALUES ('416','40','Chuquibamba','1');
INSERT INTO distrito VALUES ('417','40','Andaray','1');
INSERT INTO distrito VALUES ('418','40','Cayarani','1');
INSERT INTO distrito VALUES ('419','40','Chichas','1');
INSERT INTO distrito VALUES ('420','40','Iray','1');
INSERT INTO distrito VALUES ('421','40','Río Grande','1');
INSERT INTO distrito VALUES ('422','40','Salamanca','1');
INSERT INTO distrito VALUES ('423','40','Yanaquihua','1');
-- Arequipa - Islay (41)
INSERT INTO distrito VALUES ('424','41','Mollendo','1');
INSERT INTO distrito VALUES ('425','41','Cocachacra','1');
INSERT INTO distrito VALUES ('426','41','Dean Valdivia','1');
INSERT INTO distrito VALUES ('427','41','Islay','1');
INSERT INTO distrito VALUES ('428','41','Mejia','1');
INSERT INTO distrito VALUES ('429','41','Punta de Bombón','1');
-- Arequipa - La Unión (42)
INSERT INTO distrito VALUES ('430','42','Cotahuasi','1');
INSERT INTO distrito VALUES ('431','42','Alca','1');
INSERT INTO distrito VALUES ('432','42','Charcana','1');
INSERT INTO distrito VALUES ('433','42','Huaynacotas','1');
INSERT INTO distrito VALUES ('434','42','Pampamarca','1');
INSERT INTO distrito VALUES ('435','42','Puyca','1');
INSERT INTO distrito VALUES ('436','42','Quechualla','1');
INSERT INTO distrito VALUES ('437','42','Sayla','1');
INSERT INTO distrito VALUES ('438','42','Tauria','1');
INSERT INTO distrito VALUES ('439','42','Tomepampa','1');
INSERT INTO distrito VALUES ('440','42','Toro','1');

-- Ayacucho - Huamanga (43)
INSERT INTO distrito VALUES ('441','43','Ayacucho','1');
INSERT INTO distrito VALUES ('442','43','Acocro','1');
INSERT INTO distrito VALUES ('443','43','Acos Vinchos','1');
INSERT INTO distrito VALUES ('444','43','Carmen Alto','1');
INSERT INTO distrito VALUES ('445','43','Chiara','1');
INSERT INTO distrito VALUES ('446','43','Ocros','1');
INSERT INTO distrito VALUES ('447','43','Pacaycasa','1');
INSERT INTO distrito VALUES ('448','43','Quinua','1');
INSERT INTO distrito VALUES ('449','43','San José de Ticllas','1');
INSERT INTO distrito VALUES ('450','43','San Juan Bautista','1');
INSERT INTO distrito VALUES ('451','43','Santiago de Pischa','1');
INSERT INTO distrito VALUES ('452','43','Socos','1');
INSERT INTO distrito VALUES ('453','43','Tambillo','1');
INSERT INTO distrito VALUES ('454','43','Vinchos','1');
INSERT INTO distrito VALUES ('455','43','Jesús Nazareno','1');
INSERT INTO distrito VALUES ('456','43','Andrés Avelino Cáceres','1');
-- Ayacucho - Cangallo (44)
INSERT INTO distrito VALUES ('457','44','Cangallo','1');
INSERT INTO distrito VALUES ('458','44','Chuschi','1');
INSERT INTO distrito VALUES ('459','44','Los Morochucos','1');
INSERT INTO distrito VALUES ('460','44','María Parado de Bellido','1');
INSERT INTO distrito VALUES ('461','44','Paras','1');
INSERT INTO distrito VALUES ('462','44','Totos','1');
-- Ayacucho - Huanca Sancos (45)
INSERT INTO distrito VALUES ('463','45','Sancos','1');
INSERT INTO distrito VALUES ('464','45','Carapo','1');
INSERT INTO distrito VALUES ('465','45','Sacsamarca','1');
INSERT INTO distrito VALUES ('466','45','Santiago de Lucanamarca','1');
-- Ayacucho - Huanta (46)
INSERT INTO distrito VALUES ('467','46','Huanta','1');
INSERT INTO distrito VALUES ('468','46','Ayahuanco','1');
INSERT INTO distrito VALUES ('469','46','Huamanguilla','1');
INSERT INTO distrito VALUES ('470','46','Iguain','1');
INSERT INTO distrito VALUES ('471','46','Luricocha','1');
INSERT INTO distrito VALUES ('472','46','Santillana','1');
INSERT INTO distrito VALUES ('473','46','Sivia','1');
INSERT INTO distrito VALUES ('474','46','Llochegua','1');
INSERT INTO distrito VALUES ('475','46','Canayre','1');
INSERT INTO distrito VALUES ('476','46','Uchuraccay','1');
INSERT INTO distrito VALUES ('477','46','Pucacolpa','1');
-- Ayacucho - La Mar (47)
INSERT INTO distrito VALUES ('478','47','San Miguel','1');
INSERT INTO distrito VALUES ('479','47','Anco','1');
INSERT INTO distrito VALUES ('480','47','Ayna','1');
INSERT INTO distrito VALUES ('481','47','Chilcas','1');
INSERT INTO distrito VALUES ('482','47','Chungui','1');
INSERT INTO distrito VALUES ('483','47','Luis Carranza','1');
INSERT INTO distrito VALUES ('484','47','Santa Rosa','1');
INSERT INTO distrito VALUES ('485','47','Tambo','1');
INSERT INTO distrito VALUES ('486','47','Samugari','1');
INSERT INTO distrito VALUES ('487','47','Anchihuay','1');
-- Ayacucho - Lucanas (48)
INSERT INTO distrito VALUES ('488','48','Puquio','1');
INSERT INTO distrito VALUES ('489','48','Aucara','1');
INSERT INTO distrito VALUES ('490','48','Cabana','1');
INSERT INTO distrito VALUES ('491','48','Carmen Salcedo','1');
INSERT INTO distrito VALUES ('492','48','Chaviña','1');
INSERT INTO distrito VALUES ('493','48','Chipao','1');
INSERT INTO distrito VALUES ('494','48','Huac-Huas','1');
INSERT INTO distrito VALUES ('495','48','Laramate','1');
INSERT INTO distrito VALUES ('496','48','Leoncio Prado','1');
INSERT INTO distrito VALUES ('497','48','Llauta','1');
INSERT INTO distrito VALUES ('498','48','Lucanas','1');
INSERT INTO distrito VALUES ('499','48','Ocaña','1');
INSERT INTO distrito VALUES ('500','48','Otoca','1');
INSERT INTO distrito VALUES ('501','48','Saisa','1');
INSERT INTO distrito VALUES ('502','48','San Cristóbal','1');
INSERT INTO distrito VALUES ('503','48','San Juan','1');
INSERT INTO distrito VALUES ('504','48','San Pedro','1');
INSERT INTO distrito VALUES ('505','48','San Pedro de Palco','1');
INSERT INTO distrito VALUES ('506','48','Sancos','1');
INSERT INTO distrito VALUES ('507','48','Santa Ana de Huaycahuacho','1');
INSERT INTO distrito VALUES ('508','48','Santa Lucia','1');
-- Ayacucho - Parinacochas (49)
INSERT INTO distrito VALUES ('509','49','Coracora','1');
INSERT INTO distrito VALUES ('510','49','Chumpi','1');
INSERT INTO distrito VALUES ('511','49','Coronel Castañeda','1');
INSERT INTO distrito VALUES ('512','49','Pacapausa','1');
INSERT INTO distrito VALUES ('513','49','Pullo','1');
INSERT INTO distrito VALUES ('514','49','Puyusca','1');
INSERT INTO distrito VALUES ('515','49','San Francisco de Ravacayco','1');
INSERT INTO distrito VALUES ('516','49','Upahuacho','1');
-- Ayacucho - Páucar del Sara Sara (50)
INSERT INTO distrito VALUES ('517','50','Pausa','1');
INSERT INTO distrito VALUES ('518','50','Colta','1');
INSERT INTO distrito VALUES ('519','50','Corculla','1');
INSERT INTO distrito VALUES ('520','50','Lampa','1');
INSERT INTO distrito VALUES ('521','50','Marcabamba','1');
INSERT INTO distrito VALUES ('522','50','Oyolo','1');
INSERT INTO distrito VALUES ('523','50','Pararca','1');
INSERT INTO distrito VALUES ('524','50','San Javie de Alpabamba','1');
INSERT INTO distrito VALUES ('525','50','San José de Ushua','1');
INSERT INTO distrito VALUES ('526','50','Sara Sara','1');
-- Ayacucho - Sucre (51)
INSERT INTO distrito VALUES ('527','51','Querobamba','1');
INSERT INTO distrito VALUES ('528','51','Belén','1');
INSERT INTO distrito VALUES ('529','51','Chalcos','1');
INSERT INTO distrito VALUES ('530','51','Chilcayoc','1');
INSERT INTO distrito VALUES ('531','51','Huacaña','1');
INSERT INTO distrito VALUES ('532','51','Morcolla','1');
INSERT INTO distrito VALUES ('533','51','Paico','1');
INSERT INTO distrito VALUES ('534','51','San Pedro de Larcay','1');
INSERT INTO distrito VALUES ('535','51','San Salvador de Quije','1');
INSERT INTO distrito VALUES ('536','51','Santiago de Paucaray','1');
INSERT INTO distrito VALUES ('537','51','Soras','1');
-- Ayacucho - Víctor Fajardo (52)
INSERT INTO distrito VALUES ('538','52','Huancapi','1');
INSERT INTO distrito VALUES ('539','52','Alcamenca','1');
INSERT INTO distrito VALUES ('540','52','Apongo','1');
INSERT INTO distrito VALUES ('541','52','Asquipata','1');
INSERT INTO distrito VALUES ('542','52','Canaria','1');
INSERT INTO distrito VALUES ('543','52','Cayara','1');
INSERT INTO distrito VALUES ('544','52','Colca','1');
INSERT INTO distrito VALUES ('545','52','Huamanquiquia','1');
INSERT INTO distrito VALUES ('546','52','Huancaraylla','1');
INSERT INTO distrito VALUES ('547','52','Huaya','1');
INSERT INTO distrito VALUES ('548','52','Sarhua','1');
INSERT INTO distrito VALUES ('549','52','Vilcanchos','1');
-- Ayacucho - Vilcas Huamán (53)
INSERT INTO distrito VALUES ('550','53','Vilcas Huamán','1');
INSERT INTO distrito VALUES ('551','53','Accomarca','1');
INSERT INTO distrito VALUES ('552','53','Carhuanca','1');
INSERT INTO distrito VALUES ('553','53','Concepción','1');
INSERT INTO distrito VALUES ('554','53','Huambalpa','1');
INSERT INTO distrito VALUES ('555','53','Independencia','1');
INSERT INTO distrito VALUES ('556','53','Saurama','1');
INSERT INTO distrito VALUES ('557','53','Vischongo','1');

-- Cajamarca - Cajamarca (54)
INSERT INTO distrito VALUES ('558','54','Cajamarca','1');
INSERT INTO distrito VALUES ('559','54','Asunción','1');
INSERT INTO distrito VALUES ('560','54','Chetilla','1');
INSERT INTO distrito VALUES ('561','54','Cospan','1');
INSERT INTO distrito VALUES ('562','54','Encañada','1');
INSERT INTO distrito VALUES ('563','54','Jesús','1');
INSERT INTO distrito VALUES ('564','54','Llacanora','1');
INSERT INTO distrito VALUES ('565','54','Los Baños del Inca','1');
INSERT INTO distrito VALUES ('566','54','Magdalena','1');
INSERT INTO distrito VALUES ('567','54','Matara','1');
INSERT INTO distrito VALUES ('568','54','Namora','1');
INSERT INTO distrito VALUES ('569','54','San Juan','1');
-- Cajamarca - Cajabamba (55)
INSERT INTO distrito VALUES ('570','55','Cajabamba','1');
INSERT INTO distrito VALUES ('571','55','Cachachi','1');
INSERT INTO distrito VALUES ('572','55','Condebamba','1');
INSERT INTO distrito VALUES ('573','55','Sitacocha','1');
-- Cajamarca - Celendín (56)
INSERT INTO distrito VALUES ('574','56','Celendín','1');
INSERT INTO distrito VALUES ('575','56','Chumuch','1');
INSERT INTO distrito VALUES ('576','56','Cortegana','1');
INSERT INTO distrito VALUES ('577','56','Huasmin','1');
INSERT INTO distrito VALUES ('578','56','Jorge Chávez','1');
INSERT INTO distrito VALUES ('579','56','José Gálvez','1');
INSERT INTO distrito VALUES ('580','56','Miguel Iglesias','1');
INSERT INTO distrito VALUES ('581','56','Oxamarca','1');
INSERT INTO distrito VALUES ('582','56','Sorochuco','1');
INSERT INTO distrito VALUES ('583','56','Sucre','1');
INSERT INTO distrito VALUES ('584','56','Utco','1');
INSERT INTO distrito VALUES ('585','56','La Libertad de Pallan','1');
-- Cajamarca - Chota (57)
INSERT INTO distrito VALUES ('586','57','Chota','1');
INSERT INTO distrito VALUES ('587','57','Anguia','1');
INSERT INTO distrito VALUES ('588','57','Chadin','1');
INSERT INTO distrito VALUES ('589','57','Chiguirip','1');
INSERT INTO distrito VALUES ('590','57','Chimban','1');
INSERT INTO distrito VALUES ('591','57','Choropampa','1');
INSERT INTO distrito VALUES ('592','57','Cochabamba','1');
INSERT INTO distrito VALUES ('593','57','Conchan','1');
INSERT INTO distrito VALUES ('594','57','Huambos','1');
INSERT INTO distrito VALUES ('595','57','Lajas','1');
INSERT INTO distrito VALUES ('596','57','Llama','1');
INSERT INTO distrito VALUES ('597','57','Miracosta','1');
INSERT INTO distrito VALUES ('598','57','Paccha','1');
INSERT INTO distrito VALUES ('599','57','Pion','1');
INSERT INTO distrito VALUES ('600','57','Querocoto','1');
INSERT INTO distrito VALUES ('601','57','San Juan de Licupis','1');
INSERT INTO distrito VALUES ('602','57','Tacabamba','1');
INSERT INTO distrito VALUES ('603','57','Tocmoche','1');
INSERT INTO distrito VALUES ('604','57','Chalamarca','1');
-- Cajamarca - Contumazá (58)
INSERT INTO distrito VALUES ('605','58','Contumaza','1');
INSERT INTO distrito VALUES ('606','58','Chilete','1');
INSERT INTO distrito VALUES ('607','58','Cupisnique','1');
INSERT INTO distrito VALUES ('608','58','Guzmango','1');
INSERT INTO distrito VALUES ('609','58','San Benito','1');
INSERT INTO distrito VALUES ('610','58','Santa Cruz de Toledo','1');
INSERT INTO distrito VALUES ('611','58','Tantarica','1');
INSERT INTO distrito VALUES ('612','58','Yonan','1');
-- Cajamarca - Cutervo (59)
INSERT INTO distrito VALUES ('613','59','Cutervo','1');
INSERT INTO distrito VALUES ('614','59','Callayuc','1');
INSERT INTO distrito VALUES ('615','59','Choros','1');
INSERT INTO distrito VALUES ('616','59','Cujillo','1');
INSERT INTO distrito VALUES ('617','59','La Ramada','1');
INSERT INTO distrito VALUES ('618','59','Pimpingos','1');
INSERT INTO distrito VALUES ('619','59','Querocotillo','1');
INSERT INTO distrito VALUES ('620','59','San Andrés de Cutervo','1');
INSERT INTO distrito VALUES ('621','59','San Juan de Cutervo','1');
INSERT INTO distrito VALUES ('622','59','San Luis de Lucma','1');
INSERT INTO distrito VALUES ('623','59','Santa Cruz','1');
INSERT INTO distrito VALUES ('624','59','Santo Domingo de la Capilla','1');
INSERT INTO distrito VALUES ('625','59','Santo Tomas','1');
INSERT INTO distrito VALUES ('626','59','Socota','1');
INSERT INTO distrito VALUES ('627','59','Toribio Casanova','1');
-- Cajamarca - Hualgayoc (60)
INSERT INTO distrito VALUES ('628','60','Bambamarca','1');
INSERT INTO distrito VALUES ('629','60','Chugur','1');
INSERT INTO distrito VALUES ('630','60','Hualgayoc','1');
-- Cajamarca - Jaén (61)
INSERT INTO distrito VALUES ('631','61','Jaén','1');
INSERT INTO distrito VALUES ('632','61','Bellavista','1');
INSERT INTO distrito VALUES ('633','61','Chontali','1');
INSERT INTO distrito VALUES ('634','61','Colasay','1');
INSERT INTO distrito VALUES ('635','61','Huabal','1');
INSERT INTO distrito VALUES ('636','61','Las Pirias','1');
INSERT INTO distrito VALUES ('637','61','Pomahuaca','1');
INSERT INTO distrito VALUES ('638','61','Pucara','1');
INSERT INTO distrito VALUES ('639','61','Sallique','1');
INSERT INTO distrito VALUES ('640','61','San Felipe','1');
INSERT INTO distrito VALUES ('641','61','San José del Alto','1');
INSERT INTO distrito VALUES ('642','61','Santa Rosa','1');
-- Cajamarca - San Ignacio (62)
INSERT INTO distrito VALUES ('643','62','San Ignacio','1');
INSERT INTO distrito VALUES ('644','62','Chirinos','1');
INSERT INTO distrito VALUES ('645','62','Huarango','1');
INSERT INTO distrito VALUES ('646','62','La Coipa','1');
INSERT INTO distrito VALUES ('647','62','Namballe','1');
INSERT INTO distrito VALUES ('648','62','San José de Lourdes','1');
INSERT INTO distrito VALUES ('649','62','Tabaconas','1');
-- Cajamarca - San Marcos (63)
INSERT INTO distrito VALUES ('650','63','Pedro Gálvez','1');
INSERT INTO distrito VALUES ('651','63','Chancay','1');
INSERT INTO distrito VALUES ('652','63','Eduardo Villanueva','1');
INSERT INTO distrito VALUES ('653','63','Gregorio Pita','1');
INSERT INTO distrito VALUES ('654','63','Ichocan','1');
INSERT INTO distrito VALUES ('655','63','José Manuel Quiroz','1');
INSERT INTO distrito VALUES ('656','63','José Sabogal','1');
-- Cajamarca - San Miguel (64)
INSERT INTO distrito VALUES ('657','64','San Miguel','1');
INSERT INTO distrito VALUES ('658','64','Bolívar','1');
INSERT INTO distrito VALUES ('659','64','Calquis','1');
INSERT INTO distrito VALUES ('660','64','Catilluc','1');
INSERT INTO distrito VALUES ('661','64','El Prado','1');
INSERT INTO distrito VALUES ('662','64','La Florida','1');
INSERT INTO distrito VALUES ('663','64','Llapa','1');
INSERT INTO distrito VALUES ('664','64','Nanchoc','1');
INSERT INTO distrito VALUES ('665','64','Niepos','1');
INSERT INTO distrito VALUES ('666','64','San Gregorio','1');
INSERT INTO distrito VALUES ('667','64','San Silvestre de Cochan','1');
INSERT INTO distrito VALUES ('668','64','Tongod','1');
INSERT INTO distrito VALUES ('669','64','Unión Agua Blanca','1');
-- Cajamarca - San Pablo (65)
INSERT INTO distrito VALUES ('670','65','San Pablo','1');
INSERT INTO distrito VALUES ('671','65','San Bernardino','1');
INSERT INTO distrito VALUES ('672','65','San Luis','1');
INSERT INTO distrito VALUES ('673','65','Tumbaden','1');
-- Cajamarca - Santa Cruz (66)
INSERT INTO distrito VALUES ('674','66','Santa Cruz','1');
INSERT INTO distrito VALUES ('675','66','Andabamba','1');
INSERT INTO distrito VALUES ('676','66','Catache','1');
INSERT INTO distrito VALUES ('677','66','Chancaybaños','1');
INSERT INTO distrito VALUES ('678','66','La Esperanza','1');
INSERT INTO distrito VALUES ('679','66','Ninabamba','1');
INSERT INTO distrito VALUES ('680','66','Pulan','1');
INSERT INTO distrito VALUES ('681','66','Saucepampa','1');
INSERT INTO distrito VALUES ('682','66','Sexi','1');
INSERT INTO distrito VALUES ('683','66','Uticyacu','1');
INSERT INTO distrito VALUES ('684','66','Yauyucan','1');

-- Cusco - Cusco (67)
INSERT INTO distrito VALUES ('685','67','Cusco','1');
INSERT INTO distrito VALUES ('686','67','Ccorca','1');
INSERT INTO distrito VALUES ('687','67','Poroy','1');
INSERT INTO distrito VALUES ('688','67','San Jerónimo','1');
INSERT INTO distrito VALUES ('689','67','San Sebastian','1');
INSERT INTO distrito VALUES ('690','67','Santiago','1');
INSERT INTO distrito VALUES ('691','67','Saylla','1');
INSERT INTO distrito VALUES ('692','67','Wanchaq','1');
-- Cusco - Acomayo (68)
INSERT INTO distrito VALUES ('693','68','Acomayo','1');
INSERT INTO distrito VALUES ('694','68','Acopia','1');
INSERT INTO distrito VALUES ('695','68','Acos','1');
INSERT INTO distrito VALUES ('696','68','Mosoc Llacta','1');
INSERT INTO distrito VALUES ('697','68','Pomacanchi','1');
INSERT INTO distrito VALUES ('698','68','Rondocan','1');
INSERT INTO distrito VALUES ('699','68','Sangarara','1');
-- Cusco - Anta (69)
INSERT INTO distrito VALUES ('700','69','Anta','1');
INSERT INTO distrito VALUES ('701','69','Ancahuasi','1');
INSERT INTO distrito VALUES ('702','69','Cachimayo','1');
INSERT INTO distrito VALUES ('703','69','Chinchaypujio','1');
INSERT INTO distrito VALUES ('704','69','Huarocondo','1');
INSERT INTO distrito VALUES ('705','69','Limatambo','1');
INSERT INTO distrito VALUES ('706','69','Mollepata','1');
INSERT INTO distrito VALUES ('707','69','Pucyura','1');
INSERT INTO distrito VALUES ('708','69','Zurite','1');
-- Cusco - Calca (70)
INSERT INTO distrito VALUES ('709','70','Calca','1');
INSERT INTO distrito VALUES ('710','70','Coya','1');
INSERT INTO distrito VALUES ('711','70','Lamay','1');
INSERT INTO distrito VALUES ('712','70','Lares','1');
INSERT INTO distrito VALUES ('713','70','Pisac','1');
INSERT INTO distrito VALUES ('714','70','San Salvador','1');
INSERT INTO distrito VALUES ('715','70','Taray','1');
INSERT INTO distrito VALUES ('716','70','Yanatile','1');
-- Cusco - Canas (71)
INSERT INTO distrito VALUES ('717','71','Yanaoca','1');
INSERT INTO distrito VALUES ('718','71','Checca','1');
INSERT INTO distrito VALUES ('719','71','Kunturkanki','1');
INSERT INTO distrito VALUES ('720','71','Langui','1');
INSERT INTO distrito VALUES ('721','71','Layo','1');
INSERT INTO distrito VALUES ('722','71','Pampamarca','1');
INSERT INTO distrito VALUES ('723','71','Quehue','1');
INSERT INTO distrito VALUES ('724','71','Tupac Amaru','1');
-- Cusco - Canchis (72)
INSERT INTO distrito VALUES ('725','72','Sicuani','1');
INSERT INTO distrito VALUES ('726','72','Checacupe','1');
INSERT INTO distrito VALUES ('727','72','Combapata','1');
INSERT INTO distrito VALUES ('728','72','Marangani','1');
INSERT INTO distrito VALUES ('729','72','Pitumarca','1');
INSERT INTO distrito VALUES ('730','72','San Pablo','1');
INSERT INTO distrito VALUES ('731','72','San Pedro','1');
INSERT INTO distrito VALUES ('732','72','Tinta','1');
-- Cusco - Chumbivilcas (73)
INSERT INTO distrito VALUES ('733','73','Santo Tomas','1');
INSERT INTO distrito VALUES ('734','73','Capacmarca','1');
INSERT INTO distrito VALUES ('735','73','Chamaca','1');
INSERT INTO distrito VALUES ('736','73','Colquemarca','1');
INSERT INTO distrito VALUES ('737','73','Livitaca','1');
INSERT INTO distrito VALUES ('738','73','Llusco','1');
INSERT INTO distrito VALUES ('739','73','Quiñota','1');
INSERT INTO distrito VALUES ('740','73','Velille','1');
-- Cusco - Espinar (74)
INSERT INTO distrito VALUES ('741','74','Espinar','1');
INSERT INTO distrito VALUES ('742','74','Condoroma','1');
INSERT INTO distrito VALUES ('743','74','Coporaque','1');
INSERT INTO distrito VALUES ('744','74','Ocoruro','1');
INSERT INTO distrito VALUES ('745','74','Pallpata','1');
INSERT INTO distrito VALUES ('746','74','Pichigua','1');
INSERT INTO distrito VALUES ('747','74','Suyckutambo','1');
INSERT INTO distrito VALUES ('748','74','Alto Pichigua','1');
-- Cusco - La Convención (75)
INSERT INTO distrito VALUES ('749','75','Santa Ana','1');
INSERT INTO distrito VALUES ('750','75','Echarate','1');
INSERT INTO distrito VALUES ('751','75','Huayopata','1');
INSERT INTO distrito VALUES ('752','75','Maranura','1');
INSERT INTO distrito VALUES ('753','75','Ocobamba','1');
INSERT INTO distrito VALUES ('754','75','Quellouno','1');
INSERT INTO distrito VALUES ('755','75','Kimbiri','1');
INSERT INTO distrito VALUES ('756','75','Santa Teresa','1');
INSERT INTO distrito VALUES ('757','75','Vilcabamba','1');
INSERT INTO distrito VALUES ('758','75','Pichari','1');
INSERT INTO distrito VALUES ('759','75','Inkawasi','1');
INSERT INTO distrito VALUES ('760','75','Villa Virgen','1');
INSERT INTO distrito VALUES ('761','75','Villa Kintiarina','1');
-- Cusco - Paruro (76)
INSERT INTO distrito VALUES ('762','76','Paruro','1');
INSERT INTO distrito VALUES ('763','76','Accha','1');
INSERT INTO distrito VALUES ('764','76','Ccapi','1');
INSERT INTO distrito VALUES ('765','76','Colcha','1');
INSERT INTO distrito VALUES ('766','76','Huanoquite','1');
INSERT INTO distrito VALUES ('767','76','Omacha','1');
INSERT INTO distrito VALUES ('768','76','Paccaritambo','1');
INSERT INTO distrito VALUES ('769','76','Pillpinto','1');
INSERT INTO distrito VALUES ('770','76','Yaurisque','1');
-- Cusco - Paucartambo (77)
INSERT INTO distrito VALUES ('771','77','Paucartambo','1');
INSERT INTO distrito VALUES ('772','77','Caicay','1');
INSERT INTO distrito VALUES ('773','77','Challabamba','1');
INSERT INTO distrito VALUES ('774','77','Colquepata','1');
INSERT INTO distrito VALUES ('775','77','Huancarani','1');
INSERT INTO distrito VALUES ('776','77','Kosñipata','1');
-- Cusco - Quispicanchi (78)
INSERT INTO distrito VALUES ('777','78','Urcos','1');
INSERT INTO distrito VALUES ('778','78','Andahuaylillas','1');
INSERT INTO distrito VALUES ('779','78','Camanti','1');
INSERT INTO distrito VALUES ('780','78','Ccarhuayo','1');
INSERT INTO distrito VALUES ('781','78','Ccatca','1');
INSERT INTO distrito VALUES ('782','78','Cusipata','1');
INSERT INTO distrito VALUES ('783','78','Huaro','1');
INSERT INTO distrito VALUES ('784','78','Lucre','1');
INSERT INTO distrito VALUES ('785','78','Marcapata','1');
INSERT INTO distrito VALUES ('786','78','Ocongate','1');
INSERT INTO distrito VALUES ('787','78','Oropesa','1');
INSERT INTO distrito VALUES ('788','78','Quiquijana','1');
-- Cusco - Urubamba (79)
INSERT INTO distrito VALUES ('789','79','Urubamba','1');
INSERT INTO distrito VALUES ('790','79','Chinchero','1');
INSERT INTO distrito VALUES ('791','79','Huayllabamba','1');
INSERT INTO distrito VALUES ('792','79','Machupicchu','1');
INSERT INTO distrito VALUES ('793','79','Maras','1');
INSERT INTO distrito VALUES ('794','79','Ollantaytambo','1');
INSERT INTO distrito VALUES ('795','79','Yucay','1');

-- Huancavelica - Huancavelica (80)
INSERT INTO distrito VALUES ('796','80','Huancavelica','1');
INSERT INTO distrito VALUES ('797','80','Acobambilla','1');
INSERT INTO distrito VALUES ('798','80','Acoria','1');
INSERT INTO distrito VALUES ('799','80','Conayca','1');
INSERT INTO distrito VALUES ('800','80','Cuenca','1');
INSERT INTO distrito VALUES ('801','80','Huachocolpa','1');
INSERT INTO distrito VALUES ('802','80','Huayllahuara','1');
INSERT INTO distrito VALUES ('803','80','Izcuchaca','1');
INSERT INTO distrito VALUES ('804','80','Laria','1');
INSERT INTO distrito VALUES ('805','80','Manta','1');
INSERT INTO distrito VALUES ('806','80','Mariscal Cáceres','1');
INSERT INTO distrito VALUES ('807','80','Moya','1');
INSERT INTO distrito VALUES ('808','80','Nuevo Occoro','1');
INSERT INTO distrito VALUES ('809','80','Palca','1');
INSERT INTO distrito VALUES ('810','80','Pilchaca','1');
INSERT INTO distrito VALUES ('811','80','Vilca','1');
INSERT INTO distrito VALUES ('812','80','Yauli','1');
INSERT INTO distrito VALUES ('813','80','Ascensión','1');
INSERT INTO distrito VALUES ('814','80','Huando','1');
-- Huancavelica - Acobamba (81)
INSERT INTO distrito VALUES ('815','81','Acobamba','1');
INSERT INTO distrito VALUES ('816','81','Andabamba','1');
INSERT INTO distrito VALUES ('817','81','Anta','1');
INSERT INTO distrito VALUES ('818','81','Caja','1');
INSERT INTO distrito VALUES ('819','81','Marcas','1');
INSERT INTO distrito VALUES ('820','81','Paucara','1');
INSERT INTO distrito VALUES ('821','81','Pomacocha','1');
INSERT INTO distrito VALUES ('822','81','Rosario','1');
-- Huancavelica - Angaraes (82)
INSERT INTO distrito VALUES ('823','82','Lircay','1');
INSERT INTO distrito VALUES ('824','82','Anchonga','1');
INSERT INTO distrito VALUES ('825','82','Callanmarca','1');
INSERT INTO distrito VALUES ('826','82','Ccochaccasa','1');
INSERT INTO distrito VALUES ('827','82','Chincho','1');
INSERT INTO distrito VALUES ('828','82','Congalla','1');
INSERT INTO distrito VALUES ('829','82','Huanca-Huanca','1');
INSERT INTO distrito VALUES ('830','82','Huayllay Grande','1');
INSERT INTO distrito VALUES ('831','82','Julcamarca','1');
INSERT INTO distrito VALUES ('832','82','San Antonio de Antaparco','1');
INSERT INTO distrito VALUES ('833','82','Santo Tomas de Pata','1');
INSERT INTO distrito VALUES ('834','82','Secclla','1');
-- Huancavelica - Castrovirreyna (83)
INSERT INTO distrito VALUES ('835','83','Castrovirreyna','1');
INSERT INTO distrito VALUES ('836','83','Arma','1');
INSERT INTO distrito VALUES ('837','83','Aurahua','1');
INSERT INTO distrito VALUES ('838','83','Capillas','1');
INSERT INTO distrito VALUES ('839','83','Chupamarca','1');
INSERT INTO distrito VALUES ('840','83','Cocas','1');
INSERT INTO distrito VALUES ('841','83','Huachos','1');
INSERT INTO distrito VALUES ('842','83','Huamatambo','1');
INSERT INTO distrito VALUES ('843','83','Mollepampa','1');
INSERT INTO distrito VALUES ('844','83','San Juan','1');
INSERT INTO distrito VALUES ('845','83','Santa Ana','1');
INSERT INTO distrito VALUES ('846','83','Tantara','1');
INSERT INTO distrito VALUES ('847','83','Ticrapo','1');
-- Huancavelica - Churcampa (84)
INSERT INTO distrito VALUES ('848','84','Churcampa','1');
INSERT INTO distrito VALUES ('849','84','Anco','1');
INSERT INTO distrito VALUES ('850','84','Chinchihuasi','1');
INSERT INTO distrito VALUES ('851','84','El Carmen','1');
INSERT INTO distrito VALUES ('852','84','La Merced','1');
INSERT INTO distrito VALUES ('853','84','Locroja','1');
INSERT INTO distrito VALUES ('854','84','Paucarbamba','1');
INSERT INTO distrito VALUES ('855','84','San Miguel de Mayocc','1');
INSERT INTO distrito VALUES ('856','84','San Pedro de Coris','1');
INSERT INTO distrito VALUES ('857','84','Pachamarca','1');
INSERT INTO distrito VALUES ('858','84','Cosme','1');
-- Huancavelica - Huaytará (85)
INSERT INTO distrito VALUES ('859','85','Huaytara','1');
INSERT INTO distrito VALUES ('860','86','Ayavi','1');
INSERT INTO distrito VALUES ('861','85','Córdova','1');
INSERT INTO distrito VALUES ('862','85','Huayacundo Arma','1');
INSERT INTO distrito VALUES ('863','85','Laramarca','1');
INSERT INTO distrito VALUES ('864','85','Ocoyo','1');
INSERT INTO distrito VALUES ('865','85','Pilpichaca','1');
INSERT INTO distrito VALUES ('866','85','Querco','1');
INSERT INTO distrito VALUES ('867','85','Quita-Arma','1');
INSERT INTO distrito VALUES ('868','85','San Antonio de Cusicancha','1');
INSERT INTO distrito VALUES ('869','85','San Francisco de Sangayaico','1');
INSERT INTO distrito VALUES ('870','85','San Isidro','1');
INSERT INTO distrito VALUES ('871','85','Santiago de Chocorvos','1');
INSERT INTO distrito VALUES ('872','85','Santiago de Quirahuara','1');
INSERT INTO distrito VALUES ('873','85','Santo Domingo de Capillas','1');
INSERT INTO distrito VALUES ('874','85','Tambo','1');
-- Huancavelica - Tayacaja (86)
INSERT INTO distrito VALUES ('875','86','Pampas','1');
INSERT INTO distrito VALUES ('876','86','Acostambo','1');
INSERT INTO distrito VALUES ('877','86','Acraquia','1');
INSERT INTO distrito VALUES ('878','86','Ahuaycha','1');
INSERT INTO distrito VALUES ('879','86','Colcabamba','1');
INSERT INTO distrito VALUES ('880','86','Daniel Hernández','1');
INSERT INTO distrito VALUES ('881','86','Huachocolpa','1');
INSERT INTO distrito VALUES ('882','86','Huaribamba','1');
INSERT INTO distrito VALUES ('883','86','Ñahuimpuquio','1');
INSERT INTO distrito VALUES ('884','86','Pazos','1');
INSERT INTO distrito VALUES ('885','86','Quishuar','1');
INSERT INTO distrito VALUES ('886','86','Salcabamba','1');
INSERT INTO distrito VALUES ('887','86','Salcahuasi','1');
INSERT INTO distrito VALUES ('888','86','San Marcos de Rocchac','1');
INSERT INTO distrito VALUES ('889','86','Surcubamba','1');
INSERT INTO distrito VALUES ('890','86','Tintay Puncu','1');
INSERT INTO distrito VALUES ('891','86','Quichuas','1');
INSERT INTO distrito VALUES ('892','86','Andaymarca','1');

-- Huánuco - Huánuco (87)
INSERT INTO distrito VALUES ('893','87','Huanuco','1');
INSERT INTO distrito VALUES ('894','87','Amarilis','1');
INSERT INTO distrito VALUES ('895','87','Chinchao','1');
INSERT INTO distrito VALUES ('896','87','Churubamba','1');
INSERT INTO distrito VALUES ('897','87','Margos','1');
INSERT INTO distrito VALUES ('898','87','Quisqui (Kichki)','1');
INSERT INTO distrito VALUES ('899','87','San Francisco de Cayran','1');
INSERT INTO distrito VALUES ('900','87','San Pedro de Chaulan','1');
INSERT INTO distrito VALUES ('901','87','Santa María del Valle','1');
INSERT INTO distrito VALUES ('902','87','Yarumayo','1');
INSERT INTO distrito VALUES ('903','87','Pillco Marca','1');
INSERT INTO distrito VALUES ('904','87','Yacus','1');
-- Huánuco - Ambo (88)
INSERT INTO distrito VALUES ('905','88','Ambo','1');
INSERT INTO distrito VALUES ('906','88','Cayna','1');
INSERT INTO distrito VALUES ('907','88','Colpas','1');
INSERT INTO distrito VALUES ('908','88','Conchamarca','1');
INSERT INTO distrito VALUES ('909','88','Huacar','1');
INSERT INTO distrito VALUES ('910','88','San Francisco','1');
INSERT INTO distrito VALUES ('911','88','San Rafael','1');
INSERT INTO distrito VALUES ('912','88','Tomay Kichwa','1');
-- Huánuco - Dos de Mayo (89)
INSERT INTO distrito VALUES ('913','89','La Unión','1');
INSERT INTO distrito VALUES ('914','89','Chuquis','1');
INSERT INTO distrito VALUES ('915','89','Marías','1');
INSERT INTO distrito VALUES ('916','89','Pachas','1');
INSERT INTO distrito VALUES ('917','89','Quivilla','1');
INSERT INTO distrito VALUES ('918','89','Ripan','1');
INSERT INTO distrito VALUES ('919','89','Shunqui','1');
INSERT INTO distrito VALUES ('920','89','Sillapata','1');
INSERT INTO distrito VALUES ('921','89','Yanas','1');
-- Huánuco - Huacaybamba (90)
INSERT INTO distrito VALUES ('922','90','Huacaybamba','1');
INSERT INTO distrito VALUES ('923','90','Canchabamba','1');
INSERT INTO distrito VALUES ('924','90','Cochabamba','1');
INSERT INTO distrito VALUES ('925','90','Pinra','1');
-- Huánuco - Huamalíes (91)
INSERT INTO distrito VALUES ('926','91','Llata','1');
INSERT INTO distrito VALUES ('927','91','Arancay','1');
INSERT INTO distrito VALUES ('928','91','Chavín de Pariarca','1');
INSERT INTO distrito VALUES ('929','91','Jacas Grande','1');
INSERT INTO distrito VALUES ('930','91','Jircan','1');
INSERT INTO distrito VALUES ('931','91','Miraflores','1');
INSERT INTO distrito VALUES ('932','91','Monzón','1');
INSERT INTO distrito VALUES ('933','91','Punchao','1');
INSERT INTO distrito VALUES ('934','91','Puños','1');
INSERT INTO distrito VALUES ('935','91','Singa','1');
INSERT INTO distrito VALUES ('936','91','Tantamayo','1');
-- Huánuco - Leoncio Prado (92)
INSERT INTO distrito VALUES ('937','92','Rupa-Rupa','1');
INSERT INTO distrito VALUES ('938','92','Daniel Alomía Robles','1');
INSERT INTO distrito VALUES ('939','92','Hermílio Valdizan','1');
INSERT INTO distrito VALUES ('940','92','José Crespo y Castillo','1');
INSERT INTO distrito VALUES ('941','92','Luyando','1');
INSERT INTO distrito VALUES ('942','92','Mariano Damaso Beraun','1');
-- Huánuco - Marañón (93)
INSERT INTO distrito VALUES ('943','93','Huacrachuco','1');
INSERT INTO distrito VALUES ('944','93','Cholon','1');
INSERT INTO distrito VALUES ('945','93','San Buenaventura','1');
-- Huánuco - Pachitea (94)
INSERT INTO distrito VALUES ('946','94','Panao','1');
INSERT INTO distrito VALUES ('947','94','Chaglla','1');
INSERT INTO distrito VALUES ('948','94','Molino','1');
INSERT INTO distrito VALUES ('949','94','Umari','1');
-- Huánuco - Puerto Inca (95)
INSERT INTO distrito VALUES ('950','95','Puerto Inca','1');
INSERT INTO distrito VALUES ('951','95','Codo del Pozuzo','1');
INSERT INTO distrito VALUES ('952','95','Honoria','1');
INSERT INTO distrito VALUES ('953','95','Tournavista','1');
INSERT INTO distrito VALUES ('954','95','Yuyapichis','1');
-- Huánuco - Lauricocha (96)
INSERT INTO distrito VALUES ('955','96','Jesús','1');
INSERT INTO distrito VALUES ('956','96','Baños','1');
INSERT INTO distrito VALUES ('957','96','Jivia','1');
INSERT INTO distrito VALUES ('958','96','Queropalca','1');
INSERT INTO distrito VALUES ('959','96','Rondos','1');
INSERT INTO distrito VALUES ('960','96','San Francisco de Asís','1');
INSERT INTO distrito VALUES ('961','96','San Miguel de Cauri','1');
-- Huánuco - Yarowilca (97)
INSERT INTO distrito VALUES ('962','97','Chavinillo','1');
INSERT INTO distrito VALUES ('963','97','Cahuac','1');
INSERT INTO distrito VALUES ('964','97','Chacabamba','1');
INSERT INTO distrito VALUES ('965','97','Aparicio Pomares','1');
INSERT INTO distrito VALUES ('966','97','Jacas Chico','1');
INSERT INTO distrito VALUES ('967','97','Obas','1');
INSERT INTO distrito VALUES ('968','97','Pampamarca','1');
INSERT INTO distrito VALUES ('969','97','Choras','1');

-- Ica - Ica (98)
INSERT INTO distrito VALUES ('970','98','Ica','1');
INSERT INTO distrito VALUES ('971','98','La Tinguiña','1');
INSERT INTO distrito VALUES ('972','98','Los Aquijes','1');
INSERT INTO distrito VALUES ('973','98','Ocucaje','1');
INSERT INTO distrito VALUES ('974','98','Pachacutec','1');
INSERT INTO distrito VALUES ('975','98','Parcona','1');
INSERT INTO distrito VALUES ('976','98','Pueblo Nuevo','1');
INSERT INTO distrito VALUES ('977','98','Salas','1');
INSERT INTO distrito VALUES ('978','98','San José de Los Molinos','1');
INSERT INTO distrito VALUES ('979','98','San Juan Bautista','1');
INSERT INTO distrito VALUES ('980','98','Santiago','1');
INSERT INTO distrito VALUES ('981','98','Subtanjalla','1');
INSERT INTO distrito VALUES ('982','98','Tate','1');
INSERT INTO distrito VALUES ('983','98','Yauca del Rosario','1');
-- Ica - Chincha (99)
INSERT INTO distrito VALUES ('984','99','Chincha Alta','1');
INSERT INTO distrito VALUES ('985','99','Alto Laran','1');
INSERT INTO distrito VALUES ('986','99','Chavín','1');
INSERT INTO distrito VALUES ('987','99','Chincha Baja','1');
INSERT INTO distrito VALUES ('988','99','El Carmen','1');
INSERT INTO distrito VALUES ('989','99','Grocio Prado','1');
INSERT INTO distrito VALUES ('990','99','Pueblo Nuevo','1');
INSERT INTO distrito VALUES ('991','99','San Juan de Yanac','1');
INSERT INTO distrito VALUES ('992','99','San Pedro de Huacarpana','1');
INSERT INTO distrito VALUES ('993','99','Sunampe','1');
INSERT INTO distrito VALUES ('994','99','Tambo de Mora','1');
-- Ica - Nazca (100)
INSERT INTO distrito VALUES ('995','100','Nazca','1');
INSERT INTO distrito VALUES ('996','100','Changuillo','1');
INSERT INTO distrito VALUES ('997','100','El Ingenio','1');
INSERT INTO distrito VALUES ('998','100','Marcona','1');
INSERT INTO distrito VALUES ('999','100','Vista Alegre','1');
-- Ica - Palpa (101)
INSERT INTO distrito VALUES ('1000','101','Palpa','1');
INSERT INTO distrito VALUES ('1001','101','Llipata','1');
INSERT INTO distrito VALUES ('1002','101','Río Grande','1');
INSERT INTO distrito VALUES ('1003','101','Santa Cruz','1');
INSERT INTO distrito VALUES ('1004','101','Tibillo','1');
-- Ica - Pisco (102)
INSERT INTO distrito VALUES ('1005','102','Pisco','1');
INSERT INTO distrito VALUES ('1006','102','Huancano','1');
INSERT INTO distrito VALUES ('1007','102','Humay','1');
INSERT INTO distrito VALUES ('1008','102','Independencia','1');
INSERT INTO distrito VALUES ('1009','102','Paracas','1');
INSERT INTO distrito VALUES ('1010','102','San Andrés','1');
INSERT INTO distrito VALUES ('1011','102','San Clemente','1');
INSERT INTO distrito VALUES ('1012','102','Tupac Amaru Inca','1');

-- Junín - Huancayo (103)
INSERT INTO distrito VALUES ('1013','103','Huancayo','1');
INSERT INTO distrito VALUES ('1014','103','Carhuacallanga','1');
INSERT INTO distrito VALUES ('1015','103','Chacapampa','1');
INSERT INTO distrito VALUES ('1016','103','Chicche','1');
INSERT INTO distrito VALUES ('1017','103','Chilca','1');
INSERT INTO distrito VALUES ('1018','103','Chongos Alto','1');
INSERT INTO distrito VALUES ('1019','103','Chupuro','1');
INSERT INTO distrito VALUES ('1020','103','Colca','1');
INSERT INTO distrito VALUES ('1021','103','Cullhuas','1');
INSERT INTO distrito VALUES ('1022','103','El Tambo','1');
INSERT INTO distrito VALUES ('1023','103','Huacrapuquio','1');
INSERT INTO distrito VALUES ('1024','103','Hualhuas','1');
INSERT INTO distrito VALUES ('1025','103','Huancan','1');
INSERT INTO distrito VALUES ('1026','103','Huasicancha','1');
INSERT INTO distrito VALUES ('1027','103','Huayucachi','1');
INSERT INTO distrito VALUES ('1028','103','Ingenio','1');
INSERT INTO distrito VALUES ('1029','103','Parihuanca','1');
INSERT INTO distrito VALUES ('1030','103','Pilcomayo','1');
INSERT INTO distrito VALUES ('1031','103','Pucara','1');
INSERT INTO distrito VALUES ('1032','103','Quichuay','1');
INSERT INTO distrito VALUES ('1033','103','Quilcas','1');
INSERT INTO distrito VALUES ('1034','103','San Agustín','1');
INSERT INTO distrito VALUES ('1035','103','San Jerónimo de Tunan','1');
INSERT INTO distrito VALUES ('1036','103','Saño','1');
INSERT INTO distrito VALUES ('1037','103','Sapallanga','1');
INSERT INTO distrito VALUES ('1038','103','Sicaya','1');
INSERT INTO distrito VALUES ('1039','103','Santo Domingo de Acobamba','1');
INSERT INTO distrito VALUES ('1040','103','Viques','1');
-- Junín - Concepción (104)
INSERT INTO distrito VALUES ('1041','104','Concepción','1');
INSERT INTO distrito VALUES ('1042','104','Aco','1');
INSERT INTO distrito VALUES ('1043','104','Andamarca','1');
INSERT INTO distrito VALUES ('1044','104','Chambara','1');
INSERT INTO distrito VALUES ('1045','104','Cochas','1');
INSERT INTO distrito VALUES ('1046','104','Comas','1');
INSERT INTO distrito VALUES ('1047','104','Heroínas Toledo','1');
INSERT INTO distrito VALUES ('1048','104','Manzanares','1');
INSERT INTO distrito VALUES ('1049','104','Mariscal Castilla','1');
INSERT INTO distrito VALUES ('1050','104','Matahuasi','1');
INSERT INTO distrito VALUES ('1051','104','Mito','1');
INSERT INTO distrito VALUES ('1052','104','Nueve de Julio','1');
INSERT INTO distrito VALUES ('1053','104','Orcotuna','1');
INSERT INTO distrito VALUES ('1054','104','San José de Quero','1');
INSERT INTO distrito VALUES ('1055','104','Santa Rosa de Ocopa','1');
-- Junín - Chanchamayo (105)
INSERT INTO distrito VALUES ('1056','105','Chanchamayo','1');
INSERT INTO distrito VALUES ('1057','105','Perene','1');
INSERT INTO distrito VALUES ('1058','105','Pichanaqui','1');
INSERT INTO distrito VALUES ('1059','105','San Luis de Shuaro','1');
INSERT INTO distrito VALUES ('1060','105','San Ramón','1');
INSERT INTO distrito VALUES ('1061','105','Vitoc','1');
-- Junín - Jauja (106)
INSERT INTO distrito VALUES ('1062','106','Jauja','1');
INSERT INTO distrito VALUES ('1063','106','Acolla','1');
INSERT INTO distrito VALUES ('1064','106','Apata','1');
INSERT INTO distrito VALUES ('1065','106','Ataura','1');
INSERT INTO distrito VALUES ('1066','106','Canchayllo','1');
INSERT INTO distrito VALUES ('1067','106','Curicaca','1');
INSERT INTO distrito VALUES ('1068','106','El Mantaro','1');
INSERT INTO distrito VALUES ('1069','106','Huamali','1');
INSERT INTO distrito VALUES ('1070','106','Huaripampa','1');
INSERT INTO distrito VALUES ('1071','106','Huertas','1');
INSERT INTO distrito VALUES ('1072','106','Janjaillo','1');
INSERT INTO distrito VALUES ('1073','106','Julcán','1');
INSERT INTO distrito VALUES ('1074','106','Leonor Ordóñez','1');
INSERT INTO distrito VALUES ('1075','106','Llocllapampa','1');
INSERT INTO distrito VALUES ('1076','106','Marco','1');
INSERT INTO distrito VALUES ('1077','106','Masma','1');
INSERT INTO distrito VALUES ('1078','106','Masma Chicche','1');
INSERT INTO distrito VALUES ('1079','106','Molinos','1');
INSERT INTO distrito VALUES ('1080','106','Monobamba','1');
INSERT INTO distrito VALUES ('1081','106','Muqui','1');
INSERT INTO distrito VALUES ('1082','106','Muquiyauyo','1');
INSERT INTO distrito VALUES ('1083','106','Paca','1');
INSERT INTO distrito VALUES ('1084','106','Paccha','1');
INSERT INTO distrito VALUES ('1085','106','Pancan','1');
INSERT INTO distrito VALUES ('1086','106','Parco','1');
INSERT INTO distrito VALUES ('1087','106','Pomacancha','1');
INSERT INTO distrito VALUES ('1088','106','Ricran','1');
INSERT INTO distrito VALUES ('1089','106','San Lorenzo','1');
INSERT INTO distrito VALUES ('1090','106','San Pedro de Chunan','1');
INSERT INTO distrito VALUES ('1091','106','Sausa','1');
INSERT INTO distrito VALUES ('1092','106','Sincos','1');
INSERT INTO distrito VALUES ('1093','106','Tunan Marca','1');
INSERT INTO distrito VALUES ('1094','106','Yauli','1');
INSERT INTO distrito VALUES ('1095','106','Yauyos','1');
-- Junín - Junín (107)
INSERT INTO distrito VALUES ('1096','107','Junin','1');
INSERT INTO distrito VALUES ('1097','107','Carhuamayo','1');
INSERT INTO distrito VALUES ('1098','107','Ondores','1');
INSERT INTO distrito VALUES ('1099','107','Ulcumayo','1');
-- Junín - Satipo (108)
INSERT INTO distrito VALUES ('1100','108','Satipo','1');
INSERT INTO distrito VALUES ('1101','108','Coviriali','1');
INSERT INTO distrito VALUES ('1102','108','Llaylla','1');
INSERT INTO distrito VALUES ('1103','108','Mazamari','1');
INSERT INTO distrito VALUES ('1104','108','Pampa Hermosa','1');
INSERT INTO distrito VALUES ('1105','108','Pangoa','1');
INSERT INTO distrito VALUES ('1106','108','Río Negro','1');
INSERT INTO distrito VALUES ('1107','108','Río Tambo','1');
INSERT INTO distrito VALUES ('1108','108','Vizcatan del Ene','1');
-- Junín - Tarma (109)
INSERT INTO distrito VALUES ('1109','109','Tarma','1');
INSERT INTO distrito VALUES ('1110','109','Acobamba','1');
INSERT INTO distrito VALUES ('1111','109','Huaricolca','1');
INSERT INTO distrito VALUES ('1112','109','Huasahuasi','1');
INSERT INTO distrito VALUES ('1113','109','La Unión','1');
INSERT INTO distrito VALUES ('1114','109','Palca','1');
INSERT INTO distrito VALUES ('1115','109','Palcamayo','1');
INSERT INTO distrito VALUES ('1116','109','San Pedro de Cajas','1');
INSERT INTO distrito VALUES ('1117','109','Tapo','1');
-- Junín - Yauli (110)
INSERT INTO distrito VALUES ('1118','110','La Oroya','1');
INSERT INTO distrito VALUES ('1119','110','Chacapalpa','1');
INSERT INTO distrito VALUES ('1120','110','Huay-Huay','1');
INSERT INTO distrito VALUES ('1121','110','Marcapomacocha','1');
INSERT INTO distrito VALUES ('1122','110','Morococha','1');
INSERT INTO distrito VALUES ('1123','110','Paccha','1');
INSERT INTO distrito VALUES ('1124','110','Santa Bárbara de Carhuacayan','1');
INSERT INTO distrito VALUES ('1125','110','Santa Rosa de Sacco','1');
INSERT INTO distrito VALUES ('1126','110','Suitucancha','1');
INSERT INTO distrito VALUES ('1127','110','Yauli','1');
-- Junín - Chupaca (111)
INSERT INTO distrito VALUES ('1128','111','Chupaca','1');
INSERT INTO distrito VALUES ('1129','111','Ahuac','1');
INSERT INTO distrito VALUES ('1130','111','Chongos Bajo','1');
INSERT INTO distrito VALUES ('1131','111','Huachac','1');
INSERT INTO distrito VALUES ('1132','111','Huamancaca Chico','1');
INSERT INTO distrito VALUES ('1133','111','San Juan de Iscos','1');
INSERT INTO distrito VALUES ('1134','111','San Juan de Jarpa','1');
INSERT INTO distrito VALUES ('1135','111','Tres de Diciembre','1');
INSERT INTO distrito VALUES ('1136','111','Yanacancha','1');

-- La Libertad - Trujillo (112)
INSERT INTO distrito VALUES ('1137','112','Trujillo','1');
INSERT INTO distrito VALUES ('1138','112','El Porvenir','1');
INSERT INTO distrito VALUES ('1139','112','Florencia de Mora','1');
INSERT INTO distrito VALUES ('1140','112','Huanchaco','1');
INSERT INTO distrito VALUES ('1141','112','La Esperanza','1');
INSERT INTO distrito VALUES ('1142','112','Laredo','1');
INSERT INTO distrito VALUES ('1143','112','Moche','1');
INSERT INTO distrito VALUES ('1144','112','Poroto','1');
INSERT INTO distrito VALUES ('1145','112','Salaverry','1');
INSERT INTO distrito VALUES ('1146','112','Simbal','1');
INSERT INTO distrito VALUES ('1147','112','Victor Larco Herrera','1');
-- La Libertad - Ascope (113)
INSERT INTO distrito VALUES ('1148','113','Ascope','1');
INSERT INTO distrito VALUES ('1149','113','Chicama','1');
INSERT INTO distrito VALUES ('1150','113','Chocope','1');
INSERT INTO distrito VALUES ('1151','113','Magdalena de Cao','1');
INSERT INTO distrito VALUES ('1152','113','Paijan','1');
INSERT INTO distrito VALUES ('1153','113','Rázuri','1');
INSERT INTO distrito VALUES ('1154','113','Santiago de Cao','1');
INSERT INTO distrito VALUES ('1155','113','Casa Grande','1');
-- La Libertad - Bolívar (114)
INSERT INTO distrito VALUES ('1156','114','Bolívar','1');
INSERT INTO distrito VALUES ('1157','114','Bambamarca','1');
INSERT INTO distrito VALUES ('1158','114','Condormarca','1');
INSERT INTO distrito VALUES ('1159','114','Longotea','1');
INSERT INTO distrito VALUES ('1160','114','Uchumarca','1');
INSERT INTO distrito VALUES ('1161','114','Ucuncha','1');
-- La Libertad - Chepén (115)
INSERT INTO distrito VALUES ('1162','115','Chepen','1');
INSERT INTO distrito VALUES ('1163','115','Pacanga','1');
INSERT INTO distrito VALUES ('1164','115','Pueblo Nuevo','1');
-- La Libertad - Julcán (116)
INSERT INTO distrito VALUES ('1165','116','Julcan','1');
INSERT INTO distrito VALUES ('1166','116','Calamarca','1');
INSERT INTO distrito VALUES ('1167','116','Carabamba','1');
INSERT INTO distrito VALUES ('1168','116','Huaso','1');
-- La Libertad - Otuzco (117)
INSERT INTO distrito VALUES ('1169','117','Otuzco','1');
INSERT INTO distrito VALUES ('1170','117','Agallpampa','1');
INSERT INTO distrito VALUES ('1171','117','Charat','1');
INSERT INTO distrito VALUES ('1172','117','Huaranchal','1');
INSERT INTO distrito VALUES ('1173','117','La Cuesta','1');
INSERT INTO distrito VALUES ('1174','117','Mache','1');
INSERT INTO distrito VALUES ('1175','117','Paranday','1');
INSERT INTO distrito VALUES ('1176','117','Salpo','1');
INSERT INTO distrito VALUES ('1177','117','Sinsicap','1');
INSERT INTO distrito VALUES ('1178','117','Usquil','1');
-- La Libertad - Pacasmayo (118)
INSERT INTO distrito VALUES ('1179','118','San Pedro de Lloc','1');
INSERT INTO distrito VALUES ('1180','118','Guadalupe','1');
INSERT INTO distrito VALUES ('1181','118','Jequetepeque','1');
INSERT INTO distrito VALUES ('1182','118','Pacasmayo','1');
INSERT INTO distrito VALUES ('1183','118','San José','1');
-- La Libertad - Pataz (119)
INSERT INTO distrito VALUES ('1184','119','Tayabamba','1');
INSERT INTO distrito VALUES ('1185','119','Buldibuyo','1');
INSERT INTO distrito VALUES ('1186','119','Chillia','1');
INSERT INTO distrito VALUES ('1187','119','Huancaspata','1');
INSERT INTO distrito VALUES ('1188','119','Huaylillas','1');
INSERT INTO distrito VALUES ('1189','119','Huayo','1');
INSERT INTO distrito VALUES ('1190','119','Ongon','1');
INSERT INTO distrito VALUES ('1191','119','Parcoy','1');
INSERT INTO distrito VALUES ('1192','119','Pataz','1');
INSERT INTO distrito VALUES ('1193','119','Pias','1');
INSERT INTO distrito VALUES ('1194','119','Santiago de Challas','1');
INSERT INTO distrito VALUES ('1195','119','Taurija','1');
INSERT INTO distrito VALUES ('1196','119','Urpay','1');
-- La Libertad - Sánchez Carrión (120)
INSERT INTO distrito VALUES ('1197','120','Huamachuco','1');
INSERT INTO distrito VALUES ('1198','120','Chugay','1');
INSERT INTO distrito VALUES ('1199','120','Cochorco','1');
INSERT INTO distrito VALUES ('1200','120','Curgos','1');
INSERT INTO distrito VALUES ('1201','120','Marcabal','1');
INSERT INTO distrito VALUES ('1202','120','Sanagoran','1');
INSERT INTO distrito VALUES ('1203','120','Sarin','1');
INSERT INTO distrito VALUES ('1204','120','Sartimbamba','1');
-- La Libertad - Santiago de Chuco (121)
INSERT INTO distrito VALUES ('1205','121','Santiago de Chuco','1');
INSERT INTO distrito VALUES ('1206','121','Angasmarca','1');
INSERT INTO distrito VALUES ('1207','121','Cachicadan','1');
INSERT INTO distrito VALUES ('1208','121','Mollebamba','1');
INSERT INTO distrito VALUES ('1209','121','Mollepata','1');
INSERT INTO distrito VALUES ('1210','121','Quiruvilca','1');
INSERT INTO distrito VALUES ('1211','121','Santa Cruz de Chuca','1');
INSERT INTO distrito VALUES ('1212','121','Sitabamba','1');
-- La Libertad - Gran Chimú (122)
INSERT INTO distrito VALUES ('1213','122','Cascas','1');
INSERT INTO distrito VALUES ('1214','122','Lucma','1');
INSERT INTO distrito VALUES ('1215','122','Marmot','1');
INSERT INTO distrito VALUES ('1216','122','Sayapullo','1');
-- La Libertad - Virú (123)
INSERT INTO distrito VALUES ('1217','123','Viru','1');
INSERT INTO distrito VALUES ('1218','123','Chao','1');
INSERT INTO distrito VALUES ('1219','123','Guadalupito','1');

-- Lambayeque - Chiclayo (124)
INSERT INTO distrito VALUES ('1220','124','Chiclayo','1');
INSERT INTO distrito VALUES ('1221','124','Chongoyape','1');
INSERT INTO distrito VALUES ('1222','124','Eten','1');
INSERT INTO distrito VALUES ('1223','124','Eten Puerto','1');
INSERT INTO distrito VALUES ('1224','124','José Leonardo Ortiz','1');
INSERT INTO distrito VALUES ('1225','124','La Victoria','1');
INSERT INTO distrito VALUES ('1226','124','Lagunas','1');
INSERT INTO distrito VALUES ('1227','124','Monsefu','1');
INSERT INTO distrito VALUES ('1228','124','Nueva Arica','1');
INSERT INTO distrito VALUES ('1229','124','Oyotun','1');
INSERT INTO distrito VALUES ('1230','124','Picsi','1');
INSERT INTO distrito VALUES ('1231','124','Pimentel','1');
INSERT INTO distrito VALUES ('1232','124','Reque','1');
INSERT INTO distrito VALUES ('1233','124','Santa Rosa','1');
INSERT INTO distrito VALUES ('1234','124','Saña','1');
INSERT INTO distrito VALUES ('1235','124','Cayalti','1');
INSERT INTO distrito VALUES ('1236','124','Patapo','1');
INSERT INTO distrito VALUES ('1237','124','Pomalca','1');
INSERT INTO distrito VALUES ('1238','124','Pucala','1');
INSERT INTO distrito VALUES ('1239','124','Tuman','1');
-- Lambayeque - Ferreñafe (125)
INSERT INTO distrito VALUES ('1240','125','Ferreñafe','1');
INSERT INTO distrito VALUES ('1241','125','Cañaris','1');
INSERT INTO distrito VALUES ('1242','125','Incahuasi','1');
INSERT INTO distrito VALUES ('1243','125','Manuel Antonio Mesones Muro','1');
INSERT INTO distrito VALUES ('1244','125','Pitipo','1');
INSERT INTO distrito VALUES ('1245','125','Pueblo Nuevo','1');
-- Lambayeque - Lambayeque (126)
INSERT INTO distrito VALUES ('1246','126','Lambayeque','1');
INSERT INTO distrito VALUES ('1247','126','Chochope','1');
INSERT INTO distrito VALUES ('1248','126','Illimo','1');
INSERT INTO distrito VALUES ('1249','126','Jayanca','1');
INSERT INTO distrito VALUES ('1250','126','Mochumi','1');
INSERT INTO distrito VALUES ('1251','126','Morrope','1');
INSERT INTO distrito VALUES ('1252','126','Motupe','1');
INSERT INTO distrito VALUES ('1253','126','Olmos','1');
INSERT INTO distrito VALUES ('1254','126','Pacora','1');
INSERT INTO distrito VALUES ('1255','126','Salas','1');
INSERT INTO distrito VALUES ('1256','126','San José','1');
INSERT INTO distrito VALUES ('1257','126','Tucume','1');

-- Lima - Lima (127)
INSERT INTO distrito VALUES ('1258','127','Lima','1');
INSERT INTO distrito VALUES ('1259','127','Ancón','1');
INSERT INTO distrito VALUES ('1260','127','Ate','1');
INSERT INTO distrito VALUES ('1261','127','Barranco','1');
INSERT INTO distrito VALUES ('1262','127','Breña','1');
INSERT INTO distrito VALUES ('1263','127','Carabayllo','1');
INSERT INTO distrito VALUES ('1264','127','Chaclacayo','1');
INSERT INTO distrito VALUES ('1265','127','Chorrillos','1');
INSERT INTO distrito VALUES ('1266','127','Cieneguilla','1');
INSERT INTO distrito VALUES ('1267','127','Comas','1');
INSERT INTO distrito VALUES ('1268','127','El Agustino','1');
INSERT INTO distrito VALUES ('1269','127','Independencia','1');
INSERT INTO distrito VALUES ('1270','127','Jesús María','1');
INSERT INTO distrito VALUES ('1271','127','La Molina','1');
INSERT INTO distrito VALUES ('1272','127','La Victoria','1');
INSERT INTO distrito VALUES ('1273','127','Lince','1');
INSERT INTO distrito VALUES ('1274','127','Los Olivos','1');
INSERT INTO distrito VALUES ('1275','127','Lurigancho','1');
INSERT INTO distrito VALUES ('1276','127','Lurin','1');
INSERT INTO distrito VALUES ('1277','127','Magdalena del Mar','1');
INSERT INTO distrito VALUES ('1278','127','Pueblo Libre','1');
INSERT INTO distrito VALUES ('1279','127','Miraflores','1');
INSERT INTO distrito VALUES ('1280','127','Pachacamac','1');
INSERT INTO distrito VALUES ('1281','127','Pucusana','1');
INSERT INTO distrito VALUES ('1282','127','Puente Piedra','1');
INSERT INTO distrito VALUES ('1283','127','Punta Hermosa','1');
INSERT INTO distrito VALUES ('1284','127','Punta Negra','1');
INSERT INTO distrito VALUES ('1285','127','Rímac','1');
INSERT INTO distrito VALUES ('1286','127','San Bartolo','1');
INSERT INTO distrito VALUES ('1287','127','San Borja','1');
INSERT INTO distrito VALUES ('1288','127','San Isidro','1');
INSERT INTO distrito VALUES ('1289','127','San Juan de Lurigancho','1');
INSERT INTO distrito VALUES ('1290','127','San Juan de Miraflores','1');
INSERT INTO distrito VALUES ('1291','127','San Luis','1');
INSERT INTO distrito VALUES ('1292','127','San Martín de Porres','1');
INSERT INTO distrito VALUES ('1293','127','San Miguel','1');
INSERT INTO distrito VALUES ('1294','127','Santa Anita','1');
INSERT INTO distrito VALUES ('1295','127','Santa María del Mar','1');
INSERT INTO distrito VALUES ('1296','127','Santa Rosa','1');
INSERT INTO distrito VALUES ('1297','127','Santiago de Surco','1');
INSERT INTO distrito VALUES ('1298','127','Surquillo','1');
INSERT INTO distrito VALUES ('1299','127','Villa El Salvador','1');
INSERT INTO distrito VALUES ('1300','127','Villa María del Triunfo','1');
-- Lima - Barranca (128)
INSERT INTO distrito VALUES ('1301','128','Barranca','1');
INSERT INTO distrito VALUES ('1302','128','Paramonga','1');
INSERT INTO distrito VALUES ('1303','128','Pativilca','1');
INSERT INTO distrito VALUES ('1304','128','Supe','1');
INSERT INTO distrito VALUES ('1305','128','Supe Puerto','1');
-- Lima - Cajatambo (129)
INSERT INTO distrito VALUES ('1306','129','Cajatambo','1');
INSERT INTO distrito VALUES ('1307','129','Copa','1');
INSERT INTO distrito VALUES ('1308','129','Gorgor','1');
INSERT INTO distrito VALUES ('1309','129','Huancapon','1');
INSERT INTO distrito VALUES ('1310','129','Manas','1');
-- Lima - Canta (130)
INSERT INTO distrito VALUES ('1311','130','Canta','1');
INSERT INTO distrito VALUES ('1312','130','Arahuay','1');
INSERT INTO distrito VALUES ('1313','130','Huamantanga','1');
INSERT INTO distrito VALUES ('1314','130','Huaros','1');
INSERT INTO distrito VALUES ('1315','130','Lachaqui','1');
INSERT INTO distrito VALUES ('1316','130','San Buenaventura','1');
INSERT INTO distrito VALUES ('1317','130','Santa Rosa de Quives','1');
-- Lima - Callao (131)
INSERT INTO distrito VALUES ('1318','131','Callao','1');
INSERT INTO distrito VALUES ('1319','131','Bellavista','1');
INSERT INTO distrito VALUES ('1320','131','Carmen de la Legua Reynoso','1');
INSERT INTO distrito VALUES ('1321','131','La Perla','1');
INSERT INTO distrito VALUES ('1322','131','La Punta','1');
INSERT INTO distrito VALUES ('1323','131','Ventanilla','1');
INSERT INTO distrito VALUES ('1324','131','Mi Perú','1');
-- Lima - Cañete (132)
INSERT INTO distrito VALUES ('1325','132','San Vicente de Cañete','1');
INSERT INTO distrito VALUES ('1326','132','Asia','1');
INSERT INTO distrito VALUES ('1327','132','Calango','1');
INSERT INTO distrito VALUES ('1328','132','Cerro Azul','1');
INSERT INTO distrito VALUES ('1329','132','Chilca','1');
INSERT INTO distrito VALUES ('1330','132','Coayllo','1');
INSERT INTO distrito VALUES ('1331','132','Imperial','1');
INSERT INTO distrito VALUES ('1332','132','Lunahuana','1');
INSERT INTO distrito VALUES ('1333','132','Mala','1');
INSERT INTO distrito VALUES ('1334','132','Nuevo Imperial','1');
INSERT INTO distrito VALUES ('1335','132','Pacaran','1');
INSERT INTO distrito VALUES ('1336','132','Quilmana','1');
INSERT INTO distrito VALUES ('1337','132','San Antonio','1');
INSERT INTO distrito VALUES ('1338','132','San Luis','1');
INSERT INTO distrito VALUES ('1339','132','Santa Cruz de Flores','1');
INSERT INTO distrito VALUES ('1340','132','Zúñiga','1');
-- Lima - Huaral (133)
INSERT INTO distrito VALUES ('1341','133','Huaral','1');
INSERT INTO distrito VALUES ('1342','133','Atavillos Alto','1');
INSERT INTO distrito VALUES ('1343','133','Atavillos Bajo','1');
INSERT INTO distrito VALUES ('1344','133','Aucallama','1');
INSERT INTO distrito VALUES ('1345','133','Chancay','1');
INSERT INTO distrito VALUES ('1346','133','Ihuari','1');
INSERT INTO distrito VALUES ('1347','133','Lampian','1');
INSERT INTO distrito VALUES ('1348','133','Pacaraos','1');
INSERT INTO distrito VALUES ('1349','133','San Miguel de Acos','1');
INSERT INTO distrito VALUES ('1350','133','Santa Cruz de Andamarca','1');
INSERT INTO distrito VALUES ('1351','133','Sumbilca','1');
INSERT INTO distrito VALUES ('1352','133','Veintisiete de Noviembre','1');
-- Lima - Huarochirí (134)
INSERT INTO distrito VALUES ('1353','134','Matucana','1');
INSERT INTO distrito VALUES ('1354','134','Antioquia','1');
INSERT INTO distrito VALUES ('1355','134','Callahuanca','1');
INSERT INTO distrito VALUES ('1356','134','Carampoma','1');
INSERT INTO distrito VALUES ('1357','134','Chicla','1');
INSERT INTO distrito VALUES ('1358','134','Cuenca','1');
INSERT INTO distrito VALUES ('1359','134','Huachupampa','1');
INSERT INTO distrito VALUES ('1360','134','Huanza','1');
INSERT INTO distrito VALUES ('1361','134','Huarochiri','1');
INSERT INTO distrito VALUES ('1362','134','Lahuaytambo','1');
INSERT INTO distrito VALUES ('1363','134','Langa','1');
INSERT INTO distrito VALUES ('1364','134','Laraos','1');
INSERT INTO distrito VALUES ('1365','134','Mariatana','1');
INSERT INTO distrito VALUES ('1366','134','Ricardo Palma','1');
INSERT INTO distrito VALUES ('1367','134','San Andrés de Tupicocha','1');
INSERT INTO distrito VALUES ('1368','134','San Antonio','1');
INSERT INTO distrito VALUES ('1369','134','San Bartolomé','1');
INSERT INTO distrito VALUES ('1370','134','San Damian','1');
INSERT INTO distrito VALUES ('1371','134','San Juan de Iris','1');
INSERT INTO distrito VALUES ('1372','134','San Juan de Tantaranche','1');
INSERT INTO distrito VALUES ('1373','134','San Lorenzo de Quinti','1');
INSERT INTO distrito VALUES ('1374','134','San Mateo','1');
INSERT INTO distrito VALUES ('1375','134','San Mateo de Otao','1');
INSERT INTO distrito VALUES ('1376','134','San Pedro de Casta','1');
INSERT INTO distrito VALUES ('1377','134','San Pedro de Huancayre','1');
INSERT INTO distrito VALUES ('1378','134','Sangallaya','1');
INSERT INTO distrito VALUES ('1379','134','Santa Cruz de Cocachacra','1');
INSERT INTO distrito VALUES ('1380','134','Santa Eulalia','1');
INSERT INTO distrito VALUES ('1381','134','Santiago de Anchucaya','1');
INSERT INTO distrito VALUES ('1382','134','Santiago de Tuna','1');
INSERT INTO distrito VALUES ('1383','134','Santo Domingo de Los Olleros','1');
INSERT INTO distrito VALUES ('1384','134','Surco','1');
-- Lima - Huaura (135)
INSERT INTO distrito VALUES ('1385','135','Huacho','1');
INSERT INTO distrito VALUES ('1386','135','Ambar','1');
INSERT INTO distrito VALUES ('1387','135','Caleta de Carquín','1');
INSERT INTO distrito VALUES ('1388','135','Checras','1');
INSERT INTO distrito VALUES ('1389','135','Hualmay','1');
INSERT INTO distrito VALUES ('1390','135','Huaura','1');
INSERT INTO distrito VALUES ('1391','135','Leoncio Prado','1');
INSERT INTO distrito VALUES ('1392','135','Paccho','1');
INSERT INTO distrito VALUES ('1393','135','Santa Leonor','1');
INSERT INTO distrito VALUES ('1394','135','Santa María','1');
INSERT INTO distrito VALUES ('1395','135','Sayan','1');
INSERT INTO distrito VALUES ('1396','135','Vegueta','1');
-- Lima - Oyón (136)
INSERT INTO distrito VALUES ('1397','136','Oyon','1');
INSERT INTO distrito VALUES ('1398','136','Andajes','1');
INSERT INTO distrito VALUES ('1399','136','Caujul','1');
INSERT INTO distrito VALUES ('1400','136','Cochamarca','1');
INSERT INTO distrito VALUES ('1401','136','Navan','1');
INSERT INTO distrito VALUES ('1402','136','Pachangara','1');
-- Lima - Yauyos (137)
INSERT INTO distrito VALUES ('1403','137','Yauyos','1');
INSERT INTO distrito VALUES ('1404','137','Alis','1');
INSERT INTO distrito VALUES ('1405','137','Allauca','1');
INSERT INTO distrito VALUES ('1406','137','Ayaviri','1');
INSERT INTO distrito VALUES ('1407','137','Azángaro','1');
INSERT INTO distrito VALUES ('1408','137','Cacra','1');
INSERT INTO distrito VALUES ('1409','137','Carania','1');
INSERT INTO distrito VALUES ('1410','137','Catahuasi','1');
INSERT INTO distrito VALUES ('1411','137','Chocos','1');
INSERT INTO distrito VALUES ('1412','137','Cochas','1');
INSERT INTO distrito VALUES ('1413','137','Colonia','1');
INSERT INTO distrito VALUES ('1414','137','Hongos','1');
INSERT INTO distrito VALUES ('1415','137','Huampara','1');
INSERT INTO distrito VALUES ('1416','137','Huancaya','1');
INSERT INTO distrito VALUES ('1417','137','Huangascar','1');
INSERT INTO distrito VALUES ('1418','137','Huantan','1');
INSERT INTO distrito VALUES ('1419','137','Huañec','1');
INSERT INTO distrito VALUES ('1420','137','Laraos','1');
INSERT INTO distrito VALUES ('1421','137','Lincha','1');
INSERT INTO distrito VALUES ('1422','137','Madean','1');
INSERT INTO distrito VALUES ('1423','137','Miraflores','1');
INSERT INTO distrito VALUES ('1424','137','Omas','1');
INSERT INTO distrito VALUES ('1425','137','Putinza','1');
INSERT INTO distrito VALUES ('1426','137','Quinches','1');
INSERT INTO distrito VALUES ('1427','137','Quinocay','1');
INSERT INTO distrito VALUES ('1428','137','San Joaquín','1');
INSERT INTO distrito VALUES ('1429','137','San Pedro de Pilas','1');
INSERT INTO distrito VALUES ('1430','137','Tanta','1');
INSERT INTO distrito VALUES ('1431','137','Tauripampa','1');
INSERT INTO distrito VALUES ('1432','137','Tomas','1');
INSERT INTO distrito VALUES ('1433','137','Tupe','1');
INSERT INTO distrito VALUES ('1434','137','Viñac','1');
INSERT INTO distrito VALUES ('1435','137','Vitis','1');

-- Loreto - Maynas (138)
INSERT INTO distrito VALUES ('1436','138','Iquitos','1');
INSERT INTO distrito VALUES ('1437','138','Alto Nanay','1');
INSERT INTO distrito VALUES ('1438','138','Fernando Lores','1');
INSERT INTO distrito VALUES ('1439','138','Indiana','1');
INSERT INTO distrito VALUES ('1440','138','Las Amazonas','1');
INSERT INTO distrito VALUES ('1441','138','Mazan','1');
INSERT INTO distrito VALUES ('1442','138','Napo','1');
INSERT INTO distrito VALUES ('1443','138','Punchana','1');
INSERT INTO distrito VALUES ('1444','138','Torres Causana','1');
INSERT INTO distrito VALUES ('1445','138','Belén','1');
INSERT INTO distrito VALUES ('1446','138','San Juan Bautista','1');
-- Loreto - Alto Amazonas (139)
INSERT INTO distrito VALUES ('1447','139','Yurimaguas','1');
INSERT INTO distrito VALUES ('1448','139','Balsapuerto','1');
INSERT INTO distrito VALUES ('1449','139','Jeberos','1');
INSERT INTO distrito VALUES ('1450','139','Lagunas','1');
INSERT INTO distrito VALUES ('1451','139','Santa Cruz','1');
INSERT INTO distrito VALUES ('1452','139','Teniente Cesar López Rojas','1');
-- Loreto - Loreto (140)
INSERT INTO distrito VALUES ('1453','140','Nauta','1');
INSERT INTO distrito VALUES ('1454','140','Parinari','1');
INSERT INTO distrito VALUES ('1455','140','Tigre','1');
INSERT INTO distrito VALUES ('1456','140','Trompeteros','1');
INSERT INTO distrito VALUES ('1457','140','Urarinas','1');
-- Loreto - Mariscal Ramón Castilla (141)
INSERT INTO distrito VALUES ('1458','141','Ramón Castilla','1');
INSERT INTO distrito VALUES ('1459','141','Pebas','1');
INSERT INTO distrito VALUES ('1460','141','Yavari','1');
INSERT INTO distrito VALUES ('1461','141','San Pablo','1');
-- Loreto - Requema (142)
INSERT INTO distrito VALUES ('1462','142','Requena','1');
INSERT INTO distrito VALUES ('1463','142','Alto Tapiche','1');
INSERT INTO distrito VALUES ('1464','142','Capelo','1');
INSERT INTO distrito VALUES ('1465','142','Emilio San Martín','1');
INSERT INTO distrito VALUES ('1466','142','Maquia','1');
INSERT INTO distrito VALUES ('1467','142','Puinahua','1');
INSERT INTO distrito VALUES ('1468','142','Saquena','1');
INSERT INTO distrito VALUES ('1469','142','Soplin','1');
INSERT INTO distrito VALUES ('1470','142','Tapiche','1');
INSERT INTO distrito VALUES ('1471','142','Jenaro Herrera','1');
INSERT INTO distrito VALUES ('1472','142','Yaquerana','1');
-- Loreto - Ucayali (143)
INSERT INTO distrito VALUES ('1473','143','Contamana','1');
INSERT INTO distrito VALUES ('1474','143','Inahuaya','1');
INSERT INTO distrito VALUES ('1475','143','Padre Márquez','1');
INSERT INTO distrito VALUES ('1476','143','Pampa Hermosa','1');
INSERT INTO distrito VALUES ('1477','143','Sarayacu','1');
INSERT INTO distrito VALUES ('1478','143','Vargas Guerra','1');
-- Loreto - Datem del Marañón (144)
INSERT INTO distrito VALUES ('1479','144','Barranca','1');
INSERT INTO distrito VALUES ('1480','144','Cahuapanas','1');
INSERT INTO distrito VALUES ('1481','144','Manseriche','1');
INSERT INTO distrito VALUES ('1482','144','Morona','1');
INSERT INTO distrito VALUES ('1483','144','Pastaza','1');
INSERT INTO distrito VALUES ('1484','144','Andoas','1');
-- Loreto - Putumayo (145)
INSERT INTO distrito VALUES ('1485','145','Putumayo','1');
INSERT INTO distrito VALUES ('1486','145','Rosa Panduro','1');
INSERT INTO distrito VALUES ('1487','145','Teniente Manuel Clavero','1');
INSERT INTO distrito VALUES ('1488','145','Yaguas','1');

-- Madre de Dios - Tambopata (146)
INSERT INTO distrito VALUES ('1489','146','Tambopata','1');
INSERT INTO distrito VALUES ('1490','146','Inambari','1');
INSERT INTO distrito VALUES ('1491','146','Las Piedras','1');
INSERT INTO distrito VALUES ('1492','146','Laberinto','1');
-- Madre de Dios - Manu (147)
INSERT INTO distrito VALUES ('1493','147','Manu','1');
INSERT INTO distrito VALUES ('1494','147','Fitzcarrald','1');
INSERT INTO distrito VALUES ('1495','147','Madre de Dios','1');
INSERT INTO distrito VALUES ('1496','147','Huepetuhe','1');
-- Madre de Dios - Tahuamanu (148)
INSERT INTO distrito VALUES ('1497','148','Iñapari','1');
INSERT INTO distrito VALUES ('1498','148','Iberia','1');
INSERT INTO distrito VALUES ('1499','148','Tahuamanu','1');

-- Moquegua - Mariscal Nieto (149)
INSERT INTO distrito VALUES ('1500','149','Moquegua','1');
INSERT INTO distrito VALUES ('1501','149','Carumas','1');
INSERT INTO distrito VALUES ('1502','149','Cuchumbaya','1');
INSERT INTO distrito VALUES ('1503','149','Samegua','1');
INSERT INTO distrito VALUES ('1504','149','San Cristóbal','1');
INSERT INTO distrito VALUES ('1505','149','Torata','1');
-- Moquegua - General Sánchez Cerro (150)
INSERT INTO distrito VALUES ('1506','150','Omate','1');
INSERT INTO distrito VALUES ('1507','150','Chojata','1');
INSERT INTO distrito VALUES ('1508','150','Coalaque','1');
INSERT INTO distrito VALUES ('1509','150','Ichuña','1');
INSERT INTO distrito VALUES ('1510','150','La Capilla','1');
INSERT INTO distrito VALUES ('1511','150','Lloque','1');
INSERT INTO distrito VALUES ('1512','150','Matalaque','1');
INSERT INTO distrito VALUES ('1513','150','Puquina','1');
INSERT INTO distrito VALUES ('1514','150','Quinistaquillas','1');
INSERT INTO distrito VALUES ('1515','150','Ubinas','1');
INSERT INTO distrito VALUES ('1516','150','Yunga','1');
-- Moquegua - Ilo (151)
INSERT INTO distrito VALUES ('1517','151','Ilo','1');
INSERT INTO distrito VALUES ('1518','151','El Algarrobal','1');
INSERT INTO distrito VALUES ('1519','151','Pacocha','1');

-- Pasco - Pasco (152)
INSERT INTO distrito VALUES ('1520','152','Chaupimarca','1');
INSERT INTO distrito VALUES ('1521','152','Huachon','1');
INSERT INTO distrito VALUES ('1522','152','Huariaca','1');
INSERT INTO distrito VALUES ('1523','152','Huayllay','1');
INSERT INTO distrito VALUES ('1524','152','Ninacaca','1');
INSERT INTO distrito VALUES ('1525','152','Pallanchacra','1');
INSERT INTO distrito VALUES ('1526','152','Paucartambo','1');
INSERT INTO distrito VALUES ('1527','152','San Francisco de Asís de Yarusyacan','1');
INSERT INTO distrito VALUES ('1528','152','Simón Bolívar','1');
INSERT INTO distrito VALUES ('1529','152','Ticlacayan','1');
INSERT INTO distrito VALUES ('1530','152','Tinyahuarco','1');
INSERT INTO distrito VALUES ('1531','152','Vicco','1');
INSERT INTO distrito VALUES ('1532','152','Yanacancha','1');
-- Pasco - Daniel Alcides Carrión (153)
INSERT INTO distrito VALUES ('1533','153','Yanahuanca','1');
INSERT INTO distrito VALUES ('1534','153','Chacayan','1');
INSERT INTO distrito VALUES ('1535','153','Goyllarisquizga','1');
INSERT INTO distrito VALUES ('1536','153','Paucar','1');
INSERT INTO distrito VALUES ('1537','153','San Pedro de Pillao','1');
INSERT INTO distrito VALUES ('1538','153','Santa Ana de Tusi','1');
INSERT INTO distrito VALUES ('1539','153','Tapuc','1');
INSERT INTO distrito VALUES ('1540','153','Vilcabamba','1');
-- Pasco - Oxapampa (154)
INSERT INTO distrito VALUES ('1541','154','Oxapampa','1');
INSERT INTO distrito VALUES ('1542','154','Chontabamba','1');
INSERT INTO distrito VALUES ('1543','154','Huancabamba','1');
INSERT INTO distrito VALUES ('1544','154','Palcazu','1');
INSERT INTO distrito VALUES ('1545','154','Pozuzo','1');
INSERT INTO distrito VALUES ('1546','154','Puerto Bermúdez','1');
INSERT INTO distrito VALUES ('1547','154','Villa Rica','1');
INSERT INTO distrito VALUES ('1548','154','Constitución','1');

-- Piura - Piura (155)
INSERT INTO distrito VALUES ('1549','155','Piura','1');
INSERT INTO distrito VALUES ('1550','155','Castilla','1');
INSERT INTO distrito VALUES ('1551','155','Atacaos','1');
INSERT INTO distrito VALUES ('1552','155','Cura Mori','1');
INSERT INTO distrito VALUES ('1553','155','El Tallan','1');
INSERT INTO distrito VALUES ('1554','155','La Arena','1');
INSERT INTO distrito VALUES ('1555','155','La Unión','1');
INSERT INTO distrito VALUES ('1556','155','Las Lomas','1');
INSERT INTO distrito VALUES ('1557','155','Tambo Grande','1');
INSERT INTO distrito VALUES ('1558','155','Veintiseis de Octubre','1');
-- Piura - Ayabaca (156)
INSERT INTO distrito VALUES ('1559','156','Ayabaca','1');
INSERT INTO distrito VALUES ('1560','156','Frias','1');
INSERT INTO distrito VALUES ('1561','156','Jilili','1');
INSERT INTO distrito VALUES ('1562','156','Lagunas','1');
INSERT INTO distrito VALUES ('1563','156','Montero','1');
INSERT INTO distrito VALUES ('1564','156','Pacaipampa','1');
INSERT INTO distrito VALUES ('1565','156','Paimas','1');
INSERT INTO distrito VALUES ('1566','156','Sapillica','1');
INSERT INTO distrito VALUES ('1567','156','Sicchez','1');
INSERT INTO distrito VALUES ('1568','156','Suyo','1');
-- Piura - Huancabamba (157)
INSERT INTO distrito VALUES ('1569','157','Huancabamba','1');
INSERT INTO distrito VALUES ('1570','157','Canchaque','1');
INSERT INTO distrito VALUES ('1571','157','El Carmen de la Frontera','1');
INSERT INTO distrito VALUES ('1572','157','Huarmaca','1');
INSERT INTO distrito VALUES ('1573','157','Lalaquiz','1');
INSERT INTO distrito VALUES ('1574','157','San Miguel de El Faique','1');
INSERT INTO distrito VALUES ('1575','157','Sondor','1');
INSERT INTO distrito VALUES ('1576','157','Sondorillo','1');
-- Piura - Morropón (158)
INSERT INTO distrito VALUES ('1577','158','Chulucanas','1');
INSERT INTO distrito VALUES ('1578','158','Buenos Aires','1');
INSERT INTO distrito VALUES ('1579','158','Chalaco','1');
INSERT INTO distrito VALUES ('1580','158','La Matanza','1');
INSERT INTO distrito VALUES ('1581','158','Morropon','1');
INSERT INTO distrito VALUES ('1582','158','Salitral','1');
INSERT INTO distrito VALUES ('1583','158','San Juan de Bigote','1');
INSERT INTO distrito VALUES ('1584','158','Santa Catalina de Mossa','1');
INSERT INTO distrito VALUES ('1585','158','Santo Domingo','1');
INSERT INTO distrito VALUES ('1586','158','Yamango','1');
-- Piura - Paita (159)
INSERT INTO distrito VALUES ('1587','159','Paita','1');
INSERT INTO distrito VALUES ('1588','159','Amotape','1');
INSERT INTO distrito VALUES ('1589','159','Arenal','1');
INSERT INTO distrito VALUES ('1590','159','Colan','1');
INSERT INTO distrito VALUES ('1591','159','La Huaca','1');
INSERT INTO distrito VALUES ('1592','159','Tamarindo','1');
INSERT INTO distrito VALUES ('1593','159','Vichayal','1');
-- Piura - Sullana (160)
INSERT INTO distrito VALUES ('1594','160','Sullana','1');
INSERT INTO distrito VALUES ('1595','160','Bellavista','1');
INSERT INTO distrito VALUES ('1596','160','Ignacio Escudero','1');
INSERT INTO distrito VALUES ('1597','160','Lancones','1');
INSERT INTO distrito VALUES ('1598','160','Marcavelica','1');
INSERT INTO distrito VALUES ('1599','160','Miguel Checa','1');
INSERT INTO distrito VALUES ('1600','160','Querecotillo','1');
INSERT INTO distrito VALUES ('1601','160','Salitral','1');
-- Piura - Talara (161)
INSERT INTO distrito VALUES ('1602','161','Pariñas','1');
INSERT INTO distrito VALUES ('1603','161','El Alto','1');
INSERT INTO distrito VALUES ('1604','161','La Brea','1');
INSERT INTO distrito VALUES ('1605','161','Lobitos','1');
INSERT INTO distrito VALUES ('1606','161','Los Organos','1');
INSERT INTO distrito VALUES ('1607','161','Mancora','1');
-- Piura - Sechura (162)
INSERT INTO distrito VALUES ('1608','162','Sechura','1');
INSERT INTO distrito VALUES ('1609','162','Bellavista de la Unión','1');
INSERT INTO distrito VALUES ('1610','162','Bernal','1');
INSERT INTO distrito VALUES ('1611','162','Cristo Nos Valga','1');
INSERT INTO distrito VALUES ('1612','162','Vice','1');
INSERT INTO distrito VALUES ('1613','162','Rinconada Llicuar','1');

-- Puno - Puno (163)
INSERT INTO distrito VALUES ('1614','163','Puno','1');
INSERT INTO distrito VALUES ('1615','163','Acora','1');
INSERT INTO distrito VALUES ('1616','163','Amantani','1');
INSERT INTO distrito VALUES ('1617','163','Atuncolla','1');
INSERT INTO distrito VALUES ('1618','163','Capachica','1');
INSERT INTO distrito VALUES ('1619','163','Chucuito','1');
INSERT INTO distrito VALUES ('1620','163','Coata','1');
INSERT INTO distrito VALUES ('1621','163','Huata','1');
INSERT INTO distrito VALUES ('1622','163','Mañazo','1');
INSERT INTO distrito VALUES ('1623','163','Paucarcolla','1');
INSERT INTO distrito VALUES ('1624','163','Pichacani','1');
INSERT INTO distrito VALUES ('1625','163','Plateria','1');
INSERT INTO distrito VALUES ('1626','163','San Antonio','1');
INSERT INTO distrito VALUES ('1627','163','Tiquillaca','1');
INSERT INTO distrito VALUES ('1628','163','Vilque','1');
-- Puno - Azángaro (164)
INSERT INTO distrito VALUES ('1629','164','Azángaro','1');
INSERT INTO distrito VALUES ('1630','164','Achaya','1');
INSERT INTO distrito VALUES ('1631','164','Arapa','1');
INSERT INTO distrito VALUES ('1632','164','Asillo','1');
INSERT INTO distrito VALUES ('1633','164','Caminaca','1');
INSERT INTO distrito VALUES ('1634','164','Chupa','1');
INSERT INTO distrito VALUES ('1635','164','José Domingo Choquehuanca','1');
INSERT INTO distrito VALUES ('1636','164','Muñani','1');
INSERT INTO distrito VALUES ('1637','164','Potoni','1');
INSERT INTO distrito VALUES ('1638','164','Saman','1');
INSERT INTO distrito VALUES ('1639','164','San Anton','1');
INSERT INTO distrito VALUES ('1640','164','San José','1');
INSERT INTO distrito VALUES ('1641','164','San Juan de Salinas','1');
INSERT INTO distrito VALUES ('1642','164','Santiago de Pupuja','1');
INSERT INTO distrito VALUES ('1643','164','Tirapata','1');
-- Puno - Carabaya (165)
INSERT INTO distrito VALUES ('1644','165','Macusani','1');
INSERT INTO distrito VALUES ('1645','165','Ajoyani','1');
INSERT INTO distrito VALUES ('1646','165','Ayapata','1');
INSERT INTO distrito VALUES ('1647','165','Coasa','1');
INSERT INTO distrito VALUES ('1648','165','Corani','1');
INSERT INTO distrito VALUES ('1649','165','Crucero','1');
INSERT INTO distrito VALUES ('1650','165','Ituata','1');
INSERT INTO distrito VALUES ('1651','165','Ollachea','1');
INSERT INTO distrito VALUES ('1652','165','San Gaban','1');
INSERT INTO distrito VALUES ('1653','165','Usicayos','1');
-- Puno - Chucuito (166)
INSERT INTO distrito VALUES ('1654','166','Juli','1');
INSERT INTO distrito VALUES ('1655','166','Desaguadero','1');
INSERT INTO distrito VALUES ('1656','166','Huacullani','1');
INSERT INTO distrito VALUES ('1657','166','Kelluyo','1');
INSERT INTO distrito VALUES ('1658','166','Pisacoma','1');
INSERT INTO distrito VALUES ('1659','166','Pomata','1');
INSERT INTO distrito VALUES ('1660','166','Zepita','1');
-- Puno - El Collao (167)
INSERT INTO distrito VALUES ('1661','167','Ilave','1');
INSERT INTO distrito VALUES ('1662','167','Capazo','1');
INSERT INTO distrito VALUES ('1663','167','Pilcuyo','1');
INSERT INTO distrito VALUES ('1664','167','Santa Rosa','1');
INSERT INTO distrito VALUES ('1665','167','Conduriri','1');
-- Puno - Huancané (168)
INSERT INTO distrito VALUES ('1666','168','Huancane','1');
INSERT INTO distrito VALUES ('1667','168','Cojata','1');
INSERT INTO distrito VALUES ('1668','168','Huatasani','1');
INSERT INTO distrito VALUES ('1669','168','Inchupalla','1');
INSERT INTO distrito VALUES ('1670','168','Pusi','1');
INSERT INTO distrito VALUES ('1671','168','Rosaspata','1');
INSERT INTO distrito VALUES ('1672','168','Taraco','1');
INSERT INTO distrito VALUES ('1673','168','Vilque Chico','1');
-- Puno - Lampa (169)
INSERT INTO distrito VALUES ('1674','169','Lampa','1');
INSERT INTO distrito VALUES ('1675','169','Cabanilla','1');
INSERT INTO distrito VALUES ('1676','169','Calapuja','1');
INSERT INTO distrito VALUES ('1677','169','Nicasio','1');
INSERT INTO distrito VALUES ('1678','169','Ocuviri','1');
INSERT INTO distrito VALUES ('1679','169','Palca','1');
INSERT INTO distrito VALUES ('1680','169','Paratia','1');
INSERT INTO distrito VALUES ('1681','169','Pucara','1');
INSERT INTO distrito VALUES ('1682','169','Santa Lucia','1');
INSERT INTO distrito VALUES ('1683','169','Vilavila','1');
-- Puno - Melgar (170)
INSERT INTO distrito VALUES ('1684','170','Ayaviri','1');
INSERT INTO distrito VALUES ('1685','170','Antauta','1');
INSERT INTO distrito VALUES ('1686','170','Cupi','1');
INSERT INTO distrito VALUES ('1687','170','Llalli','1');
INSERT INTO distrito VALUES ('1688','170','Macari','1');
INSERT INTO distrito VALUES ('1689','170','Nuñoa','1');
INSERT INTO distrito VALUES ('1690','170','Orurillo','1');
INSERT INTO distrito VALUES ('1691','170','Santa Rosa','1');
INSERT INTO distrito VALUES ('1692','170','Umachiri','1');
-- Puno - Moho (171)
INSERT INTO distrito VALUES ('1693','171','Moho','1');
INSERT INTO distrito VALUES ('1694','171','Conima','1');
INSERT INTO distrito VALUES ('1695','171','Huayrapata','1');
INSERT INTO distrito VALUES ('1696','171','Tilali','1');
-- Puno - San Antonio de Putina (172)
INSERT INTO distrito VALUES ('1697','172','Putina','1');
INSERT INTO distrito VALUES ('1698','172','Ananea','1');
INSERT INTO distrito VALUES ('1699','172','Pedro Vilca Apaza','1');
INSERT INTO distrito VALUES ('1700','172','Quilcapuncu','1');
INSERT INTO distrito VALUES ('1701','172','Sina','1');
-- Puno - San Román (173)
INSERT INTO distrito VALUES ('1702','173','Juliaca','1');
INSERT INTO distrito VALUES ('1703','173','Cabana','1');
INSERT INTO distrito VALUES ('1704','173','Cabanillas','1');
INSERT INTO distrito VALUES ('1705','173','Caracoto','1');
-- Puno - Sandia (174)
INSERT INTO distrito VALUES ('1706','174','Sandia','1');
INSERT INTO distrito VALUES ('1707','174','Cuyocuyo','1');
INSERT INTO distrito VALUES ('1708','174','Limbani','1');
INSERT INTO distrito VALUES ('1709','174','Patambuco','1');
INSERT INTO distrito VALUES ('1710','174','Phara','1');
INSERT INTO distrito VALUES ('1711','174','Quiaca','1');
INSERT INTO distrito VALUES ('1712','174','San Juan del Oro','1');
INSERT INTO distrito VALUES ('1713','174','Yanahuaya','1');
INSERT INTO distrito VALUES ('1714','174','Alto Inambari','1');
INSERT INTO distrito VALUES ('1715','174','San Pedro de Putina Punco','1');
-- Puno - Yunguyo (175)
INSERT INTO distrito VALUES ('1716','175','Yunguyo','1');
INSERT INTO distrito VALUES ('1717','175','Anapia','1');
INSERT INTO distrito VALUES ('1718','175','Copani','1');
INSERT INTO distrito VALUES ('1719','175','Cuturapi','1');
INSERT INTO distrito VALUES ('1720','175','Ollaraya','1');
INSERT INTO distrito VALUES ('1721','175','Tinicachi','1');
INSERT INTO distrito VALUES ('1722','175','Unicachi','1');

-- San Martín - Moyobamba (176)
INSERT INTO distrito VALUES ('1723','176','Moyobamba','1');
INSERT INTO distrito VALUES ('1724','176','Calzada','1');
INSERT INTO distrito VALUES ('1725','176','Habana','1');
INSERT INTO distrito VALUES ('1726','176','Jepelacio','1');
INSERT INTO distrito VALUES ('1727','176','Soritor','1');
INSERT INTO distrito VALUES ('1728','176','Yantalo','1');
-- San Martín - Bellavista (177)
INSERT INTO distrito VALUES ('1729','177','Bellavista','1');
INSERT INTO distrito VALUES ('1730','177','Alto Biavo','1');
INSERT INTO distrito VALUES ('1731','177','Bajo Biavo','1');
INSERT INTO distrito VALUES ('1732','177','Huallaga','1');
INSERT INTO distrito VALUES ('1733','177','San Pablo','1');
INSERT INTO distrito VALUES ('1734','177','San Rafael','1');
-- San Martín - El Dorado (178)
INSERT INTO distrito VALUES ('1735','178','San José de Sisa','1');
INSERT INTO distrito VALUES ('1736','178','Agua Blanca','1');
INSERT INTO distrito VALUES ('1737','178','San Martín','1');
INSERT INTO distrito VALUES ('1738','178','Santa Rosa','1');
INSERT INTO distrito VALUES ('1739','178','Shatoja','1');
-- San Martín - Huallaga (179)
INSERT INTO distrito VALUES ('1740','179','Saposoa','1');
INSERT INTO distrito VALUES ('1741','179','Alto Saposoa','1');
INSERT INTO distrito VALUES ('1742','179','El Eslabón','1');
INSERT INTO distrito VALUES ('1743','179','Piscoyacu','1');
INSERT INTO distrito VALUES ('1744','179','Sacanche','1');
INSERT INTO distrito VALUES ('1745','179','Tingo de Saposoa','1');
-- San Martín - Lamas (180)
INSERT INTO distrito VALUES ('1746','180','Lamas','1');
INSERT INTO distrito VALUES ('1747','180','Alonso de Alvarado','1');
INSERT INTO distrito VALUES ('1748','180','Barranquita','1');
INSERT INTO distrito VALUES ('1749','180','Caynarachi','1');
INSERT INTO distrito VALUES ('1750','180','Cuñumbuqui','1');
INSERT INTO distrito VALUES ('1751','180','Pinto Recodo','1');
INSERT INTO distrito VALUES ('1752','180','Rumisapa','1');
INSERT INTO distrito VALUES ('1753','180','San Roque de Cumbaza','1');
INSERT INTO distrito VALUES ('1754','180','Shanao','1');
INSERT INTO distrito VALUES ('1755','180','Tabalosos','1');
INSERT INTO distrito VALUES ('1756','180','Zapatero','1');
-- San Martín - Mariscal Cáceres (181)
INSERT INTO distrito VALUES ('1757','181','Juanjuí','1');
INSERT INTO distrito VALUES ('1758','181','Campanilla','1');
INSERT INTO distrito VALUES ('1759','181','Huicungo','1');
INSERT INTO distrito VALUES ('1760','181','Pachiza','1');
INSERT INTO distrito VALUES ('1761','181','Pajarillo','1');
-- San Martín - Picota (182)
INSERT INTO distrito VALUES ('1762','182','Picota','1');
INSERT INTO distrito VALUES ('1763','182','Buenos Aires','1');
INSERT INTO distrito VALUES ('1764','182','Caspisapa','1');
INSERT INTO distrito VALUES ('1765','182','Pilluana','1');
INSERT INTO distrito VALUES ('1766','182','Pucacaca','1');
INSERT INTO distrito VALUES ('1767','182','San Cristóbal','1');
INSERT INTO distrito VALUES ('1768','182','San Hilarión','1');
INSERT INTO distrito VALUES ('1769','182','Shamboyacu','1');
INSERT INTO distrito VALUES ('1770','182','Tingo de Ponasa','1');
INSERT INTO distrito VALUES ('1771','182','Tres Unidos','1');
-- San Martín - Rioja (183)
INSERT INTO distrito VALUES ('1772','183','Rioja','1');
INSERT INTO distrito VALUES ('1773','183','Awajun','1');
INSERT INTO distrito VALUES ('1774','183','Elías Soplin Vargas','1');
INSERT INTO distrito VALUES ('1775','183','Nueva Cajamarca','1');
INSERT INTO distrito VALUES ('1776','183','Pardo Miguel','1');
INSERT INTO distrito VALUES ('1777','183','Posic','1');
INSERT INTO distrito VALUES ('1778','183','San Fernando','1');
INSERT INTO distrito VALUES ('1779','183','Yorongos','1');
INSERT INTO distrito VALUES ('1780','183','Yuracyacu','1');
-- San Martín - San Martín (184)
INSERT INTO distrito VALUES ('1781','184','Tarapoto','1');
INSERT INTO distrito VALUES ('1782','184','Alberto Leveau','1');
INSERT INTO distrito VALUES ('1783','184','Cacatachi','1');
INSERT INTO distrito VALUES ('1784','184','Chazuta','1');
INSERT INTO distrito VALUES ('1785','184','Chipurana','1');
INSERT INTO distrito VALUES ('1786','184','El Porvenir','1');
INSERT INTO distrito VALUES ('1787','184','Huimbayoc','1');
INSERT INTO distrito VALUES ('1788','184','Juan Guerra','1');
INSERT INTO distrito VALUES ('1789','184','La Banda de Shilcayo','1');
INSERT INTO distrito VALUES ('1790','184','Morales','1');
INSERT INTO distrito VALUES ('1791','184','Papaplaya','1');
INSERT INTO distrito VALUES ('1792','184','San Antonio','1');
INSERT INTO distrito VALUES ('1793','184','Sauce','1');
INSERT INTO distrito VALUES ('1794','184','Shapaja','1');
-- San Martín - Tocache (185)
INSERT INTO distrito VALUES ('1795','185','Tocache','1');
INSERT INTO distrito VALUES ('1796','185','Nuevo Progreso','1');
INSERT INTO distrito VALUES ('1797','185','Polvora','1');
INSERT INTO distrito VALUES ('1798','185','Shunte','1');
INSERT INTO distrito VALUES ('1799','185','Uchiza','1');

-- Tacna - Tacna (186)
INSERT INTO distrito VALUES ('1800','186','Tacna','1');
INSERT INTO distrito VALUES ('1801','186','Alto de la Alianza','1');
INSERT INTO distrito VALUES ('1802','186','Calana','1');
INSERT INTO distrito VALUES ('1803','186','Ciudad Nueva','1');
INSERT INTO distrito VALUES ('1804','186','Coronel Gregorio Albarracín Lanchipa','1');
INSERT INTO distrito VALUES ('1805','186','Inclan','1');
INSERT INTO distrito VALUES ('1806','186','La Yarada-Los Palos','1');
INSERT INTO distrito VALUES ('1807','186','Pachia','1');
INSERT INTO distrito VALUES ('1808','186','Palca','1');
INSERT INTO distrito VALUES ('1809','186','Pocollay','1');
INSERT INTO distrito VALUES ('1810','186','Sama','1');
-- Tacna - Candarave (187)
INSERT INTO distrito VALUES ('1811','187','Candarave','1');
INSERT INTO distrito VALUES ('1812','187','Cairani','1');
INSERT INTO distrito VALUES ('1813','187','Camilaca','1');
INSERT INTO distrito VALUES ('1814','187','Curibaya','1');
INSERT INTO distrito VALUES ('1815','187','Huanuara','1');
INSERT INTO distrito VALUES ('1816','187','Quilahuani','1');
-- Tacna - Jorge Basadre (188)
INSERT INTO distrito VALUES ('1817','188','Locumba','1');
INSERT INTO distrito VALUES ('1818','188','Ilabaya','1');
INSERT INTO distrito VALUES ('1819','188','Ite','1');
-- Tacna - Tarata (189)
INSERT INTO distrito VALUES ('1820','189','Tarata','1');
INSERT INTO distrito VALUES ('1821','189','Héroes Albarracín','1');
INSERT INTO distrito VALUES ('1822','189','Estique','1');
INSERT INTO distrito VALUES ('1823','189','Estique-Pampa','1');
INSERT INTO distrito VALUES ('1824','189','Sitajara','1');
INSERT INTO distrito VALUES ('1825','189','Susapaya','1');
INSERT INTO distrito VALUES ('1826','189','Tarucachi','1');
INSERT INTO distrito VALUES ('1827','189','Ticaco','1');

-- Tumbes - Tumbes (190)
INSERT INTO distrito VALUES ('1828','190','Tumbes','1');
INSERT INTO distrito VALUES ('1829','190','Corrales','1');
INSERT INTO distrito VALUES ('1830','190','La Cruz','1');
INSERT INTO distrito VALUES ('1831','190','Pampas de Hospital','1');
INSERT INTO distrito VALUES ('1832','190','San Jacinto','1');
INSERT INTO distrito VALUES ('1833','190','San Juan de la Virgen','1');
-- Tumbes - Contralmirante Villar (191)
INSERT INTO distrito VALUES ('1834','191','Zorritos','1');
INSERT INTO distrito VALUES ('1835','191','Casitas','1');
INSERT INTO distrito VALUES ('1836','191','Canoas de Punta Sal','1');
-- Tumbes - Zarumilla (192)
INSERT INTO distrito VALUES ('1837','192','Zarumilla','1');
INSERT INTO distrito VALUES ('1838','192','Aguas Verdes','1');
INSERT INTO distrito VALUES ('1839','192','Matapalo','1');
INSERT INTO distrito VALUES ('1840','192','Papayal','1');

-- Ucayali - Coronel Portillo (193)
INSERT INTO distrito VALUES ('1841','193','Calleria','1');
INSERT INTO distrito VALUES ('1842','193','Campoverde','1');
INSERT INTO distrito VALUES ('1843','193','Iparia','1');
INSERT INTO distrito VALUES ('1844','193','Masisea','1');
INSERT INTO distrito VALUES ('1845','193','Yarinacocha','1');
INSERT INTO distrito VALUES ('1846','193','Nueva Requena','1');
INSERT INTO distrito VALUES ('1847','193','Manantay','1');
-- Ucayali - Atalaya (194)
INSERT INTO distrito VALUES ('1848','194','Raymondi','1');
INSERT INTO distrito VALUES ('1849','194','Sepahua','1');
INSERT INTO distrito VALUES ('1850','194','Tahuania','1');
INSERT INTO distrito VALUES ('1851','194','Yurua','1');
-- Ucayali - Padre Abad (195)
INSERT INTO distrito VALUES ('1852','195','Padre Abad','1');
INSERT INTO distrito VALUES ('1853','195','Irazola','1');
INSERT INTO distrito VALUES ('1854','195','Curimana','1');
INSERT INTO distrito VALUES ('1855','195','Neshuya','1');
INSERT INTO distrito VALUES ('1856','195','Alexander Von Humboldt','1');
-- Ucayali - Purús (196)
INSERT INTO distrito VALUES ('1857','196','Purús','1');

-- SELECT * FROM distrito;
-- SELECT * FROM persona WHERE estado = "1";
-- SELECT * FROM usuario;
-- SELECT * FROM alumno;

/*select 
	departamento.iddepartamento,
	provincia.idprovincia,
	persona.idpersona,
	distrito.iddistrito,
	persona.nombres,
	persona.apellidopa,
	persona.apellidoma,
	persona.fecha_nacimiento,
	persona.sexo,
	persona.dni,
	persona.telefono,
	persona.correo,
	persona.estado
from persona inner join distrito on
	persona.iddistrito = distrito.iddistrito inner join provincia on
	distrito.idprovincia = provincia.idprovincia inner join departamento on
	provincia.iddepartamento = departamento.iddepartamento
where persona.idpersona = '1'; */

/* select 
	departamento.iddepartamento,
	provincia.idprovincia,
	alumno.idalumno,
	persona.idpersona,
	distrito.iddistrito,
	alumno.descripcion,
	alumno.estado
from alumno inner join persona on
	alumno.idpersona = persona.idpersona inner join distrito on
	alumno.iddistrito = distrito.iddistrito inner join provincia on
	distrito.idprovincia = provincia.idprovincia inner join departamento on
	provincia.iddepartamento = departamento.iddepartamento
where alumno.idalumno = '1'; */

INSERT INTO persona VALUES ('1','984','Diana Carolina','Acharte','Moreyra','1993-01-01','F','10000001','100000001','ejemplo1@hotmail.com','1');
INSERT INTO persona VALUES ('2','984','Vanesa','Amanza','Solis','1978-01-01','F','10000002','100000002','ejemplo2@hotmail.com','1');
INSERT INTO persona VALUES ('3','984','Ángel Jesús','Avalos','Carbajal','1990-01-01','M','10000003','100000003','ejemplo3@hotmail.com','1');
INSERT INTO persona VALUES ('4','984','Andrea','Chavez','Arana','1995-01-01','F','10000004','100000004','ejemplo4@hotmail.com','1');
INSERT INTO persona VALUES ('5','984','Carlos','Contreras','Pachas','1990-01-01','M','10000005','100000005','ejemplo5@hotmail.com','1');
INSERT INTO persona VALUES ('6','984','Tracy Geovanna','Cordova','Medina','1983-01-01','F','10000006','100000006','ejemplo6@hotmail.com','1');
INSERT INTO persona VALUES ('7','984','Rosa María','Cordova','Talla','1981-01-01','F','10000007','100000007','ejemplo7@hotmail.com','1');
INSERT INTO persona VALUES ('8','984','Elizabeth','Huahuatico','Charca','1987-01-01','F','10000008','100000008','ejemplo8@hotmail.com','1');
INSERT INTO persona VALUES ('9','984','María Lizbeth','La Madrid','Farias','1996-01-01','F','10000009','100000009','ejemplo9@hotmail.com','1');
INSERT INTO persona VALUES ('10','984','Ediht Jaqueline','Magallanes','Gonzales','1982-01-01','F','10000010','100000010','ejemplo10@hotmail.com','1');
INSERT INTO persona VALUES ('11','984','Yenifer Suimayda','Manrique','Saldaña','1988-01-01','F','10000011','100000011','ejemplo11@hotmail.com','1');
INSERT INTO persona VALUES ('12','984','Alvaro','Martinez','Barriga','1993-01-01','M','10000012','100000012','ejemplo12@hotmail.com','1');
INSERT INTO persona VALUES ('13','984','María','Martinez','Villa','1990-01-01','F','10000013','100000013','ejemplo13@hotmail.com','1');
INSERT INTO persona VALUES ('14','984','Paola','Mogrovejo','Ormeño','1989-01-01','F','10000014','100000014','ejemplo14@hotmail.com','1');
INSERT INTO persona VALUES ('15','984','Alex Alberto','Mucushua','Azang','1971-01-01','M','10000015','100000015','ejemplo15@hotmail.com','1');
INSERT INTO persona VALUES ('16','984','Eder Wilber','Nestarez','Martinez','1982-01-01','M','10000016','100000016','ejemplo16@hotmail.com','1');
INSERT INTO persona VALUES ('17','984','Juan Manuel','Pachas','Cueva','1981-01-01','M','10000017','100000017','ejemplo17@hotmail.com','1');
INSERT INTO persona VALUES ('18','984','Vidal Nelly','Pacheco','Paredes','1987-01-01','F','10000018','100000018','ejemplo18@hotmail.com','1');
INSERT INTO persona VALUES ('19','984','Nataly Katerin','Ramos','Falcon','1992-01-01','F','10000019','100000019','ejemplo19@hotmail.com','1');
INSERT INTO persona VALUES ('20','984','Ambar','Rojas','Martinez','1987-01-01','M','10000020','100000020','ejemplo20@hotmail.com','1');
INSERT INTO persona VALUES ('21','984','Alcides','Romo','Mansilla','1992-01-01','M','10000021','100000021','ejemplo21@hotmail.com','1');
INSERT INTO persona VALUES ('22','984','Freddy','Rosas','Donayre','1995-01-01','M','10000022','100000022','ejemplo22@hotmail.com','1');
INSERT INTO persona VALUES ('23','984','Yessica','Soto','Mendoza','1990-01-01','F','10000023','100000023','ejemplo23@hotmail.com','1');
INSERT INTO persona VALUES ('24','984','Diana Shirley','Tipián','Donayre','1977-01-01','F','10000024','100000024','ejemplo24@hotmail.com','1');
INSERT INTO persona VALUES ('25','984','Yuliana','Torres','Ayllon','1987-01-01','F','10000025','100000025','ejemplo25@hotmail.com','1');
INSERT INTO persona VALUES ('26','984','Nancy','Turuco','Quispe','1994-01-01','F','10000026','100000026','ejemplo26@hotmail.com','1');
INSERT INTO persona VALUES ('27','984','Marianella','Ventura','Vera','1987-01-01','F','10000027','100000027','ejemplo27@hotmail.com','1');
INSERT INTO persona VALUES ('28','984','Lisbeth Stefanny','Vicerrel','Perez','1978-01-01','F','10000028','100000028','ejemplo28@hotmail.com','1');
INSERT INTO persona VALUES ('29','984','Jhon','Yataco','Almeyda','1985-01-01','M','10000029','100000029','ejemplo29@hotmail.com','1');
INSERT INTO persona VALUES ('30','984','Luiggi Yax','Molina','Tipián','1995-12-17','M','70075788','956474298','luiggie_2005@hotmail.com','1');



-- DELETE FROM persona WHERE idpersona = 33;

-- select * from persona;


INSERT INTO personal VALUES ('1','30','Administrador','1');




INSERT INTO usuario VALUES ('1','1','LuiggiYax','123456','b','1');




INSERT INTO alumno VALUES ('1','1','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('2','2','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('3','3','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('4','4','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('5','5','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('6','6','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('7','7','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('8','8','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('9','9','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('10','10','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('11','11','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('12','12','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('13','13','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('14','14','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('15','15','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('16','16','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('17','17','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('18','18','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('19','19','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('20','20','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('21','21','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('22','22','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('23','23','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('24','24','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('25','25','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('26','26','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('27','27','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('28','28','984','Interesado en Ofimática Básica','1');
INSERT INTO alumno VALUES ('29','29','984','Interesado en Ofimática Básica','1');



INSERT INTO curso VALUES ('1','Microsoft Office 2013','Básico','1');
INSERT INTO curso VALUES ('2','Diseño Gráfico Publicitario','Básico','1');
INSERT INTO curso VALUES ('3','Ensamblaje de PC','Básico','1');
INSERT INTO curso VALUES ('4','Desarrollador de Aplicaciones','Básico','1');
INSERT INTO curso VALUES ('5','Diseño Web Interactivo','Básico','1');
INSERT INTO curso VALUES ('6','Diseñador CAD','Básico','1');
INSERT INTO curso VALUES ('7','Aula Multimedia Educativa','Básico','1');




INSERT INTO horario VALUES ('1','N°1064-05','N°1416-06','A1','','1');




INSERT INTO grupo VALUES ('1','1','1','N°01926-2013','2013','Noche','Única','180h','2013-01-01','2013-06-01','1','1');




INSERT INTO matricula VALUES ('1','1','1','142591700045-13','20','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('2','2','1','142591700046-13','35','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('3','3','1','142591700047-13','23','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('4','4','1','142591700048-13','18','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('5','5','1','142591700049-13','23','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('6','6','1','142591700050-13','30','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('7','7','1','142591700051-13','32','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('8','8','1','142591700052-13','26','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('9','9','1','142591700053-13','17','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('10','10','1','142591700054-13','31','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('11','11','1','142591700055-13','25','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('12','12','1','142591700056-13','20','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('13','13','1','142591700057-13','23','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('14','14','1','142591700058-13','24','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('15','15','1','142591700059-13','42','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('16','16','1','142591700060-13','31','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('17','17','1','142591700061-13','32','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('18','18','1','142591700062-13','26','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('19','19','1','142591700063-13','21','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('20','20','1','142591700064-13','26','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('21','21','1','142591700065-13','21','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('22','22','1','142591700066-13','18','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('23','23','1','142591700067-13','23','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('24','24','1','142591700068-13','35','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('25','25','1','142591700069-13','26','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('26','26','1','142591700070-13','19','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('27','27','1','142591700071-13','26','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('28','28','1','142591700072-13','35','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');
INSERT INTO matricula VALUES ('29','29','1','142591700073-13','28','lugar ejemplo','Estudiante','No','Soltero','2013-01-01','P','1');


/*
INSERT INTO nota VALUES ('1','1','1° Unidad','15','2013-02-01','1');
INSERT INTO nota VALUES ('2','1','2° Unidad','16','2013-02-15','1');
INSERT INTO nota VALUES ('3','1','3° Unidad','14','2013-03-01','1');
INSERT INTO nota VALUES ('4','1','4° Unidad','15','2013-03-15','1');
INSERT INTO nota VALUES ('5','1','5° Unidad','16','2013-04-01','1');
INSERT INTO nota VALUES ('6','1','6° Unidad','17','2013-04-15','1');
INSERT INTO nota VALUES ('7','1','7° Unidad','18','2013-05-01','1');
INSERT INTO nota VALUES ('8','2','1° Unidad','15','2013-02-01','1');
INSERT INTO nota VALUES ('9','2','2° Unidad','16','2013-02-15','1');
INSERT INTO nota VALUES ('10','2','3° Unidad','14','2013-03-01','1');
INSERT INTO nota VALUES ('11','2','4° Unidad','15','2013-03-15','1');
INSERT INTO nota VALUES ('12','2','5° Unidad','16','2013-04-01','1');
INSERT INTO nota VALUES ('13','2','6° Unidad','17','2013-04-15','1');
INSERT INTO nota VALUES ('14','2','7° Unidad','18','2013-05-01','1');
INSERT INTO nota VALUES ('15','3','1° Unidad','15','2013-02-01','1');
INSERT INTO nota VALUES ('16','3','2° Unidad','16','2013-02-15','1');
INSERT INTO nota VALUES ('17','3','3° Unidad','14','2013-03-01','1');
INSERT INTO nota VALUES ('18','3','4° Unidad','15','2013-03-15','1');
INSERT INTO nota VALUES ('19','3','5° Unidad','16','2013-04-01','1');
INSERT INTO nota VALUES ('20','3','6° Unidad','17','2013-04-15','1');
INSERT INTO nota VALUES ('21','3','7° Unidad','18','2013-05-01','1');
INSERT INTO nota VALUES ('22','4','1° Unidad','15','2013-02-01','1');
INSERT INTO nota VALUES ('23','4','2° Unidad','16','2013-02-15','1');
INSERT INTO nota VALUES ('24','4','3° Unidad','14','2013-03-01','1');
INSERT INTO nota VALUES ('25','4','4° Unidad','15','2013-03-15','1');
INSERT INTO nota VALUES ('26','4','5° Unidad','16','2013-04-01','1');
INSERT INTO nota VALUES ('27','4','6° Unidad','17','2013-04-15','1');
INSERT INTO nota VALUES ('28','4','7° Unidad','18','2013-05-01','1');
INSERT INTO nota VALUES ('29','5','1° Unidad','15','2013-02-01','1');
INSERT INTO nota VALUES ('30','5','2° Unidad','16','2013-02-15','1');
INSERT INTO nota VALUES ('31','5','3° Unidad','14','2013-03-01','1');
INSERT INTO nota VALUES ('32','5','4° Unidad','15','2013-03-15','1');
INSERT INTO nota VALUES ('33','5','5° Unidad','16','2013-04-01','1');
INSERT INTO nota VALUES ('34','5','6° Unidad','17','2013-04-15','1');
INSERT INTO nota VALUES ('35','5','7° Unidad','18','2013-05-01','1');*/