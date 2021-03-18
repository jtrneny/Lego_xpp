#include '..\..\Mzdy.Ch'
#include '..\..\MzdDEF_.Ch'


// definice pole pro n po‡et Druh–Mezd ze souboru SVP
#define  AN_SVP        { 0, 0, 0, 0, 0, .f., .f., .f., .f., .f., 0, 0, 0, 0, 0, 0, 0, 0 }
#define  SVP_DRMZ      1
#define  SVP_DNY       2
#define  SVP_HOD       3
#define  SVP_KCS       4
#define  SVP_PROC      5
#define  SVP_DIL1      6
#define  SVP_DIL2      7
#define  SVP_          8
#define  SVP_DIL3      9
#define  SVP_DIL4     10
#define  SVP_RZDNY    11
#define  SVP_RZHOD    12
#define  SVP_RZKCS    13
#define  SVP_MSDNY    14
#define  SVP_MSHOD    15
#define  SVP_MSKCS    16
#define  SVP_ZNAM     17
#define  SVP_HRMZ     18


// definice pro pole vìpoŸtu danØ dle Procent a Z kladn¡ danØ
#define  AN_PROC      { { 910, 0, 0, 510, 10, 0, 0, 0, 0, 0, 0, 0, 0 }, ;
                        { 911, 0, 0, 511, 15, 0, 0, 0, 0, 0, 0, 0, 0 }, ;
                        { 912, 0, 0, 512, 20, 0, 0, 0, 0, 0, 0, 0, 0 }, ;
                        { 913, 0, 0, 513, 25, 0, 0, 0, 0, 0, 0, 0, 0 }, ;
                        { 914, 0, 0, 514, 10, 0, 0, 0, 0, 0, 0, 0, 0 }, ;
                        { 915, 0, 0, 515, 15, 0, 0, 0, 0, 0, 0, 0, 0 }, ;
                        { 916, 0, 0, 516, 20, 0, 0, 0, 0, 0, 0, 0, 0 }, ;
                        { 917, 0, 0, 517, 25, 0, 0, 0, 0, 0, 0, 0, 0 }  }

#define  AN_DAN       { { 901, 0, 0,   0, 0, 0, 0, 0, 0 } , ;
                        { 902, 0, 0, 502, 0, 0, 0, 0, 0 } , ;
                        { 903, 0, 0, 501, 0, 0, 0, 0, 0 } , ;
                        { 904, 0, 0, 504, 0, 0, 0, 0, 0 } , ;
                        { 905, 0, 0, 505, 0, 0, 0, 0, 0 } , ;
                        { 908, 0, 0, 508, 0, 0, 0, 0, 0 } , ;
                        { 909, 0, 0, 509, 0, 0, 0, 0, 0 } , ;
                        { 919, 0, 0, 519, 0, 0, 0, 0, 0 } , ;
                        { 950, 0, 0,   0, 0, 0, 0, 0, 0 } }

#define  DAN_901       1
#define  DAN_902       2
#define  DAN_903       3
#define  DAN_904       4
#define  DAN_905       5
#define  DAN_908       6
#define  DAN_909       7
#define  DAN_919       8
#define  DAN_950       9

#define  _DRMZ         1
#define  _KCS          2
#define  _DAN          3
#define  _DRMZG        4
#define  _PROC         5
#define  _RZKCS        6
#define  _ZAKLSOC      7
#define  _ZAKLZDR      8
#define  _ODVSOC       9
#define  _ODVZDR      10
#define  _ODVZDRO     11
#define  _HRUBMZD     12
#define  _ODVSOCO     13

/*
#define  _HrubaMzda    1
#define  _ZaklSocPo    2
#define  _OdvoSocPC    3
#define  _OdvoSocPO    4
#define  _OdvoSocPZ    5
#define  _ZaklZdrPo    6
#define  _OdvoZdrPC    7
#define  _OdvoZdrPZ    8
#define  _OdvoZdrPZ    9
#define  _DanZaklMz   10
#define  _NezdCasZD   11
#define  _ZdanMzdaP   12
#define  _SrazkoDan   13
#define  _ZalohoDan   14
#define  _DanCelkem   15
#define  _CistPrije   16
#define  _CistPrije   17
#define  _NemocCelk   18
#define  _NemocCelk   19
#define  _DnyFondKD   20
#define  _DnyFondPD   21
#define  _DnyNemoKD   22
#define  _HodFondKD   23
#define  _HodFondPD   24
#define  _HodPresc    25
#define  _HodPripl    26
*/

static  anSumaSVP ,anDanPROC, anDanZAKL, anVolneDNY
static  nZaklOdbor
static  anHalVYR, nNemoc, nZdrDuch
static  nFiErr
static  nMesic, nRok, nZaokr, nMinMzda, nProcSoc, nProcZdr, nDMzdyVd, nDMzdySp
static  nVolneDny, nDMzNeplVd, nPrcSocCfg, nPrcZdrCfg, nHodnZdrSt, lGenVolDN
static  nSoubehPrijmu, nTiskSazVP
static  cMesic, cRok, cObdobi, nLastDay
static  nOrdItTmp
static  anFondPD
Static  nDnyPrcTyd, nDelPrcTyd
Static  cKeyObZer


STATIC  xKEYocpOBD, xKEYobdOCP
STATIC  xKEYocppOB, xKEYobOCPP
STATIC  cZEROobd, cZEROrok, cZEROmes

STATIC  aOdvSoc
STATIC  aOdvZdr
STATIC  nOdprHOD
STATIC  nProcZdrC
STATIC  nSUMAzakl
STATIC  nSUModvZdr
STATIC  lStudent
STATIC  aZakCelObd
STATIC  nMaxSocZak
STATIC  nMaxZdrZak
STATIC  aZakSocStO
STATIC  OdvSocStO
STATIC  nDnySvNem
STATIC  nSumMinMz


Function CmVypoc( pA, nTYPzprac)
  Local  lOk
  Local  aOutDEF1 := { { 'cLINE'  , 'C',  90, 0 }, ;
	                     { 'aIDENT' , 'M',  10, 0 }    }
  Local  aOutDEF2 := { { 'cLINE'  , 'C', 140, 0 }, ;
	                     { 'aIDENT' , 'M',  10, 0 }    }
  Local  cFileERR := fHomAdr() + '\Lst\CMZD5001.Lst'
  Local  cKey
  Local  cOldStred
	Local  nOldArea
	LOCAL  acOdvSocOrg := faOdvSocOR()
	LOCAL  acOdvSocZam := faOdvSocZA()
	LOCAL  xKEY
	LOCAL  nKeyCNT := 0, nKeyNO  := 0
	LOCAL  cOldTAG, nOldREC
	LOCAL  cC, nAKTrec
	LOCAL  nRECmat, lNEW
	LOCAL  lZPRACUJ := .T.
	LOCAL  cTAGsco, nRECsco, cSCOPE
	LOCAL  aZPRACpr := {}

  Set ( _SET_DELETED, .t. )

  anSumaSVP  := {}
  anDanPROC  := {}
  anDanZAKL  := {}
	anFondPD   := { 0, 0 }
  anVolneDNY := { 0, 0, 0, 0, 0, 0, 0}
  anHalVYR   := { { 998, 0 },{ 999, 0 } }
  nZaklOdbor := 0
  nNemoc     := 0
	nDnySvNem  := 0
  nZdrDuch   := 0
	nOrdItTMP  := 1
	aZakSocStO := { 0, 0 }  //z klad pro statutary
	aOdvSocStO := { 0, 0 }  //odvody pro statutary
	nSumMinMzd := 0

	cZEROobd  := ACT_OBDn()
	cZEROrok  := StrZero( ACT_OBDyn(), 4)
	cZEROmes  := StrZero( ACT_OBDon(), 2)

	cObdobi   := ACTObdobi()
  cMesic    := SubStr( cObdobi, 1, 2)       ;  nMesic := ACT_OBDon()
  cRok      := SubStr( cObdobi, 4, 2)       ;  nRok   := ACT_OBDyn()
  nLastDay  := LastDayOM( FirstODate( nRok, nMesic))

	cKeyObZer := StrZero( nRok, 4) + StrZero( nMesic, 2)
  nMinMzda  := SysConfig( "Mzdy:nMinMzdaNS")
  nDMzdyVd  := SysConfig( "Mzdy:nDMzdyVdNS")
  nDMzdySp  := SysConfig( "Mzdy:nDMzdyPsNS")
  nDMzNeplVd:= SysConfig( "Mzdy:nDMzdyNvNS")
  lGenVolDN := SysConfig( "Mzdy:lGenVolDny")
  nPrcSocCfg := SysConfig( "Mzdy:nProcSocNS")
  nPrcZdrCfg := SysConfig( "Mzdy:nProcZdrNS")
  nProcSoc   := nPrcSocCfg
  nProcZdr   := nPrcZdrCfg
  nProcZdrC  := SysConfig( "Mzdy:nOdvZdrZam") +SysConfig( "Mzdy:nOdvZdrOrg")
  nHodnZdrSt := SysConfig( "Mzdy:nHodnZdrSt")
  nTiskSazVP := SysConfig( "Mzdy:nTiskSazVP")
	nDnyPrcTyd := SysConfig( "Mzdy:nDnyPrcTyd")
	nDelPrcTyd := SysConfig( "Mzdy:nDelPrcTyd")
  nVolneDny  := f_VolDnyOD( nRok, nMesic, 1, nLastDay)    // +       ;
//									f_SvatkyOD( nRok, nMesic, 1, nLastDay)

  anVolneDNY[ 1] := nDmzdyVd
  anVolneDNY[ 3] := 200
  anVolneDNY[ 6] := 290

	aOdvSoc := { 0, 0}
	aEVAL( acOdvSocOrg, { |X| aOdvSoc[1] += X })
	aEVAL( acOdvSocZam, { |X| aOdvSoc[2] += X })

	aOdvZdr := { 0, 0}
	aOdvZdr[1] := SysConfig( "Mzdy:nOdvZdrOrg")
	aOdvZdr[2] := SysConfig( "Mzdy:nOdvZdrZam")

	nMaxSocZak := 1206576
	nMaxZdrZak := 1809864

	Dc_DCOPen( { 'DruhyMZD, 1', 'M_Nem, 1', 'M_Srz, 1', 'M_Dav, 1', 'Mzdy_Obd, 2';
	             ,'C_PolRVP, 1', 'MzKum_Ro, 1', 'C_Odpoc, 1', 'MsOdpPol, 1', 'C_TypDMZ, 1'  ;
							 ,'Mzdy_Srz, 1', 'Vypl, 1', 'MsPrc_Mo, 1', 'MsSrz_Mz, 1',      ;
							 ,'MsSrz_Mo, 1', 'MzdListH, 1', 'Mzdy, 1', "C_NemGen, 1", "PrSmlDoh, 1" })

  Set ( _SET_DELETED, .t. )

 	dbCreate( cFileERR, aOutDEF1)
  dbUseArea( .t., "SIXCDX", ( cFileERR ), "FiERR", if( .T. .or. .F., .F., NIL ), .f. )
  fprintErrIn()

// aœ taky u§ivatel vid¡ co se dØje

//	nOldArea := TmpDav ->( dbSetOrder( 2))

  anDanPROC := aclone( AN_PROC)
  anDanZAKL := aclone( AN_DAN )

	c_PolRvp ->( OrdSetFOCUS( 3))
  MsPrc_Mz ->( OrdSetFOCUS( 4))
  MsPrc_Mo ->( OrdSetFOCUS( 1))
  MzKum_Ro ->( OrdSetFOCUS( 1))
	C_Odpoc ->( OrdSetFOCUS( 4))

	MsOdpPol ->( dbSetRelation( 'C_Odpoc'  , ;
                     { || cZEROrok +Cs_Upper( MsOdpPol ->cTypOdpPol) } , ;
                         'cZEROrok +Cs_Upper(  MsOdpPol ->cTypOdpPol)' ) )
  MsOdpPol ->( dbSkip( 0))

	DruhyMZD ->( dbSetRelation( 'C_TypDMZ'  , ;
                     { || Cs_Upper( DruhyMZD ->cTypDMZ) },  ;
                         'Cs_Upper( DruhyMZD ->cTypDMZ)'))
  DruhyMZD ->( dbSkip( 0))

//	Mzdy ->( dbSetRelation( 'DruhyMZD', { || Mzdy ->nDruhMzdy) }, 'Mzdy ->nDruhMzdy'))
//  Mzdy ->( dbSkip( 0))

  cOldStred := MsPrc_Mz ->cKmenStrPr
 	nKeyCNT   := MsPrc_Mz ->( SX_KeyCount())

	nOldREC := MsPrc_Mz ->( Recno())
	DO CASE
	CASE nTYPzprac == 1 .OR. nTYPzprac == 2
		lZPRACUJ := !TESTcmObd()

	CASE nTYPzprac == 3 .OR. nTYPzprac == 4                             //
		MsPrc_Mz ->( dbGoTop())
    cC := "Proch z¡m matriŸn¡ soubor prac. ..."
    BOX_MOVEIN( cC, 5, pA[ 3].Row, pA[ 3].Col, 'GR+/W', pA[ 3].Picture )

	ENDCASE

	DO WHILE !MsPrc_Mz ->( Eof()) .AND. lZPRACUJ
		IF aSCAN( aZPRACpr, MsPrc_Mz ->nOsCisPrac) == 0
		  nRECmat := MsPrc_Mz ->( Recno())
		  IF( nTYPzprac = 3 .OR. nTYPzprac = 4                                  ;
				   , TempZpr( nKeyCNT, nKeyNO++, pA), NIL)

      cTAGsco := MsPrc_Mz ->( OrdSetFOCUS())
      nRECsco := MsPrc_Mz ->( Recno())
      cSCOPE  := MsPrc_Mz ->( Sx_SetScope())

      MsPrc_Mz ->( Set_sSCOPE( 6, StrZero( MsPrc_Mz ->nOsCisPrac, 5)))
	     DO WHILE !MsPrc_Mz ->( Eof())
				 lStudent := MsPrc_Mz ->nTypZamVzt == 11 .OR. MsPrc_Mz ->lStudent
         ReplRec( "MsPrc_Mz")
		     EvidPocPrac( "MsPrc_Mz")          // pýepoŸet evidenŸn¡ho poŸtu
 		     DcrUnlock( "MsPrc_Mz")
				 aZakCelObd := IF( nMesic > 1, ZakCelObd(), {0,0,0})
		     VYPOCETcm( pA, nTypZPRAC)
	       MsPrc_Mz ->( dbSkip())
		   ENDDO
	    MsPrc_Mz ->( Clr_SCOPE())

      MsPrc_Mz ->( OrdSetFOCUS( 4))
		  MsPrc_Mz ->( dbGoTo( nRECmat))

		  SOUBEhPrVZ( pA)

			AAdd( aZPRACpr, MsPrc_Mz ->nOsCisPrac)

		ENDIF

		IF nTYPzprac == 1 .OR. nTYPzprac == 2 .OR. nTYPzprac == 9
		  lZPRACUJ := .F.
	  ELSE
		  MsPrc_Mz ->( dbSkip())
		ENDIF
	ENDDO

	IF( nTYPzprac = 3 .OR. nTYPzprac = 4, TempZpr(,, pA), NIL)

	MsPrc_Mz ->( dbGoTo( nOldREC))
	C_Odpoc ->( dbClearRelations())
  C_TypDMZ ->( dbClearRelations())
//	MsOdpp ->( dbClearRelations())
	FiERR ->( dbCloseArea())
	//TmpDav ->( dbSetOrder( nOldArea ))

RETURN( NIL)


STATIC FUNCTION VYPOCETcm( pA, nTYPzprac, lSOUBEH)
	LOCAL  nRECmat
	LOCAL  cC, cSCOPE, nAKTrec
	LOCAL  lNEW

	DEFAULT lSOUBEH TO .F.

	xKEYocpOBD := StrZero( MsPrc_Mz ->nOsCisPrac)              ;
	               +StrZero( nRok, 4) +StrZero( nMesic, 2)
	xKEYocppOB := StrZero( MsPrc_Mz ->nOsCisPrac)              ;
								 +StrZero( MsPrc_Mz ->nPorPraVzt)            ;
	                +StrZero( nRok, 4) +StrZero( nMesic, 2)

	xKEYobdOCP := StrZero( nRok, 4) +StrZero( nMesic, 2)       ;
									 +StrZero( MsPrc_Mz ->nOsCisPrac)
	xKEYobOCPP := StrZero( nRok, 4) +StrZero( nMesic, 2)       ;
								 +StrZero( MsPrc_Mz ->nOsCisPrac)            ;
									+StrZero( MsPrc_Mz ->nPorPraVzt)


// pýepoŸet soubor MZDY  z hrubìch mezd, sr §ek a nemocenek
	IF nTYPzprac == 1 .OR. nTYPzprac == 3
		WRT_MDavMz( xKEYobOCPP)

			M_Srz ->( SET_sSCOPE( 1, xKEYobOCPP))
			 DO WHILE !M_Srz ->( Eof())
				 cSCOPE  := M_Srz ->( Sx_SetScope())
				 nAKTrec := M_Srz ->( Recno())
			 	 WRT_DOKLMz( "M_Srz",, 4, xKEYobOCPP +Cs_Upper( M_Srz ->cDenik), M_Srz ->nDoklad)
				 IF( !IsNil( cSCOPE), M_Srz ->( SET_sSCOPE( 1, cSCOPE)), NIL)
				 M_Srz ->( dbGoTo( nAKTrec))
				 M_Srz ->( dbSkip())
			 ENDDO
			M_Srz ->( CLR_SCOPE())

			M_Nem ->( SET_sSCOPE( 1, xKEYobOCPP))
			 DO WHILE !M_Nem ->( Eof())
				 cSCOPE  := M_Nem ->( Sx_SetScope())
				 nAKTrec := M_Nem ->( Recno())
			   OnLineWRT( .F.)
				 IF( !IsNil( cSCOPE), M_Nem ->( SET_sSCOPE( 1, cSCOPE)), NIL)
				 M_Nem ->( dbGoTo( nAKTrec))

				 nDnySvNem += D_DnyOdDo( M_Nem ->dVykazN_OD, M_Nem ->dVykazN_DO, "SVAT")

				 M_Nem ->( dbSkip())
			 ENDDO
			M_Nem ->( CLR_SCOPE())
		ENDIF

		IF nTYPzprac == 1 .OR. nTYPzprac == 2 .OR. nTYPzprac == 9
      fDEL_ZprREC()        // zruç¡ pýedch zej¡c¡ zpracov n¡
			RemINFS ( nMesic, nRok, .T.)
		ENDIF

    MODImsp_Mo()         // modifikace MsPrc_Mo
    MODIkum_Ro( "IN")    // vytvoýen¡ pomocn‚ho MzKumRoP

		IF fPocCM()
			nOrdItTMP  := 1
			nOdprHOD   := 0
	    lNEW := !Mzdy_Obd ->( dbSeek( xKEYocppOB))
	    IF( !lNEW, ( ReplREC( "Mzdy_Obd"), W_EMPTYrec( "Mzdy_Obd")), NIL)
      MH_CopyFLD( 'MsPrc_Mo', 'Mzdy_Obd', lNEW)
			Mzdy_Obd ->cUloha     := "M"
			Mzdy_Obd ->cDenik     := "M"
		  Mzdy_Obd ->nFondPDHo  := fPracDOBA( MsPrc_Mo ->cDelkPrDob)[3]               ;
			                          *F_PracDny( MsPrc_Mo ->nRok, MsPrc_Mo ->nObdobi)
			Mzdy_Obd ->nFondPDSHo := fPracDOBA( MsPrc_Mo ->cDelkPrDob)[3]               ;
			                          *( F_PracDny( MsPrc_Mo ->nRok, MsPrc_Mo ->nObdobi) ;
			 													   +F_Svatky( MsPrc_Mo ->nRok, MsPrc_Mo ->nObdobi))

			Mzdy ->( SET_sSCOPE( 12, xKEYobOCPP))
       IF Mzdy ->( SX_KeyCount()) > 0
				 IF nTYPzprac == 3 .OR. nTYPzprac == 4
		       cC :=  Str( MsPrc_Mz ->nOsCisPrac, 5) +" - "                     ;
									 +Left( MsPrc_Mz ->cPracovnik, 15) + " "                  ;
					          +Str( MsPrc_Mz ->nPorPraVzt, 2) +" - "                  ;
										  +MsPrc_Mz ->cDruPraVzt
  	       BOX_MOVEIN( cC, 5, pA[ 3].Row, pA[ 3].Col, 'GR+/W', pA[ 3].Picture )
				 ENDIF

			   ReplRec( "MsPrc_Mz")

			   DO WHILE !Mzdy ->( Eof())
           fNapSvp()

					 nOdprHOD += IF( Mzdy ->nDruhMzdy >= 110 .AND.                  ;
					                  Mzdy ->nDruhMzdy <= 129, Mzdy ->nHodFondPD, 0)

					 fNapMzdOBD()

					 Mzdy ->( dbSkip())
			   ENDDO

		     Mzdy ->( CLR_SCOPE())
         fvypVypl( lSOUBEH)
			 ELSE
		     Mzdy ->( CLR_SCOPE())
			 ENDIF
		ELSE
		  IF( Mzdy_Obd ->( dbSeek( xKEYocppOB)), DelREC( "Mzdy_Obd"), NIL)

		ENDIF

    MODIkum_Ro( "OUT")    // pýeklopen¡ pomocn‚ho MzKumRoP

		IF MsPrc_Mz ->( Sx_RLock())
		  MsPrc_Mz ->nTMoZPRcmz := Val( Left( xKEYobdOCP, 6))
		ENDIF

		DelNapFiOC( "MzdListH")

 		DcrUnlock( "MsPrc_Mz")
 		DcrUnlock( "MsPrc_Mo")
 		DcrUnlock( "Vypl")


