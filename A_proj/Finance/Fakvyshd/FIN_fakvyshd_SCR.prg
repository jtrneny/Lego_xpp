#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "DMLB.CH"

#include "..\Asystem++\Asystem++.ch"

#pragma Library( "ADSUTIL.LIB" )


#define m_files  { 'ucetsys' , 'uzavisoz', 'dphdada'                                                , ;
                   'dph_2001', 'dph_2004', 'dph_2009'                                               , ;
                   'c_typpoh', 'c_bankuc', 'c_meny'  , 'c_vykdph', 'c_typUhr'                       , ;
                   'banvyphd', 'banvypit', 'pokladms', 'pokladhd', 'pokladit','range_hd' ,'range_it', ;
                   'ucetpol' , 'parvyzal', 'dodlstit', 'vyrzak'  , 'vyrZakit'                       , ;
                   'objhead' , 'objitem' , 'cenzboz' , 'dodzboz'                                      }


*
** CLASS for FIN_fakvyshd_SCR **************************************************
CLASS FIN_fakvyshd_SCR FROM drgUsrClass, FIN_finance_IN, FIN_doplnujici_in
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, tabSelect, itemMarked
  *
  method  fin_dodlsthd, fin_pvphead

  inline method fin_dobropis(drgDialog)
    local  odialog, nexit

    oDialog := drgDialog():new('fin_fakvyshd_in',drgDialog)
    oDialog:cargo     := drgEVENT_APPEND2
    oDialog:cargo_usr := -1
    odialog:create(,,.T.)

    odialog:destroy()
    odialog := nil

    ::itemMarked()
  return self


  * položky - bro
  inline access assign method kuhrade_vzm() var kuhrade_vzm  // k úhradì V Základní Mìnì
    return fakVysHd->nCENZAKCEL -fakVysHd->nUHRCELFAK
  *
  inline access assign method kuhrade_vcm() VAR kuhrade_vcm  // k úhradì V Cizí     Mìnì
    return fakVysHd->nCENZAHCEL -fakVysHd->nUHRCELFAZ

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


/*
  inline method createContext()
    local  pa    := ::a_popUp
    local  aPos  := ::pb_context:oXbp:currentPos()
    local  aSize := ::pb_context:oXbp:currentSize()

    opopup         := XbpImageMenu():new( ::drgDialog:dialog )
    opopup:barText := 'Pohledávky'
    opopup:create()

    for x := 1 to len(pa) step 1
      opopup:addItem( {pa[x,1]                       , ;
                       de_BrowseContext(self,x,pA[x]), ;
                                                     , ;
                       XBPMENUBAR_MIA_OWNERDRAW        }, ;
                       500                                )
    next

    opopup:popup( ::pb_context:oxbp:parent, { apos[1] -120, apos[2] } )
  return self

  inline method fromContext(aorder,p_popUp)
    local cformName := p_poPup[2]
    local odialog

    odialog := drgDialog():new( cformName, ::drgDialog)
    odialog:create(,,.T.)

    odialog:destroy()
    odialog := nil

//    ::itemMarked()
  return self
*/


hidden:
  var     tabnum, brow
**  var     pb_context, a_popUp
  method  postDelete


  inline method info_in_msgStatus()
    local  msg       := ::drgDialog:oMessageBar             // messageBar
    *
    local  msgStatus := msg:msgStatus, picStatus := msg:picStatus
    local  ncolor, cinfo, oPs
    *
    local  extDokl  := ( fakVyshd->ncisUzv = -1 )
    local  ofont    := XbpFont():new():create( "9.Arial CE" )
    local  curSize  := msgStatus:currentSize()
    local  paColors := { { graMakeRGBColor( {  0, 183, 183} ), graMakeRGBColor( {174, 255, 255} ) }, ;
                         { graMakeRGBColor( {255, 255,  13} ), graMakeRGBColor( {255, 255, 166} ) }, ;
                         { graMakeRGBColor( {251,  51,  40} ), graMakeRGBColor( {254, 183, 173} ) }, ;
                         { GraMakeRGBColor( { 78, 154, 125} ), GraMakeRGBColor( {157, 206, 188} ) }  }

    msgStatus:setCaption( '' )
    picStatus:hide()

    ncolor := if( extDokl, 2, 4 )
    cinfo  := c_typpoh->cnaztyppoh +if( extDokl, ' ( externí doklad )', '' )

    oPs := msgStatus:lockPS()
    GraGradient( oPs, {  0, 0 }    , ;
                      { curSize }, paColors[ncolor], GRA_GRADIENT_HORIZONTAL )

    GraSetFont( oPs, oFont )
    graStringAT( oPs, { 20, 4 }, cinfo )
    msgStatus:unlockPS()

    if extDokl
      picStatus:setCaption(DRG_ICON_MSGWARN)
      picStatus:show()
    endif
  return


  inline method fakvyshd_act()
    local  ab      := ::drgDialog:oActionBar:members // actionBar
    local  cisloDl := fakvyshd->ncislodl
    local  x, ev, ok

    for x := 1 to len(ab) step 1
      ev := lower( isNull( ab[x]:event, ''))

      if ev $ 'fin_dodlsthd,fin_pvphead,fin_dobropis'
        do case
        case (ev = 'fin_dodlsthd' )
          ok := ( cisloDl <> 0 .and. dodlsthd->( dbseek( cislodl,,'DODLHD1')))

        case (ev = 'fin_pvphead'  )
          ok := ( cisloDl <> 0 .and. pvphead->( dbseek( cislodl,,'PVPHEAD10')))

        case (ev = 'fin_dobropis' )
          ok := ( .not. fakVysHD->(eof()) .and. empty( fakVysHD->csubTask) .and. fakVysHd->nparZalFak = 0 .and. fakVysHd->nparZahFak = 0 )

