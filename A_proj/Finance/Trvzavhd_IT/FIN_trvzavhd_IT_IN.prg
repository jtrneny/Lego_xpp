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
** CLASS for FIN__IT_IN ************************************************
****  , FIN_finance_in, FIN_NAK_fakturovat_z_vld, FIN_NAK_fakdol
CLASS FIN_trvzavhd_IT_IN FROM drgUsrClass, FIN_finance_in, FIN_NAK_fakturovat_z_vld, FIN_NAK_fakdol
exported:

  method  init, drgDialogStart
  method  comboItemSelected, comboItemMarked

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      return .f.

    case ( nEvent = drgEVENT_APPEND .or. ;
           nEvent = drgEVENT_EDIT   .or. ;
           nEvent = drgEVENT_DELETE .or. ;
           nEvent = drgEVENT_SAVE        )
      return .t.

    endcase
  return .f.

hidden:
  VAR     aEdits, panGroup, members, butPar, roundDph
  var     members_fak, members_pen, members_inf
  var     members_bc
  var     members_fak_it

  method  showGroup, refresh


ENDCLASS


method FIN_trvzavhd_it_in:init(parent)
  ::drgUsrClass:init(parent)


  drgDBMS:open('C_DPH')
  drgDBMS:open('FAKPRIHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('TRVZAVHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('TRVZAVITw',.T.,.T.,drgINI:dir_USERfitm); ZAP


return self


method FIN_trvzavhd_it_in:drgDialogStart(drgDialog)


return self


method FIN_trvzavhd_it_in:comboItemSelected(drgComboBox,isMarked)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nIn, finTyp

  do case
  case right(drgComboBox:name,7) = 'COBDOBI'
    ::cobdobi(drgComboBox)

  case 'CZKRTYPZAV' $ drgComboBox:name
    nIn := AScan(values, {|X| X[1] = value })

*    finTyp := SET_typ(values[nIn,4])

    IF .not. IsNull(isMarked,.F.)
*      TRVZAVHDw->cTYPDOKLAD := values[nIn,3]
      TRVZAVHDw->cZKRTYPZAV := values[nIn,1]
*      TRVZAVHDw->nFINTYP    := finTyp
*      TRVZAVHDw->ciszal_fak := if(finTyp = 3 .or. finTyp = 5, '1', '0')

      * celní
*      if(finTyp = 2, ::dm:has('fakprihdw->nparzahfak'):oDrg:isEdit := .f., nil)
    ENDIF

    * zmìna typupohybu znamená znovu vytvoøení vykdph_iw
    *                                          ucetpolw/ucetolw_2
*    fin_vykdph_cpy('FAKPRIHDw')

*    ::panGroup := Str( IF(finTyp = 6, 1, finTyp), 1)
*    ::showGroup()

  case 'CTYPPOHYBU' $ drgComboBox:name
    nIn := AScan(values, {|X| X[1] = value })

    finTyp := SET_typ(values[nIn,4])

    IF .not. IsNull(isMarked,.F.)
      TRVZAVHDw->cTYPDOKLAD := values[nIn,3]
      TRVZAVHDw->cTYPPOHYBU := values[nIn,1]
      TRVZAVHDw->nFINTYP    := finTyp
      TRVZAVHDw->ciszal_fak := if(finTyp = 3 .or. finTyp = 5, '1', '0')

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

     * blokujeme ncenZakCel a nsazDan pro tuzemskou fakturu
     ::isVisible_cenZakCel_sazDan(value)
     PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,drgComboBox:oxbp)
   endif

  endcase
return self


METHOD FIN_trvzavhd_it_in:comboItemMarked(drgComboBox)
  DO CASE
  CASE('CTYPPOHYBU' $ drgComboBox:name)
    ::comboItemSelected(drgComboBox, .T.)
  CASE('NPROCDAN_'  $ drgComboBox:name)
    DBPutVal('TRVZAVHDw ->nPROCDAN_' +Right(drgComboBox:name,1),drgComboBox:Value)
  ENDCASE
RETURN self


** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_trvzavhd_it_in:showGroup()
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


METHOD FIN_trvzavhd_it_in:refresh(drgVar)
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

