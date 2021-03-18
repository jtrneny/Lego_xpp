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


**  Aktualizace licenèních údajù
** CLASS for SYS_users_IN *********************************************
CLASS SYS_licasys_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  onSave
  METHOD  getForm
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


METHOD SYS_licasys_CRD:init(parent)

  dbUseArea(.t., oSession_sys, drgINI:dir_SYSTEM +'licAsys',, .T.)
  licAsys->( AX_SetPass(syApa))
  LICASYS->( dbGoTo(recFirma))

  ::drgUsrClass:init(parent)

RETURN self


METHOD SYS_licasys_CRD:getForm()
  LOCAL drgFC, cParm, oDrg

  cParm    := drgParseSecond(::drgDialog:initParam)
  ::newRec := .F.

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,13 DTYPE '10' TITLE 'Modifikace licenèních údajù' GUILOOK 'All:Y,Border:Y,Action:N' POST 'postValidate' FILE 'LICASYS'

//  DRGAction INTO drgFC CAPTION 'Návrh' EVENT 'LL_DefineDesign'  TIPTEXT 'Návrh tiskového výstupu'// ICON1 101 ICON2 201 ATYPE 3

//  DRGSTATIC INTO drgFC FPOS 0.5,0.07 SIZE 99.1,7.6 STYPE XBPSTATIC_TYPE_RECESSEDRECT
    DRGTEXT INTO drgFC CAPTION 'Název firmy' CPOS 1,0.3 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->CNAZFIRMY INTO drgFC CPOS 25,0.3 CLEN 50 BGND 13 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
*     oDrg:push := 'firmy'
*     DRGGET LICENCE->nCisFirmy INTO drgFC FPOS 85,0.5 FLEN 5 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'IÈO/DIÈ'  CPOS 1,1.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->cico INTO drgFC CPOS 25,1.4 CLEN 12 BGND 13// FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->cdic INTO drgFC CPOS 45,1.4 CLEN 25 BGND 13// FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'Název pro pøihlášení' CPOS 1,2.5 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET LICASYS->CNAZFIRPRI INTO drgFC FPOS 25,2.5 FLEN 50 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Zkratka firmy'  CPOS 1,3.5 CLEN 20  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->CZKRNAZEV INTO drgFC CPOS 25,3.5 CLEN 15 PP 2 BGND 13 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Ulice-è.popisné'  CPOS 1,5.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET LICASYS->CULICE INTO drgFC FPOS 25,5.4 FLEN 30 PP 2
//    DRGTEXT INTO drgFC CAPTION 'Èíslo popisné'  CPOS 1,6.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET LICASYS->cCisPopis INTO drgFC FPOS 60,5.4 FLEN 15  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
//    DRGTEXT INTO drgFC CAPTION 'Psè'  CPOS 1,7.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Místo' CPOS 1,6.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET LICASYS->cPsc INTO drgFC FPOS 25,6.4 FLEN 8  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET LICASYS->cMisto INTO drgFC FPOS 35,6.4 FLEN 35 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Stát' CPOS 1,7.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET LICASYS->cZkrStat INTO drgFC FPOS 25,7.4 FLEN 8  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'IDuživ' CPOS 1,8.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->nIdUzivSW INTO drgFC CPOS 25,8.4 CLEN 18 BGND 13 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'IDdatabáze' CPOS 1,9.5 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->nUsrIdDB INTO drgFC CPOS 25,9.5 CLEN 18 BGND 13 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'IDlicence' CPOS 1,10.6 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->cLicence INTO drgFC CPOS 25,10.6 CLEN 25 BGND 13 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Název dat.adresáøe' CPOS 1,11.7 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET LICASYS->cDataDir INTO drgFC FPOS 25,11.7 FLEN 50  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     oDrg:push := 'dir'

*     DRGGET USERS->nCISOSOBY INTO drgFC FPOS 30,10.2 FLEN 0 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
//  DRGEND  INTO drgFC


RETURN drgFC


METHOD SYS_licasys_CRD:drgDialogStart(drgDialog)
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
METHOD SYS_licasys_CRD:postValidate(drgVar)
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


METHOD SYS_licasys_CRD:onSave()
  LOCAL aUsers
  LOCAL n

  IF( ::newRec, LICASYS->(dbAppend()), LICASYS->(dbRlock()))
  ::dm:save()
  LICASYS->(dbUnlock())

RETURN .T.



METHOD SYS_licasys_CRD:dir()
  local  path, n
  local  cfile := AllTrim(drgINI:dir_DATA)

  n     := Rat('\Data\', cfile)
  cfile := SubStr( cfile, 1, n)

  path := selDIR(,cfile )

RETURN .t.



** END of CLASS ****************************************************************
METHOD SYS_licasys_CRD:destroy()
  ::drgUsrClass:destroy()

RETURN NIL