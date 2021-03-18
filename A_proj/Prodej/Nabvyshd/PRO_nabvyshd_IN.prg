#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
*
#include "..\Asystem++\Asystem++.ch"

#define  m_files   {'typdokl' ,'c_typoh'                                  , ;
                    'c_dph'   ,'c_meny'  ,'c_staty' , 'kurzit'            , ;
                    'firmy'   ,'firmyfi' ,'firmyuc' , 'nakpol' , 'vyrpol' , ;
                    'cenZb_rp','cenzboz' ,'cenprodc','procenfi', 'procenho' }



*  NABÍDKY VYSTAVENÉ
** CLASS for PRO_nabvyshd_IN ***************************************************
CLASS PRO_nabvyshd_IN FROM drgUsrClass, FIN_finance_IN, SYS_ARES_forAll
  exported:
  var     lNEWrec,  cmb_typPoh
  var     typ_dokl, is_ban, hd_file, it_file, in_file, varSym
  var     existPROCEN, existVYRPOL

  * new
  var     system_nico, system_cdic, system_cpodnik, system_culice, system_cpsc, system_csidlo

  method  init, drgDialogStart, drgDialogEnd
  method  postValidate, comboItemSelected, tabSelect
  method  postLastField, postSave, postAppend, postDelete, postEscape
  method  fir_firmy_sel, osb_osoby_sel, KusTree, prepocetCENy
  method  nabvyshd_z_sel, vyr_vyrpol_sel

  * nabvysit
  inline access assign method procDph() var procDph
    c_dph->(dbseek(if(IsNull(::klicDph), 0,::klicDph:value)))
    return c_dph->nprocdph

  inline access assign method vyrpol_Pol(par)
    local cretVal := ''

    if ::in_file = 'vyrpol'
      do case
      case( par = 1 )  ; cretVal := vyrpol->ccisZakaz
      case( par = 2 )  ; cretVal := vyrpol->ccisZakaz
      case( par = 3 )  ; cretval := vyrpol->cvyrPol
      case( par = 4 )  ; cretVal := vyrpol->ccisVyk
      endcase
    endif
    return cretVal


  * objitem
  inline access assign method stav_objitemw() var stav_objitemw
    local retVal := 0

    do case
    case(objitemw->nmnozplodb = 0                    )  ;  retVal := 301
    case(objitemw->nmnozplodb >= objitemw->nmnozobodb)  ;  retVal := 302
    case(objitemw->nmnozplodb <  objitemw->nmnozobodb)  ;  retVal := 303
    endcase
    return retVal

   inline access assign method typ_objitem() var typ_objitem
    local ky := if(IsNull(::cisSklad), '', ::cisSklad:value +::sklPol:value), isVyr := .F.

    nakpol->(dbseek(upper(ky),,'NAKPOL3'))
    isVyr := (nakpol->ckodtpv = 'R ' .or. nakpol->ckodtpv == 'P ')
    return if(isVyr, 'výrobek', 'zboží')

  *
  **
  inline method int_cislNabidky(in_wrt, in_copy)
    local  m_filter := "ncisfirmy = %%", filter

    default in_wrt  to .f. , ;
            in_copy to .f.

    filter := format( m_filter, {nabvyshdw->ncisFirmy})
    nabhd_iw->(AdsSetOrder('NABVYSH3'), ads_setAof(filter), dbGoBottom())

    nabvyshdw->ncisOdes   := nabhd_iw->ncisOdes +1
    nabvyshdw->cnazOdes   := left(firmy->cnazev,4)       +'-' + ;
                             strzero(firmy->ncisfirmy,5) +'/' + ;
                             strzero(nabvyshdw->ncisOdes,4)

    if .not. in_wrt
//      objheadw->mpoznobj   := objhd_iw->mpoznobj
    endif

    if .not. in_copy
      ::dm:get(::hd_file +'->cnazOdes', .F.):set(nabvyshdw->cnazOdes)
    endif
    nabhd_iw->(ads_clearAof())
  return
  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)
      if( ::state = 2, ::postEscape(), nil )
      ::state := 0

      ::enable_or_disable_items(.f.)

      if(isobject(::brow), ::brow:hilite(), nil)
      SetAppFocus(::brow)
      ::dm:refresh()
      RETURN .F.

    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()

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

    * tohle asi nepotøebujeme
    case nEvent = xbeP_Keyboard .and. mp1 = xbeK_ESC .and. oXbp:ClassName() = 'XbpBrowse'
      ::postEscape()

    case nEvent = xbeP_Close
      ::postEscape(.t.)

    otherwise
      RETURN ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .F.

 HIDDEN:
   * ok
   var     cisFirmy, datOdes, datPlat, zkrTypUhr
   var     zboziKat, cisSklad, sklPol, vyrPol, cisVyk, cislObint, klicDph
   var     ofile_iv, orecs_iv
   *
   var     itemForIns, itemSelIns

   var     cenaZakl,  hodnSlev, procSlev
   var     mnozOdes
   method  sumColumn, takeValue, objvst_pc
   VAR     zaklMena, title, cisFak, tabNum

   *
   inline method enable_or_disable_items(lenable)
     if lenable
       (::sklPol:odrg:isEdit   := .t., ::sklPol:odrg:oxbp:enable() )
       (::vyrPol:odrg:isEdit   := .t., ::vyrPol:odrg:oxbp:enable() )
       (::cisVyk:odrg:isEdit   := .t., ::cisVyk:odrg:oxbp:enable() )

       if ::dm:get( ::itemForIns, .f. ):odrg:isEdit
         ::one_edt := ::itemForIns

         if ::itemSelIns = 'sel'
           postAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has(::itemForIns):oDrg:oXbp )
         endif
       endif
       ::df:setNextFocus(::one_edt,, .T. )

     else
       ( ::sklPol:odrg:isEdit   := .F., ::sklPol:odrg:oxbp:disable() )
       ( ::vyrPol:odrg:isEdit   := .F., ::vyrPol:odrg:oxbp:disable() )
       ( ::cisVyk:odrg:isEdit   := .F., ::cisVyk:odrg:oxbp:disable() )
     endif
