#include "ActiveX.ch"
#include "appevent.ch"
#include "Common.ch"
#include "drg.ch"
#include 'gra.ch'
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\Asystem++\Asystem++.ch"

#PRAGMA LIBRARY( "XPPUI2.LIB" )
#pragma library ( "OT4XB.LIB" )
#PRAGMA LIBRARY( "ASCOM10.LIB" )


**
** CLASS for FRM VYR_operTree_EX_scr ******************************************
CLASS KAN_ukolTree_EX_scr FROM drgUsrClass
EXPORTED:
  METHOD  init, drgDialogStart
  method  eventHandled, treeItemMarked, treeItemSelected
  *
  METHOD  postValidate, postSave, postDelete
  METHOD  tabSelect
  *
  method  kan_ukoly_crd
  **
  var     oTree, oTreeItem
  VAR     msg, dm, dc, df, ab, brow


  inline method destroy()

    ::drgUsrClass:destroy()
  return self


HIDDEN:
  method ex_fillTree

  var    sid_ukoly_Root       // sid   základního úkolu
  var    rec_ukoly_Root       // recNo základního úkolu
  VAR    members, state       // 0 - inBrowse  1 - inEdit  2 - inAppend
  var    lnewRec
  var    tabNum, m_file, a_files, is_intree
  var    oinfo_text, o_cucet

  inline method restColor()
    local members := ::df:aMembers
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
  return

  inline method setfocus(state)
    local  members := ::df:aMembers, pos

    ::state := isnull(state,0)

    do case
    case(::state = 2)
      PostAppEvent(drgEVENT_APPEND,,,::brow)
      SetAppFocus(::brow)
    otherwise
      pos := ascan(members,{|X| (x = ::brow:cargo)})
      ::df:olastdrg   := ::brow:cargo
      ::df:nlastdrgix := pos -1
      ::df:olastdrg:setFocus()
      if isobject(::brow)
        PostAppEvent(xbeBRW_ItemMarked,,,::brow)
        ::brow:refreshCurrent():hilite()
      endif
    endcase
  return

  * reakce na ESC
  inline method esc_focustobrow( refreshAll )

    default refreshAll To .f.

    ::restColor()
    ::setfocus()
    if refreshAll
      ::brow:refreshAll():hilite()
    else
      ::brow:refreshCurrent():hilite()
    endif

    ::dm:refresh()
  return
ENDCLASS


METHOD KAN_ukolTree_EX_scr:init(parent)
  local  pa_initParam
  local  cf := "UKOLY = %%", filter, sid_ukoly

  ::drgUsrClass:init(parent)

  ::lnewRec        := .f.
  ::sid_ukoly_Root := 0

  ::state     := 0
  ::tabNum    := 1
  ::a_files   := { 'c_uctosn', 'c_syntuc', 'c_grupuc', 'c_triduc' }
  ::m_file    := 'c_uctosn'
  ::is_intree := .t.

  drgDBMS:open( 'ukoly'    )
  drgDBMS:open( 'vazUkoly' )

  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    ukoly->( dbgoto( val(pa_initParam[2])))

    ::rec_ukoly_Root := ukoly->( recNo())
    ::sid_ukoly_Root := ukoly->sid
    filter    := format( cf, {::sid_ukoly_Root} )
    vazUkoly->( ordSetFocus('VAZUKOLY1'), ads_setAof(filter), dbgotop() )
  endif
RETURN self


METHOD KAN_ukolTree_EX_scr:drgDialogStart(drgDialog)
  local x, odrgTree

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

  ::members  := drgDialog:oForm:aMembers

  for x := 1 to len(::members)
    if ::members[x]:className() = 'drgText' .and. .not. empty(::members[x]:groups)
      if ::members[x]:groups = 'INFO'
        ::oinfo_text := ::members[x]
      endif
    endif

    if( ::members[x]:className() = 'drgTreeView', odrgTree := ::members[x], nil )
  next

  ::ex_fillTree(odrgTree)
RETURN self


METHOD KAN_ukolTree_EX_scr:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL  nBRo, nCOLn, nRESc, nIn
  LOCAL  cC
  LOCAL  dbArea   := Lower( Alias( ::dc:dbArea ))

  do case
  case nevent = xbeBRW_ItemMarked
    ::msg:editState:caption := 0
    ::msg:WriteMessage(,0)
    ::state := 0

    if(isobject(::brow), ::brow:hilite(), nil)
    ::restColor()

    ::o_cucet:odrg:isEdit := .F.
