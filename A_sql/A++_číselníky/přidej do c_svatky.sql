INSERT INTO C_SVATKY ( dDatum,cNazev,nRok,nMesic,nDen,lSvatek,lVolDen,nDistrib,dVznikZazn) 
       SELECT dDatum,cNazev,nRok,nMesic,nDen,lSvatek,lVolDen,nDistrib,'02.01.2018'
         FROM C_SVATKY_