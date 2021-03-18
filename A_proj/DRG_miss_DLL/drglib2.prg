//////////////////////////////////////////////////////////////////////
//
//  \TCDRGLib Standard drgUsrxxx functions
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      Library of standard drgUsrxxx functions
//
//  Remarks:
//
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "Xbp.ch"
#include "Drg.ch"
#include "drgRes.ch"
#include "Appevent.ch"
//
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


static o_icobd


*****************************************************************************
*****************************************************************************
FUNCTION drgPostUniqueKey(oVar)
LOCAL key := oVar:get()
LOCAL drgDialog := oVar:drgDialog
LOCAL has, cAlias := drgDialog:dbName
LOCAL mp1, mp2, oXbp, nEvent
LOCAL isAppend := Coalesce( drgDialog:dialogCtrl:isAppend, .F. )
* Check for the presence of key if adding record
  IF isAppend
* Key cannot be empty
    IF EMPTY(key)
      nEvent := LastAppEvent( @mp1,@mp2,@oXbp)
      IF mp1 = xbeK_ESC
        RETURN .T.
      ELSE
*        drgMsg(drgNLS:msg('Empty value not allowed!'),, drgDialog)
        drgMsgBox(drgNLS:msg('Empty value not allowed!'))
        RETURN .F.
      ENDIF
    ENDIF
* Check if key already exists
    drgDialog:pushArea()            // save SELECT() + ORDER()
    (cAlias)->( AdsSetOrder(1))
    has := (cAlias)->( DBSEEK(key))
    drgDialog:popArea()             // restore SELECT() + ORDER()
    IF has
*      drgMsg(drgNLS:msg('Key already exists!'),, drgDialog)
      drgMsgBox(drgNLS:msg('Key already exists!'))
      RETURN .F.
    ENDIF
* If edit (not ADD) don't allow key change
  ELSEIF oVar:changed()               // If changed
    oVar:recall()                     // restore initial value
*    drgMsg(drgNLS:msg('Key can not be changed!'),, drgDialog)
    drgMsgBox(drgNLS:msg('Key can not be changed!'))
    RETURN .F.
  ENDIF
RETURN .T.

**********************************************************************
* Function creates DRG standard IconBar, positioned on the top of the screen \
* filled with small icons. If you want to use your own \
* style of IconBar than you should write drgStdIcon bar function and link it \
* to your project.
*
* \bParameters:b\
* \< oParent >b\  : object : DrgDialog object which will use the iconBar.
*
* \b< Returns >b\ : object : of type drgAction.
**********************************************************************
FUNCTION drgStdIconBar(oParent)
LOCAL iconBar, size, pos, ms, oBord
*
local obd, rok, state, task, text

  oBord := oParent:dialog:drawingArea

  ms := drgNLS:msg('Quit dialog,Save changes and exit dialog,Save changes,Print,' + ;
                  'Edit record,Append new record with current data,' + ;
                  'Append new blank record,Delete record,' + ;
                  'First record,Previous record or page,' + ;
                  'Next record or page,Last record,Sort,Find,Filter O~N,' + ;
                  'Filter OFF,Documents,Help on dialog')

* Set size of drawing area
  size := ACLONE( oParent:dataAreaSize )
  size[2] := 24
* Set position of iconBar area
  pos  := ACLONE( oParent:dataAreaSize )
  pos[1] := 0
**  pos[2] += 2

* Create icon bar
  iconBar := drgActions():new(oParent, .t.)  // is_toolBar
  iconBar:create(oBord, pos, size)

* Put Icons (Actions) on a IconBar
  pos  := {4, 1}
  size := {24, 22}
* Separator
  iconBar:addAction( {pos[1],3}, {3, 18}, 0)
  pos[1] += 6
*
  iconBar:addAction( pos, size, 1, 460,,,, 'Znovu naèíst zdroj (CTRL_R)',misEVENT_BROREFRESH,.F., '0')
  drgParse(@ms)
