//////////////////////////////////////////////////////////////////////
//
//  SYS_deokument_IN.PRG
//
//  Copyright:
//       MISS Software, s.r.o., (c) 2009. All rights reserved.
//
//  Contents:
//       Správa dokumentù dialog pro založení dokumentu.
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


**  Seznam dokumentù v systému
** CLASS for SYS_dokument_IN *********************************************
CLASS SYS_dokument_IN FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  getForm
*  METHOD  SYS_datkommle_CRD
  METHOD  postAppend, postValidate, onSave
*  METHOD  comboBoxInit, comboBoxPre
  method  destroy
* vnitøní metody
  method  selDokument

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
  var     fltExt

ENDCLASS


METHOD SYS_dokument_IN:init(parent)
  local  filename, filedesc
  local  x, obj, mod

  ::drgUsrClass:init(parent)
  drgDBMS:open('C_TASK')
  drgDBMS:open('ASYSTEM')
  drgDBMS:open('dokument')
  drgDBMS:open('dokument',,,,,'dokumentc')

  dokument->(DbSetRelation( 'C_TASK',  {|| dokument->cTASK },'dokument->cTASK','C_TASK01'))
  dokument->(dbSkip(0))

  * karta dokumentu volaná pro opravu z ... vodevšad 2 parametr je recNo()
  if len(pa_initParam := listAsArray(parent:initParam)) = 2
    parent:cargo := drgEVENT_EDIT
    dokument->(dbgoTo( val( pa_initParam[2] )))
  endif

  ::newRec := .not. (parent:cargo = drgEVENT_EDIT)

  ::changeFRM       := .F.
  ::iniCombo        := .t.
  ::is_task_changed := .f.
  ::fltExt          := {}

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

RETURN self


method SYS_dokument_IN:getForm()
  LOCAL drgFC, odrg
  local n
  local cVal  := ' , , , , , , , , , '
  local cvalb := ' , '
  local defOpr
  local rOnly := .f.

  drgFC := drgFormContainer():new()
  defOpr := defaultDisUsr('Dokument','CID')
  if .not. ::newRec
    rOnly  := if( At('DIST', defOpr)> 0, .f., dokument->cid = 'DIST')
  endif

  DRGFORM INTO drgFC SIZE 92,22 DTYPE '10' TITLE 'Modifikace seznamu dokumentù' ;
                       GUILOOK 'All:Y,Border:Y,Action:N';
                       PRE 'preValidate' POST 'postValidate'


   DRGTABPAGE INTO drgFC CAPTION 'Dokument' SIZE 91,21.2 OFFSET 1,82 FPOS 0.5,0.5 PRE 'tabSelect' TABHEIGHT 1.2

    DRGSTATIC INTO drgFC STYPE 14 SIZE 88.5,19.2 FPOS 1,0.4
    odrg:ctype := 2

    DRGTEXT INTO drgFC CAPTION 'Typ dokumentu      __________'  CPOS 2,.4 CLEN 23
     DRGCOMBOBOX dokument->cID  INTO drgFC FPOS 25,.4 FLEN 21 VALUES defOpr PP 2
     odrg:isedit_inrev := .f.

    DRGTEXT INTO drgFC CAPTION 'identifikace'  CPOS 49,.4 CLEN 10
    DRGTEXT dokument->cIDdokum INTO drgFC CPOS 60,.4 CLEN 20 PP 2 BGND 13 FONT 5

    DRGTEXT INTO drgFC CAPTION 'Úloha                   __________'  CPOS 2,1.7 CLEN 23
     DRGGET dokument->CTASK  INTO drgFC FPOS 25,1.7 FLEN 20 PP 2
     odrg:isedit_inrev := .f.
     DRGTEXT C_TASK->cNazUlohy INTO drgFC CPOS 49,1.7 CLEN 20

    DRGTEXT INTO drgFC CAPTION 'Zkratka dokumentu _________'  CPOS 2,3 CLEN 23
     DRGGET dokument->czkrdokum  INTO drgFC FPOS 25,3 FLEN 20 PP 2
     odrg:isedit_inrev := .f.

    DRGTEXT INTO drgFC CAPTION 'Název dokumentu __________'  CPOS 2,4.8 CLEN 23
     DRGGET dokument->cnazdokum  INTO drgFC FPOS 25,4.8 FLEN 54 PP 2

    DRGTEXT INTO drgFC CAPTION 'Typ prohlížeèe-editoru ______'  CPOS 2,6.9 CLEN 23
     DRGCOMBOBOX dokument->cTypEdit INTO drgFC FPOS 25,6.9 FLEN 54 REF 'TYPEDTDOK' PP 2
     odrg:isedit_inrev := .f.

    DRGTEXT INTO drgFC CAPTION 'Umístìní dokumentu   __________'  CPOS 2,8.2 CLEN 23
     DRGGET dokument->CSOUBOR  INTO drgFC FPOS 25,8.2 FLEN 54 PUSH 'selDokument' PP 2
     odrg:isedit_inrev := .f.