//      SetAppFocus(::brow)
//      ::dm:refresh()
   return self

  *  recyklaèní polatek ke skladové položce
  ** hokus pokus asi jen pro Elektrosvit
  inline method rp_saveRecPopl()
    local  it_file := ::it_file
    local  iz_file := 'cenzboz', iz_pos := 2
    *
    local  mnozParent := (it_file)->nmnoznOdes
    local  cky        := (it_file)->ccissklad +(it_file)->csklpol
    local  nvaz_Rp    := (it_file)->nvaz_Rp, recNo
    local  drgVar     := ::dm:has(it_file +'->nmnoznOdes')
    *
    local  akt_recNo  := (it_file)->( recNo())
    local  akt_order  := (it_file)->nintcount
    local  new_order  := ::ordItem()+1

    do case
    case ::state = 2             // nová položka

      if cenZb_rp->( dbseek( upper(cky),, 'CENZBRP1' ))
        if cenZboz->( dbseek( cenZb_rp->nyCENZBOZ,, 'ID' ))

          ::dm:refreshAndSetEmpty( it_file )

          cenZboz->( dbseek( cenZb_rp->nyCENZBOZ,, 'ID' ))
          ::takeValue( iz_file, iz_pos )

          drgVar       := ::dm:has(it_file +'->nmnoznOdes')
          ( drgVar:value := mnozParent, drgvar:refresh() )

          if ::postValidate(drgVar)
            (::it_file)->nvaz_rp := new_order

            addrec(::it_file)

            ::copyfldto_w(iz_file , ::it_file)
            ::copyfldto_w(::hd_file,::it_file)
                         (::it_file)->nintcount := ::ordItem()+1
                         (::it_file)->nvaz_rp   := akt_order

            ::itsave()
            if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
            (::it_file)->(flock())
          endif
        endif
      endif

    case nvaz_Rp <> 0           // oprava položky s vazbou CEN <-> Rp

      if nabit_iw->( dbseek( strZero(nvaz_Rp,5),, 'NABVYSI_1'))
        recNo := nabit_iw->( recNo())

        (it_file)->( dbgoTo(recNo))

        ::refresh(drgVar)
        drgVar:set(mnozParent)
        drgVar:value := drgVar:prevValue := drgVar:initValue := mnozParent

        if( ::postValidate(drgVar), ::itsave(), nil )

        (it_file)->( dbgoTo(akt_recNo))
        ::brow:refreshAll()
      endif
    endcase
  return .t.

ENDCLASS


method pro_nabvyshd_in:init(parent)
  *
  (::hd_file := 'nabvyshdw', ::it_file := 'nabvysitw')
  *
  ::typ_dokl := 'xx'
  ::is_ban   := .F.  // (typ_dokl = 'ban')
  ::lNEWrec  := .not. (parent:cargo = drgEVENT_EDIT)
  ::zaklMena := SysConfig('Finance:cZaklMena')
  ::tabNum   := 1

  * základní soubory
  ::openfiles(m_files)
  drgDBMS:open('nabvyshd',,,,,'nabhd_iw')

  * pøednastavení z CFG
  ::SYSTEM_nico    := sysconfig('system:nico'     )
  ::SYSTEM_cdic    := sysconfig('system:cdic'     )
  ::SYSTEM_cpodnik := sysconfig('system:cpodnik'  )
  ::SYSTEM_culice  := sysconfig('system:culice'   )
  ::SYSTEM_cpsc    := sysconfig('system:cpsc'     )
  ::SYSTEM_csidlo  := sysconfig('system:csidlo'   )
  *
  ** pro kopii nabídky potøebujeme metody tøídy
  ** data si nachystáme sami
  if isnil(parent:cargo_usr)
    pro_nabvyshd_cpy(self)
  endif
return self


