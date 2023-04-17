drop function if exists stima_gravita;
delimiter :)
create function stima_gravita(_datacalamita datetime, _tipocalamita varchar(45), _latitudine decimal(9,6), _longitudine decimal(9,6), _zona varchar(45)) returns float reads sql data
begin
	declare _lat_centro, _long_centro decimal(9, 6);
    declare _intensita, _k float;
    
	select latitudine, longitudine, intensita
    into _lat_centro, _long_centro, _intensita
    from calamita
    where data = _datacalamita and tipo = _tipocalamita;
    
    if _lat_centro is null or _long_centro is null or _intensita is null then
		signal sqlstate "45000" set message_text = "Calamita non inserita correttamente";
	end if;
    
    select coefficienterischio into _k from rischiogeologico where zona = _zona and tipologia = _tipocalamita;
    
	if _k is null then
		signal sqlstate "45000" set message_text = "ZonaGeografica non soggetta a tale rischio o parametri errati";
	end if;
    
    return pga_to_mercalli(mercalli_to_pga(_intensita)/power(distanza_superficie_terrestre(_latitudine, _longitudine, _lat_centro, _long_centro)/_k+1, 2));
end :)
delimiter ;