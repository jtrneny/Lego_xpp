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
CLASS SYS_about_INF FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  onSave
  METHOD  getForm
  METHOD  SYS_verze_SCR
  METHOD  dir

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


METHOD SYS_about_INF:init(parent)

  drgDBMS:open('ASYSVER')
//  drgDBMS:open('LICASYS',,,drgINI:dir_SYSTEM)

  dbUseArea(.t., oSession_sys, drgINI:dir_SYSTEM +'licAsys',, .T.)
  licAsys->( AX_SetPass(syApa))

  LICASYS->( dbGoTo(recFirma))
  ::drgUsrClass:init(parent)

RETURN self


METHOD SYS_about_INF:getForm()
  LOCAL drgFC, cParm, oDrg, cRok := str(year(date()))
  LOCAL tm1,tm2,tm3

  tm1 := if(Empty(LicASYS->cLicence),'DEMO-9999-9999-9999',LicASYS->cLicence)
  tm2 := DtoC( if(Empty(dPlatLicDO),CtoD('30.6.2009'),LicASYS->dPlatLicDO))

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 55,11 DTYPE '10' TITLE 'Informace o aplikaci' GUILOOK 'All:N,Border:N,Action:N' POST 'postValidate' FILE 'ASYSVER'
    DRGSTATIC INTO drgFC STYPE 5 CAPTION '2' FPOS 2,0.1 SIZE 150,150

     DRGTEXT INTO drgFC CAPTION 'ASYSTEM++' CPOS 24,0.6 CLEN 28 CTYPE 1 FONT 8 PP 3
     DRGPUSHBUTTON INTO drgFC POS 32,2.4 SIZE 12,0.9 ATYPE 4 CAPTION verzeAsys[8,2] EVENT 'SYS_verze_SCR' TIPTEXT 'Pøehled verzí systému'
*     DRGTEXT INTO drgFC CAPTION verzeAsys[8,2] CPOS 31,2.1 CLEN 20 FONT 5 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGTEXT INTO drgFC CAPTION verzeAsys[1,2]  CPOS 31,3.9 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGTEXT INTO drgFC CAPTION verzeAsys[5,2] CPOS 29,4.6 CLEN 30  // FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGSTATIC INTO drgFC STYPE 16 FPOS 22,5.7 SIZE 30,.2

     DRGTEXT INTO drgFC CAPTION 'Licenèní klíè: ' + tm1 CPOS 23,6.0 CLEN 30  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGTEXT INTO drgFC CAPTION 'Platný do    : ' + tm2 CPOS 23,6.7 CLEN 30  // FCAPTION 'Distribuèní hodnota' CPOS 1,2

     DRGTEXT INTO drgFC CAPTION 'ID uživatele: ' + Str(usrIdSW) CPOS 23,7.4 CLEN 30  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGTEXT INTO drgFC CAPTION 'ID databáze: '  + Str(usrIdDB) CPOS 23,8.1 CLEN 30  // FCAPTION 'Distribuèní hodnota' CPOS 1,2

     DRGTEXT INTO drgFC CAPTION 'Verze DB    : '  + SpecialBuild CPOS 23,8.8 CLEN 30  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGTEXT INTO drgFC CAPTION 'Verze EXE  : '   + verzeAsys[3,2] CPOS 23,9.6 CLEN 30  // FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGPUSHBUTTON INTO drgFC POS 3.7,6.1 SIZE 16,0.9 ATYPE 4 CAPTION 'Program' EVENT 140000002 TIPTEXT 'Informace o programu'
    DRGPUSHBUTTON INTO drgFC POS 3.7,7.6 SIZE 16,0.9 ATYPE 4 CAPTION 'Licence'  EVENT 140000002 TIPTEXT 'Licenèní podmínky'
    DRGPUSHBUTTON INTO drgFC POS 3.7,9.1 SIZE 16,0.9 ATYPE 4 CAPTION 'Kontakt'    EVENT 140000002 TIPTEXT 'Kontaktní informace'

RETURN drgFC


METHOD SYS_about_INF:drgDialogStart(drgDialog)
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
METHOD SYS_about_INF:postValidate(drgVar)
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


METHOD SYS_about_INF:onSave()
  LOCAL aUsers
  LOCAL n

  ::dm:save()

RETURN .T.


method SYS_about_INF:SYS_verze_SCR(drgDialog)
  local oDialog, nExit

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SYS_verze_SCR' PARENT drgDialog MODAL DESTROY EXITSTATE nExit
  ::drgDialog:popArea()
return .t.


METHOD SYS_about_INF:dir()
  local  path, n
  local  cfile := AllTrim(drgINI:dir_DATA)

  n     := Rat('\Data\', cfile)
  cfile := SubStr( cfile, 1, n)

  path := selDIR(,cfile )

RETURN .t.



** END of CLASS ****************************************************************
METHOD SYS_about_INF:destroy()
  ::drgUsrClass:destroy()

RETURN NIL