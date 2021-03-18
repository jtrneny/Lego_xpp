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


**  Reinstalace systému
** CLASS for SYS_reinstal_CRD *********************************************
CLASS SYS_reinstal_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  onSave
  METHOD  getForm
  METHOD  dir
  METHOD  dnNewVer

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


METHOD SYS_reinstal_CRD:init(parent)

  ( drgDBMS:open('LICASYS',,,drgINI:dir_SYSTEM), LICASYS->( dbGoTo(recFirma)))
  drgDBMS:open('ASYSVER')
  ::drgUsrClass:init(parent)

RETURN self


METHOD SYS_reinstal_CRD:getForm()
  LOCAL drgFC, cParm, oDrg

  cParm    := drgParseSecond(::drgDialog:initParam)
  ::newRec := .F.

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,13 DTYPE '10' TITLE 'Nastavení reinstalace systému' GUILOOK 'All:Y,Border:Y,Action:Y' POST 'postValidate' FILE 'LICASYS'
    DRGAction INTO drgFC CAPTION 'Stažení' EVENT 'dnNewVer'  TIPTEXT 'Stažení nové verze'// ICON1 101 ICON2 201 ATYPE 3

    DRGTEXT INTO drgFC CAPTION 'Cesta na distribuèní server' CPOS 1,0.3 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Poslední distribuèní verze'  CPOS 1,1.3 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGGET ASYSVER->cVerze INTO drgFC FPOS 35,1.3 FLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2

RETURN drgFC


METHOD SYS_reinstal_CRD:drgDialogStart(drgDialog)
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
METHOD SYS_reinstal_CRD:postValidate(drgVar)
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


METHOD SYS_reinstal_CRD:onSave()
  LOCAL aUsers
  LOCAL n

  IF( ::newRec, LICASYS->(dbAppend()), LICASYS->(dbRlock()))
  ::dm:save()
  LICASYS->(dbUnlock())

RETURN .T.


METHOD SYS_reinstal_CRD:dnNewVer()
  LOCAL aUsers
  LOCAL n

  drgDBMS:open('FIRMYFI')
  drgDBMS:open('FIRMY')

  Ads_SetRelation('FIRMY','FIRMYFI', 'FIRMYFI1','NCISFIRMY')

  firmy->( dbGoTop())

  do while .not. firmy->( Eof())

    aa := firmy->ncisfirmy
    bb := firmyfi->ncisfirmy
    cc := firmyfi->cuct_dod
    firmy->( dbSkip())
  enddo


RETURN .T.


METHOD SYS_reinstal_CRD:dir()
  local  path, n
  local  cfile := AllTrim(drgINI:dir_DATA)

  n     := Rat('\Data\', cfile)
  cfile := SubStr( cfile, 1, n)

  path := selDIR(,cfile )

RETURN .t.



** END of CLASS ****************************************************************
METHOD SYS_reinstal_CRD:destroy()
  ::drgUsrClass:destroy()

RETURN NIL