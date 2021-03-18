#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


function MZD_kmenove_cpy(oDialog)
  local  lnewRec    := oDialog:lnewRec
  local  nKy        := if( lnewRec, 0, msPrc_mo->ncisOsoby )


  ** tmp **
  *
  * TAB - 1 - msPrc_moW, mimPrvztW, duchodyW, msOdpPolW
  drgDBMS:open( 'msPrc_moW', .T., .T., drgINI:dir_USERfitm); ZAP
  drgDBMS:open( 'mimPrvztW', .T., .T., drgINI:dir_USERfitm); ZAP
  drgDBMS:open( 'duchodyW' , .T., .T., drgINI:dir_USERfitm); ZAP
  drgDBMS:open( 'msOdpPolW', .T., .T., drgINI:dir_USERfitm); ZAP

  * TAB - 2 - msPrc_moW, msTarindW, msSazZamW
  drgDBMS:open( 'msTarindW', .T., .T., drgINI:dir_USERfitm); ZAP
  drgDBMS:open( 'msSazZamW', .T., .T., drgINI:dir_USERfitm); ZAP

  * TAb 3 - msSrz_moW
  drgDBMS:open( 'msSrz_moW', .T., .T., drgINI:dir_USERfitm); ZAP

  * TAB 4 - osobyW
  drgDBMS:open( 'osobyW'   , .T., .T., drgINI:dir_USERfitm); ZAP

  * TAB 5
  * vazOsobyW
  drgDBMS:open( 'vazOsobyW', .T., .T., drgINI:dir_USERfitm); ZAP

  * TAB 6
  * duchodyW
  drgDBMS:open( 'duchodyW' , .T., .T., drgINI:dir_USERfitm); ZAP

  msPrc_moW->(dbappend())
  osobyW   ->(dbappend())

  if .not. lnewRec

    mh_copyFld( 'msPrc_mo', 'msPrc_moW' )
/*
    mimPrvzt->( adsSetOrder('xx')           , ;
                dbsetScope( SCOPE_BOTH, nKy), ;
                dbgoTop()                   , ;
                dbEval( { || mh_copyFld('mimPrvzt', 'mimPrvztW', .t.) ) )

    duchody ->( adsSetOrder('DUCHODY04')   , ;
                dbsetScope(SCOPE_BOTH, nKy), ;
                dbgoTop()                  , ;
                dbEval( { || mh_copyFld('duchody', 'duchodyW', .t.) ) )

*/

  endif

return nil



