# Include   'C:\Lego.Wk\Include\Vyroba\Vyroba_.Ch'
# Include   'Include\RV_.Ch'
# Include   'Include\DefBrow_.Ch'

//ÄÄ Odveden¡ ML - vych z¡ z jednoduch‚ verze ML
# DEFINE   CisML       1
# DEFINE   RokML       2
# DEFINE   TypML       3
# DEFINE   DrMZD       4
# DEFINE   OsCIS       5
# DEFINE   MzdMJ       6
# DEFINE   KsCEL       7
# DEFINE   KsHOT       8
# DEFINE   KsVAD       9
# DEFINE   NhPL       10
# DEFINE   NmPL       11
# DEFINE   KcPL       12
# DEFINE   NhSK       13
# DEFINE   NmSK       14
# DEFINE   KcSK       15
# DEFINE   DatSK      16
# DEFINE   TydPL      17
# DEFINE   CisKUS     18
# DEFINE   SazPRAC    19
# DEFINE   NAZPOL1    20

# DEFINE   KodPRIPL   21
# DEFINE   KdyML      22
# DEFINE   KdoML      23
# DEFINE   KdyMZDY    24
# DEFINE   KdoMZDY    25
# DEFINE   StavLIST   26
# DEFINE   KcPRIPL    27

//ÄÄ  Typ poŸ¡tan‚ hodnoty
# Define    PLAN       1   //  KŸ Pl n
# Define    SKUT       2   //  KŸ SkuteŸnost

//ÄÄ Typ Druhu mzdy
# Define    UKOL        'UKOL'
# Define    CAS         'CASO'
# Define    REZIE       'REZI'
# Define    PRESCAS     'PRES'

STATIC  axE, cDmz
STATIC  lNewREC, lSCR, cTypML, nDrMZD, nCisML, dVyhotML

//ÄÄÄÄÄ< Odveden¡ l¡stku  ( F5)       // OdvedLST
FUNCTION MzdITEM( nKey, lCallFromScr)
	Local cScr := SaveScreen(), cClr := SetColor( 'w/b, n/bg*,,,w+/b' ), cKey
	Local nAREA := Select()
	Local lOK := NO, lCykl := YES, lMLVykazat
	Local cStavListk := AllTrim( ListIT->cStavListk)
	Local N, nRecIT := ListIT->( RecNO()), nStart := OsCIS, nSetPOS
	Local GetList := {}, aCFG
	Local bSetTAB, cMemo := ''
	Local bAcc := KeyACCESS( {|| SetACCESS( 'CRD', 'MLOdved', 1) }), lWrtACC
	Local nCfgSAZ := GetCFG( 'cSazbaVML')
	Local nCfgSTR := GetCFG( 'cStredVML')


IF NazPol1_TST( 'ListIT', nKey, '12' )
	DEFAULT nCisML TO ListHD->nPorCisLis
	DEFAULT lCallFromScr TO NO
	lSCR := lCallFromScr

  If ListIT->( RecNo()) <= ListIT->( LastRec())
    If Val( cStavListk) <= 6
	    lNewREC := ( nKey == K_INS )
	    cMemo   := If( lNewRec, '', ListIT->mTextML )
	    bSetTab := SetKey( K_TAB,;
	               { || cMemo := RvMemo( cMemo, 15, 18, MaxRow()-1, MaxCol()-1,,,;
	   		                              '( Popis mzdov‚ho l¡stku )', 'w+/B', NO ) } )
			PaintCARD()
	    If SysRV->( dbSeek( 'OdvedML'))
         Box_DispHotKeys( SysRV->cHotKeys )
		     axE := SysRV->axCard
				 // new 4.5.2004
				 // Pokud se polo§ka nepou§¡v , needituje se
				 axE[ SazPRAC, 1] := IF( nCfgSAZ == 1, 30, axE[ SazPRAC, 1] )
				 axE[ NAZPOL1, 1] := IF( nCfgSTR == 1, 30, axE[ NAZPOL1, 1] )
				 //
		     If( lNewRec, ListIT->( dbGoTo( ListIT->( LastRec() +1 ))), Nil )
				 SetFromFILE( axE)
    		 // aEVAL( axE, { |X| X[ 4] := DBGetVal( X[ 5]) })
				 SetGET( nRecIT)
				 // lKOO := OperIsKOO()      // 24.3.2003
				 lMLVykazat := TRUE   // ML_Vykazat()  // 27.1.2004
															//  zat¡m v§dy umo§n¡me vyk zat // 28.1.2004
		     FOR n := 1 TO LEN( axE)
            @ axE[ n, 1], axE[ n, 2] Get  axE[ n, 4]  Picture axE[ n, 6] ;
					    Valid MLOdvedVLD( GetList)
		        If( n == 1 .or. n = 2, ( GetList[ n]:ColorSpec := 'gr+/b', GetList[ n]:Display() ), Nil)
			      aTAIL( GetList):Cargo := axE[ n, 7]
			      WhenBl( GetList[ n])
	       NEXT
		     PlneniPROC( GetList)
				 aCFG := GetCFG( 'cKarOdvML')
				 GetLIST[ MzdMJ]:PreBlock := {|| aCFG[ 1] }
				 GetLIST[ KsCEL]:PreBlock := {|| aCFG[ 2] }
				 GetLIST[ KsHOT]:PreBlock := {|| aCFG[ 3] }
				 GetLIST[ KsVAD]:PreBlock := {|| aCFG[ 4] }
				 GetLIST[ NhSK]:PreBlock  := {|| aCFG[ 5] .AND. lMLVykazat }
				 GetLIST[ NmSK]:PreBlock  := {|| aCFG[ 6] .AND. lMLVykazat }
				 GetLIST[ SazPRAC]:PreBlock := {|| ( nCfgSAZ == 3) }
				 GetLIST[ NAZPOL1]:PreBlock := {|| ( nCfgSTR == 3) }
				 GetLIST[ KcPRIPL]:PreBlock := {|| .F. }

				 nStart := IF( nDrMZD == 0, DrMZD, OsCIS )

		 	   Do While lCykl
		 		  ReadModal( GetList, nStart )

				  lWrtACC := GetACCESS( 'CRD', 'MLOdved', 1 )
		 		  IF ( LastKey() == K_CTRL_W ) .AND. lWrtACC
					 //Ä Vyexportovanì l¡stek nelze opravit
					 IF !lNewREC .AND. !EMPTY( ListIT->dPrenos)
