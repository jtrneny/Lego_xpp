#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
//
#include "..\FINANCE\FIN_finance.ch"

/*
TYPY vstupních karet --nFINTYP--                                  --párování záloh--
1 -> FAKPB  ->  FAKP       ... Faktura pøijatá bìžná                x
2 -> FAKPC  ->  FAKPCEL    ... Faktura pøijatá celní                -
3 -> FAKPZ  ->  FAKPZAL    ... Faktura pøijatá zálohová             -
4 -> FAKPZB ->  FAKPZAH    ... Faktura pøijatá zahranièní           x
5 -> FAKPZZ ->  FAKZAHZAL  ... Faktura pøijatá zahranièní zálohová  -
6 -> FAKPEU ->  FAKPEURO   ... Faktura pøijatá EURo                 x
*/


#translate SET_typ(<c>) => ;
           AScan( {'FAKP','FAKPCEL','FAKPZAL','FAKPZAH','FAKPZAHZAL','FAKPEURO'}, ;
                  Upper(AllTrim(<c>))                                             )

#define m_files  { 'typdokl' ,'c_typoh'                                                    , ;
                   'c_bankuc','c_dph'  ,'c_meny' ,'c_staty','c_typfak'                     , ;
                   'kurzit'  ,'firmy'  ,'firmyfi','firmyuc','parprzal','range_hd','range_it' }


**
** CLASS for FIN_fakprihd_IN ***************************************************
CLASS FIN_fakprihd_IN FROM drgUsrClass, FIN_finance_in
exported:
  var     lNEWrec, uctLikv, vykDph, prepZakl, it_file
  var     cmb_typPoh

  method  init, drgDialogStart, postSave, destroy
  method  comboItemSelected, comboItemMarked
  method  postValidate

  method  fir_firmyuc_sel, fin_parprzal


  inline access assign method prepZakl() var prepZakl
    local koeD := fakprihdw->nkurzahmed/fakprihdw->nmnozpred
  return(fakprihdw->ncenzahcel * koeD)

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_SAVE
      if( FIN_postSave():new('fakprihd',self):ok, ::postSave(), nil)
      return .t.

    otherwise
       return ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .f.

HIDDEN:
  VAR     aEdits, panGroup, members, butPar, roundDph
  METHOD  showGroup, refresh, vlde, vldc, vldz, zustpozao
  *

  INLINE METHOD value(name)
  LOCAL fullName := IF( '->' $ name, name, 'fakprihdw->' +name)
  RETURN ::dm:has(fullName):value
ENDCLASS


method FIN_fakprihd_in:init(parent)
  ::drgUsrClass:init(parent)
  *
  ::lNEWrec  := .not. (parent:cargo = drgEVENT_EDIT)
  ::it_file  := 'parprzalw'

   * základní soubory
  ::openfiles(m_files)

  * pro kontrolu
  drgDBMS:open('fakprihd',,,,,'fakpri_v')

  ::roundDph  := SysConfig('Finance:nRoundDph')
  fin_fakprihd_cpy(self)

  file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
               (::it_file) ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name,  ::it_file , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'parprzi_w', .t., .t.) ; parprzi_w  ->(AdsSetOrder(1))
return self


