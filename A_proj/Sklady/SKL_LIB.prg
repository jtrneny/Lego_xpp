********************************************************************************
*  SKL_LIB
********************************************************************************

#include "Common.ch"
#include "Drg.ch"
#include "Appevent.ch"
#include "Gra.ch"
#include "..\SKLADY\SKL_Sklady.ch"


*****************************************************************************
* Vol�n� po�izovac�ch mechanism� pro jednotliv� typy karet
*****************************************************************************
FUNCTION SelectCARD( oDialog, nKarta, lNewRec)
  Local nRecNO := PVPHEAD->( RecNO())
  Local nDoklad := PVPHEAD->nDoklad
  Local aCargo, cTag, cCRD, aEDT
  Local nCislPoh
  Local lFakParSym := SysConfig( 'Sklady:lFakParSym')

  DEFAULT lNewRec TO .F.

  DO CASE
    * P��jmy
    CASE nKarta = 100  ; cCRD := '0000'   // P��jem - jin� p��jem
    CASE nKarta = 102  ; cCRD := '0A02'   // Produkce
    CASE nKarta = 103  ; cCRD := '1012'   // V�robn� produkce
    CASE nKarta = 104  ; cCRD := '1012'   // V�robn� produkce
/* POZN.  u karty 104 lze editovat vnitrocenu, u karty 103 nelze
          v HLA kart� se edituje ( vyb�r�) zak�zka !
*/
    CASE nKarta = 110  ; cCRD := '0100'   // P��jem - vazba na dodavatele
    CASE nKarta = 120   //; cCRD := '0200'   // P��jem - bez vazby na dodavatele
                         cCrd := IIF( lFakParSym, '2100', '2200' )
    CASE nKarta = 111  ; cCRD := '0101'   // P��jem z prodejn� ceny - mar�e
    CASE nKarta = 116  ; cCRD := '0106'   // P��jem z prodejn� ceny - rabat
    CASE nKarta = 117  ; cCRD := '1107'   // P��jem v zahr. m�n�
    CASE nKarta = 130  ; cCRD := '0300'   // P��jem - nevyfakturov�no
    CASE nKarta = 142  // ; cCRD := '0402'   // P��jem - s variabiln�m symbolem
         cCrd := IIF( lFakParSym, '4102', '4202' )

    * V�deje
    CASE nKarta = 203  ; cCRD := '0A03'   // '0003'   // Jin� v�dej
    CASE nKarta = 204  ; cCRD := '0A04'   // '0004'   // Spot�eba
    CASE nKarta = 244  ; cCrd := '4304'   //; cCRD := '0404'   // NN  V�dej s V-Symbolem

    CASE nKarta = 274  ; cCRD := '0704'   // Spot�eba na zak�zku
    CASE nKarta = 205  ; cCRD := '0A05'   // '0005'   // V�dej do DKP     DOSUD NENI
    CASE nKarta = 206  ; cCRD := '0A61 '  // '0061'   // Spot�eba s vazbou na cKlicOdpMi  DOSUD NENI
    CASE nKarta = 253  ; cCRD := '0503'   // Prodej na fakturu ( DL)
    CASE nKarta = 255  ; cCRD := '0503'   // Prodej z fakturace - 2.3.2007
    CASE nKarta = 263  ; cCRD := '0603'   // Jednoduch� prodej
*    CASE nKarta = 283  ; cCRD := '0803'   // Prodej za hotov� -- �loha PRODEJ
    CASE nKarta = 293  ; cCRD := '0903'   // Prodej na zak�zku
    CASE nKarta = 299  ; cCRD := '0909'   // Oprava prodeje
    * P�evody
    CASE nKarta = 305  ; cCRD := '0051'   //  Automatick� p�evod mezi sklady  6.10.06
    * P�ecen�n�
    CASE nKarta = 400  ; cCRD := '0400'   // NN  P�ecen�n�
    OTHERWISE
      cCRD := '0000'
  ENDCASE

  aEDT := ShowGROUP( oDialog, cCRD )
  SetBUTTON_Edit( { 'Vyber_SKLAD', 'Vyber_POHYB' }, oDialog:oForm:aMembers, .F.)
  nDoklad := PVPHEAD->nDoklad
  PVPHEAD->( dbGoTO( nRecNO))

RETURN aEDT

*****************************************************************************
* Zobrazen� po�adovan�ho panelu ( skupiny �daj�)
* Parametry:
* oDialog ...
* nPOS    ... indikace ur�uj�c� panel v klauzuli GROUP( nPOS)
*===============================================================================
FUNCTION ShowGROUP( oDialog, cPOS)
  LOCAL N, oVAR, cStr
