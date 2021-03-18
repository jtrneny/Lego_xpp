#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Gra.ch"
#include "dbstruct.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"



*  POZEMKY
** CLASS HIM_pozemky_SCR ********************************************************
CLASS HIM_pozemkIT_SCR FROM drgUsrClass  // , quickFiltrs
EXPORTED:
  METHOD  eventHandled

  method  rozpPOZEMEK // ven

  inline method init(parent)
    ::drgUsrClass:init(parent)

    drgDBMS:open('pozemky' )   // pozemky hlavièky
    drgDBMS:open('pozemkit')   // pozemky položky
    drgDBMS:open('maj')        // him
    drgDBMS:open('c_katast')   // katastry nemovitostí
  return self


  inline method drgDialogStart(drgDialog)
    ::dc        := drgDialog:dialogCtrl              // dataCtrl
    ::df        := drgDialog:oForm                   // form
    ::msg       := drgDialog:oMessageBar             // messageBar
  return self


  inline method him_pozemkit_vypCen(drgDialog)
    local  odialog, nexi

    oDialog := drgDialog():new('HIM_pozemkit_vypCen',drgDialog)
    odialog:create(,,.T.)

    odialog:destroy()
    odialog := nil

*    ::itemMarked()
  return self


HIDDEN:
  VAR     dc, df, msg

  inline method postDelete()
    local  sid    := isNull(pozemky->sid,0)
    local  cc     := padc( str(pozemky->ninvCis,10) +' _ ' +pozemky->cku_kod +' _ ' +str(pozemky->nlistVlast,8) +' _ '+pozemky->cparcCis, 40 )
    *
    local  ctitle := 'Zrušení pozemku v evidenci ...'
    local  cinfo  := 'Promiòte prosím,'                                       +CRLF + ;
                     'požadujete zrušit pozemek v evidenci majetku ...' +CRLF +CRLF + ;
                      '[ ' +allTrim(cc) +' ]'
    *
    local  cStatement, oStatement
    local  stmt := "delete from pozemky  where sID = %sid;"    + ;
                   "delete from pozemkit where nPOZEMKY = %sid;"

    if sid <> 0
      nsel :=  ConfirmBox( , cinfo      , ;
                             ctitle     , ;
                             XBPMB_YESNO, ;
                             XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

      if nsel = XBPMB_RET_YES

        cinfo := 'Promiòte prosím,'                                               +CRLF + ;
                 'p.' +logOsoba                                                   +CRLF + ;
                 'OPRAVDU požadujete zrušit pozemek v evidenci majetku ...' +CRLF +CRLF + ;
                 '[ ' +allTrim(cc) +' ]'

        nsel := ConfirmBox( , cinfo    , ;
                              ctitle   , ;
                              XBPMB_YESNO                            , ;
                              XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )


        if nsel = XBPMB_RET_YES
          cStatement := strTran( stmt, '%sid', allTrim(str(sid)) )
          oStatement := AdsStatement():New(cStatement,oSession_data)

          if oStatement:LastError > 0
            *  return .f.
          else
            oStatement:Execute( 'test', .f. )
            oStatement:Close()
          endif
          pozemky->(dbskip())
        endif
      endif

      pozemky ->(dbcommit(), dbunlock())
      pozemkit->(dbcommit(), dbunlock())

      ::drgDialog:dialogCtrl:refreshPostDel()
    endif
  return .t.


ENDCLASS


*
********************************************************************************
METHOD HIM_pozemkIT_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
*  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
*    ::itemSelected()

  case  nEvent = drgEVENT_DELETE
    ::postDelete()
    return .T.

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


method him_pozemkIT_SCR:rozpPOZEMEK()
  local oDialog

//  ::drgdialog:odbrowse[1]:arselect

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'him_pozemkit_rozp_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()

RETURN self


*  Rozpoèítání výmìry pozemku
** CLASS for him_pozemky_rozp_CRD *********************************************
CLASS him_pozemkit_rozp_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  getForm
  METHOD  drgDialogStart
  METHOD  postValidate, onSave

  VAR     rozloha, cenacelkem, pocet

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::onSave()
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
      RETURN .t.

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
  VAR     dm, msg
  VAR     aselrec

ENDCLASS


method him_pozemkit_rozp_CRD:init(parent)
  local  filename, filedesc

  ::drgUsrClass:init(parent)
  drgDBMS:open('POZEMKIT',,,,,'POZEMKITc')

  ::aselrec    := parent:parent:odbrowse[1]:arselect

  ::rozloha    := 0
  ::cenacelkem := 0
  ::pocet      := Len( ::aselrec)

  for n := 1 to len( ::aselrec)
    pozemkitc->( dbGoTo(::aselrec[n]))
    ::rozloha += pozemkitc->nvymera_m2
  next

  * tady nevím jestli zap *
//  drgDBMS:open('POZEMKYw',.T.,.T.,drgINI:dir_USERfitm);ZAP
//  mh_COPYFLD('POZEMKY', 'POZEMKYw', .T.)

return self


method him_pozemkit_rozp_CRD:getForm()
  LOCAL oDrg, drgFC
  local n
  LOCAL cVal := ''
  local defOpr

//  defOpr := defaultDisUsr('Forms','CTYPFORMS')

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,6.3 DTYPE '10' TITLE 'Rozpoèítání ceny pozemkù' ;
                       GUILOOK 'All:Y,Border:Y,Action:N';
                       PRE 'preValidate' POST 'postValidate'

  DRGPUSHBUTTON INTO drgFC CAPTION 'Spustit' POS 70,5 SIZE 25,1.2 ;
    EVENT 'onSave' ICON1 DRG_ICON_SAVE ICON2 gDRG_ICON_SAVE ATYPE 3 ;
    TIPTEXT 'Spustit pøepoèet'

  DRGSTATIC INTO drgFC STYPE 14 SIZE 98,4.1 FPOS 1,0.4
  DRGTEXT INTO drgFC CAPTION 'Údaje pro pøepoèet'  CPOS 2,0.3 CLEN 35 PP 3// FCAPTION 'Distribuèní hodnota' CPOS 1,2
//  DRGTEXT INTO drgFC CAPTION 'Typ formuláøe'  CPOS 2,1.6 CLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
//   DRGCOMBOBOX pozemky->npozemek  INTO drgFC FPOS 2,2.6 FLEN 15 VALUES defOpr PP 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Celková cena'     CPOS 2,1.6 CLEN 21 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGGET M->cenacelkem INTO drgFC FPOS 2,2.6 FLEN 15 PP 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Poèet vybraných parcel'  CPOS 50,1.6 CLEN 21  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGTEXT M->pocet  INTO drgFC CPOS 50,2.6 CLEN 15 PP 2 BGND 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Rozloha vybraných parcel'  CPOS 75,1.6 CLEN 21 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGTEXT M->rozloha  INTO drgFC CPOS 77,2.6 CLEN 15 PP 2 BGND 2//PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2


return drgFC


method him_pozemkit_rozp_CRD:drgDialogStart(drgDialog)
  local typ, cval

  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager

  ::dm:refresh()

//  typ   := defaultDisUsr('Forms', 'DEFAULTOPR')

//  cval  := newIDforms(typ)
//  ::dataManager:set("formsw->cidforms", cval)

return self


method him_pozemkit_rozp_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval

/*
  do case
  case(name = 'formsw->ctypforms')
    if !Empty( value) .and. changed
      cval := newIDforms(value)
      ::dataManager:set("formsw->cidforms", cval)
    endif

  case(name = 'formsw->cidforms')
    if !Empty( value) .or.  changed
      if FORMSc->(dbSeek(Upper(value),, AdsCtag(1) ))
         drgNLS:msg('Pod tímto ID již sestava existuje ...')
         lOK := .F.
      endif
    endif

  case(name = 'formsw->cformname')
    if Empty( value)
      drgNLS:msg('Název sestavy je povinný údaj ...')
      lOk := .F.
    endif

  endcase

*/


//  if( changed .and. .not. ::changeFRM, ::changeFRM := .T., NIL)

  ** ukládáme pøi zmìnì do tmp **
//  if(lOK, ::msg:writeMessage(), NIL)
//  if( changed, ::dm:refresh(.T.), NIL )

return lOk


method him_pozemkit_rozp_CRD:onSave()
  local  n
  local  dan
  local  procento,procdan
  local  zbyvacel,zbyvadan

//  ( ::dm:save(), mh_COPYFLD('POZEMKYw', 'POZEMKY', .T.))
//  forms->ncisforms := Val(Right(formsw->cidforms,6))

  if drgIsYESNO(drgNLS:msg('Spustit pøepoèet ceny vybraných pozemkù ?'))

    ::dm:save()

    dan      := ::cenacelkem * 0.04
    procento := ::cenacelkem/::rozloha
    procdan  := dan/::rozloha
    zbyvacel := ::cenacelkem
    zbyvadan := dan

    for n := 1 to len(::aselrec)
      pozemkitc->( dbGoTo(::aselrec[n]))
      if pozemkitc->( dbRlock())
        if n < len(::aselrec)
          pozemkitc->ncenapoz   := pozemkitc->nvymera_m2 *procento
          pozemkitc->ndannabpoz := pozemkitc->nvymera_m2 *procdan

          zbyvacel -= pozemkitc->ncenapoz
          zbyvadan -= pozemkitc->ndannabpoz
        else
          pozemkitc->ncenapoz   := zbyvacel
          pozemkitc->ndannabpoz := zbyvadan
        endif
        pozemkitc->ncenasdana := pozemkitc->ncenapoz +pozemkitc->ndannabpoz
      endif
      pozemkitc->( dbUnLock())
    next
  endif

  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

return .T.