# INCLUDE  'Inkey.Ch'
# INCLUDE  'Common.Ch'
# INCLUDE  'SetCurs.Ch'
# INCLUDE  'dbStruct.Ch'
# INCLUDE  'C:\Lego.Wk\SystemN\CsModi_.Ch'

# DEFINE   IsSET         CHR( 139)
# DEFINE   CHECK         1
# DEFINE   COMBO         2
# DEFINE   LISTBOX       3
# DEFINE   COMPILE( C)   &("{||" + C + "}")
# DEFINE   PASSW         'Miss'

STATIC   cHOT
STATIC   aBUT, nBUT
STATIC   nMaxPict := 3      //  ...
STATIC   nAktROW
STATIC   lAKT

//ÚÄ< MENU intern¡ch parametr… >ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FUNCTION MenuCFG( nT, nL, nB, nR )
	Local  cCfgFILE := FHomAdr() + '\Cfg'
	Local  nKEY, nPos, nArea := SELECT()
	Local  cTypPARAM
	Local  lDO := YES
	Local  B, C

	DEFAULT nT TO 3, nL TO 3, nR TO 58
	DEFAULT cHOT TO ''

	RestPARAMs()
	dbSelectArea( 'CFG')
	CFG->( dbEval( {|| If( !EMPTY( CFG->cPicture),;
	            nMaxPict := MAX( nMaxPict, Len( AllTrim( CFG->cPicture))), Nil) }))
	nMaxPict := MIN( nMaxPict, 25 )
	nB := MIN( CFG->( LastRec()) + 4, 21)
	nR := nL + 30 + nMaxPict + 6
  DispBox( nT, nL, nB, nR, 'ÉÍ»º¼ËÈÊ ', 'W+/W')
  BoxShadow( nT, nL, nB, nR )

	B  := TBrowseDB( nT+1, nL+1, nB-1, nR-1 )
  B:colorSpec := 'N/W, W+/B, B/W*, N+/W, W/B, N/GR*'
	C := TBColumnNew( , {|| ' ' + CFG->cName + IF( EMPTY( CFG->cTyp), '   ', ' = ')+;
	                  + InColumn() + ' ' })
	C:ColorBlock := {||  IF( CFG->lActive, { 1,2}, {4,5} ) }
	B:AddColumn( C)
	CFG->( dbGoTop())

  DO WHILE lDo
		B:ForceStable()
    If( ( B:hitTop .or. B:hitBottom ), Tone( 125, 0 ), Nil )
	  B:RefreshAll():ForceStable()
