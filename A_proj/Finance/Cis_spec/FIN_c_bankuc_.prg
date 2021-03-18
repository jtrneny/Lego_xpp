#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "Xbp.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"



*
** CLASS for FIN_c_bankuc ******************************************************
CLASS c_bankuc FROM drgUsrClass
EXPORTED:
  *
  ** název promìnné pro sekci komunikace
  var     csection, mDefin_kom

  method  init, drgDialogInit, drgDialogStart, postLastField
  method  checkItemSelected
  method  postValidate
  *
  method  onLoad, comboBoxInit, ComboItemSelected


  inline method tabSelect(oTabPage,tabnum)
    ::tabnum := tabnum
*    ::itemMarked()
  return .t.


  inline method set_datkomE()
    local idDatKomE := allTrim(::dm:get( 'c_bankuc->ciddatkome'))

    ::csection  := 'ciddatkome'
    ::sel_datkomhd_usr(idDatKomE)
  return self

  inline method set_datkozE()
    local idDatKozE := allTrim(::dm:get( 'c_bankuc->ciddatkoze'))

    ::csection  := 'ciddatkoze'
    ::sel_datkomhd_usr(idDatKozE)
  return self

  inline method set_datkomI()
    local idDatKomI := allTrim(::dm:get( 'c_bankuc->ciddatkomi'))

    ::csection  := 'import'
    ::sel_datkomhd_usr(idDatKomI)
  return self


  * bro col for c_bankuc
  inline access assign method isMain_uc() var isMain_uc
    return if( c_bankuc->lisMain, 300, 0)

  inline access assign method isDatKomE() var isDatKomE
    return if( .not. empty(c_bankuc->cIdDatKomE) .or. .not. empty(c_bankuc->cIdDatKozE), 505, 0 )

  inline access assign method isDatKomI() var isDatKomI
    return if( .not. empty(c_bankuc->cIdDatKomI), 505, 0 )


  * pøednastavíme cbank_uce / cbanis z cbank_uct
  * doplníme      cBIC               z c_banky   pokud ho najdeme
  inline access assign method set_uce_banis()
    local  cbank_Uct := ::oget_cbank_uct:ovar:value
    local  cbank_Uce := ::oget_cbank_uce:ovar:value
    local  cbanis    := ::oget_cbanis:ovar:value
    *
    local  npos

    if empty(cbank_Uce) .and. empty(cbanis)

      if ( npos := rat( '/',  cbank_Uct)) <> 0
        cbank_uce := strTran( allTrim( subStr( cbank_uct,      1, npos-1)), '-', '')
        cbanis    := allTrim( subStr( cbank_uct, npos+1         ))
      endif

      if .not. empty(cbanis)
        cbank_uce := padL( cbank_uce, 16, '0')

        ::dm:set( 'c_bankuc->cbank_uce', cbank_uce )
        ::dm:set( 'c_bankuc->cbanis'   , cbanis    )

        if c_banky ->(dbseek( upper(cbanis),, 'C_BANKY01'))
          ::dm:set( 'c_bankuc->cbic', c_banky->cbic )
          ::drgVar_bic:initValue := ::drgVar_bic:prevValue := ::drgVar_bic:value
        endif

        ::comboBoxInit( ::dm:has( 'c_bankuc->ciddatkome'):odrg )
        ::comboBoxInit( ::dm:has( 'c_bankuc->ciddatkomi'):odrg )
      endif
    endif
  return .t.

  
  * interface pro FIRMYFI - zmìna/ zrušení bankovního úètu má vazbu na FIRMYFI *
  inline method onSave(inSave,isAppend)
    local  x, odrg, members := ::df:aMembers
    local  initValue, value, block, lok
    *
    local  sName := ::tmp_Dir +allTrim(c_bankuc->ciddatkomi) +'.usr'

    if .not. isAppend
      begin sequence
      for x := 1 to len(members) step 1
        if members[x]:className() = 'drgGet'
          if lower(members[x]:name) = 'c_bankuc->cbank_uct'
            odrg := members[x]
      break
          endif
        endif
      next
      end sequence

      if isobject(odrg) .and. isFunction('onsave_c_bankuc')
         initValue := odrg:ovar:initValue
             value := odrg:ovar:value
         if initValue <> value
           block := &('{|a,b| ' + 'onsave_c_bankuc(a,b) }')
           lok   := EVAL( block, initValue, value)
         endif
      endif
    endif
  return .t.

  inline method onDelete()
    local  value := c_bankuc->cbank_uct
    local  block, lok

    if isFunction('ondelete_c_bankuc')
      block := &('{|a| ' + 'ondelete_c_bankuc(a) }')
      lok   := EVAL( block, value)
    endif
  return .t.


  inline method enable_datkom()
    local idDatKomE := allTrim(::dm:get( 'c_bankuc->ciddatkome'))
    local idDatKozE := allTrim(::dm:get( 'c_bankuc->ciddatkoze'))
    local idDatKomI := allTrim(::dm:get( 'c_bankuc->ciddatkomi'))

    if( empty(idDatKomE), ::obtn_datkomE:oxbp:disable(), ::obtn_datkomE:oxbp:enable() )
    if( empty(idDatKozE), ::obtn_datkozE:oxbp:disable(), ::obtn_datkozE:oxbp:enable() )
    if( empty(idDatKomI), ::obtn_datkomI:oxbp:disable(), ::obtn_datkomI:oxbp:enable() )
    return self

  **
  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local odrg

    do case
    case (nevent = drgEVENT_FORMDRAWN)
      if ::lsearch
        postAppEvent(xbeP_Keyboard,xbeK_LEFT,,::brow:oxbp)
        return .t.
      else
        return .f.
      endif

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        ::drgDialog:cargo := c_bankuc->cbank_uct  // &(oXbp:cargo:arDef[1,2])
        return .t.
      endif

    case( nevent = drgEVENT_SAVE)
      if isnull( ::lisMain, .f.)
        if c_bankuc->( Flock())
          fordRec( {'c_bankuc' } )
          c_bankuc->( dbgoTop(), ;
                      dbeval( { || c_bankuc->lisMain := .f. } ) )
        endif
        c_bankuc->(DbUnlock())
        fordRec()

        odrg := ::dm:has( 'c_bankuc->lisMain' )
        odrg:value := ::lisMain
      endif
      ::drgVar_bic:initValue := ::drgVar_bic:prevValue := ''
      return .f.

    case(nevent = drgEVENT_MSG)
      if mp2 = DRG_MSG_ERROR
         _clearEventLoop()
         SetAppFocus(::drgDialog:dialogCtrl:oBrowse:oXbp)
         return .t.
      endif
      return .f.

    endcase
  return .f.

