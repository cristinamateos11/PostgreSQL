/*

Ejercici 03 - PRIMERES PASSES. JOC
Cristina Mateos Paez

Crear una estructura de dades i taules per permetre la persistència
d'un joc de taula.

*/

-- DROP TABLE IF EXISTS jugadors;
-- DROP TYPE IF EXISTS categoria;
-- DROP TYPE IF EXISTS enter_positiu;
-- DROP TYPE IF EXISTS puntuacio;

-- 01. Els punts obtinguts sempre seran positius. Crear domini dels nombres sencers positius.

CREATE DOMAIN enter_positiu AS INTEGER CHECK (VALUE >= 0);

-- 02. Crear tipus de dada on guardar els punts i les penalitzacions.
-- Objecte compost amb 2 columnes

CREATE TYPE puntuacio AS (
	punts enter_positiu,
	penalitzacio enter_positiu
);

-- 03. Els jugadors només poden pertanyer a 1 de les categories (infantil, juvenil, senior)
-- llista etiquetes de text

CREATE TYPE categoria AS ENUM ('infantil', 'juvenil', 'sènior');

-- 04. Tipus de dada de negoci que aglutina info sobre diferents jugadors.

CREATE TABLE jugadors (
	nom VARCHAR(50),
	cat categoria,
	punt puntuacio
);

-- 05. Afegeix informacio a la base de dades. Qué observes?
	
	-- MÈTODE 1 (AMB ROW)
INSERT INTO jugadors VALUES ('Anna', 'infantil', ROW(12,2));
	-- MÈTODE 2 (SENSE ROW)
INSERT INTO jugadors VALUES ('Diego', 'sènior', (6,1));
	-- MÈTODE 3 (AMB COMETES)
INSERT INTO jugadors VALUES ('Luca', 'juvenil', '(10,3)');
	-- MÈTODE 4 (AMB CAMPS)
INSERT INTO jugadors (nom, cat, punt) 
	VALUES ('Elena','infantil', (9,1));
	
	-- Al fer aquestes 2 insercions dona els seguents ERRORS:
	
	-- 1r error: invalid input value for enum categoria: "peques"
INSERT INTO jugadors (nom, cat, punt)
	VALUES ('Lucia','peques', (6,0));

	-- 2n Error: value for domain enter_positiu violates check constraint "enter_positiu_check" 
INSERT INTO jugadors (nom, cat, punt)
	VALUES ('Sonia','infantil',(8,-1));
	
/*
La primera produeix un error ja que 'peques' no està en el tipus ENUM 'categoria'.
La segona produeix un error ja que -1 no és un enter positiu tal com hem definit en el domini 'enter_positiu'
*/

-- 06. Visualitzar tots els resultats ordenats per categoria. En quin ordre apareixen?

-- SELECT * FROM jugadors ORDER BY cat;
SELECT nom AS Jugador, 
	cat AS Categoria, 
	(punt).punts AS Puntuació, 
	(punt).penalitzacio AS Penalització 
FROM jugadors ORDER BY cat;

/*
Apareixen en aquest ordre: infantil, juvenil, senior.
*/

-- 07. Definir una funcio per obtenir puntuacio real d'un jugador. Rep com a parametre
-- un tipus compost (objecte) que conte punt i penalitzacio. Definit en el punt 2.
-- Retorna un sencer (resultat de restar punts - penalitzacio)
-- Fes una prova amb SELECT obtenir_puntuacio((3,1));

CREATE FUNCTION obtenir_puntuacio(obj_puntuacio puntuacio) RETURNS INTEGER AS $$
BEGIN
	RETURN obj_puntuacio.punts - obj_puntuacio.penalitzacio;
END;
$$ LANGUAGE plpgsql;

SELECT obtenir_puntuacio((3,1));

/*
CREATE FUNCTION obtenir_puntuacio(obj_puntuacio puntuacio) RETURNS INTEGER AS $$
DECLARE
    resultado INTEGER;
BEGIN
    resultado := obj_puntuacio.punts - obj_puntuacio.penalitzacio;
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;
*/


-- 08. Visualitza una taula amb 3 columnes (nom jugador, punts que porta, puntuacio real)

SELECT nom AS jugador,
	(punt).punts AS Puntuació,
	obtenir_puntuacio(punt) AS puntuacio_real
FROM jugadors;

-- 09. Mostra el nom del jugador amb mes punts per cada categoria

-- SELECT nom, cat, (punt).punts FROM jugadors ORDER BY (punt).punts DESC;
SELECT DISTINCT ON (cat) cat, nom, (punt).punts 
	FROM jugadors ORDER BY cat, (punt).punts DESC;

-- 10. Mostra el nom del jugador amb mes punts (independentment de la categoria)

SELECT nom FROM jugadors ORDER BY (punt).punts DESC LIMIT 1;

-- 11. Es correcte fer servir la seguent sentencia per donar el resultat de l'apartat 10?
-- Adapta jugador, resultado, puntuacion, puntos a la tva definicio de tipus

-- SELECT jugador FROM resultado ORDER BY (puntuacion).puntos DESC LIMIT 1;
/*
Depen, la sentencia no seria correcta en el contexte de la meva
definició de tipus i la meva estructura que he creat.
Ja que els punts jo els tinc a través de (punt).punts, accedeixo a punts
a través del tipus objecte compost puntuacio.
*/

-- 12. Mostra el nom del jugador amb una puntuacio de (6,1)

SELECT nom from jugadors WHERE punt = (6,1)::puntuacio;