*    DRGTEXT INTO drgFC CAPTION 'Øídící soubor        __________'  CPOS 2,6.8 CLEN 23
*     DRGCOMBOBOX datkomhd->CMAINFILE  INTO drgFC FPOS 25,6.8 FLEN 51 VALUES cVal PP 2 PRE 'comboBoxPre'
*     odrg:isedit_inrev := .f.

//  DRGTEXT INTO drgFC CAPTION 'Zpùsob zpracování  ________'  CPOS 2,6.9 CLEN 23
//   DRGCOMBOBOX FORMS->NTYPZPR INTO drgFC FPOS 25,6.9 FLEN 25 ;
//                              VALUES '0:stantartní zpracování,' + ;
//                                     '1:zpracování TMP funkce,' + ;
//                                     '2:uživatelský dialog' PP 2

*    DRGTEXT INTO drgFC CAPTION 'Rozlišovací atribut _______'  CPOS 2,7.9 CLEN 23
*     DRGGET datkomhd->cattr1  INTO drgFC FPOS 25,7.9 FLEN 15 PP 2
*      odrg:ronly := rOnly

*    DRGTEXT INTO drgFC CAPTION 'Externí blok     __________'  CPOS 2,9 CLEN 23
*     DRGCOMBOBOX datkomhd->MBLOCKKOM INTO drgFC FPOS 25,9 FLEN 61 VALUES cvalb PP 2
*     odrg:isedit_inrev := .f.

*    DRGTEXT INTO drgFC CAPTION 'Datový model'  CPOS 2,11 CLEN 20 FONT 5
*     DRGMLE datkomhd->mDATA_KOM INTO drgFC FPOS 2,12.0 SIZE 42,6.8 PP 2

*    DRGTEXT INTO drgFC CAPTION 'Definice komunikace'  CPOS 45,11 CLEN 20 FONT 5
*     DRGMLE datkomhd->mDEFIN_KOM INTO drgFC FPOS 45,12.0 SIZE 42,6.8 PP 2

    DRGEnd INTO drgFC
   DRGEnd INTO drgFC

   DRGTABPAGE INTO drgFC CAPTION 'Metodika' SIZE 91,21.2 OFFSET 16,68 FPOS 0.5,0.5 PRE 'tabSelect' TABHEIGHT 1.2
     DRGMLE dokument->mMetodika INTO drgFC FPOS 0.8,0.2 SIZE 89.0,19.3 POST 'postLastField'// FCAPTION 'Distribuèní hodnota' CPOS 1,2
      odrg:ronly := rOnly
//       drgFC:members[16]:ronly := .t.
//     DRGEND INTO drgFC
   DRGEND INTO drgFC

  DRGEnd INTO drgFC

//  DRGPushButton INTO drgFC CAPTION 'Návrh-FRM'  EVENT 'SYS_datkommle_CRD' POS 44,20.5 SIZE 15,1 TIPTEXT 'Zmìna v návrhu formuláøe'
return drgFC


method SYS_dokument_IN:drgDialogStart(drgDialog)
  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager

  if ::newRec
    ::postAppend()
    ::dataManager:set("dokument->ctask", 'SYS')
  else
    ::dm:refresh()
  endif

return self


* ok
method SYS_dokument_IN:postAppend()
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




METHOD SYS_dokument_IN:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval

  do case
  case(name = 'dokument->cid')
    if changed
      cval := newIDdokum(value)
      ::dataManager:set("dokument->ciddokum", cval)
    endif

  case(name = 'dokument->ciddokum')
    if !Empty( value) .or.  changed
      if dokumentc->(dbSeek(Upper(value),,'Dokument03'))
        MsgBox( 'Pod tímto ID již dokument existuje ...',DRG_MSG_ERROR)
         lOK := .F.
      endif
    endif

  case(name = 'dokument->czkrdokum')
    if !Empty( value) .or.  changed
      if ::newRec
        if c_dokume->(dbSeek(Upper(value),,'c_dokume01'))
          ::fltExt := mh_Token(c_dokume->cPrpDokum)
          ::dataManager:set("dokument->cTypEDIT", c_dokume->cTypEDIT)
        endif

      endif
