//ÄÄÄÄÄÄÄÄÄÄÄÄDOCHµZKA ze sn¡maŸe U PRACOVNÖKAÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
# Include  '..\DOCHDef_.Ch'

# xTranslate  REG_xSCo(<N>,<T>,<X> [,<lCLR>] [,<lSHA>]) => ;
                    ( REG_File(<N>) ->( OrdSetFocus(<T>)    , ;
                                 Sx_SetScope( 0, <X>), ;
                                 Sx_SetScope( 1, <X>), ;
                                 REG_GTop(<N>)       , ;
                                 REG_Rest(<N>, .T. [,<lCLR>] [,<lSHA>] )))

# xTranslate  SET_xSCo(<T>,<X>) => ( OrdSetFocus(<T>)    , ;
                                     Sx_SetScope( 0, <X>), ;
                                     Sx_SetScope( 1, <X>), ;
                                     dbGoTop())

Static  nDAY_doch, nDNY_fond
Static  cKEY_prac
Static  dAKT_den, nAKT_tyden
Static  aKAL_den, aKAL_tyden, aKAL_mesic, pA[3], paPRERUs
Static  vKAL_den, vKAL_tyden, vKAL_mesic
Static  dKAL_den, dKAL_tyden, dKAL_mesic, paFOND


FUNCTION DOCHAZ_scr(nSCRs)
  Local  cKEy¨

  If SCREENarea() == 1
    If nSCRs == 2
      cKEy := STRZERO( MSPRC_md ->nOScisPRAC) +ACT_OBDn() +'01'
      DSPOHYBY ->( SET_xSCo( 9, cKEy))
    ElseIf nSCRs == 3
      cKEy := STRZERO( MSPRC_md ->nOScisPRAC) +CS_UPPER( ACTobdobi())
      LISTIT ->( Set_Scope( cKEy))
    EndIf
  EndIf

Return(.T.)


FUNCTION Dochaz_GET( nMOD)
  Local  nKEy, nCURrow, nNEWrow, nCURcol, nCOLUMn, nCURSOR := SETCURSOR(0)
  Local  nROK  := ACT_OBDyn(), nMES := ACT_OBDon()
  Local  lDONe := .T., nACTIVe := 0 // 0-kalendar,1-DSPOHYBY,2-LISTIT,3-d_SUMTMP
  LOCAL  nOldError := DosError( 2001)
  LOCAL  cC, cScreen := SaveScreen()
  Local  acHOTs
  LOCAL  axEdit, GetList := {}, paSETs
  LOCAL  lNewREC
  LOCAL  nTypOPR := SysConfig("Dochazka:nTypOpravn")
  LOCAL  acKODprer, cKODprer := ''

  paSETs    := { DSPOHYBY ->( ORDsetFOCUS()), DSPOHYBY ->( SX_SETSCOPE()) }
  nDAY_doch := MAX( 1, DSPOHYBY ->nDEN )

  DC_DcOPEN( { 'c_SVATKY,3', 'c_PRERUS,3', 'c_PRACSM,1'  ;
                   , 'c_PRACDO,1', 'c_INFSUM,3', 'c_OPRAKT,1' } )

  d_SUMTMP ->( ORDsetFOCUS(1),  __dbZAP(), sx_KILLTAG(.T.))
  dbSELECTAREA( 'd_SUMTMP' )
  INDEX on d_SUMTMP ->nPORADI TAG d_SUM_1

  c_INFSUM ->( dbEVAL( { || MH_COPYFLD( 'c_INFSUM', 'd_SUMTMP', .T.) }))
  d_SUMTMP ->( dbGOTOP())

  lNewREC  := ( nMOD == K_INS)

  IF nTypOPR > 0
    IF C_OPRAKT ->( dbSeek( nTypOPR))
      acKODprer := IF( IsARRAY( C_OPRAKT->acKODprer), C_OPRAKT->acKODprer, {} )
      aEVAL( acKODprer, { |X| cKODprer += X +',' } )
    ENDIF
  ENDIF

  paPRERUs := {}
  c_PRERUS ->( dbEVAL( { || IF( IF( nTYPopr > 0,                             ;
                            At( c_PRERUS ->cKODPRER, cKODprer) > 0 , .T.) ,  ;
                                   ( aADD( paPRERUs, ;
                              { '~'+c_PRERUS->cKODPRER+'º'+c_PRERUS->cNAZPRER,;
                                c_PRERUS ->nMASKinp , ;
                                c_PRERUS ->nMASKout , ;
                                c_PRERUS ->( RECNO()) } )), NIL)} ))

  cKEY_prac := STRZERO( MsPrc_Md ->nOScisPRAC) +ACT_OBDn()
  c_PRACDO ->( dbSEEK( CS_UPPER( MSPRC_md ->cDELKprDOB)))
  c_PRACSM ->( dbSEEK( CS_UPPER( MSPRC_MD ->cTYPsmeny)))

  Cards_RES( 'DOCHAZKa.Sc1', .T., .F., .T. )
  axEdit := Cards ->axCards

  MH_INITSCREEN( {1,2,3}, CARDS ->axBRO_1, pA, .T. )

  For nCOLUMn := 1 TO pA[1]:COLCOUNT() STEP 1
    pA[1]:GETCOLUMN(nCOLUMn):COLORBLOCK:={|X|If(DSPOHYBY->nSAYcrd= 1,{1,2},{7,8})}
  Next
  ( pA[3]:GETCOLUMN(2):COLSEP := '->', pA[3]:GETCOLUMN(3):COLSEP := '  ', ;
    pA[3]:GETCOLUMN(4):COLSEP := '/' , pA[3]:GETCOLUMN(5):COLSEP := '  ', ;
    pA[3]:GETCOLUMN(6):COLSEP := '/' )

  For nCOLUMN := 2 To 6 STEP 2
    pA[3]:GETCOLUMN(nCOLUMn):COLORBLOCK := { |X| If( X == 0, {7,8}, {9,1} ) }
  Next
  pA[3]:GETCOLUMN(3):COLORBLOCK := { |X| If( X == 0, {7,8}, {1,2} ) }
  pA[3]:GETCOLUMN(5):COLORBLOCK := { |X| If( X == 0, {7,8}, {1,2} ) }

