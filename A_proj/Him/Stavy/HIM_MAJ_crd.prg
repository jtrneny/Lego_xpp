/*==============================================================================
  HIM_MAJ_scr.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "adsdbe.ch"
#include "..\HIM\HIM_Him.ch"

*
*===============================================================================
FUNCTION HIM_MAJ_INFO( oDlg)
  LOCAL oDialog, cFile := IF( oDlg:Udcp:isHim, 'MAJ', 'MAJZ')
  LOCAL cTitle := 'Karta investièního majetku '
  LOCAL nArea := Select(), cTag := OrdSetFocus(), nRecNO := RecNO()

  IF (cFile)->nInvCis = 0
    drgMsgBox(drgNLS:msg( cTitle + 'není k dispozici ...' ))
    RETURN NIL
  ENDIF
  *
  DRGDIALOG FORM 'HIM_MAJ_CRD' PARENT oDlg CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg( cTitle + ' - INFO') MODAL DESTROY
  dbSelectArea( nArea)
  IF( cTag <> '' , ( nArea)->( AdsSetOrder( cTag)), NIL )
  IF( nRecNO <> 0, ( nArea)->( dbGoTO( nRecNO))   , NIL )
RETURN NIL

********************************************************************************
*
********************************************************************************
CLASS HIM_MAJ_CRD FROM drgUsrClass
EXPORTED:
  VAR     parent
  VAR     lNewREC, fiMAJ, fiMAJ_ps, fiMAJw, fiMAJww, fiZMAJU, fiZMAJUw, cTASK, isHIM
  VAR     cAktOBD, nAktOBD, nAktROK
  VAR     lZmenyN, lRocniUZV
  VAR     lEditOdpis
  VAR     nZustCenaU, nZustCenaD
  VAR     cTextDobaD
  * jen ZVI
  VAR     nUcetSkup

  METHOD  Init, drgDialogInit
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  PreValidate, PostValidate, OnSave
  METHOD  comboBoxInit
  METHOD  Destroy, C_TypPoh_sel, KategZvi_sel
  *

HIDDEN
  VAR     dm, dc, df, majMembers
  VAR     cLAST_obd, nLAST_obd, nLAST_rok
  var     fiRokUZV

  METHOD  modiCARD, DanOdpis, RokDO, isObdOK
  METHOD  TpvMAJ_modi, ZMajN_IM, genUO_PLNY
  *
  ** inovace pøi opravì majetku
  ** pokud cobdZar = uctOBDOBI_LAST:&(::ctask):cobdobi a najde
  ** v ZMAJU   ( ctypPohybu =  '31' .or. ctypPohybu =  '37' )
  ** v ZMAJUZ  ( ctypPohybu = '131' .or. ctypPohybu = '137' )
  *
  *  zablokuje nCenaPorU, nCenaPorD, nDotaceUct, nDotaceDan, nOprUct, nOprDan
  *
  inline method can_edit_ceny()
    local  cf := "cobdobi = '%%' .and. ntypMaj = %% .and. ninvCis = %% .and. (ctypPohybu = '%%' .or. ctypPohybu = '%%')"
    local  filter
    local  isOk, recNo := (::fiZMAJU)->( recNo())

    if (::fiMAJ)->cobdZar = uctOBDOBI_LAST:&(::cTASK):cobdobi

      if ::isHIM
        filter := format( cf, { (::fiMAJ)->cobdZar, (::fiMAJ)->ntypMaj  , (::fiMAJ)->ninvCis, '31        ', '37        ' } )
      else
        cf     := strTran( cf, 'ntypMaj', 'nucetSkup' )
        filter := format( cf, { (::fiMAJ)->cobdZar, (::fiMAJ)->nucetSkup, (::fiMAJ)->ninvCis, '131       ', '137       ' } )
      endif

      (::fiZMAJU)->( ads_setAOF(filter)            , ;
                     dbgoTop()                     , ;
                     isOk := ( isNull( (::fiZMAJU)->sID, 0) = 0), ;
                     ads_clearAOF()                , ;
                     dbgoTo(recNo)                   )

       isEditGet( { ::fiMAJw +'->nCenaPorU' , ;
                    ::fiMAJw +'->nCenaPorD' , ;
                    ::fiMAJw +'->nDotaceUct', ;
                    ::fiMAJw +'->nDotaceDan', ;
                    ::fiMAJw +'->nOprUct'   , ;
                    ::fiMAJw +'->nOprDan'     }, ::drgDialog, isOk )
    endif
  return self

  inline method obdZar_from_datZar(ddatZar)
    local cdatZar := dtoc(ddatZar)
  return subStr( cdatZar,4,2) + '/' + right( cdatZar,2)

  *
  ** kontrola cnazPol1..6 na c_naklSt
  inline method c_naklst_vld()
    local  drgVar_nazPol1 := ::dm:has( ::fiMAJw +'->cnazPol1' )
    local  x, value := '', ok := .f., showDlg := .f.

    drgDBMS:open('c_naklst')

    for x := 1 to 6 step 1
      value += upper(::dm:get( ::fiMAJw +'->cnazPol' +str(x,1)))
    next

    do case
    case empty(value)
      c_naklSt->( dbgoTop())
      ok      := ( isNull(c_naklSt->sID, 0) = 0 )    // nepoužívají nákladovou struktu
      showDlg := .not. ok
    otherwise
      ok      := c_naklSt->(dbseek(value,,'C_NAKLST1'))
      showDlg := .not. ok
    endcase

    if showDlg
      DRGDIALOG FORM 'c_naklst_sel' PARENT ::drgDialog MODAL           ;
                                                       DESTROY         ;
                                                       EXITSTATE nExit ;
                                                       CARGO drgVar_nazPol1

      if nexit != drgEVENT_QUIT .or. ok
         for x := 1 to 6 step 1
           ::dm:set( ::fiMAJw + '->cnazPol' +str(x,1), DBGetVal('c_naklSt->cnazPol' +str(x,1)))
           ::dm:save()
         next
         _clearEventLoop(.t.)
         ok := .t.
       else
        ::df:setNextFocus( ::fiMAJw +'->cnazPol1',,.t.)
      endif
    endif
  return ok
ENDCLASS


********************************************************************************
METHOD HIM_MAJ_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::parent   := parent:drgDialog
  *
  ::isHIM    := parent:parent:UDCP:isHIM
  ::fiMAJ    := IF( ::isHIM, 'MAJ'   , 'MAJZ'    )
  ::fiMAJ_ps := IF( ::isHIM, 'MAJ_PS', 'MAJZ_PS' )
  ::fiRokUZV := IF( ::isHIM, 'RokUZV', 'RokUZVZ' )
  *
  ::fiMAJw   := ::fiMAJ + 'w'
  ::fiMAJww  := ::fiMAJ + 'ww'
  ::cTASK    := IF( ::isHIM, 'HIM', 'ZVI')
  ::fiZMAJU  := IF( ::isHIM, 'ZMAJU' , 'ZMAJUZ')
  ::fiZMAJUw := ::fiZMAJU + 'w'
  *
  ::lNewREC := !( parent:cargo = drgEVENT_EDIT)
  ::lZmenyN := ( !::lNewRec .and. !Empty( (::fiMAJ)->cObdPosOdp) )
  ::lEditOdpis := SysConfig( IF( ::isHIM, 'IM', 'ZVIRATA') + ':lEditOdpis' )

  ::cAktOBD    := uctOBDOBI:&(::cTask):cObdobi
  ::nAktOBD    := uctOBDOBI:&(::cTask):nObdobi
  ::nAktROK    := uctOBDOBI:&(::cTask):nROK
  *
  ::cLAST_obd  := uctOBDOBI_LAST:&(::cTask):cObdobi
  ::nLAST_obd  := uctOBDOBI_LAST:&(::cTask):nObdobi
  ::nLAST_rok  := uctOBDOBI_LAST:&(::cTask):nROK
  *
  ::nUcetSkup  := 1    // bude se brát ze souboru KATEGZVI po validaci kategorie
  *
  drgDBMS:open( ::fiMAJ_ps )
  drgDBMS:open( ::fiRokUZV )
  drgDBMS:open('UcetSYS'   )
  drgDBMS:open('UcetPOL'   )
  drgDBMS:open('C_Aktiv'   )
  drgDBMS:open('C_AktivD'  )
  drgDBMS:open('C_DanSkp'  )
  drgDBMS:open('C_TYPPOH'  )
  drgDBMS:open( ::fiMAJw ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open( ::fiMAJww,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  *
  IF ::lNewREC
     C_TypPoh->( dbGoTo(0))
    (::fiMAJw)->(dbAppend())
     mh_COPYFLD( ::fiMAJw, ::fiMAJww , .T.)
    (::fiMAJw)->nTypDOdpi  := DO_ROVNOMERNY
    (::fiMAJw)->nTypUOdpi  := UO_ROVNOMERNY
    (::fiMAJw)->nTypVypUO  := UO_VYPOCET_ZKRACENY
    (::fiMAJw)->nUplProc   := 0
    (::fiMAJw)->nDoklad    := HIM_NewDoklad( ::cTASK)
    (::fiMAJw)->nZnAktD    := AKTIVNI                        //newD
    (::fiMAJw)->nZnAkt     := AKTIVNI
    (::fiMAJw)->nKusy      := 1
    (::fiMAJw)->lHmotnyIM  := .T.
    ::cTextDobaD           := 'Roky odpisu'
    (::fiMAJw)->nZpuOdpis  := 1                              // dle zákona
    *
    ::nZustCenaU := 0
    ::nZustCenaD := 0
    *
  ELSE
    mh_COPYFLD( ::fiMAJ , ::fiMAJw , .T.)
    mh_COPYFLD( ::fiMAJw, ::fiMAJww, .T.)
    ::nZustCenaU := (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct
    ::nZustCenaD := (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDan
    *
    c_DanSkp->( dbSeek( Upper( (::fiMAJ)->cOdpiSkD),,'C_DANSKP1'))
    ::cTextDobaD := IF( c_DanSkp->cMjCas = 'R', 'Roky odpisu', 'Mìsíce odpisu' )
    C_TypPoh->( dbSeek( IF( ::isHIM, 'I', 'Z') + Upper((::fiMAJ)->cTypPohybu),, 'C_TYPPOH06' ))
  ENDIF
RETURN self

********************************************************************************
METHOD HIM_MAJ_CRD:drgDialogInit(drgDialog)
  Local title := IF( ::isHIM, 'Karta investièního majetku', 'Karta zvíøete' )
  Local cFilter

  drgDialog:formHeader:title := title + ' ...'
  drgDialog:formHeader:File  := ::fiMAJw
  *
  IF ::isHIM
    cFilter := FORMAT("lHmotnyIM = %%",{ .t. } )
    C_DanSkp->( mh_SetFILTER( cFilter))
  ELSE
    cFilter := "Val(Right(alltrim(ctypdoklad),3)) > 0 .and. Val(Right(alltrim(ctypdoklad),3)) < 400"
    C_TypPoh->( dbSetFilter( COMPILE( cFilter)), dbGotop())
  ENDIF

RETURN self

********************************************************************************
METHOD HIM_MAJ_CRD:drgDialogStart(drgDialog)

  ::dm        := ::drgDialog:dataManager
  ::dc        := ::drgDialog:dialogCtrl
  ::df        := ::drgDialog:oForm
  ::lRocniUZV := HIM_isRocniUZV( ::nAktROK, IF( ::isHIM, 'DMAJ', 'DMAJZ'))
  *
  IF( 'INFO' $ UPPER( drgDialog:title), drgDialog:SetReadOnly( .T.), NIL )
  *
  ::modiCARD()
  ::dm:has( ::fiMAJw +  if( c_DanSkp->cMjCas = 'R', '->nMesOdpiD', '->nRokyOdpiD')):odrg:oXbp:hide()


  IsEditGET( { ::fiMAJw + '->nInvCis'      ,;
               ::fiMAJw + '->ddatZar'      ,;
               ::fiMAJw + '->cObdZar' }    , drgDialog, ::lNewREC  )

  IsEditGET( {'M->nZustCenaU'          ,;
              'M->nZustCenaD'          ,;
              ::fiMAJw + '->nCenaVstU' ,;
              ::fiMAJw + '->nCenaVstD' ,;
              ::fiMAJw + '->nRokyOdpiD',;
              ::fiMAJw + '->nMesOdpiD' ,;
              ::fiMAJw + '->nRokyOdpiU',;
              ::fiMAJw + '->nUplHodn'  ,;
              ::fiMAJw + '->cObdZar'    }  , drgDialog, .F. )

  IsEditGET( { ::fiMAJw + '->nProcDanOd'   ,;
               ::fiMAJw + '->nDanOdpRok'   ,;
               ::fiMAJw + '->nProcUctOd'   ,;
               ::fiMAJw + '->nUctOdpRok'   ,;                   //w->nUctOdpRok
               ::fiMAJw + '->nUctOdpMes'}  , drgDialog, ::lEditOdpis )

  IsEditGET( { ::fiMAJw + '->nUplProc' }, drgDialog, ( (::fiMAJ)->nRokUpl = ::nAktROK ) .OR. ::lNewREC .OR.;
                                                       YEAR( (::fiMAJ)->dDatZAR) = ::nAktROK   )
  IsEditGET( { ::fiMAJw + '->nDoklad' } , drgDialog, ::lNewREC  )
  IsEditGET( { ::fiMAJw + '->lHmotnyIM'}, drgDialog, ::isHIM .and. ::lNewREC  )

  IF !::lNewREC
    ::df:setNextFocus( ::fiMAJw + '->cNazev',, .t. )
    *
    C_DanSkp->( mh_ClrFILTER())
    cFilter := FORMAT("lHmotnyIM = %%",{ ( ::fiMAJw)->lHmotnyIM } )
    C_DanSkp->( mh_SetFILTER( cFilter), dbGoBottom() )

    ::can_edit_ceny()
  ENDIF
RETURN self

********************************************************************************
METHOD HIM_MAJ_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

*  CASE  nEvent = drgEVENT_SAVE
*     PostAppEvent(xbeP_Close,drgEVENT_EXIT,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD HIM_MAJ_CRD:PreValidate(oVar)
  LOCAL lOK := .T.
  LOCAL Name := oVar:Name, cField := Lower(drgParseSecond( Name, '>')), cFilter
  *
  Do Case
    Case cField $ 'codpiskd'
      C_DanSkp->( mh_ClrFILTER())
      cFilter := FORMAT("lHmotnyIM = %%",{ ::dm:get( ::fiMAJw + '->lHmotnyIM') } )
      C_DanSkp->( mh_SetFILTER( cFilter), dbGoBottom())
  EndCase
RETURN lOK

********************************************************************************
METHOD HIM_MAJ_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T., lReCompute := .F., lRocniUZV
  LOCAL  lValid := ( ::lNewREC .or. lChanged ), lHmotnyIM
  LOCAL  cNAMe := UPPER(oVar:name), cField := Lower(drgParseSecond( cName, '>'))
  LOCAL  nUplProc, nRec, cMsg, cKEY
  Local  nAktMes, nPocetMes, nOdpiSK, cOdpiSk, nOdpiSkD, cOdpiSkD, nTypDOdpi, nTypUOdpi, nTypVypUO, cObdZar
  Local  nPocetDO, nDORok, nUORok, nUOMes, nZCD, nZCU
  Local  nCenaVstU, nCenaVstD, nOprUct, nOprDan, nCenaPorU, nCenaPorD
  Local  nRoPrvni, nRoDalsi, nRoZvCena, nProcRDO, cMJcAS
  Local  nRoundAlgor := IF( ::isHIM , SysConfig( 'Im:nRoundOdpi'  ),;
                                      SysConfig( 'Zvirata:nRoundOdpi') )
  *
  local  obdZar, nzavren_MAJ, nzavren_UCT
  local  ddatZar

  nEvent     := LastAppEvent(@mp1,@mp2)
  lHmotnyIM  := ::dm:get( ::fiMAJw + '->lHmotnyIM' )
  nCenaPorU  := ::dm:get( ::fiMAJw + '->nCenaPorU' )  // cena vèetnì dotací
  nCenaPorD  := ::dm:get( ::fiMAJw + '->nCenaPorD' )
  nCenaVstU  := ::dm:get( ::fiMAJw + '->nCenaVstU' )  // cena bez dotace
  nCenaVstD  := ::dm:get( ::fiMAJw + '->nCenaVstD' )
  nAktMes    := HIM_AktMes( ::dm:get( ::fiMAJw + '->cObdZAR'), ::cTASK)
  nAktMes    := If( ::lRocniUZV, 0, nAktMes )
  nTypVypUO  := ::dm:get( ::fiMAJw + '->nTypVypUO')
  nPocetMes  := If( nTypVypUO = UO_VYPOCET_PLNY, 13 - nAktMes, 12 - nAktMes )
  *
  ddatZar    := ::dm:get( ::fiMAJw + '->dDatZar')

  DO CASE
  CASE cField $ 'ctyppohybu'
    lOK := IF( lValid, ::C_TypPoh_SEL(), lOK )

  CASE cField $ 'nzvirkat'
    IF lValid
      lOK := ::KategZvi_sel()   // ControlDUE( oVar)
    ENDIF
    if lOK .and. cField = 'nzvirkat'
      ::nUcetSkup := KategZvi->nUcetSkup
    endif

  CASE cField = 'nInvCis'
    IF lValid
      IF( lOK := ControlDUE( oVar) )
        nRec := (::fiMAJ)->( RecNo())
        IF ::isHIM
          cKEY := StrZero( ::dm:get( ::fiMAJw +'->nTypMAJ'),3) + StrZero( xVar, 10)
          IF ( lOK := (::fiMAJ)->( dbSeek( cKEY,,AdsCtag(1))) )
            cMsg := 'DUPLICITA !;; Majetek s tímto inventárním èíslem již existuje !'
            drgMsgBox(drgNLS:msg( cMsg))
          ELSEIF ( lOK := (::fiMAJ)->( dbSeek( xVar,, AdsCtag(2)) ))
            cMsg := 'Majetek s tímto inventárním èíslem již existuje, ALE s jiným typem  !'
            drgMsgBox(drgNLS:msg( cMsg))
            lOK := .F.
          ENDIF
        ELSE
          cKEY := StrZero( ::nUcetSkup,3) + StrZero( xVar, 10)
          IF ( lOK := (::fiMAJ)->( dbSeek( cKEY,, AdsCtag(1))) )
            cMsg := 'DUPLICITA !;; Zvíøe s tímto evidenèním èíslem již existuje !'
            drgMsgBox(drgNLS:msg( cMsg))
          ENDIF
        ENDIF
        (::fiMAJ)->( dbGoTo( nRec))
        lOK := !lOK
        IF( lOK, ::dm:set( ::fiMAJw+'->nInvCis', xVar ), NIL )
      ENDIF
    ENDIF
*
  case cField = 'ddatPor'
    if empty(xVar)
      fin_info_box( 'Datum poøízení majetku je povinný údaj ...', XBPMB_CRITICAL )
      lok := .f.
    endif

  case cField = 'ddatzar'
    do case
    case empty(xVar)
      fin_info_box( 'Datum zaøazení majetku do evidence je povinný údaj ...', XBPMB_CRITICAL )
      lok := .f.

    case (::fiRokUzv)->( dbseek( year(xvar),,'ROKUZV_1')) .and. lValid
      fin_info_box( 'Byla provedena uzávìrka roku [ ' + str(year(xvar)) + ' ] ;' + ;
                    'majetek NELZE zaøadit do uzavøeného roku ...'          , XBPMB_CRITICAL )
      lok := .f.

    otherWise
      obdZar      := ::obdZar_from_datZar(xVar)
      nzavren_MAJ := if( ucetSys->( dbseek( if( ::isHIM, 'I', 'Z')+obdZar,,'UCETSYS2')), if( ucetSys->lzavren, 1, 0), -1 )
      nzavren_UCT := if( ucetSys->( dbseek(                   'U' +obdZar,,'UCETSYS2')), if( ucetSys->lzavren, 1, 0), -1 )

      do case
      case ( nzavren_MAJ = -1 .or. nzavren_UCT = -1 )
        fin_info_box( 'Období [ ' +obdZar + '] pro zaøazení majetku neexistuje ;' + ;
                      'majetek NELZE zaøadit ...'       , XBPMB_CRITICAL )
        lok := .f.
      case ( nzavren_MAJ =  1 .or. nzavren_UCT =  1 )
        fin_info_box( 'Období [ ' +obdZar + '] pro zaøazení majetku je již uzavøeno ;' + ;
                      'majetek NELZE zaøadit do uzavøeného období ...'       , XBPMB_CRITICAL )
        lok := .f.
      otherwise
        ::dm:set( ::fiMAJw + '->cobdZar', obdZar )
      endcase
    endCase
*

  CASE cField = 'lHmotnyIM'
    If lValid
      /*
      ::cTextDobaD := IF( xVar, 'Roky odpisu', 'Mìsíce odpisu')
      ::dm:set( 'M->cTextDobaD', ::cTextDobaD )
      IF xVar
        ::dm:set( ::fiMAJw + '->nMesOdpiD', 0 )
        ::dm:has( ::fiMAJw + '->nMesOdpiD'):odrg:oXbp:hide()
        ::dm:has( ::fiMAJw + '->nRokyOdpiD'):odrg:oXbp:show()
      ELSE
        ::dm:set( ::fiMAJw + '->nRokyOdpiD', 0 )
        ::dm:has( ::fiMAJw + '->nMesOdpiD'):odrg:oXbp:show()
        ::dm:has( ::fiMAJw + '->nRokyOdpiD'):odrg:oXbp:hide()
      ENDIF
      */
      *
      C_DanSkp->( mh_ClrFILTER())
      cFilter := FORMAT("lHmotnyIM = %%",{ xVar } )
      C_DanSkp->( mh_SetFILTER( cFilter), dbGoBottom())
