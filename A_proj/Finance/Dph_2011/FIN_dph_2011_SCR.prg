#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Appedit.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


FUNCTION FIN_dph_2011_obd(nrok, inInsert)
  LOCAL  aCOMBO_val := {}
  LOCAL  bFOR       := IF( inInsert, { || .not. UCETSYS ->lZAVREND }, ;
                                     { ||       UCETSYS ->lZAVREND }  )

  FOrdRec({'UCETSYS,3'})
  UCETSYS ->( DbSetScope( SCOPE_BOTH, 'F' +StrZero(nrok,4)), ;
              DbGoTop()                                      , ;
              DbEval( { || ;
              IF(( nIn := AScan( aCOMBO_val, { |X| X[1] == UCETSYS ->cOBDOBIDAN })) == 0, ;
                         AAdd( aCOMBO_val, ;
                               { UCETSYS ->cOBDOBIDAN                                       , ;
                                 left(ucetsys->cobdobiDan,3) +strZero(ucetsys->nrok,4)      , ;
                                 {UCETSYS ->(RecNo())} }                                       ), ;
                         AAdd( aCOMBO_val[nIn,3], UCETSYS ->(RecNo()) ) ) }, ;
                         bFOR  ) )
  FOrdRec()

RETURN aCOMBO_val


**
** CLASS for FIN_dph_2011_SCR **************************************************
CLASS FIN_dph_2011_SCR FROM drgUsrClass
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
  var   brow, msg, dm, showDialog
ENDCLASS


METHOD FIN_dph_2011_SCR:init(parent)
  ::drgUsrClass:init(parent)

  ::nrok       := uctOBDOBI:FIN:NROK
  ::showDialog := .t.

  drgDBMS:open('UCETSYS')
RETURN self


METHOD FIN_dph_2011_SCR:destroy()
  ::drgUsrClass:destroy()

  ::nrok        := NIL

  if(select('dph_2011') <> 0, DPH_2011 ->(Ads_ClearAOF()), nil)
RETURN


METHOD FIN_dph_2011_SCR:comboBoxInit(drgComboBox)
  LOCAL  nIn
  LOCAL  aROK_zpr   := {}
  LOCAL  aCOMBO_val := {}

  FOrdRec({'UCETSYS,3'})
  UCETSYS ->( DbSetScope( SCOPE_BOTH, 'F'), ;
              DbGoTop()                   , ;
              DbEval( { || If( aSCAN(aCOMBO_val, { |X| X[1] == UCETSYS ->nROK }) == 0, ;
                               AAdd( aCOMBO_val,{ UCETSYS ->NROK, 'ROK _ ' +STRZERO( UCETSYS ->nROK,4) }), ;
                               NIL ) }, { || ucetsys->nrok > 2010 }) )
  FOrdRec()

  * není založené období
  if len(aCOMBO_val) = 0
    aadd(aCOMBO_val, { 0, '' })
    ::showDialog := .f.
  endif

  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[1] < aY[1] } )
  AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

  drgComboBox:value := ::nrok
RETURN SELF


METHOD FIN_dph_2011_SCR:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse[1]
  ::msg  := drgDialog:oMessageBar             // messageBar
  ::dm   := drgDialog:dataManager             // dataMabanager

  DPH_2011 ->( Ads_SetAof("nROK = " +STR(::nrok,4)), dbGoTop() )

  if .not. ::showDialog
    ConfirmBox( ,'Je mì líto, ale nelze spustil tuto nabídku, nejsou splnìny podmínky pro zpracování ...', ;
                 'Nelze zpracovat požadavek ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  else
    ::brow:oXbp:refreshAll()
  endif
RETURN ::showDialog


METHOD FIN_dph_2011_SCR:comboItemSelected(mp1, mp2, o)
  Local  dc := ::drgDialog:dialogCtrl

  IF ::nrok <> mp1:value
    ::nrok := mp1:value
    DPH_2011 ->( Ads_SetAof("nROK = " +STR(::nrok,4)), dbGoTop() )

    dc:oaBrowse:refresh(.T.)
    ::drgDialog:dataManager:refresh()

    SetAppFocus(dc:oaBrowse:oXbp)
  ENDIF
RETURN .T.


*
** RUN METHOD
method FIN_dph_2011_SCR:dph_Delete()
  local oDialog, nExit

  DRGDIALOG FORM 'FIN_DPH_2011_DEL' PARENT ::drgDialog MODAL DESTROY ;
                                    EXITSTATE nExit

  ::drgDialog:dialogCtrl:refreshPostDel()
  ::dm:refresh()
return(nExit != drgEVENT_QUIT)


METHOD FIN_dph_2011_SCR:dph_Insert()
  LOCAL oDialog, nExit

  DRGDIALOG FORM 'FIN_DPH_2011_INS' PARENT ::drgDialog MODAL DESTROY ;
                                    EXITSTATE nExit

  ::drgDialog:dialogCtrl:refreshPostDel()
  ::dm:refresh()
RETURN (nExit != drgEVENT_QUIT)


method fin_dph_2011_scr:dph_Edit()
  local oFile := drgDBMS:getDBD( 'dph_2011' )
  local adesc, pao, adesc_dbd := {}, x
  *
  local cdirW      := drgINI:dir_USERfitm +userWorkDir()
  local cwork_File := cdirW +'\' +'dph_2011wx'

  if dph_2011->nobdobi <> 0
    adesc := oFile:desc

    for x :=  1 to Len(adesc) STEP 1
      pao       := adesc[x]

      if lower(pao:type) = 's'
      else
        AAdd( adesc_dbd, {pao:name, pao:type, pao:len, pao:dec})
      endif
    next

    myCreateDir( cdirW )
    dbCreate( cwork_File, adesc_dbd, 'FOXCDX')
    dbUseArea( .t., 'FOXCDX', cwork_File, 'dph_2011wx')
    mh_copyFld( 'dph_2011', 'dph_2011wx', .t.)

    APPEDIT ALIAS 'DPH_2011wx' ;
      STYLE PLAIN              ;
      HEADING 'Oprava daòového pøiznání za obdobi ' +str(dph_2011->nobdobi) +'/' +str(dph_2011->nrok) ;
      POSITION CENTER,CENTER ;
      NOACTION APPACTION_NONAVIGATION +APPACTION_NOINSERT+ APPACTION_NODELETE ;
      FONT '8.Arial CE'
    APPDISPLAY

    if dph_2011->( dbRLock())
      mh_copyFld( 'dph_2011wx', 'dph_2011' )
      dph_2011->(dbRUnlock())
    endif

    dph_2011wx->( dbCloseArea())
  endif
return self