RETURN( NIL)


// test zda poŸ¡tat Ÿistou mzdu pro pracovn¡ka

STATIC FUNCTION fPocCM()
	LOCAL  lOK
	LOCAL  nVYSTtm, nOBDtm

	nVYSTtm := ( Year( MsPrc_Mz ->dDatVyst)*100) +Month( MsPrc_Mz ->dDatVyst)
	nOBDtm  := ( nRok *100) +nMesic

	lOK := MsPrc_Mz ->lVypCisMZD                                                ;
					.AND.( M_Nem ->( dbSeek( cZEROobd +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt)))  ;
					 .OR. M_Srz ->( dbSeek( cZEROobd +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt))) ;
					  .OR. M_Dav ->( dbSeek( cZEROobd +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt))))

//	            .AND. (( nVYSTtm >= nOBDtm .OR. Empty( MsPrc_Mz ->dDatVyst))     ;


RETURN( lOK)


// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄN po‡et ze TmpDav do anSumaSVPÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ //
static function fnapSvp()
  Local  n, cMsDny, cMsHod, cMsKcs, cVpDny, cVpHod, cVpKcs

  if ( n := ascan( anSumaSVP, { |x| x[ SVP_DRMZ] == Mzdy ->nDruhMzdy })) == 0
    if !DruhyMZD ->( dbSeek( Mzdy ->nDruhMzdy))
      fprintErrIn( 2)
    else
      aadd( anSumaSVP, AN_SVP)
      n := len( anSumaSVP)
      cMsDny := 'm' +strZero( DruhyMZD ->Rz_Dny )
      cMsHod := 'm' +strZero( DruhyMZD ->Rz_Hod )
      cMsKcs := 'm' +strZero( DruhyMZD ->Rz_Kcs )
      anSumaSVP[ n, SVP_DRMZ  ] := Mzdy ->nDruhMzdy
      DO CASE
      CASE DruhyMZD ->nTypDane == 20
        anSumaSVP[ n, SVP_PROC  ] := 1
      CASE DruhyMZD ->nTypDane == 21
        anSumaSVP[ n, SVP_PROC  ] := 2
      CASE DruhyMZD ->nTypDane == 22
        anSumaSVP[ n, SVP_PROC  ] := 3
      CASE DruhyMZD ->nTypDane == 23
        anSumaSVP[ n, SVP_PROC  ] := 4
      CASE DruhyMZD ->nTypDane == 10
        anSumaSVP[ n, SVP_PROC  ] := 5
      CASE DruhyMZD ->nTypDane == 11
        anSumaSVP[ n, SVP_PROC  ] := 6
      CASE DruhyMZD ->nTypDane == 12
        anSumaSVP[ n, SVP_PROC  ] := 7
      CASE DruhyMZD ->nTypDane == 13
        anSumaSVP[ n, SVP_PROC  ] := 8
			OTHERWISE
        anSumaSVP[ n, SVP_PROC  ] := 0
      ENDCASE

      anSumaSVP[ n, SVP_DIL1  ] := DruhyMZD ->nTypDane == 1

      anSumaSVP[ n, SVP_DIL3  ] := DruhyMZD ->lSocPojis .and. MsPrc_Mz ->lSocPojis
      anSumaSVP[ n, SVP_DIL4  ] := DruhyMZD ->lZdrPojis .and. MsPrc_Mz ->nZdrPojis > 0
      anSumaSVP[ n, SVP_RZDNY ] := MzKumRoP ->( fieldPos( cMsDny))
      anSumaSVP[ n, SVP_RZHOD ] := MzKumRoP ->( fieldPos( cMsHod))
      anSumaSVP[ n, SVP_RZKCS ] := MzKumRoP ->( fieldPos( cMsKcs))
      anSumaSVP[ n, SVP_MSDNY ] := MzKumRoP ->( fieldGet( anSumaSVP[ n, SVP_RZDNY]))
      anSumaSVP[ n, SVP_MSHOD ] := MzKumRoP ->( fieldGet( anSumaSVP[ n, SVP_RZHOD]))
      anSumaSVP[ n, SVP_MSKCS ] := MzKumRoP ->( fieldGet( anSumaSVP[ n, SVP_RZKCS]))

      fnapDhk( n)
    endif
  else
    if !DruhyMZD ->( dbSeek( Mzdy ->nDruhMzdy))
      fprintErrIn( 2)
    else

      fnapDhk( n)
		ENDIF
  endif
return ( nil)


// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄNapo‡te <D>ny, <H>odiny, <K>‡s
static function fnapDhk( nVal)
  Local  nDMzdy   := Mzdy ->nDruhMzdy, nA
  Local  lSocZdr  := DruhyMZD ->lSocPojis .OR. DruhyMZD ->lZdrPojis
  Local	 nTypPROC := anSumaSVP[ nVal, SVP_PROC]
  Local  n := if( DruhyMZD ->nNapocetCM == 1, 1 , ;
                  if( DruhyMZD ->nNapocetCM == 2, -1, 0 ))
	Local  nZnam := IF( DruhyMZD ->nNapocetCM == 2, -1, 1)
	LOCAL  nX, nPOS

  anSumaSVP[ nVal, SVP_DNY ] += Mzdy ->nDnyDoklad
  anSumaSVP[ nVal, SVP_HOD ] += Mzdy ->nHodDoklad
  anSumaSVP[ nVal, SVP_KCS ] += Mzdy ->nMzda
  anSumaSVP[ nVal, SVP_ZNAM] := nZnam
  anSumaSVP[ nVal, SVP_HRMZ] += IF( DruhyMZD ->lHrubaMzda, Mzdy ->nMzda, 0)
  anDanZAKL[ DAN_950, _KCS ] += n *Mzdy ->nMzda

  nZaklOdbor += IF( DruhyMZD ->lOdbory, n *Mzdy ->nMzda, 0)
  nNemoc     += IF( nDMzdy >= 400 .and. nDMzdy < 440, n *Mzdy ->nMzda, 0)

	IF( Mzdy ->cDENIK == "MS", Mzdy_Srz(,.T.), NIL)

	ReplREC( "Mzdy")

	Mzdy ->nTypPraVzt := MsPrc_Mz ->nTypPraVzt
	Mzdy ->nTypZamVzt := MsPrc_Mz ->nTypZamVzt
	Mzdy ->nClenSpol  := IF( MsPrc_Mz ->nTypZamVzt == 2                      ;
	                          .OR. MsPrc_Mz ->nTypZamVzt == 3                ;
			                       .OR. MsPrc_Mz ->nTypZamVzt == 4, 1, 0)
	Mzdy ->nTypDuchod := MsPrc_Mz ->nTypDuchod
  Mzdy ->cPracZar   := MsPrc_Mz ->cPracZar
	Mzdy ->nMimoPrVzt := MsPrc_Mz ->nMimoPrVzt
	Mzdy ->nZdrPojis  := MsPrc_Mz ->nZdrPojis

	Mzdy ->cPolVyplPa := DruhyMZD ->cPolVyplPa
	Mzdy ->cVyplMist  := MsPrc_Mz ->cVyplMist

	anFondPD[1] += Mzdy ->nDnyFondPD
	anFondPD[2] += Mzdy ->nHodFondPD - Mzdy ->nHodPresc

  anVolneDNY[ 2] += IF( anVolneDNY[ 1] == Mzdy ->nDruhMzdy, Mzdy ->nDnyFondKD, 0)
  anVolneDNY[ 5] += IF( anVolneDNY[ 1] == Mzdy ->nDruhMzdy, Mzdy ->nDnyFondKD, 0)

  anVolneDNY[ 4] += IF( Mzdy ->nDruhMzdy >= 200 .AND. Mzdy ->nDruhMzdy <= 205, Mzdy ->nDnyFondKD, 0)
  anVolneDNY[ 5] += IF( Mzdy ->nDruhMzdy >= 200 .AND. Mzdy ->nDruhMzdy <= 205, Mzdy ->nDnyFondKD, 0)

  anVolneDNY[ 7] += IF( anVolneDNY[ 6] == Mzdy ->nDruhMzdy, Mzdy ->nDnyFondKD, 0)
  anVolneDNY[ 5] += IF( anVolneDNY[ 6] == Mzdy ->nDruhMzdy, Mzdy ->nDnyFondKD, 0)

// napocet zakladu soc. a zdr. pojisteni vcetne speciality pro za–‡tov n¡
// je¨tˆ jeden test¡k pro z klad Soci ln¡ho k da¤ov‚mu Z kladu
  IF Mzdy ->nZaklSocPo <> 0
    DO CASE
    CASE DruhyMZD ->nTypDane == 1
      anDanZAKL[ DAN_901, _ZAKLSOC]  += Mzdy ->nZaklSocPo
			if DruhyMZD ->lZakSocStO
  			aZakSocStO[1]                += Mzdy ->nZaklSocPo
			endif

    CASE DruhyMZD ->nTypDane >= 10
      anDanPROC[ nTypPROC, _ZAKLSOC] += Mzdy ->nZaklSocPo
			if DruhyMZD ->lZakSocStO
  			aZakSocStO[1]                += Mzdy ->nZaklSocPo
			endif
    ENDCASE
  ENDIF

  IF Mzdy ->nZaklZdrPo <> 0
    DO CASE
    CASE DruhyMZD ->nTypDane == 1
      anDanZAKL[ DAN_901, _ZAKLZDR]  += Mzdy ->nZaklZdrPo
    CASE DruhyMZD ->nTypDane >= 10 .AND. DruhyMZD ->nTypDane <= 23
      anDanPROC[ nTypPROC, _ZAKLZDR] += Mzdy ->nZaklZdrPo
    ENDCASE
	ENDIF

  Mzdy_Obd ->nHrubaMzda += IF( DruhyMZD ->lHrubaMzda, Mzdy ->nMzda, 0)

	DcrUnlock( "Mzdy")

RETURN( NIL)


// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄV˜po‡et danˆ, k v˜platˆ ...ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ //
static function fvypVypl( lSOUBEH)
  Local  c
  Local  nA, nB, n, nTMPproc
  Local  an
  Local  nPosInPROC, nOdvSoc, nOdvZdr, nOdvZdrNV := 0
  Local  lOk, lZustUcet := .F., nPorUcet, cPorZust
  Local  nRoundVypl, nHalerVyr, nZbytekDoDes, nValInMs, nPosInMs
  Local  nOdvSocO  := 0, nOdvZdrO  := 0
  Local  nSocDoklO := 0, nZdrDoklO := 0
  Local  nSocDokl := 0, nZdrDokl := 0, nDanDokl := 0
  Local  nOdprDny  := 0, nOdprDnyN := 0, nInd, nOdpDopr := 0
  Local  nNeplVd := 0, nDnyAbs := 0
  Local  nZaklVypl := 0, nPracDob := 0, nZdrNeplDn := 0
  Local  nZakl_901, nZakl_902, nSoc400 := 0, nZdr400 := 0
  Local  lNeSoc := .F., lNeZdr := .F.
  Local  nZaklZdr, nCelkem, nCelkZak, cNewKeyCp, nSpor, cAlia, cRzAli, nRzMs
	LOCAL  nPROCodv
	LOCAL  nXSum, nXSum2
	LOCAL  nVolDnyCP := nVolneDny
	LOCAL  xKEY, cTAGold, nRECold, nDNYprdob
	LOCAL  nTModvZDR, nZaDOPLzdr, nOdDOPLzdr, nTMPzakl
	LOCAL  nTMPdny, nZaokrHM
	LOCAL  nDanovaUl, nDanovyBo, lDanBoOK, nTMPfondHo, nTMPminMzd, nTmpNum
	LOCAL  dDATtmp, nTMPvek, aTMPfond
	LOCAL  aDanUleva, nDanUlDeti, nTmpUl, lSrDanNe, lProcDan


	DEFAULT lSOUBEH TO .F.

	nSUModvZdr := 0
	nZaokrHM   := 0
	nDanovaUl  := 0
	nDanovyBo  := 0
	aDanUleva  := {}

	IF Month( MsPrc_Mz ->dDatVyst) == nMesic
		nVolDnyCP := f_VolDnyOD( nRok, nMesic, 1, Day( MsPrc_Mz ->dDatVyst))
	ELSE
	  nVolDnyCP := nVolneDny
	ENDIF

// zalo‘¡me pracovn¡ka do < Vypl > a d l se uk ‘e
//  Vypl ->( dbAppend())
	W_DelRepl( "Vypl")

  Vypl ->nStred    := Val( IF( Len( AllTrim( MsPrc_Mz ->cKmenStrPr)) > 4, SubStr( MsPrc_Mz ->cKmenStrPr, 3,4), MsPrc_Mz ->cKmenStrPr))
  Vypl ->nStredVyp := IF( Val( MsPrc_Mz ->cVyplMist) > 9999, 0, Val( MsPrc_Mz ->cVyplMist))
//  Vypl ->nStred    := Val( IF( Len( AllTrim( MsPrc_Mz ->cKmenStrPr)) > 3, SubStr( MsPrc_Mz ->cKmenStrPr, 3,3), MsPrc_Mz ->cKmenStrPr))
//  Vypl ->nStredVyp := IF( Val( MsPrc_Mz ->cVyplMist) > 999, 0, Val( MsPrc_Mz ->cVyplMist))
  Vypl ->nCPrac    := MsPrc_Mz ->nOsCisPrac
  Vypl ->cJmeno    := MsPrc_Mz ->cPracovnik
  Vypl ->nMesic    := nMesic
  Vypl ->nRok      := nRok
  Vypl ->cPracovnik:= cPRACsort( "MsPrc_Mz")
  Vypl ->nProf     := IF( Val( MsPrc_Mz ->cPracZar) > 999, 0, Val( MsPrc_Mz ->cPracZar))
  Vypl ->nHodPrNahr:= MsPrc_Mz ->nHodPrumPP
  Vypl ->nDenPrNahr:= MsPrc_Mz ->nDenPrumPP
  Vypl ->n50NemPr  := MsPrc_Mz ->nDenVZCiKN
  Vypl ->n69NemPr  := MsPrc_Mz ->nDenVZCisN
  Vypl ->nSazbaHod := fSazTAR()[1]
  Vypl ->nSazbaMes := fSazTAR()[2]
	Vypl ->cObdobi   := cObdobi
  Vypl ->nObdobi   := nMesic
  Vypl ->nOsCisPrac:= MsPrc_Mz ->nOsCisPrac
  Vypl ->nPorPraVzt:= MsPrc_Mz ->nPorPraVzt
  Vypl ->cPracZar  := MsPrc_Mz ->cPracZar
  Vypl ->nSazDenNiN:= MsPrc_Mz ->nSazDenNiN
  Vypl ->nSazDenVKN:= MsPrc_Mz ->nSazDenVKN
  Vypl ->nSazDenVyN:= MsPrc_Mz ->nSazDenVyN
	Vypl ->cTmKmStrPr:= TMPkmenSTR( MsPrc_Mz ->cKmenStrPr)
  Vypl ->nZavod    := IF( Val( Left( Vypl ->cTmKmStrPr, 2)) < 100          ;
	                          , Val( Left( Vypl ->cTmKmStrPr, 2)), 0)


  for nA = 1 to len( anSumaSVP)
// odpracovan‚ dny
    if DruhyMZD ->( dbSeek( anSumaSVP[ nA, SVP_DRMZ]))
      nInd     := DruhyMZD ->nNapocHM
      nOdprDny  += if( nInd == 0 .or. ;
                      nInd == 3 .or. nInd == 6, anSumaSVP[ nA, SVP_DNY], 0 )
			nOdprDnyN += If( nInd == 7, anSumaSVP[ nA, SVP_DNY], 0 )
    endif
    Do Case
    Case  anSumaSVP[ nA, SVP_DRMZ] = nDMzNeplVd
      nNeplVd += anSumaSVP[ nA, SVP_DNY]

    Case  anSumaSVP[ nA, SVP_DRMZ] = 195
      nDnyAbs += anSumaSVP[ nA, SVP_DNY]

    EndCase

// v˜po‡et z klad– pro procentu ln¡ danˆ
    nPosInPROC := anSumaSVP[ nA, SVP_PROC]
    if nPosInPROC > 0
      anDanPROC[ nPosInPROC, _KCS]     += anSumaSVP[ nA, SVP_KCS]
      anDanPROC[ nPosInPROC, _HRUBMZD] += anSumaSVP[ nA, SVP_HRMZ]
    endif

// v˜po‡et z klad– pro mˆs¡‡n¡ a ro‡n¡ danˆ
    for nB = 1 to 2
      if anSumaSVP[ nA, SVP_PROC +nB] .and. anSumaSVP[ nA, SVP_PROC] = 0
        anDanZAKL[ nB, _KCS] += anSumaSVP[ nA, SVP_KCS]
        anDanZAKL[ nB,    9] += anSumaSVP[ nA, SVP_HRMZ]
      endif
    next
  next

  IF nVolDnyCp > Mzdy_Obd ->nDnyVoSoNe
