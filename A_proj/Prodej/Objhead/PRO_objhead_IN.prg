#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dmlb.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
//
#include "..\Asystem++\Asystem++.ch"

#define  m_files   {'typdokl' ,'c_typoh'                        , ;
                    'c_dph'   ,'c_meny'  ,'c_staty' , 'kurzit'  , ;
                    'firmy'   ,'firmyfi' ,'firmyuc' , 'nakpol'  , ;
                    'cenZb_rp','cenzboz' ,'cenprodc','procenho', 'nabvysit'  }



*  PØIJATÉ OBJEDNÁVKY       *
** CLASS for PRO_objhead_IN ****************************************************
CLASS PRO_objhead_IN FROM drgUsrClass, FIN_finance_IN, WDS, SYS_ARES_forAll
  exported:
  var     lNEWrec,  cmb_typPoh
  var     typ_dokl, is_ban, hd_file, it_file, in_file, varSym
  var     typReODB, ldat_HD_to_IT

  * new
  var     system_nico, system_cdic, system_cpodnik, system_culice, system_cpsc, system_csidlo

  * new - možnost opravy dokladu z pro_objitem_scr
  var     isparent_mainScr

  method  init, drgDialogStart, drgDialogEnd
  method  postValidate, comboItemSelected, tabSelect
  method  postLastField, postSave, postAppend, postDelete
  method  fir_firmy_sel, skl_cenzboz_sel, osb_osoby_sel
  method  objhead_z_sel

  method  takeValue

  *
  ** po uložení ojednávky, lze zavolat poøízení FA
  method FIN_fakVyshd_in
  var    set_fakVyshd_inOn

  inline method set_fakvyshd_in()
    ::set_fakVyshd_inOn := 1
    postAppEvent(drgEVENT_ACTION, drgEVENT_SAVE,'2',::dm:drgDialog:lastXbpInFocus)
    return self


  * objitem
  * textové info položky na kartì
  inline access assign method cenzboz_kDis(co) var cenzboz_kDis
    local cky, retVal := 0, lok := .f., oxbp

    if isObject(::cisSklad) .and. isObject(::sklPol)
      cky  := ::cisSklad:get() + ::sklPol:get()

      if( lok := cenzboz->(dbseek(upper(cky),,'CENIK03')))
        * jen pro cenníkové položky *
        if( upper(cenzboz->cpolcen) = 'C', retval := max(0, ::wds_cenzboz_kDis), lok := .f.)
      endif

      if isobject(::o_cenzboz_kDis)
        if(lok, ::o_cenzboz_kDis:odrg:oxbp:show(), ::o_cenzboz_kDis:odrg:oxbp:hide())
      endif
    endif
    return retVal

  inline access assign method lastprocSlev() var lastprocSlev
    local  procSlev := 0, cky

    if isObject(::cisSklad) .and. isObject(::sklPol)
      cky  := strZero(objheadw->ncisFirmy,  5) + ;
              upper(::cisSklad:get()         ) + ;
              upper(::sklPol:get()           )

      objit_lpc ->(dbseek( cky,, 'OBJITE26'))
      procSlev := objit_lpc->nprocSlev
    endif
    return procSlev

  inline access assign method stav_objitemw() var stav_objitemw
    local retVal := 0

    do case
    case(objitemw->nmnozplodb = 0                    )  ;  retVal := 301   // MIS_ICON_ERR
    case(objitemw->nmnozplodb >= objitemw->nmnozobodb)  ;  retVal := 302   // MIS_BOOK
    case(objitemw->nmnozplodb <  objitemw->nmnozobodb)  ;  retVal := 303   // MIS_BOOKOPEN
    endcase
    return retVal

  inline access assign method stav_Svydw() var stav_Svydw
    local retVal := 0
    local stav_Svyd := objitemw->nstav_Svyd

    do case
    case( stav_Svyd = 1 )                     ;  retVal := 555
    case( stav_Svyd = 2 .or. stav_Svyd = 3 )  ;  retVal := 556
    endcase
    return retVal

*  inline access assign method datObj_hd var datObj_hd
*    return objheadw->ddatObj

  inline access assign method typ_objitem() var typ_objitem
    local ky := if(IsNull(::cisSklad), '', ::cisSklad:value +::sklPol:value), isVyr := .F.

    nakpol->(dbseek(upper(ky),,'NAKPOL3'))
    isVyr := (nakpol->ckodtpv = 'R ' .or. nakpol->ckodtpv == 'P ')
    return if(isVyr, 'výrobek', 'zboží')

  inline access assign method procDph() var procDph
    c_dph->(dbseek(if(IsNull(::klicDph), 0,::klicDph:value)))
    return c_dph->nprocdph

  inline access assign method datObj_it() var datObj_it
    return if( ::lNEWrec, objheadw->ddatObj, date())

  inline access assign method datdoOdb_it() var datdoOdb_it
    return if( ::lNEWrec, objheadw->ddatdoodb, ctod( '  .  .  '))

  inline access assign method datodvVyr_it() var datodvVyr_it
    return if( ::lNEWrec, objheadw->ddatodvvyr, ctod( '  .  .  '))

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
  inline method int_cislObint(in_wrt)
    local  m_filter := "ncisfirmy = %%", filter

    default in_wrt to .f.

    filter := format( m_filter, {objheadw->ncisFirmy})
    objhd_iw->(AdsSetOrder('OBJHEAD1'), ads_setAof(filter), dbGoBottom())

    objheadw->ncislObint := objhd_iw->ncislobint +1
    objheadw->ccislObint := left(firmy->cnazev,4)       +'-' + ;
                            strzero(firmy->ncisfirmy,5) +'/' + ;
                            strzero(objheadw->ndoklad,10)

    if .not. in_wrt
      *
      ** požadavek 29.6.2015 - poznámku dle ddatOBJ
      objhd_iw->( AdsSetOrder('OBJHEAD18'), dbgoTop() )

      objheadw->mpoznobj   := objhd_iw->mpoznobj
    endif

    ::dm:get(::hd_file +'->ccislObint', .F.):set(objheadw->ccislobint)
    objhd_iw->(ads_clearAof())
  return

  inline method show_KDis(citem, xval)
    local ovar := ::dm:has(citem)

    if( isObject(ovar), ovar:set(xval), nil)
  return
  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local cky := upper( objitemW->ccisSklad) +upper(objitemw->csklPol)

    *
    ::wds_watch_time()
    *

    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)

      if( ::state = 2, ::esc_focustobrow(), nil )
      ::state := 0

      cenZboz->(dbseek( cky,,'CENIK03'))

      ::enable_or_disable_items(.f.)

