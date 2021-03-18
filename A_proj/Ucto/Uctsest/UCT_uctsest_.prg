
*
** podklady pro UCETSALw *******************************************************
function uct_ucetsalw()
  local cobd_akt := subStr(obdReport,4) +left(obdReport,2), ckeys
  local cfilter
*-  local cobd_akt := strZero(uctOBDOBI:uct:nrok,4) +strZero(uctOBDOBI:uct:nobdobi,2), ckeys

  drgDBMS:open('ucetsalk')  ;  ucetsalk->(ordSetfocus('UCSALD06')        , ;
                                          dbSetScope(SCOPE_BOTH,cobd_akt), ;
                                          dbGoTop()                        )

  drgDBMS:open('ucetsald')  ;  ucetsald->(ordSetFocus('UCSALD09'))
  drgDBMS:open('ucetsalw',.t.,.t.,drgINI:dir_USERfitm); ZAP

  cfilter := ucetsalw->(Ads_getAOF())
  if( .not. empty(cfilter), ucetsalw->(Ads_clearAOF(), dbgotop()), nil )

  drgServiceThread:progressStart(drgNLS:msg('Saldokonto k obdobi ... ', cobd_akt), ;
                                             ucetsalk->(lastRec())                 )

  do while .not. ucetsalk->(eof())

    if .not. ucetsalk->lisClose
      ckeys := upper(ucetsalk->cucetMd) +upper(ucetsalk->csymbol)
      ucetsald->(dbSetScope(SCOPE_TOP   , ckeys +'000000')                , ;
                 dbSetScope(SCOPE_BOTTOM, ckeys +cobd_akt)                , ;
                 dbgotop()                                                , ;
                 dbEval( {|| mh_copyfld('ucetsald','ucetsalw',.t., .f.) }), ;
                 dbClearScope()                                             )
    endif
    drgServiceThread:progressInc()
    ucetsalk->(dbSkip())
 enddo

 drgServiceThread:progressEnd()
  ucetsalw->(dbcommit())
   ucetsalk->(dbClearScope())
    ucetsald->(dbClearScope())
     if( .not. empty(cfilter), ucetsalw->(Ads_setAOF(cfilter), dbgotop()), nil )
return .t.