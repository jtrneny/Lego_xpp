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
** CLASS for UCT_uctdokhd_IN ***************************************************
CLASS UCT_uctdokhd_IN FROM drgUsrClass, FIN_finance_IN
exported:
  var     lNEWrec, cmb_typPoh
  method  init, drgDialogStart, drgDialogEnd
  method  comboItemSelected, postValidate, postAppend, postLastField, postSave
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
    local  sumMd  := 0, rozMd  // (::hd_file)->nsazDan_1 +(::hd_file)->nsazDan_2, rozMd
    local  sumCol := ::brow:getColumn(column)

    uctdoki_w->(dbgotop(),dbeval({ || sumMd += uctdoki_w->nkcmd }))

    rozMd   := uctdokhdw->ncenzakcel -Round(sumMd,2)
    ::rozMd := rozMd

    sumCol:Footing:hide()
    sumCol:Footing:setCell(1,str(rozMd))
    sumCol:Footing:show()
  return rozMd
ENDCLASS


method UCT_uctdokhd_IN:init(parent)
  local file_name

  ::drgUsrClass:init(parent)
  *
  (::hd_file     := 'uctdokhdw', ::it_file := 'uctdokitw')
   ::lNEWrec     := .not. (parent:cargo = drgEVENT_EDIT)
   ::lok_append2 := .f.
   ::roundDph    := SysConfig('Finance:nRoundDph')
  *
  drgDBMS:open('C_MENY'  )
  drgDBMS:open('C_DPH'   )
  drgDBMS:open('RANGE_HD')
  drgDBMS:open('RANGE_IT')
  drgDBMS:open('c_uctosn')

  uct_uctdokhd_cpy(self)

  file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
               (::it_file) ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file)->(OrdSetFocus(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'uctdoki_w', .t., .t.) ; uctdoki_w  ->(OrdSetFocus(1))
return self


method UCT_uctdokhd_IN:drgDialogStart(drgDialog)
  local x, ocolumn, odrg

  ::FIN_finance_in:init(self,'ucd','UCTDOKITw->cUCETDAL','_úèetního dokladu_',.t.)

  ::aEdits   := {}
  ::panGroup := '1'
  ::members  := drgDialog:oForm:aMembers

  for x := 1 to LEN(::members) step 1
    if ::members[x]:ClassName() = 'drgStatic' .and. .not.Empty(::members[x]:groups)
      AAdd(::aEdits, { ::members[x]:groups, x })
    endif
  next

  drgDialog:dataManager:refresh()

  * zakážeme daòové odbdobí *
  odrg := ::dm:get(::hd_file +'->cobdobidan',.f.):odrg
  (odrg:isEdit := .f., odrg:oxbp:disable())

*  ::showGroup()
  *
  ::nazuc_hd   := ::dm:get(::hd_file +'->cucet_uct' , .F.)
  ::nazuc_it   := ::dm:get(::it_file +'->cucetdal'  , .F.)
  ::cmb_typPoh := ::dm:has(::hd_file +'->ctyppohybu'):odrg
  *
  ::sumColumn(5)
  *
  *
  if ::lnewRec
    if .not. ::lok_append2
      ::df:setNextFocus('uctdokhdw->ctyppohybu',,.t.)
    else
      ( ::cmb_typPoh:isEdit := .f., ::cmb_typPoh:oxbp:disable() )
    endif
  endif
return self


method UCT_uctdokhd_IN:comboItemSelected(mp1,mp2,o)
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
  endcase
return .t.


method UCT_uctdokhd_IN:postAppend()
  if .not. (::it_file) ->(eof())
    ::dm:set(::it_file +'->cucetDal', (::it_file)->cucetDal)
    ::dm:set(::it_file +'->ctext'   , (::it_file)->ctext   )
    ::dm:set('m->cnaz_uct_it'       , c_uctosn->cnaz_uct   )
  endif
return .t.


METHOD UCT_uctdokhd_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  if changed
    do case
    case( name = 'uctdokhdw->ndoklad')
      ok := fin_range_key('UCTDOKHD',value,,::msg)[1]

    case(name = 'uctdokhdw->nzakldan_1' .and. changed)
      uctdokhdw->nsazdan_1 := mh_RoundNumb( (value/100) * uctdokhdw->nprocdan_1, ::roundDph )
      ::dm:set('uctdokhdw->nsazdan_1',uctdokhdw->nsazdan_1)

    case(name = 'uctdokhdw->nzakldan_2' .and. changed)
      uctdokhdw->nsazdan_2 := mh_RoundNumb( (value/100) * uctdokhdw->nprocdan_2, ::roundDph )
      ::dm:set('uctdokhdw->nsazdan_2',uctdokhdw->nsazdan_2)

    case(name = 'uctdokhdw->ctextdok')
      if (::it_file)->(eof()) .or. ::state = 2
        ::dm:set('uctdokitw->ctext',value)
      endif

    endcase
  endif

*
** pøeskok MEMA
  if(name = ::hd_file +'->cnazpol6')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      ::df:setNextFocus('uctdokitw->cucetDal',,.T.)
    endif
  endif


  if(name = ::it_file +'->cnazpol6')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      ::postLastField()
    endif
  endif

  if('uctdokhdw' $ name .and. ok, drgVAR:save(),nil)

  * modifikace vykdph_iw
  if( field_name $ 'nosvoddan,nzakldan_1,nsazdan_1,nzakldan_2,nsazdan_2') .and. changed
    ::fin_finance_in:FIN_vykdph_mod('uctdokhdw')
  endif
RETURN ok

/*
method UCT_uctdokhd_IN:postAppend()
  local value := ::dm:get('uctdokhdw->ctextdok')

  ::dm:set('uctdokitw->ctext',value)
return
*/


METHOD UCT_uctdokhd_IN:postLastField(drgVar)
  local  isChanged := ::dm:changed()

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
// JS    if(::state = 2, mh_copyfld(::hd_file, ::it_file, , .f.), nil)

    if(::state = 2, ::copyfldto_w(::hd_file,::it_file), nil )

    (::it_file)->(flock())
    ::dm:save()

    if ::state = 2
      uctdokitw ->cUCETMD   := UCTDOKHDw ->cUCET_UCT
      uctdokitw ->cTYP_R    := UCTDOKHDw ->cTYPOBRATU
      uctdokitw ->nORDITEM  := ::ordItem() +1
      uctdokitw ->nORDUCTO  := 1

      uct_uctdokhd_typ(::cmb_typPoh)
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


method UCT_uctdokhd_IN:postSave()
  local  ok := .t., file_name

  if ::rozMd <> 0
    fin_info_box('Nelze uložit nevyrovnaný doklad !')
    ok := .f.
  else
    ok := uct_uctdokhd_wrt(self)
  endif

  if(ok .and. ::new_Dok .and. ::lok_append2, ::new_Dok := .f., nil )

  if(ok .and. ::new_dok)

    (::it_file)->(DbCloseArea())
    uctdoki_w ->(DbCloseArea())

    uct_uctdokhd_cpy(self)

    file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
                 (::it_file) ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file)->(OrdSetFocus(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'uctdoki_w', .t., .t.) ; uctdoki_w  ->(OrdSetFocus(1))

    ::df:setNextFocus('uctdokhdw->ctypdoklad',,.t.)
    ::brow:refreshAll()
    ::dm:refresh()
    ::sumColumn(5)
  elseif(ok .and. .not. ::new_dok)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return ok


method UCT_uctdokhd_IN:drgDialogEnd(drgDialog)
  (::it_file)->(DbCloseArea())
  uctdoki_w ->(DbCloseArea())
return


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD UCT_uctdokhd_IN:showGroup()
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