#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
//
#include "xbp.ch"
//
#include "..\Asystem++\Asystem++.ch"


#translate SET_typ(<c>) => ;
           AScan( {'FAKP','FAKPCEL','FAKPZAL','FAKPZAH','FAKPZAHZAL','FAKPEURO'}, ;
                  Upper(AllTrim(<c>))                                             )


**
** CLASS for MZD_trvZavhd_IN ***************************************************
CLASS MZD_trvZavhd_IN FROM drgUsrClass
exported:

  method  init, drgDialogStart
  method  comboBoxInit, comboItemSelected
  method  postValidate

  method  fir_firmyuc_sel


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case ( nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      return .f.

    case ( nEvent = drgEVENT_SAVE        )
      ::postSave()

      _clearEventLoop()
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      return .t.

    case ( nEvent = drgEVENT_APPEND .or. ;
           nEvent = drgEVENT_EDIT   .or. ;
           nEvent = drgEVENT_DELETE      )
      return .t.

    endcase
  return .f.

hidden:
  VAR     msg, dm, dc, df, ab, brow
  VAR     members
  var     o_varSym, val_povUcTrZa

  method  refresh, postSave
  var     lnewRec
ENDCLASS


method MZD_trvZavhd_in:init(parent)
  ::drgUsrClass:init(parent)

  ::lNEWrec       := ( parent:cargo = drgEVENT_APPEND )
  ::val_povUcTrZa := 0

  // TMP soubory //
  drgDBMS:open('trvZavHdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('trvZavItw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  IF ::lNEWrec
    trvZavHdw->(dbAppend())

    trvZavHdw ->CZKRATSTAT := SysConfig( 'System:cZaklStat' )
  ELSE
    mh_COPYFLD('trvZavHd', 'trvZavHdw', .T.)
  ENDIF

  * pro jistotu nalníme hlavièku vždy
  ( trvZavHdw ->cUloha     := "M"                             , ;
    trvZavHdw ->cZKRATMENY := SysConfig( 'Finance:cZaklMENA' ), ;
    trvZavHdw ->cZKRATMENZ := SysConfig( 'Finance:cZaklMENA' ), ;
    trvZavHdw ->cDENIK     := "MC"                            , ;
    trvZavHdw ->nMNOZPREP  := 1                               , ;
    trvZavHdw ->nKURZAHMEN := 1                                 )
return self


method MZD_trvZavhd_in:drgDialogStart(drgDialog)

  * NEWs *
  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager
  ::dc     := drgDialog:dialogCtrl              // dataCtrl
  ::df     := drgDialog:oForm                   // dialogForm
  ::ab     := drgDialog:oActionBar:members      // actionBar

  ::o_varSym := ::dm:get( 'trvZavhdw->cvarsym'  , .F.)
return self


method MZD_trvZavhd_in:comboBoxInit(drgComboBox)
  local  cname := lower( drgParseSecond(drgComboBox:name,'>'))
  local  acombo_val := {}, ky, block := { || .t. }, onSort := 2
  local  nin
  *
  drgDBMS:open('c_typpoh')
  drgDBMS:open('typdokl' )  ;  typdokl->(AdsSetOrder('TYPDOKL01'))

  do case
  case( 'ctyppohybu' $ cname )
    ky := M_ZAVAZKY

    c_typpoh->(dbsetscope(SCOPE_BOTH,ky), dbgotop())
    do while .not. c_typpoh ->(eof())
      if eval(block)
        typdokl ->(dbseek(c_typpoh ->(sx_keyData())))
        aadd( acombo_val, { c_typpoh ->ctyppohybu       , ;
                            c_typpoh ->cnaztyppoh       , ;
                            c_typpoh ->ctypdoklad       , ;
                            alltrim(typdokl  ->ctypcrd) , ;
                            c_typpoh->ctask             , ;
                            c_typpoh->csubtask          , ;
                            c_typpoh->craddph091        , ;
                            c_typpoh->npovUcTrZa          } )
      endif
      c_typpoh->(dbskip())
    endDo
    c_typpoh ->(dbclearscope())
  endcase

  if .not. empty( ky )
    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[onSort] < aY[onSort] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgComboBox:value := drgComboBox:ovar:value
    if( nin := AScan(drgComboBox:values, {|X| X[1] = drgComboBox:ovar:value })) <> 0
      ::val_povUcTrZa := drgComboBox:values[nin,8]
    endif
  endif
return self



method MZD_trvZavhd_in:comboItemSelected(drgComboBox,isMarked)
  local  cname := lower( drgParseSecond(drgComboBox:name,'>'))
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nIn, finTyp
  *
  local  textFakt, npos, cc

  do case
  case( 'ctyppohybu' $ cname )
    nIn      := AScan(values, {|X| X[1] = value })
    finTyp   := SET_typ(values[nIn,4])
    textFakt := values[nIn,2]

    if .not. IsNull(isMarked,.F.)
      trvZavHdw->ctypDoklad := values[nIn,3]
      trvZavHdw->ctypPohybu := values[nIn,1]
      trvZavHdw->nfinTyp    := finTyp

      if empty(trvZavHdw->ctextFakt)
        if( npos := at( '-', textFakt)) <> 0
          textFakt := subStr( textFakt, npos +1 )
        endif
        trvZavHdw->ctextFakt := allTrim( textFakt )
        ::dm:set( 'trvZavHdw->ctextFakt', allTrim( textFakt ))
      endif

      ::val_povUcTrZa       := values[nin,8]
    endif

  case( 'ctypvarsym' $ cname )
    trvZavhdw->ctypVarSym := value

    if empty( value )
      (::o_varSym:odrg:isEdit := .T., ::o_varSym:odrg:oxbp:enable())
    else
      trvZavhdw->cvarSym := ''
      ::o_varSym:set( '' )

      (::o_varSym:odrg:isEdit := .F., ::o_varSym:odrg:oxbp:disable())
    endif
  endcase


  if drgComboBox:ovar:changed()
    PostAppEvent(xbeP_Keyboard,xbeK_TAB,,drgComboBox:oxbp)
  endif
return self


method MZD_trvZavhd_in:postValidate(drgVar)
  local  value    := drgVar:get()
  local  name     := Lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))

  local  lOk := .t.

  if(lOk, eval(drgVar:block,drgVar:value), nil)

  do case
  case( name = 'trvzavhdw->cvarsym' )
    if empty( value )
      ::msg:writeMessage('Variabilní symbol je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    endif

  * cucet mùže být prázdný, tj. jedná se o srážku na úèet, který je nastavný buï
  * v msSrz_mo, nebo pøímo pøi poøízení dokladù srážek v mzdDavITw
  * pøímo na c_typpoh->npovUcTrZa = 1 povinný úèet
  case(name = 'trvzavhdw->cucet'     )
    if empty( value ) .and. ::val_povUcTrZa = 0
      lok := .t.
    else
      lok := ::fir_firmyuc_sel()
    endif

  case(name = 'trvzavhdw->czkrtypuhr'  )
    if .not. empty( value )
      trvzavhdw->nkodzaokr := c_typuhr->nkodzaokr
    endif
    lok := .t.

  case( name = 'druhymzdw->ndruhmzpre' )
    lok := ::mzd_druhyMzd_sel()

  case( name = 'druhymzdw->nprnapnaho' )
    if lOk .and. ( ::df:nexitState = GE_ENTER .or. ::df:nexitState = GE_DOWN )
      ::onSave()
    endif
  endcase
return lOk


method MZD_trvZavhd_in:fir_firmyuc_sel(drgDialog)
  local oDialog, nExit := drgEVENT_QUIT, fintyp := trvZavHdw->nfintyp, copy := .F.
  *
  local drgVar := ::dm:has('trvZavHdw->cucet')
  local value  := drgVar:get()
  local lOk    := FIRMYUC ->(DBseek(Upper(value),,'FIRMYUC2')) .and. .not. empty(value)

  IF IsObject(drgDialog) .or. .not. lOk
    DRGDIALOG FORM 'FIR_FIRMYUC_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                     EXITSTATE nExit
  ENDIF

  if (lOk .and. drgVar:itemChanged())
    copy := .T.
  elseif nexit != drgEVENT_QUIT
    copy := .T.
  endif

  if copy
    FIRMY ->( DbSeek( FIRMYUC ->nCISFIRMY,,'FIRMY1'))
    mh_COPYFLD('FIRMY', 'trvZavHdw',,.f.)

    if FIRMYFI ->(DbSeek( FIRMYUC ->nCISFIRMY,,'FIRMYFI1'))
      trvZavHdw ->cucet_uct  := firmyfi ->cuct_dod
      trvZavHdw ->czkrtypuhr := firmyfi ->czkrtypuhr
    endIf

    c_staty->(dbseek(upper(trvZavHdw->czkratstat),,'C_STATY1'))
    c_meny->(dbseek(upper(c_staty->czkratmeny,,'C_MENY1')))
    *
    if (trvZavHdw->nkurzahmen +trvZavHdw->nmnozprep = 0 .or. ;
       empty(trvZavHdw->czkratmenz)                     .or. ;
       (c_meny->czkratmeny <> trvZavHdw->czkratmenz)         )

       kurzit->(mh_seek(upper(c_meny->czkratmeny),2,,.t.))

       kurzit->( AdsSetOrder(2), dbsetScope(SCOPE_BOTH, UPPER(c_meny->czkratMeny)))
       cKy := upper(c_meny->czkratMeny) +dtos(date() )
       kurzit->(dbSeek(cKy, .T.))
       If( kurzit->nkurzStred = 0, kurzit->(dbgoBottom()), NIL )

       trvZavHdw->czkratmenz := c_meny->czkratmeny
       trvZavHdw->nkurzahmen := kurzit->nkurzstred
       trvZavHdw->nmnozprep  := kurzit->nmnozprep

       trvZavHdw->nkurzahmeD := kurzit->nkurzstred
       trvZavHdw->nmnozpreD  := kurzit->nmnozprep

       kurzit->(dbclearScope())
    endif

    trvZavHdw ->cucet := firmyuc ->cucet

    ::refresh( drgvar )
    ::dm:refresh()
*    ::df:setNextFocus('fakprihdw->dvystfakdo',,.T.)
  endif
return (nExit != drgEVENT_QUIT) .or. lOk


** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method MZD_trvZavhd_in:refresh(drgVar,nextFocus,vars_)
  local  nin, ovar, vars, new_val, dbArea

  default nextFocus to .f.

  if isobject(drgVar)  ;  dbarea := lower(drgParse(drgVar:name,'-'))
                          vars   := drgVar:drgDialog:dataManager:vars
  else                 ;  dbarea := lower(drgVar)
                          vars   := vars_
  endif

  for nIn := 1 TO vars:size() step 1
    oVar := vars:getNth(nIn)

    if (dbArea == lower(drgParse(oVar:name,'-')) .or. 'M' == drgParse(oVar:name,'-')) .and. isblock(ovar:block)
      if(new_val := eval(ovar:block)) <> ovar:value
        ovar:set(new_val)
      endif
      ovar:initValue := ovar:prevValue := ovar:value
    endif
  next

  if nextFocus
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
  endif
return .t.


method MZD_trvZavhd_in:postSave()
  local ok := .t.

  if ::lnewRec
    mh_copyFld( 'trvZavHdw', 'trvZavHd', .t.)

  else
    if trvZavHd->( sx_Rlock())
      mh_copyFld( 'trvZavHdw', 'trvZavHd' )
      trvZavHd->(dbUnlock())
    endif
  endif

  trvZavhd->( dbcommit())
  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
return ok