method pro_nabvyshd_in:drgDialogStart(drgDialog)
  local  que_del := ' ' +'nabídky vystavené'   //::title
  *
  local  members  := drgDialog:oForm:aMembers, aedits := {}
  local  fst_item := if(::lNewrec,'ctyppohybu','ccisobj')
  *
  local  acolors  := MIS_COLORS, pa_groups, nin
  local  c_PRO_nabvys
  local  pa_itemForIns := {'csklpol','cvyrpol', 'ccisvyk' }
  local  cv_prg_filter


  * pøidán nový parametr PRO_nabvys
  * 1 - csklPol, cvyrPol, ccisVyk
  *     po ins aktivuje pøíslušný prvek, pokud je k dispozici, implicitnì csklPol
  * 2 - SEL
  *     po INS automaticky rozevøe nabídku pro SEL dialog
  * 1 a 2 paramert jsou svázané
  **
  ::itemForIns := ::it_file +'->csklPol'
  ::itemSelIns := ''

  if isCharacter( c_PRO_nabvys := sysConfig('prodej:PRO_nabvys'))
    pa := asize( listAsArray( strTran(c_PRO_nabvys,' ', '')), 3)
    aeval( pa, {|x,n| pa[n] := isNull(x,'') })

    * 1
    if( nin := ascan( pa_itemForIns, {|x| x == lower(pa[1]) })) <> 0
      ::itemForIns := ::it_file +'->' +lower(pa[1])

      * 2
      if lower(pa[2]) = 'sel'
        ::itemSelIns := 'sel'
      endif
    endif
  endif


  for x := 1 to LEN(members) step 1
    if members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
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
    endif
  next

  ::FIN_finance_in:init(drgDialog,::typ_dokl,::it_file +'->csklpol',que_del,.t.)

  * propojka pro ARES
  ::sys_ARES_forAll:init(drgDialog)

  * hd
  ::cmb_typPoh := ::dm:has(::hd_file +'->ctyppohybu'):odrg
  ::cisFirmy   := ::dm:get(::hd_file +'->ncisfirmy' , .F.)
  ::datOdes    := ::dm:get(::hd_file +'->ddatOdes'  , .F.)
  ::datPlat    := ::dm:get(::hd_file +'->ddatPlat'  , .F.)
  ::zkrTypUhr  := ::dm:get(::hd_file +'->czkrtypuhr', .F.)
  * it
  ::zboziKat   := ::dm:get(::it_file +'->nzboziKat', .F.)
  ::cisSklad   := ::dm:get(::it_file +'->ccissklad', .F.)

  ::sklPol     := ::dm:get(::it_file +'->csklpol'  , .F.)
  ::vyrPol     := ::dm:get(::it_file +'->cvyrpol'  , .F.)
  ::cisVyk     := ::dm:get(::it_file +'->ccisvyk'  , .F.)

  ::klicDph    := ::dm:get(::it_file +'->nklicdph' , .F.)
  * pro take_value
  ::cenaZakl   := ::dm:get(::it_file +'->ncenaZakl' , .F.)
  ::hodnSlev   := ::dm:get(::it_file +'->nhodnSlev' , .F.)
  ::procSlev   := ::dm:get(::it_file +'->nprocSlev' , .F.)
  *
  ::mnozOdes   := ::dm:has('nabvysitw->nmnoznOdes')
  ::ofile_iv   := ::dm:get(::it_file +'->cfile_iv' , .F.)
  ::orecs_iv   := ::dm:get(::it_file +'->nrecs_iv' , .F.)

  *
  if( ::lNEWrec, ::comboItemSelected(::cmb_typPoh), nil)
  if( ::lNEWrec, nil, ::df:setNextFocus((::hd_file) +'->' +fst_item,, .T. ))
  *
  *
  ** pokud je dialog z firmy_scr -> pro_nabvyshd_scr
  ** naplníme v INS ncisFirmy a zakážeme zmìnit
  if isMemberVar( drgDialog:parent:UDCP, 'cv_prg_filter', VAR_ASSIGN_PROTECTED )
     if .not. empty( drgDialog:parent:UDCP:cv_prg_filter )
       *
       cv_prg_filter := drgDialog:parent:UDCP:cv_prg_filter
       firmy->( ads_setAof( cv_prg_filter), dbgoTop() )

       if ::lnewRec
         ( ::cisFirmy:odrg:isEdit := .f., ::cisFirmy:odrg:oxbp:disable() )
           ::cisFirmy:set( firmy->ncisFirmy )
           ::fir_firmy_sel()
       endif
     endif
  endif

  ::sumColumn()
return self


method pro_nabvyshd_in:drgDialogEnd(drgDialog)
  nabvysitw ->(DbCloseArea())
*   vyrpolw   ->(DbCloseArea())
   if( select('vyrpolw') <> 0, vyrpolw->( dbCloseArea()), nil )
    nabhd_iw  ->(DbCloseArea())
     nabit_iw  ->(DbCloseArea())
return


METHOD PRO_nabvyshd_IN:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-')
  local  ok     := .T., changed := drgVAR:changed(), subtxt
  local  it_sel := 'nabvysitw->csklpol,nabvysitw->cvyrpol,nabvysitw->ccidvyk'
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F., ovar, recNo
  local  nmnoznOdes, nprocDph , ;
         ncenaZakl , nhodnSlev, nproSlev, ncenjedZak, ncenZakCel, ncenZakCeD


  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


  do case
