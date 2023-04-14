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