//     IF anVolneDNY[ 5] < nVolDnyCp
    IF lGenVolDN .and. MsPrc_Mz ->nTypPraVzt < 5
      nTMPdny := nVolDnyCp - ( Mzdy_Obd ->nDnyVoSoNe + Mzdy_Obd ->nDnyVNSoNe)
			IF( nTMPdny > 0, FGenDmz( anVolneDNY[ 1 ], nTMPdny, 0, 0 ), NIL)
//      FGenDmz( anVolneDNY[ 1 ], nVolDnyCp - anVolneDNY[ 5], 0, 0 )
      fNapMzdOBD()
    ELSE
      fprintErrIn( 3)
    ENDIF
  ENDIF

//  vygenerov n¡ dn… do fondu
//   nOdprHOD :=  Mzdy_Obd ->nHodFondPD - Mzdy_Obd ->nHodPresc
  IF SysConfig("Mzdy:lGenOdpDny")
//		 nDNYprdob := Round( nOdprHOD / fPracDOBA()[3], 0)
    nDNYprdob := Mzdy_Obd ->nFondPDsDn - Mzdy_Obd ->nDnyFondPD
    IF nDNYprdob > 0
      FGenDmz( 109, nDNYprdob, 0, 0 )
      fNapMzdOBD()
    ENDIF
  ENDIF


// pokud ma neplacene volno nebo absenci tak prumerem pro zdravotni
  If ( nNeplVd > 0 .or. nDnyAbs > 0 ) .and. MsPrc_Mz ->nTypDuchod = 0       ;
		                                    .and. !lStudent    //  MsPrc_Mz ->nTypZamVzt <> 11
    nNeplVd += nDnyAbs

		If ( nNeplVd + anVolneDny[ 7 ] ) = nLastDay
			nZdrNeplDn := nMinMzda
		Else
			nZdrNeplDn := ( nMinMzda/nLastDay) * ( nNeplVd + anVolneDny[ 7])
		Endif
  EndIf

// zapamatujem si nezaokrouhlene zaklady bude se to jednou hodit
  nZakl_901 := anDanZAKL[ DAN_901, _KCS]
  nZakl_902 := anDanZAKL[ DAN_902, _KCS]

// zaokrouhleni
  anDanZAKL[ DAN_901, _KCS]     := Round( anDanZAKL[ DAN_901, _KCS]     +0.49, 0)
  anDanZAKL[ DAN_901,    9]     := Round( anDanZAKL[ DAN_901,    9]     +0.49, 0)
  anDanZAKL[ DAN_901, _ZAKLSOC] := Round( anDanZAKL[ DAN_901, _ZAKLSOC] +0.49, 0)
  anDanZAKL[ DAN_901, _ZAKLZDR] := Round( anDanZAKL[ DAN_901, _ZAKLZDR] +0.49, 0)
	nZaokrHM                      += anDanZAKL[ DAN_901,    9]

  anDanZAKL[ DAN_902, _KCS]     := Round( anDanZAKL[ DAN_902, _KCS]     +0.49, 0)
  anDanZAKL[ DAN_902,    9]     := Round( anDanZAKL[ DAN_902,    9]     +0.49, 0)
  anDanZAKL[ DAN_902, _ZAKLSOC] := Round( anDanZAKL[ DAN_902, _ZAKLSOC] +0.49, 0)
  anDanZAKL[ DAN_902, _ZAKLZDR] := Round( anDanZAKL[ DAN_902, _ZAKLZDR] +0.49, 0)
	nZaokrHM                      += anDanZAKL[ DAN_902,    9]

	nxSum  := aZakCelObd[1]
	nxSum2 := nxSum

	Do Case
	Case MsPrc_Mz->lZamMalRoz
//		lNeSoc := nxSum < 2000
		lNeSoc := anDanZAKL[ DAN_901, _ZAKLSOC] +anDanZAKL[ DAN_902, _ZAKLSOC] < 2000
	Case MsPrc_Mz->lZamKratko
		lNeSoc := Mzdy_Obd ->nDnyFondKd < 15
	EndCase

// zaklady soc. a zdravotniho pro vypocet
	if nxSum > nMaxSocZak .or. lNeSoc
		anDanZAKL[ DAN_901, _ZAKLSOC] := 0
		anDanZAKL[ DAN_902, _ZAKLSOC] := 0
	else
		nxSum += anDanZAKL[ DAN_901, _ZAKLSOC]
		if nxSum > nMaxSocZak
			anDanZAKL[ DAN_901, _ZAKLSOC] := nMaxSocZak - nxSum2
		else
			nxSum += anDanZAKL[ DAN_902, _ZAKLSOC]
		  if nxSum > nMaxSocZak
				anDanZAKL[ DAN_902, _ZAKLSOC] := nMaxSocZak - nxSum2
			endif
		endif
	endif


	nxSum  := aZakCelObd[2]
	nxSum2 := nxSum

	Do Case
	Case MsPrc_Mz->lZamMalRoz
		If MsPrc_Mz->nTypPraVzt = 6
//  		lNeZdr := nxSum < 2000
			lNeZdr := anDanZAKL[ DAN_901, _ZAKLZDR] +anDanZAKL[ DAN_902, _ZAKLZDR] < 2000
		EndIf
	Case MsPrc_Mz->lZamKratko
		If MsPrc_Mz->nTypPraVzt = 6
  		lNeZdr := nxSum < 2000
		EndIf
	EndCase

// zaklady soc. a zdravotniho pro vypocet
	if nxSum > nMaxZdrZak .or. lNeZdr
		anDanZAKL[ DAN_901, _ZAKLZDR] := 0
		anDanZAKL[ DAN_902, _ZAKLZDR] := 0
	else
		nxSum += anDanZAKL[ DAN_901, _ZAKLZDR]
		if nxSum > nMaxZdrZak
			anDanZAKL[ DAN_901, _ZAKLZDR] := nMaxZdrZak - nxSum2
		else
			nxSum += anDanZAKL[ DAN_902, _ZAKLZDR]
		  if nxSum > nMaxZdrZak
				anDanZAKL[ DAN_902, _ZAKLZDR] := nMaxZdrZak - nxSum2
			endif
		endif
  endif

	nxSum  := aZakCelObd[3]
	nxSum2 := nxSum

// zaklady soc. a zdravotniho pro vypocet
	if nxSum > nMaxSocZak .or. lNeSoc
		aZakSocStO[1] := 0
	else
		nxSum += aZakSocStO[1]
		if nxSum > nMaxSocZak
			aZakSocStO[1] := nMaxSocZak - nxSum2
		else
			nxSum += aZakSocStO[1]
		  if nxSum > nMaxSocZak
				aZakSocStO[1] := nMaxSocZak - nxSum2
			endif
		endif
	endif

  anDanZAKL[ DAN_904, _KCS] := anDanZAKL[ DAN_901, _ZAKLSOC]
  anDanZAKL[ DAN_905, _KCS] := anDanZAKL[ DAN_901, _ZAKLZDR]
  anDanZAKL[ DAN_908, _KCS] := anDanZAKL[ DAN_902, _ZAKLSOC]
  anDanZAKL[ DAN_909, _KCS] := anDanZAKL[ DAN_902, _ZAKLZDR]

// Moznost daneni jednorazovymi sazbami
  nZaklVypl += anDanZakl[ DAN_901, _KCS]
  nZaklVypl += anDanZakl[ DAN_902, _KCS]

	DO CASE
  CASE nRok >= 2004
	  nTMPproc := 5000
	ENDCASE

  Do Case
  Case MsPrc_Mz ->nOdpocObd == 0 .and. !MsPrc_Mz ->lDanProhl
		lProcDan := .F.
		lSrDanNe := .F.
		lSrDanNe := ( MsPrc_Mz->nTypZamVZT = 2 .or.                   ;
		               MsPrc_Mz->nTypZamVZT = 3 .or.                  ;
		                MsPrc_Mz->nTypZamVZT = 4 .or.                  ;
		                 MsPrc_Mz->nTypZamVZT = 5) .and.                  ;
								  MsPrc_Mz->cDruPraVZT <> "HLAV"

    If nZaklVypl <= nTMPproc .and. !lSrDanNe
      anDanProc[ 2, _ZAKLSOC] += anDanZAKL[ DAN_904, _KCS]
      anDanProc[ 2, _ZAKLZDR] += anDanZAKL[ DAN_905, _KCS]
      anDanProc[ 2, _ZAKLSOC] += anDanZAKL[ DAN_908, _KCS]
      anDanProc[ 2, _ZAKLZDR] += anDanZAKL[ DAN_909, _KCS]
      anDanProc[ 2, _HRUBMZD] += anDanZAKL[ DAN_901,    9]
      anDanProc[ 2, _KCS    ] += nZaklVypl
			lProcDan := .T.
    EndIf

		IF lProcDan
	    an        := anDanZakl[ DAN_950]
	    nZaokrHM  -= anDanZAKL[ DAN_901, 9]
      anDanZakl := aClone( AN_DAN)
      anDanZakl[ DAN_950] := an
		ENDIF
  EndCase

// stanoven¡ X procent p©i soubˆhu p©¡jm–
  nSoubehPrijmu := ( anDanZAKL[ DAN_905, _KCS] +anDanZAKL[ DAN_908, _KCS]) - ;
                      nHodnZdrSt

//  vygenerov n¡ odpoŸitatelnìch polo§ek
	xKEY := StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( nRok, 4) +             ;
							StrZero( MsPrc_Mz ->nPorPraVzt)

	nxSUM   := 0
	nxSUM2  := 0
	cTAGold := MsOdpPol ->( OrdSetFOCUS())
	nRECold := MsOdpPol ->( Recno())

	MsOdpPol ->( SET_sSCOPE( 1, xKEY))
	 DO WHILE !MsOdpPol ->( Eof())
		 IF MsOdpPol ->lOdpocet
			 IF !Empty( MsPrc_Mz ->dDatVyst) .AND. MsPrc_Mz ->dDatVyst <= LastODate( nRok, nMesic)
			   IF Empty( MsOdpPol ->dPlatnDO) .OR. MsOdpPol ->dPlatnDO >= MsPrc_Mz ->dDatVyst
				   IF MsOdpPol ->( Sx_Rlock())
						 MsOdpPol ->dPlatnDO := MsPrc_Mz ->dDatVyst
						 MsOdpPol ->cObdDO   := OBD_MM_YY( MsPrc_Mz ->dDatVyst)

       		   IF Year( MsOdpPol ->dPlatnDo)*100 +Month( MsOdpPol ->dPlatnDo) >= ( ACT_OBDyn()*100 +ACT_OBDon())           ;
 	          		.OR. Empty( MsOdpPol ->dPlatnDo)
 			   		   MsOdpPol ->lAktiv := .T.
						 ELSE
 			   		   MsOdpPol ->lAktiv := .F.
		   		   ENDIF
	     		   WRT_zmena( "MsOdpPol", .F.)
	    	   ENDIF
				 ENDIF
			 ENDIF

    	 IF ( Year( MsOdpPol ->dPlatnOd)*100 +Month( MsOdpPol ->dPlatnOd)) <= ( ACT_OBDyn()*100 +ACT_OBDon())            ;
					.AND. ( ( Year( MsOdpPol ->dPlatnDo)*100 +Month( MsOdpPol ->dPlatnDo)) >= ( ACT_OBDyn()*100 +ACT_OBDon())   ;
			 			 	  		.OR. Empty( MsOdpPol ->dPlatnDo))

      	 fgenSraz( C_Odpoc ->nDruhMzdy, MsOdpPol ->nOdpocOBD, .T.)
      	 fnapDoVp( C_Odpoc ->nDruhMzdy, 0, 0, MsOdpPol ->nOdpocOBD)
		  	 nxSUM += MsOdpPol ->nOdpocOBD
			 ENDIF
		 ENDIF
		 MsOdpPol ->( dbSkip())
	 ENDDO

	 MsOdpPol ->( dbGoTop())
	 DO WHILE !MsOdpPol ->( Eof())
		 IF MsOdpPol ->lDanUleva
			 IF !Empty( MsPrc_Mz ->dDatVyst) .AND. MsPrc_Mz ->dDatVyst <= LastODate( nRok, nMesic)
			   IF Empty( MsOdpPol ->dPlatnDO) .OR. MsOdpPol ->dPlatnDO >= MsPrc_Mz ->dDatVyst
				   IF MsOdpPol ->( Sx_Rlock())
						 MsOdpPol ->dPlatnDO := MsPrc_Mz ->dDatVyst
						 MsOdpPol ->cObdDO   := OBD_MM_YY( MsPrc_Mz ->dDatVyst)

       		   IF Year( MsOdpPol ->dPlatnDo)*100 +Month( MsOdpPol ->dPlatnDo) >= ( ACT_OBDyn()*100 +ACT_OBDon())           ;
 	          		.OR. Empty( MsOdpPol ->dPlatnDo)
 			   		   MsOdpPol ->lAktiv := .T.
						 ELSE
 			   		   MsOdpPol ->lAktiv := .F.
		   		   ENDIF
	     		   WRT_zmena( "MsOdpPol", .F.)
	    	   ENDIF
				 ENDIF
			 ENDIF

    	 IF ( Year( MsOdpPol ->dPlatnOd)*100 +Month( MsOdpPol ->dPlatnOd)) <= ( ACT_OBDyn()*100 +ACT_OBDon())            ;
					.AND. ( ( Year( MsOdpPol ->dPlatnDo)*100 +Month( MsOdpPol ->dPlatnDo)) >= ( ACT_OBDyn()*100 +ACT_OBDon())   ;
			 			 	  		.OR. Empty( MsOdpPol ->dPlatnDo))
				 AAdd( aDanUleva, {  C_Odpoc ->cTypOdpPol,C_Odpoc ->nDruhMzdy        ;
														 ,MsOdpPol ->nDanUlObd                           ;
				                     ,C_Odpoc ->nDruhMzdy2, C_Odpoc ->nDruhMzdy3     ;
														 ,C_Odpoc ->nDruhMzdy4, C_Odpoc ->nDruhMzdy5 })
      	 fgenSraz( C_Odpoc ->nDruhMzdy, MsOdpPol ->nDanUlOBD, .T.)
      	 fnapDoVp( C_Odpoc ->nDruhMzdy, 0, 0, MsOdpPol ->nDanUlOBD)
		  	 nxSUM2 += MsOdpPol ->nDanUlOBD
			 ENDIF
		 ENDIF
		 MsOdpPol ->( dbSkip())
	 ENDDO

	MsOdpPol ->( CLR_sSCOPE( cTAGold, nRECold))

	IF MsPrc_Mz ->nOdpocOBD <> nxSUM
		BOX_Waring( "POZOR nebyly spr vnØ nastaveny odpoŸit.polo§ky pracovn¡ka")
		fPrintErrIn( 7, nxSUM)
		MsPrc_Mz ->nOdpocOBD := nxSUM
	ENDIF

	IF MsPrc_Mz ->nDanUlOBD <> nxSUM2
		BOX_Waring( "POZOR nebyly spr vnØ nastaveny daåov‚ £levy pracovn¡ka")
		fPrintErrIn( 8, nxSUM2)
		MsPrc_Mz ->nDanUlOBD := nxSUM2
	ENDIF

	Mzdy_Obd ->nNemocCelk := nNemoc

  for nB = 1 to 8
    anDanPROC[ nB,     _KCS]  := Round( anDanPROC[ nB,     _KCS], +0.49)
    anDanPROC[ nB, _HRUBMZD]  := Round( anDanPROC[ nB, _HRUBMZD], +0.49)
		nZaokrHM                  += anDanPROC[ nB, _HRUBMZD]
  next

	anDanZAKL[ DAN_950, _KCS] := Round( anDanZAKL[ DAN_950, _KCS] +0.49, 0)

// pokud by vy¨el z klad z porn˜ tak p©ehodit na NULU
  FOR nB := 1 to len( anSumaSVP)
    nA := anSumaSvp[ nB, _DRMZ]

		DO CASE
		CASE nA = 504 .OR. nA = 506 .OR. nA = 508 .OR. nA = 586
      nSocDokl += anSumaSVP[ nB, SVP_KCS]

		CASE nA = 505 .OR. nA = 507 .OR. nA = 509 .OR. nA = 519 .OR. nA = 518 .OR. nA = 587
      nZdrDokl += anSumaSVP[ nB, SVP_KCS]

		CASE nA = 500 .OR. nA = 501 .OR. nA = 502 .OR. nA = 503               ;
			    .OR. ( nA >= 530 .AND. nA = 539)
      nDanDokl += anSumaSVP[ nB, SVP_KCS]

		CASE nA = 704
      nSocDoklO += anSumaSVP[ nB, SVP_KCS]

		CASE nA = 705
      nZdrDoklO += anSumaSVP[ nB, SVP_KCS]

		ENDCASE
  NEXT

// v˜po‡et mˆs¡‡n¡ danˆ
  nOdvSoc  := nOdvZdr  := 0
  nOdvSocO := nOdvZdrO := 0

  IF MsPrc_Mz ->lSocPojis
    nOdvSoc  := Round((( anDanZAKL[ DAN_901, _ZAKLSOC] *nProcSoc) /100) +.49, 0)
		if aZakSocStO[1] > 0
			nOdvSocO      := Round(((( (anDanZAKL[ DAN_901, _ZAKLSOC] - aZakSocStO[1]) *aOdvSoc[1])/100) +0.49), 0)
			aOdvSocStO[1] := Round(((( (aZakSocStO[1]) * 21.5)/100) +0.49), 0) //odvody pro statutary
			nOdvSocO      += aOdvSocStO[1]
		else
      nOdvSocO := Round(((( anDanZAKL[ DAN_901, _ZAKLSOC] *aOdvSoc[1])/100) +0.49), 0)
		endif
    fGenSraz( 704, nOdvSocO, .t. )
    fnapDoVp( 704, 0, 0,  nOdvSocO )
  ENDIF

  IF MsPrc_Mz ->nZdrPojis > 0
    IF nZdrNeplDn <> 0
      anDanZAKL[ DAN_919, _KCS] := nZdrNeplDn
			nTModvZDR := Round((( nZdrNeplDn *nProcZdrC) /100) +.49, 0)
			nOdvZdrNV := Round(( nTModvZDR /3) +.49, 0)
			nTModvZDR := nTModvZDR -nOdvZdrNV
//  vygenerovanì odvod zdr.poj za organizaci za neplacen‚ volno
      fGenSraz( 719, nTModvZDR, .t. )
      fnapDoVp( 719, 0, 0, nTModvZDR )
      Mzdy_Obd ->nOdvoZdrPO += nTModvZDR
//			nOdvZdrNV := Round((( nZdrNeplDn *nProcZdr) /100) +.49, 0)
    ENDIF

		nTModvZDR := Round((( anDanZAKL[ DAN_901, _ZAKLZDR] *nProcZdrC) /100) +.49, 0)
		nOdvZdr   := Round(( nTModvZDR /3) +.49, 0)
		nTModvZDR := nTModvZDR - nOdvZdr

//  vygenerovanì odvod zdr.poj za organizaci za z lohovou daå
    fGenSraz( 705, nTModvZDR, .t. )
    fnapDoVp( 705, 0, 0, nTModvZDR )
		Mzdy_Obd ->nOdvoZdrPO += nTModvZDR
    nOdvZdrO := nTModvZDR
	ENDIF

