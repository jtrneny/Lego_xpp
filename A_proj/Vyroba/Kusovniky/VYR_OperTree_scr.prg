/*==============================================================================
  VYR_OperTREE_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "xbp.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_OperTREE_scr FROM drgUsrClass, VYR_OperTREE_gen
EXPORTED:
  VAR     nRec

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  TreeItemMarked, TreeItemSelected

HIDDEN:
  VAR     dc
  VAR     tabNUM, lNewREC

  METHOD  FilesSYNC
ENDCLASS

*
********************************************************************************
METHOD VYR_OperTREE_scr:init(parent)

*  ::parent := parent
  ::drgUsrClass:init(parent)
  ::VYR_OperTREE_gen:init(parent)
*  ::dialogTitle := 'Kusovníkový rozpad'

  drgDBMS:open('POLOPER' )
  drgDBMS:open('OPERACE' )
  POLOPER->( DbSetRelation( 'OPERACE', { || Upper(POLOPER->cOznOper) },;
                                           'Upper(POLOPER->cOznOper)' ))
  ::nREC := KusTREE->( RecNO())
  ::tabNUM    := 1
  ::lNewRec   := .F.
*  ::nROZPAD := 2

RETURN self

*
********************************************************************************
METHOD VYR_OperTREE_scr:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members
  LOCAL aInfo := { 'cCisZakaz', 'VYRZAK->cNazevZAK1'}

  AEVAL( aInfo,;
   {|c| drgDialog:dataManager:has( IF( drgParse( c,'-') = c, 'VYRPOL->'+ c, c) ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {221, 221, 221} )) })
  *
  ::dc := ::drgDialog:dialogCtrl
*  SEPARATORs( members)

  OperTree->( dbGoTOP())
  SetAppFocus( ::oTree)
  ::oTree:SetData( ::oTreeItem)
*  ::tabSelect( , ::tabNUM)
RETURN self

*
********************************************************************************
METHOD VYR_OperTREE_scr:EventHandled(nEvent, mp1, mp2, oXbp)
*  LOCAL o, xRec

  DO CASE

  CASE nEvent = xbeTV_ItemMarked
    ::TreeItemMarked( mp1, mp2, oXbp)

  CASE nEvent = xbeTV_ItemSelected
    ::lNewRec := .F.
    ::TreeItemSelected( mp1, mp2, oXbp)

  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = drgEVENT_DELETE
**     VYR_POLOPER_del()
     ::dc:oaBrowse:oXbp:refreshAll()

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_INS
      ::lNewRec := .T.
      ::TreeItemSelected( oXbp:getData(),, oXbp)
      * posunout o stranku dolu
      PostAppEvent( xbeSB_Scroll, XBPSB_PREVPAGE,,oXbp)

    CASE mp1 = xbeK_DEL
**      ::FilesSYNC()
**      VYR_KUSOV_del( self)

    CASE mp1 = xbeK_SPACE

    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_OperTREE_scr:TreeItemMarked( oItem, aRect, oXbp)

  * Synchronizace s KusTREE
*  xRec :=  KusTree->( RecNO())
  OperTree->( dbGoTO( oItem:undoBuffer))
  ::oTreeItem := oItem

  ::dataManager:refresh()

RETURN SELF

*
********************************************************************************
METHOD VYR_OperTREE_scr:TreeItemSelected( oItem, aRect, oXbp)
*  ::VYR_KUSOV_CRD()
  SetAppFocus( oXbp)
  oXbp:setData( ::oTreeItem)
RETURN SELF


* Synchronizace souborù s TreeView
********************************************************************************
METHOD VYR_OperTREE_scr:FilesSYNC()
  LOCAL cKey, lOK

  cKey := Upper( KusTree->cSklPol)
  lOK := CenZboz->( dbSeek( cKey))
  lOK := NakPol->( dbSeek( cKey))
  /*
  cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol) +;
          StrZero( KusTree->nVarPoz, 3)
  lOK := VyrPol->( dbSeek( cKey))
  */
  cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
          StrZero( KusTree->nPozice, 3) + StrZero( KusTree->nVarPoz, 3)
  lOK := Kusov->( dbSeek( cKey))
RETURN self


*
********************************************************************************
METHOD VYR_OperTREE_scr:destroy()
  ::drgUsrClass:destroy()
   ::dc      := ;
   Nil

  vyrPol->( dbclearRelation())    
  OperTREE->( dbCloseArea())
RETURN self

/*
*===============================================================================
FUNCTION VYR_ScopeOPER( lSET)
  Local  nArea := Select(), nRec, nPos, anRec := {}
  Local  cKeyOld, cKeyNew, cScope
  Static nFltRYO
/*
  DEFAULT lRefresh To YES, lZapus To NO, lCLEAR TO NO
  //Ä Pro potýeby OperTree
  Default nRozpad  To ROZPAD_NENI, lOperace To YES
*

  DEFAULT lSET To .T.
  IF !lSET
*    PolOPER->( dbClearScope(), dbClearFilter(), dbGoTOP())
    PolOPER->( dbClearScope(), Ads_ClearAOF(), dbGoTOP())
    RETURN NIL
  ENDIF

  nVarRoot := GetVarPos()        // VyrPol->nVarCis
*   PolOPER->( dbClearScope(), dbClearFilter(), dbGoTOP())
   PolOPER->( dbClearScope(), Ads_ClearAOF(), dbGoTOP())

   cScope := If( KusTree->lNakPol, KusTree->cVysPol, KusTree->cVyrPol )
   cScope := Upper( KusTree->cCisZakaz) + Upper( cScope)
   PolOPER->( dbSetScope(SCOPE_BOTH, cScope ), dbGoTOP() )
   IF KusTree->lNakPol
      * napozicuje Kusov
      cKeyNew := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
                 StrZero( KusTree->nPozice, 3) + StrZero( KusTree->nVarPoz, )
      Kusov->( dbSEEK( cKeyNew))
      *
      cKeyNew := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
                 StrZero( Kusov->nCisOper, 4) + StrZero( Kusov->nUkonOper, 2) + StrZero( nVarRoot, 3)
      PolOPER->( dbSetScope(SCOPE_BOTH, cKeyNew ) )

      IF  PolOper->( dbSEEK( cKeyNew + StrZero( nVarRoot, 3) ))
      ELSEIF  PolOper->( dbSEEK( cKeyNew + '001' ))
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
            IF PolOper->( dbSEEK( cKeyNew + StrZero( nVarRoot, 3)))
               nPos := aSCAN( anRec, PolOper->( RecNO()) )
               IF( nPos == 0, aAdd( anRec, PolOper->( RecNo()) ), Nil )
            ELSE
               IF PolOper->( dbSEEK( cKeyNew + '001'))
                  aADD( anRec, PolOper->( RecNO()) )
               ENDIF
            ENDIF
        ENDIF
        PolOper->( dbGoTO( nRec))
        cKeyOld := cKeyNew
        PolOper->( dbSKIP())
      ENDDO

   ENDIF
   SetRyoFILTER( anRec, 'POLOPER' )
   dbSelectAREA( nArea)
RETURN NIL

*
*===============================================================================
FUNCTION VYR_KusCAS()
  LOCAL nKusCAS := 0
  If PolOper->nCelkKusCa > 0
     nKusCas := PolOper->nCelkKusCa // * KusTree->nSpMnoNas
  Else
*     nKusCas := Operace->nKusovCas * PolOper->nKoefKusCa *  ;  // KusTree->nSpMnoNas * ;
*                Operace->nKoefSmCas * Operace->nKoefViOb / Operace->nKoefViSt
  EndIf
*  nKusCas := MjCAS( nKusCas, to_CFG )
RETURN nKusCAS

*
*===============================================================================
FUNCTION VYR_PriprCAS()
  Local nPriprCas := 0

  If PolOper->nPriprCas > 0
     nPriprCas := PolOper->nPriprCas // * KusTree->nSpMnoNas
  EndIf
*  nPriprCas := MjCAS( nPriprCas, to_CFG )
Return nPriprCas
*/