//ÄÄÄÄÄÄÄÙBRO FOR d_SUMTMP

  DSPOHYBY ->( dbSETRELATION( 'c_PRERUS', { || DSPOHYBY ->nKODPRER }, ;
                                  'DSPOHYBY ->nKORPRER'   ))

  acHOTs := pA[1]:CARGO.Vs_cHotKeys
  DOCH_kal()
  paFOND := { c_PRACDO ->nHODden  , ;
              c_PRACDO ->nDNYtyden, c_PRACDO ->nHODtyden, ;
              DOCH_fond('DNY')    , DOCH_fond('HOD')      }
  CARDs_DIS( axEDIT,, .T. )

  Do While lDONe
    dAKT_den   := CTOD( STRZERO(nDAY_doch,2) +'.' +STRTRAN( ACT_OBDnc(), '/', '.'))
    nAKT_tyden := WOM( dAKT_den )

    BOX_DISPHOTKEYs( acHOTs[ IF( nACTIVe == 1, 2, 1)])
    @ MAXROW(),        0 SAY 'Ê' COLOR 'W+/W'
    @ MAXROW(), MAXCOL() SAY 'º' COLOR 'W+/W'

    aEVAL( aKAL_den, { |X,M|                                                 ;
                ( DISPOUTAT(X[1],X[2]-1,If(nDAY_doch == M,'•',' '), 'W+/W'), ;
                  DISPOUTAT(X[1],X[2]+2,If(nDAY_doch == M,'',' '), 'W+/W')) })

    If nACTIVe == 0
      aEVAL( aKAL_den  , { |X| ( X[5] := 0, X[6] := 0 ) })
      aEVAL( aKAL_tyden, { |X| ( X[2] := 0, X[3] := 0 ) })
      ( aKAL_mesic[1] := 0, aKAL_mesic[2] := 0 )
      aEVAL( vKAL_den  , { |X| ( X[5] := 0, X[6] := 0 ) })
      aEVAL( vKAL_tyden, { |X| ( X[2] := 0, X[3] := 0 ) })
      ( vKAL_mesic[1] := 0, vKAL_mesic[2] := 0 )

      aEVAL( dKAL_den  , { |X| ( X[5] := 0, X[6] := 0 ) })
      aEVAL( dKAL_tyden, { |X| ( X[2] := 0, X[3] := 0 ) })
      ( dKAL_mesic[1] := 0, dKAL_mesic[2] := 0 )

      d_SUMTMP ->( dbEVAL( { || ( d_SUMTMP ->nHOD_den   := 0, ;
                                    d_SUMTMP ->nDNY_tyden := 0, ;
                                     d_SUMTMP ->nHOD_tyden := 0, ;
                                    d_SUMTMP ->nDNY_mesic := 0, ;
                                  d_SUMTMP ->nHOD_mesic := 0  ) }), ;
                                      dbGOTOP()                           )
      DOCH_sum()

      REG_xSCo( 1, 10, cKEY_prac +STRZERO( nDAY_doch, 2), .F., .F. )
      REG_xSCo( 2, 9, cKEY_prac +STRZERO( nDAY_doch, 2), .F., .F. )
      REG_Rest( 3, .T., .F. )
    EndIf
    DOCH_inf()

    nKEy := InKEY(0)

    Do Case
    Case( nKEY == K_TAB .or. nKEY == K_SH_TAB )
      If( nACTIVe > 0, REG_Rest( nACTIVe, .T., .F. ), NIL )
      nACTIVe := If( nKEy == K_TAB, If( nACTIVe +1 > 3, 0, nACTIVe +1), ;
                                      If( nACTIVe -1 < 0, 3, nACTIVe -1)  )
                                If( nACTIVe > 0,REG_Rest( nACTIVe,.T.,.T.),NIL)
    Case( nKEY == K_ESC .and. nACTIVe <> 0 )
      ( nACTIVe := 0, nKEy := 0 )

