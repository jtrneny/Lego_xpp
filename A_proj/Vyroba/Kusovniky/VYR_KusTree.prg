#include "common.ch"
#include "drg.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

# Define   CHR_NUL     '000'// Chr( 1)
# Define   DELIM    '.'

# Define   LAST     'L- '  // 'L- '   // 'ÀÄ '  // + chr( 149) + ' '   Ò    _
# Define   PREV     '|- ' // '+¦ '    // 'ÃÄ '  // + chr( 149) + ' '
# Define   LINE     '|  ' //'-  '     // '³  '

Static  aV, aN
Static  nLenAN, nVarPoz
Static  cLast
Static  cCisZakaz
Static  nTypVar  // lVzdyVar_1

* Generuje strukturu kusovníku do TMP souboru - KusTree.Dbf
*===============================================================================
FUNCTION GenTreeFILE( nRozpad, lMomentBox, nMnFinal, lNakPolCFG, fromNabVys )
  Local lOK := .T., lFound, lFirst := .T., lExist, lZaklPoz, lAppend
  Local lRozpad := !IsNil( nRozpad)
  Local cKey := CHR_NUL
  Local cTagTree, cKeyZAK
  Local nRecVyrPol := VyrPol->( RecNo()), cTagVyrPol := VyrPol->( AdsSetOrder( 1))
  Local n, m, nRecZakPoz, nRecRet, nPozOrg, nMinVarPoz := 999, nHandle
  Local lTreeALL   // !!! := GenTreeALL()

  * Varianta pozice se pøednastaví dle varianty výrobku
  nVarPoz    := VyrPol->nVarCis
  * NEW  19.7.2010
  * 1  = Pokud neexistuje požadovaná varinta, vždy ji nahraï základní variantou è. 1
  * 2  =      -         "        -          , položku ze struktury kusovníku vypustí
  nTypVar :=  SysConfig( 'Vyroba:nTypVar')
  nTypVar := If( IsArray( nTypVar), 1, nTypVar )


  Default lRozpad  To NO, cCisZakaz TO EMPTY_ZAKAZ // Space( 30)
  Default nMnFinal To  1, lNakPolCFG  TO YES, lTreeALL  TO YES
  Default fromNabVys To NO
  *
  drgDBMS:open('C_PrepMJ')

BEGIN SEQUENCE

  cKeyZAK := Upper( VyrPOL->cCisZakaz) + Upper( VyrPOL->cVyrPol) + ;
             StrZERO( VyrPOL->nVarCis, 3)
  cCisZakaz := VyrPOL->cCisZakaz

  aV := {}
  aAdd( aV, VyrPol->cVyrPol + CHR_NUL )
  aN := {}

  * Vytvoøení KusTree.Dbf + koøenový záznam
  KusTREE->( dbZAP())
  cTagTree := KusTree->( AdsSetOrder( 1))

//  kusov->( dbseek( upper(cCisZakaz) +upper(vyrPol->cvyrPol) ))
  AppendTmpTree( cKey,, nRozpad, nMnFinal, lTreeALL, fromNabVys)

  Do While lOK
     For n := 1 To Len( aV)
       KUSOV->( mh_SetScope( Upper( cCisZakaz + Left( aV[n], 15) ) ))
       nLenAN := CountOfPoz()
       m := 0

       Do While ! Kusov->( Eof())
         cKey := SubStr( aV[ n], 16 )   // AllTrim( SubStr( aV[ n], 16 ) )
         cKey := Left( cKey, Len( cKey) - 3)  // -1
         lFound := VyrPol->( dbSeek( Upper( cCisZakaz + Left( aV[ n], 15)) ))
         If lFound
