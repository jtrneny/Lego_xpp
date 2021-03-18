
insert into msmzdyhd (ctask,cUloha,cDenik,cTypMasky,CTYPDOKLAD,CTYPPOHYBU,
                      nOsCisPrac,nPorPraVzt,lAutoVypHM,nAutoGen,lzaklMatr,
                      nkeyMatr,cnazMatr)
       select         ctask,cUloha,'MH','GENDO','MZD_PRIJEM','HRUBMZDA',
                      nOsCisPrac,nPorPraVzt,false,nAutoGen,false,
                      10,'Pøíspìvky'
       from msprc_mo where cobdobi = '08/14' and lstavem = true and ( ckmenstrpr = '101' or ckmenstrpr = '600' or ckmenstrpr = '602')



insert into msmzdyit (ctask,cUloha,cDenik,CTYPDOKLAD,CTYPPOHYBU,nOrdItem,
                      cKmenStrPr,nOsCisPrac,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                      nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,cPracZarDo,dDatPoriz,CUCETSKUP,nDruhMzdy,
                      cNazPol1,
                      nDnyDoklad,nHodDoklad,nMnPDoklad,nSazbaDokl,nMzda,nHrubaMZD,
                      nkeyMatr)                                  
       select         ctask,cUloha,'MH','MZD_PRIJEM','HRUBMZDA',1
                      cKmenStrPr,nOsCisPrac,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                      nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,cPracZarDo,dDatPoriz,'330',330,
                      cNazPol1,
                      nDnyDoklad,nHodDoklad,nMnPDoklad,95,95,95,
                      10      
       from msprc_mo where cobdobi = '08/14' and lstavem = true and ( ckmenstrpr = '101' or ckmenstrpr = '600' or ckmenstrpr = '602')



insert into msmzdyhd (ctask,cUloha,cDenik,cTypMasky,CTYPDOKLAD,CTYPPOHYBU,
                      nOsCisPrac,nPorPraVzt,lAutoVypHM,lzaklMatr,
                      nkeyMatr,cnazMatr)
       select         ctask,cUloha,'MH','GENDO','MZD_PRIJEM','HRUBMZDA',
                      nOsCisPrac,nPorPraVzt,false,false,
                      10,'Pøíspìvky'
       from msprc_mo where cobdobi = '08/14' and lstavem  and ( ckmenstrpr = '101' or ckmenstrpr = '600' or ckmenstrpr = '602');



insert into msmzdyit (ctask,cUloha,cDenik,CTYPDOKLAD,CTYPPOHYBU,nOrdItem,
                      cKmenStrPr,nOsCisPrac,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                      nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,CUCETSKUP,nDruhMzdy,
                      cNazPol1,
                      nSazbaDokl,nMzda,nHrubaMZD,nkeyMatr)                                  
       select         ctask,cUloha,'MH','MZD_PRIJEM','HRUBMZDA',1
                      cKmenStrPr,nOsCisPrac,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                      nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,'330',330,
                      cNazPol1,
                      95,95,95,10      
       from msprc_mo where cobdobi = '08/14' and lstavem and ( ckmenstrpr = '101' or ckmenstrpr = '600' or ckmenstrpr = '602')
