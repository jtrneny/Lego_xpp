#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
*
**
#include "..\FINANCE\FIN_finance.ch"


#define  m_files   { 'c_uctosn'                                   , ;
                     'dodlstit', 'vyrzak'  , 'vyrzakit', 'cenzboz', ;
                     'fakprihd', 'fakvyshd'                         }


*
** CLASS for FIN_fakvnphd_IN ***************************************************
CLASS FIN_fakvnphd_IN FROM drgUsrClass, FIN_finance_IN, FIN_fakturovat_z_vld, FIN_pro_fakdol
  exported:
  var     rozPo, typ_dokl, is_ban, aval_krp
  var     in_file, ain_file, varSym
  var     lok_append2

  METHOD  init, preValidate, postValidate, postLastField, postValidateForm
  METHOD  overPostLastField, postSave, postAppend, postDelete
  METHOD  drgDialogInit, drgDialogStart, drgDialogEnd
  *
  method  osb_osoby_sel

  *
  inline access assign method cnaz_uct_hd()  var cnaz_uct_hd
    c_uctosn->( DbSeek(if(isnull(::nazuc_hd),'',::nazuc_hd:value)))
    return c_uctosn->cnaz_uct
  *
  inline access assign method cnaz_uct_it()  var cnaz_uct_it
    c_uctosn->( DbSeek(if(isnull(::nazuc_it),'',::nazuc_it:value)))
    return c_uctosn->cnaz_uct

  inline access assign method dod_cenzakcel var dod_cenzakcel
    return if(fakvnpitw->nsubcount = 0, fakvnpitw->ncenzakcel, 0)

  inline access assign method odb_cenzakcel var odb_cenzakcel
    return if(fakvnpitw->nsubcount = 0, 0, fakvnpitw->ncenzakcel)

  inline access assign method in_file(m_file)
    local pos

    if ::state = 2
      if pcount() == 1
        ::in_file := m_file
      else
        ::in_file := if( Empty(::varSym:get()), '', ::in_file)
      endif
    else
      if(pos := AScan(::ain_file,{|x| x[6] = (::it_file)->cdenik_par})) <> 0
        ::in_file := ::ain_file[pos,1]
      endif
    endif
  return ::in_file

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  olastDrg := ::df:olastDrg
    local  rowPos, lrefresh := .f., sid := isNull( fakvnpitW->sid, 0 )

    do case
    case (nEvent = xbeBRW_ItemMarked)
      rowPos   := if( isArray(mp1), mp1[1], mp1 )
      lrefresh := ( ::state <> 0 )

      ::msg:WriteMessage(,0)
      ::state := 0

      if sid <> 0 .and. rowPos = ::brow:rowPos
        * hd

        * it
        (::cisloDl:odrg:isEdit   := .F., ::cisloDl:odrg:oxbp:disable()  )
        (::cisZakazi:odrg:isEdit := .F., ::cisZakazi:odrg:oxbp:disable())
        (::sklPol:odrg:isEdit    := .F., ::sklPol:odrg:oxbp:disable()   )

        if(ismethod(self, 'postItemMarked'), ::postItemMarked(), Nil)
        ::restColor()
      endif

      return .f.

    otherwise
      return ::fakdol_handleEvent(nevent,mp1,mp2,oxbp)
    endcase
  return .F.

  inline method showGroup()
    return .t.

 HIDDEN:
  var     members_inf

  VAR     zaklMena, paGroups, title, cisFak
  var     cisloDl, cisZakazi, sklPol, nazuc_hd, nazuc_it


  inline method sumColumn()
    local  recNo         := fakvnpitW->( recNo())
    local  dod_cenZakCel := 0
    local  sumCol

    fakvnpitW->( dbeval( { || dod_cenZakCel += fakvnpitW->ncenzakcel } ), ;
                 dbgoTo( recNo )                                      )

    fakVnphdW->ncenZakCel := dod_cenZakCel
    ::dm:set('fakVnphdW->ncenZakCel', dod_cenZakCel)

    sumCol         := ::brow:cargo:getColumn_byName( 'M->dod_cenZakCel' )

    sumCol:Footing:setCell(1, dod_cenZakCel )
    sumCol:footing:invalidateRect()
    sumCol:Footing:show()
  return self

