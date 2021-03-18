/*==============================================================================
  VYR_VyrZakIT_SCR2.PRG                    ... Položky výrobních zakázek
==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

*===============================================================================
FUNCTION VyrZAKITis_U()
RETURN if(VyrZakIt->cStavZakaz = 'U', MIS_ICON_OK, 0)

********************************************************************************
CLASS VYR_VyrZakIT_SCR2 FROM VYR_VyrZakIT_SCR
EXPORTED:
  METHOD  Init, destroy, drgDialogStart, drgDialogEnd, EventHandled, ItemMarked
  METHOD  ZAKIT_ukoncit, ZAKIT_Copy, ZAKIT_Open

ENDCLASS

********************************************************************************
METHOD VYR_VyrZakIT_SCR2:init(parent)
  *
  ::VYR_VyrZakIT_SCR:init(parent)
  *
  drgDBMS:open('VYRZAK' )
  drgDBMS:open('VYRPOL' )
  drgDBMS:open('LISTHD' )
  drgDBMS:open('KusTREE' ,.T.,.T.,drgINI:dir_USERfitm)

RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_SCR2:destroy()
  ::VYR_VyrZakIT_SCR:destroy()
RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_SCR2:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members

  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  *
  SEPARATORs( members)
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  *
  drgDialog:odBrowse[2]:oxbp:refreshAll()
  drgDialog:odBrowse[1]:oxbp:refreshAll()
  *
  IsEditGet( { 'nOrdItem', 'cVyrobCisl'}, drgDialog, .F. )
RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_SCR2:drgDialogEnd(drgDialog)
  *
RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_SCR2:EventHandled(nEvent, mp1, mp2, oXbp)
  Local lOK, oDialog, nExit, nRec
  Local cFile

  DO CASE
  CASE  nEvent = drgEVENT_APPEND
    cFile := ::dc:oaBrowse:cFile
    IF cFile = 'VyrZakIT'
       drgMsgBox(drgNLS:msg('Na této obrazovce nelze vkládat položky zakázky ...'))
       RETURN .T.
    ELSEIF cFile = 'PolOper'
      ::PolOPER_CRD( nEvent)
      RETURN .T.
    ENDIF
    *
  CASE  nEvent = drgEVENT_EDIT
    cFile := ::dc:oaBrowse:cFile
    IF cFile = 'VyrZakIT'
       RETURN .F.
    ELSEIF cFile = 'PolOper'
      ::PolOPER_CRD( nEvent)
      RETURN .T.
    ENDIF

  CASE nEvent = xbeP_SetDisplayFocus
    ::sumColOper()
  *
  OTHERWISE
    RETURN .F.
  ENDCASE
*
RETURN .F.

********************************************************************************
METHOD VYR_VyrZakIT_SCR2:ItemMarked()
  Local cKey := Upper( VyrZAKIT->cCisZakaz) + Upper( VyrZAKIT->cVyrPol)

  VYRZAK->( dbSEEK( cKey + StrZero( VyrZakIT->nVarCis, 3) ,, 'VYRZAK1'))
  PolOPER->( mh_SetScope( cKey + StrZero( VyrZakIT->nOrdItem, 3)))
  ::sumColOper()
RETURN SELF

********************************************************************************
METHOD VYR_VyrZAKIT_SCR2:ZAKIT_Copy()
  LOCAL oDialog
  *
  PostAppEvent(drgEVENT_APPEND2,,,::drgDialog:dialogCtrl:oBrowse[1]:oXbp)
RETURN self

********************************************************************************
METHOD VYR_VyrZAKIT_SCR2:ZAKIT_ukoncit()
  Local oDialog, nExit
  Local cStav := AllTrim( Upper( VyrZakIT->cStavZakaz))
  /*
  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  */
  DRGDIALOG FORM 'VYR_VYRZAKIT_UKONC' PARENT ::drgDialog DESTROY EXITSTATE nExit
  IF ( nExit != drgEVENT_QUIT )
    ::drgDialog:dialogCtrl:oaBrowse:refresh()
    ::drgDialog:dataManager:refresh()
  ENDIF

