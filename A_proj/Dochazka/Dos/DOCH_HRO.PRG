//ÄÄÄÄÄÄÄÄÄÄÄÄDOCHµZKA ze sn¡maŸe U PRACOVNÖKAÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
# Include  '..\DOCHDef_.Ch'

STATIC  paPRERUs
STATIC  cOB_ym
STATIC  axEdit
STATIC  nPOS
STATIC  nZaokBEG
STATIC  nZaokEND


//ÄÄÄÄÄÄÄÄÄÄÄÄDOPLÕUJÖCÖ NABÖDKA NA ALT_WÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
FUNCTION SCR_ALTW()
	Local  N, nPosIN
	Local  cC, cScreen := SaveSCREEN()
	Local  lDONE := .T., lIsRYO := .F.
	Local  GetList
        LOCAL  nRecNo := DsPohyby ->( RecNo())
	LOCAL  cTAGds := DsPohyby ->( OrdSetFOCUS())
	LOCAL  nRECms := MsPrc_Md ->( RecNo())
	LOCAL  cTAGms := MsPrc_Md ->( OrdSetFOCUS())
	LOCAL  aX, aMNu := { { 'hromadnì ~Vstup doch zky ', 'V S T U P      ' }, ;
	  	     	     { 'hromadnì ~PýepoŸet doch. ', 'P ü E P O ¬ E T' }, ;
		     	     { 'hromadn‚ ~Zruçen¡ doch.  ', 'Z R U æ E N Ö  ' }  }
	LOCAL  axDEF_INS

	IF( nPosIN := xCHOICE( aMNu, 4, 50)) <> 0
		DO CASE
		CASE nPosIN == 1    ;   HRO_vstup()
		CASE nPosIN == 2    ;   HRO_prepoc()
		CASE nPosIN == 3    ;   HRO_zrus()
		CASE nPosIN == 4    ;   HRO_prepde()
		ENDCASE

    DsPohyby ->( dbGoTO( nRecNO))
    MsPrc_Md ->( dbGoTO( nRECms))
    DsPohyby ->( OrdSetFOCUS( cTAGds))
    MsPrc_Md ->( OrdSetFOCUS( cTAGms))

//    RestSCREEN( ,,,, cScreen)
//	  ScreenBROW( 1):RefreshALL()
		DCIsUserMODI( "MsPrc_Md", .T.)
	ENDIF

RETURN( NIL)


//ÄÄÄÄÄÄÄÄÄÄÄÄHROMADNí VSTUP PRO DOCHµZKUÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

