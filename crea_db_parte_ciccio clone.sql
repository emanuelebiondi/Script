DROP SCHEMA IF EXISTS PBCC;
CREATE SCHEMA IF NOT EXISTS PBCC DEFAULT CHARACTER SET utf8;
USE PBCC;

DROP TABLE IF EXISTS AreaGeografica;
CREATE TABLE IF NOT EXISTS AreaGeografica (
    Nome VARCHAR(45) NOT NULL,
    PRIMARY KEY (Nome)
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS Edificio;
CREATE TABLE IF NOT EXISTS Edificio (
    CodEdificio INT NOT NULL AUTO_INCREMENT,
    Tipologia VARCHAR(45) NOT NULL,
    DataRealizzazione DATE NULL,
    Latitudine DECIMAL(9,6) NOT NULL,
    Longitudine DECIMAL(9,6) NOT NULL,
    StatoEdificio VARCHAR(45) NULL,
		AreaGeografcia VARCHAR(45) NOT NULL,
    PRIMARY KEY (CodEdificio),
    INDEX fk_Edificio_AreaGeografica1_idx (AreaGeografica ASC) VISIBLE,
    CONSTRAINT chk_coords CHECK (Latitudine between -90 and 90 and Longitudine between -180 and 180),
    CONSTRAINT fk_Edificio_AreaGeografica1
        FOREIGN KEY (AreaGeografica)
        REFERENCES AreaGeografica (Nome)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS Progetto;
CREATE TABLE IF NOT EXISTS Progetto (
    CodProgetto INT NOT NULL PRIMARY KEY,
    DataPresentazione DATE NOT NULL,
    DataApprovazione DATE NOT NULL,
    DataInizio DATE NOT NULL,
    StimaFine DATE NOT NULL,
    DataFine DATE NOT NULL,
    CostoProgetto DECIMAL(10,2) NULL,
    INDEX fk_Progetto_Edificio1_idx (Edificio ASC) VISIBLE,
    CONSTRAINT fk_Progetto_Edificio1
        FOREIGN KEY (Edificio_rid)
        REFERENCES Edificio (CodEdificio)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS StoricoCalamita;
CREATE TABLE IF NOT EXISTS StoricoCalamita (
    LivelloIntensita INT NOT NULL,
    Tipologia VARCHAR(45) NOT NULL,
    Data DATE NOT NULL,
    Latitudine DECIMAL(9,6) NOT NULL,
    Longitudine DECIMAL(9,6) NOT NULL,
    PRIMARY KEY (LivelloIntensita, Tipologia, Data, AreaGeografica), 
    INDEX fk_AreaGeografica_StoricoCalamita1_idx (AreaGeograficaK ASC) VISIBLE,
    CONSTRAINT fk_AreaGeografica_StoricoCalamita1
        FOREIGN KEY (Areageografica)
        REFERENCES AreaGeografica (Nome)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT chk_coords CHECK (Latitudine between -90 and 90 and Long
