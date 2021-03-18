#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"
//
#include "..\FINANCE\FIN_finance.ch"


#define m_files  { 'typdokl' , 'c_typpoh'                     , ;
                   'c_dph'   , 'c_meny'  , 'c_staty','kurzit' , ;
                   'pokladks', 'pokza_za', 'pokladms'         , ;
                   'osoby'                                    , ;
                   'ucetpol' , 'fakprihd', 'fakvyshd'         , ;
                   'firmy'   , 'forms'                          }


**
** CLASS for FIN_pokladhd_IN **************************************************
CLASS FIN_pokladhd_IN FROM drgUsrClass, FIN_finance_IN, SYS_ARES_forAll


exported:
  *
  VAR     lNEWrec, uctLikv, rozdilDokl, hd_file, it_file
  var     ain_file, cmb_typDokl, typ_dokl
  method  init, drgDialogStart, drgDialogEnd, postValidate, showGroup, postSave
  method  comboItemSelected
   *
  var     lok_append2

  * info
  var     nazTypPoh, celDoklad

  * sel
  method  fin_banvyphd_in_pok
  method  fin_pokladms_sel, fin_pokladhd_osb_sel, fin_firmy_sel, fin_banvyphd_kr

  *
  inline access assign method zkratMenZ() var zkratMenZ
    return pokladhdw->czkratMenZ

  inline access assign method lno_inDPH(lno_inDPH) var lno_inDPH
    local cc

    default lno_inDPH to pokladhdW->lno_inDPH

    cc := 'doklad ' +if(lno_inDPH, 'NE-', '') +'vstupuje do uzávìrky DPH'

    if isObject(::dm)
      otxt_inDPH := ::dm:has('M->lno_inDPH'):odrg
      otxt_inDPH:oxbp:setFontCompoundName('12.Arial CE')
      otxt_inDPH:oXbp:setColorFG(if( lno_inDPH, GRA_CLR_RED, GRA_CLR_DARKGREEN ))
    endif
    return cc

  inline access assign method aktStav var aktStav
    local n_aktStav
    local isPri := (pokladhdw->ntypdok = 1)
    local celhd := if(::istuz(), (pokladhdw->ncencel_hd +pokladhdw->ncencel_it), ;
                                 (pokladhdw->ncenzah_hd +pokladhdw->ncenzah_it)  )

    n_aktStav := (pokladhdw->npocstav +if(ispri, celhd, -celhd))
    pokladhdW->naktStav := n_aktStav
   return n_aktStav

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    * pøeskok
    if nEvent = xbeP_Keyboard .and. oxbp:ClassName() = 'XbpGet'
      if 'ctextdok' $ lower(oxbp:cargo:name)
        if mp1 == xbeK_RETURN
          ::df:setNextFocus('pokladhdw->ncencel_hd',,.t.)
        endif
      endif
    endif

   do case
    case nEvent = drgEVENT_SAVE
      if( FIN_postSave():new('pokladhd',self):ok, ::postSave(), nil)
      return .t.

    otherwise
       return ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .f.


  inline access assign method istuz() var istuz
  return Equal(::zaklMena, (::hd_file)->czkratmenz) .or. empty((::hd_file)->czkratmenz)

hidden:
  VAR     panGroup, members, roundDph, zaklMena, fin_pokladks, cenZak, cenZah
  var     is_ext_pok
  method  osb_sel, zuc_zal, vldb, vldz

  inline method cmpCenzax()
    pokladhdw->ncenzakcel := pokladhdw->ncencel_hd +pokladhdw->ncencel_it
    pokladhdw->ncenzahcel := pokladhdw->ncenzah_hd +pokladhdw->ncenzah_it
    *
    ::cenZak:set(pokladhdw->ncenzakcel)
    ::cenZah:set(pokladhdw->ncenzahcel)
    *
    ::dm:set('m->rozdilDokl',::rozdilDokl)
  return


  inline method printParagon()
    local  cfrm := AllTrim( SYSCONFIG('FINANCE:CFRMPARAG'))
    local  cinfo    := 'Promiòte prosím,', nsel := 1
    local  paButton := { '   ~Ano    ', '    ~Ne   ', '    ~S kopí   '  }
    local  ncopies  := 0
    *
    ** vytiskneme
    if .not. empty(cfrm)
      cinfo += '; požadujete tisk úètenky [' +str(pokladhdW->ndoklad) +' ] ... ?'
      nsel  := alertBox( ::drgDialog:dialog, cInfo               , ;
                         paButton, XBPSTATIC_SYSICON_ICONQUESTION, ;
                         'Zvolte možnost ...'                      )

      _clearEventLoop(.t.)

      *
      ** ve workVersion nebudu pøece tisknout
      if .not. isWorkVersion
        if nsel <> 2