//						 BOX_ALERT( '( NELZE OPRAVIT )', 'L¡stek byl ji§ pýenesen do £Ÿetnictv¡ !', acWAIT )
//						 EXIT
		         CFG_PROVPs()
		         IF lOK := IsSUPERVISOR()
		 		        SetSUPERVISOR( NO)
		         ELSE
						   BOX_ALERT( '( NELZE OPRAVIT )', 'L¡stek byl ji§ pýenesen do £Ÿetnictv¡ !', acWAIT )
						   EXIT
		         ENDIF
					 ENDIF
					 //Ä Kontrola na povinn‚ polo§ky
					 IF ( ( nSetPOS := NeedITEM( GetLIST)) > 0 )
						  nStart := nSetPOS
						  LOOP
					 ENDIF
					 //Ä Kontrola na uzavýen¡ obdob¡ ( export do mezd)
					 IF IsOBD_Uzv( GetLIST[ DatSK]:VarGET())
						 LOOP
					 ENDIF
					 //Ä Kontrola na nenulovost ceny operace
					 IF IsNULA_KcSK( GetLIST[ KcSK]:VarGET(), GetLIST[ DrMZD]:VarGET() )
							LOOP
					 ENDIF
					 //Ä
		 		 	 If ( lOK := CtrlHEAD( GetList) )
             lOk := If( lNewREC, AddREC( 'ListIT'), ReplREC( 'ListIT'))
             IF lOk
  	  	        // aEVAL( axE, { |X,n| DBPutVal( X[ 5], X[ 4] )} )
								PutInFILE( axE)
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
								IF EMPTY( ListIT->cNazPol1 )
								   ListIT->cNazPol1   := MsPrc_MD->cKmenStrPr
								ENDIF
								ListIT->cNazPol2   := VyrZak->cNazPol2       // 8.1.2002
								ListIT->cNazPol4   := MsPrc_MD->cNazPol4     //  5.10.2007
    		        ListIT->cTarifStup := Operace->cTarifStup
    		        ListIT->cTarifTrid := Operace->cTarifTrid
								ListIT->mTextML   := cMEMO
		 		 				FOrdRec()
		 		 	 			SysFields( 'ListIT', lNewREC)
		 		 				StavLST()
		 		 	 			DCrUnlock( 'ListIT')
								IF lNewRec
								   cTypML := If( UPPER( ListIT->cTypListku ) == UPPER( cTypML),;
														     cTypML, ListIT->cTypListku )
									 nDrMZD := If( ListIT->nDruhMzdy == nDrMZD,;
									 					     nDrMZD, ListIT->nDruhMzdy )
//									 dVyhotML := ListIT->dVyhotSkut
								ENDIF
								dVyhotML := ListIT->dVyhotSkut
								// Aktualizace hlaviŸky ML pýi poý¡zen¡ ze SCR ...20.1.2004
								IF lCallFromSCR
									FOrdRec( { 'ListIT, 1' })
									SetSCOPE( 'ListIT', StrZERO(ListIT->nRokVytvor) + StrZERO(ListIT->nPorCisLis))
  								FootIT( YES, NO )
									FOrdRec()
								ENDIF

		 		 	   ENDIF
		 		 	   lCykl := NO
		 		 	 EndIf
		 	    EndIf

		 		  If ( LastKey() == K_PGDN ) .or. ( LastKey() == 0 )
		 		  	                            nStart := Len( GetList)  ; EndIf
		 		  If ( LastKey() == K_PGUP )  ; nStart := TypML          ; EndIf
		 		  If ( LastKey() == K_ESC  )  ; lCykl  := NO 					   ; Endif
		 	   EndDo
	    EndIf
    Else
		  Box_Alert( cEM, 'Mzdovì l¡stek ji§ nen¡ mo§no odv‚st !', acWAIT,, 11 )
    Endif
  Endif
	( RestScreen( ,,,, cScr), SetColor( cClr) )
ENDIF
	dbSelectAREA( nAREA)
	SetKEY( K_TAB, bSetTAB )
	KeyACCESS( bAcc)

RETURN( lOK)

//ÄÄÄ* Validace polo§ky mzdov‚ho l¡stku - SIMPLE-verze
STATIC FUNC MLOdvedVLD( G)
	Local  lOk   := .T., ax
	Local  nCurs := SetCursor( 0)
	Local  n     := GetActive():SubScript[ 1], nNm, nTarif
	Local  xVal  := GetActive():VarGet(), xOrg := GetActive():Original
	Local  cKey, cText, cObdForML
	Local  lValid := lNewRec .OR. ( xVal <> xOrg )
	Local  nCfg := GetCFG( 'cMzdaZaKus')
	Local  aCfgKAR := GetCFG( 'cKarOdvML')
	Local  lCfg := GetCFG('lHODdleNH')

If LastKey() <> K_UP
	Do Case
		Case n == TypML  //  Typ l¡stku
			ax := CisBrowse( 'c_TypLis', xVal )
			If ( lOK := ax[ 1])  ;   G[ n]:VarPut( ax[ 2])
															 dbSelectArea( 'ListIT')
			EndIf

		Case n == DrMZD  //  Druh mzdy
		  If( lOK := BrDrMzdy( xVal, YES ))
		     G[ n]:VarPut( DruhyMzd->nDruhMzdy )
				 @ G[ n]:Row(), G[ n]:Col()+11 Say Left( DruhyMzd->cNazevDmz, 30) Color 'bg+/b'
			EndIf
			cDmz := AllTrim( DruhyMzd->cTypDmz)
			If G[ OsCIS]:VarGet() <> 0
	 	     G[ KcSK]:VarPut( KcCMP( G, SKUT ))
			Endif

		Case n == OsCIS   // Os.Ÿ¡slo prac
			If lValid   //... 2.6.2004
		  	If( lOK := BrOsCis( xVal, YES ))
				 	IF EMPTY( MsPrc_MD->dDatVyst)
		       	G[ OsCIS]:VarPut( MsPrc_MD->nOsCisPrac )
				   	@ G[ n]:Row(), G[ n]:Col()+11 Say ;
				     	PADR( AllTrim( MsPrc_MD->cPrijPrac) + ' ' + ;
					         	AllTrim( MsPrc_MD->cJmenoPrac), 30) Color 'bg+/b'
	      	  nTarif := TarifCASO( G[ OsCIS]:VarGET(), G[ DatSK]:VarGET() )  // TarifCASO( G)
     		 		G[ SazPRAC]:VarPUT( nTarif) //!!!  * ( ProcPREM( G)/100 + 1) )   // new
 	        	G[ SazPRAC]:Display()
	 	       	G[KcSK]:VarPut( KcCMP( G, SKUT ))

				 	ELSE
					 	BOX_ALERT( cEM, { 'Pracovn¡k ¯ ' + AllTrim( MsPrc_MD->cPrijPrac) + ' ' + ;
					                                    	AllTrim( MsPrc_MD->cJmenoPrac) + ' ®',;
						                 	'm  ji§ ukonŸen pracovn¡ pomØr !'}, acWAIT )
				 	ENDIF
		  	EndIf
			EndIf
			//Ä 14.1.2003 ... Prun‚ýov
			IF lOK .and. lNewRec
				 lOK := StredInCFG( MsPrc_MD->cKmenStrPr)
				 IF !lOK
	         BOX_ALERT( cEM, 'Kmenov‚ stýed. pracovn¡ka < ' + ALLTRIM(MsPrc_MD->cKmenStrPr) + ;
					                 ' > nen¡ v konfiguraŸn¡m seznamu !', acWAIT)
				 ENDIF
			ENDIF

		Case n == MzdMJ   // Mzda za MJ
			If lValid  ;  G[ KcPL]:VarPut( KcCMP( G, PLAN ))
										IF cDmz == UKOL
       					       G[ KcSK]:VarPut( KcCMP( G, SKUT ))
										ENDIF
			Endif

 		Case n == KsCEL   // Mno§. celkem