RETURN self

********************************************************************************
METHOD VYR_VyrZAKIT_SCR2:ZAKIT_OPEN()
  Local oDialog, nExit
  Local cStav := AllTrim( Upper( VyrZakIT->cStavZakaz))
  *
  IF cStav <> 'U'
    drgMsgBox(drgNLS:msg('NELZE OTEVØÍT !;;Položka zakázky není v odpovídajícím stavu !!!'))
    RETURN self
  ENDIF
  * Znovu otevøít lze jen položku zakázky uzavøenou, tedy ve stavu 'U'
  DRGDIALOG FORM 'VYR_VYRZAKIT_OPEN' PARENT ::drgDialog DESTROY ;
                                     EXITSTATE nExit
  ::drgDialog:dialogCtrl:oaBrowse:refresh()
  ::drgDialog:dataManager:refresh()

RETURN self


********************************************************************************
* VYR_VYRZAKIT_UKONC ...
********************************************************************************
CLASS VYR_VYRZAKIT_UKONC FROM drgUsrClass

EXPORTED:
  VAR     dUzavZAKA
  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled, PostLastField
ENDCLASS

********************************************************************************
METHOD VYR_VYRZAKIT_UKONC:init(parent)
  ::drgUsrClass:init(parent)
  ::dUzavZAKA := IF( EMPTY( VyrZAKIT->dUzavZAKA), DATE(), VyrZAKIT->dUzavZAKA )
RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_UKONC:drgDialogInit(drgDialog)
  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_UKONC:drgDialogStart(drgDialog)
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
RETURN self

********************************************************************************
METHOD VYR_VYRZAKIT_UKONC:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT   //.or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD VYR_VYRZAKIT_UKONC:postLastField(drgVar)
  LOCAL dm := ::drgDialog:DataManager
  Local aRecIT := {}, nRecIT := VyrZAKIT->( RecNo()), lUzvIT := .t.
  Local LockZak := VyrZAK->( dbRLock()), LockZakIT := VyrZAKIT->( dbRLock())
  *
  IF LockZak .and. LockZakIT
    dm:save()
    *
    VyrZakIT->dZnovuOtvZ := CTOD('  .  .  ')
    VyrZakIT->cStavZakUz := VyrZakIT->cStavZakaz  // uložíme stav pol.zak. pøed uzavøením

    VyrZakIT->cStavZakaz := 'U'
    VyrZakIT->dUzavZAKA  := ::dUzavZAKA
    VyrZakIT->nRok       := YEAR( ::dUzavZAKA)
    VyrZakIT->nObdobi    := MONTH( ::dUzavZAKA)
    *
    mh_WRTzmena( 'VYRZAKIT', .F.)
    * zjistíme, zda náhodou nejsou uzavøeny i ostatní položky zakázky
    VyrZakIT->( AdsSetOrder(1), mh_SetSCOPE( Upper(VyrZAK->cCisZakaz)) )
    VyrZakIT->( dbEVAL( {|| lUzvIT := IF( VyrZakIT->cStavZakaz = 'U', lUzvIT, .F. )  }))
    VyrZakIT->( mh_ClrScope(), dbGoTo( nRecIT))
    * pokud jsou, uzavøeme i hlavièku, tedy VyrZAK
    IF lUzvIT
      VyrZak->dZnovuOtvZ := CTOD('  .  .  ')
      VyrZak->cStavZakUz := VyrZak->cStavZakaz  // uložíme stav zak. pøed uzavøením
      VyrZak->cStavZakaz := 'U'
      VyrZak->dUzavZAKA  := ::dUzavZAKA
      VyrZak->nRok       := YEAR( ::dUzavZAKA)
      VyrZak->nObdobi    := MONTH( ::dUzavZAKA)
      mh_WRTzmena( 'VYRZAK', .F.)
    ENDIF
    VyrZAK->( dbUnlock())
    VyrZAKIT->( dbUnlock())
    *
    PostAppEvent(xbeP_Close, drgEVENT_SAVE,,::drgDialog:dialog)
  ELSE
    drgMsgBox(drgNLS:msg('POLOŽKU ZAKÁZKY se nepodaøilo ukonèit,;'+;
                         'nebo související záznamy jsou blokovány jiným uživatelem !!!'))
    IF( LockZak  , VyrZAK->( dbUnlock())  , Nil )
    IF( LockZakIT, VyrZAKIT->( dbUnlock()), Nil )
  ENDIF

