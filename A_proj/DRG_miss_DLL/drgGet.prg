//////////////////////////////////////////////////////////////////////
//
//  drgGet.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgGet class handles xbpGet form field definition.
//
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////
#include "appevent.ch"
#include "Common.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "gra.ch"



CLASS drgGet FROM drgObject
  EXPORTED:

  VAR     picture
  VAR     clrFocus
  VAR     IsrelTO                                                               // miss
  VAR     push
  VAR     pushGet                                                               // miss
  VAR     cargoGet                                                              // schovka
  VAR     arRelate   // se to nehodí READONLY
  var     lsetColor                                                             // miss

  var     cballonTip

  METHOD  create
  METHOD  refresh
  METHOD  postValidateRelate
  METHOD  postValidate
  METHOD  preValidate
  METHOD  getPicture

  METHOD  destroy

  HIDDEN:
  VAR     aArea
  VAR     postEval
  var     cfield

  METHOD  postEvaluate
  METHOD  postValidateXbp
ENDCLASS

****************************************************************************
* Creates xbpGet object for data input in a form.
*
* /bParameters:b/
* /b<oDesc>b/   : object : drgFormField object containing field description
* /b<aForm>b/   : object : drgForm where xbpGet is to be created
*
* /bReturn:b/   : object : newly created xbpGetField
****************************************************************************
METHOD drgGet:create(oDesc)
LOCAL aPos:={1,1}, aParm, aPP, fPos, size, m_size
LOCAL cName, cFile, bBlock, aPicture
LOCAL aVal, relat, oBord, aFD, oHlp
LOCAL aDBD, st
*
local  pa, relFile, relAlias

  oBord := ::parent:getActiveArea()
* Position of the field on the screen
  size := oBord:currentSize()
  fPos := oDesc:fPos
  aPos[1] := fPos[1]*drgINI:fontW  + ::parent:leftOffset // + 1 zaradi estetike
  aPos[2] := size[2] - (fPos[2]+1)*drgINI:fontH - ::parent:topOffset + 1 // - fPos[2]
* Length of the field
*  fLen := (oDesc:fLen + 1)*drgINI:fontW

  aPP   := oDesc:pp + drgPP_PP_EDIT1 - 1
  ::clrFocus := drgPP:getPP(aPP)[2,2]
  ::lsetColor:= .t.
  ::IsrelTO  := .F.
  ::push     := oDesc:push

* Other presentation parameters

*  aParm := IIF(oDesc:clrFG = NIL, 1, oDesc:clrFG)
*  AADD(aPP,{ XBP_PP_FGCLR, aParm } )
*  AADD(aPP,{ XBP_PP_BGCLR, GRA_CLR_WHITE } )

* Get memory variable
  cFile    := _getcFilecName(@cName, oDesc, ::drgDialog:dbName)
  ::name   := cFile + '->' + cName
  ::cfield := lower(cName)

  drgLog:cargo := 'Get: ' + ::name
  ::oVar := ::drgDialog:dataManager:add(cFile, cName)
  ::oVar:oDrg := self

* Determine the size of static object
  if isArray(odesc:size) .and. oDesc:size[2] < 50
    m_size := { oDesc:size[1]*drgINI:fontW, oDesc:size[2]*drgINI:fontH }
  endif

* Create xbpGet field
  ::oXbp := XbpGet():new( oBord, , aPos, oDesc:fLen, drgPP:getPP(aPP),, m_size)
  ::oXbp:dataLink := {|a| ::oVar:getSet(a) }


* Set field picture
  ::oXbp:picture := ::getPicture(oDesc)

* Set RELATETO control block
  IF .NOT. (cFile == 'M')
    aFD   := drgDBMS:getFieldDesc(cFile, cName)   // get field description
    relat := aFD:relTO                            // has this field RELATETO statement
  ELSEIF(cFile == 'M') .and. ( !ISNIL(oDesc:relTO) .and. !ISNIL(oDesc:relTYPE) )
    relat := oDesc:relTO
  ENDIF
//
  IF VALTYPE(EVAL(::oVar:block)) == 'N'
    ::oXbp:align := If( IsNull(relat) .and. IsNull(::push), XBPSLE_RIGHT, XBPSLE_LEFT)
  ENDIF
//
  IF relat != NIL
    ::IsrelTO  := .T.                                                           // miss
    ::arRelate := {}
    ::aArea := SELECT()                        // It will be needed for check of REC0
    ::drgDialog:pushArea()                     // save current work area

    pa       := ListAsArray(relat)
    relFile  := pa[1]
    relAlias := if(len(pa) = 2, pa[2], pa[1])

    aArea    := drgDBMS:open(relFile,,,,,relAlias)

    AADD(::arRelate, { relFile, ;
                       IF(ISOBJECT(aFD), VAL(aFD:relType), VAL(oDesc:relTYPE)), ;
                       IF(ISOBJECT(aFD),     aFD:relORD  , 1                 ), ;
                       relAlias                                                 } )
    ::drgDialog:popArea()                      // restore work area
    ::postValidateRelate(.T.)
  ENDIF

