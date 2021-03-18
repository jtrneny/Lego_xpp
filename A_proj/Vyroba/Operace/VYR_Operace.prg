/*******************************************************************************
  VYR_OPERACE.PRG
  ------------------------------------------------------------------------------
  XPP              ->  DOS          in   DOS.Prg
  VYR_OPERACE_del()    DelOperace()      VstOPER.Prg
*******************************************************************************/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

*
*===============================================================================
FUNCTION VYR_OPERACE_edit( oDlg, cFILE, lApp)
  LOCAL cKey, lOK, nREC, cField

  DO CASE
  CASE  cFILE = 'OPERACEw'
    IF oDlg:lCopyREC
       SetCopyREC()
    ELSEIF oDlg:lNewREC
       OPERACEw->(dbAppend())
       HodAtrib->( mh_ClrScope(), mh_SetScope( OPERACEw->cOznOper ))
       PPOper->( mh_ClrScope()  , mh_SetScope( OPERACEw->cOznOper ))
    ELSE
       mh_COPYFLD('OPERACE', 'OPERACEw', .T.)
*       HODATRIB->( DbEval( { || mh_COPYFLD('HODATRIB', 'HODATRIBw', .T.) }), DbGoTop() )
*       PPOPER->( DbEval( { || mh_COPYFLD('PPOPER', 'PPOPERw', .T.) }), DbGoTop() )
    ENDIF
    OPERACEw->nPriprCas  := MjCAS( OPERACEw->nPriprCas , to_CFG )
    OPERACEw->nKusovCas  := MjCAS( OPERACEw->nKusovCas , to_CFG )

  CASE  cFILE = 'HodAtrib' .or. cFILE = 'PPOper'
    IF lApp
      nRec := ( cFile)->( RecNO())
      ( cFile)->(dbGoTo(-1))
      oDlg:drgDialog:DataManager:refresh()
      ( cFile)->(dbGoTo( nREC))
    ENDIF
    cField := IF( cFILE = 'HodAtrib', 'HodAtrib->cAtribOper',;
                                      'PPOper->cOznPrPo' )
    oDlg:drgDialog:oForm:setNextFocus( cField,, .t. )
  ENDCASE

RETURN NIL

*
*===============================================================================
FUNCTION VYR_OPERACE_save( oDlg, cFILE, lAppend)
  LOCAL x, dm := oDlg:dataManager, oVar, lOK

  IF ! oDlg:drgDialog:dialogCtrl:isReadOnly
    DO CASE
    CASE cFILE = 'OPERACEw'
      dm:save()
      IF( oDlg:lNewREC, OPERACE->( DbAppend()), NIL )
      IF OPERACE->(sx_RLock())
         mh_COPYFLD('OPERACEw', 'OPERACE' )
  *       mh_WRTzmena( 'OPERACE', oDlg:lNewREC)
         OPERACE->nKoefSmCas := C_Pracov->nKoefSmCas
         OPERACE->nKoefViOb  := C_Pracov->nKoefViOb
         OPERACE->nKoefViSt  := C_Pracov->nKoefViSt
         OPERACE->( dbUnlock())
         oDlg:drgDialog:parent:dialogCtrl:oaBrowse:refresh()
      ENDIF

    CASE cFILE = 'HODATRIB' .or. cFILE = 'PPOPER'
      IF ( lOK := if( lAppend, AddREC( cFILE), ReplREC(cFILE)) )
        ( cFILE)->cOznOper  := OPERACEw->cOznOper
        IF cFILE = 'HODATRIB'
           HODATRIB->cAtribOper := dm:get('HODATRIB->cAtribOper')
           HODATRIB->cHodnAtrC  := dm:get('HODATRIB->cHodnAtrC')
           HODATRIB->nHodnAtrN  := dm:get('HODATRIB->nHodnAtrN')
           HODATRIB->mPoznamka  := dm:get('HODATRIB->mPoznamka')
        ELSE
           PPOPER->cOznPrPo := dm:get('PPOPER->cOznPrPo')
        ENDIF
        ( cFILE)->( dbUnlock())
        ( cFILE)->( mh_ClrScope(), mh_SetScope( OPERACEw->cOznOper ) )
      ENDIF
    ENDCASE
  ENDIF
RETURN NIL


* ZruöenÌ typovÈ operace
*===============================================================================
FUNCTION VYR_OPERACE_del( oDlg)
  Local  lPolOper, lDel := .F.
  Local  cOper := Operace->cOznOper, cMsg
