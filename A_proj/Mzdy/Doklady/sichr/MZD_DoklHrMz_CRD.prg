#include "Common.ch"
#include "Class.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dbstruct.ch"
#include "dmlb.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "class.ch"

#include "..\Asystem++\Asystem++.ch"


// pøi otevnøení souborù ? se musí nastavit filtr nrok + nobdobi
// základní klíè na msprc_mo
// STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)


*
** CLASS for MZD_doklhrmz_CRD **************************************************
CLASS MZD_doklhrmz_CRD FROM drgUsrClass, MZD_doklhrmz_in, MZD_doklhrmz_aut, MZD_doklhrmz_NEMOC
EXPORTED:
  var     lnewRec

  VAR     nState
  VAR     nSaveDokl

  METHOD  Init
  METHOD  ItemSelected
  METHOD  InFocus
  METHOD  preValidate, postValidate
  METHOD  drgDialogStart, drgDialogEnd, destroy
  METHOD  onSave
  METHOD  NewDoklad

  method  MZD_kmenove_SEL, MZD_trvZavhd_sel

  method  comboBoxInit, comboItemSelected
  method  ebro_afterAppendBlankRec, ebro_beforSaveEditRow, ebro_saveEditRow
  method  postSave

  * pro rozhraní _aut
  method  copyfldto_w, refresh

  * info only for me
  inline access assign method zaklSocPo_sum()
    return ::pa_info[1,6] +mzdDavHDw->nzaklSocPo +mzdDavHDwa->nzaklSocPo
  inline access assign method zaklZdrPo_sum()
    return ::pa_info[1,7] +mzdDavHDw->nzaklZdrPo +mzdDavHDwa->nzaklZdrPo

  * tarifní sazba z msTarind, funkce fsazTar vrací pole { nTarSazHod, nTarSazMes }
  inline access assign method tarSazba_hm()
    local  pa := fSazTAR( mzdDavHDw->dDatPoriz )

    (::hd_file)->ctypTarMzd := msTarindT->ctypTarMzd
    (::hd_file)->ntarSaz    := (pa[1] +pa[2])
    return ( pa[1] +pa[2])

  * hodinový a denní prùmìr z msPrum
  inline access assign method hodPrumPP()
    local cmain_Ky := DBGetVal(::cmain_Ky)

    msvPrum->( dbseek( cmain_Ky,, 'PRUMV_03'))
    return msvPrum->nhodPrumPP

  inline access assign method denPrumPP()
    local cmain_Ky := DBGetVal(::cmain_Ky)

    msvPrum->( dbseek( cmain_Ky,, 'PRUMV_03'))
    return msvPrum->ndenPrumPP

  inline access assign method is_nemoc()
    return ( (::hd_file)->cdenik = 'MN' )

  * info hrubá mzda
  inline access assign method dnyFondKD_H()
    return ::pa_info[1,2] +if( ::is_nemoc, 0, mzdDavHDw->nDnyFondKD) +mzdDavHDwa->nDnyFondKD
  inline access assign method dnyFondPD_H()
    return ::pa_info[1,3] +if( ::is_nemoc, 0, mzdDavHDw->nDnyFondPD) +mzdDavHDwa->nDnyFondPD
  inline access assign method hodFondPD_H()
    return ::pa_info[1,4] +if( ::is_nemoc, 0, mzdDavHDw->nHodFondPD) +mzdDavHDwa->nHodFondPD
  inline access assign method mzda_H()
    return ::pa_info[1,5] +if( ::is_nemoc, 0, mzdDavHDw->nMzda     ) +mzdDavHDwa->nMzda
  inline access assign method prumer_H()
    return ::mzda_H() / ::hodFondPD_H()

  * info nemocenská
  inline access assign method dnyFondKD_N()
    return ::pa_info[3,2] +if( ::is_nemoc, mzdDavHDw->nDnyFondKD, 0)
  inline access assign method dnyFondPD_N()
    return ::pa_info[3,3] +if( ::is_nemoc, mzdDavHDw->nDnyFondPD, 0)
  inline access assign method hodFondPD_N()
    return ::pa_info[3,4] +if( ::is_nemoc, mzdDavHDw->nHodFondPD, 0)
  inline access assign method mzda_N()
    return ::pa_info[3,5] +if( ::is_nemoc, mzdDavHDw->nMzda     , 0)

  * info srážka
  inline access assign method mzda_S()        ;  return ::pa_info[2,5]

  * info zaPracovníka
  inline access assign method dnyFondKD_sum() ;  return ::dnyFondKD_H() + ::dnyFondKD_N()
  inline access assign method dnyFondPD_sum() ;  return ::dnyFondPD_H() + ::dnyFondPD_N()
  inline access assign method hodFondPD_sum() ;  return ::hodFondPD_H() + ::hodFondPD_N()
  inline access assign method mzda_sum()      ;  return ::mzda_H()      + ::mzda_N() - ::mzda_S()


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local n_mp1 := if( isNumber(mp1), mp1, 0 )

    if n_mp1 = drgEVENT_EDIT .or. n_mp1 = drgEVENT_APPEND .or. n_mp1 = xbeK_ESC
      ::info_in_msgStatus()
      return .f.
    endif
    return ::handleEvent(nEvent, mp1, mp2, oXbp)

  inline method EdItemMarked()
    local  druhMzdy

    ::ncol_druhMzdy := ascan( ::brow:cargo:ardef, { |x| 'NDRUHMZDY' $ x[2] } )
           druhMzdy := val( isnull( ::brow:getColumn( ::ncol_druhMzdy ):getRow( ::brow:rowPos ), '0' ))
    ::info_in_msgStatus()
    return self

  inline method ebro_afterAppend(o_eBro)
    *
    ** pro nový záznam musíme zanulovat pomocné položky
    ::nold_druhmzdy := 0

    ::it_mzda:set(0)

    ::it_dnyFondKD:set(0)
    ::it_dnyFondPD:set(0)
    ::it_dnyDovol:set(0)

    ::it_hodFondKD:set(0)
    ::it_hodFondPD:set(0)
    ::it_hodPresc:set(0)
    ::it_hodPrescS:set(0)
    ::it_hodPripl:set(0)

    if ::prednNakR .and. (::hd_file)->cdenik = 'MH'
      c_naklst->( dbseek( msPrc_mo->ckmenStrPr +'1',,'C_NAKLST9'))

      ::dm:set('mzddavITw->cnazPol1', c_naklst->cnazPol1 )
      ::dm:set('mzddavITw->cnazPol2', c_naklst->cnazPol2 )
      ::dm:set('mzddavITw->cnazPol3', c_naklst->cnazPol3 )
      ::dm:set('mzddavITw->cnazPol4', c_naklst->cnazPol4 )
      ::dm:set('mzddavITw->cnazPol5', c_naklst->cnazPol5 )
      ::dm:set('mzddavITw->cnazPol6', c_naklst->cnazPol6 )
    endif
  return .t.

  inline method info_in_msgStatus()
    local cval, o_msg := ::msg:msgStatus, oPS
    local druhMzdy
    *
    local curSize  := o_msg:currentSize()
    local pa       := { GraMakeRGBColor({ 78,154,125}), ;
                        GraMakeRGBColor({157,206,188})  }

    ::ncol_druhMzdy := ascan( ::brow:cargo:ardef, { |x| 'NDRUHMZDY' $ x[2] } )
           druhMzdy := val( isnull( ::brow:getColumn( ::ncol_druhMzdy ):getRow( ::brow:rowPos ), '0' ))

    o_msg:setCaption( '' )
    oPS := o_msg:lockPS()
    GraGradient( ops               , ;
                 { 2,2 }           , ;
                 { curSize }, pa, GRA_GRADIENT_HORIZONTAL)

    *
    ** tohle je jistota
    druhyMzd->(dbseek( (::it_file)->ndruhMzdy,, 'DRUHYMZD01'))
    GraStringAt( oPS, {   4, 4}, druhymzd->cnazevDMz )

    if (::hd_file)->cdenik = 'MH'
      GraStringAt( oPS, { 350, 4}, 'Základ :')
      GraStringAt( oPS, { 450, 4}, str( ::dm:get(::it_file +'->nmzda')))

      if (::it_file)->npremie <> 0
        GraStringAt( oPS, { 550, 4}, 'Prémie :')
        GraStringAt( oPS, { 650, 4}, str( (::it_file)->npremMzd) )
      endif
    endif
    o_msg:unlockPS()

    ::nold_druhmzdy := druhMzdy
    return


