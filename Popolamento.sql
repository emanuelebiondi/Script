use SmartConstructionCompany;
-- SET FOREIGN_KEY_CHECKS = 0;

----------------------------------
-- AREA GEOGRAFICA 
----------------------------------
insert into AreaGeografica (Nome)
values 			
	('Nord-Ovest'), 
	('Nord-Est'), 
	('Centro'), 
	('Sud'), 
	('Isole');
				
----------------------------------
-- RISCHIO
----------------------------------



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
insert into Edificio (Tipologia, DataRealizzazione, Longitudine, Latitudine, AreaGeografica)
VALUES('Villetta', '1987-07-13', 43.640578, 10.290558, 'Centro');