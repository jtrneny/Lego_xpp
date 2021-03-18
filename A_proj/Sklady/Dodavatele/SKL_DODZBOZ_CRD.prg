*
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"

#include "DRGres.Ch'
#include "XBP.Ch"

*===============================================================================
FUNCTION HlavniDOD()
RETURN IF( DODZBOZ->lHlavniDod, DRG_ICON_SELECTT, DRG_ICON_SELECTF)


********************************************************************************
* SKL_DODZBOZ_CRD
********************************************************************************
CLASS SKL_DODZBOZ_CRD FROM drgUsrClass
EXPORTED:
  VAR     dPrijemOd, dPrijemDo

  METHOD  Destroy, drgDialogStart, drgDialogEnd, eventHandled, tabSelect
  METHOD  postValidate, Firmy_sel, postLastField

  * dodZboz hlavniDod
  inline access assign method hlavniDod() var hlavniDod
    return if( dodZboz->lhlavniDod, 172, 0 )


  inline method init(parent)
    ::drgUsrClass:init(parent)
    *
    ::lnewRec   := .F.
    ::dPrijemOd := CTOD('  .  .  ')
    ::dPrijemDo := Date()
  return self


  inline method itemMarked()
    ::setFilter( 'PVPITEM')
    ::sumColumn()
  return self


  inline method post_drgEvent_Refresh()

    if ( ::broDOD = ::dc:oaBrowse:oxbp )
      ::sta_activeBro:oxbp:setCaption( 337 )     // in dodZboz
    else
      ::sta_activeBro:oxbp:setCaption( 338 )     // in pvpItem
    endif
  return self

HIDDEN
* sys
  var     brow, msg, dm, dc, df
  var     sta_activeBro

  VAR     tabNum, broDOD, broPVP, tabPM, RecNO, lNewRec
  METHOD  setFilter

  inline method refresh()
    LOCAL  nIn, odrg
    LOCAL  oVAR, vars := ::drgDialog:dataManager:vars
    *
    for nIn := 1 to vars:size() step 1
      oVar := vars:getNth(nIn)

      if isBlock( ovar:block )
        xVal := eval( ovar:Block )

        if ovar:value <> xVal
          ovar:value := xval
          ovar:odrg:refresh( xVal )
        endif
      endif
    NEXT
  return .t.


  inline method sumColumn()
    local  arDef := ::dc:oBrowse[2]:arDef
    local  pa    := { { 'nmnozprdod', 0 }, { 'ncenacelk', 0 } }
    *
    local  recNo := pvpItem->( recNo()), x, npos, ocolumn

    pvpItem->( dbeval( { || ( pa[1,2] += pvpItem->nmnozPrDod, ;
                              pa[2,2] += pvpItem->ncenaCelk   ) } ) )
    pvpItem->( dbgoTo( recNo))

    for x := 1 to len(pa) step 1
      if( npos := ascan( arDef, { |ait| pa[x,1] $ lower( ait[2]) })) <> 0

        ocolumn := ::broPvp:getColumn(npos)
        ocolumn:Footing:Hide()
        ocolumn:Footing:setCell(1, pa[x,2] )
        ocolumn:Footing:show()
      endif
    next
  return .t.

ENDCLASS


method SKL_DODZBOZ_CRD:drgDialogStart(drgDialog)
  local  x
  local  aMembers := drgDialog:oForm:aMembers

  ::msg       := drgDialog:oMessageBar             // messageBar
  ::dc        := drgDialog:dialogCtrl              // dataCtrl
  ::dm        := drgDialog:dataManager             // dataMananager
  ::df        := drgDialog:oForm                   // form

  ::broDOD    := ::dc:oBrowse[1]:oXbp
  ::broPVP    := ::dc:oBrowse[2]:oXbp
  ::tabPM     := drgDialog:oForm:tabPageManager

  ::brow      := ::dc:oBrowse

  for x := 1 TO LEN(aMembers) step 1
    if aMembers[x]:ClassName() = 'drgStatic'
      if aMembers[x]:oxbp:type = XBPSTATIC_TYPE_ICON
         ::sta_activeBro := aMembers[x]
      endif
    endif
  next

  ColorOfTEXT( ::dc:members[1]:aMembers )
  IsEditGET( {'DodZBOZ->cNazev' }, ::drgDialog, .F. )
  *
  ::setFilter( 'DodZboz')
  ::tabNum := 1
RETURN


********************************************************************************
METHOD SKL_DODZBOZ_CRD:destroy()
  ::drgUsrClass:destroy()
  ::dc := ::dm := ::tabNum := ::broDOD := ::broPVP := ::tabPM := ::RecNO := ;
  ::lNewRec := ::dPrijemOd := ::dPrijemDo := ;
  NIL
