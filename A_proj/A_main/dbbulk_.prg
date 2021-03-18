#include "ads.ch"
#include "common.ch"
#include "dll.ch"
#include "dmlb.ch"
#include "Deldbe.ch"
#include "Sdfdbe.ch"
#include "DbStruct.ch"
#include "error.ch"

#include "adsdbe.ch"
#include "..\A_main\ace.ch"



//////////////////////////////////////////////////////////////////////////////
//
// Function _DbExport()
//    Export records from a work area to a database file
//
// Notes    :
//    The function is used by the command COPY TO. It automatically
//    loads a required DBE. If the DBE was not loaded when _DbExport()
//    was called the DBE is released when _DbExport() has finished.
//
///////////////////////////////////////////////////////////////////////////////
FUNCTION _DbExport( cFile, ;            // Name for target file
                    aFieldNames, ;      // Array containing field names
                    bFor, ;             // Code block for FOR condition
                    bWhile, ;           // Code block for WHILE condition
                    nNext, ;            // Number of records
                    nRecord, ;          // Only current record
                    lRest, ;            // All records until Eof()
                    cDbe, ;             // DBE for new database file
                    cDelimiter )        // Delimiter for DELDBE
   LOCAL aDbeInfo, i, cOldDbe, cDataComponent
   LOCAL cFieldToken

   IF Valtype( cDbe ) <> "C"
      cDbe := DbeSetDefault()
   ENDIF

   /*
    * Is DBE loaded ?
    */
   cDbe     := Upper( cDbe )
   aDbeInfo := DbeList()
   i        := AScan( aDbeInfo , {|a| cDbe $ a[1] .AND. .NOT. a[2]} )

   IF i == 0
      DbeLoad( cDbe, .F.)
   ELSE
      cDbe := Upper( aDbeInfo[i,1] )
   ENDIF

   cOldDbe        := DbeSetDefault( cDbe )
   cDataComponent := DbeInfo( COMPONENT_DATA, DBE_NAME )

   DO CASE
   /*
    * Default values for DbeInfo()
    */
   CASE cDataComponent == "SDFDBE"
      aDbeInfo := {{ SDFDBE_AUTOCREATION, .T. }}
   CASE cDataComponent == "DELDBE"
      cFieldToken := ","
      IF Valtype( cDelimiter ) <> "C"
         cDelimiter := '"'
      ELSEIF "BLANK" $ Upper( cDelimiter )
         cFieldToken := " "
         cDelimiter  := Chr(0)
      ELSEIF Empty( cDelimiter )
         cDelimiter := '"'
      ENDIF

      aDbeInfo := { ;
        { DELDBE_FIELD_TOKEN    , cFieldToken      }, ;
        { DELDBE_DELIMITER_TOKEN, cDelimiter       }, ;
        { DELDBE_MODE           , DELDBE_AUTOFIELD }}

   OTHERWISE
      aDbeInfo := {}
   ENDCASE

   DbeSetDefault( cOldDbe )

   /*
    * Export data
    */
   DbExport( cFile, ;
             aFieldNames, ;
             bFor, ;
             bWhile, ;
             nNext, ;
             nRecord, ;
             lRest, ;
             cDbe, ;
             aDbeInfo )

RETURN NIL


