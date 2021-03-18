/*==============================================================================
  ZVI_opeZvirata_SCR.PRG
==============================================================================*/

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Xbp.ch"
#include "Gra.ch"
#include "Collat.ch"

#Define  TAB_UCETNI      1
#Define  TAB_NEUCETNI    2
#Define  TAB_ZAKLUDAJE   3

********************************************************************************
*
********************************************************************************
CLASS ZVI_opeZvirata_SCR FROM drgUsrClass
EXPORTED:
  METHOD  Init, drgDialogStart, EventHandled, ItemMarked, tabSelect
  METHOD  opePrecisREG

HIDDEN
  VAR     dc, tabNum
ENDCLASS

********************************************************************************
METHOD ZVI_opeZvirata_SCR:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('KategZVI'  )
  drgDBMS:open('C_TypPoh'  )
*  drgDBMS:open('C_DrPohZ'  )
  drgDBMS:open('C_DrPohP'  )
  drgDBMS:open('CNAZPOL1'  )
  drgDBMS:open('CNAZPOL4'  )
  *
RETURN self

********************************************************************************
METHOD ZVI_opeZvirata_SCR:drgDialogStart(drgDialog)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  Zvirata->( DbSetRelation( 'KategZvi'  , {|| Zvirata->nZvirKat  } ,'Zvirata->nZvirKat'  ))
  *
*  ZvZmenIT->( DbSetRelation( 'C_DrPohZ' , {|| ZvZmenIT->nDrPohyb } ,'ZvZmenIT->nDrPohyb' ))
  ZvZmenIT->( DbSetRelation( 'C_DrPohP' , {|| ZvZmenIT->nDrPohybP} ,'ZvZmenIT->nDrPohybP'))
  ZvZmenIT->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+ UPPER(CTYPPOHYBU) },;
                                         'UPPER(cULOHA)+UPPER(CTYPPOHYBU))', 'C_TYPPOH06'))
  ::dc     := drgDialog:dialogCtrl
  ::tabNum := TAB_UCETNI
RETURN

********************************************************************************
METHOD ZVI_opeZvirata_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
    /*
    CASE nEvent = drgEVENT_APPEND
      IF ::tabNum = TAB_UCETNI .and. ::dc:oaBrowse:cFile = 'ZvZmenHD'
*        drgMsgBox(drgNLS:msg( '��etn�  zm�ny INSERT' ))
        ::zsbPohyby( nEvent)
      ELSEIF ::tabNum = TAB_NEUCETNI
      ELSE
        RETURN .F.
      ENDIF

    CASE nEvent = drgEVENT_EDIT
      IF ::tabNum = TAB_UCETNI .and. ::dc:oaBrowse:cFile = 'ZvZmenHD'
*        drgMsgBox(drgNLS:msg( '��etn�  zm�ny ENTER' ))
        ::zsbPohyby( nEvent)
      ELSEIF ::tabNum = TAB_NEUCETNI
      ELSE
        RETURN .F.
      ENDIF
    */
    CASE nEvent = drgEVENT_DELETE
      IF ::dc:oaBrowse:cFile = 'Zvirata'
        ZVI_opeZvirata_DEL()
       ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
*      ELSEIF ::tabNum = TAB_UCETNI .and. ::dc:oaBrowse:cFile = 'ZvZmenHD'
*        drgMsgBox(drgNLS:msg( '��etn�  zm�ny DELETE' ))
*      ELSEIF ::tabNum = TAB_NEUCETNI
      ELSE
        RETURN .F.
      ENDIF


    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD ZVI_opeZvirata_scr:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
RETURN .T.

*******************************************************************************
METHOD ZVI_opeZvirata_SCR:ItemMarked()
  Local cScope := StrZero(Zvirata->nFarma,10) + StrZero(Zvirata->nPorCisLis,10) +;
                  StrZero(Zvirata->nPorCisRad,2)
  ZvZmenIT->( mh_SetScope( cScope))  // ��etn� zm�ny
RETURN SELF

* P�epo�et (p�e��slov�n�) st�jov�ho registru skotu.
*****************************************************************
*FUNCTION PrepRegSKOT()
METHOD ZVI_opeZvirata_SCR:opePrecisREG()
*  Local cText := '', aOld
  Local cKEY, cKEYmin, cKEYod, cTAG, cFARMA, aFARMY := {}
  Local nCount := 1, nRecCount, nRecNO, n
  Local nPorCisLis, nPorCisRad
  Local nROK := uctObdobi:ZVI:nROK, nOBD := uctObdobi:ZVI:nOBDOBI, nROKmin, nOBDmin
  Local nRadRegSko := SysConfig( 'Zvirata:nRadRegSko')
*  Local lOK := .F., cEndText

*  drgMsgBox( drgNLS:msg('P�e��slov�n� st�jov�ho registru ... '))
  *
  IF drgIsYESNO(drgNLS:msg( 'Po�adujete p�e��slovat st�jov� registr skotu za  [ & / & ] ?', nObd, nRok ) )
*  IF BOX_ALERT( cQM, 'P�e��slovat st�jov� registr skotu za ' + STR( nOBD)+'/'+STR( nROK) + ' ?', acNOYES ) == 2
    nRecNO := Zvirata->( RecNO())
    cTAG := Zvirata->( AdsSetOrder( 6))
*    Box_WORK( 1)
    * Zji�t�n� farem v aktu�ln�m obdob�
    cKEY := STRZERO( nROK, 4) + STRZERO( nOBD, 2)
