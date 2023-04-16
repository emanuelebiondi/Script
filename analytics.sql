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
            SELECT m.CodMuro, m.Piano
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
            SELECT ms.CodSensore, ms.Piano, ms.Tipologia, ms.Soglia, ms.Longitudine, ms.Latitudine, ms.TimeStamp, ms.ValoreSuperamento
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
        SELECT ar.Piano, (
            IF ((ar.Tipologia = "Giroscopio"
             OR ar.Tipologia = "Accelerometro"
             ) AND ar.Piano < ContaPiani, CONCAT("Consigliata ristrutturazione del solaio del piano",ar.Piano),
            IF ((ar.Tipologia = "Giroscopio"
             OR ar.Tipologia = "Accelerometro") 
             AND ar.Piano = ContaPiani, CONCAT("Consigliata ristrutturazione tetto"
             , CONCAT("Ristrutturazione muro", ar.CodMuro)))
            ) AS Suggerimento,(
                IF (ar.DannoPerc BETWEEN 1 AND 20, "120 giorni",
                IF (ar.DannoPerc BETWEEN 1 AND 20, "90 giorni",
                IF (ar.DannoPerc BETWEEN 1 AND 20, "60 giorni",
                IF (ar.DannoPerc BETWEEN 1 AND 20, "30 giorni",
                IF (ar.DannoPerc BETWEEN 1 AND 20, "10 giorni",
                "Iniziare i lavori il prima possibile")))))
                ) AS TemporisticaInterventi
            )
            FROM AlertRecenti ar;
    END $$
DELIMITER;
