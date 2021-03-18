#include "Appevent.ch"
#include "Common.ch"
#include "Class.ch"
#include "drg.ch"
#include "Gra.ch"
#include "xbp.ch"
//
#include "..\Asystem++\Asystem++.ch"



function FIN_fakturovat_z_bc(col,head)
  LOCAL  finTyp := IF((FAKVYSHD ->nFINTYP > 2 .or. FAKVYSHD->nFINTYP = 6), 2, 1)
  *
  LOCAL  cel := DBGetVal( 'FAKVYSHD ->' +if(finTyp = 1,'nCENZAKCEL', 'nCENZAHCEL')), ;
         uhr := DBGetVal( 'FAKVYSHD ->' +if(finTyp = 1,'nUHRCELFAK', 'nUHRCELFAZ')), ;
         par := DBGetVal( 'FAKVYSHD ->' +if(finTyp = 1,'nPARZALFAK', 'nPARZAHFAK'))
  LOCAL  val := 0, parZal := 0, isIn    // := FIN_fakturovat_z_csym_in()

  do case
  case head = 1
    do case
    case(col = 1) ; val := if( cel == uhr, H_big, if( uhr == 0, 0, H_low ))
    case(col = 2) ; val := if( uhr == par, P_big, if( par == 0, 0, P_low ))
    case(col = 6) ; val := cel
    case(col = 7) ; val := uhr

    case(col = 8)
      isIn := FIN_fakturovat_z_csym_in()

      if isIn
        parZal := DBGetVal( 'fakvysi_w->' +IF(finTyp = 1, 'nPARZALFAK', 'nPARZAHFAK'))
        parZal := parZal * if( fakvysi_w->_delrec = '9', +1, 0 )    // -1)
      endif
      val := uhr -par +parZal

    case(col = 9) ; val := DBGetVal('FAKVYSHD ->' +if(fintyp = 1, 'cZKRATMENY', 'cZKRATMENZ'))
    endcase

  case head = 2
    do case
    case(col = 7)
      val := DBGetVal('FAKVYSITzw->' +if(fintyp = 1, 'nCEJPRKBZ', 'nCEJPRKBZ'))
    case(col = 8)
      val := DBGetVal('FAKVYSITzw->' +if(fintyp = 1, 'nCECPRKDZ', 'nCENZAHCEL'))
    endcase

  case head = 3
    do case
    case(col = 5)
      val := (vyrzakit->nMNOZPLANO -vyrzakit->nMNOZFAKT)
    case(col = 8)
      val :=  MIS_ICON_OK
    endcase

  endcase
RETURN val

static function FIN_fakturovat_z_csym_in()
return fakvysi_w->( dbseek( fakvysi_w->ncisZalFak,, 'FAKVYSIT_2'))


*
**
class FIN_fakturovat_z_vld
exported:
  method init, fakturovat_z_sel, favst_padz
  method takeValue

hidden:
  var    dm, df, udcp, curr_var, iz_file

  method            favst_mnoD, favst_dph, favst_vyz, favst_czns, favst_rv, favst_czpc
  method            favst_parz
  method            favst_pen

  method            favst_procSlev


  inline method show_KDis(citem, xval)
    local ovar := ::dm:has(citem)

    if( isObject(ovar), ovar:set(xval), nil)
  return

endclass

method FIN_fakturovat_z_vld:init(parent)
return self

*
**   fin_fakvyshd_in/fin_fakvnphd_in              - postValidate
***  dodsltit, vyrzakit, objitem, fakprihd, cenzboz - postAppend povolí/zakáže editaci
method FIN_fakturovat_z_vld:fakturovat_z_sel(drgDialog)
  local odialog, nexit, showDlg := .t., odrg := drgDialog:lastXbpInFocus:cargo
  *
  local items , isfav, value, filter, cf, hd_file, it_file, iz_file, iz_pos, ft_pos
  local cisFir, recCnt, finTyp, parTyp
  local ovar
  local pa, x
  local pa_parZal := {}
  *
  local ctagName

  *
  ::dm       := drgDialog:dataManager
  ::df       := drgDialog:oForm
  ::udcp     := drgDialog:udcp
  values     := drgDialog:dataManager:vars:values
    size     := drgDialog:dataManager:vars:size()
  hd_file    := drgDialog:udcp:hd_file
   recCnt    := 0
  *
  drgDBMS:open('kusov')
  *
  if IsObject(odrg)
    items                := Lower(drgParseSecond(odrg:name,'>'))
    isfav                := (Lower(drgParse(odrg:name,'-')) = 'fakvysitw')
    value                := drgDialog:lastXbpInFocus:value
    it_file              := Lower(drgParse(odrg:name,'-'))
    ::iz_file := iz_file := if(items = 'ncislodl'   , 'dodlstit'  , ;
                            if(items = 'cciszakazi' , 'vyrzakit'  , ;
                            if(items = 'ccislobint' , 'objitem'   , ;
                            if(items = 'nciszalfak' , 'fakvyshd'  , ;
                            if(items = 'ncispenfak' , 'fakvyshd_p', 'cenzboz' )))))

    do case
    case(items = 'ncislodl'  )                   // - dodlstit -
      iz_pos     := 2

      if isfav
        cisFir := strzero(fakvyshdw->ncisfirmy,5)
        cf     := "strzero(ncisfirmy,5) = '%%'" +if( .not. empty(value)," .and. ndoklad = %%", '')
        filter := format(cf, if(empty(value),{cisFir},{cisFir,value}))
      else
        if .not. empty(value)
          cf     := "strzero(ndoklad,10) = '%%'"
          filter := format(cf,{strzero(value,10)})
        endif
      endif

    case(items = 'cciszakazi' )                   // - vyrzakit -
      iz_pos   := 3
      do case
      case isfav
        cf     := "ncisfirmy = %%"  +if( .not. empty(value)," .and. cciszakazi = '%%'", '')
        filter := format(cf, if(empty(value),{fakvyshdw->ncisfirmy},{fakvyshdw->ncisfirmy,value}))
      otherwise

        do case
        case(it_file = 'fakvnpitw')
          cf     := "cnazpol1 = '%%'" +if( .not. empty(value)," .and. cciszakazi = '%%'", '')
          filter := format(cf, if(empty(value),{fakvnphdw->cnazpol1},{fakvnphdw->cnazpol1,value}))

        case(it_file = 'explstitw')
          if .not. empty(value)
            cf     := "cciszakazi = '%%'"
            filter := format(cf,{value})
          endif

        otherwise
          cf     := "ncisfirmy = %%"  +if( .not. empty(value)," .and. cciszakazi = '%%'", '')
          filter := format(cf, if(empty(value),{(hd_file)->ncisfirmy},{(hd_file)->ncisfirmy,value}))
        endcase
      endcase

    case(items = 'ccislobint')                   // - objitem -
      iz_pos := 4
      cf     := "ncisfirmy = %%" +if( .not. empty(value)," .and. ccislobint = '%%'", '')
      filter := format(cf, if(empty(value),{(hd_file)->ncisfirDOA},{(hd_file)->ncisfirDOA,value}))

    case(items = 'nciszalfak')                   // - fakvyshd & fakvysit -
      fordRec({'fakvyshd'})

      finTyp := fakvyshdw->nfinTyp
      parTyp := if(finTyp = 1, 2, 4)
      iz_pos := 5
      cisFir := strzero(fakvyshdw->ncisfirmy,5)
      cf     := ::udcp:m_sel_filter +if( .not. empty(value)," .and. ncisfak = %%", '')

      filter := format( cf, if(empty(value),{},{value}) )

    case(items = 'ncispenfak')                   // - penalizace
      finTyp := fakvyshdw->nfinTyp
      parTyp := if(finTyp = 1, 2, 4)
      iz_pos := 7
      cisFir := strzero(fakvyshdw->ncisfirmy,5)

      cf     := "strzero(ncisfirmy,5) = '%%'"            + ;
                " .and. nfinTyp <> 2 .and. nfinTyp <> 4" + ;
                " .and. dposUhrFak > dsplatFak"          + ;
                if( .not. empty(value)," .and. ncisfak = %%", '')
      filter := format(cf, if(empty(value),{cisFir},{cisFir,value}))

    case(items = 'csklpol')                      // - cenzboz -
      iz_pos   := 6
      ctagName := 'CENIK01'

      if( select(iz_file) = 0, drgDBms:open(iz_file), nil)
      *
      ** nový parametr by nemuseli vybírat pokud je položka na více skladech
      if isCharacter( cPRIsklPRO := sysConfig( 'Finance:cPRIsklPRO' ))
        if .not. empty(cPRIsklPRO)
          ctagName := 'CENIK03'
          value    := cPRIsklPRO +value
        endif
      endif

      cenzboz->(AdsSetOrder(ctagName)              , ;
                dbsetscope(SCOPE_BOTH,upper(value)), ;
                dbgotop()                          , ;
                dbeval( {|| recCnt++ })            , ;
                dbgotop()                            )

      showDlg := .not. (recCnt = 1)
      if(recCnt = 0, cenzboz->(dbclearscope(),dbgotop()), nil)

    otherwise
      return .t.

    endcase

    if( select(iz_file) = 0, drgDBms:open(iz_file), nil)
