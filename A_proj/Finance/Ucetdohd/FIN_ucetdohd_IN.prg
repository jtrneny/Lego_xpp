#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"
#include "dmlb.ch"
//
#include "..\FINANCE\FIN_finance.ch"


*
** CLASS for FIN_ucetdohd_IN ***************************************************
CLASS FIN_ucetdohd_IN FROM drgUsrClass, FIN_finance_IN
exported:
  var     lNEWrec, cmb_typPoh
  method  init, drgDialogStart, drgDialogEnd
  method  comboItemSelected, postAppend, postValidate, overPostLastField, postLastField, postSave
  method  firmyico_sel
  *
  var     lok_append2


  inline access assign method typObratu() var typObratu
    local  value, values, nin, pa

    if isobject(::cmb_typPoh)
      value  := ::cmb_typPoh:Value
      values := ::cmb_typPoh:values
      nin    := ascan(values,{|x| x[1] = value })
       pa    := listasarray(values[nin,4])
      return pa[1]
    else
      return ''
    endif
    return

  *
  inline access assign method cnaz_uct_hd()  var cnaz_uct_hd
    c_uctosn->( DbSeek(if(isnull(::nazuc_hd),'',::nazuc_hd:value)))
    return c_uctosn->cnaz_uct
  *
  inline access assign method cnaz_uct_it()  var cnaz_uct_it
    c_uctosn->( DbSeek(if(isnull(::nazuc_it),'',::nazuc_it:value)))
    return c_uctosn->cnaz_uct
  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    return ::handleEvent(nEvent, mp1, mp2, oXbp)

hidden:
  var     roundDph, aEdits, panGroup, members, hd_file, it_file, nazuc_hd, nazuc_it
  var     rozMd
  method  showGroup

  * suma
  inline method sumColumn(column)
    local  sumMd  := (::hd_file)->nsazDan_1 +(::hd_file)->nsazDan_2, rozMd
    local  sumCol := ::brow:getColumn(column)
    *
    * pøenesená daòová povinnost se nesmí zahrnou do souètu
    sumMd := 0
    vykDph_iW->( dbgoTop())
    do while .not. vykDph_iW->( eof())
      sumMd += if( vykDph_iw->lpreDANpov, 0, vykDph_iW->nsazba_Dph )

      vykDph_iW->( dbskip())
    enddo

    ucetdoi_w->(dbgotop(),dbeval({ || sumMd += ucetdoi_w->nkcmd }))

    rozMd   := ucetdohdw->ncenzakcel -Round(sumMd,2)
    ::rozMd := rozMd

    sumCol:Footing:hide()
    sumCol:Footing:setCell(1,str(rozMd))
    sumCol:Footing:show()
  return rozMd
ENDCLASS


method FIN_ucetdohd_IN:init(parent)
  local file_name

  ::drgUsrClass:init(parent)
  *
  (::hd_file     := 'ucetdohdw', ::it_file := 'ucetdoitw')
   ::lNEWrec     := .not. (parent:cargo = drgEVENT_EDIT)
   ::lok_append2 := .f.
   ::roundDph    := SysConfig('Finance:nRoundDph')
  *
  drgDBMS:open('C_MENY'  )
  drgDBMS:open('C_DPH'   )
  drgDBMS:open('c_uctosn')
  drgDBMS:open('FIRMY'   )
  drgDBMS:open('RANGE_HD')
  drgDBMS:open('RANGE_IT')

  FIN_ucetdohd_cpy(self)

  file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
               (::it_file) ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'ucetdoi_w', .t., .t.) ; ucetdoi_w  ->(AdsSetOrder(1))
return self


method FIN_ucetdohd_IN:drgDialogStart(drgDialog)
  local x, ocolumn

  ::FIN_finance_in:init(self,'ucd','UCETDOITw->cUCETDAL','_úèetního dokladu_',.t.)

  ::aEdits   := {}
  ::panGroup := '1'
  ::members  := drgDialog:oForm:aMembers

  for x := 1 to LEN(::members) step 1
    if ::members[x]:ClassName() = 'drgStatic' .and. .not.Empty(::members[x]:groups)
      AAdd(::aEdits, { ::members[x]:groups, x })
    endif
  next

  drgDialog:dataManager:refresh()
*  ::showGroup()
  *
  ::nazuc_hd   := ::dm:get(::hd_file +'->cucet_uct' , .F.)
  ::nazuc_it   := ::dm:get(::it_file +'->cucetdal'  , .F.)
  ::cmb_typPoh := ::dm:has(::hd_file +'->ctyppohybu'):odrg
  *
  ::sumColumn(5)
  *
  if ::lnewRec
    if .not. ::lok_append2
      ::df:setNextFocus('ucetdohdw->ctyppohybu',,.t.)
    else
      ( ::cmb_typPoh:isEdit := .f., ::cmb_typPoh:oxbp:disable() )
    endif
  endif
return self