* hlavièka dokladu
  case(file = ::hd_file)
    do case
    CASE(name = ::hd_file +'->ndoklad')
      ok := fin_range_key('NABVYSHD',value,,::msg)[1]

    case(name = ::hd_file +'->ncisfirmy' .and. mp1 = xbeK_RETURN)
      ok := ::fir_firmy_sel()

    case(name = ::hd_file +'->czkratstat' .or. name = ::hd_file +'->czkratmenz') .and. changed
      ::fin_kurzit(drgvar,(::hd_file)->ddatOdes)

    case(name = ::hd_file +'->cnazpracov')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)

        ovar := ::dm:get(::hd_file +'->mpoznnab',.f.)
        PostAppEvent(xbeP_Keyboard,xbeK_TAB,,ovar:odrg:oxbp)

        ovar := ::dm:get(::hd_file +'->mpoznamka',.f.)
        PostAppEvent(xbeP_Keyboard,xbeK_TAB,,ovar:odrg:oxbp)
      endif

    case(name = ::hd_file +'->ccastermin')
      // c_casTer->ndnyLAST
      if empty(::datPlat:value)
        ::datPlat:set( ::datOdes:value + c_casTer->ndnyLAST )
      endif
    endcase

  * položky dokladu
  case(file = ::it_file)
    nmnoznOdes := ::dm:has('nabvysitw->nmnoznOdes')
    nprocDph   := ::dm:has('nabvysitw->nprocDph'  )

    ncenaZakl  := ::dm:has('nabvysitw->ncenazakl' )
    nhodnSlev  := ::dm:has('nabvysitw->nhodnslev' )
    nprocslev  := ::dm:has('nabvysitw->nprocslev' )

    ncenJedZak := ::dm:has('nabvysitw->ncenJedZak')
    ncenZakCel := ::dm:has('nabvysitw->ncenZakCel')
    ncenZakCeD := ::dm:has('nabvysitw->ncenZakCeD')

    do case
    case(name $ it_sel .and. changed)
      ok    := ::nabvyshd_z_sel()

    case(name = ::it_file +'->ncenazakl' .and. changed)
      nhodnslev:set((ncenazakl:value * nprocslev:value)/100)

    case(name = ::it_file +'->nhodnslev' .and. changed)
      nprocslev:set((nhodnslev:value / ncenazakl:value)*100)
      if( nprocslev:value > 99.9, (nhodnslev:set(0), nprocslev:set(0)), nil)

    case(name = ::it_file +'->nprocslev')
      if changed
        nhodnslev:set((ncenazakl:value * nprocslev:value)/100)
      endif

    case(name = ::it_file +'->cdoplntxt')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif

    endcase

    * výpoèet ncenJedZak
    ncenJedZak:set( round(ncenazakl:value -(ncenazakl:value * nprocslev:value)/100,2))

    * výpoèet ncenZakCel / ncenZakCeD
    ncenZakCel:set( nmnoznOdes:value  * ncenJedZak:value )
    ncenZakCeD:set( ncenZakCel:value + int( ncenZakCel:value * nprocDph:value/100))
  endcase

  if( changed .and. ok, ::dm:refresh(), nil)

* hlavièku ukládáma na každém prvku
  if( ::hd_file $ name .and. drgVar:changed() .and. ok)
    drgVar:save()

    * výpoèet nprocslev na objhead
    (::hd_file)->nprocslev := (::hd_file)->nprocslfao +(::hd_file)->nprocslhot
    ::dm:set(::hd_file +'->nprocslev', (::hd_file)->nprocslev)
  endif
RETURN ok


method pro_nabvyshd_in:fir_firmy_sel(drgDialog)
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
      ::copyfldto_w('firmyfi','nabvyshdw')
      zkrProdej := firmyFI->czkrProdej
      zkrTypUhr := firmyFI->czkrTypUod
    endif
    ::copyfldto_w('firmy'  ,'nabvyshdw')

    ::int_cislNabidky()
    *
    nabvyshdw->czkrTypUhr := zkrTypUhr
    *
    c_staty->(dbSeek(upper((::hd_file)->czkratStat,,'C_STATY1')))
    c_meny->(dbseek(upper(c_staty->czkratMeny,,'C_MENY1')))

    if ((::hd_file)->nkurzahmen +(::hd_file)->nmnozprep = 0 .or. ;
       empty((::hd_file)->czkratmenz)                       .or. ;
       (c_meny->czkratmeny <> (::hd_file)->czkratmenz)           )

      kurzit->(mh_seek(upper(c_meny->czkratmeny),2,,.t.))

      kurzit->( AdsSetOrder(2), dbsetScope(SCOPE_BOTH, UPPER(c_meny->czkratMeny)))
      cKy := upper(c_meny->czkratMeny) +dtos((::hd_file)->ddatOdes)
      kurzit->(dbSeek(cKy, .T.))
      If( kurzit->nkurzStred = 0, kurzit->(dbgoBottom()), NIL )

      (::hd_file)->czkratmenz := c_meny->czkratmeny
      (::hd_file)->nkurzahmen := kurzit->nkurzstred
      (::hd_file)->nmnozprep  := kurzit->nmnozprep

      kurzit->(dbclearScope())
    endif

    ::fin_finance_in:refresh(::cisFirmy)
    ::dm:refresh()
    ::df:setNextFocus(::hd_file +'->ddatdoodb',,.t.)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_nabvyshd_in:osb_osoby_sel(drgDialog)
  local  odialog, nexit,  odrg := drgDialog:lastXbpInFocus:cargo

  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit != drgEVENT_QUIT
    ::dm:set(odrg:name, osoby->cosoba)
  endif
return .t.


method pro_nabvyshd_in:comboItemSelected(drgcombo,mp2,o)
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


method pro_nabvyshd_in:tabSelect(oTabPage,tabnum)
  local it_file := ::brow:cargo:cfile
  local tab_Num := oTabPage:tabNumber

  ::tabNum := tabnum
  do case
  case(tab_Num =  1)  ;  ::df:setNextFocus('objheadw->ncisfirmy' ,, .t.)
  otherwise
    _clearEventLoop(.t.)
    ::setfocus( if( (it_file)->(eof()), 2, 0) )
  endcase