// vot problema      if(isobject(::brow), ::brow:hilite(), nil)
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

    otherwise
      RETURN ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .F.

 HIDDEN:
   * ok
   var     cisFirmy, datObj, zkrTypUhr, zkratMenZ
   var     zboziKat, cisSklad, sklPol, cislObint, klicDph, datObj_hd
   var                         o_cenzboz_kDis
   var                         nazOdes

   var     cenaZakl,  hodnSlev, procSlev
   var     mnozObOdb, mnozPoOdb, mnozVpInt, mnPotVyr, mnozPdOdb, mnozPlOdb
   *
   var     itemForIns, itemSelIns

   method  sumColumn, objvst_pc, mnozValidate

   VAR     zaklMena, title, cisFak
   var     odialog_cen, oBtn_set_fakVyshd_in
   var     members

   var     is_ext_obj


   inline method enable_or_disable_items(lenable)
     if lenable
       (::sklPol:odrg:isEdit   := .t., ::sklPol:odrg:oxbp:enable() )
       (::nazOdes:odrg:isEdit  := .t., ::nazOdes:odrg:oxbp:enable())
     else
       ( ::sklPol:odrg:isEdit   := .F., ::sklPol:odrg:oxbp:disable() )
       ( ::nazOdes:odrg:isEdit  := .F., ::nazOdes:odrg:oxbp:disable())
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
    local  mnozParent := (it_file)->nmnozOBodb
    local  cky        := (it_file)->ccissklad +(it_file)->csklpol
    local  nvaz_Rp    := (it_file)->nvaz_Rp, recNo
    local  drgVar     := ::dm:has(it_file +'->nmnozOBodb')
    *
    local  akt_recNo  := (it_file)->( recNo())
    local  akt_order  := (it_file)->ncislPOLob
    local  new_order  := ::ordItem()+1

    do case
    case ::state = 2             // nová položka

      if cenZb_rp->( dbseek( upper(cky),, 'CENZBRP1' ))
        if cenZboz->( dbseek( cenZb_rp->nyCENZBOZ,, 'ID' ))

          ::dm:refreshAndSetEmpty( it_file )

          cenZboz->( dbseek( cenZb_rp->nyCENZBOZ,, 'ID' ))
          ::takeValue( iz_file, iz_pos )

          drgVar       := ::dm:has(it_file +'->nmnozOBodb')
          ( drgVar:value := mnozParent, drgvar:refresh() )

          if ::postValidate(drgVar)
            (::it_file)->nvaz_rp := new_order

            addrec(::it_file)

            ::copyfldto_w(iz_file , ::it_file)
            ::copyfldto_w(::hd_file,::it_file)
                         (::it_file)->ncislPOLob := ::ordItem()+1
                         (::it_file)->nvaz_rp    := akt_order

            ::itsave()
            if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
            (::it_file)->(flock())
          endif
        endif
      endif

    case nvaz_Rp <> 0           // oprava položky s vazbou CEN <-> Rp

      if objit_iw->( dbseek( strZero(nvaz_Rp,5),, 'OBJITEM_1'))
        recNo := objit_iw->( recNo())

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



/*
   inline method copy_And_appen()
     local  x, ok := .t., vars := ::dm:vars, drgVar, in_file

     for x := 1 to ::dm:vars:size() step 1
       drgVar := ::dm:vars:getNth(x)
       if isblock(drgVar:block)
         in_file := lower( left( drgVar:name, at( '-', drgVar:name)  -1))
         if ( in_file = 'objitemw' .and. isMemberVar(drgVar:odrg, 'isEdit'))
           xvalue := eval( drgVar:block )
         endif
       endif
     next
     PostAppEvent(drgEVENT_APPEND,,,::brow)
     return self
*/

ENDCLASS


method pro_objhead_in:init(parent)

  ::drgUsrClass:init(parent)
  *
  (::hd_file := 'objheadw', ::it_file := 'objitemw')
  *
  ::typ_dokl     := 'xx'
  ::is_ban       := .F.  // (typ_dokl = 'ban')
  ::lNEWrec      := .not. (parent:cargo = drgEVENT_EDIT)
  ::zaklMena     := SysConfig('Finance:cZaklMena')
  ::is_ext_obj   := .f.


  ::set_fakVyshd_inOn := 0
  ::isparent_mainScr  := .t.

  * základní soubory
  ::openfiles(m_files)
  drgDBMS:open('objitem',,,,,'objit_lpc')
  drgDBMS:open('objhead',,,,,'objhd_iw' )

  * pøednastavení z CFG
  ::SYSTEM_nico    := sysconfig('system:nico'     )
  ::SYSTEM_cdic    := sysconfig('system:cdic'     )
  ::SYSTEM_cpodnik := sysconfig('system:cpodnik'  )
  ::SYSTEM_culice  := sysconfig('system:culice'   )
  ::SYSTEM_cpsc    := sysconfig('system:cpsc'     )
  ::SYSTEM_csidlo  := sysconfig('system:csidlo'   )
  *

  if lower(parent:parent:formName) = 'pro_objitem_scr'
    * by se muselo
    * odložit/ pøípadnì zrušit AOF
    * odložit/ pøípadnì zrušit SCOPE

    ::isparent_mainScr := .f.
  endif

  *
  ** požadavek automatického vytvoøení OBJEDNÁVKY z NABVYSHD
  cargo_usr    := if( ismemberVar( parent, 'cargo_usr'), isnull( parent:cargo_usr, ''), '' )
  ::is_ext_obj := ( lower(cargo_usr) = 'ext_obj')

  pro_objhead_cpy(self)
return self


