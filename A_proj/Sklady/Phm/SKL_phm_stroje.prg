#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"




* SKL_PHM_stroje.prg --- obsahuje class SCR / IN
*
****** CLASS for PRO_stroje_SCR ***********************************************
CLASS SKL_PHM_stroje_SCR FROM drgUsrClass
EXPORTED:
  var     rok, obdobi, rokobdobi
  VAR     newRec, drgGet
  var     nspo_Day, nspo_Month, nspo_Year

  METHOD  drgDialogStart
  method  comboBoxInit, comboItemSelected
  method  itemMarked

  *
  ** BRO column stroje
  inline access assign method spoMes_BC() var spoMes_BC
    local  cky := strZero(::rok,4) +strZero(::obdobi,2) +upper(stroje->cStroj), nspoMes := 0

     denStroj_S->( ordSetFocus('PHMSTRO_05')                      , ;
                   dbsetScope( SCOPE_BOTH, cKy)                   , ;
                   dbeval( { || nspoMes += denStroj_S->nspoDen } ), ;
                   dbclearScope()                                   )
   return nspoMes


  inline access assign method spoRok_BC() var spoRok_BC
    local  cky := strZero(::rok,4) +upper(stroje->cStroj), nspoRok := 0

     denStroj_S->( ordSetFocus('PHMSTRO_03')                      , ;
                   dbsetScope( SCOPE_BOTH, cKy)                   , ;
                   dbeval( { || nspoRok += denStroj_S->nspoDen } ), ;
                   dbclearScope()                                   )
  return nspoRok

  * stroje
  inline access assign method nazevMaj() var nazevMaj      // název majeku
    maj->( dbseek( stroje->ninvCis,,'MAJ02'))
    return maj->cnazev


  inline method init(parent)
    local  olastDrg

    ::drgUsrClass:init(parent)

    ::rok       := uctOBDOBI:SKL:NROK
    ::obdobi    := uctOBDOBI:SKL:NOBDOBI
    ::rokobdobi := uctOBDOBI:SKL:NROKOBD

    drgDBMS:open('firmy'     )
    drgDBMS:open('maj'       )
    drgDBMS:open('ucetSys'   )

    drgDBMS:open('PHMVYDden' )
    drgDBMS:open('PHMVYDstro')
    drgDBMS:open('PHMVYDstro',,,,,'denStroj_S')

    if isObject(parent:parent)
      if isObject( parent:parent:oform )
        if parent:parent:oform:olastDrg:className() = 'drgGet'
          ::drgGet := parent:parent:oform:olastDrg
        endif
      endif
    endif

    ::newRec := .F.
  return self

  inline method drgDialogInit(drgDialog)
    local  aPos, aSize
    local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

    if IsObject(::drgGet)
      **  XbpDialog:titleBar := .F.
      drgDialog:dialog:drawingArea:bitmap  := 1020
      drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

      if ::drgGet:oxbp:parent:className() = 'XbpCellGroup'
        aPos := mh_GetAbsPosDlg(::drgGet:oXbp:parent,drgDialog:dataAreaSize)
        aPos[1] := 50
        return self
//        ( apos[1] := 50, apos[2] += 24 )
      else
        aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
      endif
      drgDialog:usrPos := {aPos[1],aPos[2]}
    endif
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case ( nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT ) .and. isObject(::drgGet)
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)

    case( nEvent = drgEVENT_OBDOBICHANGED )
      ::rok       := uctOBDOBI:SKL:NROK
      ::obdobi    := uctOBDOBI:SKL:NOBDOBI
      ::rokobdobi := uctOBDOBI:SKL:NROKOBD
      ::oDBro_stroje:oxbp:refreshAll()

    otherwise
      return .f.
    endcase
  return .t.

HIDDEN:
  var     oDBro_stroje
  VAR     nFile, cFile, dm, dc, df, msg, oBro
  var     curr_datPoh
ENDCLASS