STATIC FUNCTION HRO_vstup()
	LOCAL  nOldError := DosError( 2001), nCursor := SetCursor( 1)
	LOCAL  nPriREC := 0
	LOCAL  N, nT, nL, nB, nR
	LOCAL  cC, cScreen := SaveScreen()
	LOCAL  aX, GetList := {}
	LOCAL  nTypOPR := SysConfig("Dochazka:nTypOpravn")
	LOCAL  acKODprer, cKODprer := ''
	LOCAL  cKEY

	DC_DcOPEN( { 'c_SVATKY,3', 'c_PRERUS,3', 'c_PRACSM,1'         ;
	           , 'c_PRACDO,1', 'c_INFSUM,3', 'c_OPRAKT,1' } )

	cOB_ym   := ACT_OBDn()
	nZaokBEG := 0
	nZaokEND := 0


	IF nTypOPR > 0
	  IF C_OPRAKT ->( dbSeek( nTypOPR))
	    acKODprer := IF( IsARRAY( C_OPRAKT ->acKODprer), C_OPRAKT ->acKODprer, {} )
	    aEVAL( acKODprer, { |X| cKODprer += X +',' } )
	  ENDIF
	ENDIF

	paPRERUs := {}
	c_PRERUS ->( dbEVAL( { || IF( IF( nTYPopr > 0,                              ;
	                     At( c_PRERUS ->cKODPRER, cKODprer) > 0 , .T.) ,        ;
	                      ( aADD( paPRERUs, ;
	                       { '~' +c_PRERUS ->cKODPRER +'º' +c_PRERUS ->cNAZPRER, ;
    				      c_PRERUS ->nMASKinp , ;
				      c_PRERUS ->nMASKout , ;
				      c_PRERUS ->( RECNO()) } )), NIL)} ))

 	aX := Cards_RES( 'DOCH_Hro.Sc1', .T., .T., .T. )
 	axEdit := Cards ->axCards

        aEval( axEdit, { |X| X[ 4] := DBGetVal( X[ 5]) } )

        Cards_GET( axEdit, { || DOCH_vld( GetList) }, .T., GetList, nT, nL)

	GetList[9]:VarPut( PadC( "pracovn¡ka", 17))
	GetList[9]:Display()

        GetList[5]:READER := { || DOCH_dwn( GETLIST) }
        GetList[7]:READER := { || DOCH_dwn( GETLIST) }
        GetList[9]:READER := { || SWITCH( GETLIST) }

 	IF ReadModal( GetList,,.T.)
	  IF GetList[9]:VarGet() == PadC( "pracovn¡ka", 17) 
	    GENrecDsPo( GetLIST)
  	  ELSE
 	    C_Prerus ->( OrdSetFOCUS( 1))
	    C_Prerus ->( dbSeek( Cs_Upper( GetList[5]:VarGet())))
	    IF TMp_OMETRa( .T., "MsPrc_Md"                                       ;
	  		   , "Hromadn‚ vygenerov n¡ z znam… do doch zky"                    ;
					  , " ... za kmenov‚ stýedisko " +AllTrim( MsPrc_Md ->cKmenStrPr) + " ..." ;
						  , Left( C_Prerus ->cNazPrer, 20)  )

	      cKEY := Cs_Upper( SubStr( AllTrim( GetList[9]:VarGet()), 5, 8))
      	      MsPrc_Md ->( SET_sSCOPE( 4, cKEY))

	       TMp_OMETRa( 1, "MsPrc_Md")
	       DsPohyby ->( OrdSetFOCUS( 11))
	       DO WHILE !MsPrc_Md ->( Eof())
	 	 TMp_OMETRa( , "MsPrc_Md")
	         GENrecDsPo( GetLIST)
	         MsPrc_Md ->( dbSkip())
	       ENDDO
	       TMp_OMETRa( -1, "MsPrc_Md")

	      MsPrc_Md ->( CLR_SCOPE())
	    ENDIF
	  ENDIF
	ENDIF

  ( DosError( nOldError), RestScreen( ,,,, cScreen), SetCursor( nCursor) )

RETURN( NIL)


