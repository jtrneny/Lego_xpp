#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "..\FINANCE\FIN_finance.ch"


static  anHD

*
****************** vpoèet na fakprihdw *****************************************
# xTRANSLATE .nOSVodDAN   => anHD\[1 \]
# xTRANSLATE .nZAKLdan_1  => anHD\[2 \]
# xTRANSLATE .nSAZdan_1   => anHD\[3 \]
# xTRANSLATE .nZAKLdan_2  => anHD\[4 \]
# xTRANSLATE .nSAZdan_2   => anHD\[5 \]
# xTRANSLATE .nZAKLdan_3  => anHD\[6 \]
# xTRANSLATE .nSAZdan_3   => anHD\[7 \]
# xTRANSLATE .nHODNslev   => anHD\[8 \]
# xTRANSLATE .nCENzahCEL  => anHD\[9 \]
# xTRANSLATE .nPARzalFAK  => anHD\[10\]
# xTRANSLATE .nPARzahFAK  => anHD\[11\]
# xTRANSLATE .nCENzdan_1  => anHD\[12\]
# xTRANSLATE .nCENzdan_2  => anHD\[13\]
# xTRANSLATE .nCENzdan_3  => anHD\[14\]
# xTRANSLATE .nCENzakcel  => anHD\[15\]



