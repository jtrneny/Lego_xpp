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
CLASS VYR_operTree_EX_scr FROM drgUsrClass
EXPORTED:
  METHOD  init, drgDialogStart, eventHandled
  METHOD  postValidate, postSave, postDelete
  METHOD  tabSelect
  *
  **
  VAR    msg, dm, dc, df, ab, brow


  inline method destroy()

    ::drgUsrClass:destroy()

    VyrPOL ->( DbClearRelation())
    POLOPER->( DbClearRelation())
  return self


HIDDEN:
  method ex_fillTree

  VAR    members, state       // 0 - inBrowse  1 - inEdit  2 - inAppend
  var    oTree
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


METHOD VYR_operTree_EX_scr:init(parent)
  local  cflt_vyrZak := "(cstavZakaz = '5' or cstavZakaz = '6')"
  local  cflt_vyrPol := "nmnZADva <> 0"
  *
  local  pa_initParam

  ::drgUsrClass:init(parent)

  ::state     := 0
  ::tabNum    := 1
  ::a_files   := { 'c_uctosn', 'c_syntuc', 'c_grupuc', 'c_triduc' }
  ::m_file    := 'c_uctosn'
  ::is_intree := .t.

  drgDBMS:open('operace' )

  drgDBMS:open('CenZboz' )
  drgDBMS:open('NakPol'  )
  drgDBMS:open('DodZboz' )
  drgDBMS:open('Kusov'   )
  drgDBMS:open('PolOPER' )
  drgDBMS:open('VyrZAK'  )
  drgDBMS:open('VyrPol'  )
  drgDBMS:open('C_Stred' )
  drgDBMS:open('C_TypPol')
  *
  VyrPOL ->( DbSetRelation( 'VyrZAK' , { || Upper(VyrPOL->cCisZakaz) }, 'Upper(VyrPOL->cCisZakaz)' ))
  POLOPER->( DbSetRelation( 'OPERACE', { || Upper(POLOPER->cOznOper) }, 'Upper(POLOPER->cOznOper)' ))


  drgDBMS:open('KusTREE' ,.T.,.T.,drgINI:dir_USERfitm)
  KusTree->( AdsSetOrder( 1))

  drgDBMS:open('OperTREE' ,.T.,.T.,drgINI:dir_USERfitm)
  OperTree->( AdsSetOrder( 1))

  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    vyrPol->( dbgoto( val(pa_initParam[2])))
  endif

RETURN self


METHOD VYR_operTree_EX_scr:drgDialogStart(drgDialog)
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

  GenTreeFILE()
  GenOperTree()

  ::ex_fillTree(odrgTree)
RETURN self


METHOD VYR_operTree_EX_scr:eventHandled(nEvent, mp1, mp2, oXbp)
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

//  case(nevent = drgEVENT_EDIT  .or. nevent = drgEVENT_APPEND)
//    cc := 'M->cucet'
//
//    if nevent = drgEVENT_APPEND
//      ::dm:refreshAndSetEmpty( 'm' )
//      ::state := 2
//    else
//      ::state := 1
//    endif
//
//    ::o_cucet:odrg:isEdit := (nevent = drgEVENT_APPEND)
//    ::drgDialog:oForm:setNextFocus(cc,, .T. )
//    return .t.
//
// case nEvent = drgEVENT_SAVE
//    if SetAppFocus():ClassName() <> 'XbpBrowse'
//      ::postSave()
//    endif
//    return .t.
//
//  CASE nEvent = drgEVENT_DELETE
//    if( .not. ::is_intree, ::postDelete(), nil )
//    return .t.
//
//  CASE nEvent = xbeP_Keyboard .and. .not. ::is_intree
//    IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
//      ::restColor()
//      ::esc_focustobrow()
//      return .t.
//    ELSE
//      RETURN .F.
//    ENDIF

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.


