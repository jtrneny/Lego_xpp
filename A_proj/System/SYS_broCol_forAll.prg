#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"

  #include '..\DRG_miss_DLL\drgRTF.ch'
  #include 'ot4xb.ch'

#include "..\Asystem++\Asystem++.ch"

  #pragma library( "ot4xb.lib"   )

*
*****************************************************************
CLASS SYS_broCol_forAll FROM drgUsrClass
EXPORTED:
  method init, drgdialogStart
  method getForm
  method destroy
  method doSave

  var    sel_DBrowse
  var    odBrowse, m_deBrowse

  inline method drgDialogEnd()
    if( .not. empty( B_Fieldsw->( ads_getAof()) ), B_Fieldsw->( ads_clearAof()), nil )
    if( .not. empty( X_Fieldsw->( ads_getAof()) ), X_Fieldsw->( ads_clearAof()), nil )
  return self

  inline access assign method c_fields() var c_fields
    return drgParseSecond(s_Fieldsw->cvyraz_1, '>')

  inline access assign method dataArea_sumColum() var dataArea_sumColum
    return if( B_Fieldsw->nsumCol = 1, 461, 0 )


  inline access assign method dataArea_ColorBG()  var dataArea_ColorBG
    return '  '


  inline method createContext(mp1,mp2,obj)
    local omenu := XbpImageMenu():new( obj )

    omenu:create()
    omenu:addItem({ 'Upravit barvu sloupce ...  ' , {|| ::getColor() },, XBPMENUBAR_MIA_OWNERDRAW }, 6112 )
    omenu:addItem({ 'Definovat písmo sloupce ...' , {|| ::getFont()  },, XBPMENUBAR_MIA_OWNERDRAW }, 6101 )
    omenu:popup(obj,mp1)
    return self

    inline method GetColor( nColor, oDlg )
      local oBro := ::m_deBrowse:oxbp, ocolumn, xColor
      local oColorStruct, paColors

      STATIC cCustColors:= nil

      DEFAULT nColor TO 0, ;
              oDlg   TO SetAppWindow()

      IF cCustColors = nil
         cCustColors:= Replicate( L2Bin( 16777215 ), 16 )
      ENDIF
      paColors:= _xGrab( cCustColors )

      IF paColors != 0
         oColorStruct:= COLORSTRUC():new()
            oColorStruct:lStructSize   := 36
            oColorStruct:hwnd          := oDlg:getHWND()
            oColorStruct:hInstance     := 0
            oColorStruct:rgbResult     := nColor
            oColorStruct:lpCustColors  := paColors
            oColorStruct:flags         := xCC_RGBINIT + xCC_FULLOPEN + IIF( 'Windows 9' $ Os(), xCC_SOLIDCOLOR, 0 )
            oColorStruct:lCustData     := 0
            oColorStruct:lpfnHook      := 0
            oColorStruct:lpTemplateName:= 0

         IF @COMDLG32:ChooseColorA( oColorStruct ) = 1
            nColor := oColorStruct:rgbResult
            xColor := AutomationTranslateColor( nColor, .t.)
         ENDIF
         cCustColors:= PeekStr( paColors, 0, 64 )
         _xfree( paColors )

         if B_FieldsW->ncount <> 0
           ocolumn   := oBro:getColumn( B_FieldsW->ncount )
           ocolumn:dataArea:cargo := xColor
           ::oBro_B_Fieldsw:refreshCurrent()
         endif
      ENDIF
      RETURN nColor

   inline method getFont( oDlg )
     local oBro := ::m_deBrowse:oxbp, oColumn
     local oFontDialog, oFont, xFont

     default oDlg to SetAppWindow()

     ocolumn     := ::oBro_B_Fieldsw:getColumn(3) // oBro:getColumn( B_FieldsW->ncount )

     oFontDialog := XbpFontDialog():New()
       oFontDialog:underscore := .f.
       oFontDialog:strikeOut  := .f.
       oFontDialog:familyName := ocolumn:dataArea:setFontCompoundName() // "Times New Roman"
       oFontDialog:create()

     oFont := oFontDialog:display( XBP_DISP_APPMODAL )

     if isobject(oFont)
       ocolumn := ::oBro_B_Fieldsw:getColumn(3)

       xFont := str( oFont:nominalPointSize, 2) +'.' +oFont:compoundName   // familyName

       ocolumn:dataArea:setFontCompoundName( xFont )           //   oFont:compoundName )
       ocolumn:DataAreaLayout[XBPCOL_DA_COMPOUNDNAME] := xFont //   oFont:compoundName

       ::fuj( ::oBro_B_Fieldsw )

       ocolumn:DataAreaLayout[XBPCOL_DA_ROWHEIGHT]    := 50
