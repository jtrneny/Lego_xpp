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



function FIN_fakprihd_IT_SCR_BC(colum)
  fakprih_Ow->( dbseek( parPrzal->ncisFak,,'FPRIHD1'))

  do case
  case lower(colum) = 'varsym'
    return fakprih_Ow->cvarSym

  case lower(colum) = 'ucet_uct'
    return fakprih_Ow->cucet_Uct

  case lower(colum) = 'textfakt'
    return fakprih_Ow->ctextFakt

  endcase
return ''


*
** CLASS for FIN_fakprihd_IT_SCR ***********************************************
CLASS FIN_fakprihd_IT_SCR FROM drgUsrClass, FIN_finance_IN, FIN_doplnujici_in
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, tabSelect
  method  itemMarked  // , stableBlock
  *
  method  W_maximize

   inline method fin_dobropis(drgDialog)
    local  odialog, nexit

    oDialog := drgDialog():new('fin_fakprihd_it_in',drgDialog)
    oDialog:cargo     := drgEVENT_APPEND2
    oDialog:cargo_usr := -1

    odialog:create(,,.T.)

    odialog:destroy()
    odialog := nil

    ::itemMarked()
  return self

  *
  * položky - bro
  inline access assign method has_items var has_items
    local  doklad := strZero(fakprihd->ndoklad,10)
    return if( fakprii_BC->(dbseek(doklad,,'FAKPRIIT01')), MIS_BOOKOPEN, 0)

  inline access assign method cenPol() var cenPol
    return if(fakpriit->cpolcen = 'C', MIS_ICON_OK, 0)

  INLINE ACCESS ASSIGN METHOD kuhrade_vzm() VAR kuhrade_vzm  // k úhradì V Základní Mìnì
    RETURN FAKPRIHD ->nCENZAKCEL -FAKPRIHD ->nUHRCELFAK
  *
  INLINE ACCESS ASSIGN METHOD kuhrade_vcm() VAR kuhrade_vcm  // k úhradì V Cizí     Mìnì
    RETURN FAKPRIHD ->nCENZAHCEL -FAKPRIHD ->nUHRCELFAZ

  * FAKVYSHDuw  -- BANVYPIT, POKLADIT
  inline access assign method typObratu()  var typObratu
    local  typObratu := fakprihduw->ntypobratu
    return if( fakprihduw->ndoklad = 0, 0, if( typObratu = 1, 304, 305))

  * parPrzal
  inline access assign method parovanoFak()   var parovanoFak
    return if( parPrzal->nuhrZalFak = parPrzal->nparZalFak, P_big, if( parPrzal->nparZalFak = 0, 0, P_low))

  inline access assign method zkratMenZ() var zkratMenZ
    fakprih_Ow->(dbseek( parPrzal->ncisZalFak,,'FPRIHD1'))
    return fakprih_Ow->czkratMenZ

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, brow, otab_parZal
  method  postDelete

  inline method fakprihd_act()
    local  ab      := ::drgDialog:oActionBar:members // actionBar
    local  x, ev, ok

    for x := 1 to len(ab) step 1
      ev := lower( isNull( ab[x]:event, ''))

      if ev = 'fin_dobropis'
        ok := ( .not. fakPriHD->(eof()) .and. fakPriHd->nparZalFak = 0 .and. fakPriHd->nparZahFak = 0 )

        ab[x]:disabled := .not. ok
        if(ok, ab[x]:oxbp:enable(), ab[x]:oxbp:disable() )
      endif
    next
  return self

ENDCLASS


method fin_fakprihd_IT_scr:W_maximize()
  local hWnd

  hWnd := ::drgDialog:dialog:getHwnd()

  if IsZoomed(hwnd) = 1
    ShowWindow(hwnd,SW_SHOWNORMAL)
  else
    ShowWindow(hwnd,SW_SHOWMAXIMIZED)
  endif

  ::drgDialog:dialog:invalidateRect()
*-  ::drgDialog:dialog:show()
return .t.


METHOD FIN_fakprihd_IT_SCR:init(parent)
  local  pa_initParam

  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1

  * základní soubory
  ::openfiles(m_files)