method FIN_fakprihd_in:drgDialogStart(drgDialog)

  ::FIN_finance_in:init(self,'zav')

  ::cmb_typPoh := ::dm:has('fakprihdw->ctyppohybu'):odrg
  ::aEdits     := {}
  ::panGroup   := '1'
  ::members    := drgDialog:oForm:aMembers

  posPar       := AScan(::members, {|X| IF( x:className() = 'drgPushButton', X:event = 'FIN_PARPRZAL', NIL) })
  ::butPar     := ::members[posPar]

  FOR x := 1 TO LEN(::members)
    IF ::members[x]:ClassName() = 'drgStatic' .and. .not.Empty(::members[x]:groups)
      AAdd(::aEdits, { ::members[x]:groups, x })
    ENDIF
  NEXT

  IF .not. ::lNEWrec
    ::dm:has('fakprihdw->cobdobi'   ):oDrg:isEdit := ;
    ::dm:has('fakprihdw->ncisfak'   ):oDrg:isEdit := ;
    ::dm:has('fakprihdw->ctyppohybu'):oDrg:isEdit := .F.

    ::df:setNextFocus('fakprihdw->cvarsym',,.T.)
  ELSE

    ::comboItemSelected(::dm:has('fakprihdw->ctyppohybu'):oDrg)
    ::df:setNextFocus('fakprihdw->ctyppohybu',, .T.)
  ENDIF

  *
  ::dm:has('m->prepZakl'):odrg:oxbp:setFontCompoundName('SETFONT,8.Arial CE')
  ::dm:has('m->prepZakl'):odrg:oxbp:setColorFG(GRA_CLR_BLUE)

  ::panGroup := Str( IF(FAKPRIHDw ->nFINTYP = 6, 1,FAKPRIHDw ->nFINTYP), 1)
  ::fin_finance_in:refresh('fakprihdw',,drgDialog:dataManager:vars)
  drgDialog:dataManager:refresh()
  ::showGroup()
  ::zustpozao()
RETURN self


method fin_fakprihd_in:postSave()
  local ok, file_name, value := ::cmb_typPoh:value

  ok := fin_fakprihd_wrt(self)

  if(ok .and. ::new_dok)
    fakprihdw->(dbzap())
    (::it_file)->(DbCloseArea())
    parprzi_w ->(DbCloseArea())

    fin_fakprihd_cpy(self)

    file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
                 (::it_file) ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'parprzi_w', .t., .t.) ; parprzi_w  ->(AdsSetOrder(1))

    ::cmb_typPoh:value := value
    ::comboItemSelected(::cmb_typPoh)

    ::fin_finance_in:refresh('fakprihdw',,::dm:vars)
    ::dm:refresh()
    ::showGroup()
    ::zustpozao()

    ::df:setnextfocus('fakprihdw->ctyppohybu',,.t.)
  elseif(ok .and. .not. ::new_dok)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return ok


METHOD FIN_fakprihd_IN:destroy()
  ::drgUsrClass:destroy()

  ::lNEWrec  := ;
  ::aEdits   := ;
  ::panGroup := ;
  ::members  := NIL

  (::it_file)->(DbCloseArea())
  parprzi_w ->(DbCloseArea())

  *
  if(select('vykdph_pw') <> 0, vykdph_pw->(dbclosearea()), nil)
  if(select('vykdph_ps') <> 0, vykdph_ps->(dbclosearea()), nil)

  if(select('ucetpolw') <> 0, ucetpolw->(dbclosearea()), nil)
  if(select('ucetpols') <> 0, ucetpols->(dbclosearea()), nil)
  FAKPRIHD ->(ads_clearAof())
RETURN


*
**
method FIN_fakprihd_in:fir_firmyuc_sel(drgDialog)
  local oDialog, nExit := drgEVENT_QUIT, fintyp := fakprihdw ->nfintyp, copy := .F.
  *
  local drgVar := ::dm:has('fakprihdw->cucet')
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
    mh_COPYFLD('FIRMY', 'FAKPRIHDw',,.f.)

    IF FIRMYFI ->(DbSeek( FIRMYUC ->nCISFIRMY,,'FIRMYFI1'))
      fakprihdw ->cucet_uct  := IF( fintyp = 3 .or. fintyp = 5, firmyfi ->cuct_fpz, firmyfi ->cuct_dod)
      fakprihdw ->czkrtypuhr := firmyfi ->czkrtypuhr
    ENDIF

    c_staty->(dbseek(upper(fakprihdw->czkratstat),,'C_STATY1'))
    c_meny->(dbseek(upper(c_staty->czkratmeny,,'C_MENY1')))
    *
    if (fakprihdw->nkurzahmen +fakprihdw->nmnozprep = 0 .or. ;
       empty(fakprihdw->czkratmenz)                     .or. ;
       (c_meny->czkratmeny <> fakprihdw->czkratmenz)         )

       kurzit->(mh_seek(upper(c_meny->czkratmeny),2,,.t.))

       kurzit->( AdsSetOrder(2), dbsetScope(SCOPE_BOTH, UPPER(c_meny->czkratMeny)))
       cKy := upper(c_meny->czkratMeny) +dtos(fakprihdw->dvystFak)
       kurzit->(dbSeek(cKy, .T.))
       If( kurzit->nkurzStred = 0, kurzit->(dbgoBottom()), NIL )

       fakprihdw->czkratmenz := c_meny->czkratmeny
       fakprihdw->nkurzahmen := kurzit->nkurzstred
       fakprihdw->nmnozprep  := kurzit->nmnozprep

       fakprihdw->nkurzahmeD := kurzit->nkurzstred
       fakprihdw->nmnozpreD  := kurzit->nmnozprep

       kurzit->(dbclearScope())
    endif

    fakprihdw ->cucet := firmyuc ->cucet

    ::fin_finance_in:refresh(drgVar)
    ::dm:refresh()
    ::restColor()
    ::df:setNextFocus('fakprihdw->dvystfakdo',,.T.)

    ::showGroup()
  ENDIF
