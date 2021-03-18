#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"



#define m_files  { 'ucetsys' ,'uzavisoz','dphdada','dph_2001','dph_2004'            , ;
                   'c_typpoh','c_bankuc','c_meny'  ,'c_vykdph'                      , ;
                   'banvyphd','banvypit','pokladhd','pokladit','range_hd','range_it', ;
                   'datkomhd','pokladms'                                            , ;
                   'pvphead' ,'pvpitem'                                             , ;
                   'ucetpol' ,'parvyzal','dodlstit','vyrzak'  ,'objitem' ,'cenzboz'   }



*
** CLASS for PRO_poklhd_SCR ***************************************************
CLASS PRO_poklhd_SCR FROM drgUsrClass, FIN_finance_IN, PRO_poklhd_doplnujici_in
exported:
  var     lnewRec, oinf, on_vykDph
  method  init, drgDialogStart, tabSelect, itemMarked
  *
  method  fin_pvphead

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, brow
  method  postDelete
ENDCLASS


method pro_poklhd_scr:Init(parent)
  local  pa, ctypEdit := SYSCONFIG('PRODEJ:cTYPEDIT')

  ::drgUsrClass:init(parent)

  pa := listAsArray(ctypEdit)
  ::on_vykDph := if( len(pa) >= 4, pa[4], '1' )  // 0 - negeneruje vykDph, 1 - generuje vykDph
  ::lnewRec   := .f.
  ::tabnum    := 1

  * základní soubory
  ::openfiles(m_files)

  drgDBMS:open('pvphead',,,,,'pvp_head')
  drgDBMS:open('pvpitem',,,,,'pvp_item')

  ** likvidace
  ::FIN_finance_in:typ_lik := 'pok_r'

  ** info
  ::oinf := fin_datainfo():new('POKLHD')
RETURN self


METHOD pro_poklhd_scr:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse

  *
  ** doplòující nabídka
  ::PRO_poklhd_doplnujici_in:init(drgDialog)
RETURN


METHOD pro_poklhd_scr:tabSelect(oTabPage,tabnum)
 local lrest := (tabNum = 2)

  ::tabnum := tabnum
  ::itemMarked()

  if(lrest,::brow[3]:oxbp:refreshAll(),nil)
RETURN .T.


METHOD pro_poklhd_scr:itemMarked()
  local  cky
  *
  cky := POKLHD->nCISFAK
  POKLIT->(AdsSetOrder('POKLIT1'), dbSetScope(SCOPE_BOTH, cky), DbGoTop())

  cky := Upper(POKLHD->cDENIK) +StrZero(POKLHD->nCISFAK,10)
  ucetpol ->(DbSetScope(SCOPE_BOTH,cky), DbGoTop())
  vykdph_i->(dbsetscope(SCOPE_BOTH,cky), DbGoTop())

  pokladMs->( dbseek( poklHd  ->nPokladna ,, 'POKLADM1' ))
  datkomHd->( dbseek( pokladms->cidDATkomE,, 'DATKOMH01'))

  c_typpoh->(dbseek(upper(poklhd->culoha) +upper(poklhd->ctypdoklad) +upper(poklhd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
return self


method pro_poklhd_scr:postDelete()
  local  oinf := fin_datainfo():new('POKLHD'), nsel, nodel := .f.

  if poklhd->ncisfak <> 0 .and. (oinf:danuzav() = 0 .and. oinf:ucuzav() = 0 .and. oinf:stavEet() <> 556) // 556 - zelená odeslán do EET )
    nsel := ConfirmBox( ,'Požadujete zrušit paragon _' +alltrim(str(poklhd->ndoklad)) +'_', ;
                         'Zrušení paragonu ...' , ;
                          XBPMB_YESNO                    , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES

      pro_poklhd_cpy(self)
      nodel := .not. pro_poklhd_del(self)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Paragon _' +alltrim(str(poklhd->ndoklad)) +'_' +' nelze zrušit ...' +CRLF +CRLF + ;
                 '    ... NELZE ZRUŠit DOKLAD ...'                                              , ;
                 'Zrušení paragonu ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::itemMarked()
  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel


*
**
method pro_poklhd_scr:fin_pvphead(drgDialog)
  local  odialog, nexit, m_filter

  m_filter := format("ncisfak = %%",{poklhd->ndoklad})

  if(select('pvphead') = 0, drgDBMS:open('pvphead'), nil)
  pvphead->(ads_setAof(m_filter), dbgotop())

  oDialog := drgDialog():new('fin_fakvyshd_pvphead',drgDialog)
  odialog:create(,,.T.)

  pvphead->(ads_clearAof())

  odialog:destroy()
  odialog := nil
return