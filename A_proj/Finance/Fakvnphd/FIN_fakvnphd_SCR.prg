#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


#define  m_files   { 'c_uctosn'                                   , ;
                     'dodlstit', 'vyrzak'  , 'vyrzakit', 'cenzboz', ;
                     'fakprihd', 'fakvyshd'                         }


*
** CLASS for FIN_fakvnphd_SCR **************************************************
** dle hlavièek vnitroFaktur
CLASS FIN_fakvnphd_SCR FROM drgUsrClass, FIN_finance_IN
EXPORTED:
  var     oinf, lnewRec
  method  postDelete

  INLINE ACCESS ASSIGN METHOD dodavatel_ns() VAR dodavatel_ns  // dodavatel z cNAZPOL1
    cNAZPOL1 ->( DbSeek( UPPER(FAKVNPHD ->cNAZPOL1),,'CNAZPOL1'))
    RETURN cNAZPOL1 ->cNAZEV
  *
  INLINE ACCESS ASSIGN METHOD odberatel_ns() VAR odberatel_ns  // odberatel z cNAZPOL1
    cNAZPOL1 ->( DbSeek( UPPER(FAKVNPHD ->cNAZPOL1O),,'CNAZPOL1'))
    RETURN cNAZPOL1 ->cNAZEV

  METHOD  init, drgDialogStart, tabSelect, itemMarked

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.


HIDDEN:
  VAR  tabnum, brow, dodavatel_str, comboBox
ENDCLASS


METHOD FIN_fakvnphd_SCR:init(parent)
  ::drgUsrClass:init(parent)

  ::tabnum  := 1
  ::lnewRec := .f.

  * základní soubory
  ::openfiles(m_files)

  // PRO INFO //
  drgDBMS:open('DPH_2004')
  drgDBMS:open('DPHDATA' )
  drgDBMS:open('UCETSYS' )
  drgDBMS:open('UZAVISOZ')
  drgDBMS:open('cNAZPOL1')

  ** likvidace
  ::FIN_finance_in:typ_lik := 'vnp_f'

  ** info
  ::oinf := fin_datainfo():new('FAKVNPHD')
RETURN self


METHOD FIN_fakvnphd_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
  FAKVNPHD ->( DBGoBottom())
RETURN


METHOD FIN_fakvnphd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
RETURN .T.


METHOD FIN_fakvnphd_SCR:itemMarked()
  LOCAL  cky := StrZero(FAKVNPHD ->nCISFAK,10)

  ::dodavatel_str := FAKVNPHD ->cNAZPOL1

  cky := StrZero(FAKVNPHD ->nCISFAK,10)
  FAKVNPIT ->( dbSetScope(SCOPE_BOTH, cky), DbGoTop())

  cky := Upper(FAKVNPHD ->cDENIK) +StrZero(FAKVNPHD ->nCISFAK,10)
  UCETPOL ->(DbSetScope(SCOPE_BOTH,cky), DbGoTop())

  /*
  do case
  case ::tabnum = 1
    cky := StrZero(FAKVNPHD ->nCISFAK,10)
    FAKVNPIT ->( dbSetScope(SCOPE_BOTH, cky), DbGoTop())
  case ::tabnum = 2
    cky := Upper(FAKVNPHD ->cDENIK) +StrZero(FAKVNPHD ->nCISFAK,10)
    UCETPOL ->(DbSetScope(SCOPE_BOTH,cky), DbGoTop())
    ::brow[3]:refresh(.T.)
  endcase
  */
RETURN SELF


