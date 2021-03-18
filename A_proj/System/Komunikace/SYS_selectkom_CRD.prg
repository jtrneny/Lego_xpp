#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "dmlb.ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


static function SaveWorkarea()
return  { { Alias(Select())            ,{|x|   DbSelectArea(x)         } }, ;
          { OrdSetFocus()              ,{|x|   AdsSetOrder(x)          } }, ;
          { ads_getaof()               ,{|x|   ads_setaof(x)           } }, ;
          { dbrselect(1), dbrelation(1),{|x,y| sys_relation_crd(x,y)   } }, ;
          { Recno()                    ,{|x|   Dbgoto(x)               } }  }


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

            if y = 5                 // dbgoto nesmíme se snažit postavit na zrušený záznam
              do case
              case (cfile)->(deleted())
                (cfile)->(dbskip())
                pb[1] := (cfile)->(recNo())
                
              case pb[1] > (cfile)->(lastRec())
                (cfile)->(DbGoBottom())
                pb[1] := (cfile)->(recNo())
              endcase
            endif

            (cfile)->( eval( pb[2], pb[1]))
          else
            (cfile)->( eval( pb[3], pb[1], pb[2]))
          endif
        endif
      next
    endif
  next
return .t.


static function sys_relation_crd(warea,cblock)
  dbsetrelation(warea,COMPILE(cblock))
return .t.


*
** CLASS for SYS_tiskform_crd **************************************************
CLASS SYS_selectkom_CRD FROM drgUsrClass, sys_filtrs
EXPORTED:
  *
  ** název promìnné pro sekci komunikace + vazba na okolí pøi volání ASys_Komunik(typ,::drgdialog)
  var     csection, mDefin_kom, odata

  var     idflt, ZPUSOBdatkom

  METHOD  init, getForm, drgDialogStart, preValidate, postValidate
  METHOD  all_itemMarked
  METHOD  selDatKom, selFiltrs
  *
  METHOD  offFILTER
  METHOD  runCOMM, sel_datkomhd_usr
  *
  METHOD  onSave, delRecKom, delRecFlt
  *
  METHOD  destroy
  method  ebro_saveEditRow


  * BRO column indikuje vazbu na období pro vytváøení TMP podkladù
  inline access assign method is_obdDatKom() var is_obdDatKom
    local  retVal := 0, npos, cblock

    if datkomhd->(dbSeek(upper(komusers->ciddatkom),, AdsCtag(1) ))
      if .not. empty(datkomhd->mdata_kom)
        cblock := upper(allTrim(datkomhd->mdata_kom))
        if(npos := at('(',cblock)) <> 0
          cblock := subStr(cblock, 1, npos-1)
        endif

        asystem->(dbSeek(cblock,, AdsCtag(1) ))

        retVal := if(asystem->lobdReport,  MIS_EDIT, 0)
      endif
    endif
    return retVal

  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc      := ::drgDialog:dialogCtrl
    LOCAL  lastXbp := ::drgDialog:lastXbpInFocus
    LOCAL  tmIns   := .F.
    LOCAL  fileTm

    do case
    case nEvent = xbeBRW_ItemMarked
      ::enableOrDisable_Action()
      return .f.

    CASE nEvent = drgEVENT_DELETE
      if oXbp:ClassName() = 'XbpBrowse'
        if drgIsYESNO(drgNLS:msg('Delete record!;;Are you sure?'))
          if( oXbp:cargo:cfile = 'KOMUSERS', ::delRecKom(), NIL)
          if( oXbp:cargo:cfile = 'FLTUSERS', ::delRecFlt(), NIL)
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
    local  editSize, state, text, task := 'UCT'
    local  pos := AClone(drgDialog:dataAreaSize)

    editSize := 24 +13*drgINI:fontW
    pos[1]   -= editSize +1
    pos[2]   := 21
    state    := DRG_ICON_EDIT
    text     := '  ' +task +' ' +obdReport

    ::ib:addAction({pos[1],1},{editSize,pos[2]},3,state,state,,text,,NIL,.F.)

    ::push_obd         := atail(::ib:members)
    ::push_obd:event   := 'obdReport_sel'
    ::push_obd:tipText := 'Nastavené období pro komunikaci'
    *
    ::push_obd:oXbp:setFont(drgPP:getFont(5))
    ::push_obd:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
  return .t.


  inline method obdDatKom_sel(drgDialog)
    local  odialog, nexit
    local  old_obdDatKom := obdDatKom
    *
    DRGDIALOG FORM 'sys_obdDatKom_sel' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

    if( old_obdDatKom <> obdDatKom, ::push_obd:oText:setCaption('  UCT ' +obdReport), nil)
  return .t.

