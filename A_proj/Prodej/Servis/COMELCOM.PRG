# include 'ComeDef_.Ch'
# Include '..\..\Systems\System.P\Alert_.Ch'
# Include  'FileIO.Ch'

Static nObd, nRok
Static lNetWare
STATIC aTypUct, aUcetPol
STATIC lCONDuct
STATIC lHEAD
STATIC lVsymbol
STATIC nHandle
STATIC cPATHelco, nCOM
STATIC nCelkSKLd
STATIC anCelPKLd

FUNCTION ComElcom()
	LOCAL  n, nPosIN
	LOCAL  cConfig   := fHomAdr() + '\Config'
	LOCAL  lOK
	LOCAL  aX, aMNu := { { '~EXPORT dat na pokladnu ', 'V S T U P      ' }, ;
							    	   { '~IMPORT dat z pokladny  ', 'P ü E P O ¬ E T' }, ;
											 { '~ZmØna OBDOBÖ           ', 'O B D O B Ö    ' }, ;
											 { '~PýepoŸet DPH           ', 'D P H          ' }, ;
											 { '~Pýe£Ÿtov n¡ pohyb…     ', 'é ¬ T U J      ' } }

	lNetWare  := SysConfig("System:lNetWare")
  cPATHelco := AllTrim( SysConfig("Pokladna:cPathRegPo"))
	nCOM      := SysConfig("Pokladna:nComRegPok")

	DO WHILE LastKey() <> K_ESC
	  IF( nPosIN := xCHOICE( aMNu, 1, 13)) <> 0
		  DO CASE
		  CASE nPosIN == 1    ;   ComEl_EXP()
		  CASE nPosIN == 2    ;   ComEl_IMP()
		  CASE nPosIN == 3    ;   UCTo_OBD( 'P', .T.)
		  CASE nPosIN == 4    ;   PrepocDPH()
		  CASE nPosIN == 5    ;   NEW_uctuj()
			ENDCASE
	  ENDIF
	ENDDO
	dbCloseAll()

RETURN( NIL)


STATIC FUNCTION ComEl_EXP()
	Local cColor := SetColor( 'W+/B, N/W+,,, w+/b' )
//  Local cColor := 'N/W,W+/B'
	Local cScreen := SaveScreen()
	Local GetList := {}
	Local cScope
	LOCAL cFileCEN := fNetAdr() + '\Sklady\Dat\Cenik\CenZboz'
	LOCAL cTMP     := fHomAdr() + '\Tmp\'
	LOCAL aX, cKeyDPH
	LOCAL aOutDEF, cOutFILE
	LOCAL aOutDEFex := { { "nRok",    "n",  4, 0 }, { "nObdobi",  "n",  2, 0 }, ;
	                     { "cObdobi", "c",  5, 0 }, { "nOrdItem", "n",  5, 0 }, ;
	                     { "nDoklad", "n", 10, 0 }, { "nPrenos",  "n", 10, 0 } }
	LOCAL cBuff, nLenBuff
	LOCAL cRUNexe, cPATHold
	LOCAL cSkladPokl := AllTrim( SysConfig("Pokladna:cCisSklad"))

  dbUseArea( .t., "SIXCDX", ( cFileCEN),,  if( .T. .or. .F., lNetWare, NIL ), .f. )

	IF Box_YesNo( "Aktualizovat zbo§¡ na pokladnØ ?") = 1
    cOutFILE := cPATHelco +"\TPLU.PRS"
    nHandle  := fCreate( cOutFILE, 0)

	  TMp_OMETRp( .T.,,"Export polo§ek cen¡ku do registraŸn¡ pokladny" )
	  TMp_OMETRp( 1,"CenZboz")

		DO WHILE !CenZboz ->( Eof())

	    TMp_OMETRp( ,"CenZboz")

			if Val(CenZboz ->cCisSklad) = Val(cSkladPokl)
//			@ 11, 12  Say  "Z znam  Ÿ¡slo  " + Str( CenZboz ->( Recno()), 4)

			  cKeyDPH := IF( CenZboz ->nKlicDPH == 2 .OR. CenZboz ->nKlicDPH == 4 ;
			                     , "2", Str( CenZboz ->nKlicDPH, 1))
			  cBuff := AllTrim( CenZboz ->cSklPol) + ";"+ StrTran( SubStr( CenZboz ->cNazZbo, 1, 14), ";", ",") ;
				  			 +";"+ AllTrim( Str( CenZboz ->nCenaMZbo *100, 0))                      ;
					  			 +";"+ "001111"+ Str( CenZboz ->nZboziKat, 1) + "38" ;
						  			 +cKeyDPH +"00" +";"     ;
							  			 + "00000000000000" +";" +AllTrim( Str( CenZboz ->nMnozDZbo, 10, 3))  ;
								  				+ Chr( 13) + Chr( 10)

		    nLenBuff := Len( cBuff)
        IF ( fWrite( nHandle, cBuff, nLenBuff) <> nLenBuff)
          Box_Waring( "Chyba pýi z pisu do souboru ....")
		    ENDIF
			endif

			CenZboz ->( dbSkip())

		ENDDO
    fWrite( nHandle, Chr( 26), 1)
	  fClose( nHandle)

		cPATHold := DiskName() +":" +DirName()
	  cRUNexe  := cPATHelco +"\TxtAlpha 3 " +AllTrim( Str( nCOM, 1))

	  IF DirChange( cPATHelco) == -3
		  DirMake( cPATHelco)
	  ENDIF

 	  SWPRUNCMD( cRUNexe, 0, cPATHelco, "")

		DirChange( cPATHold)

	  TMp_OMETRp( -1, "CenZboz")

 		CenZboz ->( dbCloseArea())

 	ENDIF

  RestSCREEN( ,,,, cScreen)

RETURN( NIL)


STATIC FUNCTION ComEl_IMP()
	Local cColor := SetColor( 'W+/B, N/W+,,, w+/b' )
