////////////////////////////////////////////////////////////////////
//
//  drgDC20.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//  Implementation of controller with single browser. This type of controller uses \
//  browser to browse data and displays edit controls for editing data.
//
//  Remarks: 20:01 8.2.2005 pøesunuto do DRG_miss
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"


#define   _menuED   { 'CTRL+P'      , 'ENTER'      , 'F3'            , 'INS'          , 'DEL'          , ;
                      'CTRL+PGUP'   , 'PGUP'       , 'PGDN'          , 'CTRL+PGDN'    , 'CTRL+F'       , ;
                      'CTRL+N'                                                 }
#define   _actionED { drgEVENT_PRINT, drgEVENT_EDIT, drgEVENT_APPEND2, drgEVENT_APPEND, drgEVENT_DELETE, ;
                      drgEVENT_TOP  , drgEVENT_PREV, drgEVENT_NEXT, drgEVENT_BOTTOM , drgEVENT_FIND      }



CLASS drgDC20 FROM drgDialogController
EXPORTED:
  VAR     aData
  VAR     oaBrowse                                                              // aktivní BROw
  VAR     tabNumber

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
  VAR     browseOnTabs
  VAR     menuItemCheck

  METHOD  chkMenuItem
  METHOD  registerBrowseOnTabs
  METHOD  postValidateForm

ENDCLASS

//
METHOD drgDC20:init(oParent)
  ::drgDialogController:init(oParent)
  ::oBrowse        := {}
  ::tabNumber      := 1
  ::hasBrowseData  := .F.
  ::menuItemCheck  := {}
RETURN self


//
METHOD drgDC20:registerBrowser(oDrgBrowse)
  AAdd(::oBrowse, oDrgBrowse)
RETURN self


//
METHOD drgDC20:registerBrowseOnTabs()
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

  // jednotlivé TABs mohou mít drgBrowse //
  ::browseOnTabs := {}
  FOR nIn := 1 TO LEN(tabPage) ;  AAdd(::browseOnTabs, {} ) ;  NEXT

  FOR nTABs := 1 TO LEN(tabPage)
    onFormIndex := tabPage[nTABs]:onFormIndex
    nLASTs      := IF( nTABs +1 > LEN(tabPage), LEN(dc), tabPage[nTABs+1]:onFormIndex)
    FOR nIn := onFormIndex +1 TO nLASTs
      IF lower(dc[nIn]:className()) $ 'drgbrowse,drgdbrowse'
        AAdd( ::browseOnTabs[nTABs], dc[nIn])
      ENDIF
    NEXT
  NEXT
RETURN SELF

//
METHOD drgDC20:browseInFocus(lSetTabFocus)
  LOCAL  tabManager := ::members[1]:tabPageManager
  LOCAL  nIn, nPn
  Local  oForm := ::drgDialog:oForm

  DEFAULT lSetTabFocus TO .F.

  IF( nIn := ASCAN( ::oBrowse, {|x| ::drgDialog:oForm:oLastDrg = x} )) <> 0
    ::oaBrowse           := ::oBrowse[nIn]

    IF lSetTabFocus
      IF( nPn := AScan( tabManager:members, {|X| X:tabBrowse = ::oaBrowse:cFile })) <> 0
        tabManager:showPage(nPn, .T.)
      ENDIF
    ENDIF
  ENDIF

  ::hasBrowseData := IF(nIn <> 0, !(::oaBrowse:cFile) ->(EOF()), .F.)
RETURN nIn <> 0

//
METHOD drgDc20:browseRefresh()
  IF ::oaBrowse != NIL
    ::oaBrowse:oXbp:refreshAll()
  ENDIF
RETURN

