#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define  m_files   {'firmy','licence','asysver','dokument', 'c_stapri' }

*
** CLASS for PRO_explsthd_IN ***************************************************
CLASS SYS_pripominky_IN FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewrec, hd_file, it_file
  *
*  var     cisZakazi
  method  init, drgDialogStart, postLastField, postSave, destroy
  method  postAppend, postValidate
  method  sys_verze_sel
  method  sys_users_sel
  method  c_stapri_sel
  *

  * hlavièka info
  * 1 -bìžná faktura/ 6 -euro faktura
  * 'Bez DpH    <infoval_11>   DpH  <infoval_12> Celkem                               '

  * položky - bro
  inline method tabSelect(oTabPage,tabnum)
    do case
    case(otabPage:tabNumber = 6)   // 1 -> 2
    case(otabPage:tabNumber = 5)   // 1 -> 2
    case(otabPage:tabNumber = 4)   // 1 -> 2
    case(otabPage:tabNumber = 3)   // 1 -> 2
*      if Empty( ::dm:get(::hd_file +'->cusrvyjadr'))
*       ::dm:set(::hd_file +'->cusrvyjadr', users->cuser)
*       ::dm:set(::hd_file +'->cosovyjadr', users->cosoba)
*       ::dm:set(::hd_file +'->dzacvyjadr', Date())
*       ::dm:refresh()
*      endif

*-      ::p_head:hide()
    case(otabPage:tabNumber = 1)   // 2 -> 1
*-      ::p_head:show()
    endcase
  return .t.

  inline method eventHandled(nevent,mp1,mp2,oxbp)
    local  inSav := 0   // 0-neumíme uložit 1-ukládáme položku 2-ukládáme doklad
    local  inBro := (lower(::df:oLastDrg:classname()) $ 'drgbrowse,drgdbrowse')

    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      ::state := 0

*      if ::state <> 0
*        (::cisZakazi:odrg:isEdit := .F., ::cisZakazi:odrg:oxbp:disable())
*      endif

      ::dm:refresh()
      return .f.

    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()

      if isObject(::brow)
        if     inBro                                 ; inSav := if(isMethod(self,'postSave'),2,0)
        elseif ::hd_file $ lower(::df:oLastDrg:name) ; inSav := if(isMethod(self,'postSave'),2,0)
        else                                         ; inSav := if(isMethod(self,'postLastField'),1,0)
        endif
      else
        inSav := if( isMethod(self,'postSave'),2,0)
      endif

      do case
      case (inSav = 0)
        drgMsg(drgNLS:msg('Doklad je ve stavu rozpracován -nebude uložen- omlouvám se ...'),,::dm:drgDialog)
        return .t.

      case (inSav = 1)
        ::postLastField()

      otherwise
        if ::postSave()
          if( .not. ::new_dok,PostAppEvent(xbeP_Close, nEvent,,oXbp),nil)
          return .t.
        endif
      endcase

    otherwise
      return ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .f.

  method  showGroup

HIDDEN:
  var     p_head
  var     members_fak, members_pen, members_inf
*  method  fir_firmy_set
ENDCLASS


method SYS_pripominky_in:init(parent)
  ::drgUsrClass:init(parent)
  *
  (::hd_file  := 'asysprhdw',::it_file  := 'asyspritw')
  ::lnewrec  := .not. (parent:cargo = drgEVENT_EDIT)

  * základní soubory
  ::openfiles(m_files)

  * pøednastavení z CFG
*  ::SYSTEM_nico    := sysconfig('system:nico'     )

  * likvidace
*  ::FIN_finance_in:typ_lik := 'poh'

  SYS_pripominky_cpy(self)

return self


METHOD SYS_pripominky_IN:drgDialogStart(drgDialog)
  local  members  := drgDialog:dialogCtrl:members[1]:aMembers, odrg, groups
  local  fst_item := if(::lnewrec,'ctyppohybu','ncisFirmy'), pa, ph

  ::members_fak := {}
  ::members_pen := {}
  pa := ::members_inf := {}
  ph := ::p_head := nil

  aeval(members, {|x| if(ismembervar(x,'groups') .and. .not. isnull(x:groups), ;
                        if(x:groups $ 'HEAD', ph := x, nil),nil) })
  ::p_head     := ph:oxbp

