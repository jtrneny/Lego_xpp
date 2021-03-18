#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Gra.ch"
#include "dbstruct.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*
** CLASS for HIM_pozemky_prevPoz ***********************************************
CLASS HIM_pozemky_prevPoz FROM drgUsrClass
exported:

  method  init, drgDialogStart
  method  postValidate

  method  save_prevPoz

  inline method drgDialogInit(drgDialog)
   _clearEventLoop()
    postAppEvent(drgEVENT_EDIT,,,drgDialog:dialog)
  return self

 * pozemkyW
  inline access assign method nazevMaj() var nazevMaj      // název majeku
    majSW->( dbseek( pozemkyW->ninvCis,,'MAJ02'))
    return majSW->cnazev

hidden:
* sys
  var     msg, dm, dc, df
  var     hd_file, it_file
  var     obtn_save_prevPoz, obtn_cmp_Marked
ENDCLASS


method HIM_pozemky_prevPoz:init(parent)
  local  cf := "cku_Kod = '%%' and nlistvlast <> %%", filter

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('maj')
  drgDBMS:open('maj',,,,,'majSW')
  drgDBMS:open('pozemky' )
  drgDBMS:open('pozemkit')

  drgDBMS:open('c_listvl' )
  drgDBMS:open('c_listvl',,,,,'c_newLv')
  *
  (::hd_file      := 'pozemkyW' )

  ** tmp soubory **
  drgDBMS:open('POZEMKYw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  mh_copyFld( 'POZEMKY', 'POZEMKYw', .t., .t. )
  *
  ** omezíme c_newLV na pozemky->cku_kod a vyhodíme nlistVlast na kterém stojí
  filter := format(cf, {pozemky->cku_kod, pozemky->nlistVlast} )
  c_listvl->( ads_setAof(filter), dbgoTop() )
return self


method HIM_pozemky_prevPoz:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers
  local  x, odrg, groups, name, tipText
  local  acolors  := MIS_COLORS, pa_groups, nin

  ::msg             := drgDialog:oMessageBar             // messageBar
  ::dm              := drgDialog:dataManager             // dataManager
  ::dc              := drgDialog:dialogCtrl              // dataCtrl
  ::df              := drgDialog:oForm                   // form
  *
*  ::msg:can_writeMessage := .f.
*  ::msg:msgStatus:paint  := { |aRect| ::info_in_msgStatus(aRect) }
  *
  for x := 1 to len(members) step 1
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)


    if odrg:className() = 'drgText' .and. .not. empty(groups)
      pa_groups := ListAsArray(groups)

      * XBPSTATIC_TYPE_RAISEDBOX           12
      * XBPSTATIC_TYPE_RECESSEDBOX         13

      if odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13
        odrg:oxbp:setColorBG(GRA_CLR_BACKGROUND)
      endif

      if ( nin := ascan(pa_groups,'SETFONT') ) <> 0
        odrg:oXbp:setFontCompoundName(pa_groups[nin+1])
      endif

      if 'GRA_CLR' $ atail(pa_groups)
        if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
          odrg:oXbp:setColorFG(acolors[nin,2])
        endif
      else
        if isMemberVar(odrg, 'oBord') .and. ( odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13)
          odrg:oXbp:setColorFG(GRA_CLR_BLUE)
        else
          odrg:oXbp:setColorFG(GRA_CLR_DARKGREEN)
        endif
      endif
    endif

    if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
      odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
    endif

    if odrg:ClassName() = 'drgStatic' .and. odrg:oxbp:type = XBPSTATIC_TYPE_ICON
*      ::sta_activeBro := odrg
    endif

    if odrg:ClassName() = 'drgPushButton'
      if isCharacter( odrg:event )
        do case
        case odrg:event = 'save_prevPoz'  ;  ::obtn_save_prevPoz := odrg
        endcase

      elseif isNumber( odrg:event )
        odrg:oxbp:setFontCompoundName('10.Arial CE Bold')
        odrg:oxbp:SetGradientColors( { 0,3 } )  // {0,5} -zelená, {0,3} - èervená, {0,7} - žlutá
      endif
    endif
  next
  *
  ::obtn_save_prevPoz:oxbp:setFontCompoundName("10.Arial Bold Italic")
  ::obtn_save_prevPoz:oxbp:disable()

  ::df:setNextFocus( ::hd_file +'->nnewLv',, .T. )
return self


METHOD HIM_pozemky_prevPoz:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)
  *

  do case
  * kontroly na hlavièce pozemky
  case( file = ::hd_file )
    do case
    case( name = ::hd_file +'->nnewlv' )
      ok := ( .not. empty(value) .and. c_listvl->( dbseek( value,,'C_LISTVL01' )) )
    endcase
  endcase

  * na pozemkyW ukládme vždy
  if('pozemkyw' $ name .and. ok, drgVAR:save(),nil)
  if( ok, ( ::obtn_save_prevpoz:oxbp:enable(), SetAppFocus(::obtn_save_prevPoz:oxbp) ), nil )
return ok


method HIM_pozemky_prevPoz:save_prevPoz()
  local  anPoz  := {}
  local  mainOk := .t., nrecOr
  *
  local  csid_pozemky := '', cpozemky

  pozemkyW->nlistVlast := pozemkyW->nnewLv
  pozemkyW->( dbcommit())

    mh_copyFld( 'pozemkyW', 'pozemky' , .t., .f. )
    mh_copyFld( 'pozemkyW', 'pozemkit', .t., .f. )
    pozemkit->nPOZEMKY  := pozemky->sID

  pozemky->(dbunlock(), dbcommit())
    pozemkit->(dbunlock(), dbcommit())

  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
return self


