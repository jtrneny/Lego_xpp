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


*
** CLASS for NAK_objvyshd_vzt_IN **********************************************
CLASS NAK_objvyshd_vzt_IN FROM drgUsrClass
exported:
  var     mnozKOdod, mnozOBdod, mainFile
  *
  method  init, getForm, drgDialogInit, drgDialogStart, drgDialogEnd
  method  postValidate


  * broColumn  _ 2 _ 8
  **
  inline access assign method nazev_firmy() var nazev_firmy
    firmy ->(dbseek(vztahobjw->ncisfirmy,,'FIRMY1'))
    return firmy->cnazev

  inline access assign method stavZakaz() var stavZakaz
    vyrzak ->(dbseek(vztahobjw->ccisZakaz,,'VYRZAK1'))
    return(vyrzak->cstavZakaz)

  *
  ** event *********************************************************************
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local colPos  := ::brow:colPos, aRect, aPos, aSize
    local oColumn := ::brow:getColumn(colPos), odrg

    colPos := aScan(::aEdits, {|X| X[3] = colPos})

    DO CASE
    CASE(nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      return .f.

    CASE( nEvent = xbeP_Keyboard .and. ::inEdit )
      IF (mp1 = xbeK_ESC)
        ::killRead(.F.)
        ::brow:refreshCurrent()
        ::sumColumn()
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    case nEvent = drgEVENT_DELETE
      return .t.

    case(nevent = drgEVENT_EXIT .or. nevent = drgEVENT_QUIT)
      return .f.
*-      ::sum()

   case nEvent = drgEVENT_SAVE .and. oxbp:className() = 'XbpBrowse'
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
      return .t.


    case(nEvent = drgEVENT_EDIT)
      if colPos = 0  ;  colPos := 1
                        ::brow:colPos := ::aEdits[colPos,3]
                        oColumn := ::brow:getColumn(::brow:colPos)
      endif
      ::killRead()

      aRect := oColumn:dataArea:cellRect(::brow:rowPos)                        // presentation space
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

      SetAppFocus(::aEdits[colPos, 2]:oXbp)
      ::editPos := colPos
      ::inEdit  := .T.
      return .f.

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  var    parent, p_dm, msg, dm
  var    brow, inEdit, aEdits, editPos, drgGet
  var    it_file, state, m_key, intCount
  *
  method  killRead, set_Vztah

  inline method in_objvysit()
    return objvy_itw->(dbSeek(::m_key,,'OBJVYSIT_2'))

  * sumColum
  inline method sumColumn()
    local  recNo := vztahobjw->(recNo())
    local  x, value
    local  mnozKOdod := mnozOBdod := 0

    vztahobjw->( dbGoTop(), ;
                 dbeval({|| (mnozKOdod += vztahobjw->nmnozKOdod , ;
                             mnozOBdod += vztahobjw->nmnozOBdod   )}, ;
                        {|| vztahobjw->_delrec <> '9' }               ))

    for x := 6 to 7 step 1
      value := if(x = 6, str(mnozKOdod), str(mnozOBdod))

      ::brow:getColumn(x):Footing:hide()
      ::brow:getColumn(x):Footing:setCell(1,value)
      ::brow:getColumn(x):Footing:show()
    next

    vztahobjw->(dbGoTo(recNo))
  return mnozOBdod

ENDCLASS


method NAK_objvyshd_vzt_IN:init(parent)
  local  nEvent,mp1,mp2,oXbp,pa

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if( isObject(oXbp:cargo), ::drgGet := oXbp:cargo, NIL )
  *
  ::drgUsrClass:init(parent)
  *
  ::parent := parent:parent:udcp
  ::p_dm   := ::parent:dm

  ::mainFile := 'objvysitw'
  ::it_file  := 'vztahobjw'
  *
  pa         := listAsArray(parent:cargo)
  ::state    := val(pa[1])
  ::m_key    := pa[2]
  ::intCount := if(::state = 2,::parent:ordItem()+1,objvysitw->nintCount)
  parent:cargo := nil
  *
  ::set_Vztah()
return self


method NAK_objvyshd_vzt_IN:getForm()
  local  oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 110,10 DTYPE '10' TITLE 'Pokrytí objednávek pøijatých ...' ;
                                            GUILOOK 'Action:N,Message:Y,Menu:N,IconBar:N,Border:Y' ;
                                            BORDER 4

  DRGDBROWSE INTO drgFC FPOS 0,1.3 SIZE 109.9,8.7 FILE ::it_file       ;
    FIELDS 'nCISFIRMY:firma,'                                        + ;
           'M->nazev_firmy:název firmy:26,'                          + ;
           'DDATDOODB:datDod,'                                       + ;
           'DDATREODB:datRez,'                                       + ;
           'CCISLOBINT:èísloObj,'                                    + ;
           'NMNOZKODOD:množKobj,'                                    + ;
           'NMNOZOBDOD:množObj,'                                     + ;
           'M->stavZakaz::3'                                           ;
    SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'n'

* GETY v gridu
  DRGGET VZTAHOBJw->NMNOZOBDOD INTO drgFC FPOS 0,0 FLEN 8  POST 'postValidate'
*-  odrg:name   := ::it_file +'->nmnozOBdod'
  odrg:groups := '7'

  DRGSTATIC INTO drgFC FPOS 0,0 SIZE 110,1.3 STYPE XBPSTATIC_TYPE_RAISEDBOX
    DRGTEXT       INTO drgFC CAPTION 'Pokrytí objednávek pøijatých ...' CPOS 1,.1 FONT 5
    DRGPUSHBUTTON INTO drgFC POS 106.9,.05 SIZE 3,1 ATYPE 1 ICON1 102 ICON2 202 EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
  DRGEND  INTO drgFC
return drgFC


method NAK_objvyshd_vzt_IN:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]-21}
  endif
