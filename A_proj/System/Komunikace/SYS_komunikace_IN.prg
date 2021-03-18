//////////////////////////////////////////////////////////////////////
//
//  SYS_komunikace_IN.PRG
//
//  Copyright:
//       MISS Software, s.r.o., (c) 2009. All rights reserved.
//
//  Contents:
//       Datová komunikace dialog pro založení definice.
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


**  Komunikace dat systému
** CLASS for SYS_komunikace_IN *********************************************
*   Modifikace tiskového formuláøe
** CLASS for SYS_forms_modi_CRD ************************************************
CLASS SYS_komunikace_IN FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  getForm
  METHOD  SYS_datkommle_CRD
  METHOD  postAppend, postValidate, onSave
  METHOD  comboBoxInit, comboBoxPre, destroy

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc   := ::drgDialog:dialogCtrl
    LOCAL save := .T.

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::onSave()
      ::changeFRM := .f.
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      RETURN .t.
//    CASE nEvent = drgEVENT_EXIT
//      if( ::changeFRM, ::onSave(), NIL)
//      Return .F.

    CASE nEvent = xbeP_Close
      if ::changeFRM
        if drgIsYESNO(drgNLS:msg('Došlo ke zmìnì v datech. Uložit záznam ?'))
          ::onSave()
        endif
      endif
      Return .F.

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
  VAR     arr, newRec, bloc, odrg_ctask
  VAR     dm, msg
  VAR     changeFRM
  VAR     iniCombo
  var     is_task_changed

ENDCLASS


METHOD SYS_komunikace_IN:init(parent)
  local  filename, filedesc
  local  x, obj, mod

  ::drgUsrClass:init(parent)
  drgDBMS:open('C_TASK')
  drgDBMS:open('ASYSTEM')
  drgDBMS:open('DEFVYKHD')
  drgDBMS:open('datkomhd')
  drgDBMS:open('datkomit')
  drgDBMS:open('datkomhd',,,,,'datkomhdc')

  datkomhd->(DbSetRelation( 'C_TASK',  {|| datkomhd->cTASK },'datkomhd->cTASK','C_TASK01'))
  datkomhd->(dbSkip(0))

  ::newRec := .not. (parent:cargo = drgEVENT_EDIT)

  ::changeFRM       := .F.
  ::iniCombo        := .t.
  ::is_task_changed := .f.

  mod  := drgParseSecond(::drgDialog:initParam)

//  ::newRec := if( mod == 'APP', .T., .F.)
  ::arr  := {}
  ::bloc := {}
  values := drgDBMS:dbd:values

  FOR x := 1 to LEN(values) STEP 1
    obj  := values[x,2]
    fileName := obj:fileName
    fileDesc := obj:description
    AAdd( ::arr, {fileName +':'+fileName +'.'+ fileDesc})
  NEXT

  defvykhd->( dbGoTop())
  do while .not.defvykhd->( Eof())
    AAdd( ::bloc, {defvykhd->cidvykazu +':'+ AllTrim(defvykhd->cnazvykazu)+'.'+AllTrim(defvykhd->ctypvykazu)})
    defvykhd->( dbSkip())
  enddo

RETURN self