*      drgMsgBox(drgNLS:msg( 'Nutno pøekontrolovat daòovou skupinu !!!'))
      *
    EndIf

  CASE cField = 'ctypczcpa'
    if lValid
      if c_czCpa->( dbSeek( upper(xVar),, AdsCtag(1)))
        if ( c_czCpa->nOdpiSkD > 0 .and. c_czCpa->nOdpiSkD <= 6 )
           ::dm:set( ::fiMAJw +'->cOdpiSkD', c_czCpa->cOdpiSkD )
           (::fiMAJw)->nOdpiSkD := c_czCpa->nOdpiSkD  // ?
         Else
           drgMsgBox(drgNLS:msg( 'K tomuto typu CPA není nastavena daòová skupina !'))
           ::df:setNextFocus( ::fiMAJw +'->nTrObor',, .T. )
           _clearEventLoop(.t.)
         EndIf
       EndIf
    Endif


  CASE cField = 'cTypSKP'
    IF lValid
      IF c_TypSkp->( dbSeek( Upper( xVar),, AdsCtag(1)))
         If (c_TypSkp->nOdpiSkD > 0 .and. c_TypSkp->nOdpiSkD <= 5) .or. c_TypSkp->nOdpiSkD = 7
           ::dm:set( ::fiMAJw +'->cOdpiSkD', c_TypSkp->cOdpiSkD )
           (::fiMAJw)->nOdpiSkD := c_TypSkp->nOdpiSkD  // ?
         Else
           drgMsgBox(drgNLS:msg( 'K tomuto typu SKP není nastavena daòová skupina !'))
           ::df:setNextFocus( ::fiMAJw +'->nTrObor',, .T. )
           _clearEventLoop(.t.)
         EndIf
       EndIf
    Endif
    C_DanSkp->( mh_ClrFILTER())

  CASE cField = 'nCenaPorU'
    IF lValid
      lReCompute := .T.
      IF xVar < 0
        drgMsgBox(drgNLS:msg( 'Poøizovací cena úèetní nesmí být záporná !'))
        lOK := .F.
      ENDIF
      ::dm:set( ::fiMAJw +'->nCenaPortU', xVar )
      nCenaVstU := xVar - ::dm:get( ::fiMAJw +'->nDotaceUct')
      ::dm:set( ::fiMAJw +'->nCenaVstU', nCenaVstU )
      ::dm:set( 'M->nZustCenaU'  , nCenaVstU - ::dm:get( ::fiMAJw +'->nOprUct')  )
    ENDIF

  CASE cField = 'nCenaPorD'
    IF lValid
      lReCompute := .T.
      IF ! ( lOK := xVar >= 0 )
        drgMsgBox(drgNLS:msg( 'Poøizovací cena daòová nesmí být záporná !'))
      ENDIF
      ::dm:set( ::fiMAJw +'->nCenaPorD', xVar )
      nCenaVstD := xVar - ::dm:get( ::fiMAJw +'->nDotaceDan')
      ::dm:set( ::fiMAJw +'->nCenaVstD', nCenaVstD )
      ::dm:set( 'M->nZustCenaD'  , nCenaVstD - ::dm:get( ::fiMAJw +'->nOprDan')  )
      nUplProc := ::dm:get( ::fiMAJw +'->nUplProc')
