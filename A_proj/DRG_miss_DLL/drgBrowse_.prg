#pragma Library( "XppUI2.LIB"  )
#pragma Library( "ADAC20B.LIB" )


#include "Appevent.ch"
#include "Common.ch"
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


FUNCTION GetCursorPos()
  LOCAL sPoint := REPLICATE(CHR(0),8)
  LOCAL nX     := 0
  LOCAL nY     := 0

  STATIC GetCursorPos

   IF GetCursorPos = NIL
      GetCursorPos := DllPrepareCall("user32.dll",DLL_STDCALL,;
                                                 "GetCursorPos")
   ENDIF
   DllExecuteCall(GetCursorPos,@sPoint)

   nX := BIN2L(SUBSTR(sPoint,1,4))
   nY := BIN2L(SUBSTR(sPoint,5,4))

   nY := (- 1 * nY)+APPDESKTOP():CURRENTSIZE()[2] - 1      // from Top to Down
RETURN ({nX,nY})



function de_browseContext(obj, ix, nMENU)
return {|| obj:fromContext( ix, nMENU) }


CLASS xbpDrgColumn FROM xbpColumn
  EXPORTED:
  var       frmColum, sumColum, sumValue, picColum, reqColum, defColum, currSize

  inline method init( oParent, oOwner, aPos, aSize, aPP, lVisible )
    ::xbpColumn:init( oParent, oOwner, aPos, aSize, aPP, lVisible )

    ::frmColum       := ''
    ::sumColum       := 0
    ::sumValue       := 0
    ::picColum       := ''
    ::reqColum       := .t. // povinný sloupec, nelze uživatelem vyjmout z BRO
    ::defColum       := {}
    ::currSize       := ::currentSize()
    return self

  inline method configure(oParent,oOwner,aPos,aSize,aPresParam,lVisible)
    local  frmColum  := ::frmColum
    local  sumColum  := ::sumColum
    local  sumValue  := ::sumValue
    local  picColum  := ::picColum
    local  reqColum  := ::reqColum
    local  defColum  := ::defColum
    local  currSize  := ::currentSize()
    local  oColumn

    oColumn := ::xbpColumn:configure(oParent,oOwner,aPos,aSize,aPresParam,lVisible)
    oColumn:frmColum       := frmColum
    oColumn:sumColum       := sumColum
    oColumn:sumValue       := sumValue
    oColumn:picColum       := picColum
    oColumn:reqColum       := reqColum
    oColumn:defColum       := defColum
    oColumn:currSize       := ::currentSize()

    oColumn:setSize( currSize )
    return self

  inline method destroy()
    ::frmColum := NIL
    ::XbpColumn:destroy()
    return self
ENDCLASS

**
*
DLLFUNCTION SetCursorPos( nX, nY ) USING STDCALL FROM USER32.DLL
DLLFUNCTION GetCursor()            USING STDCALL FROM USER32.DLL
DLLFUNCTION SetCursor( hCursor)    USING STDCALL FROM USER32.DLL
*
**

*
** parent class for drgDBrowse - drgEBrowse
CLASS deBrowse FROM drgObject
  EXPORTED:
    var     nrecno , obord, cfile, dbarea, ardef, isfile, order, ordtype, ;
            scope_Button, scope_Direction
    var     cellBGC, toRecNo, atStart
    var     is_selAllRec, arselect
    var     autoShow_foot
    var     oico_Scope, oico_killScope

    method  create, createColumn, handleEvent, keyHandled, destroy, refresh, reSize
    method  createContext, fromContext, scope_Activate
    method  headLBdown, headMove
    method  stableBlock

    var     itemMarked, adbd, arfilter, oseek, paCols, ocurCol, stableBlock
    var     enabled_ins, enabled_insCykl, enabled_enter, enabled_del, enabled_sizeCols

    method  createInfo, setVisibleCols, maxbro

    var     ncurrRecNo
    var     noreqColum                // seznam nepovinných sloucù - C
    var     pa_toolTipText            // toolTipText - na hlavièce BRo

    var     last_ok_rowPos, last_ok_recNo


    inline access assign method deBrowse_indicateRow() var deBrowse_indicateRow
      local  recNo  := (::cfile)->(RECNO())

      do case
      case      ::is_selAllRec
        if ascan( ::arSelect, recNo) <> 0
          return 0
        else
          return 564
        endif

      case      len(::arSelect) <> 0
        if ascan( ::arSelect, recNo) <> 0
          return 564
        endif

      endcase
    return 0


    inline method getColumn_byName(cdefName)
      local  npos, defColum, ocol

      for npos := 1 to ::oxbp:colCount step 1
        defColum := ::oxbp:getColumn(npos):defColum
        if  lower(strTran( defColum.defName, ' ', '')) =  lower( strTran( cdefName, ' ', ''))
          return ::oxbp:getColumn(npos)
        endif
      next
    return ::oxbp:getColumn(1)   // jen pro jistotu 1, páè by nám to áflo


  HIDDEN:
    var     popupMenu, possible_indicateRow


    * xretVal - T -   vyøešil oznaèeni na UDCP
    *           F - nevyøešil oznaèeni na UDCP - lze použít na BRO
    inline method is_possible_indicateAllRow()
      local  xretVal, ok := .t.

      if ismethod(::drgDialog:udcp, 'post_bro_colourCodeAll')
        xretVal := ::drgDialog:udcp:post_bro_colourCodeAll()
      endif
    return .t.


    * xretVal - T -   vyøešil oznaèeni na UDCP
    *           F - nevyøešil oznaèeni na UDCP - lze použít na BRO
    * xretVal - 1 -   povolil oznaèení a sumaci na UDCP
    *           0 - nepovolil oznaèení a sumaci na UDCP
    inline method  is_possible_indicateRow()
      local xretVal, ok := .t.

      if ismethod(::drgDialog:udcp, 'post_bro_colourCode')
        xretVal := ::drgDialog:udcp:post_bro_colourCode()

        do case
        case( isLogical(xretVal) .and. xretVal )
          ::oxbp:refreshCurrent()
          return .t.

        case isNumber(xretVal)
          ok := ( xretVal = 1 )

        endcase
      endif

      if ok
        if(pos := ascan(::arselect,(::cfile)->(RECNO()))) = 0
           aadd(::arselect,(::cfile)->(RECNO()))
        else
          (adel(::arselect,pos), asize(::arselect,len(::arselect)-1))
        endif
        ::sumColumn()
        ::oxbp:refreshCurrent()
      endif
      return self

    inline method sumColumn()
      local  x, oColumn, nsign, xval, nval
      local  colCount   := ::oxbp:colCount
      *
      local  footHeight := if( len( ::arSelect) = 0, 0, drgINI:fontH -2)
      local  refreshAll := .f.

      if ::autoShow_foot

        for x := 1 to colCount step 1
          oColumn := ::oxbp:getColumn(x)

          if oColumn:sumColum = 1
            nsign := if( ascan( ::arSelect, (::cfile)->(recNo())) = 0, -1, +1)
            xval  := eval( oColumn:dataLink )

            oColumn:sumValue += if( isNumber(xval), xval, val( strTran( xval, ',', '.'))) * nsign

*            xval  := isNull( oColumn:getRow( ::oxbp:rowPos ), '' )

*            if .not. empty( oColumn:picColum)
*              nval := val( transForm( xval, oColumn:picColum))
*            else
*              nval := if( isNumber(xval), xval, val( xval) )
*            endif

*            oColumn:sumValue += nval * nsign
          endif

          do case
          case len( ::arSelect) = 0
            oColumn:sumValue := 0

            if oColumn:FooterLayout[XBPCOL_HFA_HEIGHT] <> 0
              footHeight := 0
            endif

          otherWise
            if oColumn:FooterLayout[XBPCOL_HFA_HEIGHT] = 0
              footHeight := drgINI:fontH -2
            endif
          endcase

          if oColumn:FooterLayout[XBPCOL_HFA_HEIGHT] <> footHeight
            refreshAll := .t.

            oColumn:lockUpdate(.t.)
            oColumn:FooterLayout[XBPCOL_HFA_HEIGHT] := footHeight
            oColumn:configure()
            oColumn:lockUpdate(.f.)
          endif

          if oColumn:sumColum = 1
            oColumn:footing:setCell(1, oColumn:sumValue)
            oColumn:footing:invalidateRect()
            oColumn:footing:show()
          endif
        next

        if refreshAll
          ::oxbp:lockUpdate(.t.)
          ::oxbp:configure()
          ::oXbp:refreshAll()
          ::oxbp:lockUpdate(.f.)
        endif
      endif
      return self

    inline method broColumn()
      local  odialog

      if lower(::drgDialog:formName) <> "sys_brocolumn"
        odialog := drgDialog():new('SYS_broCol_forAll', ::drgDialog )
        oDialog:cargo_usr :=  ::oxbp:cargo
        odialog:create(,,.T.)

