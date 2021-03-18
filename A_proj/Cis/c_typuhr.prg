#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for c_typuhr *********************************************************
CLASS c_typuhr FROM drgUsrClass
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  *
  ** bro column
   * bro col for pokladms
  inline access assign method is_Eet() var is_Eet
    return if( c_typUhr->npokladEET = 1, 559, 0 )

  inline access assign method is_hotov() var is_hotov
    return if(c_typuhr->lisHotov, MIS_ICON_OK, 0)

  inline access assign method is_inkaso() var is_inkaso
    return if(c_typuhr->lisInkaso, MIS_ICON_OK, 0)

  inline access assign method is_regPok() var is_regPok
    return if(c_typuhr->lisregPok, MIS_ICON_OK, 0)

  inline access assign method is_regDef() var is_regDef
    return if(c_typuhr->lisregDef, MIS_ICON_OK, 0)

  inline access assign method is_itZaokr() var is_itZaokr
    return if(c_typuhr->nisITzaokr = 1, MIS_ICON_OK, 0)

  inline method onLoad(isAppend)
    ::comboBoxInit( ::dm:has( 'c_typUhr->ctypPohybu'):odrg )
    ::enable_or_disable_Items()
  return self


  inline method comboBoxInit(drgComboBox)
    local  cname      := lower(drgParseSecond(drgComboBox:name,'>'))
    local  onSort     := 2, isOk := .f.
    local  acombo_val := {}, ky := F_POKLADNA

    aadd( acombo_val, {  '', space(50), '', '', '', '', '', '', 0 } )

    do case
    case('ctyppohybu' = cname)
      isOk := .t.

      c_typpoh->(dbsetscope(SCOPE_BOTH,ky), dbgotop())
      do while .not. c_typpoh ->(eof())
        if upper(c_typpoh->ctypDoklad) = 'FIN_PODOPR'
          typdokl ->(dbseek(c_typpoh ->(sx_keyData())))
          aadd( acombo_val, { c_typpoh ->ctyppohybu       , ;
                              c_typpoh ->cnaztyppoh       , ;
                              c_typpoh ->ctypdoklad       , ;
                              alltrim(typdokl  ->ctypcrd) , ;
                              c_typpoh->ctask             , ;
                              c_typpoh->csubtask          , ;
                              c_typpoh->craddph091        , ;
                              c_typpoh->cvypSAZdan        , ;
                              c_typpoh->npokladEET          } )
        endif
        c_typpoh->(dbskip())
      ENDDO
      c_typpoh ->(dbclearscope())
    endcase

    if isOk
      drgComboBox:oXbp:clear()
      drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[onSort] < aY[onSort] } )
      aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
    endif

    * musíme nastavit startovací hodnotu *
    drgComboBox:value := drgComboBox:ovar:value
    drgComboBox:refresh()
  return self


  inline method comboItemSelected(drgComboBox)
    local  cname := lower(drgParseSecond(drgComboBox:name,'>'))
    local  value := drgcomboBox:Value, values := drgcomboBox:values
    local  nin

    do case
    case('ctyppohybu' = cname)
      nin := ascan(values, {|X| X[1] = value })
      ::dm:set('c_typUhr->ctypdoklad', values[nin,3] )
      ::dm:set('c_typUhr->npokladEET', values[nin,9] )
    endcase
  return self


  inline method checkItemSelected(drgCheckBox)
    ::enable_or_disable_Items()
  return self


  inline method enable_or_disable_Items()
    if ::ochb_isRegPok:value
      ::ocmb_pokladEet:oxbp:enable()
      ::oget_pokladna:oxbp:disable()
      ::oget_pokladna:pushGet:oxbp:disable()
      ::ocmb_typPohybu:oxbp:disable()

      ::oget_pokladna:ovar:set(0)
      ::dm:set('pokladms->cnazPoklad', '' )
      ::ocmb_typPohybu:refresh('')

    else
      ::ocmb_pokladEet:oxbp:disable()
      ::oget_pokladna:oxbp:enable()
      ::oget_pokladna:pushGet:oxbp:enable()
      ::ocmb_typPohybu:oxbp:enable()
    endif
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = xbeBRW_ItemMarked)
     ::dm:refresh()

    case(nevent = drgEVENT_FORMDRAWN)
      if ::lsearch
        postAppEvent(xbeP_Keyboard,xbeK_LEFT,,::brow:oxbp)
        return .t.
      else
        return .f.
      endif

    case nEvent = drgEVENT_EDIT
      if ::lsearch
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
*        ::drgDialog:cargo := &(oXbp:cargo:arDef[1,2])

        ::drgDialog:cargo := c_typuhr->czkrTypUhr
        return .t.
      endif

    case(nevent = drgEVENT_MSG)
      if mp2 = DRG_MSG_ERROR
        _clearEventLoop()
         SetAppFocus(::drgDialog:dialogCtrl:oBrowse:oXbp)
         return .t.
      endif
      return .f.

    endcase
  return .f.


  inline method destroy()
    ::drgUsrClass:destroy()
  return self

RETURN self


HIDDEN:
  var    msg, dm, dc, df, ab, brow
  *
  var    drgGet, lsearch, value
  var    ochb_isRegPok, ocmb_pokladEet, oget_pokladna, ocmb_typPohybu
ENDCLASS


method c_typuhr:init(parent)

  ::value   := if( isNull(parent:cargo), '',parent:cargo)
  ::lsearch := .not. isNull(parent:cargo)

  ::drgUsrClass:init(parent)

  drgDBMS:open('c_typpoh')
  drgDBMS:open('typdokl' )  ;  typdokl->(AdsSetOrder('TYPDOKL01'))
return self


method c_typuhr:drgDialogInit(drgDialog)

  drgDialog:formHeader:title += if( ::lsearch, ' - VÝBÌR ...', '' )
return self


method c_typuhr:drgDialogStart(drgDialog)
  local aPP  := drgPP:getPP(2), oColumn, x

  ::brow    := drgDialog:dialogCtrl:oBrowse
  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form
  if isobject(drgDialog:oActionBar)
    ::ab      := drgDialog:oActionBar:members    // actionBar
  endif

  if ::lsearch
    for x := 1 TO ::brow:oXbp:colcount
      ocolumn := ::brow:oXbp:getColumn(x)
      ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
      ocolumn:configure()
    next

    if .not. c_typuhr->(dbseek(upper(::value),,'TYPUHR1'))
      c_typuhr->(dbgoTop())
    endif
    ::brow:oXbp:refreshAll()
  endif

  ::ochb_isRegPok  := ::dm:has('c_typUhr->lisRegPok' )
  ::ocmb_pokladEet := ::dm:has('c_typUhr->npokladEET'):odrg
  ::oget_pokladna  := ::dm:has('c_typUhr->npokladna' ):odrg
  ::ocmb_typPohybu := ::dm:has('c_typUhr->ctypPohybu'):odrg

  isEditGet( { 'c_typuhr->ctypDoklad' }, ::drgDialog, .F. )
return


method c_typuhr:postLastField(drgVar)
return .t.