STATIC FUNCTION GENrecDsPo( GetLIST)
	LOCAL  n
	LOCAL  cKEYs, cFS_day, dFS_DATE
	LOCAL  lNOgen, lNEM, cKEYnem
	LOCAL  xKEY, nI
	LOCAL  lGENsv := .F.
	LOCAL  nRECold, cTAGold

	nI := 0

        FOR n := Day( GetList[3]:VarGet()) TO Day( GetList[4]:VarGet())
   	  IF n == Day( GetList[3]:VarGet())
	    cKEYnem := StrZero( MsPrc_Md ->nOsCisPrac) +DtoS( GetList[3]:VarGet() -1)
	    IF !( lNEM := DsPohyby ->( dbSeek( cKEYnem +Cs_Upper( "NEM"))))
	      lNEM := DsPohyby ->( dbSeek( cKEYnem +Cs_Upper( "OSE")))
	    ENDIF
	  ENDIF
	  dFS_DATE := CTOD( STRZERO( n, 2) +'.' +STRTRAN( ACT_OBDnc(), '/', '.'))
	  cFS_day  := LEFT( CDOW( dFS_DATE), 2)

	  xKEY   := StrZero( MsPrc_Md ->nOsCisPrac) +DtoS( GetList[3]:VarGet() +nI)
	  IF GetList[5]:VarGet() == "SVA"
	    DsPohyby ->( OrdSetFOCUS( 12))
            lNOgen := cFS_day == 'So' .OR. cFS_day == 'Ne' .OR. lNEM
	    lNOgen := lNOgen .OR. DsPohyby ->( dbSeek( xKEY +"1"))
	    lNOgen := lNOgen .OR. !c_SVATKY ->( dbSEEK( cOB_ym +STRZERO( n, 2)))
	  ELSE
            lNOgen := cFS_day == 'So' .OR. cFS_day == 'Ne' .OR. lNEM
	    lGENsv := c_SVATKY ->( dbSEEK( cOB_ym +STRZERO( n, 2))) .AND. !lNOgen
	  ENDIF

         DsPohyby ->( OrdSetFOCUS( 11))
	 lNOgen := lNOgen .OR. DsPohyby ->( dbSeek( xKEY +Cs_Upper( GetList[5]:VarGet())))

  	 IF !lNOgen .OR. lGENsv
	   IF lGENsv
 	     nRECold := C_Prerus ->( Recno())
	     cTAGold := C_Prerus ->( OrdSetFOCUS( 1))
 	     C_Prerus ->( dbSeek( Cs_Upper( "SVA")))
	   ENDIF

           DSPOHYBY ->( dbAPPEND())
           DSPOHYBY ->nROK    := ACT_OBDyn()
	   DSPOHYBY ->nOBDOBI := ACT_OBDon()
	   DSPOHYBY ->nMESIC  := ACT_OBDon()
	   DSPOHYBY ->nDEN    := n
	   DSPOHYBY ->cOBDOBI := ACTObdobi()
           DSPOHYBY ->dDATUM  := dFS_DATE
           DSPOHYBY ->cZKRDNE := cFS_day
	   DSPOHYBY ->nGENREC := 3
	   DSPOHYBY ->lIsManual := .T.

	   DSPOHYBY ->nOsCisPrac := MSPRC_md ->nOsCisPrac
	   DSPOHYBY ->cKmenStrPr := MSPRC_md ->cKmenStrPr
	   DSPOHYBY ->cIdOsKarty := MSPRC_md ->cIdOsKarty
  	   DSPOHYBY ->cRodCisPra := MSPRC_md ->cRodCisPra
  	   DSPOHYBY ->cNazPol4   := MSPRC_md ->cNazPol4

  	   DSPOHYBY ->nNAPpreR  := c_PRERUS ->nNAPpreR

           DsPohyby ->nNapPrer  := C_Prerus ->nNapPrer
	   DsPohyby ->nSaySCR   := C_Prerus ->nSaySCR
	   DsPohyby ->nSayCRD   := C_Prerus ->nSayCRD
	   DsPohyby ->nPritPrac := C_Prerus ->nPritPrac

  	   aEval( GetList, { |X,M| DBPutVal( axEdit[ M, 5], X:VarGet())}, 5)

 	   IF lGENsv
	     DsPohyby ->cKodPreR  := C_Prerus ->cKodPreR
	     DsPohyby ->cKodPreRE := C_Prerus ->cKodPreR
	   ENDIF

           cKEYs := CS_UPPER( DSPOHYBY ->cIdOsKarty) + ;
	                STRZERO ( DSPOHYBY   ->nROK   ) + ;
	                STRZERO ( DSPOHYBY  ->nMESIC ) + ;
	                 STRZERO ( DSPOHYBY ->nDen   )
	   c_PRACSM ->( dbSEEK( CS_UPPER( MSPRC_MD ->cTYPsmeny)))
	   DSPOHYBY  ->( Sx_Unlock())

	   MODICasy( cKEYs, 3)                             // IMP_TERM.prg
	   WRT_zmena( 'DSPOHYBY', .T., .T.)

	   IF lGENsv
	     C_Prerus ->( OrdSetFOCUS( cTAGold))
	     C_Prerus ->( dbGoTo( nRECold))
	   ENDIF
  	 ENDIF
		nI++
	NEXT

RETURN( NIL)


