*
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"

#include "DRGres.Ch'
#include "XBP.Ch"

#define   CRD_edt     1    // základní editaèní karta
#define   CRD_pvp     2    // editace ve skladových pohybech

********************************************************************************
* SKL_VYRCIS_CRD
********************************************************************************
CLASS SKL_VYRCIS_CRD FROM drgUsrClass
EXPORTED:
  VAR     nModCRD, cTypEvid
  VAR     cText1,cText2,cText3,cText4,cText5,cText6,cText7,cText8,cText9
  VAR     nZarukaT   , nZarukaR
  VAR     nKonZarukaD, nKonZarukaT, nKonZarukaR
  VAR     lastEditField
  * pro CRD_pvp
  VAR     isNewPVP, isPrijem, isVydej, nSumMnoz, nSumMnozP, nSumMnozV, nSumZust,;
          nSumMnozVD, nMnozPrDod

  METHOD  Init, Destroy, drgDialogStart, drgDialogEnd, eventHandled, tabSelect
  METHOD  ItemMarked, postValidate, postLastField, post_bro_colourCode

HIDDEN
  VAR     dc, dm, df, tabNum, broCIS, tabPM, RecNO, lNewRec, nRecOrg, parentForm
  METHOD  sumColumn, setFilter
  METHOD  ZarukaCMP, newPoradi, showGroups
ENDCLASS

********************************************************************************
METHOD SKL_VYRCIS_CRD:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open( 'VyrCIS',,,,,'VyrCIS_1')
  *
  ::nModCRD := Coalesce( parent:cargo_usr, CRD_edt)
  *
  ::lNewRec  := .F.
  ::cTypEvid := Upper( CenZBOZ->cVyrCis)
  ::nZarukaT := ::nKonZarukaD := ::nKonZarukaT := 0
  ::nZarukaR := ::nKonZarukaR := 0.00
  ::nMnozPrDod := 0.00
  ::lastEditField := 'VyrCis->cVady'
  ::parentForm := parent:parent:formName
  if ::parentForm = 'skl_vyrcis_2_scr'
    ::nRecOrg := VYRCIS->( RecNo())
  endif
  *
  if ::nModCRD = CRD_pvp
    ::isNewPVP   := ( parent:cargo = xbeK_INS )
    ::isPrijem   := ( PVPItemWW->nTypPoh =  1)
    ::isVydej    := ( PVPItemWW->nTypPoh = -1)
    ::nSumMnoz   := 0.00   // Mn. editované ( pøíjem, výdej)
    ::nSumMnozP  := 0.00   // Mn.pøijaté CELKEM
    ::nSumMnozV  := 0.00   // Mn.vydané CELKEM
    ::nSumZust   := 0.00   // Zùstatek CELKEM
    ::nSumMnozVD := 0.00   // Mn.vydané dokladem
    ::nMnozPrDod := PVPItemWW->nMnozPrDod
    *
    drgDBMS:open( 'VyrCISV')
  endif
RETURN self

********************************************************************************
METHOD SKL_VYRCIS_CRD:drgDialogStart(drgDialog)
  Local n, oVar, cText, cOldXbp
  Local aPopis := {'VyrCis->cPopis1', 'VyrCis->cPopis2', 'VyrCis->cPopis3',;
                   'VyrCis->cPopis4', 'VyrCis->cPopis5', 'VyrCis->nValue1',;
                   'VyrCis->nValue2', 'VyrCis->nValue3', 'VyrCis->nValue4'}
  *
*  if( ::nModCRD = CRD_pvp, _clearEventLoop(.t.), nil )
  *
  ::dc     := drgDialog:dialogCtrl
  ::dm     := drgDialog:dataManager
  ::df     := drgDialog:oForm
  ::broCIS := ::dc:oBrowse[1]:oXbp
  ::tabPM  := drgDialog:oForm:tabPageManager
  *
  ColorOfTEXT( ::dc:members[1]:aMembers )
  ::ShowGroups()
  ::setFilter()
  ::itemMarked()
  ::tabNum := 1
  ::sumColumn()
  if ::nModCRD = CRD_edt
    IsEditGET( { 'M->nKonZarukaD', 'M->nKonZarukaT', 'M->nKonZarukaR'  }, ::drgDialog, .F. )
  else
    IsEditGET( {'VyrCis->nZust'  ,;
                'M->nKonZarukaD' , 'M->nKonZarukaT', 'M->nKonZarukaR',;
                'VyrCis->nDoklad', 'VyrCis->dDatPrijem', 'VyrCis->nDokladV', 'VyrCis->dDatProdej'  }, ::drgDialog, .F. )
  endif
  *
  IF ::cTypEvid = 'A'
    IsEditGET( {'VyrCis->nMnoz'}, ::drgDialog, .F. )
  ENDIF
  *
  FOR n := 1 TO LEN( aPopis)
    cText := 'cText' + Str( n, 1)
    ::&cText := SysConfig( 'Sklady:' + cText )
    oVar :=  ::dm:has( aPopis[ n]):oDrg
    oVar:isEdit := !EMPTY( ::&cText)
    IF( oVar:isEdit, oVar:oXbp:show(), oVar:oXbp:hide() )
    ::lastEditField := IF( oVar:isEdit, oVar:name, ::lastEditField )
  NEXT
  ::dm:refresh()
  *
  if ::parentForm = 'skl_vyrcis_2_scr'
    ::tabNum := 2
    ::tabPM:toFront(2)
  endif
  cOldXbp := SetAppFocus(::broCIS)

