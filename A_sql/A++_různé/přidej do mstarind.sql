delete from mstarind   ; 
INSERT INTO mstarind
      (cTask,cUloha,nCisOsoby,nOsCisPrac,nPorPraVzt,cJmenoRozl,cMzdKatPra,cTypTarPou,cTypTarMzd,cDelkPrDob,dPlatTarOd,nTarSazHod,nTarSazMes,lAktTarif,cRoObCpPPv)
SELECT 'MZD','M',nCisOsoby,nOsCisPrac,nPorPraVzt,cJmenoRozl,cMzdKatPra,'NEPOUZIV','CASOVA',cDelkPrDob,'01.01.2013',nTarSazHod,nTarSazMes,true,cRoObCpPPv
FROM   msprc_mo where cobdobi = '07/13' and ntarsazhod<>0     ;

INSERT INTO mstarind
      (cTask,cUloha,nCisOsoby,nOsCisPrac,nPorPraVzt,cJmenoRozl,cMzdKatPra,cTypTarPou,cTypTarMzd,,cDelkPrDob,dPlatTarOd,nTarSazHod,nTarSazMes,lAktTarif,cRoObCpPPv)
SELECT 'MZD','M',nCisOsoby,nOsCisPrac,nPorPraVzt,cJmenoRozl,cMzdKatPra,'NEPOUZIV','MESICNI',cDelkPrDob,'01.01.2013',nTarSazHod,nTarSazMes,true,cRoObCpPPv
FROM   msprc_mo where cobdobi = '07/13' and ntarsazmes<>0


