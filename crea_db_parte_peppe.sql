DROP DATABASE IF EXISTS NomeProgetto;
CREATE DATABASE NomeProgetto;

USE NomeProgetto;

DROP TABLE IF EXISTS `Edificio`;
CREATE TABLE `Edificio` (
    `CodEdificio` INT UNSIGNED NOT NULL,
    `Tipologia` VARCHAR(255) NOT NULL,
    `DataRealizzazione` DATE NULL,
    `StatoEdificio` INT UNSIGNED NULL,
    `Latitudine` DECIMAL(9,6) UNSIGNED NOT NULL,
    `Longitudine` DECIMAL(9,6) UNSIGNED NOT NULL,
		`AreaGeografica` VARCHAR(255) not null,
    PRIMARY KEY (`CodEdificio`),
    INDEX `fk_Edificio_Ubicazione_idx` (`AreaGeografica` ASC),
    CONSTRAINT `fk_Edificio_Ubicazione`
        FOREIGN KEY (`AreaGeografica`) REFERENCES `AreaGeografica`(`Nome`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `AreaGeografica`;
CREATE TABLE `AreaGeografica` (
    `Nome` VARCHAR(255) NOT NULL, 
    PRIMARY KEY (`Nome`)
);

DROP TABLE IF EXISTS `Rischio`;
CREATE TABLE `Rischio` (
    `CodRischio` INT UNSIGNED NOT NULL ,
    `Tipo` VARCHAR(255) NOT NULL,
    `Coefficiente` DECIMAL(2,1) UNSIGNED NOT NULL,
    PRIMARY KEY (`CodRischio`)
);

DROP TABLE IF EXISTS `StoricoCalamità`;
CREATE TABLE `StoricoCalamità` (
    `AreaGeografica` INT UNSIGNED NOT NULL,
    `Tipologia` VARCHAR(255) NOT NULL,
    `Data` DATE NOT NULL,
    `LivelloIntensità` DECIMAL(4,1) UNSIGNED NOT NULL,
    `Longitudine` DECIMAL(9,6) UNSIGNED NOT NULL,
    `Latitudine` DECIMAL(9,6) UNSIGNED NULL,
    PRIMARY KEY (AreaGeografica, Tipologia, Data, LivelloIntensità),
    INDEX `fk_StoricoCalamità_idx`(`AreaGeografica`ASC),
    CONSTRAINT `fk_StoricoCalamità`
        FOREIGN KEY (`AreaGeografica`) REFERENCES `AreaGeografica` (`Nome`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION 
);

DROP TABLE IF EXISTS `Piano`;
CREATE TABLE `Piano` (
    `Edificio` INT UNSIGNED NOT NULL,
    `NumeroPiano` INT UNSIGNED NOT NULL,
    `Area` DECIMAL(5,2) UNSIGNED NOT NULL,
    `Perimetro` DECIMAL(5,2) UNSIGNED NOT NULL,
    PRIMARY KEY (Edificio, NumeroPiano),
    INDEX `fk_Piano_Edificio_idx` (`Edificio` ASC),
    CONSTRAINT `fk_Piano_Edificio`
        FOREIGN KEY (`Edificio`) REFERENCES `Edificio` (`CodEdificio`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `Vano`;
CREATE TABLE `Vano` (
    `CodVano` INT NOT NULL ,
    `LarghezzaMax` DECIMAL(4,2)NOT NULL,
    `LungezzaMax` DECIMAL(4,2) NOT NULL,
    `AltezzaMax` DECIMAL(4,2) NULL,
    `Piano` INT NOT NULL,
    `Edificio` INT NOT NULL,
    PRIMARY KEY (`CodVano`),
    INDEX `fk_Vano_Piano_idx` (`Piano` ASC, `Edificio`),
    INDEX `fk_Vano_Funzione_idx` (`Funzione` ASC),
    CONSTRAINT `fk_Vano_Piano`
        FOREIGN KEY (`Piano`, `Edificio`) REFERENCES `Piano` (`NumeroPiano`,`Edificio`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Vano_Funzione`
        FOREIGN KEY (`Funzione`) REFERENCES `Funzione`(`Nome`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `Funzione`;
CREATE TABLE `Funzione` (
    `Nome` VARCHAR(255) NOT NULL, 
    PRIMARY KEY (`Nome`)
);

DROP TABLE IF EXISTS `Muro`;
CREATE TABLE `Muro` (
    `CodMuro` INT UNSIGNED NOT NULL ,
    `Lunghezza` DECIMAL(4,2) NOT NULL,
    PRIMARY KEY (`CodMuro`)
);

DROP TABLE IF EXISTS `PuntoAccesso`;
CREATE TABLE `PuntoAccesso` (
    `CodPuntoAccesso` INT UNSIGNED NOT NULL ,
    `PuntoCardinale` VARCHAR(1) NOT NULL,
    `Tipologia` VARCHAR(255) NOT NULL,
    `Muro`INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodPuntoAccesso`),
    INDEX `fk_PuntoAccesso_Muro_idx` (`Muro` ASC)
    CONSTRAINT `fk_PuntoAccesso_Muro`
        FOREIGN KEY (`Muro`) REFERENCES `Muro`(`CodMuro`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `Finestra`;
CREATE TABLE `Finestra` (
    `CodFinestra` INT UNSIGNED NOT NULL ,
    `PuntoCardinale` VARCHAR(2) NOT NULL,
    `Muro` INT NOT NULL,
    PRIMARY KEY (`CodFinestra`),
    INDEX `fk_Finestra_Muro_idx` (`Muro` ASC),
    CONSTRAINT `fk_Finestra_Muro`
        FOREIGN KEY (`Muro`) REFERENCES `Muro`(`CodMuro`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `Sensore`;
CREATE TABLE `Sensore`(
    `CodSensore` INT NOT NULL ,
    `Tipologia` VARCHAR(255) NOT NULL,
    `Longitudine` DECIMAL(9,6) UNSIGNED NOT NULL,
    `Latitudine` DECIMAL(9,6) UNSIGNED NOT NULL,
    `Soglia` FLOAT NOT NULL,
    `Muro` INT NOT NULL,
    PRIMARY KEY (`CodSensore`),
    INDEX `fk_Sensore_Muro_idx` (`Muro` ASC),
    CONSTRAINT `fk_Sensore_Muro`
        FOREIGN KEY (`Muro`) REFERENCES `Muro`(`CodMuro`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `MisuraMonovalore`;
CREATE TABLE `MisuraMonovalore`(
    `Sensore` INT UNSIGNED NOT NULL,
    `TimeStamp` TIMESTAMP NOT NULL,
    `Valore` DECIMAL(5,2) UNSIGNED NULL,
    PRIMARY KEY(`Sensore`, `TimeStamp`),
    INDEX `fk_MisuraMonovalore_Sensore_idx` (`Sensore` ASC),
    CONSTRAINT `fk_MisuraMonovalore_Sensore`
        FOREIGN KEY(`Sensore`) REFERENCES `Sensore`(`CodSensore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

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
        FOREIGN KEY(`Sensore`) REFERENCES `Sensore`(`CodSensore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXIST `Alert`;
CREATE TABLE `Alert` (
    `CodAlert` INT UNSIGNED NOT NULL ,
    `TimeStamp` TIMESTAMP NOT NULL,
    `MisuraMonovalore` TIMESTAMP NULL,
    `MisuraTrivalore` TIMESTAMP NULL,
    PRIMARY KEY (`CodAlert`),
    INDEX `fk_Alert_MisuraMonovalore_idx` (`MisuraMonovalore` ASC),
    INDEX `fk_Alert_MisuraTrivalore_idx` (`MisuraTrivalore` ASC),
    CONSTRAINT `fk_Alert_MisuraMonovalore`
        FOREIGN KEY (`MisuraMonovalore`) REFERENCES `MisuraMonovalore`(`TimeStamp`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Alert_MisuraTrivalore`
        FOREIGN KEY (`MisuraTRivalore`) REFERENCES `MisuraTrivalore`(`TimeStamp`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `Materiale`;
CREATE TABLE `Materiale` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(255) NOT NULL,
    `DataAcquisto` DATE NOT NULL,
    `Quantità` INT UNSIGNED NOT NULL,
    `Tipologia` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`)
);

DROP TABLE IF EXISTS `Pietra`;
CREATE TABLE `Pietra` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(255) NOT NULL,
    `Tipo` VARCHAR(255) NOT NULL,
    `SuperficieMedia` FLOAT UNSIGNED NOT NULL,
    `PesoMedio` FLOAT UNSIGNED NOT NULL,
    `X` INT UNSIGNED NOT NULL,
    `Y` INT UNSIGNED NOT NULL,
    `Z` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`),
    INDEX `fk_Pietra_Materiale_idx`(`CodLotto` ASC,`Fornitore` ASC),
    CONSTRAINT `fk_Pietra_Materiale`
        FOREIGN KEY (`CodLotto`, `Fornitore`) REFERENCES `Materiale`(`CodLotto`,`Fornitore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `Intonaco`;
CREATE TABLE `Intonaco` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(255) NOT NULL,
    `Tipo` VARCHAR(255) NOT NULL,
    `Spessore` FLOAT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`),
    INDEX `fk_Intonaco_Materiale_idx`(`CodLotto` ASC,`Fornitore` ASC),
    CONSTRAINT `fk_Intonaco_Materiale`
        FOREIGN KEY (`CodLotto`, `Fornitore`) REFERENCES `Materiale`(`CodLotto`,`Fornitore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `Mattone`;
CREATE TABLE `Mattone` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(255) NOT NULL,
    `Alveolatura` VARCHAR(255) NOT NULL,
    `Composizione` VARCHAR(255) NOT NULL,
    `Isolante` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`),
    INDEX `fk_Mattone_Materiale_idx`(`CodLotto` ASC,`Fornitore` ASC),
    CONSTRAINT `fk_Mattone_Materiale`
        FOREIGN KEY (`CodLotto`, `Fornitore`) REFERENCES `Materiale`(`CodLotto`,`Fornitore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `Piastrella`;
CREATE TABLE `Piastrella` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(255) NOT NULL,
    `Tipo` VARCHAR(255) NOT NULL,
    `Fuga` FLOAT UNSIGNED NOT NULL,
    `Materiale` VARCHAR(255) NOT NULL,
    `X` INT UNSIGNED NOT NULL,
    `Y` INT UNSIGNED NOT NULL,
    `Z` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`),
    INDEX `fk_Piastrella_Materiale_idx`(`CodLotto` ASC,`Fornitore` ASC),
    CONSTRAINT `fk_Piastrella_Materiale`
        FOREIGN KEY (`CodLotto`, `Fornitore`) REFERENCES `Materiale`(`CodLotto`,`Fornitore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS `MaterialeGenerico`;
CREATE TABLE `MaterialeGenerico` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(255) NOT NULL,
    `Descrizione` VARCHAR(255) NOT NULL,
    `Funzione` VARCHAR(255) NOT NULL,
    `X` INT UNSIGNED NOT NULL,
    `Y` INT UNSIGNED NOT NULL,
    `Z` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`),
    INDEX `fk_MaterialeGenerico_Materiale_idx`(`CodLotto` ASC,`Fornitore` ASC),
    CONSTRAINT `fk_MaterialeGenerico_Materiale`
        FOREIGN KEY (`CodLotto`, `Fornitore`) REFERENCES `Materiale`(`CodLotto`,`Fornitore`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);