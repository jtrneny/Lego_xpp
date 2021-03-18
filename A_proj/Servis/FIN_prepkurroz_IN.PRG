#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for FIN_c_bankuc ******************************************************
CLASS FIN_prepkurroz_IN FROM drgUsrClass
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  method  prepocet

  var    rok, mena, kurz

/*
  * bro col for c_bankuc
  inline access assign method isMain_uc() var isMain_uc
    return if( c_bankuc->lisMain, 300, 0)


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = xbeBRW_ItemMarked)
     ::dm:refresh()

    case(nevent = drgEVENT_FORMDRAWN)
      if ::lsearch
        postAppEvent(xbeP_Keyboard,xbeK_LEFT,,::brow:oxbp)
        return .t.
      else
        return .f.
      endif

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        ::drgDialog:cargo := &(oXbp:cargo:arDef[1,2])
        return .t.
      endif

    endcase
  return .f.
*/

HIDDEN:
  var    msg, dm, dc, df
  *
ENDCLASS


method FIN_prepkurroz_IN:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
 ::drgUsrClass:init(parent)

 ::rok   := 2008
 ::mena  := "EUR"
 ::kurz  := 0.0000

  drgDBMS:open('FakPriHD')
  drgDBMS:open('FakVysHD')

return self


method FIN_prepkurroz_IN:drgDialogInit(drgDialog)

return self


method FIN_prepkurroz_IN:drgDialogStart(drgDialog)

  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form

return


method FIN_prepkurroz_IN:postLastField(drgVar)
return .t.


method FIN_prepkurroz_IN:prepocet(drgVar)
  local lok, cx

  drgServiceThread:progressStart(drgNLS:msg('P¯epoËet kurzovnÌch rozdÌl˘ u faktur p¯ijat˝ch ! ... ', 'FAKPRIHD'), ;
                                               fakprihd->(lastRec())  )
  FakPriHD->(dbGoTop())
  do while .not. FakPriHD->(Eof())
    if FakPriHD->nRok = 2008 .and. FakPriHD->nCisUzv = 557
      if FakPriHD ->( dbRlock())
        FakPriHD ->nCisUzv := 558
        FakPriHD ->( dbUnlock())
      endif
    endif

    lok := FakPriHD->nRok <= 2008                                           ;
                .and. FakPriHD->nCenZakCel <> FakPriHD->nUhrCelFak          ;
                 .and. FakPriHD->nCisUzv <> 558                             ;
                  .and. FakPriHD->cZkratMenZ = ::mena
    if lok
      if FakPriHD ->( dbRlock())
        cx := Chr(13) +Chr(10)
        cx := cx + "P¯epoËet kurz˘ za rok 2008" +Chr(13) +Chr(10)
        cx := cx + " - p˘vodnÌ kurz             (nKurZahMen): "  +Str(FakPriHD ->nKurZahMen) +Chr(13) +Chr(10)
        cx := cx + " - p˘vodnÌ z·kladnÌ cena    (nCenZakCel): "  +Str(FakPriHD ->nCenZakCel) +Chr(13) +Chr(10)
        cx := cx + " - p˘vodnÌ fakturovan· cena (nCenFakCel): "  +Str(FakPriHD ->nCenFakCel) +Chr(13) +Chr(10)
        cx := cx + " - p˘vodnÌ uhrazen· Ë·stka  (nUhrCelFaZ): "  +Str(FakPriHD ->nUhrCelFaZ) +Chr(13) +Chr(10)
        FakPriHD ->mPopisFak  := FakPriHD ->mPopisFak +cx
        FakPriHD ->nKurZahMen := ::kurz
        FakPriHD ->nCenZakCel := FakPriHD ->nCenZahCel *FakPriHD ->nKurZahMen
        FakPriHD ->nCenFakCel := FakPriHD ->nCenZahCel *FakPriHD ->nKurZahMen
        FakPriHD ->nUhrCelFak := FakPriHD ->nUhrCelFaZ *FakPriHD ->nKurZahMen
        FakPriHD ->nCisUzv := 558
        FakPriHD ->( dbUnlock())
      endif
    endif
    drgServiceThread:progressInc()
    FakPriHd->( dbSkip())
  enddo

  drgServiceThread:progressEnd()


  drgServiceThread:progressStart(drgNLS:msg('P¯epoËet kurzovnÌch rozdÌl˘ u faktur p¯ijat˝ch ! ... ', 'FAKVYSHD'), ;
                                               fakvyshd->(lastRec()) )
  FakVysHD ->(dbGoTop())

  do while !FakVysHD->(Eof())
    if FakVysHD->nRok = 2008 .AND. FakVysHD->nCisUzv = 557
      if FakVysHD ->( dbRlock())
        FakVysHD ->nCisUzv := 558
        FakVysHD ->( dbUnlock())
      endif
    endif

   lOK := FakVysHD->nRok <= 2008                                        ;
           .and. FakVysHD->nCenZakCel <> FakVysHD->nUhrCelFak           ;
            .and.FakVysHD->nCisUzv <> 558                              ;
             .and. FakVysHD->cZkratMenZ = ::mena
   if lOK
     IF ReplREC( "FakVysHD")
       cX := Chr(13) +Chr(10)
       cX := cX + "P¯epoËet kurz˘ za rok 2008" +Chr(13) +Chr(10)
       cX := cX + " - p˘vodnÌ kurz             (nKurZahMen): "  +Str(FakVysHD ->nKurZahMen) +Chr(13) +Chr(10)
       cX := cX + " - p˘vodnÌ z·kladnÌ cena    (nCenZakCel): "  +Str(FakVysHD ->nCenZakCel) +Chr(13) +Chr(10)
       cX := cX + " - p˘vodnÌ fakturovan· cena (nCenFakCel): "  +Str(FakVysHD ->nCenFakCel) +Chr(13) +Chr(10)
       cX := cX + " - p˘vodnÌ uhrazen· Ë·stka  (nUhrCelFaZ): "  +Str(FakVysHD ->nUhrCelFaZ) +Chr(13) +Chr(10)
       FakVysHD ->mDolFakCis := FakVysHD ->mDolFakCis +cX
       FakVysHD ->nKurZahMen := ::kurz
       FakVysHD ->nCenZakCel := FakVysHD ->nCenZahCel *FakVysHD ->nKurZahMen
       FakVysHD ->nCenFakCel := FakVysHD ->nCenZahCel *FakVysHD ->nKurZahMen
       FakVysHD ->nUhrCelFak := FakVysHD ->nUhrCelFaZ *FakVysHD ->nKurZahMen

       FakVysHD ->nCisUzv := 558
       FakVysHD ->( dbUnlock())
     endif
   endif

    drgServiceThread:progressInc()
    FakVysHd->( dbSkip())
  enddo

  drgServiceThread:progressEnd()

