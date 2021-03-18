//insert into c_listvl (nlistvlast,ctask,dvznikzazn)
//      SELECT DISTINCT [nlistvlast],'HIM',curdate() FROM pozemky

insert into c_listvl( cku_Kod, nlistVlast)
            SELECT DISTINCT [cku_kod],[nlistVlast]
			 FROM pozemky ORDER BY cku_kod,nlistVlast         ;

update c_listvl set c_listvl.cku_Nazev = c_katast.cku_Nazev
                from c_katast where c_listvl.cku_Kod = c_katast.cku_Kod