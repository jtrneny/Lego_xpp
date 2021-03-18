// MlisIT.Prg  -  02.09.97 09.16
# Include   'C:\Lego.Wk\Include\Vyroba\Vyroba_.Ch'
# Include   'Include\RV_.Ch'
# Include   'Include\DefBrow_.Ch'

//ÄÄ Pln  verze mzdovìch l¡stk…
# xTranslate   .CisML      => \[ 1\]
# xTranslate   .RokML      => \[ 2\]
# xTranslate   .TypML      => \[ 3\]
# xTranslate   .DrMZD      => \[ 4\]
# xTranslate   .TarST      => \[ 5\]
# xTranslate   .TarTR      => \[ 6\]
# xTranslate   .NhPL       => \[ 7\]
# xTranslate   .NhSK       => \[ 8\]
# xTranslate   .NmPL       => \[ 9\]
# xTranslate   .NmSK       => \[10\]
# xTranslate   .KcPL       => \[11\]
# xTranslate   .KcSK       => \[12\]
# xTranslate   .KcPrem     => \[13\]
# xTranslate   .OsCis      => \[14\]
# xTranslate   .DatMOZ     => \[15\]
# xTranslate   .DatNUT     => \[16\]
# xTranslate   .DatPL      => \[17\]
# xTranslate   .DatSK      => \[18\]
# xTranslate   .DatKON     => \[19\]
# xTranslate   .KdoKON     => \[20\]
# xTranslate   .SMENA      => \[21\]
# xTranslate   .KsCEL      => \[22\]
# xTranslate   .KsHOT      => \[23\]
# xTranslate   .KsKON      => \[24\]
# xTranslate   .KsVAD      => \[25\]
# xTranslate   .StavML     => \[26\]
# xTranslate   .DruhML     => \[27\]
# xTranslate   .TydPL      => \[28\]

//ÄÄ Jednoduch  verze mzdovìch l¡stk…
# xTranslate   .CisML2      => \[ 1\]
# xTranslate   .RokML2      => \[ 2\]
# xTranslate   .TypML2      => \[ 3\]
# xTranslate   .DrMZD2      => \[ 4\]
# xTranslate   .OsCis2      => \[ 5\]
# xTranslate   .MzdMJ2      => \[ 6\]
# xTranslate   .KsCEL2      => \[ 7\]
# xTranslate   .KsHOT2      => \[ 8\]
# xTranslate   .KsVAD2      => \[ 9\]
# xTranslate   .NhPL2       => \[10\]
# xTranslate   .NhSK2       => \[11\]
# xTranslate   .NmPL2       => \[12\]
# xTranslate   .NmSK2       => \[13\]
# xTranslate   .KcPL2       => \[14\]
# xTranslate   .KcSK2       => \[15\]
# xTranslate   .KcPrem2     => \[16\]
# xTranslate   .DatPL2      => \[17\]
# xTranslate   .DatSK2      => \[18\]
# xTranslate   .SMENA2      => \[19\]
# xTranslate   .StavML2     => \[20\]
# xTranslate   .DruhML2     => \[21\]
# xTranslate   .TydPL2      => \[22\]

//ÄÄ  Typ poŸ¡tan‚ hodnoty
# Define    PLAN       1   //  KŸ Pl n
# Define    SKUT       2   //  KŸ SkuteŸnost

//ÄÄ  Typ pou§it‚ tarifn¡ sazby
# Define    HOD        1   //  Hodinov  sazba
# Define    PRE        2   //  Navìçen¡ hodinov‚ sazby

//ÄÄ Typ vìpoŸtu KŸ
# Define    SazbaTAR    '1'   // - ze sazeb TARIF…
# Define    SazbaZAM    '2'   // - ze sazeb ZAM·STNANC… dle druhu mzdy

//ÄÄ Typ Druhu mzdy
# Define    UKOL        'UKOL'
# Define    CAS         'CASO'
# Define    REZIE       'REZI'
# Define    PRESCAS     'PRES'

