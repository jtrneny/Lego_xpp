INSERT INTO autom_it ( nRok,nObdobi,cObdobi,nTYP_AUT,nSUB_AUT,CNAZPOL_OD,CNAZPOL_DO,CMROZP_CO,CMROZP_KAM,CUCET_MD,
                       CUCET_DAL,CROZP__STR,CROZP___CO,lUKONCENO,dVznikZazn)
SELECT                 nRok,12,'12/14',nTYP_AUT,nSUB_AUT,CNAZPOL_OD,CNAZPOL_DO,CMROZP_CO,CMROZP_KAM,CUCET_MD,
                       CUCET_DAL,CROZP__STR,CROZP___CO,lUKONCENO,curdate() FROM autom_it_