return (nExit != drgEVENT_QUIT) .or. lOk


METHOD FIN_fakprihd_IN:fin_parprzal()
  local  oDialog, nExit
  local  koeZ  := fakprihdw->nkurzahmen/fakprihdw->nmnozprep

  IF (FAKPRIHDw ->nFINtyp = 1 .or. FAKPRIHDw ->nFINtyp = 4 .or. FAKPRIHDw ->nFINtyp = 6)
    oDialog := drgDialog():new('FIN_parprzal',self:drgDialog)
    oDialog:create(,self:drgDialog:dialog,.F.)

    ::dm:set('fakprihdw->nparzahfak', oDialog:udcp:sumPar)
    fakprihdw->nparzahfak := oDialog:udcp:sumPar
    fakprihdw->nparzalfak := oDialog:udcp:sumPar *koeZ

    oDialog:destroy(.T.)
    oDialog := NIL
  ENDIF
RETURN self


method FIN_fakprihd_IN:comboItemSelected(drgComboBox,isMarked)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nIn, finTyp

  do case
  case right(drgComboBox:name,7) = 'COBDOBI'
    ::cobdobi(drgComboBox)

  case 'CTYPPOHYBU' $ drgComboBox:name
    nIn := AScan(values, {|X| X[1] = value })

    finTyp := SET_typ(values[nIn,4])

    IF .not. IsNull(isMarked,.F.)
      FAKPRIHDw->cTYPDOKLAD := values[nIn,3]
      FAKPRIHDw->cTYPPOHYBU := values[nIn,1]
      FAKPRIHDw->nFINTYP    := finTyp
      fakprihdw->ciszal_fak := if(finTyp = 3 .or. finTyp = 5, '1', '0')

      * celní
      if(finTyp = 2, ::dm:has('fakprihdw->nparzahfak'):oDrg:isEdit := .f., nil)
    ENDIF

    * zmìna typupohybu znamená znovu vytvoøení vykdph_iw
    *                                          ucetpolw/ucetolw_2
    fin_vykdph_cpy('FAKPRIHDw')

    ::panGroup := Str( IF(finTyp = 6, 1, finTyp), 1)
    ::showGroup()

  case 'CZKRATMENZ' $ drgComboBox:name
   if drgComboBox:ovar:itemChanged()
     PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,drgComboBox:oxbp)
   endif

  endcase
return self


METHOD FIN_fakprihd_IN:comboItemMarked(drgComboBox)
  DO CASE
  CASE('CTYPPOHYBU' $ drgComboBox:name)
    ::comboItemSelected(drgComboBox, .T.)
  CASE('NPROCDAN_'  $ drgComboBox:name)
    DBPutVal('FAKPRIHDw ->nPROCDAN_' +Right(drgComboBox:name,1),drgComboBox:Value)
  ENDCASE
RETURN self

*
** KONTROLY / VÝPOÈTY **********************************************************
method FIN_fakprihd_in:postValidate(drgVar)
  LOCAL  value    := drgVar:get()
  LOCAL  name     := Lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  LOCAL  cFILe    := drgParse(name,'-')
