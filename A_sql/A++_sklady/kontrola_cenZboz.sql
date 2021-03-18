select ccisSklad, csklPol, ncenaCzbo,
       nCenasZBO,
	   nMnozsZBO,
	   ncenaPzbo,
	   round(nCenasZBO * nMnozsZBO,2) as cenaCzbo,
	   ddatPzbo
       from cenZboz
	   where ncenaCzbo < 0 order by ddatPZbo
	   
select * from pvpItem where ccisSklad = '520' and csklPol = '6060117224' order by ddatPvp

select ncenaCzbo, nmnozSzbo, ncenaSzbo, 
       round(ncenaCzbo / nmnozSzbo, 4) as prumCena from cenZboz	
	   where nmnozSzbo <> 0   