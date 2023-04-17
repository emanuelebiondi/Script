use SmartBuildings;
-- SET FOREIGN_KEY_CHECKS = 0;

set @acc_max = 4 ;
set @est_max = 10 ;
set @temp_max = 40 ;


DROP PROCEDURE IF EXISTS insertRowsToMisura_Accellerometro;
DROP PROCEDURE IF EXISTS insertRowsToMisura_Temperatura;
DROP PROCEDURE IF EXISTS insertRowsToMisura_Pluviometro;

DELIMITER //  
CREATE PROCEDURE insertRowsToMisura_Accellerometro()   
BEGIN
DECLARE i INT DEFAULT 1; 
	WHILE (i <= 36) DO -- 3600 in un ora
		-- Accellerometro
		INSERT INTO Misura (Sensore,Timestamp,ValoreX,ValoreY,ValoreZ)
		select 	CodSensore, current_timestamp()-interval i second, 
				@acc_max*rand()-@acc_max/2, @acc_max*rand()-@acc_max/2, @acc_max*rand()-@acc_max/2
		from Sensore s
		where s.Tipologia='Accellerometro';
		set i = i+1;
	END WHILE;
END //


CREATE PROCEDURE insertRowsToMisura_Temperatura() 
BEGIN
	DECLARE i INT DEFAULT 1; 
		WHILE (i <= 6) DO
			-- Temperatura
			INSERT INTO Misura (Sensore,Timestamp,ValoreX,ValoreY,ValoreZ)
			select 	CodSensore, current_timestamp()-interval 10*i minute, @temp_max*rand(), null, null
			from Sensore s
			where s.Tipologia='Temperatura';
			set i = i+1;
		END WHILE;
END //

CREATE PROCEDURE insertRowsToMisura_Pluviometro()
BEGIN
	DECLARE i INT DEFAULT 1; 
		WHILE (i <= 12) DO
			-- Temperatura
			INSERT INTO Misura (Sensore,Timestamp,ValoreX,ValoreY,ValoreZ)
			select 	CodSensore, current_timestamp()-interval 5*i minute, 1*rand(), null, null
			from Sensore s
			where s.Tipologia='Pluviometro';
			set i = i+1;
		END WHILE;
END //
DELIMITER ;



----------------------------------
-- LAVORATORE
----------------------------------
insert into Lavoratore (CodFiscale, PagaOraria)
values 
	('LDATTL64L22D732G', 9),
	('PRMGRM67A28A272V', 11),
	('MDRGFR79P16L019O', 11),
	('CLLRCL76M30A720O', 10),
	('BNCQMD64H04C130C', 9),
	('PRSRFL64T11H034X', 11),
	('NCNNCI60H06I031X', 9),
	('GRLPLG66C08D927T', 10),
	('TZURME67D24D748V', 10),
	('BTTRLD66R18B906N', 8),
	('VRNGTN93E06G258H', 10),
	('PLDCNL95M04I150R', 10),
	('LCDDDG78R01A977D', 8),
	('CNISMN95M30G568W', 8),
	('DNNCLL92C17H221N', 8),
	('BRNRCR56D01A398H', 8),
	('TRNLII89L41C324P', 9),
	('LBASGN94D01E457P', 10),
	('SNDTRS92R41B858A', 11),
	('LMNDDV80S01G140F', 9),
	('SBRDMR65E41C390H', 8),
	('BSTYLE55A41L779N', 7),
	('CRCPGB69E41I259E', 7),
	('LSANOX78S09E236Z',  7);
		
----------------------------------
-- RESPONSABILE
----------------------------------
insert into Responsabile (CodFiscale, PagaProgetto)
values 
	('CTNMDL85P41G224X', 10000),	
	('LPOLTD84S41G992I', 8000),
	('CRNRZO89L41M214D', 15000);	

----------------------------------
-- CapoCantiere
----------------------------------
insert into CapoCantiere (CodFiscale, PagaOraria, MaxOperai)
values 
	('CMBYZE44B15M297I', 17, 5),	
	('FMLSBX79A21I848T', 15, 6),
	('DHCQYP78L51L372I', 16, 5),	
	('FJYSCG79C57C125P', 15, 4),
	('HQTBHM90M51E819K', 17, 6),	
	('BZFTZI88E47F385W', 15, 1),
	('ZLZLXH27C03D728J', 16, 3);	
		

