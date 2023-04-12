DELIMITER $$
DROP TRIGGER IF EXISTS check_puntocardinale_puntoaccesso
CREATE TRIGGER check_puntocardinale_puntoaccesso
BEFORE INSERT ON PuntoAccesso
FOR EACH ROW
BEGIN 
    IF  NEW.PuntoCardinale <> 'N' AND NEW.PuntoCardinale <> 'S' AND 
        NEW.PuntoCardinale <> 'E' AND NEW.PuntoCardinale <> 'O' AND 
        NEW.PuntoCardinale <> 'NE' AND NEW.PuntoCardinale <> 'NO' AND 
        NEW.PuntoCardinale <> 'SE' AND NEW.PuntoCardinale <> 'SO'
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Punto cardinale non valido!';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS check_puntocardinale_finestra;
CREATE TRIGGER check_puntocardinale_finestra
BEFORE INSERT ON Finestra
FOR EACH ROW
BEGIN 
    IF  NEW.PuntoCardinale <> 'N' AND NEW.PuntoCardinale <> 'S' AND 
        NEW.PuntoCardinale <> 'E' AND NEW.PuntoCardinale <> 'O' AND 
        NEW.PuntoCardinale <> 'NE' AND NEW.PuntoCardinale <> 'NO' AND  
        NEW.PuntoCardinale <> 'SE' AND NEW.PuntoCardinale <> 'SO'
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Punto cardinale non valido!';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS check_tipologia_puntoaccesso;
CREATE TRIGGER check_tipologia_puntoaccesso
BEFORE INSERT ON PuntoAccesso
FOR EACH ROW
BEGIN
    IF  NEW.Tipologia <> 'Porta' AND NEW.Tipologia <> 'Arco' AND NEW.Tipologia <> 'Accesso Senza Serramento' AND NEW.Tipologia <> 'Portafinestra'
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipologia di punto di accesso non valida!';
    END IF;
END $$
DELIMITER;

DELIMITER $$
DROP TRIGGER IF EXISTS check_tipologia_sensore;
CREATE TRIGGER check_tipologia_sensore
BEFORE INSERT ON Sensore
FOR EACH ROW
BEGIN 
    IF  NEW.Tipologia <> 'Giroscopio' AND NEW.Tipologia <> 'Temperatura' AND NEW.Tipologia <> 'Allungamento' AND NEW.Tipologia <> 'Pluviometro' AND NEW.Tipologia <> 'Accelerometro'
    THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipologia di sensore non valida!';
    END IF;
END $$
DELIMITER;

DELIMITER $$
DROP TRIGGER IF EXISTS check_numerolavoratori_turno;
CREATE TRIGGER check_numerolavoratori_turno
BEFORE INSERT ON Turno
FOR EACH ROW
BEGIN
    DECLARE numerolavoratori INTEGER DEFAULT 1;
    DECLARE numeromassimolavoratori INTEGER DEFAULT 0;
    
    SET numerolavoratori = (
        SELECT count(*) AS numerolavoratoricontemporanei
        FROM Turno t INNER JOIN Lavoratore l ON c.CodFiscale=l.Turno
        WHERE c.CodFiscale = NEW.Turno
    );

    SET numeromassimolavoratori = (
        SELECT MaxOperai
        FROM CapoCantiere c
        WHERE c.CodFiscale = NEW.CapoCantiere
    )
    
    