RETURN

********************************************************************************
METHOD SKL_VYRCIS_CRD:drgDialogEnd(drgDialog)
  VYRCIS->( mh_ClrFilter())
  if SELECT( 'VYRCISV') <> 0
    VYRCISV->( dbCloseArea())
  endif
RETURN self

********************************************************************************
METHOD SKL_VYRCIS_CRD:eventHandled(nEvent, mp1, mp2, oXbp)
  Local cKey, aRec := {}, lOk, n
*
  IF nEvent = xbeP_Keyboard
    IF mp1 == xbeK_ESC
      IF ::tabNum = 1
        IF ::nModCRD = CRD_pvp
          if  ::nSumMnoz < PVPITEMww->nMnozPrDod
            drgMsgBox(drgNLS:msg( 'Bylo zaevidováno menší množství než je na dokladu [ & ] !', PVPITEMww->nMnozPrDod))
          endif
        ENDIF
        PostAppEvent(xbeP_Close,drgEVENT_QUIT,, ::drgDialog:dialog)

      ELSEIF ::tabNum = 2
        if ::parentForm = 'skl_vyrcis_2_scr'
          PostAppEvent(xbeP_Close,drgEVENT_QUIT,, ::drgDialog:dialog)
        else
          ::tabPM:toFront(1)
          IF ::lNewRec
            IF( IsNull( ::RecNO), nil, VYRCIS->( dbGoTO(::RecNO )) )
            ::broCIS:refreshCurrent()
          ELSE
            ::broCIS:refreshALL()
          ENDIF
          ::itemMarked()
          ::lNewRec := .F.
          SetAppFocus( ::broCIS)
          RETURN .T.
        endif
      ENDIF
    ENDIF

  ENDIF
*
  DO CASE
    CASE nEvent = drgEVENT_APPEND
      *
      if ::parentForm = 'skl_vyrcis_2_scr'
        * Nad screenem dle výrobních èísel je povolena pouze oprava
        return .t.
      endif
      IF ::nModCRD = CRD_pvp
        if ::isPrijem
        * U typu A neumožnit poøízení další pol., je-li již zaevidováno mn. jako na dokladu