Static  lNewRec, lScr, axE
Static  cCisZakaz
Static  cVerML, FULL, cVypKC, cDmz
Static  nCisML, cTypML, nDrMZD, nCfg

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
FUNCTION MzdITEM( nKey, lCallFromScreen)
	Local lOK := NO
	DEFAULT cVerML TO SysConfig( 'RV:cVerMzdLis' )
	DEFAULT FULL   TO ( cVerML == '0' )

	IF     cVerML == '0'  ; lOK := ListIT_0( nKey, lCallFromScreen)    //Ä FULL verze
	ELSEIF cVerML == '1'  ; lOK := ListIT_1( nKey, lCallFromScreen)    //Ä SINGLE verze
	ENDIF

RETURN lOK

//ÄÄÄÄÄ< POLO¦KA mzdov‚ho l¡stku
FUNCTION ListIT_0( nKey, lCallFromScreen)
	Local nOldErr, n
	Local lOK := NO, lCykl := .t.
	Local cColor := SetColor( 'w/b, n/bg*,,, w+/b'), cKey
	Local nCurs := SetCursor( SC_NORMAL), nStart := 3, nRecIT := ListIT->( RecNo())
	Local cScr := SaveScreen(), GetList := {}
	Local bAcc := KeyACCESS( {|| SetACCESS( 'CRD', 'MzdList', 1) })
  Local	lWrtACC := GetACCESS( 'CRD', 'MzdList', 1 )

IF NazPol1_TST( 'ListIT', nKey, '12' )

	DEFAULT cVerML TO SysConfig( 'RV:cVerMzdLis' )
	DEFAULT FULL   TO ( cVerML == '0' )
	DEFAULT cVypKC TO SysConfig( 'RV:cVypSkutKc' )
	DEFAULT nCisML TO ListHD->nPorCisLis
	Default lCallFromScreen To NO
	lScr := lCallFromScreen
	nCfg := GetCFG( 'cMzdaZaKus')

	OpenFiles( { 'DruhyMzd', 'MsPrc_MD' } )
Begin Sequence
	cCisZakaz := IsZakazka()
	lNewRec := ( nKey == K_INS )
	SayMzdITEM()
	If SysRV->( dbSeek( If( FULL, 'KarMzdIt', 'KarMzdIt1')))
     Box_DispHotKeys( SysRV->cHotKeys )
		 axE := SysRV->axCard
		 If( lNewRec, ListIT->( dbGoTo( ListIT->( LastRec() +1 ))), Nil )
		 aEval( axE, { |X|  X[ 4]  := DBGetVal( X[ 5]) })
		 SetGET( nRecIT)

		 For n := 1 To Len( axE)
            @ axE[ n, 1], axE[ n, 2] Get  axE[ n, 4]  Picture axE[ n, 6] ;
					    Valid If( FULL, MLIT_Vld( GetList), MLIT_Vld1( GetList) )
		   If( n = 1, ( GetList[ n]:ColorSpec := 'N/W*' , GetList[ n]:Display() ), Nil)
		   If( n = 2, ( GetList[ n]:ColorSpec := 'gr+/b', GetList[ n]:Display() ), Nil)
			 aTail( GetList):Cargo := axE[ n, 7]
			 WhenBl( GetList[ n])
	   Next
		 nStart := If( IsNil( cTypML), 3, 5 )
		 PlneniPROC( GetList)

		 Do While lCykl
			 ReadModal( GetList, nStart )

			 If ( LastKey() == K_CTRL_W ) .AND. lWrtACC
