#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "class.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  Pøístupová práva
** CLASS for SYS_asysact_IN ****************************************************
CLASS SYS_asysact_IN FROM drgUsrClass
EXPORTED:
  VAR     aitw


  METHOD  init, getForm, drgDialogStart, itemMarked, preValidate, postValidate
  METHOD  selAsystem
   *
  method  ebro_saveEditRow
   *
  METHOD  destroy

  VAR     cOLDfrmName
  *
  INLINE METHOD isOk()
    LOCAL isOk := .not. Empty(::aitw)
    AEval(::aitw, {|s| if( Empty(s), isOk := .F., NIL )})
    if( isOk, ::pushOk:enable(), ::pushOk:disable())
  RETURN isOk
  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc     := ::drgDialog:dialogCtrl
    LOCAL  dbArea := ALIAS(SELECT(dc:dbArea))

    DO CASE
    CASE nEvent = drgEVENT_DELETE
      if ::dctrl:oaBrowse = ::dctrl:oBrowse[1]
         if drgIsYESNO(drgNLS:msg( 'Zrušit nastavení oprávnìní <&> ?' , asysact ->cidobject))
          asysact ->(dbRlock())
          asysact ->(dbDelete())
          oXbp:cargo:refresh()
        endif
      endif
      RETURN .T.

    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

HIDDEN:
  var     msg, dm, bro, dctrl, pushOk, key
  var     prevForm, prevBro, prevFile, lnewrec
ENDCLASS


METHOD SYS_asysact_IN:init(parent)
  local cparm

  ::drgUsrClass:init(parent)

   cParm    := drgParseSecond(::drgDialog:initParam)

  ::prevFile := ''
  ::lnewrec  := .F.
  ::key    := cParm

  drgDBMS:open('ASYSACT')
  drgDBMS:open('ASYSTEM')

  ASYSACT->(DbSetRelation( 'ASYSTEM',{|| ASYSACT->cIDobject },'ASYSACT->cIDobject','ASYSTEM04'))

RETURN self


METHOD SYS_asysact_IN:getForm()
  LOCAL drgFC, _drgEBrowse

  drgFC := drgFormContainer():new()


  DRGFORM INTO drgFC SIZE 100,20 DTYPE '10' TITLE 'Uživatelské oprávnìní' ;
                     GUILOOK 'All:Y,Border:Y,Action:N';
                     PRE 'preValidate' POST 'postValidate'

* Browser _fltusers
  DRGEBROWSE INTO drgFC FPOS 0.5,0 SIZE 99,18.9 FILE 'ASYSACT'  ;
              SCROLL 'ny' CURSORMODE 3 PP 7
    _drgEBrowse := oDrg

    DRGGET  asysact->cidobject INTO drgFC   FPOS  1,0 CLEN 14 FCAPTION 'object' PUSH 'selAsystem'
    DRGTEXT INTO drgFC NAME asystem->cnameobj  CPOS 2,0 CLEN 35  CAPTION 'název objektu'

    DRGCHECKBOX asysact->lbegact INTO drgFC FLEN 5 FCAPTION 'run' VALUES 'T:.,F:.'
    DRGCHECKBOX asysact->lnewact INTO drgFC FLEN 5 FCAPTION 'ins' VALUES 'T:.,F:.'
    DRGCHECKBOX asysact->ldelact INTO drgFC FLEN 5 FCAPTION 'del' VALUES 'T:.,F:.'
    DRGCHECKBOX asysact->lmodact INTO drgFC FLEN 5 FCAPTION 'mod' VALUES 'T:.,F:.'
    DRGCHECKBOX asysact->lsavact INTO drgFC FLEN 5 FCAPTION 'sav' VALUES 'T:.,F:.'

    _drgEBrowse:createColumn(drgFC)
  DRGEND INTO drgFC
RETURN drgFC


METHOD SYS_asysact_IN:drgDialogStart(drgDialog)
  LOCAL broPos, members, x
  local filtr

  *
  ::prevForm := drgDialog:parent
  ::prevFile := ''
  members    := ::prevForm:oForm:aMembers
  BEGIN SEQUENCE
    for x := 1 TO len(members)
      if 'browse' $ lower(members[x]:className())
        ::prevBro  := members[x]
        ::prevFile := ::prevBro:cFile
  BREAK
      endif
    next
  END SEQUENCE

  *
  ::msg      := drgDialog:oMessageBar
  ::dm       := drgDialog:dataManager
  ::dctrl    := drgDialog:dialogCtrl
  ::prevForm := drgDialog:parent

  *
  members  := drgDialog:oForm:aMembers
  BEGIN SEQUENCE
    for x := 1 TO len(members)
      if members[x]:ClassName() = 'drgBrowse'
        drgDialog:oForm:nextFocus := x
  BREAK
      endif
    next
  END SEQUENCE

  *
  if ::key == 'USER'
    filtr := Format("cUser = '%%'", {users->cuser})
  else
    filtr := Format("cGroup = '%%'", {usersgrp->cgroup})
  endif

  asysact->( ads_setaof(filtr))
  asysact->(dbGoTop())

  ::dctrl:oBrowse[1]:refresh(.t.)
RETURN self



METHOD SYS_asysact_IN:itemMarked()
  LOCAL  buffer

  if ::dctrl:oaBrowse = ::dctrl:oBrowse[1]

  end
RETURN NIL


METHOD SYS_asysact_IN:preValidate(drgVar)
  local  lOk := .T., odesc, picture

*-  drgVar:oDrg:oXbp:enable()
/*
  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    lOk   := (at('->',filtritw ->cvyraz_2) = 0)
    odesc := drgDBMS:getFieldDesc(strtran(filtritw->cvyraz_1,' ',''))


    if lOK .and. IsObject(odesc)
      do case
      case odesc:type = 'D'
        drgVar:odrg:oxbp:picture := '@D'
      otherwise
        picture := if(odesc:name = 'COBDOBI','99/99',odesc:picture)
        drgVar:oDrg:oXbp:picture := picture
      endcase

    else
*-      drgVar:oDrg:oXbp:disable()
      lOk := .f.
    endif
  endif
*/
RETURN lOk


METHOD SYS_asysact_IN:postValidate(drgVar)
  local  value := drgVar:get(), lOk := .T.

/*
  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    if drgVar:changed()
      filtritw ->cvyraz_2         := value
      ::aitw[filtritw->(RecNo())] := value
    endif

    ::isOk()
  endif
*/

RETURN lOk

*
*
** pøevzetí záznamu z FILTRS -> FLTUSERS ***************************************
METHOD SYS_asysact_IN:selAsystem(parent)
  LOCAL oDialog, nExit, keyFLT

  DRGDIALOG FORM 'SYS_asystem_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit != drgEVENT_QUIT
    ::dm:set("asysact->cidobject", asystem->cidobject)
  endif

  ::lnewrec := .F.
RETURN self


method sys_asysact_in:ebro_saveEditRow(parent)
  local  cfile := lower(parent:cfile)

  if ::key == 'USER'
    asysact->cuser  := users->cuser
  else
    asysact->cgroup := usersgrp->cGroup
  endif

return


*
** END of CLASS ****************************************************************
METHOD SYS_asysact_IN:destroy()
  ::drgUsrClass:destroy()

  ::aitw     := ;
  ::msg      := ;
  ::dm       := ;
  ::bro      := ;
  ::dctrl    := ;
  ::pushOk   := ;
  ::prevForm := NIL

  asysact->(ads_clearaof())
RETURN NIL