/*
			IF lValid  ;  G[ KcPL]:VarPut( KcCMP( G, PLAN ))
  									IF cDmz == UKOL
       					       G[ KcSK]:VarPut( KcCMP( G, SKUT ))
										ENDIF
			ENDIF
*/
			nNm := IF( nCfg == 1, ( ListHD->nKusovCas * ( xVal - G[ KsVAD]:VarGET() ) ) ,;
			                      ( ListHD->nNmNaOpePl / ListHD->nKusyCelk) * ( xVal - G[ KsVAD]:VarGET()) )
			G[ NmPL]:VarPut( nNm)
			G[ NhPL]:VarPut( nNm / 60 )
			G[ KsHOT]:VarPut( xVal)
			G[ KsVAD]:VarPut( 0)
			// 27.1.2005
			IF lValid  ;  G[ KcPL]:VarPut( KcCMP( G, PLAN ))
   					        G[ KcSK]:VarPut( KcCMP( G, SKUT ))
			ENDIF

		Case n == KsHOT   // Mno§. hotov‚
			IF ( lOK := xVAL <= G[ KsCEL]:VarGET() )
				G[ KsVAD]:VarPut( G[ KsCEL]:VarGET() - xVal )
/* 27.1.2005
			  If cDmz == UKOL ;  G[ KcPL]:VarPut( KcCMP( G, PLAN ))
				                   G[ KcSK]:VarPut( KcCMP( G, SKUT ))
			  Endif
*/
				// 15.11.2004 ... START
				IF lCfg
			    nNm := IF( nCfg == 1, ( ListHD->nKusovCas * xVal ) ,;
			                          ( ListHD->nNmNaOpePl / ListHD->nKusyCelk) * xVal )
			    G[ NmSK]:VarPut( nNm)
			    G[ NhSK]:VarPut( nNm / 60 )
				ENDIF
				// 15.11.2004 ... END

			  G[ KcPL]:VarPut( KcCMP( G, PLAN ))    // 27.1.2005
				G[ KcSK]:VarPut( KcCMP( G, SKUT ))    // 27.1.2005
			ELSE
				BOX_ALERT( cEM, 'Mn.hotov‚ nem…§e bìt vØtç¡ ne§ mn.celkem !', acWAIT,, 11)
				G[ n]:UNDO()
			ENDIF

		Case n == KsVAD   // Mno§. vadn‚, neshodn‚
			IF ( lOK := xVAL <= G[ KsCEL]:VarGET() )
				G[ KsHOT]:VarPut( G[ KsCEL]:VarGET() - xVal )
			  nNm := IF( nCfg == 1, ( ListHD->nKusovCas * ( G[ KsCEL]:VarGET() - xVAL) ) ,;
			                        ( ListHD->nNmNaOpePl / ListHD->nKusyCelk) * ( G[ KsCEL]:VarGET() - xVAL) )
			  G[ NmPL]:VarPut( nNm)
			  G[ NhPL]:VarPut( nNm / 60 )

			ELSE
				BOX_ALERT( cEM, 'Mn.neshodn‚ nem…§e bìt vØtç¡ ne§ mn.celkem !', acWAIT,, 11)
				G[ n]:UNDO()
			ENDIF

		CASE n == NhPL  // Nh pl n
			IF lValid ; G[ NmPL]:VarPut( xVal * 60)
				          IF xVal <> 0
				 	           G[ KcPL]:VarPut( KcCMP( G, PLAN ))
										 PlneniPROC( G)
			            ENDIF
			ENDIF

		CASE n == NhSK  //Ä Nh skut.
			IF lValid
			   G[ NmSK]:VarPut( xVal * 60)
				 IF xVal <> 0
				   G[ KcSK]:VarPut(   KcCMP( G, SKUT ))
				   PlneniPROC( G)
				 ELSEIF !aCfgKAR[ 6]
				   BOX_ALERT( cEM, 'Nutno vyplnit odpracovanì Ÿas !', acWAIT,,14 )
				 ENDIF
				 CastkaPRIPL( G)
			ENDIF
			IF G[ DrMZD]:VarGET() == 0
				 __KeyBOARD( CHR( K_CTRL_W))
			ENDIF

		CASE n == NmPL  //Ä Nm pl n
			IF lValid ;  G[ NhPL]:VarPut( xVal / 60)
								   G[ KcPL]:VarPut( KcCMP( G, PLAN ))
									 PlneniPROC( G)
			ENDIF

		CASE n == NmSK  // Nm skut.
			IF lValid
				 G[ NhSK]:VarPut( xVal / 60)
				 IF xVAL <> 0
				   G[ KcSK]:VarPut(   KcCMP( G, SKUT ))
				   PlneniPROC( G)
				 ELSE // IF !aCfgKAR[ 5]
				   BOX_ALERT( cEM, 'Nutno vyplnit odpracovanì Ÿas !', acWAIT,,14 )
				 ENDIF
				 CastkaPRIPL( G)
			ENDIF
			IF G[ DrMZD]:VarGET() == 0
				 __KeyBOARD( CHR( K_CTRL_W))
			ENDIF

		CASE n == DatSK  //  Dat. skut. vyhot.
			IF lValid
				IF !Empty( G[ DatSK]:VarGet() )

					cObdForML := GetCFG( 'cObdForML')
					lOK := VAL( LEFT( cObdForML, 2))  == MONTH( xVAL ) .AND. ;
 				       	VAL( RIGHT( cObdForML, 4)) == YEAR( xVAL )
					IF !lOK
						lOK := BOX_Alert( '( Chybn‚ datum )',;
					          	{ 'Poýizujete mimo konfiguraŸnØ nastaven‚ho obdob¡ ' + cObdForML + ' !',;
					 				    	'Po§adujete z pis ?' }, acNOYES ) = 2
					ENDIF
					IF lOK
		       	G[ TydPL]:VarPut( WEEK( xVAL) )
	      	 	nTarif := TarifCASO( G[ OsCIS]:VarGET(), xVAL )
     		 	 	G[ SazPRAC]:VarPUT( nTarif)   //!! * ( ProcPREM( G)/100 + 1) )
	 	       	G[ SazPRAC]:Display()
       		 	G[ KcPL]:VarPut( KcCMP( G, PLAN ))
       		 	G[ KcSK]:VarPut( KcCMP( G, SKUT ))
					ENDIF

					//Ä
					IF lOK
				  	IF !EMPTY( MsPrc_MD->dDatVyst)
							IF xVAL >= MsPrc_MD->dDatVyst
					    	BOX_ALERT( cEM, { 'Pracovn¡k ¯ ' + AllTrim( MsPrc_MD->cPrijPrac) + ' ' + ;
					                                       	AllTrim( MsPrc_MD->cJmenoPrac) + ' ®',;
						                    	'm  k tomuto dni ji§ ukonŸen pracovn¡ pomØr !'}, acWAIT,,6 )
					    	lOK := NO
							ENDIF
						ENDIF
					ENDIF

	    	ENDIF
			ENDIF

		Case n == CisKUS  //  ¬¡slo kusu
			IF ( lOK := ( xVAL < 0))
				BOX_ALERT( cEM, '¬¡slo kusu mus¡ bìt kladn‚ !', acWAIT)
			ENDIF
			IF ( lOK := !lOK)
				IF( lOK := ( xVAL > VyrZAK->nMnozPlano))
				   BOX_ALERT( cEM, { '¬¡slo kusu nem…§e bìt vØtç¡ ne§ mn. pl novan‚ !',;
					                   '( Mn. pl novan‚ = ' + ALLTRIM( STR( VyrZAK->nMnozPlano, 9, 2)) + ' )' }, acWAIT)
				ENDIF
				lOK := !lOK
			ENDIF

		Case n == SazPRAC  //  Sazba pracovn¡ka
			IF lValid
   		  G[ KcPL]:VarPut( KcCMP( G, PLAN, xVAL ))
        G[ KcSK]:VarPut( KcCMP( G, SKUT, xVAL ))
			ENDIF

		Case n == NAZPOL1  //  Stýedisko
			ax := CisBrowse( 'cNazPol1', xVal )
			If ( lOK := ax[ 1])  ;   G[ n]:VarPut( ax[ 2])
															 dbSelectArea( 'ListIT')
			EndIf

		Case n == KodPRIPL  //  K¢d pý¡platku
			ax := CisBrowse( 'c_Pripl', xVal, 'nHodPripl' )
			If ( lOK := ax[ 1])  ;   G[ n]:VarPut( ax[ 2])
															 dbSelectArea( 'ListIT')
			   G[ KcPRIPL]:VarPUT( G[ NhSK]:VarGET() * ax[ 3] )
			EndIf

	EndCase
	aEval( G, { |X| X:Display() } )
	WhenBl( G[ n])
