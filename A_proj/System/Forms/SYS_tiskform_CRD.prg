#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "dmlb.ch"
#include "dll.ch"

#include "..\Asystem++\Asystem++.ch"


static function SaveWorkarea()
return  { { Alias(Select())                          ,{|x|   DbSelectArea(x)         } }, ;
          { OrdSetFocus()                            ,{|x|   AdsSetOrder(x)          } }, ;
          { ads_getaof()                             ,{|x|   ads_setaof(x)           } }, ;
          { dbrselect(1), dbrelation(1)              ,{|x,y| sys_relation_crd(x,y)   } }, ;
          { dbscope(SCOPE_TOP), dbscope(SCOPE_BOTTOM),{|x,y| sys_scope_crd(x,y)      } }, ;
          { Recno()                                  ,{|x|   AdsGotoRecord(x)        } }  }


static function RestWorkSpace(asaved)
  local x, y, pa, pb, cfile

  for x := 1 to len(asaved) step 1
    pa    := asaved[x]

    if used( cfile := pa[1,1] )

      (cfile)->( ads_clearaof())     // odstøelíme filtry
      (cfile)->( dbclearrelation())  // odstøelíme relace

      for y := 2 to len( pa ) step 1
        pb := pa[y]

        if .not. empty( pb[1] )
          if len( pb ) = 2
            (cfile)->( eval( pb[2], pb[1]))
          else
            (cfile)->( eval( pb[3], pb[1], pb[2]))
          endif
        endif
      next
    endif
  next
return .t.


function sys_relation_crd(warea,cblock)
  dbsetrelation(warea,COMPILE(cblock))
return .t.


function sys_scope_crd(xscope_top, xscope_bottom)

  if .not. empty(xscope_top) .and. .not. empty(xscope_bottom)
    do case
    case xscope_top = xscope_bottom
      dbsetscope(SCOPE_BOTH, xscope_top)
      DbGoTop()
    otherwise
      ( dbsetscope(SCOPE_TOP, xscope_top), dbsetscope(SCOPE_BOTTOM,xscope_bottom) )
      dbGoTop()
    endcase
  endif
return .f.



*
** CLASS for SYS_tiskform_crd **************************************************
CLASS SYS_tiskform_CRD FROM drgUsrClass, sys_filtrs
EXPORTED:
  var     idflt, ZPUSOBtisku, ctask, culoha
  var     pa_grpkey                                 // pro vykazw
  var     isReport                                  // pro vyk_vykazy

  METHOD  init, getForm, drgDialogStart, preValidate, postValidate
  METHOD  all_itemMarked
  METHOD  selForms, selFiltrs
  *
  METHOD  runPRV, runPRN, runSEL, runEXP, runFIL, offFILTER, set_Printer
  *
  METHOD  onSave, delRecTsk, delRecFlt
  *
  METHOD  destroy
  method  ebro_saveEditRow

  * BRO column indikuje vazbu na období pro vytváøení TMP podkladù
  inline access assign method is_obdReport() var is_obdReport
    local  retVal := 0, npos, cblock
    local  nobdobi, nrok
    *
    local  ok

    if forms ->(dbSeek(upper(frmusers->cidforms),, AdsCtag(1) ))
      if .not. empty(forms->mblockfrm)
        cblock := upper(allTrim(forms->mblockfrm))
        if(npos := at('(',cblock)) <> 0
          cblock := subStr(cblock, 1, npos-1)
        endif
        *
        **
        ::ctask     := '  ' +upper(forms->ctask) +' '

        if isObject( 'uctOBDOBI:' +upper(forms->ctask) +':culoha' )
          ::culoha    := DBGetVal('uctOBDOBI:' +upper(forms->ctask) +':culoha' )
        endif

        if isObject( ::push_obd )
          nobdobi   := DBGetVal('uctOBDOBI:' +upper(forms->ctask) +':nobdobi')
          nrok      := DBGetVal('uctOBDOBI:' +upper(forms->ctask) +':nrok'   )
          obdReport := strZero( nobdobi,2) +'/' +strZero(nRok,4)

          ::push_obd:oxbp:setCaption( ::ctask +obdReport)
        endif

        ok := asystem->(dbSeek(upper(cblock),, AdsCtag(1) ))

        retVal := if(asystem->lobdReport,  MIS_EDIT, 0)
      endif
    endif
    return retVal

  inline access assign method c_obdReport() var c_obdReport
    local  retVal := space(11)
    *
    local  npos, ctask, recNo
    *
    if ::is_obdReport = MIS_EDIT
      ctask := upper(forms->ctask)
      recNo := frmusers->(recNo())

      * na záznamu si nastavil obdobi pro tisk
      if( npos := ascan( ::a_obdReport, { |i| i[3] = recNo })) <> 0
        retVal := ::a_obdReport[npos,2]
        return retVal
      endif

      * použijeme období sakra ale které user / sys ??
      if( npos := ascan( ::a_obdReport, { |i| i[1] = ctask })) <> 0
        retVal :=  ::a_obdReport[npos,2]
      endif

      * no a aby toho nebylo dost
      if empty(retVal)
        retVal := upper(ctask)                       + ;
                  ' '                                + ;
                  strZero(UCTOBDOBI:&ctask:nobdobi,2)+ ;
                  '/'                                + ;
                  strZero(UCTOBDOBI:&ctask:nrok,4)
      endif

      *
      ** no a aby toho bylo ještì trochu pro Nákladové Výsledovky
      if( ::is_NaklVysl, retVal := obdReport, nil )

    endif
    return retVal


  * filtritw
  inline access assign method ised_cvyraz_2() var ised_cvyraz_2
    return if(filtritw->lnoedt_2, MIS_NO_RUN, 0 )


  inline method ebro_afterAppend( drgEBro )
    local  ardef   := drgEBro:ardef, npos
    local  cfile   := lower(drgEBro:cfile)
    local  odrgVar := ::dm:get('m->c_obdReport', .f. )

    *
    ** ins - musíme vyèistit filtr a položky filtru
    do case
    case (cfile = 'frmusers')
      if ::isReport
        ::all_itemMarked()
        ::dctrl:oBrowse[2]:oxbp:goTop():refreshAll():deHilite()

        ::itemMarked()
        ::dctrl:oBrowse[3]:oxbp:goTop():refreshAll():deHilite()
        ::idflt := ''
      endif
    *
    ** ins - musíme vyèistit položky filtru
    case (cfile = 'fltusers')
      ::itemMarked()

      ::dctrl:oBrowse[3]:oxbp:goTop():refreshAll():deHilite()
      ::idflt := ''

      if (npos := ascan(ardef, {|x| lower(x[2]) = 'fltusers->cfltName' })) <> 0
        return npos
      endif
    endcase

    if isObject(odrgVar) .and. (cfile = 'frmusers')
      odrgVar:odrg:isEdit := .f.
      return 1
    endif
  return .t.


  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc      := ::drgDialog:dialogCtrl
    LOCAL  lastXbp := ::drgDialog:lastXbpInFocus, cfile
    LOCAL  tmIns   := .F.
    LOCAL  fileTm

    forms ->(DbSeek(upper(frmusers ->cidforms),, 'FORMS01' ))

    * hodnì to blbne
    if ::isReport .and. .not. ::is_showItems
      ::is_showItems := .t.
      ::dctrl:oBrowse[3]:oxbp:show()
    endif

    do case
    CASE nEvent = drgEVENT_DELETE

      if lastXbp:className() = 'XbpBrowse'
        cfile := upper( lastXbp:cargo:cfile )

        if drgIsYESNO(drgNLS:msg('Delete record!;;Are you sure?'))
          if( cfile = 'FRMUSERS', ::delRecTsk(), NIL)
          if( cfile = 'FLTUSERS', ::delRecFlt(), NIL)
        endif
      endif
      RETURN .T.

    CASE nEvent = xbeP_Keyboard
      do case
      case oxbp:className() = 'XbpGet'
        if ascan(::noedit_get, {|x| x = oxbp}) <> 0
          if (mp1 >= 32 .and. mp1 <= 255)
            return .t.
          else
            return .f.
          endif
        endif
        return .f.

      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        RETURN .F.
      endcase

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

  * nastavení období pro tisky
  inline method push_obd(drgDialog)
    local  editSize, state, text
    local  pos := AClone(drgDialog:dataAreaSize)

    editSize := 24 +13*drgINI:fontW
    pos[1]   -= editSize +1
    pos[2]   := 21
    state    := DRG_ICON_EDIT
    text     := ''

    ::ib:addAction({pos[1],1},{editSize,pos[2]},3,state,state,,text,,NIL,.F.)

    ::push_obd         := atail(::ib:members)
    ::push_obd:event   := 'obdReport_sel'
    ::push_obd:tipText := 'Nastavené období pro tisky'
    *
    ::push_obd:oXbp:setFont(drgPP:getFont(5))
    ::push_obd:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
  return .t.


  inline method obdReport_sel(drgDialog)
    local  odialog, nexit
    local  old_obdReport := obdReport
    *
    local  pa := ::a_obdReport, npos, cobd

    DRGDIALOG FORM 'sys_obdReport_sel' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

    **
    ctask := upper(forms->ctask)
    recNo := frmusers->(recNo())
    npos  := ascan( pa, { |i| i[3] = recNo })

    if at( ',', obdReport) <> 0
      cobd := obdReport
    else
      cobd  := strZero(ucetsys->nobdobi,2) +'/' +strZero(ucetsys->nrok,4)
    endif

    if npos = 0
      aadd( ::a_obdReport, { ctask, ctask +' ' +cobd, recNo } )
    else
      ::a_obdReport[npos,2] := ctask +' ' +cobd
      ::a_obdReport[npos,3] := recNo
    endif

    ::is_obdReport_sel := .t.

    postAppEvent(drgEVENT_SAVE,,, drgDialog:lastXbpInFocus)
    postAppEvent(xbeBRW_ItemMarked,,,::dctrl:obrowse[1]:oxbp)
 return .t.