HIDDEN:
  VAR     msg, dm, bro, dctrl, ib, ab, pushOk, noedit_get
  VAR     prevForm, prevBro, prevFile, comFiles
  VAR     isReport, selMenuCom, lnewrec
  *
  var     asaved, push_obd
  var     pb_offFILTER
  var     obtn_runComm, obtn_sel_datkomhd_usr

  * pro parametry datové komunikace
  var     tmp_Dir

  METHOD  verifyActions, setFilter

  inline method enableOrDisable_Action()
    local mDefin_kom, oicon := XbpIcon():new():create()

    datkomhd ->(DbSeek(upper(komusers ->ciddatkom),, AdsCtag(1) ))
    mDefin_kom := datKomhd->mdefin_kom

    if isObject(::obtn_runComm) .and. isObject(::obtn_sel_datkomhd_usr)

      if empty(mDefin_kom)
        oicon:load( nil, gDRG_ICON_QUIT)

        ::obtn_sel_datkomhd_usr:disable()
        ::obtn_sel_datkomhd_usr:oxbp:setImage( oicon )
      else
        if( empty(komUsers->mDefin_kom), ::obtn_runComm:oxbp:disable(), ;
                                         ::obtn_runComm:oxbp:enable()   )

        oicon:load( NIL, if( empty(komUsers->mDefin_kom), MIS_ICON_ATTENTION, MIS_ICON_CHECK ))

        ::obtn_sel_datkomhd_usr:enable()
        ::obtn_sel_datkomhd_usr:oxbp:setImage( oicon )
      endif

    endif
  return self
ENDCLASS


METHOD SYS_selectkom_CRD:init(parent)
  local  asaved := ::asaved := {}

  if empty(obdReport)
    obdReport := strZero(uctOBDOBI:UCT:nobdobi,2) +'/' +strZero(uctOBDOBI:UCT:nrok,4)
  endif

  ::drgUsrClass:init(parent)
  ::lnewrec    := .F.
  ::idflt      := ''
  ::noedit_get := {}
  ::tmp_Dir    := drgINI:dir_USERfitm +userWorkDir() +'\'

  WorkSpaceEval( {|| aadd( asaved, SaveWorkarea() ) } )

  drgDBMS:open('KOMUSERS')
  drgDBMS:open('FLTUSERS')
  drgDBMS:open('FILTRS'  )
  drgDBMS:open('DATKOMHD'   )
  drgDBMS:open('ASYSTEM' )
  *
  * tady nevím jestli zap *
  drgDBMS:open('FILTRITw',.T.,.T.,drgINI:dir_USERfitm);ZAP
RETURN self