HIDDEN:
  var     cmb_typPoh, cmb_keyMatr, get_doklad, get_datPoriz, get_datumOd, sta_keyMatr, members, aEdits

  var     cmain_Ky
  var     paGroups, panGroup, pa_info, pac_naklst, pao_nem_HD
  var     o_osCisPrac
  var     ncol_druhMzdy, nold_druhMzdy
  var     canSel_osCisPrac              // osobní èíslo pracovníka pro cykl poøízení
  var     hodnZdrSt                     // konfigurace -> Proc.z vymer.základu zdr.stát
  var     prednNakR                     // konfigurace -> po INS se pøednaplí NS
  var     vnitrUcMz                     // konfigurace -> Provádet vnitropodnik. zaúcto.
                                        // VLD        ..  if( cnazPol1 <> ckmenStrPr )-> nucetMzdy <> 0
  *
  method  showGroup /* ,copyfldto_w, refresh */

  inline method msprc_mo_seek()
    local cmain_Ky := DBGetVal(::cmain_Ky)

    msprc_mo->( dbseek( cmain_Ky,, 'MSPRMO01'))
  return nil

  inline method sum_mzddavhd()
    local  cdenik, npos, is_Ok
    local  pa  := ::pa_info
    *
    local  cmain_Ky := DBGetVal(::cmain_Ky)

    mzdDavHd_s->( ordSetFocus('MZDDAVHD01')      , ;
                  dbsetScope(SCOPE_BOTH,cmain_Ky), ;
                  dbgoTop()                        )

    do while .not. mzdDavHd_s->(eof())
      cdenik := mzdDavHd_s->cdenik

      if( npos:= ascan( pa, { |x| x[1] = cdenik })) <> 0

        is_Ok := .t.

        * musíme ze souètu vylouèit opravovaný doklad a automat - jen denik MH a nautoGen = 1
        do case
        case ::lnewRec
          if( mzdDavHD_s->cdenik = 'MH' .and. mzdDavHD_s->nautoGen = 1 )
            ( is_Ok := .f., ::doklhrmz_aut_cpy() )
          endif

        otherwise
          if( mzdDavHD_s->ndoklad = mzddavhdw->ndoklad )
            is_Ok := .f.
          else
            if( mzdDavHD_s->cdenik = 'MH' .and. mzdDavHD_s->nautoGen = 1 )
              ( is_Ok := .f., ::doklhrmz_aut_cpy() )
            endif
          endif
        endcase

        if is_Ok
          pa[npos,2] += mzdDavHD_s->nDnyFondKD
          pa[npos,3] += mzdDavHD_s->nDnyFondPD
          pa[npos,4] += mzdDavHD_s->nHodFondPD
          pa[npos,5] += mzdDavHD_s->nMzda
          pa[npos,6] += mzdDavHD_s->nzaklSocPo
          pa[npos,7] += mzdDavHD_s->nzaklZdrPo
        endif
      endif
      mzdDavHd_s->(dbskip())
    enddo
  return

ENDCLASS


METHOD MZD_doklhrmz_CRD:Init(parent)
  LOCAL  cKy, cDEFnaklst, pa, x
  local  cfiltr, nrok, nobdobi
  *
  nrok    := uctOBDOBI:MZD:NROK
  nobdobi := uctOBDOBI:MZD:NOBDOBI

  ::drgUsrClass:init(parent)

  (::hd_file  := 'mzddavhdw',::it_file  := 'mzddavitw')

  ::lnewRec  := .not. (parent:cargo = drgEVENT_EDIT)
  ::cmain_Ky := 'strZero(mzdDavHDw->nrok,4) +strZero(mzdDavHDw->nobdobi,2) + ' + ;
                'strZero(mzdDavHDw->nosCisPrac,5) +strZero(mzdDavHDw->nporPraVzt,3)'

  *                 cdenik, nDnyFondKD, nDnyFondPD , nHodFondPD, nMzda, nzaklSocPo, nzaklZdrPo
  *                 1       2           3            4           5      6           7
  ::pa_info  := { { ''    , 0         , 0          , 0         , 0    , 0         , 0         }, ;
                  { ''    , 0         , 0          , 0         , 0    , 0         , 0         }, ;
                  { ''    , 0         , 0          , 0         , 0    , 0         , 0         }  }
  *
  * úroveò nákladové struktury ... Asystem++.ch
  ::pac_naklst := paDEFc_naklst
  if isCharacter( cDEFnaklst := sysConfig('System:cDEFnaklst') )
    pa := listAsArray( cDEFnaklst )
    for x := 1 to len( pa ) step 1
      if( pa[x] = '0', ::pac_naklst[x,2] := .f., nil )
    next
  endif

  ::pa_info[1,1]     := sysConfig('MZDY:cdenikMZ_H')
  ::pa_info[2,1]     := sysConfig('MZDY:cdenikMZ_S')
  ::pa_info[3,1]     := sysConfig('MZDY:cdenikMZ_N')

  ::hodnZdrSt        := sysConfig('MZDY:nHodnZdrSt')
  ::prednNakR        := sysConfig('MZDY:lprednNakR')
  ::vnitrUcMz        := sysConfig('MZDY:lVnitrUcMz')

  ::canSel_osCisPrac := .t.

  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('DRUHYMZD',,,,,'druhyMzd_p' )     // pro automaticky generované prémie k základní mzdì

  cfiltr := Format("nROK = %% .and. nOBDOBI = %%", {nrok,nobdobi})
  druhyMzd  ->( ads_setaof(cfiltr), dbGoTop())
  druhyMzd_p->( ads_setaof(cfiltr), dbGoTop())

  drgDBMS:open('c_nemPas')

  drgDBMS:open('MZDDAVHD')
  drgDBMS:open('MZDDAVIT')
  *
  * pro automat
  drgDBMS:open( 'mzdDavit',,,,,'mzdDavIt_a')

  drgDBMS:open('MSPRC_MO')
  drgDBMS:open('MSPRC_MO',,,,,'MSPRC_mos')

  * prùmìry
  drgDBMS:open( 'msvPrum')

  * matrice msMzdyHd / msMzdyIt
  drgDBMS:open('msMzdyHd')
  drgDBMS:open('msMzdyIt')

  * pøednastavení nákladové struktury do položky dle konfigurace
  drgDBMS:open('c_naklst')

  * MS - srážky
  drgDBMS:open( 'trvZavHD' )

  * mlaskla na ENTER ale nemá data musím to pøehodit na INS
  if( ::lnewRec, nil, if( mzdDavhd->(eof()), ::lnewRec := .t., nil ))
  MZD_mzddavhd_cpy(self)

  * pro sumu za daný klíè
  drgDBMS:open('MZDDAVHD',,,,, 'mzddavHd_s')
  ::sum_mzddavhd()

  cfiltr := Format("nROK = %% .and. nOBDOBI = %% .and. lstavem", {nrok,nobdobi})
  msprc_mos->( ads_setaof(cfiltr), dbGoTop())

  ::msprc_mo_seek()