//////////////////////////////////////////////////////////////////////////////
//
// Function DbExport()
//    Export records from a work area to a database file
//
// Notes    :
//    All necessary DBEs must be loaded
//    before this function is called.
//
///////////////////////////////////////////////////////////////////////////////
FUNCTION DbExport( cFile, ;            // Name for target file
                   aFieldNames, ;      // Array with field names
                   bFor, ;             // Code block for FOR condition
                   bWhile, ;           // Code block for WHILE condition
                   nNext, ;            // Number of records
                   nRecord, ;          // Only current record
                   lRest, ;            // All records until Eof() ?
                   cDbe, ;             // DBE for new database file
                   aDbeInfo )          // Settings for DBE
   LOCAL nTargetArea, nSourceArea, aSource, aTarget, nCount, aFieldPos
   LOCAL cOldDbe, i:=0 , cFieldTypes
   LOCAL cTargetTypes, lSupportDel
   /*
    * No field names are specified
    */
   IF Valtype( aFieldNames ) <> "A"
      aFieldNames := {}
   ENDIF

   /*
    * No DBE specified
    */
   IF Valtype( cDbe ) <> "C"
      cDbe := DbeSetDefault()
   ENDIF

   /*
    * No DBE info specified
    */
   IF Valtype( aDbeInfo ) <> "A"
      aDbeInfo := {}
   ENDIF

   /*
    * Structure array for source database
    */
   aSource      := DbStruct()
   nCount       := Len( aFieldNames )
   nSourceArea  := Select()

   /*
    * No field names specified, copy all fields
    */
   IF nCount == 0
      nCount    := Len( aSource )
      aTarget   := aSource
      aFieldPos := Array( nCount )
      DO WHILE ++i <= nCount
         aFieldPos[i] := i
      ENDDO
   ELSE
      /*
       * Array for target database
       */
      aTarget   := Array( nCount )
      /*
       *  Array for field positions
       */
      aFieldPos := Array( nCount )
      DO WHILE ++i <= nCount
         aFieldPos[i] := FieldPos( aFieldNames[i] )
         aTarget[i]   := aSource[ aFieldPos[i] ]
      ENDDO
   ENDIF

   /*
    * Set DBE settings
    */
   cDbe        := Upper( cDbe )
   cOldDbe     := DbeSetDefault( cDbe )
   AEval( aDbeInfo, {|a| a[2] := DbeInfo( COMPONENT_DATA, a[1], a[2] ) } )
   cFieldTypes := DbeInfo( COMPONENT_DATA, DBE_DATATYPES )

   /*
    * Delete memo fields for SDF and DEL engine (more precisely:
    * delete fields with unsupported data types)
    */
   i:=0
   DO WHILE ++i <= nCount
      IF ! aTarget[i,2] $ cFieldTypes
         ADel( aTarget, i )
         ADel( aFieldPos, i )
         i--
         nCount--
      ENDIF
   ENDDO

   IF ATail( aTarget ) == NIL
      ASize( aTarget  , nCount )
      ASize( aFieldPos, nCount )
   ENDIF

   /*
    *  determine field types of target
    */

   IF DbeInfo( COMPONENT_DATA, DBE_NAME ) == "DELDBE"
     cTargetTypes := ""
     FOR i := 1 TO Len(aTarget)
       cTargetTypes += aTarget[i, DBS_TYPE]
     NEXT

     DbeInfo(COMPONENT_DATA, DELDBE_FIELD_TYPES, cTargetTypes)
   ENDIF


   /*
    *  determine if target supports delete
    */
   IF DbeInfo( COMPONENT_DATA, DBE_NAME ) == "SDFDBE"
     lSupportDel = .F.
   ELSE
     lSupportDel = .T.
   ENDIF


   /*
    * Create target database file and open it exclusively
    */
   if cDbe = 'ADSDBE'
     dbCreate( cFile, aTarget, oSession_free)
     dbUsearea( .t., oSession_free, cFile,, .f.)
   else
     DbCreate( cFile, aTarget, cDbe )
     USE (cFile) NEW EXCLUSIVE
   endif

   nTargetArea := Select()

   /*
    * Export records
    */
   SELECT (nSourceArea)

   DbEval( {|| DbExportRecord( aFieldPos  , ;
                               aTarget    , ;
                               nCount     , ;
                               nSourceArea, ;
                               nTargetArea, ;
                               lSupportDel) }, ;
           bFor, bWhile, nNext, nRecord, lRest )

   SELECT (nTargetArea)

   /*
    * Clean up
    */
   DbCloseArea()
   SELECT ( nSourceArea )
   AEval( aDbeInfo, {|a| a[2] := DbeInfo( COMPONENT_DATA, a[1], a[2] ) } )
   DbeSetDefault( cOldDbe )

RETURN NIL

*****************************************************************************
* Copy current record to target database file
*****************************************************************************
STATIC PROCEDURE DbExportRecord( aFieldPos, aTarget, nCount, nSource, nTarget, lSupportDel)
   LOCAL i := 0, lDeleted := Deleted()


   /*
    * Read fields from work area
    */
   DO WHILE ++i <= nCount
      aTarget[i] := FieldGet( aFieldPos[i] )
   ENDDO

   SELECT (nTarget)
   /*
    * Write values to target file
    */
   DbAppend()

   i := 0
   DO WHILE ++i <= nCount
      FieldPut( i, aTarget[i] )
   ENDDO

   IF lDeleted .AND. lSupportDel
     DELETE
   ENDIF

   SELECT (nSource)