* js      ::dm:set( ::fiMAJw +'->nUplHodn'  , IF( nUplProc > 0, ( nCenaVstD / 100) * nUplProc, 0 ))

      ::dm:set( ::fiMAJw +'->nUplHodn'  , IF( nUplProc > 0, mh_roundNUMB(( nCenaVstD / 100) *nUplProc, nRoundAlgor), 0) )
    ENDIF

  CASE cField = 'nDotaceUct'
    if lValid
      lReCompute := .T.
      nCenaVstU := nCenaPorU - xVar
      ::dm:set( ::fiMAJw +'->nCenaVstU', nCenaVstU )
      ::dm:set( 'M->nZustCenaU', nCenaVstU - ::dm:get( ::fiMAJw +'->nOprUct') )
*      ::dm:set( ::fiMAJw + '->nUplHodn', PercToVAL( nCenaVstU, ::dm:get( ::fiMAJw + '->nUplProc' )))
    endif
  CASE cField = 'nDotaceDan'
    if lValid
      lReCompute := .T.
      nCenaVstD := nCenaPorD - xVar
      ::dm:set( ::fiMAJw +'->nCenaVstD', nCenaVstD )
      ::dm:set( 'M->nZustCenaD', nCenaVstD - ::dm:get( ::fiMAJw +'->nOprDan') )
      ::dm:set( ::fiMAJw + '->nUplHodn', PercToVAL( nCenaVstD, ::dm:get( ::fiMAJw + '->nUplProc' )))
    endif

  CASE cField = 'nOprUct'
    if lValid
      ::dm:set( 'M->nZustCenaU', nCenaVstU - xVar )
    endif

  CASE cField = 'nOprDan'
    if lValid
      ::dm:set( 'M->nZustCenaD', nCenaVstD - xVar )
    endif

  CASE cField $ 'codpiskd,codpisk'
    IF lValid
      IF( lOK := ControlDUE( oVar) )
        xVar       := AllTrim( xVar)
        lReCompute := .T.

        do case
        case (xVar = '1M' .or. xVar = '2M') // datumZaøazení < 30.6.2010
          lOk := ( dDatZar < CTOD('30.06.2010') )
          if !lOk
            drgMsgBox( 'Majetek s touto daòovou skupinou nelze zaøadit ;         po 30.6.2010' )
            Return .f.
          endif

        case (xVar = '1M1' .or. xVar = '2M2') // datumZarazeni >= 1.1.2020 a <= 31.12.2012
          if .not. ( ddatZar >= ctod( '01.01.20') .and. ddatZar <= ctod( '31.12.21') )
            drgMsgBox( 'Majetek s touto daòovou skupinou lze zaøadit pouze ;           od 1.1.2020 do 31.12.2021' )
            Return .f.
          endif
        endCase


/*
        * 1M a 2M mùže zadat, je-li datum zaøazení < 30.6.2010
        if (xVar = '1M' .or. xVar = '2M' )
          lOk := (  ::dm:get( ::fiMAJw + '->dDatZar' ) < CTOD('30.06.2010'))
          if !lOk
            drgMsgBox(drgNLS:msg( 'Majetek s touto daòovou skupinou nelze zaøadit po 30.6.2010' ))
            Return .f.
          endif
        endif


        lReCompute := .T.
        xVar := AllTrim( xVar)
        IF ( cField = 'codpiskd') .and. ( !lHmotnyIM   .or. xVar = '1M' .or. xVar = '2M' )  // 1M = 7, 2M = 9
          ::dm:set( ::fiMAJw +'->nTypDOdpi'  , 1 )  // D
          ::dm:set( ::fiMAJw +'->nTypUOdpi'  , 1 )  // U
          ::dm:set( ::fiMAJw +'->nUplProc'   , 0 )  // D
          ::dm:set( ::fiMAJw +'->nUplHodn'   , 0 )  // D
//          ::dm:set( ::fiMAJw +'->nRokyOdpiU' , IF( xVar = '1M', 12, IF( xVar = '2M', 24, 0)) )  // U
        ENDIF
*/

        IF cField = 'codpiskd'
          nOdpiSkD := C_DanSkp->nOdpiSkD
          cMJCas   := C_DanSkp->cMJCas

          if ( !lHmotnyIM .or. ascan( { '1M', '2M', '1M1', '2M2' }, xVar ) <> 0 )
            ::dm:set( ::fiMAJw +'->nTypDOdpi'  , 1 )  // D
            ::dm:set( ::fiMAJw +'->nTypUOdpi'  , 1 )  // U
            ::dm:set( ::fiMAJw +'->nUplProc'   , 0 )  // D
            ::dm:set( ::fiMAJw +'->nUplHodn'   , 0 )  // D
            ::dm:set( ::fiMAJw +'->nRokyOdpiU' , c_danSkp->nmesOdpiD/12 )
          endif

          ***NEW_w
          IF cMJCas = 'R'
            ::cTextDobaD := 'Roky odpisu'
            ::dm:set( ::fiMAJw + '->nRokyOdpiD', C_DanSKP->nRokyOdpis)
            ::dm:set( ::fiMAJw + '->nMesOdpiD', 0 )
            ::dm:has( ::fiMAJw + '->nMesOdpiD'):odrg:oXbp:hide()
            ::dm:has( ::fiMAJw + '->nRokyOdpiD'):odrg:oXbp:show()
          ELSE
            ::cTextDobaD := 'Mìsíce odpisu'
            ::dm:set( ::fiMAJw + '->nMesOdpiD', C_DanSKP->nMesOdpiD  )
            ::dm:set( ::fiMAJw + '->nRokyOdpiD', 0 )
            ::dm:has( ::fiMAJw + '->nMesOdpiD'):odrg:oXbp:show()
            ::dm:has( ::fiMAJw + '->nRokyOdpiD'):odrg:oXbp:hide()
            IsEditGET( { ::fiMAJw + '->nProcDanOd' }, ::drgDialog,  .f. )
          ENDIF
          ::dm:set( 'M->cTextDobaD', ::cTextDobaD )
          ***
          ::DanOdpis()
          **
          IF ( nodpiSkD = 4 .or. nodpiSkD = 5 .or. nodpiSkD = 6 .or. nOdpiSkD >= 7 )
            IsEditGET( { ::fiMAJw + '->nUplProc' } , ::drgDialog,  .f. )
          ENDIF

          if ascan( { '1M', '2M', '1M1', '2M2' }, xVar ) <> 0
