#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************NEW
* SKL_PVPHEAD_SCR ... Pohybové doklady - dle dokladù
********************************************************************************
CLASS SKL_PVPHead_SCR FROM drgUsrClass

EXPORTED:
  VAR     parentFRM
  VAR     cfg_cDenik, cVarSym
  METHOD  Init, drgDialogStart, drgDialogEnd, HeadMarked, ItemMarked, EventHandled, tabSelect
  METHOD  PARUJ_VS_PRIJEM, PARUJ_VS_VYDEJ
HIDDEN:
  VAR     dc, df
  var     tabNum, abMembers
  var     obtn_PARUJ_VS_PRIJEM, obtn_PARUJ_VS_VYDEJ, obtn_STORNO_VYDEJ

********************************************************************************
  INLINE METHOD  UcetPol_Item()
    UCETPOL->( mh_ClrScope(),;
               mh_SetScope(Upper( ::cfg_cDenik) + StrZero( PVPITEM->nDoklad, 10) + StrZero( PVPITEM->nOrdItem, 5 )))
  RETURN self
********************************************************************************
  INLINE METHOD  UcetPol_Doklad()
    UCETPOL->( mh_ClrScope(),;
               mh_SetScope(Upper( ::cfg_cDenik) + StrZero( PVPITEM->nDoklad, 10)))
  RETURN self

ENDCLASS

*
********************************************************************************
METHOD SKL_PVPHead_SCR:init(parent)
  *
  ::drgUsrClass:init(parent)
  drgDBMS:open('PVPITEM')
  drgDBMS:open('PVPHEAD')
  drgDBMS:open('C_DRPOHY')
  drgDBMS:open('C_DPH')
  drgDBMS:open('C_TYPPOH')
  drgDBMS:open('VYRCIS')
  drgDBMS:open('CENZBOZ')
  *
  ::parentFRM  := parent:parent:formName
  ::cfg_cDenik := Padr( AllTrim( SysConfig( 'Sklady:cDenik')),2)
  ::cVarSym    := ''
RETURN self

********************************************************************************
METHOD SKL_PVPHead_SCR:drgDialogStart(drgDialog)
  local  x

  ::dc             := drgDialog:dialogCtrl              // dataCtrl
  ::df             := drgDialog:oForm                   // form

  ::abMembers := drgDialog:oActionBar:Members
  ColorOfTEXT( ::dc:members[1]:aMembers )
  SEPARATORs( ::abMembers)

  for x := 1 to len(::abMembers) step 1
    do case
    case ::abMembers[x]:event $ 'PARUJ_VS_PRIJEM' ; ::obtn_PARUJ_VS_PRIJEM := ::abMembers[x]
    case ::abMembers[x]:event $ 'PARUJ_VS_VYDEJ'  ; ::obtn_PARUJ_VS_VYDEJ  := ::abMembers[x]
    case ::abMembers[x]:event $ 'STORNO_VYDEJ'    ; ::obtn_STORNO_VYDEJ    := ::abMembers[x]
    endcase
  next

  ::tabNum := 1
  * Pohyby  jsou volány tlaèítkem pohyby z obrazovky ceníku zboží
  IF ::parentFRM = 'skl_cenzboz_scr'
    PVPITEM->( DbClearRelation())
  endif
  *
  PVPHEAD->( DbSetRelation( 'C_TypPoh', { || UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU) },;
                                            'UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU)', 'C_TYPPOH06'))
  PVPITEM->( DbSetRelation( 'C_DPH', { || PVPITEM->nKlicDPH },'PVPITEM->nKlicDPH'))
  PVPITEM ->( AdsSetOrder( 'PVPITEM02'))

RETURN


METHOD SKL_PVPHEAD_SCR:drgDialogEnd(drgDialog)

  IF ::parentFRM = 'skl_cenzboz_scr'
    PVPITEM->( DbClearRelation())
    PVPITEM->( DbSetRelation( 'C_DRPOHY', { || PVPITEM->nCislPoh } ,'PVPITEM->nCislPoh' ))
    PVPITEM->( DbSetRelation( 'PVPHEAD',  { || PVPITEM->nDoklad }  ,'PVPITEM->nDoklad' ))
  ENDIF
