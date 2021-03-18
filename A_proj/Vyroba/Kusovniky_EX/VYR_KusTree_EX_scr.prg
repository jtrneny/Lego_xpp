/*==============================================================================
  VYR_KusTREE_ex_scr.PRG
==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "gra.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

#DEFINE  tab_INFO      1
#DEFINE  tab_OPERACE   2
#DEFINE  tab_SKLADY    3
********************************************************************************
*
********************************************************************************
CLASS VYR_KusTREE_ex_scr FROM drgUsrClass, VYR_KusTREE_ex_gen
EXPORTED:
  VAR     nRec, nSpMnoSkl

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  TreeItemMarked, TreeItemSelected
  METHOD  tabSelect

  METHOD  POLOPER_COPY_one, POLOPER_COPY_more
  METHOD  VYR_CenZboz_INFO
  METHOD  VYR_KUSOV_CRD
  METHOD  VYR_PostupTech
  METHOD  VYR_KalkPLAN, VYR_KalkSKUT
  method  VYR_vyrZak_CRD

  * Bro - polOper
  inline access assign method polOper_porCisLis() var polOper_porCisLis
    return if( polOper->nporCisLis = 0, 0, 552 )  // M_big_new  -  má vygenerovaný mlistHd ?

  * new del for ALL
  inline method vyr_kusTree_EX_del()
    local  odialog

    ::filesSync()

    oDialog := drgDialog():new('VYR_kusTree_EX_del',self:drgDialog)
    odialog:create(,,.T.)

    ::filesSync()

    odialog:destroy()
    odialog := nil
  return self


  inline method drgDialogEnd(drgDialog)
    local  oItems := ::oTree:Items()

    kusTree->( Ads_clearAof())
    ::oTree:ClearFilter()
    oItems:SetProperty("ExpandItem", 0, .t. )

    ::tre_Layout := ::oTree:Layout         // asysini.tre_layout M10
  return self

  *
  ** tímto je pokryta púvodní varianta dvou tlaèítek - plný, 1. výrStupeò, vyrábìné položky, nakupované položky
  inline method createContext()
    local  opopUp, x, apos
    local  pa := { { 'Kusovník plný'        }, ;
                   { 'Kusovník 1.výrStupeò' }, ;
                   { 'Vyrábìné položky'     }, ;
                   { 'Nakupované položky'   }, ;
                   { ''                     }, ;
                   { 'Programové nastavení' }  }

    opopUp := XbpImageMenu( ::drgDialog:dialog ):new()
    opopUp:barText := 'kusTree'
    opopUp:create()

    for x := 1 to len(pa) step 1
     if empty( pa[x,1] )
        opopup:addItem({ NIL                           , ;
                         NIL                           , ;
                         XBPMENUBAR_MIS_SEPARATOR      , ;
                         XBPMENUBAR_MIA_OWNERDRAW        } )
     else
       opopup:addItem( {pa[x,1]                       , ;
                        de_BrowseContext(self,x,pA[x]), ;
                                                      , ;
                        XBPMENUBAR_MIA_OWNERDRAW        }, ;
                        if( x = ::popState, 500, 0)     )
     endif
    next

     apos     := ::drgPush:oXbp:currentPos()
     apos_parent := ::drgPush:oXbp:parent:currentPos()

     opopup:popup( ::drgPush:oxbp:parent, { apos[1] -40, apos[2] } )
  return self


  inline method fromContext(aorder,p_popUp,apos)
    local  oItems := ::oTree:Items()
    *
    local  pa_Items, x, isExpand, lexpant_Item
    local  cf
    local  sid := kusTree->nKUSOV   // kusov->sid

    ::popState := aorder
    ::drgPush:oxbp:setCaption( allTrim( p_popUp[1]))

    do case
    case( ::popState = 1 .or. ::popState = 2 )

      ::oTree:BeginUpdate()
      if .not. empty( kusTree->( Ads_getAof()))
        kusTree->( Ads_clearAof(), dbGoTop())
        oItems:RemoveAllItems()

        ::ex_fillTree()
      endif

      pa_items      := ::oTree:getItems(1)   // vrátí pole h položek, 1 je ROOT
      lexpant_Item  := ( aorder = 1 )

      for x := 2 to len(pa_items) step 1
        isExpand := oItems:ExpandItem( pa_items[x] )

        oItems:SetProperty("ExpandItem",pa_items[x], lexpant_Item )
      next
      ::oTree:EndUpdate()

    case ::popState = 3 .or. ::popState = 4  // 3 - Vyrábìné položky, 4 - Nakupované položky

      cf := if( ::popState = 3, "(sid = 1 or !lnakPol)", "(sid = 1 or lnakPol)" )
      kusTree->( Ads_SetAof(cf), dbGoTOP() )

      ::oTree:BeginUpdate()
        oItems:RemoveAllItems()

        ::ex_fillTree()
      ::oTree:EndUpdate()

    case ::popState = 6                     // 5 - oddìlovaè, 6 - Programové nastavení

      ::oTree:BeginUpdate()
        kusTree->( dbGoTop())
        ::oTree:Columns:Clear()

        ::tre_Layout := ''
        ::ex_fillTree()
      ::oTree:EndUpdate()
    endcase

    // postavit se záznam  podle sid
    if ( hc := oItems:FindItemData(sid) ) <> 0
      oItems:setProperty("SelectItem", hc, .t. )
      oItems:EnsureVisibleItem(hc)
    endif

  return self
****


HIDDEN:
  VAR     msg, dm, dc, df, ab
  VAR     tabNUM, lNewREC, nSumCena, aRec
  VAR     lSaveKusovCrd        // byla uložena karta kus.vazby
  var     oactiveArea, in_file
  *
  var     drgPush, popState
  var     pb_vyrZak_CRD

  METHOD  FilesSYNC, sumColumn

  inline method extree_Color(isActive)
    local oColumn, nColor_ex, nColor

    default isActive to .f.

    oColumn   := ::oTree:Columns(0)
    nColor_ex := oColumn:GetProperty("Def",4/*exCellBackColor*/ )
    nColor    := AutomationTranslateColor( if( isActive, GRA_CLR_WHITE, GRA_CLR_PALEGRAY) , .f. )

    if nColor_ex <> nColor
      var_Count := ::oTree:Columns:Count()

      ::oTree:BeginUpdate()
      for x := 0 to var_Count -1 step 1
        oColumn  := ::oTree:Columns(x)
        oColumn:SetProperty("Def",4/*exCellBackColor*/,ncolor)
      next
      ::oTree:EndUpdate()
    endif

    if ::oactiveArea:className() = 'XbpBrowse'
      ::dc:sp_resetActiveArea( ::oactiveArea:cargo, .f., .t. )
    endif
  return self