RETURN self


**
METHOD MZD_doklhrmz_CRD:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


**
METHOD MZD_doklhrmz_CRD:ItemSelected()
  x := "jdu sem"
RETURN self


**
method MZD_doklhrmz_crd:drgDialogStart(drgDialog)
  local  x, groups, className
  local  pa, pa_groups, pm, mo_prac_filtr
  local  pa_o
  local  ardef, colCount
  local  field_name, npos, ncnt_ardef
  local  typDokl := 'MZD_PRIJEM, MZD_SRAZKY, MZD_NEMOC'
  *
  local  acolors      := MIS_COLORS

  ::MZD_doklhrmz_in:init( self )
  ::MZD_doklhrmz_aut:init( self )

  ::msg:can_writeMessage := .f.
  ::msg:msgStatus:paint  := { |aRect| ::info_in_msgStatus(aRect) }

  ::o_osCisPrac := ::dm:has(::hd_file +'->nosCisPrac' )

  ::cmb_typPoh         := ::dm:has('mzdDavHDw->ctypPohybu'):odrg
  ::get_doklad         := ::dm:has('mzdDavHDw->ndoklad'):odrg
  ::get_datPoriz       := ::dm:has('mzdDavHDw->ddatPoriz'):odrg
  ::get_datumOd        := ::dm:has('mzdDavHDw->ddatumOd'):odrg
  ::cmb_keymatr        := ::dm:has('mzdDavHDw->nkeyMatr'  ):odrg

  pa  := ::paGroups    := {}
  ::panGroup           := if( ::lnewRec, 'MZD_PRIJEM', (::hd_file)->ctypDoklad )
  pm   := ::members    := aclone( drgDialog:dialogCtrl:members[1]:aMembers ) // drgDialog:oForm:aMembers
  pa_o := ::pao_nem_HD := {}

  ::nold_druhMzdy      := 0
  BEGIN SEQUENCE
    for x := 1 to ::brow:colCount step 1
      ocol := ::brow:getColumn(x)
      if 'NDRUHMZDY' $ ocol:frmColum
        ::ncol_druhMzdy := x
  BREAK
      endif
    next
  END SEQUENCE


  for x := 1 to len(::members) step 1
    className := ::members[x]:ClassName()
    groups    := isNull( ::members[x]:groups, '' )

    * 1 - typ dokladu
    * 2 - denik
    pa_groups := ListAsArray( groups )

    if pa_groups[1] $ typDokl

      if     className = 'drgStatic'
        aadd( ::paGroups, { pa_groups[1], ;
                            ::members[x], ;
                                       x, ;
                                     nil, ;
                                     nil, ;
                            sysConfig('MZDY:' +pa_groups[2]), 0, pa_groups[3] = 'MATR_ANO' } )

      elseif className = 'drgEBrowse'
        if (npos := ascan( pa, {|pit| pit[1] = groups} )) <> 0
          pa[npos,4] := ::members[x]
          pa[npos,5] := x

          colCount   := 0
          ardef      := ::members[x]:ardef
          aeval( ardef, { |o| colCount += if( isObject(o.drgPush), 2, 1 ) } )
          pa[npos,7] := colCount
        endif

      endif
      ::members[x]:groups := pa_groups[1]
    endif

    if( groups = 'MZD_MN_HD', aadd( pa_o, ::members[x]), nil )

    if     className = 'drgText' .and. .not. Empty(groups)
      if 'SETFONT' $ groups
        pa_groups := ListAsArray(groups)
        nin       := ascan(pa_groups,'SETFONT')

        ::members[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            ::members[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          ::members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
        ::members[x]:groups := ''
      endif

    elseif className = 'drgGet'
      field_name := lower( drgParseSecond( ::members[x]:name, '>'))
      if( npos := ascan( ::pac_naklst, { |s| s[1] = field_name } )) <> 0
        ::members[x]:isEdit := ::pac_naklst[npos,2]
      endif

    elseif classname = 'drgStatic'
       if ::members[x]:oxbp:type = XBPSTATIC_TYPE_ICON
         ::sta_keyMatr := ::members[x]
       endif
    endif
  next
  *
  ** pokud je dialog z mzd_kmenove_scr -> mzd_doklhrmzdo_scr
  ** nebo                                 mzd_doklhrmzpr_scr
  ** naplníme v INS pracovníka a zakážeme ho zmìnit
  **                                      mzd_doklhrmzdo_scr - volé poøízení s výbìrem nosCisPrac
  if isMemberVar( drgDialog:parent:UDCP, 'mo_prac_filtr', VAR_ASSIGN_PROTECTED )
     if .not. empty( drgDialog:parent:UDCP:mo_prac_filtr )
       *
       ** na prvních 7B je ' .and. ' pro použití filtru v mzd_doklhrmzdo_scr
       if left( lower( drgDialog:parent:UDCP:mo_prac_filtr), 7) = ' .and. '
         mo_prac_filtr := substr( drgDialog:parent:UDCP:mo_prac_filtr, 8 )
       else
         mo_prac_filtr := drgDialog:parent:UDCP:mo_prac_filtr
       endif

       msPrc_mos->(ads_clearAof())
       msprc_mos->( ads_setAof( mo_prac_filtr), dbgoTop() )

       if ::lnewRec
         ( ::o_osCisPrac:odrg:isEdit := .f., ::o_osCisPrac:odrg:oxbp:disable() )
           ::o_osCisPrac:set( msprc_mos->nosCisPrac )
           ::mzd_kmenove_sel()
           ::df:setNextFocus(::hd_file +'->ctyppohybu',,.t.)

         ::canSel_osCisPrac := .f.
       endif
     endif
  endif

  if .not. ::lnewRec
    *
    ** pokraèování nemoci,
    if (::hd_file)->_npokrN_MO = 1
      ( ::get_datumOd:isEdit  := .f., ::get_datumOd:oxbp:disable() )
    endif

  else
    ( ::cmb_typPoh:isEdit   := .t., ::cmb_typPoh:oxbp:enable()  )
    ( ::get_doklad:isEdit   := .t., ::get_doklad:oxbp:enable()  )
    ( ::get_datPoriz:isEdit := .t., ::get_datPoriz:oxbp:enable())
    ( ::get_datumOd:isEdit  := .t., ::get_datumOd:oxbp:enable() )
    ( ::cmb_keymatr:isEdit  := .t., ::cmb_keymatr:oxbp:enable() )

    ::comboItemSelected(::dm:has( ::hd_file +'->ctyppohybu'):oDrg)
    ::comboBoxInit( ::cmb_keymatr )
  endif

  drgDialog:dataManager:refresh()
  ::showGroup()
return self


method MZD_doklhrmz_CRD:drgDialogEnd(drgDialog)
  local  x, o_EBro


  for x := 1 to len(::paGroups) step 1
    ::paGroups[x,4]:oxbp:itemRbDown := { || .t. }
  next

  msprc_mos->( ads_clearAof())
return


method MZD_doklhrmz_CRD:destroy()
  ::drgUsrClass:destroy()

  mzdDavITs->( dbcloseArea())

  mzdDavhdWa ->(DbCloseArea())
  mzdDavitWa ->(DbCloseArea())

  mzdDavitW ->(DbCloseArea())
  mzdDav_iw ->(DbCloseArea())
return


METHOD MZD_doklhrmz_CRD:preValidate(drgVar)
  local  value := drgVar:value
  local  name  := lower(drgVar:name)
  local  ok    := .t.

  do case
  case(name = ::it_file +'->ndruhmzdy' )
    drgVar:odrg:isEdit := ( value = 0 )
**    return drgVar:odrg:isEdit
  endcase
return .t.


METHOD MZD_doklhrmz_CRD:postValidate(drgVar)
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-')
  local  ok     := .T., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F., ovar, recNo
  * HRMZDA
  local  it_ucetMzdy  , it_dnyDoklad ,   it_druhMzdy,  it_sazbaDokl, it_hodDoklad, it_mnPDoklad, it_hrubaMzda, it_premie
  * NEMOC
  local  it_dvykazN_OD, it_dvykazN_DO, it_dproplN_OD, it_dproplN_DO, it_nproplN_HO, it_nproplN_PD, it_nproplN_KD
  * SRAZKY
  local  npos
  local  nfondPracDoby
  local  nhodFond

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  * hlavièka dokladu
  case(file = ::hd_file)
    do case
    case(name = ::hd_file +'->noscisprac' .and. changed )
      ok := ::mzd_kmenove_sel()

    case(name = ::hd_file +'->ndoklad'   )
      ok     := fin_range_key( 'MZDDAVHD:' +(::hd_file)->cdenik,value,,::msg)[1]

    * pro doklady nemocenek
    case( name = ::hd_file +'->ddatumdo' )
     *
     ** zkusíme generovat buï nový doklad, nebo pokraèování nemoci
     if( ::lnewRec .or. (::hd_file)->_npokrN_MO = 1, ( drgVar:save(), ::gen_nemoc( self )), nil )

    endcase

  * položky dokladu
  case(file = ::it_file)

//    it_ucetMzdy  := if((::hd_file)->cdenik = 'MH', ::dm:has(::it_file +'->nucetMzdy' ), 0 )
    it_dnyDoklad := ::dm:has(::it_file +'->ndnyDoklad' )
    it_druhMzdy  := ::dm:has(::it_file +'->ndruhMzdy'  )
    it_sazbaDokl := ::dm:has(::it_file +'->nsazbaDokl' )
    it_hodDoklad := ::dm:has(::it_file +'->nhodDoklad' )
    it_mnPDoklad := ::dm:has(::it_file +'->nmnPDoklad' )
    it_hrubaMzda := ::dm:has(::it_file +'->nhrubaMzda' )
    it_premie    := ::dm:has(::it_file +'->npremie'    )

    * pro nemocenskou
    if (::hd_file)->cdenik = 'MN'
     c_nemPas->( dbseek( strZero( (::hd_file)->nrok   ,4) + ;
                         strZero( (::hd_file)->nobdobi,2) + ;
                         strZero( it_druhMzdy:value   ,4)   ) )

     it_dvykazN_OD := ::dm:has(::it_file +'->dvykazN_OD' )
     it_dvykazN_DO := ::dm:has(::it_file +'->dvykazN_DO' )

     it_dproplN_OD := ::dm:has(::it_file +'->dproplN_OD' )
     it_dproplN_DO := ::dm:has(::it_file +'->dproplN_DO' )

     it_nproplN_HO := ::dm:has(::it_file +'->nproplN_HO' )

     it_nproplN_PD := ::dm:has(::it_file +'->nproplN_PD' )
     it_nproplN_KD := ::dm:has(::it_file +'->nproplN_KD' )
    endif
    *
    ** tohle je jistota
    druhyMzd->(dbseek( it_druhMzdy:value,, 'DRUHYMZD01'))

    do case
    case(name = ::it_file +'->cnazpol1'  .and. changed )
      if (::hd_file)->cdenik = 'MH' .and. ::vnitrUcMz                      ;
                                    .and. value <> (::hd_file)->ckmenStrPr ;
                                    .and. ::dm:get(::it_file +'->nucetMzdy') = 0
        fin_info_box('Prosím pozor, musí být uveden mzdový úèet ...')
      endif



    case(name = ::it_file +'->ndruhmzdy' .and. changed )
      
      * na drhuhyMzd mùže bých chybnì nastaveno, pak by to spadlo
      * 
      if( druhyMzd->lhodZDnu .and. isNumber(it_dnyDoklad:value) .and. isNumber(it_hodDoklad:value) )

        * ke mzdì lze poøídit procento prémie
        ::dm:set( ::it_file +'->ndruhMzPre', druhyMzd->ndruhMzPre )

        if druhyMzd->lhodZDnu .and. it_dnyDoklad:value <> 0 .and. it_hodDoklad:value = 0
          nfondPracDoby := it_dnyDoklad:value * fPracDOBA()[3]
          it_hodDoklad:set( nfondPracDoby )

          ::aktFndHod( nfondPracDoby )
        endif
      endif

    case(name = ::it_file +'->ndnydoklad' .and. changed )
      ::aktFNDdny( it_dnyDoklad:value )
      if (::hd_file)->cdenik = 'MH' .and.( druhyMzd->ntypVypHm = 3        ;
                                     .or.  druhyMzd->ntypVypHm = 6 )      ;
                                    .and. value = 0
        fin_info_box('Prosím pozor, údaj dny by mìl být rùzný od nuly ...')
      endif


    case(name = ::it_file +'->nhoddoklad' .and. changed )
      ::aktFNDHod( it_hodDoklad:value )
      if (::hd_file)->cdenik = 'MH' .and. druhyMzd->ntypVypHm = 1        ;
                                    .and. value = 0
        fin_info_box('Prosím pozor, údaj hodiny by mìl být rùzný od nuly ...')
      endif

    case(name = ::it_file +'->nmnpdoklad' .and. changed )
      if (::hd_file)->cdenik = 'MH' .and. druhyMzd->ntypVypHm = 2        ;
                                    .and. value = 0
        fin_info_box('Prosím pozor, údaj množství by mìl být rùzný od nuly ...')
      endif

    case(name = ::it_file +'->nsazbadokl' .and. changed )
      if (::hd_file)->cdenik = 'MH' .and. druhyMzd->ntypVypHm > 0        ;
                                    .and. value = 0
        fin_info_box('Prosím pozor, údaj sazba by mìl být rùzný od nuly ...')
      endif
    *
    ** nemocenská
    case((name = ::it_file +'->dvykazn_od' .or. name = ::it_file +'->dvykazn_do' ) .and. changed )
      * kalendáøní dny
      ::dm:set( ::it_file +'->nvykazN_KD',         max(0, (it_dvykazN_DO:value -it_dvykazN_OD:value) +1 ))
      ::dm:set( ::it_file +'->nvykazN_PD', Fx_prcDnyOD(    it_dvykazN_OD:value, it_dvykazN_DO:value     ))
      ::dm:set( ::it_file +'->nvykazN_VD', Fx_volDnyOD(    it_dvykazN_OD:value, it_dvykazN_DO:value     ))

      * proplaceno dny
      ndnyPas := (c_nemPas->npasmoDo -c_nemPas->npasmoOd) + 1

      ::dm:set( ::it_file +'->dproplN_OD', it_dvykazN_OD:value )
      ::dm:set( ::it_file +'->dproplN_DO', it_dvykazN_DO:value )
      ::dm:set( ::it_file +'->nproplN_KD', (it_dproplN_DO:value -it_dproplN_OD:value) +1 )
      ::dm:set( ::it_file +'->nproplN_PD', Fx_prcDnyOD( it_dproplN_OD:value, it_dproplN_DO:value ))
      ::dm:set( ::it_file +'->nproplN_VD', Fx_volDnyOD( it_dproplN_OD:value, it_dproplN_DO:value ))

      * výpoèet hodin z nproplN_PD  ntypVypHm = 1:hodiny * sazba
      if druhyMzd->ntypVypHm = 1
        ::dm:set( ::it_file +'->ndnyDoklad', it_nproplN_PD:value )

        if it_nproplN_HO:value = 0
          ::dm:set( ::it_file +'->nhodDoklad', it_nproplN_PD:value * fPracDOBA()[3] )
        else
          ::dm:set( ::it_file +'->nhodDoklad', it_nproplN_HO:value )
        endif
      else
        ::dm:set( ::it_file +'->ndnyDoklad', it_nproplN_KD:value )
        ::dm:set( ::it_file +'->nhodDoklad', 0 )
      endif

      ::aktFndNem( ::dm:has(::it_file +'->nvykazN_KD'):value, ;
                   ::dm:has(::it_file +'->nvykazN_PD'):value  )

    case((name = ::it_file +'->nvykazn_kd' .or. name = ::it_file +'->nvykazn_pd' ) .and. changed )
      ::aktFndNem( ::dm:has(::it_file +'->nvykazN_KD'):value, ;
                   ::dm:has(::it_file +'->nvykazN_PD'):value  )

    case( name = ::it_file +'->nvykazn_h1' .and. changed )
      nhodFond :=  ::dm:has(::it_file +'->nvykazN_KD'):value * fPracDOBA()[3]
      nHodFond -=  ::dm:has(::it_file +'->nvykazN_H1'):value
      ::dm:set(::it_file +'->nHodFondKD', nhodFond )
      nhodFond :=  ::dm:has(::it_file +'->nvykazN_PD'):value * fPracDOBA()[3]
      nHodFond -=  ::dm:has(::it_file +'->nvykazN_H1'):value
      ::dm:set(::it_file +'->nHodFondPD', nhodFond )


    case( name = ::it_file +'->npropln_pd' .and. changed )
     * výpoèet hodin z nproplN_PD  ntypVypHm = 1:hodiny * sazba
      if druhyMzd->ntypVypHm = 1
        ::dm:set( ::it_file +'->ndnyDoklad', it_nproplN_PD:value )

        if it_nproplN_HO:value = 0
          ::dm:set( ::it_file +'->nhodDoklad', it_nproplN_PD:value * fPracDOBA()[3] )
        else
          ::dm:set( ::it_file +'->nhodDoklad',it_nproplN_HO:value )
        endif
      else
        ::dm:set( ::it_file +'->ndnyDoklad', it_nproplN_KD:value )
        ::dm:set( ::it_file +'->nhodDoklad', 0 )
      endif
    ** nemocenská
    *
    * srážky
    case(name = ::it_file +'->czkrsrazky' .and. changed )
      it_druhMzdy:set( c_srazky->ndruhMzdy)

    endcase

    n_sazbaDokl := ::VypHrMz()
  endcase

  * hlavièku ukládáma na každém prvku
  if( ::hd_file $ name .and. drgVar:changed() .and. ok)
    drgVar:save()
  endif
return ok


method mzd_doklhrmz_crd:postsave()
  local  ok        := .t.
  local  pa        := ::pa_info
  *
  local  cfiltr, nrok, nobdobi
  local  oscisPrac := mzdDavHDw->noscisPrac
  local  porPraVzt := mzdDavHDw->nporPraVzt

  ok := mzd_mzddavhd_wrt_inTrans(self)

  if ( ok .and. ::lnewRec )
    mzdDavHdw->( dbcloseArea())
    mzdDavItw->( dbcloseArea())
    mzdDav_iw->( dbCloseArea())

    MZD_mzddavhd_cpy(self)

    * poøizuji doklady v kruhu pro nosCisPrac a nporPraVzt ?
    if .not. ::canSel_osCisPrac
      mzdDavHdw->noscisPrac := oscisPrac
      mzdDavHdw->nporPraVzt := porPraVzt

      ::o_osCisPrac:set( msprc_mos->nosCisPrac )
      ::mzd_kmenove_sel()
    endif

    * pro sumu za daný klíè
    aeval( pa, { |x| x[2] := x[3] := x[4] := x[5] := x[7] := 0 } )
    drgDBMS:open('MZDDAVHD',,,,, 'mzddavHd_s')
    ::sum_mzddavhd()

    nrok    := uctOBDOBI:MZD:NROK
    nobdobi := uctOBDOBI:MZD:NOBDOBI

    if ::canSel_osCisPrac
      cfiltr := Format("nROK = %% .and. nOBDOBI = %% .and. lstavem", {nrok,nobdobi})
      msprc_mos->( ads_setaof(cfiltr), dbGoTop())
    endif

    ::msprc_mo_seek()

    ::df:setNextFocus(::hd_file +'->ctyppohybu',,.t.)

    ::comboItemSelected(::dm:has( ::hd_file +'->ctyppohybu'):oDrg)
    ::dm:refresh()
    ::showGroup()
    ::brow:goTop():refreshAll()

  elseif( ok .and. .not. ::lnewRec )
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return ok


METHOD MZD_doklhrmz_CRD:onSave(lIsCheck,lIsAppend)                                 // kotroly a výpoèty po uložení
  LOCAL  dc       := ::drgDialog:dialogCtrl
  LOCAL  cALIAs   := ALIAS(dc:dbArea)

  IF !lIsCheck
//    IF (cALIAs) ->nCISFIRMY == 0
//      (cALIAs) ->nCISFIRMY := FIRMYw ->nCISFIRMY
//    ENDIF
  ENDIF
RETURN .T.


**
METHOD MZD_doklhrmz_CRD:NewDoklad()

   MZDDAVHDW->( dbAppend())
   MZDDAVITW->( dbAppend())
   ::drgDialog:dataManager:refresh()
   ::drgDialog:oForm:setNextFocus('MZDDAVHDW->NDOKLAD',, .T. )
RETURN self


method MZD_doklhrmz_CRD:mzd_kmenove_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar  := ::o_osCisPrac
  local  value   := drgVar:get()
  local  name    := lower(drgVar:name)
  local  changed
  local  in_file := 'msprc_mos', cmain_Ky
  *
  local  recCnt := 0, showDlg := .f., ok := .f.
  local  lAuKmStroj := sysConfig( "Mzdy:lAuKmStroj")

  if isObject(drgDialog)
    showDlg := .t.

  else
    msprc_mos->( adsSetOrder( 'MSPRMO09' )    , ;
                 dbSetScope(SCOPE_BOTH, value), ;
                 dbGoTop()                    , ;
                 dbeval( {|| recCnt++ })      , ;
                 dbgotop()                    , ;
                 dbclearScope()                 )

    showDlg := .not. (recCnt = 1)
         ok :=       (recCnt = 1)
    if(recCnt = 0, msprc_mos->(dbclearscope(),dbgotop()), nil)
  endif

  if showDlg
    in_file := 'msprc_mob'
    DRGDIALOG FORM 'MZD_msprc_moB_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if .not. showDlg .or. (nexit != drgEVENT_QUIT)
    ::copyfldto_w( in_file, ::hd_file )
    *
    drgvar:value = drgvar:initValue := drgvar:prevValue := (in_file)->nOsCisPrac
    *
    ** Automaticky dotahovat kmenové støedisko stroje
    if( .not. lAuKmStroj, (::hd_file)->ckmenStrSt :=  (in_file)->ckmenStrPr, nil )
    *
    * dotáhnem položky z msvPrum
    cmain_Ky := DBGetVal(::cmain_Ky)
    msvPrum->( dbseek( cmain_Ky,, 'PRUMV_03'))
    (::hd_file)->nHodPrumNA := msvPrum->nHodPrumNA
    (::hd_file)->nDenVZhruN := msvPrum->nDenVZhruN
    (::hd_file)->nDenVZcisN := msvPrum->nDenVZcisN
    (::hd_file)->nDenVZciKN := msvPrum->nDenVZciKN

    ::sum_mzddavhd()
    ::msprc_mo_seek()
    ::refresh(drgVar)

    * je možné dotáhnout do comba definované matrice pro pracovnníka ?
    if( ::cmb_keymatr:isEdit, ::comboBoxInit( ::cmb_keymatr ), nil )

    ::dm:refresh()
    ::df:setNextFocus(::hd_file +'->ndoklad',,.t.)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method MZD_doklhrmz_CRD:mzd_trvZavhd_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar  := ::dm:has( ::it_file +'->cpohZavFir' )
  local  value   := drgVar:get()
  local  name    := lower(drgVar:name)
  local  pohZavFir
  *
  local  showDlg := .f., ok := .f.

   if isObject(drgDialog)
     showDlg := .t.
   else
     if trvZavhd->(dbseek( value,,'TRVZAVHD02'))
       showDlg := .f.
            ok := .t.
     else
       showDlg := .t.
     endif
   endif

   if showDlg
     DRGDIALOG FORM 'MZD_trvZavHd_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
   endif

   if .not. showDlg .or. (nexit != drgEVENT_QUIT)
     pohZavFir := trvZavhd->ctyppohybu +if(trvZavhd->ncisFirmy <> 0, strZero(trvZavhd->ncisFirmy,5), '     ' )
     drgVar:set( pohZavFir )
   endif
return (nexit != drgEVENT_QUIT) .or. ok


method MZD_doklhrmz_crd:comboBoxInit(drgComboBox)
  LOCAL  cname      := drgParseSecond(drgComboBox:name,'>')
  local  in_file    := lower(drgParse(drgComboBox:name,'-'))
  LOCAL  afields    := {'x-NRADVYKDPH', 'NPROCDAN_1', 'NPROCDAN_2', ;
                        'CTYPPOHYBU', 'COBDOBI'   , 'COBDOBIDAN', 'CTYPDOKLAD', 'CTYPOBRATU', 'NKEYMATR' }
  local  acombo_val := {}, nnapocet, ky, pa, block := { || .t. }, x, ncol, nrow, npos

  * ?? doklad v režimu opravy
  local  inRevision := (drgComboBox:drgDialog:cargo = drgEVENT_EDIT), onSort := 2, filter, uloha
  local  value, rok, typ_dokl
  local  cmain_Ky, lok
  local  cc        := ' - automatický výpoèet hrubé mzdy'

  drgDBMS:open('c_typpoh')
  drgDBMS:open('typdokl' )  ;  typdokl->(AdsSetOrder('TYPDOKL01'))

  if AScan(aFIELDs,cNAMe) <> 0

    do case
    case('CTYPPOHYBU' = cname)
      ky := 'MDOKLADY       '

      c_typpoh->(dbsetscope(SCOPE_BOTH,ky), dbgotop())
      do while .not. c_typpoh ->(eof())
        if eval(block)
          typdokl ->(dbseek(c_typpoh ->(sx_keyData())))
          aadd( acombo_val, { c_typpoh ->ctyppohybu       , ;
                              c_typpoh ->cnaztyppoh       , ;
                              c_typpoh ->ctypdoklad       , ;
                              alltrim(typdokl  ->ctypcrd) , ;
                              c_typpoh->ctask             , ;
                              c_typpoh->csubtask          , ;
                              c_typpoh->craddph091          } )
        endif
        c_typpoh->(dbskip())
      endDo
      c_typpoh ->(dbclearscope())

    case( 'NKEYMATR' = cname )
      aadd( acombo_val, { 0, 'Bez poøizovací masky', .f., '' } )

      if (::hd_file)->noscisPrac <> 0
        cmain_Ky := DBGetVal(::cmain_Ky)
              ky := strZero( (::hd_file)->noscisPrac, 5) +strZero( (::hd_file)->nporPraVzt,3)

        msMzdyhd->( dbsetScope(SCOPE_BOTH,ky), dbGoTop() )
        do while .not. msMzdyhd->( eof())
          lok := .t.

          * použila již automatikou matrici,
          * je jen jedna lautoVypHM = .t. and ctypMasky = 'AUVYH'
          * ostatní matrice lze použít pro poøízení n_krát
          if msMzdyhd->lautoVypHM
            lok := .not. mzdDavit->( dbseek( cmain_Ky +'AUVYH',,'MZDDAVIT27'))
          endif

          if lok
            aadd( acombo_val, { msMzdyhd->nkeyMatr                                            , ;
                                allTrim(msMzdyhd->cnazMatr) +if( msMzdyhd->lautoVypHM, cc, ''), ;
                                msMzdyhd->lautoVypHM, upper(msMzdyhd->ctypMasky) } )
          endif

/*
          if msMzdyhd->lautoVypHM
            lok := .not. mzdDavit->( dbseek( cmain_Ky +'1',,'MZDDAVIT23'))
          endif

          if lok
            aadd( acombo_val, { msMzdyhd->nkeyMatr                                            , ;
                                allTrim(msMzdyhd->cnazMatr) +if( msMzdyhd->lautoVypHM, cc, ''), ;
                                msMzdyhd->lautoVypHM } )
          endif
*/

          msMzdyhd->( dbskip())
        enddo
        msMzdyhd->( dbclearScope())
      endif
    endcase

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[onSort] < aY[onSort] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgComboBox:value := drgComboBox:ovar:value

    if 'NKEYMATR' = cname
      npos := ascan( acombo_val, { |i| i[3] = .t. } )
      npos := if( npos = 0, 1, npos )

      drgComboBox:oXbp:xbpSLE:setData( acombo_val[npos,2])
      drgComboBox:setValue()

      (::hd_file)->nkeyMatr   := acombo_val[npos,1]
      (::hd_file)->lautoVypHM := acombo_val[npos,3]
    endif

  endif
return self


method MZD_doklhrmz_crd:comboItemselected( drgComboBox, isMarked )
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nin, panGroup
  *
  local  odrg_hd := ::dm:has( ::hd_file +'->ndnyFondKD' )
  local  cky, file_name, keyMatr, autoVypHM, typMasky
  *
  local   nrok, nobdobi, cdenik, cfiltr

  do case
  case 'CTYPPOHYBU' $ drgComboBox:name
    nin      := AScan(values, {|X| X[1] = value })
    panGroup := values[nin,3]

    if( (::it_file)->(eof()), nil, ::reOpen_mzdDavitW(.t.) )

    (::hd_file)->ctypDoklad := values[nin,3]
    (::hd_file)->ctypPohybu := values[nin,1]

    npos := ascan( ::paGroups, {|x| x[1] = panGroup })
    (::hd_file)->cdenik     := ::paGroups[npos,6]
    (::hd_file)->ndoklad    := fin_range_key('MZDDAVHD:' +::paGroups[npos,6])[2]

    ::dm:set( ::hd_file +'->ndoklad', (::hd_file)->ndoklad )

    if( ::panGroup <> panGroup, ( ::panGroup := panGroup, ::showGroup() ), nil )

    * tvrdì omezíme druhyMzd rok/obdobi/denik
    nrok    := uctOBDOBI:MZD:NROK
    nobdobi := uctOBDOBI:MZD:NOBDOBI
    cdenik  := (::hd_file)->cdenik

    cfiltr  := Format("nROK = %% .and. nOBDOBI = %% .and. cdenik = '%%'", {nrok,nobdobi,cdenik})
    druhyMzd->( ads_clearAof(), ads_setaof(cfiltr), dbGoTop())


  case 'NKEYMATR'  $ drgComboBox:name
    nin       := AScan(values, {|X| X[1] = value })
    keyMatr   := values[nin,1]
    autoVypHM := values[nin,3]
    typMasky  := values[nin,4]

    ::sta_keyMatr:oxbp:setCaption( if( autoVypHM, 427, 0) )
    (::hd_file)->nkeyMatr   := keyMatr
    (::hd_file)->lautoVypHM := autoVypHM
    (::hd_file)->ctypMasky  := typMasky

    if keyMatr <> 0  //  autoVypHM
      ::msMzdyit_to_mzdDavitw( keyMatr, autoVypHM )
    else
      ::reOpen_mzdDavitw(.t.)
    endif

    _clearEventLoop()
    mzd_mzddavhd_cmp()

    ::refresh( odrg_hd )
    ::brow:refreshAll()

    * pøesuneme se na BRO
    PostAppEvent(xbeP_Keyboard,xbeK_TAB,,drgComboBox:oxbp)
  endcase
return self


method MZD_doklhrmz_crd:ebro_afterAppendBlankRec(o_eBro)

  ::copyfldto_w( ::hd_file, ::it_file )
return self


method MZD_doklhrmz_crd:ebro_beforSaveEditRow( drgEBrowse )
  local  lok := .t.
  local  o_nazPol1

  * hrubá mzda -> kontrola cnzapol1 ... 6
  if (::hd_file)->cdenik = 'MH'
    o_nazPol1 := ::dm:has(::it_file +'->cnazPol1' )
    lok       := ::c_naklst_vld(o_nazPol1)
  endif
return lok


method MZD_doklhrmz_crd:ebro_saveEditRow( drgEBrowse )
  local  odrg_hd := ::dm:has( ::hd_file +'->ndnyFondKD' )
  *
  local  ordRec, recNo, nordItem := drgEBrowse:odata:nordItem
  local  ardef      := drgEBrowse:ardef
  local  zaklZdrPo
  local  ok_praVzt  := ( msPrc_mo->ntypPraVzt <> 5 .and. msPrc_mo->nTypPraVzt <> 9 )
  local  is_student := ( msPrc_mo->ntypZamVzt = 11 .or.  msPrc_mo->lStudent        )
  local  pohZavFir
  *
  local  old_ordItem, pa_ordItem := {}

  ::itSave( 'ITw' )

  * hrubá mzda
  if (::hd_file)->cdenik = 'MH'
    ::aktFnd_DnyHod()
    mzdDavItw->nHrubaMZD := mzdDavItw->nmzda
  endif

  * nemocenská
  if (::hd_file)->cdenik = 'MN'
    (::it_file)->ndnyDoklad := ::dm:get( ::it_file +'->ndnyDoklad' )
    (::it_file)->nhodDoklad := ::dm:get( ::it_file +'->nhodDoklad' )

    * Vylouèená doba a Vylouèená doba v ochranné dobì
    * lVylouDoba  -->  nDnyVylocD
    * lVyloDobOD  -->  nDnyVylDOD
    (::it_file)->nDnyVylocD := if( druhyMzd->lVylouDoba, (::it_file)->nvykazN_KD, 0)
    (::it_file)->nDnyVylDOD := if( druhyMzd->lVyloDobOD, (::it_file)->nvykazN_KD, 0)
  endif

  (::it_file)->(dbcommit())

  do case
  case drgEBrowse:isAppend
    (::it_file)->nsubItem := 0

    if drgEBrowse:isAddData .or. nordItem = 0
      (::it_file)->nordItem := nordItem +10

    else
      (::it_file)->nordItem := nordItem

       recNo := (::it_file)->(recNo())
      ordRec := fordRec({ ::it_file })

      (::it_file)->(AdsSetOrder(0),dbgoTop())

      do while .not. (::it_file)->(eof())
        if (::it_file)->nordItem >= nordItem  .and. (::it_file)->(recNo()) <> recNo

          (::it_file)->nordItem += 10
          *
          ** pokud pøeèíslujeme, musíme pøeèíslovat i automaticky generované prémie
          if (::hd_file)->cdenik = 'MH' .and. (::it_file)->_nsidPrem <> 0
            if mzdDavitS->( dbseek( (::it_file)->_nsidPrem,,'ID'))
               mzdDavitS->nordItem := (::it_file)->nordItem +9
            endif
          endif
        endif
        (::it_file)->(dbskip())
      enddo
      fordRec()
    endif
  endcase

  * srážky
  if (::hd_file)->cdenik = 'MS'

    pohZavFir := upper( (::it_file)->cpohZavFir)

    if (::it_file)->ncisFirmy <> 0
      trvZavHd->( dbseek(       pohZavFir               ,,'TRVZAVHD02'))
    else
      trvZavHd->( dbseek( left( pohZavFir, 10) +'00000' ,,'TRVZAVHD02'))
    endif


    (::it_file)->ctypPohZav := trvZavhd ->ctyppohybu
    (::it_file)->ncisFirmy  := trvZavhd ->ncisFirmy
    (::it_file)->ntrvZavHd  := trvZavHd ->sID

    * pro generování pøíkazu k úhradì
    (::it_file)->cZkratStat := SysConfig( 'System:cZkrStaOrg' )
    (::it_file)->czkratMeny := SysConfig( 'Finance:cZaklMENA' )
    (::it_file)->czkratMenZ := SysConfig( 'Finance:cZaklMENA' )
    (::it_file)->nMNOZPREP  := 1
    (::it_file)->nKURZAHMEN := 1

    * cucet
    if .not. empty( (::it_file)->cuceti +(::it_file)->ckodBanky )
      (::it_file)->cucet := allTrim((::it_file)->cuceti ) +'/' +allTrim((::it_file)->ckodBanky )
    endif
  endif

  * nechtìjí editovat ani vidìt nákladovou strukturu, ale mají ji pøenastavenou
  if ::prednNakR                .and. ;
     (::hd_file)->cdenik = 'MH' .and. ;
     c_naklst->( dbseek( msPrc_mo->ckmenStrPr +'1',,'C_NAKLST9'))

     if( mzddavITw->cnazPol1 <> c_naklst->cnazPol1, mzddavITw->cnazPol1 := c_naklst->cnazPol1, nil)
     if( mzddavITw->cnazPol2 <> c_naklst->cnazPol2, mzddavITw->cnazPol2 := c_naklst->cnazPol2, nil)
     if( mzddavITw->cnazPol3 <> c_naklst->cnazPol3, mzddavITw->cnazPol3 := c_naklst->cnazPol3, nil)
     if( mzddavITw->cnazPol4 <> c_naklst->cnazPol4, mzddavITw->cnazPol4 := c_naklst->cnazPol4, nil)
     if( mzddavITw->cnazPol5 <> c_naklst->cnazPol5, mzddavITw->cnazPol5 := c_naklst->cnazPol5, nil)
     if( mzddavITw->cnazPol6 <> c_naklst->cnazPol6, mzddavITw->cnazPol6 := c_naklst->cnazPol6, nil)
  endif

  * modifikace položky pøed nápoètem
  mzdDavitw->cucetskup  := allTrim( Str( mzdDavItw->ndruhMzdy))
  mzdDavItw->nzaklSocPo := 0
  mzdDavItw->nzaklZdrPo := 0

  if( msPrc_mo->lsocPojis .and. druhyMzd->lsocPojis .and. ok_praVzt) .or. druhyMzd->ndruhmzdy = 304
     mzdDavItw->nzaklSocPo := mzdDavItw->nHrubaMZD
  endif

  if( msPrc_mo->nzdrPojis <> 0 .and. druhyMzd->lzdrPojis .and. ok_praVzt) .or. druhyMzd->ndruhmzdy = 305
    mzdDavItw->nzaklZdrPo := mzdDavItw->nHrubaMZD
  endif

  * hrubá mzda deník MH
  if (::hd_file)->cdenik = 'MH'

    * pro automaticky generované prémie k základní mzdì
    ::VypocPremie( msPrc_mo->lsocPojis .and. ok_praVzt,  msPrc_mo->nzdrPojis <> 0 .and. ok_praVzt  )

    * musíme zabezpeèit automatiký pøepoèet
    if( (::it_file)->nautoGen = 0, ::doklhrmz_aut_modify(drgEBrowse:isAppend), nil )
  endif

  mzd_mzddavhd_cmp()

  * modifikace pro základ zdravotního pojištìní po nápoètu
  if msPrc_mo->nzdrPojis <> 0 .and. druhyMzd->lzdrPojis .and. ok_praVzt
    if ( is_student .or. msPrc_mo->ntypDuchod <> 0 .or. ;
                         msPrc_mo->nmimoPrVzt  = 1 .or. ;
                         msPrc_mo->nmimoPrVzt  = 2 .or. ;
                         msPrc_mo->nmimoPrVzt  = 3      ) .and. ::zaklZdrPo_sum() < ::hodnZdrSt

                  zaklZdrPo := ::zaklZdrPo_sum() - ::hodnZdrSt
      mzdDavItw->nzaklZdrPo := zaklZdrPo
      mzddavHdw->nzaklZdrPo := mzddavHdw->nzaklZdrPo - zaklZdrPo
    endif
  endif

  mzdDavitW->( dbcommit())
  ::refresh( odrg_hd )
return .t.


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method MZD_doklhrmz_crd:showGroup()
  local  x, oEBro, nit_Start, nit_Count
  local  avars, members := aclone(::members)
  *
  local  members_grp  := {}, nit_Head := ::paGroups[1,3] -1
  local  panGroup     := ::panGroup, nin, lcanset_matr
  *
  * promìnné pro poøízení nemocenek
  local  pa_noVisible, ardef, npos, odrg

  for x := 1 to len(::paGroups) step 1
    if ::paGroups[x,1] = ::panGroup
      ::paGroups[x,2]:oxbp:show()
      ::brow    := ::paGroups[x,4]:oxbp
      oEBro     := ::paGroups[x,4]
      nit_Start := ::paGroups[x,3]
      nit_Count := ::paGroups[x,7] +2
    else
      ::paGroups[x,2]:oxbp:hide()
    endif
  next

  * hlavièka dokladu
  aeval( members, { |o| aadd( members_grp, o ) },         1, nit_Head )

  * na 8 rozmìru ::panGroup je indikace pro matrici t - ok, f - není editovatelná
  if( npos := ascan( ::paGroups, { |x| x[1] = panGroup } )) <> 0
    if ::paGroups[ npos, 8]
      ::cmb_keymatr:isEdit := .t.
      ::cmb_keymatr:oxbp:show()
      ::sta_keyMatr:oxbp:setCaption( if( (::hd_file)->lautoVypHM, 427, 0) )
    else
      ::cmb_keymatr:isEdit := .f.
      ::cmb_keymatr:oxbp:hide()
      ::sta_keyMatr:oxbp:setCaption(0)
    endif
  endif

  * Static + EBro + GETy pro ttyp dokladu
  aeval( members, { |o| aadd( members_grp, o ) }, nit_Start, nit_Count )

  * neviditelné pomocné položky
  nit_Start := ::paGroups[3,3] + ::paGroups[3,7] +2
  aeval( members, { |o| aadd( members_grp, o ) }, nit_Start            )

  avars := drgArray():new()

  for x := 1 to len(members_grp) step 1
    if ismembervar(members_grp[x],'ovar') .and. isobject(members_grp[x]:ovar)
      if members_grp[x]:ovar:className() = 'drgVar'
        avars:add(members_grp[x]:ovar,lower(members_grp[x]:ovar:name))
      endif
    endif
  next

  ::df:aMembers := members_grp
  ::dm:vars     := avars

  * pro deník MN
  if (::hd_file)->cdenik = 'MN'
    aeval( ::pao_nem_HD, { |o,n| ( if( n = 2, o:isEdit := .t., nil), o:oxbp:show() ) } )

    * sloupce v gridu pro poøízení nemocenek nesmí byt vidìt, jsou pomocé pro výpoèet
*    pa_noVisible := { 'nhoddoklad', 'ndnydoklad' }
    pa_noVisible := { 'ndnydoklad' }
    ardef        := oEBro:arDef

    for x := 1 to len(pa_noVisible) step 1
      if ( npos := ascan( ardef, { |ait| pa_noVisible[x] $ lower( ait[2]) })) <> 0
        * musíme pøehodit parenta, jinak to padne na destroy
        odrg_s := ardef[npos]
        odrg_s[7]:oBord:setParent( ::drgDialog:dialog )

        oEBro:oxbp:delColumn( npos )
        aRemove( arDef, npos )
      endif
    next
  else
    aeval( ::pao_nem_HD, { |o,n| ( if( n = 2, o:isEdit := .f., nil), o:oxbp:hide() ) } )
  endif
return self


method MZD_doklhrmz_crd:copyfldto_w(from_db,to_db,app_db)
  local  npos, xval, afrom := (from_db)->(dbstruct()), x
  *
  local  citem

  if(isnull(app_db,.f.),(to_db)->(dbappend()),nil)
  for x := 1 to len(afrom) step 1
    citem := to_Db +'->' +(to_Db)->(fieldName(x))

    if .not. (lower(afrom[x,DBS_NAME]) $ 'nmzda,_nrecor,_delrec,nautogen')
      xval := (from_db)->(fieldget(x))
      npos := (to_db)->(fieldpos(afrom[x,DBS_NAME]))

      if(npos <> 0, (to_db)->(fieldput(npos,xval)), nil)
    endif
  next
return nil


method MZD_doklhrmz_crd:refresh(drgVar,nextFocus,vars_)
  local  nin, ovar, vars, new_val, dbArea
  *
  local  groups

  default nextFocus to .f.

  if isobject(drgVar)  ;  dbarea := lower(drgParse(drgVar:name,'-'))
                          vars   := drgVar:drgDialog:dataManager:vars
  else                 ;  dbarea := lower(drgVar)
                          vars   := vars_
  endif

  for nIn := 1 TO vars:size() step 1
    oVar   := vars:getNth(nIn)
    groups := isNull( oVar:oDrg:groups, '' )

    if empty( groups) .or. ::panGroup = groups

      if (dbArea == lower(drgParse(oVar:name,'-')) .or. 'M' == drgParse(oVar:name,'-')) .and. isblock(ovar:block)
        if(new_val := eval(ovar:block)) <> ovar:value
          ovar:set(new_val)
        endif
        ovar:initValue := ovar:prevValue := ovar:value
      endif
    endif
  next

  if nextFocus
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
  endif
return .t.