// for ALL
  LOCAL  nFINTYP  := FAKPRIHDw ->nFINTYP, koed, cc
  local  ok       := .t., changed := drgVAR:itemChanged()
  local  subValid := if( nFINTYP = 1 .or. nFINTYP = 6, 'vlde', ;
                     if( nFINTYP = 2                 , 'vldc', ;
                     if( nFINTYP = 3 .or. nFINTYP = 4 .or. nFINTYP = 5, 'vldz', '')))
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  *
  DO CASE
  CASE(name = 'fakprihdw->ncisfak'   )
    IF( changed, ok := fin_range_key('FAKPRIHD',value,,::msg)[1], NIL )

  CASE(name = 'fakprihdw->cvarsym'   )
    if empty(value)
      ::msg:writeMessage('Variabilní symbol je povinný údaj ...',DRG_MSG_WARNING)
      ok := .f.
    endif

  CASE(name = 'fakprihdw->ctyppohybu')
    IF(changed, ::comboItemSelected(drgVar:oDrg), NIL)

  CASE(name = 'fakprihdw->cucet'     )
    ok := ::FIR_firmyuc_sel()

    if ok .and. ::lnewRec
      fordRec({'fakprihd,2'})
      cc := upper(fakprihdw->cvarSym) +strZero(fakprihdw->ncisFirmy,5)
      if fakpri_v->(dbseek(cc,,'FPRIHD2'))
        fin_info_box('Duplicitní variabilní symbol v rámci firmy ...')
      endif
      fordRec()
    endif

  CASE(name = 'fakprihdw->cpsc'      )
    IF( changed, FAKPRIHDw ->cSIDLO := C_PSC ->cMISTO, Nil )

  CASE(name = 'fakprihdw->czkratstat' .or. name = 'fakprihdw->czkratmenz')
    IF changed
      C_MENY ->( DBSeek( Upper( value)))
      IF( IsMethod(self, subValid, CLASS_HIDDEN), self:&subValid(drgVar), NIL)
    ENDIF

  case(field_name $ 'dvystfakdo,dvystfak,dsplatfak')
    if empty(value)
      ::msg:writeMessage('Datum vystavení/uzp/splatnost jsou povinné údaje ...',DRG_MSG_WARNING)
      ok := .f.
    endif

    if(ok .and. name = 'fakprihdw->dvystfak')

      * zmìna rv_dph
      if  year(drgVar:prevValue) <> year(value)
         eval(drgVar:block,drgVar:value)
         fin_vykdph_cpy('fakprihdw')
      endif

       cC := StrZero( Month(value), 2) +'/' +Right( Str( Year(value), 4), 2)
       if fakprihdw->cobdobiDan <> cc
         fin_info_box('Datum (uzp) neodpovídá daòovému období dokladu ...')
       endif
     endif
     *
     **
     if ok .and. name = 'fakprihdw->dvystfakdo' .and. empty(fakprihdw->dsplatFak)
       firmyFi ->(dbSeek( fakprihdw->ncisFirmy,,'FIRMYFI1'))
       if firmyFi->nsplatnDOD <> 0
         fakprihdw->dsplatFak := value +firmyFi->nsplatnDOD
         ::dm:set('fakprihdw->dsplatFak', value +firmyFi->nsplatnDOD)
       endif
     endif

  case(name = 'fakprihdw->ncenzahcel')  //  .and. mp1 = xbeK_RETURN .and. nfinTyp = 2)
    if isNumber(mp1) .and. mp1 = xbeK_RETURN .and. nfinTyp = 2
      ::df:setNextFocus('fakprihdw->ncelzakl_1',,.T.)
    endif

  case(name = 'fakprihdw->czkratmenz')
    if changed
      C_MENY ->( DbSeek(Upper(value)))
      if( IsMethod(self, subValid, CLASS_HIDDEN), self:&subValid(drgVar), NIL)
    endif
  endcase

  if(ok,eval(drgVar:block,drgVar:value),nil)
  if(ok .and. IsMethod(self, subValid, CLASS_HIDDEN), self:&subValid(drgVar), NIL)

  *
  if(field_name $ 'nkurzahmned,nmnozpred') .and. changed
  endif

 * modifikace vykdph_iw
  if( field_name $ 'nosvoddan,nzakldan_1,nsazdan_1,nzakldan_2,nsazdan_2') .and. changed
    ::fin_finance_in:FIN_vykdph_mod('fakprihdw')
  endif

  * modifikace nzustpozao
  ::zustpozao()

  * memo neni editovatelne jen na myšáka
  if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN .and. ok)
    if( name = 'fakprihdw->ddatvratil', ::df:setNextFocus('fakprihdw->cvarsym',,.t.), nil)
  endif