//				 If lOK := CtrlOverFlow( GetList)
				 If ( lOK := CtrlHEAD( GetList) )
           lOk := If( lNewRec, AddRec( 'ListIT'), ReplRec( 'ListIT'))
  	       If lOk ;  aEval( axE  , { |X,n| DBPutVal( X[ 5], X[ 4] )} )
									   ListIT->cCisZakaz  := ListHD->cCisZakaz
									   ListIT->cVyrPol    := ListHD->cVyrPol
									   ListIT->cObdobi    := WhatOBD()
										 FOrdRec( { 'MsPrc_MD, 1', 'Operace, 1' })
									   MsPrc_MD->( dbSeek( ListIt->nOsCisPrac))
									   ListIT->cPrijPrac  := MsPrc_MD->cPrijPrac
									   ListIT->cJmenoPrac := MsPrc_MD->cJmenoPrac
										 Operace->( dbSeek( Cs_Upper( ListHD->cOznOper)))
										 ListIT->cOznOper   := ListHD->cOznOper
										 ListIT->cStred     := Operace->cStred
										 ListIT->cOznPrac   := Operace->cOznPrac
										 ListIT->cPracZar   := Operace->cPracZar
										 ListIT->cNazPol1   := VyrZAK->cNazPol1
										 If !FULL
    		                ListIT->cTarifStup := Operace->cTarifStup
    		                ListIT->cTarifTrid := Operace->cTarifTrid
										 Endif
										 FOrdRec()
				 				     SysFields( 'ListIT', lNewRec)
									   StavLST()
				 				     DCrUnlock( 'ListIT')
										 If lNewRec
										    cTypML := If( UPPER( ListIT->cTypListku ) == UPPER( cTypML),;
																	    cTypML, ListIT->cTypListku )
										    nDrMZD := If( ListIT->nDruhMzdy == nDrMZD,;
																	    nDrMZD, ListIT->nDruhMzdy )
										 Endif
				   Endif
				   lCykl := FALSE
				 EndIf
//				 Endif
		   EndIf

			 If ( LastKey() == K_PGDN ) .or. ( LastKey() == 0 )
			 	                             nStart := Len( GetList)       ; EndIf
			 If ( LastKey() == K_PGUP )  ; nStart := 3                   ; EndIf
			 If ( LastKey() == K_ESC  )  ; lCykl  := .f.					       ; Endif
		 EndDo
	EndIf

EndSequence
	( RestScreen( ,,,, cScr), SetCursor( nCurs), SetColor( cColor) )
ENDIF
	KeyACCESS( bAcc)

RETURN( lOK)

//ÄÄÄ* Validace polo§ky mzdov‚ho l¡stku - FULL-verze
Static Function MLIT_Vld( G)
	Local  lOk   := .T., ax
	Local  nCurs := SetCursor( 0)
	Local  n     := GetActive():SubScript[ 1]
	Local  xVal  := GetActive():VarGet(), xOrg := GetActive():Original
	Local  cKey, cText, cObdForML
	Local  lValid := ( lNewRec .or. ( !lNewRec .and. xVal <> xOrg ))