METHOD SKL_phm_stroje_scr:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers
  local  x, odrg, groups, name, tipText
  local  acolors  := MIS_COLORS, pa_groups, nin, pa_noEdit := {}

  if( isObject(::drgGet), drgDialog:odbrowse[1]:enabled_enter := .f., nil )

  ::dm       := drgDialog:dataManager             // dataMananager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // dialogForm
  ::msg      := drgDialog:oMessageBar             // messageBar
  ::obro     := drgDialog:dialogCtrl:oBrowse[1]:oXbp

  ::oDBro_stroje := ::dc:oBrowse[1]

  ::nspo_Day   := 0
  ::nspo_Month := 0
  ::nspo_Year  := 0

    *
  for x := 1 to len(members) step 1
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)


    if odrg:className() = 'drgText' .and. .not. empty(groups)
      pa_groups := ListAsArray(groups)

      * XBPSTATIC_TYPE_RAISEDBOX           12
      * XBPSTATIC_TYPE_RECESSEDBOX         13

      if odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13
        odrg:oxbp:setColorBG(GRA_CLR_BACKGROUND)
      endif

      if ( nin := ascan(pa_groups,'SETFONT') ) <> 0
        odrg:oXbp:setFontCompoundName(pa_groups[nin+1])
      endif

      if 'GRA_CLR' $ atail(pa_groups)
        if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
          odrg:oXbp:setColorFG(acolors[nin,2])
        endif
      else
        if isMemberVar(odrg, 'oBord') .and. ( odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13)
          odrg:oXbp:setColorFG(GRA_CLR_BLUE)
        else
          odrg:oXbp:setColorFG(GRA_CLR_DARKGREEN)
        endif
      endif

*      groups      := pa_groups[1]
*      odrg:groups := groups
    endif

    if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
      odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
    endif

    if odrg:ClassName() = 'drgStatic' .and. odrg:oxbp:type = XBPSTATIC_TYPE_ICON
*      ::sta_activeBro := odrg
    endif

    if odrg:ClassName() = 'drgGet'
      aadd( pa_noEdit, odrg:name )
    endif
  next
  *
  isEditGet( pa_noEdit, drgDialog, .F. )
RETURN self


METHOD SKL_phm_stroje_scr:comboBoxInit(drgComboBox)
  local  aCOMBO_val := {}
  local  ames       := {'. ledena '  , '. února ', '. bøezna ', '. dubna ', '. kvìtna '   ,'. èervna '  , ;
                        '. èervence ', '. srpna ', '. záøí '  , '. øíjna ', '. listopadu ','. prosince '  }


  phmVYDstro->( dbEval( { || if( ascan( aCOMBO_val, { |x| x[1] = dtos(phmVYDstro->ddatPoh) }) = 0, ;
                             AAdd( aCOMBO_val, { dtos(phmVYDstro->ddatPoh)             , ;
                                                 left( dtoc(phmVYDstro->ddatPoh), 2) + ;
                                                 ames[ Month(phmVYDstro->ddatPoh) ]  + ;
                                                 str( year( phmVYDstro->ddatPoh), 4)     } ), nil ) } ))

  * není denní výdej PHM
  if len(aCOMBO_val) = 0
    aadd(aCOMBO_val, { dtos(date()), left( dtoc(date()), 2) +ames[Month(date()) ] +str( year( date()), 4) } )
  endif

  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[1] > aY[1] } )
  AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

  ::curr_datPoh :=  stod( aCOMBO_val[1,1] )
RETURN SELF


method SKL_phm_stroje_scr:comboItemSelected(drgcombo,mp2,o)
  local  value := drgcombo:Value, values := drgcombo:values

  if(isnull(mp2),PostAppEvent(xbeP_Keyboard,xbeK_TAB,,drgCombo:oxbp),nil)
return .t.


method SKL_phm_stroje_scr:itemMarked()
  local  nrok   := strZero( year(::curr_datPoh), 4)
  local  nmesic := month(::curr_datPoh)
  local  ky     := strZero( year(::curr_datPoh), 4) +upper(stroje->cstroj)
  *
  local  nspo_Day := nspo_Month := nspo_Year := 0

