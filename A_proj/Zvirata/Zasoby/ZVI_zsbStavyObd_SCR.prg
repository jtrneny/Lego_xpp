********************************************************************************
* ZVI_zsbStavyObd_SCR.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
* ZVI_StavyObd_SCR ... Stavy za období
********************************************************************************
CLASS ZVI_zsbStavyObd_SCR FROM drgUsrClass
EXPORTED:
  VAR     nROK, nObdPOC, nObdKON, oneZvKarty
  VAR     nKusyPoc  , nMnozPoc  , nCenaPoc  , nKdPoc
  VAR     nKusyKon  , nMnozKon  , nCenaKon  , nKdKon
  VAR     nKusyPrij , nMnozPrij , nCenaPrij , nKdPrij
  VAR     nKusyVydej, nMnozVydej, nCenaVydej, nKdVydej
  VAR     nKusyPr   , nMnozPr   , nCenaPr
  VAR     nKusyPrOr , nMnozPrOr , nCenaPrOr

  METHOD  Init, Destroy, ItemMarked, drgDialogStart, eventHandled
  METHOD  ZVI_KUMUL, createKUMUL, copyToKUMUL

HIDDEN
  VAR     dc, dm, msg, cUser, dDate, cTime
ENDCLASS

********************************************************************************
METHOD ZVI_zsbStavyObd_SCR:init(parent)
  *