**    ::lastOk_sid := (iz_file)->sID

    if .not. empty(filter)
      (iz_file)->(ads_setAof(filter),dbgotop())

      * zadal chybnou hodnotu - value/ pro výbìr jen základní filtr
      if (iz_file) ->(eof()) .and. .not. empty(value)
        if(ft_pos := rat('.and.',filter)) <> 0
           filter := substr(filter,1,ft_pos-1)
           (iz_file)->(ads_clearAof(), ads_setAof(filter), dbgotop())
        else
          (iz_file)->(ads_clearAof(), dbgotop())
        endif
      endif

      * n - položek pro daný klíè, nebo zálohová faktura -> nabízíme výbìr
      showDlg := (items = 'nciszalfak') .or. ((iz_file)->( ads_getKeyCount(1)) > 1)
    endif

    if showDlg
      odialog := drgDialog():new('FIN_fakturovat_z_SEL',drgDialog)
      odialog:create(,,.T.)
      nexit := odialog:exitState

*--      odialog:destroy()
*--      odialog := nil
    endif

    if .not. showDlg .or. (nexit != drgEVENT_QUIT)

      * ukládáme vybrané položky v cyklu
      if showDlg .and. odialog:udcp:sp_saved .and. isMethod(::udcp, 'sp_overPostLastField')
        pa := odialog:udcp:d_bro:arselect
        for x := 1 to len(pa) step 1
          (iz_file)->(dbgoto(pa[x]))

          * tohle je šílená a stále nedoøešená chyba na drgVar
          * v metodì refresh jsme zavedli kovenci inBrow tj.
          * test SetAppFocus():className() = 'XbpBrowse', pokud jedu v kruhu získá fokus
          * právì BRO a pak se chybnì naètou hodnoty do drgVar

          setAppFocus(odrg:oxbp)
          ::takeValue(it_file,iz_file,iz_pos)
          ::udcp:sp_overPostLastField()

          nexit := drgEVENT_EDIT
        next
      else

        ::takeValue(it_file,iz_file,iz_pos)
        if(isMethod(::udcp, 'showGets'), ::udcp:showGets(,.t.), nil)
        PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,drgDialog:lastXbpInFocus)
        nexit := drgEVENT_EDIT
      endif

      * tady se s tím nebudeme trápit, prostì to hodíme do mema pokud tam je nìjaká vazba
*      if iz_file = 'cenzboz' .and. isObject(ovar := ::dm:has(it_file +'->mapolSest'))
      if isObject(ovar := ::dm:has(it_file +'->mapolSest'))
        ovar:set( ::fin_mapolSest_in(hd_file) )
      endif
    endif


    if(items = 'nciszalfak')  ; fakvyshd->(ads_clearAof(), dbclearScope())
                                fordRec()

    else                      ; (iz_file)->(ads_clearAof())
                                (iz_file)->(dbclearscope())
    endif
  endif
RETURN (nexit != drgEVENT_QUIT)


method FIN_fakturovat_z_vld:takeValue(it_file,iz_file,iz_pos, o_udcp)
  local  x, pos, value, items, mname, par, iz_recs := (iz_file)->(recno()), nullDph
  local  mnozReODB := 0
  local  m_dm      := ::dm

* fakvys/vnpitw,     dodlstit,       vyrzakit,        objitem,      fakvyshd,         cenzboz  ,    fakvyshd_p
*
  local  pa := { ;
{      'cskp',             '',         'cskp',             '',              '',               '',             '' }, ;
{ 'ccissklad',    'ccissklad',             '',    'ccissklad',              '',      'ccissklad',             '' }, ;
{ 'ncislodl' ,    'ndoklad'  ,              0,              0,               0,                0,              0 }, ;
{ 'cciszakaz',    'cciszakaz',    'cciszakaz',             '',              '',               '',             '' }, ;
{'cciszakazi',   'cciszakazi',   'cciszakazi',             '',              '',               '',             '' }, ;
{'ccislobint',             '',             '',   'ccislobint',              '',               '',             '' }, ;
{'nciszalfak',              0,              0,              0,       'ncisfak',                0,              0 }, ;
{'ncispenfak',              0,              0,              0,               0,                0,      'ncisfak' }, ;
{   'csklpol',      'csklpol',             '',      'csklpol',              '',        'csklpol',             '' }, ;
{ 'nzbozikat',     'nzbozikat',             0,    'nzbozikat',               0,      'nzbozikat',              0 }, ;
{   'cnazzbo',      'cnazzbo',   'cnazevzak1',      'cnazzbo', ':favst_parz/1',        'cnazzbo', ':favst_pen/4' }, ;
{ 'nfaktmnoz',    'nfaktmnoz', ':favst_vyz/1',':favst_mnoD/3', ':favst_parz/2',                0, ':favst_pen/1' }, ;
{'czkratjedn',   'czkratjedn', ':favst_vyz/2',   'czkratjedn', ':favst_parz/3',     'czkratjedn',             '' }, ;
{ 'ncenazakl',    'ncenazakl',      'ncenamj',              0,               0,      'ncenapzbo',              0 }, ;
{  'nprocdph', ':favst_dph/1', ':favst_dph/2', ':favst_dph/3',               0,   ':favst_dph/5',              0 }, ;
{ 'ncejprzbz',    'ncejprzbz',      'ncenamj',    'ncenazakl', ':favst_parz/4',  ':favst_czpc/5',              0 }, ;
{ 'nhodnslev',    'nhodnslev',              0,    'nhodnslev',               0,                0,              0 }, ;
{ 'nprocslev',    'nprocslev',              0,    'nprocslev',               0,                0,              0 }, ;
{ 'ncejprkdz',    'ncejprkdz',              0,              0,               0,      'ncenamzbo',              0 }, ;
{ 'ncecprkbz',              0,              0,              0,               0,                0,              0 }, ;
{ 'ncelkslev',    'ncelkslev',              0,    'ncelkslev',               0,                0,              0 }, ;
{ 'ncecprkbz',    'ncecprkbz',              0,              0,               0,                0,              0 }, ;
{ 'ncecprkdz',    'ncecprkdz',              0,    'nkcszdobj',               0,                0,              0 }, ;
{ 'cdoplntxt',    'cdoplntxt',             '',    'cdoplntxt',              '',               '', ':favst_pen/2' }, ;
{     'cucet',        'cucet',   'cucettrzeb',':favst_czns/0',     'cucet_Uct',  ':favst_czns/0',             '' }, ;
{  'cnazpol1',     'cnazpol1',     'cnazpol1',':favst_czns/1',              '',  ':favst_czns/1',             '' }, ;
{  'cnazpol2',     'cnazpol2',     'cnazpol2',':favst_czns/2',              '',  ':favst_czns/2',             '' }, ;
{  'cnazpol3',     'cnazpol3',     'cnazpol3',':favst_czns/3',              '',  ':favst_czns/3',             '' }, ;
{  'cnazpol4',     'cnazpol4',     'cnazpol4',':favst_czns/4',              '',  ':favst_czns/4',             '' }, ;
{  'cnazpol5',     'cnazpol5',     'cnazpol5',':favst_czns/5',              '',  ':favst_czns/5',             '' }, ;
{  'cnazpol6',     'cnazpol6',     'cnazpol6',':favst_czns/6',              '',  ':favst_czns/6',             '' }, ;
{  'ncountdl',    'nintcount',              0,              0,               0,                0,              0 }, ;
{'ncislPolob',              0,              0,   'ncislPolob',               0,                0,              0 }, ;
{'ncisPOLzak',              0,     'nordItem',              0,               0,                0,              0 }, ;
{'nradvykdph',  ':favst_rv/1',  ':favst_rv/1',  ':favst_rv/1', ':favst_parz/5',    ':favst_rv/1',              0 }, ;
{'ncelpenfak',               ,               ,               ,                ,                 ,   'ncenzahcel' }, ;
{ 'dsplatfak',               ,               ,               ,                ,                 ,    'dsplatfak' }, ;
{'dposuhrfak',               ,               ,               ,                ,                 ,   'dposuhrfak' }, ;
{'nuhrcelfaz',               ,               ,               ,                ,                 ,   'nuhrcelfaz' }, ;
{'ncenpencel',               ,               ,               ,                ,                 ,   'ncenzahcel' }, ;
{  'npen_odb',               ,               ,               ,                ,                 , ':favst_pen/3' }, ;
{ 'ncenaSzbo',    'ncenaSzbo',              0,              0,               0,      'ncenaSzbo',              0 }, ;
{'nhmotnostj',   'nhmotnostj',    'nhmotnost',   'nhmotnostj',               0,      'nhmotnost',              0 }, ;
{   'nobjemj',      'nobjemj',       'nobjem',      'nobjemj',               0,         'nobjem',              0 }  }


  if( isObject(o_udcp), (::dm := o_udcp:dm, ::iz_file := iz_file, ::udcp := o_udcp),  nil )

  for x := 1 to len(pa) step 1
    if IsObject(ovar := ::dm:has(it_file +'->' +pa[x,1]))

      ::curr_var := ovar

      do case
      case empty(pa[x,iz_pos])
        value := pa[x,iz_pos]

      case at(':', pa[x,iz_pos]) <> 0
        items := strtran(pa[x,iz_pos],':','')
        mname := substr(items,1,at('/',items) -1)
        par   := val(substr(items,  at('/',items) +1))
        value := self:&mname(par)

      otherwise
        value := DBGetVal(iz_file +"->" +pa[x,iz_pos])
      endcase

      ovar:set(value)
      ovar:initValue := ovar:prevValue := value

      * nìkdo nastavuje relaèní vazby na DB - pak dojde k repozici na postValidateRelate
      * hlavnì u cenzboz tam je klíè ccisSklad +csklPol
      * nastavení relace jen na csklPol je chybé !!!
      if iz_recs <> 0
        if( iz_recs <> (iz_file)->(recno()), (iz_file)->(dbgoto(iz_recs)), nil )
      endif
    endif
  next

  if( IsObject(ovar := ::dm:has(it_file +'->cfile_iv')), ovar:set(iz_file), nil)
  if( IsObject(ovar := ::dm:has(it_file +'->nrecs_iv')), ovar:set(iz_recs), nil)

  *
  ** vazba na daòové doklady zùètování záloh vystavených
  ** nisParZal 1 - není DD / 2 - je DD
  if iz_file = 'fakvyshd'
    ovar := ::dm:has(it_file +'->nisParZal')

    if( ::favst_padz(),  ovar:set(2),  ovar:set(1))

    nullDph   := if(fakvyshdw->nfinTyp > 2 .or. fakvyshdw->nfinTyp = 6, 14, 4)
    if(isObject(ovar := ::dm:has(it_file +'->nnullDph')), ovar:set(nullDph), nil)
  endif

  * pokud fakturuji z objitem musím naplnit ncenaSzbo z cenzboz
  if iz_file = 'objitem'
    cenzboz->(dbseek( upper(objitem->ccisSklad) +upper(objitem->csklPol),,'CENIK03'))

    mnozReODB := objitem->nmnozReODB
         ovar := ::dm:has(it_file +'->ncenaszbo')
    if( isobject(ovar), ovar:set(cenzboz->ncenaSzbo), nil)
  endif

  * pokud fakturuji z cenZboz skusíme upatnit slevu/pøirážku
  if( (it_file = 'fakvysitw' .and. iz_file = 'cenzboz'), ::favst_procSlev(), nil )

  ::show_kDis('M->cenzboz_kDis' , ::udcp:cenzboz_kDis +mnozReODB)
  ::show_kDis('M->dodlstit_kDis', ::udcp:dodlstit_kDis          )
  ::show_kDis('M->objitem_kDis' , ::udcp:objitem_kDis           )
  ::show_kDis('M->vyrzak_kDis'  , ::udcp:vyrzak_kDis            )

  ::dm := m_dm
