#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys' ,'uzavisoz','dphdada','dph_2001','dph_2004' , ;
                   'uctvykhd','uctvykit'                                   }


//function uct_uctdokit_bc(typ)
//  local typObratu := if(typ = 'w', uctdokhdw->ntypobratu, uctdokhd->ntypobratu)
//return if(typObratu = 1, 'DAL', 'MD ')


*
** CLASS for UCT_uctdokhd_SCR **************************************************
CLASS UCT_uctvykhd_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, tabSelect, itemMarked, drgDialogEnd, postDelete

  method  aktVykazu

  *
  inline access assign method aktStav() var aktStav
    local  key
    local  nretVal := 6002

    key := Upper('U') + StrZero( uctvykhd->nrok,4) + StrZero( uctvykhd->nobdobi,2)

    if ucetsys->( dbSeek( key,,'UCETSYS3'))
      nretVal := if( ucetsys->naktuc_ks = 2, 607, 6002)
    endif

  return nretVal

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = drgEVENT_OBDOBICHANGED)
      if ::nrok <> uctOBDOBI:UCT:NROK
        ::nrok := uctOBDOBI:UCT:NROK

        uctvykhd ->( ADS_SetAOF( Format("nROK = %% .and. cTypUctVyk = '%%'", { ::nrok, ::avyk[::tabnum]})), dbGoTop())
        ::brow[::aHd[::tabnum]]:oxbp:refreshAll()

        ::itemMarked()
      endif

    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, brow, dm
  var     nrok
  var     aHd, aIt
  var     avyk

ENDCLASS

method UCT_uctvykhd_SCR:init(parent)
*-  LOCAL filter := FORMAT("upper(cdenik) = '%%'", {SYSCONFIG('FINANCE:cDENIKFIDO')})

  ::drgUsrClass:init(parent)
  ::lnewRec := .f.
  ::tabnum  := 1
  ::aVyk    := {'ROZ', 'VZZ', 'CFW'}
  ::aHd     := {1,3,5}
  ::aIt     := {2,4,6}

  ::nrok := uctOBDOBI:UCT:NROK

  * základní soubory
  ::openfiles(m_files)
  drgDBMS:open( 'uctvykhd',,,,, 'uctvykhda' )
  drgDBMS:open( 'uctvykit',,,,, 'uctvykita' )
  drgDBMS:open( 'defvykhd',,,,, 'defvykhdx' )

  ** likvidace úèetní doklad se nelikviduje, typ_lik je použit pro RV_dph **
  ::oinf  := fin_datainfo():new('UCTDOKHD')

*-  uctdokhd->(ads_setAof(filter))
return self


method UCT_uctvykhd_SCR:drgDialogStart(drgDialog)
  local nOBDOBI
  local cFiltr

  ::brow := drgDialog:dialogCtrl:oBrowse
  ::dm   := drgDialog:dataManager

//  nROK    := uctOBDOBI:UCT:NROK
//  nOBDOBI := uctOBDOBI:UCT:NOBDOBI

  cFiltr := Format("nROK = %% .and. cTypUctVyk = '%%'", {::nrok, ::avyk[1]})
  uctvykhd ->( ADS_SetAOF( cFiltr), dbGoTop())
//  ::brow[1]:oxbp:refreshAll()

//  cFiltr := Format("nROK = %% .and. cTypUctVyk = '%%'", {nROK})
//  uctvykhd ->( ADS_SetAOF( cFiltr), dbGoTop())

return


method UCT_uctvykhd_SCR:tabSelect(oTabPage,tabnum)
  local cfiltr

  ::tabnum := tabnum

  cFiltr := Format("nROK = %% .and. cTypUctVyk = '%%'", { ::nrok, ::avyk[::tabnum]})
  uctvykhd ->( ADS_SetAOF( cFiltr), dbGoTop())
  ::brow[::aHd[::tabnum]]:oxbp:refreshAll()

  ::itemMarked()
return .t.


method UCT_uctvykhd_SCR:itemMarked()
  local  cfiltr

  if .not. empty( uctvykhd->sid) .and. .not. uctvykhd->(eof())
    cFiltr := Format("nuctvykhd = %%", {uctvykhd->sid})
    uctvykit->( Ads_SetAof( cfiltr), dbGoTop())
  else
//    cFiltr := Format("nuctvykhd = %%", {0})
//    uctvykit->( Ads_SetAof( cfiltr), dbGoTop())
  endif

  ::brow[::aIt[::tabnum]]:oxbp:refreshAll()

return self


method UCT_uctvykhd_SCR:drgDialogEnd()
return


method UCT_uctvykhd_SCR:postDelete()
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


method UCT_uctvykhd_SCR:aktVykazu()
  local cidvyk
  local ctypvyk
  local cfiltr
  local acfgvyk
  local firstYear

  firstYear := mh_FirstODate( ::nrok, uctOBDOBI:UCT:nOBDOBI)
  acfgvyk   := mh_token( SysConfig('Ucto:cIDvykUct', firstYear))
  cidvyk    := AllTrim( acfgvyk[::tabnum])

  cFiltr := Format("cobdobi = '%%' .and. cTypUctVyk = '%%'", {uctOBDOBI:UCT:cOBDOBI,::avyk[::tabnum]} )
  uctvykhda->( Ads_SetAof( cfiltr), dbGoTop())

  if uctvykhda->( Rlock())
    uctvykhda->( dbDelete(), dbUnlock())

    uctvykita->( Ads_SetAof( cfiltr), dbGoTop())
    uctvykita->( dbEval( {|| if( Rlock(),( dbDelete(),dbUnlock()), NIL)}))

    uctvykhda->( Ads_ClearAof())
    uctvykita->( Ads_ClearAof())

    obdReport := StrZero(uctOBDOBI:UCT:nOBDOBI,2) + '/' + StrZero( ::nrok,4)

    vyk_naplnvyk_in( cidvyk,,1)

    defvykhdx->( dbSeek( Upper(AllTrim(acfgvyk[::tabnum])),,'DEFVYKHD03'))
    vykazw->( dbGoTop())
    mh_copyFld('vykazw', 'uctvykhd',.t.)

    uctvykhd->cNazVykazu := defvykhdx->cNazVykazu
    uctvykhd->cTypUctVyk := ::avyk[::tabnum]
    uctvykhd->cIDVykazu  := defvykhdx->cIDVykazu
    uctvykhd->dDatZprac  := Date()

    do while .not. vykazw->( Eof())
      mh_copyFld('vykazw', 'uctvykit',.t.)

      uctvykit->cTypUctVyk := uctvykhd->cTypUctVyk
      uctvykit->cOznRadVyk := vykazw->ctexttm1
      uctvykit->nRadUctVyk := Val(vykazw->cskuradvyk)

      uctvykit->nuctvykhd := isNull( uctvykhd->sid,0)
      vykazw->( dbSkip())
    enddo

    uctvykit->( dbGoTop())
    uctvykhd->( dbUnlock())
    uctvykit->( dbUnlock())
    uctvykhda->( dbUnlock())

    ::brow[::aHd[::tabnum]]:oxbp:refreshAll()
    ::itemMarked()
  else
    MsgBox( 'Vygenerovaný výkaz nelze zrušit, nebude se aktualizovat...')

  endif


return .t.