----------------------------------
-- Insert AreaGeografica 
----------------------------------
insert into AreaGeografica (Nome)
values 			
	('Nord'), 
	('Centro'), 
	('Sud'), 
	('Sicilia'), 
	('Sardegna'); 
			
----------------------------------
-- Insert Rischio
----------------------------------
insert into Rischio (AreaGeografica, Tipo, Coefficiente)
values
	('Nord', 'Sismico', 7),
	('Centro', 'Sismico', 4),
	('Sud', 'Sismico', 2),
	('Sicilia', 'Sismico', 7),
	('Sardegna', 'Sismico', 1),

	('Nord', 'Idrogeologico', 4),
	('Centro', 'Idrogeologico', 4),
	('Sud', 'Idrogeologico', 7),
	('Sicilia', 'Idrogeologico', 5),
	('Sardegna', 'Idrogeologico', 7);

----------------------------------
-- Insert Calamita
----------------------------------
INSERT INTO Calamita (AreaGeografica, Tipologia, Data, LivelloIntensita, Latitudine, Longitudine)
values
	('Sud', 'Gelamento', '2023-02-03', 3, 15.996094, 40.287907),
	('Nord', 'Valanga', '2023-02-10', 5, 12.524414, 41.934977),
	('Centro', 'Frana', '2022-11-22', 1, 12.788086, 42.771211),
	('Sud', 'Alluvione', '2019-02-28', 3, 15.699463, 41.401536),
	('Nord', 'Terremoto', '2022-06-29', 4, 9.887695, 45.042478),
	('Centro', 'Inondazione', '2022-10-06', 2, 10.920410, 43.500752),
	('Sicilia', 'Uragano', '2022-04-24', 6, 14.754639, 37.596824),
	('Sud', 'Eruzione', '2022-09-13', 9, 16.622314, 39.130060),
	('Sardegna', 'Terremoto', '2019-10-28', 6, 9.174762, 40.818189),
	('Sardegna', 'Incendio', '2021-01-15', 4, 8.745117, 39.308800),
	('Sud', 'Gelamento', '2021-12-30', 3, 15.325928, 40.262761),
	('Sicilia', 'Valanga', '2020-03-31', 7, 13.688965, 37.666429),
	('Sardegna', 'Frana', '2021-03-29', 3, 9.558105, 40.010787),
	('Nord', 'Alluvione', '2020-11-08', 5, 11.260986, 46.035109),
	('Centro', 'Terremoto', '2019-05-07', 5, 13.128662, 41.508577),
	('Sicilia', 'Inondazione', '2022-05-29', 4, 14.908447, 37.909534),
	('Sud', 'Uragano', '2022-05-19', 6, 16.820068, 41.120746),
	('Sicilia', 'Eruzione', '2019-02-07', 9, 14.128418, 37.466139),
	('Nord', 'Terremoto', '2020-03-24', 4, 13.150635, 45.981695),
	('Sardegna', 'Incendio', '2021-07-13', 4, 9.118652, 40.979898),
	('Centro', 'Gelamento', '2021-08-29', 1, 18.369141, 40.094882),
	('Sud', 'Valanga', '2022-09-25', 3, 16.270752, 38.479395);



----------------------------------
-- Insert Edificio
----------------------------------
insert into Edificio (Tipologia, DataRealizzazione, StatoEdificio, Latitudine, Longitudine, AreaGeografica)
values 
	('Villetta', '2020-07-13', 1, 43.640578, 10.290558, 'Centro'), -- CodEdificio = 1
	('Condominio', '1989-05-21', 2, 38.153594, 15.660652, 'Sud'); -- CodEdificio = 2

----------------------------------
-- Insert Piano
----------------------------------
insert into Piano (Edificio, NumeroPiano, Perimetro, Area)
values 
	(1, 1, 68, 253), -- 1.1
	(1, 2, 68, 253); -- 1.2

----------------------------------
-- Insert Funzione (del Vano)
----------------------------------
insert into Funzione (Nome)
values
	('Ingresso'),
	('SalaDaPranzo'),
	('CameraDaLetto'),
	('Cucina'),
	('Bagno'),
	('Garage'),
	('Cantina'),
	('LocaleTecnico'),
	('Balcone'),
	('Mansarda'),
	('Disimpiego');