method pro_objhead_in:drgDialogStart(drgDialog)
  local  que_del := ' ' +'objednávky pøijaté'   //::title
  *
  local  members  := drgDialog:oForm:aMembers, aedits := {}
  local  fst_item := if(::lNewrec,'ctyppohybu','ccisobj')
  *
  local  acolors  := MIS_COLORS
  local  c_PRO_objhea, typReODB
  local  pa_itemForIns := {'csklpol','cnazodes'}


  * pøidán nový parametr PRO_objhea
  * 1- csklPol / cnazOdes
  *     po INS naktivuje požadovaný prvek, pokud je k dispozici, imlicitnì csklPol
  * 2 - SEL
  *     po INS automaticky rozevøe nabídku pro SEL dialog
  * 1 a 2 parametr jsou svázané
  *
  * 4 - 0/1 naplnit dat z HDw do ITw 0 - ne/ 1 - vždy
  **
  ::itemForIns    := ::it_file +'->csklPol'
  ::itemSelIns    := ''
  ::ldat_HD_to_IT := .f.

  if isCharacter( c_PRO_objhea := sysConfig('prodej:PRO_objhea'))
    pa := asize( listAsArray( strTran(c_PRO_objhea,' ', '')), 4)
    aeval( pa, {|x,n| pa[n] := isNull(x,'') })

    * 1
    if( nin := ascan( pa_itemForIns, {|x| x == lower(pa[2]) })) <> 0
      ::itemForIns := ::it_file +'->' +lower(pa[2])

      * 2
      if lower(pa[3]) = 'sel'
        ::itemSelIns := 'sel'
      endif
    endif

    ::ldat_HD_to_IT := ( pa[4] = '1' )
  endif

  * další nový CFG parametr ntypReODB
  * default 0 - standartní rezeraèní mechnismus
  *         1 - hlídá nmnozPoODB = cenzboz.nmnozDzbo
  *           - pøi ukádání objdenávky zmìní hodnotu nmnozPoODB min( cenzboz.nmnozDzbo, nmnozPoODB)

  ::typReODB := 0

  if isNumber( typReODB := sysConfig( 'prodej:ntypReODB' ))
    ::typReODB := typReODB
  endif

  ::members  := drgDialog:oForm:aMembers

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

  members := drgDialog:oActionBar:members

  for x := 1 TO LEN(members) step 1
    odrg := members[x]

    do case
    case odrg:className() = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case lower(members[x]:event) = 'set_fakVyshd_in'  ;  ::oBtn_set_fakVyshd_in := members[x]
        endcase
      endif
    endcase
  next

  ::FIN_finance_in:init(drgDialog,::typ_dokl,::it_file +'->csklpol',que_del,.t.)

  * propojka pro ARES
  ::sys_ARES_forAll:init(drgDialog)


  * hd
  ::cmb_typPoh     := ::dm:has(::hd_file +'->ctyppohybu'):odrg
  ::cisFirmy       := ::dm:get(::hd_file +'->ncisfirmy' , .F.)
  ::datObj         := ::dm:get(::hd_file +'->ddatObj'   , .F.)
  ::zkrTypUhr      := ::dm:get(::hd_file +'->czkrtypuhr', .F.)
  ::zkratMenZ      := ::dm:get(::hd_file +'->czkratMenZ', .F.)
  * it
  ::datObj_hd      := ::dm:get('M->datobj_hd'          , .F.)
  ::o_cenzboz_kDis := ::dm:has('M->cenzboz_kDis' )
  ::zboziKat       := ::dm:get(::it_file +'->nzboziKat', .F.)
  ::cisSklad       := ::dm:get(::it_file +'->ccissklad', .F.)
  ::sklPol         := ::dm:get(::it_file +'->csklpol'  , .F.)
  ::nazOdes        := ::dm:get(::it_file +'->cnazodes' , .F.)
  ::klicDph        := ::dm:get(::it_file +'->nklicdph' , .F.)
  * pro take_value
  ::cenaZakl       := ::dm:get(::it_file +'->ncenaZakl' , .F.)
  ::hodnSlev       := ::dm:get(::it_file +'->nhodnSlev' , .F.)
  ::procSlev       := ::dm:get(::it_file +'->nprocSlev' , .F.)
  *
  ::mnozObOdb      := ::dm:has('objitemw->nmnozobodb')
  ::mnozPoOdb      := ::dm:has('objitemw->nmnozpoodb')
  ::mnozVpInt      := ::dm:has('objitemw->nmnozvpint')
  ::mnPotVyr       := ::dm:has('objitemw->nmnpotvyr' )
  ::mnozPdOdb      := ::dm:has('objitemw->nmnozpdodb')
  ::mnozPlOdb      := ::dm:has('objitemw->nmnozplodb')
  *
  ** na xbpCombo vypneme visuální styl, je to blbì vidìt na focusu
  ::cmb_typPoh:oxbp:useVisualStyle := .f.

  if( ::lNEWrec, ::comboItemSelected(::cmb_typPoh), nil)
  if( ::lNEWrec, nil, ::df:setNextFocus((::hd_file) +'->' +fst_item,, .F. ))
  *
//  ::sumColumn()

  ::wds_connect(self)
  ::cwds_itmnoz     := 'nmnozPOodb'
  ::cwds_itmnoz_org := '_mnozPOodb'

  ::sumColumn()

  * datum objednávky z hlavièky na kartì položek
  ::datobj_hd:set( (::hd_file)->ddatobj )

return if( ::is_ext_obj, .f., self )


method pro_objhead_in:drgDialogEnd(drgDialog)
  objitemw ->(DbCloseArea())
   objhd_iw ->(DbCloseArea())
    objit_iw ->(DbCloseArea())

    if( isObject( ::odialog_cen), ::odialog_cen:destroy(), nil )
    ::wds_disconnect()
return