*        odialog:destroy()
        odialog := nil
      endif
      return .t.


    inline method frmInfo()
      DRGDIALOG FORM 'SYS_frmInfo' PARENT ::drgDialog CARGO_USR self MODAL DESTROY
      return self

    inline method set_ndistrib(cdistrib)
      local c_sid_file := '', x
      local cStatement, oStatement
      *
      local stmt := "update " +::cfile +" set nDistrib = %distrib"

      do case
      case      ::is_selAllRec
      case len( ::arSelect) <> 0
        fordRec( { ::cfile } )

        for x := 1 to len( ::arSelect) step 1
          (::cfile)->( dbgoTo( ::arSelect[x]))

          c_sid_file += strTran( str( (::cfile)->sID), ' ', '') +','
        next
        fordRec()
        c_sid_file := left( c_sid_file, len( c_sid_file) -1)
        stmt       += " where sID IN(" +c_sid_file +")"
      otherWise
        c_sid_file += strTran( str( isNull((::cfile)->sID),0), ' ', '')
        stmt       += " where sID IN(" +c_sid_file +")"
      endcase

      cStatement := strTran( stmt, '%distrib', cdistrib )
      oStatement := AdsStatement():New(cStatement,oSession_data)

      if oStatement:LastError > 0
      *  return .f.
     else
       oStatement:Execute( 'test', .f. )
     endif

     oStatement:Close()

     (::cfile)->( dbunlock(), dbcommit() )
     return self

ENDCLASS


method deBrowse:create(oDesc)
  local  bBlock, aOrd, n, cAlias, x, aHead, sArea, aLen, aFld, oHlp, cFile, cName, arFreeze
  local  pa, pb, item, value, nF_column := 0
  *
  local  obord := ::parent:getActiveArea()
  local  size, asize, fpos, apos := {1,1}, app, adbd, initBlock, startBlock, oColumn
  local  apresParam, nin, ainfo_pos

  ::ncurrRecNo           := 0
  ::popupMenu            := .f.
  ::possible_indicateRow := .t.
  *
  drgLog:cargo     := 'Browse:AT START'
  ::is_selAllRec   := .f.
  ::arselect       := {}
  ::arfilter       := .f.
  ::toRecNo        := .f.
  ::atStart        := ''
  *
  ** set or modify GUILOOK for bro **
  ::enabled_ins    := ::enabled_insCykl := ::enabled_enter := ::enabled_del := ::enabled_sizeCols := .t.
  ::autoShow_foot  := (odesc:footer = 'yy')
  ::noreqColum     := oDesc:noreqColum
  ::pa_toolTipText := {}

  if .not. empty(odesc:guiLook)
    pa := listAsArray(odesc:guiLook)

    for x := 1 to len(pa) step 1
      pb    := listAsArray(pa[x], ':')
      item  := lower(pb[1])
      value := lower(pb[2])

      do case
      case( item = 'ins'      )
        if len(value) = 2 ; ::enabled_ins      := (left(value,1) = 'y')
                            ::enabled_insCykl  := if(::enabled_ins, right(value,1) ='y', .f.)
        else              ; ::enabled_ins      := (value = 'y')
                            ::enabled_insCykl  := (value = 'y')
        endif

      case( item = 'enter'    )  ;  ::enabled_enter    := (value = 'y')
      case( item = 'del'      )  ;  ::enabled_del      := (value = 'y')
      case( item = 'sizecols' )  ;  ::enabled_sizeCols := (value = 'y')
      case( item = 'headmove' )  ;  odesc:headMove     := value
      case( item = 'popummenu')  ;  odesc:popupMenu    := value
      endcase
    next
  endif

  * nemáme a nebudem dìlat enabled_enterCykl, jen to pøesetujeme
  if .not. ::enabled_ins .and. ::enabled_enter
    ::enabled_insCykl := .t.
  endif

  if(initBlock := ::drgDialog:getMethod(oDesc:browseInit,'browseInit') ) != NIL
    eval(initBlock, self)
  endif

* Position of the field on the screen
  size  := aclone(obord:currentSize())

* Size of a browser border in pixels
  if oDesc:size = NIL
    asize := aclone(size)
  else
    asize    := aclone(oDesc:size)
    asize[1] := asize[1] * drgINI:fontW
    asize[2] := asize[2] * drgINI:fontH
  endif

* Position of browser
  fpos    := aclone(oDesc:fpos)
  apos[1] := fpos[1] * drgINI:fontW  + ::parent:leftOffset
  apos[2] := size[2] - fpos[2]*drgINI:fontH - asize[2] - ::parent:topOffset

* Resize
  ::canResize := .T.
  ::optResize := odesc:resize

* Get file name
  ::cfile  := iif(oDesc:file = NIL, ::drgDialog:formHeader:file, oDesc:file)
  ::isfile := .t.
*
* Open file and set working index
  adbd := drgDBMS:getDBD(::cfile)
  adbd:open()
  ::dbArea := select()
  (::cfile)->(AdsSetOrder(oDesc:indexord), dbgotop())

  if left(odesc:popupMenu,1) = 'y'
    ainfo_pos    := aclone(apos)

    asize[1]               -= 8
    asize[2]               -= 28
    apos[1]                += 4
    apos[2]                += 24
    ::popupMenu            := .t.
    ::possible_indicateRow := .t.
    ::createInfo(ainfo_pos, asize, obord)

    if len(odesc:popupMenu) = 2
      ::possible_indicateRow := ( subStr(odesc:popupMenu,2,1) = 'y' )
    endif
  else
    asize[1]    -= 8
    asize[2]    -= 8
    apos[1]     += 8
    apos[2]     += 8
  endif

  * PP parameters
  app        := iif(left(oDesc:type, 2) = 'ed', drgPP_PP_BROWSE4, drgPP_PP_BROWSE1)
  app        := iif(empty(oDesc:pp), app, oDesc:pp)
  apresParam := aclone( drgPP:getPP(aPP) )

  *
  ** zmìníme BG barvu podøízené BROw
  if len(::drgDialog:odbrowse) <> 0
    if len(::drgDialog:odbrowse) >= 1
      if( nin := ascan( apresParam, {|a| a[1] = XBP_PP_COL_DA_BGCLR }) ) <> 0
        apresParam[nin,2] := NOACTIVE_BRO_COLOR
      endif
    endif
  *
  ** první BRO má vždy aktivní barvu
  else
    if( nin := ascan( apresParam, {|a| a[1] = XBP_PP_COL_DA_BGCLR }) ) <> 0
      apresParam[nin,2] := ACTIVE_BRO_COLOR
    endif
  endif

**  rowCount :=  int( asize[2] / (drgINI:fontH - 2) )
**  asize[2] :=  (rowCount * (drgINI:fontH - 2))

  ::oXbp := XbpBrowse():new(  obord, , apos, asize, apresParam, .f. )
  ::oxbp:adjustHeight := .t.

  ::oxbp:useVisualStyle := if( isMemvar( 'visualStyle'), visualStyle, .f. )
  ::oXbp:cursorMode     := oDesc:cursorMode
  ::oXbp:Sizecols       := ::enabled_sizeCols

  ::drgDialog:dialogCtrl:registerBrowser(self)

* první sloupec by mìl indikovat výbìr
  if ::oxbp:useVisualStyle .and. IsThemeActive(.T.)
    if (len(::drgDialog:odbrowse) = 0 .and. left(odesc:popupMenu,1) = 'y')
      *
      * "M->deBrowse_indicateRow::2.7::2,"
      * bacha, sloupec se na drgScrPos vždy vylouèí pak je možné jet s visuálním stylem, nebo ne
      *                                              1 - icon, 2 - bmp
      odesc:fields := "M->deBrowse_indicateRow::2.7::2," +odesc:fields
    endif
  endif

  ::ardef  := _getBrowseFields(odesc, self)
    aFld   := listAsArray(odesc:fields)

* Set font and create
  ::oXbp:setFont(drgPP:getFont())
  ::oXbp:hScroll := substr(odesc:scroll, 1, 1) = 'y'
  ::oXbp:vScroll := substr(odesc:scroll, 2, 1) = 'y'
  ::oXbp:create()


* This may come handy with post and prevalidation of Browser - Otherwise oVar is not needed.
  ::ovar := ::oXbp
  drgLog:cargo  := 'Browse: ' + ::cfile