METHOD SYS_selectkom_CRD:getForm()
  LOCAL drgFC := drgFormContainer():new(), oDrg, _drgEBrowse

  ::isReport := (::drgDialog:parent:formName == "drgMenu")

  if ::isReport
    * sestava volaná z nabídky menu *

    ::selMenuCom := drgParse(drgParseSecond(::drgDialog:initParam))

    DRGFORM INTO drgFC SIZE 115,23 DTYPE '10' TITLE 'Uživatelská komunikace' ;
                       GUILOOK 'All:Y,Border:Y,Action:Y';
                       PRE 'preValidate' POST 'postValidate'

    * Browser _komusers
    DRGEBROWSE INTO drgFC FPOS 0.5,0.05 SIZE 61,12.1 FILE 'KOMUSERS'      ;
               ITEMMARKED 'all_itemMarked' SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'ny'
      _drgEBrowse := oDrg

      DRGTEXT INTO drgFC NAME M->is_obdDatKom       CLEN  2  CAPTION ''
      oDrg:isbit_map := .t.

      DRGGET  komusers->cnadatkom INTO drgFC       FLEN 48 FCAPTION 'Název komunikace'
      oDrg:push         := 'selDatKom'
      oDrg:isedit_inrev := .f.
      DRGTEXT INTO drgFC NAME komusers->ciddatkom   CLEN 12  CAPTION 'id'

      _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC


    * Browser _fltusers
    DRGEBROWSE INTO drgFC FPOS 61.9,0.05 SIZE 52.7,10.9 FILE 'FLTUSERS'   ;
               ITEMMARKED 'all_itemMarked' SCROLL 'ny' CURSORMODE 3 PP 7 GUILOOK 'enter:n' RESIZE 'yy'
      _drgEBrowse := oDrg

      DRGGET  fltusers->cfltName INTO drgFC        FPOS 1,0 FLEN 50 FCAPTION 'Název filtru'
      oDrg:push := 'selFiltrs'
      DRGTEXT INTO drgFC NAME fltusers->cidFilters CPOS 2,0 CLEN 12  CAPTION 'id'

      _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC

    * Browser _filtritw
    DRGEBROWSE INTO drgFC FPOS 0.05,12.2 SIZE 114.5,10.6 FILE 'FILTRITw'             ;
             SCROLL 'ny' ITEMMARKED 'all_itemMarked' CURSORMODE 3 PP 7 GUILOOK 'ins:n,del:n,sizecols:n,headmove:n' RESIZE 'yn'
      _drgEBrowse := oDrg

      DRGTEXT INTO drgFC NAME filtritW->clgate_1  CLEN  2 CAPTION  '('
      DRGTEXT INTO drgFC NAME filtritW->clgate_2  CLEN  2 CAPTION  '('
      DRGTEXT INTO drgFC NAME filtritW->clgate_3  CLEN  2 CAPTION  '('
      DRGTEXT INTO drgFC NAME filtritW->clgate_4  CLEN  2 CAPTION  '('

      DRGTEXT INTO drgFC NAME filtritW->cfile_1   CLEN  9   CAPTION  'table'

      DRGTEXT INTO drgFC NAME filtritW->cvyraz_1u CLEN 33 CAPTION  'výraz-L'
      DRGTEXT INTO drgFC NAME filtritW->crelace   CLEN  6 CAPTION  'oper'
      DRGGET  filtritW->cvyraz_2u INTO drgFC      CLEN 32 FCAPTION 'výraz-P'

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
                       POS 61.8,11.10                                  ;
                       SIZE 35,1 ATYPE 3 ICON1 0 ICON2 0              ;
                       EVENT 'offFILTER'                               ;
                       TIPTEXT 'Nefiltrovat tiskovou setavu ...'
  else

    * formuláø volaný z formuláøe *

    DRGFORM INTO drgFC SIZE 58.2,20 DTYPE '10' TITLE 'Uživatelská komunikace' ;
                       GUILOOK 'All:Y,Border:Y,Action:Y';
                       PRE 'preValidate' POST 'postValidate'

    * Browser _komusers
    DRGEBROWSE INTO drgFC FPOS 0.5,0.05 SIZE 57.6,19.8 FILE 'KOMUSERS'  ;
               ITEMMARKED 'itemMarked' SCROLL 'ny' CURSORMODE 3 PP 3
      _drgEBrowse := oDrg

      DRGGET  komusers->cnazdatkom INTO drgFC       FPOS 1,0 FLEN 48 FCAPTION 'Název komunikace'
      oDrg:push         := 'selDatKom'
      oDrg:isedit_inrev := .f.
      DRGTEXT INTO drgFC NAME komusers->ciddatkom CPOS 2,0 CLEN 15  CAPTION 'id'

      _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC

    DRGTEXT INTO drgFC CAPTION 'Zpracovat ...' CPOS 0,15 CLEN 12 BGND 9
    DRGRadioButton M->ZPUSOBdatkom INTO drgFC FPOS 0,16.5 SIZE 18,3 ;
                   VALUES 'Z:záznam,'  + ;
                          'V:výbìr,'   + ;
                          'A:vše'
  endif

  DRGAction INTO drgFC CAPTION 'Komunikace'      EVENT 'runCOMM'          TIPTEXT 'Export a import dat'

  DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
  DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
  DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
  DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
  DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
  DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
  DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
  DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
  DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5
  DRGAction INTO drgFC CAPTION      ''           EVENT 'sep' ATYPE 5

  DRGAction INTO drgFC CAPTION '     p~Arametry' EVENT 'sel_datkomhd_usr' ;
                                                 TIPTEXT 'Nastavení parametrù komunikace'
RETURN drgFC


