//////////////////////////////////////////////////////////////////////
//
//  drgArray.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgArray is the implementation of the sorted array with
//       ability to return elements by key.
//       This is my implementation of HashTable and Vector Java Classes.
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"

CLASS drgArray
  EXPORTED:
    VAR values

    METHOD init
    METHOD add
    METHOD getByKey
    METHOD hasMore
    METHOD update

    METHOD getNth
    METHOD getNext
    METHOD getLast
    METHOD getPrev
    METHOD getKey

    METHOD reSort
    METHOD destroy
    METHOD size

  HIDDEN:
    VAR  lastix, size, sorted
ENDCLASS

*    FOR n := 1 TO ::drgLoc:size()
*      drgDump(::drgLoc:getNth(n),::drgLoc:getKey(n))
*    NEXT

***************************************************************************
* Initialize array with initial capacity
***************************************************************************
METHOD drgArray:init(initialCapacity)
  DEFAULT initialCapacity TO 10
  ::values := ARRAY(initialCapacity,2)
  ::size   := 0
  ::lastix := 0
  ::sorted := .F.
RETURN self

***************************************************************************
* add new value to array
***************************************************************************
METHOD drgArray:add(value, key)
  DEFAULT key TO ' '
  key := LOWER(key)
  IF ++::size > LEN(::values)
    AADD(::values, { key, value} )
  ELSE
    ::values[::size,1] := key
    ::values[::size,2] := value
  ENDIF
  ::sorted := .F.
RETURN self

***************************************************************************
* returns size of the array
***************************************************************************
METHOD drgArray:size()
RETURN ::size

***************************************************************************
* get array element by key
***************************************************************************
METHOD drgArray:getByKey(key)
LOCAL x,delta, wasFound := .F.
LOCAL low := 0, high
  DEFAULT key TO ' '

  IF ::size = 0
    RETURN NIL
  ENDIF
  key := LOWER(key)

* Perform ASCAN if not sorted
  IF !::sorted
    x := ASCAN(::values, {|a| a[1] == key } )
    IF x = 0
      RETURN NIL
    ELSE
      ::lastix := x
      RETURN ::values[x, 2]
    ENDIF
  ENDIF

  high  := ::size + 1
* search in a sorted area by cutting scope by 2
  WHILE .T.
    delta := INT((high - low)/2)
    x := low + delta

    IF delta = 0
      EXIT
    ENDIF

    IF ::values[x,1] == key
      wasFound := .T.
      EXIT
    ENDIF

    IF ::values[x,1] >= key     // in lower half
      high := x
    ELSE
      low  := x                 // in higher half
    ENDIF
  ENDDO

  IF wasFound                   // return value if found
    ::lastix := x
    RETURN ::values[x,2]
  ENDIF

RETURN NIL

***************************************************************************
* updates value with specified key
***************************************************************************
METHOD drgArray:update(value, key)
  IF ::getByKey(key) != NIL
    ::values[::lastix,2] := value
  ELSE
    ::add(value, key)
    ::reSort()
  ENDIF
RETURN self

***************************************************************************
* returns true if array has more elements then last read element
***************************************************************************
METHOD drgArray:hasMore()
RETURN ::lastix < ::size

***************************************************************************
* returns Nth element of array
***************************************************************************
METHOD drgArray:getNth(n)
  DEFAULT n TO 1
  IF n > ::size .OR. n < 1
    RETURN NIL
  ENDIF
  ::lastix := n
RETURN ::values[n,2]

***************************************************************************
* returns next element of array
***************************************************************************
METHOD drgArray:getNext()
RETURN ::getNth(++::lastix)

***************************************************************************
* returns last element of array
***************************************************************************
METHOD drgArray:getLast()
RETURN ::getNth(::size)

***************************************************************************
* returns previous element to the last read element in array
***************************************************************************
METHOD drgArray:getPrev()
RETURN ::getNth(--::lastix)

***************************************************************************
* returns last used key
***************************************************************************
METHOD drgArray:getKey()
RETURN ::values[::lastix,1]

***************************************************************************
* resorts values in the array
***************************************************************************
METHOD drgArray:reSort()
  IF !::sorted
    ASORT( ::values, 1, ::size, {|aX,aY| aX[1] < aY[1] })
    ::sorted := .T.
  ENDIF
RETURN self

***************************************************************************
* Clean UP
***************************************************************************
METHOD drgArray:destroy()
LOCAL x
  FOR x := 1 TO ::size()
    IF VALTYPE(::values[x, 2]) = 'O'
      ::values[x, 2]:destroy()
    ENDIF
    ::values[x, 2] := NIL
  NEXT
  ::values := ;
  ::lastix := ;
  ::sorted := ;
  ::size   := NIL
RETURN self
