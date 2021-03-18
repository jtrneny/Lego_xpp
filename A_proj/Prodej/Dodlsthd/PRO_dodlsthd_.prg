#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dbstruct.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


static b_pvphead, b_pvpitem, in_pro


function pro_dodlsthd_cpy(oDialog)
  local  nKy     := dodlsthd->ncisfak, inScope, x, apvp := {}, ky
  local  cky_pvp
  *
  local  lNEWrec := If( IsNull(oDialog), .F., oDialog:lNEWrec)

  ** tmp **
  drgDBMS:open('dodlsthdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('dodlstitw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('pvpheadw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('pvpitemw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  if .not. lNEWrec
    mh_copyfld('dodlsthd', 'dodlsthdw', .t., .t.)
    dodlsthdw->cobdobio := dodlsthd->cobdobi

    ky := strzero(dodlsthd->ndoklad,10)
    dodlstit->(AdsSetOrder('DODLIT5'),dbsetscope(SCOPE_BOTH,ky),dbgotop(), ;
               dbeval({|| mh_copyfld('dodlstit','dodlstitw',.t., .t.)}))

    cky_pvp := '2' +strZero(dodlsthd->ncisFirmy,5) +strzero(dodlsthd->ndoklad,10)

    pvp_head->(AdsSetOrder('PVPHEAD19'), dbSetScope(SCOPE_BOTH,cky_pvp), dbgotop(), ;
               dbeval( {|| mh_copyfld('pvp_head','pvpheadw',.t., .t.) })            )

    pvp_item->(AdsSetOrder('PVPITEM32'), dbSetScope(SCOPE_BOTH,cky_pvp), dbgotop(), ;
               dbeval( {||mh_copyfld('pvp_item','pvpitemw', .t., .t.) })            )

    *
*    pvp_head->(AdsSetOrder('PVPHEAD10'), dbSetScope(SCOPE_BOTH,dodlsthd->ndoklad), dbgotop(), ;
*               dbeval( {|| mh_copyfld('pvp_head','pvpheadw',.t., .t.) })                      )
*
*    pvp_item->(AdsSetOrder('PVPITEM17'), dbSetScope(SCOPE_BOTH,dodlsthd->ndoklad), dbgotop(), ;
*               dbeval( {||mh_copyfld('pvp_item','pvpitemw', .t., .t.) })                      )

  else
    dodlsthdw->(dbappend())
    if( .not. c_bankuc->(dbseek(.t.,,'bankuc2')), c_bankuc->(dbgotop()),nil)

    ( dodlsthdw ->cULOHA     := "E"                                     , ;
      dodlsthdw ->cOBDOBI    := uctOBDOBI:SKL:COBDOBI                   , ;
      dodlsthdw ->nROK       := uctOBDOBI:SKL:NROK                      , ;
      dodlsthdw ->nOBDOBI    := uctOBDOBI:SKL:NOBDOBI                   , ;
      dodlsthdw ->cOBDOBIDAN := uctOBDOBI:SKL:COBDOBIDAN                , ;
      dodlsthdw ->nKODZAOKRD := SYSCONFIG('FINANCE:nROUNDDPH')          , ;
      dodlsthdw ->cZKRATMENY := SYSCONFIG('FINANCE:cZAKLMENA')          , ;
      dodlsthdw ->dSPLATFAK  := DATE() +SYSCONFIG( 'FINANCE:nSPLATNOST'), ;
      dodlsthdw ->dVYSTFAK   := DATE()                                  , ;
      dodlsthdw ->dPOVINFAK  := DATE()                                  , ;
      dodlsthdw ->cBANK_UCT  := C_BANKUC ->cBANK_UCT                    , ;
      dodlsthdw ->cDENIK     := SYSCONFIG('FINANCE:cDENIKFAVY')         , ;
      dodlsthdw ->nKURZAHMEN := 1                                       , ;
      dodlsthdw ->nMNOZPREP  := 1                                       , ;
      dodlsthdw ->cJMENOVYS  := usrName                                 , ;
      dodlsthdw ->ndoklad    := fin_range_key('DODLSTHD')[2]            , ;
      dodlsthdw ->ncislodl   := dodlsthdw->ndoklad                      , ;
      dodlsthdw ->cZKRATMENZ := SYSCONFIG('FINANCE:cZAKLMENA')          , ;
      dodlsthdw ->cVYPSAZDAN := SYSCONFIG('FINANCE:cVYPSAZDPH')           )
  endif
return nil

*
** uložení dodacího listu z PRODEJE v transakci ********************************
function PRO_dodlsthd_wrt_inTrans(oDialog)
  local  lDone := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := PRO_dodlsthd_wrt(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE
return lDone


function PRO_dodlsthd_wrt(odialog)
  local  anDoi := {}, anPvh := {}, anPvi := {}, anLik := {}, aPvh := {}
  local                                         anLik_del
  local  uctLikv, mainOk := .t., nrecor, nrecpv, lastPvp := 0, newPvp := 0, pos, key
  local  ispvp //:= pro_dodlsthd_ispvp()
  *
  local  pa_recs, pa, rec_pvh, rec_pvi, x
  local  cf := "ccisSklad = '%%'", cfilter, cky
  local  omoment

  * rozboèka pro FIN - PRO
  * jde o odaci list vystavený v úloze PRODEJ ?
  if upper(dodlsthdW->culoha) = 'E' .and. upper(dodlsthdW->ctask) = 'PRO' .and. empty(dodlsthdW->csubTask)
    cky := upper(dodLSThdw->culoha) +upper(dodLSThdw->ctypdoklad) +upper(dodLSThdw->ctyppohybu)
    c_typpoh->(dbseek(cky,,'C_TYPPOH05'))
    in_Pro := .t.
  else
    in_Pro := .f.
  endif

  ispvp   := pro_dodlsthd_ispvp()
*  in_pro  := (lower(odialog:drgDialog:formName) = 'pro_dodlsthd_in')
  pa_sest := {}
  *
  dodlstitw->(AdsSetOrder(0), dbgotop(), ;
              dbeval({|| if(dodlstitw->_nrecor <> 0, aadd(anDoi,dodlstitw->_nrecor), nil) }))


  pvpheadw ->(AdsSetOrder(0), dbgotop(), ;
              dbeval({|| pro_dodlsthd_rlo(anPvh,anLik) }))

  pvpitemw ->(AdsSetOrder(0), dbgotop(), ;
              dbeval({|| if(pvpitemw ->_nrecor <> 0, aadd(anPvi,pvpitemw ->_nrecor), nil) }))

  *
  if( ispvp, pro_dodlsthd_pvp(), nil)

  if .not. odialog:lnewrec
    dodlsthd->(dbgoto(dodlsthdw->_nrecor))
    mainOk := dodlsthd->(sx_rlock())      .and. ;
              dodlstit->(sx_rlock(anDoi)) .and. ;
              pvp_head->(sx_rlock(anPvh)) .and. ;
              pvp_item->(sx_rlock(anPvi)) .and. ;
              ucetpol ->(sx_rlock(anLik))
  endif


  dodlstitw->(AdsSetOrder(0), dbgotop())

  if mainOk
    omoment := if( in_Pro, SYS_MOMENT( if( dodLSThdw->_delRec = '9', '=== RUŠÍM DOKLAD ===', '=== UKLÁDÁM DOKLAD ===')), nil )
    uctLikv := ''

    if(dodlsthdw->_delrec <> '9', mh_copyfld('dodlsthdw','dodlsthd',odialog:lnewRec, .f.), nil)

    dodlstitw->(dbgotop())
    do while .not. dodlstitw->(eof())

      if dodlstitw->_nrecpvph <> 0 .and. dodlstitw->_delrec <> '9'
        if ascan(aPvh,dodlstitw->_nrecpvph) = 0
          pvpheadw->(dbgoto(dodlstitw->_nrecpvph))
          if(nrecpv := pvpheadw->_nrecor) = 0
            newPvp := fin_range_key('PVPHEAD')[2]
            if(newPvp = lastPvp, newPvp++, nil )

            pvpheadw->ndoklad   := newPvp
            pvpheadw->ncislodl  := dodlsthd->ndoklad
            pvpheadw->ncislopvp := pvpheadw->ndoklad
          else
            pvp_head->(dbgoto(nrecpv))
          endif

          * výdejky jsou generované pro pøíslušný sklad
          mh_copyfld('pvpheadw','pvp_head',(nrecpv=0), .f.)

          if nrecpv = 0
*             newPvp := fin_range_key('PVPHEAD')[2]
*             pvp_head->ndoklad   := newPvp
*             pvp_head->ncislopvp := newPvp

             pvpheadw->ndoklad   := pvp_head->ndoklad
             pvpheadw->ncislodl  := dodlsthd->ndoklad
             pvpheadw->ncislopvp := pvp_head->ncislopvp
          endif

          cfilter := format( cf, { pvpheadw->ccisSklad } )
          pvpitemw->(Ads_setAOF( cfilter ), dbgoTop() )
            uctLikv  := UCT_likvidace():New(upper(pvpheadw->cUloha) +upper(pvpheadw->ctypdoklad),.t.)
            uctLikv:ucetpol_wrt()
            *
            pvp_head->nkLikvid := pvpheadw->nkLikvid
            pvp_head->nzLikvid := pvpheadw->nzLikvid
            *
          pvpitemw->(Ads_ClearAOF())

          aadd(aPvh,dodlstitw->_nrecpvph)

          if(pos := ascan(anPvh,pvpheadw ->_nrecor)) <> 0
            (adel(anPvh,pos),asize(anPvh,len(anPvh)-1))
          endif

          lastPvp := pvpheadW->ndoklad
        endif
      endif

      pvpheadw->(dbCommit())
      pvpitemw->(dbCommit())

      if((nrecor := dodlstitw->_nrecor) = 0, nil, dodlstit->(dbgoto(nrecor)))

      pa_recs := listAsArray(dodlstitw->ma_recs, ';')

      if   dodlstitw->_delrec = '9'  ; if(nrecpv := dodlstitw->_nrecpvpi) <> 0

                                          for x := 1 to len(pa_recs) step 1
                                            pa      := listAsArray(pa_recs[x])
                                            rec_pvh := val(pa[1])
                                            rec_pvi := val(pa[2])

                                            pvpitemw->(dbgoto(rec_pvi))

                                            ** šílená oprava **
                                            if pvpitemw->_nrecor <> 0
                                              pvp_item->(dbgoto(pvpitemw->_nrecor))
                                              pvpheadw->(dbgoto(rec_pvh))
                                              pvp_head->(dbgoto(pvpheadw ->_nrecor))

                                              *
                                              ** potøebujeme zrušit likvidaci
                                              pro_dodlsthd_del_likv_pvpi( anLik )
                                              pvp_item->(dbdelete())
                                            endif  

                                            if(pos := ascan(anPvi,pvpitemw->_nrecor)) <> 0
                                              aRemove(anPvi, pos)
                                            endif
                                          next
                                        endif
                                        dodlstit->(dbdelete())

      else                           ;  if dodlstitw->_nrecpvpi <> 0

                                          for x := 1 to len(pa_recs) step 1
                                            pa      := listAsArray(pa_recs[x])
                                            rec_pvh := val(pa[1])
                                            rec_pvi := val(pa[2])

                                            pvpheadw->(dbgoto(rec_pvh))
                                            pvpitemw->(dbgoto(rec_pvi))

                                            pvpitemw->ndoklad   := pvpheadw->ndoklad
                                            pvpitemw->ncislodl  := dodlsthd->ndoklad
                                            pvpitemw->ncislopvp := pvpheadw->ndoklad
                                            if((nrecpv := pvpitemw->_nrecpvi) = 0, nil, pvp_item->(dbgoto(nrecpv)))
                                            pvp_head->(dbgoto(pvpheadw ->_nrecor))

                                            key := if(nrecpv = 0, xbeK_INS, xbeK_ENTER)

                                            if((nrecpv := pvpitemw->_nrecor) = 0, nil, pvp_item->(dbgoto(nrecpv)))

                                            pvpItemW->nPVPHEAD := isNull( pvp_head->sID, 0)
                                            mh_copyfld('pvpitemw','pvp_item',(nrecpv=0), .f.)

                                            dodlstitw->ncislopvp := pvpheadw->ndoklad
                                            *
                                            if(pos := ascan(anPvi,pvpitemw ->_nrecor)) <> 0
                                              (adel(anPvi,pos),asize(anPvi,len(anPvi)-1))
                                            endif
                                          next

                                        endif
                                        *
                                        mh_copyfld('dodlstitw','dodlstit',(nrecor=0), .f.)
                                        dodlstit->ndoklad := dodlsthd->ndoklad

      endif

      dodlstitw->(dbskip())
    enddo

*    pvp_head->( dbcommit())
*    pvp_item->( dbcommit())

    *
    pvpheadw->(dbcommit(),dbgotop())
    pvpitemw->(dbcommit(),dbgotop())
    *

    if dodlsthdw->_delrec = '9'
       *
       * pokud je DL pøipojeno víc PVPHEAD - musíme ztušit likvidaci pro všecny hlavièky
       pvpheadw->(dbgotop())
       do while .not. pvpheadw->(eof())
         uctLikv  := UCT_likvidace():New(upper(pvpheadw->cUloha) +upper(pvpheadw->ctypdoklad),.t.)
         uctLikv:ucetpol_del()

         pvpheadw->(dbskip())
       enddo

       pvpheadw->(dbgotop(),dbeval({||pvp_head->(dbgoto(pvpheadw->_nrecor),dbdelete()) }))
       if(dodlsthdw->_nrecor <> 0, dodlsthd->(dbdelete()), nil)
    else
      dodlsthd->ncislopvp := lastPvp
      aeval(anPvh, {|x| pvp_head->(dbgoto(x),dbdelete()) })
      aeval(anPvi, {|x| pvp_item->(dbgoto(x),dbdelete()) })

    endif

    if( in_Pro, omoment:destroy(), nil )
  else
    drgMsg(drgNLS:msg('Nelze modifikovat DODACÍ LIST VYSTAVENÝ, blokováno uživatelem ...'),,odialog)
  endif

  dodlsthd->(dbunlock(), dbcommit())
   dodlstit->(dbunlock(), dbcommit())
    pvp_head->(dbunlock(), dbcommit())
     pvp_item->(dbunlock(), dbcommit())
      ucetpol ->(dbunlock(), dbcommit())
return mainOk


*
** zrušení dodacího listu **
function pro_dodlsthd_del(odialog)
  local  mainOk

  dodlsthdw->_delrec := '9'
  dodlstitw->(AdsSetOrder(0),dbgotop(),dbeval({|| dodlstitw->_delrec := '9'}))

  if .not. oSession_data:inTransaction()
    mainOk := PRO_dodlsthd_wrt_inTrans(odialog)
  else
    mainOk := pro_dodlsthd_wrt(odialog)
  endif
return mainOk


*
** pomocná funkce pro zrušení likvidace spojené s pvpitem
** cdenik + ndoklad,10 + nordItem,5
static function pro_dodlsthd_del_likv_pvpi( anLik )
  local  cky       := upper(pvp_item->cdenik) +strZero(pvp_item->ndoklad,10) +strZero(pvp_item->nordItem,5)
  local  anLik_del := {}

  ucetpol->( AdsSetOrder('UCETPOL1')                           , ;
             dbSetScope( SCOPE_BOTH, cky)                      , ;
             dbgotop()                                         , ;
             dbeval({ || aadd(anLik_del, ucetpol->(recno())) }), ;
             dbclearscope()                                      )

  aeval( anLik_del, {|x| if( x $ anLik, ucetpol->(dbgoto(x), dbRLock(), dbdelete()), nil ) })
return nil


*
** pomocná funkce pro zámky ucetpol
static function pro_dodlsthd_rlo(anPvh,anLik)
  local scope := upper(pvpheadw->cdenik) +strzero(pvpheadw->ndoklad,10)

  *
  if(select('ucetpol') = 0, drgDBMS:open('ucetpol'), nil)

  if(pvpheadw ->_nrecor <> 0, aadd(anPvh,pvpheadw ->_nrecor), nil)
  ucetpol->(AdsSetOrder('UCETPOL1')                       , ;
            dbsetscope(SCOPE_BOTH, scope)                 , ;
            dbgotop()                                     , ;
            dbeval({ || aadd(anLik, ucetpol->(recno())) }), ;
            dbclearscope()                                  )
return nil


*
**
static function pro_dodlsthd_ispvp()
  local lenBuff := 40960, buffer := space(lenBuff)
  local sname   := drgINI:dir_USERfitm +'mmacro', fields
  local ok      := .f.

  * napozicovat se na záznam typdokl *
  if(select('typdokl') = 0, drgDBMS:open('typdokl'), nil)

  b_pvphead := b_pvpitem := nil

  if typdokl->(dbseek(upper(dodlsthdw->culoha) +upper(dodlsthdw->ctypdoklad),,'TYPDOKL02'))

    * pokud je v typdokl mmacro tak ho zpøístupníme *
    if .not. empty(typdokl->mmacro)
      memowrit(sname,typdokl->mmacro)

      * naèteme ze sekce UsedIdentifiers Fields *
      GetPrivateProfileSectionA('pvpheadw', @buffer, lenBuff, sname)
      fields    := substr(buffer,1,len(trim(buffer))-1)
      fields    := strtran(fields,chr(0),',')
      b_pvphead := substr(fields,1,len(fields) -1)

      buffer    := space(lenBuff)

      GetPrivateProfileSectionA('pvpitemw', @buffer, lenBuff, sname)
      fields    := substr(buffer,1,len(trim(buffer))-1)
      fields    := strtran(fields,chr(0),',')
      b_pvpitem := substr(fields,1,len(fields) -1)

      ferase(sname)
      ok := (.not. empty(b_pvphead) .and. .not. empty(b_pvpitem))
    endif
  endif
return ok


static function pro_dodlsthd_pvp()
  local a_skl := {}, x
  local a_skl_dokl := {}, npos

  dodlstitw->(AdsSetOrder(2), dbgotop())

  do while .not. dodlstitw->(eof())
    dodlstitw->_polcen := ''
    *
    ** ceníková / evidenèní + sestava
    *
    if dodlstitw->cpolCen = 'C' .or. (dodlstitw->cpolCen = 'E' .and. dodlstitw->ctypsklPol = 'S ')
      *
      ** NEW
      if( npos := ascan( a_skl_dokl, {|pa| pa[1] = dodlstitw->ccissklad })) = 0
        aadd( a_skl_dokl, { dodlstitw->ccissklad, dodlstitw->ncisloPvp } )
      else
        if( dodlstitw->ncisloPvp <> 0, a_skl_dokl[npos,2] := dodlstitw->ncisloPvp, nil )
      endif

      dodlstitw->_polcen := 'C'
    endif
    dodlstitw->(dbskip())
  enddo

  pvpheadw->(dbgotop())
  pvpitemw->(dbgotop())
  dodlstitw->(AdsSetOrder('DODLSIT_4'))
  *
  ** NEW
  for x := 1 to len(a_skl_dokl) step 1
    dodlstitw->(dbsetscope( SCOPE_BOTH,'C' +upper(a_skl_dokl[x,1])),dbgotop())
    pro_dodlsthd_pvhd( a_skl_dokl[x,2] )
    dodlstitw->(dbeval({|| pro_dodlsthd_pvit() }))

    pvpheadw->(dbskip())
  next
return nil


static function pro_dodlsthd_pvhd(ndoklad)
  if   pvpheadw->(eof())  ; pvpheadw->(dbappend())
                            ndoklad := 0
*  else                    ; ndoklad := pvpheadw->ndoklad
  endif

  Eval( &("{||" + b_pvphead + "}"))
  pvpheadw ->ndoklad   := ndoklad
  pvpheadw->ncenadokl  := 0
  pvpheadw->ncenazakl  := 0
  pvpheadw ->ccissklad := dodlstitw->ccissklad
  dodlstitw->_nrecpvph := pvpheadw->(recno())

  pvpheadw->(dbCommit())
return nil


static function pro_dodlsthd_pvit()
  local  x, papolSest, pa, ordNum := dodlstitw->nintCount * 1000

  if( pvpitemw->(eof()), pvpitemw->(dbappend()), nil)

  objitem->(dbseek(upper(dodlstitw->ccislobint) +strzero(dodlstitw->ncislpolob,5),,'OBJITEM0'))
  cenzboz->(dbseek(upper(dodlstitw->ccissklad +dodlstitw->csklpol),,'CENIK3'))
  c_dph  ->(dbseek(dodlstitw->nprocdph,,'C_DPH2'))

  dodlstitw->ma_recs := ''

  if dodlstitw->ctypSklPol = 'S ' .and. .not. empty(dodlstitw->mapolSest)
    papolSest := listAsArray(dodlstitw->mapolSest, ';')

    for x := 1 to len(papolSest) step 1
      pa := listAsArray(papolSest[x])

      cenzboz->(dbseek( pa[1] +pa[2],,'CENIK03'))

      pro_dodlsthd_pvpitS(pa, ordNum +x)
      pro_dodlsthd_pvit_ky()
    next
  else
    Eval( &("{||" + b_pvpitem + "}"))
    pro_dodlsthd_pvit_ky()
  endif

  dodlstitw->ma_recs := subStr(dodlstitw->ma_recs, 1, len(dodlstitw->ma_recs) -1)
return nil


static function pro_dodlsthd_pvit_ky(isSest)
  local  ky, is_inPvpi

  if in_pro
    ky        := strZero(dodlsthdw->ndoklad,10) +strZero(pvpitemw->norditem,5)
    is_inPvpi := pvp_item->(dbseek(ky,,'PVPITEM24'))
  else
    ky        := strZero(pvpitemw->ncisfak,10) +strZero(pvpitemw->norditem,5) +upper(pvpitemw->cSubTask)
    is_inPvpi := pvp_item->(dbseek(ky,,'PVPITEM18'))
  endif
  *
  ** musíme poktýt i variantu, že zrušil a pak pøidal stejnou položku
  if ( is_inPvpi .and. dodlstitw->_nrecor <> 0 )
    pvpitemw->_nrecor    := pvp_item->(recNo())
    pvpitemw->_nrecpvi   := pvp_item->(recNo())
    pvpitemw->nmnozPR_or := pvp_item->nmnozPRdod
    pvpitemw->nmnozRE_or := pvp_item->nmnozREodb
    pvpitemw->nmnozZO_or := pvp_item->nmnozZOBJE
    pvpitemw->ncenaCE_or := pvp_item->ncenaCELK
  else
    pvpitemw->_nrecor    := 0
    pvpitemw->_nrecpvi   := 0
    pvpitemw->nmnozPR_or := 0
    pvpitemw->nmnozRE_or := 0
    pvpitemw->nmnozZO_or := 0
    pvpitemw->ncenaCE_or := 0
  endif

  pvpheadw->(dblocate({|| pvpheadw->ccissklad = pvpitemw->ccissklad }))

  if empty(pvpitemw->_delrec)
    pvpheadw->ncenadokl  += pvpitemw->ncenacelk
    pvpheadw->ncenazakl  += pvpitemw->ncenazakl
  endif
  *
  dodlstitw->ncislopvp := pvpitemw->ndoklad
  dodlstitw->_nrecpvph := pvpheadw->(recno())
  dodlstitw->_nrecpvpi := pvpitemw->(recno())

  dodlstitw->ma_recs   += str(pvpheadw->(recno())) +',' +str(pvpitemw->(recno())) + ';'
  pvpitemw->(dbCommit(),dbskip())
return nil


*
** položky sestavy pro výdejku
/*
   pvpitem                                                           kusov
                       ncenanapDod  ncenazakl
   cenzboz                                                           kusov
   ccisSklad, csklPol, ncenaSZbo  , ncenapzbo, nmnozszbo, ncenaczbo, nspMno
*/
static function pro_dodlsthd_pvpitS(pa, ordNum)
  if( pvpitemw->(eof()), pvpitemw->(dbappend()), nil)

  Eval( &("{||" + b_pvpitem + "}"))

  pvpitemw->ndoklad      := pvpheadw ->ndoklad
  pvpitemw->ccissklad    := cenzboz  ->ccisSklad
  pvpitemw->csklpol      := cenzboz  ->csklPol
  pvpitemw->cpolcen      := cenzboz  ->cpolCen
  pvpitemw->norditem     := ordNum
  pvpitemw->nucetskup    := cenzboz  ->nucetSkup
  pvpitemw->cucetskup    := alltrim(str(cenzboz->nucetSkup))
  pvpitemw->ddatpvp      := pvpheadw ->ddatpvp
  pvpitemw->ccaspvp      := time()
  pvpitemw->cobdpoh      := pvpheadw ->cobdpoh
  pvpitemw->cobdobi      := pvpheadw ->cobdobi
  pvpitemw->nrok         := pvpheadw ->nrok
  pvpitemw->nobdobi      := pvpheadw ->nobdobi
  pvpitemw->ntyppoh      := -1
  pvpitemw->ncislpoh     := pvpheadw ->ncislpoh
  pvpitemw->cnazzbo      := cenzboz  ->cnazZbo
  pvpitemw->nzbozikat    := cenzboz  ->nzboziKat
  *
  pvpitemw->ncennapdod   := val(pa[3])
  pvpitemw->nmnozprdod   := dodlstitw->nfaktMnoz * val(pa[7])
  *
  pvpitemw->ncenacelk    := pvpitemw ->ncennapdod *pvpitemw ->nmnozprdod
  *
  pvpitemw->ncenapzbo    := val(pa[4])
  *
  pvpitemw->ncenapdzbo   := pvpitemw ->ncenapzbo +(pvpitemw ->ncenapzbo *c_DPH->nprocdph/100)
  pvpitemw->nklicdph     := cenzboz  ->nklicDph
  pvpitemw->czkratjedn   := cenzboz  ->czkratJedn
  pvpitemw->czkratmeny   := dodlsthdw->czkratmeny
  *
  pvpitemw->nmnozszbo    := val(pa[5])
  pvpitemw->ncenaczbo    := val(pa[6])
  *
  pvpitemw->nintcount    := dodlstitw->nintcount
  pvpitemw->ccislobint   := objitem  ->ccislobint
  pvpitemw->ncislpolob   := objitem  ->ncislpolob
  pvpitemw->nmnozpoodb   := objitem  ->nmnozpoodb
  pvpitemw->nmnozreodb   := objitem  ->nmnozreodb
  pvpitemw->nmnozvyobj   := objitem  ->nmnozvpint
  pvpitemw->nmnozkobje   := objitem  ->nmnozkodod
  pvpitemw->ncislopvp    := pvpheadw ->ndoklad
  pvpitemw->ncisfak      := dodlstitw->ncisfak
  pvpitemw->cnazpol1     := dodlstitw->cnazpol1
  pvpitemw->cnazpol2     := dodlstitw->cnazpol2
  pvpitemw->cnazpol3     := dodlstitw->cnazpol3
  pvpitemw->cnazpol4     := dodlstitw->cnazpol4
  pvpitemw->cnazpol5     := dodlstitw->cnazpol5
  pvpitemw->cnazpol6     := dodlstitw->cnazpol6
  pvpitemw->ntypslevy    := 0
  pvpitemw->nprocslev    := 0
  pvpitemw->nprocslfao   := 0
  pvpitemw->nprocslmn    := 0
  pvpitemw->nhodnslev    := 0
  pvpitemw->ncelkslev    := 0
  *
  pvpitemw->ncenazakl    := val(pa[4])
  *
  pvpitemw->culoha       := pvpheadw ->culoha
  pvpitemw->czkrprodej   := dodlsthdw->czkrprodej
  pvpitemw->cdenik       := pvpheadw  ->cdenik
  pvpitemw->cciszakaz    := dodlstitw->cciszakaz
  pvpitemw->cvyrpol      := ''
  pvpitemw->nvarcis      := 0
  pvpitemw->nklicobl     := dodlsthdw->nklicobl
  pvpitemw->czahrmena    := dodlsthdw->czkratmenz
  pvpitemw->ctypskp      := cenzboz  ->ctypskp
  pvpitemw->nkoefmn      := cenzboz  ->nkoefmn
  pvpitemw->nmnozprkoe   := pvpitemw ->nkoefmn * pvpitemw->nmnozprdod
  pvpitemw->ncejprzbz    := pvpitemw ->ncenaZakl
  pvpitemw->ncejprkbz    := pvpitemw ->ncejprzbz
  pvpitemw->ncejprkdz    := (pvpitemw->ncejprkbz + (pvpitemw->ncejprkbz * c_dph->nprocdph/100))
  pvpitemw->ncecprzbz    := (pvpitemw->ncejprkbz * pvpitemw->nmnozprdod)
  pvpitemw->ncecprkbz    := (pvpitemw->ncejprkbz * pvpitemw->nmnozprdod)
  pvpitemw->ncecprkdz    := (pvpitemw->ncejprkdz * pvpitemw->nmnozprdod)
  pvpitemw->nhmotnost    := cenzboz  ->nhmotnost * pvpitemw->nmnozprkoe
  pvpitemw->nobjem       := cenzboz  ->nobjem    * pvpitemw->nmnozprkoe
  pvpitemw->cobdobi      := dodlsthdw->cobdobi
return nil