STATIC FUNCTION SWITCH()
	LOCAL  nKEy, nSTEp := 1, nCURSOR := SETCURSOR(0)
	Local  lDONe, nIT
	Local  aC := { 'N*/W*', 'N/W*', 'W/W*' }, pSELs := {}
	Local  O  := GETACTIVE(), xVAL
	LOCAL  n

	n    := O:SubScript[1]
	xVAL := O:VARGET()

        Do While( nKEy := INKEY(.3)) == 0
	  If( nSTEp +1 > 3, nSTEp := 1, nSTEp++ )
	  @ O:ROW, O:COL SAY PadC( xVAL, 17) COLOR aC[nSTEp]    //   'N*/W*'
        EndDo

	IF nKEy == K_SPACE
          xVAL := IF( xVAL ==  PadC( "pracovn¡ka", 17), AllTrim( "stý." + MsPrc_Md ->cKmenStrPr), "pracovn¡ka")
	  O:VarPut( PadC( xVAL, 17))
	ELSE
	  GETapplyKEY( O, nKEy )
	ENDIF

	O:DISPLAY()
	SETCURSOR( nCURSOR)

RETURN( NIL)

Static Function DOCH_dwn( GETLIST)
	Local  nKEy, nSTEp := 1, nCURSOR := SETCURSOR(0), nCARDs, nT, nMASK
	Local  lDONe
	Local  aC := { 'N/BG*', 'R+/BG*', 'B/BG*' }, pSELs := {}
	Local  O  := GETACTIVE(), xVAL
	LOCAL  n

	n := O:SubScript[1]
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
  	  If n == 5  ;  aEVAL( paPRERUs, { |X| If( X[2] <> 0, aADD( pSELs, X ), NIL ) })
	  Else       ;  aEVAL( paPRERUs, { |X| If( X[3] <> 0, aADD( pSELs, X ), NIL ) })
	EndIf

        nT := MAX( O:ROW -2 -LEN( pSELs), 6 )

        If( nCARDs := xCHOICE( pSELs, nT, O:COL() -1, O:ROW -1,,,, 'N/BG,W+/B',, .F. )) <> 0
	  c_PRERUS ->( dbGOTO( pSELs[nCARDs,4]))
	  If n == 5
	    GETLIST[19]:VarPut( c_PRERUS ->nSaySCR)
	    GETLIST[20]:VarPut( c_PRERUS ->nSayCRD)

  	    O:VarPut( c_PRERUS ->cKODPRER)
	    GETLIST[12]:VarPut( c_PRERUS ->nKODPRER)

	    c_PRACSM ->( dbSEEK( CS_UPPER( MSPRC_MD ->cTYPsmeny)))
	    nMASK := pSELs[nCARDs,2]

	    Do Case
	    Case( nMASK == 1 )
	    Case( nMASK == 2 )
	      GETLIST[ 6]:VarPut( c_PRACSM ->cRANsmeZAC)
	      GETLIST[13]:VarPut( TIMETOSEC( c_PRACSM ->cRANsmeZAC)/ 3600)

	    Case( nMASK == 3 )
	      GETLIST[ 7]:VarPut( c_PRERUS ->cKODPRER)
	      GETLIST[14]:VarPut( c_PRERUS ->nKODPRER)

	    Case( nMASK == 4 )
	      GETLIST[ 6]:VarPut( c_PRACSM ->cRANsmeZAC)
	      GETLIST[13]:VarPut( TIMETOSEC( c_PRACSM ->cRANsmeZAC)/ 3600)
	      GETLIST[ 7]:VarPut( c_PRERUS ->cKODPRER)
	      GETLIST[14]:VarPut( c_PRERUS ->nKODPRER)
 	      GETLIST[ 8]:VarPut( c_PRACSM ->cRANsmeKON)
	      GETLIST[15]:VarPut( TIMETOSEC( c_PRACSM ->cRANsmeKON)/ 3600)

	    EndCase
	    aEVAL( GETLIST, {|X| X:DISPLAY() })
	  Else
            O:VarPut( c_PRERUS ->cKODPRER)
	    GETLIST[14]:VarPut( c_PRERUS ->nKODPRER)

	  EndIf
	  GETapplyKEY( O, K_ENTER )
        Else
  	  GETapplyKEY( O, nKEy )
        EndIf

        @ O:ROW, O:COL +LEN( xVAL) SAY ' ' COLOR 'W/B'   // 'W/BG*'
        O:DISPLAY()
        SETCURSOR( nCURSOR)