* sumujeme PHMVYDstro
  phmVYDstro->(AdsSetOrder('PHMstro_03'),dbsetscope(SCOPE_BOTH,ky),dbgotop())

  do while .not. phmVYDstro->( eof())
    if( ::curr_datPoh = phmVYDstro->ddatPoh       , nspo_Day   += phmVYDstro->nspoDen, nil )
    if( nmesic        = month(phmVYDstro->ddatPoh), nspo_Month += phmVYDstro->nspoDen, nil )
                                                    nspo_Year  += phmVYDstro->nspoDen

    phmVYDstro->(dbskip())
  enddo

  ::nspo_Day   := nspo_Day
  ::nspo_Month := nspo_Month
  ::nspo_Year  := nspo_Year

**  ::dm:set('m->nspo_Month', ::spoMes_BC )
return self



*
** CLASS for SKL_phm_stroje_IN *************************************************
CLASS SKL_phm_stroje_IN FROM drgUsrClass
exported:
  var     lNEWrec
  method  init, drgDialogStart
  method  postValidate

  method  fir_firmy_sel, skl_cenzboz_sel, c_naklst_vld

  * stroje
  inline access assign method nazevMaj() var nazevMaj      // název majeku
    majSW->( dbseek( strojeW->ninvCis,,'MAJ02'))
    return majSW->cnazev

  *
  * onSave
  inline method onSave(lOk,isAppend,oDialog)
    local  mainOk := .t.

    if .not. ::c_naklst_vld()
      ::restColor()
      return .f.
    endif

    if .not. ::lnewRec
      stroje->( dbgoTo( strojeW->_nrecOr))
      mainOk := stroje->(sx_rLock())
    endif

    if mainOk
      mh_copyFld( 'strojeW', 'stroje', ::lnewRec, .f. )
    else
      drgMsgBox(drgNLS:msg('Nelze modifikovat STROJE, blokováno uživatelem ...'))
    endif

    stroje->(dbunlock(),dbcommit())
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  return mainOk

  inline method restColor()
    local members := ::df:aMembers

    oxbp := setAppFocus()
    aeval(members, {|X| if(ismembervar(x,'clrFocus'), x:oxbp:setcolorbg(x:clrfocus), nil) })
    return .t.


hidden:
* sys
  var     msg, dm, dc, df
  var     hd_file
  var     odrg_invCis
ENDCLASS


method SKL_phm_stroje_in:init(parent)
  local file_name

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('stroje',,,,,'stroje_S' )

  drgDBMS:open('maj')
  drgDBMS:open('maj',,,,,'majSW')

  drgDBMS:open('firmy'   )
  drgDBMS:open('cenzboz' )
  drgDBMS:open('c_naklSt')

  *
  ::lNEWrec := .not. (parent:cargo = drgEVENT_EDIT)
  ::hd_file := 'strojeW'
  *
  skl_phm_stroje_cpy(self)
return self


method SKL_phm_stroje_in:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers
  local  x, odrg, groups, name, tipText
  local  acolors  := MIS_COLORS, pa_groups, nin

  ::msg             := drgDialog:oMessageBar             // messageBar
  ::dm              := drgDialog:dataManager             // dataManager
  ::dc              := drgDialog:dialogCtrl              // dataCtrl
  ::df              := drgDialog:oForm                   // form
  *
*  ::msg:can_writeMessage := .f.
*  ::msg:msgStatus:paint  := { |aRect| ::info_in_msgStatus(aRect) }

  ::odrg_invCis     := ::dm:has('strojeW->ninvCis'   )

  *
  for x := 1 to len(members) step 1
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)


    if odrg:className() = 'drgText' .and. .not. empty(groups)
      pa_groups := ListAsArray(groups)

      * XBPSTATIC_TYPE_RAISEDBOX           12
      * XBPSTATIC_TYPE_RECESSEDBOX         13

      if odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13
        odrg:oxbp:setColorBG(GRA_CLR_BACKGROUND)
      endif

      if ( nin := ascan(pa_groups,'SETFONT') ) <> 0
        odrg:oXbp:setFontCompoundName(pa_groups[nin+1])
      endif

      if 'GRA_CLR' $ atail(pa_groups)
        if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
          odrg:oXbp:setColorFG(acolors[nin,2])
        endif
      else
        if isMemberVar(odrg, 'oBord') .and. ( odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13)
          odrg:oXbp:setColorFG(GRA_CLR_BLUE)
        else
          odrg:oXbp:setColorFG(GRA_CLR_DARKGREEN)
        endif
      endif

