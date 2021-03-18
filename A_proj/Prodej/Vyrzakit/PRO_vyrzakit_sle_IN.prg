#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "gra.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'osoby'   , 'kalendar', 'vyrzak', 'vyrzakit', 'explsthd', 'explstit', ;
                   'rozvozhd', 'rozvozit' }

*
** CLASS for PRO_vyrzakit_sle_IN ***********************************************
CLASS PRO_vyrzakit_sle_in FROM drgUsrClass, quickFiltrs, FIN_finance_IN
exported:
  var     lnewRec
  method  init, drgDialogStart, drgDialogEnd, itemMarked
  method  postvalidate

  method  pro_explsthd_scr
  method  pro_vyrzakit_sle_OSB_sel, pro_rozvozhd_sel

  method  ebro_saveEditRow

  * položky - bro
  *           tpv
  inline access assign method tpv_column() var tpv_column
    local  czkrOs := if( empty(vyrZakpl->czkrOs_Tpv), space(8), vyrZakpl->czkrOs_Tpv)
    local  colum  :=                czkrOs      +' | ' + ;
                     dtoc(vyrZakpl->dzahPL_Tpv) +' | ' + ;
                     dtoc(vyrZakpl->dkonPL_Tpv) +' | ' + ;
                     dtoc(vyrZakpl->dzahSK_Tpv) +' | ' + ;
                     dtoc(vyrZakpl->dkonSK_Tpv)
    return colum



  inline access assign method mnozPlano() var mnozPlano
    local val := 0
    vyrzai_s->(::s_scope(), dbeval({|| val += vyrzai_s->nmnozPlano}))
    return val

  inline access assign method cenaCelk() var cenaCelk
    local val := 0
    vyrzai_s->(::s_scope(), dbeval({|| val += vyrzai_s->ncenaCelk}))
    return val

 inline access assign method cenCelTuz() var cenCelTuz
    local val := 0
    vyrzai_s->(::s_scope(), dbeval({|| val += vyrzai_s->ncenCelTuz}))
    return val

  * info
  inline access assign method crozm_del_sir_vys() var crozm_del_sir_vys
    local  cc :=  '( ' + allTrim( str( vyrZakit->nRozm_del, 13, 2)) +' / ' + ;
                         allTrim( str( vyrZakit->nRozm_sir, 13, 2)) +' / ' + ;
                         allTrim( str( vyrZakit->nRozm_vys, 13, 2)) +' ) ' + ;
                         vyrZakit->cRozm_MJ
    return cc

  inline access assign method ncisFirmy_cnazFirmy() var ncisFirmy_cnazFirmy
    local  cc := '( ' +allTrim( str( vyrZakpl->ncisFirmy,5)) +' _ ' + ;
                       allTrim(      vyrZakpl->cnazFirmy   ) +' )'
    return cc

  inline access assign method nazevDop() var nazevDop
    local  doklRozv := vyrZakpl->ndoklRozv
    rozvozhd->( dbseek( doklRozv,,'ROZVOZHD01'))
  return rozvozhd->cnazevDop


  *
  **
  inline access assign method is_expList() var is_expList
    return if( .not. empty(vyrzakit->ncisloEL), MIS_ICON_OK, 0)

  inline access assign method firmaDOP() var firmaDOP
    return explsthd->cnazevDOP

  inline access assign method datExpedice() var datExpedice
    return explsthd->dexpedice

  inline access assign method datNakladky() var datNakladky
    return explsthd->dnakladky

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
       return .t.
    endcase
    return .f.

  inline method fuj ( oBro )
    local c, ocolumn

    for x := 1 to oBro:colCount step 1
      ocolumn := oBro:getColumn(x)

      if ocolumn:type = XBPCOL_TYPE_TEXT
**        ocolumn:type := XBPCOL_TYPE_MULTILINETEXT
      endif

      ocolumn:DataAreaLayout[XBPCOL_DA_ROWHEIGHT]    := 50
*       ocolumn:DataAreaLayout[XBPCOL_DA_CELLHEIGHT]   := 10
*       ocolumn:dataArea:maxRow := 1
      oColumn:configure()
    next
    oBro:configure()
    return

hidden:
* sys
  var     msg, dm, dc, df, ab, brow
* datové
  var     ndoklRozv_org
  var     o_ndoklRozv, o_nazevDop, o_dNakladky, o_cCasNaklad, o_dVykladky, o_cCasVyklad, o_mTextRozv


  inline method s_scope()
    local ky := strZero(kalendar->nrok,4) +strZero(kalendar->ntyden,2)

    vyrzai_s->(AdsSetOrder('ZAKIT_6'),dbsetScope(SCOPE_BOTH,ky),dbgotop())
  return nil
ENDCLASS


