select sum(nmzda) from mzdyit
;
select nhrubamzda, 
       ndanzaklmz, 
	   nzaklsocpo, 
	   nzaklzdrpo, 
	   nmzdzaklad, 
	   ncistprije, 
	   ncastkvypl, 
	   nsuphmmz from mzdyhd



update mzdyhd set mzdyhd.nhrubamzda = mzdyhd.nhrubamzda +mzdyit.nmzda,
mzdyhd.ndanzaklmz = mzdyhd.ndanzaklmz +mzdyit.nmzda,
mzdyhd.nzaklsocpo = mzdyhd.nzaklsocpo +mzdyit.nmzda,
mzdyhd.nzaklzdrpo = mzdyhd.nzaklzdrpo +mzdyit.nmzda,
mzdyhd.nmzdzaklad = mzdyhd.nmzdzaklad +mzdyit.nmzda,
mzdyhd.ncistprije = mzdyhd.ncistprije +mzdyit.nmzda,
mzdyhd.ncastkvypl = mzdyhd.ncastkvypl +mzdyit.nmzda,
mzdyhd.nsuphmmz   = mzdyhd.nsuphmmz   +mzdyit.nmzda from mzdyit where mzdyhd.ndoklad = 73300104    and mzdyit.sid = 14         