METHOD SYS_selectkom_CRD:drgDialogStart(drgDialog)
  LOCAL  members, x, filtr, asize_G, asize, capt
  local  ardef, lastRec

  ::sys_filtrs:init(drgDialog)
  *
  ::prevForm := drgDialog:parent
  members    := ::prevForm:oForm:aMembers
  BEGIN SEQUENCE
    for x := 1 TO len(members)
      if 'browse' $ lower(members[x]:className())
        ::prevBro  := members[x]
        ::prevFile := ::prevBro:cFile
  BREAK
      endif
    next
  END SEQUENCE

  *
  ::msg      := drgDialog:oMessageBar
  ::dm       := drgDialog:dataManager
  ::dctrl    := drgDialog:dialogCtrl
  ::ib       := drgDialog:oIconBar                // iconBar
  if isobject(drgDialog:oActionBar)
    ::ab      := drgDialog:oActionBar:members    // actionBar
  endif

  ::prevForm := drgDialog:parent
  ::comFiles := drgDialog:parent:formHeader:comFiles
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

  if isArray(::ab)
    for x := 1 to len(::ab) step 1
      ev := lower( isNull( ::ab[x]:event, ''))

      if     ev = 'runcomm'          ; ::obtn_runComm          := ::ab[x]
      elseif ev = 'sel_datkomhd_usr' ; ::obtn_sel_datkomhd_usr := ::ab[x]
      endif
    next
  endif

  *
  ** volba zpracování pro tisk z formuláøe
  if .not. ::isReport
    members[5]:oxbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
    members[5]:oBord:setParent(drgDialog:oActionBar:oBord)

    for x := 1 to len(members[6]:members) step 1
      oxbp := members[6]:members[x]

      do case
      case( x = 1 )  ;  if( len(::prevBro:arselect)  = 0 .and. .not.::prevBro:is_selAllRec, ::ZPUSOBdatkom := 'R', nil)
      case( x = 2 )  ;  if( len(::prevBro:arselect) <> 0, ::ZPUSOBdatkom := 'V', nil)
      case( x = 3 )
        if ::prevBro:is_selAllRec
          oxbp:setCaption('vše_' +strTran(str((::prevFile)->(lastRec())),' ','') +'')
          ::ZPUSOBdatkom := 'A'
        endif
      endcase

      oxbp:parent:setParent(drgDialog:oActionBar:oBord)
    next
  endif

  filtr := Format("cUser = '%%' .and. cCallForm = '%%'", ;
                  {    usrName,if(::isReport,::selMenuCom,::prevForm:formName)})
  komusers ->( ads_setaof(filtr),DbGoTop())
  ::dctrl:oBrowse[1]:refresh(.t.)

  * needitaèní gety
  ardef := drgDialog:odbrowse[1]:ardef
  for x := 1 to len(ardef) step 1
    if lower(ardef[x].defName) = 'komusers->cnadatkom'
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
    asize_G      := drgDialog:dialogCtrl:obrowse[2]:obord:currentSize()

    ::pb_offFilter := atail(members)
    asize          := ::pb_offFilter:oxbp:currentSize()
    ::pb_offFilter:oxbp:setSize({asize_G[1], asize[2]})

    asize          := ::pb_offFilter:otext:currentSize()
    ::pb_offFilter:otext:setSize({asize_G[1] -16, asize[2]})

    capt           := ::pb_offFILTER:otext:caption
    ::pb_offFILTER:otext:setCaption( padC(capt,75) )

    ::push_obd(drgDialog)
  endif
RETURN self


METHOD SYS_selectkom_CRD:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  *
  local  lOk := .T., odesc

  do case
  case file = 'fltusers'
    if komusers->(eof())
      ::msg:writeMessage('Nelze nastavit filtr, pokud není vybrána žádná sestava ...',DRG_MSG_ERROR)
      lok := .f.
    endif

  case file = 'filtritw'
    if filtritw->(eof())
      ::msg:writeMessage('Nelze zadat hodnoty pro výbìr, pokud není vybrán žádný filtr ...',DRG_MSG_ERROR)
      lok := .f.
    endif
  endcase

  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    lOk   := (at('->',filtritw ->cvyraz_2) = 0)
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


method sys_selectkom_crd:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()


  do case
  case(file = 'komusers')
    ok := if( item = 'cnadatkom', ::selDatKom(), .t.)

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
METHOD SYS_selectkom_CRD:all_itemMarked()
  local  file, filtr

  local  offFILTER := if(::isReport, (::pb_offFILTER:oIcon:caption <> 0), .f.)

  if isObject(::dctrl:oaBrowse)
    file  := Lower(::dctrl:oaBrowse:cFile)

    do case
    case file = 'komusers'
      if ::isReport

        fltusers->(ads_clearaof())
        filtr := Format("cUser = '%%' .and. cCallForm = '%%' .and. cIDdatkom = '%%'", ;
                          { usrName, komusers->ccallform, komusers->cIDdatkom})
        fltusers->(ads_setaof(filtr), DBGoTop())

        if( ::is_obdReport = 0, ::push_obd:oxbp:hide(), ::push_obd:oxbp:show() )
      endif

    case file = 'filtritw' .and. offFILTER
      postAppEvent(XBPBRW_Navigate_GoTop,,,::dctrl:obrowse[3]:oxbp)
    endcase

    if( offFILTER, ::offFILTER(), nil)

    ::verifyActions()

    if( offFILTER, ::dctrl:obrowse[3]:oxbp:refreshAll(), nil)
  endif

  if ::isReport
    if komusers->(eof())
      ::pb_offFILTER:oIcon:setCaption(0)
      ::pb_offFILTER:otext:disable()
      ::pb_offFILTER:disable()
    else
      ::pb_offFILTER:otext:enable()
      ::pb_offFILTER:enable()
    endif
  endif
