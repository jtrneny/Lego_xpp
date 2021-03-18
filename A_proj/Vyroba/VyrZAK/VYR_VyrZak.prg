/*==============================================================================
  VYR_VyrZAK.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
                       FakFilter()        RvSCR
  VYR_DelZAK           DelVyrZAK()        VZ.Prg
  VYR_PolOPERZ_MODI    PolOPERZ_MODI      VZ.Prg
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


* Zrušení výrobní zakázky ... na základì existence ObjHead, ListHD
*===============================================================================
FUNCTION VYR_VYRZAK_Del( lDelZAK)
  Local cKey := VyrZak->cCisZakaz
  Local cText // , cTag1, cTag2, cTag3
  Local lDEL := .T., lOK

  DEFAULT lDelZAK TO YES
*IF NazPol1_TST( 'VyrZAK', K_DEL, '3')
  cText := IF( lDelZAK, 'Výrobní zakázku < & > nelze zrušit, nebo ;',;
                        'Informace o rušené zakázce : '        )
*    cTag1 := ObjItem->( AdsSetOrder( 3))
*    cTag2 := ListHD->( AdsSetOrder( 3))
*    cTag3 := ObjZAK->( AdsSetOrder( 2))
    IF ObjItem->( dbSeek( Upper( cKey),, 'OBJITEM2' ))
       cText += '; - existují objednávky ( požadavky na materiál)'
       lDEL := .F.
    ENDIF
    IF ListHD->( dbSeek( Upper( cKey),, 'LISTHD3'))
       cText += '; - existují mzdové lístky na tuto zakázku'
       lDEL := .F.
    ENDIF
    IF VyrZAK->nMnozFakt > 0
       cText += '; - na zakázku již bylo fakturováno'
       lDEL := .F.
    ENDIF
    IF ObjZAK->( dbSEEK( Upper( cKey),, 'OBJZAK2'))
       cText += '; - existuje vztah na objednávky pøijaté'
       lDEL := .F.
    ENDIF
    * 29.10.2008
    IF PVPItem->( dbSEEK( '-1' + Upper( cKey),, 'PVPITEM11'))
       cText += '; - existují výdejové doklady na tuto zakázku'
       lDEL := .F.
    ENDIF

    IF lDelZAK
      IF lDEL
        IF drgIsYESNO(drgNLS:msg('Zrušit výrobní zakázku < & > ?', VyrZAK->cCisZakaz ) )
           DelREC( 'VyrZAK')
           IF drgIsYESNO(drgNLS:msg('Zrušit i kusovník a operace k výrobní zakázce < & > ?', cKEY ) )
*              FOrdREC( { 'Kusov, 1', 'PolOper, 1', 'VyrPol, 7' })
              VYR_PolOperZ_MODI( cKEY, 0 )
              DO WHILE Kusov->( dbSEEK( Upper( cKey),, 'KUSOV1'))
                 DelREC( 'Kusov')
              ENDDO
              DO WHILE PolOper->( dbSEEK( Upper( cKey),, 'POLOPER1'))
                 DelREC( 'PolOper')
              ENDDO
              dbSelectAREA( 'VyrPol')
              DO WHILE dbSEEK( Upper( cKey),, 'VYRPOL7')
                 DelREC( 'VyrPol')
              ENDDO
*              FOrdREC()
           ENDIF
           DO WHILE ZakaPAR->( dbSEEK( Upper( cKey),, 'ZAKAPAR_1'))
              DeLREC( 'ZakaPAR')
           ENDDO
           DO WHILE VyrZakIT->( dbSEEK( Upper( cKey),, 'ZAKIT_1'))
              DeLREC( 'VyrZakIT')
           ENDDO

           /*
           IF GetCFG( 'cVyrZakBut') == OPRAVY_EMISE
             DO WHILE ZakOprav->( dbSEEK( Cs_Upper( cKey)))
                DeLREC( 'ZakOprav')
             ENDDO
           ENDIF
           */
        ENDIF
      ELSE
        drgMsgBox(drgNLS:msg( cText, VYRZAK->cCisZakaz ) )
      ENDIF

    ELSE    // Zruší pouze okolí zakázky ( Kusov, PolOPER, VyrPOL )

      IF !lDEL
        drgMsgBox(drgNLS:msg( cText, VYRZAK->cCisZakaz ) )
      ENDIF
      IF drgIsYESNO(drgNLS:msg('Zrušit výrobní zakázku < & > ?', VyrZAK->cCisZakaz ) )
*         FOrdREC( { 'Kusov, 2', 'PolOper, 1', 'VyrPol, 7' })
         VYR_PolOperZ_MODI( cKEY, 0 )
         DO WHILE Kusov->( dbSEEK( Upper( cKey),, 'KUSOV2'))
*            DelREC( 'Kusov')
         ENDDO
         DO WHILE PolOPER->( dbSEEK( Upper( cKey),, 'POLOPER1'))
*            DelREC( 'PolOPER')
         ENDDO
         dbSelectAREA( 'VyrPol')
         DO WHILE dbSEEK( Upper( cKey),, 'VYRPOL7')
*            DelREC( 'VyrPol')
         ENDDO
*         FOrdREC()
      ENDIF

    ENDIF
*    ObjITEM->( AdsSetOrder( cTag1))
*    ListHD->( AdsSetOrder( cTag2))
*    ObjZAK->( AdsSetOrder( cTag3))
*ENDIF

RETURN Nil