return .t.



/*



Function PrepKurR()
        Local cColor := SetColor( 'W+/B, N/W+,,, w+/b' )
//  Local cColor := 'N/W,W+/B'
        Local cScr := SaveScreen()
        Local GetList := {}
        Local cScope
//        Local cFakPriHd := fNetAdr() + '\Finance\Dat\FakPri\FakPriHD'
//        Local cFakVysHd := fNetAdr() + '\Finance\Dat\FakVys\FakVysHD'
        Local cFakPriHd := 'FakPriHD'
        Local cFakVysHd := 'FakVysHD'
//        Local cFakPriHd := 'FakPriHD'
//        Local cFakVysHd := 'FakVysHD'
  Local nRecCount1 := 0, nRecCount2 := 0, nCount, n
        Local lOK
  Local cX
        Local cZkrMeny
        Local nKurz
        Local cBuff, nLenBuff

//  Local cColor := 'W/N,N/W+,,,W+/N'
//         SetColor(cColor)

        lNetWare := .T.

//        dbCreate( cFileIt, aOutDefIt )
//  dbUseArea( .t., "SIXCDX", ( cFileIT),, if( .T. .or. .F., .F., NIL ), .f. )


  DispBox( 8, 23, 13, 70, BX_DOUBLE + ' ', 'W+/B')
  BoxShadow( 8, 23, 13, 70)

        SET CURSOR ON

  cZkrMeny := Space(3)
  nKurz    := 0.000000

  @ 10, 25 Say 'Zkratka mÿny : ' Get cZkrMeny Picture 'XXX'
  @ 11, 25 Say 'Kurz mÿny    : ' Get nKurz    Picture '99999.999999'

         ReadModal( GetList)

        SET CURSOR OFF

  If LastKey() == K_ESC
Break
  Endif
  RestScreen( ,,,, cScr)

  Box_Make( '< Okamßik pros°m ... >',;
               'Prob°h† p˝°prava pro proveden° p˝evodu faktur ...',;
                'w+/g, gr+/n*')


  dbUseArea( .t., "SIXCDX", ( cFakPriHd),, if( .T. .or. .F., lNetWare, NIL ), .f. )
        FakPriHD ->( OrdSetFOCUS(0))
  dbUseArea( .t., "SIXCDX", ( cFakVysHd),, if( .T. .or. .F., lNetWare, NIL ), .f. )
        FakVysHD ->( OrdSetFOCUS(0))

//  dbUseArea( .t., "SIXCDX", ( cFakVysIt),, if( .T. .or. .F., lNetWare, NIL ), .f. )
//         INDEX ON FakVysIt->cObdobi TO ( cTMP +'TmpIt') For ForIdx1()
//        FakVysIt->(dbGoTop())
//  FakVysIt->( dbEval( {|| nRecCount2++ }))

  nHandle  := fCreate( "PrMe_"+AllTrim(cZkrMeny) +".TXT", 0)

  Box_Make()

        nRecCount1 := 0
        nCount := 1

  Box_Thermo( 1, nCount, nRecCount1, '< Okamßik pros°m ... >' ,;
                                    'Prob°h† p˝epoüet kurzovn°ch rozd°lÖ u faktur p˝ijatÏch !')

  FakPriHd ->( dbEval( {|| nRecCount1++ }))
        FakPriHD->(dbGoTop())

        cBuff := Chr( 13) + Chr( 10)
  cBuff := "FAKTURY P¸IJATê za " +AllTrim(cZkrMeny) +Chr( 13) + Chr( 10)
        cBuff := cBuff +"======================" +Chr( 13) + Chr( 10)
  nLenBuff := Len( cBuff)
  IF ( fWrite( nHandle, cBuff, nLenBuff) <> nLenBuff)
    Box_Waring( "Chyba p˝i z†pisu do souboru ....")
  ENDIF

        Do While !FakPriHD->(Eof())
                IF FakPriHD->nRok = 2007 .AND. FakPriHD->nCisUzv = 556
                        IF ReplREC( "FakPriHD")
                                FakPriHD ->nCisUzv := 557
                                FakPriHD ->( dbUnlock())
                        ENDIF
                ENDIF

                lOK := FakPriHD->nRok <= 2007                                            ;
                        .AND. FakPriHD->nCenZakCel <> FakPriHD->nUhrCelFak               ;
                                                          .AND. FakPriHD->nCisUzv <> 557                                ;
                                                          .AND. FakPriHD->cZkratMenZ = cZkrMeny
//                                                 .AND. FakPriHD->cZkratStat <> "CZ"                              ;
//                                                  .AND. FakPriHD->nFinTyp <> 5                                   ;

                IF lOK
                        cBuff := FakPriHD ->cObdobi +"  " +Str( FakPriHD ->nCisFak) +Chr( 13) + Chr( 10)
                  nLenBuff := Len( cBuff)
      IF ( fWrite( nHandle, cBuff, nLenBuff) <> nLenBuff)
        Box_Waring( "Chyba p˝i z†pisu do souboru ....")
                  ENDIF

                        IF ReplREC( "FakPriHD")
                                cX := Chr(13) +Chr(10)
                                cX := cX + "P˝epoüet kurzu za rok 2007" +Chr(13) +Chr(10)
                                cX := cX + " - pÖvodn° kurz             (nKurZahMen): "  +Str(FakPriHD ->nKurZahMen) +Chr(13) +Chr(10)
                                cX := cX + " - pÖvodn° z†kladn° cena    (nCenZakCel): "  +Str(FakPriHD ->nCenZakCel) +Chr(13) +Chr(10)
                                cX := cX + " - pÖvodn° fakturovan† cena (nCenFakCel): "  +Str(FakPriHD ->nCenFakCel) +Chr(13) +Chr(10)
                                cX := cX + " - pÖvodn° uhrazen† ü†stka  (nUhrCelFaZ): "  +Str(FakPriHD ->nUhrCelFaZ) +Chr(13) +Chr(10)
                                FakPriHD ->mPopisFak  := FakPriHD ->mPopisFak +cX

                                FakPriHD ->nKurZahMen := nKurz
                                FakPriHD ->nCenZakCel := FakPriHD ->nCenZahCel *FakPriHD ->nKurZahMen
                                FakPriHD ->nCenFakCel := FakPriHD ->nCenZahCel *FakPriHD ->nKurZahMen
                                FakPriHD ->nUhrCelFak := FakPriHD ->nUhrCelFaZ *FakPriHD ->nKurZahMen

                                FakPriHD ->nCisUzv := 557
                                FakPriHD ->( dbUnlock())
                        ENDIF
                ENDIF

          Box_Thermo( 0, nCount, nRecCount1)
    ( FakPriHd->( dbSkip()), nCount++ )
        EndDo

  Box_Thermo( -1)

        nCount     := 1
        nRecCount1 := 0

  Box_Thermo( 1, nCount, nRecCount1, '< Okamßik pros°m ... >' ,;
                                    'Prob°h† p˝epoüet kurzovn°ch rozd°lÖ u faktur vystavenÏch !')

  FakVysHd ->( dbEval( {|| nRecCount1++ }))
        FakVysHD ->(dbGoTop())

        cBuff := Chr( 13) + Chr( 10)
  cBuff := cBuff +"FAKTURY VYSTAVENê za " +AllTrim(cZkrMeny) +Chr( 13) + Chr( 10)
        cBuff := cBuff +"========================" +Chr( 13) + Chr( 10)
  nLenBuff := Len( cBuff)
  IF ( fWrite( nHandle, cBuff, nLenBuff) <> nLenBuff)
    Box_Waring( "Chyba p˝i z†pisu do souboru ....")
  ENDIF

        Do While !FakVysHD->(Eof())
                IF FakVysHD->nRok = 2007 .AND. FakVysHD->nCisUzv = 556
                        IF ReplREC( "FakVysHD")
                                FakVysHD ->nCisUzv := 557
                                FakVysHD ->( dbUnlock())
                        ENDIF
                ENDIF


                lOK := FakVysHD->nRok <= 2007                                           ;
                        .AND. FakVysHD->nCenZakCel <> FakVysHD->nUhrCelFak              ;
                                                         .AND. FakVysHD->nCisUzv <> 557                               ;
                                                          .AND. FakVysHD->cZkratMenZ = cZkrMeny

//                                                 .AND. FakVysHD->cZkratStat <> "CZ"                             ;
//                                                  .AND. FakVysHD->nFinTyp <> 4                                  ;

                IF lOK
                        cBuff := FakVysHD ->cObdobi +"  " +Str(FakVysHD ->nCisFak) +Chr( 13) + Chr( 10)
                  nLenBuff := Len( cBuff)
      IF ( fWrite( nHandle, cBuff, nLenBuff) <> nLenBuff)
        Box_Waring( "Chyba p˝i z†pisu do souboru ....")
                  ENDIF
                        IF ReplREC( "FakVysHD")
                                cX := Chr(13) +Chr(10)
                                cX := cX + "P˝epoüet kurzu za rok 2007" +Chr(13) +Chr(10)
                                cX := cX + " - pÖvodn° kurz             (nKurZahMen): "  +Str(FakVysHD ->nKurZahMen) +Chr(13) +Chr(10)
                                cX := cX + " - pÖvodn° z†kladn° cena    (nCenZakCel): "  +Str(FakVysHD ->nCenZakCel) +Chr(13) +Chr(10)
                                cX := cX + " - pÖvodn° fakturovan† cena (nCenFakCel): "  +Str(FakVysHD ->nCenFakCel) +Chr(13) +Chr(10)
                                cX := cX + " - pÖvodn° uhrazen† ü†stka  (nUhrCelFaZ): "  +Str(FakVysHD ->nUhrCelFaZ) +Chr(13) +Chr(10)
                                FakVysHD ->mDolFakCis := FakVysHD ->mDolFakCis +cX

                                FakVysHD ->nKurZahMen := nKurz
                                FakVysHD ->nCenZakCel := FakVysHD ->nCenZahCel *FakVysHD ->nKurZahMen
                                FakVysHD ->nCenFakCel := FakVysHD ->nCenZahCel *FakVysHD ->nKurZahMen
                                FakVysHD ->nUhrCelFak := FakVysHD ->nUhrCelFaZ *FakVysHD ->nKurZahMen

                                FakVysHD ->nCisUzv := 557
                                FakVysHD ->( dbUnlock())
                        ENDIF
                ENDIF

          Box_Thermo( 0, nCount, nRecCount1)
    ( FakVysHd->( dbSkip()), nCount++ )
        EndDo

  Box_Thermo( -1)

//  fWrite( nHandle, Chr( 26), 1)
  fClose( nHandle)

        dbCloseAll()

Return(Nil)

*/