* Set pre & post validation codeblocks
  ::setPreValidate(oDesc)
  ::setPostValidate(oDesc)
  ::postEval  := oDesc:postEval
  ::tipText   := drgNLS:msg(oDesc:tipText)
* HelpLink for window
  oHlp := XbpHelpLabel():new():create( ::drgDialog:helpName + '.htm#' + cName )
  oHlp:helpObject := drgHelp
  ::oXbp:helpLink   := oHlp

* Create object
  ::oXbp:tabStop := .F.
  ::oXbp:create()
  ::oXbp:setData()
  ::oXbp:cargo := self

** 2 5 6 7 je ok
  ::oXbp:setFont( drgPP:getFont(oDesc:font) )

* Set keyboard and inputFocus callbacks
  ::oXbp:keyboard      := { |mp1, mp2, o| ::keyboard( mp1, mp2, o ) }
  ::oXbp:setInputFocus := { |mp1, mp2, o| ::setInputFocus( mp1, mp2, o ) }


// JS
/*
  *
  ** showBallonTip
   if IsObject( odbd := drgDBMS:dbd:getByKey(cfile))
     if IsObject(odrgrf := odbd:getFieldDesc(cname))
       if .not. empty( odrgrf:desc )
         ::cballonTip      := odrgrf:desc
         ::oxbp:enter     := {|mp1, mp2, obj| ::oXbp:showTip( XBP_TIPINFO,,::cballonTip)}
         ::oxbp:leave     := {|mp1, mp2, obj| ::oxbp:hideTip()                          }
       endif
     endif
   endif
*/

  drgLog:cargo := NIL
RETURN self

*********************************************************************
* Post control for fields which have RELETETO other database statement
*********************************************************************
METHOD drgGet:postValidateRelate(atStart,atPush)
  LOCAL  rArea, rType, rOrd, rFile, aVal, xVal, srchDialog, selDialog
  local  lastDrg, ok := .f., is_ok := .t.
  *
  local  cfile := drgParse(::name,'-')

  IF EMPTY(::arRelate) // .OR. (::aArea)->( EOF() )
    RETURN .T.
  ENDIF
  DEFAULT atStart TO .F., atPush TO .F.

  rFile := ::arRelate[1,1]
  rType := ::arRelate[1,2]
  rOrd  := IsNull(::arRelate[1,3],1)
  rArea := ::arRelate[1,4]

  aVal  := ::oVar:oDrg:oXbp:value                                               // miss

* During dialog initialization
  IF atStart
    aVal := IF( VALTYPE(::oVar:get()) == 'C', Upper(::oVar:get()), ::oVar:get())
    ( rArea )->( DbSeek(aVal,, AdsCtag(rOrd)))

  ELSE
    IF rType = 2 .AND. EMPTY(aVal) .AND. !atPush                                // may be empty miss
    ELSE
      aVal := IF( VALTYPE(aVal) == 'C', Upper( aVal), aVal )
      IF .NOT. (rArea) ->(DbSeek(aVal,, AdsCtag(rOrd))) .OR. atPush                       // MISs

        IF ::push <> NIL .or. ((cfile)->(eof()) .and. ::drgdialog:oform:olastdrg <> self)
          RETURN .T.                                                            // exists own solution of validation in event PUSH(Event)
        ELSE
    * Post error message
          PostAppEvent(drgEVENT_MSG, drgNLS:msg('Invalid value!'), DRG_MSG_ERROR, ::oXbp )

          IF ::drgDialog:oForm:oLastDrg = self                                    // miss

            * Set cargo for comunication with drgFind. Must be set to self drgDialog because
            * getForm is called upon initialization of searchDialog

            ::oXbp:setColorBG((drgPP:getPP(drgPP_PP_EDIT3)[2,2]))

