// Program:... IMP_dat.Prg
// Funkce:.... Naüten° dat

#include '..\DochDEF_.Ch'

STATIC cPathTER

FUNCTION ImportTERM( nTYP)
	LOCAL  cKEY, nOldDOKL, nOldCP
	LOCAL  lOK := .F.
	LOCAL  cScreen   := SaveScreen()
	LOCAL  cALIAS
	LOCAL  cFILEouTX, cSerNM

	Dc_DCOpen( { 'C_Svatky, 3', 'C_Prerus, 1', 'C_Termin, 1', 'C_PracSm, 1'    ;
 	              , 'DsPohyby, 1', 'MsPrc_Md, 5' })

	cPathTER := AllTrim( SysConfig( "Dochazka:cPathTERM"))

	IF ACT_OBDon() <> Month( Date())
		BOX_WARING( " Nastavte spr†vnÇ obdob° - p˝enos bude ukonüen !!!! ")

	ELSE
    IF BOX_YESNO( "Naü°st data z termin†lu ?") == 1
 	    cScreen := SaveScreen()
			IF DsPohyby ->( FLock())
       	DC_DCclose( { 'DsPohyby'})
	      DCOpen( "DsPohyby",, .T.)

			ELSE
				BOX_WARING( "POZOR jsou p˝ihl†Áeni ußivatelÇ v modulu DOCHAZKA." +  ;
				             " Po dobu p˝enosu mus° ukonüit üinnost !!!")
				RETURN( NIL)
			ENDIF

			dbSelectArea( "Tmp_Term")
	    Tmp_Term ->( __dbZAP())
	    Tmp_Term ->( Sx_KillTag( .T.))

	    INDEX ON StrZero( Tmp_Term ->nRok) +StrZero( Tmp_Term ->nMesic)            ;
	       +StrZero( Tmp_Term ->nDen) +Cs_Upper( Tmp_Term ->cCas) TAG TMPTER_1
	    Tmp_Term ->( OrdSetFOCUS( 1))