method FIN_fakvnphd_SCR:postDelete()
  local  oinf := fin_datainfo():new('FAKVNPHD'), nsel, nodel := .f.

  if oinf:canBe_Del()
    nsel := ConfirmBox( ,'Požadujete zrušit vnitro_Podnikovou fakturu  _' +alltrim(str(fakVnphd->ndoklad)) +'_', ;
                         'Zrušení vnitro_Podnikové faktury ...' , ;
                          XBPMB_YESNO                           , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES

      FIN_fakVnphd_cpy(self)
      nodel := .not. FIN_fakVnphd_del(self)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Vnitro_podnikovou fakturu _' +alltrim(str(fakVnphd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení vnitro_Podnikové faktury ...' , ;
                 XBPMB_CANCEL                           , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel



*
** CLASS for FIN_fakvnphd_dod_SCR **********************************************
** dle støedisek dodavatele
CLASS FIN_fakvnphd_dod_SCR FROM drgUsrClass
EXPORTED:
  var  oinf

  INLINE ACCESS ASSIGN METHOD dodavatel_ns() VAR dodavatel_ns  // dodavatel z cNAZPOL1
    cNAZPOL1a ->( DbSeek( UPPER(FAKVNPHD ->cNAZPOL1),,'CNAZPOL1'))
    RETURN cNAZPOL1a ->cNAZEV
  *
  INLINE ACCESS ASSIGN METHOD odberatel_ns() VAR odberatel_ns  // odberatel z cNAZPOL1
    cNAZPOL1a ->( DbSeek( UPPER(FAKVNPHD ->cNAZPOL1O),,'CNAZPOL1'))
    RETURN cNAZPOL1a ->cNAZEV

  METHOD  init, drgDialogStart, tabSelect, itemMarked

  inline method itemMarked_hd()
    local  cky

    cky := strZero(fakvnpHd ->ncisFak,10)
    fakvnpIt ->( dbSetScope(SCOPE_BOTH, cky), DbGoTop())

    cky := upper(fakvnpHd->cdenik) +strZero(fakvnpHd->ncisFak,10)
    ucetpol ->( dbsetScope(SCOPE_BOTH,cky), dbgoTop())

RETURN SELF

HIDDEN:
  VAR  tabnum, brow, dodavatel_str, comboBox
ENDCLASS


METHOD FIN_fakvnphd_dod_SCR:init(parent)
  ::drgUsrClass:init(parent)

  ::tabnum := 1

  // PRO INFO //
  drgDBMS:open('DPH_2004')
  drgDBMS:open('DPHDATA' )
  drgDBMS:open('UCETSYS' )
  drgDBMS:open('UZAVISOZ')
  drgDBMS:open('cNAZPOL1')
  drgDBMS:open('cnazPOL1',,,,, 'cnazPOL1a' )

  ** info
  ::oinf := fin_datainfo():new('FAKVNPHD')
RETURN self


METHOD FIN_fakvnphd_dod_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
//  FAKVNPHD ->( DBGoBottom())
RETURN


METHOD FIN_fakvnphd_dod_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
//  ::itemMarked()
RETURN .T.


METHOD FIN_fakvnphd_dod_SCR:itemMarked()
  LOCAL  cky

  ::dodavatel_str := FAKVNPHD ->cNAZPOL1

  cky := upper(cnazPOL1->cnazPOL1)
  fakvnpHd->( dbSetScope(SCOPE_BOTH,cky), dbgoTop())

  cky := strZero(fakvnpHd ->ncisFak,10)
  fakvnpIt ->( dbSetScope(SCOPE_BOTH, cky), DbGoTop())

  cky := upper(fakvnpHd->cdenik) +strZero(fakvnpHd->ncisFak,10)
  ucetpol ->( dbsetScope(SCOPE_BOTH,cky), dbgoTop())
RETURN SELF


*
** CLASS for FIN_fakvnpit_SCR **************************************************
** dle pololožek vnitroFaktur
CLASS FIN_fakvnpit_SCR FROM drgUsrClass
EXPORTED:
  var  oinf

  INLINE ACCESS ASSIGN METHOD dodavatel_ns() VAR dodavatel_ns  // dodavatel z cNAZPOL1
    cNAZPOL1 ->( DbSeek( UPPER(FAKVNPHD ->cNAZPOL1),,'CNAZPOL1'))
    RETURN cNAZPOL1 ->cNAZEV
  *
  INLINE ACCESS ASSIGN METHOD odberatel_ns() VAR odberatel_ns  // odberatel z cNAZPOL1
    cNAZPOL1 ->( DbSeek( UPPER(FAKVNPHD ->cNAZPOL1O),,'CNAZPOL1'))
    RETURN cNAZPOL1 ->cNAZEV

  METHOD  init, drgDialogStart, itemMarked
HIDDEN:
  VAR  brow, dodavatel_str, comboBox
ENDCLASS


METHOD FIN_fakvnpit_SCR:init(parent)
  ::drgUsrClass:init(parent)

  // PRO INFO //
  drgDBMS:open('DPH_2004')
  drgDBMS:open('DPHDATA' )
  drgDBMS:open('UCETSYS' )
  drgDBMS:open('UZAVISOZ')
  drgDBMS:open('cNAZPOL1')

  ** info
  ::oinf := fin_datainfo():new('FAKVNPHD')
RETURN self


METHOD FIN_fakvnpit_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
  FAKVNPHD ->( DBGoBottom())
RETURN


METHOD FIN_fakvnpit_SCR:itemMarked()
  LOCAL  cky

  ::dodavatel_str := FAKVNPHD ->cNAZPOL1

  cky := fakvnpIt->ncisFak
  fakvnpHd->( mh_ordSetScope(cky,'FODBHD1'))

  cky := upper(fakvnpHd->cdenik) +strZero(fakvnpHd->ncisFak,10)
  ucetpol ->( dbsetScope(SCOPE_BOTH,cky), dbgoTop())
RETURN SELF