// KALENDµü
    Case( nACTIVe == 0 .and. nKEY == K_ENTER )
      ( nACTIVe := 1, REG_Rest( nACTIVe, .T., .T.) )

    Case( nACTIVE == 0 .and. nKEy == K_RIGHT )
      If( nDAY_doch +1 <= LEN( aKAL_den), nDAY_doch++, nDAY_doch := 1 )

    Case( nACTIVe == 0 .and. nKEy == K_LEFT  )
      If( nDAY_doch -1 >= 1, nDAY_doch--, nDAY_doch := LEN( aKAL_den) )

    Case( nACTIVE == 0 .and. ( nKEy == K_UP .or. nKEy == K_DOWN) )
      nCURrow := aKAL_den[ nDAY_doch, 1] +If( nKEy == K_UP, -1, +1)
      nCURcol := aKAL_den[ nDAY_doch, 2]
      If( nNEWrow := aSCAN(aKAL_den,{|X|X[1]=nCURrow .and. X[2]=nCURcol })) <> 0
      nDAY_doch := nNEWrow
    EndIf

// DSPOHYBY MODIFIKACE
    Case( nACTIVe == 1 .and. nKEy == K_ENTER )
      If( REG_RLock(1),(DOCH_edt( nKEy), REG_UnLock(1), nKEy := K_LEFT), NIL )

    Case( nACTIVe == 1 .and. nKEy == K_INS   )
      DSPOHYBY ->( dbAPPEND())
      DSPOHYBY ->nROK    := ACT_OBDyn()
      DSPOHYBY ->nMESIC  := ACT_OBDon()
      DSPOHYBY ->nDEN    := nDAY_doch
      DSPOHYBY ->cOBDOBI := ACTObdobi()
      DSPOHYBY ->nOBDOBI := ACT_OBDon()
      DSPOHYBY ->nGENREC := 2
      DSPOHYBY ->nOsCisPrac := MSPRC_md ->nOsCisPrac
      DSPOHYBY ->cKmenStrPr := MSPRC_md ->cKmenStrPr
      DSPOHYBY ->cIdOsKarty := MSPRC_md ->cIdOsKarty
      DSPOHYBY ->cRodCisPra := MSPRC_md ->cRodCisPra
      DSPOHYBY ->cNazPol4   := MSPRC_md ->cNazPol4

      If( REG_RLock(1), (DOCH_edt( nKEy), REG_UnLock(1), nKEy := K_LEFT ), NIL)
    Case( nACTIVe == 1 .and. nKEy == K_DEL   )
      If BOX_YESNO( 'Zrušit POLOŽKU pohybu ...') == 1
        If( REG_RLock(1), ( REG_DRec(1), REG_UnLock(1)), NIL )
      EndIf
    EndCase

    If( nACTIVe == 0, NIL, REG_Meth( nKEy, nACTIVe, .T. ))
    lDONe := ( lDONe .and. nKEy <> K_ESC )
  EndDo

  DSPOHYBY ->( dbCLEARREL())
  ( DosError( nOldError), RestScreen( ,,,, cScreen), SetCursor( nCursor) )


  DSPOHYBY ->( ORDsetFOCUS( paSETs[1]))
  DSPOHYBY ->( SX_SETSCOPE( 0, paSETs[2]))
  DSPOHYBY ->( SX_SETSCOPE( 1, paSETs[2]))

RETURN( NIL)


Function DOCH_fond( cTYP)                        //Äzobrazen¡ FONDU_PDÄÄÄÄÄÄÄÄ
  Local nVAL := 0

  If     cTYP == 'DNY'  ;  nVAL := nDNY_fond
  ElseIf cTYP == 'HOD'  ;  nVAL := nDNY_fond * c_PRACDO ->nHODden
  EndIf

Return( nVAL)


