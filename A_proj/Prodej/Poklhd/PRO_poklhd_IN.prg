#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
//
#include "drgRes.ch"
#include "..\Asystem++\Asystem++.ch"


// 1_B�n� faktura      6_Faktura do EU
// 2_Z�lohov� faktura   5_Penaliza�n� faktura
// 3_Zahrani�n� faktura 4_Z�lohov� zahrani�n�


#define  m_files   {'c_typuhr', 'c_dph'    , 'c_meny'  , 'c_bankuc', 'c_staty' , ;
                    'c_prepmj'                                                 , ;
                    'firmy'   , 'firmyfi'  , 'firmyuc' , 'kurzit'              , ;
                    'poklhd'  , 'poklit'                                       , ;
                    'pokladks', 'pokladms'                                     , ;
                    'objitem' , 'vyrzak'   , 'cenzboz' , 'cenprodc', 'procenho', ;
                    'pvphead' , 'pvpitem'  , 'ucetpol'                         , ;
                    'stroje'                                                   , ;
                    'forms'                                                      }

*
** CLASS for PRO_poklhd_IN *****************************************************
CLASS PRO_poklhd_IN FROM drgUsrClass, FIN_finance_IN, FIN_pro_fakdol
exported:
  var     selSklad, s_popup
  var     on_sklPol, on_zaplaceno, on_cenaProd, on_vykDph, on_fstItems, on_isHotov, on_prnDoklad, on_firmySel
  var     on_basketSave
  var     cenZahCel
  var     a_nazPol
  *
  method  init, drgDialogStart, postLastField, postSave, postDelete, onSave, destroy
  method  postItemMarked
  *
  method  takeValue
  *
  method  fakturovat_z_sel, poklhd_c_prepmj_sel
  method  edit_pc
  method  edit_ns
  method  favst_procSlev
  method  saveParagon
  method  openKase
  *

  inline method drgDialogInit(drgDialog)

    drgDialog:dialog:drawingArea:bitmap  := 1019
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  return self


  inline access assign method nazevDne() var nazevDne
    return cdow(date())

  inline access assign method datumDne() var datumDne
    return date()

  inline access assign method casDne()   var casDne
    if( isobject(::hodiny), ::hodiny:set(time()), nil)
    return time()


  inline method postValidate(drgVar)
    local  value  := drgVar:get()
    local  name   := Lower(drgVar:name)

    if ( name = ::it_file +'->csklpol' .and. empty(value) )
      drgVar:prevValue := '??????????'
    endif
    return ::FIN_PRO_fakdol:postValidate(drgVar)


  * hlavi�ka info
  * 1 -b�n� faktura/ 6 -euro faktura
  * 'Bez DpH    <infoval_11>   DpH  <infoval_12> Celkem                               '
  inline access assign method infoval_11 var infoval_11
    return (poklhdw->ncendancel +poklhdw->nzakldaz_1 +poklhdw->nzakldaz_2)

  inline access assign method infoval_12 var infoval_12
    return (poklhdw->nsazdan_1 +poklhdw->nsazdan_2 +poklhdw->nsazdaz_3)
  inline access assign method infoval_13 var infoval_13
    return (poklhdw->nzaklDan_1 +poklhdw->nzaklDan_2 +poklhdw->nzaklDan_3)


  * polo�ky - bro
  inline access assign method cenPol() var cenPol
    return if(poklitw->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method cena_za_mj() var cena_za_mj
    local retval := 0

    retval := if(poklhdw->nfintyp > 2 .or. poklhdw->nfintyp = 6, ;
              if(poklhdw->nfintyp = 4, poklhdw->ncenzakcel,poklhdw->ncejprkbz), poklhdw->ncejprkbz)
    return retval

  inline method eventHandled(nevent,mp1,mp2,oxbp)

    if ::lnewRec
      if isNull( (::it_file)->sID, 0) <> 0
        ( ::cisFak:isEdit   := .f., ::cisFak:oxbp:disable()  )
        ( ::cisFirmy:isEdit := .f., ::cisFirmy:oxbp:disable())
      else
        if( ::on_cenaProd = '1', (::cisFak:isEdit := .t., ::cisFak:oxbp:enable()), nil )
        ( ::cisFirmy:isEdit := .t., ::cisFirmy:oxbp:enable()  )
      endif
    endif

    if nEvent = xbeP_Keyboard .and. mp1 = 43
      do case
      case oxbp:className() = 'XbpGet'
        if lower(oxbp:cargo:name) = 'poklitw->csklpol' .and. empty(oxbp:value)
          ::setfocus()
          ::dm:refresh()
          nevent := drgEVENT_SAVE
        endif

      case oxbp:className() = 'XbpBrowse'
        nevent := drgEVENT_SAVE
      endcase
    endif

    return ::fakdol_handleEvent(nevent,mp1,mp2,oxbp)

  method  showGroup

HIDDEN:
  var     members_fak, members_pen , members_inf, hodiny, obdobi_Fin
  var     cisFak     , cisFirmy
  var     fakMnoz    , koefMn      , faktMnKoe  , zkrJednD
  var     zboziKat   , cejPrZDZ    , cejPrKDZ   , procSlev   , hodnSlev
  method  favst_koefMn, favst_dph  , favst_vyz, favst_czns, favst_rv
ENDCLASS




method pro_poklhd_in:init(parent)
*  local  filtr, flt := "(ccissklad = '%%' .and. nmnozdzbo <> 0 .and. ncenapzbo <> 0 .and. laktivni)"

  local  filtr, flt := "(ccissklad = '%%' .and. ncenapzbo <> 0 .and. laktivni .and. (( cpolcen = 'C' .and. nmnozdzbo <> 0) .or. cpolcen <> 'C'))"
  local  pa, ctypEdit := SYSCONFIG('PRODEJ:cTYPEDIT')

  ::drgUsrClass:init(parent)
  *
  pa := listAsArray(ctypEdit)
  ::on_sklPol      := if( len(pa) >= 1, pa[1], '0')        //  0 - ukl�d� na csklPol        , 1 - ukl�d� na nfaktMnKoe, 2 - ukl�d� na ncejPrKDZ
  ::on_zaplaceno   := if( len(pa) >= 2, pa[2], '0')        //  0 - nepovol� ECS na zaplaceno, 1 - povol� ESC
  ::on_cenaProd    := if( len(pa) >= 3, pa[3], '0')        //  0 - nepovol� EDIT ceny       , 1 - povol� EDIT ceny
  ::on_vykDph      := if( len(pa) >= 4, pa[4], '1'  )      //  0 - negeneruje vykDph        , 1 - generuje vykDph
  ::on_fstItems    := if( len(pa) >= 5, pa[5], 'csklPol')  //  prvn� edita�n� polo�ka  ncisFirmy, csklPol
  ::on_isHotov     := if( len(pa) >= 6, pa[6], '1')        //  0 - bez hotovosn� platba     , 1  - platba v hotovost
  ::on_prnDoklad   := if( len(pa) >= 7, pa[7], '0')        //  0 - bez dotazu na tisk       , N - s dotazem na tisk, po�et kopi�
  ::on_firmySel    := if( len(pa) >= 8, pa[8], '0')        //  0 - ��slo firmy nen� povinn� , 1 - ��slo firmy je povinn�
  ::on_basketSave  := if( len(pa) >= 9, pa[9], '0')        //  0 - ukl�d� na nfaktMnKoe, 1 - ukl�d� na czkrJednD, 2 - ukl�d� na ncejPrKDZ

  (::hd_file  := 'poklhdw',::it_file  := 'poklitw', ::s_popup := '')
  ::lnewrec  := .not. (parent:cargo = drgEVENT_EDIT)
  ::selSklad := SYSCONFIG('PRODEJ:CCISSKLRP')

  * z�kladn� soubory
  ::openfiles(m_files)

  drgDBMS:open('c_typpoh',,,,,'c_typpohe')
  drgDBMS:open('pvphead' ,,,,,'pvp_head' )
  drgDBMS:open('pvpitem' ,,,,,'pvp_item' )

  *
  ** pro kontrolu na duplicity dokladu
  drgDBMS:open('poklhd',,,,,'poklhd_i')

  * p�ednastaven� z CFG
  ::lVSYMBOL       := sysconfig('finance:lvsymbol')
  ::SYSTEM_nico    := sysconfig('system:nico'     )
  ::SYSTEM_cdic    := sysconfig('system:cdic'     )
  ::SYSTEM_cpodnik := sysconfig('system:cpodnik'  )
  ::SYSTEM_culice  := sysconfig('system:culice'   )
  ::SYSTEM_cpsc    := sysconfig('system:cpsc'     )
  ::SYSTEM_csidlo  := sysconfig('system:csidlo'   )

  * likvidace
  ::FIN_finance_in:typ_lik := 'poh'

  * v�b�r z c_sklady
  drgDBMS:open('c_sklady')
  c_sklady->(dbgotop())
  do while .not. c_sklady->(eof())
    filtr := format(flt, {c_sklady->ccissklad})

    cenzboz->(ads_setaof(filtr),dbgotop())
    ::s_popup += if( .not. cenzboz->(eof()), c_sklady->ccissklad +'.' +c_sklady->cnazsklad +',', '')

    c_sklady->(dbskip())
  enddo
  cenzboz->(ads_clearAof(),dbgotop())
  ::s_popup := substr(::s_popup, 1, len(::s_popup) -1)

  pro_poklhd_cpy(self)
return self


method pro_poklhd_in:drgDialogStart(drgDialog)
  local  members  := drgDialog:dialogCtrl:members[1]:aMembers, odrg, groups
  local  fst_item := if(::lnewrec, ::on_fstItems, 'cvarsym'), pa
  local  oIcon    := XbpIcon():new():create(), state_y
  local  className, pa_groups, nin
  *
  local  obdobi, dvystFak := (::hd_file)->dvystFak
  local  acolors := MIS_COLORS


  ::members_fak := {}
  ::members_pen := {}
  pa            := ::members_inf := {}

  aeval(members, {|x| if(ismembervar(x,'groups') .and. .not. isnull(x:groups), ;
                        if(x:groups $ '16,25,34', aadd(pa,x), nil),nil) })

  for x := 1 TO Len(members)
    className := members[x]:ClassName()
    groups    := isNull( members[x]:groups, '' )

    if  className = 'drgText' .and. .not. Empty(groups)
      if 'SETFONT' $ groups
        pa_groups := ListAsArray(groups)
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


/*
    if members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
        members[x]:oXbp:setFontCompoundName(ListAsArray(members[x]:groups)[2])
        members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
      endif
    endif
*/
  next


  *
  if( isNull(drgDialog:cargo), drgDialog:Cargo := drgEVENT_APPEND, nil)
  ::fin_finance_in:init(drgDialog,'poh',::it_file +'->csklpol',' polo�ku faktury')

  ::cmb_typPoh        := ::dm:has(::hd_file +'->ctyppohybu'):odrg
  ::cmb_typPoh:isEdit := .f.

  ::hodiny    := ::dm:get('M->casDne'              , .F.)
  ::cisFak    := ::dm:get(::hd_file +'->ncisFak'   , .F.):odrg
  ::cisFirmy  := ::dm:get(::hd_file +'->ncisFirmy' , .F.):odrg

  ::cisloDl   := ::dm:get(::it_file +'->ncislodl'  , .F.)
  ::cisZakazi := ::dm:get(::it_file +'->cciszakazi', .F.)
  ::cislObInt := ::dm:get(::it_file +'->ccislobint', .F.)
  ::cisZalFak := ::dm:get(::it_file +'->nciszalfak', .F.)
  ::cisSklad  := ::dm:get(::it_file +'->ccissklad' , .F.)
  ::sklPol    := ::dm:get(::it_file +'->csklpol'   , .F.)
  ::zboziKat  := ::dm:get(::it_file +'->nzboziKat' , .F.)
  *
  ::cejPrZDZ  := ::dm:get(::it_file +'->ncejPrZDZ' , .F.)
  ::cejPrKDZ  := ::dm:get(::it_file +'->ncejPrKDZ' , .F.)
  ::procSlev  := ::dm:get(::it_file +'->nprocSlev' , .F.)
  ::hodnSlev  := ::dm:get(::it_file +'->nhodnSlev' , .F.)
  ::fakMnoz   := ::dm:get(::it_file +'->nfaktmnoz' , .F.)
  ::koefMn    := ::dm:get(::it_file +'->nkoefmn'   , .F.)
  ::faktMnKoe := ::dm:get(::it_file +'->nfaktmnKoe', .F.)
  ::zkrJednD  := ::dm:get(::it_file +'->czkrjednd' , .F.)
  *
  ::cenZahCel := ::dm:get(::hd_file +'->ncenZahCel', .F.)

  ::a_nazPol          := { '', '', '', '', '', '' }

  if ::on_cenaProd <> '1'
    odrg := ::dm:get(::it_file +'->ncejprkdz', .f.):odrg
    ( odrg:isEdit := .f., odrg:oxbp:disable() )

    if( ::lnewRec, (::cisFak:isEdit := .f., ::cisFak:oxbp:disable()), nil )
  endif

  for x := 1 to len(members) step 1
    if members[x]:classname() = 'drgPushButton'
      do case
      case isobject(members[x]:oxbp:cargo) .and. members[x]:oxbp:cargo:classname() = 'drgGet'
        odrg := members[x]:oxbp:cargo
      case members[x]:event = 'obdobi_Fin'
        ::obdobi_Fin := members[x]
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

  * projka FAKPRIHD-DODLSTHD
  ::fin_pro_fakdol:init(drgDialog:udcp)

* ::infoShow()
  ::comboItemSelected(::cmb_typPoh,0)
  ::cmb_typPoh:ovar:value     := ;
  ::cmb_typPoh:ovar:initValue := ;
  ::cmb_typPoh:ovar:prevValue :=(::hd_file)->ctypPohybu

* ::obdobi_Fin
  if isObject(::obdobi_Fin)
    state_y := if( uctOBDOBI:FIN:lzavren, MIS_ICON_QUIT, DRG_ICON_EDIT)

    oicon:load( NIL, state_y )

    ::obdobi_Fin:oxbp:setImage( oicon )
    ::obdobi_Fin:oxbp:setCaption('  FIN' +' ' +str(uctOBDOBI:FIN:nobdobi,2) +'/' +str(uctOBDOBI:FIN:nrok,4) )
    ::obdobi_Fin:isEdit := .f.
  endif


  if ::lnewrec
    obdobi := StrZero( Month(dvystFak), 2) +'/' +Right( Str( Year(dvystFak), 4), 2)

    if (::hd_file)->cobdobi <> obdobi
      ConfirmBox( ,'Je m� l�to, '                                                                        +CRLF + ;
                   'nelze spustil tuto nab�dku, nejsou spln�ny podm�nky pro zpracov�n� '                 +CRLF + ;
                   'aktu�ln� datum ' +dtoc(dvystFak) +' <> od aktu�ln�ho obdob� ' +(::hd_file)->cobdobi +' ...', ;
                   'Nelze zpracovat po�adavek ...'                                                             , ;
                    XBPMB_CANCEL                                                                               , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
      return .f.
    endif
  else
    ::df:setNextFocus((::it_file) +'->' +fst_item,, .T. )
  endif

*--  SetTimerEvent(100, {|| ::casDne()})
RETURN


method pro_poklhd_in:fakturovat_z_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, copy := .f., showDlg := .t.
  local  value := ::cisSklad:value +::sklPol:value
  * F4
  local  nevent := mp1 := mp2 := nil

  nevent  := LastAppEvent(@mp1,@mp2)

  if( ::sklPol:prevValue = '??????????', ::sklPol:prevValue := ::sklPol:value, nil )

  if    nevent = drgEVENT_ACTION
    showDlg := .t.
  else
    showDlg := .not. cenzboz->(dbseek( upper(value),,'CENIK03')) .or. empty(::sklPol:value)
    nexit   := if( .not. showDlg, drgEVENT_EDIT, drgEVENT_QUIT)
  endif

  if showDlg
    odialog       := drgDialog():new('PRO_poklhd_cen_sel',::dm:drgDialog)
    odialog:cargo := self
    odialog:create(,,.T.)
    nexit := odialog:exitState

    odialog:destroy()
    odialog := nil
  endif

  copy := if((showDlg .and. ::sklPol:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::takeValue(::it_file, 'cenzboz', 2)
    PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,drgDialog:lastXbpInFocus)

    if ::on_sklPol = '0'  //  0 - ukl�d� na csklPol , 1 - ukl�d� na nfaktMnKoe, 2 - ukl�d� na ncejPrKDZ
      PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,::fakMnoz:odrg:oxbp)
    endif
    nexit := drgEVENT_EDIT
  endif
return (nexit != drgEVENT_QUIT)


method pro_poklhd_in:poklhd_c_prepmj_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, dm, mp1
  local  koefMn
  *
  **
  odialog       := drgDialog():new('PRO_poklhd_c_prepmj_sel',::dm:drgDialog)
  odialog:create(,,.T.)
  nexit := odialog:exitState

  mp1   := if( odialog:exitState = drgEVENT_SAVE, xbeK_ENTER, xbeK_ESC )

  if nexit = drgEVENT_SAVE
    if ::zkrJednD:value <> c_prepmj->cvychoziMJ
     koefMn := c_prepmj->nkoefPrVC
    ::fakMnoz:set( ::faktMnKoe:value *koefMn )

    ::koefMn:set( c_prepmj->nkoefPrVC )
    ::zkrJednD:set( c_prepmj->cvychoziMJ )
    endif
  endif

  odialog:destroy()
  odialog := nil

  PostAppEvent(xbeP_Keyboard, mp1,,::zkrJednD:odrg:oxbp)
return .t.


method pro_poklhd_in:edit_pc(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, dm, mp1, pa_cargo_Usr
  *
  **
  pa_cargo_Usr := { ::dm:has(::it_file +'->nCEJPRZDZ' ):value, ;
                    ::dm:has(::it_file +'->nHODNSLEV' ):value, ;
                    ::dm:has(::it_file +'->nPROCSLEV' ):value, ;
                    ::dm:has(::it_file +'->nCEJPRKDZ' ):value, ;
                    ::dm:has(::it_file +'->nCELKSLEV' ):value, ;
                    ::dm:has(::it_file +'->nCECPRKDZ' ):value, ;
                    ::dm:has(::it_file +'->nFAKTMNKOE'):value  }


  odialog           := drgDialog():new('PRO_poklhd_edit_pc',::dm:drgDialog)
  odialog:cargo_Usr := pa_cargo_Usr
  odialog:create(,,.T.)
  nexit := odialog:exitState

  mp1   := if( odialog:exitState = drgEVENT_SAVE, xbeK_ENTER, xbeK_ESC )

  if nexit = drgEVENT_SAVE
    dm := oDialog:dataManager

    * 1
    ::cejPrZDZ:set( dm:get( ::it_file +'->ncejPrZdz' ) )
    ::hodnSlev:set( dm:get( ::it_file +'->nhodnSlev' ) )
    ::procSlev:set( dm:get( ::it_file +'->nprocSlev' ) )
    ::cejPrKdz:set( dm:get( ::it_file +'->ncejPrKdz' ) )
  endif

  odialog:destroy()
  odialog := nil

  if ::lnewRec .and. mp1 = xbeK_ESC
  else
    PostAppEvent(xbeP_Keyboard, mp1,,::cejPrKdz:odrg:oxbp)
  endif
return


method pro_poklhd_in:edit_ns(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, dm
  *
  local  oLastDrg := ::df:olastdrg

  odialog       := drgDialog():new('PRO_poklhd_edit_ns',::dm:drgDialog)
**  odialog:cargo := self
  odialog:create(,,.T.)
  nexit := odialog:exitState

  dm            := oDialog:dataManager
  ::a_nazPol[1] := dm:get(::it_file +'->cnazPol1')
  ::a_nazPol[2] := dm:get(::it_file +'->cnazPol2')
  ::a_nazPol[3] := dm:get(::it_file +'->cnazPol3')
  ::a_nazPol[4] := dm:get(::it_file +'->cnazPol4')
  ::a_nazPol[5] := dm:get(::it_file +'->cnazPol5')
  ::a_nazPol[6] := dm:get(::it_file +'->cnazPol6')

  odialog:destroy()
  odialog := nil

  if oLastDrg:oxbp:ClassName() = 'XbpBrowse'
    ::setFocus()
  endif
return


method pro_poklhd_in:postLastField()
  local  isChanged := ::dm:changed()                                  , ;
         file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value         , ;
         pa        := ::a_nazPol                                      , ;
         is_nazPol := .f.                                             , ;
         lnewRec, intCount


  AEval( pa, {|x| if( empty(x), nil, is_nazPol := .t. ) } )

  * ukl�d�me na posledn�m PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  lnewRec  := (::state = 2)
  intCount := if( lnewRec, ::ordItem() +1, (::it_file)->nintCount )
  ::wds_watch_mnoz( lnewRec, intCount )


  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
    if ::state = 2  ;  if .not. empty(file_iv)
                          (file_iv)->(dbgoto(recs_iv))
                          ::copyfldto_w(file_iv,::it_file)
                       endif
                       ::copyfldto_w(::hd_file,::it_file)
                       (::it_file)->ncislopvp  := 0
                       (::it_file)->nintcount  := ::ordItem()+1
    endif

    ::itsave()
    (::it_file)->ncenzahcel := (::it_file)->ncecprkbz
    *
    if is_nazPol
      (::it_file)->cnazPol1 := pa[1]
      (::it_file)->cnazPol2 := pa[2]
      (::it_file)->cnazPol3 := pa[3]
      (::it_file)->cnazPol4 := pa[4]
      (::it_file)->cnazPol5 := pa[5]
      (::it_file)->cnazPol6 := pa[6]
    endif
    *
    c_dph->(dbseek((::it_file)->nprocdph,,'C_DPH2'))
    (::it_file)->nklicdph := c_dph->nklicdph

    if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
    (::it_file)->(flock())
  endif

  fin_ap_modihd(::hd_file,.t.)

  ::setfocus(::state)
  ::dm:refresh()
return .t.


method pro_poklhd_in:postSave()
  local  ok := .f., odialog, nexit

  * p�epo�et hlavi�ky *
  fin_ap_modihd(::hd_file,.t.)

  * cht�j� co prodali to plat�
  c_typuhr->( dbseek( upper(poklhdW->czkrTypUhr),,'TYPUHR1'))
  if ::lnewrec
    poklhdw->nzaplaceno := if( c_typuhr->lisHotov, poklhdw->ncenzahcel, 0 )
  endif

  * zaplaceno - vr�ceno
  DRGDIALOG FORM 'PRO_poklhd_pay' PARENT ::drgDialog MODAL DESTROY ;
                                  EXITSTATE nExit

  if( nExit = drgEVENT_SAVE, ::saveParagon(), ::setfocus())
return ok


method pro_poklhd_in:saveParagon()
  local  ok := .t., value := ::cmb_typPoh:value
  local  cfrm, new_cisFak
  *
  local  cinfo    := 'Promi�te pros�m,', nsel := 1
  local  paButton := { '   ~Ano    ', '    ~Ne   ', '    ~S kop�   '  }
  local  ncopies  := 0

  * kontrola duplicity dokladu, po�izuj� ve stejn� �ad� proti sob�
  if ::lnewRec
    if poklhd_i->( dbseek( poklhdw->ncisFak,,'POKLHD3') )
      poklhdw->ncisFak := fin_range_key('POKLHD')[2]
    endif
  endif

  * zat�m, pak uvid�me
  if( ::lnewRec .and. poklhdw->npokladEET = 1 )
    poklhdw->ndoklad    := poklhdw->ncisfak
    poklhdw->ncenfakcel := poklhdw->ncenzakcel
    poklhdw->ncenfazcel := poklhdw->ncenzahcel

    if .not. empty(pokladms->cidDATkomE) .and. .not. empty(pokladms->mdefin_Kom)
      Asys_komunik_int( pokladms->cidDATkomE, ::drgDialog, .t. )
    endif
  endif

  * ulo��me
  ok := pro_poklhd_wrt(self)
  cfrm := AllTrim( SYSCONFIG('PRODEJ:CFRMPARAG'))
  *
  ** vytiskneme
  if SYSCONFIG('PRODEJ:LTISKPARAG') .and. .not. Empty( cfrm)
    if ::on_prnDoklad <> '0'
      cinfo += '; po�adujete tisk ��tenky [' +str(poklhdW->ndoklad) +' ] ... ?'
      nsel  := alertBox( ::drgDialog:dialog, cInfo               , ;
                         paButton, XBPSTATIC_SYSICON_ICONQUESTION, ;
                         'Zvolte mo�nost ...'                      )

     _clearEventLoop(.t.)
    endif
    *
    ** ve workVersion nebudu p�ece tisknout
    if .not. isWorkVersion
      if nsel <> 2
        ncopies := if( nsel = 3, val(::on_prnDoklad), 0 )

        if( forms->(dbSeek( cfrm,,'FORMS01')), LL_PrintDesign( ,'PRN',,.T.,, ncopies ), nil)
        poklhdw->( DbClearRelation())
        poklitw->( DbClearRelation())
      endif
    *
    ** ve workVersion se pod�v�me na n�hled
    else

      if nsel <> 2
        if( forms->(dbSeek( cfrm,,'FORMS01')), LL_PrintDesign( ,'PRV'), nil)
        poklhdw->( DbClearRelation())
        poklitw->( DbClearRelation())
      endif

    endif
  endif


  if(ok .and. ::new_dok)
    poklhdw->(dbclosearea())
    poklitw->(dbclosearea())

    pro_poklhd_cpy(self)

    ::cmb_typPoh:value := value
    ::comboItemSelected(::cmb_typPoh,0)

    SetAppFocus(::brow)
    ::brow:refreshAll()
    ::dm:refresh()
    *
    _clearEventLoop(.t.)
**    ::df:setNextFocus((::it_file) +'->csklpol',, .T. )
    *
    ** v cylklu dle CFG ::on_fstItems  na csklPol...ncisFirmy
    if( lower(::on_fstItems) = 'ncisfirmy', ::one_edt := ::hd_file +'->ncisFirmy', nil )
    PostAppEvent(drgEVENT_APPEND,,,::brow)

  elseif(ok .and. .not. ::new_dok)

    _clearEventLoop(.t.)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return ok


method pro_poklhd_in:onSave(lIsCheck,lIsAppend)                              // cmp_AS FIN_FAKVYSITw
  LOCAL  dc     := ::drgDialog:dialogCtrl
  LOCAL  cALIAs := ALIAS(dc:dbArea)

  IF !lIsCheck .and. cALIAs = 'POKLITW'
    // dopln�n� �daj� do polo�ek //
    C_DPH ->(mh_SEEK(poklitw ->nPROCDPH,2))
    poklitw->nKLICDPH  := C_DPH ->nKLICDPH
    poklitw ->nNAPOCET := C_DPH ->nNAPOCET

    // p�epo�tem hlavi�ku //
    FIN_ap_modihd('POKLHDW',.t.)
  ENDIF
RETURN .T.


method pro_poklhd_in:postDelete()

  ::wds_postDelete()
  fin_ap_modihd('POKLHDW',.t.)
return


method pro_poklhd_in:postItemMarked()


  if ::lnewRec .and. (::it_file)->(eof())
    ::setFocus(2)
    if( lower(::on_fstItems) = 'ncisfirmy', ::one_edt := ::hd_file +'->ncisFirmy', nil )
  endif
return nil


method pro_poklhd_in:showGroup()
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
method pro_poklhd_in:destroy()

  ::wds_disconnect()

  poklhdw->(dbclosearea())
  poklitw->(dbclosearea())
  *
  ::drgUsrClass:destroy()
return self


method pro_poklhd_in:takeValue(it_file,iz_file,iz_pos, dm)
  local  x, pos, value, items, mname, par
  local  iz_recs := (iz_file)->(recno())
  local  m_dm := ::dm

*                      poklitw,         cenzboz,   poklitW
*
  local  pa := { {      'cskp',              '',       'cskp' }, ;
                 { 'ccissklad',     'ccissklad',  'ccissklad' }, ;
                 {   'csklpol',       'csklpol',    'csklpol' }, ;
                 { 'nzbozikat',     'nzbozikat',  'nzbozikat' }, ;
                 {  'ncislodl',               0,   'ncislodl' }, ;
                 { 'cciszakaz',              '',  'cciszakaz' }, ;
                 {'ccislobint',              '', 'ccislobint' }, ;
                 {'nciszalfak',               0, 'nciszalfak' }, ;
                 {   'csklpol',       'csklpol',    'csklpol' }, ;
                 {   'cnazzbo',       'cnazzbo',    'cnazzbo' }, ;
                 { 'nfaktmnoz',               1,  'nfaktmnoz' }, ;
                 {'czkratjedn',    'czkratjedn', 'czkratjedn' }, ;
                 {   'nkoefmn',               1,    'nkoefmn' }, ;
                 {'nfaktmnkoe',               1, 'nfaktmnkoe' }, ;
                 { 'czkrjednd',    'czkratjedn',  'czkrjednd' }, ;
                 { 'ncenazakl',     'ncenapzbo',  'ncenazakl' }, ;
                 {  'nprocdph',  ':favst_dph/2',   'nprocdph' }, ;
                 {  'nnapocet',  ':favst_dph/6',   'nnapocet' }, ;
                 { 'ncejprzbz',     'ncenapzbo',  'ncejprzbz' }, ;
                 { 'nhodnslev',               0,  'nhodnslev' }, ;
                 { 'nprocslev',               0,  'nprocslev' }, ;
                 { 'ncejprkdz',     'ncenamzbo',  'ncejprkdz' }, ;
                 { 'ncejprzdz',     'ncenamzbo',  'ncejprzdz' }, ;
                 { 'ncecprkbz',               0,  'ncecprkbz' }, ;
                 { 'ncelkslev',               0,  'ncelkslev' }, ;
                 { 'ncecprkbz',               0,  'ncecprkbz' }, ;
                 { 'ncecprkdz',               0,  'ncecprkdz' }, ;
                 { 'cdoplntxt',              '',  'cdoplntxt' }, ;
                 {     'cucet', ':favst_czns/0',      'cucet' }, ;
                 {  'cnazpol1', ':favst_czns/1',   'cnazpol1' }, ;
                 {  'cnazpol2', ':favst_czns/2',   'cnazpol2' }, ;
                 {  'cnazpol3', ':favst_czns/3',   'cnazpol3' }, ;
                 {  'cnazpol4', ':favst_czns/4',   'cnazpol4' }, ;
                 {  'cnazpol5', ':favst_czns/5',   'cnazpol5' }, ;
                 {  'cnazpol6', ':favst_czns/6',   'cnazpol6' }, ;
                 {'nradvykdph',   ':favst_rv/1', 'nradvykdph' }  }

  if( isObject(dm), ::dm := dm, nil )

  for x := 1 to len(pa) step 1
    if IsObject(ovar := ::dm:has(it_file +'->' +pa[x,1]))

      do case
      case empty(pa[x,iz_pos]) .or. isnumber(pa[x,iz_pos])
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

      * n�kdo nastavuje rela�n� vazby na DB - pak dojde k repozici na postValidateRelate
      * hlavn� u cenzboz tam je kl�� ccisSklad +csklPol
      * nastaven� relace jen na csklPol je chyb� !!!
      if iz_recs <> 0
        if( iz_recs <> (iz_file)->(recno()), (iz_file)->(dbgoto(iz_recs)), nil )
      endif

    endif
  next

  ::favst_koefMn()
  ::favst_procSlev()

  if( IsObject(ovar := ::dm:has(it_file +'->cfile_iv')), ovar:set(iz_file)             , nil)
  if( IsObject(ovar := ::dm:has(it_file +'->nrecs_iv')), ovar:set((iz_file)->(recno())), nil)

  ::dm := m_dm
return

*
* nprocdph, nnapocet
method pro_poklhd_in:favst_dph(par)
  local  klicDph := DBGetVal('cenzboz->nklicdph'), procDph
  *
  local  hd_file := ::dm:drgDialog:dbname

  drgDBms:open('c_dph')
  c_dph->(dbseek(klicDph,,'C_DPH1'))
return if(par = 2, c_dph->nprocdph, c_dph->nnapocet)

*
*  cucet, cnazpol1, cnazpol2, cnazpol3, cnazpol4, cnazpol5, cnazpol6
method pro_poklhd_in:favst_czns(par)
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

*
* nradvykdph
method pro_poklhd_in:favst_rv(par)
  local retVal := '0', cradDph, pa, ovar
  *
  local it_file := ::dm:drgDialog:udcp:it_file
  local hd_file := ::dm:drgDialog:udcp:hd_file
  local cky     := upper((hd_file)->culoha    ) + ;
                   upper((hd_file)->ctypdoklad) + ;
                   upper((hd_file)->ctyppohybu)
  *
  local duzp    := (hd_file)->dpovinfak

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

* _ tady se nepou��v�
method pro_poklhd_in:favst_vyz(par)
  local  retVal

  drgDBms:open('vyrpol')
  vyrpol->(dbseek(vyrzak->(sx_keydata()),,'VYRPOL1'))

  if par = 1  ; retval := vyrzak->nmnozplano - vyrzak->nmnozfakt
  else        ; retVal := vyrpol->czkratjedn
  endif
return retVal

*
** vazba na c_prepmj
method pro_poklhd_in:favst_koefMn()
  local  koefMn := 1
  *
  local  o_cisSklad  := ::dm:has(::it_file +'->ccisSklad' ), ;
         o_sklPol    := ::dm:has(::it_file +'->csklPol'   ), ;
         o_fakMnoz   := ::dm:has(::it_file +'->nfaktmnoz' ), ;
         o_koefMn    := ::dm:has(::it_file +'->nkoefmn'   ), ;
         o_faktMnKoe := ::dm:has(::it_file +'->nfaktmnKoe'), ;
         o_zkrJednD  := ::dm:has(::it_file +'->czkrjednd' )

  if c_prepmj->( dbseek( upper(o_cisSklad:value) +upper(o_sklPol:value),, 'C_PREPMJ02'))
    koefMn := c_prepmj->nkoefPrVC
    o_fakMnoz:set( o_faktMnKoe:value *koefMn )

    o_koefMn:set( c_prepmj->nkoefPrVC )
    o_zkrJednD:set( c_prepmj->cvychoziMJ )
  endif
return

*
** vazba na procenho
method pro_poklhd_in:favst_procSlev()
  local  filtr, m_filtr, procento := 0
  local  o_cisSklad  := ::dm:has(::it_file +'->ccisSklad' ), ;
         o_sklPol    := ::dm:has(::it_file +'->csklPol'   ), ;
         o_zboziKat  := ::dm:has(::it_file +'->nzboziKat' )
*
  local  o_procSlev  := ::dm:has(::it_file +'->nprocSlev' ), ;
         o_hodnSlev  := ::dm:has(::it_file +'->nhodnSlev' ), ;
         o_cejPrKDZ  := ::dm:has(::it_file +'->ncejPrKDZ' )
  *
  local cisFirmy := (::hd_file)->ncisFirmy, zkrTypUhr := 'CASH'         , dvystFak := (::hd_file)->dvystFak
  local cisSklad := o_cisSklad:value      , sklPol    := o_sklPol:value , zboziKat := o_zboziKat:value
  local m_cky    := upper(cisSklad) +upper(sklPol)


  filtr := "ntypProCen = 7 .and. "                                  + ;
           "  (ncisFirmy = %% .or. ncisFirmy = 0) .and. "           + ;
           "( (ccisSklad = '%%' .and. csklPol = '%%') .or. nzboziKat = %% .or. contains(czkrTypUhr,'%%') )"

  m_filtr := format( filtr, {cisFirmy, cisSklad, sklPol, zboziKat, zkrTypUhr})

  procenho->(ads_setAof(m_filtr),dbgoTop())
  cenprodc->(dbseek( m_cky,,'CENPROD1'))
  *
  ** sleva nastaven�/ zanulovan� na hlavi�ce m� p�ednost
  if poklhdw->nprocslhot <> 0 .or. poklhdw->nNullSlHot > 0
    procento := if( poklhdw->nprocslhot <> 0, poklhdw->nprocslhot, 0 )

  elseif .not. procenho->(eof())
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

  o_procSlev:set(procento)
  o_hodnSlev:set((cenprodc->ncenaMzbo * procento) / 100)
  o_cejPrKDZ:set( cenprodc->ncenaMzbo - o_hodnSlev:value )
return procento

static function is_datumOk(datum)
  local  ok :=  empty(procenho->dplatnyOD) .or. ;
                (procenho->dplatnyOD <= datum .and. procenho->dplatnyDO >= datum)
return ok
**
*

method pro_poklhd_in:openKase()
  local  oPrinter := XbpPrinter():new()
  local  oSpace   := XbpPresSpace():new()
  local  cond

  oPrinter:Create()
  oSpace:Create(oPrinter)

  cond := Chr(27)+Chr(112)+Chr(48)+Chr(56)+Chr(56)
  oSpace:device():StartDoc()
  devOut(cond)
  oSpace:device():EndDoc()
return


*
** CLASS for PRO_poklhd_edit_pc ************************************************
CLASS PRO_poklhd_edit_pc FROM drgUsrClass
EXPORTED:
  var  dm, dc, df

  inline method init(parent)
    local nEvent,mp1,mp2,oXbp

    nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
    IF IsOBJECT(oXbp:cargo)
      ::drgGet := oXbp:cargo
    ENDIF

    ::it_file := 'poklitW'

    ::drgUsrClass:init(parent)
  return self

  inline method drgDialogStart(drgDialog)
    local  pa_cargo_Usr := drgDialog:cargo_Usr

    ::dm          := drgDialog:dataManager             // dataManager
    ::dc          := drgDialog:dialogCtrl              // dataCtrl
    ::df          := drgDialog:oForm                   // form

    ::nfaktMnKoe    := 1
    ::is_slevy_Edit := .f.

    if isArray(pa_cargo_Usr)
      ::dm:set(::it_file +'->nCEJPRZDZ', pa_cargo_Usr[1] )
      ::dm:set(::it_file +'->nHODNSLEV', pa_cargo_Usr[2] )
      ::dm:set(::it_file +'->nPROCSLEV', pa_cargo_Usr[3] )
      ::dm:set(::it_file +'->nCEJPRKDZ', pa_cargo_Usr[4] )

      ::dm:set(::it_file +'->ncelkSlev', pa_cargo_Usr[5] )
      ::dm:set(::it_file +'->ncecPrKdz', pa_cargo_Usr[6] )

      ::nfaktMnKoe := pa_cargo_Usr[7]
    endif

    if poklhdw->nprocslhot <> 0 .or. poklhdw->nNullSlHot > 0
      ::dm:has(::it_file +'->nHODNSLEV'):odrg:oxbp:disable()
      ::dm:has(::it_file +'->nPROCSLEV'):odrg:oxbp:disable()
    else
      ::dm:has(::it_file +'->nHODNSLEV'):odrg:oxbp:enable()
      ::dm:has(::it_file +'->nPROCSLEV'):odrg:oxbp:enable()
      ::is_slevy_Edit := .t.
    endif

  return self

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

    do case
    case nevent = drgEVENT_SAVE
      PostAppEvent(xbeP_Close,drgEVENT_SAVE,,::drgDialog:dialog)
      return .t.
    otherwise
      return .f.
    endcase
  return .t.

  inline method postValidate(drgVar)
    local  name    := Lower(drgVar:name)
    local  changed := drgVAR:Changed()
    local  ncejPrZdz, nhodnSlev, nprocSlev, ncejPrKdz, ;
           ncecPrKdz, ncelkSlev
    *
    local  nevent := mp1 := mp2 := nil

    * F4
    nevent  := LastAppEvent(@mp1,@mp2)
    If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

    * 1
    ncejPrZdz  := ::dm:has(::it_file +'->nCEJPRZDZ' )
    nhodnSlev  := ::dm:has(::it_file +'->nHODNSLEV' )
    nprocSlev  := ::dm:has(::it_file +'->nPROCSLEV' )
    ncejPrKdz  := ::dm:has(::it_file +'->nCEJPRKDZ' )
    * 2
    ncecPrKdz  := ::dm:has(::it_file +'->ncecPrKdz' )
    ncelkSlev  := ::dm:has(::it_file +'->ncelkSlev' )
    ncecPrKdz  := ::dm:has(::it_file +'->ncecPrKdz' )

    do case
    case(name = ::it_file +'->ncejprzdz'  .and. changed)
      nhodnSlev:set((ncejPrZdz:value * nprocSlev:value) /100)
      nhodnSlev:value     := round(nhodnSlev:value,2)
      nhodnSlev:initValue := nhodnSlev:prevValue := nhodnSlev:value

    case(name = ::it_file +'->nhodnslev'  .and. changed)
      nprocSlev:set(nhodnSlev:value/ncejPrZdz:value *100)

      nprocSlev:value     := round(nprocSlev:value,2)
      nhodnSlev:initValue := nhodnSlev:prevValue := nhodnSlev:value
      nprocSlev:initValue := nprocSlev:prevValue := nprocSlev:value

    case(name = ::it_file +'->nprocslev'  .and. changed)
      nhodnSlev:set((ncejPrZdz:value * nprocSlev:value) /100)

      nhodnSlev:value     := round(nhodnSlev:value,2)
      nhodnSlev:initValue := nhodnSlev:prevValue := nhodnSlev:value
      nprocSlev:initValue := nprocSlev:prevValue := nprocSlev:value
    endcase

    ncejPrKdz:set( ncejPrZdz:value - nhodnSlev:value )
    ncelkSlev:set( nhodnSlev:value * ::nfaktMnKoe )
    ncecPrKdz:set( ncejPrKdz:value * ::nfaktMnKoe )

    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN )
      do case
      case (name = ::it_file +'->ncejprzdz' .and. .not. ::is_slevy_Edit)
        PostAppEvent(xbeP_Close,drgEVENT_SAVE,,::drgDialog:dialog)

      case (name = ::it_file +'->nprocslev')
        PostAppEvent(xbeP_Close,drgEVENT_SAVE,,::drgDialog:dialog)
      endcase
    endif

  return .t.

HIDDEN:
  var  drgGet, it_file, nfaktMnKoe, is_slevy_Edit
ENDCLASS


*
** CLASS for c_prepmj_sel ******************************************************
CLASS PRO_poklhd_c_prepmj_sel FROM drgUsrClass
EXPORTED:
  *
  ** bro column
  inline access assign method nazJednot() var nazJednot
    c_jednot->( dbseek( upper(c_prepmj->cvychoziMJ),,'C_JEDNOT1' ))
    return c_jednot->cnazJednot

  inline method init(parent)
    ::parent_udcp := parent:parent:udcp
    ::cisSklad    := ::parent_udcp:cisSklad
    ::sklPol      := ::parent_udcp:sklPol

    ::value       := if( isNull(parent:cargo), '', parent:cargo)
    ::lsearch     := .not. isNull(parent:cargo)

    ::drgUsrClass:init(parent)
  return self

  inline method getForm()
    local  oDrg, drgFC := drgFormContainer():new()

    DRGFORM INTO drgFC SIZE 70,10 DTYPE '10' TITLE 'V�b�r m�rn� jednotky ..... ' ;
                                             GUILOOK 'All:N,Border:Y'
    DRGTEXT INTO drgFC CAPTION 'Vyberte typ po�adovan�ho p�epo�tu ... ' CPOS 0,9 CLEN 70 PP 2 BGND 15

    DRGDBROWSE INTO drgFC  SIZE 70,9 FPOS -.5,0 FILE 'c_prepmj'         ;
                           FIELDS 'cvychoziMJ:mj_V,'                  + ;
                                  'M->nazJednot:n�zev mj_v�choz�:48,' + ;
                                  'nkoefPrVC:koef'                      ;
                           SCROLL 'ny' CURSORMODE 3 PP 7
  RETURN drgFC


  inline method drgDialogStart(drgDialog)
    local  cfiltr
    local  cflt := "ccisSklad = '%%' .and. csklPol = '%%'"

    cfiltr := format( cflt, { ::cisSklad:value, ::sklPol:value })
    c_prepmj->( ads_setAof( cfiltr), dbgoTop() )

    ::brow    := drgDialog:dialogCtrl:oBrowse
    ::msg     := drgDialog:oMessageBar             // messageBar
    ::dm      := drgDialog:dataManager             // dataMabanager
    ::dc      := drgDialog:dialogCtrl              // dataCtrl
    ::df      := drgDialog:oForm                   // form
    if isobject(drgDialog:oActionBar)
      ::ab      := drgDialog:oActionBar:members    // actionBar
    endif
  return


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = xbeBRW_ItemMarked)
     ::dm:refresh()

    case nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close,drgEVENT_SAVE,,::drgDialog:dialog)
      return .t.

    case(nevent = drgEVENT_MSG)
      if mp2 = DRG_MSG_ERROR
        _clearEventLoop()
         SetAppFocus(::drgDialog:dialogCtrl:oBrowse:oXbp)
         return .t.
      endif
      return .f.

    endcase
  return .f.

  inline method destroy()
    c_prepmj->( ads_clearAof())

    ::drgUsrClass:destroy()
  return self

HIDDEN:
  var    msg, dm, dc, df, ab, brow
  var    parent_udcp, cisSklad, sklPol
  *
  var    drgGet, lsearch, value
ENDCLASS


*
** CLASS for PRO_poklhd_edit_ns ************************************************
CLASS PRO_poklhd_edit_ns FROm drgUsrClass
EXPORTED:
  method init, drgDialogStart

  *
  ** EVENT *********************************************************************
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

   do case
    case nevent = drgEVENT_SAVE
      PostAppEvent(xbeP_Close,drgEVENT_SAVE,,::drgDialog:dialog)
      return .t.
/*
    case nEvent = xbeP_Keyboard
      if mp1 == xbeK_ESC
        if ::on_zaplaceno <> '1' ; return .t.
        else                     ; return .f.
        endif
      else
        return .f.
      endif
*/
    otherwise
      return .f.
    endcase
  return .t.

HIDDEN:
  var dm, df
ENDCLASS


method PRO_poklhd_edit_ns:init(parent)
  ::drgUsrClass:init(parent)
return self


method PRO_poklhd_edit_ns:drgDialogStart(drgDialog)
  local  pa := drgDialog:parent:UDCP:a_nazPol

  ::dm := drgDialog:dataManager             // dataMabanager
  ::df := drgDialog:oForm                   // form

  ::dm:set('poklitw->cnazPol1', pa[1] )
  ::dm:set('poklitw->cnazPol2', pa[2] )
  ::dm:set('poklitw->cnazPol3', pa[3] )
  ::dm:set('poklitw->cnazPol4', pa[4] )
  ::dm:set('poklitw->cnazPol5', pa[5] )
  ::dm:set('poklitw->cnazPol6', pa[6] )
return self


*
** CLASS for PRO_poklhd_pay ****************************************************
CLASS PRO_poklhd_pay FROM drgUsrClass
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postValidate
  method  comboBoxInit, comboItemSelected
  method  fir_firmy_sp_sel, pro_stroje_sp_sel
  *
  var     pay_celkBezSlev, pay_celkSleva, pay_celkSeSlevou

  *
  * { c_typuhr->cpopisUhr, c_typuhr->czkrTypUhr, c_typuhr->cpopisUhr, c_typuhr->lisHotov, c_typUhr->npokladEet }
  inline method set_lisHotov()
    local  pa := ::pa_set_isHotov
    local  nin
    local  lisHotov

    if ::n_count_isHotov = 0
      nin := ascan( pa, {|x| upper(x[2]) = upper(poklhdw->czkrtypuhr) } )
      if( nin = 0, nin := 1, nil )
    else
      nin := if( ::n_count_isHotov +1 > len(pa), 1, ::n_count_isHotov +1 )
    endif

    ::n_count_isHotov := nin

    ::obtn_set_lisHotov:oxbp:setCaption( pa[nin,1] )

    lisHotov := poklhdw->lisHotov   := pa[nin,4]
                poklhdw->npokladEET := pa[nin,5]

    ::dm:set( 'poklhdw->nzaplaceno', if( lisHotov, poklhdw->ncenzahcel, 0 ))
    ::dm:set( 'poklhdw->nvraceno'  , 0                                     )
    ::dm:set( 'poklhdw->czkrtypuhr', pa[nin,2]                             )

    ::df:setNextFocus('poklhdw->nzaplaceno',,.t.)
    return self


  inline method set_nNullSLHot()
    local nNullSlHot := poklhdW->nNullSlHot

    poklhdW->nNullSlHot := if( poklhdW->nNullSlHot = 0, 1, 0 )
    ::obtn_set_nNullSlHot:oxbp:SetGradientColors( if( poklhdW->nNullSlHot = 0, nil    , {0,5} ) )
    ::obtn_set_nNullSlHot:oxbp:setCaption(        if( poklhdW->nNullSlHot = 0, '<> 0%', '= 0%') )

    if nNullSlHot = 0 .and. poklhdW->nNullSlHot = 1
      ::dm:set( 'poklhdw->nprocslhot', 0       )
      ::dm:set( 'poklhdw->czkrtypuhr', 'BEZHO' )
      ::o_procSlHot:prevValue := .1
      postAppEvent(xbeP_Keyboard,xbeK_ENTER,,::o_procSlHot:odrg:oxbp)
    endif
    return self


  inline method preValidate(drgVar)
    local o_cmbzkrTypUhr := ::dm:has('poklhdw->czkrTypUhr'):odrg

    if( ::is_tabselect, ::ndouble := 0, nil )

    if ::tabNum = 1 .and. ::is_tabselect
      PostAppEvent(xbeP_Keyboard,xbeK_TAB,,o_cmbzkrTypUhr:oxbp)
    else
    endif

    ::is_tabselect := .f.
    return .t.


  inline method tabSelect( otabPage, tabNum)
    local  recNo    := poklitW->(recNo())
    local  lisHotov := poklhdW->lisHotov

    ::ndouble      := 0
    ::tabNum       := otabPage:tabNumber
    ::is_tabSelect := .t.

    do case
    case( otabPage:tabNumber = 1)  // 2 -> 1
      ::cenZahCel:set( poklhdw->ncenzahcel )

      ::dm:set( 'poklhdw->ncenzahcel', poklhdw->ncenzahcel )
      ::dm:set( 'poklhdw->nzaplaceno', if( lisHotov, poklhdw->nzaplaceno, 0 ) )
      ::dm:set( 'poklhdw->nvraceno'  , poklhdw->nvraceno   )

    case( otabPage:tabNumber = 2)  // 1 -> 2
      ::pay_celkBezSlev  := 0
      ::pay_celkSleva    := 0
      ::pay_celkSeSlevou := 0

      poklitw->( dbeval( { || ( ::pay_celkBezSlev  += ( poklitw->ncejPrZdz * poklitw->nfaktMnKoe ), ;
                                ::pay_celkSleva    += ( poklitw->nhodnSlev * poklitw->nfaktMnKoe ), ;
                                ::pay_celkSeSlevou += poklitw->ncecPrKdz                            ) } ))
      poklitw->(dbgoTo(recNo))

      ::dm:set( 'M->pay_celkBezSlev' , ::pay_celkBezSlev  )
      ::dm:set( 'M->pay_celkSleva'   , ::pay_celkSleva    )
      ::dm:set( 'M->pay_celkSeSlevou', ::pay_celkSeSlevou )
    endcase

    return .t.

  *
  ** EVENT *********************************************************************
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local nicon_keyDouble := if( ::ndouble = 0, 0, 101 )

    if ::sta_keyDouble:oxbp:caption <> nicon_keyDouble
      ::sta_keyDouble:oxbp:setCaption( nicon_keyDouble )
    endif

    do case
    case nevent = drgEVENT_SAVE .and. ::ndouble = 2
      PostAppEvent(xbeP_Close,drgEVENT_SAVE,,::drgDialog:dialog)
      return .t.

    case nEvent = xbeP_Keyboard
      if mp1 == xbeK_ESC
        if ::on_zaplaceno <> '1' ; return .t.
        else                     ; return .f.
        endif
      else
        return .f.
      endif

    otherwise
      return .f.
    endcase
  return .t.

HIDDEN:
  VAR  drgGet, dm, df, bro_bord, on_zaplaceno, on_isHotov, ndouble, lisHotov
  var  cenZahCel
  var  tabNum, is_tabSelect
  var  o_zkrTypUhr, o_zaplaceno
  var  arSelect_DOA
  var  obtn_set_lisHotov, pa_set_isHotov, n_count_isHotov
  var  hd_file, sta_keyDouble

  var  obtn_set_nNullSlHot
  var  o_procSlHot


  inline method refreshGroup(drgvar, panGroup)
    local  nin, ovar, vars, new_val, dbarea, ok

//    default nextFocus to .f.

    dbarea := lower(drgParse(drgVar:name,'-'))
    vars   := drgVar:drgDialog:dataManager:vars

    for x := 1 to vars:size() step 1
      ovar := vars:getNth(x)
      if( ovar:odrg:groups = panGroup)
        if (dbArea == lower(drgParse(oVar:name,'-')) .or. 'M' == drgParse(oVar:name,'-')) .and. isblock(ovar:block)
          if(new_val := eval(ovar:block)) <> ovar:value
            ovar:set(new_val)
          endif
        endif
      endif
    next

//    if nextFocus
//      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
//    endif
  return .t.
ENDCLASS



method PRO_poklhd_pay:init(parent)
  local  nEvent,mp1,mp2,oXbp
  local  acombo_val := {}

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF

  ::drgUsrClass:init(parent)

  drgDBMS:open( 'firmyVa' )
  drgDBMS:open( 'firmy',,,,,'firmy_vaw')

*  ::lnewRec      := parent:parent:UDCP:lNEWrec
  ::on_isHotov     := parent:parent:UDCP:on_isHotov
  ::on_zaplaceno   := parent:parent:UDCP:on_zaplaceno
  ::cenZahCel      := parent:parent:UDCP:cenZahCel
  ::bro_bord       := parent:parent:UDCP:brow:cargo:obord
  ::ndouble        := 0
  ::tabNum         := 1
  ::is_tabSelect   := .f.
  ::pa_set_isHotov := { 'Platba v hotovosti', 'Bez_Hotovostn� platba' }
  ::hd_file        := 'poklhdw'
  *
  ** Sleva na celkovou ��stku
  ::pay_celkBezSlev  := 0
  ::pay_celkSleva    := 0
  ::pay_celkSeSlevou := 0

  c_typuhr->(dbEval( {|| aAdd(acombo_val, { left(c_typuhr->cpopisUhr,36), c_typuhr->czkrTypUhr, c_typuhr->cpopisUhr, c_typuhr->lisHotov, c_typUhr->npokladEet }) }, ;
                      {|| c_typuhr->lisRegPok                                                  }  ) )
  ::pa_set_isHotov  := acombo_val
  ::n_count_isHotov := 0
return self


method PRO_poklhd_pay:drgDialogInit(drgDialog)
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.
return


method PRO_poklhd_pay:drgDialogStart(drgDialog)
  local  x, className
  local  aMembers := drgDialog:oForm:aMembers
  local  cf       := "ncisFirmy = %% .and. czkr_SKva = '%%'", cFilter
  local  arSelect_DOA, is_Doa

  arSelect_DOA := ::arSelect_DOA := {}

  ::dm := drgDialog:dataManager             // dataManager
  ::df := drgDialog:oForm                   // form

  ::o_zkrTypUhr := ::dm:has('poklhdw->czkrTypUhr')
  ::o_zaplaceno := ::dm:has('poklhdw->nzaplaceno')
  *
  ::o_procslhot := ::dm:has('poklhdw->nprocslhot')

  for x := 1 to len(aMembers) step 1
    className := aMembers[x]:ClassName()

    if className = 'drgPushButton'
      if isCharacter( aMembers[x]:event )
        do case
        case( aMembers[x]:event = 'set_lisHotov'  )  ; ::obtn_set_lisHotov   := aMembers[x]
        case( aMembers[x]:event = 'set_nNullSlHot')  ; ::obtn_set_nNullSlHot := aMembers[x]
        endcase
      endif

    elseif classname = 'drgStatic'
      if aMembers[x]:oxbp:type = XBPSTATIC_TYPE_ICON
        ::sta_keyDouble := aMembers[x]
      endif
    endif
  next
  *
  ** zablokujem DOA pokud nen� nastavena --> FAA => DOA
  cFilter := format( cf, { poklhdw->ncisFirmy, 'DOA' } )
  firmyVa->( ads_setAof(cFilter) , ;
             dbEval( { || if( firmy_vaw->( dbseek( firmyVa->ncisFirVa,,'FIRMY1')), aadd( arSelect_DOA, firmy_vaw->( recNo())), nil ) } ), ;
             ads_clearAof()       )

  is_Doa := ( poklhdw->ncisFirmy <> 0 .and. len(arSelect_DOA) > 0 )
  if .not. is_Doa
    isEditGet( {'poklhdw->NCISFIRDOA', 'poklhdw->NICODOA', 'poklhdw->CDICDOA', 'poklhdw->CNAZEVDOA'}, drgDialog, .f. )
  endif

*** EET
  ::obtn_set_lisHotov:isEdit := .f.
  ::set_lisHotov()
*  ::obtn_set_lisHotov:oxbp:setCaption( if( poklhdW->lisHotov, ::pa_set_isHotov[1], ::pa_set_isHotov[2] ))
  ::sta_keyDouble:oxbp:setCaption(0)

  ::obtn_set_nNullSlHot:isEdit := .f.
  ::obtn_set_nNullSlHot:oXbp:setFont(drgPP:getFont(5))
  ::obtn_set_nNullSlHot:oxbp:SetGradientColors( if( poklhdW->nNullSlHot = 0, nil    , {0,5} ) )
  ::obtn_set_nNullSlHot:oxbp:setCaption(        if( poklhdW->nNullSlHot = 0, '<> 0%', '= 0%') )

  ::df:setNextFocus('poklhdw->nzaplaceno',,.t.)
return self


method PRO_poklhd_pay:comboBoxInit(drgCombo)
  local  cname := drgParseSecond(drgCombo:name,'>')
  local  acombo_val := {}, npos
  local  zkrTypUhr  := poklhdw->czkrTypUhr

  if lower(cname) = 'czkrtypuhr'
    c_typuhr->(dbEval( {|| aAdd(acombo_val, { upper(c_typuhr->czkrTypUhr), c_typuhr->cpopisUhr, c_typuhr->lisHotov, c_typUhr->npokladEet }) }, ;
                       {|| c_typuhr->lisRegPok                                                  }  ) )

    drgCombo:oXbp:clear()
    drgCombo:values := ASort( acombo_val,,, {|aX,aY| aX[2] < aY[2] } )
    aeval(drgCombo:values, { |a| drgCombo:oXbp:addItem( a[2] ) } )

    * mus�me nastavit startovac� hodnotu *
    drgCombo:value := drgCombo:ovar:value := zkrTypUhr

    npos       := ascan( acombo_val, { |x| x[1] = upper(zkrTypUhr) })
    ::lisHotov := if( npos <> 0, acombo_val[npos,3], .t. )
  endif
return self


method PRO_poklhd_pay:comboItemSelected(drgCombo,mp2,o)
  local  cname := drgParseSecond(drgCombo:name,'>')
  local  value, values, cKy, nIn

  if isobject(drgCombo)
    value  := drgCombo:Value
    values := drgCombo:Values

    if lower(cname) = 'czkrtypuhr'
      nIn := AScan(values, {|X| X[1] = value })
      ::lisHotov := values[nin,3]
    endif

    if ::lisHotov
      if( ::o_zaplaceno:value = 0, ::o_zaplaceno:set(poklhdw->ncenzahcel), nil )
    else
      ::o_zaplaceno:set(0)
    endif

    poklhdw->czkrtypuhr := value
    ::ndouble           := 0
    ::df:setNextFocus('poklhdw->nzaplaceno',,.t.)
  endif
return self


method PRO_poklhd_pay:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name), changed := drgVAR:Changed()
  local  ok    := .t.
  *
  local  recNo    := poklitW->( recNo())
  local  lisHotov := poklhdW->lisHotov


  do case
  case(name = 'poklhdw->nzaplaceno')

    ok := if( lisHotov, ((value <> 0) .and. (value >= poklhdw->ncenzahcel)), .t. )

    if ok
      if lisHotov
         poklhdw->nzaplaceno := value
         poklhdw->nvraceno   := value -poklhdw->ncenzahcel
         ::dm:set('poklhdw->nvraceno', poklhdw->nvraceno)
       else
         poklhdw->nzaplaceno := 0
         poklhdw->nvraceno   := 0
         ::dm:set('poklhdw->nzaplaceno', 0 )
         ::dm:set('poklhdw->nvraceno'  , 0 )
       endif

      ::ndouble++

      if ::ndouble = 2
        poklhdw->czkrtypuhr := ::dm:get('poklhdw->czkrtypuhr')
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif

      ::df:setNextFocus('poklhdw->nzaplaceno')
    endif

  case(name = 'poklhdw->nprocslhot')
    if changed

      do case
      case ( drgVar:initValue <> 0 .and. value =  0 )   // <>0 -> =0
        poklhdW->nnullSlHot := 1
      case ( drgVar:initValue =  0 .and. value <> 0 )   // =0 -> <>0
        poklhdW->nnullSlHot := 0
      endcase

      ::obtn_set_nNullSlHot:oxbp:SetGradientColors( if( poklhdW->nNullSlHot = 0, nil    , {0,5} ) )
      ::obtn_set_nNullSlHot:oxbp:setCaption(        if( poklhdW->nNullSlHot = 0, '<> 0%', '= 0%') )

      eval(drgVar:block,drgVar:value)
      drgVar:initValue := drgVar:value

      poklitW->( dbgoTop()                                       , ;
                 dbeval( { || pro_poklhd_pay_reCompute(value) } )  )
      poklitW->( dbgoTo( recNo))

      fin_ap_modihd('poklhdW',.t.)
      poklhdw->nzaplaceno := poklhdw->ncenzahcel
    endif

  case(name = 'poklhdw->ncisfirdoa' .or. name = 'poklhdw->ncisfirdop')
     ok := if( changed, ::fir_firmy_sp_sel(), .t.)

  otherwise

    if ::tabNum = 3 .and. changed
      eval(drgVar:block,drgVar:value)
      drgVar:initValue := drgVar:value
    endif
  endcase
