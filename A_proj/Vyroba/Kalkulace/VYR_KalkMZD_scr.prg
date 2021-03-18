/*==============================================================================
  VYR_KalkMZD_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
  VYR_CenaCELKEM()     CenaCELKEM()       Kalkul.prg
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

STATIC   nVarRoot

********************************************************************************
*
********************************************************************************
CLASS VYR_KalkMZD_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init
  METHOD  Destroy

  * ACTION
*  METHOD  VYR_VYRPOL_DET        // Detail VYRPOL
  METHOD  VYR_KALK_MZD          // Kalkulace mezd

ENDCLASS

*
********************************************************************************
METHOD VYR_KalkMZD_SCR:Init(parent)
  ::drgUsrClass:init(parent)
RETURN self

*
********************************************************************************
METHOD VYR_KalkMZD_SCR:destroy()
  ::drgUsrClass:destroy()
RETURN self

/* ACTION - Detail VYRPOL
********************************************************************************
METHOD VYR_KalkMZD_SCR:VYR_VYRPOL_DET()
LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VYRPOL_CRD' PARENT ::drgDialog CARGO drgEVENT_EDIT  MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self
*/

* ACTION - Kalkulace mezd
********************************************************************************
METHOD VYR_KalkMZD_SCR:VYR_Kalk_MZD()
LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_Kalk_MZD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

RETURN self


********************************************************************************
*
********************************************************************************
CLASS VYR_Kalk_MZD FROM drgUsrClass
EXPORTED:
  VAR     cCisZakaz, cVyrPol, cNazev, nVarCis
  VAR     nCas, nKc

  METHOD  Init, drgDialogStart, TabSelect, Destroy
  * Action
  METHOD  Detail_1         // Detail VYRPOL
  METHOD  Detail_2         // Detail C_PRACOV
  METHOD  Detail_3         // Detail OPERACE

HIDDEN
  VAR  dm, dc, msg
ENDCLASS

*
********************************************************************************
METHOD VYR_Kalk_MZD:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('CenZBOZ'  )
  drgDBMS:open('Kusov'    )
  drgDBMS:open('NakPOL'   )
  drgDBMS:open('C_Pracov' )
  drgDBMS:open('PolOper'  )
  drgDBMS:open('Operace'  )

  drgDBMS:open('KALKMZD',.T.,.T.,drgINI:dir_USERfitm);  ZAP
    KalkMZD->( DbSetRelation( 'C_Pracov', {|| Upper(KalkMZD->cOznPrac) },'Upper(KalkMZD->cOznPrac)'))
    KalkMZD->( DbSetRelation( 'Operace' , {|| Upper(KalkMzd->cOznOper) },'Upper(KalkMzd->cOznOper)'))
  drgDBMS:open('KusTREE',.T.,.T.,drgINI:dir_USERfitm);  ZAP
*    KusTREE->( DbSetRelation( 'NakPOL', {|| KusTREE->cSklPol },'KusTREE->cSklPol'))
*    KusTREE->( DbSetRelation( 'VYRPOL', {|| KusTREE->cVyrPOL },'KusTREE->cVyrPOL'))

  ::nCas := ::nKc := 0
  ::cCisZakaz := VyrPOL->cCisZakaz
  ::cVyrPOL   := VyrPOL->cVyrPOL
  ::cNazev    := VyrPOL->cNazev
  ::nVarCis   := VyrPOL->nVarCis

RETURN self

*
********************************************************************************
METHOD VYR_Kalk_MZD:drgDialogStart(drgDialog)
LOCAL x, members  := drgDialog:oForm:aMembers

  ::dm  := drgDialog:dataManager
  ::dc  := drgDialog:dialogCtrl
  ::msg := drgDialog:oMessageBar
  *
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
*  SEPARATORs( members)
RETURN self