*  aeval(members, {|x| if(ismembervar(x,'groups') .and. .not. isnull(x:groups), ;
*                        if(x:groups $ '16,25,34', aadd(pa,x), nil),nil) })

  for x := 1 TO Len(members)
    if members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
        members[x]:oXbp:setFontCompoundName(ListAsArray(members[x]:groups)[2])
        members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
      endif
    endif
  next

  *
  ::fin_finance_in:init(drgDialog,'poh' )  //  ,::it_file +'->ccisZakazi',' položku expedièního listu')

  for x := 1 to len(members) step 1
    if members[x]:classname() = 'drgPushButton'
      if isobject(members[x]:oxbp:cargo) .and. members[x]:oxbp:cargo:classname() = 'drgGet'
        odrg := members[x]:oxbp:cargo
      endif
    else
      odrg := members[x]
    endif

    groups := if( ismembervar(odrg,'groups'), isnull(members[x]:groups,''), '')

    do case
    case empty(groups)
      aadd(::members_fak,members[x])
      aadd(::members_pen,members[x])
    otherwise
      do case
      case('FAK' $ groups)  ;  aadd(::members_fak,members[x])
      case('PEN' $ groups)  ;  aadd(::members_pen,members[x])
      otherwise
        aadd(::members_fak,members[x])
        aadd(::members_pen,members[x])
      endcase
    endcase
  next

*  if(::lnewrec, ::comboItemSelected(::cmb_typPoh,0)                 , ;
*                ::df:setNextFocus((::hd_file) +'->ncisFirmy',, .T. )  )
*-  ::df:setNextFocus((::hd_file) +'->' +fst_item,, .T. )
RETURN


method SYS_pripominky_in:postAppend()
  LOCAL id
*  ::dm:set('explstitw->czkratJedn','ks')
*  ::dm:set('explstitw->ntypPriloh',  1 )

return .t.


method SYS_pripominky_in:postLastField()
  local  isChanged := ::dm:changed(), file_iv := alltrim(::dm:has(::it_file +'->cfile_iv'):value)
  local  cisZakaz

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
/*
    if ::state = 2  ;  if(.not. empty(file_iv), ::copyfldto_w(file_iv,::it_file),nil)
                       cisZakaz := (::it_file)->ccisZakaz
                       ::copyfldto_w(::hd_file,::it_file)

                       (::it_file)->ccisZakaz  := cisZakaz
                       (::it_file)->nintcount  := ::ordItem()+1
    endif
*/
*    ::itsave()

    if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
    (::it_file)->(flock())
  endif

*-  fin_ap_modihd('DODLSTHDW')
  ::setfocus(::state)
  ::dm:refresh()
return .t.


method SYS_pripominky_IN:postSave()
  local ok := SYS_pripominky_wrt(self)

  if(ok .and. ::new_dok)
    asysprhdw->(dbclosearea())
    asyspritw->(dbclosearea())

    SYS_pripominky_cpy(self)

    ::fin_finance_in:refresh('asysprhdw',,::dm:vars)

    ::brow:refreshAll()
    ::dm:refresh()
    ::df:tabPageManager:toFront(1)
    ::df:setnextfocus('asysprhdw->ctyppripom',,.t.)
*    ::df:setnextfocus('explsthdw->ncisFirDOP',,.t.)
  endif
return ok


method SYS_pripominky_IN:showGroup()
  local  x, odrg, avars, members := ::df:aMembers
*  local  panGroup := if((::hd_file)->nfintyp = 5, 'PEN', 'FAK')

* off
  aeval(members,{|o| ::modi_memvar(o,.f.)})

* on
  members := if( panGroup = 'FAK', ::members_fak, ::members_pen)
  aeval(members,{|o| ::modi_memvar(o,.t.)})

  avars := drgArray():new()
  for x := 1 to len(members) step 1
    if ismembervar(members[x],'ovar') .and. isobject(members[x]:ovar)
      if members[x]:ovar:className() = 'drgVar'
        avars:add(members[x]:ovar,lower(members[x]:ovar:name))
      endif
    endif
  next

  ::df:aMembers := members
  ::dm:vars     := avars

**  ::dm:refresh()
return


/*
method SYS_pripominky_in:comboItemSelected(drgcombo,mp2,o)
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
  endcase
return self
*/




method SYS_pripominky_IN:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok     := .T., changed := drgVAR:changed()
  *
