/*

Ejercici 01 - PRIMERES PASSES
Cristina Mateos Paez

*/

-- DROP TABLE IF EXISTS inventario;
-- DROP TYPE IF EXISTS producte;


-- 03. Crear tipus producte amb atributs nombre (varchar) i precio (monetari)

CREATE TYPE producte AS (
	nombre VARCHAR(50),
	precio MONEY
);

-- 04. Crear taula inventario amb columnes item (tipus producte) i cantidad (sencer)

CREATE TABLE inventario (
	item producte,
	cantidad INTEGER
);

-- 05. Inserir 8 registres amb els 4 mètodes

	-- Mètode 1 (AMB ROW)
INSERT INTO inventario VALUES (ROW('Lapiz',2.50),30);
INSERT INTO inventario VALUES (ROW('Goma',2),30);

	-- Mètode 2 (SENSE ROW)
INSERT INTO inventario VALUES (('Calculadora',60),50);
INSERT INTO inventario VALUES (('Calculadora Pro', 100),20);

	-- Mètode 3 (AMB COMETES)
INSERT INTO inventario VALUES ('("Pintura Rosa",5)',10);
INSERT INTO inventario VALUES ('("Pintura Azul",5)', 15);

	-- Mètode 4 (AMB CAMPS)
INSERT INTO inventario (item.nombre, item.precio, cantidad) VALUES ('Cartera',65,25);
INSERT INTO inventario (item.nombre, item.precio, cantidad) VALUES ('Pecera',300,2);

-- 06. Consultar les dades de l'inventari

SELECT * FROM inventario;

-- 07. Obtenir l'article amb el preu màxim

SELECT item FROM inventario ORDER BY (item).precio DESC LIMIT 1;

-- 08. Obtenir l'article que tingui la quantitat minima

SELECT item FROM inventario ORDER BY cantidad LIMIT 1;

-- 09. Obtenir productes amb preu superior a 60 (fer cast per convertir numero en money)

SELECT * FROM inventario WHERE (item).precio > 60::MONEY;

-- 10. Elimina el tipus de dades producto. I com afecta a la taula inventario.

-- DROP TYPE producte;

/*
No es pot eliminar el tipus producte mentre existeixi
la taula inventario que fa referencia al tipus producte.
Per eliminar el tipus producte primer s'ha d'eliminar la taula
inventario o canviar la columna item a un altre tipus.
*/

DROP TYPE producte CASCADE;

/*
En canvi, si volem eliminar el tipus producte junt amb tots
els objectes que depenen de ell, també s'eliminara de la taula
inventari. A la taula inventari doncs, s'eliminara el tipus producte també
i només mostra la cantidad.
*/