METHOD PRO_objhead_IN:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-')
  local  ok     := .T., changed := drgVAR:changed(), subtxt
  local  it_sel := 'objitemw->csklpol,objitemw->cnazodes'
  *
  local  it_cmp := 'objitemw->nmnozobodb,objitemw->nmnozpoodb,objitemw->nmnozvpint,' + ;
                   'objitemw->nmnpotvyr,objitemw->nmnozpdodb'
  *
  local  nevent := mp1 := mp2 := oxbp := nil, isF4 := .F., ovar, recNo, cky
  local  nmnozobodb, nmnozpoodb, nmnozvpint, nmnpotvyr , ;
         nmnozpdodb, ncenazakl , nhodnslev , nprocslev , ;
         ncenadlodb, nmnozplodb, nprocslfao, nprocslhot, nprocslmno, ;
         nkcsbdobj , nkcszdobj

  local  nevent_n := mp1_n := mp2_n := oxbp_n := nil


  * F4
  nevent  := LastAppEvent(@mp1,@mp2,@oxbp)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  nevent_n  := nextAppEvent(@mp1_n,@mp2_n,@oxbp_n)

  do case
* hlavièka dokladu
  case(file = ::hd_file)
    do case
    CASE(name = ::hd_file +'->ndoklad')
      ok := fin_range_key('OBJHEAD',value,,::msg)[1]

    case(name = ::hd_file +'->ncisfirmy' .and. mp1 = xbeK_RETURN)
      ok := ::fir_firmy_sel()

    case(name = ::hd_file +'->czkratstat' .or. name = ::hd_file +'->czkratmenz') .and. changed
      ::fin_kurzit(drgvar,(::hd_file)->ddatobj)

    case(name = ::hd_file +'->cnazpracov')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)

        ovar := ::dm:get(::hd_file +'->mpoznobj',.f.)
        PostAppEvent(xbeP_Keyboard,xbeK_TAB,,ovar:odrg:oxbp)

        ovar := ::dm:get(::hd_file +'->mpoznamka',.f.)
        PostAppEvent(xbeP_Keyboard,xbeK_TAB,,ovar:odrg:oxbp)
      endif
    endcase

  * položky dokladu
  case(file = ::it_file)
    nmnozobodb := ::dm:has('objitemw->nmnozobodb')   // 12
    nmnozpoodb := ::dm:has('objitemw->nmnozpoodb')   // 13
    nmnozvpint := ::dm:has('objitemw->nmnozvpint')   // 14
    nmnpotvyr  := ::dm:has('objitemw->nmnpotvyr' )   // 15
    nmnozpdodb := ::dm:has('objitemw->nmnozpdodb')   // 16
    ncenazakl  := ::dm:has('objitemw->ncenazakl' )   // 17
    nhodnslev  := ::dm:has('objitemw->nhodnslev' )   // 18
    nprocslev  := ::dm:has('objitemw->nprocslev' )   // 19
    ncenadlodb := ::dm:has('objitemw->ncenadlodb')   // 20
**    nmnpotvyr  := ::dm:has('objitemw->nmnpotvyr' ) // 24
    nmnozplodb := ::dm:has('objitemw->nmnozplodb')   // 25
    nprocslfao := ::dm:has('objitemw->nprocslfao')   // 26
    nprocslhot := ::dm:has('objitemw->nprocslhot')   // 27
    nprocslmno := ::dm:has('objitemw->nprocslmno')   // 28
    nkcsbdobj  := ::dm:has('objitemw->nkcsbdobj' )
    nkcszdobj  := ::dm:has('objitemw->nkcszdobj' )

    do case
*    case(name $ it_sel .and. changed)
*      ok := ::objhead_z_sel( if( empty(value), ::drgDialog, nil ))

    ** pùvodní varianta ELSvit ale pojede z nabídek vystavených, AGRIKOL - nesmí být chyba
    case(name = ::it_file +'->csklpol' )
      do case
      case nevent = xbeP_SetInputFocus .or. mp1 = xbeK_RETURN .or. mp1 = xbeK_TAB
        ok := ::objhead_z_sel( if( empty(value), ::drgDialog, nil ) )
       endcase

    case(name = ::it_file +'->cnazodes')
      do case
      case nevent = xbeP_SetInputFocus .or. mp1 = xbeK_RETURN .or. mp1 = xbeK_TAB
        ok := ::objhead_z_sel( if( empty(value), ::drgDialog, nil ) )
      endcase

    case(name $ it_cmp)
      do case
      case(name = ::it_file +'->nmnozobodb' .and. changed)

*        nprocslmno:set(::slevyMnoz())
*-        nprocslev:set(nprocslfao:value +nprocslhot:value +nprocslmno:value)
*-        nhodnslev:set((ncenazakl:value * nprocslev:value)/100)

      case(name = ::it_file +'->nmnozpoodb' )
        if ( nevent = xbeP_SetInputFocus .or. mp1 = xbeK_RETURN .or. mp1 = xbeK_TAB .and. ::typReODB = 1)

          cky := ::dm:get(::it_file +'->ccissklad') +::dm:get(::it_file +'->csklpol')

          if cenzboz->(dbseek(upper(cky),,'CENIK03'))
            if upper(cenzboz->cpolcen) = 'C'

              if value > ::wds_cenzboz_kDis
                ::msg:writeMessage('Dispozièní množství je pouze [' +str( ::wds_cenzboz_kDis) +' ...', DRG_MSG_ERROR)
                ok := .f.
              endif

            endif
          endif
        endif
      endcase

    case(name = ::it_file +'->ncenazakl' .and. changed)
      nhodnslev:set((ncenazakl:value * nprocslev:value)/100)

    case(name = ::it_file +'->nhodnslev' .and. changed)
      nprocslev:set((nhodnslev:value / ncenazakl:value)*100)
      if( nprocslev:value > 99.9, (nhodnslev:set(0), nprocslev:set(0)), nil)


    case(name $ it_sel .and. changed)
      ok := ::fakturovat_z_sel(drgVar:drgDialog)

    case(name = ::it_file +'->nprocslev')
      if changed
        nhodnslev:set((ncenazakl:value * nprocslev:value)/100)
      endif

    case(name = ::it_file +'->cdoplntxt')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif

    endcase

    * výpocet ncenadlodb
    ncenadlodb:set( round(ncenazakl:value -(ncenazakl:value * nprocslev:value)/100,2))

    * výpoèet nkcsbdobj / nkcszdobj
    nkcsbdobj:set(nmnozobodb:value * ncenadlodb:value)
    nkcszdobj:set(nkcsbdobj:value +int(nkcsbdobj:value * ::procDph/100))
  endcase

  if( changed .and. ok, ::dm:refresh(), nil)

