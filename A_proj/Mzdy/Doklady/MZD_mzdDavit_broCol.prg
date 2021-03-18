#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"

#include "..\Asystem++\Asystem++.ch"


*
*****************************************************************
CLASS MZD_mzdDavit_broCol FROM drgUsrClass
EXPORTED:
  method init, drgdialogStart  // , drgDialogEnd
  method getForm
  method destroy
  method doSave

  var    sel_DBrowse


  inline access assign method c_fields() var c_fields
    return drgParseSecond(s_Fieldsw->cvyraz_1, '>')


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local n_mp1 := if( isNumber(mp1), mp1, 0 )

    if( n_mp1 = drgEVENT_SAVE, ::doSave(), nil )
    if  n_mp1 = drgEVENT_APPEND .or. n_mp1 = drgEVENT_APPEND2 .or. n_mp1 = drgEVENT_DELETE
       return .t.
    endif

    if setAppFocus() = ::oBro_B_Fieldsw
      if( B_Fieldsw ->(eof()), ::obtn_delFrom_B_Fieldsw:disable(), ::obtn_delFrom_B_Fieldsw:enable() )
      ::obtn_addTo_B_Fieldsw:disable()
    endif

    if setAppFocus() = ::oBro_X_Fieldsw
      if( X_Fieldsw ->(eof()), ::obtn_addTo_B_Fieldsw:disable()  , ::obtn_addTo_B_Fieldsw:enable()   )
      ::obtn_delFrom_B_Fieldsw:disable()
    endif
    return .f.


  inline method comboBoxInit(drgComboBox)
    local  acombo_val := {}
    *
    local  x, groups, citem

    do case
    case( 'sel_dbrowse' $ lower(drgComboBox:name) )
      for x := 1 to len( ::odBrowse) step 1

        groups := ::odBrowse[x]:groups
        citem  := if( groups = 'MZD_PRIJEM', 'Hrubá mzda    ', ;
                  if( groups = 'MZD_SRAZKY', 'Srážka ze mzdy', 'Nemocenské    ' ))

        aadd( acombo_val, { groups, citem, ::odBrowse[x] } )
      next

      drgComboBox:oXbp:clear()
      drgComboBox:values := acombo_val
      AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

      drgComboBox:refresh( ::m_deBrowse:groups )
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
  var   odBrowse, m_deBrowse
  var   groups
  var   obtn_delFrom_B_Fieldsw, obtn_addTo_B_Fieldsw
  var   oBro_B_Fieldsw        , oBro_X_Fieldsw


  inline method setSysFilter()
    local cfiltr

    ::groups := ::m_deBrowse:groups
      cfiltr := format( "cfield_m = '%%'", {::groups} )

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
    local defCap, defName, defLen, defPict, defType
    *
    local obro, asize, cdesc, groups, ncount

    for nBro := 1 to len( ::odBrowse ) step 1
      oBro   := ::odBrowse[ nBro ]:oxbp
      groups := ::odBrowse[ nBro ]:groups
      ncount := 1

      for n := 1 to obro:colCount step 1
        ocol  := obro:getColumn(n)
        asize := ocol:currentSize()

        pa_defColum  := ocol:defColum

          defCap  := pa_defColum.defCap     // záhlaví sloupce
          defName := pa_defColum.defName    // fieldName - var - fce
          defLen  := pa_defColum.defLen     // šíøka sloupce
          defPict := pa_defColum.defPict    // picture
          defType := pa_defColum.defType    // typ sloupce XBPCOL_TYPE_

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

        if asize[1] = 0
          B_Fieldsw->_delRec  := if( asize[1] = 0, '9', '' )

          X_Fieldsw->(dbappend())

          X_Fieldsw->ncount   := ncount
          X_Fieldsw->cvyraz_u := cdesc
          X_Fieldsw->cfield   := drgParseSecond(defName, '>')
          X_Fieldsw->cfield_m := groups
        endif
        ncount++
      next
    next
    return self

ENDCLASS


