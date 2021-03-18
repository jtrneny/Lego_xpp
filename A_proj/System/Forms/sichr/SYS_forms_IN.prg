#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "activex.Ch"

#include "..\Asystem++\Asystem++.ch"


*  Servis - Tiskové výstupy
** CLASS for SYS_forms_IN ******************************************************
CLASS SYS_forms_IN FROM drgUsrClass, sys_filtrs
EXPORTED:
  VAR     isdesc, isczech, checkDesc
  var     isReport                                  // pro vyk_vykazy

  METHOD  itemSelected
  METHOD  init, getForm, drgDialogStart, preValidate, postValidate
  METHOD  all_itemMarked, checkItemSelected

  METHOD  runDesign, runView, runPrint
  METHOD  copyFRMexp, copyFRMimp, replNEWit, copy_CRD
  METHOD  SYS_forms_modi_CRD, SYS_Formsmle_CRD

  method  deleteFRM

  * je vytvoøen návrh sestavy mforms_ll
  inline access assign method mforms_ll_is() var mforms_ll_is
    return if(empty(forms->mforms_ll), 0, MIS_ICON_OK)

  * filtritw
  inline access assign method ised_cvyraz_2() var ised_cvyraz_2
    return if(filtritw->lnoedt_2, MIS_NO_RUN, 0 )

  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected(.F.)
      Return .T.

    CASE nEvent = drgEVENT_DELETE
      ::deleteFRM()
      Return .T.

    CASE nEvent = drgEVENT_APPEND
      if( oXbp:ClassName() <> 'XbpCheckBox', ::SYS_forms_modi_CRD(.T.), NIL)
      Return .T.

    CASE nEvent = drgEVENT_APPEND2
      if( oXbp:ClassName() <> 'XbpCheckBox', ::copy_CRD(), NIL)
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
  VAR     msg, dm, dctrl, df, ab, pushOk, defOpr
  VAR     prevForm, prevBro, prevFile, selForm

  METHOD  verifyActions
ENDCLASS


METHOD SYS_forms_IN:init(parent)

  ::prevFile := ''
  ::isdesc   := .T.
  ::isczech  := .T.
  ::isreport := .T.
  ::defOpr   := defaultDisUsr('Forms','CTYPFORMS')

  ::drgUsrClass:init(parent)
  drgDBMS:open('FORMS')
  drgDBMS:open('FILTRS')
  drgDBMS:open('FILTRS',,,,, 'FILTRSs')

  * tady nevím jestli zap *
  drgDBMS:open('FILTRITw',.T.,.T.,drgINI:dir_USERfitm);ZAP
RETURN self


METHOD SYS_forms_IN:getForm()
  LOCAL oDrg, drgFC, _drgEBrowse

  drgFC := drgFormContainer():new()


  DRGFORM INTO drgFC SIZE 110,26 DTYPE '10' TITLE 'Sestavy - tvorba a oprava' ;
                                 GUILOOK 'All:Y,Border:Y,Action:Y';
                                 PRE 'preValidate' POST 'postValidate'

* Browser definition
  DRGDBROWSE INTO drgFC FPOS 0.5,1.05 SIZE 73,17 FILE 'FORMS'                 ;
    FIELDS 'M->mforms_ll_is::2.7::2,'                                       + ;
           'CFORMNAME:Tiskový výstup,'                                      + ;
           'CIDFORMS:ID formuláøe,'                                         + ;
           'CIDFILTERS:ID filtru,'                                          + ;
           'NTYPPROJ_L:Typ výstupu,'                                        + ;
           'LISFORM:Formuláø,'                                              + ;
           'CTASK:Úloha systému,'                                           + ;
           'CUSER:Zkratka uživatele,'                                       + ;
           'NVER_MAJOR:Verze major,'                                        + ;
           'NVER_MINOR:Verze minor,'                                        + ;
           'CMAINFILE:Øídící soubor'                                          ;
            ITEMMARKED 'all_itemMarked' ITEMSELECTED 'itemSelected'           ;
            SCROLL 'ny' CURSORMODE 3 PP 7  POPUPMENU 'yy' RESIZE 'ny'

 * Browser _fltusers
  DRGDBROWSE INTO drgFC FPOS 73.2,1.05 SIZE 36.4,17 FILE 'FILTRSs'   ;
               FIELDS 'CFLTNAME:Název filtru:35'                    ;
               ITEMMARKED 'all_itemMarked' SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'yy'


