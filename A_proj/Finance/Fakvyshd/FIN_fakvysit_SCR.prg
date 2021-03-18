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
                   'ucetpol' ,'parvyzal','dodlstit','vyrzak'  ,'objitem' ,'cenzboz'   }


*
** CLASS for FIN_fakvysit_SCR **************************************************
CLASS FIN_fakvysit_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, tabSelect, itemMarked
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


METHOD FIN_fakvysit_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum := 1

  * základní soubory
  ::openfiles(m_files)

  ** úhrady
  drgDBMS:open('FAKVYSHDuw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  ** likvidace
  ::FIN_finance_in:typ_lik := 'poh'

  ** info
  ::oinf := fin_datainfo():new('FAKVYSHD')
RETURN self


METHOD FIN_fakvysit_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
RETURN


METHOD FIN_fakvysit_SCR:tabSelect(oTabPage,tabnum)
 local lrest := (tabNum = 2)

  ::tabnum := tabnum
  ::itemMarked()

  if(lrest,::brow[3]:oxbp:refreshAll(),nil)
RETURN .T.


METHOD FIN_fakvysit_SCR:itemMarked()
  local  cky, ain := {'BANVYPIT','POKLADIT'}, cin, cou := 'FAKVYSHDuw', x

  do case
  case ::tabnum = 2
    cky := Upper(FAKVYSHD ->cDENIK) +StrZero(FAKVYSHD ->nCISFAK,10)
    (cou) ->(DbZap())

    if fakvyshd->ncisfak <> 0
      for x := 1 to len(ain)
        cin := ain[x]

        (cin) ->(mh_ordSetScope(cky,2))

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
  fakvyshd->(mh_ordSetScope(cky,'FODBHD5'))

  cky := Upper(FAKVYSHD ->cDENIK) +StrZero(FAKVYSHD ->nCISFAK,10)
  ucetpol ->(mh_ordSetScope(cky))
  vykdph_i->(mh_ordSetScope(cky))

  c_typpoh->(dbseek(upper(fakvyshd->culoha) +upper(fakvyshd->ctypdoklad) +upper(fakvyshd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
return self