* hlavièku ukládáma na každém prvku
  if( ::hd_file $ name .and. drgVar:changed() .and. ok)
    drgVar:save()

    * datum objednávky z hlavièky na kartì položek
    ::datobj_hd:set( (::hd_file)->ddatobj )

    * výpoèet nprocslev na objhead
    (::hd_file)->nprocslev := (::hd_file)->nprocslfao +(::hd_file)->nprocslhot
    ::dm:set(::hd_file +'->nprocslev', (::hd_file)->nprocslev)
  endif
RETURN ok


method pro_objhead_in:fir_firmy_sel(drgDialog)
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
      ::copyfldto_w('firmyfi','objheadw')
      zkrProdej := firmyFI->czkrProdej
      zkrTypUhr := firmyFI->czkrTypUod
    endif
    ::copyfldto_w('firmy'  ,'objheadw')

    ::int_cislObint()
    *
    objheadw->czkrProdej := zkrProdej
    objheadw->czkrTypUhr := zkrTypUhr
    *
    c_staty->(dbseek(upper(objheadw->czkratStat),,'C_STATY1'))

    ::cisFirmy:set(firmy->ncisfirmy)

    ::fin_finance_in:refresh(::cisFirmy)
    ::dm:refresh()
    ::df:setNextFocus(::hd_file +'->ddatdoodb',,.t.)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_objhead_in:osb_osoby_sel(drgDialog)
  local  odialog, nexit,  odrg := drgDialog:lastXbpInFocus:cargo

  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit != drgEVENT_QUIT
    ::dm:set(odrg:name, osoby->cosoba)
  endif
return .t.


method pro_objhead_in:comboItemSelected(drgcombo,mp2,o)
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


method pro_objhead_in:tabSelect(oTabPage,tabnum)
  local it_file := ::brow:cargo:cfile
  local tab_Num := oTabPage:tabNumber

  do case
  case(tab_Num =  1)  ;  ::df:setNextFocus('objheadw->ncisfirmy' ,, .t.)
  otherwise
    _clearEventLoop(.t.)
    ::setfocus( if( (it_file)->(eof()), 2, 0) )
  endcase
return .t.


method pro_objhead_in:objhead_z_sel(drgDialog)
  local  odrg   := ::dm:drgDialog:lastXbpInFocus:cargo
  *
  local  value  := ::dm:drgDialog:lastXbpInFocus:value
  local  items  := Lower(drgParseSecond(odrg:name,'>'))
  local  recCnt := 0, showDlg := .f., ok := .f., isOk := .f.
  *
  local  odialog, nexit := drgEVENT_QUIT
  local  ovar     := ::dm:get('M->lastprocSlev' , .F.)

  local  iz_file  := if( items = 'csklpol', 'cenzboz', 'nabvysit')
  local  iz_pos   := if( items = 'csklpol',         2,          3)
  *

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

    case( items = 'cnazodes' )
      nabvysit->(AdsSetOrder('NABVYSI9')            , ;
                 dbsetscope(SCOPE_BOTH,upper(value)), ;
                 dbgotop()                          , ;
                 dbeval( {|| recCnt++ })            , ;
                 dbgotop()                            )

        showDlg := .not. (recCnt = 1)
             ok :=       (recCnt = 1)
        if(recCnt = 0, nabvysit->(dbclearscope(),dbgotop()), nil)
    endcase
  endif

  if showDlg
    if( isMethod( ::dm:drgDialog, 'quickShow' ) .and. isObject( ::odialog_cen ))
      odialog := ::odialog_cen

      odialog:odBrowse[1]:oxbp:refreshCurrent()
      odialog:quickShow(.t.)
     else
      odialog := drgDialog():new('PRO_objhead_cen_SEL', ::dm:drgDialog)
      odialog:create(,,.T.)

      ::odialog_cen := odialog
    endif

    nexit := odialog:exitState
  endif

  if .not. showDlg .or. (nexit != drgEVENT_QUIT)
    *
    ** pokud pøebírá položku z nabvysit -> musíme napozicovat cenzboz
    if iz_file = 'nabvysit'
      cky := upper(nabvysit->ccisSklad) +upper(nabvysit->csklPol)
      cenZboz->( dbSeek( cky,, 'CENIK03'))
    endif

    ::takeValue( iz_file, iz_pos)
    ovar:odrg:refresh( ::lastprocSlev )

    * po pøevzetí zablokujeme csklPol i cnazOdes
    * páè by se to furt kontrolovalo
    ::enable_or_disable_items(.f.)
  endif

  (iz_file)->(dbclearScope())
return (nexit != drgEVENT_QUIT) .or. ok


