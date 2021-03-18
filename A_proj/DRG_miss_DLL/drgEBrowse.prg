#pragma Library( "XppUI2.LIB" )
#pragma Library( "ADAC20B.LIB" )

#include "Appevent.ch"
#include "Common.ch"
#include "class.ch"
#include "Directry.ch"
#include "Gra.ch"
#include "Font.ch"
#include "Xbp.ch"
#include "ads.ch"
#include "adsdbe.ch"

#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"

#include "..\Asystem++\Asystem++.ch"

*
** state - 0 - inBrowse  1 - inEdit  2 - inAppend
#define   _inBrow    0
#define   _doEdit    1
#define   _doAppend  2
#define   _doDelete  3
#define   _doSave    5
*
**

/*
interface pro okolí
INS   -   ebro_beforeAppend         -  pøed INS
          ebro_afterAppend          -  po   INS
          ebro_afterAppendBlankRec  -  možnost doplnito údaje do nového /prázdného/
                                       záznamu pøed uložením editaèních prvkù
ENTER
DEL
SAVE      ebro_saveEditRow
*/


CLASS drgEBrowse FROM deBrowse
  EXPORTED:
    var     state , isAppend, odata, isAddData
    method  create, addDesc , saveEditRow

    *
    **
    inline method X_loadEditRow( newRec, scrollArea )
      local  x, drgEd, ok, isEdit, nBeg := 1, ovar, value, type, xvalue
      *
      local  colPos         := ::oxbp:colPos
      local  recNo          := (::cfile)->(recNo())
      local  pa             := {}
      local  odbrowse       := ::drgDialog:odbrowse
      local  cmp_rowCount   := int(::oxbp:getColumn(1):dataArea:currentSize()[2] / (drgINI:fontH -2))
      local  rowPos         := edit_rowPos := ::oxbp:rowPos
      local  is_inBro       := (::drgDialog:oForm:olastDrg:className() = 'drgEBrowse')
      *
      local  last_ok_rowPos := ::last_ok_rowPos
      local  last_ok_recNo  := ::last_ok_recNo
      *
      local  c_className, drgPush
      local  nEvent, mp1, mp2, oXbp

      default newRec     to  .f., ;
              scrollArea to  .f.

      * pøechod do editaèního režimu, musíme zanulovat ::oseek
      if(isobject(::oseek), ::oseek:setData(''), nil)
      ::oxbp:GetVScrollObject():disable()

      if .not. scrollArea
        ::getRecord()
        ::oxbp:deHilite()
        ::oxbp:cursorMode := XBPBRW_CURSOR_NONE
      endif


      for x := 1 to len(::ardef) step 1
        drgEd   := ::ardef[x]

        if drgEd.drgEdit:className() <> 'drgText'
              ok := if( ismethod(drgEd.drgEdit, 'preValidate'), drgEd.drgEdit:preValidate(.f.), .t.)

          drgEd.drgEdit:isEdit := ok

          isEdit := ( ok .and. if( newRec,  drgEd.drgEdit:isEdit, ;
                                          ( drgEd.drgEdit:isEdit .and. drgEd.drgEdit:isedit_inrev)))

          drgEd.drgEdit:isEdit := isEdit
          aadd(pa, isEdit )
        endif

        isEdit := .f.
        aEval( pa, { |e| if( e, isEdit := .t., nil ) } )
      next

      * INS - nebo KEY_DOWN
      if newRec
        if lastAppEvent(@mp1,@mp2,@oXbp) = xbeP_Keyboard

          * máme k dispozici volný øádek gridu ?
          if .not. ( cmp_rowCount >= ::oxbp:rowPos +1 .and. cmp_rowCount >= ::oxbp:rowPos )
            * ne musíme zarolovat na rowPos     -- budeme editovat
            PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_NextLine,, ::oxbp )
            ::oxbp:refreshCurrent()
            ::oxbp:refreshAll()
          else
            * ano máme jen zvedneme na rowPos++ -- budeme editovat
            * ale jen pokud má grid data ...
            if( (::cfile)->(eof()), nil, ::oxbp:rowPos++ )
          endif
        else
          * musíme odrolovat od rowPos ... rowCout -1 jen pokud máme nìjaká data
          ::pa_rowsData := {}

          if .not. (::cfile)->(eof())
            begin sequence
              for x := rowPos to ::oxbp:rowCount-1 step 1
                ::oxbp:deHilite()
                ::oxbp:rowPos++
                ::oxbp:refreshCurrent()

                ::oxbp:cursorMode := XBPBRW_CURSOR_ROW
                aadd( ::pa_rowsData, { ::oxbp:rowPos, ::oxbp:getData() })
                ::oxbp:cursorMode := XBPBRW_CURSOR_NONE

                (::cfile)->(dbskip())
                if (::cfile)->(eof())
            break
                endif
              next
            end sequence
            ::last_ok_rowPos := last_ok_rowPos
            ::last_ok_recNo  := last_ok_recNo
            ::oxbp:rowPos    := edit_rowPos

            ::oxbp:GetVScrollObject():disable()
          endif

        endif
      else
        isEdit := .f.
        aEval( pa, { |e| if( e, isEdit := .t., nil ) } )
        if( .not. isEdit, nBeg := len(::ardef) +1, nil)
      endif

