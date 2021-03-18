#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"

#pragma Library( "XppUI2.LIB" )


#xtranslate IsDrgGet(<o>) => IF( IsNull(<o>)  , NIL, ;
                             IF( IsObject(<o>), IF( <o>:className() = 'drgGet', <o>, NIL ), NIL))


FUNCTION FIN_vykdph_BC(nCOLUMn)
  C_VYKDPH ->( DbSeek( STRZERO( VYKDPH_Iw ->nODDIL_dph,2) +STRZERO(VYKDPH_Iw ->nRADEK_dph,3),, AdsCtag(1) ))
RETURN(c_VYKDPH ->cRADEK_say)


*
** CLASS for NAK_objit_at_IN **************************************************
CLASS NAK_objit_at_IN drgUsrClass
exported:
  var     nFINTYP
  *
  var     mainFile
  var     nosvoddan
  var     nprocdan_1, nzakldan_1, nsazdan_1, odvod_1, narok_1
  var     nprocdan_2, nzakldan_2, nsazdan_2, odvod_2, narok_2

  method  init, drgDialogStart, drgDialogEnd, itemMarked, tabSelect, postLastField, key_board, fin_cmdph

  * broColumn  _ 8
  **
  inline access assign method stavZakaz() var stavZakaz
    vyrzak ->(dbseek( objit_atw ->ccisZakaz,, AdsCtag(1) ))
  return(vyrzak->cstavZakaz)

  *
  ** event *********************************************************************
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local colPos  := ::oBROw:colPos, aRect, aPos, aSize
    local oColumn := ::oBROw:getColumn(colPos), odrg

    colPos := aScan(::aEdits, {|X| X[3] = colPos})

    DO CASE
    CASE(nEvent = xbeBRW_ItemMarked)
      IF oXbp:ClassName() = 'XbpCellGroup'
        oColumn:= oXbp:parent
        BEGIN SEQUENCE
          FOR colPos := 1 to ::OBROw:colCount
            IF ::oBROw:getColumn(colPos) = oColumn
        BREAK
            ENDIF
          NEXT
        END SEQUENCE
        ::oBROw:hilite()
        ::oBROw:colPos := colPos
      ENDIF
      ::showCell()
      RETURN .f.

    CASE( nEvent = xbeP_Keyboard .and. ::inEdit )
      IF (mp1 = xbeK_ESC)
        ::killRead(.F.)
        ::oBROw:refreshCurrent()
        ::sum()
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    case(nevent = drgEVENT_EXIT .or. nevent = drgEVENT_QUIT)
      ::sum()

    case(nEvent = drgEVENT_EDIT)
      if(::inedit, ::postValidate(), nil )
      ::killRead()

      aRect := oColumn:dataArea:cellRect(::oBROw:rowPos)                        // presentation space
      aPos  := { aRect[1], aRect[2] }                                           // position
      aSize := { aRect[3]-aRect[1], aRect[4]-aRect[2] }                         // and size of object
      *
      odrg    := ::aEdits[colPos,2]:ovar
      odrg:refresh()
      *
      ::aEdits[colPos, 2]:oXbp:setPos ( aPos  )                                 // set position
      ::aEdits[colPos, 2]:oXbp:setSize( aSize )                                 // and size
      ::aEdits[colPos, 2]:oXbp:show()

      ::aEdits[colPos, 2]:oXbp:enable()

      ::aEdits[colPos, 2]:postBlock := ::postBlock

      if ::tabNum <> 1 .and. IsObject(::aEdits[colPos][4])
        aPos[1] += aSize[1] -aSize[2] -2
        aPos[2] += 1
        ::aEdits[colPos][4]:oXbp:setPos ( aPos )
        ::aEdits[colPos][4]:oXbp:show()
      endif

      SetAppFocus(::aEdits[colPos, 2]:oXbp)
      ::editPos := colPos
      ::inEdit  := .T.
      return .t.

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR    typ, subTitle
  VAR    obrow, inEdit, aEdits, editPos, drgGet, tabNum, roundDph
  VAR    postBlock

  METHOD showCell, killRead, postValidate, sum
