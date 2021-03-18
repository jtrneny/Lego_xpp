////////////////////////////////////////////////////////////////////////////////
//
//  drgDC20w.PRG
//  modifikace drgDC20 - ponìkud odlišné øízení
//
//  použito - FIR_FIRMY_CRD.FRM
////////////////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"


#define   _menuED   { 'CTRL+P'      , 'ENTER'      , 'F3'            , 'INS'          , 'DEL'          , ;
                      'CTRL+PGUP'   , 'PGUP'       , 'PGDN'          , 'CTRL+PGDN'    , 'CTRL+F'       , ;
                      'CTRL+N'                                                 }
#define   _actionED { drgEVENT_PRINT, drgEVENT_EDIT, drgEVENT_APPEND2, drgEVENT_APPEND, drgEVENT_DELETE, ;
                      drgEVENT_TOP  , drgEVENT_PREV, drgEVENT_NEXT, drgEVENT_BOTTOM , drgEVENT_FIND      }



**
** CLASS for FRM (20w) *********************************************************
CLASS drgDC20w FROM drgDialogController
EXPORTED:
  VAR     aData
  VAR     oaBrowse                                                              // aktivní BROw
  VAR     tabNumber
  VAR     browseOnTabs

  METHOD  init
  METHOD  registerBrowser
  METHOD  browseInFocus
  METHOD  browseRefresh
  METHOD  onItemMarked

  METHOD  eventHandled
  METHOD  chkDuplicates
  METHOD  loadData
  METHOD  saveData

HIDDEN:
*  VAR     tabNumber
  VAR     hasBrowseData
*  VAR     browseOnTabs
  VAR     menuItemCheck

  METHOD  chkMenuItem
  METHOD  registerBrowseOnTabs
  METHOD  postValidateForm

ENDCLASS

//
METHOD drgDC20w:init(oParent)
  ::drgDialogController:init(oParent)
  ::oBrowse        := {}
  ::tabNumber      := 1
  ::hasBrowseData  := .F.
  ::menuItemCheck  := {}
RETURN self


//
METHOD drgDC20w:registerBrowser(oDrgBrowse)
  AAdd(::oBrowse, oDrgBrowse)
RETURN self


//
METHOD drgDC20w:registerBrowseOnTabs()
  LOCAL  nTABs, nIn, onFormIndex, nLASTs
  LOCAL  tabPage := ::members[1]:tabPageManager:members
  LOCAL  dc      := ::members[1]:aMembers
//
  LOCAL  nItem, nSubItem
  LOCAL  oMenuBar      := ::drgDialog:dialog:menuBar(), oITEMs

  // položky MENU pro povolení/zákaz //
  FOR nItem := 1 TO oMenuBar:numItems()
    oITEMs := oMenuBar:getItem(nItem)[1]
    FOR nSubItem := 1 TO oITEMs:numItems()
      IF !IsNIL(oITEMs:getItem(nSubItem)[1])
        IF AScan( _menuED, { |X| X $ UPPER(oITEMs:getItem(nSubItem)[1]) }) <> 0
          AAdd(::menuItemCheck, {oITEMs,nSubItem} )
        ENDIF
      ENDIF
    NEXT
  NEXT

  // první editaèní prvek urèuje dbArea - drgBrowse má :dbArea ostatní :name//
  BEGIN SEQUENCE
    FOR nIn := 1 TO LEN(dc)
      IF dc[nIn]:isEdit .and. !IsNIL(dc[nIn]:name)
        ::dbArea := IF(IsMemberVar(dc[nIn], 'dbArea'), dc[nIn]:dbArea, ;
                                                       SELECT(drgParse(dc[nIn]:name,'-')))
  BREAK
      ENDIF
    NEXT
  END SEQUENCE

  // jednotlivé TABs mohou mít drgBrowse, drgEBrowse //
  ::browseOnTabs := {}
  FOR nIn := 1 TO LEN(tabPage) ;  AAdd(::browseOnTabs, {} ) ;  NEXT

  FOR nTABs := 1 TO LEN(tabPage)
    onFormIndex := tabPage[nTABs]:onFormIndex
    nLASTs      := IF( nTABs +1 > LEN(tabPage), LEN(dc), tabPage[nTABs+1]:onFormIndex)
    FOR nIn := onFormIndex +1 TO nLASTs
      IF Lower(dc[nIn]:className()) $ 'drgbrowse,drgebrowse'
        AAdd( ::browseOnTabs[nTABs], dc[nIn])
      ENDIF
    NEXT
  NEXT