method pro_objhead_in:skl_cenzboz_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f., recNo
  *
  local  ovar := ::dm:get('M->lastprocSlev' , .F.)

  ok := cenzboz->(dbseek(upper(::sklPol:value),,'CENIK01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'PRO_objhead_cen_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
**    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. ::sklPol:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::takeValue('cenzboz',2)

    ovar:odrg:refresh( ::lastprocSlev )

*    recNo := (::it_file)->(recNo())
*    if objitemw->(dbseek( upper(cenzboz->ccisSklad) +upper(csklPol),,'OBJITEM_3'))
*      fin_info_box('Skladová položka je již obsažena v objednávce ...')
*    endif
*    (::it_file)->(dbgoTo(recNo))
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_objhead_in:postLastField(drgVar)
  local  isChanged := ::dm:changed()                                  , ;
         file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value         , ;
         ok        := ::mnozValidate()
  *
  local  lnewRec   := (::state = 2)
  local  intCount  := if( lnewRec, ::ordItem()+1, (::it_file)->ncislPOLob)

  if ok
**     ::wds_watch_mnoz( lnewRec, intCount )  nmnozPOodb -> nmnozDzbo

    * ukládáme na posledním PRVKU *
    if((::it_file)->(eof()),::state := 2,nil)

    if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
      if ::state = 2  ;  if .not. empty(file_iv)
                           (file_iv)->(dbgoto(recs_iv))
                           ::copyfldto_w(file_iv,::it_file)
                         endif
                         ::copyfldto_w(::hd_file,::it_file)
                         *
                         (::it_file)->ncislPOLob := ::ordItem()+1
      endif

      ::itsave()
      *
      if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
      (::it_file)->(flock())
    endif

    (::it_file)->nmnozneodb := ((::it_file)->nmnozobodb - (::it_file)->nmnozpoodb)
    (::it_file)->ncelkslev  := ((::it_file)->nhodnSlev  * (::it_file)->nmnozobodb)
    (::it_file)->nhmotnost  := ((::it_file)->nmnozobodb * (::it_file)->nhmotnostJ)
    (::it_file)->nobjem     := ((::it_file)->nmnozobodb * (::it_file)->nobjemJ   )

// zatím ne 22.1.2020
*   ::rp_saveRecPopl()

    pro_objhdead_cmp()

    ::sumColumn()
    ::setfocus(::state)
    ::dm:refresh()
  endif
return ok


method PRO_objhead_IN:postAppend()
  (::sklPol:odrg:isEdit   := .t., ::sklPol:odrg:oxbp:enable()  )
  *
  ** máme k dispozici položky nabídek vystavených pro ncisFirmy ??
  if nabvysit->(dbseek( (::hd_file)->ncisFirmy,,'NABVYSI4'))
    ( ::nazOdes:odrg:isEdit := .t., ::nazOdes:odrg:oxbp:enable() )
  else
    ( ::nazOdes:odrg:isEdit := .f., ::nazOdes:odrg:oxbp:disable())
  endif

  if ::dm:get( ::itemForIns, .f. ):odrg:isEdit
    ::one_edt := ::itemForIns

    if ::itemSelIns = 'sel'
      postAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has(::itemForIns):oDrg:oXbp )
    endif
  endif
return .t.


method pro_objhead_in:postSave()
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

  pro_objhdead_cmp()
  if( ok := pro_objhead_wrt_inTrans(self), ::wds_postsave(), nil )

  if ok .and. ::set_fakVyshd_inOn = 1
    ::FIN_fakVyshd_in(::dm:drgDialog)
    ::set_fakVyshd_inOn = 0
    _clearEventLoop(.t.)
  endif


  if(ok .and. ::new_dok)
    objheadw->(dbclosearea())
    objitemw->(dbclosearea())
    objit_iw->(dbclosearea())

    pro_objhead_cpy(self)

    ::brow:refreshAll()

    setAppFocus(::brow)
    ::dm:refresh( , .t.)

    ::df:tabPageManager:toFront(1)

    ::df:setnextfocus('objheadw->ctyppohybu',,.t.)
    ::comboItemSelected(::cmb_typPoh)
  endif
return ok


method PRO_objhead_IN:FIN_fakVyshd_in(drgDialog)
  local  o_fin_fakVyshd_in, o_udcp, o_dm
  local  iz_file := 'objitem', hd_file, it_file
  local  fak_cisFirmy, fak_cislOBint, fak_faktMnoz
  local  pa_Recs := {}, x, file_name

  local  last_Cargo := drgDialog:cargo
  local  inEdit     := If( IsNull(drgDialog:cargo), .F., .T.)

  * asi by se mìlo zjistit jestli už existuje FA
  ::lNEWrec   := .t.
  ::drgDialog := ::dm:drgDialog

  o_fin_fakVyshd_in := drgDialog():new('FIN_fakVyshd_IN',drgDialog)
  o_fin_fakVyshd_in:cargo_Usr := 'EXT_FAK'
  o_fin_fakVyshd_in:create( ,, .t. )

  o_udcp  := o_fin_fakVyshd_in:udcp
  hd_file := o_udcp:hd_file
  it_file := o_udcp:it_file
  o_udcp:lnewrec := .t.
  **
  *
  file_name := (it_file) ->( DBInfo(DBO_FILENAME))
               (it_file) ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name,  it_file , .t., .f.)   ; (it_file)->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'fakvysi_w', .t., .t.) ; fakvysi_w  ->(AdsSetOrder(1))
  *
  ** hlavièka, musíme vynut uložení jak zmìnu
  fak_cisFirmy         := o_udcp:dm:has(hd_file +'->ncisFirmy')
  fak_cisFirmy:value   := objheadW->ncisFirmy
  o_udcp:df:olastDrg   := fak_cisFirmy:odrg

  o_udcp:fin_firmy_sel()
  *
  ** položky
  fak_cislOBint := o_udcp:dm:has(it_file +'->ccislOBint')
  fak_faktMnoz  := o_udcp:dm:has(it_file +'->nfaktMnoz')

  objitem->( AdsSetOrder('OBJITEM2'),dbsetscope(SCOPE_BOTH,upper(objheadW->ccislobint) ),dbgotop())
  objitem->( dbeval( { || aadd( pa_Recs, objitem->( recNo()) ) } ) )

  for x := 1 to len(pa_Recs) step 1
    objitem->( dbgoTo( pa_Recs[x]) )
    *
    ** vot problema, po uložení položky získá focus BRO,
    ** pak blbne s vyèítáním položek initValue a value pøestaví ...
    *
    setAppFocus( fak_cislOBint:odrg:oxbp )

    o_udcp:takeValue(it_file, iz_file, 4, o_udcp )
    o_udcp:postValidate(fak_faktMnoz)
    o_udcp:postLastField()
  next
  *
  ** trošku doplníme hlavièku
  fakVyshdW->czkrZPUdop := objheadW->czkrZPUdop
  fakVyshdW->czkrtypuhr := objheadW->czkrtypuhr
  *
  ** je potøeba pøezobrazit typ položek, jinak to zblbne
  fakVyshdW->( dbcommit())
  fakVysitW->( dbcommit(), dbgoTop())

  o_udcp:brow:goTop():refreshAll()
  o_udcp:showGroup()
  _clearEventLoop(.t.)


*  setAppFocus(o_udcp:brow)
***  o_udcp:refresh('fakvysitW',, o_udcp:dm:vars)
*  PostAppEvent(xbeBRW_ItemMarked,,,o_udcp:brow)

  o_fin_fakVyshd_in:quickShow(.t.,.t.)
  o_udcp:wds_disconnect()

*  fakvyshdw->(dbclosearea())
*  fakvysitw->(dbclosearea())
***  fakvysi_w->(dbclosearea())
  *