return


method fin_fakturovat_z_vld:favst_mnoD(par)
  local mnozDzbo := 0

  do case
  case( par = 1 )  ;  mnozDzbo := ::wsd_dodlstit_kDis()
  case( par = 2 )  ;  mnozDzbo := ::wsd_vyrzakit_kDis()
  case( par = 3 )  ;  mnozDzbo := ::wsd_objitem_kDis()
  endcase
return mnozDzbo

*
** fakturuji z cenZboz - nová promìnná ngetProCen 0 - ncenaPzbo / 1 - ncenaSzbo
method fin_fakturovat_z_vld:favst_czpc(par)
return if( cenZboz->ngetProCen = 0, cenZboz->ncenaPzbo, cenZboz->ncenaSzbo )

*
** zavedena koncence pro pøednastavení procDph
** 1 - osvobozeno, 2- snížená, 3- základní
** pokud je 1 vypnìna a 2,3 je prázdná pøednastvujeme 0
*
method FIN_fakturovat_z_vld:favst_dph(par)
  local  aiz     := {'dodlstit','vyrzakit','objitem','','cenzboz'}
  local  klicDph := DBGetVal(aiz[par] +'->nklicdph'), procDph
  *
  local  hd_file := ::dm:drgDialog:dbname
  local  cky     := upper((hd_file)->culoha    ) + ;
                    upper((hd_file)->ctypdoklad) + ;
                    upper((hd_file)->ctyppohybu)

  if(select('c_typpoh') = 0, drgDBms:open('c_typpoh'), nil)
  c_typpoh->(dbseek(cky,,'C_TYPPOH05'))

  if .not. empty(cradDph := c_typpoh->craddph)
    pa       := listasarray(cradDph)
    pa       := asize(pa,3)

    procDph  := if(empty(pa[2]) .and. empty(pa[3]), 0, nil)
  endif

  if isNull(procDph)
    drgDBms:open('c_dph')
    c_dph->(dbseek(klicDph,,'C_DPH1'))

    procDph := if(::curr_var:odrg:oxbp:visible, c_dph->nprocdph, 0)
  endif
return procDph


method FIN_fakturovat_z_vld:favst_vyz(par)
  local  retVal

  drgDBms:open('vyrpol')
  vyrpol->(dbseek(vyrzakit->(sx_keydata()),,'VYRPOL1'))

  if par = 1  ; retval := vyrzakit->nmnozplano - vyrzakit->nmnozfakt
  else        ; retVal := vyrpol->czkratjedn
  endif
return retVal

method FIN_fakturovat_z_vld:favst_czns(par)
  local retVal, cin_File
  *
  local hd_file := ::dm:drgDialog:udcp:hd_file
  local cky     := upper((hd_file)->culoha    ) + ;
                   upper((hd_file)->ctypdoklad) + ;
                   upper((hd_file)->ctyppohybu) + upper(cenzboz->cucetskup)

  if(select('cenZb_ns') = 0, drgDBms:open('cenZb_ns'), nil)
  if(select('ucetprit') = 0, drgDBms:open('ucetprit'), nil)

  if cenZb_ns->( dbseek( upper((hd_file)->ctyppohybu) +upper(cenzboz->ccisSklad) +upper(cenZboz->csklPol),,'CENZBNS3') )
    cin_File := 'cenZb_ns'
  else
    ucetprit->(dbseek(cky,,'UCETPRIT01'))
    cin_File := 'ucetPrit'
  endif

  do case
  case(par = 0)  ;  retVal := if( cin_File = 'cenZb_ns', (cin_File)->cucet, (cin_File)->cucetmd )
  case(par = 1)  ;  retVal := (cin_File)->cnazpol1
  case(par = 2)  ;  retVal := (cin_File)->cnazpol2
  case(par = 3)  ;  retVal := (cin_File)->cnazpol3
  case(par = 4)  ;  retVal := (cin_File)->cnazpol4
  case(par = 5)  ;  retVal := (cin_File)->cnazpol5
  case(par = 6)  ;  retVal := (cin_File)->cnazpol6
  endcase
return retVal


method FIN_fakturovat_z_vld:favst_rv(par)
  local retVal    := '0', cradDph, pa, ovar
  local typPreDan, klicDph, procDphPP := 0, napocetPP := 0
  *
  local it_file := ::dm:drgDialog:udcp:it_file
  local hd_file := ::dm:drgDialog:udcp:hd_file
  local cky     := upper((hd_file)->culoha    ) + ;
                   upper((hd_file)->ctypdoklad) + ;
                   upper((hd_file)->ctyppohybu)
  *
  local duzp    := (hd_file)->dpovinfak
  *
  ** od 1.4.2011 je provedena úprava pro pøenesení daòové povinnosti na odbìratele
  if FIN_c_vykdph_ndat_od( duzp ) >= 20110401
    if (::iz_file)->(FieldPos( 'ctypPreDan' )) <> 0
       typPreDan := (::iz_file)->ctypPreDan

       if .not. empty(typPreDan)
         *
         ** Režim pøenesení daò. pov.(§ 92a) dodavatel
         ** nprocDph   := 0
         ** ctypPreDan := (::iz_file)->ctypPreDan
         ** nprocDPHpp := % DPH podle nklicDph
         ** nnapocetPP := c_dph->nnapocet
         ** ::typPreDan( 25 )
         *
         if isObject(ovar := ::dm:has(it_file +'->nprocDph'  ))
           ovar:set(0)
           ovar:initValue := ovar:prevValue := 0
         endif

//         if( isObject(ovar := ::dm:has(it_file +'->nprocDph'  )), ovar:set(0)        , nil)
         if( IsObject(ovar := ::dm:has(it_file +'->ctypPreDan')), ovar:set(typPreDan), nil)

         if (::iz_file)->(FieldPos( 'nklicDph' )) <> 0
           klicDph := (::iz_file)->nklicDph
           c_dph->(dbseek( klicDph,,'C_DPH1'))
           procDphPP := c_dph->nprocDph
           napocetPP := c_dph->nnapocet
         endif
         if( IsObject(ovar := ::dm:has(it_file +'->nprocDphPP')), ovar:set(procDphPP), nil)
         if( IsObject(ovar := ::dm:has(it_file +'->nnapocetPP')), ovar:set(napocetPP), nil)
         ::typPreDan( 25 )

         return 25
       endif
    endif
  endif

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
return val(retVal)