return ok

*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_fakprihd_in:showGroup()
  local  x

  for x := 1 to len(::members) step 1
    if IsMemberVar(::members[x],'groups') .and. .not. Empty(::members[x]:groups)
      if .not. (::panGroup $ ::members[x]:groups)
        ::members[x]:oXbp:hide()
        if( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members[x]:isEdit := .F.)
      else
        ::members[x]:oXbp:show()
        if( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members[x]:isEdit := .T.)
      endif
    endif
  next

  ::FIN_finance_IN:fakprihd_act(::drgDialog)
RETURN self


METHOD FIN_fakprihd_IN:refresh(drgVar)
  LOCAL  nIn, nFs
  LOCAL  oVAR, vars := ::drgDialog:dataManager:vars
//
  LOCAL  dc       := ::drgDialog:dialogCtrl
  LOCAL  dbArea   := ALIAS(dc:dbArea)

* 1- kotrola jen pro datové objekty aktuální DB
* 2- kominace refresh tj. znovunaètení dat
*  - mìl by probìhnout refresh od aktuálního prvku dolù

  nFs := AScan(vars:values, {|X| X[1] = Lower(drgVar:Name) })

  FOR nIn := nFs TO vars:size()
    oVar := vars:getNth(nIn)
    IF !oVar:rOnly .and. (dbArea == drgParse(oVar:name,'-'))
      IF( oVar:itemChanged(), Eval( oVar:block, oVar:value), NIL )
      oVar:refresh()
    ENDIF
  NEXT
RETURN .T.


METHOD FIN_fakprihd_IN:vlde(drgVar)
  LOCAL  name  := Lower(drgVar:name), changed := drgVar:itemChanged()
  LOCAL  value := drgVar:value, initValue := drgVar:initValue, koeZ, koeD
  *
  LOCAL  nCENZAK_cm, nSAZdan, nPROCdan
  LOCAL  cKEYs
  LOCAL  lCMP := .F., lNULL_dph := .F.

  DO CASE
  CASE( name = 'fakprihdw->czkratstat' .or. name = 'fakprihdw->czkratmenz') .and. changed
      ( lCMP  := .T., lNULL_dph := .T. )
      KURZIT ->( AdsSetOrder(2), DBSetScope( SCOPE_BOTH, UPPER(C_MENY ->cZKRATmeny)))
      cKEYs := UPPER(C_MENy ->cZKRATmeny) +DTOS(FAKPRIHDw ->dPORIZfak)
      KURZIT ->( DBSeek( cKEYs, .T.))
      If( KURZIT ->nKURZstred == 0, KURZIT ->( DBGoBottom()), NIL )

      FAKPRIHDw ->nKURZAHmen := KURZIT ->nKURZstred
      FAKPRIHDw ->nMNOZprep  := KURZIT ->nMNOZprep

      cKEYs := UPPER( C_MENy ->cZKRATmeny) +DTOS(FAKPRIHDw ->dVYSTfakdo)
      KURZIT ->( DBSeek( cKEYs, .T.))
      If( KURZIT ->nKURZstred == 0, KURZIT ->( DbGoBottom()), NIL )
      FAKPRIHDw ->nKURZAHmed := KURZIT ->nKURZstred
      FAKPRIHDw ->nMNOZpred  := KURZIT ->nMNOZprep

      KURZIT ->( DbClearScope())

  CASE( name = 'fakprihdw->ncenzahcel' .or. name = 'fakprihdw->nparzahfak' .or. ;
        name = 'fakprihdw->cnazmeny'   .or. name = 'fakprihdw->nkurzahmen' .or. ;
        name = 'fakprihdw->nmnozprep'  .or. name = 'fakprihdw->ncenzakcel' .or. ;
        name = 'fakprihdw->nkurzahmed' .or. name = 'fakprihdw->nmnozpred'       )

    lCMP      := .T.
    lNULL_dph := ( name = 'fakprihdw->cnazmeny'   .or.                                     ;
                   name = 'fakprihdw->nkurzahmen' .or. name = 'fakprihdw->nmnozprep'  .or. ;
                   name = 'fakprihdw->nkurzahmed' .or. name = 'fakprihdw->nmnozpred'       )

   CASE( name = 'fakprihdw->nzakldan_1' .and. changed)
     FAKPRIHDw ->nSAZdan_1 := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_1, ::roundDph )

   CASE( name = 'fakprihdw->nzakldan_2' .and. changed)
     FAKPRIHDw ->nSAZdan_2 := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_2, ::roundDph )

   ENDCASE

   drgVar:save()
