//delete from mssazzam where cTypSazby ='SAZOSOOHOD'  ; 
INSERT INTO mssazzam
       (cTask,cUloha,nOsCisPrac,nPorPraVzt,cJmenoRozl,cTypSazby,cDelkPrDob,dPlatSazOd,nSazba,nSazOsoOh,lAKTSAZBA)
SELECT 'MZD','M',nOsCisPrac,nPorPraVzt,cJmenoRozl,'SAZOSOOHOD',cDelkPrDob,dPlatSazOd,nSazOsoOh,nSazOsoOh,true
FROM   msprc_mo where cobdobi = '07/13' 