*  ::drgUsrClass:init(parent)
  drgDBMS:open('ZvKarty'   )
  drgDBMS:open('cNazPOL1'  )
  drgDBMS:open('cNazPOL4'  )
  drgDBMS:open('KategZvi'  )
  drgDBMS:open('C_UCTSKZ'  )
  drgDBMS:open('C_FarmyV'  )
  drgDBMS:open('ZvKarty_ps')
  *
  drgDBMS:open('ZvKarOBDw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('ZvZmenHD',,,,.T.,'ZvZmHD_1')
  ZvZmHD_1->( AdsSetOrder( 6))
  *
  ::oneZvKarty := .T.
  ::cUser      := SysConfig( "System:cUserABB")
  ::dDate      := Date()
  ::cTime      := Time()
  *
  ::nROK    := uctObdobi:ZVI:nROK
  ::nObdPOC := 1
  ::nObdKON := uctObdobi:ZVI:nOBDOBI
  *
RETURN self

********************************************************************************
METHOD ZVI_zsbStavyObd_SCR:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
  *
  ZvKarty->( DbSetRelation( 'KategZvi'  , {|| ZvKarty->nZvirKat  } ,'ZvKarty->nZvirKat'  ))
  ZvKarty->( DbSetRelation( 'C_UctSkZ'  , {|| ZvKarty->nUcetSkup } ,'ZvKarty->nUcetSkup' ))

RETURN self

********************************************************************************
METHOD ZVI_zsbStavyObd_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local lOK := .T.

  DO CASE
    CASE nEvent = drgEVENT_OBDOBICHANGED

      ::nROK    := uctObdobi:ZVI:nROK
      ::nObdKON := uctObdobi:ZVI:nOBDOBI
      ZvKarOBDw->( dbZap())
      ::itemMarked()

      RETURN .T.
    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD ZVI_zsbStavyObd_SCR:ItemMarked()
  Local cScope  := Upper(ZvKarty->cNazPol1) + Upper(ZvKarty->cNazPol4) + StrZero( ZvKarty->nZvirKat, 6)
  Local nRok    := IF( ZvKarOBDw->( LastRec()) = 0, ::nRok   , ZvKarOBDw->nRok    )
  Local nObdobi := IF( ZvKarOBDw->( LastRec()) = 0, ::nObdKon, ZvKarOBDw->nObdobi )

  ZvKarOBDw->( mh_SetScope( cScope))
  *
  IF ::oneZvKarty
    ::createKUMUL()
    *
    ZvKarOBDw->( dbSeek( cScope + StrZero(nRok,4) + StrZero(nObdobi,2),, AdsCtag(1) ))
    ::dc:oBrowse[2]:oXbp:refreshAll()
    ::dm:refresh()
  ENDIF
RETURN SELF

********************************************************************************
METHOD ZVI_zsbStavyObd_SCR:destroy()
  ::drgUsrClass:destroy()
  *
  ::nROK       := ::nObdPOC    := ::nObdKON    := ::oneZvKarty := ;
  ::nKusyPoc   := ::nMnozPoc   := ::nCenaPoc   := ::nKdPoc   := ;
  ::nKusyKon   := ::nMnozKon   := ::nCenaKon   := ::nKdKon   := ;
  ::nKusyPrij  := ::nMnozPrij  := ::nCenaPrij  := ::nKdPrij  := ;
  ::nKusyVydej := ::nMnozVydej := ::nCenaVydej := ::nKdVydej := ;
  ::nKusyPr    := ::nMnozPr    := ::nCenaPr    := ;
  ::nKusyPrOr  := ::nMnozPrOr  := ::nCenaPrOr  := ;
  NIL
RETURN self

*
********************************************************************************
METHOD ZVI_zsbStavyObd_SCR:createKUMUL()
  Local cKey := Upper(ZvKarty->cNazPol1) + Upper(ZvKarty->cNazPol4) + StrZero( ZvKarty->nZvirKat, 6)
  Local cNazevPOL1 := if( cNazPol1->( dbSEEK( Upper(ZvKarty->cNazPol1),, 'CNAZPOL1' )),  cNazPol1->cNazev, '' )
  Local cNazevPOL4 := if( cNazPol4->( dbSEEK( Upper(ZvKarty->cNazPol4),, 'CNAZPOL1' )),  cNazPol4->cNazev, '' )
  Local cNazevKAT  := if( KategZvi->( dbSEEK( ZvKarty->nZvirKat,, 'KATEGZVI_1' ))     ,  KategZvi->cNazevKAT, '' )
  Local nMes, lOK
  *
  IF( ::oneZvKarty, ZvKarOBDw->( dbZAP()), NIL )
  *
  ::nKusyPoc   := ::nMnozPoc   := ::nCenaPoc   := ::nKdPoc   := ;
  ::nKusyKon   := ::nMnozKon   := ::nCenaKon   := ::nKdKon   := ;
  ::nKusyPrij  := ::nMnozPrij  := ::nCenaPrij  := ::nKdPrij  := ;
  ::nKusyVydej := ::nMnozVydej := ::nCenaVydej := ::nKdVydej := ;
  ::nKusyPr    := ::nMnozPr    := ::nCenaPr    := ;
  ::nKusyPrOr  := ::nMnozPrOr  := ::nCenaPrOr  := 0

  * roèní poè. stavy
  IF ZvKarty_ps->( dbSEEK( cKEY + StrZero(::nRok, 4),,'ZVKARPS_01'))
    ::nKusyPoc := ZvKarty_ps->nKusyPocZV
    ::nMnozPoc := ZvKarty_ps->nMnozPocZV
    ::nCenaPoc := ZvKarty_ps->nCenaPocZV
    ::nKdPoc   := ZvKarty_ps->nKdPocZV
  ENDIF
  *
  FOR nMes := ::nObdPOC TO ::nObdKON
    * kumulace pohybù
    cKey := Upper(ZvKarty->cNazPol1) + Upper(ZvKarty->cNazPol4) + StrZero( ZvKarty->nZvirKat, 6) + ;
            StrZero(::nRok, 4) + StrZero(nMes, 2)
    ZvZmHD_1->( mh_SetScope( cKey))
    *
    Do While !ZvZmHD_1->( Eof())
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
         /* 9.2.2012
         ::nKusyPr   += ZvZmHD_1->nKusyZV
         ::nMnozPr   += ZvZmHD_1->nMnozsZV
         ::nCenaPr   += ZvZmHD_1->nCenacZV
         ::nKusyPrOR += ZvZmHD_1->nKusyZV
         ::nMnozPrOR += ZvZmHD_1->nMnozsZV
         ::nCenaPrOR += ZvZmHD_1->nCenacZV
         */
         ::nKusyPr   += ZvZmHD_1->nKusyZV   * ZvZmHD_1->nTypPohyb
         ::nCenaPr   += ZvZmHD_1->nCenacZV  * ZvZmHD_1->nTypPohyb
         ::nKusyPrOR += ZvZmHD_1->nKusyZV   * ZvZmHD_1->nTypPohyb
         ::nCenaPrOR += ZvZmHD_1->nCenacZV  * ZvZmHD_1->nTypPohyb
         ::nMnozPrOR += ZvZmHD_1->nMnozsZV  * ZvZmHD_1->nTypPohyb
         ::nMnozPr   += ZvZmHD_1->nMnozsZV  * ZvZmHD_1->nTypPohyb
       ENDIF

       ZvZmHD_1->( dbSkip())
    EndDo

    * zápis do KUMULU
    mh_CopyFLD( 'ZvKARTY', 'ZvKarOBDw', .T.)
    ZvKarOBDw->nRok     := ::nROK
    ZvKarOBDw->nObdobi  := nMes
    ZvKarOBDw->cObdobi  := StrZero( nMes, 2) + '/' + RIGHT( STR(::nROK), 2)
    * stavy na poèátku roku
    ZvKarOBDw->nKusyPocZV := ZvKarty_ps->nKusyPocZV
    ZvKarOBDw->nMnozPocZV := ZvKarty_ps->nMnozPocZV
    ZvKarOBDw->nCenaPocZV := ZvKarty_ps->nCenaPocZV
    ZvKarOBDw->nKdPocZV   := ZvKarty_ps->nKdPocZV
    * stavy na poè. období
    ZvKarOBDw->nKusyPoc   := ::nKusyPoc
    ZvKarOBDw->nMnozPoc   := ::nMnozPoc
    ZvKarOBDw->nCenaPoc   := ::nCenaPoc
    ZvKarOBDw->nKdPoc     := ::nKdPoc
    *
    ZvKarOBDw->nKusyPrij  := ::nKusyPrij
    ZvKarOBDw->nMnozPrij  := ::nMnozPrij
    ZvKarOBDw->nCenaPrij  := ::nCenaPrij
    ZvKarOBDw->nKdPrij    := ::nKdPrij
    *
    ZvKarOBDw->nKusyVydej := ::nKusyVydej
    ZvKarOBDw->nMnozVydej := ::nMnozVydej
    ZvKarOBDw->nCenaVydej := ::nCenaVydej
    ZvKarOBDw->nKdVydej   := ::nKdVydej
    *
    ZvKarOBDw->nKusyKon   := ::nKusyPoc + ::nKusyPrij - ::nKusyVydej
    ZvKarOBDw->nMnozKon   := ::nMnozPoc + ::nMnozPrij - ::nMnozVydej
    ZvKarOBDw->nCenaKon   := ::nCenaPoc + ::nCenaPrij - ::nCenaVydej
    ZvKarOBDw->nKdKon     := ::nKdPoc   + ::nKdPrij   - ::nKdVydej
    *
    ZvKarOBDw->nKusyRoz   := ZvKarOBDw->nKusyKon - ZvKarOBDw->nKusyPoc
    ZvKarOBDw->nMnozRoz   := ZvKarOBDw->nMnozKon - ZvKarOBDw->nMnozPoc
    ZvKarOBDw->nCenaRoz   := ZvKarOBDw->nCenaKon - ZvKarOBDw->nCenaPoc
    ZvKarOBDw->nKdRoz     := ZvKarOBDw->nKdKon   - ZvKarOBDw->nKdPoc
    *
    if ZvKarOBDw->nCenaKon <> 0
      ZvKarOBDw->nPrumCena  := ZvKarOBDw->nCenaKon / ;
        IF( KategZvi->nTypVypCel = 1, ZvKarOBDw->nMnozKon, ZvKarOBDw->nKusyKon)
    endif
    *
    ZvKarOBDw->nKusyPr    := ::nKusyPr
    ZvKarOBDw->nKusyPrOr  := ::nKusyPrOr
    ZvKarOBDw->nMnozPr    := ::nMnozPr
    ZvKarOBDw->nMnozPrOr  := ::nMnozPrOr
    ZvKarOBDw->nCenaPr    := ::nCenaPr
    ZvKarOBDw->nCenaPrOr  := ::nCenaPrOr
    *
    ZvKarOBDw->cNazevPOL1 := cNazevPOL1
    ZvKarOBDw->cNazevPOL4 := cNazevPOL4
    ZvKarOBDw->cNazevKAT  := cNazevKAT
    C_FarmyV->( dbSEEK( Upper( ZvKarOBDw->cNazPol4),, 'FARMYV_1'))
    ZvKarOBDw->cFarma     := PADR( ALLTRIM( STR( C_FarmyV->nFARMA )), 10)
    *
    mh_WRTzmena( 'ZvKarOBDw', .T.)
    *
    ::nKusyKon := ZvKarOBDw->nKusyKon
    ::nMnozKon := ZvKarOBDw->nMnozKon
    ::nCenaKon := ZvKarOBDw->nCenaKon
    ::nKdKon   := ZvKarOBDw->nKdKon
    *
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
  ZvKarOBDw->( dbGoTOP())
  *
RETURN SELF

********************************************************************************
METHOD ZVI_zsbStavyObd_SCR:ZVI_KUMUL()
  Local cC := 'Požadujete provést výpoèet kumulací pro všechny karty ?'
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')
  Local nRec := ZVKARTY->( RecNO()), nCount := 0
  *
  IF drgIsYESNO(drgNLS:msg( cC))
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg('Generuji stavy za období ...', 'ZVKARTY'), ZVKARTY->(LASTREC()) )
    ::oneZvKarty := .F.
    ZvKarOBDw->( dbZAP())
    ZVKARTY->( dbGoTOP())
    DO WHILE !ZVKARTY->( EOF())
      ::createKUMUL( .F.)