// dodanØn¡ penzijn¡ho pojiçtØn¡
//  PenPoDoDan()

// T e s t i k y
	IF lSOUBEH
		IF MsPrc_Mz ->cDruPraVzt  == "HLAVNI  "
       anDanZAKL[ DAN_903, _KCS] := nSUMAzakl
		ELSE
      anDanZAKL[ DAN_903, _KCS] := 0
		ENDIF
	  nSumMinMzd += Mzdy_Obd->nNapMinMzd
	ELSE
    anDanZAKL[ DAN_903, _KCS] := anDanZAKL[ DAN_901, _KCS] +nOdvSocO +nOdvZdrO
	  nSumMinMzd := Mzdy_Obd->nNapMinMzd
	ENDIF

  if anDanZAKL[ DAN_903, _KCS] < 0 .or. anDanZakl[ DAN_901, _KCS] == 0
    anDanZAKL[ DAN_903, _KCS] := 0
  endif

  anDanZAKL[ DAN_903, _DAN] := fdanVyp( anDanZAKL[ DAN_903, _KCS])
  anDanZAKL[ DAN_904, _DAN] := nOdvSoc
  anDanZAKL[ DAN_905, _DAN] := nOdvZdr
  anDanZAKL[ DAN_919, _DAN] := nOdvZdrNV

	Mzdy_Obd ->nZdanMzdaP := anDanZAKL[ DAN_903, _KCS]
	Mzdy_Obd ->nDanCelVyp := anDanZAKL[ DAN_903, _DAN]
//  Mzdy_Obd ->nDanUlevaC := MsPrc_Mz ->nDanUlOBD        // 19.1.2010


// v˜po‡et Procentu ln¡Danˆ
  aEval( anDanPROC, { |x| fprocDan( x, lSOUBEH) } )

// prvn¡ ‡ st v˜po‡tu €ist‚Mzdy
  aEval( anDanZAKL, { |X| anDanZAKL[ DAN_950, _KCS] -= X[ _DAN] })
  aEval( anDanPROC, { |X| anDanZAKL[ DAN_950, _KCS] -= X[ _DAN] })
  aEval( anDanPROC, { |X| anDanZAKL[ DAN_950, _KCS] -= X[ _ODVSOC] })
  aEval( anDanPROC, { |X| anDanZAKL[ DAN_950, _KCS] -= X[ _ODVZDR] })

// daåov  £leva
	IF MsPrc_Mz ->nDanUlOBD <> 0
		IF nROK = 2008 .or. nROK = 2009 .OR. nROK = 2010 .OR. nROK = 2011 ;
			   .OR. nROK = 2012
			nDanUlDeti := 0
			nDanovaUl  := 0
			nTMPminMzd := MH_RoundNumb( SysConfig( "Mzdy:nMinMzdaDB") / 2, 33)
			lDanBoOK   := IF(  nSumMinMzd >= nTMPminMzd, .T., .F.)

			FOR n := 1 TO Len( aDanUleva)
				IF aDanUleva[n,1] <> "DITE"
					IF (nDanovaUl +aDanUleva[n,3]) < anDanZAKL[ DAN_903, _DAN]
						GenSlevDan( aDanUleva[n,4], aDanUleva[n,5], aDanUleva[n,3])
						nDanovaUl += aDanUleva[n,3]
					ELSE
						nTmpUl := aDanUleva[n,3] - ( (nDanovaUl +aDanUleva[n,3]) -anDanZAKL[ DAN_903, _DAN])
						IF nTmpUl > 0
						  GenSlevDan( aDanUleva[n,4], aDanUleva[n,5], nTmpUl)
						  nDanovaUl += nTmpUl
						ENDIF
					ENDIF
				ELSE
					nDanUlDeti += aDanUleva[n,3]
				ENDIF
			NEXT

    	IF anDanZAKL[ DAN_903, _DAN] >= MsPrc_Mz ->nDanUlOBD
 	    	nTmpUl := MsPrc_Mz ->nDanUlOBD -nDanovaUl
	    ELSE
			  nTmpUl := anDanZAKL[ DAN_903, _DAN] - nDanovaUl
			  nTmpUl := IF( nDanUlDeti >= nTmpUl, nTmpUl, 0)
		  ENDIF

			nDanovyBo := 0
			IF( nTmpUl > 0, GenSlevDan( 530, 960, nTmpUl), NIL)
			nDanovyBo := nDanUlDeti - nTmpUl
			nDanovyBo := IF( nDanovyBo >= 50, nDanovyBo, 0)

			IF lDanBoOK .AND. nDanovyBo > 0
				nDanovyBo := IF( nDanovyBo > 5025, 5025, nDanovyBo)
 		    GenSlevDan( 531, 961, nDanovyBo)
			ELSE
				nDanovyBo := 0
	  	ENDIF

	//	 	  anDanZAKL[ DAN_950, _KCS] += nDanovaUl
	  	nDanovaUl := ( nDanovaUl +nTmpUl) * (-1)
	  	nDanovyBo := nDanovyBo * (-1)
		ENDIF
	ENDIF

	Mzdy_Obd ->nZaklZdrPo += anDanZAKL[ DAN_905, _KCS]                       ;
	                              +anDanZAKL[ DAN_909, _KCS]                 ;
		                              +anDanZAKL[ DAN_919, _KCS]

	Mzdy_Obd ->nOdvoZdrPZ += anDanZAKL[ DAN_905, _DAN]                       ;
		                            +anDanZAKL[ DAN_909, _DAN]                 ;
		                              +anDanZAKL[ DAN_919, _DAN] +nZdrDokl

	aEval( anDanProc, { |X|	Mzdy_Obd ->nZaklSocPo += X[ _ZAKLSOC], ;
	            						Mzdy_Obd ->nOdvoSocPZ += X[ _ODVSOC],  ;
              						Mzdy_Obd ->nZaklZdrPo += X[ _ZAKLZDR], ;
						              Mzdy_Obd ->nOdvoZdrPZ += X[ _ODVZDR],  ;
						              Mzdy_Obd ->nOdvoSocPO += X[ _ODVSOCO], ;
						              Mzdy_Obd ->nOdvoZdrPO += X[ _ODVZDRO] })

// Test zda zaklad zdravotniho pojisteni dosahl minimalni mzdy
  na := anDanZAKL[ DAN_901, _ZAKLZDR] +anDanZakl[ DAN_902, _ZAKLZDR] + ;
        anDanProc[       1, _ZAKLZDR] +anDanProc[       2, _ZAKLZDR] + ;
        anDanProc[       3, _ZAKLZDR] +anDanProc[       4, _ZAKLZDR] + ;
        anDanProc[       5, _ZAKLZDR] +anDanProc[       6, _ZAKLZDR] + ;
        anDanProc[       7, _ZAKLZDR] +anDanProc[       8, _ZAKLZDR] + ;
				anDanZAKL[ DAN_919,     _KCS]


  IF Mzdy_Obd ->nDnyNemoKD > 0 .OR. Mzdy_Obd ->nFondKDDn < nLastDay
    nTMPzakl := nMinMzda / nLastDay    //Mzdy_Obd ->nFondKDDn
    nTMPzakl := Round( nTMPzakl * ( Mzdy_Obd ->nFondKDDn - Mzdy_Obd ->nDnyNemoKD), 0)
//     nTMPzakl := Round( nTMPzakl * ( nLastDay - Mzdy_Obd ->nDnyNemoKD), 0)
  ELSE
    nTMPzakl := nMinMzda
  ENDIF

  nZaDOPLzdr := nTMPzakl - na

  If ( nZaDOPLzdr > 0 .and. MsPrc_Mz ->nTypPraVzt <= 2       ;
                      .and. MsPrc_Mz ->nTypDuchod == 0       ;
                      .and. !lStudent,                       ;  //MsPrc_Mz ->nTypZamVzt <> 11,         ;
         fPrintErrIn( 5, na), NIL)

  IF nZaDOPLzdr > 0 .AND. MsPrc_Mz ->nZdrPojDop > 0
    nTModvZDR  := Round((( nTMPzakl *nProcZdrC) /100) +.49, 0)
    nOdDOPLzdr := Round(( nTModvZDR /3) +.49, 0)
    nOdDOPLzdr := nOdDOPLzdr - Mzdy_Obd ->nOdvoZdrPZ
    nTModvZDR  := nTModvZDR - ( Mzdy_Obd ->nOdvoZdrPZ +nOdDOPLzdr +Mzdy_Obd ->nOdvoZdrPO)

//  vygenerovanì odvod zdr.poj za organizaci za doplatek zdr.pojiçtØn¡
    DO CASE
    CASE MsPrc_Mz ->nZdrPojDop == 1
      fGenSraz( 718, nTModvZDR +nOdDOPLzdr, .t. )
      Mzdy_Obd ->nOdvoZdrPO += nTModvZDR +nOdDOPLzdr

    CASE MsPrc_Mz ->nZdrPojDop == 2
      fGenSraz( 518, nTModvZDR +nOdDOPLzdr)
      fnapDoVp( 518, 0, 0, nTModvZDR +nOdDOPLzdr )
      Mzdy_Obd ->nOdvoZdrPZ += nTModvZDR +nOdDOPLzdr

    CASE MsPrc_Mz ->nZdrPojDop == 3 .OR. MsPrc_Mz ->nZdrPojDop == 4
      fGenSraz( 518, nOdDOPLzdr)
      fnapDoVp( 518, 0, 0, nOdDOPLzdr )
      Mzdy_Obd ->nOdvoZdrPZ += nOdDOPLzdr
      IF MsPrc_Mz ->nZdrPojDop == 4
        fGenSraz( 569, nTModvZDR)
        fnapDoVp( 569, 0, 0, nTModvZDR)
      ENDIF
      fGenSraz( 718, nTModvZDR, .t. )
      Mzdy_Obd ->nOdvoZdrPO += nTModvZDR
    ENDCASE
    fGenSraz( 918, nZaDOPLzdr, .t. )
    Mzdy_Obd ->nZaklZdrPo += nZaDOPLzdr
  ENDIF

// pokud m  m lo nebo moc voln˜ch dn– tak buÔ vyp¡çem nebo vygenerujem
  IF MsPrc_Mz ->nTarSazMes <> 0     ///  POZOR je nutno upravit ve vazbØ na typ mzdy
//		 nVolDnyCp += f_SvatkyOD( nRok, nMesic, 1, nLastDay)
  ENDIF


//  aktualizace sumaŸn¡ho souboru za pracovn¡ka

  Mzdy_Obd ->nZalohoDan := anDanZAKL[ DAN_903, _DAN]                       ;
                            +anDanPROC[ 5, _DAN] +anDanPROC[ 6, _DAN]      ;
                             +anDanPROC[ 7, _DAN] +anDanPROC[ 8, _DAN]     ;
														  + nDanDokl +nDanovaUl +nDanovyBo
  Mzdy_Obd ->nSrazkoDan := anDanZAKL[ 1, _DAN] +anDanPROC[ 2, _DAN]        ;
                            +anDanPROC[ 3, _DAN] +anDanPROC[ 4, _DAN]

  Mzdy_Obd ->nZaklSocPo += anDanZAKL[ DAN_904, _KCS]                       ;
                            +anDanZAKL[ DAN_908, _KCS]

  Mzdy_Obd ->nOdvoSocPZ += anDanZAKL[ DAN_904, _DAN]                       ;
                            +anDanZAKL[ DAN_908, _DAN] +nSocDokl

  Mzdy_Obd ->nDanCelkem := Mzdy_Obd ->nZalohoDan +Mzdy_Obd ->nSrazkoDan

// z lohu mus¡ vr tit
//  fgenMzdy( 568, 14, -1)

// pýeplateŸky z minul‚ho mØs¡ce
//  fgenMzdy( 566, 23, -1)
//	MsPrc ->m023 := 0

// pokud je odbor ý tak si to zaplat¡
  IF MsPrc_Mz ->lOdborar
    nZaklOdbor := Round( nZaklOdbor, 0)
    nZaklOdbor -= ( anDanZAKL[ DAN_904, _DAN] + ;
                    anDanZAKL[ DAN_905, _DAN] + ;
                    anDanZAKL[ DAN_903, _DAN] + ;
                    anDanZAKL[ DAN_902, _DAN] + ;
                    anDanZAKL[ DAN_908, _DAN] + ;
                    anDanZAKL[ DAN_909, _DAN] + ;
                    anDanZAKL[ DAN_919, _DAN] + ;
                    anDanProc[       1, _DAN] + ;
                    anDanProc[       2, _DAN] + ;
                    anDanProc[       3, _DAN] + ;
                    anDanProc[       4, _DAN] + ;
                    anDanProc[       1, _ODVSOC] + ;
                    anDanProc[       2, _ODVSOC] + ;
                    anDanProc[       3, _ODVSOC] + ;
                    anDanProc[       4, _ODVSOC] + ;
                    anDanProc[       1, _ODVZDR] + ;
                    anDanProc[       2, _ODVZDR] + ;
                    anDanProc[       3, _ODVZDR] + ;
                    anDanProc[       4, _ODVZDR] + ;
                    anDanProc[       5, _DAN] + ;
                    anDanProc[       6, _DAN] + ;
                    anDanProc[       7, _DAN] + ;
                    anDanProc[       8, _DAN] + ;
                    anDanProc[       5, _ODVSOC] + ;
                    anDanProc[       6, _ODVSOC] + ;
                    anDanProc[       7, _ODVSOC] + ;
                    anDanProc[       8, _ODVSOC] + ;
                    anDanProc[       5, _ODVZDR] + ;
                    anDanProc[       6, _ODVZDR] + ;
                    anDanProc[       7, _ODVZDR] + ;
                    anDanProc[       8, _ODVZDR] + ;
                    nDanDokl +nSocDokl +nZdrDokl + ;
	   							  nDanovaUl)   // vyhozenì bonus +nDanovyBo)

		nZaklOdbor := IF( nZaklOdbor < 0, 0, nZaklOdbor)
    IF nZaklOdbor > 0
      fgenSraz( 920, nZaklOdbor, .t.  )
      fnapDoVp( 920, 0, 0, nZaklOdbor )
    ENDIF
	ELSE
		nZaklOdbor := 0
  ENDIF

// sr ‘e‡ky kter‚ m  v Matri‡ ku
  SrazZAM( 1)

// tak a co si zastr‡¡ do portmonky
  nRoundVypl := round( anDanZAKL[ DAN_950, _KCS], 0)
  nHalerVyr  := nRoundVypl -anDanZAKL[ DAN_950, _KCS]

  IF MsPrc_Mz ->nTypZamVzt == 2 .OR. MsPrc_Mz ->nTypZamVzt == 3         ;
			.OR. MsPrc_Mz ->nTypZamVzt == 4
    anHalVYR[ 1, 2] += nHalerVyr
  ELSE
    anHalVYR[ 2, 2] += nHalerVyr
  ENDIF

// zaokrouhlen¡ na 10 KŸ
  IF MsPrc_Mz ->lZaokrNa10 .OR. MsPrc_Mz ->nZaokrNa10 > 0
    nRoundVypl += MsPrc_Mz ->nZaokrNa10

    IF Empty( MsPrc_Mz ->dDatVyst) .AND. MsPrc_Mz ->lZaokrNa10
      IF MsPrc_Mz ->nZaokrNa10 > 0
        fgenSraz( 596, -1 *MsPrc_Mz ->nZaokrNa10, .t. )
        fnapDoVp( 596, 0, 0, MsPrc_Mz ->nZaokrNa10    )
      ENDIF

      MsPrc_Mz ->nZaokrNa10 := 0
      IF nRoundVypl > 0
        nZbytekDoDes := nRoundVypl % 10
        fgenSraz( 595, nZbytekDoDeset, .t.  )
        fnapDoVp( 595, 0, 0, nZbytekDoDeset )
        nRoundVypl            -= nZbytekDoDes
        MsPrc_Mz ->nZaokrNa10 := nZbytekDoDes
      ENDIF
    ELSE
      IF Month( MsPrc_Mz ->dDatVyst) <= nMesic .OR. !MsPrc_Mz ->lZaokrNa10
        IF !Empty( MsPrc_Mz ->nZaokrNa10)
          fgenSraz( 596, -1 *MsPrc_Mz ->nZaokrNa10, .t. )
          fnapDoVp( 596, 0, 0, MsPrc_Mz ->nZaokrNa10    )
          MsPrc_Mz ->nZaokrNa10 := 0
        ENDIF
      ENDIF
    ENDIF
  ENDIF

  Mzdy_Obd ->nCastKVypl := anDanZAKL[ DAN_950, _KCS]

// zustatek dame na ucet
  IF ( anDanZAKL[ DAN_950, _KCS] := nRoundVypl) > 0
    SrazZAM( 2)
  ENDIF

// n˜‡ko mu to napo‡teme nap©ed do MsPrc a taky do Vypl
  aEval ( anSumaSVP, { |x| fnapDoMs( x, 'Mz') } )
  aEval ( anDanPROC, { |x| fnapDoMs( x, 'Dp') } )
  aEval ( anDanZAKL, { |x| fnapDoMs( x, 'Dz') } )