*        case (ev = 'fakvyshd_to_pokladhd_in' )
*          if ::oinf:canBe_Del() .and. c_typUhr->( dbseek( upper(fakvyshd->czkrTYPuhr),,'TYPUHR1') )
*            ok := ( c_typUhr->lisHotov  .and. .not. c_typUhr->lisInkaso .and. pokladms->(dbseek( npokladna,, 'POKLADM1') ) )
*          else
*            ok := .f.
*          endif
        endcase

        ab[x]:disabled := .not. ok
        if(ok, ab[x]:oxbp:enable(), ab[x]:oxbp:disable() )
      endif
    next
  return self

ENDCLASS


METHOD FIN_fakvyshd_SCR:Init(parent)
  local  pa_initParam

  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1
**  ::a_poPup := { { 'Zmìna data splatnosti', 'fin_dsplatfak_in' } }


  * základní soubory
  ::openfiles(m_files)
  dbUseArea(.t., oSession_data, 'dodlsthd', 'dodlsthd')
  dbUseArea(.t., oSession_data, 'pvphead' , 'pvphead' )

  ** úhrady
  drgDBMS:open('FAKVYSHDuw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  ** likvidace
  ::FIN_finance_in:typ_lik := 'poh'

  ** info
  ::oinf := fin_datainfo():new('FAKVYSHD')

  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    ::drgDialog:set_prg_filter(pa_initParam[2], 'fakvyshd')
  endif
RETURN self


METHOD FIN_fakvyshd_SCR:drgDialogStart(drgDialog)
  local  paFiles  := ThreadObject():paFiles
  local   members := drgDialog:oActionBar:members, x

  ::brow := drgDialog:dialogCtrl:oBrowse

  ** doplòující nabídka
  ::FIN_doplnujici_in:init(drgDialog)

/*
  for x := 1 to len(members) step 1
    if  members[x]:ClassName() = 'drgPushButton'
      if( members[x]:event = 'createContext', ::pb_context := members[x], nil )
    endif
  next
*/
RETURN


METHOD FIN_fakvyshd_SCR:tabSelect(oTabPage,tabnum)
 local lrest := (tabNum = 2)

  ::tabnum := tabnum
  ::itemMarked()

  if(lrest,::brow[3]:oxbp:refreshAll(),nil)
RETURN .T.


METHOD FIN_fakvyshd_SCR:itemMarked()
  local  cky, ain := {'BANVYPIT','POKLADIT'}, cin, cou := 'FAKVYSHDuw', x

  ::fakvyshd_act()

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
  cky := Upper(FAKVYSHD ->cZKRTYPFAK) +StrZero(FAKVYSHD ->nCISFAK,10)
  fakvysit->(mh_ordSetScope(cky,'FVYSIT4'))

  cky := Upper(FAKVYSHD ->cDENIK) +StrZero(FAKVYSHD ->nCISFAK,10)
  ucetpol  ->(mh_ordSetScope(cky))
  vykdph_i ->(mh_ordSetScope(cky, 'VYKDPH_1'))

  c_typpoh->(dbseek(upper(fakvyshd->culoha) +upper(fakvyshd->ctypdoklad) +upper(fakvyshd->ctyppohybu),,'C_TYPPOH05'))
  ::info_in_msgStatus()

*  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
return self


method fin_fakvyshd_scr:postDelete()
  local  oinf := fin_datainfo():new('FAKVYSHD'), nsel, nodel := .f.

  if oinf:canBe_Del()
    nsel := ConfirmBox( ,'Požadujete zrušit fakturu vystavenou _' +alltrim(str(fakvyshd->ndoklad)) +'_', ;
                         'Zrušení faktury vystavené ...' , ;
                          XBPMB_YESNO                    , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

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
method fin_fakvyshd_scr:fin_dodlsthd(drgDialog)
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

  ::itemMarked()
return


method fin_fakvyshd_scr:fin_pvphead(drgDialog)
  local  odialog, nexit, pa := {}, x, filter := '', m_filter

  m_filter := format("ncislodl = %%",{fakvyshd->ncislodl})

  if(select('pvphead') = 0, drgDBMS:open('pvphead'), nil)
  pvphead->(ads_setAof(m_filter), dbgotop())

  oDialog := drgDialog():new('fin_fakvyshd_pvphead',drgDialog)
  odialog:create(,,.T.)

  pvphead->(ads_clearAof())

  odialog:destroy()
  odialog := nil

  ::itemMarked()
return


*
**
#define dl_files  { 'ucetsys' ,'uzavisoz','dphdada','dph_2001','dph_2004', ;
                    'c_bankuc','c_meny'  ,'c_vykdph','c_typpoh'                     , ;
                    'dodlsthd','dodlstit','pvphead' ,'pvpitem'                      , ;
                    'banvyphd','banvypit','pokladhd','pokladit','range_hd','range_it' }

*
** CLASS for PRO_dodlsthd_SCR **************************************************
CLASS fin_fakvyshd_dodlsthd FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked

  * položky - bro
  inline access assign method cenPol() var cenPol
    return if(dodlstit->cpolcen = 'C', MIS_ICON_OK, 0)

hidden:
  var     tabnum, brow
ENDCLASS


METHOD fin_fakvyshd_dodlsthd:Init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1

  * základní soubory
  ::openfiles(dl_files)

  ** likvidace
  ::FIN_finance_in:typ_lik := 'poh'
RETURN self


METHOD fin_fakvyshd_dodlsthd:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse
  drgDialog:setReadOnly(.t.)
*-  dodlsthd->(dbgobottom())
RETURN


METHOD fin_fakvyshd_dodlsthd:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
RETURN .T.


method fin_fakvyshd_dodlsthd:itemMarked(arowco,unil,oxbp)
  local ky, rest := ''


  if isobject(oxbp)
    cfile := lower(oxbp:cargo:cfile)
    rest  := if(cfile = 'dodlsthd','ab',if(cfile = 'dodlstit','b', ''))

    if( 'a' $ rest)
      ky := strzero(dodlsthd->ndoklad,10)
      dodlstit->(mh_ordSetScope(ky,'DODLIT5'))
    endif

    if ('b' $ rest)
      ky := strzero(dodlstit->ncisfak,10) +strzero(dodlstit->nintcount,5)
      fakvysit->(mh_ordSetScope(ky, 'FVYSIT8'))

      ky := upper(dodlstit->ccissklad) +strzero(dodlstit->ncislopvp,10) ;
            +if(dodlstit->ctypsklPol = 'S ', '', strzero(dodlstit->nintcount,5))

      pvpitem->(mh_ordSetScope(ky,'PVPITEM02'))
    endif

    c_typpoh->(dbseek(upper(dodlsthd->culoha) +upper(dodlsthd->ctypdoklad) +upper(dodlsthd->ctyppohybu),,'C_TYPPOH05'))
    drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
  endif
return self



*
**
#define pv_files  { 'pvphead','pvpitem','ucetpol', 'c_drpohy','c_dph' }


CLASS fin_fakvyshd_pvphead FROM drgUsrClass, FIN_finance_in
EXPORTED:
  method  init, drgDialogStart, itemMarked, drgDialogEnd

  * pvphead - likvidace
  inline access assign method likvidaceHD() var likvidaceHD
    local klikv  := pvphead->nklikvid
    local zlikv  := pvphead->nzlikvid
    return if(klikv =  0 .and. zlikv = 0, 0, if(klikv = zlikv, L_big, L_low))

  * pvpitem -* likvidace
  inline access assign method likvidaceIT() var likvidaceIT
    local klikv  := pvpitem->nklikvid
    local zlikv  := pvpitem->nzlikvid
    return if(klikv =  0 .and. zlikv = 0, 0, if(klikv = zlikv, L_big, L_low))

HIDDEN:
  var     ucetpol_Sco
ENDCLASS


method fin_fakvyshd_pvphead:init(parent)

  ::drgUsrClass:init(parent)
  ::ucetpol_Sco := ucetpol->(dbscope(SCOPE_TOP))

  * základní soubory
  ::openfiles(pv_files)

  PVPHEAD->( DbSetRelation( 'C_DRPOHY', { || PVPHEAD->nCislPoh },'PVPHEAD->nCislPoh'))
  PVPITEM->( DbSetRelation( 'C_DPH'   , { || PVPITEM->nKlicDPH },'PVPITEM->nKlicDPH'))
  PVPITEM ->( AdsSetOrder( 'PVPITEM02'))
return self


method fin_fakvyshd_pvphead:drgDialogStart(drgDialog)
 LOCAL aInfo := { 'cCisSklad', 'cSklPol', 'cNazZbo', 'nUcetSkup', 'C_DRPOHY->cNazevPoh'}
  AEVAL( aInfo,;
   {|c| drgDialog:dataManager:has( IF( drgParse( c,'-') = c, 'PVPITEM->'+ c, c) ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {221, 221, 221} )) })
 drgDialog:setReadOnly(.t.)
return


method fin_fakvyshd_pvphead:ItemMarked()
  local  cky := upper(pvphead->ccissklad) +strZero(pvphead->ndoklad,10)

  pvpitem->(mh_ordSetScope(cky))

  cky := upper(pvphead->cdenik) +strZero(pvphead->ndoklad,10)
  ucetpol->(mh_ordSetScope(cky))
return self


method fin_fakvyshd_pvphead:drgDialogEnd()
  if .not. empty(::ucetpol_Sco)
    ucetpol->(mh_ordSetScope(::ucetpol_Sco))
  endif
return self