*            srchDialog := drgDialog():new('drgSearch', ::drgDialog)
            IF IsNull( ClassObject( rFile))
              xVal := if(ISNUMBER(aVal), STR(aVal), aVal )
              srchDialog := drgDialog():new('drgSearch', ::drgDialog)
              srchDialog:cargo := rFile + TAB + xVal + TAB +STR(rOrd) +TAB +rArea
            ELSE
              srchDialog := drgDialog():new( rFILE, ::drgDialog)
              srchDialog:cargo := aVal
            ENDIF
            // srchDialog:cargo := rFile + TAB + aVal + TAB +STR(rOrd) +TAB +rArea
            // srchDialog:cargo := aVal

            srchDialog:create(,,.T.)

            * Program waits until returned from drgSearch dialog
            * If search's dialog cargo is NIL than QUIT was selected

            * plácl ESC - nebo X ... nic si nevybral nesmíme ho pustit na daší prvek
            if srchDialog:exitState != drgEVENT_QUIT
              aVal  := if( VALTYPE(srchDialog:cargo) == 'C', Upper(srchDialog:cargo), srchDialog:cargo )
            endif
            is_ok := (rArea) ->(DbSeek(aVal,, AdsCtag(rOrd)))

            IF srchDialog:exitState != drgEVENT_QUIT .and. is_ok
              ::oVar:set(srchDialog:cargo)

              lastDrg := ::drgDialog:oform:oLastDrg
              ok      := .t.

              * je to OK, nìco si vybral obèas potøebujeme nìco dotáhnout
              * v našem postValidate bloku
              if ::postBlock != NIL
                EVAL(::postBlock, ::oVar)
              endif

              ::drgDialog:oform:setNextFocus(lastDrg:name,,.t.)
              PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,lastDrg:oxbp)
            ENDIF
            */
            srchDialog:destroy()
            srchDialog := NIL
            return ok

          ENDIF
        ENDIF
* Force redisplay of entry field again
        RETURN .F.
      ENDIF
    ENDIF
    ::drgDialog:dataManager:refresh(.T.)
  ENDIF
RETURN .T.

***************************************************************************
* PostValidation control for this object
***************************************************************************
METHOD drgGet:postValidate(endCheck)
  LOCAL  ret := .T.
  local  xVal

  DEFAULT endCheck TO .F.

  IF ::isReadOnly
    ::oVar:recall()
    RETURN .T.
  ENDIF

  if ::cfield = 'csklpol'
    if( select('cenZboz' ) = 0, drgDBMS:open('cenZboz' ), nil )
    if( select('ceCarKod') = 0, drgDBMS:open('ceCarKod'), nil )

    if .not. empty( xVal := ::oxbp:value )
      if ceCarKod->( dbseek( xVal,, 'CECARKOD01' ))
        ::oxbp:setData( ceCarKod->csklPol )
      endif
    endif
  endif


  // nasi uzivatele poridi DATUM ve tvaru DD.MM.xxxx a ocekavajo DD.MM.RRRR
  IF VALTYPE(::oVar:get()) = 'D'
    value := ::oxbp:xbpsle:editBuffer()

    if len(value) = 10 .and. empty(right(value,4))
      if .not. right(value,5) = '  .  '
        m_date := dtoc(::oxbp:value)
        m_date := stuff(m_date,7,4,str(year(date(),4)))
        ::oxbp:value := ctod(m_date)
      endif
    endif
  endif

* End check. On form closing all objects must be postvalidated.
  IF endCheck .AND. ::postValidOK != NIL
    RETURN ::postValidOK
  ELSE
* Update memVar value and executes postEvaluation if defined
  ::postEvaluate( ::oXbp:value )    // getData not used with reason
* First call oXbp postvalidation. It will set data and check for bad date
    IF (ret := (::oXbp:postValidate() .AND. ::postValidateRelate() ) )
      IF ::postBlock != NIL
        ret := EVAL(::postBlock, ::oVar)
      ENDIF
    ENDIF
 ENDIF
*
 IF !ret
   IF ::drgDialog:oForm:oLastDrg != self
     ::drgDialog:oForm:checkTabPage(self)
   ENDIF
   ::oXbp:setInputFocus()
 ENDIF
 ::postValidOK := ret
 IF !endCheck .AND. ret
   ::oXbp:setColorBG( ::clrFocus )
 ENDIF

 *
 if(ret,::ovar:prevValue := ::ovar:value,nil)
RETURN ret

***************************************************************************
* Performs postEvaluation of objects value. Thus all valid Xbase++ functions \
* can be evaluated prior postValidation is called.
***************************************************************************
METHOD drgGet:postValidateXbp()
LOCAL c
*
  IF VALTYPE(::oVar:get()) = 'D'
    ::oXbp:getData( .F. )
    c := ::oVar:get()
    IF !EMPTY(c)
      ::oVar:recall()
      ::oXbp:setData()
      RETURN .F.
    ENDIF
  ENDIF
  ::oXbp:getData( .F. )
RETURN .T.