*      nCount++
*      IF( nCount % 500 = 0, ::msg:writeMessage( cMsg + ' - ' + Str( nCount) ,DRG_MSG_WARNING), NIL )
      ZVKARTY->( dbSkip())
      drgServiceThread:progressInc()
    ENDDO
    ZVKARTY->( dbGoTO( nRec))
    drgServiceThread:progressEnd()
    ::msg:WriteMessage(,0)
    *
    ::copyToKUMUL()
  ENDIF
  *
RETURN SELF

********************************************************************************
METHOD ZVI_zsbStavyObd_SCR:copyToKUMUL( lASK)
  Local cTAG, lOK := .T.
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')
  local filtr

  DEFAULT lASK TO .T.
  *
  IF lASK
    lOK := drgIsYESNO(drgNLS:msg( 'Požadujete uložit výpoètenou kumulaci pro všechny karty ?'))
  ENDIF

  IF lOK
    drgDBMS:open('zvkarobd',,,,,'zvkarobda')
//    IF( lASK, ::msg:writeMessage( cMsg ,DRG_MSG_WARNING), NIL )
    drgServiceThread:progressStart(drgNLS:msg('Ukládám vypoètené kumulace ...', 'ZvKarOBDw'), ZvKarOBDw->(LASTREC()) )

    cTag := ZvKarOBDw->( AdsSetOrder(0))
    ZvKarOBDw->( dbGoTOP())