*       ocolumn:dataArea:maxRow := 5
       oColumn:configure()

       ::oBro_B_Fieldsw:refreshAll()
     endif
     return


  inline method fuj ( oBro )
    local c, ocolumn

    for x := 1 to oBro:colCount step 1
      ocolumn := oBro:getColumn(x)

      if ocolumn:type = XBPCOL_TYPE_TEXT
*        ocolumn:type := XBPCOL_TYPE_MULTILINETEXT
      endif

      ocolumn:DataAreaLayout[XBPCOL_DA_ROWHEIGHT]    := 50
*       ocolumn:DataAreaLayout[XBPCOL_DA_CELLHEIGHT]   := 10
*       ocolumn:dataArea:maxRow := 1
       oColumn:configure()
    next
    oBro:configure()
    return



  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local n_mp1 := if( isNumber(mp1), mp1, 0 )

    if isworkVersion
      if nevent = xbeM_RbDown .and. setAppFocus():className() = 'xbpBrowse'
        ::createContext(mp1,mp2,oxbp )
      endif
    endif

    if( n_mp1 = drgEVENT_SAVE, ::doSave(), nil )
    if  n_mp1 = drgEVENT_APPEND .or. n_mp1 = drgEVENT_APPEND2 .or. n_mp1 = drgEVENT_DELETE
       return .t.
    endif

    if setAppFocus() = ::oBro_B_Fieldsw
      if( B_Fieldsw ->(eof()), ::obtn_delFrom_B_Fieldsw:disable(), ::obtn_delFrom_B_Fieldsw:enable() )
      ::obtn_addTo_B_Fieldsw:disable()

      do case
        case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
*        ::setOperand()
        return .t.

      case (nEvent = xbeP_Keyboard)
        if mp1 = xbeK_ALT_ENTER
*          ::setOperand()
          return .t.
        endif
      endcase
    endif

    if setAppFocus() = ::oBro_X_Fieldsw
      if( X_Fieldsw ->(eof()), ::obtn_addTo_B_Fieldsw:disable()  , ::obtn_addTo_B_Fieldsw:enable()   )
      ::obtn_delFrom_B_Fieldsw:disable()
    endif
    return .f.


  inline method comboBoxInit(drgComboBox)
    local  x, odbd, acombo_val := {}
    local  cfile, cdesc

    do case
    case( 'sel_dbrowse' $ lower(drgComboBox:name) )
      for x := 1 to len( ::odBrowse) step 1
        cfile := ::odBrowse[x]:cfile
        cdesc := ''

        do case
        case ::odBrowse[x]:oxbp:parent:className()        = 'XbpTabPage'
          cdesc := ::odBrowse[x]:oxbp:parent:caption
        case ::odBrowse[x]:oxbp:parent:parent:className() = 'XbpTabPage'
          cdesc := ::odBrowse[x]:oxbp:parent:parent:caption
        endcase

        if (npos := at( ':', cdesc)) <> 0
          cdesc := allTrim( subStr( cdesc, npos +1))
        endif

        if IsObject( odbd := drgDBMS:dbd:getByKey(cfile))
          aadd( acombo_val, { cfile, cdesc +if( empty(cdesc), '', '_ ') +odbd:description, ::odBrowse[x] } )
        endif
      next

      drgComboBox:oXbp:clear()
      drgComboBox:values := acombo_val
      AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
    endcase
    return self

  inline method comboItemSelected(drgComboBox)
    local  value := drgComboBox:Value, values := drgComboBox:values
    local  nin

    do case
    case( 'sel_dbrowse' $ lower(drgComboBox:name) )
      nin := AScan(values, {|X| X[1] = value })

      if values[nin,3] <> ::m_deBrowse
        ::m_deBrowse := values[nin,3]
        ::setSysFilter()
       endif
    endcase
    return .t.

  inline method delFrom_B_Fieldsw()
    X_Fieldsw->(dbappend())
    X_Fieldsw->ncount   := B_Fieldsw->ncount
    X_Fieldsw->cvyraz_u := B_Fieldsw->cvyraz_u
    X_Fieldsw->cfield   := B_Fieldsw->cfield
    X_Fieldsw->cfield_m := B_Fieldsw->cfield_m

    B_Fieldsw->_delRec := '9'

    if( ::oBro_B_Fieldsw:rowPos = 1, ::oBro_B_Fieldsw:gotop(), nil )
    ::oBro_B_Fieldsw:refreshAll()

    ::oBro_X_Fieldsw:goBottom():refreshAll()

    PostAppEvent(xbeBRW_ItemMarked,,,::oBro_B_Fieldsw )
    SetAppFocus(::oBro_B_Fieldsw)
    return self

  inline method addTo_B_Fieldsw()
    local oBro

    if B_fieldsw->( dbseek( X_Fieldsw->ncount,,'Fieldsw02'))

      X_Fieldsw->( dbdelete())

      B_Fieldsw->_delRec := ''

      if( ::oBro_X_Fieldsw:rowPos = 1, ::oBro_X_Fieldsw:gotop(), nil )
      ::oBro_X_Fieldsw:refreshAll()

      ::oBro_B_Fieldsw:refreshAll()

      oBro := if( X_Fieldsw->( eof()), ::oBro_B_Fieldsw, ::oBro_X_Fieldsw )
      PostAppEvent(xbeBRW_ItemMarked,,,oBro )
      SetAppFocus(oBro)
    endif
    return self

