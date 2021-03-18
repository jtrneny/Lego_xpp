*
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Xbp.ch"
#include "..\SKLADY\SKL_Sklady.ch"

********************************************************************************
*  Dialog pro výbìr SKLADU
********************************************************************************
CLASS SKL_C_SKLAD FROM drgUsrClass
EXPORTED:
  METHOD getForm, eventHandled

ENDCLASS

**********************************************************************
METHOD SKL_C_SKLAD:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)

  CASE nEvent = drgEVENT_APPEND

  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,, oXbp)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_C_SKLAD:getForm()
  Local  oDrg, drgFC

  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 50,17 DTYPE '10' TITLE 'Èíselník skladù - VÝBÌR' ;
                                          GUILOOK 'All:N,Border:Y'
  DRGTEXT INTO drgFC CAPTION 'Vyber požadovaný sklad ... ' CPOS 0,16 CLEN 50 PP 2 BGND 15

  DRGBROWSE INTO drgFC  SIZE 50,16 FILE 'C_SKLADY' INDEXORD 1 ;
    FIELDS 'cCisSklad, cNazSklad' ;
    SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'xy' //  ITEMSELECTED 'SelSKLAD'
RETURN drgFC

********************************************************************************
*  Dialog pro výbìr Úèetní sk. pro pøevod
********************************************************************************
CLASS SKL_C_UCTSKP FROM drgUsrClass
EXPORTED:
  METHOD getForm, eventHandled

ENDCLASS

********************************************************************************
METHOD SKL_C_UCTSKP:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)

  CASE nEvent = drgEVENT_APPEND

  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,, oXbp)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_C_UCTSKP:getForm()
  Local  oDrg, drgFC

  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 50,17 DTYPE '10' TITLE 'Úèetní skupina - VÝBÌR' ;
                                          GUILOOK 'All:N,Border:Y'
  DRGTEXT INTO drgFC CAPTION 'Vyber požadovanou úèetní skupinu ... ' CPOS 0,16 CLEN 50 PP 2 BGND 15

  DRGBROWSE INTO drgFC  SIZE 50,16 FILE 'C_UCTSKP' INDEXORD 1 ;
    FIELDS 'nUcetSkup, cNazUctSk' ;
    SCROLL 'ny' CURSORMODE 3 PP 7 RESIZE 'xy' //  ITEMSELECTED 'SelSKLAD'
RETURN drgFC

********************************************************************************
*  Dialog pro výbìr NÁZVU ZBOŽÍ
********************************************************************************
CLASS C_NAZZBO FROM drgUsrClass
EXPORTED:
  VAR    lSearch, oVar, tabNum, recNo
  METHOD init, drgDialogInit, eventHandled, preValidate, tabSelect //,  getForm
  METHOD drgDialogStart

ENDCLASS

********************************************************************************
METHOD C_NAZZBO:init(parent)
  *
  ::drgUsrClass:init(parent)
  ::oVar := parent:cargo
  IF(::lSearch := ::oVar <> NIL )
    if( empty(::oVar) .or. C_NazZbo->(eof()), C_NazZbo->( dbGoTOP()), NIL )
    ::recNo := C_NazZbo->( recNo())
  ENDIF

RETURN self

********************************************************************************
METHOD C_NAZZBO:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += IF( ::lSearch, ' - VÝBÌR ...', '' )
RETURN


METHOD C_NAZZBO:drgDialogStart(drgDialog)
  Local aPP := drgPP:getPP(2), oColumn, x
  Local oBro := ::drgDialog:dialogCtrl:oBrowse

  IF ::lSearch
     FOR x := 1 TO oBro:oXbp:colcount
        ocolumn := oBro:oXbp:getColumn(x)
        ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
        ocolumn:configure()
      NEXT
      oBro:oXbp:refreshAll()
      C_NazZbo->( dbGoTo( ::recNo))
  ENDIF

RETURN