Return( NIL )


Static Function DOCH_vld( GETLIST)
	Local  nCAS, nCAScel
	Local  lDONe := .T.
	Local  O := GETACTIVE(), xCAS
	LOCAL  n, nX
	LOCAL  nOldTAG, nOldREC

	n := O:SubScript[1]

	DO CASE

	CASE n == 3

	CASE n == 4

	CASE n == 6 .OR. n == 8
	  nCAS := VAL( STRTRAN( STRTRAN( O:VARGET(), ' ', '' ), ':', '.'))
	  xCAS := STRTRAN( STRZERO( nCAS, 5, 2), '.', ':' )

	  If ( nCAS < 0.00 .and. nCAS > 24.00 )
	    ( BOX_AU(), lDONe := .F. )
	  Else
	    If n == 6
	      GETLIST[13]:VarPut( TIMETOSEC( xCAS )/3600)
	    Else
	      GETLIST[15]:VarPut( TIMETOSEC( xCAS )/3600)
	      nCAScel := DOCH_cas( GETLIST[13]:VarGet(), GETLIST[15]:VarGet()    ;
				                      , GETLIST[6]:VarGet(), GETLIST[8]:VarGet() )

	      GETLIST[16]:VarPut( TIMETOSEC( xCAS )/3600)

	      nOldREC := c_PRERUS ->( Recno())
	      nOldTAG := c_PRERUS ->( OrdSetFOCUS( 1))

	      c_PRERUS ->( dbSeek( Cs_Upper( GETLIST[5]:VarGet())))
 	      nX := MH_ROUNDnumb( GETLIST[13]:VarGet(), c_PRERUS ->nKODzaokr)
	      GETLIST[17]:VarPut( nX)
 	      c_PRERUS ->( dbSeek( Cs_Upper( GETLIST[7]:VarGet())))
	      nX := MH_ROUNDnumb( GETLIST[15]:VarGet(), c_PRERUS ->nKODzaokr)
	      GETLIST[18]:VarPut( nX)
	      c_PRERUS ->( OrdSetFOCUS( nOldTAG))
	      c_PRERUS ->( dbGoTo( nOldREC))
	    EndIf
	  EndIf

	  ( O:VARPUT( xCAS ), O:DISPLAY() )
	ENDCASE
Return( lDONe)


//ÄÄÄÄÄÄÄÄÄÄÄÄHROMADNí PüEPO¬ET DOCHµZKYÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

STATIC FUNCTION HRO_prepoc()
	LOCAL  nOldError := DosError( 2001), nCursor := SetCursor( 1)
	LOCAL  nRecNo    := DsPohyby ->( RecNo()), nPriREC := 0
	LOCAL  cC, cScreen := SaveScreen()
	LOCAL  cKEYs

	DC_DcOPEN( { 'c_SVATKY,3', 'c_PRERUS,3', 'c_PRACSM,1', 'c_PRACDO,1', 'c_INFSUM,3' } )
	MsPrc_Md ->( OrdSetFOCUS( 5))

	DsPohyby ->( dbGoTop())

	 DO WHILE !DsPohyby ->( Eof())
	   MsPrc_Md ->( dbSEEK( CS_UPPER( DSPOHYBY ->cIdOsKarty)))
	   cKEYs := CS_UPPER( DSPOHYBY ->cIdOsKarty) + ;
           STRZERO ( DSPOHYBY   ->nROK   ) + ;
	    STRZERO ( DSPOHYBY  ->nMESIC ) + ;
	     STRZERO ( DSPOHYBY ->nDen   )
	   c_PRACSM ->( dbSEEK( CS_UPPER( MSPRC_MD ->cTYPsmeny)))

           MODICasy(cKEYs, 4)                              // IMP_TERM.prg

           WRT_zmena( 'DSPOHYBY', .T., .T. )
           DsPohyby ->( dbSkip())
	 ENDDO

        ( DosError( nOldError), RestScreen( ,,,, cScreen), SetCursor( nCursor) )