ENDCLASS

********************************************************************************
METHOD VYR_KusTREE_ex_scr:init(parent)
  Local  nShow_Tree := Tree_FULL, cParam
  Local  nPrm := SysConfig( 'Vyroba:nKusTreFrm')
  *
  local  pa_initParam, cky

  nPrm := If( IsArray(nPrm), 1, nPrm )
  parent:formName := If( nPrm = 1, 'VYR_KusTREE_ex_scr', 'VYR_KusTREE2_scr')
  *
*  ::parent := parent
  ::drgUsrClass:init(parent)
  *
  cParam := drgParseSecond( parent:initParam, ',' )
  nShow_Tree := IF( EMPTY( cParam), nShow_Tree, VAL( cParam) )
  ::VYR_KusTREE_ex_gen:init(parent, nShow_Tree)
  ::dialogTitle := 'Kusovníkový rozpad'

  drgDBMS:open('POLOPER' )
  drgDBMS:open('OPERACE' )
  drgDBMS:open('VYRPOL',,,,,'VYRPOL_s')
  POLOPER->( DbSetRelation( 'OPERACE', { || Upper(POLOPER->cOznOper) },;
                                           'Upper(POLOPER->cOznOper)' ))
  ::nREC := KusTREE->( RecNO())
  ::tabNUM    := if( parent:parent:formname = 'PRO_NabVysHD_IN'      .or.;
                     parent:parent:formname = 'PRO_NabVysHD_cen_SEL', tab_OPERACE, tab_INFO )
  ::lNewRec   := .F.
  ::nSumCena  := 0
