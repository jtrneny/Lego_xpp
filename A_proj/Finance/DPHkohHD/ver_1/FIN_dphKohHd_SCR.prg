#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Appedit.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


*
** CLASS for FIN_dphkohhd_SCR **************************************************
CLASS FIN_dphKohHd_SCR FROM drgUsrClass
EXPORTED:
  method  init, destroy, drgDialogStart, comboBoxInit, comboItemSelected
  method  tabSelect, itemMarked
  *
  ** RUN METHOD
  method  dph_Insert, dph_Delete, dph_Edit
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
  var   brow, msg, dm, dc, showDialog
  var   coddil
ENDCLASS


METHOD FIN_dphKohHd_SCR:init(parent)
  ::drgUsrClass:init(parent)

  ::nrok       := uctOBDOBI:FIN:NROK
  ::coddil     := ''
  ::showDialog := .t.

  drgDBMS:open('UCETSYS')
RETURN self


METHOD FIN_dphKohHD_SCR:destroy()
  ::drgUsrClass:destroy()

  ::nrok        := NIL

  if(select('dphKohHd') <> 0, dphKohHd ->(Ads_ClearAOF()), nil)
RETURN


METHOD FIN_dphKohHd_SCR:comboBoxInit(drgComboBox)
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


METHOD FIN_dphKohHd_SCR:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse[1]
  ::msg  := drgDialog:oMessageBar             // messageBar
  ::dc     := drgDialog:dialogCtrl            // dataCtrl
  ::dm   := drgDialog:dataManager             // dataMananager

  dphKohHd ->( Ads_SetAof("nROK = " +STR(::nrok,4)), dbGoTop() )

  if .not. ::showDialog
    ConfirmBox( ,'Je mì líto, ale nelze spustil tuto nabídku, nejsou splnìny podmínky pro zpracování ...', ;
                 'Nelze zpracovat požadavek ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  else
    ::brow:oXbp:refreshAll()
  endif
RETURN ::showDialog


METHOD FIN_dphKohHd_SCR:comboItemSelected(mp1, mp2, o)
  Local  dc := ::drgDialog:dialogCtrl

  IF ::nrok <> mp1:value
    ::nrok := mp1:value
    dphKohHd ->( Ads_SetAof("nROK = " +STR(::nrok,4)), dbGoTop() )

    dc:oaBrowse:refresh(.T.)
    ::drgDialog:dataManager:refresh()

    SetAppFocus(dc:oaBrowse:oXbp)
  ENDIF
RETURN .T.


METHOD FIN_dphKohHd_SCR:tabSelect(oTabPage,tabnum)

  ::coddil := otabPage:subs
  ::itemMarked()
return .t.


METHOD FIN_dphKohHd_SCR:itemMarked()
  local  cky        := dphKohHd->cidHlaseni +::coddil
  local  pa_oBrowse := ::dc:oBrowse

  dphKohit->( dbsetScope(SCOPE_BOTH, cky), dbgoTop())
  aeval( pa_oBrowse, { |o| o:oxbp:refreshAll() }, 2 )
return self


*
** RUN METHOD
METHOD FIN_dphKohHd_SCR:dph_Insert()
  LOCAL  oDialog, nExit
  local  pa_oBrowse := ::dc:oBrowse

  DRGDIALOG FORM 'FIN_dphKohHD_INS' PARENT ::drgDialog MODAL DESTROY ;
                                    EXITSTATE nExit

  ::dc:refreshPostDel()
  ::coddil := ''
  ::itemMarked()

*  ::drgDialog:dialogCtrl:refreshPostDel()
*  aeval( pa_oBrowse, { |o| o:oxbp:refreshAll() } )
RETURN (nExit != drgEVENT_QUIT)


method FIN_dphkohhd_SCR:dph_Delete()
  local  sid, nsel, nodel := .f.
  local  pa_oBrowse := ::dc:oBrowse
  *
  local  cStatement, oStatement
  local  stmt     := "delete from %file where %c_sid = %sid"
  local  pa_files := { { 'dphKohHd', 'sid' }, { 'dphKohIt', 'ndphKohlHd' } }, x

  if ( sid := dphKohHd->sid ) <> 0

    nsel := ConfirmBox( ,'Požadujete zrušit Kontrolní hlášení o DPH _' +allTrim(dphKohHd->cidHlaseni) +'_' +CRLF +CRLF, ;
                         'Zrušení kontrolního hlášení ...' , ;
                          XBPMB_YESNO                      , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

    if nsel <> XBPMB_RET_YES
      return .t.
    endif

    for x := 1 to len(pa_files) step 1
      cStatement := strTran( stmt      , '%file' , pa_files[x,1]    )
      cStatement := strTran( cStatement, '%c_sid', pa_files[x,2]    )
      cStatement := strTran( cStatement, '%sid'  , allTrim(str(sid)))

      oStatement := AdsStatement():New(cStatement, oSession_data)

      if oStatement:LastError > 0
        *  return .f.
      else
        oStatement:Execute( 'test', .f. )
      endif

      oStatement:Close()

      (pa_files[x,1])->(dbUnlock(), dbCommit())
    next

    dphKohhd->(dbskip())

    ::dc:refreshPostDel()
    ::coddil := ''
    ::itemMarked()
  endif
return self


method fin_dphkohhd_scr:dph_Edit()
  local oFile := drgDBMS:getDBD( 'dph_2015' )
  local adesc, pao, adesc_dbd := {}, x
  *
  local cdirW      := drgINI:dir_USERfitm +userWorkDir()
  local cwork_File := cdirW +'\' +'dph_2015wx'

  if dph_2015->nobdobi <> 0
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
    dbUseArea( .t., 'FOXCDX', cwork_File, 'dph_2015wx')
    mh_copyFld( 'dph_2015', 'dph_2015wx', .t.)

    APPEDIT ALIAS 'DPH_2015wx' ;
      STYLE PLAIN              ;
      HEADING 'Oprava daòového pøiznání za obdobi ' +str(dph_2015->nobdobi) +'/' +str(dph_2015->nrok) ;
      POSITION CENTER,CENTER ;
      NOACTION APPACTION_NONAVIGATION +APPACTION_NOINSERT+ APPACTION_NODELETE ;
      FONT '8.Arial CE'
    APPDISPLAY

    if dph_2015->( dbRLock())
      mh_copyFld( 'dph_2015wx', 'dph_2015' )
      dph_2015->(dbRUnlock())
    endif

    dph_2015wx->( dbCloseArea())
  endif
return self