*
** uloložení MS pracovníka *****************************************************
FUNCTION MZD_kmenove_wrt( odialog)
  LOCAL  anTAR := {}, lTAR := .T.                                 //__MSTARIND__
  LOCAL  anSAZ := {}, lSAZ := .T.                                 //__MSSAZZAM__
  LOCAL  anSRZ := {}, lSRZ := .T.                                 //__MSSRZ_MO__
  LOCAL  anMIM := {}, lMIM := .T.                                 //__MIMPRVZ __
  LOCAL  anDUC := {}, lDUC := .T.                                 //__DUCHODY __
  LOCAL  anODP := {}, lODP := .T.                                 //__MSODPPOL__
  LOCAL  lDONe := .T.
  local  newrec

  newrec := odialog:lNEWrec

  * 1
  MIMPRVZw  ->( ordSetFocus(0), ;
                dbgoTop()     , ;
                DbEval({||IF(MIMPRVZw ->_nrecor <>0,AAdd(anMIM,MIMPRVZw ->_nrecor), NIL)}))
    lMIM := MIMPRVZ  ->(sx_RLock(anMIM))

  DUCHODYw  ->( ordSetFocus(0), ;
                dbgoTop()     , ;
                DbEval({||IF(DUCHODYw ->_nrecor <>0,AAdd(anDUC,DUCHODYw ->_nrecor), NIL)}))
    lDUC := DUCHODY  ->(sx_RLock(anDUC))

  MSODPPOLw ->( ordSetFocus(0), ;
                dbgoTop()     , ;
                DbEval({||IF(MSODPPOLw->_nrecor <>0,AAdd(anODP,MSODPPOLw->_nrecor), NIL)}))
    lODP := MSODPPOL ->( sx_RLock(anODP))

  * 2
  MSTARINDw ->( ordSetFocus(0), ;
                dbgoTop()     , ;
                DbEval({||IF(MSTARINDw->_nrecor <>0,AAdd(anTAR,MSTARINDw->_nrecor), NIL)}))
    lTAR := MSTARIND ->(sx_RLock(anTAR))

  MSSAZZAMw ->( ordSetFocus(0), ;
                dbgoTop()     , ;
                DbEval({||IF(MSSAZZAMw->_nrecor <>0,AAdd(anSAZ,MSSAZZAMw->_nrecor), NIL)}))
    lSAZ := MSSAZZAM ->(sx_RLock(anSAZ))

  * 3
  MSSRZ_MOw ->( ordSetFocus(0), ;
                dbgoTop()     , ;
                DbEval({||IF(MSSRZ_MOw->_nrecor <>0,AAdd(anSRZ,MSSRZ_MOw->_nrecor), NIL)}))
    lSRZ := MSSRZ_MO ->(sx_RLock(anSRZ))


  IF lTAR .and. lSAZ .and. lSRZ .and. lMIM .and. lDUC .and. lODP .and. ;
     MSPRC_MO ->(sx_RLock()) .and. PERSONAL ->(sx_RLock())

     ModiMsPrc()
     ModiPersonal()
     ModiDochazka()

     msprc_moW->(dbCommit())

     mh_COPYFLD('MSPRC_MOw', 'MSPRC_MO', odialog:lNEWrec)

     newrec := !PERSONALc->( dbSeek( Upper( MSPRC_MOw->cRodCisPra),,'PERSONAL03'))
     mh_COPYFLD('PERSONALw', 'PERSONAL', newrec)

     * 1 záložka
     MZD_kmenove_all('MIMPRVZw' ,'MIMPRVZ' ,anMIM)    // PER_data * mimopracovní vztahy
     MZD_kmenove_all('DUCHODYw' ,'DUCHODY' ,anDUC)    // PER_data * dùchody
     MZD_kmenove_all('MSODPPOLw','MSODPPOL',anODP)    // MZD_data * odpoèitatelné položky

     * 2 záložka
     MZD_kmenove_all('MSTARINDw','MSTARIND',anTAR)    // MZD_data * individuální tarify
     MZD_kmenove_all('MSSAZZAMw','MSSAZZAM',anSAZ)    // MZD_data * sazby zamìstnancù

     * 3 záložka
     MZD_kmenove_all('MSSRZ_MOw','MSSRZ_MO',anSRZ)    // MZD_data * srážky za období

  ELSE
    drgMsgBox(drgNLS:msg('Nelze modifikovat KMENOVÉ údaje pracovníka, blokováno uživatelem !!!'))
    lDONe := .F.
  ENDIF


  MSPRC_MO ->(DbUnlockAll(), DbCommit())
   MSPRC_MD ->(DbUnlockAll(), DbCommit())
    PERSONAL ->(DbUnlockAll(), DbCommit())
     MSTARIND ->(DbUnlockAll(), DbCommit())
      MSSAZZAM ->(DbUnlockAll(), DBCommit())
       MSSRZ_MO ->(DbUnlockAll(), DBCommit())
        MIMPRVZ  ->(DbUnlockAll(), DBCommit())
         DUCHODY  ->(DbUnlockAll(), DBCommit())
          MSODPPOL ->(DbUnlockAll(), DBCommit())
RETURN lDONe


*
** pro uložení vazeb 1:N *******************************************************
STATIC PROCEDURE MZD_kmenove_all(inp,out,paLOCK)
  LOCAL recor,pos

  (inp) ->(DbGoTop())
  DO WHILE .not. (inp) ->(Eof())
    recor := (inp)->_nrecor

    IF(pos := AScan(paLOCK,recor)) <> 0
      (out) ->(DbGoTo(recor))
      (ADel(paLOCK,pos), ASize(paLOCK, LEN(paLOCK) -1))
    ENDIF

    IF( (inp) ->_delrec = '9', (out) ->(DbDelete()), mh_COPYFLD(inp, out, (pos = 0)))
    (inp)->(DbSkip())
  ENDDO

  AEval(paLOCK, {|x| (out) ->(DbGoTo(x),DbDelete()) })
  (out) ->(DbCommit(), DbUnLock())
