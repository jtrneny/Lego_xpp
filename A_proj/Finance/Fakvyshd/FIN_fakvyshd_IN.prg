#include "adsdbe.ch"
#include "common.ch"
#include "dmlb.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


// 1_Bìžná faktura      6_Faktura do EU
// 2_Zálohová faktura   5_Penalizaèní faktura
// 3_Zahranièní faktura 4_Zálohová zahranièní


#define  m_files   {'c_dph'   ,'c_meny'  ,'c_bankuc'                                           , ;
                    'ucetSys'                                                                  , ;
                    'firmy'   ,'firmyfi' ,'firmyda' ,'firmyuc'                                 , ;
                    'c_staty' ,'kurzit'                                                        , ;
                    'parvyzal', 'dodlsthd','dodlstit','vyrzak'  ,'vyrzakit','objhead','objitem', ;
                    'cenZb_rp', 'cenzboz' , 'pvphead' , 'pvpitem' ,'ucetpol' ,'ucetdohd', 'kusov'            }

*
** CLASS for FIN_fakvyshd_IN ***************************************************
CLASS FIN_fakvyshd_IN FROM drgUsrClass, FIN_finance_IN, FIN_fakturovat_z_vld, FIN_pro_fakdol, SYS_ARES_forAll

exported:
  method  init, drgDialogStart
  method  overPostLastField, postLastField, postSave, postEscape, postDelete, onSave, destroy
  method  postItemMarked
  *
  * ukládáme položky v cyklu
  method  sp_overPostLastField
  *
  var     onTabNum, itemForIns, itemSelIns, cykleInIns
  var     lok_append2
  *
  * hlavièka info
  * 1 -bìžná faktura/ 6 -euro faktura
  * 'Bez DpH    <infoval_11>   DpH  <infoval_12> Celkem                               '
  inline access assign method infoval_11 var infoval_11
    return (fakvyshdw->ncendancel +fakvyshdw->nzakldaz_1 +fakvyshdw->nzakldaz_2 +fakvyshdw->nzakldaz_3)

  inline access assign method infoval_12 var infoval_12
    return (fakvyshdw->nsazdan_1 +fakvyshdw->nsazdan_2 +fakvyshdw->nsazdan_3 + ;
            fakvyshdw->nsazdaz_1 +fakvyshdw->nsazdaz_2 +fakvyshdw->nsazdaz_3   )

  inline access assign method kurZahMen() var kurZahMen
    local  odrg_m
    local  nkurz := 0

    if isObject( ::dm )
      nkurz  := (::hd_file)->nkurZahMen
      odrg_m := ::dm:has( 'M->kurZahMen')

      if isObject(odrg_m)
        odrg_m:set( nkurz )
      endif
    endif
    return nkurz

  * položky - bro
  inline access assign method cenPol() var cenPol
    local  retVal := 0, nvaz_Rp := fakvysitw->nintCount

    if fakvysitw->cpolcen = 'C'
      retVal := MIS_ICON_OK  // OK.bmp
    else
      if fakvysi_w->( dbseek( strZero(nvaz_Rp,5),, 'FAKVYSIT_1'))
        if fakvysi_w->ctypSKLpol = 'Y '
          retVal :=  BANVYPIT_4  // m_append2.bmp"  BANVYPIT_4 511
        endif
      endif
    endif
    return retVal

  inline access assign method cena_za_mj() var cena_za_mj
    local retval := 0

    retval := if(fakvyshdw->nfintyp > 2 .or. fakvyshdw->nfintyp = 6, ;
              if(fakvyshdw->nfintyp = 4, fakvysitw->ncenzakcel,fakvysitw->ncejprkbz), fakvysitw->ncejprkbz)
    return retval

  inline access assign method k_disp_fak var k_disp_fak
    local retVal := '', cky

    do case
    case( fakvysitw->cfile_iv = 'cenzboz')
      cky := fakvysitw->ccissklad +fakvysitw->csklpol
      cenzboz->(dbseek(upper(cky),,'CENIK03'))
      retVal := str(cenzboz->nmnozDZbo)
    endcase
    return retVal


  inline method eventHandled(nevent,mp1,mp2,oxbp)
    local  sID := isNull((::it_file)->sID,0)
    *
    ** úprava pro kontrolní pøepoèet faktury
    if isObject(::oBtn_fin_KontrPrepocet)
      if  ::df:tabPageManager:active:tabNumber = 4
        if( sID = 0, ::oBtn_fin_KontrPrepocet:disable(), ::oBtn_fin_KontrPrepocet:enable() )
      else
        ::oBtn_fin_KontrPrepocet:disable()
      endif
    endif
    return ::fakdol_handleEvent(nevent,mp1,mp2,oxbp)


  method  showGroup
  *
  ** kontrolní pøepoèet faktury
  inline method fin_KontrPrepocet()
    local  it_file    := ::it_file
    local  nrec_count := (it_file)->( ads_getRecordCount()), nrec_work  := 1
    local  drgVar     := ::dm:has(it_file +'->nfaktMnoz')
    local  cPol

    (it_file)->( dbGoTop())
    ::brow:goTop():refreshAll()
    setAppFocus(::brow)

    do while ( nrec_count >= nrec_work )
      ::refresh(drgVar)

      if ::postValidate(drgVar)
        ::itsave()
      endif

      nrec_work++
      ::brow:down():refreshAll()
    enddo

    cPol := if(nrec_count = 1,' položka', ;
             if(nrec_count >= 2 .and. nrec_count <= 4, ' položky', ' položek' )) +' ...'
    fin_info_Box('Kontrolní pøepoèet dokonèen, zpracováno ' +str(nrec_count) +cPol )

    ::brow:goTop():refreshAll()
    PostAppEvent(xbeBRW_ItemMarked,,,::brow)
  return self


