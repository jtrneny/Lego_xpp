#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys' ,'uzavisoz','dphdada','dph_2001','dph_2004' , ;
                   'uctdokhd','uctdokit'                                   }


function uct_uctdokit_bc(typ)
  local typObratu := if(typ = 'w', uctdokhdw->ntypobratu, uctdokhd->ntypobratu)
return if(typObratu = 1, 'DAL', 'MD ')


*
** CLASS for UCT_uctdokhd_SCR **************************************************
CLASS UCT_uctdokhd_SCR FROM drgUsrClass, FIN_finance_IN
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

method UCT_uctdokhd_SCR:init(parent)
*-  LOCAL filter := FORMAT("upper(cdenik) = '%%'", {SYSCONFIG('FINANCE:cDENIKFIDO')})

  ::drgUsrClass:init(parent)
  ::lnewRec  := .f.
  ::tabnum   := 1

  * základní soubory
  ::openfiles(m_files)

  ** likvidace úèetní doklad se nelikviduje, typ_lik je použit pro RV_dph **
  ::FIN_finance_in:typ_lik := 'ucd'
  ::oinf  := fin_datainfo():new('UCTDOKHD')

*-  uctdokhd->(ads_setAof(filter))
return self


method UCT_uctdokhd_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
  ::dm   := drgDialog:dataManager
return


method UCT_uctdokhd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
return .t.


method UCT_uctdokhd_SCR:itemMarked()
  local  cky := Upper(UCTDOKHD ->cDENIK) +StrZero(UCTDOKHD ->nDOKLAD,10)

  do case
  case ::tabnum = 1
    UCTDOKIT ->( dbSetScope(SCOPE_BOTH, cky), DbGoTop())
    ::brow[2]:refresh(.T.)
    ::dm:refresh()
  case ::tabnum = 2
    UCETPOL ->(DbSetScope(SCOPE_BOTH,cky), DbGoTop())
    ::brow[3]:refresh(.T.)
  endcase
return self


method UCT_uctdokhd_SCR:drgDialogEnd()
return


method UCT_uctdokhd_SCR:postDelete()
  local  oinf := fin_datainfo():new('UCTDOKHD'), nsel, nodel := .f.

  if oinf:ucuzav() = 0
    nsel := ConfirmBox( ,'Požadujete zrušit úèetní doklad _' +alltrim(str(uctdokhd->ndoklad)) +'_', ;
                         'Zrušení úèetního dokladu ...' , ;
                          XBPMB_YESNO                   , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES
      uct_uctdokhd_cpy(self)
      nodel := .not. uct_uctdokhd_del()
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Úèetní doklad _' +alltrim(str(uctdokhd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení úèetního dokladu ...' , ;
                 XBPMB_CANCEL                  , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel