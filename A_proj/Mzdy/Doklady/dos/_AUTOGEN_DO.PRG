

STATIC FUNCTION GenRADEKdok( nDMZ, nDokl, nPOR, anFPD)
  LOCAL cFILE := "m_Dav"
  LOCAL lOK := .T.
  LOCAL anX
  LOCAL	nRecMSp := MsPrc_Mz ->( Recno())
  LOCAL cTagMSp := MsPrc_Mz ->( OrdSetFOCUS())
  LOCAL nTMPsazba
  LOCAL nX

// nTypAutGHM = 1  -  TREFAL

  IF IsNil( anFPD)
    anFPD := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  ENDIF

  IF nDMZ = 150
    DO CASE
    CASE nTypAutGHM = 1
      IF MsPrc_Mz ->cTypTarMZD = "CASOVA  "
	nTMPsazba := M_Dav ->nHrubaMZD    // * fSazZAM( Date())[1] / 100
      ELSE
	nTMPsazba := M_Dav ->nHrubaMZD    // * fSazZAM( Date())[1] / 100
      ENDIF
    OTHERWISE
      nTMPsazba := M_Dav ->nHrubaMZD    // * fSazZAM( Date())[1] / 100
    ENDCASE
  ENDIF

  MH_CopyFLD( 'MsPrc_Mz', 'M_Dav', .T.,, .T., .T.)

  m_Dav ->cUloha     := "M"
  m_Dav ->cDenik     := "M"
  m_Dav ->nRok       := ACT_OBDyn()
  m_Dav ->nObdobi    := ACT_OBDon()
  m_Dav ->cObdobi    := ACTObdobi()
  m_Dav ->nDoklad    := nDokl +MsPrc_Mz ->nOsCisPrac
  m_Dav ->nOrdItem   := nPOR *10
  m_Dav ->cPracZarDo := MsPrc_Mz ->cPracZar
  IF Month( Date()) <> ACT_OBDon()
    m_Dav ->dDatPoriz := LastODate( ACT_OBDyn(), ACT_OBDon())
  ELSE
    m_Dav ->dDatPoriz := Date()
  ENDIF

  m_Dav ->cKmenStrSt := MsPrc_Mz ->cKmenStrPr
  m_Dav ->nZdrPojis  := MsPrc_Mz ->nZdrPojis
  m_Dav ->cTmKmStrPr := TMPkmenSTR( MsPrc_Mz ->cKmenStrPr)
  m_Dav ->cPracovnik := cPRACsort( "MsPrc_Mz")
  m_Dav ->nUcetMzdy  := 0

  PrednaNAKL( "M_Dav")

  m_Dav ->nDruhMzdy  := nDMZ

  DO CASE
  CASE nDMZ = 122 .OR. nDMZ = 120
    m_Dav ->nDnyDoklad := IF( nDMZ = 120, anFPD[14], anFPD[3])
    m_Dav ->nHodDoklad := anFPD[5]

    m_Dav ->nDnyFondKD := m_Dav ->nDnyDoklad
    m_Dav ->nDnyFondPD := m_Dav ->nDnyDoklad
    m_Dav ->nHodFondKD := m_Dav ->nHodDoklad
    m_Dav ->nHodFondPD := m_Dav ->nHodDoklad

  CASE nDMZ = 127
    DO CASE
    CASE nTypAutGHM = 1
      m_Dav ->nSazbaDokl := fSazZAM( Date())[2]
      m_Dav ->nMnPDoklad := anFPD[5]
    OTHERWISE
      m_Dav ->nDnyDoklad := anFPD[3]
      m_Dav ->nHodDoklad := anFPD[5]
    ENDCASE

  CASE nDMZ = 150
    m_Dav ->nSazbaDokl := nTMPsazba
    m_Dav ->nMnPDoklad := fSazZAM( Date())[1] / 100


  CASE nDMZ = 156
    m_Dav ->nSazbaDokl := fSazZAM( Date())[3]
    m_Dav ->nMnPDoklad := anFPD[5]

  CASE nDMZ = 199
    m_Dav ->nDnyDoklad := anFPD[1]
    m_Dav ->nHodDoklad := anFPD[2]

    m_Dav ->nDnyFondKD := anFPD[3]
    m_Dav ->nHodFondKD := anFPD[4]

  OTHERWISE
    m_Dav ->nDnyDoklad := anFPD[1]
    m_Dav ->nHodDoklad := anFPD[2]
    m_Dav ->nMnPDoklad := anFPD[11]

    m_Dav ->nDnyFondKD := anFPD[3]
    m_Dav ->nHodFondKD := anFPD[4]

    m_Dav ->nDnyFondPD := anFPD[5]
    m_Dav ->nHodFondPD := anFPD[6]

    m_Dav ->nHodPresc  := anFPD[7]
    m_Dav ->nHodPripl  := anFPD[8]

  ENDCASE

  anX := fSAZBA( ( cFILE) ->nDruhMzdy, cFILE)
  VypocHm( anX, cFILE)
  IF m_Dav ->nDnyDoklad == 0 .AND. m_Dav ->nHodDoklad == 0        ;
       .AND. m_Dav ->nSazbaDokl == 0 .AND. m_Dav ->nMzda == 0
    DelREC( "M_Dav")
  ENDIF
  MsPrc_Mz ->( OrdSetFOCUS( cTagMSp))
  MsPrc_Mz ->( dbGoTo( nRecMSp))

RETURN( NIL)


// Vrac¡ celkem nemoc za pracovn¡ka za obdob¡
STATIC FUNCTION ArrNEMo( xKEY)
	LOCAL aNEM := { 0, 0, 0, 0}
	LOCAL nREC := m_Nem ->( Recno())
	LOCAL nTAG := m_Nem ->( OrdSetFOCUS())

  IF m_Nem ->( dbSeek( xKEY))
    m_Nem ->( SET_sSCOPE( 2, xKEY))
     DO WHILE !m_Nem ->( Eof())
       aNEM[1] += m_Nem ->nVykazN_PD
       aNEM[2] += m_Nem ->nVykazN_VD
       aNEM[3] += m_Nem ->nHodFondPD
       aNEM[4] += m_Nem ->nNemocNiSa + m_Nem ->nNemocVySa
       m_Nem ->( dbSkip())
     ENDDO
    m_Nem ->( CLR_sSCOPE( nTag, nRec))
  ENDIF

RETURN( aNEM)


// Vrac¡ celkem nemoc za pracovn¡ka za obdob¡
STATIC FUNCTION ArrOSTo( xKEY)
	LOCAL aOST := { 0, 0, 0, 0, 0, 0, 0, 0}
	LOCAL nREC := m_Dav ->( Recno())
	LOCAL nTAG := m_Dav ->( OrdSetFOCUS())

  IF m_Dav ->( dbSeek( xKEY))
    m_Dav ->( SET_sSCOPE( 1, xKEY))
     DO WHILE !m_Dav ->( Eof())
       aOST[1] += m_Dav ->nDnyFondPD
       aOST[2] += m_Dav ->nHodFondPD
       aOST[3] += m_Dav ->nHodPresc
       aOST[4] += m_Dav ->nHodPrescS
       aOST[5] += m_Dav ->nDnyFondKD
       aOST[6] += m_Dav ->nHodFondKD
       IF m_Dav ->nDruhMzdy == 142
         aOST[7] += m_Dav ->nHodDoklad
       ENDIF
       aOST[8] += IF( C_TypDMZ ->cTypNapHoC == "OD", M_Dav ->nHodDoklad, 0)
       aOST[8] -= IF( C_TypDMZ ->cTypNapHoC == "PR", M_Dav ->nHodPresc, 0)

       m_Dav ->( dbSkip())
     ENDDO
    m_Dav ->( CLR_sSCOPE( nTag, nRec))
  ENDIF

RETURN( aOST)