***    ::o_cucet:odrg:oxbp:disable()
    RETURN .F.

  CASE (nEvent = xbeP_Selected)
    ::postValidate(oXbp:cargo:oVar, .T., oxbp)
    RETURN .F.

  case nevent = drgEVENT_APPEND
    ::lnewRec := .t.
    ::KAN_ukoly_CRD()

  case nevent = drgEVENT_EDIT
    ::lnewRec := .f.
    ::KAN_ukoly_CRD()

  case nevent = drgEVENT_DELETE


  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.


METHOD KAN_ukolTree_EX_scr:treeItemMarked( oItem, aRect, oXbp)
  Local cKey
  LOCAL nEvent := mp1 := mp2 := nil
  *
  local  oItems, h, recNo, sid, caption, lis_Edit := .f.
  local  oColumn, ncolor_ex

  nEvent := LastAppEvent(@mp1,@mp2)
  _clearEventLoop(.T.)


  * Synchronizace s KusTREE
  oItems  := ::oTree:Items()
  h       := oItems:SelectedItem(0)
  recNo   := oItems:CellData( h, 0)
  sid     := oItems:ItemData( h )
  caption := oItems:CellCaption( h, 0)

  if( isNumber(recNo), ukoly->( dbGoTO( recNo)), nil )

  ::dataManager:refresh()
  PostAppEvent( drgEVENT_SELECT,,, ::oTree)
  *
//  if( (empty(kusTree->ccisZakaz) .and. .not. kusTree->lnakPol), ::pb_vyrZak_crd:oxbp:show(), ;
//
/*                                                              ::pb_vyrZak_crd:oxbp:hide()  )
  *
  IF ::tabNUM = tab_INFO
    IF KusTREE->lNakPol
      NakPol->( dbSeek( Upper(KusTree->cSklPol),,'NAKPOL1'))
    ENDIF
    ::nSpMnoSkl := PrepocetMJ( KusTree->nSpMno, KusTree->cMjSpo, NAKPOL->cZkratJedn , 'NAKPOL' )
    ::dataManager:refresh()

  ELSEIF ::tabNUM = tab_OPERACE
    * Pokus nedošlo k uložení karty KUSOV, nastav filter a refrešní browse operací
    IF .not. ::lSaveKusovCrd
      ::aRec := VYR_ScopeOPER()
      ::sumColumn()
      ::dc:oBrowse[1]:oXbp:refreshAll()

      ::dc:sp_resetActiveArea( ::dc:oBrowse[1], .f., .f. )
    ENDIF

  ELSEIF ::tabNUM = tab_SKLADY
    IF KusTree->lNakPol
      cKey := KusTree->cSklPol
    ELSE
      cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol) + StrZero( KusTree->nVarPoz,3)
      VyrPol_s->( dbSeek( cKey,, 'VYRPOL1'))
      cKey := VyrPOL_s->cSklPol
    ENDIF
    CenZBOZ->( mh_SetSCOPE( cKey))
    ::dc:oBrowse[2]:oXbp:refreshAll()

    ::dc:sp_resetActiveArea( ::dc:oBrowse[2], .f., .f. )
  ENDIF
*/
  *

  do case
  case aRect = xbeK_INS // .and. KusTree->( RecNo()) <> 1
    ( ::lnewRec := .t., lis_Edit := .T. )
    PostAppEvent(drgEVENT_APPEND,,,::oTree)

  case aRect = xbeK_ENTER
    ( ::lnewRec := .f., lis_Edit := .t. )
    PostAppEvent(drgEVENT_EDIT  ,,,::oTree)
  case aRect = xbeK_CTRL_DEL
    PostAppEvent(drgEVENT_DELETE,,,::oTree)
  endCase
RETURN SELF



method KAN_ukolTree_EX_scr:treeItemSelected( oItem, aRect, oXbp)
  LOCAL nEvent, mp1, mp2

*  IF ! ::lNewRec .and. KusTree->( RecNo()) = 1
    * Nelze opravovat vazbu vrcholového výrobku, nebo neexistuje
*  ELSE
    ::KAN_ukoly_CRD()
    *
    SetAppFocus( oXbp)
    oXbp:setData( ::oTreeItem)
