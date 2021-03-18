#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dbstruct.ch"
*
#include "..\Asystem++\Asystem++.ch"


static b_pvphead, b_pvpitem, in_nak


function NAK_dodlstPhd_cpy(oDialog)
  local  nKy := dodlstPhd->ncisfak, inScope, x, apvp := {}
  *
  local  lNEWrec := If( IsNull(oDialog), .F., oDialog:lNEWrec)

  ** tmp **
  drgDBMS:open('dodlstPhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('dodlstPitw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('pvpheadw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('pvpitemw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  if .not. lNEWrec
    mh_copyfld('dodlstPhd', 'dodlstPhdw', .t., .t.)
    dodlstPhdw->cobdobio := dodlstPhd->cobdobi

    dodlstPit->(dbgotop(), dbeval({|| mh_copyfld('dodlstPit','dodlstPitw',.t., .t.)}))
    *
    pvp_head->(AdsSetOrder('PVPHEAD10'), dbSetScope(SCOPE_BOTH,dodlstPhd->ndoklad), dbgotop(), ;
               dbeval( {|| mh_copyfld('pvp_head','pvpheadw',.t., .t.) })                       )

    pvp_item->(AdsSetOrder('PVPITEM17'), dbSetScope(SCOPE_BOTH,dodlstPhd->ndoklad), dbgotop(), ;
               dbeval( {||mh_copyfld('pvp_item','pvpitemw', .t., .t.) })                       )

  else
    dodlstPhdw->(dbappend())
    if( .not. c_bankuc->(dbseek(.t.,,'bankuc2')), c_bankuc->(dbgotop()),nil)

    ( dodlstPhdw ->cULOHA     := "N"                                     , ;
      dodlstPhdw ->cOBDOBI    := uctOBDOBI:SKL:COBDOBI                   , ;
      dodlstPhdw ->nROK       := uctOBDOBI:SKL:NROK                      , ;
      dodlstPhdw ->nOBDOBI    := uctOBDOBI:SKL:NOBDOBI                   , ;
      dodlstPhdw ->cOBDOBIDAN := uctOBDOBI:SKL:COBDOBIDAN                , ;
      dodlstPhdw ->nKODZAOKRD := SYSCONFIG('FINANCE:nROUNDDPH')          , ;
      dodlstPhdw ->cZKRATMENY := SYSCONFIG('FINANCE:cZAKLMENA')          , ;
      dodlstPhdw ->dSPLATFAK  := DATE() +SYSCONFIG( 'FINANCE:nSPLATNOST'), ;
      dodlstPhdw ->dVYSTFAK   := DATE()                                  , ;
      dodlstPhdw ->dPOVINFAK  := DATE()                                  , ;
      dodlstPhdw ->cBANK_UCT  := C_BANKUC ->cBANK_UCT                    , ;
      dodlstPhdw ->cDENIK     := SYSCONFIG('FINANCE:cDENIKFAPR')         , ;
      dodlstPhdw ->nKURZAHMEN := 1                                       , ;
      dodlstPhdw ->nMNOZPREP  := 1                                       , ;
      dodlstPhdw ->cJMENOVYS  := usrName                                 , ;
      dodlstPhdw ->ndoklad    := fin_range_key('DODLSTPHD')[2]           , ;
      dodlstPhdw ->ncislodl   := dodlstPhdw->ndoklad                     , ;
      dodlstPhdw ->cZKRATMENZ := SYSCONFIG('FINANCE:cZAKLMENA')          , ;
      dodlstPhdw ->cVYPSAZDAN := SYSCONFIG('FINANCE:cVYPSAZDPH')           )
  endif
return nil


function NAK_dodlstPhd_wrt(odialog)
  local  anDoi := {}, anPvh := {}, anPvi := {}, anLik := {}, aPvh := {}
  local                                         anLik_del
  local  uctLikv, mainOk := .t., nrecor, nrecpv, lastPvp := 0, newPvp := 0, pos, key
  local  ispvp := nak_dodlsthd_ispvp()
  *
  local  pa_recs, pa, rec_pvh, rec_pvi, x
  local  cf := "ccisSklad = '%%'", cfilter

  * rozboèka pro FIN - NAK
  in_nak  := (lower(odialog:drgDialog:formName) = 'nak_dodlstphd_in')
  pa_sest := {}
  *
  dodlstitw->(AdsSetOrder(0), dbgotop(), ;
              dbeval({|| if(dodlstitw->_nrecor <> 0, aadd(anDoi,dodlstitw->_nrecor), nil) }))

  pvpheadw ->(AdsSetOrder(0), dbgotop(), ;
              dbeval({|| nak_dodlsthd_rlo(anPvh,anLik) }))

  pvpitemw ->(AdsSetOrder(0), dbgotop(), ;
              dbeval({|| if(pvpitemw ->_nrecor <> 0, aadd(anPvi,pvpitemw ->_nrecor), nil) }))

  *
  if( ispvp, nak_dodlstPhd_pvp(), nil)
**  if(dodlsthdw->_delrec <> '9' .and. ispvp, pro_dodlsthd_pvp(), nil)

  if .not. odialog:lnewrec
    dodlstPhd->(dbgoto(dodlsthdw->_nrecor))
    mainOk := dodlstPhd->(sx_rlock())      .and. ;
              dodlstPit->(sx_rlock(anDoi)) .and. ;
              pvp_head ->(sx_rlock(anPvh)) .and. ;
              pvp_item ->(sx_rlock(anPvi)) .and. ;
              ucetpol  ->(sx_rlock(anLik))
  endif

  dbcommitall()

  dodlstPitw->(AdsSetOrder(0), dbgotop())

  if mainOk
    uctLikv := ''

    if(dodlstPhdw->_delrec <> '9', mh_copyfld('dodlstPhdw','dodlstPhd',odialog:lnewRec, .f.), nil)

    dodlstPitw->(dbgotop())
    do while .not. dodlstiPtw->(eof())

      if dodlstPitw->_nrecpvph <> 0 .and. dodlstPitw->_delrec <> '9'
        if ascan(aPvh,dodlstPitw->_nrecpvph) = 0
          pvpheadw->(dbgoto(dodlstPitw->_nrecpvph))
          if(nrecpv := pvpheadw->_nrecor) = 0
            newPvp := fin_range_key('PVPHEAD',,,,.t.)[2]
            if(newPvp = lastPvp, newPvp++, nil )

            pvpheadw->ndoklad   := newPvp
            pvpheadw->ncislodl  := dodlstPhd->ndoklad
            pvpheadw->ncislopvp := pvpheadw ->ndoklad
          else
            pvp_head->(dbgoto(nrecpv))
          endif

          * výdejky jsou generované pro pøíslušný sklad
          cfilter := format( cf, { pvpheadw->ccisSklad } )
          pvpitemw->(Ads_setAOF( cfilter ), dbgoTop() )
            uctLikv  := UCT_likvidace():New(upper(pvpheadw->cUloha) +upper(pvpheadw->ctypdoklad),.t.)
            uctLikv:ucetpol_wrt()
          pvpitemw->(Ads_ClearAOF())

          mh_copyfld('pvpheadw','pvp_head',(nrecpv=0), .f.)

          aadd(aPvh,dodlstPitw->_nrecpvph)

          if(pos := ascan(anPvh,pvpheadw ->_nrecor)) <> 0
            (adel(anPvh,pos),asize(anPvh,len(anPvh)-1))
          endif

          lastPvp := pvpheadW->ndoklad
        endif
      endif

      pvpheadw->(dbCommit())
      pvpitemw->(dbCommit())

      if((nrecor := dodlstPitw->_nrecor) = 0, nil, dodlstPit->(dbgoto(nrecor)))

      pa_recs := listAsArray(dodlstPitw->ma_recs, ';')

      if   dodlstPitw->_delrec = '9'  ; if(nrecpv := dodlstPitw->_nrecpvpi) <> 0

                                          for x := 1 to len(pa_recs) step 1
                                            pa      := listAsArray(pa_recs[x])
                                            rec_pvh := val(pa[1])
                                            rec_pvi := val(pa[2])

                                            pvpitemw->(dbgoto(rec_pvi))

                                            ** šílená oprava **
                                            pvp_item->(dbgoto(pvpitemw->_nrecor))
**                                            pvp_item->(dbgoto(pvpitemw->_nrecpvi))

                                            pvpheadw->(dbgoto(rec_pvh))
                                            pvp_head->(dbgoto(pvpheadw ->_nrecor))

                                            *
                                            ** potøebujeme zrušit likvidaci
                                            nak_dodlstPhd_del_likv_pvpi( anLik )

                                            pvp_item->(dbdelete())

                                            if(pos := ascan(anPvi,pvpitemw->_nrecor)) <> 0
                                              aRemove(anPvi, pos)
                                            endif
                                          next
                                        endif
                                        dodlstPit->(dbdelete())

      else                           ;  if dodlstPitw->_nrecpvpi <> 0

                                          for x := 1 to len(pa_recs) step 1
                                            pa      := listAsArray(pa_recs[x])
                                            rec_pvh := val(pa[1])
                                            rec_pvi := val(pa[2])

                                            pvpheadw->(dbgoto(rec_pvh))
                                            pvpitemw->(dbgoto(rec_pvi))

                                            pvpitemw->ndoklad   := pvpheadw ->ndoklad
                                            pvpitemw->ncislodl  := dodlstPhd->ndoklad
                                            pvpitemw->ncislopvp := pvpheadw ->ndoklad
                                            if((nrecpv := pvpitemw->_nrecpvi) = 0, nil, pvp_item->(dbgoto(nrecpv)))
                                            pvp_head->(dbgoto(pvpheadw ->_nrecor))

                                            key := if(nrecpv = 0, xbeK_INS, xbeK_ENTER)

                                            if((nrecpv := pvpitemw->_nrecor) = 0, nil, pvp_item->(dbgoto(nrecpv)))
                                            mh_copyfld('pvpitemw','pvp_item',(nrecpv=0), .f.)

                                            dodlstPitw->ncislopvp := pvpheadw->ndoklad
                                            *
                                            if(pos := ascan(anPvi,pvpitemw ->_nrecor)) <> 0
                                              (adel(anPvi,pos),asize(anPvi,len(anPvi)-1))
                                            endif
                                          next

                                        endif
                                        *
                                        mh_copyfld('dodlstPitw','dodlstPit',(nrecor=0), .f.)
                                        dodlstPit->ndoklad := dodlstPhd->ndoklad

      endif

      dodlstPitw->(dbskip())
    enddo

*    pvp_head->( dbcommit())
*    pvp_item->( dbcommit())

    *
    pvpheadw->(dbcommit(),dbgotop())
    pvpitemw->(dbcommit(),dbgotop())
    *

    if dodlstPhdw->_delrec = '9'
       *
       * pokud je DL pøipojeno víc PVPHEAD - musíme ztušit likvidaci pro všecny hlavièky
       pvpheaPdw->(dbgotop())
       do while .not. pvpheadw->(eof())
         uctLikv  := UCT_likvidace():New(upper(pvpheadw->cUloha) +upper(pvpheadw->ctypdoklad),.t.)
         uctLikv:ucetpol_del()

         pvpheadw->(dbskip())
       enddo

       pvpheadw->(dbgotop(),dbeval({||pvp_head->(dbgoto(pvpheadw->_nrecor),dbdelete()) }))
       if(dodlstPhdw->_nrecor <> 0, dodlstPhd->(dbdelete()), nil)
    else
      dodlstPhd->ncislopvp := lastPvp
      aeval(anPvh, {|x| pvp_head->(dbgoto(x),dbdelete()) })
      aeval(anPvi, {|x| pvp_item->(dbgoto(x),dbdelete()) })

    endif
  else
    drgMsg(drgNLS:msg('Nelze modifikovat DODACÍ LIST PØIJATÝ, blokováno uživatelem ...'),,odialog)
  endif

  dodlstPhd->(dbunlock(), dbcommit())
   dodlstPit->(dbunlock(), dbcommit())
    pvp_head->(dbunlock(), dbcommit())
     pvp_item->(dbunlock(), dbcommit())
      ucetpol ->(dbunlock(), dbcommit())
return mainOk


*
** zrušení dodacího listu **
function NAK_dodlstPhd_del(odialog)
  local  mainOk

  dodlstPhdw->_delrec := '9'
  dodlstPitw->(AdsSetOrder(0),dbgotop(),dbeval({|| dodlstPitw->_delrec := '9'}))
  mainOk := NAK_dodlstPhd_wrt(odialog)
return mainOk


*
** pomocná funkce pro zrušení likvidace spojené s pvpitem
** cdenik + ndoklad,10 + nordItem,5
static function nak_dodlstPhd_del_likv_pvpi( anLik )
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
static function nak_dodlsthd_rlo(anPvh,anLik)
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
static function nak_dodlsthd_ispvp()
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

      GetPrivateProfileSectionA('pvpitemw', @buffer, lenBuff, sname)
      fields    := substr(buffer,1,len(trim(buffer))-1)
      fields    := strtran(fields,chr(0),',')
      b_pvpitem := substr(fields,1,len(fields) -1)

      ferase(sname)
      ok := (.not. empty(b_pvphead) .and. .not. empty(b_pvpitem))
    endif
  endif
return ok


static function nak_dodlstPhd_pvp()
  local a_skl := {}, x

  dodlstitw->(AdsSetOrder(2), dbgotop())

  do while .not. dodlstitw->(eof())
    dodlstitw->_polcen := ''
    *
    ** ceníková / evidenèní + sestava
    *
    if dodlstitw->cpolCen = 'C' .or. (dodlstitw->cpolCen = 'E' .and. dodlstitw->ctypsklPol = 'S ')
      if(ascan(a_skl, dodlstitw->ccissklad) = 0, aadd(a_skl, dodlstitw->ccissklad), nil)

      dodlstitw->_polcen := 'C'
    endif
    dodlstitw->(dbskip())
  enddo

  pvpheadw->(dbgotop())
  pvpitemw->(dbgotop())
  dodlstitw->(AdsSetOrder('DODLSIT_4'))

  for x := 1 to len(a_skl) step 1
    dodlstitw->(dbsetscope(SCOPE_BOTH,'C' +a_skl[x]),dbgotop())
    nak_dodlsthd_pvhd()
    dodlstitw->(dbeval({|| nak_dodlsthd_pvit() }))

    pvpheadw->(dbskip())
  next
return nil


static function nak_dodlsthd_pvhd(ndoklad)
  if   pvpheadw->(eof())  ; pvpheadw->(dbappend())
                            ndoklad := 0
  else                    ; ndoklad := pvpheadw->ndoklad
  endif

  Eval( &("{||" + b_pvphead + "}"))
  pvpheadw ->ndoklad   := ndoklad
  pvpheadw->ncenadokl  := 0
  pvpheadw->ncenazakl  := 0
  pvpheadw ->ccissklad := dodlstitw->ccissklad
  dodlstitw->_nrecpvph := pvpheadw->(recno())

  pvpheadw->(dbCommit())
return nil


static function nak_dodlsthd_pvit()
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
      nak_dodlsthd_pvpitS(pa, ordNum +x)

      nak_dodlsthd_pvit_ky()
    next
  else
    Eval( &("{||" + b_pvpitem + "}"))
    nak_dodlsthd_pvit_ky()
  endif

  dodlstitw->ma_recs := subStr(dodlstitw->ma_recs, 1, len(dodlstitw->ma_recs) -1)
return nil


static function nak_dodlsthd_pvit_ky(isSest)
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
static function nak_dodlsthd_pvpitS(pa, ordNum)
  if( pvpitemw->(eof()), pvpitemw->(dbappend()), nil)

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