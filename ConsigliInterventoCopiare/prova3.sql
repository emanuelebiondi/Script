drop procedure if exists consigli_intervento;
delimiter :)
create procedure consigli_intervento(_edificio int, _datetime datetime)
begin
	select
		(prediction-soglia)*coefficiente_muri() as urgenza,
		if((prediction-soglia)*coefficiente_muri() < soglia_ricostruzione(), 'Consolidamento', 'Ricostruzione') as intervento,
        'Muro' as tipo_elemento,
        muro_sensore(SP.id) as id_elemento,
        costo_costruzione_muro_from_sensore(SP.id) as stima_spesa_crollo,
        SP.id as id_sensore
    from (
		select
			S.id,
			S.soglia,
			linear_best_fit_predict(S.id, _datetime, _datetime-interval 1 week, _datetime+interval 1 week) as prediction
		from sensore S inner join vano V on S.vano = V.id
		where V.edificio = _edificio and S.tipo='Allungamento'
        ) SP
	where prediction > soglia
 
    union
    
    select
		media_triassiale(_edificio, 'Accelerometro', 300, _datetime)*coefficiente_struttura_accelerometro() as urgenza,
		if(media_triassiale(_edificio, 'Accelerometro', 300, _datetime)*coefficiente_struttura_accelerometro() < soglia_ricostruzione(), 'Consolidamento', 'Ricostruzione') as intervento,
        'Struttura edificio' as tipo_elemento,
        null as id_elemento,
        costo_lavori_edificio(_edificio) as stima_spesa_crollo,
        null as id_sensore
        
	union
    
	select
        media_triassiale(_edificio, 'Giroscopio', 300, _datetime)*coefficiente_struttura_giroscopio() as urgenza,
		if(media_triassiale(_edificio, 'Giroscopio', 300, _datetime)*coefficiente_struttura_giroscopio() < soglia_ricostruzione(), 'Raddrizzamento', 'Ricostruzione') as intervento,
        'Struttura edificio' as tipo_elemento,
        null as id_elemento,
        costo_lavori_edificio(_edificio) as stima_spesa_crollo,
        null as id_sensore
        
	union

    select * from
		(select
			(max(M.xOppureUnico)-min(M.xOppureUnico)-offset_escursione())*coefficiente_ambiente_escursione() as urgenza,
			'Cappotti di isolamento' as intervento,
			'Vano' as tipo_elemento,
			V.id as id_elemento,
			0 as stima_spesa_crollo,
			S.id as id_sensore
		from sensore S inner join vano V on S.vano = V.id inner join misura M on M.sensore = S.id
		where
			V.edificio = _edificio and
			S.tipo='Temperatura' and
			M.timestamp between _datetime-interval 1 week and _datetime
		group by S.id) TMP
	where TMP.urgenza >= 0
    
    union
    
    select * from
		(select
			(avg(M.xOppureUnico)-S.soglia)*coefficiente_ambiente_temperatura() as urgenza,
			'Installazione climatizzazione' as intervento,
			'Vano' as tipo_elemento,
			V.id as id_elemento,
			0 as stima_spesa_crollo,
			S.id as id_sensore
		from sensore S inner join vano V on S.vano = V.id inner join misura M on M.sensore = S.id
		where
			V.edificio = _edificio and
			S.tipo='Temperatura' and
			M.timestamp between _datetime-interval 1 week and _datetime
		group by S.id) TMP
    where TMP.urgenza >= 0
    
    union
    
    select * from 
		(select
			(avg(M.xOppureUnico)-S.soglia)*coefficiente_ambiente_umidita() as urgenza,
			'Installazione deumidificatore' as intervento,
			'Vano' as tipo_elemento,
			V.id as id_elemento,
			0 as stima_spesa_crollo,
			S.id as id_sensore
		from sensore S inner join vano V on S.vano = V.id inner join misura M on M.sensore = S.id
		where
			V.edificio = _edificio and
			S.tipo='Umidita' and
			M.timestamp between _datetime-interval 1 week and _datetime
		group by S.id) TMP
    where TMP.urgenza >= 0

    order by urgenza desc;
    
end :)
delimiter ;