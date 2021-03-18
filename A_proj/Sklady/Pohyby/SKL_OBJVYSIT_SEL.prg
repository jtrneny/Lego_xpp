********************************************************************************
*
* SKL_OBJVYSIT_SEL.PRG
*
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


********************************************************************************
* SKL_OBJVYSIT_SEL ...
********************************************************************************
CLASS SKL_OBJVYSIT_SEL FROM drgUsrClass

EXPORTED:
  VAR     lDataFilter, mainBro

  METHOD  Init, EventHandled, drgDialogStart, drgDialogEnd, comboItemSelected
  METHOD  ItemMarked

  * objvysit
  inline access assign method stav_objvysit() var stav_objvysit
    local retVal := 0

    do case
    case(objvysit->nmnozpldod = 0                    )  ;  retVal :=   0
    case(objvysit->nmnozpldod >= objvysit->nmnozobdod)  ;  retVal := 302
    case(objvysit->nmnozpldod <  objvysit->nmnozobdod)  ;  retVal := 303
    endcase
    return retVal
ENDCLASS

********************************************************************************
METHOD SKL_OBJVYSIT_SEL:init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('OBJVYSIT')
  drgDBMS:open('OBJVYSHD')
  *
  ::lDataFilter   := 2
RETURN self

********************************************************************************
METHOD SKL_OBJVYSIT_SEL:drgDialogStart(drgDialog)

  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  *
  ::mainBro := drgDialog:odBrowse[1]
*  ObjVysIT->( mh_SetFilter( 'nmnozpldod =  0'))    // jen nevykryté obj.
  *
RETURN self

********************************************************************************
METHOD SKL_OBJVYSIT_SEL:drgDialogEnd( drgDialog)
*  ObjVysIT->( mh_ClrFilter())
RETURN

********************************************************************************
METHOD SKL_OBJVYSIT_SEL:ItemMarked()
*  Local cKey := Upper( (::IT)->cCisSklad) +  Upper( (::IT)->cSklPol)
  ObjVysHD->( dbSeek( StrZero( ObjVysIT->nCisFirmy, 5) + Upper( ObjVysIT->cCisObj),,'OBJDODH2'))

RETURN self

********************************************************************************
METHOD SKL_OBJVYSIT_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
*    ::recordEdit()

  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

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
METHOD SKL_OBJVYSIT_SEL:comboItemSelected( Combo)
  Local Filter

  ::lDataFilter := Combo:value
  Do Case
  Case Combo:value = 1             // Všechny objednávky vystavené
    IF( EMPTY(ObjVysIT->(ads_getAof())), NIL, ObjVysIT->(ads_clearAof(),dbGoTop()) )
  Case Combo:value = 2             // Nevykryté všechny ( nevykr.zcela + èást.vykryté )
    Filter := "(nmnozpldod =  0 .or. (nmnozpldod <> 0 .and. nmnozpldod < nmnozobdod))"
  Case Combo:value = 3             // Jen Nevykryté zcela
    Filter := "nmnozpldod =  0"
  Case Combo:value = 4             // Èásteènì vykryté
    Filter := "nmnozpldod <> 0 .and. nmnozpldod < nmnozobdod"
  Case Combo:value = 5             // Vykryté zcela
    Filter := "nmnozpldod <> 0 .and. nmnozpldod >= nmnozobdod"
  EndCase
*  IF Combo:value > 1, ObjVysIT->( mh_SetFilter( Filter)), Nil )
  IF Combo:value = 1
    Filter := FORMAT( "StrZero(nCisFirmy,5) = '%%'", {StrZero( PVPHeadw->nCisFirmy,5)})
  ELSE
    Filter := FORMAT( "StrZero(nCisFirmy,5) = '%%' .and." + Filter, {StrZero( PVPHeadw->nCisFirmy,5)})
  ENDIF
  ObjVysIT->( mh_SetFilter( Filter))
  *
  ::ItemMarked()
  ::mainBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::mainBro:oxbp)
  SetAppFocus(::mainBro:oXbp)

RETURN .T.