ENDCLASS


method NAK_objit_at_IN:init(parent)
  LOCAL nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  ::drgGet := IsDrgGet(oXbp:cargo)
  *
  ::drgUsrClass:init(parent)
  *
  ::typ      := IsNull(parent:parent:UDCP:typ_lik, '')
  ::roundDph := SysConfig('Finance:nRoundDph')
  *
  do case
  case(::typ = 'zav')
    ::subTitle := 'závazkù ...'
    ::mainFile := 'FAKPRIHDw'
  case(::typ = 'poh')
    ::subTitle := 'pohledávek ...'
    ::mainFile := 'FAKVYSHDw'
  case(::typ = 'pok')
    ::subTitle := 'pokladních dokladù ...'
    ::mainFile := 'POKLADHDw'
  case(::typ = 'ucd')
    ::subTitle := 'úèetních dokladù ...'
    ::mainFile := 'UCETDOHDw'
  endcase

  drgDBMS:open('typdokl')
  typdokl->(dbseek(upper((::mainFile)->ctypdoklad),, AdsCtag(3) ))
return self


method NAK_objit_at_IN:drgDialogStart(drgDialog)
  local  x, nIn, cfield
  local  aMembers := drgDialog:oForm:aMembers, oColumn, aVar
  *
  local  tabsNum  := IF( IsObject(::drgGet), Right(::drgGet:name,1), '0')

  ** naplníme M-> z DAT **
  aVar := ::classDescribe(CLASS_DESCR_MEMBERS)

  FOR x := 1 TO LEN(aVar)
    cfield := aVar[x,CLASS_MEMBER_NAME]
    IF (::mainFile) ->(FieldPos(cfield)) <> 0
      self:&cfield :=  DBGetVal(::mainFile +'->' +cFIELD)
    ENDIF
  NEXT

  ::inEdit := .F.
  ::aEdits := {}
  ::tabNum := 1
  ::postBlock := drgDialog:getMethod('postLastField')

  FOR x := 1 TO LEN(aMembers)
    IF     aMembers[x]:ClassName() = 'drgBrowse'
      ::oBROw := aMembers[x]:oXbp
    ELSEIF aMembers[x]:ClassName() = 'drgGet'
      aadd(::aEdits, { NIL                                                       , ;
                       aMembers[x]                                               , ;
                       Val(aMembers[x]:groups)                                   , ;
                       if(isobject(amembers[x]:pushGet),amembers[x]:pushGet,nil) } )

    ELSEIF aMembers[x]:ClassName() = 'drgPushButton'
      BEGIN SEQUENCE
      FOR nIn := 1 TO LEN(::aEdits)
        IF aMembers[x]:drgGet = ::aEdits[nIn][2]
          ::aEdits[nIn][4] := aMembers[x]
      BREAK
        ENDIF
      NEXT
      END SEQUENCE
      aMembers[x]:oXbp:hide()
    ENDIF
  NEXT

  ::oBROw:colPos   := 3
  ::oBROw:Keyboard := { |nKey| ::key_Board (nKey) }

  FOR x := 1 TO LEN( ::aEdits)
    oColumn :=  ::oBROw:getColumn(::aEdits[x][3])

    ::aEdits[x][2]:oXbp:setParent(oColumn:dataArea)

    IF IsOBJECT(::aEdits[x][4])
      ::aEdits[x][4]:oXbp:setParent(oColumn:dataArea)
    ENDIF
  NEXT

  ::tabNum := IF( tabsNum $ '1,2', Val(tabsNum) +1, 1)

  drgDialog:oForm:tabPageManager:toFront(::tabNum)
  ::tabSelect(NIL,::tabnum)

  ::sum()
RETURN self


method NAK_objit_at_IN:drgDialogEnd()
  vykdph_iw->(dbclearfilter())
  ::sum()
return self


METHOD NAK_objit_at_IN:itemMarked()
  ::showCell()
RETURN self