RETURN NIL


*
** možnost zapnout / vypnout filtr u sestav
method sys_selectkom_crd:offFILTER()
  local  x, ok := .t., ab := ::ab

  if ::pb_offFILTER:oIcon:caption = 0

    ::pb_offFILTER:oIcon:setCaption(MIS_ICON_ATTENTION)

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
      if IsCharacter(ab[x]:event) .and. Lower(ab[x]:event) $ 'runcomm,runprn,runsel'
        ev := Lower(ab[x]:event)
        om := ab[x]:parent:aMenu

        ab[x]:oXbp:setColorFG(If(ok, GraMakeRGBColor({0,0,0}), GraMakeRGBColor({128,128,128})))
        if(ok, ab[x]:enable()  , ab[x]:disable())
        ab[x]:frameState := if( ok,1,2)

        ab[x]:drawFrame()

      endif
    next

  else
    ::pb_offFILTER:oIcon:setCaption(0)

    ::pb_offFILTER:oxbp:setFont(drgPP:getFont(1))
    ::pb_offFILTER:oxbp:setColorFG(GRA_CLR_FALSE)

    ::idflt := ''
    postAppEvent(xbeBRW_ItemMarked,,,::dctrl:obrowse[2]:oxbp)
  endif
return self


*
** pøevzetí záznamu z DATKOMHD -> KOMUSERS **
METHOD SYS_selectkom_CRD:selDatKom(drgDialog)
  local  oDialog, nExit
  local  value, ok := .t., keyFRM
  *
  local  nlen   := datkomhd->(FieldInfo(datkomhd->(FieldPos('cmainfile')),FLD_LEN))
  local  filter := '', comFiles

  keyFRM := Padr( Upper( usrName), 10)                                           ;
             +Padr(Upper(IF( ::isReport, ::selMenuCom, ::prevForm:formName)),50) ;
              +',' +if( ::isReport,'A','N')

  value := padr(::dm:get('komusers->cnazdatkom'),50) +padr(::dm:get('komusers->ciddatkom'),10)
  ok    := datkomhd->(dbseek( upper(value),,'DATKOMH07'))
  ok    := (ok .and. (('[EXPORT]' $ datkomhd->mdefin_kom).or.('[IMPORT]' $ datkomhd->mdefin_kom)))

  if ::isReport
  else
    if .not. empty( ::comFiles)
      aeval(listasarray( ::comFiles), ;
           {|X| filter += " .or. lower(cmainfile) = '" +padr(substr(x,1,at(':',x)-1),nlen) +"'"})
      filter := SubStr( filter,7)
      filter := "(" +filter +")  .and. "
      filter := lower(filter)

      ok := ok .and. (lower(datkomhd->cmainFile) $ filter)
    else
      * není nadefinavaná sekce vezmem iplicitnì 1 - øídící soubor
      if empty( ::comFiles ) .and. .not. empty( ::prevFile )
        filter := "( lower(cmainfile) = '" +lower( ::prevFile ) +"') .and. "
      endif
    endif
  endif

  if  isObject(drgDialog) .or. .not. ok
    filter += "ndefin_kom = 1"
    datkomhd->(ads_setAof(filter))

    DRGDIALOG FORM 'SYS_komunikace_SEL,' + keyFRM PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif


  if nExit != drgEVENT_QUIT .or. ok
    ::dm:set('komusers->cnazdatkom', datkomhd->cnazdatkom)
    ::dm:set('komusers->ciddatkom', datkomhd->ciddatkom )
    ok := .t.
  endif

  datkomhd->(ads_clearAof())
RETURN ok


*
** pøevzetí záznamu z FILTRS -> FLTUSERS **
METHOD SYS_selectkom_CRD:selFiltrs(drgDialog)
  local  oDialog, nExit
  *
  local  value, ok := .t.

  if ::isReport
    ** u sestav by mìl mít možnost vybrat jen z filtrù pro datcomhd->cmainfile **
    if datkomhd ->(DbSeek(upper(komusers->ciddatkom),, AdsCtag(1) ))
       filtrs ->(ads_setaof("Upper(cmainfile) = '" +Upper(datkomhd->cmainfile) +"'"), DbGoTop())

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


