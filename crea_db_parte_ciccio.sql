DROP SCHEMA IF EXISTS PBCC;
CREATE SCHEMA IF NOT EXISTS PBCC DEFAULT CHARACTER SET utf8;
USE PBCC;

DROP TABLE IF EXISTS `AreaGeografica`;
CREATE TABLE IF NOT EXISTS `AreaGeografica` (
    `Nome` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`Nome`)
)
ENGINE = InnoDB;


DROP TABLE IF EXISTS `Edificio`;
CREATE TABLE IF NOT EXISTS `Edificio` (
    `CodEdificio` INT NOT NULL AUTO_INCREMENT,
    `Tipologia` VARCHAR(45) NOT NULL,
    `DataRealizzazione` DATE NULL,
    `Latitudine`    DECIMAL(9,6) NOT NULL,
    `Longitudine`   DECIMAL(9,6) NOT NULL,
    `StatoEdificio` VARCHAR(45) NULL,
    'AreaGeografica' VARCHAR(45) NOT NULL,
    PRIMARY KEY (`CodEdificio`),
    INDEX `fk_Edificio_AreaGeografica1_idx` (`AreaGeografica` ASC) VISIBLE,
    CONSTRAINT chk_coords CHECK (Latitudine between -90 and 90 and Longitudine between -180 and 180),
    CONSTRAINT `fk_Edificio_AreaGeografica1`
        FOREIGN KEY (`AreaGeografica`)
        REFERENCES `AreaGeografica` (`Nome`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `Progetto`;
CREATE TABLE IF NOT EXISTS `Progetto` (
    `CodProgetto` INT NOT NULL PRIMARY KEY,
    `DataPresentazione` DATE NOT NULL,
    `DataApprovazione`  DATE NOT NULL,
    `DataInizio`    DATE NOT NULL,
    `StimaFine`     DATE NOT NULL,
    `DataFine`      DATE NOT NULL,
    `CostoProgetto` DECIMAL(10,2) NULL,
    INDEX `fk_Progetto_Edificio1_idx` (`Edificio` ASC) VISIBLE,
    CONSTRAINT `fk_Progetto_Edificio1`
        FOREIGN KEY (`Edificio_rid`)
        REFERENCES `Edificio` (`CodEdificio`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;



DROP TABLE IF EXISTS `StoricoCalamita`;
CREATE TABLE IF NOT EXISTS `StoriscoCalamita` (
    `LivelloIntensita` INT NOT NULL ,
    `Tipologia` VARCHAR(45) NOT NULL,
    `Data` DATE NOT NULL,
    `Latitudine`    DECIMAL(9,6) NOT NULL,
    `Longitudine`   DECIMAL(9,6) NOT NULL,
    PRIMARY KEY (`LivelloIntensita`, `Tipologia`, `Data`, `AreaGeografica` ), 
    INDEX `fk_AreaGeografica_StoricoCalamita1_idx` (`AreaGeografica` ASC) VISIBLE,
    CONSTRAINT `fk_AreaGeografica_StoricoCalamita1`
        FOREIGN KEY (`Areageografica`)
        REFERENCES `Areageografica` (`Nome`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
    CONSTRAINT chk_coords CHECK (Latitudine between -90 and 90 and Longitudine between -180 and 180)
);
ENGINE = InnoDB;

DROP TABLE IF EXISTS `Rischio`;
CREATE TABLE IF NOT EXISTS `Rischio` (
    `CodRischio` INT NOT NULL,
    `Tipo`  VARCHAR(45) NOT NULL,
    `Coefficiente`  FLOAT NULL,
    PRIMARY KEY (`CodRischio`),
    INDEX   `fk_Rischio_has_AreaGeografica_AreaGeografica1_idx` (`AreaGeografica` ASC) VISIBLE,
    CONSTRAINT `fk_Rischio_has_AreaGeografica_AreaGeografica1`
        FOREIGN KEY (`AreaGeografica`)
        REFERENCES `Areageografica` (`Nome`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION  
)
ENGINE = InnoDB;


DROP TABLE IF EXISTS `Responsabile`;
CREATE TABLE IF NOT EXISTS `Responsabile` (
    `CodFiscale` INT NOT NULL,
    `PagaProgetto`  FLOAT NOT NULL,
    PRIMARY KEY (`CodFiscale`)
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `StadioAvanzamentoProgetto`;
CREATE TABLE IF NOT EXISTS `StadioAvanzamentoProgetto` (
    `CodStato` INT NOT NULL,
    `DataCompletamento` DATE NULL,
    PRIMARY KEY (`CodStato`, `Progetto`),
    INDEX `fk_Progetto_StadioAvanzamentoProgetto1_idx` (`Progetto` ASC) VISIBLE,
    INDEX `fk_Responsabile_StadioAvanzamentoProgetto1_idx` (`Responsabile` ASC) VISIBLE,
    CONSTRAINT `fk_Progetto_StadioAvanzamentoProgetto1`
        FOREIGN KEY (`Progetto`)
        REFERENCES `Progetto` (`CodProgetto`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Responsabile_StadioAvanzamentoProgetto1`
        FOREIGN KEY (`Responsabile`)
        REFERENCES `Responsabile` (`CodFiscale`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


DROP TABLE IF EXISTS `Lavoro`;
CREATE TABLE IF NOT EXISTS `Lavoro` (
    `CodLavoro` INT NOT NULL,
    `DataInizio` DATE NULL,
    `DataFine` DATE NULL,
    `Descrizione` VARCHAR(255) NOT NULL,
    `MaxOperai` INT UNSIGNED NULL,
    PRIMARY KEY (`CodLavoro`),
    INDEX `fk_StadioAvanzamentoProgetto_Lavoro_idx` (`Stadio` ASC) VISIBLE,
    CONSTRAINT `fk_StadioAvanzamentoProgetto_Lavoro`
        FOREIGN KEY (`Stadio`)
        REFERENCES `Stadio` (`CodStadio`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


DROP TABLE IF EXISTS `Turno`;
CREATE TABLE IF NOT EXISTS `Turno` (
    `TimestampInizio` DATETIME(3) NOT NULL,
    `TimestampFine` DATETIME(3) NOT NULL,
    `CapoCantiere` CHAR(16) NOT NULL,
    `Lavoratore` CHAR(16) NOT NULL,
    PRIMARY KEY (`TimestampInizio`, `TimestampFine`, `Lavoro`),
    INDEX `fk_Lavoro_Turno1_idx` (`Lavoro` ASC ) VISIBLE,
    INDEX `fk_CapoCantiere_Turno1_idx` (`CapoCantiere` ASC) VISIBLE,
    INDEX `fk_Lavoratore_Turno1_idx` (`Lavoratore` ASC) VISIBLE,
    CONSTRAINT `fk_Lavoro_Turno1`
        FOREIGN KEY (`Lavoro`)
        REFERENCES `Lavoro` (`CodLavoro`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
    CONSTRAINT `fk_CapoCantiere_Turno1`
        FOREIGN KEY (`CapoCantiere`)
        REFERENCES `CapoCantiere` (`CodFiscale`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
    CONSTRAINT `fk_Lavoratore_Turno1`
        FOREIGN KEY (`Lavoratore`)
        REFERENCES `Lavoratore` (`CodFiscale`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `CapoCantiere`;
CREATE TABLE IF NOT EXISTS `CapoCantiere` (
    `CodFiscale` CHAR(16) NOT NULL,
    `PagaOraria` INT UNSIGNED NOT NULL,
    `MaxOperai` INT UNSIGNED NULL,
    PRIMARY KEY (`CodFiscale`),
    CONSTRAINT `fk_Turno_CapoCantiere1`
        FOREIGN KEY (`Lavoro`, `TimestampInizio`, `TimestampFine`)
        REFERENCES `Turno` (`Lavoro`,`TimestampInizio`, `TimestampFine`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


DROP TABLE IF EXISTS `Lavoratore`;
CREATE TABLE IF NOT EXISTS `Lavoratore` (
    `CodFiscale` CHAR(16) NOT NULL,
    `PagaOraria` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodFiscale`),
    CONSTRAINT `fk_Turno_Lavoratore1`
        FOREIGN KEY (`Lavoro`, `TimestampInizio`, `TimestampFine`)
        REFERENCES `Turno` (`Lavoro`,`TimestampInizio`, `TimestampFine`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;


DROP TABLE IF EXISTS `Materiale`;
CREATE TABLE `Materiale` (
    `CodLotto` INT UNSIGNED NOT NULL,
    `Fornitore` VARCHAR(255) NOT NULL,
    `DataAcquisto` DATE NOT NULL,
    `Tipologia` VARCHAR(255) NOT NULL,
    `CostoLotto` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`CodLotto`,`Fornitore`)
)
ENGINE = InnoDB;


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
