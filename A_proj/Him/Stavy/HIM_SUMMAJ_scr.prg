********************************************************************************
* HIM_SUMMAJ_SCR.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"

#include "DRGres.Ch'
#include "XBP.Ch"
#include "GRA.Ch"

********************************************************************************
* HIM_SUMMAJ_SCR ... Stavy za období
********************************************************************************
CLASS HIM_SUMMAJ_SCR FROM HIM_Main, drgUsrClass
EXPORTED:
  VAR     cTask
  VAR     nROK, nObdPOC, nObdKON, oneMAJ
  VAR     nVsCenDPS , nVsCenUPS, nOprUctPS, nZuCenUPS,;
          nZmVstCMin, nZmOprMin, nZmZCMin, nZmVstCKla, nZmOprKla,;
          nVsCenUKS, nOprUctKS, nZuCenUKS, nUctOdpMes
  VAR     fiSUMMAJw, fiZMAJU_1, fiMaj_ps

  METHOD  Init, Destroy, ItemMarked, drgDialogStart, eventHandled
  METHOD  createKUMUL, vypocetKUMUL, copyToKUMUL

HIDDEN
  VAR     dc, dm, msg, cUser, dDate, cTime
ENDCLASS

********************************************************************************
METHOD HIM_SUMMAJ_SCR:init(parent, cTask)
  ::drgUsrClass:init(parent)
  *
  DEFAULT cTASK TO 'HIM'
  ::cTask  := cTask
  *
  ::HIM_Main:Init( parent, cTASK = 'HIM')
  *
  ::fiSUMMAJw := ::fiSUMMAJ + 'w'
  ::fiZMAJU_1 := ::fiZMAJU + '_1'
  ::fiMAJ_ps  := if( ::isHIM, 'MAJ_PS', 'MAJZ_PS' )
  *
  drgDBMS:open( ::fiMAJ   )
  drgDBMS:open( ::fiMAJ_ps)
  drgDBMS:open( ::fiSUMMAJw ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open( ::fiZMAJU,,,,.T., ::fiZMAJU_1)
  ( ::fiZMAJU_1)->( AdsSetOrder( IF( ::isHIM, 8, 9)))
  *
  ::oneMAJ  := .T.
  ::cUser   := SysConfig( "System:cUserABB")
  ::dDate   := Date()
  ::cTime   := Time()
  *
  ::nROK    := uctObdobi:&(::cTask):nROK
  ::nObdPOC := 1
  ::nObdKON := uctObdobi:&(::cTask):nOBDOBI
  *
RETURN self

********************************************************************************
METHOD HIM_SUMMAJ_SCR:drgDialogStart( drgDialog )
  *
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  ::dc  := drgDialog:dialogCtrl
  ::dm  := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
  *
RETURN self

********************************************************************************
METHOD HIM_SUMMAJ_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local lOK := .T.

  DO CASE
    CASE nEvent = drgEVENT_OBDOBICHANGED

      ::nROK    := uctObdobi:&(::cTask):nROK
      ::nObdKON := uctObdobi:&(::cTask):nOBDOBI
      (::fiSUMMAJw)->( dbZap())
      ::itemMarked()

      RETURN .T.
    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD HIM_SUMMAJ_SCR:ItemMarked()
  Local  cScope
  Local  nRok    := IF( (::fiSUMMAJw)->( LastRec()) = 0, ::nRok   , (::fiSUMMAJw)->nRok    )
  Local  nObdobi := IF( (::fiSUMMAJw)->( LastRec()) = 0, ::nObdKon, (::fiSUMMAJw)->nObdobi )


  cScope := IF( ::isHIM, StrZero(MAJ->nTypMaj,3) + StrZero(MAJ->nInvCis,15)    ,;
                         StrZero(MAJZ->nUcetSkup,3) + StrZero(MAJZ->nInvCis,15) )
  (::fiSUMMAJw)->( mh_SetScope( cScope))
  *
  IF ::oneMAJ
    ::createKUMUL()
    *
    (::fiSUMMAJw)->( dbSeek( cScope + StrZero(nRok,4) + StrZero(nObdobi,2),, AdsCtag(1) ))
    ::dc:oBrowse[2]:oXbp:refreshAll()
    ::dm:refresh()
  ENDIF
  *
RETURN SELF

********************************************************************************
METHOD HIM_SUMMAJ_SCR:destroy()
  ::drgUsrClass:destroy()
  *
  ::nROK       := ::nObdPOC   := ::nObdKON    := ::oneMAJ    := ;
  ::nVsCenDPS  := ::nVsCenUPS := ::nOprUctPS  := ::nZuCenUPS := ;
  ::nZmVstCKla := ::nZmOprKla := ::nZmVstCMin := ::nZmOprMin := ;
  ::nUctOdpMes := NIL

RETURN self

********************************************************************************
METHOD  HIM_SUMMAJ_SCR:createKUMUL()
  Local cKey, nMes, nSign

  cKey := IF( ::isHIM, StrZero(MAJ->nTypMaj,3) + StrZero(MAJ->nInvCis,15)    ,;
                       StrZero(MAJZ->nUcetSkup,3) + StrZero(MAJZ->nInvCis,15) )
  *
  IF( ::oneMAJ, (::fiSUMMAJw)->( dbZAP()), NIL )

  ::nVsCenDPS  := ::nVsCenUPS := ::nOprUctPS  := ::nZuCenUPS := ;
  ::nZmVstCKla := ::nZmOprKla := ::nZmVstCMin := ::nZmOprMin := ;
  ::nUctOdpMes := 0
  * roèní poè. stavy
  IF (::fiMAJ_ps)->( dbSEEK( cKEY + StrZero(::nRok, 4),,AdsCtag(1)))
    ::nVsCenDPS := (::fiMAJ_ps)->nVsCenDPS
    ::nVsCenUPS := (::fiMAJ_ps)->nVsCenUPS
    ::nOprUctPS := (::fiMAJ_ps)->nOprUctPS
    ::nZuCenUPS := (::fiMAJ_ps)->nZuCenUPS
  ENDIF
  *
  FOR nMes := ::nObdPOC TO ::nObdKON
    * kumulace pohybù
    cKey := IF( ::isHIM, StrZero(MAJ->nTypMaj,3) + StrZero(MAJ->nInvCis,15)    ,;
                         StrZero(MAJZ->nUcetSkup,3) + StrZero(MAJZ->nInvCis,15) ) + ;
            StrZero(::nRok, 4) + StrZero(nMes, 2)

    ( ::fiZMAJU_1)->( mh_SetScope( cKey))
    *
    Do While !( ::fiZMAJU_1)->( Eof())
      nSign := ( ::fiZMAJU_1)->nTypPohyb
      ::nZmVstCKla  += If( nSign ==  1, Abs( (::fiZMAJU_1)->nZmenVstCU), 0 )
      ::nZmOprKla   += If( nSign ==  1, Abs( (::fiZMAJU_1)->nZmenOprU ), 0 )
      ::nZmVstCMin  += If( nSign == -1, Abs( (::fiZMAJU_1)->nZmenVstCU), 0 )
      ::nZmOprMin   += If( nSign == -1, Abs( (::fiZMAJU_1)->nZmenOprU ), 0 )
      ::nUctOdpMes  += (::fiZMAJU_1)->nUctOdpMes

      (::fiZMAJU_1)->( dbSkip())
    EndDo

    * zápis do KUMULU
    mh_CopyFLD( ::fiMAJ, ::fiSUMMAJw, .T.)

    ( ::fiSUMMAJw)->nRok       := ::nROK
    ( ::fiSUMMAJw)->nObdobi    := nMes
    ( ::fiSUMMAJw)->cObdobi    := StrZero( nMes, 2) + '/' + RIGHT( STR(::nROK), 2)
    *
    ( ::fiSUMMAJw)->nVsCenDPS  := ::nVsCenDPS
    ( ::fiSUMMAJw)->nVsCenUPS  := ::nVsCenUPS
    ( ::fiSUMMAJw)->nOprUctPS  := ::nOprUctPS
    ( ::fiSUMMAJw)->nZuCenUPS  := ::nZuCenUPS
    *
    ( ::fiSUMMAJw)->nZmVstCKla := ::nZmVstCKla
    ( ::fiSUMMAJw)->nZmOprKla  := ::nZmOprKla
    ( ::fiSUMMAJw)->nZmVstCMin := ::nZmVstCMin
    ( ::fiSUMMAJw)->nZmOprMin  := ::nZmOprMin

    ( ::fiSumMAJw)->nUctOdpMes := ::nUctOdpMes
    *
    (::fiSumMAJw)->nVsCenUKS   := ::nVsCenUPS - ::nZmVstCMin + ::nZmVstCKla
    (::fiSumMAJw)->nOprUctKS   := ::nOprUctPS + ::nUctOdpMes - ::nZmOprMin + ::nZmOprKla
    (::fiSumMAJw)->nZuCenUKS   := (::fiSumMAJw)->nVsCenUKS - (::fiSumMAJw)->nOprUctKS
    *
    ::nVsCenUPS  := ( ::fiSUMMAJw)->nVsCenUKS
    ::nOprUctPS  := ( ::fiSUMMAJw)->nOprUctKS
    ::nZuCenUPS  := ( ::fiSUMMAJw)->nZuCenUKS
    *
    ::nZmVstCKla := ::nZmOprKla := ::nZmVstCMin := ::nZmOprMin := ::nUctOdpMes := 0
    *
    (::fiZMAJU_1)->( mh_ClrScope())
  NEXT
  (::fiSumMAJw)->( dbGoTOP())
  *
RETURN SELF

********************************************************************************
METHOD HIM_SUMMAJ_SCR:vypocetKUMUL()
  Local cC := 'Požadujete provést výpoèet kumulací pro celý majetkový soubor ?'
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')
  Local nRec := ( ::fiMAJ)->( RecNO()), nCount := 0

  IF drgIsYESNO(drgNLS:msg( cC))
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg('Generuji stavy za období ...', ::fiMAJ ), ( ::fiMAJ)->(LASTREC()) )
    ::oneMAJ := .F.
    ( ::fiSUMMAJw)->( dbZAP())
    ( ::fiMAJ)->( dbGoTOP())
    DO WHILE !( ::fiMAJ)->( EOF())
      ::createKUMUL( .F.)

      ( ::fiMAJ)->( dbSkip())
      drgServiceThread:progressInc()
    ENDDO
    ( ::fiMAJ)->( dbGoTO( nRec))
    drgServiceThread:progressEnd()
    ::msg:WriteMessage(,0)
    *
    ::copyToKUMUL()
  ENDIF