STATIC FUNCTION AUTGenPREM()
  LOCAL  nPOR
  LOCAL  anFOND, aDNnem, aOST
  LOCAL  xKEYod, xKEYdo
  LOCAL  lOK, nZaklad
  LOCAL  dDatFirst
  LOCAL  dDatLast
  LOCAL  dDatOd, dDatDo

  DruhyMZD ->( OrdSetFOCUS( 1))

  M_Dav ->( dbSetRelation( 'DruhyMZD'  , ;
            { || M_Dav ->nDruhMzdy } , ;
                 'M_Dav ->nDruhMzdy'   ) )
  M_Dav ->( dbSkip( 0))

  dDatFirst := CtoD( "01/" +StrZero( ACT_OBDon(), 2) +"/"     ;
	                          +StrZero( ACT_OBDyn(), 4))
  dDatLast  := CtoD( StrZero( LastDayOM( dDatFirst), 2) +"/"  ;
	                         +StrZero( ACT_OBDon(), 2) +"/"     ;
	                          +StrZero( ACT_OBDyn(), 4))

  IF Box_YesNo( "Vygenerovat pr‚mie z HV ") == 1
    MsPrc_Mz ->( dbGoTop())

    DO WHILE !MsPrc_Mz ->( Eof())
      lOK := .F.
      dDatOd := IF( dDatFirst >= MsPrc_Mz ->dDatNast, dDatFirst, MsPrc_Mz ->dDatNast)
      IF ( dDatLast >= MsPrc_Mz ->dDatVyst .AND. MsPrc_Mz ->dDatVyst > dDatFirst) ;
		.OR. Empty( MsPrc_Mz ->dDatVyst)
	lOK    := .T.
	dDatDo := IF( Empty( MsPrc_Mz ->dDatVyst), dDatLast, MsPrc_Mz ->dDatVyst)
      ENDIF
      M_Dav ->( OrdSetFOCUS(1))
      IF lOK .AND. MsPrc_Mz ->nMimoPrVzt = 0 .AND. MsPrc_Mz ->nSazPodHVP > 0  ;
	       .AND. !M_Dav ->( dbSeek( ACT_OBDn()+StrZero( MsPrc_Mz ->nOsCisPrac)    ;
					  +StrZero( MsPrc_Mz ->nPorPraVzt)    ;														   +StrZero( 700000 +MsPrc_Mz ->nOsCisPrac, 6)))
        GenRADEKdok( 154, 700000, 1)
      ENDIF

      MsPrc_Mz ->( dbSkip())
    ENDDO
  ENDIF

  DruhyMZD ->( dbClearRelat())

RETURN( NIL)


