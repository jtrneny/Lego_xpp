********************************************************************************
* ZVI_zsbKategObd_SCR.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
* ZVI_zsbKategObd_SCR ... Stavy za období
********************************************************************************
CLASS ZVI_zsbKategObd_SCR FROM drgUsrClass
EXPORTED:
  VAR     nROK, nObdPOC, nObdKON, oneKategZVI
  VAR     nKusyPocZV, nMnozPocZV, nCenaPocZV, nKdPocZV
  VAR     nKusyPoc  , nMnozPoc  , nCenaPoc  , nKdPoc
  VAR     nKusyKon  , nMnozKon  , nCenaKon  , nKdKon
  VAR     nKusyPrij , nMnozPrij , nCenaPrij , nKdPrij
  VAR     nKusyVydej, nMnozVydej, nCenaVydej, nKdVydej
  VAR     nKusyPr  , nMnozPr  , nCenaPr
  VAR     nKusyPrOr, nMnozPrOr, nCenaPrOr

  METHOD  Init, Destroy, ItemMarked, drgDialogStart, drgDialogEnd
  METHOD  ZVI_KUMUL, createKUMUL, copyToKUMUL

HIDDEN
  VAR     dc, dm, msg, cUser, dDate, cTime
ENDCLASS

********************************************************************************
METHOD ZVI_zsbKategObd_SCR:init(parent)
  *