* Create navigation codeblocks for browsing file
  ::oXbp:skipBlock     := {|n| (::cfile)->(DbSkipper(n))       }
  ::oXbp:goTopBlock    := {| | (::cfile)->(DbGoTop())          }
  ::oXbp:goBottomBlock := {| | (::cfile)->(DbGoBottom())       }
  ::oXbp:phyPosBlock   := {| | (::cfile)->(Recno())            }

  ::oXbp:posBlock      := {| | (::cfile)->(DbPosition()*10)    }
  ::oXbp:goPosBlock    := {|n| (::cfile)->(DbGoPosition(n/10)) }
  ::oXbp:lastPosBlock  := {| | 1000                            }
  ::oXbp:firstPosBlock := {| | 0                               }


  for x := 1 TO LEN(::ardef) step 1
     oColumn := ::createColumn(::ardef[x,1], ::ardef[x,2], ::ardef[x,3], ::ardef[x,4], ::ardef[x,5])
     oColumn:frmColum := allTrim(aFld[x])
     oColumn:picColum := ::ardef[x,4]
     oColumn:sumColum := ::ardef[x,6]
     oColumn:reqColum := .not. ( lower( drgParseSecond( ::arDef[x,2], '>')) $ oDesc:noreqColum )
     oColumn:defColum := ::ardef[x]

     if(odesc:headMove <> 'y', oColumn:heading:itemMarked := NIL, nil)
     * new
     if(odesc:footer = 'y' .or. odesc:footer = 'yy')
       oColumn:FooterLayout[XBPCOL_HFA_CAPTION]     := ''
       oColumn:FooterLayout[XBPCOL_HFA_HEIGHT]      := if( odesc:footer = 'yy', 0, drgINI:fontH - 2)
       oColumn:FooterLayout[XBPCOL_HFA_FRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
       oColumn:FooterLayout[XBPCOL_HFA_ALIGNMENT]   := XBPALIGN_RIGHT
       oColumn:FooterLayout[XBPCOL_HFA_FGCLR]       := GRA_CLR_DARKBLUE
     endif
     * endnew

     ::oxbp:addColumn(oColumn)
     ocolumn:currSize := oColumn:currentSize()

     if( len(::pa_toolTipText) >= x, oColumn:heading:tooltipText := ::pa_toolTipText[x], nil )
     if( oColumn:type = XBPCOL_TYPE_BITMAP, oColumn:autoSize := .t., nil )

     if ::ardef[x,3] = 0
       asize := ocolumn:currentSize()
       ocolumn:disable()
       ocolumn:setSize( { 0, asize[2] } )
       ocolumn:hide()
     else
       if( nF_column = 0, nF_column := x, nil )
     endif
  next

  ::oXbp:cargo := self


* Call backs
* Set pre & post validation codeblocks, althow they make little sence here
  ::postBlock := ::drgDialog:getMethod( oDesc:post )
  ::preBlock  := ::drgDialog:getMethod( oDesc:pre )
  ::tipText   := drgNLS:msg(oDesc:tipText)
  ::name      := IIF(oDesc:name = NIL, 'BROWSE', oDesc:name)

* ItemMarked callback
  ::itemMarked  := ::drgDialog:getMethod(oDesc:itemMarked,'browseItemMarked')
  ::stableBlock := ::drgDialog:getMethod(oDesc:stableBlock)

 if .not. isnull(odesc:atStart)
    if odesc:atStart = 'last'
       if isRestFRM
         ::atStart := odesc:atStart
       else
         (::cfile) ->( dbgoBottom())
         for x := 1 to 3 ; (::cfile) ->( dbskip(-1)) ; next
         for x := 1 to 3 ; ::oxbp:down()             ; next
       endif
    endif
  endif

  if (len(::drgDialog:odbrowse) = 0 .and. left(odesc:popupMenu,1) = 'y')
    ::oXbp:itemRbDown := { |mp1,mp2,obj| ::createContext(mp1,mp2,obj) }
  endif

  if(startBlock := ::drgDialog:getMethod(,'browseStart') ) != NIL
    eval(startBlock, self)
  endif

  ::cellBGC             := ::oxbp:getColumn(1):dataAreaLayout[XBPCOL_DA_BGCLR]
  ::recPosFocus         := 0
  ::oxbp:stableBlock    := {|a| ::stableBlock(a)}
  ::oxbp:colPos         := nF_column
  ::oxbp:refreshAll(.f.)

  drgLog:cargo := 'Browse:CALLBACKS '
  drgLog:cargo := NIL

  aadd(::drgDialog:odbrowse,self)
return self

*
method deBrowse:stableBlock(oxbp)

  ::last_ok_rowPos := oxbp:rowPos
  ::last_ok_recNo  := if( (::cfile)->(eof()), 0, (::cfile)->(recNo()) )

  if .not. isNull(::stableBlock)
    if (::cfile)->(recNo()) <> ::recPosFocus
      eval(::stableBlock,oxbp)
      ::recPosFocus := (::cfile)->(recNo())
      postAppEvent(drgEVENT_STABLEBLOCK,,,oxbp)
    endif
  endif
return

*
method deBrowse:createInfo(apos,asize,obord)
  local osearch, oxbp
  *
  local bKeyBoard := {|mp1,mp2,obj| ::keyHandled(mp1,obj) }
  local adbd      := drgDBMS:getDBD(::cfile)
  *
  local indexDef, ctag, order, ordKey
  *
  osearch := XbpStatic():new(obord,,apos,{asize[1],21})
  osearch:type := XBPSTATIC_TYPE_RECESSEDBOX
  osearch:create()

  ::oseek := XbpSLE():new(osearch,, { 2,1}, {255,18} )
  ::oseek:create()
  ::oseek:keyBoard := bKeyboard

  *
  ::scope_Direction  := .f.
  ::oico_Scope     := xbpIcon():new():create()
  ::oico_Scope:load( nil, MIS_ICON_FILTER )

  ::oico_killScope := xbpIcon():new():create()
  ::oico_killScope:load( nil, MIS_ICON_KILLFILTER)

  ::scope_Button := XbpImageButton():new( oSearch,, {259, 0}, {20,20} )
  ::scope_Button:image         := ::oico_killScope
  ::scope_Button:caption       := ' '
  ::scope_Button:tooltiptext   := 'Nazdar... '
  ::scope_Button:CaptionLayout := XBPALIGN_HCENTER+XBPALIGN_VCENTER
  ::scope_Button:ImageAlign    := XBPALIGN_HCENTER+XBPALIGN_TOP
  ::scope_Button:create()
  ::scope_Button:activate:= {|| ::scope_Activate() }

  ordKey := (::cfile)->(ordKey())
  if lower( left(ordKey, 5)) <> 'upper'
    ::scope_Button:disable()
  else
    ::scope_Button:enable()
  endif


  oXbp := XbpStatic():new( osearch,, {280,1}, {10,18} )
  oXbp:caption := "["
  oxbp:setColorFG(GRA_CLR_BLUE)
  oXbp:options := XBPSTATIC_TEXT_LEFT
  oXbp:create()

  *
  indexDef := adbd:indexDef
  ctag     := upper( (::cfile) ->( ordSetFocus()) )
  order    := ascan( indexDef, { |x| upper(x:cname) = ctag } )

  if( order = 0, order := 1, nil )

  *
  ::order := XbpStatic():new( osearch,, {295,1}, {165,16} )
  ::order:setFontCompoundName('7.Arial CE')
  ::order:caption := adbd:indexDef[order]:ccaption
  ::order:options := XBPSTATIC_TEXT_LEFT
  ::order:create()

  ::ordtype := valtype((::cfile)->(sx_keydata()))

  oXbp := XbpStatic():new( osearch,, {490,1}, {5,18} )
  oXbp:caption := "]"
  oxbp:setColorFG(GRA_CLR_BLUE)
  oXbp:options := XBPSTATIC_TEXT_RIGHT
  oXbp:create()
return self

*
method deBrowse:scope_Activate()
  local  scopeKy := (::cfile)->( dbScope( SCOPE_TOP))
  local  seaKy   := upper( ::oseek:getData())

  do case
  * zapnutý scope / vypínáme
  case ::scope_Direction
    (::cfile)->(dbclearScope())

  * vypnutý scope / zapínáme
  otherWise
    do case
    case .not. empty( seaKy)
      (::cfile)->(dbsetScope(SCOPE_BOTH, seaKy))
    case .not. empty( scopeKy)
      (::cfile)->(dbsetScope(SCOPE_BOTH, scopeKy))
    endcase
  endCase

  ::scope_Button:image := if( ::scope_Direction, ::oico_killScope, ::oico_Scope)
  ::scope_Direction    := .not. ::scope_Direction
  ::refresh()

  setAppFocus( ::oxbp )
return self

*
method deBrowse:createColumn(hCaption, cName, cLen, cPic, cType)
  local ocolumn, cblock, cc, n, cFldName
  local app := { { XBP_PP_COL_HA_CAPTION      , ""  } , ;
                 { XBP_PP_COL_DA_ROWWIDTH     , 7   } , ;
                 { XBP_PP_COL_DA_ROWHEIGHT    , drgINI:fontH - 8} }


  Local aCOL_h := { GRA_CLR_RED ,}, aCOL_d := {,}

  if at('|',hCaption) <> 0
    cc       := ::drgDialog:getVarBlock(hCaption)
    hcaption := if(isBlock(cc), eval(cc), '')
  endif

  clen     := (clen*drgINI:fontW)
  app[1,2] := hCaption
  app[2,2] := cLen

* Set codeblock for DB file
  if at('(',cName) = 0
    cc := ::drgDialog:getVarBlock(cName)    // field cb
  else
    cName := STRTRAN(cName,';',',')         // function
    cc := &('{|a, b, c|' + cName + ' }')
  endif

* první sloupec není na ::udcp
  if empty(cc) .and. cName = "M->deBrowse_indicateRow"
    cFldName := drgParseSecond(cName, '>' )
    cc       := drgVarBlock( @::deBrowse:&cFldName )
  endif


* Set picture
  IF EMPTY(cPic)
    cBlock := cc
  ELSE
    cBlock := {|a| IIF(a = NIL, drg2String(cc, cPic),'') }

    IF VALTYPE( EVAL(cc) ) = 'N'
      AADD( aPP, { XBP_PP_COL_DA_CELLALIGNMENT, XBPALIGN_RIGHT } )
    ENDIF
  ENDIF

*
  oColumn           := xbpDrgColumn():new( ,,,, aPP)
  oColumn:dataLink  := cBlock
  oColumn:cargo     := ::oxbp  // cName
  oColumn:type      := cType


  if (::parent:drgDialog:formName <> 'drgSearch')
    oColumn:colorBlock := {|| colorBlock( ::arselect, (::cfile)->(recno()), ::is_selAllRec ) }
  endif

  oColumn:heading:itemMarked := { |nrowPos,uNIL,obj| ::headLBdown(nrowPos,uNIL,obj) }
return oColumn


*
** pokud je zapnut visuální styl a je  IsThemeActive(.T.) == .T., je to naopak,
** zùstne celoøádkový kurzor a nejde zmìnit barvu textu
*
static function colorBlock(arselect, recNo, is_selAllRec)
  local useVisualStyle := if( isMemvar( 'visualStyle'), visualStyle, .f. )
  local aCOL_h := { GRA_CLR_RED , }, aCOL_d := { , }

  do case
  case is_selAllRec
    if ascan(arselect, recNo) <> 0
      return aCOL_d
    else

      if useVisualStyle .and. IsThemeActive(.T.)
        return { , GraMakeRGBColor( {215, 255, 220 } ) }
      else
        return aCOL_h
      endif

    endif

  otherwise
    if ascan(arselect, recNo) <> 0

      if useVisualStyle .and. IsThemeActive(.T.)
        return { , GraMakeRGBColor( {215, 255, 220 } ) }
      else
        return aCOL_h
      endif

    else
      return aCOL_d
     endif
  endcase
return aCOL_d


method deBrowse:handleEvent(nEvent, mp1, mp2, oxbp)
  local   odbrowse := ::drgDialog:odbrowse, ocolumn, cky, userZmen, navigate
  local   colCount, colPos, new_colPos, ocellGroup, nin, nstep
  *
  local   mp1_nx, mp2_nx, oxbp_nx
  local   is_Scope := (::cfile)->( dbScope())
  local   oclipBoard, xValue
  *
  *
  do case
  case(nevent = xbeP_Paint)
*-    IF(::drgdialog:oform:olastdrg:oxbp = ::oxbp, ::showCell(), nil )
    return .f.

  case(nEvent = xbeP_Keyboard)
    do case
    case ( chr(mp1)= 'R' .and. ;
           AppKeyState( xbeK_ALT   ) = APPKEY_DOWN .and. ;
           AppKeyState( xbeK_SHIFT ) = APPKEY_DOWN )

      if ( ::cfile)->( FieldPos('mUserZmenR')) > 0
        DRGDIALOG FORM 'SYS_UserZmen_Log' PARENT ::drgDialog CARGO self MODAL DESTROY
      else
        drgMsgBox(drgNLS:msg( 'Soubor [ & ] nemá k dispozici archiv zmìn pro záznamy !', ::cFile), XBPMB_INFORMATION)
      endif

    case ( chr(mp1)= 'M' .and. ;
           AppKeyState( xbeK_ALT   ) = APPKEY_DOWN .and. ;
           AppKeyState( xbeK_SHIFT ) = APPKEY_DOWN )

      ::deBrowse:maxbro( oXbp)

    case mp1 = xbeK_CTRL_C
      ::ocurCol := ::oxbp:getColumn( ::oxbp:colPos )

      if valType(xValue := ::ocurCol:getRow(::oxbp:rowPos)) <> 'N'
        oclipBoard := XbpClipboard():New():Create()
        oclipBoard:open()
        oclipBoard:setBuffer( xValue )
        oclipBoard:close()
      endif

    *
    ** XBPBRW_CURSOR_ROW
    case( mp1 == xbeK_LEFT .or. mp1 == xbeK_RIGHT .or. mp1 == xbeK_HOME .or. mp1 == xbeK_END)

      if ::oxbp:cursorMode = XBPBRW_CURSOR_ROW

        ::ocurCol := ::oxbp:getColumn( ::oxbp:colPos )
        ::setVisibleCols()

        colCount   := ::oXbp:colCount
        colPos     := ::oXbp:colPos
        new_colPos := colPos

        do case
        case( mp1 = xbeK_LEFT )
          aeval( ::paCols, { |x,i| if( x[7], new_colPos := i, nil ) },        1, colPos-1 )

        case( mp1 = xbeK_RIGHT)  ;  new_colPos := ascan( ::paCols, { |x| x[7] }, colPos+1 )
        case( mp1 = xbeK_HOME )  ;  new_colPos := ascan( ::paCols, { |x| x[7] } )
        case( mp1 = xbeK_END  )
          do while .not. ::paCols[colCount,7] .and. colCount > 0  ;  colCount--  ; enddo
          new_colPos := colCount
        endcase

        if( new_colPos = 0, new_colPos := colPos, nil )

        ocolumn    := ::oxbp:getColumn( new_colPos )
        if ( nin := ascan( ::paCols, { |o| o[6] = ocolumn:heading } )) <> 0

          * je sloupec viditelný,pokud není je potøeba posunout panel
          if .not. ::paCOls[nin,4]
            if( mp1 = xbeK_LEFT, ::oxbp:panLeft(), ;
              if( mp1 = xbeK_RIGHT, ::oxbp:panRight(), ;
                if( mp1 = xbeK_HOME, ::oxbp:panHome(), ::oxbp:panEnd() )))
          endif
        endif

        ocellGroup := ::oxbp:getColumn( new_colPos ):dataArea
        postAppEvent( xbeBRW_ItemMarked, ::oxbp:rowPos, 1, ocellGroup )
        return .t.
      else
        return .f.
      endif

    case( mp1 = xbeK_CTRL_ENTER .and. isobject(::oseek)) .and. ::possible_indicateRow
      ::is_possible_indicateRow()
      return .t.

    case( mp1 = xbeK_CTRL_A     .and. isobject(::oseek)) .and. ::possible_indicateRow
      ::fromContext( if( .not. ::is_selAllRec, 2, 4 ) )
      return .t.
************

    case(isobject(::oseek) .and. (oxbp <> ::oseek) .and. mp1 = xbeK_BS)
      if len(cky := ::oseek:getData()) > 0
        ::oseek:setData(left(cky,len(cky)-1))
        ::keyHandled(mp1,oxbp)
        return .t.
      endif

    case(isobject(::oseek) .and. (oxbp <> ::oseek) .and. (mp1 > 31 .and. mp1 < 255))
      if ::ordType = 'N' .and. .not. isdigit(chr(mp1))
        tone(500,3)
        return .t.
      else
        ::oseek:setData(::oseek:getData() +chr(mp1))
        ::keyHandled(mp1,oxbp)
      endif
    endcase

    return .f.

  case (AppKeyState(xbeK_CTRL) == 1 .and. nevent = xbeM_LbClick)
    ::is_possible_indicateRow()
    return .t.

  case(nevent = drgEVENT_EDIT .or. nevent = drgEVENT_APPEND)
    if(isobject(::oseek), if( is_Scope, nil, ::oseek:setData('')), nil)

  case( nevent = xbeBRW_ItemSelected )    /// .and. .not. ::drgDialog:dialogCtrl:isReadOnly )
    if(isobject(::oseek), if( is_Scope, nil, ::oseek:setData('')), nil)

    * pokud mlátí do gridu myší, bereme tuto událost jen jednou *
    if nextAppEvent() = xbeM_LbDblClick
      postAppEvent(drgEVENT_ACTION, drgEVENT_EDIT,'0',::oXbp)
    endif
    return .t.

  case(nevent = xbeBRW_ItemMarked .and. ::oxbp:currentState() = 1 )
    if oxbp:className() = 'XbpBrowse'

      if(isobject(::oseek), if( is_Scope, nil, ::oseek:setData('')), nil)

      if isblock(::itemMarked)

         aeval( odbrowse, { |o| o:ncurrRecNo := (o:cfile)->(recNo()) } )
         eval(::itemMarked,{::oxbp:rowPos,::oxbp:colPos},,::oxbp)

         nin := ascan( odbrowse, { |o| o:oxbp = ::oxbp })

         for nstep := nin +1 to len(odbrowse) step 1
           if odbrowse[nstep] <> self
             odbrowse[nstep]:oxbp:refreshAll()
           endif
         next

      endif
    endif

  case(nevent = xbeM_Wheel)
*    i := Int( ::oxbp:rowCount / ( 360 / Abs( mp2[2] ) ) )
*    IF mp2[2] > 0
*      i := i * (-1)
*    ENDIF
*    PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_Skip, i, ::oxbp )

    ::oxbp:HandleEvent ( nEvent,mp1,mp2 )
    return .t.


