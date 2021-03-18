//////////////////// //////////////////////////////////////////////////
//
//  Asystem++_login.PRG
//
//  Copyright:
//       MISS Software, s.r.o., (c) 2005. All rights reserved.
//
//  Contents:
//       Login Asystem++Dialog.
//                                                        //  Remarks:
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



**  Konfigaurace DIM
** CLASS for DIM_config_scr_DIM *********************************************
CLASS SYS_licasys_SCR FROM drgUsrClass

EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  onSave
  METHOD  postValidate

  METHOD  destroy             // rel ease all resources used by this object

  METHOD  getForm
  METHOD  licasysIn

  VAR     typIn

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
    CASE nEvent = drgEVENT_EDIT //.OR. nEvent = xbeM_LbDblClick // .OR. nEvent = drgEVENT_FORMDRAWN
      ::typIn := "EDIT"
//    USERS->(dbRlock())
      ::licasysIN()
      dc:oBrowse[1]:refresh(.T.)
      RETURN .T.
    RETURN .T.

  CASE nEvent = drgEVENT_APPEND
    ::typIn := "APPEND"
    ::licasysIN()
    dc:oBrowse[1]:refresh(.T.)
    RETURN .T.

//  CASE nEvent = drgEVENT_FORMDRAWN
//     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      RETURN .T.
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.

 ENDCASE
HIDDEN:
  VAR    dm, dctrl


ENDCLASS


METHOD SYS_licasys_SCR:init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('LICASYS',,,drgINI:dir_SYSTEM)

RETURN self


METHOD SYS_licasys_SCR:getForm()
  LOCAL drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 85,25 DTYPE '10' TITLE 'Licenèní soubor' GUILOOK 'All:Y,Border:Y,Action:Y'

*  DRGAction INTO drgFC CAPTION '~DemoLic' EVENT 'demoLic'  TIPTEXT 'Vytvoøení demo licenèního souboru'// ICON1 101 ICON2 201 ATYPE 3
*  DRGAction INTO drgFC CAPTION '~DistrLic' EVENT 'distrLic'  TIPTEXT 'Vytvoøení distribuèního licenèního souboru'// ICON1 101 ICON2 201 ATYPE 3

  DRGDBROWSE INTO drgFC FPOS 0.5,0.05 SIZE 84.0,24.7 FILE 'LICASYS'         ;
    FIELDS 'cNazFirmy:Název firmy:30:::GET,'                              + ;
           'cNazFirPri:Název firmy pro pøihlášení::::GET,'                + ;
           'cZkrNazev:Zkratka pro firmu::::GET,'                          + ;
           'cUlice:Ulice::::GET,'                                         + ;
           'cCisPopis:Èíslo popisné::::GET,'                              + ;
           'cPsc:Psè::::GET,'                                             + ;
           'cMisto:Sídlo firmy::::GET,'                                   + ;
           'cZkrStat:Zkratka státu::::GET,'                               + ;
           'cIco:IÈO::::GET,'                                             + ;
           'cDic:DIÈ::::GET,'                                             + ;
           'nIDuzivSW:::::GET,'                                           + ;
           'nUsrIdDB:::::GET,'                                            + ;
           'cLicence:Licence::::GET,'                                     + ;
           'cDataDir:Datový adresáø::::GET'                                 ;
           ITEMMARKED 'itemMarked' SCROLL 'yy' CURSORMODE 3 PP 7

RETURN drgFC








































METHOD SYS_licasys_SCR:drgDialogStart(drgDialog)

  ::dm       := drgDialog:dataManager
  ::dctrl    := drgDialog:dialogCtrl


RETURN self


*
*****************************************************************
METHOD SYS_licasys_SCR:onSave(lIsCheck,lIsAppend)                                 // kotroly a výpoèty po uložení
  LOCAL  dc       := ::drgDialog:dialogCtrl
  LOCAL  cALIAs   := ALIAS(dc:dbArea)

  IF !lIsCheck
//    IF (cALIAs) ->nCISFIRMY == 0
//      (cALIAs) ->nCISFIRMY := FIRMYw ->nCISFIRMY
//    ENDIF
  ENDIF
RETURN .T.

RETURN SELF


*
*****************************************************************
METHOD SYS_licasys_SCR:postValidate(drgVar)
  LOCAL cName    := drgVar:Name
  LOCAL xVar     := drgVar:get()
  Local lNewRec  := ::drgDialog:dialogCtrl:isAppend
  Local lChanged := drgVar:changed()
  Local dm       := ::drgDialog:dataManager
  Local aValues  := dm:vars:values
  LOCAL lRefreshALL := .T.
  LOCAL lOK := .T.
  LOCAL lFound, cKey, xX
                                     // kotroly a výpoèty
// nastavení doprovodných textù u nejednoznaèných položek