----------------------------------
-- Insert Vano
----------------------------------
insert into Vano (Edificio, Piano, Altezzamax, LunghezzaMax, LarghezzaMax, Funzione)
values 
	(1, 1, 2.7, 11, 10, 'SalaDaPranzo'), -- 1.1.1
	(1, 1, 2.7, 7, 4, 'Cucina'), -- 1.1.2
	(1, 1, 2.7, 4, 6, 'Bagno'), -- 1.1.3
	(1, 1, 2.7, 13, 3, 'Ingresso'), -- 1.1.4
	(1, 1, 2.7, 4, 7, 'CameraDaLetto'), -- 1.1.5
	(1, 1, 2.7, 4, 7, 'CameraDaLetto'), -- 1.1.6
	(1, 2, 2.1, 11, 10, 'Mansarda'), -- 1.2.1
	(1, 2, null, 13, 11, 'Balcone'); -- 1.2.2

insert into Muro (Lunghezza, Vano1, Vano2)
values 
	(11, 1, null), -- 1.1.1.1 -- SalaDaPranzo
	(10, 1, null), -- 1.1.1.2
	(4, 1, 2), -- 1.1.1.3
	(3, 1, 4), -- 1.1.1.4 --> Porta
	(4, 1, 5), -- 1.1.1.5
	(10, 1, null), -- 1.1.1.6
	
	(7, 2, null), -- 1.1.2.2 -- Cucina
	(4, 2, 3), -- 1.1.2.3
	(7, 2, 4), -- 1.1.2.4
	
	(6, 3, null), -- 1.1.3.2 -- Bagno
	(4, 3, null), -- 1.1.3.3
	(6, 3, 4), -- 1.1.3.4
	
	(6, 4, 6), -- 1.1.4.4 -- Ingresso
	(7, 4, 5), -- 1.1.4.5
	(3, 4, null), -- 1.1.4.6
	
	(7, 5, null), -- 1.1.5.3 -- Camera 1
	(4, 5, 6), -- 1.1.5.4
	
	(6, 6, null), -- 1.1.6.3 -- Camera 2
	(4, 6, null), -- 1.1.6.4

	(10, 7, null), 	-- 1.2.1.1 -- Mansarda
	(11, 7, null), 	-- 1.2.1.2
	(10, 7, null), 	-- 1.2.1.3
	(11, 7, 8), 	-- 1.2.1.4

	(13, 8, null), -- 1.2.2.1 -- Balcone
	(13, 8, null), -- 1.2.2.3
	(11, 8, null); -- 1.2.2.4

insert into PuntoAccesso (Muro, PuntoCardinale, Tipologia)
values
	(4, 'E', 'Porta'), -- Vano 1-4
	(9, 'S', 'Porta'), -- Vano 2-4
	(12, 'S', 'Porta'), -- Vano 3-4
	(14, 'N', 'Porta'), -- Vano 5-4
	(13, 'N', 'Porta'), -- Vano 6-4
	(15, 'E', 'Porta'), -- Vano 5-null
	(23, 'E', 'Porta'); -- Vano 7-8

insert into Finestra (Muro, PuntoCardinale)
values
	(1, 'E'), (1, 'E'), (1, 'E'), (2, 'N'), (6, 'S'),
	(7, 'N'),
	(10, 'N'), (11, 'E'),
	(15, 'E'), 
	(16, 'S'), (16, 'S'),
	(18, 'S'), (19, 'E'),
	
	(21, 'N'), (21, 'N'), (21, 'N'),
	(20, 'S'), (20, 'S'),
	(23, 'E'), (23, 'E');

insert into Progetto (Edificio, DataPresentazione, DataApprovazione, DataInizio, StimaFine, DataFine)
values
	(1, '2022-01-10', '2022-02-10', '2022-03-15', '2022-06-20', '2022-05-22'); -- Progetto 1 
	--(1, '2023-01-10', '2023-01-26', '2023-02-04', '2023-07-13', null); -- Progetto 2 edif.1


insert into StadioAvanzamentoProgetto (Progetto, Responsabile, DataCompletamento)
values
	(1, 'CTNMDL85P41G224X', '2022-04-24'), -- 1 stadio
	(1, 'LPOLTD84S41G992I', '2022-05-22'); -- 2 stadio

