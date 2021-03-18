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


**  Seznam systémových objektù a funkcí
** CLASS for SYS_asystem_SCR_SYS *********************************************
CLASS SYS_asystem_SCR FROM drgUsrClass

EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  onSave
  METHOD  postValidate

  METHOD  destroy             // release all resources used by this object

  METHOD  getForm
  METHOD  asystemIn
  METHOD  copyRec

  VAR     typIn

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
    CASE nEvent = drgEVENT_EDIT //.OR. nEvent = xbeM_LbDblClick // .OR. nEvent = drgEVENT_FORMDRAWN
      ::typIn := "EDIT"
//    USERS->(dbRlock())
      ::asystemIN()
      dc:oBrowse[1]:refresh(.T.)
      RETURN .T.
    RETURN .T.

    CASE nEvent = drgEVENT_APPEND
      ::typIn := "APPEND"
      ::asystemIN()
      dc:oBrowse[1]:refresh(.T.)
      RETURN .T.

    case nEvent = drgEVENT_APPEND2
      ::copyRec()
//      if( oXbp:ClassName() <> 'XbpCheckBox', ::copyRec(), NIL)
      ::typIn := "EDIT"
      ::asystemIN()
      dc:oBrowse[1]:refresh(.T.)
      Return .T.

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
  return .f.

HIDDEN:
  VAR    dm, dctrl


ENDCLASS


METHOD SYS_asystem_SCR:init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('ASYSTEM')

RETURN self


METHOD SYS_asystem_SCR:getForm()
  LOCAL drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 85,25 DTYPE '10' TITLE 'Programové objekty a funkce' GUILOOK 'All:Y,Border:Y,Action:Y'

*  DRGAction INTO drgFC CAPTION '~DemoLic' EVENT 'demoLic'  TIPTEXT 'Vytvoøení demo licenèního souboru'// ICON1 101 ICON2 201 ATYPE 3
*  DRGAction INTO drgFC CAPTION '~DistrLic' EVENT 'distrLic'  TIPTEXT 'Vytvoøení distribuèního licenèního souboru'// ICON1 101 ICON2 201 ATYPE 3

  DRGDBROWSE INTO drgFC FPOS 0.5,0.05 SIZE 84.0,24.7 FILE 'ASYSTEM'          ;
    FIELDS 'cIdObject,'                                    + ;
           'cTask,'                                        + ;
           'nSysAct,'                                      + ;
           'cTypObject,'                                   + ;
           'cZkrObject,'                                   + ;
           'cNameObj,'                                     + ;
           'cCaption,'                                     + ;
           'nSysAct,'                                      + ;
           'lObdReport,'                                   + ;
           'cPrgObject,'                                   + ;
           'mObject,'                                      + ;
           'mBrowse,'                                      + ;
           'mPopisObj'                                       ;
           ITEMMARKED 'itemMarked' SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'yy'

RETURN drgFC


METHOD SYS_asystem_SCR:drgDialogStart(drgDialog)

  ::dm       := drgDialog:dataManager
  ::dctrl    := drgDialog:dialogCtrl


RETURN self


*
*****************************************************************
METHOD SYS_asystem_SCR:onSave(lIsCheck,lIsAppend)                                 // kotroly a výpoèty po uložení
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
METHOD SYS_asystem_SCR:postValidate(drgVar)
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


METHOD SYS_asystem_SCR:destroy()
  ::drgUsrClass:destroy()
RETURN NIL


METHOD SYS_asystem_SCR:asystemIn()
LOCAL oDialog
//  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SYS_asystem_IN,' + ::typIn PARENT ::drgDialog MODAL DESTROY
//  ::drgDialog:popArea()                  // Restore work area
RETURN self



METHOD SYS_asystem_SCR:copyRec()

  drgDBMS:open('asystem',,,,,'asystem_b')
  asystem_b->(dbgoto( asystem->(Recno())))
  * tady nevím jestli zap *
  mh_COPYFLD('asystem_b', 'asystem', .T.)

  asystem->cIDobject := newIDasys()

  asystem->cverze      := verzeAsys[3,2]
  asystem->cverzefi    := verzeAsys[3,2]

  asystem->cverzedb    := SpecialBuild
  asystem->cverzedbfi  := SpecialBuild

RETURN .T.



**  Aktualizace uživatele
** CLASS for SYS_users_IN *********************************************
CLASS SYS_asystem_IN FROM drgUsrClass
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
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
      RETURN .t.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR typ, dm, msg

