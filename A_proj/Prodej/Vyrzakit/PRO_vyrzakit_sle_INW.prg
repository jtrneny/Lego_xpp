#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "gra.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'osoby', 'kalendar', 'vyrzak', 'vyrzakit', 'explsthd', 'explstit' }

*
** CLASS for PRO_vyrzakit_sle_INW *********************************************
CLASS PRO_vyrzakit_sle_inw FROM drgUsrClass, quickFiltrs, FIN_finance_IN
exported:
  var     lnewRec
  method  init, drgDialogStart, itemMarked
  method  postvalidate

  method  pro_explsthd_scr
  method  pro_vyrzakit_sle_OSB_sel

  * položky - bro
  * rozmìry výrobní/ pøepravní
  inline access assign method rozm_column() var rozm_column
    local  colum :=  'výrobní    ( ' + str( vyrZakit->nRozm_del, 8, 2) +' / '   + ;
                                       str( vyrZakit->nRozm_sir, 8, 2) +' / '   + ;
                                       str( vyrZakit->nRozm_vys, 8, 2) +' ) v ' + ;
                                            vyrZakit->cRozm_MJ                   + CRLF + ;
                     'pøepravní ( '  + str( vyrZakit->nRozmP_del, 8, 2) +' / '  + ;
                                       str( vyrZakit->nRozmP_sir, 8, 2) +' / '  + ;
                                       str( vyrZakit->nRozmP_vys, 8, 2) +' ) v '+ ;
                                            vyrZakit->cRozmP_MJ
  return colum

  * obch
  inline access assign method obch_column() var obch_column
    local  colum :=       vyrZakpl->cjmeOsOdp   + CRLF + ;
                     dtoc(vyrZakpl->dzapis)     + CRLF + ;
                     dtoc(vyrZakpl->dodvedZaka) + CRLF + ;
                     dtoc(vyrZakpl->dskuOdvZak)
  return colum

  * tpv
  inline access assign method tpv_column() var tpv_column
    local  colum  := vyrZakpl->czkrOs_Tpv                   +CRLF + ;
                     'plán od ' +dtoc(vyrZakpl->dzahPL_Tpv)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonPL_Tpv) +CRLF + ;
                     'skut od ' +dtoc(vyrZakpl->dzahSK_Tpv)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonSK_Tpv)
  return colum

  * svarna
  inline access assign method sva_column() var sva_column
    local  colum  := vyrZakpl->czkrOs_Sva                   +CRLF + ;
                     'plán od ' +dtoc(vyrZakpl->dzahPL_Sva)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonPL_Sva) +CRLF + ;
                     'skut od ' +dtoc(vyrZakpl->dzahSK_Sva)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonSK_Sva)
  return colum

  * lakovna
  inline access assign method lak_column() var lak_column
    local  colum  := vyrZakpl->czkrOs_Lak                   +CRLF + ;
                     'plán od ' +dtoc(vyrZakpl->dzahPL_Lak)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonPL_Lak) +CRLF + ;
                     'skut od ' +dtoc(vyrZakpl->dzahSK_Lak)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonSK_Lak)
  return colum

  * montáž
  inline access assign method mon_column() var mon_column
    local  colum  := vyrZakpl->czkrOs_Mon                   +CRLF + ;
                     'plán od ' +dtoc(vyrZakpl->dzahPL_Mon)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonPL_Mon) +CRLF + ;
                     'skut od ' +dtoc(vyrZakpl->dzahSK_Mon)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonSK_Mon)
  return colum

  * elektro
  inline access assign method ele_column() var ele_column
    local  colum  := vyrZakpl->czkrOs_Ele                   +CRLF + ;
                     'plán od ' +dtoc(vyrZakpl->dzahPL_Ele)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonPL_Ele) +CRLF + ;
                     'skut od ' +dtoc(vyrZakpl->dzahSK_Ele)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonSK_Ele)
  return colum

  * kooperace
  inline access assign method koo_column() var koo_column
    local  colum  := vyrZakpl->czkrOs_Koo                   +CRLF + ;
                     'plán od ' +dtoc(vyrZakpl->dzahPL_Koo)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonPL_Koo) +CRLF + ;
                     'skut od ' +dtoc(vyrZakpl->dzahSK_Koo)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonSK_Koo)
  return colum

  * kontrola jakosti
  inline access assign method kon_column() var kon_column
    local  colum  := vyrZakpl->czkrOs_Kon                   +CRLF + ;
                     'plán od ' +dtoc(vyrZakpl->dzahPL_Kon)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonPL_Kon) +CRLF + ;
                     'skut od ' +dtoc(vyrZakpl->dzahSK_Kon)       + ;
                     ' do '     +dtoc(vyrZakpl->dkonSK_Kon)
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
        ocolumn:type := XBPCOL_TYPE_MULTILINETEXT
      endif

      ocolumn:DataAreaLayout[XBPCOL_DA_ROWHEIGHT] := 50

      ocolumn:HeaderLayout[XBPCOL_HFA_HEIGHT]     := 30
      
      ocolumn:heading:type := XBPCOL_TYPE_MULTILINETEXT
      ocolumn:HeaderLayout[XBPCOL_HFA_CAPTION ] := allTrim(oColumn:heading:referenceString) +CRLF +allTrim( str(x))


