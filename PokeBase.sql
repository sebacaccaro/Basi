/*Creo dominio descrizione*/
CREATE DOMAIN Desc AS VARCHAR(50);


/*Creo Tabella SpeciePokemon Pokemon*/
CREATE TABLE SpeciePokemon(
  ID Smallint,
  Nome VARCHAR(15) NOT NULL,
  Descrizione Desc,
  Altezza Smallint,
  Peso Int,
  Tipo1 VARCHAR(10) NOT NULL,
  Tipo2 VARCHAR(10),

  CONSTRAINT Specie CHECK(ID > 0 AND Altezza > 0 AND Peso > 0)
)

/*Creo Tabella Apprendimento*/
CREATE TABLE Apprendimento(
  Pokemon Smallint,
  Mossa VARCHAR(20) NOT NULL,
  Livello TinyInt NOT NULL,
  MetodoApprendimento VARCHAR(20) NOT NULL DEFAULT "LevelUP",

  CONSTRAINT Appr CHECK(Livello > 0 AND Livello < 100)
)

/*Creo Tabella Caratterizzazione*/
CREATE TABLE Caratterizzazione(
  Pokemon Smallint,
  Abilita VARCHAR(15)
)

/*Creo Tabella Abilita*/
CREATE TABLE Abilita(
  Nome VARCHAR(10),
  Descrizione Desc
)

/*Creo Tabella Tipo*/
CREATE TABLE Tipo(
  Nome VARCHAR(10),
  Descrizione Desc
)

/*Creo Tabella Efficacia*/
CREATE TABLE Efficacia(
  Attaccante VARCHAR(10),
  Difensore VARCHAR(10),
  Coefficiente Decimal(1,1) NOT NULL,

  CONSTRAINT Eff CHECK(Coefficiente >= 0 AND MOD(Coefficiente,0.5) = 0)
)

/*Creo Tabella Mossa*/
CREATE TABLE Mossa(
  Nome VARCHAR(20),
  Potenza TinyInt NOT NULL DEFAULT 0,
  Categoria VARCHAR(8) NOT NULL,
  PPBase TinyInt NOT NULL,
  Descrizione Desc,
  Precisione TinyInt,
  Utilitaria Boolean NOT NULL DEFAULT FALSE,
  MTMN VARCHAR(5),
  Tipo VARCHAR(10) NOT NULL,

  CONSTRAINT Moss CHECK(Potenza >= 0 AND PPBase >= 0 AND Precisione >= 0)
)

/*Creo Tabella Evoluzione*/
CREATE TABLE Evoluzione(
  PokemonEvoluto Smallint,
  PokemonEvolvente Smallint NOT NULL,
  StatoEvoluzione TinyInt NOT NULL,
  ModalitaEvoluzione VARCHAR(20) NOT NULL DEFAULT "LevelUP",
  Livello TinyInt,

  CONSTRAINT Evo CHECK (StatoEvoluzione >= -1 AND StatoEvoluzione <= 4
                        AND Livello > 1)
)

/*Creo Tabella Evoluzione da Zona*/
CREATE TABLE EvoluzioneDaZona(
  Pokemon Smallint,
  Zona Smallint
)

/*Create Table Zona*/
CREATE TABLE Zona(
  ID SmallInt,
  Nome VARCHAR(30) NOT NULL,
  Regione VARCHAR(30) NOT NULL,
  Descrizione Desc,
  Morfologia VARCHAR(10),

  CONSTRAINT Zon CHECK(ID >= 0)
)

/*Creo Tabella Habitat*/
CREATE TABLE Habitat(
  Zona SmallInt,
  Orario VARCHAR(7) NOT NULL DEFAULT "Sempre",
  Pokemon SmallInt,

  CONSTRAINT Ora CHECK(Orario IN ("Mattino","Giorno","Notte","Sempre"))
)