RETURN SELF


method drgDC20w:browseInFocus(lSetTabFocus)
  local  appFocus := SetAppFocus(), pos
  *
  local  inbrow   := .F.

  default lSetTabFocus to .f.

  if(inbrow := (appFocus:className() = 'XbpBrowse'))
    ::oabrowse := appFocus:cargo
  endif
return inbrow


//
METHOD drgDC20w:browseRefresh()
  IF ::oaBrowse != NIL
    ::oaBrowse:oXbp:forceStable()   // refreshAll()
  ENDIF
RETURN

//
METHOD drgDC20w:onItemMarked(oXbp,nPAGE,onEsc)
  LOCAL  nBRo, nCOLn, activeGet
  LOCAL  nextFocus, oACTIVe, oLASTXbp := ::dataManager:drgDialog:lastXbpInFocus
  LOCAL  cFILE
  LOCAL  vars   := ::dataManager:vars:values

  IF Lower(oXbp:ClassName()) $ 'drgbrowse,drgebrowse'
    nPAGE      := 0
    oACTIVe    := oXbp
  ELSEIf IsNIL(nPAGE)
    BEGIN SEQUENCE
      FOR nBRo := 1 TO LEN(::oBrowse)
        FOR nCOLn := 1 TO ::oBrowse[nBRo]:oXbp:colCount
          IF ::oBrowse[nBRo]:oXbp:getColumn(nCOLn) = oXbp
            IF oLASTXbp:ClassName() <> 'XbpBrowse'
              oLASTXbp:setColorBG((drgPP:getPP(drgPP_PP_EDIT1)[2,2]))
            ENDIF
            oACTIVe := ::oBrowse[nBRo]
    BREAK
          ENDIF
        NEXT
      NEXT
    END SEQUENCE
  ELSE                                                                          // XbpTabPage
    IF !IsNIL(nextFocus  := ::oaBrowse:parent:nextFocus)
      oACTIVe    := ::members[1]:aMembers[nextFocus]

      if .not. (Lower(oactive:className()) $ 'drgbrowse,dbrebrowse')

        IF !IsNil(oXbp:cargo) .or. oactive:oxbp:setParent():className() = 'XbpCellGroup'
          cfile := if( .not. isnil(oxbp:cargo), oxbp:cargo:tabBrowse, drgParse(oactive:name,'-'))

          IF( nBro := AScan( ::oBrowse, {|X| X:cFile = cfile })) <> 0
            oACTIVe := ::oBrowse[nBro]
          ENDIF
        ENDIF
      ENDIF
    ENDIF
  ENDIF

  IF IsObject(oACTIVe)
    if Lower(oactive:className()) $ 'drgbrowse,drgebrowse'
      ::oaBrowse                             := oACTIVe
      ::drgDialog:oForm:oLastDrg             := ::oaBrowse
      ::dataManager:drgDialog:lastXbpInFocus := ::oaBrowse:oXbp
      ::dbArea                               := ::oaBrowse:dbArea

      IF IsNUMBER(onEsc)
        ::oaBrowse:refresh()                                                    //27.4.2005//
**        (::dbArea) ->( DbGoTo(::oaBrowse:nRECNO))
        ::loadData()
      ENDIF

      cFILE := ::oaBrowse:cFile
      IF(activeGet := AScan( vars, {|X| IF( IsNIL(x[1]), NIL, cFILE $ UPPER(X[1]) )} )) <> 0
        ::drgDialog:oForm:setNextFocus(vars[activeGet,1])
      ENDIF
    ENDIF
  ENDIF

  IF( IsNIL(nPAGE), NIL, SetAppFocus(::oaBrowse:oXbp))