*  local  it_fir := 'ncisfirmy,ncisfirdop,ncisfirdoa'
*  local  it_sel   := '...->ncislodl,...->cciszakazi,...->ccislobint,...->csklpol'
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
* hlavièka dokladu
  case(file = ::hd_file)
    do case
    case(name = ::hd_file +'->ctyppripom')
      if Empty( value)
        drgMsgBox(drgNLS:msg('Údaj musí být vyplnìn!'),XBPMB_CRITICAL )
        ok := .F.
      else
        if changed
          (::hd_file)->ctyppripom :=  value
          ::dm:set(::hd_file +'->ctyppripom', value)
        endif
      endif
    case(name = ::hd_file +'->cusrvyjadr')
      if changed
        ::dm:set(::hd_file +'->cosovyjadr', users->cosoba)
        if Empty( ::dm:get(::hd_file +'->dzacvyjadr'))
         ::dm:set(::hd_file +'->dzacvyjadr', Date())
        endif
      endif

    case(name = ::hd_file +'->cusrreseni')
      if changed
        ::dm:set(::hd_file +'->cosoreseni', users->cosoba)
        if Empty( ::dm:get(::hd_file +'->dzacreseni'))
         ::dm:set(::hd_file +'->dzacreseni', Date())
        endif
        if Empty( ::dm:get(::hd_file +'->cverreseni'))
          asysver->( dbSeek( 1,, AdsCtag(3) ))
          ::dm:set(::hd_file +'->cverreseni', asysver->cverze)
        endif
      endif
    case(name = ::hd_file +'->cusrtest')
      if changed
        ::dm:set(::hd_file +'->cosotest', users->cosoba)
        if Empty( ::dm:get(::hd_file +'->dzactest'))
          ::dm:set(::hd_file +'->dzactest', Date())
        endif
        if Empty( ::dm:get(::hd_file +'->cvertest'))
          asysver->( dbSeek( 1,, AdsCtag(3) ))
          ::dm:set(::hd_file +'->cvertest', asysver->cverze)
        endif
      endif
    endcase

/*
    do case
    case(item $ it_fir .and. mp1 = xbeK_RETURN)
      ok := ::fir_firmy_sel()


    case(name = ::hd_file +'->cnazpracov')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        ovar := ::dm:get(::hd_file +'->mpoznobj',.f.)
        PostAppEvent(xbeP_Keyboard,xbeK_TAB,,ovar:odrg:oxbp)
      endif
*/

 * položky dokladu
  case(file = ::it_file)
/*
    it_sel := strtran(it_sel,'...',::it_file)
    do case
    case(name $ it_sel .and. changed)
      ok := ::fakturovat_z_sel(drgVar:drgDialog)

    case(item $ it_fir .and. mp1 = xbeK_RETURN)
      ok := ::fir_firmy_sel()

    case(name = ::it_file +'->ncennaodod')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif
    endcase
*/

  endcase

  if( changed .and. ok, ::dm:refresh(), nil)

* hlavièku ukládáma na každém prvku
  if( ::hd_file $ name .and. drgVar:changed() .and. ok, drgVar:save(), nil )
return ok

/*
method SYS_pripominky_in:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgVar := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')

  ok := firmy->(dbseek(value,, AdsCtag(1) ))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    do case
    case(file = ::hd_file)  ;  (::hd_file)->ncisFirDOP  := firmy->ncisFirmy
                               (::hd_file)->cnazevDOP   := firmy->cnazev
                               (::hd_file)->cnazevDOP2  := firmy->cnazev2
                               (::hd_file)->nicoDOP     := firmy->nico
                               (::hd_file)->cdicDOP     := firmy->cdic
                               (::hd_file)->culiceDOP   := firmy->culice
                               (::hd_file)->csidloDOP   := firmy->csidlo
                               (::hd_file)->cpscDOP     := firmy->cpsc
      drgVar:set(firmy->ncisfirmy)
      ::fin_finance_in:refresh(drgVar)
      ::dm:refresh()

    case(file = ::it_file)  ;  ::fir_firmy_set(item)
    endcase
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_explsthd_in:fir_firmy_set(item)
  do case
  case(item = 'ncisfirmy' )  ;  ::dm:set(::it_file +'->ncisFirmy' ,firmy->ncisFirmy )
                                ::dm:set(::it_file +'->cnazev'    ,firmy->cnazev    )
                                ::dm:set(::it_file +'->cnazev2'   ,firmy->cnazev2   )
                                ::dm:set(::it_file +'->nico'      ,firmy->nico      )
                                ::dm:set(::it_file +'->cdic'      ,firmy->cdic      )
                                ::dm:set(::it_file +'->culice'    ,firmy->culice    )
                                ::dm:set(::it_file +'->csidlo'    ,firmy->csidlo    )
                                ::dm:set(::it_file +'->cpsc'      ,firmy->cpsc      )
                                ::dm:set(::it_file +'->czkratstat',firmy->czkratstat)

  case(item = 'ncisfirdoa')  ;  ::dm:set(::it_file +'->ncisFirDOA',firmy->ncisFirmy)
                                ::dm:set(::it_file +'->cnazevDOA' ,firmy->cnazev   )
                                ::dm:set(::it_file +'->cnazevDOA2',firmy->cnazev2  )
                                ::dm:set(::it_file +'->nicoDOA'   ,firmy->nico     )
                                ::dm:set(::it_file +'->cdicDOA'   ,firmy->cdic     )
                                ::dm:set(::it_file +'->culiceDOA' ,firmy->culice   )
                                ::dm:set(::it_file +'->csidloDOA' ,firmy->csidlo   )
                                ::dm:set(::it_file +'->cpscDOA'   ,firmy->cpsc     )
  endcase
return
*/