*  Local Members := oDialog:dialogCtrl:Members[1]:aMembers
  Local membersORG := oDialog:UDCP:membersORG
  Local membersUSR := {}
  Local EditMembers := {}
  Local varsORG := oDialog:UDCP:varsORG
  Local varsUSR := drgArray():new(30)


  For N := 1 To LEN( membersORG)
    oVAR := membersORG[N]
    If IsMemberVar(oVAR,'Groups')
      If IsCharacter(oVAR:Groups)
        If oVAR:Groups <> ''
          oVAR:IsEDIT := .F.
          oVAR:oXbp:Hide()
        EndIf
      EndIf
    EndIf
  Next

  For N := 1 To LEN( membersORG)
    oVAR := membersORG[N]
    If IsMemberVar(oVAR,'Groups')
      IF IsNIL( oVAR:Groups)
        AADD( membersUSR, oVar)
      ElseIf IsCharacter( oVAR:Groups)
        If LEN( oVar:Groups) = 2          // Karta HLA
          If oVAR:Groups == Left( cPOS, 2)
            IF oVAR:ClassName() $ 'drgGet,drgComboBox'
              oVAR:IsEDIT := .t.  // ModiGroup( oVAR)
              IF oVAR:IsEDIT
                oVAR:oXbp:Show()
                AADD( EditMembers, { oVar, n })
                AADD( membersUSR, oVar)
              ENDIF
            ELSE
              oVAR:oXbp:Show()
              AADD( membersUSR, oVar)
            ENDIF
          EndIf
        ElseIf LEN( oVar:Groups) >= 4     // Karta POL
          * cStr := oVar:Group
          IF cPOS $ oVar:Groups
            IF oVAR:ClassName() = 'drgGet'
              oVAR:IsEDIT := .T.
              oVAR:oXbp:Show()
              AADD( EditMembers, { oVar, n })
              AADD( membersUSR, oVar)
            ELSE
              oVAR:oXbp:Show()
              AADD( membersUSR, oVar)
            ENDIF
          ENDIF
        ELSE
          AADD( EditMembers, { oVar, n })
          AADD( membersUSR, oVar)
        EndIf
      EndIf
    ELSE
      AADD( membersUSR, oVar)
    EndIf
  Next

  For N := 1 To LEN( varsORG:values)
    oVAR := varsORG:values[N, 2]:oDrg
    IF oVAR:ClassName() $ 'drgGet,drgText,drgComboBox'
      If IsNIL( oVar:Groups)
        varsUSR:add(oVar:oVar, oVar:oVar:name)
      ElseIf LEN( oVar:Groups) = 2          // Karta HLA
        If oVAR:Groups == Left( cPOS, 2)
          varsUSR:add(oVar:oVar, oVar:oVar:name)
        ENDIF
      ElseIf LEN( oVar:Groups) >= 4     // Karta POL
        cStr := oVar:Groups
        IF cPOS $ cStr
          varsUSR:add(oVar:oVar, oVar:oVar:name)
        ENDIF
      ELSE
        varsUSR:add(oVar:oVar, oVar:oVar:name)
      ENDIF
    ENDIF
  NEXT

  FOR n := 1 TO LEN( membersUSR)
    IF membersUSR[n]:ClassName() = 'drgTabPage'
      membersUSR[n]:onFormIndex := n
    ENDIF
  NEXT

  oDialog:oForm:aMembers   := membersUSR
  oDialog:dataManager:vars := varsUSR

Return EditMembers

*
*-------------------------------------------------------------------------------
STATIC FUNCTION ModiGroup( oVAR)
  Local isEdit := .T.
  Local cHLA := oVar:Groups
  Local Name // := IF( IsMemberVar( oVar, 'Name'), oVar:NAME, NIL)
  Local nKARTA := oVar:drgDialog:UDCP:nKARTA
  Local lFakParSym := SysConfig( 'Sklady:lFakParSym')
  Local cTypPohyb  := LEFT( ALLTRIM(STR( nKarta)), 1 )

  IF IsMemberVar( oVar, 'Name')
    Name := oVar:Name
    DO CASE
    CASE cHLA == '02'
      isEdit := IIF( Name == 'PVPHEAD->NCISFAK' , lFakParSym,;
                IIF( Name == 'PVPHEAD->NCISLODL', !lFakParSym, isEdit ) )

    CASE cHLA == '04'
      isEdit := IIF( Name == 'PVPHEAD->NCISFAK' , lFakParSym ,;
                IIF( Name == 'PVPHEAD->NCISLODL', !lFakParSym, isEdit ) )
    ENDCASE
  ELSE
    isEdit := .F.   // drgText
  ENDIF