*  iconBar:addAction( pos, size, 1, DRG_ICON_QUIT, gDRG_ICON_QUIT,,, drgParse(@ms),drgEVENT_QUIT,.F.)

  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_EXIT, gDRG_ICON_EXIT,,, drgParse(@ms),drgEVENT_EXIT,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_SAVE, gDRG_ICON_SAVE,,, drgParse(@ms),drgEVENT_SAVE,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_PRINT, gDRG_ICON_PRINT,,, drgParse(@ms),drgEVENT_PRINT,.F.)
* Separator line
  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
  iconBar:addAction( pos, size, 1, DRG_ICON_EDIT, gDRG_ICON_EDIT,,, drgParse(@ms),drgEVENT_EDIT,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_APPEND2, gDRG_ICON_APPEND2,,, drgParse(@ms),drgEVENT_APPEND2,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_APPEND, gDRG_ICON_APPEND,,, drgParse(@ms),drgEVENT_APPEND,.F., '0')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_DELETE, gDRG_ICON_DELETE,,, drgParse(@ms),drgEVENT_DELETE,.F.)

  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
  iconBar:addAction( pos, size, 1, DRG_ICON_TOP, gDRG_ICON_TOP,,, drgParse(@ms),drgEVENT_TOP,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_LEFT, gDRG_ICON_LEFT,,, drgParse(@ms),drgEVENT_PREV,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_RIGHT, gDRG_ICON_RIGHT,,, drgParse(@ms),drgEVENT_NEXT,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_BOTTOM, gDRG_ICON_BOTTOM,,, drgParse(@ms),drgEVENT_BOTTOM,.F., '2')

** nástroje tøídìní a hledání
  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
  iconBar:addAction( pos, size, 1, MIS_ICON_SORT,  gMIS_ICON_SORT,,, drgParse(@ms),misEVENT_SORT,.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_FIND,  gDRG_ICON_FIND,,, drgParse(@ms),misEVENT_SORT,.F.)

** nástroje tøídìní a hledání
  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
  iconBar:addAction( pos                  , ;
                     {size[1] *2, size[2]}, ;
                     1                    , ;
                     MIS_ICON_FILTER,     gMIS_ICON_FILTER    ,,'', drgParse(@ms),misEVENT_FILTER,.F.)
  oparent:act_Filter := atail(iconBar:members)

  pos[1] += (size[1] *2) +2
  iconBar:addAction( pos, size, 1, MIS_ICON_KILLFILTER, gMIS_ICON_KILLFILTER,,, drgParse(@ms),misEVENT_KILLFILTER,.F., '2')
  oparent:act_killFilter := atail(iconBar:members)

**
  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
  iconBar:addAction( pos, size, 1, DRG_ICON_DOCNEW,  gDRG_ICON_DOCNEW,,, drgParse(@ms),misEVENT_DOCUMENTS,.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, MIS_ICON_DATCOM1, gMIS_ICON_DATCOM1,,, drgParse(@ms),misEVENT_DATACOM,.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, MIS_ICON_SWHELP, gMIS_ICON_SWHELP,,, drgParse(@ms),misEVENT_SWHELP,.F.)

** help
  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
  iconBar:addAction( pos, size, 1, DRG_ICON_HELP, gDRG_ICON_HELP,,, drgParse(@ms),drgEVENT_HELP,.F.)

  * obdobi
  if .not. empty(task := oparent:formHeader:tskObdobi)
    pos  := ACLONE(oParent:dataAreaSize)
    editSize := size[1]+11*drgINI:fontW
    pos[1] -= editSize +1
    pos[2] := 1

    obd   := uctOBDOBI:&task:nobdobi
    rok   := uctOBDOBI:&task:nrok

    if uctOBDOBI:&task:culoha = 'M'
      drgDBMS:open('mzdZavHD')

      do case
      case uctOBDOBI:&task:lzavren  ;  state := MIS_ICON_QUIT
      otherwise
        *
        ** našel vystavený pøíkaz na mzdu ?
        if mzdZavHD->( dbseek( strZero(rok,4) +strZero(obd,2) +'1',,'MZDZAVHD13')) .and. drgINI:l_blockObdMzdy
          state := DRG_ICON_QUIT
        else
          state := DRG_ICON_EDIT
        endif
      endcase
    else

      state := if(uctOBDOBI:&task:lzavren,MIS_ICON_QUIT,DRG_ICON_EDIT)
    endif

    text  := '  ' +task +' ' +str(obd,2) +'/' +str(rok,4)

    iconBar:addAction(pos,{editSize,size[2]},3,state,state,,text,drgParse(@ms),'uct_ucetsys_inlib',.F.)

    o_icobd := atail(iconBar:members)
//    o_icobd:oxbp:SetGradientColors( { 0, if( uctOBDOBI:UCT:lzavren, 3, 5 ) } )
  endif
RETURN iconBar

*
**
function uct_ucetsys_inlib(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, task := drgDialog:formHeader:tskObdobi, obd, rok
  *
  local  old_obd := uctOBDOBI:&task:nobdobi, old_rok := uctOBDOBI:&task:nrok
  local  state_y
  local  o_obd   := atail( drgDialog:oIconBar:members )
  *
  local  oIcon   := XbpIcon():new():create()


  DRGDIALOG FORM 'UCT_ucetsys,' +task  PARENT drgDialog MODAL DESTROY EXITSTATE nExit

  if nexit <> drgEVENT_QUIT
    obd     := uctOBDOBI:&task:nobdobi
    rok     := uctOBDOBI:&task:nrok

    if uctOBDOBI:&task:culoha = 'M'
      drgDBMS:open('mzdZavHD')

      do case
      case uctOBDOBI:&task:lzavren  ;  state_y := MIS_ICON_QUIT
      otherwise
        *
        ** našel vystavený pøíkaz na mzdu ?
        if mzdZavHD->( dbseek( strZero(rok,4) +strZero(obd,2) +'1',,'MZDZAVHD13'))
          state_y := DRG_ICON_QUIT
        else
          state_y := DRG_ICON_EDIT
        endif
      endcase
    else

      state_y := if(uctOBDOBI:&task:lzavren,MIS_ICON_QUIT, DRG_ICON_EDIT)
    endif

    oicon:load( NIL, state_y )

    o_obd:oxbp:setImage  ( oicon )
    o_obd:oxbp:setCaption( '  ' +task +' ' +str(obd,2) +'/' +str(rok,4) )
//    o_obd:oxbp:SetGradientColors( { 0, if( uctOBDOBI:UCT:lzavren, 3, 5 ) } )


    if old_rok <> rok .or. old_obd <> obd
      PostAppEvent( drgEVENT_ACTION, 'postChangeObdobi', '0', drgDialog:dialog)
      postAppEvent( drgEVENT_ACTION, drgEVENT_OBDOBICHANGED, '0', drgDialog:dialog)
    endif
  endif
return .t.



**********************************************************************
* Standard browsing iconbar.
*
* \bParameters:b\
* \< oParent >b\  : object : DrgDialog object which will use the iconBar.
*
* \b< Returns >b\ : object : of type drgAction.
**********************************************************************
FUNCTION drgStdBrowseIconBar(oParent)
LOCAL iconBar, size, pos, ms, oBord
*
local obd, rok, state, task, text

  oBord := oParent:dialog:drawingArea

  ms := drgNLS:msg('Close dialog,Print,' + ;
                  'To first record,Previous page,' + ;
                  'Next page,To last record,' + ;
                  'Find,Help on dialog')

* Set size of drawing area
  size := ACLONE( oParent:dataAreaSize )
  size[2] := 24
* Set position of iconBar area
  pos  := ACLONE( oParent:dataAreaSize )
  pos[1] := 0
  pos[2] += 0
* Create icon bar
  iconBar := drgActions():new(oParent,.t.)
  iconBar:create(oBord, pos, size)
* Put Icons (Actions) on a IconBar
  pos  := {4, 1}
  size := {24, 22}
* Separator
  iconBar:addAction( {pos[1],3}, {3, 18}, 0)
  pos[1] += 6
*
  iconBar:addAction( pos, size, 1, 460,,,, 'Znovu naèíst zdroj (CTRL_R)',misEVENT_BROREFRESH,.F., '0')
  drgParse(@ms)
*  iconBar:addAction( pos, size, 1, DRG_ICON_QUIT, gDRG_ICON_QUIT,,, drgParse(@ms),drgEVENT_QUIT,.F.)

  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_PRINT, gDRG_ICON_PRINT,,, drgParse(@ms),drgEVENT_PRINT,.F.)
