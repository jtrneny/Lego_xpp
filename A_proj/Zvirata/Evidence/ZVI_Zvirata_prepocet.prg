/*==============================================================================
  ZVI_Zvirata_prepocet.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
*
********************************************************************************
CLASS ZVI_Zvirata_prepocet FROM drgUsrClass

EXPORTED:
  VAR     dDatumOd

  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled
  METHOD  Start

HIDDEN
  VAR     dm, msg
ENDCLASS

********************************************************************************
METHOD ZVI_Zvirata_prepocet:init(parent)
  ::drgUsrClass:init(parent)

  ::dDatumOd  := date()
  *
  drgDBMS:open('ZvZmenIT')
  ZvZmenIT->( AdsSetOrder('ZvZmenIT05'))
  drgDBMS:open('Zvirata' )
  drgDBMS:open('ZvKarty' )
  *
RETURN self

********************************************************************************
METHOD ZVI_Zvirata_prepocet:drgDialogInit(drgDialog)
  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
RETURN self

********************************************************************************
METHOD ZVI_Zvirata_prepocet:drgDialogStart(drgDialog)
  *
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
  ::dm:refresh()
  *
RETURN self

********************************************************************************
METHOD ZVI_Zvirata_prepocet:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT   //.or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  CASE nEvent = drgEVENT_SAVE
  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE
  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD ZVI_Zvirata_prepocet:Start()
  Local Filter, nCount, lock_Zvirata, lock_Zmeny, lock_Main
  Local dDatumOd, x := 0, y := 0

  ::msg:WriteMessage(,0)
  *
  lock_Zvirata := Zvirata->( FLock())
  lock_Zmeny   := ZvZmenIT->( FLock())
  lock_Main    := ( lock_Zvirata .and. lock_Zmeny )
  *
  IF !lock_Main
    ::msg:WriteMessage( 'Pøepoèet pøerušen ...', DRG_MSG_WARNING)
    * nìco se nám nepodaøilo zamknout
    cMsg := 'Nepodaøilo se zamknout soubor(y): '
    cMsg += IF( lock_Zvirata, '', ' Zvirata,'  )
    cMsg += IF( lock_Zmeny  , '', ' ZvZmenIT,' )
    cMsg := LEFT( cMsg, LEN(cMsg)-1) + ' ...'
    drgMsgBox(drgNLS:msg( cMsg ))
    *
    IF( lock_Zvirata, Zvirata->( dbUnlock()) , NIL )
    IF( lock_Zmeny  , ZvZmenIT->( dbUnlock()), NIL )
    RETURN NIL
  ENDIF

  IF drgIsYESNO(drgNLS:msg( 'Požadujete provést pøepoèet ?' ) )
    dDatumOd := ::dm:get('M->dDatumOd')
    Filter := FORMAT( "ZvZmenIT->dDatZmZv >= '%%'", { dDatumOD})
    ZvZmenIT->( mh_SetFilter( Filter))
    nCount := ZvZmenIT->( mh_COUNTREC())
    *
    drgServiceThread:progressStart(drgNLS:msg('Pøepoèet souboru Zvirata ... ', 'Zvirata'), nCount  )

    ZvZmenIT->( dbGoTop())
    DO WHILE !ZvZmenIT->( EOF())
      *
      cKey := Upper(ZvZmenIT->cNazPol1) + Upper(ZvZmenIT->cNazPol4) + StrZero(ZvZmenIT->nZvirKat,6)
      ZvKarty->( dbSEEK( cKey,, 'ZVKARTY_01'))

      cKey += StrZero(ZvZmenIT->nInvCis, 15)
      IF Zvirata->( dbSEEK( cKey,, 'ZVIRATA01'))
        x++
      ELSE
        // založit ZVIRATA
        y++
        mh_copyFLD( 'ZvZmenIT', 'Zvirata', .t., .f.)
        Zvirata->cTypEvid   := ZvKarty->cTypEvid
*        Zvirata->cNazPol1   := ZvKarty->cNazPol1
*        Zvirata->cNazPol4   := ZvKarty->cNazPol4
*        Zvirata->nZvirKat   := ZvKarty->nZvirKat
        Zvirata->cNazev     := ZvKarty->cNazev
        Zvirata->nUcetSkup  := ZvKarty->nUcetSkup
        Zvirata->cDanpZBO   := ZvKarty->cDanpZBO
        Zvirata->cTypSKP    := ZvKarty->cTypSKP
        Zvirata->dDatPorKar := ZvKarty->dDatPorKar
        Zvirata->cNazPol2   := ZvKarty->cNazPol2
        Zvirata->mPopis     := ZvKarty->mPopis
        Zvirata->dDatpZV    := ZvKarty->dDatpZV

      ENDIF
      *
      IF ZvZmenIT->nTypPohyb = 1         //   pøíjem
        Zvirata->nKusy      := 1
        Zvirata->dDatKdyODK := ZvZmenIT->dDatZmZv
      ELSEIF ZvZmenIT->nTypPohyb = -1    //   výdej
        Zvirata->nKusy      := 0
        Zvirata->dDatKdyKAM := ZvZmenIT->dDatZmZv
      ENDIF
      *
      Zvirata->cPohlavi   := IF( Zvirata->nPohlavi = 1, 'B', 'J' )
      Zvirata->cFarma     := PADR( ALLTRIM( STR( Zvirata->nFarma)), 10)
      Zvirata->cFarmaKrj  := LEFT( Zvirata->cFarma, 2)
      Zvirata->cFarmaPod  := SubSTR( Zvirata->cFarma, 3, 6)
      Zvirata->cFarmaStj  := RIGHT( Zvirata->cFarma, 2)
      *
      ZvZmenIT->( dbSkip())
      drgServiceThread:progressInc()
    ENDDO
    ZvZmenIT->( mh_ClrFilter())

    drgServiceThread:progressEnd()
    *
    Zvirata->( dbUnlock())
    ZvZmenIT->( dbUnlock())
    ::msg:WriteMessage( 'Pøepoèet probìhl a je ukonèen ...', DRG_MSG_WARNING)

  ENDIF

RETURN self