*            if (::cTypEvid = 'A' .and. ::nSumMnoz >= PVPITEMww->nMnozPrDod)
          if ::nSumMnozP >= PVPITEMww->nMnozPrDod
            drgMsgBox(drgNLS:msg( 'Nelze zaevidovat vìtší množství než je na dokladu [ & ] !', PVPITEMww->nMnozPrDod))
            RETURN .T.
          endif
        endif
        *
        if ::isVydej
          if ::cTypEvid = 'A'
             RETURN .T.              // výdej se realizuje jinak a jinde ( ozn.vydaných výr.èísel)
          elseif ::cTypEvid = 'B'
             return .t.              // výdej pøes klávesu enter
          elseif ::cTypEvid = 'C'
          ENDIF
        endif
      ENDIF
      *
      ::lNewRec := .T.
      IsEditGET( {'VYRCIS->cVyrobCis' }, ::drgDialog, .T. )
      ::RecNO := VYRCIS->( RecNO())
      ::tabPM:toFront(2)
      ::dm:refreshAndSetEmpty('VYRCIS')
      ::df:setNextFocus('VYRCIS->cVyrobCis')
      ::dm:set( 'VyrCis->nMnoz', 1 )
      *
      IF ::nModCRD = CRD_pvp
        if ::isPrijem
          ::dm:set( 'VYRCIS->nDoklad'   , PVPITEMww->nDoklad )
          ::dm:set( 'VYRCIS->dDatPrijem', PVPITEMww->dDatPVP )
        endif
      ENDIF

    CASE nEvent = drgEVENT_EDIT
      *
      ::lNewRec := .F.
      IsEditGET( {'VYRCIS->cVyrobCis' }, ::drgDialog, .F. )
      ::tabPM:toFront(2)
      ::df:setNextFocus( IF( (::cTypEvid = 'A'), 'VYRCIS->nZaruka' ,'VYRCIS->nMnoz'),, .T.)
      ::ZarukaCMP( ::dm:get( 'VYRCIS->nZaruka'), ::dm:get( 'VYRCIS->dDatPrijem'), .T. )
      *
      IF ::nModCRD = CRD_pvp
        if ::isVydej
          if ::cTypEvid = 'B'
            ::dm:set( 'VYRCIS->nDokladV'  , PVPITEMww->nDoklad )
            ::dm:set( 'VYRCIS->dDatProdej', PVPITEMww->dDatPVP )
            cKey := strzero( PVPITEMww->nDoklad, 10) + strzero( PVPITEMww->nOrdItem,5) + Upper( VYRCIS->cVyrobCis)
            ::dm:set( 'VyrCis->nMnoz', IF( VyrCISV->( dbSeek(cKey,, 'C_VYRCV3')), VyrCisV->nMnozV, 0) )
          endif
        endif
      ENDIF

    CASE nEvent = drgEVENT_DELETE

      if ::nModCRD = CRD_edt
        IF drgIsYESNO(drgNLS:msg('Zrušit záznam ...;;' + ;
                                 'Opravdu požadujete zrušení záznamu o výrobním èísle ?') )
          cKey := Upper( VYRCIS->cCisSklad) + Upper( VYRCIS->cSklPol) + Upper(VYRCIS->cVyrobCis)
          VYRCISV->( ordSetFocus( 'C_VYRCv2'),;
                     mh_SetScope( cKey)      ,;
                     dbEval( {|| AADD( aRec, VYRCISV->(RecNo()))  } ),;
                     mh_ClrScope() )
          lOk := IF( LEN( aRec) = 0, .T., VYRCISV->( sx_RLOCK( aRec)) )
          IF VYRCIS->( dbRLock()) .and. lOK
            FOR n := 1 TO LEN( aRec)
              VYRCISV->( dbGoTO( aRec[ n]), dbDelete() )
            NEXT
            VYRCIS->( dbDelete())
          ENDIF
          VYRCISV->( dbUnlock())
          VYRCIS->( dbUnlock())
          ::broCIS:refreshAll()
          ::itemMarked()
          ::sumcolumn()
        ENDIF
      endif

      */
    CASE nEvent = drgEVENT_SAVE
      ::postLastField()

    CASE nEvent = drgEVENT_QUIT
      /*
      if  ::nSumMnoz < PVPITEMww->nMnozPrDod
        drgMsgBox(drgNLS:msg( 'Bylo zaevidováno menší množství než je na dokladu [ & ] !', PVPITEMww->nMnozPrDod))
      endif
      */
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD SKL_VYRCIS_CRD:ItemMarked()

  * pøi volbì fitru ( zobraz vše) musí u výdeje znovu nastavit filter
  IF ::nModCRD = CRD_pvp
    if ::isVydej
      if ::cTypEvid = 'A'
        if empty( VYRCIS->( ads_GetAOF()) )
          ::setFilter()
          ::broCIS:refreshAll()
        endif
      endif
      *
    endif
  ENDIF
RETURN SELF

********************************************************************************
METHOD SKL_VYRCIS_CRD:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
  IF ::tabNUM = 2 .and. !::lNewRec
    PostAppEvent(drgEVENT_EDIT,,, ::broCIS)
  ENDIF

RETURN .T.

********************************************************************************
METHOD SKL_VYRCIS_CRD:postVALIDATE(oVar)
  Local lOK := .T. , nRecNo
  Local xVal := oVar:get(), cName := oVar:Name, cKey, nPos, nVal
  Local lChanged := (::lNewRec .or. oVar:changed() )
  Local nEvent := mp1 := mp2 := nil

  nEvent := LastAppEvent(@mp1,@mp2)
  *
  DO CASE
  *
  Case cName = 'VyrCis->cVyrobCis'
    *
    IF lChanged
      IF ( nEvent = xbeP_Keyboard  )
        * v insertu chce šipkou nahoru, tedy mimo záložku
        IF( mp1 = xbeK_UP  .and. ::lNewRec) ; RETURN .F. ; ENDIF
        * v insertu dá ESC, takže nevalidovat
        IF( mp1 = xbeK_ESC .and. ::lNewRec) ; RETURN .T. ; ENDIF
      ENDIF
      * povinný údaj
      IF !( lOK := ControlDUE( oVar, .T.))
        RETURN .F.
      ENDIF
      * duplicitní údaj
      cKey := Upper( CenZBOZ->cCisSklad) + Upper( CenZBOZ->cSklPol) + Upper( xVal)
      IF VYRCIS_1->( dbSeek( cKey,, 'C_VYRC1'))
        lOK := .F.
        drgMsgBox(drgNLS:msg( 'Duplicitní výrobní èíslo !'))
      ENDIF
      * evidence C - výr.è. se zadává ve tvaru intervalu a z nìj je pak vypoèteno a
      *              nastaveno množství : pø.   121-126  , nMnoz := 6
      IF lOK .and. ::cTypEvid = 'C'
        IF (( nPos := At( '-', xVal)) > 0 )
          nVal := VAL( SubStr( xVal, nPos+1 )) - ;
                  VAL( SubStr( xVal, 1, nPos -1)) + 1
          ::dm:set( 'VyrCis->nMnoz', nVal )
        ENDIF
      ENDIF
    ENDIF

  CASE cName = 'VYRCIS->nMnoz'
    IF lChanged
      IF ( nEvent = xbeP_Keyboard )
        IF( !::lNewRec .and.( mp1 = xbeK_UP .or. mp1 = xbeK_SH_TAB)) ; RETURN .F.  ;  ENDIF
      ENDIF
      *
      IF ::cTypEvid = 'B'