*          ncopies := if( nsel = 3, val(::on_prnDoklad), 0 )

          if( forms->(dbSeek( cfrm,,'FORMS01')), LL_PrintDesign( ,'PRN',,.T.,, ncopies ), nil)
          pokladhdw->( DbClearRelation())
          pokladitw->( DbClearRelation())
      endif
      *
      ** ve workVersion se podíváme na náhled
      else

        if nsel <> 2
          if( forms->(dbSeek( cfrm,,'FORMS01')), LL_PrintDesign( ,'PRV'), nil)
          pokladhdw->( DbClearRelation())
          pokladitw->( DbClearRelation())
        endif
      endif
    endif
  return self
ENDCLASS


method FIN_pokladhd_IN:init(parent)

  ::drgUsrClass:init(parent)
  *
  (::hd_file    := 'pokladhdw', ::it_file := 'pokladitw')
  ::lNEWrec     := .not. (parent:cargo = drgEVENT_EDIT)
  ::lok_append2 := .f.
  ::is_ext_pok  := .f.
  ::typ_dokl    := 'pok'

  * vstupní soubory pro kontrolu na csymol
  ::ain_file := {{'fakprihd', 0, 0, 1,  9, SysConfig('FINANCE:cDENIKFAPR')}, ;
                 {'fakvyshd', 0, 0, 2, 10, SysConfig('FINANCE:cDENIKFAVY')}  }

  *
  ** požadavek automatického vytvoøení pokladního dokladu s položkami vybraných faktur vystavených
  ** button FIN_fakvyshd_SCR
  cargo_usr    := if( ismemberVar( parent, 'cargo_usr'), isnull( parent:cargo_usr, ''), '' )
  ::is_ext_pok := ( lower(cargo_usr) = 'ext_pok')

  * základní soubory
  ::openfiles(m_files)
  if ::is_ext_pok
  else
    pokladms->( ads_setAof( "left(ctypPoklad,3) = 'FIN'" ), dbgoTop())
  endif

  ::roundDph  := SysConfig('Finance:nRoundDph')
  ::zaklMena  := SysConfig('Finance:cZaklMena')

  FIN_pokladhd_cpy(self)
return self


METHOD FIN_pokladhd_IN:drgDialogStart(drgDialog)
  LOCAL  omenz, otxt_inDPH, oget_pokladna
  local  ctypPohybu

  ::FIN_finance_in:init(self,'pok')   // ,'_úèetního dokladu_',.t.)

   * propojka pro ARES
  if( .not. ::is_ext_pok, ::sys_ARES_forAll:init(drgDialog), nil )

  omenz := ::dm:has('M->zkratmenz'):odrg
  omenz:oxbp:setFontCompoundName('20.Arial CE')
  omenz:oXbp:setColorFG(GRA_CLR_BLUE)
  omenz:oxbp:disable()

  otxt_inDPH := ::dm:has('M->lno_inDPH'):odrg
  otxt_inDPH:oxbp:setFontCompoundName('12.Arial CE')
  otxt_inDPH:oXbp:setColorFG(GRA_CLR_BLUE)