method sys_selectkom_crd:ebro_saveEditRow(parent)
  local  cfile := lower(parent:cfile)

  do case
  case (cfile = 'komusers')
    komusers->cuser      := usrName
    komusers->ciddatkom  := datkomhd->ciddatkom
    komUsers->mDefin_org := datKomhd->mDefin_kom
    komusers->ccallform  := IF( ::isReport, ::selMenuCom, ::prevForm:formName)

  case (cfile = 'fltusers')
    fltusers ->cuser      := usrName
    fltusers ->ccallform  := komusers->ccallform
    fltusers ->ciddatkom  := komusers->ciddatkom
    fltusers ->cidfilters := filtrs ->cidfilters
  endcase
return


*  KONTROLA *
** ???? **
METHOD SYS_selectkom_CRD:onSave(parent)
RETURN self

METHOD SYS_selectkom_CRD:delRecKom()

  if( komusers->(RLock()), komusers->(dbDelete()), NIL)

  ::drgDialog:dataManager:refresh(.T.)
  ::drgDialog:dialogCtrl:oBrowse[1]:refresh(.T.)

  postAppEvent(xbeBRW_ItemMarked,,,::dctrl:obrowse[1]:oxbp)
RETURN .F.

METHOD SYS_selectkom_CRD:delRecFlt()

  if( fltusers->(RLock()), fltusers->(dbDelete()), NIL)

  ::drgDialog:dataManager:refresh(.T.)
  ::verifyActions()
  ::drgDialog:dialogCtrl:oBrowse[2]:refresh(.T.)
  ::drgDialog:dialogCtrl:oBrowse[3]:refresh(.T.)

  postAppEvent(xbeBRW_ItemMarked,,,::dctrl:obrowse[2]:oxbp)
RETURN .F.


*
** hiden method
** povolí/zakáže akce pro vlastní tisk/view **
method SYS_selectkom_CRD:verifyActions(inPostValidate)
  local  ab, ok, ev, om

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
  else
    ok := .t.
  endif

  ok := (ok .and. .not. komusers->(eof()))

  for x := 1 to len(ab) step 1
    if IsCharacter(ab[x]:event) .and. Lower(ab[x]:event) $ 'runcomm,runprn,runsel,sep'
      ev := Lower(ab[x]:event)
      om := ab[x]:parent:aMenu

      ab[x]:oXbp:setColorFG(If(ok, GraMakeRGBColor({0,0,0}), GraMakeRGBColor({128,128,128})))
      if(ok, ab[x]:enable()  , ab[x]:disable())
      ab[x]:frameState := if( ok,1,2)

      ab[x]:drawFrame()
    endif
  next
return


method sys_selectkom_crd:setFilter()
  local mainFile := lower(alltrim(datkomhd->cmainFile))
  local pos, vyr, pa, x, items, vals, odesc, m_filtr := "", s_filtr := ""
  local cf := "(", af := {}, av, ctyp
  *
  local arselect := if( isNull(::prevBro), {}, ::prevBro:arselect)

  do case
  case  ::ZPUSOBdatkom = 'V' .and. .not. empty(arselect)
    aeval(arselect, {|i,n| m_filtr += 'recno() = ' +str(i) + if(n < len(arselect), ' .or. ', '') })
  case  ::ZPUSOBdatkom = 'R'
    m_filtr := "recno() = " +str((::prevFile)->(recno()))
  endcase

//  if .not. Equal(Upper(mainFile),Upper(::prevFile))
    if (pos := at(Upper(mainFile) +':',Upper(::comFiles))) <> 0
      vyr := substr(Upper(::comFiles),pos)
      if((pos := at(',', vyr)) <> 0, vyr := left(vyr,pos-1), nil)
      vyr := substr(vyr,at(':',vyr)+1)

      pa := listasarray(vyr,'+')

      for x := 1 to len(pa) step 1
        vyr  := pa[x]
        pos  := at('=',vyr)

        item := substr(vyr,1,pos)
        vals := substr(vyr,pos+1)

        * zjistíme si typ
        if isObject(odesc := drgDBMS:getFieldDesc(::prevFile +'->' +vals))
          ctyp  := odesc:type
          cf += item +if(ctyp = 'N', '%%', "'%%'") +if(x < len(pa), " .and. ", ")")
          aadd(af, ::prevFile +'->' +vals)
        endif
      next
    endif
//  endif
  *
  **

  if Filtrs->nCisFiltrs < 0
    (::prevFile)->(dbclearfilter())
    (::prevFile)->(dbsetfilter(COMPILE(m_filtr)),dbgotop())
    do while .not. (::prevFile)->(eof())
     (av := {}, aeval(af,{|x| aadd(av, DBGetVal(x))}))

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

        (::prevFile)->(dbskip())
        if .not. Empty(av)
          s_filtr += format(cf,av) +if((::prevFile)->(eof()), '', " .or. ")
        endif
      enddo
      (::prevFile)->(dbgotop())
    endif

    if .not. Empty( s_filtr)
      (mainFile)->(dbclearscope())
      (mainFile)->(ads_clearaof())
      (mainFile)->(ads_setaof(s_filtr),dbgotop())
    endif
  endif

