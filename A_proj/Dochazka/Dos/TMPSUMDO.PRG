//ÄÄÄÄÄÄÄÄÄÄÄÄDOCHµZKA ze sn¡maŸe U PRACOVNÖKAÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
# Include  '..\DOCHDef_.Ch'

# xTranslate  REG_xSCo(<N>,<T>,<X> [,<lCLR>] [,<lSHA>]) => ;
         	   ( REG_File(<N>) ->( OrdSetFocus(<T>)    , ;
                                 Sx_SetScope( 0, <X>), ;
                                 Sx_SetScope( 1, <X>), ;
                    			       REG_GTop(<N>)       , ;
			                           REG_Rest(<N>, .T. [,<lCLR>] [,<lSHA>] )))

Static  nDAY_doch, nDNY_fond, nDNY_svat
Static  cKEY_prac
STATIC  nRYOSTP


FUNCTION TMPsumKON( lALL, lVYR)
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
	LOCAL  aRUNFLTs  := {}, aFLTsTMP := {}, aSCREENs := VW_SCREENs()
	LOCAL  lIsFilter := .T.
	LOCAL  cScreen := SaveScreen()
	LOCAL  nCOUNT, nITEm := 1

	DEFAULT lALL TO .F.
	DEFAULT lVYR TO .F.

	IF lALL
		DC_DcOPEN( { 'DSPOHYBY,1', 'MsPrc_Md,1' })
	ENDIF

	IF lVYR
		DC_DcOPEN( { 'ListIT,1'})
	ENDIF

	DC_DcOPEN( { 'c_SVATKY,3', 'c_PRERUS,3', 'c_PRACSM,1', 'c_PRACDO,1', 'c_INFSUM,3' } )

//	TmpSumKo ->( __dbZAP())

	nREC_po := DSPOHYBY ->( RECNO())
	TmpSumKo ->( ORDsetFOCUS( 1),  __dbZAP(), sx_KILLTAG(.T.))
	dbSELECTAREA( 'TmpSumKo')
	INDEX on TmpSumKo ->nOsCisPrac TAG TmpSUK_01

	c_PRACDO ->( dbSEEK( CS_UPPER( MSPRC_md ->cDELKprDOB)))

	DSPOHYBY ->( dbSETRELATION( 'c_PRERUS', { || DSPOHYBY ->nKODPRER }, ;
																						  'DSPOHYBY ->nKORPRER'   ))
	DOCH_kal()

	IF lALL
    MsPrc_Md ->( dbGoTop())
	ELSE
	  paSETs  := { DSPOHYBY ->( ORDsetFOCUS()), DSPOHYBY ->( SX_SETSCOPE()) }
	ENDIF

	IF lALL
//	  ThermBOX( 1,,, "Vytvoýen¡ podklad… pro sestavu", "Sumarizace pohyb…")
		TMp_OMETRp( .T.,, "Vytvoýen¡ podklad… pro sestavu")
//		TMp_OMETRs( -2)
		TMp_OMETRp( 1, "MsPrc_Md")
	ENDIF

  DSPOHYBY ->( OrdSetFOCUS( 1))
	nCOUNT := MsPrc_Md ->( Sx_KeyCount())

	DO WHILE !MsPrc_Md ->( Eof()) .AND. lHRO
	  IF( lALL, TMp_OMETRp( 0, "MsPrc_Md"), NIL)
//	  IF( lALL, ThermBOX( , nCOUNT, nITEm), NIL)
		aPdDNY    := {}
	  cKEY_prac := STRZERO( MsPrc_Md ->nOScisPRAC) +ACT_OBDn()
	  DSPOHYBY ->( Set_Scope( cKEY_prac))
		 IF( lALL, DSPOHYBY ->( dbGoTop()), NIL)
		 IF MsPrc_Md ->nOsCisPrac == DSPOHYBY ->nOsCisPrac
	     MH_CopyFld( "DSPOHYBY", "TmpSumKo", .T.)

	     TmpSumKo ->nFondPDHo := DOCH_fond('HOD', 'PD')
	     TmpSumKo ->nFondPDDn := DOCH_fond('DNY', 'PD')
	     TmpSumKo ->nFondSVHo := DOCH_fond('HOD', 'SV')
	     TmpSumKo ->nFondSVDn := DOCH_fond('DNY', 'SV')

	     TmpSumKo ->nFondPSHo := TmpSumKo ->nFondPDHo +TmpSumKo ->nFondSVHo
	     TmpSumKo ->nFondPSDn := TmpSumKo ->nFondPDDn +TmpSumKo ->nFondSVDn