*  Local lOK := .T. // EditOPER( K_DEL)

  FOrdRec( { 'PolOper, 2' } )
  lPolOper := PolOper->( dbSeek( Upper( cOper)))
  FOrdRec()
  IF lPolOper
     cMsg  := 'Nelze zruöit typovou operaci < & >, neboù je pouûita v pracovnÌch postupech !'
     drgMsgBox(drgNLS:msg( cMsg, cOper ), oDlg)
     RETURN lDel
  ENDIF

  cMsg  := '< ZruöenÌ typovÈ operace >;; Zruöit typovou operaci < & > - &  ?'
  IF ( isYES := drgIsYESNO(drgNLS:msg( cMsg, cOper, Operace->cNazOper) ) )
    * Nutno zruöit z·znamy v HodAtrib, a PpOper
     FOrdRec( { 'HodAtrib, 1', 'PpOper, 1' } )
     Do While HodAtrib->( dbSeek( Upper( cOper))) ;  DelRec( 'HodAtrib') ; EndDo
     Do While PpOper->( dbSeek( Upper( cOper)))   ;  DelRec( 'PpOper')   ; EndDo
     FOrdRec()
     DelRec( 'Operace' )
     lDel := .T.
  ENDIF
RETURN lDEL

*===============================================================================
STATIC FUNCTION SetCopyREC()
  LOCAL nPos, aFld
  LOCAL cFld := 'cOznOper,cNazOper,cTypOper,cStred,cOznPrac,cPracZar,nDruhMzdy,' + ;
                'cTarifStup,cTarifTrid,nKusovCas,nPriprCas,lVykazML,nKoefSmCas,' + ;
                'nKoefViSt,nKoefViOb,mTextOper'

  aFld :=  ListAsArray( cFld)
  OPERACEw->( DbAppend())
  aEVAL( aFld, { |X,i| ;
                ( nPos := OPERACE->( FieldPos( X))             , ;
                If( nPos <> 0, OPERACEw->( FieldPut( nPos, OPERACE->( FieldGet( nPos)) )), Nil ) ) } )
RETURN NIL


/*
      TYPE(GET)      NAME(cTypOper)             FPOS(20, 1) FLEN( 15) FCAPTION(Typ operace)        CPOS( 1, 1)
      TYPE(Text)     NAME(C_TypOp->cPopisOper)  CPOS(37, 1) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(cStred)               FPOS(20, 2) FLEN( 15) FCAPTION(V˝robnÌ st¯edisko)  CPOS( 1, 2)
      TYPE(Text)     NAME(C_Stred->cNazStr)     CPOS(37, 2) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(cOznPrac)             FPOS(20, 3) FLEN( 15) FCAPTION(PracoviötÏ)         CPOS( 1, 3)
      TYPE(Text)     NAME(C_Pracov->cNazevPrac) CPOS(37, 3) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(cPracZar)             FPOS(20, 4) FLEN( 15) FCAPTION(PracovnÌ zaûazenÌ)  CPOS( 1, 4)
      TYPE(Text)     NAME(C_PracZa->cNazPracZa) CPOS(37, 4) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(nDruhMzdy)            FPOS(20, 5) FLEN( 15) FCAPTION(Druh mzdy)          CPOS( 1, 5)
      TYPE(Text)     NAME(DruhyMzd->cNazevDmz)  CPOS(37, 5) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(cTarifStup)           FPOS(20, 6) FLEN( 15) FCAPTION(TarifnÌ stupnice)  CPOS( 1, 6)
      TYPE(Text)     NAME(C_TarStu->cNazTarStu) CPOS(37, 6) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(cTarifTrid)           FPOS(20, 7) FLEN( 15) FCAPTION(TarifnÌ t¯Ìda)     CPOS( 1, 7)
      TYPE(Text)     NAME(C_TarTri->cNazTarTri) CPOS(37, 7) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(nKusovCas)            FPOS(20, 8) FLEN( 15) FCAPTION(Kusov˝ Ëas)        CPOS( 1, 8)
      TYPE(GET)      NAME(nPriprCas)            FPOS(20, 9) FLEN( 15) FCAPTION(P¯Ìpravn˝ Ëas)     CPOS( 1, 9)
      TYPE(COMBOBOX) NAME(lVykazML)             FPOS(20,10) FLEN( 16) FCAPTION(Vykazovat mzd.lÌstky)    CPOS( 1,10)
      TYPE(GET)      NAME(nKoefSmCas)           FPOS(20,11) FLEN( 15) FCAPTION(Koef. smÏnovÈho Ëasu) CPOS( 1,11)
      TYPE(GET)      NAME(nKoefViSt)            FPOS(20,12) FLEN( 15) FCAPTION(Koef.vÌcestroj. obsluhy) CPOS( 1,12)
      TYPE(GET)      NAME(nKoefViOb)            FPOS(20,13) FLEN( 15) FCAPTION(Koef.vÌceobsl. stroje)      CPOS( 1,13)



*/