RETURN


FUNCTION ModiMsPrc()
  local  pa

  pa := ListAsArray(allTrim( msprc_mow->cpracovnik), ' ')
  msprc_moW->cjmenoPrac := pa[1]
  msprc_moW->cprijPrac  := pa[2]
  msprc_mow->ctitulPrac := if( Len(pa) >= 3, pa[3], '' )
  msprc_moW->lStavem    := if( empty( msprc_moW->ddatVyst), .t.                               ;
                            , if( year( msprc_moW->ddatVyst) > uctOBDOBI:MZD:nROK, .t.        ;
                             , if( month( msprc_moW->ddatVyst) >= uctOBDOBI:MZD:nOBDOBI .AND. ;
                                year( msprc_moW->ddatVyst) = uctOBDOBI:MZD:nROK, .t., .f.)))
  msprc_moW->nStavem    := if( msprc_moW->lStavem, 1, 0)
  msprc_moW->lzdrPojis  := ( msprc_moW->lStavem .and. c_pracvz->lzdrPojis )
  msprc_moW->lsocPojis  := ( msprc_moW->lStavem .and. c_pracvz->lSocPojis )


  MSPRC_MOw->nTmOZprCMz  := 0
  MSPRC_MOw->cTmKmStrPr  := TMPkmenSTR( MSPRC_MOw->cKmenStrPr)
  IF MSPRC_MOw->nWkStation == 0
    MSPRC_MOw->nWkStation := SysConfig( 'SYSTEM:nWKStation')
  ENDIF
  EvidPocPrac( "MSPRC_MOw")
  lZMENvyst := MSPRC_MO->dDatVyst <> MSPRC_MOw->dDatVyst
  MSPRC_MOw->lPrukazZPS := IF( !Empty( MSPRC_MOw->cPrukazZPS), .T., .F.)

RETURN nil


FUNCTION ModiPersonal()

  mh_COPYFLD( 'MSPRC_MOw', 'PERSONALw')

  IF Empty( PERSONALw->dDatNaroz)
    IF SubStr( PERSONALw->cRodCisPra, 4, 1)  == "5"                     ;
         .OR. SubStr( PERSONALw->cRodCisPra, 4, 1) == "6"
      PERSONALw->dDatNaroz := CtoD( SubStr( PERSONALw->cRodCisPra, 7,2) +"/" ;
                                  +IF( SubStr( PERSONALw->cRodCisPra, 4, 1) == "5", "0", "1")    ;
                                     +SubStr( PERSONALw->cRodCisPra, 5, 1) +"/"                    ;
                                         +SubStr( PERSONALw->cRodCisPra, 1, 2))
    ELSE
      PERSONALw->dDatNaroz := CtoD( SubStr( PERSONALw->cRodCisPra, 7,2) +"/" ;
                                     +SubStr( PERSONALw->cRodCisPra, 4,2) +"/"     ;
                                         +SubStr( PERSONALw->cRodCisPra, 1,2))
    ENDIF
  ENDIF

RETURN nil


FUNCTION ModiDochazka()

  mh_COPYFLD( 'MSPRC_MOw', 'MSPRC_MDw')

  IF !MSPRC_MOw ->lExport
    MSPRC_MDw->nSazPrePr  := 0
    MSPRC_MDw->nSazOsoOh  := 0
    MSPRC_MDw->nSazOsoOh  := 0
    MSPRC_MDw->nSazOsoOh  := 0
    MSPRC_MDw->nHodPrumPP := 0
    MSPRC_MDw->nDenPrumPP := 0
  ENDIF
  MSPRC_MDw->cIdOsKarty := PERSONALw->cIdOsKarty

RETURN nil


