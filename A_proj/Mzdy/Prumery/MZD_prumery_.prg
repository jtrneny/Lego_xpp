//////////////////////////////////////////////////////////////////////
//
//  MZD_prumery_vypocet.PRG
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"

#include "DRGres.Ch'
#include "XBP.Ch"

// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


CLASS MZD_prumery_vypocet FROM drgUsrClass

  METHOD  Init
//  METHOD  ItemMarked
//  METHOD  ItemSelected
//  METHOD  CardOfPrumMzd
  METHOD  drgDialogStart
//  METHOD  Destroy

/*
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT   ;   ::CardOfKmenMzd()
    CASE nEvent = xbeP_Keyboard
      Do Case
      Case mp1 = xbeK_INS   ;   ::CardOfKmenMzd(.T.)
      Case mp1 = xbeK_ENTER ;   ::CardOfKmenMzd(.F.)
      Case mp1 = xbeK_ESC   ;   PostAppEvent(xbeP_Close,nEvent,,oXbp)
      Otherwise
        RETURN .F.
      EndCase
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.
*/

ENDCLASS


*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD MZD_prumery_vypocet:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('msvprum',,,,,'msvprump')
  drgDBMS:open('msprc_mo',,,,,'msprc_mop')
  drgDBMS:open('druhymzd',,,,,'druhymzdp')
  drgDBMS:open('mzdyhd',,,,,'mzdyhdp')
  drgDBMS:open('mzdyit',,,,,'mzdyitp')


  mzdyitp ->( dbSetRelation( 'druhymzdp'  , ;
                   { || mzdyitp->ndruhmzdy } , ;
                       'mzdyitp->ndruhmzdy' ) )
  mzdyitp ->( dbSkip( 0))



RETURN self


METHOD MZD_prumery_vypocet:drgDialogStart(drgDialog)

RETURN self


*****************************************************************
* Pøi pohybu v seznamu
*****************************************************************
/*
METHOD MZD_prumery_vypocet:ItemMarked()

RETURN SELF
*/

/*
METHOD MZD_prumery_SCR:ItemSelected()

RETURN SELF
*/



/*METHOD MZD_prumery_SCR:destroy()
 ::drgUsrClass:destroy()

RETURN SELF */


//ÄÄÄÄÄÄÄÄÄÄÄÄINDIVIDUµLNÖ VíPO¬ET PRUM·RUÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

