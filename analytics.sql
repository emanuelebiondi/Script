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

DROP PROCEDURE IF EXISTS StimaDanni;
DELIMITER $$
CREATE PROCEDURE StimaDanni (IN CodEdificio_f INT, OUT coeffPrevisione FLOAT)
    BEGIN
        DECLARE coeffSensore FLOAT DEFAULT 25;
        WITH MuriScelti AS(
            SELECT m.CodMuro, m.Piano
            FROM Vano v INNER JOIN Muro m ON m.Piano = v.Piano
            WHERE v.Edificio = CodEdificio_f
        ),
        SensoriScelti AS(
            SELECT s.CodSensore, m.ValoreX, m.ValoreY, m.ValoreZ, SQRT(m.ValoreX*m.ValoreX+m.ValoreY*m.ValoreY+m.ValoreZ*m.ValoreZ)/Soglia AS PercValori
            FROM Sensore s INNER JOIN Misura m ON s.CodSensore = m.Sensore
        )
        SET coeffSensore = (
            SELECT SUM(PercValori)*0.25
            FROM SensoriScelti
        );
        DECLARE coeffStato FLOAT DEFAULT 50;
        SET coeffStato =(
            SELECT IF(e.Stato IS NULL, 0, e.Stato)/3 * 0.5 AS PercValoriStato
            FROM Edificio E
            WHERE e.CodEdificio = CodEdificio_f
        );
        DECLARE coeffCalamita FLOAT DEFAULT 25;
        SET coeffCalamita = (
            SELECT eventiDiEdificio/TotaleEventi*0.25
            FROM (
                SELECT COUNT(*) AS TotaleEventi, (
                    SELECT COUNT(*)
                    FROM Calamita c1 INNER JOIN Edificio e1 ON e1.AreaGeografica = c1.AreaGeografica
                    WHERE c1.Tipologia = "Terremoto" AND e1.CodEdificio = CodEdificio_f
                ) AS eventiDiEdificio
                FROM Calamita c
                WHERE c.Tipologia = "Terremoro"
            )
        );
        SET coeffPrevisione = IFNULL(coeffCalamita+coeffSensore+coeffStato, 0);
        DECLARE Messaggio VARCHAR(30);
        IF coeffPrevisione = 0 THEN SET Stringa = 'Nessun rischio';
            ELSE IF coeffPrevisione <=3 THEN SET Stringa = 'Danni superficiali';
                ELSE IF coeffPrevisione <=5 THEN SET Stringa = 'Danni strutturali';
                    ELSE SET Stringa = 'Danni gravi alla struttura';
                END IF;
            END IF;
        END IF;

        SELECT coeffPrevisione as IndiceCalcolato, Messaggio;

    END $$
DELIMITER ;