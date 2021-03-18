#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"



#define m_files  { 'ucetsys' ,'uzavisoz','dphdada','dph_2001','dph_2004'            , ;
                   'c_typpoh','c_bankuc','c_meny'  ,'c_staty'                       , ;
                   'banvyphd','banvypit','pokladhd','pokladit'                      , ;
                   'ucetpol' ,'parvyzal','dodlstpit','vyrzak'  ,'objvysit' ,'cenzboz'   }


*
** CLASS for PRO_objitem_SCR **************************************************
CLASS NAK_objvysit_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, tabSelect, itemMarked


  inline access assign method cnazMeny() var cnazMeny
    c_meny->( dbSeek( upper(objvyshd->czkratMenZ),,'C_MENY1'))
    return c_meny->cnazMeny

  inline access assign method cnazevStat() var cnazevStat
    c_staty->(dbSeek( upper( objvyshd->czkratStat),,'C_STATY1'))
    return c_staty->cnazevStat

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
ENDCLASS


METHOD NAK_objvysit_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum := 1

  * základní soubory
  ::openfiles(m_files)

  ** likvidace
**  ::FIN_finance_in:typ_lik := 'poh'

  ** info
**  ::oinf := fin_datainfo():new('FAKVYSHD')
RETURN self


METHOD NAK_objvysit_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
RETURN


METHOD NAK_objvysit_SCR:tabSelect(oTabPage,tabnum)
 local lrest := (tabNum = 2)

  ::tabnum := tabnum
  ::itemMarked()

*-  if(lrest,::brow[3]:oxbp:refreshAll(),nil)
RETURN .T.


method NAK_objvysit_scr:itemMarked()
*  local  cKy := upper(objitem->ccislobint) +strZero(objitem->ncislPolOb,5)

  objvyshd ->( dbseek( objvysit->ndoklad,, 'OBJDODH6'))
//  fakvysit->(AdsSetOrder('FVYSIT2'), DbSetScope(SCOPE_BOTH,cky), DbGoTop() )
return self