//  FAKPRIHD ->(DbSetRelation( 'FIRMY', { || FAKPRIHD ->nCISFIRMY }))

  * pomocný soubor nahradí aliasy fakpri_v / fakpri_p / fakpri_rvw
  drgDBMS:open('fakprihd',,,,,'fakprih_ow'   )

  * pomocný pro broColumn indikující že doklad má položky
  drgDBMS:open('fakpriit',,,,,'fakprii_BC'   )

  ** úhrady
  drgDBMS:open('FAKPRIHDuw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  ** likvidace
  ::FIN_finance_in:typ_lik := 'zav'

  ** info
  ::oinf := fin_datainfo():new('FAKPRIHD')

  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    ::drgDialog:set_prg_filter(pa_initParam[2], 'fakprihd')
  endif
RETURN self


METHOD FIN_fakprihd_IT_SCR:drgDialogStart(drgDialog)
  local x, members := drgDialog:oForm:aMembers

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

  ** doplòující nabídka
  ::FIN_doplnujici_in:init(drgDialog)
*-  FAKPRIHD ->(DbGoBottom())
RETURN


METHOD FIN_fakprihd_IT_SCR:tabSelect(oTabPage,tabnum)
  local lrest := (tabNum = 2)

  ::tabnum := tabnum
  ::itemMarked()

  if(lrest,::brow[2]:oxbp:refreshAll(),nil)
RETURN .T.

/*
method FIN_fakprihd_IT_SCR:stableBlock(obro)
  local  cky := Upper(FAKPRIHD ->cDENIK) +StrZero(FAKPRIHD ->nCISFAK,10)
  local  ain := {'BANVYPIT','POKLADIT'}, cin, cou := 'FAKPRIHDuw'
  *
  local  odbrowse := ::drgDialog:odbrowse

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

  UCETPOL ->(AdsSetOrder('UCETPOL4'), DbSetScope(SCOPE_BOTH,cky), DbGoTop())
**  if( isArray( ::brow ), ::brow[3]:refresh(.T.), nil )

  vykdph_i->(AdsSetOrder('VYKDPH_1'), dbsetscope(SCOPE_BOTH,cky), DbGoTop())
  c_typpoh->(dbseek(upper(fakprihd->culoha) +upper(fakprihd->ctypdoklad) +upper(fakprihd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)

  ::FIN_finance_IN:fakprihd_act(::drgDialog)
return
*/


METHOD FIN_fakprihd_IT_SCR:itemMarked()
  LOCAL  cky := Upper(FAKPRIHD ->cDENIK) +StrZero(FAKPRIHD ->nCISFAK,10)
  LOCAL  ain := {'BANVYPIT','POKLADIT'}, cin, cou := 'FAKPRIHDuw'

/*
  if isObject(::otab_parZal)
    if fakPriHd->cisZAL_FAK = '1'
      ( ::otab_parZal:isEdit := .t., ::otab_parZal:oxbp:enable() )
    else
      * pokud je tam pøepnutý musíme jít na 1-záložku
      if ::otab_parZal:is_Show
        ::df:tabPageManager:toFront(1)
      endif
      ( ::otab_parZal:isEdit := .f., ::otab_parZal:oxbp:disable() )
    endif
  endif
*/

  ::fakprihd_act()

  do case
  case ::tabnum = 3
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

  fakpriit->(adsSetOrder('FAKPRIIT01'), dbSetScope(SCOPE_BOTH, strZero( fakprihd->ndoklad,10)), dbgoTop())

  UCETPOL ->(AdsSetOrder('UCETPOL4')  , DbSetScope(SCOPE_BOTH,cky), DbGoTop())
  ::brow[3]:refresh(.T.)

  vykdph_i->(AdsSetOrder('VYKDPH_1'), dbsetscope(SCOPE_BOTH,cky), DbGoTop())
  parPrzal->(AdsSetOrder('FODBHD2' ), dbsetscope(SCOPE_BOTH,fakprihd->ndoklad), DbGoTop())

  c_typpoh->(dbseek(upper(fakprihd->culoha) +upper(fakprihd->ctypdoklad) +upper(fakprihd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)

  ::FIN_finance_IN:fakprihd_act(::drgDialog)
RETURN SELF


method FIN_fakprihd_IT_scr:postDelete()
  local  oinf := fin_datainfo():new('FAKPRIHD'), nsel, nodel := .f.


  if oinf:canBe_Del()
    nsel := ConfirmBox( ,'Požadujete zrušit pøijatou fakturu _' +alltrim(str(fakprihd->ncisfak)) +'_', ;
                         'Zrušení pøijaté faktury ...'                , ;
                          XBPMB_YESNO                                 , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, ;
                          XBPMB_DEFBUTTON2                              )

    if nsel = XBPMB_RET_YES
      fin_fakprihd_it_cpy(self)
      nodel := .not. fin_fakprihd_it_del(self)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Pøijatou fakturu _' +alltrim(str(fakprihd->ncisfak)) +'_' +' nelze zrušit ...', ;
                 'Zrušení pøijaté faktury ...' , ;
                 XBPMB_CANCEL                  , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel