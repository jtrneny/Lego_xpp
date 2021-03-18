#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "dbstruct.ch"


Static  anHD
Static  nFINtyp, nROUNDdph, nKOE, nKODzaokr, nPROCdan_1, nPROCdan_2, nPROCdan_3, ;
        nSAZdanf_1, nSAZdanf_2, nSAZdanf_3, ;
        nCENzahCEL, nZAOKR, nisITzaokr
Static  dDAT


*
****************** vpoèet na fakvyshdw ****************************************
# xTRANSLATE .nOSVodDAN   => anHD\[1 \]
# xTRANSLATE .nZAKLdan_1  => anHD\[2 \]
# xTRANSLATE .nZAKLdan_2  => anHD\[3 \]
# xTRANSLATE .nZAKLdan_3  => anHD\[4 \]
# xTRANSLATE .nHODNslev   => anHD\[5 \]
# xTRANSLATE .nCENzahCEL  => anHD\[6 \]
# xTRANSLATE .nPARzalFAK  => anHD\[7 \]
# xTRANSLATE .nPARzahFAK  => anHD\[8 \]
# xTRANSLATE .nCENzdan_1  => anHD\[9 \]
# xTRANSLATE .nCENzdan_2  => anHD\[10\]
# xTRANSLATE .nCENzdan_3  => anHD\[11\]
# xTRANSLATE .nCENzakcel  => anHD\[12\]
# xTRANSLATE .nSAZdan_1   => anHD\[13\]
# xTRANSLATE .nSAZdan_2   => anHD\[14\]
# xTRANSLATE .nSAZdan_3   => anHD\[15\]

