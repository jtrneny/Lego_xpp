#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "CLASS.CH"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


**  Správa uživatelù systému
** CLASS SYS_users_SCR *********************************************
CLASS SYS_usersgrp_SCR FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  itemMarked
  METHOD  getForm
  METHOD  grpIn, grpDel
  METHOD  grpMenu, grpUsers, emptyMNU
  METHOD  asysact

  METHOD  destroy

  VAR     typIn


  * je vytvoøeno menu pro skupinu uživatelù
  inline access assign method groupMenu_is() var groupmenu_is
    return if(empty(usersgrp->mmenugroup), 0, MIS_ICON_OK)

  * je vytvoøeno menu na uživatele
  inline access assign method userMenu_is() var usermenu_is
    return if(empty(users->mmenuuser), 0, MIS_ICON_OK)

  inline access assign method c_lastPrihl() var c_lastPrihl
    local  cdPrihl := if( empty( users->dprihlUser), space(10), dtoc(users->dprihlUser) )
    local  ccPrihl := if( empty( users->cprihlUser), space(10),      users->cprihlUser  )
    return if( empty(cdPrihl +ccPrihl), space(22), cdPrihl +' v ' +ccPrihl )


  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_APPEND
//    USERS->(dbAppend())
      ::typIn := "APPEND"
      ::grpIN()
      dc:oBrowse[1]:refresh(.T.)
      RETURN .T.

    CASE nEvent = drgEVENT_EDIT //.OR. nEvent = xbeM_LbDblClick // .OR. nEvent = drgEVENT_FORMDRAWN
      ::typIn := "EDIT"
//    USERS->(dbRlock())
      ::grpIN()
      dc:oBrowse[1]:refresh(.T.)
      RETURN .T.

    CASE nEvent = drgEVENT_DELETE
      ::grpDel()
      dc:oBrowse[1]:refresh(.T.)
      RETURN .T.

    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.


ENDCLASS

METHOD SYS_usersgrp_SCR:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('USERSGRP')
  drgDBMS:open('USERS'   )
RETURN self


METHOD SYS_usersgrp_SCR:getForm()
  LOCAL drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,25 DTYPE '10' TITLE 'Skupiny uživatelù systému' GUILOOK 'All:Y,Border:Y,Action:Y'

  DRGAction INTO drgFC CAPTION 'Uživatelé'   EVENT 'grpUsers'  TIPTEXT 'Uživatelé skupiny systému'     // ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION 'Menu'        EVENT 'grpMenu'   TIPTEXT 'Skupinové menu'                // ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION 'ZrušMenu'    EVENT 'emptyMNU'  TIPTEXT 'Zrušení nastaveného menu'      // ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION 'Oprávnìní'   EVENT 'asysact'   TIPTEXT 'Skupinová oprávnìní pøístupu'  // ICON1 101 ICON2 201 ATYPE 3

  DRGDBROWSE INTO drgFC FPOS .5, .05 SIZE 99,10 FILE 'USERSGRP'     ;
    FIELDS 'M->groupmenu_is::2.7::2,'                             + ;
           'CGROUP:Zkratka skupiny:10,'                           + ;
           'CNAMEGROUP:Jméno skupiny:37,'                         + ;
           'COPRAVNENI:Oprávnìní:20,'                             + ;
           'dPLATN_OD:Platnost OD:11,'                            + ;
           'dPLATN_DO:Platnost DO:11'                               ;
            ITEMMARKED 'itemMarked' SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y'


  DRGSTATIC INTO drgFC FPOS .5,10.2 SIZE 98.5, 1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX
    odrg:ctype := 2

    DRGTEXT     usersGrp->cnameGroup  INTO drgFc CPOS   22,.07 CLEN 30 FONT 5

    DRGTEXT INTO drgFC CAPTION '['      CPOS 53, .07 CLEN  2 FONT 5
      DRGTEXT     usersGrp->cGroup      INTO drgFc CPOS  56,.07 CLEN 15
    DRGTEXT INTO drgFC CAPTION ']'      CPOS 72, .07 CLEN 10.6 FONT 5
  DRGEND  INTO drgFC


  DRGDBROWSE INTO drgFC FPOS  .5, 11.5 SIZE 99,13.5 FILE 'USERS'  ;
    FIELDS 'M->usermenu_is::2.7::2,'                            + ;
           'COSOBA:Jméno osoby:30,'                             + ;
           'CUSER:zkratka,'                                     + ;
           'M->c_lastPrihl:pøihlášen dne:18,'                   + ;
           'DPLATN_OD:Platnost OD:10,'                          + ;
           'DPLATN_DO:Platnost DO:10,'                          + ;
           'COPRAVNENI:Oprávnìní,'                              + ;
           'NCISOSOBY:osÈíslo'                                    ;
            SCROLL 'yy' CURSORMODE 3 PP 9