ENDCLASS


METHOD SYS_asystem_IN:init(parent)

*  drgDBMS:open('ASYSTEM')

  ::drgUsrClass:init(parent)
  ::dm  := ::drgDialog:dataManager             // dataMabanager


RETURN self


METHOD SYS_asystem_IN:drgDialogStart(drgDialog)
  local cval

  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager

  if !::newRec
//    oSle := ::dataManager:get('LICENCE->CUSER', .F.)// :oDrg:oXpb:xbpSle
//    osle:odrg:isEdit := .f.
//    osle:odrg:oxbp:disable()
  else
    ::postAppend()
    cval := newIDasys()
    ::dataManager:set("asystem->cidobject", cval)

    ::dm:set("asystem->cverze"  , verzeAsys[3,2])
    ::dm:set("asystem->cverzedb", SpecialBuild)

    ::dm:set( 'asystem->cverzeFi'  , verzeAsys[3,2] )
    ::dm:set( 'asystem->cverzeDBFi', SpecialBuild   )
  endif
RETURN self



METHOD SYS_asystem_IN:getForm()
  LOCAL drgFC, cParm, oDrg

  cParm    := drgParseSecond(::drgDialog:initParam)
  ::newRec := IF( cParm == "APPEND", .T., .F.)

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,22 DTYPE '10' TITLE 'Modifikace programových objektù a funkcí' GUILOOK 'All:Y,Border:Y,Action:N' POST 'postValidate' FILE 'ASYSTEM'

    DRGTEXT INTO drgFC CAPTION 'ID objektu'  CPOS 1,0.5 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET ASYSTEM->CIDOBJECT INTO drgFC FPOS 25,0.5 FLEN 10 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
     odrg:isedit_inrev := .f.

    DRGTEXT INTO drgFC CAPTION 'Zpùsob distribuce'  CPOS 42,0.5 CLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGCOMBOBOX ASYSTEM->NDISTRIB INTO drgFC FPOS 60,0.5 FLEN 37 ;
        VALUES '0:nedistribuje se,1:vždy se distribuje a pøepisuje,2:vždy se distribuje a pouze se pøidá'

*     oDrg:push := 'firmy'
*     DRGGET LICENCE->nCisFirmy INTO drgFC FPOS 85,0.5 FLEN 5 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Úloha'  CPOS 1,1.6 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET ASYSTEM->CTASK INTO drgFC FPOS 25,1.6 FLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
      DRGTEXT C_TASK->cNazUlohy INTO drgFC CPOS 42,1.6 CLEN 40 // FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'Typ objektu'  CPOS 1,2.6 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET ASYSTEM->CTYPOBJECT INTO drgFC FPOS 25,2.6 FLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
      DRGTEXT C_OBJECT->cNazTypObj INTO drgFC CPOS 42,2.6 CLEN 40 // FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'Zkratka objektu'  CPOS 1,3.8 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET ASYSTEM->CZKROBJECT INTO drgFC FPOS 25,3.8 FLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'Zpùsob aut.startu'  CPOS 42,3.8 CLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGCOMBOBOX ASYSTEM->NRUNTASK INTO drgFC FPOS 60,3.8 FLEN 37 ;
        VALUES '0:nespouští se,1:client,2:služba,3:client i služba'


    DRGTEXT INTO drgFC CAPTION 'Název objektu' CPOS 1,5.0 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET ASYSTEM->CNAMEOBJ INTO drgFC FPOS 25,5.0 FLEN 50 // FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'Zkrácený název-popis'  CPOS 1,6.2 CLEN 20  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET ASYSTEM->CCAPTION INTO drgFC FPOS 25,6.2 FLEN 50 PP 2 // FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'Možnost nastavit oprávnìní'  CPOS 1,7.4 CLEN 24  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGCOMBOBOX ASYSTEM->NSYSACT INTO drgFC FPOS 25,7.4 FLEN 30 ;
        VALUES '0:nenastavit,1:spouštìt a všechny klávesy,2:jen spouštìt,3:spouštìt a jen INS'

    DRGTEXT INTO drgFC CAPTION 'Zobraz.int.filtr období'  CPOS 56,7.4 CLEN 17  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET ASYSTEM->lobdReport INTO drgFC FPOS 75,7.4 FLEN 4 PP 2//PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'tabulka DB'  CPOS 42,8.6 CLEN 10
     DRGGET ASYSTEM->cTableDB INTO drgFC FPOS 52,8.6 FLEN 10 PP 2


    DRGTEXT INTO drgFC CAPTION 'Platnost od      verze EXE'  CPOS 1,9.8 CLEN 20
     DRGGET ASYSTEM->cVerze INTO drgFC FPOS 25,9.8 FLEN 10 PP 2 PICTURE '99.99.99'

    DRGTEXT INTO drgFC CAPTION 'verze DB'  CPOS 42,9.8 CLEN 10
     DRGGET ASYSTEM->cVerzeDB INTO drgFC FPOS 52,9.8 FLEN 10 PP 2 PICTURE '99.9999'


    DRGTEXT INTO drgFC CAPTION 'poø.aktualizace'  CPOS 67,9.8 CLEN 10
     DRGGET ASYSTEM->nPorAktual INTO drgFC FPOS 80,9.8 FLEN 10 PP 2

