select * from pvpkumulw_, cenzboz
               where pvpkumulw_.cobdpoh='12/12' and pvpkumulw_.ccissklad = cenzboz.ccissklad and 
			    pvpkumulw_.csklpol = cenzboz.csklpol and (pvpkumulw_.nmnozkon<>cenzboz.nmnozSzbo or pvpkumulw_.ncenakon<>cenzboz.ncenaCzbo)