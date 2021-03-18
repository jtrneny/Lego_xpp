//////////////////////////////////////////////////////////////////////
//
//     xbp_util.prg
//
//  Copyright:
//     Alaska Software, (c) 1997-2009. All rights reserved.         
//
//  Contents :
//
//     Additional helper stuff for browsers
//
//////////////////////////////////////////////////////////////////////

 #include "appevent.ch"
 #include "xbp.ch"
 #include "gra.ch"
 #include "common.ch"
 #include "dll.ch"

 #include "xbp_brw.ch"

 /* **********************************************************************
  * This mechanism implements a queue which is used to manage
  * the navigation requests of the browser. This queue will 
  * basically store the navigation requests in a LIFO order and
  * the browser stablization routine removes the navigation requests
  * in the order they have been added.
  * Later we might put some kind of optimization logic into the 
  * queue manager which basically does the following:
  *
  * a) when several operations overlap each other (2*up + 1*down == 1*up)
  *    we will normalize the redundand operations
  * b) when several operations assume that the user wants TO perform
  *    special operations on the queue then we might optimize this
  *    Example: 1*up + 1*up + 1*up + 1*up -> 1*PageUp
  *
  * The navigation codes are defined in xbp.ch (XBPBRW_Navigate_*)
  */
#ifdef RTL_DEBUG
 #define _DBG  
#else
 #define _DBG  NODEBUG
