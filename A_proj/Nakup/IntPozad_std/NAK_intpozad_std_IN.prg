#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
//
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'typdokl' , 'c_typpoh'                       , ;
                   'c_dph'   , 'c_meny'  , 'c_staty' , 'kurzit' , ;
                   'range_hd', 'range_it'                       , ;
                   'objitem' , 'vztahobj'                       , ;
                   'intPozad'                                   , ;
                   'osoby'   , 'spojeni' , 'vazSpoje'                        , ;
                   'nakpol'  , 'vyrzak'  , 'vyrzakit', 'cenzboz', 'dodzboz'  , ;
                   'firmy'   , 'firmyfi'                                        }


*  VYSTAVENÉ OBJEDNÁVKY      *
** CLASS for NAK_intpozad_std_IN **********************************************
CLASS NAK_intpozad_std_IN FROM drgUsrClass, FIN_finance_IN
  exported:
  var     lNEWrec,  cmb_typPoh
  var     typ_dokl  , is_ban, hd_file, it_file, in_file, varSym
  var     pa_vazRecs, cfiltr_ip_sel
  *
  var     lok_append2

  * new
  var     system_nico, system_cdic, system_cpodnik, system_culice, system_cpsc, system_csidlo

  * propojka na intPozad
  var     cisFirmy, from_nak_intPozad_in
  method  takeValue


  method  init, drgDialogStart, drgDialogEnd
  method  postValidate, comboItemSelected, tabSelect
  method  postLastField, postSave, postAppend, postDelete, postEscape
  *
  method  fir_firmy_sel, osb_osoby_sel_spoj, skl_cenzboz_sel, vyr_vyrzakit_sel, nak_objvyshd_vzt
  method  objVyshd_z_sel

  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1019
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
    drgDialog:dialog:maxButton := .f.
    return self

  * intpozad
  inline access assign method c_text_nsspo_Zpr() var c_text_nsspo_Zpr
    local  cte_Zpr, cem_Zpr
      spojeni->(dbseek( (::hd_file)->nsspoTeZpr,,'ID'))
      cte_Zpr := allTrim(spojeni->cadrElSpoj)

      spojeni->(dbseek( (::hd_file)->nsspoEmZpr,,'ID'))
      cem_Zpr := allTrim(spojeni->cadrElSpoj)
    return '[ ' +cte_Zpr +' / ' +cem_Zpr +' ]'

  inline access assign method c_text_nsspo_Pro() var c_text_nsspo_Pro
    local  cte_Zpr, cem_Zpr
      spojeni->(dbseek( (::hd_file)->nsspoTePro,,'ID'))
      cte_Zpr := allTrim(spojeni->cadrElSpoj)

      spojeni->(dbseek( (::hd_file)->nsspoEmPro,,'ID'))
      cem_Zpr := allTrim(spojeni->cadrElSpoj)
    return '[ ' +cte_Zpr +' / ' +cem_Zpr +' ]'

  *
  ** potenciální dodavatel
  inline access assign method nazFirmy() var nazFirmy
    local  cisFirmy := intPozadw->ncisFirmy
    firmy->( dbseek( cisFirmy,,'FIRMY1'))
  return firmy->cnazev

  inline access assign method c_text_infoFirmy() var c_text_infoFirmy
    local  cisFirmy := intPozadw->ncisFirmy
    firmy->( dbseek( cisFirmy,,'FIRMY1'))
  return '[ ' +allTrim(firmy->culice) +' / ' + ;
               allTrim(firmy->csidlo) +'_'   + ;
               str(firmy->nico) +' / ' +allTrim(firmy->cdic) +' ]'

