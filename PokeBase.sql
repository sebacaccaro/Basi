SET FOREIGN_KEY_CHECKS = 0;

/*Creo Tabella SpeciePokemon Pokemon*/
CREATE TABLE SpeciePokemon(
  ID Smallint,
  Nome VARCHAR(15) NOT NULL,
  Descrizione VARCHAR(50),
  Altezza Smallint,
  Peso Int,
  Tipo1 VARCHAR(10) NOT NULL,
  Tipo2 VARCHAR(10),

  PRIMARY KEY(ID)

);

/*Creo Tabella Apprendimento*/
CREATE TABLE Apprendimento(
  Pokemon Smallint,
  Mossa VARCHAR(20) NOT NULL,
  Livello TinyInt NOT NULL,
  MetodoApprendimento VARCHAR(20) NOT NULL DEFAULT "LevelUP",

  PRIMARY KEY(Pokemon,Mossa)
);

/*Creo Tabella Caratterizzazione*/
CREATE TABLE Caratterizzazione(
  Pokemon Smallint,
  Abilita VARCHAR(15),

  PRIMARY KEY(Pokemon,Abilita)
);

/*Creo Tabella Abilita*/
CREATE TABLE Abilita(
  Nome VARCHAR(20),
  Descrizione VARCHAR(200),

  PRIMARY KEY (Nome)
);

/*Creo Tabella Tipo*/
CREATE TABLE Tipo(
  Nome VARCHAR(10),
  Descrizione VARCHAR(50),

  PRIMARY KEY (Nome)
);

/*Creo Tabella Efficacia*/
CREATE TABLE Efficacia(
  Attaccante VARCHAR(10),
  Difensore VARCHAR(10),
  Coefficiente Decimal(2,1) NOT NULL,

  PRIMARY KEY (Attaccante,Difensore)
);

/*Creo Tabella Mossa*/
CREATE TABLE Mossa(
  Nome VARCHAR(20),
  Potenza TinyInt NOT NULL DEFAULT 0,
  Categoria VARCHAR(8) NOT NULL,
  PPBase TinyInt NOT NULL,
  Descrizione VARCHAR(50),
  Precisione TinyInt,
  Utilitaria Boolean NOT NULL DEFAULT FALSE,
  MTMN VARCHAR(5),
  Tipo VARCHAR(10) NOT NULL,

  PRIMARY KEY (Nome)
);

/*Creo Tabella Evoluzione*/
CREATE TABLE Evoluzione(
  PokemonEvoluto Smallint,
  PokemonEvolvente Smallint NOT NULL,
  StatoEvoluzione TinyInt NOT NULL,
  ModalitaEvoluzione VARCHAR(40) NOT NULL DEFAULT "LevelUP",
  Livello TinyInt,

  PRIMARY KEY(PokemonEvoluto)
);


/*Create Table Zona*/
CREATE TABLE Zona(
  ID SmallInt,
  Nome VARCHAR(50) NOT NULL,
  Regione VARCHAR(30) NOT NULL,
  Descrizione VARCHAR(50),
  Morfologia VARCHAR(10),

  PRIMARY KEY (ID)
);

/*Creo Tabella Habitat*/
CREATE TABLE Habitat(
  Zona SmallInt,
  Orario VARCHAR(7) NOT NULL DEFAULT "Sempre",
  Pokemon SmallInt,

  PRIMARY KEY (Zona,Orario,Pokemon)
);


ALTER TABLE SpeciePokemon
  ADD CONSTRAINT SpTp1 FOREIGN KEY (Tipo1) REFERENCES Tipo(Nome),
  ADD CONSTRAINT SpTp2 FOREIGN KEY (Tipo2) REFERENCES Tipo(Nome),
  ADD CONSTRAINT Sp CHECK(ID > 0 AND Altezza > 0 AND Peso > 0);

ALTER TABLE Apprendimento
  ADD CONSTRAINT ApMo FOREIGN KEY (Mossa) REFERENCES Mossa(Nome),
  ADD CONSTRAINT Appr CHECK(Livello > 0 AND Livello < 100);

ALTER TABLE Caratterizzazione
  ADD CONSTRAINT CaSp FOREIGN KEY (Pokemon) REFERENCES SpeciePokemon(ID),
  ADD CONSTRAINT CaAb FOREIGN KEY (Abilita) REFERENCES Abilita(Nome);