HIDDEN:
  VAR     msg, dm, bro, dctrl, ib, ab, pushOk, noedit_get
  VAR     prevForm, prevBro, prevFile, prnFiles
  VAR     selMenuTsk, lnewrec
  VAR     is_NaklVysl, cflt_NaklVysl
  *
  var     asaved, push_obd, a_obdReport
  var     pb_runPRV, pb_runPRN, pb_runSEL, pb_runEXP, pb_offFILTER
  *
  var     xbp_therm, oThread_w
  var     is_showItems, is_obdReport_sel
  *
  var     oPrinter

  METHOD  verifyActions, setFilter
  METHOD  runPrint

  inline method start_worm()
    local  i, aBitMaps  := { 0, 0, {nil,nil,nil,nil} }, nPHASe := MIS_WORM_PHASE1, oThread_w
    local     xbp_therm := ::xbp_therm
    *
    ** nachystáme si èervíka v samostatném vláknì
    for i := 1 to 4 step 1
      aBitMaps[3,i] := XbpBitmap():new():create()
      aBitMaps[3,i]:load( ,nPHASe )
      nPHASe++
    next

    ::oThread_w := Thread():new()
    ::oThread_w:setInterval( 8 )
    ::oThread_w:start( "sys_fltusers_animate", xbp_therm, aBitMaps)
    return self

  inline method stop_worm()
    ::oThread_w:setInterval( NIL )
    ::oThread_w:synchronize( 0 )
    ::oThread_w := nil

    ::xbp_therm:setCaption('')
    return self
ENDCLASS


METHOD SYS_tiskform_CRD:init(parent)
  local  asaved := ::asaved := {}
  local  x, c_task, c_obdobi
  *
  local  pa

  if empty(obdReport)
    obdReport := strZero(uctOBDOBI:UCT:nobdobi,2) +'/' +strZero(uctOBDOBI:UCT:nrok,4)
  endif

  ::drgUsrClass:init(parent)
  *
  ** období pro úlohu a uživatele
  ::a_obdReport := {}
  for x := 1 to len(uctOBDOBI:a_mobdUser) step 1
    c_task   := uctOBDOBI:a_mobdUser[x,1]
    c_obdobi := uctOBDOBI:a_mobdUser[x,2]

    aadd( ::a_obdReport, { c_task, ;
                           c_task +' ' +right(c_obdobi,2) +'/' +subStr(c_obdobi,2,4), ;
                           0       } )
  next
  *
  ** impliciní hodnoty
  ::ctask            := 'UCT'
  ::culoha           := 'U'

  ::lnewrec          := .F.
  ::idflt            := ''
  ::noedit_get       := {}

  ::is_NaklVysl      := .f.
  ::cflt_NaklVysl    := ''

  ::is_showItems     := .f.
  ::is_obdReport_sel := .f.
  ::oPrinter         := XbpPrinter():new()
  if( ::oPrinter:list() = nil, nil, ::oPrinter:create() )

  *
  ** nákladové výsledovky volané z uct_naklvysl_in
  if len( pa := listAsArray( parent:initParam, ',')) >= 2
    ** 1 -- u tìchto sestav se nenabízí NIKDY období
    ** 2 -- pøi výbìru pro pøevzetí je nastaven filtr
    **      ( cmainFile = 'vykazw' .and. ntypZpr = 3 )
    if lower( pa[2]) = 'uct_naklvysl_lst'
      ::is_NaklVysl   := .t.
      ::cflt_NaklVysl := " .and. (lower(cmainFile) = 'vykazw' .and. ntypZpr = 4)"
    endif
  endif

  WorkSpaceEval( {|| aadd( asaved, SaveWorkarea() ) } )

  drgDBMS:open('FRMUSERS')
  drgDBMS:open('FLTUSERS')
  drgDBMS:open('FILTRS'  )
  drgDBMS:open('FORMS'   )
  drgDBMS:open('ASYSTEM' )

  drgDBMS:open('DEFVYKIT')
  drgDBMS:open('DEFVYKSY')
  *
  * tady nevím jestli zap *
  drgDBMS:open('FILTRITw',.T.,.T.,drgINI:dir_USERfitm);ZAP
RETURN self


