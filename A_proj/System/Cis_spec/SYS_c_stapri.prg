#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"



*
** CLASS for SYS_c_stapri *****************************************************
CLASS sys_c_stapri FROM drgUsrClass
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  method  getForm

  * bro col for c_bankuc
  inline access assign method stav_pripominky() var stav_pripominky
    return c_staPri->nBitMap

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = drgEVENT_FORMDRAWN)
      if ::lsearch
        postAppEvent(xbeP_Keyboard,xbeK_LEFT,,::brow:oxbp)
        return .t.
      else
        return .f.
      endif

    case (nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_DELETE)
      return .t.

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        ::drgDialog:cargo := c_stapri->nstaPripom
        return .t.
      endif

    case(nevent = drgEVENT_MSG)
      if mp2 = DRG_MSG_ERROR
         _clearEventLoop()
         SetAppFocus(::drgDialog:dialogCtrl:oBrowse:oXbp)
         return .t.
      endif
      return .f.

    endcase
  return .f.

HIDDEN:
  var    msg, dm, dc, df, ab, brow
  *
  var    drgGet, lsearch
ENDCLASS


method sys_c_stapri:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

  ::lsearch := (::drgGet <> NIL)
  ::drgUsrClass:init(parent)
return self


method sys_c_stapri:drgDialogInit(drgDialog)

  drgDialog:formHeader:title += if( ::lsearch, ' - VÝBÌR ...', '' )
return self


method sys_c_stapri:getForm()
 local  oDrg, drgFC


  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 70,15.2 DTYPE '10' TITLE 'Seznam stavu pøiponínek _ výbìr' ;
                                             GUILOOK 'All:N,Border:Y'

  DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 110,13 FILE 'c_stapri'     ;
             FIELDS 'M->stav_pripominky::2.7::2,'                + ;
                    'nStaPripom:stav,'                           + ;
                    'cNazStaPri:název typu pøipomínky:63'          ;
             SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y'

return drgFC



method sys_c_stapri:drgDialogStart(drgDialog)
  local aPP  := drgPP:getPP(2), oColumn, x

  ::brow    := drgDialog:dialogCtrl:oBrowse[1]
  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form
  if isobject(drgDialog:oActionBar)
    ::ab      := drgDialog:oActionBar:members    // actionBar
  endif

  if ::lsearch
    for x := 1 TO ::brow:oXbp:colcount
      ocolumn := ::brow:oXbp:getColumn(x)
      ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
      ocolumn:configure()
    next

    if .not. c_stapri->(dbseek(::drgGet:ovar:value,,'C_STAPRI01'))
      c_stapri->(dbgoTop())
    endif
    ::brow:oXbp:refreshAll()
  endif
return


method sys_c_stapri:postLastField(drgVar)
return .t.