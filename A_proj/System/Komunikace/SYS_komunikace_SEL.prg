#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "dmlb.ch"
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


**  Výbìr z typù komunikací v nabídce v programu
** CLASS for SYS_komunikace_SEL *********************************************
CLASS SYS_komunikace_SEL FROM drgUsrClass

EXPORTED:
  METHOD  itemSelected
  METHOD  init, getForm, drgDialogStart
  METHOD  itemMarked
  METHOD  SYS_komunik_IN

  *

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected(.F.)
      Return .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
        RETURN .F.
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR  key, typcom

ENDCLASS


METHOD SYS_komunikace_SEL:init(parent)

  ::drgUsrClass:init(parent)
  ::key    := ''
  ::typcom := .T.

  drgDBMS:open('DATKOMHD')
  drgDBMS:open('KOMUSERS',,,,,'KOMUSERSc')

RETURN self


METHOD SYS_komunikace_SEL:getForm()
  LOCAL drgFC
  LOCAL cParm

  cParm    := drgParseSecond(::drgDialog:initParam)
  ::key    := Left( cParm, 60)
  ::typcom := Right(cParm,1) == 'A'

  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 65,20 DTYPE '10' TITLE 'Komunikace - výbìr' ;
                       GUILOOK 'All:Y,Border:Y,Action:Y';
                       PRE 'preValidate' POST 'postValidate'

* Browser definition
  DRGDBROWSE INTO drgFC FPOS 0.5,0.057 SIZE 64.2,19.8 FILE 'DATKOMHD'            ;
    FIELDS 'CNAZDATKOM:Datová komunikace,'                                  + ;
           'CIDDATKOM:ID komunikace,'                                       + ;
           'CTYPDATKOM:Typ komunikace,'                                     + ;
           'CZKRDATKOM:Zkratka,'                                            + ;
           'CTASK:Úloha systému,'                                           + ;
           'CUSER:Zkratka uživatele,'                                       + ;
           'CMAINFILE:Øídící soubor'                                          ;
            ITEMMARKED 'itemMarked' ITEMSELECTED 'itemSelected'               ;
            SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'

  DRGAction INTO drgFC CAPTION 'Tvorba' EVENT 'SYS_komunikace_IN'        TIPTEXT 'Definice typù komunikací'// ICON1 101 ICON2 201 ATYPE 3

*           'CIDFILTERS:ID filtru,'                                          + ;


RETURN drgFC


METHOD SYS_komunikace_SEL:drgDialogStart()
  if( .not. DATKOMHD->(dbSeek(Upper(KOMUSERS->cIddatkom),, AdsCtag(1) )), DATKOMHD->(DbGoTop()), nil)
RETURN SELF


METHOD SYS_komunikace_SEL:itemSelected()
  local  mod

  if KOMUSERSc->(dbSeek( Upper( ::key) +Upper(DATKOMHD->CIDDATKOM),, AdsCtag(3) ))
      drgMsgBox(drgNLS:msg('Tento typ komunikace již máte vybrán !!!'))
  else
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  endif
RETURN SELF


*
** itemMarked for all **
METHOD SYS_komunikace_SEL:itemMarked()
RETURN NIL


*
method SYS_komunikace_SEL:SYS_komunik_IN()
  LOCAL oDialog

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SYS_komunikace_IN' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
RETURN self
*