method SYS_komunikace_IN:getForm()
  LOCAL drgFC, odrg
  local n
  local cVal  := ' , , , , , , , , , '
  local cvalb := ' , '
  local defOpr
  local rOnly := .f.

  drgFC := drgFormContainer():new()
  defOpr := defaultDisUsr('Komunik','CID')
  if .not. ::newRec
    rOnly  := if( At('DIST', defOpr)> 0, .f., datkomhd->cid = 'DIST')
    defOpr := 'DIST:distribuèní,USER:uživatelský'
  endif

  DRGFORM INTO drgFC SIZE 92,22 DTYPE '10' TITLE 'Modifikace definice datové komunikace' ;
                       GUILOOK 'All:Y,Border:Y,Action:N';
                       PRE 'preValidate' POST 'postValidate'


   DRGTABPAGE INTO drgFC CAPTION 'Komunikace' SIZE 91,21.2 OFFSET 1,82 FPOS 0.5,0.5 PRE 'tabSelect' TABHEIGHT 1.2

    DRGSTATIC INTO drgFC STYPE 14 SIZE 88.5,19.2 FPOS 1,0.4
    odrg:ctype := 2

    DRGTEXT INTO drgFC CAPTION 'Typ formuláøe      __________'  CPOS 2,.4 CLEN 23
     DRGCOMBOBOX datkomhd->cID  INTO drgFC FPOS 25,.4 FLEN 21 VALUES defOpr PP 2
     odrg:isedit_inrev := .f.

    DRGTEXT INTO drgFC CAPTION 'identifikace'  CPOS 55,.4 CLEN 10
    DRGTEXT datkomhd->cIDdatkom INTO drgFC CPOS 66,.4 CLEN 20 PP 2 BGND 13 FONT 5

    DRGTEXT INTO drgFC CAPTION 'Zkratka dat.komunikace _________'  CPOS 2,1.5 CLEN 23
     DRGGET datkomhd->czkrdatkom  INTO drgFC FPOS 25,1.5 FLEN 20 PP 2
     odrg:isedit_inrev := .f.

    DRGTEXT INTO drgFC CAPTION 'Název dat_kom __________'  CPOS 2,3 CLEN 23
     DRGGET datkomhd->cnazdatkom  INTO drgFC FPOS 25,3 FLEN 60 PP 2
     odrg:ronly := rOnly

    DRGTEXT INTO drgFC CAPTION 'Typ dat_kom        __________'  CPOS 2,4.6 CLEN 23
     DRGCOMBOBOX datkomhd->cTypDatKom INTO drgFC FPOS 25,4.6 FLEN 21 VALUES 'E:Export,I:Import,O:Obousmìrný' PP 2
     odrg:isedit_inrev := .f.

    DRGTEXT INTO drgFC CAPTION 'Úloha                   __________'  CPOS 2,5.7 CLEN 23
     DRGGET datkomhd->CTASK  INTO drgFC FPOS 25,5.7 FLEN 20 PP 2
     odrg:isedit_inrev := .f.
     DRGTEXT C_TASK->cNazUlohy INTO drgFC CPOS 48,5.7 CLEN 35

    DRGTEXT INTO drgFC CAPTION 'Øídící soubor        __________'  CPOS 2,6.8 CLEN 23
     DRGCOMBOBOX datkomhd->CMAINFILE  INTO drgFC FPOS 25,6.8 FLEN 61 VALUES cVal PP 2 PRE 'comboBoxPre'
     odrg:isedit_inrev := .f.

//  DRGTEXT INTO drgFC CAPTION 'Zpùsob zpracování  ________'  CPOS 2,6.9 CLEN 23
//   DRGCOMBOBOX FORMS->NTYPZPR INTO drgFC FPOS 25,6.9 FLEN 25 ;
//                              VALUES '0:stantartní zpracování,' + ;
//                                     '1:zpracování TMP funkce,' + ;
//                                     '2:uživatelský dialog' PP 2

    DRGTEXT INTO drgFC CAPTION 'Rozlišovací atribut _______'  CPOS 2,7.9 CLEN 23
     DRGGET datkomhd->cattr1  INTO drgFC FPOS 25,7.9 FLEN 20 PP 2
      odrg:ronly := rOnly

    DRGTEXT INTO drgFC CAPTION 'Externí blok     __________'  CPOS 2,9 CLEN 23
     DRGCOMBOBOX datkomhd->MBLOCKKOM INTO drgFC FPOS 25,9 FLEN 61 VALUES cvalb PP 2
     odrg:isedit_inrev := .f.

    DRGTEXT INTO drgFC CAPTION 'Datový model'  CPOS 2,11 CLEN 20 FONT 5
     DRGMLE datkomhd->mDATA_KOM INTO drgFC FPOS 2,12.0 SIZE 42,6.8 PP 2
     odrg:ronly := rOnly

    DRGTEXT INTO drgFC CAPTION 'Definice komunikace'  CPOS 45,11 CLEN 20 FONT 5
     DRGMLE datkomhd->mDEFIN_KOM INTO drgFC FPOS 45,12.0 SIZE 42,6.8 PP 2
     odrg:ronly := rOnly

    DRGEnd INTO drgFC
   DRGEnd INTO drgFC

   DRGTABPAGE INTO drgFC CAPTION 'Metodika' SIZE 91,21.2 OFFSET 16,68 FPOS 0.5,0.5 PRE 'tabSelect' TABHEIGHT 1.2
     DRGMLE datkomhd->mMetodika INTO drgFC FPOS 0.8,0.2 SIZE 89.0,19.3 POST 'postLastField'// FCAPTION 'Distribuèní hodnota' CPOS 1,2
      odrg:ronly := rOnly
