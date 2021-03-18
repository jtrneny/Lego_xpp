#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"

// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"



*
**
CLASS SYS_filtrs_sel FROM drgUsrClass, sys_filtrs
EXPORTED:
  method  init, getForm, itemSelected
  *
  method  sys_filtrs_in

  inline method drgDialogStart(drgDialog)
    ::sys_filtrs:init(drgDialog)
    return self


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected(.F.)
      RETURN .T.

    case nevent = drgEVENT_APPEND
      ::sys_filtrs_in()
      return .t.

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

HIDDEN:
  VAR  key

ENDCLASS


METHOD SYS_filtrs_sel:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('FILTRS')
  drgDBMS:open('FILTRITw',.T.,.T.,drgINI:dir_USERfitm);ZAP
  drgDBMS:open('FLTUSERS',,,,,'FLTUSERSc')

RETURN self


METHOD SYS_filtrs_sel:getForm()
  LOCAL drgFC
  LOCAL cParm

  cParm    := drgParseSecond(::drgDialog:initParam)
  ::key    := Left( cParm, 60)

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,25 DTYPE '10' TITLE 'Filtr - výbìr' GUILOOK 'All:Y,Border:Y,Action:N'

* Browser definition
  DRGDBROWSE INTO drgFC FPOS 0,0.05 SIZE 99,11.4 FILE 'FILTRS'    ;
    FIELDS 'M->is_complet::2.7::2,'      + ;
           'CFLTNAME:Název filtru:60,'   + ;
           'cTASK:úloha:10,'             + ;
           'cMAINFILE:hlavní soubor:10,' + ;
           'CIDFILTERS:ID_filtru:17'       ;
            ITEMMARKED 'itemMarked' ITEMSELECTED 'itemSelected' ;
            SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'

  DRGDBROWSE INTO drgFC FPOS .5,11.8 SIZE 99,13.2 FILE 'FILTRITw' ;
    FIELDS 'CLGATE_1:(,'           + ;
           'CLGATE_2:(,'           + ;
           'CLGATE_3:(,'           + ;
           'CLGATE_4:(,'           + ;
           'CFILE_1:table:9,'      + ;
           'CVYRAZ_1u:výraz-L:24,' + ;
           'CRELACE:oper:6.5,'     + ;
           'CFILE_2:table:9,'      + ;
           'CVYRAZ_2u:výraz-P:24,' + ;
           'CRGATE_1:),'           + ;
           'CRGATE_2:),'           + ;
           'CRGATE_3:),'           + ;
           'CRGATE_4:),'           + ;
           'COPERAND::7'             ;
            SCROLL 'ny' CURSORMODE 3 PP 7 HEADMOVE 'n'
RETURN drgFC


method SYS_filtrs_sel:itemSelected()
  if FLTUSERSc->(dbSeek( Upper(::key) +Upper(FILTRS->CIDFILTERS),, AdsCtag(3) ))
      drgMsgBox(drgNLS:msg('Filtr již máte vybrán !!!'))
  else
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  endif
return self


method sys_filtrs_sel:sys_filtrs_in()
  local  odialog, nexit := drgEVENT_QUIT
  local  obro := ::dc:obrowse[1]:oxbp

  *
  DRGDIALOG FORM 'SYS_filtrs_IN' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

  obro:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,obro)
return .t.