Static Function DOCH_kal()
  Local  nPOs, nFS_row := 5, nFS_col := 4
  Local  nFS_day, nLS_day
  Local  dFs_day := CTOD( '01.' +STRTRAN( ACT_OBDnc(), '/', '.'))
  Local  cFS_day := UPPER( LEFT( CDOW( dFS_day), 2))
  Local  cOB_ym  := ACT_OBDn()
  Local  cCLRs
  Local  aDAY    := { 'PO', 'éT', 'ST', '¬T', 'Pµ', 'SO', 'NE' }

  nDNY_fond := 0
  ( aKAL_den := {}, aKAL_tyden := {}, aKAL_mesic := { 0, 0.00 }, ;
    vKAL_den := {}, vKAL_tyden := {}, vKAL_mesic := { 0, 0.00 }, ;
    dKAL_den := {}, dKAL_tyden := {}, dKAL_mesic := { 0, 0.00 }  )

  nFS_day   := aSCAN( aDAY, cFS_day )
  nFS_col   := If( nFS_day <> 1, nFS_col +( nFS_day -1) * 4, nFS_col )
  nLS_day   := LASTDAYOM( dFs_day)

  aADD( aKAL_tyden, { nFS_row, 0, 0.00 } )
  aADD( vKAL_tyden, { nFS_row, 0, 0.00 } )
  aADD( dKAL_tyden, { nFS_row, 0, 0.00 } )

  For nPOs := 1 To nLS_day STEP 1
    cFS_day := UPPER( LEFT( CDOW( dFS_day +nPOs -1), 2))
    If c_SVATKY ->( dbSEEK( cOB_ym +STRZERO( nPOs, 2)))
    cCLRs := 'N+/W*'
    If( cFS_day <> 'SO' .AND. cFS_day <> 'NE', nDNY_fond++, NIL)
    Else
      cCLRs := If( cFS_day == 'SO' .or. cFS_day == 'NE', 'R+/BG*', 'N+/BG')
      If( cCLRs == 'R+/BG*', NIL, nDNY_fond++ )
    EndIf

    @ nFS_row, nFS_col SAY STR( nPOs, 2) COLOR cCLRs

    aADD( aKAL_den, { nFS_row, nFS_col, STR( nPOs, 2), cCLRs, 0, 0.00 })
    aADD( vKAL_den, { nFS_row, nFS_col, STR( nPOs, 2), cCLRs, 0, 0.00 })
    aADD( dKAL_den, { nFS_row, nFS_col, STR( nPOs, 2), cCLRs, 0, 0.00 })

    If( nFS_col +4 > LEN( aDAY) *4, ;
        ( nFS_row++, nFS_col := 4, aADD( aKAL_tyden, { nFS_row, 0, 0.00 }), ;
        aADD( vKAL_tyden, { nFS_row, 0, 0.00 }), ;
        aADD( dKAL_tyden, { nFS_row, 0, 0.00 })  ), ;
        nFS_col += 4 )
  Next
Return( Nil)