/*
  DO CASE
  CASE cName = 'M_DAVHDw->nDoklad'
    IF xVAR = 0
        lOK := .F.
    ENDIF

  ENDCASE
//  dm:refresh(.T.)
*/
  IF( lChanged, (dm:save(), dm:refresh(.T.)), NIL )

RETURN lOK


METHOD SYS_licasys_SCR:destroy()
  ::drgUsrClass:destroy()
RETURN NIL


METHOD SYS_licasys_SCR:licasysIn()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SYS_licasys_IN,' + ::typIn PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self



**  Aktualizace uživatele
** CLASS for SYS_users_IN *********************************************
CLASS SYS_licasys_IN FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  postAppend
  METHOD  onSave
  METHOD  getForm

  METHOD  destroy

  VAR     paswordCheck
  VAR     newRec


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::onSave()
      if nEvent = drgEVENT_EXIT
        PostAppEvent(xbeP_Close, nEvent,,oXbp)
      endif
      RETURN .t.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR typ, dm, msg

ENDCLASS


METHOD SYS_licasys_IN:init(parent)

//  drgDBMS:open('LICENCE',,,,,"USERStm")

  ::drgUsrClass:init(parent)

RETURN self


METHOD SYS_licasys_IN:getForm()
  LOCAL drgFC, cParm, oDrg

  cParm    := drgParseSecond(::drgDialog:initParam)
  ::newRec := IF( cParm == "APPEND", .T., .F.)

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,13 DTYPE '10' TITLE 'Modifikace licenèních údajù' GUILOOK 'All:Y,Border:Y,Action:N' POST 'postValidate' FILE 'LICASYS'

//  DRGAction INTO drgFC CAPTION 'Návrh' EVENT 'LL_DefineDesign'  TIPTEXT 'Návrh tiskového výstupu'// ICON1 101 ICON2 201 ATYPE 3

//  DRGSTATIC INTO drgFC FPOS 0.5,0.07 SIZE 99.1,7.6 STYPE XBPSTATIC_TYPE_RECESSEDRECT
    DRGTEXT INTO drgFC CAPTION 'Název firmy' CPOS 1,0.5 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->CNAZFIRMY INTO drgFC CPOS 25,0.5 CLEN 50 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
*     oDrg:push := 'firmy'
*     DRGGET LICENCE->nCisFirmy INTO drgFC FPOS 85,0.5 FLEN 5 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'IÈO/DIÈ'  CPOS 1,1.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->cico INTO drgFC CPOS 25,1.4 CLEN 12 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->cdic INTO drgFC CPOS 45,1.4 CLEN 25 // FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'Název pro pøihlášení' CPOS 1,2.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET LICASYS->CNAZFIRPRI INTO drgFC FPOS 25,2.4 FLEN 50 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Zkratka firmy'  CPOS 1,3.4 CLEN 20  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->CZKRNAZEV INTO drgFC CPOS 25,3.4 CLEN 15 PP 2 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
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
    DRGTEXT LICASYS->nIdUzivSW INTO drgFC CPOS 25,8.4 CLEN 18  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'IDdatabáze' CPOS 1,9.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->nUsrIdDB INTO drgFC CPOS 25,9.4 CLEN 18  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'IDlicence' CPOS 1,10.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT LICASYS->cLicence INTO drgFC CPOS 25,10.4 CLEN 25  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Název dat.adresáøe' CPOS 1,11.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET LICASYS->cDataDir INTO drgFC FPOS 25,11.4 FLEN 50  // FCAPTION 'Distribuèní hodnota' CPOS 1,2

*     DRGGET USERS->nCISOSOBY INTO drgFC FPOS 30,10.2 FLEN 0 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
//  DRGEND  INTO drgFC


RETURN drgFC


METHOD SYS_licasys_IN:drgDialogStart(drgDialog)
  LOCAL aUsers
  LOCAL n
  LOCAL oSle

  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager

  if !::newRec
//    oSle := ::dataManager:get('LICENCE->CUSER', .F.)// :oDrg:oXpb:xbpSle
//    osle:odrg:isEdit := .f.
//    osle:odrg:oxbp:disable()
  else
    ::postAppend()
  endif

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
METHOD SYS_licasys_IN:postValidate(drgVar)
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


* ok
method SYS_licasys_IN:postAppend()
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


METHOD SYS_licasys_IN:onSave()
  LOCAL aUsers
  LOCAL n

  IF( ::newRec, LICASYS->(dbAppend()), LICASYS->(dbRlock()))
  ::dm:save()
  LICASYS->(dbUnlock())

RETURN .T.




** END of CLASS ****************************************************************
METHOD SYS_licasys_IN:destroy()
  ::drgUsrClass:destroy()

RETURN NIL