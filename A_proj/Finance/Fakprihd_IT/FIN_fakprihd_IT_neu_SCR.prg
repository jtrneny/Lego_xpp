#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "DMLB.CH"
*
#include "std.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'c_typpoh','c_vykdph'                                            , ;
                   'fakprihd','parprzal','banvyphd','banvypit','pokladhd','pokladit', ;
                   'firmy'   ,'ucetpol' ,'vykdph_i'                                 , ;
                   'ucetDoHd'              , ;
                   'dodlstPhd', 'dodlstPit', ;
                   'objVyshd' , 'objVysit'   }


*
** CLASS for FIN_fakprihd_IT_neu_SCR **************************************************
CLASS FIN_fakprihd_IT_neu_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, tabSelect
  method  itemMarked
  *
  *
  * položky - bro
  inline access assign method fakprihd_dny_poSpl() var fakprihd_dny_poSpl
    local posUhr    := Date()  // if( empty(fakPrihd->dposUhrFak), date(), fakPrihd->dposUhrFak )
    local splFak    := fakPrihd->dsplatFak
    local dny_poSpl := 0

    dny_poSpl := if(empty(posUhr) .or. isNull(fakPrihd->sId,0) = 0, 0, posUhr -splFak)
    return dny_poSpl // max(0, dny_poSpl)

  INLINE ACCESS ASSIGN METHOD kuhrade_vzm() VAR kuhrade_vzm  // k úhradì V Základní Mìnì
    RETURN FAKPRIHD ->nCENZAKCEL -FAKPRIHD ->nUHRCELFAK
  *
  INLINE ACCESS ASSIGN METHOD kuhrade_vcm() VAR kuhrade_vcm  // k úhradì V Cizí     Mìnì
    RETURN FAKPRIHD ->nCENZAHCEL -FAKPRIHD ->nUHRCELFAZ

  * FAKVYSHDuw  -- BANVYPIT, POKLADIT
  inline access assign method typObratu()  var typObratu
    local  typObratu := fakprihduw->ntypobratu
    return if( fakprihduw->ndoklad = 0, 0, if( typObratu = 1, 304, 305))

  inline access assign method zkratMenZ() var zkratMenZ
    fakprih_Ow->(dbseek( parPrzal->ncisZalFak,,'FPRIHD1'))
    return fakprih_Ow->czkratMenZ

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

    case nEvent = xbeP_Keyboard
      if mp1 = xbeK_CTRL_A
        return .t.
      endif
    endcase
    return .f.

hidden:
  var     tabnum, brow, otab_parZal
  var     pa_sumColumn
ENDCLASS


METHOD FIN_fakprihd_IT_neu_SCR:init(parent)
  local  pa_initParam

  ::drgUsrClass:init(parent)

  ::lnewRec      := .f.
  ::tabnum       := 1
  ::pa_sumColumn := {}

  * základní soubory
  ::openfiles(m_files)

  * pomocný soubor nahradí aliasy fakpri_v / fakpri_p / fakpri_rvw
  drgDBMS:open('fakprihd',,,,,'fakprih_ow'   )

  ** úhrady
  drgDBMS:open('FAKPRIHDuw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  ** likvidace
  ::FIN_finance_in:typ_lik := 'zav'

  ** info
  ::oinf := fin_datainfo():new('FAKPRIHD')
  ::drgDialog:set_prg_filter( '(ncenZakCel <> nuhrCelFak)', 'fakprihd')

  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    ::drgDialog:set_prg_filter(pa_initParam[2], 'fakprihd')
  endif
RETURN self


METHOD FIN_fakprihd_IT_neu_SCR:drgDialogStart(drgDialog)
  local  x, members := drgDialog:oForm:aMembers
  local  oColumn

  ::df := drgDialog:oForm                   // form

  begin sequence
    for x := 1 to len(members) step 1
      if members[x]:ClassName() = 'drgTabPage'
        if members[x]:tabNumber = 6
         ::otab_parZal := members[x]
  break
        endif
      endif
    next
  end sequence

  ::brow := drgDialog:dialogCtrl:oBrowse

  for x := 1 to ::brow[1]:oxbp:colCount step 1
    oColumn := ::brow[1]:oxbp:getColumn(x)
    if oColumn:sumColum = 1
      aadd( ::pa_sumColumn, { oColumn, oColumn:DataLink, 0, x } )
    endif
  next
RETURN


METHOD FIN_fakprihd_IT_neu_SCR:tabSelect(oTabPage,tabnum)
  local lrest := (tabNum = 2)

  ::tabnum := tabnum
  ::itemMarked()

  if(lrest,::brow[2]:oxbp:refreshAll(),nil)
RETURN .T.


METHOD FIN_fakprihd_IT_neu_SCR:itemMarked()
  LOCAL  cky := Upper(FAKPRIHD ->cDENIK) +StrZero(FAKPRIHD ->nCISFAK,10)
  LOCAL  ain := {'BANVYPIT','POKLADIT'}, cin, cou := 'FAKPRIHDuw'

  do case
  case ::tabnum = 2
    FAKPRIHDuw ->(DbZap())
    for x := 1 to len(ain)
      cin := ain[x]

      (cin) ->(AdsSetOrder(2)            , ;
               DbSetScope(SCOPE_BOTH,cky), ;
               DbGoTop()                   )

      do while .not. (cin) ->(Eof())
        mh_COPYFLD(cin,cou,.t.,.f.)

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
    (cou) ->(DbGoTop())
  endcase

*  fakpriit->(adsSetOrder('FAKPRIIT01'), dbSetScope(SCOPE_BOTH, strZero( fakprihd->ndoklad,10)), dbgoTop())

*  UCETPOL ->(AdsSetOrder('UCETPOL4')  , DbSetScope(SCOPE_BOTH,cky), DbGoTop())
*  ::brow[3]:refresh(.T.)

*  vykdph_i->(AdsSetOrder('VYKDPH_1'), dbsetscope(SCOPE_BOTH,cky), DbGoTop())
*  parPrzal->(AdsSetOrder('FODBHD2' ), dbsetscope(SCOPE_BOTH,fakprihd->ndoklad), DbGoTop())

  c_typpoh->(dbseek(upper(fakprihd->culoha) +upper(fakprihd->ctypdoklad) +upper(fakprihd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
RETURN SELF