Static Function DOCH_sum()
  Local  nREC_po := DSPOHYBY ->( RECNO())
  Local  nREC_li := LISTIT   ->( RECNO())
  Local  nTYDEn, nDEN, nNAPprer, nSUMfond, nSTEPs, nKODprer
  Local  lNAP_den, lNAP_hod, nDENtm
  Local  anKODprer

  DSPOHYBY ->( Set_Scope( cKEY_prac))
   Do While !DSPOHYBY ->( EOF())
     nNAPprer  := c_PRERUS ->nNAPprer
     nSUMfond  := c_PRERUS ->nSUMfond
     lNAP_den  := nNAPprer == 1 .OR. nNAPprer == 3
     lNAP_hod  := ( nNAPprer == 1 .OR. nNAPprer == 2 .OR. nNAPprer == 3 )
     d_SUMTMP ->( dbGOTOP())

     Do While !d_SUMTMP ->( EOF())
       If aSCAN( d_SUMTMP ->anKODprer, DSPOHYBY ->nKODprer ) <> 0
         If DSPOHYBY ->dDATUM == dAKT_den
           If( lNAP_hod, d_SUMTMP ->nHOD_den += DSPOHYBY ->nCAScelCPD, NIL )
         EndIf
         If WOM( DSPOHYBY ->dDATUM) == nAKT_tyden
           If lNAP_den
             IF d_SUMTMP ->nDNY_tyden + 1 <= 9
               IF nNAPprer = 3
                 d_SUMTMP->nDNY_tyden += MH_RoundNumb(DSPOHYBY->nCAScelCPD/paFOND[1], 212)
               ELSE
                 d_SUMTMP->nDNY_tyden += 1
               ENDIF
             ENDIF
           ENDIF
           If( lNAP_hod, d_SUMTMP ->nHOD_tyden += DSPOHYBY ->nCAScelCPD, NIL )
         EndIf

         IF lNAP_den
           IF nNAPprer = 3
             d_SUMTMP->nDNY_mesic += MH_RoundNumb(DSPOHYBY->nCAScelCPD/paFOND[1], 212)
           ELSE
             d_SUMTMP->nDNY_mesic += 1
           ENDIF
         ENDIF

         If( lNAP_hod, d_SUMTMP ->nHOD_mesic += DSPOHYBY ->nCAScelCPD, NIL )
       EndIf
       d_SUMTMP ->( dbSKIP())
     EndDo

     If c_PRERUS ->nSUMfond == 1
       nTYDEn := WOM( DSPOHYBY ->dDATUM)
       IF nNAPprer = 3
         nDENtm := MH_RoundNumb( DSPOHYBY ->nCAScelCPD/paFOND[1], 212)
         dKAL_den[ DSPOHYBY ->nDEN, 5] += nDENtm
         dKAL_tyden[ nTYDEn, 2]        += nDENtm
         dKAL_mesic[ 1]                += nDENtm
       ELSE
         dKAL_den[ DSPOHYBY ->nDEN, 5] += 1
         dKAL_tyden[ nTYDEn, 2]        += 1
         dKAL_mesic[ 1]                += 1
       ENDIF
       dKAL_den[ DSPOHYBY ->nDEN, 6] += DSPOHYBY ->nCAScelCPD
       dKAL_tyden[ nTYDEn, 3]        += DSPOHYBY ->nCAScelCPD
       dKAL_mesic[ 2]                += DSPOHYBY ->nCAScelCPD
     EndIf

     If c_PRERUS ->nSUMvyr == 1
      nTYDEn := WOM( DSPOHYBY ->dDATUM)
      IF nNAPprer = 3
        aKAL_den[ DSPOHYBY ->nDEN, 5] += IF( DSPOHYBY ->nCAScelCPD > 4, 1, 0.5)
        aKAL_tyden[ nTYDEn, 2]        += IF( DSPOHYBY ->nCAScelCPD > 4, 1, 0.5)
        aKAL_mesic[ 1]                += IF( DSPOHYBY ->nCAScelCPD > 4, 1, 0.5)
      ELSE
        aKAL_den[ DSPOHYBY ->nDEN, 5] += 1
        aKAL_tyden[ nTYDEn, 2]        += 1
        aKAL_mesic[ 1]                += 1
      ENDIF
      aKAL_den[ DSPOHYBY ->nDEN, 6] += DSPOHYBY ->nCAScelCPD
      aKAL_tyden[ nTYDEn, 3]        += DSPOHYBY ->nCAScelCPD
      aKAL_mesic[ 2]                += DSPOHYBY ->nCAScelCPD
    EndIf
    DSPOHYBY ->( dbSKIP())
  EndDo
 DSPOHYBY ->( Clr_Scope(), dbGOTO( nREC_po))

 LISTIT ->( Set_Scope( cKEY_prac))
  Do While !LISTIT ->( EOF())
    nDEN := VAL( LEFT( DTOC( LISTIT ->dVYHOTskut), 2 ))
    vKAL_den[ nDEN, 5] += 1
    vKAL_den[ nDEN, 6] += LISTIT ->nNHnaOPEsk

    nTYDEn := WOM( LISTIT ->dVYHOTskut)
    vKAL_tyden[ nTYDEn, 2] += 1
    vKAL_tyden[ nTYDEn, 3] += LISTIT ->nNHnaOPEsk

    vKAL_mesic[ 1] += 1
    vKAL_mesic[ 2] += LISTIT ->nNHnaOPEsk

    LISTIT ->( dbSKIP())
  EndDo
 LISTIT ->( Clr_Scope(), dbGOTO( nREC_li))

 d_SUMTMP ->( dbGOTOP())

Return( Nil)