Else
	G[ n]:Undo()
EndIf
SetCursor( nCurs)

RETURN( lOK)

//ÄÄÄ< VìpoŸet Pl novanìch a SkuteŸnìch K¬
STATIC FUNC KcCMP( G, nTypKC, nNewTarif )
	Local nKc := 0, nTarif, nSazPrePr

	FOrdRec( { 'DruhyMzd, 1', 'MsPrc_MD, 1' } )
	MsPrc_MD->( dbSeek( G[ OsCIS]:VarGet() ))
  DruhyMzd->( dbSeek( G[ DrMZD]:VarGet() ))
  nSazPrePr := ProcPREM( G)

	cDmz := AllTrim( DruhyMzd->cTypDmz )
	If cDmz == UKOL
		 nKc := G[ MzdMJ]:VarGet() * If( nTypKc == PLAN,;
		                               G[ KsCEL]:VarGet(), G[ KsHOT]:VarGet() )

	ElseIf ( cDmz == CAS) .OR. ( cDmz == REZIE)
		 IF IsNIL( nNewTarif)
				IF lNewREC
  		 		nTarif := TarifCASO( G[ OsCIS]:VarGET(), G[ DatSK]:VarGET() )
				ELSE
					nTarif := G[ SazPRAC]:VarGET()
				ENDIF
		 		nKc := nTarif * ( nSazPrePr / 100 + 1 ) * ;
            		If( nTypKc == PLAN, G[ NhPL]:VarGet(), G[ NhSK]:VarGet() )
		 ELSE
		 		nKc := nNewTarif * ( nSazPrePr / 100 + 1 ) * ;
            		If( nTypKc == PLAN, G[ NhPL]:VarGet(), G[ NhSK]:VarGet() )
		 ENDIF

/*
	ElseIf ( cDmz == REZIE)
		 nKc := MsPrc_MD->nHodTarSml * ( MsPrc_MD->nSazPrePr / 100 + 1 ) * ;
            If( nTypKc == PLAN, G[ NhPL]:VarGet(), G[ NhSK]:VarGet() )
*/
	ElseIf cDmz == PRESCAS
//		 nKc := MsPrc_MD->nHodPresca * If( nTypKc == PLAN,;
//		                                   G[ NhPL]:VarGet(), G[ NhSK]:VarGet() )
	Endif
	FOrdRec()
RETURN( nKc)

//ÄÄÄ< Tarif Ÿasov‚ mzdy >ÄÄÄ
FUNCTION TarifCASO( nOsCisPrac, dVyhotSKUT )
	LOCAL	cTypTarPOU := UPPER( MsPrc_MD->cTypTarPOU)
	Local cALIAS, cTAG, cKEY := '', cKEYi
//	Local dVyhotSKUT := G[ DatSK]:VarGET(), dDatHLP := CTOD( '  .  .  ')
	Local dDatHLP := CTOD( '  .  .  ')
	Local nTARIF := 0

	DO CASE
		CASE cTypTarPOU == 'INDIVIDU' .OR. cTypTarPOU == 'HROMADNY'
			IF cTypTarPOU == 'INDIVIDU'
				 cALIAS := 'MSTARIND'
				 cKEY := RIGHT( StrZERO( nOsCisPrac), 5 )
			ELSE
				 cALIAS := 'MSTARHRO'
				 //Ä V MsTarInd zjist¡ Tar.skupinu, tar.tý¡du a d‚lku prac.doby
				 MSTARIND->( OrdSetFOCUS( 1))
				 cKEYi := RIGHT( StrZERO( nOsCisPrac ), 5 )
			   SetSCOPE( 'MSTARIND', cKEYi )
					 DO WHILE !MSTARIND->( EOF())
				     IF ( MSTARIND->dPlatTarOd <= dVyhotSKUT .AND. dVyhotSKUT <= MSTARIND->dPlatTarDo ) .OR. ;
					      ( MSTARIND->dPlatTarOd <= dVyhotSKUT .AND. EMPTY( MSTARIND->dPlatTarDo ) )
					     IF dDatHLP <= MSTARIND->dPlatTarOd
			            cKEY    := Cs_Upper( MSTARIND->cTarifTrid) + Cs_Upper( MSTARIND->cTarifStup) + ;
													   Cs_Upper( MSTARIND->cDelkPrDob)
							    dDatHLP := MSTARIND->dPlatTarOd
					     ENDIF
				     ENDIF
						 MSTARIND->( dbSKIP())
					 ENDDO
				 CLRSCOPE( 'MSTARIND')
				 dDatHLP := CTOD( '  .  .  ')
				 //Ä
			ENDIF
			//Ä Pokud se nenajdou v MsTarInd, vezmou se z MsPrc_MD
			cKEY := IF( EMPTY( cKEY), Cs_Upper( MsPrc_MD->cTarifTrid) + Cs_Upper( MsPrc_MD->cTarifStup) + ;
																Cs_Upper( MsPrc_MD->cDelkPrDob),;
									              cKEY )
			cTAG := ( cALIAS)->( OrdSetFOCUS( 1))
			SetSCOPE( cALIAS, cKEY )

			DO WHILE !( cALIAS)->( EOF())
				IF ( ( cALIAS)->dPlatTarOd <= dVyhotSKUT .AND. dVyhotSKUT <= ( cALIAS)->dPlatTarDo ) .OR. ;
					 ( ( cALIAS)->dPlatTarOd <= dVyhotSKUT .AND. EMPTY( ( cALIAS)->dPlatTarDo ) )
					 IF dDatHLP <= ( cALIAS)->dPlatTarOd
					    nTARIF  := ( cALIAS)->nTarSazHod
							dDatHLP := ( cALIAS)->dPlatTarOd
					 ENDIF
				ENDIF
				( cALIAS)->( dbSKIP())
			ENDDO
			ClrSCOPE( cALIAS)
			( cALIAS)->( OrdSetFOCUS( cTAG))

		CASE cTypTarPOU == 'NEPOUZIV' .OR. EMPTY( cTypTarPOU )
			nTARIF := MsPrc_MD->nTarSazHod
	ENDCASE

