#include "Appevent.ch"
#include "Common.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"

#pragma Library( "XppUI2.LIB" )


function sys_filtrs_inf(oXbp,ctext)
  local  oPS, oFont, aAttr, nSize := oxbp:currentSize()[1]

  if .not. empty(oPS := oXbp:lockPS())
*    oFont := XbpFont():new():create( "12.Arial CE" )
    aAttr := ARRAY( GRA_AS_COUNT )

*    GraSetFont( oPS, oFont )

    aAttr [ GRA_AS_COLOR     ] := GRA_CLR_RED
    GraSetAttrString( oPS, aAttr )

    GraStringAt( oPS, {0,0}, ctext)

    oXbp:unlockPS(oPS)
  endif
return .t.

*
** CLASS for SYS_filtrs_IN ****************************************************
CLASS SYS_filtrs_IN FROM drgUsrClass, sys_filtrs
EXPORTED:
  var     newRec

  method  init, getForm, drgDialogStart
  method  comboBoxInit, comboItemSelected
  method  preValidate, postValidate, postSave, postSave_rel
  *
  method  sys_fieldsW_sel
  method  ebro_saveEditRow, itemMarked

  inline method sel_lgate(drgDialog)
    local  oDrg  := drgDialog:oForm:oLastDrg
    local  otext := odrg:pushGet:otext

    otext:setCaption( if( odrg:ovar:get() = '', '(', ''))
    postAppEvent(xbeP_Keyboard,xbeK_RETURN,,odrg:oXbp)
  return .t.

  inline method sel_rgate(drgDialog)
    local  oDrg  := drgDialog:oForm:oLastDrg
    local  otext := odrg:pushGet:otext

    otext:setCaption( if( odrg:ovar:get() = '', ')', ''))
    postAppEvent(xbeP_Keyboard,xbeK_RETURN,,odrg:oXbp)
  return .t.


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  values, npos

    do case
    case nEvent = drgEVENT_SAVE
      if lower(::df:oLastDrg:classname()) = 'drgebrowse'
        if ::postSave()
          PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
          return .t.
        endif
      endif
      return .t.

    case(nEvent = xbeP_Keyboard)
      *
      do case
      case oxbp:className() = 'XbpGet'
       if ( nPos := ascan(::ardef, {|x| x.drgEdit:oxbp = oxbp})) <> 0
         drgEdit := ::ardef[nPos].drgEdit

         do case
         case 'gate' $ lower(drgEdit:name) .and. mp1 = xbeK_SPACE
           if( 'lgate' $ lower(drgEdit:name), ::sel_lgate(::drgDialog), ::sel_rgate(::drgDialog))

         case 'cvyraz_1' $ lower(drgEdit:name)
           if (mp1 >= 32 .and. mp1 <= 255)
             return .t.
           endif
         endcase
       endif

      case oXbp:className() = 'XbpComboBox'
        if ( mp1 > 31 .and. mp1 < 255)
          ::comboSearch(oXbp:cargo,chr(mp1),oXbp)
*          values := oXbp:cargo:values
          PostAppEvent(xbeP_Keyboard,xbeK_ALT_DOWN,,oxbp)

          return .t.
        endif
      endcase
      *
    otherwise
      return .f.
    endcase
  return .f.

HIDDEN:
  var     ardef, typFiltrs, u_typFiltrs, p_users, p_file
  var     infrm_filtrs_sel

  inline method comboSearch(drgCombo,cVal,oXbp)
    local  values := drgCombo:values
    local  search := lower(drgCombo:search +cVal)
    *
    local  nSea   := len(search), pa := {}

    for x := 1 to len(values) step 1
      if left(lower(values[x,2]),nSea) = search
        AAdd(pa, values[x])
      endif
    next

    do case
    case( len(pa) = 0 )
    otherwise
****
      sys_filtrs_inf(oXbp,left(pa[1,2],nsea))
      drgCombo:search := search
      drgCombo:refresh(pa[1,1])
      oXbp:setMarked({1,nSea})
    endcase
  return self

ENDCLASS