FUNCTION KMENMz_WRT()
  LOCAL  lOK := .T.
  LOCAL  nX, lNEWpers, lNEWdoch
  LOCAL  cX
  LOCAL  lZMENvyst
  LOCAL  cOBDOBI

  IF cOldRC <> MSPRC_MOw->cRodCisPra
    lNEWpers := !PERSONAL->( dbSeek( Upper( cOldRC)))
  ELSE
    lNEWpers := !PERSONAL->( dbSeek( Upper( MSPRC_MOw->cRodCisPra)))
  ENDIF

  cOBDOBI := StrZero( uctOBDOBI:MZD:NROK, 4) +StrZero( uctOBDOBI:MZD:NOBDOBI, 2)
  lOK := IF( !( ::lNewREC), MSPRC_MO->( Sx_Rlock()), .T.)
  lOK := lOK .AND. IF( !lNEWpers, PERSONAL->( Sx_Rlock()), .T.)
  lOK := IF( LAST_OBDn( "M") == cOBDOBI, .T., .F.)

  IF lOK
*    cX := AllTrim( StrTran( MSPRC_MOw->cRodCisPra, "-", ""))
*    cX := AllTrim( StrTran( cX, "/", ""))

*    MSPRC_MOw->cPrijPrac  := mh_Token( MSPRC_MOw->cPracovnik, " ", 1)
*    MSPRC_MOw->cJmenoPrac := mh_Token( MSPRC_MOw->cPracovnik, " ", 2)
*    MSPRC_MOw->cTitulPrac := mh_Token( MSPRC_MOw->cPracovnik, " ", 3, 3)

*    MSPRC_MOw->cRodCisPrN := cX
*    MSPRC_MOw->nRodCisPra := Val( MSPRC_MOw->cRodCisPrN)
*    MSPRC_MOw->nMuz       := IF( SubStr( MSPRC_MOw->cRodCisPra, 4, 1) < "2", 1, 0)
*    MSPRC_MOw->nZena      := IF( SubStr( MSPRC_MOw->cRodCisPra, 4, 1) > "1", 1, 0)
*    MSPRC_MOw->nTMdatVyst := IF( Empty( MSPRC_MOw->dDatVyst), 99999999      ;
*                                 ,( ( Year( MSPRC_MOw->dDatVyst)  * 10000)  ;
*                                  +( Month( MSPRC_MOw->dDatVyst) *   100)  ;
*                                  +Day( MSPRC_MOw->dDatVyst)))
*    MSPRC_MOw->nClenSpol  := IF( MSPRC_MOw->nTypZamVzt == 2                    ;
*                                 .OR. MSPRC_MOw->nTypZamVzt == 3               ;
*                                  .OR. MSPRC_MOw->nTypZamVzt == 4, 1, 0)
    MSPRC_MOw->nTmOZprCMz        := 0
    MSPRC_MOw->cTmKmStrPr := TMPkmenSTR( MSPRC_MOw->cKmenStrPr)
    IF MSPRC_MOw->nWkStation == 0
      MSPRC_MOw->nWkStation := SysConfig( 'SYSTEM:nWKStation')
    ENDIF
    MSPRC_MOw->mPoznamka1 := mX
    EvidPocPrac( "MSPRC_MOw")
    lZMENvyst := MSPRC_MO->dDatVyst <> MSPRC_MOw->dDatVyst
    MSPRC_MOw->lPrukazZPS := IF( !Empty( MSPRC_MOw->cPrukazZPS), .T., .F.)

    MSPRC_MOw->nstavem    := if( MSPRC_MOw->lstavem,1,0)

    MH_CopyFLD( 'MSPRC_MOw', 'MSPRC_MO', ::lNewREC)

    IF( lZMENvyst, UpravDATvy(), NIL)