// asi ven

  * objvyshd
  inline access assign method c_text_nsspoTeVyr() var c_text_nsspoTeVyr
    spojeni->(dbseek( (::hd_file)->nsspoTeVyr,,'ID'))
    return spojeni->cadrElSpoj

  inline access assign method c_text_nsspoEmVyr() var c_text_nsspoEmVyr
    spojeni->(dbseek( (::hd_file)->nsspoEmVyr,,'ID'))
    return spojeni->cadrElSpoj

  inline access assign method c_text_nsspoTeZpr() var c_text_nsspoTeZpr
    spojeni->(dbseek( (::hd_file)->nsspoTeZpr,,'ID'))
    return spojeni->cadrElSpoj

  inline access assign method c_text_nsspoEmZpr() var c_text_nsspoEmZpr
    spojeni->(dbseek( (::hd_file)->nsspoEmZpr,,'ID'))
    return spojeni->cadrElSpoj

  * objvysit
  inline access assign method stav_objvysitw() var stav_objvysitw
    local retVal := 0

    do case
    case(intPozadw->nmnozobdod  = 0                    )  ;  retVal :=   0
    case(intPozadw->nmnozobdod >= intPozadw->nmnozpodod)  ;  retVal := 302
    case(intPozadw->nmnozpldod <= intPozadw->nmnozobdod)  ;  retVal := 303
    endcase
    return retVal

  inline access assign method katcZbo() var katcZbo
    local  cky := strZero((::hd_file)->ncisFirmy,5) +::cisSklad:value +::sklPol:value

    dodzboz->(dbseek(cky,,'DODAV6'))
    return dodzboz->ckatcZbo

  inline access assign method procDph() var procDph
    c_dph->(dbseek(if(IsNull(::klicDph), 0,::klicDph:value)))
    return c_dph->nprocdph

  inline access assign method datObj()  var datObj
    return (::hd_file)->ddatObj

  inline access assign method typ_objitem() var typ_objitem
    local ky := if(IsNull(::cisSklad), '', ::cisSklad:value +::sklPol:value), isVyr := .F.

    nakpol->(dbseek(upper(ky),,'NAKPOL3'))
    isVyr := (nakpol->ckodtpv = 'R ' .or. nakpol->ckodtpv == 'P ')
    return if(isVyr, 'výrobek', 'zboží')

  inline access assign method cenaOzbo(par) var cenaOzbo
    local  cky := strZero((::hd_file)->ncisFirmy,5) +::cisSklad:value +::sklPol:value

    * pøednost má cena uvedená na intPozad
    if par = 3 .and. select('intPozad') <> 0
      if intpozad->ncennaodod <> 0
        return intpozad->ncennaodod
      endif
    endif

    dodzboz->(dbseek(cky,,'DODAV6'))
  return if( dodzboz->ncenaOzbo = 0, dodzboz->ncenaNzbo, dodzboz->ncenaOzbo)

  inline access assign method in_file(m_file)
    local pos

    if ::state = 2
      if pcount() == 1
        ::in_file := m_file
      else
        ::in_file := if( Empty(::varSym:get()), '', ::in_file)
      endif
    else
    endif
  return ::in_file
  *
  **
  inline method int_cisObj()
    local  m_filter := "ncisfirmy = %%", filter

    filter := Format(m_filter, {objvyshdw->ncisfirmy})
    objhd_iw->(AdsSetOrder('OBJDODH2'), ;
               ads_setAOF(filter)     , ;
               dbgobottom()             )

    objvyshdw->ncisObj := objhd_iw->ncisObj +1
    objvyshdw->ccisObj := left(firmy->cnazev,4)       +'-' + ;
                          strzero(firmy->ncisfirmy,5) +'/' + ;
                          strzero(objvyshdw->ncisObj,4)

    ::dm:get(::hd_file +'->ccisObj', .F.):set(objvyshdw->ccisObj)
    objhd_iw->(ads_clearAOF())

    objhd_iw->(dbSeek( strZero(Year(date()),4),, AdsCtag(4) ,.t.))
    objvyshdw->nrok_obj := Year(date())
    objvyshdw->npor_obj := objhd_iw->npor_obj +1
  return
  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  myEv := {drgEVENT_APPEND,drgEVENT_EDIT,drgEVENT_SAVE,drgEVENT_EXIT,drgEVENT_DELETE}
    local  cky  := upper((::it_file)->ccisSklad) +upper((::it_file)->csklPol)
    local  file_Name, saveOk

    if( nEvent = drgEVENT_REFRESH, ::sumColumn(), nil)

    if ascan(myEv,nevent) <> 0
      if lower(::df:olastDrg:className()) $ 'drgbrowse,drgdbrowse'
        file_name := ::it_file
      else
        file_name := lower( isNull(drgparse(::df:oLastDrg:name,'-'), ::it_file ))
      endif
    endif

    do case
    case (nEvent = xbeBRW_ItemMarked)
      if( ::state <> 0, ::esc_focustobrow(), nil )

      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)
      ::state := 0

      cenZboz->(dbseek( cky,,'CENIK03'))
      ::enable_or_disable_items(.f.)

      if(isobject(::brow), ::brow:hilite(), nil)
      ::dm:refresh()
      RETURN .F.

    case( nevent = drgEVENT_ACTION )

       if isNumber( mp1 )
         if  mp1 = drgEVENT_SAVE .or. mp1 = drgEVENT_EXIT
           ::restColor()

           do case
           case(file_name = ::hd_file)  ;  saveOk := if((::it_file)->(eof()),-1,2)
           otherwise                    ;  if lower(::df:olastDrg:className()) $ 'drgbrowse,drgdbrowse'
                                             saveOk := if((::it_file)->(eof()),-1,2)
                                           else
                                             saveOk := 1
*                                            saveOk := if( ::postValidateForm(file_name), 1, 0)
                                           endif
           endcase

           if     saveOk = 1
              if(IsMethod(self, 'postLastField'), ::postLastField(), Nil)

           elseif saveOk = 2
              if isMethod(self,'postSave')
                if ::postSave()
                  if( .not. ::new_dok,PostAppEvent(xbeP_Close, nEvent,,oXbp),nil)
                  return .t.
                endif
              endif

           elseif saveOk = -1
             drgMsg(drgNLS:msg('Doklad nemá položky -nelze uložit- omlouvám se ...'),,::dm:drgDialog)
           endif

           return .t.
         endif
       endif
/*
    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()

      do case
      case(file_name = ::hd_file)  ;  saveOk := if((::it_file)->(eof()),-1,2)
      otherwise                    ;  if lower(::df:olastDrg:className()) $ 'drgbrowse,drgdbrowse'
                                        saveOk := if((::it_file)->(eof()),-1,2)
                                      else
                                        saveOk := 1
*                                        saveOk := if( ::postValidateForm(file_name), 1, 0)
                                      endif
      endcase

      if     saveOk = 1
        if(IsMethod(self, 'postLastField'), ::postLastField(), Nil)

      elseif saveOk = 2
        if isMethod(self,'postSave')
          if ::postSave()
            if( .not. ::new_dok,PostAppEvent(xbeP_Close, nEvent,,oXbp),nil)
            return .t.
          endif
        endif

      elseif saveOk = -1
        drgMsg(drgNLS:msg('Doklad nemá položky -nelze uložit- omlouvám se ...'),,::dm:drgDialog)
      endif
      return .t.
*/

/*
      if .not. (lower(::df:oLastDrg:classname()) $ 'drgbrowse,drgdbrowse') .and. isobject(::brow)
        if(IsMethod(self, 'postLastField'), ::postLastField(), Nil)
      else
        if isMethod(self,'postSave')
          if ::postSave()
            if( .not. ::new_dok,PostAppEvent(xbeP_Close, nEvent,,oXbp),nil)
            return .t.
          endif
        else
          drgMsg(drgNLS:msg('Doklad je ve stavu rozpracován -nebude uložen- omlouvám se ...'),,::dm:drgDialog)
          return .t.
        endif
      endif
*/
    otherwise
      RETURN ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .F.

HIDDEN:
   * ok
   var     cislObint, cisSklad, sklPol, cisIntPoz, cisZakazI, klicDph, mnozOBodb
   method  sumColumn // , takeValue

   VAR     zaklMena, title, cisFak
   METHOD  postValidateForm

   *
   **
   inline method is_vztahObj()
     local  cisSklad := upper(::cisSklad:value), sklPol := upper(::sklPol:value)
     local  m_filter := "upper(ccisSklad) = '%%' .and. upper(csklPol) = '%%' .and. nmnozKOdod <> 0"
     *
     local  filter, is_Vztah

     if vztahobjw->(dbseek(ccisSklad +sklPol,,'VZTAHOB_1'))
       is_Vztah := .t.

     else
       filter := format(m_filter, {cisSklad,sklPol})
       objitem->(ads_setAof(filter),dbgotop())

       is_Vztah  := .not. objitem->(eof())
       objitem->(ads_clearAof())
     endif

     ::mnozOBodb:odrg:isEdit := is_Vztah
     if( is_Vztah, ::mnozOBodb:odrg:oxbp:enable(), ::mnozOBodb:odrg:oxbp:disable())
   return .t. /// is_Vztah

   inline method enable_or_disable_items(lenable)
     if lenable
       ( ::sklPol:odrg:isEdit    := .t., ::sklPol:odrg:oxbp:enable()   )