METHOD SYS_tiskform_CRD:getForm()
  LOCAL drgFC := drgFormContainer():new(), oDrg, _drgEBrowse

  ::isReport := (::drgDialog:parent:formName == "drgMenu")

  if ::isReport
    * sestava volaná z nabídky menu *

    ::selMenuTsk := drgParse(drgParseSecond(::drgDialog:initParam))

    DRGFORM INTO drgFC SIZE 115,23 DTYPE '10' TITLE 'Uživatelské sestavy' ;
                       GUILOOK 'All:Y,Border:Y,Action:Y';
                       PRE 'preValidate' POST 'postValidate'

    * Browser _frmusers
    DRGEBROWSE INTO drgFC FPOS 0.5,0.05 SIZE 61,12.5 FILE 'FRMUSERS'      ;
               ITEMMARKED 'all_itemMarked' SCROLL 'yy' CURSORMODE 3 PP 7 RESIZE 'ny'
      _drgEBrowse := oDrg

      DRGGET  M->c_obdReport      INTO drgFC       FLEN 12 FCAPTION 'Období ?'
      oDrg:push         := 'obdReport_sel'

      DRGGET  frmusers->cformName INTO drgFC       FLEN 45 FCAPTION 'Název sestavy'
      oDrg:push         := 'selForms'
      oDrg:isedit_inrev := .f.

      DRGTEXT INTO drgFC NAME frmusers->cidForms   CLEN 12  CAPTION 'id'

      _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC


    * Browser _fltusers
    DRGEBROWSE INTO drgFC FPOS 60.9,0.05 SIZE 53.3,10.9 FILE 'FLTUSERS'   ;
               ITEMMARKED 'all_itemMarked' SCROLL 'yy' CURSORMODE 3 PP 7  ;
               GUILOOK 'ins:y,del:y,enter:y'                              ;
               RESIZE 'yy'

      _drgEBrowse := oDrg

      DRGCHECKBOX fltusers->lbegUsers INTO drgFC FLEN  3 FCAPTION 'usr' VALUES 'T,F'
      DRGCHECKBOX fltusers->lfiltrYes INTO drgFC FLEN  3 FCAPTION 'res' VALUES 'T:.,F:.'

      DRGGET      fltusers->cfltName  INTO drgFC FLEN 43 FCAPTION 'Název filtru'
      oDrg:push := 'selFiltrs'
      oDrg:isedit_inrev := .f.

      DRGTEXT INTO drgFC NAME fltusers->cidFilters CPOS 2,0 CLEN 12  CAPTION 'id'

      _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC

    * Browser _filtritw
    DRGEBROWSE INTO drgFC FPOS 0.05,12.8 SIZE 114.5,9.6 FILE 'FILTRITw'             ;
         SCROLL 'ny'  CURSORMODE 3 PP 7 GUILOOK 'ins:n,del:n,sizecols:n,headmove:n' RESIZE 'yn'

      _drgEBrowse := oDrg

      DRGTEXT INTO drgFC NAME filtritW->clgate_1  CLEN  2 CAPTION  '('
      DRGTEXT INTO drgFC NAME filtritW->clgate_2  CLEN  2 CAPTION  '('
      DRGTEXT INTO drgFC NAME filtritW->clgate_3  CLEN  2 CAPTION  '('
      DRGTEXT INTO drgFC NAME filtritW->clgate_4  CLEN  2 CAPTION  '('

      DRGTEXT INTO drgFC NAME filtritW->cfile_1   CLEN  9   CAPTION  'table'

      DRGTEXT INTO drgFC NAME filtritW->cvyraz_1u CLEN 31 CAPTION  'výraz-L'
      DRGTEXT INTO drgFC NAME filtritW->crelace   CLEN  6 CAPTION  'oper'
      DRGGET  filtritW->cvyraz_2u INTO drgFC      CLEN 32 FCAPTION 'výraz-P'

      DRGTEXT INTO drgFC NAME M->ised_cvyraz_2    CLEN  2  CAPTION ''
      oDrg:isbit_map := .t.

      DRGTEXT INTO drgFC NAME filtritW->cfile_2   CLEN  9   CAPTION  'table'

      DRGTEXT INTO drgFC NAME filtritW->crgate_1  CLEN  2 CAPTION  ')'
      DRGTEXT INTO drgFC NAME filtritW->crgate_2  CLEN  2 CAPTION  ')'
      DRGTEXT INTO drgFC NAME filtritW->crgate_3  CLEN  2 CAPTION  ')'
      DRGTEXT INTO drgFC NAME filtritW->crgate_4  CLEN  2 CAPTION  ')'
      DRGTEXT INTO drgFC NAME filtritW->coperand  CLEN  7

      _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC

    DRGPUSHBUTTON INTO drgFC ;
                       CAPTION 'Zpracovat tiskovou sestavu bez filtru' ;
                       POS 61.8,11.2                                   ;
                       SIZE 35,1 ATYPE 3 ICON1 0 ICON2 0               ;
                       EVENT 'offFILTER'                               ;
                       TIPTEXT 'Nefiltrovat tiskovou setavu ...'
  else

    * formuláø volaný z formuláøe *

    DRGFORM INTO drgFC SIZE 58.2,20 DTYPE '10' TITLE 'Uživatelské sestavy'              ;
                       GUILOOK 'Menu:N,Border:Y,Action:Y,ICONBAR:Y:drgStdBrowseIconBar' ;
                       PRE 'preValidate' POST 'postValidate'

    * Browser _frmusers
    DRGEBROWSE INTO drgFC FPOS 0.5,0.05 SIZE 57.6,19.8 FILE 'FRMUSERS'  ;
               ITEMMARKED 'itemMarked' SCROLL 'ny' CURSORMODE 3 PP 3    ;
               RESIZE 'yy'

      _drgEBrowse := oDrg

      DRGGET  frmusers->cformName INTO drgFC       FPOS 1,0 FLEN 48 FCAPTION 'Název sestavy'
      oDrg:push         := 'selForms'
      oDrg:isedit_inrev := .f.
      DRGTEXT INTO drgFC NAME frmusers->cidForms   CPOS 2,0 CLEN 15  CAPTION 'id'

      _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC

    DRGTEXT INTO drgFC CAPTION 'Zpracovat ...' CPOS 0,15 CLEN 12 BGND 9
    DRGRadioButton M->ZPUSOBtisku INTO drgFC FPOS 0,16.5 SIZE 18,3 ;
                   VALUES 'Z:záznam,'  + ;
                          'V:výbìr,'   + ;
                          'A:vše'
  endif

  DRGAction INTO drgFC CAPTION 'ná~Hled'      EVENT 'runPRV'    TIPTEXT 'Prohlížení a tisk'
  DRGAction INTO drgFC CAPTION 't~Isk'        EVENT 'runPRN'    TIPTEXT 'Tisk na tiskárnu'
  DRGAction INTO drgFC CAPTION      ''        EVENT 'sep'       ATYPE 5
  DRGAction INTO drgFC CAPTION 'pøí~Mý tisk'  EVENT 'runSEL'    TIPTEXT 'Pøímý tisk na tiskárnu'

  DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
  DRGACTION INTO drgFC CAPTION 'e~Xport do  ' EVENT 'runEXP'    TIPTEXT 'Export do aplikace' // ICON1 338 ATYPE 33

  if isWorkVersion
    DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
    DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
    DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
    DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
    DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
    DRGAction INTO drgFC CAPTION 'ti~Skárna' EVENT 'set_printer' ;
                                                    TIPTEXT 'Nastavení tiskárny ...'
  endif
RETURN drgFC


METHOD SYS_tiskform_CRD:drgDialogStart(drgDialog)
  LOCAL  members, x, filtr, asize_G, asize, capt
  local  ardef, lastRec

  ::sys_filtrs:init(drgDialog)
  *
  ::prevForm := drgDialog:parent
  members    := ::prevForm:oForm:aMembers

  if .not. ::isReport
     BEGIN SEQUENCE
       for x := 1 TO len(members)
         if 'browse' $ lower(members[x]:className())
            ::prevBro  := members[x]
            ::prevFile := ::prevBro:cFile
     BREAK
         endif
       next
     END SEQUENCE
  endif

  * tady musíme vyskoèit stiskl CTRL_P a nelze spustit dialog
  if .not. ::isReport .and. ( empty( ::prevBro ) .or. empty( ::prevFile ))
    return .f.
  endif

  *
  ::msg       := drgDialog:oMessageBar
  ::dm        := drgDialog:dataManager
  ::dctrl     := drgDialog:dialogCtrl
  ::ib        := drgDialog:oIconBar
  ::xbp_therm := drgDialog:oMessageBar:msgStatus

  // iconBar
  if isobject(drgDialog:oActionBar)
    ::ab      := drgDialog:oActionBar:members    // actionBar

    for x := 1 to len( ::ab) step 1
      do case
      case ::ab[x]:event = 'runPRV'  ;  ::pb_runPRV := ::ab[x]:oxbp
      case ::ab[x]:event = 'runPRN'  ;  ::pb_runPRN := ::ab[x]:oxbp
      case ::ab[x]:event = 'runSEL'  ;  ::pb_runSEL := ::ab[x]:oxbp
      case ::ab[x]:event = 'runEXP'  ;  ::pb_runEXP := ::ab[x]:oxbp
      endcase
    next
  endif

  ::prevForm := drgDialog:parent
  ::prnFiles := drgDialog:parent:formHeader:prnFiles
  *
  members  := drgDialog:oForm:aMembers

  BEGIN SEQUENCE
    for x := 1 TO len(members)
      if members[x]:ClassName() = 'drgEBrowse'
        drgDialog:oForm:nextFocus := x
        postappevent(xbeBRW_ItemMarked,,,members[x]:oxbp)
        setappfocus(members[x]:oxbp)
  BREAK
      endif
    next
  END SEQUENCE

  *
  ** volba zpracování pro tisk z formuláøe
  if .not. ::isReport
    members[5]:oxbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
    members[5]:oBord:setParent(drgDialog:oActionBar:oBord)

    for x := 1 to len(members[6]:members) step 1
      oxbp := members[6]:members[x]

      do case
      case( x = 1 )  ;  if( len(::prevBro:arselect)  = 0 .and. .not.::prevBro:is_selAllRec, ::ZPUSOBtisku := 'R', nil)
      case( x = 2 )  ;  if( len(::prevBro:arselect) <> 0, ::ZPUSOBtisku := 'V', nil)
      case( x = 3 )
        if ::prevBro:is_selAllRec
          oxbp:setCaption('vše_' +strTran(str((::prevFile)->(lastRec())),' ','') +'')
          ::ZPUSOBtisku := 'A'
        endif
      endcase

      oxbp:parent:setParent(drgDialog:oActionBar:oBord)
    next
  endif

  filtr := Format("upper(cUser) = '%%' .and. upper(cCallForm) = '%%'", ;
                  {  upper(usrName), if(::isReport, upper(::selMenuTsk), upper(::prevForm:formName)) })
  frmusers ->( ads_setaof(filtr),DbGoTop())
  ::dctrl:oBrowse[1]:refresh(.t.)

  * needitaèní gety
  ardef := drgDialog:odbrowse[1]:ardef
  for x := 1 to len(ardef) step 1
    if lower(ardef[x].defName) = 'm->c_obdreport'      .or. ;
       lower(ardef[x].defName) = 'frmusers->cformname'

      aadd(::noedit_get, ardef[x].drgEdit:oxbp)
    endif
  next


  if ::isReport
    * needitaèní gety
    ardef := drgDialog:odbrowse[2]:ardef
    for x := 1 to len(ardef) step 1
      if lower(ardef[x].defName) = 'fltusers->cfltname'
        aadd(::noedit_get, ardef[x].drgEdit:oxbp)
      endif
    next

    * modifikace tlaèítka offFilter
    asize_G      := drgDialog:dialogCtrl:obrowse[2]:oxbp:currentSize()

    ::pb_offFilter := atail(members)
    asize          := ::pb_offFilter:oxbp:currentSize()
    ::pb_offFilter:oxbp:setSize({asize_G[1], asize[2]})


    if isObject(ocol := ::dctrl:obrowse[1]:getColumn_byName('M->c_obdReport'))