If LastKey() <> K_UP
	Do Case
		Case n == 3  //  Typ l¡stku
			ax := CisBrowse( 'c_TypLis', xVal )
			If( lOK := ax[ 1], G[ n]:VarPut( ax[ 2]), Nil)

		Case n == 4  //  Druh mzdy
		  If( lOK := BrDrMzdy( xVal, YES ))
		     G[ n]:VarPut( DruhyMzd->nDruhMzdy )
				 @ G[ n]:Row(), G[ n]:Col()+11 Say Left( DruhyMzd->cNazevDmz, 30) Color 'bg+/b'
		  EndIf

		Case n == 5  //  Tarifn¡ stupnice
			ax := CisBrowse( 'c_TarStu', xVal )
			If( lOK := ax[ 1], G[ n]:VarPut( ax[ 2]), Nil)

		Case n == 6  //  Tarifn¡ tı¡da
			ax := CisBrowse( 'c_TarTri', xVal )
			If( lOK := ax[ 1], G[ n]:VarPut( ax[ 2]), Nil)

		Case n == 7  // Nh pl n
			If lValid  ; G.NmPL:VarPut( xVal * 60)
				           If xVal <> 0
											PlneniPROC( G)
						          G.KcPL:VarPut( KcCMP( G, PLAN, HOD) )
			             Endif
				           ReCMP( G)
			Endif

		Case n == 8  // Nh skut.
			If lValid ;  G.NmSK:VarPut( xVal * 60)
									 If xVal <> 0
											PlneniPROC( G)
											G.KcSK:VarPut(   KcCMP( G, SKUT, HOD ))
											G.KcPrem:VarPut( KcCMP( G, SKUT, PRE ))
									 Endif
			Endif

		Case n == 9  // Nm pl n
			If lValid ;  G.NhPL:VarPut( xVal / 60)
									 G.KcPL:VarPut( KcCMP( G, PLAN, HOD))
									 PlneniPROC( G)
			Endif
			ReCMP( G)

		Case n == 10  // Nm skut.
			If lValid ;  G.NhSK:VarPut( xVal / 60)
									 G.KcSK:VarPut(   KcCMP( G, SKUT, HOD ))
									 G.KcPrem:VarPut( KcCMP( G, SKUT, PRE ))
									 PlneniPROC( G)
			Endif

		Case n == 11  // KŸ pl n
			ReCMP( G)

		Case n == 14 .or. n == 20  // Os.Ÿ¡slo, Kdo kontroloval
		  lOK := BrOsCis( xVal, YES )
		  If( lOK, G[ n]:VarPut( MsPrc_MD->nOsCisPrac ), Nil )
			If n == 14 ;  @ G[ n]:Row(), G[ n]:Col()+11 Say  ;
				              PADR( AllTrim( MsPrc_MD->cPrijPrac) + ' ' + ;
				                    AllTrim( MsPrc_MD->cJmenoPrac), 30) Color 'bg+/b'
			EndIf

		Case n == 17 .or. n == 18  //  Datum pl. vyhotov. , Datum skut. vyhotov.
			If lValid
				 If !Empty( G.DatSK:VarGet() )
						cObdForML := GetCFG( 'cObdForML')
						IF VAL( LEFT( cObdForML, 2))  == MONTH( G.DatSK:VarGet() ) .AND. ;
 							 VAL( RIGHT( cObdForML, 4)) == YEAR( G.DatSK:VarGet() )
		           G.TydPL:VarPut( WEEK( G.DatSK:VarGet()) )
						ELSEIF n == 18
							 BOX_Alert( '( Chybn‚ datum )',;
							            { 'Nelze poı¡dit do jin‚ho, ne§ konfiguraŸnØ nastaven‚ho',;
													  'obdob¡, a tim je obdob¡  ' + cObdForML + ' !' }, acWAIT )
							 lOK := NO
						ENDIF
	       ElseIf !Empty( G.DatPL:VarGet() )
		        G.TydPL:VarPut( WEEK( G.DatPL:VarGet()) )
	       Endif
			Endif

		Case n == 22  // Kusy Celkem
			If lValid .and. xVal > 0
				 G.NmSK:VarPut( G.NmPL:VarGet() / xVal * G.KsHOT:VarGet() )
				 G.NhSK:VarPut( G.NmSK:VarGet() / 60 )
				 G.KcSK:VarPut( G.KcPL:VarGet() / xVal * G.KsHOT:VarGet() )
		     G.KcPrem:VarPut( KcCMP( G, SKUT, PRE ))
			Endif
//			If( lNewRec, G.KsHOT:VarPut( xVal), Nil)
			G.KsHOT:VarPut( xVal)

		Case n == 23  // Kusy hotov‚
			If lValid .and. G.KsCEL:VarGet() > 0
				 G.NmSK:VarPut( G.NmPL:VarGet() / G.KsCEL:VarGet() * xVal )
				 G.NhSK:VarPut( G.NmSK:VarGet() / 60 )
				 G.KcSK:VarPut( G.KcPL:VarGet() / G.KsCEL:VarGet() * xVal )
		     G.KcPrem:VarPut( KcCMP( G, SKUT, PRE ))
			Endif
	EndCase
	aEval( G, { |X| X:Display() } )
	WhenBl( G[ n])
Else
	G[ n]:VarPut( xOrg)
EndIf
SetCursor( nCurs)
Return( lOk)

//ÄÄÄ*
Static Function ReCMP( G )
  If G.KsCEL:VarGet() <> 0 .and. G.KsHOT:VarGet() <> 0
     G.NhSK:VarPut( G.NhPL:VarGet() / G.KsCEL:VarGet() * G.KsHOT:VarGet() )
     G.NmSK:VarPut( G.NmPL:VarGet() / G.KsCEL:VarGet() * G.KsHOT:VarGet() )
	   G.KcSK:VarPut( G.KcPL:VarGet() / G.KsCEL:VarGet() * G.KsHOT:VarGet() )
		 G.KcPrem:VarPut( KcCMP( G, SKUT, PRE ))
	EndIf