* TT    ::oXbp:getColumn(::oxbp:colPos):invalidateRect()
*    sleep(15)

  endcase
return .f.


method deBrowse:keyHandled(nkey,obj)
  local  cky      := ::oseek:getData(), seaKy, recs := (::cfile)->(recno())
  local  odbrowse := ::drgDialog:odbrowse, odesc
  *
  local  vars     := ::drgDialog:dataManager:vars, x, ovar
  local  isnum    := (::ordType = 'N')
  local  npos, citem, cblock := '', cordKey
  *
  local  nval

  *
  ** stojí v hledacím prvku a chce pøejít do BRO
  if obj:className() = 'XbpSLE' .and. ( nkey = xbeK_UP .or. nkey = xbeK_DOWN )
    postAppEvent(xbeP_Keyboard, nkey,, ::oxbp)
    setAppFocus( ::oxbp )
  endif

  *
  ** strZero
  if ::ordType = 'C'
    if (npos := at('+', ordKey := (::cfile)->(ordKey()))) <> 0
      cc := allTrim(subStr(ordKey, 1, npos -1))
      do case
      case( 'strzero' $ lower(cc) )
        isnum  := .t.
        citem  := substr(cc   , at('(', cc) +1)
        citem  := substr(citem,              1, at(',', citem) -1)
        cblock := '{ |' +citem +'| ' +cc + '}'

        nval   := val(cky)

        * u strZero zadal jen 00..
        if nval = 0
          isnum  := .f.
          cblock := ''
        else
          * zadal èíslo, ? nasal víc znakù než pro strZero ?
          if len(cky) > len( eval( &(cblock), nval))
            isNum  := .f.
            cblock := ''
          endif
        endif
      endcase
    endif
  endif

  do case
  case( nkey > 31 .and. nkey < 255)
    if( isnum .and. .not. isdigit(chr(nkey)))
      tone(500,3)
      ::oseek:setData(left(cky,len(cky)-1))
      postappevent(xbeP_Keyboard,xbeK_END,,::oseek)
      return .f.
    endif

    if isnum
      cordKey := ( ::cfile ) ->( ordKey())
      if isobject(odesc := drgDBMS:getFieldDesc(::cfile, cordKey))
        if len( cky ) > odesc:len
          tone(900,3)
          ::oseek:setData(left(cky,len(cky)-1))
          return .f.
        endif
      endif
    endif
  endcase

  seaKy := if( isnum, if( empty(cblock), val(cky), eval( &(cblock), val(cky)) ), ;
               upper(cky)                                                        )
     ok := (::cfile)->(dbseek(seaKy,isnum))

  if( .not. ok .and. .not. isnum, tone(500,7), nil)
  if( .not. ok .and.       isnum .and. (::cfile)->( eof()))
    tone(500,7)
    (::cfile)->(dbGoBottom())
  endif

  if ok .and. ::scope_Button:isEnabled() .and. ::scope_Direction
    (::cfile)->(dbsetScope(SCOPE_BOTH, seaKy))
    ::refresh()
  endif

  if recs <> (::cfile)->(recno())
    ::oxbp:refreshAll()
    *
    if isblock(::itemMarked)
      eval(::itemMarked,{::oxbp:rowPos,::oxbp:colPos},,::oxbp)
