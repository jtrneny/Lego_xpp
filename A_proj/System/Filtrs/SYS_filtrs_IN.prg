#include "Appevent.ch"
#include "Common.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"

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

    GraStringAt( oPS, {2,2}, ctext)

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
  method  preValidate, postValidate, postSave
  *
  method  sys_fieldsW_sel
  method  ebro_saveEditRow, itemMarked

  inline method sel_lgate(drgDialog)
    local  oDrg  := drgDialog:oForm:oLastDrg
    local  otext := odrg:pushGet:oxbp

    otext:setCaption( if( odrg:ovar:get() = '', '(', ''))
    postAppEvent(xbeP_Keyboard,xbeK_RETURN,,odrg:oXbp)
  return .t.

  inline method sel_rgate(drgDialog)
    local  oDrg  := drgDialog:oForm:oLastDrg
    local  otext := odrg:pushGet:oxbp

    otext:setCaption( if( odrg:ovar:get() = '', ')', ''))
    postAppEvent(xbeP_Keyboard,xbeK_RETURN,,odrg:oXbp)
  return .t.

   inline method sel_noedt_2(drgDialog)
    local  oDrg  := drgDialog:oForm:oLastDrg
    local  otext := odrg:pushGet:oxbp

    otext:setCaption( if( empty(odrg:ovar:get()), 'x', ''))
    postAppEvent(xbeP_Keyboard,xbeK_RETURN,,odrg:oXbp)
  return .t.


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  values, npos, ncount := 1

    do case
    case nEvent = drgEVENT_SAVE
      if lower(::df:oLastDrg:classname()) = 'drgebrowse'
        if ::postSave()
          PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
          return .t.
        endif
      endif
      return .t.

    case nEvent = drgEVENT_DELETE
      if .not. filtritW->( eof())
        if drgIsYESNO( 'Požadujete zrušit položku filtru ?')
          filtritW->(dbdelete())

          filtritW->( dbeval( { || ( filtritW->ncount := ncount, ncount++ ) } ))
          filtritw->( dbgoTop())
          ::brow:refreshAll()
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
         case 'gate' $   lower(drgEdit:name) .and. mp1 = xbeK_SPACE
           if( 'lgate' $ lower(drgEdit:name), ::sel_lgate(::drgDialog), ::sel_rgate(::drgDialog))

         case 'cnoedt_2' $ lower(drgEdit:name) .and. mp1 = xbeK_SPACE
           ::sel_noedt_2(::drgDialog)

         case 'cvyraz_1' $ lower(drgEdit:name)
           if (mp1 >= 32 .and. mp1 <= 255)
             return .t.
           endif
         endcase
       endif

      case oXbp:className() = 'XbpComboBox'
        if ( mp1 > 31 .and. mp1 < 255)
          if oxbp:cargo:className() = 'drgComboBox'
            ::comboSearch(oXbp:cargo,chr(mp1),oXbp)
            PostAppEvent(xbeP_Keyboard,xbeK_ALT_DOWN,,oxbp)
            return .t.
          endif
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
  var     fromName

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
  local  cpar
  *
  local  m_task, odbd
  local  typ

  ::drgUsrClass:init(parent)

  ::newRec           := .not. (parent:cargo = drgEVENT_EDIT)
  ::infrm_filtrs_sel := (lower(parent:parent:formName) = 'sys_filtrs_sel')
  ::fromName         := lower(parent:parent:formName)

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

  * pøi opravì filtru, musíme modifikovat FLTUSERS
  drgDBMS:open('fltUsers',,,,,'fltUsersX')

  ::u_typFiltrs := defaultDisUsr( 'Filtrs', 'CTYPFILTRS')
  typ           := defaultDisUsr( 'Filtrs', 'DEFAULTOPR')


  drgDBMS:open('filtrsW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('filtritW',.T.,.T.,drgINI:dir_USERfitm)
  drgDBMS:open('fieldsW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  if ::newRec  ;  filtrsW ->(dbAppend())
                  filtritW->(dbzap())

                  if ::infrm_filtrs_sel
                    filtrsw->ctask     := m_task
                    filtrsw->cmainFile := ::m_file
                  endif

                  newIDfiltrs(typ)

  else         ;  mh_copyFld( 'filtrs','filtrsW',.t.)
  endif


return self


method sys_filtrs_in:getForm()
  local drgFC := drgFormContainer():new(), odrg
  local defOpr
  local rOnly := .f.

  defOpr := defaultDisUsr('Filtrs','CTYPFILTRS')
  if .not. ::newRec
    rOnly  := if( At('DIST', defOpr)> 0, .f., filtrsw->ctypFiltrs = 'DIST')
    defOpr := 'DIST:distribuèní,USER:uživatelský'
  endif

  DRGFORM INTO drgFC SIZE 117,22 DTYPE '10' TITLE 'Modifikace filtru'        ;
                                            GUILOOK 'All:Y,Border:Y,Action:N';
                                            PRE  'preValidate'               ;
                                            POST 'postValidate'

 DRGTABPAGE INTO drgFC CAPTION 'Komunikace' SIZE 116,21.2 OFFSET 1,82 FPOS 0.5,0.5 PRE 'tabSelect' TABHEIGHT 1.2  SUBTABS 'A2,A3'

  DRGSTATIC INTO drgFC STYPE 14 SIZE 114.8,3.5 FPOS 0.5,0.01
    odrg:ctype  := 2
    odrg:resize := 'yn'
* 1
    DRGTEXT                         INTO drgFC CAPTION 'Název filtru'  CPOS  4,0.5 CLEN 11  FONT 5
    DRGGET      filtrsw->cfltName   INTO drgFC                         FPOS 15,0.5 FLEN 50  PP 2
    odrg:ronly := rOnly

    DRGTEXT                         INTO drgFC CAPTION 'typ'           CPOS 69,0.5 CLEN  4  FONT 5
    DRGCOMBOBOX filtrsw->ctypFiltrs INTO drgFC                         FPOS 74,0.5 FLEN 12 ;
                                    VALUES defOpr PP 2
    odrg:isedit_inrev := .f.

    DRGTEXT                         INTO drgFC CAPTION 'identifikace'  CPOS 87,0.5 CLEN 10
    DRGTEXT     filtrsw->cidFilters INTO drgFC                         CPOS 97,0.5 CLEN 12 PP 1 FONT 5 BGND 13

* 2
    DRGTEXT                         INTO drgFC CAPTION 'Úloha'         CPOS  4,1.8 CLEN 11 FONT 5
    DRGCOMBOBOX filtrsw->ctask      INTO drgFC                         FPOS 15,1.8 FLEN 25 ;
                                    VALUES 'a,a,a,a' PP 2
    odrg:isedit_inrev := .f.

    DRGTEXT                         INTO drgFC CAPTION 'øídící soubor' CPOS 46,1.8 CLEN 12
    DRGCOMBOBOX filtrsw->cmainFile  INTO drgFC                         FPOS 59,1.8 FLEN 50 ;
                                    VALUES 'a,a,a,a' PP 2
    odrg:isedit_inrev := .f.
  DRGEnd INTO drgFC

* Browser _filtritw
//   DRGTABPAGE INTO drgFC CAPTION 'položky' FPOS 0.5,5.0 SIZE 114.8,15.8 OFFSET 1,86 TTYPE 3 PRE 'tabSelect' TABHEIGHT 0.8 RESIZE 'yx' SUB 'A2'
   DRGTABPAGE INTO drgFC CAPTION 'položky' FPOS 0.5,5.0 SIZE 114.8,15.8 OFFSET 1,86 PRE 'tabSelect' TABHEIGHT 1.0 RESIZE 'yx' SUB 'A2'
    odrg:resize := 'yy'
//    DRGTEXT INTO drgFC CAPTION 'Položky filtru' CPOS 0.1,0 CLEN 114.8 FONT 5 PP 3 BGND 11 CTYPE 1
//     odrg:resize := 'yn'

    DRGEBROWSE INTO drgFC FPOS .3,1.1 SIZE 113.5,13.4 FILE 'FILTRITw'        ;
               SCROLL 'ny' CURSORMODE 3 PP 7 GUILOOK 'sizecols:n,headmove:n' ITEMMARKED 'itemMarked'
      _drgEBrowse := oDrg
      _drgEBrowse:resize := 'yy'

      DRGGET      filtritW->clgate_1  INTO drgFC CLEN  3   FCAPTION '(' PUSH 'sel_lgate' //RESIZE 'yn'
       odrg:ronly := rOnly
//       odrg:resize := 'yn'
      DRGGET      filtritW->clgate_2  INTO drgFC CLEN  3  FCAPTION '(' PUSH 'sel_lgate'
       odrg:ronly := rOnly
      DRGGET      filtritW->clgate_3  INTO drgFC CLEN  3  FCAPTION '(' PUSH 'sel_lgate'
       odrg:ronly := rOnly
      DRGGET      filtritW->clgate_4  INTO drgFC CLEN  3  FCAPTION '(' PUSH 'sel_lgate'
       odrg:ronly := rOnly

      DRGTEXT INTO drgFC NAME filtritW->cfile_1  CLEN  10   CAPTION  'table'

      DRGGET      filtritW->cvyraz_1u INTO drgFC CLEN 25  FCAPTION 'výraz-L' PUSH 'sys_fieldsW_sel'
       odrg:ronly := rOnly
      DRGCOMBOBOX filtritW->crelace   INTO drgFC FLEN 6   FCAPTION 'oper'    VALUES '==:==,> :> ,< :< ,>=:>=,<=:<=,<>:<>,= :=,!=:!= '
       odrg:ronly := rOnly
      DRGGET      filtritW->cvyraz_2u INTO drgFC CLEN 25  FCAPTION 'výraz-P' PUSH 'sys_fieldsW_sel'
       odrg:ronly := rOnly
      DRGCHECKBOX filtritW->lnoedt_2  INTO drgFC FLEN 3   FCAPTION 'e'        VALUES 'T:.,F:.'
       odrg:ronly := rOnly

      DRGTEXT INTO drgFC NAME filtritW->cfile_2  CLEN  10  CAPTION  'table'

      DRGGET      filtritW->crgate_1  INTO drgFC CLEN 3   FCAPTION ')' PUSH 'sel_rgate'
       odrg:ronly := rOnly
      DRGGET      filtritW->crgate_2  INTO drgFC CLEN 3   FCAPTION ')' PUSH 'sel_rgate'
       odrg:ronly := rOnly
      DRGGET      filtritW->crgate_3  INTO drgFC CLEN 3   FCAPTION ')' PUSH 'sel_rgate'
       odrg:ronly := rOnly
      DRGGET      filtritW->crgate_4  INTO drgFC CLEN 3   FCAPTION ')' PUSH 'sel_rgate'
       odrg:ronly := rOnly

      DRGCOMBOBOX filtritW->coperand  INTO drgFC FLEN 7.3 VALUES '     :    ,.and.:.and.,.or. : .or. '
       odrg:ronly := rOnly

      _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC
   DRGEND INTO drgFC


//   DRGTABPAGE INTO drgFC CAPTION 'relace' FPOS 0.5,5.0 SIZE 114.8,15.8 OFFSET 13,74 TTYPE 3 PRE 'tabSelect' TABHEIGHT 0.8 RESIZE 'yx' SUB 'A3'
   DRGTABPAGE INTO drgFC CAPTION 'relace' FPOS 0.5,5.0 SIZE 114.8,15.8 OFFSET 13,74 PRE 'tabSelect' TABHEIGHT 1.0 RESIZE 'yx' SUB 'A3'
    odrg:resize := 'yy'
//    DRGTEXT INTO drgFC CAPTION 'Definované relaèní vazby' CPOS 0.1,0 CLEN 113.8 FONT 5 PP 3 BGND 11 CTYPE 1
//     odrg:resize := 'yn'

    DRGTREEVIEW INTO drgFC                 ;
                FPOS .5, 1.1               ;
                SIZE 113.8,13.4            ;
                TREEINIT 'R_treeViewInit'  ;
                ITEMMARKED 'treeItemMarked';
                HASLINES                   ;
                HASBUTTONS                 ;
                RESIZE  'yy'
//    odrg:ronly := rOnly

//  DRGEnd INTO drgFC
   DRGEnd INTO drgFC
  DRGEnd INTO drgFC

  DRGTABPAGE INTO drgFC CAPTION 'Metodika' SIZE 116,21.2 OFFSET 16,68 FPOS 0.5,0.5 PRE 'tabSelect' TABHEIGHT 1.2
   DRGMLE filtrsw->mMetodika INTO drgFC FPOS 0.8,0.2 SIZE 114.0,19.3 POST 'postLastField'// FCAPTION 'Distribuèní hodnota' CPOS 1,2
   odrg:ronly := rOnly
//       drgFC:members[16]:ronly := .t.
//     DRGEND INTO drgFC

  DRGPushButton INTO drgFC CAPTION 'Návrh-FRM'  EVENT '' POS 0,0 SIZE 0,0

  DRGEND INTO drgFC



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

  ::df:tabPageManager:showPage(2)
return self


method sys_filtrs_in:comboBoxInit(drgComboBox)
  local  cname      := lower(drgComboBox:name)
  local  acombo_val := {}, ok := .f., x, obj, task, isTask := .f., pa, pos
  *
  local  values := drgDBMS:dbd:values
  local  dm     := drgComboBox:drgDialog:dataManager

  drgDBMS:open('c_task')

  do case
//  case(cname = 'filtrsw->ctypFiltrs')
//    ok := .t.
//    pa := listAsArray(::u_typFiltrs,',')

//    for x := 1 to len(pa) step 1
//      pos := at(':',pa[x])
//      aadd(acombo_val, { subStr(pa[x],1,pos-1), substr(pa[x],pos+1) })
//    next

  case(cname = 'filtrsw->ctask'     )
    ok := .t.
    c_task->(AdsSetOrder(1),dbGoTop())
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
  local  drgCombo, value, drgVar := drgComboBox:oVar

  do case
  case(cname = 'filtrsw->ctask'    )
    drgVAR:save()

    drgCombo := ::dm:has('filtrsw->cmainFile'):odrg
    ::comboBoxInit(drgCombo)

    value := drgCombo:values[1,1]
    drgCombo:refresh(value)
    ::df:setNextFocus('filtrsw->cmainFile',, .T. )

  case(cname = 'filtrsw->cmainFile')
     drgVAR:save()

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
  case('gate'     $ item)
    drgVar:odrg:pushGet:oxbp:setCaption(value)

  case('cnoedt_2' $ item)
    drgVar:odrg:pushGet:oxbp:setSize({22,16})
    drgVar:odrg:pushGet:oxbp:configure()

    if at('->',filtritw ->cvyraz_2) = 0
      drgVar:odrg:pushGet:oxbp:setCaption(value)
      drgVar:odrg:isEdit := .t.
    else
      drgVar:odrg:pushGet:oxbp:setCaption('')
      drgVar:odrg:isEdit := .f.
    endif
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
    case( item = 'ctypFiltrs')
      if changed
        newIDfiltrs(value)
//        cval := newIDdatcom(value)
        ::dataManager:set("filtrsw->cidFilters", filtrsw->cidFilters)
      endif

    case( item = 'cfltname')
      if empty(value)
        ::msg:writeMessage('Název filtru je povinný údaj ...',DRG_MSG_ERROR)
        ok := .f.
      endif
    endcase

  otherwise
    do case
    case('gate' $ item )
      drgVar:set(drgVar:odrg:pushGet:oxbp:caption)

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

    case('cnoedt_2' $ item )
      drgVar:set(drgVar:odrg:pushGet:oxbp:caption)

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
  case drgEBrowse:isAppend

    if drgEBrowse:isAddData
      filtritW->ncount := ncount +1

    else
      filtritW->ncount := ncount

       recNo := filtritW->(recNo())
      ordRec := fordRec({'filtritW'})

      filtritW->(AdsSetOrder(0),dbgoTop())

      do while .not. filtritW->(eof())
        if filtritW->ncount >= ncount  .and. filtritW->(recNo()) <> recNo
          filtritW->ncount++
        endif
        filtritW->(dbskip())
      enddo
      fordRec()

*      drgEBrowse:oxbp:refreshAll()
    endif
  endcase
return

*
** uložíme si nastavení
method sys_filtrs_in:postSave()
  local  p_memos  := ::build_memos()
  local  anFtu    := {}, lok_Ftu := .t., ok := .t.
  local  cfltName

  if .not. p_memos[3]
    ConfirmBox( ,'Pøi kontrole filtru byly zjištìny syntaktické chyby !', ;
                 'Vámi vytvoøený filtr nelze uložit ...'                , ;
                  XBPMB_OK                                              , ;
                  XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE            )
    return .f.
  endif


  * pøi opravì filtru musíme modifikovat FLTUSERS
  if .not. ::newRec
    if (filtrs->mfilterS <> p_memos[1]) .or. (filtrs->mdata <> p_memos[2])
      fltUsersX->(AdsSetOrder('FLTUSERS05')                        , ;
                  dbSetScope(SCOPE_BOTH, upper(filtrs->cidFilters)), ;
                  dbgoTop()                                        , ;
                  dbeval( { || aadd(anFtu, fltUsersX->(recNo())) } )  )

      lok_Ftu  := fltUsersX->(sx_RLock(anFtu))
    endif
  endif

  if lok_Ftu
    if(ok := if( ::newRec .or. filtrs->(eof()), addRec('filtrs'), replRec('filtrs')))

      if( ::typFiltrs:odrg:isEdit, newIDfiltrs(allTrim(::typFiltrs:odrg:value)), nil)
      mh_copyFld('filtrsW','filtrs')

      filtrs->mfilterS := p_memos[1]
      filtrs->mdata    := p_memos[2]

      if ( .not. ::newRec .and. len(anFtu) <> 0 )
        cfltName := filtrs->cfltName

        fltUsersX->(dbgoTop(), ;
                    dbeval( { || ( fltUsersX->cfltName   := cfltName, ;
                                   fltUsersX->lbegAdmin  := .f.     , ;
                                   fltUsersX->lbegUsers  := .f.     , ;
                                   fltUsersX->mfilterS_u := ''        ) } ) )
      endif
    endif
  endif

  filtrs->(dbunlock(), dbcommit())
   fltUsersX->(dbunlock(), dbcommit(), dbclearScope())
return ok