*  ::nROZPAD := 2
  ::lSaveKusovCrd := .f.
  ::nSpMnoSkl := 0

  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    vyrPol->( dbgoto( val(pa_initParam[2])))

    cky := upper(vyrPol->ccisZakaz) +upper(vyrPol->cvyrPol) +strZero(vyrPol->nvarCis,3)
    vyrZak->( dbseek( cky,, 'VYRZAK1' ))
  endif

RETURN self

********************************************************************************
METHOD VYR_KusTREE_ex_scr:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x, Item
  local  amembers := drgDialog:oForm:aMembers, cevent
  *
  local pa       := { GraMakeRGBColor({ 78,154,125}), GraMakeRGBColor({157,206,188})  }
  *
  ::msg       := drgDialog:oMessageBar             // messageBar
  ::dc        := drgDialog:dialogCtrl              // dataCtrl
  ::dm        := drgDialog:dataManager             // dataMananager
  ::df        := drgDialog:oForm                   // form
  *
  ::msg:can_writeMessage := .f.


  ColorOfText( ::dc:members[1]:aMembers)
  SEPARATORs( members)
  *
  FOR x := 1 TO LEN( Members)
    do case
    case members[x]:event $ 'VYR_VYRZAK_INFO'
      IF( EMPTY(VYRPOL->cCisZakaz), members[x]:oXbp:disable(), members[x]:oXbp:enable())

      members[x]:oXbp:setColorFG( If( EMPTY(VYRPOL->cCisZakaz), GraMakeRGBColor({128,128,128}),;
                                                                GraMakeRGBColor({0,0,0})))
    case members[x]:event $ 'VYR_vyrZak_CRD'
      ::pb_vyrZak_CRD := members[x]

    endcase
  NEXT

  ::popState := 1
  ::pb_vyrZak_crd:oxbp:hide()

  for x := 1 to len(aMembers) step 1
    if aMembers[x]:ClassName() = "drgPushButton"
       cevent  := isNull(aMembers[x]:event  , '' )

      if( cevent = 'createContext',  ::drgPush := aMembers[x], nil )
    endif
  next

  if isObject(::drgPush)
    ::drgPush:oXbp:setFont(drgPP:getFont(5))
    ::drgPush:oxbp:setGradientColors( pa )

    ::drgPush:oxbp:show()
  endif

  *
  KusTree->( dbGoTOP())
  SetAppFocus( ::oTree)
  *
  ::tabSelect( , ::tabNUM)
  drgDialog:oForm:tabPageManager:showPage( ::tabNum, .T.)

  ::oactiveArea := ::oTree
  ::in_file     := 'kusov'
  *
  ** pro editaèní režim musíme TREE pøepoèítat pøed startem
  ** BACHA
  if empty(vyrZak->ccisZakaz)
    KusTree->nmnozZadan := 0
    Item     := ::oTree:Items:FindItemData(0)
    ::OnAfterCellEdit(::oTree,Item, 1, '1')
  endif
RETURN self

********************************************************************************
METHOD VYR_KusTREE_ex_scr:EventHandled(nEvent, mp1, mp2, oXbp)
  local  myEv := {drgEVENT_APPEND,drgEVENT_EDIT,drgEVENT_DELETE}
  local  olastDrg := ::df:olastDrg
  local  lastXbp  := ::drgDialog:lastXbpInFocus

  local  anRec, nRec
  local  msgStatus := ::msg:msgStatus, oPs, cinfo := '', isActive := .f.

  *