RETURN nTARIF

//ÄÄÄ< >ÄÄÄ
STATIC FUNCT ProcPREM( G)
	Local cTAG, cKEY := RIGHT( StrZERO( G[ OsCIS]:VarGET() ), 5 )
	Local nSazPrePr := 0, lExist := NO
	Local dVyhotSKUT := G[ DatSK]:VarGET(), dDatHLP := CTOD( '  .  .  ')

	cTAG := MSSAZZAM->( OrdSetFOCUS( 4))
	SetSCOPE( 'MSSAZZAM', cKEY )

	DO WHILE !MSSAZZAM->( EOF())
		IF ( MSSAZZAM->dPlatSazOd <= dVyhotSKUT .AND. dVyhotSKUT <= MSSAZZAM->dPlatSazDo ) .OR. ;
			 ( MSSAZZAM->dPlatSazOd <= dVyhotSKUT .AND. EMPTY( MSSAZZAM->dPlatSazDo ) )
			 IF dDatHLP <= MSSAZZAM->dPlatSazOd
			    nSazPrePr := MSSAZZAM->nSazPrePr
					dDatHLP   := MSSAZZAM->dPlatSazOd
			 ENDIF
			 lExist := YES  //Ä Existuje interval se sazbou premii
		ENDIF
		MSSAZZAM->( dbSKIP())
	ENDDO
	ClrSCOPE( 'MSSAZZAM')
	MSSAZZAM->( OrdSetFOCUS( cTAG))
	//Ä Nen¡-li sazba pr‚mie v MSSAZZAM, bereme ji z MsPrc_MD
	nSazPrePr := IF( lExist, nSazPrePr, MsPrc_MD->nSazPrePr )

RETURN nSazPrePr

//ÄÄÄ< VìpoŸet % plnØn¡ na z kladØ NhPl a NhSk >ÄÄÄ
STATIC FUNCT PlneniPROC( G)
	LOCAL nProc := ( G[ NhPL]:VarGet() / G[ NhSK]:VarGet()) * 100

	@ 12, 69 SAY STR( nProc, 6, 2) Color 'bg+/b'
RETURN NIL

//ÄÄÄ< VìpoŸet Ÿ stky pý¡platku >ÄÄÄ
STATIC FUNCT CastkaPRIPL( G)
	LOCAL nHodPripl := 0, cKodPripl := G[ KodPRIPL]:VarGET()

	IF !EMPTY( cKodPripl)
		c_Pripl->( dbSEEK( Cs_Upper( cKodPripl)))
		nHodPripl := c_Pripl->nHodPripl
		G[ KcPRIPL]:VarPUT( G[ NhSK]:VarGET() * nHodPripl )
		G[ KcPRIPL]:Display()
	ENDIF
RETURN NIL

//ÄÄÄ< >ÄÄÄ
STATIC FUNC IsOBD_Uzv( dDatSK )
	Local cOBDOBI := STRZERO( MONTH( dDatSK), 2)
	Local cROK := STRZERO( YEAR( dDatSK), 4 )
	Local cKEY := Cs_UPPER( 'D') + cROK + cOBDOBI, lOK := NO
	Local cObdForML := GetCFG( 'cObdForML'), lOKobd

	FOrdREC( { 'UcetSYS, 3' } )
	IF UcetSYS->( dbSEEK( cKEY)) .AND. UcetSYS->lZavren
		BOX_ALERT( '( NELZE ULO¦IT )', { 'Datum vyhotoven¡ l¡stku spad  do uzavýen‚ho obdob¡,',;
		                  'tj. probØhl export dan‚ho obdob¡ !' }, acWAIT )
		lOK := YES
	ELSE
		lOKobd := VAL( LEFT( cObdForML, 2))  == MONTH( dDatSk ) .AND. ;
 				      VAL( RIGHT( cObdForML, 4)) == YEAR( dDatSk )
		IF !lOKobd
			lOK := ! BOX_Alert( '( Chybn‚ datum )',;
				          { 'Poýizujete mimo konfiguraŸnØ nastaven‚ho obdob¡ ' + cObdForML + ' !',;
			 				    'Po§adujete z pis ?' }, acNOYES ) = 2


			/*  5.2.2004
			 BOX_ALERT( '( Chybn‚ datum )',;
					      { 'Nelze poý¡dit do jin‚ho, ne§ konfiguraŸnØ nastaven‚ho',;
					 		    'obdob¡, a t¡m je obdob¡  ' + cObdForML + ' !' }, acWAIT )
			 lOK := YES
			 */
		ENDIF
	ENDIF
	FOrdREC()
RETURN lOK

//ÄÄÄ< >ÄÄÄ
STATIC FUNC IsNULA_KcSK( nKcSK, nDruhMzdy )
	Local nChoice, nREC := DruhyMzd->( RecNO())
	Local cTAG, cTypDmz

	IF nKcSK == 0
		 cTAG := DruhyMzd->( OrdSetFOCUS( 1))
		 DruhyMzd->( dbSEEK( nDruhMzdy))
		 cTypDmz := UPPER( DruhyMzd->cTypDmz)
		 IF cTypDmz <> 'PODM'
		   nChoice := BOX_ALERT( 'Cena operace je nulov  !',;
		              { 'K pracovn¡kovi nen¡ nastavena sazba, tarif nebo stupnice.',;
								    'Po§adujete z pis l¡stku ?'},;
		 					 		  acNOYES,,15 )
		ENDIF
		DruhyMzd->( OrdSetFOCUS( cTAG), dbGoTO( nREC) )
	ENDIF
RETURN ( nChoice == 1 .or. nChoice == 0 )

//ÄÄÄ< >ÄÄÄ
STATIC FUNC SetGET( nRecIT)
  Local	cObdForML := GetCFG( 'cObdForML')
	Local nCFG := GetCFG( 'cMnozCelML')