*           ( lExist := FALSE, lZaklPoz := FALSE )   !!!! NEFUNGUJE
           lExist     := FALSE
           lZaklPoz   := FALSE
           nPozOrg    := Kusov->nPozice
           nMinVarPoz := 999
           Do While nPozOrg == Kusov->nPozice .and. !Kusov->(eof())
             If Kusov->nVarPoz == nVarPoz
               cKey := cKey +  StrZERO(Kusov->nPozice, LEN( CHR_NUL))+ CHR_NUL  // CHR( Kusov->nPozice + 32 ) + CHR_NUL
               m++
               If( lAppend := AppendTmpTree( cKey, m, nRozpad, nMnFinal, lTreeALL, fromNabVys ) )
                  aAdd( aN, Kusov->cNizPol + cKey )
               EndIf
               lExist := .T.
             ElseIf Kusov->nVarPoz == 1
               nRecZakPoz := Kusov->( RecNo())
               lZaklPoz := .T.
             Endif
             Kusov->( dbSkip())
           EndDo
           If !lExist .and. lZaklPoz .and. nTypVar = 1
           *  pokud neexistuje požadovaná  varianta pozice, uplatní se
           ** základní 001  // ta s nejnižší hodnotou, tj. s nejvyšší prioritou
              nRecRet := Kusov->( RecNo())
              Kusov->( dbGoTo( nRecZakPoz))
              cKey := cKey + StrZERO(Kusov->nPozice, LEN( CHR_NUL)) + CHR_NUL  // CHR( Kusov->nPozice + 32 ) + CHR_NUL
              m++
              AppendTmpTree( cKey, m, nRozpad, nMnFinal, lTreeALL, fromNabVys )
              aAdd( aN, Kusov->cNizPol + cKey )
              Kusov->( dbGoTo( nRecRet))
           Endif
         Else
           Kusov->( dbSkip())
         Endif
       EndDo
       KUSOV->( mh_ClrScope())
     Next
     aV := aN
     aN := {}
     lOK := ( Len( aV) <> 0 )

  EndDo

  KusTree->( AdsSetOrder( cTagTree), dbGoTop())

EndSEQUENCE

  VyrPol->( AdsSetOrder( cTagVyrPol), dbGoTo( nRecVyrPol) )
  KusTree->( AdsSetOrder( cTagTree))

RETURN Nil

