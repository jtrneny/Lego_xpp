select * from pvpkumul, cenzb_ps
               where pvpkumul.cobdpoh='12/10' and pvpkumul.ccissklad = cenzb_ps.ccissklad and 
			    pvpkumul.csklpol = cenzb_ps.csklpol and (pvpkumul.nmnozkon<>cenzb_ps.nmnozpoc or pvpkumul.ncenakon<>cenzb_ps.ncenapoc) and cenzb_ps.nrok = 2011
