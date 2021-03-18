#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "CLASS.CH"
//
#include "DRGres.Ch'
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


**  Aktualizace inicializa�n�ch parametr� pro u�ivatele
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
  DRGFORM INTO drgFC SIZE 100,15 DTYPE '10' TITLE 'Nastaven� inicializa�n�ch parametr� u�ivatele' GUILOOK 'All:Y,Border:Y,Action:N' POST 'postValidate'

*    DRGAction INTO drgFC CAPTION 'Konfigurace' EVENT 'config'  TIPTEXT 'Nastaven� u�ivatelsk� konfigurace'// ICON1 101 ICON2 201 ATYPE 3
*    DRGAction INTO drgFC CAPTION 'Menu' EVENT 'menu'  TIPTEXT 'Nastaven� u�ivatelsk�ho menu'// ICON1 101 ICON2 201 ATYPE 3
*    DRGAction INTO drgFC CAPTION 'Opravn�n�' EVENT 'osoby'  TIPTEXT 'Nastaven� u�ivatelsk�ho opr�vn�n� - p��stupu'// ICON1 101 ICON2 201 ATYPE 3

   DRGSTATIC INTO drgFC FPOS 0.5,0.07 SIZE 99.1,14.6 STYPE XBPSTATIC_TYPE_RECESSEDRECT

    DRGTEXT INTO drgFC CAPTION 'Visu�ln� styl zobrazen�' CPOS 1,1 CLEN 20 // FCAPTION 'Distribu�n� hodnota' CPOS 1,2
     DRGCOMBOBOX M->visstyl  INTO drgFC  FPOS 25,1  FLEN 7  REF 'LYESNO' // FCAPTION 'V�etn� v�po�tu pl�nu' CPOS 1, 1.4  REF 'LYESNO'

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

  ** ukl�d�me p�i zm�n� do tmp **
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