*  ::drgUsrClass:init(parent)
  drgDBMS:open('KategZVI'  )
  drgDBMS:open('ZVKARTY'   )
  drgDBMS:open('C_UCTSKZ'  )
  drgDBMS:open('ZvKarty_ps')
  ZvKarty_ps->( AdsSetOrder( 3))
  *
  drgDBMS:open('ZvKatOBDw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open('ZvZmenHD',,,,.T.,'ZvZmHD_1')
  ZvZmHD_1->( AdsSetOrder( 13))
* 16.3.2011  drgDBMS:open('C_DrPOHZ'  )
  *
  ::oneKategZVI := .T.
  ::cUser      := SysConfig( "System:cUserABB")
  ::dDate      := Date()
  ::cTime      := Time()
  *
  ::nROK    := uctObdobi:ZVI:nROK
  ::nObdPOC := 1
  ::nObdKON := uctObdobi:ZVI:nOBDOBI
  */
RETURN self

********************************************************************************
METHOD ZVI_zsbKategObd_SCR:drgDialogStart(drgDialog)
  Local aRecFLT := {}
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
  *
  * Zobrazí se jen kategorie, které se používájí, tj. existuje pro nì záznam v ZvKarty
  KategZVI->( dbGoTOP())
  DO WHILE !KategZVI->( EOF())
    IF ZvKarty->( dbSEEK( KategZVI->nZvirKat,, 'ZVKARTY_03'))
      aAdd( aRecFLT, KategZVI->( RecNO()) )
    ENDIF
    KategZVI->( dbSkip())
  ENDDO
  *
  IF( LEN( aRecFLT) > 0)
    mh_RyoFILTER( aRecFLT, 'KategZVI' )
  ENDIF
  *
RETURN self

********************************************************************************
METHOD ZVI_zsbKategObd_SCR:drgDialogEnd(drgDialog)
  KategZVI->( mh_ClrFilter())
RETURN self

********************************************************************************
METHOD ZVI_zsbKategObd_SCR:ItemMarked()
  Local cScope := StrZero( KategZVI->nZvirKat, 6)

  ZvKatOBDw->( mh_SetScope( cScope))
  *
  IF ::oneKategZVI
    ::createKUMUL()
    *
    ::dc:oBrowse[2]:oXbp:refreshAll()
    ::dm:refresh()
  ENDIF
RETURN SELF

********************************************************************************
METHOD ZVI_zsbKategObd_SCR:destroy()
  ::drgUsrClass:destroy()
  *
  ::nROK       := ::nObdPOC    := ::nObdKON    := ::oneKategZVI := ;
  ::nKusyPocZV := ::nMnozPocZV := ::nCenaPocZV := ::nKdPocZV    := ;
  ::nKusyPoc   := ::nMnozPoc   := ::nCenaPoc   := ::nKdPoc   := ;
  ::nKusyKon   := ::nMnozKon   := ::nCenaKon   := ::nKdKon   := ;
  ::nKusyPrij  := ::nMnozPrij  := ::nCenaPrij  := ::nKdPrij  := ;
  ::nKusyVydej := ::nMnozVydej := ::nCenaVydej := ::nKdVydej := ;
  ::nKusyPr    := ::nMnozPr    := ::nCenaPr    := ;
  ::nKusyPrOr  := ::nMnozPrOr  := ::nCenaPrOr  := ;
  NIL
RETURN self

********************************************************************************
METHOD ZVI_zsbKategObd_SCR:createKUMUL()
  Local cKey, cKeyPS, nMes
  *
  IF( ::oneKategZVI, ZvKatOBDw->( dbZAP()), NIL )
  *
  ::nKusyPocZV := ::nMnozPocZV := ::nCenaPocZV := ::nKdPocZV := ;
  ::nKusyPoc   := ::nMnozPoc   := ::nCenaPoc   := ::nKdPoc   := ;
  ::nKusyKon   := ::nMnozKon   := ::nCenaKon   := ::nKdKon   := ;
  ::nKusyPrij  := ::nMnozPrij  := ::nCenaPrij  := ::nKdPrij  := ;
  ::nKusyVydej := ::nMnozVydej := ::nCenaVydej := ::nKdVydej := ;
  ::nKusyPr    := ::nMnozPr    := ::nCenaPr    := ;
  ::nKusyPrOr  := ::nMnozPrOr  := ::nCenaPrOr  := 0
  *
  * poè. stavy za kategorii
  cKeyPS := StrZero(::nRok, 4) + StrZero( KategZVI->nZvirKat, 6)
  ZvKarty_ps->( mh_SetScope( cKeyPS))
  ZvKarty_ps->( dbEval( {|| ::nKusyPocZV += ZvKarty_ps->nKusyPocZV ,;
                            ::nMnozPocZV += ZvKarty_ps->nMnozPocZV ,;
                            ::nCenaPocZV += ZvKarty_ps->nCenaPocZV ,;
                            ::nKdPocZV   += ZvKarty_ps->nKdPocZV    } ))
  ::nKusyPoc   := ::nKusyPocZV
  ::nMnozPoc   := ::nMnozPocZV
  ::nCenaPoc   := ::nCenaPocZV
  ::nKdPoc     := ::nKdPocZV
  *
  ZvKarty_ps->( mh_ClrScope())
  *
  FOR nMes := ::nObdPOC TO ::nObdKON
    * kumulace pohybù
    cKey := StrZero( KategZVI->nZvirKat, 6) + StrZero(::nRok, 4) + StrZero(nMes, 2)
    ZvZmHD_1->( mh_SetScope( cKey))
    *
    Do While !ZvZmHD_1->( Eof())
       *
       ::nKusyPrij  += If( ZvZmHD_1->nTypPohyb =  1 , ZvZmHD_1->nKusyZV , 0 )
       ::nKusyVydej += If( ZvZmHD_1->nTypPohyb = -1 , ZvZmHD_1->nKusyZV , 0 )
       ::nMnozVydej += If( ZvZmHD_1->nTypPohyb = -1 , ZvZmHD_1->nMnozsZV, 0 )
       ::nCenaPrij  += If( ZvZmHD_1->nTypPohyb =  1 , ZvZmHD_1->nCenacZV, 0 )
       ::nCenaVydej += If( ZvZmHD_1->nTypPohyb = -1 , ZvZmHD_1->nCenacZV, 0 )
       ::nKdPrij    += If( ZvZmHD_1->nTypPohyb =  1 , ZvZmHD_1->nKD     , 0 )
       ::nKdVydej   += If( ZvZmHD_1->nTypPohyb = -1 , ZvZmHD_1->nKD     , 0 )

//     vylouèí naèítání l mléka z množství
       if ZvZmHD_1->ctyppohybu <> '85'
         ::nMnozPrij  += If( ZvZmHD_1->nTypPohyb =  1 , ZvZmHD_1->nMnozsZV, 0 )
       endif

       IF ZvZmHD_1->lProdukce
         /* 9.2.12
         ::nKusyPr   += ZvZmHD_1->nKusyZV
         ::nMnozPr   += ZvZmHD_1->nMnozsZV
         ::nCenaPr   += ZvZmHD_1->nCenacZV
         ::nKusyPrOR += ZvZmHD_1->nKusyZV
         ::nMnozPrOR += ZvZmHD_1->nMnozsZV
         ::nCenaPrOR += ZvZmHD_1->nCenacZV
         */
         ::nKusyPr   += ZvZmHD_1->nKusyZV   * ZvZmHD_1->nTypPohyb
         ::nMnozPr   += ZvZmHD_1->nMnozsZV  * ZvZmHD_1->nTypPohyb
         ::nCenaPr   += ZvZmHD_1->nCenacZV  * ZvZmHD_1->nTypPohyb
         ::nKusyPrOR += ZvZmHD_1->nKusyZV   * ZvZmHD_1->nTypPohyb
         ::nMnozPrOR += ZvZmHD_1->nMnozsZV  * ZvZmHD_1->nTypPohyb
         ::nCenaPrOR += ZvZmHD_1->nCenacZV  * ZvZmHD_1->nTypPohyb

       ENDIF

       ZvZmHD_1->( dbSkip())
    EndDo

    * zápis do KUMULU
    mh_CopyFLD( 'KategZVI', 'ZvKatOBDw', .T.)
    ZvKatOBDw->nRok     := ::nROK
    ZvKatOBDw->nObdobi  := nMes
    ZvKatOBDw->cObdobi  := StrZero( nMes, 2) + '/' + RIGHT( STR(::nROK), 2)
    *
    ZvKatOBDw->nKusyPocZV := ::nKusyPocZV
    ZvKatOBDw->nMnozPocZV := ::nMnozPocZV
    ZvKatOBDw->nCenaPocZV := ::nCenaPocZV
    ZvKatOBDw->nKdPocZV   := ::nKdPocZV
    *
    ZvKatOBDw->nKusyPoc   := ::nKusyPoc
    ZvKatOBDw->nMnozPoc   := ::nMnozPoc
    ZvKatOBDw->nCenaPoc   := ::nCenaPoc
    ZvKatOBDw->nKdPoc     := ::nKdPoc
    *
    ZvKatOBDw->nKusyPrij  := ::nKusyPrij
    ZvKatOBDw->nMnozPrij  := ::nMnozPrij
    ZvKatOBDw->nCenaPrij  := ::nCenaPrij
    ZvKatOBDw->nKdPrij    := ::nKdPrij
    *
    ZvKatOBDw->nKusyVydej := ::nKusyVydej
    ZvKatOBDw->nMnozVydej := ::nMnozVydej
    ZvKatOBDw->nCenaVydej := ::nCenaVydej
    ZvKatOBDw->nKdVydej   := ::nKdVydej
    *
    ZvKatOBDw->nKusyKon   := ::nKusyPoc + ::nKusyPrij - ::nKusyVydej
    ZvKatOBDw->nMnozKon   := ::nMnozPoc + ::nMnozPrij - ::nMnozVydej
    ZvKatOBDw->nCenaKon   := ::nCenaPoc + ::nCenaPrij - ::nCenaVydej
    ZvKatOBDw->nKdKon     := ::nKdPoc   + ::nKdPrij   - ::nKdVydej
    *
    ZvKatOBDw->nKusyRoz  := ZvKatOBDw->nKusyKon - ZvKatOBDw->nKusyPoc
    ZvKatOBDw->nMnozRoz  := ZvKatOBDw->nMnozKon - ZvKatOBDw->nMnozPoc
    ZvKatOBDw->nCenaRoz  := ZvKatOBDw->nCenaKon - ZvKatOBDw->nCenaPoc
    ZvKatOBDw->nKdRoz    := ZvKatOBDw->nKdKon   - ZvKatOBDw->nKdPoc
    *
    if ZvKatOBDw->nCenaKon <> 0
      ZvKatOBDw->nPrumCena  := ZvKatOBDw->nCenaKon / ;
          IF( KategZvi->nTypVypCel = 1, ZvKatOBDw->nMnozKon, ZvKatOBDw->nKusyKon)
    endif
   *
    ZvKatOBDw->nKusyPr   := ::nKusyPr
    ZvKatOBDw->nKusyPrOr := ::nKusyPrOr
    ZvKatOBDw->nMnozPr   := ::nMnozPr
    ZvKatOBDw->nMnozPrOr := ::nMnozPrOr
    ZvKatOBDw->nCenaPr   := ::nCenaPr
    ZvKatOBDw->nCenaPrOr := ::nCenaPrOr
    *
    ZvKatOBDw->cNazevKAT  := KategZvi->cNazevKAT
    *
    ::nKusyKon := ZvKatOBDw->nKusyKon
    ::nMnozKon := ZvKatOBDw->nMnozKon
    ::nCenaKon := ZvKatOBDw->nCenaKon
    ::nKdKon   := ZvKatOBDw->nKdKon
    ::nKusyPoc := ::nKusyKon
    ::nMnozPoc := ::nMnozKon
    ::nCenaPoc := ::nCenaKon
    ::nKdPoc   := ::nKdKon
    ::nKusyPrij  := ::nMnozPrij  := ::nCenaPrij  := ::nKdPrij  := ;
    ::nKusyVydej := ::nMnozVydej := ::nCenaVydej := ::nKdVydej := 0
    *
    ::nKusyPr    := ::nMnozPr    := ::nCenaPr    :=  0
    *
    ZvZmHD_1->( mh_ClrScope())
  NEXT
  ZvKatOBDw->( dbGoTOP())
  *
RETURN SELF

********************************************************************************
METHOD ZVI_zsbKategObd_SCR:ZVI_KUMUL()
  Local cC := 'Požadujete provést výpoèet kumulací pro všechny kategorie ?'
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')
  Local nRec := KategZVI->( RecNO()), nCount := 0
  *
  IF drgIsYESNO(drgNLS:msg( cC))
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg('Generuji stavy za kategorie a období ...', 'KATEGZVI'), KATEGZVI->(LASTREC()) )
    ::oneKategZVI := .F.
    ZvKatOBDw->( dbZAP())
    KATEGZVI->( dbGoTOP())
    DO WHILE !KATEGZVI->( EOF())
      ::createKUMUL( .F.)

      KATEGZVI->( dbSkip())
      drgServiceThread:progressInc()
    ENDDO
    KATEGZVI->( dbGoTO( nRec))
    drgServiceThread:progressEnd()
    ::msg:WriteMessage(,0)
    *
    ::copyToKUMUL()
  ENDIF
  *