//# Include  '..\MZDY.Ch'
//# Include  '..\MZDDef_.Ch'

 /*
STATIC  anCtvrt  := { { 1, 2, 3}, { 4, 5, 6}, { 7, 8, 9}, { 10, 11, 12} }
STATIC  anObdobi := { { 1, 12}, { 2, 1}, { 3, 2}, { 4, 3}, { 5, 4}, { 6, 5}, { 7, 6}, { 8, 7}, { 9, 8}, { 10, 9}, { 11, 10}, { 12, 11} }
STATIC  nRYO_s
STATIC  aAlgHOD, aAlgDNU, aAlgODM, aZAOKnem
STATIC  nPracDobaH, nPracDobaD
STATIC  nPracDoMsH, nPracDoObH
STATIC  nPraDoMsTH, nPraDobaTH
STATIC  nPracDoMsD, nPracDoObD
STATIC  nPrcDobaHz, nPrcDobaDz
STATIC  xOBDkey, xCTVRTkey, nCtvrt, nVybRok
STATIC         nRokNemOD, nRokNemDO, nObdNemOD, nObdNemDO
STATIC  nPROCsocZ, nPROCzdrZ, nKoefDNmes, nKoefHOmes, nKoefHM
STATIC  nACTrok, nACTobd
STATIC  lNEWprum
STATIC  aDMZodm
STATIC  lINIstat
STATIC  pA


FUNCTION VYPpru_GET( nMOD)
        LOCAL  nOldError := DosError( 2001), nCursor := SetCursor( 1)
        LOCAL  nRecMs    := MsPrc_Mz ->( RecNo()), nPriREC := 0
//        LOCAL  nTAGms    := MsPrc ->( ORDsetFOCUS(1))
        LOCAL  N, nT, nL, nB, nR
        LOCAL  cC, cScreen := SaveScreen()
        LOCAL  aX, axEdit, GetList := {}
        LOCAL  lNewREC
        LOCAL  cTAGNo, xKEY
        LOCAL  cX, cTMobd

        Dc_DCOPen( { 'Mzdy, 1', 'DruhyMZD, 1', 'MsPrc_Mz, 1', 'MsPrc_Mo, 1'       ;
                    , 'Mzdy_Obd, 1', 'MzKum_Ro, 1' })

        Mzdy ->( dbSetRelation( 'DruhyMZD'  , ;
                   { || Mzdy ->nDruhMzdy } , ;
                       'Mzdy ->nDruhMzdy' ) )
  Mzdy ->( dbSkip( 0))

        lINIstat := .T.

        DO CASE
        CASE nMOD == K_INS .OR. nMOD == K_ENTER
           lNewREC := ( nMOD == K_INS)
          IF lNewREC
                        cTMobd := ACT_OBDn()
                   fVYPprumer( lNewREC,,, cTMobd)
                ELSE
                  cTMobd := StrZero( MsVPrum ->nRok, 4) + StrZero( MsVPrum ->nObdobi, 2)
                        IF cTMobd = "00"
                                BOX_WARING( "Je potýeba nejprve d t INSERT - novì vìpoŸet...")
                                RETURN
                        ELSE
                          INcSTATic( .F., cTMobd)
                        ENDIF
                ENDIF

           aX := Cards_RES( 'Prumery.Sc1', .T., .T., .T. )
           axEdit := Cards ->axCards

    aEval( axEdit, { |X| X[ 4] := DBGetVal( X[ 5]) } )

    IF aAlgDNU[1] < 4
                    axEdit[26,8] := .F.
                ENDIF

           Cards_GET( axEdit, { || VypPRU_VLD( GetList) }, lNewREC, GetList, nT, nL)

           If ReadModal( GetList,,.T., { || VYPPRU_DYN( GETLIST)})
             If( ReplRec( 'MsVPrum'))
                      aEval( GetList, { |X,M| DBPutVal( axEdit[ M, 5], X:VarGet())})

                     IF Box_YesNo( "Ulo§it vypoŸten‚ pr…mØry i do kmenov‚ho souboru ") == 1
                                        WRT_MSprum()
                    ENDIF

                      MsVPrum ->( SX_UnLock())
                            ScreenBROW( 1):RefreshALL()
                    Else
                            BOX_WARING( "Nelze ulo§it zmØny, BLOKOVµNO u§ivatelem ...")
             EndIf
           EndIf

        CASE nMOD == K_DEL
          cTMobd := StrZero( MsVPrum ->nRok) + StrZero( MsVPrum ->nObdobi, 2)
          INcSTATic( .F., cTMobd)
          IF Box_YesNo( "Zruçit vypoŸten‚ pr…mØry za obdob¡ " + StrZero( MsVPrum ->nObdobi) +"/" +StrZero( MsVPrum ->nRok) ) == 1
            cTAGNo := MsVPrum ->( ORDsetFOCUS(3))
             xKEY   := cTMobd +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt)
                  IF( MsVPrum ->( dbSeek( xKEY)), DelREC( "MsVPrum"), NIL)
      MsVPrum ->( ORDsetFOCUS( cTAGNo ))
          ENDIF
        ENDCASE

  DruhyMZD ->( dbClearRelations())
        MsVPrum ->( SET_sSCOPE( 2, StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt)))
        MsPrc_Mz ->( dbGoTo( nRecMs))

  ( DosError( nOldError), RestScreen( ,,,, cScreen), SetCursor( nCursor) )

RETURN( NIL)


STATIC FUNCTION VypPRU_VLD( GetList)
        LOCAL  N, nCursor := SetCursor( 0)
        LOCAL  cKEYs
        LOCAL  xVAL, aX := { .F., NIL }
        LOCAL  lOk     := .T.
        LOCAL  O := GetACTIVE()
        LOCAL  lDone
        LOCAL  lIsSpec := .F., xSeek, xRet, nOldArea, cFile, cItem, cItemV, nTagNo

        ( N := O:SubSCRIPT[ 1], xVAL := O:VarGET() )

        DO CASE
        CASE( N ==  11 .OR. N ==  15 .OR. N ==  19 )
        ENDCASE

//        If( aX[ 1],( O:VarPut( aX[ 2]), O:Display()), Nil)
//        ( Cards_Whn( O), SetCursor( nCursor) )

RETURN( lOK)


STATIC FUNCTION VYPPRU_DYN( O)
        LOCAL  xN, aX, nVAL

//        fVYPprprac()

//  ----- hodinovì pr…mØr ----------------------------------------------------
        xN := Mh_RoundNumb( ( O[ 20]:VarGet() +O[ 21]:VarGet()) /O[ 22]:VarGet()  ;
                              , aAlgHOD[2])
         O[23]:VARPUT( Val( TransForm( xN, "999.99")))

         O[24]:VARPUT( O[ 20]:VarGet())
         O[25]:VARPUT( O[ 21]:VarGet())

//  ----- denn¡ pr…mØr -------------------------------------------------------
  xN :=  VypDENpru( O[ 23]:VarGet(), 0, O[ 26]:VarGet()                     ;
                            ,O[ 24]:VarGet(), O[ 25]:VarGet())
  nVAL := Val( TransForm( xN, "9999.99"))
  O[27]:VARPUT( Val( TransForm( xN, "9999.99")))


  aX := F_VypPrumNem( O[ 40]:VarGet(), O[ 41]:VarGet(), O[ 42]:VarGet(), nACTrok)

//  ----- nemocensk  pr…mØr --------------------------------------------------
         O[43]:VARPUT( Val( TransForm( aX[1], "999999.99")))
         O[44]:VARPUT( Val( TransForm( aX[5], "999.99")))

         O[45]:VARPUT( Val( TransForm( aX[8], "999")))
         O[46]:VARPUT( Val( TransForm( aX[3], "999")))
         O[47]:VARPUT( Val( TransForm( aX[6], "999")))
         O[48]:VARPUT( Val( TransForm( aX[4], "999")))
         O[49]:VARPUT( Val( TransForm( aX[9], "999")))

         ( O[20]:Display(), O[21]:Display(), O[23]:Display())
  IF aAlgDNU[1] < 4
    @ 13, 25 SAY "(     " + Str( O[ 23]:VarGet()) + " *      " + Str( nPrcDobaHz) + ")           = "  Color "W/B"
           ( O[27]:Display())
        ELSE
           ( O[24]:Display(), O[25]:Display(), O[26]:Display(), O[27]:Display())
        ENDIF
         ( O[43]:Display(), O[44]:Display(), O[45]:Display(), O[46]:Display())
         ( O[47]:Display(), O[48]:Display(), O[49]:Display())

RETURN( NIL)


FUNCTION VYP_PRUget()
  Local  cFile, cInd1, pomI, pomD, cDbf, cKey
        LOCAL  nPosDenOBD
  Local  N, nKey, nTypBUT := 2, nPosIN, nCards
        Local  cColor, cC, cBEG
        Local  aCards
        Local  lDone   := .T.
        Local  cScreen := SaveScreen()
        LOCAL  nTypZprac := 1
        LOCAL  aTYPzpr
        LOCAL  cCtvrt, nX

        nX := ACT_OBDon()

        aTYPzpr := { { "za obdob¡     ", "... vìpoŸet pr…mØr… pro obdob¡ " +ACTObdobi() +" ... "  } ;
                                                  ,{ "za obdob¡     ", "... vìpoŸet pr…mØr… za obdob¡ " +ACTObdobi() +" ... "  };
                                                        ,{ "vìbØr obdob¡  ", "... vìpoŸet pr…mØr… za vybran  obdob¡ ... " }}

        aCards := Cards_RES( 'PrumeryH.Sc1', .T., .T.)
        BOX_DispHotKEYS( Cards ->cHotKEYS)
        pA := Cards ->axCards
        aEval( pA, { |X| ( X.Row += aCards[ 1], X.Col += aCards[ 2] ) } )

        cC := 'Hromadn‚ zpracov n¡ pr…mØr…'
        @ pA[ 1].Row, pA[ 1].Col Say PadC( cC, pA[ 1].Picture) Color 'W+/B'

//  cC := Str( MsPrc_Mz ->nOsCisPrac, 5) +" - " +Left( MsPrc_Mz ->cPracovnik, 20)
        cC := " ... za vçechny pracovn¡ky ... "
  BOX_MOVEIN( cC, 5, pA[ 3].Row, pA[ 3].Col, 'GR+/W', pA[ 3].Picture )

        BOX_BUTT( { pA[ 5].Row, pA[ 5].Col, 23 }, aTypZPR[nTypZprac,1], .T. )
        BOX_BUTT( { pA[ 6].Row, pA[ 6].Col,  7 }, 'Ano', .F. )
        BOX_BUTT( { pA[ 7].Row, pA[ 7].Col,  7 }, 'Ne ', .T. )

//                If( !UcetSYS ->lZAVREN, cBEG := ::cUzvBEG, ( cC := UcetSYS ->cOBDOBI, cBEG := ::cUzvEXIS))
//                cBEG := IF( nTypISOZ <> 0, StrTran( cBEG, "X", Str( nTypISOZ, 1)), cBEG)

        BOX_MOVEIN( aTypZPR[nTypZprac,2],, pA[ 2].Row, pA[ 2].Col, 'W+/W', pA[ 2].Picture)

//        BOX_MOVEIN( cC, 5, pA[ 3].Row, pA[ 3].Col, 'GR+/W', pA[ 3].Picture )

        Do While lDone
          nKey := InKey( 0)

          Do Case
    Case( nKey == K_SPACE )
                        If( nTypZprac <= 2, nTypZprac++, nTypZprac := 1)
                  BOX_BUTT( { pA[ 5].Row, pA[ 5].Col, 23 }, aTypZPR[nTypZprac,1], .T. )
            BOX_MOVEIN( aTypZPR[nTypZprac,2],, pA[ 2].Row, pA[ 2].Col, 'W+/W', pA[ 2].Picture)

                        IF nTypZprac <= 3
        cC := Str( MsPrc_Mz ->nOsCisPrac, 5) +" - " +Left( MsPrc_Mz ->cPracovnik, 20)
                        ENDIF
      BOX_MOVEIN( cC, 5, pA[ 3].Row, pA[ 3].Col, 'GR+/W', pA[ 3].Picture )

                Case( nKey == K_TAB .or. nKey == K_RIGHT .or. nKey == K_DOWN )
                  nTypBUT := If( nTypBUT +1  > 2, 1, nTypBUT +1)
                Case( nKey == K_LEFT .or. nKey == K_UP    )
                  nTypBUT := If( nTypBUT    == 1, 2, nTypBUT -1)
          Case( Chr( nKey) $ 'Nn' .or. ( nKey == K_ENTER .and. nTypBUT == 2 ))
                  lDone := .F.
          Case( Chr( nKey) $ 'Aa' .or. ( nKey == K_ENTER .and. nTypBUT == 1 ))
      BOX_BUTT( { pA[ 6].Row, pA[ 6].Col,  7 }, 'Ano', .F. )
      BOX_BUTT( { pA[ 7].Row, pA[ 7].Col,  7 }, 'Ne ', .F. )
                        DO CASE
                        CASE nTypZprac == 1        ;       VYP_PruHro()
                        CASE nTypZprac == 2        ;       VYP_PruHro(1)
                        CASE nTypZprac == 3        ;                   VYP_PruHro(2)
                        ENDCASE

                        lDone := .F.
//                        UzavMI_NEW(), UzavIS_NEW( nTypZprac) )
//                                        lDone := !lUzvOK
          Case( nKey == K_ESC   ) ;  lDone := .F.
    EndCase

          BOX_BUTT( { pA[ 6].Row, pA[ 6].Col, 7 }, 'Ano', ( nTypBUT == 1))
          BOX_BUTT( { pA[ 7].Row, pA[ 7].Col, 7 }, 'Ne ', ( nTypBUT == 2))
  EndDo

  RestScreen( ,,,, cScreen)

RETURN( NIL)


FUNCTION VYP_PruHro( nVYBobd, lNEWobd, pX)    // vìpoŸet pr…mØr… hromadnì za Ÿtvrtlet¡
        LOCAL  xKEY, cOBDnz, lOK
        LOCAL  cC
        LOCAL  nKeyCNT := 0, nKeyNO  := 0
        LOCAL  nOLDrec, n
        LOCAL  nRECold
        LOCAL  nTAGold

        DEFAULT nVYBobd TO  0
        DEFAULT lNEWobd TO .F.

        Dc_DCOPen( { 'Mzdy, 1', 'DruhyMZD, 1', 'MsPrc_Mz, 1'                     ;
                     , 'MsPrc_Mo, 1', 'MzKum_Ro, 1', 'MsVPrum, 1' })

        Mzdy ->( dbSetRelation( 'DruhyMZD'  , ;
                   { || Mzdy ->nDruhMzdy } , ;
                       'Mzdy ->nDruhMzdy' ) )
  Mzdy ->( dbSkip( 0))

        lINIstat := .T.
        IF( !IsNIL( pX), pA := pX, NIL )

        nRECold := MsPrc_Mz ->( Recno())
        nTAGold := MsPrc_Mz ->( OrdSetFOCUS())

        nKeyCNT := MsPrc_Mz ->( M6_CountFOR( !MsPrc_Mz ->( Deleted())))

        IF lNEWobd
          cOBDnz := StrZero( UcetSys ->nROK) + StrZero( UcetSys ->nOBDOBI)
    cC := "... vìpoŸet pr…mØr… na PP a ND ..."
    BOX_MOVEIN( cC, 5, pA[ 3].Row, pA[ 3].Col, 'GR+/W', pA[ 3].Picture )
        ELSE
          cOBDnz := StrZero( UcetSys ->nROK) + StrZero( UcetSys ->nOBDOBI)
        ENDIF

        MsPrc_Mz ->( dbGoTop())
        DO WHILE !MsPrc_Mz ->( Eof())
//    cC := Str( MsPrc_Mz ->nOsCisPrac, 5) +" - " +Left( MsPrc_Mz ->cPracovnik, 20)
          TempZpr( nKeyCNT, nKeyNO++, pA)
                xKEY := Left( cOBDnz, 4) + StrZero( CTVRTzOBDn( Val( Right( cOBDnz, 2))), 1)   ;
                                                 +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt)

                lOK := .F.
                DO CASE
                CASE Empty( MsPrc_Mz ->dDatVyst)                                         ;
                            .OR. Year( MsPrc_Mz ->dDatVyst) > Val( Left( cOBDnz, 4))
                        lOK := .T.

                CASE ( Year( MsPrc_Mz ->dDatVyst)   ) = Val( Left( cOBDnz, 4))
                        lOK := ( Month( MsPrc_Mz ->dDatVyst) + 1) >= Val( Right( cOBDnz, 2))

                CASE ( Year( MsPrc_Mz ->dDatVyst) +1) = Val( Left( cOBDnz, 4))           ;
                                         .AND. Val( Right( cOBDnz, 2)) = 1                                 ;
                                                .AND. Month( MsPrc_Mz ->dDatVyst) = 12
                        lOK := .T.
                ENDCASE

          IF lOK
                        nOLDrec := MsPrc_Mz ->( Recno())
            IF !fVYPprumer( .T.,, .T., cOBDnz)
                          IF( MsVPrum ->( dbSeek( xKEY)), DelREC( "MsVPrum"), NIL)
                        ENDIF
                        MsPrc_Mz ->( dbGoTo( nOLDrec))
                ELSE
                        IF MsVPrum ->( dbSeek( xKEY))
                                DelREC( "MsVPrum")
                        ENDIF
          ENDIF

    MsPrc_Mz ->( dbSkip())
  ENDDO

        MsPrc_Mz ->( OrdSetFOCUS( nTAGold))
        MsPrc_Mz ->( dbGoTo( nRECold))

RETURN( NIL)


FUNCTION fVYPprumer( lNewGen, lPRAVd, lEXT, cOBDnz, nTYP)
  LOCAL  cALIAS
  LOCAL  nX, cX, n
  LOCAL  aRET

  DEFAULT lPRAVd TO .F.
  DEFAULT lEXT   TO .F.
  DEFAULT nTYP   TO  1   // typ vìpoŸtu 1 .. za Ÿtvrtlet¡, 2 .. za obdob¡

  Dc_DCOPen( { 'Mzdy_Obd, 1', 'Mzdy, 1'})

  cALIAS   := IF( lPRAVd, "MsPrc_Mp", "MsPrc_Mz")
  lNewPrum := lNewGen

  INcSTATic( lPRAVD, cOBDnz)

  aRET := IF( !lPRAVD, fPRACmzdu( cALIAS), {.T.,.F.})

        DO CASE
  CASE aRET[1] .OR. aRET[2]
                fZalozREC( cALIAS)
    IF( aRET[1], fNAPprumPP( lPRAVD, cALIAS), NIL)
    IF( aRET[2], fNAPprumNM( lPRAVD, cALIAS), NIL)
    DcrUnlock( "MsVPrum")
    fVYPprprac()
    IF( lPRAVd .OR. lEXT, WRT_MSprum( cALIAS), NIL)

  CASE ( !aRET[1] .AND. !aRET[2] .AND. lNewGen )
                fZalozREC( cALIAS)
    DcrUnlock( "MsVPrum")
    fVYPprprac()
    IF( lPRAVd .OR. lEXT, WRT_MSprum( cALIAS), NIL)

  ENDCASE

RETURN( aRET[1] .OR. aRET[1])


STATIC FUNCTION fNAPprumPP( lPRAVd, cALIAS)
  LOCAL  xKEY, n, cX, nLen, xKEYcp
  LOCAL  cRokHL_, nPocM, cVybObd := ""
  LOCAL  lOdp_POL
  LOCAL  nDnyFND
  LOCAL  nOldArea
  LOCAL  anSUMo[6,2]
  LOCAL  lSVATKY
//  LOCAL  nPocMesPr := SysConfig( "Mzdy:nPocMesPr")

  DEFAULT lPRAVd TO .F.
  DEFAULT cALIAS TO "MsPrc_Mz"

  lSVATKY := ( cALIAS) ->cTypTarMZD == "MESICNI "
  nDnyFND := F_PrumFND( lSVATKY)

  xKEYcp := StrZero( ( cALIAS) ->nOsCisPrac) +StrZero( ( cALIAS) ->nPorPraVzt)
  xKEY   := xCTVRTkey +xKEYcp

  nPocM     := 3
//  nPocMesPr := IF( nPocMesPr = 0, nPocM, nPocMesPr)

//        MsVPrum ->nAlgCelOdm := IF( ( cALIAS) ->nAlgCelOdm <> 0 ;
//                                    , ( cALIAS) ->nAlgCelOdm, aAlgODM[3])

//        MsVPrum ->nPocMesPr  :=      IF( ( cALIAS) ->nAlgCelOdm <> 0 ;
//                                    , ( cALIAS) ->nPocMesPr, nPocMesPr)

        IF !IsNil( aDMZodm)
                IF !Empty( aDMZodm)
                  MsVPrum ->nAlgCelOdm := aDMZodm[1,2]
            MsVPrum ->nPocMesPr  := aDMZodm[1,3]
                ENDIF
        ENDIF

  IF( MsVPrum ->nAlgCelOdm <> 0, CELodm( xKEYcp, aDMZodm), NIL)

//    MsVPrum ->nDOdpra_NP := nDayForNP

// novinka pro nekolik algoritmu vypoctu prumeru
  MsVPrum ->nDFondu_PP := nDnyFND
  MsVPrum ->nHFondu_PP := nDnyFND * IF( aAlgHOD[1] = 2, nPracDobaH, ;
                  IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH ;
                                                                                  , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))
  MsVPrum ->nDFondu_NA := nDnyFND
  MsVPrum ->nHFondu_NA := nDnyFND * IF( aAlgHOD[1] = 2, nPracDobaH, ;
                  IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH ;
                                                                                  , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))
  MsVPrum ->nHFondu_OO := nDnyFND * IF( aAlgODM[1] = 2, nPracDobaH, ;
                  IF( aAlgODM[1] = 3 .and. nPracDoObH = 0, nPracDobaH  ;
                                                                                  , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))

  MsVPrum ->nDOdpra_PP := 0
  MsVPrum ->nHOdpra_PP := 0
  MsVPrum ->nDnyNap_NA := 0
  MsVPrum ->nHodNap_NA := 0
  MsVPrum ->nKcsODMEN  := 0

  IF !lPRAVd
    FOR n := 1 TO 3
      anSUMo[1,1] := anSUMo[2,1] := anSUMo[3,1] := anSUMo[4,1] := anSUMo[5,1] := anSUMo[6,1] := 0
      anSUMo[1,2] := anSUMo[2,2] := anSUMo[3,2] := anSUMo[4,2] := anSUMo[5,2] := anSUMo[6,2] := 0

      xKey := StrZero( nVybRok, 4) + StrZero( anCtvrt[nCtvrt, n], 2)                                ;
                           +StrZero( ( cALIAS) ->nOsCisPrac) +StrZero( ( cALIAS) ->nPorPraVzt)

      anSUMo[1,1] := IF( aAlgDNU[1] = 4, F_PRACDNY( nVybRok, anCtvrt[nCtvrt, n]), 0)
      anSUMo[2,1] := anSUMo[1,1]  * IF( aAlgHOD[1] = 2, nPracDobaH                                      ;
                    , IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH    ;
                                                                                      , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))

      anSUMo[1,2] := IF( aAlgDNU[1] = 4, F_PRACDNY( nVybRok, anCtvrt[nCtvrt, n]), 0)
      anSUMo[2,2] := anSUMo[1,2]  * IF( aAlgHOD[1] = 2, nPracDobaH                                      ;
                    , IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH    ;
                                                                                      , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))

      nOldArea := Select()
      Mzdy ->( SET_sSCOPE( 8, xKey))
       DO WHILE !Mzdy ->( Eof())
                                 IF ( DruhyMZD->nPrNapPpDn+DruhyMZD->nPrNapPpHo+DruhyMZD->nPrNapPpMz  ;
                                             +DruhyMZD->nPrNapNaDn+DruhyMZD->nPrNapNaHo+DruhyMZD->nPrNapNaMz  ;
                                                         +DruhyMZD->nPrNapRoMz+DruhyMZD->P_KcsPOHSL ) <> 0

           lOdp_POL  := IF( DruhyMZD ->P_KcsPOHSL = 1, .T., .F.)

           MsVPrum ->nHFondu_OO -= IF( lOdp_POL, Mzdy ->nHodDoklad, 0)
           anSUMo[1,1] -= IF( lOdp_POL .AND. aAlgDNU[1] = 4, Mzdy ->nDnyDoklad, 0)
           anSUMo[2,1] -= IF( lOdp_POL .AND. ( aAlgHOD[1] = 2 .OR. aAlgHOD[1] = 3), Mzdy ->nHodDoklad, 0)

           MsVPrum ->nDOdpra_PP += Mzdy ->nDnyDoklad * DruhyMZD->nPrNapPpDn
           MsVPrum ->nDnyNap_PP += Mzdy ->nDnyDoklad * DruhyMZD->nPrNapPpDn
           MsVPrum ->nHOdpra_PP += Mzdy ->nHodDoklad * DruhyMZD->nPrNapPpHo
           MsVPrum ->nHodNap_PP += Mzdy ->nHodDoklad * DruhyMZD->nPrNapPpHo
           MsVPrum ->nKcsPRACP  += Mzdy ->nMzda      * DruhyMZD->nPrNapPpMz
           MsVPrum ->nMzdNap_PP += Mzdy ->nMzda      * DruhyMZD->nPrNapPpMz
           anSUMo[1,1]          += IF(aAlgDNU[1] <> 4,                       ;
                                                        Mzdy->nDnyDoklad*DruhyMZD->nPrNapPpDn, 0)
           anSUMo[2,1]          += IF( aAlgHOD[1] = 1,                       ;
                                                                          Mzdy->nHodDoklad*DruhyMZD->nPrNapPpHo, 0)
           anSUMo[3,1]          += Mzdy ->nMzda      * DruhyMZD->nPrNapPpMz

           MsVPrum ->nDnyNap_NA += Mzdy ->nDnyDoklad * DruhyMZD->nPrNapNaDn
           MsVPrum ->nHodNap_NA += Mzdy ->nHodDoklad * DruhyMZD->nPrNapNaHo
           MsVPrum ->nMzdNap_NA += Mzdy ->nMzda      * DruhyMZD->nPrNapNaMz
           anSUMo[1,2]          += IF(aAlgDNU[1] <> 4,                       ;
                                                        Mzdy->nDnyDoklad*DruhyMZD->nPrNapNaDn, 0)
           anSUMo[2,2]          += IF( aAlgHOD[1] = 1,                       ;
                                                                          Mzdy->nHodDoklad*DruhyMZD->nPrNapNaHo, 0)
           anSUMo[3,2]          += Mzdy ->nMzda      * DruhyMZD->nPrNapNaMz

           MsVPrum ->nKcsODMEN  += ( Mzdy ->nMzda*DruhyMZD->nPrNapRoMz / 12 );
                                                                     * MsVPrum ->nPocMesPr //

                 MsVPrum ->nHOD_presc += Mzdy ->nHodPresc
                 MsVPrum ->nHOD_presc += Mzdy ->nHodPrescS
         ENDIF

                                 IF Mzdy ->nDruhMzdy = 960
                                   MsVPrum ->nDanUleva += Mzdy ->nMzda
                                 ENDIF

         Mzdy ->( dbSkip())
       ENDDO
      Mzdy ->( CLR_sSCOPE( 1, nOldArea))

      cX := Padl( AllTrim( Str( n)), 2, "0")
      MsVPrum ->&( "nDNY_PP"+cX) := anSUMo[1,1]
      MsVPrum ->&( "nHOD_PP"+cX) := anSUMo[2,1]
      MsVPrum ->&( "nKC_PP" +cX) := anSUMo[3,1]
      MsVPrum ->&( "nDNY_NA"+cX) := anSUMo[1,2]
      MsVPrum ->&( "nHOD_NA"+cX) := anSUMo[2,2]
      MsVPrum ->&( "nMZD_NA"+cX) := anSUMo[3,2]
    NEXT

    MsVPrum ->nDNY_PPSUM := MsVPrum ->nDNY_PP01 +MsVPrum ->nDNY_PP02 ;
                                   +MsVPrum ->nDNY_PP03
    MsVPrum ->nHOD_PPSUM := MsVPrum ->nHOD_PP01 +MsVPrum ->nHOD_PP02 ;
                                   +MsVPrum ->nHOD_PP03
    MsVPrum ->nKC_PPSUM  := MsVPrum ->nKC_PP01 +MsVPrum ->nKC_PP02   ;
                                          +MsVPrum ->nKC_PP03

    MsVPrum ->nDNY_NASUM := MsVPrum ->nDNY_NA01 +MsVPrum ->nDNY_NA02 ;
                                   +MsVPrum ->nDNY_NA03
    MsVPrum ->nHOD_NASUM := MsVPrum ->nHOD_NA01 +MsVPrum ->nHOD_NA02 ;
                                   +MsVPrum ->nHOD_NA03
    MsVPrum ->nMZD_NASUM  := MsVPrum ->nMZD_NA01 +MsVPrum ->nMZD_NA02   ;
                                          +MsVPrum ->nMZD_NA03

  ELSE
    MsVPrum ->nDNY_PPSUM := nDnyFND
    MsVPrum ->nHOD_PPSUM := nPracDoMsH *nDnyFND
    MsVPrum ->nDNY_NASUM := nDnyFND
    MsVPrum ->nHOD_NASUM := nPracDoMsH *nDnyFND

    DO CASE
    CASE MsPrc_Mp ->cTypTarMzd == "MESICNI "
      MsVPrum ->nKC_PPSUM := MsPrc_Mp ->nTarSazMes * nPocM
      MsVPrum ->nMZD_NASUM := MsPrc_Mp ->nTarSazMes * nPocM

    CASE MsPrc_Mp ->cTypTarMzd == "CASOVA  "
      MsVPrum ->nKC_PPSUM := MsPrc_Mp ->nTarSazHod *MsVPrum ->nHOD_PPSUM
      MsVPrum ->nMZD_NASUM := MsPrc_Mp ->nTarSazHod *MsVPrum ->nHOD_NASUM

    CASE MsPrc_Mp ->nTarSazHod <> 0
      MsVPrum ->nKC_PPSUM := MsPrc_Mp ->nTarSazHod *MsVPrum ->nHOD_PPSUM
      MsVPrum ->nMZD_NASUM := MsPrc_Mp ->nTarSazHod *MsVPrum ->nHOD_NASUM

    CASE MsPrc_Mp ->nTarSazMes <> 0
      MsVPrum ->nKC_PPSUM := MsPrc_Mp ->nTarSazMes * nPocM
      MsVPrum ->nMZD_NASUM := MsPrc_Mp ->nTarSazMes * nPocM
    ENDCASE

    MsVPrum ->nKC_PPSUM += IF( MsPrc_Mp ->nSazPrePr <> 0,                             ;
    Round( MsVPrum ->nKC_PPSUM * ( MsPrc_Mp ->nSazPrePr/100), 0), 0)
    MsVPrum ->nKC_PPSUM += IF( MsPrc_Mp ->nSazOsoOh <> 0, MsPrc_Mp ->nSazOsoOh, 0)
    MsVPrum ->nMZD_NASUM += IF( MsPrc_Mp ->nSazPrePr <> 0,                             ;
    Round( MsVPrum ->nMZD_NASUM * ( MsPrc_Mp ->nSazPrePr/100), 0), 0)
    MsVPrum ->nMZD_NASUM += IF( MsPrc_Mp ->nSazOsoOh <> 0, MsPrc_Mp ->nSazOsoOh, 0)
  ENDIF


RETURN( NIL)


STATIC FUNCTION fNAPprumNM( lPRAVd, cALIAS)
  LOCAL  xKEYod, xKEYdo, n, cX, nLen, xKEYcp
  LOCAL  cRokHL_, nPocM, cVybObd := ""
  LOCAL  lNem_KCS, lNem_DNY, lDan_NP
  LOCAL  nDnyFND
  LOCAL  nOldArea
  LOCAL  anSUMo[6]
  LOCAL  lODPOCnem := .T.
  LOCAL  lSVATKY
//  LOCAL  nPocMesPr := SysConfig( "Mzdy:nPocMesPr")

  DEFAULT lPRAVd TO .F.
  DEFAULT cALIAS TO "MsPrc_Mz"

  lSVATKY := ( cALIAS) ->cTypTarMZD == "MESICNI "
  nDnyFND := F_PrumFND( lSVATKY)

  xKEYcp := StrZero( ( cALIAS) ->nOsCisPrac) +StrZero( ( cALIAS) ->nPorPraVzt)

  MsVPrum ->nKcsNEMOC  := 0
  MsVPrum ->nKcsDAN_NP := 0

  fKalDnyNM()

  IF !lPRAVd
    anSUMo[1] := anSUMo[2] := anSUMo[3] := anSUMo[4] := anSUMo[5] := anSUMo[6] := 0

    xKEYod := xKEYcp +StrZero( nRokNemOD, 4) +StrZero( nObdNemOD, 2)
    xKEYdo := xKEYcp +StrZero( nRokNemDO, 4) +StrZero( nObdNemDO, 2)

    nOldArea := Select()
    Mzdy ->( SET_rSCOPE( 18, xKEYod, xKEYdo))
     DO WHILE !Mzdy ->( Eof())
       IF ( DruhyMZD ->P_KcsNEMOC +DruhyMZD ->P_KcsHOPRP) != 0
         lNem_KCS  := IF( DruhyMZD ->P_KcsNEMOC = 1, .T., .F.)
         lNem_DNY  := IF( DruhyMZD ->P_KcsHOPRP = 1, .T., .F.)
         lDan_NP   := IF( Mzdy ->nDruhMzdy = 500 .OR. Mzdy ->nDruhMzdy = 501, .T., .F.)
// byl vybr n tento mØs¡c tak‚ pro nemocensk‚ pojiçtØn¡ ?
         IF !Empty( MsVPrum ->dDatVyst)                                             ;
                                            .AND. Month( MsVPrum ->dDatVyst) < Mzdy ->nObdobi                      ;
                                              .AND. Year( MsVPrum ->dDatVyst) <= Mzdy ->nRok
           lODPOCnem := .F.
         ENDIF

         IF lODPOCnem
           MsVPrum ->nDOdpra_NP -= IF( lNem_DNY, Mzdy ->nDnyDoklad, 0)
                       anSUMo[5]            -= IF( lNem_DNY, Mzdy ->nDnyDoklad, 0)
         ENDIF

         IF lNem_KCS
           MsVPrum ->nKcsNEMOC  += Mzdy ->nMzda
                                   anSUMo[6]            += Mzdy ->nMzda

// naŸteme si daå pro NP pro pý¡sluçnì mØs¡c
           MsVPrum ->nKcsDAN_NP := MsVPrum ->nKcsDAN_NP + ;
                                                 if( lDan_NP, Mzdy ->nMzda, 0 )
         ENDIF
       ENDIF
       Mzdy ->( dbSkip())
     ENDDO
    Mzdy ->( CLR_sSCOPE( 1, nOldArea))

//    cX := Padl( AllTrim( Str( n)), 2, "0")
    MsVPrum ->nKDO_NM01 := anSUMo[5]
    MsVPrum ->nKC_NM01  := anSUMo[6]

    MsVPrum ->nKD_NMSUM  := MsVPrum ->nKD_NM01 +MsVPrum ->nKD_NM02   ;
                                   +MsVPrum ->nKD_NM03
    MsVPrum ->nKDO_NMSUM := MsVPrum ->nKDO_NM01 +MsVPrum ->nKDO_NM02 ;
                                   +MsVPrum ->nKDO_NM03
    MsVPrum ->nKC_NMSUM  := MsVPrum ->nKC_NM01 +MsVPrum ->nKC_NM02   ;
                                   +MsVPrum ->nKC_NM03

  ELSE
    MsVPrum ->nKD_NMSUM := F_KalenFND( nVybRok, nCtvrt)
    MsVPrum ->nKC_NMSUM := MsVPrum ->nKC_PPSUM
  ENDIF

RETURN( NIL)


STATIC FUNCTION fZalozREC( cALIAS)
  LOCAL  xKEY, n, cX, nLen, xKEYcp
  LOCAL  cRokHL_, nPocM
        LOCAL  cVybObdPP := "", cVybObdNM := ""
  LOCAL  nDnyFND
  LOCAL  nOldArea
  LOCAL  lODPOCnem := .T.
  LOCAL  lSVATKY
//  LOCAL  nPocMesPr := SysConfig( "Mzdy:nPocMesPr")

  DEFAULT cALIAS TO "MsPrc_Mz"

  lSVATKY := ( cALIAS) ->cTypTarMZD == "MESICNI "
  nDnyFND := F_PrumFND( lSVATKY)

  xKEYcp := StrZero( ( cALIAS) ->nOsCisPrac) +StrZero( ( cALIAS) ->nPorPraVzt)
  xKEY   := ACT_OBDn() +xKEYcp

//  aEval( anCtvrt[ nCtvrt], {|X| cVybObd := cVybObd + AllTrim( Str( X)) +"," })
//  nLen      := Len( AllTrim( cVybObd))

  cVybObdPP :=  StrZero( anCtvrt[ nCtvrt,1], 2) + "/" +StrZero( nVybRok,4) + " - " ;
                                                                 +StrZero( anCtvrt[ nCtvrt,3], 2) + "/" +StrZero( nVybRok,4)

  cVybObdNM :=  StrZero( nObdNemOD,2) + "/" + StrZero( nRokNemOD,4) + " - " ;
                                                                 +StrZero( nObdNemDO,2) + "/" + StrZero( nRokNemDO,4)

  nPocM     := 3
//  nPocMesPr := IF( nPocMesPr = 0, nPocM, nPocMesPr)

  MsVPrum ->( OrdSetFOCUS( 3))
  IF( MsVPrum ->( dbSeek ( xKEY)), DelREC( "MsVPrum"), NIL)
  W_DelRepl("MsVPrum")

  MsVPrum ->nRok       := ACT_OBDyn()
  MsVPrum ->nObdobi    := ACT_OBDon()
  MsVPrum ->cObdobi    := StrZero( MsVPrum ->nObdobi, 2) +"/"                   ;
                                 +Right( StrZero( MsVPrum ->nRok, 4), 2)
  MsVPrum ->nCtvrtleti := CTVRTzOBDn( MsVPrum ->nObdobi)
  MsVPrum ->cCtvrtlRIM := CTVRTzOBDc( MsVPrum ->nObdobi)

  MsVPrum ->cPracovnik := Left( ( cALIAS) ->cPracovnik, 25)                 ;
                                                                                                         +StrZero( ( cALIAS) ->nOsCisPrac)
  MsVPrum ->cKmenStrPr := ( cALIAS) ->cKmenStrPr
  MsVPrum ->nOsCisPrac := ( cALIAS) ->nOsCisPrac
  MsVPrum ->nPorPraVzt := ( cALIAS) ->nPorPraVzt
  MsVPrum ->cVybObd_P  := cVybObdPP
  MsVPrum ->cVybObd_N  := cVybObdNM
  MsVPrum ->nDelkPDoby := nPracDoMsH

  MsVPrum ->dDatNast   := ( cALIAS) ->dDatNast
  MsVPrum ->dDatVyst   := ( cALIAS) ->dDatVyst

RETURN( NIL)


STATIC FUNCTION        fVYPprprac()
  LOCAL  _nM172, _nM013, _nOdmH, _nOdmD, anNem
  LOCAL  nKoefCIST
        LOCAL  nTmpNA, nOdmNA

  _nOdmH := 0
  _nOdmD := 0
        _nM172 := 0
        nTmpNA := 0
        nOdmNA := 0

  IF ReplRec( "MsVPrum")
//// PP _ tak‚ algoritmus vìpoŸtu celoroŸn¡ch odmØn
    nKoefCIST := ( MsVPrum ->nHOD_PPSUM - MsVPrum ->nHOD_presc) / MsVPrum ->nHFondu_PP
//    nKoefCIST := IF( nKoefCIST > 1, 1, Round( nKoefCIST,2))         // £prava 2.11.2004 STS Prun‚ýov
    nKoefCIST := IF( nKoefCIST > 1, 1, nKoefCIST)
    MsVPrum ->nKc_ODMcis := MsVPrum ->nKc_ODMroz * nKoefCIST
//                        MsVPrum ->nKcsODMEN  := MsVPrum ->nKc_ODMcis

    IF aAlgHOD[1] = 1 .OR. aAlgHOD[1] = 2 .OR. aAlgHOD[1] = 3
       _nM172 := Round( IF( MsVPrum ->nHOD_PPSUM > 0, ( MsVPrum ->nKC_PPSUM +MsVPrum ->nKC_ODMcis)   ;
                                                                 / MsVPrum ->nHOD_PPSUM, 0), 2)
       nTmpNA := Round( IF( MsVPrum ->nHOD_NASUM > 0, ( MsVPrum ->nMZD_NASUM +MsVPrum ->nKC_ODMcis)   ;
                                                                 / MsVPrum ->nHOD_NASUM, 0), 2)
    ENDIF

    DO CASE
    CASE aAlgODM[1] = 1
      _nOdmH := Mh_RoundNumb( IF( MsVPrum ->nHOdpra_PP > 0, ;
                        MsVPrum ->nKcsODMEN / MsVPrum ->nHOdpra_PP, 0), aAlgODM[2])
      nOdmNA := Mh_RoundNumb( IF( MsVPrum ->nHOD_NASUM > 0, ;
                        MsVPrum ->nKcsODMEN / MsVPrum ->nHOD_NASUM, 0), aAlgODM[2])

    CASE aAlgODM[1] = 2 .or. aAlgODM[1] = 3
      _nOdmH := Mh_RoundNumb( IF( MsVPrum ->nHFondu_PP > 0, ;
                        MsVPrum ->nKcsODMEN / MsVPrum ->nHFondu_PP, 0), aAlgODM[2])
      nOdmNA := Mh_RoundNumb( IF( MsVPrum ->nHFondu_NA > 0, ;
                        MsVPrum ->nKcsODMEN / MsVPrum ->nHFondu_NA, 0), aAlgODM[2])

      DO CASE
      CASE aAlgODM[1] = 2
        _nOdmD := Mh_RoundNumb( _nOdmH * nPracDobaH, aAlgODM[2])

      CASE aAlgODM[1] = 3
        _nOdmD := Mh_RoundNumb( _nOdmH * nPrcDobaHz, aAlgODM[2])

      ENDCASE
    ENDCASE

//// PP _ tak a çupnem hodinovì pr…mØr do souboru, ale nesm¡ n m pýet‚ct
    MsVPrum ->nHodPrumPP := Mh_RoundNumb( IF( _nM172 + _nOdmH > 9999.99, 0,                  ;
                                  ( _nM172 + _nOdmH ) * nKoefHM), aAlgHOD[2])
    MsVPrum ->nHodPrumNA := Mh_RoundNumb( IF( nTmpNA + nOdmNA > 9999.99, 0,                  ;
                                  ( nTmpNA + nOdmNA) * nKoefHM), aAlgHOD[2])

    IF nPracDoMsH <> nPracDoObH .AND. nPracDoMsH <> 0 .AND. nPracDoObH <> 0
      MsVPrum ->nHodPrumPP := Mh_RoundNumb( MsVPrum ->nHodPrumPP *( nPracDoObH/nPracDoMsH), aAlgHOD[2])
      MsVPrum ->nHodPrumNA := Mh_RoundNumb( MsVPrum ->nHodPrumNA *( nPracDoObH/nPracDoMsH), aAlgHOD[2])
          ENDIF

// PP _ respekujeme algoritmus v˜po‡tu denn¡ho pr–mˆru v‡etnˆ celor. odmˆn
//      a çupnem denn¡ pr…mØr do souboru
    MsVPrum ->nDenPrumPP := VypDENpru( _nM172, _nOdmD                        ;
                                                    , MsVPrum ->nDNY_PPSUM               ;
                                         , MsVPrum ->nKC_PPSUM               ;
                                                                                                                                                                  , MsVPrum ->nKC_ODMcis)


//// vypoŸteme pr…mØr pro n hrady za nemocensk‚ pojiçtØn¡
    IF MsVPrum ->nHodPrumPP > 0 .OR. MsVPrum ->nHodPrumNA > 0
                        IF SysConfig( "Mzdy:lNezPrumNA")
        anNem := F_VypPrumNem( MsVPrum ->nHodPrumNA, 0, 0, nACTrok, .t.)
                        ELSE
        anNem := F_VypPrumNem( MsVPrum ->nHodPrumPP, 0, 0, nACTrok, .t.)
                        ENDIF

      MsVPrum ->nDenVZhruH := anNem[1]
      MsVPrum ->nDenVZcisH := anNem[2]
      MsVPrum ->nDenVZcikH := anNem[5]

      MsVPrum ->nSazDenH_1 := anNem[8]
      MsVPrum ->nSazDenH_2 := anNem[3]
    ENDIF

//// vypoŸteme pr…mØr pro nemocensk‚ pojiçtØn¡
    IF MsVPrum ->nKC_NMSUM > 0 .AND. ( MsVPrum ->nKD_NMSUM + MsVPrum ->nKDO_NMSUM) > 0  //    .and. Empty( MsVPrum ->nM010)
      anNem := F_VypPrumNem( MsVPrum ->nKC_NMSUM, MsVPrum ->nKD_NMSUM, MsVPrum ->nKDO_NMSUM, nACTrok)

      MsVPrum ->nDenVZhruN := anNem[1]
      MsVPrum ->nDenVZcisN := anNem[2]
      MsVPrum ->nSazDenNiN := anNem[3]
      MsVPrum ->nSazDenVyN := anNem[4]
      MsVPrum ->nDenVZcikN := anNem[5]
      MsVPrum ->nSazDenVKN := anNem[6]
      MsVPrum ->nSazDenMaN := anNem[7]

      MsVPrum ->nSazDenN_1 := anNem[8]
      MsVPrum ->nSazDenN_2 := anNem[3]
      MsVPrum ->nSazDenN_3 := anNem[6]
      MsVPrum ->nSazDenN_4 := anNem[4]
      MsVPrum ->nSazDenN_5 := 0
      MsVPrum ->nSazDenM_1 := anNem[7]
      MsVPrum ->nSazDenM_2 := anNem[9]
      MsVPrum ->nSazDenO_1 := anNem[7]
      MsVPrum ->nSazDenO_2 := 0

    ENDIF
    PRUmesMZD()

    WRT_Zmena( "MsVPrum", lNEWPrum)
    DcrUnlock( "MsVPrum")
  ENDIF

RETURN( NIL)


STATIC FUNCTION VypDENpru( nHODpru, nODMmzd, nDNYsum, nKCsum, nODMcis)
        LOCAL  nDENpru := 0

    DO CASE
    CASE aAlgDNU[1] = 1 .OR. aAlgDNU[1] = 2
      nDENpru := ( nHODpru +nODMmzd) * nPrcDobaHz

    CASE aAlgDNU[1] = 3
      nDENpru := ( nHODpru +nODMmzd) * nPracDobaH

    CASE aAlgDNU[1] = 4 .OR.  aAlgDNU[1] = 5
      nDENpru := IF( nDNYsum > 0, ( nKCsum +nODMcis) / nDNYsum, 0) +nODMmzd
    ENDCASE

//// PP _ tak a çupnem denn¡ pr…mØr do souboru, ale nesm¡ n m pýet‚ct
    nDENpru :=  Mh_RoundNumb( IF( nDENpru > 9999.99, 0, nDENpru * nKoefHM), aAlgDNU[2])

RETURN( nDENpru)



STATIC FUNCTION F_PrumFND( lSVATKY)
  LOCAL  nDOdpra := 0

        DEFAULT lSVATKY TO .F.

        aEval( anCtvrt[ nCtvrt],{ |X| nDOdpra += F_PRACDNY( nVybRok, X)})
        IF lSVATKY
                 aEval( anCtvrt[ nCtvrt],{ |X| nDOdpra += F_SVATKY( nVybRok, X)})
        ENDIF

RETURN( nDOdpra)


STATIC FUNCTION F_KalenFND()
  LOCAL  nDKalen := 0

        aEval( anCtvrt[ nCtvrt],{ |X| nDKalen += F_KALDNY( nVybRok, X)})

RETURN( nDKalen)



FUNCTION F_VypPrumNem( nKC, nKD, nKDO, nROKlik, lNAHR)
        LOCAL  _nV_Nemoc, _nS_Nemoc, _nK_Nemoc
  LOCAL  anPruNem[9]
        LOCAL  nXzakl90, nXzakl, nX30, nX60, nX90
        LOCAL  nRedHr1, nRedHr2, nRedHr3
        LOCAL  n, cX
        LOCAL  nkoenahr

        DEFAULT lNAHR TO .F.

        IF Empty( aZAOKnem)
          aZAOKNem := { 31, 0, 0, 0, 0 }
    cX := SysConfig( "Mzdy:cZAOKnem")
    FOR n := 1 TO 5        ; aZAOKnem[n] := Val( Token( cX, ",", n))
    NEXT
        ENDIF

        nkoenahr := if(lnahr, 0.175, 1)

        DO CASE
        CASE nROKlik == 2004 .OR. nROKlik == 2005
                nRedHr1 := 480
                nRedHr2 := 690
        CASE nROKlik == 2006
                nRedHr1 := 510
                nRedHr2 := 730
        CASE nROKlik == 2007 .OR. nROKlik == 2008
                nRedHr1 := 550
                nRedHr2 := 790
        CASE nROKlik == 2009
                nRedHr1 :=  786 * nkoenahr
                nRedHr2 := 1178 * nkoenahr
                nRedHr3 := 2356 * nkoenahr
        CASE nROKlik == 2010
                nRedHr1 :=  791 * nkoenahr
                nRedHr2 := 1186 * nkoenahr
                nRedHr3 := 2371 * nkoenahr
        CASE nROKlik == 2011
                nRedHr1 :=  825 * nkoenahr
                nRedHr2 := 1237 * nkoenahr
                nRedHr3 := 2474 * nkoenahr
        ENDCASE

        anPruNem[1] := anPruNem[2] := anPruNem[3] := anPruNem[4] := anPruNem[5] := anPruNem[6] := anPruNem[7] := anPruNem[8] := anPruNem[9] := 0

  IF nKC > 0
                if lnahr
      _nV_Nemoc := nKC
                else
      IF nKD > 0
        _nV_Nemoc := nKC / ( nKD +nKDO)
      ELSE
        _nV_Nemoc := 0
      ENDIF
                endif

                DO CASE
                CASE _nV_Nemoc > nRedHr3
                        nXzakl    := MH_RoundNum(nRedHr3 - nRedHr2, aZAOKnem[2])  // 0
                        nX30      := MH_RoundNum( Round( nXzakl  * 0.30, 2), aZAOKnem[3])  // 31
                        nXzakl    := MH_RoundNum(nRedHr2 - nRedHr1, aZAOKnem[2])  // 0
                        nX60      := MH_RoundNum( Round( nXzakl  * 0.60, 2), aZAOKnem[3])  // 31
                        nX90      := MH_RoundNum( Round( nRedHr1 * 0.90, 2), aZAOKnem[4])  // 31

                        _nS_Nemoc := nRedHr1 + nX60
                        _nK_Nemoc := nX90 + nX60 + nX30

                CASE _nV_Nemoc > nRedHr2
                        nXzakl    := MH_RoundNum( _nV_Nemoc - nRedHr2,       aZAOKnem[2])  // 0
                        nX30      := MH_RoundNum( Round( nXzakl  * 0.30, 2), aZAOKnem[3])  // 31
                        nXzakl    := MH_RoundNum(nRedHr2 - nRedHr1, aZAOKnem[2])  // 0
                        nX60      := MH_RoundNum( Round( nXzakl  * 0.60, 2), aZAOKnem[3])  // 31
                        nX90      := MH_RoundNum( Round( nRedHr1 * 0.90, 2), aZAOKnem[4])  // 31

                        _nS_Nemoc := nRedHr1 + nX60
                        _nK_Nemoc := nX90 + nX60 + nX30


          CASE _nV_Nemoc > nRedHr1
                        nXzakl    := MH_RoundNum(          _nV_NEMOC - nRedHr1, aZAOKnem[2])  // 0
                        nX60      := MH_RoundNum( Round( nXzakl   * 0.60, 2), aZAOKnem[3])  // 31
                        nX90      := MH_RoundNum( Round(  nRedHr1 * 0.90, 2), aZAOKnem[4])  // 31

                        _nS_Nemoc := nRedHr1 + nX60
                        _nK_Nemoc := nX90 + nX60

                OTHERWISE
                        nXzakl    := MH_RoundNum( _nV_NEMOC, aZAOKnem[2])
                        nX90      := MH_RoundNum( Round( nXzakl * 0.9, 2), aZAOKnem[4])     //31

                        _nS_Nemoc := nXzakl
                        _nK_Nemoc := nX90

                ENDCASE

    anPruNem[1] := IF( _nV_Nemoc > 9999.99, 0, _nV_Nemoc)
    anPruNem[2] := IF( _nS_Nemoc > 9999.99, 0, _nS_Nemoc)
    anPruNem[5] := IF( _nK_Nemoc > 9999.99, 0, _nK_Nemoc)
    anPruNem[3] := MH_RoundNum( Round( ( anPruNem[5] *0.60), 2), aZAOKnem[5])
    anPruNem[6] := MH_RoundNum( Round( ( anPruNem[5] *0.66), 2), aZAOKnem[5])
    anPruNem[4] := MH_RoundNum( Round( ( anPruNem[5] *0.72), 2), aZAOKnem[5])
    anPruNem[7] := MH_RoundNum( Round( ( anPruNem[2] *0.69), 2), aZAOKnem[5])
    anPruNem[8] := MH_RoundNum( Round( ( anPruNem[5] *0.25), 2), aZAOKnem[5])
    anPruNem[9] := MH_RoundNum( Round( ( anPruNem[2] *0.70), 2), aZAOKnem[5])

  ENDIF

RETURN( anPruNem)




STATIC FUNCTION WRT_MSprum( cALIAS)

  DEFAULT cALIAS TO "MsPrc_Mz"

  IF ReplRec( cALIAS)
    ( cALIAS) ->nHodPrumPP := MsVPrum ->nHodPrumPP
    ( cALIAS) ->nDenPrumPP := MsVPrum ->nDenPrumPP
    ( cALIAS) ->nDenVZhruN := MsVPrum ->nDenVZhruN
    ( cALIAS) ->nDenVZcisN := MsVPrum ->nDenVZcisN
    ( cALIAS) ->nDenVZciKN := MsVPrum ->nDenVZciKN
    ( cALIAS) ->nSazDenNiN := MsVPrum ->nSazDenNiN
    ( cALIAS) ->nSazDenVyN := MsVPrum ->nSazDenVyN
    ( cALIAS) ->nSazDenVKN := MsVPrum ->nSazDenVKN
    ( cALIAS) ->nSazDenMaN := MsVPrum ->nSazDenMaN
                ( cALIAS) ->nSazDenN_1 := MsVPrum ->nSazDenN_1

    WRT_Zmena( cALIAS)
    ( cALIAS) ->( Sx_Unlock())
  ENDIF

RETURN( NIL)


STATIC FUNCTION fKalDnyNM()
        LOCAL  dZACAT, dKONEC
        LOCAL  nAKTobd := ACT_OBDon()
        LOCAL  nAKTrok := ACT_OBDyn()

        IF nAKTobd == 1
    dZACAT := FirstODate( nAKTrok-1, anObdobi[nAKTobd,1])
          dKONEC := LastODate(  nAKTrok-1, anObdobi[nAKTobd,2])
        ELSE
    dZACAT := FirstODate( nAKTrok-1, anObdobi[nAKTobd,1])
          dKONEC := LastODate(  nAKTrok,   anObdobi[nAKTobd,2])
        ENDIF

  MsVPrum ->nKDSkut    := D_DnyOdDo( dZACAT, dKONEC, "KALE")

        IF( dZACAT < MsVPrum ->dDatNast, dZACAT := MsVPrum ->dDatNast, NIL)
        IF !Empty( MsVPrum ->dDatVyst)
          IF( dKONEC > MsVPrum ->dDatVyst, dKONEC := MsVPrum ->dDatVyst, NIL)
        ENDIF

  MsVPrum ->nKD_NM01   := D_DnyOdDo( dZACAT, dKONEC, "KALE")
  MsVPrum ->nDOdpra_NP := MsVPrum ->nKD_NM01

RETURN( NIL)


FUNCTION PRUmesMZD()
  LOCAL nX, nVAL
  LOCAL aX
  LOCAL nPruDNUmes, nHodCELKEM
  LOCAL nZaklad
  LOCAL nSoc := 0, nZdr := 0, nDan := 0
        LOCAL nRECms := MsPrc_Mz ->( Recno())
        LOCAL nSupHrMzda := 0

  IF nPracDoMsD <> 0
//    nHodCELKEM :=  nKoefDNmes * nPracDoMsH
    nHodCELKEM :=  nKoefHOmes * nPraDoMsTH
  ELSE
//    nHodCELKEM :=  nKoefDNmes * nPracDobaH
    nHodCELKEM :=  nKoefHOmes * nPraDobaTH
  ENDIF

        nHodCELKEM := Mh_RoundNumb( nHodCELKEM,222)
  MsVPrum ->nPruMesMzH := Mh_RoundNumb( MsVPrum ->nHodPrumPP *nHodCELKEM, 32)

        nSoc := Round( ( ( MsVPrum ->nPruMesMzH * nPROCsocZ) / 100) + 0.49, 0)
        nZdr := Round( ( ( MsVPrum ->nPruMesMzH * nPROCzdrZ) / 100) + 0.49, 0)

        nSupHrMzda := MsVPrum ->nPruMesMzH + (MsVPrum ->nPruMesMzH * 0.35)
        nSupHrMzda := Mh_RoundNumb( nSupHrMzda, 32)

        nVAL := nSupHrMzda - MsPrc_Mz ->nOdpocOBD
        nDan := fDanVyp( nVal, nACTrok)
        nDan := IF( nDan >= MsPrc_Mz ->nDanUlObd, nDan - MsPrc_Mz ->nDanUlObd, 0)

  MsVPrum ->nPruMesMzC := MsVPrum ->nPruMesMzH  - nSoc - nZdr - nDan
//  ENDIF

        MsPrc_Mz ->( dbGoTo( nRECms))

RETURN( NIL)


STATIC FUNCTION INcSTATic( lPRAVD, cOBDnz)
  LOCAL  nX, cX, aX, n, nQ, nW
        LOCAL  dZACAT, dKONEC
        LOCAL  nREC, nY
        LOCAL  i
        LOCAL  aTMP
        LOCAL  cALIAS
  LOCAL  nPocMesPr := SysConfig( "Mzdy:nPocMesPr")
        LOCAL  nAlgCelOdm

  cALIAS   := IF( lPRAVd, "MsPrc_Mp", "MsPrc_Mz")
        IF( lPRAVd, lINIstat := .T., NIL)

  nPracDoMsH := 0
  nPracDoObH := 0
  nPracDoMsD := 0
  nPracDoObD := 0
  nPraDoMsTH := 0

        IF        lINIstat
    aAlgHOD  := { 0, 0}
    aAlgDNU  := { 0, 0}
    aAlgODM  := { 0, 0, 0}
          aZAOKNem := { 31, 0, 31, 31, 31 }

    nACTrok := ACT_OBDyn()
                nACTobd := ACT_OBDon()

    cX := SysConfig( "Mzdy:cAlgHOD_PR")
    FOR n := 1 TO 2        ; aAlgHOD[n] := Val( Token( cX, ",", n))
    NEXT
    cX := SysConfig( "Mzdy:cAlgDNU_PR")
    FOR n := 1 TO 2        ; aAlgDNU[n] := Val( Token( cX, ",", n))
    NEXT
    cX := SysConfig( "Mzdy:cAlgODM_PR")
    FOR n := 1 TO 3        ; aAlgODM[n] := Val( Token( cX, ",", n))
    NEXT
    cX := SysConfig( "Mzdy:cZAOKnem")
    FOR n := 1 TO 5        ; aZAOKnem[n] := Val( Token( cX, ",", n))
    NEXT

    nPracDobaH := SysConfig( "Mzdy:nDelPrcTyd") / SysConfig( "Mzdy:nDnyPrcTyd")
    nPracDobaD := SysConfig( "Mzdy:nDnyPrcTyd")
    nPraDobaTH := SysConfig( "Mzdy:nDelPrcTyd")

//                aX := faOdvSocZA()
                nPROCsocZ  := 0
                aEVAL( faOdvSocZA(), { |X| nPROCsocZ += X })
                nPROCzdrZ  := SysConfig( "Mzdy:nOdvZdrZam")
    nKoefHM    := SysConfig( "Mzdy:nKoefHM")

    dZACAT     := FirstODate( nACTrok, 1)
          dKONEC     := LastODate(  nACTrok, 12)
                nKoefDNmes := 21.74
                nKoefHOmes := 4.348
//    nKoefDNmes := ( D_DnyOdDo( dZACAT, dKONEC, "PRAC")                    ;
//                                 +D_DnyOdDo( dZACAT, dKONEC, "SVAT")) / 12

    lINIstat := .F.
        ENDIF


        nY := Val( Right( AllTrim(cOBDnz), 2))

        DO CASE
        CASE nY = 1 .OR. nY = 2 .OR. nY = 3
    nX      := 12
    nVybRok := Val( Left( cOBDnz, 4)) -1

        CASE nY = 4 .OR. nY = 5 .OR. nY = 6
    nX      := 3
    nVybRok := Val( Left( cOBDnz, 4))

        CASE nY = 7 .OR. nY = 8 .OR. nY = 9
    nX      := 6
    nVybRok := Val( Left( cOBDnz, 4))

        CASE nY = 10 .OR. nY = 11 .OR. nY = 12
    nX      := 9
    nVybRok := Val( Left( cOBDnz, 4))
        ENDCASE

        i         := Val( Right( cOBDnz, 2))
        nRokNemOD := Val( Left( cOBDnz, 4)) -1
        nRokNemDO := IF( nY = 1, Val( Left( cOBDnz, 4)) -1, Val( Left( cOBDnz, 4)))
        nObdNemOD := anObdobi[i,1]
        nObdNemDO := anObdobi[i,2]

  xOBDkey   := cOBDnz
  nCtvrt    := CTVRTzOBDn( nX)
  xCTVRTkey := StrZero( nVybRok, 4) +StrZero( nCtvrt, 1)


  IF lPRAVD
    nPracDoMsH := fPracDOBA( MsPrc_Mp ->cDelkPrDob)[3]
                nPraDoMsTH := fPracDOBA( MsPrc_Mp ->cDelkPrDob)[2]
    nPracDoObH := nPracDoMsH
    nPracDoMsD := fPracDOBA()[1]
    nPracDoObD := nPracDoMsD
  ELSE
                nREC := MsPrc_Mz ->( RecNo())
    IF MsPrc_Mo ->( dbSeek( xOBDkey +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt)))
      MzKum_Ro ->( dbSeek( xOBDkey +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt)))
      nPracDoObH := fPracDOBA( MsPrc_Mo ->cDelkPrDob)[3]
      nPracDoObD := fPracDOBA( MsPrc_Mo ->cDelkPrDob)[1]

            IF nRokNemOD < Year( MsPrc_Mo ->dDatNast)
                          nRokNemOD :=  Year(  MsPrc_Mo ->dDatNast)
               i         :=  Month( MsPrc_Mo ->dDatNast)
        nObdNemOD := anObdobi[i,1]
                        ENDIF

                ELSE
                        MsPrc_Mz ->( dbGoTo( nREC))
      nPracDoMsH := fPracDOBA()[3]
                        nPraDoMsTH := fPracDOBA()[2]
      nPracDoMsD := fPracDOBA()[1]
            IF nRokNemOD < Year( MsPrc_Mo ->dDatNast)
                          nRokNemOD :=  Year(  MsPrc_Mo ->dDatNast)
               i         :=  Month( MsPrc_Mo ->dDatNast)
        nObdNemOD := anObdobi[i,1]
                        ENDIF
                ENDIF
  ENDIF

  nPrcDobaHz := IF( nPracDoObH > 0, nPracDoObH, IF( nPracDoMsH > 0, nPracDoMsH, nPracDobaH))
  nPrcDobaDz := IF( nPracDoObD > 0, nPracDoObD, IF( nPracDoMsD > 0, nPracDoMsD, nPracDobaD))

        nAlgCelOdm := IF( ( cALIAS) ->nAlgCelOdm <> 0 ;
                                       , ( cALIAS) ->nAlgCelOdm, aAlgODM[3])
  nPocMesPr  := IF( nPocMesPr = 0, 3, nPocMesPr)
        nPocMesPr  := IF( ( cALIAS) ->nAlgCelOdm <> 0 ;
                                      , ( cALIAS) ->nPocMesPr, nPocMesPr)
  aDMZodm    := {}

  DruhyMZD ->( dbGoTop())
  DO WHILE !DruhyMZD ->( Eof())
                IF DruhyMZD ->lNapPrCelO
                  nQ   := IF( DruhyMZD ->nAlgCelOdm == 0, nAlgCelOdm          ;
                                                                , DruhyMZD ->nAlgCelOdm)
                  nW   := IF( DruhyMZD ->nPocMesPr  == 0, nPocMesPr           ;
                                                                , DruhyMZD ->nPocMesPr)
            ( aTMP := {}, aTMP := { StrZero(  DruhyMZD ->nDruhMzdy, 4), nQ, nW})
      AAdd( aDMZodm, aTMP)
                ENDIF
    DruhyMZD ->( dbSkip())
  ENDDO

RETURN( NIL)


FUNCTION CELodm( xKEY, aDMZ)
        LOCAL  n
        LOCAL  nCelODM := 0
        LOCAL  xKEYod, xKEYdo
        LOCAL  cOBDod, cOBDdo
        LOCAL  nOldTAG := Mzdy ->( OrdSetFOCUS())
        LOCAL  nOldREC := Mzdy ->( Recno())
        LOCAL  nTYP


        MsVPrum ->nKC_ODMcel := 0
        MsVPrum ->nKC_ODMroz := 0

        IF !IsNil( aDMZ)
          FOR n := 1 TO Len( aDMZ)
                        nTYP := aDMZ[n,2]

                        DO CASE
                        CASE nTYP == 1
                          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"01"
                          cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"

                        CASE nTYP == 2
                          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"07"
                          cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"

                        CASE nTYP == 3
                                DO CASE
                                CASE ACT_OBDqn() = 1
                            cOBDod := StrZero( ACT_OBDyn() -1, 4) +"01"
                            cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
                                CASE ACT_OBDqn() = 2
                            cOBDod := StrZero( ACT_OBDyn() -1, 4) +"04"
                            cOBDdo := StrZero( ACT_OBDyn(), 4) +"03"
                                CASE ACT_OBDqn() = 3
                            cOBDod := StrZero( ACT_OBDyn() -1, 4) +"07"
                            cOBDdo := StrZero( ACT_OBDyn(), 4) +"06"
                                CASE ACT_OBDqn() = 4
                            cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
                            cOBDdo := StrZero( ACT_OBDyn(), 4) +"09"
                                ENDCASE

                        CASE nTYP == 4
                                DO CASE
                                CASE ACT_OBDqn() = 1
                            cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
                            cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
                                OTHERWISE
                            cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
                            cOBDdo := StrZero( ACT_OBDyn(), 4) +"09"
                                ENDCASE

                        CASE nTYP == 5
                                DO CASE
                                CASE ACT_OBDqn() = 1 .OR. ACT_OBDqn() = 2 .OR. ACT_OBDqn() = 3
                            cOBDod := StrZero( ACT_OBDyn() -1, 4) +"01"
                            cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
                                CASE ACT_OBDqn() = 4
                            cOBDod := StrZero( ACT_OBDyn(), 4) +"01"
                            cOBDdo := StrZero( ACT_OBDyn(), 4) +"12"
                                ENDCASE

                        CASE nTYP == 6
                                DO CASE
                                CASE ACT_OBDqn() = 1  //4
                            cOBDod := StrZero( ACT_OBDyn()-1, 4) +"07"
                            cOBDdo := StrZero( ACT_OBDyn()-1, 4) +"12"
                                CASE ACT_OBDqn() = 2   //1
                            cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
                            cOBDdo := StrZero( ACT_OBDyn(), 4) +"03"
                                CASE ACT_OBDqn() = 3   //1
                            cOBDod := StrZero( ACT_OBDyn(), 4) +"01"
                            cOBDdo := StrZero( ACT_OBDyn(), 4) +"06"
                                CASE ACT_OBDqn() = 4   //1
                            cOBDod := StrZero( ACT_OBDyn(), 4) +"04"
                            cOBDdo := StrZero( ACT_OBDyn(), 4) +"09"
                                ENDCASE

                        CASE nTYP == 7
                                DO CASE
                                CASE ACT_OBDqn() = 1 .OR. ACT_OBDqn() = 2          //4
                            cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
                            cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
                                OTHERWISE
                            cOBDod := StrZero( ACT_OBDyn(), 4) +"01"
                            cOBDdo := StrZero( ACT_OBDyn(), 4) +"09"
                                ENDCASE
                        ENDCASE

                        xKEYod := xKEY +aDMZ[n,1] +cOBDod
                        xKEYdo := xKEY +aDMZ[n,1] +cOBDdo
                        Mzdy ->( Set_rSCOPE( 15, xKEYod, xKEYdo))
                         nCelODM := 0
                         DO WHILE !Mzdy ->( Eof())
                                 nCelODM += Mzdy ->nMzda
                                 Mzdy ->( dbSkip())
                         ENDDO
                        Mzdy ->( Clr_SCOPE())

      MsVPrum ->nKC_ODMcel += nCelODM
      MsVPrum ->nKC_ODMroz += ( nCelODM / 12) * aDMZ[n,3]
          NEXT
        ENDIF

        Mzdy ->( OrdSetFOCUS( nOldTAG))
        Mzdy ->( dbGoTo( nOldREC))

RETURN( NIL)


STATIC FUNCTION fPRACmzdu( cALIAS)
        LOCAL  aRET := { .F., .F.}
        LOCAL  xKEY, n
        LOCAL  xKEYcp, xKEYod, xKEYdo
        LOCAL  nOldTAG, nOldArea
        LOCAL  nOldREC := Mzdy ->( Recno())

        nOldArea := Select()
        nOldTAG  := Mzdy ->( OrdSetFOCUS( 8))

  Dc_DCOPen( { 'Mzdy, 8'})

        FOR n := 1 TO 3
    xKey := StrZero( nVybRok, 4) + StrZero( anCtvrt[nCtvrt, n], 2)         ;
                           +StrZero( ( cALIAS) ->nOsCisPrac) +StrZero( ( cALIAS) ->nPorPraVzt)
                IF Mzdy ->( dbSeek( xKey))
                        aRET[1] := .T.
                        n := 3
                ENDIF
        NEXT

  xKEYcp := StrZero( ( cALIAS) ->nOsCisPrac) +StrZero( ( cALIAS) ->nPorPraVzt)
  xKEYod := xKEYcp +StrZero( nRokNemOD, 4) +StrZero( nObdNemOD, 2)
  xKEYdo := xKEYcp +StrZero( nRokNemDO, 4) +StrZero( nObdNemDO, 2)

  nOldArea := Select()
  Mzdy ->( SET_rSCOPE( 18, xKEYod, xKEYdo))
         aRET[2] := Mzdy ->( Sx_KeyCount()) > 0
  Mzdy ->( CLR_sSCOPE( nOldTAG, nOldArea))
        Mzdy ->( dbGoTo( nOldREC))

RETURN( aRET)


FUNCTION F_VyPrNe08( nKC, nKD, nKDO, nROKlik)
        LOCAL  _nV_Nemoc, _nS_Nemoc, _nK_Nemoc
  LOCAL  anPruNem[9]
        LOCAL  nXzakl90, nXzakl, nX60, nX90
        LOCAL  nRedHr1, nRedHr2
        LOCAL  n, cX

  aZAOKNem := { 31, 0, 31, 31, 31 }

        DO CASE
        CASE nROKlik == 2009
                nRedHr1 := 610
                nRedHr2 := 870

        CASE nROKlik == 2010
                nRedHr1 := 610
                nRedHr2 := 870

        CASE nROKlik == 2011
                nRedHr1 := 610
                nRedHr2 := 870
        ENDCASE

        anPruNem[1] := anPruNem[2] := anPruNem[3] := anPruNem[4] := anPruNem[5] := anPruNem[6] := anPruNem[7] := anPruNem[8]:= anPruNem[9] := 0

  IF nKC > 0
    IF nKD > 0
      _nV_Nemoc := nKC / ( nKD +nKDO)
    ELSE
      _nV_Nemoc := 0
    ENDIF

                DO CASE
                CASE _nV_Nemoc > nRedHr2
                        nXzakl90  := MH_RoundNum(         nRedHr2  - nRedHr1, aZAOKnem[2])  // 0
                        nX60      := MH_RoundNum( Round( nXzakl90 * 0.60, 2), aZAOKnem[3])  // 31
                        nX90      := MH_RoundNum( Round(  nRedHr1 * 0.90, 2), aZAOKnem[4])  // 31

                        _nS_Nemoc := nRedHr1 + nX60
                        _nK_Nemoc :=    nX90 + nX60

          CASE _nV_Nemoc <= nRedHr1
                        nXzakl    := MH_RoundNum( _nV_NEMOC, aZAOKnem[1]) //   31
                        nXzakl90  := MH_RoundNum( _nV_NEMOC, aZAOKnem[2])
                        nX90      := MH_RoundNum( Round( nXzakl90 * 0.9, 2), aZAOKnem[4])     //31

                        _nS_Nemoc := nXzakl
                        _nK_Nemoc := nX90

                OTHERWISE
                        nXzakl90  := MH_RoundNum(          _nV_NEMOC - nRedHr1, aZAOKnem[2])  // 0
                        nX60      := MH_RoundNum( Round( nXzakl90 * 0.60, 2), aZAOKnem[3])  // 31
                        nX90      := MH_RoundNum( Round(  nRedHr1 * 0.90, 2), aZAOKnem[4])  // 31

                        _nS_Nemoc := nRedHr1 + nX60
                        _nK_Nemoc := nX90 + nX60

                ENDCASE

    anPruNem[1] := IF( _nV_Nemoc > 9999.99, 0, _nV_Nemoc)
    anPruNem[2] := IF( _nS_Nemoc > 9999.99, 0, _nS_Nemoc)
    anPruNem[5] := IF( _nK_Nemoc > 9999.99, 0, _nK_Nemoc)
    anPruNem[3] := MH_RoundNum( Round( ( anPruNem[5] *0.60), 2), aZAOKnem[5])
    anPruNem[6] := MH_RoundNum( Round( ( anPruNem[5] *0.66), 2), aZAOKnem[5])
    anPruNem[4] := MH_RoundNum( Round( ( anPruNem[5] *0.72), 2), aZAOKnem[5])
    anPruNem[7] := MH_RoundNum( Round( ( anPruNem[2] *0.69), 2), aZAOKnem[5])
    anPruNem[8] := MH_RoundNum( Round( ( anPruNem[5] *0.25), 2), aZAOKnem[5])
    anPruNem[9] := 0

  ENDIF

RETURN( anPruNem)
*/