//          IF nOdpiSkD = 7 .or. nOdpiSkD = 9   // daò.sk. 1M,2M
            IsEditGET( { ::fiMAJw + '->nRokyOdpiD' } , ::drgDialog,  .f. )
            ::DanOdpis( .t.)
          ELSE
            IsEditGET( { ::fiMAJw + '->nRokyOdpiD' } , ::drgDialog, (cMJCas = 'R') )
          ENDIF
        ENDIF
        *
        IF cField = 'codpisk'
          ::dm:set( ::fiMAJw +'->nRokyOdpiU', C_UcetSKP->nRokyOdpis )
        ENDIF
      ENDIF
    ENDIF

  CASE cField $ 'ntypdodpi'    //,ntypuodpi'
    lReCompute := IF( lValid, .T., lReCompute )

  CASE cField = 'nProcDanOd'   // roèní daò. odpis %
    If lValid
      ::dm:set( ::fiMAJw + '->nProcDanOd', xVar )    // 25.2.2012
      ::dm:set( ::fiMAJw + '->nDanOdpRok', PercToVAL( nCenaVstD, xVar, nRoundAlgor ))
    endif

  CASE cField = 'nDanOdpRok'   // roèní daò. odpis KC
    If lValid
      ::dm:set( ::fiMAJw + '->nProcDanOd', ValToPERC( nCenaVstD, xVar ))
    endif

  CASE cField = 'ntypuodpi'
    lReCompute := IF( lValid, .T., lReCompute )
    if lValid
      if C_DanSkp->cMJCas = 'M' .and. xVar = UO_ROVENDANOVEMU
        IsEditGET( { ::fiMAJw + '->nProcUctOd' }, ::drgDialog,  .f. )
      endif
    endif

  CASE cField = 'ntypvypuo'
    lReCompute := IF( lValid, .T., lReCompute )

  CASE cField = 'nProcUctOd'

    If lValid
      nUORok := PercToVAL( nCenaVstU, xVar )
      nZCU   := nCenaVstU - (::fiMAJw)->nOprUctPS
      If nUORok > nZCU
        lOk := FALSE
        drgMsgBox(drgNLS:msg( 'Roèní úèetní odpis pøesahuje zùstatkovou cenu !'))
      Else
        ::dm:set( ::fiMAJw + '->nProcUctOd', xVar )
        *new
        nUOMes := nUORok / nPocetMes
        nUOMes := mh_RoundNumb( nUOMes, nRoundAlgor)
        nUORok := nUOMes * nPocetMes
        ::dm:set( ::fiMAJw + '->nUctOdpRok', nUORok := HIM_RocniOdpis( nUORok, nZCU, nRoundAlgor) )
        ::dm:set( ::fiMAJw + '->nUctOdpMes', If( nAktMes == 12, 0, nUOMes) )
        ::dm:set( ::fiMAJw + '->nProcUctOd', ValToPERC( nCenaVstU, nUORok) )
      EndIf
    EndIf

  CASE cField = 'nUctOdpRok'
    If lValid
      nUORok := xVar
      nZCU   := nCenaVstU - (::fiMAJw)->nOprUctPS
      IF nUORok = 0 .AND. nZCU > 0  // 11.11.2004 ... JCH
        xdrgMsgBox(drgNLS:msg( 'Roèní úèetní odpis je nulový, pøestože zùstatková cena je nenulová !'))
      ELSE
        If nUORok > nZCU
          lOk := FALSE
          drgMsgBox(drgNLS:msg( 'Roèní úèetní odpis pøesahuje zùstatkovou cenu !'))
        Else
          * new
          nUOMes := nUORok / nPocetMes
          nUOMes := mh_RoundNumb( nUOMes, nRoundAlgor)
          nUORok := nUOMes * nPocetMes
          ::dm:set( ::fiMAJw + '->nUctOdpRok', nUORok := HIM_RocniOdpis( nUORok, nZCU, nRoundAlgor) )
          ::dm:set( ::fiMAJw + '->nUctOdpMes', If( nAktMes == 12, 0, nUOMes) )
          ::dm:set( ::fiMAJw + '->nProcUctOd', ValToPERC( nCenaVstU, nUORok) )

        /*zal 11.11.2010
          ::dm:set( ::fiMAJw + '->nUctOdpRok', xVar )
          ::dm:set( ::fiMAJw + '->nProcUctOd', ValToPERC( nCenaVstU, xVar) )
          ::dm:set( ::fiMAJw + '->nUctOdpMes', If( nAktMes == 12, 0, xVar / nPocetMes) )
        */
**          ::DanOdpis()
        EndIf
      ENDIF
    EndIf

  CASE cField = 'nUctOdpMes'   // mìsíèní úèetní odpis
    If lValid

      nUOMes := mh_RoundNumb( xVar, nRoundAlgor)
      nUORok := nUOMes * nPocetMes    // ( 12 - nAktMes)
      nZCU   := nCenaVstU - (::fiMAJw)->nOprUctPS
      If nUORok > nZCU
        lOk := FALSE
        cMsg := 'Roèní úèetní odpis [ & ] pøesahuje zùstatkovou cenu  [ & ] !'
        drgMsgBox(drgNLS:msg( cMsg, nUORok, nZCU))
      Else
        * new
        ::dm:set( ::fiMAJw + '->nUctOdpMes', nUOMes )
        ::dm:set( ::fiMAJw + '->nUctOdpRok', nUORok )
        ::dm:set( ::fiMAJw + '->nProcUctOd', ValToPERC( nCenaVstU, nUORok) )
      EndIf
    EndIf

  CASE cField = 'nUplProc'
    If lValid
      lReCompute := TRUE
* js      ::dm:set( ::fiMAJw + '->nUplHodn', PercToVAL( nCenaVstD, xVar ))
      ::dm:set( ::fiMAJw +'->nUplHodn' , mh_roundNUMB( PercToVAL(nCenaVstD, xVar), nRoundAlgor) )
    EndIf

  CASE cField = 'nDoklad'
    If( lValid, lOk := HIM_CisDoklad( xVar, ::cTASK), Nil )

/*
  CASE cField = 'dDatZar'
    IF 'M' $ Upper( ::dm:get( ::fiMAJw + '->cOdpiSk'))
      lOK := xVar > CTOD('01.01.09') .AND. xVar < CTOD('30.06.10')
      IF lOK
        ::dm:set( ::fiMAJw + '->cObdZar', StrZero( Month( xVar), 2) + '/' + right(alltrim( str(year( xVar))), 2) )
      ELSE
        drgMsgBox(drgNLS:msg( 'Datum zaøazení musí být pro tuto daòovou skupinu v intervalu: ;'+ ;
                              ' 1.1.2009 - 30.6.2010 !'  ))
      ENDIF
    ENDIF

  CASE cField = 'cObdZar'
    IF lValid
      lReCompute := TRUE
      **
      dDatZar :=  ::dm:get( ::fiMAJw + '->dDatZar')
      lOK := ( Month( dDatZar) = VAL( LEFT( xVar, 2)) .and. ;
               VAL(Right(Str(Year( dDatZar)), 2)) = VAL( RIGHT( xVar,2)) )
      *
      IF !lOK
        drgMsgBox(drgNLS:msg( 'Zadané období zaøazení [ & ] nekoresponduje s datem zaøazení [ & ] !', xVar, dDatZar ))
        If ( nEvent = xbeP_Keyboard .and.( mp1 = xbeK_RETURN .or.  mp1 = xbeK_DOWN ))
          RETURN .F.
        else
          RETURN .T.
        endif
      ENDIF
      **
      If lChanged .and. ::IsObdOk( xVar)
         If !( lOk := mh_ObdToVal( xVar) <= mh_ObdToVal( ::cAktOBD) )
           drgMsgBox(drgNLS:msg( 'Nelze zadat vyšší období než [ & ] !', ::cAktOBD ))
         Endif
      Endif
    EndIF
*/

  CASE cField = 'nZnAkt' .or. cField = 'nZnAktD'
    IF lValid
      Do Case
      Case xVar == AKTIVNI          // 0 = aktivní
        lRecompute := .T.
      Case xVar == NEAKTIVNI        // 1 = neaktivní
        if cField = 'nZnAkt'
          ::dm:set( ::fiMAJw + '->nProcUctOd', 0 )  // roèní úèetní odpis %
          ::dm:set( ::fiMAJw + '->nUctOdpRok', 0 )  // roèní úèetní odpis
          ::dm:set( ::fiMAJw + '->nUctOdpMes', 0 )  // mìsíèní úèetní odpis
        elseif cField = 'nZnAktD'
          ::dm:set( ::fiMAJw + '->nProcDanOd', 0 )  // roèní daòový odpis %
          ::dm:set( ::fiMAJw + '->nDanOdpRok', 0 )  // roèní daòový odpis
        ENDIF
      Case xVar == UCETNE_ODEPSAN   //  2 = úèetnì/daòovì odepsaný
        *
        if cField = 'nZnAkt'
          If  ::dm:get( ::fiMAJw + '->nOprUctPS') <> ::dm:get( ::fiMAJw + '->nCenaVstU')
            drgMsgBox(drgNLS:msg( 'POZOR - Poèáteèní stav úè. oprávek se liší od vst. ceny úèetní !'))
          ENDIF
        elseif cField = 'nZnAktD'
          If  ::dm:get( ::fiMAJw + '->nOprDanPS') <> ::dm:get( ::fiMAJw + '->nCenaVstD')
            drgMsgBox(drgNLS:msg( 'POZOR - Poèáteèní stav daò. oprávek se liší od vst. ceny daòové !'))
          ENDIF
        endif

      Case xVar == VYRAZEN   //  9 = vyøazen / prodaný
         *
        if cField = 'nZnAkt'
          If  (::fiMAJw)->nZnAkt <> 9
            drgMsgBox(drgNLS:msg( 'POZOR - majetek nebyl vyøazen bìžným pohybem !'))
          ENDIF
        elseif cField = 'nZnAktD'
          If (::fiMAJw)->nZnAktD <> 9
            drgMsgBox(drgNLS:msg( 'POZOR - majetek nebyl vyøazen bìžným pohybem !'))
          ENDIF
        endif

      EndCase
    EndIF

  CASE cField $ 'ncisfak, cvarsym'
    if lValid
      lOK := ControlDUE( oVar, .F.)
    endif

  ENDCASE
  *
  cOdpiSkD := ::dm:get( ::fiMAJw + '->cOdpiSkD')
  nOdpiSkD := VAL( cOdpiSkD)
  cOdpiSk  := ::dm:get( ::fiMAJw + '->cOdpiSk')
  nOdpiSk  := VAL( cOdpiSk)