//       ( ::cisIntPoz:odrg:isEdit := .t., ::cisIntPoz:odrg:oxbp:enable())
     else
       ( ::sklPol:odrg:isEdit    := .f., ::sklPol:odrg:oxbp:disable()   )
//       ( ::cisIntPoz:odrg:isEdit := .f., ::cisIntPoz:odrg:oxbp:disable())
     endif
   return self

ENDCLASS


method NAK_intpozad_std_in:init(parent)
  local  cfiltr := "czkrSpoj = 'TEL_ZAM' .or. czkrSpoj = 'EMAIL_ZAM'"

  ::drgUsrClass:init(parent)
  *
//  (::hd_file := 'objvyshdw', ::it_file := 'objvysitw')
  (::hd_file := 'intPozadw' , ::it_file := 'intPozadw' )
  *
  ::typ_dokl    := 'xx'
  ::is_ban      := .F.  // (typ_dokl = 'ban')
  ::lNEWrec     := .not. (parent:cargo = drgEVENT_EDIT)
  ::lok_append2 := .f.
  ::zaklMena    := SysConfig('Finance:cZaklMena')

  * data
  drgDBMS:open('objvyshd',,,,,'objhd_iw')

  * základní soubory
  ::openfiles(m_files)

  * vazba na intPozad,
  * pokud by byl filtrovaný musím ji uvolnit pro ukládání vazby
  drgDBMS:open('intPozad',,,,,'int_Pozad' )

  spojeni->( ads_setAof(cfiltr), dbgoTop())

  * pøednastavení z CFG
  ::SYSTEM_nico    := sysconfig('system:nico'     )
  ::SYSTEM_cdic    := sysconfig('system:cdic'     )
  ::SYSTEM_cpodnik := sysconfig('system:cpodnik'  )
  ::SYSTEM_culice  := sysconfig('system:culice'   )
  ::SYSTEM_cpsc    := sysconfig('system:cpsc'     )
  ::SYSTEM_csidlo  := sysconfig('system:csidlo'   )
  *
  nak_intPozad_std_cpy(self)
return self