RETURN self


********************************************************************************
METHOD SKL_DODZBOZ_CRD:drgDialogEnd(drgDialog)

  dodZboz->( ads_clearAof())
  pvpItem->( dbclearScope(), ads_clearAof())
RETURN self


method SKL_DODZBOZ_CRD:eventHandled(nEvent, mp1, mp2, oXbp)
  local  m_file   := lower(::dc:oaBrowse:cfile)
  local  myEv     := {drgEVENT_APPEND,drgEVENT_EDIT,drgEVENT_DELETE}
  local  cisFirmy := dodZboz->ncisFirmy


  if ascan(myEv,nevent) <> 0
    if m_file = 'pvpitem'
      fin_info_box('Tohle opravdu nejde, pøeètete si prosím nápovìdu ...')
      return .t.
    else
      if cisFirmy = 0  // no DEL - ENTER->INS
        nevent := if( nevent = drgEVENT_EDIT, drgEVENT_APPEND, 0 )
      endif
    endif
  endif


  IF nEvent = xbeP_Keyboard
    IF mp1 == xbeK_ESC
      IF ::tabNum = 1
        postAppEvent(xbeP_Close, drgEVENT_EXIT,,oXbp)

      ELSEIF ::tabNum = 2
        postAppEvent(xbeTab_TabActivate,,, ::df:tabPageManager:members[1]:oxbp)
**        ::tabPM:toFront(1)
        IF ::lNewRec
**          IF( IsNull( ::RecNO), nil, DodZBOZ->( dbGoTO(::RecNO )) )
          ::broDOD:refreshCurrent()
        ELSE
          ::broDOD:refreshALL()
        ENDIF
        ::itemMarked()
        ::lnewRec := .F.
        SetAppFocus( ::broDOD)
        ::df:oLastDrg := ::brow[1]

        RETURN .T.
      ENDIF
    ENDIF
  ENDIF


  do case
  case ( nEvent = drgEVENT_APPEND )
    ::lnewRec := .t.

    ::dm:refreshAndSetEmpty( 'dodZboz' )
    ::dm:set('DODZBOZ->cZkratMeny', CENZBOZ->cZahrMena )
    ::dm:set('DODZBOZ->cKatcZbo'  , CENZBOZ->cKatcZbo  )
    ::dm:set('DODZBOZ->cNazDod1'  , CENZBOZ->cNazZbo   )
    ::dm:set('DODZBOZ->cNazDod2'  , CENZBOZ->cNazZbo2  )

    isEditGET( {'DodZBOZ->nCisFirmy' }, ::drgDialog, .T. )

    ::drgDialog:oForm:setNextFocus('DODZBOZ->nCisFirmy')

     postAppEvent(xbeTab_TabActivate,,, ::df:tabPageManager:members[2]:oxbp)
     ::tabNum := 2

   case ( nEvent = drgEVENT_EDIT )
     ::lnewRec := .F.
      isEditGET( {'DodZBOZ->nCisFirmy' }, ::drgDialog, .F. )
      postAppEvent(xbeTab_TabActivate,,, ::df:tabPageManager:members[2]:oxbp)

      ::drgDialog:oForm:setNextFocus('DODZBOZ->lHlavniDOD',, .T.)
      ::tabNum := 2

   case ( nEvent = drgEVENT_DELETE )
     if drgIsYESNO(drgNLS:msg('Zrušit záznam ...;;' + ;
                              'Opravdu požadujete zrušení záznamu o dodavateli ?') )
       if dodZboz->( dbRLock())
         dodZboz->( dbDelete(), dbUnlock())
         ::broDOD:refreshAll()
         ::itemMarked()
         ::broPVP:refreshAll()
       endif
     endIf

   case ( nEvent = drgEVENT_SAVE )
     ::postLastField()

   otherWise

     RETURN .F.
   endcase
RETURN .T.



********************************************************************************
METHOD SKL_DODZBOZ_CRD:tabSelect( tabPage, tabNum)

  if tabNum <> ::tabNum
    do case
    case      tabNum = 1
      ::df:oLastDrg := ::brow[1]
      ::refresh()

    otherWise
      if .not. ::lnewRec
        postAppEvent(drgEVENT_EDIT,,, ::broDOD)
        ::refresh()
      endif
    endcase
  endif

  ::tabNum := tabNum
RETURN .T.

