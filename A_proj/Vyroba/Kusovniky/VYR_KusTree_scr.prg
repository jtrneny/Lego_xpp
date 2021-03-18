/*==============================================================================
  VYR_KusTREE_scr.PRG
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
CLASS VYR_KusTREE_scr FROM drgUsrClass, VYR_KusTREE_gen
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

  * Bro - polOper
  inline access assign method polOper_porCisLis() var polOper_porCisLis
    return if( polOper->nporCisLis = 0, 0, 552 )  // M_big_new  -  má vygenerovaný mlistHd ?

HIDDEN:
  VAR     dc, dm, msg
  VAR     tabNUM, lNewREC, nSumCena, aRec
  VAR     lSaveKusovCrd        // byla uložena karta kus.vazby

  METHOD  FilesSYNC, sumColumn
ENDCLASS

********************************************************************************
METHOD VYR_KusTREE_scr:init(parent)
  Local nShow_Tree := Tree_FULL, cParam
  Local nPrm := SysConfig( 'Vyroba:nKusTreFrm')

  nPrm := If( IsArray(nPrm), 1, nPrm )
  parent:formName := If( nPrm = 1, 'VYR_KusTREE_scr', 'VYR_KusTREE2_scr')
  *
*  ::parent := parent
  ::drgUsrClass:init(parent)
  *
  cParam := drgParseSecond( parent:initParam, ',' )
  nShow_Tree := IF( EMPTY( cParam), nShow_Tree, VAL( cParam) )
  ::VYR_KusTREE_gen:init(parent, nShow_Tree)
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

RETURN self

********************************************************************************
METHOD VYR_KusTREE_scr:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x
  *
  ::dc := ::drgDialog:dialogCtrl
  ::dm := ::drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
  *
  ColorOfText( ::dc:members[1]:aMembers)
  SEPARATORs( members)
  *
  FOR x := 1 TO LEN( Members)
    IF members[x]:event $ 'VYR_VYRZAK_INFO'
      IF( EMPTY(VYRPOL->cCisZakaz), members[x]:oXbp:disable(), members[x]:oXbp:enable())

      members[x]:oXbp:setColorFG( If( EMPTY(VYRPOL->cCisZakaz), GraMakeRGBColor({128,128,128}),;
                                                                GraMakeRGBColor({0,0,0})))
    ENDIF
  NEXT
*  ::sumColumn()
  *
  KusTree->( dbGoTOP())
  SetAppFocus( ::oTree)
  ::oTree:SetData( ::oTreeItem)
  *
  ::tabSelect( , ::tabNUM)
  drgDialog:oForm:tabPageManager:showPage( ::tabNum, .T.)
  *
RETURN self

********************************************************************************
METHOD VYR_KusTREE_scr:EventHandled(nEvent, mp1, mp2, oXbp)
  Local anRec, nRec
  *

  DO CASE
  /*
  CASE nEvent = xbeTV_ItemExpanded
    ::lNewRec := .F.

  CASE nEvent = xbeTV_ItemCollapsed
    ::lNewRec := .F.
  */
  CASE nEvent =  xbeP_None
    ::lSaveKusovCrd  := .f.

  CASE nEvent = xbeTV_ItemMarked
    ::TreeItemMarked( mp1, mp2, oXbp)

  CASE nEvent = xbeTV_ItemSelected
    ::lNewRec := .F.
    ::TreeItemSelected( mp1, mp2, oXbp)
    ::TreeItemMarked( mp1, mp2, oXbp)

  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = drgEVENT_DELETE
      VYR_POLOPER_del()
     ::dc:oBrowse[1]:oXbp:refreshAll()

  CASE nEvent = drgEVENT_APPEND
    IF KusTree->lNakpol
       drgMsgBox(drgNLS:msg( 'OPERACE K POLOŽCE !;;' + ;
                             'Nelze vytvoøit operaci k materiálu !'))
       RETURN .T.
    ELSE
      RETURN .F.
    ENDIF