HIDDEN:
  var     members_fak, members_pen, members_inf
  var     members_fak_it
  var     ncurrRec
  var     is_ext_fak
  var     oBtn_fin_KontrPrepocet


  inline method dopln_Firmu_z_file_iv(file_iv)
    local  pa_file_iv := { { 'dodlstit', 'dodlsthd',          file_iv +'->ndoklad'    , 'DODLHD1' }, ;
                           { 'objitem' , 'objhead' ,          file_iv +'->ndoklad'    , 'OBJHEAD7'}, ;
                           { 'vyrzakit', 'vyrzak'  , 'upper(' +file_iv +'->ccisZakaz)', 'VYRZAK10'}  }
    *
    local  pa_items   := { { 'cnazev'   , 'cnazev'    }, { 'cnazFirmy' , 'cnazev'     }, ;
                           { 'cnazev2'  , 'cnazev2'   }, { 'nico'      , 'nico'       }, ;
                           { 'cdic'     , 'cdic'      }, { 'culice'    , 'culice'     }, ;
                           { 'csidlo'   , 'csidlo'    }, { 'cpsc'      , 'cpsc'       }, ;
                           { 'cnazev'   , 'cnazevDOA' }, { 'cnazev2'   , 'cnazevDOA2' }, ;
                           { 'culice'   , 'culiceDOA' }, { 'csidlo'    , 'csidloDOA'  }, ;
                           { 'cpsc'     , 'cpscDOA'   }                                , ;
                           { 'czkrTypUhr' , 'czkrTypUhr', 'objhead' }, ;
                           { 'czkrZpuDop' , 'czkrZpuDop', 'objhead' }  }


    *
    local  npos, cfile_hd, xkey_hd, ctag_hd, npos_in, npos_out, xval, cname
    local  y, vars := ::dm:vars, drgVar


    if ( npos := ascan( pa_file_iv, { |x| x[1] = lower(file_iv) })) <> 0
      if ( (file_iv)->ncisFirmy = (::hd_file)->ncisFirmy .and. ((::hd_file)->ncisFirmy = (::hd_file)->ncisFirDoa) )

        firmy->( dbseek( (::hd_file)->ncisFirmy,,'FIRMY1'))

        if firmy->nis_INO = 1 .or. firmy->nis_ODB = 1
          cfile_hd := pa_file_iv[npos,2]
          xkey_hd  := DBGetVal( pa_file_iv[npos,3])
          ctag_hd  := pa_file_iv[npos,4]

          if (cfile_hd)->( dbseek( xkey_hd,, ctag_hd))

            for x := 1 to len(pa_items) step 1
              npos_in  := (cfile_hd) ->( fieldPos( pa_items[x,1]))
              npos_out := (::hd_file)->( fieldPos( pa_items[x,2]))

              if( npos_in <> 0 .and. npos_out <> 0 )
                isOk  := .t.
                cname := lower( ::hd_file +'->' +pa_items[x,2])
                xval  := (cfile_hd)->( fieldGet( npos_in))

                * Agrikol, z první položky objitem.objhead pøevzít zpuUhrady a zpuDopravy
                if len( pa_items[x] ) = 3 .and. cfile_hd = 'objhead'
                  isok := (firmy->nis_INO = 1 .and. .not. empty(xVal) .and. xVal <> (::hd_file)->( fieldGet( npos_out)))

                  if isok
                    if pa_items[x,1] = 'czkrTypUhr'  ;  c_typUhr->( dbseek( upper(xval),,'TYPUHR1'))
                    else                             ;  c_zpuDop->( dbseek( upper(xval),,'TYPUHR1'))
                    endif
                  endif
                endif

                if isOk
                  (::hd_file)->( fieldPut( npos_out, xVal))

                  for y := 1 to ::dm:vars:size() step 1
                    drgVar := ::dm:vars:getNth(y)
                    if( lower(drgVar:name) = cname, drgVar:set(xval), nil )
                  next
                endif
              endif
            next

            (::hd_file)->(dbcommit())
            ::dm:refresh(.f.)
          endif
        endif
      endif
    endif
  return self

  *  recyklaèní polatek ke skladové položce
  ** hokus pokus asi jen pro Elektrosvit
  inline method rp_saveRecPopl()
    local  it_file := ::it_file
    local  iz_file := 'cenzboz', iz_pos := 6
    *
    local  ccisZakaz  := (it_file)->ccisZakaz
    local  mnozParent := (it_file)->nfaktMnoz
    *
    local  nHmotnostJ := (it_file)->nHmotnostJ, cZkratJedH := (it_file)->cZkratJedH
    local  nObjemJ    := (it_file)->nObjemJ   , cZkratJedO := (it_file)->cZkratJedO
    *
    local  cky        := (it_file)->ccissklad +(it_file)->csklpol
    local  nvaz_Rp    := (it_file)->nvaz_Rp, recNo
    local  drgVar     := ::dm:has(it_file +'->nfaktMnoz')
    *
    local  akt_recNo  := (it_file)->( recNo())
    local  akt_order  := (it_file)->nintcount
    local  new_order

    do case
    case ::state = 2             // nová položka

      if cenZb_rp->( dbseek( upper(cky),, 'CENZBRP1' ))
        if cenZboz->( dbseek( cenZb_rp->nyCENZBOZ,, 'ID' ))

          ::dm:refreshAndSetEmpty( it_file )

          cenZboz->( dbseek( cenZb_rp->nyCENZBOZ,, 'ID' ))
          ::takeValue(it_file, iz_file, iz_pos, ::drgDialog:udcp)

          drgVar       := ::dm:has(it_file +'->nfaktMnoz')
          ( drgVar:value := mnozParent, drgvar:refresh() )

          if ::postValidate(drgVar)
            *
            ** do parenta nvaz_Rp vložit nintcount childa tj. recyklaèního poplatku
            new_order  := ::ordItem()+1
            (::it_file)->nvaz_rp := new_order

            addrec(::it_file)

            ::copyfldto_w(iz_file  ,::it_file)
            ::copyfldto_w(::hd_file,::it_file)
                         (::it_file)->nHmotnost  := 0
                         (::it_file)->nObjem     := 0
                         (::it_file)->ncisloPVP  := 0
                         (::it_file)->ccisZakaz  := ccisZakaz
                         **
                         (::it_file)->nintcount  := new_order
                         (::it_file)->nvaz_rp    := akt_order

            ::itsave()
                         (::it_file)->nHmotnostJ := nHmotnostJ
                         (::it_file)->cZkratJedH := cZkratJedH
                         (::it_file)->nObjemJ    := nObjemJ
                         (::it_file)->cZkratJedO := cZkratJedO

            if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
            (::it_file)->(flock())
          endif
        endif
      endif

    case nvaz_Rp <> 0           // oprava položky s vazbou CEN <-> Rp

      if fakvysi_w->( dbseek( strZero(nvaz_Rp,5),, 'FAKVYSIT_1'))
        recNo := fakvysi_w->( recNo())

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


  *  cucetFaVy - cnapl1FaVy - cnapl2FaVy
  ** hokus pokus se zdanìním zaokrouhlení faktury
  inline method dan_zustPoZaokr()
    local  hd_file := ::hd_file, it_file := ::it_file
    *****
    local  c_zaklDan := 'nzaklDan_'
    local  c_procDan := 'nprocDan_'
    local  nposZakl, nposDan, nprocDph, nnapocet, nradVYKdph, nzaklDan, nsazDan
    local  cucet, cnazPol_1, cnazPol_2
    local  pa := {}
    *
    local  cradDph, retVal := '0'
    local  cky     := upper((hd_file)->culoha    ) +upper((hd_file)->ctypdoklad) +upper((hd_file)->ctyppohybu)
    local  duzp    := (hd_file)->dpovinfak
    *
    local  x, nkoeF
    local  pa_it


    if (hd_file)->nzustPoZao <> 0

      cucet     := sysconfig('ucto:cucetFaVy' )
      cnazPol_1 := sysconfig('ucto:cnapl1FaVy')
      cnazPol_2 := sysconfig('ucto:cnapl2FaVy')

      ::dm:refreshAndSetEmpty( ::it_file )
      *
      ** do kterého %DPH pøide položka
      for x := 1 to 3 step 1
        nposZakl := (hd_file)->( fieldPos( c_zaklDan +str(x,1)))
        nposDan  := (hd_file)->( fieldPos( c_procDan +str(x,1)))

        if nposZakl <> 0 .and. nposDan <> 0
          aadd( pa, { (hd_file)->(fieldGet( nposZakl)), (hd_file)->( fieldGet( nposDan)) })
        endif
      next

      * oprava pro dobropisy, èáska je záporná a vleze to do jiného DPH
      *
      pa       := ASort( pa,,, {|aX,aY| abs(aX[1]) > abs(aY[1]) } )
      nprocDph := pa[1,2]