//  Local cColor := 'N/W,W+/B'
	Local cScreen := SaveScreen()
	Local GetList := {}
	LOCAL aX
	LOCAL cRUNexe, cPATHold

	IF Box_YesNo( "NaŸ¡st data z pokladny ?") = 1
    Load_SAL()
		AKT_Pohyb()

		TmpComel ->( dbCloseArea())
    C_Dph ->( dbCloseArea())
    C_TypUhr ->( dbCloseArea())
    C_DrPohy ->( dbCloseArea())
    PVPHead ->( dbCloseArea())
    PVPItem ->( dbCloseArea())
	  CenZboz ->( dbCloseArea())
	  PVPKumul ->( dbCloseArea())
	  PoklHd ->( dbCloseArea())
	  PoklIt ->( dbCloseArea())
	  C_TypUct ->( dbCloseArea())
	  UcetPre ->( dbCloseArea())
	  UcetPol ->( dbCloseArea())

	  IF File( cPATHelco +"\TPLUSAL.SAL")
	    cPATHold := DiskName() +":" +DirName()
      IF DirChange( cPATHelco) == -3
	      DirMake( cPATHelco)
      ENDIF

	    cRUNexe := cPATHelco +"\TxtAlpha 12 " +AllTrim( Str( nCOM, 1))
//	    cRUNexe := cPATHelco +"\TxtAlpha 12 2"
      SWPRUNCMD( cRUNexe, 0, cPATHelco, "")

	    DirChange( cPATHold)

      FileDelete( cPATHelco +"\TPLUSAL.SAL")

		ENDIF
 	ENDIF

  RestSCREEN( ,,,, cScreen)

RETURN( NIL)