* Separator line
  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
  iconBar:addAction( pos, size, 1, DRG_ICON_TOP, gDRG_ICON_TOP,,, drgParse(@ms),drgEVENT_TOP,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_LEFT, gDRG_ICON_LEFT,,, drgParse(@ms),drgEVENT_PREV,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_RIGHT, gDRG_ICON_RIGHT,,, drgParse(@ms),drgEVENT_NEXT,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_BOTTOM, gDRG_ICON_BOTTOM,,, drgParse(@ms),drgEVENT_BOTTOM,.F., '2')

** filtry
  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4

  iconBar:addAction( pos                  , ;
                     {size[1] *2, size[2]}, ;
                     1                    , ;
                     MIS_ICON_FILTER,     gMIS_ICON_FILTER    ,,'', drgParse(@ms),misEVENT_FILTER,.F.)
  oparent:act_Filter := atail(iconBar:members)

  pos[1] += (size[1] *2) +2
  iconBar:addAction( pos, size, 1, MIS_ICON_KILLFILTER, gMIS_ICON_KILLFILTER,,, drgParse(@ms),misEVENT_KILLFILTER,.F., '2')
  oparent:act_killFilter := atail(iconBar:members)

  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
  iconBar:addAction( pos, size, 1, DRG_ICON_HELP, gDRG_ICON_HELP,,, drgParse(@ms),drgEVENT_HELP,.F.)

*  pos[1] += 26
*  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
*  pos[1] += 4
*  iconBar:addAction( pos, size, 1, DRG_ICON_HELP, gDRG_ICON_HELP,,, drgParse(@ms),drgEVENT_HELP,.F.)

  * obdobi
  if .not. empty(task := oparent:formHeader:tskObdobi)
    pos  := ACLONE(oParent:dataAreaSize)
    editSize := size[1]+11*drgINI:fontW
    pos[1] -= editSize +1
    pos[2] := 1

    obd   := uctOBDOBI:&task:nobdobi
    rok   := uctOBDOBI:&task:nrok
    state := if(uctOBDOBI:&task:lzavren,MIS_ICON_QUIT,DRG_ICON_EDIT)
    text  := '  ' +task +' ' +str(obd,2) +'/' +str(rok,4)

    iconBar:addAction(pos,{editSize,size[2]},3,state,state,,text,drgParse(@ms),'uct_ucetsys_inlib',.F.)

    o_icobd := atail(iconBar:members)
    o_icobd:frameState := 2
  endif
RETURN iconBar

**********************************************************************
* Standard iconbar for editing documents.
*
* \bParameters:b\
* \< oParent >b\  : object : DrgDialog object which will use the iconBar.
*
* \b< Returns >b\ : object : of type drgAction.
**********************************************************************
FUNCTION drgStdDocumentIconBar(oParent)
LOCAL iconBar, size, pos, ms, oBord
  oBord := oParent:dialog:drawingArea

  ms := drgNLS:msg('Quit dialog,Print,' + ;
                  'Create new document,View document,Delete document,' + ;
                  'First record,Previous record or page,' + ;
                  'Next record or page,Last record,Find,' + ;
                  'Help on dialog')

* Set size of drawing area
  size := ACLONE( oParent:dataAreaSize )
  size[2] := 24
* Set position of iconBar area
  pos  := ACLONE( oParent:dataAreaSize )
  pos[1] := 0
* pos[2] += 2
* Create icon bar
  iconBar := drgActions():new(oParent)
  iconBar:create(oBord, pos, size)
* Put Icons (Actions) on a IconBar
  pos  := {4, 1}
  size := {24, 22}
* Separator
  iconBar:addAction( {pos[1],3}, {3, 18}, 0)
  pos[1] += 6
