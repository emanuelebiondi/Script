CREATE PROCEDURE stimaDanni(IN _codEdificio CHAR(5), IN gravita FLOAT, OUT danni_ VARCHAR(100))
	
    BEGIN
		
        DECLARE stato FLOAT;
        DECLARE primoContributo FLOAT;
        DECLARE secondoContributo FLOAT;
        DECLARE terzoContributo FLOAT;

		SET primoContributo =	(
									SELECT	SUM( ( S.Soglia - P.Larghezza )/(PERIOD_DIFF(DATE_FORMAT(CURRENT_DATE, '%Y%m'), DATE_FORMAT(CAST(P.Timestamp AS DATE), '%Y%m'))+1 ) )*0.2 AS contributo
									FROM	Sensore S
											INNER JOIN
											Posizione P ON S.IDSensore = P.IDSensore
									WHERE	S.Edificio = _codEdificio
											AND
                                            PERIOD_DIFF(
														DATE_FORMAT(CURRENT_DATE, '%Y%m'),
														DATE_FORMAT(CAST(P.Timestamp AS DATE), '%Y%m')
                                                        ) < 12
								);
                                
		SET secondoContributo =	(
									SELECT	SUM( ( S.Soglia - SQRT(POWER(G.Wx,2) + POWER(G.Wy,2) + POWER(G.Wz,2)) )/(PERIOD_DIFF(DATE_FORMAT(CURRENT_DATE, '%Y%m'), DATE_FORMAT(CAST(G.Timestamp AS DATE), '%Y%m'))+1 ) )*0.4 AS contributo
									FROM	Sensore S
											INNER JOIN
											Giroscopio G ON S.IDSensore = G.IDSensore
									WHERE	S.Edificio = _codEdificio  
											AND
                                            PERIOD_DIFF(
														DATE_FORMAT(CURRENT_DATE, '%Y%m'),
														DATE_FORMAT(CAST(G.Timestamp AS DATE), '%Y%m')
                                                        ) < 12
								);
                                
		SET terzoContributo =	(
									SELECT	SUM( ( S.Soglia - SQRT(POWER(A.X,2) + POWER(A.Y,2) + POWER(A.Z,2)) )/(PERIOD_DIFF(DATE_FORMAT(CURRENT_DATE, '%Y%m'), DATE_FORMAT(CAST(A.Timestamp AS DATE), '%Y%m'))+1 ) )*0.4 AS contributo
									FROM	Sensore S
											INNER JOIN
											Accelerometro A ON S.IDSensore = A.IDSensore
									WHERE	S.Edificio = _codEdificio
											AND
                                            PERIOD_DIFF(
														DATE_FORMAT(CURRENT_DATE, '%Y%m'),
														DATE_FORMAT(CAST(A.Timestamp AS DATE), '%Y%m')
                                                        ) < 12
								);
                                
		SET stato = primoContributo + secondoContributo + terzoContributo;

		IF ( stato >= 0 AND gravita BETWEEN 0 AND 5) THEN 
			SET danni_ = "Nessun danno";
		ELSEIF ( stato > 0 AND gravita BETWEEN 6 AND 10)THEN
			SET danni_ = "Danni lievi";
		ELSEIF ( stato <= 0 AND gravita BETWEEN 0 AND 5) THEN
			SET danni_ = "Danni moderati";
		ELSEIF ( stato < 0 AND gravita BETWEEN 6 AND 10) THEN
			SET danni_ = "Danni ingenti";
		ELSE
			SET danni_ = "Si e' verificato un errore.";
        END IF;
	END $$

DELIMITER ;