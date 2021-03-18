//////////////////////////////////////////////////////////////////////
//
//  Asystem++_login.PRG
//
//  Copyright:
//       MISS Software, s.r.o., (c) 2005. All rights reserved.
//
//  Contents:
//       Login Asystem++Dialog.
//
//  Remarks:
//
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "drg.ch"
#include "drgRes.ch"

// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


**  Import dat do systému
** CLASS for SYS_importdat_IN *********************************************
CLASS SYS_exportdat_IN FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  onSave
  METHOD  runExport
  METHOD  dir

  METHOD  destroy

  VAR     newRec


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::onSave()
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
      RETURN .t.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR typ, dm, msg

ENDCLASS


METHOD SYS_exportdat_IN:init(parent)

  drgDBMS:open('impdathd')

  ::drgUsrClass:init(parent)

RETURN self



METHOD SYS_exportdat_IN:drgDialogStart(drgDialog)
  LOCAL aUsers
  LOCAL n
  LOCAL oSle

  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager


/*

  oSle := ::dataManager:get('USERS->NCISOSOBY', .F.)// :oDrg:oXpb:xbpSle
  osle:odrg:isEdit := .f.

  IF ::newRec
    ::dataManager:set("users->copravneni", "USR_ZAKLAD")
    ::dataManager:set("users->dPlatn_Od", Date())
    ::dataManager:set("users->cpassword", '')
  ELSE
    ::dataManager:set("m->paswordcheck", USERS->CPASSWORD)
    ::paswordCheck := USERS->CPASSWORD
  ENDIF
*/
RETURN self

                                  *
*****************************************************************
METHOD SYS_exportdat_IN:postValidate(drgVar)
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

  CASE(name = 'users->cuser')
    IF Empty(value)
      ::msg:writeMessage('Zkratka uživatele je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    ELSE
      IF ::newRec .AND. USERStm->(dbSeek(Upper(Padr(AllTrim( value) ,10)),, AdsCtag(1) ))
        ::msg:writeMessage('Zkratka uživatele již existuje, musíte zadat jinou ....',DRG_MSG_ERROR)
        lOk := .F.
      ENDIF
    ENDIF

  CASE(name = 'users->cprihljmen')
    if Empty(value)
      ::msg:writeMessage('Pøihlašovací jméno je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    else
      if USERStm->(dbSeek(Upper(Padr(AllTrim( value) ,20)),, AdsCtag(3) ))
        ::msg:writeMessage('Pøihlašovací jméno již existuje, musíte zadat jiné ....',DRG_MSG_ERROR)
        lOk := .F.
      endif
    endif

  CASE(name = 'm->paswordcheck')
    IF value <> ::dataManager:get("users->cpassword")
      ::msg:writeMessage('Chybnì zadané heslo ...',DRG_MSG_ERROR)
      lOk := .F.
    ENDIF

  ENDCASE
*/
  ** ukládáme pøi zmìnì do tmp **
  if(lOK, ::msg:writeMessage(), NIL)
//  if( changed, ::dm:refresh(.T.), NIL )

RETURN lOk


METHOD SYS_exportdat_IN:onSave()
  LOCAL aUsers
  LOCAL n

  IF( ::newRec, expdathd->(dbAppend()), expdathd->(dbRlock()))
  ::dm:save()
  expdathd->(dbUnlock())

RETURN .T.


METHOD SYS_exportdat_IN:runExport()

  if drgIsYESNO(drgNLS:msg('Spustit export dat ?'))
  endif

RETURN .t.


METHOD SYS_exportdat_IN:dir()
  local  path, n
  local  cfile := AllTrim(drgINI:dir_DATA)

  n     := Rat('\Data\', cfile)
  cfile := SubStr( cfile, 1, n)

  path := selDIR(,cfile )

RETURN .t.



** END of CLASS ****************************************************************
METHOD SYS_exportdat_IN:destroy()
  ::drgUsrClass:destroy()

RETURN NIL