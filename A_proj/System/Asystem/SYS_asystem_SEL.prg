#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"



*
**
CLASS SYS_asystem_sel FROM drgUsrClass
EXPORTED:
  method  init, getForm, itemSelected

  inline method drgDialogStart(drgDialog)
*    ::sys_filtrs:init(drgDialog)
    return self


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected(.F.)
      RETURN .T.

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


METHOD SYS_asystem_sel:init(parent)
  local filtr
  local null := 0

  ::drgUsrClass:init(parent)

  cParm    := drgParseSecond(::drgDialog:initParam)
  ::key    := cParm

  drgDBMS:open('asystem')
*  filtr := Format("nsysAct <> '%%'", {null})
  filtr := "nsysAct <> 0"
  asystem->( ads_setaof(filtr),DbGoTop())

*  drgDBMS:open('FILTRITw',.T.,.T.,drgINI:dir_USERfitm);ZAP

RETURN self


METHOD SYS_asystem_sel:getForm()
  LOCAL drgFC
  LOCAL cParm


  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 92,20 DTYPE '10' TITLE 'Objekty - výbìr' GUILOOK 'All:Y,Border:Y,Action:Y'

*  DRGAction INTO drgFC CAPTION 'Filtr' EVENT 'SYS_formsmle_CRD'  TIPTEXT 'Návrh podmínky filtru'

* Browser definition
  DRGDBROWSE INTO drgFC FPOS 0,0.05 SIZE 91,19 FILE 'ASYSTEM'    ;
    FIELDS 'cIdObject,'                                    + ;
           'cNameObj,'                                     + ;
           'cTask,'                                        + ;
           'cTypObject,'                                   + ;
           'cZkrObject,'                                   + ;
           'cCaption,'                                     + ;
           'cPrgObject,'                                   + ;
           'mObject'                                       ;
            SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'
RETURN drgFC


METHOD SYS_asystem_sel:itemSelected()

*  if FLTUSERSc->(dbSeek( Upper(::key) +Upper(FILTRS->CIDFILTERS),, AdsCtag(3) ))
*      drgMsgBox(drgNLS:msg('Filtr již máte vybrán !!!'))
*  else
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
*  endif
RETURN SELF


*
**
CLASS SYS_asystem_tsk_sel FROM drgUsrClass
EXPORTED:

  inline method init(parent)
    local filtr
    local null := 0

    ::drgUsrClass:init(parent)

    cParm    := drgParseSecond(::drgDialog:initParam)
    ::key    := cParm

    drgDBMS:open('asystem')
    *  filtr := Format("nsysAct <> '%%'", {null})
*    filtr := "nsysAct <> 0"
*     asystem->( ads_setaof(filtr),DbGoTop())
  return self

  inline method getForm()
    local drgFC := drgFormContainer():new()
    local cParm

    DRGFORM INTO drgFC SIZE 92,20 DTYPE '10' TITLE 'Objekty - výbìr' GUILOOK 'All:Y,Border:Y,Action:Y'

* Browser definition
    DRGDBROWSE INTO drgFC FPOS 0,0.05 SIZE 91,19 FILE 'ASYSTEM'    ;
      FIELDS 'cPrgObject::30,'                               + ;
             'cIdObject,'                                    + ;
             'cNameObj::80,'                                 + ;
             'cTask,'                                        + ;
             'cTypObject,'                                   + ;
             'cZkrObject,'                                   + ;
             'cCaption,'                                     + ;
             'mObject'                                       ;
              SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'
  return drgFC

  inline method drgDialogStart(drgDialog)
*    ::sys_filtrs:init(drgDialog)
  return self


  inline method itemSelected()

*  if FLTUSERSc->(dbSeek( Upper(::key) +Upper(FILTRS->CIDFILTERS),, AdsCtag(3) ))
*      drgMsgBox(drgNLS:msg('Filtr již máte vybrán !!!'))
*  else
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
*  endif
  return self


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected(.F.)
      RETURN .T.

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