* Browser _filtritw
  DRGEBROWSE INTO drgFC FPOS 0.5,18.2 SIZE 109.1,7.6 FILE 'FILTRITw' ;
             GUILOOK 'ins:n,del:n,sizecols:n,headmove:n' RESIZE 'yn' ;
             SCROLL 'ny' CURSORMODE 3 PP 7
    _drgEBrowse := oDrg

    DRGTEXT INTO drgFC NAME filtritW->clgate_1  CPOS  1,0 CLEN  2 CAPTION  '('
    DRGTEXT INTO drgFC NAME filtritW->clgate_2  CPOS  2,0 CLEN  2 CAPTION  '('
    DRGTEXT INTO drgFC NAME filtritW->clgate_3  CPOS  3,0 CLEN  2 CAPTION  '('
    DRGTEXT INTO drgFC NAME filtritW->clgate_4  CPOS  4,0 CLEN  2 CAPTION  '('

    DRGTEXT INTO drgFC NAME filtritW->cfile_1   CLEN  9   CAPTION  'table'

    DRGTEXT INTO drgFC NAME filtritW->cvyraz_1u CPOS  5,0 CLEN 28 CAPTION  'výraz-L'
    DRGTEXT INTO drgFC NAME filtritW->crelace   CPOS  6,0 CLEN  6 CAPTION  'oper'
    DRGGET  filtritW->cvyraz_2u INTO drgFC      FPOS  7,0 CLEN 27 FCAPTION 'výraz_P'

    DRGTEXT INTO drgFC NAME M->ised_cvyraz_2    CLEN  2  CAPTION ''
    oDrg:isbit_map := .t.

    DRGTEXT INTO drgFC NAME filtritW->cfile_2   CLEN  9   CAPTION  'table'

    DRGTEXT INTO drgFC NAME filtritW->crgate_1  CPOS  8,0 CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->crgate_2  CPOS  9,0 CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->crgate_3  CPOS 10,0 CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->crgate_4  CPOS 11,0 CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->coperand  CPOS 12,0 CLEN  7 CAPTION  'operand'

    _drgEBrowse:createColumn(drgFC)
  DRGEND INTO drgFC

  DRGCHECKBOX M->isdesc INTO drgFC FPOS 2,0 FLEN 20 ;
                        VALUES 'T:doplnit popisky v návrhu,F:bez popisek v návrhu' PP 1

  DRGCHECKBOX M->isczech INTO drgFC FPOS 95,0 FLEN 20 ;
                        VALUES 'T:èeský návrháø,F:anglický návrháø' PP 1


  DRGAction INTO drgFC CAPTION 'Návrh'    EVENT 'runDesign'        TIPTEXT 'Návrh tiskového výstupu'// ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION 'Data'     EVENT 'SYS_formsmle_CRD' TIPTEXT 'Návrh datového modelu'// ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION      ''    EVENT ''                 ATYPE 5
  DRGAction INTO drgFC CAPTION 'Náhled'   EVENT 'runView'          TIPTEXT 'Prohlížení a tisk'
  DRGAction INTO drgFC CAPTION 'Tisk'     EVENT 'runPrint'         TIPTEXT 'Pøímý tisk na tiskárnu'
  DRGAction INTO drgFC CAPTION      ''    EVENT ''                 ATYPE 5
  DRGAction INTO drgFC CAPTION 'Export'   EVENT 'copyFRMexp'       TIPTEXT 'Export sestav'
  DRGAction INTO drgFC CAPTION 'Import'   EVENT 'copyFRMimp'       TIPTEXT 'Import sestav'
  DRGAction INTO drgFC CAPTION 'UpravVyk' EVENT 'replNEWit'        TIPTEXT 'Úprava volání definic výkazù'
RETURN drgFC


method SYS_forms_IN:CheckItemSelected(drgCheck)
  ::checkDesc := drgCheck

  do case
  case Lower(drgCheck:name) == 'm->isdesc'
    ::isdesc    := drgCheck:value
  case Lower(drgCheck:name) == 'm->isczech'
    ::isczech   := drgCheck:value
  endcase
return


METHOD SYS_forms_IN:itemSelected(new)
  local  mod
  *
  if ::selForm
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  else
    if(.not. empty(forms->cidForms), ::SYS_forms_modi_CRD(.F.), nil)
  endif
RETURN SELF

*
** itemMarked for all **
METHOD SYS_forms_IN:all_itemMarked(arowCol,xnil,oxbp)
  local file
  local filtr := Format("Lower(cMainFile) = '%%'", {Lower(FORMS->cMainFile)})

  if( .not. IsNil(::dctrl:oaBrowse), file := Lower(::dctrl:oaBrowse:cFile), NIL)
  if( isobject(::checkDesc), ::checkDesc:oXbp:setColorBG(XBPSYSCLR_3DFACE), NIL)

  do case
  case file = 'forms'
    FILTRSs->(ads_setaof(filtr), DBGoTop())

    ::verifyActions()
//    ::dctrl:oBrowse[2]:refresh(.T.)  // ?
//    ::dctrl:oBrowse[3]:refresh(.T.)  // ?
  case file = 'filtrss'
    ::verifyActions()
//    ::dctrl:oBrowse[3]:refresh(.T.)  // ?
  endcase
RETURN .t.

*
** povolí/zakáže akce pro vlastní tisk/view **
METHOD SYS_forms_IN:verifyActions(inPostValidate)
  local  ab, ok, ev, ok_navrhData
  local  x

  default inPostValidate to .F.

  ab := ::drgDialog:oActionBar:members
  ok := .not. forms ->(Eof())

  if .not. inPostValidate
    ok := .not. empty(forms->mforms_ll)

    ::sys_filtrs:itemMarked()

    ok      := ok .and. .not. filtritw->(eof())
    AEval(::aitw, {|s| if( Empty(s), ok := .F., NIL )})
  else
    AEval(::aitw, {|s| if( Empty(s), ok := .F., NIL )})
  endif

  for x := 1 to len(ab) step 1
    do case
    case IsCharacter(ab[x]:event) .and. Lower(ab[x]:event) $ 'runview,runprint'
      ev := Lower(ab[x]:event)

      ab[x]:disabled := .not. ok

      if(ok, ab[x]:oxbp:enable(), ab[x]:oxbp:disable())

    case IsCharacter(ab[x]:event) .and. Lower(ab[x]:event) $ 'rundesign,sys_formsmle_crd'
      ev := Lower(ab[x]:event)

      ok_navrhData := if( At('DIST', ::defOpr) > 0, .t., (forms->ctypforms = 'USER') )

      ab[x]:disabled := .not. ok_navrhData

      if(ok_navrhData, ab[x]:oxbp:enable(), ab[x]:oxbp:disable())
    endcase
  next
RETURN


METHOD SYS_forms_IN:drgDialogStart(drgDialog)
  LOCAL  members, x, filtr

  ::sys_filtrs:init(drgDialog)
  *
  *
  ::prevForm := drgDialog:parent
  members    := ::prevForm:oForm:aMembers
  BEGIN SEQUENCE
    for x := 1 TO len(members)
      ::selForm := .F.
      if members[x]:ClassName() = 'drgBrowse' .or. members[x]:ClassName() = 'drgEBrowse'
        ::prevBro  := members[x]
        ::prevFile := ::prevBro:cFile
        ::selForm  := .T.
  BREAK
      endif
    next
  END SEQUENCE
  *
  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dctrl    := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  ::ab       := drgDialog:oActionBar:members      // actionBar
  ::prevForm := drgDialog:parent
  *
  *
  members  := drgDialog:oForm:aMembers
  BEGIN SEQUENCE
    for x := 1 TO len(members)
      if members[x]:ClassName() = 'drgBrowse'
        drgDialog:oForm:nextFocus := x
  BREAK
      endif
    next
  END SEQUENCE
  ::verifyActions()