// JT oprava
//    nprocDph := 21

      c_dph->( dbseek( nprocDph,,'C_DPH2'))
      nnapocet := c_dph->nnapocet

      *
      ** øádek výkazu DPH
      if(select('c_typpoh') = 0, drgDBms:open('c_typpoh'), nil)
      c_typpoh->(dbseek(cky,,'C_TYPPOH05'))

      cradDph := FIN_c_vykdph_cradDph( duzp, hd_file )

      if .not. empty(cradDph)
        pa := listasarray(cradDph)
        pa := asize(pa,5)

        do case
        case c_dph->nnapocet = 0 ;  retVal := isnull(pa[1],'0')
        case c_dph->nnapocet = 1 ;  retVal := isnull(pa[2],'0')
        case c_dph->nnapocet = 2 ;  retVal := isnull(pa[3],'0')
        case c_dph->nnapocet = 3 ;  retVal := isnull(pa[5],'0')
        endcase
      endif

      nradVYKdph := val(retVal)
      *
      ** výpoèet danì
      nzaklDan := (hd_file)->nzustPoZao
      nkoeF    := round( (100 + nprocDph) / 100, 2 )
      nsazDan  := round( nzaklDan - (nzaklDan / nkoeF), 2 )

      pa_it := { {   'cnazzbo',                 'zaokrouhlení' }, ;
                 { 'nfaktmnoz',                              1 }, ;
                 {'czkratjedn',                            'x' }, ;
                 {'ncenJEDzak',              nzaklDan -nsazDan }, ;
                 {'ncenJEDzad',                       nzaklDan }, ;
                 {'ncenZAKcel',              nzaklDan -nsazDan }, ;
                 {'ncenZAKced',                       nzaklDan }, ;
                 {'ncenZAHcel',              nzaklDan -nsazDan }, ;
                 {   'njedDan',                        nsazDan }, ;
                 {   'nsazDan',                        nsazDan }, ;
                 { 'ncenazakl',              nzaklDan -nsazDan }, ;
                 { 'ncenazAKc',              nzaklDan -nsazDan }, ;
                 { 'ncejPRzbz',              nzaklDan -nsazDan }, ;
                 { 'ncejPRkbz',              nzaklDan -nsazDan }, ;
                 { 'ncejPRkdz',                       nzaklDan }, ;
                 { 'ncecPRzbz',              nzaklDan -nsazDan }, ;
                 { 'ncecPRkbz',              nzaklDan -nsazDan }, ;
                 { 'ncecPRkdz',                       nzaklDan }, ;
                 {  'nprocdph',                       nprocDph }, ;
                 {  'nnapocet',                       nnapocet }, ;
                 {'nradvykdph',                     nradVYKdph }, ;
                 {     'cucet',                          cucet }, ;
                 {'nIND_zaokr',                              1 }, ;
                 {  'cnazPol1',                      cnazPol_1 }, ;
                 {  'cnazPol2',                      cnazPol_2 }  }


      for x := 1 to len(pa_it) step 1
        if IsObject(ovar := ::dm:has(it_file +'->' +pa_it[x,1]))
          ovar:set(pa_it[x,2])
          ovar:initValue := ovar:prevValue := pa_it[x,2]
        endif
      next

      (hd_file)->nzustPoZao := 0

      ::state := 2
      ::postLastField(.t.)
    endif
  return self