/*
  if ascan(myEv,nevent) <> 0
    msgStatus:setCaption( '' )
    oPs := msgStatus:lockPS()

    cinfo := ::oactiveArea:className() +' . ' +::in_file +' . ' +str( nevent )

    graStringAT( oPs, { 20, 4 }, cinfo )
    msgStatus:unlockPS()
    return .t.
  endif
*/


  if nevent = drgEVENT_SELECT .or. ( ::tabNUM <> tab_INFO .and. nEvent = xbeBRW_ItemMarked )

    msgStatus:setCaption( '' )
    oPs := msgStatus:lockPS()

    if  oxbp:ClassName() = 'XbpActiveXControl'
       cinfo    := 'je na tree ' +oXbp:className()
       isActive := .t.
    else
      cinfo    := 'kde je ? ' +oXbp:className()
      isActive := .f.
    endif

    graStringAT( oPs, { 20, 4 }, cinfo )
    msgStatus:unlockPS()

    ::oactiveArea := if( oxbp:classname() = 'XbpCellGroup', oxbp:parent:cargo, oxbp )
    ::in_file     := if( isActive, 'kusov', lower(::oactiveArea:cargo:cfile) )

    ::extree_Color(isActive)
  endif

  do case
  case nevent = drgEVENT_APPEND
    do case
    case ::in_file = 'kusov'
      if kusTree->lnakPol
        drgMsgBox( 'SKLADOVÁ POLOŽKA !;;' +'nelze vytvoøit vztah na položku nižší !')
        return .t.
      else
        ::lnewRec := .t.
        ::vyr_kusov_crd()
      endif
    case ::in_file = 'poloper'
      if kusTree->lnakPol
        drgMsgBox('OPERACE K POLOŽCE !;;' +'nelze vytvoøit operaci k materiálu !')
        return .t.
      else
        return .f.
      endif
    endcase

  case nevent = drgEVENT_EDIT
    do case
    case ::in_file = 'kusov'
      if kusTree->( RecNo()) = 1
        drgMsgBox( 'NELZE opravovat ;;vazbu vrcholového výrobku, nebo neexistuje !')
        return .t.
      else
        ::lnewRec := .f.
        ::vyr_kusov_crd()
      endif
    case ::in_file = 'poloper'
      if kusTree->lnakPol
        drgMsgBox('OPERACE K POLOŽCE !;;' +'nelze vytvoøit operaci k materiálu !')
        return .t.
      else
        return .f.
      endif
    endcase

  case nevent = drgEVENT_DELETE
    do case
    case ::in_file = 'kusov'
       ::FilesSYNC()
      VYR_KUSOV_del( self)
      ::FilesSYNC()
    case ::in_file = 'poloper'
      if polOper->sid <> 0
        VYR_POLOPER_del()
      endif
    endcase

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD VYR_KusTREE_ex_scr:TreeItemMarked( oItem, aRect, oXbp)
  Local cKey
  LOCAL nEvent := mp1 := mp2 := nil
  *
  local  oItems, h, recNo, caption, lis_Edit := .f.
  local  oColumn, ncolor_ex

  nEvent := LastAppEvent(@mp1,@mp2)
  _clearEventLoop(.T.)


  * Synchronizace s KusTREE
  oItems  := ::oTree:Items()
  h       := oItems:SelectedItem(0)
  recNo   := oItems:CellData( h, 0)
  caption := oItems:CellCaption( h, 0)

  if( isNumber(recNo), KusTree->( dbGoTO( recNo)), nil )

  ::dataManager:refresh()
  PostAppEvent( drgEVENT_SELECT,,, ::oTree)
  *
  if( (empty(kusTree->ccisZakaz) .and. .not. kusTree->lnakPol), ::pb_vyrZak_crd:oxbp:show(), ;
                                                                ::pb_vyrZak_crd:oxbp:hide()  )
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
  *

  do case
  case aRect = xbeK_INS .and. KusTree->( RecNo()) <> 1
    ( ::lnewRec := .t., lis_Edit := .T. )
    PostAppEvent(drgEVENT_APPEND,,,::oTree)

  case aRect = xbeK_ENTER
    ( ::lnewRec := .f., lis_Edit := .t. )
    PostAppEvent(drgEVENT_EDIT  ,,,::oTree)
  case aRect = xbeK_CTRL_DEL
    PostAppEvent(drgEVENT_DELETE,,,::oTree)
  endCase