RETURN self


METHOD SKL_PVPHead_SCR:HeadMarked()
  Local lOk := PVPHEAD->nTypPoh <> 1
  Local lPrijem := PVPHEAD->nTypPoh = 1, lVydej := PVPHEAD->nTypPoh = 2
  *
  local   filter
  local m_filter := "nPVPHEAD = %%"

*  zatítm vypneme
*  filter := format( m_filter, { pvpHead->sID } )
*  pvpItem->( ads_setAof(filter), dbgoTop() )

  PVPITEM ->( mh_SetScope( Upper( PVPHEAD->cCisSklad) + StrZERO(PVPHEAD->nDoklad,10)) )
  IF( ::tabNum = 4, ::UcetPol_Item(), ::UcetPol_Doklad() )
  *
  do case
  case lPrijem
    ::obtn_PARUJ_VS_PRIJEM:oxbp:enable()
    ::obtn_PARUJ_VS_VYDEJ:oxbp:disable()
  case lVydej
    ::obtn_PARUJ_VS_PRIJEM:oxbp:disable()
    ::obtn_PARUJ_VS_VYDEJ:oxbp:enable()
  otherwise
    ::obtn_PARUJ_VS_PRIJEM:oxbp:disable()
    ::obtn_PARUJ_VS_VYDEJ:oxbp:disable()
  endcase

  if empty(pvpHead->csubTask) .and. left(pvpHead->ctypDoklad,7) = 'SKL_VYD'
    ::obtn_STORNO_VYDEJ:oxbp:enable()
  else
    ::obtn_STORNO_VYDEJ:oxbp:disable()
  endif
RETURN SELF


METHOD SKL_PVPHead_SCR:ItemMarked()
  ::UcetPol_Item()
  *
RETURN SELF

********************************************************************************
METHOD SKL_PVPHead_SCR:tabSelect( tabPage, tabNumber)
  *
  ::tabNUM := tabNumber
  IF( ::tabNum = 4, ::UcetPol_Item(),;
  IF( ::tabNum = 5, ::UcetPol_Doklad(), NIL))

  if( ::tabNum = 1 .or. ::tabNum = 2, ::obtn_STORNO_VYDEJ:oxbp:show(), ::obtn_STORNO_VYDEJ:oxbp:hide() )
RETURN .T.

********************************************************************************
METHOD SKL_PVPHead_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  *
  DO CASE
    CASE nEvent = drgEVENT_APPEND
      IF  Skl_allOK( .T. ,, 'PVPHEAD', 'PVPITEM' )
        RETURN .F.
      ENDIF

    CASE nEvent = drgEVENT_DELETE
      SKL_DelDoklad( 'PVPHEAD', 'PVPITEM')
      ::dc:oBrowse[1]:oXbp:refreshAll()
      postAppEvent(xbeBRW_ItemMarked,,,::dc:obrowse[1]:oxbp)

    CASE nEvent = drgEVENT_EDIT
      IF PVPHEAD->cTypDoklad = 'SKL_PRE305' .and. PVPHEAD->cTypPohybu = '40'
      drgMsgBox(drgNLS:msg( ;
        'NELZE OPRAVIT !;;'+ ;
        'Pohyb 40 je modifikován automatizovanì pøi modifikaci pohybu 80 - pøevod mezi støedisky !'), XBPMB_CRITICAL )
      ELSE
        RETURN .F.
      END

    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_PVPHead_SCR:Paruj_VS_PRIJEM()
  Paruj_VS( ::drgDialog, 'SKL_PAROVANI_VSprijem')
RETURN self

********************************************************************************
METHOD SKL_PVPHead_SCR:Paruj_VS_VYDEJ()
  Paruj_VS( ::drgDialog, 'SKL_PAROVANI_VSvydej')
RETURN self

*===============================================================================
FUNCTION Paruj_VS( dialog, cNameFRM)
  LOCAL oDialog, nExit