RETURN

//
METHOD drgDC20w:chkMenuItem()
  LOCAL  dbArea         := ::dbArea
  LOCAL  lastXbpInFocus := ::dataManager:drgDialog:lastXbpInFocus

  // zmìna AKTIVNÍHO souboru //
  IF IsOBJECT(lastXbpInFocus) .and. IsOBJECT(lastXbpInFocus:cargo)
    IF IsMemberVar(lastXbpInFocus:cargo, 'dbArea')
      IF ::dbArea <> lastXbpInFocus:cargo:dbArea
        dbArea := lastXbpInFocus:cargo:dbArea
      ENDIF
    ELSE
      IF ::dbArea <> SELECT(drgParse(lastXbpInFocus:cargo:name,'-'))
        dbArea := SELECT(drgParse(lastXbpInFocus:cargo:name,'-'))
      ENDIF
    ENDIF
    // pokud zmìníme AREA zkontrolujeme a uložíme NE pro pamìové promìnné M-> //
    IF (dbArea <> 0) .and. (::dbArea <> dbArea)
      IF( ::saveData(.F.), (::dbArea := dbArea, ::loadData()), ::dbArea := dbArea )
    ENDIF
  ENDIF

  // aktivní TAB page //
  IF IsOBJECT(::members[1]:tabPageManager:active)
    ::tabNumber := ::members[1]:tabPageManager:active:tabNumber
  ENDIF

  // povolí/zakáže položky MENU a ACTION //
  if (SetAppFocus():className() = 'XbpBrowse')
    ::drgDialog:actionManager:enableActions(_actionED)
    AEval( ::menuItemCheck, {|X| X[1]:enableItem(X[2])} )
  ELSE
    ::drgDialog:actionManager:disableActions(_actionED)
    AEval( ::menuItemCheck, {|X| X[1]:disableItem(X[2])} )
  ENDIF
RETURN


****************************************************************************
* Event handled method for this type of controller.
****************************************************************************
METHOD drgDC20w:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL cargo
  LOCAL nCOL, nROW
  LOCAL aPOSbro

  IF( IsNIL(::browseOnTabs), ::registerBrowseOnTabs(), NIL )


* Call default controller eventHandled method
  IF ::drgDialogController:eventHandled(nEvent, mp1, mp2, oXbp)
    RETURN .T.
  ENDIF

* on XbpTabPage click set focus to XbpBrowse for this page as INPUT
  IF nEvent = xbeP_SetInputFocus .and. oXbp:ClassName() = 'XbpTabPage'
    IF ::saveData(.F.)
      ::onItemMarked(oXbp,VAL(SUBSTR(oXbp:caption,2,1)))
      ::browseRefresh()
      ::loadData()
      PostAppEvent(drgEVENT_MSG,,nEvent, oXbp)
    ELSE                                                                        // na TABs je chyba
      ::drgDialog:oForm:oLastDrg := ::members[1]:tabPageManager:active
      RETURN .F.
    ENDIF
  ENDIF

* on ItemMarked in Browse
  If nEvent = xbeBRW_ItemMarked                                                 // 400  BROW/BROW/INFO etc.
    IF oXbp:ClassName() = 'XbpCellGroup'
      ::onItemMarked(oXbp:parent)
    ENDIF

    IF oXbp:ClassName() = 'XbpBrowse'
      if IsNIL(::oaBrowse)
        ::oaBrowse                 := ::oBrowse[1]
        ::drgDialog:oForm:oLastDrg := ::oaBrowse
      endif

      PostAppEvent(drgEVENT_REFRESH,,nEvent, oXbp)
    endif
  ENDIF

* on ESC keys not in Browse
  IF nEvent = xbeP_Keyboard
    IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
      oXbp:setColorBG((drgPP:getPP(drgPP_PP_EDIT1)[2,2]))
      ::onItemMarked(::oaBrowse,,1)
    ENDIF
  ENDIF

  ::chkMenuItem()