*       ocolumn:DataAreaLayout[XBPCOL_DA_CELLHEIGHT]   := 10
*       ocolumn:dataArea:maxRow := 1
*      oColumn:heading:configure()
      oColumn:configure()
    next
    oBro:configure()
    return

hidden:
  var     msg, dm, dc, df, ab, brow

  inline method s_scope()
    local ky := strZero(kalendar->nrok,4) +strZero(kalendar->ntyden,2)

    vyrzai_s->(AdsSetOrder('ZAKIT_6'),dbsetScope(SCOPE_BOTH,ky),dbgotop())
  return nil
ENDCLASS


method PRO_vyrzakit_sle_inw:init(parent)
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


method PRO_vyrzakit_sle_inw:drgDialogStart(drgDialog)
  local  x, ocolumn, defName, ncolor, xColor
  local  odesc, pa, pa_quick := {{ 'Kompletní seznam       ', ''            }}
  *
  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  ::brow     := drgDialog:dialogCtrl:oBrowse[1]

/*
  for x := 1 TO ::brow:oXbp:colcount
    ocolumn := ::brow:oXbp:getColumn(x)
    defName := upper( ocolumn:defColum.defName)
    ncolor  := if( '_TPV' $ defName, 1, ;
                 if( '_SVA' $ defName, 2, ;
                   if( '_LAK' $ defName, 3, ;
                     if( '_MON' $ defName, 4, 0 ))))
    do case
    case ncolor = 1
      xColor := GraMakeRGBColor( { 128,255,128 } )
      ocolumn:dataArea:setColorBG( xColor )              // XBPSYSCLR_BACKGROUND  )
      ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR] := xColor  // XBPSYSCLR_BACKGROUND

    case ncolor = 2
      ocolumn:dataArea:setColorBG( XBPSYSCLR_HOTLIGHTBGND  )
      ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR] := XBPSYSCLR_HOTLIGHTBGND

    case ncolor = 3
      ocolumn:dataArea:setColorBG( GRA_CLR_DARKCYAN  )
      ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR] := GRA_CLR_DARKCYAN

    case ncolor = 4
      xColor := GraMakeRGBColor( { 255,128,128 } )
      ocolumn:dataArea:setColorBG( xColor )               // GRA_CLR_RED  )
      ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR] := xColor   // GRA_CLR_RED

    endcase
  next
*/
  if isObject( odesc := drgDBMS:getFieldDesc('vyrzak', 'cstavZakaz'))
    pa := listAsArray( odesc:values )

    for x := 1 to len(pa) step 1
      pa_it := listAsArray( pa[x], ':')

      aadd( pa_quick, { pa_it[2], 'cstavZakaz = "' +pa_it[1] +'"'} )
    next
  endif

  ::quickFiltrs:init( self, pa_quick, 'VýrZakázky' )
  ::fuj( ::brow:oxbp )
return


method PRO_vyrzakit_sle_inw:itemMarked(arowco,unil,oxbp)
  local ky, rest := ''


  if isobject(oxbp)
    ky    := strZero(kalendar->nrok,4) +strZero(kalendar->ntyden,2)
*    vyrzakit->(AdsSetOrder('ZAKIT_6'),dbsetScope(SCOPE_BOTH,ky),dbgotop())
  endif

  vyrZakit->(dbseek( upper(vyrZakpl->ccisZakazI),,'ZAKIT_4'))
  vyrzak  ->(dbseek( upper(vyrzakit->ccisZakaz) ,,'VYRZAK1'))
return self


method pro_vyrzakit_sle_inw:postValidate(drgVar)
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
  endcase
return lOk


method pro_vyrzakit_sle_inw:pro_explsthd_scr(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT

  DRGDIALOG FORM 'PRO_EXPLSTHD_SCR' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
return


method pro_vyrzakit_sle_inw:pro_vyrzakit_sle_OSB_sel(drgDialog)
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