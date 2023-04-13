--OP.1 Stampare le registrazioni di ogni sensore di un edificio nelle ultime 24 ore

drop procedure if exists stampa_registrazioni_24;
delimiter $$

create procedure stampa_registrazioni_24 (in CodEdificio int)
begin
    with RegistrazioneScelta as(
        select 
        from Sensore S 
        where
    )

delimiter ;

--OP.2 Stampa le informazioni della pianta di ogni piano di un edificio

drop procedure if exists info_pianta_edificio
delimiter   $$

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

--OP.4 Inserimento nuovo materiale

drop procedure if exists NuovoMateriale
delimiter $$

create procedure NuovoMateriale (in _CodLotto int, in _Fornitore VARCHAR(45), in _DataAcquisto DATE, in _Quantita int, in _CostoLotto decimal(10,2), in _Tipologia varchar(45))
begin
    insert into 