*    SetSCOPE( 'Zvirata', cKEY )
    Zvirata->( mh_SetScope( cKey))
      cFARMA := Zvirata->cFarma
      DO WHILE !Zvirata->( EOF())
        IF cFARMA <> Zvirata->cFARMA
          Zvirata->( dbSKIP( -1))
          AADD( aFARMY,{ Zvirata->cFARMA, 0, 0 } )
          Zvirata->( dbSKIP())
          cFARMA := Zvirata->cFarma
        ENDIF
        Zvirata->( dbSKIP())
      ENDDO
      Zvirata->( dbGoBottom())
      AADD( aFARMY, { Zvirata->cFARMA, 0, 0 } )
*    ClrSCOPE( 'Zvirata')
    Zvirata->( mh_ClrScope())

    * Zji�t�n� posledn�ch hodnot nPorCisLis, nPorCisRad za p�edchoz� obdob�
    Zvirata->( AdsSetOrder( 7), dbGoTOP())
    nOBDmin := IF( nOBD > 1, nOBD - 1, 12   )
    nROKmin := IF( nOBD > 1, nROK, nROK - 1 )

    FOR n := 1 TO LEN( aFARMY)
      cFARMA := aFARMY[ n, 1]
      cKEYod  := UPPER( cFARMA) + '1980' + '01'
      cKEYmin := UPPER( cFARMA) + STRZERO( nROKmin, 4) + STRZERO( nOBDmin, 2)
      Zvirata->( mh_SetSCOPE( cKEYod, cKEYmin ), dbGoBottom())
  //      aFARMY[ n, 2] := Zvirata->nPorCisLis
        aFARMY[ n, 2] := IF( Zvirata->nPorCisLis == 0, 1, Zvirata->nPorCisLis )
        aFARMY[ n, 3] := Zvirata->nPorCisRad
*      ClrSCOPE( 'Zvirata')
      Zvirata->( mh_ClrSCOPE())
    NEXT

    * P�e��slov�n� nPorCisLis, nPorCisRad v aktu�ln�m obdob�
    Zvirata->( AdsSetOrder( 6), dbGoTOP())
    FOR n := 1 TO LEN( aFARMY)
      cFARMA := aFARMY[ n, 1]
      cKEY := STRZERO( nROK, 4) + STRZERO( nOBD, 2) + UPPER( cFARMA)
      nPorCisLis := aFARMY[ n, 2]
      nPorCisRad := aFARMY[ n, 3]
      Zvirata->( mh_SetSCOPE( cKey))
        DO WHILE !Zvirata->( EOF())
          *
          IF ReplREC( 'Zvirata')
            *
            Zvirata->nPorCisLis := IF( nPorCisRAD = nRadRegSko, nPorCisLis + 1, nPorCisLis )
            Zvirata->nPorCisRad := IF( nPorCisRAD = nRadRegSko, 1, nPorCisRAD + 1 )
            mh_wrtzmena( 'Zvirata', .f.)
            nPorCisLis := Zvirata->nPorCisLis
            nPorCisRad := Zvirata->nPorCisRad
            */
            Zvirata->( dbUnlock())
          ENDIF
          *
          Zvirata->( dbSKIP())
        ENDDO
      Zvirata->( mh_ClrSCOPE())
    NEXT
*    Box_WORK()
    Zvirata->( AdsSetOrder( cTAG), dbGoTO( nRecNO) )
    *
    drgMsgBox( drgNLS:msg('St�jov� registr skotu   P�E��SLOV�N ... '))
  ENDIF
  *

RETURN self


*===============================================================================
FUNCTION  ZVI_opeZvirata_DEL()
  Local  cText := 'Kartu zv��ete nelze zru�it, nebo� ', acText, cKey
  Local  lDEL := YES, lOK := YES

  drgMsgBox(drgNLS:msg( 'SORRY ... zat�m neru��me' ))
/*
  cKey := StrZERO( uctObdobi:SKL:nROK, 4) + Upper( ZvKarty->cNazPol1) + ;
          Upper( ZvKarty->cNazPol4) + StrZero( ZvKarty->nZvirKat, 6 )
  IF  ZvZmenHd->( dbSeek( cKey,, 7))
      cText += ' ; existuj� k n� pohybov� v�ty !'
      lDEL := NO
  ENDIF
  IF ZvKarty->nMnozSZv <> 0 .OR. ZvKarty->nKusyZv <> 0 .OR. ZvKarty->nCenaCZv <> 0
    cText += ' ; stav karty nen� nulov� !'
    lDEL := NO
  ENDIF

  IF lDEL
    IF drgIsYesNO(drgNLS:msg('Zru�it eviden�n� kartu zv��ete ?'))
       /*
       lOK := YES
       Do While lOK
         If( lOK := ZvKarObd->( dbSeek( Upper( cKey,, 1))))
            ZvKarObd->(  RLock(), dbDelete(), dbUnlock() )
         EndIf
       EndDo
       *
       ZvKarty->( RLock(), dbDelete(), dbUnlock() )
    Endif
  ELSE
    drgMsgBox(drgNLS:msg( cText ))
  ENDIF
*/
RETURN NIL

*===============================================================================
FUNCTION ZVI_Pohlavi( nPohlavi)
  Local cZnakPohlavi

  DEFAULT nPohlavi TO Zvirata->nPohlavi

  cZnakPohlavi := IF( nPohlavi = 1, '1',;
                  IF( nPohlavi = 2, '2', '' ))
RETURN cZnakPohlavi