*        ::dm:set( 'VyrCis->nZust', xVal )
        IF ::nModCRD = CRD_pvp
          if ::isPrijem
            if (::nSumMnozP + xVal > PVPITEMww->nMnozPrDod)
              drgMsgBox(drgNLS:msg( 'Nelze zaevidovat vìtší pøijaté množství než je na dokladu [ & ] !', PVPITEMww->nMnozPrDod))
              lOK := .F.
            endif
          endif
          if ::isVydej
*            if (::nSumMnozVD + xVal > PVPITEMww->nMnozPrDod)
            if (::nSumMnozVD - oVar:initvalue + xVal > PVPITEMww->nMnozPrDod)
              drgMsgBox(drgNLS:msg( 'Nelze zaevidovat vìtší vydané množství než je na dokladu [ & ] !', PVPITEMww->nMnozPrDod))
              lOK := .F.
            else
              ::dm:set( 'VyrCis->nZust', VyrCis->nMnozP - xVal )
            endif
          endif
        ENDIF
      ENDIF
    ENDIF

  CASE cName = 'VYRCIS->nZaruka'
    ::ZarukaCMP( xVal, ::dm:get( 'VYRCIS->dDatPrijem'),.T.)

  CASE cName = 'M->nZarukaT'
    ::ZarukaCMP( xVal * 7, ::dm:get( 'VYRCIS->dDatPrijem'),.T.)

  CASE cName = 'M->nZarukaR'
    ::ZarukaCMP( INT(xVal * 365), ::dm:get( 'VYRCIS->dDatPrijem'),.T.)
  *
  CASE cName = 'VYRCIS->dDatPrijem'
    if( empty( dtos(xVal)))
      ::ZarukaCMP( 0, xVal, .T.)
    else
      ::ZarukaCMP( ::dm:get( 'VYRCIS->nZaruka'), xVal, .T.)
    endif

  CASE cName = 'VYRCIS->dDatProdej'
    if( empty( dtos(xVal)))
      ::ZarukaCMP( 0, xVal, .T.)
    else
      ::ZarukaCMP( ::dm:get( 'VYRCIS->nZaruka'), xVal, .T.)
    endif

  CASE cName = ::lastEditField
    if ( nEvent = xbeP_Keyboard .and. mp1 = xbeK_ENTER)
      PostAppEvent(drgEVENT_SAVE,,, oVar:oDrg:oXbp)
    endif
  ENDCASE

RETURN lOK

********************************************************************************
METHOD SKL_VYRCIS_CRD:postLastField()
  Local nRec, lExistB, cKey, nSuma := 0
  *
*  IF ::nModCRD = CRD_edt   // Editaèní karta nad SCR
    IF( ::lNewRec, VYRCIS->( dbAppend()), nil )
    IF VYRCIS->( dbRLock())
      ::dm:save()
      VYRCIS->cCisSklad  := CenZboz->cCisSklad
      VYRCIS->cSklPol    := CenZboz->cSklPol
      VYRCIS->nPoradi    := if( ::lNewRec, ::newPoradi(), VYRCIS->nPoradi )
      IF ::nModCRD = CRD_pvp
        IF ::isPrijem
          VYRCIS->nDoklad    := PVPITEMww->nDoklad
          VYRCIS->nOrdItemP  := PVPITEMww->nOrdItem
          VYRCIS->dDatPrijem := PVPITEMww->dDatPVP
          VYRCIS->nMnozP     := VYRCIS->nMnoz
          VYRCIS->nZust      := VYRCIS->nMnoz