********************************************************************************
METHOD C_NAZZBO:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    IF   ::lSearch
*      ::drgDialog:cargo := &(oXbp:cargo:arDef[1,2]) 

      ::drgDialog:cargo := c_nazZbo->cnazevNaz 
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)
    ELSE           ;  RETURN .F.
    ENDIF
  *
  CASE nEvent = drgEVENT_APPEND
    /*
      C_nazzbo->( dbGoTO(-1) )
      ::drgDialog:datamanager:refreshandsetempty()
      ::drgDialog:oForm:setNextFocus( 'C_NAZZBO->nZboziKat',, .t. )
    */
    RETURN .F.
  CASE nEvent = drgEVENT_FORMDRAWN
    IF ::lSearch
//      IF drgIsYesNO(drgNLS:msg('Neexistuje takový název v "Èíselníku názvù zboží".;;Založit ho ?') )
//        PostAppEvent(xbeP_Keyboard, xbeK_INS, , ::drgDialog:dialogCtrl:oBrowse:oXbp)
//      ENDIF
*      Return .T.
    ENDIF
  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
        RETURN .F.

    OTHERWISE
      RETURN .F.
    ENDCASE

  case(nevent = drgEVENT_MSG)
    if mp2 = DRG_MSG_ERROR
      _clearEventLoop()
       SetAppFocus(::drgDialog:dialogCtrl:oBrowse:oXbp)
       return .t.
    endif
    return .f.

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD C_NAZZBO:preValidate( oVar)
  IF ::lSearch
    IF oVar:Name = 'C_NazZBO->cNazevNaz' //'C_NazZBO->nZboziKat'
      ::drgDialog:dataManager:set( 'C_NazZBO->cNazevNaz', ::oVar:oXbp:value )
      ::drgDialog:dataManager:set( 'C_NazZBO->nKlicNaz' , 0                 )
    ENDIF
  ENDIF
RETURN .T.

********************************************************************************
METHOD C_NAZZBO:tabSelect( tabPage, tabNumber)
  ::tabNUM := tabNumber
RETURN  IF( ::lSearch .and. ::tabNUM = 2, .F., .T.)

********************************************************************************
*  Dialog pro výbìr
********************************************************************************
CLASS C_SKLADY FROM drgUsrClass
EXPORTED:
  VAR    lSearch, oVar, tabNum, recNo
  METHOD init, drgDialogInit, drgDialogStart, eventHandled, tabSelect
ENDCLASS

********************************************************************************
METHOD C_SKLADY:init(parent)
  *
  ::drgUsrClass:init(parent)
  ::oVar := parent:cargo
  IF(::lSearch := ::oVar <> NIL )
    if( empty(::oVar) .or. C_Sklady->(eof()), C_Sklady->( dbGoTOP()), NIL )
    ::recNo := C_Sklady->( recNo())
  ENDIF
RETURN self

********************************************************************************
METHOD C_SKLADY:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += IF( ::lSearch, ' - VÝBÌR ...', '' )
*  _clearEventLoop(.t.)
RETURN

********************************************************************************
METHOD C_SKLADY:drgDialogStart(drgDialog)
  Local aPP := drgPP:getPP(2), oColumn, x
  Local oBro := ::drgDialog:dialogCtrl:oBrowse

  IF ::lSearch
     FOR x := 1 TO oBro:oXbp:colcount
        ocolumn := oBro:oXbp:getColumn(x)
        ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
        ocolumn:configure()
      NEXT
      oBro:oXbp:refreshAll()
      C_Sklady->( dbGoTo( ::recNo))
  ENDIF
RETURN

********************************************************************************
METHOD C_SKLADY:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit

  DO CASE
*  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
  CASE nEvent = drgEVENT_EDIT
    IF   ::lSearch
*      ::drgDialog:cargo := &(oXbp:cargo:arDef[1,2])  

      ::drgDialog:cargo := c_sklady->ccisSklad
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)
    ELSE
      RETURN .F.
    ENDIF

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
        RETURN .F.
    CASE mp1 = xbeK_ENTER

      IF oXbp:ClassName() = 'xbpGet' .or. oXbp:ClassName() = 'xbpDrgComboBox'
        RETURN .F.
      ELSE
        _clearEventLoop(.t.)
        PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)
      endif

     OTHERWISE
      RETURN .F.
    ENDCASE

  CASE nEvent = drgEVENT_FORMDRAWN
    Return ::lSearch

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD C_SKLADY:tabSelect( tabPage, tabNumber)
  ::tabNUM := tabNumber
RETURN .T.