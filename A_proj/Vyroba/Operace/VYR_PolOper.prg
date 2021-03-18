/*******************************************************************************
  VYR_POLOPER.PRG
  ------------------------------------------------------------------------------
  XPP              ->  DOS          in   DOS.Prg
  SetCisOper()         SetCisOper()      VstPOOP.Prg
  VYR_POLOPER_del()    DelPolOper()      KUSOV.Prg
*******************************************************************************/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

*
*===============================================================================
FUNCTION VYR_POLOPER_edit( oDlg)
  LOCAL cKey, lOK, nREC
  LOCAL cFile := IF( oDlg:parentForm = 'Vyr_PolOper_Scr' , 'VyrPOL'  ,;
                 IF( oDlg:parentForm = 'Vyr_VyrZakIT_Scr', 'VyrZakIT',  'KusTree' ))
  LOCAL nOperML := SysCONFIG( 'Vyroba:nOperML')
*  LOCAL cFile := 'VyrPOL'

  IF oDlg:lCopyREC
    SetCopyREC()
    POLOPERw->nCisOper  := SetCisOper()
    POLOPERw->nVarOper  := IF( nOperML = OPERML_MOPAS, 1, POLOPERw->nVarOper)
  ELSEIF oDlg:lNewREC
    POLOPERw->(dbAppend())
    POLOPERw->cCisZakaz  := (cFILE)->cCisZakaz
    POLOPERw->cVyrPol    := (cFILE)->cVyrPol
    POLOPERw->nCisOper   := SetCisOper()
    POLOPERw->nUkonOper  := IF( nOperML = OPERML_MOPAS, 1, 0)
    POLOPERw->nVarOper   := (cFILE)->nVarCis
    POLOPERw->nKoefKusCa := 1
    * varianta frm 1 (Hydrap)
    POLOPERw->nKoefMnoSt := 1
  ELSE
    mh_COPYFLD('POLOPER', 'POLOPERw', .T.)
  ENDIF

  POLOPERw->nPriprCas  := MjCAS( POLOPERw->nPriprCas , to_CFG )
  POLOPERw->nKusovCas  := MjCAS( POLOPERw->nKusovCas , to_CFG )
  POLOPERw->nCelkKusCa := MjCAS( POLOPERw->nCelkKusCa, to_CFG )
/*
     axE[ STRED  , 4] := Operace->cStred
     axE[ OznPRAC, 4] := Operace->cOznPrac
     axE[ PracZAR, 4] := Operace->cPracZar
*/
RETURN NIL

*
*===============================================================================
FUNCTION VYR_POLOPER_save( oDlg)

  IF ! oDlg:drgDialog:dialogCtrl:isReadOnly
    oDlg:dataManager:save()
    IF( oDlg:lNewREC, POLOPER->( DbAppend()), Nil )
    IF POLOPER->(sx_RLock())
       mh_COPYFLD('POLOPERw', 'POLOPER' )
       *  varianta frm = 1 ( HYDRAP)
       if oDlg:nVarFrmPolOPER = 1
         PolOper->nKusovCas  := (( 28800 / PolOper->nNormaKsSt) / PolOper->nKoefMnoSt )
         PolOper->nCelkKusCa := ( PolOper->nKusovCas * PolOper->nKoefKusCa )
       ENDIF
       *
       PolOper->nPriprCas  := MjCAS( PolOper->nPriprCas , to_MIN )
       PolOper->nKusovCas  := MjCAS( PolOper->nKusovCas , to_MIN )
       PolOper->nCelkKusCa := MjCAS( PolOper->nCelkKusCa, to_MIN )
       *
       * Poøízení PolOper na mzdových lístcích
       IF( oDlg:parentForm = 'Vyr_MListHD_Crd' )
         PolOper->nRokVytvor := ListHD->nRokVytvor
         PolOper->nPorCisLis := ListHD->nPorCisLis
       ELSE
         VYR_POLOPER_fill( PolOper->cCisZakaz)
       ENDIF
       /* VYR_POLOPER_fill
       IF  VyrZak->nPolZAK = 1    // nepoložková
         PolOper->cCisZakazI := PolOper->cCisZakaz
       ELSEIF VyrZak->nPolZAK = 2   //  položková
         PolOper->cCisZakazI := ALLTRIM(PolOper->cCisZakaz)+ '/' + ;
                                IF( VyrZAK->nMnozPlano = 1, '0', + ALLTRIM( STR( PolOper->nVarOper)))
       ENDIF
       PolOper->cVyrobCisl := PolOper->cCisZakazI
       */
       POLOPER->( dbUnlock())
    ENDIF
  ENDIF