*          VYRCIS->nMnoz      := 0.00
        ENDIF
        *
        IF ::isVydej
          VYRCIS->nDokladV   := PVPITEMww->nDoklad
          VYRCIS->nOrdItemV  := PVPITEMww->nOrdItem
          VYRCIS->dDatProdej := PVPITEMww->dDatPVP
          VYRCIS->nMnozV     := VYRCIS->nMnoz
          IF ::cTypEvid = 'B'
            cKey := Upper( VYRCIS->cCisSklad) + Upper( VYRCIS->cSklPol) + Upper( VYRCIS->cVyrobCis) +;
                           STRZERO(VYRCIS->nDokladV,10) +STRZERO(VYRCIS->nOrdItemV,5)
            lExistB := VyrCISV->( dbSeek(cKey,, 'C_VYRCV2'))
            If (lOk := If( lExistB, ReplREC( 'VyrCisV'), AddREC('VyrCisV') ))
              mh_copyFld( 'VYRCIS', 'VYRCISV' )
              VyrCisV->( dbUnlock())
            EndIf
            *
            cKey := Upper( VYRCIS->cCisSklad) + Upper( VYRCIS->cSklPol) + Upper( VYRCIS->cVyrobCis)
            VYRCISV->( ordSetFocus( 'C_VYRCV2') ,;
                       mh_SetScope( cKey)       ,;
                       dbEval( {|| nSuma += VyrCisV->nMnozV } ) ,;
                       mh_ClrScope() )
            VYRCIS->nMnozV := nSuma
            VYRCIS->nZust  := VYRCIS->nMnozP - nSuma
            VYRCIS->nZust  := MAX( VYRCIS->nZust, 0 )
*            VYRCIS->nMnoz  := 0.00
          ENDIF
        ENDIF
        *
        IF ::cTypEvid $ 'AC'
          VYRCIS->nZust  := VYRCIS->nMnoz - VYRCIS->nMnozV
        /*
        ELSEIF ::cTypEvid = 'B'
          cKey := Upper( VYRCIS->cCisSklad) + Upper( VYRCIS->cSklPol) + ;
                         STRZERO(VYRCIS->nDokladV,10) +STRZERO(VYRCIS->nOrdItemV,5)
          lNewB := VyrCISV->( dbSeek(cKey,, 'C_VYRCV1'))
          mh_copyFld( 'VYRCIS', 'VYRCISV', lNewB)
         */
        ENDIF
      ENDIF
      *
      mh_WrtZmena( 'VYRCIS', ::lNewRec )
      VYRCIS->( dbUnlock())
      *
*      ::lNewRec := .F.
      ::broCIS:refreshAll()
      ::tabPM:toFront(1)
      *
      ::sumcolumn()
      if ::lNewRec
        ::broCIS:goBottom()
        ::broCIS:refreshAll()
      endif
      ::lNewRec := .F.
      ::dm:refresh()
      *
    ENDIF

*  ELSEIF ::nModCRD = CRD_pvp   // Editaèní karta v pohybech

*  ENDIF
  *
RETURN .T.

********************************************************************************
METHOD SKL_VYRCIS_CRD:destroy()
  ::drgUsrClass:destroy()
  *
  ::cText1 := ::cText2 := ::cText3 := ::cText4 := ::cText5 := ;
  ::cText6 := ::cText7 := ::cText8 := ::cText9 := ;
  ::nZarukaT := ::nZarukaR := ::nKonZarukaD := ::nKonZarukaT := ::nKonZarukaR := ;
  ::dc := ::dm := ::tabNum := ::broCIS := ::tabPM := ::RecNO := ;
  ::lNewRec := ::cTypEvid := ::isNewPVP := ::isPrijem := ::isVydej := ::nSumMnoz := ;
  ::nSumMnozP := ::nSumMnozV := ::nSumZust := ::nSumMnozVD := ;
  NIL
RETURN self