RETURN isEdit

* Nastaven� (ne)editovatelnosti tla��tek
*===============================================================================
FUNCTION SetBUTTON_Edit( aEvent, Members, isEdit)
  Local m, n

  If IsArray( Members)
    For m := 1 To LEN( aEvent)
      For n := 1 To Len( Members)
        If Members[ n]:isDerivedFrom('drgPushButton')
          If ( Members[ n]:Event = aEvent[m] )
            * z�ejm� m��e b�t na FRM i button, kter� m� v EVENT ��slo ud�losti
            Members[n]:IsEdit := isEdit
          EndIf
        EndIf
      Next
    Next
  EndIf

RETURN NIL

* Vyhled� po�adovanou firmu a vr�t� po�adovanou polo�ku
*===============================================================================
FUNCTION SeekFIRMA( nFirma, cFIELD)
  Local nArea := Select(), xVAL := ''

  DEFAULT cFIELD TO 'cNazev'
  IF FIRMY->( dbSEEK( nFIRMA,, 'FIRMY1' ))
    xVAL := FIRMY->&cFIELD
  ENDIF
  Select( nArea)
RETURN xVAL

*
*===============================================================================
FUNCTION dbCOUNT( cAlias)
  Local nRecCount := 0, nRecNo := ( cAlias)->( RecNo())

 ( cAlias)->( dbGoTop())
 ( cAlias)->( dbEval( { || nRecCount++ }))
 ( cAlias)->( dbGoTo( nRecNo))
/*
Function ScopedOrdKeyCount()
   Local nRecNo:=RecNo()
   Local nTop:=0
   dbGoTop()
   nTop=ordKeyNo()
   dbGoBottom()
   nRecords:= ordKeyNo()-nTop+1
   dbGoto(nRecNo)
Return nRecords
*/

Return( nRecCount)

/*  TMP
*===============================================================================
FUNCTION StoreOBD()
  Local  cOBDOBI := StrZero( uctOBDOBI:SKL:nObdobi, 2) + '/' + ;
                    RIGHT( StrZero( uctOBDOBI:SKL:nROK, 4), 2)
RETURN cOBDOBI
*/
*
*===============================================================================
FUNCTION SKL_CENZBOZ_INFO( oDlg)
  LOCAL oDialog
  LOCAL nArea := Select(), cTag := OrdSetFocus(), nRecNO := RecNO()

  IF EMPTY( CENZBOZ->cSklPol)
    drgMsgBox(drgNLS:msg( 'Skladov� polo�ka nen� k didpozici ...' ))
    RETURN NIL
  ENDIF
  *
*  oDlg:pushArea()
  DRGDIALOG FORM 'SKL_CENZBOZ_CRD' PARENT oDlg CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Cen�k zbo�� - INFO') MODAL DESTROY
  *
  dbSelectArea( nArea)
  IF( cTag <> '' , ( nArea)->( AdsSetOrder( cTag)), NIL )
  IF( nRecNO <> 0, ( nArea)->( dbGoTO( nRecNO))   , NIL )
*  oDlg:popArea()
RETURN NIL

* Algoritmus v�po�tu sazby DPH :   1...do 30.4.2004, 2 ...od 1.5.2004
*===============================================================================
FUNCTION SKL_AlgSazDPH( nCisFirmy, dDate)
  Local nALG := 1, cVypSazDan, lOldDph

  Firmy->( dbSEEK( nCisFirmy,,'FIRMY1'))
  IF EMPTY( Firmy->cVypSazDan)                        //- nastaven na firm�
    cVypSazDan := SysCONFIG( 'Finance:cVypSazDPH')
    IF EMPTY( cVypSazDan)                            //- nastaven v konfiguraci
      nALG := IIF( dDate < CTOD( '01.05.04'), 1, 2 ) //- dle data zdanit. pln�n�
    ELSE
      nALG := VAL( RIGHT( cVypSazDan, 1))
    ENDIF
  ELSE
    nALG := VAL( RIGHT( Firmy->cVypSazDan, 1))
  ENDIF
  lOldDPH := IIF( nALG == 1, YES,;
             IIF( nALG == 2, NO , YES ) )
RETURN ( lOldDPH)