**      ocol := ::dctrl:obrowse[1]:oxbp:getColumn(1)
**      ocol:dataArea:setFont( drgPP:getFont(2) )
      ocol:colorBlock := { |xval| if( empty(xval), {,}, { , GraMakeRGBColor({255,255,0}) } ) }
    endif
  endif
RETURN self


METHOD SYS_tiskform_CRD:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  *
  local  lOk := .T., odesc

  do case
  case file = 'fltusers'
    if frmusers->(eof())
      ::msg:writeMessage('Nelze nastavit filtr, pokud není vybrána žádná sestava ...',DRG_MSG_ERROR)
      return .f.
    endif

    if ( name = 'fltusers->lbegusers' )
      if fltusers->( Ads_GetRecordCount()) > 1
        return .t.
      else
        return .f.
      endif
    endif

  case file = 'filtritw'
    if filtritw->(eof())
      ::msg:writeMessage('Nelze zadat hodnoty pro výbìr, pokud není vybrán žádný filtr ...',DRG_MSG_ERROR)
      return .f.
    endif
  endcase

  if lower(name) = 'm->c_obdreport'
    if ::is_NaklVysl
      return .f.
    else
      return  .not. empty(::c_obdReport)
    endif
  endif

  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    lOk   := (at('->',filtritw ->cvyraz_2) = 0)
    lOk   := if( lOk, .not. filtritw->lnoedt_2, lOk)

    odesc := drgDBMS:getFieldDesc(strtran(filtritw->cvyraz_1,' ',''))

    if lOK .and. IsObject(odesc)
      do case
      case odesc:type = 'D'
        drgVar:odrg:oxbp:picture := '@D'
      case odesc:type = 'L'
        drgVar:odrg:oxbp:picture := '@KXXX'
      otherwise
        drgVar:oDrg:oXbp:picture := odesc:picture
      endcase
    endif
  endif
RETURN lOk


method sys_tiskform_crd:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()


  do case
  case(file = 'frmusers')
    ok := if( item = 'cformName', ::selForms(), .t.)

  case(file = 'fltusers')
    ok := if( item = 'cfltname', ::selFiltrs(), .t.)

  case(file = 'filtritw')
    if item = 'cvyraz_2u' .and. changed
      filtritw ->cvyraz_2         := value
      ::aitw[filtritw->(RecNo())] := value
    endif
    ::verifyActions(.t.)

  endcase
return ok


*
** itemMarked for all **
METHOD SYS_tiskform_CRD:all_itemMarked()
  local  file, filtr, cc
  local  offFilter := if(::isReport, .not. empty(::pb_offFILTER:icon1), .f. )
  local  ccallform, cIDForms
  local  nskip := 0, lbegUsers := .f.

  if isObject(::dctrl:oaBrowse)

    file  := Lower(::dctrl:oaBrowse:cFile)

    do case
    case file = 'frmusers'
      if ::isReport

        ccallform := if( ::dctrl:oaBrowse:state = 0 .or. ::is_obdReport_sel, frmusers->ccallform, '  ' )
        cIDForms  := if( ::dctrl:oaBrowse:state = 0 .or. ::is_obdReport_sel, frmusers->cIDForms , '  ' )

        filtr := Format("cUser = '%%' .and. cCallForm = '%%' .and. cIDForms = '%%'", ;
                       { usrName, ccallform, cIDForms })

        if filtr <> fltUsers->(ads_getAof())
          fltusers->(ads_clearaof())
          fltusers->( ads_setaof(filtr), dbgoTop() )

          begin sequence
            do while .not. fltUsers->( eof())
              if fltusers->lbegUsers
                lbegUsers := .t.
            break
              else
                nskip++
              endif
              fltUsers->( dbskip())
            enddo
          end sequence
          fltUsers->( dbgoTop())

          if lbegUsers
            ::dctrl:obrowse[2]:oxbp:goTop()
            for x := 1 to nskip step 1  ;  ::dctrl:obrowse[2]:oxbp:down() ;  next

            ::dctrl:obrowse[2]:oxbp:refreshAll()
          endif
        endif

        if isObject( ::push_obd )
          if( ::is_obdReport = 0, ::push_obd:oxbp:hide(), ::push_obd:oxbp:show() )
        endif

        if .not. empty( cc := ::c_obdReport)
          obdReport := right( cc, 7 )             // je to ve tvaru UCT 05/2010
        endif
      endif

    case file = 'filtritw' .and. offFILTER
      postAppEvent(XBPBRW_Navigate_GoTop,,,::dctrl:obrowse[3]:oxbp)
    endcase

    if( offFILTER, ::offFILTER(), nil)
    ::verifyActions()
    if( offFILTER, ::dctrl:obrowse[3]:oxbp:refreshAll(), nil)

    ::is_obdReport_sel := .f.
  endif

  if ::isReport
    if frmusers->(eof())
      ::pb_offFILTER:disable()
    else
      ::pb_offFILTER:enable()
    endif
  endif
RETURN NIL


*
** možnost zapnout / vypnout filtr u sestav
method sys_tiskform_crd:offFILTER()
  local  x, ok := .t., ab := ::ab
  *
  local oIcon := XbpIcon():new():create()


  if empty( ::pb_offFILTER:icon1 )
    ::pb_offFILTER:icon1 := MIS_ICON_ATTENTION

    oIcon:load( NIL, MIS_ICON_ATTENTION )

    ::pb_offFILTER:oxbp:setImage( oIcon )
    ::pb_offFILTER:oxbp:setFont(drgPP:getFont(5))
    ::pb_offFILTER:oxbp:setColorFG(GRA_CLR_RED)

    * zrušímì kurzor u FLTUSERS
    ::dctrl:obrowse[2]:oxbp:refreshCurrent()
    ::dctrl:obrowse[2]:oxbp:deHilite()

    * zapnem FILTRITw a refrešnem grid
    filtritW->(dbZap(),dbgotop())
    ::dctrl:obrowse[3]:oxbp:refreshAll()
    ::dctrl:obrowse[3]:oxbp:deHilite()

    * zapneme tlaèítka a menu
    for x := 1 to len(ab) step 1
      if IsCharacter(ab[x]:event) .and. Lower(ab[x]:event) $ 'runprv,runprn,runsel'
        ev := Lower(ab[x]:event)
        om := ab[x]:parent:aMenu

        ab[x]:oXbp:setColorFG(If(ok, GraMakeRGBColor({0,0,0}), GraMakeRGBColor({128,128,128})))
        if(ok, ab[x]:oxbp:enable()  , ab[x]:oxbp:disable())
        ab[x]:frameState := if( ok,1,2)

      endif
    next

  else
    ::pb_offFILTER:icon1 := 0

    ::pb_offFILTER:oxbp:setImage( oIcon )

    ::pb_offFILTER:oxbp:setFont(drgPP:getFont(1))
    ::pb_offFILTER:oxbp:setColorFG(GRA_CLR_FALSE)

    ::idflt := ''
    postAppEvent(xbeBRW_ItemMarked,,,::dctrl:obrowse[1]:oxbp)
  endif