*      groups      := pa_groups[1]
*      odrg:groups := groups
    endif

    if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
      odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
    endif

    if odrg:ClassName() = 'drgStatic' .and. odrg:oxbp:type = XBPSTATIC_TYPE_ICON
*      ::sta_activeBro := odrg
    endif
  next
  *
  isEditGet( { 'strojew->cskladMOo', 'strojew->cnazZboMOo', ;
               'strojew->cskladPRo', 'strojew->cnazZboPRo', ;
               'strojew->cskladHYo', 'strojew->cnazZboHYo', 'strojeW->cNAZPOL5'}, drgDialog, .F. )
return self


METHOD SKL_phm_stroje_in:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  * kontroly na hlavièce strojeW  cstroj, cSPZstroj
  case( field_name = 'cstroj' )
    if empty(value)
      fin_info_box( 'Èíslo stroje je povinný údaj ...',XBPMB_CRITICAL)
      ok := .f.
    else
      if stroje_S->( dbseek( upper(value),, 'STROJE01'))
        fin_info_box( 'Èíslo stroje již v seznamu strojù existuje ...',XBPMB_CRITICAL)
        ok := .f.
      else
        ::dm:set( 'strojeW->cnazStroj', cnazPol5S->cnazev )
        strojeW->cnazStroj := cnazPol5S->cnazev
      endif
    endif

  case( field_name = 'cspzstroj' )
    if empty(value)
      fin_info_box( 'SPZ stroje je povinný údaj ...',XBPMB_CRITICAL)
      ok := .f.
    else
      if changed .and. stroje_S->( dbseek( upper(value),,'STROJE06' ))
        fin_info_box( 'SPZ stroje již v seznamu strojù existuje ...',XBPMB_CRITICAL)
        ok := .f.
      endif
    endif

  case( field_name = 'ninvcis' )
    if value <> 0
      if .not. majSW->( dbSeek( value,,'MAJ02'))
        fin_info_box('Zadané inventární èíslo neexistuje !!!', XBPMB_CRITICAL )
        ok := .f.
      endif
    endif
    ::dm:set( 'M->nazevMaj', majSW->cnazev )

  case( field_name = 'ncisfirmy' )
    ok := ::fir_firmy_sel()

  case( 'csklpol' $ field_name   )
    ok := ::skl_cenzboz_sel(drgVar)

  case ( field_Name = 'cnazpol6')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
    endif

  endcase

  * na strojeW ukládme vždy
  if('strojew' $ name .and. ok, drgVAR:save(),nil)
return ok


method SKL_phm_stroje_in:fir_firmy_sel(drgDialog)
  LOCAL oDialog, nExit:= drgEVENT_QUIT, copy := .f.
  Local drgVar := ::dm:get( 'strojeW->nCisFirmy', .F.)
  Local value  := drgVar:get()
  Local ok     := firmy->( dbseek( if( empty(value), -1, value),,'FIRMY1'))

  if( empty(value), ok := .t., nil )
  *
  ** firma není povinná
  If IsObject(drgDialog) .or. !ok
    _clearEventLoop(.t.)
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::drgDialog  MODAL DESTROY EXITSTATE nExit
  ENDIF

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ok := .T.
    ::dm:set( 'strojeW->ncisFirmy' , firmy->ncisFirmy)
    ::dm:set( 'strojeW->cnazFirmy' , firmy->cNazev   )

    strojeW->ncisFirmy := firmy->ncisFirmy
    strojeW->cnazFirmy := firmy->cnazev
  endif
return ok