method FIN_ucetdohd_IN:comboItemSelected(mp1,mp2,o)
  local  name  := lower(mp1:name), ovar := ::dm:get('m->typObratu', .F.)
  local  value := mp1:Value, values := mp1:values
  local  nin,pa

  do case
  case(name = ::hd_file +'->cobdobi'   )
    ::cobdobi(mp1)

  case(name = ::hd_file +'->ctyppohybu')
    nin := ascan(values,{|x| x[1] = value })
     pa := listasarray(values[nin,4])
    ovar:set(pa[1])

    ucetdohdw->ntypobratu := val(pa[2])
    if ucetdohdw->ntypobratu = 1           // MD
      if empty(ucetdohdw->cdanDoklad)
        ucetdohdw->cdanDoklad := alltrim(str( ucetdohdw->ndoklad))
      endif
    endif

    ::dm:has(::hd_file +'->cdanDoklad'):set(ucetdohdw->cdanDoklad)
  endcase
return .t.


method FIN_ucetdohd_in:postAppend()
  if .not. (::it_file) ->(eof())
    ::dm:set(::it_file +'->cucetDal', (::it_file)->cucetDal)
    ::dm:set(::it_file +'->ctext'   , (::it_file)->ctext   )
    ::dm:set('m->cnaz_uct_it'       , c_uctosn->cnaz_uct   )
  endif
return .t.


METHOD FIN_ucetdohd_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  local  n_typvykDph := sysconfig('FINANCE:nTypVykDPH')
  local  cQ_beg, cQ_end, nQ_beg, nQ_end

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  if changed
    do case
    case( name = 'ucetdohdw->ndoklad')
      ok := fin_range_key('UCETDOHD:' +ucetdohdw->_denik,value,,::msg)[1]

      if ok .and. ucetdohdw->ntypobratu = 1           // MD
        if changed .or. empty(ucetdohdw->cdanDoklad)
          ucetdohdw->cdanDoklad := alltrim(str( value ))
          ::dm:has(::hd_file +'->cdanDoklad'):set(ucetdohdw->cdanDoklad)
        endif
      endif

    case( name = 'ucetdohdw->dporizdok' .or. name = 'ucetdohdw->dvystdok')
      if empty(value)
        ::msg:writeMessage('Datum vystavení/uzp jsou povinné údaje ...',DRG_MSG_WARNING)
        ok := .f.
      endif

      if(ok .and. name = 'ucetdohdw->dvystdok')
       * zmìna rv_dph
       if .not. vykdph_iw->(dbseek( FIN_c_vykdph_ndat_od(value),, 'VYKDPH_6' ))
//       if  year(drgVar:prevValue) <> year(value)
         eval(drgVar:block,drgVar:value)
         fin_vykdph_cpy('ucetdohdw')
       endif

       cC := StrZero( Month(value), 2) +'/' +Right( Str( Year(value), 4), 2)

       * 1 - mìsíèní plátce DPH
       do case
       case n_typvykDph = 1
         if ucetdohdw->cobdobiDan <> cC
           fin_info_box('Datum (uzp) neodpovídá daòovému období dokladu ...')
         endif

       * 3 - ètvrtletní plátce DPH
       case n_typvykDph= 3
         nQ_end := val( left( ucetdohdw->cobdobiDan, 2)) *n_typvykDph
         nQ_beg := nQ_end -2

         cQ_beg := strZero(nQ_beg,2) +'/' +right(ucetdohdw->cobdobiDan, 2)
         cQ_end := strZero(nQ_end,2) +'/' +right(ucetdohdw->cobdobiDan, 2)

         if .not. (cQ_beg <= cc .and. cQ_end >= cc)
           fin_info_box('Datum (uzp) neodpovídá daòovému období dokladu ...')
         endif
       endcase
     endif

    case(name = 'ucetdohdw->cdic' .and. changed)
       ok := ::firmyico_sel()

    case(name = 'ucetdohdw->nzakldan_1' .and. changed)
      ucetdohdw->nsazdan_1 := mh_RoundNumb( (value/100) * ucetdohdw->nprocdan_1, ::roundDph )
      ::dm:set('ucetdohdw->nsazdan_1',ucetdohdw->nsazdan_1)

    case(name = 'ucetdohdw->nzakldan_2' .and. changed)
      ucetdohdw->nsazdan_2 := mh_RoundNumb( (value/100) * ucetdohdw->nprocdan_2, ::roundDph )
      ::dm:set('ucetdohdw->nsazdan_2',ucetdohdw->nsazdan_2)

    case(name = 'ucetdohdw->nzakldan_3' .and. changed)
      ucetdohdw->nsazdan_3 := mh_RoundNumb( (value/100) * ucetdohdw->nprocdan_3, ::roundDph )
      ::dm:set('ucetdohdw->nsazdan_3',ucetdohdw->nsazdan_3)

    endcase
  else
    do case
    case(name = 'ucetdoitw->csymbol')
      cc := ::dm:get('ucetdoitw->cucetDal')
      c_uctosn->(dbSeek(cc,,'UCTOSN1'))
      if c_uctosn->lsaldoUct .and. empty(value)
        fin_info_box('Variabilní symbol pro ùèet >' +cc +'<' +CRLF + 'je POVINNÝ údaj !!!')
        ok := .f.
      endif
    endcase

  endif

  if(name = ::it_file +'->cnazpol6')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      if(::overPostLastField(), ::postLastField(), nil)
    endif
  endif

  if('ucetdohdw' $ name .and. ok, drgVAR:save(),nil)

  * modifikace vykdph_iw
  if( field_name $ 'nosvoddan,nzakldan_1,nsazdan_1,nzakldan_2,nsazdan_2,nzakldan_3,nsazdan_3') .and. changed
    ::fin_finance_in:FIN_vykdph_mod('ucetdohdw')
  endif
