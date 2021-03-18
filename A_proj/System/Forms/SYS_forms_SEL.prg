#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "dmlb.ch"
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


**  Výbìr sestavy k uživateli a nabídce v programu
** CLASS for SYS_forms_SEL *********************************************
CLASS SYS_forms_SEL FROM drgUsrClass

EXPORTED:
  METHOD  itemSelected
  METHOD  init, getForm, drgDialogStart
  METHOD  itemMarked
  METHOD  SYS_forms_IN

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
  VAR  key, report

ENDCLASS


METHOD SYS_forms_SEL:init(parent)

  ::drgUsrClass:init(parent)
  ::key    := ''
  ::report := .T.

  drgDBMS:open('FORMS')
  drgDBMS:open('FRMUSERS',,,,,'FRMUSERSc')
RETURN self


METHOD SYS_forms_SEL:getForm()
  LOCAL drgFC
  LOCAL cParm

  cParm    := drgParseSecond(::drgDialog:initParam)
  ::key    := Left( cParm, 60)
  ::report := Right(cParm,1) == 'A'

  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 65,20 DTYPE '10' TITLE 'Sestavy - výbìr' ;
                       GUILOOK 'All:Y,Border:Y,Action:Y';
                       PRE 'preValidate' POST 'postValidate'

* Browser definition
  DRGDBROWSE INTO drgFC FPOS 0.5,0.057 SIZE 64.2,19.8 FILE 'FORMS'                ;
    FIELDS 'CFORMNAME:Tiskový výstup,'                                      + ;
           'CIDFORMS:ID formuláøe,'                                         + ;
           'CIDFILTERS:ID filtru,'                                          + ;
           'NTYPPROJ_L:Typ výstupu,'                                        + ;
           'LISFORM:Formuláø,'                                              + ;
           'CTASK:Úloha systému,'                                           + ;
           'CUSER:Zkratka uživatele, '                                      + ;
           'CMAINFILE:Øídící soubor '                                         ;
            SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'

*  DRGAction INTO drgFC CAPTION 'Tvorba' EVENT 'SYS_forms_IN'        TIPTEXT 'Vytváøení tiskových výstupù'// ICON1 101 ICON2 201 ATYPE 3
RETURN drgFC


METHOD SYS_forms_SEL:drgDialogStart( drgDialog )
  if( .not. FORMS->(dbSeek(Upper(FRMUSERS->cIdForms),, AdsCtag(1) )), FORMS->(DbGoTop()), nil)

  drgDialog:odBrowse[1]:oxbp:refreshAll()
RETURN SELF


METHOD SYS_forms_SEL:itemSelected()
  local  mod

  if FRMUSERSc->(dbSeek( Upper( ::key) +Upper(FORMS->CIDFORMS),, AdsCtag(3) ))
      drgMsgBox(drgNLS:msg('Sestavu již máte vybranou !!!'))
  else
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  endif
RETURN SELF


*
** itemMarked for all **
METHOD SYS_forms_SEL:itemMarked()
RETURN NIL


*
method SYS_forms_SEL:SYS_forms_IN()
  LOCAL oDialog

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SYS_forms_IN' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
RETURN self
*