//    mh_WRTzmena( 'MSPRC_MO', ::lNewREC)

    IF !Empty( MSPRC_MOw->cRodCisPra)
      PERSONALw->nOsCisPrac := MSPRC_MOw->nOsCisPrac
      PERSONALw->cPracovnik := MSPRC_MOw->cPracovnik
      PERSONALw->cRodCisPra := MSPRC_MOw->cRodCisPra
      PERSONALw->cRodCisPrN := MSPRC_MOw->cRodCisPrN
      IF Empty( PERSONALw->dDatNaroz)
        IF SubStr( PERSONALw->cRodCisPra, 4, 1)  == "5"                     ;
             .OR. SubStr( PERSONALw->cRodCisPra, 4, 1) == "6"
          PERSONALw->dDatNaroz := CtoD( SubStr( PERSONALw->cRodCisPra, 7,2) +"/" ;
                                       +IF( SubStr( PERSONALw->cRodCisPra, 4, 1) == "5", "0", "1")    ;
                                     +SubStr( PERSONALw->cRodCisPra, 5, 1) +"/"                    ;
                                         +SubStr( PERSONALw->cRodCisPra, 1, 2))
        ELSE
               PERSONALw->dDatNaroz := CtoD( SubStr( PERSONALw->cRodCisPra, 7,2) +"/" ;
                                           +SubStr( PERSONALw->cRodCisPra, 4,2) +"/"     ;
                                             +SubStr( PERSONALw->cRodCisPra, 1,2))
        ENDIF
      ENDIF
      PERSONALw->cKmenStrPr := MSPRC_MOw->cKmenStrPr
      PERSONALw->cNazPol1   := MSPRC_MOw->cNazPol1
      PERSONALw->cPrijPrac  := MSPRC_MOw->cPrijPrac
      PERSONALw->cJmenoPrac := MSPRC_MOw->cJmenoPrac
      PERSONALw->cTitulPrac := MSPRC_MOw->cTitulPrac
      PERSONALw->nMuz       := MSPRC_MOw->nMuz
      PERSONALw->nZena      := MSPRC_MOw->nZena
      PERSONALw->cPohlavi   := IF( MSPRC_MOw ->nMuz = 1, "Muž ", "Žena")
      PERSONALw->nTypDuchod := MSPRC_MOw->nTypDuchod
      PERSONALw->nPorPraVzt := MSPRC_MOw->nPorPraVzt
      PERSONALw->nTypPraVzt := MSPRC_MOw->nTypPraVzt
      PERSONALw->nTypZamVzt := MSPRC_MOw->nTypZamVzt
      PERSONALw->dDatVznPrV := MSPRC_MOw->dDatVznPrV
      PERSONALw->dDatNast   := MSPRC_MOw->dDatNast
      PERSONALw->dDatVyst   := MSPRC_MOw->dDatVyst
      PERSONALw->dDatPredVy := MSPRC_MOw->dDatPredVy
      PERSONALw->nTypUkoPrV := MSPRC_MOw->nTypUkoPrV
      PERSONALw->cPracZar   := MSPRC_MOw->cPracZar
      PERSONALw->cFunPra    := MSPRC_MOw->cFunPra
      PERSONALw->cNazPol4   := MSPRC_MOw->cNazPol4
      PERSONALw->cVyplMist  := MSPRC_MOw->cVyplMist
      PERSONALw->lStavem    := MSPRC_MOw->lStavem
//      IF( !Empty( .GetLISTb), DBPutVal( .axEDITb[ 7, 5], .GetLISTb[7]:VarGet()), NIL)
      mh_CopyFLD( 'PERSONALw', 'PERSONAL', lNEWpers)
      mh_WRTzmena( 'PERSONAL', lNEWpers)
    ENDIF

    lNEWdoch := !MSPRC_MD->( dbSeek( MSPRC_MOw->nOsCisPrac))

     PERSONAL->( Sx_Rlock())
    IF( !lNEWdoch, MSPRC_MD->( Sx_Rlock()), NIL)
    mh_CopyFLD( 'MSPRC_MOw', 'MSPRC_MD', lNEWdoch)
    IF !MSPRC_MOw ->lExport
      MSPRC_MD->nSazPrePr  := 0
      MSPRC_MD->nSazOsoOh  := 0
      MSPRC_MD->nSazOsoOh  := 0
      MSPRC_MD->nSazOsoOh  := 0
      MSPRC_MD->nHodPrumPP := 0
      MSPRC_MD->nDenPrumPP := 0
    ENDIF
    MSPRC_MD->cIdOsKarty := PERSONALw->cIdOsKarty
    mh_WRTzmena( 'MSPRC_MD', lNEWdoch)
