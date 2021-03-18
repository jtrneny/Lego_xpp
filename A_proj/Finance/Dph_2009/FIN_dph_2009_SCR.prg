#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Appedit.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


FUNCTION FIN_dph_2009_obd(nrok, inInsert)
  LOCAL  aCOMBO_val := {}
  LOCAL  bFOR       := IF( inInsert, { || .not. UCETSYS ->lZAVREND }, ;
                                     { ||       UCETSYS ->lZAVREND }  )
/*
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
*/


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
** CLASS for FIN_dph_2009_SCR **************************************************
CLASS FIN_dph_2009_SCR FROM drgUsrClass
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


METHOD FIN_dph_2009_SCR:init(parent)
  ::drgUsrClass:init(parent)

  ::nrok       := uctOBDOBI:FIN:NROK
  ::showDialog := .t.

  drgDBMS:open('UCETSYS')
RETURN self


METHOD FIN_dph_2009_SCR:destroy()
  ::drgUsrClass:destroy()

  ::nrok        := NIL

  if(select('dph_2009') <> 0, DPH_2009 ->(Ads_ClearAOF()), nil)
RETURN


METHOD FIN_dph_2009_SCR:comboBoxInit(drgComboBox)
  LOCAL  nIn
  LOCAL  aROK_zpr   := {}
  LOCAL  aCOMBO_val := {}

  FOrdRec({'UCETSYS,3'})
  UCETSYS ->( DbSetScope( SCOPE_BOTH, 'F'), ;
              DbGoTop()                   , ;
              DbEval( { || If( aSCAN(aCOMBO_val, { |X| X[1] == UCETSYS ->nROK }) == 0, ;
                               AAdd( aCOMBO_val,{ UCETSYS ->NROK, 'ROK _ ' +STRZERO( UCETSYS ->nROK) }), ;
                               NIL ) }, { || ucetsys->nrok > 2008 }) )
  FOrdRec()

  * nen� zalo�en� obdob�
  if len(aCOMBO_val) = 0
    aadd(aCOMBO_val, { 0, '' })
    ::showDialog := .f.
  endif

  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[1] < aY[1] } )
  AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

  drgComboBox:value := ::nrok
RETURN SELF


METHOD FIN_dph_2009_SCR:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse[1]
  ::msg  := drgDialog:oMessageBar             // messageBar
  ::dm   := drgDialog:dataManager             // dataMabanager

  DPH_2009 ->( Ads_SetAof("nROK = " +STR(::nrok,4)), dbGoTop() )

  if .not. ::showDialog
    ConfirmBox( ,'Je m� l�to, ale nelze spustil tuto nab�dku, nejsou spln�ny podm�nky pro zpracov�n� ...', ;
                 'Nelze zpracovat po�adavek ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  else
    ::brow:oXbp:refreshAll()
  endif
RETURN ::showDialog


METHOD FIN_dph_2009_SCR:comboItemSelected(mp1, mp2, o)
  Local  dc := ::drgDialog:dialogCtrl

  IF ::nrok <> mp1:value
    ::nrok := mp1:value
    DPH_2009 ->( Ads_SetAof("nROK = " +STR(::nrok,4)), dbGoTop() )

    dc:oaBrowse:refresh(.T.)
    ::drgDialog:dataManager:refresh()

    SetAppFocus(dc:oaBrowse:oXbp)
  ENDIF
RETURN .T.


*
** RUN METHOD
method FIN_dph_2009_SCR:dph_Delete()
  local oDialog, nExit

  DRGDIALOG FORM 'FIN_DPH_2009_DEL' PARENT ::drgDialog MODAL DESTROY ;
                                    EXITSTATE nExit

  ::drgDialog:dialogCtrl:refreshPostDel()
  ::dm:refresh()
return(nExit != drgEVENT_QUIT)


METHOD FIN_dph_2009_SCR:dph_Insert()
  LOCAL oDialog, nExit

  DRGDIALOG FORM 'FIN_DPH_2009_INS' PARENT ::drgDialog MODAL DESTROY ;
                                    EXITSTATE nExit

  ::drgDialog:dialogCtrl:refreshPostDel()
  ::dm:refresh()
RETURN (nExit != drgEVENT_QUIT)


method fin_dph_2009_scr:dph_Edit()
  local oFile := drgDBMS:getDBD( 'dph_2009' )
  local adesc, pao, adesc_dbd := {}, x
  *
  local cdirW      := drgINI:dir_USERfitm +userWorkDir()
  local cwork_File := cdirW +'\' +'dph_2009wx'

  if dph_2009->nobdobi <> 0
    adesc := oFile:desc

    for x :=  1 to Len(adesc) STEP 1
      pao       := adesc[x]
      AAdd( adesc_dbd, {pao:name, pao:type, pao:len, pao:dec})
    next

    myCreateDir( cdirW )
    dbCreate( cwork_File, adesc_dbd, 'FOXCDX')
    dbUseArea( .t., 'FOXCDX', cwork_File, 'dph_2009wx')
    mh_copyFld( 'dph_2009', 'dph_2009wx', .t.)

    APPEDIT ALIAS 'DPH_2009wx' ;
      STYLE PLAIN              ;
      HEADING 'Oprava da�ov�ho p�izn�n� za obdobi ' +str(dph_2009->nobdobi) +'/' +str(dph_2009->nrok) ;
      POSITION CENTER,CENTER ;
      NOACTION APPACTION_NONAVIGATION +APPACTION_NOINSERT+ APPACTION_NODELETE ;
      FONT '8.Arial CE'
    APPDISPLAY

    if dph_2009->( dbRLock())
      mh_copyFld( 'dph_2009wx', 'dph_2009' )
      dph_2009->(dbRUnlock())
    endif

    dph_2009wx->( dbCloseArea())
  endif
return self