***
    DRGTEXT INTO drgFC CAPTION '['                   CPOS 25, 10.8 CLEN  2 CTYPE 2
      odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_BLUE'
    DRGTEXT asystem->cverzeFi INTO drgFC             CPOS 28, 10.8 CLEN 15 CTYPE 2

    DRGTEXT INTO drgFC CAPTION ' _ '                 CPOS 45, 10.8 CLEN  5 CTYPE 2
      odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_BLUE'
    DRGTEXT asystem->cverzeDBFi INTO drgFC           CPOS 51, 10.8 CLEN 15 CTYPE 2

    DRGTEXT INTO drgFC CAPTION ']'                   CPOS 68, 10.8 CLEN 2 CTYPE 2
      odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_BLUE'
***

    DRGTEXT INTO drgFC CAPTION 'Objekt(text)'  CPOS 1,12.2 CLEN 20
     DRGGET ASYSTEM->CPRGOBJECT INTO drgFC FPOS 25,12.2 FLEN 71 PP 2

    DRGTEXT INTO drgFC CAPTION 'Objekt(block)'  CPOS 1,13.2 CLEN 20
     DRGMLE ASYSTEM->MOBJECT INTO drgFC FPOS 25,13.6 SIZE 72,3.2 PP 2

    DRGTEXT INTO drgFC CAPTION 'Metodika'  CPOS 1,16.8 CLEN 20
     DRGMLE ASYSTEM->MMETODIKA INTO drgFC FPOS 25,17.2 SIZE 72,4.2 PP 2
RETURN drgFC



*
*****************************************************************
METHOD SYS_asystem_IN:postValidate(drgVar)
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
method SYS_asystem_IN:postAppend()
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


METHOD SYS_asystem_IN:onSave()
  local cverzeFi   := allTrim( ::dm:get( 'asystem->cverzeFi'   ))
  local cverzeDBFi := allTrim( ::dm:get( 'asystem->cverzeDBFi' ))
  local nverzeFi, nverzeDBFi

  local  oMoment := sys_moment()

  nverzeFi   := val( strTran( cverzeFi  , '.', ''))
  nverzeDBFi := val( strTran( cverzeDBFi, '.', ''))

  IF( ::newRec, ASYSTEM->(mh_Append()), ASYSTEM->(dbRlock()))
  ::dm:save()

  asystem->nverzeFi   := nverzeFi
  asystem->nverzeDBFi := nverzeDBFi

  ASYSTEM->(dbUnlock(), dbcommit() )
  oMoment:destroy()
RETURN .T.


** END of CLASS ****************************************************************
METHOD SYS_asystem_IN:destroy()

  ::drgUsrClass:destroy()

RETURN NIL


STATIC FUNCTION newIDasys()
  local newID
  local filtr

  drgDBMS:open('ASYSTEM',,,,,'ASYSTEMa')
*  filtr := Format("cIDforms = '%%'", {typ})
*  ASYSTEMa->( AdsSetOrder(1), ads_setaof(filtr), DBGoBotTom())
*  newID := typ + StrZero( Val( SubStr(FORMSa->cIDforms,5,6))+1, 6)
*  FORMSa->(ads_clearaof(), dbCloseArea())
  ASYSTEMa->( AdsSetOrder(4), DBGoBotTom())
  newID := 'DIST' + StrZero( Val( SubStr(ASYSTEMa->cIDobject,5,6))+1, 6)

RETURN(newID)