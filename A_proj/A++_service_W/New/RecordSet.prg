#include "class.ch"



/*
 * Class for accessing 2-dim arrays
 */
CLASS RecordSet
   PROTECTED:
   CLASS VAR columnNames                   // Names of the array columns

   VAR bof                                 // Logical flag for BoF
   VAR eof                                 // Logical flag for EoF
   VAR index                               // Array holding sort order
   VAR alias                               // Array form DBF-file

   INLINE METHOD resetFlags
      ::bof     := .F.
      ::eof     := .F.
   RETURN self

   EXPORTED:
   CLASS METHOD createClass

   METHOD skipper
   METHOD sort
   METHOD seek

   VAR records    READONLY                 // The 2-dim data array
   VAR recsNo     READONLY                 // pole recno pøi kopírování addDBRec
   VAR recno      READONLY                 // Pointer to current row
   VAR lastrec    READONLY                 // Total number of rows


   INLINE CLASS METHOD initClass( aColumnNames )
      IF Valtype( aColumnNames ) == "A"
         ::columnNames := AClone( aColumnNames )
      ENDIF
   RETURN self


   INLINE METHOD init(aRecords,alias)
      ::resetFlags()

      ::alias := alias

      IF IsNULL(aRecords)
        ::records    := {}
        ::recsNo     := {}
        ::recno      := 1
        ::lastrec    := 1
        ::index      := {}
      ELSE
        ::records    := aRecords
        ::recno      := 1
        ::lastrec    := Len( aRecords )
        ::index      := Array( ::lastrec )
      ENDIF

      // Initial sort order is the natural/original order
      AEval( ::index, {|n,i| n:=i },,, .T. )
   RETURN self


   INLINE METHOD getVar( nColumn )
      IF ::lastrec == 0
         RETURN NIL
      ENDIF
   RETURN ::records[ ::index[ ::recno ], nColumn ]


   INLINE METHOD addRec(aRecord)
     AAdd(::records, aRecord)
     ::lastrec += 1
     AAdd(::index, LEN(::index) +1)
   RETURN self


   INLINE METHOD addDBRec(subAlias)              // pro kopii dat z DBF - ARR //
     LOCAL  alias
     LOCAL  aRecord := {}, aFrom := ::columnNames  //(::alias) ->(DbStruct())

     alias := IsNull(subAlias, ::alias)

     AEval(aFrom, {|X,M| AAdd( aRecord, (alias) ->( FieldGet(M))) })
     AAdd(::records, aRecord)
     AAdd(::recsNo , (alias) ->(RecNo()))

     ::lastRec += 1
     AAdd(::index, LEN(::index) +1)
   RETURN self


   INLINE METHOD replDBRec(subAlias,recs,doAppend)
     LOCAL  pa := ::records[recs]

     IF( IsNull(doAppend,.F.), (subAlias) ->(DbAppend()), NIL )

     AEval( pa, { |x,m| (subAlias) ->( FieldPut(m,x)) } )
   RETURN self


   INLINE METHOD putVar( nColumn, xValue )
      IF ::lastrec == 0
         RETURN NIL
      ENDIF
   RETURN ::records[ ::index[ ::recno ], nColumn ] := xValue

   INLINE METHOD resetAll()
     ::records := {}
     ::recsNo  := {}
     ::recno   := 1
     ::lastrec := 1
     ::index   := {}
   RETURN self

   INLINE METHOD bof
   RETURN ::bof


   INLINE METHOD eof
   RETURN ::eof


   // Navigate the row pointer for the array.
   // NOTE: There is no "ghost record" as for database files
   INLINE METHOD skip( n )
      IF n == NIL
         n := 1
      ENDIF

      ::recno += n
      ::resetFlags()

      IF ::recno < 1
         ::bof   := .T.
         ::recno := 1
      ENDIF

      IF ::recno > ::lastrec
         ::eof   := .T.
         ::recno := ::lastrec
      ENDIF
   RETURN self


   INLINE METHOD goTo( nRecno )
      ::skip( nRecno - ::recno )
   RETURN self


   INLINE METHOD goTop
      ::resetFlags()
      ::recno := 1
   RETURN self


   INLINE METHOD goBottom
      ::resetFlags()
      ::recno := ::lastRec
   RETURN self
ENDCLASS


/*
 * Create a new class for accessing a 2-dim array of known columns
 */
CLASS METHOD RecordSet:createClass( cClassname, aColumnNames )
   LOCAL oClass := ClassObject( cClassName )
   LOCAL i, imax:= Len( aColumnNames )
   LOCAL aMethod, cBlock, cName, nType

   IF oClass <> NIL
      // Class object exists already
      RETURN oClass
   ENDIF

   // Instance variables are in fact EXPORTED ACCESS/ASSIGN methods
   nType := CLASS_EXPORTED + METHOD_INSTANCE + ;
            METHOD_ACCESS  + METHOD_ASSIGN

   // Class does not exist yet
   aMethod:= Array( imax )

   FOR i:=1 TO imax
      // Name of iVar
      cName  := aColumnNames[i]

      // Each iVar is mapped to the generic :getVar()/:putVar() methods.
      // Both receive the numeric column index i
      cBlock := "{|o,x| IIf(x==NIL,"                        + ;
                         "o:getVar(" + Var2Char(i) + "),"   + ;
                         "o:putVar(" + Var2Char(i) + ",x))}"
      aMethod[i] := { cName, nType, &(cBlock), cName }
   NEXT

   // Create the new class object and use RecordSet as super class (=self).
   // This way, the derived new class knows the :getVar()/:putVar()
   // and navigational methods
   oClass := ClassCreate( cClassName, { self }, {}, aMethod )

   // Initialize the new class object
   oClass:initClass( aColumnNames )
RETURN oClass


/*
 * Method to be used by a browser for navigating
 * the row pointer of a 2-dim array
 */
METHOD RecordSet:skipper( nWantSkip )
   LOCAL nDidSkip := 0

   DO CASE
   CASE ::lastrec == 0 .OR. nWantSkip == 0
      ::skip(0)

   CASE nWantSkip > 0
      DO WHILE nDidSkip < nWantSkip
         ::skip(1)
         IF ::eof
            EXIT
         ENDIF
         nDidSkip ++
      ENDDO

   CASE nWantSkip < 0
      DO WHILE nDidSkip > nWantSkip
         ::skip(-1)
         IF ::bof
            EXIT
         ENDIF
         nDidSkip --
      ENDDO

   ENDCASE
RETURN  nDidSkip


/*
 * Sort the ::index array, not the data array referenced in ::records
 * The ::index array holds numeric row pointers.
 * Sorting the ::index array leaves the original data array intact!
 */
METHOD RecordSet:sort( nColumn )
   IF nColumn == NIL
      nColumn := 0
   ENDIF

   IF Valtype( nColumn ) == "C"
      nColumn := AScan( ::columnNames, {|c| Upper(c) == Upper(nColumn) } )
   ENDIF

   IF nColumn == 0
      AEval( ::index, {|n,i| n:=i },,, .T. )
   ELSE
      AASort( ::index, ::records, nColumn )
   ENDIF
RETURN self


STATIC PROCEDURE AASort( aIndex, aRecords, nColumn )
   ASort( aIndex, , ,{|n1,n2| aRecords[n1,nColumn] < aRecords[n2,nColumn] } )
RETURN


/*
 * Seek in data array
*/
METHOD RecordSet:seek(xValue)
  LOCAL  nIn

  IF(nIn := AScan( ::records, {|X| X[1] = xValue })) <> 0
    ::recno := nIn
  ENDIF
RETURN( nIn <> 0)