***************************************************************************
* Performs postEvaluation of objects value. Thus all valid Xbase++ functions \
* can be evaluated prior postValidation is called.
***************************************************************************
METHOD drgGet:postEvaluate(aValue)
LOCAL x, t, aVal, prcEval
LOCAL cParsed, cEval
  IF ::postEval != NIL
    cEval := ::postEval
    WHILE !EMPTY(cParsed := drgParse(@cEval,';') )
      t := VALTYPE(aValue)
      DO CASE
      CASE t = 'C'
        aVal := "'" + aValue + "'"
      CASE t = 'L'
        aVal := IIF(aValue,'.T.','.F.')
      CASE t = 'N'
        aVal := ALLTRIM(STR(aValue))
      ENDCASE

      prcEval := cParsed
      WHILE (x := AT('&', prcEval) ) > 0
        prcEval := STUFF(prcEval, x, 1, aVal)
      ENDDO
      aValue := &prcEval
    ENDDO
  ENDIF
  ::oVar:getSet(aValue)
*  ::oXbp:setData()
RETURN aValue

***************************************************************************
* Refresh this object with new value
***************************************************************************
METHOD drgGet:refresh(xNewValue)
  local name

  ::oXbp:setData(xNewValue)
  ::postValidateRelate(.T.)
*  drgDump(::oXbp:get(), ::oVar:name )
RETURN

***************************************************************************
* Prevalidation method for drgGet
***************************************************************************
METHOD drgGet:preValidate( lsetColor )
  LOCAL ret := ::drgObject:preValidate()

  default lsetColor to .t.

  lsetColor := ( lsetColor .and. ::lsetColor )

  IF ret .AND. !::isReadOnly
    if( lsetColor, ::oXbp:setColorBG((drgPP:getPP(drgPP_PP_EDIT3)[2,2])), nil )
  ENDIF
RETURN ret

***************************************************************************
* Returns picture of object
***************************************************************************
METHOD drgGet:getPicture(oDesc)
LOCAL aPic, x, i, n, m
LOCAL xVal
  IF oDesc:picture != NIL
    aPic := oDesc:picture
* Picture from reference
  ELSEIF ::oVar:ref != NIL
    aPic := ::oVar:ref:picture
  ENDIF

  IF aPic = NIL
    xVal := ::oVar:get()
    DO CASE
    CASE VALTYPE(xVal) = 'C'
      aPic := '&' + ALLTRIM( STR(oDesc:fLen) ) + ' X'
    CASE VALTYPE(xVal) = 'N'
      aPic := '@N'
    CASE VALTYPE(xVal) = 'D'
      aPic := '@D'
    OTHERWISE
      aPic = ''
    ENDCASE
  ENDIF
* Replace all ocurence of & with no. of chars defined by '&99 X'
  WHILE ( x:= AT('&', aPic) ) > 0
    m := ''                         // multiplikator
    n := 2                          // number of chars to be replaced
* Search for first non digit char
    FOR i := x+1 TO LEN(aPic)
      IF ISDIGIT(aPic[i])
        m := m + aPic[i]
        n++
      ELSE
        EXIT
      ENDIF
    NEXT
* IF char is blank than next char is to be multiplicated
    IF EMPTY( aPic[i] )
      ch := aPic[i+1]
      n++
    ELSE
      ch := aPic[i]
    ENDIF
    ch := REPLICATE(ch, VAL(m) )      // string to STUFF
    aPic := STUFF(aPic, x -1, n, ch)
  ENDDO

RETURN aPic

***************************************************************************
* Cleanup
***************************************************************************
METHOD drgGet:destroy()
  ::drgObject:destroy()

  ::picture     := ;
  ::aArea       := ;
  ::arRelate    := ;
  ::postEval    := ;
  ::clrFocus    := ;
  ::IsrelTO     := ;
  ::push        := ;
                    NIL
RETURN

************************************************************************
************************************************************************
*
* Get type definition class
*
************************************************************************
************************************************************************
CLASS _drgGet FROM _drgObject
  EXPORTED:
  VAR     push                                                                  // miss
  VAR     relTO                                                                 // miss
  VAR     relTYPE                                                               // miss
  VAR     revTYPE                                                               // miss

  METHOD  init
  METHOD  parse
*  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgGet:init(line)
  ::type := 'get'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::fLen    TO 1
  DEFAULT ::fPos    TO {1, 1}
  DEFAULT ::pp      TO 1
  DEFAULT ::rOnly   TO .F.
  DEFAULT ::revTYPE TO 0
RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgGet:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'PUSH'
      ::push    := _getStr(value)
    CASE keyWord = 'RELATETO'
      ::relTO   := UPPER( _getStr(value) )
    CASE keyWord = 'RELATETYPE'
      ::relType := _getStr(value)
    CASE keyWord = 'NOREVISION'
      ::revTYPE := 1
      ::parsed(keyWord, value)

    CASE ::parsed(keyWord, value)
*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

/************************************************************************
* CleanUP
************************************************************************
METHOD _drgGet:destroy()
  ::_drgObject:destroy()
RETURN
*/