*  oDialog := drgDialog():new('SKL_PAROVANI_VS', dialog)
  oDialog := drgDialog():new(cNameFRM, dialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  oDialog:destroy(.T.)
  oDialog := Nil

RETURN NIL


********************************************************************************
* SKL_PVPITEM_SCR ... Pohybové doklady - dle položek
********************************************************************************
CLASS SKL_PVPItem_SCR FROM drgUsrClass
EXPORTED:
  VAR     cfg_cDenik
  METHOD  Init, drgDialogStart, EventHandled, itemMarked, tabSelect
HIDDEN
  VAR     dc, tabNum
ENDCLASS

*****************************************************************
METHOD SKL_PVPItem_SCR:init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('PVPITEM')
  drgDBMS:open('PVPHEAD')
  drgDBMS:open('C_DRPOHY')
  drgDBMS:open('C_DPH')
  drgDBMS:open('C_TYPPOH')
  *
  ::cfg_cDenik := SysConfig( 'Sklady:cDenik')
  *
  PVPITEM->( DbSetRelation( 'C_DRPOHY', { || PVPITEM->nCislPoh },'PVPITEM->nCislPoh'))
  PVPITEM->( DbSetRelation( 'C_DPH', { || PVPITEM->nKlicDPH },'PVPITEM->nKlicDPH'))
  PVPITEM->( AdsSetOrder('PVPITEM05'))
  PVPHEAD->( DbSetRelation( 'C_TypPoh', { || UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU) },;
                                            'UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU)', 'C_TYPPOH06'))
RETURN self

********************************************************************************
METHOD SKL_PVPItem_SCR:drgDialogStart(drgDialog)

  ::dc  := drgDialog:dialogCtrl
  ColorOfTEXT( ::dc:members[1]:aMembers )
  ::tabNum := 1
RETURN

********************************************************************************
METHOD SKL_PVPItem_SCR:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE nEvent = drgEVENT_DELETE
     X := 1
    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_PVPItem_SCR:ItemMarked()
  Local cKey := Upper( ::cfg_cDenik) + StrZero( PVPITEM->nDoklad, 10)
  *
  cKey += IF( ::tabNum = 2, StrZero( PVPITEM->nOrdItem, 5 ), '' )
  UCETPOL->( mh_ClrScope())
  IF ::tabNum = 2 .or. ::tabNum = 4
     UCETPOL->( mh_SetScope( cKey))
  ENDIF
  PVPHead->( dbSeek( PVPITEM->nDoklad,, 'PVPHEAD01'))
RETURN SELF

********************************************************************************
METHOD SKL_PVPItem_SCR:tabSelect( tabPage, tabNumber)
  *
  ::tabNUM := tabNumber
  ::itemMarked()
RETURN .T.

/*
FUNCTION FIRMA_toPVPITEM()
  Local cScope
  Local cTagH := PVPHEAD->( AdsSetOrder( 0)), nRecH := PVPHEAD->( RecNO())
  Local cTagI := PVPITEM->( AdsSetOrder( 5)), nRecI := PVPITEM->( RecNO())
  Local lHD, lIT

  lHD := PVPHead->( FLOCK())
  lIT := PVPITEM->( FLOCK())

  IF lHD .and. lIT

    IF drgIsYESNO(drgNLS:msg('Aktualizovat PVPITEM ?'))
      PVPHEAD->( dbGoTOP())
      DO WHILE !PVPHEAD->( Eof())
        IF PVPHead->nCisFirmy <> 0
          PVPItem->( mh_SetSCOPE( PVPHead->nDoklad))
          DO WHILE ! PVPITEM->( EOF())
            PVPItem->nCisFirmy := PVPHead->nCisFirmy
            PVPItem->( dbSkip())
          ENDDO
          PVPItem->( mh_ClrSCOPE())
        ENDIF
        PVPHead->( dbSkip())
      ENDDO
      drgMsgBox(drgNLS:msg( 'KONEC ...'))
    ENDIF
  ENDIF

  IF( lHD, PVPHead->( dbUnlock()), Nil )
  IF( lIT, PVPItem->( dbUnlock()), Nil )
  *
  PVPHead->( AdsSetOrder( cTagH), dbGoTO( nRecH) )
  PVPITEM->( AdsSetOrder( cTagI), dbGoTO( nRecI) )

RETURN NIL
*/