** bacha **      eval(::itemMarked,self)
      aeval(odbrowse, {|x| if( x = self, nil, x:oxbp:refreshall() )})
    endif
    *
    for x := 1 TO vars:size() step 1
      ovar := vars:getNth(x)
      if isblock(ovar:block)
        ovar:set(eval(ovar:block))
        ovar:initvalue := ovar:prevvalue := ovar:value
      endif
    next
  endif
return self


*
**
#xtranslate  .pCOL   =>  \[ 1\]
#xtranslate  .pWITH  =>  \[ 2\]
#xtranslate  .pCURS  =>  \[ 3\]
#xtranslate  .pVIS   =>  \[ 4\]

method deBrowse:headLBdown(nrowPos,uNIL,obj)
  local  aRect, aPos, aSize, aPos_c
  local  curCol   := ::oxbp:colPos, newCol
  local  oColumn  := ::oxbp:getColumn(::oxbp:colPos)
  local  frmColum := oColumn:frmColum
  local  oCol, oDrag, oIcon, oText, oCusr, oIcon_L, oIcon_R
  *
  local  nevent := mp1 := mp2 := nil
  local  isCurs, isVis
  *
  local  aChild, colorBG := oColumn:dataAreaLayout[XBPCOL_DA_HILITE_BGCLR]
  local  hCursor := getCursor()

  local  paCurs := getCursorPos()
  local  paHead := mh_getAbsPos(obj)

  if .not. (paHead[1] +4 <= paCurs[1] .and. paHead[1] +obj:currentSize()[1] -4 >= paCurs[1])
    return .f.
  endif

  BEGIN SEQUENCE
  for x := 1 to ::oxbp:colCount step 1
    if ::oxbp:getColumn(x) = obj:parent
      curCol  := x
      oColumn := ::oxbp:getColumn(curCol)
  BREAK
    endif
  next
  END SEQUENCE

  * zakážeme SizeCols, jinak se nám to potká s pøetahováním sloupce
  ::oXbp:Sizecols   := .f.

  ::oxbp:deHilite()
  ::oxbp:cursorMode := XBPBRW_CURSOR_CELL
  ::oxbp:configure():deHilite()

  ::ocurCol := obj
  ::setVisibleCols()

  aRect   := oColumn:dataArea:cellRect(::oXbp:rowPos)
  aPos    := mh_GetAbsPos(obj)
  aPos[2] -= (aRect[4] -aRect[2])
  aSize   := {aRect[3]-aRect[ 1], obj:currentSize()[2] }    // aRect[4]-aRect[2]}

  oDrag := XbpDialog():new( AppDeskTop(), SetAppWindow(), aPos, {aSize[1] +16,aSize[2]},, .f.)
    *
    oDrag:drawingArea:bitmap   := 1016
    oDrag:drawingArea:options  := XBP_IMAGE_SCALED
    *
    oDrag:useVisualStyle    := visualStyle
    oDrag:alwaysOnTop       := .T.
    oDrag:border            := XBPDLG_RAISEDBORDERTHICK_FIXED
    oDrag:titleBar          := .F.
    oDrag:motion            := {|mp1,uNIL,obj| newCol := ::headMove(mp1,aPos,oDrag,oCurs,oText)}
    oDrag:setModalState(XBP_DISP_APPMODAL)
    oDrag:create():captureMouse(.T.)
    oDrag:cargo             := curCol

  oIcon := XbpStatic():new()
    oIcon:type    := XBPSTATIC_TYPE_ICON
    oIcon:caption := MIS_DARGDROP_PUNTERO
    oIcon:create( oDrag:drawingArea,, { 1, 1 }, { 16, 16 }, ;
                { { XBP_PP_FGCLR, XBPSYSCLR_TRANSPARENT }, ;
                  { XBP_PP_BGCLR, XBPSYSCLR_TRANSPARENT } } )

  oText := XbpStatic():new()
    oText:type := XBPSTATIC_TYPE_TEXT
    oText:caption := obj:referenceString
    oText:create( oDrag:drawingArea,, {18,-5}, aSize)
    oText:cargo   := obj:referenceString
*
**
  aPos_c := mh_GetAbsPos(obj)
  aPos_c[1] -= 15
  apos_c[2] +=  2
  oCurs  := XbpDialog():new( AppDeskTop(), SetAppWindow(), aPos_c, {16+14,16},, .f.)
    oCurs:alwaysOnTop       := .T.
    oCurs:border            := XBPDLG_NO_BORDER
    oCurs:titleBar          := .F.
    oCurs:setModalState(XBP_DISP_APPMODAL)
    oCurs:create()

  oIcon_L := XbpStatic():new()
    oIcon_L:type    := XBPSTATIC_TYPE_ICON
    oIcon_L:caption := MIS_RIGHT_LIGHTBLUE
    oIcon_L:create( oCurs:drawingArea,, { 0, 0 }, { 16, 16 }, ;
                    { { XBP_PP_FGCLR, XBPSYSCLR_TRANSPARENT}, ;
                      { XBP_PP_BGCLR, XBPSYSCLR_TRANSPARENT}  } )

  oIcon_R := XbpStatic():new()
    oIcon_R:type  := XBPSTATIC_TYPE_ICON
    oIcon_R:caption := MIS_LEFT_LIGHTBLUE
    oIcon_R:create( oCurs:drawingArea,, { 14, 0 }, { 16, 16 }, ;
                  { { XBP_PP_FGCLR, XBPSYSCLR_TRANSPARENT }, ;
                    { XBP_PP_BGCLR, XBPSYSCLR_TRANSPARENT } } )