*
   If lCMP
     koeZ  := fakprihdw->nkurzahmen/fakprihdw->nmnozprep
     FAKPRIHDw ->nCENZAKCEL := FAKPRIHDw ->nCENzahCEL * koeZ

     IF( name = 'fakprihdw->ncenzahcel')
       IF ::value('fakprihdw->nkurzahmed') <> ::value('fakprihdw->nmnozpred')
         koeD  := fakprihdw->nkurzahmed/fakprihdw->nmnozpred
         FAKPRIHDw ->nOSVodDAN += (value - initValue) * koeD
       ENDIF
     ENDIF
  EndIf

  ::fin_finance_in:refresh(drgVar)
RETURN .T.


METHOD FIN_fakprihd_IN:vldc(drgVar)
  LOCAL  name  := Lower(drgVar:name), changed := drgVar:itemChanged()
  LOCAL  value := drgVar:value, initValue := drgVar:initValue


  if changed
    DO CASE
    CASE( name = 'fakprihdw->ncelzakl_1')
      FAKPRIHDw ->nZAKLDAN_1 := value
      FAKPRIHDw ->nSAZDAN_1  := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_1, ::roundDph )
      FAKPRIHDw ->nOSVODDAN  += (value -initValue) *(-1)

    CASE( name $ 'fakprihdw->ncelclo_1, fakprihdw->ncelspd_1, fakprihdw->nceldal_1')
      FAKPRIHDw ->nZAKLDAN_1 += (value -initValue)
                       value := FAKPRIHDw ->nZAKLDAN_1
      FAKPRIHDw ->nSAZDAN_1  := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_1, ::roundDph )

    CASE( name = 'fakprihdw->ncelzakl_2')
      FAKPRIHDw ->nZAKLDAN_2 := value
      FAKPRIHDw ->nSAZDAN_2  := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_2, ::roundDph )
      FAKPRIHDw ->nOSVODDAN  += (value -initValue) *(-1)

    CASE( name $ 'fakprihdw->ncelclo_2, fakprihdw->ncelspd_2, fakprihdw->nceldal_2')
      FAKPRIHDw ->nZAKLDAN_2 += (value -initValue)
                       value := FAKPRIHDw ->nZAKLDAN_2
      FAKPRIHDw ->nSAZDAN_2  := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_2, ::roundDph )
    ENDCASE

    ::fin_finance_in:FIN_vykdph_mod('fakprihdw')
    ::fin_finance_in:refresh(drgVar)
  endif
RETURN .T.