ENDCLASS


method FIN_fakvyshd_in:init(parent)
  local  file_name, cargo_usr

  ::drgUsrClass:init(parent)
  *
  (::hd_file     := 'fakvyshdw',::it_file  := 'fakvysitw')
  ::lnewrec      := .not. (parent:cargo = drgEVENT_EDIT)
  ::lok_append2  := .f.
  ::ncurrRec     := fakVyshd->( recNo())
  ::is_ext_fak   := .f.

  * základní soubory
  ::openfiles(m_files)

  * pøednastavení z CFG
  ::lVSYMBOL       := sysconfig('finance:lvsymbol'  )
  ::SYSTEM_nico    := sysconfig('system:nico'       )
  ::SYSTEM_cdic    := sysconfig('system:cdic'       )
  ::SYSTEM_cpodnik := sysconfig('system:cpodnik'    )
  ::SYSTEM_culice  := sysconfig('system:culice'     )
  ::SYSTEM_cpsc    := sysconfig('system:cpsc'       )
  ::SYSTEM_csidlo  := sysconfig('system:csidlo'     )

  * likvidace
  ::FIN_finance_in:typ_lik := 'poh'

  * pomocné pro párováníZáloh (z) a penalizaci (p)
*   drgDBMS:open('fakvyshd',,,,,'fakvyshd_z')
  drgDBMS:open('fakvyshd',,,,,'fakvyshd_p')

  *
  ** požadavek automatického vytvoøení FAKTURY
  cargo_usr    := if( ismemberVar( parent, 'cargo_usr'), isnull( parent:cargo_usr, ''), '' )
  ::is_ext_fak := ( lower(cargo_usr) = 'ext_fak')

  FIN_fakvyshd_cpy(self)

  if .not. ::is_ext_fak
    file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
                 (::it_file) ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name,  ::it_file , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'fakvysi_w', .t., .t.) ; fakvysi_w  ->(AdsSetOrder(1))
  endif
return self


