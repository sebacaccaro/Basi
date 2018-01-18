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

  PRIMARY KEY(Pokemon)
);

/*Creo Tabella Caratterizzazione*/
CREATE TABLE Caratterizzazione(
  Pokemon Smallint,
  Abilita VARCHAR(15),

  PRIMARY KEY(Pokemon,Abilita)
);

/*Creo Tabella Abilita*/
CREATE TABLE Abilita(
  Nome VARCHAR(10),
  Descrizione VARCHAR(50),

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
  Coefficiente Decimal(1,1) NOT NULL,

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
  ModalitaEvoluzione VARCHAR(20) NOT NULL DEFAULT "LevelUP",
  Livello TinyInt,

  PRIMARY KEY(PokemonEvoluto)
);

/*Creo Tabella Evoluzione da Zona*/
CREATE TABLE EvoluzioneDaZona(
  Pokemon Smallint,
  Zona Smallint,

  PRIMARY KEY(Pokemon,Zona)
);

/*Create Table Zona*/
CREATE TABLE Zona(
  ID SmallInt,
  Nome VARCHAR(30) NOT NULL,
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

ALTER TABLE EvoluzioneDaZona
  ADD CONSTRAINT PkEv FOREIGN KEY (Pokemon) REFERENCES Evoluzione(PokemonEvoluto),
  ADD CONSTRAINT EvZo FOREIGN KEY (Zona) REFERENCES Zona(ID);

ALTER TABLE Zona
  ADD CONSTRAINT Zon CHECK(ID >= 0);

ALTER TABLE Habitat
  ADD CONSTRAINT HaZo FOREIGN KEY (Zona) REFERENCES Zona(ID),
  ADD CONSTRAINT HASp FOREIGN KEY (Pokemon) REFERENCES SpeciePokemon(ID),
  ADD CONSTRAINT Ora CHECK(Orario IN ("Mattino","Giorno","Notte","Sempre"));

SET FOREIGN_KEY_CHECKS=1;
