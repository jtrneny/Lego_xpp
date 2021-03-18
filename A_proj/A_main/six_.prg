////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  six_.PRG                                                                  //
//                                                                            //
//  Copyright:                                                                //
//                                                                            //
//                                                                            //
//  Contents:                                                                 //
//  Implementation of sixRDD for ALASKA                                       //
//                                                                            //
//  Remarks:                                                                  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"

FUNCTION sx_RLock(xRECs)
  LOCAL  nIn
  LOCAL  lOk    := .T.
  LOCAL  aLOCKs := {}

  IF     IsNIL(xRECs)    ;  RETURN DbRLock()
  ELSEIF ISNuMBER(xRECs) ;  RETURN DbRLock(xRECs)
  ELSEIF IsARRAY(xRECs)  ;  FOR nIn := 1 TO LEN(xRECs)
                              AAdd(aLOCKs, DbRLock(xRECs[nIn]))
                            NEXT
                              aEval( aLOCKs, { |X| If( X, NIL, lOk := .F.) } )
                            RETURN lOk
  ENDIF
RETURN .F.


FUNCTION sx_SeekLast(xValue)
  LOCAL  cIndexKey := IndexKey()
  LOCAL  lDone

  DbSeek(xValue,.T.)
  DBSkip(-1)
  lDone := (xValue = LEFT(&(cIndexKey),LEN(xValue)))
RETURN(lDOne)


/*
function sx_SeekLast(xValue)
  dbSetScope(SCOPE_BOTH, xValue)
  dbGoBotttom()
return nil



FUNCTION sx_SeekLast( cString )
  LOCAL cIndexKey, cIndexVal, nLen

  cIndexKey  := IndexKey(0)
  IF Empty( cIndexKey )                                       // no index active
    RETURN .F.                                                // *** RETURN  ***
  ENDIF

  nLen    := Len( cString )                                  // increase last Chr()
  DbSeek( Left(cString,nLen-1) + ;                           // by 1 for SOFTSEEK
          Chr(Asc(Right(cString,1)) + 1 ), ;
         .T.)                                                // SOFTSEEK ON
  DbSkip(-1)                                                 // skip back 1
                                                             // determine value of index key
  IF ( cString == Left(&(cIndexKey),nLen) )
    RETURN .T.                                               // match found!
  ENDIF

  DbSkip(1)                                                  // if Eof() was .T.
RETURN .F.
*/


FUNCTION sx_IsLocked()
  LOCAL  nCURRrec  := RECNO()
  LOCAL  lIsLocked := .F.
  LOCAL  aLOCKED   := DbRLockList()

  lIsLocked := (AScan(aLOCKED,nCURRrec) <> 0)
RETURN(lIsLocked)


FUNCTION sx_KeyData(nIndex)
**  LOCAL  cIndexKey := If( IsNil(nIndex), IndexKey(), IndexKey(nIndex))

  LOCAL  cIndexKey := If( IsNil(nIndex), OrdKey(), Ordkey(nIndex))
RETURN(&(cIndexKey))


function sx_KeyCount()
  local nRet := 0, nTmp,nRec := Recno()

  DbGoTop()
  nTmp := OrdKeyNo()
  DbGoBottom()
  nRet := ( OrdKeyNo() - nTmp ) + 1

  if nret == 1 .and. eof()
    nret := 0
  else
    dbGoto( nRec )
  endif

return nRet