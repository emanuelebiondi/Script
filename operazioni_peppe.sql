--OP. 5------------------------------------------------
DROP PROCEDURE IF EXISTS NewTurnoOperaio;
DELIMITER $$

CREATE PROCEDURE NewTurnoOperaio(IN CodLavoro_f INT, IN Lavoratore_f VARCHAR(16), IN Inizio_f DATETIME(3), IN Fine_f DATETIME(3));
    BEGIN
        DECLARE CapoCantiere_f VARCHAR(16);
        SELECT CapoCantiere INTO CodFiscale FROM CapoCantiere WHERE CodLavoro_f=CodLavoro;

        -- Controllo che il turno non duri troppo poco --
        DECLARE OreDiLavoro FLOAT;
        SET OreDiLavoro=(Fine_f-Inizio_f);
        IF OreDiLavoro <= 0.015 THEN
            SIGNAL SQLSTATE "45000"
            SET MESSAGE_TEXT = "Il turno deve durare più di 1 minuto!!";
        END IF;
        
        -- Controllo sovrapposizione turni dell'operaio
        IF (SELECT COUNT(*) FROM Turno t WHERE t.Lavoratore=Lavoratore_f
            AND
            ((t.TimestampInizio >= Inizio_f AND t.TimestampInizio < Inizio_f + INTERVAL OreDiLavoro * 60 MINUTE) OR
             (t.TimestampInizio + INTERVAL OreDiLavoro*60 MINUTE > Inizio_f AND t.TimestampInizio+ INTERVAL OreDiLavoro*60 MINUTE <= Inizio_f + INTERVAL OreDiLavoro*60 MINUTE)
            )
            ) > 0 then
		    signal sqlstate "45000" 
            SET MESSAGE_TEXT = "Il turno che si vuole inserire è in conflitto con un'altro turno assegnato all'operaio";
        end if;

        -- Controllo massimo numero di operai che lavorano contemporaneamente
        IF (SELECT COUNT(DISTINCT Lavoratore)+1 FROM Turno t WHERE t.Lavoro = CodLavoro_f AND Lavoratore_f != Lavoratore AND 
    (	(t.TimestampInizio <= Inizio_f AND t.TimestampInizio + INTERVAL OreDiLavoro*60 MINUTE > Inizio_f )
        OR
		(t.TimestampInizio > Inizio_f AND t.TimestampInizio < Inizio_f + INTERVAL OreDiLavoro*60 MINUTE )
    )
    ) > (SELECT max_operai FROM Lavoro WHERE id_lavoro = _id_lavoro) then
		SIGNAL SQLSTATE "45000" 
        SET MESSAGE_TEXT = "E' stato raggiunto il numero massimo di lavoratori che possono lavorare contemporaneamente";
    END IF;
    SET Fine_f = Inizio_f+ OreDiLavoro;

    INSERT INTO Turno(Lavoro, Lavoratore, TimestampInizio, TimestampFine)
    VALUES (CodLavoro_f, Lavoratore_f, Inizio_f, Fine_f);

END $$
DELIMITER;


--OP. 7------------------------------------------------
DROP PROCEDURE IF EXISTS RischiAnnuiEdificio;
DELIMITER $$

CREATE PROCEDURE RischiAnnuiEdificio(IN CodEdificio_f INT UNSIGNED)
    BEGIN  
        DECLARE sede VARCHAR(255);
        SET sede = (
                SELECT AreaGeografica
                FROM Edificio
                WHERE CodEdificio =CodEdificio_f
        );
        SELECT *
        FROM Rischio
        WHERE AreaGeografica=sede
                AND YEAR(DATA) = YEAR(CURRENT_DATE);
    END $$
DELIMITER;


--OP. 9------------------------------------------------
DROP PROCEDURE IF EXISTS InfoAlert;
DELIMITER $$

CREATE PROCEDURE InfoAlert(IN TimeStamp_f TIMESTAMP, IN CodSensore_f INT, OUT CodEdificio_f INT, OUT Piano_f INT, OUT CodVano_f INT, OUT CodMuro_f INT, OUT Pericolosità FLOAT)
    BEGIN
        DECLARE soglia_f FLOAT;

        SET CodMuro_f = (
            SELECT Muro
            FROM Sensore
            WHERE CodSensore = CodSensore_f
        );

        SET CodVano_f = (
            SELECT Vano
            FROM Muro
            WHERE CodMuro = CodMuro_f
        );

        SET Piano_f = (
            SELECT Piano
            FROM Vano
            WHERE CodVano = CodVano_f
        );

        SET CodEdificio_f = (
            SELECT Edificio
            FROM Piano
            WHERE NumeroPiano = Piano_f
        );

        SET soglia_f = (
            SELECT Soglia 
            FROM Sensore
            WHERE CodSensore = CodSensore_f
        );

        SET Pericolosità = (
            SELECT Valore
            FROM Alert
            WHERE TimeStamp = TimeStamp_f
                AND CodSensore = CodSensore_f
        ) - soglia_g;
    END $$
DELIMITER ;