*  omenz:oxbp:disable()

  omenz := ::dm:has(::hd_file +'->czkratmenz'):odrg
  (omenz:isEdit := .f., omenz:oxbp:disable())

  oget_pokladna := ::dm:has(::hd_file +'->npokladna'):odrg
  ::cmb_typDokl := ::dm:has(::hd_file +'->ctyppohybu'):odrg

  ::rozdilDokl  := (::hd_file)->nzustpozao
  ::panGroup    := '1'
  ::members     := drgDialog:oForm:aMembers
  *
  ::cenZak      := ::dm:has(::hd_file +'->ncenzakcel')
  ::cenZah      := ::dm:has(::hd_file +'->ncenzahcel')

  *
  ** externí vystavení POKLADHD
  if ::is_ext_pok

    ::copyfldto_w('pokladms','pokladhdw')

    pokladhdw->czkratmeny := SysConfig('Finance:cZaklMena')
    pokladhdw->czkratmenZ := pokladms->czkratMeny

    ( oget_pokladna:isEdit := .f., oget_pokladna:oxbp:disable() )

    ctypPohybu := if( empty(pokladms->ctypPohybu), 'POKLPRIJ', pokladms->ctypPohybu )

    (::hd_file)->ctypPohybu := ctypPohybu
     ::dm:set( ::hd_file +'->ctypPohybu', ctypPohybu )
    ( ::cmb_typDokl:isEdit := .f., ::cmb_typDokl:oxbp:disable() )

    ::fin_pokladks := fin_pokladks():new()
    ::fin_pokladks:ps()

    ::refresh( ::dm:get('pokladhdw->npokladna', .F.) )
    ::lnewRec := .f.
  endif


  ::showGroup(::istuz())
  ::dm:refresh()
  *
  ::df:setNextFocus('pokladhdw->' +if(::lnewRec,'npokladna','cucet_uct'),,.t.)
  ::comboItemSelected()

  if ::lnewRec
    if .not. ::lok_append2
      PostAppEvent(xbeP_Keyboard,xbeK_F4,,::dm:has('pokladhdw->npokladna'):odrg:oxbp)
    else
      ::df:setNextFocus('pokladhdw->cucet_uct',,.t.)
      ( ::cmb_typDokl:isEdit := .f., ::cmb_typDokl:oxbp:disable() )
      ( oget_pokladna:isEdit := .f., oget_pokladna:oxbp:disable() )
    endif
  endif

return if( ::is_ext_pok, .f., self )


method FIN_pokladhd_IN:drgDialogEnd(drgDialog)
  (::it_file)->(DbCloseArea())
  (::hd_file)->(DbCloseArea())

  pokladms->( ads_clearAof())
return


method FIN_pokladhd_IN:postValidate(drgVar)
  local  value := drgVar:get(), m_file
  local  name  := lower(drgVar:name), file, field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .T., changed := drgVAR:changed(), subtxt
  local  subValid := if(::istuz(), 'vldb', 'vldz')
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  *
  local  vystDok  := ::dm:has(::hd_file +'->dvystdok')
  local  osvOdDan := ::dm:has(::hd_file +'->nosvodDan')
  local  n_typvykDph := sysconfig('FINANCE:nTypVykDPH')
  local  cQ_beg, cQ_end, nQ_beg, nQ_end

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  * hlavièka dokladu
  do case
  case(name = ::hd_file +'->dporizdok')
    if empty(value)
      ::msg:writeMessage('Datum poøízení dokladu je povinný údaj ...',DRG_MSG_ERROR)
      ok := .f.
    elseif strZero((::hd_file)->nobdobi,2) +'/' +str((::hd_file)->nrok, 4) <> strZero(month(value),2) +'/' +str(Year(value),4)
      fin_info_box('Datum poøízení dokladu nesouhlasí s obdobím dokladu...')
*-      ::msg:writeMessage('Datum poøízení dokladu nesouhlasí s obdobím dokladu...',DRG_MSG_WARNING)
    endif
    *
    if(ok .and. changed)
      (::hd_file)->dvystdok := value
      vystDok:set(value)
    endif

  case(name = ::hd_file +'->npokladna' )
    ok := ::fin_pokladms_sel()

  case(name = ::hd_file +'->ncisosoby')
    if changed
      ok := ::fin_pokladhd_osb_sel()
      if(ok, value := drgVar:value, nil)
    endif

  case(name = ::hd_file +'->ndoklad'   )
     m_file := upper(left(::hd_file, len(::hd_file)-1))
     ok     := fin_range_key(m_file,value,,::msg)[1]

     if ok .and. pokladhdw->ntypdok = 1  // Pokladní doklad príjmový
       if changed .or. empty(pokladhdW->cdanDoklad)
         pokladhdW->cdanDoklad := alltrim(str(value))
       endif
     endif

  case( name = ::hd_file +'->ncisfirmy' )
     ok     := if( changed, ::fin_firmy_sel(), .t.)

  case(name = ::hd_file +'->dvystdok' )
    if  Empty(value)
      ( ok := .F., drgMsgBOX( 'Datum (uzp) je povinný údaj ...' ))
    else
      * zmìna rv_dph
      if .not. vykdph_iw->(dbseek( FIN_c_vykdph_ndat_od(value),, 'VYKDPH_6' ))