RETURN( NIL)


//ÄÄÄÄÄÄÄÄÄÄÄÄHROMADNí PüEPO¬ET DOCHµZKY ZA DENÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

STATIC FUNCTION HRO_prepde()
	LOCAL  nOldError := DosError( 2001), nCursor := SetCursor( 1)
	LOCAL  nRecNo    := DsPohyby ->( RecNo()), nPriREC := 0
	LOCAL  cC, cScreen := SaveScreen()
	LOCAL  cKEYs

	DC_DcOPEN( { 'c_SVATKY,3', 'c_PRERUS,3', 'c_PRACSM,1', 'c_PRACDO,1', 'c_INFSUM,3' } )

	DsPohyby ->( CLR_SCOPE())


	DsPohyby ->( dbGoTop())

	 DO WHILE !DsPohyby ->( Eof())
	   IF DsPohyby ->nDen = 29 .AND. DsPohyby ->nMesic == 11
 	     MsPrc_Md ->( dbSEEK( CS_UPPER( DSPOHYBY ->cIdOsKarty)))
	     cKEYs := CS_UPPER( DSPOHYBY ->cIdOsKarty) + ;
	                STRZERO ( DSPOHYBY   ->nROK   ) + ;
		         STRZERO ( DSPOHYBY  ->nMESIC ) + ;
		          STRZERO ( DSPOHYBY ->nDen   )
	    c_PRACSM ->( dbSEEK( CS_UPPER( MSPRC_MD ->cTYPsmeny)))

            MODICasy(cKEYs, 4)                              // IMP_TERM.prg

            WRT_zmena( 'DSPOHYBY', .T., .T. )
	  ENDIF
          DsPohyby ->( dbSkip())
	ENDDO

        ( DosError( nOldError), RestScreen( ,,,, cScreen), SetCursor( nCursor) )

RETURN( NIL)




//ÄÄÄÄÄÄÄÄÄÄÄÄHROMADN ZRUæENÖ V DOCHµZCEÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

STATIC FUNCTION HRO_zrus()
	LOCAL  nOldError := DosError( 2001), nCursor := SetCursor( 1)
	LOCAL  nPriREC := 0
	LOCAL  N, nT, nL, nB, nR
	LOCAL  cC, cScreen := SaveScreen()
	LOCAL  aX, GetList := {}
	LOCAL  nTypOPR := SysConfig("Dochazka:nTypOpravn")
	LOCAL  acKODprer, cKODprer := ''
	LOCAL  cKEY

	DC_DcOPEN( { 'c_SVATKY,3', 'c_PRERUS,3', 'c_PRACSM,1'         ;
	           , 'c_PRACDO,1', 'c_INFSUM,3', 'c_OPRAKT,1' } )

	cOB_ym   := ACT_OBDn()
	nZaokBEG := 0
	nZaokEND := 0

	IF nTypOPR > 0
	  IF C_OPRAKT ->( dbSeek( nTypOPR))
	    acKODprer := IF( IsARRAY( C_OPRAKT ->acKODprer), C_OPRAKT ->acKODprer, {} )
	    aEVAL( acKODprer, { |X| cKODprer += X +',' } )
	  ENDIF
	ENDIF

	paPRERUs := {}
	c_PRERUS ->( dbEVAL( { || IF( IF( nTYPopr > 0,                              ;
	                     At( c_PRERUS ->cKODPRER, cKODprer) > 0 , .T.) ,        ;
	                      ( aADD( paPRERUs, ;
	                       { '~' +c_PRERUS ->cKODPRER +'º' +c_PRERUS ->cNAZPRER, ;
  				      c_PRERUS ->nMASKinp , ;
				      c_PRERUS ->nMASKout , ;
				      c_PRERUS ->( RECNO()) } )), NIL)} ))

 	aX := Cards_RES( 'DOCH_Hro.Sc2', .T., .T., .T. )
 	axEdit := Cards ->axCards

        aEval( axEdit, { |X| X[ 4] := DBGetVal( X[ 5]) } )

        Cards_GET( axEdit, { || DOCH_vld( GetList) }, .T., GetList, nT, nL)

	GetList[6]:VarPut( PadC( "pracovn¡ka", 17))
	GetList[6]:Display()

        GetList[5]:READER := { || DOCH_dwnZ( GETLIST) }
        GetList[6]:READER := { || SWITCH( GETLIST) }

 	IF ReadModal( GetList,,.T.)
	  IF GetList[6]:VarGet() == PadC( "pracovn¡ka", 17)
	    DELrecDsPo( GetLIST)
	  ELSE
	    C_Prerus ->( OrdSetFOCUS( 1))
	    C_Prerus ->( dbSeek( Cs_Upper( GetList[5]:VarGet())))
	    IF TMp_OMETRa( .T., "MsPrc_Md"                                       ;
			  , "Hromadn‚ zruçen¡ z znam… v doch zce"                          ;
				  , " ... za kmenov‚ stýedisko " +AllTrim( MsPrc_Md ->cKmenStrPr) + " ..." ;
				  , Left( C_Prerus ->cNazPrer, 20)  )

	      cKEY := Cs_Upper( SubStr( GetList[6]:VarGet(), 8))

 	      MsPrc_Md ->( SET_sSCOPE( 4, cKEY))

	      TMp_OMETRa( 1, "MsPrc_Md")
	      DO WHILE !MsPrc_Md ->( Eof())
		TMp_OMETRa( , "MsPrc_Md")
	        DELrecDsPo( GetLIST)
	        MsPrc_Md ->( dbSkip())
	      ENDDO
	      TMp_OMETRa( -1, "MsPrc_Md")

	     MsPrc_Md ->( CLR_SCOPE())
	  ENDIF
	ENDIF
      ENDIF

      ( DosError( nOldError), RestScreen( ,,,, cScreen), SetCursor( nCursor) )