*******************
* pozor, tohle je varianta, kdy na FRM u EBrowse jsou prvky, které nejsou
* souèástí EBro, nedocházelo k jejich správnému naètení
      ::drgDialog:dataManager:refresh()

      ::edit_row := if( rowPos = nil, ::oxbp:rowPos, rowPos)
*******************

      for x := 1 to ::oxbp:colCount step 1
        setAppFocus(::oxbp)
        *
        ocolumn     := ::oxbp:getColumn(x)
        aRect       := oColumn:dataArea:cellRect( ::oxbp:rowPos )
        aPos        := { aRect[1], aRect[2] }
        aSize       := { aRect[3]-aRect[1], aRect[4]-aRect[2] }

        drgEd       :=  oColumn:defColum
        c_className := drgEd.drgEdit:className()

        if isObject( drgEd.drgEdit) .and. oColumn:isVisible()

          if newRec
            ovar := drgEd.drgEdit:ovar
            ovar:prevValue := ovar:initValue := ovar:value := drgEd.drgEmpty
            if( ovar:oDrg != NIL, ovar:oDrg:refresh( drgEd.drgEmpty ), nil )
          endif

          do case
          case c_className = 'drgText'
            if oColumn:type = XBPCOL_TYPE_BITMAP
            else
              ( aPos[2] += 2, aSize[2] -= 2 )
              drgEd.drgEdit:oxbp:setPosAndSize( aPos,aSize, .t. )
            endif

          case c_className = 'drgCheckbox'
*            ( apos[1] := int(aSize[1]/2) -6, apos[2] += 3 )

            drgEd.drgEdit:oxbp:setPosAndSize( aPos, aSize, .t. )

            if ismethod(drgEd.drgEdit, 'preValidate')
              drgEd.drgEdit:isEdit := drgEd.drgEdit:preValidate()
            endif
            if( drgEd.drgEdit:isEdit, drgEd.drgEdit:oxbp:enable(), drgEd.drgEdit:oxbp:disable())

          otherwise
            drgEd.drgEdit:oxbp:setPosAndSize( aPos, aSize, .t. )

            if( ismethod(drgEd.drgEdit, 'preValidate'), drgEd.drgEdit:preValidate(.f.), nil)
            if( drgEd.drgEdit:isEdit, drgEd.drgEdit:oxbp:enable(), drgEd.drgEdit:oxbp:disable())
          endcase

          drgEd.drgShow := isEdit
        endif
      next

      if isEdit
        _clearEventLoop()
        if scrollArea
        * pokud odroluje zùstavá v pùvodní režimu vstupu state se NEMÌNÍ !!!
        else
          if( newRec  , ::state := _doAppend, ::state := _doEdit     )
        endif
        if( scrollArea,                  nil, ::setEditItem( newRec ))
      else
        ::setBroFocus()
      endif
      return

    *
    ** na 1. editaèní sloupec /na aktivní editaèní sloupec
    inline method setEditItem(do_1_Edit)
      local  ocolumn  := ::oxbp:getColumn(::oxbp:colPos) , ;
             colCount := ::oxbp:colCount, npos, x, ok := .f., drgEdit, ;
             b_afterAppend, new_colPos

      if ::state = _doAppend .or. (::cfile)->(eof())
        if isBlock(b_afterAppend := ::drgDialog:getMethod(,'ebro_afterAppend'))
           if isNumber(new_colPos := eval(b_afterAppend, self))
             do_1_Edit     := .f.
             ocolumn       := ::oxbp:getColumn(new_colPos)
             ::oxbp:colPos := new_colPos
           endif
        endif
      endif

      if .not. do_1_Edit
        npos := ascan(::ardef, {|a| a.drgColum = ocolumn })
        ok   := ::ardef[npos].drgEdit:isEdit .and. ocolumn:isVisible()
      endif

      if .not. ok
        begin sequence
          for x := ::oxbp:colPos to colCount step 1
            ocolumn := ::oxbp:getColumn(x)
            npos    := ascan(::ardef, {|a| a.drgColum = ocolumn })
            if ::ardef[npos].drgEdit:isEdit .and. ocolumn:isVisible()
        break
            endif
          next
        end sequence
      endif