STATIC FUNCTION Load_SAL()
	LOCAL  n, nIT
	LOCAL  nLineLen := 98
	LOCAL  mMemText, cLine
	LOCAL  nCount
	LOCAL  cFileARC
	LOCAL  cImpFILE := fHomAdr() + '\Tmp\TmpCOMEL'
	LOCAL  cRUNexe, cPATHold
	LOCAL  aImpDEF  := { { "C_1", "c",  5, 0 },        { "O_1", "c", 1, 0 } ;
											,{ "C_2", "c", 14, 0 },        { "O_2", "c", 1, 0 } ;
											,{ "C_3", "c",  9, 0 },        { "O_3", "c", 1, 0 } ;
											,{ "C_4", "c", 12, 0 },        { "O_4", "c", 1, 0 } ;
											,{ "C_5", "c", 14, 0 },        { "O_5", "c", 1, 0 } ;
											,{ "C_6", "c", 16, 0 },        { "O_6", "c", 1, 0 } ;
											,{ "C_7", "c",  9, 0 },        { "O_7", "c", 1, 0 } ;
											,{ "C_8", "c",  9, 0 },        { "O_8", "c", 1, 0 } ;
	                    ,{ "cSkladPol",  "c",  5, 0 }, { "cCenaPZBO", "c", 9, 0 } ;
	                    ,{ "cCenaPCZBO", "c", 16, 0 }, { "cMnozSZBO", "c", 9, 0 } ;
										  ,{ "cSklPol",    "c", 15, 0 }, { "nCenaMZBO", "n",11, 2 } ;
											,{ "nCenaMCZBO", "n", 11, 2 }, { "nMnozPrDOD","n",11, 3 } ;
											,{ "cCisSklad",  "c",  8, 0 } }

	dbCreate( cImpFILE, aImpDEF )
	dbUseArea( .t., "SIXCDX", ( cImpFILE),, if( .T. .or. .F., .F., NIL ), .f. )

	TMp_OMETRp( .T.,,"NaŸten¡ dat z registraŸn¡ pokladny" )
	TMp_OMETRp( 1,"TmpCOMEL")

	cPATHold := DiskName() +":" +DirName()
	cFileARC := StrZero( Month( Date()), 2)                       ;
					  	 	+StrZero( Day( Date()), 2)                       ;
				          +SubStr( Time(), 1, 2) + SubStr( Time(), 4, 2)  ;
							 		  +"." +Right(Str(Year(Date())),2)

	IF File( cPATHelco +"\TxtAlpha.Exe")
    IF DirChange( cPATHelco +"\Archiv") == -3
	    DirMake( cPATHelco +"\Archiv")
    ENDIF
	  DirChange( cPATHold)

    IF DirChange( cPATHelco) == -3
	    DirMake( cPATHelco)
    ENDIF

	  cRUNexe    := cPATHelco +"\TxtAlpha 159 " +AllTrim( Str( nCOM, 1))
 	  SWPRUNCMD( cRUNexe, 0, cPATHelco, "")
	  FileCOPY( cPATHelco +"\TPLUSAL.SAL", ( cPATHelco +"\Archiv\" +cFileARC))

	  DirChange( cPATHold)
	ENDIF

	IF File( cPATHelco +"\TPLUSAL.SAL")
    APPEND FROM ( cPATHelco +"\TPLUSAL.SAL") SDF

	  TmpComel ->( dbGoTop())

	  DO WHILE !TmpComel ->( Eof())
	    TMp_OMETRp( ,"TmpCOMEL")

	    TmpCOMEL ->cSkladPol  := TmpCOMEL ->C_1 //Token( cLINE, ";", 1)
	    TmpCOMEL ->cCenaPZBO  := TmpCOMEL ->C_3 //Token( cLINE, ";", 3)
	    TmpCOMEL ->cCenaPCZBO := TmpCOMEL ->C_6 //Token( cLINE, ";", 6)
	    TmpCOMEL ->cMnozSZBO  := TmpCOMEL ->C_7 //Token( cLINE, ";", 7)

	    TmpCOMEL ->cCisSklad  := AllTrim( SysConfig( "Pokladna:cCisSklad"))
	    TmpCOMEL ->cSklPol    := AllTrim( TmpCOMEL ->cSkladPol)
	    TmpCOMEL ->nCenaMZBO  := Val( AllTrim( TmpCOMEL ->cCenaPZBO))
	    TmpCOMEL ->nCenaMCZBO := Val( AllTrim( TmpCOMEL ->cCenaPCZBO))
	    TmpCOMEL ->nMnozPrDOD := Val( AllTrim( TmpCOMEL ->cMnozSZBO))

		  TmpComel ->( dbSkip())
	  ENDDO
	ENDIF

	TMp_OMETRp( -1, "TmpCOMEL")

RETURN( NIL)


STATIC FUNCTION AKT_Pohyb()
	LOCAL cDPH, cTypUhr
	LOCAL cPVPHead, cPVPItem, cFileKum, cFileCen, cDrPohyb
	LOCAL cPoklHd, cPoklIt
	LOCAL cUcetPre, cC_TypUct, cUcetPol
	LOCAL lOK := .T.
	LOCAL aX
	LOCAL nTmpSazDPH

	lCONDuct := .T.
	lHEAD    := .F.
	lVSymbol := SysConfig( "Finance:lVSymbol")

	cDPH      := fNetAdr() +'\Cis\C_Dph'
	cTypUhr   := fNetAdr() +'\Finance\Cis\C_TypUhr'
	cDrPohyb  := fNetAdr() +'\Sklady\Cis\C_DrPohy'
	cPVPHead  := fNetAdr() +'\Sklady\Dat\Pohyby\PVPHead'
	cPVPItem  := fNetAdr() +'\Sklady\Dat\Pohyby\PVPItem'
	cFileKum  := fNetAdr() +'\Sklady\Dat\Pohyby\PVPKumul'
	cFileCen  := fNetAdr() +'\Sklady\Dat\Cenik\CenZboz'
  cPoklHd   := fNetAdr() +'\Pokladna\Dat\PoklHd'
	cPoklIt   := fNetAdr() +'\Pokladna\Dat\PoklIt'
	cUcetPre  := fNetAdr() +'\Ucto\Cis\UcetPre'
	cC_TypUct := fNetAdr() +'\Ucto\Cis\c_TypUct'
	cUcetPol  := fNetAdr() +'\Ucto\Dat\UcetPol'

  dbUseArea( .t., "SIXCDX", ( cDph),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cTypUhr),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cDrPohyb),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPVPHead),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPVPItem),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cFileCEN),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cFileKUM),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPoklHd),,   if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPoklIt),,   if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cC_TypUct),, if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cUcetPre),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cUcetPol),,  if( .T. .or. .F., lNetWare, NIL ), .f. )

	IF !PVPHead ->( FLock()) .OR. !PVPItem ->( FLock()) ;
			.OR. !PoklHd ->( FLock()) .OR. !PoklIt ->( FLock()) ;
		   .OR. !PVPKumul ->( FLock()) .OR. !CenZboz ->( FLock())                     ;
			  .OR. !UcetPol ->( FLock())
		BOX_Waring( "Pýenos nejde uskuteŸnit, nØkdo m  otevýenou spoleŸnou £lohu !")
		Break
		PVPHead ->( dbCloseArea())
		PVPItem ->( dbCloseArea())
		PVPKumul ->( dbCloseArea())
		CenZboz ->( dbCloseArea())
		UcetPol ->( dbCloseArea())
		lOK := .F.
	ELSE
	ENDIF

	IF lOK
    ( aX := Init_TYPuct(), aTypUct := aX[1], aUcetPol := aX[2])

		CenZBOZ ->( OrdSetFOCUS( 3))
    TmpCOMEL ->( dbSetRelation( 'CenZBOZ'  , ;
                     { || Cs_Upper( TmpCOMEL ->cCisSklad) +Cs_Upper( TmpCOMEL ->cSklPol) +"00000"} , ;
										      'Cs_Upper( TmpCOMEL ->cCisSklad) +Cs_Upper( TmpCOMEL ->cSklPol) +"00000"'))
    TmpCOMEL ->( dbSkip( 0))

	  TmpCOMEL ->( dbGoTop())
		TMp_OMETRp( .T.,,"Aktualizace pohyb… v A_SYSTEMU" )
		TMp_OMETRp( 1,"TmpCOMEL")

		fNewHD_fil()
		nCelkSklD := 0
		anCelPKLd := { 0, 0, 0, 0, 0}

	ENDIF

	DO WHILE lOK .AND. !TmpCOMEL ->( Eof())
		TMp_OMETRp( , "TmpCOMEL")

		fPVPit_fil()
		fPOKit_fil()

    UctujPVP()
	  PVPItem ->cUctovano := "u"

		TmpCOMEL ->( dbSkip())
	ENDDO

	PoklHd ->nOsvOdDan  := anCelPKLd[3]
	PoklHd ->nZaklDan_1 := fVypDPH( anCelPKLd[2], anCelPKLd[5])[3]
	PoklHd ->nSazDan_1  := MH_RoundNUM( fVypDPH( anCelPKLd[2],anCelPKLd[5])[2], 32)
	PoklHd ->nZaklDan_2 := fVypDPH( anCelPKLd[1], anCelPKLd[4])[3]
	PoklHd ->nSazDan_2  := MH_RoundNUM( fVypDPH( anCelPKLd[1],anCelPKLd[4])[2], 32)

	PoklHd ->nCenZakCel := anCelPKLd[1] +anCelPKLd[2] +anCelPKLd[3]
	PoklHd ->nCenDanCel := PoklHd ->nZaklDan_1 +PoklHd ->nZaklDan_2
	PoklHd ->nZustPoZaO := PoklHd ->nCenZakCel                                ;
													- ( PoklHd ->nOsvOdDan                            ;
													     +PoklHd ->nZaklDan_1 +PoklHd ->nSazDan_1     ;
															  +PoklHd ->nZaklDan_2 +PoklHd ->nSazDan_2)

	IF( PoklHd ->nSazDan_1  <> 0, UctujOST( {"54","55"}), NIL)
	IF( PoklHd ->nSazDan_2  <> 0, UctujOST( {"56","57"}), NIL)
	IF( PoklHd ->nZustPoZaO <> 0, UctujOST( {"52","53"}), NIL)

	TMp_OMETRp( -1, "TmpCOMEL")

RETURN( NIL)