//      if  year(drgVar:prevValue) <> year(value)
         eval(drgVar:block,drgVar:value)
         fin_vykdph_cpy(::hd_file)
      endif

      cC := StrZero( Month(value), 2) +'/' +Right( Str( Year(value), 4), 2)

      * 1 - mìsíèní plátce DPH
      do case
      case n_typvykDph = 1
        if (::hd_file)->cobdobiDan <> cC
          fin_info_box('Datum (uzp) neodpovídá daòovému období dokladu ...')
        endif

      * 3 - ètvrtletní plátce DPH
      case n_typvykDph= 3
        nQ_end := val( left( (::hd_file)->cobdobiDan, 2)) *n_typvykDph
        nQ_beg := nQ_end -2

        cQ_beg := strZero(nQ_beg,2) +'/' +right((::hd_file)->cobdobiDan, 2)
        cQ_end := strZero(nQ_end,2) +'/' +right((::hd_file)->cobdobiDan, 2)

        if .not. (cQ_beg <= cc .and. cQ_end >= cc)
          fin_info_box('Datum (uzp) neodpovídá daòovému období dokladu ...')
        endif
      endcase
   endif

  case('ncencel_hd' $ name) .and. changed
    pokladhdw->nosvoddan += (value -pokladhdw->ncencel_hd)
    ::refresh(drgVar,.f.)
    *
    osvOdDan:initValue := pokladhdw->nosvoddan
    ::dm:set('pokladhdw->nosvoddan',pokladhdw->nosvoddan)

    ::fin_finance_in:FIN_vykdph_mod('pokladhdw')
  endcase

  if(ok,eval(drgVar:block,value),nil)
*-  if(ok .and. changed .and. IsMethod(self, subValid, CLASS_HIDDEN), self:&subValid(drgVar), NIL)
  if(ok .and. IsMethod(self, subValid, CLASS_HIDDEN), self:&subValid(drgVar), NIL)

  * modifikace vykdph_iw
  if( field_name $ 'nosvoddan,nzakldan_1,nsazdan_1,nzakldan_2,nsazdan_2,nzakldan_3,nsazdan_3') .and. changed
    ::fin_finance_in:FIN_vykdph_mod('pokladhdw')
  endif

  ::comboItemSelected()
return ok


method FIN_pokladhd_in:comboItemSelected(mp1,mp2,o)
  local  value   := ::cmb_typDokl:Value, values := ::cmb_typDokl:values
  local  ntypDok := pokladhdw->ntypdok
  local  nin

  if isobject(mp1) .and. right(mp1:name,7) = 'COBDOBI'
    ::cobdobi(mp1)
  endif

  nin := ascan(values,{|x| x[1] = value })
  ::nazTypPoh := values[nin,2]
  ::dm:has('m->nazTypPoh'):set(::nazTypPoh)

  ::celDoklad := if(::istuz(), ((::hd_file)->ncencel_hd +(::hd_file)->ncencel_it), ;
                               ((::hd_file)->ncenzah_hd +(::hd_file)->ncenzah_it)  )

  ::dm:has('m->celDoklad'):set(::celDoklad)
  ::dm:has('m->aktStav'):set(::aktStav)

  * pozor INS, pøi výbìru pokladms
  pokladhdw->ntypdok    := val(values[nin,4])
  pokladhdw->npokladEET := values[nin,9]
  if( ::lNEWrec .and. pokladhdw->ntypdok <> ntypDok, fin_vykdph_cpy('POKLADHDw'), nil )

  *
  if (values[nin,3] <> pokladhdw->ctypdoklad .or. values[nin,1] <> pokladhdw->ctyppohybu)
    pokladhdw->ctypdoklad := values[nin,3]
    pokladhdw->ctyppohybu := values[nin,1]
    pokladhdw->ntypdok    := val(values[nin,4])
    pokladhdw->npokladEET := values[nin,9]

    if pokladhdw->ntypdok = 1  // Pokladní doklad príjmový
      if empty(pokladhdW->cdanDoklad)
        pokladhdW->cdanDoklad := alltrim(str( pokladhdW->ndoklad))
      endif
    endif

    ::dm:has(::hd_file +'->cdanDoklad'):set(pokladhdW->cdanDoklad)

    fin_vykdph_cpy('POKLADHDw')
    if(empty(pokladhdw->ncisOsoby), nil,::osb_sel())
  endif
return self


*  1. - výbìr pokladny je striktní
** SELL METHOD *****************************************************************
METHOD FIN_pokladhd_IN:fin_pokladms_sel(drgDialog)
  LOCAL oDialog, nExit
  local ctyppohPOK := sysconfig('finance:ctyppohPOK')