//      ZvKarOBD->( dbZAP())
    filtr     := format( "nrok = %%", { ZvKarOBDw->nrok})
    zvkarobda->( ads_setAof(filtr),dbgoTop())
    zvkarobda->( dbEval( {|| if( dbRlock(), dbDelete(), nil)}) )
    zvkarobda->( dbUnlock())
    zvkarobda->( ads_clearAof())

    do while !ZvKarOBDw->( EOF())
      mh_CopyFLD( 'ZvKarOBDw', 'ZvKarOBDa', .T.)
      ZvKarOBDw->( dbSkip())
      drgServiceThread:progressInc()
    enddo
    ZvKarOBDw->( AdsSetOrder( cTag))

    ZvKarOBDa->( dbUnlock(), dbCloseArea() )
    drgServiceThread:progressEnd()
    IF( lASK, ::msg:WriteMessage(,0), NIL )
//      drgMsgBox(drgNLS:msg( 'Kumulativní soubor [ ZVKAROBD] se nepodaøilo uzamknout ... '))
  ENDIF
  *
RETURN SELF

* Aktualizace ( pøepoèet) kumulativního souboru ZvKarOBDw  pøed TISKEM
*===============================================================================
FUNCTION ZVI_ZVKAROBD_PRN()
  Local zsbStavyObd, cTag

  zsbStavyObd            := ZVI_zsbStavyObd_SCR():new()
  zsbStavyObd:oneZvKarty := .F.  // generovat za všechny položky ZVKARTY
  zsbStavyObd:nRok       := VAL( RIGHT( obdReport, 4))
  zsbStavyObd:nObdKON    := VAL( LEFT( obdReport, 2))
  *
  drgServiceThread:progressStart(drgNLS:msg('Generuji stavy za období ' + obdReport + ' ...', 'ZVKARTY'), ZVKARTY->(LASTREC()) )

  ZvKarOBDw->( dbZAP(), mh_ClrScope() )
  ZVKARTY->( dbGoTOP())
  DO WHILE !ZVKARTY->( EOF())
    zsbStavyObd:createKUMUL()
    ZVKARTY->( dbSkip())
    drgServiceThread:progressInc()
  ENDDO
  *
  drgServiceThread:progressEnd()

  * Ponecháme jen poslední období
  cTag := ZvKarOBDw->( AdsSetOrder(0))
  ZvKarOBDw->( dbGoTOP())
  Do While !ZvKarOBDw->( Eof())
    IF ZvKarOBDw->nObdobi <> zsbStavyObd:nObdKON
      ZvKarOBDw->( dbDelete())
    ENDIF
    ZvKarOBDw->( dbSkip())
  EndDo
  ZvKarOBDw->( AdsSetOrder(cTag), dbPack(), dbGoTOP())

RETURN NIL

* Aktualizace ( pøepoèet) kumulativních souborù ZvKarOBDw, ZvZmOBDw  pøed TISKEM
*===============================================================================
FUNCTION ZVI_OBRATOBD_PRN()
  ZVI_ZVKAROBD_PRN()
  ZVI_ZVZMOBD_PRN( 1)
RETURN NIL