* Pøidá záznam do KusTree.Dbf
*===============================================================================
FUNCTION AppendTmpTREE( cKey, nN, nRozpad, nMnFinal, lTreeALL, fromNabVys)
  Local  nPos, nVyrSt
  Local  nSpMno := nMnFinal, nSpMnoNas := nMnFinal, nCiMnoNas := nMnFinal
  Local  aDot := { '|', '/', '-', '\' }
  Local  cZnak := '', cTreeText := '', cKeyHlp
  Local  lNakPol, lFound, lAppend := .t.
***!<        Local  lZero := ( LastKey() == K_ALT_C )  //Ä Vynuluje mn. zadan‚ do vìroby
  Local  nVysVar, cVysVarPop, cNazevVys
  Local  C := 'GetMnZapus()', nMnZapus
  local  cKy, lis_spMNonas
  * z parenta
  local  nspMno_p := 1, nspMnoN_p := 1, nciMno_p := 1, nciMnoN_p := 1

  Static cPrevText, cLastZnak, cFinPol, cNazevFin, X

  Default  nN  To 0, cPrevText To '', cLastZnak To ''

  IF( Used('C_Stred'), NIL, drgDBMS:open('C_Stred' ))
  IF( Used('NakPOL' ), NIL, drgDBMS:open('NakPOL'  ))
  IF( Used('DodZBOZ'), NIL, drgDBMS:open('DodZBOZ' ))

Begin Sequence

  cKeyHlp := SubStr( cKey, 1, Len( cKey)-6) + CHR_NUL
  cKeyHlp := Upper( cKeyHlp)

  IF ( lFound := KusTree->( dbSeek( cKeyHlp)) )
    nPos      := At( '-', KusTree->cTreeText )
    cLastZnak := SubStr( KusTree->cTreeText, nPos-1, 3)
    cPrevText := Left( KusTree->cTreeText, nPos -2 ) + '   '
    nSpMno    := KusTree->nSpMno
    nSpMnoNas := KusTree->nSpMnoNas
    nCiMnoNas := KusTree->nCiMnoNas
    *
    nspMno_p  := KusTree->nSpMno
    nspMnoN_p := KusTree->nSpMnoNas
    nciMno_p  := KusTree->nCiMno
    nciMnoN_p := KusTree->nCiMnoNas
  Endif

  If nN == 0   // Koøenový záznam

    if ( .not. empty(kusov->ccisZakaz) .and. vyrZak->nautoPlan = 1 )
      nmnFinal := vyrZak->nMnozZadan
    endif

    KusTree->( dbAppend())
    *
    cFinPOL             := VyrPol->cVyrPol
    cNazevFin           := VyrPol->cNazev
    *
    KusTree->lRozpad    := TRUE
    KusTree->lZapustit  := If( nRozpad == 3 .OR. nRozpad == 6, NO, YES)
    KusTree->cTypPol    := VyrPol->cTypPol
    KusTree->cCisZakaz  := cCisZakaz
    KusTree->cVyrPol    := VyrPol->cVyrPol
    KusTree->nVarCis    := VyrPol->nVarCis
    KusTree->cVarPop    := VyrPol->cVarPop
    KusTree->cNazev     := VyrPol->cNazev
    KusTree->cZkratJEDN := VyrPol->cZkratJEDN
    KusTree->cSklPol    := VyrPOL->cSklPol
    KusTree->lNakPOL    := POLOTOV()
    KusTree->nEkDav     := VyrPol->nEkDav
    CisSKLAD()

    KusTree->nVyrSt     := 1
    KusTree->nPozice    := 1
    KusTree->nVarPoz    := VyrPol->nVarCis
    KusTree->cStav      := VyrPol->cStav
    KusTree->cTreeText  := IF( lTreeALL, '(-)', '(+)' ) + ' '+ AllTrim( VyrPol->cNazev)
    KusTree->cTreeKey   :=  cKey

    KusTree->nSpMno     := 1
    KusTree->nSpMnoNas  := nMnFinal  // 1
    KusTree->nCiMno     := 1
    KusTree->nCiMnoNas  := nMnFinal  // 1
    *
    KusTree->nspMno_J   := 1 // nmnFinal ??
    KusTree->nciMno_J   := 1 // nmnFinal ??

    nMnZapus            := EVAL( COMPILE( C))    //If( TSK_RV, EVAL( COMPILE( C)), 0)
    KusTree->nMnZadVA   := nMnZapus * KusTree->nSpMnoNas
    KusTree->nStrizPl   := VyrPol->nStrizPl
    KusTree->nKusyPas   := VyrPol->nKusyPas

    KusTree->cStred     := VyrPol->cStrVyr
    C_Stred->( dbSEEK( UPPER( KusTREE->cStred)))
    KusTREE->cTypStr    := C_Stred->cTypStr

    KusTREE->cFinPOL    := cFinPOL
    KusTREE->cNazevFin  := cNazevFin
    kusTree->nmnozZadan := nmnFinal
    kusTree->nKUSOV     := kusov->sid

  Else
    nVysVar    := VyrPol->nVarCis
    cVysVarPop := VyrPol->cVarPop
    cNazevVys  := VyrPol->cNazev

    cKeyHlp := Upper( cCisZakaz) + Upper( Kusov->cNizPol) + StrZero( Kusov->nNizVar, 3)
    lNakPol := Empty( Kusov->cNizPol )
    If !lNakPol
      lFound := VyrPol->( dbSeek( cKeyHlp))
      If !lFound
        IF nTypVar = 1
          * pokud neexistuje pøíslušná varianta, hledá  se základní varianta 1
          cKeyHlp := Upper( cCisZakaz) + Upper( Kusov->cNizPol) + '001'
          lFound := VyrPol->( dbSeek( cKeyHlp))
        ENDIF
        If !lFound
          * pokud neexistuje zákl. varianta 1, není položka zahrnuta do struktury
          lAppend := FALSE
BREAK
        Endif
      Endif
    Endif

    //nDeep := Len( cKey) -2
    nVyrSt := LEN( cKEY) / 3    // výrobní stupeò
    IF !lTreeALL .AND. nVyrSt > 2
BREAK
    ENDIF

    if ( .not. empty(kusov->ccisZakaz) .and. vyrZak->nautoPlan = 1 )
      nmnFinal := vyrZak->nMnozZadan
    endif

    nSpMno    := if( ( kusov->nMnozZadan = 0 .and. empty(kusov->ccisZakaz)), nMnFinal, kusov->nMnozZadan )
    nSpMnoNas := if( ( kusov->nMnozZadan = 0 .and. empty(kusov->ccisZakaz)), nMnFinal, kusov->nMnozZadan )
    nCiMnoNas := if( ( kusov->nMnozZadan = 0 .and. empty(kusov->ccisZakaz)), nMnFinal, kusov->nMnozZadan )

    lis_spMNonas := .f.

    do case
    case         empty(kusov->ccisZakaz)
      nSpMnoNas := nMnFinal
      nCiMnoNas := nMnFinal

    case ( .not. empty(kusov->ccisZakaz) .and. vyrZak->nautoPlan = 1 )
      if lnakPol
        nSpMnoNas := nspMNonas
        nCiMnoNas := nCiMnoNas
      else
        do case
        case kusov->nspMNOnas <> 0
          lis_spMNonas := .t.
          nspMNOnas    := kusov->nspMNOnas
          nCiMnoNas    := kusov->nspMNOnas
        case Len( AllTrim(KusTree->cTreeKey)) <= 6 .and. kusov->nvyrst <= 2
          nspMNOnas := if( kusov->nmnozZadan = 0 .or. kusov->nmnozZadan <> nMnFinal, nMnFinal, kusov->nmnozZadan )
          nCiMnoNas := if( kusov->nmnozZadan = 0 .or. kusov->nmnozZadan <> nMnFinal, nMnFinal, kusov->nmnozZadan )
        otherwise
          nspMNOnas := kusov->nmnozZadan
          nCiMnoNas := kusov->nmnozZadan
        endcase
      endif

//      nSpMnoNas := if( lnakPol, nspMNonas, if( kusov->nmnozZadan = 0 .or. kusov->nmnozZadan <> nMnFinal, nMnFinal, kusov->nmnozZadan ))   // vyrzak nmnFinal
//      nCiMnoNas := if( lnakPol, nCiMnoNas, if( kusov->nmnozZadan = 0 .or. kusov->nmnozZadan <> nMnFinal, nMnFinal, kusov->nmnozZadan ))   // vyrZak nmnFinal )

    otherWise
      nSpMnoNas := if( kusov->nMnozZadan = 0, 1, nMnFinal )
      nCiMnoNas := if( kusov->nMnozZadan = 0, 1, nMnFinal )
    endCase

    KusTree->( dbAppend())

    KusTree->lRozpad    := TRUE
    KusTree->lZapustit  := If( nRozpad == 3 .OR. nRozpad == 6, .F., .T. )
    KusTree->cCisZakaz  := cCisZakaz
    KusTree->nVysVar    := nVysVar
    KusTree->cVysVarPop := cVysVarPop
    KusTree->cNazevVys  := cNazevVys
    KusTree->cVyrPol    := VyrPol->cVyrPol
    KusTree->nVarCis    := VyrPol->nVarCis
    KusTree->cVarPop    := VyrPol->cVarPop
    KusTree->cNazev     := VyrPol->cNazev
    KusTree->cZkratJEDN := VyrPol->cZkratJEDN
    KusTree->cStav      := VyrPol->cStav
    KusTree->cVysPol    := Kusov->cVysPol
    KusTree->nVyrSt     := nVyrSt
    KusTree->nPozice    := Kusov->nPozice
    KusTree->nVarPoz    := IF( VYR_IsVyrZakIT(), nVarPoz, Kusov->nVarPoz)  // Kusov->nVarPoz   10.4.2007
    KusTree->cTreeKey   := cKey

    * z parenta
    KusTree->nspMno_p   := nspMno_p
    KusTree->nspMnoN_p  := nspMnoN_p
    KusTree->nciMno_p   := nciMno_p
    KusTree->nciMnoN_p  := nciMnoN_p

    KusTree->nSpMno     := Kusov->nSpMno * nspMno_p
    KusTree->nSpMnoNas  := if( lis_spMNonas, nspMNonas, KusTree->nSpMno * nspMNonas )
    KusTree->nCiMno     := Kusov->nCiMno * nciMno_p
    KusTree->nCiMnoNas  := if( lis_spMNonas, nspMNonas, KusTree->nCiMno * nCiMnoNas )
    *
    KusTree->nspMno_J   := Kusov->nSpMno
    KusTree->nciMno_J   := Kusov->nCiMno
    KusTree->cKodPoz    := Kusov->cKodPoz
    *
    KusTree->cText1     := Kusov->cText1
    KusTree->cText2     := Kusov->cText2
    ** Mn. zadané do výroby pro potøeby zapouštìní po položkách
    nMnZapus := EVAL( COMPILE( C))
    KusTree->nMnZadVA   := nMnZapus * KusTree->nSpMnoNas
    KusTree->nStrizPl   := VyrPol->nStrizPl
    KusTree->nKusyPas   := VyrPol->nKusyPas
    KusTree->cStred     := VyrPol->cStrVyr

    C_Stred->( dbSEEK( UPPER( KusTREE->cStred)))
    KusTREE->cTypStr    := C_Stred->cTypStr
    KusTree->cSklPol    := VyrPOL->cSklPol

    KusTree->nCisOper   := Kusov->nCisOper
    KusTree->nUkonOper  := Kusov->nUkonOper
    KusTree->nVarOper   := Kusov->nVarOper
    KusTREE->cFinPOL    := cFinPOL
    KusTREE->cNazevFin  := cNazevFin
    kusTree->nmnozZadan := if( ( kusov->nMnozZadan = 0 .and. empty(kusov->ccisZakaz)), nMnFinal, kusov->nmnozZadan )
    kusTree->nKUSOV     := kusov->sid

    Do Case
      Case nLenAN == 1 .or. nLenAN == nN   ;   cZnak := LAST
      Case nLenAN >  1                     ;   cZnak := PREV
      OtherWise                            ;   cZnak := LAST
    EndCase

    If cLastZnak == LAST
       cTreeText := cPrevText
    ElseIf Left( cKey, 1) == cLast
       cTreeText := SubStr( cPrevText, 1, Len( cPrevText) -3)
       cTreeText += If( cLastZnak == PREV, LINE, '')
    Else
       cTreeText := SubStr( cPrevText, 1, Len( cPrevText) -3)
       cTreeText += If( cLastZnak == PREV, LINE, '')
    Endif

///*
    cKeyHlp := If( lNakPol, Kusov->cSklPol, cKeyHlp )
    If lNakPol  /*  Skladová  položka */
*      fOrdRec( { 'NakPol, 1', 'CenZboz, 1', 'DodZboz, 3' })
      If NakPol->( dbSeek( Upper( cKeyHlp),, 'NAKPOL1'))
         CenZboz->( dbSeek( Upper( cKeyHlp),, 'CENIK01'))
         DodZBOZ->( dbSEEK( Upper( NakPOL->cSklPOL) + '1',, 'DODAV3' ))

         KusTree->cVyrPol    := EMPTY_VYRPOL  // Space( 15)
         KusTree->nVarCis    := 0

         KusTree->cSklPol    := NakPol->cSklPol
         KusTree->cNazev     := NakPol->cNazTpv
         KusTree->lNakPol    := .T.
* 29.8.07        KusTree->cZkratJEDN := NakPol->cMjTpv
* 24.10.07         KusTree->nKoefPREP  := NakPol->nKoefPREP
         KusTree->cZkratJEDN := CoalesceEmpty( Kusov->cZkratJedn, NakPOL->cZkratJedn, CenZboz->cZkratJedn )
         KusTree->cMjTpv     := IF( !EMPTY( Kusov->cMjTpv ), Kusov->cMjTpv ,;
                                IF( !EMPTY( NakPOL->cMjTpv), NakPOL->cMjTpv, '' ))     // CoalesceEmpty( Kusov->cMjTpv    , NakPOL->cMjTpv  )
         KusTree->cMjSpo     := IF( !EMPTY( Kusov->cMjSpo ), Kusov->cMjSpo ,;  // CoalesceEmpty( Kusov->cMjSpo    , NakPOL->cMjSpo  )
                                IF( !EMPTY( NakPol->cMjSpo), NakPol->cMjSpo, '' ))

         cKey := Upper( NakPOL->cCisSklad) + Upper( NakPOL->cSklPol) + ;
                 Upper( KusTree->cMjSpo) + Upper( KusTree->cZkratJEDN)
         IF C_PrepMJ->( dbSEEK( cKey,,'C_PREPMJ02'))
           KusTree->nKoefPREP := C_PrepMJ->nKoefPrVC
         ELSE
           KusTree->nKoefPREP := 1
         ENDIF

         KusTree->cTreeText  := cTreeText + cZnak + AllTrim( Str( KusTree->nPozice)) + ;
                                + DELIM + AllTrim( NakPol->cSklPol)+ DELIM + AllTrim( NakPol->cNazTpv)

         * pro kalkulace pøímého materiálu
         KusTree->nSpMno     := Kusov  ->nSpMno * nspMno_p
//         KusTree->nSpMnoNas  := KusTree->nSpMno * nSpMnoNas
         KusTree->nSpMnoNas  := if( ( kusov->nMnozZadan = 0 .and. empty(kusov->ccisZakaz)), KusTree->nSpMno * nSpMnoNas, kusov->nmnozZadan )

         KusTree->nCiMno     := Kusov  ->nCiMno * nciMno_p
//         KusTree->nCiMnoNas  := KusTree->nCiMno * nCiMnoNas
         KusTree->nCiMnoNas  := if( ( kusov->nMnozZadan = 0 .and. empty(kusov->ccisZakaz)), KusTree->nCiMno * nCiMnoNas, kusov->nmnozZadan )

         *
         KusTree->nspMno_J   := Kusov->nSpMno
         KusTree->nciMno_J   := Kusov->nCiMno

         KusTree->nCenaCelk  := KusTree->nSpMnoNas * ( CenZboz->nCenasZbo + VYR_PrirazkaCMP( 'CenZboz->nCenasZbo'))
         KusTree->nCenaCelk2 := KusTree->nSpMnoNas * CenZboz->nCenanZbo
         KusTree->nCenaCelk3 := KusTree->nSpMnoNas * CenZboz->nCenCNZbo
         * Objednací cena z DodZBOZ
         KusTree->nCenaCelk4 := DodZb_CENA()
         * Pøedbìžná skl. cena (nabídková) - HYDRAP
         KusTree->nCenaCelk5 := NabVYS_CENA( fromNabVys)  // Cena do nabídky vystavené
         KusTree->nSpMnSklHR := Kusov->nSpMnSklHR
         KusTree->nSpMnSklCI := Kusov->nSpMnSklCI
         * Indikace zapuštìní
         KusTREE->lZapusteno := ( Kusov->nCislPolOb > 0 )
         *
         KusTree->cZkratMENY := CenZboz->cZkratMENY
         KusTree->cTypMat    := NakPol->cTypMat
         KusTree->nCenaCelk6 := If( CenZboz->nCenanZbo <> 0,;
                                    KusTree->nCenaCelk2, KusTree->nCenaCelk3 )
         KusTree->cCisSklad  := CenZBOZ->cCisSklad
         KusTree->nUcetSkup  := CenZBOZ->nUcetSkup
         KusTree->nZboziKAT  := CenZBOZ->nZboziKAT

         KusTree->nmnozDzbo  := CenZBOZ->nmnozDzbo
         KusTree->nrozD_NAS  := KusTree->nmnozDzbo -KusTree->nSpMnoNas
         kusTree->nmnozZadan := if( ( kusov->nMnozZadan = 0 .and. empty(kusov->ccisZakaz)), nMnFinal, kusov->nmnozZadan )
         kusTree->nKUSOV     := kusov->sid
      EndIf
*      fOrdRec()

    Else       /* Vyrábìná položka  */
      KusTree->cTypPol    := VyrPol->cTypPol
      KusTree->cTreeText  := cTreeText + cZnak + AllTrim( Str( KusTree->nPozice, 3)) + ;
                                 DELIM + AllTrim( VyrPol->cVyrPol)+ DELIM + AllTrim( VyrPol->cNazev) + DELIM+ ;
                                                   StrZero( VyrPol->nVarCis, 3)
      lFound := VyrPol->( dbSeek( Upper( cCisZakaz) + Upper( Kusov->cVysPol) +StrZero( nVarPoz, 3)))
      If( !lFound, VyrPol->( dbSeek( Upper( cCisZakaz) + Upper( Kusov->cVysPol))), Nil )
      KusTree->nVysVar    := VyrPol->nVarCis
      KusTree->cVysVarPop := VyrPol->cVarPop
      KusTree->cNazevVys  := VyrPol->cNazev
      //-
      lFound := VyrPOL->( dbSEEK( Upper( cCisZakaz) + Upper( KusTREE->cVyrPol) +StrZero( nVarPoz, 3)))
      IF( !lFound, VyrPOL->( dbSEEK( Upper( cCisZakaz) + Upper( KusTREE->cVyrPol))), Nil )
      KusTree->lNakPOL    := POLOTOV()
      KusTree->nEkDav     := VyrPol->nEkDav
      CisSKLAD()

      cKy := upper(kusTree->ccisSklad) +upper(kusTree->csklPol)
      cenZboz->( dbSeek( cKy,, 'CENIK03'))
      KusTree->nmnozDzbo  := CenZBOZ->nmnozDzbo
      KusTree->nrozD_NAS  := KusTree->nmnozDzbo -KusTree->nSpMnoNas
      kusTree->nmnozZadan := if( ( kusov->nMnozZadan = 0 .and. empty(kusov->ccisZakaz)), nMnFinal, kusov->nmnozZadan )
      kusTree->nVYRPOL    := vyrPol->sid
      kusTree->nKUSOV     := kusov->sid
    EndIf

  EndIf

EndSequence

RETURN( lAppend)

*
*===============================================================================
STATIC FUNCTION POLOTOV()
  Local lNakPOL

  IF( Used('C_TypPOL'), NIL, drgDBMS:open('C_TypPOL'))
  C_TypPOL->( dbSEEK( Upper( VyrPOL->cTypPOL),, 'TYPPOL1'))
  lNakPOL := ( UPPER( ALLTRIM( C_TypPOL->cKodPRG)) == 'P' )
RETURN lNakPOL

*
*===============================================================================
STATIC FUNCTION CisSKLAD()

  IF( Used('CenZBOZ'), NIL, drgDBMS:open('CenZBOZ'))
  CenZBOZ->( dbSEEK( Upper( KusTREE->cSklPOL),, 'CENIK01'))
  KusTREE->cCisSKLAD := CenZBOZ->cCisSklad
  KusTREE->nUcetSkup := CenZBOZ->nUcetSkup
RETURN NIL

*
*===============================================================================
STATIC FUNCTION DodZb_CENA()
  Local nCENA, nAREA := SELECT()

  IF VYR_IsCZK( DodZboz->cZkratMENY)
    nCENA := KusTree->nSpMnoNas * DodZBOZ->nCenaOZBO
  ELSE
    nCENA := KusTree->nSpMnoNas * ;
             VYR_MenaToMENA( DodZBOZ->nCenaOZBO, DodZboz->cZkratMENY, 'CZK' )
    dbSelectAREA( nAREA)
  ENDIF
RETURN nCENA

*  Cena pro nabídku vystavenou
*===============================================================================
FUNCTION NabVYS_CENA( fromNabVys)
  Local nCena := 0, nAREA := SELECT()
  local cZkrMat := CenZBOZ->cZkrMat, dDatOdes
  *
  ** obèas to sem vleze, ale není k dispozíci soubor nabVyshdW
  ** podmínka pro fromNabVys je pokaždé jiná, asi se to nedodìlalo
  *
  if ( fromNabVys .and. select('nabVyshdW') <> 0 )

    drgDBMS:open('C_MatPOL' )
    dDatOdes := Nabvyshdw->dDatOdes
    if c_MatPOL->( dbSeek( Upper(CenZBOZ->cZkrMat),, 'C_MATPOL1'))
      if .not. empty(c_MatPOL->mBlockNAV)
        nCena := Eval( &("{||" + alltrim( c_MatPOL->mBlockNAV)+ "}"))
*      else
*        nCena := CenaMAT( cZkrMat, dDatOdes )
*        nCena := nCena * KusTree->nSpMnoNas
      endif
    endif
  endif

RETURN nCena

*===============================================================================
FUNCTION CenaMAT( cZkrMAT, dDatOdes )
  local nCena := 0, cKey := UPPER(cZkrMAT)

  drgDBMS:open('CenaMAT' )
  CenaMAT->(AdsSetOrder('CENAMAT03'),dbsetscope(SCOPE_BOTH,cKey),dbgotop())
  do while ! CenaMAT->( eof())
    nCena := if( dDatOdes > CenaMAT->dDatum, CenaMAT->nCenCNmat, nCena )
    CenaMAT->( dbSkip())
  enddo
RETURN nCena

*===============================================================================
FUNCTION NAV_Hydrap( cZkrMat)
  local nCena := 0, nCenaMAT := 0, nCenaODP := 0, cKey
*  local cZkrMat := CenZBOZ->cZkrMat, dDatOdes := Nabvyshdw->dDatOdes
  local dDatOdes := Nabvyshdw->dDatOdes
  local nProcOdp_1 := Kusov->nProcOdp_1

  * 1. napozicovat C_MatPOL na pøíslušný cZkrMat ( c_MatPOL->( dbSeek( CenZBOZ->cZkrMat)))
  * 2. V C_MatPOL bude existovat výkonný blok, který se provede
  * 3. Tento blok bude obsahovat mech. zjištìní ceny v souboru CenaMAT ( viz. fce CenaMAT() )
  nCena := CenaMAT( CenZBOZ->cZkrMat, dDatOdes )
  * 4. Tato zjištìná cena bude spolu s % odpadu ( Kusov->nProcOdp_1) vstupním parametrem
  * pro výpoèet ceny
  KusTree->nCenMAT_MJ := nCena
  Do Case
  case cZkrMat = 'CuZn'
    nCena := Hydrap_mosaz( nCena, nProcOdp_1)

*  case cZkrMat = 'Fe'
  otherwise
    nCenaMAT := nCena * KUSOV->nSpMnSklHR   //KusTree->nSpMnoNas
    if KUSOV->nMnozOdp_1 > 0
      drgDBMS:open('CENZBOZ',,,,, 'CenZBOZa' )
      cKey := Upper( KUSOV->cSklOdp_1) + Upper( KUSOV->cPolOdp_1)
      CenZBOZa->( dbSeek( cKey,,'CENIK03'))
      nCenaODP := CenaMAT( CenZBOZa->cZkrMat, dDatOdes ) * KUSOV->nMnozOdp_1

    endif
*    nCena = nCenaMAT - nCenaODP
    nCena := nCenaMAT

*  case cZkrMat = 'CuAl'
  endcase

return nCena

*-------------------------------------------------------------------------------
FUNCTION Hydrap_mosaz( nCena, nProcOdp_1)
  local nHmot := 0, ncenacelk := 0, njedncen, x1, x2, x3, n, aa := {}

  x1 := nCena  //125      // cena materiálu
  x2 := 15                // cena za opracování odpadu
  x3 := nProcOdp_1 //45   // procento odpadu
  *
  for n := 1 to 11
    aadd( aa, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } )
  next
  *
  aa[ 1,1] := 1000
  aa[ 2,1] := x1
  aa[ 3,1] := aa[1,1]*aa[2,1]

  aa[ 4,1] := x3
  aa[ 5,1] := ( aa[1,1] / 100 ) * aa[4,1]
  aa[ 6,1] := aa[5,1] * 0.13
  aa[ 7,1] := aa[5,1] - aa[6,1]

  aa[ 8,1] := 85
  aa[ 9,1] := 15
  aa[10,1] := ( aa[ 8,1] + aa[ 9,1]) * aa[ 7,1]
  aa[11,1] := aa[10,1] / aa[ 7,1]

  for n := 2 to 10
    aa[ 1,n] := aa[7,n-1]
    aa[ 2,n] := x2
    aa[ 3,n] := ( aa[1,n] * aa[2,n])

    aa[ 4,n] := aa[ 4,1]
    aa[ 5,n] := ( aa[1,n] / 100 ) * aa[4,n]
    aa[ 6,n] := ( aa[5,n] * 0.13 )
    aa[ 7,n] := ( aa[5,n] - aa[6,n ] )

    aa[ 8,n] := 0
    aa[ 9,n] := aa[ 9,1]
    aa[10,n] := ( aa[ 8,n] + aa[ 9,n] ) * aa[ 7,n]
    aa[11,n] := ( aa[10,n] / aa[ 7,n] )
  next

  for n := 1 to 10
    nHmot     += aa[ 1,n]
    ncenacelk += aa[ 3,n]
  next
  *
  ncenacelk += aa[10,1]
  njedncen  :=  ncenacelk/nhmot

return njedncen

* Zjištìní poètu pozic v dané rozpisce.
*===============================================================================
STATIC FUNCTION CountOfPoz()
  Local nCount := 0
  Local nPozice := 0, nNewPozice, lZakPoz := .f.

  nPozice := Kusov->nPozice
  Do While !Kusov->( Eof())
    If Kusov->nVarPoz == nVarPoz   ; nCount++
                                                                                                                                                 lZakPoz := .F.
    ElseIf Kusov->nVarPoz == 1     ; lZakPoz := .T.
    Endif
    Kusov->( dbSkip())
    If Kusov->nPozice <> nPozice
       nPozice := Kusov->nPozice
       nCount  += If( lZakPoz, 1, 0 )
       lZakPoz := .F.
     Endif
  EndDo
  Kusov->( dbGoTop())
Return( nCount)

* Vrátí nastavení pozice varianty
*===============================================================================
FUNCTION GetVarPos()
RETURN nVarPoz