*      if dokumentc->(dbSeek(Upper(value),, 'DatKomH02'))
*        MsgBox( 'Tato zkratka je již použita. Zadejte jinou ...', 'CHYBA...' )
*        lOK := .F.
*      endif
    endif

//  case(name = 'datkomhd->ctypdatkom')
//    if Empty( value) .and. (::newRec .or. changed)
//      cval := newIDdatkom(value)
//      ::dataManager:set("datkomhd->ciddatkom", cval)
//    endif

  case(name = 'dokument->cnazdokum')
    if Empty( value)
      ::msg:writeMessage('Název dokumentu je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    endif

  case( name = 'dokument->ctask' )
    if Empty( value)
      ::msg:writeMessage('Zkratka úlohy je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    endif
    ::is_task_changed := (drgVar:value <> drgVar:prevValue)

*  case(name = 'datkomhd->cmainfile')
*    if !Empty( value) .and. (::newRec .or. changed)
*      cval := '[DefineField]' + Chr(13)+Chr(10)                              ;
*                +'  [Table:'+AllTrim(value)+']'+ Chr(13)+Chr(10)             ;
*                +'    [SortOrder]' + Chr(13)+Chr(10)                         ;
*                +'    [Relations]'+ Chr(13)+Chr(10)
*      ::dataManager:set("datkomhd->mdata_kom", cval)
*      ::drgDialog:dataManager:refresh('datkomhd->mdata_kom')
*    endif

*    if Lower(AllTrim(value)) == "vykazw"
*      drgDBMS:open('DEFVYKHD')
*      ::drgDialog:dataManager:set('datkomhd->mblockkom', AllTrim(defvykhd->cnazvykazu)+'.'+AllTrim(defvykhd->ctypvykazu))
*      ::drgDialog:dataManager:refresh('datkomhd->mblockkom')
*    endif

  endcase

  if( changed .and. .not. ::changeFRM, ::changeFRM := .T., NIL)
RETURN lOk


method SYS_dokument_IN:onSave()
  LOCAL aUsers
  LOCAL n

  if( ::newRec, dokument->( mh_append()), dokument->(dbRlock()))
  ::dm:save()

  dokument->ciddokum := ::dm:get('dokument->ciddokum')

  ::changeFRM := .F.
  if(Empty(dokument->cid), dokument->cid := Left(dokument->ciddokum,4), NIL)
  dokument->nid := Val(SubStr(dokument->ciddokum,5))
  mh_WRTzmena( 'dokument', ::newRec)
  dokument->(dbUnlock())

RETURN .T.


// výbìr dokumentu
method SYS_dokument_IN:selDokument()
  local  arrExt := {}
  local  file
  local  firstExt
  local  ext    := ''

  for n = 1 to Len(::fltExt)
    if( n = 1, firstExt := AllTrim(::fltExt[n]), nil)
    ext += '*.'+AllTrim(::fltExt[n])
    if( n < Len(::fltExt), ext += ';', nil)
  next
  AAdd( arrExt, {'Dokumenty typu ' +'('+ext+')',  ext})
  AAdd( arrExt, {'Vsechny dokumenty '+'(*.*)',  '*.*'})

  file := selFile(,firstExt,,,arrExt)
  ::dataManager:set("dokument->csoubor", file)

return .t.


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

*METHOD SYS_komunikace_IN:SYS_datkommle_CRD()
*  LOCAL oDialog
*
*  ::drgDialog:pushArea()
*  DRGDIALOG FORM 'SYS_datkom_modi_mle_CRD' PARENT ::drgDialog MODAL DESTROY
*  ::drgDialog:popArea()
*RETURN self

/*
METHOD SYS_dokument_IN:comboBoxInit(drgComboBox)
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
*/

** END of CLASS ****************************************************************
METHOD SYS_dokument_IN:destroy()
  ::drgUsrClass:destroy()

RETURN NIL


FUNCTION newIDdokum(typ)
  local newID
  local filtr

  drgDBMS:open('dokument',,,,,'dokumenta')
  filtr := Format("cIDdokum = '%%'", {typ})
  dokumenta->( AdsSetOrder(1), ads_setaof(filtr), DBGoBotTom())
  newID := typ + StrZero( Val( SubStr(dokumenta->cIDdokum,5,10))+1, 10)
  dokumenta->(ads_clearaof(), dbCloseArea())

RETURN(newID)


// výbìr souboru
*function selDokument()

*  selFile()

*return nil