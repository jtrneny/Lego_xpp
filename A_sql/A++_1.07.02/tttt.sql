// insert into msosb_mo (nrokobd,noscisprac,ncisosoby ) select DISTINCT [nrokobd],[noscisprac],ncisosoby  from msprc_mo where nrok >= 2013
insert into msosb_mo (nrokobd,nOsCisPrac,ctask,cUloha,cObdobi,nRok,nObdobi,nCtvrtleti,nCisOsoby,cPrijOsob,cJmenoOsob,cOsoba,cTitulPred,cTitulZa,
cRozlJmena,cJmenoRozl,lStavem,nStavem,nZdrPojis,nZdrPojCP,nTypDuchod)
select distinct [nRokObd],[nOsCisPrac],ctask,cUloha,cObdobi,nRok,nObdobi,nCtvrtleti,nCisOsoby,cPrijOsob,cJmenoOsob,cOsoba,cTitulPred,cTitulZa,
cRozlJmena,cJmenoRozl,lStavem,nStavem,nZdrPojis,nZdrPojCP,nTypDuchod
from msprc_mo where nrok >= 2013 and noscisprac=411 