return ok


method PRO_poklhd_pay:fir_firmy_sp_sel(drgDialog)
  local  oDialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  cisFirmy := poklhdw->ncisFirmy
  local  drgVar   := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  value    := drgVar:get()
  local  name     := lower(drgVar:name)
  local  file     := drgParse(name,'-'), item := lower( drgParseSecond(name,'>'))
  local  panGroup
  *
  * u DOP je to jedno, lze vybrat kohokoliv z FIRMY
  * u DOD mus� existovat v seznamu dodac�ch adres vazba na firmyVA
  ok := firmy->( dbseek(value,,'FIRMY1'))
  ok := if( item = 'ncisfirdoa', ( ascan( ::arSelect_DOA, firmy->( recNo())) <> 0 .and. ok), ok )

  if isobject(drgdialog) .or. .not. ok
    oDialog := drgDialog():new('FIR_FIRMY_sp_SEL', ::dm:drgDialog)
    oDialog:cargo_usr := cisFirmy
    oDialog:create(,,.T.)

    nExit := oDialog:exitState
    oDialog:destroy(.T.)
    oDialog := NIL
  endif
  *
  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)
  *
  if copy
    do case
    case( item = 'ncisfirdop' )  ;  panGroup := 'DOP'
                                    (::hd_file)->ncisFirDOP  := firmy->ncisFirmy
                                    (::hd_file)->cnazevDOP   := firmy->cnazev
                                    (::hd_file)->cnazevDOP2  := firmy->cnazev2
                                    (::hd_file)->nicoDOP     := firmy->nico
                                    (::hd_file)->cdicDOP     := firmy->cdic
                                    (::hd_file)->culiceDOP   := firmy->culice
                                    (::hd_file)->csidloDOP   := firmy->csidlo
                                    (::hd_file)->cpscDOP     := firmy->cpsc

                                    if stroje->( dbseek(firmy->ncisFirmy,, 'STROJE07'))
                                      (::hd_file)->cspz := stroje->cspzStroj
                                    endif

    case( item = 'ncisfirdoa' )  ;  panGroup := 'DOA'
                                    (::hd_file)->ncisFirDOA  := firmy->ncisFirmy
                                    (::hd_file)->cnazevDOA   := firmy->cnazev
                                    (::hd_file)->cnazevDOA2  := firmy->cnazev2
                                    (::hd_file)->nicoDOA     := firmy->nico
                                    (::hd_file)->cdicDOA     := firmy->cdic
                                    (::hd_file)->culiceDOA   := firmy->culice
                                    (::hd_file)->csidloDOA   := firmy->csidlo
                                    (::hd_file)->cpscDOA      := firmy->cpsc
    endcase

    ::refreshGroup( drgVar, panGroup )
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method PRO_poklhd_pay:pro_stroje_sp_sel(drgDialog)
  local  oDialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  cisFirDop := (::hd_file)->ncisFirDop
  local  drgvar    := ::dm:has('poklhdw->ncisFirDOP')
  local  recNo     := firmy->( recNo())

  if isobject(drgdialog) .or. .not. ok
    oDialog := drgDialog():new('PRO_stroje_sp_SEL', ::dm:drgDialog)
    oDialog:cargo_usr := cisFirDop
    oDialog:create(,,.T.)

    nExit := oDialog:exitState
    oDialog:destroy(.T.)
    oDialog := NIL
  endif
  *
  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)
  *
  if copy
    panGroup := 'DOP'
    if cisFirDop <> stroje->ncisFirmy
      firmy->( dbseek( stroje->ncisFirmy,,'FIRMY1'))

      (::hd_file)->ncisFirDOP  := firmy->ncisFirmy
      (::hd_file)->cnazevDOP   := firmy->cnazev
      (::hd_file)->cnazevDOP2  := firmy->cnazev2
      (::hd_file)->nicoDOP     := firmy->nico
      (::hd_file)->cdicDOP     := firmy->cdic
      (::hd_file)->culiceDOP   := firmy->culice
      (::hd_file)->csidloDOP   := firmy->csidlo
      (::hd_file)->cpscDOP     := firmy->cpsc
    endif

    (::hd_file)->cspz := stroje->cspzStroj

    ::refreshGroup( drgVar, panGroup )
  endif

  firmy->( dbgoTo( recNo))