method MZD_mzdDavit_broCol:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('B_Fieldsw' ,.T., .T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('X_Fieldsw' ,.T., .T.,drgINI:dir_USERfitm); ZAP

  ::odBrowse   := parent:parent:odBrowse
  ::m_deBrowse := parent:cargo_usr
return self


method MZD_mzdDavit_broCol:getForm()
  local drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 110,18 DTYPE '10' TITLE 'Uživatelské nastavení sloupcù mzdových dokladù ...' ;
                                 GUILOOK 'Message:Y,Action:n,IconBar:y:MyIconBar,Menu:n'


  * LEFT - B_Fieldsw - nastavené položky BRO uživatelem
  *******
  DRGDBROWSE INTO drgFC FPOS 0,2.3 SIZE 48,16 FILE 'B_Fieldsw'   ;
             FIELDS 'ncount:pol:3,'                            + ;
                    'cvyraz_u:Uživatelský název pole:31,'      + ;
                    'cfield:promìnná:11'                         ;
             ITEMMARKED 'itemMarked' SCROLL 'ny' CURSORMODE 3 PP 9  POPUPMENU 'nn' RESIZE 'ny'


  * RIGHT - X_Fieldsw - seznam položek BRO pro nastavení uživatelem
  ******
  DRGSTATIC INTO drgFC FPOS 60,0.1 SIZE 48,1.3 RESIZE 'y'
    odrg:ctype := 2

    DRGTEXT INTO drgFC CAPTION 'Seznam položek k nastavení' CPOS 1, .5 CLEN 46 FONT 7
    odrg:ctype := 1
  DRGEND INTO drgFC

  DRGDBROWSE INTO drgFC FPOS 59,2.3 SIZE 48,16 FILE 'X_FieldsW'    ;
             FIELDS 'ncount:pol:3,'                              + ;
                    'cvyraz_u:Uživatelský název pole:30,'        + ;
                    'cfield:promìnná:11'                           ;
             ITEMMARKED 'itemMarked' SCROLL 'ny' CURSORMODE 3 PP 9  POPUPMENU 'nn' RESIZE 'ny'

  DRGSTATIC INTO drgFC FPOS 1,0.1 SIZE 47,1.3
    odrg:ctype := 2

    DRGTEXT INTO drgFC CAPTION 'Položky pohledu -->' CPOS 1,0.5 CLEN 15
    DRGCOMBOBOX M->sel_dbrowse INTO drgFC FPOS 16,.6 FLEN 30 VALUES 'a,a,a'  ;
                               COMBOINIT 'comboBoxInit' ITEMSELECTED 'comboItemSelected'
  DRGEND  INTO drgFC

  * center
  DRGPUSHBUTTON INTO drgFC CAPTION '>>' POS 49, 9 SIZE 10,1 ATYPE 3  ;
                ICON1 110 EVENT 'delFrom_B_Fieldsw' TIPTEXT 'Odstranit položku ...'

  DRGPUSHBUTTON INTO drgFC CAPTION '<<' POS 49,11 SIZE 10,1 ATYPE 33 ;
                ICON1 107 EVENT 'addTo_B_Fieldsw'  TIPTEXT 'Pøidat položku ...'

  *
  DRGPUSHBUTTON INTO drgFC CAPTION '    ~Ulož'  ;
                           POS 49,15.5          ;
                           SIZE 10,1.1          ;
                           ATYPE 3              ;
                           ICON1 101            ;
                           ICON2 201            ;
                           EVENT 'doSave' TIPTEXT 'Ulož nastavení sloupcù ...'
  DRGPUSHBUTTON INTO drgFC CAPTION '    ~Storno';
                           POS 49,16.7          ;
                           SIZE 10,1.1          ;
                           ATYPE 3              ;
                           ICON1 102            ;
                           ICON2 202            ;
                           EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
return drgFC


method MZD_mzdDavit_broCol:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers, x
  local  className

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

  ::create_BX_FieldsW()
  ::setSysFilter()
return self


method MZD_mzdDavit_broCol:doSave()
  local  nBro, cfiltr, ocolumn, asize, clen
  *
  B_FieldsW->( ordSetFocus('FIELDSW02'), dbgotop())

  for nBro := 1 to len( ::odBrowse ) step 1
    oBro   := ::odBrowse[ nBro ]:oxbp
    groups := ::odBrowse[ nBro ]:groups
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


method MZD_mzdDavit_broCol:destroy()
  ::drgUsrClass:destroy()

   d_Fieldsw->( dbcloseArea())
    s_Fieldsw->( dbcloseArea())
return self