insert into Lavoro (Stadio, DataInizio, DataFine, Descrizione, MaxOperai)
values
	(1, '2022-03-15', '2022-03-18', 'Rimozione Pavimento', 5),
	(1, '2022-03-19', '2022-03-23', 'Rifacimento Massetto', 4),
	(1, '2022-03-28', '2022-04-02', 'Messa in posa pavimento', 3),
	(1, '2022-04-03', '2022-04-05', 'Montaggio Ponteggi', 5),
	(1, '2022-04-06', '2022-04-12', 'Rimozione Vernice ', 6),
	(1, '2022-04-13', '2022-04-20', 'Verniciatura Edificio', 6),
	(1, '2022-04-21', '2022-04-24', 'Smontaggio Ponteggi', 4),

	(2, '2022-04-25', '2022-04-28', 'Rimozione Pavimento', 4),
	(2, '2022-05-01', '2022-05-06', 'Rifacimento Massetto', 3),
	(2, '2022-05-07', '2022-05-10', 'Messa in posa pavimento', 4),
	(2, '2022-05-11', '2022-05-15', 'Verniciatura', 3),
	(2, '2022-05-16', '2022-05-18', 'Verniciatura', 2),
	(2, '2022-05-19', '2022-05-22', 'Verniciatura', 3);

