/////////////////////////////////////////////////////////////////////
//
//  drgStatic.PRG
//
//  Copyright:
//      DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgStatic class manages different xbpStatic objects.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#pragma Library( "XppSYS.LIB"  )

#include "Appevent.ch"
#include "Common.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"

#pragma Library( "XppSYS.LIB" )

***********************************************************************
* drgStatic Class declaration
***********************************************************************
CLASS drgStatic FROM drgObject
  EXPORTED:
  METHOD  create
  METHOD  setFocus
  METHOD  resize

  var     caption
ENDCLASS

***********************************************************************
* Create drgStatic object.
***********************************************************************
METHOD  drgStatic:create(oDesc)
LOCAL aPos:={1,1}, size, aSize, fPos, app := {}
LOCAL caption := NIL, oBord
LOCAL cType, cName, oBmp
  oBord     := ::parent:getActiveArea()

  ::isEdit       := .F.
  ::isedit_inrev := .F.
  ::caption      := ''

//  ::Group  := oDesc:group

* Position of the group on the screen
  size  := ACLONE(oBord:currentSize())
  aSize := IIF( oDesc:size = NIL, {10,10}, ACLONE(oDesc:size) )
* Size of Group. IF Bitmap don't size with fonts
  IF oDesc:sType < 3 .OR. oDesc:sType > 5
    aSize[1] := aSize[1]*drgINI:fontW
    aSize[2] := aSize[2]*drgINI:fontH
  ENDIF
* IF GroupBox than  make a little difference
  IF oDesc:sType = 2; aSize[2] += INT(drgINI:fontH/2); ENDIF

  fPos := IIF(oDesc:fpos = NIL, {1, 1}, ACLONE(oDesc:fpos) )
  aPos[1] := fPos[1]*drgINI:fontW  + ::parent:leftOffset
  aPos[2] := size[2] - fPos[2]*drgINI:fontH - aSize[2] - ::parent:topOffset

  ::isGroup   := .F.
  ::canResize := .F.
  if( .not. empty(oDesc:caption), ::caption := oDesc:caption, nil )
  ::name      := oDesc:name

  DO CASE
  CASE oDesc:sType = 1                  // Text. If empty than used as box without frame
    IF EMPTY(oDesc:caption)
      ::isGroup   := .T.
      ::canResize := .T.
      caption := ''
    ELSE
      caption := oDesc:caption
    ENDIF
  CASE oDesc:sType = 2                  // GroupBox
    ::isGroup   := .T.
    ::canResize := .T.
    caption := drgNLS:msg( oDesc:caption )
  CASE oDesc:sType > 15                // Lines
    aSize[1] -= 4; aSize[2] := 0
    aPos[1] += 2;  aPos[2] += 4
  CASE oDesc:sType > 5                 // Frames, rectengulars, boxes
    ::isGroup   := .T.
    ::canResize := .T.
*    aSize[2] -= 4
  CASE oDesc:sType > 2                  // Icon, Sysicon, Bitmap
* Numeric. It must be resource number
    IF ISDIGIT(oDesc:caption)
      caption := VAL(oDesc:caption)
    ELSE
* Character. Probably file name
      oBmp := XbpBitmap():new():create()
      IF !FILE( cName := oDesc:caption )                // file in current dir
        IF !FILE( cName := drgINI:dir_RSRC + oDesc:caption )   // file in resource dir
* Set default to this
          caption := 1
          oBmp := NIL
        ENDIF
      ENDIF
* Load image from file
      IF EMPTY(caption)
        oBmp:loadFile(cName)
        caption := oBmp
      ENDIF
    ENDIF
  ENDCASE

*  aPos[1]  += ::parent:leftOffset    // ne vem še zakaj je bilo tako
* Other presentation parameters
*  aParm := IIF(oDesc:clrFG = NIL, 0, 0)
*  AADD(aPP,{ XBP_PP_FGCLR, aParm } )
* Create xbp
  ::tipText   := drgNLS:msg(oDesc:tipText)
  ::optResize := oDesc:resize
*
  ::oXbp := XbpStatic():new( oBord, , aPos, aSize, aPP )
  ::oXbp:type    := oDesc:sType
  ::oXbp:caption := caption

* If caption type specified for text captions
  IF oDesc:cType != NIL
    ::oXbp:options := oDesc:cType
  ENDIF
  ::oXbp:setFont( drgPP:getFont() )

  ::oXbp:create()
RETURN self


***************************************************************************
* Called by controller when drgObject can receive focus. Group objects don't
* receive focus at all.
***************************************************************************
METHOD drgStatic:setFocus(mp1, mp2, oXbp)
  PostAppEvent(drgEVENT_OBJEXIT, self,,::oXbp)
RETURN

***************************************************************************
* Method is called on window resize event.
***************************************************************************
METHOD drgStatic:resize(aOld, aNew)
  LOCAL nX, nY, newX_pos , newY_pos
  local         newX_size, newY_size

  nX := aNew[1] - aOld[1]
  nY := aNew[2] - aOld[2]
* New static size
  newX_size := IIF(SUBSTR(::optResize,1,1) = 'y', ::oXbp:currentSize()[1]+nX, ::oXbp:currentSize()[1] )
  newY_size := IIF(SUBSTR(::optResize,2,1) = 'y', ::oXbp:currentSize()[2]+nY, ::oXbp:currentSize()[2] )
*  ::oXbp:setSize( {newX,newY}, .F.)

* New static Pos
  newX_pos := IIF(SUBSTR(::optResize,1,1) = 'n', ::oXbp:currentPos()[1]+nX, ::oXbp:currentPos()[1] )
  newY_pos := IIF(SUBSTR(::optResize,2,1) = 'n', ::oXbp:currentPos()[2]+nY, ::oXbp:currentPos()[2] )
*  ::oXbp:setPos( {newX,newY}, .F.)

  ::oxbp:setPosAndSize( {newX_pos,newY_pos}, {newX_size,newY_size}, .f. )
RETURN self

************************************************************************
************************************************************************
*
* Group type definition class
*
************************************************************************
************************************************************************
CLASS _drgStatic FROM _drgObject

  EXPORTED:
  VAR     sType

  METHOD  init
  METHOD  parse
  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgStatic:init(line)
  ::type := 'static'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::sType        TO 2
  DEFAULT ::fPos         TO {1,1}
  DEFAULT ::size         TO {10,10}
  DEFAULT ::resize       TO 'nn'
RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgStatic:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'STYPE'
      ::sType := _getNum(value)

    CASE ::parsed(keyWord, value)
*   OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* Clean UP
************************************************************************
METHOD _drgStatic:destroy()
  ::_drgObject:destroy()
  ::sType   := ;
             NIL
RETURN