* tabNum - 1 osvobozeno ntyp_dph 0
*          2 snížená             1
*          3 základní            2
method NAK_objit_at_IN:tabSelect(drgTabPage, tabNum)
  local  typ  := IF(tabNum = 1, 0, IF(tabNum = 2, 1, 2)), col_hd, x
  local  acol := { {'', '', 'osvobozeno', ''   , ''       , ''     }, ;
                   {'', '', 'základ'    , 'daò', 'krácení', 'SuAu_'}  }
  *
  local  m_filter := "ntyp_dph = %%", filter

  if ::tabNum <> tabNum .or. isnull(drgTabPage)
    filter := format(m_filter,{typ})
    vykdph_iw->(dbsetfilter(COMPILE(filter)),dbgotop())

    for x := 3 to 6 step 1
      col_hd := acol[if(tabnum >= 2,2,1),x]

      ::obrow:getColumn(x):heading:hide()
      ::obrow:getColumn(x):heading:setCell(1,col_hd)
      ::obrow:getColumn(x):heading:show()
    next

    ::aedits[2,2]:isedit := ::aedits[3,2]:isedit := ::aedits[4,2]:isedit := (tabNum >= 2)
    ::killRead()
    ::oBROw:refreshAll()
    ::showCell()

    ::tabNum := tabNum
  endif
return .t.


method NAK_objit_at_IN:postValidate()
  local  odrg, name

  if (odrg := ::drgDialog:oform:olastdrg):className() = 'drgGet'
    name := lower(odrg:name)

    if (name = 'vykdph_iw->nzakld_dph' .and. ::tabNum <> 1 )
      vykdph_iw->nsazba_dph := mh_roundnumb((odrg:ovar:value/100) * vykdph_iw->nprocdph, ::roundDph)
    endif
  endif
return .t.


*
** ::oBROw:Keyboard **
method NAK_objit_at_IN:key_Board(nkey)
  local  bBlock

  do case
  case nkey == xbeK_DOWN       ;  bBlock := {|o| o:down() }
  casE nKey == xbeK_UP         ;  bBlock := {|o| o:up() }
  case nKey == xbeK_LEFT       ;  bBlock := {|o| o:left()     }
  case nKey == xbeK_RIGHT      ;  bBlock := {|o| o:right()    }
  case nkey == xbeK_PGDN       ;  bBlock := {|o| o:pageDown() }
  case nKey == xbeK_PGUP       ;  bBlock := {|o| o:pageUp()   }
  case nkey == xbeK_CTRL_PGDN  ;  bBlock := {|o| o:goBottom() }
  case nKey == xbeK_CTRL_PGUP  ;  bBlock := {|o| o:goTop()    }
  endcase

  if( bblock <> nil)
    do case
    case(nkey = xbeK_RIGHT) .and. (::obrow:colpos = ::obrow:colcount)
      ::obrow:down():refreshCurrent()
      ::obrow:colPos := 3

    case(nkey = xbeK_LEFT ) .and. (::obrow:colpos = 3)
      ::obrow:up():refreshCurrent()
      ::obrow:colPos := 6

    otherwise
      eval(bblock,::obrow)
    endcase

    ::obrow:refreshAll()

    if((nkey == xbeK_DOWN .or. nkey == xbeK_UP), _clearEventLoop(), nil)
  endif

  ::showCell()
return(bblock <> nil)


METHOD NAK_objit_at_IN:postLastField(drgVar)
  LOCAL  dc     := ::drgDialog:dialogCtrl
  LOCAL  name   := drgVAR:name
  LOCAL  lZMENa := ::drgDialog:dataManager:changed()

  // ukládáme VYKDPH_Iw na každém PRVKU //
*  IF lZMENa
   ::dataManager:save()
   ::oBROw:refreshCurrent()
*  ENDIF

  ::killRead(.T.)
  ::sum()
RETURN .T.



method NAK_objit_at_IN:FIN_cmdph(drgDialog)
  LOCAL oDialog, nExit, odrg := drgDialog:oform:olastdrg

  DRGDIALOG FORM 'FIN_CMDPH' PARENT drgDialog MODAL DESTROY  EXITSTATE nExit

  if(nExit != drgEVENT_QUIT)
    ::obrow:refreshcurrent()
    postappevent(drgEVENT_EDIT,,,::obrow)
  endif
