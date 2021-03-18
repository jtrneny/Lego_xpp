insert into msodppol (ctask, cUloha, nRok,cKmenStrPr, nOsCisPrac, cPracovnik, cOsoba, cOsobaRP, cJmenoRoRP, cJmenoRozl, nPorPraVzt, nPorOdpPol, cTypOdpPol,
                         cNazOdpPol, dPlatnOd, dPlatnDo, cObdOd, cObdDo, nOdpocObd, nOdpocRok,nDanUlObd, nDanUlRok, cRodCisRP, nCisOsoRP,
                         nRodPrisl, lAktiv, lAktMesOdp, lOdpocet, lDanUleva, cTmKmStrPr, cRoCpPPv, nVazOsoby)
           select  ctask, cUloha, nRok, cKmenStrPr, nOsCisPrac, cPracovnik, cOsoba, cOsobaRP, cJmenoRoRP, cJmenoRozl, nPorPraVzt, nPorOdpPol, cTypOdpPol,
                   cNazOdpPol, '01.07.2017', dPlatnDo, '07/17', cObdDo, nOdpocObd, nOdpocRok, 1617, 19404, cRodCisRP, nCisOsoRP,
                   nRodPrisl, lAktiv, lAktMesOdp, lOdpocet, lDanUleva, cTmKmStrPr, cRoCpPPv, nVazOsoby as msodppolq
           from msodppol where nrok= 2017 and ctypodppol ='DIT2' and  ( dplatndo > '30.6.2017' or dplatndo is null or cast(dplatndo as SQL_CHAR) = '')   ;     

insert into msodppol (ctask, cUloha, nRok,cKmenStrPr, nOsCisPrac, cPracovnik, cOsoba, cOsobaRP, cJmenoRoRP, cJmenoRozl, nPorPraVzt, nPorOdpPol, cTypOdpPol,
                         cNazOdpPol, dPlatnOd, dPlatnDo, cObdOd, cObdDo, nOdpocObd, nOdpocRok,nDanUlObd, nDanUlRok, cRodCisRP, nCisOsoRP,
                         nRodPrisl, lAktiv, lAktMesOdp, lOdpocet, lDanUleva, cTmKmStrPr, cRoCpPPv, nVazOsoby)
            select  ctask, cUloha, nRok, cKmenStrPr, nOsCisPrac, cPracovnik, cOsoba, cOsobaRP, cJmenoRoRP, cJmenoRozl, nPorPraVzt, nPorOdpPol, cTypOdpPol,
                    cNazOdpPol, '01.07.2017', dPlatnDo, '07/17', cObdDo, nOdpocObd, nOdpocRok, 2017, 24204, cRodCisRP, nCisOsoRP,
                    nRodPrisl, lAktiv, lAktMesOdp, lOdpocet, lDanUleva, cTmKmStrPr, cRoCpPPv, nVazOsoby as msodppolq
        from msodppol where nrok= 2017 and ctypodppol ='DIT3' and  ( dplatndo > '30.6.2017' or dplatndo is null or cast(dplatndo as SQL_CHAR) = '')   ;     
		
		
update msodppol set dplatndo = '30.6.2017', cObdDo = '06/17' where nrok= 2017 and ( (ctypodppol ='DIT2' and nDanUlObd = 1417) or ( ctypodppol ='DIT3' and nDanUlObd = 1717) ) and 
                                                              ( dplatndo > '30.6.2017' or dplatndo is null or cast(dplatndo as SQL_CHAR) = '')    ;

update msprc_mo set msprc_mo.nDanUlObd = ( select sum(msodppol.nDanUlObd) from msodppol where 
											   msprc_mo.nrok = msodppol.nrok and
											    msprc_mo.noscisprac = msodppol.noscisprac and
                                                 msprc_mo.nporpravzt = msodppol.nporpravzt and
												   msodppol.cObdDo >= '07/17' ),
                    msprc_mo.nDanUlRok = ( select sum(msodppol.nDanUlRok) from msodppol where 
											   msprc_mo.nrok = msodppol.nrok and
											    msprc_mo.noscisprac = msodppol.noscisprac and
                                                 msprc_mo.nporpravzt = msodppol.nporpravzt and
												   msodppol.cObdDo >= '07/17' )												   		
                       where msprc_mo.cobdobi = '07/17' and msprc_mo.nDanUlObd > 0 and msprc_mo.nDanUlObd <> 2070 and
					          msprc_mo.lstavem
                           												
											                															        