STATIC FUNCTION fNewHD_fil()
	LOCAL xKEYo, xKEYd
	LOCAL nDoklSKL, nDoklPOK
	LOCAL aX
	LOCAL nSklPohCFG := SysConfig( "Pokladna:nCisPohyb")

	aX := SysConfig( "Sklady:nRangePrij")

	nDoklSKL := aX[1]

	C_TypUhr ->( OrdSetFOCUS( 1))
	C_TypUhr ->( dbSeek( Cs_Upper("Cash")))

	C_DrPohy ->( OrdSetFOCUS( 1))
	C_DrPohy ->( dbSeek( nSklPohCFG))

	IF SysConfig( "Sklady:lRangePVP")
  	aX := SysConfig( "Sklady:nRangeVyde")
 	  xKEYo := "2" +StrZero( aX[1], 6)    // + Ÿ¡seln  ýada u§ivatele
	  xKEYd := "2" +StrZero( aX[2], 6)   // + Ÿ¡seln  ýada u§ivatele
	  PVPHead ->( SET_rSCOPE( 7, xKEYo, xKEYd))
	   PVPHead ->( dbGoBotTom())
	   IF PVPHead ->nDoklad == 0
	     nDoklSKL := SysConfig( "Sklady:nRangeVyde")[1]
	   ELSE
		   nDoklSKL := PVPHead ->nDoklad +1
	   ENDIF
	  PVPHead ->( CLR_SCOPE())
	ELSE
 	  xKEYo := "1"    // + Ÿ¡seln  ýada u§ivatele
	  xKEYd := "999999"    // + Ÿ¡seln  ýada u§ivatele
	  PVPHead ->( SET_rSCOPE( 1, xKEYo, xKEYd))
	   PVPHead ->( dbGoBotTom())
	   IF PVPHead ->nDoklad == 0
	     nDoklSKL := SysConfig( "Sklady:nRangePrij")[1]
	   ELSE
		   nDoklSKL := PVPHead ->nDoklad +1
	   ENDIF
	  PVPHead ->( CLR_SCOPE())
	ENDIF

	xKEYo := StrZero( SysConfig( "Pokladna:nCisKasa"), 3)   // + Ÿ¡seln  ýada u§ivatele
	xKEYd := StrZero( SysConfig( "Pokladna:nCisKasa"), 3)    // + Ÿ¡seln  ýada u§ivatele

	PoklHD ->( SET_rSCOPE( 2, xKEYo, xKEYd))
	 PoklHD ->( dbGoBotTom())

	 nDoklPOK := IF( PoklHD ->nCisFAK == 0                                    ;
	                  , SysConfig( "Pokladna:nRangePoDo")[1]                  ;
										 , PoklHD ->nCisFAK +1)
	PoklHD ->( CLR_SCOPE())

  PVPHead ->( dbAppend())

 	PVPHead ->nDoklad    := nDoklSKL
	PVPHead ->dDatPVP    := Date()
	PVPHead ->cObdPoh    := ACTObdobi()     // SubStr( cObdGET, 1, 3) +SubStr( cObdGET, 6, 2)
	PVPHead ->nRok       := ACT_OBDyn()     // Val( SubStr( cObdGET, 4, 4))
	PVPHead ->nObdobi    := ACT_OBDon()     // Val( SubStr( cObdGET, 1, 2))
	PVPHead ->nCislPOH   := C_DrPohy ->nCislPOH
	PVPHead ->nKarta     := C_DrPohy ->nKarta
	PVPHead ->nTypPoh    := 2
	PVPHead ->cCisSklad  := AllTrim( SysConfig( "Pokladna:cCisSklad"))
	PVPHead ->nCisFak    := nDoklPOK
//	PVPHead ->nCenaDokl  := nCelkDokl
	PVPHead ->dDatLikv   := Date()
	PVPHead ->cUloha     := "P"
	PVPHead ->cDenik     := SysConfig( "Sklady:cDenik")
//	PVPHead ->nLikCelDok := nCelkDokl

	MH_CopyFLD( "PVPHead", "PoklHD", .T.)

	PoklHD ->cDenik     := SysConfig( "Pokladna:cDenikPokl")
	PoklHD ->nKasa      := SysConfig( "Pokladna:nCisKasa")
	PoklHD ->cVarSYM    := AllTrim( Str( PoklHD ->nCisFAK))
	PoklHD ->cObdobi    := PVPHead ->cObdPoh
	PoklHD ->cObdobiDAN := PoklHD ->cObdobi        //  pozor zat¡m
	PoklHD ->cZkrTypUhr := "CASH"
	PoklHD ->nKodZaokr  := C_TypUhr ->nKodZaokr
	PoklHD ->nKodZaokrD := SysConfig( "Finance:nRoundDpH")
	PoklHD ->cZkratMeny := SysConfig( "Finance:cZaklMena")
	PoklHD ->nKonstSymb := 8
	PoklHD ->dVystFAK   := Date()
	PoklHD ->cUserABB   := SysConfig( "System:cUserAbb")

RETURN( NIL)


STATIC FUNCTION fPVPit_fil()

	MH_CopyFLD( "PVPHead", "PVPItem", .T.)

//  nCelkDokl += PVPItem ->nCenaCelk

	  PVPItem ->cSklPol    := CenZBOZ ->cSklPol
	  PVPItem ->cPolCen    := CenZBOZ ->cPolCen
	  PVPItem ->nOrdItem   := TmpCOMEL ->( Recno())
		PVPItem ->nUcetSkup  := CenZBOZ ->nUcetSkup
	  PVPItem ->dDatPVP    := Date()
		PVPItem ->nTypPoh    := -1
		PVPItem ->cNazZbo    := CenZBOZ ->cNazZbo
		PVPItem ->nZboziKat  := CenZBOZ ->nZboziKat
		PVPItem ->nCenNapDod := CenZBOZ ->nCenaSZBO
		PVPItem ->nMnozPrDod := TmpCOMEL ->nMnozPrDod
		PVPItem ->nCenaCelk  := PVPItem ->nCenNapDod *PVPItem ->nMnozPrDod
		PVPItem ->nCenaPDZBO := TmpCOMEL ->nCenaMZBO
		PVPItem ->nKlicDph   := CenZBOZ ->nKlicDph
		PVPItem ->cZkratJedn := CenZBOZ ->cZkratJedn
		PVPItem ->cZkratMeny := CenZBOZ ->cZkratMeny

		PVPItem ->nKlicNS   := 0
	  PVPItem ->cNazPol1  := "160"
	  PVPItem ->cNazPol2  := "601"
	  PVPItem ->cNazPol3  := ""
	  PVPItem ->cNazPol4  := ""
	  PVPItem ->cNazPol5  := ""
	  PVPItem ->cNazPol6  := ""

	  ModiCenZBO( -1)
	  ModiPvpKUM( -1)

   PVPItem ->nMnozSzbo := CenZboz ->nMnozSzbo
   PVPItem ->nCenaCzbo := CenZboz ->nCenaCzbo

   nCelkSklD += PVPItem ->nCenaCelk

