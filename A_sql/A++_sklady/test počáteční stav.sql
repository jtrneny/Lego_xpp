select cenzboz.ccissklad,cenzboz.csklpol,cenzboz.ncenapoc,pvpkumul.ncenakon,cenzboz.nmnozpoc,pvpkumul.nmnozkon 
               from cenzboz, pvpkumul  
               where cenzboz.ccissklad = pvpkumul.ccissklad and cenzboz.csklpol = pvpkumul.csklpol and pvpkumul.cObdPoh = '12/15' and
                      ( cenzboz.ncenapoc <> pvpkumul.ncenakon or cenzboz.nmnozpoc <> pvpkumul.nmnozkon )  
