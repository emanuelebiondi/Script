DROP PROCEDURE IF EXISTS ConsigliIntervento;
DELIMITER $$
CREATE PROCEDURE ConsigliIntervento(IN CodEdificio_f INT)
    BEGIN
        DECLARE fattoreDiRischio FLOAT;
        SET fattoreDiRischio =(
            SELECT r.Coefficiente
            FROM Calamita c INNER JOIN Edificio e ON c.AreaGeografica = e.AreaGeografica
            WHERE e.CodEdificio = CodEdificio_f AND c.Tipologia = "Sismico"
                AND c.Data >= ALL(
                    SELECT cd.Data
                    FROM Calamita cd INNER JOIN Edificio ed ON cd.AreaGeografica = ed.AreaGeografica
                    WHERE ed.CodEdificio = CodEdificio_f AND cd.Tipologia = "Sismico"
                )
        );
        DECLARE ContaPiani INT;
        SET ContaPiani = (
            SELECT COUNT(*)
            FROM Piano
            WHERE Edificio = CodEdificio_f
        );
        WITH VaniScelti AS(
            SELECT
            FROM Piano p INNER JOIN Vano v 
        )
    END $$
DELIMITER;

