#include "Common.ch"
#include "Xbp.ch"
#include "Drg.ch"
#INCLUDE 'DRGRES.ch'
#INCLUDE 'DBSTRUCT.ch'
#include "AppEvent.ch"
#include "Directry.ch"

static  o_icobd

** pracovn� adres�� u�ivatele
function userWorkDir()
  local processID := if(isWorkVersion, '', allTrim(str(GetCurrentProcessId())))
  local cthreadID := allTrim(str(ThreadID()))

return 'dir_' +processID +cthreadID


* Kontrola na vypln�n� �daje :  tvrd� kontrola = �daj povinn�   lDUE = .T.
*                               m�kk� kontrola = �daj nepovinn� lDUE = .F.
*===============================================================================
FUNCTION ControlDUE( oVar, lDUE)
  LOCAL  xVar := oVar:get(), lOK := .T., cMsg

  DEFAULT lDUE TO .T.
  IF EMPTY( xVar)
    cMsg := IF( lDUE, ': ... �daj mus� b�t vypln�n !',;
                      ': ... POZOR, �daj nebyl vypln�n !' )
    drgMsgBox(drgNLS:msg( oVar:ref:caption + cMsg),, oVar:drgDialog:dialog)
    lOK := !lDUE
  ENDIF
RETURN lOK


*****************************************************************
* Funkce nastavuj�c� polo�ku na (ne)editovatelnou.
* Parametry:
*   xField ... n�zev polo�ky nebo pole n�zv� polo�ek
*   oDialog... formul��
*   IsEdit ... .F. = needitovateln�, .T. = editovateln�
*****************************************************************
FUNCTION IsEditGET( xField, oDialog, IsEdit )
  Local nPos, n, drgVar, xHelp
  Local aValues := oDialog:dataManager:vars:values
  Local NoEdit := GraMakeRGBColor( {221,221,221})
*  Local clrFocus := If( IsEdit, GraMakeRGBColor( {221,221,221} ), XBPSYSCLR_WINDOW )

  IF IsCharacter( xField) // nastaven� u jedn� polo�ky
    xHelp  := xField
    xField := {}
    AADD( xField, xHelp)
  ENDIF

  IF IsArray( xField)    // nastaven� u v�ce polo�ek definovan�ch v poli
    FOR n := 1 TO LEN( xField)
      nPos := aSCAN( aValues, xField[ n])
      IF nPOS <> 0
        drgVar := aValues[ nPos, 2]
        drgVar:oDrg:IsEdit := IsEdit
*        drgVar:oDrg:clrFocus := clrFocus
        drgVar:oDrg:oXbp:setColorBG(IF( IsEdit, XBPSYSCLR_WINDOW, NoEdit))
        IF drgVar:oDrg:ClassName() = 'drgGet'
          IF IsObject(drgVar:oDrg:pushGet) .and. drgVar:oDrg:pushGet:ClassName() = 'drgPushButton'
*            drgVar:oDrg:pushGet:disabled := !IsEdit

           if( IsEdit, drgVar:oDrg:pushGet:oxbp:show(), drgVar:oDrg:pushGet:oxbp:hide())

          ENDIF
        ENDIF
      ENDIF
    NEXT
  ENDIF
RETURN Nil

*****************************************************************
* Funkce realizuje validaci mechanismem v�b�ru z ��seln�ku.
* Parametry:
* oDialog - dialog z n�ho� je funkce vol�na
* xField  - typ character => validace dan� polo�ky p�es button ...
*           typ array => validace p�es kl�vesu F4
* cOrder  - nastaven� t��d�n�, implicitn� tag 1
*****************************************************************
FUNCTION Vld_CISEL( oDialog, xField )
  Local nPosField := 1, nPosValues, drgVar
  Local aValues := oDialog:dataManager:vars:values
  Local cField := oDialog:oForm:oLastDrg:Name
  Local cSearchFile, cSearchVal, cType, cOrder
  Local cRetVal, cRetValHlp

  If LEN( xField) = 1                                  // validace p�es ...
    cField := xField[ 1, 1]
  Else                                                 // validace p�es F4
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
* Dohled�n� sazby DPH ... dle k�du DPH
* Parametry:
* nKod  - k�d sazby DPH
*****************************************************************
FUNCTION SeekKodDPH( nKod)
  Local nSazba, cTag

  IF( Used('C_DPH'), NIL, drgDBMS:open('C_DPH'  ))
  cTAG := C_DPH->( AdsSetOrder( 1))
  nSazba := If( C_DPH->( dbSeek( nKod)), C_DPH->nProcDph, 0)
  C_DPH ->( AdsSetOrder( cTAG))
RETURN( nSazba)