*  ENDIF
RETURN SELF


method KAN_ukolTree_EX_scr:KAN_ukoly_CRD()
  lOCAL  oDialog, nExit
  local  oItems, h, hc, sid

  oDialog       := drgDialog():new('KAN_ukoly_CRD',::drgDialog)
  oDialog:cargo :=  IF( ::lnewRec, drgEVENT_APPEND, drgEVENT_EDIT)
  oDialog:create(,self:drgDialog:dialog,.F.)

  if oDialog:exitState != drgEVENT_QUIT
     oItems  := ::oTree:Items()
     h       := oItems:SelectedItem(0)
     sid     := oItems:ItemData( h )

     if ::lnewRec
       vazUkoly->( dbAppend())
       vazUkoly->ukoly   := ::sid_ukoly_Root
       vazUkoly->npolVys := sid
       vazUkoly->npolNiz := ukoly->sid

       vazUkoly->( dbCommit(), dbgoTop())
/*
       if .not. empty( kusTree->( Ads_getAof()))
         kusTree->( Ads_clearAof(), dbGoTop())
       endif
       ::oTree:ClearFilter()
*/
     endif

     ukoly   ->( dbGoTo(::rec_ukoly_Root))
     vazUkoly->( dbgoTop())

     ::oTree:BeginUpdate()
       oItems:RemoveAllItems()

       ::ex_fillTree(::oTree:parent:cargo)   // xbpTreeView

       // postavit se na nový, nebo opravovaný záznam asi podle sid
       if ( hc := oItems:FindItemData(sid) ) <> 0
         oItems:setProperty("SelectItem", hc, .t. )
         oItems:EnsureVisibleItem(hc)
      endif

     ::oTree:EndUpdate()
   endif

  oDialog:destroy(.T.)
  oDialog := NIL
return self


method KAN_ukolTree_EX_scr:ex_fillTree(drgObj)
  local  oColumns, oColumn, citem
  local  anode := {}, asubNode := {}, nvyrST, wvyrST
  local  vysPol
  *
  local  hRoot, h
  local  oFont_task  := XbpFont():new():create( "10.Helvetica BOLD" )
  local  nColor_task := AutomationTranslateColor( GRA_CLR_BLUE, .f. )
  local  nColor_vyr  := AutomationTranslateColor( GRA_CLR_DARKGREEN, .f. )

  local  oBord, apos, asize
  local  ccisZakaz
  *
  local  npolVys, npolNiz
  local  pa_ukoly    := {}, x


   if .not. isObject(::oTree)
    oBord := drgObj:oBord
    apos  := drgObj:oxbp:currentPos()
    asize := drgObj:oxbp:currentSize()

    ::oTree := XbpActiveXControl():new( oBord )
    ::oTree:CLSID  := "Exontrol.Tree.1" // {3C5FC763-72BA-4B97-9985-81862E9251F2}
    ::oTree:create(,, apos, asize )

    drgObj:oxbp:hide()
    drgObj:oxbp := ::oTree
  endif

  ::oTree:LinesAtRoot   := -1           // exLinesAtRoot
  ::oTree:hasLines      :=  1           // .t.   0, -1, 1, 2
  ::oTree:DrawGridLines := -1           /*exAllLines*/
  ::oTree:ExpandOnDblClick := .f.

  ::oTree:LbDblClick    := { ||     ::treeItemMarked(::oTree, xbeK_ENTER ) }
  ::oTree:KeyBoard      := { |nkey| ::treeItemMarked(::oTree, nkey) }

//***
  if ::oTree:Columns:Count() = 0 // init, nebo chce pùvodní nastavení Tree

    oColumn              := ::oTree:Columns():Add("název úkolu")
    oColumn:AllowSort    := .f.
    oColumn:SetProperty("Def",  3, .T.)    // exCellHasCheckBox//
    oColumn:SetProperty("Def",17/*exCellCaptionFormat*/,1)
    oColumn:PartialCheck := .T.
    **
    oColumn:SetProperty("Def",17/*exCellCaptionFormat*/,1)
