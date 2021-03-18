#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"

********************************************************************************NEW
*
********************************************************************************
CLASS SKL_Parovani_VSprijem FROM drgUsrClass
EXPORTED:
  VAR     cfg_cDenik, cfg_lFakParSym, nCisFak, nCisloDL
  METHOD  Init, drgDialogStart, destroy
  METHOD  btn_GoParovani
HIDDEN:
  VAR     dm, msg
ENDCLASS

********************************************************************************
METHOD SKL_Parovani_VSprijem:init(parent)
  ::drgUsrClass:init(parent)
  *
  ::nCisFak        := PVPHEAD->nCisFak
  ::nCisloDL       := PVPHEAD->nCisloDL
  ::cfg_cDenik     := Padr(AllTrim(SysConfig( 'Sklady:cDenik')),2)
  ::cfg_lFakParSym := SysConfig( 'Sklady:lFakParSym')
RETURN self

********************************************************************************
METHOD SKL_Parovani_VSprijem:drgDialogStart(drgDialog)
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN self

********************************************************************************
METHOD SKL_Parovani_VSprijem:destroy()
  *
  ::cfg_cDenik := ::cfg_lFakParSym := ::nCisFak := ::nCisloDL := NIL
RETURN self

********************************************************************************
METHOD SKL_Parovani_VSprijem:btn_GoParovani()
  Local cObdDokl, cScope, isLock, aRecPvpIT := {}, aRecUcetPOL := {}, aRecUcetSYS := {}

  ::dm:save()
  *
  drgDBMS:open('UCETSYS')
  fordRec({'UCETSYS,3'})
  cObdDokl := StrZero( PVPHEAD->nRok, 4) + StrZero( PVPHEAD->nObdobi, 2)
  UCETSYS->( mh_SetScope('U'))
  UCETSYS->( dbSeek('U' + cObdDokl))

  do while .not. UCETSYS->(eof())
    if UCETSYS->nAKTUc_KS = 2 .and. !UCETSYS->lZavren
      AAdd(aRecUcetSys, UCETSYS->(recNo()))
    endif
    UCETSYS->(dbSkip())
  enddo
  UCETSYS->( mh_ClrScope())
  fordRec()
  *
  drgDBMS:open('PVPITEM',,,,, 'PVPITEMx')
  PVPITEMx->( AdsSetOrder( 'PVPITEM02'))
  cScope := Upper( PVPHEAD->cCisSklad) + StrZero( PVPHEAD->nDoklad, 10)
  PVPITEMx->( mh_ClrScope(), mh_SetScope( cScope),;
             dbEval( {|| aADD( aRecPVPIt, PVPITEMx->( RecNo()) )}),;
             dbGoTOP() )
  *
  drgDBMS:open('UCETPOL',,,,, 'UCETPOLx')
  UCETPOLx->( AdsSetOrder( 'UCETPOL1'))
  cScope := Upper( ::cfg_cDenik) + StrZero( PVPHEAD->nDoklad, 10)
  UCETPOLx->( mh_ClrScope(), mh_SetScope( cScope),;
             dbGoTOP(),;
             dbEval( {|| aADD( aRecUcetPOL, UCETPOLx->( RecNo()) )}),;
             dbGoTOP() )

  isLock := ( PVPHEAD->( dbRLock( )) .and.             ;
              PVPITEMx->( sx_RLock( aRecPVPIT)) .and.   ;
              UCETSYS->( sx_RLock( aRecUcetSys)) .and. ;
              UCETPOLx->( sx_RLOCK( aRecUcetPOL)) )
  *
  IF isLock
    oMoment := SYS_MOMENT('Probíhá párování dle V-symbolu ...')
    * PVPHEAD
    PVPHEAD->nCisFak  := ::nCisFak
    PVPHEAD->nCisloDL := ::nCisloDL
    mh_WRTzmena( 'PVPHEAD')
    * PVPITEM
    AEval(aRecPVPIt, {|x| ( PVPITEMx->(dbGoTo(x))           , ;
                            PVPITEMx->nCisFak  := ::nCisFak , ;
                            PVPITEMx->nCisloDL := ::nCisloDL, ;
                            mh_WRTzmena( 'PVPITEMx')  ) })
    * UCETSYS
    AEval(aRecUcetSys, {|x| ( UCETSYS->(dbGoTo(x))           , ;
                              UCETSYS->nAKTUc_KS := 1        , ;
                              UCETSYS->cuctKdo   := logOsoba , ;
                              UCETSYS->ductDat   := date()   , ;
                              UCETSYS->cuctCas   := time()   , ;
                              mh_WRTzmena( 'UCETSYS')  ) })
    * UCETPOL
    AEval(aRecUcetPOL, {|x| ( UCETPOLx->(dbGoTo(x))          , ;
                              UCETPOLx->cSymbol := if( ::cfg_lFakParSym, alltrim( str(::nCisFak)), alltrim( str(::nCisloDL))) , ;
                              mh_WRTzmena( 'UCETPOLx')) })
    *
    oMoment:destroy()

    PVPHEAD->( dbCommit(), dbUnlock())
    PVPITEMx->( dbCommit(), dbUnlock())
    UCETPOLx->( dbCommit(), dbUnlock(), mh_ClrScope())
    UCETSYS->( dbCommit(), dbUnlock() )
  ELSE
    drgMsgBox(drgNLS:msg('NELZE - soubory jsou blokovány jiným uživatelem ...'))
  ENDIF

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN self