* Oznaèení/Odznaèení pøi výdeji
********************************************************************************
METHOD SKL_VYRCIS_CRD:post_bro_colourCode()
  Local  bro := ::dc:oBrowse[1], nRec := VYRCIS->(RecNo())
  Local  arselect := bro:arselect

  IF ::nModCRD = CRD_pvp
    if ::isVydej .and. ::cTypEvid = 'A'
      if VYRCIS->( RLock())
        if (npos := ascan(arselect, nRec)) = 0
          if ::nSumMnozV + VYRCIS->nMnoz > PVPITEMww->nMnozPrDod
            drgMsgBox(drgNLS:msg( 'Nelze zaevidovat vìtší množství než je na dokladu [ & ] !', PVPITEMww->nMnozPrDod))
            return .T.
          endif
          aadd(arselect, nRec)
          VYRCIS->nDokladV   := PVPITEMww->nDoklad
          VYRCIS->dDatProdej := PVPITEMww->dDatPVP
          VYRCIS->nOrdItemV  := PVPITEMww->nOrdItem
          VYRCIS->nMnozV     := VYRCIS->nMnoz
          ::dm:set('VYRCIS->nDokladV'  , PVPITEMww->nDoklad)
          ::dm:set('VYRCIS->dDatProdej', PVPITEMww->dDatPVP)
        else
          Aremove(arselect, npos )
          VYRCIS->nDokladV   := 0
          VYRCIS->nOrdItemV  := 0
          VYRCIS->dDatProdej := CtoD( '  .  .  ')
          VYRCIS->nMnozV     := 0
          ::dm:set('VYRCIS->nDokladV'  , 0 )
          ::dm:set('VYRCIS->dDatProdej', CtoD( '  .  .  '))
        endif
        VYRCIS->nZust  := VYRCIS->nMnoz - VYRCIS->nMnozV
        VYRCIS->( dbUnlock())
        ::dc:oBrowse[1]:arselect := arselect
        ::dm:refresh()
      endif
      ::sumColumn()
    endif
  ELSE
    RETURN .F.  // oznaèí standardnì
  ENDIF
RETURN .t.

** HIDDEN **********************************************************************
METHOD SKL_VyrCis_CRD:ZarukaCMP( nDNY, dDate, lValid)

   DEFAULT lValid TO .F.
  ::nZarukaT := INT( nDny / 7)
  ::nZarukaR := ROUND( nDny / 365, 2 )
  * do konce záruky
  ::nKonZarukaD := MAX( nDny - ( Date() - dDate), 0 )
  ::nKonZarukaT := MAX( INT( ::nKonZarukaD / 7)            , 0 )
  ::nKonZarukaR := MAX( ROUND( ::nKonZarukaD / 365, 2 )    , 0 )
  *
  IF lValid
    ::dm:set( 'VYRCIS->nZaruka', nDNY       )
    ::dm:set( 'M->nZarukaT'    , ::nZarukaT )
    ::dm:set( 'M->nZarukaR'    , ::nZarukaR )
    ::dm:set( 'M->nKonZarukaD' , ::nKonZarukaD )
    ::dm:set( 'M->nKonZarukaT' , ::nKonZarukaT )
    ::dm:set( 'M->nKonZarukaR' , ::nKonZarukaR )
  ENDIF
  *
  ::dm:refresh()

RETURN self

** HIDDEN **********************************************************************
METHOD SKL_VYRCIS_CRD:setFilter()
  Local Filter, cFilter, aFilter, nGoTo, aRecs := {}

  DO CASE
  CASE ::nModCRD = CRD_edt
    cFilter := "Upper(cCisSklad) = '%%' .and. Upper(cSklPol) = '%%'"
    aFilter := { Upper(CENZBOZ->cCisSklad), Upper(CENZBOZ->cSklPol)}
    Filter  := Format( cFilter, aFilter )
    if ::parentForm = 'skl_vyrcis_2_scr'
      nGoTo := ::nRecOrg
    endif
    VYRCIS->( mh_SetFilter( Filter, nGoTo))

  CASE ::nModCRD = CRD_pvp
    if ::isPrijem
      cFilter := "Upper(cCisSklad) = '%%' .and. Upper(cSklPol) = '%%' .and. StrZero( nDoklad, 10)= '%%' .and. StrZero( nOrdItemP, 5)= '%%'"
      aFilter := { Upper(CENZBOZ->cCisSklad), Upper(CENZBOZ->cSklPol), StrZero( PVPITEMww->nDoklad,10), StrZero( PVPITEMww->nOrdItem,5) }
      Filter  := Format( cFilter, aFilter )
      VYRCIS->( mh_SetFilter( Filter))
    elseif ::isVydej
      if ::isNewPVP
        cFilter := "Upper(cCisSklad) = '%%' .and. Upper(cSklPol) = '%%' .and. ( nZust > 0 .or. StrZero( nDokladV, 10)= '%%')"// .and. StrZero( nDoklad, 10)= '%%'"
  *                 IF( ::isPrijem, "StrZero( nDoklad, 10)", "StrZero( nDokladV, 10)") + " = '%%'"
        aFilter := { Upper(CENZBOZ->cCisSklad), Upper(CENZBOZ->cSklPol), StrZero( PVPITEMww->nDoklad,10) }
        Filter  := Format( cFilter, aFilter )
        VYRCIS->( mh_SetFilter( Filter))
      else
        IF ::cTypEvid = 'A'
          cFilter := "Upper(cCisSklad) = '%%' .and. Upper(cSklPol) = '%%' .and. StrZero( nDokladV, 10)= '%%' .and. StrZero( nOrdItemV, 5)= '%%'"
          aFilter := { Upper(CENZBOZ->cCisSklad), Upper(CENZBOZ->cSklPol), StrZero( PVPITEMww->nDoklad,10), StrZero( PVPITEMww->nOrdItem,5) }
          Filter  := Format( cFilter, aFilter )

          VYRCIS->( mh_SetFilter( Filter))
          VYRCIS->( dbEval( {|| aadd( aRecs, VyrCis->( RecNo()))   }))
          ::dc:oBrowse[1]:arselect := aRecs
        ENDIF
        cFilter := "Upper(cCisSklad) = '%%' .and. Upper(cSklPol) = '%%' .and. ( nZust > 0 .or. StrZero( nDokladV, 10)= '%%')"
        aFilter := { Upper(CENZBOZ->cCisSklad), Upper(CENZBOZ->cSklPol), StrZero( PVPITEMww->nDoklad,10) }
        Filter  := Format( cFilter, aFilter )
        VYRCIS->( mh_SetFilter( Filter))
        * VyRCISw obsahuje originál VYRCIS
        VYRCIS->( dbEval( {|| mh_copyFld( 'VYRCIS', 'VYRCISw', .t., .t.) }),;
                  dbGoTop()  )
      endif
    endif

  ENDCASE

