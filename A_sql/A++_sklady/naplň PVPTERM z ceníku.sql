INSERT INTO PVPTERM( CTYPIMPORT,CTYPPOHYBU,nTypPVP,NTYPPOHYB,NDOKLAD,NORDITEM,cCisSklad,cSklPol,CULOZZBO,CZKRCARKOD,cCarKod,cNazZbo,nZboziKat,NCENADOKL1,
                     NMNOZDOKL1,CMJDOKL1,nCenaDokl,nCenapZbo,nCenamZbo,nCenasZbo,CZKRATMENY,cPolCen,nCarkKod,CSKLADKAM,CSKLPOLKAM )
       SELECT        'E','80',3,80,0,0,cCisSklad,cSklPol,CULOZZBO,CZKRCARKOD,cCarKod,cNazZbo,nZboziKat,nCenasZbo,
                     NMNOZSZBO,CZKRATJEDN,0,nCenapZbo,nCenamZbo,nCenasZbo,CZKRATMENY,cPolCen,nCarkKod,'2',cSklPol
       FROM CENZBOZ WHERE (cCisSklad = '30' and nmnozszbo > 0) ;