STATIC FUNCTION AUTGenDOCH()
  LOCAL  nPOR
  LOCAL  anFND, aDNnem, aOST
  LOCAL  xKEYod, xKEYdo
  LOCAL  lOK, nZaklad
  LOCAL  dDatFirst
  LOCAL  dDatLast
  LOCAL  dDatOd, dDatDo

  DruhyMZD ->( OrdSetFOCUS( 1))

  M_Dav ->( dbSetRelation( 'DruhyMZD'  , ;
             { || M_Dav ->nDruhMzdy } , ;
                 'M_Dav ->nDruhMzdy'   ) )
  M_Dav ->( dbSkip( 0))

  dDatFirst := CtoD( "01/" +StrZero( ACT_OBDon(), 2) +"/"     ;
                             +StrZero( ACT_OBDyn(), 4))
  dDatLast  := CtoD( StrZero( LastDayOM( dDatFirst), 2) +"/"  ;
                             +StrZero( ACT_OBDon(), 2) +"/"     ;
	                      +StrZero( ACT_OBDyn(), 4))

  IF Box_YesNo( "Vygenerovat data z modulu DOCHAZKA ") == 1
    TMPsumKON()
    C_Prerus ->( OrdSetFOCUS( 1))
    MsPrc_Mz ->( dbGoTop())
    TMp_OMETRp( .T.,, "Generov n¡ mezd z modulu DOCHAZKA...")
    TMp_OMETRp( 1, "MsPrc_Mz")

    DO WHILE !MsPrc_Mz ->( Eof())
      TMp_OMETRp( 0, "MsPrc_Mz")
      lOK := .F.
      dDatOd := IF( dDatFirst >= MsPrc_Mz ->dDatNast, dDatFirst, MsPrc_Mz ->dDatNast)
      IF ( dDatLast >= MsPrc_Mz ->dDatVyst .AND. MsPrc_Mz ->dDatVyst > dDatFirst) ;
		  .OR. Empty( MsPrc_Mz ->dDatVyst)
        lOK    := .T.
        dDatDo := IF( Empty( MsPrc_Mz ->dDatVyst), dDatLast, MsPrc_Mz ->dDatVyst)
      ENDIF
      M_Dav ->( OrdSetFOCUS(1))
      IF lOK .AND. TmpSumKo ->( dbSeek( MsPrc_Mz ->nOsCisPrac))               ;
	      .AND. !M_Dav ->( dbSeek( ACT_OBDn()+StrZero( MsPrc_Mz ->nOsCisPrac)  ;												        +StrZero( MsPrc_Mz ->nPorPraVzt)          ;												          +StrZero( 800000 +MsPrc_Mz ->nOsCisPrac, 6)))
        nPOR  := 1
 	anFND := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	IF TmpSumKo ->nDovolenHo <> 0                                      ;
   	    .AND. C_Prerus ->( dbSeek( Cs_Upper( "DOV")))                  ;
	     .AND. C_Prerus ->nDruhMzdy <> 0
          anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	  anFND[1] := TmpSumKo ->nDovolenDn
	  anFND[2] := TmpSumKo ->nDovolenHo
	  anFND[5] :=	anFND[3] := anFND[1]
	  anFND[6] :=	anFND[4] := anFND[2]
          GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
	ENDIF

	IF TmpSumKo ->nSvatkyHo <> 0                                        ;
	    .AND. C_Prerus ->( dbSeek( Cs_Upper( "SVA")))                   ;
	     .AND. C_Prerus ->nDruhMzdy <> 0
          anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	  anFND[1] := TmpSumKo ->nSvatkyDn
	  anFND[2] := TmpSumKo ->nSvatkyHo
	  anFND[5] :=	anFND[3] := anFND[1]
	  anFND[6] :=	anFND[4] := anFND[2]
       	  GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
	ENDIF

        IF TmpSumKo ->nNeplVolHo <> 0                                       ;
	    .AND. C_Prerus ->( dbSeek( Cs_Upper( "NEV")))                    ;
	     .AND. C_Prerus ->nDruhMzdy <> 0
 	  anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	  anFND[1] := TmpSumKo ->nNeplVolDn
	  anFND[2] := TmpSumKo ->nNeplVolHo
	  anFND[5] :=	anFND[3] := anFND[1]
	  anFND[6] :=	anFND[4] := anFND[2]
       	  GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
	ENDIF

        IF TmpSumKo ->nNahZMzdHo <> 0                                       ;
 	    .AND. C_Prerus ->( dbSeek( Cs_Upper( "NMZ")))                    ;
	     .AND. C_Prerus ->nDruhMzdy <> 0
 	  anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	  anFND[1] := TmpSumKo ->nNahZMzdDn
	  anFND[2] := TmpSumKo ->nNahZMzdHo
	  anFND[5] :=	anFND[3] := anFND[1]
	  anFND[6] :=	anFND[4] := anFND[2]
       	  GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
	ENDIF

        IF TmpSumKo ->nRefuMzdHo <> 0                                      ;
	    .AND. C_Prerus ->( dbSeek( Cs_Upper( "REF")))                   ;
	     .AND. C_Prerus ->nDruhMzdy <> 0
 	  anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	  anFND[1] := TmpSumKo ->nRefuMzdDn
	  anFND[2] := TmpSumKo ->nRefuMzdHo
	  anFND[5] :=	anFND[3] := anFND[1]
	  anFND[6] :=	anFND[4] := anFND[2]
       	  GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
        ENDIF

        IF TmpSumKo ->nOstNahrHo <> 0                                    ;
  	    .AND. C_Prerus ->( dbSeek( Cs_Upper( "LEK")))                 ;
	     .AND. C_Prerus ->nDruhMzdy <> 0
 	  anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	  anFND[1] := TmpSumKo ->nOstNahrDn
	  anFND[2] := TmpSumKo ->nOstNahrHo
	  anFND[5] :=	anFND[3] := anFND[1]
	  anFND[6] :=	anFND[4] := anFND[2]
       	  GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
	ENDIF

        IF TmpSumKo ->nAbsenceHo <> 0                                      ;
  	    .AND. C_Prerus ->( dbSeek( Cs_Upper( "ABS")))                   ;
 	     .AND. C_Prerus ->nDruhMzdy <> 0
   	  anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	  anFND[1] := TmpSumKo ->nAbsenceDn
	  anFND[2] := TmpSumKo ->nAbsenceHo
	  anFND[5] :=	anFND[3] := anFND[1]
	  anFND[6] :=	anFND[4] := anFND[2]
       	  GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
	ENDIF

        IF TmpSumKo ->nPresc25Ho <> 0                                     ;
 	    .AND. ( C_Prerus ->( dbSeek( Cs_Upper( "PPD")))                ;
	                     .OR. C_Prerus ->( dbSeek( Cs_Upper( "MPD"))))        ;
	     .AND. C_Prerus ->nDruhMzdy <> 0
 	  anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	  anFND[2] := TmpSumKo ->nPresc25Ho
	  anFND[7] :=	anFND[2]
          GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
        ENDIF

        IF TmpSumKo ->nPresc50Ho <> 0                                     ;
   	    .AND. ( C_Prerus ->( dbSeek( Cs_Upper( "PSN")))                ;
		              .OR. C_Prerus ->( dbSeek( Cs_Upper( "MSN"))))        ;
   	     .AND. C_Prerus ->nDruhMzdy <> 0
 	  anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	  anFND[2] := TmpSumKo ->nPresc50Ho
	  anFND[7] :=	anFND[2]
          GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
       ENDIF

       IF TmpSumKo ->nPripl10SN <> 0                                     ;
	   .AND.  C_Prerus ->( dbSeek( Cs_Upper( "SNP")))                 ;
	    .AND. C_Prerus ->nDruhMzdy <> 0
 	 anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	 anFND[2] := TmpSumKo ->nPripl10SN
	 anFND[7] :=	anFND[2]
         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
       ENDIF

       IF TmpSumKo ->nSvatPriHo <> 0                                     ;
	   .AND. ( C_Prerus ->( dbSeek( Cs_Upper( "PSV")))                ;
		              .OR. C_Prerus ->( dbSeek( Cs_Upper( "MSV"))))        ;
	    .AND. C_Prerus ->nDruhMzdy <> 0
         anFND     := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	 anFND[2] := TmpSumKo ->nSvatPriHo
	 anFND[8] :=	anFND[2]
         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
       ENDIF

       IF TmpSumKo ->nPripl10SV <> 0                                     ;
	   .AND.  C_Prerus ->( dbSeek( Cs_Upper( "SVP")))                 ;
	    .AND. C_Prerus ->nDruhMzdy <> 0
         anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	 anFND[2] := TmpSumKo ->nPripl10SV
	 anFND[7] :=	anFND[2]
         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
       ENDIF

       IF TmpSumKo ->nNocnPriHo <> 0                                     ;
	   .AND. C_Prerus ->( dbSeek( Cs_Upper( "PNO")))                  ;
	    .AND. C_Prerus ->nDruhMzdy <> 0
	 anFND     := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	 anFND[2]  := TmpSumKo ->nNocnPriHo
	 anFND[8]  :=	anFND[2]
	 anFND[11] :=	anFND[2]

       	 GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
       ENDIF
     ENDIF

     MsPrc_Mz ->( dbSkip())
   ENDDO
   TMp_OMETRp( -1)
 ENDIF