**
*
  trapCursor(oDrag,.t.)
  oDrag:show()
  obj:setPointer(,MIS_HAND, XBPWINDOW_POINTERTYPE_POINTER)
  setCursorPos(aPos[1] +(aSize[1] +16)/2, aPos[2])

  do while .t.
    nEvent := AppEvent( @mp1, @mp2, @oXbp )
    oXbp:handleEvent( nEvent, mp1, mp2 )

    if nEvent = xbeM_LbUp
      trapCursor(oDrag,.f.)

      newCol := isNull(newCol,curCol)

      if curCol <> newCol
        * pro EBrowse
        aChild := oColumn:dataArea:childList()
        if( len(aChild) <> 0, aeval(aChild, {|x| x:setParent(AppDesktop())}), nil)

        ::oxbp:lockUpdate(.t.)
        if newCol > ::oxbp:colCount
          ::oXbp:delColumn(curCol)
          *
          oColumn:frmColum := frmColum
          ::oXbp:addColumn(oColumn)
        else
          ::oXbp:delColumn(curCol)
          *
          oColumn:frmColum := frmColum
          oColumn:dataAreaLayout[XBPCOL_DA_HILITE_BGCLR] := nil
          ::oxbp:insColumn(newCol,oColumn)
        endif

        * pro EBrowse
        if( len(aChild) <> 0, aeval(aChild, {|x| x:setParent(oColumn:dataArea)}), nil)

        ::oxbp:cursorMode := XBPBRW_CURSOR_ROW
        ::oxbp:configure():refreshAll()
        ::oxbp:lockUpdate(.f.)
      else
        ::oxbp:cursorMode := XBPBRW_CURSOR_ROW
        ::oxbp:refreshCurrent()
      endif

      PostAppevent(xbeBRW_ItemMarked, ;
                   ::oxbp:rowPos    , ;
                   ::oxbp:colPos    , ;
                   ::oxbp:getColumn( ::oxbp:colPos):dataArea )
      exit
    endif
  enddo

  obj:setPointer( NIL, XBPSTATIC_SYSICON_ARROW, XBPWINDOW_POINTERTYPE_SYSPOINTER )
  SetCursor( hCursor)
  ocurs:destroy()
  odrag:destroy()

 * vrátíme SizeCols po dokonèení pøetažení sloupce
 ::oXbp:Sizecols := ::enabled_sizeCols
return nil

*
method deBrowse:headMove(mp1,aPos,oDrag,oCurs,oText)
  local curPos  := oDrag:currentPos(), x, pa
  local curSize := oDrag:currentSize()
  *
  local nxBPos  := mh_GetAbsPos(::oxbp)[1]
  local nBSize  := ::oxbp:currentSize()[1]
  local oR_mp1  := mp1

  trapCursor(oDrag,.f.)

  mp1[1] := mp1[1] +curPos[1] -curSize[1]/2
  oDrag:setPos({mp1[1],aPos[2]})
  curPos    := mh_getAbsPos(oDrag)

  if oR_mp1[1] < nXBPos .or. oR_mp1[1] > nXBPos +nBSize
    do case
    case(oR_mp1[1] < nXBPos) ; ::oxbp:left()
    otherwise                ; (::oxbp:right(),::oxbp:right())
    endcase
    ::setVisibleCols()
  endif

  BEGIN SEQUENCE
  for x := 1 to len(::paCols) step 1
    pa := ::paCols[x]
    if (pa[1] >= curPos[1])
      if .not. pa.pVIS
        if( oDrag:cargo <= x, (::oxbp:right(),::oxbp:right()),::oxbp:left())
        ::setVisibleCols()
        pa := ::paCols[x]
        ::oxbp:colPos := x
      else
        ::oxbp:colPos := x
      endif
  BREAK
    endif
  next
  END SEQUENCE

  * na posledním slouci
  if x = len(::paCols) +1
    oCurs:setPos({pa[1]+pa[2]-14,aPos[2]+23})
  else
    oCurs:setPos({pa[1]-14,aPos[2]+23})
  endif

  * sem se nedá pøesunout
  if(.not. pa.pCURS,oCurs:hide(),oCurs:show())
  trapCursor(oDrag,.t.)
return x

*
method deBrowse:setVisibleCols()
  local  x
  local  nDSize, nxBPos, nBSize, nxCPos, cCSize
  local  nCSum := 0, nCSum_NoVis := 0
  local  ocols
  local  aCPos
  *
  local  isCurs, isVis
  local  nLeftOffset := ::oxbp:GetScrollBG():currentPos()[1]
  local  nXSizeBG    := ::oxbp:GetBG():CurrentSize()[1]
  *
  ::paCols := {}
  nCsum    := abs( nLeftOffset )

  nDSize   := appDeskTop():currentSize()[1]
  nxBPos   := mh_GetAbsPos(::oxbp)[1]
  nBSize   := ::oxbp:currentSize()[1] // - if( ::oxbp:vScroll, 18, 0 )
  aCPos    := mh_GetAbsPos(::ocurCol)
  aCPos[2] := aCPos[1] + ::ocurCol:currentSize()[1]

  for x := 1 to ::oxbp:colCount step 1
    ocol   := ::oxbp:getColumn(x):heading
    nxCPos := mh_getAbsPos(ocol)[1]
    nCSize := ocol:currentSize()[1]
    nCSum  += nCSize
    *
    isCurs := .not. (nxCPos $ aCPos)
    *
    isVis  :=             (nxCPos >= 0      .and. nxCPos <= nDSize)
    isVis  := isVis .and. (nCsum  <= nBSize)
    isVis  := isVis .and. (nxCPos >= nxBPos .and. nxCPos <= (nxBPos +nBSize))
    *
    **
    nxCPos      := if(nxCPos >= 0 .and. nxCPos <= nDSize,nxCPos,0)
    nCSum_NoVis += if( isVis, 0, nCSize )

    aadd(::paCols, {nxCPos, nCSize, isCurs, isVis, oCol:referenceString, ocol, ocol:isVisible()} )
    if(.not. isVis    , nCSum -= nCSize, nil)

    if nLeftOffset <> 0 .and. nCSum_NoVis >= abs(nLeftOffset)
      nCSum       := ( nCSum_NoVis - abs(nLeftOffset) )
      nCSum_NoVis := 0
    endif
  next
return self

static function trapCursor(o,lTrap)
  local cBuffer     := Space(16) // cBuffer == a4LTRB_lpRect:= {nL,nT,nR,nB}

  if lTrap
    DllCall("User32.DLL", DLL_STDCALL,"GetWindowRect", o:GetHwnd(), @cBuffer)
    cBuffer:= substr(cBuffer,  1, 12)+U2Bin(Bin2U(substr(cBuffer, 13, 4)))
    DllCall("User32.DLL", DLL_STDCALL, "ClipCursor", cBuffer)
  else
    DllCall("User32.DLL", DLL_STDCALL, "ClipCursor", 0)
  endif