**  local npokladEET := pokladhdw->npokladEet
  *
  local drgVar := ::dataManager:get('pokladhdw->npokladna', .F.)
  local value  := drgVar:get()
  local ok     := (.not. Empty(value) .and. pokladms ->(dbseek(value,,'POKLADM1')))

  *
  ** fin_pokladhd_scr.prg
  if IsObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'FIN_POKLADMS_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                      EXITSTATE nExit CARGO drgVar:odrg

    if nexit = drgEVENT_SELECT
     ::copyfldto_w('pokladms','pokladhdw')

     pokladhdw->czkratmeny := SysConfig('Finance:cZaklMena')
     pokladhdw->czkratmenZ := pokladms->czkratMeny
**     pokladhdw->npokladEet := npokladEET

     ::fin_pokladks := fin_pokladks():new()
     ::fin_pokladks:ps()

     ::refresh(drgVar,.t.)
    endif
  endif
RETURN (nexit = drgEVENT_SELECT .or. ok)


method FIN_pokladhd_IN:fin_pokladhd_osb_sel(drgDialog)
  local  oDialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::dm:has('pokladhdw->ncisOsoby')
  local  value  := drgVar:get()
  local  ok     := .t., copy := .f.

  if .not. empty(value)  ;  ok := osoby->(dbseek(value,,'Osoby01'))
                            if( ok, ok := osoby->lpri_zal, nil)
  else                   ;        osoby->(dbseek(   -1,,'Osoby01'))
  endif

  if isObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'FIN_pokladhd_osb_sel' PARENT ::drgDialog MODAL DESTROY ;
                                          EXITSTATE nExit
  endif

  if (ok .and. drgVar:itemChanged())
    copy := .T.
  elseif nexit = drgEVENT_SELECT
    copy := .T.
  endif

  if copy
    pokladhdw->ncisOsoby  := osoby->ncisOsoby
    pokladhdw->nosCisPrac := osoby->nosCisPrac
    pokladhdw->cjmenoPrij := osoby->cOsoba
    ::osb_sel()

    ::refresh(drgVar,.t.)
    drgVar:initValue := drgVar:value
  endif
return (nexit = drgEVENT_SELECT) .or. ok


method FIN_pokladhd_in:osb_sel()
  local  typDok := pokladhdw->ntypDok, cisOsoby := pokladhdw->ncisOsoby
  *
  local  drgVar
  local  x, pa  := {'ncisfirmy','nico','cdic','cnazev','cnazev2','culice','cpsc','csidlo','czkratstat'}

  pokladhdw->ctextDok := allTrim(osoby->cOsoba) +          ;
                         if(typDok = 1, '_ vrátil(a) zálohu', ;
                         if(typDok = 2, '_ pøijal(a) zálohu', '_ zùètoval(a) zálohu'))

  * pøíjem a výdej na pracovníka NESMÍ být na FIRMU
  *                              NEMÁ         POKLADIT
  if typDok <> 3
    firmy->(dbSeek(-1,,'FIRMY1'))
    mh_copyFld('firmy', 'pokladhdw',,.f.)
  endif

  for x := 1 to len(pa) step 1
    drgVar := ::dm:has(::hd_file +'->' +pa[x])
    if empty(cisOsoby)  ; (drgVar:odrg:isEdit := .t., drgVar:odrg:oxbp:enable() )
    else                ; (drgVar:odrg:isEdit := .f., drgVar:odrg:oxbp:disable())
    endif
  next
return


method FIN_pokladhd_in:fin_firmy_sel( drgDialog )
  LOCAL oDialog, nExit
  *
  local drgVar := ::dm:has('pokladhdw->ncisfirmy'), ok
  local value  := drgVar:value

  ok := (empty(value) .or. firmy->(dbseek(value,,'FIRMY1')))

  if IsObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  IF nExit != drgEVENT_QUIT .or. ok
    mh_COPYFLD('FIRMY', 'pokladhdw',,.F.)

    ::fin_finance_in:refresh(drgVar)
    ::drgDialog:dataManager:refresh()
    ::df:setNextFocus(::hd_file + '->' +if(::istuz(), 'ncencel_hd', 'ncenzah_hd'),,.t.)

  ENDIF
return (nExit != drgEVENT_QUIT)


