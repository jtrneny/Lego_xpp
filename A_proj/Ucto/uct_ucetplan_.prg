#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


Static  anPLAN := {}


**
** CLASS for FRM UCT_ucetpocs_CRD **********************************************
CLASS UCT_ucetplan_CRD FROM drgUsrClass
EXPORTED:
  method  init, comboBoxInit, drgDialogStart, eventHandled
  method  itemMarked, comboItemSelected
  method  postValidate, postLastField

HIDDEN:
  method  showGroup

  var     aEdits, panGroup, members, NROK
  VAR     dm, dc, df, oabro, nState      // 0 - inBrowse  1 - inEdit  2 - inAppend

  inline method restColor()
    local members := ::df:aMembers
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.
ENDCLASS


METHOD UCT_ucetplan_CRD:eventHandled(nEvent, mp1, mp2, oXbp)
  local  anPlan   := {}
  LOCAL  nBRo, nCOLn, nIn, nRECs
  LOCAL  lOk      := .T.
  LOCAL  dc       := ::drgDialog:dialogCtrl
  LOCAL  dbArea   := ALIAS(dc:dbArea)

  DO CASE
  CASE (nEvent = xbeBRW_ItemMarked)
*-    drgDump(oXbp:cargo:cfile)

    BEGIN SEQUENCE
      FOR nBRo := 1 TO LEN(dc:oBrowse)
        FOR nCOLn := 1 TO dc:oBrowse[nBRo]:oXbp:colCount
          IF dc:oBrowse[nBRo]:oXbp:getColumn(nCOLn) = oXbp:parent
    BREAK
          ENDIF
        NEXT
      NEXT
    END SEQUENCE

    IF nBRo <= 2
      dc:oaBrowse                             := dc:oBrowse[nBRo]
      dc:drgDialog:oForm:oLastDrg             := dc:oaBrowse
      dc:dataManager:drgDialog:lastXbpInFocus := dc:oaBrowse:oXbp
      dc:dbArea                               := dc:oaBrowse:dbArea

      SetAppFocus(dc:oaBrowse:oXbp)

      IF dbArea <> ALIAS(dc:dbArea)
        ::panGroup := STR(nBRo,1)
        ::showGroup()
      ENDIF
    ENDIF
    ( ::nState := 0, anPLAN := {} )
    RETURN .F.

  CASE nEvent = drgEVENT_EDIT
    BEGIN SEQUENCE
      FOR nIn := 1 TO LEN(::aEdits)
        IF ::aEdits[nIn,1] = ::panGroup
    BREAK
        ENDIF
      NEXT
    END SEQUENCE

    ::nState := 1
    ::drgDialog:oForm:setNextFocus(::aEdits[nIn,2] +1,, .T. )
    RETURN .T.

  CASE nEvent = drgEVENT_APPEND
    IF dbArea = 'UCETPLAH'                                                      // not for UCETPLAN

      ::dm:refreshAndSetEmpty( 'ucetplah' )

      ::drgDialog:dataManager:set('UCETPLAH->NPOCOBD_PL', SYSCONFIG('UCTO:nPocOBD_PL'))

      ::nState := 2
      ::drgDialog:oForm:setNextFocus(::aEdits[1,2] +1,, .T. )
      RETURN .T.
    ENDIF

  case nEvent = drgEVENT_SAVE
    if .not. (lower(::df:oLastDrg:classname()) $ 'drgdbrowse')
      ::postLastField()
    endif
    return .t.

  case nEvent = drgEVENT_DELETE
    if lower(dbArea) = 'ucetplah' .and. .not. ucetplah->(eof())                                                     // not for UCETPLAN

      if drgIsYESNO('Zrušit plán na rok '+str(ucetplah ->nrok) +' pro úèet ' +ucetplah ->cucetMd + '.?')
        ucetplan->(dbeval( {|| aadd(anPlan,ucetplan->(recNo())) } ))
        if ucetplah->(sx_rLock()) .and. ucetplan->(sx_rLock(anPlan))
          ucetplan->(dbeval( { || ucetplan->(dbdelete()) }))
          ucetplah->(dbdelete())
        endif
        ucetplah->(dbunlock(), dbcommit())
        ucetplan->(dbunlock(), dbcommit())

        ::oabro[1]:oxbp:refreshAll()
        ::dm:refresh()
        PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
      endif
    endif
    return .t.

  CASE nEvent = xbeP_Keyboard
    IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
      ::restColor()
      ::drgDialog:oForm:setNextFocus(AScan(::members, dc:oaBrowse),, .T. )
      ::dm:refresh()
      RETURN .T.
    ELSE
      RETURN .F.
    ENDIF

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.