// Oprava INGE
  IF MzKumRoP ->M102 == 0
    IF MzKumRoP ->M101 <= MsPrc_Mz ->nDovMinNar
      Vypl ->nDovMinR := MsPrc_Mz ->nDovMinNar -MzKumRoP ->M101
      Vypl ->nDovAktR := MsPrc_Mz ->nDovBezNar

      MsPrc_Mz ->nDovMinZus := MsPrc_Mz ->nDovMinNar -MzKumRoP ->M101
      MsPrc_Mz ->nDovMinCer := MzKumRoP ->M101
      MsPrc_Mz ->nDovBezZus := MsPrc_Mz ->nDovBezNar

      MsPrc_Mo ->nDovMinZus := MsPrc_Mz ->nDovMinNar -MzKumRoP ->M101
      MsPrc_Mo ->nDovMinCer := MzKumRoP ->M101
      MsPrc_Mo ->nDovBezZus := MsPrc_Mz ->nDovBezNar
    ELSE
      Vypl ->nDovMinR := 0
      Vypl ->nDovAktR := MsPrc_Mz ->nDovBezNar + MsPrc_Mz ->nDovMinNar    ;
                          -MzKumRoP ->m101

      MsPrc_Mz ->nDovMinZus := 0
      MsPrc_Mz ->nDovMinCer := MsPrc_Mz ->nDovMinNar
      MsPrc_Mz ->nDovBezZus := MsPrc_Mz ->nDovBezNar + MsPrc_Mz ->nDovMinNar    ;
			                                - MzKumRoP ->m101
      MsPrc_Mz ->nDovBezCer := MzKumRoP ->m101 -MsPrc_Mz ->nDovMinNar

      MsPrc_Mo ->nDovMinZus := 0
      MsPrc_Mo ->nDovMinCer := MsPrc_Mz ->nDovMinNar
      MsPrc_Mo ->nDovBezZus := MsPrc_Mz ->nDovBezNar + MsPrc_Mz ->nDovMinNar    ;
			                                - MzKumRoP ->m101
      MsPrc_Mo ->nDovBezCer := MzKumRoP ->m101 -MsPrc_Mz ->nDovMinNar
    ENDIF
  ELSE
    Vypl ->nDovAktR  := MsPrc_Mz ->nDovBezNar -MzKumRoP ->M101
    Vypl ->nDovMinR  := MsPrc_Mz ->nDovMinNar -MzKumRoP ->M102

    MsPrc_Mz ->nDovMinCer   := MzKumRoP ->M102
    MsPrc_Mz ->nDovMinZus   := MsPrc_Mz ->nDovMinNar - MzKumRoP ->M102
    MsPrc_Mz ->nDovBezCer   := MzKumRoP ->M101
    MsPrc_Mz ->nDovBezZus   := MsPrc_Mz ->nDovBezNar - MzKumRoP ->M101

    MsPrc_Mo ->nDovMinCer   := MzKumRoP ->M102
    MsPrc_Mo ->nDovMinZus   := MsPrc_Mz ->nDovMinNar - MzKumRoP ->M102
    MsPrc_Mo ->nDovBezCer   := MzKumRoP ->M101
    MsPrc_Mo ->nDovBezZus   := MsPrc_Mz ->nDovBezNar - MzKumRoP ->M101
  ENDIF

  MsPrc_Mz ->nDovZustat := MsPrc_Mz ->nDovBezZus +MsPrc_Mz ->nDovMinZus
  MsPrc_Mz ->nDoDZustat := MsPrc_Mz ->nDoDBezZus +MsPrc_Mz ->nDoDMinZus
  MsPrc_Mz ->nDovZustCe := MsPrc_Mz ->nDovZustat +MsPrc_Mz ->nDoDZustat

  MsPrc_Mo ->nDovZustat := MsPrc_Mz ->nDovZustat
  MsPrc_Mo ->nDoDZustat := MsPrc_Mz ->nDoDZustat
  MsPrc_Mo ->nDovZustCe := MsPrc_Mz ->nDovZustCe

  Mzdy_Obd ->nOdvoSocPO := Round(((( Mzdy_Obd ->nZaklSocPo *aOdvSoc[1])/100) +0.49), 0)
  Mzdy_Obd ->nOdvoSocPC := Mzdy_Obd ->nOdvoSocPZ +Mzdy_Obd ->nOdvoSocPO
  Mzdy_Obd ->nOdvoZdrPC := Mzdy_Obd ->nOdvoZdrPZ +Mzdy_Obd ->nOdvoZdrPO

	Mzdy_Obd ->nZakSocStO := aZakSocStO[1] + aZakSocStO[2]
	Mzdy_Obd ->nOdvSocStO := aOdvSocStO[1] + aOdvSocStO[2]
	if Mzdy_Obd ->nOdvSocStO <> 0
		Mzdy_Obd ->nOdvSocStZ := Mzdy_Obd ->nOdvoSocPZ
	endif

	if Mzdy_Obd ->nDanCelVyp < Mzdy_Obd ->nSlevaDanC
		Mzdy_Obd ->nSlevaDanU := Mzdy_Obd ->nDanCelVyp
	else
		Mzdy_Obd ->nSlevaDanU := Mzdy_Obd ->nSlevaDanC
	endif

// Test zda hruby prijem pracovnika dosahl minimalni mzdy
  na := anDanZAKL[ DAN_901,    9] +anDanZAKL[ DAN_902,    9] + ;
        anDanProc[       1, _HRUBMZD] +anDanProc[       2, _HRUBMZD] +         ;
        anDanProc[       3, _HRUBMZD] +anDanProc[       4, _HRUBMZD] +         ;
        anDanProc[       5, _HRUBMZD] +anDanProc[       6, _HRUBMZD] +         ;
        anDanProc[       7, _HRUBMZD] +anDanProc[       8, _HRUBMZD] + nNemoc

  If( na < nMinMzda .AND. MsPrc_Mz ->nTypPraVzt <= 2                        ;
                      .AND. MsPrc_Mz ->nTypDuchod == 0                      ;
			                 .AND. !lStudent,                                     ;    //     MsPrc_Mz ->nTypZamVzt <> 11,
      fPrintErrIn( 4, na), NIL)

//  If( na-nNemoc > 8200 .AND. ( MsPrc_Mz ->nTypDuchod <> 0                      ;
//                         .AND. MsPrc_Mz ->nTypDuchod <= 4  ),                  ;
//      fPrintErrIn( 6, na - nNemoc), NIL)


// specieln¡ polo‘ka Da¤ov˜ z klad mesicni tabulka
  IF lSOUBEH
    na := IF( MsPrc_Mz ->cDruPraVzt == "HLAVNI  ", nSUMAzakl, 0)

  ELSE
    na := anDanZAKL[ DAN_903, _KCS]

/*
    na := anDanZAKL[ DAN_901, _KCS]  -                           ;
                                   ( anDanZAKL[ DAN_904, _DAN] + ;
                                     anDanZAKL[ DAN_905, _DAN] + ;
                                     anDanZAKL[ DAN_919, _DAN] + ;
                                     +nSocDokl +nZdrDokl )
*/
  ENDIF

  IF nZaokrHM <> 0
    fgenSraz( 900, nZaokrHM, .t. )
    fnapDoVp( 900, 0, 0, nZaokrHM)
    IF DruhyMZD ->( dbSeek( 900))
      c := 'm' +strZero( DruhyMZD ->Rz_Kcs)
      IF ( nPosInMs := MzKumRoP ->( fieldPos( c))) > 0
        nValInMs := MzKumRoP ->( fieldGet( nPosInMs)) +nZaokrHM
        MzKumRoP ->( fieldPut( nPosInMs, nValInMs))
      ENDIF
    ENDIF
	ENDIF

  If na > 0
    Mzdy_Obd ->nDanZaklMz += na
    fgenSraz( 944, na, .t. )
    fnapDoVp( 944, 0, 0, na)
    if DruhyMZD ->( dbSeek( 941))
      c := 'm' +strZero( DruhyMZD ->Rz_Kcs)
      if ( nPosInMs := MzKumRoP ->( fieldPos( c))) > 0
        nValInMs := MzKumRoP ->( fieldGet( nPosInMs)) +na
        MzKumRoP ->( fieldPut( nPosInMs, nValInMs))
      endif
    endif
  EndIf


/*
  If na > 0
    Mzdy_Obd ->nDanZaklMz += na
    fgenSraz( 941, na, .t. )
    fnapDoVp( 941, 0, 0, na)
    if DruhyMZD ->( dbSeek( 941))
      c := 'm' +strZero( DruhyMZD ->Rz_Kcs)
      if ( nPosInMs := MzKumRoP ->( fieldPos( c))) > 0
        nValInMs := MzKumRoP ->( fieldGet( nPosInMs)) +na
        MzKumRoP ->( fieldPut( nPosInMs, nValInMs))
      endif
    endif
  EndIf


// specieln¡ polo‘ka Da¤ov˜ z klad rocni tabulka
  na := anDanZakl[ DAN_902, _KCS] -                            ;
                                 ( anDanZAKL[ DAN_908, _DAN] + ;
                                   anDanZAKL[ DAN_909, _DAN] )
  If na > 0
    Mzdy_Obd ->nDanZaklMz += na
    fgenSraz( 942, na, .t. )
    fnapDoVp( 942, 0, 0, na)
    if DruhyMZD ->( dbSeek( 942))
      c := 'm' +strZero( DruhyMZD ->Rz_Kcs)
      if ( nPosInMs := MzKumRoP ->( fieldPos( c))) > 0
        nValInMs := MzKumRoP ->( fieldGet( nPosInMs)) +na
        MzKumRoP ->( fieldPut( nPosInMs, nValInMs))
      endif
    endif
  EndIf
*/

// specieln¡ polo‘ka Da¤ov˜ z klad procentuelni dan
  na := anDanProc[       5, _KCS] +anDanProc[       6, _KCS] + ;
        anDanProc[       7, _KCS] +anDanProc[       8, _KCS] - ;
                              ( anDanProc[       5, _ODVSOC] + ;
                                anDanProc[       6, _ODVSOC] + ;
                                anDanProc[       7, _ODVSOC] + ;
                                anDanProc[       8, _ODVSOC] + ;
                                anDanProc[       5, _ODVZDR] + ;
                                anDanProc[       6, _ODVZDR] + ;
                                anDanProc[       7, _ODVZDR] + ;
                                anDanProc[       8, _ODVZDR] )
  If na > 0
    Mzdy_Obd ->nDanZaklMz += na
    fgenSraz( 943, na, .t. )
    fnapDoVp( 943, 0, 0, na)
    if DruhyMZD ->( dbSeek( 943))
      c := 'm' +strZero( DruhyMZD ->Rz_Kcs)
      if ( nPosInMs := MzKumRoP ->( fieldPos( c))) > 0
        nValInMs := MzKumRoP ->( fieldGet( nPosInMs)) +na
        MzKumRoP ->( fieldPut( nPosInMs, nValInMs))
      endif
    endif
  EndIf


// generov n¡ superhrub‚ mzdy ze sr §kov‚ danØ  £prava 25.9.2008
  na := anDanProc[       1, _KCS] +anDanProc[       2, _KCS] + ;
        anDanProc[       3, _KCS] +anDanProc[       4, _KCS] + ;
                              ( anDanProc[       1, _ODVSOCO] + ;
                                anDanProc[       2, _ODVSOCO] + ;
                                anDanProc[       3, _ODVSOCO] + ;
                                anDanProc[       4, _ODVSOCO] + ;
                                anDanProc[       1, _ODVZDRO] + ;
                                anDanProc[       2, _ODVZDRO] + ;
                                anDanProc[       3, _ODVZDRO] + ;
                                anDanProc[       4, _ODVZDRO] )
  If na > 0
    Mzdy_Obd ->nDanZaklMz += na
    fgenSraz( 944, na, .t. )
    fnapDoVp( 944, 0, 0, na)
    if DruhyMZD ->( dbSeek( 944))
      c := 'm' +strZero( DruhyMZD ->Rz_Kcs)
      if ( nPosInMs := MzKumRoP ->( fieldPos( c))) > 0
        nValInMs := MzKumRoP ->( fieldGet( nPosInMs)) +na
        MzKumRoP ->( fieldPut( nPosInMs, nValInMs))
      endif
    endif
  EndIf


// specieln¡ polo‘ka €ist˜ p©¡jem
  na := anDanZAKL[ DAN_901,        9] +anDanZakl[ DAN_902,        9] + ;
        anDanProc[       1, _HRUBMZD] +anDanProc[       2, _HRUBMZD] + ;
        anDanProc[       3, _HRUBMZD] +anDanProc[       4, _HRUBMZD] + ;
        anDanProc[       5, _HRUBMZD] +anDanProc[       6, _HRUBMZD] + ;
        anDanProc[       7, _HRUBMZD] +anDanProc[       8, _HRUBMZD] - ;
                                 ( anDanZAKL[ DAN_904, _DAN] + ;
                                   anDanZAKL[ DAN_905, _DAN] + ;
                                   anDanZAKL[ DAN_903, _DAN] + ;
                                   anDanZAKL[ DAN_902, _DAN] + ;
                                   anDanZAKL[ DAN_908, _DAN] + ;
                                   anDanZAKL[ DAN_909, _DAN] + ;
                                   anDanZAKL[ DAN_919, _DAN] + ;
                                   anDanProc[       1, _DAN] + ;
                                   anDanProc[       2, _DAN] + ;
                                   anDanProc[       3, _DAN] + ;
                                   anDanProc[       4, _DAN] + ;
                                   anDanProc[       1, _ODVSOC] + ;
                                   anDanProc[       2, _ODVSOC] + ;
                                   anDanProc[       3, _ODVSOC] + ;
                                   anDanProc[       4, _ODVSOC] + ;
                                   anDanProc[       1, _ODVZDR] + ;
                                   anDanProc[       2, _ODVZDR] + ;
                                   anDanProc[       3, _ODVZDR] + ;
                                   anDanProc[       4, _ODVZDR] + ;
                                   anDanProc[       5, _DAN] + ;
                                   anDanProc[       6, _DAN] + ;
                                   anDanProc[       7, _DAN] + ;
                                   anDanProc[       8, _DAN] + ;
                                   anDanProc[       5, _ODVSOC] + ;
                                   anDanProc[       6, _ODVSOC] + ;
                                   anDanProc[       7, _ODVSOC] + ;
                                   anDanProc[       8, _ODVSOC] + ;
                                   anDanProc[       5, _ODVZDR] + ;
                                   anDanProc[       6, _ODVZDR] + ;
                                   anDanProc[       7, _ODVZDR] + ;
                                   anDanProc[       8, _ODVZDR] + ;
                                   nDanDokl +nSocDokl +nZdrDokl + ;
																	 nDanovaUl)   // vyhozenì bonus +nDanovyBo)


  If na > 0
    Mzdy_Obd ->nCistPrije := na
    fgenSraz( 940, na, .t. )
    fnapDoVp( 940, 0, 0, na)
    if DruhyMZD ->( dbSeek( 940))
      c := 'm' +strZero( DruhyMZD ->Rz_Kcs)
      if ( nPosInMs := MzKumRoP ->( fieldPos( c))) > 0
        nValInMs := MzKumRoP ->( fieldGet( nPosInMs)) +na
        MzKumRoP ->( fieldPut( nPosInMs, nValInMs))
        Vypl ->nKumMzda := nValInMs
      endif
    endif
  EndIf

/*
// sleva na soci ln¡m za organizaci
  Mzdy_Obd->nPocZamSlO := 0
	Mzdy_Obd->nSlevSocPO := 0

	If Mzdy_Obd->nZaklSocPO > 0 .and. Mzdy_Obd->nZaklSocPO < 27100
		If fNarSlevZAM( nRok, nMesic)
			na := Mh_RoundNum((( 27100 - Mzdy_Obd->nZaklSocPO) * 0.033), 31)
			Mzdy_Obd->nSlevSocPO := na
			na := Mh_RoundNum( (Mzdy_Obd->nZaklSocPO * 0.25), 31)

			If( na < Mzdy_Obd->nSlevSocPO, Mzdy_Obd->nSlevSocPO := na, nil)

      fgenSraz( 790, Mzdy_Obd->nSlevSocPO, .t.)

			Mzdy_Obd->nPocZamSlO := 1

		EndIf
	EndIf
*/

// OdeŸet sv tk… z nemoci pro hodiny £ýadu pr ce
	if Mzdy_Obd ->nHodNemZak > 0
		na := nDnySvNem * fPracDOBA( Mzdy_Obd ->cDelkPrDob)[3]
		Mzdy_Obd ->nHodFondUP := Mzdy_Obd ->nHodFondUP - na
	endif



  Mzdy_Obd ->dPoslZpraM := Date()
  Mzdy_Obd ->cPoslZpraM := Time()

  Mzdy_Obd ->( DcrUnlock())
  Vypl ->( DcrUnlock())

// nu a jedem na dal¨¡ho pracanta
  anSumaSVP      := {}
  anDanPROC      := aClone( AN_PROC )
  anDanZAKL      := aClone( AN_DAN  )
	aZakSocStO     := { 0, 0 }
	aOdvSocStO     := { 0, 0 }
	anFondPD       := { 0, 0 }
  anVolneDNY[ 2] := 0
  anVolneDNY[ 4] := 0
  anVolneDNY[ 5] := 0
  anVolneDNY[ 7] := 0
  nZaklOdbor     := 0
  nNemoc         := 0
  nZdrDuch       := 0
  nProcSoc       := nPrcSocCfg
  nProcZdr       := nPrcZdrCfg
	nDnySvNem      := 0

RETURN( NIL)


// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄVìpoŸet procentueln¡ danØÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
STATIC FUNCTION fProcDan( x, lSOUBEH)
  Local  n
  LOCAL  nTModvZDR, nX
	LOCAL  nY

  DEFAULT lSOUBEH TO .F.

  x[ _KCS]		 :=	Round( x[ _KCS]     +0.49, 0)
  x[ _ZAKLSOC] := Round( x[ _ZAKLSOC] +0.49, 0)
  x[ _ZAKLZDR] := Round( x[ _ZAKLZDR] +0.49, 0)
  n            := x[ _KCS]

  IF x[ _KCS] > 0
    IF MsPrc_Mz ->lSocPojis
      x[ _ODVSOC] := Round((( x[ _ZAKLSOC]/ 100) *nProcSoc) +.49, 0)
		  if aZakSocStO[2] > 0
        x[ _ODVSOCO]  := Round(((( x[ _ZAKLSOC]- aZakSocStO[2]) / 100) *aOdvSoc[1]) +.49, 0)
        aOdvSocStO[2] := Round((( aZakSocStO[2] / 100) *21.5) +.49, 0)
        x[ _ODVSOCO]  += aOdvSocStO[2]
		  else
        x[ _ODVSOCO] := Round((( x[ _ZAKLSOC]/ 100) *aOdvSoc[1]) +.49, 0)
		  endif
      x[ _KCS]    += x[ _ODVSOCO]
    ENDIF

    IF MsPrc_Mz ->nZdrPojis > 0
		  nTModvZDR    := Round((( x[ _ZAKLZDR] *nProcZdrC) /100) +.49, 0)
		  nX           := Round(( nTModvZDR /3) +.49, 0)
		  x[ _ODVZDRO] := nTModvZDR - nX
			x[ _ODVZDR]  += nX
      x[ _KCS]     += x[ _ODVZDRO]
    ENDIF

    If x[ _DRMZ] = 910 .or. x[ _DRMZ] = 911 .or. x[ _DRMZ] = 912 .or.  ;
         x[ _DRMZ] = 913
      x[ _DAN] := Round( (( x[ _KCS]/ 100) *x[ _PROC]) - 0.49, 0 )
    Else
      If x[ _KCS] <= 100
        x[ _KCS] := Round( x[ _KCS] + 0.49, 0)
      Else
        x[ _KCS] := ( Round( x[ _KCS]/100 + 0.49, 0)) * 100
      EndIf

			IF lSOUBEH
        x[ _DAN] := 0
			ELSE
        x[ _DAN] := Round( (x[ _KCS] * x[ _PROC]/100) + 0.49, 0 )
			ENDIF
    EndIf
    x[ _KCS] := n
  ENDIF

RETURN( NIL)


// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄVypocet z lohy Danˆ
FUNCTION fDanVyp( nVal, nROK)
  LOCAL nRetVal := 0, nDan := 0
	LOCAL aSAZdan, nN
	LOCAL nROKvyp

	DEFAULT nROKvyp TO ACT_OBDyn()

 	DO CASE
	CASE nROKvyp = 2008
		aSAZdan := { { 0, 0, 0, 0.15 } }
	CASE nROKvyp = 2009
		aSAZdan := { { 0, 0, 0, 0.15 } }
	CASE nROKvyp = 2010
		aSAZdan := { { 0, 0, 0, 0.15 } }
	CASE nROKvyp = 2011
		aSAZdan := { { 0, 0, 0, 0.15 } }
	CASE nROKvyp = 2012
		aSAZdan := { { 0, 0, 0, 0.15 } }
  ENDCASE

  IF nVal > 0
    IF nVal <= 100
      nVal := round( nVal + 0.49, 0)
    ELSE
      nVal := ( round( nVal/100 + 0.49, 0 ) ) * 100
    ENDIF

		FOR nN := 1 TO Len( aSAZdan)
			IF nVal <= aSAZdan[nN,2] .OR. nN == Len( aSAZdan)
				nDan := IF( aSAZdan[nN,3] = 0, nVal * aSAZdan[nN,4]     ;
                    , aSAZdan[nN,3] +(( nVal - aSAZdan[nN,1]) * aSAZdan[nN,4]))
				EXIT
			ENDIF
		NEXT

    nRetVal := round( nDan + 0.49, 0)
  ENDIF

