#include "class.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
*********OBECNÁ TØÍDA PRO UCETNI OBDOBI*****************************************
CLASS uctOBDOBI
  EXPORTED:
    METHOD  init
    METHOD  destroy

    VAR     aTASK_list
    VAR     a_mobdUser
    VAR     UCT
    VAR     FIN
    VAR     SKL
    VAR     ZVI
    VAR     HIM
    VAR     POK
    VAR     MZD
    VAR     PRO
    VAR     DIM
    var     VYR
    var     DOH

ENDCLASS

*
** users->modbUser je uloženo ve tvaru FIN,F201003;UCT,U201005 ...
**
METHOD uctOBDOBI:init()
  local  nIn, cVarName, cULOHA
  *
  local  m_filter :="culoha = '%%'", filter
  *
  **
  local  npos, pa, pi, cky, ctag

  ::a_mobdUser := {}
  ::atask_list := {}

  pa := listAsArray( users->mobdUser, ';' )

  for npos := 1 to len(pa) step 1
    pi := listAsArray( pa[npos] )

    if len( pi ) = 2
      aadd( ::a_mobdUser, { pi[1], pi[2] } )
    endif
  next
  **
  *
  drgDBMS:open('c_task' )
  c_task->(dbgotop(), ;
           dbeval({|| aadd(::atask_list,c_task->ctask +':' +c_task->culoha +':' +c_task->cnazulohy)}, ;
                  {|| c_task->luctuj }))

  drgDBMS:open('UCETSYS')

  FOR nIn := 1 TO LEN(::aTASK_list)
    cVarName := ListAsArray( ::aTASK_list[nIn], ':')[1]
    cULOHA   := ListAsArray( ::aTASK_list[nIn], ':')[2]

    filter := format(m_filter,{culoha})
    ucetsys->(ads_setaof(filter),DbGoTop())

    if (npos := ascan( ::a_mobdUser, { |it| upper(it[1]) = upper(cVarName) } )) <> 0
      cky  := ::a_mobdUser[npos,2]
      ctag := 'UCETSYS3'
    else
      cky  := culoha +'1'
      ctag := 'UCETSYS4'
    endif

    if .not. ucetsys->(dbseek(cky,,ctag))
      ucetsys->(dbgobottom())
    endif

    self:&cVarName := DbRecord(cVarName):new()

    ** bacha tohle se mì nelíbí
    ** tohle bylo zaremované proè - potože ???
*    if npos = 0
*      aadd( ::a_mobdUser, { cVarName, upper(cUloha)              + ;
*                                      strZero(ucetsys->nrok,4)   + ;
*                                      strZero(ucetsys->nobdobi,2)  } )
*    endif

    ucetsys->(ads_clearaof())
  NEXT

  UCETSYS ->( DbCloseArea())

  //  test zda existuje kalendáø - celý rok - pro aktuální datum
  genKalendar( Year( Date()))

RETURN self


METHOD uctOBDOBI:destroy()
  ::aTASK_list := NIL
RETURN self


*
*********OBECNÁ TØÍDA PRO POSLEDNÍ UCETNI OBDOBI********************************
CLASS uctOBDOBI_LAST
  EXPORTED:
    METHOD  init
    METHOD  destroy

    VAR     aTASK_list
    VAR     UCT
    VAR     FIN
    VAR     SKL
    VAR     ZVI
    VAR     HIM
    VAR     POK
    VAR     MZD
    VAR     PRO
    VAR     DIM
    var     VYR
    VAR     DOH

ENDCLASS


METHOD uctOBDOBI_LAST:init()
  local  nIn, cVarName, cULOHA
  *
  local  m_filter :="culoha = '%%'", filter

  ::atask_list := {}
  *
  drgDBMS:open('c_task' )
  c_task->(dbgotop(), ;
           dbeval({|| aadd(::atask_list,c_task->ctask +':' +c_task->culoha +':' +c_task->cnazulohy)}, ;
                  {|| c_task->luctuj }))

  drgDBMS:open('UCETSYS')

  FOR nIn := 1 TO LEN(::aTASK_list) step 1
    cVarName := ListAsArray( ::aTASK_list[nIn], ':')[1]
    cULOHA   := ListAsArray( ::aTASK_list[nIn], ':')[2]

    filter := format(m_filter,{culoha})
    ucetsys->(ordsetFocus( 'UCETSYS3'), ads_setaof(filter), dbgoBottom())

    self:&cVarName := DbRecord(cVarName):new()
    ucetsys->(ads_clearaof())
  NEXT

  UCETSYS ->( DbCloseArea())

RETURN self


METHOD uctOBDOBI_LAST:destroy()
  ::aTASK_list := NIL
RETURN self

*
**
STATIC FUNCTION DbRecord(cVarName)
  LOCAL aIVar, aMethod, oClass, nAttr, bSkip

  oClass := ClassObject(cVarName)

  IF oClass <> NIL
    RETURN oClass                 // Class already exists
  ENDIF

  nAttr   := CLASS_EXPORTED + VAR_INSTANCE
  aIVar   := AEval( DbStruct(), {|a| a:={a[1], nAttr} } ,,, .T.)

  nAttr   := CLASS_EXPORTED + METHOD_INSTANCE
  aMethod := {{ "INIT" , nAttr, {|self| GetRecord(self) } }, ;
              { "GET"  , nAttr, {|self| GetRecord(self) } }, ;
              { "PUT"  , nAttr, {|self| PutRecord(self) } }  }

  // Method with parameter according to obj:skip( n )
  bSkip   := {|self,n| DbSkip(n), ::get() }
  AAdd( aMethod, { "SKIP" , nAttr, bSkip } )
RETURN ClassCreate( cVarName,, aIVar, aMethod )


** Transfer values from fields to instance variables
static function GetRecord( oRecord )
  local astru := ucetsys->(dbstruct())

  aeval(astru,{|a,i| orecord:&(a[1]) := ucetsys->(fieldget(i)) })
return oRecord

/*
STATIC FUNCTION GetRecord( oRecord )
  AEval( DbStruct(), {|a,i| oRecord:&(a[1]) := FieldGet(i)} )
RETURN oRecord
*/

** Transfer values from instance variables to fields
STATIC FUNCTION PutRecord( oRecord )
  LOCAL lLocked := RLock()
  IF lLocked
    AEval( DbStruct(), {|a,i| FieldPut(i, oRecord:&(a[1])) } )
    DbUnlock()
  ENDIF
RETURN lLocked