Return( Nil)


//ÄÄÄ* Validace polo§ky mzdov‚ho l¡stku - SIMPLE-verze
Static Function MLIT_Vld1( G)
	Local  lOk   := .T., ax
	Local  nCurs := SetCursor( 0)
	Local  n     := GetActive():SubScript[ 1], nNm
	Local  xVal  := GetActive():VarGet(), xOrg := GetActive():Original
	Local  cKey, cText, cObdForML
	Local  lValid := ( lNewRec .or. ( !lNewRec .and. xVal <> xOrg ))

If LastKey() <> K_UP
	Do Case
		Case n == 3  //  Typ l¡stku
			ax := CisBrowse( 'c_TypLis', xVal )
			If ( lOK := ax[ 1])  ;   G[ n]:VarPut( ax[ 2])
															 dbSelectArea( 'ListIT')
			EndIf

		Case n == 4  //  Druh mzdy
		  If( lOK := BrDrMzdy( xVal, YES ))
		     G[ n]:VarPut( DruhyMzd->nDruhMzdy )
				 @ G[ n]:Row(), G[ n]:Col()+11 Say Left( DruhyMzd->cNazevDmz, 30) Color 'bg+/b'
			EndIf
			cDmz := AllTrim( DruhyMzd->cTypDmz)
			If G.OsCis2:VarGet() <> 0
//	 	     G.KcPL2:VarPut( KcCMP( G, PLAN ))
	 	     G.KcSK2:VarPut( KcCMP( G, SKUT ))
			Endif

		Case n == 5   // Os.Ÿ¡slo prac
		  If( lOK := BrOsCis( xVal, YES ))
		     G.OsCis2:VarPut( MsPrc_MD->nOsCisPrac )
				 @ G[ n]:Row(), G[ n]:Col()+11 Say ;
				   PADR( AllTrim( MsPrc_MD->cPrijPrac) + ' ' + ;
					       AllTrim( MsPrc_MD->cJmenoPrac), 30) Color 'bg+/b'
//	 	     G.KcPL2:VarPut( KcCMP( G, PLAN ))
	 	     G.KcSK2:VarPut( KcCMP( G, SKUT ))
		  EndIf

		Case n == 6   // Mzda za MJ
			// If lValid .and. cDmz == UKOL ;  G.KcPL2:VarPut( KcCMP( G, PLAN ))
			If lValid  ;  G.KcPL2:VarPut( KcCMP( G, PLAN ))
										IF cDmz == UKOL
       					       G.KcSK2:VarPut( KcCMP( G, SKUT ))
										ENDIF
			Endif
		Case n == 7   // Mno§. celkem
			// If lValid .and. cDmz == UKOL ;  G.KcPL2:VarPut( KcCMP( G, PLAN ))
			IF lValid  ;  G.KcPL2:VarPut( KcCMP( G, PLAN ))
										IF cDmz == UKOL
       					       G.KcSK2:VarPut( KcCMP( G, SKUT ))
										ENDIF
			ENDIF
			nNm := IF( nCfg == 1, ( ListHD->nKusovCas * xVal) ,;
			                      ( ListHD->nNmNaOpePl / ListHD->nKusyCelk) * xVal )
			G.NmPL2:VarPut( nNm)
			G.NhPL2:VarPut( nNm / 60 )
			G.KsHOT2:VarPut( xVal)

		Case n == 8   // Mno§. hotov‚
			If cDmz == UKOL ;  G.KcPL2:VarPut( KcCMP( G, PLAN ))
				                 G.KcSK2:VarPut( KcCMP( G, SKUT ))
			Endif

		Case n == 9   // Mno§. neshodn‚

		Case n == 10  // Nh pl n
			If lValid ; G.NmPL2:VarPut( xVal * 60)
				          If xVal <> 0
				 	           G.KcPL2:VarPut( KcCMP( G, PLAN ))
										 PlneniPROC( G)
			            Endif