ALTER TABLE Efficacia
  ADD CONSTRAINT AtTi FOREIGN KEY (Attaccante) REFERENCES Tipo(Nome),
  ADD CONSTRAINT DiTi FOREIGN KEY (Difensore) REFERENCES Tipo(Nome),
  ADD CONSTRAINT Eff CHECK(Coefficiente >= 0 AND MOD(Coefficiente,0.5) = 0);

ALTER TABLE Mossa
  ADD CONSTRAINT MoTi FOREIGN KEY (Tipo) REFERENCES Tipo(Nome),
  ADD CONSTRAINT Moss CHECK(Potenza >= 0 AND PPBase >= 0 AND Precisione >= 0);

ALTER TABLE Evoluzione
  ADD CONSTRAINT EVluto FOREIGN KEY (PokemonEvoluto) REFERENCES SpeciePokemon(ID),
  ADD CONSTRAINT EVente FOREIGN KEY (PokemonEvolvente) REFERENCES SpeciePokemon(ID),
  ADD CONSTRAINT Evo CHECK (StatoEvoluzione >= -1 AND StatoEvoluzione <= 4
                        AND Livello > 1);

ALTER TABLE Zona
  ADD CONSTRAINT Zon CHECK(ID >= 0);

ALTER TABLE Habitat
  ADD CONSTRAINT HaZo FOREIGN KEY (Zona) REFERENCES Zona(ID),
  ADD CONSTRAINT HASp FOREIGN KEY (Pokemon) REFERENCES SpeciePokemon(ID),
  ADD CONSTRAINT Ora CHECK(Orario IN ("Mattina","Giorno","Notte","Sempre"));

ALTER TABLE Tipo
  ADD CONSTRAINT lol FOREIGN KEY (Nome) REFERENCES Efficacia(Difensore);


/* Funzione 1 */
DELIMITER //
CREATE FUNCTION num_mosse(pkm varchar(15))
RETURNS tinyint
BEGIN
	DECLARE NumMosse tinyint;
	SELECT count(*) into NumMosse
	FROM SpeciePokemon as s JOIN Apprendimento as a on s.ID = a.Pokémon
	WHERE s.Nome = pkm;
	RETURN NumMosse;
END //

/* Funzione 2 */
DELIMITER //
CREATE FUNCTION pokeName(pkID smallint)
RETURNS VARCHAR(15)
BEGIN
	RETURN (SELECT Nome FROM SpeciePokemon AS s WHERE s.ID = pkID);
END //
DELIMITER ;

/* Funzione 3 */
DROP FUNCTION IF EXISTS maxEv;
DELIMITER //
CREATE FUNCTION maxEv(pkm VARCHAR(15))
RETURNS VARCHAR(15)
BEGIN
	DECLARE evPkm VARCHAR(15);
	DECLARE bPkm VARCHAR(15);
	SET evPkm = pkm;
	SET bPkm = pkm;
	WHILE evPkm IS NOT NULL DO
		SET evPkm = NULL;
		SELECT evoluto.Nome into evPkm
		FROM Evoluzione AS e JOIN SpeciePokemon AS base ON 
		e.PokemonEvolvente = base.ID left outer JOIN SpeciePokemon AS evoluto ON
		e.PokemonEvoluto = evoluto.ID
		WHERE base.Nome = bPkm
		LIMIT 1;
		if evPkm IS NOT NULL then set bPkm = evPkm; end if;
	end while;
	return bPkm;
END//
DELIMITER ;


/* Funzione 4 */
DELIMITER //
CREATE FUNCTION zoneName(znID smallint)
RETURNS VARCHAR(15)
BEGIN
	RETURN (SELECT Nome FROM Zona AS s WHERE s.ID = znID);
END //
DELIMITER ;


/* Vista 1 */
CREATE OR REPLACE VIEW ZonaPokemon AS
SELECT Pokemon as pkID, pokeName(Pokemon) as Pokémon, zoneName(Zona) as Zona, Orario
FROM Habitat
order by Pokemon;

/* Vista 2 */
CREATE OR REPLACE VIEW PokeMosse AS
SELECT p.Nome as Pokemon, m.Nome Mossa, m.Categoria as Categoria, m.Potenza as Potenza
FROM SpeciePokemon AS p JOIN Apprendimento AS a ON p.ID = a.Pokemon JOIN Mossa as m ON a.Mossa = m.Nome;


/* Query 1 */
CREATE OR REPLACE VIEW Query1 AS
SELECT pokeName(base.PokemonEvolvente) AS pkmBase, pokeName(base.PokemonEvoluto) AS prima, pokeName(ev.PokemonEvoluto) AS seconda 
FROM Evoluzione AS base JOIN Evoluzione AS ev on base.PokemonEvoluto = ev.PokemonEvolvente
WHERE ev.StatoEvoluzione = 2;