Static Function DOCH_inf()
  Local  nPOs, nITM, nTYDEn, nVAL
  Local  cITM
  Local  dDAY  := CTOD(STRZERO(nDAY_doch,2)+'.'+STRTRAN( ACT_OBDnc(), '/', '.'))
  Local  axEDT := CARDs ->axBRO_2, aITM, xITM

  For nPOs := 1 To LEN( axEDT) STEP 1
    aITM  := axEDT[nPOs]
    cITM  := aITM [5]

    Do Case
    Case( cITM == 'MONTH' )
      aITM.Value := LOWER( NTOCMONTH( MONTH( dDAY )))
    Case( cITM == 'YEAR' )  ;  aITM.Value := YEAR( dDAY )
    Case( cITM == 'DAY'  )  ;  aITM.Value := dDAY
    Otherwise
      If 'aKAL_den' $ cITM
        nITM := If(  TOKEN( cITM, ',') == 'DNY', 5, 6 )
        aITM.Value := aKAL_den[ nDAY_doch, nITM]
        @ aITM.Row, aITM.Col SAY aITM.Value PICTURE aITM.Picture COLOR 'N/W'

      ElseIf 'vKAL_den'   $ cITM
        nITM  := If(  TOKEN( cITM, ',') == 'DNY', 5, 6 )
        aITM.Value := vKAL_den[ nDAY_doch, nITM]
        If (aKAL_den[nDAY_doch,6] -vKAL_den[nDAY_doch,6]) <> 0
          @ 21, 55 SAY (aKAL_den[nDAY_doch,6] -vKAL_den[nDAY_doch,6]) PICTURE '999.99' COLOR 'GR+/W'
        Else
            @ 21, 55 SAY '      ' COLOR 'W/W'
        EndIf

      ElseIf 'aKAL_tyden' $ cITM
        xITM   := LISTasARRAY( cITM, ',' )
        nITM   := If ( 'DNY' $ xITM[2], 2, 3 )
        nTYDEn := WOM( dAKT_den )
        aITM.Value := aKAL_tyden[ nTYDEn, nITM]
        @ aITM.Row, aITM.Col SAY aITM.Value PICTURE aITM.Picture COLOR 'N/W'

      ElseIf 'vKAL_tyden' $ cITM
        xITM   := LISTasARRAY( cITM, ',' )
        nITM   := If ( 'DNY' $ xITM[2], 2, 3 )
        nTYDEn := WOM( dAKT_den )
        aITM.Value := vKAL_tyden[ nTYDEn, nITM]
        If (aKAL_tyden[nTYDEn,3] -vKAL_tyden[nTYDEn,3]) <> 0
          @ 21, 61 SAY (aKAL_tyden[nTYDEn,3] -vKAL_tyden[nTYDEn,3]) PICTURE '9999.99' COLOR 'GR+/W'
        Else
            @ 21, 61 SAY '       ' COLOR 'W/W'
        EndIf
      ElseIf 'dKAL_tyden' $ cITM
        xITM   := LISTasARRAY( cITM, ',' )
        nITM   := If ( 'DNY' $ xITM[2], 2, 3 )
        nTYDEn := WOM( dAKT_den )
        aITM.Value := dKAL_tyden[ nTYDEn, nITM]
        If( nVAL := (paFOND[If( nITM == 2, 2, 3)] -dKAL_tyden[nTYDEn,3])) <> 0
          @ aITM.Row, aITM.Col SAY nVAL PICTURE aITM.Picture COLOR 'N/W'
        Else
             @ aITM.Row, aITM.Col SAY SPACE( LEN( aITM.Picture)) COLOR 'W/W'
        EndIf

      ElseIf 'aKAL_mesic' $ cITM
        nITM := If(  TOKEN( cITM, ',') == 'DNY', 1, 2 )
        aITM.Value := aKAL_mesic[ nITM]
        @ aITM.Row, aITM.Col SAY aITM.Value PICTURE aITM.Picture COLOR 'N/W'

      ElseIf 'vKAL_mesic' $ cITM
        nITM := If(  TOKEN( cITM, ',') == 'DNY', 1, 2 )
        aITM.Value := vKAL_mesic[ nITM]
        If (aKAL_mesic[2] -vKAL_mesic[2]) <> 0
          @ 21, 69 SAY (aKAL_mesic[2] -vKAL_mesic[2]) PICTURE '9999.99' COLOR 'GR+/W'
        Else
             @ 21, 69 SAY '       ' COLOR 'W/W'
        EndIf
      ElseIf 'dKAL_mesic' $ cITM
        xITM   := LISTasARRAY( cITM, ',' )
        nITM   := If ( 'DNY' $ xITM[2], 1, 2 )
        aITM.Value := dKAL_mesic[ nITM]

        If( nVAL := ( dKAL_mesic[nITM] -paFOND[If( nITM == 1, 4, 5)])) <> 0
          @ aITM.Row, aITM.Col SAY nVAL PICTURE aITM.Picture COLOR 'GR+/W'
        Else
          @ aITM.Row, aITM.Col SAY SPACE( LEN( aITM.Picture)) COLOR 'W/W'
        EndIf
      EndIf
    EndCase
  Next

Return( Nil)


