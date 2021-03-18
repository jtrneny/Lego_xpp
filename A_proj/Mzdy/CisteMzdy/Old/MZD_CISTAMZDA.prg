#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

// ----------------- Test zda probìhl v daném období výpoèet ÈM ----------------

FUNCTION TESTcmObd()
  LOCAL xKEY
  LOCAL nROK, nOBD
  LOCAL lOK
  LOCAL nOLDtag := MSPRC_MO ->( AdsSetOrder( 1))

  nROK := IF( uctOBDOBI:MZD:nOBDOBI = 12, uctOBDOBI:MZD:nROK +1, uctOBDOBI:MZD:nROK())
  nOBD := IF( uctOBDOBI:MZD:nOBDOBI = 12,                     1, uctOBDOBI:MZD:nOBDOBI +1)
  xKEY := StrZero( nROK, 4) +StrZero( nOBD, 2)
  lOK  := MSPRC_MO->( dbSeek( xKEY))
  MSPRC_MO->( AdsSetOrder( nOLDtag))

RETURN( lOK)


// ----------------- Informace o výpoètu ÈM ------------------------------------
FUNCTION INFzprac()
  LOCAL aRET
  LOCAL nOBD      // ve tvaru RRRRMM

  nOBD := Val( StrZero( uctOBDOBI:MZD:nROK, 4) +Str( uctOBDOBI:MZD:nOBDOBI, 2))

  DO CASE
  CASE MSPRC_MO->nTMoZPRhmz == nOBD .AND. MSPRC_MO->nTMoZPRcmz == nOBD
    aRET := "  "
  CASE MSPRC_MO->nTMoZPRhmz == nOBD .AND. MSPRC_MO->nTMoZPRcmz <> nOBD
    aRET := " ¤"
  CASE MSPRC_MO->nTMoZPRhmz <> nOBD .AND. MSPRC_MO->nTMoZPRcmz == nOBD
    aRET := "¤ "
  OTHERWISE
    aRET := "¤¤"
  ENDCASE

RETURN( aRET)