RETURN SELF

********************************************************************************
METHOD HIM_SUMMAJ_SCR:copyToKUMUL()
  Local cTAG
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')

  IF drgIsYESNO(drgNLS:msg( 'Požadujete uložit výpoètenou kumulaci pro celý majetkový soubor ?'))

    drgDBMS:open( ::fiSUMMAJ, .T. )
    IF ( ::fiSUMMAJ)->( FLock())
      ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
      drgServiceThread:progressStart(drgNLS:msg('Ukládám vypoètené kumulace ...', ::fiSUMMAJw ), ( ::fiSUMMAJw)->(LASTREC()) )
      (::fiSUMMAJ)->( dbZAP())

      cTag := ( ::fiSUMMAJw)->( AdsSetOrder(0))
      ( ::fiSUMMAJw)->( dbGoTOP())
      DO WHILE ! ( ::fiSUMMAJw)->( EOF())
        mh_CopyFLD( ::fiSUMMAJw, ::fiSUMMAJ, .T.)
        ( ::fiSUMMAJw)->( dbSkip())
        drgServiceThread:progressInc()
      ENDDO
      ( ::fiSUMMAJw)->( AdsSetOrder( cTag))

      ( ::fiSUMMAJ)->( dbUnlock(), dbCloseArea() )
      drgServiceThread:progressEnd()
      ::msg:WriteMessage(,0)
    ELSE
      drgMsgBox(drgNLS:msg( 'Kumulativní soubor se nepodaøilo uzamknout ... '))
    ENDIF
  ENDIF

RETURN SELF