RETURN ok


method FIN_ucetdohd_in:firmyico_sel(drgDialog)
  local oDialog, nExit := drgEVENT_QUIT, copy := .F.
  *
  local drgVar := ::dm:has('ucetDohdW->cdic')
  local value  := upper(drgVar:get())
  local lOk    := firmy ->(dbseek(value,,'FIRMY8')) .and. .not. empty(value)

  IF IsObject(drgDialog) .or. .not. lOk
    DRGDIALOG FORM 'FIR_FIRMYICO_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                      EXITSTATE nExit
  ENDIF

  if (lOk .and. drgVar:itemChanged())
    copy := .T.
  elseif nexit != drgEVENT_QUIT
    copy := .T.
  endif

  if copy
    mh_copyfld('firmy','ucetDohdW',,.f.)

    drgVar:set(firmy->cdic)
    drgvar:value = drgvar:initValue := drgvar:prevValue := firmy->cdic
  endif
return (nExit != drgEVENT_QUIT) .or. lOk


method FIN_ucetdohd_in:overPostLastField()
  local  o_nazPol1 := ::dm:has(::it_file +'->cnazPol1')
  local  ucet      := ::dm:get(::it_file +'->cucetDal'   )
  local  ok

  ok := ::c_naklst_vld(o_nazPol1,ucet)
return ok


METHOD FIN_ucetdohd_IN:postLastField(drgVar)
  local  isChanged := ::dm:changed()

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
// JS    if(::state = 2, mh_copyfld(::hd_file,::it_file,, .f., .f.), nil)
    if(::state = 2, ::copyfldto_w(::hd_file,::it_file), nil )

    (::it_file)->(flock())
    ::dm:save()

    if ::state = 2
      UCETDOITw ->cUCETMD   := UCETDOHDw ->cUCET_UCT
      UCETDOITw ->cTYP_R    := UCETDOHDw ->cTYPOBRATU
      UcetDOITw ->nORDITEM  := ::ordItem() +1
      UcetDOITw ->nORDUCTO  := 1

      fin_ucetdohd_typ(::cmb_typPoh)
      ::brow:gobottom()
      ::brow:refreshAll()
    else
      ::brow:refreshCurrent()
    endif
  endif

  ::setfocus(::state)
  ::sumColumn(5)
  ::dm:refresh()
RETURN .T.


method FIN_ucetdohd_IN:postSave()
  local  ok := .t., file_name

  if ::rozMd <> 0
    fin_info_box('Nelze uložit nevyrovnaný doklad !')
    ok := .f.
  else
    ok := FIN_ucetdohd_wrt(self)
  endif

  if(ok .and. ::new_Dok .and. ::lok_append2, ::new_Dok := .f., nil )

  if(ok .and. ::new_dok)

    (::it_file)->(DbCloseArea())
    ucetdoi_w ->(DbCloseArea())

    FIN_ucetdohd_cpy(self)

    file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
                 (::it_file) ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'ucetdoi_w', .t., .t.) ; ucetdoi_w  ->(AdsSetOrder(1))

    ::df:setNextFocus('ucetdohdw->ctypdoklad',,.t.)
    ::brow:refreshAll()
    ::dm:refresh()
    ::sumColumn(5)
  elseif(ok .and. .not. ::new_dok)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return ok


method FIN_ucetdohd_IN:drgDialogEnd(drgDialog)
  (::it_file)->(DbCloseArea())
  ucetdoi_w ->(DbCloseArea())
return


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_ucetdohd_IN:showGroup()
  LOCAL  nIn
  LOCAL  lOk
  LOCAL  pA  := {'banvyphdw->nprijem' , 'banvyphdw->nvydej' , 'banvypitw->ncenzakcel', ;
                 'banvyphdw->nprijemz', 'banvyphdw->nvydejz', 'banvypitw->ncenzahcel'  }
  LOCAL  drgVar, dm := ::dataManager

  FOR nIn := 1 TO LEN(pA)
    drgVar := dm:has(pA[nIn]):oDrg

    lOk    := IF(C_BANKUC ->lIsTUZ_UC, IF( nIn <= 3, .T., .F.), IF(nIn > 3, .T., .F.))

    IF( drgVar:className() = 'drgGet', drgVar:isEdit := lOk, NIL )
    IF( lOk, drgVar:oXbp:show(), drgVar:oXbp:hide() )
  NEXT
RETURN self