return .t.


method pro_nabvyshd_in:nabvyshd_z_sel(drgDialog)
  local  odrg   := ::dm:drgDialog:lastXbpInFocus:cargo
  *
  local  value  := ::dm:drgDialog:lastXbpInFocus:value
  local  items  := Lower(drgParseSecond(odrg:name,'>'))
  local  recCnt := 0, showDlg := .f., ok := .f., isOk := .f.
  *
  local  odialog, nexit := drgEVENT_QUIT
  *
  ::in_file  := if( items = 'csklpol', 'cenzboz', 'vyrpol')


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

    case( items = 'cvyrpol' )
        vyrpol->(AdsSetOrder('VYRPOL4')             , ;
                 dbsetscope(SCOPE_BOTH,upper(value)), ;
                 dbgotop()                          , ;
                 dbeval( {|| recCnt++ })            , ;
                 dbgotop()                            )

        showDlg := .not. (recCnt = 1)
             ok :=       (recCnt = 1)
        if(recCnt = 0, vyrpol->(dbclearscope(),dbgotop()), nil)

    case( items = 'ccisvyk' )
        vyrpol->(AdsSetOrder('VYRPOL3')             , ;
                 dbsetscope(SCOPE_BOTH,upper(value)), ;
                 dbgotop()                          , ;
                 dbeval( {|| recCnt++ })            , ;
                 dbgotop()                            )

        showDlg := .not. (recCnt = 1)
             ok :=       (recCnt = 1)
        if(recCnt = 0, vyrpol->(dbclearscope(),dbgotop()), nil)
    endcase
  endif

  if showDlg
     odialog := drgDialog():new('PRO_nabvyshd_cen_SEL', ::dm:drgDialog)
     odialog:create(,,.T.)
     nexit := odialog:exitState
  endif

  if .not. showDlg .or. (nexit != drgEVENT_QUIT)
    isOk := if( ::in_file = 'vyrpol', ::vyr_vyrpol_sel(), .t.)
    if( isOk, ::takeValue('cenzboz',2), nil )
  endif

  (::in_file)->(dbclearScope())
  *
  if ::in_file = 'vyrpol'
    ::cisVyk:oDrg:isEdit := empty( ::cisVyk:oDrg:oVar:value)
  endif
return (nexit != drgEVENT_QUIT) .or. ok

*
** vazba na VYRPOL *************************************************************
method pro_nabvyshd_in:vyr_vyrpol_sel()
  local  cky       := upper(vyrpol->ccisSklad) + upper(vyrpol->csklPol)
  local  recNo, ok := .f.
  local  ccilZakaz := 'NAV-' + strZero(nabvyshdw->ncisFirmy, 5) + '-' ;
                             + strZero(nabvyshdw->ndoklad  ,10) + '-' ;
                             + strzero(::ordItem()+1       , 5)
  *
  local  cInfo     := 'Promiòte prosím,'
  local  ord_vyrpo := vyrpol ->(ordSetFocus())

  if cenZboz->( dbSeek( cky,, 'CENIK03'))
    mh_CopyFld( 'VYRPOL' , 'VYRPOLw', .t.)
    *
    recNo := VyrPOL->( RecNo())
    VyrPOL->( ads_ClearAOF()) // 12.1.2012
    cKy := strZero(nabvyshdw->ndoklad,10) +strZero(if( ::state = 2, ::ordItem()+1, nabvysitw->nintCount ),5)
    if .not. vyrpol->( dbseek( cKy,,'VYRPOL10'))

      mh_CopyFld( 'VYRPOLw', 'VYRPOL' , .t.,,, .t.)
      VyrPOL->ccisZakaz  := ccilZakaz
      VyrPOL->nCisNabVys := nabvyshdw->nDoklad
      VyrPOL->nIntCount  := ::ordItem()+1
      *
      recNo := VyrPOL->( RecNo())
      VYR_VyrPOL_cpy( NIL, VyrPOLw->cCisZakaz, VyrPOLw->cVyrPol, VyrPOLw->nVarCis ,;
                           cCilZakaz         , VyrPOL->cVyrPol , VyrPOL->nVarCis  ,;
                      .T., .T.,.F. )

    endif
    VyrPOL->( dbGoTo(recNo))
    ok := .t.
  else
    cInfo += 'vyrábìná položka < '                 + ;
              allTrim(vyrpol->cvyrPol) +' >' +CRLF + ;
            'neexistuje v ceníku zboží < '         + ;
              allTrim(vyrpol->ccisSklad) +'_' +allTrim(vyrpol->csklPol) +' >' +CRLF

    fin_info_box( cInfo, XBPMB_CRITICAL )
  endif

  vyrpol ->(ordSetFocus( ord_vyrpo ))
return ok

* Strukt. kusovník
********************************************************************************
method pro_nabvyshd_in:kusTree()
  local  cKy, oDialog, cFilter := VyrPOL->( ads_GetAOF())
  *
  local  intCount := if( ::state = 2, ::ordItem()+1, nabvysitw->nintCount )

  cKy := strZero(nabvyshdw->ndoklad,10) +strZero(intCount,5)
  VyrPOL->( ads_ClearAOF())

  if vyrpol->( dbseek( cKy,,'VYRPOL10'))
    DRGDIALOG FORM 'VYR_KusTREE_SCR, 0' PARENT ::dm:drgDialog MODAL DESTROY
  endif