OpenFILES( { 'DruhyMzd', 'MsPrc_MD' } )
// FOrdREC( { 'DruhyMzd, 1', 'MsPrc_MD, 1' } )
DruhyMzd->( OrdSetFOCUS( 1))
MsPrc_MD->( OrdSetFOCUS( 1))

IF lNewREC
  ListIT->( dbGoTO( nRecIT))
	cTypML := IF( IsNil( cTypML) .OR. nCisML <> ListHD->nPorCisLis,;
	              ListIT->cTypListku, cTypML)
	nDrMZD := IF( IsNil( nDrMZD) .OR. nCisML <> ListHD->nPorCisLis,;
	              ListIT->nDruhMzdy, nDrMZD)
	axE[ CisML, 4] := ListHD->nPorCisLis
	axE[ RokML, 4] := ListHD->nRokVytvor
	axE[ TypML, 4] := cTypML
	axE[ DrMZD, 4] := nDrMZD
	DruhyMzd->( dbSEEK( ListIT->nDruhMzdy))
	@ axE[ DrMZD, 1], axE[ DrMZD, 2]+11 Say Left( DruhyMzd->cNazevDmz, 30) Color 'bg+/b'
	axE[    KsCEL, 4] := IF( nCFG == 2, OnlyToZERO( ListHD->nKusyCELK - ListHD->nKusyHOTOV), 0 )
	IF IsNIL( dVyhotML)
		dVyhotML := CTOD( '01.' + LEFT( cObdForML, 2) + '.'+ RIGHT( cObdForML, 4) )
	ENDIF
	axE[    DatSK, 4] := dVyhotML  // CTOD( '01.' + LEFT( cObdForML, 2) + '.'+ RIGHT( cObdForML, 4) )
	axE[    TydPL, 4] := WEEK( DATE())
	axE[   CisKUS, 4] := ListHD->nCisloKusu
	axE[ StavLIST, 4] := '1'
	axE[    MzdMJ, 4] := SetMzdMJ()

ELSE
	  DruhyMzd->( dbSeek( ListIT->nDruhMzdy))
	  @ axE[ DrMZD, 1], axE[ DrMZD, 2]+11 Say Left( DruhyMzd->cNazevDmz, 30) Color 'bg+/b'
  	cDmz := AllTrim( DruhyMzd->cTypDmz )
	  MsPrc_MD->( dbSeek( ListIT->nOsCisPrac))
 	  @ axE[ OsCIS, 1], axE[ OsCIS, 2]+11 Say PADR( AllTrim( MsPrc_MD->cPrijPrac) + ' ' +;
		 				                          AllTrim( MsPrc_MD->cJmenoPrac), 30) Color 'bg+/b'
//	FOrdREC()
	axE[ DatSK, 4] := IF( EMPTY( ListIT->dVyhotSkut), DATE(), ListIT->dVyhotSkut)
	axE[ TydPL, 4] := WEEK( axE[ DatSK, 4] )    //ListIT->dVyhotSkut)
	@ axE[ StavLIST, 1], axE[ StavLIST, 2] +5 SAY  ;
	           SubStr( StavML[ Val( axE[ StavLIST, 4])], 5) Color 'bg+/b'
	nDrMZD := ListIT->nDruhMzdy
ENDIF

RETURN Nil

//ÄÄÄ< >ÄÄÄ
STATIC FUNC PaintCARD()
	Local n, nR := 1, nC := 18, nB := 22
	Local nCfgSAZ := GetCFG( 'cSazbaVML')
	Local lSaz := ( nCfgSAZ <> 1 )
	Local nCfgSTR := GetCFG( 'cStredVML')
	Local lStr := ( nCfgSTR <> 1 )
	Local ac := { ;
   '¬¡slo l¡stku :                 Rok vytvoýen¡ :           ',;
   'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',;
   'Typ l¡stku   :          (                          )     ',;
   'Druh mzdy    :          (                               )',;
   'Os.Ÿ¡s. prac.:          (                               )',;
   'Mzda za MJ   :                                           ',;
   'Mno§. celkem :                  ' + IF( lSaz, 'Sazba prac.:', ''),;
   'Mno§. hotov‚ :                  ' + IF( lStr, 'Stýedisko  :', ''),;
   'Mno§.neshodn‚:                                           ',;
   '              ÄÄÄÄÄÄÄÄÄÄPl n ÄÄÄSkuteŸnost ÄÄÄÄÄÄPlnØn¡ÄÄ',;
   'Nh-operaci   :                                          %',;
   'Nm-operaci   :                                           ',;
   'Cena operace :                                           ',;
   'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',;
   'Skut. vyhot. :            ³ K¢d pý¡platku   :            ',;
   'Tìden zapl n.:            ³ (                          ) ',;
   '¬¡slo kusu   :            ³ Pý¡platky CELKEM:            ',;
   'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',;
	 'Z pis - KDY  :              Pýenos mzdy- KDY :           ',;
	 '      - KDO  :                         - KDO :           ',;
   'Stav l¡stku  :    (                                )     ' }

	DispBox( nR, nC, nR+nB, nC+60, BX_DOUBLE + ' ', 'W+/b')
	BoxShadow( nR, nC, nR+nB, nC+60 )
	@ nR, nC+2 SAY ' ODVEDENÖ MZDOVHO LÖSTKU ' Color 'W*/B+'
	FOR n := 1 To Len( aC)
		  @ nR+n, nC+2 Say aC[ n] Color 'w/b'
	NEXT
RETURN Nil

//Ä
STATIC FUNC NeedITEM( G)
  Local aItem := { DrMZD, DatSK }
	Local lRet := YES
	Local cObdForML := GetCFG( 'cObdForML')
	Local cTEXT := '', acTEXT := { 'DRUH MZDY', 'DATUM SK. VYHOTOVENÖ' }, alERR := {}
	Local nRokCFG := VAL( RIGHT( cObdForML, 4)), nMesCFG := VAL( LEFT( cObdForML, 2))
	Local dDatSk := G[ DatSK]:VarGET()
	Local nRokSk := YEAR( dDatSk), nMesSk := MONTH( dDatSk), nSetPOS := 0