return self


*
** pøevzetí záznamu z FORMS -> FRMUSERS **
METHOD SYS_tiskform_CRD:selForms(drgDialog)
  local  oDialog, nExit
  local  value, ok := .t., keyFRM
  *
  local  nlen   := FORMS->(FieldInfo(forms->(FieldPos('cmainfile')),FLD_LEN))
  local  filter := '', prnFiles


  keyFRM := Padr( Upper( usrName), 10)                                           ;
             +Padr(Upper(IF( ::isReport, ::selMenuTsk, ::prevForm:formName)),50) ;
              +',' +if( ::isReport,'A','N')

  value := padr(::dm:get('frmusers->cformname'),50) +padr(::dm:get('frmusers->cidforms'),10)
  ok    := forms->(dbseek( upper(value),,'FORMS08'))
//  ok    := (ok .and. ('[List description]' $ forms->mforms_ll))
  ok    := (ok .and. .not. empty(forms->mforms_ll))


  if ::isReport
  else
    if .not. empty( ::prnFiles)
      aeval(listasarray( ::prnFiles), ;
           {|X| filter += " .or. lower(cmainfile) = '" +padr(substr(x,1,at(':',x)-1),nlen) +"'"})
      filter := SubStr( filter,7)
      filter := "(" +filter +")  .and. "
      filter := lower(filter)

      ok := ok .and. (lower(forms->cmainFile) $ filter)
    else

      * není nadefinavaná sekce vezmem iplicitnì 1 - øídící soubor
      if empty( ::prnFiles ) .and. .not. empty( ::prevFile )
        filter := "( lower(cmainfile) = '" +lower( ::prevFile ) +"') .and. "
      endif
    endif
  endif

  if isObject(drgDialog) .or. .not. ok

    filter += "nforms_ll = 1"
    filter += if( ::is_NaklVysl, ::cflt_NaklVysl, '')

    forms->(ads_setAof(filter))

    DRGDIALOG FORM 'SYS_forms_SEL,' + keyFRM PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif


  if nExit != drgEVENT_QUIT .or. ok
    ::dm:set('frmusers->cformname', forms->cformname)
    ::dm:set('frmusers->cidforms' , forms->cidforms )
    ok := .t.
  endif

  forms->(ads_clearAof())
RETURN ok


*
** pøevzetí záznamu z FILTRS -> FLTUSERS **
METHOD SYS_tiskform_CRD:selFiltrs(drgDialog)
  local  oDialog, nExit
  *
  local  value, ok := .t.

  if ::isReport
    ** u sestav by mìl mít možnost vybrat jen z filtrù pro forms->cmainfile **
    if forms ->(DbSeek(upper(frmusers->cidforms),, AdsCtag(1) ))
       filtrs ->(ads_setaof("Upper(cmainfile) = '" +Upper(forms->cmainfile) +"'"), DbGoTop())

       value := padr(::dm:get('fltusers->cfltname'),50) +padr(::dm:get('fltusers->cidfilters'),10)
       ok    := filtrs->(dbseek( upper(value),,'FILTRS08'))

      if IsObject(drgDialog) .or. .not. ok
        DRGDIALOG FORM 'SYS_filtrs_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
      endif

      if nExit != drgEVENT_QUIT .or. ok
        ::dm:set("fltusers->cfltname"  , filtrs->cfltname  )
        ::dm:set('fltusers->cidfilters', filtrs->cidFilters)
        ok := .t.
      endif

      filtrs->(ads_clearaof())
    endif
  endif
RETURN ok


method sys_tiskform_crd:ebro_saveEditRow(parent)
  local  cfile := lower(parent:cfile)
  *
  local  recNo  := fltusers->(recNo()), oldNo := 0
  local  arDef, drgVar, nin, restAll := .f.


  do case
  case (cfile = 'frmusers')
    frmusers->cuser     := usrName
    frmusers->cidforms  := forms->cidforms
    frmusers->ccallform := IF( ::isReport, ::selMenuTsk, ::prevForm:formName)

    if ::isReport
      ::is_obdReport_sel := .t.
      ::all_itemMarked()
      ::dctrl:oBrowse[2]:oxbp:refreshAll()
      ::dctrl:oBrowse[3]:oxbp:refreshAll()
    endif

  case (cfile = 'fltusers')
    fltusers ->cuser      := usrName
    fltusers ->ccallform  := frmusers->ccallform
    fltusers ->cidforms   := frmusers->cidforms
    fltusers ->cidfilters := filtrs ->cidfilters

    if fltUsers->lbegUsers
      arDef := parent:ardef

      ** tady musí být vyjímka pro fltusers->lbegusers = .t.
      *  jen jeden fitr si mùže uživatel pøednastavit
      if (nin := ascan( arDef, {|x| lower(x[2]) = 'fltusers->lbegusers'} )) <> 0
        drgVar := arDef[nin,7]:ovar

        if ((drgVar:value <> drgVar:prevValue) .and. drgVar:value)
          * pøednastvil filtr, musí bý jen jeden
          fltusers->(dbeval( {|| if( fltusers->lbegusers .and. recNo <> fltusers->(recNo()), ;
                                     oldNo := fltusers->(recNo()), nil ) } ))

          * byl pøednastavený jiny záznam
          if oldNo <> 0
            fltusers->(dbgoTo(oldNo))

            if fltusers->(dbRlock())  ;  fltusers->lbegusers := .f.
                                         restAll := .t.
            else                      ;  lbegusers := .f.
            endif

            fltusers->(dbRUnlock())
          endif

          fltUsers->(dbgoto(recNo))
        endif
      endif

      if( restAll, ::dctrl:oBrowse[2]:oxbp:refreshAll(), nil)
    endif

    if( ::isReport, ::idflt := '', nil )
    ::verifyActions()
    ::dctrl:oBrowse[3]:oxbp:refreshAll()
  endcase
return


METHOD SYS_tiskform_CRD:runPRV()
  if frmusers->(eof())
    return self
  endif
  *
  ** zakážeme tlaèítko - Prohlížení a tisk
  if( isObject(::pb_runPRV), ::pb_runPRV:disable(), nil )
  ::runPrint('PRV')
RETURN self

METHOD SYS_tiskform_CRD:runPRN()
  if frmusers->(eof())
    return self
  endif
  *
  ** zakážeme tlaèítko - Tisk na tiskárnu
  if( isObject(::pb_runPRN), ::pb_runPRN:disable(), nil )
  ::runPrint('PRN')
RETURN self

METHOD SYS_tiskform_CRD:runSEL()
  if frmusers->(eof())
    return self
  endif
  *
  ** zakážeme tlaèítko - Pøímý tisk na tiskárnu
  if( isObject(::pb_runSEL), ::pb_runSEL:disable(), nil )
  ::runPrint('SEL')
RETURN self

method sys_tiskform_crd:runEXP()
  if frmusers->(eof())
    return self
  endif
  *
  ** zakážeme tlaèítko - Export
  if( isObject(::pb_runEXP), ::pb_runEXP:disable(), nil )
  ::runPrint('EXP')
return self


METHOD SYS_tiskform_CRD:runFIL()
  ::runPrint('FIL')
RETURN self


method sys_tiskForm_crd:set_Printer()
  local oprintDialog

  if ::oPrinter = NIL .or. ::oPrinter:status() <> XBP_STAT_CREATE
    return NIL
  endif

  oprintDialog := XbpPrintDialog():new():create()
  oprintDialog:enableNumCopies := .t.
  oprintDialog:numCopies       :=  5

  xx := oprintDialog:display(::oPrinter)
  xx := ::oPrinter:setNumCopies()
  aForms := ::oPrinter:forms()
  yy := oprintDialog:numCopies

return self