method PRO_vyrzakit_sle_in:init(parent)
  local  cky := 'strZero(kalendar->nrok,4) +strZero(kalendar->ntyden,2)'
  local  bky := COMPILE(cky)

  ::drgUsrClass:init(parent)

  ::lnewRec := .f.

  * základní soubory
  ::openfiles(m_files)
  explstit->(dbSetRelation('explsthd',{|| explstit->ndoklad}, 'explstit->ndoklad','EXPLSTHD01'))

  * pomocný soubor pro souèty
  if(select('vyrzai_s') = 0, drgDBMS:open('vyrzakit',,,,,'vyrzai_s'), nil)
  vyrzai_s->(AdsSetOrder('ZAKIT_6'))
return self


method PRO_vyrzakit_sle_in:drgDialogStart(drgDialog)
  local  x, ocolumn, defName, ncolor, xColor
  local  odesc, pa, pa_quick := {{ 'Kompletní seznam       ', ''                  }, ;
                                 { 'Neukonèené zakázky     ', 'cstavZakaz <> "U"' }  }

  *
  ::msg          := drgDialog:oMessageBar             // messageBar
  ::dm           := drgDialog:dataManager             // dataMabanager
  ::dc           := drgDialog:dialogCtrl              // dataCtrl
  ::df           := drgDialog:oForm                   // form
  ::brow         := drgDialog:dialogCtrl:oBrowse[1]
  *
  ::o_ndoklRozv  := ::dm:get('vyrZakpl->ndoklRozv' , .f.)
  ::o_nazevDop   := ::dm:get(' M->nazevDop'        , .f.)
  ::o_dNakladky  := ::dm:get('vyrZakpl->dNakladky' , .f.)
  ::o_cCasNaklad := ::dm:get('vyrZakpl->cCasNaklad', .f.)
  ::o_dVykladky  := ::dm:get('vyrZakpl->dVykladky' , .f.)
  ::o_cCasVyklad := ::dm:get('vyrZakpl->cCasVyklad', .f.)
  ::o_mTextRozv  := ::dm:get('vyrZakpl->mTextRozv' , .f.)


 if isObject( odesc := drgDBMS:getFieldDesc('vyrzak', 'cstavZakaz'))
    pa := listAsArray( odesc:values )

    for x := 1 to len(pa) step 1
      pa_it := listAsArray( pa[x], ':')

      aadd( pa_quick, { pa_it[2], 'cstavZakaz = "' +pa_it[1] +'"'} )
    next
  endif

  ::quickFiltrs:init( self, pa_quick, 'VýrZakázky' )

  vyrZakit->( ordsetFocus('ZAKIT_4'))
  vyrZakpl->( DbSetRelation( 'vyrZakit', {|| Upper(vyrZakpl->ccisZakazI)  },'Upper(vzrZakpl->ccisZakazI)'))
return


method PRO_vyrzakit_sle_in:drgDialogEnd( drgDialog)
  vyrZakit->( dbClearRelation())
return


method PRO_vyrzakit_sle_in:itemMarked(arowco,unil,oxbp)
  local ky, rest := ''

  ::ndoklRozv_org := vyrZakpl->ndoklRozv

  if isobject(oxbp)
    ky    := strZero(kalendar->nrok,4) +strZero(kalendar->ntyden,2)
  endif

*  vyrZakit->(dbseek( upper(vyrZakpl->ccisZakazI),,'ZAKIT_4'))
  vyrzak  ->(dbseek( upper(vyrzakit->ccisZakaz) ,,'VYRZAK1'))

*  if( isObject(oxbp), oxbp:refreshCurrent(), nil )
return self


