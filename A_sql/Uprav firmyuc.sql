update firmyuc set cbanis = ''   ;
update firmyuc set cbanis = SUBSTRING( cucet, POSITION( '/' IN cucet)+1,4) where POSITION( '/' IN cucet) > 0  ;  
update firmyuc set cbank_sta = 'CZ' where POSITION( '/' IN cucet) > 0 ;
update firmyuc set firmyuc.cbic = c_banky.cbIC from c_banky where firmyuc.cbanis <> ' ' and firmyuc.cbanis = c_banky.cbanis  