method VYR_operTree_EX_scr:ex_fillTree(drgObj)
  local  oColumns, oColumn, citem
  local  anode := {}, asubNode := {}, nvyrST, wvyrST
  local  vysPol
  *
  local  hRoot, h
  local  oFont_task  := XbpFont():new():create( "10.Helvetica BOLD" )
  local  nColor_task := AutomationTranslateColor( GRA_CLR_BLUE, .f. )
  local  nColor_vyr  := AutomationTranslateColor( GRA_CLR_DARKGREEN, .f. )

//  local  oBord       := drgObj:oXbp, apos := drgObj:oxbp:currentPos(), asize := drgObj:oxbp:currentSize()
  local  oBord := drgObj:oBord, apos := drgObj:oxbp:currentPos(), asize := drgObj:oxbp:currentSize()
  local  ccisZakaz

  ::oTree := nil
  ::oTree := XbpActiveXControl():new( oBord )
  ::oTree:CLSID  := "Exontrol.Tree.1" // {3C5FC763-72BA-4B97-9985-81862E9251F2}
  ::oTree:create(,, apos, asize )

  drgObj:oxbp:hide()
  drgObj:oxbp := ::oTree

  ::oTree:LinesAtRoot   := -1           // exLinesAtRoot
  ::oTree:hasLines      :=  1           // .t.   0, -1, 1, 2
  ::oTree:DrawGridLines := -1           /*exAllLines*/
  ::oTree:BeginUpdate()


  oColumn := ::oTree:Columns():Add( operTree->cvyrPol)
             oColumn:AllowSort := .f.
             oColumn:PartialCheck := .T.
             oColumn:SetProperty("Def",17/*exCellCaptionFormat*/,1)
             oColumn:Width := 150
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
  oColumn := ::oTree:Columns():Add("poz")
             oColumn:AllowSort := .f.
             oColumn:Position  := 1

  * 3
  oColumn := ::oTree:Columns():Add("název položky")
             oColumn:AllowSort := .f.
             oColumn:Width     := 300
  * 4
  ::oTree:Columns():Add("množství"):AllowSort := .f.
  * 5
  ::oTree:Columns():Add("mj"):AllowSort := .f.
  *6
  ::oTree:Columns():Add("operace"):AllowSort := .f.

  aadd( anode, { ocolumn, 1, .f., '' } )

  oItems := ::oTree:Items()
  cItem  := operTree->cNazev
  hRoot  := oitems:addItem(citem)
            oItems:SetProperty("CellCaption",hRoot,2," Pozice <img>p3</img> ")
            oItems:SetProperty("CellCaptionFormat",hRoot,2,1/*exHTML*/)
            oItems:SetProperty("CellHAlignment",hRoot,2,2/*RightAlignment*/)
            oItems:SetProperty("CellHasButton",hRoot,2,.T.)
            oItems:SetProperty("CellCaption",hRoot, 3,operTree->cnazev )
            oItems:SetProperty("CellCaption",hRoot, 4,operTree->nSpMno )
            oItems:SetProperty("CellCaption",hRoot, 5,operTree->czkratJedn )


  do while len(anode) > 0

    for x := 1 to len(anode) step 1
      operTree->( DBGOTO( aNode[ x, 2]) )
      nVyrST   := operTree->nVyrST
      cTreeKey := ALLTRIM( OperTree->cTreeKey)
      operTree->( DBSKIP() )

      if anode[x,3]
         h := anode[x,1]
      endif

      do while .not. operTree->( eof())
        wVyrST   := operTree->nVyrST
        vysPol   := operTree->cvysPol
        wTreeKey := ALLTRIM(OperTree->cTreeKey)

        IF ( nVyrST + 1 = wVyrST  .and. LEN( wTreeKey) = 3*(nVyrSt+1) ) .or. ;
           ( nVyrST     = wVyrST  .and. '!' $ wTreeKey .and. LEFT( cTreeKEY, nVyrST) = LEFT( wTreeKEY, nVyrST) )

          vysPol := operTree->cvysPol
          citem  := IF( empty(operTree->coznOper), operTree->cvyrPol, operTree->coznOper)

          if anode[x,3]
            if vysPol = anode[x,4]
               hc := oItems:InsertItem( h, 0, citem  )
                     npozice := if( EMPTY( OperTree->cOznOper), OperTree->nPozice, OperTree->nCisOper )
                     cnazev  := if( EMPTY( OperTree->cOznOper), operTree->cNazev , opertree->cnazOper ) +' _ ' +operTree->ctext1

                     oItems:SetProperty("CellCaption",hc, 2,             npozice)
                     oItems:SetProperty("CellCaption",hc, 3,             cnazev )
                     oItems:SetProperty("CellCaption",hc, 4, operTree->nSpMno     )
                     oItems:SetProperty("CellCaption",hc, 5, operTree->czkratJedn )
                     oItems:SetProperty("CellCaption",hc, 6, operTree->coznOper   )