RETURN drgFC


METHOD SYS_usersgrp_SCR:drgDialogStart(drgDialog)
RETURN self

METHOD SYS_usersgrp_SCR:itemMarked()
  local filtr := Format("cGroup = '%%'", {USERSGRP->cGroup})

  USERS->( ads_setaof(filtr),DbGoTop())
RETURN self


METHOD SYS_usersgrp_SCR:grpIn()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SYS_group_IN,' + ::typIn PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self


METHOD SYS_usersgrp_SCR:grpDel()
  LOCAL aUsers
  LOCAL n

//        if drgIsYESNO(drgNLS:msg( 'Zrušit uživatelský filtr <&> ?' , fltusers->cidfilters) )
  IF drgIsYESNO(drgNLS:msg( 'Zrušit skupinu uživatele <&> ?' , USERSGRP->CGROUP) )
    IF( USERSGRP->(dbRlock()), USERSGRP->( dbDelete(), dbUnlock()), NIL)
  ENDIF

RETURN .T.


METHOD SYS_usersgrp_SCR:grpUsers()
local oDialog, filtr

  ::drgDialog:pushArea()                  // Save work area

  filtr := Format("cGroup = '%%'", {USERSGRP->cGroup})
  USERS->( ads_setaof(filtr),DbGoTop())

  DRGDIALOG FORM 'SYS_users_SCR' PARENT ::drgDialog MODAL DESTROY

  USERS->(ads_clearaof())
  ::drgDialog:popArea()                  // Restore work area
RETURN self


METHOD SYS_usersgrp_SCR:grpMenu()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'Sys_users_Menu,GroupMenu' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self


METHOD SYS_usersgrp_SCR:emptyMNU()
  LOCAL n

//        if drgIsYESNO(drgNLS:msg( 'Zrušit uživatelský filtr <&> ?' , fltusers->cidfilters) )
  IF drgIsYESNO(drgNLS:msg( 'Zrušit menu skupiny <&> ?' , USERSGRP->CGROUP) )
    IF USERSGRP->(dbRlock())
     USERSGRP->MMENUGROUP := ''
     USERSGRP->( dbUnlock())
    endif
  ENDIF

RETURN .T.


METHOD SYS_usersgrp_SCR:asysact()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SYS_asysact_IN,GROUP' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self



** END of CLASS ****************************************************************
METHOD SYS_usersgrp_SCR:destroy()
  ::drgUsrClass:destroy()

RETURN NIL



**  Aktualizace uživatele
** CLASS for SYS_users_IN *********************************************
CLASS SYS_group_IN FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  postAppend
  METHOD  onSave
  METHOD  getForm
*  METHOD  config

  METHOD  destroy

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


METHOD SYS_group_IN:init(parent)

  drgDBMS:open('USERSGRP',,,,,"USERSGRPtm")

  ::drgUsrClass:init(parent)

RETURN self


