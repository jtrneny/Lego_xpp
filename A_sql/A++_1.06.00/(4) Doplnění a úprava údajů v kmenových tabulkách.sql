update osoby set cjmenoRozl = rtrim( cprijOsob)+' ' +
                              rtrim(cjmenoOsob)     +
                              IIF( crozlJmena is null, ' ', ' ' +RTRIM(crozlJmena) )   ;         


update osoby set cosoba = IIF( cTitulPred is null or ctitulPred = '', '', RTRIM(cTitulPred) +' ' ) +
                               rtrim( cprijOsob)+' ' +
                               rtrim(cjmenoOsob)     +
                               IIF( cTitulZa is null or ctitulZa = '', '', ',' +RTRIM(cTitulZa) )      ;      


update msprc_mo set msprc_mo.ncisosoby   =osoby.ncisosoby,
                    msprc_mo.cPrijOsob   =osoby.cPrijOsob,
                    msprc_mo.cJmenoOsob  =osoby.cJmenoOsob,     
                    msprc_mo.cosoba      =osoby.cosoba,
                    msprc_mo.ctitulpred  =osoby.ctitulpred,
                    msprc_mo.ctitulza    =osoby.ctitulza,
                    msprc_mo.cPrijPrac   =osoby.cPrijOsob,
                    msprc_mo.cJmenoPrac  =osoby.cJmenoOsob,     
                    msprc_mo.cpracovnik  =osoby.cosoba,
                    msprc_mo.cjmenoRozl  =osoby.cjmenoRozl,
  	            msprc_mo.nosoby      =osoby.sid
       from osoby    
       where msprc_mo.noscisprac=osoby.noscisprac                       ;


update personal set personal.ncisosoby   =osoby.ncisosoby,
                    personal.cPrijOsob   =osoby.cPrijOsob,
                    personal.cJmenoOsob  =osoby.cJmenoOsob,     
                    personal.cosoba      =osoby.cosoba,
                    personal.ctitulpred  =osoby.ctitulpred,
                    personal.ctitulza    =osoby.ctitulza,
                    personal.cPrijPrac   =osoby.cPrijOsob,
                    personal.cJmenoPrac  =osoby.cJmenoOsob,     
                    personal.cpracovnik  =osoby.cosoba
       from osoby    
       where personal.noscisprac=osoby.noscisprac                       ;

update osoby set osoby.nis_ZAM=1 from msprc_mo where osoby.noscisprac=msprc_mo.noscisprac and osoby.noscisprac <> 0;
update osoby set osoby.nis_PER=1 from personal where osoby.noscisprac=personal.noscisprac and osoby.noscisprac <> 0