HIDDEN:
  var    msg, dm, dc, df, ab, brow
  var    lisMain, drgVar_bic, odrgVar_defin_kom, tmp_Dir
  var    oget_cbank_uct, oget_cbank_uce, oget_cbanis
  var    obtn_datkomE, obtn_datkozE, obtn_datkomI
  *
  var    drgGet, lsearch, tabNum
  method sel_datkomhd_usr
ENDCLASS


method c_bankuc:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL

  drgDBMS:open( 'c_banky'  )
  drgDBMS:open( 'datkomhd' )


  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

  ::lsearch := (::drgGet <> NIL)
  ::tabNum  := 1
  ::tmp_Dir := drgINI:dir_USERfitm +userWorkDir() +'\'
  ::drgUsrClass:init(parent)
return self


method c_bankuc:drgDialogInit(drgDialog)

 drgDialog:formHeader:title += if( ::lsearch, ' - VÝBÌR ...', '' )
RETURN

return self


method c_bankuc:drgDialogStart(drgDialog)
  local  aPP  := drgPP:getPP(2), oColumn, x
  *
  local  members    := drgDialog:oForm:aMembers
  local  pa_groups, acolors  := MIS_COLORS

  ::brow    := drgDialog:dialogCtrl:oBrowse
  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form
  if isobject(drgDialog:oActionBar)
    ::ab      := drgDialog:oActionBar:members    // actionBar
  endif

  ::drgVar_bic        := ::dm:has('c_bankuc->cbic'      )
  ::odrgVar_defin_kom := ::dm:has('c_bankuc->mdefin_kom')

  for x := 1 TO Len(members) step 1
    do case
    case members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
         pa_groups := ListAsArray(members[x]:groups)
         nin       := ascan(pa_groups,'SETFONT')

         members[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

         if 'GRA_CLR' $ atail(pa_groups)
           if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
             members[x]:oXbp:setColorFG(acolors[nin,2])
           endif
         else
           members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
         endif
       endif

    case members[x]:ClassName() = 'drgPushButton'
      do case
      case members[x]:event = 'set_datkomE'  ;  ::obtn_datkomE := members[x]
      case members[x]:event = 'set_datkozE'  ;  ::obtn_datkozE := members[x]
      case members[x]:event = 'set_datkomI'  ;  ::obtn_datkomI := members[x]
      endcase

    case members[x]:ClassName() = 'drgGet'
      do case
      case lower(members[x]:name) = 'c_bankuc->cbank_uct' ;  ::oget_cbank_uct := members[x]
      case lower(members[x]:name) = 'c_bankuc->cbank_uce' ;  ::oget_cbank_uce := members[x]
      case lower(members[x]:name) = 'c_bankuc->cbanis'    ;  ::oget_cbanis    := members[x]
      endcase

    endcase
  next

  if ::lsearch
    for x := 1 TO ::brow:oXbp:colcount
      ocolumn := ::brow:oXbp:getColumn(x)
      ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
      ocolumn:configure()
    next

    if .not. c_bankuc->(dbseek(upper(::drgGet:ovar:value),,'BANKUC1'))
      c_bankuc->(dbgoTop())
    endif
    ::brow:oXbp:refreshAll()
  endif

return


method c_bankuc:postValidate( drgVar )
  local  name := Lower(drgVar:name)
  local  changed := drgVAR:Changed()

  do case
  case( name = 'c_bankuc->cbank_uct')
    ::set_uce_banis()

  case( name = 'c_bankuc->cbic' .and. changed )
    ::comboBoxInit( ::dm:has( 'c_bankuc->ciddatkome'):odrg )
    ::comboBoxInit( ::dm:has( 'c_bankuc->ciddatkomi'):odrg )

  endCase
return .t.


method c_bankuc:CheckItemSelected( CheckBox)
  local name := drgParseSecond( CheckBox:oVar:Name,'>')

  self:&Name := CheckBox:Value
  PostAppEvent(drgEVENT_OBJEXIT,,, checkBox:oXbp)
return self


method c_bankuc:postLastField(drgVar)
return .t.


method c_bankuc:onLoad()
  ::enable_datkom()

  ::comboBoxInit( ::dm:has( 'c_bankuc->ciddatkome'):odrg )
  ::comboBoxInit( ::dm:has( 'c_bankuc->ciddatkoze'):odrg )
  ::comboBoxInit( ::dm:has( 'c_bankuc->ciddatkomi'):odrg )
return self


// DATKOMH04, cmainFile, cidDatKom, cnazDatKom
// c_bankuc->CIDDatKomE
// c_bankuc->CIDDatKozE
// c_bankuc->CIDDatKomI

// FIN_PRUHTU
// FIN_PRUHZA

method c_bankuc:comboBoxInit( drgComboBox )
  local  cname         := lower(drgComboBox:name)
  local  aCOMBO_val    := { { '          ', space(50) } }
  local  cbic, cc, bForCondition
  *
  local  cForCondition := "( upper(datkomhd->ctypDatKom)       = '%%' .and. " + ;
                          "  allTrim( upper(datkomhd->cattr1)) = '%%' )"


  if isObject( ::dm )
    cbic := allTrim( upper( ::dm:get( 'c_bankuc->cbic')))

    datkomhd->( ordSetFocus( 'DATKOMH04')           , ;
                DbSetScope( SCOPE_BOTH, 'C_BANKUC' ), ;
                DbGoTop()                             )

    do case
    case ( 'ciddatkome' $ cname )
      cc := format( cForCondition, { 'E', cbic +'_T' })
      datkomhd->( dbeval( { || aadd( acombo_val, { datkomhd->cidDatKom, datkomhd->cnazDatKom }) }, ;
                          COMPILE( cc ) ))

    case ( 'ciddatkoze' $ cname )
      cc := format( cForCondition, { 'E', cbic +'_Z' })
      datkomhd->( dbeval( { || aadd( acombo_val, { datkomhd->cidDatKom, datkomhd->cnazDatKom }) }, ;
                          COMPILE( cc ) ))

    case ( 'ciddatkomi' $ cname )
      cc := format( cForCondition, { 'I', cbic })
      datkomhd->( dbeval( { || aadd( acombo_val, { datkomhd->cidDatKom, datkomhd->cnazDatKom }) }, ;
                            COMPILE( cc ) ))

    endcase

    datkomhd->( dbClearScope())
  endif

  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[1] < aY[1] } )
  AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

  * musíme nastavit startovací hodnotu *
  drgComboBox:value := drgComboBox:ovar:value
  drgComboBox:refresh()