//  AEVAL( aItem, {|N| lRET := IF( EMPTY( G[ N]:VarGET() ), NO, lRET) })
  AEVAL( aItem, {|X,n|  IF( EMPTY( G[ X]:VarGET() ),;
	                          ( cTEXT += acTEXT[ n], AADD( alERR, X), lRET := NO ),;
														lRET := lRET) })
	IF !lRET
		 BOX_ALERT( cEM, { 'Nebyly vyplnØny povinn‚ £daje !',;
		                   cTEXT }, acWAIT, 'R/W*, W*/B+' )
	ENDIF
	nSetPOS := IF( LEN( alERR) > 0, alERR[ 1], nSetPOS )
	IF( nSetPOS > 0, G[ nSetPOS]:SetFOCUS(), NIL )
	IF nSetPOS == DatSK
		 IF ( nRokCFG <> nRokSk) .OR. ( nMesCFG <> nMesSk)
			 lRET := BOX_Alert( '( Chybn‚ datum )',;
			           { 'Poýizujete mimo konfiguraŸnØ nastaven‚ obdob¡  ' + cObdForML + ' !',;
			 				     'Umo§nit z pis  ?' }, acNOYES ) == 1
		 ENDIF

		 /*
		 IF ( nRokCFG <> nRokSk) .OR. ( nMesCFG <> nMesSk)
			 BOX_Alert( '( Chybn‚ datum )',;
			           { 'Nelze poý¡dit do jin‚ho, ne§ konfiguraŸnØ nastaven‚ho',;
			 				     'obdob¡, a t¡m je obdob¡  ' + cObdForML + ' !' }, acWAIT )
			 lRET := YES
			 // G[ DatSK]:SetFOCUS()
		 ENDIF
		 */
	ENDIF
	IF !EMPTY( MsPrc_MD->dDatVyst)
		IF dDatSk >= MsPrc_MD->dDatVyst
	    BOX_ALERT( cEM, { 'Pracovn¡k ¯ ' + AllTrim( MsPrc_MD->cPrijPrac) + ' ' + ;
	                                       AllTrim( MsPrc_MD->cJmenoPrac) + ' ®',;
		                    'm  k tomuto dni ji§ ukonŸen pracovn¡ pomØr !'}, acWAIT,,6 )
			nSetPos := DatSK
		ENDIF
	ENDIF

RETURN nSetPOS

//ÄÄÄ< Pýednastaven¡ Mzdy za MJ. >ÄÄÄÄ
STATIC FUNC SetMzdMJ()
	Local nMzdMJ, nREC := ListIT->( RecNO()), cKey

	IF lSCR  ;  FOrdREC( { 'ListIT, 2' } )
							cKey := StrZERO( ListHD->nPorCisLis)
							SetSCOPE( 'ListIT', cKey )
	ENDIF
	ListIt->( dbGoTOP())
	nMzdMJ := ListIT->nMzdaZaKus
	IF( lSCR, ( ClrSCOPE( 'ListIT'), FOrdREC()), NIL )
	ListIT->( dbGoTO( nREC))
RETURN( nMzdMJ)

//ÄÄÄÄÄ< Kontrola na PLµN v hlaviŸce ML oproti SKUTE¬NOSTI v polo§k ch ML
FUNCTION CtrlHEAD( G )
	Local  aS := { 0, 0, 0 }, nRec := ListIT->( RecNo())
  Local  cKey, cTyp, cVar, cText := '', acText, lOK := YES
	Local  nHlp, nPos
	Local  alCFG := GetCFG( 'cKonVykNOR')

	IF lScr  ;  FOrdREC( { 'ListIT, 2' } )
							cKey := StrZERO( ListHD->nPorCisLis)
							SetSCOPE( 'ListIT', cKey )
	ENDIF
	ListIT->( dbGoTOP())
	ListIT->( dbEVAL( { || cTyp := UPPER( LEFT( ListIT->cTypListku, 1)),;
						IF( lNewRec .or. ( !lNewRec .and. ListIT->( RecNO()) <> nRec),;
            IF( cTyp $ 'VR', NIL,;
               ( aS[ 1] += ListIT->nKusyHotov ,;
                 aS[ 2] += ListIT->nNhNaOpeSk ,;
                 aS[ 3] += ListIT->nKcNaOpeSk  )), NIL ) }))
	ListIT->( dbGoTO( nREC))
	cTyp := UPPER( LEFT( G[ TypML]:VarGET(), 1))

	IF !( cTyp $ 'VR')  //Ä V¡cepr ce, RuŸn¡
	  aS[ 1] += G[ KsHOT]:VarGET()
    aS[ 2] += G[  NhSK]:VarGET()
    aS[ 3] += G[  KcSK]:VarGET()
		//ÄÄ Kontrola na Kusy hotov‚
		IF ListHD->nKusyCelk < aS[ 1] .AND. alCFG[ 1]
			cVar  :=  Str( aS[ 1] - ListHD->nKusyCelk, 11, 2 )
      cText += 'Nelze vyk zat o ' + cVar + ' vØtç¡ mno§stv¡ ne§ je pl n !'
    ENDIF
		//ÄÄ Kontrola na Normohodiny skuteŸn‚
		nPos := AT( '.', Str( aS[ 2]) )
		nHlp := VAL( SubStr( Str( aS[ 2] ), 1, nPos+4 ) )
		IF ListHD->nNhNaOpePl < nHlp .AND. alCFG[ 2] //   aS[ 2]
			cVar  := Str( aS[ 2] - ListHD->nNhNaOpePl, 10, 4 )
      cText += If( Empty( cText), '', ';') + 'Nelze vyk zat o ' + cVar + '  Nh v¡ce ne§ je pl n !'
    ENDIF
		//ÄÄ Kontrola na ¬ stku skuteŸnou
		nPos := AT( '.', Str( aS[ 3]) )
		nHlp := VAL( SubStr( Str( aS[ 3] ), 1, nPos+3 ) )
		IF ListHD->nKcNaOpePl < nHlp .AND. alCFG[ 3] //   aS[ 3]
			cVar  := Str( aS[ 3] - ListHD->nKcNaOpePl, 11, 3 )
      cText += If( Empty( cText), '', ';') + 'Nelze vyk zat o ' + cVar + ' KŸ v¡ce ne§ je pl n !'
    ENDIF
		IF !EMPTY( cText)
		   acText := If( ';' $ cText, ListAsArray( cText, ';'), cText )
			 BOX_ALERT( cEM, acText, acWAIT )
			 lOK := NO
		ENDIF
	ENDIF
	IF( lScr, ( ClrSCOPE( 'ListIT'), FOrdREC() ), NIL )
RETURN( lOK)

//ÄÄÄÄÄ< Generov n¡ obdob¡ >ÄÄÄÄ
FUNCTION WhatOBD( lTydKapBlo )
	Local cObd, cDate := '  .  .  ', nWeekOfYear := 0

	DEFAULT lTydKapBlo TO NO
	IF !EMPTY( ListIT->dVyhotSkut)
		cDate := DtoC( ListIT->dVyhotSkut)
		nWeekOfYear := WEEK( ListIT->dVyhotSkut)
	ELSEIF !EMPTY( ListIT->dVyhotPlan)
		cDate := DtoC( ListIT->dVyhotPlan)
		nWeekOfYear := WEEK( ListIT->dVyhotPlan)
	ENDIF
	cObd := SubSTR( cDate, 4, 2) + '/' + RIGHT( cDate, 2)
	IF lTydKapBlo
		 ListIT->nTydKapBlo := nWeekOfYear
	ENDIF
RETURN( cObd)