RETURN self


METHOD SYS_forms_IN:preValidate(drgVar)
  local  lOk := .T., odesc

  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    lOk   := (at('->',filtritw ->cvyraz_2) = 0)
    lOk   := if( lOk, .not. filtritw->lnoedt_2, lOk)

    odesc := drgDBMS:getFieldDesc(strtran(filtritw->cvyraz_1,' ',''))

    if lOK .and. IsObject(odesc)
      do case
      case odesc:type = 'D'
        drgVar:odrg:oxbp:picture := '@D'
      otherwise
        drgVar:oDrg:oXbp:picture := odesc:picture
      endcase
    endif
  endif
RETURN lOk


METHOD SYS_forms_IN:postValidate(drgVar)
  local  value := drgVar:get(), lOk := .T.

  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    if drgVar:changed()
      filtritw ->cvyraz_2         := value
      ::aitw[filtritw->(RecNo())] := value   // JT !!!!!
    endif

    ::verifyActions(.T.)
  endif
RETURN lOk


method SYS_forms_IN:deleteFRM
  local ok := .f.

   ok := if( At('DIST', ::defOpr) > 0, .t., (forms->ctypforms = 'USER') )

   if ok
     if forms->( dbRlock())
       if drgIsYESNO(drgNLS:msg('Opravdu požadujete zrušit vybranou sestavu ?'))
         forms->( dbDelete())
         ::dctrl:oBrowse[1]:refresh(.T.)
         ::verifyActions()
         ::dctrl:oBrowse[2]:refresh(.T.)
         ::dctrl:oBrowse[3]:refresh(.T.)
       endif
       forms->( dbUnlock())
     endif
   else
     drgNLS:msg('Nemáte oprávnìní rušit sestavy !!!')
   endif

return


METHOD SYS_forms_IN:SYS_forms_modi_CRD(new)
  LOCAL oDialog, mod

  mod := if(new, "APP","EDI")
  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SYS_forms_modi_CRD,'+ mod PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()

  ::dctrl:oBrowse[1]:refresh(.T.)
  ::verifyActions()
  ::dctrl:oBrowse[2]:refresh(.T.)
  ::dctrl:oBrowse[3]:refresh(.T.)
RETURN self


method SYS_forms_IN:SYS_formsmle_CRD()
  LOCAL oDialog

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SYS_forms_datamle_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
RETURN self



*
** návrh a modifikace vzoru ***************************************
method SYS_forms_IN:runDesign()
   LL_DefineDesign(self,::isdesc,::isczech)
return


*
** tisk pøes view ***************************************
METHOD SYS_forms_IN:runView()
  local cond, file
  *
  local oini := flt_setcond():new(.f.,.f.)

  if .not. Empty(oini:ft_cond)
    file := alltrim(forms ->cmainfile)
    if .not. empty(forms->mblockfrm)

      if substr(upper(file), len(file), 1) = 'W'
         drgDBMS:open(file,.T.,.T.,drgINI:dir_USERfitm); ZAP
      else
        drgDBMS:open(file)
      endif
    else
      drgDBMS:open(file)
    endif

    (file)->(ads_setaof(oini:ft_cond),DbGoTop())

    if (.not. empty(filtrss->mdata) .and. .not. empty(oini:ex_cond))
      oini:relfiltrs(file,oini:ex_cond)
    endif
  endif

  LL_PrintDesign(.f.)
  if( !Empty(oini:ft_cond), (file)->(ads_clearaof()), NIL)
RETURN self


*
** pøímý tisk na tiskárnì ***************************************
METHOD SYS_forms_IN:runPrint(parent)
  local cond, file
  *
  local oini := flt_setcond():new(.f.,.f.)

  if .not. Empty(oini:ft_cond)
    file := alltrim(forms ->cmainfile)

    if .not. empty(forms->mblockfrm)
      if substr(upper(file), len(file), 1) = 'W'
         drgDBMS:open(file,.T.,.T.,drgINI:dir_USERfitm); ZAP
      else
        drgDBMS:open(file)
      endif
    else
      drgDBMS:open(file)
    endif

    (file)->(ads_setaof(oini:ft_cond),DbGoTop())

    if (.not. empty(filtrss->mdata) .and. .not. empty(oini:ex_cond))
      oini:relfiltrs(file,oini:ex_cond)
    endif
  endif

  LL_PrintDesign(.f.) //::isdesc)

  if( !Empty(cond), (file)->(ads_clearaof()), NIL)
RETURN self


METHOD SYS_forms_IN:copyFRMexp()
  local  recNo, file
  local  lok := .T.
  local  i,n,m_filtr := ""
  local  arselect := ::dctrl:oBrowse[1]:arselect
  *
  local  aStruc := FORMS->(dbStruct())

  file := selFILE('FormsN','Adt')

  if .not. Empty(file)
    if .not. empty(arselect)
      aeval(arselect, {|i,n| m_filtr += 'recno() = ' +str(i) + if(n < len(arselect), ' .or. ', '') })
    else
      m_filtr := "recno() = " +str(Forms->(recno()))
    endif
    if File(file)
      lOk := !drgIsYESNO(drgNLS:msg('Výstupní soubor již existuje. Chcete ho pøepsat ?'))
    endif
    if lOk
      dbCreate( file, aStruc, oSession_free)
      dbUseArea(.T.,oSession_free,file,'FILEEXP',.F.)

      recNo := Forms->(Recno())
      Forms->(ads_setaof(m_filtr),dbgotop())

      do while .not. Forms->(eof())
        mh_COPYFLD( 'FORMS', 'FILEEXP', .T.,,,.F.)
        Forms->(dbskip())
      enddo

      FILEEXP->(dbCloseArea())
      FORMS->(ads_clearaof(), dbGoTo(recNo))
      drgNLS:msg('Export sestav byl proveden...')
    endif
  endif