return self


method c_bankuc:ComboItemSelected(drgComboBox)
  local cname := lower(drgComboBox:name)

  do case
  case ( 'ciddatkome' $ cname )
  case ( 'ciddatkoze' $ cname )
  case ( 'ciddatkomi' $ cname )
  endcase

  ::enable_datkom()
return self

*
** hiden
method c_bankuc:sel_datkomhd_usr(idDatKom)
  local  odialog, nExit := 0
  *
  local  sName, cc
  *
  local  idDatKomE := allTrim(::dm:get( 'c_bankuc->ciddatkome'))
  local  idDatKozE := allTrim(::dm:get( 'c_bankuc->ciddatkoze'))
  local  idDatKomI := allTrim(::dm:get( 'c_bankuc->ciddatkomi'))

  ::mDefin_kom := ''
  if datkomhd->( dbseek( upper(idDatKomE),,'DATKOMH01'))
    cc           := strTran( datkomhd->mDefin_kom, 'Users', 'Users_ciddatkome')
    ::mDefin_kom += cc +CRLF +CRLF
  endif

  if datkomhd->( dbseek( upper(idDatKozE),,'DATKOMH01'))
    cc           := strTran( datkomhd->mDefin_kom, 'Users', 'Users_ciddatkoze')
    ::mDefin_kom += cc +CRLF +CRLF
  endif

   if datkomhd->( dbseek( upper(idDatKomI),,'DATKOMH01'))
    cc           := strTran( datkomhd->mDefin_kom, 'Users', 'Users_import'   )
    ::mDefin_kom += cc +CRLF +CRLF
  endif
  *
  ** pokud neexistuje musíme ho založit
  myCreateDir( ::tmp_Dir )
    datkomhd->( dbseek( upper(idDatKom),,'DATKOMH01'))
    sName  := ::tmp_Dir +datkomhd->cidDatKom +'.usr'
    memoWrit( sName, ::odrgVar_defin_kom:value )

  DRGDIALOG FORM 'SYS_DATKOMHD_USR' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit = drgEVENT_SELECT
    ::odrgVar_defin_kom:set( memoRead( sName) )
  endif
return .t.