RETURN SELF

********************************************************************************
METHOD VYR_KusTREE_ex_scr:TreeItemSelected( oItem, aRect, oXbp)
  LOCAL nEvent, mp1, mp2

  IF ! ::lNewRec .and. KusTree->( RecNo()) = 1
    * Nelze opravovat vazbu vrcholového výrobku, nebo neexistuje
  ELSE
    ::VYR_KUSOV_CRD()
    *
    SetAppFocus( oXbp)
    oXbp:setData( ::oTreeItem)

**    _clearEventLoop(.T.)
*    PostAppEvent(drgEVENT_MSG, drgEVENT_ACTIVATE,, oXbp)
*    nEvent := AppEvent( @mp1, @mp2, @oXbp, 5 )
  ENDIF
RETURN SELF


********************************************************************************
METHOD VYR_KusTREE_ex_scr:tabSelect( tabPage, tabNumber)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x, anRec
  Local  cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')
  local  ok

  ::tabNUM := tabNumber

  if ::tabNum = tab_INFO
    ::df:setNextFocus( ::oTree:parent:cargo,, .t. )
    PostAppEvent( drgEVENT_SELECT,,, ::oTree)
  endif

  IF ::tabNUM = tab_OPERACE
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    If isNull( ::aRec)
      ::aRec := VYR_ScopeOPER()
    EndIf
    ::sumColumn( anRec)
    ::dc:oBrowse[1]:oXbp:refreshAll()

    postAppEvent(xbeBRW_ItemMarked, 1, 2, ::dc:oBrowse[1]:oXbp:getColumn(2):dataArea)
    PostAppEvent( drgEVENT_SELECT,,, ::dc:oBrowse[1]:oXbp:getColumn(2):dataArea)
    ::msg:WriteMessage(,0)
  ENDIF

  IF ::tabNUM = tab_SKLADY
**    ::TreeItemMarked()
    IF KusTree->lNakPol
      cKey := KusTree->cSklPol
    ELSE
      cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol) + StrZero( KusTree->nVarPoz,3)
      VyrPol_s->( dbSeek( cKey,, 'VYRPOL1'))
      cKey := VyrPOL_s->cSklPol
    ENDIF
    CenZBOZ->( mh_SetSCOPE( cKey))
    ::dc:oBrowse[2]:oXbp:refreshAll()

    postAppEvent(xbeBRW_ItemMarked, 1, 2, ::dc:oBrowse[2]:oXbp:getColumn(2):dataArea)
    PostAppEvent( drgEVENT_SELECT,,, ::dc:oBrowse[1]:oXbp:getColumn(2):dataArea)
  ENDIF
  *
  FOR x := 1 TO LEN( Members)
    IF members[x]:event = 'separator'
       ADEL( members, x)
       ASIZE( members, Len(members)-1)
       x := x-1
    ENDIF
  NEXT
  *
  FOR x := 1 TO LEN( Members)
    IF members[x]:event $ 'VYR_POLOPER_INFO,VYR_OPERACE_INFO,POLOPER_COPY_one,POLOPER_COPY_more'
       ok := ( ::tabNUM = tab_OPERACE )

       members[x]:disabled := .not. ok
       if( ok, members[x]:oXbp:enable(), members[x]:oXbp:disable() )
    ENDIF
  NEXT
RETURN .T.