RETURN( nRetVal)


// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄGenerov n¡ mzdov˜ch polo‘ek
Static Function FGenDmz( nDruhMzd, nDny, nHod, nKcs)
  Local  lGenMzdu := .F.
  Local  n, cMsDny, cMsHod, cMsKcs
	LOCAL  nHodPrDOBA := fPracDOBA()[3]

  If( n := ascan( anSumaSVP, { |x| x[ SVP_DRMZ] == nDruhMzd } )) == 0
    IF DruhyMZD ->( dbSeek( nDruhMzd))
      aAdd( anSumaSVP, AN_SVP)
      n      := Len( anSumaSVP)
      cMsDny := 'm' +strZero( DruhyMZD ->Rz_Dny )
      cMsHod := 'm' +strZero( DruhyMZD ->Rz_Hod )
      cMsKcs := 'm' +strZero( DruhyMZD ->Rz_Kcs )

      anSumaSVP[ n, SVP_DRMZ  ] := nDruhMzd
      anSumaSVP[ n, SVP_PROC  ] := IF( DruhyMZD ->nTypDane == 20, 1,   ;
                                    IF( DruhyMZD ->nTypDane == 21, 2,  ;
                                     IF( DruhyMZD ->nTypDane == 22, 3, ;
																		 	IF( DruhyMZD ->nTypDane == 23, 4, 0))))
      anSumaSVP[ n, SVP_DIL1  ] := DruhyMZD ->nTypDane == 1
      anSumaSVP[ n, SVP_DIL3  ] := DruhyMZD ->lSocPojis .and. MsPrc_Mz ->lSocPojis
      anSumaSVP[ n, SVP_DIL4  ] := DruhyMZD ->lZdrPojis .and. MsPrc_Mz ->nZdrPojis > 0
      anSumaSVP[ n, SVP_RZDNY ] := MzKumRoP ->( fieldPos( cMsDny))
      anSumaSVP[ n, SVP_RZHOD ] := MzKumRoP ->( fieldPos( cMsHod))
      anSumaSVP[ n, SVP_RZKCS ] := MzKumRoP ->( fieldPos( cMsKcs))
      anSumaSVP[ n, SVP_MSDNY ] := MzKumRoP ->( fieldGet( anSumaSVP[ n, SVP_RZDNY]))
      anSumaSVP[ n, SVP_MSHOD ] := MzKumRoP ->( fieldGet( anSumaSVP[ n, SVP_RZHOD]))
      anSumaSVP[ n, SVP_MSKCS ] := MzKumRoP ->( fieldGet( anSumaSVP[ n, SVP_RZKCS]))

      anSumaSVP[ n, SVP_DNY ]   += nDny
      anSumaSVP[ n, SVP_HOD ]   += nHod
      anSumaSVP[ n, SVP_KCS ]   += nKcs
      lGenMzdu := .T.
    EndIf
  Else
    anSumaSVP[ n, SVP_DNY ]   += nDny
    anSumaSVP[ n, SVP_HOD ]   += nHod
    anSumaSVP[ n, SVP_KCS ]   += nKcs
    lGenMzdu := .T.
  EndIf

   If lGenMzdu
//   Mzdy ->( dbAppend())
		 W_DelRepl( "Mzdy")

		 Mzdy ->cKmenStrPr := MsPrc_Mz ->cKmenStrPr
		 Mzdy ->nOsCisPrac := MsPrc_Mz ->nOsCisPrac
     Mzdy ->cPracZar   := MsPrc_Mz ->cPracZar
	   Mzdy ->nMimoPrVzt := MsPrc_Mz ->nMimoPrVzt
	   Mzdy ->nZdrPojis  := MsPrc_Mz ->nZdrPojis
		 Mzdy ->cTmKmStrPr := TMPkmenSTR( Mzdy ->cKmenStrPr)

		 Mzdy ->nDruhMzdy  := nDruhMzd

     Mzdy ->nDnyDoklad := nDny
     Mzdy ->nHodDoklad := nHod
     Mzdy ->nMzda      := nKcs

		 IF nDruhMzd == nDMzdyVd
			 Mzdy ->nDnyFondKd := Mzdy ->nDnyDoklad
			 Mzdy ->nHodFondKd := Mzdy ->nDnyDoklad * ( IF( nHodPrDOBA = 0                 ;
                                          , Round( nDelPrcTyd/nDnyPrcTyd, 2) ;
																					  ,	nHodPrDOBA))
		 ENDIF

		 IF nDruhMzd == 109
			 Mzdy ->nDnyFondKd := Mzdy ->nDnyDoklad
			 Mzdy ->nDnyFondPd := Mzdy ->nDnyDoklad
		 ENDIF

		 KeyFile()

     anDanZAKL[ DAN_950, _KCS] += nKcs

  	 Mzdy ->( DcrUnlock())

   EndIf

RETURN( Nil)


// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄGenerov n¡ sr ‘ek z MsPrc
static function fgenSraz( nDrMzdy, nKcs, lInNap, nPoradi, cStred)

  default lInNap  to .F.
  default nPoradi to 0
	DEFAULT cStred  TO MsPrc_Mz ->cKmenStrPr

	IF DruhyMZD ->( dbSeek( nDrMzdy))
    IF nKcs <> 0 .OR. nDrMzdy == 950
//    Mzdy ->( dbAppend())
  	  W_DelRepl( "Mzdy")

	    Mzdy ->cKmenStrPr := cStred
		  Mzdy ->nOsCisPrac := MsPrc_Mz ->nOsCisPrac
      Mzdy ->cPracZar   := MsPrc_Mz ->cPracZar
	    Mzdy ->nMimoPrVzt := MsPrc_Mz ->nMimoPrVzt
	    Mzdy ->nZdrPojis  := MsPrc_Mz ->nZdrPojis
		  Mzdy ->nDruhMzdy  := nDrMzdy

      Mzdy ->nMzda      := nKcs

		  Mzdy ->nPoradi    := nPoradi

			DO CASE
			CASE DruhyMZD ->cZkrTrvPla == "ZdrPo"
				Mzdy ->cZkrTypZav := "Zp" +StrZero( Mzdy ->nZdrPojis)

			CASE nPoradi <> 0  .AND. !Empty( MsSrz_Mz ->cZkrTypZav)
				IF nDrMzdy <> MsSrz_Mz ->nDruhMzdy2 .AND. nDrMzdy <> MsSrz_Mz ->nDruhMzdy3
				  Mzdy ->cZkrTypZav := MsSrz_Mz ->cZkrTypZav
				ENDIF
			OTHERWISE
			  IF !Empty( DruhyMZD ->cZkrTrvPla)
				   Mzdy ->cZkrTypZav := DruhyMZD ->cZkrTrvPla
				ENDIF
			ENDCASE

		  KeyFile()

      if !lInNap ;  anDanZAKL[ DAN_950, _KCS] += nKcs * ( -1) ; endif

 	    Mzdy ->( DcrUnlock())

			IF DruhyMZD ->cTypDMZ == "ZAKO"
			  Mzdy_Obd ->nZakOdCelk += nKcs
			ENDIF
			IF DruhyMZD ->cTypDMZ == "SRAZ"
			  Mzdy_Obd ->nSrazkCelk += nKcs
			ENDIF
    endif
	ENDIF

RETURN( NIL)


// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄN po‡ty do MsPrc
static function fnapDoMs( ax, cTyp)
  Local  nPosInMs, nValInMs := 0
  Local  nValInVp := 0
  Local  c, n, nNonZero
	LOCAL  nVAL

  DO CASE
  CASE cTyp == 'Mz'
    if ax[ SVP_RZDNY] > 0
      nValInMs := MzKumRoP ->( fieldGet( ax[ SVP_RZDNY])) +ax[ SVP_DNY]
      MzKumRoP ->( fieldPut( ax[ SVP_RZDNY], nValInMs))
    endif

    if ax[SVP_RZHOD] > 0
      nValInMs := MzKumRoP ->( fieldGet( ax[ SVP_RZHOD])) +ax[ SVP_HOD]
      MzKumRoP ->( fieldPut( ax[SVP_RZHOD], nValInMs))
    endif

    if ax[SVP_RZKCS] > 0
      nValInMs := MzKumRoP ->( fieldGet( ax[ SVP_RZKCS])) +ax[ SVP_KCS]
      MzKumRoP ->( fieldPut( ax[SVP_RZKCS], nValInMs))
    endif
		IF ax[ SVP_DRMZ] > 499 .AND. ax[ SVP_DRMZ] < 600
      fnapDoVp( ax[ SVP_DRMZ], ax[ SVP_HOD], ax[ SVP_DNY], ( ax[ SVP_KCS] *ax[SVP_ZNAM]) * -1)
		ELSE
      fnapDoVp( ax[ SVP_DRMZ], ax[ SVP_HOD], ax[ SVP_DNY], ax[ SVP_KCS] *ax[SVP_ZNAM])
		ENDIF

  CASE cTyp == 'Dp' .or. cTyp == 'Dz'
    if ax[ _DAN] <> 0 .and. DruhyMZD ->( dbSeek( ax[ _DRMZG]))
      c := 'm' +strZero( DruhyMZD ->Rz_Kcs)
      if( nPosInMs := MzKumRoP ->( fieldPos( c))) > 0
        nValInMs := MzKumRoP ->( fieldGet( nPosInMs)) +ax[ _DAN]
        MzKumRoP ->( fieldPut( nPosInMs, nValInMs))
      endif
      fgenSraz( ax[ _DRMZG], ax[ _DAN], .t. )
      fnapDoVp( ax[ _DRMZG], 0, 0, ax[ _DAN])
      if cTyp == 'Dp'
        if ax[ _DRMZG]=510 .or. ax[ _DRMZG]=511 .or. ax[ _DRMZG]=512 .or.;
             ax[ _DRMZG]=513
          if ax[ _ODVSOC] != 0
            fgenSraz( 906, ax[ _ZAKLSOC], .t. )
            fgenSraz( 706, ax[ _ODVSOCO], .t. )
            fgenSraz( 506, ax[ _ODVSOC],  .t. )
            fnapDoVp( 506, 0, 0, ax[ _ODVSOC])

//						Mzdy_Obd ->nZaklSocPo += ax[ _ZAKLSOC]
//						Mzdy_Obd ->nOdvoSocPZ += ax[ _ODVSOC]
          endif

          if ax[ _ODVZDR] != 0
            fgenSraz( 907, ax[ _ZAKLZDR], .t. )
            fgenSraz( 707, ax[ _ODVZDRO], .t. )
            fgenSraz( 507, ax[ _ODVZDR],  .t. )
            fnapDoVp( 507, 0, 0, ax[ _ODVZDR])

//						Mzdy_Obd ->nZaklZdrPo += ax[ _ZAKLZDR]
//						Mzdy_Obd ->nOdvoZdrPZ += ax[ _ODVZDR]
//						Mzdy_Obd ->nOdvoZdrPO += ax[ _ODVZDRO]
          endif
        Else
          if ax[ _ODVSOC] != 0
            fgenSraz( 986, ax[ _ZAKLSOC], .t. )
            fgenSraz( 586, ax[ _ODVSOC],  .t. )
            fnapDoVp( 586, 0, 0, ax[ _ODVSOC])

//						Mzdy_Obd ->nZaklSocPo += ax[ _ZAKLSOC]
//						Mzdy_Obd ->nOdvoSocPZ += ax[ _ODVSOC]

          endif
          if ax[ _ODVZDR] != 0
            fgenSraz( 987, ax[ _ZAKLZDR], .t. )
            fgenSraz( 787, ax[ _ODVZDRO], .t. )
            fgenSraz( 587, ax[ _ODVZDR] , .t. )
            fnapDoVp( 587, 0, 0, ax[ _ODVZDR])

//						Mzdy_Obd ->nZaklZdrPo += ax[ _ZAKLZDR]
//						Mzdy_Obd ->nOdvoZdrPZ += ax[ _ODVZDR]
//						Mzdy_Obd ->nOdvoZdrPO += ax[ _ODVZDRO]

          endif
        EndIf
      endif
    endif

		DO CASE
		CASE ax[ _DRMZ] == 901 .OR. ax[ _DRMZ] == 902
			nVAL := ax[9]
		CASE ax[ _DRMZ] == 910 .OR. ax[ _DRMZ] == 911 .OR. ax[ _DRMZ] == 912       ;
			    .OR. ax[ _DRMZ] == 913 .OR. ax[ _DRMZ] == 914 .OR. ax[ _DRMZ] == 915 ;
					 .OR. ax[ _DRMZ] == 916 .OR. ax[ _DRMZ] == 917
			nVAL := ax[ _HRUBMZD]

		OTHERWISE
		  nVAL := ax[ _KCS]
		ENDCASE

    ax[ _DRMZ] := if( ax[ _DRMZ] == 950 .and. nVAL < 0, 565, ax[ _DRMZ])
    nNonZero   := if( ax[ _DRMZ] == 565, -1, 1 )
    IF ( nVAL <> 0 .OR. ax[ _DRMZ] == 950 )                            ;
	       .AND. DruhyMZD ->( dbSeek( ax[ _DRMZ]))
      c := 'm' +strZero( DruhyMZD ->Rz_Kcs)
      IF( nPosInMs := MzKumRoP ->( fieldPos( c))) > 0
        nValInMs   := MzKumRoP ->( fieldGet( nPosInMs)) +nVAL *nNonZero
        MzKumRoP ->( fieldPut( nPosInMs, nValInMs))
      endif
      fgenSraz( ax[ _DRMZ], nVAL, .t.)
      fnapDoVp( ax[ _DRMZ] , 0, 0, nVAL)
    ENDIF
  ENDCASE

RETURN( NIL)


// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄN po‡ty do Vypl
static function fnapDoVp( nDMzdy, nHod, nDny, nKcs)
  Local  nPosInVp, nTypInVp, nValInVp := 0
  Local  nPosInC_Pol

  if c_PolRVp ->( dbSeek( nDMzdy))
    nPosInC_Pol := c_PolRVp ->( RecNo())
    do while nDMzdy == c_PolRVp ->nDruhMzdy .and. !c_PolRVp ->(Eof())
      nPosInVp := c_PolRVp ->nField_Vp
      nTypInVp := c_PolRVp ->nTypNap
      nValInVp += Vypl ->( fieldGet( nPosInVp)) + ;
                    if( nTypInVp == 1, nDny, if( nTypInVp == 2, nHod, nKcs))
      Vypl ->( fieldPut( nPosInVp, nValInVp))
      nValInVp := 0
      c_PolRVp ->( dbSkip())
    enddo
    c_PolRVp ->( dbGoTo( nPosInC_Pol))
  endif
return( nil)



// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTisk chybi‡ek p©i zpracov n¡ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ //
static function fprintErrIn( nError, nKc)
  Static nKeyInErr
  Local  acTypErr := { '< Pracovnik nen¡ v M.S. - pracovn¡k se nezpracoval>'               , ;
                       '< Chybnì druh mzdy  - radek se nezpracoval>'                       , ;
                       '< Vykazane volne dny rozdilne od kalednarniho fondu >'             , ;
                       '< Pracovnik nedosahl minimalni mzdy >'                             , ;
                       '< Z klad pro zdravotni pojisteni je mensi nez minim ln¡ mzda >'    , ;
											 '< Duchodce prekrocil maximalni hranici HM  >'                      , ;
											 '< POZOR u pracovn¡ka jsou rozd¡lnØ zadan‚ odpoŸitateln‚ polo§ky >' , ;
											 '< POZOR u pracovn¡ka jsou rozd¡lnØ zadan‚ daåov‚ £levy >'  }

  Default nKc to 0

  if nError == NIL
    wAppend( "FiERR", 'Vypis chyb pri zpracovani < CISTYCH MEZD > ')
    wAppend( "FiERR", 'za obdobi  ' +cObdobi )
    wAppend( "FiERR", "")
    wAppend( "FiERR", 'Ú' +replicate( chr( 196), 83) +'¿')
    wAppend( "FiERR", '³ Doklad Zp  Sp   Cp   Vyk  Prace   Dny   DMZ    ' + ;
                    'Sazba  Hodiny   Mno§stv¡        Kc ³')
    wAppend( "FiERR", 'À' +replicate( chr( 196), 83) +'Ù')
  else
    if nKeyInErr == NIL .or. nKeyInErr <> nError
      wAppend( "FiERR", "")
      wAppend( "FiERR", acTypErr[ nError])
      nKeyInErr := nError
    endif
    do case
    case nError == 3
      wAppend( "FiERR", '        '                   + ;
                      MsPrc_Mz ->cKmenStrPr          + ;
                      str( MsPrc_Mz ->nOsCisPrac, 5) + ;
                      '  ÄÄÄvykazÄÄÄ>  '             + ;
                      str( anVolneDNY [5], 2)        + ;
                      '  <ÄÄÄfondÄÄÄ>  '             + ;
                      str( nVolneDny     , 2))
    Case nError == 4
      wAppend( "FiERR", '        '                     + ;
                      MsPrc_Mz ->cKmenStrPr          + ;
                      str( MsPrc_Mz ->nOsCisPrac, 5) + ;
                      '  ÄÄÄÄ HM ÄÄÄ> '              + ;
                      str( nKc              ,  5   ) + ;
                      '  ÄÄmin.mzdaÄÄ> '             + ;
                      str( nMinMzda         ,  5   ) + ;
                      '  <ÄÄÄrozdilÄÄÄ> '            + ;
                      str( nMinMzda - nKc   ,  5   ))
    Case nError == 5
      wAppend( "FiERR", '        '                     + ;
                      MsPrc_Mz ->cKmenStrPr          + ;
                      str( MsPrc_Mz ->nOsCisPrac, 5) + ;
                      '  ÄÄzakl.zdrÄ> '              + ;
                      str( nKc              ,  5   ) + ;
                      '  ÄÄmin.mzdaÄÄ> '             + ;
                      str( nMinMzda         ,  5   ) + ;
                      '  <ÄÄÄrozd¡lÄÄÄ> '            + ;
                      str( nMinMzda - nKc   ,  5   ))
    Case nError == 6
      wAppend( "FiERR", '        '                     + ;
                      MsPrc_Mz ->cKmenStrPr          + ;
                      str( MsPrc_Mz ->nOsCisPrac, 5) + ;
                      '  ÄÄÄÄ HM ÄÄÄ> '              + ;
                      str( nKc              ,  5   ) + ;
                      '  ÄÄmax.do 2ÄÄ> '             + ;
                      ' 8200'  + ;
                      '  <ÄÄÄrozd¡lÄÄÄ> '            + ;
                      str( ABS(8200 - nKc)  ,  5   ))

    Case nError == 7
      wAppend( "FiERR", '        '                     + ;
                      MsPrc_Mz ->cKmenStrPr          + ;
                      str( MsPrc_Mz ->nOsCisPrac, 5) + ;
                      '  ÄÄ MsPrc ÄÄ> '              + ;
                      str( MsPrc_Mz ->nOdpocOBD, 5 ) + ;
                      '  ÄÄ MsOdpPÄÄÄ> '             + ;
                      str( nKc              ,  5   ) + ;
                      '  <ÄÄÄrozd¡lÄÄÄ> '            + ;
                      str( MsPrc_Mz ->nOdpocOBD - nKc,  5 ))
    Case nError == 8
      wAppend( "FiERR", '        '                     + ;
                      MsPrc_Mz ->cKmenStrPr          + ;
                      str( MsPrc_Mz ->nOsCisPrac, 5) + ;
                      '  ÄÄ MsPrc ÄÄ> '              + ;
                      str( MsPrc_Mz ->nDanUlOBD, 5 ) + ;
                      '  ÄÄ MsOdpPÄÄÄ> '             + ;
                      str( nKc              ,  5   ) + ;
                      '  <ÄÄÄrozd¡lÄÄÄ> '            + ;
                      str( MsPrc_Mz ->nDanUlOBD - nKc,  5 ))

    otherwise
      wAppend( "FiERR", '  ' +str( Mzdy ->nDoklad        ) + ;
                            SubStr( Mzdy ->cKmenStrPr, 1, 7) + ;
                            str( Mzdy ->nOsCisPrac,  6   ) + ;
                            str( Mzdy ->nDnyDoklad,  6   ) + ;
                            str( Mzdy ->nDruhMzdy ,  6   ) + ;
                            str( Mzdy ->nSazbaDokl,  9, 2) + ;
                            str( Mzdy ->nHodDoklad,  8, 2) + ;
                            str( Mzdy ->nMnPDoklad, 11, 2) + ;
                            str( Mzdy ->nMzda,      12, 2))
    endcase
  endif