METHOD FIN_fakvyshd_IN:drgDialogStart(drgDialog)
  local  members  := drgDialog:dialogCtrl:members[1]:aMembers, odrg, groups, name
  local  fst_item := if(::lnewrec,'ctyppohybu','cvarsym'), pa
  *
  local  ardef    := drgDialog:odbrowse[1]:ardef, npos_isSest, ocolumn, pa_groups, nin
  local  acolors  := MIS_COLORS
  *
  local  onTabNum, itemForINS
  local  c_FIN_fakvys
  local  pa_onTabNum   := {'ncisfirmy', 'ncisfirdoa' }
  local  pa_itemForIns := {'csklpol','ncislodl','ccislobint','cciszakazi','nciszalfak'}

  * pøidán nový parametr FIN_fakvys
  * 1 - ncisFirmy / ncisFirDoa
  *     ncisFirmy  poøizuje dotahuje se ncisFirDoa  TabNun -> základní karta
  *     ncisFirDoa poøizuje dotahuje se ncisFirmy   TabNum -> 3
  * 2 - csklPol / ncisloDl / ccislObInt / ccisZakazI / ncisZalFak
  *     po INS naktivuje požadovaný prvek, pokud je k dispozici, imlicitnì csklPol
  * 3 - SEL
  *     po INS automaticky rozevøe nabídku pro SEL dialog
  * 2 a 3 parametr jsou svázané
  * 4 - indikace pro poøizování dokladù v cyklu - imlicitnì v INS TRUE
  **
  ::onTabNum   := 0
  ::itemForIns := ::it_file +'->csklPol'
  ::itemSelIns := ''
  ::cykleInIns := .t.

  if isCharacter( c_FIN_fakvys := sysConfig('finance:FIN_fakvys'))
    pa := asize( listAsArray( strTran(c_FIN_fakvys,' ', '')), 3)
    aeval( pa, {|x,n| pa[n] := isNull(x,'') })

    * 1
    if( nin := ascan( pa_onTabNum  , {|x| x == lower(pa[1]) })) =  2
      ::onTabNum := 1
    endif

    * 2
    if( nin := ascan( pa_itemForIns, {|x| x == lower(pa[2]) })) <> 0
      ::itemForIns := ::it_file +'->' +lower(pa[2])

      * 3
      if lower(pa[3]) = 'sel'
        ::itemSelIns := 'sel'
      endif
    endif

    * 4
    if len( pa ) = 4
      ::cykleInIns := ( val(pa[4]) = 1 )
    endif
  endif

  * na základì paramertu konfigurace - doèasné øešení !!!
  * 0 - základní poøízení ncisFirmy  a dotahuje se ncisFirDOA
  * 1 - poøizuje          ncisFirDOA a dotahuje se ncisFirmy
// ne  onTabNum   := sysconfig('finance:ntabpagfak')
//     ::onTabNum := if(isNumber(onTabNum), onTabNum, 0)
//     itemForINS := if(::onTabNum = 0, '->csklpol', '->ccislobint')

  ::members_fak    := {}
  ::members_fak_it := {}
  ::members_pen    := {}

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

  * paramert z CFG
  ::fin_finance_in:init(drgDialog,'poh', ::itemForIns,' položku faktury')

  ::cmb_typPoh := ::dm:has(::hd_file +'->ctyppohybu'):odrg
  * cenzboz
  ::cisSklad   := ::dm:get(::it_file +'->ccissklad' , .F.)
  ::sklPol     := ::dm:get(::it_file +'->csklpol'   , .F.)
  *dodldtit
  ::cisloDl    := ::dm:get(::it_file +'->ncislodl'  , .F.)
  ::countdl    := ::dm:get(::it_file +'->ncountdl'  , .F.)
  * objitem
  ::cislObInt  := ::dm:get(::it_file +'->ccislobint', .F.)
  ::cislPolob  := ::dm:get(::it_file +'->ncislPolob', .F.)

  ::cisZakazi  := ::dm:get(::it_file +'->cciszakazi', .F.)
  ::cisZalFak  := ::dm:get(::it_file +'->nciszalfak', .F.)


  * kombinované tlaèítko u FAKVYSITw->NCEJPRZBZ
  ::o_cejPrZbz := ::dm:get(::it_file +'->ncejPrZbz' , .F.)

  * nkodPlneni se poøizuje jen u EU faktur, nastavení je v c_typPoh->cradDph -- parametr 4
  ::cmb_kodPlneni        := ::dm:has(::it_file +'->nkodplneni'):odrg
  ::cmb_kodPlneni_orsize := ::cmb_kodPlneni:oxbp:currentSize()
  ::cmb_kodPlneni_defval := 0

  * ctypPreDan a nprodDPHpp se edituje pouze pro nradVykDPH = 25, jinak není ani viditelný
  ::cmb_typPreDan          := ::dm:has(::it_file +'->ctypPreDan'):odrg
  ( ::cmb_typPreDan:isEdit := .f., ::cmb_typPreDan:oxbp:hide() )

  ::get_procDPHpp          := ::dm:has(::it_file +'->nprocDPHpp'):odrg
  (::get_procDPHpp:isEdit  := .f., ::get_procDPHpp:oxbp:hide() )

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

    groups := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    name   := if( ismemberVar(members[x],'name'  ), isnull(members[x]:name  ,''), '')

    * jen editaèní prvky (IT) pro validaci ukládání v cyklu
    if  members[x]:isEdit .and. .not. ('PEN' $ groups)
      if( 'fakvysitw' $ lower(name), aadd(::members_fak_it, {members[x],x}), nil)
    endif

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

  * projka FAKPIHD-DODLSTHD
  ::fin_pro_fakdol:init(drgDialog:udcp)

  * propojka pro ARES
  if( .not. ::is_ext_fak, ::sys_ARES_forAll:init(drgDialog), nil )

  * pøi INS musíme zavolat vazbu na kurz
  if ::lnewRec
    if .not. Equal( c_bankuc->czkratMeny, SYSCONFIG('FINANCE:cZAKLMENA'))
      odrg := ::dm:has(::hd_file +'->cbank_uct')
      odrg:prevValue := ''
      ::fin_kurzit( odrg, (::hd_file)->dvystfak)
    endif
  endif

  * pøi ENTER musíme nastavit splatn_ffi
  if .not. ::lnewRec
    do case
    case firmyfi->( dbseek( (::hd_file)->ncisFirDoa,,'FIRMYFI1'))
      ::splatn_ffi := firmyfi->nsplatnost
    case firmyfi->(dbseek( (::hd_file)->ncisfirmy  ,,'FIRMYFI1'))
      ::splatn_ffi := firmyfi->nsplatnost
    endcase
  endif

  ::comboItemSelected(::cmb_typPoh,0)
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

  * parametr z CFG
  if ::onTabNum = 1
    ::df:tabPageManager:showPage(3)
    ::df:setnextfocus(::hd_file +if( ::lnewrec, '->ctypPohybu', '->cvarSym'),,.t.)
  endif
  *
  * kontrolní pøepoèet položek faktury
  members := drgDialog:oActionBar:members

  for x := 1 TO LEN(members) step 1
    odrg := members[x]

    do case
    case odrg:className() = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case lower(members[x]:event) = 'fin_kontrprepocet' ; ::oBtn_fin_KontrPrepocet := members[x]
        endcase
      endif
    endcase
  next
  if( isObject(::oBtn_fin_KontrPrepocet), ::oBtn_fin_KontrPrepocet:disable(), nil )

  *
  * externí vystavení FAKTURY
  if( ::is_ext_fak, ::cykleInIns := .f., nil )