*  lRecompute := if( ::dm:get( ::fiMAJw + '->nZnAktD') = 0, .t., .f. )

  IF ( cField $ 'ncenapord,ndotacedan,ncenavstd,codpiskd,ntypdodpi,nznaktd,cobdzar,nuplproc') .and. ;
     lRecompute .and. ::dm:get( ::fiMAJw + '->nZnAktD') = AKTIVNI
    *
    cObdZar   := ::dm:get( ::fiMAJw + '->cObdZar')
    * Roèní daòové odpisy
    nTypDOdpi := ::dm:get( ::fiMAJw + '->nTypDOdpi')
    nCenaVstD := ::dm:get( ::fiMAJw + '->nCenaVstD')
    nOprDan   := ::dm:get( ::fiMAJw + '->nOprDan'  )
    nCenaPorD := ::dm:get( ::fiMAJw + '->nCenaPorD' )
    c_DanSkp->( dbSeek( Upper( cOdpiSkD),,'C_DANSKP1') )
    nPocetDO  := (::fiMAJw)->nRokyDanOd
    nZCD      := nCenaVstD - nOprDan

    Do Case
      Case nTypDOdpi == DO_ROVNOMERNY      //  = 1
        IF c_DanSkp->cMJCas = 'R'
          nProcRDO := HIM_ProcRDO( cObdZar                           , ;
                                   cOdpiSkD                          , ;
                                   ::dm:get( ::fiMAJw + '->nUplProc'), ;
                                   nPocetDO                          , ;
                                   ::cTask                           ,, ::lnewRec )
          if cField = 'ntypdodpi'
            *  pøi zmìnì typu daòového odpisu se procento daòového odpisu vždy bere
            ** z tabulky daòových odpisù ( HIM_ProcRDO() )
          else
* js            nProcRDO := CoalesceEmpty( ::dm:get( ::fiMAJw + '->nProcDanOd'), nProcRDO)
          endif

          ::dm:set( ::fiMAJw + '->nProcDanOd', nProcRDO )
          nDORok := PercToVal( nCenaVstD, nProcRDO )
          ::dm:set( ::fiMAJw + '->nDanOdpRok', HIM_RocniOdpis( nDORok, nZCD))

        ELSEIF c_DanSkp->cMJCas = 'M'
          ::DanODPIS()
        ENDIF

      Case nTypDOdpi == DO_ZRYCHLENY .and. Empty( (::fiMAJw)->cObdZvys)  //  = 2
        If nPocetDO == 0
          nDORok := nCenaVstD / c_DanSkp->nZrPrvni
          nDORok += ::dm:get( ::fiMAJw + '->nUplHodn'  )  // 1.11.2005
        Else
          nDORok := 2 * ( nCenaVstD - nOprDan ) / ;
                        ( c_DanSkp->nZrDalsi - (::fiMAJw)->nRokyDanOd)
        EndIf
        ::dm:set( ::fiMAJw + '->nDanOdpRok', nDORok := HIM_RocniOdpis( nDORok, nZCD))
        ::dm:set( ::fiMAJw + '->nProcDanOd', ValToPerc( nCenaVstD, nDORok) )

      Case nTypDOdpi == DO_ZRYCHLENY .and. !Empty( (::fiMAJw)->cObdZvys)
        If (::fiMAJw)->nRokZvDanO == 0
          nDORok := ( 2 * ( nCenaVstD - nOprDan ) / c_DanSkp->nZrPrvni )
        Else
          nDORok := ( 2 * ( nCenaVstD - nOprDan ) / ;
                    ( c_DanSkp->nZrZvCena - (::fiMAJw)->nRokZvDanO ) )
        Endif
        ::dm:set( ::fiMAJw + '->nDanOdpRok', nDORok := HIM_RocniOdpis( nDORok, nZCD))
        ::dm:set( ::fiMAJw + '->nProcDanOd', ValToPerc( nCenaVstD, nDORok) )
    EndCase
  EndIf

*  lRecompute := if( ::dm:get( ::fiMAJw + '->nZnAkt') = 0, .t., .f. )
  IF ( cField $ 'ncenaporu,ndotaceuct,ncenavstu,codpisk,ntypuodpi,ntypvypuo,cobdzar') .and. ;
     lRecompute .and. ::dm:get( ::fiMAJw + '->nZnAkt') = AKTIVNI
    *
    * Roèní úèetní odpisy
    c_UcetSkp->( dbSeek( Upper( cOdpiSk),, 'C_UCETSKP1'))
**    nAktMes   := HIM_AktMes( cObdZAR, ::cTASK )
    nTypUOdpi := ::dm:get( ::fiMAJw + '->nTypUOdpi')
    nTypVypUO := ::dm:get( ::fiMAJw + '->nTypVypUO')
    nCenaVstU := ::dm:get( ::fiMAJw + '->nCenaVstU')
    nOprUct   := ::dm:get( ::fiMAJw + '->nOprUct'  )
    nZCU      := nCenaVstU - nOprUct
    nCenaPorU := ::dm:get( ::fiMAJw + '->nCenaPorU' )

*    lRocniUZV := HIM_isRocniUZV( ::nAktROK, IF( ::isHIM, 'DMAJ', 'DMAJZ'))

    /*  org 21.8.2008
    If nTypUOdpi == UO_ROVNOMERNY  //  1 = rovnomìrný
**20.8.      nUOMes := nCenaVstU / ( ::dm:get( ::fiMAJw + '->nRokyOdpiU') * 12 )
      nUOMes := nCenaVstU / (C_UcetSkp->nRokyOdpis * 12 )
      nUOMes := mh_RoundNumb( nUOMes, nRoundAlgor)
      ::dm:set( ::fiMAJw + '->nUctOdpMes', nUOMes )
**      nAktMes := If( ::lRocniUZV, 0, nAktMes )
      nUORok := If( nAktMes = 12 .and. !::lRocniUZV .and. ::lNewRec, 0, nUOMes * ( 12 - nAktMes) )
      ::dm:set( ::fiMAJw + '->nUctOdpRok', nUORok := HIM_RocniOdpis( nUORok, nZCU, nRoundAlgor))
      ::dm:set( ::fiMAJw + '->nProcUctOd', ValToPERC( nCenaVstU, nUORok) )
    EndIF
    If nTypUOdpi == UO_ROVENDANOVEMU    // 3 = roven daòovému
**20.8.      ::dm:set( ::fiMAJw + '->nRokyOdpiU', C_DanSkp->nRokyOdpis )
      ::dm:set( ::fiMAJw + '->nProcUctOd', ::dm:get( ::fiMAJw + '->nProcDanOd' ) )
      nUORok := ::dm:get( ::fiMAJw + '->nDanOdpRok')
      nUOMes := If( nAktMes = 12 .and. !lRocniUZV .and. ::lNewRec, 0,;
                    mh_RoundNumb( nUORok / ( 12 - nAktMes), nRoundAlgor) )
      nUORok := If( nAktMes == 12, nUORok, nUOMes * ( 12 - nAktMes) )
      ::dm:set( ::fiMAJw + '->nUctOdpRok', nUORok )
      ::dm:set( ::fiMAJw + '->nUctOdpMes', nUOMes )
    EndIf
    */

    If nTypUOdpi == UO_ROVNOMERNY      //  1 = rovnomìrný
      /*
      If nTypVypUO = UO_VYPOCET_PLNY
        * odepisuje se již v mìsíci zaøazení
        nUORok := ( nCenaVstU / 100 * C_UcetSkp->nRoPrvni)
        nUOMes := nUORok / ( 13 - nAktMes )
        *new
        nUOMes := mh_RoundNumb( nUOMes, nRoundAlgor)
        nUORok := nUOMes * ( 13 - nAktMes )
      ELSEIF nTypVypUO = UO_VYPOCET_ZKRACENY
        * odepisuje se od následujícího mìsíce po zaøazení
        nUOMes := (( nCenaVstU / 100 * C_UcetSkp->nRoPrvni) / 12 )
        nUOMes := mh_RoundNumb( nUOMes, nRoundAlgor)
        nUORok := If( nAktMes = 12 .and. !::lRocniUZV .and. ::lNewRec, 0, nUOMes * ( 12 - nAktMes) )
      ENDIF
      */

      nUOMes := (( nCenaVstU / 100 * C_UcetSkp->nRoPrvni) / 12 )
      nUOMes := mh_RoundNumb( nUOMes, nRoundAlgor)
      If nTypVypUO = UO_VYPOCET_PLNY
        nUORok := nUOMes * ( 13 - nAktMes)
      ELSEIF nTypVypUO = UO_VYPOCET_ZKRACENY
        nUORok := If( nAktMes = 12 .and. !::lRocniUZV .and. ::lNewRec, 0, nUOMes * ( 12 - nAktMes) )
      ENDIF
      ::dm:set( ::fiMAJw + '->nUctOdpMes', nUOMes )
      ::dm:set( ::fiMAJw + '->nUctOdpRok', nUORok := HIM_RocniOdpis( nUORok, nZCU, nRoundAlgor))
      ::dm:set( ::fiMAJw + '->nProcUctOd', ValToPERC( nCenaVstU, nUORok) )
    EndIF
    If nTypUOdpi == UO_ROVENDANOVEMU     // 3 = roven daòovému
