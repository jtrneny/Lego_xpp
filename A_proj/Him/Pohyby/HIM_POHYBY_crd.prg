********************************************************************************
* HIM_POHYBY_crd.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "dmlb.ch"
#include "..\HIM\HIM_Him.ch"

********************************************************************************
* HIM_POHYBY_CRD ... Tvorba pohybových dokladù
********************************************************************************
CLASS HIM_POHYBY_crd FROM drgUsrClass
EXPORTED:
  VAR     cTASK, isHIM, fiMAJ, fiZMAJU, fiZMAJUw, fiCIS, fiSUMMAJ
  VAR     nKARTA, lNewREC, nRoundOdpi, cAktOBD, nAktOBD, nAktROK
  VAR     varsORG, membORG

  METHOD  Init, Destroy
  METHOD  ItemMarked
  METHOD  drgDialogStart, eventHandled
  METHOD  postValidate
  METHOD  C_TypPOH_SEL, LikvDOKL
  METHOD  ZMajU_MODI

HIDDEN
  VAR     dm, dc, df, oBro
  VAR     nPorZmeny, cDenik, cUserAbb, nZmenVstCU_org, nZmenOprU_org
  VAR     nLenINVCIS

  METHOD  modiCard, DoZmena
  METHOD  NStoZMAJU, CisDokl_UO
  METHOD  Maj_MODI, SumMaj_MODI, ReKUMUL, AllOK, refresh_SCR

  INLINE METHOD RowPosZME()
    RETURN ::dc:oBrowse[1]:oXbp:rowPos

ENDCLASS

********************************************************************************
METHOD HIM_POHYBY_crd:init(parent, cTASK)

  ::drgUsrClass:init(parent)
  DEFAULT cTASK TO 'HIM'
  ::cTASK := cTASK
  ::isHIM    := ( ::cTASK = 'HIM')
  ::fiMAJ    := IF( ::isHIM, 'MAJ'   , 'MAJZ'  )
  ::fiZMAJU  := IF( ::isHIM, 'ZMAJU' , 'ZMAJUZ')
  ::fiZMAJUw := ::fiZMAJU + 'w'
  ::fiSUMMAJ := IF( ::isHIM, 'SUMMAJ', 'SUMMAJZ')
  ::fiCIS    := 'C_TYPPOH'
  ::cAktOBD  := uctOBDOBI:&(::cTask):cObdobi
  ::nAktOBD  := uctOBDOBI:&(::cTask):nObdobi
  ::nAktROK  := uctOBDOBI:&(::cTask):nRok

  drgDBMS:open( ::fiZMAJU  ) ; (::fiZMAJU)->( AdsSetOrder(2))
  drgDBMS:open( ::fiMAJ    ) ; (::fiMAJ)->( AdsSetOrder(1))
  drgDBMS:open( ::fiSUMMAJ )
  drgDBMS:open( ::fiCIS    )
  drgDBMS:open( 'C_DanSKP' )
  drgDBMS:open( 'C_UcetSKP')
  drgDBMS:open( 'C_TYPPOH' )
  drgDBMS:open( 'UCETPOL'  )
  IF( ::isHIM, drgDBMS:open( 'C_TYPMAJ' ),;
               drgDBMS:open( 'C_UCTSKZ' ) )
  *
  drgDBMS:open( ::fiZMAJUw ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  (::fiZMAJUw)->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU))', 'C_TYPPOH05'))
  (::fiZMAJUw)->( AdsSetOrder(2))
  *
  ::nKARTA     := 999
  ::nPorZmeny  := 0
  ::lNewREC    := .F.
  ::nRoundOdpi := IF( ::isHIM , SysConfig( 'Im:nRoundOdpi'  ),;
                                SysConfig( 'Zvirata:nRoundOdpi') )
  ::cDenik     := IF( ::isHIM , PadR( SysConfig( 'Im:cDenikIm'     ), 2 ),;
                                PadR( SysConfig( 'Zvirata:cDenikZv'), 2 ) )
  ::cUserAbb   :=  SysConfig( 'System:cUserAbb')

RETURN self

********************************************************************************
METHOD HIM_POHYBY_crd:drgDialogStart(drgDialog)
  Local  members  := drgDialog:dialogCtrl:members[1]:aMembers, x, cSCOPE
  *
  ColorOfText( members)
  *
  ::dm         := ::drgDialog:dataManager
  ::dc         := ::drgDialog:dialogCtrl
  ::df         := ::drgDialog:oForm
  ::oBro       := ::dc:oBrowse[1]
  ::membORG    := ::dc:members[1]:aMembers
  ::varsORG    := ::dm:vars
  ::nLenINVCIS := (::fiMAJ)->( FieldInfo( (::fiMAJ)->(FieldPos('nInvCis')),FLD_LEN))
  *
  ::refresh_SCR()
  *
RETURN self

********************************************************************************
METHOD HIM_POHYBY_crd:EventHandled(nEvent, mp1, mp2, oXbp)
  Local oMoment

  DO CASE
  CASE nEvent = drgEVENT_OBDOBICHANGED
    *
    ::cAktOBD  := uctOBDOBI:&(::cTask):cObdobi
    ::nAktOBD  := uctOBDOBI:&(::cTask):nObdobi
    ::nAktROK  := uctOBDOBI:&(::cTask):nRok

    ::refresh_SCR()
    *
  CASE nEvent = drgEVENT_EDIT
    IF ::AllOK()
      ::DoZmena( nEvent)
    ENDIF

  CASE  nEvent = drgEVENT_APPEND
    IF ::AllOK( .T.)
      ::DoZmena( nEvent, mp1, mp2, oXbp)
    ENDIF

  CASE  nEvent = drgEVENT_DELETE
    IF ::AllOK()
      ::DoZmena( nEvent)
    ENDIF

  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE  nEvent = drgEVENT_SAVE
    IF oXbp:ClassName() <> 'XbpBrowse'
      oMoment := SYS_MOMENT( '=== UKLÁDÁM DOKLAD ===')
      *
      ::ZMajU_MODI( IF( ::lNewREC, xbeK_INS, xbeK_ENTER) )
      *
      ::oBro:oXbp:refreshAll()
      SetAppFocus( ::oBro:oXbp)
      ::itemMarked()

      _clearEventLoop(.t.)
      oMoment:destroy()
    ENDIF
*    PostAppEvent(xbeP_Close,drgEVENT_EXIT,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      IF oXbp:ClassName() = 'XbpBrowse'
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,, ::drgDialog:dialog)
      ELSE
        IF ::lNewREC
          (::fiZMAJUw)->( dbDelete(), dbGoTOP())

          ::nKarta := IF( (::fiZMAJUw)->nKarta = 0, 999, (::fiZMAJUw)->nKarta )
          ::modiCard()
          ::oBro:oXbp:refreshAll()
          SetAppFocus( ::oBro:oXbp)
          ::itemMarked()
        else
          SetAppFocus( ::oBro:oXbp)
        ENDIF
      ENDIF
    CASE mp1 = xbeK_DEL
      ::DoZmena( drgEVENT_DELETE)
    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

* HIDDEN************************************************************************
METHOD HIM_POHYBY_crd:doZmena( nEvent, mp1, mp2, oXbp)
  Local  nPohyb, cMsg

*  (::fiZMAJUw)->( dbGoTOP())
  nPohyb := Int( (::fiZMAJUw)->nKarta / 100 )
*  ::nPorZmeny := (::fiZMAJUw)->nPorZmeny

  DO CASE
  CASE ( nPohyb == 0 .and. (::fiMAJ)->nZnAkt = VYRAZEN )
    drgMsgBox(drgNLS:msg( 'N E L Z E , majetek je již vyøazen !' ))

  CASE nEvent = drgEVENT_EDIT
    IF ::RowPosZME() = 1
      ::lNewREC := .F.
      Do Case
      Case nPohyb = VSTUPNI
        IF Empty( (::fiMAJ)->cObdPosOdp )
          RETURN .f.
        ELSE
          drgMsgBox(drgNLS:msg( 'Vstupní pohyb nelze modifikovat, nebo již probìhl mìsíèní odpis !' ))
        ENDIF
      Case ( nPohyb == 0 .and. (::fiMAJ)->nZnAkt <> VYRAZEN )
         If nPohyb == 0 ; drgMsgBox(drgNLS:msg( 'Není co opravit !' ))
         Endif
      Case nPohyb = BEZNY
        IF (::fiZMAJUw)->nKarta = 204
          drgMsgBox(drgNLS:msg( 'Úèetní odpis nelze opravit !'))
        ELSE
          ::df:setNextFocus( ::fiZMAJUw + '->nDoklad',, .T. )
        ENDIF
      Case nPohyb = VYSTUPNI
        drgMsgBox(drgNLS:msg( 'NELZE, majetek je již vyøazen !'))
      OtherWise
      EndCase
    ELSE

    ENDIF

  CASE  nEvent = drgEVENT_APPEND
    ::lNewREC := .T.
    *
    (::fiZMAJUw)->( dbGoTOP())
    ::nPorZmeny := (::fiZMAJUw)->nPorZmeny
    Do Case
    Case nPohyb = VYSTUPNI
       drgMsgBox(drgNLS:msg( 'Majetek je již vyøazen !' ))
    OtherWise
      (::fiZMAJUw)->( dbAppend())
      (::fiZMAJUw)->dDatZmeny := date()
      ::nKARTA := 999
      ::modiCard()
      *
      IsEditGET( CRD_204    , ::drgDialog, .T.)
      *
      ::df:setNextFocus( ::fiZMAJUw +'->cTypPohybu',, .T. )
      ::dm:refresh()

    EndCase

  CASE  nEvent = drgEVENT_DELETE
    IF ::RowPosZME() = 1
      (::fiZMAJU)->( dbGoTO( (::fiZMAJUw)->_nrecor))
      nPohyb := Int( (::fiZMAJU)->nKarta / 100 )
      Do Case
      Case nPohyb = VSTUPNI
         drgMsgBox(drgNLS:msg( 'Vstupní pohyb nelze zrušit !' ))
      Case nPohyb = BEZNY  .or. ( nPohyb == 0 .and. (::fiMAJ)->nZnAkt <> VYRAZEN )
         If nPohyb == 0 ; drgMsgBox(drgNLS:msg( 'Není co zrušit !' ))
         Else           ; ::ZMajU_MODI( xbeK_DEL)
         Endif
      Case nPohyb = VYSTUPNI
        ::ZMajU_MODI( xbeK_DEL)
      EndCase

      (::fiZMAJUw)->( dbGoTop())
      ::oBro:oXbp:refreshAll()
      ::itemMarked()
      *
    ELSE
      drgMsgBox(drgNLS:msg( 'N E L Z E  rušit zmìnu mimo posloupnost !' ))
    ENDIF
  ENDCASE