method FIN_fakturovat_z_vld:favst_padz(ncisZalFak)
  local  cky := upper(fakVysHDw->cdenik) +strZero(::dm:get('fakvysitw->ncisZalFak'), 10)
  local  pky
  local  lis_zal := .f., lnewRec

  if isNumber(ncisZalFak)
    cky := upper(fakVysHDw->cdenik) +strZero( ncisZalFak, 10)
  endif

  vykdph_i->(AdsSetOrder('VYKDPH_5'), dbsetscope(SCOPE_BOTH,cky), dbgotop())
  do while .not. vykdph_i->(eof())

    pky := upper(vykdph_i->cdenik_Par)     + ;
           strZero(vykdph_i->ncisFak, 10)  + ;
           strZero(vykDph_i->ndoklad_Or,10)+ ;
           strZero(vykDph_i->noddil_Dph,2) + ;
           strZero(vykDph_i->nradek_Dph,3)

    * daòové doklady
    if vykdph_i->ndoklad = vykdph_i->ndoklad_or
      lnewRec := .not. vykdph_Pw->( dbseek( pky,,'VYKDPH_3'))

      mh_copyFld('vykdph_i','vykdph_pw', lnewRec, .f.)
      *
      lis_zal := .t.
      *
      vykdph_pw->ndoklad    := fakvyshdw->ncisFak
      vykdph_pw->cdenik     := fakvyshdw->cdenik
      vykdph_pw->cobdobi    := fakvyshdw->cobdobi
      vykdph_pw->nrok       := fakvyshdw->nrok
      vykdph_pw->nobdobi    := fakvyshdw->nobdobi
      vykdph_pw->cobdobiDan := fakvyshdw->cobdobiDan
      vykdph_pw->nzakld_zal := vykdph_pw->nzakld_or
      vykdph_pw->nsazba_zal := vykdph_pw->nsazba_or
      *
      ucetdohd->(dbseek(upper(vykdph_i->cdenik_par) +strzero(vykdph_i->ncisFak,10),,'UCETDH_7'))
      vykdph_pw->cucetu_dok := ucetdohd->cucet_uct
      *
      vykdph_pw->nUhrCelFAK := ucetdohd->nUhrCelFAK
      vykdph_pw->nUhrCelFAZ := ucetdohd->nUhrCelFAZ
      vykdph_pw->cZkratMenF := ucetdohd->cZkratMenF
      vykdph_pw->nKurzMenU  := CoalesceEmpty(ucetdohd->nKurzMenU,1)
      vykdph_pw->nMnozPreU  := CoalesceEmpty(ucetdohd->nMnozPreU,1)
**      vykdph_pw->cky_pz     := cky_pz
      *
      vykdph_pw->nzakld_dph := vykdph_pw->nzakld_zal * (-1)
      vykdph_pw->nsazba_dph := vykdph_pw->nsazba_zal * (-1)
      vykdph_pw->lis_zal    := .t.
      vykdph_pw->nporadi    := 1
      *
    endif
    vykdph_i->(dbskip())
  enddo

  vykdph_i->(dbGoTop())
  vykdph_pw->(dbCommit())

  do while .not. vykdph_i->(eof())
    * jedná se o již párovanou zálohu
    if vykdph_i->ndoklad <> vykdph_i->ndoklad_or
      pky := strZero(vykdph_i->ndoklad_or,10) +strZero(vykdph_i->noddil_DPH,2) +strZero(vykdph_i->nradek_DPH,3)
      if  vykdph_pw->(dbSeek(pky,,'VYKDPH_7'))
        vykdph_pw->nzakld_zal += vykdph_i->nzakld_dph
        vykdph_pw->nsazba_zal += vykdph_i->nsazba_dph
        *
        vykdph_pw->nzakld_dph := vykdph_pw->nzakld_zal * (-1)
        vykdph_pw->nsazba_dph := vykdph_pw->nsazba_zal * (-1)
      endif
    endif
    vykdph_i->(dbSkip())
  enddo
return lis_zal


method FIN_fakturovat_z_vld:favst_parz(par)
  do case
  case(par = 1)
    return 'FAK_' +alltrim(str(fakVyshd->ncisFak)) +' odpoèet zálohy'
  case(par = 2)
    return -1
  case(par = 3)
    return 'x'
  case(par = 4)
    return FIN_fakturovat_z_bc(8,1)
  case(par = 5)
    * 29.6.2011 oprava dle požadavku - RV := 0
    return 0
**    return 1
  endcase
return nil

method FIN_fakturovat_z_vld:favst_pen(par)
  local  posUhr := fakvyshd_p->dposUhrFak
  local  splFak := fakvyshd_p->dsplatFak
  *
  local  retVal

  do case
  case(par = 1)
    retVal := if(empty(posUhr), 0, posUhr -splFak)
    return max(0, retVal)

  case(par = 2)
    retVal :=  'K Fak_è '   +allTrim( str( fakvyshd_p->ncisFak))    + ;
               ' na '       +allTrim( str( fakvyshd_p->ncenZahCel)) + ;
               ' splatná, ' +dtoc(fakvyshd_p->dsplatFak)
  case(par = 3)
    retVal := 0.05

  case(par = 4)
    retVal := 'Penále k fak_è, ' +allTrim( str( fakvyshd_p->ncisFak))
  endcase
return retVal

*
** vazba na procenho
method FIN_fakturovat_z_vld:favst_procSlev()
  local  it_file := ::dm:drgDialog:udcp:it_file
  local  hd_file := ::dm:drgDialog:udcp:hd_file
  *
  local  filtr, m_filtr, procento := 0
  local  o_cisSklad  := ::dm:has(it_file +'->ccisSklad' ), ;
         o_sklPol    := ::dm:has(it_file +'->csklPol'   ), ;
         o_zboziKat  := ::dm:has(it_file +'->nzboziKat' )
*
  local  o_cejprzbz  := ::dm:has(it_file +'->ncejprzbz' ), ;
         o_procSlev  := ::dm:has(it_file +'->nprocSlev' ), ;
         o_hodnSlev  := ::dm:has(it_file +'->nhodnSlev' ), ;
         o_cejPrKDZ  := ::dm:has(it_file +'->ncejPrKDZ' )
  *
  local cisFirmy := (hd_file)->ncisFirmy, zkrTypUhr := (hd_file)->czkrTypUhr, dvystFak := (hd_file)->dvystFak
  *
  local cisSklad := o_cisSklad:value    , sklPol    := o_sklPol:value       , zboziKat := o_zboziKat:value
  local cejprzbz := o_cejprzbz:value
  local m_cky    := upper(cisSklad) +upper(sklPol)

  drgDBMS:open('procenho')
  drgDBMS:open('cenprodc')

  filtr := "ntypProCen = 9 .and. "                                  + ;
           "  (ncisFirmy = %% .or. ncisFirmy = 0) .and. "           + ;
           "( (ccisSklad = '%%' .and. csklPol = '%%') .or. nzboziKat = %% .or. contains(czkrTypUhr,'%%') )"

  m_filtr := format( filtr, {cisFirmy, cisSklad, sklPol, zboziKat, zkrTypUhr})

  procenho->(ads_setAof(m_filtr),dbgoTop())
  cenprodc->(dbseek( m_cky,,'CENPROD1'))
  *
  if .not. procenho->(eof())
    procenho->(dbsetFilter( { || is_datumOk(dvystFak) }))

    do case
    case( procenho->(dbseek(m_cky   ,,'PROCENHO09')))
       procento := procenho->nprocento

    case( procenho->(dbseek(zboziKat,,'PROCENHO10')))
       procento := procenho->nprocento

    case( procenho->(dbseek( upper(zkrTypUhr),,'PROCENHO16')))
       procento := procenho->nprocento
    endcase
  endif

  procento := procento * -1

  o_procSlev:set( procento )
  o_hodnSlev:set( (cejprzbz * procento) / 100 )
  o_cejPrKDZ:set( cejprzbz - o_hodnSlev:value )
return procento

static function is_datumOk(datum)
  local  ok :=  empty(procenho->dplatnyOD) .or. ;
                (procenho->dplatnyOD <= datum .and. procenho->dplatnyDO >= datum)
return ok
**
*


*
** CLASS FIN_fakturovat_z_SEL *************************************************
** základní tøída pro kontrolu/nabídku fakvysitw/fakvnpitw
function fin_fakturovat_z_sel_is(ocol_is)
  local xval := ocol_is:getData()
return (xval = 6001)


CLASS FIN_fakturovat_z_SEL FROM drgUsrClass
EXPORTED:
  method  init, getForm, drgDialogInit, drgDialogStart, drgDialogEnd, itemMarked
  method  createContext, fromContext
  *
  method  mark_doklad, save_marked

  var     m_udcp, sp_saved, d_bro

  * CENZBOZ ceníková položka / sestava
  inline access assign method cenPol() var cenPol
    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method isSest() var isSest
    local  retVal := 0, cky := space(30) +upper(cenzboz->csklPol)

    if cenzboz->ctypSklPol = 'S '
      retVal := if( kusov->(dbSeek(cky,,'KUSOV1')), MIS_BOOKOPEN, MIS_BOOK)
    endif
    return retVal

  * k ceníkové položceje pøipojen recyklaèní polatek
  inline access assign method isSetCenZboz_Rp() var isSetCenZboz_Rp
    local  retVal := 0, cky := upper(cenZboz->ccissklad) +upper(cenZboz->csklpol)

    if cenZb_rp->( dbseek( upper(cky),, 'CENZBRP1' ))
      retVal := 511  // m_append2.bmp"
    endif
  return retVal

  *
  ** DODLSTIT stav / ceníková položka / k dispozici na skladu / _?_ k fakturaci
  inline access assign method dodlstit_is() var dodlstit_is
    return if(::m_udcp:wsd_dodlstit_kDis <> 0, 6001, 0)

