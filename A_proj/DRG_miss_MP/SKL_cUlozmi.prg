
#include "common.ch"
#include "drg.ch"
#include "Xbp.ch"
#include "appevent.ch"

/*******************************************************************************
CLASS C_ULOZMI FROM drgUsrClass

EXPORTED:
  METHOD Valid_cULOZMI
ENDCLASS

********************************************************************************
METHOD C_ULOZMI:Valid_cULOZMI(oVar)
  LOCAL xVar := oVar:get()
  LOCAL lChanged := oVar:changed(), lFound, lRet := .T.
  LOCAL cName := oVar:Name, cKey
  Local lNewRec  := ::drgDialog:dialogCtrl:isAppend, nREC

IF lNewRec .or. lChanged

  DO CASE
    CASE cName = 'C_ULOZMI->CULOZZBO'
      ::drgDialog:pushArea()            // save SELECT() + ORDER()
      cKey := ::dataManager:get('C_UlozMi->cCisSklad')
      cKey := Upper(cKey) + Upper(xVar)
      lFound := C_UlozMi->( dbSEEK( cKey,,'C_ULOZM2'))

      IF lNewRec
        IF lFound
          drgMsg(drgNLS:msg('Místo uložení v rámci skladu již existuje !'),, ::drgDialog:dialog)
          lRet := .F.
        ENDIF
    * Edition of key is alowed but only if it doesn't exist
      ELSEIF lChanged .AND. lFound
        oVar:recall()                     // restore initial value
        drgMsg(drgNLS:msg('Místo uložení v rámci skladu již existuje !'),, ::drgDialog:dialog)
        lRet := .F.
      ENDIF
      ::drgDialog:popArea()             // restore SELECT() + ORDER()
  ENDCASE
ENDIF

RETURN lRet
*/

********************************************************************************
CLASS C_ULOZMI FROM drgUsrClass
EXPORTED:
  VAR    lSearch, oVar
  METHOD init, drgDialogInit, drgDialogStart, eventHandled, tabSelect
  METHOD postValidate

HIDDEN:
  VAR     dc, dm, tabNum, recNo, recnoApp
ENDCLASS

********************************************************************************
METHOD C_ULOZMI:init(parent)
  *
  ::drgUsrClass:init(parent)
  ::oVar := parent:cargo
  if ( ::lSearch := ::oVar <> NIL)
    ::recNo := C_ULOZMI->( recNo())
  endif
  drgDBMS:open('C_ULOZMI',,,,,'C_ULOZMIa' )
RETURN self

********************************************************************************
METHOD C_ULOZMI:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += IF( ::lSearch, ' - VÝBÌR ...', '' )
*  _clearEventLoop(.t.)
RETURN self

********************************************************************************
METHOD C_ULOZMI:drgDialogStart(drgDialog)
  Local aPP := drgPP:getPP(2), oColumn, x
  Local oBro := ::drgDialog:dialogCtrl:oBrowse

  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager

  IF ::lSearch
     FOR x := 1 TO oBro:oXbp:colcount
        ocolumn := oBro:oXbp:getColumn(x)
        ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
        ocolumn:configure()
      NEXT
      oBro:oXbp:refreshAll()
  ENDIF
RETURN self

********************************************************************************
METHOD C_ULOZMI:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit

  DO CASE
*  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
  CASE nEvent = drgEVENT_APPEND
    ::recnoApp := C_UlozMi->(RecNo())
    ::dm:refreshAndSetEmpty( 'C_UlozMi' )
    ::tabNum := 2
    RETURN .F.
  CASE nEvent = drgEVENT_EDIT
    IF   ::lSearch
      ::drgDialog:cargo := &(oXbp:cargo:arDef[2,2])  //
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)
    ELSE
      RETURN .F.
    ENDIF

  CASE nEvent = xbeP_Keyboard
    DO CASE

    CASE mp1 = xbeK_ESC
*      IF ::lSearch
        IF oXbp:ClassName() = 'XbpBrowse'           //::tabNum = 1
          PostAppEvent(xbeP_Close, drgEVENT_QUIT,, oXbp)
        ELSE   //IF ::tabNum = 2
          /*
          ::drgDialog:oForm:tabPageManager:showPage(1, .t.)
          ::tabNum := 1
          SetAppFocus( ::drgDialog:odBrowse[1]:oXbp)
          */
