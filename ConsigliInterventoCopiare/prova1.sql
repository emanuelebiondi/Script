drop procedure if exists consigli_intervento_edificio;
delimiter $$
create procedure consigli_intervento_edificio (in _id_edificio int)
begin
	
    call stato_murature() ;
	call stato_solai() ;
	call stato_muri() ;
    
	with 
	muri_piano as (
		select v.id_edificio, v.piano, count(distinct id_muro) numero_muri
        from Perimetro p
        inner join Vano v on v.id_vano=p.id_vano
        group by v.id_edificio, v.piano
    ),
    effetto_domino_piano as (
		select *, 
				sum(numero_muri) over(partition by id_edificio order by piano desc) numero_muri_sopra,
				sum(numero_muri) over(partition by id_edificio order by piano asc) numero_muri_sotto,
				max(piano) over(partition by id_edificio) - piano as numero_solai_sopra,
				piano - min(piano) over(partition by id_edificio) as numero_solai_sotto
		from muri_piano ),    
    stato_elementi as (
		select	m.id_edificio, 'piano' as oggetto, m.piano as id, 
				m.deficit_muratura as deficit, 'rinforzo muratura' as intervento,
                round(n.numero_muri*costo_muro()*(m.scostamento/100),0) as costo_immediato,
                round(n.numero_muri_sopra*costo_muro() + n.numero_solai_sopra*costo_solaio(),0) as costo_futuro,
                1 as rischio
		from stato_murature m
        inner join effetto_domino_piano n on n.id_edificio=m.id_edificio and n.piano=m.piano
        where m.deficit_muratura > 0
        union
		select	s.id_edificio, 'piano' as oggetto, s.piano as id, 
				s.deficit_solai as deficit, 'consolidamento solaio' as intervento,
                round(1*costo_solaio()*(s.scostamento/100),0) as costo_immediato,
                round(n.numero_solai_sotto*costo_solaio(),0) as costo_futuro,
                1 as rischio
		from stato_solai s
        inner join effetto_domino_piano n on n.id_edificio=s.id_edificio and n.piano=s.piano
        where s.deficit_solai > 0
        union
		select	m.id_edificio, 'id muro' as oggetto, m.id_muro as id, 
				m.deficit_locale_muri as deficit, 'rinforzo locale muratura' as intervento,
                round(1*costo_muro()*(m.scostamento/100),0) as costo_immediato,
                round(n.numero_muri_sopra*costo_muro() + n.numero_solai_sopra*costo_solaio(),0) as costo_futuro,
                1/n.numero_muri as rischio
		from stato_muri m
        inner join effetto_domino_piano n on n.id_edificio=m.id_edificio and n.piano=m.piano
        where m.deficit_locale_muri > 0
    ),
	last_rischio as (
		select r.id_area, r.rischio, r.coeff_rischio, r.dataora,
				lead(r.coeff_rischio) over(partition by r.id_area, r.rischio order by r.dataora) lead_coeff
        from Rischio r
    )
	select 	e.id_edificio, e.tipo_edificio, 
			s.oggetto, s.id, s.deficit, s.intervento, 
            s.costo_immediato, s.costo_futuro,
            round(1/r.coeff_rischio/s.rischio) as giorni_prima_del_rischio,
            rank() over(order by costo_futuro/round(1/r.coeff_rischio/s.rischio) desc) ranking
    from stato_elementi s
    inner join Edificio e on e.id_edificio=s.id_edificio
    left join last_rischio r on r.id_area=e.id_area and r.rischio='SISMICO' and r.lead_coeff is null
    where e.id_edificio = _id_edificio
    ;
	
end $$
delimiter ;