RETURN SELF

* HIDDEN************************************************************************
METHOD HIM_POHYBY_crd:ZMAJU_MODI( nKEY, fromCRD)
  Local nDoklad, lSumMajEXIST, lOK
  Local Lock, LockMAJ, LockSumMaj, LockZMAJU
  Local uctLikv, cKEY

  DEFAULT fromCRD TO .T.
  *

  drgDBMS:open( 'C_TYPPOH',,,,,'C_TYPPOHa' )

  DO CASE
  CASE nKEY = xbeK_INS  .or. nKEY = xbeK_ENTER
*     IF( fromCRD, ::dm:save(), NIL)
     IF fromCRD
       ::dm:save()
       (::fiZMAJUw)->nProcDanOo := ::dm:get( ::fiZMAJUw + '->nProcDanOo')
       (::fiZMAJUw)->nProcDanOn := ::dm:get( ::fiZMAJUw + '->nProcDanOn')
       (::fiZMAJUw)->nProcUctOo := ::dm:get( ::fiZMAJUw + '->nProcUctOo')
     ENDIF

     IF nKEY = xbeK_INS
       nDoklad := ::CisDokl_UO()
*       mh_COPYFLD( ::fiMAJ, ::fiZMAJUw )
       IF( ::isHIM, (::fiZMAJUw)->nTypMaj   := (::fiMAJ)->nTypMaj,;
                    (::fiZMAJUw)->nUcetSkup := (::fiMAJ)->nUcetSkup)
       (::fiZMAJUw)->cUcetSkup := IF( ::isHIM, ALLTRIM( STR( (::fiMAJ)->nTypMaj  )),;
                                               ALLTRIM( STR( (::fiMAJ)->nUcetSkup)))
       (::fiZMAJUw)->nInvCis   := (::fiMAJ)->nInvCis
       (::fiZMAJUw)->cNazev    := (::fiMAJ)->cNazev
       *
       cKEY := IF( ::isHIM, I_DOKLADY, Z_DOKLADY) + (::fiZMAJUw)->cTypPohybu
       lOK := C_TypPOHa->( dbSEEK( cKEY,, 'C_TYPPOH02'))
       (::fiZMAJUw)->cTypDoklad := IF( lOK, C_TypPoha->cTypDoklad, '???' )
       (::fiZMAJUw)->cTypPohybu := IF( lOK, C_TypPoha->cTypPohybu, '???' )
       *
       (::fiZMAJUw)->nKARTA    := ::nKARTA
       (::fiZMAJUw)->nPorZmeny :=  If( ::nPorZmeny > 0, ::nPorZmeny - 1,;
                                      Val( Right( ::cAktObd, 2) + Left( ::cAktObd, 2) + '99') )
       (::fiZMAJUw)->nTypPohyb  := C_TypPoha->nTypPohyb
       (::fiZMAJUw)->cObdobi    := ::cAktObd
       (::fiZMAJUw)->nRok       := ::nAktRok  // uctOBDOBI:&(::cTask):nRok
       (::fiZMAJUw)->nObdobi    := ::nAktObd
       (::fiZMAJUw)->cUserAbb   := ::cUserAbb
       (::fiZMAJUw)->cUloha     := IF( ::isHIM, 'I', 'Z' )
       (::fiZMAJUw)->cDenik     := ::cDenik
       ::NStoZMAJU()

      Do Case
      Case ::nKARTA == 204                        //  úèetní odpis
        (::fiZMAJUw)->nDoklad    := ++nDoklad
        (::fiZMAJUw)->dDatZmeny  := Date()
        (::fiZMAJUw)->nKusy      := (::fiMAJ)->nKusy
        (::fiZMAJUw)->nUctOdpMes := (::fiMAJ)->nUctOdpMes

      Case ::nKARTA == 301 .or. ::nKARTA == 302  //  prodej
        (::fiZMAJUw)->nCenaVstU  := (::fiMAJ)->nCenaVstU
        (::fiZMAJUw)->nZustCenaU := (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct

      Case ::nKARTA == 205     //  doúètování úè.odpisu pøi roèní uzávìrce
        (::fiZMAJUw)->nDoklad    := ++nDoklad
        (::fiZMAJUw)->dDatZmeny  := Date()
        (::fiZMAJUw)->nKusy      := (::fiMAJ)->nKusy
        (::fiZMAJUw)->nTypPohyb  := If( (::fiZMAJUw)->nZmenOprU > 0, 1, -1 )
  * ???      (::fiZMAJUw)->nZmenOprU  := nRozdil

      Case ::nKARTA == 206     //  pøevod ze ZS do zásob - JEN ZVIRATA
        (::fiZMAJUw)->nCenaVstU  := (::fiMAJ)->nCenaVstU
        (::fiZMAJUw)->nZustCenaU := (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct
        (::fiZMAJUw)->nKusy      := 1
  *      (::fiZMAJUw)->nDokl183   := NewDoklZSB()
      EndCase

      *
      (::fiZMAJUw)->nOrdItem  := HIM_OrdItem( (::fiZMAJUw)->nDoklad, ::isHIM )
      (::fiZMAJU)->( dbAppend())
      (::fiZMAJUw)->_nrecor := (::fiZMAJU)->( RecNO())
      *
    ELSEIF nKEY = xbeK_ENTER
      (::fiZMAJUw)->cUserAbb   := ::cUserAbb
      ::NStoZMAJU()
    ENDIF

    * 21.10.2008
    (::fiZMAJUw)->nCenaPorUo := (::fiZMAJUw)->nCenaVstUo + (::fiMAJ)->nDotaceUct
    (::fiZMAJUw)->nCenaPorDo := (::fiZMAJUw)->nCenaVstDo + (::fiMAJ)->nDotaceDan
    (::fiZMAJUw)->nCenaPorUn := (::fiZMAJUw)->nCenaVstUn + (::fiMAJ)->nDotaceUct
    (::fiZMAJUw)->nCenaPorDn := (::fiZMAJUw)->nCenaVstDn + (::fiMAJ)->nDotaceDan
    *
    IF IsNIL( cKEY := (::fiZMAJU)->( dbSCOPE( SCOPE_TOP)) )
      cKEY := IF( ::isHIM, uctObdobi:HIM:cObdobi + StrZero( MAJ->nTypMaj,3) + StrZero(MAJ->nInvCis,15),;
                           uctObdobi:ZVI:cObdobi + StrZero( MAJZ->nUcetSkup,3) + StrZero(MAJZ->nInvCis,15) )
    ENDIF
    lSumMajEXIST := (::fiSUMMAJ)->( dbSeek( cKEY,,AdsCtag(1) ))
**MP    IF( lSumMajEXIST, NIL, (::fiSUMMAJ)->( dbAppend()) )
    *
    Lock := (::fiZMAJU)->( sx_RLock())  .and. ;
            IF( fromCRD, (::fiMAJ)->( sx_RLock()), .T.)    .and. ;
            (::fiSUMMAJ)->( sx_RLock())

    IF Lock
       ::nZmenVstCU_org := (::fiZMAJU)->nZmenVstCU
       ::nZmenOprU_org  := (::fiZMAJU)->nZmenOprU
       mh_COPYFLD( ::fiZMAJUw, ::fiZMAJU )
       *
*       IF ( nPos := ASCAN( { 201,202,203 }, (::fiZMAJU)->nKarta )) = 0
       IF ::lNewREC
         (::fiZMAJU)->nCenaPorUo := (::fiMAJ)->nCenaPorU
         (::fiZMAJU)->nCenaPorDo := (::fiMAJ)->nCenaPorD
         (::fiZMAJU)->nDotaceUo  := (::fiMAJ)->nDotaceUct
         (::fiZMAJU)->nDotaceDo  := (::fiMAJ)->nDotaceDan
         (::fiZMAJU)->nCenaVstUo := (::fiMAJ)->nCenaVstU
         (::fiZMAJU)->nCenaVstDo := (::fiMAJ)->nCenaVstD
         (::fiZMAJU)->nOprUcto   := (::fiMAJ)->nOprUct
         (::fiZMAJU)->nOprDano   := (::fiMAJ)->nOprDan
         (::fiZMAJU)->nProcDanOo := (::fiMAJ)->nProcDanOd
         (::fiZMAJU)->nDanOdpRo  := (::fiMAJ)->nDanOdpRok
         (::fiZMAJU)->nProcUctOo := (::fiMAJ)->nProcUctOd
         (::fiZMAJU)->nUctOdpRo  := (::fiMAJ)->nUctOdpRok
         (::fiZMAJU)->nUctOdpMo  := (::fiMAJ)->nUctOdpMes
         (::fiZMAJU)->nZnAkto    := (::fiMAJ)->nZnAkt
         (::fiZMAJU)->cObdZvyso  := (::fiMAJ)->cObdZvys
         (::fiZMAJU)->nZnAktDo   := (::fiMAJ)->nZnAktD
         (::fiZMAJU)->nrokZvDANo := (::fiMAJ)->nrokZvDANo

       ENDIF
       *
       ::Maj_MODI( nKEY)
       ::SumMaj_MODI( nKEY, lSumMajEXIST )
       uctLikv := UCT_likvidace():New(Upper( (::fiZMAJU)->cUloha) + Upper( (::fiZMAJU)->cTypDoklad),.T.)
       *
       HIM_LikCelDok( ::isHIM)
       (::fiZMAJU)->( dbUnlock())
       IF( fromCRD, (::fiMAJ)->( dbUnlock()), NIL )
       (::fiSumMAJ)->( dbUnlock())
    ENDIF

  CASE nKEY = xbeK_DEL
    *
    IF (::fiZMAJUw)->cTypPohybu = UCETNI_ODPIS_HIM       .or. ;
       (::fiZMAJUw)->cTypPohybu = DOUCTOVANI_ODPISU_HIM  .or. ;
       (::fiZMAJUw)->cTypPohybu = UCETNI_ODPIS_ZS        .or. ;
       (::fiZMAJUw)->cTypPohybu = DOUCTOVANI_ODPISU_ZS

      drgMsgBox(drgNLS:msg( 'Není povolena práce s tímto druhem pohybu !' ))
      RETURN NIL
    ENDIF
    *
    IF mh_ObdToVal( (::fiZMAJUw)->cObdobi) < mh_ObdToVal( (::fiMAJ)->cObdPosOdp)
      drgMsgBox(drgNLS:msg( 'Nelze zrušit zmìnu v období, které již prošlo uzávìrkou !' ))
      RETURN NIL
    ENDIF
    *
    IF drgIsYesNo(drgNLS:msg( 'Požadujete zrušit úèetní zmìnu ?' ))
      cKey := (::fiZMAJUw)->cObdobi + ;
              IF( ::isHIM, StrZero( (::fiMaj)->nTypMaj,3), StrZero( (::fiMaj)->nUcetSkup,3) ) + ;
                           StrZero( (::fiMaj)->nInvCis, 15 )
      (::fiZMAJU)->( dbGoTO( (::fiZMAJUw)->_nrecor ))
      lockZMAJU    := (::fiZMAJU)->( sx_RLock())
      lockMAJ      := (::fiMAJ)->( sx_RLock())
      lSumMajExist := (::fiSumMaj)->( dbSeek( cKey,,AdsCtag(1)))
      lockSUMMAJ   := IF( lSumMajExist, (::fiSumMAJ)->( sx_RLock()), .T. )
      *
      IF ( Lock := lockZMAJU .and. lockMAJ .and. lockSUMMAJ )
        *
        ::Maj_MODI( nKEY)
        ::SumMaj_MODI( nKEY, lSumMajExist )
        HIM_UcetPOL_DEL( ::cTASK)
        *
        IF ::cTASK = 'ZVI'
          IF (::fiZMAJUw)->nKARTA == 206
*=             PrevodDoZSB( nKey)
          ENDIF
        ENDIF
        (::fiZMAJU)->( dbDelete(), dbUnlock())
        (::fiZMAJUw)->( dbDelete(), dbUnlock())
        (::fiMAJ)->( dbUnlock())
        (::fiSumMAJ)->( dbUnlock())
      ENDIF
      *
      ::oBro:oXbp:refreshAll()
*      SetAppFocus( ::oBro:oXbp)    //( ::dc:oaBrowse:oXbp)
      ::nKARTA := (::fiZMAJUw)->nKarta
      ::modiCard()
      ::itemMarked()
      *
    ENDIF

  ENDCASE

RETURN self

* HIDDEN************************************************************************
METHOD HIM_POHYBY_crd:Maj_MODI( nKEY)
  Local  nTypPohyb := Int( (::fiZMAJU)->nKarta / 100 ), nDanOdpRok, nZustCenaD
  Local  isDEL := ( nKey = xbeK_DEL), nPOS

  IF isDEL
    (::fiMAJ)->nCenaPorU  := (::fiZMAJU)->nCenaPorUo
    (::fiMAJ)->nCenaPorD  := (::fiZMAJU)->nCenaPorDo
    (::fiMAJ)->nDotaceUct := (::fiZMAJU)->nDotaceUo
    (::fiMAJ)->nDotaceDan := (::fiZMAJU)->nDotaceDo
    (::fiMAJ)->nCenaVstU  := (::fiZMAJU)->nCenaVstUo
    (::fiMAJ)->nCenaVstD  := (::fiZMAJU)->nCenaVstDo
    (::fiMAJ)->nOprUct    := (::fiZMAJU)->nOprUcto
    (::fiMAJ)->nOprDan    := (::fiZMAJU)->nOprDano
    (::fiMAJ)->nProcDanOd := (::fiZMAJU)->nProcDanOo
    (::fiMAJ)->nDanOdpRok := (::fiZMAJU)->nDanOdpRo
    (::fiMAJ)->nProcUctOd := (::fiZMAJU)->nProcUctOo
    (::fiMAJ)->nUctOdpRok := (::fiZMAJU)->nUctOdpRo
    (::fiMAJ)->nUctOdpMes := (::fiZMAJU)->nUctOdpMo
    (::fiMAJ)->nZnAkt     := (::fiZMAJU)->nZnAkto
    (::fiMAJ)->nZnAktD    := (::fiZMAJU)->nZnAktDo
    (::fiMAJ)->cObdZvys   := (::fiZMAJU)->cObdZvyso
    (::fiMAJ)->nRokZvDanO := (::fiZMAJU)->nRokZvDanO

    if (::fiZMAJU)->nZnAktn = VYRAZEN .and. (::fiZMAJU)->nZnAktDn = VYRAZEN
      (::fiMAJ)->dDatVyraz  := CtoD( '  .  .  ')
      (::fiMAJ)->cObdVyraz  := '     '
    endif
    *
  ELSEIF ( nPos := ASCAN( { 201,202,203,207 }, (::fiZMAJU)->nKarta )) > 0
    (::fiMAJ)->nCenaPorU  := (::fiZMAJU)->nCenaPorUn
    (::fiMAJ)->nCenaPorD  := (::fiZMAJU)->nCenaPorDn
    (::fiMAJ)->nDotaceUct := (::fiZMAJU)->nDotaceUn
    (::fiMAJ)->nDotaceDan := (::fiZMAJU)->nDotaceDn
    (::fiMAJ)->nCenaVstU  := (::fiZMAJU)->nCenaVstUn
    (::fiMAJ)->nCenaVstD  := (::fiZMAJU)->nCenaVstDn
    (::fiMAJ)->nProcDanOd := (::fiZMAJU)->nProcDanOn
    (::fiMAJ)->nDanOdpRok := (::fiZMAJU)->nDanOdpRn
    (::fiMAJ)->nProcUctOd := (::fiZMAJU)->nProcUctOn
    (::fiMAJ)->nUctOdpRok := (::fiZMAJU)->nUctOdpRn
    (::fiMAJ)->nUctOdpMes := (::fiZMAJU)->nUctOdpMn

    if( nKey == xbeK_INS, nil, (::fiMAJ)->cObdZvys := (::fiZMAJU)->cObdZvysO )

*    (::fiMAJ)->nZnAkt     := (::fiZMAJU)->nZnAktn
    * 21.10.2008
*    (::fiMAJ)->nCenaPorU := (::fiZMAJU)->nCenaVstUn + (::fiMAJ)->nDotaceUct
*    (::fiMAJ)->nCenaPorD := (::fiZMAJU)->nCenaVstDn + (::fiMAJ)->nDotaceDan
    */
    IF (::fiZMAJU)->nKarta = 203
      (::fiMAJ)->nOprUct    := (::fiZMAJU)->nOprUctn
      (::fiMAJ)->nOprDan    := (::fiZMAJU)->nOprDann
    ENDIF
  ENDIF

  Do Case
    Case ( nTypPohyb == VYSTUPNI .and. nKey == xbeK_INS   ) .or. ;
         ( nTypPohyb == VYSTUPNI .and. nKey == xbeK_ENTER )
      (::fiMAJ)->nZnAkt     := VYRAZEN
      (::fiMAJ)->nZnAktD    := VYRAZEN
      (::fiMAJ)->dDatVyraz  := (::fiZMAJU)->dDatZmeny
      (::fiMAJ)->cObdVyraz  := (::fiZMAJU)->cObdobi
      nDanOdpRok      := If( Right( (::fiMAJ)->cObdZar, 2) = Right( (::fiMAJ)->cObdVyraz, 2), 0,;
                             (::fiMAJ)->nDanOdpRok * 0.5 )
      nZustCenaD      := (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDan
      (::fiMAJ)->nDanOdpRok := HIM_RocniOdpis( nDanOdpRok, nZustCenaD )
      (::fiMAJ)->nProcDanOd := ValToPerc( (::fiMAJ)->nCenaVstD, (::fiMAJ)->nDanOdpRok)

    Case ( nTypPohyb == VYSTUPNI .and. nKey == xbeK_DEL )
      (::fiMAJ)->dDatVyraz  := CtoD( '  .  .  ')
      (::fiMAJ)->cObdVyraz  := '     '

    Case ( (::fiZMAJU)->nKarta == 201 .and. nKey == xbeK_INS   ) .or. ;
         ( (::fiZMAJU)->nKarta == 201 .and. nKey == xbeK_ENTER )   // zvýšení ceny ( novì techn.zhodnocení)
      If Right( (::fiMAJ)->cObdZar, 2) <> Right( (::fiZMAJU)->cObdobi, 2)
         (::fiMAJ)->nRokZvDanO := IF( nKey == xbeK_INS .and. !EMPTY( (::fiMAJ)->cObdZvys), 0, (::fiMAJ)->nRokZvDanO)
         (::fiMAJ)->dDatZvys   := (::fiZMAJU)->dDatZmeny
         (::fiMAJ)->cObdZvys   := (::fiZMAJU)->cObdobi
      Endif
      * Majetek byl již odepsán, ale zvýšili jsme vst.cenu => stává se znovu aktivním !
      If (::fiMAJ)->nZnAkt == ODEPSAN
        (::fiMAJ)->nZnAkt := AKTIVNI
      Endif
      * newD - 8.3.2011
      If (::fiMAJ)->nZnAktD == ODEPSAN
        (::fiMAJ)->nZnAktD := AKTIVNI
      Endif
      * Zvýšení nehmotného majetku s daò.skupinou 8
      IF !(::fiMAJ)->lHmotnyIM .and. (::fiMAJ)->nOdpiSk = 8
        (::fiMAJ)->nPocMesUOZ := 0  // poèet skut. mìs.odpisù po zmìnì
      ENDIF

    Case ( (::fiZMAJU)->nKarta == 201 .and. nKey == xbeK_DEL )
      (::fiMAJ)->dDatZvys   := CtoD( '  .  .  ')
  EndCase

  *
  ** je na poøizovací kartì Pohyby majetku ...
  if isObject(::dm) .and. .not. isDEL
    if ( (::fiZMAJU)->nCenaVstUn +(::fiZMAJU)->nCenaVstDn +(::fiZMAJU)->nDanOdpRn +(::fiZMAJU)->nUctOdpRn + ;
         (::fiZMAJU)->nUctOdpMn  +(::fiZMAJU)->nOprUctn +  (::fiZMAJU)->nOprDann ) = 0

      (::fiMAJ)->nZnAkt     := VYRAZEN
      (::fiMAJ)->nZnAktD    := VYRAZEN
      (::fiMAJ)->dDatVyraz  := (::fiZMAJU)->dDatZmeny
      (::fiMAJ)->cObdVyraz  := (::fiZMAJU)->cObdobi
    endif
  endif
RETURN self

* HIDDEN************************************************************************
METHOD HIM_POHYBY_crd:SumMaj_MODI( nKEY, lSumMajEXIST )
  Local  nSign := (::fiZMAJU)->nTypPohyb
  Local  cTag := (::fiSumMAJ)->( AdsSetOrder( 1))
  *
  IF !lSumMajEXIST
    IF ADDREC( ::fiSumMAJ)
      HIM_SumMaj_ADD( ::isHIM)
      (::fiSumMAJ)->nROK    := uctOBDOBI:&(::cTask):nRok
      (::fiSumMAJ)->nObdobi := ::nAktOBD
    ENDIF
  ENDIF
  *
  Do Case
    Case nKey == xbeK_INS
      (::fiSumMAJ)->nZmVstCKla += If( nSign ==  1, Abs( (::fiZMAJU)->nZmenVstCU), 0 )
      (::fiSumMAJ)->nZmOprKla  += If( nSign ==  1, Abs( (::fiZMAJU)->nZmenOprU ), 0 )
      (::fiSumMAJ)->nZmVstCMin += If( nSign == -1, Abs( (::fiZMAJU)->nZmenVstCU), 0 )
      (::fiSumMAJ)->nZmOprMin  += If( nSign == -1, Abs( (::fiZMAJU)->nZmenOprU ), 0 )

    Case nKey == xbeK_ENTER
      (::fiSumMAJ)->nZmVstCKla += If( nSign ==  1,;
                         - Abs( ::nZmenVstCU_org) + Abs( (::fiZMAJU)->nZmenVstCU), 0 )
      (::fiSumMAJ)->nZmOprKla  += If( nSign ==  1,;
                         - Abs( ::nZmenOprU_org) + Abs( (::fiZMAJU)->nZmenOprU ), 0 )
      (::fiSumMAJ)->nZmVstCMin += If( nSign == -1,;
                         - Abs( ::nZmenVstCU_org) + Abs( (::fiZMAJU)->nZmenVstCU), 0 )
      (::fiSumMAJ)->nZmOprMin  += If( nSign == -1,;
                         - Abs( ::nZmenOprU_org) + Abs( (::fiZMAJU)->nZmenOprU ), 0 )

    Case nKey == xbeK_DEL
      (::fiSumMAJ)->nZmVstCKla += If( nSign ==  1, - Abs( (::fiZMAJU)->nZmenVstCU), 0 )
      (::fiSumMAJ)->nZmOprKla  += If( nSign ==  1, - Abs( (::fiZMAJU)->nZmenOprU ), 0 )
      (::fiSumMAJ)->nZmVstCMin += If( nSign == -1, - Abs( (::fiZMAJU)->nZmenVstCU), 0 )
      (::fiSumMAJ)->nZmOprMin  += If( nSign == -1, - Abs( (::fiZMAJU)->nZmenOprU ), 0 )
  EndCase
  (::fiSumMAJ)->nVsCenUKS  := (::fiSumMAJ)->nVsCenUPS - (::fiSumMAJ)->nZmVstCMin ;
                                          + (::fiSumMAJ)->nZmVstCKla
  (::fiSumMAJ)->nOprUctKS  := (::fiSumMAJ)->nOprUctPS + (::fiSumMAJ)->nUctOdpMes  ;
                              - (::fiSumMAJ)->nZmOprMin + (::fiSumMAJ)->nZmOprKla
  (::fiSumMAJ)->nZuCenUKS  := (::fiSumMAJ)->nVsCenUKS - (::fiSumMAJ)->nOprUctKS

  IF !lSumMajEXIST
    (::fiSumMAJ)->( dbUnlock())
  ENDIF

  * Pøípadný pøepoèet kumulativního souboru
  ::ReKumul( (::fiSumMAJ)->( RecNo()) )
  *
  (::fiSumMAJ)->( AdsSetOrder( cTag))
RETURN self

*
* HIDDEN************************************************************************
METHOD HIM_POHYBY_crd:ReKUMUL( nRecNO)
  Local  cTag := (::fiSumMAJ)->( AdsSetOrder( 2)), cKey
  Local  nVsCenUKS, nOprUctKS

  (::fiSumMAJ)->( dbGoTo( nRecNo))
  cKey := IF( ::isHIM, StrZero( (::fiSumMaj)->nTypMaj,3), StrZero( (::fiSumMaj)->nUcetSkup,3) ) + ;
                     StrZero( (::fiSumMaj)->nInvCis, 15 )
  (::fiSumMaj)->( mh_SetScope( cKEY), dbGoTO( nRecNo) )

  (  nVsCenUKS := (::fiSumMAJ)->nVsCenUKS, nOprUctKS := (::fiSumMAJ)->nOprUctKS )
  (::fiSumMAJ)->( dbSkip())
  Do While ! (::fiSumMAJ)->( Eof())
     IF (::fiSumMAJ)->( dbRLock( (::fiSumMaj)->( RecNO())  ))
       (::fiSumMAJ)->nVsCenUPS := nVsCenUKS
       (::fiSumMAJ)->nOprUctPS := nOprUctKS
       (::fiSumMAJ)->nZuCenUPS := (::fiSumMAJ)->nVsCenUPS - (::fiSumMAJ)->nOprUctPS
       (::fiSumMAJ)->nVsCenUKS := (::fiSumMAJ)->nVsCenUPS - (::fiSumMAJ)->nZmVstCMin ;
                                  + (::fiSumMAJ)->nZmVstCKla
       (::fiSumMAJ)->nOprUctKS := (::fiSumMAJ)->nOprUctPS + (::fiSumMAJ)->nUctOdpMes ;
                            - (::fiSumMAJ)->nZmOprMin + (::fiSumMAJ)->nZmOprKla
       (::fiSumMAJ)->nZuCenUKS := (::fiSumMAJ)->nVsCenUKS - (::fiSumMAJ)->nOprUctKS
       nVsCenUKS         := (::fiSumMAJ)->nVsCenUKS
       nOprUctKS         := (::fiSumMAJ)->nOprUctKS
       (::fiSumMAJ)->( dbRUnlock( (::fiSumMaj)->( RecNO()) ))
     EndIf
     (::fiSumMAJ)->( dbSkip())
  EndDo
  (::fiSumMaj)->( mh_ClrScope())
  (::fiSumMAJ)->( AdsSetOrder( cTag), dbGoTo( nRecNo) )

RETURN self

* HIDDEN************************************************************************
METHOD HIM_POHYBY_crd:NStoZMAJU()
  (::fiZMAJUw)->cNazPol1   := (::fiMAJ)->cNazPol1
  (::fiZMAJUw)->cNazPol2   := (::fiMAJ)->cNazPol2
  (::fiZMAJUw)->cNazPol3   := (::fiMAJ)->cNazPol3
  (::fiZMAJUw)->cNazPol4   := (::fiMAJ)->cNazPol4
  (::fiZMAJUw)->cNazPol5   := (::fiMAJ)->cNazPol5
  (::fiZMAJUw)->cNazPol6   := (::fiMAJ)->cNazPol6
RETURN self

* Poèáteèní èíslo dokladu pro úèetní odpisy
* HIDDEN************************************************************************
METHOD HIM_POHYBY_crd:CisDokl_UO()
  Local nDoklad, cAlias := ::fiZMAJU + 'a'

  drgDBMS:open( ::fiZMAJU,,,,, cAlias )
  (cAlias)->( AdsSetOrder( 3), dbGoBottom() )
  nDoklad := (cAlias)->nDoklad
*  nDoklad := If( nDoklad < 900000, 900000, nDoklad  )
  nDoklad := If( nDoklad < 9000000000, 9000000000, nDoklad  )
  (cAlias)->( dbCloseArea())

RETURN nDoklad

* Pøi pohybu v seznamu
********************************************************************************
METHOD HIM_POHYBY_crd:ItemMarked()
  Local nPohyb := Int( (::fiZMAJUw)->nKarta / 100 )
  Local lEdit

  IF ::nKARTA <> (::fiZMAJUw)->nKARTA
    ::nKARTA := IF( (::fiZMAJUw)->nKARTA <> 0, (::fiZMAJUw)->nKARTA, ::nKARTA)
    ::modiCARD()
  ENDIF
  *
  lEdit := ( ::RowPosZME() = 1 .and. (::fiMAJ)->nZnAkt <> VYRAZEN )  .and. ;
             nPohyb <> 0
  *
  DO CASE
    CASE ::nKARTA = 201 .or. ::nKARTA = 202 .or. ::nKARTA = 207
      IsEditGET( CRD_201_202, ::drgDialog, lEdit)
    CASE ::nKARTA = 203
      IsEditGET( CRD_203    , ::drgDialog, lEdit)
    CASE ::nKARTA = 204 .or. ::nKARTA = 100
      IsEditGET( CRD_204    , ::drgDialog, .F.)
    CASE ::nKARTA = 301
      IsEditGET( CRD_301    , ::drgDialog, lEdit)
  ENDCASE
  IsEditGET( ::fiZMAJUw + '->cTypPohybu', ::drgDialog, .F.)
  *
  ::dm:refresh()
  *
RETURN SELF

*
* HIDDEN ***********************************************************************
METHOD HIM_POHYBY_crd:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T., lObdZar, lZvCena
  LOCAL  lValid := ( ::lNewREC .or. lChanged )
  LOCAL  cNAMe := UPPER(oVar:name), cField := Lower(drgParseSecond( cName, '>'))
  LOCAL  lSnizeni := ( ::nKarta = 202 .or. ::nKarta = 203 ), nSign := IF( lSnizeni, -1, 1 )
  Local  cCenaNAME, cCenaTEXT, cOdpiSkD
  Local  nCenaVstD, nProcDanOd
  Local  nAktMes, nRocniOdpis, nUOMes, nUORok, nPerc, nKoef, nCitatel, nUplHodn := 0
  Local  cTypPohybu := alltrim( ::dm:get( ::fiZMAJUw + '->cTypPohybu'))
  Local  nEvent := mp1 := mp2 := nil
  *
  local  noprUct := (::fiMAJ)->nOprUct


  nEvent := LastAppEvent(@mp1,@mp2)

  IF cField $ 'nzmenvstcu,nzmenvstcd,nzmenopru,nzmenoprd'
    IF (::fiMAJ)->nZnAkt = 1 .and. ::nKarta = 203 .and. cField $ 'nzmenopru,nzmenoprd'
      * u neaktivního majetku mohou být pøi èásteèném vyøazení zadány nulové oprávky(8.10.07)
      IF xVar < 0
        drgMsgBox(drgNLS:msg( oVar:ref:caption + ' : ... èástka nesmí být záporná !'))
        RETURN .F.
      ENDIF
    ELSE
      IF xVar = 0
        drgMsgBox(drgNLS:msg( oVar:ref:caption + ' : ... èástka musí být kladná !'))
        RETURN .T.
      ENDIF
    ENDIF
  ENDIF
  *

  lObdZar   := ( Right((::fiMaj)->cObdZar, 2) = Right( ::cAktObd, 2) )


  DO CASE
  CASE cField $ 'ctyppohybu'
    lOK := IF( lValid, ::C_TypPoh_SEL(), lOK)

  CASE cField $ 'ndoklad'

  CASE cField $ 'nzmenvstcu,nzmenvstcd,nzmenopru,nzmenoprd'

    IF cField $ 'nzmenvstcu,nzmenvstcd'
      cCenaNAME := IF( cField = 'nzmenvstcu', 'nCenaVstU', 'nCenaVstD' )
      cCenaTEXT := 'Vstupní cena ' + IF( cField = 'nzmenvstcu', 'úèetní', 'daòová')
    ELSE
      cCenaNAME := IF( cField = 'nzmenopru', 'nOprUct', 'nOprDan' )
      cCenaTEXT := 'Cena oprávek ' + IF( cField = 'nzmenopru', 'úèetních', 'daòových')
    ENDIF

    IF lSnizeni
      IF xVar > (::fiMAJ)->&cCenaNAME
        drgMsgBox(drgNLS:msg( cCenaTEXT + ' je pouze [ & ]!', (::fiMAJ)->&cCenaNAME ))
        lOK := .F.

      ELSEIF xVar = (::fiMAJ)->&cCenaNAME
        drgMsgBox(drgNLS:msg( cCenaTEXT + '  -  POZOR, snižujete ji na nulovou hodnotu !' ))
        lOK := .T.
      ENDIF
    ENDIF
    ::dm:set( ::fiZMAJUw + '->'+cCenaNAME+'n', ::dm:get( ::fiZMAJUw+'->'+cCenaNAME+'o') + nSign * xVar)
    *                        HIM_DrPohyb_SEL
    * Roèní daòové odpisy
    *
    IF ( (::fiMaj)->nZnAktD = AKTIVNI .or. ( (::fiMaj)->nZnAktD = ODEPSAN .and. cTypPohybu = '31' ) )

      cOdpiSkD   := (::fiMAJ)->cOdpiSkD
      c_DanSkp->( dbSeek( Upper( (::fiMAJ)->cOdpiSkD),, AdsCtag(1)))
      nCenaVstD  := ::dm:get( ::fiZMAJUw + '->nCenaVstDn')
      nProcDanOd := ::dm:get( ::fiZMAJUw + '->nProcDanOn')
      lObdZar    := ( Right( (::fiMaj)->cObdZar, 2) = Right( ::cAktObd, 2) )
      nAktMes    := ::nAktOBD
      cTypPohybu := alltrim( ::dm:get( ::fiZMAJUw + '->cTypPohybu'))
      Do Case
        ***
        *   // tech.zhodnocení pro nehm. majetek
        CASE cTypPohybu = '31' .and. ( cOdpiSkD = '10' .or. cOdpiSkD = '11' .or. cOdpiSkD = '12' .or. cOdpiSkD = '13')
           nCitatel    := (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDan + ::dm:get(::fiZMAJUw + '->nzmenvstcd')
           nJmenovatel := (::fiMAJ)->nMesOdpiD - (::fiMAJ)->nPocMesDO
           nJmenovatel := if( nJmenovatel > C_DanSkp->nMesTZhod, nJmenovatel, C_DanSkp->nMesTZhod )
           nDOMes      := nCitatel / nJmenovatel
           nDOMes      := mh_RoundNumb( nDOMes, ::nRoundOdpi)
           nRocniOdpis := ( nDOMes * If( nAktMes == 12, 0, ( 12 - nAktMes))) + ;
                          ( (::fiMAJ)->nOprDan - (::fiMaj)->nOprDanPS )
           nRocniOdpis := mh_RoundNumb( nRocniOdpis, ::nRoundOdpi)
        ***

        ** START 3.7.2008
        *  Zvýšení VC u nehmotného majetku s daòovou sk. 8 ( odpisování na mìsíce)
  *      CASE !lSnizeni .and. !(::fiMaj)->lHmotnyIM  // .and. (::fiMAJ)->nOdpiSk = 8
        CASE !lSnizeni  .and. c_DanSkp->cMjCas = 'M'
           nCitatel    := (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDan + ::dm:get(::fiZMAJUw + '->nzmenvstcd')
           nJmenovatel := (::fiMAJ)->nMesOdpiD - (::fiMAJ)->nPocMesDO
           nDOMes      := nCitatel /nJmenovatel
           nDOMes      := mh_RoundNumb( nDOMes, ::nRoundOdpi)
           nRocniOdpis := ( nDOMes * If( nAktMes == 12, 0, ( 12 - nAktMes))) + ;
                     ( (::fiMAJ)->nOprDan - (::fiMaj)->nOprDanPS )
           nRocniOdpis := mh_RoundNumb( nRocniOdpis, ::nRoundOdpi)
        *
        ** END 3.7.2008
        Case lSnizeni .and. (::fiMaj)->nTypDOdpi == DO_ROVNOMERNY  // = 1
          ::dm:set( ::fiZMAJUw + '->nProcDanOn',;
                    IF( (::fiMAJ)->nRokyDanOd = 0, c_DanSkp->nRoPrvni, c_DanSkp->nRoDalsi ))
          nRocniOdpis := PercToVal(  nCenaVstD, nProcDanOd )

        Case lSnizeni .and. (::fiMaj)->nTypDOdpi == DO_ZRYCHLENY  // = 2
          If (::fiMaj)->nRokyDanOd == 0
            nRocniOdpis := nCenaVstD / c_DanSkp->nZrPrvni
          Else
            nRocniOdpis := ( 2 * ( nCenaVstD - (::fiZMAJUw)->nOprDann ) / ;
                                 ( c_DanSkp->nZrDalsi - (::fiMaj)->nRokyDanOd ) )
          Endif

        Case !lSnizeni .and. (::fiMaj)->nTypDOdpi == DO_ROVNOMERNY    // = 1
  *        lObdZar := ( Right( (::fiMaj)->cObdZar, 2) = Right( ::cAktObd, 2) )
          lZvCena := ( Right( (::fiMaj)->cObdZar, 2) <> Right( ::cAktObd, 2) )
          nPerc := HIM_ProcRDO( (::fiMaj)->cObdZar   ,;
                                (::fiMaj)->cOdpiSk   ,;
                                (::fiMaj)->nUplProc  ,;
                                (::fiMaj)->nRokyDanOd,;
                                ::cTASK              ,;
                                lZvCena         )   // 1.11.2005
          ::dm:set( ::fiZMAJUw + '->nProcDanOn', nPerc )
          nRocniOdpis := PercToVal( nCenaVstD, nPerc )
          * 20.5.2008
          nRocniOdpis := IF( ( ::fiMAJ)->nOprDan + nRocniOdpis <= nCenaVstD,;
                             nRocniOdpis, MAX( 0, ( ::fiMAJ)->nOprDan + nRocniOdpis - nCenaVstD) )
          *
          IF lObdZar      // zvýšení v roce zaøazení
            nUplHodn := ( nCenaVstD / 100 ) * (::fiMaj)->nUplProc
          ENDIF

        Case !lSnizeni .and. (::fiMaj)->nTypDOdpi == DO_ZRYCHLENY   // =  2
          IF lObdZar       // zvýšení v roce zaøazení
            nCitatel := nCenaVstD
            nKoef    := c_DanSkp->nZrPrvni
            nUplHodn := ( nCitatel / 100 ) * (::fiMaj)->nUplProc
          ELSE                         // zvýšení v dalším roce
***            nCitatel :=  2 * ( nCenaVstD - (::fiZMAJUw)->nOprDann )
            nCitatel :=  2 * ( nCenaVstD - (::fiMAJ)->nOprDan )
            nKoef    := c_DanSkp->nZrZvCena
          ENDIF
          If (::fiMaj)->nRokZvDanO == 0
            nRocniOdpis := ( nCitatel / nKoef ) + nUplHodn
          Else
* mp Err
*            nRocniOdpis := ( nCitatel  / ;
*                            abs( c_DanSkp->nZrZvCena - (::fiMaj)->nRokZvDanO ) )
* js
            nRocniOdpis := ( nCitatel  / c_DanSkp->nZrZvCena )
          Endif
          *
          nRocniOdpis := IF( ( ::fiMAJ)->nOprDan + nRocniOdpis <= nCenaVstD,;
                             nRocniOdpis, MAX( 0, ( ::fiMAJ)->nOprDan + nRocniOdpis - nCenaVstD) )
          *
      EndCase
      ::dm:set( ::fiZMAJUw + '->nDanOdpRn' , nRocniOdpis := mh_RoundNumb( nRocniOdpis, ::nRoundOdpi ) )
      ::dm:set( ::fiZMAJUw + '->nProcDanOn', ValToPERC( nCenaVstD, nRocniOdpis ))
    ENDIF
    *
    * Roèní úèetní odpisy
    *
    IF ( (::fiMaj)->nZnAkt = AKTIVNI  .or. ( (::fiMaj)->nZnAkt = ODEPSAN .and. cTypPohybu = '31' ) )

      nAktMes := ::nAktOBD   //HIM_AktMes( StoreObd(), ::cTASK )
      nCenaVstU  := ::dm:get( ::fiZMAJUw + '->nCenaVstUn')
      c_UcetSkp->( dbSeek( Upper( (::fiMAJ)->cOdpiSk,, AdsCtag(1))))
      *
      DO CASE
        *  Zvýšení VC u nehmotného majetku s daòovou sk. 8 ( odpisování na mìsíce)
** 17.1.2011        CASE !lSnizeni .and. !(::fiMaj)->lHmotnyIM  // .and. (::fiMAJ)->nOdpiSk = 8
           /*  ???  Zvýšení vstupní ceny u nehmotného majetku
           JCH analyticky vymyslí
           */
**        OTHERWISE
          /*  25.8.2008 ZAL
          If (::fiMaj)->nTypUOdpi == UO_ROVNOMERNY   // 1 =  rovnomìrný
            nUOMes := nCenaVstU / ( (::fiMaj)->nRokyOdpiU * 12 )
            nUOMes := mh_RoundNumb( nUOMes, ::nRoundOdpi)
            nUORok := ( nUOMes * If( nAktMes == 12, 0, ( 12 - nAktMes))) + ;
                      ( (::fiMAJ)->nOprUct - (::fiMaj)->nOprUctPS )
            nUORok := mh_RoundNumb( nUORok, ::nRoundOdpi)

          ElseIf (::fiMaj)->nTypUOdpi == UO_ROVENDANOVEMU   // 3 = roven daòovému
            ::dm:set( ::fiZMAJUw + '->nProcUctOn', ::dm:get( ::fiZMAJUw + '->nProcDanOn'))
            nUORok := ::dm:get( ::fiZMAJUw + '->nDanOdpRn')    // G[ 15]:VarGet()
            nUOMes :=  If( nAktMes == 12, 0,;
                        ( nUORok -( (::fiMAJ)->nOprUct - (::fiMaj)->nOprUctPS )) / ( 12 - nAktMes))
            nUOMes := mh_RoundNumb( nUOMes, ::nRoundOdpi)
            nUORok := ( nUOMes * If( nAktMes == 12, 0, ( 12 - nAktMes))) + ;
                      ( (::fiMAJ)->nOprUct - (::fiMaj)->nOprUctPS )
            nUORok := mh_RoundNumb( nUORok, ::nRoundOdpi)
          Endif
          */
        ** newD
        CASE !lSnizeni  .and. c_DanSkp->cMjCas = 'M'
          If (::fiMaj)->nTypUOdpi == UO_ROVNOMERNY
            nCitatel    := (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct + ::dm:get(::fiZMAJUw + '->nzmenvstcu')
            nJmenovatel := ((::fiMAJ)->nRokyOdpiU * 12) - (::fiMAJ)->nPocMesUO
            nUOMes      := nCitatel /nJmenovatel
            nUOMes      := mh_RoundNumb( nUOMes, ::nRoundOdpi)
            nUORok      := ( nUOMes * If( nAktMes == 12, 0, ( 12 - nAktMes))) + ;
                          ( (::fiMAJ)->nOprUct - (::fiMaj)->nOprUctPS )
            nUORok      := mh_RoundNumb( nRocniOdpis, ::nRoundOdpi)
          EndIf

          If (::fiMaj)->nTypUOdpi == UO_ROVENDANOVEMU   //  = 3
            ::dm:set( ::fiZMAJUw + '->nProcUctOn', ::dm:get( ::fiZMAJUw + '->nProcDanOn'))
            nUORok := ::dm:get( ::fiZMAJUw + '->nDanOdpRn')
            nUOMes :=  If( nAktMes == 12, 0,;
                        ( nUORok -( (::fiMAJ)->nOprUct - (::fiMaj)->nOprUctPS )) / ( 12 - nAktMes))
            nUOMes := mh_RoundNumb( nUOMes, ::nRoundOdpi)
            nUORok := ( nUOMes * If( nAktMes == 12, 0, ( 12 - nAktMes))) + ;
                      ( (::fiMAJ)->nOprUct - (::fiMaj)->nOprUctPS )
            nUORok := mh_RoundNumb( nUORok, ::nRoundOdpi)
          Endif


        CASE lSnizeni .or. !lSnizeni  //  .and. (::fiMaj)->nTypUOdpi == UO_ROVNOMERNY    // = 1
          If (::fiMaj)->nTypUOdpi == UO_ROVNOMERNY   //  = 1
            nProcUO := if( lObdZar, C_UcetSkp->nRoPrvni, C_UcetSkp->nRoDalsi)
            /*
            If (::fiMAJ)->nTypVypUO = UO_VYPOCET_PLNY
              * odepisuje se již v mìsíci zaøazení
              nUORok   := ( nCenaVstU / 100 * nProcUO)
              nUORok_r := nUORok - (::fiMaj)->nUctOdpRok  // Roèní úè.odpis nový - pùvodní
              nUOMes := (::fiMaj)->nUctOdpMes + nUORok_r / ( 12 - nAktMes + 1)
            ELSEIF (::fiMAJ)->nTypVypUO = UO_VYPOCET_ZKRACENY
              * odepisuje se od následujícího mìsíce po zaøazení
              nUOMes   := (( nCenaVstU / 100 * C_UcetSkp->nRoPrvni) / 12 )
              nUOMes_r :=  nUOMes - (::fiMaj)->nUctOdpMes   // Mìsíèní úè.odpis nový - pùvodní
              nUORok := (::fiMaj)->nUctOdpRok + If( nAktMes = 12 .and. !::lRocniUZV .and. ::lNewRec, 0, nUOMes_r * ( 12 - nAktMes) )
            ENDIF
            */

            if (::fiMAJ)->nznAkt = UCETNE_ODEPSAN
              nUOMes := ( ( ( ( nCenaVstU - noprUct ) / 100 ) * nProcUO ) / 12 )
            else
              nUOMes := (( nCenaVstU / 100 * nProcUO) / 12 )
            endif


            nUOMes   := mh_RoundNumb( nUOMes, ::nRoundOdpi )
            nUOMes_r :=  nUOMes - (::fiMaj)->nUctOdpMes   // Mìsíèní úè.odpis nový - pùvodní
            If (::fiMAJ)->nTypVypUO = UO_VYPOCET_PLNY
              nUORok := (::fiMaj)->nUctOdpRok + nUOMes_r * ( 12 - nAktMes)
            ELSEIF (::fiMAJ)->nTypVypUO = UO_VYPOCET_ZKRACENY
              nUORok := (::fiMaj)->nUctOdpRok + If( nAktMes = 12, 0, nUOMes_r * ( 12 - nAktMes) )
            ENDIF

            nUORok := if( nCenaVstU = 0, 0, nUORok )
          EndIf

          If (::fiMaj)->nTypUOdpi == UO_ROVENDANOVEMU   //  = 3
            ::dm:set( ::fiZMAJUw + '->nProcUctOn', ::dm:get( ::fiZMAJUw + '->nProcDanOn'))
            nUORok := ::dm:get( ::fiZMAJUw + '->nDanOdpRn')
            nUOMes :=  If( nAktMes == 12, 0,;
                        ( nUORok -( (::fiMAJ)->nOprUct - (::fiMaj)->nOprUctPS )) / ( 12 - nAktMes))
            nUOMes := mh_RoundNumb( nUOMes, ::nRoundOdpi)
            nUORok := ( nUOMes * If( nAktMes == 12, 0, ( 12 - nAktMes))) + ;
                      ( (::fiMAJ)->nOprUct - (::fiMaj)->nOprUctPS )
            nUORok := mh_RoundNumb( nUORok, ::nRoundOdpi)
          Endif
        OTHERWISE

      ENDCASE

      nUOMes := IsNull(nUOMes, 0)
      nUORok := IsNull(nUORok, 0)
      ::dm:set( ::fiZMAJUw + '->nUctOdpMn' , mh_RoundNumb( nUOMes, ::nRoundOdpi))   // nUOMes )
      ::dm:set( ::fiZMAJUw + '->nUctOdpRn' , mh_RoundNumb( nUORok, ::nRoundOdpi))   //nUORok )
      ::dm:set( ::fiZMAJUw + '->nProcUctOn', ValToPERC( nCenaVstU, nUORok ) )
      *
    ENDIF
    * uložení na poslední položce dané karty
    IF ( cField $ 'nzmenvstcu' .and. ( nPos := ASCAN( { 201,202,207}, ::nKARTA )) > 0 ) .or. ;
       ( cField $ 'nzmenopru'  .and. ( nPos := ASCAN( { 203}, ::nKARTA )) > 0 )
      If( nEvent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      EndIf

    ENDIF

*  CASE cField $ 'nzmenopru'
*  CASE cField $ 'nzmenoprd'

  CASE cField $ 'cvarsym' .and. ( nPos := ASCAN( { 301}, ::nKARTA )) > 0
    If( nEvent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
    EndIf

  ENDCASE

RETURN lOK

********************************************************************************
METHOD HIM_POHYBY_crd:destroy()
  ::drgUsrClass:destroy()
  *
  (::fiZMajUw)->( dbCloseArea())
  *
  ::cTASK := ::isHIM := ::fiMAJ := ::fiZMAJU := ::fiZMAJUw := ::fiCIS :=  ;
  ::dm := ::dc := ::df := ::nKARTA := ::lNewREC := ::varsORG := ::membORG := ;
  ::nRoundOdpi := ::cAktObd := ::nAktOBD := ::nAktROK := ;
  ::nPorZmeny := ::cDenik := ::cUserAbb := ::fiSUMMAJ :=  ;
  ::nZmenVstCU_org := ::nZmenOprU_org := ::nLenINVCIS := ;
   Nil

RETURN self

* Zavolá výbìr druhu pohybu
********************************************************************************
METHOD HIM_Pohyby_crd:C_TypPoh_SEL( oDlg)
  LOCAL oDialog, nExit
  LOCAL Value := ::dm:get( ::fiZMAJUw +'->cTypPohybu')
  LOCAL lOK   := ( !Empty(value) .and. C_TypPoh->(dbseek(IF( ::isHim,I_DOKLADY, Z_DOKLADY) + value,,'C_TYPPOH02')))

  IF IsObject( oDlg) .or. ! lOK
    * nastaví filtr na záznamy úlohy I nebo Z
    cFilter := if( ::isHIM, "cUloha = 'I'", "cUloha = 'Z'" ) + ;
                            ".and. Val(Right(AllTrim( cTypDoklad),3)) >= 200 .and. Val(Right(AllTrim( cTypDoklad),3)) < 400"
    C_TypPoh->( mh_ClrFilter(), mh_SetFilter( cFilter))
    *
    DRGDIALOG FORM 'C_TypPOH_sel' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  ENDIF

  IF  nExit = drgEVENT_QUIT
    PostAppEvent( xbeP_Keyboard, xbeK_ESC,,::dm:has( ::fiZMAJUw +'->cTypPohybu'):oDrg:oXbp)
    RETURN .F.
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.

    IF ::nKARTA <> Val(Right(AllTrim( C_TypPOH->cTypDoklad),3))   // C_TypPOH->nKARTA   // (::fiCIS)->nKARTA
      ::nKARTA := Val(Right(AllTrim( C_TypPOH->cTypDoklad),3))  // C_TypPOH->nKARTA // (::fiCIS)->nKARTA
      ::modiCARD()
      *
      ::dm:set( ::fiZMAJUw + '->cTypPohybu', C_TypPoh->cTypPohybu )
      IF ::lNewREC
        ::dm:set( ::fiZMAJUw + '->nDoklad'  , HIM_NewDoklad( ::cTASK) )
        ::dm:set( ::fiZMAJUw + '->dDatZmeny', DATE() )

        IF( ALLTRIM( Str( ::nKARTA)) $ '201,202,203,207' )
          ::dm:set( ::fiZMAJUw + '->nZmenVstCU' , 0 )
          ::dm:set( ::fiZMAJUw + '->nZmenVstCD' , 0 )

          ::dm:set( ::fiZMAJUw + '->nCenaVstUo', (::fiMAJ)->nCenaVstU  )
          ::dm:set( ::fiZMAJUw + '->nCenaVstDo', (::fiMAJ)->nCenaVstD  )
          ::dm:set( ::fiZMAJUw + '->nProcDanOo', (::fiMAJ)->nProcDanOd )
          ::dm:set( ::fiZMAJUw + '->nDanOdpRo' , (::fiMAJ)->nDanOdpRok )
          ::dm:set( ::fiZMAJUw + '->nProcUctOo', (::fiMAJ)->nProcUctOd )
          ::dm:set( ::fiZMAJUw + '->nUctOdpRo' , (::fiMAJ)->nUctOdpRok )
          ::dm:set( ::fiZMAJUw + '->nUctOdpMo' , (::fiMAJ)->nUctOdpMes )
          ::dm:set( ::fiZMAJUw + '->nCenaVstUn', (::fiMAJ)->nCenaVstU  )
          ::dm:set( ::fiZMAJUw + '->nCenaVstDn', (::fiMAJ)->nCenaVstD  )
          ::dm:set( ::fiZMAJUw + '->nProcDanOn', (::fiMAJ)->nProcDanOd )
          ::dm:set( ::fiZMAJUw + '->nDanOdpRn' , (::fiMAJ)->nDanOdpRok )
          ::dm:set( ::fiZMAJUw + '->nProcUctOn', (::fiMAJ)->nProcUctOd )
          ::dm:set( ::fiZMAJUw + '->nUctOdpRn' , (::fiMAJ)->nUctOdpRok )
          ::dm:set( ::fiZMAJUw + '->nUctOdpMn' , (::fiMAJ)->nUctOdpMes )

          IF ::nKARTA = 203
            ::dm:set( ::fiZMAJUw + '->nOprUcto', (::fiMAJ)->nOprUct    )
            ::dm:set( ::fiZMAJUw + '->nOprDano', (::fiMAJ)->nOprDan    )
            ::dm:set( ::fiZMAJUw + '->nZmenOprU' , 0 )
            ::dm:set( ::fiZMAJUw + '->nZmenOprD' , 0 )

          ENDIF
        ENDIF
      ENDIF
    ENDIF
    *
    ::dm:refresh()
    C_TypPoh->( mh_ClrFilter())
  ENDIF

RETURN lOK

* Likvidace dokladu
********************************************************************************
METHOD HIM_Pohyby_crd:LikvDokl( oDlg)
  LOCAL  oDialog, nExit
  Local  nRecZmaju := (::fiZMAJU)->( RecNO())
  Local  nRecMaj   := (::fiMAJ)->( RecNO())
  Local  Filter := Format("nDoklad = %%", { (::fiZMAJUw)->nDoklad })
  Local  cScr   := If( ::isHIM, 'HIM', 'ZVI') + '_LikvDOK_SCR'

  (::fiZMAJU)->( mh_SetFILTER( Filter))
  *
  oDialog := drgDialog():new( cSCR, self:drgDialog)
  oDialog:create(,self:drgDialog:dialog,.F.)
  *
  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL
  * Obnoví nastavení souboru
  (::fiZMAJU)->( mh_ClrFILTER(), dbGoTO( nRecZmaju))
  (::fiMAJ)->( dbGoTO( nRecMaj))
  ::itemMarked()
RETURN self

*HIDDEN*************************************************************************
METHOD HIM_Pohyby_crd:modiCARD()
  Local  membCRD := {}, varsCRD := drgArray():new()
  Local  oVar, x

  For x := 1 TO Len( ::membORG)
    oVar := ::membORG[x]
    If IsMemberVar(oVAR,'Groups')
      If IsCharacter(oVAR:Groups)
*        If oVAR:Groups <> '' .and. oVAR:Groups <>'clrINFO'.and. oVAR:Groups <>'clrHEAD'
        If oVAR:Groups <> '' .and. oVAR:Groups <>'clrINFO'.and. oVAR:Groups <>'clrGREEN'
          oVAR:IsEDIT := .F.
          oVAR:oXbp:Hide()
          IF( isMemberVar( oVar,'obord') .and. isObject(oVar:obord))
            oVar:obord:hide()
          EndIf
        EndIf
      EndIf
    Endif
  Next
*
  For x := 1 TO Len( ::membORG)
    oVar := ::membORG[x]
    IF IsMemberVar(oVAR,'Groups')
      IF IsNIL( oVAR:Groups)
        AADD( membCRD, oVar)
      ElseIf IsCharacter( oVAR:Groups)
        IF  EMPTY(  oVAR:Groups) .OR. ALLTRIM( str(::nKARTA)) $ oVAR:Groups
          IF oVAR:ClassName() $ 'drgGet,drgComboBox'
            oVAR:IsEDIT := .t.
            oVAR:oXbp:Show()
            AADD( membCRD, oVar)
            If ( IsMemberVar(oVar,'pushGet') .and. IsObject(oVar:pushGet))
              oVar:pushGet:oxbp:show()
              oVar:pushGet:disabled := .f.
            EndIf
          ELSE
            oVAR:oXbp:Show()
            AADD( membCRD, oVar)
          ENDIF
          IF( isMemberVar( oVar,'obord') .and. isObject(oVar:obord))
            oVar:obord:show()
          EndIf
        ELSEIf ! EMPTY( oVAR:Groups)
          If ( IsMemberVar(oVar,'pushGet') .and. IsObject(oVar:pushGet))
            oVar:pushGet:oxbp:hide()
            oVar:pushGet:disabled := .t.
          EndIf
        EndIf
      EndIf
    ELSE
      AADD( membCRD, oVar)
    ENDIF
  Next
  *
  For x := 1 To LEN( ::varsORG:values)
    IF ! IsNIL( ::varsORG:values[x, 2] )
      oVAR := ::varsORG:values[x, 2]:oDrg
      IF oVAR:ClassName() $ 'drgGet,drgText,drgComboBox'
        If IsNIL( oVar:Groups) .OR. EMPTY(oVar:Groups) .OR. ( ALLTRIM( str(::nKARTA)) $ oVar:Groups)
          varsCRD:add(oVar:oVar, oVar:oVar:name)
        ENDIF
      ENDIF
    ENDIF
  NEXT
  *
  FOR x := 1 TO LEN( membCRD)
    IF membCRD[x]:ClassName() = 'drgTabPage'
      membCRD[x]:onFormIndex := x
    ENDIF
  NEXT
  *
  ::df:aMembers := membCRD
  ::dm:vars     := varsCRD
  *
  IsEditGET( { ::fiZMAJUw +'->nCenaVstUo', ::fiZMAJUw +'->nCenaVstUn',;
               ::fiZMAJUw +'->nCenaVstDo', ::fiZMAJUw +'->nCenaVstDn',;
               ::fiZMAJUw +'->nOprUcto'  , ::fiZMAJUw +'->nOprUctn'  ,;
               ::fiZMAJUw +'->nOprDano'  , ::fiZMAJUw +'->nOprDann'  ,;
               ::fiZMAJUw +'->nProcDanOo', ::fiZMAJUw +'->nProcDanOn',;
               ::fiZMAJUw +'->nDanOdpRo' , ::fiZMAJUw +'->nDanOdpRn' ,;
               ::fiZMAJUw +'->nProcUctOo', ::fiZMAJUw +'->nProcUctOn',;
               ::fiZMAJUw +'->nUctOdpRo' , ::fiZMAJUw +'->nUctOdpRn' ,;
               ::fiZMAJUw +'->nUctOdpMo' , ::fiZMAJUw +'->nUctOdpMn' },;
               ::drgDialog, .F.)
RETURN self

*
*HIDDEN*************************************************************************
METHOD HIM_Pohyby_crd:AllOK()
  Local lOK := .F., cUloha := IF( ::isHIM, 'I', 'Z' )

  drgDBMS:open( 'UCETSYS',,,,, 'UCETSYSw' )
  UCETSYSw->( AdsSetOrder( 3), mh_SetScope( cUloha), dbGoBottom() )
  IF ::cAktObd <> UCETSYSw->cObdobi
    drgMsgBox(drgNLS:msg( 'Nelze poøídit do období [ & ], nebo již bylo založeno období [ & ]', ::cAktObd, UCETSYSw->cObdobi ))
    RETURN .F.
  ENDIF

  IF !ObdobiUZV( ::cAktObd, 'U' )        // období není úèetnì uzavøeno v ÚÈETNICTVÍ
    IF !ObdobiUZV( ::cAktObd, cUloha)    // období není úèetnì uzavøeno v úloze HIM (ZVI)
      lOK := .T.
    ENDIF
  ENDIF
  *
RETURN lOK

* Zobrazení aktuálních dat pøi otevøení obrazovky, pøi zmìnì období.
*HIDDEN*************************************************************************
METHOD HIM_Pohyby_crd:refresh_SCR()
  Local cScope

  IF ::isHIM
    cScope :=  uctObdobi:HIM:cObdobi + StrZero( MAJ->nTypMaj,3) + StrZero(MAJ->nInvCis,15)
    ZMajU->( mh_SetScope( cScope))
  ELSE
    cScope :=  uctObdobi:ZVI:cObdobi + StrZero( MAJZ->nUcetSkup,3) + StrZero(MAJZ->nInvCis,15)
    ZMajUZ->( mh_SetScope( cScope), dbGoBottom() )
  ENDIF

  (::fiZMAJUw)->( dbZAP())
  (::fiZMAJU)->( DbEval( { || mh_COPYFLD( ::fiZMAJU, ::fiZMAJUw, .T.),;
                              ( ::fiZMAJUw)->_nrecor := (::fiZMAJU)->( RecNO())   }), dbGoTop() )
  (::fiZMAJUw)->( dbGoTop())
  *
  ::oBro:oXbp:refreshAll()
  ::itemMarked()

RETURN self


/*****************************************************************
* HIM_POHYBY_CRD ... Tvorba pohybových dokladù
*****************************************************************
CLASS ZVI_POHYBY_crd FROM HIM_POHYBY_crd
EXPORTED:
  METHOD  Init

ENDCLASS

*
********************************************************************************
METHOD ZVI_POHYBY_crd:Init(parent)

*  ::drgUsrClass:init(parent)
  ::HIM_POHYBY_crd:init( parent, 'ZVI' )
RETURN self
*/