********************************************************************************
METHOD VYR_KusTREE_ex_scr:PolOPER_Copy_one( drgDialog)
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('VYR_POLOPER_CRD',self:drgDialog)
  oDialog:cargo := drgEVENT_APPEND2
  oDialog:create( , self:drgDialog:dialog,.F.)

  IF oDialog:exitState = drgEVENT_SAVE
    oDialog:parent:dialogCtrl:isAppend := .T.
    EVAL( oDialog:dialogCtrl:cbSave )
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
RETURN self

********************************************************************************
METHOD VYR_KusTREE_ex_scr:PolOPER_Copy_more
  LOCAL oDialog, nExit
  LOCAL nREC := VyrPOL->( RecNO())

  oDialog := drgDialog():new('VYR_POLOPER_CPY',self:drgDialog)
  oDialog:create( ,,.F.)

  IF oDialog:exitState = drgEVENT_SAVE
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
  *
  VyrPOL->( dbGoTO( nREC))
  ::dm:refresh()

RETURN self


method VYR_kusTree_ex_scr:VYR_KUSOV_CRD()
  lOCAL  oDialog, nExit
  local  oItems, h, hc, sid

  oDialog       := drgDialog():new('VYR_KUSOV_CRD',self:drgDialog)
  oDialog:cargo :=  IF( ::lNewRec, drgEVENT_APPEND, drgEVENT_EDIT)
  oDialog:create(,self:drgDialog:dialog,.T.)

  if oDialog:exitState != drgEVENT_QUIT
     oItems  := ::oTree:Items()
     h       := oItems:SelectedItem(0)
     sid     := kusov->sid

     if ::lnewRec
       if .not. empty( kusTree->( Ads_getAof()))
         kusTree->( Ads_clearAof(), dbGoTop())
       endif
       ::oTree:ClearFilter()
     endif

     ::oTree:BeginUpdate()
       oItems:RemoveAllItems()

       ::treeInit(::oTree:parent:cargo)   // xbpTreeView

       // postavit se na nový, nebo opravovaný záznam asi podle sid
       if ( hc := oItems:FindItemData(sid) ) <> 0
         oItems:setProperty("SelectItem", hc, .t. )
         oItems:EnsureVisibleItem(hc)
      endif

     ::oTree:EndUpdate()

     ::treeItemMarked(::oTree, 0)
   endif



  oDialog:destroy(.T.)
  oDialog := NIL
return self

********************************************************************************
METHOD VYR_KusTREE_ex_scr:VYR_PostupTech
  LOCAL oDialog, nExit, nREC := VyrPOL->( RecNO())
  *
  IF ::tabNUM <> tab_OPERACE
     VYR_ScopeOPER()
  ENDIF

  VYR_PolOperW_TMP()

  oDialog := drgDialog():new('VYR_POSTUPTECH',self:drgDialog)
  oDialog:create( ,,.F.)

  IF oDialog:exitState = drgEVENT_SAVE
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
  *
  VyrPOL->( dbGoTO( nREC))
  ::dm:refresh()

RETURN self

********************************************************************************
METHOD VYR_KusTREE_ex_scr:VYR_KalkPLAN
  LOCAL oDialog, nExit, nREC := VyrPOL->( RecNO())
  *
  oDialog := drgDialog():new('VYR_KALKUL_SCR',self:drgDialog)
  oDialog:parent:dbName := 'VyrPOL'
  oDialog:create( ,,.F.)

  IF oDialog:exitState = drgEVENT_SAVE
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
  *
  VyrPOL->( dbGoTO( nREC))
  ::dm:refresh()

RETURN self

********************************************************************************
METHOD VYR_KusTREE_ex_scr:VYR_KalkSKUT
  LOCAL oDialog, nExit, nREC := VyrPOL->( RecNO())
  *
  oDialog := drgDialog():new('VYR_KALKULVP_SCR',self:drgDialog)
  oDialog:parent:dbName := 'VyrZAK'
  oDialog:create( ,,.F.)

  IF oDialog:exitState = drgEVENT_SAVE
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
  *
  VyrPOL->( dbGoTO( nREC))
  ::dm:refresh()