/* Query 2 */
/*CREATE OR REPLACE VIEW Query2 AS*/

/* Query 3 */
CREATE OR REPLACE VIEW Query3 AS
SELECT e1.Difensore AS Difensore1, e2.Difensore AS Difensore2, e1.Attaccante AS AttaccanteForte
FROM Efficacia AS e1 JOIN Efficacia AS e2 ON e1.Attaccante = e2.Attaccante
WHERE e1.Coefficiente = 2.0 AND e2.Coefficiente = 2.0 AND e1.Difensore > e2.Difensore;

/* Query 4 */
CREATE OR REPLACE VIEW Query4 AS
SELECT Nome
FROM SpeciePokemon
WHERE ID not in (
    SELECT pokemonEvolvente
    FROM Evoluzione )
    AND ID not in(
    SELECT pokemonEvoluto
    FROM Evoluzione 
    WHERE StatoEvoluzione <> 0 );

/* Query 5 */
CREATE OR REPLACE VIEW Query5 AS
SELECT Nome, count(e1.Coefficiente) as deboleVerso
FROM SpeciePokemon JOIN Efficacia AS e1 ON e1.Difensore = Tipo1 
JOIN Efficacia AS e2 on e2.Difensore = Tipo2 
JOIN Evoluzione AS ev ON ev.PokemonEvoluto =  SpeciePokemon.ID
WHERE e1.Coefficiente * e2.Coefficiente >1 AND ev.StatoEvoluzione = 2
GROUP BY Nome 
order by count(e1.coefficiente) desc
LIMIT 1;


/* Aux1 Query 6 */
CREATE OR REPLACE VIEW TipiHabitat AS 
SELECT distinct Zona, Pokemon, Tipo1 as Tipo
FROM Habitat JOIN SpeciePokemon ON Pokemon = ID
UNION
SELECT distinct Zona,Pokemon, Tipo2 as Tipo
FROM Habitat JOIN SpeciePokemon ON Pokemon = ID
WHERE Tipo2 IS NOT NULL;

/* Aux2 Query 6 */
CREATE OR REPLACE VIEW NumPokemonPerZona AS 
SELECT COUNT(Pokemon) as numPkm, Tipo, Zona
FROM TipiHabitat
GROUP BY Tipo, Zona;

/* Query 6 */
CREATE OR REPLACE VIEW Query6 AS
SELECT Tipo, Morfologia,max(numPkm)
FROM NumPokemonPerZona, Zona
WHERE NumPokemonPerZona.Zona = Zona.ID
GROUP BY Tipo
HAVING max(numPkm);


/* Query 7 */
CREATE OR REPLACE VIEW Query7 AS
SELECT S.Nome as PokemonEvoluto, S2.Nome as EvolveDa, E.ModalitaEvoluzione as Tramite
FROM Evoluzione as E JOIN SpeciePokemon as S JOIN SpeciePokemon as S2
ON E.PokemonEvoluto = S.ID
WHERE E.ModalitaEvoluzione like "Pietra%" AND
E.PokemonEvoluto = S.ID AND
E.PokemonEvolvente = S2.ID
ORDER BY S2.ID;




/* Popolamento Database*/
LOAD DATA LOCAL INFILE 'SpeciePokemon.txt' INTO TABLE SpeciePokemon;
LOAD DATA LOCAL INFILE 'Caratterizzazione.txt' INTO TABLE Caratterizzazione;
LOAD DATA LOCAL INFILE 'Apprendimento.txt' INTO TABLE Apprendimento;
LOAD DATA LOCAL INFILE 'Mossa.txt' INTO TABLE Mossa;
LOAD DATA LOCAL INFILE 'Abilita.txt' INTO TABLE Abilita;
LOAD DATA LOCAL INFILE 'Tipi.txt' INTO TABLE Tipo;
LOAD DATA LOCAL INFILE 'Efficacia.txt' INTO TABLE Efficacia;
LOAD DATA LOCAL INFILE 'Zona.txt' INTO TABLE Zona;
LOAD DATA LOCAL INFILE 'Evoluzione.txt' INTO TABLE Evoluzione;
LOAD DATA LOCAL INFILE 'Habitat.txt' INTO TABLE Habitat;


SET FOREIGN_KEY_CHECKS=1;