*
*===============================================================================
FUNCTION VYR_PolOPERZ_MODI( cCisZAKAZ, nDAVKA)
  Local cTAG, cKEY

 DEFAULT nDAVKA TO 0
  drgDBMS:open('PracVAZ' )
  PracVAZ->( AdsSetOrder('PRVAZ_2'))
  *
  IF( Used('POLOPERZ' ), NIL, drgDBMS:open('POLOPERZ' ))
*  drgDBMS:open('POLOPERZ' )
  cTAG := PolOPERZ->( AdsSetOrder( 2))
  cKEY := Upper( cCisZAKAZ) + IF( nDAVKA == 0, '', StrZERO( nDAVKA, 2 ))
  PolOPERZ->( mh_SetScope( cKey ))
  DO WHILE !PolOPERZ->( EOF())
    IF PracVAZ->( dbSEEK( Upper( PolOperZ->cIdVazby)))
      PracVAZ->( RLock(), dbDelete(), dbUnlock() )
    ENDIF
    PolOPERZ->( RLock(), dbDelete(), dbUnlock() )
    PolOPERZ->( dbSKIP())
  ENDDO
  PolOPERZ->( mh_ClrScope(), dbCommit(), AdsSetOrder( cTAG))
RETURN NIL

*
*===============================================================================
FUNCTION VYR_isZakIT()
  Local cKey := Upper( VyrZAK->cCisZakaz), Filter, ret := 0
  *
  IF ( VyrZAK->nPolZAK  = 2 )
    drgDBMS:open('VyrZakIT',,,,, 'ZakITa')
    isZakIT := ZakITa->( dbSeek( cKey,,'ZAKIT_1'))
    ret := IF(isZakIT, DRG_ICON_SELECTT, DRG_ICON_SELECTF)
*    ZakITa->( dbCloseArea())
  ELSE
    ret := 0
  ENDIF
  *
RETURN( ret )


/*
================================================================================
FUNCTION FakFILTER( cALIAS, lCLEAR )
  Local  cScope, N, nTAG
  Static nHANDLE_1, nHANDLE_2

  DEFAULT lCLEAR TO NO
  IF ScreenAREA() == 1
    IF UPPER( cALIAS) == 'FAKVYSIT'
      IF !ISNIL( nHANDLE_1)
         ( cALIAS)->( M6_FreeFILTER( nHANDLE_1))
         ( cALIAS)->( dbClearFILTER())
      ENDIF

      nHANDLE_1 := ( cALIAS)->( M6_NewFILTER())
      FOR N := 1 TO 2
        nTAG := IF( N == 1, 5, 10 )
        cSCOPE := IF( N == 1, Cs_Upper( VyrZAK->cNazPOL3 ) ,;
                              Cs_Upper( VyrZAK->cCisZAKAZ)  )
        ( cALIAS)->( M6_ADDSCOPED( nHANDLE_1, cSCOPE, cSCOPE, nTAG ))
        ( cALIAS)->( M6_SetAreaFILTER( nHANDLE_1), dbGoTOP() )
      NEXT
    ENDIF
    IF UPPER( cALIAS) == 'FAKVNPIT'
      IF !ISNIL( nHANDLE_2)
         ( cALIAS)->( M6_FreeFILTER( nHANDLE_2))
         ( cALIAS)->( dbClearFILTER())
      ENDIF

      nHANDLE_2 := ( cALIAS)->( M6_NewFILTER())
      FOR N := 1 TO 2
        nTAG := IF( N == 1, 4, 6 )
        cSCOPE := IF( N == 1, Cs_Upper( VyrZAK->cNazPOL3 ) ,;
                              Cs_Upper( VyrZAK->cCisZAKAZ)  )
        ( cALIAS)->( M6_ADDSCOPED( nHANDLE_2, cSCOPE, cSCOPE, nTAG ))
        ( cALIAS)->( M6_SetAreaFILTER( nHANDLE_2), dbGoTOP() )
      NEXT
    ENDIF
  ENDIF
  /*
  IF lCLEAR
    IF UPPER( cALIAS) == 'FAKVYSIT'
      IF !ISNIL( nHANDLE_1)
         ( cALIAS)->( M6_FreeFILTER( nHANDLE_1))
         ( cALIAS)->( dbClearFILTER())
      ENDIF
    ELSE
      IF !ISNIL( nHANDLE_2)
         ( cALIAS)->( M6_FreeFILTER( nHANDLE_2))
         ( cALIAS)->( dbClearFILTER())
      ENDIF
    ENDIF
  ENDIF
  */
/*
  IF ScreenAREA() == 1
    IF !ISNIL( nHANDLE)
       ( cALIAS)->( M6_FreeFILTER( nHANDLE))
       ( cALIAS)->( dbClearFILTER())
    ENDIF

    nHANDLE := ( cALIAS)->( M6_NewFILTER())
    FOR N := 1 TO 2
      IF     UPPER( cALIAS) == 'FAKVYSIT'  ;  nTAG := IF( N == 1, 5, 10 )
      ELSEIF UPPER( cALIAS) == 'FAKVNPIT'  ;  nTAG := IF( N == 1, 4, 4  )
      ENDIF
      cSCOPE := IF( N == 1, Cs_Upper( VyrZAK->cNazPOL3 ) ,;
                            Cs_Upper( VyrZAK->cCisZAKAZ)  )
      ( cALIAS)->( M6_ADDSCOPED( nHANDLE, cSCOPE, cSCOPE, nTAG ))
      ( cALIAS)->( M6_SetAreaFILTER( nHANDLE), dbGoTOP() )
    NEXT
  ENDIF

RETURN NIL
*/

/*
*===============================================================================
FUNCTION VYR_VYRZAK_UKONC()
  drgMsgBox(drgNLS:msg('UKONÈENÍ ZAKÁZKY ...'))
RETURN NIL
*/