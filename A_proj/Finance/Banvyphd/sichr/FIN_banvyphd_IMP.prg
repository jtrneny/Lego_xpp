#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
** class FIN_banvyphd_imp ******************************************************
class FIN_banvyphd_imp from drgUsrClass
  exported:
  method  init, drgDialogInit, drgDialogStart

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

    do case
    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    case nEvent = drgEVENT_APPEND
    case nEvent = drgEVENT_FORMDRAWN
      Return .T.

    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        RETURN .F.
      endcase

    otherwise
      RETURN .F.
    endcase
  RETURN .T.

  hidden:
  var  drgGet
endclass


method FIN_banvyphd_imp:init(parent)
  local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  endif

  ::drgUsrClass:init(parent)
return self


method FIN_banvyphd_imp:getForm()
  local oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 75,20 DTYPE '10' TITLE 'Naètené bankovná výpisy ...' ;
                                           FILE 'banvyph_iw'                   ;
                                           GUILOOK 'All:N,Border:Y'

  DRGDBROWSE INTO drgFC FPOS 0, 0.1 SIZE 75,9.8 FILE 'banvyph_iw' ;
    FIELDS 'ncisPoVyp:výpis,'     + ;
           'ddatPoVyp:ze dne,'    + ;
           'npocPoloz:položek,'   + ;
           'ddatPoVyp:stav k,'    + ;
           'nposZust:,'           + ;    
           'nprijem:pøíjem,'      + ;
           'nvydej:výdej,'        + ;
           'ddatZust:zùstatek k,' + ;  
           'nzustatek:'             ;  
    SCROLL 'ny' CURSORMODE 3 PP 7
return drgFC



method FIN_banvyphd_imp:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*  XbpDialog:titleBar := .F.

*  if IsObject(::drgGet)
*    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
*    drgDialog:usrPos := {aPos[1],aPos[2]}
*  endif
return


method FIN_banvyphd_imp:drgDialogStart(drgDialog)
  Local val, obro := drgDialog:dialogCtrl:oBrowse[1]

/*
  if IsObject(::drgGet)
    val := ::drgGet:oVar:value

    IF( .not. C_BANKUC ->(DbSeek(::drgGet:oVar:value,,'BANKUC1')), C_BANKUC ->(DbGoTop()), NIL )

    obro:oxbp:refreshAll()
  endif
*/
return self