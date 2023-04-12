drop trigger if exists check_piano;
delimiter $$
create trigger check_piano before insert on Piano for each row
begin
    if NEW.NumeroPiano > 0 and not exists (select 1 from Piano where Edificio = new.Edificio and NumeroPiano = new.NumeroPiano-1)
	then
        signal sqlstate '45000'
        set message_text = "Non puoi inserire il piano x senza il piano x-1";
	end if;
    if NEW.NumeroPiano < 0 and not exists (select 1 from Piano where Edificio = new.Edificio and NumeroPiano = new.NumeroPiano+1)
	then
        signal sqlstate '45000'
        set message_text = "Non puoi inserire il piano sotterraneo x senza il piano x+1";
	end if;
end $$
delimiter ;


drop function if exists calcolo_costo_lavoro;
delimiter $$
create function calcolo_costo_lavoro(_CodLavoro int) returns decimal(10,2) reads sql data
begin
	declare costo_impiego, costo_materiale,costo_responsabile, costo_capocantiere decimal(10,2) default 0;

	select sum(L.PagaOraria * (TIMESTAMPDIFF(8, T.TimestampInizio, T.TimestampFine))) --Calcola la somma della paga di operaio conteggiando le ore di lavoro svolte
    into costo_impiego
	from Turno T inner join Lavoratore L on T.operaio = L.CodFiscale
	where T.Lavoro = _CodLavoro;
    
	select sum(M.CostoLotto)
    into costo_materiale
	from AcquistoMateriale A inner join Materiale M on A.Materiale = M.CodiceLotto
	where A.Lavoro = _CodLavoro;
    
    select sum(C.PagaOraria * (TIMESTAMPDIFF(8,T.TimestampInizio, T.TimestampFine)))
    into costo_capocantiere
    from Turno T inner join CapoCantiere C on T.CapoCantiere = C.CodFiscale
    where T.Lavoro =_CodLavoro;
    
    select PagaProgetto
    into costo_responsabile
    from StadioAvanzamentoProgetto S inner join Responsabile R on S.Responsabile = R.CodFiscale
    where id = S.CodStadio

    return costo_impiego + costo_responsabile + costo_materiale + costo_capocantiere;
end $$
delimiter ;


drop trigger if exists costo_lavoro;
delimiter $$
create trigger costo_lavoro after update on Lavoro for each row
begin
    if old.DataFine is null and new.DataFine is not null then
	    update Progetto
		set CostoProgetto = CostoProgetto + calcolo_costo_lavoro(new.id)
		where id = (select Progetto from StadioAvanzamentoProgetto where id = new.Stadio);
    end if;
end $$
delimiter ;

-- L'ora di inizio e fine di un turno di un lavoratore non sono coerenti
drop trigger if exists check_orario_turno_lavoratore
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

-- Controlla che non venga inserito un turno con stesso lavoratore che si sovrappone ad un suo turno preesistente
drop trigger if exists check_sovrapposizione_turno_lavoratore
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