return


*
** zpracování požadavku komunikace **************************************************
METHOD SYS_selectkom_CRD:runComm(typ)
  LOCAL oDialog, nExit, recno
  local file := ''
  *
  local  oini
  local  offFILTER := if(::isReport, (::pb_offFILTER:oIcon:caption <> 0), .f.)
  *
  ** pro ASys_Komunik(typ,::drgdialog)
  local  pa_mDatkom_us := {}, x, pa, pa_items := {}, pa_data := {}, oClass

  datkomhd ->(DbSeek(upper(komusers ->ciddatkom),, AdsCtag(1) ))
  *
  if isNull(::prevFile)
    ::prevFile := allTrim(datkomhd->cmainFile)

    if empty(datkomhd->mBlockKom)
       if( select(::prevFile) = 0, drgDBMS:open(::prevFile), nil)
    endif
  endif

  do case
  case ::isReport
    if filtrs ->(DbSeek(upper(komusers ->cidfilters),, AdsCtag(1) ))
      oini := flt_setcond():new(.f.,.f.)

      if .not. Empty(oini:ft_cond) .or. offFILTER
        file := alltrim(datkomhd ->cmainfile)
        if .not. empty(datkomhd->mdefin_kom)

          if substr(upper(file), len(file), 1) = 'W'
             if at('::',datkomhd->mdefin_kom) = 0

               if( select(file) <> 0, (file)->(dbcloseArea()), nil)
               drgDBMS:open(file,.T.,.T.,drgINI:dir_USERfitm); ZAP

             endif
          else
            drgDBMS:open(file)
          endif
        else
          drgDBMS:open(file)
        endif

        if( .not. offFILTER, (file)->(ads_setaof(oini:ft_cond)), nil)
        (file)->(DbGoTop())

        if (.not. empty(filtrs->mdata) .and. .not. empty(oini:ex_cond))
          oini:relfiltrs(file,oini:ex_cond)
        endif
      endif
    endif

  otherwise
    recno := (::prevFile)->( recno())
    ::setFilter()
    if (::prevFile)->( FieldPos('dDatTisk')) > 0
      if (::prevFile)->( dbRlock())
       (::prevFile)->dDatTisk := Date()
       (::prevFile)->( dbUnlock())
      endif
    endif
  endcase
  *
  ** ::odata se použijí pøi volání ASYS_Komunik
  pa_mDatkom_us := listAsArray( memoTran( komUsers->mDatkom_us,,''),';')
  for x := 1 to len(pa_mDatkom_us) step 1
    pa := listAsArray( pa_mDatkom_us[x], '=' )

    if len(pa) = 2
      aadd( pa_items, pa[1] )
      aadd( pa_data , pa[2] )
    endif
  next

  oClass  := RecordSet():createClass( "selectkom_crd_" + komUsers->cIDdatKom, pa_items )
  ::odata := oClass:new( { ARRAY(LEN(pa_items)) } )

  for x := 1 to len(pa_data) step 1
    ::odata:putVar( x, pa_data[x] )
  next

  ::drgDialog:odata_datKom := ::odata

  ASys_Komunik( typ, ::drgdialog )


  if ::isReport
    if( .not.Empty(file), (file) ->(ads_clearaof()), nil)
    ::dctrl:obrowse[3]:oxbp:refreshAll()
  else
    if Select(::prevFile) > 0
      if .not.Empty(::prevFile)
        (::prevFile)->(ads_clearaof())
        if( (::prevFile)->(eof()), (::prevFile)->(dbgotop()), (::prevFile)->(dbGoTo(recno)) )
      endif

//      if( .not.Empty(::prevFile), ((::prevFile)->(ads_clearaof(),(::prevFile)->(dbGoTo(recno)))), nil)
    endif
  endif
RETURN self