/*
      if (::drgDialog:oForm:olastDrg:className() = 'drgEBrowse')
      else
        ::drgDialog:oForm:olastDrg := ::ardef[npos].drgEdit
      endif
*/

      drgEdit := ::ardef[npos].drgEdit
      postAppEvent(drgEVENT_OBJENTER,,,drgEdit:oxbp)
      setAppFocus(drgEdit:oxbp)
    return
    *
    **
    inline method killEditRow()
      local arDef := ::arDef
      aeval( arDef, { |i| i.drgEdit:oxbp:setSize( {0,0}, .t.) } )
      aeval( arDef, { |i| if( isObject(i.drgPush), i.drgPush:oxbp:hide(), nil ) } )
      return
    *
    **
    inline method setBroFocus()
      local  df := ::drgDialog:oForm, members, pos
      *
      local  rowPos := ::oxbp:rowPos
      local  colPos := ::oxbp:colPos

      ::killEditRow()
      _clearEventLoop(.t.)
      ::oxbp:cursorMode := XBPBRW_CURSOR_ROW
      ::oxbp:refreshCurrent()
      *
      postAppEvent(xbeBRW_ItemMarked, rowPos,colPos,::oXbp:getColumn(colPos):dataArea)
      setAppFocus(::oxbp)
      *
      members := df:aMembers
      pos     := ascan(members, {|x| x = self})
      df:olastdrg   := self
      df:nlastdrgix := pos
      df:olastdrg:setFocus()
      ::state := _inBrow
    return
    **
    *
    **
    method  eventHandled
    *
    **
    inline method comboBox_col(oDrg)
      local  value := DBGetVal(odrg:name), pos, retVal := ''

      pos    := AScan(odrg:values, { |a| a[1] = value })
      retVal := if(pos = 0, '', odrg:values[pos,2])
    return retVal

    inline method checkBox_col(odrg)
      local  value := if(left(odrg:name,3) = 'M->', eval(odrg:ovar:block), DBGetVal(odrg:name))

      if isNumber(value)
        value := if( value = 0, .f., .t.)
      endif
      return if( value, 427, 0 )

  HIDDEN:
    method postValidateRow

    var    ebro_postAppend, edit_row, pa_rowsData, ebro_atStart
    var    isEdit_Color, noEdit_Color

    inline method enabled_ins()
      local  b_beforeAppend := ::drgDialog:getMethod(,'ebro_beforeAppend')
      local  ok := .t.

      if ::last_ok_rowPos <> ::oxbp:rowPos
        return .f.
      endif

      if .not. ::enabled_ins
        return .f.
      else
         if(isBlock(b_beforeAppend), ok := EVAL(b_beforeAppend, self), nil)
         return (::enabled_ins .and. ok)
      endif
    return ok

    inline method getRecord()
      local astru := (::cfile)->(dbstruct()), orecord := ::odata

      aeval(astru,{|a,i| orecord:&(a[1]) := (::cfile)->(fieldget(i)) })
    return

    inline method checkDataPos(nkey)
      local recNo := (::cfile)->(recNo()), ok := .t., nskip

      nskip := if( nkey = xbeK_UP, -1, 1)
      (::cfile)->(dbskip(nskip))

      ok := .not. (::cfile)->(eof())
      ok := ok .and. .not. (::cfile)->(bof())

      (::cfile)->(dbgoto(recNo))
    return ok

    inline method  createExtColumn(oColumn,oDrg)
      local  type := oDrg:className()

      do case
      case( type = 'drgCombobox')
        oColumn:dataLink := { || ::comboBox_col(oDrg) }

      case( type = 'drgcheckbox')
         oColumn:dataLink := { || ::checkBox_col(oDrg) }

      endcase
    return
ENDCLASS


method drgEBrowse:create(oDesc)
  local  odrg

  ::deBrowse:create(oDesc)
  aeval(::ardef, {|x| asize(x,12)})

  if ::oxbp:getColumn(1):defColum[2] = "M->deBrowse_indicateRow"
     oDrg           := _drgText():new()
     oDrg:name      := "M->deBrowse_indicateRow"
     oDrg:cLen      :=  2
     oDrg:caption   :=  ''
     oDrg:isbit_map := .t.

     ::addDesc(oDrg)
  endif

  ::isContainer  := .t.
  ::state        := _inBrow
  ::odata        := ebro_record( 'ebro_' + ::cfile, ::cfile):new()

  ::isEdit_Color := graMakeRGBColor( { 198, 255, 213 } )
  ::noEdit_Color := XBPSYSCLR_3DFACE

  ::ebro_postAppend := ::drgDialog:getMethod(,'ebro_postAppend')
return self


