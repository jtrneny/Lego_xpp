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
                   'ucetpol' ,'parvyzal','dodlstit','vyrzak'  ,'objitem' ,'cenzboz'   }


*
** CLASS for PRO_dodlstit_SCR **************************************************
CLASS PRO_dodlstit_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, tabSelect, itemMarked


  inline access assign method cnazMeny() var cnazMeny
    c_meny->( dbSeek( upper(dodlsthd->czkratMenZ),,'C_MENY1'))
    return c_meny->cnazMeny

  inline access assign method cnazevStat() var cnazevStat
    c_staty->(dbSeek( upper( dodlsthd->czkratStat),,'C_STATY1'))
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


METHOD PRO_dodlstit_SCR:Init(parent)
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


METHOD PRO_dodlstit_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
RETURN


METHOD PRO_dodlstit_SCR:tabSelect(oTabPage,tabnum)
 local lrest := (tabNum = 2)

  ::tabnum := tabnum
  ::itemMarked()

*-  if(lrest,::brow[3]:oxbp:refreshAll(),nil)
RETURN .T.


method pro_dodlstit_scr:itemMarked()
  local  cKy := strZero(dodlstit->ndoklad,10)

  dodlsthd->( dbSeek( dodlstit->ndoklad          ,,'DODLHD1'))
  fakvysit->(AdsSetOrder(11), DbSetScope(SCOPE_BOTH,cky), DbGoTop() )

*-  c_meny  ->( dbSeek( upper(dodlsthd->czkratMenZ),,'C_MENY1'))
return self

/*
method PRO_dodlstit_SCR:itemMarked()
  local  cky, ain := {'BANVYPIT','POKLADIT'}, cin, cou := 'FAKVYSHDuw', x


  do case
  case ::tabnum = 2
    cky := Upper(FAKVYSHD ->cDENIK) +StrZero(FAKVYSHD ->nCISFAK,10)
    (cou) ->(DbZap())

    if fakvyshd->ncisfak <> 0
      for x := 1 to len(ain)
        cin := ain[x]

        (cin) ->(AdsSetOrder(2), DbSetScope(SCOPE_BOTH,cky), DbGoTop() )

        do while .not. (cin) ->(Eof())
          mh_COPYFLD(cin,cou,.t., .f.)

          if x = 1
            BANVYPHD ->(DbSeek((cin) ->nDOKLAD,,'BANVYP_1'))
            (cou) ->cBANK_UCT := BANVYPHD ->cBANK_UCT
            (cou) ->cBANK_NAZ := BANVYPHD ->cBANK_NAZ
          else
            POKLADHD ->(DbSeek((cin) ->nDOKLAD,,'POKLADH1'))
            (cou) ->nPOKLADNA := POKLADHD ->nPOKLADNA
            (cou) ->cBANK_NAZ := POKLADHD ->cNAZPOKLAD
          endif

          (cin) ->(DbSkip())
        enddo
      next
    endif
    (cou) ->(DbGoTop())
  endcase

  *
  cky := upper(fakvysit->czkrTypFak) +strZero(fakvysit->ncisFak,10)
  fakvyshd->(AdsSetOrder('FODBHD5'),dbSetScope(SCOPE_BOTH, cky), DbGoTop())

  cky := Upper(FAKVYSHD ->cDENIK) +StrZero(FAKVYSHD ->nCISFAK,10)
  ucetpol ->(DbSetScope(SCOPE_BOTH,cky), DbGoTop())
  vykdph_i->(dbsetscope(SCOPE_BOTH,cky), DbGoTop())

  c_typpoh->(dbseek(upper(fakvyshd->culoha) +upper(fakvyshd->ctypdoklad) +upper(fakvyshd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
return self
*/