method sys_filtrs_in:init(parent)
  local  sName   := drgINI:dir_USERfitm +userWorkDir() +'\c_opravn.mem'
  local  lenBuff := 40960, buffer := space(lenBuff), cpar
  *
  local  m_task, odbd

  ::drgUsrClass:init(parent)

  ::newRec           := .not. (parent:cargo = drgEVENT_EDIT)
  ::infrm_filtrs_sel := (lower(parent:parent:formName) = 'sys_filtrs_sel')

  if ::infrm_filtrs_sel
    if(filtrs->(eof()), ::newRec >= .t., nil )

    * uživatelské sestavy volané z menu
    if lower(parent:parent:parent:parent:formName) = 'drgmenu'
      forms->(dbseek( upper(frmusers->cidForms),,'FORMS01'))
      ::m_file := allTrim(forms->cmainFile)

    * uživatelské filtry volané ze SCR
    else
      ::m_file := parent:parent:parent:parent:odbrowse[1]:cfile
    endif

    odbd     := drgDBMS:getDBD(::m_file)
    m_task   := odbd:task
  endif

  * c_opravn v mBlock obsahuje popis povolených nasavení pro filtr
  drgDBMS:open('c_opravn')
  c_opravn->(dbseek(syOpravneni,,'C_OPRAVN01'))
  memoWrit(sName,c_opravn->mBlock)

  getPrivateProfileStringA('Filtrs', 'CTYPFILTRS', '', @buffer, lenBuff, sName)
  ::u_typFiltrs := substr(buffer,1,len(trim(buffer))-1)


  drgDBMS:open('filtrsW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('filtritW',.T.,.T.,drgINI:dir_USERfitm)
  drgDBMS:open('fieldsW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  if ::newRec  ;  filtrsW ->(dbAppend())
                  filtritW->(dbzap())

                  if ::infrm_filtrs_sel
                    filtrsw->ctask     := m_task
                    filtrsw->cmainFile := ::m_file
                  endif

  else         ;  mh_copyFld( 'filtrs','filtrsW',.t.)
  endif
return self


method sys_filtrs_in:getForm()
  local  drgFC := drgFormContainer():new(), odrg

  DRGFORM INTO drgFC SIZE 107,20 DTYPE '10' TITLE 'Modifikace filtru'        ;
                                            GUILOOK 'All:Y,Border:Y,Action:N';
                                            PRE  'preValidate'               ;
                                            POST 'postValidate'

  DRGSTATIC INTO drgFC STYPE 14 SIZE 106.4,3.5 FPOS 0.2,0.01
    odrg:ctype := 2
* 1
    DRGTEXT                         INTO drgFC CAPTION 'Název filtru'  CPOS  1,0.5 CLEN 11  FONT 5
    DRGGET      filtrsw->cfltName   INTO drgFC                         FPOS 12,0.5 FLEN 50  PP 2
    DRGTEXT                         INTO drgFC CAPTION 'typ'           CPOS 64,0.5 CLEN  4  FONT 5
    DRGCOMBOBOX filtrsw->ctypFiltrs INTO drgFC                         FPOS 69,0.5 FLEN 12 ;
                                    VALUES 'a,a,a,a' PP 2
    odrg:isedit_inrev := .f.

    DRGTEXT                         INTO drgFC CAPTION 'identifikace'  CPOS 82,0.5 CLEN 10
    DRGTEXT     filtrsw->cidFilters INTO drgFC                         CPOS 92,0.5 CLEN 12 PP 1 FONT 5 BGND 13

* 2
    DRGTEXT                         INTO drgFC CAPTION 'Úloha'         CPOS  1,1.8 CLEN 11 FONT 5
    DRGCOMBOBOX filtrsw->ctask      INTO drgFC                         FPOS 12,1.8 FLEN 25 ;
                                    VALUES 'a,a,a,a' PP 2
    odrg:isedit_inrev := .f.

    DRGTEXT                         INTO drgFC CAPTION 'øídící soubor' CPOS 40,1.8 CLEN 12
    DRGCOMBOBOX filtrsw->cmainFile  INTO drgFC                         FPOS 54,1.8 FLEN 50 ;
                                    VALUES 'a,a,a,a' PP 2
    odrg:isedit_inrev := .f.
  DRGEnd INTO drgFC

* Browser _filtritw
  DRGTABPAGE INTO drgFC CAPTION 'položky' FPOS 0.5,3.6 SIZE 106,15.8 OFFSET 1,86 TTYPE 3 PRE 'tabSelect' TABHEIGHT 0.8 RESIZE 'yx'
    DRGTEXT INTO drgFC CAPTION 'Položky filtru' CPOS 0.1,0 CLEN 105.8 FONT 5 PP 3 BGND 11 CTYPE 1
    odrg:resize := 'yx'

    DRGEBROWSE INTO drgFC FPOS .5,1.1 SIZE 105.5,13.4 FILE 'FILTRITw'        ;
               SCROLL 'ny' CURSORMODE 3 PP 7 GUILOOK 'sizecols:n,headmove:n' ITEMMARKED 'itemMarked'
      _drgEBrowse := oDrg

      DRGGET      filtritW->clgate_1  INTO drgFC CLEN  2.5 FCAPTION '(' PUSH 'sel_lgate'
      DRGGET      filtritW->clgate_2  INTO drgFC CLEN  2.5 FCAPTION '(' PUSH 'sel_lgate'
      DRGGET      filtritW->clgate_3  INTO drgFC CLEN  2.5 FCAPTION '(' PUSH 'sel_lgate'
      DRGGET      filtritW->clgate_4  INTO drgFC CLEN  2.5 FCAPTION '(' PUSH 'sel_lgate'

      DRGTEXT INTO drgFC NAME filtritW->cfile_1  CLEN  9   CAPTION  'table'

      DRGGET      filtritW->cvyraz_1u INTO drgFC CLEN 26  FCAPTION 'výraz-L' PUSH 'sys_fieldsW_sel'
      DRGCOMBOBOX filtritW->crelace   INTO drgFC FLEN 7   FCAPTION 'oper'    VALUES '==:==,> :> ,< :< ,>=:>=,<=:<=,<>:<>,= :=,!=:!= '
      DRGGET      filtritW->cvyraz_2u INTO drgFC CLEN 25  FCAPTION 'výraz-P' PUSH 'sys_fieldsW_sel'

      DRGTEXT INTO drgFC NAME filtritW->cfile_2  CLEN  9   CAPTION  'table'

      DRGGET      filtritW->crgate_1  INTO drgFC CLEN 2.5 FCAPTION ')' PUSH 'sel_rgate'
      DRGGET      filtritW->crgate_2  INTO drgFC CLEN 2.5 FCAPTION ')' PUSH 'sel_rgate'
      DRGGET      filtritW->crgate_3  INTO drgFC CLEN 2.5 FCAPTION ')' PUSH 'sel_rgate'
      DRGGET      filtritW->crgate_4  INTO drgFC CLEN 2.5 FCAPTION ')' PUSH 'sel_rgate'

      DRGCOMBOBOX filtritW->coperand  INTO drgFC FLEN 7   VALUES '     :    ,.and.:.and.,.or. : .or. '

      _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC
  DRGEND INTO drgFC


  DRGTABPAGE INTO drgFC CAPTION 'relace' FPOS 0.5,3.6 SIZE 106,15.8 OFFSET 13,74 TTYPE 3 PRE 'tabSelect' TABHEIGHT 0.8 RESIZE 'yx'
    DRGTEXT INTO drgFC CAPTION 'Definované relaèní vazby' CPOS 0.1,0 CLEN 105.8 FONT 5 PP 3 BGND 11 CTYPE 1
    odrg:resize := 'yx'

    DRGTREEVIEW INTO drgFC                 ;
                FPOS .5, 1.1               ;
                SIZE 105.5,13.4            ;
                TREEINIT 'R_treeViewInit'  ;
                ITEMMARKED 'treeItemMarked';
                HASLINES                   ;
                HASBUTTONS                 ;
                RESIZE  'YN'

  DRGEnd INTO drgFC

  * neviditelné pomocné položky
  DRGTEXT INTO drgFC NAME filtritW->cvyraz_1 CPOS 0,0 CLEN  0
  DRGTEXT INTO drgFC NAME filtritW->ctype_1  CPOS 0,0 CLEN  0
  DRGTEXT INTO drgFC NAME filtritW->nlen_1   CPOS 0,0 CLEN  0
  DRGTEXT INTO drgFC NAME filtritW->ndec_1   CPOS 0,0 CLEN  0

  DRGTEXT INTO drgFC NAME filtritW->cvyraz_2 CPOS 0,0 CLEN  0
RETURN drgFC


method sys_filtrs_in:drgDialogStart(drgDialog)
  local members := drgDialog:oForm:aMembers, in_file, odrg

  ::sys_filtrs:init(drgDialog)
  if( ::newRec, nil, (::m_file := allTrim(filtrsW->cmainFile), ::R_fillRoot()))

  * pøí opravì se pozicujeme vžda na 1.BROw pokud je na FRM a má data *
  BEGIN SEQUENCE
    FOR x := 1 TO LEN(members)
      IF lower(members[x]:ClassName()) $ 'drgebrowse'
        ::brow  := members[x]:oXbp
        in_file := members[x]:cfile
  BREAK
      ENDIF
    NEXT
  ENDSEQUENCE

  if isObject(::brow) .and. (in_file) ->(LastRec()) <> 0
     ::df:nextFocus := x
  endif

  ::ardef     := drgDialog:odbrowse[1]:ardef
  ::typFiltrs := ::dm:has('filtrsw->ctypFiltrs')

  if ::infrm_filtrs_sel
*-    ::m_file := coalesceEmpty(allTrim(filtrsw->cmainFile), ::p_file)
    ::R_fillRoot()

    ::dm:has('filtrsW->ctask'    ):odrg:isEdit := .f.
    ::dm:has('filtrsW->cmainFile'):odrg:isEdit := .f.
  endif

  ::itemMarked()
  ::dm:refresh()
return self


method sys_filtrs_in:comboBoxInit(drgComboBox)
  local  cname      := lower(drgComboBox:name)
  local  acombo_val := {}, ok := .f., x, obj, task, isTask := .f., pa, pos
  *
  local  values := drgDBMS:dbd:values
  local  dm     := drgComboBox:drgDialog:dataManager

  drgDBMS:open('c_task')

  do case
  case(cname = 'filtrsw->ctypFiltrs')
    ok := .t.
    pa := listAsArray(::u_typFiltrs,';')

    for x := 1 to len(pa) step 1
      pos := at(':',pa[x])
      aadd(acombo_val, { subStr(pa[x],1,pos-1), substr(pa[x],pos+1) })
    next

  case(cname = 'filtrsw->ctask'     )
    ok := .t.
    c_task->(ordSetFocus(1),dbGoTop())
    do while .not. c_task->(eof())
      task := upper(c_task->ctask)

      BEGIN SEQUENCE
      for x := 1 to len(values) step 1
        obj := values[x,2]
        if upper(obj:task) = task
          isTask := .t.
      BREAK
        endif
      next
      END SEQUENCE

      if(isTask, AAdd(acombo_val, { c_task->ctask, c_task->cnazUlohy }), nil)
      c_task->(dbSkip())
      isTask := .f.
    enddo
    if( empty(dm:get('filtrsw->ctask')), dm:set('filtrsw->ctask', acombo_val[1,1]), nil)

  case(cname = 'filtrsw->cmainFile' )
    ok     := .t.
    task   := upper(dm:get('filtrsw->ctask'))
    values := drgDBMS:dbd:values

    for x := 1 to len(values) step 1
      obj  := values[x,2]
      if upper(obj:task) = task
        AAdd(acombo_val, {padR(obj:fileName,10), obj:fileName +'.' +obj:description } )
      endif
    next
  endcase

  if ok
    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgComboBox:value := drgComboBox:ovar:value
  endif
return self


method sys_filtrs_in:comboItemSelected(drgComboBox,mp2,o)
  local  cname := lower(drgComboBox:name)
  local  drgCombo, value

  do case
  case(cname = 'filtrsw->ctask'    )
    drgCombo := ::dm:has('filtrsw->cmainFile'):odrg
    ::comboBoxInit(drgCombo)

    value := drgCombo:values[1,1]
    drgCombo:refresh(value)
    ::df:setNextFocus('filtrsw->cmainFile',, .T. )

  case(cname = 'filtrsw->cmainFile')
     value    := allTrim(drgComboBox:value)

     if .not. empty(::m_file)
       filtritW->(dbzap(), dbgotop())
     endif

     ::m_file := allTrim(value)
     ::R_fillRoot()
*-     if(isnull(mp2),PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,drgCombo:oxbp),nil)
  endcase
return self

method sys_filtrs_in:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  do case
  case('gate' $ item )
    drgVar:odrg:pushGet:otext:setCaption(value)
  endcase
return ok


method sys_filtrs_in:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  do case
  case( file = 'filtrsw')
    do case
    case( item = 'cfltname')
      if empty(value)
        ::msg:writeMessage('Název filtru je povinný údaj ...',DRG_MSG_ERROR)
        ok := .f.
      endif
    endcase

  otherwise
    do case
    case('gate' $ item )
      drgVar:set(drgVar:odrg:pushGet:otext:caption)

    case( item  = 'cvyraz_1u')
      if empty(value)
        ::msg:writeMessage('Výraz na levé stranì filtru je povinný údaj ...',DRG_MSG_ERROR)
        ok := .f.
      endif

    case( item  = 'cvyraz_2u')
      if drgVar:prevValue <> value
        ::dm:set( 'filtritW->cfile_2' , ''   )
        ::dm:set( 'filtritW->cvyraz_2', value)
      endif
    endcase
  endcase

  * hlavièku vždy uložíme
  if(file = 'filtrsw' .and. ok, drgVAR:save(),nil)
return ok


method sys_filtrs_in:itemMarked(arowCol,unil,oxbp)
  local  odrg   := ::df:olastdrg
  local  values := ::dm:vars:values, size := ::dm:vars:size()

  ::msg:editState:caption := 0
  ::msg:WriteMessage(,0)

  if isObject(oxbp) .and. oxbp:className() = 'XbpBrowse'
    if odrg:isEdit .and. odrg:className() <> 'drgEBrowse'
      begin sequence
      for x := 1 to size step 1
        if values[x,2]:odrg:isEdit .and. 'filtrsw' $ lower(values[x,2]:name)
          if .not. values[x,2]:odrg:postValidate()
            ::df:setNextFocus(values[x,2]:odrg)
            oxbp:refreshCurrent()
            postAppEvent(drgEVENT_OBJEXIT,,,oXbp)
      break
          endif
        endif
      next
      end sequence
    endif
  endif
return .t.


method sys_filtrs_in:sys_fieldsW_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  odrg   := ::df:olastDrg
  local  name   := lower(odrg:name)

  DRGDIALOG FORM 'SYS_fieldsW_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

  if (nexit != drgEVENT_QUIT)
    if 'cvyraz_1' $ name
      ::dm:set( 'filtritW->cfile_1' , fieldsW->cfile )
      ::dm:set( 'filtritW->cvyraz_1', fieldsW->cvyraz)
      ::dm:set( 'filtritW->ctype_1' , fieldsW->ctype )
      ::dm:set( 'filtritW->nlen_1'  , fieldsW->nlen  )
      ::dm:set( 'filtritW->ndec_1'  , fieldsW->ndec  )
    else
      ::dm:set( 'filtritW->cfile_2' , fieldsW->cfile )
      ::dm:set( 'filtritW->cvyraz_2', fieldsW->cvyraz)
    endif

    ::dm:set(name, allTrim(fieldsW->cvyraz_u))

     odrg := ::dm:has(name)
     odrg:prevValue := odrg:value
  endif
return (nexit != drgEVENT_QUIT)


method sys_filtrs_in:ebro_saveEditRow(drgEBrowse)
  local  x, drgVar
  local  ordRec, recNo, ncount := drgEBrowse:odata:ncount
  local  pa := { 'filtritW->cfile_1' , ;
                 'filtritW->cvyraz_1', ;
                 'filtritW->ctype_1' , ;
                 'filtritW->nlen_1'  , ;
                 'filtritW->ndec_1'  , ;
                 'filtritW->cfile_2' , ;
                 'filtritW->cvyraz_2'  }

  for x := 1 to len(pa) step 1
    drgVar := ::dm:has(pa[x])
    if( isblock(drgVar:block), eval(drgVar:block,drgVar:value), nil)
  next

  do case
  case drgEBrowse:isAppend  ;  filtritW->ncount := ncount +1
  case drgEBrowse:state = 2
     recNo := filtritW->(recNo())
    ordRec := fordRec({'filtritW'})

    filtritW->ncount := ncount
    filtritW->(ordSetFocus(0),dbgoTop())

    do while .not. filtritW->(eof())
      if filtritW->ncount >= ncount .and. filtritW->(recNo()) <> recNo
        filtritW->ncount++
      endif
      filtritW->(dbskip())
    enddo

    fordRec()
  endcase
return


method sys_filtrs_in:postSave()
  local  ofile   := drgDBMS:dbd:getByKey('filtritW'), pa := {}, x
  local  paFiles := {upper(filtrsW->cmainFile)}, cfile_1, cfile_2
  local  recNo   := filtritW->(recNo())
  *
  local  mfilterS := '', item, value, n_lgate, n_rgate
  local  mdata    := ''

  for x := 1 to len( ofile:desc) step 1
    if( ofile:desc[x]:desc = 'S', aadd( pa, ofile:desc[x]:name), nil)
  next

  filtritW->(dbgoTop())

  do while .not. filtritW->(eof())
    cfile_1 := upper(alltrim(filtritW->cfile_1))
    cfile_2 := upper(alltrim(filtritW->cfile_2))

    for x := 1 to len(pa) step 1
      item    := pa[x]
      value   := DBGetVal('filtritW->' +item)
      n_lgate := 0
      n_rgate := 0

      if('gate' $ item .and. .not. empty(value))
        if('lgate' $ item, n_lgate++, n_rgate++)
      endif

      if .not. empty(value)
        mfilterS += item +':' +value +CRLF
      endif
    next

    ** relaèní prvky
    if( ascan( paFiles, { |a| a = cfile_1 }) = 0, aadd(paFiles,cfile_1), nil)

    if .not. empty(cfile_2) .and. (cfile_1 <> cfile_2)
      if( ascan( paFiles, { |a| a = cfile_2 }) = 0, aadd(paFiles,cfile_2), nil)
    endif
    **

    filtritW->(dbskip())

    mfilterS += if( .not. filtritW->(eof()), ';' +CRLF, '' )
  enddo

  filtritW->(dbgoTo(recNo))

  if( len(::relDef) > 0 .and. len(paFiles) > 1, mdata := ::postSave_rel(paFiles), nil)

  if(ok := if( ::newRec .or. filtrs->(eof()), addRec('filtrs'), replRec('filtrs')))
    if( ::typFiltrs:odrg:isEdit, newIDfiltrs(allTrim(::typFiltrs:odrg:value)), nil)
    mh_copyFld('filtrsW','filtrs')

    filtrs->mfilterS := mfilterS
    filtrs->mdata    := mdata
  endif

  filtrs->(dbunlock(), dbcommit())
return ok


#xtranslate  .relFile   =>  \[ 1\]
#xtranslate  .relKey    =>  \[ 2\]
#xtranslate  .relOrder  =>  \[ 3\]
#xtranslate  .mainFile  =>  \[ 4\]


method sys_filtrs_in:postSave_rel(paFiles)
  local  mdata := '', x, y, z, relFile, tagDef, pa, relKey, ckey
  *
  local  relDef := ::relDef, u_relDef := {}, p_relDef

  mdata += '[DefineField]'              +CRLF
  mdata += '  [Table:' +paFiles[1] +']' +CRLF
  mdata += '    [Relations]'            +CRLF

  for x := 2 to len(paFiles) step 1
    relFile := paFiles[x]

    begin sequence
      for y := 1 to len(relDef) step 1
        aadd(u_relDef, { relDef[y]:relFile, relDef[y]:relKey, relDef[y]:relOrder, relDef[y]:mainFile })

        if upper(relDef[y]:relFile) = relFile
    break
        else

          begin sequence
            for z := 1 to len(relDef[y]:relSubs) step 1
              p_relDef := relDef[y]:relSubs[z]
              aadd(u_relDef, { p_relDef:relFile, p_relDef:relKey, p_relDef:relOrder, p_relDef:mainFile })

              if upper(p_relDef:relFile) = relFile
           break
               endif
            next
          end sequence

        endif
      next

    end sequence
  next

  ** uložím požadovanou relaci do mdata
  for x := 1 to len(u_relDef) step 1
     relFile := u_relDef[x].relFile
     relKey  := ''
    tagDef   := drgDBMS:dbd:getByKey(relFile):indexDef[u_relDef[x].relOrder]
        pa   := listAsArray(u_relDef[x].relKey,'+')
        pb   := listAsArray(tagDef:cindexKey  ,'+')

    for y := 1 to len(pa) step 1
      ckey   := strTran(allTrim(lower(pb[y])), allTrim(lower(pa[y])), u_relDef[x].mainFile +'->' +pa[y])
      relKey += ckey +'+'
    next
    relKey := subStr(relKey,1, len(relKey) -1)
    *
    mdata    += '    ' +str(u_relDef[x].relOrder,2) +':' ;
                       +str(x,2)                    +':' ;
                       +relKey                      +':' ;
                       +u_relDef[x].mainFile        +':' ;
                       +u_relDef[x].relFile              +CRLF
  next
return if(len(u_relDef) > 0, mdata, '')