RETURN .t.

** HIDDEN **********************************************************************
METHOD SKL_VYRCIS_CRD:sumColumn()
  LOCAL nRec := VYRCIS->( RecNo()), nPos, nMnoz := 0.0000, aItems, x

  ::nSumMnoz := ::nSumMnozP := ::nSumMnozV := ::nSumZust := ::nSumMnozVD := 0.00
  VYRCIS->( dbGoTOP(),;
            dbEVAL( {|| ::nSumMnoz   += VYRCIS->nMnoz    ,;
                        ::nSumMnozP  += VYRCIS->nMnozP   ,;
                        ::nSumMnozV  += VYRCIS->nMnozV   ,;
                        ::nSumZust   += VYRCIS->nZust    ,;
                        ::nSumMnozVD += FMnozV()       }),;
            dbGoTop() )

  aItems := { {'VYRCIS->nMnoz' , ::nSumMnoz  },;
              {'VYRCIS->nMnozP', ::nSumMnozP },;
              {'VYRCIS->nMnozV', ::nSumMnozV },;
              {'VYRCIS->nZust' , ::nSumZust  },;
              {'FMnozV()'      , ::nSumMnozVD} }

  FOR x := 1 TO LEN( aItems)
    IF ( nPos := AScan( ::dc:oBrowse[1]:arDef, {|Col| Col[ 2] = aItems[ x, 1] } ) ) > 0
      ::broCIS:getColumn( nPos):Footing:hide()
      ::broCIS:getColumn( nPos):Footing:setCell(1, aItems[ x, 2] )
      ::broCIS:getColumn( nPos):Footing:show()
    ENDIF
  NEXT
  ::dm:refresh()
  *
RETURN self

*HIDDEN*************************************************************************
METHOD SKL_VYRCIS_CRD:NewPoradi()
  Local nPoradi := 0
  Local cScope := Upper( CENZBOZ->cCisSklad) + Upper( CENZBOZ->cSklPol )

  VyrCis_1->( AdsSetOrder( 8))
  VyrCIS_1->( mh_SetSCOPE( cScope), dbGoBottom() )
    nPoradi := VyrCis_1->nPoradi + 1
  VyrCIS_1->( mh_ClrSCOPE())
RETURN nPoradi

*HIDDEN*************************************************************************
METHOD SKL_VYRCIS_CRD:ShowGroups()
  Local n, members := ::drgDialog:oForm:aMembers

  FOR n := 1 TO LEN( members)
    IF IsMemberVar( members[n],'groups') .and. !EMPTY( members[n]:groups) .and. ! ( 'clr' $ members[n]:groups)
      IF (::cTypEvid $ members[n]:groups)
        members[n]:oXbp:show()
        IF( members[n]:ClassName() $ 'drgStatic,drgText', NIL, members[n]:isEdit := .T.)
      ELSE
        members[n]:oXbp:hide()
        IF( members[n]:ClassName() $ 'drgStatic,drgText', NIL, members[n]:isEdit := .F.)
      ENDIF
    ENDIF
  NEXT

RETURN self