*
  iconBar:addAction( pos, size, 1, 460,,,, 'Znovu naèíst zdroj (CTRL_R)',misEVENT_BROREFRESH,.F., '0')
  drgParse(@ms)
*  iconBar:addAction( pos, size, 1, DRG_ICON_QUIT, gDRG_ICON_QUIT,,, drgParse(@ms),drgEVENT_QUIT,.F.)

  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_PRINT, gDRG_ICON_PRINT,,, drgParse(@ms),drgEVENT_PRINT,.F.)
* Separator line
  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
  iconBar:addAction( pos, size, 1, DRG_ICON_DOCNEW, gDRG_ICON_DOCNEW,,, drgParse(@ms),'documentNew',.F., '0')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_DOCVIEW, gDRG_ICON_DOCVIEW,,, drgParse(@ms),'documentView',.F., '0')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_DOCDEL, gDRG_ICON_DOCDEL,,, drgParse(@ms),'documentDelete',.F., '0')
*
  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
  iconBar:addAction( pos, size, 1, DRG_ICON_TOP, gDRG_ICON_TOP,,, drgParse(@ms),drgEVENT_TOP,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_LEFT, gDRG_ICON_LEFT,,, drgParse(@ms),drgEVENT_PREV,.F., '2')

  pos[1] += 24
  iconBar:addAction( pos, size, 1, 460,,,, 'Znovu naèíst zdroj (CTRL_R)',misEVENT_BROREFRESH,.F., '0')

  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_RIGHT, gDRG_ICON_RIGHT,,, drgParse(@ms),drgEVENT_NEXT,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_BOTTOM, gDRG_ICON_BOTTOM,,, drgParse(@ms),drgEVENT_BOTTOM,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_FIND, gDRG_ICON_FIND,,, drgParse(@ms),drgEVENT_FIND,.F.)

  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
  iconBar:addAction( pos, size, 1, DRG_ICON_HELP, gDRG_ICON_HELP,,, drgParse(@ms),drgEVENT_HELP,.F.)
RETURN iconBar


****************************************************************************
* Procedure creates a menu system for standard dialog window. If end user
* wants to have a menu system of its own, he must write <drgINI:stdDialogMenu>
* function with same parameters.
*
* /bParameters:b/
* <oMenuBar>  : object : xbpDialog menuBar
****************************************************************************
procedure drgStdDialogMenu(oMBar, drgDialog)
  local oDMenu, oEMenu, oNMenu, oHMenu
  *
  local odlg := drgDialog:dialog
  local ms   := drgNLS:msg('~Dialog,~Save,Save/E~xit,Print,~Quit,' + ;
                            '~Edit,Edit,Add+,Add,Delete,' + ;
                            'First,Next,Previous,Last,Find,~Find next,' + ;
                            '~Tools,Sort,Filtrs,Kill Filtrs,' + ;
                            'Documents,Datacom,~Swhelp,' + ;
                            '~Help,Help Index,Help,About')

  oDMenu := XbpImageMenu():new(oMBar)
  oDMenu:title   := drgParse(@ms)
  oDMenu:barText := strTran(oDMenu:title,'~','')
  oDMenu:create()