RETURN (nExit != drgEVENT_QUIT)


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method NAK_objit_at_IN:showCell()
  local  colPos, nXD, nYD, nXH, nYH
  local  aPos, aSize, aRect
  *
  local  oColumn := ::oBROw:getColumn(::oBROw:colPos), oPS

  colPos  := IF( ::oBROw:colPos = 1 .or. ::oBROw:colPos = 2, 3, ::oBROw:colPos )
  oColumn := ::oBROw:getColumn(colPos)

  if ::obrow:forceStable()
    oPS    := oColumn:dataArea:lockPS()
    aRect  := oColumn:dataArea:cellRect(::obrow:rowPos)

    aPos   := { aRect[1]         , aRect[2]          }
    aSize  := { aRect[3]-aRect[1], aRect[4]-aRect[2] }

    nXD := aRect[1] +1                       ; nYD := aRect[4] -1
    nXH := aRect[1] +(aRect[3] -aRect[1]) -2 ; nYH := aRect[2] +1

    GraSetColor( oPS, GraMakeRGBColor( {90 ,240, 84}) , GRA_CLR_GREEN )
    GraBox( oPS, {nXD,nYD}, {nXH,nYH}, GRA_OUTLINE, 5, 5)
    oColumn:dataArea:unlockPS(oPS)
  endif
RETURN self


METHOD NAK_objit_at_IN:killRead(nextEdit)

  default nextEdit to .f.

  aeval(::aedits,{|x| x[2]:oxbp:disable()})

  IF ::inEdit
    ::aEdits[::editPos, 2]:oXbp:hide()
    ::aEdits[::editPos, 2]:postBlock := NIL
    IF IsObject(::aEdits[::editPos, 4])
      ::aEdits[::editPos, 4]:oXbp:hide()
    ENDIF

    IF nextEdit
      PostAppEvent(xbeP_Keyboard, xbeK_RIGHT,, ::oBROw)
      PostAppEvent(drgEVENT_EDIT,,, ::oBROw)
    ELSE
      SetAppFocus(::oBROw)
      ::showCell()
      ::inEdit := .F.
    ENDIF
  ENDIF
RETURN self


method NAK_objit_at_IN:sum()
  local  czustuct, ntyp_dph, pa := {}

  ::nosvoddan  := 0
  ::nzakldan_1 := ::nsazdan_1 := ::odvod_1 := ::narok_1 := 0
  ::nzakldan_2 := ::nsazdan_2 := ::odvod_2 := ::narok_2 := 0

  vykdph_is->(dbgotop())
  do while .not. vykdph_is->(eof())
    czustuct := lower(vykdph_is->czustuct)
    ntyp_dph :=       vykdph_is->ntyp_dph
    do case
    case(czustuct = 'm')
      if(ntyp_dph = 1, ::narok_1 += vykdph_is->nsazba_dph, ::narok_2 += vykdph_is->nsazba_dph)

    case(czustuct = 'd')
      if(ntyp_dph = 1, ::odvod_1 += vykdph_is->nsazba_dph, ::odvod_2 += vykdph_is->nsazba_dph)

    endcase

    * návratové hodnoty dokladu
    do case
    case empty(czustuct)
       ::nosvoddan += vykdph_is->nzakld_dph

    case (vykdph_is->nzakld_dph +vykdph_is->nsazba_dph) <> 0
      if ascan(pa,{|x| x = vykdph_is->nradek_vaz}) = 0
        aadd(pa,vykdph_is->nradek_vaz)
        *
        if     (ntyp_dph = 1)  ;  ::nzakldan_1 += vykdph_is->nzakld_dph
                                  ::nsazdan_1  += vykdph_is->nsazba_dph
        elseif (ntyp_dph = 2)  ;  ::nzakldan_2 += vykdph_is->nzakld_dph
                                  ::nsazdan_2  += vykdph_is->nsazba_dph
        endif
      endif
    endcase

    vykdph_is->(dbskip())
  enddo

  ::drgDialog:dataManager:refresh()
return