*  dodlsthdw->(dbclosearea())
*  dodlstitw->(dbclosearea())

  if  .not. inedit
    PostAppEvent(xbeBRW_ItemMarked,,,drgDialog:dialogCtrl:oaBrowse:oXbp)
  endif
return self



method PRO_objhead_IN:postDelete()
  local  nvaz_Rp   := (::it_file)->nvaz_Rp
  local  cky       := (::it_file)->ccissklad +(::it_file)->csklpol, recNo

  ::wds_postDelete()

  if nvaz_Rp <> 0
    if cenZboz->( dbseek( upper(cky),,'CENIK03'))
      if objit_iw->( dbseek( strZero(nvaz_Rp,5),, 'OBJITEM_1'))
         recNo := objit_iw->( recNo())

         (::it_file)->( dbgoTo(recNo))
         if( cenZboz->ctypSKLpol = 'Y ', (::it_file)->nvaz_Rp := 0  , ;
                                         (::it_file)->_delRec := '9'  )
      endif
    endif
  endif

  ::sumColumn()
  ::brow:refreshAll()
return .t.

/*
C:\Windows\System32\drivers\etc
192.168.101.222 TS2
192.168.101.233 TS1
192.168.101.244 SERVERQI
192.168.101.245 IMM-SERVERQI
*/


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method pro_objhead_in:sumColumn()
  local  kcsBdobj := kcsZdobj := 0, x, value
  local  isOk     := .t.
  *
  ** tady udìlám zmìnu, pokud je nmnozobodb = 0 or nstav_Fakt = 0 or nstav_Svyd or ::cenZboz_kDis = 0
  ** bloknem button
  *
  objit_iw->(dbgotop())
  do while .not. objit_iw ->(Eof())
    if objit_iw->_delrec <> '9'
      ( kcsBdobj += objit_iw->nkcsBdobj, kcsZdobj += objit_iw->nkcsZdobj)

      ::cisSklad:set(objit_iw->ccisSklad)
      ::sklPol:set(objit_iw->csklPol)

      isOk := isOk .and. ( objit_iw->nmnozOBodb <> 0 .and. ;
                           objit_iw->nstav_Fakt =  0 .and. ;
                           objit_iw->nstav_Svyd =  0 .and. ;
                           if( upper(objit_iw->cpolCen) = 'C', ::cenZboz_kDis >= objit_iw->nmnozOBodb, .t. ) )
/*
      if objit_iw->nmnozOBodb  = 0 .or. ;
         objit_iw->nstav_Fakt <> 0 .or. ;
         objit_iw->nstav_Svyd <> 0 .or. ;
         if( upper(objit_iw->cpolCen) = 'C', ::cenZboz_kDis < objit_iw->nmnozOBodb, .f. )

        isOk := .f.
      endif
*/
    endif
    objit_iw->(dbskip())
  enddo

  for x := 6 to 7 step 1
    value := if(x = 6,str(kcsBdobj), str(kcsZdobj))

    ::brow:getColumn(x):Footing:hide()
    ::brow:getColumn(x):Footing:setCell(1,value)
    ::brow:getColumn(x):Footing:show()
  next

  if isObject(::oBtn_set_fakVyshd_in)
    if( isOk, ::oBtn_set_fakVyshd_in:oxbp:enable(), ::oBtn_set_fakVyshd_in:oxbp:disable() )
  endif
return .t.


method pro_objhead_in:takeValue(iz_file,iz_pos)
  local  x, pos, value, items, mname, par, iz_recs := (iz_file)->(recno())
*           objitemw,        cenzboz,           nabvysit
*
  local  pa := { ;
  {      'nzboziKat',            'nzboziKat',            'nzbozikat' }, ;
  {      'ccissklad',            'ccissklad',            'ccissklad' }, ;
  {        'csklpol',              'csklpol',              'csklpol' }, ;
  {       'cnazodes',                     '',             'cnazodes' }, ;
  {        'cnazzbo',              'cnazzbo',              'cnazzbo' }, ;
  { 'M->typ_objitem',         ':typ_objitem',         ':typ_objitem' }, ;
  {       'nklicdph',             'nklicdph',             'nklicdph' }, ;
  {     'M->procDph',             ':procDph',             ':procDph' }, ;
  {     'czkratjedn',           'czkratjedn',           'czkratjedn' }, ;
  {        'ddatobj',           ':datObj_it',           ':datObj_it' }, ;
  {      'ddatdoodb',         ':datdoOdb_it',         ':datdoOdb_it' }, ;
  {     'ddatodvvyr',        ':datodvVyr_it',        ':datodvVyr_it' }, ;
  {      'nprocslev',  'objheadw->nprocslev',  'objheadw->nprocslev' }, ;
  {     'nprocslfao', 'objheadw->nprocslfao', 'objheadw->nprocslfao' }, ;
  {     'nprocslhot', 'objheadw->nprocslhot', 'objheadw->nprocslhot' }, ;
  {      'ncenazakl',            'ncenapzbo',            'ncenazakl' }, ;
  {     'nhmotnostj',            'nhmotnost',            'nhmotnost' }, ;
  {        'nobjemj',               'nobjem',               'nobjem' }  }

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

   if( IsObject(ovar := ::dm:has(::it_file +'->cfile_iv')), ovar:set(iz_file), nil)
   if( IsObject(ovar := ::dm:has(::it_file +'->nrecs_iv')), ovar:set(iz_recs), nil)

   ::show_kDis('M->cenzboz_kDis' , ::cenzboz_kDis )

   ::df:setNextFocus('objitemw->nmnozobodb',,.T.)
return


method pro_objhead_in:objvst_pc()
  local filtr, m_filtr
  local ok
  local cenaPzbo := 0, procento := 0  //100
  *
  local cisFirmy := ::cisFirmy:value, zkrTypUhr := ::zkrTypUhr:value, zkratMenZ := ::zkratMenZ:value, datObj := ::datObj:value
  local cisSklad := ::cisSklad:value, sklPol    := ::sklPol:value, ;
        zboziKat := ::zboziKat:value
  *
  local m_cky    := upper(cisSklad) +upper(sklPol)


  procenho->( OrdSetFocus( 'PROCENHO18'))

