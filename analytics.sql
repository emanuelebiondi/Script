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
        WITH MuriScelti AS(
            SELECT m.CodMuro
            FROM Vano v INNER JOIN Muro m ON m.Piano = v.Piano
            WHERE v.Edificio = CodEdificio_f
        ),
        SensoriAllarmati AS(
            SELECT s.CodSensore, s.Muro, s.Tipologia, s.Soglia s.Longitudine, s.Latitudine, a.TimeStamp, a.ValoreSuperamento
            FROM Sensore s INNER JOIN Alert a ON s.CodSensore = a.Sensore
            WHERE (
                s.Tipologia = "Giroscopio" OR
                s.Tipologia = "Accellerometro" OR
                s.Tipologia = "Allungamento"
            )
        ),
        AlertInteressati AS(
            SELECT sm.CodSensore, sm.Tipologia, sm.Soglia, sm.Longitudine, sm.Latitudine, sm.TimeStamp, sm.ValoreSuperamento
            FROM MuriScelti ms INNER JOIN SensoriAllarmati sa ON sa.Muro = ms.CodMuro
        ),
        AlertRecenti AS(
            SELECT *, (
                (ABS(at.ValoreSuperamento-at.Soglia)/at.Soglia)*100 + (ABS(at.ValoreSuperamento-at.Soglia)/at.Soglia)*100*fattoreDiRischio
            ) AS DannoPerc
            FROM AlertInteressati at
            WHERE at.TimeStamp >= ALL (
                SELECT at1.TimeStamp
                FROM AlertInteressati at1
                WHERE at1.CodSensore = at.CodSensore
            )
        )
        
    END $$
DELIMITER;
