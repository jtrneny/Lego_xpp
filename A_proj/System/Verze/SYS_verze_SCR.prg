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


**  Verze systému
** CLASS for SYS_verze_CRD *********************************************
CLASS SYS_verze_SCR FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  onSave
  METHOD  getForm
  METHOD  dir

  METHOD  saveVer
  METHOD  instalVer

  METHOD  destroy

  VAR     paswordCheck
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


METHOD SYS_verze_SCR:init(parent)

  drgDBMS:open('ASYSVER')
  ::drgUsrClass:init(parent)

RETURN self


METHOD SYS_verze_SCR:getForm()
  LOCAL drgFC, cParm, oDrg

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 85,25 DTYPE '10' TITLE 'Pøehled plánovaných a vydaných verzí systému' GUILOOK 'All:Y,Border:Y,Action:Y'

  DRGAction INTO drgFC CAPTION '~Stažení'   EVENT 'saveVer'  TIPTEXT 'Stažení instalaèního souboru ASYSTEM++'// ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION '~Instalace' EVENT 'instalVer'  TIPTEXT 'Instalace nové verze ASYTEM++'// ICON1 101 ICON2 201 ATYPE 3

  DRGDBROWSE INTO drgFC FPOS 0.5,0.05 SIZE 44.0,24.7 FILE 'ASYSVER'          ;
    FIELDS 'cVerze,'                                    + ;
           'dPlanVer,'                                  + ;
           'dVznikVer,'                                 + ;
           'dStazVer,'                                  + ;
           'cUsrInsVer,'                                + ;
           'dInstalVer,'                                  ;
           ITEMMARKED 'itemMarked' SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'yy'

  DRGMLE asysver->mPopisPlan INTO drgFC FPOS 45.0,1.0 SIZE 39,11.2 PP 2 FCAPTION 'Plán zmìn ve verzi' CPOS 46.5,0.1
   odrg:rOnly := .t.

  DRGMLE asysver->mPopisVer  INTO drgFC FPOS 45.0,13.6 SIZE 39,11.2 PP 2 FCAPTION 'Provedené zmìny ve verzi' CPOS 46.5,12.7
   odrg:rOnly := .t.


RETURN drgFC


METHOD SYS_verze_SCR:drgDialogStart(drgDialog)
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
METHOD SYS_verze_SCR:postValidate(drgVar)
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


METHOD SYS_verze_SCR:onSave()
  LOCAL aUsers
  LOCAL n

  ::dm:save()

RETURN .T.



METHOD SYS_verze_SCR:dir()
  local  path, n
  local  cfile := AllTrim(drgINI:dir_DATA)

  n     := Rat('\Data\', cfile)
  cfile := SubStr( cfile, 1, n)

  path := selDIR(,cfile )

RETURN .t.


METHOD SYS_verze_SCR:saveVer()

RETURN .t.


METHOD SYS_verze_SCR:instalVer()

RETURN .t.



** END of CLASS ****************************************************************
METHOD SYS_verze_SCR:destroy()
  ::drgUsrClass:destroy()

RETURN NIL