*  inline access assign method dodlstit_cp() var dodlstit_cp
*    local  cky := upper(dodlstit->ccisSklad) +upper(dodlstit->csklPol)
*    cenzboz->(dbseek(cky,, 'CENIK03'))
*    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method dodlstit_cp() var dodlstit_cp
    local  cky := upper(dodlstit->ccisSklad) +upper(dodlstit->csklPol)
    *
    local  cenzboz_kDis, dodlstit_kDis, retVal := 0

    cenzboz->(dbseek(cky,, 'CENIK03'))

    if cenzboz->cpolcen = 'C'
      cenzboz_kDis  := ::m_udcp:wds_cenzboz_kDis
      dodlstit_kDis := ::m_udcp:wsd_dodlstit_kDis

      do case
      case cenzboz_kDis = 0 .and. dodlstit_kDis =  0  ; retVal := MIS_NO_RUN
      case cenzboz_kDis = 0 .and. dodlstit_kDis <> 0  ; retVal := MIS_ICON_ERR
      case cenzboz_kDis      >=   dodlstit_kDis       ; retVal := MIS_ICON_OK
      otherwise                                       ; retVal := 6002
      endcase
    endif
    return retVal

  inline access assign method dodlstit_sdm() var dodlstit_sdm
    local  cky := upper(dodlstit->ccisSklad) +upper(dodlstit->csklPol)
    cenzboz->(dbseek(cky,, 'CENIK03'))
    return ::m_udcp:wds_cenzboz_kDis

  inline access assign method mnozKFak_dl() var mnozKFak_dl
    local  nmnozVy := ( dodlstit->nmnoz_fakt +dodlstit->nmnoz_dlvy + ;
                        dodlstit->nmnoz_objp +dodlstit->nmnoz_expl +dodlstit->nmnoz_zak )
    return dodlstit->nfaktMnoz -nmnozVy

  *
  ** OBJITEM stav/ ceníková položka/ k dispozici na skladu
  inline access assign method objitem_is() var objitem_is
    return if(::m_udcp:wsd_objitem_kDis <> 0, 6001, 0)

*  inline access assign method objitem_cp() var objitem_cp
*    local  cky := upper(objitem->ccisSklad) +upper(objitem->csklPol)
*    cenzboz->(dbseek(cky,, 'CENIK03'))
*    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method objitem_cp() var objitem_cp
    local  cky := upper(objitem->ccisSklad) +upper(objitem->csklPol)
    *
    local  cenzboz_kDis, objitem_kDis, retVal := 0

    cenzboz->(dbseek(cky,, 'CENIK03'))

    if cenzboz->cpolcen = 'C'
      cenzboz_kDis := ::m_udcp:wds_cenzboz_kDis
      objitem_kDis := ::m_udcp:wsd_objitem_kDis

      do case
      case cenzboz_kDis = 0 .and. objitem_kDis =  0  ; retVal := MIS_NO_RUN
      case cenzboz_kDis = 0 .and. objitem_kDis <> 0  ; retVal := MIS_ICON_ERR
      case cenzboz_kDis      >=   objitem_kDis       ; retVal := MIS_ICON_OK
      otherwise                                      ; retVal := 6002
      endcase
    endif
    return retVal

  inline access assign method objitem_sdm() var objitem_sdm
    local  cky := upper(objitem->ccisSklad) +upper(objitem->csklPol)
    cenzboz->(dbseek(cky,, 'CENIK03'))
    return ::m_udcp:wds_cenzboz_kDis +objitem->nmnozReODB

  * VYRZAKIT stav
  inline access assign method vyrzakit_is() var vyrzakit_is
    return if(::m_udcp:wsd_vyrzakit_kDis <> 0, 6001, 0)

  * FAKVYSHD - H_razeno/ P_árováno/ D_ny pøekroèené splatnosti
  inline access assign method cradek_dph() var cradek_dph
    local  cky := strZero(vykdph_pw ->noddil_dph,2) + ;
                  strZero(vykdph_pw ->nradek_dph,3) + ;
                  strZero(vykdph_pw ->ndat_od,8)

    c_vykdph->(dbSeek(cky,,'VYKDPH4'))
    return(c_vykDph->cradek_say)

  inline access assign method preDanPov() var preDanPov
    return if( vykDph_pw->lpreDanPov, MIS_CHECK_BMP, 0)


  inline access assign method fakvyshd_p_uhr() var fakvyshd_p_uhr
    local  cenZak := fakvyshd_p->ncenZakCel
    local  uhrCel := fakvyshd_p->nuhrCelFak
    local  retVal := 0
    return if( cenZak == uhrCel, H_big, If( uhrCel == 0, 0, H_low ) )

  inline access assign method fakvyshd_p_pen() var fakvyshd_p_pen
    return if( .not. empty(fakvyshd_p->ddatPenFak), MIS_ICON_OK, 0)

  inline access assign method fakvyshd_p_dny() var fakvyshd_p_dny
    local posUhr := fakvyshd_p->dposUhrFak
    local splFak := fakvyshd_p->dsplatFak
    local retVal := 0

    dnyPrekr := if(empty(posUhr), 0, posUhr -splFak)
    return max(0, dnyPrekr)

  *
  ** EVENT *********************************************************************
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl, recNo, in_file := ::in_file

    do case
    case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
      if ::in_file = 'cenzboz' .and. ::isSest = MIS_BOOKOPEN
        ** tady zavoláme pohled na kusov
        ::fin_cenzboz_ses()
      endif
      return .t.

    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
      return .t.

    case nEvent = drgEVENT_APPEND
    case nEvent = drgEVENT_FORMDRAWN
       return .t.

    case nEvent = xbeP_Keyboard
      do case
      case (mp1 = xbeK_ESC       )
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

      otherwise
        if in_file $ ::sp_files .and. mp1 = xbeK_CTRL_D
          ::mark_doklad(.t.)
        endif
        return .f.
      endcase

    otherwise
      return .f.
    endcase
  return .t.


  inline method post_bro_colourCode()
    local recNo := (::in_file)->(recNo()), ;
             pa := ::d_bro:arselect      , ;
             ok := .f.                   , in_file, obro, ardef, npos_in, ocol_is

    if ::in_file $ ::sp_files
      *
      in_file := ::in_file
      obro    := ::drgDialog:dialogCtrl:oBrowse[1]
      ardef   := obro:ardef

      npos_is := ascan(ardef, {|x| x[2] = 'M->' +in_file +'_is' })
      ocol_is := obro:oxbp:getColumn(npos_is)

      ok := .t.
      if ocol_is:getData() = 6001
         if (npos := ascan(pa, recNo)) = 0
           aadd(pa, recNo)
         else
           Aremove(pa, npos )
         endif

         if( len(pa) = 0, ::pb_save_marked:disable(), ::pb_save_marked:enable())
         ::d_bro:arselect := pa
      endif
    endif
  return .t.   /// øešení na BRO není povoleno ok


  ** jen pro test -- tato metoda musí být pro 3 vazby
  ** 1 - u nabídky cenzboz zobrazí kusovníkový rozpad cenzboz - kusov
  ** 2 - pøi zadání množství provede kontrolu to je virtuálnì
  ** 3 - u položky dokladu kusovníkový rozpad položka dokladu - cenzboz - kusov
  inline method fin_cenzboz_ses(drgDialog)
    local  odialog, nexit := drgEVENT_QUIT

    DRGDIALOG FORM 'FIN_cenzboz_SEST' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  return


  inline method FAZ_itemMarked()
    local  filter := format("ncisfak = %%",{fakvyshd->ncisFak})

    vykdph_pw->(dbclearfilter(), dbgotop())

    ::m_udcp:favst_padz( fakvyshd->ncisFak )
    vykdph_pw->(dbSetfilter(COMPILE(filter)), dbgotop())
  return self

HIDDEN:
  VAR     drgVar, lNEWrec, typ_dokl, typ_state, hd_file, it_file, in_file
  VAR     tabNum, popUp, popState, m_filter

  * speciení vstupní soubory pro fakturaci
  **  pøi zobrazení seznamu je nastaven pohled na nevyfakturované
  **  nožnost oznaèení a pøevzetí položek do dokladu v režimu NEVYFAKTUROVANÉ
  VAR     sp_files, pb_context, pb_mark_doklad, pb_save_marked, main_is

ENDCLASS



METHOD FIN_fakturovat_z_SEL:init(parent)
  local items
  *
  ::drgVar  := parent:parent:lastXbpInFocus:cargo
     items  := Lower(drgParseSecond(::drgVar:name,'>'))
  ::in_file := if(items = 'ncislodl'   , 'dodlstit'  , ;
               if(items = 'cciszakazi' , 'vyrzakit'  , ;
               if(items = 'ccislobint' , 'objitem'   , ;
               if(items = 'nciszalfak' , 'fakvyshd'  , ;
               if(items = 'ncispenfak' , 'fakvyshd_p', 'cenzboz' )))))

  ::m_filter := (::in_file)->(ads_getAof())
  ::m_udcp   := parent:parent:udcp
  ::popUp    := ::m_udcp:cwds_popUp
  ::popState := 1
  ::sp_files := 'dodlstit,vyrzakit,objitem'
  ::sp_saved := .f.

  drgDBMS:open('cenZb_rp')
  drgDBMS:open('FAKVYSHD')
  drgDBMS:open('KUSOV')

  ::drgUsrClass:init(parent)
RETURN self