ENDCLASS


METHOD FIN_fakvnphd_IN:init(parent)

  ::drgUsrClass:init(parent)
  *
  (::hd_file := 'fakvnphdw', ::it_file := 'fakvnpitw')
  ::lok_append2  := .f.

  * vstupní soubory pro kontrolu na csymol
  ::ain_file := {{'fakprihd', 0, 0, 1,  9, SysConfig('FINANCE:cDENIKFAPR')}, ;
                 {'fakvyshd', 0, 0, 2, 10, SysConfig('FINANCE:cDENIKFAVY')}  }

  *
  ::rozPo    := 0
  ::typ_dokl := 'vnp_f'
  ::is_ban   := .f.
  ::lNEWrec  := .not. (parent:cargo = drgEVENT_EDIT)

  * základní soubory
  ::openfiles(m_files)

  * pøednastavení z CFG
  ::lVSYMBOL := sysconfig('finance:lvsymbol')
  ::zaklMena := SysConfig('Finance:cZaklMena')

  FIN_fakvnphd_cpy(self)

  file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
               (::it_file) ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file) ->(OrdSetFocus(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'fakvnp_iw', .t., .t.) ; fakvnp_iw ->(OrdSetFocus(1))
RETURN self


METHOD FIN_fakvnphd_IN:drgDialogInit(drgDialog)
RETURN


METHOD FIN_fakvnphd_IN:drgDialogStart(drgDialog)
  local que_del := ' vnitro_Podnikové faktury'
  *
  local members  := drgDialog:oForm:aMembers, aedits := {}

  FOR x := 1 TO LEN(members)
    IF members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
        members[x]:oXbp:setFontCompoundName(ListAsArray(members[x]:groups)[2])
      endif
    ENDIF
  NEXT

  ::members_inf := {}

  * likvidace bankovní výpisy/vzájemné zápoèty/ úhrady pokladnou/ vnitro_podnikové fakttury nemají RVDPH *
  ::FIN_finance_in:init(drgDialog,::typ_dokl,::it_file +'->ncislodl',que_del)
  ::fin_pro_fakdol:init(drgDialog:udcp)

  *
  ::cmb_typPoh := ::dm:has(::hd_file +'->ctyppohybu'):odrg

  ::nazuc_hd  := ::dm:get(::hd_file +'->cucet_uct' , .F.)
  ::cisloDl   := ::dm:get(::it_file +'->ncislodl'  , .F.)
  ::cisZakazi := ::dm:get(::it_file +'->cciszakazi', .F.)
  ::sklPol    := ::dm:get(::it_file +'->csklpol'   , .F.)
  ::nazuc_it  := ::dm:get(::it_file +'->cucetdal'  , .F.)

  ::comboItemSelected(::cmb_typPoh,0)
  ::sumColumn()

  if ::lnewRec
    ::df:setNextFocus( 'fakvnphdW->ctyppohybu',,.t.)
  endif
RETURN self


METHOD FIN_fakvnphd_IN:drgDialogEnd(drgDialog)

  fakVnphdW->(dbclosearea())
  fakvnpitw->(dbclosearea())
  fakVnp_iW->(dbclosearea())

  ::drgUsrClass:destroy()
RETURN


method FIN_fakvnphd_IN:preValidate(drgVar)
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-')
  local  ok     := .t.

  do case
  * konroly na hlavièce
  case(file = ::hd_file )

  * zpracování na položce
  case(file = ::it_file )
    if( ::lnewRec, ok := ::postValidateForm(::hd_file), nil )
  endcase
return ok


METHOD FIN_fakvnphd_IN:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-')
  LOCAL  ok     := .T., changed := drgVAR:changed(), subtxt
  local  it_sel := 'fakvnpitw->ncislodl,fakvnpitw->cciszakazi,fakvnpitw->csklpol'
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case(file = ::hd_file )

    * konroly na hlavièce
    do case
    case(name = ::hd_file +'->ncisfak')
       m_file := upper(left(::hd_file, len(::hd_file)-1))
       (aX := fin_range_key(m_file,value,,::msg), ok := aX[1])
       if( ok .and. ::lVSYMBOL)
         (::hd_file)->cvarsym := alltrim(str(value))
         ::dm:has(::hd_file +'->cvarsym'):set(alltrim(str(value)))
       endif

    case(name = ::hd_file +'->cvarsym'   )

    case(name = ::hd_file +'->dvystfak'  )
      if empty(value)
        drgMsgBOX( 'Datum vystavení faktury je povinný údaj ...' )
        ok := .f.
      else
        if StrZero(fakvnphdW->nobdobi,2) +'/' +Str(fakvnphdW->nrok) <> StrZero(Month(value),2) +'/' +Str( Year( value),4)
          ::msg:writeMessage('Datum vystavení faktury, nesouhlasí s obdobím dokladu...',DRG_MSG_INFO)
        endif
      endif

    case(name = ::hd_file +'->cnazpol1'  )
      ok := dod_stred->( dbseek( upper(value),,'CNAZPOL1') )

    case(name = ::hd_file +'->cnazpol1o' )
      ok := odb_stred->( dbseek( upper(value),,'CNAZPOL1') )

    endcase

  case(file = ::it_file )

    * kontroly a zpracování na položce
    do case
    case(name $ it_sel .and. changed)
      ok := ::fakturovat_z_sel(drgVar:drgDialog)

    case( name = ::it_file +'->nfaktmnoz' )

    case( name = ::it_file +'->ncenazakl' )
      nfaktmnoz := ::dm:has(::it_file +'->nFAKTMNOZ' )
      ::dm:set( ::it_file +'->ncenZakCel', nfaktmnoz:value * value )

    case(name = ::it_file +'->cnazpol6')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif

    endcase
  endcase

  if(file = ::hd_file .and. ok)
    eval(drgVar:block,drgVar:value)
    drgVar:initValue := drgVar:value
  endif

  if changed .and. ok
    ::dm:refresh()
  endif
RETURN ok


method fin_fakvnphd_in:osb_osoby_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::dm:drgDialog:lastXbpInFocus:cargo:ovar
  local  name   := lower(drgVar:name)

  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if (nexit != drgEVENT_QUIT)
    (::hd_file)->cjmenoVys := osoby->cosoba
    ::dm:set(::hd_file +'->cjmenoVys',osoby->cosoba)
  endif
return (nexit != drgEVENT_QUIT)



method fin_fakvnphd_in:overPostLastField()
  local  o_nazPol1 := ::dm:has(::it_file +'->cnazPol1' )
  local  ucet      := ::dm:get(::it_file +'->cucet'    )
  local  ok

  ok := ::c_naklst_vld(o_nazPol1,ucet)
return ok


METHOD FIN_fakvnphd_IN:postLastField(drgVar)
  local  isChanged := ::dm:changed()                                  , ;
         file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value
  local  ccisZakaz, ok

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if ::postValidateForm(::it_file)
    if ::state = 2  ; addRec( ::it_file )
                      if .not. empty(file_iv)
                         (file_iv)->(dbgoto(recs_iv))

                         * penalizaèní faktura se nesmí kopírovat
                         if file_iv <> 'fakvyshd_p'
                           ::copyfldto_w(file_iv,::it_file)
                         endif
                       endif

                       cisZakaz := (::it_file)->ccisZakaz
                       ::copyfldto_w(::hd_file,::it_file)
                       (::it_file)->nintcount  := ::ordItem()+1
                       (::it_file)->nsubCount  := 0
                       (::it_file)->ccisZakaz  := cisZakaz
    endif

    ::itSave()

    if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
    (::it_file)->(flock())

    ::sumColumn()
    ::setfocus(::state)
    ::dm:refresh()
  endif
RETURN .t.


method FIN_fakvnphd_IN:postAppend()

  * máme k dispozici položky DL ?
  if dodlstit ->(eof())
    (::cisloDl:odrg:isEdit := .F., ::cisloDl:odrg:oxbp:disable())
  else
    (::cisloDl:odrg:isEdit := .t., ::cisloDl:odrg:oxbp:enable())
  endif

  * máme výrobní zakázky pro støedisko dodavatele ?
  if .not. vyrzak ->(dbseek(upper(fakvnphd->cnazpol1),,'VYRZAK6'))
    (::cisZakazi:odrg:isEdit := .F., ::cisZakazi:odrg:oxbp:disable())
  else
    (::cisZakazi:odrg:isEdit := .t., ::cisZakazi:odrg:oxbp:enable())
  endif

  (::sklPol:odrg:isEdit   := .t., ::sklPol:odrg:oxbp:enable()  )
RETURN .T.


method FIN_fakvnphd_IN:postDelete()

//  ::wds_postDelete()
  ::sumColumn()
  ::brow:refreshAll()
return .t.


method FIN_fakvnphd_IN:postSave()
  local  ok
  *
  local  m_file := upper(left(::hd_file, len(::hd_file)-1))
  local  cisFak := (::hd_file)->ncisFak
  local  doklad := (::hd_file)->ndoklad

  local  file_name


  if ::lnewRec
    if .not. fin_range_key(m_file,cisFak,,::msg)[1]
      ::df:setnextfocus(::hd_file +'->ncisFak',,.t.)
      return .f.
    endif
  endif

  ok := FIN_fakVnphd_wrt_inTrans(self)

  if ok .and. ::set_likvidace_inOn = 1
    ::FIN_fakvnphd_lik_IN( ::drgDialog )
    ::set_likvidace_inOn = 0
    _clearEventLoop(.t.)
  endif


  if( ok .and. ::new_dok )
    if( select('fakVnphdW') <> 0, fakVnphdW->(dbclosearea()), nil )
    if( select('fakVnpitW') <> 0, fakVnpitW->(dbclosearea()), nil )
    if( select('fakVnp_iw') <> 0, fakVnp_iw->(dbclosearea()), nil )

    FIN_fakVnphd_cpy(self)

    file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
                 (::it_file) ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, ::it_file  , .t., .f.) ; (::it_file) ->(OrdSetFocus(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'fakvnp_iw', .t., .t.) ; fakvnp_iw ->(OrdSetFocus(1))


    ::brow:refreshAll()
    setAppFocus(::brow)
    ::dm:refresh( , .t.)

    ::sumColumn()
    ::df:setNextFocus( 'fakVnphdW->ctyppohybu',,.t.)

  elseif(ok .and. .not. ::new_dok)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

  endif
return ok

*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method FIN_fakvnphd_IN:postValidateForm(m_file)
  local  values := ::dm:vars:values, size := ::dm:vars:size(), x, file
  local  drgVar
  *
  begin sequence
    for x := 1 to size step 1
      file := lower(if( ismembervar(values[x,2]:odrg,'name'),drgParse(values[x,2]:odrg:name,'-'), ''))

      if file = m_file .and. values[x,2]:odrg:isEdit

        drgVar := values[x,2]

        if .not. ::postValidate(drgVar)

          ::df:olastdrg   := values[x,2]:odrg
          ::df:nlastdrgix := x
          ::df:olastdrg:setFocus()
          return .f.
  break
        endif
      endif
    next
  end sequence
return .t.