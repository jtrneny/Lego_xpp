#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"

*
**
#include "Dmlb.ch"
#include "directry.ch"
**
*

// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys' ,'uzavisoz','dphdada','dph_2001','dph_2004' , ;
                   'ucetdohd','ucetdoit'                                   }


function fin_ucetdoit_bc(typ)
  local typObratu := if(typ = 'w', ucetdohdw->ntypobratu, ucetdohd->ntypobratu)
return if(typObratu = 1, 'DAL', 'MD ')


*
** CLASS for FIN_ucetdoh_SCR **************************************************
CLASS FIN_ucetdohd_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, tabSelect, itemMarked, drgDialogEnd, postDelete

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, brow, dm
ENDCLASS

METHOD FIN_ucetdohd_SCR:init(parent)
  LOCAL filter := FORMAT("upper(cdenik) = '%%'", {SYSCONFIG('FINANCE:cDENIKFIDO')})

  ::drgUsrClass:init(parent)
  ::lnewRec  := .f.
  ::tabnum   := 1

  * základní soubory
  ::openfiles(m_files)

  ** likvidace úèetní doklad se nelikviduje, typ_lik je použit pro RV_dph **
  ::FIN_finance_in:typ_lik := 'ucd'
  ::oinf  := fin_datainfo():new('UCETDOHD')

  ucetdohd->(ads_setAof(filter))
RETURN self


METHOD FIN_ucetdohd_SCR:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse
  ::dm   := drgDialog:dataManager
RETURN


METHOD FIN_ucetdohd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
RETURN .T.


method FIN_ucetdohd_SCR:itemMarked()
  local  cky := Upper(UCETDOHD ->cDENIK) +StrZero(UCETDOHD ->nDOKLAD,10)

  do case
  case ::tabnum = 1
    UCETDOIT ->( dbSetScope(SCOPE_BOTH, cky), DbGoTop())
    ::brow[2]:refresh(.T.)
    ::dm:refresh()
  case ::tabnum = 2
    UCETPOL ->(DbSetScope(SCOPE_BOTH,cky), DbGoTop())
    ::brow[3]:refresh(.T.)
  case ::tabnum = 3
     vykdph_i->(dbsetscope(SCOPE_BOTH,cky), DbGoTop())
    ::brow[4]:refresh(.T.)
  endcase
return self


method FIN_ucetdohd_SCR:drgDialogEnd()
return


method FIN_ucetdohd_SCR:postDelete()
  local  oinf := fin_datainfo():new('UCETDOHD'), nsel, nodel := .f.

  if oinf:danuzav() = 0 .and. oinf:ucuzav() = 0
    nsel := ConfirmBox( ,'Požadujete zrušit úèetní doklad _' +alltrim(str(ucetdohd->ndoklad)) +'_', ;
                         'Zrušení úèetního dokladu ...' , ;
                          XBPMB_YESNO                   , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES
      fin_ucetdohd_cpy(self)
      nodel := .not. fin_ucetdohd_del()
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Úèetní doklad _' +alltrim(str(ucetdohd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení úèetního dokladu ...' , ;
                 XBPMB_CANCEL                  , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel