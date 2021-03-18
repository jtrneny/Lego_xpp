#include "Common.ch"
#include "Xbp.ch"
#include "Drg.ch"
#INCLUDE 'DRGRES.ch'
#INCLUDE 'DBSTRUCT.ch'
#include "AppEvent.ch"
#include "Directry.ch"
#include "gra.ch"
#include "ads.ch"
#include "foxdbe.ch"
#include "adsdbe.ch"
#include "dmlb.ch"
#include "ads.ch"
#include "odbcdbe.ch"

#include "..\Asystem++\Asystem++.ch"

#pragma library ("Xppui2.lib")
#pragma library ("ADSUTIL.lib")
#pragma library( "ADAC20B.LIB" )
#pragma library("odbcut10.lib")


static  o_icobd


** pracovnÌ adres·¯ uûivatele
function userWorkDir()
  local processID := if(isWorkVersion, '', allTrim(str(GetCurrentProcessId())))
  local cthreadID := allTrim(str(ThreadID()))

return 'dir_' +processID +cthreadID


* Kontrola na vyplnÏnÌ ˙daje :  tvrd· kontrola = ˙daj povinn˝   lDUE = .T.
*                               mÏkk· kontrola = ˙daj nepovinn˝ lDUE = .F.
*===============================================================================
FUNCTION ControlDUE( oVar, lDUE)
  LOCAL  xVar := oVar:get(), lOK := .T., cMsg

  DEFAULT lDUE TO .T.
  IF EMPTY( xVar)
    cMsg := IF( lDUE, ': ... ˙daj musÌ b˝t vyplnÏn !',;
                      ': ... POZOR, ˙daj nebyl vyplnÏn !' )
    drgMsgBox(drgNLS:msg( oVar:ref:caption + cMsg),, oVar:drgDialog:dialog)
    lOK := !lDUE
  ENDIF
RETURN lOK


********************************************************************************
* Funkce nastavujÌcÌ poloûku na (ne)editovatelnou.
* Parametry:
*   xField ... n·zev poloûky nebo pole n·zv˘ poloûek
*   oDialog... formul·¯
*   IsEdit ... .F. = needitovateln·, .T. = editovateln·
********************************************************************************
FUNCTION IsEditGET( xField, oDialog, IsEdit )
  Local nPos, n, drgVar, xHelp
  Local aValues := oDialog:dataManager:vars:values
  Local NoEdit := GraMakeRGBColor( {221,221,221})

  IF IsCharacter( xField) // nastavenÌ u jednÈ poloûky
    xHelp  := xField
    xField := {}
    AADD( xField, xHelp)
  ENDIF

  IF IsArray( xField)    // nastavenÌ u vÌce poloûek definovan˝ch v poli
    FOR n := 1 TO LEN( xField)
      nPos := aSCAN( aValues, xField[ n])
      IF nPOS <> 0
        drgVar := aValues[ nPos, 2]
        drgVar:oDrg:IsEdit := IsEdit
        drgVar:oDrg:oXbp:setColorBG(IF( IsEdit, XBPSYSCLR_WINDOW, NoEdit))
        IF drgVar:oDrg:ClassName() = 'drgGet'
          IF IsObject(drgVar:oDrg:pushGet) .and. drgVar:oDrg:pushGet:ClassName() = 'drgPushButton'
            drgVar:oDrg:pushGet:disabled := !IsEdit
          ENDIF
        ELSEIF drgVar:oDrg:ClassName() = 'drgComboBox'
          drgVar:oDrg:disabled := !IsEdit
        ENDIF
      ENDIF
    NEXT
  ENDIF
RETURN Nil

*****************************************************************
* Funkce realizuje validaci mechanismem v˝bÏru z ËÌselnÌku.
* Parametry:
* oDialog - dialog z nÏhoû je funkce vol·na
* xField  - typ character => validace danÈ poloûky p¯es button ...
*           typ array => validace p¯es kl·vesu F4
* cOrder  - nastavenÌ t¯ÌdÏnÌ, implicitnÏ tag 1
*****************************************************************
FUNCTION Vld_CISEL( oDialog, xField )
  Local nPosField := 1, nPosValues, drgVar
  Local aValues := oDialog:dataManager:vars:values
  Local cField := oDialog:oForm:oLastDrg:Name
  Local cSearchFile, cSearchVal, cType, cOrder
  Local cRetVal, cRetValHlp

  If LEN( xField) = 1                                  // validace p¯es ...
    cField := xField[ 1, 1]
  Else                                                 // validace p¯es F4
    nPosField := aSCAN( xFIELD,{|X| X[1] = cField } )
  EndIf

  If nPosField <> 0
    nPosValues := aSCAN( aVALUEs, cField)
    IF nPosValues <> 0
      drgVar := aVALUEs[nPosValues,2]
      SetAppFocus(drgVar:oDrg:oXbp)

      If LEN( xField[ nPosField]) = 1
        cSearchFILE := drgVar:ref:relTO
        cType := drgVar:ref:type
        cSearchVal := If ( cType = 'N', STR( drgVar:Value),;
                                        drgVar:Value )
        cOrder := '1'
      ELSE
        cSearchFILE := xField[ nPosField, 2]
        cType := ValType( drgVar:Value)
        cSearchVal := If ( cType = 'N', STR( drgVar:Value),;
                                        drgVar:Value )
        cOrder := If( LEN( xField[ nPosField]) >= 3, xField[ nPosField, 3], '1')
      ENDIF
      cRetVal := oDialog:dataManager:get( cField)
      cRetValHlp := drgCallSearch( oDialog, cSearchFile, cSearchVal, cOrder )
      cRetVal := If( IsNil( cRetValHlp), cRetVal, cRetValHlp )
      oDialog:dataManager:set( cField, cRetVal )
    END
  End

Return nil

