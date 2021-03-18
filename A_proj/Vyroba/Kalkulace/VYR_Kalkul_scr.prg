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
  METHOD  KalkToCENIK          // P�enos kalkulace do cen�ku
  METHOD  KalkToNABV           // P�enos kalkulace do nab�dky vystaven�
  METHOD  CreateKALKUL         // Automatizovan� zalo�en� a v�po�et kalkulace ( pro nab�dky vystaven�)

HIDDEN:
  * sys
  var  obro_kalkul

  inline method set_stavKalk()
    local  cMess := 'Promi�te pros�m, ' +CRLF +CRLF
    local  cTitl := 'Nastaven� aku�ln� kalkulace '
    local  nsel
    *
    local  cid   := strTran( str( kalkul->sID), ' ', '' )
    *
    local cStatement, oStatement
    local stmt := "update kalkul set nstavKalk = iif( sID = %SID, -1, 0 ) where ccisZakaz = '%czak' and cvyrPol = '%cvyr' and nvarCis = %nvar;"

    cMess += 'po�adujete nastavit aktu�ln� kalkulaci, ' +CRLF + ;
             'ze dne [ '  + dtoc(kalkul->dDatAktual) +'] po�Kalk [ ' +allTrim( str( kalkul->nporKALden)) +' ] ...'

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
  ::dialogTitle := IF( ::cFILE = 'VyrPol', 'PL�NOV� kalkulace polo�ky' ,;
                                           'SKUTE�N� kalkulace zak�zky' )
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
  * Jde z nab�dek vystaven�ch
  IF ::fromNabVYS
    * a neexistuje ��dn� kalkulace v�robku
    IF KALKUL->( EOF())
    * pak by se m�la n�jak automatizovan� zalo�it
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
  LOCAL  cTitle := 'Kalkulace polo�ky ... KOPIE'

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
    cMsg := 'AKTUALIZACE CEN�KU;;P�en�st pl�novou kalkulaci do cen�ku ?'
    IF drgIsYESNO(drgNLS:msg( cMsg) )
      VYR_KalkToCENIK( VyrPOL->cSklPOL)
    ENDIF
  ENDIF
RETURN self

********************************************************************************
METHOD VYR_Kalkul_SCR:KalkToNabV()
LOCAL cKEY, cMsg, obro, dm, x

  IF ::nTypKalk = KALKUL_PLAN .and. !EMPTY( Kalkul->cVyrPOL)
    cMsg := 'NAB�DKA VYSTAVEN�;;P�en�st pl�novou kalkulaci do nab�dky vystaven� ?'
    IF drgIsYESNO(drgNLS:msg( cMsg) )
      * p�eneseme kalk.cenu do nab�dky
      dm := ::drgDialog:parent:parent:dataManager
      dm:set( 'NabVysITw->nCenaZakl', Kalkul->nCenKalkP)
      * zav�e dialogy Pl�nov� kalkulace + strukturovan� kusovn�k
      PostAppEvent(xbeP_Close, drgEVENT_QUIT,, ::drgDialog:dialog)
      PostAppEvent(xbeP_Close, drgEVENT_QUIT,, ::drgDialog:parent:dialog)

*      obro := ::drgDialog:parent:dialog:cargo:odbrowse[1]:oXbp
*      SetAppFocus(obro)
*      obro:refreshAll()

    ENDIF
  ENDIF
RETURN self

* Zalo�en� a v�po�et kalkulace pro nab�dky vystaven�
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
  KALKULw->cDruhCeny := '5 '    // '5 ' = nab�dkov� cena
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
*  METHOD  KalkToCENIK          // P�enos kalkulace do cen�ku

*HIDDEN
*  VAR  cFILE
*  VAR  nTypKALK

ENDCLASS

********************************************************************************
METHOD VYR_KalkulVP_SCR:Init(parent)
  ::VYR_Kalkul_SCR:init(parent)

  ::cFILE       := 'VyrPol'
  ::nTypKALK    := KALKUL_VYSL
  ::dialogTitle := 'SKUTE�N� kalkulace v�robku'

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