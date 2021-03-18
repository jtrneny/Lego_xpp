//////////////////////////////////////////////////////////////////////
//
//  drgText.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgText class handles static form field  definition.
//
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////
#pragma Library( "XppSYS.LIB"  )


#include "Common.ch"
#include "Xbp.ch"
#include "Gra.ch"
#include "drg.ch"


CLASS drgText
  EXPORTED:

  VAR     parent
  VAR     drgDialog
  VAR     oXbp
  VAR     oBord
  VAR     oVar
  VAR     picture
  VAR     isEdit
  VAR     isGroup
  VAR     isContainer
  VAR     canResize
  VAR     optResize
  VAR     tipText
  VAR     Groups
  VAR     arRelate   READONLY

  METHOD  init
  METHOD  create
  METHOD  refresh
  METHOD  resize
  METHOD  destroy

  INLINE METHOD  preValidate
  RETURN .F.
  INLINE METHOD  postValidate
  RETURN .T.

ENDCLASS

METHOD drgText:init(parent)
  ::parent      := parent
  ::drgDialog   := parent:drgDialog
  ::isGroup     := .F.
  ::isContainer := .F.
  ::isEdit      := .F.
  ::Groups      := ''
RETURN self

****************************************************************************
* Creates xbpText object in a form.
*
* /bParameters:b/
* /b<oDesc>b/  : object : drgFormField object containing field description
*
* /bReturn:b/  : object : newly created xbpStatic object
****************************************************************************
METHOD drgText:create(oDesc)
LOCAL aPos := {1,1}, nLen, cPos, fPos, size, aSize
LOCAL aPP, oBord
LOCAL caption, aParm, staticType
LOCAL cFile, cName
*
local  aFD, relat

  oBord := ::parent:getActiveArea()
  size := ACLONE( oBord:currentSize() )
* Groups
  IF IsMemberVar(oDesc, 'groups')
    ::Groups  := oDesc:groups  // miss
  ENDIF
* Picture
  ::picture := oDesc:picture
* Caption value if added to other drgXXX objects
  IF IsMemberVar(oDesc, 'fCaption')
    caption := oDesc:fCaption
  ENDIF
* still NIL then from description
  IF caption = NIL
    caption := oDesc:caption
  ENDIF

* IF caption is NIL than it is a memory VAR or database field. Add to memManager
  IF caption = NIL
    cFile := _getcFilecName(@cName, oDesc, ::drgDialog:dbName)
* Open file if not memory var
    IF !(LOWER(cFile) == 'm')
      ::drgDialog:pushArea()
      drgDBMS:open(cFile)
      ::drgDialog:popArea()
    ENDIF
*
    drgLog:cargo := 'Text: ' + cFile + '->' + cName
    ::oVar       := ::drgDialog:dataManager:add(cFile, cName, .T.)
    ::oVar:oDrg  := self
    caption      := drg2String(::oVar:get(), ::picture)
  ELSE
    drgLog:cargo := 'Text: ' + caption
    caption      := drgNLS:msg(caption)                  // support NLS
  ENDIF
* Stil NIL. It is an error. Set caption to '**'
  DEFAULT caption TO '**'
  caption := STRTRAN(caption,';',Chr(13))

* Length of the caption. We may also assume that cLen is not specified.
  IF (nLen := oDesc:cLen) = NIL
    IF (oDesc:fPos != NIL)
* IF in same row than subtract field position from caption position
      IF oDesc:fPos[2] = oDesc:cPos[2]
        nLen := oDesc:fPos[1] - oDesc:cPos[1] - 1
      ELSE
        nLen := IIF(oDesc:fLen = NIL, LEN(caption), oDesc:fLen + 1)
      ENDIF
    ELSE
      nLen := LEN(caption)
    ENDIF
  ENDIF
  nLen  *= drgINI:fontW

* Determine the size of static object
  IF oDesc:size = NIL .OR. oDesc:fCaption != NIL // IsMemberVar(oDesc, 'fCaption')
    aSize := {nLen, drgINI:fontH }
  ELSEIF oDesc:size[2] < 50
    aSize := { oDesc:size[1]*drgINI:fontW, oDesc:size[2]*drgINI:fontH }
  ELSE
    aSize := ACLONE(oDesc:size)
  ENDIF

* Test JT
  do case
  case oDesc:font = 2 .or. oDesc:font = 6
    aSize[2] := aSize[2] + 4
  case oDesc:font = 3 .or. oDesc:font = 7
    aSize[2] := aSize[2] + 6
  case oDesc:font = 4 .or. oDesc:font = 8
    aSize[2] := aSize[2] + 10
  endcase

  * Set RELATETO control block
  IF ( .not. empty(cfile) .and. .not. empty(cname))
    aFD   := drgDBMS:getFieldDesc(cFile, cName)                                     // get field description
    relat := if( isObject( aFD) .and. isMembervar( aFD, 'relTo'), aFD:relTO, nil )  // has this field RELATETO statement
  ENDIF

  IF relat != NIL
    ::arRelate := {}
    pa       := ListAsArray(relat)
    relFile  := pa[1]
    relAlias := if(len(pa) = 2, pa[2], pa[1])

    aArea    := drgDBMS:open(relFile,,,,,relAlias)

    AADD(::arRelate, { relFile, ;
                       IF(ISOBJECT(aFD), VAL(aFD:relType), VAL(oDesc:relTYPE)), ;
                       IF(ISOBJECT(aFD),     aFD:relORD  , 1                 ), ;
                       relAlias                                               , ;
                       aFD:type                                                 } )
  ENDIF