* položky pokladního dokladu *
METHOD FIN_pokladhd_IN:FIN_banvyphd_in_pok()
  local oDialog, nExit, drgVar := ::dataManager:get('pokladhdw->npokladna', .F.)
  *
  local prijem,vydej,prijemZ,vydejZ,cenZakCel,likPolPok,cenZahCel, isPri := (pokladhdw->ntypdok = 1)


  DRGDIALOG FORM 'FIN_banvyphd_in_pok' PARENT ::drgDialog MODAL EXITSTATE nExit

  * pøepoèet hlavèky
  prijem := vydej := prijemZ := vydejZ := cenZakCel := likPolPok := cenZahCel := 0
  (::it_file)->(dbgotop(), ;
                dbeval( {|| (prijem    += (::it_file)->nprijem   , ;
                             vydej     += (::it_file)->nvydej    , ;
                             prijemZ   += (::it_file)->nprijemZ  , ;
                             vydejZ    += (::it_file)->nvydejZ   , ;
                             cenZakCel += (::it_file)->ncenzakcel, ;
                             cenZahCel += (::it_file)->ncenzahcel, ;
                             likPolPok += (::it_file)->nlikpolpok  ) }))

  (::hd_file)->nprijem    := prijem  +if(       isPri, (::hd_file)->ncencel_hd, 0)
  (::hd_file)->nvydej     := vydej   +if( .not. isPri, (::hd_file)->ncencel_hd, 0)
  (::hd_file)->nprijemZ   := prijemZ +if(       isPri, (::hd_file)->ncenzah_hd, 0)
  (::hd_file)->nvydejZ    := vydejZ  +If( .not. isPri, (::hd_file)->ncenzah_hd, 0)
  (::hd_file)->ncenzakcel := cenZakCel
  (::hd_file)->ncenzahcel := cenZahCel
  (::hd_file)->ncencel_it := cenZakCel
  (::hd_file)->ncenzah_it := cenZahCel

  if nExit != drgEVENT_QUIT
  endif

  oDialog:destroy(.T.)
  oDialog := NIL

  ::postValidate(drgvar)   // NEWs SJ
  ::refresh(drgVar)
return(nExit != drgEVENT_QUIT)



METHOD FIN_pokladhd_IN:FIN_banvyphd_KR()
  LOCAL oDialog, nExit

  DRGDIALOG FORM 'FIN_BANVYPHD_KR' PARENT ::drgDialog MODAL DESTROY ;
                                   EXITSTATE nExit

  IF nExit != drgEVENT_QUIT
*    BANVYPHDw ->cBANK_UCT := C_BANKUC ->cBANK_UCT
*    ::drgDialog:dataManager:refresh()
  ENDIF
RETURN (nExit != drgEVENT_QUIT)


method FIN_pokladhd_IN:showGroup(istuz_uc)
  local  x, noedit := GraMakeRGBColor({221, 221, 221})
  local  zkrMeny, dporiz, cky

  *
  ::panGroup := if(istuz_uc,'1','2')
  *
  FOR x := 1 TO LEN(::members) step 1
    If IsMemberVar(::members[x],'groups') .and. .not. Empty(::members[x]:groups)
      IF .not. (::panGroup $ ::members[x]:groups)
        ::members[x]:oXbp:hide()
        *
        * u GETU je PUSH musíme ho zakázat
        if ::members[x]:ClassName() $ 'drgGet' .and. isObject( ::members[x]:pushGet)
          ::members[x]:pushGet:oxbp:hide()
        endif

        IF( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members[x]:isEdit := .F.)
      ELSE
        if at(':', ::members[x]:groups) <> 0
          ::members[x]:oXbp:disable()
        endif
        ::members[x]:oXbp:show()
        *
        * u GETU je PUSH musíme ho povolit
        if ::members[x]:ClassName() $ 'drgGet' .and. isObject( ::members[x]:pushGet)
          ::members[x]:pushGet:oxbp:show()
        endif

        IF( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ;
           ::members[x]:isEdit := ::members[x]:oXbp:isenabled() )
      ENDIF
    ENDIF
  NEXT

  ::dm:set('M->zkratmenz',c_meny->czkratMeny)

  if istuz_uc .and. ::new_dok
    ::dm:set('M->lno_inDph', ::lno_inDPH(pokladms->lno_inDPH) )
  endif

  if .not. istuz_uc .and. ::new_dok

    odrg := ::dm:has('pokladhdW->czkratMenz')
    odrg:set(c_meny->czkratMeny)
    ::fin_kurzit( odrg, pokladhdw->dporizdok)