*
*===============================================================================
FUNCTION mh_SetScope( xTop, xBot)
  *
  Do Case
  Case pcount() = 1
    dbSetScope( SCOPE_BOTH, xTop)
  Case pcount() = 2
    If !IsNil(xTop) .and. !IsNil(xBot)
      dbSetScope( SCOPE_TOP   , xTop)
      dbSetScope( SCOPE_BOTTOM, xBot)
    ElseIf !IsNil(xTop) .and. IsNil(xBot)
      dbSetScope( SCOPE_TOP, xTop)
    ElseIf IsNil(xTop) .and. !IsNil(xBot)
      dbSetScope( SCOPE_BOTTOM, xBot)
    Endif
  EndCase

  dbGoTop()
RETURN Nil

*===============================================================================
FUNCTION mh_ClrScope( nScope)

  DEFAULT nScope TO SCOPE_BOTH
  *
  DbClearScope(nScope)
  dbGoTop()
RETURN Nil

*===============================================================================
FUNCTION mh_SetFILTER( cFilter, goTO )

  DEFAULT goTO TO FLT_TOP
  *
  Ads_SetAOF( cFilter)
*  dbSetFilter( COMPILE( Filter))
  IF( goTO = FLT_TOP, dbGoTOP()   ,;
  IF( goTO = FLT_BOT, dbGoBOTTOM(),;
  IF( goTO = FLT_NO , NIL         ,  dbGoTO( goTO) )))
RETURN Nil

*
*===============================================================================
FUNCTION mh_ClrFILTER()

  Ads_ClearAOF()
*  dbClearFilter()
RETURN Nil

*
*===============================================================================
FUNCTION ColorOfTEXT( members)
  Local x, nColor, groups

  For x := 1 TO Len(members)
    groups := If( IsMemberVar( members[x], 'groups'), members[x]:groups, '' )
    If ( members[x]:ClassName() = 'drgText' .or. members[x]:ClassName() = 'drgStatic') .and. !Empty(groups)
      nColor := nil
      Do Case
      Case 'clrGREY' $ groups .or. 'clrINFO' $ groups
        nColor := GraMakeRGBColor( {221, 221, 221})
      Case 'clrBLUE' $ groups
        nColor := GraMakeRGBColor( {220, 220, 250})
      Case 'clrYELL' $ groups
        nColor := GraMakeRGBColor( {255, 255, 200} )
      Case 'clrGREEN' $ groups
        nColor := GraMakeRGBColor( {200 ,255, 200} )   // GRA_CLR_GREEN
      Otherwise
*        nColor := GraMakeRGBColor( {221, 221, 221})
      EndCase
      If !IsNIL( nColor)
        members[x]:oXbp:setColorBG( nColor)
      EndIf
    EndIf
  Next

RETURN NIL

*
*===============================================================================
FUNCTION SKL_postAppendObdobi( oDlg)
*  drgMsgBox(drgNLS:msg( 'Akce ... postAppendObdobi ... FUNKCE' ))
  SKL_CenZb_ps( oDlg)      // aktualizace po�. stav�
RETURN NIL

* P�i zalo�en� 1.obdob� zalo�it z�znam s po�.stavem
*===============================================================================
FUNCTION  SKL_CenZb_ps( oDlg)
  Local nCount, lSeek, cKey
  Local newObdobi := oDlg:udcp:o_Obdobi:value
  LOCAL newRok    := oDlg:udcp:o_Rok:value

  IF newObdobi = 1          // na po�. roku
    drgDBMS:open('CENZBOZ'  )
    drgDBMS:open('CENZB_ps' )
    *
    CenZboz->( dbGoTop())
    nCount := CenZboz->( mh_COUNTREC())
    *
    drgServiceThread:progressStart(drgNLS:msg('Generuji po��te�n� stavy pro rok [ ' + Str( newRok) + ' ]  ...', 'CenZboz'), nCount  )

    DO WHILE !CenZboz->( Eof())
      IF CenZboz->( RLock())
        * aktualizace po�.hodnot na skladov� kart�
        CenZboz->nCenaPoc  := CenZboz->nCenacZBO
        CenZboz->nMnozPoc  := CenZboz->nMnozsZBO
        * aktualizace souboru po�. stav�
        cKey := Upper(CenZboz->cCisSklad) + Upper(CenZboz->cSklPol) + StrZero( newRok, 4)
        IF (lSeek := CenZb_ps->( dbSeek( cKey,, 'CENPS01')) )
          IF CenZb_ps->( RLock())
            CenZb_ps->nCenaPoc   := CenZboz->nCenaCZBO
            CenZb_ps->nMnozPoc   := CenZboz->nMnozSZBO
          ENDIF
        ELSEIF  CenZb_ps->( dbAppend(), RLock())
          mh_CopyFld( 'CenZboz', 'CenZb_ps')
          CenZb_ps->nRok := newRok
        ENDIF
      ENDIF
      CenZboz->( dbSkip())
      *
      drgServiceThread:progressInc()
    ENDDO
    *
    drgServiceThread:progressEnd()
    *
    CenZboz->( dbUnlock())
    CenZb_ps->( dbUnlock())
  ENDIF

