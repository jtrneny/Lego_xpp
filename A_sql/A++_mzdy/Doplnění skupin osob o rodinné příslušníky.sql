INSERT INTO osobysk(ncisosoby,czkr_skup)
       SELECT ncisosoby,'RPR'			
	   FROM osoby WHERE nis_rpr=1