//ÄÄÄÄÄ< VìbØrovì browse nad MsPrc_MD >ÄÄÄÄ
FUNCTION BrOsCis( nOsCis, lClear )
	Local  axKey, axMs
	Local  lRetVal := FALSE, nRecNo := MsPrc_MD->( RecNo())
  Local  cOldClr := SetColor( 'w*/b+, w+/n,,,w/w' )
	Local  cScr    := SaveScreen(), cKey
	Local  cHD := 'ÄOs.¬¡s.ÂÄPý¡jmen¡ ÄÄÄÄÄÄÄÄÄÄÄÂÄJm‚noÄÄÄÄÄÄÄÄÄÄÄÄ'
	Static oV

	DEFAULT lClear TO NO
  axKey := {  { K_RETURN  , {|| lRetVal := .t.                ,;
	                              nRecNo := MsPrc_MD->( RecNo()),;
	                              oV:stopbrow()                },;
                ' Enter~vìbØr'                               },;
							{ K_INS     , {|| KarMzPrc( K_INS, 1, YES) }    ,;
								'Ins~novì'                                   } }

  FOrdREC( { 'MsPrc_MD, 1' } )
	IF MsPrc_MD->( dbSEEK( nOsCis))
	   ( nRecNo := MsPrc_MD->( RecNo()), lRetVal := YES )
	ELSE
		 axMs := OnlyArrDef( 'MsPrc_MD')
     oV   := oSBrow():New( 3, 2, 21, 50, axMs, axKey , ;
                        { 'nOsCisPrac', 'cPrijPrac', 'cJmenoPrac' },;
												{ { 1, 1}, { 2, 2} }, NO )
		 oV:oBrowse:FootSep := ''
		 IF( lClear, ClearWin( 0, 0, 23, 51, 'w/w'), NIL )
		 DispBoxW( 1, 2, 22, 50, 'W/B+')
		 DispOutAt( 1, 2, PadC( ' ( Seznam pracovn¡k… ) ', 49), 'w+/B')
		 DispOutAt(  2, 2, cHD, 'gr+/B*')
		 oV:Run( .t., 1,,,,, FALSE )
	ENDIF
	FOrdREC()
	MsPrc_MD->( dbGoTO( nRecNo))
	( SetCOLOR( cOldClr), RestSCREEN( ,,,, cScr ) )
RETURN( lRetVal )

//ÄÄÄÄÄ< N hrada druhu mzdy   na ALT+P nad screenem >ÄÄ
FUNCTION ReplaceDMZ( nPorCisLis)
	Local cSCR := SaveSCREEN(), cC := 'W+/N*'
	Local cObdForML := GetCFG( 'cObdForML')
	Local cObdobi := LEFT( cObdForML, 3 ) + RIGHT( cObdForML, 2), cScope
	Local nDruhMzdy := 0, nKEY, GetLIST := {}
	Local nRecNO := ListIT->( RecNO())
	Local cTAG := ListIT->( OrdSetFOCUS( 11)), nCOUNT := 1, nRecCount

	DC_DcOPEN( { 'DruhyMZD, 1' } )
	DispBOX( 2, 0, 22, 79, BX_DOUBLE + ' ', 'W+/N*')
	@  4, 4 SAY 'SpuçtØn¡m tohoto mechanismu se v polo§k ch mzdovìch l¡stk…,' Color cC
	@  5, 4 SAY 'kter‚ splåuj¡ tyto podm¡nky: - spadaj¡ do obdob¡ nastaven‚m v konfiguraci' Color cC
	@  6, 4 SAY '                             - os. Ÿ¡slo pracovn¡ka  > 0' Color cC
	@  7, 4 SAY '                             - KŸ na operaci skuteŸn‚ = 0' Color cC
	@  8, 4 SAY 'nahrad¡ druh mzdy novìm druhem mzdy definovanìm u§ivatelem. 'Color cC
	@ 10, 4 SAY 'Zadejte novì druh mzdy : ' Color 'gr+/n*'
	@ 10,35 SAY '(                               )' Color 'w/n*'

  @ 10,29 GET nDruhMzdy Color 'bg+/W, N/BG*' Picture '9999' ;
												VALID ValidDrMzd( GetLIST )
	IF ReadMODAL( GetLIST)
	   IF BOX_ALERT( cQM, 'SkuteŸnØ po§adujete nahradit druh mzdy v obdob¡ ¯ ' + cObdForML + ' ®  ?' , acNOYES,, 12 ) == 2
				cScope := IF( IsNIL( nPorCisLis), Cs_Upper( cObdobi),;
				                                  Cs_Upper( cObdobi) + StrZERO( nPorCisLis) )
        SetSCOPE( 'ListIT', cScope )
				BOX_WORK( 1)
				nRecCOUNT := dbCOUNT( 'ListIT')
				BOX_WORK()
				IF nRecCOUNT > 0
          BOX_THERMO( 1, nCount, nRecCount, '( Okam§ik pros¡m ... )',;
																 'Prob¡h  aktualizace mzdovìch l¡stk… ...',, 12 )
					ListIT->( dbGoTOP())
					DO WHILE !ListIT->( EOF())
						IF ListIT->nOsCisPrac > 0 .AND. ListIT->nKcNaOpeSK == 0
							IF ReplREC( 'ListIT')
								ListIT->nDruhMzdy := nDruhMzdy
								DCrUnlock( 'ListIT')
							ENDIF
						ENDIF

            BOX_THERMO( 0, nCount, nRecCount)
						( ListIT->( dbSKIP()), nCount++ )
	  			ENDDO
          BOX_THERMO( -1)
				ELSE
					BOX_ALERT( cEM, 'Nenalezen § dnì l¡stek k aktualizaci !', acWAIT,, 12 )
				ENDIF
        ClrSCOPE( 'ListIT')
		 ENDIF
	ENDIF
	ListIT->( OrdSetFOCUS( cTAG), dbGoTO( nRecNO) )
	RestSCREEN( ,,,, cSCR)
RETURN NIL

//ÄÄÄ<>ÄÄÄ
STATIC FUNCT ValidDrMzd( G)
	Local lOK, nDruhMzdy := G[ 1]:VarGET()

  IF( lOK := BrDrMzdy( nDruhMzdy, YES ) )
		@ 10, 37 SAY  Left( DruhyMzd->cNazevDmz, 30) COLOR 'bg*/N+'
		( G[ 1]:VarPUT( DruhyMzd->nDruhMzdy ), G[ 1]:Display() )
	ELSE
		@ 10, 37 SAY  SPACE( 30) COLOR 'GR*/N+'
	ENDIF
RETURN lOK

//ÄÄÄ<>ÄÄÄ  24.3.2003
// 27.1.2004: Funkce se p…vodnØ jmenovala OperIsKOO() a umoznovala vykazovat ML
// pouze v pripade, ze operace byla typu KOO (kooperace)
// Nyn¡ se rozhoduje na z klade hodnoty lVykazML

STATIC FUNCT ML_Vykazat()
	Local lOK := NO
	Local cTAG := Operace->( OrdSetFOCUS( 1))

	IF Operace->( dbSEEK( Cs_Upper( ListHD->cOznOper)) )
		lOK := Operace->lVykazML
	ENDIF
	Operace->( OrdSetFOCUS( cTAG))
RETURN lOK