METHOD FIN_fakturovat_z_SEL:getForm()
  local  oDrg, drgFC, headTite
  local  zkratMenz := (::m_udcp:hd_file)->czkratMenZ


  headTitle := if(::in_file = 'dodlstit'  , 'dodacích listù'         , ;
               if(::in_file = 'vyrzakit'  , 'výrobních zakázek'      , ;
               if(::in_file = 'objitem'   , 'objednávek pøijatých'   , ;
               if(::in_file = 'fakvyshd'  , 'zálohových faktur'      , ;
               if(::in_file = 'fakvyshd_p', 'pohledávek k penalizaci', 'skladových položek')))))

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 110,15.2 DTYPE '10' TITLE 'Seznam ' +headTitle +' _ výbìr' ;
                                              GUILOOK 'All:N,Border:Y'

  do case
  case ::in_file = 'dodlstit'
  * Pøevzít z Dodacích listù       ->dodlstit
    ::main_is := ::dodlstit_is

    DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 110,13 FILE 'DODLSTIT'     ;
      FIELDS 'M->dodlstit_is::2.7::2,'                             + ;
             'M->dodlstit_cp:c:2.6::2,'                            + ;
             'nDOKLAD:èísloDl,'                                    + ;
             'cCISSKLAD:èisSklad,'                                 + ;
             'nZBOZIKAT:katZbo,'                                   + ;
             'cSKLPOL:sklPoložka,'                                 + ;
             'cNAZZBO:název zboží:33,'                             + ;
             'nCENZAKCED:prodCena,'                                + ;
             'M->m_udcp|wsd_dodlstit_kDis:množKDisp:13,'           + ;
             'M->dodlstit_sdm:množSdis:13,'                        + ;
             'M->mnozKFak_dl:množKFak:15,'                         + ;
             'cCISZAKAZ:èísloZakázky:20,'                          + ;
             'cCISZAKAZI:výrÈíslo:20'                                ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'

    DRGPUSHBUTTON INTO drgFC CAPTION 'Kompletní seznam ' POS 65.5,0.05 SIZE 38,1 ;
                  EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'

    DRGPUSHBUTTON INTO drgFC POS 103.5,.05 SIZE 3,1.1 ATYPE 1 ;
                  ICON1 MIS_ICON_CHECK ICON2 gMIS_ICON_CHECK  ;
                  EVENT 'mark_doklad' TIPTEXT 'Oznaè vstupní doklad ...'

    DRGPUSHBUTTON INTO drgFC POS 106.5,.05 SIZE 3,1.1 ATYPE 1    ;
                  ICON1 MIS_ICON_SAVE_AS ICON2 gMIS_ICON_SAVE_AS ;
                  EVENT 'save_marked' TIPTEXT 'Pøevzít položky do dokladu ...'

  case ::in_file = 'vyrzakit'
  * Pøevzít z Výrobních zakázek    ->vyrzakit
    ::main_is := ::vyrzakit_is

    DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 110,13 FILE 'VYRZAKIT'     ;
      FIELDS 'M->vyrzakit_is::2.7::2,'                             + ;
             'cCISZAKAZ:èísloZakázky:20,'                          + ;
             'cCISZAKAZI:výrÈíslo:20,'                             + ;
             'cNAZEVZAK1:název zakázky:39,'                        + ;
             'CNAZFIRMY::20,'                                      + ;
             'cSKP:skp,'                                           + ;
             'cZKRATMENZ:mìna,'                                    + ;
             'nCENAMJ:cena/mj,'                                    + ;
             'M->m_udcp|wsd_vyrzakit_kDis:množKDisp:13,'           + ;
             'FIN_fakturovat_z_bc(5;3):množKFak,'                  + ;
             'FIN_fakturovat_z_bc(6;3):H:2.6::2,'                  + ;
             'nRozm_del:délka,'                                    + ;
             'nRozm_sir:šíøka,'                                    + ;
             'nRozm_vys:výška,'                                    + ;
             'cRozm_MJ:mj'                                           ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'

    DRGPUSHBUTTON INTO drgFC CAPTION 'Kompletní seznam ' POS 65.5,0.05 SIZE 38,1 ;
                  EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'

    DRGPUSHBUTTON INTO drgFC POS 103.5,.05 SIZE 0,0 ATYPE 1 ;
                  ICON1 MIS_ICON_CHECK ICON2 gMIS_ICON_CHECK  ;
                  EVENT 'mark_doklad' TIPTEXT 'Oznaè vstupní doklad ...'

    DRGPUSHBUTTON INTO drgFC POS 106.5,.05 SIZE 0,0 ATYPE 1    ;
                  ICON1 MIS_ICON_SAVE_AS ICON2 gMIS_ICON_SAVE_AS ;
                  EVENT 'save_marked' TIPTEXT 'Pøevzít položky do dokladu ...'

  case ::in_file = 'objitem'
  * Pøevzít z Objednávek pøijatých ->objitem
    ::main_is := ::objitem_is

    DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 110,13 FILE 'OBJITEM'      ;
      FIELDS 'M->objitem_is::2.7::2,'                              + ;
             'M->objitem_cp:c:2.6::2,'                             + ;
             'nDOKLAD:èísloObj,'                                   + ;
             'cCISLOBINT:èísloObjed_in:15,'                        + ;
             'cCISSKLAD:èisSklad,'                                 + ;
             'cROZPORADI:poøPol,'                                  + ;
             'nZBOZIKAT:katZbo,'                                   + ;
             'cSKLPOL:sklPoložka,'                                 + ;
             'cNAZZBO:název zboží:34,'                             + ;
             'nCENADLODB:podCena,'                                 + ;
             'M->m_udcp|wsd_objitem_kDis:množDoDokl:13,'           + ;
             'M->objitem_sdm:množSklDis:13,'                       + ;
             'nMNOZOBODB:množObOdb'                                  ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'


    DRGPUSHBUTTON INTO drgFC CAPTION 'Kompletní seznam ' POS 65.5,0.05 SIZE 38,1 ;
                  EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'

    DRGPUSHBUTTON INTO drgFC POS 103.5,.05 SIZE 3,1.1 ATYPE 1 ;
                  ICON1 MIS_ICON_CHECK ICON2 gMIS_ICON_CHECK  ;
                  EVENT 'mark_doklad' TIPTEXT 'Oznaè vstupní doklad ...'

    DRGPUSHBUTTON INTO drgFC POS 106.5,.05 SIZE 3,1.1 ATYPE 1    ;
                  ICON1 MIS_ICON_SAVE_AS ICON2 gMIS_ICON_SAVE_AS ;
                  EVENT 'save_marked' TIPTEXT 'Pøevzít položky do dokladu ...'

  case ::in_file = 'fakvyshd'
  * Fakturovat ze Zálohových faktur   ->fakvyshd
    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 110, 9 FILE 'FAKVYSHD'     ;
      FIELDS 'FIN_fakturovat_z_bc(1;1):H:2.6::2,'                  + ;
             'FIN_fakturovat_z_bc(2;1):P:2.6::2,'                  + ;
             'nCISFAK:èísZálFak,'                                  + ;
             'cVARSYM:varSymbol,'                                  + ;
             'nCISFIRMY:firma,'                                    + ;
             'cNAZEV:název firmy:16,'                              + ;
             'dVYSTFAK:datVyst,'                                   + ;
             'FIN_fakturovat_z_bc(6;1):záloha:13,'                 + ;
             'FIN_fakturovat_z_bc(7;1):úhrada:13,'                 + ;
             'FIN_fakturovat_z_bc(9;1):v:4,'                       + ;
             'FIN_fakturovat_z_bc(8;1):k uplatnìní v ' +zkratMenz +':13' ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y' ITEMMARKED 'FAZ_itemMarked'

   DRGDBROWSE INTO drgFC FPOS 0,9.1 SIZE 109,6 FILE 'vykdph_Pw'      ;
      FIELDS 'M->preDanPov::2.7::2,'                               + ;
             'nradek_Dph:øv:5,'                                    + ;
             'M->cradek_Dph:název øádku výkazu dph:32,'            + ;
             'ndoklad_Or:daòDoklad:12,'                            + ;
             'nzakld_or:základ:14,'                                + ;
             'nsazba_or:daò:14,'                                   + ;
             'nzakld_Zal:základ_zál:14,'                           + ;
             'nsazba_Zal:sazba_zál:14'                               ;
      SCROLL 'ny'  CURSORMODE 3 PP 7


  case ::in_file = 'fakvyshd_p'
  * Penalizovat z faktur   ->fakvyshd_p
    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 110,13 FILE 'FAKVYSHD_P'   ;
      FIELDS 'M->fakvyshd_p_uhr::2.7::2,'                          + ;
             'M->fakvyshd_p_pen::2.7::2,'                          + ;
             'nCISFAK:èísFak,'                                     + ;
             'cVARSYM:varSymbol,'                                  + ;
             'cNAZEV:název firmy:21,'                              + ;
             'dSPLATFAK:datSplatn,'                                + ;
             'ncenZahCel:celkFakt,'                                + ;
             'nuhrCelFaz:úhrada,'                                  + ;
             'dposUhrFak:dne,'                                     + ;
             'M->fakvyshd_p_dny:poSpl:7'                             ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'

  otherwise
  * Pøevzít z Ceníku zboží         ->cenzboz
    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 110,13 FILE 'CENZBOZ'      ;
      FIELDS 'M->cenPol:c:2.6::2,'                                 + ;
             'M->isSest:s:2.6::2,'                                 + ;
             'M->isSetCenZboz_Rp:rp:3::2,'                         + ;
             'cCISSKLAD:èisSklad,'                                 + ;
             'cROZPORADI:poøPol,'                                  + ;
             'nZBOZIKAT:katZbo,'                                   + ;
             'cSKLPOL:sklPoložka,'                                 + ;
             'cNAZZBO:název zboží:33,'                             + ;
             'cJKPOV:jkpov,'                                       + ;
             'nCENAPZBO:prodCena,'                                 + ;
             'M->m_udcp|wds_cenzboz_kDis:množKDisp:13,'            + ;
             'nMNOZDZBO:množKFak'                                    ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'
  endcase

  DRGEND INTO drgFC
RETURN drgFC


METHOD FIN_fakturovat_z_SEL:drgDialogInit(drgDialog)
  local  apos, asize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

//  XbpDialog:titleBar := .F.

  if IsObject(::drgVar)
    aPos := mh_GetAbsPosDlg(::drgVar:oXbp,drgDialog:dataAreaSize)
    if(apos[1] < 0, apos[1] := 10, nil)
    drgDialog:usrPos := {aPos[1],aPos[2] -24}
  endif
RETURN