RETURN NIL

*
*===============================================================================
FUNCTION VYR_POLOPER_fill( cZakaz,file)

  default file to 'PolOper'

  drgDBMS:open('VYRZAK',,,,,'VYRZAKi')
  IF ! IsNil( cZakaz)
    VYRZAKi->( dbSEEK( Upper( cZakaz),, 'VYRZAK1'))
  ENDIF

  if vyrZakI->npolZak = 2   // položková zakázka
    (file)->ccisZakazI := ALLTRIM((file)->cCisZakaz)+ '/' + ALLTRIM( STR( (file)->nVarOper))
  else                      // ne-položková zakázka
    (file)->cCisZakazI := (file)->cCisZakaz
  endif

  (file)->cVyrobCisl := (file)->cCisZakazI
RETURN NIL


* Zrušení operace k vyrábìné položce
*===============================================================================
FUNCTION VYR_POLOPER_del( oDlg)
  Local cKey, cMsg, lDel := .F., IsYES, lMaj, aRECs := {}
  Local lOK := .T. // EditOPER( K_DEL)

  IF lOK
    cMsg  := '< Zrušení operace >;; Zrušit operaci k vyrábìné položce ?'
    IF ( isYES := drgIsYESNO(drgNLS:msg( cMsg) ) )
      cKEY := Upper( PolOper->cVyrPol) + StrZero( PolOper->nCisOper, 4) + ;
              StrZero( PolOper->nUkonOper, 2) + StrZero( PolOper->nVarOper, 3)

      drgDBMS:open('MajOPER'  )
      FOrdREC( { 'MajOper, 2'} )
      MajOPER->( mh_SetScope( cKey),;
                 dbEVAL( {|| AADD( aRECs, MajOPER->( RecNO()) )}),;
                 mh_ClrScope() )
      FOrdREC()
      lMaj := IF( LEN( aRECs) = 0, .T.,  MajOPER->( sx_RLock( aRECs)))
      IF PolOPER->( sx_RLock()) .and. lMaj
         FOR n := 1 TO LEN( aRECs)
           MajOPER->( dbGoTO( aRECs[ n]), dbDelete() )
         NEXT
         MajOPER->( dbUnlock())
         PolOPER->( dbDelete(), dbUnlock())
         lDel := .T.
      ENDIF
    ENDIF
  ENDIF
RETURN lDEL

* Nastavení èísla operace pøi zadávání nové operace k vyr. položce
*===============================================================================
STATIC FUNCTION SetCisOper()
  Local nCisOper := 0, nRec := PolOper->( RecNo())
**  Local cTag := PolOPER->( AdsSetOrder( 1))
  Local lSetCisOp := SysCONFIG( 'Vyroba:lSetCisOp')
  Local nOperML   := SysCONFIG( 'Vyroba:nOperML')

  IF lSetCisOp
    PolOPER->( dbGoBottom() )
    nCisOper := PolOper->nCisOper + IF( nOperML = OPERML_MOPAS, 1, 10 )
  ENDIF
**  PolOper->( AdsSetOrder( cTAG), dbGoTO( nRec) )
  PolOper->( dbGoTO( nRec) )

RETURN( nCisOper)

*
*===============================================================================
STATIC FUNCTION SetCopyREC()
  LOCAL nPos, aFld
  LOCAL cFld := 'cCisZakaz,cVyrPOL,nUkonOper,nVarOper,cOznOper,cOznPracN,' + ;
                'nPozice,nPriprCas,nKusovCas,nKoefKusCa,nCelkKusCa,nKcNaOper,'  + ;
                'cText1,cText2,cText3,mPolOPER'

  aFld :=  ListAsArray( cFld)
  PolOPERw->( DbAppend())
  aEVAL( aFld, { |X,i| ;
                ( nPos := PolOPER->( FieldPos( X))             , ;
                If( nPos <> 0, PolOPERw->( FieldPut( nPos, PolOPER->( FieldGet( nPos)) )), Nil ) ) } )
RETURN NIL