*****************************************************************
* Dohled·nÌ sazby DPH ... dle kÛdu DPH
* Parametry:
* nKod  - kÛd sazby DPH
*****************************************************************
FUNCTION SeekKodDPH( nKod)
  Local nSazba, cTag

  IF( Used('C_DPH'), NIL, drgDBMS:open('C_DPH'  ))
  cTAG := C_DPH->( AdsSetOrder( 1))
  nSazba := If( C_DPH->( dbSeek( nKod)), C_DPH->nProcDph, 0)
  C_DPH ->( AdsSetOrder( cTAG))
RETURN( nSazba)

*****************************************************************
* Dohled·nÌ sazby DPH ... dle typu a data platnosti
* Parametry:
* nNapocet - typ n·poËtu ( 1 - snÌûen· sazba, 2 - z·kladnÌ sazba
* dDatum   - datum, od kterÈho sazba platÌ
*****************************************************************
FUNCTION SeekSazDph( nNapocet, dDatum)
  Local nSazba := 0, cTAG, lCyklus := YES

  DEFAULT dDATUM To DATE()

  cTAG := C_DPH->( AdsSetOrder( 3))
  C_DPH ->( dbSetScope(SCOPE_BOTH, STRZERO( nNapocet, 2)))

  C_DPH->( dbGoBOTTOM())
  DO WHILE !C_DPH->( BOF()) .AND. lCyklus
    IF dDatum >= C_DPH->dDatPlat
      nSazba := C_DPH->nProcDPH
      lCyklus := NO
    ENDIF
    C_DPH->( dbSKIP( -1))
  ENDDO
  C_DPH ->( dbClearScope())
  C_DPH ->( AdsSetOrder( cTAG))
RETURN( nSazba)

*****************************************************************
* PlnÏnÌ systÈmov˝ch ˙daju o manipulaci se z·znamem
*****************************************************************
FUNCTION SysFLD( cFile, lNewRec)

  mh_WRTzmena( cFile, lNewRec)

RETURN Nil

*****************************************************************
* ÿetÏzec s oddÏlovaËi p¯evede na pole
*****************************************************************
FUNCTION ListAsArray( cList, cDelimiter )
  LOCAL nPos
  LOCAL aList := {}

  DEFAULT cDelimiter To ','
  Do While (nPos := aT( cDelimiter, cList)) != 0
    aAdd( aList, SubStr( cList, 1, nPos - 1))
    cList := SubStr( cList, nPos +Len( cDelimiter) )
  EndDo
  aAdd(aList, cList)
RETURN( aList)


*****************************************************************
* P¯epnutÌ indexu
*****************************************************************
FUNCTION FordRec( acAlias)
  Static  axOrdRec
  Local   n, cA, nO, nPosIn

  if acAlias == NIL
    for n = 1 to len( axOrdRec)
      ( axOrdRec[n,1]) ->( AdsSetOrder( axOrdRec[n,2]))
      ( axOrdRec[n,1]) ->( dbGoto( axOrdRec[n,3]))
    next
  else
    axOrdRec := {}
    for n = 1 to len( acAlias)
      If( nPosIn := At( ',', acAlias[ n])) == 0
        cA := acAlias[ n]
        nO := ( cA) ->( ordSetFocus())
      Else
        cA := SubStr( acAlias[n], 1, nPosIn -1)
        nO := Val( substr( acAlias[n], nPosIn +1) )
      EndIf

      * musÌme d·t pozor na zruöenÈ z·znamy,
      * pokud n·hodou stojÌme na zruöenÈm z·znamu, doölo by k p·du

      if( (cA) ->(deleted()), (cA)->(dbGoTop()), nil )

      aadd( axOrdRec, { cA, ( cA) ->( OrdSetFocus()), ( cA) ->(recNo()) } )
      ( cA) ->( AdsSetOrder( nO))
    next
  endif
RETURN Nil


*****************************************************************
* P¯id·nÌ z·znamu
****************************************************************
FUNCTION ADDrec(cAlias,nSec)
  Local  lForever, lOk := .F.

  DEFAULT cAlias TO ALIAS(), nSec TO .5

  Begin Sequence
    (cAlias) ->(DbAppend())
    IF !NetErr()
      IF (cAlias) ->(RLock())
        lOk := .T.
  Break
      ENDIF
    ENDIF


    lForever := (nSec = 0)
    DO WHILE (lForever .or. nSec > 0)
      (cAlias) ->(DbAppend())
      IF !NetErr()
        IF (cAlias) ->(RLock())
          lOk := .T.
  Break
        ENDIF
      ENDIF
    ENDDO
  End Sequence
RETURN lOk


*****************************************************************
* ZruöenÌ z·znamu
****************************************************************
FUNCTION DELrec(cAlias)
  Local lOK := .F.

  Default cAlias To Alias()

  IF (cAlias) ->( drgLockOK())
    (cAlias) ->( DbDelete(), DbUnlock())
    lOK := .T.
  ENDIF
RETURN lOK


*****************************************************************
* UzamËenÌ z·znamu pro opravu
****************************************************************
FUNCTION REPLrec(cAlias)
  Local cOldArea := Alias(), lOK := .F.

  Default cAlias To Alias()

  IF ( (cAlias)->( Eof()) .and. (cAlias)->( Bof()) )
    Return lOK
  ENDIF

  SELECT( cAlias)
  IF (cAlias) ->( drgLockOK())
    lOK := .T.
  ENDIF
  IF( EMPTY( cOldArea), NIL, dbSelectAREA( cOldArea) )
RETURN lOK

/*
p¯esunuto do mh_.prg
//-------KOPIE POLOZEK DB -> DB-----------------------------------
Function mh_COPYFLD(cDBFrom,cDBTo,lDBApp,IsMain,aLock)
  Local  nPOs
  Local  xVAL
  Local  aFrom := ( cDBFrom) ->( dbStruct())

  Default lDBApp To .F., IsMain TO .T.

  If( lDBApp, (cDBTo) ->( DbAppend()), Nil )

  AEval( aFrom, { |X,M| ;
             ( xVal := ( cDBFrom) ->( FieldGet( M))                        , ;
               nPos := ( cDBTo  ) ->( FieldPos( X[ DBS_NAME]))             , ;
               If( nPos <> 0, ( cDBTo) ->( FieldPut( nPos, xVal)), Nil ) ) } )

  // zavedena konvence u TMP poloûka _nrecor pro z·mky p¯i ukl·d·nÌ //
  IF IsMain .and. (nPOs := (cDBTo) ->(FieldPos('_nrecor'))) <> 0
    (cDBTo) ->(FieldPut(nPOs, (cDBFrom) ->(RecNo())))
    IF(IsARRAY(aLock), AAdd(aLock,(cDBFrom) ->(RecNo())),NIL)
  ENDIF
Return( Nil)


//-------VYPR¡ZDNÃNÕ Z¡ZNAMU-----------------------------------
Function mh_BLANKREC(cALIAs,nPOs)
  Local  nFLD, nFLDc := ( cALIAs) ->( FCOUNT())
  Local  xVAL, aSTRU := ( cALIAs) ->( dbSTRUCT())

  DEFAULT nPOs TO 1

  For nFLD := nPOs TO nFLDc STEP 1
    Do Case
    Case aSTRU[ nFLD, DBS_TYPE ] == 'C' .OR. ;
         aSTRU[ nFLD, DBS_TYPE ] == 'M' .OR. ;
         ( aSTRU[ nFLD, DBS_TYPE ] == 'V' .AND. aSTRU[ nFLD, DBS_LEN ] >= 6 )
      xVAL := ''
    Case aSTRU[ nFLD, DBS_TYPE ] == 'N' .OR. ;
         ( aSTRU[ nFLD, DBS_TYPE ] == 'V' .AND. aSTRU[ nFLD, DBS_LEN ] == 4 )
      xVAL := 0
    Case aSTRU[ nFLD, DBS_TYPE ] == 'D' .OR. ;
         ( aSTRU[ nFLD, DBS_TYPE ] == 'V' .AND. aSTRU[ nFLD, DBS_LEN ] == 3 )
      xVAL := CTOD( '')
    Case aSTRU[ nFLD, DBS_TYPE ] == 'L'
      xVAL := .F.
    EndCase
      ( cALIAs) ->( FieldPUT( nFLD, xVAL))
  Next
Return( Nil)
*/


FUNCTION myIconBar(oParent)
LOCAL iconBar, size, pos, ms, oBord, task, editSize
*
local obd, rok, state, text

  oBord := oParent:dialog:drawingArea
/*
  ms := drgNLS:msg('Quit dialog,Save changes and exit dialog,Save changes,Print,' + ;
                  'Edit record,Append new record with current data,' + ;
                  'Append new blank record,Delete record,' + ;
                  'First record,Previous record or page,' + ;
                  'Next record or page,Last record,Find,' + ;
                  'Help on dialog')
*/
  ms := drgNLS:msg('Quit dialog,Save changes and exit dialog,Save changes,Print,' + ;
                  'Help on dialog')



* Set size of drawing area
  size := ACLONE( oParent:dataAreaSize )
  size[2] := 24
* Set position of iconBar area
  pos  := ACLONE( oParent:dataAreaSize )
  pos[1] := 0
* pos[2] += 2
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
  iconBar:addAction( pos, size, 1, DRG_ICON_QUIT, gDRG_ICON_QUIT,,, drgParse(@ms),drgEVENT_QUIT,.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_EXIT, gDRG_ICON_EXIT,,, drgParse(@ms),drgEVENT_EXIT,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_SAVE, gDRG_ICON_SAVE,,, drgParse(@ms),drgEVENT_SAVE,.F., '2')
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_PRINT, gDRG_ICON_PRINT,,, drgParse(@ms),drgEVENT_PRINT,.F.)



* Separator line
*  pos[1] += 26
*  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
*  pos[1] += 4
*  iconBar:addAction( pos, size, 1, DRG_ICON_EDIT, gDRG_ICON_EDIT,,, drgParse(@ms),drgEVENT_EDIT,.F., '2')
*  pos[1] += 24
*  iconBar:addAction( pos, size, 1, DRG_ICON_APPEND2, gDRG_ICON_APPEND2,,, drgParse(@ms),drgEVENT_APPEND2,.F., '2')
*  pos[1] += 24
*  iconBar:addAction( pos, size, 1, DRG_ICON_APPEND, gDRG_ICON_APPEND,,, drgParse(@ms),drgEVENT_APPEND,.F., '2')
*  pos[1] += 24
*  iconBar:addAction( pos, size, 1, DRG_ICON_DELETE, gDRG_ICON_DELETE,,, drgParse(@ms),drgEVENT_DELETE,.F.)

*  pos[1] += 26
*  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
*  pos[1] += 4
*  iconBar:addAction( pos, size, 1, DRG_ICON_TOP, gDRG_ICON_TOP,,, drgParse(@ms),drgEVENT_TOP,.F., '2')
*  pos[1] += 24
*  iconBar:addAction( pos, size, 1, DRG_ICON_LEFT, gDRG_ICON_LEFT,,, drgParse(@ms),drgEVENT_PREV,.F., '2')
*  pos[1] += 24
*  iconBar:addAction( pos, size, 1, DRG_ICON_RIGHT, gDRG_ICON_RIGHT,,, drgParse(@ms),drgEVENT_NEXT,.F., '2')
*  pos[1] += 24
*  iconBar:addAction( pos, size, 1, DRG_ICON_BOTTOM, gDRG_ICON_BOTTOM,,, drgParse(@ms),drgEVENT_BOTTOM,.F., '2')
*  pos[1] += 24
*  iconBar:addAction( pos, size, 1, DRG_ICON_FIND, gDRG_ICON_FIND,,, drgParse(@ms),drgEVENT_FIND,.F.)


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
    state := if(uctOBDOBI:&task:lzavren,MIS_ICON_QUIT,DRG_ICON_EDIT)
    text  := '  ' +task +' ' +str(obd,2) +'/' +str(rok,4)

    iconBar:addAction(pos,{editSize,size[2]},3,state,state,,text,drgParse(@ms),'uct_ucetsys_inalib',.F.)

    o_icobd := atail(iconBar:members)
    o_icobd:frameState := 2
  endif
RETURN iconBar


function uct_ucetsys_inalib(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, task := drgDialog:formHeader:tskObdobi, obd, rok
  *
  local  old_obd := uctOBDOBI:&task:nobdobi, old_rok := uctOBDOBI:&task:nrok
  local  state
  local  o_obd   := atail( drgDialog:oIconBar:members )
  *
  local  oIcon   := XbpIcon():new():create()

  DRGDIALOG FORM 'UCT_ucetsys,' +task  PARENT drgDialog MODAL DESTROY EXITSTATE nExit

  if nexit <> drgEVENT_QUIT
    obd   := uctOBDOBI:&task:nobdobi
    rok   := uctOBDOBI:&task:nrok
    state := if(uctOBDOBI:&task:lzavren,MIS_ICON_QUIT,DRG_ICON_EDIT)

    oicon:load( NIL, state )

    o_obd:oxbp:setImage  ( oicon )
    o_obd:oxbp:setCaption( '  ' +task +' ' +str(obd,2) +'/' +str(rok,4) )

    if old_rok <> rok .or. old_obd <> obd
      PostAppEvent( drgEVENT_ACTION, 'postChangeObdobi', '0', drgDialog:dialog)
      postAppEvent( drgEVENT_ACTION, drgEVENT_OBDOBICHANGED, '0', drgDialog:dialog)
    endif

  endif
return .t.


PROCEDURE myMenuBar( oMenuBar )
LOCAL oMenu, ms, mp12
/*
  ms := drgNLS:msg('~Dialog,~Save,Save/E~xit,Print,~Quit,' + ;
                  '~Edit,Edit,Add+,Add,Delete,' + ;
                  'First,Next,Previous,Last,Find,Find next,' + ;
                  '~Help,Help Index,Help,About')
*/
  ms := drgNLS:msg('~Dialog,~Save,Save/E~xit,Print,~N·povÏda,Index,N·povÏda,O aplikaci')


  oMenu       := XbpMenu():new(oMenuBar)
  oMenu:title := drgParse(@ms)
  oMenu:create()

  oMenu:addItem( {drgParse(@ms) + TAB + "Ctrl+S" , ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_SAVE, '2', obj ) }} )
  oMenu:addItem( {drgParse(@ms) + TAB + "Alt+X", ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_EXIT, '2', obj ) }} )
  oMenu:addItem( {drgParse(@ms) + TAB + "Ctrl+P" , ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drEVENT_PRINT, '2', obj ) }} )
*  oMenu:addItem( {NIL, NIL, XBPMENUBAR_MIS_SEPARATOR, 0} )
*  oMenu:addItem( {drgParse(@ms) + TAB + "Alt+Q", ;
*                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_QUIT, '0', obj ) }} )

  oMenuBar:addItem( {oMenu, NIL} )

* Edit menu
/*
  oMenu := XbpMenu():new(oMenuBar)
  oMenu:title := drgParse(@ms)
  oMenu:create()

  oMenu:addItem( {drgParse(@ms)+TAB+"Ctrl+E", ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_EDIT,   '2', obj ) }} )
  oMenu:addItem( {drgParse(@ms)+TAB+"Ctrl+D", ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_APPEND2,'2', obj ) }} )
  oMenu:addItem( {drgParse(@ms)+TAB+"Ctrl+A", ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_APPEND, '2', obj ) }} )
  oMenu:addItem( {drgParse(@ms)+TAB+"Ctrl+K", ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_DELETE, '0', obj ) }} )
  oMenu:addItem( {NIL, NIL, XBPMENUBAR_MIS_SEPARATOR, 0} )
  oMenu:addItem( {drgParse(@ms)+TAB+"Ctrl+PgUp" , ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_TOP,    '2', obj ) }} )
  oMenu:addItem( {drgParse(@ms)+TAB+"PgUp", ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_PREV,   '2', obj ) }} )
  oMenu:addItem( {drgParse(@ms)+TAB+"PgDn", ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_NEXT,   '2', obj ) }} )
  oMenu:addItem( {drgParse(@ms)+TAB+"Ctrl+PgDn", ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_BOTTOM, '2', obj ) }} )
  oMenu:addItem( {NIL, NIL, XBPMENUBAR_MIS_SEPARATOR, 0} )
  oMenu:addItem( {drgParse(@ms)+TAB+"Ctrl+F" , ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_FIND,   '2', obj ) }} )
  oMenu:addItem( {drgParse(@ms)+TAB+"Ctrl+N", ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_FINDNXT,'2', obj ) }} )

  oMenubar:addItem( {oMenu, NIL} )
*/
* Help menu
  oMenu := XbpMenu():new(oMenuBar)
  oMenu:title := drgParse(@ms)
  oMenu:create()

  oMenu:addItem( {drgParse(@ms), {|| drgHelp:showHelpContents()} } )
  oMenu:addItem( {drgParse(@ms)+TAB+"F1", ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, drgEVENT_HELP, '0', obj ) }} )

  oMenu:addItem( {NIL, NIL, XBPMENUBAR_MIS_SEPARATOR, 0} )
  oMenu:addItem( {drgParse(@ms) , {|| _drgCallAboutDialog()} } )

  oMenubar:addItem( {oMenu, NIL} )
RETURN


PROCEDURE myCreateDir( cDIR)
  SHCreateDirectoryExA( NIL, cdir, NIL)
return

/*
LOCAL cX, cY

  IF Empty( Directory( cDIR))
    cX := drgParse( cDIR, '\')
    cY := drgParseSecond( cDIR, '\')
    DO WHILE !Empty( cY)
      cX := cX +'\' +drgParse( cY, '\')
      cY := drgParseSecond( cY, '\')
      IF Empty( Directory( cX))
        CreateDir(cX)
      ENDIF
    ENDDO
  ENDIF
RETURN
*/