/*
    W_PrSmlDoh()
    W_MsOdpPol()
    IF( MsSrzP ->( LastRec()) > 0,      W_MsSrz_Mz(), NIL)
    IF( !Empty( MSPRC_MOw ->dPlatSazOd), W_MsSazZam(), NIL)
    IF( !Empty( MSPRC_MOw ->dPlatTarOd), W_MsTarInd(), NIL)
    IF( Empty( MSPRC_MOw ->dDatVyst),    W_C_OdpMis(), NIL)   // mus¡ bìt na konfiguraci !!!!
    IF( Empty( MSPRC_MOw ->dDatVyst),    W_C_Zamest(), NIL)
    IF( RodPrisP ->( LastRec()) > 0,    W_RodPrisl(), NIL)
    IF( DuchodP ->( LastRec()) > 0,     W_Duchody(),  NIL)
    IF( MimPrVzP ->( LastRec()) > 0,                 W_MimPrVz(),  NIL)
    ::lWrtREC := .T.
    ( MSPRC_MO ->( Sx_Unlock()), PERSONAL ->( Sx_Unlock()),MsPrc_Md ->( Sx_Unlock()))
    ( __KillREAD(), __KeyBoard( Chr( K_ESC)))
//                IF SysConfig( "Mzdy:nTypVypoCM") = 1                                     ;
//                         .AND. ( MSPRC_MO ->nTypVypoCM = 1)
//            CmVypoc(, 9)
//                ENDIF

*/
  ELSE
    IF LAST_OBDn( "M") <> cOBDOBI
//      Box_WARING( "Nem…§ete ukl dat v jin‚m ne§ posledn¡m - aktu ln¡m obdob¡ !!! ")
    ELSE
//      Box_WARING( "Poý¡zen‚ £daje nelze ulo§it, BLOKOVµNO jinìm u§ivatelem ...")
    ENDIF
  ENDIF

RETURN( NIL)


FUNCTION UpravDATvy()
  LOCAL cOldOrd, nOldRec, lWRT
  LOCAL dTMPnast, dTMPvyst
  LOCAL xKey

  dTMPnast := MSPRC_MO->dDatNast
  dTMPvyst := MSPRC_MO->dDatVyst
  xKey     := StrZero( MSPRC_MO->nOsCisPrac) +StrZero( MSPRC_MO->nPorPraVzt)
  cOldOrd  := MSPRC_MO->( AdsSetOrder())
  nOldRec  := MSPRC_MO->( Recno())

  MSPRC_MO->( AdsSetOrder(10),                                                 ;
              ADS_SetScope( SCOPE_TOP, xKey),                                  ;
              ADS_SetScope( SCOPE_BOTTOM, xKey),                               ;
              dbGoBotTom())

   DO WHILE !MSPRC_MO->( Eof())
     lWRT    := .F.
     IF Empty( MSPRC_MO->dDatVyst) .AND. !Empty( MSPRC_MO->dDatVyst)
       lWRT := .T.
     ELSE
       IF !Empty( MSPRC_MO->dDatVyst)
         IF Year( MSPRC_MO->dDatVyst) <= MSPRC_MO->nRok                    ;
              .AND. Month( MSPRC_MO->dDatVyst) <= MSPRC_MO->nObdobi
           lWRT := MSPRC_MO->dDatVyst <> MSPRC_MO->dDatVyst
         ELSE
           IF Year( MSPRC_MO->dDatVyst) < MSPRC_MO->nRok
             lWRT := MSPRC_MO->dDatVyst <> MSPRC_MO->dDatVyst
           ENDIF
         ENDIF
       ENDIF
     ENDIF

     IF lWRT .AND. MSPRC_MO->( Sx_RLock())
       MSPRC_MO->dDatVyst := MSPRC_MO->dDatVyst
       MSPRC_MO->( dbUnlock())
     ENDIF
     MSPRC_MO->( dbSkip())
   ENDDO

  MSPRC_MO->( ADS_ClearScope( SCOPE_TOP),                                      ;
             ADS_ClearScope( SCOPE_BOTTOM),                                   ;
             AdsSetOrder(cOldOrd),                                               ;
             dbGoTo(nOldRec))

RETURN( NIL)