* Position of the field on the screen
  cPos := ACLONE(oDesc:cPos)
  aPos[1] := cPos[1]* drgINI:fontW + ::parent:leftOffset
  aPos[2] := size[2] - cPos[2]*drgINI:fontH - aSize[2] - ::parent:topOffset //- cPos[2]
* Resize
  ::optResize := oDesc:resize
  ::canResize := !(::optResize = NIL .OR. ::optResize = 'xx')


* Border around the static
  ::oBord := XbpStatic():new( oBord,, aPos,  aSize )
  ::oBord:type := IIF( EMPTY(oDesc:bgnd), drgINI:defTextBGND, oDesc:bgnd )
  ::oBord:create()

* Type of caption
*  staticType := oDesc:cType
*  DEFAULT staticType TO drgINI:defTextType
  aPP := oDesc:pp + drgPP_PP_TEXT1 - 1

  aSize[1] -= 6
  aSize[2] -= 6
  ::oXbp := XbpStatic():new( ::oBord,, {3,3},  aSize , drgPP:getPP(aPP) )
  ::oXbp:options := IIF( EMPTY(oDesc:cType), drgINI:defTextType, oDesc:cType )
  ::oXbp:caption := caption
  ::oXbp:setFont( drgPP:getFont(oDesc:font) )
  ::oXbp:create()
  ::oXbp:cargo := self

  ::tipText   := drgNLS:msg(oDesc:tipText)
  drgLog:cargo := NIL
RETURN self

***************************************************************************
* Method is called on dialog window resize event.
***************************************************************************
METHOD drgText:resize(aOld, aNew)
LOCAL nX, nY, newX, newY
  nX := aNew[1] - aOld[1]
  nY := aNew[2] - aOld[2]
*  New Border size
  newX := IIF(SUBSTR(::optResize,1,1) = 'y', ::oBord:currentSize()[1]+nX, ;
                                             ::oBord:currentSize()[1] )
  newY := ::oBord:currentSize()[2]
  ::oBord:setSize( {newX,newY}, .F.)
*  New border position
  newX := IIF(SUBSTR(::optResize,1,1) = 'n', ::oBord:currentPos()[1]+nX, ::oBord:currentPos()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'n', ::oBord:currentPos()[2]+nY, ::oBord:currentPos()[2] )
  ::oBord:setPos( {newX,newY}, .F.)
*  New xbpStatic size
  newX := IIF(SUBSTR(::optResize,1,1) = 'y', ::oXbp:currentSize()[1]+nX, ::oXbp:currentSize()[1] )
  newY := ::oXbp:currentSize()[2]
  ::oXbp:setSize( {newX,newY}, .F.)
RETURN self


****************************************************************************
* Refreshes value of field on the form
****************************************************************************
METHOD drgText:refresh(xNewValue)
  local  oldValue := ::oxbp:caption
  local  newValue := drg2String(xNewValue, ::picture)
  *
  local  rFile, rType, rOrd, rArea, type, aVal

  if( oldValue <> newValue, ::oxbp:setCaption( newValue), nil )

  * možnost zobrazení doprovodných textù
  if isArray( ::arRelate )
    rFile := ::arRelate[1,1]
    rType := ::arRelate[1,2]
    rOrd  := IsNull(::arRelate[1,3],1)
    rArea := ::arRelate[1,4]
    cType := ::arRelate[1,5]
    aVal  := ::oxbp:caption

    aVal := if( cType = 'C', Upper( aVal), ;
             if( cType = 'N', val(aVal), aVal ))

   * musíme zabezpeèit aby relaèní vazba na DBD
   * nerepozicovala BRO

    if ascan(::drgDialog:odbrowse, { |o| lower(o:cfile) = lower(rArea) }) = 0
//      ( rArea )->( DbSeek(aVal,, AdsCtag(rOrd)))
    endif

  endif
RETURN

****************************************************************************
* CleanUP
****************************************************************************
METHOD drgText:destroy()

  ::oXbp:destroy()
  ::oBord:destroy()

  ::drgDialog   := ;
  ::parent      := ;
  ::oXbp        := ;
  ::oBord       := ;
  ::oVar        := ;
  ::picture     := ;
  ::isGroup     := ;
  ::isContainer := ;
  ::isEdit      := ;
  ::canResize   := ;
  ::optResize   := ;
  ::tipText     := ;
  ::Groups      := ;
                   NIL
RETURN

************************************************************************
************************************************************************
*
* Static type definition class
*
************************************************************************
************************************************************************
CLASS _drgText FROM _drgObject
  EXPORTED:

  METHOD  init
  METHOD  parse
  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgText:init(line)
  ::type := 'text'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::cpos    TO {1,1}
  DEFAULT ::PP      TO 1
  DEFAULT ::resize  TO 'xx'

RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgText:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE ::parsed(keyWord, value)

*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgText:destroy()
  ::_drgObject:destroy()
RETURN