#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "CLASS.CH"
//
#include "DRGres.Ch'
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


**  Aktualizace inicializaèních parametrù pro uživatele
** CLASS for SYS_usrinit_CRD *********************************************
CLASS SYS_usrinit_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  postAppend
  METHOD  onSave
  METHOD  getForm

  METHOD  destroy

  VAR     visStyl
  VAR     newRec


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc := ::drgDialog:dialogCtrl, new_val

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::onSave()
*      if nEvent = drgEVENT_EXIT
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
*      endif
      RETURN .t.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR typ, dm, msg, opsw_1, opsw_2

ENDCLASS


METHOD SYS_usrinit_CRD:init(parent)

  ::drgUsrClass:init(parent)

  ::visStyl := visualStyle

RETURN self


METHOD SYS_usrinit_CRD:getForm()
  LOCAL drgFC, cParm, oDrg

  cParm    := drgParseSecond(::drgDialog:initParam)
  ::newRec := IF( cParm == "APPEND", .T., .F.)

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,15 DTYPE '10' TITLE 'Nastavení inicializaèních parametrù uživatele' GUILOOK 'All:Y,Border:Y,Action:N' POST 'postValidate'

*    DRGAction INTO drgFC CAPTION 'Konfigurace' EVENT 'config'  TIPTEXT 'Nastavení uživatelské konfigurace'// ICON1 101 ICON2 201 ATYPE 3
*    DRGAction INTO drgFC CAPTION 'Menu' EVENT 'menu'  TIPTEXT 'Nastavení uživatelského menu'// ICON1 101 ICON2 201 ATYPE 3
*    DRGAction INTO drgFC CAPTION 'Opravnìní' EVENT 'osoby'  TIPTEXT 'Nastavení uživatelského oprávnìní - pøístupu'// ICON1 101 ICON2 201 ATYPE 3

   DRGSTATIC INTO drgFC FPOS 0.5,0.07 SIZE 99.1,14.6 STYPE XBPSTATIC_TYPE_RECESSEDRECT

    DRGTEXT INTO drgFC CAPTION 'Visuální styl zobrazení' CPOS 1,1 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGCOMBOBOX M->visstyl  INTO drgFC  FPOS 25,1  FLEN 7  REF 'LYESNO' // FCAPTION 'Vèetnì výpoètu plánu' CPOS 1, 1.4  REF 'LYESNO'

     //  DRGEND  INTO drgFC


RETURN drgFC


METHOD SYS_usrinit_CRD:drgDialogStart(drgDialog)
  LOCAL aUsers, n, oSle, new_val

  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager

  if !::newRec
  else
    ::postAppend()
  endif

RETURN self

                                  *
*****************************************************************
METHOD SYS_usrinit_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval

/*
  DO CASE
  CASE(name = 'users->cosoba')
    if( !Empty( value) .and. (::newRec .or. changed)                         ;
          ,lOK := ::returnOsoba(value), NIL)

  ENDCASE
*/

  ** ukládáme pøi zmìnì do tmp **
  if(lOK, ::msg:writeMessage(), NIL)
//  if( changed, ::dm:refresh(.T.), NIL )

RETURN lOk



* ok
method SYS_usrinit_CRD:postAppend()
  local x, ovar, type, val, ok, file

  for x := 1 to ::dm:vars:size() step 1
    ok   := .f.
    ovar := ::dm:vars:getNth(x)
    type := valtype(ovar:value)
    file := lower(drgParse(ovar:name,'-'))

    do case
    case(type == 'N')  ;  val := 0
    case(type == 'C')  ;  val := ''
    case(type == 'D')  ;  val := ctod('  .  .  ')
    case(type == 'L')  ;  val := .f.
    endcase

    ovar:set(val)
    ovar:initValue := ovar:prevValue := ovar:value := val
  next
return .t.


METHOD SYS_usrinit_CRD:onSave()
  LOCAL aUsers
  LOCAL n

  ::dm:save()

  visualStyle := ::visStyl

RETURN .T.


** END of CLASS ****************************************************************
METHOD SYS_usrinit_CRD:destroy()
  ::drgUsrClass:destroy()

RETURN NIL