*  if( empty( cFilter), nil, VyrPOL->( ads_SetAOF( cFilter)))
  cenzboz->(dbClearScope())
return self

/*
method pro_nabvyshd_in:KusTree()
  Local oDialog, nChoice, lPROCEN, lVYRPOL
*  Local lPROCEN := ::existPROCEN, lVYRPOL := ::existVYRPOL

  if .not. ::lNewREC
    cKey := Upper(NabVysITw->cCisSklad) + Upper(NabVysITw->cSklPol)
    ::existPROCEN := PROCENHO->( dbSeek( cKey,,'PROCENHO09'))
    cKey := STRZERO(NabVysITw->nDoklad,10) + STRZERO(NabVysITw->nIntCount,5)
    ::existVYRPOL := VYRPOL->( dbSeek( cKey,,'VYRPOL10'))
  endif

  lPROCEN := ::existPROCEN
  lVYRPOL := ::existVYRPOL

  if lPROCEN .and. lVYRPOL
    nChoice := AlertBOX( , "Zvolte mechanismus získání prodejní ceny pro nabídku !" ,;
                          { "z ~Prodejního ceníku", "z ~Kalkulace plánové" }  ,;
                          XBPSTATIC_SYSICON_ICONQUESTION,;
                          'Zvolte možnost'    )
    lPROCEN := ( nChoice = 1 )
    lVYRPOL := ( nChoice = 2 )
  endif
  *
  if lPROCEN
      drgMsgBox(drgNLS:msg('Mechanismus je rozpracován ...'))
  elseif lVYRPOL
    DRGDIALOG FORM 'VYR_KusTREE_SCR, 0' PARENT ::dm:drgDialog MODAL DESTROY
  endif

  cenzboz->(dbClearScope())
RETURN self
*/

method pro_nabvyshd_in:postLastField(drgVar)
  local  isChanged := ::dm:changed()                                  , ;
         file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value         , ;
         ok        := .t.

  if ok
    * ukládáme na posledním PRVKU *
    if((::it_file)->(eof()),::state := 2,nil)

    if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
      if ::state = 2  ;  if .not. empty(file_iv)
                           (file_iv)->(dbgoto(recs_iv))
                           ::copyfldto_w(file_iv,::it_file)
                         endif
                         ::copyfldto_w(::hd_file,::it_file)
                         *
                         (::it_file)->nintCount := ::ordItem()+1
      endif

      ::itsave()
      *
      if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
      (::it_file)->(flock())
    endif

    (::it_file)->ncelkslev := ((::it_file)->nhodnSlev  * (::it_file)->nmnozNOdes)
    (::it_file)->nhmotnost := ((::it_file)->nmnozNOdes * (::it_file)->nhmotnostJ)
    (::it_file)->nobjem    := ((::it_file)->nmnozNOdes * (::it_file)->nobjemJ   )

// zatím ne 22.1.2020
*   ::rp_saveRecPopl()

    pro_nabvyshd_cmp()

    ::sumColumn()
    ::setfocus(::state)
    ::dm:refresh()
  endif
return ok


method PRO_nabvyshd_IN:postAppend()
  ::enable_or_disable_items(.t.)
  ::tabNum := 2
  ::state  := 2
return .t.


method pro_nabvyshd_in:postSave()
  local ok
  *
  local  m_file := upper(left(::hd_file, len(::hd_file)-1))
  local  doklad := (::hd_file)->ndoklad

  if ::lnewRec
    if .not. fin_range_key(m_file,doklad,,::msg)[1]
      ::df:tabPageManager:toFront(1)
      ::df:setnextfocus(::hd_file +'->ndoklad',,.t.)
      return .f.
    endif
  endif

  pro_nabvyshd_cmp()

  ok := pro_nabvyshd_wrt_inTrans(self)

  if(ok .and. ::new_dok)
    nabvyshdw ->(dbclosearea())
    nabvysitw ->(dbclosearea())
    nabit_iw  ->(dbclosearea())

    pro_nabvyshd_cpy(self)

    ::brow:refreshAll()

    setAppFocus(::brow)
    ::dm:refresh()

    ::df:tabPageManager:toFront(1)

    ::df:setnextfocus('nabvyshdw->ctyppohybu',,.t.)
    ::comboItemSelected(::cmb_typPoh)
  endif
return ok


method PRO_nabvyshd_IN:postDelete()
  local  nvaz_Rp   := (::it_file)->nvaz_Rp
  local  cky       := (::it_file)->ccissklad +(::it_file)->csklpol, recNo
  *
  * musíme zrušit vazbu jen pro vyrpol - ale pouze pro položku nabídky
  *
  if ::ofile_iv:value = 'vyrpol' .and. nabvysitw->_nrecor = 0
    vyrpol->( dbgoTO( ::orecs_iv:value))
    ModiFILES()
  endif
  *
  if nvaz_Rp <> 0
    if cenZboz->( dbseek( upper(cky),,'CENIK03'))
      if nabit_iw->( dbseek( strZero(nvaz_Rp,5),, 'NABVYSI_1'))
         recNo := nabit_iw->( recNo())

         (::it_file)->( dbgoTo(recNo))
         if( cenZboz->ctypSKLpol = 'Y ', (::it_file)->nvaz_Rp := 0  , ;
                                         (::it_file)->_delRec := '9'  )
         ::brow:panHome()
      endif
    endif
  endif

  ::sumColumn()
  ::brow:refreshAll()