//			       	  ReCMP( G)
			Endif

		Case n == 11  // Nh skut.
			If lValid ;  G.NmSK2:VarPut( xVal * 60)
									 If xVal <> 0
									 	  G.KcSK2:VarPut(   KcCMP( G, SKUT ))
											PlneniPROC( G)
									 Endif
			Endif

		Case n == 12  // Nm pl n
			If lValid ;  G.NhPL2:VarPut( xVal / 60)
								   G.KcPL2:VarPut( KcCMP( G, PLAN ))
									 PlneniPROC( G)
			Endif
//			ReCMP( G)

		Case n == 13  // Nm skut.
			If lValid ;  G.NhSK2:VarPut( xVal / 60)
									 G.KcSK2:VarPut(   KcCMP( G, SKUT ))
									 PlneniPROC( G)
			Endif

		Case n == 14  // KŸ pl n
//			ReCMP( G)

		Case n == 17 .or. n == 18  // Dat. pl n. vyhot., Dat. skut. vyhot.
			If lValid
				If !Empty( G.DatSK2:VarGet() )
					cObdForML := GetCFG( 'cObdForML')
					IF VAL( LEFT( cObdForML, 2))  == MONTH( G.DatSK:VarGet() ) .AND. ;
 					   VAL( RIGHT( cObdForML, 4)) == YEAR( G.DatSK:VarGet() )
		         G.TydPL2:VarPut( WEEK( G.DatSK2:VarGet()) )
					ELSEIF n == 18
						 BOX_Alert( '( Chybn‚ datum )',;
						          { 'Nelze poı¡dit do jin‚ho, ne§ konfiguraŸnØ nastaven‚ho',;
						 				    'obdob¡, a tim je obdob¡  ' + cObdForML + ' !' }, acWAIT )
						 lOK := NO
					ENDIF
	      ElseIf !Empty( G.DatPL2:VarGet() )
		      G.TydPL2:VarPut( WEEK( G.DatPL2:VarGet()) )
	      Endif
			Endif

	EndCase
	aEval( G, { |X| X:Display() } )
	WhenBl( G[ n])
Else
	G[ n]:VarPut( xOrg)
EndIf
SetCursor( nCurs)

Return( lOK)

//ÄÄÄ* VìpoŸet Pl novanìch a SkuteŸnìch K¬, dle parametru
Static Function KcCMP( G, nTypKC, nSazba )
	Local cKey, nKc := 0

	If cVypKC == SazbaTAR
		 cKey := G.TarST:VarGet() + G.TarTR:VarGet()
	   c_Tarif->( dbSeek( Cs_Upper( cKey)))
	ElseIf cVypKC == SazbaZAM
		 FOrdRec( { 'DruhyMzd, 1', 'MsPrc_MD, 1' } )
	   MsPrc_MD->( dbSeek( G.OsCis2:VarGet() ))
	 // DruhyMzd->( dbSeek( G.DrMZD:VarGet() ))
	 // Napozicovat DruhyMZD, MsPrc_MD, ale ty u§ jsou z validace
	Endif

	Do Case
		//ÄÄ
		Case FULL  .and. cVypKC == SazbaTAR
		  // cKey := G.TarST:VarGet() + G.TarTR:VarGet()
	    // c_Tarif->( dbSeek( Cs_Upper( cKey)))
			If nTypKc == PLAN
			   nKc := G.NhPL:VarGet() * If( nSazba == HOD, c_Tarif->nHodinSaz, c_Tarif->nHodinNav )
			ElseIf nTypKc == SKUT
			   nKc := G.NhSK:VarGet() * If( nSazba == HOD, c_Tarif->nHodinSaz, c_Tarif->nHodinNav )
			Endif
		//ÄÄ
		Case FULL  .and. cVypKC == SazbaZAM
		//ÄÄ
		Case !FULL .and. cVypKC == SazbaTAR
		//ÄÄ
		Case !FULL .and. cVypKC == SazbaZAM
		  cDmz := AllTrim( DruhyMzd->cTypDmz )
		  If cDmz == UKOL
				 nKc := G.MzdMJ2:VarGet() * If( nTypKc == PLAN,;
				                               G.KsCEL2:VarGet(), G.KsHOT2:VarGet() )

		  ElseIf ( cDmz == CAS) .or. ( cDmz == REZIE)
				 nKc := MsPrc_MD->nHodTarSml * ( MsPrc_MD->nSazPrePr / 100 + 1 ) * ;
                If( nTypKc == PLAN, G.NhPL2:VarGet(), G.NhSK2:VarGet() )
		  ElseIf cDmz == PRESCAS
				 nKc := MsPrc_MD->nHodPresca * If( nTypKc == PLAN,;
				                                   G.NhPL2:VarGet(), G.NhSK2:VarGet() )
		  Endif

			FOrdRec()
	EndCase