* Non drg events are not of our interest
  IF nEvent < drgEVENT_MIN .OR. nEvent > drgEVENT_MAX

    // pokud uknu myší na EDITAÈNÍ prvek //
    IF nEvent = xbeM_LbDown
      cargo := oXbp:cargo

      IF cargo != NIL .AND. VALTYPE(cargo) = 'O' .AND. !cargo:IsDerivedFrom('DrgAction')
        IF ::browseInFocus()
          if .not. (::oaBrowse:cFile)->(eof())
*-          IF ::hasBrowseData
            RETURN .F.
          ELSE
            PostAppEvent(drgEVENT_ACTION, drgEVENT_APPEND,'2',oXbp)
            RETURN .T.
          ENDIF
        ENDIF
      ENDIF
    ENDIF
  ENDIF


  DO CASE
* Handle action events
  CASE nEvent = drgEVENT_ACTION
    ::handleAction(nEvent, mp1, mp2, oXbp)

***********************************************************
* Refresh event on browse:itemMarked event
  CASE nEvent = drgEVENT_REFRESH
     IF ::saveData()
      ::browseRefresh()
      ::loadData()

** refresh for NON-active BROWs
      AEval(::oBrowse, {|X| IF( X = ::oaBrowse, NIL, X:oXbp:refreshAll()) } )
      PostAppEvent(drgEVENT_MSG,,nEvent,oXbp)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_NEXT
    IF ::saveData()
      IF ::browseInFocus()
        PostAppEvent(xbeP_Keyboard, xbeK_PGDN, , ::oaBrowse:oXbp)
      ELSE
        (::dbArea)->( DBSKIP() )
        IF (::dbArea)->( EOF() )
          drgMsg(drgNLS:msg('Last record reached!'), DRG_MSG_WARNING, oXbp )
          (::dbArea)->( DBGOBOTTOM() )
        ENDIF
      ENDIF
      ::browseRefresh()
      ::loadData()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_PREV
    IF ::saveData()
      IF ::browseInFocus()
        PostAppEvent(xbeP_Keyboard, xbeK_PGUP, , ::oaBrowse:oXbp)
      ELSE
        (::dbArea)->( DBSKIP(-1) )
      ENDIF
      ::browseRefresh()
      ::loadData()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_TOP
    IF ::saveData()
      PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGUP, , ::oaBrowse:oXbp)
      ::loadData()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_BOTTOM
    IF ::saveData()
      PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGDN, , ::oaBrowse:oXbp)
      ::loadData()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_EDIT
    IF ::saveData()
      IF ::browseInFocus(.T.)
        ::browseRefresh()

        * editaèní BROw *
        if Lower(::oaBrowse:className()) = 'drgebrowse'
          nCOL := ::oabrowse:oxbp:colPos
          nROW := ::oabrowse:oxbp:rowPos
          PostAppEvent(xbeBRW_ItemSelected,{nCOL,nROW},NIL,::oabrowse:oxbp)
          RETURN .F.
        else
          PostAppEvent(drgEVENT_OBJEXIT,::oaBrowse, ,oXbp)                        // Jump to next field
        endif
      ENDIF
      ::loadData()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_APPEND
    IF ::saveData(.T.)
*      lastRec := (::dbarea)->(recno())
*      ::oabrowse:oXbp:refreshCurrent():DeHilite()

*      (::dbArea)->( DBGOTO(0) )
      ::loadData(.T.)

      PostAppEvent(drgEVENT_MSG,,nEvent, oXbp)

      * editaèní BROw *
*      if Lower(::oaBrowse:className()) = 'drgebrowse'

*        (::dbarea)->(dbgoto(lastRec))
*        ::oabrowse:oxbp:pageDown():refreshCurrent():dehilite()
*        (::dbArea)->( DBGOTO(0) )

*        nCOL := 1
*        nROW := if(::lastRECNO == 1, 1, ::oabrowse:oxbp:rowPos+1)

