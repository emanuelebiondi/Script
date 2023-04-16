DROP PROCEDURE IF EXISTS consigliIntervento;

DELIMITER $$

CREATE PROCEDURE consigliIntervento(IN _codEdificio CHAR(5))
	
    BEGIN
		
        DECLARE coefficienteRischio FLOAT;
        
        DECLARE NPianiEdificio INT;
        
        SET coefficienteRischio =	(
										SELECT 	R.Coefficiente
										FROM	Rischio R
												INNER JOIN
												Edificio E	ON R.AreaGeografica = E.AreaGeografica
										WHERE	E.CodEdificio = _codEdificio
												AND
												R.Tipo = "Sismico"
												AND
												R.Data >= ALL	(
																	SELECT 	R1.Data
																	FROM	Rischio R1
																			INNER JOIN
																			Edificio E1	ON R1.AreaGeografica = E1.AreaGeografica
																	WHERE	E1.CodEdificio = _codEdificio
																			AND
																			R1.Tipo = "Sismico"
																)
									);
		
        SET NPianiEdificio =	(
									SELECT	COUNT(*)
                                    FROM	Pianta
                                    WHERE	Edificio = _codEdificio
								);
    
		WITH AlertTarget AS	(
								SELECT	S.IDSensore, S.Tipologia, S.soglia, S.Parte, S.Piano, S.Vano, A.ValoreMisurato, A.Timestamp
								FROM	Alert A
										INNER JOIN
										Sensore S	ON S.IDSensore = A.IDSensore
								WHERE	S.Edificio = _codEdificio
										AND	(
												S.Tipologia = "Giroscopio" OR
												S.Tipologia = "Accelerometro" OR
												S.Tipologia = "Posizione"
											)
							),
			UltimiAlert AS 	(
								SELECT	*, 	(	
												(ABS(A1.ValoreMisurato-A1.Soglia)/A1.Soglia)*100 
												+
                                                (ABS(A1.ValoreMisurato-A1.Soglia)/A1.Soglia)*100*coefficienteRischio 
											) 	AS PDanno
                                FROM	AlertTarget A1
                                WHERE	A1.TimeStamp >= ALL	(
																SELECT	A2.TimeStamp
                                                                FROM	AlertTarget A2
																WHERE	A2.IDSensore = A1.IDSensore
															)
							)


			SELECT	A.Vano, A.Piano,	(
											IF	( ( A.Tipologia = "Giroscopio" OR A.Tipologia = "Accelerometro") AND A.Piano < NPianiEdificio, CONCAT("Rifacimento solaio al piano ",A.Piano),
											IF	( ( A.Tipologia = "Giroscopio" OR A.Tipologia = "Accelerometro") AND A.Piano = NPianiEdificio, "Rifacimento copertura",
											CONCAT("Risanamento parte ",A.Parte)))
										)	AS Consiglio,
										(
											IF	( A.PDanno BETWEEN 1 AND 20, "60 Giorni",
                                            IF	( A.PDanno BETWEEN 21 AND 40, "40 Giorni",
                                            IF	( A.PDanno BETWEEN 41 AND 60, "20 Giorni",
                                            IF	( A.PDanno BETWEEN 61 AND 80, "10 Giorni",
                                            IF	( A.PDanno BETWEEN 81 AND 100, "3 Giorni",
                                            "Immediato")))))
                                        )	AS TempoInterventoMax
                                                
            FROM	UltimiAlert A;

	END $$

DELIMITER ;