insert into Turno (Lavoro, TimestampInizio, TimestampFine, Lavoratore, Capocantiere)
values
	(1, '2022-03-15 08:00:00', '2022-03-15 14:00:00', 'BNCQMD64H04C130C', 'BZFTZI88E47F385W'),
	(1, '2022-03-15 08:00:00', '2022-03-15 14:00:00', 'BRNRCR56D01A398H', 'BZFTZI88E47F385W'),
	(1, '2022-03-15 08:00:00', '2022-03-15 14:00:00', 'BSTYLE55A41L779N', 'BZFTZI88E47F385W'),
	(1, '2022-03-16 08:00:00', '2022-03-16 14:00:00', 'BNCQMD64H04C130C', 'BZFTZI88E47F385W'),
	(1, '2022-03-16 08:00:00', '2022-03-16 14:00:00', 'BRNRCR56D01A398H', 'BZFTZI88E47F385W'),
	(1, '2022-03-16 08:00:00', '2022-03-17 14:00:00', 'CNISMN95M30G568W', 'BZFTZI88E47F385W'),
	(1, '2022-03-17 08:00:00', '2022-03-17 14:00:00', 'BNCQMD64H04C130C', 'BZFTZI88E47F385W'),
	(1, '2022-03-17 08:00:00', '2022-03-17 14:00:00', 'BRNRCR56D01A398H', 'BZFTZI88E47F385W'),
	(1, '2022-03-17 08:00:00', '2022-03-17 14:00:00', 'CNISMN95M30G568W', 'BZFTZI88E47F385W'),
	(1, '2022-03-18 08:00:00', '2022-03-18 14:00:00', 'BNCQMD64H04C130C', 'BZFTZI88E47F385W'),
	(1, '2022-03-18 08:00:00', '2022-03-18 14:00:00', 'BRNRCR56D01A398H', 'BZFTZI88E47F385W'),
	(1, '2022-03-18 08:00:00', '2022-03-18 14:00:00', 'CNISMN95M30G568W', 'BZFTZI88E47F385W'),

	(2, '2022-03-19 08:00:00', '2022-03-19 16:00:00', 'BNCQMD64H04C130C', 'HQTBHM90M51E819K'),
	(2, '2022-03-19 08:00:00', '2022-03-19 16:00:00', 'BRNRCR56D01A398H', 'HQTBHM90M51E819K'),
	(2, '2022-03-20 08:00:00', '2022-03-20 12:00:00', 'BNCQMD64H04C130C', 'HQTBHM90M51E819K'),
	(2, '2022-03-20 08:00:00', '2022-03-20 12:00:00', 'BRNRCR56D01A398H', 'HQTBHM90M51E819K'),
	(2, '2022-03-23 08:00:00', '2022-03-23 12:00:00', 'BNCQMD64H04C130C', 'HQTBHM90M51E819K'),
	(2, '2022-03-23 08:00:00', '2022-03-23 12:00:00', 'BRNRCR56D01A398H', 'HQTBHM90M51E819K'),
	(2, '2022-03-23 08:00:00', '2022-03-23 12:00:00', 'CNISMN95M30G568W', 'HQTBHM90M51E819K'),

	(3, '2022-03-28 08:00:00', '2022-03-28 16:00:00', 'VRNGTN93E06G258H', 'FMLSBX79A21I848T'),
	(3, '2022-03-28 08:00:00', '2022-03-28 16:00:00', 'DNNCLL92C17H221N', 'FMLSBX79A21I848T'),
	(3, '2022-03-28 08:00:00', '2022-03-28 16:00:00', 'MDRGFR79P16L019O', 'FMLSBX79A21I848T'),
	(3, '2022-04-02 08:00:00', '2022-04-02 16:00:00', 'VRNGTN93E06G258H', 'FMLSBX79A21I848T'),
	(3, '2022-04-02 08:00:00', '2022-04-02 16:00:00', 'DNNCLL92C17H221N', 'FMLSBX79A21I848T'),
	(3, '2022-04-02 08:00:00', '2022-04-02 16:00:00', 'MDRGFR79P16L019O', 'FMLSBX79A21I848T'),

	(4, '2022-04-03 08:00:00', '2022-04-03 16:00:00', 'VRNGTN93E06G258H', 'FJYSCG79C57C125P'),
	(4, '2022-04-03 08:00:00', '2022-04-03 16:00:00', 'CNISMN95M30G568W', 'FJYSCG79C57C125P'),
	(4, '2022-04-03 08:00:00', '2022-04-03 16:00:00', 'LSANOX78S09E236Z', 'FJYSCG79C57C125P'),
	(4, '2022-04-04 08:00:00', '2022-04-04 16:00:00', 'VRNGTN93E06G258H', 'FJYSCG79C57C125P'),
	(4, '2022-04-04 08:00:00', '2022-04-04 16:00:00', 'CNISMN95M30G568W', 'FJYSCG79C57C125P'),
	(4, '2022-04-04 08:00:00', '2022-04-04 16:00:00', 'LSANOX78S09E236Z', 'FJYSCG79C57C125P'),
	(4, '2022-04-05 08:00:00', '2022-04-05 16:00:00', 'VRNGTN93E06G258H', 'FJYSCG79C57C125P'),
	(4, '2022-04-05 08:00:00', '2022-04-05 16:00:00', 'CNISMN95M30G568W', 'FJYSCG79C57C125P'),
	(4, '2022-04-05 08:00:00', '2022-04-05 16:00:00', 'LSANOX78S09E236Z', 'FJYSCG79C57C125P'),

	(5, '2022-04-06 08:00:00', '2022-04-06 16:00:00', 'VRNGTN93E06G258H', 'HQTBHM90M51E819K'),
	(5, '2022-04-06 08:00:00', '2022-04-06 16:00:00', 'CNISMN95M30G568W', 'HQTBHM90M51E819K'),
	(5, '2022-04-07 08:00:00', '2022-04-07 16:00:00', 'CNISMN95M30G568W', 'HQTBHM90M51E819K'),
	(5, '2022-04-07 08:00:00', '2022-04-07 16:00:00', 'LSANOX78S09E236Z', 'HQTBHM90M51E819K'),
	(5, '2022-04-08 08:00:00', '2022-04-08 16:00:00', 'CNISMN95M30G568W', 'HQTBHM90M51E819K'),
	(5, '2022-04-08 08:00:00', '2022-04-08 16:00:00', 'VRNGTN93E06G258H', 'HQTBHM90M51E819K'),
	(5, '2022-04-12 08:00:00', '2022-04-12 16:00:00', 'MDRGFR79P16L019O', 'HQTBHM90M51E819K'),
	(5, '2022-04-12 08:00:00', '2022-04-12 16:00:00', 'VRNGTN93E06G258H', 'HQTBHM90M51E819K'),
	--(1, '2022-04-13', '2022-04-20', 'Verniciatura Edificio', 6),
	(6, '2022-04-13 08:00:00', '2022-04-13 16:00:00', 'VRNGTN93E06G258H', 'HQTBHM90M51E819K'),
	(6, '2022-04-14 08:00:00', '2022-04-14 16:00:00', 'VRNGTN93E06G258H', 'HQTBHM90M51E819K'),
	(6, '2022-04-15 08:00:00', '2022-04-15 16:00:00', 'VRNGTN93E06G258H', 'HQTBHM90M51E819K'),
	(6, '2022-04-16 08:00:00', '2022-04-16 16:00:00', 'VRNGTN93E06G258H', 'HQTBHM90M51E819K'),
	(6, '2022-04-17 08:00:00', '2022-04-17 16:00:00', 'VRNGTN93E06G258H', 'HQTBHM90M51E819K'),
	(6, '2022-04-20 08:00:00', '2022-04-20 16:00:00', 'VRNGTN93E06G258H', 'HQTBHM90M51E819K'),
	--(1, '2022-04-21', '2022-04-24', 'Smontaggio Ponteggi', 4),
	(7, '2022-04-21 08:00:00', '2022-04-21 16:00:00', 'BTTRLD66R18B906N', 'ZLZLXH27C03D728J'),
	(7, '2022-04-22 08:00:00', '2022-04-22 16:00:00', 'BTTRLD66R18B906N', 'ZLZLXH27C03D728J'),
	(7, '2022-04-24 08:00:00', '2022-04-24 16:00:00', 'BTTRLD66R18B906N', 'ZLZLXH27C03D728J'),
	--(2, '2022-04-25', '2022-04-28', 'Rimozione Pavimento', 4),
	(8, '2022-04-25 08:00:00', '2022-04-25 16:00:00', 'DNNCLL92C17H221N', 'FMLSBX79A21I848T'),
	(8, '2022-04-26 08:00:00', '2022-04-26 16:00:00', 'DNNCLL92C17H221N', 'FMLSBX79A21I848T'),
	(8, '2022-04-27 08:00:00', '2022-04-27 16:00:00', 'DNNCLL92C17H221N', 'FMLSBX79A21I848T'),
	(8, '2022-04-28 08:00:00', '2022-04-28 16:00:00', 'DNNCLL92C17H221N', 'FMLSBX79A21I848T'),
	--(2, '2022-05-01', '2022-05-06', 'Rifacimento Massetto', 3),
	(9, '2022-05-01 08:00:00', '2022-05-01 16:00:00', 'LSANOX78S09E236Z', 'FJYSCG79C57C125P'),
	(9, '2022-06-01 08:00:00', '2022-06-01 16:00:00', 'LSANOX78S09E236Z', 'FJYSCG79C57C125P'),
	--(2, '2022-05-07', '2022-05-10', 'Messa in posa pavimento', 4),
	(10, '2022-05-07 08:00:00', '2022-05-07 16:00:00', 'DNNCLL92C17H221N', 'CMBYZE44B15M297I'),
	(10, '2022-04-08 08:00:00', '2022-05-08 16:00:00', 'DNNCLL92C17H221N', 'CMBYZE44B15M297I'),
	(10, '2022-05-09 08:00:00', '2022-05-09 16:00:00', 'DNNCLL92C17H221N', 'CMBYZE44B15M297I'),
	(10, '2022-05-10 08:00:00', '2022-05-10 16:00:00', 'DNNCLL92C17H221N', 'CMBYZE44B15M297I'),
	--(2, '2022-05-11', '2022-05-15', 'Verniciatura', 3),
	(11, '2022-05-11 08:00:00', '2022-05-11 16:00:00', 'LBASGN94D01E457P', 'FJYSCG79C57C125P'),
	(11, '2022-05-12 08:00:00', '2022-05-12 16:00:00', 'LBASGN94D01E457P', 'FJYSCG79C57C125P'),
	(11, '2022-05-15 08:00:00', '2022-05-15 16:00:00', 'LBASGN94D01E457P', 'FJYSCG79C57C125P'),
	--(2, '2022-05-16', '2022-05-18', 'Verniciatura', 2),
	(12, '2022-05-16 08:00:00', '2022-05-16 16:00:00', 'LBASGN94D01E457P', 'FJYSCG79C57C125P'),
	(12, '2022-05-17 08:00:00', '2022-05-17 16:00:00', 'LBASGN94D01E457P', 'FJYSCG79C57C125P'),
	(12, '2022-05-18 08:00:00', '2022-05-18 16:00:00', 'LBASGN94D01E457P', 'FJYSCG79C57C125P'),
	--(2, '2022-05-19', '2022-05-22', 'Verniciatura', 3);
	(13, '2022-05-19 08:00:00', '2022-05-19 16:00:00', 'LBASGN94D01E457P', 'FJYSCG79C57C125P'),
	(13, '2022-05-21 08:00:00', '2022-05-21 16:00:00', 'LBASGN94D01E457P', 'FJYSCG79C57C125P'),
	(13, '2022-05-22 08:00:00', '2022-05-22 16:00:00', 'LBASGN94D01E457P', 'FJYSCG79C57C125P');