********************************************************************************
METHOD SKL_DODZBOZ_CRD:postVALIDATE(oVar)
  Local lOK := .T. , nRecNo
  Local xVal := oVar:get(), cName := oVar:Name
  Local lChanged := oVar:changed()
  Local nEvent := mp1 := mp2 := oxbp := nil

  nEvent := LastAppEvent(@mp1,@mp2,@oxbp)


  if oxbp:className() = 'XbpImageTabPage'.and. nevent = xbeTab_TabActivate
    return .t.
  endif


  DO CASE
  Case cName = 'M->dPrijemOd'
  Case cName = 'M->dPrijemDo'
    IF ::dm:get( 'M->dPrijemOd') <= xVal
      ::dPrijemOd := ::dm:get( 'M->dPrijemOd')
      ::dPrijemDo := xVal
      ::itemMarked()
      SetAppFocus( ::broPVP)
      ::broPVP: refreshAll()
    ELSE
      drgMsgBox(drgNLS:msg('Chybný datový interval !'))
      lOK := .F.
    ENDIF
  *
  Case cName = 'DodZboz->nCisFirmy'
    IF ( nEvent = xbeP_Keyboard  )
      * v insertu chce šipkou nahoru, tedy mimo záložku
      IF( mp1 = xbeK_UP  .and. ::lNewRec) ; RETURN .F. ; ENDIF
      * v insertu dá ESC, takže nevalidovat
      IF( mp1 = xbeK_ESC .and. ::lNewRec) ; RETURN .T. ; ENDIF
    ENDIF
    lOK := ::Firmy_sel()

  CASE cName = 'DODZBOZ->NCENAOZBO'
    IF ( nEvent = xbeP_Keyboard )
      IF( !::lNewRec .and.( mp1 = xbeK_UP .or. mp1 = xbeK_SH_TAB)) ; RETURN .F.  ;  ENDIF
    ENDIF

  CASE cName = 'DODZBOZ->lHlavniDod'
    IF lChanged
      nRecNo := DODZBOZ->( RecNo())
      DODZBOZ->( dbGoTOP())
      DODZBOZ->( dbEval( {|| ;
        IF( nRecNo <> DODZBOZ->( RecNo()) .and. DODZBOZ->LHLAVNIDOD,;
          IF( ReplREC('DODZBOZ'), ( DODZBOZ->LHLAVNIDOD := .F., DODZBOZ->( dbUnLock()) ), NIL ), NIL) } ))
      DODZBOZ->( dbGoTO( nRecNO))
    ENDIF

  Case cName = 'DodZboz->MPOZDOD'
    IF ( nEvent = xbeP_Keyboard .and. mp1 = xbeK_TAB)
      ::postLastField()
    ENDIF

  ENDCASE

RETURN lOK

********************************************************************************
METHOD SKL_DODZBOZ_CRD:postLastField()
  Local nRec

  IF ::lNewRec
    DodZBOZ->( mh_ClrFilter(), dbAppend())
    nRec := DodZBOZ->( RecNO())
  ENDIF
  IF DodZBOZ->( dbRLock())
    ::dm:save()
    DodZboz->cCisSklad  := CenZboz->cCisSklad
    DodZboz->cSklPol    := CenZboz->cSklPol
    DODZBOZ->nKlicNaz   := CENZBOZ->nKlicNaz
    DODZBOZ->nCenPol    := CENZBOZ->nCenPol
    *
    mh_WrtZmena( 'DodZboz', ::lNewRec )
    DodZboz->( dbUnlock())
    IF ::lNewRec
      ::setFilter( 'DodZboz')
      DodZBOZ->( dbGoTO( nRec))
      ::itemMarked()
    ENDIF
    *
    ::tabPM:toFront(1)
    ::broDOD:refreshAll()
    ::broPVP:refreshALL()
    ::lNewRec := .F.
  ENDIF

RETURN .T.

