#include "common.ch"
#include "drg.ch"
#include "Xbp.ch"
#include "appevent.ch"



********************************************************************************
CLASS C_ULOZMI FROM drgUsrClass
EXPORTED:
  VAR    lSearch, oVar
  METHOD init, drgDialogInit, drgDialogStart, eventHandled, tabSelect
  METHOD postValidate


  inline method preValidate(drgVar)
    local  value := drgVar:get()
    local  name  := Lower(drgVar:name)

    if name = 'c_ulozmi->culozzbo'
      if empty(value)
        if( .not. empty(::val_cisSklad), ::o_cisSklad:set(::val_cisSklad ), nil )
**        ::dm:refresh(.t.)
      endif
    endif
  return .t.

  inline method save_c_ulozmi( inSave, isAppend)
    local  dm         := ::dataManager             // dataManager
    local  o_cisSklad := dm:has( 'c_ulozmi->ccisSklad' )
    *
    if inSave
      o_cisSklad:initValue := ''
    endif
  return .t.


HIDDEN:
  VAR     dc, dm, tabNum, recNo, recnoApp
  var     o_cisSklad, val_cisSklad

ENDCLASS

********************************************************************************
METHOD C_ULOZMI:init(parent)
  local  pa
  *
  ::drgUsrClass:init(parent)

  ::oVar         := parent:cargo
  ::val_cisSklad := ''

  if ( ::lSearch := ::oVar <> NIL)
    if lower(parent:parent:formName) = 'skl_cenzboz_crd'
      pa := listAsarray( c_ulozmi->( ads_getAof()), '=' )

      ::val_cisSklad := padR( allTrim( strTran( pa[2], "'", "" )), 8 )
    endif
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
  Local  aPP := drgPP:getPP(2), oColumn, x
  Local  oBro := ::drgDialog:dialogCtrl:oBrowse
  local  cky, recNo

  ::dc         := drgDialog:dialogCtrl
  ::dm         := drgDialog:dataManager
  ::o_cisSklad := ::dm:get( 'c_ulozmi->ccisSklad', .f.)

  IF ::lSearch
    FOR x := 1 TO oBro:oXbp:colcount
      ocolumn := oBro:oXbp:getColumn(x)
      ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
      ocolumn:configure()
    NEXT

    if .not. empty(::val_cisSklad)
      ( ::o_cisSklad:odrg:isEdit := .F., ::o_cisSklad:odrg:oxbp:disable() )

      if .not. c_ulozmi->( dbseek( upper(::val_cisSklad) +upper(::ovar),, 'C_ULOZM2') )
        c_ulozmi->( dbgoTop())
      endif
    endif

    oBro:oXbp:refreshAll()
    postAppEvent(drgEVENT_REFRESH,,,oBro:oxbp)
  ENDIF
RETURN self

********************************************************************************
METHOD C_ULOZMI:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit

  do case
  case nEvent = drgEVENT_FORMDRAWN
    return ::lsearch

  case nEvent = drgEVENT_EDIT
    if   ::lSearch .and. oXbp:className() = 'XbpBrowse'
      ::drgDialog:cargo := c_ulozMi->culozZbo
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)
    else
      return .f.
    endif

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
*      IF ::lSearch
        IF oXbp:ClassName() = 'XbpBrowse'           //::tabNum = 1
          PostAppEvent(xbeP_Close, drgEVENT_QUIT,, oXbp)
        ELSE   //IF ::tabNum = 2
          IF !IsNull(::dc:isAppend) .and. ::dc:isAppend
            IF( IsNull( ::recnoApp), nil, C_UlozMi->( dbGoTO(::recnoApp )) )
          ENDIF
          ::tabNum := 1
          ::drgDialog:oForm:tabPageManager:members[1]:setfocus(1)
*          postAppEvent(xbeTab_TabActivate,,,::drgDialog:oForm:tabPageManager:members[1]:oxbp )

          ::drgDialog:odBrowse[1]:oXbp:refreshall()
*          SetAppFocus( ::drgDialog:odBrowse[1]:oXbp)
          */
*          RETURN .F.
        ENDIF
*      ELSE
*        RETURN .F.
*      ENDIF
*        RETURN .F.
    CASE mp1 = xbeK_ENTER
      IF oXbp:ClassName() = 'xbpGet' .or. oxbp:className() = 'XbpCombobox'
        RETURN .F.
      ELSE
        IF ::lSearch
          ::drgDialog:cargo := c_ulozMi->culozZbo
          PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)
        ELSE
          RETURN .F.
        ENDIF
      ENDIF

     OTHERWISE
      RETURN .F. // RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD C_ULOZMI:tabSelect( tabPage, tabNumber)
  ::tabNUM := tabNumber

  if( ::tabNum = 1, ::dc:isAppend := .f., nil )
RETURN  .t.


********************************************************************************
METHOD C_ULOZMI:postValidate(oVar)
  LOCAL xVar := oVar:get()
  LOCAL lChanged := oVar:changed(), lFound, lRet := .T.
  LOCAL cName    := oVar:Name, cKey
  Local lNewRec  := isNull(::dc:isAppend, .f.)
  Local nEvent := mp1 := mp2 := nil

  nEvent := LastAppEvent(@mp1,@mp2)
  if(IsNUMBER(mp1) .and. mp1 = xbeK_ESC )
    return .t.
  endif

  IF lNewRec .or. lChanged

    DO CASE
    CASE cName = 'C_ULOZMI->CULOZZBO'
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
*      ::drgDialog:popArea()             // restore SELECT() + ORDER()

    CASE cName = 'C_ULOZMI->CCISSKLAD'
      cKey := Upper(xVar) + Upper(::dm:get('C_UlozMi->cUlozZbo'))
      IF C_UlozMIa->( dbSEEK( cKey,,'C_ULOZM2'))
        drgMsgBox(drgNLS:msg('Místo uložení v rámci skladu již existuje !'),, ::drgDialog:dialog)
        oVar:recall()                     // restore initial value
        lRet := .F.
      ENDIF
      IF ( nEvent = xbeP_Keyboard .and.( mp1 = xbeK_TAB .or. mp1 = xbeK_ENTER ))
        postLastField_2( oVar)
      ENDIF

    ENDCASE
  ENDIF

  if cname = 'C_ULOZMI->CULOZSYS' .and. lret
    if ( nEvent = xbeP_Keyboard .and. mp1 = xbeK_ENTER )
      postLastField_2( oVar)
    endif
  endif

RETURN lRet