* výbìr osoby kdo zapsal
method SYS_pripominky_in:sys_users_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  name   := lower(drgVar:name)
  local  changed

  DRGDIALOG FORM 'SYS_users_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if (nexit != drgEVENT_QUIT)

    changed := drgVAR:changed()

    do case
    case 'cusrpripom' $ name
      (::hd_file)->cuser      := users->cuser
      (::hd_file)->cosoba     := users->cosoba

    case 'cusrvyjadr' $ name
      (::hd_file)->cusrvyjadr := users->cuser
      (::hd_file)->cosovyjadr := users->cosoba

    case 'cusrreseni' $ name
      if Empty( (::hd_file)->cusrreseni)
        (::hd_file)->dPriReseni := Date()
//        asysver->( dbSeek( 1,, AdsCtag(3) ))
//        (::hd_file)->cverreseni := asysver->cverze
      endif
      (::hd_file)->cusrreseni := users->cuser
      (::hd_file)->cosoreseni := users->cosoba

    case 'dkonreseni' $ name
      if .not. Empty( (::hd_file)->dkonreseni) .and. Empty( (::hd_file)->cverreseni)
        asysver->( dbSeek( 1,, 'ASYSVER03' ))
        (::hd_file)->cverreseni := asysver->cverze
      endif

    case 'cusrtest' $ name
      (::hd_file)->cusrtest   := users->cuser
      (::hd_file)->cosotest   := users->cosoba

    case 'dzactest' $ name
      if .not. Empty( (::hd_file)->dzactest) .and. Empty( (::hd_file)->cvertest)
        asysver->( dbSeek( 1,, 'ASYSVER03'))
        (::hd_file)->cvertest := asysver->cverze
      endif
      (::hd_file)->cusrtest   := users->cuser
      (::hd_file)->cosotest   := users->cosoba

    endcase

    ::fin_finance_in:refresh(drgVar)
    ::dm:refresh()
  endif
return (nexit != drgEVENT_QUIT)


* výbìr verze
method SYS_pripominky_IN:sys_verze_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  name   := lower(drgVar:name)

  DRGDIALOG FORM 'SYS_verze_SEL,' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if (nexit != drgEVENT_QUIT)
    do case
    case 'cverze' $ name
      (::hd_file)->cverze     := asysver->cverze
    case 'cverreseni' $ name
      (::hd_file)->cVerReseni := asysver->cverze
    case 'cvertest' $ name
      (::hd_file)->cVerTest   := asysver->cverze
    endcase
    ::fin_finance_in:refresh(drgVar)
    ::dm:refresh()
  endif
return (nexit != drgEVENT_QUIT)


*
** stav pøipomínky
method SYS_pripominky_in:c_stapri_sel(drgDialog)
  LOCAL oDialog, nExit
  *
  local  drgVar := ::dm:has('asysprhdw->nstaPripom')
  local  value  := drgVar:get()
  local  lOk    := (.not. Empty(value) .and. c_stapri ->(DbSeek(value,,'C_STAPRI01')))

  if IsObject(drgDialog) .or. .not. lOk
     DRGDIALOG FORM 'SYS_C_STAPRI' PARENT ::dm:drgDialog MODAL DESTROY ;
                                   EXITSTATE nExit

    if nExit != drgEVENT_QUIT
      (::hd_file)->nstaPripom := c_stapri->nstaPripom

      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgDialog:lastXbpInFocus)
    endif

    ::fin_finance_in:refresh(drgVar)
    ::dm:refresh()
  endif
return (nExit != drgEVENT_QUIT) .or. lOk


*
*****************************************************************
METHOD SYS_pripominky_IN:destroy()
  ::drgUsrClass:destroy()
RETURN self