FUNCTION FIN_fakprihd_IT_cpy(oDialog)
  LOCAL  nKy := FAKPRIHD ->nCISFAK, inScope, doklad, cky
  *
  LOCAL  lNEWrec     := If( IsNull(oDialog), .F., oDialog:lNEWrec)
  local  lok_append2 := .f., ncnt_it := 0, nSign := 1

  ** tmp soubory **
  drgDBMS:open('fakpriHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('fakpriITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('PARPRZALw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  If .not. lNEWrec
    mh_COPYFLD('FAKPRIHD','FAKPRIHDw',.t., .t.)

    if .not. (inScope := fakpriit->(dbscope()))
      fakpriit->(AdsSetOrder(1),dbsetscope(SCOPE_BOTH, strzero(fakprihd->ncisfak,10)), DbGoTop() )
    endif

    fakpriit->(dbgotop())
    do while .not. fakpriit->(eof())
      mh_copyFld('fakpriit','fakpriitW',.t.,.t.)
      *
      fakpriitw->_nstate   := 0    // stav pro tree rozpad párovaných záloh DD +/-
      fakpriitw->_nvisible := 0    // 0 - jsou vidìt položky DD, 1 - ne

*      fakvysitW->nfaktm_org := fakvysit->nfaktMnoz
      fakpriit->(dbSkip())
    enddo
    fakpriit->(dbgotop())

    if( .not. inSCope, fakpriit->(dbclearscope()), nil)

    FORDREC( {'PARPRZAL,1'} )
    PARPRZAL ->( DbSetScope(SCOPE_BOTH,nKy)                                   , ;
                 DbGoTop()                                                    , ;
                 DbEval( { || mh_COPYFLD('PARPRZAL', 'PARPRZALw', .t., .t.) }), ;
                 DbClearScope()                                                 )
    FORDREC()
  ELSE
    FAKPRIHDw ->( DbAppend())
    doklad := FIN_RANGE_KEY('FAKPRIHD')[2]

    if isObject(oDialog)                          .and. ;
       oDialog:drgDialog:cargo = drgEVENT_APPEND2 .and. ;
       .not. fakPriHD->(eof())                    .and. ;
       fakPriHd->nparZalFak = 0                   .and. ;
       fakPriHd->nparZahFak = 0

      nSign := isNull( oDialog:drgDialog:cargo_usr, 1)

      oDialog:lok_append2 := lok_append2 := .t.
      mh_copyFld( 'fakPriHD', 'fakPriHDw', .f., .f. )

      ( FAKPRIHDw ->dPORIZFAK  := Date()                          , ;
        FAKPRIHDw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI           , ;
        FAKPRIHDw ->nROK       := uctOBDOBI:FIN:NROK              , ;
        FAKPRIHDw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI           , ;
        FAKPRIHDw ->cOBDOBIDAN := uctOBDOBI:FIN:COBDOBIDAN        , ;
        FAKPRIHDw ->nCISFAK    := doklad                          , ;
        FAKPRIHDw ->cZKRATMENY := SysConfig( 'Finance:cZaklMENA' ), ;
        FAKPRIHDw ->cZKRATMENZ := SysConfig( 'Finance:cZaklMENA' ), ;
        FAKPRIHDw ->dVYSTFAK   := Date()                          , ;
        FAKPRIHDw ->dVYSTFAKDO := Date()                          , ;
        FAKPRIHDw ->nPROCDAN_1 := SeekSazDPH(1)                   , ;
        FAKPRIHDw ->nPROCDAN_2 := SeekSazDPH(2)                   , ;
        FAKPRIHDw ->nPROCDAN_3 := SeekSazDPH(3)                   , ;
        FAKPRIHDw ->nDOKLAD    := doklad                            )
      *
      ** musí se zanulovat
      fakPrihdW ->cdanDoklad := ''
      fakPrihdW ->cvarSym    := ''
      fakPrihdw ->ddatTisk   := ctod('  .  .  ')
      fakPrihdw ->nuhrCelFak := 0
      fakPrihdw ->nuhrCelFaz := 0
      fakPrihdw ->dposUhrFak := ctod('  .  .  ')
      fakPrihdw ->nkurzRozdF := 0
      fakPrihdw ->nparZalFak := 0
      fakPrihdw ->nparZahFak := 0
      fakPrihdw ->dparZalFak := ctod('  .  .  ')
      fakPrihdw ->ddatpriuhr := ctod('  .  .  ')
      fakPrihdw ->npriuhrcel := 0

      * dobropis
      if nSign = -1
        fakPrihdW->nDoklad_DR := fakprihd->ndoklad

        fakPrihdw->ncenZakCel := fakPrihdw->ncenZakCel * nSign
        fakPrihdw->ncenZahCel := fakPrihdw->ncenZahCel * nSign
        fakPrihdw->nosvOdDan  := fakPrihdw->nosvOdDan  * nSign
        fakPrihdw->nzaklDan_1 := fakPrihdw->nzaklDan_1 * nSign
        fakPrihdw->nsazDan_1  := fakPrihdw->nsazDan_1  * nSign
        fakPrihdw->nzaklDan_2 := fakPrihdw->nzaklDan_2 * nSign
        fakPrihdw->nsazDan_2  := fakPrihdw->nsazDan_2  * nSign
        fakPrihdw->nzaklDan_3 := fakPrihdw->nzaklDan_3 * nSign
        fakPrihdw->nsazDan_3  := fakPrihdw->nsazDan_3  * nSign
      endif


      if .not. (inScope := fakpriit->(dbscope()))
        fakpriit->(AdsSetOrder(1),dbsetscope(SCOPE_BOTH, strzero(fakprihd->ncisfak,10)), DbGoTop() )
      endif

      fakpriit->(dbgotop())
      do while .not. fakpriit->(eof())
        mh_copyFld('fakpriit','fakpriitW',.t.,.f.)
        ncnt_it += 1
        *
        fakPriitw->cobdobi    := fakPrihdw->cobdobi
        fakPriitw->nrok       := fakPrihdw->nrok
        fakPriitw->nobdobi    := fakPrihdw->nobdobi
        fakPriitw->ndoklad    := fakPrihdw->ndoklad
        fakPriitw->ncisFak    := fakPrihdw->ncisFak
        fakPriitw->dsplatFak  := fakPrihdw->dsplatFak
        fakPriitw->dvystFak   := fakPrihdw->dvystFak

        * dobropis
        if nSign = -1
          fakPriitW->nfaktMnoz  := fakPriitW->nfaktMnoz * nSign

          * 2 øádek
          fakPriitW->ncecprzbz  := fakPriitW->ncejprkbz  * fakPriitW->nfaktmnoz
          fakPriitW->ncelkslev  := fakPriitW->nhodnslev  * fakPriitW->nfaktmnoz
          fakPriitW->ncecprkbz  := fakPriitW->ncejprkbz  * fakPriitW->nfaktmnoz
          fakPriitW->nsazDan_Z  := fakPriitW->nsazDan_Z  * nSign
          fakPriitW->ncecprkdz  := fakPriitW->ncejprkdz  * fakPriitW->nfaktmnoz

          * 3 øádek
          fakPriitW->ncenZakCel := fakPriitW->ncenZakCel * nSign
          fakPriitW->nsazDan    := fakPriitW->nsazDan    * nSign
          fakPriitW->ncenZakCeD := fakPriitW->ncenZakCeD * nSign
        endif

        *
        fakpriitw->_nstate    := 0    // stav pro tree rozpad párovaných záloh DD +/-
        fakpriitw->_nvisible  := 0    // 0 - jsou vidìt položky DD, 1 - ne
        fakpriit->(dbSkip())
      enddo
      fakpriit->(dbgotop())

      if( .not. inSCope, fakpriit->(dbclearscope()), nil)

    else
      doklad := FIN_RANGE_KEY('FAKPRIHD')[2]

      ( FAKPRIHDw ->cUloha     := "F"                             , ;
        FAKPRIHDw ->dPORIZFAK  := Date()                          , ;
        FAKPRIHDw ->cOBDOBI    := uctOBDOBI:FIN:COBDOBI           , ;
        FAKPRIHDw ->nROK       := uctOBDOBI:FIN:NROK              , ;
        FAKPRIHDw ->nOBDOBI    := uctOBDOBI:FIN:NOBDOBI           , ;
        FAKPRIHDw ->cOBDOBIDAN := uctOBDOBI:FIN:COBDOBIDAN        , ;
        FAKPRIHDw ->nFINTYP    := 1                               , ;
        FAKPRIHDw ->nCISFAK    := doklad                          , ;
        FAKPRIHDw ->cZKRATMENY := SysConfig( 'Finance:cZaklMENA' ), ;
        FAKPRIHDw ->cZKRATMENZ := SysConfig( 'Finance:cZaklMENA' ), ;
        FAKPRIHDw ->dVYSTFAK   := Date()                          , ;
        FAKPRIHDw ->cDENIK     := SysConfig( 'Finance:cDenikFAPR'), ;
        FAKPRIHDw ->cDENIK_puc := SysConfig( 'Finance:cDENIKpuc' ), ;
        FAKPRIHDw ->dVYSTFAKDO := Date()                          , ;
        FAKPRIHDw ->nMNOZPREP  := 1                               , ;
        FAKPRIHDw ->nKURZAHMEN := 1                               , ;
        FAKPRIHDw ->nPROCDAN_1 := SeekSazDPH(1)                   , ;
        FAKPRIHDw ->nPROCDAN_2 := SeekSazDPH(2)                   , ;
        FAKPRIHDw ->nPROCDAN_3 := SeekSazDPH(3)                   , ;
        FAKPRIHDw ->nKURZAHMED := 1                               , ;
        FAKPRIHDw ->nMNOZPREP  := 1                               , ;
        FAKPRIHDw ->nMNOZPRED  := 1                               , ;
        FAKPRIHDw ->nDOKLAD    := doklad                            )

        fakprihdw->ctyppohybu  := sysconfig('finance:ctyppohFAP')

      IF( C_BANKUC ->( mh_SEEK( .T., 2, .T.)), Nil, C_BANKUC ->( DBGoTop()) )
      FAKPRIHDw ->cBANK_UCT := C_BANKUC ->cBANK_UCT
    endif
  ENDIF
   *
  fakprihdw->lno_indph := .not. fakprihdw->lno_indph

  *
  ** pro append2, musíme pøevzít RV které použil pro pùvodní doklad
  ** tj. na chvilku strèíme do ndoklad pùvodní, ale pak to musíme vrátit
  **     také pøeèíslovat vykDph_iw.ndoklad
  if lok_append2
    fakpriHdw->ndoklad := fakPrihd->ndoklad
    FIN_vykdph_cpy('FAKPRIHDw')

    FAKPRIHDw ->nDOKLAD  := doklad
    vykDph_iw->( dbgoTop()                                                                 , ;
                 dbeval( { || ( vykDph_iw->ndoklad := doklad, vykDph_iw->nrecVyk := 0 ) } ), ;
                 dbCommit(), dbgoTop()                                                       )
  else
    FIN_vykdph_cpy('FAKPRIHDw')
  endif

  FIN_parzalfak_vykdph_cpy( 'fakprihdw' )
  *
  ** musíme pøi opravì zkotrolovat a pøípandì opravit nsubCount pro vazbu na vykDph_pW
  if .not. lNEWrec
    fakpriitW->( dbgotop())
    do while .not. fakPriitW->( eof())
      if fakPriitW->ncisZalFak <> 0 .and. fakPriitW->ncisloDD <> 0
        cky := strZero(fakPriitW->ncisZalFak,10) + ;
               strZero(fakPriitW->ncisloDD  ,10) + ;
               strZero(fakPriitW->nradVykDph, 3)
        if( vykDph_pW->( dbseek( cky,,'VYKDPH_10')), fakPriitW->nsubCount := isNUll(vykDph_pW->sid,0), nil )
      endif
      fakPriitw->( dbskip())
    enddo
    fakPriitw->( dbgoTop())
  endif

  if( lok_append2 .and. ncnt_it <> 0, fin_nak_ap_modihd( 'fakPriHdw'), nil )
RETURN NIL


*
** uložení závazku v transakci *************************************************
function FIN_fakprihd_IT_wrt_inTrans(oDialog)
  local  lDone := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    if fakPriitW->(eof())

      fakprihdW->nhasItems := 0
      lDone := FIN_fakprihd_wrt(oDialog)
    else

      fakprihdW->nhasItems := 1
      lDone := fin_fakprihd_IT_wrt(odialog)
    endif

    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE
return lDone

*
*  HEAD and ITEMS
** uložení závazku *************************************************************
static function fin_fakprihd_IT_wrt(odialog)
  local  anFai := {}, anDoi := {}, anFaz := {}, anPaz := {}, anObj := {}
  local  uctLikv, mainOk := .t., nrecor, lnewrec := odialog:lnewrec, vykhphOk
  *
  local  nparzalfak := 0, nparzahfak := 0
  *
  **
  if(select('dodzboz') <> 0, nil, drgDBMS:open('dodzboz') )

  fin_fakprihd_IT_puc(FAKPRIHDw ->nFINTYP,'FAKPRIHDw')
  fakpriitw->(AdsSetOrder(0), ;
              dbgotop()     , ;
              dbeval({|| fin_fakprihd_rlo( anFai, anDoi, anFaz, anPaz, anObj) }))

  * spojíme RV položek faktury a párovaných záloh, na FA lze použít víc záloh
  * 19.11.2012
  * musíme do vykDph_iW nakopírovat jen ty položky které jsou v fakVysitW
  * jinak by se tam dostali i ty které si jen prohlížel, ale nepøevzal
  vykdph_pw->(dbclearFilter(), dbgotop())
  do while .not. vykDph_pW->(eof())
    if fakPriitW->( dbseek( vykDph_pW->ncisFak,,'FAKPRIIT_2'))
      mh_copyfld('vykdph_pw','vykdph_iw',.t., .f.)
    endif
    vykDph_pW->(dbskip())
  enddo


*  vykdph_pw->(dbgotop()                                                 , ;
*              dbeval({ || mh_copyfld('vykdph_pw','vykdph_iw',.t., .f.) }) )
*  vykdph_iw->(flock(), dbCommit())

  uctLikv  := UCT_likvidace():new(upper(fakprihdw->culoha) +upper(fakprihdw->ctypdoklad),.T.)
  mainOk   := (mainOk .and. fin_vykdph_rlo('FAKPRIHDw'))

  if .not. lnewrec
    fakPriHd->(dbgoto(fakPriHdw->_nrecor))
    mainOk := (mainOk                       .and.         ;
               fakprihd ->(sx_rlock())      .and.         ;
               fakpriit ->(sx_rlock(anFai)) .and.         ;
               fakprihd ->(sx_rlock(anFaz)) .and.         ;
               parprzal ->(sx_rlock(anPaz)) .and.         ;
               dodlstPit->(sx_rlock(anDoi)) .and.         ;
               objvysit ->(sx_rlock(anObj)) .and.         ;
               ucetpol  ->(sx_rlock(uctLikv:ucetpol_rlo)) )
  else
    mainOk := (mainOk                       .and.         ;
               dodlstPit->(sx_rlock(anDoi)) .and.         ;
               objvysit ->(sx_rlock(anObj))               )
  endif

  if mainOk
    *
    if(fakPrihdw->nprocDan_1 = 0, fakPrihdw->nprocDan_1 := seekSazDPH(1,fakPrihdw->dpovinFak), nil)
    if(fakPrihdw->nprocDan_2 = 0, fakPrihdw->nprocDan_2 := seekSazDPH(2,fakPrihdw->dpovinFak), nil)
    if(fakPrihdw->nprocDan_3 = 0, fakPrihdw->nprocDan_3 := seekSazDPH(3,fakPrihdw->dpovinFak), nil)
    *
    fakprihdw->lno_indph := .not. fakprihdw->lno_indph

    if fakPrihdw->_delrec <> '9'
      if odialog:lnewrec
        fakPrihdw->ndoklad := fakPrihdw->ncisfak
      endif
      *
      *  22.2.2016 pøi opravì faktury pokud byla párovaná se ncenFAK/ FAZ navýšila o párování
      *
      fakPrihdw->ncenfakcel := fakPrihdw->ncenzakcel //  +abs(fakPrihdw->nparzalfak)  ???
      fakPrihdw->ncenfazcel := fakPrihdw->ncenzahcel //  +abs(fakPrihdw->nparzahfak)  ???

      mh_copyFld( 'fakPrihdw', 'fakPrihd', lnewRec, .f. )
      fakPrihd->(dbcommit())
    endif

    fakPriitw->(AdsSetOrder(0),dbgotop())
    fakPriHd->(sx_rlock(anFaz))

    do while .not. fakPriitw->( eof())
      if((nrecor := fakPriitw->_nrecor) = 0, nil, fakPriit->(dbgoto(nrecor)))

      if   fakPriitw->_delrec = '9' .or. fakPrihdw->_delrec = '9'
        if(nrecor = 0, nil, fakPriit->(dbdelete()))
      else
        fin_fakprihd_carKod()

        * pozor otevøela se editace úèetního a daòového období na HD
        fakPriitw->nrok       := fakPrihd->nrok
        fakPriitw->nobdobi    := fakPrihd->nobdobi
        fakPriitw->cobdobi    := fakPrihd->cobdobi

        fakPriitw->czkrTYPfak := fakPrihd->czkrTYPfak
        fakPriitw->ndoklad    := fakPrihd->ndoklad
        fakPriitw->ncisFak    := fakPrihd->ncisFak
        fakPriitw->dvystFak   := fakPrihd->dvystFak
        fakPriitw->czkrProdej := fakPrihd->czkrProdej
        mh_copyfld('fakPriitw','fakPriit',(nrecor=0), .f.)
      endif

      if fakPriitw->_delrec = '9' .and. nrecOr = 0
        * nic nedìláme, jen zkoušel pøidat položku s vazbou a zrušil ji
      else

        if(.not. empty(fakPriitw->nciszalfak) .and. empty(fakpriitw->ncisloDD), fin_fakprihd_par(), ;
          if( .not. empty(fakPriitw->ncislodl), fin_fakprihd_dol(), ;
           if(.not. empty(fakPriitw->ccislobint),   fin_fakprihd_obj(), nil )))
      endif

      fakPriitw->(dbskip())
    enddo

    if(fakprihdw->_delrec = '9')  ;  uctLikv:ucetpol_del()
                                     fin_vykdph_wrt(NIL,.t.,'FAKPRIHD')
                                     fakprihd->(dbdelete())
    else                          ;  fin_vykdph_wrt(NIL,.f.,'FAKPRIHD')
                                     uctLikv:ucetpol_wrt()
    endif
  else
    drgMsg(drgNLS:msg('Nelze modifikovat FAKTURU PØIJATOU, blokováno uživatelem ...'),,odialog)
  endif

  fakPrihd ->(dbunlock(), dbcommit())
   fakPriit ->(dbunlock(), dbcommit())
    parPrzal ->(dbunlock(), dbcommit())
     dodlstPit->(dbunlock(), dbcommit())
      objVysit ->(dbunlock(), dbcommit())
        vykdph_i->(dbunlock(), dbcommit())
         ucetpol ->(dbunlock(), dbcommit())
return mainOk


static function fin_fakprihd_rlo( anFai, anDoi, anFaz, anPaz, anObj)
  local  ncislodl   := fakpriitw->ncislodl , ncountdl := fakpriitw->ncountdl
  local  ncisfak    := fakpriitw->ncisfak
  local  nciszalfak := fakpriitw->nciszalfak
  local  ncispenfak := fakpriitw->ncispenfak
  local  cvyrzak    := fakpriitw->cciszakaz
  local  cobjitem   := fakpriitw->ccislObint, npolobj := fakpriitw->ncislPolob

  aadd(anFai,fakpriitw->_nrecor)

  if     .not. empty(nciszalfak)
    if( .not. empty(fakprihd->(ads_getAof())), fakprihd->(ads_clearAof()), nil )

    if(fakprihd->(dbseek(nciszalfak,,'FPRIHD1')), ;
      (fakpriitw->nrecfaz := fakprihd->(recno()), aadd(anFaz, fakprihd->(recno()))), nil)

    if(parprzal->(dbseek(strZero(ncisfak,10) +strZero(nciszalfak,10),,'FODBHD3')), ;
      (fakpriitw->nrecpar := parprzal->(recno()), aadd(anPaz, parprzal->(recno()))), nil)

    *  položka   fakPriItw - je párovaná záloha s vazbou na daòové doklady
    **           nisParZal = 2
    if(fakpriitw->nisParZal = 2, fin_fakprihd_rvpaz(ncisZalFak), nil)

  elseif .not. empty(ncislodl)
    if(dodlstPit->(dbseek(strzero(ncislodl,10) +strzero(ncountdl,5),,'DODLIT5')), ;
      (fakpriitw->nrecdol := dodlstPit->(recno()), aadd(anDoi, dodlstPit->(recno()))), nil)

  elseif .not. empty(cobjitem)
    if(objvysit ->(dbseek(upper(cobjitem) +strZero(npolobj,5),,'OBJVYSI5')), ;
      (fakpriitw->nrecobj := obvysit ->(recNo()), aadd(anObj, objvysit ->(recNo()))), ;
       fakpriitw->nrecobj := 0 )

  endif
return nil


static function fin_fakprihd_rvpaz(ncisZalFak)
  * pøí zrušení položky zálohy je využit test pøi ukládání RV

  if fakpriitw->_delRec = '9'
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

* položka z fakPrihd - párované zálohy
static function fin_fakprihd_par()
  local recNo := fakPrihd->(recno()), cisFak_Zuc := fakPrihd->ncisfak
  *
  local parZalFak_Org := parZahFak_Org := 0

  fakPrihd->(dbgoto(fakPriitw->nrecfaz))
  parPrzal->(dbgoto(fakPriitw->nrecpar))

  * zrušena párovaná záloha
  if fakPriitw->_delrec = '9'
    fakPrihd->nparZalFak -= parPrzal->nparZalFak
    fakPriHd->nparZahFak -= parPrzal->nparZahFak
    parPrzal->(dbdelete())

    fakPriHd->(dbgoTo( recNo))
    return nil
  endif

  * nová párovaná záloha
  if fakPriitW->nrecPar = 0
    parPrzal->(dbappend())

    parPrzal->ncisFak    := cisFak_Zuc
    parPrzal->norditem   := 1000 +fakPriitW->nintcount
    parPrzal->ctextFakt  := fakprihd->ctextFakt
    parPrzal->ncisZalFak := fakPriHd->ncisFak
    parPrzal->cvarzalfak := fakprihd->cvarsym
    parPrzal->cvarZalFak := fakprihd->cvarsym
    parPrzal->cuctZalFak := fakPriHd->cucet_Uct
    parPrzal->ncenZalFak := fakprihd->ncenZakCel
    parPrzal->ncenZahFak := fakprihd->ncenZahCel
    parPrzal->nuhrZalFak := fakprihd->nuhrcelFak
    parPrzal->nuhrZahFak := fakprihd->nuhrcelFaz
    parPrzal->duhrzalFak := fakprihd->dposUhrFak
    parPrzal->nparZalFak := abs(fakpriitW->ncenZakCeD)
    parPrzal->cucet_pucR := fakprihd->cucet_pucR
    parPrzal->cucet_pucS := fakprihd->cucet_pucS
    parPrZal->nparZahFak := abs(fakpriitW->ncecPrKdz)
    parPrzal->dparZalFak := date()

  * oprava párované zálohy již uloženého dokladu
  else
    parZalFak_Org        := parPrzal->nparZalFak
    parZahFak_Org        := parPrzal->nparZahFak

    parPrzal->nparZalFak += ( abs(fakpriitW->ncenZakCeD) - parZalFak_Org )
    parPrZal->nparZahFak += ( abs(fakpriitW->ncecPrKdz ) - parZahFak_Org )
  endif

  parPrzal->dparZalFak := date()
  fakprihd->nparZalFak += ( parPrzal->nparZalFak - parZalFak_Org)
  fakprihd->nparZahFak += ( parPrZal->nparZahFak - parZahFak_Org)

  fakPrihd->(dbgoto(recNo))
return nil


* položka z dodlstPit
static function fin_fakprihd_dol()
  dodlstPit->(dbgoto(fakPriitw->nrecdol))

  if fakPriitw->_delrec = '9'
    dodlstPit->ncisvysfak := 0
    dodlstPit->nmnoz_fakt -= fakPriitw->nfaktm_org
    dodlstPit->nmnoz_fakv -= fakPriitw->nfaktm_org
  else
    dodlstPit->ncisvysfak := fakPrihd->ncisfak
    dodlstPit->nmnoz_fakt += (fakPriitw->nfaktmnoz -fakPriitw->nfaktm_org)
    dodlstPit->nmnoz_fakv += (fakPriitw->nfaktmnoz -fakPriitw->nfaktm_org)
  endif

  dodlstPit->nstav_fakt := if(dodlstPit->nmnoz_fakt = 0                   , 0, ;
                           if(dodlstPit->nmnoz_fakt = dodlstPit->nfaktMnoz, 2, 1))
  dodlstPit->nstav_fakv := dodlstPit->nstav_fakt
return nil


* položka z objitem
static function fin_fakprihd_obj()

  if fakPriitw->nrecobj <> 0
    objVysit ->(dbgoto(fakPriitw->nrecobj))

    if fakPriitw->_delrec = '9'
      objVysit->ncisvysfak := 0
      objVysit->nmnoz_fakt -= fakPriitw->nfaktm_org
      objVysit->nmnoz_fakv -= fakPriitw->nfaktm_org
      objVysit->nmnozplOdb -= fakPriitw->nfaktm_org

      objVysit->nmnozReODB += fakPriitW->nmnozReODB
    else
      objVysit->ncisvysfak := fakPrihd->ncisfak
      objVysit->nmnoz_fakt += (fakPriitw->nfaktmnoz -fakPriitw->nfaktm_org)
      objVysit->nmnoz_fakv += (fakPriitw->nfaktmnoz -fakPriitw->nfaktm_org)
      objVysit->nmnozplOdb += (fakPriitw->nfaktmnoz -fakPriitw->nfaktm_org)

      if objVysit->nmnozReODB <> 0
        objVysit->nmnozReODB := max( 0, objVysit->nmnozReODB -(fakPriitw->nfaktmnoz -fakPriitw->nfaktm_org))
      endif
    endif

    objVysit->nstav_fakt := if(objVysit->nmnoz_fakt  = 0                      , 0, ;
                            if(objVysit->nmnoz_fakt >= objVysit->nmnozObOdb, 2, 1) )
    objVysit->nstav_fakv := objVysit->nstav_fakt

    * hruško jabkový souèet na hlavièce
    if objVysHd->(dbseek(objVysit->ndoklad,,'OBJHEAD7'))
      if objVysHd->(sx_rlock())
        if fakPriitw->_delrec = '9'
          objVysHd->nmnozplOdb -= fakPriitw->nfaktm_org
        else
          objVysHd->nmnozplOdb += (fakPriitw->nfaktmnoz -fakPriitw->nfaktm_org)
        endif
      endif
      objVysHd->(dbunlock(),dbcommit())
    endif
  endif
return nil


* doplnìní èárového kódu do fakvysit
static function fin_fakprihd_carKod()
  local  cky   := upper(fakPriitw->ccisSklad) +upper(fakPriitw->csklPol)
  *
  local  paKod := {}

  dodzboz->( AdsSetOrder('DODAV9')      , ;
             dbsetscope(SCOPE_BOTH, cky), ;
             DbGoTop()                  , ;
             DbEval( { || aadd( paKod, left(dodzboz->ccarKod,15) ) }, ;
                     { || .not. empty(dodzboz->ccarKod)            }  ), ;
             DbClearScope()                                              )

  if len(paKod) <> 0
    fakPriitw->ccarKod_1 := if( len( paKod) >= 1, paKod[1], '' )
    fakPriitw->ccarKod_2 := if( len( paKod) >= 2, paKod[2], '' )
    fakPriitw->ccarKod_3 := if( len( paKod) >= 3, paKod[3], '' )
  endif
return nil


*  only HEAD
** uložení závazku *************************************************************
static function FIN_fakprihd_wrt(oDialog)
  local  nPARZALFAK, nCISFAK, nRECs
  local  anPaz := {}, lPaz := .t.         //__PÁROVANÉ ZÁLOHY VAZBY   __________
  local  anRvz := {}, lRvz := .t.         //__ØÁDKY vÝKAZU DPH PAR_ZAL__________
  local  anFaz := {}, lFaz := .t.         //__PÁROVANÉ ZÁLOHY HLAVIÈKY__________

  LOCAL  lDONe := .T., zaklMena := SysConfig('Finance:cZaklMENA')
  *
  local  uctLikv

  parprzalw->(flock())
  FIN_fakprihd_IT_puc(FAKPRIHDw ->nFINTYP,'FAKPRIHDw')
  FIN_fakprihd_IT_parprzal(anPaz,anRvz,anFaz)

  uctLikv  := UCT_likvidace():new(upper(fakprihdw->culoha) +upper(fakprihdw->ctypdoklad),.T.)
  *
  lPaz := parprzal->(sx_rlock(anPaz))
  lFaz := fakprihd->(sx_rlock(anFaz))

  If( oDialog:lNEWrec, FAKPRIHD ->(DbAppend()), FAKPRIHD ->( DbGoTo(FAKPRIHDw ->_nRECOR)))


  IF FAKPRIHD ->(sx_RLock())                    .and. ;
     lPaz                                       .and. ;
     lFaz                                       .and. ;
     UCETPOL ->(sx_Rlock(uctLikv:ucetpol_rlo )) .and. ;
     fin_vykdph_rlo('FAKPRIHDw')

    *
    fakprihdw->lno_indph := .not. fakprihdw->lno_indph

    if(fakprihdw->_delrec <> '9', mh_copyfld('FAKPRIHDw', 'FAKPRIHD',, .f.), nil)

    nRECs   := FAKPRIHD ->( RecNo())
    nCISFAK := FAKPRIHD ->nCISFAK
    FAKPRIHD ->nDOKLAD := nCISFAK

    * u bìžných zálohových v tuzemské mìnì editujeme nCENZAHCEL musíme naplnit nCENZAKCEL
    * u celních
    do case
    case( fakprihd->nfinTyp = 2 )
      fakprihd->ncenZakCel := fakprihd->ncenZahCel
    case( fakprihd->nfinTyp = 3 .and. (fakprihd->czkratMenZ = zaklMena))
      fakprihd->ncenZakCel := fakprihd->ncenZahCel
    endcase

    FAKPRIHD ->nCENFAKCEL := FAKPRIHD ->nCENZAKCEL +FAKPRIHD ->nPARZALFAK
    FAKPRIHD ->nCENFAZCEL := FAKPRIHD ->nCENZAHCEL +FAKPRIHD ->nPARZAHFAK
    FAKPRIHD  ->( DbCommit())

    fakprihd->(sx_rlock(anFaz))

    do while .not. parprzalw->(eof())
      parprzal->(dbgoto(parprzalw->_nrecor))
      fakprihd->(dbgoto(parprzalw->nrecfaz))

      if parprzalw->_delrec = '9'
        fakprihd->nparzalfak -= parprzal->nparzalfak
        fakprihd->nparzahfak -= parprzal->nparzahfak
        parprzal->(dbDelete())
      else
        if(parprzalw->nparzahfak <> 0, FIN_fakprihd_IT_puc(5,'parprzalw'), nil)

        fakprihd->nparzalfak += (parprzalw->nparZalFak - parprzal->nparZalFak)
        fakprihd->nparzahfak += (parprzalw->nparZahFak - parprzal->nparZahFak)

        fakprihd->dparZalFak := date()
        mh_COPYFLD('parprzalw','parprzal',(parprzalw->_nrecor = 0), .f.)

        parprzal->ncisFak  := ncisFak
        parprzal->nrecFaZ  := parprzal->nrecPar := 0
      endif
      parprzalw->(dbSkip())
    enddo

    *
    fakprihd->(dbGoTo(nrecs))

    if(fakprihdw->_delrec = '9')  ;  uctLikv:ucetpol_del()
                                     fin_vykdph_wrt(NIL,.t.,'FAKPRIHD')
                                     fakprihd->(dbdelete())
    else                          ;  fin_vykdph_wrt(NIL,.f.,'FAKPRIHD')
                                     uctLikv:ucetpol_wrt()
    endif
  ELSE
    drgMsgBox(drgNLS:msg('Nelze modifikovat FAKTURU vystavenou, blokováno uživatelem !!!'))
    lDONe := .F.
  ENDIF

  fakprihd->(dbunlock(),dbcommit())
    parprzal->(dbunlock(),dbcommit())
     ucetpol->(dbunlock(),dbcommit())
RETURN lDONe


STATIC FUNCTION FIN_fakprihd_IT_puc(nFINTYP,cFILE_ou)
  Local  cKy

  DEFAULT nFINTYP TO FAKPRIHDw ->nFINTYP
  drgDBMS:open('C_PODRUC')

  IF(nFINTYP = 4 .or. nFINTYP = 5)               // FAKPZAH, FAKPZAHZAL //
    cKy := StrZero(FAKPRIHDw ->nCISFIRMY,5) +Upper(FAKPRIHDw ->cZKRATMENZ)

    IF C_PODRUC ->(DbSeek(cKy,,'C_PODR2'))               // FIRMY->C_MENY->C_PODRUC
    ELSE
      cKy := Upper(FAKPRIHDw ->cZKRATMENZ)
      IF C_PODRUC ->(DbSeek(cKy,,'C_PODR1'))             // C_MENY->C_PODRUC
      ELSE
        cKy := '00000' +'   '
        IF C_PODRUC ->(DbSeek(cKy,,'C_PODR2'))           // ZAKLADNI
        ENDIF
      ENDIF
    ENDIF

    IF(nFINTYP = 4)                              // FAKPZAH
      (cFILE_ou) ->cUCET_pucR := C_PODRUC ->cUCTZ_puh
      (cFILE_ou) ->cUCET_pucS := C_PODRUC ->cUCTZ_puhS
    ELSE
      (cFILE_ou) ->cUCET_pucR := C_PODRUC ->cUCTZ_puz
      (cFILE_ou) ->cUCET_pucS := C_PODRUC ->cUCTZ_puzS
    ENDIF
  ENDIF
RETURN NIL

*
**                                    parprzal, vykdph_i, fakprihd
static function FIN_fakprihd_IT_parprzal(anPaz   ,anRvz    ,anFaz)
  local  filter, cisZalFak

  parprzalw->(AdsSetOrder(0), dbGoTop())

  do while .not. parprzalw->(eof())
    vykdph_pw->(dbgotop())
    cisZalFak := parprzalw->nciszalfak

    if parprzalw->_delrec = '9'
      if parprzalw->_nrecor = 0
         parprzalw->(dbDelete())

         vykdph_pw->(dbEval({|| vykdph_pw->(dbDelete())}       , ;
                            {|| vykdph_pw->ncisFak = cisZalFak}) )

      else
        aadd(anPaz,parprzalw->_nrecor)

        fakprihd->(dbSeek(cisZalFak,,'FPRIHD1'))
        parprzalw->nrecFaz := fakprihd->(recno())
        aadd(anFaz,fakprihd->(recno()))
        vykdph_pw->(dbEval({|| AAdd(anRvz,vykdph_pw->nrecvyk) }, ;
                           {|| vykdph_pw->ncisFak = cisZalFak})  )


*-        vykdph_pw->(dbEval({|| (aadd(anRvz,vykdph_pw->nrecvyk), vykdph_pw->(dbDelete())) }, ;
*-                           {|| vykdph_pw->ncisFak = cisZalFak}) )

      endif
    else
      aadd(anPaz,parprzalw->_nrecor)

      fakprihd->(dbSeek(cisZalFak,,'FPRIHD1'))
      parprzalw->nrecFaz := fakprihd->(recno())
      aadd(anFaz,fakprihd->(recno()))

      vykdph_pw->(dbEval({|| aadd(anRvz,vykdph_pw->nrecvyk)}, ;
                         {|| vykdph_pw->ncisFak = cisZalFak}) )
    endif

    parprzalw->(dbSkip())
  enddo

  vykdph_pw->(dbgotop()                                                 , ;
              FIN_fakprihd_IT_daz()                                        , ;
              dbeval({ || mh_copyfld('vykdph_pw','vykdph_iw',.t., .f.) }) )
  vykdph_iw->(flock(), dbCommit())
  parprzalw->(dbGoTop())
return nil


*
** zrušení faktury pøijaté
function FIN_fakprihd_IT_del(odialog)
  local  mainOk

  fakprihdw->_delrec := '9'
  fakpriitw->(AdsSetOrder(0),dbgotop(),dbeval({|| fakpriitw->_delrec := '9'}),dbgotop())
  parprzalw->(parprzalw->(AdsSetOrder(0),dbgotop()), dbeval({|| parprzalw->_delrec := '9'}))

  mainOk := FIN_fakprihd_IT_wrt_inTrans(odialog)
return mainOk



static function FIN_fakprihd_IT_daz()
  local  nZAKLdan_1 := nSAZdan_1 := nZAKLdan_2 := nSAZdan_2 := 0

  do while .not. vykdph_pw->(eof())
    do case
    case vykdph_pw->ntyp_dph = 1
      nZAKLdan_1 += vykdph_pw->nZAKLD_dph
      nSAZdan_1  += vykdph_pw->nSAZBA_dph

    case vykdph_pw->ntyp_dph = 2
      nZAKLdan_2 += vykdph_pw->nZAKLD_dph
      nSAZdan_2  += vykdph_pw ->nSAZBA_dph
    endcase

    vykdph_pw->(dbskip())
  enddo

  fakprihdw->nZAKLdaz_1 := nZAKLdan_1
  fakprihdw->nSAZdaz_1  := nSAZdan_1
  fakprihdw->nZAKLdaz_2 := nZAKLdan_2
  fakprihdw->nSAZdaz_2  := nSAZdan_2

  vykdph_pw->(dbgotop())
return nil


*
** pøepoèet hlavièky dokladu fakprihd/dodlstPhd
function fin_nak_ap_modihd(cHp, lis_prodej)
  local  nRECNo, nORDno := C_DPH ->( AdsSetOrder( 1))
  local  cIp  := STRTRAN( upper(cHp), 'HDW', 'ITW')
  local  nZAOKR := 0
  local  nOBJEM := 0, nHMOTNOST := 0
  local  nTYP_v := 1
  local  nVYP_c := VAL( RIGHT( SYSCONFIG('FINANCE:cVYPsazDPH'),1))  // CFG
  local  nVYP_f := 1
//
  local  nZAKLdan_1, nSAZdan_1, nZAKLdan_2, nSAZdan_2,  nZAKLdan_3, nSAZdan_3
  local  nSAZdan_1_noPP := nSAZdan_2_noPP := nSAZdan_3_noPP := 0
  local  typ_dph, axcm := { {0,0,0}, {0,0,0}, {0,0,0} }, x, roz_dph
  *
  ** pokud na položce zmìnil lpreDanPov ... cucetu_dph
  ** musíme modifikovat všechny položky pro nradVykDph
  local   radVykDph := (cIp)->nradVykDph
  local   preDanPov := (cIp)->lpreDanPov
  local   ucetu_Dph := (cIp)->cucetu_Dph

  default lis_prodej to .f.

  if lis_prodej
    nVYP_c := VAL( RIGHT( SYSCONFIG('PRODEJ:cVYPsazDPH'),1))        // CFG
  endif

  vykdph_iw->( dbgotop(), ;
               dbeval( {|| (vykdph_iw->nzakld_dph := 0,vykdph_iw->nsazba_dph := 0, vykdph_iw->nkrace_nar := 0) } ) )

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

  do while !(cIp) ->( EOF())

    // prepocet polozek KURZEM //
*    (cIp) ->nCENAzakl  := (cIp) ->nCeJPrKBZ * nKOe
*    (cIp) ->nCENjedzak := (cIp) ->nCeJPrKBZ * nKOe
*    (cIp) ->nCENjedzad := (cIp) ->nCeJPrKDZ * nKOe
*    (cIp) ->nCENAzakc  := (cIp) ->nCeCPrZBZ * nKOe
*    (cIp) ->nCENzakcel := (cIp) ->nCeCPrKBZ * nKOe
*    (cIp) ->nCENzakced := (cIp) ->nCeCPrKDZ * nKOe
*TS*    (cIp) ->nSAZdan    := (cIp) ->nCENzakced - (cIp) ->nCENzakcel

   * pro stejné RV musí být tyto promìnné shodné
   if (cIp)->nradVykDph = radVykDph
      (cIp)->lpreDanPov := preDanPov
      (cIp)->cucetu_Dph := ucetu_Dph
    endif

    if (cIp)->ncisloDD = 0

      * nápoèet rv-dph pro bìžnou položku, vylouèíme párované zálohy
      if (cIp)->nisParZal <> 2
        if vykdph_iw->(dbseek((cip)->nradvykdph,,'VYKDPH_5'))
          vykdph_iw->nzakld_dph += (cip)->ncenzakcel
          vykdph_iw->nsazba_dph += (cip)->nsazdan
          vykdph_iw->nkrace_nar += (cip)->nkrace_nar

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
          .nOSVodDAN  += (cIp) ->ncenZakCel
        endif

      case ( C_DPH ->nNapocet == 1 ) ; .nZAKLdan_1    += (cIp) ->nCENzakCEL
                                       .nSAZdan_1     += (cIp) ->nSAZdan
                                       nSAZdan_1_noPP += if( (cIp)->lpreDanPov, 0,(cIp) ->nSAZdan )

      case ( C_DPH ->nNapocet == 2 ) ; .nZAKLdan_2    += (cIp) ->nCENzakCEL
                                       .nSAZdan_2     += (cIp) ->nSAZdan
                                       nSAZdan_2_noPP += if( (cIp)->lpreDanPov, 0,(cIp) ->nSAZdan )

      case ( C_DPH ->nNapocet == 3 ) ; .nZAKLdan_3    += (cIp) ->nCENzakCEL
                                       .nSAZdan_3     += (cIp) ->nSAZdan
                                       nSAZdan_3_noPP += if( (cIp)->lpreDanPov, 0,(cIp) ->nSAZdan )

      endcase

      nOBJEM      += (cIp) ->nOBJEM
      nHMOTNOST   += (cIp) ->nHMOTNOST
      .nCENzahCEL += (cIp) ->nCeCPrKDZ
      .nHODNslev  += (cIp) ->nCELKslev
      .nCENzakcel += (cIp) ->nCENzakcel
    endif

    (cIp) ->( dbSKIP())
  enddo

* FAV  (cHp) ->nOBJEM     :=  nOBJEM
* FAV  (cHp) ->nHMOTNOST  :=  nHMOTNOST

  do case
  case( nVYP_f <> 0 )  ;  nTYP_v := nVYP_f
  case( nVYP_c <> 0 )  ;  nTYP_v := nVYP_c
  otherwise
* FAV    nTYP_v := If((cHp) ->dPOVINfak >= CTOD('01.05.04'), 2, 1 )
    nTYP_v := If((cHp) ->dvystFak >= CTOD('01.05.04'), 2, 1 )
  endcase

/*
  if nTYP_v == 2                                             //NEw od 1.5.2004
    .nOSVoddan  := MH_roundnumb( .nOSVoddan , nKODzaokr)
    .nCENzdan_1 := MH_roundnumb( .nCENzdan_1, nKODzaokr)
    .nCENzdan_2 := MH_roundnumb( .nCENzdan_2, nKODzaokr)

    EU_comphd(cHp, nZAOKR)
  else

    AP_comphd(cHp)
  endif
*/

  *
  (cHp) ->nOSVodDAN   := .nOSVodDAN  // * nKOe
  (cHp) ->nZAKLdan_1  := .nZAKLdan_1 // * nKOe
  (cHp) ->nSAZdan_1   := .nSAZdan_1  // * nKOe
  (cHp) ->nZAKLdan_2  := .nZAKLdan_2 // * nKOe
  (cHp) ->nSAZdan_2   := .nSAZdan_2  // * nKOe
  (cHp) ->nZAKLdan_3  := .nZAKLdan_3 // * nKOe
  (cHp) ->nSAZdan_3   := .nSAZdan_3  // * nKOe

  (cHp) ->nSAZdaz_1   := nSAZdan_1
  (cHp) ->nZAKLdaz_1  := nZAKLdan_1
  (cHp) ->nSAZdaz_2   := nSAZdan_2
  (cHp) ->nZAKLdaz_2  := nZAKLdan_2
  (cHp) ->nSAZdaz_3   := nSAZdan_3
  (cHp) ->nZAKLdaz_3  := nZAKLdan_3

* FAV  (cHp) ->nHODNslev   := .nHODNslev
  (cHp) ->nPARzahFAK  := abs(.nPARzahFAK)
  (cHp) ->nPARzalFAK  := abs(.nPARzahFAK) * nKOe


*  (cHp) ->nCENzahCEL  := MH_roundnumb(.nCENzdan_1 + .nCENzdan_2 + .nOSVodDAN, nKODzaokr);
*                           +(cHp) ->nPARzahFAK

*  if (cHp) ->cZKRATmeny == (cHp) ->cZKRATmenz
*    (cHp) ->nCENzakCEL := (cHp) ->nCENzahCEL
*  else
*    (cHp) ->nCENzakCEL  := MH_roundnumb(((cHp) ->nOsvOdDan  + ;
*                              (cHp) ->nZaklDan_1 +(cHp) ->nSazDan_1 + ;
*                              (cHp) ->nZaklDan_2 +(cHp) ->nSazDan_2), nKODzaokr) ;
*                             +(cHp) ->nPARzalFAK
*  endif

* FAV  (cHp) ->nCENdanCel  := (cHp) ->nOsvOdDan  + ;
*                         (cHp) ->nZaklDan_1 +(cHp) ->nZaklDan_2 + ;
*                         (cHp) ->nZAKLdar_1 +(cHp) ->nZAKLdar_2

  (cHp) ->nZUSTpozao  := (cHp) ->nCENzakCEL - ;
                         ( .nCENzakcel +nSAZdan_1_noPP +nSAZdan_2_noPP +nSAZdan_3_noPP )

  (cHp) ->_nsumCen    := .nCENzakcel
  (cHp) ->_nsumDph    := (nSAZdan_1_noPP +nSAZdan_2_noPP +nSAZdan_3_noPP)
  (cHp) ->_nrozDok    := (cHp) ->nZUSTpozao

  C_DPH ->( AdsSetOrder( nOrdNO))
  (cIp) ->( dbGOTO(nRECNo))

  * musíme doplnit o ØV z párovaných záloh, jinak to vlítne do rozdílu u nsazba_Dph
  * musíme zahrnout do SUM.daz jen ty položky které jsou v fakPritW
  * jinak by se tam dostali i ty které si jen prohlížel, ale nepøevzal

  if select('vykdph_pw') <> 0
    vykdph_pw->(dbclearFilter(), dbGoTop())

    do while .not. vykdph_pw->(eof())
      if (cIp)->( dbseek( vykDph_pW->ncisFak,,'FAKPRIIT_2'))

        typ_dph := vykdph_pw->ntyp_dph

        if ( typ_dph = 1 .or. typ_dph = 2  .or. typ_dph = 3) .and. (cIp)->_delrec <> '9'
          if     typ_dph = 1
            (cHp) ->nZAKLdaz_1 += vykdph_pw->nzakld_Dph
            (cHp) ->nSAZdaz_1  += vykdph_pw->nsazba_Dph
          elseif typ_Dph = 2
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

  nSAZdanf_1 := MH_roundnumb(( .nZAKLdan_1 / 100) * nPROCdan_1, nRoundDPH )
  nSAZdanf_2 := MH_roundnumb(( .nZAKLdan_2 / 100) * nPROCdan_2, nRoundDPH )
  nSAZdanf_3 := MH_roundnumb(( .nZAKLdan_3 / 100) * nPROCdan_3, nRoundDPH )

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

  nSAZdanf_1 := ;
    MH_roundnumb(ROUND(.nCENzdan_1 * ROUND((nPROCdan_1/(100 +nPROCdan_1)),4),2), nROUNDdph)

  nSAZdanf_2 := ;
    MH_roundnumb(ROUND(.nCENzdan_2 * ROUND((nPROCdan_2/(100 +nPROCdan_2)),4),2), nROUNDdph)

  nSAZdanf_3 := ;
    MH_roundnumb(ROUND(.nCENzdan_3 * ROUND((nPROCdan_3/(100 +nPROCdan_3)),4),2), nROUNDdph)

  (cHp) ->nSAZdan_1   := nSAZdanf_1 * nKOe
  (cHp) ->nZAKLdan_1  := (.nCENzdan_1 - nSAZdanf_1) * nKOe
  (cHp) ->nSAZdan_2   := nSAZdanf_2 * nKOe
  (cHp) ->nZAKLdan_2  := (.nCENzdan_2 - nSAZdanf_2) * nKOe
  (cHp) ->nSAZdan_3   := nSAZdanf_3 * nKOe
  (cHp) ->nZAKLdan_3  := (.nCENzdan_3 - nSAZdanf_3) * nKOe

  (cHp) ->nOSVodDAN   := .nOSVodDAN * nKOe
return nil