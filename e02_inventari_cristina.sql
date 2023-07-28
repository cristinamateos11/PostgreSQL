/*

Ejercici 02 - PRIMERES PASSES. INVENTARI
Cristina Mateos Paez

*/

-- DROP TABLE IF EXISTS inventari;

-- 01. Taula amb tots els articles, preu i preu amb IVA.
CREATE TABLE inventari (
	id SERIAL PRIMARY KEY,
	nom VARCHAR(50),
	preu NUMERIC(5,2),
	iva NUMERIC(5,2) NOT NULL DEFAULT 21.00,
	stock INTEGER
);

	-- Per defecte, si no posem res, l'iva serà 21%
INSERT INTO inventari (nom, preu, stock) VALUES ('Taula',200,3);
INSERT INTO inventari (nom, preu, stock) VALUES ('Cadira',60,1);
INSERT INTO inventari (nom, preu, stock) VALUES ('Mirall',20,2);
INSERT INTO inventari (nom, preu, stock) VALUES ('Ordinador',600,10);

	-- Insertar iva del 4% i del 10%
INSERT INTO inventari (nom, preu, iva, stock) VALUES ('Pa',2,4,5);
INSERT INTO inventari (nom, preu, iva, stock) VALUES ('Carn',6,10,8);

SELECT * FROM inventari;

-- 02. Baixada Generalitzada de preus en un 7% sense modificar cadascun dels articles

	-- Baixada del 7% en el preu original
SELECT nom, preu, round(preu * (1 - 0.07),2) AS preu_descompte
FROM inventari;

	-- Baixada del 7% en el preu amb IVA
SELECT nom, preu, iva,
  ROUND(preu * (1 + (iva / 100)),2) AS preu_amb_iva,
  ROUND(preu * (1 + (iva / 100)) * (1 - 0.07), 2) AS preu_descompte
FROM inventari;

-- 03. Saber el nom dels articles que estan per sota de la quantitat de trencament stock (2 articles)

SELECT nom FROM inventari WHERE stock < 2;

-- 04. Obtenir taula amb nom i quantitat stock disponible

SELECT nom, stock FROM inventari;

-- 05. Obtenir nom dels articles que tenen stock per sobre de la mitja

SELECT nom FROM inventari WHERE stock > (SELECT AVG(stock) FROM inventari);
