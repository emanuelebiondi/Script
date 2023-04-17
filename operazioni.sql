--OP.1 Stampare le registrazioni di ogni sensore di un edificio nelle ultime 24 ore

drop procedure if exists stampa_registrazioni_24;
delimiter $$

create procedure stampa_registrazioni_24 (in CodEdificio int)
begin
    with MuriScelti AS(
            SELECT  v.Edificio, m.CodMuro
            FROM Vano v INNER JOIN Muro m ON m.Piano = v.Piano
            WHERE v.Edificio = CodEdificio_f
    ),

    SensoriScelti as(
        select *
        from    Sensore S inner join MuriScelti M on S.Muro = M.CodMuro    
    ),
    
    RegistrazioniEdificio as(
        select M.Sensore, M.ValoreX, M.ValoreY, M.ValoreZ
        from SensoriScelti S inner join Misura M on S.CodSensore=M.Sensore
        where  timestamp >= current_timestamp - interval 1 day
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

--OP.4 Inserimento nuovo tipo di materiale generico

drop procedure if exists nuovo_materiale
delimiter $$

create procedure nuovo_materiale (in _CodLotto int, in _Fornitore VARCHAR(45), in _DataAcquisto DATE, in _Quantita int, in _CostoLotto decimal(10,2), in _Tipologia varchar(45), in _Descrizione varchar(255), in _Funzione varchar(45), in _X int, in _Y int, in _Z int)
begin
    insert into Materiale
    values (_CodLotto, _Fornitore, _DataAcquisto, _Quantita, _CostoLotto, _Tipologia);
    
    insert into MaterialeGenerico
    values (_CodLotto, _Fornitore, _Descrizione, _Funzione, _X, _Y, _Z);

end $$
delimiter ;

-- OP. 5 Stampa la busta paga relativa ad un operaio specificando anno e mese di interesse

drop procedure if exists calcola_bustapaga;
delimiter $$

create procedure calcola_bustapaga (in _dipendente char(16), in anno int, in mese int)
begin
    select count(*)*8 * PagaOraria as BustaPaga
    from Turno T inner join Lavoratore L on T.Lavoratore = L.CodFiscale
    where year(T.TimestampInizio) = anno and month(T.TimestampInizio) = mese and L.CodFiscale = _dipendente;
end $$
delimiter ;  

-- OP. 6------------------------------------------------
DROP PROCEDURE IF EXISTS NewTurnoOperaio;
DELIMITER $$

CREATE PROCEDURE NewTurnoOperaio(IN CodLavoro_f INT, IN CapoCantiere_f CHAR(16), IN Lavoratore_f CHAR(16), IN Inizio_f DATETIME(3), IN Fine_f DATETIME(3))
    BEGIN
		INSERT INTO Turno
		VALUES ( Inizio_f, Fine_f, CodLavoro_f, CapoCantiere_f, Lavoratore_f);
	END $$
DELIMITER ;


-- OP. 7------------------------------------------------
DROP PROCEDURE IF EXISTS RischiAnnuiEdificio;
DELIMITER $$

CREATE PROCEDURE RischiAnnuiEdificio(IN CodEdificio_f INT)
    BEGIN  
        DECLARE sede VARCHAR(45);
        SET sede = (
                SELECT AreaGeografica
                FROM Edificio
                WHERE CodEdificio =CodEdificio_f
        );
        SELECT *
        FROM Calamita
        WHERE AreaGeografica=sede
                AND YEAR(Data) = YEAR(CURRENT_DATE);
    END $$
DELIMITER ;


-- OP. 8------------------------------------------------
DROP PROCEDURE IF EXISTS InfoAlert;
DELIMITER $$

CREATE PROCEDURE InfoAlert(IN TimeStamp_f TIMESTAMP, IN CodSensore_f INT, OUT CodEdificio_f INT, OUT Piano_f INT, OUT CodVano_f INT, OUT CodMuro_f INT, OUT Pericolosita FLOAT)
    BEGIN
        DECLARE soglia_f FLOAT;

        SET CodMuro_f = (
            SELECT Muro
            FROM Sensore
            WHERE CodSensore = CodSensore_f
        );

        SET CodVano_f = (
            SELECT Vano1
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

        SET Pericolosita = (
            SELECT ValoreSuperamento
            FROM Alert
            WHERE TimeStamp = TimeStamp_f
                AND Sensore = CodSensore_f
        ) - soglia_f;
    END $$ 
DELIMITER ;
