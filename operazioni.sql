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
--OP.1 Stampare le registrazioni di ogni sensore di un edificio nelle ultime 24 ore

drop procedure if exists stampa_registrazioni_24;
delimiter $$

create procedure stampa_registrazioni_24 (in CodEdificio int)
begin
    with RegistrazioniEdificio as(
        select  M.Sensore, M.ValoreX, M.ValoreY, M.ValoreZ
        from    Sensore S inner join Misura M on S.CodSensore=M.Sensore
        where   Edificio = _CodEdificio
            and timestamp >= current_timestamp - interval 1 day
    )

    select  *
    from    RegistrazioniEdificio
    order by    Sensore;
    
end $$
delimiter ;

--OP.2 Stampa le informazioni della pianta di ogni piano di un edificio

drop procedure if exists info_pianta_edificio
delimiter $$

create procedure info_pianta_edificio (in _CodEdificio int)
begin
    with PianiEdificioScelto as (
        select  P.NumeroPiano, P.Area, P.Perimetro
        from    Piano P
        where   P.Edificio = _CodEdificio
    )

    VaniEdificioScelto as(
        select  PES.NumeroPiano as NumPiano, PES.Perimetro as PerimetroPiano, PES.Area as AreaPiano, V.CodVano, V.LarghezzaMax, V.LunghezzaMax, V.AltezzaMax, V.Funzione
        from    Vano V inner join PianiEdificioScelto PES on PES.NumeroPiano = V.Piano 
    )

    
    select  *
    from VaniEdificioScelto
end $$
delimiter ;

--OP.3 Calcolare il costo di un progetto
drop procedure if exists calcola_costo_progetto
delimiter $$

create procedure calcola_costo_progetto (in _CodProgetto int)
begin
    select CostoProgetto
    from Progetto 
    where CodProgetto = _CodProgetto;

end $$
delimiter ;

--OP.4 Inserimento nuovo tipo materiale generico

drop procedure if exists NuovoMateriale
delimiter $$

create procedure NuovoMateriale (in _CodLotto int, in _Fornitore VARCHAR(45), in _DataAcquisto DATE, in _Quantita int, in _CostoLotto decimal(10,2), in _Tipologia varchar(45)create procedure nuovo_materiale (in _CodLotto int, in _Fornitore VARCHAR(45), in _DataAcquisto DATE, in _Quantita int, in _CostoLotto decimal(10,2), in _Tipologia varchar(45), in _Descrizione varchar(255), in _Funzione varchar(45), in _X int, in _Y int, in _Z int)
begin
    insert into Materiale
    values (_CodLotto, _Fornitore, _DataAcquisto, _Quantita, _CostoLotto, _Tipologia);
    
    insert into MaterialeGenerico
    values (_CodLotto, _Fornitore, _Descrizione, _Funzione, _X, _Y, _Z);

end $$
delimiter ;

-- OP. 5 Stampa la busta paga relativa ad un operaio specificando anno e mese di interesse

drop procedure if exists calcola_bustapaga
delimiter $$

create procedure calcola_bustapaga (in _dipendente char(16), in anno int, in mese int)
begin
    select count(*) * PagaOraria /12 as BustaPaga
    from Turno T inner join Lavoratore L on T.Lavoratore = D.CodFiscale
    where year(T.TimestampInizio) = anno and month(T.TimestampInizio) = mese and L.CodFiscale = _dipendente;
end $$
delimiter ;
                                 
                                 