*                     oItems:SetProperty("CellCaption",hc, 6,if( operTree->lnakPol, "<img>p1:16</img>", "<img>p2:16</img>") )
*                     oItems:SetProperty("CellCaptionFormat",hc,6,1/*exHTML*/)

                     oItems:SetProperty("CellData"   ,hc, 0,operTree->( recno()))
                     oItems:SetProperty("ItemData",   hc,   operTree->( recNo()) )

                     oItems:SetProperty("ExpandItem",hc,.T.)

                     if empty(OperTree->cOznOper)
                       aadd( asubNode, { hc, operTree->( recno()), .t., operTree->cvyrPol } )
                     endif
            endif

          else
            h := oItems:InsertItem( hRoot, 0, citem  )
                 npozice := if( EMPTY( OperTree->cOznOper), OperTree->nPozice, OperTree->nCisOper )
                 cnazev  := if( EMPTY( OperTree->cOznOper), operTree->cNazev , opertree->cnazOper ) +' _ ' +operTree->ctext1

                 oItems:SetProperty("CellCaption",h, 2,           npozice)
                 oItems:SetProperty("CellCaption",h, 3,           cnazev )
                 oItems:SetProperty("CellCaption",h, 4, operTree->nSpMno )
                 oItems:SetProperty("CellCaption",h, 5, operTree->czkratJedn )
                 oItems:SetProperty("CellCaption",h, 6, operTree->coznOper   )

*                 oItems:SetProperty("CellCaption",h, 6,if( operTree->lnakPol, "<img>p1:16</img>", "<img>p2:16</img>") )
*                 oItems:SetProperty("CellCaptionFormat",h,6,1/*exHTML*/)

                 oItems:SetProperty("CellData"   ,h, 0,operTree->( recno()))
                 oItems:SetProperty("ItemData",   h   ,operTree->( recNo()) )

                 oItems:SetProperty("ExpandItem", h,.T.)

                 if .not. operTree->lnakPol
                   for nit := 0 to 6 step 1
                     oItems:setProperty( "CellFont"     , h, nit, oFont_task )
                     oItems:setProperty( "CellForeColor", h, nit, nColor_vyr )
                   next
                 endif

                 oItems:SetProperty("ExpandItem",h,.T.)

                 if empty( OperTree->cOznOper)
                   aadd( asubNode, { h, operTree->( recno()), .t., operTree->cvyrPol } )
                 endif
          endif
        endif

        operTree->( dbSkip())
      enddo

    next

    anode := aclone(asubNode)
    asubNode := {}
  enddo

  oItems:SetProperty("ExpandItem",hRoot,.T.)
  oItems:setProperty("SelectItem",hroot,.T.)

  ::oTree:EndUpdate()
return self


METHOD VYR_operTree_EX_scr:tabSelect(drgTabPage, tabNum)
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


METHOD VYR_operTree_EX_scr:postValidate(drgVar,lSelected, oxbp)                                     // kotroly a výpoèty
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


method VYR_operTree_EX_scr:postSave()
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


method VYR_operTree_EX_scr:postDelete()
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