return if( ::is_ext_fak, .f., self )



* metoda pro ukládání vybraných položek v cyklu
method fin_fakvyshd_in:sp_overPostLastField()
  local  pa := ::members_fak_it, x
  *
  begin sequence
    for x := 1 to len(pa) step 1
      if .not. ::postValidate(pa[x,1]:oVar)
        ::df:olastdrg   := pa[x,1]
        ::df:nlastdrgix := pa[x,2]
        ::df:olastdrg:setFocus()
        return .f.
  break
      endif
    next
  end sequence

  if ::overPostLastField(.t.)
    ::postLastField()
    ::wds_watch_time()
  endif
return .t.


method fin_fakvyshd_in:overPostLastField(in_spcykl)
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

  if .not. ::wds_watch_mnoz( lnewRec, intCount )
    if .not. in_spcykl
      ::df:setNextFocus((::it_file) +'->nfaktmnoz',, .t.)
      ::msg:writeMessage('Množství k fakturaci bylo již použito ...', DRG_MSG_ERROR)
    endif
    return .f.
  endif
return ok


method fin_fakvyshd_in:postLastField(lin_postSave)
  local  isChanged := ::dm:changed()                                  , ;
         file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value
  local  cisZakaz, ok, cky

  default lin_postSave to .f.

  *
  ** zajímavá úprava, pokud pøebírají 1. položku do dokladu z dodlstit,objitem,vyrzakit
  ** doplnit / zmìnit údaje o firmì z primárního dokladu
  ** z dùvodu rychlosti to pùjde po singl testech
  **
  if( isNull( (::it_file)->sID, 0) = 0, ::dopln_Firmu_z_file_iv(file_iv), nil )


  * tady je to divné, v cyklu postValidOK nìco obsahuje a nezkotroluje znovu prvky na FRM !!!
  if(fakvyshdw->nprocDan_1 = 0, fakvyshdw->nprocDan_1 := seekSazDPH(1,fakvyshdw->dpovinFak), nil)
  if(fakvyshdw->nprocDan_2 = 0, fakvyshdw->nprocDan_2 := seekSazDPH(2,fakvyshdw->dpovinFak), nil)
  if(fakvyshdw->nprocDan_3 = 0, fakvyshdw->nprocDan_3 := seekSazDPH(3,fakvyshdw->dpovinFak), nil)


  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  ok := if(::state = 2, addrec(::it_file), .t.)


  if ok
    if ::state = 2  ;  if .not. empty(file_iv)
                         (file_iv)->(dbgoto(recs_iv))

                         * penalizaèní faktura se nesmí kopírovat
                         if file_iv <> 'fakvyshd_p'
                           ::copyfldto_w(file_iv,::it_file)
                         endif
                       endif

                       cisZakaz := (::it_file)->ccisZakaz
                       ::copyfldto_w(::hd_file,::it_file)
                       (::it_file)->ncislopvp  := 0
                       (::it_file)->nintcount  := 0
                       (::it_file)->nintcount  := ::ordItem()+1
                       (::it_file)->ccisZakaz  := cisZakaz
    endif

    ::itsave()
    *
    ** nullDph 4 a 14 jsou pro párování záloh nklicDph musí být -1 **
    if (::it_file)->nnullDph = 4 .or. (::it_file)->nnullDph = 14
       (::it_file)->ncenzahcel := (::it_file)->ncecprkdz
    else
      (::it_file)->ncenzahcel := (::it_file)->ncecprkbz
      c_dph->(dbseek((::it_file)->nprocdph,,'C_DPH2'))
      (::it_file)->nklicdph := c_dph->nklicdph
    endif

    if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
    (::it_file)->(flock())

    *
    ** párování zálohy zase z fakPrihd rozhodí postavení DB
    if( file_iv = 'fakvyshd', fakVysHd->( dbgoto( ::ncurrRec)), nil )

    *
    ** penalizaèní faktury
    if (::hd_file)->nfintyp = 5
      fakvysitw->czkratJedn := 'DNY'
      fakvysitw->nnullDph   := 3
      fakvysitw->nceCPrKDZ  := fakvysitw->nceCPrKBZ
    endif

    *
    ** nìkdy se stane, že se ztratí ncenaSzbo a pak ke nevygeneruje pvpitem
    if fakvysitw->ncenaSzbo = 0
      cky := fakvysitw->ccissklad +fakvysitw->csklpol
      if cenzboz->(dbseek(upper(cky),,'CENIK03'))
        fakvysitw->ncenaSzbo := cenZboz->ncenaSzbo
      endi
    endif
  endif

  (::it_file)->nmnozZdok := isnull(::wds_mnozZdok,0)
  (::it_file)->nhmotnost := ((::it_file)->nfaktmnoz * (::it_file)->nhmotnostJ)
  (::it_file)->nobjem    := ((::it_file)->nfaktmnoz * (::it_file)->nobjemJ   )

  if( .not. lin_postSave, if( ::is_ext_fak, nil, ::rp_saveRecPopl()), nil )
  fin_ap_modihd(::hd_file)

  if( .not. lin_postSave, ::setfocus(::state), nil )
  ::dm:refresh()