return


method NAK_objvyshd_vzt_IN:drgDialogStart(drgDialog)
  local  x, nIn, cfield
  local  aMembers := drgDialog:oForm:aMembers, oColumn
  *
  local  tabsNum  := IF( IsObject(::drgGet), Right(::drgGet:name,1), '0')

  *
  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager

  ::inEdit := .F.
  ::aEdits := {}

  FOR x := 1 TO LEN(aMembers)
    IF     aMembers[x]:ClassName() = 'drgDBrowse'
      ::brow := aMembers[x]:oXbp
    ELSEIF aMembers[x]:ClassName() = 'drgGet'
      aMembers[x]:postBlock := drgDialog:getMethod('postValidate')

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
      aMembers[x]:isEdit := .f.
*-      aMembers[x]:oXbp:hide()
    ENDIF
  NEXT

  * patièky
  for x := 1 to ::brow:colCount step 1
    ocolumn := ::brow:getColumn(x)

    ocolumn:FooterLayout[XBPCOL_HFA_CAPTION]     := ''
    ocolumn:FooterLayout[XBPCOL_HFA_HEIGHT]      := drgINI:fontH - 2
    ocolumn:FooterLayout[XBPCOL_HFA_FRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
    ocolumn:FooterLayout[XBPCOL_HFA_ALIGNMENT]   := XBPALIGN_RIGHT
    ocolumn:configure()
  next
  ::brow:configure():refreshAll()
  ::brow:colPos   := 7

  FOR x := 1 TO LEN( ::aEdits)
    oColumn :=  ::brow:getColumn(::aEdits[x][3])

    ::aEdits[x][2]:oXbp:setParent(oColumn:dataArea)

    IF IsOBJECT(::aEdits[x][4])
      ::aEdits[x][4]:oXbp:setParent(oColumn:dataArea)
    ENDIF
  NEXT

  ::sumColumn()
return self


method NAK_objvyshd_vzt_IN:drgDialogEnd()
  local mnozOBdod := ::sumColumn()

  ::drgGet:ovar:set(mnozOBdod)
  vztahobjw->(dbclearfilter())
return self


method NAK_objvyshd_vzt_IN:postValidate(drgVar)
  local  value   := drgVar:get()
  local  name    := lower(drgVar:name)
  local  changed := drgVAR:changed()
  *
  local  mnozKOdod := (::it_file)->nmnozKOdod
  local  nevent := mp1 := mp2 := nil, ok := .t.

  nevent  := LastAppEvent(@mp1,@mp2)

  do case
  case(name = ::it_file +'->nmnozobdod')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      if mnozKOdod >= value
        drgVar:save()
        *
        (::it_file)->(dbCommit())
        ::killRead()
        ::sumColumn()
        ::brow:refreshCurrent()
      else
        ::msg:writeMessage('Množství k objednání je pouze ...' +alltrim(str(mnozKOdod)) +'...',DRG_MSG_ERROR)
        ok := .f.
      endif
    endif
  endcase
return ok


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD NAK_objvyshd_vzt_IN:killRead(nextEdit)

  default nextEdit to .f.

  aeval(::aedits,{|x| x[2]:oxbp:disable()})

  IF ::inEdit
    ::aEdits[::editPos, 2]:oXbp:hide()
    IF IsObject(::aEdits[::editPos, 4])
      ::aEdits[::editPos, 4]:oXbp:hide()
    ENDIF

    IF nextEdit
      PostAppEvent(xbeP_Keyboard, xbeK_RIGHT,, ::brow)
      PostAppEvent(drgEVENT_EDIT,,, ::brow)
    ELSE
      SetAppFocus(::brow)
*-      ::showCell()
      ::inEdit := .F.
    ENDIF
  ENDIF
RETURN self


method NAK_objvyshd_vzt_IN:set_Vztah()
  local  filter, ky, v_ky, mnozOBodb, intCount := ::intCount, in_vztahobj
  *

  objitem->(AdsSetOrder('OBJITEM3'), dbSetScope(SCOPE_BOTH,::m_key), dbGoTop())

  filter := format("ccisOBJ = '%%' .and. nintCount = %%",{objvyshdw->ccisOBJ,::intCount})
  vztahobjw->(dbSetFilter(COMPILE(filter)),dbGoTop())

  do while .not. objitem->(eof())
    ky := upper(objitem  ->ccislOBint) +strZero(objitem->ncislPOLob,5) + ;
          upper(objvyshdw->ccisOBJ   ) +strZero(::intCount,5)

    mnozOBdod := 0
    v_ky := upper(objitem  ->ccislOBint) +strZero(objitem->ncislPOLob,5) +::m_key
    vztahob_w->(AdsSetOrder('VZTAHOB_3')                        , ;
                dbsetscope(SCOPE_BOTH,v_ky)                     , ;
                dbgotop()                                       , ;
                dbeval({|| mnozOBdod += vztahob_w->nmnozOBdod } , ;
                       {|| vztahob_w->nintCount <> intCount   }), ;
                dbclearScope()                                    )


    if .not. (in_vztahobj := vztahobjw->(dbSeek(ky,,'VZTAHOB_2')))
      vztahobjw->(dbappend())
      vztahobjw->ncisFirmy  := objitem  ->ncisFirmy
      vztahobjw->ccislOBint := objitem  ->ccislOBint
      vztahobjw->ncislPOLob := objitem  ->ncislPOLob
      vztahobjw->ccisSklad  := objitem  ->ccisSklad
      vztahobjw->csklPol    := objitem  ->csklPol
      vztahobjw->cpolCen    := objitem  ->cpolCen
      vztahobjw->ccisOBJ    := objvyshdw->ccisOBJ
      vztahobjw->nintCount  := ::intCount
      vztahobjw->ddatOBJ    := objvyshdw->ddatOBJ
      vztahobjw->ccisZakaz  := objitem  ->ccisZakaz
    endif
*
** ONLY in WORK
    vztahobjw->nmnozOBodb := objitem  ->nmnozOBodb
    vztahobjw->nmnozPOodb := objitem  ->nmnozPOodb
    vztahobjw->nmnozKOdor := objitem  ->nmnozKOdod

    if in_vztahobj
      vztahobjw->nmnozKOdod := vztahobjw->nmnozKOdor -(mnozOBdod +vztahobjw->nmnozOBdod) + ;
                                                      vztahobjw->nmnozOBdod
    else
      vztahobjw->nmnozKOdod := objitem  ->nmnozKOdod -mnozOBdod
      vztahobjw->nmnozKOdor := objitem  ->nmnozKOdod
    endif
    vztahobjw->ddatREodb  := objitem  ->dDatReODB
    vztahobjw->ddATDOodb  := objitem  ->dDATdoODB
    vztahobjw->_nrecobjit := objitem  ->(recNo())

    objitem->(dbSkip())
  enddo

  objitem  ->(dbClearScope())
  vztahobjw->(dbgotop(),flock())
return nil