*****************************************************************
* Dohled�n� sazby DPH ... dle typu a data platnosti
* Parametry:
* nNapocet - typ n�po�tu ( 1 - sn�en� sazba, 2 - z�kladn� sazba
* dDatum   - datum, od kter�ho sazba plat�
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
* Pln�n� syst�mov�ch �daju o manipulaci se z�znamem
*****************************************************************
FUNCTION SysFLD( cFile, lNewRec)

  mh_WRTzmena( cFile, lNewRec)

RETURN Nil

*****************************************************************
* �et�zec s odd�lova�i p�evede na pole
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
* P�epnut� indexu
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

      * mus�me d�t pozor na zru�en� z�znamy,
      * pokud n�hodou stoj�me na zru�en�m z�znamu, do�lo by k p�du

      if( (cA) ->(deleted()), (cA)->(dbGoTop()), nil )

      aadd( axOrdRec, { cA, ( cA) ->( OrdSetFocus()), ( cA) ->(recNo()) } )
      ( cA) ->( AdsSetOrder( nO))
    next
  endif
RETURN Nil


*****************************************************************
* P�id�n� z�znamu
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
* Zru�en� z�znamu
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
* Uzam�en� z�znamu pro opravu
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
p�esunuto do mh_.prg
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

  // zavedena konvence u TMP polo�ka _nrecor pro z�mky p�i ukl�d�n� //
  IF IsMain .and. (nPOs := (cDBTo) ->(FieldPos('_nrecor'))) <> 0
    (cDBTo) ->(FieldPut(nPOs, (cDBFrom) ->(RecNo())))
    IF(IsARRAY(aLock), AAdd(aLock,(cDBFrom) ->(RecNo())),NIL)
  ENDIF
Return( Nil)


//-------VYPR�ZDN�N� Z�ZNAMU-----------------------------------
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
  iconBar := drgActions():new(oParent)
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
  local  state
  local  o_obd   := atail( drgDialog:oIconBar:members )

  DRGDIALOG FORM 'UCT_ucetsys,' +task  PARENT drgDialog MODAL DESTROY EXITSTATE nExit

  if nexit <> drgEVENT_QUIT
    obd   := uctOBDOBI:&task:nobdobi
    rok   := uctOBDOBI:&task:nrok
    state := if(uctOBDOBI:&task:lzavren,MIS_ICON_QUIT,DRG_ICON_EDIT)

    o_obd:oicon:setcaption(state)
    o_obd:otext:setcaption('  ' +task +' ' +str(obd,2) +'/' +str(rok,4))
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
  ms := drgNLS:msg('~Dialog,~Save,Save/E~xit,Print,~N�pov�da,Index,N�pov�da,O aplikaci')


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

*****************************************************************
* Funkce realizuje nab�dku pro v�b�r soubor�
* Parametry:
* aFilters - pole filtru pro v�b�r soubor� nap�. {{"DBF Files","*.DBF"},{"ADT Files","*.ADT"}}
*            hodnota m��e b�t i EMPTY
* cDirectory - je mo�n� zadat default adres�� ...
* cExtension - je mo�n� zadat p��ponu souboru ketr� se maj� zadat jinak *.*
* lMultiple  -
* N�vratov� hodnota:
* aFiles - pole vybran�ch soubor� v�etn� cesty a extense
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
* Funkce realizuje nab�dku pro v�b�r soubor�
* Parametry:
* aFilters - pole filtru pro v�b�r soubor� nap�. {{"DBF Files","*.DBF"},{"ADT Files","*.ADT"}}
*            hodnota m��e b�t i EMPTY
* cDirectory - je mo�n� zadat default adres�� ...
* cExtension - je mo�n� zadat p��ponu souboru ketr� se maj� zadat jinak *.*
* lMultiple  -
* N�vratov� hodnota:
* aFiles - pole vybran�ch soubor� v�etn� cesty a extense
****************************************************************

FUNCTION selFILE(cFile,cExtense,cDirectory,cNazev,aFilters,lRestDir,lnoAcces,lcenter)
  Local oDlg:=Nil, oFocus:=SetAppFocus()

  Default aFilters To {}
  Default cNazev To "V�b�r souboru"
  Default cDirectory To ""
  Default cExtense To ""
  Default lRestDir to .f.
  Default lnoAcces to .f.
  Default lcenter  to .t.

  Begin Sequence
     oDlg:=XbpFileDialog():new()
     oDlg:fileFilters   := aFilters
     oDlg:center        := lcenter
     oDlg:noWriteAccess := lnoAcces
     oDlg:restoreDir    := lRestDir
     oDlg:defExtension  := cExtense
     oDlg:title         := cNazev
     oDlg:create()
     aFiles             :=oDlg:open(cDirectory + cFile+'.'+cExtense)
     oDlg:destroy()
     SetAppFocus(oFocus)
  End

RETURN(aFILES)