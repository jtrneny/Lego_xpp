#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Appedit.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


FUNCTION FIN_dph_2004_obd(nrok, inInsert)
  LOCAL  aCOMBO_val := {}
  LOCAL  bFOR       := IF( inInsert, { || .not. UCETSYS ->lZAVREND }, ;
                                     { ||       UCETSYS ->lZAVREND }  )

  FOrdRec({'UCETSYS,3'})
  UCETSYS ->( DbSetScope( SCOPE_BOTH, 'F' +StrZero(nrok,4)), ;
              DbGoTop()                                      , ;
              DbEval( { || ;
              IF(( nIn := AScan( aCOMBO_val, { |X| X[1] == UCETSYS ->cOBDOBIDAN })) == 0, ;
                         AAdd( aCOMBO_val, ;
                               { UCETSYS ->cOBDOBIDAN                                        , ;
                                 StrZero(UCETSYS ->nOBDOBI,2) +'/' +StrZero(UCETSYS ->nROK,4), ;
                                 {UCETSYS ->(RecNo())} }                                       ), ;
                         AAdd( aCOMBO_val[nIn,3], UCETSYS ->(RecNo()) ) ) }, ;
                         bFOR  ) )
  FOrdRec()
RETURN aCOMBO_val


**
** CLASS for FIN_dph_2004_SCR **************************************************
CLASS FIN_dph_2004_SCR FROM drgUsrClass
EXPORTED:
  method  init, destroy, drgDialogStart, comboBoxInit, comboItemSelected
  *
  ** RUN METHOD
  method  dph_Delete, dph_Insert, dph_Edit
  var     nrok

  **
  ** EVENT *********************************************************************
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  nRECs

    do case
    case nEvent = xbeBRW_ItemMarked
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)
      return .f.

    CASE nEvent = drgEVENT_APPEND
      RETURN .T.

    CASE nEvent = drgEVENT_EDIT
      RETURN .T.

    CASE nEvent = drgEVENT_DELETE
      RETURN .T.

    CASE nEvent = drgEVENT_SAVE
       RETURN .T.

    CASE nEvent = xbeP_Keyboard
      IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  var   msg, dm
ENDCLASS


METHOD FIN_dph_2004_SCR:init(parent)
  ::drgUsrClass:init(parent)

  ::nrok := uctOBDOBI:FIN:NROK

  drgDBMS:open('UCETSYS')
RETURN self


METHOD FIN_dph_2004_SCR:destroy()
  ::drgUsrClass:destroy()

  ::nrok        := NIL

  if(select('dph_2004') <> 0, DPH_2004 ->(Ads_ClearAOF()), nil)
RETURN


METHOD FIN_dph_2004_SCR:comboBoxInit(drgComboBox)
  LOCAL  nIn
  LOCAL  aROK_zpr   := {}
  LOCAL  aCOMBO_val := {}, nrok := ::nrok

  FOrdRec({'UCETSYS,3'})
  UCETSYS ->( DbSetScope( SCOPE_BOTH, 'F'), ;
              DbGoTop()                   , ;
              DbEval( { || If( aSCAN(aCOMBO_val, { |X| X[1] == UCETSYS ->nROK }) == 0, ;
                               AAdd( aCOMBO_val,{ UCETSYS ->NROK, 'ROK _ ' +STRZERO( UCETSYS ->nROK) }), ;
                               NIL ) }, { || ucetsys->nrok < 2009 } ) )
  FOrdRec()

  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[1] < aY[1] } )
  AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

  if ascan( aCOMBO_val, {|x| x[1] = nrok} ) = 0
    ::nrok := atail(aCOMBO_val)[1]
  endif

  drgComboBox:value := ::nrok
RETURN SELF


METHOD FIN_dph_2004_SCR:drgDialogStart(drgDialog)

  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager

  DPH_2004 ->( Ads_SetAof("nROK = " +STR(::nrok,4)), dbGoTop() )
RETURN self


METHOD FIN_dph_2004_SCR:comboItemSelected(mp1, mp2, o)
  Local  dc := ::drgDialog:dialogCtrl

  IF ::nrok <> mp1:value
    ::nrok := mp1:value
    DPH_2004 ->( Ads_SetAof("nROK = " +STR(::nrok,4)), dbGoTop() )

    dc:oaBrowse:refresh(.T.)
    ::drgDialog:dataManager:refresh()

    SetAppFocus(dc:oaBrowse:oXbp)
  ENDIF
RETURN .T.


*
** RUN METHOD
method FIN_dph_2004_SCR:dph_Delete()
  local oDialog, nExit

  DRGDIALOG FORM 'FIN_DPH_2004_DEL' PARENT ::drgDialog MODAL DESTROY ;
                                    EXITSTATE nExit

  ::drgDialog:dialogCtrl:refreshPostDel()
  ::dm:refresh()
return(nExit != drgEVENT_QUIT)


METHOD FIN_dph_2004_SCR:dph_Insert()
  LOCAL oDialog, nExit

  DRGDIALOG FORM 'FIN_DPH_2004_INS' PARENT ::drgDialog MODAL DESTROY ;
                                    EXITSTATE nExit

  ::drgDialog:dialogCtrl:refreshPostDel()
  ::dm:refresh()
RETURN (nExit != drgEVENT_QUIT)


method fin_dph_2004_scr:dph_Edit()

  if dph_2004->nobdobi <> 0
    APPEDIT ALIAS 'DPH_2004' ;
      STYLE PLAIN            ;
      HEADING 'Oprava daòového pøiznání za obdobi ' +str(dph_2004->nobdobi) +'/' +str(dph_2004->nrok) ;
      POSITION CENTER,CENTER ;
      NOACTION APPACTION_NONAVIGATION +APPACTION_NOINSERT+ APPACTION_NODELETE ;
      FONT '8.Arial CE'
    APPDISPLAY
  endif
return self