*          ::drgDialog:oForm:tabPageManager:toFront(1)
*          ::drgDialog:oForm:tabPageManager:showPage(1, .t.)
          *
          IF !IsNull(::dc:isAppend) .and. ::dc:isAppend
            IF( IsNull( ::recnoApp), nil, C_UlozMi->( dbGoTO(::recnoApp )) )
          ENDIF
          ::tabNum := 1
          ::drgDialog:oForm:tabPageManager:members[1]:setfocus(1)
          postAppEvent(xbeTab_TabActivate,,,::drgDialog:oForm:tabPageManager:members[1]:oxbp )

          ::drgDialog:odBrowse[1]:oXbp:refreshall()
*          SetAppFocus( ::drgDialog:odBrowse[1]:oXbp)
          */
*          RETURN .F.
        ENDIF
*      ELSE
*        RETURN .F.
*      ENDIF
*        RETURN .F.
       */
    CASE mp1 = xbeK_ENTER
      IF oXbp:ClassName() = 'xbpGet'
        RETURN .F.
      ELSE
        IF   ::lSearch
          ::drgDialog:cargo := &(::drgDialog:odBrowse[1]:arDef[2,2])  //
          PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)
        ELSE
          RETURN .F.
        ENDIF
      ENDIF

*      _clearEventLoop(.t.)
*      PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)
     OTHERWISE
      RETURN .F. // RETURN .F.
    ENDCASE

  case(nevent = drgEVENT_MSG)
    if mp2 = DRG_MSG_ERROR
      _clearEventLoop()
       SetAppFocus(::dc:oBrowse:oXbp)
       return .t.
    endif
    return .f.

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD C_ULOZMI:tabSelect( tabPage, tabNumber)
  ::tabNUM := tabNumber
  IF ::lSearch
    C_ULOZMI->( dbGoTo( ::recNo))
    IF( C_ULOZMI->( EOF()),C_ULOZMI->( dbGoTOP()), NIL )
  ENDIF
RETURN  IF( ::lSearch .and. ::tabNUM = 2, .F., .T.)

********************************************************************************
METHOD C_ULOZMI:postValidate(oVar)
  LOCAL xVar := oVar:get()
  LOCAL lChanged := oVar:changed(), lFound, lRet := .T.
  LOCAL cName := oVar:Name, cKey
  Local lNewRec  := ::dc:isAppend
  Local nEvent := mp1 := mp2 := nil

  nEvent := LastAppEvent(@mp1,@mp2)
  if mp1 = xbeK_ESC
    return .t.
  endif

    DO CASE
    CASE cName = 'C_ULOZMI->CULOZZBO'
      IF lNewRec .or. lChanged
        IF lRet := ControlDUE( oVar)
          cKey := ::dm:get('C_UlozMi->cCisSklad')
          cKey := Upper(::dm:get('C_UlozMi->cCisSklad')) + Upper(xVar)
          lFound := C_UlozMIa->( dbSEEK( cKey,,'C_ULOZM2'))

          IF lNewRec
            IF lFound
              drgMsg(drgNLS:msg('Místo uložení v rámci skladu již existuje !'),, ::drgDialog:dialog)
              lRet := .F.
            ENDIF
        * Edition of key is alowed but only if it doesn't exist
          ELSEIF lChanged .AND. lFound
            oVar:recall()                     // restore initial value
            drgMsg(drgNLS:msg('Místo uložení v rámci skladu již existuje !'),, ::drgDialog:dialog)
            lRet := .F.
          ENDIF
        ENDIF
      ENDIF

    CASE cName = 'C_ULOZMI->CCISSKLAD'
      IF lNewRec .or. lChanged
        cKey := Upper(xVar) + Upper(::dm:get('C_UlozMi->cUlozZbo'))
        IF C_UlozMIa->( dbSEEK( cKey,,'C_ULOZM2'))
          drgMsgBox(drgNLS:msg('Místo uložení v rámci skladu již existuje !'),, ::drgDialog:dialog)
          oVar:recall()                     // restore initial value
          lRet := .F.
        ENDIF
      ENDIF
      *
      IF ( nEvent = xbeP_Keyboard .and.( mp1 = xbeK_TAB .or. mp1 = xbeK_ENTER ))
        postLastField_2( oVar)
      ENDIF

    ENDCASE

RETURN lRet