method SYS_selectkom_CRD:sel_datkomhd_usr()
  local  idDatKom := komUsers->cidDatKom
  local  m_datKomhd_Defin_kom, ctypDatKom
  *
  local  oDialog, nExit := drgEVENT_QUIT

  ::csection   := ''   // datkom  E - export, I - import
  ::mDefin_kom := ''

  if datkomhd->( dbseek( upper(idDatKom),,'DATKOMH01'))
    ctypDatKom           := upper(datkomhd->ctypDatKom)
    m_datKomhd_Defin_kom := upper(datkomhd->mDefin_kom)

    if     ctypDatKom = 'I'
      ::csection := if( at( '[DATKOMI]', m_datKomhd_Defin_kom) <> 0, 'datkomi', 'import' )
    elseif ctypDatKom = 'E'
      ::csection := if( at( '[DATKOME]', m_datKomhd_Defin_kom) <> 0, 'datkome', 'export' )
    endif

    cc           := strTran( datkomhd->mDefin_kom, 'Users', 'Users_' +::csection )
    ::mDefin_kom += cc +CRLF +CRLF
  endif
  *
  ** pokud adresáø neexistuje musíme ho založit
  myCreateDir( ::tmp_Dir )
    datkomhd->( dbseek( upper(idDatKom),,'DATKOMH01'))
    sName  := ::tmp_Dir +datkomhd->cidDatKom +'.usr'
    memoWrit( sName, komUsers->mDefin_kom )

  oDialog := drgDialog():new('SYS_DATKOMHD_USR', ::drgDialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  if nExit = drgEVENT_SELECT
    if komUsers->(sx_rLock())
      komUsers->mDefin_kom := memoRead(sName)
      komUsers->mdatKom_us := odialog:udcp:m_datKom_us

      komUsers->( dbUnlock(), dbCommit())
    endif

    ::enableOrDisable_Action()
  endif

  odialog:destroy()
  odialog := nil
return self


*
** END of CLASS ****************************************************************
METHOD SYS_selectkom_CRD:destroy()
  local  cfile, arselect

  ::drgUsrClass:destroy()
  *
  if !Empty(::asaved) .and. select('komusers') <> 0
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
  ::comFiles   := ;
  ::isReport   := ;
  ::selMenuCom := ;
  ::lnewrec    := NIL
RETURN NIL


*
**
** class SYS_obdReport_SEL *****************************************************
class SYS_obdDatKom_SEL from drgUsrClass
exported:
  method  init, getForm, drgDialogInit, drgDialogStart, drgDialogEnd

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


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_DELETE
      return .t.

    case nEvent = drgEVENT_EDIT   ;  ::recordSelected()
    otherwise

      return .f.
    endcase
  return .f.


hidden:
  var  drgGet

  inline method recordSelected()
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    obdReport := strZero(ucetsys->nobdobi,2) +'/' +strZero(ucetsys->nrok,4)
  return self
endclass


method SYS_obdDatKom_SEL:init(parent)
  local nEvent,mp1,mp2,oXbp

  drgDBMS:open('ucetsys' )
  drgDBMS:open('uceterr')

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  endif

  ::drgUsrClass:init(parent)
  ucetsys->( ads_setAOF("culoha = 'U'"), dbGoTop())
return self


method SYS_obdDatKom_SEL:getForm()
  local oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 75,15 DTYPE '10' TITLE '' FILE 'UCETSYS' GUILOOK 'All:N,Border:Y'

  DRGSTATIC INTO drgFC FPOS 0,0 SIZE 75,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX
    DRGTEXT INTO drgFC CAPTION 'Výbìr období pro komunikaci'   CPOS  2,.1 CLEN 75 FONT 5
  DRGEND  INTO drgFC

  DRGDBROWSE INTO drgFC FPOS 0,1.3 SIZE 75,13.8 FILE 'UCETSYS'       ;
                        FIELDS 'M->actual_obd:_:2.7::2,'           + ;
                               'M->status_obd:e:2.7::2,'           + ;
                               'M->update_obd:a:2.7::2,'           + ;
                               'cOBDOBI:obdobi,'                   + ;
                               'UCT_ucetsys_BC(2):ROK/OBD:7,'      + ;
                               'UCT_ucetsys_BC(4):ÚÈTOVAL:25,'     + ;
                               'UCT_ucetsys_BC(5):AKTUALIZOVAL:25'   ;
                        INDEXORD 3 SCROLL 'ny' CURSORMODE 3 PP 7  POPUPMENU 'y'

  DRGPUSHBUTTON INTO drgFC POS 72,.2 SIZE 3,1.2 ATYPE 1 ICON1 146 ICON2 246 EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
return drgFC


method SYS_obdDatKom_SEL:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  endif
return


method SYS_obdDatKom_SEL:drgDialogStart(drgDialog)
  local  cKy := 'U' +subStr(obdReport,4) +left(obdReport,2)

  ucetsys->(dbSeek( cKy,,'UCETSYS3'))
  drgDialog:dialogCtrl:browseRefresh()
return self


method SYS_obdDatKom_sel:drgDialogEnd()

  ucetsys->(ads_clearAof())
return self