RETURN SELF

********************************************************************************
METHOD ZVI_zsbKategObd_SCR:copyToKUMUL( lASK)
  Local cTAG, lOK := .T.
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')

  DEFAULT lASK TO .T.
  *
  IF lASK
    lOK := drgIsYESNO(drgNLS:msg( 'Požadujete uložit výpoètenou kumulaci pro všechny kategorie ?'))
  ENDIF

  IF lOK
    IF( Select('ZvKatOBD') <> 0, ZvKatOBD->( dbCloseArea()), NIL )
    drgDBMS:open('ZvKatOBD', .T. )
    IF ZvKatOBD->( FLock())
      IF( lASK, ::msg:writeMessage( cMsg ,DRG_MSG_WARNING), NIL )
      drgServiceThread:progressStart(drgNLS:msg('Ukládám vypoètené kumulace ...', 'ZvKatOBDw'), ZvKatOBDw->(LASTREC()) )
      ZvKatOBD->( dbZAP())

      cTag := ZvKatOBDw->( AdsSetOrder(0))
      ZvKatOBDw->( dbGoTOP())
      DO WHILE !ZvKatOBDw->( EOF())
        mh_CopyFLD( 'ZvKatOBDw', 'ZvKatOBD', .T.)
        ZvKatOBDw->( dbSkip())
        drgServiceThread:progressInc()
      ENDDO
      ZvKatOBDw->( AdsSetOrder( cTag))

      ZvKatOBD->( dbUnlock(), dbCloseArea() )
      drgServiceThread:progressEnd()
      IF( lASK, ::msg:WriteMessage(,0), NIL )
    ELSE
      drgMsgBox(drgNLS:msg( 'Kumulativní soubor [ ZVKATOBD] se nepodaøilo uzamknout ... '))
    ENDIF
  ENDIF
  *
