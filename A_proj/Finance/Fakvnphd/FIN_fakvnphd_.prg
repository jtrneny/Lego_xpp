#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "..\FINANCE\FIN_finance.ch"


FUNCTION FIN_fakvnphd_cpy(oDialog)
  LOCAL  nKy := FAKvnpHD ->nCISFAK, doklad
  *
  LOCAL  lNEWrec := If( IsNull(oDialog), .F., oDialog:lNEWrec)
  local  inScope
  local  lok_append2 := .f.

  ** tmp soubory **
  drgDBMS:open('FAKVNPHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('FAKVNPITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  If .not. lNEWrec
    mh_COPYFLD('FAKVNPHD','FAKVNPHDw',.t., .t.)

    FAKVNPIT ->(DbGoTop())
    Do while .not. FAKVNPIT ->(Eof())
      mh_COPYFLD('FAKVNPIT','FAKVNPITw',.t., .t.)

      FAKVNPITw ->cOBDOBI    := FAKVNPHDw ->cOBDOBI
      FAKVNPITw ->nROK       := FAKVNPHDw ->nROK
      FAKVNPITw ->nOBDOBI    := FAKVNPHDw ->nOBDOBI
      FAKVNPITw ->nDOKLADORG := FAKVNPIT ->( RecNo())
      FAKVNPITw ->nFAKTM_ORG := FAKVNPIT ->nFAKTMNOZ

      FAKVNPIT ->(DbSkip())
    EndDo
  ELSE
    FAKVNPHDw ->( DbAppend())
    doklad := FIN_RANGE_KEY('FAKVNPHD')[2]

    if isobject(oDialog)                          .and. ;
       oDialog:drgDialog:cargo = drgEVENT_APPEND2 .and. ;
       .not. fakvnphd->(eof())

       oDialog:lok_append2 := lok_append2 := .t.
       mh_copyFld( 'fakvnphd', 'fakvnphdW', .f., .f. )

       ( fakvnphdW->ncisFak    := doklad                      , ;
         fakvnphdW->ndoklad    := doklad                      , ;
         fakvnphdW->cvarSym    := allTrim(str(doklad))        , ;
         fakvnphdW->cobdobi    := uctOBDOBI:FIN:COBDOBI       , ;
         fakvnphdW->nrok       := uctOBDOBI:FIN:NROK          , ;
         fakvnphdW->nobdobi    := uctOBDOBI:FIN:NOBDOBI       , ;
         fakvnphdW->dvystFak   := date()                      , ;
         fakvnphdW->ddatTisk   := ctod('  .  .  ')            , ;
         fakvnphdW->cjmenoVys  := logOsoba                      )

       if .not. (inScope := fakvnpit->(dbscope()))
         fordRec( { 'fakvnpit' } )
         fakvnpit->( ordSetFocus('FVYSIT1'),dbsetscope(SCOPE_BOTH, strZero(fakvnphdW->ncisFak,10)) )
       endif

       fakvnpit->( dbgoTop())
       do while .not. fakVnpit->( eof())
         mh_COPYFLD('fakvnpit','fakvnpitW',.t., .f.)
         *
         fakVnpitW->ncisFak   := fakvnphdW->ncisFak
         fakVnpitW->cobdobi   := fakVnphdw->cobdobi
         fakVnpitw->nrok      := fakVnphdw->nrok
         fakVnpitw->nobdobi   := fakVnphdw->nobdobi

         fakvnpit->(DbSkip())
       enddo
       fakvnpit->(dbgotop())

       if .not. inSCope
         fakvnpit->(dbclearscope())
         fordRec()
       endif

       * po uložení bude další doklad v INS, ne kopie
       oDialog:drgDialog:cargo := drgEVENT_APPEND

    else
      ( FAKVNPHDw ->cULOHA     := "F"                             , ;
        fakvnphdW ->ncisFak    := doklad                          , ;
        fakVnphdW ->ndoklad    := doklad                          , ;
        FAKVNPHDw ->cVARSYM    := AllTrim(Str(doklad))            , ;
        FAKVNPHDw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI           , ;
        FAKVNPHDw ->nROK       := uctOBDOBI:FIN:NROK              , ;
        FAKVNPHDw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI           , ;
        FAKVNPHDw ->cZKRATMENY := SysConfig( 'Finance:cZaklMENA' ), ;
        FAKVNPHDw ->dVYSTFAK   := Date()                          , ;
        FAKVNPHDw ->cDENIK     := SysConfig( 'Finance:cDENIKvnpF'), ;
        FAKVNPHDw ->cJMENOVYS  := logOsoba                          )
    endif
  ENDIF
RETURN NIL


*
** uložení vnitro_Podnikové faktury ********************************************
function FIN_fakVnphd_wrt_inTrans(oDialog)
  local  lDone := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := fin_fakVnphd_wrt(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE

  _clearEventLoop(.t.)
return lDone


static function FIN_fakvnphd_wrt(odialog)
  local  anFai := {}, anDoi := {}, anVYR := {}, anVYRit := {}
  local  uctLikv, mainOk := .t., nrecOr, lnewRec := odialog:lnewRec, vykhphOk
  local  omoment

  fakvnpitW->(AdsSetOrder(0), ;
              dbgotop()     , ;
              dbeval({|| fin_fakvnphd_rlo( anFai, anDoi, anVYR, anVYRit ) }))

  uctLikv := UCT_likvidace():new(upper(fakvnphdW->culoha) +upper(fakvnphdW->ctypdoklad),.T.)

  if .not. lnewRec
    fakvnphd->(dbgoto(fakvnphdW->_nrecor))
    mainOk := ( fakvnphd->(sx_rlock())        .and.         ;
                fakvnpit->(sx_rlock(anFai  )) .and.         ;
                dodlstit->(sx_rlock(anDoi  )) .and.         ;
                vyrZak  ->(sx_rlock(anVYR  )) .and.         ;
                vyrzakit->(sx_rlock(anVYRit)) .and.         ;
                ucetpol ->(sx_rlock(uctLikv:ucetpol_rlo)) )
  else
    mainOk := ( dodlstit->(sx_rlock(anDoi  )) .and.         ;
                vyrZak  ->(sx_rlock(anVYR  )) .and.         ;
                vyrzakit->(sx_rlock(anVYRit))               )
  endif


  if mainOk
    omoment := SYS_MOMENT( '=== UKLÁDÁM DOKLAD ===')

    if fakVnphdW->_delrec <> '9'
      if odialog:lnewrec
        fakVnphdW->ndoklad := fakVnphdW->ncisfak
      endif

      mh_copyFld( 'fakVnphdW', 'fakVnphd', lnewRec, .f. )
      fakPrihd->(dbcommit())
    endif

    fakVnpitW->( AdsSetOrder(0), dbgoTop() )

    do while .not. fakVnpitW->( eof())
      if((nrecOr := fakVnpitW->_nrecor) = 0, nil, fakVnpit->(dbgoto(nrecor)))

      if   fakVnpItW->_delrec = '9' .or. fakVnphdW->_delrec = '9'
        if(nrecor = 0, nil, fakVnpit->(dbdelete()))
      else
        *
        * editujeme ccisZakazI -ale- musíme naplnit i ccisZakaz
        fakVnpitW->ccisZakaz  := fakVnpitW->ccisZakazI

        * pozor otevøela se editace úèetního na HD
        fakVnpitW->nrok       := fakVnphd->nrok
        fakVnpitW->nobdobi    := fakVnphd->nobdobi
        fakVnpitW->cobdobi    := fakVnphd->cobdobi
        fakVnpitW->ncisFak    := fakVnphd->ncisFak

        mh_copyfld('fakVnpitW','fakVnpit',(nrecOr=0), .f.)
      endif

      if fakVnpitW->_delrec = '9' .and. nrecOr = 0
        * nic nedìláme, jen zkoušel pøidat položku s vazbou a zrušil ji
      else
        if( .not. empty(fakVnpitW->ncislodl), fin_fakVnphd_dol(), ;
          if( .not. empty(fakVnpitW->cciszakazi), fin_fakVnphd_vyr(), nil ) )
      endif

      fakVnpitW->( dbskip())
    enddo

    if(fakVnphdW->_delrec = '9')  ;  uctLikv:ucetpol_del()
                                     fakVnphd->(dbdelete())
    else                          ;  uctLikv:ucetpol_wrt()
    endif


    omoment:destroy()
  else
    drgMsg(drgNLS:msg('Nelze modifikovat FAKTURU VYSTAVENOU, blokováno uživatelem ...'),,odialog)
  endif

  fakvnphd->(dbunlock(), dbcommit())
   fakvnpit->(dbunlock(), dbcommit())
    dodlstit->(dbunlock(), dbcommit())
     vyrzak  ->(dbunlock(), dbcommit())
      vyrzakit->(dbunlock(), dbcommit())
       ucetpol ->(dbunlock(), dbcommit())
return mainOk


static function fin_fakvnphd_rlo( anFai, anDoi, anVYR, anVYRit )
  local  ncislodl   := fakvnpitW->ncislodl , ncountdl := fakvnpitW->ncountdl
  local  ccisZakaz  := left(fakvnpitw->ccisZakazi,30), ncisPOLzak := fakvnpitw->ncisPOLzak

  aadd(anFai,fakvnpitw->_nrecor)

  if .not. empty(ncislodl)
    if(dodlstit->(dbseek(strzero(ncislodl,10) +strzero(ncountdl,5),,'DODLIT5')), ;
      (fakvnpitW->nrecdol := dodlstit->(recno()), aadd(anDoi, dodlstit->(recno()))), nil)

  elseif .not. empty(ccisZakaz)
    if vyrZakit->( dbseek(upper(ccisZakaz) +strZero(ncisPOLzak,5),,'ZAKIT_1'))
      if vyrzak->( dbseek( upper(ccisZakaz),,'VYRZAK1'))
        aadd( anVYR  , vyrZak  ->( recNo()) )
        aadd( anVYRit, vyrZakit->( recNo()) )

        fakvnpitW->nrec_VYR   := vyrZak  ->( recNo())
        fakvnpitW->nrec_VYRit := vyrZakit->( recNo())
      endif
    endif
  endif
return nil


static function fin_fakVnphd_dol()
  dodlstit->(dbgoto(fakvnpitW->nrecdol))

  if fakvnpitW->_delrec = '9'
    dodlstit->ncisvysfak := 0
    dodlstit->nmnoz_fakt -= fakvnpitW->nfaktm_org
    dodlstit->nmnoz_fakv -= fakvnpitW->nfaktm_org
  else
    dodlstit->ncisvysfak := fakvnpitW->ncisfak
    dodlstit->nmnoz_fakt += (fakvnpitW->nfaktmnoz -fakvnpitW->nfaktm_org)
    dodlstit->nmnoz_fakv += (fakvnpitW->nfaktmnoz -fakvnpitW->nfaktm_org)
  endif

  dodlstit->nstav_fakt := if(dodlstit->nmnoz_fakt = 0                  , 0, ;
                          if(dodlstit->nmnoz_fakt = dodlstit->nfaktMnoz, 2, 1))
  dodlstit->nstav_fakv := dodlstit->nstav_fakt
return .t.


static function fin_fakVnphd_vyr()
  vyrZak  ->( dbgoTo( fakvnpitW->nrec_VYR   ))
  vyrZakit->( dbgoTo( fakvnpitW->nrec_VYRit ))

  if fakVnpitW->_delrec = '9'
    vyrZak  ->nmnozfakt  -= fakvnpitw->nfaktm_org
*    vyrZak  ->nmnoz_fakt -= fakvnpitw->nfaktm_org
    vyrZak  ->nmnoz_fakv -= fakvnpitw->nfaktm_org
    if(vyrZak->nmnozfakt = 0, vyrzak->ncisfak := 0, nil)

    vyrZakit->nmnozfakt  -= fakvnpitw->nfaktm_org
*    vyrZakit->nmnoz_fakt -= fakvnpitw->nfaktm_org
    vyrZakit->nmnoz_fakv -= fakvnpitw->nfaktm_org
    if(vyrZakit->nmnozfakt = 0, vyrZakit->ncisfak := 0, nil)
  else
    vyrZak  ->ncisfak    := fakvnpitw->ncisfak
    vyrZak  ->nmnozfakt  += (fakvnpitw->nfaktmnoz -fakvnpitw->nfaktm_org)
*    vyrZak  ->nmnoz_fakt += (fakvnpitw->nfaktmnoz -fakvnpitw->nfaktm_org)
    vyrZak  ->nmnoz_fakv += (fakvnpitw->nfaktmnoz -fakvnpitw->nfaktm_org)

    vyrZakit->ncisfak    := fakvnpitw->ncisfak
    vyrZakit->nmnozfakt  += (fakvnpitw->nfaktmnoz -fakvnpitw->nfaktm_org)
*    vyrZakit->nmnoz_fakt += (fakvnpitw->nfaktmnoz -fakvnpitw->nfaktm_org)
    vyrZakit->nmnoz_fakv += (fakvnpitw->nfaktmnoz -fakvnpitw->nfaktm_org)
  endif

  vyrZak  ->nstav_fakv := if(vyrZak  ->nmnoz_fakV = 0                  , 0,   ;
                          if(vyrZak  ->nmnoz_fakV = vyrZak ->nmnozFakt , 2, 1))

  vyrzakit->nstav_fakV := if(vyrzakit->nmnoz_fakV = 0                  , 0, ;
                          if(vyrzakit->nmnoz_fakV = vyrzakit->nmnozfakt, 2, 1))
return .t.


*
** zrušení vnitro_Podnikové faktury
function FIN_fakVnphd_del(odialog)
  local  mainOk := .t.

  fakVnphdW->_delrec := '9'
  fakVnpitW->(fakVnpitW->(AdsSetOrder(0),dbgotop()), dbeval({|| fakVnpitW->_delrec := '9'}))

  fakVnphdW->(dbcommit())
  fakVnpitW->(dbcommit())

  mainOk := FIN_fakVnphd_wrt_inTrans(oDialog)
return mainOk