RETURN .T.


********************************************************************************
* VYR_VYRZAK_OPEN ...  Znovuotevøení uzavøené zakázky
********************************************************************************
CLASS VYR_VYRZAKIT_OPEN FROM drgUsrClass

EXPORTED:
  VAR     cCisZakazI, cNazevZak1, dZnovuOtvZ
  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled
  METHOD  PostLastField

HIDDEN:
  VAR     dm
ENDCLASS

********************************************************************************
METHOD VYR_VYRZAKIT_OPEN:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('VYRZAK'  )
  drgDBMS:open('VYRZAKIT')
  *
  ::cCisZakazI := VYRZAKIT->cCisZakazI   //''
  ::cNazevZak1 := VYRZAKIT->cNazevZak1  //''
  ::dZnovuOtvZ := IF( EMPTY( VYRZAKIT->dZnovuOtvZ), DATE(), VYRZAKIT->dZnovuOtvZ )
RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_OPEN:drgDialogInit(drgDialog)
  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_OPEN:drgDialogStart(drgDialog)

 ::dm := drgDialog:dataManager
 IsEditGET(  {'M->cCisZakazI', 'M->cNazevZak1'}, drgDialog, .F.)
RETURN self

********************************************************************************
METHOD VYR_VYRZAKIT_OPEN:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD VYR_VYRZAKIT_OPEN:postLastField(drgVar)
  Local LockZAK, LockZakIT
  *
  LockZak   := VyrZAK->( dbRLock())
  LockZakIT := VyrZAKIT->( dbRLock())
  *
  IF LockZak .and. LockZakIT
    IF drgIsYesNo(drgNLS:msg( 'Požadujete ukonèenou položku zakázky znovu otevøít ?' ))
      ::dm:save()
      * Znovuotevøení hlavièky zakázky
      VyrZak->cStavZakaz := CoalesceEmpty( VyrZak->cStavZakUz, '4')
      VyrZak->dZnovuOtvZ := ::dZnovuOtvZ
      VyrZak->cStavZakUz := ''

      VyrZak->dUzavZAKA  := CTOD('  .  .  ')
      VyrZak->nRok       := 0
      VyrZak->nObdobi    := 0
      mh_WRTzmena( 'VYRZAK', .F.)
      * Znovuotevøení položky zakázky
      VyrZakIT->cStavZakaz := VyrZak->cStavZakaz
      VyrZakIT->dZnovuOtvZ := ::dZnovuOtvZ
      VyrZakIT->cStavZakUz := ''

      VyrZakIT->dUzavZAKA  := VyrZAK->dUzavZAKA
      VyrZakIT->nRok       := VyrZAK->nRok
      VyrZakIT->nObdobi    := VyrZAK->nObdobi
      mh_WRTzmena( 'VYRZAKIT', .F.)

      VyrZAK->( dbUnlock())
      VyrZAKIT->( dbUnlock())
    ENDIF
      *
  ELSE
    drgMsgBox(drgNLS:msg('POLOŽKU ZAKÁZKY se nepodaøilo znovu otevøít,;'+;
                         'nebo související záznamy jsou blokovány jiným uživatelem !!!'))
    IF( LockZak  , VyrZAK->( dbUnlock())  , Nil )
    IF( LockZakIT, VyrZAKIT->( dbUnlock()), Nil )
  ENDIF
  *
  PostAppEvent(xbeP_Close, drgEVENT_SAVE,,::drgDialog:dialog)
RETURN .T.