method SKL_phm_stroje_in:skl_cenzboz_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, copy := .f.
  local  drgVar, value, field_exp, ok
  local  pa        := { 'strojeW->csklad...', 'strojeW->csklPol...', 'strojeW->cnazZbo...' }, x, cc, xVal
  *
  drgVar    := if( drgDialog:className() = 'drgDialog', ::df:olastDrg:ovar, drgDialog )
  value     := drgVar:get()
  field_exp := right( upper(drgParseSecond(drgVar:name, '>')), 3)
  ok        := cenZboz->( dbseek( if( empty(value), '-1', upper(value)),,'CENIK01'))

  if( empty(value), ok := .t., nil )
  *
  ** sklPoložka MOT_olej, PØEV_olej, HYDR_olej není povinná
  if drgDialog:className() = 'drgDialog' .or. .not. ok
    _clearEventLoop(.t.)
    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    for x := 1 to len(pa) step 1
      cc := strTran( pa[x], '...', field_exp )
      drgVar := ::dm:has( cc )
      drgVar:set( if( x = 1, cenZboz->ccisSklad, if( x = 2, cenZboz->csklPol, cenZboz->cnazZbo) ) )

      eval(drgVar:block,drgVar:value)
      drgVar:initValue := drgVar:value
    next
  endif
return ok


method SKL_phm_stroje_in:c_naklst_vld()
  local  drgVar_nazPol1 := ::dm:has( ::hd_file +'->cnazPol1' )
  *
  local  oDialog, nExit := drgEVENT_QUIT
  local  drgVar, x, cvalue := ''
  local  ok := .f., showDlg := .f.
  *
  local  members := ::df:aMembers, pos, drgGet


  for x := 1 to 6 step 1
    cvalue += padR( upper(::dm:get( ::hd_file +'->cnazPol' +str(x,1))), 8)
  next

  do case
  case(  empty(cvalue) )
    fin_info_box('Položku nelze uložit, nemá žádnou vypovídací hodnotu ...')
    ::df:setNextFocus(::hd_file +'->cnazPo1',,.t.)

  otherwise
    ok      := c_naklSt->(dbseek(cvalue,,'C_NAKLST1'))
    showDlg := .not. ok
  endcase

  if showDlg
    DRGDIALOG FORM 'c_naklst_sel' PARENT ::dm:drgDialog MODAL           ;
                                                        DESTROY         ;
                                                        EXITSTATE nExit ;
                                                        CARGO drgVar_nazPol1

    if nexit != drgEVENT_QUIT .or. ok
      for x := 1 to 6 step 1
        drgVar := ::dm:has(::hd_file + '->cnazPol' +str(x,1) )
        drgVar:set( DBGetVal('c_naklSt->cnazPol' +str(x,1)) )

        eval(drgVar:block,drgVar:value)
        drgVar:initValue := drgVar:value
      next
      ok := .t.
    else
      ::df:setNextFocus(::hd_file +'->cnazPol1',, .t.  )


*      olastDrg := ::dm:has(::hd_file +'->cnazPol6'):odrg
*      PostAppEvent(drgEVENT_OBJEXIT, oLastDRG,, oLastDRG:oXbp)
/*
      drgGet := ::dm:has(::hd_file +'->cnazPol1'):odrg

      pos := ascan(members,{|X| (x = drgGet )})
      ::df:olastdrg   := drgGet
      ::df:nlastdrgix := pos
      ::df:olastdrg:setFocus()

*      postAppEvent(drgEVENT_OBJENTER, self,, oXbp)
      SetAppFocus( drgGet:oXbp )
      _clearEventLoop(.t.)

/*
      ::df:setNextFocus(::hd_file +'->cnazPol1',, .t.  )
       _clearEventLoop()

      ::df:olastDrg := ::dm:has(::hd_file +'->cnazPol1'):odrg
      drgGet := ::dm:has(::hd_file +'->cnazPol1'):odrg
*/

    endif
  endif
return ok


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
static function skl_phm_stroje_cpy(oDialog)
  local  lnewRec := if( isNull(oDialog), .f., oDialog:lnewRec )

  ** tmp soubory **
  drgDBMS:open('STROJEw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  if lnewRec
    STROJEw->( dbappend())
  else
    mh_copyFld( 'STROJE', 'STROJEw', .t., .t. )
  endif
return nil