    delete from ucetpol 
       where ucetpol.nrok = 2012 and culoha='S' and
         ucetpol.ndoklad NOT IN ( select pvphead.ndoklad from pvphead where ucetpol.ndoklad = pvphead.ndoklad ) 
    
