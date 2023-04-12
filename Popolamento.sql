use NomeDataBase;
-- SET FOREIGN_KEY_CHECKS = 0;

----------------------------------
-- AREA GEOGRAFICA 
----------------------------------
insert into AreaGeografica (nome)
VALUES 	(Nord-ovest), 
				(Nord-est), 
				(Centro), 
				(Sud), 
				(Isole);
				
----------------------------------
-- RISCHIO
----------------------------------
insert into Lavoratore (CodiceFiscale, Nome, Cognome, PagaOraria)
values 
		('LDATTL64L22D732G', 'RAFFAELE', 'Attilio', 9),
		('PRMGRM67A28A272V', 'Parmegiani', 'Geremia', 11),
		('MDRGFR79P16L019O', 'Amadori', 'Gianfranco', 11),
		('CLLRCL76M30A720O', 'Colla','Ercole',10),
		('BNCQMD64H04C130C', 'Bonacorso','Quasimodo', 9),
		('PRSRFL64T11H034X', 'Persichelli','Raffaele', 11),
		('NCNNCI60H06I031X', 'Nocenti', 'Nico', 9),
		('GRLPLG66C08D927T', 'Guaraldi','Pierluigi',10),
		('TZURME67D24D748V', 'Tuzi', 'Remo', 10),
		('BTTRLD66R18B906N', 'Butto','Rinaldo',8),
		('VRNGTN93E06G258H', 'Varner', 'Gastone', 10),
		('PLDCNL95M04I150R', 'Pulidoro', 'Cornelio', 10),
		('BTTRLD66R18B906N', 'Butto', 'Socrate', 8),
		('CNISMN95M30G568W', 'Ciani','Salomone',8),
		("DNNCLL92C17H221N", "De Anna", "Achille", 8);
		("LSANOX78S09E236Z", "Alasia", "Noè", 8);
		

				
				
----------------------------------
-- EDIFICIO
----------------------------------