* dialog
  oDMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+S', ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_SAVE, '2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 500 )

  oDMenu:addItem( {drgParse(@ms) +chr(9) +'Alt+X' , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_EXIT, '2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 501 )

  oDMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+P', ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_PRINT, '2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 502 )

  oDMenu:addItem( {NIL,;
                  {|| NIL}, XBPMENUBAR_MIS_SEPARATOR, XBPMENUBAR_MIA_OWNERDRAW } )

  oDMenu:addItem( {drgParse(@ms) +chr(9) +'ALt+Q' , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_QUIT, '0', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 503 )

* editace
  oEMenu := XbpImageMenu():new(oMBar)
  oEMenu:title   := drgParse(@ms)
  oEMenu:barText := strTran(oEMenu:title,'~','')
  oEMenu:create()

  oEMenu:addItem( {drgParse(@ms) +chr(9) +'Enter'     , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_EDIT,   '2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 510 )

  oEMenu:addItem( {drgParse(@ms) +chr(9) +'F3'       , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_APPEND2,'2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 511 )

  oEMenu:addItem( {drgParse(@ms) +chr(9) +'Ins'       , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_APPEND, '0', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 512 )

  oEMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+Del'  , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_DELETE, '0', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 513 )

  oEMenu:addItem( {NIL,;
                  {|| NIL}, XBPMENUBAR_MIS_SEPARATOR, XBPMENUBAR_MIA_OWNERDRAW } )

  oEMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+PgUp' , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_TOP,    '2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 514 )

  oEMenu:addItem( {drgParse(@ms) +chr(9) +'PgUp'      , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_PREV,   '2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 515 )

  oEMenu:addItem( {drgParse(@ms) +chr(9) +'PgDn'      , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_NEXT,   '2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 516 )

  oEMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+PgDn' , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_BOTTOM, '2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 517 )

* nástroje
  oNMenu := XbpImageMenu():new(oMBar)
  oNMenu:title   := drgParse(@ms)
  oNMenu:barText := strTran(oNMenu:title,'~','')
  oNMenu:create()

  oNMenu:addItem( {drgParse(@ms) +chr(9) +'F7'       , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, misEVENT_SORT,   '2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 520 )

  oNMenu:addItem( {NIL,;
                  {|| NIL}, XBPMENUBAR_MIS_SEPARATOR, XBPMENUBAR_MIA_OWNERDRAW } )

  oNMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+F'    , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_FIND,   '2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 521 )

  oNMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+N'    , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_FINDNXT,'2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }      )

  oNMenu:addItem( {NIL,;
                  {|| NIL}, XBPMENUBAR_MIS_SEPARATOR, XBPMENUBAR_MIA_OWNERDRAW } )

  oNMenu:addItem( {drgParse(@ms) +chr(9) +'F8'       , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, misEVENT_FILTER, '2', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 522 )

  oNMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+F8'  , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, misEVENT_KILLFILTER, '0', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 523 )

  oNMenu:addItem( {NIL,;
                  {|| NIL}, XBPMENUBAR_MIS_SEPARATOR, XBPMENUBAR_MIA_OWNERDRAW } )

  oNMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+D'  , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, misEVENT_DOCUMENTS, '0', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 524 )

  oNMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+C'  , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, misEVENT_DATACOM, '0', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 525 )

  oNMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+W'  , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, misEVENT_SWHELP, '0', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 526 )


* nápovìda
  oHMenu := XbpImageMenu():new(oMBar)
  oHMenu:title   := drgParse(@ms)
  oHMenu:barText := strTran(oHMenu:title,'~','')
  oHMenu:create()

  oHMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+N'    , ;
                  { || drgHelp:showHelpContents() }                                         ,,;
                  XBPMENUBAR_MIA_OWNERDRAW       }      )

  oHMenu:addItem( {drgParse(@ms) +chr(9) +'F1'        , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_HELP, '0', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 530 )

  oHMenu:addItem( {NIL,;
                  {|| NIL}, XBPMENUBAR_MIS_SEPARATOR, XBPMENUBAR_MIA_OWNERDRAW } )

  oHMenu:addItem( {drgParse(@ms)                      , ;
                  { |a| _drgCallAboutDialog(oMbar:setOwner()) }                          ,, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 531 )


  // Add popup-menus to menubar
  oMbar:measureItem := {|nItem,aDims,self| MeasureMenubarItem(oDlg,self,nItem,aDims) }
  oMbar:drawItem    := {|oPS,aInfo,self  | DrawMenubarItem(oDlg,self,oPS,aInfo) }

  oMbar:addItem( {oDMenu,,, NIL })    // XBPMENUBAR_MIA_OWNERDRAW} )
  oMbar:addItem( {oEMenu,,, NIL })    // XBPMENUBAR_MIA_OWNERDRAW} )
  oMbar:addItem( {oNMenu,,, NIL })    // XBPMENUBAR_MIA_OWNERDRAW} )
  oMbar:addItem( {oHMenu,,, NIL })    // XBPMENUBAR_MIA_OWNERDRAW} )
return