HIDDEN:
  var   groups
  var   obtn_delFrom_B_Fieldsw, obtn_addTo_B_Fieldsw
  var   oBro_B_Fieldsw        , oBro_X_Fieldsw


  inline method setSysFilter()
    local cfiltr

    ::groups := ::m_deBrowse:cfile
      cfiltr := format( "cfield_m = '%%'", { padr(::groups,10) } )

    B_Fieldsw->( ads_setAof(cfiltr), dbgoTop())
    X_Fieldsw->( ads_setAof(cfiltr), dbgoTop())

    ::oBro_B_Fieldsw:goTop():refreshAll()
    ::oBro_X_Fieldsw:goTop():refreshAll()

    PostAppEvent(xbeBRW_ItemMarked,,,::oBro_B_Fieldsw )
    SetAppFocus(::oBro_B_Fieldsw)
    return self


  * LEFT  - B_Fieldsw - nastavené položky BRO uživatelem
  * RIGHT - X_Fieldsw - seznam zrušených položek BRO pro nastavení uživatelem
  *******
  inline method create_BX_FieldsW()
    local cfile, citem, odesc
    local pa_defColum
    local defCap, defName, defLen, defPict, defType, sumColum
    *
    local obro, asize, cdesc, groups, ncount

    for nBro := 1 to len( ::odBrowse ) step 1
      oBro   := ::odBrowse[ nBro ]:oxbp
      groups := ::odBrowse[ nBro ]:cfile
      ncount := 1

      for n := 1 to obro:colCount step 1
        ocol  := obro:getColumn(n)
        asize := ocol:currentSize()
        *
        ** pùvodní barva sloupce
*        ocol:dataArea:cargo := ocol:dataArea:setColorBG()

        pa_defColum  := ocol:defColum

          defCap   := pa_defColum.defCap     // záhlaví sloupce
          defName  := pa_defColum.defName    // fieldName - var - fce
          defLen   := pa_defColum.defLen     // šíøka sloupce
          defPict  := pa_defColum.defPict    // picture
          defType  := pa_defColum.defType    // typ sloupce XBPCOL_TYPE_
          sumColum := ocol:sumColum          // souètový sloupec

          cfile   := drgParse( defName, '-')
          citem   := drgParseSecond( defName,'>')

          if isobject(odesc := drgDBMS:getFieldDesc(cfile, citem))
            cdesc := right( odesc:desc, 32)
          else
            cdesc := 'Virtuální datová položka'
          endif

        B_Fieldsw->(dbappend())

        B_Fieldsw->ncount   := ncount
        B_Fieldsw->cvyraz_u := cdesc
        B_Fieldsw->cfield   := drgParseSecond(defName, '>')
        B_Fieldsw->cfield_m := groups
        B_Fieldsw->nsumCol  := sumColum

        if asize[1] = 0
          B_Fieldsw->_delRec  := if( asize[1] = 0, '9', '' )

          X_Fieldsw->(dbappend())

          X_Fieldsw->ncount   := ncount
          X_Fieldsw->cvyraz_u := cdesc
          X_Fieldsw->cfield   := drgParseSecond(defName, '>')
          X_Fieldsw->cfield_m := groups
          X_Fieldsw->nsumCol  := sumColum
        endif
        ncount++
      next
    next
    return self

