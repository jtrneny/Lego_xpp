#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define  m_files   {'asysprhd','asysprit','firmy','licence','asysver','dokument' }

*
** CLASS for PRO_explsthd_IN ***************************************************
CLASS SYS_pripominky_CRD FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewrec, hd_file, it_file
  *
*  var     cisZakazi
  method  init, drgDialogStart, postLastField, postSave, destroy
  method  preValidate, postValidate
  method  sys_verze_sel
  method  osb_osoby_sel
  *

  * hlavièka info
  * 1 -bìžná faktura/ 6 -euro faktura
  * 'Bez DpH    <infoval_11>   DpH  <infoval_12> Celkem                               '

  * položky - bro

  inline method eventHandled(nevent,mp1,mp2,oxbp)
    local  inSav := 0   // 0-neumíme uložit 1-ukládáme položku 2-ukládáme doklad

    do case
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


method SYS_pripominky_crd:init(parent)
  local value[2]
  local pos

  ::drgUsrClass:init(parent)
  *
  (::hd_file := 'asysprhdw',::it_file  := 'asyspritw')
  ::lnewrec  := .not. (parent:cargo = drgEVENT_EDIT)

  pos      := at('[', parent:parent:title)
  value[1] := Left(parent:parent:formName, 3)
  value[2] := Left(parent:parent:title, pos-1)

  * základní soubory
  ::openfiles(m_files)

  * pøednastavení z CFG
*  ::SYSTEM_nico    := sysconfig('system:nico'     )

  * likvidace
*  ::FIN_finance_in:typ_lik := 'poh'

  SYS_pripominky_cpy(self, value)
return self


METHOD SYS_pripominky_CRD:drgDialogStart(drgDialog)
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


method SYS_pripominky_CRD:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

/*

  do case
  case('cverze'     $ item)
    ::dataManager:set((::hd_file)->cverze, verzeAsys[3,2])
*    drgVar:odrg:pushGet:otext:setCaption(value)

  endcase

  case('cnoedt_2' $ item)
    drgVar:odrg:pushGet:otext:setSize({22,16})
    drgVar:odrg:pushGet:otext:configure()

    if at('->',filtritw ->cvyraz_2) = 0
      drgVar:odrg:pushGet:otext:setCaption(value)
      drgVar:odrg:isEdit := .t.
    else
      drgVar:odrg:pushGet:otext:setCaption('')
      drgVar:odrg:isEdit := .f.
    endif
*/

return ok


method SYS_pripominky_CRD:postLastField()
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


method SYS_pripominky_CRD:postSave()
  local ok := SYS_pripominky_wrt(self)

  if(ok .and. ::new_dok)
    asysprhdw->(dbclosearea())
    asyspritw->(dbclosearea())

    SYS_pripominky_cpy(self)

*    ::fin_finance_in:refresh('explsthdw',,::dm:vars)

    ::brow:refreshAll()
    ::dm:refresh()
    ::df:tabPageManager:toFront(1)
*    ::df:setnextfocus('explsthdw->ncisFirDOP',,.t.)
  endif
return ok


method SYS_pripominky_CRD:showGroup()
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




method SYS_pripominky_CRD:postValidate(drgVar)
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
    endcase
  endcase

  if( changed .and. ok, ::dm:refresh(), nil)

* hlavièku ukládáma na každém prvku
  if( ::hd_file $ name .and. drgVar:changed() .and. ok, drgVar:save(), nil )
return ok


* výbìr verze
method SYS_pripominky_CRD:sys_verze_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  name   := lower(drgVar:name)

  DRGDIALOG FORM 'SYS_verze_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if (nexit != drgEVENT_QUIT)
    do case
    case 'cverze' $ name
**      (::hd_file)->cverze := verzeAsys[3,2]
      (::hd_file)->cverze := asysver->cverze  //verzeAsys[3,2]
*    case 'cusrvyjadr' $ name
*      (::hd_file)->cusrvyjadr := osoby->cosoba
*    case 'cusrreseni' $ name
*      (::hd_file)->cusrreseni := osoby->cosoba
*    case 'cusrtest' $ name
*      (::hd_file)->cusrtest := osoby->cosoba
    endcase
    ::fin_finance_in:refresh(drgVar)
    ::dm:refresh()
  endif
return (nexit != drgEVENT_QUIT)


method SYS_pripominky_CRD:osb_osoby_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  name   := lower(drgVar:name)

  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if (nexit != drgEVENT_QUIT)
    do case
    case 'cusrpripom' $ name
      (::hd_file)->cusrpripom := osoby->cosoba
    case 'cusrvyjadr' $ name
      (::hd_file)->cusrvyjadr := osoby->cosoba
    case 'cusrreseni' $ name
      (::hd_file)->cusrreseni := osoby->cosoba
    case 'cusrtest' $ name
      (::hd_file)->cusrtest := osoby->cosoba
    endcase

    ::fin_finance_in:refresh(drgVar)
    ::dm:refresh()
  endif
return (nexit != drgEVENT_QUIT)



*
*****************************************************************
METHOD SYS_pripominky_CRD:destroy()
  ::drgUsrClass:destroy()
RETURN self