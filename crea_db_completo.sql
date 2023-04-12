DROP SCHEMA IF EXISTS PBCC;
CREATE SCHEMA IF NOT EXISTS PBCC DEFAULT CHARACTER SET utf8;
USE PBCC;


---------------------------------
-- CREATE TABLE AreaGeografica 
---------------------------------
DROP TABLE IF EXISTS `AreaGeografica`;
CREATE TABLE `AreaGeografica` (
    `Nome` VARCHAR(45) NOT NULL, 
    PRIMARY KEY (`Nome`)
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE Edificio 
---------------------------------
DROP TABLE IF EXISTS `Edificio`;
CREATE TABLE `Edificio` (
    `CodEdificio` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Tipologia` VARCHAR(45) NOT NULL,
    `DataRealizzazione` DATE NULL,
    `StatoEdificio` INT UNSIGNED NULL, -- NON è un bool?
    `Latitudine` DECIMAL(9,6) UNSIGNED NOT NULL,
    `Longitudine` DECIMAL(9,6) UNSIGNED NOT NULL,
	`AreaGeografica` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`CodEdificio`),
    INDEX `fk_Edificio_AreaGeografica_idx` (`AreaGeografica` ASC) VISIBLE,
    CONSTRAINT chk_coords CHECK (Latitudine between -90 and 90 and Longitudine between -180 and 180),
    CONSTRAINT `fk_Edificio_AreaGeografica`
        FOREIGN KEY (`AreaGeografica`) REFERENCES `AreaGeografica` (`Nome`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE Rischio 
---------------------------------
DROP TABLE IF EXISTS `Rischio`;
CREATE TABLE `Rischio` (
    `CodRischio` INT UNSIGNED NOT NULL ,
    `Tipo` VARCHAR(255) NOT NULL,
    `Coefficiente` DECIMAL(2,1) UNSIGNED NOT NULL,
    PRIMARY KEY (`CodRischio`)
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE Calamità
---------------------------------
DROP TABLE IF EXISTS `Calamita`;
CREATE TABLE `Calamita` (
	`AreaGeografica` VARCHAR(45) NOT NULL,
    `Tipologia` VARCHAR(255) NOT NULL,
    `Data` DATE NOT NULL,
    `LivelloIntensita` DECIMAL(4,1) UNSIGNED NOT NULL,
    `Longitudine` DECIMAL(9,6) UNSIGNED NOT NULL,
    `Latitudine` DECIMAL(9,6) UNSIGNED NOT NULL,
    PRIMARY KEY (AreaGeografica, Tipologia, Data, LivelloIntensita),
    INDEX `fk_Calamita_idx`(`AreaGeografica` ASC) VISIBLE,
    CONSTRAINT `fk_Calamita`
        FOREIGN KEY (`AreaGeografica`) 
        REFERENCES `AreaGeografica` (`Nome`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION 
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE Piano 
---------------------------------
DROP TABLE IF EXISTS `Piano`;
CREATE TABLE `Piano` (
    `Edificio` INT UNSIGNED NOT NULL,
    `NumeroPiano` INT UNSIGNED NOT NULL,
    `Area` DECIMAL(5,2) UNSIGNED NOT NULL,
    `Perimetro` DECIMAL(5,2) UNSIGNED NOT NULL,
    PRIMARY KEY (Edificio, NumeroPiano),
    INDEX `fk_Piano_Edificio_idx` (`Edificio` ASC) VISIBLE,
    CONSTRAINT `fk_Piano_Edificio`
        FOREIGN KEY (`Edificio`) 
        REFERENCES `Edificio` (`CodEdificio`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE Funzione (del Vano)
---------------------------------
DROP TABLE IF EXISTS `Funzione`;
CREATE TABLE `Funzione` (
    `Nome` VARCHAR(45) NOT NULL, 
    PRIMARY KEY (`Nome`)
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE Vano 
---------------------------------
DROP TABLE IF EXISTS `Vano`;
CREATE TABLE `Vano` (
    `CodVano` INT NOT NULL ,
    `LarghezzaMax` DECIMAL(4,2)NOT NULL,
    `LungezzaMax` DECIMAL(4,2) NOT NULL,
    `AltezzaMax` DECIMAL(4,2) NULL,
    `Piano` INT UNSIGNED NOT NULL,
    `Edificio` INT UNSIGNED NOT NULL,
    `Funzione` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`CodVano`),
    INDEX `fk_Vano_Piano_idx` (`Edificio` ASC, `Piano` ASC) VISIBLE,
    INDEX `fk_Vano_Funzione_idx` (`Funzione` ASC) VISIBLE,
    CONSTRAINT `fk_Vano_Piano`
        FOREIGN KEY (`Edificio`, `Piano`) 
        REFERENCES `Piano` (`Edificio`, `NumeroPiano`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Vano_Funzione`
        FOREIGN KEY (`Funzione`) 
        REFERENCES `Funzione`(`Nome`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE Muro 
---------------------------------
DROP TABLE IF EXISTS `Muro`;
CREATE TABLE `Muro` (
    `CodMuro` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
    `Lunghezza` DECIMAL(4,2) NOT NULL,
    PRIMARY KEY (`CodMuro`)
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE PuntoAccesso 
---------------------------------
DROP TABLE IF EXISTS `PuntoAccesso`;
CREATE TABLE `PuntoAccesso` (
    `CodPuntoAccesso` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `PuntoCardinale` VARCHAR(1) NOT NULL,
    `Tipologia` VARCHAR(45) NOT NULL,
    `Muro` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodPuntoAccesso`),
    INDEX `fk_PuntoAccesso_Muro_idx` (`Muro` ASC) VISIBLE,
    CONSTRAINT `fk_PuntoAccesso_Muro`
        FOREIGN KEY (`Muro`) 
        REFERENCES `Muro`(`CodMuro`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE Finstra 
---------------------------------
DROP TABLE IF EXISTS `Finestra`;
CREATE TABLE `Finestra` (
    `CodFinestra` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `PuntoCardinale` VARCHAR(2) NOT NULL,
    `Muro` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodFinestra`),
    INDEX `fk_Finestra_Muro_idx` (`Muro` ASC),
    CONSTRAINT `fk_Finestra_Muro`
        FOREIGN KEY (`Muro`) 
        REFERENCES `Muro`(`CodMuro`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE Sensore 
---------------------------------
DROP TABLE IF EXISTS `Sensore`;
CREATE TABLE `Sensore`(
    `CodSensore` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Tipologia` VARCHAR(45) NOT NULL,
    `Longitudine` DECIMAL(9,6) UNSIGNED NOT NULL,
    `Latitudine` DECIMAL(9,6) UNSIGNED NOT NULL,
    `Soglia` FLOAT NOT NULL,
    `Muro` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodSensore`),
    INDEX `fk_Sensore_Muro_idx` (`Muro` ASC) VISIBLE,
    CONSTRAINT `fk_Sensore_Muro`
        FOREIGN KEY (`Muro`) 
        REFERENCES `Muro`(`CodMuro`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE MisuraMonovalore 
---------------------------------
DROP TABLE IF EXISTS `MisuraMonovalore`;
CREATE TABLE `MisuraMonovalore`(
    `Sensore` INT UNSIGNED NOT NULL,
    `TimeStamp` TIMESTAMP NOT NULL,
    `Valore` DECIMAL(5,2) UNSIGNED NULL,
    PRIMARY KEY(`Sensore`, `TimeStamp`),
    INDEX `fk_MisuraMonovalore_Sensore_idx` (`Sensore` ASC),
    CONSTRAINT `fk_MisuraMonovalore_Sensore`
        FOREIGN KEY(`Sensore`) 
        REFERENCES `Sensore`(`CodSensore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE MisuraTrivalore 
---------------------------------
DROP TABLE IF EXISTS `MisuraTrivalore`;
CREATE TABLE `MisuraTrivalore`(
    `Sensore` INT UNSIGNED NOT NULL,
    `TimeStamp` TIMESTAMP NOT NULL,
    `ValoreX` DECIMAL(5,2) UNSIGNED,
    `ValoreY` DECIMAL(5,2) UNSIGNED,
    `ValoreZ` DECIMAL(5,2) UNSIGNED,
    PRIMARY KEY(`Sensore`, `TimeStamp`),
    INDEX `fk_MisuraTrivalore_Sensore_idx` (`Sensore` ASC),
    CONSTRAINT `fk_Misuratrivalore_Sensore`
        FOREIGN KEY(`Sensore`)
        REFERENCES `Sensore`(`CodSensore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


---------------------------------
-- CREATE TABLE Alert
---------------------------------
DROP TABLE IF EXISTS `Alert`;/*
CREATE TABLE `Alert` (
    `CodAlert` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Sensore`
    `TimeStamp` TIMESTAMP NOT NULL,
    `MisuraMonovalore` TIMESTAMP NULL,
    `MisuraTrivalore` TIMESTAMP NULL,
    PRIMARY KEY (`CodAlert`),
    INDEX `fk_Alert_MisuraMonovalore_idx` (`MisuraMonovalore` ASC),
    INDEX `fk_Alert_MisuraTrivalore_idx` (`MisuraTrivalore` ASC),
    CONSTRAINT `fk_Alert_MisuraMonovalore` -- Occhio a sta roba! Non mi convince!
        FOREIGN KEY (`MisuraMonovalore`) 
        REFERENCES `MisuraMonovalore`(`TimeStamp`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Alert_MisuraTrivalore`
        FOREIGN KEY (`MisuraTRivalore`) 
        REFERENCES `MisuraTrivalore`(`TimeStamp`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;
*/ 


---------------------------------
-- CREATE TABLE Progetto 
---------------------------------
DROP TABLE IF EXISTS `Progetto`;
CREATE TABLE IF NOT EXISTS `Progetto`(
    `CodProgetto` INT NOT NULL PRIMARY KEY,
    `Edificio` INT UNSIGNED NOT NULL,
    `DataPresentazione` DATE NOT NULL,
    `DataApprovazione`  DATE NOT NULL,
    `DataInizio` DATE NOT NULL,
    `StimaFine` DATE NOT NULL,
    `DataFine` DATE NOT NULL,
    `CostoProgetto` DECIMAL(10,2) NULL, 
    INDEX `fk_Progetto_Edificio_idx` (`Edificio` ASC) VISIBLE,
    CONSTRAINT `fk_Progetto_Edificio`
        FOREIGN KEY (`Edificio`)
        REFERENCES `Edificio` (`CodEdificio`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;

---------------------------------
-- CREATE TABLE StatoAvanzamentoProgetto 
---------------------------------
DROP TABLE IF EXISTS `Materiale`;
CREATE TABLE `Materiale` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(45) NOT NULL,
    `DataAcquisto` DATE NOT NULL,
    `Quantita` INT UNSIGNED NOT NULL,
    `CostoLotto` DECIMAL(10,2) NULL NOT NULL,
    `Tipologia` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`)
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `Pietra`;
CREATE TABLE `Pietra` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(45) NOT NULL,
    `Tipo` VARCHAR(45) NOT NULL,
    `SuperficieMedia` FLOAT UNSIGNED NOT NULL,
    `PesoMedio` FLOAT UNSIGNED NOT NULL,
    `X` INT UNSIGNED NOT NULL,
    `Y` INT UNSIGNED NOT NULL,
    `Z` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`),
    INDEX `fk_Pietra_Materiale_idx`(`CodLotto` ASC,`Fornitore` ASC),
    CONSTRAINT `fk_Pietra_Materiale`
        FOREIGN KEY (`CodLotto`, `Fornitore`) 
        REFERENCES `Materiale`(`CodLotto`,`Fornitore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `Intonaco`;
CREATE TABLE `Intonaco` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(45) NOT NULL,
    `Tipo` VARCHAR(45) NOT NULL,
    `Spessore` FLOAT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`),
    INDEX `fk_Intonaco_Materiale_idx`(`CodLotto` ASC,`Fornitore` ASC),
    CONSTRAINT `fk_Intonaco_Materiale`
        FOREIGN KEY (`CodLotto`, `Fornitore`) 
        REFERENCES `Materiale`(`CodLotto`,`Fornitore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `Mattone`;
CREATE TABLE `Mattone` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(45) NOT NULL,
    `Alveolatura` VARCHAR(45) NOT NULL,
    `Composizione` VARCHAR(45) NOT NULL,
    `Isolante` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`),
    INDEX `fk_Mattone_Materiale_idx`(`CodLotto` ASC,`Fornitore` ASC),
    CONSTRAINT `fk_Mattone_Materiale`
        FOREIGN KEY (`CodLotto`, `Fornitore`) 
        REFERENCES `Materiale`(`CodLotto`,`Fornitore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `Piastrella`;
CREATE TABLE `Piastrella` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(45) NOT NULL,
    `Tipo` VARCHAR(45) NOT NULL,
    `Fuga` FLOAT UNSIGNED NOT NULL,
    `Materiale` VARCHAR(45) NOT NULL,
    `X` INT UNSIGNED NOT NULL,
    `Y` INT UNSIGNED NOT NULL,
    `Z` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`),
    INDEX `fk_Piastrella_Materiale_idx`(`CodLotto` ASC,`Fornitore` ASC),
    CONSTRAINT `fk_Piastrella_Materiale`
        FOREIGN KEY (`CodLotto`, `Fornitore`) 
        REFERENCES `Materiale`(`CodLotto`,`Fornitore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `MaterialeGenerico`;
CREATE TABLE `MaterialeGenerico` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(45) NOT NULL,
    `Descrizione` VARCHAR(255) NOT NULL,
    `Funzione` VARCHAR(45) NOT NULL,
    `X` INT UNSIGNED NOT NULL,
    `Y` INT UNSIGNED NOT NULL,
    `Z` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`),
    INDEX `fk_MaterialeGenerico_Materiale_idx`(`CodLotto` ASC,`Fornitore` ASC),
    CONSTRAINT `fk_MaterialeGenerico_Materiale`
        FOREIGN KEY (`CodLotto`, `Fornitore`) 
        REFERENCES `Materiale`(`CodLotto`,`Fornitore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


DROP TABLE IF EXISTS `Responsabile`;
CREATE TABLE IF NOT EXISTS `Responsabile` (
    `CodFiscale` CHAR(16) NOT NULL,
    `PagaProgetto`  FLOAT NOT NULL,
    PRIMARY KEY (`CodFiscale`)
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `StadioAvanzamentoProgetto`;
CREATE TABLE IF NOT EXISTS `StadioAvanzamentoProgetto`(
    `CodStadio` INT NOT NULL AUTO_INCREMENT,
    `Progetto` INT NOT NULL,
    `Responsabile` CHAR(16) NOT NULL,
    `DataCompletamento` DATE NULL,
    PRIMARY KEY (`CodStadio`, `Progetto`),
    INDEX `fk_Progetto_StadioAvanzamentoProgetto_idx` (`Progetto` ASC) VISIBLE,
    INDEX `fk_Responsabile_StadioAvanzamentoProgetto_idx` (`Responsabile` ASC) VISIBLE,
    CONSTRAINT `fk_Progetto_StadioAvanzamentoProgetto`
        FOREIGN KEY (`Progetto`)
        REFERENCES `Progetto`(`CodProgetto`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Responsabile_StadioAvanzamentoProgetto`
        FOREIGN KEY (`Responsabile`)
        REFERENCES `Responsabile`(`CodFiscale`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `Lavoro`;
CREATE TABLE IF NOT EXISTS `Lavoro` (
    `CodLavoro` INT NOT NULL AUTO_INCREMENT,
    `Stadio` INT NOT NULL,
    `DataInizio` DATE NULL,
    `DataFine` DATE NULL,
    `Descrizione` VARCHAR(255) NOT NULL,
    `MaxOperai` INT UNSIGNED NULL,
    PRIMARY KEY (`CodLavoro`),
    INDEX `fk_StadioAvanzamentoProgetto_Lavoro_idx` (`Stadio` ASC) VISIBLE,
    CONSTRAINT `fk_StadioAvanzamentoProgetto_Lavoro`
        FOREIGN KEY (`Stadio`)
        REFERENCES `StadioAvanzamentoProgetto`(`CodStadio`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


DROP TABLE IF EXISTS `CapoCantiere`;
CREATE TABLE IF NOT EXISTS `CapoCantiere` (
    `CodFiscale` CHAR(16) NOT NULL,
    `PagaOraria` FLOAT NOT NULL,
    `MaxOperai` INT UNSIGNED NULL,
    PRIMARY KEY (`CodFiscale`)/*,
    CONSTRAINT `fk_Turno_CapoCantiere1`
        FOREIGN KEY (`Lavoro`, `TimestampInizio`, `TimestampFine`)
        REFERENCES `Turno` (`Lavoro`,`TimestampInizio`, `TimestampFine`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION */
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `Lavoratore`;
CREATE TABLE IF NOT EXISTS `Lavoratore` (
    `CodFiscale` CHAR(16) NOT NULL,
    `PagaOraria` FLOAT NOT NULL,
    PRIMARY KEY (`CodFiscale`)
    /*,
    CONSTRAINT `fk_Turno_Lavoratore1`
        FOREIGN KEY (`Lavoro`, `TimestampInizio`, `TimestampFine`)
        REFERENCES `Turno` (`Lavoro`,`TimestampInizio`, `TimestampFine`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
    */
)
ENGINE = InnoDB;


DROP TABLE IF EXISTS `Turno`;
CREATE TABLE IF NOT EXISTS `Turno` (
    `TimestampInizio` DATETIME(3) NOT NULL,
    `TimestampFine` DATETIME(3) NOT NULL,
    `Lavoro` INT NOT NULL,
    `CapoCantiere` CHAR(16) NOT NULL,
    `Lavoratore` CHAR(16) NOT NULL,
    PRIMARY KEY (`TimestampInizio`, `TimestampFine`, `Lavoro`),
    INDEX `fk_Lavoro_Turno1+_idx` (`Lavoro` ASC ) VISIBLE,
    INDEX `fk_CapoCantiere_Turno_idx` (`CapoCantiere` ASC) VISIBLE,
    INDEX `fk_Lavoratore_Turno_idx` (`Lavoratore` ASC) VISIBLE,
    CONSTRAINT `fk_Lavoro_Turno`
        FOREIGN KEY (`Lavoro`)
        REFERENCES `Lavoro` (`CodLavoro`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_CapoCantiere_Turno`
        FOREIGN KEY (`CapoCantiere`)
        REFERENCES `CapoCantiere` (`CodFiscale`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Lavoratore_Turno`
        FOREIGN KEY (`Lavoratore`)
        REFERENCES `Lavoratore` (`CodFiscale`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;

/* Che è sta roba?
DROP TABLE IF EXISTS `AcquistoMateriale`;
CREATE TABLE `AcquistoMateriale` (
    `Lavoro` INT NOT NULL,
    `Materiale` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`Lavoro`, `Materiale`),
    INDEX `fk_Materiale_has_Lavoro_Lavoro1_idx` (`Lavoro` ASC) VISIBLE,
    INDEX `fk_Materiale_has_Lavoro_Materiale1_idx` (`Materiale` ASC) VISIBLE,
    CONSTRAINT `fk_Materiale_has_Lavoro_Lavoro1`
        FOREIGN KEY (`Lavoro`)
        REFERENCES `Materiale` (`CodLotto`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;
*/