method drgEBrowse:addDesc(oDesc)
  local  oColumn, oDrg, oBord, name
  *
  local  aPos, aSize, oDrg_pb
  local  colPos, c_col, c_edt, isPush, cPush
  local  isMle := .f.
  *
  local  value, type, xvalue, npos

  oDesc:caption := oDesc:fcaption := NIL

  begin sequence
    for colPos := 1 to ::oxbp:colCount step 1
      oColumn := ::oxbp:getColumn(colPos)
      c_col   := listAsArray(oColumn:frmColum,':')[1]
      c_edt   := oDesc:name
      if lower(c_col) = lower(c_edt)
  break
      endif
    next
  end sequence

  ** musíme zmìnit type na XBPCOL_TYPE_ICON
  do case
  case oDesc:type = 'checkbox'
    oColumn:type := XBPCOL_TYPE_ICON
    oColumn:configure()
  endcase

  oBord      := xbpStatic():new(oColumn:dataArea,,{1,1},{1,drgINI:fontH -8},,.f.)
  oBord:type := XBPSTATIC_TYPE_RECESSEDBOX
  oBord:create()

  ::ardef[colPos].drgBord := oBord

  oDesc:fpos := {0,0}
  oDesc:cpos := {0,0}
  if((isMle := oDesc:type = 'mle'), oDesc:size := {0,1.2}, nil)

  name       := '{ |a| ' + 'drg' + oDesc:type + '():new(a) }'
  oDrg       := eval(&name, self:parent)
  oDrg:create(oDesc)
  *
  * u GETu klauzue NOREVISION *
  if odrg:isDerivedFrom('drgObject') .and. isMemberVar(odesc, 'isedit_inrev')
    odrg:isedit_inrev := IsNull(odesc:isedit_inrev,.T.)
  endif

  do case
  case oDrg:className() = 'drgText'
    oDrg:oxbp:setParent( oColumn:dataArea )
**    oDrg:oxbp:options := XBPSTATIC_TEXT_CENTER
**    oDrg:oxbp:configure()

  case oDrg:className() = 'drgCheckBox'
    oDrg:oxbp:setParent ( oColumn:dataArea )
    oDrg:oxbp:setCaption('')

  otherwise
    oDrg:oxbp:setParent(oColumn:dataArea)
  endcase

  oColumn:dataArea:cargo := self
  oDrg:oxbp:cargo        := self
  AAdd(self:parent:aMembers, oDrg)

  *
  ::ardef[colPos].drgEdit  := oDrg
  ::ardef[colPos].drgIx    := ascan(self:parent:aMembers, odrg)
  ::ardef[colPos].drgShow  := .f.
  ::ardef[colPos].drgColum := oColumn

  * Create drgPushButton if push != NIL only for GET and MEMO
  isPush := isMemberVar(oDesc, 'PUSH')
   cPush := NIL

  do case
  case isMle
    cPush := 'ebro_memEdit'
  case   isMemberVar(oDesc, 'PUSH')
    cPush := if( isDate(oDrg:oVar:get()), 'CLICKDATE', oDesc:push )
  endcase

  ::createExtColumn(oColumn,oDrg)

  if isPush
    if cPush != NIL .or. oDrg:IsrelTO .or. IsDATE(oDrg:oVar:get())
      name    := '{ |a| ' + 'drgPushButton():new(a) }'
      oDrg_pb := EVAL(&name,self:parent)

      aPos    := oDrg:oxbp:currentPos()
      aSize   := oDrg:oxbp:currentSize()
      aPos[1] += aSize[1] -aSize[2] -2
      aPos[2] += 1

      if isMle
        oDrg_pb:create(aPos,{aSize[2] +1,aSize[2] -3}, 1, DRG_ICON_EDIT,,,,, cPush,,,IF(ISNIL(cPush),oDrg, NIL ))
        oDrg_pb:oXbp:setParent(oColumn:dataArea)
      else
        oDrg_pb:create(aPos,{aSize[2] +1,aSize[2] -3},4,,,,'...',,cPush,,,IF(ISNIL(cPush),oDrg, NIL ))