RETURN( NIL)


STATIC FUNCTION TMPsumKON()
	LOCAL  nROK  := ACT_OBDyn(), nMES := ACT_OBDon()
	LOCAL  lNewREC
	LOCAL  nREC_po
	LOCAL  cTAG_po
	LOCAL  cTYP
	LOCAL  paSETs
	LOCAL  n
	LOCAL  cALIAS := Alias()
	LOCAL  aPdDNY := {}, cFS_day
	LOCAL  lHRO   := .T.
	LOCAL  cScreen := SaveScreen()
	LOCAL  nCOUNT, nITEm := 1
	LOCAL  cKEY_prac
	LOCAL  nDNY_fond, nDNY_svat, aX := {}

	DC_DcOPEN( { 'DSPOHYBY,1', 'MsPrc_Mz,1' })
	DC_DcOPEN( { 'c_SVATKY,3', 'c_PRERUS,3', 'c_PRACSM,1', 'c_PRACDO,1'})


	nREC_po := DSPOHYBY ->( RECNO())
	DCOpen( "TmpSumKo",, .T.)
        TmpSumKo ->( ORDsetFOCUS( 1),  __dbZAP(), sx_KILLTAG(.T.))
	dbSELECTAREA( 'TmpSumKo')
	INDEX on TmpSumKo ->nOsCisPrac TAG TmpSUK_01

	c_PRACDO ->( dbSEEK( CS_UPPER( MsPrc_Mz ->cDELKprDOB)))

	DSPOHYBY ->( dbSETRELATON( 'c_PRERUS', { || DSPOHYBY ->nKODPRER }, ;
																						  'DSPOHYBY ->nKORPRER'   ))
	aX        := DOCH_kal()
	nDNY_fond := aX[1]
	nDNY_svat := aX[2]

        MsPrc_Mz ->( dbGoTop())

	TMp_OMETRp( .T.,, "Vytvoýen¡ podklad… pro generov n¡ mezd...")
	TMp_OMETRp( 1, "MsPrc_Mz")

        DSPOHYBY ->( OrdSetFOCUS( 1))
	nCOUNT := MsPrc_Mz ->( Sx_KeyCount())

	DO WHILE !MsPrc_Mz ->( Eof())
	  TMp_OMETRp( 0, "MsPrc_Mz")
    	  aPdDNY    := {}
	  cKEY_prac := STRZERO( MsPrc_Mz ->nOsCisPRAC) +ACT_OBDn()
	  DSPOHYBY ->( Set_Scope( cKEY_prac))
	  DSPOHYBY ->( dbGoTop())
	  IF MsPrc_Mz ->nOsCisPrac == DSPOHYBY ->nOsCisPrac
	     MH_CopyFld( "DSPOHYBY", "TmpSumKo", .T.)

	     TmpSumKo ->nFondPDHo := DOCH_fond('HOD', 'PD', nDNY_fond, nDNY_svat)
	     TmpSumKo ->nFondPDDn := DOCH_fond('DNY', 'PD', nDNY_fond, nDNY_svat)
	     TmpSumKo ->nFondSVHo := DOCH_fond('HOD', 'SV', nDNY_fond, nDNY_svat)
	     TmpSumKo ->nFondSVDn := DOCH_fond('DNY', 'SV', nDNY_fond, nDNY_svat)

	     TmpSumKo ->nFondPSHo := TmpSumKo ->nFondPDHo +TmpSumKo ->nFondSVHo
	     TmpSumKo ->nFondPSDn := TmpSumKo ->nFondPDDn +TmpSumKo ->nFondSVDn

	     C_Svatky ->( OrdSetFOCUS( 1))

	     DO WHILE !DSPOHYBY ->( EOF())
	       cTYP := AllTrim( DSPOHYBY ->cKodPrer)

	       IF cTYP == "PRI" .OR. cTYP == "MPR"
		 TmpSumKo ->nOdpracoHo += DsPohyby ->nCasCelCPD
		 IF cTYP == "PRI" .AND. DSPOHYBY ->cZkrDne <> "So"                     ;
		       .AND. DSPOHYBY ->cZkrDne <> "Ne"                                  ;
		    	.AND. !c_SVATKY ->( dbSEEK( DtoS( DSPOHYBY ->dDatum)))
		   IF( aScan( aPdDNY, DSPOHYBY ->nDen) = 0, AAdd( aPdDNY, { DSPOHYBY ->nDen}), NIL)
		 ENDIF
	       ENDIF

	       TmpSumKo ->nDovolenHo += IF( cTYP == "DOV", DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nNemocenHo += IF( cTYP == "NEM", DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nSvatkyHo  += IF( cTYP == "SVA", DsPohyby ->nCasCelCPD, 0)
//		     TmpSumKo ->nNeplVolHo += IF( cTYP == "NEV", DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nOCRHo     += IF( cTYP == "OSE", DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nNahZMzdHo += IF( cTYP == "NMZ", DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nRefuMzdHo += IF( cTYP == "REF", DsPohyby ->nCasCelCPD, 0)
//		     TmpSumKo ->nAbsenceHo += IF( cTYP == "ABS", DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nOstNahrHo += IF( cTYP == "SOU" .OR. cTYP == "LEK"           ;
		                                    , DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nPresc25Ho += IF( cTYP == "PPD" .OR. cTYP == "MPD"           ;
		                                    , DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nPresc50Ho += IF( cTYP == "PSN" .OR. cTYP == "MSN"           ;
		                                    , DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nPripl10SN += IF( cTYP == "SNP", DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nSvatPriHo += IF( cTYP == "PSV" .OR. cTYP == "MSV"           ;
		                                    , DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nPripl10SV += IF( cTYP == "SVP", DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nNocnPriHo += IF( cTYP == "PNO", DsPohyby ->nCasCelCPD, 0)
	       TmpSumKo ->nOdmenyHo  += IF( cTYP == "MPR", DsPohyby ->nCasCelCPD, 0)

	       IF cTYP == "NEV"
		 TmpSumKo ->nNeplVolHo += DsPohyby ->nCasCelCPD
		 TmpSumKo ->nNeplVolDn += IF( DsPohyby ->nCasCelCPD >= c_PRACDO ->nHodDen, 1, 0)
	       ENDIF

	       IF cTYP == "ABS"
		 TmpSumKo ->nAbsenceHo += DsPohyby ->nCasCelCPD
		 TmpSumKo ->nAbsenceDn += IF( DsPohyby ->nCasCelCPD >= c_PRACDO ->nHodDen, 1, 0)
	       ENDIF

	       DSPOHYBY ->( dbSkip())
	     ENDDO

	     TmpSumKo ->nOdpracoDn := Len( aPdDNY)

	     TmpSumKo ->nDovolenDn := MH_RoundNumb( TmpSumKo ->nDovolenHo /c_PRACDO ->nHodDen, 212)
	     TmpSumKo ->nNemocenDn := MH_RoundNumb( TmpSumKo ->nNemocenHo /c_PRACDO ->nHodDen, 212)
	     TmpSumKo ->nSvatkyDn  := MH_RoundNumb( TmpSumKo ->nSvatkyHo  /c_PRACDO ->nHodDen, 212)
//	     TmpSumKo ->nNeplVolDn := MH_RoundNumb( TmpSumKo ->nNeplVolHo /c_PRACDO ->nHodDen, 212)
	     TmpSumKo ->nOCRDn     := MH_RoundNumb( TmpSumKo ->nOCRHo     /c_PRACDO ->nHodDen, 212)
	     TmpSumKo ->nNahZMzdDn := MH_RoundNumb( TmpSumKo ->nNahZMzdHo /c_PRACDO ->nHodDen, 212)
	     TmpSumKo ->nRefuMzdDn := MH_RoundNumb( TmpSumKo ->nRefuMzdHo /c_PRACDO ->nHodDen, 212)

	     TmpSumKo ->nOstNahrDn := MH_RoundNumb( TmpSumKo ->nOstNahrHo /c_PRACDO ->nHodDen, 212)
//	     TmpSumKo ->nAbsenceDn := MH_RoundNumb( TmpSumKo ->nAbsenceHo /c_PRACDO ->nHodDen, 212)
	  ENDIF

	  DSPOHYBY ->( Clr_Scope())

	  nITEm++
	  MsPrc_Mz ->( dbSkip())
	ENDDO

	TMp_OMETRp( -1)

	C_Prerus ->( dbClearRelat())

//	RESTSCREEN( ,,,, aSCREENs[1])
//	SETPOS( aSCREENs[2] +2, aSCREENs[3] +2 )

RETURN( NIL)


STATIC FUNCTION DOCH_fond( cTYP, cFND, nDNY_fond, nDNY_svat)            //Äzobrazen¡ FONDU_PDÄÄÄÄÄÄÄÄ
	Local nVAL := 0

  If     cTYP == 'DNY' .AND. cFND == "PD"  ;  nVAL := nDNY_fond
  ElseIf cTYP == 'DNY' .AND. cFND == "SV"  ;  nVAL := nDNY_svat
  ElseIf cTYP == 'HOD' .AND. cFND == "PD"  ;  nVAL := nDNY_fond * c_PRACDO ->nHODden
  ElseIf cTYP == 'HOD' .AND. cFND == "SV"  ;  nVAL := nDNY_svat * c_PRACDO ->nHODden
  EndIf

RETURN( nVAL)


Static Function DOCH_kal()
  Local  nFS_day, nLS_day, nPOS
  Local  dFs_day := CTOD( '01.' +STRTRAN( ACT_OBDnc(), '/', '.'))
  Local  cFS_day := UPPER( LEFT( CDOW( dFS_day), 2))
  Local  cOB_ym  := ACT_OBDn()
  Local  nDNY_fond
  Local	 nDNY_svat

  C_Svatky ->( OrdSetFOCUS( 3))

  nDNY_fond := 0
  nDNY_svat := 0

  nLS_day   := LASTDAYOM( dFs_day)

  For nPOs := 1 To nLS_day STEP 1
    cFS_day := UPPER( LEFT( CDOW( dFS_day +nPOs -1), 2))
    If c_SVATKY ->( dbSEEK( cOB_ym +STRZERO( nPOs, 2))) .OR. cFS_day == 'SO' .OR. cFS_day == 'NE'
      IF c_SVATKY ->( dbSEEK( cOB_ym +STRZERO( nPOs, 2))) .AND. cFS_day <> 'SO' .AND. cFS_day <> 'NE'
        nDNY_svat++
      ENDIF
    ELSE
      nDNY_fond++
    EndIf
  Next

RETURN( { nDNY_fond, nDNY_svat })


STATIC FUNCTION DEL_AutDOK( nDOKL, lPRAC)
  LOCAL  cTAG := M_Dav ->( OrdSetFOCUS())
  LOCAL  nREC := M_Dav ->( Recno())
  LOCAL  xKEYod, xKEYdo
  LOCAL  nTAG
  LOCAL  lOK := .F.

  DEFAULT lPRAC TO .F.

  IF lPRAC
    xKEYod := ACT_OBDn() +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt) +StrZero( nDOKL, 6)
    xKEYdo := ACT_OBDn() +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt) +StrZero( nDOKL +99999, 6)
    nTAG   := 1
  ELSE
    xKEYod := ACT_OBDn() +StrZero( nDOKL, 6)
    xKEYdo := ACT_OBDn() +StrZero( nDOKL +99999, 6)
    nTAG   := 4
  ENDIF

  lOK := IF( !lPRAC, Box_YesNo( "Zruçit doklady " +Str( nDOKL) +" - "+ Str( nDOKL+99999)) == 1, .T.)

  IF lOK
    IF( !lPRAC, Tmp_OMETRp( .T.,, " Ruç¡m doklady " +Str( nDOKL) +" - "+ Str( nDOKL+99999)), NIL)

    M_Dav ->( SET_rSCOPE(  nTAG, xKEYod, xKEYdo))
     IF( !lPRAC, Tmp_OMETRp( 1,"M_Dav"), NIL)
     DO WHILE !M_Dav ->( Eof())
       IF( !lPRAC, Tmp_OMETRp( 0,"M_Dav"), NIL)
       DELrec( "M_Dav")
       M_Dav ->( dbSkip())
     ENDDO
    M_Dav ->( CLR_rSCOPE( cTAG, nREC))
    IF( !lPRAC, Tmp_OMETRp( -1), NIL)
  ENDIF

RETURN( NIL)


FUNCTION fCFGautVYP()
  LOCAL  cX := SysConfig( "Mzdy:cCFGAutVHM")
  LOCAL  aX := { 0, 0, 0, 0, 0, 0 }     //  122,127,120,150,183,199
  LOCAL  n

  FOR n := 1 TO 6	; aX[n] := Val( Token( cX, ",", n))
  NEXT

RETURN( aX)