RETURN NIL

* Vr�t� koeficient p�epo�tu pro v�choz� a c�lovou MJ
*===============================================================================
FUNCTION KoefPrVC_MJ( cVychoziMJ, cCilovaMJ, cFromFILE )
  Local cKey

  DEFAULT cFromFILE TO 'C_Jednot'

  drgDBMS:open('C_PrepMJ',,,,, 'C_PrepMJw' )
  IF( Empty(cVychoziMJ), cVychoziMJ := cCilovaMJ, nil)
  *
  IF cVychoziMJ = cCilovaMJ
    RETURN 1
  ENDIF
  *
  cKey := Upper((cFromFILE)->cCisSklad) + Upper((cFromFILE)->cSklPol) + ;
          Upper( cVychoziMJ) + Upper( cCilovaMJ)
  IF C_PrepMJw->( dbSEEK( cKey,,'C_PREPMJ02'))
    RETURN C_PrepMJw->nKoefPrVC
  ENDIF
  * Pokud nenajde vztah V->C, hled� opa�n� vztah C->V a pou�ije inverzn� koeficient
  cKey := Upper((cFromFILE)->cCisSklad) + Upper((cFromFILE)->cSklPol) + ;
          Upper( cCilovaMJ) + Upper( cVychoziMJ)
  IF C_PrepMJw->( dbSEEK( cKey,,'C_PREPMJ02'))
    RETURN ( 1 / C_PrepMJw->nKoefPrVC )
  ENDIF
  *
  cKey := Upper( cVychoziMJ) + Upper( cCilovaMJ)
  IF C_PrepMJw->( dbSEEK( cKey,,'C_PREPMJ01'))
    RETURN C_PrepMJw->nKoefPrVC
  ENDIF

RETURN C_PrepMJw->nKoefPrVC

* Shod� p��znak aktualizac v UCETSYS RRRRMM
*===============================================================================
FUNCTION Ucetsys_ks(obdDokl)
  local  anUc := {}

  drgDBMS:open('UCETSYS')
  fordRec({'UCETSYS,3'})
  ucetsys->( DbSetScope( SCOPE_BOTH, 'U'), dbGoTop())
  ucetsys->( dbSeek('U' + obdDokl))

  do while .not. ucetsys->(eof())
    if( ucetsys->nAKTUc_KS = 2, AAdd(anUc, ucetsys->(recNo())), nil)
    ucetsys->(dbSkip())
  enddo

  if ucetsys->(sx_rlock(anUc))
    AEval(anUc, {|x| ( ucetsys->(dbGoTo(x))          , ;
                       ucetsys->nAKTUc_KS := 1       , ;
                       ucetsys->cuctKdo   := logOsoba, ;
                       ucetsys->ductDat   := date()  , ;
                       ucetsys->cuctCas   := time()    ) })
  endif

  ucetsys->(dbCommit(), dbUnlock(), dbClearScope())
  fordRec()
return nil

* Shod� p��znak aktualizac v UCETSYS RRRRMM
*===============================================================================
FUNCTION Cfg_kardex( typ)
  local  anCfg := {.f.,{}}
  local  aTm, aTx


  if AllTrim( SysCONFIG('Sklady:cKardex')) <> 'S:0,S:0;S:0,S:0;S:0,S:0'

//    anTm := ListAsArray( SysCONFIG('Sklady:cKardex'), ';')
    do case
    case  typ = 'CEN'
      aTm := ListAsArray( ListAsArray( SysCONFIG('Sklady:cKardex'), ';')[1])
      for n := 1 to len( aTm)
        aTx := ListAsArray( aTm[n],':')
        if aTx[2] = '1'
          AAdd( anCfg[2], aTx[1] )
          anCfg[1] := .t.
        endif
      next

    case  typ = 'PRI'
      aTm := ListAsArray( ListAsArray( SysCONFIG('Sklady:cKardex'), ';')[2])
      for n := 1 to len( aTm)
        aTx := ListAsArray( aTm[n],':')
        if aTx[2] = '1'
          AAdd( anCfg[2], aTx[1] )
          anCfg[1] := .t.
        endif
      next

    case  typ = 'VYD'
      aTm := ListAsArray( ListAsArray( SysCONFIG('Sklady:cKardex'), ';')[3])
      if Alltrim(aTm[1]) = '1'
        anCfg[1] := .t.
      endif
    endcase
  endif


return anCfg