return nil
**
*
*
method deBrowse:createContext(mp1,mp2,obj)
  local  omenu
  *
  local  x, osort, st, pos := ascan(::arselect,(::cfile)->(recno()))
  local  adbd := drgDBMS:getDBD(::cfile), nPos := 0, pa := {}, n
  *
  local  clrFG, clrBG, is_selCurrRec, is_selMoreRec, ctagName, indexDef
  local  odistr, odesc, pa_values, pb, pa_distr := {}

  omenu         := XbpImageMenu():new(::oxbp )
  omenu:barText := adbd:description
  omenu:create()

  obj:getColumn(1):dataArea:getCellColor(obj:rowPos, @clrFG, @clrBG)

  is_selCurrRec   := (clrFG <> 1)
  is_selMoreRec   := (len(::arselect) <> 0)

  if ::popupMenu
    if ::possible_indicateRow
      omenu:addItem({ 'Oznaè záznam'                , ;
                      {|| ::fromContext(1    )}     , ;
                                                    , ;
                      XBPMENUBAR_MIA_OWNERDRAW        })
      omenu:addItem({ 'Oznaè vše'                   , ;
                     {|| ::fromContext(2    )}      , ;
                                                    , ;
                     XBPMENUBAR_MIA_OWNERDRAW         }, ;
                     if( ::is_selAllRec, 500, 0)         )

      omenu:addItem({ 'Zruší oznaèení záznamu'      , ;
                      {|| ::fromContext(3,pos)}     , ;
                                                    , ;
                      XBPMENUBAR_MIA_OWNERDRAW        })
      omenu:addItem({ 'Zruší oznaèení všech záznamù', ;
                      {|| ::fromContext(4    )}     , ;
                                                    , ;
                      XBPMENUBAR_MIA_OWNERDRAW        })
      omenu:addItem({ NIL                           , ;
                      NIL                           , ;
                      XBPMENUBAR_MIS_SEPARATOR      , ;
                      XBPMENUBAR_MIA_OWNERDRAW        } )
      omenu:addItem({ 'Zobraz oznaèené záznamy'     , ;
                      {|| ::fromContext(6    )}     , ;
                                                    , ;
                      XBPMENUBAR_MIA_OWNERDRAW        } )
      omenu:addItem({ 'Zobraz vše'                  , ;
                      {|| ::fromContext(7    )}     , ;
                                                    , ;
                      XBPMENUBAR_MIA_OWNERDRAW        } )

      *
      if(  is_selCurrRec                    , omenu:disableItem(1),                  nil)
      if(::is_selAllRec                     , omenu:disableItem(2),                  nil)

      if(  is_selCurrRec                    , nil                 , omenu:disableItem(3))
      if(  is_selMoreRec .or. ::is_selAllRec, nil                 , omenu:disableItem(4))

      if(  is_selMoreRec .and.   !::arfilter, nil                 , omenu:disableItem(6))
      if(                         ::arfilter, nil                 , omenu:disableItem(7))
    endif

    if len(adbd:indexDef) > 0
      omenu:addItem( {NIL                     , ;
                      NIL                     , ;
                      XBPMENUBAR_MIS_SEPARATOR, ;
                      XBPMENUBAR_MIA_OWNERDRAW  } )

      osort := XbpImageMenu():new():create( ::oxbp )
      osort:title   := drgNLS:msg('Sorted')

      * definované tágy ze seznamu vyøadí
      for x := 1 to len(adbd:indexDef) step 1
        if adbd:indexDef[x]:lInSort
          nPos++
          aadd( pa, { nPos, x, adbd:indexDef[x]:cName } )
          st := str(x,2) +':' + adbd:indexDef[x]:ccaption
          osort:addItem({ st,{|x| ::fromContext(8,,pa[x,2],,pa[x,3])},,XBPMENUBAR_MIA_CHECKED })
          osort:checkItem(nPos,.f.)
        endif
      next

      ctagName := lower( (::cfile)->(ordSetFocus()) )
      indexDef := adbd:indexDef
      if ( n  := ascan( indexDef, {|o| lower(o:cname) = ctagName } )) <> 0
        if( npos := ascan( pa, {|i| i[2] = n } )) <> 0
          osort:checkItem( pa[ npos, 1], .t.)
        endif
      endif

      omenu:addItem( {osort,,, XBPMENUBAR_MIA_OWNERDRAW}, 122 )
      *
    endif

    omenu:addItem({ 'Vždy na vybraný záznam'      , ;
                   {|| ::fromContext(10    )}     , ;
                                                  , ;
                   XBPMENUBAR_MIA_OWNERDRAW         }, ;
                   if( ::toRecNo, 500, 0)              )

    omenu:addItem({ NIL                           , ;
                    NIL                           , ;
                    XBPMENUBAR_MIS_SEPARATOR      , ;
                    XBPMENUBAR_MIA_OWNERDRAW        } )

    omenu:addItem({ 'Nastavení sloupcù'           , ;
                    {|| ::fromContext(20   )}     , ;
                                                  , ;
                    XBPMENUBAR_MIA_OWNERDRAW        })
  else

    omenu:addItem({ 'Nastavení sloupcù'           , ;
                    {|| ::fromContext(20   )}     , ;
                                                  , ;
                    XBPMENUBAR_MIA_OWNERDRAW        })

  endif

  if isWorkVersion
    omenu:addItem({ 'Informace o formuláøi'       , ;
                    {|| ::fromContext(21   )}     , ;
                                                  , ;
                    XBPMENUBAR_MIA_OWNERDRAW        })
  endif

  if At('DIST',defaultDisUsr('Forms','CTYPFORMS')) <> 0 .and. ;
     (::cfile)->( fieldPos('nDistrib'))            <> 0 .and. ;
     (::cfile)->( fieldPos('sID'))                 <> 0 .and. ;
     isObject( odesc := drgRef:getRef( 'NDISTRIB' ))

    odistr := XbpImageMenu():new():create( ::oxbp )
    odistr:title   := drgNLS:msg('Zpùsob distribuce záznamu')

    pa_values := listAsArray( odesc:values )
    aeval( pa_values, {|x| ( pb := listAsArray(x, ':'), aadd( pa_distr, { allTrim(pb[1]), pb[2]} ) ) } )

    for x := 1 to len(pa_distr) step 1
      st := pa_distr[x, 2]
      odistr:addItem({ st, {|x| ::fromContext(22,,pa_distr[x,1],,pa_distr[x,2])},,XBPMENUBAR_MIA_CHECKED })
      odistr:checkItem(x, (::cfile)->ndistrib = (x-1) )
    next

    omenu:addItem( {odistr,,, XBPMENUBAR_MIA_OWNERDRAW}, 122 )
  endif

  omenu:popup(obj,mp1)
return self

*
method deBrowse:fromContext(menu,pos,order,st,ctag,omenu)
  local lall := .t., filter := ''
  local adbd := drgDBMS:getDBD(::cfile)
  local ordKey

  do case
  case(menu = 1)  ;  ::is_possible_indicateRow()
                     lall := .f.

  case(menu = 2)  ;  ::arselect     := {}
                     ::sumColumn()
                     ::is_selAllRec := .T.

  case(menu = 3)  ;  if ::is_selAllRec
                       if pos = 0  ; aadd(::arselect,(::cfile)->(RECNO()))
                       else        ; (adel(::arselect,pos), asize(::arselect,len(::arselect)-1))
                       endif
                     else
                       (adel(::arselect,pos), asize(::arselect,len(::arselect)-1))
                     endif
                     ::sumColumn()
                     lall := .f.

  case(menu = 4)  ;  ::arselect     := {}
                     ::sumColumn()
                     ::is_selAllRec := .F.

  case(menu = 6)  ;  if ::is_selAllRec
                       (::cfile)->(ads_setAof('.T.'))
                       (::cfile)->(ads_customizeAOF(::arselect,2), dbgotop())
                     else
                       (::cfile)->(ads_setAof('.F.'))
                       (::cfile)->(ads_customizeAOF(::arselect), dbgotop())
                     endif
                     ::oxbp:panHome()
                     ::arfilter := .t.

  case(menu = 7)  ;  (::cfile)->(ads_clearaof())
                     ::arfilter := .f.

  case(menu = 8)  ;  (::cfile)->(AdsSetOrder(ctag))
                     ::order:setCaption( adbd:indexDef[order]:ccaption)

                     ordKey := (::cfile)->(ordKey())
                     if lower( left(ordKey, 5)) <> 'upper'
                       ::scope_Button:disable()
                     else
                       ::scope_Button:enable()
                     endif

                     ::ordtype := valtype((::cfile)->(sx_keydata()))
                     if(isobject(::oseek), ::oseek:setData(''), nil)

                     if ismethod(::drgDialog:udcp, 'post_ordChanged')
                       ::drgDialog:udcp:post_ordChanged()
                     endif


  case(menu = 10)  ; ::toRecNo := .not. ::toRecNo
                     lall := .f.

  case(menu = 20)  ; ::broColumn()
                     lall := .f.

  case(menu = 21)  ; ::frmInfo()
                     lall := .f.

  case(menu = 22)  ; ::set_ndistrib(order)
                     lall := .t.

  endcase

  if(lall,::oxbp:refreshAll(),::oxbp:refreshCurrent())
  PostAppEvent(xbeBRW_ItemMarked,,,::oxbp)
return self


*
method deBrowse:refresh(lAll)
  DEFAULT lAll TO .T.

  if(lall, ::oXbp:refreshAll(), ::oXbp:refreshCurrent())
return self

*
method deBrowse:resize(aold,anew)
  local nx  := anew[1] -aold[1], ;
        ny  := anew[2] -aold[2], ;
        isX := (substr(::optResize,1,1) = 'y'), ;
        isY := (substr(::optResize,2,1) = 'y'), newX, newY

* new Browse size
  newX := if(isX, ::oXbp:currentSize()[1] +nX, ::oXbp:currentSize()[1] )
  newY := if(isY, ::oXbp:currentSize()[2] +nY, ::oXbp:currentSize()[2] )
  ::oXbp:setSize({newX,newY},.f.)
  ::oXbp:refreshAll()
return self

*
method deBrowse:maxbro( oXbp)
  Local cFile   := oXbp:cargo:cFile
  Local cTag    := (cFile)->( OrdSetFocus())
  Local nRecno  := (cFile)->( RecNO())
  Local cScoTop := (cFile)->( dbScope( SCOPE_TOP ))
  Local cScoBot := (cFile)->( dbScope( SCOPE_BOTTOM ))
  Local cFilter := (cFile)->( Ads_GetAOF())
  Local aParams := { cFile, cTag, nRecNo, cScoTop, cScoBot, cFilter }

  IF ::drgDialog:formName <> "SYS_maxBRO"
    DRGDIALOG FORM 'SYS_maxBRO' PARENT ::drgDialog CARGO_USR aParams MODAL DESTROY
    *
    If( !Empty( cFilter), (cFile)->( Ads_SetAOF( cFilter)), NIL )
    (cFile)->( dbGoTO( nRecNo))
    (cFile)->( AdsSetOrder( cTag))
  ENDIF
return self

*
method deBrowse:destroy()
  ::drgObject:destroy()

  ::nrecno           := ;
  ::cfile            := ;
  ::dbarea           := ;
  ::ardef            := ;
  ::isfile           := ;
  ::order            := ;
  ::ordtype          := ;
  ::scope_Button     := ;
  ::scope_Direction  := ;
  ::cellBGC          := ;
  ::toRecNo          := ;
  ::is_selAllRec     := ;
  ::arselect         := ;
  ::itemMarked       := ;
  ::adbd             := ;
  ::arfilter         := ;
  ::oseek            := ;
  ::paCols           := ;
  ::ocurCol          := ;
  ::stableBlock      := ;
  ::enabled_ins      := ;
  ::enabled_insCykl  := ;
  ::enabled_enter    := ;
  ::enabled_del      := ;
  ::enabled_sizeCols := NIL
return


