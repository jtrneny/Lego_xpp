#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"

**
** CLASS for c_nempas **********************************************************
CLASS c_prerus FROM drgUsrClass
EXPORTED:
  METHOD  init
//  METHOD  itemmarked
//  METHOD  drgDialogInit
  METHOD  postLastField
  METHOD  c_prerva_in


    inline access assign method is_Vazba() var is_Vazba
    return if( c_Prervaa->( dbSeek( 'DOH'+c_prerus->ckodprer,,'C_PRERVA07')), 556, 0 )


    inline method drgDialogStart( drgDialog )

      ::brow := drgDialog:dialogCtrl:oBrowse
    return self

  **
  ** EVENT *********************************************************************
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  nRECs
    local  msg      := ::drgDialog:oMessageBar

    do case
    case (nEvent = xbeBRW_ItemMarked)
      if(IsObject(::drgGet), nil, msg:WriteMessage(,0))
      ::nState := 0
      ::drgDialog:dialogCtrl:isAppend := (::nState = 2)
      return .F.

    case nEvent = drgEVENT_EDIT
      if ::lsearch
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
*        ::drgDialog:cargo := &(oXbp:cargo:arDef[1,2])

        ::drgDialog:cargo := c_prerus->ckodprer
        return .t.
      endif

  * zmìna období - budeme reagovat
//    case(nevent = drgEVENT_OBDOBICHANGED)
//      ::setSysFilter()
//      return .t.

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  var    drgGet, brow
  var    nState       // 0 - inBrowse  1 - inEdit  2 - inAppend
  var    lsearch, value


/*
  * filtr
  inline method setSysFilter( ini )
    local rok, obdobi
    local cfiltr, ft_APU_cond, filtrs

    default ini to .f.

    rok    := uctOBDOBI:MZD:NROK
    obdobi := uctOBDOBI:MZD:NOBDOBI
    cfiltr := Format("nROK = %% .and. nOBDOBI = %%", {rok,obdobi} )

    if ini
      ::drgDialog:set_prg_filter(cfiltr, 'c_nempas')

    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('c_nempas', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      ::drgDialog:set_prg_filter(cfiltr, 'c_nempas')

      c_nempas->( ads_setaof(filtrs), dbGoTop())
      ::brow:oxbp:refreshAll()
    endif
  return self
*/


ENDCLASS


METHOD c_prerus:init(parent)
  Local nEvent,mp1,mp2,oXbp


  ::value   := if( isNull(parent:cargo), '',parent:cargo)
  ::lsearch := .not. isNull(parent:cargo)

  ::drgUsrClass:init(parent)
  ::drgGet     := NIL
  ::nState     := 0

  drgDBMS:open('c_Prerva',,,,,'c_Prervaa' )

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

//  ::setSysFilter(.t.)
RETURN self

/*
METHOD c_prerus:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  IF IsObject(::drgGet)
    drgDialog:hasIconArea := drgDialog:hasActionArea := ;
    drgDialog:hasMsgArea  := drgDialog:hasMenuArea   := drgDialog:hasBorder := .F.
    XbpDialog:titleBar    := .F.

    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN self
*/


METHOD c_prerus:postLastField(drgVar)
  Local  dc     := ::drgDialog:dialogCtrl
  Local  name   := drgVAR:name
  Local  lZMENa := ::drgDialog:dataManager:changed()

  // ukládáme C_ZAMEST na posledním PRVKU //

*  IF lZMENa .and. If( ::nState == 2, ADDrec('C_ZAMEST'), REPLrec( 'C_ZAMEST'))
*    ::dataManager:save()
*  ENDIF

*  ::drgDialog:oForm:setNextFocus(1,, .T.)
*  C_ZAMEST ->( DbUnLock())
RETURN .T.



method c_prerus:c_prerva_in(drgDialog)

  DRGDIALOG FORM 'C_PRERVA' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
//  DRGDIALOG FORM 'C_PRERVA' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND2

return nil