METHOD SYS_group_IN:getForm()
  LOCAL drgFC, cParm, oDrg

  cParm    := drgParseSecond(::drgDialog:initParam)
  ::newRec := IF( cParm == "APPEND", .T., .F.)

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,10 DTYPE '10' TITLE 'Modifikace skupiny uživatelù systému' GUILOOK 'All:Y,Border:Y,Action:N' POST 'postValidate' FILE 'USERS'

//  DRGSTATIC INTO drgFC FPOS 0.5,0.07 SIZE 99.1,7.6 STYPE XBPSTATIC_TYPE_RECESSEDRECT
    DRGTEXT INTO drgFC CAPTION 'Název skupiny' CPOS 1,0.5 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERSGRP->CNAMEGROUP INTO drgFC FPOS 25,0.5 FLEN 50 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Zkratka skupiny'  CPOS 1,2.4 CLEN 20  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERSGRP->CGROUP INTO drgFC FPOS 25,2.4 FLEN 15 PP 2 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Systémové oprávnìní'  CPOS 1,5.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERSGRP->COPRAVNENI INTO drgFC FPOS 25,5.4 FLEN 15 PP 2
//     DRGTEXT C_OPRAVN->CNAZOPRAVN INTO drgFC CPOS 43,5.4 FLEN 30 BGND 13 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Platnost OD'  CPOS 1,7.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERSGRP->dPLATN_OD INTO drgFC FPOS 25,7.4 FLEN 15  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     oDrg:push := 'clickdate'
    DRGTEXT INTO drgFC CAPTION 'Platnost DO'  CPOS 1,8.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERSGRP->dPLATN_DO INTO drgFC FPOS 25,8.4 FLEN 15  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     oDrg:push := 'clickdate'


RETURN drgFC


METHOD SYS_group_IN:drgDialogStart(drgDialog)
  LOCAL aUsers, n, oSle, new_val

  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager

  if !::newRec
    oSle := ::dataManager:get('USERSGRP->CGROUP', .F.)// :oDrg:oXpb:xbpSle
    osle:odrg:isEdit := .f.
    osle:odrg:oxbp:disable()
  else
    ::postAppend()
  endif

  IF ::newRec
    ::dataManager:set("usersgrp->copravneni", "USR_ZAKLAD")
    ::dataManager:set("usersgrp->dPlatn_Od", Date())
  ENDIF

RETURN self

                                  *
*****************************************************************
METHOD SYS_group_IN:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval


  DO CASE
  CASE(name = 'usersgrp->cnamegroup')
    if Empty(value)
      ::msg:writeMessage('Jméno skupiny je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    endif

  CASE(name = 'usersgrp->cgroup')
    IF Empty(value)
      ::msg:writeMessage('Zkratka skupiny je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    ELSE
      IF ::newRec .AND. USERSGRPtm->(dbSeek(Upper(Padr(AllTrim( value) ,10)),, AdsCtag(1) ))
        ::msg:writeMessage('Zkratka skupiny již existuje, musíte zadat jinou ....',DRG_MSG_ERROR)
        lOk := .F.
      ENDIF
    ENDIF
  ENDCASE

  ** ukládáme pøi zmìnì do tmp **
  if(lOK, ::msg:writeMessage(), NIL)
//  if( changed, ::dm:refresh(.T.), NIL )

RETURN lOk



* ok
method SYS_group_IN:postAppend()
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


METHOD SYS_group_IN:onSave()
  LOCAL aUsers
  LOCAL n

  IF( ::newRec, USERSGRP->(dbAppend()), USERSGRP->(dbRlock()))
  ::dm:save()
  USERSGRP->(dbUnlock())

RETURN .T.



*METHOD SYS_group_IN:config()
*LOCAL oDialog
*  ::drgDialog:pushArea()                  // Save work area
*  DRGDIALOG FORM 'SYS_config_CRD,USER' PARENT ::drgDialog MODAL DESTROY
*  ::drgDialog:popArea()                  // Restore work area
*RETURN self



** END of CLASS ****************************************************************
METHOD SYS_group_IN:destroy()
  ::drgUsrClass:destroy()
RETURN NIL