RETURN SELF

* Aktualizace ( pøepoèet) kumulativního souboru ZvKatOBDw  pøed TISKEM
*===============================================================================
FUNCTION ZVI_ZVKATOBD_PRN()
  Local zsbKategObd, nCenaCelk := 0

  zsbKategObd             := ZVI_zsbKategObd_SCR():new()
  zsbKategObd:oneKategZVI := .F.                         // generovat za všechny položky ZVKARTY
  zsbKategObd:nRok        := VAL( RIGHT( obdReport, 4))
  zsbKategObd:nObdKON     := VAL( LEFT( obdReport, 2))
  *
  drgServiceThread:progressStart(drgNLS:msg('Generuji stavy za kategorie a období ' + obdReport + ' ...', 'KATEGZVI'), KATEGZVI->(LASTREC()) )

  ZvKatOBDw->( dbZAP(), mh_ClrScope() )
  KATEGZVI->( dbGoTOP())
  DO WHILE !KATEGZVI->( EOF())
    zsbKategObd:createKUMUL()
    KATEGZVI->( dbSkip())
    drgServiceThread:progressInc()
  ENDDO
  *
  drgServiceThread:progressEnd()
  *
  * Ponecháme jen poslední období
  cTag := ZvKatOBDw->( AdsSetOrder(0))
  ZvKatOBDw->( dbGoTOP())
  Do While !ZvKatOBDw->( Eof())
    IF ZvKatOBDw->nObdobi = zsbKategObd:nObdKON
      nCenaCelk += ZvKatOBDw->nCenaKon
    ELSE
      ZvKatOBDw->( dbDelete())
    ENDIF
    ZvKatOBDw->( dbSkip())
  EndDo
  ZvKatOBDw->( AdsSetOrder(cTag), dbPack(), dbGoTOP())
  *
  ZvKatOBDw->( dbEval( {|| ZvKatOBDw->nCenaCelk := nCenaCelk } ) ,;
               dbGoTOP() )
RETURN NIL

* Aktualizace ( pøepoèet) kumulativních souborù ZvKatOBDw, ZvZmOBDw  pøed TISKEM
*===============================================================================
FUNCTION ZVI_OBRATKAT_PRN()
  ZVI_ZVKATOBD_PRN()
  ZVI_ZVZMOBD_PRN( 2)
RETURN NIL