/*
  CASE nEvent = drgEVENT_FORMDRAWN
    IF ::tabNUM = tab_OPERACE
      anRec := VYR_ScopeOPER()
      ::sumColumn( anRec)
      ::dc:oBrowse[1]:oXbp:refreshAll()
    ENDIF
*/
  CASE nEvent = xbeP_SetDisplayFocus
    IF ::tabNUM = tab_OPERACE
      nRec := PolOper->( RecNO())
      ::aRec := VYR_ScopeOPER()
      PolOper->( dbGoTO( nRec))
      ::sumColumn()
      ::dc:oBrowse[1]:oXbp:refreshAll()
    ENDIF
    RETURN .F.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_INS
      IF KusTree->lNakpol
         drgMsgBox(drgNLS:msg( 'SKLADOVÁ POLOŽKA !;;' + ;
                               'Nelze vytvoøit vztah na položku nižší !'))
         RETURN .T.
      ENDIF
      ::lNewRec := .T.
      ::TreeItemSelected( oXbp:getData(),, oXbp)
      * posunout o stranku dolu
      PostAppEvent( xbeSB_Scroll, XBPSB_PREVPAGE,,oXbp)

    CASE mp1 = xbeK_DEL // .or. mp1 = xbeK_CTRL_DEL
      ::FilesSYNC()
      VYR_KUSOV_del( self)
      ::FilesSYNC()          //25.3.11
      *
    CASE mp1 = 43 .or. mp1 = 45    //  +, -  for Expanded / Collapsed
      Return .F.

    CASE  ( mp1 > 31 .AND. mp1 < 255 ) .or. mp1 = xbeK_BS
       ::dlgSearch( mp1, self)
    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD VYR_KusTREE_scr:TreeItemMarked( oItem, aRect, oXbp)
  Local cKey
  LOCAL nEvent := mp1 := mp2 := nil
  *

  nEvent := LastAppEvent(@mp1,@mp2)

  * Synchronizace s KusTREE
  KusTree->( dbGoTO( oItem:undoBuffer))
  ::oTreeItem := oItem

  ::dataManager:refresh()
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
*      drgDump( 'TreeItemMarked - ' )
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
  ENDIF
  *

RETURN SELF

********************************************************************************
METHOD VYR_KusTREE_scr:TreeItemSelected( oItem, aRect, oXbp)
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

/*
********************************************************************************
METHOD VYR_KusTree_scr:OnSave(isBefore, isAppend)
*   VYR_POLOPER_save( self)
  drgMsgBox(drgNLS:msg( 'OnSave ...' ))
RETURN .T.
*/
*
********************************************************************************
METHOD VYR_KusTREE_scr:tabSelect( tabPage, tabNumber)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x, anRec
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')

  ::tabNUM := tabNumber
  IF ::tabNUM = tab_OPERACE
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    If isNull( ::aRec)
      ::aRec := VYR_ScopeOPER()
    EndIf
    ::sumColumn( anRec)
    ::dc:oBrowse[1]:oXbp:refreshAll()
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
*      members[x]:oXbp:visible := ( ::tabNUM = tab_OPERACE)
*      members[x]:oXbp:configure()
       members[x]:disabled := !( ::tabNUM = tab_OPERACE)

      members[x]:oXbp:setColorFG( If( members[x]:disabled , GraMakeRGBColor({128,128,128}),;
                                                            GraMakeRGBColor({0,0,0})))
    ENDIF
  NEXT

RETURN .T.

********************************************************************************
METHOD VYR_KusTREE_scr:PolOPER_Copy_one( drgDialog)
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
METHOD VYR_KusTREE_scr:PolOPER_Copy_more
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

********************************************************************************
METHOD VYR_KusTREE_scr:VYR_KUSOV_CRD( nKEY)
  LOCAL  oDialog, nExit
  local  oItems

  oDialog := drgDialog():new('VYR_KUSOV_CRD',self:drgDialog)
  oDialog:cargo :=  IF( ::lNewRec, drgEVENT_APPEND, drgEVENT_EDIT)
  oDialog:create(,self:drgDialog:dialog,.T.)

  IF oDialog:exitState != drgEVENT_QUIT
    ::lSaveKusovCrd := .t.              // indikace pøi uložení karty nastav ON
    ::TreeRebuild()
    PostAppEvent( xbeP_None,,, ::oTree) // Pošli informaci, že indikace se má nastavit na OFF
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
RETURN

********************************************************************************
METHOD VYR_KusTREE_scr:VYR_PostupTech
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
METHOD VYR_KusTREE_scr:VYR_KalkPLAN
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
METHOD VYR_KusTREE_scr:VYR_KalkSKUT
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

* Synchronizace souborù s TreeView
********************************************************************************
METHOD VYR_KusTREE_scr:FilesSYNC()
  LOCAL cKey, lOK

  cKey := Upper( KusTree->cSklPol)
  lOK  := CenZboz->( dbSeek( cKey))
  lOK  := NakPol->( dbSeek( cKey))
  cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
          StrZero( KusTree->nPozice, 3) + StrZero( KusTree->nVarPoz, 3)
  lOK := Kusov->( dbSeek( cKey))
RETURN self

********************************************************************************
METHOD VYR_KusTREE_scr:VYR_CenZboz_INFO()
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
METHOD VYR_KusTREE_scr:destroy()
  ::drgUsrClass:destroy()
  ::tabNum  := ;
  ::dc      := ;
  ::dm      := ;
  ::msg     := ;
  ::nSumCena := ;
   Nil

  vyrPol->( dbclearRelation())
  KusTREE->( dbCloseArea())
  PolOper->( mh_ClrFilter())
