
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Xbp.ch"
#include "Gra.ch"

#Define   VYBER_SETRENI_SKOT     1
#Define   VYBER_SETRENI_PRAS     2

*===============================================================================
FUNCTION ZVI_TypNAPOC()
*  Local acText := { 'Kusy      ', 'Množství  ', 'Cena      ', 'Krmné dny ' }
  Local acText := { 'Kusy', 'Množství', 'Cena', 'Krmné dny' }
  Local cText

  cText := IF( C_Vykazy->nTypNapoc == 0, 'Mezisouèet',;
                                         acText[ C_Vykazy->nTypNapoc] )
RETURN PADR( cText, 10)

*
********************************************************************************
CLASS ZVI_Vykazy_SCR FROM drgUsrClass
EXPORTED:
  VAR     lDataFilter

  METHOD  Init, drgDialogStart, EventHandled
  METHOD  ComboItemSelected

HIDDEN
  VAR     dm, dc
ENDCLASS

*
********************************************************************************
METHOD ZVI_Vykazy_SCR:init(parent)
  ::drgUsrClass:init(parent)
  *
  ::lDataFilter := VYBER_SETRENI_SKOT
RETURN self

********************************************************************************
METHOD ZVI_Vykazy_SCR:drgDialogStart(drgDialog)
  Local Filter

*  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ::dm  := drgDialog:dataManager
  ::dc  := drgDialog:dialogCtrl
  *
  Filter := "nVykaz = %%"
  Filter := Format( Filter,{ ::lDataFilter})
  C_Vykazy->( mh_SetFilter( Filter))
RETURN self

********************************************************************************
METHOD ZVI_Vykazy_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
    CASE nEvent = drgEVENT_DELETE
    CASE nEvent = drgEVENT_APPEND
    CASE nEvent = drgEVENT_EDIT
      ::drgDialog:oForm:setNextFocus( 'C_Vykazy->cNazRadek',, .t. )
*      ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
    CASE nEvent = xbeP_Keyboard
        IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
          IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
            oXbp:setColorBG( oXbp:cargo:clrFocus )
          ENDIF
          *
          SetAppFocus(::dc:oaBrowse:oXbp)
          ::dm:refresh()
          ::dc:isAppend := .F.
          RETURN .T.
        ELSE
          RETURN .F.
        ENDIF
    CASE  nEvent = drgEVENT_SAVE
      IF C_Vykazy->( dbRLock())
        ::dm:save()
        C_Vykazy->( dbRUnLock())
        ::dc:oaBrowse:refresh()
        SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
        ::dm:refresh()
        IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
          oXbp:setColorBG( oXbp:cargo:clrFocus )
        ENDIF
      ELSE

      ENDIF

    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD ZVI_Vykazy_SCR:comboItemSelected( Combo)

  IF( EMPTY(C_Vykazy->(ads_getAof())), NIL, C_Vykazy->(mh_ClrFilter()) )
  ::lDataFilter := Combo:value
  Filter := "nVykaz = %%"
  Filter := Format( Filter,{ ::lDataFilter})
  C_Vykazy->( mh_SetFilter( Filter))
  *
  ::drgDialog:odBrowse[1]:oxbp:refreshAll()
*  PostAppEvent(xbeBRW_ItemMarked,,,drgDialog:odBrowse[1]:oxbp)
  SetAppFocus(::drgDialog:odBrowse[1]:oXbp)

RETURN .T.