return .t.


*
** tahle metoda má dvì roviny
*  1 - ESC/X/ALT_F4       zavírá doklad neukládá žádné zmìny  - isClose .t.
*  2 - INS - VYRPOL - ESC musí se zrušit vytvoøené vazby      - isClose NIL
method pro_nabvyshd_in:postEscape( isClose )

  default isClose to .f.
  if((::it_file)->(eof()),::state := 2,nil)

  if isClose
    nabvysitw->(dbgoTop())
    do while .not. nabvysitw->(eof())
      if nabvysitw->cfile_iv = 'vyrpol' .and. nabvysitw->_nrecor = 0
        vyrpol->(dbgoTo( nabvysitw->nrecs_iv ))
        ModiFILES()
      endif
      nabvysitw->(dbskip())
    enddo
  else
    if ::ofile_iv:value = 'vyrpol' .and. ::state = 2
      ModiFILES()
    endif
  endif
return .t.

*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method pro_nabvyshd_in:sumColumn()
  local  cenZakCel := cenZakCed := 0, x, value, npos
  *
  local  pa    := { 'ncenzakcel', 'ncenzakced' }
  local  ardef := ::brow:cargo:ardef

  nabit_iw->( dbgotop())

  do while .not. nabit_iw ->(Eof())
    if nabit_iw->_delrec <> '9'
      ( cenZakCel += nabit_iw->ncenZakCel, cenZakCeD += nabit_iw->ncenZakCeD)
    endif
    nabit_iw->(dbskip())
  enddo

  for x := 1 to len( pa) step 1
    value := if( x = 1, cenZakCel, cenZakCed )

    if ( npos := ascan( ardef, { |ait| pa[x] $ lower( ait[2]) })) <> 0

      ::brow:getColumn(npos):Footing:hide()
      ::brow:getColumn(npos):Footing:setCell(1, value)
      ::brow:getColumn(npos):Footing:show()
    endif
  next
return .t.


method pro_nabvyshd_in:takeValue(iz_file,iz_pos)
  local  x, pos, value, items, mname, par, iz_recs := (iz_file)->(recno())
*         nabvysitw,                cenzboz,
*
  local  pa := { ;
  {      'ccissklad',            'ccissklad' }, ;
  {      'ccisZakaz',         ':vyrpol_Pol/1'}, ;
  {     'ccisZakazi',         ':vyrpol_Pol/2'}, ;
  {        'csklPol',              'csklpol' }, ;
  {        'cvyrPol',         ':vyrpol_Pol/3'}, ;
  {        'ccisVyk',         ':vyrpol_Pol/4'}, ;
  {        'cnazzbo',              'cnazzbo' }, ;
  {      'ddatdoodb', 'nabvyshdw->ddatdoodb' }, ;
  {     'czkratjedn',           'czkratjedn' }, ;
  {       'nklicdph',             'nklicdph' }, ;
  {       'nprocDph',             ':procDph' }, ;
  {      'ncenazakl',            'ncenapzbo' }, ;
  {     'nprocslfao', 'nabvyshdw->nprocslfao'}, ;
  {     'nprocslhot', 'nabvyshdw->nprocslhot'}, ;
  {      'nprocslev', 'nabvyshdw->nprocslev' }, ;
  {      'nzboziKat',            'nzboziKat' }, ;
  {     'nhmotnostj',            'nhmotnost' }, ;
  {        'nobjemj',               'nobjem' }  }

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

   ::objvst_pc()

   if ::in_file = 'vyrpol'
     ( iz_file := 'vyrpol', iz_res := vyrpol->(recNo()) )
   endif

   if( IsObject(ovar := ::dm:has(::it_file +'->cfile_iv')), ovar:set(iz_file), nil)
   if( IsObject(ovar := ::dm:has(::it_file +'->nrecs_iv')), ovar:set(iz_recs), nil)

   ::df:setNextFocus('nabvysitw->nmnoznOdes',,.T.)
return


/*
filtr := "ntypProCen = 9 .and. "                                  + ;
           "  (ncisFirmy = %% .or. ncisFirmy = 0) .and. "           + ;
           "( (ccisSklad = '%%' .and. csklPol = '%%') .or. nzboziKat = %% .or. contains(czkrTypUhr,'%%') )"


*/