#endif

 CLASS NavigationQueue

 PROTECTED:
    VAR aQueue   _DBG           /* the queue */
    VAR lCount   _DBG           /* the current queue size */

 EXPORTED:
    METHOD Init                 /* initialization */
    SYNC METHOD Add, Get, Peek  /* operations on the queue */
    SYNC METHOD Optimize        /* optimize the queue */

 ENDCLASS

 /* **********************************************************************
  * initialize the queue
  * */
 METHOD NavigationQueue:Init( lSize )

    DEFAULT lSize TO 50
    ::lCount := 0
    ::aQueue := Array( lSize )

 RETURN self

 /* **********************************************************************
  * Add a navigation operation to the queue, the queue will basically
  * store one record which consists of a operation and a parameter
  * */
 METHOD NavigationQueue:Add( nOperation, nParam )

    LOCAL lSuccess := TRUE

    ::lCount++
    IF ::lCount > Len( ::aQueue )
       ASize( ::aQueue, Len( ::aQueue ) + 10 )
    ENDIF
    AIns( ::aQueue, 1, { nOperation, nParam } )

 RETURN lSuccess

 /* **********************************************************************
  * Remove the next record from the queue, the record will be returned
  * in form of a array with two elements.
  * */
 METHOD NavigationQueue:Get()

    LOCAL aRet

    /* return the value and remove the first element from the queue */
    IF ::lCount > 0
       aRet := AClone( ::aQueue[1] )
       ADel( ::aQueue, 1 )
       ::lCount--
    ENDIF

 RETURN aRet

 /* **********************************************************************
  * Check if a record exists in the queue without returning it.
  * */
 METHOD NavigationQueue:Peek( nOperation )
    
    LOCAL aRet, nPos := 0

    /* find the operation in the queue */
    IF Empty( nOperation )
       nPos := ::lCount
    ELSE
       nPos := AScan( ::aQueue, { | aValue | aValue[1] == nOperation } )
    ENDIF

    /* now return the value without removing it form the queue */
    IF nPos > 0
       aRet := AClone( ::aQueue[nPos] )
    ENDIF

 RETURN aRet

 /* **********************************************************************
  * Perform a optimization on the queue
  * */
 METHOD NavigationQueue:Optimize()
    // Not yet implemented. 
    // 
    // Later we might walk over the queue and combine several up operations
    // to page up and several page ups to gobottom, etc.
    //
 RETURN self


 /* **********************************************************************
  * Create/Recalculate a reference string out of two given strings
  * */
 FUNCTION _qbGetReferenceString( aReference, aNewReference )
    LOCAL i, imax, nLen

    IF Empty( aReference )
       aReference := Array( Len( aNewReference ) )
       AFill( aReference, " " )
    ENDIF
    imax := Min( Len( aReference ), Len( aNewReference ) )

    FOR i := 1 TO imax
       nLen := Len( _qbToString( aNewReference[i] ) )
       IF nLen > Len( _qbToString( aReference[i] ) )
          aReference[i] := Replicate( "O", nLen )
       ENDIF
    NEXT

 RETURN aReference
 
 /* **********************************************************************
  * Convert value TO string and RETURN that
  * */
 FUNCTION _qbToString ( xVal )

    LOCAL cType := VALTYPE ( xVal ), cRet

    DO CASE
    CASE cType == "N"
       cRet := STR ( xVal )
    CASE cType == "D"
       cRet := DTOC ( xVal )
    CASE cType == "L"
       cRet := IIF ( xVal, ".T.", ".F." )
    CASE cType == "M"
       cRet := "Memo"
    CASE cType == "C"
       cRet := xVal
    CASE cType == "A"
       cRet := "{ "
       AEval( xVal, { | x | cRet += _qbToString( x ) } )
       cRet += " }"
    OTHERWISE
       cRet := " "
    ENDCASE

 RETURN cRet


 /* **********************************************************************
  * Determine string size for a given XBP or its parents
  * 
  * This function will pass the XBPs and its parent hierarchy unless
  * a XBP was found in CREATE state. The PS of this object is then
  * to be used in order to determine the string size.
  *
  * RETURN: aSize : { width, height }
  * 
  * When no XBP was found this function will return { -1, -1 }
  * */
 FUNCTION xbpQueryStringSize ( oXbp, cStr )

   LOCAL oPS, _oXbp, aPoints, aRet

   // find XBP in CREATE state
   IIF ( oXbp == NIL, _oXbp := SetAppWindow(), _oXbp := oXbp )
   WHILE ! _oXbp:Status() == XBP_STAT_CREATE
      _oXbp := _oXbp:SetParent()
   ENDDO

   // Determine text size when the XBP is a window
   IF _oXbp:IsDerivedFrom( XbpWindow() )

      // use the GRA to get the text rectangle
      oPS     := _oXbp:LockPS()
      aPoints := GraQueryTextBox( oPS, cStr )
      _oXbp:UnlockPS()

      // provide return value
      aRet := { aPoints[3,1] - aPoints[1,1], aPoints[3,2] - aPoints[2,2] }
   ELSE

      // default return
      aRet := { -1, -1 }
   ENDIF

 RETURN aRet


 /* **********************************************************************
  * Get Bundle Values from given Presentation Parameter array
  * - get only values which are != NIL
  * 
  * Precondition: both bundles must have been correctly initialized,
  *               that means that  Len( aBundle ) - nPPBase >= Len( aPPBundle) 
  *
  * The original values are returned when they where != NIL, if no
  * values where set, an empty array is returned.
  * */
 FUNCTION xbpAssignPPBundle ( aBundle, aPPBundle, nPPBase )

   LOCAL i, imax := Len( aPPBundle ), nBundleIndex, nMaxIndex := Len( aBundle ) + 1
   LOCAL aRet := Array( 0 )

   FOR i := 1 TO imax
      IF ( aPPBundle[i,2] <> NIL )                        .AND. ;
         ( nBundleIndex := aPPBundle[i,1] - nPPBase ) > 0 .AND. ;
         nBundleIndex < nMaxIndex

         // return original value
         AAdd( aRet, { aPPBundle[i,1], aBundle[nBundleIndex] } )

         // now set value
         aBundle[nBundleIndex] := aPPBundle[i,2]
      ENDIF
   NEXT

 RETURN aRet


 /* **********************************************************************
  * Get presparam bundle from bundle
  * - get only values which are != NIL
  * */
 FUNCTION xbpGetPPBundle ( aPPBundle, nPPBase )

   LOCAL aRet := Array( 0 ), i

   FOR i := 1 TO Len( aPPBundle )
      IF aPPBundle[i] <> NIL
         Aadd( aRet, { i + nPPBase, aPPBundle[i] } )
      ENDIF
   NEXT

 RETURN aRet


 /* **********************************************************************
  * Inherit bundle values from another bundle
  * - inherit only values which are != NIL
  * */
 FUNCTION xbpInheritBundle ( aBundle, aSourceBundle )

   LOCAL i

   FOR i := 1 TO Len( aSourceBundle )
      IF aBundle[i] == NIL .AND. aSourceBundle[i] <> NIL
         aBundle[i] := aSourceBundle[i]
      ENDIF
   NEXT

 RETURN 0


 /* **********************************************************************
  * Wrap the system metrics function
  * */
 FUNCTION xbpGetSystemMetrics( nValue )
 RETURN DllCall( "USER32.DLL", DLL_STDCALL, "GetSystemMetrics", nValue ) 

 // EOF
