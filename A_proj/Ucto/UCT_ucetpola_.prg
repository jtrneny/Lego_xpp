#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


FUNCTION UCT_ucetpola_INF()  ;  RETURN( ' ' +UCT_main_INF('UCETPOLA'))
FUNCTION UCT_ucetpola_OBD()  ;  RETURN( STR(UCETPOLA ->nROK) +'/' +STR(UCETPOLA ->nOBDOBI))
FUNCTION UCT_ucetpola_TIP()  ;  RETURN( If( UCTDOKHDw ->nTYPOBRATU == 1, 'DAL', 'MD ' ))


**
** CLASS for FRM UCT_ucetpola_SCR **********************************************
CLASS UCT_ucetpola_SCR FROM drgUsrClass
EXPORTED:
  VAR     cDENIK

  METHOD  Init
  METHOD  comboItemSelected
  METHOD  itemSelected

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected()
    CASE nEvent = drgEVENT_DELETE
      RETURN .T.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

ENDCLASS


METHOD UCT_ucetpola_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::cDENIK := 'A'

  drgDBMS:open('UCETPOLA')
  drgDBMS:open('C_UCTOSN')
  drgDBMS:open('UCETSYS')

  // relace //
  UCETPOLA ->( DbSetRelation( 'C_UCTOSN', { || UPPER(UCETPOLA->CUCETMD) }))
RETURN self


METHOD UCT_ucetpola_SCR:comboItemSelected(mp1, mp2, o)
  LOCAL  dc     := ::drgDialog:dialogCtrl

  IF ::cDENIK <> mp1:value
    UCETPOLA ->( Ads_SetAof("cDENIK = '" +mp1:value +"'"), ;
                 dbGoTop()                                   )

    dc:oaBrowse:refresh(.T.)
    SetAppFocus(dc:oaBrowse:oXbp)
  ENDIF
RETURN .T.


METHOD UCT_ucetpola_SCR:itemSelected()
  Local  nRECs  := UCETPOLA ->(RECNO())
  Local  nORDs  := UCETPOLA ->(OrdSetFocus())
  Local  oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'UCT_ucetpola_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

  UCETPOLA ->(OrdSetFocus(nORDs), DBGoTo(nRECs))

Return self


**
** CLASS for FRM UCT_ucetpola_CRD **********************************************
CLASS UCT_ucetpola_CRD FROM drgUsrClass
EXPORTED:
  METHOD  Init

ENDCLASS


METHOD UCT_ucetpola_CRD:Init(parent)
  Local  cSCOPe  := UPPER(UCETPOLA ->cDENIK) +STRZERO(UCETPOLA ->nDOKLAD,10)

  ::drgUsrClass:init(parent)

  UCETPOLA ->( ORDsetFOCUS( AdsCtag( 1 )), DbSetScope(SCOPE_BOTH, cScope), DBGoTop())
  drgDBMS:open('UCTDOKHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  mh_COPYFLD('UCETPOLA', 'UCTDOKHDw', .t., .t.)
  UCTDOKHDw ->cUCET_UCT := If( UCETPOLA ->cTYP_R == 'DAL', UCETPOLA ->cUCETdal, UCETPOLA ->cUCETmd )
  UCTDOKHDw ->dPORIZDOK := UCETPOLA ->dDATPORIZ
  UCTDOKHDw ->cTEXTDOK  := UCETPOLA ->cTEXT

  Do While !UCETPOLA ->( EOF())
    UCTDOKHDw ->nCENzakCEL += UCETPOLA ->nKCmd
    UCETPOLA  ->( dbSkip())
  EndDo
RETURN self