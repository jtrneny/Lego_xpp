#include "appevent.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

#define  _VSECHNY     1
#define  _VYKRYTE     2
#define  _NEVYKRYTE   3

********************************************************************************
* Objednávky pøijaté dle zakázek
********************************************************************************
CLASS VYR_ObjItem_ZAK_scr FROM drgUsrClass
EXPORTED
  VAR     lDataFilter
  METHOD  Init, drgDialogStart, drgDialogEnd, ItemMarked, ComboItemSelected

  inline access assign method ObjVykryta() var ObjVykryta
    return if(ObjITEM->nMnozVpInt > 0, MIS_ICON_OK, 0)

HIDDEN
  VAR     mainBro
ENDCLASS

********************************************************************************
METHOD VYR_ObjItem_ZAK_scr:Init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('VYRZAK' )
  ::lDataFilter := _VSECHNY
RETURN self

********************************************************************************
METHOD VYR_ObjItem_ZAK_scr:drgDialogStart(drgDialog)

*   ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
   *
   ::mainBro := drgDialog:odBrowse[1]
   OBJZAK->( DbSetRelation( 'VyrZAK', {|| Upper(OBJZAK->cCisZakaz)  },'Upper(OBJZAK->cCisZakaz)'))
RETURN self

********************************************************************************
METHOD VYR_ObjItem_ZAK_scr:drgDialogEnd( drgDialog)
  OBJZAK->( dbClearRelation())
RETURN

********************************************************************************
METHOD VYR_ObjItem_ZAK_scr:ItemMarked()
  Local cScope := Upper( ObjITEM->cCislObInt) + StrZero( ObjITEM->nCislPolOb, 5)

  OBJZAK->( mh_SetScope( cScope))
RETURN SELF

********************************************************************************
METHOD VYR_ObjItem_ZAK_scr:comboItemSelected( Combo)
  Local Filter

  ::lDataFilter := Combo:value
  Do Case
  Case ::lDataFilter = _VSECHNY
    IF( EMPTY(ObjITEM->(ads_getAof())), NIL, ObjITEM->(ads_clearAof(),dbGoTop()) )

  Case ::lDataFilter = _VYKRYTE
    Filter := "nMnozVpInt > 0"
    ObjITEM->( mh_SetFilter( Filter))

  Case ::lDataFilter = _NEVYKRYTE
    Filter := "nMnozVpInt = 0"
    ObjITEM->( mh_SetFilter( Filter))
  EndCase
  *
  ::mainBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::mainBro:oxbp)
  SetAppFocus(::mainBro:oXbp)

RETURN .T.