*****************************************************************
* Funkce realizuje nabÌdku pro v˝bÏr soubor˘
* Parametry:
* aFilters - pole filtru pro v˝bÏr soubor˘ nap¯. {{"DBF Files","*.DBF"},{"ADT Files","*.ADT"}}
*            hodnota m˘ûe b˝t i EMPTY
* cDirectory - je moûnÈ zadat default adres·¯ ...
* cExtension - je moûnÈ zadat p¯Ìponu souboru ketrÈ se majÌ zadat jinak *.*
* lMultiple  -
* N·vratov· hodnota:
* aFiles - pole vybran˝ch soubor˘ vËetnÏ cesty a extense
****************************************************************

FUNCTION selDIR( aFilters,cDirectory,cExtense,lMultiple,lRestDir,lnoAcces)
  Local aFiles := {}
  Local oDlg:=Nil, oFocus:=SetAppFocus()

  Default aFilters To {}
  Default cDirectory To "C:\ASYSTEM++\"
  Default cExtense To "*"
  Default lMultiple To .F.
  Default lRestDir  to .f.
  Default lnoAcces  to .f.

  Begin Sequence
     oDlg:=XbpFileDialog():new()
     oDlg:fileFilters:=aFilters
     oDlg:center:=.T.
     oDlg:noWriteAccess := lnoAcces
     oDlg:restoreDir := lRestDir
     oDlg:create()
     aFiles:=oDlg:open(cDirectory + "*." +cExtense,,lMultiple)
     oDlg:destroy()
     SetAppFocus(oFocus)
  End

RETURN(aFILES)


*****************************************************************
* Funkce realizuje nabÌdku pro v˝bÏr soubor˘
* Parametry:
* aFilters - pole filtru pro v˝bÏr soubor˘ nap¯. {{"DBF Files","*.DBF"},{"ADT Files","*.ADT"}}
*            hodnota m˘ûe b˝t i EMPTY
* cDirectory - je moûnÈ zadat default adres·¯ ...
* cExtension - je moûnÈ zadat p¯Ìponu souboru ketrÈ se majÌ zadat jinak *.*
* lMultiple  -
* N·vratov· hodnota:
* aFiles - pole vybran˝ch soubor˘ vËetnÏ cesty a extense
****************************************************************

FUNCTION selFILE(cFile,cExtense,cDirectory,cNazev,aFilters,lRestDir,lnoAcces,lcenter,lMultiple)
  Local oDlg :=Nil, oFocus:=SetAppFocus()

  Default cFile      To "*"
  Default aFilters   To {{'Vsechno','*.*'}}
  Default cNazev     To "V˝bÏr soubor˘"
  Default cDirectory To ""
  Default cExtense   To "*"
  Default lRestDir   to .f.
  Default lnoAcces   to .f.
  Default lcenter    to .t.
  Default lMultiple  to .f.

  Begin Sequence
     oDlg:=XbpFileDialog():new()
     oDlg:fileFilters   := aFilters
     oDlg:center        := lcenter
     oDlg:noWriteAccess := lnoAcces
     oDlg:restoreDir    := lRestDir
     oDlg:defExtension  := cExtense
     oDlg:title         := ConvToOemCP( cNazev )
     oDlg:create()
     aFiles             := oDlg:open(ConvToOemCP(cDirectory + cFile+'.'+cExtense),,lMultiple)
     oDlg:destroy()
     SetAppFocus(oFocus)
  End

RETURN(aFILES)