RETURN( NIL)


STATIC FUNCTION fPOKit_fil()
	LOCAL n

	C_Dph ->( OrdSetFOCUS( 1))

	MH_CopyFLD( "PoklHD", "PoklIT", .T.)

  PoklIT ->nOrdItem    := TmpCOMEL ->( Recno())
  PoklIT ->cSklPol     := CenZBOZ ->cSklPol
  PoklIT ->cPolCen     := CenZBOZ ->cPolCen
	PoklIT ->cNazZbo     := CenZBOZ ->cNazZbo
	PoklIT ->cZkratJedn  := CenZBOZ ->cZkratJedn
	PoklIT ->nKlicDPH    := CenZBOZ ->nKlicDPH
	PoklIT ->nZboziKat   := CenZBOZ ->nZboziKat

	C_Dph ->( dbSeek( PoklIT ->nKlicDPH))
	PoklIT ->nProcDph    := C_Dph ->nProcDph
	PoklIT ->nNullDph    := C_Dph ->nNullDph
	PoklIT ->nNapocet    := C_Dph ->nNapocet

	DO CASE
	CASE PoklIT ->nKlicDPH == 4
    PoklIT ->nRadVykDph  := 1

	CASE PoklIT ->nKlicDPH == 5
    PoklIT ->nRadVykDph  := 2

	CASE PoklIT ->nKlicDPH == 1
    PoklIT ->nRadVykDph  := 2

	CASE PoklIT ->nKlicDPH == 6
    PoklIT ->nRadVykDph  := 2

	CASE PoklIT ->nKlicDPH == 7
    PoklIT ->nRadVykDph  := 1

	ENDCASE

	PoklIT ->nCenJedZak  := fVypDPH( TmpCOMEL ->nCenaMZBO, PoklIT ->nProcDph)[3]
	PoklIT ->nCenJedZaD  := TmpCOMEL ->nCenaMZBO
	PoklIT ->nCenZakCel  := fVypDPH( TmpCOMEL ->nCenaMCZBO, PoklIT ->nProcDph)[3]
	PoklIT ->nCenZakCeD  := TmpCOMEL ->nCenaMCZBO
	PoklIT ->nSazDan     := PoklIT ->nCenZakCeD - PoklIT ->nCenZakCel

	PoklIT ->nFaktMnoz   := TmpCOMEL ->nMnozPrDOD

	PoklIT ->nCenaBezSl  := PoklIT ->nCenJedZaD

//	n := IF( PoklIT ->nProcDph == 22 .OR. PoklIT ->nProcDph == 19, 1         ;
//	      ,IF( PoklIT ->nProcDph == 5, 2, 3))

	DO CASE
	CASE PoklIT ->nProcDph == 22 .OR. PoklIT ->nProcDph == 19 .OR. PoklIT ->nProcDph == 20
		n := 1
	CASE PoklIT ->nProcDph == 5 .OR. PoklIT ->nProcDph == 9 .OR. PoklIT ->nProcDph == 10
		n := 2
	OTHERWISE
		n := 3
	ENDCASE

	IF( n == 1, anCelPKLd[4] := PoklIT ->nProcDph, NIL)
	IF( n == 2, anCelPKLd[5] := PoklIT ->nProcDph, NIL)

	anCelPKLd[n] += PoklIT ->nCenZakCeD

  PoklIt ->cNazPol1 := "160"
  PoklIt ->cNazPol2 := "601"
  PoklIt ->cNazPol3 := ""
  PoklIt ->cNazPol4 := ""
  PoklIt ->cNazPol5 := ""
  PoklIt ->cNazPol6 := ""

RETURN( NIL)


STATIC FUNCTION fVypDPH( nCELsDPH, nPROcDPH)
	LOCAL anDPH := { 0, 0, 0}

	anDPH[1] := nCELsDPH
	anDPH[2] := ( nCELsDPH /( 100 +nPROcDPH)) * nPROcDPH
	anDPH[3] := anDPH[1] - anDPH[2]

RETURN( anDPH)


STATIC FUNCTION ModiCenZBO( nTYP)
	LOCAL  xKEY

	xKEY := Cs_Upper( PVPItem ->cCisSklad)    ;
	         + Cs_Upper( PVPItem ->cSklPol) +"00000"
/*
	IF !CenZboz ->( dbSeek( xKEY))
		CenZboz ->( dbAppend())

		CenZboz ->cCisSklad  := PVPItem ->cCisSklad
		CenZboz ->cSklPol    := PVPItem ->cSklPol
		CenZboz ->nZboziKat  := PVPItem ->nZboziKat
		CenZboz ->nUcetSkup  := PVPItem ->nUcetSkup
		CenZboz ->cNazZbo    := PVPItem ->cNazZbo
		CenZboz ->cZkratJedn := PVPItem ->cZkratJedn
		CenZboz ->nKlicDph   := PVPItem ->nKlicDph
		CenZboz ->cZkratMeny := PVPItem ->cZkratMeny
		CenZboz ->cPolCen    := PVPItem ->cPolCen
	  CenZboz ->cTypSklCen := "PEV"
	ENDIF
*/
	CenZboz ->nMnozSzbo  += PVPItem ->nMnozPrDOD *( nTYP)
	CenZboz ->nMnozDzbo  += PVPItem ->nMnozPrDOD *( nTYP)
	CenZboz ->nCenaCzbo  += PVPItem ->nCenaCELK  *( nTYP)

	CenZboz ->nCenaSzbo  := Round( CenZboz ->nCenaCzbo /CenZboz ->nMnozSzbo, 2)
	CenZboz ->nCenaSvzm  := CenZboz ->nCenaSzbo
	CenZboz ->nCenaNzbo  := PVPItem ->nCenNapDOD
	CenZboz ->nCenaKurz  := PVPItem ->nCenNapDOD
	CenZboz ->dDatPZbo   := PVPItem ->dDatPVP

