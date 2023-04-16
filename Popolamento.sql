use SmartBuildings;
-- SET FOREIGN_KEY_CHECKS = 0;

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
INSERT INTO Calamita (AreaGeografica, Tipologia, Data, LivelloIntensita, Longitudine, Latitudine)
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
insert into Edificio (Tipologia, DataRealizzazione, StatoEdificio, Longitudine, Latitudine, AreaGeografica)
values 
	('Villetta', '2020-07-13', 1, 43.640578, 10.290558, 'Centro'), -- CodEdificio = 1
	('Condominio', '1989-05-21', 2, 38.153594, 15.660652, 'Sud'); -- CodEdificio = 2

----------------------------------
-- Insert Piano
----------------------------------
insert into Piano (Edificio, NumeroPiano, Perimetro, Area)
values 
	(1, 1, 68, 253); -- 1

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
	(1, 1, 2.7, 4, 7, 'CameraDaLetto'); -- 1.1.6

insert into Muro (Vano, Lunghezza)
values 
	(1, 11),
	(2, 10),
	(3, 4),
	()















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
insert into CapoCantiere (CodFiscale, PagaOraria)
values 
	('CMBYZE44B15M297I', 17),	
	('FMLSBX79A21I848T', 15),
	('DHCQYP78L51L372I', 16),	
	('FJYSCG79C57C125P', 15),
	('HQTBHM90M51E819K', 17),	
	('BZFTZI88E47F385W', 15),
	('ZLZLXH27C03D728J', 16);	
		