method UCT_ucetplan_CRD:init(parent)
  ::drgUsrClass:init(parent)

  ::aEdits   := {}
  ::panGroup := '1'
  ::NROK     := uctOBDOBI:UCT:NROK
  ::nState   := 0

  drgDBMS:open('UCETPLAH')
  drgDBMS:open('UCETPLAN')
  drgDBMS:open('C_UCTOSN')
  drgDBMS:open('UCETSYS' )

  // relace //
  UCETPLAN ->( DbSetRelation( 'C_UCTOSN', { || UPPER(UCETPLAN->CUCETMD) }))
  UCETPLAH ->( DbSetRelation( 'C_UCTOSN', { || UPPER(UCETPLAH->CUCETMD) }))
return self


method UCT_ucetplan_CRD:comboBoxInit(drgComboBox)
  local  nIn, aROK_zpr := {}

  UCETSYS ->( dbEVAL( { || ;
     If( aSCAN(aROK_zpr, { |X| X[1] == UCETSYS ->nROK }) == 0                    , ;
         aADD(aROK_zpr, { UCETSYS ->NROK, 'ROK _ ' +STRZERO( UCETSYS ->nROK,4) }), ;
         NIL ) }))

  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( aROK_zpr,,, {|aX,aY| aX[2] < aY[2] } )
  AEVAL(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

 * musíme nastavit startovací hodnotu *
  drgComboBox:value := drgComboBox:ovar:value := ::nrok
return self


method UCT_ucetplan_CRD:drgDialogStart(drgDialog)
  local  x

  ::members := drgDialog:oForm:aMembers
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form
  ::oabro   := drgDialog:dialogCtrl:obrowse


  for x := 1 to len(::members) step 1
    if ::members[x]:ClassName() = 'drgStatic' .and. IsNull(::members[x]:groups,'') <> ''
      AAdd(::aEdits, { ::members[x]:groups, x })
    endif
  next

  ucetplah->( ads_SetAof("nROK = " +STR(::nROK,4)), dbGoTop() )
return self


method UCT_ucetplan_CRD:itemMarked()
  local  cKy := STRZERO(UCETPLAH ->nROK,4) + UPPER(UCETPLAH ->cUCETMD  + ;
                                                   UCETPLAH ->cNAZPOL1 + ;
                                                   UCETPLAH ->cNAZPOL2 + ;
                                                   UCETPLAH ->cNAZPOL3 + ;
                                                   UCETPLAH ->cNAZPOL4 + ;
                                                   UCETPLAH ->cNAZPOL5 + ;
                                                   UCETPLAH ->cNAZPOL6   )
  IF( cKy <> ucetplan->( DbScope(SCOPE_TOP)), ucetplan->(DbSetScope(SCOPE_BOTH, cKy), DbGoTop()), NIL )
  ::showGroup()
return self


method UCT_ucetplan_CRD:comboItemSelected(mp1, mp2, o)
  local  dc := ::drgDialog:dialogCtrl

  if ::NROK <> mp1:value
    ucetplah ->(ads_clearAof(), ads_setAOF("nROK = " +STR(mp1:value,4)), dbGoTop())

    ::NROK := mp1:value

    ::oabro[1]:oxbp:refreshAll()
    ::dm:refresh()

    * musíme nastavit vybranou hodnotu *
*--->    mp1:ovar:value := mp1:ovar:initValue := mp1:ovar:prevValue := ::nrok

    PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
    SetAppFocus(::oabro[1]:oXbp)
  endif
return .t.


METHOD UCT_ucetplan_CRD:postValidate(drgVar)                                     // kotroly a výpoèty
  LOCAL  value := drgVar:get()
  LOCAL  name  := lower(drgVar:name)
  *
  Local  lOk  := .T., planZaObd

  DO CASE
  CASE( 'nplanrok' $ name ) .or. ('npocobd_pl' $ name )
    planZaObd := ::dm:get('UCETPLAH->NPLANROK') / ::dm:get('UCETPLAH->NPOCOBD_PL')
    ::dm:set('UCETPLAH->NPLANZAOBD', planZaObd)
  ENDCASE

  if(name = 'ucetplah->cnazpol6')
   if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
     ::postLastFileld()
*-      if( ::overPostLastField(), ::postLastField(), nil)
    endif
  endif
RETURN .T.


METHOD UCT_ucetplan_CRD:postLastField()
  local  isChanged := ::dm:changed()
  local  odrg      := ::df:oLastDrg
  local  file      := drgParse(lower(odrg:name),'-')

  ** ukládáme UCETLAH / UCETPLAN

  do case
  case( file = 'ucetplah')
    if isChanged .and. UCETPLAN_lock((::nState == 2))
      ::dataManager:save()
      UCETPLAH ->nROK      := ::NROK
      UCETPLAH ->nPLAN_POL := ::dm:get('UCETPLAH->NPLANROK') / 2
      UCETPLAH ->nPLAN_POL := ::dm:get('UCETPLAH->NPLANROK') / 4
      UCETPLAH ->cUSERABB  := SYSCONFIG('SYSTEM:cUSERABB')
      UCETPLAH ->dDATZMENY := DATE()
      UCETPLAN_auto(1)

      ::oabro[1]:oxbp:refreshAll()
      ::dm:refresh()
      PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
      SetAppFocus(::oabro[1]:oXbp)
    endif

  otherwise
    if isChanged .and. UCETPLAN_lock(.F.)
      ::dataManager:save()
      UCETPLAN ->cUSERABB  := SYsCONFIG('SYSTEM:cUSERABB')
      UCETPLAN ->dDATZMENY := DATE()
      UCETPLAN_auto(2)

      ::oabro[2]:oxbp:refreshCurrent()
      ::dm:refresh()
    endif
  endcase

  ::restColor()
  ::drgDialog:oForm:setNextFocus(AScan(::members, ::dc:oaBrowse),, .T. )
RETURN .T.


// HIDDEN METHOD and FUNCTION //
METHOD UCT_ucetplan_CRD:showGroup()
  Local  x

  FOR x := 1 TO LEN(::members)
    If IsMemberVar(::members[x],'groups') .and. IsNull(::members[x]:groups,'') <> ''
      IF IsMemberVar(::members[x], 'isEdit')
        ::members[x]:isEdit := (::members[x]:groups = ::panGroup)
      ENDIF
    ENDIF
  NEXT
RETURN self


//
static function UCETPLAN_lock(lNEWrec)
  local  nRECs := UCETPLAN ->( RecNo())
  local  alPLAN, lPLAN := .T.
  local          lPLAH := If(lNEWrec, ADDrec('UCETPLAH'), REPLrec( 'UCETPLAH'))

  anPlan := {}
  if .not. lnewRec
    ucetplan->( dbeval({ || AAdd( anPlan, ucetplan->(recNo()) ) }), DbGoTo(nRECs) )
  endif

  If !(lPLAH .and. ucetplan->(sx_rLock(anPlan)))
    drgMsgBox('Nelze uložit zmìny, blokováno uživatelem ...')
  EndIf
Return(lPLAH .and. lPLAN)


static function UCETPLAN_auto(nACTIVe)
  local  nITm  := 1
  local  nRECs := UCETPLAN ->( RecNo())
  local  nPLANROK, nPLANzaOBD := UCETPLAH ->nPLANROK/UCETPLAH ->nPocOBD_PL
  local  cROK  := Right(Str(UCETPLAH ->nROK),2)

  UCETPLAN ->( DbGoTop())

  if nACTIVe = 1
    do while ( ucetplah->npocObd_PL >= nITm )
      If !EMPTY( anPLAN)
        UCETPLAN ->( dbGoTo( anPLAN[ 1])                   )
        ( aDEL( anPLAN, 1), aSIZE( anPLAN, LEN( anPLAN) -1))
      Else                ; UCETPLAN ->( DbAppend(), DbRLock() )
      EndIf

      mh_COPYFLD( 'UCETPLAH', 'UCETPLAN',, .f. )
      UCETPLAN ->cOBDOBI    := STRZERO( nITm, 2) +'/' +cROK
      UCETPLAN ->nOBDOBI    := nITm
      UCETPLAN ->nPLANzaOBD := nPLANzaOBD
      UCETPLAN ->nPLANkOBD  := nPLANzaOBD *nITm
      nITm++
    EndDo
    aEVAL( anPLAN, { |X| UCETPLAN ->( dbGoTo( X), dbDelete()) } )
  Else
    ( nPLANROK := 0, nPLANzaOBD := 0 )
    Do While !UCETPLAN ->( EOF())
      UCETPLAN ->nPLANkOBD := UCETPLAN ->nPLANzaOBD +nPLANzaOBD
      nPLANzaOBD += UCETPLAN ->nPLANzaOBD
      nPLANROK   += UCETPLAN ->nPLANzaOBD
      UCETPLAN ->( DbSkip())
    EndDo
    UCETPLAN ->( DbGoTo(nRECs))
    UCETPLAH ->nPLANROK := nPLANROK
  EndIf

  UCETPLAH ->( DbUnlock(), DbCommit() )
  UCETPLAN ->( DbUnlock(), DbCommit() )
RETURN(Nil)