return .t.


method FIN_fakvyshd_IN:postSave()
  local  ok, ax, value     := ::cmb_typPoh:value     , ;
                 konstSymb := (::hd_file)->nkonstSymb, ;
                 vystFak   := (::hd_file)->dvystFak  , ;
                 povinFak  := (::hd_file)->dpovinFak , ;
                 typUhr    := (::hd_file)->czkrtypuhr
  *
  local  m_file := upper(left(::hd_file, len(::hd_file)-1))
  local  cisFak := (::hd_file)->ncisfak
  local  n_doklad
  *
  local  file_name

  * zdanìní zaokrouhlení faktury
  c_typuhr ->(dbseek( upper(typUhr),,'TYPUHR1'))
  (::hd_file)->nIsItZaokr := c_typuhr->nIsItZaokr
  if( (::hd_file)->nIsItZaokr = 1, ::dan_zustPoZaokr(), nil )

  * pøepoèet hlavièky *
  fin_ap_modihd(::hd_file)
  if( (::hd_file)->nIsItZaokr = 1, (::hd_file)->nzustPoZao := 0, nil )

  * u zahranièních pokud je kurz napø 25.755 .. nzustPOzao <> 0
  if (::hd_file)->cZKRATmeny <> (::hd_file) ->cZKRATmenz
    (::hd_file)->nzustPoZao := 0
  endif

  * ještì je tu jedna ptákovina .01 - .03
  * u .03 21%  je .01 jinak 0
  * .01 .. .02 je 0 ... se musí nìjak upravit

  if ::new_dok
    if .not. fin_range_key(m_file,cisFak,,::msg)[1]
      ::df:tabPageManager:toFront(1)
      ::df:setnextfocus(::hd_file +'->ncisfak',,.t.)
      return .f.
    endif
  endif
  *
  ** uložení v trasakci
  ok := fin_fakvyshd_wrt_inTrans(self)

  if ok .and. ::set_likvidace_inOn = 1
    ::FIN_likvidace_in(::drgDialog)
    ::set_likvidace_inOn = 0
    _clearEventLoop(.t.)
  endif


  if(ok .and. ::new_dok .and. ::cykleInIns)
    fakvyshdw->(dbclosearea())
    fakvysitw->(dbclosearea())
    fakvysi_w->(dbclosearea())

    fin_fakvyshd_cpy(self)

    file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
                 (::it_file) ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name,  ::it_file , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'fakvysi_w', .t., .t.) ; fakvysi_w  ->(AdsSetOrder(1))
    *
    ::cmb_typPoh:value := value
    ::comboItemSelected(::cmb_typPoh,0)

    fakvyshdw->nkonstSymb := konstSymb
    fakvyshdw->dvystFak   := vystFak
    fakvyshdw->dpovinFak  := povinFak

    * v cyklu poøízení zùstávaly položky z pøedchozích dat
    * nkodPlneni se poøizuje jen u EU faktur, nastavení je v c_typPoh->cradDph -- parametr 4
    ::cmb_kodPlneni:value := 0

    * ctypPreDan a nprodDPHpp se edituje pouze pro nradVykDPH = 25, jinak není ani viditelný
    ::cmb_typPreDan:value := ''

    ::brow:refreshAll()

    setAppFocus(::brow)
    ::dm:refresh()
    *
    ** musíme ošidit tabPage
    ::df:tabPageManager:members[1]:is_show := .f.
    ::df:tabPageManager:showPage(1)

    if ::onTabNum = 1
      ::df:tabPageManager:members[2]:oxbp:minimize()
      ::df:tabPageManager:members[2]:is_show := .f.

      ::df:tabPageManager:members[3]:oxbp:maximize()
      ::df:tabPageManager:members[3]:is_show := .t.
    endif

*    25.6.2015  tahle varianta taky nefungovala korektnì, ale vydržela 4-roky
*    ::df:tabPageManager:showPage( if(::onTabNum = 1, 3, 2) )

    if( ::onTabNum = 0, ::df:setnextfocus('fakvyshdw->ctyppohybu',,.t.), nil )
    if( ::onTabNum = 1, ::df:setnextfocus('fakvyshdw->ncisfirdoa',,.t.), nil )