*
********************************************************************************
METHOD VYR_Kalk_MZD:tabSelect( tabPage, tabNumber)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x, lOk
  Local nPriprCas, nKusovCas, nPriprKc, nKusovKc
  Local cFILE := IF( tabNumber = 1, 'KusTREE', 'KalkMZD' )
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')

  ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
  *
  FOR x := 1 TO LEN( Members)
    IF 'DETAIL_' $ members[x]:event
      lOk := !( tabNumber = VAL(RIGHT( members[x]:event, 1)))
      IF( lOk, members[x]:oXbp:disable(), members[x]:oXbp:enable() )
      members[x]:oXbp:setColorFG( If( lOk, GraMakeRGBColor({128,128,128}),;
                                           GraMakeRGBColor({0,0,0})))
      members[x]:oXbp:configure()
    ENDIF
  NEXT
  *
  GenTreeFILE( ROZPAD_NENI )
  nVarRoot := KusTree->nVarCis
  DO CASE
    CASE tabNumber = 1     // dle POLOŽEK
      ActTreeFile()

    CASE tabNumber = 2     // dle PRACOVIŠ
      ActKalkMzd( , MZDY_PRACOV)
      KalkMZD->( AdsSetOrder( 2))

    CASE tabNumber = 3     // dle OPERACÍ
      ActKalkMzd( , MZDY_OPERACE)
      KalkMZD->( AdsSetOrder( 1))
  ENDCASE

  * Omezí na vyrábìné položky
  KusTREE->( AdsSetOrder( 2), mh_SetScope( '0' ))

  * Vysouètuje NH a KÈ do patièky
  nPriprCas := nKusovCas := nPriprKc := nKusovKc := 0
  Select( cFILE)
  SUM ( cFILE)->nPriprCas, ( cFILE)->nKusovCas, ( cFILE)->nPriprKc, ( cFILE)->nKusovKc ;
       To nPriprCas, nKusovCas, nPriprKc, nKusovKc
  ::nCas := nPriprCas + nKusovCas
  ::nKc  := nPriprKc  + nKusovKc
  ( cFILE)->( dbGoTOP())

  ::dc:oBrowse[ tabNumber]:oXbp:refreshAll()
  ::dm:refresh()
  *
  ::msg:WriteMessage(,0)
RETURN .T.

*
********************************************************************************
METHOD VYR_Kalk_MZD:destroy()
  ::drgUsrClass:destroy()

  ::nCas      := ;
  ::nKc       := ;
  nVarRoot    := ;
  ::cCisZakaz := ;
  ::cVyrPol   := ;
  ::cNazev    := ;
  ::nVarCis   := ;
                NIL
RETURN self

* ACTION - Detail VYRPOL
********************************************************************************
METHOD VYR_Kalk_MZD:Detail_1()
LOCAL oDialog, cKEY, nRecNO := VYRPOL->( RecNO())

  cKEY := UPPER( KusTree->cCisZakaz) + UPPER( KusTree->cVyrPol) + StrZERO( KusTree->nVarCis, 3)
  VYRPOL->( dbSEEK( cKEY))
  VYR_VYRPOL_INFO( ::drgDialog)
  VYRPOL->( dbGoTO( nRecNO))
RETURN self

* ACTION - Detail pracovištì  C_PRACOV
********************************************************************************
METHOD VYR_Kalk_MZD:Detail_2()
LOCAL oDialog, cKEY

  ::drgDialog:pushArea()                  // Save work area
  cKEY := UPPER( KalkMZD->cOznPrac)
  IF  C_PRACOV->( dbSEEK( cKEY))
    DRGDIALOG FORM 'VYR_PRACOV_CRD' PARENT ::drgDialog CARGO drgEVENT_EDIT MODAL DESTROY
  ENDIF
  ::drgDialog:popArea()                  // Restore work area

RETURN self

* ACTION - Detail operace  OPERACE
********************************************************************************
METHOD VYR_Kalk_MZD:Detail_3()
LOCAL oDialog, cKEY

  ::drgDialog:pushArea()                  // Save work area
  cKEY := UPPER( KalkMZD->cOznOper)
  IF  OPERACE->( dbSEEK( cKEY))
    * Musí se nachystat podmínky pro regulérní zobrazení karty => obecná funkce
    drgDBMS:open('HodAtrib' )
    drgDBMS:open('PPOper'   )
    drgDBMS:open('PracPost' )
    HodAtrib->( mh_SetScope( Upper( Operace->cOznOper)) )
    PPOper->( mh_SetScope( Upper( Operace->cOznOper)) )

    DRGDIALOG FORM 'VYR_OPERACE_CRD' PARENT ::drgDialog CARGO drgEVENT_EDIT MODAL DESTROY
  ENDIF
  ::drgDialog:popArea()                  // Restore work area

RETURN self