RETURN( NIL)


STATIC FUNCTION ModiPvpKUM( nTYP)
	LOCAL  xKEY
	LOCAL  dX

	PVPKumul ->( OrdSetFOCUS( 2))

	xKEY := Cs_Upper( PVPItem ->cCisSklad) +Cs_Upper( PVPItem ->cSklPol)   ;
	         + StrZero( PVPItem ->nRok, 4) +StrZero( PVPItem ->nObdobi, 2)

	IF !PVPKumul ->( dbSeek( xKEY))
		PVPKumul ->( dbAppend())

		PVPKumul ->nRok       := PVPItem ->nRok
		PVPKumul ->nObdobi    := PVPItem ->nObdobi
		PVPKumul ->cObdPoh    := PVPItem ->cObdPoh
		PVPKumul ->cCisSklad  := PVPItem ->cCisSklad
		PVPKumul ->cSklPol    := PVPItem ->cSklPol
		PVPKumul ->nZboziKat  := PVPItem ->nZboziKat
		PVPKumul ->nUcetSkup  := PVPItem ->nUcetSkup
		PVPKumul ->cPolCen    := PVPItem ->cPolCen
	  PVPKumul ->nPoradi    := PVPItem ->nObdobi
	ENDIF

	PVPKumul ->nMnozPrij  += PVPItem ->nMnozPrDOD *( nTYP)
	PVPKumul ->nMnozKon   += PVPItem ->nMnozPrDOD *( nTYP)
	PVPKumul ->nCenaPrij  += PVPItem ->nCenaCELK  *( nTYP)
	PVPKumul ->nCenaKon   += PVPItem ->nCenaCELK  *( nTYP)
	PVPKumul ->dDatPVP    := PVPItem ->dDatPVP

	dX := dToC( PVPItem ->dDatPVP)
	PVPKumul ->cDatPosAkt := Str( PVPItem ->nRok, 4)                  ;
	                          +SubStr( dX, 4, 2) +SubStr( dX, 1, 2)

RETURN( NIL)


STATIC FUNCTION UctujPVP()
	LOCAL  xKEY
	LOCAL  lOK
	LOCAL  n
	LOCAL cUCET

	// £Ÿtov n¡ jednoho ý dku v souboru MZDY
	xKEY := Cs_Upper( "P") + StrZero( PVPItem ->nCislPoh, 5)
  UcetPre ->( SET_rSCOPE( 1, xKEY, xKEY))
  IF ( lOK := UcetPre ->( Sx_KeyCount()) <> 0)
    DO WHILE !UcetPre ->( Eof())
	    IF ( PVPItem ->nUcetSkup >= UcetPre ->nOD                             ;
						   .AND. PVPItem ->nUcetSkup <= UcetPre ->nDO)                  ;
				 	      .AND. flOkUCT( UcetPre ->mPodUct)
				FOR n := 1 TO 2
//				  If( lIsTOPs, lIsTOPs := .F., UcetPol ->( dbSkip()))
				  cUCET := IF( n == 1, UcetPre ->cTypUctMD, UcetPre ->cTypUctDAL)
  	      UcetPol_WRT( cUCET, UcetPol->( Eof()))
			  NEXT
			ENDIF
	    UcetPre ->( dbSkip())
	  ENDDO
  ENDIF

  UcetPre ->( Clr_Scope())

RETURN( NIL)


FUNCTION Init_TYPUCT()
	LOCAL xKEY    := Cs_Upper( "P")
	LOCAL nOldRec := c_TypUct ->( RecNo())
	LOCAL aX, aIT, aPom
	LOCAL aTyp, aUcPred

	( aTyp := {}, aUcPred := {}, aPom := {} )

	c_TypUct ->( SET_sSCOPE( 1, xKey))
	 DO WHILE !c_TypUct ->( EOF())
	   AADD( aTyp, c_TypUct ->cTypUct)

		 ( aX   := c_TypUct ->mPopisUCT, aPom := {} )

     aEval( aX, { |X| ;
	                    ( aIT    := ListAsArray( X)                         , ;
			 	  					    AADD( aIT, UcetPol ->( FieldPos( aIT[ 1])))       , ;
										    AADD( aIT, COMPILE( STRTRAN( aIT[ 2], '.', ','))) , ;
										    AADD( aPom, aIT)                                  )})

		 ( AADD( aUcPred, aPom), c_TypUct ->( dbSkip()))
   ENDDO
	c_TypUct ->( CLR_sSCOPE( 1, nOldRec))

RETURN( { aTyp, aUcPred})


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄProvede za£Ÿtov n¡ dle pý¡sluçn‚ho typu £Ÿtov n¡ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

FUNCTION UcetPol_WRT( cTYP, lDBAp)
	LOCAL  xVAL
	LOCAL  n
	LOCAL  nTYPi, nDenDokl
	LOCAL  lOK := .T.
	LOCAL  bCondUCT := If( lCONDUCT, ;
	                     { || !Empty( UcetPol ->cUcetMD)  .and. ;
		                        !Empty( UcetPol ->cUcetDAL) .and. ;
		                        ( UcetPol ->nKcMD +UcetPol ->nKcDAL <> 0 ) }, ;
											 { || ( UcetPol ->nKcMD +UcetPol ->nKcDAL <> 0 ) }  )

	nTYPi := AScan( aTypUct, cTYP)

/*
	IF lDBAp
		W_DelRepl( "UcetPol")
//		UcetPol ->( dbAppend())
	ELSE
    UcetPol ->( SX_RLOCK()) /// pozor je tu nebezpeŸ¡ §e by mohl bìt z znam lock

		( UcetPol ->nKcMD     := 0, UcetPol ->nKcDAL    := 0)
		( UcetPol ->nMnozNat  := 0, UcetPol ->nMnozNat2 := 0)
		ENDIF
*/
	UcetPol ->( dbAppend())

//  IF cTYP == "90" .OR. cTYP == "91"
	UcetPol ->cDenik := SysConfig( "Pokladna:cDenikPokl")
//	ENDIF

  UcetPol ->cUloha    := "P"