*        PostAppEvent(xbeBRW_ItemSelected,{nCOL,nROW},2,::oabrowse:oxbp)
*        RETURN .F.
      if ::browseInFocus(.t.)
        PostAppEvent(drgEVENT_OBJEXIT,::oaBrowse, ,oXbp)
      endif
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_APPEND2
    IF ::saveData()
      ::loadData(.T.,.T.)
      PostAppEvent(drgEVENT_MSG,,nEvent, oXbp)
      IF ::browseInFocus(.T.)
        PostAppEvent(drgEVENT_OBJEXIT,,,oXbp)                                   // Jump to next field
      ENDIF
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_DELETE
    IF !::isReadOnly .and. ::browseInFocus(.T.)                                 // miss
      IF drgIsYESNO(drgNLS:msg('Delete record!;; Are you sure?') )
* Ask user function IF ok to delete
        IF ::evalBlock(::cbDelete, .T.)
          IF ::deleteRecord()
            ::evalBlock(::cbDelete, .F.)
          ENDIF
        ENDIF
      ENDIF

* cursor reposition
      (::dbArea)->( DBSKIP(-1) )
      IF (::dbArea)->( RECNO() ) = 0
        (::dbArea)->( ADS_DaGoTop() )
      ENDIF
      ::browseRefresh()
      ::loadData()
    ENDIF
***********************************************************
  CASE nEvent = drgEVENT_SAVE
    IF ::saveData(.F.)
      ::browseRefresh()
      ::loadData()

      IF LEN(::browseOnTabs[::tabNumber]) <> 0
        ::onItemMarked(::browseOnTabs[::tabNumber,1])
      ENDIF

      PostAppEvent(drgEVENT_MSG,,nEvent, oXbp)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_EXIT
    IF ::saveData(.F.)
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
    ENDIF

  CASE nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close, nEvent,,oXbp)

***********************************************************
  CASE nEvent = drgEVENT_PRINT
    ::drgDialogPrint()

  CASE nEvent = drgEVENT_FIND
    IF !::drgDialog:dataManager:changed()
      IF ::browseInFocus()
        ::drgDialogFind()
        ::browseRefresh()
      ENDIF
    ELSE
      drgMsg(drgNLS:msg('Save changes before using find!'), DRG_MSG_WARNING, oXbp )
    ENDIF

* Post record append event if table is empty
***********************************************************
  CASE nEvent = drgEVENT_FORMDRAWN
    // pokud není pøi STARU formuláøe na aktivní záložce BRO docházelo k repozici DB //
//    IF( EMPTY(::browseOnTabs[::tabNumber]), NIL, (::dbArea)->( ADS_DaGoTop()) )
    IF LEN(::oBrowse) = 0
      IF (::dbArea)->( EOF() )
        drgMsgBox(drgNLS:msg('Table is empty. New record has been appended automatically.') )
        ::loadData(.T.)
        PostAppEvent(drgEVENT_OBJEXIT,,,oXbp)
        PostAppEvent(drgEVENT_MSG,,drgEVENT_APPEND, oXbp)
      ENDIF
    ENDIF

    RETURN .F.              // must be processed somewhere else

* Not processed
  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

***********************************************************************
* Saves last edited data from internal memManager structure to variables used \
* by dialog. If variables used are from file they are saved to file if variables \
* used are stored in memory they are stored to their memory locations.
*
* \b< Parameters: b\
* \b< chkIfChanged >b\ : Logical : If program should ask if last edited data is saved. \
* this usualy happeds when Exit dialog is selected and data is not saved yet.
***********************************************************************
METHOD drgDC20w:saveData(lChkIfChanged)
  LOCAL tmpRECNO := (::dbArea)->( RECNO())

  DEFAULT lChkIfChanged TO .T.

* Do nothing if readonly
  IF ::isReadOnly
    RETURN .T.
  ENDIF