//	 DSPOHYBY ->( dbGoTop())
	     C_Svatky ->( OrdSetFOCUS( 1))

	     DO WHILE !DSPOHYBY ->( EOF())
		     cTYP := AllTrim( DSPOHYBY ->cKodPrer)

		     IF cTYP == "PRI" .OR. cTYP == "MPR"
		       TmpSumKo ->nOdpracoHo += DsPohyby ->nCasCelCPD
			     IF cTYP == "PRI" .AND. DSPOHYBY ->cZkrDne <> "So"                     ;
			 	       .AND. DSPOHYBY ->cZkrDne <> "Ne"                                  ;
					    	.AND. !c_SVATKY ->( dbSEEK( DtoS( DSPOHYBY ->dDatum)))
			       IF( aScan( aPdDNY, DSPOHYBY ->nDen) == 0                            ;
				 	          , AAdd( aPdDNY, { DSPOHYBY ->nDen}), NIL)
			     ENDIF
		     ENDIF

		     TmpSumKo ->nDovolenHo += IF( cTYP == "DOV", DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nNemocenHo += IF( cTYP == "NEM", DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nSvatkyHo  += IF( cTYP == "SVA", DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nOCRHo     += IF( cTYP == "OSE", DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nNahZMzdHo += IF( cTYP == "NMZ", DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nRefuMzdHo += IF( cTYP == "REF", DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nOstNahrHo += IF( cTYP == "SOU" .OR. cTYP == "LEK"           ;
		                                    , DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nPresc25Ho += IF( cTYP == "PPD" .OR. cTYP == "MPD"           ;
		                                    , DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nPresc50Ho += IF( cTYP == "PSN" .OR. cTYP == "MSN"           ;
		                                    , DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nSvatPriHo += IF( cTYP == "PSV" .OR. cTYP == "MSV"           ;
		                                    , DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nNocnPriHo += IF( cTYP == "PNO", DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nOdmenyHo  += IF( cTYP == "MPR", DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nPripl10SN += IF( cTYP == "SNP", DsPohyby ->nCasCelCPD, 0)
		     TmpSumKo ->nPripl10SV += IF( cTYP == "SVP", DsPohyby ->nCasCelCPD, 0)

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

		IF lVYR
	    cKEY_prac := STRZERO( MsPrc_Md ->nOScisPRAC) +Cs_Upper( ACTObdobi())
      ListIt ->( OrdSetFOCUS( 10))
	    ListIt ->( Set_Scope( cKEY_prac))
			 ListIt ->( dbGoTop())
		   IF MsPrc_Md ->nOsCisPrac == ListIt ->nOsCisPrac
			   DO WHILE !ListIt ->( Eof())
				   TmpSumKo ->nVyrobaHo += ListIt ->nNHnaOPEsk
				   ListIt ->( dbSkip())
			   ENDDO
			 ENDIF
		  ListIt ->( Clr_Scope())
		ENDIF

		IF lALL
			nITEm++
			MsPrc_Md ->( dbSkip())
		ELSE
			lHRO := .F.
		ENDIF
	ENDDO

	IF !lALL
    DSPOHYBY ->( ORDsetFOCUS( paSETs[1]))
	  DSPOHYBY ->( SX_SETSCOPE( 0, paSETs[2]))
	  DSPOHYBY ->( SX_SETSCOPE( 1, paSETs[2]))
	  DSPOHYBY ->( dbGOTO( nREC_po))
	  dbSELECTAREA( cALIAS)
	ELSE
		TMp_OMETRp( -1)

		RESTSCREEN( ,,,, aSCREENs[1])
		SETPOS( aSCREENs[2] +2, aSCREENs[3] +2 )

	  aRUNFLTs  := RunEXTFLT( cScreen)
	  IF !Empty( aRUNFLTs)
		  lIsFilter := aRUNFLTs[1]
		  aFLTsTMP  := aRUNFLTs[3]
	  ENDIF

	  IF LastKey() <> K_ESC .AND. lIsFilter
      nRYOSTP := 0
      GSCREATREPORTs( '.\LST\' +ALLTRIM( FORMS ->cFILEVIEW) +'.LST', ;
	                        { || VW_RYOSEL() }, aFLTsTMP)
	    VIEW ->( dbCLOSEAREA())
	  ENDIF
	ENDIF

//  	DSPOHYBY ->( Clr_Scope(), dbGOTO( nREC_po))
//  	DSPOHYBY ->( OrdSetFOCUS( cTAG_po))

RETURN( NIL)


STATIC FUNCTION DOCH_fond( cTYP, cFND )            //Äzobrazen¡ FONDU_PDÄÄÄÄÄÄÄÄ
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

	C_Svatky ->( OrdSetFOCUS( 3))

	nDNY_fond := 0
	nDNY_svat := 0

	nLS_day   := LASTDAYOM( dFs_day)

	For nPOs := 1 To nLS_day STEP 1
		cFS_day := UPPER( LEFT( CDOW( dFS_day +nPOs -1), 2))
		If c_SVATKY ->( dbSEEK( cOB_ym +STRZERO( nPOs, 2)))        ;
			   .OR. cFS_day == 'SO' .OR. cFS_day == 'NE'
			IF c_SVATKY ->( dbSEEK( cOB_ym +STRZERO( nPOs, 2)))        ;
			    .AND. cFS_day <> 'SO' .AND. cFS_day <> 'NE'
			  nDNY_svat++
			ENDIF
		ELSE
			nDNY_fond++
		EndIf
	Next

RETURN( NIL)


STATIC FUNCTION VW_RYOSEL()
	LOCAL  lOK
	If( nRYOSTP == 0, ( lOK := .T., nRYOSTP++ ), lOK := .F. )
RETURN( lOK)