RETURN self


* Vyrobit na zakázku ...
method vyr_kusTree_ex_scr:VYR_vyrZak_CRD(drgDialog)
  LOCAL  oDialog, nExit
  local  nrec_vyrPol  := vyrPol ->( recNo()), ;
         nrec_vyrZak  := vyrZak ->( recNo()), ;
         nrec_kusTree := kusTree->( recNo())
  *
  oDialog := drgDialog():new('VYR_vyrZak_crd',self:drgDialog)
  oDialog:cargo     := drgEVENT_APPEND
  oDialog:cargo_usr := 'from_kusTree'
  oDialog:create( ,,.F.)

  IF oDialog:exitState = drgEVENT_SAVE
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
  *
  vyrPol ->( dbGoTo(nrec_vyrPol))
  vyrZak ->( dbGoTo(nrec_vyrZak))
  kusTree->( dbGoTo(nrec_kusTree))
  ::dm:refresh()
RETURN self



* Synchronizace souborù s TreeView
********************************************************************************
METHOD VYR_KusTREE_ex_scr:FilesSYNC()
  LOCAL cKey, lOK

  cKey := Upper( KusTree->cSklPol)
  lOK  := CenZboz->( dbSeek( cKey))
  lOK  := NakPol->( dbSeek( cKey))
  cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
          StrZero( KusTree->nPozice, 3) + StrZero( KusTree->nVarPoz, 3)
  lOK := Kusov->( dbSeek( cKey))
RETURN self

********************************************************************************
METHOD VYR_KusTREE_ex_scr:VYR_CenZboz_INFO()
  LOCAL  oDialog, nExit
  Local  cKey, cFilter, cForm, nCount := 0

  IF KusTree->lNakPol
    Filter := FORMAT("(CenZBOZ->cSklPOL = '%%')", { KusTree->cSklPol } )
  ELSE
    cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol) + StrZero( KusTree->nVarPoz,3)
    VyrPol_s->( dbSeek( cKey,, 'VYRPOL1'))
    Filter := FORMAT("(CenZBOZ->cSklPOL = '%%')", { VyrPOL_s->cSklPol } )
  ENDIF

  CenZboz->( dbSetFilter( COMPILE( Filter)), dbGoTOP() )
  CenZBOZ->( dbEval( {|| nCount++ }), dbGoTOP() )
  IF nCount <= 1
     SKL_CENZBOZ_INFO( ::drgDialog)
  ELSE
    oDialog := drgDialog():new( 'VYR_CENZBOZ_INFO', ::drgDialog)
    oDialog:create(,,.T.)
    nExit := oDialog:exitState

    oDialog:destroy(.T.)
    oDialog := Nil
  ENDIF
  CenZboz->( dbClearFilter())

RETURN self

********************************************************************************
METHOD VYR_KusTREE_ex_scr:destroy()
  ::drgUsrClass:destroy()
  ::tabNum  := ;
  ::dc      := ;
  ::dm      := ;
  ::msg     := ;
  ::nSumCena := ;
   Nil
  KusTREE->( dbCloseArea())
  PolOper->( mh_ClrFilter())
RETURN self

** HIDDEN **********************************************************************
METHOD VYR_KusTREE_ex_scr:sumColumn( anRec)
  Local nSuma := 0, nRec := PolOper->( RecNO())

  AEVAL( ::aREC, {|X| PolOper->( dbGoTO(X)),;
                     nSuma += PolOper->nKcNaOper  } )
  PolOper->( dbGoTO( nRec))
  ::nSumCena := nSuma
  ::dc:oBrowse[1]:oXbp:getColumn(6):Footing:hide()
  ::dc:oBrowse[1]:oXbp:getColumn(6):Footing:setCell(1, ::nSumCena)
  ::dc:oBrowse[1]:oXbp:getColumn(6):Footing:show()
  ::dm:refresh()

RETURN self