RETURN self

** HIDDEN **********************************************************************
METHOD VYR_KusTREE_scr:sumColumn( anRec)
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

*===============================================================================
FUNCTION Vyr_CenZBOZ_Exist( Dialog )
  LOCAL  oDialog, nExit
  Local  cKey, nCount := 0, lCenZboz, lNakPol

  drgDBMS:open('CENZBOZ',,,,,'CENZBOZa' )
  drgDBMS:open('CENZBOZw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  IF Dialog:FormName = 'VYR_ZAKZAPUS'
    GenTreeFILE( 0)
  ENDIF
  *
  KusTREE->( dbGoTOP())
  DO WHILE !KusTREE->( Eof())
    IF KusTree->lNakPol
      cKey := Upper( KusTree->cSklPol)
      IF ( lCenZboz := CENZBOZa->( dbSeek( cKey,, 'CENIK01')) )
        * ok
      ELSE
        lNakPOL := NakPOL->( dbSeek( cKey,, 'NAKPOL1'))
        * materiál neexistuje v ceníku
        mh_CopyFld( 'NakPOL', 'CENZBOZw', .t.)
        CENZBOZw->cNazZBO  := NakPOL->cNazTPV
        nCount++
      ENDIF
    ENDIF
    KusTree->( dbSkip())
  ENDDO
  *
  IF nCount = 0
  * OK
   drgMsgBox(drgNLS:msg('Kontrola probìhla OK;;Všechny použité materiály existují v ceníku zboží.'))
  ELSE
*    drgMsgBox(drgNLS:msg('V ceníku neexistuje [ & ] materiálù ...', nCount ))
    DRGDIALOG FORM 'VYR_CENZBOZ_NEEX' PARENT Dialog MODAL DESTROY
  ENDIF
  *
RETURN nil


*===============================================================================
FUNCTION VYR_ScopeOPER( lSET)
  Local  nArea := Select(), nRec, nPos, anRec := {}
  Local  cKeyOld, cKeyNew, cScope
  Local  nTypVar
  * 22.7.10
  nTypVar := SysConfig( 'Vyroba:nTypVar')
  nTypVar := If( IsArray( nTypVar), 1, nTypVar )

/*
  DEFAULT lRefresh To YES, lZapus To NO, lCLEAR TO NO
  //Ä Pro potýeby OperTree
  Default nRozpad  To ROZPAD_NENI, lOperace To YES
*/

  DEFAULT lSET To .T.
  IF !lSET
    PolOPER->( mh_ClrScope(), Ads_ClearAOF(), dbGoTOP())
    RETURN NIL
  ENDIF

**  nVarRoot := GetVarPos()       // VyrPol->nVarCis
  nvarRoot := kusTree->nvarCis

  * Musíme rozlišit variantu operace, a to podle VyrZakIT->nOrdItem
  IF USED( 'VyrZakIT')
    nVarRoot := IF( VyrZakIT->nOrdItem <> 0, VyrZakIT->nOrdItem, nVarRoot )
  ENDIF
  PolOPER->( mh_ClrScope(), Ads_ClearAOF(), dbGoTOP())

  cScope := KusTree->cCisZakaz + ;
            If( KusTree->lNakPol, KusTree->cVysPol, KusTree->cVyrPol )
  cScope := Upper( cScope)
  PolOPER->( mh_SetScope( cScope) )

  IF KusTree->lNakPol
     * napozicuje Kusov
     cKeyNew := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
                StrZero( KusTree->nPozice, 3) + StrZero( KusTree->nVarPoz, )
     Kusov->( dbSEEK( cKeyNew))
     *
     cKeyNew := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
                StrZero( Kusov->nCisOper, 4) + StrZero( Kusov->nUkonOper, 2)
     PolOPER->( mh_SetScope( cKeyNew ) )

     IF     PolOper->( dbSEEK( cKeyNew + StrZero( nVarRoot, 3),, 'POLOPER1' ))
     ELSEIF nTypVar = 1
       PolOper->( dbSEEK( cKeyNew + '001',,'POLOPER1' ))
     ENDIF
     aADD( anRec, PolOper->( RecNO()) )

  ELSE
     cKeyNew := cScope + StrZero( PolOper->nCisOper, 4) + ;
                StrZero( PolOper->nUkonOper, 2) + StrZero( nVarRoot, 3)
     cKeyOld := Space( 35)
     DO WHILE !PolOper->( EOF())
       nRec := PolOper->( RecNO())
       cKeyNew := cScope + StrZero( PolOper->nCisOper, 4) + ;
                  StrZero( PolOper->nUkonOper, 2)
       IF cKeyNew <> cKeyOld
         IF PolOper->( dbSEEK( cKeyNew + StrZero( nVarRoot, 3),,'POLOPER1'))
           nPos := aSCAN( anRec, PolOper->( RecNO()) )
           IF( nPos == 0, aAdd( anRec, PolOper->( RecNo()) ), Nil )
         ELSEIF nTypVar = 1
           IF PolOper->( dbSEEK( cKeyNew + '001',,'POLOPER1'))
             aADD( anRec, PolOper->( RecNO()) )
           ENDIF
         ENDIF
       ENDIF
       PolOper->( dbGoTO( nRec))
       cKeyOld := cKeyNew
       PolOper->( dbSKIP())
     ENDDO
  ENDIF

  polOper->( ads_setAof('.F.'))
  polOper->( ads_customizeAOF( anRec ), dbGoTop() )


///  mh_RyoFILTER( anRec, 'POLOPER' )
  dbSelectAREA( nArea)
RETURN( anREC)


//  Tag- POLOPER1 UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)
*===============================================================================
FUNCTION VYR_KusCAS()
  LOCAL nKusCAS := 0
  If PolOper->nCelkKusCa > 0
     nKusCas := PolOper->nCelkKusCa // * KusTree->nSpMnoNas
  Else
*     nKusCas := Operace->nKusovCas * PolOper->nKoefKusCa *  ;  // KusTree->nSpMnoNas * ;
*                Operace->nKoefSmCas * Operace->nKoefViOb / Operace->nKoefViSt
  EndIf
  nKusCas := MjCAS( nKusCas, to_CFG )
RETURN nKusCAS

*===============================================================================
FUNCTION VYR_PriprCAS()
  Local nPriprCas := 0

  If PolOper->nPriprCas > 0
     nPriprCas := PolOper->nPriprCas // * KusTree->nSpMnoNas
  EndIf
  nPriprCas := MjCAS( nPriprCas, to_CFG )
Return nPriprCas

*===============================================================================
FUNCTION VYR_PolOperW_TMP()
  Local  nFondMIN := 480  // Pracovní doba v minutách =  8 hod X 60 min =480 min

  drgDBMS:open('POLOPER_w1' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  PolOper->( dbGoTOP())
  DO WHILE !PolOper->( EOF())
    mh_CopyFld('PolOper', 'PolOper_W1', .T.)
    PolOper_W1->cStred     := Operace->cStred
    PolOper_W1->cOznPrac   := Operace->cOznPrac
    PolOper_W1->cTarifTrid := Operace->cTarifTrid
    PolOper_W1->nVykon_cmp := mh_RoundNumb( 480 / PolOper->nCelkKusCa, 32 )
    PolOper->( dbSkip())
  ENDDO
  PolOper_W1->( dbGoTOP())

RETURN NIL

********************************************************************************
*
********************************************************************************
CLASS VYR_CenZBOZ_INFO FROM drgUsrClass

EXPORTED:
  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled
  METHOD  getForm

HIDDEN:
  VAR  drgGet
ENDCLASS

********************************************************************************
METHOD VYR_CenZBOZ_INFO:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::drgUsrClass:init(parent)
RETURN self

********************************************************************************
METHOD VYR_CenZBOZ_INFO:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD VYR_CenZBOZ_INFO:drgDialogInit(drgDialog)
  LOCAL  aPos
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog
/*
  XbpDialog:titleBar := .F.
  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
*/
RETURN

********************************************************************************
METHOD VYR_CenZBOZ_INFO:drgDialogStart(drgDialog)
/*
  IF IsObject(::drgGet)
    IF( .not. C_ALGREZ ->(DbSeek(::drgGet:oVar:value,,1)), C_ALGREZ ->(DbGoTop()), NIL )
    drgDialog:dialogCtrl:browseRefresh()
  ENDIF
*/
RETURN self

********************************************************************************
METHOD VYR_CenZBOZ_INFO:getForm()
LOCAL oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 110, 6 DTYPE '10' TITLE 'Skladové položky' ;
                                            FILE 'CENZBOZ'                   ;
                                            GUILOOK 'All:N,Border:Y,ACTION:Y'

  DRGACTION INTO drgFC CAPTION 'info ~Ceník' EVENT 'SKL_CENZBOZ_INFO' TIPTEXT 'Informaèní karta ceníku zboží'

  DRGBROWSE INTO drgFC SIZE 110,5.8 ;
                       FIELDS 'cCisSklad, cSklPol, cNazZbo::20, nMnozSZBO, cZkratJEDN:MJ, nCenaPZBO, nCenaSZBO, nCenaVNI'  ;
                       SCROLL 'yy' CURSORMODE 3 PP 7
RETURN drgFC