Return( nKc)

//ÄÄÄ< VìpoŸet % plnØn¡ na z kladØ NhPl a NhSk >ÄÄÄ
STATIC FUNCT PlneniPROC( G)
	LOCAL nProc, nRow

	nProc := If( FULL, ( G.NhPL:VarGet()  / G.NhSK:VarGet())  * 100 ,;
	                   ( G.NhPL2:VarGet() / G.NhSK2:VarGet()) * 100  )
	nRow := If( FULL, 9, 12 )
	@ nRow, 69 Say Str( nProc, 6, 2) Color 'bg+/b'
RETURN NIL

Static Function SetGET( nRecIT)

 If lNewRec
   ListIT->( dbGoTo( nRecIT))
	 cTypML := IF( IsNil( cTypML) .OR. nCisML <> ListHD->nPorCisLis,;
	               ListIT->cTypListku, cTypML)
	 nDrMZD := IF( IsNil( nDrMZD) .OR. nCisML <> ListHD->nPorCisLis,;
	               ListIT->nDruhMzdy, nDrMZD)
	 axE[  1, 4] := ListHD->nPorCisLis
	 axE[  2, 4] := ListHD->nRokVytvor
	 axE[  3, 4] := cTypML
	 axE[  4, 4] := nDrMZD
	 DruhyMzd->( dbSeek( ListIT->nDruhMzdy))
	 @ axE[ 4, 1], axE[ 4, 2]+11 Say Left( DruhyMzd->cNazevDmz, 30) Color 'bg+/b'
	 If FULL  ;	( axE[ 26, 4] := '1', axE[ 27, 4] := '7' )
	 Else     ;	( axE[ 20, 4] := '1', axE[ 21, 4] := '7' )
								axE[  6, 4] := SetMzdMJ()
	 EndIf
 Else
	 FOrdRec( { 'DruhyMzd, 1', 'MsPrc_MD, 1' } )
	 DruhyMzd->( dbSeek( ListIT->nDruhMzdy))
	 @ axE[ 4, 1], axE[ 4, 2]+11 Say Left( DruhyMzd->cNazevDmz, 30) Color 'bg+/b'
	 MsPrc_MD->( dbSeek( ListIT->nOsCisPrac))
	 If FULL ; @ axE[ 14, 1], axE[ 14, 2]+11 Say ;
	 	         PADR( AllTrim( MsPrc_MD->cPrijPrac) + ' ' +;
						       AllTrim( MsPrc_MD->cJmenoPrac), 30) Color 'bg+/b'
 	 Else    ; @ axE[  5, 1], axE[  5, 2]+11 Say ;
	 	         PADR( AllTrim( MsPrc_MD->cPrijPrac) + ' ' +;
						       AllTrim( MsPrc_MD->cJmenoPrac), 30) Color 'bg+/b'
	 EndIf
	 FOrdRec()
 Endif
 If FULL   ; DispOutAt( axE[ 26, 1], axE[ 26, 2]+5, SubStr( StavML[ Val( axE[ 26, 4])], 5), 'BG+/B')
             DispOutAt( axE[ 27, 1], axE[ 27, 2]+5, SubStr( DruhML[ Val( axE[ 27, 4])], 5), 'BG+/B')
 Else      ; DispOutAt( axE[ 20, 1], axE[ 20, 2]+5, SubStr( StavML[ Val( axE[ 20, 4])], 5), 'BG+/B')
						 DispOutAt( axE[ 21, 1], axE[ 21, 2]+5, SubStr( DruhML[ Val( axE[ 21, 4])], 5), 'BG+/B')
 EndIf