Static Function DOCH_edt(nKEy)
  Local  nPOs, nR
  Local  cKEYs
  Local  lNEw := ( nKEy == K_INS )
  Local  axEDTs
  Local  oBRO := pA[1], oCOL, oGET, GETLIST := {}

  ( pA[1]:COLPOS := 1, REG_Rest(1), nR := ROW() )
  axEDTs := oBRO:CARGO.Vs_cHotKeys[3]

  For nPOs := 1 To oBRO:COLCOUNT STEP 1
    If axEDTs[nPOs,2] <> 0
      oCOL := oBRO:GETCOLUMN(nPOs)
      oGET := GETNEW(nR,COL(),oCOL:BLOCK,oCOL:HEADING,axEDTs[nPOs,1],'B/BG,N/W*,B/W*' )
      If( axEDTs[nPOs,2] == 2, ;
        ( oGET:CARGO := nPOs, oGET:READER    := { || DOCH_dwn(GETLIST) }), ;
        ( oGET:CARGO := nPOs, oGET:POSTBLOCK := { || DOCH_vld() })  )
      aADD( GETLIST, oGET )
    EndIf
    ( oBRO:RIGHT(), oBRO:FORCESTABLE() )
  Next
  aEVAL( GETLIST, { |X| X:DISPLAY() })

  If READMODAL( GETLIST )
    DSPOHYBY ->dDATUM    := dAKT_den
    DSPOHYBY ->cZKRDNE   := LEFT( CDOW( dAKT_den), 2)
    DSPOHYBY ->nNAPpreR  := c_PRERUS ->nNAPpreR
    DSPOHYBY ->lIsMANUAL := .T.
    DsPohyby ->nNapPrer  := C_Prerus ->nNapPrer
    DsPohyby ->nSaySCR   := C_Prerus ->nSaySCR
    DsPohyby ->nSayCRD   := C_Prerus ->nSayCRD
    DsPohyby ->nPritPrac := C_Prerus ->nPritPrac

    WRT_zmena( 'DSPOHYBY', .F. )

    cKEYs := CS_UPPER(DSPOHYBY->cIdOsKarty) +STRZERO(DSPOHYBY->nROK ) ;
                +STRZERO(DSPOHYBY->nMESIC)+STRZERO(DSPOHYBY->nDen)
    REG_UnLock(1)

    MODICasy(cKEYs, 4)                              // IMP_TERM.prg
    (oBRO:REFRESHALL() )
  Else
    If( lNEw, REG_DRec(1), SX_ROLLBACK( SELECT( 'DSPOHYBY' )) )
  EndIf

Return( Nil)


Static Function DOCH_dwn(GETLIST)
  Local  nKEy, nSTEp := 1, nCURSOR := SETCURSOR(0), nCARDs, nT, nMASK
  Local  lDONe
  Local  aC := { 'N/BG*', 'R+/BG*', 'B/BG*' }, pSELs := {}
  Local  O  := GETACTIVE(), xVAL

  xVAL := O:VARGET()
  @ O:ROW, O:COL SAY xVAL COLOR 'N/W*'
  @ O:ROW, O:COL +LEN(xVAL) SAY 'Š' COLOR aC[nSTEp]

  If !EMPTY(xVAL)
    Do While( nKEy := INKEY(.3)) == 0
      If( nSTEp +1 > 3, nSTEp := 1, nSTEp++ )
    EndDo
  Else
    nKEy := K_ALT_DOWN
  EndIf

  If nKEy == K_ALT_DOWN
    If O:CARGO == 2
      aEVAL( paPRERUs, { |X| If( X[2] <> 0, aADD( pSELs, X ), NIL ) })
    Else
      aEVAL( paPRERUs, { |X| If( X[3] <> 0, aADD( pSELs, X ), NIL ) })
    EndIf

    nT := MAX( O:ROW -2 -LEN( pSELs), 6 )

    If( nCARDs := xCHOICE(pSELs,nT,O:COL()-1,O:ROW-1,,,,'N/BG,W+/B',,.F.)) <> 0
      c_PRERUS ->( dbGOTO( pSELs[nCARDs,4]))
      If O:CARGO == 2
        MH_COPYFLD( 'c_PRERUS', 'DSPOHYBY' )
        DSPOHYBY ->nKODPRER  := c_PRERUS ->nKODPRER
        DSPOHYBY ->cKODPRER  := c_PRERUS ->cKODPRER
        c_PRACSM ->( dbSEEK( CS_UPPER( MSPRC_MD ->cTYPsmeny)))
        nMASK := pSELs[nCARDs,2]

        Do Case
        Case( nMASK == 1 )
        Case( nMASK == 2 )
          DSPOHYBY ->cCASbeg := c_PRACSM ->cRANsmeZAC
          DSPOHYBY ->nCASbeg := TIMETOSEC( DSPOHYBY ->cCASbeg )/ 3600

        Case( nMASK == 3 )
          DSPOHYBY ->nKODPRERE  := c_PRERUS ->nKODPRER
          DSPOHYBY ->cKODPRERE  := c_PRERUS ->cKODPRER

        Case( nMASK == 4 )
          DSPOHYBY ->cCASbeg    := c_PRACSM ->cRANsmeZAC
          DSPOHYBY ->nCASbeg    := TIMETOSEC( DSPOHYBY ->cCASbeg )/ 3600
          DSPOHYBY ->nKODPRERE  := c_PRERUS ->nKODPRER
          DSPOHYBY ->cKODPRERE  := c_PRERUS ->cKODPRER
          DSPOHYBY ->cCASend    := c_PRACSM ->cRANsmeKON
          DSPOHYBY ->nCASend    := TIMETOSEC( DSPOHYBY ->cCASend )/ 3600
        EndCase
        aEVAL( GETLIST, {|X| X:DISPLAY() })
      Else
        DSPOHYBY ->nKODPRERE := c_PRERUS ->nKODPRER
        DSPOHYBY ->cKODPRERE := c_PRERUS ->cKODPRER
      EndIf
      GETapplyKEY( O, K_ENTER )
    EndIf
  Else
    GETapplyKEY( O, nKEy )
  EndIf

  @ O:ROW, O:COL +LEN(xVAL) SAY ' ' COLOR 'W/BG*'
  O:DISPLAY()
  SETCURSOR( nCURSOR)

