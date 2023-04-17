USE SmartBuildings;
/* Vincolo PuntoAccesso.PuntoCardinale */
DELIMITER $$
DROP TRIGGER IF EXISTS check_puntocardinale_puntoaccesso;
CREATE TRIGGER check_puntocardinale_puntoaccesso
BEFORE INSERT ON PuntoAccesso
FOR EACH ROW
BEGIN 
    IF  NEW.PuntoCardinale <> 'N' AND NEW.PuntoCardinale <> 'S' AND 
        NEW.PuntoCardinale <> 'E' AND NEW.PuntoCardinale <> 'O' AND 
        NEW.PuntoCardinale <> 'NE' AND NEW.PuntoCardinale <> 'NO' AND 
        NEW.PuntoCardinale <> 'SE' AND NEW.PuntoCardinale <> 'SO'
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Punto cardinale non valido!';
    END IF;
END $$
DELIMITER ;



/* Vincolo Finestra.PuntoCardinale */
DELIMITER $$
DROP TRIGGER IF EXISTS check_puntocardinale_finestra;
CREATE TRIGGER check_puntocardinale_finestra
BEFORE INSERT ON Finestra
FOR EACH ROW
BEGIN 
    IF  NEW.PuntoCardinale <> 'N' AND NEW.PuntoCardinale <> 'S' AND 
        NEW.PuntoCardinale <> 'E' AND NEW.PuntoCardinale <> 'O' AND 
        NEW.PuntoCardinale <> 'NE' AND NEW.PuntoCardinale <> 'NO' AND  
        NEW.PuntoCardinale <> 'SE' AND NEW.PuntoCardinale <> 'SO'
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Punto cardinale non valido!';
    END IF;
END $$
DELIMITER ;


/* Vincolo Rischio.Tipologia */
DELIMITER $$
DROP TRIGGER IF EXISTS check_tipologia_Rischio;
CREATE TRIGGER check_tipologia_Rischio
BEFORE INSERT ON Rischio
FOR EACH ROW
BEGIN
    IF  NEW.Tipo <> 'Sismico' AND NEW.Tipo <> 'Idrogeologico' AND NEW.Tipo <> 'Meteorologico'
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipologia di Calamita non valida!';
    END IF;
END $$
DELIMITER;

/* Vincolo PuntoAccesso.Tipologia */
DELIMITER $$
DROP TRIGGER IF EXISTS check_tipologia_PuntoAccesso;
CREATE TRIGGER check_tipologia_PuntoAccess
BEFORE INSERT ON PuntoAccesso
FOR EACH ROW
BEGIN
    IF  NEW.Tipologia <> 'Porta' AND NEW.Tipologia <> 'Arco' AND NEW.Tipologia <> 'AccessoSenzaSerramento' AND NEW.Tipologia <> 'Portafinestra'
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipologia di PuntoAccesso non valida!';
    END IF;
END $$
DELIMITER;


/* Vincolo Sensore.Tipologia */
DELIMITER $$
DROP TRIGGER IF EXISTS check_tipologia_sensore;
CREATE TRIGGER check_tipologia_sensore
BEFORE INSERT ON Sensore
FOR EACH ROW
BEGIN 
    IF  NEW.Tipologia <> 'Giroscopio' AND NEW.Tipologia <> 'Temperatura' AND NEW.Tipologia <> 'Allungamento' AND NEW.Tipologia <> 'Pluviometro' AND NEW.Tipologia <> 'Accelerometro'
    THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipologia di sensore non valida!';
    END IF;
END $$
DELIMITER;

/* Controllo sul piano del edificio */
drop trigger if exists check_piano;
delimiter $$
create trigger check_piano before insert on Piano for each row
begin
    if NEW.NumeroPiano > 1 and not exists (select 1 from Piano where Edificio = new.Edificio and NumeroPiano = new.NumeroPiano-1)
	then
        signal sqlstate '45000'
        set message_text = "Non puoi inserire il piano x senza il piano x-1";
	end if;
    if NEW.NumeroPiano < 1 and not exists (select 1 from Piano where Edificio = new.Edificio and NumeroPiano = new.NumeroPiano+1)
	then
        signal sqlstate '45000'
        set message_text = "Non puoi inserire il piano sotterraneo x senza il piano x+1";
	end if;
end $$
delimiter ;

