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


--OP. 9----------------------------------------------
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
