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
** CLASS for FRM VYR_vyrPol_tree **********************************************
CLASS VYR_vyrPol_tree FROM drgUsrClass
EXPORTED:
  METHOD  init, drgDialogStart, eventHandled
  METHOD  postValidate, postSave, postDelete
  METHOD  tabSelect
  *
  method  treeViewInit, treeItemMarked

  **
  VAR    msg, dm, dc, df, ab, brow


* úèet - název úètu
 inline access assign method cucet(value)     var cucet
   return ::c_uctosn_vars('cucet'     ,value)
 inline access assign method cnaz_uct(value)  var cnaz_uct
   return ::c_uctosn_vars('cnaz_uct'  ,value)

* nákladová struktura
 inline access assign method lnaklStr(value)   var lnaklStr
   return ::c_uctosn_vars('lnaklStr' ,value)

* výpoèet zùstatku
 inline access assign method czustUct(value)   var czustUct
   return ::c_uctosn_vars('czustUct' ,value)

* typ úètu
 inline access assign method lnaklUct(value)   var lnaklUct
   return ::c_uctosn_vars('lnaklUct' ,value)
 inline access assign method lvynosUct(value)  var lvynosUct
   return ::c_uctosn_vars('lvynosUct',value)
 inline access assign method laktivUct(value)  var laktivUct
   return ::c_uctosn_vars('laktivUct',value)
 inline access assign method lpasivUct(value)  var lpasivUct
   return ::c_uctosn_vars('lpasivUct',value)
 inline access assign method lzaverUct(value)  var lzaverUct
   return ::c_uctosn_vars('lzaverUct',value)
 inline access assign method lpodrzUct(value)  var lpodrzUct
   return ::c_uctosn_vars('lpodrzUct',value)
 inline access assign method lnaturUct(value)  var lnaturUct
   return ::c_uctosn_vars('lnaturUct',value)

 inline access assign method lsaldoUct(value)  var lsaldoUct
   return ::c_uctosn_vars('lsaldoUct',value)
 inline access assign method lfinUct(value)    var lfinUct
   return ::c_uctosn_vars('lfinUct'  ,value)
 inline access assign method ldanUct(value)    var ldanUct
   return ::c_uctosn_vars('ldanUct'  ,value)
 inline access assign method lmimorUct(value)  var lmimorUct
   return ::c_uctosn_vars('lmimorUct',value)

 inline access assign method lrezucty(value)   var lrezucty
   return ::c_uctosn_vars('lrezucty',value)
 inline access assign method lrezzaklad(value) var lrezzaklad
   return ::c_uctosn_vars('lrezzaklad',value)


 inline method c_uctosn_vars(cit,value)
   local pa     := ::a_files, retVal, ;
         tabNum := if(::tabNum = 5, 1, ::tabNum)
   *
   local cc := pa[tabNum] +if(::is_intree, 'w', '') +'->' +cit

   if isNull(value)
     retVal :=  DBGetVal(cc)
   else
     DBPutVal(cc,value)
     retVal := value
   endif
  return retVal

HIDDEN:
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


METHOD VYR_vyrPol_tree:init(parent)
  local  cflt_vyrZak := "(cstavZakaz = '5' or cstavZakaz = '6')"
  local  cflt_vyrPol := "nmnZADva <> 0"

  ::drgUsrClass:init(parent)

  ::state     := 0
  ::tabNum    := 1
  ::a_files   := { 'c_uctosn', 'c_syntuc', 'c_grupuc', 'c_triduc' }
  ::m_file    := 'c_uctosn'
  ::is_intree := .f.

  drgDBMS:open('c_uctosn')
  drgDBMS:open('c_syntuc')
  drgDBMS:open('c_grupuc')
  drgDBMS:open('c_triduc')

  ** tree a postValidate
  drgDBMS:open('c_triduc',,,,,'c_triducw')
  drgDBMS:open('c_grupuc',,,,,'c_grupucw')
  drgDBMS:open('c_syntuc',,,,,'c_syntucw')
  drgDBMS:open('c_uctosn',,,,,'c_uctosnw')

  * new
  drgDBMS:open('vyrZak') ;  vyrZak->( ordSetFocus( 'VYRZAK1' ))
                            vyrZak->( ads_setAof( cflt_vyrZak ), dbgoTop() )
  drgDBMS:open('vyrPol') ;  vyrPol->( ordSetFocus( 'VYRPOL1' ))
                            vyrPol->( ads_setAof( cflt_vyrPol ), dbgoTop() )
RETURN self