//        oDrg_pb:oXbp:setParent( odrg:oxbp )
        oDrg_pb:oXbp:setParent( oColumn:dataArea )
      endif

      oDrg_pb:isEdit     := .F.
      oDrg_pb:oXbp:cargo := oDrg
      oDrg:pushGet       := oDrg_pb

      AAdd(self:parent:aMembers, oDrg_pb)

      ::ardef[colPos].drgPush := oDrg_pb
    endif
  endif

  oDrg:oxbp:setSize( { 0,0 }, .f. )
  *
  ** barva prvku
  if isMembervar( oDrg, 'isEdit' )
    oDrg:oxbp:setColorBG( if( oDrg:isEdit, ::isEdit_Color, ::noEdit_Color ))
  endif

  if isMembervar( oDrg, 'oBord')
    oDrg:oBord:setSize( { 0,0 }, .f. )
    oDrg:oBord:setColorBG( ::isEdit_Color )
  endif

  if( isMembervar( oDrg, 'clrFocus'), oDrg:clrFocus := ::isEdit_Color, nil )
  *
  ** empty value for INS
  if isMemberVar( oDrg, 'ovar' )
    value  := oDrg:ovar:value
    type   := valType( value )

    xvalue := if( type = 'C' .or. type = 'M', space( len( value)), ;
               if( type = 'D', ctod('')                          , ;
                if( type = 'L', .f.                              , ;
                 if( type = 'N', 0, nil                            ))))

    if type = 'N'
      if (npos := at('.', value := str( value ))) <> 0
        xValue := val( '0.' +replicate( '0', len(value) - npos))
      endif
    endif

    ::ardef[colPos].drgEmpty := xValue
  endif
return

*
method drgEBrowse:eventHandled(nEvent, mp1, mp2, oxbp)
  local  odbrowse := ::drgDialog:odbrowse, ocolumn
  *
  local  nPos, aPos, aSize, drgEdit, drgPush, nstp, pa
  local  df := ::drgDialog:oForm, x, nend, nstep
  local  members, pos, recNo := if((::cfile)->(eof()), 0, (::cfile)->(recNo()) )
  *
  local  enabled_ins, curr_colPos, colPos, rowPos
  local  cmp_rowCount := int(::oxbp:getColumn(1):dataArea:currentSize()[2] / (drgINI:fontH -2))
  local  isdeHilite
  local  isEof        := (::cfile)->(eof())
  local  nclr         := GraMakeRGBColor( {201, 210, 245} )
  *
  local  nevent_n := mp1_n := mp2_n := oxbp_n := nil


  if isNull(::ebro_atStart)
    aeval( odbrowse, { |o| if( o = self, nil, o:oxbp:lockUpdate(.t.) ) })
    aeval( odbrowse, { |o| o:oxbp:panHome() } )
    aeval( odbrowse, { |o| if( o = self, nil, o:oxbp:lockUpdate(.f.) ) })

    ::ebro_atStart := 99
  endif

       curr_colPos := ::oxbp:colPos
  x := colPos      := ::oxbp:colPos
       rowPos      := ::oxbp:rowPos

  if( nEvent = drgEVENT_ACTION .and. isNumber(mp1), nEvent := mp1, nil )

  do case
  case nevent = xbeP_PresParamChanged
    return .t.

  case( ::state <> _inBrow .and. ( nPos := ascan(::ardef, {|x| x.drgEdit:oxbp = oxbp})) <> 0 )
    drgEdit := ::ardef[nPos].drgEdit
    drgPush := ::ardef[nPos].drgPush

    do case
    case(nEvent = drgEVENT_OBJEXIT .or. nEvent = drgEVENT_OBJENTER)

      pa := ::ardef[npos]
      if(isObject(pa.drgPush), pa.drgPush:oxbp:hide(), nil)

      if nextAppEvent( @mp1_n, @mp2_n, @oxbp_n) = xbeP_Keyboard
        if( mp1_n = xbeK_ENTER .and. oxbp = oxbp_n )
          _clearEventLoop(.t.)
          postAppEvent( xbeP_Keyboard , mp1_n, mp2_n, oxbp_n)

          nEvent := drgEVENT_OBJEXIT
        endif
      endif

      aRect   := pa.drgColum:dataArea:cellRect( ::oxbp:rowPos )
      aPos    := { aRect[1], aRect[2] }
      aSize   := { aRect[3]-aRect[1], aRect[4]-aRect[2] }

      if nEvent = drgEVENT_OBJENTER

        if isObject(drgPush := ::ardef[nPos].drgPush)
          if .not. (drgPush:disabled)
            aPos  := drgEdit:oxbp:currentPos()
            aSize := drgEdit:oxbp:currentSize()

            if drgPush:oxbp:parent:className() = 'XbpGet'
              aPos[1] := aSize[1] -22
              aPos[2] := 0
            else
              aPos[1] += aSize[1] -aSize[2] -2
              aPos[2] += 1
            endif

            drgPush:oxbp:setPos ( aPos  )
            drgPush:oxbp:show()
            drgPush:frameState := 1
          endif
        endif

        df:nextFocus := ascan(df:aMembers, {|a| a = drgEdit })
      else

        if(isObject(pa.drgPush), pa.drgPush:oxbp:hide(), nil)
      endif