*
*===============================================================================
FUNCTION SKL_VyrCIS_Modi( nKEY, allRecs)
  Local lOpravaPVP

  DEFAULT allRecs TO .F.
  *
  IF EMPTY( CenZBOZ->cVyrCis)
    RETURN NIL
  ENDIF
  *
  IF nKEY = xbeK_DEL
    if allRECs
      PVPITEMww->( dbGoTop())
      DO WHILE !PVPITEMww->( EOF())
        lOpravaPVP := PVPITEMww->_nRecor > 0
        VyrCIS_Modi( 'PVPITEMww', lOpravaPVP )
        PVPITEMww->(dbSkip())
      ENDDO
    else
*      lOpravaPVP := PVPITEMww->_nRecor > 0
      VyrCIS_Modi( 'PVPITEMww' ) //, lOpravaPVP )
    endif

  ENDIF
RETURN NIL

*
*===============================================================================
FUNCTION VyrCIS_Modi( cAlias, lOprava)
  Local aRECs := {}, isPrijem, isVydej, cKey, nSuma
  Local cScope := Upper( ( cAlias)->cCisSklad) + Upper( ( cAlias)->cSklPol) +;
                  StrZero( ( cAlias)->nDoklad, 10) + StrZero( ( cAlias)->nOrdItem, 5)

  DEFAULT lOprava TO .F.

  If ( isPrijem := ( ( cAlias)->nTypPoh = 1))
    VyrCis->( AdsSetOrder( 2))
    VYRCIS->( mh_SetScope( cScope))
    IF lOprava
    ELSE
      VyrCis->( dbEval( {|| DelRec( 'VyrCis') }))
    ENDIF
    VYRCIS->( mh_ClrScope())

  ElseIf ( isVydej := ( ( cAlias)->nTypPoh = -1))
    VyrCis->( AdsSetOrder( 3))
    IF lOprava
      VyrCisw->( AdsSetOrder( 3))
      cScope := Upper( ( cAlias)->cCisSklad) + Upper( ( cAlias)->cSklPol)
      VYRCISw->( mh_SetScope( cScope))
      Do While ! VYRCISw->( eof())
        VyrCis->( dbGoTo( VyrCisw->_nRecOr ))
        If ReplRec( 'VyrCis')  ; VyrCis->nDokladV   := VyrCisw->nDokladV
                                 VyrCis->nOrdItemV  := VyrCisw->nOrdItemV
                                 VyrCis->dDatProdej := VyrCisw->dDatProdej
                                 VyrCis->nMnozV     := VyrCisw->nMnozV
                                 VYRCIS->nZust      := VYRCISw->nZust
                                 VYRCIS->( dbUnlock())
        Endif
        VYRCISw->( dbSkip())
      EndDo
      VYRCISw->( mh_ClrScope())

    ELSE    // DELete
      drgDBMS:open( 'VyrCISV')
      VYRCIS->( mh_SetScope( cScope))
      VyrCis->( dbEval( {|| aAdd( aRECs, VyrCis->( RecNo())) }))
      For n := 1 To Len( aRECs )
        VyrCis->( dbGoTo( aRECs[ n] ))
        * VyrCisV
        cKey := Upper((cAlias)->cCisSklad) + Upper((cAlias)->cSklPol) + Upper( VYRCIS->cVyrobCis)
        VYRCISV->( ordSetFocus( 'C_VYRCV2'), mh_SetScope( cKey) )
        nSuma := 0
        DO WHILE !VYRCISV->( Eof())
          if (cAlias)->nDoklad = VYRCISV->nDokladV
            VyrCisV->( dbRLock(), dbDelete())
          else
            nSuma += VyrCisV->nMnozV
          endif
          VYRCISV->( dbSkip())
        ENDDO
        VYRCISV->( dbGoBottom() )
         *
        If ReplRec( 'VyrCis')  ; VyrCis->nDokladV   := VYRCISV->nDokladV    // 0
                                 VyrCis->nOrdItemV  := VyrCisV->nOrdItemV    // 0
                                 VyrCis->dDatProdej := VyrCisV->dDatProdej    // CtoD( '  .  .  ')
                                 VyrCis->nMnozV     := nSuma    //  0
                                 VYRCIS->nZust      := VYRCIS->nMnozP - VYRCIS->nMnozV
                                 VYRCIS->( dbUnlock())
        Endif
        VYRCISV->( mh_ClrScope())
      Next
    ENDIF
    VYRCIS->( mh_ClrScope())
  ENDIF

RETURN NIL

*-------------------------------------------------------------------------------
FUNCTION FMnozV()
  Local nMnozV := 0, cKey

  if SELECT( 'VYRCISV') <> 0
     cKey := strzero( PVPITEMww->nDoklad, 10) + strzero( PVPITEMww->nOrdItem,5) + Upper( VYRCIS->cVyrobCis)
     VyrCisV->( dbSeek( cKey,, 'C_VYRCv3'))
     nMnozV := VyrCisV->nMnozV
  endif

RETURN nMnozV
*/