//    DsPohyby ->( __dbZap())    // pozor testy

		  C_Termin ->( dbGoTop())

		  DO WHILE !C_Termin ->( Eof())
			  IF C_Termin ->lAktivni
				  cFILEouTX := StrZero( Month( Date()), 2)                       ;
					  						+StrZero( Day( Date()), 2)                       ;
				                 +SubStr( Time(), 1, 2) + SubStr( Time(), 4, 2)  ;
							  				  +"." +StrZero( C_Termin ->nPorTermin, 3)

		      @ 5, 10 Say "Prob°h† naüten° dat z " + C_Termin ->cNazTermin

					cSerNM := AllTrim( C_Termin ->cSNTerm)

				  MemoWrit( cPathTER +"\ClkMng.Par", C_Termin ->mInitPopis)

		      SWPRUNCMD( cPathTER +"\clkcomm +R S" +cSerNM, 0, cPathTER, "")

				  FileCopy( cPathTER +"\Dochazka.Txt", cPathTER +"\Arc\" +cFILEouTX)
  	      LoadTXT()
			  ENDIF
			  C_Termin ->( dbSkip())
		  ENDDO

		  @ 5, 10 Say "Prob°h† aktualizace dat "
//*/
      AKTdsPohyb()        ///  !!!!!  uvnit˝ tÇto funkce to vypadne
	  ENDIF
	ENDIF

	RestScreen( ,,,, cScreen)
	Dc_DCclose( {'C_Prerus', 'DsPohyby', 'MsPrc_Md'})

RETURN( NIL)


STATIC FUNCTION LoadTXT()
	LOCAL  n
	LOCAL  nLineLen := 36
	LOCAL  mMemText, cLine

	mMemText := MemoRead( cPathTER + '\Dochazka.Txt')

	@ 5, 10 Say "Prob°h† vytvo˝en° pomocnÇho souboru           "

	FOR n := 1 TO  MlCount( mMemText, nLineLen)
		cLine := MemoLine( mMemText, nLineLen, n)

		Tmp_Term ->( dbAppend())

		@ 5, 60 Say Str( n, 6)

	  Tmp_Term ->cTypPrer   :=  SubStr( cLine,  1, 1)
	  Tmp_Term ->cRok       :=  SubStr( cLine,  3, 4)
	  Tmp_Term ->nRok       :=  Val( Tmp_Term ->cRok)
	  Tmp_Term ->cMesic     :=  SubStr( cLine,  8, 2)
	  Tmp_Term ->nMesic     :=  Val( Tmp_Term ->cMesic)
	  Tmp_Term ->cDen       :=  SubStr( cLine, 11, 2)
	  Tmp_Term ->nDen       :=  Val( Tmp_Term ->cDen)
	  Tmp_Term ->cCas       :=  SubStr( cLine, 14, 5)
	  Tmp_Term ->cDenVTydnu :=  SubStr( cLine, 20, 1)
	  Tmp_Term ->cIdOsKarty :=  SubStr( cLine, 22, 3)
	  Tmp_Term ->cAdrTerm   :=  SubStr( cLine, 26, 4)
	  Tmp_Term ->cSNTerm    :=  SubStr( cLine, 31, 6)

	  Tmp_Term ->dDatum     :=  CtoD( Tmp_Term ->cDen + "/" +Tmp_Term ->cMesic ;
		                                 +"/" +Tmp_Term ->cRok)
	NEXT

RETURN( NIL)


STATIC FUNCTION AKTdspohyby()
	LOCAL  lOK, lZPET
	LOCAL  nBEG, nEND
	LOCAL  cKEYod, cKEYdo, cKEY
	LOCAL  nLastDEN
	LOCAL  dLastDAT
	LOCAL  cTYP, cKEYs

  Tmp_Term ->( dbSetRelation( 'MsPrc_Md'  , ;
                     { || Cs_Upper( Tmp_Term ->cIdOsKarty) },   ;
										      'Cs_Upper( Tmp_Term ->cIdOsKarty)'))
  Tmp_Term ->( dbSkip( 0))

  MsPrc_Md ->( dbSetRelation( 'C_PracSm'  , ;
                     { || Cs_Upper( MsPrc_Md ->cTypSmeny) },   ;
										      'Cs_Upper( MsPrc_Md ->cTypSmeny)'))
  MsPrc_Md ->( dbSkip( 0))

	@ 5, 10 Say "Prob°h† aktualizace doch†zkovÇho systemu       "

	Tmp_Term ->( dbGoTop())

	DO WHILE !Tmp_Term ->( Eof())
		lOK   := .T.
		lZPET := .F.
		@ 5, 60 Say Str( Tmp_Term ->( Recno()))

// -----------------POZOR p˝i˝azen° mus° bÏt obr†cenÿ -----------------
//

	  cTYP := IF( Tmp_Term ->cTypPrer == "I", "ODC"               ;
		         ,IF( Tmp_Term ->cTypPrer == "O", "PRI"             ;
							 ,IF(Tmp_Term ->cTypPrer == "X", "MPR", "NIC")))

	  cKEY := Padr( Cs_Upper( Tmp_Term ->cIdOsKarty), 25)    ;
						 +Cs_Upper( cTYP) +"00.00"                     ;
				 	    +StrZero( Tmp_Term ->nRok, 4)                ;
						    +StrZero( Tmp_Term ->nMesic, 2)

		IF Tmp_Term ->nDen <> 1
		  cKEYod := cKEY +StrZero( Tmp_Term ->nDen -1, 2)
		ELSE
			dLASTdat := Tmp_Term ->dDatum -1
			cKEYod   := Padr( Cs_Upper( Tmp_Term ->cIdOsKarty), 25)    ;
										+Cs_Upper( cTYP) +"00.00"         ;
										 +StrZero( Year( dLASTdat), 4)    ;
										  +StrZero( Month( dLASTdat), 2)  ;
										   +StrZero( Day( dLASTdat), 2)
		ENDIF

		DO CASE
		CASE Tmp_Term ->cTypPrer == "I"
		  cKEYdo := cKEY +StrZero( Tmp_Term ->nDen+1, 2)
			DsPohyby ->( SET_rSCOPE( 7, cKEYod, cKEYdo))
			 DO WHILE !DsPohyby ->( Eof()) .AND. lOK
				 IF DsPohyby ->nDen == Tmp_Term ->nDen
					 IF DsPohyby ->cCasEnd < Tmp_Term ->cCas
						 lZPET := .T.
					 ELSE
						 cKEYs := MODIpohyby( .F., "PRI")
						 lZPET := .F.
			       lOK   := .F.
					 ENDIF
				 ELSE
				   IF DsPohyby ->cCasEnd < Tmp_Term ->cCas      // asi noün°
						 cKEYs := MODIpohyby( .F., "PRI")
						 lZPET := .F.
			       lOK   := .F.
					 ENDIF
				 ENDIF
		     DsPohyby ->( dbSkip())
		   ENDDO

			 IF lOK
				 IF lZPET
			     DsPohyby ->( dbSkip( -1))
					 cKEYs := MODIpohyby( .F., "PRI")
					 lZPET := .F.
		       lOK   := .F.
				 ELSE
			 	   cKEYs := MODIpohyby( .T., "PRI")
				 ENDIF
			 ENDIF
			DsPohyby ->( CLR_SCOPE())

		CASE Tmp_Term ->cTypPrer == "O"
		  cKEYdo := cKEY +StrZero( Tmp_Term ->nDen, 2)
			DsPohyby ->( SET_rSCOPE( 6, cKEYod, cKEYdo))
			 DO WHILE !DsPohyby ->( Eof()) .AND. lOK
				 IF DsPohyby ->nDen == Tmp_Term ->nDen
					 IF DsPohyby ->cCasBeg < Tmp_Term ->cCas
						 lZPET := .T.
					 ELSE
				     DsPohyby ->( dbSkip( -1))
						 cKEYs := MODIpohyby( .F., "ODC")
						 lZPET := .F.
			       lOK   := .F.
					 ENDIF
				 ELSE
					 IF DsPohyby ->cCasBeg > Tmp_Term ->cCas
						 cKEYs := MODIpohyby( .F., "ODC")
						 lZPET := .F.
			       lOK   := .F.
				                       // asi noün°
					 ENDIF
				 ENDIF
				 DsPohyby ->( dbSkip())
		   ENDDO

			 IF lOK
				 IF lZPET
			     DsPohyby ->( dbSkip( -1))
					 cKEYs := MODIpohyby( .F., "ODC")
				 ELSE
			 	   cKEYs := MODIpohyby( .T., "ODC")
				 ENDIF
			 ENDIF
			DsPohyby ->( CLR_SCOPE())

			IF( C_PracSm ->nTypPruzna == 2, PRUZnaSM_2(), NIL)

		CASE Tmp_Term ->cTypPrer == "X"
		  cKEYdo := cKEY +StrZero( Tmp_Term ->nDen, 2)
			DsPohyby ->( SET_rSCOPE( 6, cKEYod, cKEYdo))
			 DO WHILE !DsPohyby ->( Eof()) .AND. lOK
				 IF DsPohyby ->nDen == Tmp_Term ->nDen
					 IF DsPohyby ->cCasBeg < Tmp_Term ->cCas
						 cKEYs := MODIpohyby( .F., "MPR")
						 lOK := .F.
					 ELSE
			       lOK := .F.
					 ENDIF
				 ELSE
					 IF DsPohyby ->cCasBeg > Tmp_Term ->cCas
						 cKEYs := MODIpohyby( .F., "MPR")  // asi noün°
			       lOK   := .F.
					 ENDIF
 				 ENDIF

		     DsPohyby ->( dbSkip())

		   ENDDO
			 IF( lOK, cKEYs := MODIpohyby( .T., "MPR"), NIL)
			DsPohyby ->( CLR_SCOPE())
		ENDCASE

	  MODIcasy( cKEYs)

		Tmp_Term ->( dbSkip())
	ENDDO
RETURN( NIL)


STATIC FUNCTION MODIpohyby( lNEW, cTYP, nDEN, cCAS)
	LOCAL  nBEG, nEND
	LOCAL  cKEYs, cDEN

	DEFAULT cCAS TO Tmp_Term ->cCas
	DEFAULT nDEN TO Tmp_Term ->nDen

	cDEN := Str( nDEN)

	C_Prerus ->( dbSeek( Cs_Upper( cTYP)))

 	IF lNEW
 		AddREC( "DsPohyby")

 		DsPohyby ->nOsCisPrac := MsPrc_Md ->nOsCisPrac
 		DsPohyby ->cKmenStrPr := MsPrc_Md ->cKmenStrPr
 		DsPohyby ->cNazPol4   := MsPrc_Md ->cNazPol4
 		DsPohyby ->cRodCisPra := MsPrc_Md ->cRodCisPra
 		DsPohyby ->cIdOsKarty := Tmp_Term ->cIdOsKarty
 		DsPohyby ->cObdobi    := StrZero( Tmp_Term ->nMesic, 2) + "/"  ;
 		                          +SubStr( StrZero( Tmp_Term ->nRok, 4), 3, 4)
 		DsPohyby ->nRok       := Tmp_Term ->nRok
 		DsPohyby ->nObdobi    := Tmp_Term ->nMesic
 		DsPohyby ->nMesic     := Tmp_Term ->nMesic
 		DsPohyby ->nDen       := nDEN
 		DsPohyby ->dDatum     := cTod( cDEN +"/" +Tmp_Term ->cMesic +"/"        ;
  			   													 +Tmp_Term ->cRok)
	  DsPohyby ->cZkrDne    := Left( cDOw( DsPohyby ->dDatum), 2)

 	  DsPohyby ->nCasTMP    := TimeToSec( cCas)/3600
		WRT_zmena( "DsPohyby", .T.)

	ELSE
		ReplREC( "DsPohyby")
		WRT_zmena( "DsPohyby", .F.)
	ENDIF

	DO CASE
	CASE cTYP == "PRI" .OR. cTYP == "ODC"
		DO CASE
		CASE cTYP == "PRI"
		  IF !lNEW
 		    DsPohyby ->cObdobi    := StrZero( Tmp_Term ->nMesic, 2) + "/"  ;
 		                          +SubStr( StrZero( Tmp_Term ->nRok, 4), 3, 4)
 		    DsPohyby ->nRok       := Tmp_Term ->nRok
 		    DsPohyby ->nObdobi    := Tmp_Term ->nMesic
 		    DsPohyby ->nMesic     := Tmp_Term ->nMesic
 		    DsPohyby ->nDen       := nDEN
 		    DsPohyby ->dDatum     := cTod( cDEN +"/" +Tmp_Term ->cMesic +"/"    ;
  			       												  +Tmp_Term ->cRok)
	      DsPohyby ->cZkrDne    := Left( cDOw( DsPohyby ->dDatum), 2)
			ENDIF

  	  DsPohyby ->cKodPrer   := "PRI"
  	  DsPohyby ->nKodPrer   := 1
      DsPohyby ->cCasBeg    := cCAS
  	  DsPohyby ->nCasBeg    := TimeToSec( DsPohyby ->cCasBeg)/3600
			DsPohyby ->nCasBegPD  := MH_RoundNumb( DsPohyby ->nCasBeg, C_Prerus ->nKodZaokr)
  		DsPohyby ->cAdrTerm   := Tmp_Term ->cAdrTerm
  		DsPohyby ->cSNTerm    := Tmp_Term ->cSNTerm

	  CASE cTYP == "ODC"
      DsPohyby ->cKodPrerE   := "ODC"
      DsPohyby ->nKodPrerE   := 2
      DsPohyby ->cCasEnd     := cCAS
  	  DsPohyby ->nCasEnd     := TimeToSec( DsPohyby ->cCasEnd)/3600
			DsPohyby ->nCasEndPD   := MH_RoundNumb( DsPohyby ->nCasEnd, C_Prerus ->nKodZaokr)
      DsPohyby ->cAdrTermE   := Tmp_Term ->cAdrTerm
      DsPohyby ->cSNTermE    := Tmp_Term ->cSNTerm

		ENDCASE

	CASE cTYP == "MPR"

		IF Empty( DsPohyby ->cCasBeg)
 	    DsPohyby ->cKodPrer   := "MPR"
 	    DsPohyby ->nKodPrer   := 8
      DsPohyby ->cCasBeg    := cCAS
  	  DsPohyby ->nCasBeg    := TimeToSec( DsPohyby ->cCasBeg)/3600
			DsPohyby ->nCasBegPD  := MH_RoundNumb( DsPohyby ->nCasBeg, C_Prerus ->nKodZaokr)
  		DsPohyby ->cAdrTerm   := Tmp_Term ->cAdrTerm
  		DsPohyby ->cSNTerm    := Tmp_Term ->cSNTerm
		ELSE
 	    DsPohyby ->cKodPrerE := "MPR"
 	    DsPohyby ->nKodPrerE := 8
      DsPohyby ->cCasEnd   := cCAS
  	  DsPohyby ->nCasEnd   := TimeToSec( DsPohyby ->cCasEnd)/3600
			DsPohyby ->nCasEndPD := MH_RoundNumb( DsPohyby ->nCasEnd, C_Prerus ->nKodZaokr)
      DsPohyby ->cAdrTermE := Tmp_Term ->cAdrTerm
      DsPohyby ->cSNTermE  := Tmp_Term ->cSNTerm
		ENDIF
	ENDCASE

	DsPohyby ->nNapPrer  := C_Prerus ->nNapPrer
	DsPohyby ->nSaySCR   := C_Prerus ->nSaySCR
	DsPohyby ->nSayCRD   := C_Prerus ->nSayCRD
	DsPohyby ->nPritPrac := C_Prerus ->nPritPrac

//  nBEG := TimeToSec( DsPohyby ->cCasBeg)
//	nBEG := IF( nBEG > 0, nBEG, 0)
//	nEND := TimeToSec( DsPohyby ->cCasEnd)

  DsPohyby ->( dbCommit(), Sx_Unlock())

  cKEYs := Padr( Cs_Upper( DsPohyby ->cIdOsKarty), 25)    ; //  StrZero( MsPrc_Md ->nOsCisPrac)            ;
  	  	 	   +StrZero( DsPohyby ->nRok, 4)      ;
			  	    +StrZero( DsPohyby ->nMesic, 2)   ;
				       +StrZero( DsPohyby ->nDen, 2)

RETURN( cKEYs)


STATIC FUNCTION MODIprest()
	LOCAL  nX  := 0
	LOCAL  n   := 1
	LOCAL  lOK := .T.
	LOCAL  nCAStmp := DsPohyby ->nCasCelCPD
	LOCAL  nPresCAS, nPresZaCAS

	nPresCAS   := IF( Empty( C_PracSm ->cTypSmeny), 0.5, C_PracSm ->nPresCas)
	nPresZaCAS := IF( Empty( C_PracSm ->cTypSmeny), 4.5, C_PracSm ->nPresZaCas)

	DO WHILE lOK .AND. nX < 24
		nX := ( n - 1) * nPresCAS
		IF DsPohyby ->nCasCelCPD > ( ( nPresZaCAS *n) + nX)
		  n++
		ELSE
			DsPohyby ->nCasPresta := nX
			lOK := .F.
		ENDIF
	ENDDO

	DsPohyby ->nCasCelCPD := DsPohyby ->nCasCelCPD -DsPohyby ->nCasPresta

RETURN( NIL)


FUNCTION MODICasy( cKEYs, nGEN)
	LOCAL  nTIME, nMIN
	LOCAL  cKEY, lNEW, nPOS, cTYP
	LOCAL  cNASTUPSM
	LOCAL  nCelkPRI := 0,  nCelkMPR := 0
	LOCAL  nCASnoc  := 0
	LOCAL  nCASrec  := 0
	LOCAL  nPrescas := 0, nPrescasM := 0, nPrestavka := 0
	LOCAL  lEDIT    := .F.
	LOCAL  dFs_day
	LOCAL  cFS_day
	LOCAL  cOB_ym   := ACT_OBDn()
	LOCAL  cTypPresc, cTypPrescM
	LOCAL  nRecPres := 0, nRecNoc := 0, nRecPresM := 0, nRecPresPr := 0
	LOCAL  cOLDtag, nVAL, cVAL, cTMP
	LOCAL  nLastREC  := 0, nLastRECm := 0
	LOCAL  nCelkROZD := 0

//	LOCAL  nOldTAG := DsPohyby ->( OrdSetFOCUS())

	If IsNIL( cKEYs )
    cKEY := Padr( Cs_Upper( Tmp_Term ->cIdOsKarty), 25)    ; //  StrZero( MsPrc_Md ->nOsCisPrac)            ;
		  	 	   +StrZero( Tmp_Term ->nRok, 4)      ;
			  	    +StrZero( Tmp_Term ->nMesic, 2)   ;
				       +StrZero( Tmp_Term ->nDen, 2)
	Else
		FORDREC( { 'DSPOHYBY,10' } )
		cKEY := cKEYs
	EndIf

	nPOS    := Val( Right( cKEY, 2))
//  dFs_day := CTOD( '01.' +STRTRAN( ACT_OBDnc(), '/', '.'))
//	cFS_day := UPPER( LEFT( CDOW( dFS_day +nPOs -1), 2))

  dFs_day := CTOD( Right( cKEY, 2) +'.' +Left( Right( cKEY, 4), 2)         ;
	                   + '.'+Left( Right( cKEY, 8), 4))
	cFS_day := UPPER( LEFT( CDOW( dFS_day), 2))

//	If c_SVATKY ->( dbSEEK( cOB_ym +STRZERO( nPOs, 2)))
	If c_SVATKY ->( dbSEEK( Right( cKEY, 8)))
		cTYPpresc  := "PSV"
		cTYPprescM := "MSV"
	Else
	  cTYPpresc  := If( cFS_day == 'SO' .or. cFS_day == 'NE', "PSN", "PPD")
	  cTYPprescM := If( cFS_day == 'SO' .or. cFS_day == 'NE', "MSN", "MPD")
	EndIf

 	DsPohyby ->( SET_sSCOPE( 8, cKEY))
 	 DO WHILE !DsPohyby ->( Eof())
		 ReplREC( "DsPohyby")
		 lEDIT := IF( !lEDIT,	DsPohyby ->lIsMANUAL, lEDIT)
		 IF DsPohyby ->cKodPrer == "PPD" .OR. DsPohyby ->cKodPrer == "PSN" ;
			    .OR. DsPohyby ->cKodPrer == "PSV"
			 nRecPres := DsPohyby ->( Recno())
 	   ENDIF

		 IF DsPohyby ->cKodPrer == "SNP" .OR. DsPohyby ->cKodPrer == "SVP"
			 nRecPresPr := DsPohyby ->( Recno())
 	   ENDIF

		 IF DsPohyby ->cKodPrer == "MPD" .OR. DsPohyby ->cKodPrer == "MSN" ;
			    .OR. DsPohyby ->cKodPrer == "MSV"
			 nRecPresM := DsPohyby ->( Recno())
 	   ENDIF

		 IF DsPohyby ->cKodPrer == "PNO"
			 nRecNoc := DsPohyby ->( Recno())
		 ENDIF

		 IF Empty( cNASTUPSM)
			 IF DsPohyby ->cKodPrer == "PRI" .OR. DsPohyby ->cKodPrer == "MPR"
				 DO CASE
				 CASE DsPohyby ->cCasBeg > C_PracSm ->cRanSmeZac    ;
  				      .AND. !Empty( C_PracSm ->cRanSmeZac)
					 DsPohyby ->nCasBegPD := TimeToSec( DsPohyby ->cCasBeg) /3600
					 cNASTUPSM := "RAN"
				 CASE DsPohyby ->cCasBeg <= C_PracSm ->cRanSmeZac    ;
							 .AND. Padl( AllTrim( DsPohyby ->cCasBeg), 5, "0") >= "05:00"            ;
					      .AND. !Empty( C_PracSm ->cRanSmeZac)         ;
							   .AND. !C_PracSm ->lRanPruzna
					 DsPohyby ->nCasBegPD := TimeToSec( C_PracSm ->cRanSmeZac) /3600
					 cNASTUPSM := "RAN"

				 CASE DsPohyby ->cCasBeg <= C_PracSm ->cOdpSmeZac    ;
							 .AND. DsPohyby ->cCasBeg >= "12:00"           ;
					      .AND. !Empty( C_PracSm ->cOdpSmeZac)         ;
							   .AND. !C_PracSm ->lOdpPruzna
					 DsPohyby ->nCasBegPD := TimeToSec( C_PracSm ->cOdpSmeZac) /3600
					 cNASTUPSM := "ODP"

				 CASE DsPohyby ->cCasBeg <= C_PracSm ->cNocSmeZac   ;
							 .AND. DsPohyby ->cCasBeg >= "20:00"           ;
					      .AND. !Empty( C_PracSm ->cNocSmeZac)         ;
							   .AND. !C_PracSm ->lNocPruzna
					 DsPohyby ->nCasBegPD := TimeToSec( C_PracSm ->cNocSmeZac) /3600
					 cNASTUPSM := "NOC"
				 ENDCASE
			 ENDIF
		 ENDIF

		 IF !Empty( cNASTUPSM) .AND. DsPohyby ->cKodPrerE == "ODC"
			 DO CASE
			 CASE cNASTUPSM == "RAN"       ;
			      .AND. DsPohyby ->nCasEnd >= TimeToSec( C_PracSm ->cRanSmeKon) /3600 ;
			       .AND. DsPohyby ->nCasEnd < TimeToSec( C_PracSm ->cRanSmeKon) /3600 +0.5
   			 DsPohyby ->nCasEndPD := TimeToSec( C_PracSm ->cRanSmeKon) /3600
   			 DsPohyby ->nCasEndSM := TimeToSec( C_PracSm ->cRanSmeKon) /3600

			 CASE cNASTUPSM == "ODP"       ;
			      .AND. DsPohyby ->nCasEnd >= TimeToSec( C_PracSm ->cOdpSmeKon) /3600 ;
			       .AND. DsPohyby ->nCasEnd < TimeToSec( C_PracSm ->cOdpSmeKon) /3600 +0.5
   			 DsPohyby ->nCasEndPD := TimeToSec( C_PracSm ->cOdpSmeKon) /3600
   			 DsPohyby ->nCasEndSM := TimeToSec( C_PracSm ->cOdpSmeKon) /3600

			 CASE cNASTUPSM == "NOC"       ;
			      .AND. DsPohyby ->nCasEnd >= TimeToSec( C_PracSm ->cNocSmeKon) /3600 ;
			       .AND. DsPohyby ->nCasEnd < TimeToSec( C_PracSm ->cNocSmeKon) /3600 +0.5
   			 DsPohyby ->nCasEndPD := TimeToSec( C_PracSm ->cNocSmeKon) /3600
   			 DsPohyby ->nCasEndSM := TimeToSec( C_PracSm ->cNocSmeKon) /3600

			 ENDCASE
		 ENDIF

	   IF !Empty( DsPohyby ->cKodPrer) .AND. !Empty( DsPohyby ->cKodPrerE)
			 IF DsPohyby ->nCasBeg <> 0 .OR. DsPohyby ->nCasEnd <> 0
		     IF DsPohyby ->nCasEnd >= DsPohyby ->nCasBeg
		       DsPohyby ->nCasCel    := DsPohyby ->nCasEnd   -DsPohyby ->nCasBeg
		       DsPohyby ->nCasCelPD  := DsPohyby ->nCasEndPD -DsPohyby ->nCasBegPD
		       DsPohyby ->nCasCelCPD := DsPohyby ->nCasEndPD -DsPohyby ->nCasBegPD
		     ELSE
		       DsPohyby ->nCasCel    := 24 -DsPohyby ->nCasBeg
		       DsPohyby ->nCasCelPD  := 24 -DsPohyby ->nCasBegPD
		       DsPohyby ->nCasCelCPD := 24 -DsPohyby ->nCasBegPD
		       DsPohyby ->nCasCel    += DsPohyby ->nCasEnd
		       DsPohyby ->nCasCelPD  += DsPohyby ->nCasEndPD
		       DsPohyby ->nCasCelCPD += DsPohyby ->nCasEndPD
	       ENDIF

			 nTIME := DsPohyby ->nCasCel*3600
       DsPohyby ->cCasCel := SubStr( SecToTime( nTIME), 1, 5)

			 DsPohyby ->nCasCelCPD := MH_RoundNumb( DsPohyby ->nCasCelCPD, 232)

			 IF DsPohyby ->nCasCelPD <> 0
				 cOLDtag := C_Prerus ->( OrdSetFOCUS( 3))
	       IF C_Prerus ->( dbSeek( DsPohyby ->nKodPrer))
				   IF C_Prerus ->lPrestavka
					   MODIprest()
						 nPrestavka := DsPohyby ->nCasPresta
					 ENDIF
				 ENDIF
				 C_Prerus ->( OrdSetFOCUS( cOLDtag))
			 ENDIF

			 nCelkMPR  += IF( DsPohyby ->cKodPrer == "MPR", DsPohyby ->nCasCelCPD, 0)
			 nCelkPRI  += IF( DsPohyby ->cKodPrer == "PRI", DsPohyby ->nCasCelCPD, 0)
			 nCelkROZD += IF( DsPohyby ->cKodPrer == "PRI", DsPohyby ->nCasCelCPD, 0)

			 IF nCelkPRI > TimeToSec( C_PracSm ->cRanSmeDel) /3600                 ;
				   .AND. cTYPpresc == "PPD"
				 nPrescas := nCelkPRI -TimeToSec( C_PracSm ->cRanSmeDel) /3600
			 ENDIF

	     IF nCelkPRI > 0 .AND. ( cTYPpresc == "PSN" .OR. cTYPpresc == "PSV")
  	     nPrescas := nCelkPRI
 	     ENDIF

			 IF nCelkMPR > 0                                                      ;
					.AND. ( cTYPprescM == "MPD" .OR. cTYPprescM == "MSN" .OR. cTYPprescM == "MSV")
				 nPrescasM := nCelkMPR
			 ENDIF

			 IF ( !Empty( DsPohyby ->cCasEnd) .AND. DsPohyby ->cCasEnd >= "22:00" ;
					    .OR.  DsPohyby ->cCasEnd < DsPohyby ->cCasBeg)                ;
								.AND. ( DsPohyby ->cKodPrer == "PRI" .OR.  DsPohyby ->cKodPrer == "MPR")
				 IF DsPohyby ->cCasEnd < DsPohyby ->cCasBeg
					 IF DsPohyby ->cCasEnd < "06:00"
						 IF DsPohyby ->nCasBeg > 22
				       nCASnoc += DsPohyby ->nCasEnd +( 24 -DsPohyby ->nCasBeg)  //CelPD
				       nCASrec := DsPohyby ->nCasEnd +( 24 -DsPohyby ->nCasBeg)  //CelPD
						 ELSE
				       nCASnoc += DsPohyby ->nCasEnd + 2  //CelPD
				       nCASrec := DsPohyby ->nCasEnd + 2  //CelPD
						 ENDIF
					 ELSE
				     nCASnoc += 8.00                      //CelPD
				     nCASrec := 8.00                      //CelPD
					 ENDIF

//					 IF DsPohyby ->cCasBeg < "22:00"
//						 nCASnoc += 2
//						 nCASrec += 2
//					 ENDIF

				 ENDIF
				 IF DsPohyby ->cCasEnd >= "22:00"
				   nCASnoc +=  DsPohyby ->nCasEnd - 22.00  //   CelPD
				   nCASrec :=  DsPohyby ->nCasEnd  - 22.00  //   CelPD
				 ENDIF
			 ENDIF
			 ENDIF
		 ENDIF

		 DsPohyby ->nCasPresca := 0
		 DsPohyby ->nCasNocPri := 0
		 DsPohyby ->nRozdCasDe := 0

		 IF DsPohyby ->nSaySCR == 1
		 	 nLastREC  := IF( DsPohyby ->cKodPrer == "PRI", DsPohyby ->( Recno()), 0)
		 	 nLastRECm := IF( DsPohyby ->cKodPrer == "MPR", DsPohyby ->( Recno()), 0)
		 ENDIF

     DsPohyby ->( Sx_Unlock())
		 DsPohyby ->( dbSkip())

	 ENDDO
	DsPohyby ->( CLR_SCOPE())

	IF nPrescas > 0
		IF !( lNEW := nRecPres == 0)
			DsPohyby ->( dbGoTo( nRecPres))
			IF( DsPohyby ->lIsManual, nPrescas := DsPohyby ->nCasCelPD, NIL)
		ENDIF

		IF ( cVAL == "PSN" .OR. cVAL == "PSV") .AND. nPrestavka <> 0
		  nPrescas := nPrescas -nPrestavka
		ENDIF

		cVAL := cTYPpresc
		nVAL := MH_RoundNumb( nPrescas, 222)

		IF !lEDIT .OR. nGEN == 4
	    MODIgenpoh( lNEW, cVAL, cKEY, nGEN)

      DsPohyby ->nCasCel    := nVAL
      DsPohyby ->nCasCelPD  := DsPohyby ->nCasCel
		  DsPohyby ->nCasCelCPD := DsPohyby ->nCasCel

	    nTIME := DsPohyby ->nCasCel*3600
      DsPohyby ->cCasCel := SubStr( SecToTime( nTIME), 1, 5)
		  DsPohyby ->( Sx_Unlock())
		  IF ( cTYPpresc == "PSN" .OR. cTYPpresc == "PSV")
				IF( !lNEW, DsPohyby ->( dbGoTo( nRecPresPr)), NIL)
			  IF( DsPohyby ->lIsManual, nPrescas := DsPohyby ->nCasCelPD, NIL)
				cTMP := IF( cTYPpresc == "PSN", "SNP", "SVP")
	      MODIgenpoh( lNEW, cTMP, cKEY, nGEN)

        DsPohyby ->nCasCel    := nVAL
        DsPohyby ->nCasCelPD  := DsPohyby ->nCasCel
		    DsPohyby ->nCasCelCPD := DsPohyby ->nCasCel

	      nTIME := DsPohyby ->nCasCel*3600
        DsPohyby ->cCasCel := SubStr( SecToTime( nTIME), 1, 5)
		    DsPohyby ->( Sx_Unlock())
			ENDIF
		ENDIF

	  DsPohyby ->( dbGoTo( nLastREC))
		IF ReplREC( "DsPohyby")
	    DsPohyby ->nCasPresca := nVAL
		  DsPohyby ->( Sx_Unlock())
		ENDIF
 	ENDIF

	IF nPrescasM > 0
	  IF !( lNEW := nRecPresM == 0)
	    DsPohyby ->( dbGoTo( nRecPresM))
		ENDIF
		cVAL := cTYPprescM
		nVAL := MH_RoundNumb( nPrescasM, 222)


		IF !lEDIT .OR. nGEN == 4
	    MODIgenpoh( lNEW, cVAL, cKEY, nGEN)

      DsPohyby ->nCasCel    := nVAL
      DsPohyby ->nCasCelPD  := DsPohyby ->nCasCel
		  DsPohyby ->nCasCelCPD := DsPohyby ->nCasCel

	    nTIME := DsPohyby ->nCasCel*3600
      DsPohyby ->cCasCel := SubStr( SecToTime( nTIME), 1, 5)
		  DsPohyby ->( Sx_Unlock())
		ENDIF

	  DsPohyby ->( dbGoTo( nLastRECm))
		IF ReplREC( "DsPohyby")
	    DsPohyby ->nCasPresca := nVAL
		  DsPohyby ->( Sx_Unlock())
		ENDIF
 	ENDIF

	IF nCASnoc > 0.00
		IF !( lNEW := nRecNoc == 0)
			DsPohyby ->( dbGoTo( nRecNoc))
		ENDIF
		nVAL := MH_RoundNumb( nCASnoc, 222)

		MODIgenpoh( lNEW, "PNO", cKEY, nGEN)
    DsPohyby ->nCasCel    := nVAL
    DsPohyby ->nCasCelPD  := DsPohyby ->nCasCel
		DsPohyby ->nCasCelCPD := DsPohyby ->nCasCel

	  nTIME := DsPohyby ->nCasCel*3600
    DsPohyby ->cCasCel    := SubStr( SecToTime( nTIME), 1, 5)
		DsPohyby ->( Sx_Unlock())

	  DsPohyby ->( dbGoTo( nLastREC))
		IF ReplREC( "DsPohyby")
	    DsPohyby ->nCasNocPri := nVAL
		  DsPohyby ->( Sx_Unlock())
		ENDIF
 	ENDIF

	IF nCelkROZD > 0
	  DsPohyby ->( dbGoTo( nLastREC))
		IF ReplREC( "DsPohyby")
	    DsPohyby ->nRozdCasDe := nCelkROZD -TimeToSec( C_PracSm ->cRanSmeDel) /3600
		  DsPohyby ->( Sx_Unlock())
		ENDIF
 	ENDIF

	IF( IsNIL( cKEYs), NIL, FORDREC())

RETURN( NIL)


FUNCTION MODIgenpoh( lNEW, cTYP, cKEY, nGEN)
	LOCAL  nBEG, nEND
	LOCAL  cOLDtag := C_Prerus ->( OrdSetFOCUS( 1))

	DEFAULT nGEN TO 1

	C_Prerus ->( dbSeek( Cs_Upper( cTYP)))

 	IF lNEW
 		AddREC( "DsPohyby")

 		DsPohyby ->nOsCisPrac := MsPrc_Md ->nOsCisPrac
 		DsPohyby ->cKmenStrPr := MsPrc_Md ->cKmenStrPr
 		DsPohyby ->cNazPol4   := MsPrc_Md ->cNazPol4
 		DsPohyby ->cRodCisPra := MsPrc_Md ->cRodCisPra
 		DsPohyby ->cIdOsKarty := SubStr( cKEY, 1, 25)     //    Tmp_Term ->cIdOsKarty
 		DsPohyby ->cObdobi    := SubStr( cKEY, 30, 2) +"/"              ;
 		                          +SubStr( cKEY, 28, 2)
 		DsPohyby ->nRok       := Val( SubStr( cKEY, 26, 4))
 		DsPohyby ->nObdobi    := Val( SubStr( cKEY, 30, 2))
 		DsPohyby ->nMesic     := Val( SubStr( cKEY, 30, 2))
 		DsPohyby ->nDen       := Val( SubStr( cKEY, 32, 2))
 		DsPohyby ->dDatum     := cTod( SubStr( cKEY, 32, 2) +"/"        ;
		                                  +SubStr( cKEY, 30, 2) +"/"    ;
  			   															 +SubStr( cKEY, 26, 4))
	  DsPohyby ->cZkrDne    := Left( cDOw( DsPohyby ->dDatum), 2)

 	  DsPohyby ->nCasTMP    := 99.99
		WRT_zmena( "DsPohyby", .T.)

	ELSE
		ReplREC( "DsPohyby")
		WRT_zmena( "DsPohyby", .F.)

	ENDIF

/*
	IF nGEN == 4
		DsPohyby ->cCasBeg := ""
		DsPohyby ->nCasBeg := 0
		DsPohyby ->cCasEnd := ""
		DsPohyby ->nCasEnd := 0
	ENDIF
*/

  DsPohyby ->cKodPrer  := cTYP
  DsPohyby ->nKodPrer  := C_Prerus ->nKodPrer
  DsPohyby ->cKodPrerE := cTYP
  DsPohyby ->nKodPrerE := C_Prerus ->nKodPrer
	DsPohyby ->nNapPrer  := C_Prerus ->nNapPrer
	DsPohyby ->nSaySCR   := C_Prerus ->nSaySCR
	DsPohyby ->nSayCRD   := C_Prerus ->nSayCRD
	DsPohyby ->nPritPrac := C_Prerus ->nPritPrac

	DsPohyby ->nGenREC   := nGEN

	C_Prerus ->( OrdSetFOCUS( cOLDtag))

RETURN( NIL)


STATIC FUNCTION PRUZnaSM_2()
	LOCAL  cKEY, cKEYs
	LOCAL  nTAGold := DsPohyby ->( OrdSetFOCUS( 6))
	LOCAL  nOD, n
	LOCAL  nTMcas, cTMcas

	FOR nOD := 1 TO Tmp_Term ->nDen
		cKEY   := Padr( Cs_Upper( Tmp_Term ->cIdOsKarty), 25)                   ;
										+Cs_Upper( "PRI") +"00.00"                              ;
										 +StrZero( Tmp_Term ->nRok, 4)                          ;
										  +StrZero( Tmp_Term ->nMesic, 2)                       ;
										   +StrZero( nOD, 2)
		IF DsPohyby ->( dbSeek( cKEY))
			 LOOP
		ENDIF
	NEXT

	IF nOD < Tmp_Term ->nDen
// --------- doplnit prvn° den kdy byl na cest†ch a nemÿl konec smÿny --------
		nTMcas := DsPohyby ->nCasBeg +TimeToSec( C_PracSm ->cRanSmDel)/3600
		IF nTMcas <= 24
			cTMcas := SubStr( SecToTime( nTMcas *3600), 1, 5)
		ELSE
			nTMcas := 24 - nTMcas
			cTMcas := SubStr( SecToTime( nTMcas *3600), 1, 5)
		ENDIF

		cKEYs  := MODIpohyby( .F., "ODC", nOD, cTMcas)
    MODIcasy( cKEYs)
		nOD++

		FOR n := nOD TO Tmp_Term ->nDen
			MODIpohyby( .T., "PRI", n, C_PracSm ->cRanSmeZac)

			cTMcas := IF( n = Tmp_Term ->nDen, Tmp_Term ->cCas, C_PracSm ->cRanSmeKon)
 	    cKEYs  := MODIpohyby( .F., "ODC", n, cTMcas)
      MODIcasy( cKEYs)
		NEXT
	ENDIF

	DsPohyby ->( OrdSetFOCUS( nTAGold))

RETURN( NIL)