//    oColumn:Width := 150
    oColumn:DisplayFilterButton := .T.
    ::oTree:SetProperty("Description",3/*exFilterBarFilterForCaption*/,"new caption")

    * 1
    oColumn := ::oTree:Columns():Add("rPos")
    oColumn:FormatColumn := "1 rpos ``"
    oColumn:AllowSort := .F.
    oColumn:SetProperty("Def",4/*exCellBackColor*/,15790320)
    oColumn:SetProperty("Def",5/*exCellForeColor*/,8421504)
    oColumn:SetProperty("Def",8/*exHeaderForeColor*/,oColumn:Def(5/*exCellForeColor*/))
    oColumn:Position  := 0

    * 2
    oColumn := ::oTree:Columns():Add("typÚkolu")
    oColumn:Width     := 130
    oColumn:AllowSort := .f.
    oColumn:Position  := 1

    * 3
    oColumn := ::oTree:Columns():Add("øešitel")
    oColumn:Width     := 250
    oColumn:AllowSort := .f.

    * 4
    oColumn := ::oTree:Columns():Add("datZac_pl")
    oColumn:width     := 100
    oColumn:AllowSort := .f.

    * 5
    oColumn := ::oTree:Columns():Add("datKon_pl")
    oColumn:width     := 80
    oColumn:AllowSort    := .f.

    * 6
    oColumn := ::oTree:Columns():Add("datZac_uk")
    oColumn:width     := 80
    oColumn:AllowSort := .f.

    * 7
    oColumn := ::oTree:Columns():Add("datKon_uk")
    oColumn:width     := 80
    oColumn:AllowSort := .f.

    oColumn := ::oTree:Columns():Add("recNo")
    oColumn:AllowSort := .f.
    oColumn:setProperty( "Visible", .f. )
  else

    oColumn := ::oTree:Columns():Item("název úkolu")
  endif

  oItems := ::oTree:Items()
  hRoot  := oItems:addItem(ukoly->cnazUkolu)
            oItems:setProperty( "CellFont"     , hRoot, 0, oFont_task )
            oItems:setProperty( "CellForeColor", hRoot, 0, nColor_task)

            oItems:SetProperty("CellCaption"    ,hRoot, 2, ukoly->ctypUkolu       )
            oItems:SetProperty("CellCaption"    ,hRoot, 3, ukoly->cJmeRozlRe      )
            oItems:SetProperty("CellCaption"    ,hRoot, 4, dtoc(ukoly->dplZacUkol))
            oItems:SetProperty("CellCaption"    ,hRoot, 5, dtoc(ukoly->dplKonUkol))
            oItems:SetProperty("CellCaption"    ,hRoot, 6, dtoc(ukoly->dzacUkolu ))
            oItems:SetProperty("CellCaption"    ,hRoot, 7, dtoc(ukoly->dkonUkolu ))
            oItems:SetProperty("ExpandItem"     ,hRoot,.T.)

            oItems:SetProperty("CellData"       ,hRoot, 0,ukoly->( recno()))
            oItems:SetProperty("ItemData"       ,hRoot,   ukoly->sID       )

            aadd( pa_ukoly, { ukoly->sid, hRoot } )


  do while .not. vazUkoly->( eof())
    npolVys := vazUkoly->npolVys
    npolNiz := vazUkoly->npolNiz

    if( npos := ascan( pa_ukoly, { |u| u[1] = npolVys } )) <> 0  .and. npolNiz <> 0

      hParent := pa_ukoly[npos,2]
      ukoly->( dbseek( npolNiz,,'ID'))

      h := oItems:InsertItem( hParent,, ukoly->cnazUkolu )
           oItems:SetProperty("CellCaption",h, 2, ukoly->ctypUkolu       )
           oItems:SetProperty("CellCaption",h, 3, ukoly->cJmeRozlRe      )
           oItems:SetProperty("CellCaption",h, 4, dtoc(ukoly->dplZacUkol))
           oItems:SetProperty("CellCaption",h, 5, dtoc(ukoly->dplKonUkol))
           oItems:SetProperty("CellCaption",h, 6, dtoc(ukoly->dzacUkolu ))
           oItems:SetProperty("CellCaption",h, 7, dtoc(ukoly->dkonUkolu ))

           oItems:SetProperty("CellData"       ,h, 0,ukoly->( recno()))
           oItems:SetProperty("ItemData"       ,h,   ukoly->sID       )
           oItems:SetProperty("ExpandItem"    , h,.T.)

        aadd( pa_ukoly, { ukoly->sid, h } )
      endif

      vazUkoly->( dbskip())
    enddo


  oItems:SetProperty("ExpandItem",hRoot,.T.)
  oItems:setProperty("SelectItem",hroot,.T.)