** BEG **
      if (nEvent = drgEVENT_OBJEXIT)
        if( df:nexitState = GE_UP, (nend := 1              , nstep := -1), ;
                                   (nend := ::oxbp:colCount, nstep :=  1)  )

        begin sequence
          for x := colPos+nstep to nend step nstep
            ocolumn := ::oxbp:getColumn(x)
            npos    := ascan(::ardef, {|a| a.drgColum = ocolumn })
            if ::ardef[npos].drgEdit:isEdit .and. ocolumn:isVisible()
        break
            endif
          next
        end sequence

        drgEdit := ::ardef[npos].drgEdit
        df:nextFocus := ascan(df:aMembers, {|a| a = drgEdit })

        * poslední ED prvek
        if x > ::oxbp:colCount
          recNo := if((::cfile)->(eof()), 0, (::cfile)->(recNo()) )

          begin sequence
            for x := 1 to len(::ardef) step 1
              if ::ardef[x].drgEdit:isEdit
          break
              endif
            next
          end sequence
          ::oxbp:colPos := x

          ::saveEditRow()
          ::oxbp:scrollPanel( 1 )

          if .not. ::enabled_insCykl
            ::setBroFocus()
            return .t.
          endif

          if ::state =  _doEdit
            (::cfile)->(dbskip())

            if (::cfile)->(eof())
              postAppEvent(xbeP_Keyboard,xbeK_ESC,,drgEdit:oxbp)
            else
              _clearEventLoop(.t.)
              postAppEvent(xbeP_Keyboard, xbeK_DOWN,, if((::cfile)->(eof()), ::oxbp, oXbp))
            endif

            (::cfile)->(dbgoto(recNo))
            return .t.
          else
            if ::enabled_ins()
              isRefresh := .f.
                  recNo := (::cfile)->(recNo())
              ///
              (::cfile)->(dbskip())

               * jsme na konci, pøidáme nový øádek
               if (::cfile)->(eof())
                 postAppEvent(xbeP_Keyboard, xbeK_DOWN,, if((::cfile)->(eof()), ::oxbp, oXbp))
                 (::cfile)->(dbgoto(recNo))

               * nejsme na konci, co vèil
               else

                 if( isRefresh, nil, ::oxbp:refreshAll() )
                 PostAppEvent(drgEVENT_ACTION, drgEVENT_APPEND,, ::oXbp)
               endif

               return .t.
            endif
          endif
          return .t.
        endif

      colPos   := 1
      drgEdit  := ::ardef[npos].drgEdit
      do while ::ardef[npos].drgColum <> ::oxbp:getColumn(colPos)
        colPos++
      enddo

      * seznam viditelných/neviditelných sloupcù
      ::oxbp:colPos := colPos
      ::ocurCol     := ::oxbp:getColumn(colPos)
      ::setVisibleCols()

      if .not. ::paCols[colPos,4]
        ::oxbp:scrollPanel( colPos, (curr_colPos < colPos) )
        *
        ** musíme pøezobrazit editaèní øádek
        postAppEvent(drgEVENT_OBJENTER,,,drgEdit:oxbp)
        setAppFocus(drgEdit:oxbp)
      endif


      if isObject(drgPush := ::ardef[nPos].drgPush)
        if .not. (drgPush:disabled)
          aPos  := drgEdit:oxbp:currentPos()
          aSize := drgEdit:oxbp:currentSize()

          if drgPush:oxbp:parent:className() = 'XbpGet'
            aPos[1] := aSize[1] -22
            aPos[2] := 0
          else
            aPos[1] += aSize[1] -aSize[2] -2
            aPos[2] += 1
          endif

          drgPush:oxbp:setPos ( aPos  )
          drgPush:oxbp:show()
          drgPush:frameState := 1
        endif
      endif
    endif
** END **

    case(nevent = drgEVENT_SAVE)
      ::saveEditRow(.t.)
      return .t.

    case(nEvent = xbeP_Keyboard)
      do case
      case(mp1 == xbeK_UP .or. mp1 == xbeK_DOWN)

        if oxbp:className() = 'XbpCombobox' .or. oxbp:className() = 'XbpDrgCombobox'
          if oxbp:listBoxFocus()
            return .f.
          endif
        endif

        if ::state = _doEdit
