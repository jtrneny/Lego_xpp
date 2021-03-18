#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for FIN_banvypit_SCR **************************************************
CLASS FIN_banvypit_SCR FROM drgUsrClass
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, tabSelect, itemMarked

  * hd_crd
  inline access assign method naztypPoh_hd() var naztypPoh_hd
    local cky := upper(banvyphd->culoha) +upper(banvyphd->ctypdoklad) +upper(banvyphd->ctyppohybu)

    c_typpoh->(dbseek(cky,,'C_TYPPOH05'))
  return c_typpoh->cnaztyppoh

   * browColumn - IT
  inline access assign method err_imp_it() var err_imp_it
    return if( banvypit->nerr_imp = 1, MIS_ICON_ERR, 0 )


   * browColumn - HD
  inline access assign method err_imp_hd() var err_imp_hd
    return if( banvyphd->nerr_imp = 1, MIS_ICON_ERR, 0 )

  inline access assign method veProspech_hd() var veProspech_hd
    return if(::istuz, (::hd_file)->nprijem, (::hd_file)->nprijemz)

  inline access assign method naVrub_hd()     var naVrub_hd
    return if(::istuz, (::hd_file)->nvydej, (::hd_file)->nvydejz)

  inline method zaklMena()
    default ::zaklMena to SysConfig('Finance:cZaklMena')
  return ::zaklMena

  inline access assign method istuz() var istuz
    local zkrMeny := (::hd_file)->czkratMeny
  return Equal(::zaklMena(), zkrMeny)


  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local msg := ::drgDialog:oMessageBar

    do case
    case(nEvent = xbeBRW_ItemMarked)
      msg:WriteMessage(,0)
      return .f.

    case nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_DELETE
      return .t.

    case nEvent = drgEVENT_DELETE
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, brow
  var     hd_file, zaklMena
ENDCLASS


METHOD FIN_banvypit_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1
  ::hd_file := 'banvyphd'

  * základní soubory
  drgDBMS:open('c_typpoh')

  ** info
  ::oinf := fin_datainfo():new('BANVYPHD')
RETURN self


METHOD FIN_banvypit_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
*-  FAKVYSHD ->( DBGoBottom())
RETURN


METHOD FIN_banvypit_SCR:tabSelect(oTabPage,tabnum)
 local lrest := (tabNum = 2)

  ::tabnum := tabnum
  ::itemMarked()

  if(lrest,::brow[3]:oxbp:refreshAll(),nil)
RETURN .T.


METHOD FIN_banvypit_SCR:itemMarked()
  local  cky

  banvyphd->( AdsSetOrder('BANVYP_1'), dbsetScope(SCOPE_BOTH,banvypit->ndoklad), dbgoTop())

  cky := upper(banvyphd->cdenik) +strZero(banvyphd->ndoklad,10)
  ucetpol ->(DbSetScope(SCOPE_BOTH,cky), DbGoTop())

  c_typpoh->(dbseek(upper(banvyphd->culoha) +upper(banvyphd->ctypdoklad) +upper(banvyphd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
return self