METHOD FIN_fakprihd_IN:vldz(drgVar)
  LOCAL  name  := Lower(drgVar:name), changed := drgVar:itemChanged()
  LOCAL  value := drgVar:value, initValue := drgVar:initValue, koeZ
  *
  LOCAL  cKEYs, lCMP := .F.

  DO CASE
  CASE( name = 'fakprihdw->czkratstat' .or. name = 'fakprihdw->czkratmenz') .and. changed
    IF FAKPRIHDw ->cZKRATmenz <> C_MENY ->cZKRATmeny
      ( lCMP  := .T., lNULL_dph := .T. )
      KURZIT ->( AdsSetOrder(2), DBSetScope( SCOPE_BOTH, UPPER(C_MENY ->cZKRATmeny)))
      cKEYs := UPPER(C_MENy ->cZKRATmeny) +DTOS(FAKPRIHDw ->dPORIZfak)
      KURZIT ->( DBSeek( cKEYs, .T.))
      If( KURZIT ->nKURZstred == 0, KURZIT ->( DBGoBottom()), NIL )

      FAKPRIHDw ->nKURZAHmen := KURZIT ->nKURZstred
      FAKPRIHDw ->nMNOZprep  := KURZIT ->nMNOZprep

      cKEYs := UPPER( C_MENy ->cZKRATmeny) +DTOS(FAKPRIHDw ->dVYSTfakdo)
      KURZIT ->( DBSeek( cKEYs, .T.))
      If( KURZIT ->nKURZstred == 0, KURZIT ->( DbGoBottom()), NIL )
      FAKPRIHDw ->nKURZAHmed := KURZIT ->nKURZstred
      FAKPRIHDw ->nMNOZpred  := KURZIT ->nMNOZprep

      KURZIT ->( DbClearScope())
    ENDIF

  CASE( name = 'fakprihdw->ncenzahcel' .or. name = 'fakprihdw->nparzahfak' .or. ;
        name = 'fakprihdw->nkurzahmen' .or. name = 'fakprihdw->nmnozprep'  .or. ;
        name = 'fakprihdw->cnazmeny'   .or. name = 'fakprihdw->nkurzahmen' .or. ;
        name = 'fakprihdw->nmnozprep'  .or. name = 'fakprihdw->ncenzakcel' .or. ;
        name = 'fakprihdw->nkurzahmed' .or. name = 'fakprihdw->nmnozpred'       )

     lCMP := changed
  ENDCASE

  drgvar:save()

  if lCMP
    koeZ  := fakprihdw->nkurzahmen/fakprihdw->nmnozprep
    FAKPRIHDw ->nCENZAKCEL := FAKPRIHDw ->nCENzahCEL * koeZ
  endif
  FAKPRIHDw ->nOSVODDAN := FAKPRIHDw ->nCENZAKCEL

  ::fin_finance_in:refresh(drgVar)
RETURN .T.


method FIN_fakprihd_in:zustpozao()
  local  osvoddan, fintyp := fakprihdw->nfintyp, zustpozao := 0
  *
  local  koeZ  := ::value('nkurzahmen')/::value('nmnozprep')

  do case
  case( fintyp = 6 )                             // EU faktura
    if ::value('nkurzahmen') <> ::value('nkurzahmed')
      zustpozao := 0
    else
      zustpozao := fakprihdw->ncenzakcel   - ;
                   ( fakprihdw->nosvoddan  + ;
                     fakprihdw->nzakldan_1 + ;
                     fakprihdw->nzakldan_2 - fakprihdw->nparzahfak *koeZ)
    endif

  case( fintyp = 2 )                             // CELNÍ faktura
    * u celní poøizujeme ncenZahCel musíme tuto hodnotu šoupnout do ncenZakCel *
    fakprihdw->ncenZakCel := fakprihdw->ncenZahCel
    zustpozao := fakprihdw->ncenzakcel                           - ;
                 ((fakprihdw->nzakldan_1 +fakprihdw->nzakldan_2) - ;
                  (fakprihdw->ncelzakl_1 +fakprihdw->ncelzakl_2  + ;
                   fakprihdw->nceldal_1  +fakprihdw->nceldal_2 )   )

  case( fintyp = 3 .or. fintyp = 5)             // zálohová bìžná/zahrnièní
*   nekontroluje

  otherwise
    zustpozao := fakprihdw->ncenzakcel                                              - ;
                 (fakprihdw->nosvoddan +fakprihdw->nzakldan_1 +fakprihdw->nsazdan_1 + ;
                                        fakprihdw->nzakldan_2 +fakprihdw->nsazdan_2 - ;
                                        fakprihdw->nparzalfak                         )
  endcase

  fakprihdw->nzustpozao := zustpozao
  ::dm:set('fakprihdw->nzustpozao',zustpozao)
return zustpozao