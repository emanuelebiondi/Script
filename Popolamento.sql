use SmartConstructionCompany;
-- SET FOREIGN_KEY_CHECKS = 0;

----------------------------------
-- AREA GEOGRAFICA 
----------------------------------
insert into AreaGeografica (Nome)
values 			
	('Nord'), 
	('Sardegna'), 
	('Centro'), 
	('Sud'), 
	('Sicilia');
				
----------------------------------
-- RISCHIO
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
	(1, 1, , , ); -- 1.1.1













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
		

		
----------------------------------
-- EDIFICIO
----------------------------------
-- ?? Stato Edificio
insert into Edificio (Tipologia, DataRealizzazione, StatoEdificio, Longitudine, Latitudine, AreaGeografica)
VALUES 
		('Villetta', '1987-07-13', 80, 43.640578, 10.290558, 'Centro');
		('Condominio', '1989-05-21', 97, 38.153594, 15.660652, 'Sud');



----------------------------------
-- RISCHIO
----------------------------------
INSERT INTO Rischio (CodRischio, Tipo, Coefficiente, AreaGeografica)
VALUES
		(01, Sismico, 40, Centro);
		(02, Idraulico, 60, Centro);
		(03, Sismico, 20, Sud);
		(04, Sismico, 10, Sicilia);
		(05, Idraulico, 5, Sardegna);
		(06, Idraulico, 55, Sicilia);
		(07, Idraulico, 19, Sud);
		(08, Sismico, 5, Nord);
		(09, Idraulico, 37, Nord);



----------------------------------
-- CALAMITÀ
----------------------------------
INSERT INTO Calamità (AreaGeografica, Tipologia, Data, LivelloIntensita, Longitudine, Latitudine);
values
		(Sud, 'Gelamento', '2002-02-03', 3, 43.6, 22);
		(Nord, 'Valanga', '2020-08-10', 5, 38.9, 22.6);
		(Centro, 'Frana', '2005-11-22', 1, 35, 18.5);
		(Sud, 'Alluvione', '2018-02-28', 3, 48, 30);
		(Nord, 'Terremoto', '2002-06-29', 4, 47, 28);
		(Centro, 'Inondazione', '2001-10-06', 2);
		(Sicilia, 'Uragano', '1999-04-24', 6);
		(Sud, 'Eruzione', '2017-09-13', 9);
		(Sardegna, 'Terremoto', '2013-10-28', 0);
		(Sardegna, 'Incendio', '2021-01-15', 4);
		(Sud, 'Gelamento', '2013-12-30', 3);
		(Sicilia, 'Valanga', '2019-03-31', 7);
		(Sardegna, 'Frana', '2000-03-29', 0);
		(Nord, 'Alluvione', '2014-11-08', 5);
		(Centro, 'Terremoto', '2009-05-07', 5);
		(Sicilia, 'Inondazione', '2016-05-29', 4);
		(Sud, 'Uragano', '1994-05-19', 6);
		(Sicilia, 'Eruzione', '2008-02-07', 9);
		(Nord, 'Terremoto', '2022-03-24', 4);
		(Sardegna, 'Incendio', '1996-07-13', 4);
		(Centro, 'Gelamento', '2007-08-29', 1);
		(Sud, 'Valanga', '1996-09-25', 3);