return self


METHOD KAN_ukolTree_EX_scr:tabSelect(drgTabPage, tabNum)
  local  dc := ::drgDialog:dialogCtrl

  ::tabNum    := tabNum
  ::is_intree := (tabNum = 5)
  ::m_file    := if( tabNum < 5, ::a_files[tabNum]                          , ''  )
  ::brow      := if( tabNum < 5, ::drgDialog:dialogCtrl:oBrowse[tabNum]:oxbp, nil )
  ::oinfo_text:oxbp:setCaption(subStr(drgTabPage:oxbp:caption,4))

  *
  ** na 5- Rozpad nedovolíme nic mìnit, je to jen pohled
  for x := 1 to len(::members)
    clsName := ::members[x]:className()

    do case
    case( clsName = 'drgGet'        )
      if( tabNum = 5, ::members[x]:oxbp:disable(), ::members[x]:oxbp:enable() )

    case( clsName = 'drgCheckBox'   )
      if( tabNum = 5, ::members[x]:oxbp:disable(), ::members[x]:oxbp:enable() )

    case( clsName = 'drgRadioButton')
      pa := ::members[x]:members
      AEval( pa, {|o| if( tabNum = 5, o:disable(), o:enable()) })
    endcase
  next

  if( len(dc:oBrowse) >= tabNum, dc:oBrowse[tabNum]:oxbp:refreshCurrent(), nil)
  PostAppEvent(xbeBRW_ItemMarked,,,::drgDialog:dialogCtrl:oaBrowse:oXbp)
RETURN .T.


METHOD KAN_ukolTree_EX_scr:postValidate(drgVar,lSelected, oxbp)                                     // kotroly a výpoèty
  Local  lOk  := .T., lValue, c_fileW
  *
  local  name       := Lower(drgVar:name), ;
         field_name := lower(drgParseSecond(drgVar:name, '>'))

  local  it_typUctu := 'lnakluct,lvynosuct,laktivuct,lpasivuct,lzaveruct,lpodrzuct,lnaturuct'
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  local  odrg, members, npos
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  DEFAULT lSelected TO .F.

  if lSelected
    do case
    case (field_name $ it_typUctu)
      lValue := !drgVar:get()

      ::dm:has('M->LNAKLUCT' ):set(.F.)
      ::dm:has('M->LVYNOSUCT'):set(.F.)
      ::dm:has('M->LAKTIVUCT'):set(.F.)
      ::dm:has('M->LPASIVUCT'):set(.F.)
      ::dm:has('M->LZAVERUCT'):set(.F.)
      ::dm:has('M->LPODRZUCT'):set(.F.)
      ::dm:has('M->LNATURUCT'):set(.F.)

      drgVar:set(lValue)

    case (field_name = 'czustuct' )
      members := drgVar:odrg:members
      values  := drgVar:odrg:values
      npos    := ascan( members, oXbp )

      drgVar:set( values[npos,1] )

    otherwise
      lValue := !drgVar:get()

      drgVar:set(lValue)
    endcase
  else

    do case
    case field_name = 'cucet'
      c_fileW := ::m_file +'W'

      if empty(drgvar:value)
        ::msg:writeMessage('_ÚÈET_ je povinný údaj ...',DRG_MSG_ERROR)
        lok := .f.
      endif

      if (c_fileW)->(dbseek(upper(drgvar:value),, AdsCtag(1) ))
        ::msg:writeMessage('Duplicitní _ÚÈET_ nelze zadat ...',DRG_MSG_ERROR)
        lok := .f.
      endif
      *
      ** v INS pro c_uctosn pøedastavíme hodnoty z c_syntuc
      if ( lok .and. ::m_file = 'c_uctosn' .and. drgVar:itemChanged() )

        if c_syntucW->(DbSeek(upper(drgvar:value),,AdsCtag(1) ))
          ::dm:has('M->LNAKLSTR' ):set(c_syntucW->lnaklStr   )

          ::dm:has('M->CZUSTUCT' ):set(c_syntucW->czustUct   )

          ::dm:has('M->LNAKLUCT'  ):set(c_syntucW->lnaklUct  )
          ::dm:has('M->LVYNOSUCT' ):set(c_syntucW->lvynosUct )
          ::dm:has('M->LAKTIVUCT' ):set(c_syntucW->laktivUct )
          ::dm:has('M->LPASIVUCT' ):set(c_syntucW->lpasivUct )
          ::dm:has('M->LZAVERUCT' ):set(c_syntucW->lzaverUct )
          ::dm:has('M->LPODRZUCT' ):set(c_syntucW->lpodrzUct )
          ::dm:has('M->LNATURUCT' ):set(c_syntucW->lnaturUct )

          ::dm:has('M->LSALDOUCT' ):set(c_syntucW->lsaldoUct )
          ::dm:has('M->LFINUCT'   ):set(c_syntucW->lfinUct   )
          ::dm:has('M->LDANUCT'   ):set(c_syntucW->ldanUct   )
          ::dm:has('M->LMIMORUCT' ):set(c_syntucW->lmimorUct )

          ::dm:has('M->LREZUCTY'  ):set(c_syntucW->lrezUcty  )
          ::dm:has('M->LREZZAKLAD'):set(c_syntucW->lrezZaklad)

        endif
      endIf

    endCase
  endIf

  if(name = 'm->lrezzaklad')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      ::postSave()
    endif
  endif