Return( Nil)

//ÄÄÄ* Pıednastaven¡ Mzdy za MJ.
Static Function SetMzdMJ()
	Local nMzdMJ, nRec := ListIT->( RecNo()), cKey

	If lScr  ;  FOrdRec( { 'ListIT, 2' } )
							cKey := StrZero( ListHD->nPorCisLis)
							SetScope( 'ListIT', cKey )
	Endif
	ListIt->( dbGoTop())
	nMzdMJ := ListIT->nMzdaZaKus
	If( lScr, ( ClrScope( 'ListIT'), FOrdRec()), NIL )
	ListIT->( dbGoTo( nRec))
Return( nMzdMJ)

STATIC FUNC SayMzdITEM()
	Local n, nR := 1, nC := 18, nB, ac
	Local ac0 := { ;
   '¬¡slo l¡stku :                 Rok vytvoıen¡ :           ',;
   'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',;
   'Typ l¡stku   :          (                          )     ',;
   'Druh mzdy    :          (                               )',;
   'Tarifn¡ stup.:          (                          )     ',;
   'Tarifn¡ tı¡da:          (                          )     ',;
   '                        Pl n    SkuteŸnost       PlnØn¡  ',;
   'Nh-operaci   :                                          %',;
   'Nm-operaci   :                                   Pr‚mie  ',;
   'Cena operace :                                           ',;
   'Os.Ÿ¡s. prac.:          (                               )',;
   'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',;
   'Datum mo§nì  :           ³ SmØna           :             ',;
   'Datum nutnì  :           ³ Mno§stv¡ celkem :             ',;
   'Pl n vyhot.  :           ³ Mno§stv¡ hotov‚ :             ',;
   'Skut. vyhot. :           ³ Mno§. zkontrol. :             ',;
   'Datum kontr. :           ³ Mno§. neshodn‚  :             ',;
   'Kdo kontrola :           ³ Tìden zapl n.   :             ',;
   'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',;
   'Stav l¡stku  :    (                                )     ',;
   'Druh l¡stku  :    (                                )     ' }
	Local ac1 := { ;
   '¬¡slo l¡stku :                 Rok vytvoıen¡ :           ',;
   'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',;
   'Typ l¡stku   :          (                          )     ',;
   'Druh mzdy    :          (                               )',;
   'Os.Ÿ¡s. prac.:          (                               )',;
   'Mzda za MJ   :                                           ',;
   'Mno§. celkem :                                           ',;
   'Mno§. hotov‚ :                                           ',;
   'Mno§.neshodn‚:                                           ',;
   '                        Pl n    SkuteŸnost       PlnØn¡  ',;
   'Nh-operaci   :                                          %',;
   'Nm-operaci   :                                   Pr‚mie  ',;
   'Cena operace :                                           ',;
   'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',;
   'Pl n vyhot.  :             ³ SmØna         :             ',;
   'Skut. vyhot. :             ³ Tìden zapl n. :             ',;
   'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',;
   'Stav l¡stku  :    (                                )     ',;
   'Druh l¡stku  :    (                                )     ' }

	ac := If( FULL, ac0, ac1 )
	nB := If( FULL, 22, 20 )
	DispBox( nR, nC, nR+nB, nC+60, BX_DOUBLE + ' ', 'W+/b')
	BoxShadow( nR, nC, nR+nB, nC+60 )
	For n := 1 To Len( aC)
		  @ nR+n, nC+2 Say aC[ n] Color 'w/b'
	Next
RETURN Nil

Static Function CtrlOverFlow( G)
	Local lOK := YES, n, cVar

	FOR n := 1 TO Len( G)
		If G[ n]:Type == 'N'
			 cVar := Str( G[ n]:VarGet())
			 If ( '*' $ cVar )
					Box_Alert( cEM, 'Nelze ulo§it, doçlo k pıeteŸen¡ Ÿ¡seln‚ho £daje !',;
					                acWAIT )
					lOK := NO
			 Endif
		Endif
	NEXT
Return lOK