method pro_vyrzakit_sle_in:postValidate(drgVar)
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  lOk    := .T., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F., ovar, recNo
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  if(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case left(field_name,6) = 'czkros' .and. changed
    lOk := ::pro_vyrzakit_sle_OSB_sel()

  case field_name = 'ndoklrozv' .and. changed
    if value = 0 .and. drgVar:prevValue <> 0
      ::o_nazevDop:set('')
      ::o_dNakladky:set( ctod('  .  .  '))
      ::o_cCasNaklad:set('')
      ::o_dVykladky:set( ctod('  .  .  '))
      ::o_cCasVyklad:set('')
      ::o_mTextRozv:set('')
    else
      lOk := ::pro_rozvozhd_sel()
    endif
  endcase
return lOk


method pro_vyrzakit_sle_in:pro_explsthd_scr(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT

  DRGDIALOG FORM 'PRO_EXPLSTHD_SCR' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
return


method pro_vyrzakit_sle_in:pro_vyrzakit_sle_OSB_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgGet := ::df:olastdrg
  local  name   := lower( drgGet:name )
  local  value  := upper( allTrim( drgGet:oVar:get()))
  *
  local  recCnt := 0, showDlg := .f., ok := .f.

  if isObject(drgDialog)
    showDlg := .t.
  else
    if .not. empty(value)
      osoby->( ordsetFocus('Osoby20')       , ;
               dbsetScope(SCOPE_BOTH, value), ;
               dbeval( { || recCnt++ } )    , ;
               dbclearScope()                 )

      showDlg := .not. (recCnt = 1)
           ok :=       (recCnt = 1)

      if( recCnt = 1, osoby->( dbseek( value,,'Osoby20')), nil )
    endif
  endif

  if showDlg
    DRGDIALOG FORM 'PRO_vyrzakit_sle_OSB_sel' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if .not. showDlg .or. (nexit != drgEVENT_QUIT)
    drgGet:oxbp:setData( osoby->czkrOsob )
  endif
return(nexit = drgEVENT_SELECT .or. ok)


method pro_vyrzakit_sle_in:pro_rozvozhd_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  ok := rozvozhd->(dbseek( ::o_ndoklRozv:value,,'ROZVOZHD01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'PRO_rozvozhd_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::o_ndoklRozv:changed()) .or. (nexit != drgEVENT_QUIT))
    ::o_ndoklRozv:set( rozvozhd->ndoklad )
    ::o_nazevDop:set(rozvozhd->cnazevDop )
*
** neví co chtìjí, radìji to tady necháme
*    ::o_crozvoz:set( rozvozhd->crozvoz        )
*    ::o_dNakladky:set( rozvozhd->dOdjezd      )
*    ::o_cCasNaklad:set( rozvozhd->cCasOdjezd  )
*    ::o_dVykladky:set( rozvozhd->dPrijezd     )
*    ::o_cCasVyklad:set( rozvozhd->cCasPrijezd )
  endif
return (nexit != drgEVENT_QUIT) .or. ok

*
**
method pro_vyrzakit_sle_in:ebro_saveEditRow(o_ebro)
  local  cky_org, cky_new, nstate := 0, ok := .f.

  cky_org := strZero(::ndoklRozv_org    ,10) +upper(vyrZakpl->ccisZakazI)
  cky_new := strZero(vyrZakpl->ndoklRozv,10) +upper(vyrZakpl->ccisZakazI)

  do case
  case ::ndoklRozv_org =  0 .and. vyrZakpl->ndoklRozv <> 0
    if rozvozhd->( dbseek(vyrZakpl->ndoklRozv,, 'ROZVOZHD01'))   // jen pro jistotu

      if rozvozit->( dbseek(cky_new,,'ROZVOZIT04'))              //   našel musíme modifikovat
        nstate := if( rozvozit->( sx_Rlock()), 1, 0 )
      else                                                       // nenašel musíme pøidat a modifikovat
        nstate := 2
      endif
    endif

  case ::ndoklRozv_org <> 0 .and. (::ndoklRozv_org <> vyrZakpl->ndoklRozv)
   if rozvozhd->( dbseek(vyrZakpl->ndoklRozv,, 'ROZVOZHD01'))    // jen pro jistotu

     if rozvozit->( dbseek(cky_org,,'ROZVOZIT04'))                //   našel musíme modifikovat
       nstate := if( rozvozit->( sx_Rlock()), 1, 0 )
     else                                                         // nenašel musíme pøidat a modifikovat
       nstate := 2
     endif
   endif
  endcase

  if nstate <> 0
    if( nstate = 2, mh_copyFld( 'rozvozhd', 'rozvozit', .t. ), nil )

    rozvozit->ndoklad    := vyrZakpl->ndoklRozv
    rozvozit->cCisZakazI := vyrZakpl->cCisZakazI
    rozvozit->cNazDodavk := vyrZakit->cnazevZak1
    rozvozit->nCisFirmy  := vyrZakpl->ncisFirDoa
    rozvozit->cNazFirmy  := vyrZakpl->cnazevDoa
    rozvozit->dNakladky  := vyrZakpl->dNakladky
    rozvozit->cCasNaklad := vyrZakpl->cCasNaklad
    rozvozit->dVykladky  := vyrZakpl->dVykladky
    rozvozit->cCasVyklad := vyrZakpl->cCasVyklad

  else

    if rozvozit->( dbseek(cky_org,,'ROZVOZIT04'))                //   našel musíme modifikovat
      if rozvozit->( sx_RLock())

        if  vyrZakpl->ndoklRozv = 0
          rozvozit->(dbdelete())
        else
          rozvozit->dNakladky  := vyrZakpl->dNakladky
          rozvozit->cCasNaklad := vyrZakpl->cCasNaklad
          rozvozit->dVykladky  := vyrZakpl->dVykladky
          rozvozit->cCasVyklad := vyrZakpl->cCasVyklad
        endif
      endif
    endif
  endif

  rozvozit->(dbUnlock(), dbCommit())

  *
  ** zpìtná modifikace vyrZakit
  if vyrZakit->( sx_RLock())

    vyrZakit->dOdvedZaka := vyrZakpl->dOdvedZaka
    vyrZakit->dMozOdvZak := vyrZakpl->dMozOdvZak
    vyrZakit->dSkuOdvZak := vyrZakpl->dSkuOdvZak
    vyrZakit->nRozmP_del := vyrZakpl->nRozmP_del
    vyrZakit->nRozmP_sir := vyrZakpl->nRozmP_sir
    vyrZakit->nRozmP_vys := vyrZakpl->nRozmP_vys
    vyrZakit->cRozmP_MJ  := vyrZakpl->cRozmP_MJ

    vyrZakit->(dbUnlock(), dbCommit())
  endif
return