*     29.6.2011 tahle varianta nefungovala korektnì
**    ::df:tabPageManager:showPage( if(::onTabNum = 1, 3, 2), .t. )
**    ::df:setnextfocus('fakvyshdw->ctyppohybu',,.t.)

    ::wds_postSave()
  elseif(ok .and. .not. ::new_dok)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return ok



METHOD FIN_fakvyshd_IN:onSave(lIsCheck,lIsAppend)                              // cmp_AS FIN_FAKVYSITw
  LOCAL  dc     := ::drgDialog:dialogCtrl
  LOCAL  cALIAs := ALIAS(dc:dbArea)
  LOCAL  nKOe   := (FAKVYSHDw ->nKURZAHMEN /FAKVYSHDw ->nMNOZPREP)

  IF !lIsCheck .and. cALIAs = 'FAKVYSITW'
    // doplnìní údajù do položek //
    C_DPH ->(mh_SEEK(FAKVYSITw ->nPROCDPH,2))
    FAKVYSITw ->nKLICDPH := C_DPH ->nKLICDPH
    FAKVYSITw ->nNAPOCET := C_DPH ->nNAPOCET
    // pøepoètem hlavièku //
    FIN_ap_modihd('FAKVYSHDW')
  ENDIF
RETURN .T.


method FIN_fakvyshd_in:postEscape()
  local  cisZalFak := ::dm:get(::it_file +'->ncisZalFak')

  if cisZalFak <> 0
    if cisZalFak <> (::it_file)->ncisZalFak
      vykdph_pw->(dbeval( { || if( vykdph_pw->ncisFak = cisZalFak, vykdph_pw->(dbdelete()), nil ) } ))
    endif
  endif

  ::enable_or_disable_items()
  ::typPreDan( (::it_file)->nradVykDph )
return


method FIN_fakvyshd_in:postDelete()
  local  nintCount := (::it_file)->nintcount
  local  nvaz_Rp   := (::it_file)->nvaz_Rp
  local  cky       := (::it_file)->ccissklad +(::it_file)->csklpol, recNo
  *
  local cisZalFak := fakvysitw->ncisZalFak

  if cisZalFak <> 0
    vykdph_pw->(dbclearFilter(), dbgotop())

    if fakvysitw->_nrecor = 0
      vykdph_pw->(dbEval({|| vykdph_pw->(dbDelete())}       , ;
                         {|| vykdph_pw->ncisFak = cisZalFak}) )
    else
      vykdph_pw->(dbEval({|| vykdph_pw->_delrec := '9'}     , ;
                         {|| vykdph_pw->ncisFak = cisZalFak}) )
    endif
  endif
  *
  if nvaz_Rp <> 0
    if cenZboz->( dbseek( upper(cky),,'CENIK03'))
      if fakvysi_w->( dbseek( strZero(nvaz_Rp,5),, 'FAKVYSIT_1'))
         recNo := fakvysi_w->( recNo())

         (::it_file)->( dbgoTo(recNo))
         if( cenZboz->ctypSKLpol = 'Y ', (::it_file)->nvaz_Rp := 0  , ;
                                         (::it_file)->_delRec := '9'  )
         ::brow:refreshAll()
      endif
    endif
  endif

  fin_ap_modihd('FAKVYSHDW')
  ::wds_postDelete()
return


method fin_fakvyshd_in:postItemMarked()
  local  o_isParZal := ::dm:has(::it_file +'->nisParZal')

  vykdph_iw->(dbseek(fakvysitw->nradvykdph,,'VYKDPH_5'))

  if( isObject(o_isParZal), o_isParZal:get(), nil )
  ::fin_pro_fakdol:cejPrZbz_push()
return nil


method FIN_fakvyshd_IN:showGroup()
  local  x, odrg, avars, members := ::df:aMembers
  local  panGroup := if((::hd_file)->nfintyp = 5, 'PEN', 'FAK')
  *
  local  one_edt, que_del

  if .not. ::is_ext_fak
    ::drgDialog:dialog:lockUpdate(.t.)
  endif

* off
  aeval(members,{|o| ::modi_memvar(o,.f.)})

* on
  members := if( panGroup = 'FAK', ::members_fak, ::members_pen)
  aeval(members,{|o| ::modi_memvar(o,.t.)})

  if .not. ::is_ext_fak
    ::drgDialog:dialog:lockUpdate(.f.)
  endif


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


  if panGroup = 'FAK'
    one_edt := ::it_file +'->csklpol'
    que_del := ' položku faktury'
  else
    one_edt := ::it_file +'->ncispenfak'
    que_del := ' položku penalizaèní faktury'
  endif

  ::fin_finance_in:init(::drgDialog, 'poh', one_edt, que_del)
  ::dc:oBrowse         := { ::brow:cargo }
  ::drgDialog:odBrowse := { ::brow:cargo }
  ::brow:refreshAll()
  ::infoShow()
return


*
*****************************************************************
METHOD FIN_fakvyshd_IN:destroy()

  ::wds_disconnect()

  fakvyshdw->(dbclosearea())
  fakvysitw->(dbclosearea())
  fakvysi_w->(dbclosearea())
  *
  dodlsthdw->(dbclosearea())
  dodlstitw->(dbclosearea())

  ::drgUsrClass:destroy()
RETURN self