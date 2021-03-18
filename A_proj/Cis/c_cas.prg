#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for c_cas *********************************************************
CLASS c_cas FROM drgUsrClass
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  method  generuj
  *
  ** bro column

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = xbeBRW_ItemMarked)
     ::dm:refresh()

    case nEvent = drgEVENT_EDIT
      if ::lsearch
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
*        ::drgDialog:cargo := &(oXbp:cargo:arDef[1,2])

        ::drgDialog:cargo := c_cas->ccas
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


  inline method destroy()
    ::drgUsrClass:destroy()
  return self

RETURN self


HIDDEN:
  var    msg, dm, dc, df, ab, brow
  *
  var    drgGet, lsearch, value
ENDCLASS


method c_cas:init(parent)

  ::value   := if( isNull(parent:cargo), '',parent:cargo)
  ::lsearch := .not. isNull(parent:cargo)

  ::drgUsrClass:init(parent)
return self


method c_cas:drgDialogInit(drgDialog)

*  drgDialog:formHeader:title += if( ::lsearch, ' - VÝBÌR ...', '' )
return self


method c_cas:drgDialogStart(drgDialog)
  local aPP  := drgPP:getPP(2), oColumn, x

  ::brow    := drgDialog:dialogCtrl:oBrowse
  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form
  if isobject(drgDialog:oActionBar)
    ::ab      := drgDialog:oActionBar:members    // actionBar
  endif

return


method c_cas:postLastField(drgVar)
return .t.

method c_cas:generuj(drgDialog)

  DRGDIALOG FORM 'c_casintgen' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  ::brow:oXbp:refreshAll()

return .t.


CLASS c_casintgen FROM drgUsrClass
EXPORTED:
  method  drgDialogInit, drgDialogStart, postLastField
  method  getform
  method  generujint

  *
  ** bro column

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = xbeBRW_ItemMarked)
     ::dm:refresh()

    case nEvent = drgEVENT_EDIT
      if ::lsearch
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        ::drgDialog:cargo := &(oXbp:cargo:arDef[1,2])
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


  inline method destroy()
    ::drgUsrClass:destroy()
  return self

RETURN self


HIDDEN:
  var    msg, dm, dc, df, ab, brow
  *
  var    drgGet, lsearch, value
  var    ncasint
ENDCLASS

/*
method c_casintgen:init(parent)
  ::value   := if( isNull(parent:cargo), '',parent:cargo)
  ::lsearch := .not. isNull(parent:cargo)

  ::drgUsrClass:init(parent)
return self
*/

method c_casintgen:getForm()
  LOCAL drgFC := drgFormContainer():new(), oDrg

  DRGFORM INTO drgFC SIZE 50,6 DTYPE '10' TITLE 'Generování èasù dle vybraného intervalu' ;
                      GUILOOK 'All:n,Border:Y,Action:n';
                      PRE 'preValidate' POST 'postValidate'

    DRGTEXT INTO drgFC CAPTION 'Výbìr èasového intervalu  ____'  CPOS 2,1.6 CLEN 23
     DRGCOMBOBOX M->NCASINT INTO drgFC FPOS 27,1.6 FLEN 20 REF 'casint' PP 2

    DRGPUSHBUTTON INTO drgFC POS 32,4.2 SIZE 15,1.2 ATYPE 2 CAPTION 'Generuj' EVENT 'generujint' TIPTEXT 'Spustí generování ...'


RETURN drgFC

method c_casintgen:drgDialogInit(drgDialog)

*  ::ncasint := ''

*  drgDialog:formHeader:title += if( ::lsearch, ' - VÝBÌR ...', '' )
return self


method c_casintgen:drgDialogStart(drgDialog)
  local aPP  := drgPP:getPP(2), oColumn, x

  ::ncasint := "  "

  ::brow    := drgDialog:dialogCtrl:oBrowse
  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form
  if isobject(drgDialog:oActionBar)
    ::ab      := drgDialog:oActionBar:members    // actionBar
  endif

return


method c_casintgen:postLastField(drgVar)
return .t.

method c_casintgen:generujint(drgVar)
  local interval
*  local krat

*  interval := ::ncasint                 // správnì
  interval := Val(::df:olastdrg:value)   // totální hovadina

  c_cas->(dbGoTop())
  do while  .not. c_cas->(eof())
    if c_cas->(dbRLock())
      c_cas->(dbDelete())
    endif
    c_cas->(dbSkip())
  enddo
  c_cas->(dbUnLock())

  if .t.
    for n := 0 to 23
      celkem := 0
      UlozCasy( n,celkem,interval)
      celkem += interval
      do while celkem < 60
        UlozCasy( n,celkem,interval)
        celkem += interval
      enddo
    next
    UlozCasy( 24, 0, interval)

    c_cas->(dbUnLock())
    c_cas->(dbGoTop())
  else

  endif
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

return nil

static function UlozCasy( hod,minuty,interval)
  c_cas->( dbAppend())
  c_cas->ccas := StrZero( hod, 2) +':' +StrZero( minuty, 2)
  c_cas->ncas := if( hod < 24, TimeToSec(c_cas->ccas)/3600, 24)
  c_cas->ccasint := '00:' +StrZero( interval,2)
  c_cas->ncasint := TimeToSec(c_cas->ccasint)/3600
return nil