RETURN( NIL)


STATIC FUNCTION DELrecDsPo( GetLIST)
	LOCAL  n
	LOCAL  xKEYod, xKEYdo

	xKEYod := StrZero( MsPrc_Md ->nOsCisPrac) +Cs_Upper( GetList[5]:VarGet()) ;
				   		+DtoS( GetList[3]:VarGet())
	xKEYdo := StrZero( MsPrc_Md ->nOsCisPrac) +Cs_Upper( GetList[5]:VarGet()) ;
				   		+DtoS( GetList[4]:VarGet())

	DsPohyby ->( SET_rSCOPE( 13, xKEYod, xKEYdo))
	 DO WHILE !DsPohyby ->( Eof())
	   DelREC( "DsPohyby")
	   DsPohyby ->( dbSkip())
	 ENDDO
	DsPohyby ->( CLR_SCOPE())

RETURN( NIL)


Static Function DOCH_dwnZ( GETLIST)
	Local  nKEy, nSTEp := 1, nCURSOR := SETCURSOR(0), nCARDs, nT, nMASK
	Local  lDONe
	Local  aC := { 'N/BG*', 'R+/BG*', 'B/BG*' }, pSELs := {}
	Local  O  := GETACTIVE(), xVAL
	LOCAL  n

	n := O:SubScript[1]
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
		aEVAL( paPRERUs, { |X| If( X[2] <> 0, aADD( pSELs, X ), NIL ) })

	  nT := MAX( O:ROW -2 -LEN( pSELs), 6 )

	  If( nCARDs := xCHOICE( pSELs, nT, O:COL() -1, O:ROW -1,,,, 'N/BG,W+/B',, .F. )) <> 0
			c_PRERUS ->( dbGOTO( pSELs[nCARDs,4]))
			O:VarPut( c_PRERUS ->cKODPRER)
			aEVAL( GETLIST, {|X| X:DISPLAY() })
		  GETapplyKEY( O, K_ENTER )
		EndIf

	Else
		GETapplyKEY( O, nKEy )
	EndIf

	@ O:ROW, O:COL +LEN( xVAL) SAY ' ' COLOR 'W/B'   // 'W/BG*'
	O:DISPLAY()
	SETCURSOR( nCURSOR)
	Cards_WHN( O)
Return( NIL )