return lok


method KAN_ukolTree_EX_scr:postSave()
  local ok

  * ukládáme na posledním PRVKU *
  if((::m_file)->(eof()), ::state := 2, nil)
  ok := if(::state = 2, AddRec(::m_file), ReplRec(::m_file))

  if ok
    ::dm:save()
    (::m_file)->cucetMD    := (::m_file)->cucet
    (::m_file)->cUserAbb   := SYSCONFIG('SYSTEM:cUSERABB')
    (::m_file)->dDatZmeny  := Date()
  endif

  ::restColor()
  ::esc_focustobrow( (::state = 2 ))

  (::m_file)->(DbUnlock(), DbCommit())
return .t.


method KAN_ukolTree_EX_scr:postDelete()
  local  cMessage, cTitle, nsel
  local  canBe_Del := .t., nodel := .f.
  *
  local  cKy := upper((::m_file)->cucet)

  do case
  case(::m_file = 'c_uctosn')
    cMessage  := 'analytický úèet '
    cTitle    := 'analytického úètu ...'

  case(::m_file = 'c_syntuc')
    cMessage  := 'syntetický úèet '
    cTitle    := 'syntetického úètu ...'
    canBe_Del := .not. c_uctosnW->(DbSeek( cKy,, AdsCtag(1) ))

  case(::m_file = 'c_grupuc')
    cMessage  := 'skupinu '
    cTitle    := 'skupiny úètù ...'
    canBe_Del := ( .not. c_syntucW->(DbSeek(cKy,, AdsCtag(1) )) .and. ;
                  .not. c_uctosnW->(DbSeek(cKy,, AdsCtag(1) ))        )

  otherwise
    cMessage  := 'tøídu '
    cTitle    := 'tøídy úètù ...'
    canBe_Del := (.not. c_syntucW->(DbSeek(cKy,, AdsCtag(1) )) .and. ;
                  .not. c_uctosnW->(DbSeek(cKy,, AdsCtag(1) )) .and. ;
                  .not. c_grupucW->(DbSeek(cKy,, AdsCtag(1) ))       )

  endcase


  cnaBe_Del := (canBe_Del .and. (::m_file)->(DbRlock()))


  if canBe_Del
    nsel := ConfirmBox( ,'Požadujete zrušit ' +cMessage +'_' +alltrim((::m_file)->cucet) +'_', ;
                         'Zrušení ' +cTitle , ;
                          XBPMB_YESNO       , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      (::m_file)->(DbDelete())
      nodel := .f.
    endif
  else

    nodel := .t.
  endif


  if nodel
    cMessage := stuff( cMessage, 1, 1, upper( SubStr( cMessage, 1, 1)))

    ConfirmBox( ,cMessage + '_' +alltrim((::m_file)->cucet) +'_' +' nelze zrušit ...', ;
                 'Zrušení ' +cTitle              , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  _clearEventLoop(.t.)

  (::m_file)->(DbUnlock())
  ::brow:refreshAll()
return .t.