*
** CLASS for ebro_memo_edit ****************************************************
CLASS ebro_memoEdit FROM drgUsrClass
EXPORTED:
  method  init, getForm, drgDialogInit, drgDialogStart

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
  local dc := ::drgDialog:dialogCtrl

  do case
  case(nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_SAVE)
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  case(nEvent = drgEVENT_APPEND   )
  case(nEvent = drgEVENT_FORMDRAWN)
    return .T.

  case(nEvent = xbeP_Keyboard)
    do case
    case(mp1 = xbeK_ESC)
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    otherwise
      return .f.
    endcase

  otherwise
    return .f.
  endcase
return .t.

hidden:
  var  drgGet, m_item, m_odrg
ENDCLASS


method ebro_memoEdit:init(parent)
  Local nEvent,mp1,mp2,oXbp, odrg

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  endif

  ::m_item  := parent:cargo
  ::m_odrg  := parent:parent:dataManager:has(::m_item)

  ::drgUsrClass:init(parent)
return self


method ebro_memoEdit:getForm()
  local  oDrg, drgFC
  *
  local  subTitle := '... popis položky dokladu ...'

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 80,7 DTYPE '10' TITLE subTitle GUILOOK 'All:N,Border:Y,ICONBAR:N'

  DRGMLE '' INTO drgFC FPOS 0,1.2 SIZE 80,5.5 RESIZE 'yx' SCROLL 'ny'
    odrg:name := ::m_item

  DRGSTATIC INTO drgFC FPOS 0.2,0 SIZE 79.8,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX
    DRGTEXT INTO drgFC CAPTION '['      CPOS  2,.1 CLEN  2 FONT 5
    DRGTEXT INTO drgFC CAPTION subTitle CPOS  3,.1 CLEN 55 CTYPE 1 FONT 5
    DRGTEXT INTO drgFC CAPTION ']'      CPOS 60,.1 CLEN  2 FONT 5

    DRGPUSHBUTTON INTO drgFC POS 76.5,.05 SIZE 3,1 ATYPE 1 ICON1 102 ICON2 202 EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
  DRGEND  INTO drgFC
return drgFC


method ebro_memoEdit:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}   // -25}
  endif
return


method ebro_memoEdit:drgDialogStart(drgDialog)
  local odrg := drgDialog:dataManager:has(::m_item)

  if( isobject(::m_odrg), odrg:set(::m_odrg:value), nil)
return .t.

*
**
CLASS _drgDBrowse FROM _deBrowse
  EXPORTED:
  inline method init(line)
    ::_deBrowse:init(line)
    ::type := 'DBrowse'
    ::name := 'DBROWSE'
  return self
ENDCLASS


*
**
CLASS _drgEBrowse FROM _deBrowse
  EXPORTED:
  inline method init(line, F, fileName, nType)
    local  pF := F, pfileName := fileName, st, name, type, aDesc, fields := ''

    ::_deBrowse:init(line)
    ::type := 'EBrowse'
    ::name := 'EBROWSE'

    if .not. isNull(line)
      do while (st := _drgEBrowseGetFileds(@pF, @pfileName, @nType) ) != NIL
        type  := drgGetParm("TYPE",st)
        if lower( left(type,3) ) = 'end'
          EXIT
        endif

        name  := '{ |a| ' + '_drg' + type + '():new(a) }'
        aDesc := EVAL(&name, st)

        fields += aDesc:name                                                                  +':' ;
               +  _drgEBrowseCaption(aDesc)                                                   +':' ;
               +  _drgEBrowseLen(aDesc)                                                       +':' ;
               +  isNull(aDesc:picture,'')                                                    +':' ;
               +  if( isNull(aDesc:isbit_map, .f.), '2', '')                                  +','
      enddo
      ::fields := substr(fields, 1, len(fields) -1)
    endif
  return self


  inline method createColumn(drgFC)
    local  nbeg := ascan(drgFC:members, self) +1, x, aDesc, fields := ''

    for x := nbeg to len(drgFC:members) step 1
      aDesc := drgFC:members[x]
      fields += aDesc:name                                +':' ;
             +  _drgEBrowseCaption(aDesc)                 +':' ;
             +  _drgEBrowseLen(aDesc)                     +':' ;
             +  isNull(aDesc:picture,'')                  +':' ;
             +  if( isNull(aDesc:isbit_map, .f.), '2', '')+','
    next
    ::fields := substr(fields, 1, len(fields) -1)
  return self
ENDCLASS


static function _drgEBrowseCaption(aDesc)
  do case
  case isNull(aDesc:caption) .and. isNull(aDesc:fcaption)
    return ''
  case isNull(aDesc:caption)
    return aDesc:fcaption
  otherwise
    return aDesc:caption
  endcase
return ''


static function _drgEBrowseLen(aDesc)
  do case
  case isNull(aDesc:clen) .and. isNull(aDesc:flen)
    return ''
  case isNull(aDesc:clen)
    return str(aDesc:flen)
  otherwise
    return str(aDesc:clen)
  endcase
return ''


static function _drgEBrowseGetFileds(mF, mData, nType)
  local  x, st, line := '', lEmpty := .f.

  do while .t.
    if (x := at( chr(13), mData, mF)) > 0
      st := subStr(mData, mF, x -mF)
      mF := x+2
    elseif empty(line)
      return nil
    else
      return line
    endif

    if lEmpty .and. len(rtrim(st)) < 5 .and. left(st,1) != '*'
      return st
    endif

    st := rtrim(st)
    if len(st) < 5 .or. left(st,1) = "*"
      LOOP
    endif

    if right(st,1) $ "+;"
      line += left(st, len(st) -1)
      LOOP
    else
      line += st
    endif
    return line
  enddo
return nil


*
**
class _deBrowse from _drgObject
  EXPORTED:

  var     fields     , browseInit, itemSelected, itemMarked, cursorMode
  var     indexord   , scroll    , lFreeze     , rFreeze   , popupMenu , Colored
  var     atStart    , rest      , headMove    , footer    , guiLook   , stableBlock
  var     noreqColum

  method  init, parse, destroy
endclass


method _deBrowse:init(line)
  ::type := 'Dbrowse'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::fPos  TO {0, 0}
  DEFAULT ::cursorMode  TO XBPBRW_CURSOR_CELL
  DEFAULT ::indexord    TO 1
  DEFAULT ::scroll      TO 'yy'
  DEFAULT ::resize      TO 'yy'
  DEFAULT ::popupmenu   TO 'nn'
  DEFAULT ::colored     TO {}
  default ::atStart     TO nil
  default ::rest        TO 'y'
  default ::headMove    TO 'y'
  default ::footer      TO 'n'
  default ::guiLook     TO ''
  default ::noreqColum  TO ''
  // pokud není klauzule NOREQCOLUM uvedena nelze žádný sloupec uživatelem vypustit z BRO
return self


method _deBrowse:parse(line)
  local keyWord, value

  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'FIELDS'        ;  ::fields       := _getStr(value)
    CASE keyWord == 'BROWSEINIT'    ;  ::browseInit   := _getStr(value)
    CASE keyWord == 'ITEMSELECTED'  ;  ::itemSelected := _getStr(value)
    CASE keyWord == 'ITEMMARKED'    ;  ::itemMarked   := _getStr(value)
    CASE keyWord == 'LOAD'          ;  ::itemMarked   := _getStr(value)
    CASE keyWord == 'CURSORMODE'    ;  ::cursorMode   := _getNum(value)
    CASE keyWord == 'INDEXORD'      ;  ::indexord     := _getNum(value)
    CASE keyWord == 'SCROLL'        ;  ::scroll       := LOWER( _getStr(value) )
    CASE keyWord == 'LFREEZE'       ;  ::lFreeze      := LOWER( _getStr(value) )
    CASE keyWord == 'RFREEZE'       ;  ::rFreeze      := LOWER( _getStr(value) )
    CASE keyWord == 'POPUPMENU'     ;  ::popupmenu    := LOWER( _getStr(value) )
    CASE keyWord == 'COLORED'       ;  ::colored      := LOWER( _getStr(value) )
    case keyWord == 'ATSTART'       ;  ::atStart      := LOWER( _getStr(value) )
    case keyword == 'REST'          ;  ::rest         := LOWER( _getStr(value) )
    case keyWord == 'HEADMOVE'      ;  ::headMove     := LOWER( _getStr(value) )
    case keyWord == 'FOOTER'        ;  ::footer       := LOWER( _getStr(value) )
    case keyWord == 'GUILOOK'       ;  ::guiLook      := _getStr(value)
    case keyWord == 'STABLEBLOCK'   ;  ::stableBlock  := _getStr(value)
    case keyWord == 'NOREQCOLUM'    ;  ::noreqColum   := LOWER( _getStr(value) )

    CASE ::parsed(keyWord, value)
    ENDCASE
  ENDDO
return

method _deBrowse:destroy()
  ::_drgObject:destroy()

  ::fields       := ;
  ::browseInit   := ;
  ::itemSelected := ;
  ::itemMarked   := ;
  ::cursorMode   := ;
  ::indexord     := ;
  ::scroll       := ;
  ::lFreeze      := ;
  ::rFreeze      := ;
  ::popupmenu    := ;
  ::colored      := ;
  ::footer       := ;
                    NIL
return