** HIDDEN **********************************************************************
METHOD SKL_DODZBOZ_CRD:setFilter( cAlias)
  Local  Filter, cFilter, aFilter, aRec := {}, nCount := 0
  local  isdat_ok := .f.
  *
  local  cky := strZero(dodZboz->ncisFirmy,5) + ;
                upper(cenZboz->ccisSklad)     + ;
                upper(cenZboz->csklPol)       + '01'

  IF cAlias = 'DodZboz'
    IF ::drgDialog:parent:formName = 'SKL_CenZboz_Scr'
      * JS 6.11.2012
      cfilter := "ccisSklad = '%%' .and. csklPol = '%%' .and. ncisFirmy > 0"
      filter  := format( cfilter, { cenZboz->ccisSklad, cenZboz->csklPol } )

    ELSEIF ::drgDialog:parent:formName = 'SKL_DodTerm_Scr'

      cFilter := "StrZero( nCisFirmy, 5) = '%%' .and. Upper(cCisSklad) = '%%' .and. Upper(cSklPol) = '%%'"
      aFilter := { StrZero(DodTerm->nCisFirmy, 5), Upper(DodTerm->cCisSklad), Upper(DodTerm->cSklPol)}
      Filter  := Format( cFilter, aFilter )
    ENDIF
    dodZboz->( ads_setAof( filter ), dbgoTop() )

  ELSEIF cAlias = 'PVPITEM'
    if( empty(pvpItem->( ads_getAof())), nil, pvpItem->(ads_clearAof()) )

    pvpItem->( ordSetFocus( 'PVPITEM23'), dbsetScope(SCOPE_BOTH, cky), dbgotop())

    if .not. pvpItem->( eof())
      if .not. empty( ::dprijemOD) .and. ( ::dprijemOD <= ::dprijemDO )
        cfilter  := "ddatPvp >= '%%' .and. ddatPvp <= '%%'"
         filter  := format( cFilter, { dtos(::dPrijemOd), dtos(::dPrijemDo) } )
        pvpItem->(ads_setAof( filter), dbgoTop() )
      endif
    endif
  endif

RETURN .T.


** HIDDEN **********************************************************************
********************************************************************************
METHOD SKL_DODZBOZ_CRD:FIRMY_SEL( oDlg)
  LOCAL oDialog, nExit, cKey
  LOCAL Value := ::dm:get('DodZboz->nCisFirmy')
  LOCAL lOK := ( !Empty(value) .and. FIRMY->( dbSEEK( Value,,'FIRMY1')) )

  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::drgDialog  MODAL DESTROY EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set( 'DodZboz->nCisFirmy', Firmy->nCisFirmy )
    ::dm:set( 'DodZboz->cNazev'   , Firmy->cNazev )
    ::dm:refresh()
  ENDIF
RETURN lOK

********************************************************************************
*
* Založení nového dodavatele pro daný Klíè zboží pøi pøíjmu
*===============================================================================
FUNCTION SKL_DodZboz_Modi( cKatcZbo )
  Local cKey := StrZero( PVPHEAD->nCisFirmy, 5) + ;
                Upper( PVPITEM->cCisSklad) + Upper( PVPItem->cSklPol )

***  DEFAULT cKatcZbo TO CenZboz->cKatcZbo
  DEFAULT cKatcZbo TO pvpItem->cKatcZbo

  * Pouze pøíjmy se zadaným èíslem dodavatele
  IF PVPHEAD->nKarta <= 199 .and. PVPHEAD->nCisFirmy > 0
    If DodZboz->( dbSeek( cKey,,'DODAV6'))
      If ReplRec( 'DodZboz')
         if( .not. empty(ckatCZbo), DodZboz->ckatCZbo := ckatCZbo, nil )
         DodZboz->nCenanZBO := PVPItem->nCenNapDOD
         DodZboz->nCenNakZM := PVPItem->nCenNaDoZM
         DodZboz->cZkratMeny:= PVPItem->cZahrMena
         DodZboz->dDatPNak  := PVPHead->dDatPVP
         DodZboz->( dbUnlock())
      EndIf
    Else
      If AddRec( 'DodZboz' )
         DodZboz->nKlicNAZ  := PVPItem->nKlicNAZ
         DodZboz->cCisSklad := PVPItem->cCisSklad
         DodZboz->cSklPol   := PVPItem->cSklPol
         dodZboz->cnazZbo   := cenZboz->cnazZbo
         DodZboz->cKatcZBO  := cKatcZBO
         DodZboz->nCisFirmy := PVPHead->nCisFirmy
         DodZboz->cNazev    := SeekFirma( PVPHead->nCisFirmy, 'cNazev' )
         DodZboz->nCenanZBO := PVPItem->nCenNapDOD
         DodZboz->dDatPNak  := PVPHead->dDatPVP
         DodZboz->cNazDod1  := CenZboz->cNazZbo
         DodZboz->cNazDod2  := CenZboz->cNazZbo2
         DodZboz->nCenNakZM := PVPItem->nCenNaDoZM
         DodZboz->cZkratMeny:= PVPItem->cZahrMena
         DodZboz->( dbUnlock())
       EndIf
    EndIf

    if firmy->(dbseek( PVPHEAD->nCisFirmy,,'FIRMY1' ))
      If AT( 'DO', Firmy->cObVzth ) == 0
         If ReplRec( 'Firmy')
            Firmy->cObVzth := AllTrim( Firmy->cObVzth ) + 'DO'
            Firmy->( dbUnlock())
         EndIf
      EndIf
    endif

  ENDIF

RETURN Nil