*          ::saveEditRow()
          ::oxbp:cursorMode := XBPBRW_CURSOR_NONE

          if ::checkDataPos(mp1)
            rowPos := ::oxbp:rowPos +if( mp1 == xbeK_UP, -1, +1)
            postAppEvent(xbeBRW_ItemMarked,rowPos, 1, ::oxbp:getColumn(::oxbp:colPos):dataArea)
          else
            *
            ::saveEditRow()
            *
            if ::oxbp:rowPos = 1 .and.  mp1 == xbeK_UP
            else
              ::oxbp:refreshCurrent()
              postAppEvent(xbeP_Keyboard, xbeK_DOWN,,::oxbp)
            endif
          endif
        else

          postAppEvent(xbeP_Keyboard,xbeK_ESC,,drgEdit:oxbp)
        endif
        return .t.

      case mp1 == xbeK_ESC
        if ::state <> _inBrow

          ::killEditRow()

          rowPos := isNull(::last_ok_rowPos, ::oxbp:rowPos )
          colPos := ::oxbp:colPos

          * stojíme mimo zobrazená data ?
          if( ::last_ok_recNo = 0, (::cfile)->(dbgoTop()), ;
                                   (::cfile)->(dbgoTo( ::last_ok_recNo )) )

          ::oxbp:rowPos := ::last_ok_rowPos
          ::oxbp:refreshAll()
          ** new
          ::oxbp:cursorMode := XBPBRW_CURSOR_ROW
          ::oxbp:refreshCurrent()

          ** master - detail
          if isblock(::itemMarked)
            ::state := _inBrow
            eval(::itemMarked,{::oxbp:rowPos,::oxbp:colPos},,::oxbp)
            aeval(odbrowse, {|x| if( x = self, nil, x:oxbp:refreshall() )})
          endif

          _clearEventLoop(.t.)
          ::state := _inBrow

          setAppFocus(::oxbp)
          *
          members := df:aMembers
          pos     := ascan(members, {|x| x = self})
          df:olastdrg   := self
          df:nlastdrgix := pos
          df:olastdrg:setFocus()
          *
          ::drgDialog:dataManager:refresh()
          return .t.
        endif

      case mp1 == xbeK_F4
        if isObject(drgPush)
          drgPush:activate(.f.)
          return .t.
        endif

      case mp1 = xbeK_RETURN .and. oxbp:className() = 'xbpMle'
        postAppEvent(xbeP_Keyboard,xbeK_TAB,,oxbp)
        return .t.
      endcase

      return .f.
    endcase

*
********************************************************************************
** pohyb v BRO
** pøechod do editaèního zežimu
*
  case((nevent = drgEVENT_APPEND .and. ::enabled_ins()) .or.  ;
       (nevent = drgEVENT_EDIT   .and. ::enabled_enter) .or.  ;
       (nevent = xbeP_Keyboard   .and. ::enabled_ins())       )

    do case
    case isEof
      if( nevent = drgEVENT_APPEND .or. nevent = drgEVENT_EDIT )
        ::oxbp:scrollPanel(1)
        ::oxbp:colPos := 1
        ::X_loadEditRow(.t.)
      else

        return ::deBrowse:handleEvent(nEvent, mp1, mp2, oxbp)
      endif

    otherWise
      do case
      case nevent = drgEVENT_APPEND
        ::oxbp:scrollPanel(1)
        ::oxbp:colPos := 1
        ::X_loadEditRow(.t.)

      case nevent = drgEVENT_EDIT
        ::X_loadEditRow()

      case nevent = xbeP_Keyboard
        do case
        case mp1 = xbeK_UP   .and. ::oxbp:rowPos = 1
          return .f.

        case mp1 = xbeK_DOWN .and. isNull( ::oxbp:getColumn(1):getRow( ::oxbp:rowPos +1))
          ::oxbp:scrollPanel(1):refreshCurrent()
          ::oxbp:colPos := 1
          ::X_loadEditRow(.t.)

        otherWise
          return ::deBrowse:handleEvent(nEvent, mp1, mp2, oxbp)

        endCase
      endCase
    endcase
    return.t.

  case(nevent = drgEVENT_DELETE)
    if ::enabled_del  ;  return .f.
    else              ;  return .t.
    endif

  case( ::state <> _inBrow)
    do case
    case(nevent = xbeBRW_ItemMarked )

      if oxbp:className() <> 'XbpBrowse'
        if ::state = _doEdit
          ::saveEditRow()
          ::killEditRow()
        else
          ::killEditRow()

          rowPos := isNull(::last_ok_rowPos, 1)
          ::oxbp:goTop():forceStable()

          for x := 1 to rowPos -1 step 1  ; ::oxbp:down() ;  next
        endif
      endif

      if(isobject(::oseek), ::oseek:setData(''), nil)

      if oxbp:className() = 'XbpBrowse'
        if isblock(::itemMarked)
          eval(::itemMarked,{::oxbp:rowPos,::oxbp:colPos},,::oxbp)
          aeval(odbrowse, {|x| if( x = self, nil, x:oxbp:refreshall() )})
        endif

        if ::state = _doEdit
          postAppEvent(drgEVENT_ACTION, drgEVENT_EDIT,, ::oXbp)
        else
          ::setBroFocus()
        endif
        return .t.
      endif

      if oxbp:className() = 'XbpCellGroup'
        if ::edit_row = mp1
          npos := ascan(::ardef, {|a| a.drgColum = oxbp:parent })

          if .not. ::ardef[npos].drgEdit:isEdit
            postAppEvent(drgEVENT_ACTION, drgEVENT_EDIT,, ::oXbp)
            return .t.
          endif
        endif
      endif

      ::oxbp:dehilite()
      ::oxbp:cursorMode := XBPBRW_CURSOR_NONE
      return .f.
    endcase

  otherwise

    return ::deBrowse:handleEvent(nEvent, mp1, mp2, oxbp)

  endcase