Return( NIL )


Static Function DOCH_vld()
  Local  nCAS, nCAScel
  Local  lDONe := .T.
  Local  nOldREC, nOldTAG
  Local  O := GETACTIVE(), xCAS

  nCAS := VAL( STRTRAN( STRTRAN( O:VARGET(), ' ', '' ), ':', '.'))
  xCAS := STRTRAN( STRZERO( nCAS, 5, 2), '.', ':' )

  If ( nCAS < 0.00 .and. nCAS > 24.00 )
    ( BOX_AU(), lDONe := .F. )
  Else
    If O:CARGO == 3
      DSPOHYBY ->nCASbeg   := TIMETOSEC( xCAS )/3600
    Else
      DSPOHYBY ->nCASend   := TIMETOSEC( xCAS )/3600

      IF ( DSPOHYBY ->nCASbeg <> 0 .AND. DSPOHYBY ->nCASend <> 0);
                .OR. ( DSPOHYBY ->nCASbeg <> 0 .AND. xCAS == "24:00")    ;
             .OR. ( DSPOHYBY ->nCASend <> 0 .AND. xCAS == "24:00")
        nCAScel := DOCH_cas()
        DSPOHYBY ->nCAScel := nCAScel
        DSPOHYBY ->cCAScel := STRTRAN( STR( nCAScel, 5, 2), '.', ':' )
        nOldREC := c_PRERUS->( Recno())
        nOldTAG := c_PRERUS->( OrdSetFOCUS( 1))
        c_PRERUS->( dbSeek( Cs_Upper( DSPOHYBY ->cKodPrer)))
        DSPOHYBY->nCASbegPD:= MH_ROUNDnumb(DSPOHYBY->nCASbeg,c_PRERUS->nKODzaokr)
        c_PRERUS->( dbSeek( Cs_Upper( DSPOHYBY ->cKodPrerE)))
        DSPOHYBY->nCASendPD:= MH_ROUNDnumb(DSPOHYBY->nCASend,c_PRERUS->nKODzaokr)
        c_PRERUS->( OrdSetFOCUS( nOldTAG))
        c_PRERUS->( dbGoTo( nOldREC))
      ENDIF
    EndIf
  EndIf

  ( O:VARPUT( xCAS ), O:DISPLAY() )

Return( lDONe)


Function DOCH_cas( nBEG, nEND, cBEG, cEND)
  Local  cCasBeg, cCasEnd, cCasCel, cCasHod, cCasMin
  Local  nCasBeg, nCasEnd
  Local  nDaySec, nSecBeg, nSecEnd
  Local  nCasCel, nCasDes


  nCasBeg := IF( IsNIL( nBEG), DSPOHYBY ->nCASbeg, nBEG)
  nCasEnd := IF( IsNIL( nEND), DSPOHYBY ->nCASend, nEND)
  cCasBeg := IF( IsNIL( cBEG), DSPOHYBY ->cCASbeg, cBEG)
  cCasEnd := IF( IsNIL( cEND), DSPOHYBY ->cCASend, cEND)

  nDaySec := If( nCasEnd <> 0 .and. ( nCasBeg > nCasEnd), 86400, 0 )

  nSecBeg := TimeToSec( cCasBeg)
  nSecEnd := ( nDaySec +TimeToSec( cCasEnd))

  cCasCel := SecToTime( Abs( nSecEnd -nSecBeg) )

  cCasHod := SubStr( cCasCel, 1, 2)
  cCasMin := SubStr( cCasCel, 4, 2)

  nCasDes := Val( cCasMin)/60
  nCasCel := Val( cCasHod) +nCasDes

RETURN( Val( Transform( Val( cCasHod) +nCasDes, '99.99' )))