insert into Materiale (Lavoro, CodLotto, Fornitore, DataAcquisto, Quantita, CostoLotto)
values
	(2, 1, 'XXX', '2022-02-10', 3, 300), -- Messetto
	(3, 2, 'XXX', '2022-02-10', 2, 2000), -- Pavimento
	(4, 3, 'YYY', '2022-02-10', 100, 5000), -- Ponteggi
	(6, 4, 'XXX', '2022-02-10', 10, 60 ), -- Vernice

	(8, 5, 'XXX', '2022-02-10', 3, 300), -- Messetto
	(10, 6, 'XXX', '2022-02-10', 2, 1000 ), -- Pavimento
	(11, 7, 'KKK', '2022-02-10', 3, 40 ), -- Vernice
	(12, 8, 'KKK', '2022-02-10', 6, 20 ), -- Vernice
	(13, 9, 'KKK', '2022-02-10', 10, 35 ); -- Vernice

insert into Mattone (CodLotto, Fornitore, Alveolatura, Composizione, Isolante)
values
	(1, 'XXX', 'asasasas', 'sasasas', true), 
	(5, 'XXX', 'asasasas', 'dhadada', true);

insert into Piastrella (CodLotto, Fornitore, Tipo, Fuga, Materiale, X, Y, Z)
values
	(2, 'XXX', 'frfr', 0.01, 'Legno', 0.4, 1.0, 0.01), 
	(6, 'XXX', 'frfdasd', 0.01, 'Coccio', 0.3, 0.3, 0.1);