*
** uložení pohledávky v transakci **********************************************
function fin_fakvyshd_wrt_inTrans(oDialog)
  local  lDone      := .t.
  *

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := fin_fakvyshd_wrt(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE
return lDone


function fin_fakvyshd_cpy(oDialog)
  local  nKy := FAKVYSHD ->nCISFAK, inScope
  *
  local  lNEWrec     := If( IsNull(oDialog), .F., oDialog:lNEWrec)
  local  lok_append2 := .f., nSign := 1
  local  secBeg, secFst
  local  cfg_cbanUctFAV, isOk := .f.


  if isCharacter(cfg_cbanUctFAV := sysConfig( 'finance:cbanUctFAV' ))
    cfg_cbanUctFAV := padr( upper( allTrim(cfg_cbanUctFAV)), 25 )
  else
    cfg_cbanUctFAV := ''
  endif


  ** tmp **
  drgDBMS:open('fakvyshdw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('fakvysitw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('fakvysitzw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('fakvysitsw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  ** dodací listy **
  drgDBMS:open('dodlsthdw',.T.,.T.,drgINI:dir_USERfitm)  ; ZAP
  drgDBMS:open('dodlstitw',.T.,.T.,drgINI:dir_USERfitm)  ; ZAP
  drgDBMS:open('pvpheadw' ,.T.,.T.,drgINI:dir_USERfitm)  ; ZAP
  drgDBMS:open('pvpitemw' ,.T.,.T.,drgINI:dir_USERfitm)  ; ZAP

  drgDBMS:open('c_typdok',,,,,'c_typdoka')


  if( select('c_bankuc') = 0, drgDBMS:open('c_bankuc'), nil )

  if .not. lNEWrec
    mh_COPYFLD('FAKVYSHD', 'fakvyshdw', .t., .t.)

    fakvysit->( ordSetFocus('FVYSIT1'), dbsetscope(SCOPE_BOTH, strzero(fakvyshd->ncisfak,10)), dbgoTop() )

    do while .not. fakvysit->(eof())
      mh_copyFld('fakvysit','fakvysitW',.t.,.t.)
      *
      fakvysitW->nfaktm_org := fakvysit->nfaktMnoz

      if fakvysit->nIND_zaokr = 1
        fakvysitW->_delrec    := '9'
        fakvyshdW->nzustPOzao := fakvysit->ncecPRkdz
      endif

      fakvysit->(dbSkip())
    enddo
    fakvysit->(dbgotop())

  else
    fakvyshdw->(dbappend())
    c_typdoka->( dbSeek( Upper(fakVysHd->ctypdoklad),,'C_TYPDOK01' ))

    if isobject(oDialog)                          .and. ;
       oDialog:drgDialog:cargo = drgEVENT_APPEND2 .and. ;
       .not. fakVysHD->(eof())                    .and. ;
       c_typdoka->lcopydok                        .and. ;
       fakVysHd->nparZalFak = 0                   .and. ;
       fakVysHd->nparZahFak = 0

      nSign := isNull( oDialog:drgDialog:cargo_usr, 1)

      oDialog:lok_append2 := lok_append2 := .t.
      mh_copyFld( 'fakVysHD', 'fakVysHDw', .f., .f. )

      ( fakVyshdw->ctypDoklad  := ''                                      , ;
        fakvyshdw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI                   , ;
        fakvyshdw ->nROK       := uctOBDOBI:FIN:NROK                      , ;
        fakvyshdw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI                   , ;
        fakvyshdw ->cOBDOBIDAN := uctOBDOBI:FIN:COBDOBIDAN                , ;
        fakvyshdw ->nKODZAOKRD := SYSCONFIG('FINANCE:nROUNDDPH')          , ;
        fakvyshdw ->cZKRATMENY := SYSCONFIG('FINANCE:cZAKLMENA')          , ;
        fakvyshdw ->dSPLATFAK  := DATE() +SYSCONFIG( 'FINANCE:nSPLATNOST'), ;
        fakvyshdw ->dVYSTFAK   := DATE()                                  , ;
        fakvyshdw ->dPOVINFAK  := DATE()                                  , ;
        fakvyshdw ->cJMENOVYS  := logOsoba                                , ;
        fakvyshdw ->nCISFAK    := fin_range_key('FAKVYSHD')[2]            , ;
        fakVyshdw ->ndoklad    := fakVyshdw ->ncisfak                     , ;
        fakvyshdW ->cdanDoklad := ALLTRIM( STR(fakvyshdw ->nCISFAK))      , ;
        fakvyshdw ->cVARSYM    := ALLTRIM( STR(fakvyshdw ->nCISFAK))        )

        * dobropis
        if( nSign = -1, fakVyshdW->nDoklad_DR := fakVyshd->ndoklad, nil )
        *
        ** musí se zanulovat
        fakVyshdw ->ddatTisk   := ctod('  .  .  ')
        fakVyshdw ->nuhrCelFak := 0
        fakVyshdw ->nuhrCelFaz := 0
        fakVyshdw ->dposUhrFak := ctod('  .  .  ')
        fakVyshdw ->nkurzRozdF := 0
        fakVyshdw ->nparZalFak := 0
        fakVyshdw ->nparZahFak := 0
        fakVyshdw ->dparZalFak := ctod('  .  .  ')

      if .not. (inScope := fakvysit->(dbscope()))
        fakvysit->(AdsSetOrder(1),dbsetscope(SCOPE_BOTH, strzero(fakvyshd->ncisfak,10)), DbGoTop() )
      endif

      fakvysit->(dbgotop())

      do while .not. fakvysit->(eof())
        mh_copyFld('fakvysit','fakvysitW',.t.,.f.)
        *
        fakVysitw->cobdobi    := fakVyshdw->cobdobi
        fakVysitw->nrok       := fakVyshdw->nrok
        fakVysitw->nobdobi    := fakVyshdw->nobdobi
        fakVysitw->ndoklad    := fakVyshdw->ndoklad
        fakVysitw->ncisFak    := fakVyshdw->ncisFak
        fakVysitw->dsplatFak  := fakVyshdw->dsplatFak
        fakVysitw->dvystFak   := fakVyshdw->dvystFak

        * dobropis
        if nSign = -1
          fakvysitW->nfaktMnoz  := fakvysit->nfaktMnoz * nSign
          *
          fakvysitW->ncecprzbz  := fakvysitW->ncejprkbz * fakvysitW->nfaktmnoz
          fakvysitW->ncelkslev  := fakvysitW->nhodnslev * fakvysitW->nfaktmnoz
          fakvysitW->ncecprkbz  := fakvysitW->ncejprkbz * fakvysitW->nfaktmnoz
          fakvysitW->ncecprkdz  := fakvysitW->ncejprkdz * fakvysitW->nfaktmnoz
        endif

        *
        fakvysitW->nfaktm_org := fakvysit->nfaktMnoz

        if fakvysit->nIND_zaokr = 1
          fakvysitW->_delrec    := '9'
          fakvyshdW->nzustPOzao := fakvysit->ncecPRkdz
        endif

        fakvysit->(dbSkip())
      enddo

      fakvysit->(dbgotop())
      if( .not. inSCope, fakvysit->(dbclearscope()), nil)

    else

     do case
     case .not. empty( cfg_cbanUctFAV )
       isOk := c_bankuc->( dbseek( cfg_cbanUctFAV,,'BANKUC1'))
     endcase

     if .not. isOk
       if( .not. c_bankuc->(dbseek(.t.,,'bankuc2')), c_bankuc->(dbgotop()),nil)
     endif

     ( fakvyshdw ->cULOHA     := "F"                                     , ;
       fakvyshdw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI                   , ;
       fakvyshdw ->nROK       := uctOBDOBI:FIN:NROK                      , ;
       fakvyshdw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI                   , ;
       fakvyshdw ->cOBDOBIDAN := uctOBDOBI:FIN:COBDOBIDAN                , ;
       fakvyshdw ->nKODZAOKRD := SYSCONFIG('FINANCE:nROUNDDPH')          , ;
       fakvyshdw ->cZKRATMENY := SYSCONFIG('FINANCE:cZAKLMENA')          , ;
       fakvyshdw ->dSPLATFAK  := DATE() +SYSCONFIG( 'FINANCE:nSPLATNOST'), ;
       fakvyshdw ->dVYSTFAK   := DATE()                                  , ;
       fakvyshdw ->dPOVINFAK  := DATE()                                  , ;
       fakvyshdw ->cBANK_UCT  := C_BANKUC ->cBANK_UCT                    , ;
       fakvyshdw ->cDENIK     := SYSCONFIG('FINANCE:cDENIKFAVY')         , ;
       fakvyshdw ->cDENIK_PUC := SYSCONFIG('FINANCE:cDENIKPUC')          , ;
       fakvyshdw ->nKURZAHMEN := 1                                       , ;
       fakvyshdw ->nMNOZPREP  := 1                                       , ;
       fakvyshdw ->cJMENOVYS  := logOsoba                                , ;
       fakvyshdw ->nCISFAK    := fin_range_key('FAKVYSHD')[2]            , ;
       fakvyshdW ->cdanDoklad := ALLTRIM( STR(fakvyshdw ->nCISFAK))      , ;
       fakvyshdw ->cVARSYM    := ALLTRIM( STR(fakvyshdw ->nCISFAK))      , ;
       fakvyshdw ->cZKRATMENZ := SYSCONFIG('FINANCE:cZAKLMENA')          , ;
       fakvyshdw ->cVYPSAZDAN := SYSCONFIG('FINANCE:cVYPSAZDPH')           )

       fakvyshdw->ctyppohybu  := sysconfig('finance:ctyppohFAV')
    endif
  endif
  *
  fakvyshdw->lno_indph := .not. fakvyshdw->lno_indph

  fin_vykdph_cpy('fakvyshdw')
  FIN_parzalfak_vykdph_cpy( 'fakvyshdw' )

  if( lok_append2, fin_ap_modihd( 'fakVysHdw' ), nil )
return nil



static function fin_fakvyshd_wrt(odialog)
  local  anFai := {}, anDoi := {}, anFaz := {}, anPaz := {}, anPen := {}, anVYR := {}, anVYRit := {}, anObj := {}
  local  uctLikv, mainOk := .t., nrecor, lnewrec := odialog:lnewrec, vykhphOk
  local  omoment
  *
  local  nparzalfak := 0, nparzahfak := 0
  *
  **
  if(select('dodzboz') <> 0, nil, drgDBMS:open('dodzboz') )

  mainOk := if(fakvyshdw->_delrec <> '9', pro_fakvyshd_isdol(odialog), .t.)

  fin_fakvyshd_puc(fakvyshdw->nfintyp,'FAKVYSHDw')
  fakvysitw->(AdsSetOrder(0), ;
              dbgotop()     , ;
              dbeval({|| fin_fakvyshd_rlo( anFai, anDoi, anFaz, anPaz, anPen, anVYR, anVYRit, anObj) }))

  * spojíme RV položek faktury a párovaných záloh, na FA lze použít víc záloh
  * 12.11.2012
  * musíme do vykDph_iW nakopírovat jen ty položky které jsou v fakVysitW
  * jinak by se tam dostali i ty které si jen prohlížel, ale nepøevzal
  vykdph_pw->(dbclearFilter(), dbgotop())
  do while .not. vykDph_pW->(eof())
    if fakVysitW->( dbseek( vykDph_pW->ncisFak,,'FAKVYSIT_2'))
      mh_copyfld('vykdph_pw','vykdph_iw',.t., .f.)
    endif
    vykDph_pW->(dbskip())
  enddo

*  vykdph_pw->(dbclearFilter()                                           , ;
*              dbgotop()                                                 , ;
*              dbeval({ || mh_copyfld('vykdph_pw','vykdph_iw',.t., .f.) }) )

  vykdph_iw->(flock(), dbCommit())

  uctLikv := UCT_likvidace():new(upper(fakvyshdw->culoha) +upper(fakvyshdw->ctypdoklad),.T.)
  mainOk  := (mainOk .and. fin_vykdph_rlo('FAKVYSHDw'))

  if .not. lnewrec
    fakvyshd->(dbgoto(fakvyshdw->_nrecor))
    mainOk := (mainOk                        .and.         ;
               fakvyshd->(sx_rlock())        .and.         ;
               fakvysit->(sx_rlock(anFai))   .and.         ;
               fakvyshd->(sx_rlock(anFaz))   .and.         ;
               parvyzal->(sx_rlock(anPaz))   .and.         ;
               dodlstit->(sx_rlock(anDoi))   .and.         ;
               fakvyshd->(sx_rlock(anPen))   .and.         ;
               vyrZak  ->(sx_rlock(anVYR))   .and.         ;
               vyrZakit->(sx_rlock(anVYRit)) .and.         ;
               objitem ->(sx_rlock(anObj))   .and.         ;
               ucetpol ->(sx_rlock(uctLikv:ucetpol_rlo)) )
  else
    mainOk := (mainOk                        .and.         ;
               dodlstit->(sx_rlock(anDoi  )) .and.         ;
               vyrZak  ->(sx_rlock(anVYR  )) .and.         ;
               vyrZakit->(sx_rlock(anVYRit)) .and.         ;
               objitem ->(sx_rlock(anObj  ))               )
  endif

  if mainOk
    omoment := SYS_MOMENT( '=== UKLÁDÁM DOKLAD ===')

    *
    if(fakvyshdw->nprocDan_1 = 0, fakvyshdw->nprocDan_1 := seekSazDPH(1,fakvyshdw->dpovinFak), nil)
    if(fakvyshdw->nprocDan_2 = 0, fakvyshdw->nprocDan_2 := seekSazDPH(2,fakvyshdw->dpovinFak), nil)
    *
    fakvyshdw->lno_indph := .not. fakvyshdw->lno_indph

    if fakvyshdw->_delrec <> '9'
      if odialog:lnewrec
        fakvyshdw->ndoklad := fakvyshdw->ncisfak
      endif

      fakvyshdw->ncenfakcel := fakvyshdw->ncenzakcel +abs(fakvyshdw->nparzalfak)
      fakvyshdw->ncenfazcel := fakvyshdw->ncenzahcel +abs(fakvyshdw->nparzahfak)

/*
platilo do 10.8.2010
      fakvyshdw->ncenfakcel := fakvyshdw->ncenzakcel +abs(fakvyshd->nparzalfak)
      fakvyshdw->ncenfazcel := fakvyshdw->ncenzahcel +abs(fakvyshd->nparzahfak)

/*
platilo 12.8.2009
      if odialog:lnewrec
        fakvyshdw->ndoklad    := fakvyshdw->ncisfak
        fakvyshdw->ncenfakcel := fakvyshdw->ncenzakcel
        fakvyshdw->ncenfazcel := fakvyshdw->ncenzahcel
      else
        fakvyshdw->ncenfakcel := fakvyshdw->ncenzakcel
        fakvyshdw->ncenfazcel := fakvyshdw->ncenzahcel


**        fakvyshdw->ncenfakcel := fakvyshdw->ncenzakcel +abs(fakvyshd->nparzalfak)
**        fakvyshdw->nparzahfak := fakvyshdw->ncenfazcel +abs(fakvyshd->nparzahfak)

*-        fakvyshdw->nparZalFak := fakvyshdw->ncenzakcel +abs(fakvyshd->nparzalfak)
*-        fakvyshdw->nparZahFak := fakvyshdw->ncenfazcel +abs(fakvyshd->nparzahfak)
      endif
*/

      mh_copyfld('fakvyshdw','fakvyshd',lnewRec, .f.)
      fakvyshd->(dbcommit())
    endif

    fakvysitw->(AdsSetOrder(0),dbgotop())
    fakvyshd->(sx_rlock(anFaz), sx_rlock(anPen))

    do while .not. fakvysitw->(eof())
      if((nrecor := fakvysitw->_nrecor) = 0, nil, fakvysit->(dbgoto(nrecor)))

      if   fakvysitw->_delrec = '9'
        if(nrecor = 0, nil, fakvysit->(dbdelete()))
      else
        fin_fakvyshd_carKod()

        * pozor otevøela se editace úèetního a daòového období na HD
        fakvysitw->nrok       := fakvyshd->nrok
        fakvysitw->nobdobi    := fakvyshd->nobdobi
        fakvysitw->cobdobi    := fakvyshd->cobdobi

        fakvysitw->czkrTYPfak := fakvyshd->czkrTYPfak
        fakvysitw->ndoklad    := fakvyshd->ndoklad
        fakvysitw->ncisFak    := fakvyshd->ncisFak
        fakvysitw->dvystFak   := fakvyshd->dvystFak
        fakvysitw->czkrProdej := fakvyshd->czkrProdej
        mh_copyfld('fakvysitw','fakvysit',(nrecor=0), .f.)
      endif

      if fakvysitw->_delrec = '9' .and. nrecOr = 0
        * nic nedìláme, jen zkoušel pøidat položku s vazbou a zrušil ji
      else

        if(.not. empty(fakvysitw->nciszalfak ), fin_fakvyshd_par(), ;
          if( .not. empty(fakvysitw->ncislodl  ), fin_fakvyshd_dol(), ;
            if( .not. empty(fakvysitw->ncispenfak), fin_fakvyshd_pen(), ;
              if(.not. empty(fakvysitw->cciszakaz ),  fin_fakvyshd_vyr(), ;
                if(.not. empty(fakvysitw->ccislobint),   fin_fakvyshd_obj(), nil )))))
      endif

      fakvysitw->(dbskip())
    enddo

    if( fakvyshdw->_delrec = '9')  ;  uctLikv:ucetpol_del()
                                      fin_vykdph_wrt(NIL,.t.,'FAKVYSHD')
                                      fakvyshd->(sx_rlock(),dbdelete())
    else                           ;  fin_vykdph_wrt(NIL,.f.,'FAKVYSHD')
                                      uctLikv:ucetpol_wrt()
    endif

    omoment:destroy()
  else
    drgMsg(drgNLS:msg('Nelze modifikovat FAKTURU VYSTAVENOU, blokováno uživatelem ...'),,odialog)
  endif

  fakvyshd->(dbunlock(), dbcommit())
   fakvysit->(dbunlock(), dbcommit())
    parvyzal->(dbunlock(), dbcommit())
     dodlstit->(dbunlock(), dbcommit())
      vyrzak  ->(dbunlock(), dbcommit())
       vyrZakit->(dbunlock(), dbcommit())
        objitem ->(dbunlock(), dbcommit())
         vykdph_i->(dbunlock(), dbcommit())
          ucetpol ->(dbunlock(), dbcommit())
return mainOk


*
** je k faktutuøe pripojen dodací list *
static function pro_fakvyshd_isdol(odialog)
  local ok  := .t., anDoi := {}, pos
  local cky := upper(fakvyshdw->culoha) +upper(fakvyshdw->ctypdoklad) +upper(fakvyshdw->ctyppohybu)
  *
  local lnewrec := odialog:lnewrec

  c_typpoh->(dbseek(cky,,'C_TYPPOH05'))

  if .not. empty(cky := c_typpoh->csubpohyb)
    if c_typpoh->(dbseek(cky,,'C_TYPPOH06'))

      drgDBMS:open('pvphead',,,,,'pvp_head')
      drgDBMS:open('pvpitem',,,,,'pvp_item')

      if(dodlsthd->(dbseek(fakvyshdw->ncislodl,,'DODLHD1')) .and. fakvyshdw->ncislodl <> 0)
        ky := strzero(dodlsthd->ndoklad,10)
        dodlstit->(AdsSetOrder('DODLIT5'),dbsetscope(SCOPE_BOTH,ky),dbgotop())

        pro_dodlsthd_cpy(odialog)

        pvpheadw->(dbCommit())
        pvpitemw->(dbCommit())
      else
        odialog:lnewrec := .t.
        fin_copyfld('fakvyshdw','dodlsthdw',.t.)
        dodlsthdw->culoha     := c_typpoh->culoha
        dodlsthdw->ctypdoklad := c_typpoh->ctypdoklad
        dodlsthdw->ctyppohybu := c_typpoh->ctyppohybu
        *
        dodlsthdw->ctask      := c_typpoh->ctask
        dodlsthdw->csubtask   := c_typpoh->csubtask
        *
        dodlsthdw->ndoklad    := fin_range_key('DODLSTHD')[2]
      endif

      dodlstitw->(dbgotop()               , dbeval({|| aadd(anDoi,dodlstitw->(recno())) }), ;
                  AdsSetOrder('DODLSIT_1'), dbgotop()                                       )
      fakvysitw->(dbgotop())

      do while .not. fakvysitw->(eof())
        *
        ** pozor, tohle by mohl být obecný problém pøi generování dokladù z parenta
        ** poøídí položky, pak se pøepne do hlavièky a zmìní èísloFaktury
        if lnewRec
          fakvysitw->ndoklad    := fakvyshdw->ndoklad
          fakvysitw->ncisFak    := fakvyshdw->ncisFak
        endif

        if upper(fakvysitw->cpolcen) = 'C' .or. upper(fakvysitw->cpolcen) = 'E'
          ok := dodlstitw->(dbseek(strzero(fakvysitw->nintcount,5),,'DODLSIT_1'))
          fin_copyfld('fakvysitw','dodlstitw',.not. ok )
          if(pos := ascan(anDOi,dodlstitw->(recno()))) <> 0
            (adel(anDoi,pos), asize(anDoi, len(anDoi) -1))
          endif
        endif

        fakvysitw->(dbskip())
      enddo
      *
      aeval(anDoi, {|x| (dodlstitw->(dbgoto(x)),dodlstitw->_delrec := '9') })

      dodlstit ->(dbclearscope())
      dodlsthdw->(dbgotop(),dbcommit())
      dodlstitw->(dbgotop(),dbcommit())

      if dodlstitw->(eof())
        if .not. dodlsthdw->(eof())
          dodlsthdw->_delrec := '9'
          ok := pro_dodlsthd_wrt(odialog)
        endif
      else
        ok := pro_dodlsthd_wrt(odialog)
      endif

      pvp_head->(dbclosearea())
      pvp_item->(dbclosearea())

      if ok
        fakvyshdw->ncislodl  := dodlsthd->ndoklad
        fakvyshdw->ncislopvp := dodlsthd->ncislopvp
      endif
    endif
  odialog:lnewrec := lnewrec
  endif
return ok


static function fin_copyfld(cDBFrom,cDBTo,lDBApp)
  local  npos, xval, cfrom := cDBFrom
  local  afrom := (cfrom)->(dbstruct())
  *
  local  x, a_noCpy := {'cuniqidrec', 'muserzmenr', 'sid', '_nrecor', 'ncislopvp' }

  if(isnull(lDBapp,.f.), (cDBTo)->(dbappend()), nil)

  for x := 1 to len(aFrom) step 1
    cItem := aFrom[x,DBS_NAME]
    if AScan(a_noCpy,lower(cItem)) = 0
      if(nPos := (cDBTo)->( FieldPos( aFrom[x,DBS_NAME]))) <> 0
        if .not. isNull(xVal := (cDBFrom) ->( FieldGet(x)))
          (cDBTo) ->( FieldPut( nPos, xVal))
        endif
      endif
    endif
  next
return nil


*
** zrušení faktury vystavené **
function fin_fakvyshd_del(odialog)
  local  mainOk := .f., mainDl := .t., ky

  * dodací listy + výdejky
  if fakvyshd->ncislodl <> 0
    if(select('pvp_head') = 0, drgDBMS:open('pvphead',,,,,'pvp_head'), nil)
    if(select('pvp_item') = 0, drgDBMS:open('pvpitem',,,,,'pvp_item'), nil)
    if(select('dodlsthd') = 0, drgDBMS:open('dodlsthd'), nil)
    if(select('dodlstit') = 0, drgDBMS:open('dodlstit'), nil)

    if dodlsthd->(dbseek(fakvyshd->ncislodl,,'DODLHD1'))
       ky := strzero(dodlsthd->ndoklad,10)
       dodlstit->(AdsSetOrder('DODLIT5'),dbsetscope(SCOPE_BOTH,ky),dbgotop())

       pro_dodlsthd_cpy(odialog)


       dodlsthdw->(dbcommit())
       dodlstitw->(dbcommit())
       pvpheadw->(dbCommit())
       pvpitemw->(dbCommit())

       mainDl := pro_dodlsthd_del(odialog)
    endif
  endif

  * faktury
  if mainDl
    fakvyshdw->_delrec := '9'
    fakvysitw->(AdsSetOrder(0),dbgotop(),dbeval({|| fakvysitw->_delrec := '9'}))

// TRANSAKCE    mainOk := fin_fakvyshd_wrt(odialog)
    mainOk := fin_fakvyshd_wrt_inTrans(oDialog)
  endif
return mainOk


static function fin_fakvyshd_rlo( anFai, anDoi, anFaz, anPaz, anPen, anVYR, anVYRit, anObj)
  local  ncislodl   := fakvysitw->ncislodl , ncountdl := fakvysitw->ncountdl
  local  ncisfak    := fakvysitw->ncisfak
  local  nciszalfak := fakvysitw->nciszalfak
  local  ncispenfak := fakvysitw->ncispenfak
  local  ccisZakaz  := fakvysitw->cciszakaz , ncisPOLzak := fakvysitw->ncisPOLzak
  local  cobjitem   := fakvysitw->ccislObint, npolobj    := fakvysitw->ncislPolob

  aadd(anFai,fakvysitw->_nrecor)

  if     .not. empty(nciszalfak)
    if(fakvyshd->(dbseek(nciszalfak,,'FODBHD1')), ;
      (fakvysitw->nrecfaz := fakvyshd->(recno()), aadd(anFaz, fakvyshd->(recno()))), nil)

    if(parvyzal->(dbseek(strZero(ncisfak,10) +strZero(nciszalfak,10),,'FODBHD3')), ;
      (fakvysitw->nrecpar := parvyzal->(recno()), aadd(anPaz, parvyzal->(recno()))), nil)

    *  položka   fakvysitw - je párovaná záloha s vazbou na daòové doklady
    **           nisParZal = 2
    if(fakvysitw->nisParZal = 2, fin_fakvyshd_rvpaz(ncisZalFak), nil)

  elseif .not. empty(ncislodl)
    if(dodlstit->(dbseek(strzero(ncislodl,10) +strzero(ncountdl,5),,'DODLIT5')), ;
      (fakvysitw->nrecdol := dodlstit->(recno()), aadd(anDoi, dodlstit->(recno()))), nil)

  elseif .not. empty(ncispenfak)
    if(fakvyshd->(dbseek(ncispenfak,,'FODBHD1')), ;
      (fakvysitw->nrecpen := fakvyshd->(recno()), aadd(anPen, fakvyshd->(recno()))), nil)

  elseif .not. empty(ccisZakaz)
    if vyrZakit->( dbseek(upper(ccisZakaz) +strZero(ncisPOLzak,5),,'ZAKIT_1'))
      if vyrzak->( dbseek( upper(ccisZakaz),,'VYRZAK1'))
        aadd( anVYR  , vyrZak  ->( recNo()) )
        aadd( anVYRit, vyrZakit->( recNo()) )

        fakvysitW->nrec_VYR   := vyrZak  ->( recNo())
        fakvysitW->nrec_VYRit := vyrZakit->( recNo())
      endif
    endif

  elseif .not. empty(cobjitem)
    if(objitem ->(dbseek(upper(cobjitem) +strZero(npolobj,5),,'OBJITEM2')), ;
      (fakvysitw->nrecobj := objitem ->(recNo()), aadd(anObj, objitem ->(recNo()))), ;
       fakvysitw->nrecobj := 0 )

  endif
return nil


static function fin_fakvyshd_rvpaz(ncisZalFak)
  * pøí zrušení položky zálohy je využit test pøi ukládání RV

  if fakvysitw->_delRec = '9'
    vykdph_pw->(dbGoTop())
    do while .not. vykdph_pw->(eof())
      if vykdph_pw->ncisFak = ncisZalFak
        vykdph_pw->nprocDph   := 0
        vykdph_pw->nzakld_Dph := 0
        vykdph_pw->nsazba_Dph := 0
      endif

      vykdph_pw->(dbSkip())
    enddo
  endif
return nil


* položka z fakvyshd - párované zálohy
static function fin_fakvyshd_par()
  local recNo := fakvyshd->(recno()), cisFak := fakvyshd->ncisfak

  fakvyshd->(dbgoto(fakvysitw->nrecfaz))
  parvyzal->(dbgoto(fakvysitw->nrecpar))

  if fakvysitw->_delrec = '9'
    fakvyshd->nparzalfak -= parvyzal->nparzalfak
                            parvyzal->(dbdelete())
  else
    if(fakvysitw->ncenzahcel < 0, ( fin_fakvyshd_puc(3,'fakvysitw')             , ;
                                   fakvysit->cucet_pucr := fakvysitw->cucet_pucr, ;
                                   fakvysit->cucet_pucs := fakvysit->cucet_pucs   ), nil)

    if fakvysitw->nrecpar = 0
      fakvyshd->nparzalfak +=  fakvysitw->ncenJEDzad
    else
      fakvyshd->nparzalfak += (fakvysitw->ncenJEDzad -parvyzal->nparzalfak)
    endif
    fakvyshd->dparzalfak := date()

    if(fakvysitw->nrecpar = 0, parvyzal->(dbappend()), nil)
    parvyzal->ncisfak    := cisFak
    parvyzal->nciszalfak := fakvyshd->ncisfak
    if fakvyshdw->nfintyp = 3
      parvyzal->ncenzalfak := fakvyshd->ncenzahcel
      parvyzal->nuhrzalfak := fakvyshd->nuhrcelfaz
    else
      parvyzal->ncenzalfak := fakvyshd->ncenzakcel
      parvyzal->nuhrzalfak := fakvyshd->nuhrcelfak
    endif
    parvyzal->duhrzalfak := fakvyshd ->dposuhrfak
    parvyzal->nparzalfak := fakvysitw->ncenJEDzad
    parvyzal->dparzalfak := date()
  endif

  fakvyshd->(dbgoto(recNo))
return nil


* položka z dodlstit
static function fin_fakvyshd_dol()
  dodlstit->(dbgoto(fakvysitw->nrecdol))

  if fakvysitw->_delrec = '9'
    dodlstit->ncisvysfak := 0
    dodlstit->nmnoz_fakt -= fakvysitw->nfaktm_org
    dodlstit->nmnoz_fakv -= fakvysitw->nfaktm_org
  else
    dodlstit->ncisvysfak := fakvyshd->ncisfak
    dodlstit->nmnoz_fakt += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
    dodlstit->nmnoz_fakv += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
  endif

  dodlstit->nstav_fakt := if(dodlstit->nmnoz_fakt = 0                  , 0, ;
                          if(dodlstit->nmnoz_fakt = dodlstit->nfaktMnoz, 2, 1))
  dodlstit->nstav_fakv := dodlstit->nstav_fakt
return nil


* položka z objitem
static function fin_fakvyshd_obj()

  if fakvysitw->nrecobj <> 0
    objitem ->(dbgoto(fakvysitw->nrecobj))

    if fakvysitw->_delrec = '9'
      objitem->ncisvysfak := 0
      objitem->nmnoz_fakt -= fakvysitw->nfaktm_org
      objitem->nmnoz_fakv -= fakvysitw->nfaktm_org
      objitem->nmnozplOdb -= fakvysitw->nfaktm_org

      objitem->nmnozReODB += fakvysitW->nmnozReODB
    else
      objitem->ncisvysfak := fakvyshd->ncisfak
      objitem->nmnoz_fakt += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
      objitem->nmnoz_fakv += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
      objitem->nmnozplOdb += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)

      if objitem->nmnozReODB <> 0
        objitem->nmnozReODB := max( 0, objitem->nmnozReODB -(fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org))
      endif
    endif


    objitem->nstav_fakt := if(objitem->nmnoz_fakt  = 0                     , 0, ;
                           if(objitem->nmnoz_fakt >= objitem->nmnozObOdb, 2, 1) )
    objitem->nstav_fakv := objitem->nstav_fakt

    * hruško jabkový souèet na hlavièce
    if objhead->(dbseek(objitem->ndoklad,,'OBJHEAD7'))
      if objhead->(sx_rlock())
        if fakvysitw->_delrec = '9'
          objhead->nmnozplOdb -= fakvysitw->nfaktm_org
        else
          objhead->nmnozplOdb += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
        endif
      endif
      objhead->(dbunlock(),dbcommit())
    endif
  endif
return nil

* položka z vyrzakit
static function fin_fakvyshd_vyr()
  vyrZak  ->( dbgoTo( fakvysitW->nrec_VYR   ))
  vyrZakit->( dbgoTo( fakvysitW->nrec_VYRit ))

  if fakvysitw->_delrec = '9'
    vyrZak  ->nmnozfakt  -= fakvysitw->nfaktm_org
    vyrZak  ->nmnoz_fakt -= fakvysitw->nfaktm_org
    vyrZak  ->nmnoz_fakv -= fakvysitw->nfaktm_org
    if(vyrZak->nmnozfakt = 0, vyrzak->ncisfak := 0, nil)

    vyrZakit->nmnozfakt  -= fakvysitw->nfaktm_org
    vyrZakit->nmnoz_fakt -= fakvysitw->nfaktm_org
    vyrZakit->nmnoz_fakv -= fakvysitw->nfaktm_org
    if(vyrZakit->nmnozfakt = 0, vyrZakit->ncisfak := 0, nil)
  else
    vyrZak  ->ncisfak    := fakvysitw->ncisfak
    vyrZak  ->nmnozfakt  += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
    vyrZak  ->nmnoz_fakt += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
    vyrZak  ->nmnoz_fakv += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)

    vyrZakit->ncisfak    := fakvysitw->ncisfak
    vyrZakit->nmnozfakt  += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
    vyrZakit->nmnoz_fakt += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
    vyrZakit->nmnoz_fakv += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
  endif

  vyrZak  ->nstav_fakv := if(vyrZak->nmnoz_fakt = 0                 , 0,   ;
                          if(vyrZak->nmnoz_fakt = vyrZak->nmnozPlano, 2, 1))

  vyrZakit->nstav_fakv := if(vyrZakit->nmnoz_fakt = 0                   , 0,   ;
                          if(vyrZakit->nmnoz_fakt = vyrZakit->nmnozPlano, 2, 1))
return nil

/*
static function fin_fakvyshd_vyr()
  vyrzak->(dbgoto(fakvysitw->nrecvyr))

  if fakvysitw->_delrec = '9'
    if(vyrzak->nmnozfakt = 0, vyrzak->ncisfak := 0, nil)
    vyrzak->nmnozfakt  -= fakvysitw->nfaktm_org
    vyrzak->nmnoz_fakt -= fakvysitw->nfaktm_org
    vyrzak->nmnoz_fakv -= fakvysitw->nfaktm_org
  else
    vyrzak->ncisfak    := fakvysitw->ncisfak
    vyrzak->nmnozfakt  += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
    vyrzak->nmnoz_fakt += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
    vyrzak->nmnoz_fakv += (fakvysitw->nfaktmnoz -fakvysitw->nfaktm_org)
  endif

*  vyrzakit->nstav_fakt := if(vyrzakit->nmnoz_fakt = 0                     , 0, ;
*                          if(vyrzakit->nmnoz_fakt = vyrzakit->nmnozPlano, 2, 1))
return nil
*/


* položka z fakvyshd - penalizace
static function fin_fakvyshd_pen()
  local  recNo := fakvyshd->(recno())

  fakvyshd->(dbgoto(fakvysitw->nrecpen))

  if fakvysitw->_delrec = '9'  ;  (fakvyshd->ncispenfak := 0                 , fakvyshd->ddatpenfak := ctod('  .  .  ')   )
  else                         ;  (fakvyshd->ncispenfak := fakvyshdw->ncisfak, fakvyshd->ddatpenfak := fakvyshdw->dvystfak)
  endif

  fakvyshd->(dbgoto(recNo))
return nil



* podrozvaha - nastavení úètù
static function fin_fakvyshd_puc(finTyp, cFILE_ou)
  local cky, lok := .t.

  if( isnull(finTyp), finTyp := fakvyshdw->nfintyp, nil)
  drgDBMS:open('c_podruc')
  c_podruc->(AdsSetOrder(2))

  if(finTyp = 3 .or. finTyp = 4)                                             // zahr zahr_zálohová
    cky := strzero(fakvyshdw->ncisfirmy,5) +upper(fakvyshdw->czkratmenz)

    if c_podruc->(dbseek(cky,,'C_PODR2'))                                            // firmy - c_meny - c_podruc
    else
      cky := upper(fakvyshdw->czkratmenz)
      if c_podruc->(dbseek(cky,,'C_PODR1'))                                           // c_meny - cpodruc
      else
        cky := '00000' +'   '
        if c_podruc->(dbseek(cky,,'C_PODR2'))                                         // základní
        endif
      endif
    endif

    if finTyp = 3
      if cfile_ou = 'fakvyshdw'
        (cfile_ou)->cucet_pucr := c_podruc->cuctp_puh
        (cfile_ou)->cucet_pucs := c_podruc->cuctp_puhs
      else
        if empty((cfile_ou)->cucet_pucr) .or. empty((cfile_ou)->cucet_pucs)
          (cfile_ou)->cucet_pucr := c_podruc->cuctp_puz
          (cfile_ou)->cucet_pucs := c_podruc->cuctp_puzs
        endif
      endif
    else
      (cfile_ou)->cucet_pucr := c_podruc->cuctp_puz
      (cfile_ou)->cucet_pucs := c_podruc->cuctp_puzs
    endif
  endif
return nil


* dolpnìní èárového kódu do fakvysit
static function fin_fakvyshd_carKod()
  local  cky   := upper(fakvysitw->ccisSklad) +upper(fakvysitw->csklPol)
  *
  local  paKod := {}

  dodzboz->( AdsSetOrder('DODAV9')      , ;
             dbsetscope(SCOPE_BOTH, cky), ;
             DbGoTop()                  , ;
             DbEval( { || aadd( paKod, left(dodzboz->ccarKod,15) ) }, ;
                     { || .not. empty(dodzboz->ccarKod)            }  ), ;
             DbClearScope()                                              )

  if len(paKod) <> 0
    fakvysitw->ccarKod_1 := if( len( paKod) >= 1, paKod[1], '' )
    fakvysitw->ccarKod_2 := if( len( paKod) >= 2, paKod[2], '' )
    fakvysitw->ccarKod_3 := if( len( paKod) >= 3, paKod[3], '' )
  endif
return nil



* pøepoèet hlavièky dokladu fakvyshd/dodlsthd
function fin_ap_modihd(cHp, lis_prodej)
  local  nRECNo, nORDno := C_DPH ->( AdsSetOrder( 1))
  local  cIp  := STRTRAN( upper(cHp), 'HDW', 'ITW')
  local  nZAOKR := 0
  local  nOBJEM := 0, nHMOTNOST := 0
  local  nTYP_v := 1
  local  nVYP_c := VAL( RIGHT( SYSCONFIG('FINANCE:cVYPsazDPH'),1))  // CFG
  local  nVYP_f := VAL( RIGHT( (cHp) ->cVYPsazDAN,1))               // FAKVYSHD
//
  local  nZAKLdan_1, nSAZdan_1, nZAKLdan_2, nSAZdan_2, nZAKLdan_3, nSAZdan_3
  local  typ_dph, axcm := { {0,0,0}, {0,0,0}, {0,0,0} }, x, roz_dph
//
  default lis_prodej to .f.

  if lis_prodej
    nVYP_c := VAL( RIGHT( SYSCONFIG('PRODEJ:cVYPsazDPH'),1))        // CFG
  endif

  if( (cHp)->(fieldPos('nisItZaokr')) <> 0, nisItZaokr := (cHp)->nisItZaokr, nisITzaokr := 0 )

  vykdph_iw->(dbgotop(),dbeval({|| (vykdph_iw->nzakld_dph := 0,vykdph_iw->nsazba_dph := 0)}))

  anHD := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  nFINtyp    := (cHp) ->nFinTYP
  nROUNDdph  := SysConfig( 'Finance:nRoundDph')
  nKOE       := (cHp) ->nKURzahMEN/(cHp) ->nMNOZprep
  nKODzaokr  := (cHp) ->nKODzaokr
  nPROCdan_1 := (cHp) ->nPROCdan_1
  nPROCdan_2 := (cHp) ->nPROCdan_2
  nPROCdan_3 := (cHp) ->nPROCdan_3

  nZAKLdan_1 := nSAZdan_1 := nZAKLdan_2 := nSAZdan_2 := nZAKLdan_3 := nSAZdan_3 := 0
  ( nRECNo := (cIp) ->( RECNO()), (cIp) ->( dbGOTOP()) )

  * nápoèty pro pøenesenou daòovou povinnost ø. 25 DPH
  (cHp)->nZAKLdan01 := 0
  (cHp)->nZAKLdan02 := 0
  (cHp)->nZAKLdan03 := 0

  do while !(cIp) ->( EOF())

    // prepocet polozek KURZEM //
    (cIp) ->nCENAzakl  := (cIp) ->nCeJPrKBZ * nKOe
    (cIp) ->nCENjedzak := (cIp) ->nCeJPrKBZ * nKOe
    (cIp) ->nCENjedzad := (cIp) ->nCeJPrKDZ * nKOe
    (cIp) ->nCENAzakc  := (cIp) ->nCeCPrZBZ * nKOe
    (cIp) ->nCENzakcel := (cIp) ->nCeCPrKBZ * nKOe
    (cIp) ->nCENzakced := (cIp) ->nCeCPrKDZ * nKOe
    (cIp) ->nSAZdan    := (cIp) ->nCENzakced - (cIp) ->nCENzakcel

/*
    * válka shalíøem
    do case
    case lower(cIp) = 'fakvysitw'
      (cIp)->nsazDan  := if( (cIp)->nind_ZAOKR = 1, ;
                             (cIp)->nsazDan       , ;
                             (cIp) ->nCENzakced - (cIp) ->nCENzakcel )
    otherWise
      (cIp) ->nSAZdan := (cIp) ->nCENzakced - (cIp) ->nCENzakcel
    endCase
*/

    * nápoèet rv-dph pro bìžnou položku, vylouèíme párované zálohy
    if (cIp)->nisParZal <> 2
      if vykdph_iw->(dbseek((cip)->nradvykdph,,'VYKDPH_5'))
        vykdph_iw->nzakld_dph += (cip)->ncenzakcel
        vykdph_iw->nsazba_dph += (cip)->nsazdan

        typ_dph := vykdph_iw->ntyp_dph
        if( typ_dph = 1 .or. typ_dph = 2 .or. typ_dph = 3, ;
          (axcm[typ_dph,2] += (cip)->nsazdan, axcm[typ_dph,3] := vykdph_iw->(recNo())), nil)
      endif
    endif

    if .not. empty((cIp) ->nklicdph)
      c_dph->(dbSeek((cIp)->nKlicDph,,'C_DPH1'))
    else
      c_dph->(dbseek((cIp)->nprocdph,,'C_DPH2'))
    endif

    do case
    case ( C_DPH ->nNapocet == 0 )
      if( (cIp) ->nNULLdph == 4 .or. (cIp) ->nNULLdph == 14 )
        ( .nPARzalFAK += (cIp) ->nCENzakCEL, .nPARzahFAK += (cIp) ->nCENzahCEL )
        if     (cIp) ->nNAPOCET == 1
          nZAKLdan_1 += (cIp) ->nCENzakCEL
          nSAZdan_1  += (cIp) ->nSAZdan
        elseif (cIp) ->nNAPOCET == 2
          nZAKLdan_2 += (cIp) ->nCENzakCEL
          nSAZdan_2  += (cIp) ->nSAZdan
        elseif (cIp) ->nNAPOCET == 3
          nZAKLdan_3 += (cIp) ->nCENzakCEL
          nSAZdan_3  += (cIp) ->nSAZdan
        endif
      else
        .nOSVodDAN  += (cIp) ->nCeCPrKDZ

        if     (cIp) ->nnapocetPP == 1
          (cHp)->nZAKLdan01 += (cIp) ->nCENzakCEL
        elseif (cIp) ->nnapocetPP == 2
          (cHp)->nZAKLdan02 += (cIp) ->nCENzakCEL
        elseif (cIp) ->nnapocetPP == 3
          (cHp)->nZAKLdan03 += (cIp) ->nCENzakCEL
        endif

      endif

    case ( C_DPH ->nNapocet == 1 ) ; .nZAKLdan_1 += (cIp) ->nCeCPrKBZ   // 1
                                     .nSAZdan_1  += (cIp) ->nsazDan     //
                                     .nCENzdan_1 += (cIp) ->nCeCPrKDZ   //

    case ( C_DPH ->nNapocet == 2 ) ; .nZAKLdan_2 += (cIp) ->nCeCPrKBZ   // 2
                                     .nSAZdan_2  += (cIp) ->nsazDan     //
                                     .nCENzdan_2 += (cIp) ->nCeCPrKDZ   //

    case ( C_DPH ->nNapocet == 3 ) ; .nZAKLdan_3 += (cIp) ->nCeCPrKBZ   // 3
                                     .nSAZdan_3  += (cIp) ->nsazDan     //
                                     .nCENzdan_3 += (cIp) ->nCeCPrKDZ   //
    endcase

    nOBJEM      += (cIp) ->nOBJEM
    nHMOTNOST   += (cIp) ->nHMOTNOST
    .nCENzahCEL += (cIp) ->nCeCPrKDZ
    .nHODNslev  += (cIp) ->nCELKslev
    .nCENzakcel += (cIp) ->nCENzakcel

    (cIp) ->( dbSKIP())
  enddo

  (cHp) ->nOBJEM     :=  nOBJEM
  (cHp) ->nHMOTNOST  :=  nHMOTNOST

  do case
  case( nVYP_f <> 0 )  ;  nTYP_v := nVYP_f
  case( nVYP_c <> 0 )  ;  nTYP_v := nVYP_c
  otherwise
    nTYP_v := If((cHp) ->dPOVINfak >= CTOD('01.05.04'), 2, 1 )
  endcase


  if nTYP_v == 2                                             //NEw od 1.5.2004
    .nOSVoddan  := MH_roundnumb( .nOSVoddan , nKODzaokr)
    .nCENzdan_1 := MH_roundnumb( .nCENzdan_1, nKODzaokr)
    .nCENzdan_2 := MH_roundnumb( .nCENzdan_2, nKODzaokr)
    .nCENzdan_3 := MH_roundnumb( .nCENzdan_3, nKODzaokr)

      EU_comphd(cHp, nZAOKR)
  else

    AP_comphd(cHp)
  endif


  (cHp) ->nSAZdaz_1  := nSAZdan_1
  (cHp) ->nZAKLdaz_1 := nZAKLdan_1
  (cHp) ->nSAZdaz_2  := nSAZdan_2
  (cHp) ->nZAKLdaz_2 := nZAKLdan_2
  (cHp) ->nSAZdaz_3  := nSAZdan_3
  (cHp) ->nZAKLdaz_3 := nZAKLdan_3

  (cHp) ->nHODNslev   := .nHODNslev
  (cHp) ->nPARzahFAK  := .nPARzahFAK
  (cHp) ->nPARzalFAK  := .nPARzahFAK * nKOe

  (cHp) ->nCENzahCEL  := MH_roundnumb(.nCENzdan_1 + .nCENzdan_2 + .nCENzdan_3 + .nOSVodDAN, nKODzaokr);
                           +(cHp) ->nPARzahFAK

  if (cHp) ->cZKRATmeny == (cHp) ->cZKRATmenz
    (cHp) ->nCENzakCEL := (cHp) ->nCENzahCEL
  else
    (cHp) ->nCENzakCEL  := MH_roundnumb(((cHp) ->nOsvOdDan  + ;
                              (cHp) ->nZaklDan_1 +(cHp) ->nSazDan_1 + ;
                              (cHp) ->nZaklDan_2 +(cHp) ->nSazDan_2 + ;
                              (cHp) ->nZaklDan_3 +(cHp) ->nSazDan_3 ), nKODzaokr) ;
                             +(cHp) ->nPARzalFAK
  endif


  (cHp) ->nCENdanCel  := (cHp) ->nOsvOdDan  + ;
                         (cHp) ->nZaklDan_1 +(cHp) ->nZaklDan_2 +(cHp) ->nZaklDan_3 + ;
                         (cHp) ->nZAKLdar_1 +(cHp) ->nZAKLdar_2 +(cHp) ->nZAKLdar_3

  (cHp) ->nZUSTpozao  := (cHp) ->nCENzakCEL - ;
                         ( .nCENzakcel + (cHp) ->nSAZdan_1 +(cHp) ->nSAZdan_2 +(cHp) ->nSAZdan_3 + ;
                                                 nSAZdan_1 +        nSAZdan_2 +        nSAZdan_3   )

  C_DPH ->( AdsSetOrder( nOrdNO))
  (cIp) ->( dbGOTO(nRECNo))

  * musíme doplnit o ØV z párovaných záloh, jinak to vlítne do rozdílu u nsazba_Dph
  * musíme zahrnout do SUM.daz jen ty položky které jsou v fakVysitW
  * jinak by se tam dostali i ty které si jen prohlížel, ale nepøevzal

  if select('vykdph_pw') <> 0
    vykdph_pw->(dbclearFilter(), dbGoTop())

    do while .not. vykdph_pw->(eof())
      if (cIp)->( dbseek( vykDph_pW->ncisFak,,'FAKVYSIT_2'))

        typ_dph := vykdph_pw->ntyp_dph

        if (typ_dph = 1 .or. typ_dph = 2 .or. typ_dph = 3) .and. (cIp)->_delrec <> '9'
          if     typ_dph = 1
            (cHp) ->nZAKLdaz_1 += vykdph_pw->nzakld_Dph
            (cHp) ->nSAZdaz_1  += vykdph_pw->nsazba_Dph
          elseif typ_dph = 2
            (cHp) ->nZAKLdaz_2 += vykdph_pw->nzakld_Dph
            (cHp) ->nSAZdaz_2  += vykdph_pw->nsazba_Dph
          elseif typ_dph = 3
            (cHp) ->nZAKLdaz_3 += vykdph_pw->nzakld_Dph
            (cHp) ->nSAZdaz_3  += vykdph_pw->nsazba_Dph
          endif

          if( typ_dph = 1 .or. typ_dph = 2 .or. typ_dph = 3, axcm[typ_dph,2] += vykdph_pw->nsazba_dph, nil)
        endif
      else
        vykdph_pw->(dbDelete())
      endif

      vykdph_pw->(dbSkip())
    enddo
  endif
  *
  axcm[1,1] := (chp)->nSAZdan_1 +(chp)->nSAZdaz_1
  axcm[2,1] := (chp)->nSAZdan_2 +(chp)->nSAZdaz_2
  axcm[3,1] := (chp)->nSAZdan_3 +(chp)->nSAZdaz_3

  for x := 1 to len(axcm) step 1
    if (roz_dph := (axcm[x,1] -axcm[x,2])) <> 0
      vykdph_iw->(dbgoto(axcm[x,3]))
      vykdph_iw->nsazba_dph += roz_dph
    endif
  next

  (cIp) ->( dbGOTO(nRECNo))
return nil


static function ap_comphd(cHp)
  local nKOEdanf_1, nKOEdanf_2, nKOEdanf_3
  local cSAZdanf_1, cSAZdanf_2, cSAZdanf_3

  if nroundDph = 0
    cSAZdanf_1 := str( ( .nZAKLdan_1 / 100) * nPROCdan_1 )
    cSAZdanf_2 := str( ( .nZAKLdan_2 / 100) * nPROCdan_2 )
    cSAZdanf_3 := str( ( .nZAKLdan_3 / 100) * nPROCdan_3 )

***** 18.12.2020 * 20.1.2021
    if nisITzaokr = 1
      nSAZdanf_1 := .nsazDan_1
      nSAZdanf_2 := .nsazDan_2
      nSAZdanf_3 := .nsazDan_3
    else
      nSAZdanf_1 :=  val( subStr( cSAZdanf_1, 1, at( '.', cSAZdanf_1) +2 ))
      nSAZdanf_2 :=  val( subStr( cSAZdanf_2, 1, at( '.', cSAZdanf_2) +2 ))
      nSAZdanf_3 :=  val( subStr( cSAZdanf_3, 1, at( '.', cSAZdanf_3) +2 ))
    endif
*****

  else
    nSAZdanf_1 := MH_roundnumb(( .nZAKLdan_1 / 100) * nPROCdan_1, nRoundDPH )
    nSAZdanf_2 := MH_roundnumb(( .nZAKLdan_2 / 100) * nPROCdan_2, nRoundDPH )
    nSAZdanf_3 := MH_roundnumb(( .nZAKLdan_3 / 100) * nPROCdan_3, nRoundDPH )
  endif

  (cHp) ->nSAZdan_1   := MH_roundnumb(nSAZdanf_1  * nKOe, nRoundDPH )           //nKODzaokr)
  (cHp) ->nZAKLdan_1  := .nZAKLdan_1 * nKOe
  (cHp) ->nSAZdan_2   := MH_roundnumb(nSAZdanf_2  * nKOe, nRoundDPH )           //nKODzaokr)
  (cHp) ->nZAKLdan_2  := .nZAKLdan_2 * nKOe
  (cHp) ->nSAZdan_3   := MH_roundnumb(nSAZdanf_3  * nKOe, nRoundDPH )           //nKODzaokr)
  (cHp) ->nZAKLdan_3  := .nZAKLdan_3 * nKOe

  (cHp) ->nOSVodDAN   := .nOSVodDAN  * nKOe

  .nCENzdan_1         := MH_roundnumb(nSAZdanf_1 + .nZAKLdan_1, nRoundDPH )     // nKODzaokr)
  .nCENzdan_2         := MH_roundnumb(nSAZdanf_2 + .nZAKLdan_2, nRoundDPH )     // nKODzaokr)
  .nCENzdan_3         := MH_roundnumb(nSAZdanf_3 + .nZAKLdan_3, nRoundDPH )     // nKODzaokr)
return nil


static function eu_comphd(cHp, nZAOKR)

  if nroundDph <> 0
    nSAZdanf_1 := MH_roundnumb(ROUND(.nCENzdan_1 * ROUND((nPROCdan_1/(100 +nPROCdan_1)),4),2), nROUNDdph)
    nSAZdanf_2 := MH_roundnumb(ROUND(.nCENzdan_2 * ROUND((nPROCdan_2/(100 +nPROCdan_2)),4),2), nROUNDdph)
    nSAZdanf_3 := MH_roundnumb(ROUND(.nCENzdan_3 * ROUND((nPROCdan_3/(100 +nPROCdan_3)),4),2), nROUNDdph)
  else
    nSAZdanf_1 := ( .nCENzdan_1 - .nZAKLdan_1 )
    nSAZdanf_2 := ( .nCENzdan_2 - .nZAKLdan_2 )
    nSAZdanf_3 := ( .nCENzdan_3 - .nZAKLdan_3 )
  endif

  (cHp) ->nSAZdan_1   := nSAZdanf_1 * nKOe
  (cHp) ->nZAKLdan_1  := (.nCENzdan_1 - nSAZdanf_1) * nKOe
  (cHp) ->nSAZdan_2   := nSAZdanf_2 * nKOe
  (cHp) ->nZAKLdan_2  := (.nCENzdan_2 - nSAZdanf_2) * nKOe
  (cHp) ->nSAZdan_3   := nSAZdanf_3 * nKOe
  (cHp) ->nZAKLdan_3  := (.nCENzdan_3 - nSAZdanf_3) * nKOe

  (cHp) ->nOSVodDAN   := .nOSVodDAN * nKOe
return nil