* Data nebyla zmìnìna a soubor je prázdný at EOF *
  IF (::dbArea) ->(EOF()) .and. !::drgDialog:dataManager:changed()
    RETURN .T.
  ENDIF

* Data is not changed
* IF lChkIfChanged
    IF !::drgDialog:dataManager:changed()
      RETURN .T.
    ENDIF
*  ENDIF

* PostValidate all fields on form
  IF !::postValidateForm()               //!::drgDialog:oForm:postValidateForm()
    RETURN .F.
  ENDIF

* ON exit OR record change without SAVE
  IF lChkIfChanged //.AND. !drgIsYESNO(drgNLS:msg('Data has been changed.;; Save changes?') )
    RETURN .T.
  ENDIF

* Check for duplicate keys
  IF !::chkDuplicates(::isAppend)
    RETURN .F.
  ENDIF

* Restore record pointer
**  (::dbArea)->( DBGOTO(::lastRECNO) )

* Save changes

  IF ::evalBlock(::cbSave, .T., ::isAppend)            // Check IF OK to save
    IF ::isAppend
      ::appendBlankRecord()
    ELSE
    /*
* Check if data was changed during edit session
      IF drgArrayDif(::aData, (::dbArea)->( drgScatter() ) ) .AND. !drgIsYesNO( drgNLS:msg( ;
        'Another user has changed record while record was edited!;;' + ;
        'Save data anyway?;;' + ;
        'Select YES to save your data.;' + ;
        'Select NO to retain current data.'),,XBPMB_WARNING )
* Return IF No was selected
          RETURN .F.
      ENDIF
    */
    ENDIF
*
    IF (::dbArea)->( drgLockOK() )
      ::drgDialog:dataManager:save()
      ::evalBlock(::cbSave, .F., ::isAppend)           // Inform record has been saved

      IF( ::isAppend, (::dbArea) ->( DbCommit()), NIL )
      (::dbArea)->( DBUNLOCK() )
    ELSE
      RETURN .F.
    ENDIF
  ELSE
    RETURN .F.
  ENDIF

* Restore record position
**  IF tmpRECNO != ::lastRECNO
**    (::dbArea)->( DBGOTO(tmpRECNO) )
**  ENDIF
RETURN .T.

***********************************************************************
* Loads data into memManager structure.
***********************************************************************
METHOD drgDC20w:loadData(isAppend, withCopy)

  DEFAULT isAppend  TO .F.
  DEFAULT withCopy  TO .F.
  ::isAppend := isAppend

  IF( (::dbArea) ->(EOF()), ::isAppend := isAppend := .T., NIL )

  ::drgDialog:dataManager:refresh()
  ::lastRECNO := (::dbArea)->( RECNO() )
*****  ::aData := (::dbArea)->( drgScatter() )
  ::evalBlock(::cbLoad, isAppend)
* Mark all field as changed. This is because ::save saves only changed fields
  IF withCopy
    ::drgDialog:dataManager:markChanged( (::dbArea)->( ALIAS() ) + '->' )
  ENDIF
  ::drgDialog:oForm:resetValidation()
  PostAppEvent(drgEVENT_MSG,,drgEVENT_SAVE, ::drgDialog:dialog)

RETURN

***********************************************************************
* Checks for duplicate records.
***********************************************************************
METHOD drgDC20w:chkDuplicates(isAppend)
/*
  ::drgDialog:pushArea()
  ::drgDialog:popArea()
*/
RETURN .T.

*************************************************************************
* Postvalidate all fields on a form
*************************************************************************
METHOD drgDC20w:postValidateForm()
  LOCAL  aMembers := ::members[1]:aMembers
  LOCAL  x

  FOR x := 1 TO LEN(aMembers)
    IF aMembers[x]:isEdit .and. !IsNIL(aMembers[x]:name)
      IF ::dbArea == SELECT(drgParse(aMembers[x]:name,'-'))
        IF !( aMembers[x]:postValidate(.T.) )
          aMembers[x]:setFocus()
          RETURN .F.
        ENDIF
      ENDIF
    ENDIF
  NEXT
RETURN .T.