insert into MaterialeGenerico (CodLotto, Fornitore, Descrizione, Funzione, X, Y, Z)
values
	(3, 'YYY', 'Ponteggi', 'Ponteggi', null, null, null);

insert into Intonaco (CodLotto, Fornitore, Tipo, Spessore)
values
	(4, 'XXX', 'Vernice', 0.01),
	(7, 'KKK', 'Vernice', 0.01),
	(8, 'KKK', 'Vernice', 0.01),
	(9, 'KKK', 'Vernice', 0.01);


insert into Sensore (Muro, Tipologia, Soglia, Latitudine, Longitudine)
values
	(23, 'Pluviometro', 10, 43.640578, 10.290558), -- 1
	(24, 'Temperatura', 40, 43.640578, 10.290558), -- 2
	(10, 'Temperatura', 40, 43.640578, 10.290558), -- 3
	(2, 'Temperatura', 46, 43.640578, 10.290558), -- 4
	(5, 'Temperatura', 46, 43.640578, 10.290558), -- 5
	(15, 'Allungamento', 1.00, 43.640578, 10.290558), -- 6 cm
	(23, 'Accellerometro', 1.9, 43.640578, 10.290558); -- 7


INSERT INTO Misura (Sensore,Timestamp,ValoreX,ValoreY,ValoreZ)
	select 	CodSensore, current_timestamp()-interval 10 minute, 0.1, null, null
	from Sensore s
	where s.Tipologia='Allungamento';

call insertRowsToMisura_Accellerometro();
call insertRowsToMisura_Temperatura();
call insertRowsToMisura_Pluviometro();


INSERT INTO Alert (Sensore,Timestamp, ValoreSuperamento)
	select m.Sensore, m.Timestamp, IF(m.ValoreX <= s.Soglia, IF(m.ValoreY <= s.Soglia, IF(m.ValoreZ <= s.Soglia, NULL, m.ValoreZ), m.ValoreY), m.ValoreX)
	from Misura m
	inner join Sensore s on s.codSensore = m.Sensore
	where (m.ValoreX > s.Soglia or m.ValoreY > s.Soglia or m.ValoreZ > s.Soglia);
