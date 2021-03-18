
insert into msodppol (ctask, cUloha, nRok,cKmenStrPr, nOsCisPrac, cPracovnik, cOsoba, cOsobaRP, cJmenoRoRP, cJmenoRozl, nPorPraVzt, nPorOdpPol, cTypOdpPol,
                         cNazOdpPol, dPlatnOd, dPlatnDo, cObdOd, cObdDo, nOdpocObd, nOdpocRok,nDanUlObd, nDanUlRok, cRodCisRP, nCisOsoRP,
                         nRodPrisl, lAktiv, lAktMesOdp, lOdpocet, lDanUleva, cTmKmStrPr, cRoCpPPv)
           select  ctask, cUloha, nRok, cKmenStrPr, nOsCisPrac, cPracovnik, cOsoba, cOsobaRP, cJmenoRoRP, cJmenoRozl, nPorPraVzt, nPorOdpPol, cTypOdpPol,
                   cNazOdpPol, '01.05.2016', dPlatnDo, '05/16', cObdDo, nOdpocObd, nOdpocRok, 1417, 17004, cRodCisRP, nCisOsoRP,
                   nRodPrisl, lAktiv, lAktMesOdp, lOdpocet, lDanUleva, cTmKmStrPr, cRoCpPPv as msodppolq
           from msodppol where nrok= 2016 and ctypodppol ='DIT2' and  ( dplatndo > '30.4.2016' or dplatndo is null or cast(dplatndo as SQL_CHAR) = '')   ;     

insert into msodppol (ctask, cUloha, nRok,cKmenStrPr, nOsCisPrac, cPracovnik, cOsoba, cOsobaRP, cJmenoRoRP, cJmenoRozl, nPorPraVzt, nPorOdpPol, cTypOdpPol,
                         cNazOdpPol, dPlatnOd, dPlatnDo, cObdOd, cObdDo, nOdpocObd, nOdpocRok,nDanUlObd, nDanUlRok, cRodCisRP, nCisOsoRP,
                         nRodPrisl, lAktiv, lAktMesOdp, lOdpocet, lDanUleva, cTmKmStrPr, cRoCpPPv)
            select  ctask, cUloha, nRok, cKmenStrPr, nOsCisPrac, cPracovnik, cOsoba, cOsobaRP, cJmenoRoRP, cJmenoRozl, nPorPraVzt, nPorOdpPol, cTypOdpPol,
                    cNazOdpPol, '01.05.2016', dPlatnDo, '05/16', cObdDo, nOdpocObd, nOdpocRok, 1717, 20604, cRodCisRP, nCisOsoRP,
                    nRodPrisl, lAktiv, lAktMesOdp, lOdpocet, lDanUleva, cTmKmStrPr, cRoCpPPv as msodppolq
        from msodppol where nrok= 2016 and ctypodppol ='DIT3' and  ( dplatndo > '30.4.2016' or dplatndo is null or cast(dplatndo as SQL_CHAR) = '')   ;     
		
		
update msodppol set dplatndo = '30.4.2016', cObdDo = '04/16' where nrok= 2016 and ( (ctypodppol ='DIT2' and nDanUlObd = 1317) or ( ctypodppol ='DIT3' and nDanUlObd = 1417) ) and 
                                                              ( dplatndo > '30.4.2016' or dplatndo is null or cast(dplatndo as SQL_CHAR) = '')    ;

update msprc_mo set msprc_mo.nDanUlObd = ( select sum(msodppol.nDanUlObd) from msodppol where 
											   msprc_mo.nrok = msodppol.nrok and
											    msprc_mo.noscisprac = msodppol.noscisprac and
                                                 msprc_mo.nporpravzt = msodppol.nporpravzt and
												   msodppol.cObdDo >= '05/16' ),
                    msprc_mo.nDanUlRok = ( select sum(msodppol.nDanUlRok) from msodppol where 
											   msprc_mo.nrok = msodppol.nrok and
											    msprc_mo.noscisprac = msodppol.noscisprac and
                                                 msprc_mo.nporpravzt = msodppol.nporpravzt and
												   msodppol.cObdDo >= '05/16' )												   		
                       where msprc_mo.cobdobi = '05/16' and msprc_mo.nDanUlObd > 0 and msprc_mo.nDanUlObd <> 2070 and
					          msprc_mo.lstavem
                           												
											                															        