Return( nil)


Function KeyFile()

  Mzdy ->cUloha     := "M"
  Mzdy ->cDenik     := SysConfig( "Mzdy:cDenikMzdy")
  Mzdy ->nRok       := nRok
  Mzdy ->nObdobi    := nMesic
  Mzdy ->cObdobi    := cObdobi
  Mzdy ->nDoklad    := 9900000 +MsPrc_Mz ->nOsCisPrac
	Mzdy ->nOrdItem   := nOrdItTMP
	Mzdy ->dDatPoriz  := Date()
	Mzdy ->cPracovnik := cPRACsort( "MsPrc_Mz")
	Mzdy ->nPorPraVzt := MsPrc_Mz ->nPorPraVzt
	Mzdy ->nTypPraVzt := MsPrc_Mz ->nTypPraVzt
	Mzdy ->nTypZamVzt := MsPrc_Mz ->nTypZamVzt
	Mzdy ->cMzdKatPra := MsPrc_Mz ->cMzdKatPra
	Mzdy ->nClenSpol  := IF( MsPrc_Mz ->nTypZamVzt == 2                      ;
	                          .OR. MsPrc_Mz ->nTypZamVzt == 3                ;
			                       .OR. MsPrc_Mz ->nTypZamVzt == 4, 1, 0)
	Mzdy ->nTypDuchod := MsPrc_Mz ->nTypDuchod
	Mzdy ->cPolVyplPa := DruhyMZD ->cPolVyplPa
	Mzdy ->cVyplMist  := MsPrc_Mz ->cVyplMist
	Mzdy ->cTmKmStrPr := TMPkmenSTR( MsPrc_Mz ->cKmenStrPr)

	nOrdItTMP++

Return( Nil)


Static Function wAppend( cAlias, cTxt)

	( cAlias) ->( dbAppend())
	( cAlias) ->cLine := cTxt

Return(Nil)


STATIC FUNCTION Mzdy_Srz( nSrazka, lDOKL)

	DEFAULT lDOKL  TO .F.

 	W_DelRepl( "Mzdy_Srz")

	IF lDOKL
		M_Srz ->( OrdSetFOCUS( 4))
		IF M_Srz ->( dbSeek( xKEYobOCPP +Cs_Upper("MS") +StrZero( Mzdy ->nDoklad)))
	    MH_CopyFLD( "M_Srz", 'Mzdy_Srz', .F.)
		ENDIF
	ELSE
	  MH_CopyFLD( "MsSrz_Mo", 'Mzdy_Srz', .F.)
	  Mzdy_Srz ->cUloha   := Mzdy ->cUloha
    Mzdy_Srz ->cDenik   := Mzdy ->cDenik
    Mzdy_Srz ->nDoklad  := Mzdy ->nDoklad
	  Mzdy_Srz ->nOrdItem := Mzdy ->nOrdItem

	  Mzdy_Srz ->cNazPol1 := Mzdy_Srz ->cKmenStrPr

	  Mzdy_Srz ->nSplatka := nSrazka
	ENDIF

 	Mzdy_Srz ->( DcrUnlock())

RETURN( NIL)


STATIC FUNCTION SrazZAM( nTYP)
	LOCAL  xKEY, xKEYm, xKEYo
	LOCAL  cOLDtag   := MsSrz_Mz ->( OrdSetFOCUS())
	LOCAL  nOLDrec   := MsSrz_Mz ->( Recno())
	LOCAL  cOLDtagO  := MsSrz_Mo ->( OrdSetFOCUS( 6))
	LOCAL  lMODIvypl := .T.
	LOCAL  lGENsrz   := .T.
	LOCAL  nSrazka   := 0
	LOCAL  aMinOBD   := {}
	LOCAL  nX, nPROC


	xKEY  := StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt)  ;
	           +StrZero( nTYP, 2)

	MsSrz_Mz ->( SET_sSCOPE( 5, xKEY))

	 DO CASE
	 CASE nTYP == 2
		 IF !MsSrz_Mz ->( Eof())
			 IF fOKsrz()
		     MODIsrz_Mo()
		     nSrazka := anDanZAKL[ DAN_950, _KCS]
	       anDanZAKL[ DAN_950, _KCS] -= nSrazka
		     fGenSraz( MsSrz_Mz ->nDruhMzdy, nSrazka, .T., MsSrz_Mz ->nPoradi)
         fnapDoVp( MsSrz_Mz ->nDruhMzdy, 0, 0, nSrazka)
		     Mzdy_Srz( nSrazka)
			 ENDIF
		 ENDIF
	 OTHERWISE
		 DO WHILE !MsSrz_Mz ->( Eof())
			 aMinOBD   := MODIsrz_Mo()
	     nSrazka   := 0
			 lMODIvypl := IF( MsSrz_Mz ->cTypSrz == "SRPP", .F., .T.)

			 IF fOKsrz()
				 DO CASE
				 CASE MsSrz_Mz ->nTypCastka = 2        // procentueln¡ sr §ka
					 DO CASE
					 CASE MsSrz_Mz ->cTypSrz == "SROD"
						 nSrazka := Round( ( nZaklOdbor * MsSrz_Mz ->nSplatka) / 100, 0)
					 CASE MsSrz_Mz ->cTypSrz == "SRPP"
						 IF MsSrz_Mz ->nCelkem == 0
							 nX := Mzdy_Obd ->nZaklSocPo
						 ELSE
							 nX := IF( Mzdy_Obd ->nZaklSocPo > MsSrz_Mz ->nCelkem          ;
							            , MsSrz_Mz ->nCelkem, Mzdy_Obd ->nZaklSocPo)
						 ENDIF

						 nSrazka := Round( ( ( nX * MsSrz_Mz ->nSplatka) / 100) -0.49, 0)
					 ENDCASE
				 OTHERWISE                             // sr §ka hodnotou
			     nSrazka := MsSrz_Mz ->nSplatka
		 	   ENDCASE

				 DO CASE
				 CASE MsSrz_Mz ->cTypSrz == "SRUV"  // pokud je z…statek £vØru menç¡ ne§ spl tka
					 IF (( MsSrz_Mz ->nCelkem +aMinOBD[1]) -( nSrazka +aMinOBD[2])) < 0
						 nSrazka := MsSrz_Mz ->nCelkem -aMinOBD[1]
					 ELSE
						 nSrazka += aMinOBD[2]          // pýiŸtu nedoplatek z min.mØs¡c…
					 ENDIF
					 IF MsSrz_Mz ->( Sx_RLock())
					   MsSrz_Mz ->nSplaceno  := aMinOBD[1] +nSrazka
					   MsSrz_Mz ->nZustatek  := MsSrz_Mz ->nCelkem - MsSrz_Mz ->nSplaceno
						 MsSrz_Mz ->dDatZustat := Date()
						 MsSrz_Mz ->( Sx_UnLock())
					   MsSrz_Mo ->nSplaceno  := aMinOBD[1] +nSrazka
					   MsSrz_Mo ->nZustatek  := MsSrz_Mz ->nCelkem - MsSrz_Mz ->nSplaceno
						 MsSrz_Mo ->dDatZustat := Date()
//						 MsSrz_Mo ->( Sx_UnLock())
					 ENDIF
			   ENDCASE

				 IF lMODIvypl
				   IF anDanZAKL[ DAN_950, _KCS] >= nSrazka
					   anDanZAKL[ DAN_950, _KCS] -= nSrazka
					   MsSrz_Mo ->nNedoplat      := 0
				   ELSE
					   IF anDanZAKL[ DAN_950, _KCS]  > 0.51
					     MsSrz_Mo ->nNedoplat      += nSrazka -anDanZAKL[ DAN_950, _KCS]
						   nSrazka						       := Int( anDanZAKL[ DAN_950, _KCS])
 					     anDanZAKL[ DAN_950, _KCS] -= nSrazka
					   ELSE
						   MsSrz_Mo ->nNedoplat      += nSrazka
						   lGENsrz                   := .F.
					   ENDIF
				   ENDIF
				 ENDIF

				 IF lGENsrz .AND. nSrazka > 0
					 fGenSraz( MsSrz_Mz ->nDruhMzdy, nSrazka, .T., MsSrz_Mz ->nPoradi)
           fnapDoVp( MsSrz_Mz ->nDruhMzdy, 0, 0, nSrazka)
					 Mzdy_Srz( nSrazka)

					 IF MsSrz_Mz ->cTypSrz == "SRPP"
					   fGenSraz( MsSrz_Mz ->nDruhMzdy2, nSrazka, .T., MsSrz_Mz ->nPoradi)
             fnapDoVp( MsSrz_Mz ->nDruhMzdy2, 0, 0, nSrazka)
//					   anDanZAKL[ DAN_950, _KCS] += nSrazka
					 ENDIF
				 ENDIF
       ENDIF

			 MsSrz_Mz ->( dbSkip())
		 ENDDO
	 ENDCASE

	 DcrUnlock( "MsSrz_Mo")
	MsSrz_Mz ->( CLR_sSCOPE( cOLDtag, nOLDrec))

RETURN( NIL)


STATIC FUNCTION fOKsrz()
	LOCAL lOK := .F.

	IF MsSrz_Mz ->lAktivSrz
		lOK := IF( !Empty( MsSrz_Mz ->dDatOdSpl) ;
		             , MsSrz_Mz ->dDatOdSpl <= LastODate( nROK, nMesic), .T.)
		lOK := lOK .AND. IF( !Empty( MsSrz_Mz ->dDatDoSpl) ;
		             , MsSrz_Mz ->dDatDoSpl >= CToD( "01/" +cZeroMES +"/"        ;
								                                  +cZeroROK), .T.)

		DO CASE
 	  CASE MsSrz_Mz ->cTypSrz == "SROD"     .AND. lOK
		  lOK := MsPrc_Mz ->lOdborar
		CASE MsSrz_Mz ->cZpusSraz == "OBDOBI" .AND. lOK
			lOK := .T.
		ENDCASE
	ENDIF

RETURN( lOK)


STATIC FUNCTION DELsrz_Mo()
	LOCAL  xKEY
	LOCAL  cOLDtag   := MsSrz_Mo ->( OrdSetFOCUS())
	LOCAL  nOLDrec   := MsSrz_Mo ->( Recno())
	LOCAL  cOLDtagMz := MsSrz_Mz ->( OrdSetFOCUS( 6))

	xKEY := StrZero( nRok, 4) +StrZero( nMesic, 2)    ;
	         +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt)

	MsSrz_Mo ->( SET_sSCOPE( 6, xKEY))
	 DO WHILE !MsSrz_Mo ->( Eof())
		 IF !MsSrz_Mz ->( dbSeek( xKEY +StrZero( MsSrz_Mo ->nPoradi)))
			 DelREC( "MsSrz_Mo")
			 DcrUnlock( "MsSrz_Mo")
		 ENDIF
		 MsSrz_Mo ->( dbSkip())
	 ENDDO
	MsSrz_Mo ->( CLR_sSCOPE( cOLDtag, nOLDrec))
  MsSrz_Mz ->( OrdSetFOCUS( cOLDtagMz))

RETURN( NIL)


STATIC FUNCTION MODIsrz_Mo()
	LOCAL  xKEY, xKEYm
	LOCAL  cOLDtag := MsSrz_Mo ->( OrdSetFOCUS( 6))
	LOCAL  aRETsrz := { 0, 0}
	LOCAL  nNEDsrz
	LOCAL  lNEW

 	xKEYm := StrZero( IF( nMesic == 1, nRok - 1, nRok), 4)               ;
            +StrZero( IF( nMesic == 1, 12, nMesic - 1), 2)             ;
	           +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt)

	xKEY  := StrZero( nRok, 4) +StrZero( nMesic, 2)  ;
	           +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt)

	IF MsSrz_Mo ->( dbSeek( xKEYm +StrZero( MsSrz_Mz ->nPoradi)))
		aRETsrz[1] := MsSrz_Mo ->nSplaceno
		aRETsrz[2] := MsSrz_Mo ->nNedoplat
	ENDIF

	lNEW := !MsSrz_Mo ->( dbSeek( xKEY  +StrZero( MsSrz_Mz ->nPoradi)))
	IF( !lNEW, MsSrz_Mo ->( Sx_RLock()), NIL)

	MH_CopyFLD( 'MsSrz_Mz', 'MsSrz_Mo', lNEW)

	MsSrz_Mo ->cObdobi := cObdobi
	MsSrz_Mo ->nRok    := nRok
	MsSrz_Mo ->nObdobi := nMesic


RETURN( aRETsrz)


STATIC FUNCTION MODImsp_Mo()
	LOCAL  xKEY, xKEYm
	LOCAL  nNEDsrz
	LOCAL  lNEW

	DC_DCOpen( { 'MsPrc_Mo, 1'})

	xKEY  := StrZero( nRok, 4) +StrZero( nMesic, 2)                           ;
	          +StrZero( MsPrc_Mz ->nOsCisPrac)                                ;
	           +StrZero( MsPrc_Mz ->nPorPraVzt)

	lNEW := !MsPrc_Mo ->( dbSeek( xKEY ))
	IF( !lNEW, ReplREC( "MsPrc_Mo"), NIL)

	IF !lNEW  .AND. ReplRec( "MsPrc_Mz")
		 MsPrc_Mz ->nZaokrNa10 := MsPrc_Mo ->nZaokrNa10
		 MsPrc_Mz ->( Sx_Unlock())
	ENDIF

	MH_CopyFLD( 'MsPrc_Mz', 'MsPrc_Mo', lNEW)

	MsPrc_Mo ->cObdobi    := cObdobi
	MsPrc_Mo ->nRok       := nRok
	MsPrc_Mo ->nObdobi    := nMesic
	MsPrc_Mo ->nCtvrtleti := CTVRTzOBDn( MsPrc_Mo ->nObdobi)

	WRT_zmena( "MsPrc_Mo", lNEW)

RETURN( NIL)


STATIC FUNCTION MODIkum_Ro( cTYP)
	LOCAL  xKEY, xKEYm
	LOCAL  lNEW, lEXISt

	TM_DCOpen( { 'MzKumRoP, 1'})

	IF cTYP == "IN"
 	  xKEY := StrZero( IF( nMesic == 1, nRok - 1, nRok), 4)               ;
             +StrZero( IF( nMesic == 1, 12, nMesic - 1), 2)             ;
	            +StrZero( MsPrc_Mz ->nOsCisPrac)                          ;
	             +StrZero( MsPrc_Mz ->nPorPraVzt)

	  MzKumRoP ->( __dbZap())

		lEXISt := MzKum_Ro ->( dbSeek( xKEY))

	  IF lEXISt .AND. nMesic <> 1
	    MH_CopyFLD( 'MzKum_Ro', 'MzKumRoP', .T.)
	  ELSE
	    MzKumRoP ->( dbAppend())
	    MzKumRoP ->nOsCisPrac := MsPrc_Mz ->nOsCisPrac
	    MzKumRoP ->cNazPol1   := MsPrc_Mz ->cNazPol1
	    MzKumRoP ->cPracovnik := MsPrc_Mz ->cPracovnik
	    MzKumRoP ->cKmenStrPr := MsPrc_Mz ->cKmenStrPr
	    MzKumRoP ->nPorPraVzt := MsPrc_Mz ->nPorPraVzt
	    MzKumRoP ->cPracZar   := MsPrc_Mz ->cPracZar
		  MzKumRoP ->cTmKmStrPr := TMPkmenSTR( MzKumRoP ->cKmenStrPr)
//	    MzKumRoP ->cMzdKatPra := MsPrc_Mz ->cMzdKatPra

	  ENDIF
	  MzKumRoP ->cObdobi := cObdobi
	  MzKumRoP ->nRok    := nRok
	  MzKumRoP ->nObdobi := nMesic

		IF( lEXISt .AND. nMesic == 1, MzKumRoP ->M132 := MzKum_Ro ->M132, NIL)
	ELSE
	  xKEY := StrZero( nRok, 4) +StrZero( nMesic, 2)  ;
	              +StrZero( MsPrc_Mz ->nOsCisPrac)    ;
	                +StrZero( MsPrc_Mz ->nPorPraVzt)

	  lNEW := !MzKum_Ro ->( dbSeek( xKEY ))
	  IF( !lNEW, MzKum_Ro ->( Sx_RLock()), NIL)
	  MH_CopyFLD( 'MzKumRoP', 'MzKum_Ro', lNEW)
	  WRT_zmena( "MzKum_Ro", lNEW)
  	DcrUnlock( 'MzKum_Ro')
	ENDIF

RETURN( NIL)


STATIC FUNCTION OKzdrPlSTA()
	LOCAL lOK

	lOK := lStudent .OR. MsPrc_Mz ->nTypDuchod <> 0                           ;   //    MsPrc_Mz ->nTypZamVzt = 11  ;
				   .OR. MsPrc_Mz ->nMimoPrVzt = 1 .OR. MsPrc_Mz ->nMimoPrVzt = 2    ;
						 .OR. MsPrc_Mz ->nMimoPrVzt = 3
RETURN( lOK)


STATIC FUNCTION GeMzdy_Obd()
	LOCAL  lNEW

	lNEW := !Mzdy_Obd ->( dbSeek( xKEYocpOBD))
	IF( !lNEW, ReplREC( "Mzdy_Obd"), NIL)
  MH_CopyFLD( 'MsPrc_Mo', 'Mzdy_Obd', lNEW)

//	aEval( aMzdy_Obd,  )
//	Mzdy_Obd ->

	WRT_zmena( "Mzdy_Obd")

	DcrUnlock( "Mzdy_Obd")


RETURN( NIL)