return (nexit != drgEVENT_QUIT) .or. ok

*
**
static function pro_poklhd_pay_reCompute(nprocSlev)
  local  n_roundDph  := SysConfig('Finance:nRoundDph'), n_zaklDan, n_procDan, n_sazDan

  poklitW->nprocSlev := nprocSlev
  poklitW->nhodnSlev := ((poklitW->ncejPrZDZ * poklitW->nprocSlev) /100)

  poklitW->ncejPrKDZ := ( poklitW->ncejPrZdz - poklitW->nhodnSlev  )
  poklitW->ncelkSlev := ( poklitW->nhodnSlev * poklitW->nfaktMnKoe )
  poklitW->ncecPrKdz := ( poklitW->ncejPrKdz * poklitW->nfaktMnKoe )

  n_zaklDan := poklitW->ncejPrKDZ * poklitW->nfaktMnKoe
  n_procDan := poklitW->nprocDph

  if n_roundDph = 0
    n_sazDan := round(round(n_zaklDan * round((n_procDan/(100 +n_procDan)),4),2), 2)
  else
    n_sazDan := mh_roundnumb(round(n_zaklDan * round((n_procDan/(100 +n_procDan)),4),2), n_roundDph)
  endif

  poklitW->njedDan   := (n_sazDan  / poklitW->nfaktMnKoe)
  poklitW->ncejPrKDZ := (n_zaklDan / poklitW->nfaktMnKoe)
  poklitW->ncejPrKBZ := (n_zaklDan / poklitW->nfaktMnKoe -n_sazDan / poklitW->nfaktMnKoe)

  poklitW->ncecPrZBZ := (poklitW->ncejPrKBZ * poklitW->nfaktMnKoe)
  poklitW->ncelkSlev := (poklitW->nhodnSlev * poklitW->nfaktMnKoe)
  poklitW->ncecPrKBZ := (poklitW->ncejPrKBZ * poklitW->nfaktMnKoe)
  poklitW->ncecPrKDZ := (poklitW->ncejPrKDZ * poklitW->nfaktmnKoe)

return .t.