*
** zpracování požadavku tisku **************************************************
METHOD SYS_tiskform_CRD:runPrint(typ)
  LOCAL oDialog, nExit, recno
  local file := ''
  *
  local  oini
  local  offFilter   := if(::isReport, .not. empty(::pb_offFILTER:icon1), .f. )
  local  lstart_worm := .f.
  local  arSelect    := if( isNull(::prevBro), {}, aclone(::prevBro:arSelect))
  local  prevFile    := ::prevFile


  forms ->(DbSeek(upper(frmusers ->cidforms),, 'FORMS01' ))

  if .not. ::isReport  // Zachová se øídící soubor z definice formuláre"
    if( forms->ntypZpr = 11, ::prevFile := forms->cmainFile, nil )
  endif

  *
  if isNull(::prevFile)
    ::prevFile := allTrim(forms->cmainFile)

    if empty(forms->mblockfrm)
       if( select(::prevFile) = 0, drgDBMS:open(::prevFile), nil)
    endif
  endif

  do case
  case(forms->ntypPrint = 1)
    recno := (::prevFile)->( recno())
    file  := alltrim(forms ->cmainfile)

  case ::isReport
    if filtrs ->(DbSeek(upper(fltusers ->cidfilters),, AdsCtag(1) ))
      oini := flt_setcond():new(.f.,.f.)

      if .not. Empty(oini:ft_cond) .or. offFILTER
        file := alltrim(forms ->cmainfile)

        if .not. empty(forms->mblockfrm)
          if substr(upper(file), len(file), 1) = 'W'
/*
JS ?
            if( select(file) <> 0, (file)->(dbcloseArea()), nil)

            if at('::',forms->mblockfrm) = 0 .and. forms->ntypzpr <> 2
              drgDBMS:open(file,.T.,.T.,drgINI:dir_USERfitm); ZAP
            else
              drgDBMS:open(file,.T.,.T.,drgINI:dir_USERfitm)
            endif
*/


            if at('::',forms->mblockfrm) = 0
              if( select(file) <> 0, (file)->(dbcloseArea()), nil)
              drgDBMS:open(file,.T.,.T.,drgINI:dir_USERfitm); ZAP
            else
              if select(file) = 0
                drgDBMS:open(file,.T.,.T.,drgINI:dir_USERfitm)
              endif
            endif

          else
            drgDBMS:open(file)
          endif
        else
          drgDBMS:open(file)
        endif

        if .not. offFILTER
          lstart_worm := .t.
          ::start_worm()

          (file)->(ads_setaof(oini:ft_cond), dbgotop())
        endif

*        if( .not. offFILTER, (file)->(ads_setaof(oini:ft_cond)), nil)
*        (file)->(DbGoTop())

        if (.not. empty(filtrs->mdata) .and. .not. empty(oini:ex_cond))
          oini:relfiltrs(file,oini:ex_cond)
        endif

        if( lstart_worm, ::stop_worm(), nil )
      endif
    endif

  otherwise
    recno := (::prevFile)->( recno())
    ::start_worm()
      ::setFilter()
    ::stop_worm()

    if (prevFile)->( FieldPos('dDatTisk')) > 0
      if( empty(arSelect), aadd( arSelect, (prevFile)->( recNo()) ), nil )

      if (prevFile)->( sx_rLock( arSelect))
        aeval( arSelect, { |x| ( (prevFile)->( dbgoTo(x))      , ;
                                 (prevFile)->dDatTisk := Date()  ) } )

        (prevFile)->( dbUnlock(), dbcommit(), dbgoTo(recNo) )
      endif
    endif
  endcase

  LL_PrintDesign(,typ)

  if ::isReport
    if .not. Empty(file)
      (file) ->(ads_clearaof())

      if( .not. empty(filtrs->mdata) .and. .not. empty(oini:ex_cond) )
        (file)->(dbclearFilter())
      endif
    endif

    ::dctrl:obrowse[3]:oxbp:refreshAll()
  else
    if( .not.Empty(::prevFile), ((::prevFile)->(ads_clearaof(),(::prevFile)->(dbGoTo(recno)))), nil)

    *
    ** bude úprava ll_printDesign vrátí pole is_Printed, is_sendMain
  endif

  *
  ** povolíme tlaèítka
  if( isObject(::pb_runPRV), ::pb_runPRV:enable(), nil )
  if( isObject(::pb_runPRN), ::pb_runPRN:enable(), nil )
  if( isObject(::pb_runSEL), ::pb_runSEL:enable(), nil )
  if( isObject(::pb_runEXP), ::pb_runEXP:enable(), nil )
RETURN self



*  KONTROLA *
** ???? **
METHOD SYS_tiskform_CRD:onSave(parent)
RETURN self

METHOD SYS_tiskform_CRD:delRecTsk()
  local anFlt_u := {}, oDBro := ::drgDialog:dialogCtrl:oBrowse[1]
  *
  ** sestava volaná z nabídky menu, rušíme frmUsers & all in fltUsers
  if ::isReport
    fltUsers->( dbeval( { || aadd( anFlt_u, fltUsers->( recNo()) ) }))
  endif

  if ( frmUsers->( sx_rLock())       .and. ;
       fltUsers->( sx_rLock(anFlt_u))      )

    frmUsers->(dbDelete())
    aeval(anFlt_u, {|x| fltUsers->(dbgoto(x),dbdelete()) })


    ::drgDialog:dataManager:refresh(.T.)

    oDBro:oxbp:up():forceStable()
    oDBro:oxbp:refreshAll()
    postAppEvent(xbeBRW_ItemMarked,,,::dctrl:obrowse[1]:oxbp)
  endif

  frmUsers->(dbunlock(),dbcommit())
   fltUsers->(dbunlock(),dbcommit())
RETURN .F.


METHOD SYS_tiskform_CRD:delRecFlt()
  local oDBro_2 := ::drgDialog:dialogCtrl:oBrowse[2]

  if fltusers->(RLock())
   fltusers->(dbDelete())
   fltusers->(dbUnlock())
  endif

  ::drgDialog:dataManager:refresh(.T.)
  ::verifyActions()

  oDBro_2:oxbp:up():forceStable()
  oDBro_2:oxbp:refreshAll()
  postAppEvent(xbeBRW_ItemMarked,,,::dctrl:obrowse[2]:oxbp)
RETURN .F.


*
** hiden method
** povolí/zakáže akce pro vlastní tisk/view **
method SYS_tiskform_CRD:verifyActions(inPostValidate)
  local  ab, ok, ev, om
  local  p_memos

  default inPostValidate to .F.

  ok := .not. Empty(fltusers ->cidfilters)
  ab := ::drgDialog:oActionBar:members

  if ::isReport
    if ::idflt <> fltusers ->cidfilters .or. Empty(fltusers ->cidfilters)

      ::sys_filtrs:itemMarked()

      ok      := .not. filtritw->(eof())
      ::idflt := fltusers ->cidfilters
    endif
    if( ok, AEval(::aitw, {|s| if( Empty(s), ok := .F., NIL )}), nil)

    * uložíme si nastavení
    if ok .and. fltusers->lfiltrYes
      p_memos := ::build_memos()

      if fltusers->(dbRlock())
        fltusers->mfilterS   := filtrs->mfilterS
        fltusers->mfilterS_u := p_memos[1]
        fltusers->(dbUnlock())
      endif
    endif

//    ok := .not. empty( ::c_obdReport )

  else
    ok := .t.
  endif

  ok := (ok .and. .not. frmusers->(eof()))

  for x := 1 to len(ab) step 1
    if IsCharacter(ab[x]:event) .and. Lower(ab[x]:event) $ 'runprv,runprn,runsel,sep'
      ev := Lower(ab[x]:event)
      om := ab[x]:parent:aMenu

      ab[x]:oXbp:setColorFG(If(ok, GraMakeRGBColor({0,0,0}), GraMakeRGBColor({128,128,128})))
      if(ok, ab[x]:oxbp:enable()  , ab[x]:oxbp:disable())
      ab[x]:frameState := if( ok,1,2)

// SL1      ab[x]:drawFrame()
    endif
  next
return