ENDCLASS


method SYS_broCol_forAll:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('B_Fieldsw' ,.T., .T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('X_Fieldsw' ,.T., .T.,drgINI:dir_USERfitm); ZAP

  ::odBrowse   := parent:parent:odBrowse
  ::m_deBrowse := parent:cargo_usr
return self


method SYS_broCol_forAll:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers, x
  local  className
  *
  local  ocolumn

  for x := 1 to len(members) step 1
    className := members[x]:ClassName()

    do case
    case className = 'drgDBrowse'
      do case
      case lower(members[x]:cfile) = 'b_fieldsw' ;  ::oBro_B_Fieldsw := members[x]:oxbp
      case lower(members[x]:cfile) = 'x_fieldsw' ;  ::oBro_X_Fieldsw := members[x]:oxbp
      endcase

    case className = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case members[x]:event = 'delFrom_B_Fieldsw'  ;  ::obtn_delFrom_B_Fieldsw := members[x]
        case members[x]:event = 'addTo_B_Fieldsw'    ;  ::obtn_addTo_B_Fieldsw   := members[x]
        endcase
      endif

    endcase
  next

*  ocolumn := ::oBro_B_Fieldsw:getColumn(1)
*  ocolumn:colorBlock :=  {|| sys_broColumn_colorBlock(::m_deBrowse) }

*  xColumn := ::oBro_B_Fieldsw:getColumn(3)
*  xColumn:dataArea:DrawMode       := XBP_DRAW_OWNERADVANCED
*  xColumn:dataArea:customDrawCell := { |oPS, aInfo, self| sys_broColumn_font( oPs, aInfo, self ) }


  ::create_BX_FieldsW()
  ::setSysFilter()
return self


static function MISS_broColumn_font( oPs, aInfo, self )
return .t.

*
**
static function MISS_broColumn_colorBlock( m_deBrowse )
  local oBro   := m_deBrowse:oxbp, ocolumn
  local ncolor
  local acolor := { , , ,  }

   if B_FieldsW->ncount <> 0
     ocolumn   := oBro:getColumn( B_FieldsW->ncount )
     ncolor    := ocolumn:dataArea:cargo

     acolor[2] := acolor[4] := ncolor
    endif
return acolor
**
*

method SYS_broCol_forAll:getForm()
  local drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 112,18 DTYPE '10' TITLE 'Uživatelské nastavení sloupcù pohledu ...' ;
                                 GUILOOK 'Message:Y,Action:n,IconBar:y:MyIconBar,Menu:n'


  * LEFT - B_Fieldsw - nastavené položky BRO uživatelem
  *******
  DRGDBROWSE INTO drgFC FPOS 0,2.2 SIZE 52,16 FILE 'B_Fieldsw'   ;
             FIELDS 'M->dataArea_sumColum:s:2.8::1,'           + ;
                    'M->dataArea_ColorBG::3,'                  + ;
                    'ncount:pol:3,'                            + ;
                    'cvyraz_u:Uživatelský název pole:31,'      + ;
                    'cfield:promìnná:11'                         ;
             ITEMMARKED 'itemMarked' SCROLL 'ny' CURSORMODE 3 PP 9  POPUPMENU 'nn' RESIZE 'ny'


  * RIGHT - X_Fieldsw - seznam položek BRO pro nastavení uživatelem
  ******
  DRGSTATIC INTO drgFC FPOS 64,0.1 SIZE 47,1.3 RESIZE 'y'
    odrg:ctype := 2

    DRGTEXT INTO drgFC CAPTION 'Seznam položek k nastavení' CPOS 1, .5 CLEN 46 FONT 7
    odrg:ctype := 1
  DRGEND INTO drgFC

  DRGDBROWSE INTO drgFC FPOS 63,2.2 SIZE 48,16 FILE 'X_FieldsW'    ;
             FIELDS 'ncount:pol:3,'                              + ;
                    'cvyraz_u:Uživatelský název pole:30,'        + ;
                    'cfield:promìnná:11'                           ;
             ITEMMARKED 'itemMarked' SCROLL 'ny' CURSORMODE 3 PP 9  POPUPMENU 'nn' RESIZE 'ny'

  DRGSTATIC INTO drgFC FPOS 1,0.1 SIZE 50.5,1.3
    odrg:ctype := 2

    DRGTEXT INTO drgFC CAPTION 'Položky pohledu -->' CPOS 1,0.5 CLEN 15
    DRGCOMBOBOX M->sel_dbrowse INTO drgFC FPOS 19,.6 FLEN 30 VALUES 'a,a,a'  ;
                               COMBOINIT 'comboBoxInit' ITEMSELECTED 'comboItemSelected'
  DRGEND  INTO drgFC

  * center
  DRGPUSHBUTTON INTO drgFC CAPTION '>>' POS 53, 9 SIZE 10,1 ATYPE 3  ;
                ICON1 110 EVENT 'delFrom_B_Fieldsw' TIPTEXT 'Odstranit položku ...'

  DRGPUSHBUTTON INTO drgFC CAPTION '<<' POS 53,11 SIZE 10,1 ATYPE 33 ;
                ICON1 107 EVENT 'addTo_B_Fieldsw'  TIPTEXT 'Pøidat položku ...'

  *
  DRGPUSHBUTTON INTO drgFC CAPTION '    ~Ulož'  ;
                           POS 53,15.5          ;
                           SIZE 10,1.1          ;
                           ATYPE 3              ;
                           ICON1 101            ;
                           ICON2 201            ;
                           EVENT 'doSave' TIPTEXT 'Ulož nastavení sloupcù ...'
  DRGPUSHBUTTON INTO drgFC CAPTION '    ~Storno';
                           POS 53,16.7          ;
                           SIZE 10,1.1          ;
                           ATYPE 3              ;
                           ICON1 102            ;
                           ICON2 202            ;
                           EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
return drgFC


method SYS_broCol_forAll:doSave()
  local  nBro, cfiltr, ocolumn, asize, clen
  *
  B_FieldsW->( ordSetFocus('FIELDSW02'), dbgotop())

  for nBro := 1 to len( ::odBrowse ) step 1
    oBro   := ::odBrowse[ nBro ]:oxbp
    groups := padr( ::odBrowse[ nBro ]:cfile, 10)
    cfiltr := format( "cfield_m = '%%'", {groups} )

    B_FieldsW->( ads_setAof(cfiltr), dbgoTop())

    if( ::m_deBrowse:oxbp = oBro,  oBro:lockUpdate(.t.), nil )

    do while .not. B_FieldsW->(eof())
      ocolumn := oBro:getColumn( B_FieldsW->ncount )
        asize := ocolumn:currentSize()

      do case
      case B_FieldsW->_delRec = '9'

        ocolumn:disable()
        ocolumn:setSize( { 0, asize[2] } )
        ocolumn:hide()
      case asize[1] = 0
        clen := len( allTrim(B_FieldsW->cvyraz_u)) * drgINI:fontW

        ocolumn:enable()
        ocolumn:setSize( { clen, asize[2] } )
        ocolumn:show()
      endcase

      B_FieldsW->( dbskip())
    enddo

    oBro:panHome():configure()
    if( ::m_deBrowse:oxbp = oBro,  oBro:lockUpdate(.f.), nil )
  next

  postAppEvent(xbeP_Close,,,::drgDialog:dialog)
return self


method SYS_broCol_forAll:destroy()
  ::drgUsrClass:destroy()

return self


**************************
BEGIN STRUCTURE COLORSTRUC
**************************
   MEMBER DWORD  lStructSize
   MEMBER HWND   hwnd
   MEMBER HWND   hInstance
   MEMBER DWORD  rgbResult
   MEMBER LPSTR  lpCustColors
   MEMBER DWORD  Flags
   MEMBER LPARAM lCustData
   MEMBER LONG   lpfnHook
   MEMBER LPSTR  lpTemplateName
END STRUCTURE