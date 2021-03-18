#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "DMLB.CH"

#include "..\Asystem++\Asystem++.ch"

#pragma Library( "ADSUTIL.LIB" )


#define m_files  { 'ucetsys' ,'uzavisoz','dphdada', ;
                   'dph_2001','dph_2004','dph_2009'          , ;
                   'c_typpoh','c_bankuc','c_meny'  ,'c_vykdph'                      , ;
                   'banvyphd','banvypit','pokladhd','pokladit','range_hd','range_it', ;
                   'ucetpol' ,'parvyzal','dodlstit','vyrzak'                        , ;
                   'objhead' ,'objitem' ,'cenzboz' ,'dodzboz'  }


*
** CLASS for FIN_fakvyshd_neu_SCR *********************************************
CLASS FIN_fakvyshd_neu_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, tabSelect, itemMarked
  *
  * položky - bro
  inline access assign method fakvyshd_dny_poSpl() var fakvyshd_dny_poSpl
    local posUhr    := Date() // if( empty(fakVyshd->dposUhrFak), date(), fakVyshd->dposUhrFak )
    local splFak    := fakVyshd->dsplatFak
    local dny_poSpl := 0

    dny_poSpl := if(empty(posUhr) .or. isNull( fakVyshd->sId,0) = 0, 0, posUhr -splFak)
    return dny_poSpl // max(0, dny_poSpl)

  INLINE ACCESS ASSIGN METHOD kuhrade_vzm() VAR kuhrade_vzm  // k úhradì V Základní Mìnì
    RETURN fakVysHd->nCENZAKCEL -fakVysHd ->nUHRCELFAK
  *
  INLINE ACCESS ASSIGN METHOD kuhrade_vcm() VAR kuhrade_vcm  // k úhradì V Cizí     Mìnì
    RETURN fakVysHd->nCENZAHCEL -fakVysHd->nUHRCELFAZ

  * FAKVYSHDuw  -- BANVYPIT, POKLADIT
  inline access assign method typObratu() var typObratu
    local  typObratu := fakvyshduw->ntypobratu
    return if( fakvyshduw->ndoklad = 0, 0, if( typObratu = 1, 304, 305))

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


METHOD FIN_fakvyshd_neu_SCR:Init(parent)
  local  pa_initParam

  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1

  * základní soubory
  ::openfiles(m_files)
  drgDBMS:open('dodlsthd')
  drgDBMS:open('pvphead')

  ** úhrady
  drgDBMS:open('FAKVYSHDuw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  ** likvidace
  ::FIN_finance_in:typ_lik := 'poh'

  ** info
  ::oinf := fin_datainfo():new('FAKVYSHD')
  ::drgDialog:set_prg_filter( '(ncenZakCel <> nuhrCelFak)', 'fakvyshd')

  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    ::drgDialog:set_prg_filter(pa_initParam[2], 'fakvyshd')
  endif

RETURN self


METHOD FIN_fakvyshd_neu_SCR:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse
RETURN


METHOD FIN_fakvyshd_neu_SCR:tabSelect(oTabPage,tabnum)
 local lrest := (tabNum = 2)

  ::tabnum := tabnum
  ::itemMarked()

  if(lrest,::brow[2]:oxbp:refreshAll(),nil)
RETURN .T.


METHOD FIN_fakvyshd_neu_SCR:itemMarked()
  local  cky, ain := {'BANVYPIT','POKLADIT'}, cin, cou := 'FAKVYSHDuw', x

*  ::fakvyshd_act()

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
*  cky := Upper(FAKVYSHD ->cZKRTYPFAK) +StrZero(FAKVYSHD ->nCISFAK,10)
*  fakvysit->(mh_ordSetScope(cky,'FVYSIT4'))

*  cky := Upper(FAKVYSHD ->cDENIK) +StrZero(FAKVYSHD ->nCISFAK,10)
*  ucetpol  ->(mh_ordSetScope(cky))
*  vykdph_i ->(mh_ordSetScope(cky, 'VYKDPH_1'))

  c_typpoh->(dbseek(upper(fakvyshd->culoha) +upper(fakvyshd->ctypdoklad) +upper(fakvyshd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
return self