* sloupce v browse ... vyr_Kalk_Mzd.frm
*===============================================================================
FUNCTION VYR_TypPOL( nInit)
  Local cTypPOL := KusTREE->cTypPOL, cTAG, lExistKOO := NO
  Local cScope  := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol)

  IF !ISNIL( nINIT) .AND. nINIT == 3  // Jde o browse KOOP 1
    PolOPER->( mh_SetSCOPE( cScope) )
      cTAG := OPERACE->( AdsSetOrder( 1))
      DO WHILE !PolOPER->( EOF())
        OPERACE->( dbSEEK( Upper( PolOper->cOznOper)))
        lExistKOO := IF( UPPER( Operace->cTypOPER) == 'KOO', YES, lExistKOO )
        PolOPER->( dbSKIP())
      ENDDO
      OPERACE->( AdsSetOrder( cTAG))
    PolOPER->( mh_ClrScope())
  ENDIF
  cTypPOL := IF( lExistKOO, 'KOO', cTypPOL )
RETURN( cTypPOL)

* Výpoèítá a naplní položky potøebné pro kalkulaci pøímých mezd dle položek
*===============================================================================
FUNCTION ActTreeFILE( nDavka, lKOO, cTypKalk, fromNabVys )
  Local nPCas := 0, nPKc := 0, nKCas := 0, nKKc := 0, nVyrRez := 0  // za jednu operaci
  Local nPriprCas , nPriprKc , nKusovCas , nKusovKc, nVyrRezie      // suma ze vçechny operace
  Local nMnDavka, nRecVyrPol := VyrPol->( RecNO())
*  Local lForNabVys := .F.

  DEFAULT lKOO To NO, cTypKalk TO 'STD', fromNabVys TO .F.

  IF( Used('C_Tarif') , NIL, drgDBMS:open('C_Tarif'  ))
  IF( Used('PolOper') , NIL, drgDBMS:open('PolOper'  ))
  IF( Used('Operace') , NIL, drgDBMS:open('Operace'  ))
  IF( Used('C_Pracov'), NIL, drgDBMS:open('C_Pracov' ))
  fOrdRec( { 'PolOper, 1', 'Operace, 1', 'c_Tarif, 1', 'VyrPol, 1' } )
  KusTREE->( mh_ClrScope(), dbGoTOP() )

  nVarRoot := KusTREE->nVarCis // DEFAULT nVarRoot TO KusTREE->nVarCis 18.7.07

  DO WHILE !KusTree->( Eof())

    If KusTree->lNakPol
       // KusTree->nCenaCelk += PrirazkaCMP( 'KusTREE->nCenaCELK')
    ELSE   // If !KusTree->lNakPol
       IF KusTREE->( RecNO()) == 1
**18.7.07         VyrPol->( dbSeek( Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol)))
         VyrPol->( dbSeek( Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol)+ StrZero( KusTree->nVarCis, 3)))
         nRecVyrPol := VyrPol->( RecNO())
       ENDIF
       nDavka := IF( IsNIL( nDavka), 1, nDavka )
       IF EMPTY( KusTREE->cCisZAKAZ)
//          nMnDavka := IF( VyrPol->nEkDav <> 0,;
//                          VyrPOL->nEkDav * KusTree->nSpMnoNas, nDavka )
          IF cTypKALK == 'DAV'   // .OR. cTypKALK == 'VYR'
            VyrPol->( dbSeek( Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol)))
            nMnDavka := IF( VyrPol->nEkDav > 1, VyrPOL->nEkDav, nDavka)
          ELSE
            nMnDavka := nDavka  // * KusTREE->nSpMnoNas
          ENDIF
       ELSE
          nMnDavka := nDavka // * KusTREE->nSpMnoNas
       ENDIF
       //-
       nPriprCas := nPriprKc := nKusovCas := nKusovKc := nVyrRezie := 0
       BuildRYO( , lKOO)
       DO WHILE !PolOper->( Eof())
          Operace->( dbSeek( Upper( PolOper->cOznOper)))
          C_Pracov->( dbSEEK( Upper( Operace->cOznPrac)))
          nPCas := PolOper->nPriprCas / nMnDavka  //  * KusTree->nSpMnoNas
          c_Tarif->( dbSeek( Upper( Operace->cTarifStup + Operace->cTarifTrid)))
          nPKc  := nPCas * (( c_Tarif->nHodinSaz + c_Tarif->nHodinNav) / 60 )
          If PolOper->nCelkKusCa > 0
            nKCas := PolOper->nCelkKusCa * KusTree->nSpMnoNas
          Else
            nKCas := Operace->nKusovCas * PolOper->nKoefKusCa * KusTree->nSpMnoNas * ;
                     Operace->nKoefSmCas * Operace->nKoefViOb / Operace->nKoefViSt
          Endif
          nVyrRez := (( nKCas + nPCas) / 60 ) * C_Pracov->nSazbaStro