**20.8.      ::dm:set( ::fiMAJw + '->nRokyOdpiU', C_DanSkp->nRokyOdpis )
**      ::dm:set( ::fiMAJw + '->nProcUctOd', ::dm:get( ::fiMAJw + '->nProcDanOd' ) )
      nUORok := ::dm:get( ::fiMAJw + '->nDanOdpRok')
      nUOMes := If( nAktMes = 12 .and. !::lRocniUZV .and. ::lNewRec, 0,;
                    mh_RoundNumb( nUORok / nPocetMes, nRoundAlgor) )
      nUORok := If( nAktMes == 12, nUORok, nUOMes * nPocetMes )
      ::dm:set( ::fiMAJw + '->nUctOdpRok', nUORok )
      ::dm:set( ::fiMAJw + '->nUctOdpMes', nUOMes )
      ::dm:set( ::fiMAJw + '->nProcUctOd', ValToPERC( nCenaVstU, nUORok) ) // new
    EndIf
  ENDIF

RETURN lOK

********************************************************************************
METHOD HIM_MAJ_CRD:comboBoxInit(drgComboBox)
  LOCAL  cNAME := drgParse(drgComboBox:name), aCombo := {}
  Local  cAlias := IF( cName = ::fiMAJw +'->nZnAkt', 'C_Aktiv', 'C_AktivD')
  Local  nRec
  *
  DO CASE
  CASE cName = ::fiMAJw +'->nZnAkt' .or. cName = ::fiMAJw +'->nZnAktD'
    IF cAlias = 'c_Aktiv'
      nRec := (cAlias)->( RecNo())
      (cAlias)->( dbEVAL( {|| AADD( aCombo, { (cAlias)->nZnakAkt, alltrim( str((cAlias)->nZnakAkt) + ' - ' + (cAlias)->cPopisAkt)} ) }))
      (cAlias)->( dbGoTO( nRec))
    ELSEIF cAlias = 'c_AktivD'
      nRec := (cAlias)->( RecNo())
      (cAlias)->( dbEVAL( {|| AADD( aCombo, { (cAlias)->nZnakAktD, alltrim( str((cAlias)->nZnakAktD) + ' - ' + (cAlias)->cPopisAkt)} ) }))
      (cAlias)->( dbGoTO( nRec))
    ENDIF
    IF LEN( aCombo) <> 0
      drgComboBox:oXbp:clear()
      drgComboBox:values := ASort( aCombo,,, {|aX,aY| aX[1] < aY[1] } )
      AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2])})
      drgComboBox:value := IF( cAlias = 'c_Aktiv', (::fiMAJw)->nZnAkt, (::fiMAJw)->nZnAktD )
    ENDIF
  ENDCASE
  *
RETURN self

********************************************************************************
METHOD HIM_MAJ_CRD:OnSAVE( isBefore, isAppend )
  Local axREC, cObdZar, nMin, nMax
  Local cDP_UcOdpis := IF( ::isHIM, UCETNI_ODPIS_HIM, UCETNI_ODPIS_ZS )

  IF ! ::dc:isReadOnly
    ::dm:save()

    if .not. ::c_naklst_vld()
      return .f.
    endif

    IF( ::lNewREC, ( ::fiMAJ)->( DbAppend()), Nil )
    IF ( ::fiMAJ)->(sx_RLock())
       mh_COPYFLD( ::fiMAJw, ::fiMAJ )
       ( ::fiMAJ)->nOdpiSk := VAL( ( ::fiMAJ)->cOdpiSk )
       IF ( ::fiMAJ)->nOdpiSk = 8   // mìsíèní odpisy
         ( ::fiMAJ)->nMesOdpiUZ := ( ::fiMAJ)->nRokyOdpiU
       ENDIF
       *
       IF C_DanSkp->( dbSeek( upper((::fiMAJ)->cOdpiSkD),, 'C_DANSKP1'))
         ( ::fiMAJ)->nOdpiSkD := C_DanSkp->nOdpiSkD
       ENDIF
       *
       Do Case
         Case ::lNewRec
           ( ::fiMAJ)->nOprUctPS  := ( ::fiMAJ)->nOprUct
           ( ::fiMAJ)->nOprDanPS  := ( ::fiMAJ)->nOprDan
           if ::isHIM
             ( ::fiMAJ)->cUcetSkup := Alltrim( Str( (::fiMAJ)->nTypMaj ))
           else
             nMin := IF( KategZvi->nKcPrevBot = 0, SysCONFIG('Zvirata:nKcPrevBot'), KategZvi->nKcPrevBot )
             nMax := IF( KategZvi->nKcPrevTop = 0, SysCONFIG('Zvirata:nKcPrevTop'), KategZvi->nKcPrevTop )
             ( ::fiMAJ)->nUcetSkup := if( ( ::fiMAJ)->nCenaVstU >= nMin .and. ( ::fiMAJ)->nCenaVstU <= nMax,;
                                            KategZvi->nUcetSkupP, KategZvi->nUcetSkup )
             ( ::fiMAJ)->cUcetSkup := Alltrim( Str( (::fiMAJ)->nUcetSkup ))
           endif
           HIM_Zmaju_IM( ::lNewRec, ::isHIM )  // automaticky generuje úèetní zmìnu pro IM
           *
           * Zápis do souboru poè.stavù
           mh_COPYFLD( ::fiMAJ , ::fiMAJ_ps, .T.)
           (::fiMAJ_ps)->nROK      := ::nAktROK
           (::fiMAJ_ps)->nVsCenDPS := (::fiMAJ)->nCenaVstD
           (::fiMAJ_ps)->nVsCenUPS := (::fiMAJ)->nCenaVstU
           (::fiMAJ_ps)->nOprUctPS := (::fiMAJ)->nOprUct
           (::fiMAJ_ps)->nZuCenUPS := (::fiMAJ_ps)->nVsCenUPS - (::fiMAJ_ps)->nOprUctPS
           mh_wrtZmena( ::fiMAJ_ps, .T. )
           *
           * NEW 31.3.11
           * Je-li typ výpoètu UO plný, pak se odpisuje již v mìsíci zaøazení a musí
           * dojít k vygenerování a zaúètování dokladu o odpisu již v období zaøazení !!!
           IF ( ::fiMAJ)->nTypVypUO = UO_VYPOCET_PLNY
             ::genUO_PLNY()
           ENDIF
           * END_NEW

         Case ( ::fiMAJ)->cObdZar == ::cAktOBD  // ::cLAST_obd
           * new 25.2.12
           if empty( ( ::fiMAJ)->cObdPosOdp )
             HIM_Zmaju_IM( ::lNewRec, ::isHIM )

           elseif ( ( ::fiMAJ)->cObdZar = ( ::fiMAJ)->cObdPosOdp .and. ;
                    ( ::fiMAJ)->nTypVypUO = UO_VYPOCET_PLNY  )
             * NEW 31.3.11
             * Pokud došlo k úèetnímu odpisu hned v mìsíci zaøazení ( typ výpoètu odpisu = plný),
             * musí se odpis pøi opravì v mìsíci zaøazení zrušit
             *
             (::fiZMAJU)->( dbGoTop())
             DO WHILE ! (::fiZMAJU)->( Eof())
               if alltrim((::fiZMAJU)->cTypPohybu ) = cDP_UcOdpis
                 (::fiMAJ)->nOprUct    -= (::fiZMAJU)->nUctOdpMes  // (::fiMAJ)->nUctOdpMes
                 (::fiMAJ)->cObdPosOdp := ''
                 (::fiMAJ)->nPocMesUO  -= 1

                 * zrušit se musí i zaúètování odpisu - 12.1.2012
                 cKey := Upper( (::fiZMAJU)->cDenik) + StrZero( (::fiZMAJU)->nDoklad,10) + ;
                                                       StrZero( (::fiZMAJU)->nOrdItem,5)
                 do while UcetPOL->( dbSeek( cKey,, 'UCETPOL1'))
                   UcetPOL->( dbRLock(), dbDelete())
                 enddo
                 (::fiZMAJU)->( dbRLock(), dbDelete())
               endif
               (::fiZMAJU)->( dbSkip())
             ENDDO
             (::fiZMAJU)->( dbGoTop())
             *
             * END_NEW

             HIM_Zmaju_IM( ::lNewRec, ::isHIM )

             ::genUO_PLNY()
           endif
       EndCase

       ( ::fiMAJ)->nRokyDanOd := MAX( 0, ::RokDO( (::fiMAJ)->cObdZar ) )
*       ( ::fiMAJ)->nRokUpl := If( (::fiMAJ)->nUplProc > 0 .and. (::fiMAJ)->nRokUpl == 0,;
*                                  Year( (::fiMAJ)->dDatZar), (::fiMAJ)->nRokUpl )

       nObdZar  := VAL( Right((::fiMAJ)->cObdZar,2) )
       ( ::fiMAJ)->nRokUpl := If( (::fiMAJ)->nUplProc > 0 .and. (::fiMAJ)->nRokUpl == 0,;
                                  VAL( IF( nObdZar < 30, '20', '19') + StrZero(nObdZar,2)), (::fiMAJ)->nRokUpl )

       ( ::fiMAJ)->nRokUpl := If( (::fiMAJ)->nUplProc = 0, 0,( ::fiMAJ)->nRokUpl )
       ::ZmajN_IM()
       * Modifikace souboru C_MAJ v modulu TPV.
       IF ::isHIM
          IF( SysConfig( 'Im:lVyroba'), ::TpvMAJ_modi(), Nil )
       ENDIF
       ( ::fiMAJ)->( dbUnlock())
      //
    ENDIF
  ENDIF

  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
RETURN .T.