//       drgFC:members[16]:ronly := .t.
//     DRGEND INTO drgFC
   DRGEND INTO drgFC

  DRGEnd INTO drgFC

//  DRGPushButton INTO drgFC CAPTION 'Návrh-FRM'  EVENT 'SYS_datkommle_CRD' POS 44,20.5 SIZE 15,1 TIPTEXT 'Zmìna v návrhu formuláøe'
return drgFC


method SYS_komunikace_IN:drgDialogStart(drgDialog)
  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager

  if( ::newRec, ::postAppend(), ::dm:refresh())
return self


* ok
method SYS_komunikace_IN:postAppend()
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
    case(type == 'M')  ;  val := ''
    endcase

    ovar:set(val)
    ovar:initValue := ovar:prevValue := ovar:value := val
  next
return .t.


METHOD SYS_komunikace_IN:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval

  do case
  case(name = 'datkomhd->cid')
    if changed
      cval := newIDdatcom(value)
      ::dataManager:set("datkomhd->ciddatkom", cval)
    endif

  case(name = 'datkomhd->ciddatkom')
    if !Empty( value) .or.  changed
      if datkomhdc->(dbSeek(Upper(value),,'DatKomH01'))
        MsgBox( 'Pod tímto ID již sestava existuje ...',DRG_MSG_ERROR)
         lOK := .F.
      endif
    endif

  case(name = 'datkomhd->czkrdatkom')
    if !Empty( value) .or.  changed
      if datkomhdc->(dbSeek(Upper(value),, 'DatKomH02'))
        MsgBox( 'Tato zkratka je již použita. Zadejte jinou ...', 'CHYBA...' )
        lOK := .F.
      endif
    endif