/*
	UcetPol ->cObdobi   := PVPtem ->cObdobi
	UcetPol ->nRok      := PVPItem ->nRok
	UcetPol ->nObdobi   := PVPItem ->nObdobi

	UcetPol ->nDoklad   := PVPItem Mzdy ->nDoklad
	UcetPol ->nOrdItem  := PVPItem ->nOrdItem
	UcetPol ->cTypUct   := AllTrim( cTYP)

// UcetPol ->cSymbol   := VARsym( )

*/
//	UcetPol ->cUserAbb  := cUser
	UcetPol ->dDatZmeny := Date()
	UcetPol ->cCasZmeny := Time()

	aEval( aUcetPOL[nTYPi], { |X| ( UcetPol ->( FieldPut( X[3], Eval( X[4]))))})

//	If( lOK := Eval( bCondUCT), Nil, UcetPOL ->( dbDelete()) )
//	If( !lCONDUCT .and. !lOK .and. UcetPOL ->nOrdITEM == 1, lOK := .T., Nil )

	UcetPol ->( SX_UnLOCK())

RETURN( lOK)


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Test na splnØn¡ podm¡nky £Ÿtov n¡ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
STATIC FUNCTION flOkUCT( cVAR)
RETURN( If( !Empty( cVAR), &cVAR, .T.))


FUNCTION VSymbol()
	LOCAL  cX
	LOCAL cFILE

	cFILE := IF( lHEAD, "PVPHead", "PVPItem")
  cX := IF( lVSymbol, AllTrim( Str( ( cFILE) ->nCisFak)) ;
                       , AllTrim( Str( ( cFILE) ->nCisloDL)))
RETURN( cX)


STATIC FUNCTION LastDokl()
	LOCAL  aX
	LOCAL  nDokl
	LOCAL  lOK := .T.
	LOCAL  nOldTag := PVPHead ->( OrdSetFocus( 7))

	aX := SysConfig( "Sklady:nRangePrij")

	nDokl := aX[1]

  PVPHead ->( Sx_SetScope( 0, "1" +StrZero( aX[1], 6)))
   PVPHead ->( Sx_SetScope( 1, "1" +StrZero( aX[2], 6)))

	 PVPHead ->( dbGoBotTom())
	 DO WHILE lOK .AND. PVPHead ->( Recno()) <> 1
		 IF PVPHead ->( Deleted())
			 PVPHead ->( dbSkip( -1))
		 ELSE
   	   nDokl := PVPHead ->nDoklad +1
			 lOK   := .F.
		 ENDIF
	 ENDDO

   PVPHead ->( Sx_ClrScope( 0))
  PVPHead ->( Sx_ClrScope( 1))

	PVPHead ->( OrdSetFocus( nOldTag))

RETURN( nDokl)


FUNCTION RozdilPrij()
RETURN( PVPHead ->nRozPrij)


STATIC FUNCTION UctujOST( aTYPu)
  UcetPol_WRT( aTYPu[1], UcetPol->( Eof()))
  UcetPol_WRT( aTYPu[2], UcetPol->( Eof()))
RETURN( NIL)


STATIC FUNCTION PrepocDPH()
	LOCAL cDPH, cTypUhr
	LOCAL cPVPHead, cPVPItem, cFileKum, cFileCen, cDrPohyb
	LOCAL cPoklHd, cPoklIt
	LOCAL cUcetPre, cC_TypUct, cUcetPol
	LOCAL lOK := .T.
	LOCAL aX
	LOCAL nTmpSazDPH, xKEY

	lCONDuct := .T.
	lHEAD    := .F.
	lVSymbol := SysConfig( "Finance:lVSymbol")

	cDPH      := fNetAdr() +'\Cis\C_Dph'
  cPoklHd   := fNetAdr() +'\Pokladna\Dat\PoklHd'
	cPoklIt   := fNetAdr() +'\Pokladna\Dat\PoklIt'
	cUcetPre  := fNetAdr() +'\Ucto\Cis\UcetPre'
	cC_TypUct := fNetAdr() +'\Ucto\Cis\c_TypUct'
	cUcetPol  := fNetAdr() +'\Ucto\Dat\UcetPol'
	cDrPohyb  := fNetAdr() +'\Sklady\Cis\C_DrPohy'
	cPVPHead  := fNetAdr() +'\Sklady\Dat\Pohyby\PVPHead'
	cPVPItem  := fNetAdr() +'\Sklady\Dat\Pohyby\PVPItem'

  dbUseArea( .t., "SIXCDX", ( cDph),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPoklHd),,   if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPoklIt),,   if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cC_TypUct),, if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cUcetPre),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cUcetPol),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cDrPohyb),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPVPHead),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPVPItem),,  if( .T. .or. .F., lNetWare, NIL ), .f. )

	IF !PoklHd ->( FLock()) .OR. !PoklIt ->( FLock()) ;
		    .OR. !UcetPol ->( FLock())
		BOX_Waring( "Pýenos nejde uskuteŸnit, nØkdo m  otevýenou spoleŸnou £lohu !")
		Break
		UcetPol ->( dbCloseArea())
		lOK := .F.
	ELSE
	ENDIF

	IF lOK
    ( aX := Init_TYPuct(), aTypUct := aX[1], aUcetPol := aX[2])

		xKey := Cs_Upper( ACTObdobi())
	  PoklHD ->( SET_sSCOPE( 4, xKey))

	  PoklHD ->( dbGoTop())
		TMp_OMETRp( .T.,,"PýepoŸet DPH" )
		TMp_OMETRp( 1,"PoklHD")

//		fNewHD_fil()
//		nCelkSklD := 0
		anCelPKLd := { 0, 0, 0, 0, 0}

	ENDIF

	DO WHILE lOK .AND. !PoklHD ->( Eof())
		TMp_OMETRp( , "PoklHD")
		anCelPKLd := { 0, 0, 0, 0, 0}

		fPoklIT()
//		fPOKit_fil()