method sys_tiskform_crd:setFilter()
  local mainFile := lower(alltrim(forms->cmainFile))
  local pos, vyr, pa, x, items, vals, cfce, odesc, m_filtr := "", s_filtr := ""
  local cf := "(", af := {}, av, ctyp
  *
  local arselect  := if( isNull(::prevBro), {}, ::prevBro:arselect)
  local extBlock  := strTran( MemoTran(forms->mblockfrm,chr(0)), ' ', '')
  *
  local cidSysVyk, grpVyber
  local pa_sy
  local pa_grpkey := ::pa_grpkey := {}

  do case
  case  ::ZPUSOBtisku = 'V' .and. .not. empty(arselect)
    aeval(arselect, {|i,n| m_filtr += 'recno() = ' +str(i) + if(n < len(arselect), ' .or. ', '') })
  case  ::ZPUSOBtisku = 'R'
    m_filtr := "recno() = " +str((::prevFile)->(recno()))
  endcase


  if (pos := at(Upper(mainFile) +':',Upper(::prnFiles))) <> 0

    vyr := substr(Upper(::prnFiles),pos)
    if((pos := at(',', vyr)) <> 0, vyr := left(vyr,pos-1), nil)
    vyr := substr(vyr,at(':',vyr)+1)
     pa := listasarray(vyr,'+')

    if lower(mainFile) = 'vykazw' .and. ;
       ( 'vyk_naplnvyk_in' $ lower(extBlock) .or. 'vyk_naplnvyk2_in' $ lower(extBlock) )

      * z FORs
       pos      := at('=',vyr)
      vals      := substr(vyr,pos+1)

      * pokud je vazba a je definovaný extBlock, bereme grpVyber
      if .not. empty( extBlock)
        cidSysVyk := subStr( extBlock, at( '(', extBlock) +1)
        cidSysVyk := upper( strTran( cidSysVyk, ')', '' ))
        cidSysVyk := strTran( cidSysVyk, "'", "" )

        if defVykit->( dbseek( cidSysVyk,,'DEFVYKIT09'))
          if defVyksy->( dbseek( defVykit->cidSysVykN,,'DEFVYKSY03'))
            if .not. empty(grpVyber := allTrim(defVyksy->mGRPvyber))
              vals := grpVyber
              cfce := ''

              if at( ':', grpVyber) <> 0
                pa_sy := listAsArray( grpVyber, ':' )
                 vals := pa_sy[1]
                 cfce := strTran( pa_sy[2], '%%', ::prevFile )
              endif
            endif
          endif
        endif
      endif

      * zjistíme si typ
      if isObject(odesc := drgDBMS:getFieldDesc(::prevFile +'->' +vals))
        ctyp  := odesc:type
        aadd( af, if( empty(cfce), ::prevFile +'->' +vals, cfce ) )
//        aadd(af, ::prevFile +'->' +vals)
      endif

    else

      for x := 1 to len(pa) step 1
        vyr  := pa[x]
        pos  := at('=',vyr)

        item := substr(vyr,1,pos)
        vals := substr(vyr,pos+1)

        * zjistíme si typ
        if     isObject(odesc := drgDBMS:getFieldDesc(::prevFile +'->' +vals))
          ctyp  := odesc:type
          cf += item +if(ctyp = 'N', '%%', "'%%'") +if(x < len(pa), " .and. ", ")")
          aadd(af, ::prevFile +'->' +vals)

        elseif isObject(odesc := drgDBMS:getFieldDesc(mainFile +'->' +vals))
          ctyp  := odesc:type
          cf += item +if(ctyp = 'N', '%%', "'%%'") +if(x < len(pa), " .and. ", ")")
          aadd(af, mainFile +'->' +vals)

        endif
      next
    endif
  endif
  *
  **

  if Filtrs->nCisFiltrs < 0
    (::prevFile)->(dbclearfilter())
    (::prevFile)->(dbsetfilter(COMPILE(m_filtr)),dbgotop())
    do while .not. (::prevFile)->(eof())
      (av := {}, aeval(af,{|x| aadd(av, DBGetVal(x))}))

      aeval(av, {|x| aadd( pa_grpkey, x )} )

      (::prevFile)->(dbskip())
      s_filtr += format(cf,av) +if((::prevFile)->(eof()), '', " .or. ")
    enddo
    (::prevFile)->(dbgotop())

    (mainFile)->(dbclearscope())
    (mainFile)->(dbclearfilter())
    (mainFile)->(dbsetfilter(COMPILE(s_filtr)),dbgotop())
  else
    if .not. Empty( m_filtr)
      (::prevFile)->(ads_clearaof())
      (::prevFile)->(ads_setaof(m_filtr),dbgotop())
      do while .not. (::prevFile)->(eof())
        (av := {}, aeval(af,{|x| aadd(av, DBGetVal(x))}))

        aeval(av, {|x| aadd( pa_grpkey, x )} )

        (::prevFile)->(dbskip())
        if .not. Empty(av)
          s_filtr += format(cf,av) +if((::prevFile)->(eof()), '', " .or. ")
        endif
      enddo
      (::prevFile)->(dbgotop())
    endif

    if .not. Empty( s_filtr)
      *
      ** vykazw
      if lower(mainFile) = 'vykazw'
      else
        (mainFile)->(dbclearscope())
        (mainFile)->(ads_clearaof())
        (mainFile)->(ads_setaof(s_filtr),dbgotop())
      endif
    endif
  endif
return



*
** END of CLASS ****************************************************************
METHOD SYS_tiskform_CRD:destroy()
  local  cfile, arselect

  ::drgUsrClass:destroy()

  *
  if !Empty(::asaved) .and. select('frmusers') <> 0
    RestWorkSpace(::asaved)

    if isObject( ::prevBro )

      * je nastavený filrt pro oznaèené záznamy ?
      if ::prevBro:arfilter
        (::prevBro:cfile) ->( ads_customizeAOF(::prevBro:arselect) )
      endif

      ::prevBro:oXbp:refreshAll()
    endif
  endif

  ::aitw       := ;
  ::msg        := ;
  ::dm         := ;
  ::bro        := ;
  ::dctrl      := ;
  ::pushOk     := ;
  ::prevForm   := ;
  ::prevBro    := ;
  ::prevFile   := ;
  ::prnFiles   := ;
  ::isReport   := ;
  ::selMenuTsk := ;
  ::lnewrec    := NIL
RETURN NIL


*
**
** class SYS_obdReport_SEL *****************************************************
static function setCursorPos( nX, nY)
  DllCall( "user32.dll", DLL_STDCALL, "SetCursorPos", nX, nY)
return nil

static function getWindowPos(o)
   LOCAL nLeft       := 0
   LOCAL nTop        := 0
   LOCAL nRight      := 0
   LOCAL nBottom     := 0
   LOCAL cBuffer     := Space(16)
   LOCAL aObjPosXY   := {nil,nil}

   DllCall("User32.DLL", DLL_STDCALL,"GetWindowRect", o:GetHwnd(), @cBuffer)

   nLeft    := Bin2U(substr(cBuffer,  1, 4))
   nTop     := Bin2U(substr(cBuffer,  5, 4))
   nRight   := Bin2U(substr(cBuffer,  9, 4))
   nBottom  := Bin2U(substr(cBuffer, 13, 4))

   aObjPosXY[1]  := nLeft
   aObjPosXY[2]  := nTop  //AppDeskTop():currentSize()[2] - nBottom
RETURN(aObjPosXY)


