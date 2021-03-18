update cenzboz set cenzboz.ncenaczbo  = pvpkumul.ncenakon,
                   cenzboz.nmnozszbo = pvpkumul.nmnozkon,
                   cenzboz.nmnozdzbo = pvpkumul.nmnozkon
               from pvpkumul  
               where cenzboz.ccissklad = pvpkumul.ccissklad and cenzboz.csklpol = pvpkumul.csklpol and pvpkumul.cObdPoh = '12/15'