//		HiLiHOT( B)
		//Ä Hodnota parametru
		nAktROW := B:RowPOS()+3
		ColorWIN( nAktROW, B:nRight - MIN( LEN( ALLTRIM( CFG->cPicture)), 25),;
		          nAktROW, B:nRight -1,;
		          IF( EMPTY( CFG->cTyp), 'n/w', 'W+/B*') )
		@ 24, 0 SAY PADC( ALLTRIM( CFG->cHelpLINE), 80) Color 'N/W'
		SetPOS( nAktROW, COL() )

		nKEY := INKEY( 0)

    IF !MoveCursKey( B, nKEY )
			DO CASE
				CASE nKEY == K_F1         ;  HelpPARAM( NO )
				CASE nKEY == K_ALT_F1     ;  HelpPARAM( YES)
				CASE nKEY == K_F2         ;  MemoWRIT( FHOMADR() + '\TMP\' + ALLTRIM( CFG->cItem), MemoTRAN( CFG->mHELP) )
				CASE nKEY == K_ALT_F11    ;  CFG->lActive := !CFG->lActive
				CASE nKEY == K_ESC        ;  lDO := NO
			  CASE nKEY == K_ENTER .OR. ;
						 ( nPos := AT( UPPER( CHR( nKEY)), cHOT)) > 0
				  IF nKEY <> K_ENTER
				    IF CFG->( dbSeek( nPos))
				 	     B:Configure()
				 	     B:RefreshCurrent()
				 	     B:ForceStable()
				    ENDIF
				  ENDIF
					IF EMPTY( CFG->cBlocks)  //Ä Standartn¡ zpracov n¡
						cTypPARAM := AllTrim( Upper( CFG->cTypPARAM ))
						DO CASE
							CASE cTypPARAM == 'CHECKBOX_G'  ;  STD_CheckBox()
							CASE cTypPARAM == 'CHECKBOX_S'
							CASE cTypPARAM == 'ALPHANUM'    ;  STD_AlphaNum( B)
							CASE cTypPARAM == 'COMBOBOX_G'  ;  STD_CheckBox( COMBO)
							CASE cTypPARAM == 'COMBOBOX_S'  ;  STD_ComboBox( B)
							CASE cTypPARAM == 'LISTBOX'     ;  STD_ListBox()
//							CASE cTypPARAM == 'EDITLINE'    ;  STD_EditLine()
						ENDCASE
					ELSE                     //Ä Specifick‚ zpracov n¡
				    EVAL( COMPILE( CFG->cBlocks))
					ENDIF
			ENDCASE
		ENDIF
	ENDDO
	SavePARAMs()
	dbSelectArea( nArea)
RETURN NIL

//ÄÄÄ< Ulo§en¡ aktivaŸn¡ho nastaven¡ >ÄÄÄ
STATIC FUNCT SavePARAMs()
	Local aSavVAL, axValue
	Local cSavVAL := '', cTag := CFG->( OrdSetFocus( 2))

	CFG->( dbGoTop())
	DO WHILE !CFG->( EOF())
 		 aSavVAL := {}
	   //Ä Ulo§en¡ pý¡stupu v menu ( lActive)
		 AADD( aSavVAL, CHARXOR( CFG->cItem + IF( CFG->lActive, 'Y', 'N'), PASSW ) )
		 //Ä Ulo§en¡ hodnot parametr… ( cValue)
		 AADD( aSavVAL, CHARXOR( CFG->cValue, PASSW ) )
	   //Ä Ulo§en¡ hodnot parametr… ( axValue) ...
		 IF IsARRAY( CFG->axValue)
		   cSavVAL := ''
		   AEVAL( CFG->axValue, {|X,N| cSavVAL += STRZERO( N, 2 ) + LEFT( X, 1) } )
		   AADD( aSavVAL, CHARXOR( cSavVAL, PASSW ) )
		 ELSE
		   AADD( aSavVAL, NIL )
		 ENDIF
		 CFG->aSavVAL := aSavVAL

		 CFG->( dbSKIP())
	ENDDO

	CFG->( OrdSetFocus( cTag))
RETURN Nil

//ÄÄÄ< Obnoven¡ aktivaŸn¡ho nastaven¡ >ÄÄÄ
STATIC FUNCT RestPARAMs()
	Local cSavVAL, cItem, cTag := CFG->( OrdSetFocus( 2))
	Local N, nPOS, axValue, aSavVAL

	CFG->( dbGoTop())
	DO WHILE !CFG->( EOF())
		 aSavVAL := IF( IsARRAY( CFG->aSavVAL), CFG->aSavVAL, { NIL, NIL, NIL} )
		 // aSavVAL := CFG->aSavVAL
	   //Ä Obnova pý¡stupu v menu
		 IF !IsNIL( aSavVAL[ 1] )
		 	  cSavVAL := CHARXOR( aSavVAL[ 1], PASSW )
		    CFG->lActive := IF( UPPER( RIGHT( cSavVAL, 1)) == 'Y', YES, NO)
		 ENDIF
		 //Ä Obnova hodnot parametr… ( cValue)
		 IF !IsNIL( aSavVAL[ 2] )
		 	  cSavVAL := CHARXOR( aSavVAL[ 2], PASSW )
		    CFG->cValue := cSavVAL
		 ENDIF
	   //Ä Obnova hodnot parametr… ( axValue) ...
		 IF !IsNIL( aSavVAL[ 3] )
		 	  cSavVAL := CHARXOR( aSavVAL[ 3], PASSW )
		    axValue := CFG->axValue
				nPOS := 0
		    DO WHILE LEN( cSavVAL) > 0 .AND. nPOS < LEN( axValue)
			     cItem := LEFT( cSavVAL, 3)
				   nPOS  := VAL( LEFT( cItem, 2))
				   axValue[ nPOS] := RIGHT( cItem, 1) + SUBSTR( axValue[ nPOS], 2 )
			     cSavVAL := SUBSTR( cSavVAL, LEN( cItem) +1)
		    ENDDO
		    CFG->axValue := axValue
		 ENDIF

		 CFG->( dbSKIP())
	ENDDO
	CFG->( OrdSetFocus( cTag))
RETURN Nil

//ÄÄÄ< Vysv¡cen¡ Hot-kl ves >ÄÄÄ
STATIC FUNCT HiLiHOT( B)
	Local N, M, nPos, cStr, cChar
	Local lHot := EMPTY( cHOT)
/*
	FOR N := B:nTop TO B:nBottom
		cStr := CharOdd( ScreenSTR( N, B:nLeft, B:nLeft+30 ))
		nPos := 1
		FOR M := 1 TO Len( cStr)
			cChar := SubStr( cStr, M, 1)
			IF ASC( cChar) >= 65 .and. ASC( cChar) <= 90
				nPos := M
				EXIT
			END
		NEXT
		cChar := SubStr( cStr, nPos, 1)
		nPos  += B:nLeft -1
		//Ä Hot ZNAK
		ColorWin( N, nPos, N, nPos, IF( N == B:RowPos()+3, 'GR+/B', 'gr+/w'))
*/
		//Ä Hodnota parametru
		ColorWin( N, B:nRight - Len( AllTrim( CFG->cPicture)), N, B:nRight -1,;
		         IF( N == nAktROW, 'W+/B*', 'n/w'))
//		IF( lHot,	cHOT += cChar, Nil )
//	NEXT
RETURN Nil

//ÄÄÄ< Hodnota parametru do Browse >ÄÄÄ
STATIC FUNCT  InColumn()
	Local cVar, cTyp := CFG->cTyp, cValue := AllTrim( CFG->cValue)
	DO CASE
		CASE  cTyp == 'N'
			 cVar := cValue
		CASE  cTyp == 'C'
			 cVar := LEFT( cValue, 25)
		CASE  cTyp == 'L'
			 cVar := UPPER( cValue)
//			 cVar := If( UPPER( cValue) == 'ANO', NC_FIL,;
//			         IF( UPPER( cValue) == 'NE' , NC_EMP, cValue))
		OTHERWISE
			 cVar := cValue
	ENDCASE
	cVar := PADL( cVar, nMaxPict)
RETURN cVAR

//ÚÄ< Parametr typu CheckBox - STD >ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FUNCTION STD_CheckBox( nMOD)
	Local cScr := SaveScreen(), cC := 'W+/W'
	Local nT := ROW() + 1, nL := 25, nB, nR, n, nWidth := 20
	Local aC, alC

	DEFAULT nMOD  TO CHECK
	//ÄÄÄ
	IF( EMPTY( CFG->cbVALUE), NIL, EVAL( COMPILE( CFG->cbVALUE)) )
	//ÄÄÄ
	lAKT := YES
DO WHILE lAKT
	( aC := {}, alC := {} )
	aEVAL( CFG->axValue, {|X| AADD( alC, !Empty( Left( X, AT( ',', X) -1))),;
	                          AADD( aC , SubStr( X, AT( ',', X) +1)),;
														nWidth := MAX( nWidth, Len( X)-2 )  })  // 24.10.2000
	nB := nT + Len( aC) + 2 + 3
	//Ä Pokud Box jde mimo screen
	IF nB > MaxRow() - 2  ; nT := MAX( 2, nT - ( nB - MaxRow() + 2 ) )
													nB := MaxRow() - 2
	ENDIF
	nR := nL + nWidth + 10
	nBUT := 0
	aBUT := { { nB-2, nL+10, nB-2, nL+17, ' Ulo§it '      , {|| NIL }},;
						{ nB-2, nL+21, nB-2, nL+28, ' Storno ' , {|| NIL }} }

	DispBox( nT, nL, nB, nR, BX_DOUBLE + ' ', cC)
	BoxShadow( nT, nL, nB, nR )
	@ nT+1, nL+ 2 Say LEFT( CFG->cTextBox, nR - nL -2) Color 'gr+/w'
	For n := 1 To Len( aC)
		IF nMOD == CHECK
			@ n+nT+1, nL+2 Say '[ ] ùùù' Color 'N/W'
			@ n+nT+1, nL+3 Say If( IsNil( alC), IsSET, If( alC[ n], IsSET, ' ' )) Color 'w+/W'
		ELSEIF nMOD == COMBO
//			@ n+nT+1, nL+2 Say If( alC[ n], NC_FIL, NC_EMP ) Color 'N/W'
			NC_Say( n+nT+1,nL+2, If( alC[ n], NC_FIL, NC_EMP ) )
			@ n+nT+1, nL+6 Say 'ùùù' Color 'N/W'
		ENDIF
	Next
	ClearWIN( nB-3, nL+1, nB-1, nR-1, 'W/W')
	CreaBUT()
	aEVAL( aC, {|X, n| aC[ n] := PADR( X, nWidth) })
	IF nMOD == CHECK
	   alC := CheckBOX( aC, alC, nT+2, nL+10, nB-4, nR-1, 'N/W, w+/b,,,',;  // 'bg+/w'
                   	 { |p1,p2| SetCheck( p1, p2)}, nMOD )
	ELSEIF nMOD == COMBO
	   alC := CheckBOX( aC, alC, nT+2, nL+10, nB-4, nR-1, 'N/W, w+/b,,,',;  // 'bg+/w'
                   	 { |p1,p2| SetCombo( p1, p2)}, nMOD )
	ENDIF
	RestSCREEN(,,,, cScr)
ENDDO

RETURN Nil

//ÄÄÄ* Nastav ( Zruç ) CheckBox
STATIC FUNCT SetCheck( nRow, nCol)
	Local C := Left( ScreenStr( nRow, nCol, 1), 1 )
	@ nRow, nCol Say  If( ( C == IsSET), ' ', IsSET) Color 'w+/W'
RETURN Nil

//ÄÄÄ* Nastav  ComboBox
STATIC FUNCT SetCombo( nRow, nCol)
	Local C := CHARODD( ScreenStr( nRow, nCol, 3))
	NC_Say( nRow, nCol, NC_FIL )
//	@ nRow, nCol Say  'ANO' Color 'N/W'
RETURN Nil

//ÄÄÄ* Vyber z ListBoxu
STATIC FUNCT SetList( nSub)
	Local aX := CFG->axValue
	Local cValue := LEFT( aX[ nSub], AT( ',', aX[ nSub]) -1)

	CFG->cValue := cValue
RETURN Nil

//ÚÄ< Obsluha parametru CheckBox >ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FUNCTION CheckBOX( acARR, alARR, nT, nL, nB, nR, cColor, bDynamic, nMOD )
   LOCAL B, oCol
	 Local cScreen := SaveScreen(), cOldClr
   LOCAL nSub := 1, k := 0, nMaxLen := Len( acArr), nKey, nRow, n
	 Local lOk := .t., lEnter
	 Local aArray[ Len( acArr)], acSave

	 Default cColor To 'n/w', bDynamic To {|| .T. }
   cOldClr := SetColor( cColor)
	 aArray := AClone( acArr)
	 lAKT := NO

   B := TBrowseNew( nT, nL, nB, nR )
   B:skipBlock := {|x| JumpIt(x, @nSub, nMaxLen)}
   B:goTopBlock    := {|| nSub := 1 }
   B:goBottomBlock := {|| nSub := nMaxLen }
	 oCol := TBColumnNew( "", {|| aArray[ nSub]} )
   B:addColumn( oCol )

	 Do While lOK
			B:forceStable()
      nKey := INKEY(0)

      If B:stable
        If !MoveCursKey( b, nKey )
					IF CFG->lActive   /////
					 If nKey == K_ENTER .or. nKey == K_SPACE
							IF nMOD == CHECK
					 	  	 alArr[ nSub] := ! alArr[ nSub]
							   // Eval( bDynamic, nT+nSub-1, nL - 7 )
							   Eval( bDynamic, ROW(), nL - 7 )
							ELSEIF nMOD == COMBO
								 aEVAL( alArr, {|X, N| alArr[ N] := NO })
								 alArr[ nSub] := YES
							   Eval( bDynamic, nT+nSub-1, nL - 8 )
								 FOR n := 1 TO Len( alArr)
									 IF N <> nSub
									    // @ nT - 1 + N, nL - 8 SAY NC_EMP Color 'n/w'
											NC_Say( nT-1+N, nL-8, NC_EMP )
									 ENDIF
								 NEXT
							ELSEIF nMOD == LISTBOX
							   Eval( bDynamic, nSub )
								 lOK := NO
							ENDIF
					 EndIf
			     IF nKEY == K_TAB .or. nKEY == K_SH_TAB
							nRow := nT + B:RowPos() - 1
							ColorWin( nRow, nL, nRow, nR, 'N/W' )
					    IF( lEnter := MoveBUT( nKey) )
								 If nBUT == 1                       // ULO¦IT
										acSave := CFG->axValue
										aEVAL( alArr, {|X, n| ;
										       acSave[ N] := IF( X, 'X', ' ') + SubStr( acSave[ N], 2) })
										CFG->axValue := acSave
								 EndIf
								 lOK := NO
							ElseIf LastKey() == K_ESC
								 lOK := NO
							Else
							  ColorWin( nRow, nL, nRow, nR, 'w+/b' )
							ENDIF
					 ENDIF
					 IF nKEY == K_ALT_A
					    IF !EMPTY( CFG->cbVALUE)  //Ä
				         EVAL( COMPILE( CFG->cbVALUE))
								 lAKT := YES
								 lOK  := NO
							ENDIF
					 ENDIF
					ENDIF     ////

          If nKey == K_ESC    ; 	lOK := NO   ;     EndIf
        EndIf
      EndIf
	 EndDo
   ( SetColor( cOldClr), RestScreen(,,,,cScreen) )
RETURN( alArr)

//ÄÄÄ*
Static Function JumpIt( nRequest, nSub, nMaxLen)
   Local k := 0

   If     nRequest == 0   ;   k := 0
   ElseIf nRequest >  0   ;   k := If( nRequest < ( nMaxLen - nSub),;
	 	                                  nRequest, nMaxLen - nSub )
   ElseIf nRequest <  0   ;   k := If( nRequest < (1 - nSub), 1 - nSub,;
																														  nRequest )
   EndIf
   nSub += k
Return( k)

//ÄÄÄ<  >ÄÄÄ
STATIC FUNCT MoveBUT( nKey)
	Local n, lEnter := NO, cTypPARAM

	cTypPARAM := AllTrim( Upper( CFG->cTypPARAM ))
	IF cTypPARAM == 'CHECKBOX_G' .or. cTypPARAM == 'COMBOBOX_G'
	DO WHILE  nKey <> K_ENTER
	  nBUT := IIF( nKey == K_TAB   , If( nBUT == 2, 0, nBUT+1),;
	          IIF( nKey == K_SH_TAB, If( nBUT == 1, 0, nBUT-1), nBUT ))

	  FOR n := 1 To Len( aBUT)
	    DispBoxW( aBUT[ n, 1], aBUT[ n, 2], aBUT[ n, 3], aBUT[ n, 4])
		  DispOutAt( aBUT[ n, 1], aBUT[ n, 2], aBUT[ n, 5], If( n == nBut, 'N/BG*', 'N+/W') )
	  NEXT
		IF nBUT == 0 .or. nKey == K_ESC
			EXIT
		ENDIF

		nKey := INKEY( 0)
		DO CASE
			CASE nKey == K_ENTER
				n := nBUT
	      DispBoxW( aBUT[ n, 1], aBUT[ n, 2], aBUT[ n, 3], aBUT[ n, 4],, 'n/w', 'w+/w')
		    DispOutAt( aBUT[ n, 1], aBUT[ n, 2], aBUT[ n, 5], 'N/BG*' )
				lENTER := YES
				Inkey( 0.1)
		ENDCASE
	ENDDO
	ENDIF

RETURN lEnter

//ÄÄÄ<  >ÄÄÄ
STATIC FUNCT CreaBUT()
	Local n
	FOR n := 1 To Len( aBUT)
	  DispBoxW( aBUT[ n, 1], aBUT[ n, 2], aBUT[ n, 3], aBUT[ n, 4])
	  DispOutAt( aBUT[ n, 1], aBUT[ n, 2], aBUT[ n, 5], 'N+/W' )
	NEXT
RETURN Nil

//ÚÄ< Parametr typu ALPHANUM >ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FUNCTION STD_AlphaNUM( B)
	Local aSTRU := CFG->( dbSTRUCT())
	Local nPOS  := ASCAN( aSTRU, {|X| X[ DBS_NAME] == 'CVALUE'})
	Local nLEN
	Local nCurs := SetCURSOR()
	Local GetList := {}
	Local nCol := B:nRight() -Len( AllTrim( CFG->cPicture))
	Local xVal := IF( CFG->cTyp == 'C', CFG->cValue,;
	              IF( CFG->cTyp == 'N', Val( AllTrim( CFG->cValue)), '' ))

	IF CFG->lActive
	  @ ROW(), nCol GET xVal Picture AllTrim( CFG->cPicture) Color 'n/bg*'
	  ReadMODAL( GetList )
	  IF LastKey() == K_CTRL_W
			 nLEN := aSTRU[ nPOS, DBS_LEN]
		   CFG->cValue := IF( ISCHARACTER( xVal), PADL( xVal, nLEN),;
		                  IF( ISNUMBER( xVal), PADL( STR( xVal), nLEN), ''  ))
	  ENDIF
	ENDIF
	SetCURSOR( nCurs)
RETURN Nil

//ÚÄ< Parametr typu ComboBox_S >ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FUNCTION STD_ComboBox( B)
	Local nCol := B:nRight() - 3
	Local cVal := AllTrim( CFG->cValue)

	IF CFG->lActive
	  cVal := IF( UPPER( cVal) == 'ANO', 'NE ', 'ANO')
	  CFG->cValue := cVAL
	  @ ROW(), nCOL SAY  UPPER( cVAL) Color 'w+/b'
//		NC_Say( ROW(), COL(), IF( cVAL == 'ANO', NC_FIL, NC_EMP), 'W+/B', 'W+/B' )
	ENDIF
RETURN Nil

//ÚÄ< Parametr typu ListBox_ >ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FUNCTION STD_ListBox()
	Local cScr := SaveScreen(), cC := 'W+/W'
	Local nT := ROW() + 1, nL := 25, nB, nR, n, nWidth := 1, nPos
	Local aVal := {}, aTxt := {}
	Local nMOD := LISTBOX

	aEVAL( CFG->axValue, {|X| nPos := AT( ',', X) ,;
	                          AADD( aVal, Left( X, nPos -1)),;
	                          AADD( aTxt, SubStr( X, nPos +1)),;
														nWidth := MAX( nWidth, Len( X) )  })
	nB := nT + Len( aTxt) + 2
	//Ä Pokud Box jde mimo screen
	IF nB > MaxRow() - 2  ; nT := nT - ( nB - MaxRow() + 2 )
													nB := MaxRow() - 2
	ENDIF
	nR := nL + nWidth + nPos + 2

	DispBox( nT, nL, nB, nR, BX_DOUBLE + ' ', cC)
	BoxShadow( nT, nL, nB, nR )
	@ nT+1, nL+ 2 Say LEFT( CFG->cTextBox, nR - nL -2 ) Color 'gr+/w'
	For n := 1 To Len( aVal)
			@ n+nT+1, nL+2 Say aVal[ n]  Color 'bg+/W'
			@ n+nT+1, nL+2+nPos Say '-' + aTxt[ n] Color 'n/W'
	Next
	aEVAL( aTxt, {|X, n| aTxt[ n] := PADR( X, nWidth) })

	CheckBOX( aTxt, aVal, nT+2, nL+4+nPos, nB-1, nR-1, 'N/W, w+/b,,,',;  // 'bg+/w'
         	 { |Prm| SetList( Prm)}, nMOD )
	RestScreen(,,,, cScr)
RETURN Nil

STATIC FUNC NC_Say( nR, nC, NC_char, cCLR1, cCLR2)

	DEFAULT cCLR1 TO 'N/W', cCLR2 TO 'W+/W'
	@ nR, nC   SAY  LEFT( NC_char , 2) Color cClr1
	@ nR, nC+2 SAY  RIGHT( NC_char, 1) Color cClr2
RETURN NIL

//ÚÄ< Z¡sk  hodnotu parametru >ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FUNCTION GetCFG( cITEM)
	Local xRET, cTypPARAM
	Local axHLP
	Local nRec := CFG->( RecNo()), cTag := CFG->( OrdSetFocus( 2))

	IF CFG->( dbSeek( UPPER( cITEM)))
		cTypPARAM := ALLTRIM( UPPER( CFG->cTypPARAM))
		axHLP     := CFG->axValue
		DO CASE
			CASE cTypPARAM == 'ALPHANUM' .OR. ;    //Ä Number, Char
					 cTypPARAM == 'LISTBOX'
					 xRET := IF( CFG->cTyp == 'C', AllTrim( CFG->cValue),;
									 IF( CFG->cTyp == 'N', VAL( AllTrim( CFG->cValue)), '' ))
 			CASE cTypPARAM == 'CHECKBOX_S'   //Ä Single
			CASE cTypPARAM == 'CHECKBOX_G'   //Ä Group
					 xRET  := {}
					 aEVAL( axHLP, {|X| AADD( xRET, !EMPTY( LEFT( X, 1) )) })
			CASE cTypPARAM == 'COMBOBOX_S'   //Ä Group
					 xRET := ( UPPER( ALLTRIM( CFG->cValue)) == 'ANO' )
			CASE cTypPARAM == 'COMBOBOX_G'   //Ä Group
					 xRET := ASCAN( axHLP, {|X| !EMPTY( LEFT( X, 1) )  } )
		ENDCASE
	ELSE
//		BOX_ALERT( cEM, { 'Nebyl nalezen konfiguraŸn¡ parametr ' + cITEM + ' .',;
//		                  'éloha nem  podm¡nky pro sv…j spr vnì chod !'}, acWAIT )
	ENDIF
	// ( CFG->( OrdSetFocus( cTag)), CFG->( dbGoTo( nRec)) )
	CFG->( OrdSetFocus( cTag))
RETURN xRET

//ÚÄ< Kontrola existence Cfg.dbf >ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FUNCTION IsCFG( cDirMOD )
	Local cCfgMOD := cDirMOD   + '\CFG'
	Local cCfgUSR := FHomADR() + '\CFG'
	Local cCfgNEW := FHomADR() + '\CFGNEW'
	Local aStruMOD, aStruUSR, cALIAS := 'CFG'
	Local lCfgOK := NO, lStruOK := NO, lRecOK := NO, lItemOK := NO

	IF FILE( cCfgUSR + '.Dbf' )
    dbUseAREA( .t., "SIXCDX", ( cCfgUSR), 'CFG', if( .T. .or. .F., .F., NIL ), .f. )

		IF AMenu_IS()
	    OrdSetFOCUS( 2)
      dbUseAREA( .t., "SIXCDX", ( cCfgMOD), 'CfgMOD', if( .T. .or. .F., .F., NIL ), .f. )
	    OrdSetFOCUS( 2)
			( aStruMOD := CfgMOD->( dbSTRUCT()), aStruUSR := Cfg->( dbSTRUCT()) )

			//ÄÄ Aktualizace struktury CFG
			IF ! ( lStruOK := ( LEN( aStruMOD) == LEN( aStruUSR)) )
				 dbCREATE( cCfgNEW + '.Dbf', aStruMOD )
         dbUseAREA( .t., "SIXCDX", ( cCfgNEW), 'CfgNEW', if( .T. .or. .F., .F., NIL ), .f. )
				 CFG->( dbCloseAREA())
				 CfgNEW->( __dbAPP( cCfgUSR + '.Dbf', {}))
				 INDEX ON CfgNEW->nOrd           TAG CFG_1
				 INDEX ON UPPER( CfgNEW->cItem)  TAG CFG_2
         dbUseAREA( .t., "SIXCDX", ( cCfgUSR),, if( .T. .or. .F., .F., NIL ), .f. )
	       OrdSetFOCUS( 2)
				 IF CfgNEW->( LastREC()) == CFG->( LastREC())  //Ä povedlo se
						cALIAS := 'CfgNEW'
				 ELSE     //Ä nepovedlo se
						( CfgNEW->( dbCloseAREA()), FileDELETE( cCfgNEW + '.*') )
				 ENDIF
			ENDIF

			//ÄÄ Aktualizace poŸtu parametr… (z znam…) CFG
			IF !( lRecOK	:= ( CfgMOD->( LastREC()) == ( cALIAS)->( LastREC()) ))
				 //Ä Pýid n¡ novìch parametr…
				 CfgMOD->( dbEVAL( {|| IF( ! ( cALIAS)->( dbSEEK( UPPER( CfgMOD->cItem))),;
				                          ( ( cALIAS)->( dbAppend()), PutITEM( cALIAS, 'CfgMOD') ), NIL )  }))
				 /*/Ä Zruçen¡ starìch parametr…
				 ( cALIAS)->( dbEVAL( {|| IF( ! CfgMOD->( dbSEEK( UPPER( ( cALIAS)->cItem))),;
				                             ( cALIAS)->( dbDELETE()), NIL )  }))
				 */
				 //Ä Zruçen¡ starìch parametr…, aktualizace nOrd
				 ( cALIAS)->( dbEVAL( {|| IF( CfgMOD->( dbSEEK( UPPER( ( cALIAS)->cItem))),;
																		 ( cALIAS)->nOrd := CfgMOD->nOrd ,;
				                             ( cALIAS)->( dbDELETE())        )  }))
			ENDIF

			//ÄÄ Aktualizace nØkterìch atribut…  CFG
			( cALIAS)->( dbGoTOP())
			DO WHILE !( cALIAS)->( EOF())
			   IF CfgMOD->( dbSEEK( UPPER( ( cALIAS)->cITEM)))
						( cALIAS)->cName     := CfgMOD->cName
						( cALIAS)->cPicture  := CfgMOD->cPicture
						( cALIAS)->cbValue   := CfgMOD->cbValue
						( cALIAS)->cBlocks   := CfgMOD->cBlocks
						( cALIAS)->cTextBox  := CfgMOD->cTextBox
						( cALIAS)->mHelp     := CfgMOD->mHelp
					  IF EMPTY( ( cALIAS)->cbValue)
						  IF( LEN( ( cALIAS)->axValue) <> LEN( CfgMOD->axValue) )
						    ( cALIAS)->axValue  := CfgMOD->axValue
						  ENDIF
					  ELSE
							EVAL( COMPILE( ( cALIAS)->cbVALUE ))
						ENDIF
				 ELSE
				 ENDIF
				 ( cALIAS)->( dbSKIP())
	    ENDDO

			//ÄÄ Pokud se zmØnila struktura a vznikl CfgNEW => nØco s t¡m dØlej.
			IF cALIAS == 'CfgNEW'
				(  CFG->( dbCloseAREA()), FileDELETE( cCfgUSR + '.*') )
				CfgNEW->( dbCloseAREA())
				FRENAME( cCfgNEW + '.DBF', cCfgUSR + '.DBF' )
				FRENAME( cCfgNEW + '.FPT', cCfgUSR + '.FPT' )
				FileDELETE( cCfgNEW + '.CDX' )
        dbUseAREA( .t., "SIXCDX", ( cCfgUSR), 'CFG', if( .T. .or. .F., .F., NIL ), .f. )
				INDEX ON CFG->nOrd           TAG CFG_1
				INDEX ON UPPER( CFG->cItem)  TAG CFG_2
			ENDIF
			CfgMOD->( dbCloseAREA())
		ENDIF

	ELSE   //ÄÄ U§ivatelskì CFG neexistuje => Nutno nakop¡rovat distribuŸn¡
		COPY FILE ( cCfgMOD + '.Dbf') TO ( cCfgUSR + '.Dbf')
		COPY FILE ( cCfgMOD + '.Cdx') TO ( cCfgUSR + '.Cdx')
		COPY FILE ( cCfgMOD + '.Fpt') TO ( cCfgUSR + '.Fpt')
    dbUseAREA( .t., "SIXCDX", ( cCfgUSR),, if( .T. .or. .F., .F., NIL ), .f. )
	  CFG->( OrdSetFOCUS( 1))
		//ÄÄ Aktualizace hodnot "dynamickìch" parametr…
		( cALIAS)->( dbGoTOP())
		DO WHILE !( cALIAS)->( EOF())
			 IF !EMPTY( ( cALIAS)->cbValue)
			 		 EVAL( COMPILE( ( cALIAS)->cbVALUE ))
			 ENDIF
			 ( cALIAS)->( dbSKIP())
	  ENDDO
		( cALIAS)->( dbGoTOP())

	ENDIF
	CFG->( OrdSetFOCUS( 1))

RETURN Nil

STATIC FUNC HelpPARAM( lEDIT)
	Local cSCR := SaveSCREEN()
	Local cC := 'W+/B*', cB := 'N/W'  //'N/BG*'
	Local cHELP := CFG->mHELP
	Local nLEN := LEN( ALLTRIM( CFG->cName))

	DispBOX( 3, 3, 22, 76, BX_DOUBLE + ' ', 'W+/W')
	@ 4, 5 SAY ' ' + ALLTRIM( CFG->cNAME ) + ' ' Color 'W+/B'   // 'GR+/W'

/*
	DispBOXW( 4, 5, 4, nLEN + 6 )
	@ 3, 5 SAY REPLICATE( 'Î', nLEN + 2 ) Color 'W+/W'
	@ 4, 5 SAY ' ' + ALLTRIM( CFG->cNAME ) + ' ' Color cC   // 'GR+/W'
	@ 4, nLEN + 7 SAY ' ' + REPLICATE( 'ú', 35) Color 'W+/w'
*/
	@ 4, nLEN + 7 SAY ' ' + REPLICATE( 'ú', 35) Color 'W+/w'
	@ 4, 58      SAY ' POPIS PARAMETRU' Color 'W+/W'

  cHELP := HelpMEMO( cHELP, 6, 5, 21, 73, lEDIT,, cB )
	IF LastKEY() == K_CTRL_W .AND. lEDIT
		CFG->mHELP := cHELP
	ENDIF

	RestSCREEN( ,,,, cSCR)
RETURN NIL


STATIC FUNC HelpMEMO( cM, nT, nL, nB, nR, lEdit, cMemoUDF, cClr )
  Local  cOldClr, cMemo := cM
  Local  cSCR := SaveSCREEN()
  Local  nCurs   := SaveCURSOR()

  DEFAULT lEdit TO YES, cClr TO 'N/W'
  cOldClr := SetCOLOR( cClr)
	SetCURSOR( If( lEdit, SC_NORMAL, SC_NONE ))

//  cMemo := MemoEdit( cMemo, nT +1, nL +2, nB -1, nR -2, lEdit, cMemoUDF )
  cMemo := MemoEdit( cMemo, nT, nL, nB, nR, lEdit, cMemoUDF )

  ( SetCOLOR( cOldClr),	RestCURSOR( nCurs)  )
	RestSCREEN( ,,,, cSCR)
RETURN( cMemo)