********************************************************************************
METHOD HIM_MAJ_CRD:genUO_PLNY()
  Local cDP_UcOdpis := IF( ::isHIM, UCETNI_ODPIS_HIM, UCETNI_ODPIS_ZS )
  Local cTag := ( ::fiZMAJU)->( OrdSetFocus())
  Local HimPohyby := HIM_Pohyby_Crd():new( ::parent, ::cTask)

  drgDBMS:open( ::fiZMAJUw ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  HimPohyby:nKarta    := 204
  HimPohyby:cAktOBD   := ::cAktOBD
  HimPohyby:nAktOBD   := ::nAktOBD
  HimPohyby:nAktROK   := ::nAktROK
  *
  DO CASE
    CASE (::fiMAJ)->nZnAkt == AKTIVNI .and. ;
        ( (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct) >= (::fiMAJ)->nUctOdpMes
      (::fiMAJ)->nOprUct    += (::fiMAJ)->nUctOdpMes
      (::fiMAJ)->cObdPosOdp := ::cAktOBD
      * Poèet mìsíèních odpisù = nová položka
      (::fiMAJ)->nPocMesUO += 1
*            (::fiMAJ)->nPocMesOdp += 1   // Poèet mìsíèních odpisù
      IF !(::fiMaj)->lHmotnyIM .and. (::fiMAJ)->nOdpiSk = 8
        (::fiMAJ)->nPocMesUOZ += 1   // Poèet mìsíèních odpisù po zmìnì
      ENDIF
      *
      IF AddRec( ::fiZMAJUw)
         ( ::fiZMAJUw)->cTypPohybu := cDP_UcOdpis        // UCETNI_ODPIS
         ( ::fiZMAJUw)->nDrPohyb   := VAL(cDP_UcOdpis)   // UCETNI_ODPIS - doèasnì
         HimPohyby:ZmajU_Modi( xbeK_INS, .F. )
         ( ::fiZMAJUw)->( dbUnlock())
      ENDIF

    CASE (::fiMAJ)->nZnAkt == AKTIVNI .and. ;
        ( (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct) <  (::fiMAJ)->nUctOdpMes .and. ;
        ( (::fiMAJ)->nCenaVstU > (::fiMAJ)->nOprUct)
      (::fiMAJ)->nUctOdpMes := (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct
      (::fiMAJ)->nOprUct    += (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct
      (::fiMAJ)->cObdPosOdp := ::cNewOBD
      * Poèet mìsíèních odpisù = nová položka
      (::fiMAJ)->nPocMesUO += 1
*            (::fiMAJ)->nPocMesOdp += 1
      IF !(::fiMaj)->lHmotnyIM .and. (::fiMAJ)->nOdpiSk = 8
        (::fiMAJ)->nPocMesUOZ += 1   // Poèet mìsíèních odpisù po zmìnì
      ENDIF

      IF AddRec( ::fiZMAJUw)
         ( ::fiZMAJUw)->cTypPohybu := cDP_UcOdpis        // UCETNI_ODPIS
         ( ::fiZMAJUw)->nDrPohyb   := VAL(cDP_UcOdpis)  //  UCETNI_ODPIS - doèasnì
         HimPohyby:ZmajU_Modi( xbeK_INS, .F. )
         ( ::fiZMAJUw)->( dbUnlock())
      ENDIF

    CASE (::fiMAJ)->nZnAkt == AKTIVNI .and. (::fiMAJ)->nCenaVstU = (::fiMAJ)->nOprUct
      (::fiMAJ)->nZnAkt := ODEPSAN
  ENDCASE
  ( ::fiZMAJU)->( OrdSetFocus( cTag))

RETURN self

********************************************************************************
METHOD HIM_MAJ_CRD:KategZvi_sel(drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get( ::fiMAJw + '->nZvirKat', .F.)
  Local value  := drgVar:get()
  Local ok     := ( !Empty(value) .and. KategZvi->(dbseek( value,,'KATEGZVI_1')))

  if IsObject(drgDialog) .or. !ok
    DRGDIALOG FORM 'KategZvi_sel' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
    if nExit = drgEVENT_SELECT
      ::dm:set( ::fiMAJw + '->nZvirKat', KategZvi->nZvirKat )
      ::dm:refresh()
    endif
  endif
RETURN (nExit = drgEVENT_SELECT .or. ok)

********************************************************************************
METHOD HIM_MAJ_CRD:C_TypPoh_sel(drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get( ::fiMAJw + '->cTypPohybu', .F.)
  Local value  := drgVar:get()
  Local ok     := ( !Empty(value) .and. C_TypPoh->(dbseek(IF( ::isHim,I_DOKLADY, Z_DOKLADY) + value,,'C_TYPPOH02')))

  if IsObject(drgDialog) .or. !ok
    * nastaví filtr na záznamy úlohy I nebo Z
    Filter := IF( ::isHIM, "cUloha = 'I' .and. Val(Right(AllTrim( cTypDoklad),3)) > 0 .and. Val(Right(AllTrim( cTypDoklad),3)) <= 199",;
                           "cUloha = 'Z' .and. Val(Right(AllTrim( cTypDoklad),3)) > 0 .and. Val(Right(AllTrim( cTypDoklad),3)) <= 199" )
    C_TypPoh->( mh_ClrFilter(), mh_SetFilter( Filter))
    *
    DRGDIALOG FORM 'C_TypPoh_sel' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
    *
  ENDIF

  if nExit = drgEVENT_SELECT .OR. ok
    ::dm:set( ::fiMAJw + '->cTypPohybu', C_TypPoh->cTypPohybu )
    ::dm:refresh()
    C_TypPoh->( mh_ClrFilter())
  endif

RETURN (nExit = drgEVENT_SELECT .or. ok)

********************************************************************************
METHOD HIM_MAJ_CRD:destroy()
  ::drgUsrClass:destroy()
  (::fiMAJw)->( dbCloseArea())
  (::fiMAJww)->( dbCloseArea())

  ::lNewREC      :=  ;
  ::lZmenyN      :=  ;
  ::lEditOdpis   :=  ;
  ::nZustCenaU   :=  ;
  ::nZustCenaD   :=  ;
  ::dm           :=  ;
  ::fiMAJ        := ::fiMAJw  := ::fiMAJ_ps := ::cTASK   := ::isHIM := ;
  ::fiZMAJU      := ::fiZMAJUw := ;
  ::cAktObd      := ::nAktObd := ::nAktRok := ;
  ::lRocniUZV    := ;
  ::cTextDobaD   := ;
  ::parent       := ;
   Nil
RETURN self

* Specifikum pro majetek, který se odepisuje mìsíènì
* HIDDEN ***********************************************************************
METHOD HIM_MAJ_CRD:DanODPIS( lUctOdpis)
  Local nOdpiSkD
  Local nPocetMES := ::dm:get( ::fiMAJw + '->nMesOdpiD' )
  Local nAktMes, nDOMes, nDORok, nZCD
  Local nRoundAlgor := IF( ::isHIM , SysConfig( 'Im:nRoundOdpi'  ),;
                                     SysConfig( 'Zvirata:nRoundOdpi') )
*  Local aOdpiSkD := { 7, 8, 9, 10, 11, 12, 13 }

  DEFAULT lUctOdpis TO .F.

  nOdpiskD := IF( C_DanSkp->( dbSeek( Upper( ::dm:get( ::fiMAJw + '->cOdpiSkD')),,'C_DANSKP1')),;
                 C_DanSkp->nOdpiSkD, 0)

  IF nOdpiSkD > 6
*  IF ( nPos := aScan( aOdpiSkD, nOdpiSkD)) > 0
    nAktMes := HIM_AktMes( ::dm:get( ::fiMAJw + '->cObdZar' ), ::cTASK )
    nZCD    := ::dm:get( ::fiMAJw +'->nCenaVstD') - ::dm:get( ::fiMAJw +'->nOprDan')

    Do Case
    Case nOdpiSkD = 7 .or. nodpiSKD = 15  // 1M - 1M1
      nDOMes := mh_RoundNumb( ( ::dm:get( ::fiMAJw +'->nCenaVstD') / 12), nRoundAlgor )
    Case nOdpiSkD = 8
      nDOMes := ::dm:get( ::fiMAJw +'->nUctOdpMes')
    Case nOdpiSkD = 9 .or. nodpiSKD = 14  // 2M  - 2M2
      nDOMes := mh_RoundNumb( (( ::dm:get( ::fiMAJw +'->nCenaVstD') * 0.6) / 12), nRoundAlgor )
    Otherwise
       * sk. 10-8 mìs, 11=36, 12-60, 13-72, skupiny > 13
      nDOMes := mh_RoundNumb( ( ::dm:get( ::fiMAJw +'->nCenaVstD') / C_DanSkp->nMesOdpiD), nRoundAlgor )
    EndCase

    nDORok  := If( nAktMes == 12, 0, nDOMes * ( 12 - nAktMes) ) // od následujícího mìsíce
    ::dm:set( ::fiMAJw +'->nDanOdpRok', HIM_RocniOdpis( nDORok, nZCD) )
    ::dm:set( ::fiMAJw +'->nProcDanOd', ValToPERC( ::dm:get( ::fiMAJw +'->nCenaVstD' ),;
                                                   ::dm:get( ::fiMAJw +'->nDanOdpRok') ) )

    IF lUctOdpis
      IF ( nOdpiSkD = 7 .or. nodpiSKD = 15 .or. nOdpiSkD = 9 .or. nodpiSKD = 14)
        // pro 1M, 2M, 1M1, 2M2 pøednastavíme
        nUOMes := nDoMes
        nUOMes := mh_RoundNumb( nUOMes, nRoundAlgor)
        ::dm:set( ::fiMAJw +'->nUctOdpMes', nUOMes)
        nUORok := If( nAktMes == 12, 0, nUOMes * ( 12 - nAktMes) )
        nZCU   := ::dm:get( ::fiMAJw +'->nCenaVstU') - ::dm:get( ::fiMAJw +'->nOprUct')
        ::dm:set( ::fiMAJw +'->nUctOdpRok', HIM_RocniOdpis( nUORok, nZCU) )
        ::dm:set( ::fiMAJw +'->nProcUctOd', ( ::dm:get( ::fiMAJw +'->nUctOdpRok') /( ::dm:get( ::fiMAJw +'->nCenaVstU') / 100 )))
      ENDIF
    ENDIF
  ENDIF
RETURN NIL

* Zjištìní roku daò.odpisu pro stanovení sazby dle tabulky a algoritmu
* pro výpoèet roèního daò. odpisu
* HIDDEN ***********************************************************************
METHOD HIM_MAJ_CRD:RokDO( cObdZAR)
*  Local nRokAkt := uct     VAL( mh_GETcRok4( ::cAktObdobi))
  Local nRokZar := VAL( mh_GETcRok4( cObdZAR)), nPocetDO

  nPocetDO := ( ::nAktROK - nRokZar)
Return( nPocetDO)


* Formální a logická správnost období
* HIDDEN ***********************************************************************
METHOD HIM_MAJ_CRD:IsObdOk( cObd)
  Local lOk := .t.
  Local nMes := Val( Left( cObd, 2)), nRok := Val( Right( cObd, 2))

  lOk := If( nMes >  0 .and. nMes <= 14 , lOk, FALSE )
  lOk := If( SubStr( cObd, 3, 1)   = '/', lOk, FALSE )
  lOk := If( nRok >= 0 .and. nRok <= 99 , lOk, FALSE )
  If( lOk, Nil, drgMsgBox(drgNLS:msg( 'Chybnì zadané období !')) )
Return lOk

*HIDDEN*************************************************************************
METHOD HIM_MAJ_CRD:modiCARD()
  Local  membORG := ::dc:members[1]:aMembers, membCRD := {}
  Local  varsORG := ::dm:vars, varsCRD := drgArray():new()
  Local  oVar, x

  For x := 1 TO Len( membORG)
    oVar := membORG[x]
    If IsMemberVar(oVAR,'Groups')
      If IsCharacter(oVAR:Groups)
        If oVAR:Groups <> ''
          oVAR:IsEDIT := .F.
          oVAR:oXbp:Hide()
        EndIf
      EndIf
    Endif
  Next
*
  For x := 1 TO Len( membORG)
    oVar := membORG[x]
*    if oVAR:ClassName() = 'drgStatic'
*      ovar:oxbp:setColorBG( 5 )
*    endif


    IF IsMemberVar(oVAR,'Groups')
      IF IsNIL( oVAR:Groups)
        AADD( membCRD, oVar)
      ElseIf IsCharacter( oVAR:Groups)
        IF  EMPTY(  oVAR:Groups) .OR. ::cTASK = oVAR:Groups
          IF oVAR:ClassName() $ 'drgGet,drgComboBox,drgMLE'
            oVAR:IsEDIT := .t.
            oVAR:oXbp:Show()
            AADD( membCRD, oVar)
          ELSE
            oVAR:oXbp:Show()
            AADD( membCRD, oVar)
          ENDIF
        ELSEIf ! EMPTY( oVAR:Groups)
          If ( IsMemberVar(oVar,'pushGet') .and. IsObject(oVar:pushGet))
            oVar:pushGet:oxbp:hide()
          EndIf
        EndIf
      EndIf
    ELSE
      AADD( membCRD, oVar)
    ENDIF
  Next
  *
  For x := 1 To LEN( varsORG:values)
    IF ! IsNIL( varsORG:values[x, 2] )
      oVAR := varsORG:values[x, 2]:oDrg
      IF oVAR:ClassName() $ 'drgGet,drgText,drgComboBox'
        If IsNIL( oVar:Groups) .OR. EMPTY(oVar:Groups) .OR. ( oVar:Groups = ::cTASK )
          varsCRD:add(oVar:oVar, oVar:oVar:name)
        ENDIF
      ELSEIF oVAR:ClassName() $ 'drgMLE'
        varsCRD:add(oVar:oVar, oVar:oVar:name)
      ENDIF
    ENDIF
  NEXT
  *
  FOR x := 1 TO LEN( membCRD)
    IF membCRD[x]:ClassName() = 'drgTabPage'

*      if membCRD[x]:tabBrowse = 'POZEMKYw' .and. .not. ::isHIM
*        membCRD[x]:isEdit := .f.
*        membCRD[x]:oxbp:disable()
*        membCRD[x]:oxbp:hide()
*      endif

      membCRD[x]:onFormIndex := x
    ENDIF
  NEXT

  ::df:aMembers := membCRD
  ::dm:vars     := varsCRD

RETURN self

* Generuje neúèetní zmìny
*HIDDEN*************************************************************************
METHOD HIM_MAJ_CRD:ZMajN_IM()
  Local  fiCIS   := 'c_TypPoh'      // 'c_DrPoh' + IF( ::isHIM, 'I','Z' )
  Local  fiZmajn := 'ZMAJN'  + IF( ::isHIM,  '','Z' )
  Local  nTypPohyb, cPopisZme, n, oVar, cFld, xOrg, xNew, oDesc
  Local  cUserAbb := SYSCONFIG( 'SYSTEM:cUSERABB' ), aStru := (::fiMajW)->( dbStruct())
  Local  cKEY := IF( ::isHIM, I_DOKLADY, Z_DOKLADY) + ALLTRIM( STR( (::fiMAJ)->nDrPohyb ))

  drgDBMS:open( fiCIS  )
*  (fiCIS)->( dbSEEK( (::fiMAJ)->nDrPohyb,, AdsCtag(1)))
  C_TypPOH->( dbSEEK( cKEY,, 'C_TYPPOH02'))
*  nTypPohyb := Int( (fiCIS)->nKarta / 100 )
  nTypPohyb := Int( Val(Right(alltrim(C_TypPOH->ctypdoklad),3)) / 100 )
  cPopisZme := IIf( nTypPohyb = VSTUPNI , 'Vstupní ... ' ,;
               IIF( nTypPohyb = BEZNY   , 'Oprava ...'   ,;
               IIF( nTypPohyb = VYSTUPNI, 'Výstupní ...' , '' ) ) )

  For n := 1 TO LEN( aStru)
    xOrg := (::fiMAJww)->( FieldGet( n))
    xNew := (::fiMAJw)->( FieldGet( n))
    IF xOrg <> xNew
      IF AddREC( fiZMajn )
        cFld := ::fiMAJw + '->' + aStru[ n, 1]
        oVar := ::dm:has( cFld )
*        oDesc := drgDBMS:getFieldDesc( cFld)
        (fiZmajN)->nInvCis    := (::fiMajW)->nInvCis
        IF ::isHIM
          (fiZmajN)->nTypMaj    := (::fiMajW)->nTypMaj
        ELSE
          (fiZmajN)->nUcetSkup  := (::fiMajW)->nUcetSkup
        ENDIF
        (fiZmajN)->cPopisZme  := cPopisZme
        (fiZmajN)->cPoleZme   := aStru[ n, 1]
*        (fiZmajN)->cNazPolZme := IF( IsNIL( oVar:ref), aStru[ n, 1] , oVar:ref:caption ) // Coalesce( oVar:ref:desc, oVar:ref:caption, oVar:ref:name )
        (fiZmajN)->cNazPolZme := IF( IsNIL( oVar)            , aStru[ n, 1],;
                                 IF( IsNIL( oVar:ref)        , aStru[ n, 1],;
                                 IF( IsNIL( oVar:ref:caption), aStru[ n, 1], oVar:ref:caption )))
*??        (fiZmajN)->cNazPolZme := Coalesce( oDesc:desc, oDesc:caption, oDesc:name )
        (fiZmajN)->cOldHodn   := drg2String( xOrg)
        (fiZmajN)->cNewHodn   := drg2String( xNew)
        (fiZmajN)->dDatZmeny  := Date()
        (fiZmajN)->cCasZmeny  := Time()
        (fiZmajN)->cUserAbb   := cUserAbb
        (fiZmajN)->( dbUnlock())
      EndIF
    EndIF
  Next

RETURN NIL

*  Zakládá nebo modifikuje záznam v C_MAJ  ... vazba HIM na TPV
*HIDDEN*************************************************************************
METHOD HIM_MAJ_CRD:TpvMAJ_modi()
  Local lExist, lOK, lChange
  Local cKey := Upper( 'I ') + StrZero( Maj->nInvCis, 15)

  drgDBMS:open('C_Maj'  )
  IF( lExist := C_Maj->( dbSeek( cKey,,'C_MAJ1')) )
    lChange := ( Maj->nInvCis   <> C_Maj->nInvCis   )   .OR. ;
               ( Maj->cNazev    <> C_Maj->cNazevMaj )   .OR. ;
               ( Maj->nTypMaj   <> C_Maj->nTypMaj   )   .OR. ;
               ( Maj->mPopis    <> C_Maj->mPopisMaj )   .OR. ;
               ( Maj->cCelek    <> C_Maj->cCelek    )   .OR. ;
               ( Maj->cVykres   <> C_Maj->cVykres   )   .OR. ;
               ( Maj->cUmisteni <> C_Maj->cUmisteni )   .OR. ;
               ( Maj->cVyrCisIM <> C_Maj->cVyrCisIM )
    IF .not. lChange
      RETURN Nil
    ENDIF
  ENDIF
  *
  IF ( lOK := If( lExist, ReplRec( 'C_Maj'), AddRec( 'C_Maj') )  )
//    C_Maj->nInvCis    := Maj->nInvCis
    C_Maj->cNazevMaj  := Maj->cNazev
    C_Maj->cDruhMaj   := 'I '
    C_Maj->nTypMaj    := Maj->nTypMaj
    C_Maj->mPopisMaj  := Maj->mPopis
    C_Maj->cZkratJEDN := 'KS '
    C_Maj->cCelek     := Maj->cCelek
    C_Maj->cVykres    := Maj->cVykres
    C_Maj->cUmisteni  := Maj->cUmisteni
    C_Maj->cVyrCisIM  := Maj->cVyrCisIM
    mh_WRTzmena( 'C_Maj', !lExist )
    C_Maj->( dbUnlock())
  ENDIF

RETURN NIL

********************************************************************************
PROCEDURE xdrgMsgBox(cMsg, nIcoType)
LOCAL oXbp := SetAppFocus()                // save last object in focus
LOCAL cTitle
  DEFAULT nIcoType TO XBPMB_WARNING
* Set default window title for message type
  DO CASE
  CASE nIcoType = XBPMB_WARNING
    cTitle := drgNLS:msg("Warning!")
    Tone(500,3)
  CASE nIcoType = XBPMB_CRITICAL
    cTitle := drgNLS:msg("Error!")
    Tone(150,3)
  OTHERWISE
    cTitle := drgNLS:msg("Message!")
    Tone(500,3)
  ENDCASE

  cMsg := STRTRAN(cMsg,';',CRLF)
  ConfirmBox( , cMsg , cTitle, ;
              XBPMB_OK , ;
              nIcoType + XBPMB_APPMODAL + XBPMB_MOVEABLE )
* Set focus back to last object in focus
  SetAppFocus(oXbp)
RETURN