/*
    zkrMeny := upper(c_meny->czkratMeny)
    dporiz  := pokladhdw->dporizdok

    kurzit->(AdsSetOrder(2), dbsetscope(SCOPE_BOTH,zkrMeny))
    cky := zkrMeny +dtos(dporiz)

    kurzit->(dbseek(cky,.t.))
    if( kurzit->nkurzstred = 0, kurzit->(dbgobottom()),nil)
    pokladhdw->nkurzahmen := kurzit->nkurzstred
    pokladhdw->nmnozprep  := kurzit->nmnozprep

    ::dm:set('pokladhdw->czkratmenz', c_meny->czkratMeny)
    ::dm:set('pokladhdw->nkurzahmen', kurzit->nkurzstred)
    ::dm:set('pokladhdw->nmnozprep' , kurzit->nmnozprep )
*/
  endif
RETURN self


method FIN_pokladhd_in:postSave()
  local  ok, value, npokl := pokladhdw->npokladna
  *
  local  typDok     := pokladhdw->ntypDok, cisOsoby := pokladhdw->ncisOsoby
  * pokud jede v kruhu
  local  porizDok   := pokladhdw->dporizDok
  local  typPohybu  := pokladhdw->ctypPohybu
  local  vystDok    := pokladhdw->dvystDok
  local  zkratMenZ  := pokladhdw->czkratMenZ
  local  kurZahMen  := pokladhdw->nkurZahMen
  local  mnozPrep   := pokladhdw->nmnozprep
  * Eet
  local  is_Eet     := .f.

  * zùètování zálohy na pracovníka, požadavek naplnit cvarSym -> cisOsoby
  if typDok = 3 .and. cisOsoby <> 0
    pokladhdw->cvarSym := str(cisOsoby)
  endif

  * zatím, pak uvidíme
  if ( ::lnewRec .and. pokladhdW->ntypDok = 1 .and. pokladhdW->npokladEET = 1 )
    if .not. empty(pokladms->cidDATkomE) .and. .not. empty(pokladms->mdefin_Kom)
      is_Eet := .t.
      Asys_komunik_int( pokladms->cidDATkomE, ::drgDialog, .t. )
    endif
  endif

  ok := fin_pokladhd_wrt_inTrans(self)

  if ( ::lnewRec .and. pokladhdW->ntypDok = 1 .and. pokladhdW->npokladEET = 1 )
    if( ok, ::printParagon(), nil )
  endif

  if ok .and. ::set_likvidace_inOn = 1
    ::FIN_likvidace_in(::drgDialog)
    ::set_likvidace_inOn = 0
    _clearEventLoop(.t.)
  endif


  if(ok .and. ::new_Dok .and. ::lok_append2, ::new_Dok := .f., nil )

  if(ok .and. ::new_dok)
    pokladhdw->(dbclosearea())
    pokladitw->(dbclosearea())
    if(select('banpok_w') = 0,nil,banpok_w->(dbclosearea()))

    if typDok = 3 .and. cisOsoby <> 0 .and. (pokza_za->nprij_zal -pokza_za->nzuct_zal) <> 0
      ::zuc_zal()
      typPohybu  := pokladhdw->ctypPohybu
    else
      fin_pokladhd_cpy(self)
    endif

    pokladms->(dbseek(npokl,,'POKLADM1'))
    ::copyfldto_w('pokladms','pokladhdw')
    ::fin_pokladks := fin_pokladks():new()
    ::fin_pokladks:ps()

    c_meny->(dbSeek(upper(zkratMenZ),,'C_MENY1'))
    pokladhdw->dporizDok  := porizDok
    pokladhdw->ctypPohybu := typPohybu
    pokladhdw->dvystDok   := vystDok
    pokladhdw->czkratMeny := SysConfig( 'Finance:cZaklMena')
    pokladhdw->czkratMenZ := zkratMenZ
    pokladhdw->nkurZahMen := kurZahMen
    pokladhdw->nmnozPrep  := mnozPrep

    ::fin_finance_in:refresh('pokladhdw',,::dm:vars)
    ::showGroup(::istuz())
    ::dm:refresh( , .t.)
    *
    ::df:setNextFocus('pokladhdw->ctyppohybu',,.t.)
    ::comboItemSelected()
  elseif(ok .and. .not. ::new_dok)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return ok