//  case(name = 'datkomhd->ctypdatkom')
//    if Empty( value) .and. (::newRec .or. changed)
//      cval := newIDdatkom(value)
//      ::dataManager:set("datkomhd->ciddatkom", cval)
//    endif

  case(name = 'datkomhd->cnazdatkom')
    if Empty( value)
      ::msg:writeMessage('Název definice je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    endif

  case( name = 'datkomhd->ctask' )
    if Empty( value)
      ::msg:writeMessage('Zkratka úlohy je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    endif
    ::is_task_changed := (drgVar:value <> drgVar:prevValue)

  case(name = 'datkomhd->cmainfile')
    if !Empty( value) .and. (::newRec .or. changed)
      cval := '[DefineField]' + Chr(13)+Chr(10)                              ;
                +'  [Table:'+AllTrim(value)+']'+ Chr(13)+Chr(10)             ;
                +'    [SortOrder]' + Chr(13)+Chr(10)                         ;
                +'    [Relations]'+ Chr(13)+Chr(10)
      ::dataManager:set("datkomhd->mdata_kom", cval)
      ::drgDialog:dataManager:refresh('datkomhd->mdata_kom')
    endif

    if Lower(AllTrim(value)) == "vykazw"
      drgDBMS:open('DEFVYKHD')
      ::drgDialog:dataManager:set('datkomhd->mblockkom', AllTrim(defvykhd->cnazvykazu)+'.'+AllTrim(defvykhd->ctypvykazu))
      ::drgDialog:dataManager:refresh('datkomhd->mblockkom')
    endif

  endcase

  if( changed .and. .not. ::changeFRM, ::changeFRM := .T., NIL)
RETURN lOk


method SYS_komunikace_IN:onSave()
  LOCAL aUsers
  LOCAL n

  if( ::newRec, datkomhd->( mh_append()), datkomhd->(dbRlock()))
  ::dm:save()

  datkomhd->ciddatkom := ::dm:get('datkomhd->ciddatkom')

  ::changeFRM := .F.
  if(Empty(datkomhd->cid), datkomhd->cid := Left(datkomhd->ciddatkom,4), NIL)
  datkomhd->nid := Val(SubStr(datkomhd->ciddatkom,5))
  mh_WRTzmena( 'datkomhd', ::newRec)
  datkomhd->(dbUnlock())

RETURN .T.

/*
METHOD SYS_komunikace_IN:copyDATKOM( parent, lDIST)
  local  filtr, newID
  local  typ, typInfo

  typ     := if( lDIST, 'DIST', 'USER')
  typInfo := if( lDIST, 'distribuèní', 'uživatelskou')

  if drgIsYESNO(drgNLS:msg('Vytvoøit '+ typInfo+' kopii formuláøe - ' +alltrim(forms ->cFormName)))
    newID := newIDforms(typ)
    drgDBMS:open('FORMS',,,,,'FORMSb')
    mh_COPYFLD( 'FORMSb', 'FORMS', .T.)
    FORMS->cIDforms := newID
    FORMSb->(ads_clearaof(), dbCloseArea())
    drgNLS:msg('Kopie formuláøe byla vytvoøena')
  endif

RETURN self
*/

METHOD SYS_komunikace_IN:SYS_datkommle_CRD()
  LOCAL oDialog

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SYS_datkom_modi_mle_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
RETURN self


METHOD SYS_komunikace_IN:comboBoxInit(drgComboBox)
  LOCAL  cNAME := drgParse(drgComboBox:name), aCombo := {}
  local  filename, filedesc
  local  x, obj, mod
  local  values, cval, n, val
  local  aval
  local  acombo_val := {}
  local  ok := .f.
  local  dm     := drgComboBox:drgDialog:dataManager

  do case
  case(cname = 'datkomhd->cmainFile' )
    task   := if( ::newRec, '', upper(dm:get('datkomhd->ctask')))
    values := drgDBMS:dbd:values

    for x := 1 to len(values) step 1
      obj  := values[x,2]
      if upper(obj:task) = task
        AAdd(acombo_val, {padR(obj:fileName,10), obj:fileName +'.' +obj:description } )
      endif
    next
    ok := if( Empty(acombo_val), .f., .t.)
  endcase


  if ok
    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgComboBox:value := drgComboBox:ovar:value
  endif
RETURN self


METHOD SYS_komunikace_IN:comboBoxPre(drgComboBox)
  local  cNAME := drgParse(drgComboBox:name), aCombo_val := {}
  local  filename, filedesc, task, cfiltr
  local  x, obj, mod, xval
  local  values, cval, n
  local  aval, cfile, ok := .f.
  local  rectm, recno
  local  dm     := drgComboBox:drgDialog:dataManager

*  values := drgDBMS:dbd:values

//  aval   := drgDBMS:dbd:values
//  values := drgDBMS:dbd
//  cfile  := ::drgDialog:dataManager:get('datkomhd->cmainfile')

  do case
  case(cname = 'datkomhd->cmainFile' )
    ok     := ::is_task_changed
    task   := upper(dm:get('datkomhd->ctask'))
    values := drgDBMS:dbd:values

    for x := 1 to len(values) step 1
      obj  := values[x,2]
      if upper(obj:task) = task
        AAdd(acombo_val, {padR(obj:fileName,10), obj:fileName +'.' +obj:description } )
      endif
    next
  endcase

  if ok
    ::is_task_changed := .f.

    drgComboBox:odrg:oXbp:clear()
//    drgComboBox:oXbp:clear()
    drgComboBox:odrg:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
    aeval(drgComboBox:odrg:values, { |a| drgComboBox:odrg:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgComboBox:odrg:value :=  drgComboBox:odrg:ovar:value
  endif

RETURN .t.


** END of CLASS ****************************************************************
METHOD SYS_komunikace_IN:destroy()
  ::drgUsrClass:destroy()

RETURN NIL


FUNCTION newIDdatcom(typ)
  local newID
  local filtr

  drgDBMS:open('datkomhd',,,,,'datkomhda')
  filtr := Format("cIDdatkom = '%%'", {typ})
  datkomhda->( AdsSetOrder(1), ads_setaof(filtr), DBGoBotTom())
  newID := typ + StrZero( Val( SubStr(datkomhda->cIDdatkom,5,6))+1, 6)
  datkomhda->(ads_clearaof(), dbCloseArea())

RETURN(newID)