//
METHOD drgDc20:onItemMarked(oXbp,nPAGE,onEsc)
  LOCAL  nBRo, nCOLn, activeGet
  LOCAL  nextFocus, oACTIVe, oLASTXbp := ::dataManager:drgDialog:lastXbpInFocus
  LOCAL  cFILE
  LOCAL  vars   := ::dataManager:vars:values

  IF lower(oXbp:ClassName()) $ 'drgbrowse,drgdbrowse'
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

      IF !( lower(oACTIVe:ClassName()) $ 'drgbrowse,drgdbrowse')
        IF !IsNil(oXbp:cargo)
          IF( nBro := AScan( ::oBrowse, {|X| X:cFile = oXbp:Cargo:tabBrowse })) <> 0
            oACTIVe := ::oBrowse[nBro]
          ENDIF
        ENDIF
      ENDIF
    ENDIF
  ENDIF

  IF IsObject(oACTIVe)
    IF lower(oACTIVe:ClassName()) $ 'drgbrowse,drgdbrowse'
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
METHOD drgDC20:chkMenuItem()
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
    /*
    IF (dbArea <> 0) .and. (::dbArea <> dbArea)
      IF( ::saveData(.F.), (::dbArea := dbArea, ::loadData()), ::dbArea := dbArea )
    ENDIF
    */
  ENDIF

  // aktivní TAB page //
  IF IsOBJECT(::members[1]:tabPageManager:active)
    ::tabNumber := ::members[1]:tabPageManager:active:tabNumber
  ENDIF

  // povolí/zakáže položky MENU a ACTION //
  IF ::browseInFocus()
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
METHOD drgDC20:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL cargo

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
      If IsNIL(::oaBrowse)
        ::oaBrowse                 := ::oBrowse[1]
        ::drgDialog:oForm:oLastDrg := ::oaBrowse
      ENDIF

      PostAppEvent(drgEVENT_REFRESH,,nEvent, oXbp)
    ENDIF
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
          IF ::hasBrowseData
            RETURN .F.
          ELSE
            PostAppEvent(drgEVENT_ACTION, drgEVENT_APPEND,'2',oXbp)
            RETURN .T.
          ENDIF
        ENDIF
      ENDIF
    ENDIF

**    RETURN .F.
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
        PostAppEvent(drgEVENT_OBJEXIT,::oaBrowse, ,oXbp)                        // Jump to next field
      ENDIF
      ::loadData()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_APPEND
    IF ::saveData(.T.)
      ::browseRefresh()
      (::dbArea)->( DBGOTO(-1) )
      ::loadData(.T.)

      PostAppEvent(drgEVENT_MSG,,nEvent, oXbp)
      IF ::browseInFocus(.T.)
        PostAppEvent(drgEVENT_OBJEXIT,::oaBrowse,,oXbp)                         // Jump to next field
      ENDIF
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
        (::dbArea)->( DBGOTOP() )
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
*    IF( EMPTY(::browseOnTabs[::tabNumber]), NIL, (::dbArea)->( DBGOTOP()) )
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
METHOD drgDC20:saveData(lChkIfChanged)
LOCAL tmpRECNO
  DEFAULT lChkIfChanged TO .T.
  tmpRECNO := (::dbArea)->( RECNO() )

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
*
* ON exit OR record change without SAVE
  IF lChkIfChanged //.AND. !drgIsYESNO(drgNLS:msg('Data has been changed.;; Save changes?') )
    RETURN .T.
  ENDIF

* Check for duplicate keys
  IF !::chkDuplicates(::isAppend)
    RETURN .F.
  ENDIF

* Restore record pointer
  (::dbArea)->( DBGOTO(::lastRECNO) )

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
      (::dbArea)->( DBUNLOCK() )
    ELSE
      RETURN .F.
    ENDIF
  ELSE
    RETURN .F.
  ENDIF

/* Restore record position
  IF tmpRECNO != ::lastRECNO
    (::dbArea)->( DBGOTO(tmpRECNO) )
  ENDIF
*/
RETURN .T.

***********************************************************************
* Loads data into memManager structure.
***********************************************************************
METHOD drgDC20:loadData(isAppend, withCopy)
LOCAL st
  DEFAULT isAppend  TO .F.
  DEFAULT withCopy  TO .F.
  ::isAppend := isAppend

  IF( (::dbArea) ->(EOF()), ::isAppend := isAppend := .T., NIL )

  ::drgDialog:dataManager:refresh()
  ::lastRECNO := (::dbArea)->( RECNO() )
  ::aData := (::dbArea)->( drgScatter() )
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
METHOD drgDC20:chkDuplicates(isAppend)
/*
  ::drgDialog:pushArea()
  ::drgDialog:popArea()
*/
RETURN .T.

*************************************************************************
* Postvalidate all fields on a form
*************************************************************************
METHOD drgDC20:postValidateForm()
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