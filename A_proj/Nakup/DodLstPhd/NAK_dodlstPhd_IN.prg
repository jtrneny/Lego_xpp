#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
//
#include "..\Asystem++\Asystem++.ch"


#define  m_files   { 'typdokl' ,'c_typpoh'                       , ;
                     'c_dph'   ,'c_meny'   ,'c_staty' ,'kurzit'  , ;
                     'firmy'   ,'firmyfi'  ,'firmyuc'            , ;
                     'cenzboz' ,'objvysit' ,'vyrzak'  ,'vyrzakit','kusov'  ,'ucetpol' }

*
** CLASS for NAK_dodlstPhd_IN *************************************************
CLASS NAK_dodlstPhd_IN FROM drgUsrClass, FIN_finance_IN
exported:
  var     lNEWrec,  cmb_typPoh
  var     typ_dokl, is_ban, hd_file, it_file, in_file, varSym
  *
  var     system_nico, system_cdic, system_cpodnik, system_culice, system_cpsc, system_csidlo

  method  init, drgDialogStart, postSave
  method  postValidate, comboItemSelected, tabSelect

  method  postDelete, onSave, destroy
  method  overPostLastField, postLastField
  method  fir_firmy_sel
  method  dodlstPhd_z_sel


  * položky bro  -  ceníková položka / sestava
  inline access assign method cenPol() var cenPol
    return if((::it_file)->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method isSest() var isSest
    local  retVal := 0, cky := space(30) +upper(cenzboz->csklPol)

    if (::it_file)->ctypSklPol = 'S '
      retVal := if( kusov->(dbSeek(cky,,'KUSOV1')), MIS_BOOKOPEN, MIS_BOOK)
    endif
    return retVal

  * it
  * prijaté a fakturované množství je shodné, jde jen o pomocnou položku
  inline access assign method prij_Mnoz() var prij_Mnoz
    if isObject(::faktMnoz)
      return ::faktMnoz:get()
    endif
    return 0

  * mìnu z hlavièky potøebujeme vidìt na položkách
  inline access assign method zkratMenz() var zkratMenz
    return (::hd_file)->czkratMenz

  * skladová MJ nemusí být shodná s MJ na pøíjmu
  inline access assign method sklad_Mj() var sklad_Mj
    if isObject(::cisSklad) .and. isObject(::sklPol)
      cenzboz->(dbseek( upper(::cisSklad:get()) +upper(::sklPol:get()),,'CENIK03'))
      return cenzboz->czkratJedn
      ::dm:refresh()
    endif
    return ''

  *
  inline access assign method cenzboz_kDis()  var cenzboz_kDis
    if isObject(::cisSklad) .and. isObject(::sklPol)
      cenzboz->(dbseek( upper(::cisSklad:get()) +upper(::sklPol:get()),,'CENIK03'))
      return cenzboz->nmnozSZbo
    endif
    return 0

  inline access assign method objvysit_kDis() var objvysit_kDis
    if isObject(::cisObj) .and. isobject(::cislPolob)
      objvysit->(dbseek( upper(::cisObj:get()) +strZero(::cislPolob:get(),5),,'OBJVYSI5'))
      return (objvysit->nmnozObDod -objvysit->nmnozPlDod)
    endif
    return 0

  inline access assign method vyrzak_kDis()   var vyrzak_kDis
    if isObject(::cisZakazi)
      vyrzakit->(dbseek( upper(::cisZakazi:get()),, 'ZAKIT_4'))
      return (vyrzakit->nmnozPlano -vyrzakit->nmnozVyrob)
    endif
    return 0

  * pro takeValue
  inline method dodlp_dph()
    c_dph->(dbseek( cenzboz->nklicDph))
    return c_dph->nprocdph

  *
  * hlavièka info
  * 1 -bìžná faktura/ 6 -euro faktura
  * 'Bez DpH    <infoval_11>   DpH  <infoval_12> Celkem                               '
  inline access assign method infoval_11 var infoval_11
    return (dodlstPhdw->ncendancel +dodlstPhdw->nzakldaz_1 +dodlstPhdw->nzakldaz_2)
  inline access assign method infoval_12 var infoval_12
    return (dodlstPhdw->nsazdan_1 +dodlstPhdw->nsazdan_2 +dodlstPhdw->nsazdaz_1 +dodlstPhdw->nsazdaz_2)

  inline method eventHandled(nevent,mp1,mp2,oxbp)

    do case
    case ( 1 = 2 )

    otherwise
      RETURN ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .f.


  method  showGroup

HIDDEN:
  var     cisFirmy
  var     members_fak, members_pen, members_inf

  var     cisSklad, sklPol, cisObj, cislPolob, cisZakazi
  var     faktMnoz
* 2
  var     o_prij_Mnoz, o_sklad_Mj

  method  sumColumn, takeValue
ENDCLASS


method NAK_dodlstPhd_in:init(parent)
  ::drgUsrClass:init(parent)
  *
  (::hd_file  := 'dodlstphdw',::it_file  := 'dodlstpitw')
  ::lnewrec  := .not. (parent:cargo = drgEVENT_EDIT)

  * základní soubory
  ::openfiles(m_files)

  drgDBMS:open('pvphead',,,,,'pvp_head')
  drgDBMS:open('pvpitem',,,,,'pvp_item')

  * pøednastavení z CFG
*  ::lVSYMBOL       := sysconfig('finance:lvsymbol')
  ::SYSTEM_nico    := sysconfig('system:nico'     )
  ::SYSTEM_cdic    := sysconfig('system:cdic'     )
  ::SYSTEM_cpodnik := sysconfig('system:cpodnik'  )
  ::SYSTEM_culice  := sysconfig('system:culice'   )
  ::SYSTEM_cpsc    := sysconfig('system:cpsc'     )
  ::SYSTEM_csidlo  := sysconfig('system:csidlo'   )

  * likvidace
  ::FIN_finance_in:typ_lik := 'poh'

  NAK_dodlstPhd_cpy(self)
return self


METHOD NAk_dodlstPhd_IN:drgDialogStart(drgDialog)
  local  members  := drgDialog:dialogCtrl:members[1]:aMembers, odrg, groups
  local  fst_item := if(::lnewrec,'ctyppohybu','ccisobj'), pa
  *
  local  ardef    := drgDialog:odbrowse[1]:ardef, npos_isSest, ocolumn
  local  acolors  := MIS_COLORS

  ::members_fak := {}
  ::members_pen := {}
  pa := ::members_inf := {}

  aeval(members, {|x| if(ismembervar(x,'groups') .and. .not. isnull(x:groups), ;
                        if(x:groups $ '16,25,34', aadd(pa,x), nil),nil) })

  for x := 1 TO Len(members)
    do case
    case members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
        pa_groups := ListAsArray(members[x]:groups)
        nin       := ascan(pa_groups,'SETFONT')

        members[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            members[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
      endif
    endcase
  next
  *
  ::fin_finance_in:init(drgDialog:udcp,'poh',::it_file +'->csklpol',' položku dodacího listu')

* hd
  ::cmb_typPoh := ::dm:has(::hd_file +'->ctyppohybu'):odrg
  ::cisFirmy   := ::dm:get(::hd_file +'->ncisfirmy' , .F.)

* cenzboz
  ::cisSklad   := ::dm:get(::it_file +'->ccissklad' , .F.)
  ::sklPol     := ::dm:get(::it_file +'->csklpol'   , .F.)

* objitem
  ::cisObj     := ::dm:get(::it_file +'->ccisobj'   , .F.)
  ::cislPolob  := ::dm:get(::it_file +'->ncislPolob', .F.)

* vyrzakit
  ::cisZakazi  := ::dm:get(::it_file +'->cciszakazi', .F.)

* it
  ::faktMnoz    := ::dm:get(::it_file +'->nfaktmnoz' , .F.)
  ::o_prij_Mnoz := ::dm:get('M->prij_Mnoz'           , .F.)
  ::o_sklad_Mj  := ::dm:get('M->sklad_Mj'            , .F.)

  for x := 1 to len(members) step 1
    if members[x]:classname() = 'drgPushButton'
      do case
      case isobject(members[x]:oxbp:cargo) .and. members[x]:oxbp:cargo:classname() = 'drgGet'
        odrg := members[x]:oxbp:cargo

      case members[x]:event = 'memoEdit'
        members[x]:isEdit := .f.
      endcase
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

  if(::lnewrec, ::comboItemSelected(::cmb_typPoh,0),nil)
  ::df:setNextFocus((::hd_file) +'->' +fst_item,, .T. )

   * úprava pro sloucec isSest vazba na CENZBOZ + KLAKUL(cvysPol = csklPol)
   npos_isSest := ascan(ardef, {|x| x.defName = 'm->isSest'})
   ocolumn    :=  ::brow:getColumn(npos_isSest)

   ocolumn:dataAreaLayout[XBPCOL_DA_FRAMELAYOUT]       := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
   ocolumn:dataAreaLayout[XBPCOL_DA_HILITEFRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
   ocolumn:dataAreaLayout[XBPCOL_DA_CELLFRAMELAYOUT]   := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
   ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]             := GraMakeRGBColor( {221,221,221})

   ocolumn:configure()
   ::brow:refreshAll()
RETURN


method NAK_dodlstPhd_in:comboItemSelected(drgcombo,mp2,o)
  local  value := drgcombo:Value, values := drgcombo:values
  local  nin, pa, finTyp, obdobi, cfile
  *
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


method NAK_dodlstPhd_in:tabSelect(oTabPage,tabnum)
  local  tab_Num := oTabPage:tabNumber

  do case
  case(tab_Num =  1)  ;  ::df:setNextFocus( ::it_file +'->ncisfirmy' ,, .t.)
  otherwise
    _clearEventLoop(.t.)
    ::setfocus( if( (::it_file)->(eof()), 2, 0) )
  endcase
return .t.


method NAK_dodlstPhd_in:postValidate(drgVar)
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-')
  local  ok     := .T., changed := drgVAR:changed()
  local  it_sel := 'dodlstpitw->csklpol,dodlstpitw->ccisobjs'
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F., ovar, recNo

  // pro IT
  local  nkoe := ((::hd_file)->nkurzahmen / (::hd_file)->nmnozprep)
  local  ncejprzbz, nfaktMnoz, ncecprzbz
  local                        ncenzakced

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  * hlavièka dokladu
  case(file = ::hd_file)

  * položky dokladu
  case(file = ::it_file)
    * 1
    ncejprzbz  := ::dm:has(::it_file +'->nCEJPRZBZ'  )
    nfaktmnoz  := ::dm:has(::it_file +'->nFAKTMNOZ'  )
    ncecprzbz  := ::dm:has(::it_file +'->nCECPRZBZ'  )
    * 2
    ncenzakcel := ::dm:has(::it_file +'->nCENZAKCEL' )
    ncenzakced := ::dm:has(::it_file +'->nCENZAKCED' )

    * 1
    ncecprzbz:set(ncejprzbz:value * nfaktmnoz:value)

    * 2
    ncenzakcel:set(ncejprzbz:value *  nkoe )
    ::o_prij_Mnoz:set(nfaktmnoz:value)
    ncenzakced:set( ncejprzbz:value * nfaktmnoz:value)
  endcase

  * hlavièku ukládáma na každém prvku
  if( ::hd_file $ name .and. drgVar:changed() .and. ok)
    drgVar:save()
  endif
return ok

*
** sel
method NAK_dodlstPhd_in:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  cf := "ncisfirmy = %%", zkrProdej := '', zkrTypUhr := '', m_filter

  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. ::cisFirmy:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    if firmyfi->(dbseek(firmy->ncisfirmy,,'FIRMYFI1'))
      ::copyfldto_w('firmyfi', ::hd_file)
      zkrProdej := firmyFI->czkrProdej
      zkrTypUhr := firmyFI->czkrTypUod
    endif
    ::copyfldto_w('firmy'  , ::hd_file)
    *
*   objheadw->czkrProdej := zkrProdej
*   objheadw->czkrTypUhr := zkrTypUhr
    *
    c_staty->(dbseek(upper((::hd_file)->czkratStat),,'C_STATY1'))

    ::cisFirmy:set(firmy->ncisfirmy)

    ::fin_finance_in:refresh(::cisFirmy)
    ::dm:refresh()
    ::df:setNextFocus(::hd_file +'->dvystfak',,.t.)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method NAK_dodlstPhd_in:dodlstPhd_z_sel(drgDialog)
  local  odrg   := ::dm:drgDialog:lastXbpInFocus:cargo
  *
  local  value  := ::dm:drgDialog:lastXbpInFocus:value
  local  items  := Lower(drgParseSecond(odrg:name,'>'))
  local  recCnt := 0, showDlg := .f., ok := .f., isOk := .f.
  *
  local  odialog, nexit := drgEVENT_QUIT
  local  iz_file  := if( items = 'csklpol', 'cenzboz', 'objvysit')
  local  iz_pos   := if( items = 'csklpol',         2,          3)

  if isObject(drgDialog)
    showDlg := .t.

  else
    do case
    case( items = 'csklpol' )
      cenzboz->(AdsSetOrder('CENIK01')             , ;
                dbsetscope(SCOPE_BOTH,upper(value)), ;
                dbgotop()                          , ;
                dbeval( {|| recCnt++ })            , ;
                dbgotop()                            )

      showDlg := .not. (recCnt = 1)
           ok :=       (recCnt = 1)
      if(recCnt = 0, cenzboz->(dbclearscope(),dbgotop()), nil)

    case( items = 'ccisobj' )
      objvysit->(AdsSetOrder('OBJVYSI5')           , ;
                dbsetscope(SCOPE_BOTH,upper(value)), ;
                dbgotop()                          , ;
                dbeval( {|| recCnt++ })            , ;
                dbgotop()                            )

      showDlg := .not. (recCnt = 1)
           ok :=       (recCnt = 1)
      if(recCnt = 0, objvysit->(dbclearscope(),dbgotop()), nil)
    endcase
  endif

  if showDlg
     odialog := drgDialog():new('NAK_dodlstPhd_cen_SEL', ::dm:drgDialog)
     odialog:create(,,.T.)
     nexit := odialog:exitState
  endif

  if .not. showDlg .or. (nexit != drgEVENT_QUIT)
    *
    ** pokud pøebírá položku z nabvysit -> musíme napozicovat cenzboz
*    if iz_file = 'nabvysit'
*      cky := upper(nabvysit->ccisSklad) +upper(nabvysit->csklPol)
*      cenZboz->( dbSeek( cky,, 'CENIK03'))
*    endif

    ::takeValue( iz_file, iz_pos)
*    ovar:odrg:refresh( ::lastprocSlev )

    * po pøevzetí zablokujeme csklPol i cnazOdes
    * páè by se to furt kontrolovalo
*    ::enable_or_disable_items(.f.)
  endif

  (iz_file)->(dbclearScope())
return (nexit != drgEVENT_QUIT) .or. ok


method NAK_dodlstPhd_in:overPostLastField(in_spcykl)
  local  o_nazPol1 := ::dm:has(::it_file +'->cnazPol1')
  local  ucet      := ::dm:get(::it_file +'->cucet'   )
  local  ok
  *
  local  lnewRec  := (::state = 2)
  local  intCount := if( lnewRec, ::ordItem() +1, (::it_file)->nintCount )

  default in_spcykl to .f.

* 2 wds - èást kontrol na množství pøi ukádání položky
  if((::it_file)->(eof()),::state := 2,nil)

  * napøed musíme zkontrolovat NS
  ok := ::c_naklst_vld(o_nazPol1,ucet)
  if .not. ok
    return .f.
  endif

//  if .not. ::wds_watch_mnoz( lnewRec, intCount )
    if .not. in_spcykl
      ::df:setNextFocus((::it_file) +'->nfaktmnoz',, .t.)
*-    ::msg:writeMessage('Dispozièní množství je pouze [ NECO ] ...', DRG_MSG_ERROR)
    endif
//    return .f.
//  endif
return ok


method NAK_dodlstPhd_in:postLastField()
  local  isChanged := ::dm:changed()                                  , ;
         file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value
  local  cisZakaz


  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
    if ::state = 2  ;  if .not. empty(file_iv)
                         ::copyfldto_w(file_iv,::it_file)
                       endif

                       cisZakaz := (::it_file)->ccisZakaz
                       ::copyfldto_w(::hd_file,::it_file)
                       (::it_file)->nintcount  := ::ordItem()+1
                       (::it_file)->ccisZakaz  := cisZakaz
    endif

    ::itsave()

    if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
    (::it_file)->(flock())
  endif

  (::it_file)->nhmotnost := ((::it_file)->nfaktmnoz * (::it_file)->nhmotnostJ)
  (::it_file)->nobjem    := ((::it_file)->nfaktmnoz * (::it_file)->nobjemJ   )
  pro_ap_modihd('DODLSTPHDW')

  ::setfocus(::state)
  ::dm:refresh()
return .t.


method NAK_dodlstPhd_IN:postSave()
  local  ok
  *
  local  m_file := upper(left(::hd_file, len(::hd_file)-1))
  local  doklad := (::hd_file)->ndoklad
  *
  local  file_name

  * pøepoèet hlavièky *
  pro_ap_modihd( ::hd_file )

  if ::new_dok
    if .not. fin_range_key(m_file,doklad,,::msg)[1]
      ::df:tabPageManager:toFront(1)
      ::df:setnextfocus(::hd_file +'->ndoklad',,.t.)
      return .f.
    endif
  endif

  ok := NAK_dodlstPhd_wrt(self)

  if(ok .and. ::new_dok)
    dodlstPhdw->(dbclosearea())
    dodlstPitw->(dbclosearea())
    pvpheadw  ->(dbclosearea())
    pvpitemw  ->(dbclosearea())

    NAK_dodlstPhd_cpy(self)

    ::brow:refreshAll()

    setAppFocus(::brow)
    ::dm:refresh()

    ::df:tabPageManager:toFront(1)
    ::df:setnextfocus('dodlstPhdw->ctyppohybu',,.t.)
  endif
return ok


METHOD NAK_dodlstPhd_IN:onSave(lIsCheck,lIsAppend)                              // cmp_AS FIN_FAKVYSITw
  LOCAL  dc     := ::drgDialog:dialogCtrl
  LOCAL  cALIAs := ALIAS(dc:dbArea)
  LOCAL  nKOe   := (DODLSTPHDw ->nKURZAHMEN /DODLSTPHDw ->nMNOZPREP)

  IF !lIsCheck .and. cALIAs = 'DODLSTPITW'
    // doplnìní údajù do položek //
    C_DPH ->(mh_SEEK(DODLSTPITw ->nPROCDPH,2))
    DODLSTPITw ->nKLICDPH := C_DPH ->nKLICDPH
    DODLSTPITw ->nNAPOCET := C_DPH ->nNAPOCET
    // pøepoètem hlavièku //
    pro_ap_modihd('DODLSTPHDW')
  ENDIF
RETURN .T.


method NAK_dodlstPhd_in:postDelete()
  pro_ap_modihd('DODLSTPHDW')
return


method NAK_dodlstPhd_IN:showGroup()
  local  x, odrg, avars, members := ::df:aMembers
  local  panGroup := if((::hd_file)->nfintyp = 5, 'PEN', 'FAK')

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


*
*****************************************************************
METHOD NAK_dodlstPhd_IN:destroy()

  ::drgUsrClass:destroy()
RETURN self


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method NAK_dodlstPhd_in:sumColumn()
  local  kcsBdobj := kcsZdobj := 0, x, value

  objit_iw->(dbgotop())
  do while .not. objit_iw ->(Eof())
    if objit_iw->_delrec <> '9'
      ( kcsBdobj += objit_iw->nkcsBdobj, kcsZdobj += objit_iw->nkcsZdobj)
    endif
    objit_iw->(dbskip())
  enddo

  for x := 6 to 7 step 1
    value := if(x = 6,str(kcsBdobj), str(kcsZdobj))

    ::brow:getColumn(x):Footing:hide()
    ::brow:getColumn(x):Footing:setCell(1,value)
    ::brow:getColumn(x):Footing:show()
  next
return .t.


method NAK_dodlstPhd_in:takeValue(iz_file,iz_pos)
  local  x, pos, value, items, mname, par, iz_recs := (iz_file)->(recno())
*                     dodlstPit,          cenzboz,       objvysit
*
  local  pa := {  {      'cskp',               '' ,              '' }, ;
                  { 'ccissklad',      'ccissklad' ,     'ccissklad' }, ;
                  {  'ncislodl',                0 ,               0 }, ;
                  { 'cciszakaz',               '' ,              '' }, ;
                  {'cciszakazi',               '' ,              '' }, ;
                  {   'ccisobj',               '' ,       'ccisobj' }, ;
                  {'nciszalfak',                0 ,               0 }, ;
                  {'ncispenfak',                0 ,               0 }, ;
                  {   'csklpol',        'csklpol' ,       'csklpol' }, ;
                  {   'cnazzbo',        'cnazzbo' ,       'cnazzbo' }, ;
                  { 'nfaktmnoz',                0 , ':favst_mnoD/3' }, ;
                  {'czkratjedn',     'czkratjedn' ,    'czkratjedn' }, ;
                  { 'ncenazakl',      'ncenaSzbo' ,               0 }, ;
                  {  'nprocdph',   ':dodlp_dph/5' ,               0 }, ;
                  { 'ncejprzbz',      'ncenaSzbo' ,     'ncenazakl' }, ;
                  { 'nhodnslev',                0 ,     'nhodnslev' }, ;
                  { 'nprocslev',                0 ,     'nprocslev' }, ;
                  { 'ncejprkdz',      'ncenamzbo' ,               0 }, ;
                  { 'ncecprkbz',                0 ,               0 }, ;
                  { 'ncelkslev',                0 ,     'ncelkslev' }, ;
                  { 'ncecprkbz',                0 ,               0 }, ;
                  { 'ncecprkdz',                0 ,     'nkcszdobj' }, ;
                  { 'cdoplntxt',               '' ,     'cdoplntxt' }, ;
                  {     'cucet',               '' ,              '' }, ;
                  {  'cnazpol1',               '' ,              '' }, ;
                  {  'cnazpol2',               '' ,              '' }, ;
                  {  'cnazpol3',               '' ,              '' }, ;
                  {  'cnazpol4',               '' ,              '' }, ;
                  {  'cnazpol5',               '' ,              '' }, ;
                  {  'cnazpol6',               '' ,              '' }, ;
                  {  'ncountdl',                0 ,               0 }, ;
                  {'ncislPolob',                0 ,    'ncislPolob' }, ;
                  {'ncelpenfak',                  ,                 }, ;
                  { 'dsplatfak',                  ,                 }, ;
                  {'dposuhrfak',                  ,                 }, ;
                  {'nuhrcelfaz',                  ,                 }, ;
                  {'ncenpencel',                  ,                 }, ;
                  {  'npen_odb',                  ,                 }, ;
                  { 'ncenaSzbo',      'ncenaSzbo' ,               0 }, ;
                  {'nhmotnostj',      'nhmotnost' ,    'nhmotnostj' }, ;
                  {   'nobjemj',         'nobjem' ,       'nobjemj' }  }


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

   ::o_sklad_Mj:set( (iz_file)->czkratjedn )

//   ::objvst_pc()

   if( IsObject(ovar := ::dm:has(::it_file +'->cfile_iv')), ovar:set(iz_file), nil)
   if( IsObject(ovar := ::dm:has(::it_file +'->nrecs_iv')), ovar:set(iz_recs), nil)

   ::df:setNextFocus( ::it_file +'->nfaktmnoz',,.T.)
return




*/

/*
method pro_objhead_in:objvst_pc()
  local filtr, m_filtr, procento := 0  //100
  *
  local cisFirmy := ::cisFirmy:value, zkrTypUhr := ::zkrTypUhr:value, datObj := ::datObj:value
  local cisSklad := ::cisSklad:value, sklPol    := ::sklPol:value, ;
        zboziKat := ::zboziKat:value
  *
  local m_cky    := upper(cisSklad) +upper(sklPol)

  filtr := "ntypProCen = 1 .and. "                                  + ;
           "  (ncisFirmy = %% .or. ncisFirmy = 0) .and. "           + ;
           "( (ccisSklad = '%%' .and. csklPol = '%%') .or. nzboziKat = %% .or. czkrTypUhr = '%%')"

  m_filtr := format( filtr, {cisFirmy, cisSklad, sklPol, zboziKat, zkrTypUhr})

  procenho->(ads_setAof(m_filtr),dbgoTop())
  cenprodc->(dbseek( m_cky,,'CENPROD1'))

  ::cenaZakl:set(cenprodc->ncenaPzbo)


  if .not. procenho->(eof())
    procenho->(dbsetFilter( { || is_datumOk(datObj) }))

    do case
    case( procenho->(dbseek(m_cky   ,,'PROCENHO09')))
       procento := procenho->nprocento

    case( procenho->(dbseek(zboziKat,,'PROCENHO10')))
       procento := procenho->nprocento

*    case( procenho->(dbseek( upper(zkrTypUhr),,'PROCENHO11')) .and. is_datumOk(datObj))
*       procento := procenho->nprocento
    endcase

    ::procSlev:set(procento)
    ::hodnSlev:set((cenprodc->ncenaPzbo * procento) / 100)
  endif
return

static function is_datumOk(datum)
  local  ok :=  empty(procenho->dplatnyOD) .or. ;
                (procenho->dplatnyOD <= datum .and. procenho->dplatnyDO >= datum)
return ok
*/
**
*