METHOD FIN_fakturovat_z_SEL:drgDialogStart(drgDialog)
  local  x, members := drgDialog:oForm:aMembers
  local  d_bro := drgDialog:dialogCtrl:obrowse[1]
  local  ardef := d_bro:ardef, npos_isSest, ocolumn
  *
  local  value, ctag, pa_tagKey
  local  ctag_old, ckey_old, nsid_old, lok_old := .f.

  ::d_bro   := d_bro

  pa_tagKey := drgScrPos:getPos_forSel('FIN_fakturovat_z_SEL', drgDialog, ::in_file)
  ctag_old  := pa_tagKey[1]
  ckey_old  := pa_tagKey[2]
  nsid_old  := pa_tagKey[3]

  for x := 1 to len(members) step 1
    if  members[x]:ClassName() = 'drgPushButton'
      do case
      case members[x]:event = 'createContext'  ;  ::pb_context     := members[x]
      case members[x]:event = 'mark_doklad'    ;  ::pb_mark_doklad := members[x]
      case members[x]:event = 'save_marked'    ;  ::pb_save_marked := members[x]
      endcase
    endif
  next

  if isobject(::pb_context)
    ::pb_context:oXbp:setFont(drgPP:getFont(5))
    ::pb_context:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )

    ::pb_save_marked:disable()
  endif

  if isobject(::drgVar)

    if .not. empty(nsid_old)
      lok_old := (::in_file)->( dbseek( nsid_old,, 'ID' ))
    else
      lok_old := .t.
    endif

*    if .not. empty(ctag_old) .and. .not. empty(ckey_old)
*      lok_old := (::in_file)->( dbseek( ckey_old,, ctag_old))
*    else
*      lok_old := .t.
*    endif

    if( ::in_file $ ::sp_files, ::fromContext(2,'Nevyfakturované'), nil)


    if .not. empty(value := ::drgVar:oVar:value)

      do case
      case (::in_file = 'dodlstit'  )  ;  ctag := 'DODLIT8'   // n
      case (::in_file = 'vyrzakit'  )  ;  ctag := 'ZAKIT_4'   // c
      case (::in_file = 'objitem'   )  ;  ctag := 'OBJITEM2'  // c
      case (::in_file = 'fakvyshd'  )  ;  ctag := 'FODBHD1'   // n
      case (::in_file = 'fakvyshd_p')  ;  ctag := ''
      case (::in_file = 'cenzboz'   )  ;  ctag := 'CENIK01'   // c
      endcase

      if .not. empty(ctag)
        if( valType(value) = 'C', value := allTrim(value), nil )

        (::in_file)->(dbseek( value, valType(value) = 'N', ctag))
      endif

    * zkusíme se nastavit na poslední záznam kde byl
    else

      if .not. lok_old
        (::in_file)->( dbseek( ckey_old, .t., ctag_old))

        if (::in_file)->(eof()) .or. d_bro:oxbp:rowpos = 1
          (::in_file)->( dbgoBottom())
          for x := 1 to 3 ; (::in_file) ->( dbskip(-1)) ; next
          for x := 1 to 3 ; d_bro:oxbp:down()           ; next
        endif
      endif

    endif
  endif

  * úprava pro sloucec isSest vazba na CENZBOZ + KLAKUL(cvysPol = csklPol)
  if ::in_file = 'cenzboz'
    npos_isSest := ascan(ardef, {|x| x.defName = 'm->isSest'})
    ocolumn     := d_bro:oxbp:getColumn(npos_isSest)

    ocolumn:dataAreaLayout[XBPCOL_DA_FRAMELAYOUT]       := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
    ocolumn:dataAreaLayout[XBPCOL_DA_HILITEFRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
    ocolumn:dataAreaLayout[XBPCOL_DA_CELLFRAMELAYOUT]   := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
    ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]             := GraMakeRGBColor( {221,221,221})

    ocolumn:configure()
    d_bro:oxbp:refreshAll()
  endif
RETURN self


method fin_fakturovat_z_sel:drgDialogEnd(drgDialog)
 (::in_file)->(dbclearFilter())
return self


method fin_fakturovat_z_sel:mark_doklad(drgDialog)
  local in_file := ::in_file, recNo, ;
             pa := ::d_bro:arselect, ps, doklad, block, ok := .t., is_ctrlA, ;
          nskip := 0

  if ::popState = 2
    recNo    := (in_file)->(recNo())
    ps       := {}
    is_ctrlA := if( isObject(drgDialog), .f., .t.)

    do case
    case is_ctrlA  ;  ( ok := (len(pa) = 0),  block := ".t." )
    otherwise
      doklad := (in_file)->ndoklad
      if in_file = 'vyrzakit'
        bblock := format("cciszakaz = '%%'", {(in_file)->cciszakaz})
      else
        block  := format("ndoklad = %%", {(in_file)->ndoklad})
      endif
    endcase

    if ok
      (in_file)->(dbGoTop())
      do while .not. (in_file)->(eof())
        if (in_file) ->( eval(COMPILE(block)))
         if ascan(pa,(in_file)->(recNo())) = 0
           aadd(ps, (in_file)->(recNo()) )
         endif
        endif

        (in_file)->(dbskip())
        nskip++
      enddo

      do while (in_file)->(recNo()) <> recNo ; (in_file)->(dbskip(-1)) ; enddo
    endif

    if( len(ps) = 0, ::pb_save_marked:disable(), ::pb_save_marked:enable())
    ::d_bro:arselect := ps

    ::d_bro:oxbp:refreshAll()
  endif
return


method fin_fakturovat_z_sel:save_marked()
  ::sp_saved := .t.
  postappevent(drgEVENT_EDIT,,,::d_bro:oxbp)
return


//// tohle pøijde ven
method FIN_fakturovat_z_SEL:itemMarked()
  local  it_ky   := strZero(fakvyshd->ncisFak,10), uc_ky
  local  nparZal := FIN_fakturovat_z_bc(8,1)
  *
  local  nosvODdan, nzaklDan_1, nsazDan_1, nzaklDan_2, nsazDan_2
  local             nprocDan_1,            nprocDan_2
  local             cucet_Daz

  fakvysitzw->(flock(),dbzap())

  nosvODdan := nzaklDan_1 := nsazDan_1 := nzaklDan_2 := nsazDan_2 := 0

  uc_ky     := upper(fakvyshd->cdenik) +strZero(fakvyshd->ncisFak,10)
  ucetdohd->(AdsSetOrder('UCETDH_7')     , ;
             dbSetScope(SCOPE_BOTH,uc_ky), ;
             dbGoTop()                     )

  cucet_Daz  := ucetdohd->cucet_Uct
  nprocDan_1 := ucetdohd->nprocDan_1
  nprocDan_2 := Ucetdohd->nprocDan_2
  *
  ucetdohd->(dbeval({|| (nosvOdDan  += ucetdohd->nosvOdDan , ;
                         nzaklDan_1 += ucetdohd->nzaklDan_1, ;
                         nsazDan_1  += ucetdohd->nsazDan_1 , ;
                         nzaklDan_2 += ucetdohd->nzaklDan_2, ;
                         nsazDan_2  += ucetdohd->nsazDan_2   ) }), ;
             dbclearScope()                                        )

  if nparZal > 0
    if(nosvODdan +nzaklDan_1 +nsazDan_1 +nzaklDan_2 +nsazDan_2) <> 0
      fakvyshdw->cucet_daz := cucet_Daz
      if( nosvOdDan <> 0, fin_fakturovat_z_dan(nosvOdDan,'(osv)'), nil)

      if nzaklDan_1 <> 0
        fin_fakturovat_z_dan(nzaklDan_1,'(ssd)')
        fakvysitzw->nnapocet  := 1
        fakvysitzw->nprocDph  := nprocDan_1
        fakvysitzw->ncejprkdz := nzaklDan_1 // +nsazDan_1
        fakvysitzw->ncecprkdz := nzaklDan_1 +nsazDan_1
        fakvysitzw->nsazDan   := nsazDan_1
      endif

      if nzaklDan_2 <> 0
        fin_fakturovat_z_dan(nzaklDan_2,'(zsd)')
        fakvysitzw->nnapocet  := 2
        fakvysitzw->nprocDph  := nprocDan_2
        fakvysitzw->ncejprkdz := nzaklDan_2 // +nsazDan_2
        fakvysitzw->ncecprkdz := nzaklDan_2 +nsazDan_2
        fakvysitzw->nsazDan   := nsazDan_2
      endif
    else
      fin_fakturovat_z_dan(nparZal,'')
    endif
  endif

  fakvysit->(AdsSetOrder('FVYSIT1')                                     , ;
             dbSetScope(SCOPE_BOTH,it_ky)                               , ;
             DbGoTop()                                                  , ;
             dbeval({|| mh_copyfld('fakvysit', 'fakvysitzw', .t., .t.)}), ;
             dbClearScope()                                               )

  fakvysitzw->(dbgotop())
return self
*
static function fin_fakturovat_z_dan(nparZal,ctx)

  mh_copyfld('fakvyshd','fakvysitzw',.t., .t.)
   fakvysitzw->nfaktMnoz  := -1
   fakvysitzw->nklicDph   := -1
   fakvysitzw->nnullDph   := if(fakvyshdw->nfinTyp > 2 .or. fakvyshdw->nfinTyp = 6, 14, 4)
   fakvysitzw->cnazZbo    := 'FAK_' +alltrim(str(fakVyshd->ncisFak)) + ctx +' odpoèet zálohy'
   fakvysitzw->czkratJedn := 'x'
   fakvysitzw->ncejprzbz  := nparZal
   fakvysitzw->ncejprkdz  := nparZal
   fakvysitzw->ncecprkdz  := nparZal
   fakvysitzw->ncecprkbz  := nparZal
   fakvysitzw->cucet      := fakvyshd->cucet_Uct
   fakvysitzw->ncisZalFak := fakvyshd->ncisFak
