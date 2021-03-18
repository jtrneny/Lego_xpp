/*==============================================================================
  VYR_Kalkul_scr.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"


function vyr_kalkul_isOk()
  local nretVal := 0, sid := isNull( kalkul->sid, 0)

  if select('pvpitem_ka') = 0
     drgDBMS:open( 'pvpitem',,,,,'pvpitem_ka')
  endif

  nretVal := if( pvpitem_ka->( dbseek( sid,,'KALKUL')), 558, 0 )     


retur nretVal


FUNCTION VYR_StavKALK()
RETURN IF( KALKUL->nStavKALK = -1, MIS_ICON_OK, 0)

********************************************************************************
*
********************************************************************************
CLASS VYR_Kalkul_SCR FROM drgUsrClass
EXPORTED:
  VAR     cCisZakaz, cVyrPol, nVarCis, cFILE, nTypKALK, fromNabVYS
  VAR     dialogTitle

  METHOD  Init, drgDialogStart, drgDialogEnd, EventHandled

  METHOD  Kalkul_COPY          // Kopie kalkulace
  METHOD  KalkToCENIK          // Pøenos kalkulace do ceníku
  METHOD  KalkToNABV           // Pøenos kalkulace do nabídky vystavené
  METHOD  CreateKALKUL         // Automatizované založení a výpoèet kalkulace ( pro nabídky vystavené)

HIDDEN:
  * sys
  var  obro_kalkul

  inline method set_stavKalk()
    local  cMess := 'Promiòte prosím, ' +CRLF +CRLF
    local  cTitl := 'Nastavení akuální kalkulace '
    local  nsel
    *
    local  cid   := strTran( str( kalkul->sID), ' ', '' )
    *
    local cStatement, oStatement
    local stmt := "update kalkul set nstavKalk = iif( sID = %SID, -1, 0 ) where ccisZakaz = '%czak' and cvyrPol = '%cvyr' and nvarCis = %nvar;"

    cMess += 'požadujete nastavit aktuální kalkulaci, ' +CRLF + ;
             'ze dne [ '  + dtoc(kalkul->dDatAktual) +'] poøKalk [ ' +allTrim( str( kalkul->nporKALden)) +' ] ...'

    nsel := ConfirmBox( ,cMess +chr(13) +chr(10), ;
                         cTitl                  , ;
                         XBPMB_YESNO            , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )

    if nsel = XBPMB_RET_YES

      cStatement := strTran( stmt      , '%SID'   , cid                  )
      cStatement := strTran( cStatement, '%czak'  , kalkul->cCisZakaz    )
      cStatement := strTran( cStatement, '%cvyr'  , kalkul->cVyrPOL      )
      cStatement := strTran( cStatement, '%nvar'  , str(kalkul->nVarCis) )

      oStatement := AdsStatement():New(cStatement,oSession_data)

      if oStatement:LastError > 0
*      return .f.
      else
        oStatement:Execute( 'test', .f. )
        oStatement:Close()
      endif

      ::obro_kalkul:refreshAll()
    endif
  return self

ENDCLASS

********************************************************************************
METHOD VYR_Kalkul_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('PrMzdy'  )
  drgDBMS:open('PrMat'   )
  drgDBMS:open('FixNAKL' )
  drgDBMS:open('C_Stred' )
  *
  ::fromNabVYS := ( parent:parent:formName = 'vyr_kustree_scr')

  ::cFILE    := parent:parent:dbName
  ::nTypKALK := IF( ::cFILE = 'VyrPol', KALKUL_PLAN, KALKUL_VYSL )
  ::dialogTitle := IF( ::cFILE = 'VyrPol', 'PLÁNOVÁ kalkulace položky' ,;
                                           'SKUTEÈNÁ kalkulace zakázky' )
RETURN self

********************************************************************************
METHOD VYR_Kalkul_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local cScope

  DO CASE
  CASE nEvent = drgEVENT_DELETE
    VYR_KALKUL_DEL( ::nTypKALK)
    KALKUL->( mh_ClrScope())
    cScope := Upper( ::cCisZakaz) + Upper( ::cVyrPol) + StrZero( ::nVarCis, 3)
    KALKUL->( mh_SetScope( cScope))
    ::drgDialog:dialogCtrl:oaBrowse:refresh()
    RETURN .T.

  case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
    if( kalkul->nstavKalk <> -1 .and. .not. kalkul->( eof()), ::set_stavKalk(), nil )
    return .t.

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD VYR_KALKUL_scr:drgDialogStart(drgDialog)
  LOCAL members  := ::drgDialog:oActionBar:Members, x
  LOCAL cScope

  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ::obro_kalkul := ::drgDialog:dialogCtrl:oBrowse[1]:oxbp
  *
  ::cCisZakaz := (::cFile)->cCisZakaz
  ::cVyrPOL     := (::cFile)->cVyrPOL
  ::nVarCis     := (::cFile)->nVarCis

  cScope := Upper( ::cCisZakaz) + Upper( ::cVyrPol) + StrZero( ::nVarCis, 3)
  KALKUL->( mh_SetScope( cScope))
*  ::drgDialog:dialogCtrl:oBrowse[1]:refresh()
  *
  IF ::nTypKALK = KALKUL_VYSL
    VyrPol->( dbSeek( cScope))

    FOR x := 1 TO LEN( Members)
*      IF 'KALKTOCENIK' $ UPPER(members[x]:event)
      IF UPPER(members[x]:event) $ 'KALKTOCENIK,KALKTONABV'
        members[x]:oXbp:visible := .F.
        members[x]:oXbp:configure()
      ENDIF
    NEXT

  ELSEIF ::nTypKALK = KALKUL_PLAN
*    VyrPol->( dbSeek( cScope))

    FOR x := 1 TO LEN( Members)
      IF UPPER(members[x]:event) $ 'KALKTONABV'
        members[x]:oXbp:visible := ::fromNabVYS
        members[x]:oXbp:configure()
      ENDIF
    NEXT
  ENDIF
  * Jde z nabídek vystavených
  IF ::fromNabVYS
    * a neexistuje žádná kalkulace výrobku
    IF KALKUL->( EOF())
    * pak by se mìla nìjak automatizovanì založit
      ::CreateKALKUL()
    ENDIF
  ENDIF
  ::drgDialog:dialogCtrl:oBrowse[1]:refresh()

RETURN self

********************************************************************************
METHOD VYR_KALKUL_scr:drgDialogEnd(drgDialog)
  KALKUL->( mh_ClrScope())
RETURN

********************************************************************************
METHOD VYR_Kalkul_SCR:Kalkul_COPY()
  LOCAL  oDialog,  nExit
  LOCAL  cTitle := 'Kalkulace položky ... KOPIE'

  oDialog := drgDialog():new('VYR_KALKUL_CRD',self:drgDialog)
  oDialog:cargo := drgEVENT_APPEND2
  oDialog:create( cTitle, self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL

RETURN self

********************************************************************************
METHOD VYR_Kalkul_SCR:KalkToCenik()
LOCAL cKEY, cMsg

  IF ::nTypKalk = KALKUL_PLAN .and. !EMPTY( Kalkul->cVyrPOL)
    cMsg := 'AKTUALIZACE CENÍKU;;Pøenést plánovou kalkulaci do ceníku ?'
    IF drgIsYESNO(drgNLS:msg( cMsg) )
      VYR_KalkToCENIK( VyrPOL->cSklPOL)
    ENDIF
  ENDIF
RETURN self

********************************************************************************
METHOD VYR_Kalkul_SCR:KalkToNabV()
LOCAL cKEY, cMsg, obro, dm, x

  IF ::nTypKalk = KALKUL_PLAN .and. !EMPTY( Kalkul->cVyrPOL)
    cMsg := 'NABÍDKA VYSTAVENÁ;;Pøenést plánovou kalkulaci do nabídky vystavené ?'
    IF drgIsYESNO(drgNLS:msg( cMsg) )
      * pøeneseme kalk.cenu do nabídky
      dm := ::drgDialog:parent:parent:dataManager
      dm:set( 'NabVysITw->nCenaZakl', Kalkul->nCenKalkP)
      * zavøe dialogy Plánové kalkulace + strukturovaný kusovník
      PostAppEvent(xbeP_Close, drgEVENT_QUIT,, ::drgDialog:dialog)
      PostAppEvent(xbeP_Close, drgEVENT_QUIT,, ::drgDialog:parent:dialog)

*      obro := ::drgDialog:parent:dialog:cargo:odbrowse[1]:oXbp
*      SetAppFocus(obro)
*      obro:refreshAll()

    ENDIF
  ENDIF
RETURN self

* Založení a výpoèet kalkulace pro nabídky vystavené
********************************************************************************
METHOD VYR_Kalkul_SCR:CreateKALKUL()
  Local  KalkCMP

  KalkCMP := VYR_KalkHrCMP_CRD():new( ::drgDialog)
  KalkCMP:lKalkPlan  := .T.
  KalkCMP:cFile      := 'VyrPOL'
  KalkCMP:lKalkToCen := .F.
  KalkCMP:nKalkCount := 0
  KalkCMP:fromNabVys := .T.
  *
  KALKULw->cCisZakaz := VyrPOL->cCisZakaz
  KALKULw->cVyrPOL   := VyrPOL->cVyrPOL
  KALKULw->cDruhCeny := '5 '    // '5 ' = nabídková cena
  *
  KalkCMP:KalkCMP_PL_One('NAV')

RETURN self

********************************************************************************
*
********************************************************************************
CLASS VYR_KalkulVP_SCR FROM VYR_Kalkul_SCR

EXPORTED:
  METHOD  Init, drgDialogStart // , drgDialogEnd, EventHandled

*  METHOD  Kalkul_COPY          // Kopie kalkulace
*  METHOD  KalkToCENIK          // Pøenos kalkulace do ceníku

*HIDDEN
*  VAR  cFILE
*  VAR  nTypKALK

ENDCLASS

********************************************************************************
METHOD VYR_KalkulVP_SCR:Init(parent)
  ::VYR_Kalkul_SCR:init(parent)

  ::cFILE       := 'VyrPol'
  ::nTypKALK    := KALKUL_VYSL
  ::dialogTitle := 'SKUTEÈNÁ kalkulace výrobku'

RETURN self

********************************************************************************
METHOD VYR_KalkulVP_scr:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x
  LOCAL cScope

  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ::cCisZakaz := (::cFile)->cCisZakaz
  ::cVyrPOL   := (::cFile)->cVyrPOL
  ::nVarCis   := (::cFile)->nVarCis
  *
  cScope := Upper( ::cVyrPol) + StrZero( ::nVarCis, 3)+ 'VPO'
  KALKUL->( AdsSetOrder( 5) ,;
            mh_SetScope( cScope) )
  ::drgDialog:dialogCtrl:oBrowse[1]:refresh()
  /*
*  IF ::nTypKALK = KALKUL_VYSL
*    VyrPol->( dbSeek( cScope))
  *
    FOR x := 1 TO LEN( Members)
      IF 'KALKTOCENIK' $ UPPER(members[x]:event)
        members[x]:oXbp:visible := .F.
        members[x]:oXbp:configure()
      ENDIF
    NEXT
*  ENDIF
  */
RETURN self