RETURN self


METHOD SYS_forms_IN:copyFRMimp()
  local  recNo, file
  local  newRec

  file := selFILE('FormsN','Dbf')

  if .not. Empty(file)
    dbUseArea(.T.,oSession_free,file,'FILEIMP',.F.)
    recNo := Forms->(Recno())
    FILEIMP->(dbGoTop())

    do while .not. FILEIMP->(eof())
      if Forms->(dbSeek(Upper(FILEIMP->cIdForms),, AdsCtag(1) ))
        if drgIsYESNO(drgNLS:msg('Sestava '+ AllTrim(Forms->cFormName)+' existuje! Pøepsat sestavu ? '))
          Forms->(dbRLock())
          mh_COPYFLD( 'FILEIMP','FORMS', .F.)
          Forms->(dbUnlock())
        endif
      else
        mh_COPYFLD( 'FILEIMP','FORMS', .T.)
      endif
      FILEIMP->(dbskip())
    enddo

    FILEIMP->(dbCloseArea())
    FORMS->( dbGoTo(recNo))
    drgNLS:msg('Import sestav byl proveden...')

  endif

RETURN self

METHOD SYS_forms_IN:replNEWit()
  local  recNo, file
  local  newRec
  local  key, cseek
  local  cc := ''
  local  nMaxLines
  local  aLines := {}
  local  n


  drgDBMS:open('DEFVYKHD')

  cseek := "')"
  forms->(dbGoTop())
  do while .not. forms->(eof())

    if .not. empty(forms ->mForms_LL) .and. forms ->cidforms <> 'USER001202'
      forms->(dbRlock())
      cc := ''
      nMaxLines := MlCount( forms ->mForms_LL, 80 )
      FOR n:=1 TO nMaxLines
        cc += Str2Unicode( Trim( MemoLine( forms ->mForms_LL, 80, n ) ))
        AAdd( aLines, Str2Unicode(Trim( MemoLine( forms ->mForms_LL, 80, n ) )))
      NEXT

//      cc := Str2Unicode( forms ->mForms_LL)
//      forms ->mForms_LL := Str2Unicode( MemoEdit(forms ->mForms_LL))
//      forms->(dbUnLock())
    endif
/*
    if 'vyk_naplnvyk_in' $ forms->mBlockFrm
      key := Substr(AllTrim(forms ->mBlockFrm),18)
      key := StrTran( key,cseek,'')
      if Left(key,4)<>'DIST' .and. Left(key,4)<>'USER'
        if defvykhd->(dbSeek(Upper(key),,'DEFVYKHD01'))
          forms->(dbRlock())
          forms ->mBlockFrm := 'vyk_naplnvyk_in'+Chr(40)+ Chr(39)+defvykhd->cidvykazu+Chr(39)+Chr(41)
          forms->(dbUnLock())
        endif
      endif
    endif
*/

    forms->(dbskip())
  enddo
  forms->( dbGoTop())
  drgNLS:msg('Doplnìní bylo provedeno...')

RETURN self


METHOD SYS_forms_IN:copy_CRD()
  LOCAL oDialog

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SYS_forms_copy_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()

  ::dctrl:oBrowse[1]:refresh(.T.)
  ::all_itemMarked()
RETURN self


*   Modifikace tiskového formuláøe
** CLASS for SYS_forms_modi_CRD ************************************************
CLASS SYS_forms_modi_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  getForm
  METHOD  copyFrm, copyDIST, copyUSER
  METHOD  SYS_formsmle_CRD
  METHOD  postAppend, postValidate, onSave
  METHOD  comboBoxInit, comboBoxPre

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc   := ::drgDialog:dialogCtrl
    LOCAL save := .T.

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::onSave()
      ::changeFRM := .f.
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
      RETURN .t.

    CASE nEvent = xbeP_Close
      if ::changeFRM .and. .not. isWorkVersion
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
  VAR     arr, newRec, bloc
  VAR     dm, msg
  VAR     changeFRM
  var     is_task_changed
  *
  var     odrgCombo_MBLOCKFRM, odrgCombo_MBLOC_USER
ENDCLASS


METHOD SYS_forms_modi_CRD:init(parent)
  local  filename, filedesc
  local  x, obj, mod, values
  local  defOpr
  local  rOnly

  ::drgUsrClass:init(parent)
  drgDBMS:open('C_TASK')
  drgDBMS:open('ASYSTEM')
  drgDBMS:open('DEFVYKHD')
  drgDBMS:open('FORMS')
  drgDBMS:open('FORMS',,,,,'FORMSc')

  FORMS->(DbSetRelation( 'C_TASK',  {|| FORMS->cTASK },'FORMS->cTASK','C_TASK01'))
  FORMS->(dbSkip(0))

  mod    := drgParseSecond(::drgDialog:initParam)
  values := drgDBMS:dbd:values

  ::newRec          := if( mod == 'APP', .T., .F.)
  ::arr             := {}
  ::bloc            := {}
  ::changeFRM       := .F.
  ::is_task_changed := .f.

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