return nil
/// až sem


**
METHOD FIN_fakturovat_z_SEL:createContext()
  LOCAL csubmenu, opopup, apos
  *
  local pa := listasarray(::popUp)

  csubmenu := drgNLS:msg(::popUp)
  opopup   := XbpMenu():new( ::drgDialog:dialog ):create()

  for x := 1 to len(pa) step 1
    opopup:addItem( {drgParse(@cSubMenu), de_BrowseContext(self,x,pA[x]) } )
  next

  opopup:disableItem(::popState)

  apos    := ::pb_context:oXbp:currentPos()
  opopup:popup(::drgDialog:dialog, apos)
RETURN self


METHOD FIN_fakturovat_z_SEL:fromContext(aorder,nmenu)
  local  obro    := ::drgDialog:dialogCtrl:oBrowse[1]
  local  filter  := ::m_filter +if(.not. empty(::m_filter), " .and. ", "")
  *
  local  ardef   := obro:ardef, npos_is, ocol_is
  local  in_file := ::in_file, pa := {}
  local  pa_wds, pa_exclude := {}
  *
  local  recNo       := (::in_file)->( recNo()), curr_recNo
  local  awds_popUp  := listAsArray( ::popUp )
  local  awds_filter := ::m_udcp:awds_filter
  *
  local  ctagName

  npos_is := ascan(ardef, {|x| x[2] = 'M->' +in_file +'_is' })
  ocol_is := obro:oxbp:getColumn(npos_is)

  ::popState := aorder
  ::pb_context:oxbp:setCaption( awds_popUp[aorder])
  curr_recNo := recNo

  do case
  case(aorder = 1)                               // Kompletní seznam
    if .not. empty(::m_filter)
      (::in_file)->(ads_setAof(::m_filter))
    else
      (::in_file)->(ads_clearAof())
    endif

  otherwise
    filter += awds_filter[ aorder ]

    if( .not. empty(filter), (::in_file)->(ads_setAof(filter)), nil)
  endcase


  if(aorder = 2 .or. aorder = 4)

    pa_wds := if( ::in_file = 'dodlstit', ::m_udcp:wds_dodlstit, ;
               if( ::in_file = 'objitem' , ::m_udcp:wds_objitem , ;
                if( ::in_file = 'vyrzakit', ::m_udcp:wds_vyrzak  , {} ) ) )

    *
    ** vyjmeme záznamy, kde množství pro pøevzetí je --> 0
    aeval( pa_wds, { |x|  (in_file) ->( dbgoto(x[1])) , ;
                          if( ocol_is:getData() = 0, aadd( pa_exclude, x[1] ), nil ) } )

    if len( pa_exclude ) <> 0
      (in_file)->( ads_customizeAOF( pa_exclude, 2), dbskip())
      (in_file)->( dbgoTo( recNo ))
    endif

  endif

  if .not. (in_file)->( ads_isRecordInAOF(recNo))  // .or. .not. (in_file)->( ads_isRecordInAOF(curr_recNo))
    (in_file)->( dbskip())
    ::d_bro:oxbp:panHome():forceStable()
  else
    (in_file)->( dbgoTo(recNo))
  endif

  * rušíme oznaèení
  ::d_bro:arselect := {}
  ::d_bro:oxbp:refreshAll()

  if( ::in_file $ ::sp_files )
    if( aorder = 2, ::pb_mark_doklad:enable(), ::pb_mark_doklad:disable())
    ::pb_save_marked:disable()
  endif
RETURN self


*
** tohle nevím jestili nìkam nepøesunem, mìla by to být obená tøída **
CLASS FIN_cenzboz_SEST FROM drgUsrClass, fin_finance_in
EXPORTED:
  method  init, getForm, drgDialogInit, drgDialogStart, destroy

  * cenzboz - ceníková/neceníková položka
  inline access assign method cenPol() var cenPol
    return if(fakvysitsw->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method mnoz_k_disp var mnoz_k_disp
    local retVal := 0, cky := upper(fakvysitsw->ccisSklad) +upper(fakvysitsw->csklPol)

      cenzbozsw->(dbseek(cky,,'CENIK03'))
    return  cenzbozsw->nmnozDZbo

  *
  ** EVENT *********************************************************************
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
  RETURN .F.

HIDDEN:
  VAR     drgVar, lNEWrec, typ_dokl, typ_state, hd_file, it_file, in_file
  VAR     parent
  VAR     in_dokl
ENDCLASS


METHOD FIN_cenzboz_sest:init(parent)
  local  hd_file

  if lower(parent:parent:formName) = 'fin_fakturovat_z_sel'
    hd_file   := parent:parent:parent:udcp:hd_file
    ::in_dokl := .f.
  else
    hd_file   := parent:parent:udcp:hd_file
    ::in_dokl := .t.
  endif

  ::fin_finance_in:fin_mapolSest_in(hd_file)

  ::drgUsrClass:init(parent)
RETURN self


METHOD FIN_cenzboz_sest:getForm()
  local  oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,9.5 DTYPE '10' TITLE 'Seznam položek výrobní sestavy ...' ;
                                            GUILOOK 'ALL:n,BORDER:y'

    DRGDBROWSE INTO drgFC FPOS 0,1.4 SIZE 100,8 FILE 'fakvysitsw'     ;
        FIELDS 'M->cenPol:c:2.6::2,'          + ;
               'ccisSklad:èísSklad,'          + ;
               'csklpol:sklPoložka,'          + ;
               'cnazzbo:název zboží:28,'      + ;
               'nfaktmnoz:množVSes:12,'       + ;
               'M->mnoz_k_disp:množKDisp:12,' + ;
               'czkratjedn:mj,'               + ;
               'ncejprzbz:prodCena'             ;
       SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'n'


    DRGSTATIC INTO drgFC FPOS .3,0 SIZE 99.4,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION 't e x t' CLEN 100 CPOS .5,.1 FONT 5
      DRGPUSHBUTTON INTO drgFC POS 96,.05 SIZE 3,1 ATYPE 1 ICON1 120 ICON2 220 EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
    DRGEND  INTO drgFC

  DRGEND  INTO drgFC
RETURN drgFC


method FIN_cenzboz_sest:drgDialogInit(drgDialog)
  local  ocolumN, aPos, aRect, nW, nY
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog
  *
  local  obro := drgDialog:parent:odbrowse[1]

  XbpDialog:titleBar := .F.
*-  XbpDialog:drawingArea:bitmap := 1015


  if IsObject(obro)
    ocolumN := obro:oxbp:getColumn(2)
    aRect   := ocolumN:dataArea:cellRect(obro:oxbp:rowPos)
    nW      := (aRect[4] -aRect[2])

    nY      := (obro:oxbp:rowCount - obro:oxbp:rowPos) * nW

    aPos    := mh_GetAbsPosDlg(ocolumN:dataArea,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1] +2,aPos[2] +2 +nY-19 +if(::in_dokl, 19, 0) }
  endif
return


METHOD FIN_cenzboz_sest:drgDialogStart(drgDialog)
  local  x, members := drgDialog:oForm:aMembers, odrg
  local        obro := drgDialog:dialogCtrl:obrowse[1], ocolumn
  local       obord := drgDialog:obord


  for x := 1 TO LEN(members) step 1
    odrg := members[x]

    if((odrg:className() = 'drgStatic') .or. ;
       (odrg:className() = 'drgText' .and. odrg:obord:type = 1), ;
        odrg:oxbp:setcolorbg(GraMakeRGBColor( {0, 255, 0} )), nil)

*    if((odrg:className() = 'drgStatic') .or. ;
*       (odrg:className() = 'drgText' .and. odrg:obord:type = 1), ;
*       odrg:oxbp:setcolorbg(GraMakeRGBColor( {196, 196, 255} )), nil)
  next

  for x := 1 to obro:oXbp:colcount step 1
    ocolumn := oBro:oXbp:getColumn(x)
    ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
    ocolumn:configure()
  next
  obro:oXbp:refreshAll()



/*
  local  d_bro := drgDialog:dialogCtrl:obrowse[1]
  local  ardef := d_bro:ardef, npos_isSest, ocolumn

  for x := 1 to len(members) step 1
    if( members[x]:ClassName() = 'drgPushButton', ::drgPush := members[x], NIL )
  next

  if isobject(::drgPush)
    ::drgPush:oXbp:setFont(drgPP:getFont(5))
    ::drgPush:oXbp:setColorFG(GRA_CLR_BLUE)
  endif

   * úprava pro sloucec isSest vazba na CENZBOZ + KLAKUL(cvysPol = csklPol)
  if ::in_file = 'cenzboz'
    npos_isSest := ascan(ardef, {|x| x.defName = 'm->isSest'})
    ocolumn     := d_bro:oxbp:getColumn(npos_isSest)

    ocolumn:dataAreaLayout[XBPCOL_DA_FRAMELAYOUT]       := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
    ocolumn:dataAreaLayout[XBPCOL_DA_HILITEFRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
    ocolumn:dataAreaLayout[XBPCOL_DA_CELLFRAMELAYOUT]   := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
    ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]             := GraMakeRGBColor( {221,221,221})

    ocolumn:configure()
    d_bro:oxbp:refreshAll()
  endif
*/
RETURN self


METHOD FIN_cenzboz_sest:destroy()
RETURN