method pro_nabvyshd_in:objvst_pc()
  local filtr, m_filtr, procento := 0  //100
  *
  local cisFirmy := ::cisFirmy:value, zkrTypUhr := ::zkrTypUhr:value, datOdes := ::datOdes:value
  local cisSklad := ::cisSklad:value, sklPol    := ::sklPol:value, ;
        zboziKat := ::zboziKat:value
  *
  local m_cky    := upper(cisSklad) +upper(sklPol)
  *
  local fi_filtr := "ncisFirmy = %%", mfi_filtr, cky, pa_procenho := {}

  *
  ** procenfi
  mfi_filtr := format( fi_filtr, {cisFirmy})
  procenfi->(ads_setAof(mfi_filtr),dbgoTop())

  do while .not. procenfi->( eof())
    cky := strZero(procenfi->ntypPROcen,5) +strZero(procenfi->ncisPROcen,10)

    if procenho->( dbseek(cky,,'PROCENHO08'))
      aadd( pa_procenho, procenho->sID )
    endif
    procenfi->( dbskip())
  enddo
  procenfi->(ads_clearAof())
  ** procenfi
  *
  ** procenho
  filtr := "ntypProCen = 1 .and. "                                  + ;
           "  (ncisFirmy = %% .or. ncisFirmy = 0) .and. "           + ;
           "( (ccisSklad = '%%' .and. csklPol = '%%') .or. nzboziKat = %% .or. czkrTypUhr = '%%')"

  m_filtr := format( filtr, {cisFirmy, cisSklad, sklPol, zboziKat, zkrTypUhr})
  procenho->(ads_setAof(m_filtr),dbgoTop())

  cenprodc->(dbseek( m_cky,,'CENPROD1'))
  ::cenaZakl:set(cenprodc->ncenaPzbo)

  if .not. procenho->(eof())
    procenho->(dbsetFilter( { || is_datumOk(datOdes, pa_procenho) }))

    do case
    case( procenho->(dbseek(m_cky   ,,'PROCENHO09')))
       procento := procenho->nprocento

    case( procenho->(dbseek(zboziKat,,'PROCENHO10')))
       procento := procenho->nprocento
    endcase

    ::procSlev:set(procento)
    ::hodnSlev:set((cenprodc->ncenaPzbo * procento) / 100)

    procenho->(dbclearFilter())
  endif

  procenho->(ads_clearAof())
return

static function is_datumOk(datum,pa_procenho)
  local  lok_procenho

  lok_procenho := if( len(pa_procenho) = 0, .t., ;
                  if( ascan(pa_procenho, procenho->sID) = 0, .f., .t. ))

  lok_procenho :=  lok_procenho .and. (empty(procenho->dplatnyOD) .or. ;
                                      (procenho->dplatnyOD <= datum .and. procenho->dplatnyDO >= datum))

return lok_procenho

/*
static function is_datumOk(datum,pa_procenho)
  local  ok :=  empty(procenho->dplatnyOD) .or. ;
                (procenho->dplatnyOD <= datum .and. procenho->dplatnyDO >= datum)
return ok
*/

**
*
method pro_nabvyshd_in:prepocetCENy()
  local KalkCMP
  local x, cKey, nRec := nabvysitw->( recno()), lOk := .T.
  local nProcInt := 5, nCenaInt, oMoment
  *
  oMoment := SYS_MOMENT( 'Probíhá cenový pøepoèet nabídky')
  *
  KalkCMP             := VYR_KalkHrCMP_CRD():new( ::dc:drgDialog)
  KalkCMP:lKalkPLAN   := .t.
  KalkCMP:cFile       := 'VYRPOL'
  KalkCMP:lKalkSetAKT := .F.
  KalkCMP:lKalkToCen  := .F.
  KalkCMP:nKalkCount  := 0
  KalkCMP:fromNabVys  := .T.
  *
  KALKULw->cDruhCeny := '5 '    // '5 ' = nabídková cena
  *
  nabvysitw->( dbGoTop())
  do while ! nabvysitw->( eof())
*    cKey := upper( nabvysitw->cCisSklad) + upper(nabvysitw->cSklPol)
*    VyrPOL->( dbSeek( cKey,, 'VYRPOL9' ))
     cKey := STRZERO(nabvysitw->nDoklad,10) +STRZERO(nabvysitw->nIntCount,5)
     VyrPOL->( dbSeek( cKey,, 'VYRPOL10' ))
    *
    KalkCMP:KalkCMP_PL_One('')   // ( 'NAV')
    *
    nCenaInt := ( nabvysitw->nCenaZakl / 100 ) * nProcInt
    lOk := ( ( nabvysitw->nCenaZakl + nCenaInt ) <= KALKUL->nCenKalkP ) .or. ;
           ( ( nabvysitw->nCenaZakl - nCenaInt ) >= KALKUL->nCenKalkP )
    if lOk
      nabvysitw->nCenaZakl := KALKUL->nCenKalkP
    endif
    *
    nabvysitw->( dbSkip())
  enddo
  nabvysitw->( dbGoTo( nRec))
  *
  oMoment:destroy()

return

*
Function ModiFILES()
  local  cKey := upper(VyrPOL->cCisZakaz) + upper(VyrPOL->cVyrPOL), cTag
  *
  drgDBMS:open('KALKUL')
  drgDBMS:open('Kusov')
  drgDBMS:open('PolOPER')
  *
  if KALKUL->( dbSeek( cKey,, 'KALKUL1' ))
    DelRec('KALKUL')
  endif
  * Zruší se vazby na nižší položky
  cTag := Kusov->( AdsSetOrder( 4))
  KUSOV->( mh_SetScope( cKEY))
  DO WHILE !Kusov->( EOF())
    DelREC( 'Kusov')
    Kusov->( dbSKIP())
  ENDDO
  KUSOV->( mh_ClrScope())
  * Zruší se operace definované  k vyrábìné položce
  cTag := PolOPER->( AdsSetOrder( 1))
  PolOPER->( mh_SetScope( cKEY))
  DO WHILE PolOPER->( dbSEEK( cKey))
    DelREC( 'PolOPER')
  ENDDO
  * Zruší se VyrPOL
  DelRec('VyrPOL')
return nil