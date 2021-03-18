
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
* SKL_OBJITEM_SEL ...
********************************************************************************
CLASS SKL_OBJITEM_SEL FROM drgUsrClass
EXPORTED:
  METHOD  EventHandled

  *
  ** BRO column
  inline access assign method stav_Svydw() var stav_Svydw
    local  retVal    := 0
    local  cky       := upper(objitem->ccisSklad) +upper(objitem->csklPol)
    local  mnozOBodb := objitem->nmnozOBodb -objitem->nmnozPLodb
    local  mnozSzbo

    cenZboz->( dbseek( cky,,'CENIK03'))
    mnozSzbo := cenZboz->nmnozSzbo

    do case
    case( mnozSzbo =  0         )  ;  retVal := 558  // m_Cervena
    case( mnozSzbo >= mnozOBodb )  ;  retVal := 556  // m_Zelena
    case( mnozSzbo <  mnozOBodb )  ;  retVal := 555  // m_Zluta
    endcase
    return retVal

  inline access assign method mn_doDokl() var mn_doDokl
    return (objitem->nmnozObOdb -objitem->nmnozPlOdb)

  inline method init(parent)
    ::drgUsrClass:init(parent)
    drgDBMS:open('OBJITEM')
  return self

  inline method drgDialogInit(drgDialog)
    local nKarta := drgDialog:parentDialog:cargo:udcp:nKarta

    drgDialog:formHeader:title := if(nKarta = 274, 'Výrobní zakázky - VÝBÌR'  , ;
                                                    drgDialog:formHeader:title  )
  return self

  inline method drgDialogStart(drgDialog)
    local  x, d_bro := drgDialog:dialogCtrl:obrowse[1]
    *
    local  value, ctag, pa_tagKey
    local  ctag_old, ckey_old

*    d_Bro:oXbp:setLeftFrozen({1})

    ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
    firmy->( dbseek( objitem->ncisFirmy,, 'FIRMY1'))

    pa_tagKey := drgScrPos:getPos_forSel('SKL_OBJITEM_SEL', drgDialog, 'objitem' )
    ctag_old  := pa_tagKey[1]
    ckey_old  := pa_tagKey[2]

    * zkusíme se nastavit na poslední záznam kde byl
    objitem->( dbseek( ckey_old, .t., ctag_old))
*  if objitem->(eof()) .or. d_bro:oxbp:rowpos = 1
*    objitem->( dbgoBottom())
*    for x := 1 to 3 ; objitem ->( dbskip(-1)) ; next
*    for x := 1 to 3 ; d_bro:oxbp:down()       ; next
*  endif
  return self

ENDCLASS


********************************************************************************
METHOD SKL_OBJITEM_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  CASE nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
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