********************************************************************************
*
********************************************************************************
CLASS SKL_Parovani_VSvydej FROM drgUsrClass

EXPORTED:
  VAR     cfg_cDenik, cfg_lFakParSym
  METHOD  Init, drgDialogStart, destroy
  METHOD  btn_GoParovani

ENDCLASS

********************************************************************************
METHOD SKL_Parovani_VSvydej:init(parent)

  ::drgUsrClass:init(parent)
  ::cfg_cDenik     := Padr(AllTrim(SysConfig( 'Sklady:cDenik')),2)
  ::cfg_lFakParSym := SysConfig( 'Sklady:lFakParSym')
  *
  drgDBMS:open( 'PVPITEMww',.T.,.T.,drgINI:dir_USERfitm) ;  ZAP
RETURN self

********************************************************************************
METHOD SKL_Parovani_VSvydej:drgDialogStart(drgDialog)
  Local nRec := PVPITEM->( RecNo())
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  PVPITEM->( dbEval({|| ( mh_copyFLD( 'PVPITEM', 'PVPITEMww', .t.),;
                          PVPITEMww->_nrecor := PVPITEM->( RecNo())) }))
  PVPITEM->( dbGoTo( nRec))
  PVPITEMww->( dbGoTop())
RETURN self

********************************************************************************
METHOD SKL_Parovani_VSvydej:destroy()
  *
  ::cfg_cDenik := ::cfg_lFakParSym := NIL
RETURN self

********************************************************************************
METHOD SKL_Parovani_VSvydej:btn_GoParovani()
  Local cObdDokl, cScope, isLock, aRecPvpIT := {}, aRecUcetPOL := {}, aRecUcetSYS := {}
  *
  drgDBMS:open('UCETSYS')
  fordRec({'UCETSYS,3'})
  cObdDokl := StrZero( PVPHEAD->nRok, 4) + StrZero( PVPHEAD->nObdobi, 2)
  UCETSYS->( mh_SetScope('U'))
  UCETSYS->( dbSeek('U' + cObdDokl))

  do while .not. UCETSYS->(eof())
    if UCETSYS->nAKTUc_KS = 2 .and. !UCETSYS->lZavren
      AAdd(aRecUcetSys, UCETSYS->(recNo()))
    endif
    UCETSYS->(dbSkip())
  enddo
  UCETSYS->( mh_ClrScope())
  fordRec()
  *
  PVPITEMww->( dbEval( {|| aAdd( aRecPVPit, PVPITEMww->_nRecOr) }))
  *
  drgDBMS:open('UCETPOL',,,,, 'UCETPOLx')
  UCETPOLx->( AdsSetOrder( 'UCETPOL1'))
  cScope := Upper( ::cfg_cDenik) + StrZero( PVPHEAD->nDoklad, 10)
  UCETPOLx->( mh_ClrScope(), mh_SetScope( cScope),;
             dbEval( {|| aADD( aRecUcetPOL, UCETPOLx->( RecNo()) )}),;
             dbGoTOP() )

  isLock := ( PVPITEM->( sx_RLock( aRecPVPIT)) .and.   ;
              UCETSYS->( sx_RLock( aRecUcetSys)) .and. ;
              UCETPOLx->( sx_RLOCK( aRecUcetPOL)) )
  *
  IF isLock
    oMoment := SYS_MOMENT('Probíhá párování dle V-symbolu ...')
    * PVPITEM, UCETPOL
    PVPITEMww->( dbGoTop())
    DO WHILE !PVPITEMww->(Eof())
      PVPITEM->(dbGoTo( PVPITEMww->_nRecOr))
      PVPITEM->nCisFak  := PVPITEMww->nCisFak
      cKey := Upper( ::cfg_cDenik) + StrZero( PVPITEM->nDoklad, 10) + StrZero( PVPITEM->nOrdItem, 5)
      UCETPOLx->( mh_SetScope( cKey))
      DO WHILE !UCETPOLx->( Eof())
        UCETPOLx->cSymbol := alltrim( str(PVPITEMww->nCisFak))

* pokud na parametr, tak musí být jiný, pøíjem a výdej musí být nezávislé
*        UCETPOLx->cSymbol := if( ::cfg_lFakParSym, alltrim( str(PVPITEMww->nCisFak)), alltrim( str(PVPHEAD->nCisloDL)))
        UCETPOLx->( dbSkip())
      ENDDO
      UCETPOLx->( mh_ClrScope())
      PVPITEMww->( dbSkip())
    ENDDO
    * UCETSYS
    AEval(aRecUcetSys, {|x| ( UCETSYS->(dbGoTo(x))           , ;
                              UCETSYS->nAKTUc_KS := 1        , ;
                              UCETSYS->cuctKdo   := logOsoba , ;
                              UCETSYS->ductDat   := date()   , ;
                              UCETSYS->cuctCas   := time()   , ;
                              mh_WRTzmena( 'UCETSYS')  ) })
    *
    oMoment:destroy()

    PVPITEM->( dbCommit(), dbUnlock())
    UCETPOLx->( dbCommit(), dbUnlock(), mh_ClrScope())
    UCETSYS->( dbCommit(), dbUnlock() )
  ELSE
    drgMsgBox(drgNLS:msg('NELZE - soubory jsou blokovány jiným uživatelem ...'))
  ENDIF

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

RETURN self