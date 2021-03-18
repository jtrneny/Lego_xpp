////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  UCT_main_KEY.PRG                                                          //
//                                                                            //
//  Copyright:                                                                //
//                                                                            //
//  Contents:                                                                 //
//  Implementation of MAIN_key  -> UCT_main_KEY for UCTO                      //
//                                                                            //
//  Remarks:                                                                  //
//  MAIN_INF     ->  UCT_main_INF                                             //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "..\UCTO\UCT_ucto.ch"


*
************* ZOBECNÌNÍ FUNKCE PRO INFOSCR *************************************
Function UCT_main_INF( cFILE, cINFILE)
  Local  cC, cKEYp, cISOp := ''                                                         //indikace prùbìžné uzávìrky
  Local  pSA, aDEF_INS := _UCT_main

  nPosIN := aScan( aDEF_INS, { |X| X[ 1] == cFILE } )
  pSA    := aClone( aDEF_INS[ nPosIN, 2])

  // dodateèný test pro CTRL_W //
  If cINFILE == 'HP'
    aEVAL( pSA, { |X,N| pSA[ N] := StrTRAN( X, 'HD', 'HP' ) } )
  EndIf

  aEval( pSA, { |X,M| pSA[ M] := DBGetVal( X) }, 1, 7 )

  If pSA.pKEY <> 0
    // test na prùbìžnou uzávìrku //

    Do Case
    Case cFILE == 'UCTDOKHD'
      cC := If( Empty( pSA.pTISK), ' ', 'T' )
      cC += ' '
      cC += If( pSA.pCEL == pSA.pLIK, 'L', If( pSA.pLIK == 0, ' ', 'l'  ) )
      cKEYu := UPPER('U') +SUBSTR( pSA.pUUZ, 2)
      UCETSYS ->( mh_SEEK( cKEYu, 2, .T.,, .F.))
      cC += If( UCETSYS ->lZavren, 'U', cISOp )
      If cINFILE == 'HP'
        cC += If( UCTDOKHP ->nPODR_uct == 1, ' ¤', '  ' )
      Else
        cC += If( UCTDOKHD ->nPODR_uct == 1, ' ¤', '  ' )
      EndIf

    Case cFILE == 'UCETPOLA'
      cC := ' '
      UCETSYS ->( mh_SEEK( pSA.pUUZ, 2, .T.,, .F.))
      cC += If( UCETSYS ->lZAVREN, 'U', ' ')
      cC += If( UCETSYS ->nAKTUc_Ks == 1, CHR(1), If( UCETSYs ->nAKTUc_Ks == 2, '‹', ' '))

    Case cFILE == 'UCETKUM'
      cC := If( UCETERR ->( dbSEEK( pSA.pDUZ)), '¤', ' ')
      UCETSYs ->( mh_SEEK( pSA.pUUZ, 2, .T.,, .F.))
      cC += If( UCETSYs ->lZAVREN, 'U', ' ')
      cC += If( UCETSYs ->nAKTUc_Ks == 1, CHR(1), If( UCETSYs ->nAKTUc_Ks == 2, '‹', ' '))
    EndCase
  Else
    cC := pSA.pDEF
  EndIf
Return( cC)