METHOD VYR_vyrPol_tree:eventHandled(nEvent, mp1, mp2, oXbp)
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

  case(nevent = drgEVENT_EDIT  .or. nevent = drgEVENT_APPEND)
    cc := 'M->cucet'

    if nevent = drgEVENT_APPEND
      ::dm:refreshAndSetEmpty( 'm' )
      ::state := 2
    else
      ::state := 1
    endif

    ::o_cucet:odrg:isEdit := (nevent = drgEVENT_APPEND)
    ::drgDialog:oForm:setNextFocus(cc,, .T. )
    return .t.

 case nEvent = drgEVENT_SAVE
    if SetAppFocus():ClassName() <> 'XbpBrowse'
      ::postSave()
    endif
    return .t.

  CASE nEvent = drgEVENT_DELETE
    if( .not. ::is_intree, ::postDelete(), nil )
    return .t.

  CASE nEvent = xbeP_Keyboard .and. .not. ::is_intree
    IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
      ::restColor()
      ::esc_focustobrow()
      return .t.
    ELSE
      RETURN .F.
    ENDIF

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.


method VYR_vyrPol_tree:treeViewInit(drgObj)
  local  oColumns, oColumn, citem
  *
  local  hRoot, h
  local  oFont_task  := XbpFont():new():create( "9.Helvetica" )
  local  nColor_task := AutomationTranslateColor( GRA_CLR_BLUE, .f. )
//  local  oBord       := drgObj:oXbp, apos := drgObj:oxbp:currentPos(), asize := drgObj:oxbp:currentSize()
  local  oBord       := drgObj:oBord, apos := drgObj:oxbp:currentPos(), asize := drgObj:oxbp:currentSize()
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

  oColumn := ::oTree:Columns():Add('èíslo_Zakázky')
             oColumn:AllowSort := .f.
             oColumn:Width     := 80
*             oColumn:WidthAutoResize := .T.
  oColumn := ::oTree:Columns():Add('typ/ èíslo výkresu')
             oColumn:AllowSort       := .f.
*             oColumn:WidthAutoResize := .T.
  oColumn := ::oTree:Columns():Add('název')
             oColumn:AllowSort       := .f.
*             oColumn:WidthAutoResize := .T.
  oColumn := ::oTree:Columns():Add('dávka (ks)')
             oColumn:AllowSort       := .f.
*             oColumn:WidthAutoResize := .T.

  oItems := ::oTree:Items()

  ::oTree:BeginUpdate()

  do while .not. vyrZak->( eof())
    if .not. empty(ccisZakaz := upper(vyrZak->ccisZakaz))

      if vyrPol->( dbseek( upper(ccisZakaz),,'VYRPOL1'))

        vyrPol->(dbsetscope(SCOPE_BOTH,upper(ccisZakaz)),dbgotop())

        if vyrPol->sid <> 0
           hRoot  := oItems:addItem(ccisZakaz)
                     oItems:setProperty( "CellFont"     , hRoot, 0, oFont_task )
                     oItems:setProperty( "CellForeColor", hRoot, 0, nColor_task)
                     oItems:SetProperty( "ExpandItem"   , hRoot,.T.)

           do while .not. vyrPol->( eof())
             h := oItems:InsertItem( hRoot,, vyrPol->cvyrPol )
                  oItems:SetProperty("CellCaption",h, 1, vyrPol->cvyrPol  )
                  oItems:SetProperty("CellCaption",h, 2, vyrPol->cnazev   )
                  oItems:SetProperty("CellCaption",h, 3, vyrPol->nmnZADva )

             vyrPol->( dbskip())
           enddo
        endif
        vyrPol->(dbClearScope())
      endif
    endif
    vyrZak->( dbskip())
  enddo

  ::oTree:EndUpdate()
return self


method VYR_vyrPol_tree:treeItemMarked(oitem, orect, oxbp)
  local  pt := listAsArray(oitem:cargo)
  local  pa := ::a_files

  (pt[1])->(dbGoTo(val(pt[2])))

  ::tabNum := ascan( pA, strTran(pt[1], 'w',''))
**  SetAppFocus(::dc:obrowse[::tabNum]:oxbp)

  ::dm:refresh()

  setAppFocus(oxbp)
return self


METHOD VYR_vyrPol_tree:drgDialogStart(drgDialog)
  local x

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
  next

*  ::oinfo_text:oxbp:setColorBG( GraMakeRGBColor( {200 ,255, 200} ) )
*  ::o_cucet := ::dm:has('m->cucet')
RETURN self


METHOD VYR_vyrPol_tree:tabSelect(drgTabPage, tabNum)
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


METHOD VYR_vyrPol_tree:postValidate(drgVar,lSelected, oxbp)                                     // kotroly a výpoèty
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


method VYR_vyrPol_tree:postSave()
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


method VYR_vyrPol_tree:postDelete()
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