method SYS_forms_modi_CRD:getForm()
  LOCAL drgFC, odrg
  local n
  local cVal  := ' , , , , , , , , , '
  local cvalb := ' , , , , , , , , , '
  local defOpr
  local rOnly := .f.

  defOpr := defaultDisUsr('Forms','CTYPFORMS')
  if .not. ::newRec
    rOnly  := if( At('DIST', defOpr)> 0, .f., forms->ctypforms = 'DIST')
    defOpr := 'DIST:distribuèní,USER:uživatelský'
  endif

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 92,22 DTYPE '10' TITLE 'Modifikace sestavy' ;
                       GUILOOK 'All:Y,Border:Y,Action:N';
                       PRE 'preValidate' POST 'postValidate'


   DRGTABPAGE INTO drgFC CAPTION 'Sestava' SIZE 91,21.2 OFFSET 1,82 FPOS 0.5,0.5 PRE 'tabSelect' TABHEIGHT 1.2 SUBTABS 'A2,A3'

    DRGSTATIC INTO drgFC STYPE 14 SIZE 88.8,19.2 FPOS 1,0.4
    odrg:ctype := 2

     DRGTEXT INTO drgFC CAPTION 'Typ formuláøe      __________'  CPOS 2,.4 CLEN 23
     DRGCOMBOBOX FORMS->CTYPFORMS  INTO drgFC FPOS 25,.4 FLEN 21 VALUES defOpr PP 2
      odrg:isedit_inrev := .f.

     DRGTEXT INTO drgFC CAPTION 'identifikace'  CPOS 55,.4 CLEN 10
     DRGTEXT FORMS->CIDFORMS   INTO drgFC CPOS 66,.4 CLEN 20 PP 2 BGND 13 FONT 5

     DRGTEXT INTO drgFC CAPTION 'Název formuláøe  __________'  CPOS 2,2 CLEN 23
      DRGGET FORMS->CFORMNAME  INTO drgFC FPOS 25,2 FLEN 60 PP 2

     DRGTEXT INTO drgFC CAPTION 'Typ projektu        __________'  CPOS 2,3.6 CLEN 23
      DRGCOMBOBOX FORMS->NTYPPROJ_L INTO drgFC FPOS 25,3.6 FLEN 10 VALUES '2:Seznam,1:Štítek,3:Karta' PP 2
       odrg:isedit_inrev := .f.

     DRGTEXT INTO drgFC CAPTION 'Úloha                   __________'  CPOS 2,4.7 CLEN 23
      DRGGET FORMS->CTASK  INTO drgFC FPOS 25,4.7 FLEN 9 PP 2
      odrg:isedit_inrev := .f.
      DRGTEXT C_TASK->cNazUlohy INTO drgFC CPOS 37,4.7 CLEN 20

     DRGTEXT INTO drgFC CAPTION 'Øídící soubor        __________'  CPOS 2,5.8 CLEN 23
      DRGCOMBOBOX forms->cmainfile INTO drgFC FPOS 25,5.8 FLEN 61 VALUES cVal PP 2 PRE 'comboBoxPre'
       odrg:isedit_inrev := .f.

     DRGTEXT INTO drgFC CAPTION 'Zpùsob zpracování  ________'  CPOS 2,6.9 CLEN 23
      DRGCOMBOBOX forms->ntypzpr INTO drgFC FPOS 25,6.9 FLEN 61 ;
                              VALUES '0: 0 - stantartní zpracování       ,'       + ;
                                     '1: 1 - zpracování TMP funkce       ,'       + ;
                                     '2: 2 - uživatelský dialog          ,'       + ;
                                     '3: 3 - zpracování TMP funkce ne ZAP,'       + ;
                                     '4: 4 - TMP funkce gener.výkazù,'            + ;
                                     '5: 5 - TMP funkce mzdList bez období,'      + ;
                                     '6: 6 - TMP funkce mzdList s obdobím,'       + ;
                                     '7: 7 - TMP funkce gener.výkazù s obdobím'   + ;
                                     '8: 8 - TMP funkce mzdList s rokem,'         + ;
                                     '9: 9 - TMP funkce gener.výkazù s rokem,'    + ;
                                    '10:10 - soubìžné zpracování TMP funkce'  PP 2
       odrg:isedit_inrev := .f.

     DRGTEXT INTO drgFC CAPTION 'Externí blok       ___DIST____'  CPOS 2,8 CLEN 23
      DRGCOMBOBOX FORMS->MBLOCKFRM INTO drgFC FPOS 25,8 FLEN 61 VALUES cvalb PP 2  PRE 'comboBoxPre'
       odrg:isedit_inrev := .f.

     DRGTEXT INTO drgFC CAPTION 'Externí blok       ___USER____'  CPOS 2,9 CLEN 23
      DRGCOMBOBOX FORMS->MBLOC_USER INTO drgFC FPOS 25,9 FLEN 61 VALUES cvalb PP 2  PRE 'comboBoxPre'

     DRGTEXT INTO drgFC CAPTION 'Datový model'  CPOS 2,10 CLEN 20 FONT 5
      DRGMLE FORMS->mDATA_LL INTO drgFC FPOS 2,11.4 SIZE 84,7.4 PP 2
      odrg:ronly := rOnly

     DRGEnd INTO drgFC
   DRGEnd INTO drgFC


   DRGTABPAGE INTO drgFC CAPTION 'Metodika' SIZE 91,21.2 OFFSET 16,68 FPOS 0.5,0.5 PRE 'tabSelect' TABHEIGHT 1.2
     DRGMLE forms->mMetodika INTO drgFC FPOS 0.8,0.2 SIZE 89.0,19.3 POST 'postLastField'// FCAPTION 'Distribuèní hodnota' CPOS 1,2
     odrg:ronly := rOnly

     DRGEND INTO drgFC
   DRGEND INTO drgFC

  DRGEnd INTO drgFC

return drgFC


method SYS_forms_modi_CRD:drgDialogStart(drgDialog)
  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager


  ::odrgCombo_MBLOCKFRM  := ::dm:has( 'FORMS->MBLOCKFRM' )
  ::odrgCombo_MBLOC_USER := ::dm:has( 'FORMS->MBLOC_USER')

  if( ::newRec, ::postAppend(), ::dm:refresh())
return self


* ok
method SYS_forms_modi_CRD:postAppend()
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


