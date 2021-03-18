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


**  Verze systému  - výbìr
** CLASS for SYS_verze_SEL *********************************************
CLASS SYS_verze_SEL FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  getForm
  METHOD  EventHandled
  METHOD  itemSelected

  METHOD  destroy


ENDCLASS


METHOD SYS_verze_SEL:init(parent)
  LOCAL cparm

  ::drgUsrClass:init(parent)
  cParm    := drgParseSecond(::drgDialog:initParam)

  drgDBMS:open('ASYSVER')

RETURN self


*
********************************************************************************
METHOD SYS_verze_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    ::itemSelected()

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.



METHOD SYS_verze_SEL:getForm()
  LOCAL drgFC, cParm, oDrg

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 45,25 DTYPE '10' TITLE 'Pøehled plánovaných a vydaných verzí systému' GUILOOK 'All:Y,Border:Y,Action:N'

*  DRGAction INTO drgFC CAPTION '~Stažení' EVENT 'saveVer'  TIPTEXT 'Stažení instalaèního souboru ASYSTEM++'// ICON1 101 ICON2 201 ATYPE 3
*  DRGAction INTO drgFC CAPTION '~Instalace' EVENT 'instalVer'  TIPTEXT 'Instalace nové verze ASYTEM++'// ICON1 101 ICON2 201 ATYPE 3

  DRGDBROWSE INTO drgFC FPOS 0.5,0.05 SIZE 44.0,24.7 FILE 'ASYSVER'          ;
    FIELDS 'cVerze,'                                    + ;
           'dVznikVer,'                                   ;
           ITEMMARKED 'itemMarked' SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'yy'


RETURN drgFC


METHOD SYS_verze_SEL:drgDialogStart(drgDialog)
  LOCAL aUsers
  LOCAL n
  LOCAL oSle

*  ::msg    := drgDialog:oMessageBar             // messageBar
*  ::dm     := drgDialog:dataManager             // dataMabanager


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
********************************************************************************
METHOD SYS_verze_SEL:itemSelected()

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

RETURN self


** END of CLASS ****************************************************************
METHOD SYS_verze_SEL:destroy()
  ::drgUsrClass:destroy()

RETURN NIL