//          If PolOper->nKcNaOper > 0
          If UPPER( Operace->cTypOper) == 'KOO' .or. fromNabVys   //lForNabVys
             nKKc := PolOper->nKcNaOper * KusTree->nSpMnoNas
          Else
             nKKc := nKCas * (( c_Tarif->nHodinSaz + c_Tarif->nHodinNav) / 60 )
          EndIf
          //
          nPriprCas += nPCas
          nPriprKc  += nPKc
          nKusovCas += nKCas
          nKusovKc  += nKKc
          nVyrRezie += nVyrRez
          PolOper->( dbSkip())
       EndDo
       KusTree->nPriprCas  :=  nPriprCas
       KusTree->nPriprKc   :=  nPriprKc
       KusTree->nKusovCas  :=  nKusovCas
       KusTree->nKusovKc   :=  nKusovKc
       KusTree->nVyrRezie  :=  nVyrRezie
       PolOPER->( mh_ClrScope())

    Endif
    KusTree->( dbSkip())
  EndDo
  BuildRYO( NO)
  fOrdRec()
  KusTree->( dbGoTop())
  VyrPOL->( dbGoTO( nRecVyrPOL))
RETURN Nil

* Vypoèítá a naplní položky potøebné pro kalkulaci pøímých mezd dle pracovištì
*===============================================================================
STATIC FUNCTION ActKalkMzd( nDavka, nTypKalk)
  Local lExist, lOk, lKOO := NO
  Local nPCas := 0, nPKc := 0, nKCas := 0, nKKc := 0  // za jednu operaci
  Local nPriprCas , nPriprKc , nKusovCas , nKusovKc   // suma za pracoviçtØ
  Local nMnDavka

  IF( Used('C_Tarif'), NIL, drgDBMS:open('C_Tarif' ))
  fOrdRec( { 'PolOper, 1', 'Operace, 1', 'c_Tarif, 1', 'VyrPol, 1', 'KalkMzd, 1' } )
  KusTREE->( mh_ClrScope() )
  KalkMZD->( dbZAP())

  DO WHILE !KusTree->( Eof())
    If !KusTree->lNakPol
       VyrPol->( dbSeek( Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol)))
       //Ä IF IsNIL( nDavka) ... vol no z Kalkulac¡ pý¡mìch mezd
       //  ELSE              ... vol no z kalkulaŸn¡ karty
       // nMnDavka := IF( VyrPol->nEkDav <> 0, VyrPOL->nEkDav,;
       //                IF( IsNIL( nDavka), 1, nDavka) )
       //- 24.10.2000
       nDavka := IF( IsNIL( nDavka), 1, nDavka )
       IF EMPTY( KusTREE->cCisZAKAZ)
          nMnDavka := IF( VyrPol->nEkDav <> 0, VyrPOL->nEkDav, nDavka )
       ELSE
          nMnDavka := nDavka * KusTREE->nSpMnoNas
       ENDIF
       //-
       nPriprCas := nPriprKc := nKusovCas := nKusovKc := 0
       BuildRYO( , lKOO )
       Do While !PolOper->( Eof())
          Operace->( dbSeek( Upper( PolOper->cOznOper)))
          nPCas := PolOper->nPriprCas / nMnDavka * KusTree->nSpMnoNas
          c_Tarif->( dbSeek( Upper( Operace->cTarifStup + Operace->cTarifTrid)))
          nPKc  := nPCas * (( c_Tarif->nHodinSaz + c_Tarif->nHodinNav) / 60 )
          If PolOper->nCelkKusCa > 0
            nKCas := PolOper->nCelkKusCa * KusTree->nSpMnoNas
          Else
            nKCas := Operace->nKusovCas * PolOper->nKoefKusCa * KusTree->nSpMnoNas * ;
                     Operace->nKoefSmCas * Operace->nKoefViOb / Operace->nKoefViSt
          Endif
          If PolOper->nKcNaOper > 0
             nKKc := PolOper->nKcNaOper * KusTree->nSpMnoNas
          Else
             nKKc := nKCas * (( c_Tarif->nHodinSaz + c_Tarif->nHodinNav) / 60 )
          EndIf
          //
          If nTypKalk == MZDY_PRACOV
             lExist := KalkMzd->( dbSeek( Upper( Operace->cOznPrac)))
             If( lExist, Nil, KalkMzd->( dbAppend()) )
             KalkMzd->cOznPrac  := Operace->cOznPrac
             KalkMzd->nPriprCas += nPCas
             KalkMzd->nPriprKc  += nPKc
             KalkMzd->nKusovCas += nKCas
             KalkMzd->nKusovKc  += nKKc
          ElseIf nTypKalk == MZDY_OPERACE
             KalkMzd->( dbAppend())
             KalkMzd->cVyrPol   := PolOper->cVyrPol
             KalkMzd->cOznOper  := PolOper->cOznOper
             KalkMzd->nPriprCas := nPCas
             KalkMzd->nPriprKc  := nPKc
             KalkMzd->nKusovCas := nKCas
             KalkMzd->nKusovKc  := nKKc
          EndIf
          PolOper->( dbSkip())
       EndDo
       PolOPER->( mh_ClrScope())
    Endif
    KusTree->( dbSkip())
  EndDo
  BuildRYO( NO)
  fOrdRec()