return .f.


method drgEBrowse:postValidateRow()
  local  x, drgEdit

  for x := 1 to len(::ardef) step 1
    drgEdit := ::ardef[x].drgEdit
    if drgEdit:isEdit

*      if drgEdit:ovar:changed()
        if !drgEdit:postValidate(.t.)
          drgEdit:setFocus()
          return .f.
        endif
*      endif

    endif
  next
return .t.


method drgEBrowse:saveEditRow(isStopEdit)
  local   b_beforSaveEditRow    := ::drgDialog:getMethod(,'ebro_beforSaveEditRow')
  local   b_afterAppendBlankRec := ::drgDialog:getMethod(,'ebro_afterAppendBlankRec')
  local   b_saveEditRow         := ::drgDialog:getMethod(,'ebro_saveEditRow')
  local   is_dbLocked           := (::cfile)->(dbLocked())
  local   ok                    := .t., rowPos, rowCount
  local   lnewRec               := .f.

** TT **
** return .t.

  default isStopEdit to .f.

  if ::postValidateRow() .and. if( isBlock(b_beforSaveEditRow), eval(b_beforSaveEditRow), .t. )
    ::isAppend  := ( ::state = _doAppend .or. (::cfile)->(eof()))
    ::isAddData := isNull( ::oxbp:getColumn(1):getRow( ::oxbp:rowPos))

    if ::state = _doAppend .or. (::cfile)->(eof())
      (::cfile)->(dbAppend())
      if(isBlock(b_afterAppendBlankRec), EVAL(b_afterAppendBlankRec, self), nil)

      lnewRec    := .t.
**      isStopEdit := ( .not. ::enabled_insCykl )
    endif

    ok := if( is_dbLocked, .t., (::cfile)->(dbRlock()))

    if ok
      aeval(::ardef, {|a| a.drgEdit:ovar:save() })

      (::cfile)->(dbcommit())

      if(isBlock(b_saveEditRow), EVAL(b_saveEditRow, self), nil)

      if( is_dbLocked, nil, (::cfile)->(dbunlock()))
*
*
      if ::state = _doAppend
        ::oxbp:colPos := 1
        ::oxbp:configure()
        ::oxbp:refreshAll()
      else
        ::oxbp:refreshCurrent()
      endif

      if( isStopEdit, ::setBroFocus(), nil)
**      if( isStopEdit .and. lnewRec, ::state := _doEdit, nil )
    endif
  endif
return .t.


*
** volá tøídu ebro_memoEdit v drgBrowse_.prg
function ebro_memEdit(drgDialog)
  local odialog, odrg
  *
  local nEvent, mp1, mp2, oXbp, value, name

*  nEvent := mp1 := mp2 := oXbp := odrg := nil

  nEvent  := LastAppEvent(@mp1,@mp2,@oXbp)
  name    := oXbp:cargo:name

  odialog       := drgDialog():new('EBRO_MEMOEDIT', drgDialog)
  odialog:cargo := name
  odialog:create(,,.T.)
  *
  value := odialog:dataManager:get(name)
  *
  if isobject(odrg := drgDialog:dataManager:has(name))
    odrg:set(value)
    odrg:value := value
  endif
  odialog:destroy()
  odialog := nil
return .t.

*
**
static function ebro_record(cVarName,cfile)
  LOCAL aIVar, oClass, nAttr

  oClass := ClassObject(cVarName)

  IF oClass <> NIL
    RETURN oClass                 // Class already exists
  ENDIF

  nAttr   := CLASS_EXPORTED + VAR_INSTANCE
  aIVar   := AEval( (cfile)->(DbStruct()), {|a| a:={a[1], nAttr} } ,,, .T.)
  nAttr   := CLASS_EXPORTED + METHOD_INSTANCE
return classCreate( cVarName,, aIVar )


static function GetRecord( oRecord,cfile)
  local astru := (cfile)->(dbstruct())

  aeval(astru,{|a,i| orecord:&(a[1]) := (cfile)->(fieldget(i)) })
return oRecord
**
*