STATIC FUNCTION fDEL_ZprREC()
	LOCAL cTAGmzdy := Mzdy ->( OrdSetFOCUS())
	LOCAL cTAGsrz  := Mzdy_Srz ->( OrdSetFOCUS())
	LOCAL cTAGvypl := Vypl ->( OrdSetFOCUS())

	Mzdy ->( SET_sSCOPE( 12, xKEYobOCPP                                       ;
	                           +StrZero( 9900000 +MsPrc_Mz ->nOsCisPrac, 10)))
	 DO WHILE !Mzdy ->( Eof())
		 DelREC( "Mzdy")
		 Mzdy ->( dbSkip())
	 ENDDO
	Mzdy ->( CLR_SCOPE())

	Mzdy_Srz ->( SET_sSCOPE( 1, xKEYobOCPP))
	 DO WHILE !Mzdy_Srz ->( Eof())
		 DelREC( "Mzdy_Srz")
		 Mzdy_Srz ->( dbSkip())
	 ENDDO
	Mzdy_Srz ->( CLR_SCOPE())

	Vypl ->( OrdSetFOCUS( 6))
	IF( Vypl ->( dbSeek( xKEYobOCPP)), DelREC( "Vypl"), NIL)

	Mzdy ->( OrdSetFOCUS( cTAGmzdy))
	Mzdy ->( OrdSetFOCUS( cTAGsrz))
	Mzdy ->( OrdSetFOCUS( cTAGvypl))

RETURN( NIL)


STATIC FUNCTION SOUBEhPrVZ( pA)
	LOCAL  aDRprVZ := { .F., .F. }
	LOCAL  nOldTAG := Mzdy_Obd ->( OrdSetFOCUS())
	LOCAL  nOldREC := Mzdy_Obd ->( Recno())
	LOCAL  cTAGsco, nRECsco, cSCOPE
	LOCAL  aNEWvypoc

  cTAGsco := Mzdy_Obd  ->( OrdSetFOCUS())
  nRECsco := Mzdy_Obd  ->( Recno())
  cSCOPE  := Mzdy_Obd  ->( Sx_SetScope())

	nSUMAzakl := 0

  Mzdy_Obd ->( Set_sSCOPE( 1, xKEYobdOCP))
	 DO WHILE !Mzdy_Obd ->( Eof())
		 IF( Mzdy_Obd ->cDruPraVzt  == "HLAVNI  ", aDRprVZ[1] := .T., NIL)
		 IF( Mzdy_Obd ->cDruPraVzt  == "HLAVSOUB", aDRprVZ[2] := .T., NIL)
		 IF( Mzdy_Obd ->cDruPraVzt  == "VEDLSOUB", aDRprVZ[2] := .T., NIL)
		 nSUMAzakl += Mzdy_Obd ->nDanZaklMz
	   Mzdy_Obd ->( dbSkip())
	 ENDDO
 	Mzdy_Obd ->( Clr_SCOPE())

  IF( !IsNIL( cSCOPE), Mzdy_Obd ->( Set_sSCOPE( cTAGsco, cSCOPE)), NIL)

	Mzdy_Obd ->( OrdSetFOCUS( cTAGsco))
	Mzdy_Obd ->( dbGoTo( nRECsco))


	IF aDRprVZ[1] .AND. aDRprVZ[2]
    cTAGsco := MsPrc_Mz ->( OrdSetFOCUS())
    nRECsco := MsPrc_Mz ->( Recno())
    cSCOPE  := MsPrc_Mz ->( Sx_SetScope())

    MsPrc_Mz ->( Set_sSCOPE( 6, SubStr( xKEYobdOCP, 7)))
	   DO WHILE !MsPrc_Mz ->( Eof())
			 VYPOCETcm( pA, 9, .T.)
	     MsPrc_Mz ->( dbSkip())
	   ENDDO
	  MsPrc_Mz ->( Clr_SCOPE())

    IF( !IsNIL( cSCOPE), MsPrc_Mz ->( Set_sSCOPE( cTAGsco, cSCOPE)), NIL)

		nSumMinMzd := 0

	  MsPrc_Mz ->( OrdSetFOCUS( cTAGsco))
	  MsPrc_Mz ->( dbGoTo( nRECsco))
  ENDIF

RETURN( aDRprVZ)


FUNCTION fNapMzdOBD()
	LOCAL  dNAST, dVYST
	LOCAL  nX

  IF( Empty( nDelPrcTyd), nDelPrcTyd := SysConfig( "Mzdy:nDelPrcTyd"), NIL)

// naplnØn¡ kalend ýn¡ho a pracovn¡ho fondu ve dnech
	IF MsPrc_Mo ->dDatNast <= LastODate( Mzdy_Obd ->nRok, Mzdy_Obd ->nObdobi)
    dNAST := FirstODate( Mzdy_Obd ->nRok, Mzdy_Obd ->nObdobi)
	  IF Year( MsPrc_Mo ->dDatNast) == Mzdy_Obd ->nRok                         ;
		    .AND. Month( MsPrc_Mo ->dDatNast) == Mzdy_Obd ->nObdobi
	    dNAST := MsPrc_Mo ->dDatNast
		ENDIF
	ENDIF

	IF MsPrc_Mo ->dDatVyst >= FirstODate( Mzdy_Obd ->nRok, Mzdy_Obd ->nObdobi) ;
		 .OR. Empty( MsPrc_Mo ->dDatVyst)
    dVYST := LastODate( Mzdy_Obd ->nRok, Mzdy_Obd ->nObdobi)
	  IF Year( MsPrc_Mo ->dDatVyst) == Mzdy_Obd ->nRok                         ;
		    .AND. Month( MsPrc_Mo ->dDatVyst) == Mzdy_Obd ->nObdobi
	    dVYST := MsPrc_Mo ->dDatVyst
		ENDIF
	ENDIF

  IF !Empty( dNAST) .AND. !Empty( dVYST)
    Mzdy_Obd ->nFondKDDn  := D_DnyOdDo( dNAST, dVYST, "KALE")
    Mzdy_Obd ->nFondPDDn  := D_DnyOdDo( dNAST, dVYST, "PRAC")
    Mzdy_Obd ->nFondPDsDn := D_DnyOdDo( dNAST, dVYST, "PRAC")               ;
	                  		      +D_DnyOdDo( dNAST, dVYST, "SVAT")
  ENDIF

  DO CASE
  CASE C_TypDMZ ->cTypNapHoC == "BZ" .OR. C_TypDMZ ->cTypNapHoC == "BO"     ;
	  .OR. C_TypDMZ ->cTypNapHoC == "BV"
    Mzdy_Obd ->nDnyNemoKD += Mzdy ->nDnyFondKD
  ENDCASE

  DO CASE
  CASE C_TypDMZ ->cTypNapHoC == "OD"
    Mzdy_Obd ->nDnyOdprPD += Mzdy ->nDnyDoklad
    Mzdy_Obd ->nHodOdprac += Mzdy ->nHodDoklad

  CASE C_TypDMZ ->cTypNapHoC == "NA"
    Mzdy_Obd ->nDnyNahrPD += Mzdy ->nDnyDoklad
    Mzdy_Obd ->nHodNahrad += Mzdy ->nHodDoklad

  CASE C_TypDMZ ->cTypNapHoC == "SV"
    Mzdy_Obd ->nDnySvatPD += Mzdy ->nDnyDoklad
    Mzdy_Obd ->nHodSvatky += Mzdy ->nHodDoklad

  CASE Left( C_TypDMZ ->cTypNapHoC, 1) == "B"

    IF C_TypDMZ ->cTypNapHoC <> "BV"
      Mzdy_Obd ->nHodNemoc  += Mzdy ->nHodDoklad
		ENDIF

    IF C_TypDMZ ->cTypNapHoC == "BZ"
      Mzdy_Obd ->nHodNemZak += Mzdy ->nHodFondPD
		ENDIF

    IF C_TypDMZ ->cTypNapHoC == "BV"
      Mzdy_Obd ->nHodVoSoNe += Mzdy ->nHodFondKD
      Mzdy_Obd ->nDnyVNSoNe += Mzdy ->nDnyFondKD
      Mzdy_Obd ->nHodVNSoNe += Mzdy ->nHodFondKD
		ENDIF

  CASE C_TypDMZ ->cTypNapHoC == "XX"
    Mzdy_Obd ->nDnyNeodPD += Mzdy ->nDnyDoklad
    Mzdy_Obd ->nHodNeodpr += Mzdy ->nHodDoklad

  CASE C_TypDMZ ->cTypNapHoC == "XY"
//    Mzdy_Obd ->nDnyNeodPD += Mzdy ->nDnyDoklad
    Mzdy_Obd ->nHodNeodZa += Mzdy ->nHodDoklad

  CASE C_TypDMZ ->cTypNapHoC == "VO"
    Mzdy_Obd ->nDnyVoSoNe += Mzdy ->nDnyDoklad
    Mzdy_Obd ->nHodVoSoNe += Mzdy ->nHodFondKD

  CASE C_TypDMZ ->cTypNapHoC == "PR"
    Mzdy_Obd ->nHodPresc  += Mzdy ->nHodPresc

  CASE C_TypDMZ ->cTypNapHoC == "PS"
    Mzdy_Obd ->nHodPrescS += Mzdy ->nHodPrescS

  CASE C_TypDMZ ->cTypNapHoC == "RI"
    Mzdy_Obd ->nHodPripl  += Mzdy ->nHodPripl

  ENDCASE

	if Mzdy ->nDruhMzdy = 309
    Mzdy_Obd ->nDnyNahrPN += Mzdy ->nDnyDoklad
    Mzdy_Obd ->nHodNahrPN += Mzdy ->nHodDoklad
		Mzdy_Obd ->nNahradyPN += Mzdy ->nMzda
	endif

	IF Mzdy ->nDruhMzdy < 400
    Mzdy_Obd ->nDnyFondKD += Mzdy ->nDnyFondKD
    Mzdy_Obd ->nDnyFondPD += Mzdy ->nDnyFondPD
	ENDIF


//	IF DruhyMZD ->lVylouDoba
	Mzdy_Obd ->nDnyVylocD += Mzdy ->nDnyVylocD
	Mzdy_Obd ->nDnyVylDOD += Mzdy ->nDnyVylDOD
//	ENDIF

//         Mzdy_Obd ->nDnyNemoKD += Mzdy ->nDnyNemoKD

//         Mzdy_Obd ->nHodPresc  += Mzdy ->nHodPresc
//         Mzdy_Obd ->nHodPripl  += Mzdy ->nHodPripl

  Mzdy_Obd ->nHodFondPD := ( Mzdy_Obd ->nHodOdprac                     ;
	                             +Mzdy_Obd ->nHodNahrad                  ;
														    +Mzdy_Obd ->nHodSvatky                 ;
															   +Mzdy_Obd ->nHodNemoc                 ;
																  +Mzdy_Obd ->nHodNeodpr               ;
																	 +Mzdy_Obd ->nHodNeodZa)             ;
																- Mzdy_Obd ->nHodPresc

  Mzdy_Obd ->nHodFondUP := ( Mzdy_Obd ->nHodOdprac                     ;
	                             +Mzdy_Obd ->nHodNahrad                  ;
															   +Mzdy_Obd ->nHodNemZak                ;
																  +Mzdy_Obd ->nHodNeodpr)
//															- Mzdy_Obd ->nHodPresc

  IF MsPrc_Mo ->cTypTarMZD == "MESICNI " .AND. Mzdy_Obd ->nHodFondUP <> 0
		nX := D_DnyOdDo( dNAST, dVYST, "SVAT") * fPracDOBA( Mzdy_Obd ->cDelkPrDob)[3]
		Mzdy_Obd ->nHodFondUP := Mzdy_Obd ->nHodFondUP - nX
	ENDIF

  IF MsPrc_Mo ->cTypTarMZD <> "MESICNI " .AND. C_TypDMZ ->cTypNapHoC == "NZ"
		nX := D_DnyOdDo( Mzdy->dDatumOD, Mzdy->dDatumDO, "SVAT") * fPracDOBA( Mzdy_Obd ->cDelkPrDob)[3]
		Mzdy_Obd ->nHodFondUP := Mzdy_Obd ->nHodFondUP - nX
	ENDIF


//	IF( Mzdy_Obd ->nHodFondUP > Mzdy_Obd ->nFondPDHo                    ;
//         , Mzdy_Obd ->nHodFondUP := Mzdy_Obd ->nFondPDHo, NIL)

  Mzdy_Obd ->nHodFondKD := Mzdy_Obd ->nHodFondPD +Mzdy_Obd ->nHodVoSoNe

  DO CASE
  CASE C_TypDMZ ->cTypNapMzC == "ZA"
    Mzdy_Obd ->nMzdZaklad += Mzdy ->nMzda
  CASE C_TypDMZ ->cTypNapMzC == "PR" .OR. C_TypDMZ ->cTypNapMzC == "PS"
    Mzdy_Obd ->nMzdPripl  += Mzdy ->nMzda
  CASE C_TypDMZ ->cTypNapMzC == "OD"
    Mzdy_Obd ->nMzdOdmeny += Mzdy ->nMzda
  CASE C_TypDMZ ->cTypNapMzC == "NA"
    Mzdy_Obd ->nMzdNahrad += Mzdy ->nMzda
  CASE C_TypDMZ ->cTypNapMzC == "XX"
    Mzdy_Obd ->nMzdOstatn += Mzdy ->nMzda
  CASE Left( C_TypDMZ ->cTypNapMzC, 1) == "B"
    Mzdy_Obd ->nNemocCelk += Mzdy ->nMzda
  ENDCASE

	IF Mzdy ->nDruhMzdy == 944
    Mzdy_Obd ->nSupHmMzZa += Mzdy ->nMzda
  ENDIF

	IF DruhyMZD ->lNapMinMzd
		Mzdy_Obd ->nNapMinMzd += Mzdy ->nMzda
	ENDIF

	nX := fPracDOBA( Mzdy_Obd ->cDelkPrDob)[2]

	Mzdy_Obd ->nHodFondPD := Mzdy_Obd ->nFondPDDn * nX

	IF ( Mzdy_Obd ->nHodFondPD - Mzdy_Obd ->nHodNeodpr) > 0                   ;
		   .AND. Mzdy_Obd ->nMimoPrVzt == 0
		Mzdy_Obd ->nPrEvPZaFy := IF( Mzdy_Obd ->cDruPraVzt == "HLAVNI  "        ;
		                           .OR. Mzdy_Obd ->cDruPraVzt == "VEDLEJSI", 1, 0)
		IF nX == 0
		  Mzdy_Obd ->nPrEvPZaPr := Mzdy_Obd ->nHodOdprac/nDelPrcTyd
		  Mzdy_Obd ->nTmEvPZaPr := Mzdy_Obd ->nHodOdprac
		ELSE
		  Mzdy_Obd ->nPrEvPZaPr := nX/nDelPrcTyd
		  Mzdy_Obd ->nTmEvPZaPr := nX
		ENDIF
	ELSE
		Mzdy_Obd ->nPrEvPZaFy := 0
		Mzdy_Obd ->nPrEvPZaPr := 0
	ENDIF

	Mzdy_Obd ->nProcNemoc := (Mzdy_Obd ->nDnyNemoKD/Mzdy_Obd ->nFondKDDn) *100
	Mzdy_Obd ->nTmPocObd  := 1

RETURN( NIL)


STATIC FUNCTION GenSlevDan( nDMZ1, nDMZ2, nSleva)
  fGenSraz( nDMZ1, nSleva * (-1))
  fnapDoVp( nDMZ1, 0, 0, nSleva * (-1) )
  fGenSraz( nDMZ2, nSleva, .T.)
  fnapDoVp( nDMZ2, 0, 0, nSleva )

	DO CASE
	CASE nDMZ2 = 960
		Mzdy_Obd ->nDanUlevaC += nSleva
	CASE nDMZ2 = 961
		Mzdy_Obd ->nDanBonusC += nSleva
	OTHERWISE
		Mzdy_Obd ->nSlevaDanC += nSleva
	ENDCASE
RETURN( NIL)


STATIC FUNCTION ZakCelObd()
	LOCAL aZAKL := {0,0,0}
	LOCAL  nOldTAG := Mzdy_Obd ->( OrdSetFOCUS())
	LOCAL  nOldREC := Mzdy_Obd ->( Recno())
	LOCAL  cTAGsco, nRECsco, cSCOPE
	LOCAL  xKeyOD, xKeyDO

  cTAGsco := Mzdy_Obd  ->( OrdSetFOCUS())
  nRECsco := Mzdy_Obd  ->( Recno())
  cSCOPE  := Mzdy_Obd  ->( Sx_SetScope())

	xKeyOd := StrZero( MsPrc_Mz ->nOsCisPrac)              ;
				  	 +StrZero( MsPrc_Mz ->nPorPraVzt)            ;
	             +StrZero( nRok, 4) + "01"
	xKeyDo := StrZero( MsPrc_Mz ->nOsCisPrac)              ;
				  	 +StrZero( MsPrc_Mz ->nPorPraVzt)            ;
	             +StrZero( nRok, 4) +StrZero( nMesic-1, 2)

	nSUMAzakl := 0

  Mzdy_Obd ->( Set_rSCOPE( 2, xKeyOd,xKeyDo))
	 DO WHILE !Mzdy_Obd ->( Eof())
     aZakl[1] += Mzdy_Obd ->nZaklSocPo
     aZakl[2] += Mzdy_Obd ->nZaklZdrPo
     aZakl[3] += Mzdy_Obd ->nZakSocSto
	   Mzdy_Obd ->( dbSkip())
	 ENDDO
 	Mzdy_Obd ->( Clr_SCOPE())

  IF( !IsNIL( cSCOPE), Mzdy_Obd ->( Set_sSCOPE( cTAGsco, cSCOPE)), NIL)

	Mzdy_Obd ->( OrdSetFOCUS( cTAGsco))
	Mzdy_Obd ->( dbGoTo( nRECsco))

RETURN(aZAKL)

//test zda je n rok na slevu soci ln¡ho za zamØstnavatele

FUNCTION fNarSlevZam( nR, nO)
	LOCAL  xKey, cTAG
	LOCAL  lSleva := .F.
	LOCAL  dStart
	LOCAL  aLastObd := {}
	LOCAL  nOs, nRs

	xKey := StrZero( nR, 4)                               ;
	        +StrZero( MsPrc_Mo ->nOsCisPrac)              ;
			   	 +StrZero( MsPrc_Mo ->nPorPraVzt)

	aLastObd :=	PosDenOBD( nR, nO)
	cTAG := PrSmlDoh ->( OrdSetFOCUS(5))
	If PrSmlDoh ->( dbSeek(xKey))

		Do Case
		Case nO = 1
		  nRs := nR -1
			nOs := 10
		Case nO = 2
			nRs := nR -1
			nOs := 11
		Case nO = 3
			nRs := nR -1
			nOs := 12

		Otherwise
			nRs := nR
			nOs := nO - 3
		EndCase

		dStart := CtoD( "01." + StrZero(nOs,2)+ "."+ +StrZero( nRs, 4))

		If .not. MsPrc_Mo->lNeSlevSoc .and. .not. MsPrc_Mo->lZamMalRoz
  		Do Case
	  	Case Empty( MsPrc_Mo->dDatVyst) .and. Empty( MsPrc_Mo->dDatPredVy)
			  lSleva := .T.

		  Case .not. Empty( MsPrc_Mo->dDatVyst)
				if aLastObd[2] < MsPrc_Mo->dDatVyst
  			  lSleva := .T.
				endif

  		Case .not. Empty( MsPrc_Mo->dDatPredVy)
				if aLastObd[2] < MsPrc_Mo->dDatPredVy
  			  lSleva := .T.
				endif

		  EndCase
		EndIf
	EndIf

	PrSmlDoh ->( OrdSetFOCUS(cTAG))

RETURN( lSleva)