//------------------- typ ceníku 8  dotažení prodejní ceny ------------------------
  filtr := "ntypProCen = 8 .and. "                                                    + ;
           "((ncisFirmy = %% .or. ncisFirmy = 0) .and. "                              + ;
           "(czkratMeny = '%%' .and. ccisSklad = '%%' .and. csklPol = '%%')) .and. "  + ;
           "(empty(dplatnyOD) .or. (dplatnyOD <= '%%'.and. dplatnydo >= '%%') .or. (dplatnyOD <= '%%' .and. Empty(dplatnydo)) )"

  m_filtr := format( filtr, {cisFirmy, zkratMenZ, cisSklad, sklPol, datObj, datObj, datObj} )

  procenho->(ads_setAof(m_filtr),dbgoTop())
  cenprodc->(dbseek( m_cky,,'CENPROD1'))
  cenaPzbo := cenprodc->ncenaPzbo

  if( .not. procenho->(eof()), cenaPzbo := procenho->nhodnota, nil)

  procenho->( ads_clearAof(), dbgotop())
  ::cenaZakl:set(cenaPzbo)


//------------------- typ ceníku 1 dotažení slevy z prodejní ceny ------------------------
  filtr := "ntypProCen = 1 .and. "                                                                         + ;
           "((ncisFirmy = %% .or. ncisFirmy = 0 ) .and. czkratMeny = '%%' .and. "                          + ;
           "((ccisSklad = '%%' .and. csklPol = '%%') .or. czkrTypUhr = '%%')) .and. "  + ;
           "(empty(dplatnyOD) .or. (dplatnyOD <= '%%'.and. dplatnydo >= '%%') .or. (dplatnyOD <= '%%' .and. Empty(dplatnydo)) )"

  m_filtr := format( filtr, {cisFirmy, zkratMenZ, cisSklad, sklPol, zkrTypUhr, datObj, datObj, datObj})
  procenho->(ads_setAof(m_filtr),dbgoTop())
  ok := .f.

  if .not. procenho->(eof())
    ok := .t.
  else
    procenho->(ads_clearAof(), dbgotop())
    filtr := "ntypProCen = 1 .and. "                                                                         + ;
             "((ncisFirmy = %% .or. ncisFirmy = 0 ) .and. czkratMeny = '%%' .and. "                          + ;
             "(nzboziKat = %% .or. czkrTypUhr = '%%')) .and. "                                               + ;
             "(empty(dplatnyOD) .or. (dplatnyOD <= '%%'.and. dplatnydo >= '%%') .or. (dplatnyOD <= '%%' .and. Empty(dplatnydo)))"

    m_filtr := format( filtr, {cisFirmy, zkratMenZ, zboziKat, zkrTypUhr, datObj, datObj, datObj})
    procenho->(ads_setAof(m_filtr),dbgoTop())
    ok := .not. procenho->(eof())
  endif

  if ok
    procento := procenho->nprocento
    ::procSlev:set(procento)
    ::hodnSlev:set((cenaPzbo * procento) / 100)
  endif

  procenho->(ads_clearAof(), dbgotop())


/*
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
*/

return

static function is_datumOk(datum)
  local  ok :=  empty(procenho->dplatnyOD)                                       .or. ;
                (procenho->dplatnyOD <= datum .and. empty(procenho->dplatnyDO) ) .or. ;
                (procenho->dplatnyOD <= datum .and. procenho->dplatnyDO >= datum)
return ok
**
*


method pro_objhead_in:mnozValidate()
  Local  potvrCel := 0, potvrBez := 0, cerr := ''

  Local  ok

  ok := ( ::mnozObOdb:value >  0           .and. ;
          ::mnozPoOdb:value >= 0           .and. ;
          ::mnozVpInt:value >= 0           .and. ;
          ::mnozPdOdb:value >= 0           .and. ;
          ::mnozObOdb:value >= ::mnozPoOdb:value   .and. ;
          ::mnozObOdb:value >= ::mnozPoOdb:value +::mnozVpInt:value  +::mnPotVyr:value .and. ;
          ::mnozVpInt:value <= ::mnozObOdb:value -::mnozPoOdb:value                    .and. ;
          ::mnozObOdb:value >= ::mnozPoOdb:value +::mnozVpInt:value  +::mnPotVyr:value +::mnozPlOdb:value )

  if .not. ok
    potvrCel := ::mnozPoOdb:value +::mnozVpInt:value +::mnPotVyr:value
    potvrBez := if(potvrCel < ::mnozPlOdb:value, ::mnozPlOdb:value -potvrCel, 0 )

    do case
    case (potvrCel +potvrBez) < ::mnozPlOdb:value
      cerr := 'Hodnota POTVRZENO +K_VÝROBÌ nemúže být menší než plnìní ...'

    case ::mnozObOdb:value < 0 .and. (potvrCel +potvrBez) = 0
      return .t.

    case (potvrCel +potvrBez) > ::mnozObOdb:value
      cerr := 'Hodnota POTVRZENO +K_VÝROBÌ nemùže být vìtší než objednáno ... '

    case (::mnozObOdb:value < ::mnozPoOdb:value +::mnozVpInt:value +::mnPotVyr:value +::mNozPlOdb:value)
      cerr := 'Hodnota OBJEDNÁNO nemùže být menší než POTV_ODB +MNOŽK_VÝR +POT_VÝR +PLNÌNÍ ...'
    endcase

    ::msg:writeMessage(cerr, DRG_MSG_ERROR)
    ::df:setnextfocus(::it_file +'->nmnozobodb',,.t.)
  endif
return ok


/*
method pro_objhead_in:postValidateForm()
  local values := ::dm:vars:values, size := ::dm:vars:size(), x

  begin sequence
  for x := 1 to size step 1
    if .not. values[x,2]:odrg:postValidate()
      return .f.
  break
    endif
  next
  end sequence
return .t.


method pro_objhead_in:open_in(file,alias)
  local file_name

  if select(alias) = 0
    file_name := (file) ->( DBInfo(DBO_FILENAME))
    DbUseArea(.t., oSession_free, file_name, alias, .t., .t.)
    (alias) ->(AdsSetOrder(1))
  endif
return alias
*/