//    UctujPVP()
//	  PVPItem ->cUctovano := "u"

	  PoklHd ->nOsvOdDan  := anCelPKLd[3]
	  PoklHd ->nZaklDan_1 := fVypDPH( anCelPKLd[2], anCelPKLd[5])[3]
	  PoklHd ->nSazDan_1  := MH_RoundNUM( fVypDPH( anCelPKLd[2],anCelPKLd[5])[2], 32)
	  PoklHd ->nZaklDan_2 := fVypDPH( anCelPKLd[1], anCelPKLd[4])[3]
	  PoklHd ->nSazDan_2  := MH_RoundNUM( fVypDPH( anCelPKLd[1],anCelPKLd[4])[2], 32)

	  PoklHd ->nCenZakCel := anCelPKLd[1] +anCelPKLd[2] +anCelPKLd[3]
	  PoklHd ->nCenDanCel := PoklHd ->nZaklDan_1 +PoklHd ->nZaklDan_2
	  PoklHd ->nZustPoZaO := PoklHd ->nCenZakCel                                ;
		   											- ( PoklHd ->nOsvOdDan                            ;
			  									     +PoklHd ->nZaklDan_1 +PoklHd ->nSazDan_1     ;
															  +PoklHd ->nZaklDan_2 +PoklHd ->nSazDan_2)

//	  IF( PoklHd ->nSazDan_1  <> 0, UctujOST( {"54","55"}), NIL)
//	  IF( PoklHd ->nSazDan_2  <> 0, UctujOST( {"56","57"}), NIL)
//	  IF( PoklHd ->nZustPoZaO <> 0, UctujOST( {"52","53"}), NIL)

		PoklHD ->( dbSkip())
	ENDDO
  TMp_OMETRp( -1, "PoklHD")

RETURN( NIL)

STATIC FUNCTION fPOKlit()
	LOCAL n, xKey

	xKey := StrZero( PoklHD ->nKasa) +StrZero( PoklHD ->nCisFak)
  PoklIT ->( SET_sSCOPE( 1, xKey))
 	 DO WHILE !PoklIT ->( Eof())
//	 	 n := IF( PoklIT ->nProcDph == 22 .OR. PoklIT ->nProcDph == 19, 1         ;
//	        	,IF( PoklIT ->nProcDph == 5, 2, 3))

	   DO CASE
	   CASE PoklIT ->nProcDph == 22 .OR. PoklIT ->nProcDph == 19 .OR. PoklIT ->nProcDph == 20
		   n := 1
	   CASE PoklIT ->nProcDph == 5 .OR. PoklIT ->nProcDph == 9 .OR. PoklIT ->nProcDph == 10
		   n := 2
	   OTHERWISE
		   n := 3
	   ENDCASE

	   IF( n == 1, anCelPKLd[4] := PoklIT ->nProcDph, NIL)
	   IF( n == 2, anCelPKLd[5] := PoklIT ->nProcDph, NIL)

     anCelPKLd[n] += PoklIT ->nCenZakCeD
		 PoklIT ->( dbSkip())
	 ENDDO
  PoklIT ->( CLR_SCOPE())

RETURN( NIL)


STATIC FUNCTION NEW_uctuj()
	LOCAL cDPH, cTypUhr
	LOCAL cPVPHead, cPVPItem, cFileKum, cFileCen, cDrPohyb
	LOCAL cPoklHd, cPoklIt
	LOCAL cUcetPre, cC_TypUct, cUcetPol
	LOCAL lOK := .T.
	LOCAL aX
	LOCAL nTmpSazDPH
	LOCAL xKEYo, xKEYd

	lNetWare := .F.
	lCONDuct := .T.
	lHEAD    := .F.
	lVSymbol := SysConfig( "Finance:lVSymbol")

	cDPH      := fNetAdr() +'\Cis\C_Dph'
	cTypUhr   := fNetAdr() +'\Finance\Cis\C_TypUhr'
	cDrPohyb  := fNetAdr() +'\Sklady\Cis\C_DrPohy'
	cPVPHead  := fNetAdr() +'\Sklady\Dat\Pohyby\PVPHead'
	cPVPItem  := fNetAdr() +'\Sklady\Dat\Pohyby\PVPItem'
	cFileKum  := fNetAdr() +'\Sklady\Dat\Pohyby\PVPKumul'
	cFileCen  := fNetAdr() +'\Sklady\Dat\Cenik\CenZboz'
  cPoklHd   := fNetAdr() +'\Pokladna\Dat\PoklHd'
	cPoklIt   := fNetAdr() +'\Pokladna\Dat\PoklIt'
	cUcetPre  := fNetAdr() +'\Ucto\Cis\UcetPre'
	cC_TypUct := fNetAdr() +'\Ucto\Cis\c_TypUct'
	cUcetPol  := fNetAdr() +'\Ucto\Dat\UcetPol'

  dbUseArea( .t., "SIXCDX", ( cDph),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cTypUhr),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cDrPohyb),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPVPHead),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPVPItem),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cFileCEN),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cFileKUM),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPoklHd),,   if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cPoklIt),,   if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cC_TypUct),, if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cUcetPre),,  if( .T. .or. .F., lNetWare, NIL ), .f. )
  dbUseArea( .t., "SIXCDX", ( cUcetPol),,  if( .T. .or. .F., lNetWare, NIL ), .f. )

  ( aX := Init_TYPuct(), aTypUct := aX[1], aUcetPol := aX[2])

  xKEYo := 2346    // + Ÿ¡seln  ýada u§ivatele
  xKEYd := 2383    // + Ÿ¡seln  ýada u§ivatele
  PoklIt ->( SET_rSCOPE( 2, xKEYo, xKEYd))
  PoklIt ->( dbGoTop())

	PVPItem ->(OrdSetFOCUS( 10))

	DO WHILE !PoklIt ->( Eof())
		TMp_OMETRp( , "PoklIt")
		if PVPItem->( dbSeek( Cs_Upper( "S ")+StrZero(PoklIt->nDoklad)+StrZero(PoklIt->nOrdItem)))
      UctujPVP()
	    PVPItem ->cUctovano := "u"
		EndIf

		PoklIt ->( dbSkip())
	ENDDO

//	IF( PoklHd ->nSazDan_1  <> 0, UctujOST( {"54","55"}), NIL)
//	IF( PoklHd ->nSazDan_2  <> 0, UctujOST( {"56","57"}), NIL)
//	IF( PoklHd ->nZustPoZaO <> 0, UctujOST( {"52","53"}), NIL)

	TMp_OMETRp( -1, "PoklIt")

RETURN( NIL)





