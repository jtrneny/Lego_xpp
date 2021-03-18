#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys' ,'uzavisoz','dphdada'                                  , ;
                   'dph_2001','dph_2004','dph_2009'                                 , ;
                   'c_typpoh','c_bankuc','c_meny'  ,'c_vykdph'                      , ;
                   'banvyphd','banvypit','pokladhd','pokladit','range_hd','range_it', ;
                   'ucetpol' ,'parvyzal','dodlstit','vyrzak'  ,'vyrZakit'           , ;
                   'objhead' ,'objitem' ,'cenzboz' ,'dodzboz'                         }


*
** CLASS for PRO_fakvyshd_SCR **************************************************
CLASS PRO_fakvyshd_SCR FROM drgUsrClass, FIN_finance_IN, FIN_doplnujici_in
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, drgDialogEnd, tabSelect, itemMarked
  *
  method  fin_dodlsthd, fin_pvphead

   * položky - bro
  inline access assign method cenPol() var cenPol
    return if(fakvysit->cpolcen = 'C', MIS_ICON_OK, 0)

  * FAKVYSHDuw  -- BANVYPIT, POKLADIT
  inline access assign method typObratu() var typObratu
    local  typObratu := fakvyshduw->ntypobratu
    return if( fakvyshduw->ndoklad = 0, 0, if( typObratu = 1, 304, 305))

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

   inline method fakvyshd_act()
    local  ab      := ::drgDialog:oActionBar:members // actionBar
    local  cisloDl := fakvyshd->ncislodl
    local  x, ev, ok

    for x := 1 to len(ab) step 1
      ev := lower( isNull( ab[x]:event, ''))

      if ev $ 'fin_dodlsthd,fin_pvphead'
        do case
        case (ev = 'fin_dodlsthd' )
          ok := ( cisloDl <> 0 .and. dodlsthd->( dbseek( cislodl,,'DODLHD1')))

        case (ev = 'fin_pvphead'  )
          ok := ( cisloDl <> 0 .and. pvphead->( dbseek( cislodl,,'PVPHEAD10')))
        endcase

        ab[x]:disabled := .not. ok
        if(ok, ab[x]:oxbp:enable(), ab[x]:oxbp:disable() )
      endif
    next
  return self

ENDCLASS


METHOD PRO_fakvyshd_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum := 1

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
RETURN self


method pro_fakvyshd_scr:drgDialogStart(drgDialog)
  local filter := format("upper(csubTask) = '%%'",{'PRO'})

  ::brow := drgDialog:dialogCtrl:oBrowse

  ** doplòující nabídka
  ::FIN_doplnujici_in:init(drgDialog)

  fakvyshd->(ads_setAof(filter))
  fakvyshd->(dbGoBottom())

  ::brow[1]:oxbp:refreshAll()
return


method pro_fakvyshd_scr:drgDialogEnd()
  fakvyshd->(ads_clearAof())
return


METHOD pro_fakvyshd_scr:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
RETURN .T.


METHOD pro_fakvyshd_scr:itemMarked()
  local  cky, ain := {'BANVYPIT','POKLADIT'}, cin, cou := 'FAKVYSHDuw', x

  ::fakvyshd_act()

  do case
  case ::tabnum = 2
    cky := Upper(FAKVYSHD ->cDENIK) +StrZero(FAKVYSHD ->nCISFAK,10)
    (cou) ->(DbZap())

    if fakvyshd->ncisfak <> 0
      for x := 1 to len(ain)
        cin := ain[x]

        (cin) ->(AdsSetOrder(2), DbSetScope(SCOPE_BOTH,cky), DbGoTop())

        do while .not. (cin) ->(Eof())
          mh_COPYFLD(cin,cou, .t., .f.)

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
  cky := Upper(FAKVYSHD ->cZKRTYPFAK) +StrZero(FAKVYSHD ->nCISFAK,10)
  fakvysit->(mh_ordSetScope(cky,'FVYSIT4'))

  cky := Upper(FAKVYSHD ->cDENIK) +StrZero(FAKVYSHD ->nCISFAK,10)
  ucetpol  ->(mh_ordSetScope(cky))
*  vykdph_i ->(mh_ordSetScope(cky))

  c_typpoh->(dbseek(upper(fakvyshd->culoha) +upper(fakvyshd->ctypdoklad) +upper(fakvyshd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
return self


method pro_fakvyshd_scr:postDelete()
  local  nsel, nodel := .f.

  if fakvyshd->ncisfak <> 0
    nsel := ConfirmBox( ,'Požadujete zrušit fakturu vystavenou _' +alltrim(str(fakvyshd->ndoklad)) +'_', ;
                         'Zrušení faktury vystavené ...' , ;
                          XBPMB_YESNO                    , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES

      fin_fakvyshd_cpy(self)
      nodel := .not. fin_fakvyshd_del(self)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Fakturu vystavenou _' +alltrim(str(fakvyshd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení faktury vystavené ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel

*
**
method pro_fakvyshd_scr:fin_dodlsthd(drgDialog)
  local  odialog, nexit
  *
  local  filter   := format("ndoklad = %%",{fakvyshd->ncislodl})
  local  oldFocus := fakvysit->(AdsSetOrder())

  if(select('dodlsthd') = 0, drgDBMS:open('dodlsthd'), nil)
  dodlsthd->(ads_setAof(filter), dbgotop())

  oDialog := drgDialog():new('fin_fakvyshd_dodlsthd',drgDialog)
  odialog:create(,,.T.)

  dodlsthd->(ads_clearAof())
  fakvysit->(dbclearScope(), AdsSetOrder(oldFocus))

  odialog:destroy()
  odialog := nil
return


method pro_fakvyshd_scr:fin_pvphead(drgDialog)
  local  odialog, nexit, pa := {}, x, filter := '', m_filter

  m_filter := format("ncislodl = %%",{fakvyshd->ncislodl})

  if(select('pvphead') = 0, drgDBMS:open('pvphead'), nil)
  pvphead->(ads_setAof(m_filter), dbgotop())

  oDialog := drgDialog():new('fin_fakvyshd_pvphead',drgDialog)
  odialog:create(,,.T.)

  pvphead->(ads_clearAof())

  odialog:destroy()
  odialog := nil
return