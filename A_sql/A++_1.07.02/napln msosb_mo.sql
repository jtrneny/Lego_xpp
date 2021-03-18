insert into msosb_mo (nrokobd,nOsCisPrac) select distinct [nRokObd],[nOsCisPrac] from msprc_mo  ;

update msosb_mo set msosb_mo.ctask       = msprc_mo.ctask,
                    msosb_mo.cUloha      = msprc_mo.cUloha,
                    msosb_mo.cObdobi     = msprc_mo.cObdobi,
                    msosb_mo.nRok        = msprc_mo.nRok,
                    msosb_mo.nObdobi     = msprc_mo.nObdobi,
                    msosb_mo.nCtvrtleti  = msprc_mo.nCtvrtleti,
                    msosb_mo.nCisOsoby   = msprc_mo.nCisOsoby,
                    msosb_mo.cPrijOsob   = msprc_mo.cPrijOsob,
                    msosb_mo.cJmenoOsob  = msprc_mo.cJmenoOsob,
                    msosb_mo.cOsoba      = msprc_mo.cOsoba,
                    msosb_mo.cTitulPred  = msprc_mo.cTitulPred,
                    msosb_mo.cTitulZa    = msprc_mo.cTitulZa,
                    msosb_mo.cRozlJmena  = msprc_mo.cRozlJmena,
                    msosb_mo.cJmenoRozl  = msprc_mo.cJmenoRozl,
                    msosb_mo.lStavem     = msprc_mo.lStavem,
                    msosb_mo.nStavem     = msprc_mo.nStavem,
                    msosb_mo.nZdrPojis   = msprc_mo.nZdrPojis,
                    msosb_mo.nZdrPojCP   = msprc_mo.nZdrPojCP,
                    msosb_mo.nTypDuchod  = msprc_mo.nTypDuchod,
                    msosb_mo.lDanProhl   = msprc_mo.lDanProhl,
                    msosb_mo.lDanVypoc   = msprc_mo.lDanVypoc,
                    msosb_mo.lDanRezid   = msprc_mo.lDanRezid,
                    msosb_mo.lStudent    = msprc_mo.lStudent,
                    msosb_mo.lPrukazZPS  = msprc_mo.lPrukazZPS,
                    msosb_mo.cPrukazZPS  = msprc_mo.cPrukazZPS,
                    msosb_mo.nOdpocObd   = msprc_mo.nOdpocObd,
                    msosb_mo.nOdpocRok   = msprc_mo.nOdpocRok,
                    msosb_mo.nDanUlObd   = msprc_mo.nDanUlObd,
                    msosb_mo.nDanUlRok   = msprc_mo.nDanUlRok,
                    msosb_mo.nVekZamest  = msprc_mo.nVekZamest,
                    msosb_mo.nObdNarZam  = msprc_mo.nObdNarZam,
                    msosb_mo.nRokObdSta  = msprc_mo.nRokObdSta,
                    msosb_mo.cRoObCp     = left(msprc_mo.cRoObCpppv,11),
                    msosb_mo.cRoCp       = left(msprc_mo.cRoCpppv,9),
					msosb_mo.nOsoby      = msprc_mo.nOsoby 				
                from msprc_mo where msosb_mo.nrokobd = msprc_mo.nrokobd and
				                     msosb_mo.noscisprac = msprc_mo.noscisprac		;	
				      
 update msprc_mo set msprc_mo.nmsosb_mo  = msosb_mo.sid
                 from msosb_mo where msosb_mo.nrokobd = msprc_mo.nrokobd and
				                     msosb_mo.noscisprac = msprc_mo.noscisprac			