method NAK_intpozad_std_in:drgDialogStart(drgDialog)
  local  que_del := ' ' +'objednávky vystavené'   //::title
  local  members  := drgDialog:oForm:aMembers, aedits := {}
  *
  local  pa_grous, nin, acolors := MIS_COLORS
  local  doklad

   for x := 1 to LEN(members) step 1
    if members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      pa_groups := ListAsArray(members[x]:groups)
      nin       := ascan(pa_groups,'SETFONT')

      members[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

      if 'GRA_CLR' $ atail(pa_groups)
        if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
           members[x]:oXbp:setColorFG(acolors[nin,2])
        endif
      else
        members[x]:oXbp:setColorFG(GRA_CLR_BLACK)
      endif
    endif
  next

  ::FIN_finance_in:init(drgDialog,::typ_dokl,::it_file +'->csklpol',que_del,.t.)
  *
//  ::cmb_typPoh := ::dm:has(::hd_file +'->ctyppohybu'):odrg
  ::cisFirmy   := ::dm:get(::hd_file +'->ncisfirmy' , .F.)

  ::cisSklad   := ::dm:get(::it_file +'->ccissklad' , .F.)
  ::sklPol     := ::dm:get(::it_file +'->csklpol'   , .F.)
//  ::cisIntPoz  := ::dm:get(::it_file +'->ncisIntPoz', .F.)
  ::cisZakazI  := ::dm:get(::it_file +'->cciszakazi', .F.)
  ::klicDph    := ::dm:get(::it_file +'->nklicdph'  , .F.)
//  ::mnozOBodb  := ::dm:get(::it_file +'->nmnozobodb', .F.)
  *
  if ::lNEWrec
//    ::comboItemSelected(::cmb_typPoh)
  else
//    if objvyshd->nmnozpldod = 0
//      ::cisFirmy:odrg:isedit := ::cisFirmy:odrg:isedit_inrev := .t.
//      ::cisFirmy:odrg:oxbp:enable()

//      ::cisFirmy:odrg:pushGet:disabled := .f.
*      ::cisFirmy:odrg:pushGet:isedit   := .t.
//    endif
  endif
  *
//  ::sumColumn()
  *
  ::state := 0
  if( ::lnewRec, nil, ::df:setnextfocus(::hd_file +'->czakobjint',,.t.))
  *
  ** propojka na intPozad
  ** dialog se spouští v metodì nak_intpozad_in:nak_intPozad_to_objVys - quickShow
  if( ::from_nak_intPozad_in := ( drgDialog:parent:formName = 'nak_intpozad_in' ))
    doklad := ::dm:get(::hd_file +'->ndoklad' , .F.)

    ( ::cmb_typPoh:isEdit    := .f., ::cmb_typPoh:oxbp:disable()    )
    ( doklad:odrg:isEdit     := .f., doklad:odrg:oxbp:disable()     )
    ( ::cisFirmy:odrg:isEdit := .f., ::cisFirmy:odrg:oxbp:disable() )
  endif

return if( drgDialog:parent:formName = 'nak_intpozad_in', .f., self )


method NAK_intpozad_std_in:drgDialogEnd(drgDialog)

 intPozadw->(dbcloseArea())
  intPo_itw->(dbcloseArea())

  spojeni->( ads_clearAof())
//  objvyshdw->(dbclosearea())
//   objvysitw->(dbclosearea())
//    objvy_itw->(dbclosearea())
//     vztahobjw->(dbclosearea())
//      vztahob_w->(dbclosearea())
return


method NAK_intpozad_std_in:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-')
  local  ok     := .T., changed := drgVAR:changed(), nkcObj, nkcDan
  local  it_sel := '...->csklpol,...->ncisintpoz'
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  local  nmnozObSkl, nmnozObOdb, nmnozObDod, nmnozPoDod, nmnozPlDod, ;
         ncenNaoDod, ncenProDod, nkcBdObj  , nkcZdObj

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
* hlavièka dokladu
  case(file = ::hd_file)
    do case
     CASE(name = ::hd_file +'->ndoklad')
       if drgVar:odrg:isEdit .or. changed
         ok := fin_range_key('OBJVYSHD',value,,::msg)[1]
       endif

    case(name = ::hd_file +'->ncisfirmy' .and. mp1 = xbeK_RETURN)
      ok := ::fir_firmy_sel()

    case(name = ::hd_file +'->czkratstat' .or. name = ::hd_file +'->czkratmenz') .and. changed
      ::fin_kurzit(drgvar,(::hd_file)->ddatobj)

    case(name = ::hd_file +'->cnazpracov')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        ovar := ::dm:get(::hd_file +'->mpoznobj',.f.)
        PostAppEvent(xbeP_Keyboard,xbeK_TAB,,ovar:odrg:oxbp)
      endif
    endcase

 * položky dokladu
  case(file = ::it_file)
    it_sel     := strtran(it_sel,'...',::it_file)

    nmnozObSkl := ::dm:has(::it_file +'->nmnozObSkl')
    nmnozObOdb := ::dm:has(::it_file +'->nmnozObOdb')
    nmnozObDod := ::dm:has(::it_file +'->nmnozObDod')
    nmnozPoDod := ::dm:has(::it_file +'->nmnozPoDod')
    nmnozPlDod := ::dm:has(::it_file +'->nmnozPlDod')
    *
    ncenNaoDod := ::dm:has(::it_file +'->ncenNaoDod')
    ncenProDod := ::dm:has(::it_file +'->ncenProDod')
    nkcBdObj   := ::dm:has(::it_file +'->nkcBdObj'  )
    nkcZdObj   := ::dm:has(::it_file +'->nkcZdObj'  )

    do case
    case(name $ it_sel .and. changed)
      ok := ::objVyshd_z_sel( if( empty(value), ::drgDialog, nil ))


*********************************************
/*
    case(name = ::it_file +'->csklpol' )
      do case
      case nevent = xbeP_SetInputFocus .or. mp1 = xbeK_RETURN .or. mp1 = xbeK_TAB
        ok := if( ::cisIntPoz:odrg:isEdit, .t., ::objVyshd_z_sel( if( empty(value), ::drgDialog, nil ) ))
      endcase

    case(name = ::it_file +'->ncisIntPoz')
      do case
      case nevent = xbeP_SetInputFocus .or. mp1 = xbeK_RETURN .or. mp1 = xbeK_TAB
        ok := ::objVyshd_z_sel( if( empty(value), ::drgDialog, nil ) )
      endcase
*/

//    case(name = ::it_file +'->csklpol'    .and. (mp1 = xbeK_RETURN .or. nevent = drgEVENT_SAVE))
//      ok := ::skl_cenzboz_sel()

//    case(name = ::it_file +'->cciszakazi' .and. mp1 = xbeK_RETURN)
*-      if( .not. empty(value), ok := ::vyr_vyrzakit_sel(), nil)
**********************************************


    case(name = ::it_file +'->cdoplntxt')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif

    endcase

    * výpoèet nmnozObDod
    nmnozObDod:set(nmnozObSkl:value +nmnozObOdb:value)
    if nmnozObDod:value < 0
      ::msg:writeMessage('Objednávané množství od dodavatele je chybné ...',DRG_MSG_WARNING)
    endif

    * výpoèet nKcBdObj / nkcZdObj
    nkcObj := nmnozObDod:value *ncenNaoDod:value
    nkcDan := if( ::procDph <> 0, int(nkcObj * ::procDph/100), 0)

    nkcBdObj:set(nkcObj)
    nkcZdObj:set(nkcObj +nkcDan)
  endcase

  if( changed .and. ok, ::dm:refresh(), nil)

* hlavièku ukládáma na každém prvku
  if( ::hd_file $ name .and. drgVar:changed() .and. ok, drgVar:save(), nil )
return ok


method NAK_intpozad_std_in:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  m_filter := "ncisfirmy = %%", filter, cKy

  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. ::cisFirmy:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    if firmyfi->(dbseek(firmy->ncisfirmy,,'FIRMYFI1'))
      ::copyfldto_w('firmyfi','objvyshdw')
    endif
    ::copyfldto_w('firmy'  ,'objvyshdw')

    ::int_cisObj()

    c_staty->(dbSeek(upper((::hd_file)->czkratStat,,'C_STATY1')))
    c_meny->(dbseek(upper(c_staty->czkratMeny,,'C_MENY1')))
    *
    if ((::hd_file)->nkurzahmen +(::hd_file)->nmnozprep = 0 .or. ;
       empty((::hd_file)->czkratmenz)                       .or. ;
       (c_meny->czkratmeny <> (::hd_file)->czkratmenz)           )

      kurzit->(mh_seek(upper(c_meny->czkratmeny),2,,.t.))

      kurzit->( AdsSetOrder(2), dbsetScope(SCOPE_BOTH, UPPER(c_meny->czkratMeny)))
      cKy := upper(c_meny->czkratMeny) +dtos((::hd_file)->ddatObj)
      kurzit->(dbSeek(cKy, .T.))
      If( kurzit->nkurzStred = 0, kurzit->(dbgoBottom()), NIL )

      (::hd_file)->czkratmenz := c_meny->czkratmeny
      (::hd_file)->nkurzahmen := kurzit->nkurzstred
      (::hd_file)->nmnozprep  := kurzit->nmnozprep

      kurzit->(dbclearScope())
    endif

    ::cisFirmy:set(firmy->ncisfirmy)
    ::fin_finance_in:refresh(::cisFirmy)
    ::dm:refresh()
    ::df:setNextFocus(::hd_file +'->ddatobj',,.t.)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method NAK_intpozad_std_in:osb_osoby_sel_spoj(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, nky_Seek := 0
  *
  local  drgVar     := ::dm:drgDialog:lastXbpInFocus:cargo:ovar
  local  name       := lower(drgVar:name)
  local  field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  pa_hlavVazba, l_setTE := l_setEM := .f.

  * pokud opravuje zkusíme se napozicovat
  nky_Seek := if( field_name = 'cnazosovyr', (::hd_file)->ncisOsoVyr, (::hd_file)->ncisOsoZpr)

  oDialog := drgDialog():new('OSB_osoby_SEL_spoj', ::dm:drgDialog)
  oDialog:cargo := nky_Seek
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  pa_hlavVazba := aclone(oDialog:udcp:pa_hlavVazba)

  oDialog:destroy(.T.)
  oDialog := Nil

  if (nexit != drgEVENT_QUIT)
    do case
    case       ( field_name = 'cnazosovyr' )
      (::hd_file)->ncisOsoVyr := osoby->ncisOsoby

      (::hd_file)->cintPracov := osoby->cosoba
      (::hd_file)->cnazOsoVyr := osoby->cosoba
      * nsspoTeVyr - nsspoEmVyr
    otherwise
      (::hd_file)->ncisOsoZpr := osoby->ncisOsoby

      (::hd_file)->cnazpracov := osoby->cosoba
      (::hd_file)->cnazOsoZpr := osoby->cosoba
      * nsspoTeZpr - nsspoEmZpr
    endcase
    *
    spojeniWs->(dbgoTop())
    do while .not. spojeniWs->(eof())
      do case
      case allTrim(spojeniWs->czkrSpoj) = 'TEL_ZAM'  .and. .not. l_setTE
        if( pa_hlavVazba[1] <> 0, spojeniWs->( dbgoTo( pa_hlavVazba[1])), nil )

        if field_name = 'cnazosovyr'
          (::hd_file)->nsspoTeVyr := spojeniWs->spojeni
        else
          (::hd_file)->nsspoTeZpr := spojeniWs->spojeni
        endif
        l_setTE := .t.

      case allTrim(spojeniWs->czkrSpoj) = 'EMAIL_ZAM' .and. .not. l_setEM
        if( pa_hlavVazba[2] <> 0, spojeniWs->( dbgoTo( pa_hlavVazba[1])), nil )

        if field_name = 'cnazosovyr'
          (::hd_file)->nsspoEmVyr := spojeniWs->spojeni
        else
          (::hd_file)->nsspoEmZpr := spojeniWs->spojeni
        endif
        l_setEM := .t.
      endcase
      spojeniWs->(dbskip())
    enddo

    ::fin_finance_in:refresh(drgVar)
    ::dm:refresh()
  endif
return (nexit != drgEVENT_QUIT)


method NAK_intpozad_std_in:objVyshd_z_sel(drgDialog)
  local  odrg   := ::dm:drgDialog:lastXbpInFocus:cargo
  *
  local  value  := ::dm:drgDialog:lastXbpInFocus:value
  local  items  := Lower(drgParseSecond(odrg:name,'>'))
  local  recCnt := 0, showDlg := .f., ok := .f., isOk := .f.
  *
  local  odialog, nexit := drgEVENT_QUIT

  local  iz_file  := if( items = 'csklpol',              'cenzboz',         'intpozad')
  local  iz_pos   := if( items = 'csklpol',                      2,                  3)
  local  iz_dlg   := if( items = 'csklpol', 'NAK_objvyshd_cen_sel', 'NAK_intPozad_sel')

  ::cfiltr_ip_sel := format( "ncisFirmy = %% .and. cstavDokl = 'K'", { (::hd_file)->ncisFirmy })
  ::pa_vazRecs    := {}

  if isObject(drgDialog)
    showDlg := .t.

  else
    do case
    case( items = 'csklpol' )
      fordRec({ 'cenzboz' })
      cenzboz->(AdsSetOrder('CENIK01')             , ;
                dbsetscope(SCOPE_BOTH,upper(value)), ;
                dbgotop()                          , ;
                dbeval( {|| recCnt++ })            , ;
                dbgotop()                            )

      showDlg := .not. (recCnt = 1)
           ok :=       (recCnt = 1)
      if(recCnt = 0, cenzboz->(dbclearscope(),dbgotop()), nil)
      if(recCnt = 0, fordRec(), nil  )

    case( items = 'ncisintpoz' )
      intPozad->(AdsSetOrder('INTPOZ_01')    , ;
                 dbsetscope(SCOPE_BOTH,value), ;
                 dbgotop()                   , ;
                 dbeval( {|| recCnt++ })     , ;
                 dbgotop()                     )

        showDlg := .not. (recCnt = 1)
             ok :=       (recCnt = 1)
        if(recCnt = 0, intPozad->(dbclearscope(),dbgotop()), nil)
    endcase
  endif

  if showDlg
    odialog := drgDialog():new( iz_dlg, ::dm:drgDialog)
    odialog:create(,,.T.)

    nexit := odialog:exitState
  endif

  if .not. showDlg .or. (nexit != drgEVENT_QUIT)
    *
    ** pokud pøebírá položku z intPozad -> musíme napozicovat cenzboz
    if iz_file = 'intpozad'
      cky := upper(intpozad->ccisSklad) +upper(intpozad->csklPol)
      cenZboz->( dbSeek( cky,, 'CENIK03'))
    endif

    ::takeValue( iz_file, iz_pos)

    * po pøevzetí zablokujeme csklPol i cnazOdes
    * páè by se to furt kontrolovalo
    ::enable_or_disable_items(.f.)

    ::is_vztahObj()
  endif

  (iz_file)->(dbclearScope())
return (nexit != drgEVENT_QUIT) .or. ok


method NAK_intpozad_std_in:skl_cenzboz_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.

  ok := cenzboz->(dbseek(upper(::sklPol:value),,'CENIK01'))

  * v cenzboz se záhadným zpùsobem objevují prázdné záznamy
  * validace se pak chová jako by bylo všecno OK

  ok := ( ok .and. .not. empty( ::sklPol:value ))

  if isobject(drgdialog) .or. .not. ok
    ::sklPol:odrg:setFocus()

    DRGDIALOG FORM 'NAK_objvyshd_cen_sel' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. ::sklPol:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if( copy, ::takeValue('cenzboz',2), nil)
  if( copy, ::is_vztahObj()         , nil)
return (nexit != drgEVENT_QUIT) .or. ok


method NAK_intpozad_std_in:vyr_vyrzakit_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.

  ok := vyrzakit->(dbseek(upper(::cisZakazI:value),,'ZAKIT_4'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'NAK_objvyshd_vyr_sel' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. ::cisZakazI:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::cisZakazI:set(vyrzakit->ccisZakazI)
    ::dm:set('obbjvysitw->ccisZakaz', vyrzakit->ccisZakaz)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method NAK_intpozad_std_in:nak_objvyshd_vzt(drgDialog)
  local  state := if(::sklPol:odrg:isEdit, '2', '1') + ',' +upper(::cisSklad:value) +upper(::sklPol:value)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.

  ok := cenzboz->(dbseek(upper(::sklPol:value),,'CENIK01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'NAK_objvyshd_vzt_IN' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit CARGO state
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method NAK_intpozad_std_in:comboItemSelected(drgcombo,mp2,o)
  local  value := drgcombo:Value, values := drgcombo:values
  local  nin, pa, finTyp, obdobi, cfile

  do case
  case 'ctyppohybu' $ lower(drgcombo:name)
    nIn    := ascan(values, {|X| X[1] = value })
     pa    := listasarray(values[nin,4])
     *
     if values[nin,3] <> (::hd_file)->ctypdoklad .or. .not. ::lnewrec
       (::hd_file)->ctypdoklad := values[nin,3]
       (::hd_file)->ctyppohybu := values[nin,1]
     endif

  case 'czkratmenz' $ lower(drgcombo:name)
    if drgCombo:ovar:itemChanged()
      PostAppEvent(xbeP_Keyboard,xbeK_TAB,,drgcombo:oxbp)
    endif
  endcase
return self


method NAK_intpozad_std_in:tabSelect(oTabPage,tabnum)
  local it_file

  if oTabPage:tabNumber = 2 .and. isobject(::brow)
    it_file := ::brow:cargo:cfile
     if (it_file)->(eof())
       PostAppEvent(drgEVENT_APPEND,,,::brow)
     endif
   endif
return .t.


method NAK_intpozad_std_in:postEscape()
/*
  local filter, state := ::state
  local intCount := if(state = 2,::ordItem()+1,objvysitw->nintCount)
  *
  filter := format("ccisOBJ = '%%' .and. nintCount = %%",{objvyshdw->ccisOBJ,intCount})
  vztahobjw->(dbSetFilter(COMPILE(filter)),dbGoTop())

  do while .not. vztahobjw->(eof())
    do case
    case(state = 2)  ;  vztahobjw->nmnozOBdod := 0
                        vztahobjw->nmnozOBorg := 0
    otherwise        ;  vztahobjw->nmnozOBdod := vztahobjw->nmnozOBorg
                        vztahobjw->nmnozOBorg := vztahobjw->nmnozOBdod
    endcase
    vztahobjw->(dbSkip())
  enddo

  vztahobjw->(dbclearFilter())
*/
return .t.


method NAK_intpozad_std_in:postLastField(drgVar)
  local  file_iv, recs_iv, is_free := .f., cky

  if ::lnewRec
    if objhd_iw->( dbseek((::hd_file)->ndoklad,,'OBJDODH6'))
      (::hd_file)->ndoklad := fin_range_key('OBJVYSHD')[2]
      ::dm:set( ::hd_file +'->ndoklad', (::hd_file)->ndoklad )
    endif
  endif

  (::hd_file)->(dbcommit())

  if ::postValidateForm()

     file_iv := lower( alltrim(::dm:has(::it_file +'->cfile_iv'):value))
     recs_iv := ::dm:has(::it_file +'->nrecs_iv'):value
     is_Free := empty(file_iv)

    if((::it_file)->(eof()),::state := 2,nil)

    if ::state = 2
      if( is_Free, nil, (file_iv)->(dbgoto(recs_iv)))

      ::copyfldto_w(::hd_file, ::it_file,.t.)
      *
      ** pokud pøebírá položku z intPozad -> musíme napozicovat cenzboz
      if file_iv = 'intpozad'
        cky := upper(intpozad->ccisSklad) +upper(intpozad->csklPol)
        if cenZboz->( dbSeek( cky,, 'CENIK03'))
          ::copyfldto_w( 'cenZboz', ::it_file )
        endif
      endif

      if( is_Free, nil, ::copyfldto_w(file_iv,::it_file))
      (::it_file)->nintCount := ::ordItem()+1
    endif

    vztahobjw->(dbeval({||vztahobjw->nmnozOBorg := vztahobjw->nmnozOBdod }))
    (::it_file)->(flock())
    ::itSave()

    (::it_file)->nhmotnost := ((::it_file)->nmnozobdod * (::it_file)->nhmotnostJ)
    (::it_file)->nobjem    := ((::it_file)->nmnozobdod * (::it_file)->nobjemJ   )
    (::it_file)->(dbcommit())

    nak_objvyshd_cmp()
    ::sumColumn()

    if(::state = 2, ::brow:goBottom():refreshall(), ::brow:refreshCurrent())

    ::dm:refresh()
    ::setfocus(::state)
  endif
return .t.


method NAK_intpozad_std_in:postAppend()
  local  cky := strZero( (::hd_file)->ncisFirmy, 5) +'K'

  ::dm:set('M->datObj', (::hd_file)->ddatObj )

  (::sklPol:odrg:isEdit   := .t., ::sklPol:odrg:oxbp:enable()  )
  *
  ** máme k dispozici položky interních požadavkù pro èíslo firmy dodavatele a k objednání ?
  if intPozad->( dbseek( cky,,'INTPOZ_05'))
    ( ::cisIntPoz:odrg:isEdit := .t., ::cisIntPoz:odrg:oxbp:enable() )
  else
    ( ::cisIntPoz:odrg:isEdit := .f., ::cisIntPoz:odrg:oxbp:disable())
  endif
return .t.


method NAK_intpozad_std_in:postSave()
  local  ok, value := ::cmb_typPoh:value
  *
  local  m_file := upper(left(::hd_file, len(::hd_file)-1))
  local  doklad := (::hd_file)->ndoklad
  local  cky    := upper( 'nakup     nrangeobjv' +padR(usrName,10))

  if ::lnewRec
    if .not. configus->( dbseek( cky,,'CONFIGUS01'))
      (::hd_file)->ndoklad := fin_range_key('OBJVYSHD')[2]

    elseif .not. fin_range_key(m_file,doklad,,::msg)[1]
      ::df:tabPageManager:active := ::df:tabPageManager:members[2]
      ::df:tabPageManager:active:tabNumber   := 2
      ::df:tabPageManager:members[1]:is_show := .f.

      ::df:tabPageManager:showPage(1)

      (::hd_file)->ndoklad := fin_range_key('OBJVYSHD')[2]
      ::dm:set( ::hd_file +'->ndoklad', (::hd_file)->ndoklad )
      ::df:setnextfocus(::hd_file +'->ndoklad',,.t.)
      return .f.
    endif
  endif

  ok := nak_objvyshd_wrt_inTrans(self)

  if ( ok .and. ::new_dok .and. .not. ::from_nak_intPozad_in .and. .not. ::lok_append2 )
    objvyshdw->(dbclosearea())
    objvysitw->(dbclosearea())
    objvy_itw->(dbclosearea())
    vztahobjw->(dbclosearea())
    vztahob_w->(dbclosearea())

    nak_objvyshd_cpy(self)

    ::brow:refreshAll()
    ::dm:refresh()
    ::df:tabPageManager:toFront(1)

    ::df:setnextfocus('objvyshdw->ctyppohybu',,.t.)
    ::cmb_typPoh:value := value
    ::comboItemSelected(::cmb_typPoh)
  endif
return ok


method NAK_intpozad_std_in:postDelete()
  ::sumColumn()
  ::brow:refreshAll()
return .t.


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method NAK_intpozad_std_in:sumColumn()
  local x, ncol
  local ax_sum := {{'nmnozobdod', 0}, {'nmnozpodod', 0}, ;
                   {'nmnozpldod', 0}, {'nkczdobj'  , 0}  }

  objvy_itw->(dbgotop())
  do while .not. objvy_itw->(Eof())
    if objvy_itw->_delrec <> '9'
      ( ax_sum[1,2] += objvy_itw->nmnozobdod, ;
        ax_sum[2,2] += objvy_itw->nmnozpodod, ;
        ax_sum[3,2] += objvy_itw->nmnozpldod, ;
        ax_sum[4,2] += objvy_itw->nkczdobj    )
    endif
    objvy_itw->(dbskip())
  enddo

  for x := 1 to len(ax_sum) step 1
    begin sequence
    for ncol := 1 to ::brow:colCount step 1
      sumCol := ::brow:getColumn(ncol)
      if ax_sum[x,1] $ lower(sumCol:frmColum)
    break
      endif
    next
    end sequence

    if ncol <= ::brow:colCount
      value := ax_sum[x,2]

      ::brow:getColumn(ncol):Footing:lockUpdate(.t.)

      ::brow:getColumn(ncol):Footing:hide()
      ::brow:getColumn(ncol):Footing:setCell(1,value)
      ::brow:getColumn(ncol):Footing:show()

      ::brow:getColumn(ncol):Footing:lockUpdate(.f.)
    endif
  next
return .t.


method NAK_intpozad_std_in:takeValue(iz_file,iz_pos)
  local  x, pos, value, items, mname, par
*           objitemw,                cenzboz,              intPozad
*
  local  pa := { ;
  {      'ccissklad',            'ccissklad',            'ccissklad' }, ;
  {     'ncisintpoz',                     0 ,           'ncisintpoz' }, ;
  {        'csklpol',              'csklpol',              'csklpol' }, ;
  {       'ckatczbo',             ':katcZbo',             'ckatczbo' }, ;
  {        'cnazzbo',              'cnazzbo',              'cnazzbo' }, ;
  { 'M->typ_objitem',         ':typ_objitem',         ':typ_objitem' }, ;
  {       'nklicdph',             'nklicdph',             'nklicdph' }, ;
  {     'M->procDph',             ':procDph',             ':procDph' }, ;
  {     'czkratjedn',           'czkratjedn',           'czkratjedn' }, ;
  {       'dtermdod',  'objvyshdw->dtermdod',             'dtermdod' }, ;
  {     'ddatodvvyr', 'objheadw->ddatodvvyr',           'ddatodvvyr' }, ;
  {      'nprocslev',  'objheadw->nprocslev',            'nprocslev' }, ;
  {     'nprocslfao', 'objheadw->nprocslfao',           'nprocslfao' }, ;
  {     'nprocslhot', 'objheadw->nprocslhot',           'nprocslhot' }, ;
  {      'ncenazakl',            'ncenapzbo',            'ncenazakl' }, ;
  {     'ncennaodod',          ':cenaOzbo/2',          ':cenaOzbo/3' }, ;
  {     'nhmotnostj',            'nhmotnost',           'nhmotnostj' }, ;
  {        'nobjemj',               'nobjem',              'nobjemj' }, ;
  {     'nmnozobskl',                      0,           'nmnozObSkl' }, ;
  {     'ccisZakazI',                     '',           'ccisZakazI' }, ;
  {      'nINTPOZAD',                      0,                  'sID' }, ;
  {       'mpoznObj',                     '',             'mpoznObj' }  }


   for x := 1 to len(pa) step 1
     if IsObject(ovar := ::dm:has(if(at('->',pa[x,1]) = 0,::it_file +'->' +pa[x,1], pa[x,1])))

       do case
       case empty(pa[x,iz_pos])
         value := pa[x,iz_pos]

       case at(':', pa[x,iz_pos]) <> 0
         items := strtran(pa[x,iz_pos],':','')
         if at('/',items) = 0
           value := self:&items()
         else
           mname := substr(items,1,at('/',items) -1)
           par   := val(substr(items,  at('/',items) +1))
           value := self:&mname(par)
         endif

       otherwise
         if at('->',pa[x,iz_pos]) = 0
           value := DBGetVal(iz_file +"->" +pa[x,iz_pos])
         else
           value := DBGetVal(+pa[x,iz_pos])
         endif
       endcase

       ovar:set(value)
       ovar:initValue := ovar:prevValue := value
     endif
   next

   if( IsObject(ovar := ::dm:has(::it_file +'->cfile_iv')), ovar:set(iz_file)             , nil)
   if( IsObject(ovar := ::dm:has(::it_file +'->nrecs_iv')), ovar:set((iz_file)->(recno())), nil)

   ::df:setNextFocus('objitemw->nmnozobskl',,.T.)
return


method NAK_intpozad_std_in:postValidateForm()
  local values := ::dm:vars:values, size := ::dm:vars:size(), x

  begin sequence
  for x := 1 to size step 1
    if .not. values[x,2]:odrg:postValidate()
      return .f.
  break
    endif
  next
  end sequence
RETURN .t.

/*
*
** class NAK_objvyshd_vyr_sel **************************************************
class NAK_objvyshd_vyr_sel from drgUsrClass
  exported:
  method  init, getForm, drgDialogInit, drgDialogStart
  method  createContext, fromContext


  inline access assign method mnozKFak() var mnozKFak
      return (vyrzakit->nMNOZPLANO -vyrzakit->nMNOZFAKT)

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

    do case
    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    case nEvent = drgEVENT_APPEND
    case nEvent = drgEVENT_FORMDRAWN
      Return .T.

    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        RETURN .F.
      endcase

    otherwise
      RETURN .F.
    endcase
  RETURN .T.

  hidden:
  var  drgGet, drgPush, popUp, popState, in_file
endclass


method NAK_objvyshd_vyr_sel:init(parent)
  local nEvent,mp1,mp2,oXbp
  local m_parent, odrg

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if IsOBJECT(oXbp:cargo)
    if oxbp:cargo:className() = 'drgGet'
      ::drgGet := oXbp:cargo
    else
      * použito v EBro
      if isObject( m_parent := parent:parent )
        if isObject( odrg := m_parent:oForm:oLastDrg )
          ::drgGet := if( odrg:className() = 'drgGet', odrg, nil )
        endif
      endif
    endif
  endif

  ::popUp    := 'Kompletní seznam ,Nevyfakturované, Vyfakturované, Èásteènì fakturované'
  ::popState := 1
  ::in_file  := 'vyrzakit'

  ::drgUsrClass:init(parent)
return self


method NAK_objvyshd_vyr_sel:getForm()
  local oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 110,15.2 DTYPE '10' TITLE 'Seznam výrobních zakázek _ výbìr' ;
                                              GUILOOK 'All:N,Border:Y'

    DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 110,13 FILE 'VYRZAKIT'     ;
      FIELDS 'cCISZAKAZ:èísloZakázky:20,'                          + ;
             'cCISZAKAZI:výrÈíslo:20,'                             + ;
             'cNAZEVZAK1:název zakázky:39,'                        + ;
             'CNAZFIRMY::20,'                                      + ;
             'cSKP:skp,'                                           + ;
             'cZKRATMENZ:mìna,'                                    + ;
             'nCENAMJ:cena/mj,'                                    + ;
             'M->mnozKFak:množKFak:10,'                            + ;
             'nRozm_del:délka,'                                    + ;
             'nRozm_sir:šíøka,'                                    + ;
             'nRozm_vys:výška,'                                    + ;
             'cRozm_MJ:mj'                                           ;
      SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y'
    DRGPUSHBUTTON INTO drgFC CAPTION 'Kompletní seznam ' POS 72,0.05 SIZE 38,1 ;
                  EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'
return drgFC


method NAK_objvyshd_vyr_sel:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*  XbpDialog:titleBar := .F.

  drgDialog:dialog:drawingArea:bitmap  := 1016 // 1018
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  endif
return


method NAK_objvyshd_vyr_sel:drgDialogStart(drgDialog)
  local  x, members := drgDialog:oForm:aMembers

  * napozicujeme
  if IsObject(::drgGet)
    if( .not. vyrzakit->(dbSeek(::drgGet:oVar:value,,'ZAKIT_4')), vyrzakit->(dbGoTop()), nil)
    drgDialog:dialogCtrl:browseRefresh()
  endif


  for x := 1 to len(members) step 1
    if( members[x]:ClassName() = 'drgPushButton', ::drgPush := members[x], NIL )
  next

  if isobject(::drgPush)
    ::drgPush:oXbp:setFont(drgPP:getFont(5))
    ::drgPush:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
  endif
return self


METHOD NAK_objvyshd_vyr_sel:createContext()
  local csubmenu, opopup, apos
  *
  local pa := listasarray(::popUp)

  csubmenu := drgNLS:msg(::popUp)
  opopup   := XbpMenu():new( ::drgDialog:dialog ):create()

  for x := 1 to len(pa) step 1
    opopup:addItem( {drgParse(@cSubMenu), de_BrowseContext(self,x,pA[x]) } )
  next

  opopup:disableItem(::popState)

  apos    := ::drgPush:oXbp:currentPos()
  opopup:popup(::drgDialog:dialog, apos)
return self


method NAK_objvyshd_vyr_sel:fromContext(aorder,nmenu)
  local obro   := ::drgDialog:dialogCtrl:oaBrowse
  local filter := ''  // ::m_filter +if(.not. empty(::m_filter), " .and. ", "")

  ::popState := aorder
  ::drgPush:oxbp:setCaption(nmenu)

  do case
  case(aorder = 1)                               // Kopmletní seznam
    (::in_file)->(ads_clearAof())

  otherwise
    do case
    case(aorder = 2)                               // Nevyfakturované
      filter += " nstavfakt  = 0"

    case(aorder = 3)                              // Vyfakturované
      filter += " nstavfakt  =  2"

    case(aorder = 4)                              // Èásteènì fakturované
      filter += " nstavfakt  = 1"
    endcase

    if( .not. empty(filter),(::in_file)->(ads_setAof(filter)), nil)
  endcase

  (::in_file) ->(dbgotop())
  obro:oXbp:refreshAll()
RETURN self
*/