-- Event Aggiornamento Costo Progetto
DROP EVENT IF EXISTS AggiornamentoCosto;
DELIMITER $$
CREATE EVENT AggiornamentoCosto
ON SCHEDULE EVERY 1 DAY
DO
    BEGIN
    	WITH ProgettoScelto AS(
		SELECT CodProgetto as ProgettoEdilizio
        FROM Progetto
        WHERE DataFine IS NULL
	),
    StadioAssociato AS(
		SELECT CodStadio as StadioDiAvanzamento
        FROM ProgettoScelto p NATURAL JOIN StadioAvanzamentoProgetto s
        WHERE DataCompletamento IS NULL
    ),
    TurniLavoratoriAssociati AS(
		SELECT StadioDiAvanzamento, Lavoratore as CodiceFiscale, TIMESTAMPDIFF(HOUR,T.TimestampInizio, T.TimestampFine) as OreDiLavoro
        FROM StadioAssociato s NATURAL JOIN Turno t
        WHERE day(t.TimeStampInizio)=current_date
        GROUP BY t.Lavoratore
    ),
    TurniCapocantieriAssociati AS(
		SELECT StadioDiAvanzamento, Capocantiere as CodFiscale, TIMESTAMPDIFF(HOUR,T.TimestampInizio, T.TimestampFine) as OreDiLavoro
        FROM StadioAssociato s NATURAL JOIN Turno t
        WHERE day(t.TimeStampInizio)=current_date
        GROUP BY t.CapoCantiere
    ),
    CostoDelPersonale AS(
		SELECT CostoPersonale
        FROM ( SELECT PagaOraria*OreDiLavoro AS CostoPersonale FROM TurniLavoratoriAssociati NATURAL JOIN Lavoratore ) as L
			 UNION ALL
			 ( SELECT PagaOraria*OreDiLavoro AS CostoPersonale FROM TurniCapocantieriAssociati NATURAL JOIN Capocantiere)
    ),
    CostoDaAggiornare AS(
		SELECT SUM(CostoPersonale) AS CostoPersonale
        FROM CostoDelPersonale
    )
	UPDATE Progetto
    SET CostoProgetto = IFNULL(Costo,0) + ( SELECT CostoPersonale FROM CostoDaAggiornare)
    WHERE CodProgetto = (SELECT CodProgetto FROM ProgettoScelto)
		AND Edificio = (SELECT CodEdifico FROM Edificio where DataRealizzazione IS NULL); 
END $$
DELIMITER ;

/* L'ora di inizio e fine di un turno di un lavoratore non sono coerenti */
drop trigger if exists check_orario_turno_lavoratore;
delimiter $$
create trigger check_orario_turno_lavoratore
before insert on Turno for each row
begin
    if new.TimestampFine < new.TimestampInizio then 
        signal sqlstate '45000'
        set message_text = 'Orari non compatibili';
    end if;
end $$
delimiter ;

/* Controlla che non venga inserito un turno con stesso lavoratore che si sovrappone ad un suo turno preesistente 
drop trigger if exists check_sovrapposizione_turno_lavoratore;
delimiter $$

create trigger check_sovrapposizione_turno_lavoratore
before insert on Turno for each row
begin
    if exists ( 
        select *
        from Turno T
        where (new.TimestampInizio between T.TimestampInizio and T.TimestampFine) or (new.TimestampFine between T.TimestampInizio and T.TimestampFine)
    ) then
        signal sqlstate '45000'
        set message_text = 'Il turno si sovrappone con un altro turno dello stesso operaio';
    end if;
end $$
delimiter ;
*/
/* Controlla la coerenza delle date dentro Progetto 
drop trigger if exists check_data_stadioavanzamentoprogetto;
delimiter $$

create trigger check_data_stadioavanzamentoprogetto
before insert on StadioAvanzamentoProgetto for each row
begin
    if (new.DataPresentazione > new.DataApprovazione OR new.DataApprovazione > new.DataInizio
        OR new.DataInizio > new.StimaFine OR new.DataApprovazione > new.DataFine 
        OR new.DataInizio > new.DataFine 
    ) then
        signal sqlstate '45000'
        set message_text = 'Date non compatibili';
    end if;
end $$
delimiter ;
*/

/* Massimo numero di lavoratori - Turno*/
drop trigger if exists check_maxlavoratori;
delimiter $$

create trigger check_maxlavoratori
before insert on Turno for each row
begin

    declare numerolavoratori integer default 1;
    declare numeromassimolav integer default 0;
    declare differenza integer default 0;

    set numerolavoratori = (
        select count(*) 
        from Turno T
        where T.CapoCantiere = new.CapoCantiere
	    AND DAY(New.TimestampInizio) = ALL (
                    SELECT DAY(T1.TimestampInizio) 
                    FROM Turno T1
                    WHERE T1.CapoCantiere = T.CapoCantiere
                )
    );
    
    set numeromassimolav = (
        select MaxOperai
        from CapoCantiere C
        where C.CodFiscale = new.CapoCantiere
    );

    set differenza = numerolavoratori - numeromassimolav;

    if differenza = 0 then
        signal sqlstate '45000'
        set message_text = 'Lavoratore non inseribile - Numero massimo raggiunto per questo CaopCantiere';
    end if;
end $$
delimiter ;

/* Massimo numero di lavoratori */
drop trigger if exists check_maxlavoratori;
delimiter $$

create trigger check_maxlavoratori
before insert on Turno for each row
begin

    declare numerolavoratori integer default 1;
    declare numeromassimolav integer default 0;
    declare differenza integer default 0;

    set numerolavoratori = (
        select count(*) 
        from Turno T
        where T.Lavoro = new.Lavoro
	    AND DAY(New.TimestampInizio) = ALL (
                    SELECT DAY(T1.TimestampInizio) 
                    FROM Turno T1
                    WHERE T1.Lavoro = T.Lavoro
                )
    );

    set numeromassimolav = (
        select MaxOperai
        from Lavoro L
        where L.CodLavoro = new.Lavoro
    );

    set differenza = numerolavoratori - numeromassimolav;

    if differenza = 0 then
        signal sqlstate '45000'
        set message_text = 'Lavoratore non inseribile - Numero massimo raggiunto per questo lavoro';
    end if;
end $$
delimiter ;


  
    