METHOD SYS_forms_modi_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval

  do case
  case(name = 'forms->ctypforms')
    if !Empty( value) .and. (::newRec .or. changed)
      cval := newIDforms(value)
      ::dataManager:set("forms->cidforms", cval)
    endif

  case(name = 'forms->cidforms')
    if !Empty( value) .or.  changed
      if FORMSc->(dbSeek(Upper(value),, AdsCtag(1) ))
        ::msg:writeMessage('Pod tímto ID již sestava existuje ...',DRG_MSG_ERROR)
         lOK := .F.
      endif
    endif

  case(name = 'forms->cformname')
    if Empty( value)
      ::msg:writeMessage('Název sestavy je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    endif

  case( name = 'forms->ctask' )
    if Empty( value)
      ::msg:writeMessage('Zkratka úlohy je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    endif

    ::is_task_changed := (drgVar:value <> drgVar:prevValue)

  case(name = 'forms->cmainfile')
    if !Empty( value) .and. (::newRec .or. changed)
      cval := '[DefineField]' + Chr(13)+Chr(10)                              ;
                +'  [Table:'+AllTrim(value)+']'+ Chr(13)+Chr(10)             ;
                +'    [SortOrder]' + Chr(13)+Chr(10)                         ;
                +'    [Relations]'+ Chr(13)+Chr(10)
      ::drgDialog:dataManager:set("forms->mdata_ll", cval)
      ::drgDialog:dataManager:refresh('forms->mdata_ll')
    endif

    if Lower(AllTrim(value)) == "vykazw"
      drgDBMS:open('DEFVYKHD')
      ::comboBoxPre( ::odrgCombo_MBLOCKFRM )

*      ::odrgCombo_MBLOC_USER:odrg:oxbp:enable()
*    else
*      ::odrgCombo_MBLOC_USER:odrg:oxbp:disable()
    endif

  endcase

  if( changed .and. .not. ::changeFRM, ::changeFRM := .T., NIL)
RETURN lOk


method SYS_forms_modi_CRD:onSave()
  LOCAL aUsers
  LOCAL n

  if( ::newRec, forms->( mh_append()), forms->(dbRlock()))
  ::dm:save()
  forms->cidForms := ::dm:get('forms->cidForms')

*  if ::newRec .and. Lower( AllTrim( forms->cmainfile)) == "vykazw"
*    if defvykhd->( dbSeek( Padr( AllTrim(::dm:get('forms->mblockfrm')),15),, AdsCtag(3) ))
*      forms->mblockfrm := "vyk_naplnvyk_in('" +AllTrim(defvykhd->cidvykazu) + "')"
*    endif
*  endif

  ::changeFRM := .F.
  if(Empty(forms->cTypForms), forms->cTypForms := Left(forms->cIdForms,4), NIL)
  forms->nCisForms := Val(SubStr(forms->cIdForms,5))
  mh_WRTzmena( 'forms', ::newRec)
  forms->(dbUnlock())

RETURN .T.



METHOD SYS_forms_modi_CRD:copyDIST()
  ::copyFRM(,.T.)
RETURN NIL


METHOD SYS_forms_modi_CRD:copyUSER()
  ::copyFRM(,.F.)
RETURN NIL



METHOD SYS_forms_modi_CRD:copyFRM( parent, lDIST)
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


METHOD SYS_forms_modi_CRD:SYS_formsmle_CRD()
  LOCAL oDialog

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SYS_forms_modi_mle_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
RETURN self


METHOD SYS_forms_modi_CRD:comboBoxInit(drgComboBox)
  LOCAL  cNAME := Lower(drgParse(drgComboBox:name)), aCombo := {}
  local  filename, filedesc
  local  x, obj, mod
  local  typprg := '', typzpr, typ_Vyk
  local  values, cval, n, val, task, cfiltr
  local  acombo_val := {}
  local  aval
  local  ok := .f.
   *
  local  idVykazu, rozAtrVyk, cblock

  typzpr  := ::drgDialog:dataManager:get('forms->ntypzpr')
  typ_Vyk := if( typzpr = 5 .or. typzpr = 6, '2', '' )

  do case
  case(cname = 'forms->cmainfile' )
    task   := if( ::newRec, '', upper(::drgDialog:dataManager:get('forms->ctask')))
    values := drgDBMS:dbd:values

    for x := 1 to len(values) step 1
      obj  := values[x,2]
      if upper(obj:task) = task
        AAdd(acombo_val, {padR(obj:fileName,10), obj:fileName +'.' +obj:description } )
      endif
    next
    ok := if( Empty(acombo_val), .f., .t.)

  case ( cName = 'forms->mblockfrm')

    if .not. Empty(FORMS->MBLOCKFRM) .and. .not. ::newRec
      if Lower(AllTrim(FORMS->cmainfile)) == "vykazw" .or.          ;
           At( 'Table:VYKAZW',FORMS->mData_LL) <> 0

        val := mh_token( FORMS->MBLOCKFRM, "'")
        if defvykhd->( dbSeek( Upper(val[2]),,'DEFVYKHD03'))

          cblock   := "vyk_naplnvyk" +typ_Vyk +"_in('" +allTrim(defvykhd->cidvykazu) + "')"
          aadd( aCombo_val, { cblock,      padr( allTrim( defVykhd->cidVykazu ), 11 ) + ;
                                      '_' +padr( allTrim( defvykhd->cnazvykazu), 40 ) + ;
                                      '_' +padr( alltrim( defVykhd->ctypVykazu), 15 )     })
        endif

      else
        do case
        case typzpr = 1                                  ;   typprg := 'FCE_TMLSTV'
        case typzpr = 2                                  ;   typprg := 'OBJ_TMLSTV'
        case typzpr = 3                                  ;   typprg := 'FCE_TMLSTV'
        case typzpr = 4 .or. typzpr = 5 .or. typzpr = 6  ;   typprg := 'FCE_TMLSTV'
        endcase

        if .not. Empty(typprg)
          cFiltr := Format("Upper(ctypobject) == '%%'", {typprg})
          asystem->(ads_setaof( cFiltr),dbgotop())
           val := AllTrim( FORMS->MBLOCKFRM)
           if asystem->( dbSeek( Upper(val),,'ASYSTEM07'))
             AAdd( aCombo_val, {asystem->cprgobject, AllTrim(asystem->cnameobj)+'_'+AllTrim(asystem->cprgobject)+'_'+AllTrim(asystem->cidobject)})
           endif
          asystem->(ads_clearaof())
        endif
      endif
    endif

    ok := if( Empty(acombo_val), .f., .t.)

  case ( cName = 'forms->mbloc_user')

    acombo_val := { { '          ', space(50) } }

    if .not. empty(FORMS->MBLOCKFRM) .and. .not. ::newRec
      if lower(allTrim( FORMS->cmainfile)) == "vykazw"   .or.          ;
           At( 'Table:VYKAZW',FORMS->mData_LL) <> 0

        val := mh_token( FORMS->MBLOCKFRM, "'")
        if defvykhd->( dbSeek( Upper(val[2]),,'DEFVYKHD03'))
          task      := upper(defVykhd->ctask)
          idVykazu  :=       defVykhd->cidVykazu
          rozAtrVyk := upper(defVykhd->crozAtrVyk)

          defvykhd->( dbGoTop())

          do while .not.defvykhd->( Eof())
            if ( task = upper(defVykhd->ctask) .and. rozAtrVyk = upper(defVykhd->crozAtrVyk))
              if idVykazu <> defVykhd->cidVykazu

                cblock := "vyk_naplnvyk" +typ_Vyk +"_in('" +allTrim(defvykhd->cidvykazu) + "')"
                aadd( aCombo_val, { cblock,      padr( allTrim( defVykhd->cidVykazu ), 11 ) + ;
                                            '_' +padr( allTrim( defvykhd->cnazvykazu), 40 ) + ;
                                            '_' +padr( alltrim( defVykhd->ctypVykazu), 15 )     })
              endif
            endif
            defvykhd->( dbSkip())
          enddo
        endif
      endif
    endif
    ok := ( len(aCombo_val) > 0 )

  endcase

  if ok
    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgComboBox:value := 'test'
//    drgComboBox:value := drgComboBox:ovar:value
  endif

RETURN self


METHOD SYS_forms_modi_CRD:comboBoxPre(drgComboBox)
  local  cNAME := Lower(drgParse(drgComboBox:name)), aCombo_val := {}
  local  filename, filedesc, task, cfiltr
  local  x, obj, mod
  local  values, cval, n, val
  local  aval, cfile
  local  typprg := '', typzpr, typ_Vyk
  local  rectm, recno
  local  ok := .f.
  *
  local  idVykazu, rozAtrVyk, cblock

  typzpr := ::drgDialog:dataManager:get("forms->ntypzpr")
  typ_Vyk := if( typzpr = 5 .or. typzpr = 6, '2', '' )

  aval   := drgDBMS:dbd:values
  values := drgDBMS:dbd
  cfile  := ::drgDialog:dataManager:get('forms->cmainfile')

  do case
  case cname = 'forms->cmainfile'
    ok     := ::is_task_changed
    task   := upper(::dm:get('forms->ctask'))
    values := drgDBMS:dbd:values

    for x := 1 to len(values) step 1
      obj  := values[x,2]
      if upper(obj:task) = task
        AAdd(acombo_val, {padR(obj:fileName,10), obj:fileName +'.' +obj:description } )
      endif
    next

  case cName = 'forms->mblockfrm'

    if Lower(AllTrim(cfile)) == "vykazw" .or. At( 'Table:VYKAZW',FORMS->mData_LL) <> 0
      defvykhd->( dbGoTop())
      do while .not.defvykhd->( Eof())

        cblock := "vyk_naplnvyk" +typ_Vyk +"_in('" +allTrim(defvykhd->cidvykazu) + "')"
        aadd( aCombo_val, { cblock,      padr( allTrim( defVykhd->cidVykazu ), 11 ) + ;
                                    '_' +padr( allTrim( defvykhd->cnazvykazu), 40 ) + ;
                                    '_' +padr( alltrim( defVykhd->ctypVykazu), 15 )     })

        defvykhd->( dbSkip())
      enddo

    else
      do case
      case typzpr = 1                                  ;  typprg := 'FCE_TMLSTV'
      case typzpr = 2                                  ;  typprg := 'OBJ_TMLSTV'
      case typzpr = 3                                  ;  typprg := 'FCE_TMLSTV'
      case typzpr = 4 .or. typzpr = 5 .or. typzpr = 6  ;  typprg := 'FCE_TMLSTV'
      endcase

      if .not. Empty(typprg)
        cFiltr := Format("Upper(ctypobject) = '%%' .and. Upper(ctabledb) = '%%'", {typprg,Upper(AllTrim(cfile))})
        asystem->(ads_setaof( cFiltr),dbgotop())

         val := AllTrim( FORMS->MBLOCKFRM)
         do while .not.asystem->( Eof())
           AAdd( aCombo_val, {asystem->cprgobject, AllTrim(asystem->cnameobj)+'.'+AllTrim(asystem->mobject)})
           asystem->( dbSkip())
         enddo
        asystem->(ads_clearaof())
      endif
    endif
    if len(aCombo_val) = 0
      acombo_val := { { '          ', space(50) } }
    endif
    ok := ( len(aCombo_val) > 0 )

   case cName = 'forms->mbloc_user' .and. ::newRec

    acombo_val := { { '          ', space(50) } }

    if Lower(AllTrim(cfile)) == "vykazw" .or. At( 'Table:VYKAZW',FORMS->mData_LL) <> 0
      val := ::odrgCombo_MBLOCKFRM:odrg:value

      if defvykhd->( dbSeek( val,, 'DEFVYKHD03' ))
        task      := upper(defVykhd->ctask)
        idVykazu  :=       defVykhd->cidVykazu
        rozAtrVyk := upper(defVykhd->crozAtrVyk)

        defvykhd->( dbGoTop())

        do while .not.defvykhd->( Eof())
          if ( task = upper(defVykhd->ctask) .and. rozAtrVyk = upper(defVykhd->crozAtrVyk))
            if idVykazu <> defVykhd->cidVykazu

              cblock := "vyk_naplnvyk" +typ_Vyk +"_in('" +allTrim(defvykhd->cidvykazu) + "')"
              aadd( aCombo_val, { cblock,      padr( allTrim( defVykhd->cidVykazu ), 11 ) + ;
                                          '_' +padr( allTrim( defvykhd->cnazvykazu), 40 ) + ;
                                          '_' +padr( alltrim( defVykhd->ctypVykazu), 15 )     })
            endif
          endif
          defvykhd->( dbSkip())
        enddo
      endif
    endif
    ok := ( len(aCombo_val) > 0 )
  endcase

  if ok
    ::is_task_changed := .f.
    drgComboBox:odrg:oXbp:clear()

    drgComboBox:odrg:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
    aeval(drgComboBox:odrg:values, { |a| drgComboBox:odrg:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgComboBox:odrg:value :=  drgComboBox:odrg:ovar:value
    drgComboBox:odrg:refresh( drgComboBox:odrg:value )
  endif

  RETURN .t.



*  Kopírování formuláøe
** CLASS for SYS_forms_copy_CRD *********************************************
CLASS SYS_forms_copy_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  getForm
  METHOD  drgDialogStart
  METHOD  postValidate, onSave

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


ENDCLASS


METHOD SYS_forms_copy_CRD:init(parent)
  local  filename, filedesc

  ::drgUsrClass:init(parent)
  drgDBMS:open('FORMS',,,,,'FORMSc')
  * tady nevím jestli zap *
  drgDBMS:open('FORMSw',.T.,.T.,drgINI:dir_USERfitm);ZAP
  mh_COPYFLD('FORMS', 'FORMSw', .T.)

RETURN self


METHOD SYS_forms_copy_CRD:getForm()
  LOCAL oDrg, drgFC
  local n
  LOCAL cVal := ''
  local defOpr

  defOpr := defaultDisUsr('Forms','CTYPFORMS')

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,5 DTYPE '10' TITLE 'Kopie tiskového formuláøe' ;
                       GUILOOK 'All:Y,Border:Y,Action:N';
                       PRE 'preValidate' POST 'postValidate'

  DRGSTATIC INTO drgFC STYPE 14 SIZE 98,4.1 FPOS 1,0.4
  DRGTEXT INTO drgFC CAPTION 'Údaje nového formuláøe'  CPOS 2,0.3 CLEN 35 PP 3// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Typ formuláøe'  CPOS 2,1.6 CLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGCOMBOBOX FORMSw->CTYPFORMS  INTO drgFC FPOS 2,2.6 FLEN 15 VALUES defOpr PP 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Id formuláøe'  CPOS 20,1.6 CLEN 21 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGGET FORMSw->CIDFORMS   INTO drgFC FPOS 20,2.6 FLEN 20 PP 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Název formuláøe'  CPOS 45,1.6 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGGET FORMSw->CFORMNAME  INTO drgFC FPOS 45,2.6 FLEN 50 PP 2//PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2

RETURN drgFC


METHOD SYS_forms_copy_CRD:drgDialogStart(drgDialog)
  local typ, cval

  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager

  ::dm:refresh()

  typ   := defaultDisUsr('Forms', 'DEFAULTOPR')

  cval  := newIDforms(typ)
  ::dataManager:set("formsw->cidforms", cval)

RETURN self


METHOD SYS_forms_copy_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval

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

//  if( changed .and. .not. ::changeFRM, ::changeFRM := .T., NIL)

  ** ukládáme pøi zmìnì do tmp **
//  if(lOK, ::msg:writeMessage(), NIL)
//  if( changed, ::dm:refresh(.T.), NIL )

RETURN lOk



METHOD SYS_forms_copy_CRD:onSave()

  ( ::dm:save(), mh_COPYFLD('FORMSw', 'FORMS', .T.))
  forms->ncisforms := Val(Right(formsw->cidforms,6))

RETURN .T.




**  Konfigaurace DIM
** CLASS for DIM_config_scr_DIM *********************************************
CLASS SYS_forms_modi_mle_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  getForm
  METHOD  drgDialogStart
  METHOD  onSave

HIDDEN:
  VAR     dm, msg


ENDCLASS


METHOD SYS_forms_modi_mle_CRD:init(parent)
  local  filename, filedesc

  ::drgUsrClass:init(parent)

RETURN self


METHOD SYS_forms_modi_mle_CRD:getForm()
  LOCAL oDrg, drgFC
  local n
  LOCAL cVal := ''

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 82,18 DTYPE '10' TITLE 'Formuláø' ;
                       GUILOOK 'All:Y,Border:Y,Action:N';
                       PRE 'preValidate' POST 'postValidate'

*  DRGSTATIC INTO drgFC STYPE 14 SIZE 80,15.3 FPOS 1,0.4

  DRGTEXT INTO drgFC CAPTION 'Datový model'  CPOS 2,0.4 CLEN 20  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGMLE FORMS->mFORMS_LL INTO drgFC FPOS 2,0.4 SIZE 78,16.8 PP 2//PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2

*  DRGEnd INTO drgFC


RETURN drgFC


METHOD SYS_forms_modi_mle_CRD:drgDialogStart(drgDialog)

  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager

RETURN self


METHOD SYS_forms_modi_mle_CRD:onSave()

  (FORMS->(dbRlock()), ::dm:save(), FORMS->(dbUnLock()))

RETURN .T.


FUNCTION newIDforms(typ)
  local newID
  local filtr

  drgDBMS:open('FORMS',,,,,'FORMSa')
  filtr := Format("cIDforms = '%%'", {typ})
  FORMSa->( AdsSetOrder(1), ads_setaof(filtr), DBGoBotTom())
  newID := typ + StrZero( Val( SubStr(FORMSa->cIDforms,5,6))+1, 6)
  FORMSa->(ads_clearaof(), dbCloseArea())

RETURN(newID)