method FIN_pokladhd_in:zuc_zal()
  local  zusZal := pokza_za->nzuct_zal -pokza_za->nvrac_zal

  ** tmp **
  drgDBMS:open('POKLADHDw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
  drgDBMS:open('POKLADITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
//  drgDBMS:open('FAKPRIHD')
//  drgDBMS:open('FAKVYSHD')

  pokladhdw->ctyppohybu := 'POKLPRIJ'
  pokladhdw->ndoklad    := FIN_range_KEY('POKLADHD')[2]
  pokladhdw->nprijem    := 0
  pokladhdw->nvydej     := 0
  pokladhdw->nprijemZ   := 0
  pokladhdw->nvydejZ    := 0
  pokladhdw->nzaklDan_1 := 0
  pokladhdw->nsazDan_1  := 0
  pokladhdw->nzaklDan_2 := 0
  pokladhdw->nsazDan_2  := 0
  pokladhdw->nzustPoZao := 0
  pokladhdw->ncenCel_IT := 0
  pokladhdw->ctextDok   := pokladhdw->cjmenoPrij +'_ vrátil(a) zálohu'
  pokladhdw->ncenZakCel := zusZal
  pokladhdw->ncenCel_HD := zusZal
  pokladhdw->nosvOdDan  := zusZal
  pokladhdw->ncenZahCel := zusZal
  pokladhdw->ncenZah_HD := zusZal
  pokladhdw->ncenCel_IT := 0
  pokladhdw->ncenZah_IT := 0

  pokladhdw->( dbcommit())
return self


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method FIN_pokladhd_IN:vldb(drgVar)
  local  name  := Lower(drgVar:name), changed := drgVar:itemChanged()
  local  value := drgVar:value, initValue := drgVar:initValue
  *
  local  nsazdan, nsumdan := 0
  local  lcmp := (pokladhdw->ncencel_hd <> 0), lcondprep := .f.
  local  an   := {pokladhdw->nosvoddan, pokladhdw->nzakldan_1, pokladhdw->nsazdan_1, ;
                                        pokladhdw->nzakldan_2, pokladhdw->nsazdan_2, ;
                                        pokladhdw->nzakldan_3, pokladhdw->nsazdan_3  }

  do case
  case(name = 'pokladhdw->nosvoddan' )  ;  lcondprep := changed
  case(name = 'pokladhdw->nzakldan_1' .and. changed)
    pokladhdw->nsazdan_1 := mh_RoundNumb( (value/100) * pokladhdw->nprocdan_1, ::roundDph )
    lcondprep := changed
  case(name = 'pokladhdw->nzakldan_2' .and. changed)
    pokladhdw->nsazdan_2 := mh_RoundNumb( (value/100) * pokladhdw->nprocdan_2, ::roundDph )
    lcondprep := changed
  case(name = 'pokladhdw->nzakldan_3' .and. changed)
    pokladhdw->nsazdan_3 := mh_RoundNumb( (value/100) * pokladhdw->nprocdan_3, ::roundDph )
    lcondprep := changed
  endcase

  aeval(an, {|x| (nsumdan += x, lcmp := (x<>0))})
  *
  * lpreDANpov, nzakld_Dph, nsazba_Dph
  *
  nsumDan := 0
  vykDph_iW->( dbgoTop())
  do while .not. vykDph_iW->( eof())
    nsumDan += vykDph_iW->nzakld_Dph
    nsumDan += if( vykDph_iw->lpreDANpov, 0, vykDph_iW->nsazba_Dph )

    vykDph_iW->( dbskip())
  enddo

  ::rozdilDokl := (pokladhdw->ncencel_hd-nsumdan)
  pokladhdw->nzustpozao := ::rozdilDokl
  ::cmpCenzax()
  ::refresh(drgVar,.f.)
return .t.


method FIN_pokladhd_IN:vldz(drgVar)
  local  name  := Lower(drgVar:name), changed := drgVar:changed()
  local  value := drgVar:value, initValue := drgVar:initValue
  *
  ::cmpCenzax()

  pokladhdw->ncencel_hd := pokladhdw->ncenzahcel *(pokladhdw->nkurzahmen/pokladhdw->nmnozprep)
  pokladhdw->nosvoddan  := pokladhdw->ncenzah_hd *(pokladhdw->nkurzahmen/pokladhdw->nmnozprep)

  ::refresh(drgVar,.f.)
return .t.