// vr·tÌ cestu vûdy s lomÌtkem na konci
function retDir(path)

  path := AllTrim( path)
  path := if( Right( path,1)== '\', path, path +'\')

return path


// p¯ednastavuje hodnotu DIST nebo USER podle hodnoty syOpravneni
function defaultDisUsr( oblast, konstanta)
  local  sdirW   := drgINI:dir_USERfitm
  local  sName   := sdirW +'c_opravn.mem'  // drgINI:dir_USERfitm +userWorkDir() +'\c_opravn.mem'
  local  lenBuff := 40960, buffer := space(lenBuff)
  local  ret

  * c_opravn v mBlock obsahuje popis povolen˝ch nasavenÌ pro filtr
  drgDBMS:open('c_opravn')
  c_opravn->(dbseek( syOpravneni,,'C_OPRAVN01'))
  memoWrit(sName,c_opravn->mBlock)

  getPrivateProfileStringA( oblast, konstanta, '', @buffer, lenBuff, sName)
  ret := substr(buffer,1,len(trim(buffer))-1)

return(ret)


Function DelDiakr( text)
  local  upp_Text  := upper(text)
  local  replChar  := {{'¡','A'},{'»','C'},{'œ','D'},{'Ã','E'},{'…','E'},  ;
                       {'Õ','I'},{'“','N'},{'”','O'},{'ÿ','R'},{'ä','S'},  ;
                       {'ç','T'},{'⁄','U'},{'›','Y'},{'é','Z'},            ;
                       {'·','a'},{'Ë','c'},{'Ô','d'},{'Ï','e'},{'È','e'},  ;
                       {'Ì','i'},{'Ú','n'},{'Û','o'},{'¯','r'},{'ö','s'},  ;
                       {'ù','t'},{'˙','u'},{'˘','u'},{'˝','y'},{'û','z'}}
  *
  local  povChar   :=  'ABCDEFGHIJKLMNOPQRSRUVWXYZ.1234567890?-()+:/ '
  local  c_retText := ''

  aEval( replChar, {|x| upp_Text := StrTran( upp_Text, x[1], x[2])})

  for x := 1 to len(upp_Text) step 1
    if ( substr(upp_Text, x, 1) $ povChar )
      c_retText += substr(upp_Text, x, 1)
    endif
  next
return( c_retText)

********************************************************************************
*                    FUNCTION IsLeapYear()
********************************************************************************
FUNCTION IsLeapYear(nYear)

   LOCAL lValid   := .F.

   IF !( nYear%4 == 0 )
      lValid = .F.
   ELSEIF nYear%400 == 0
      lValid = .T.
   ELSEIF nYear%100 == 0
      lValid = .F.
   ELSE
      lValid = .T.
   ENDIF
Return ( lValid )


// p¯Ìprava bloku pro vol·nÌ z mem poloûky
FUNCTION blok_mem(memStr, lisRun)
  LOCAL cStr := MemoTran(memStr, ', ', '')
**  LOCAL cStr := MemoTran(memStr, , '')

  default lisRun to .t.

  if lisRun
    DO WHILE At(',', cStr, Len(cStr)) <> 0
      cStr := SubStr(cStr,1,Len(cStr) -1)
    ENDDO
  else
    if At(',', cStr, Len(cStr)) <> 0
      cStr := SubStr(cStr,1,Len(cStr) -1)
    endif
  endif
return '(' +AllTrim( cStr) +')'


// vr·tÌ z osob p¯Ìsluön˝ ˙daj p¯ihl·öenÈho uûivatele
function retUsrOSOBY( val)
  local ret

  *
  drgDBMS:open('osoby',,,,,'osobyu')
  osobyu->( dbseek( logCisOsoby,,'OSOBY01'))
  ret := osobyu->&val

return(ret)


// zavÌracÌ info dialog
function SYS_MOMENT( cText)
  Local oDlg, oDraw, oStatic

  oDlg          := XbpDialog():new()
  oDlg:title    := "... MOMENT PROSÕM ..."
  oDlg:create( ,, {400,400}, {300,80} )
  oDlg:alwaysOnTop := .t.

  oDraw := oDlg:drawingArea
  oDraw:setColorBG(GraMakeRGBColor( {255 ,255, 200} ))      // GRA_CLR_GREEN)
  oDraw:setColorFG(GRA_CLR_BLACK)

  oStatic := XbpStatic():new(oDraw ,, {1, 20}, {299,20} )
  oStatic:autosize := .T.

  oStatic:type        := XBPSTATIC_TYPE_TEXT
  oStatic:options     := XBPSTATIC_TEXT_CENTER
  oStatic:caption     := PADC( Coalesce( cText, '... PROBÕH¡ ZPRACOV¡NÕ ...'), 75 )
*  oStatic:caption  := PADC( Coalesce( cText, '... PROBÕH¡ ZPRACOV¡NÕ ...'), 85 )
  oStatic:create()

  Center_sys_Moment(oDlg) 
return oDlg


STATIC FUNCTION Center_sys_Moment( oXbp )
  LOCAL aSizeParent, aSize, aPos

  aSizeParent := oXbp:SetParent():CurrentSize()
  aSize := oXbp:CurrentSize()
  aPos := Array(2)
  aPos[1] := ( aSizeParent[1] - aSize[1] ) / 2
  aPos[2] := ( aSizeParent[2] - aSize[2] ) / 2
  oXbp:SetPos ( aPos )
RETURN aPos
//


// vr·tÌ ˙daje o vlastnÌ firmÏ
function myFirmaAtr(atribut)
  local xret

  drgDBMS:open('firmy',,,,,'firmyx')

  if firmyx->( dbseek( MyFIRMA,,'FIRMY1'))
    xret := firmyx->&atribut
  else
    xret := ''
  endif


return(xRet)


// doplnÌ ˙daje v bloku pohyb˘ (subpohyb)
function dopln_poh( atr, val)
   local ret

   if .not. Empty(c_typpoh->csubpohyb)
     drgDBMS:open('c_typpoh',,,,,'c_typpohq' )
     if c_typpohq->( dbSeek( c_typpoh->csubpohyb,,'C_TYPPOH06'))
       atr := AllTrim(atr)
       ret := c_typpohq->&atr
     endif
   else
     ret := val
   endif

return( ret )


// doplnÌ ˙daje v bloku pohyb˘ (subpohyb)
function genKalendar( nrok, reGen)
  local  i, n, poc
  local  first, last
  local  crok
  local  tydmes, tydmespo
  local  tydprmes, tydprmespo
  local  aden   := {'NedÏle','PondÏlÌ','⁄ter˝','St¯eda','»tvrtek','P·tek','Sobota' }
  local  adenPo := {7,1,2,3,4,5,6 }
  local  ames := {'Leden','⁄nor','B¯ezen','Duben','KvÏten','»erven'         ;
                   ,'»ervenec','Srpen','Z·¯Ì','ÿÌjen','Listopad','Prosinec' }

  default nrok  to Year( Date())
  default regen to .f.

  crok :=  Right( Str( nrok), 2)

  drgDBMS:open('kalendar',,,,,'kalendarg')
  drgDBMS:open('c_svatky',,,,,'c_svatkyg')
  drgDBMS:open('c_svatjm',,,,,'c_svatjmg')

//  crok := Str( Year( date()))


  if .not. c_svatkyg->( dbSeek( nrok,,'c_svatky04'))
    drgMsgBox(drgNLS:msg( 'Nelze generovat kalend·¯! Nejsou zad·ny sv·tky pro rok ' + StrZero(nrok,4) +'.' ))
    reGen := .f.
  endif


  if reGen
    cFiltr := Format("nROK = %%", { nrok})
    Kalendarg->( ads_setAof( cFiltr), dbgoTop())
    do while  .not. Kalendarg->( Eof())
       if Kalendarg->( dbRlock())
         Kalendarg->( dbDelete())
         Kalendarg->( dbUnLock())
       endif
       Kalendarg->(dbSkip())
     enddo
    Kalendarg->( ads_ClearAof())
  endif

  if .not. Kalendarg->( dbSeek( nrok,,'KALENDAR04'))
    poc  := 0
    for i := 1 to 12
      first  := CTOD( '01.'+ StrZero( i,2) +'.' +crok)
      last   := mh_LastDayOM(first)
      tydmes   := tydprmes   := 1
      tydmespo := tydprmespo := 1

      for n := 1 to last
        poc++
        Kalendarg->( dbAppend())
        Kalendarg->dDatum     := CTOD( StrZero( n,2)+'.'+ StrZero( i,2)+'.' +crok)
        Kalendarg->nDen       := Day(Kalendarg->dDatum)
        Kalendarg->nTyden     := Week( Kalendarg->dDatum, .f.)    //mh_WeekOfYear( Kalendarg->dDatum)    //
        Kalendarg->nMesic     := Month(Kalendarg->dDatum)
        Kalendarg->nObdobi    := Kalendarg->nMesic
        Kalendarg->nRok       := Year(Kalendarg->dDatum)
        Kalendarg->nRokObd    := Kalendarg->nRok*100 +Kalendarg->nObdobi
        Kalendarg->nPololeti  := if( Kalendarg->nMesic > 6, 2, 1)
        Kalendarg->nCtvrtleti := mh_CTVRTzOBDn(Kalendarg->nMesic)
        Kalendarg->cNazDne    := aden[DoW(Kalendarg->dDatum)]
        Kalendarg->cNazMes    := ames[Kalendarg->nMesic]
        Kalendarg->cZkrNazDne := Left(Kalendarg->cNazDne,2)
        Kalendarg->nDenvRoce  := poc
        Kalendarg->nDenvTydnu := DoW(Kalendarg->dDatum)
        Kalendarg->nDenvTydPo := adenPo[Kalendarg->nDenvTydnu]
        Kalendarg->cObdobi    := StrZero(Kalendarg->nMesic,2) +'/' + Right( Str(Kalendarg->nRok),2)
        kalendarg->nDenKalend := 1

        if Kalendarg->cZkrNazDne = 'So' .or. Kalendarg->cZkrNazDne = 'Ne'
          kalendarg->cTypDne := 'SN'
        else
          kalendarg->cTypDne    := 'PR'
          kalendarg->nDenPracov := 1
        endif

        if c_svatkyg->( dbSeek( dtos(Kalendarg->dDatum) ,,'c_svatky01'))
          kalendarg->cTypDne  := if(c_svatkyg->lsvatek, 'SV', 'VO')
          kalendarg->nDenSvatek := 1
        endif

        if c_svatjmg->( dbSeek( StrZero(Kalendarg->nMesic,2)+StrZero(Kalendarg->nDen,2),,'c_svatjm01'))
          Kalendarg->csvatjmeno  := c_svatjmg->csvatjmeno
        endif

        if( n = 1 .and. Kalendarg->nDenvTydnu = 1, tydmes := 0, nil)
        if Kalendarg->nDenvTydnu = 1
          tydmes++
          tydprmes++
        endif

        if( n = 1 .and. Kalendarg->nDenvTydPo = 1, tydmespo := 0, nil)
        if Kalendarg->nDenvTydPo = 1
          tydmespo++
          tydprmespo++
        endif

        Kalendarg->nTydVMes   := tydmes
        Kalendarg->nTydVMespo := tydmespo

        if n <= 2 .and. Kalendarg->nDenvTydnu >= 6
          if( tydprmes > 0, tydprmes--, nil)
        endif

        if n <= 2 .and. Kalendarg->nDenvTydPo >= 6
          if( tydprmespo > 0, tydprmespo--, nil)
        endif

        Kalendarg->nTyPVMes   := tydprmes
        Kalendarg->nTyPVMesPO := tydprmespo

      next
    next
  endif

  kalendarg->(dbCloseArea())
  c_svatkyg->(dbCloseArea())
  c_svatjmg->(dbCloseArea())


return(nil)


// vr·tÌ poËet pracovnÌch dnÌ v roce vËetnÏ sv·tk˘
function Kal_PDr( rok )
  local dny := 0
  local filtr

  drgDBMS:open('kalendar',,,,,'kalendarx')

  filtr := Format("nrok == %% and ndenpracov == %%", { rok, 1})
  kalendarx->(ads_setaof(filtr),dbGoTop())

  kalendarx->( dbEval( {|x| dny++ }))

  kalendarx->( ADS_ClearAof())
  kalendarx->( dbCloseArea())

return dny


// vr·tÌ poËet pracovnÌch dnÌ v roce bez sv·tk˘
function Kal_PDbSVr( rok )
  local dny := 0
  local filtr

  drgDBMS:open('kalendar',,,,,'kalendarx')

  filtr := Format("nrok == %% and ndenpracov == %% and ndensvatek == %%", { rok, 1, 0})
  kalendarx->(ads_setaof(filtr),dbGoTop())

  kalendarx->( dbEval( {|x| dny++ }))

  kalendarx->( ADS_ClearAof())
  kalendarx->( dbCloseArea())

return dny


// vr·tÌ poËet sv·tk˘ v pracovnÌ den v roce
function Kal_SVPDr( rok )
  local dny := 0
  local filtr

  drgDBMS:open('kalendar',,,,,'kalendarx')

  filtr := Format("nrok == %% and ndensvatek == %% and ndenpracov == %%", { rok,1,1})

  kalendarx->(ads_setaof(filtr),dbGoTop())
   kalendarx->( dbEval( {|x| dny++ }))
  kalendarx->( ADS_ClearAof())
  kalendarx->( dbCloseArea())

return dny


// vr·tÌ poËet kalend·¯nÌch dnÌ v roce
function Kal_DnyKD( rok, obd )
  local dny := 0
  local filtr

  default rok to 0
  default obd to 0

  drgDBMS:open('kalendar',,,,,'kalendarx')

  if rok > 0 .and. obd > 0
    filtr := Format("nrok = %% and nobdobi = %%", { rok, obd })
  else
    filtr := Format("nrok = %%", { rok })
  endif

  kalendarx->(ads_setaof(filtr),dbGoTop())
   kalendarx->( dbEval( {|x| dny++ }))
  kalendarx->( ADS_ClearAof())
  kalendarx->( dbCloseArea())

return dny


// vr·tÌ poËet sv·tk˘ v roce
function Kal_DnySV( rok, obd )
  local dny := 0
  local filtr

  default rok to 0
  default obd to 0

  drgDBMS:open('kalendar',,,,,'kalendarx')

  if rok > 0 .and. obd > 0
    filtr := Format("nrok = %% and nobdobi = %% and ndensvatek = 1", { rok, obd })
  else
    filtr := Format("nrok = %% and ndensvatek = 1", { rok })
  endif

  kalendarx->(ads_setaof(filtr),dbGoTop())
   kalendarx->( dbEval( {|x| dny++ }))
  kalendarx->( ADS_ClearAof())
  kalendarx->( dbCloseArea())

return dny


// vr·tÌ poËet sv·tk˘ v pracovnÌ dny v roce
function Kal_DnySVPD( rok, obd )
  local dny := 0
  local filtr

  default rok to 0
  default obd to 0

  drgDBMS:open('kalendar',,,,,'kalendarx')

  if rok > 0 .and. obd > 0
    filtr := Format("nrok = %% and nobdobi = %% and ndensvatek = 1 and ndenpracov = 1", { rok, obd })
  else
    filtr := Format("nrok = %% and ndensvatek = 1 and ndenpracov = 1", { rok })
  endif

  kalendarx->(ads_setaof(filtr),dbGoTop())
   kalendarx->( dbEval( {|x| dny++ }))
  kalendarx->( ADS_ClearAof())
  kalendarx->( dbCloseArea())

return dny



// vr·tÌ poËet pracovnÌch dn˘ v obdobÌ a roce
function Kal_DnyFPD( rok, obd )
  local dny := 0
  local filtr

  default rok to 0
  default obd to 0

  drgDBMS:open('kalendar',,,,,'kalendarx')

  if rok > 0 .and. obd > 0
    filtr := Format("nrok = %% and nobdobi = %% and ndenpracov = 1", { rok, obd })
  else
    filtr := Format("nrok = %% and ndenpracov = 1", { rok })
  endif

  kalendarx->(ads_setaof(filtr),dbGoTop())
   kalendarx->( dbEval( {|x| dny++ }))
  kalendarx->( ADS_ClearAof())
  kalendarx->( dbCloseArea())

return dny

// vr·tÌ prvnÌ pracovnÌ den v mÏsÌci nebo v roce
function Kal_FirstPD( rok, obd )
  local datumPD
  local filtr

  default rok to 0
  default obd to 0

  drgDBMS:open('kalendar',,,,,'kalendarq')

  if rok > 0 .and. obd > 0
    filtr := Format("nrok = %% and nobdobi = %% and ndenpracov = 1", { rok, obd })
  else
    filtr := Format("nrok = %% and ndenpracov = 1", { rok })
  endif

//  kalendarq->(ads_setaof(filtr), OrdSetFocus('KALENDAR01'), dbGoTop())
  kalendarq->(ads_setaof(filtr))
  kalendarq->(ADSSetOrder('KALENDAR01'))
  kalendarq->( dbGoTop())
  datumPD := kalendarq->ddatum
  kalendarq->( ADS_ClearAof())
  kalendarq->( dbCloseArea())

return datumPD

// text d· do ˙vozovek
FUNCTION fVAR( xVAR)
RETURN( Chr(34)+ xVAR +Chr(34))


// zapÌöe text do souboru - na konec
function FileTXT( cfile, cvar)      //  n·zev souboru vËetnÏ cesty, text
  local nhandle

  default cvar to 'temp.txt'

  if .not. Empty(cfile)
    nhandle := if( File(cfile), FOpen(cfile,2), FCreate(cfile))

    FSeek(  nhandle,0,2)
    FWrite( nhandle, cvar +Chr(10))
    FClose( nhandle)
  endif

return( nil)


FUNCTION MakeSqlTableName(cTable)
  local c, i
  local cNotAllowed := "\/()"

   i := Rat("\", cTable)
   IF i > 0
        cTable := Substr(cTable, i+1)
   ENDIF
   i := Rat("/", cTable)
   IF i > 0
        cTable := Substr(cTable, i+1)
   ENDIF
   i := Rat(".", cTable)
   IF i > 0
        cTable := Substr(cTable,1, i-1)
   ENDIF

   c := ""
   FOR i:=1 TO len(cTable)
        IF !cTable[i] $ cNotAllowed
            c += cTable[i]
        ENDIF
   NEXT
RETURN c


FUNCTION MakeSqlStruct(aStruct, oSession)
  LOCAL a := AClone(aStruct)
  local i

   AEVAL(a, {|e,i| a[i][1] := MakeSqlFieldName(a[i][1], oSession) })
   AEVAL(a, {|e,i| a[i] := MakeSqlFieldType(a[i], oSession) })

RETURN a


/*
 * Check if field name violates SQL syntax by using a keyword
 * This will be corrected by adding and underscore automatically.
 */
FUNCTION MakeSqlFieldName(cFieldName, oSession)
LOCAL c

   c := cFieldName
   IF aKeyWords = NIL
      aKeyWords := OdbcListSqlKeywords(oSession)
   ENDIF

   IF ASCAN(aKeyWords, cFieldName) > 0
      c += "_"
      ? "Field " + cFieldname + " changed to: " + c
   ENDIF
RETURN c


/*
 * check if source type is supported on target
 */
FUNCTION MakeSqlFieldType(aFldRec, oSession)
STATIC aAltTypes := { { "C", "MWX" },;
                      { "N", "FI"  },;
                      { "L", "NIF" },;
                      { "D", "C"   } }
LOCAL cTgTypes := oSession:setProperty(ODBCSSN_DATATYPES)
LOCAL aRec := AClone(aFldRec)
LOCAL nPos, i

   IF ! aFldRec[2] $ cTgTypes
      /*
       * search for alternative types
       */
      nPos := AScan(aAltTypes, {|e| e[1] == aFldRec[2]})
      IF nPos > 0
         /*
          * find a supported type
          */
         FOR i:= 1 TO len(aAltTypes[nPos][2])
             IF aAltTypes[nPos][2][i] $ cTgTypes
                aRec[2] := aAltTypes[nPos][2][i]
             ENDIF
         NEXT
      ENDIF
   ENDIF

* set memo field to 0 otherwise ODBCDBE assumes this is a var char
   IF (aFldRec[2] == "M") .OR. (aFldRec[2] == "V")
     aRec[3] = 0
   ENDIF

   IF (aFldRec[2] == "S")
     aRec[2] = "I"
     aRec[3] =  10
   ENDIF

   IF (aFldRec[2] == "I")
     aRec[3] =  10
   ENDIF


RETURN aRec