Return( Nil)

* Vytvoøí pro 1.položku v KusTREE RYO-filter požadovaných operací
*===============================================================================
STATIC FUNCTION BuildRYO( lBuild, lKOO )
  Local nArea := Select(), nRec, nPos, anRec := {}
  Local cScope := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol)
  Local cKeyOld, cKeyNew, lOK, cFilter := ''
  Local nTypVar
  * 22.7.10
  nTypVar :=  SysConfig( 'Vyroba:nTypVar')
  nTypVar := If( IsArray( nTypVar), 1, nTypVar )
  *
  DEFAULT lBuild To YES, lKOO To NO

  Select( 'PolOper')
  PolOPER->( Ads_ClearAOF(), dbGoTOP())
*  PolOPER->( dbClearFilter(), dbGoTOP())

  IF lBuild
    PolOPER->( mh_SetSCOPE( cScope))
    Operace->( AdsSetOrder( 1))
    cKeyOld := Space( 50)   // Space( 35)
    DO WHILE !PolOper->( Eof())
      Operace->( dbSeek( Upper( PolOper->cOznOper)))
      lOK := If( lKOO, UPPER( Operace->cTypOper) == 'KOO',;
                       UPPER( Operace->cTypOper) <> 'KOO' .AND. ;
                       UPPER( Operace->cTypOper) <> 'PRI'  )
      IF lOK           // vylouèí se všechny/zahrnou se pouze  Kooperace
        nRec := PolOper->( RecNo())
        cKeyNew := cScope + StrZero( PolOper->nCisOper, 4) + ;
                   StrZero( PolOper->nUkonOper, 2)
        IF cKeyNew <> cKeyOld
          IF PolOper->( dbSeek( cKeyNew + StrZero( nVarRoot, 3)))
            nPos := aSCAN( anRec, PolOper->( RecNo()) )
            IF nPos == 0
              aAdd( anRec, PolOper->( RecNo()) )
            ENDIF
          ELSEIF nTypVar = 1
            IF PolOper->( dbSeek( cKeyNew + '001'))
              aAdd( anRec, PolOper->( RecNo()) )
            ENDIF
          ENDIF
        ENDIF
        PolOper->( dbGoTo( nRec))
        cKeyOld := cKeyNew
      Endif
      PolOper->( dbSkip())
    ENDDO
    *
    PolOPER->( mh_RyoFILTER( anREC, 'POLOPER'))
    /*
    PolOper->( dbGoTop())
    AEval( anRec, {|X| cFilter += 'RECNO() = ' + STR(X) + ' .or. ' })
    cFilter := LEFT( cFilter, LEN(cFilter) -6)
    cFilter := IF( EMPTY( cFilter), 'RECNO() = 0', cFilter )
    PolOPER->( dbSetFilter( COMPILE(cFilter)), dbGoTOP() )
    */
  ENDIF
  dbSelectArea( nArea)
RETURN Nil