class SYS_obdReport_SEL from drgUsrClass
exported:
  method  init, getForm, drgDialogInit, drgDialogStart, drgDialogEnd
  var     lcan_continue


  * bro ucetsys aktuální, stav, aktualizace
  inline access assign method actual_obd() var actual_obd
    return if( ucetsys->cobdobi = uctOBDOBI:UCT:COBDOBI, 300, 0 )

  inline access assign method status_obd() var status_obd
    local retVal := 0
    retVal := if( uceterr->( mh_SEEK( ucetsys->cobdobi, 1, .T. )), 301, ;
              if( ucetsys->lzavren, 302, 0 ))
    return retVal

  inline access assign method update_obd() var update_obd
    local retVal := 0
    retVal := if( ucetsys->naktuc_ks = 1, 316, ;
              if( ucetsys->naktuc_ks = 2, 300, 0))
    return retVal

  inline access assign method report_obd() var report_obd
     local retVal := ''

     do case
     case ::ntypZpr <= 6 .or. ::ntypZpr = 7
       retVal := str(ucetSys->nrok,4) +'/' +str(ucetSys->nobdobi,2)

     case ::ntypZpr = 8 .or. ::ntypZpr = 9
       retVal := str(ucetSys->nrok,4)
     endcase
     return retVal

  inline method post_bro_colourCode()
    local recNo := ucetSys->(recNo()), ;
             pa := ::d_Bro:arselect
    *
    ** povolen pro sestavu výbìr N ... obdobi
    if ::can_selObdRep
      if (npos := ascan(pa, recNo)) = 0
         aadd(pa, recNo)
      else
         Aremove(pa, npos )
       endif
       ::d_Bro:arselect := pa
       postAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_NextLine,, ::d_Bro:oxbp )
    endif
    return .t.   /// øešení na BRO není povoleno ok

  inline method mark_record()
    postAppEvent( xbeP_Keyboard, xbeK_CTRL_ENTER,,::d_bro:oXbp)
    return self

  inline method save_marked()
    ::recordSelected()
    return self

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  apos_pb, asize_pb, apos


    do case
    case nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_DELETE
      return .t.

    case nEvent = drgEVENT_EDIT
      _clearEventLoop()
      ::drgDialog:oform:setNextFocus(::opb_save_Marked,.t.,.t.)

       apos_pb  := getWindowPos( ::opb_save_Marked:oxbp )
       asize_pb := ::opb_save_Marked:oxbp:currentSize()
       apos     := { apos_pb[1] +asize_pb[1]/2, apos_pb[2] +asize_pb[2]/2 }

       setCursorPos( apos[1], apos[2] )
       setAppFocus( ::opb_save_Marked:oxbp )
      return .f.
    otherwise

      return .f.
    endcase
  return .f.


hidden:
  var  d_Bro, can_selObdRep, opb_save_Marked
  var  drgGet, culoha, ntypZpr

  inline method recordSelected()
    local pa := ::d_Bro:arselect, x
    *
    ** povolen pro sestavu výbìr N ... obdobi
    if ::can_selObdRep
      if len(pa) <> 0
        obdReport := ''

        for x := 1 to len(pa) step 1
          ucetSys->( dbgoTo(pa[x]))
          obdReport += strZero(ucetsys->nobdobi,2) +'/' +strZero(ucetsys->nrok,4) + ;
                       if( x = len(pa), '', ',' )
        next
      else
        obdReport := strZero(ucetsys->nobdobi,2) +'/' +strZero(ucetsys->nrok,4)
      endif
    else
      obdReport := strZero(ucetsys->nobdobi,2) +'/' +strZero(ucetsys->nrok,4)
    endif

    ::lcan_continue := .t.
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self
endclass


method SYS_obdReport_SEL:init(parent)
  local  nEvent,mp1,mp2,oXbp
  local  ctask, filter
  local  pa_Val  := {}, npos, arSelect := {}

  ::ntypZpr       := forms->ntypZpr // 6 - 7 výbìr odbobí  8 - 9 výbìr roku tj. nabízem posední období roku
  ::lcan_continue := .f.

  drgDBMS:open('ucetsys')
  drgDBMS:open('ucetsys',,,,,'ucetsys_Y')

  drgDBMS:open('uceterr')
  drgDBMS:open('c_task' )

  ctask           := allTrim(upper(forms->ctask))

  c_task->( dbseek( ctask,,'C_TASK01'))
  ::culoha        := allTrim(c_task->culoha)
  ::can_selObdRep := ( asystem->nselObdRep = 1 )

  cfilter := format("culoha = '%%'", {::culoha} )

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  endif

  ::drgUsrClass:init(parent)

  c_task ->(dbseek( ctask,,'C_TASK01'))

  do case
  case ::ntypZpr = 6 .or. ::ntypZpr = 7
    ucetsys->( ads_setAof( cfilter), dbgotop())

  case ::ntypZpr = 8 .or. ::ntypZpr = 9
    ucetsys_Y->( ordSetFocus('UCETSYS3'), ads_setAof( cfilter), dbgotop())

    do while .not.  ucetsys_Y->(eof())
      if( npos := ascan( pa_Val, {|x| x[1] = ucetsys_Y->nrok})) = 0
        aadd( pa_Val, { ucetsys_Y->nrok, ucetsys_Y->nobdobi, ucetsys_Y->(recNo()) } )

      else
        if pa_Val[npos,2] < ucetsys_Y->nobdobi
          pa_Val[npos,2] := ucetsys_Y->nobdobi
          pa_Val[npos,3] := ucetsys_Y->( recNo())
        endif
      endif
      ucetsys_Y->( dbskip())
    enddo
    ucetsys_Y->( ads_clearAof())
    aeval( pa_Val, { |x| aadd( arSelect, x[3]) })

    ucetsys->( ads_setAof('.F.'), ads_customizeAof(arSelect), dbgoTop())
  endcase
return self


method SYS_obdReport_SEL:getForm()
  local  oDrg, drgFC
  local  nsize := if( ::can_selObdRep, 68, 83 )

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 83,17 DTYPE '10' TITLE '' FILE 'UCETSYS' GUILOOK 'All:N,Border:Y' BORDER 4

  DRGSTATIC INTO drgFC FPOS 0,0 SIZE nsize,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX
    DRGTEXT INTO drgFC CAPTION 'Výbìr období pro tisky [' +allTrim(c_task->cnazUlohy) +']' CPOS  2,.1 CLEN 75 FONT 5
  DRGEND  INTO drgFC

  DRGDBROWSE INTO drgFC FPOS 0,1.3 SIZE 83,13.8 FILE 'UCETSYS'       ;
                        FIELDS 'M->actual_obd:_:2.7::2,'           + ;
                               'M->status_obd:e:2.7::2,'           + ;
                               'M->update_obd:a:2.7::2,'           + ;
                               'M->report_obd:rok/obd:8,'          + ;
                               'UCT_ucetsys_BC(4):ÚÈTOVAL:32,'     + ;
                               'UCT_ucetsys_BC(5):AKTUALIZOVAL:32'   ;
                        INDEXORD 3 SCROLL 'ny' CURSORMODE 3 PP 7  POPUPMENU 'y'


  if ::can_selObdRep
    DRGPUSHBUTTON INTO drgFC CAPTION '  ~Výbìr'  ;
                             POS 68,.2           ;
                             SIZE 15,1.1         ;
                             ATYPE 3             ;
                             ICON1 427           ;
                             ICON2 428           ;
                             EVENT 'mark_record' TIPTEXT 'Oznaèí/zruší oznaèení období pro zpracování ...'
  endif

  DRGPUSHBUTTON INTO drgFC CAPTION '   ~Ok'    ;
                           POS 51,15.5         ;
                           SIZE 15,1.1         ;
                           ATYPE 3             ;
                           ICON1 429           ;
                           ICON2 430           ;
                           EVENT 'save_marked' TIPTEXT 'Pøevzít oznaèené/á období pro zpracování ...'


  DRGPUSHBUTTON INTO drgFC CAPTION '   ~Storno' ;
                           POS 67,15.5          ;
                           SIZE 15,1.1          ;
                           ATYPE 3              ;
                           ICON1 102            ;
                           ICON2 202            ;
                           EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'

return drgFC


method SYS_obdReport_SEL:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*  XbpDialog:titleBar := .F.

  drgDialog:dialog:minButton := .f.
  drgDialog:dialog:maxButton := .f.

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
*    drgDialog:usrPos := {aPos[1],aPos[2]}
  endif
return


method SYS_obdReport_SEL:drgDialogStart(drgDialog)
  local  x, members := drgDialog:oForm:aMembers
  local  cKy := ::culoha +subStr(obdReport,4) +left(obdReport,2)

  brow    := drgDialog:dialogCtrl:oBrowse[1]
  ::d_Bro := brow

  for x := 1 to len(members) step 1
    if members[x]:classname() = 'drgPushButton'
      if isCharacter( members[x]:event )
        if( members[x]:event = 'save_marked', ::opb_save_Marked := members[x], nil)
      endif
    endif
  next

  ucetsys->(dbSeek( cKy,,'UCETSYS3'))
  brow:oXbp:refreshAll()
return self


method SYS_obdReport_sel:drgDialogEnd()

  ucetsys->(ads_clearAof())
return self