RETURN




///////////////////////////////////////////////////////////////////////////////
//
//  Function DbTotal()
//    Total records into a second database file
//
//  Notes    :
//    This function is used by the command TOTAL ON..TO
//
///////////////////////////////////////////////////////////////////////////////
function DbTotal( cFile      , ;       // Name for target file
                  bIndex     , ;       // Index expression
                  aFieldNames, ;       // Array containing field names
                  bFor       , ;       // Code block for FOR condition
                  bWhile     , ;       // Code block for WHILE condition
                  nNext      , ;       // Number of records
                  nRecord    , ;       // Only current record
                  lRest      , ;       // All records until Eof() ?
                  lcloseOut    )       // close out-file default .T.


   LOCAL nCount  , nFCount, nSourceArea , nTargetArea
   LOCAL xIndexVal := NIL, aFieldPos, aSum, i:=0
   *
   local  astru := dbstruct()

   default lcloseOut to .t.


   /*
    * No fields are specified
    */
   IF Valtype( aFieldNames ) <> "A"
      /*
       * This variable must be an array
       */
      aFieldNames := {}
   ENDIF
   /*
    * An index expression is necessary
    */
   IF Valtype( bIndex ) <> "B"
      bIndex  := {|| Recno() }
   ENDIF
   /*
    * Number of fields to total (sum)
    */
   nCount      := Len( aFieldNames )
   /*
    * total number of fields in work area
    */
   nFCount     := FCount()
   aFieldPos   := Array( nCount )
   aSum        := Array( nCount )
   nSourceArea := Select()
   AFill( aSum, 0 )
   /*
    * Get field positions
    */
   DO WHILE ++i <= nCount
      aFieldPos[i] := FieldPos( aFieldNames[i] )
   ENDDO
   /*
    * Create target file and open it
    */
   dbCreate( cFile, astru, oSession_free)
   dbUsearea( .t., oSession_free, cFile,, .f.)
   nTargetArea := Select()
   /*
    * Sum values
    */
   SELECT (nSourceArea)
   DbEval( {|| DbSum( @xIndexVal, ;
                      bIndex, ;
                      nTargetArea, ;
                      nCount, ;
                      nFCount, ;
                      aFieldPos, ;
                      aSum ) }, ;
            bFor, bWhile, nNext, nRecord, lRest )

   SELECT (nTargetArea)
   i := 0
   /*
    * Write last sum to target file
    */
   DO WHILE ++i <= nCount
      FieldPut( aFieldPos[i], aSum[i] )
   ENDDO
   /*
    * Clean up
    */
   if lcloseOut
     DbCloseArea()
   endif
   SELECT (nSourceArea)

RETURN NIL


*****************************************************************************
* Sum values to an array and write the result to a database
*****************************************************************************
STATIC PROCEDURE DbSum( xIndexVal, ;
                        bIndex, ;
                        nTarget, ;
                        nCount, ;
                        nFCount, ;
                        aFieldPos, ;
                        aSum )
   LOCAL i := 0, xValue := Eval(bIndex)

   /*
    * Index has changed
    */
   IF xIndexVal <> xValue
      /*
       * It is not the first record
       */
      IF xIndexVal <> NIL
         /*
          * Write sum to target file
          */
         DO WHILE ++i <= nCount
            ( nTarget )->( FieldPut( aFieldPos[i], aSum[i] ) )
         ENDDO
      ENDIF
      /*
       * Save current index value
       */
      xIndexVal := xValue
      i         := 0
      /*
       * Transfer record to target file
       */
      ( nTarget )->( DbAppend() )
      DO WHILE ++i <= nFCount
         IF "M" <> TYPE( FieldName(i) )
            xValue := FieldGet( i )
            ( nTarget )->( FieldPut( i, xValue ) )
         ENDIF
      ENDDO

      i := 0
      /*
       * Read initial value for the total
       */
      DO WHILE ++i <= nCount
         aSum[i] := FieldGet( aFieldPos[i] )
      ENDDO

   ELSE
   /*
    * Add values
    */
      DO WHILE ++i <= nCount
         aSum[i] += FieldGet( aFieldPos[i] )
      ENDDO
   ENDIF
RETURN