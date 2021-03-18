#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dbstruct.ch"
*
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"
STATIC aCFG
STATIC nTypAutGHM


/*
//ÄÄÄÄÄÄÄÄÄÄÄÄDOPLÕUJÖCÖ NABÖDKA NA ALT_WÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
FUNCTION SCRhm_ALTW()
        Local  N, nPosIN
        Local  cC, cScreen := SaveSCREEN()
        Local  lDONE := .T., lIsRYO := .F.
        Local  GetList
        Local  aX, aMNu := { { 'generov n¡ ~MØs.mzdy     ', 'é H R A D A' }, ;
                                                                       { 'vìpoŸet ~Pr‚mi¡ z HV     ', 'O B D O B Ö' }, ;
                                                                                         { 'gener.mezd z ~Doch zky   ', 'O B D O B Ö' }, ;
                                                                       { 'zruçen¡ mØ~S.mzdy        ', 'O B D O B Ö' }, ;
                                                                       { 'zruçen¡ p~R‚mi¡ z HV     ', 'O B D O B Ö' }}
        LOCAL  axDEF_INS

        IF( nPosIN := xCHOICE( aMNu, 4, 50)) <> 0
                GEN_AutMZD( nPosIN)

    RestSCREEN( ,,,, cScreen)
          ScreenBROW( 1):RefreshALL()
//                DCIsUserMODI( "PrikUhHD", .T.)
        ENDIF

RETURN( NIL)

FUNCTION GEN_AutMZD( nPosIN)
        DO CASE
        CASE nPosIN == 1  ;  AUTGenMESm()
        CASE nPosIN == 2  ;  AUTGenPREM()
        CASE nPosIN == 3  ;  AUTGenDOCH()
        CASE nPosIN == 4  ;  DEL_AutDOK( 600000)
        CASE nPosIN == 5  ;  DEL_AutDOK( 700000)
        ENDCASE

RETURN( NIL)
*/

/*
function AUT_HMprac( nTESTdokl)

  DEFAULT nTESTdokl TO 0

  IF( !TESTcmObd() .AND. (nTESTdokl < 600000 .OR. nTESTdokl > 699999)    ;
         , AUTGenMESm( .T.), NIL)

return( NIL)
*/

function AUTGenMESm( lONE)
  local  nPOR := 1
  local  anFOND, aDNnem, aOST
  local  xKEY
  local  lOK, lGEN
  local  dDatFirst
  local  dDatLast
  local  dDatOd, dDatDo
  local  aCFG       := fCFGautVYP()
  local  nDelkPDhod := fPracDOBA( MsPrc_Mo->cDelkPrDob)[3]
  local  nOldREC, cOldTAG, cOldAREA

  DEFAULT lONE TO .F.

  drgDBMS:open('MzdDavHD',,,,,'mzddavhda')
  drgDBMS:open('MzdDavIt',,,,,'mzddavita')
  drgDBMS:open('MsPrc_Mo')
  drgDBMS:open('C_TypDMZ')


  DruhyMZD ->( dbsetRelation( 'c_typDMZ', { || DruhyMZD ->cTypDMZ },, 'C_TYPDMZ01' ))
  DruhyMZD ->( dbSkip( 0))

  dDatFirst := mh_FirstODate(uctOBDOBI:MZD:NROK,uctOBDOBI:MZD:NOBDOBI)
  dDatLast  := mh_LastODate(uctOBDOBI:MZD:NROK,uctOBDOBI:MZD:NOBDOBI)

  nTypAutGHM := SysConfig( "Mzdy:nTypAutGHm")
  aCFG       := fCFGautVYP()

  lGEN := IF( !lONE, drgIsYESNO(drgNLS:msg("Vygenerovat mìsíèní druhy mezd ")), .T.)
  if lGEN
    if( !lONE, msprc_mo ->( dbGoTop()), NIL)
      do while !msprc_mo ->( Eof()) .AND. lGEN
        lOK := .F.
*        M_Dav ->( OrdSetFOCUS(12))
*        xKEY := ACT_OBDn() + StrZero( MsPrc_Mz ->nOsCisPrac, 5)                ;
*                  + StrZero( MsPrc_Mz ->nPorPraVzt, 2)
        if msprc_mo ->lAutoVypHM .and.                                            ;
          ( msprc_mo ->cTypTarMZD = "MESICNI " .or.                          ;
             msprc_mo ->cTypTarMZD = "CASOVA  ")
          if !mzddavhd ->( dbSeek( StrZero(msprc_mo ->cRoObCpPPv,14) +StrZero( 600000 +msprc_mo ->noscisprac,6),,'MZDDAVHD01'))
            lOK := .T.
          else
*            lOK := !mzddavhda ->( dbSeek( msprc_mo-> +StrZero( 600000 +msprc_mo ->nOsCisPrac, 6) + "1" ))
            lOK := .not. mzddavhd ->lRucPoriz
            if( lOK, DEL_AutDOK( 600000, .T.), NIL)
          endif

          if lOK
            dDatOd := IF( dDatFirst >= msprc_mo->dDatNast, dDatFirst, msprc_mo->dDatNast)
            if ( dDatLast >= msprc_mo ->dDatVyst .and. msprc_mo ->dDatVyst > dDatFirst) ;
                .or. Empty( msprc_mo ->dDatVyst)
              lOK    := .T.
              dDatDo := if( Empty( msprc_mo ->dDatVyst), dDatLast, msprc_mo ->dDatVyst)
            else
              lOK := .F.
            endif
          endif
        endif

        if lOK
          anFOND := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

          if .not. lONE
            mh_CopyFLD( 'msprc_mo', 'mzddavhdw', .T.,, .T., .T.)
          endif

          mzddavhdw ->ctypdoklad := 'MZD_GENHM'
          mzddavhdw ->ctyppohybu := 'GENHMMZDA'
          mzddavhdw ->cdenik     := 'MH'
          mzddavhdw ->nDoklad    := nDokl +msprc_mo ->nOsCisPrac


          aOST       := ArrOSTo( StrZero(msprc_mo ->cRoObCpPPv,14))
          aDNnem     := ArrNEMo( StrZero(msprc_mo ->cRoObCpPPv,14))

          anFOND[1]  := D_DnyOdDo( dDatOd, dDatDo, "PRAC") + D_DnyOdDo( dDatOd, dDatDo, "SVAT")
          anFOND[12] := D_DnyOdDo( dDatOd, dDatDo, "PRAC")
          anFOND[2]  := anFOND[1] * nDelkPDhod
          anFOND[13] := anFOND[12] * nDelkPDhod
          anFOND[3]  := D_DnyOdDo( dDatOd, dDatDo, "PRAC") +D_DnyOdDo( dDatOd, dDatDo, "SVAT")   ;
                           -( aDNnem[1] + aOST[1])
          anFOND[14] := D_DnyOdDo( dDatOd, dDatDo, "PRAC")                                       ;
                           -( aDNnem[1] + aOST[1])
          anFOND[4]  := anFOND[ 2] - ( aDNnem[3] + aOST[2])
          anFOND[15] := anFOND[13] - ( aDNnem[3] + aOST[2])
          anFOND[9]  := D_DnyOdDo( dDatOd, dDatDo, "SVAT")
          anFOND[10] := D_DnyOdDo( dDatOd, dDatDo, "VOLN") - aDNnem[2]
          anFOND[16] := aOST[3]

          if anFOND[3] > 0
            do case
            case msprc_mo ->cTypTarMZD == "MESICNI "
              anFOND[5] := anFOND[4] + IF( aCFG[1] > 0, aOST[3] + aOST[4], 0)
              if( fSazTAR( Date())[2] <> 0 .and. aCFG[1] > 0, ( GenRADEKdok( 122, 600000, nPOR, anFOND), nPOR++), nil)
              if( fSazZAM( Date())[1] <> 0 .and. aCFG[4] > 0, ( GenRADEKdok( 150, 600000, nPOR, anFOND), nPOR++), nil)
              if( fSazZAM( Date())[2] <> 0 .and. aCFG[2] > 0, ( GenRADEKdok( 127, 600000, nPOR, anFOND), nPOR++), nil)
              if( fSazZAM( Date())[3] <> 0                  , ( GenRADEKdok( 156, 600000, nPOR, anFOND), nPOR++), nil)
            case msprc_mo ->cTypTarMZD == "CASOVA  "
              anFOND[5] := anFOND[15] + aOST[3] + aOST[4] + aOST[7]
              if( fSazTAR( Date())[1] <> 0 .and. aCFG[3] > 0, ( GenRADEKdok( 120, 600000, nPOR, anFOND), nPOR++), nil)
              if( fSazZAM( Date())[1] <> 0 .and. aCFG[4] > 0, ( GenRADEKdok( 150, 600000, nPOR, anFOND), nPOR++), nil)
              if( fSazZAM( Date())[2] <> 0 .and. aCFG[2] > 0, ( GenRADEKdok( 127, 600000, nPOR, anFOND), nPOR++), nil)
              if( fSazZAM( Date())[3] <> 0                  , ( GenRADEKdok( 156, 600000, nPOR, anFOND), nPOR++), nil)
              if msprc_mo ->nHodPrumPP <> 0 .and. aCFG[5] > 0 .AND. anFOND[9] > 0
*              if msvprum ->nHodPrumPP <> 0 .and. aCFG[5] > 0 .AND. anFOND[9] > 0
                anFOND[1] := anFOND[9]
                anFOND[2] := anFOND[1] * nDelkPDhod
                anFOND[5] := anFOND[3] := anFOND[1]
                anFOND[6] := anFOND[4] := anFOND[2]
                ( GenRADEKdok( 183, 600000, nPOR, anFOND), nPOR++)
              endif
            endcase
            if msprc_mo ->cTypTarMZD == "MESICNI "  .or. MsPrc_Mz ->cTypTarMZD == "CASOVA  "
              if aCFG[5] > 0 .and. anFOND[10] > 0
                anFOND[1] := anFOND[10]
                anFOND[2] := anFOND[1] * nDelkPDhod
                anFOND[5] := anFOND[3] := anFOND[1]
                anFOND[6] := anFOND[4] := anFOND[2]
                ( GenRADEKdok( 199, 600000, nPOR, anFOND), nPOR++)
              endif
            endif
          endif
*          WRT_MDavMz( xKEY)
        endif

        if( !lONE, msprc_mo ->( dbSkip()), lGEN := .F.)
      enddo
    endif

return nil


static function GenRADEKdok( nDMZ, nDokl, nPOR, anFPD)
  LOCAL cFILE := 'mzddavitw'
  LOCAL lOK := .T.
  LOCAL anX
  LOCAL nTMPsazba
  LOCAL nX

// nTypAutGHM = 1  -  TREFAL

  if IsNil( anFPD)
    anFPD := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  endif

  if nDMZ == 150
    do case
    case nTypAutGHM = 1
      if msprc_mo ->cTypTarMZD == "CASOVA  "
        nTMPsazba := mzddavitw ->nHrubaMZD    // * fSazZAM( Date())[1] / 100
      else
        nTMPsazba := mzddavitw ->nHrubaMZD    // * fSazZAM( Date())[1] / 100
      endif
    otherwise
      nTMPsazba := mzddavitw ->nHrubaMZD    // * fSazZAM( Date())[1] / 100
    endcase
  endif

  mh_CopyFLD( 'mzddavhdw', 'mzddavitw', .T.,, .T., .T.)

  mzddavitw ->nOrdItem   := nPOR *10
  mzddavitw ->cPracZarDo := msprc_mo ->cPracZar
  if Month( Date()) <> uctOBDOBI:MZD:NOBDOBI
    mzddavitw ->dDatPoriz := mh_LastODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI)
  else
    mzddavitw ->dDatPoriz := Date()
  endif

  mzddavitw ->cKmenStrSt := msprc_mo ->cKmenStrPr
  mzddavitw ->nZdrPojis  := msprc_mo ->nZdrPojis
  mzddavitw ->cTmKmStrPr := TMPkmenSTR( msprc_mo ->cKmenStrPr)
*  mzddavit ->cPracovnik := cPRACsort( "msprc_mo")
  mzddavitw ->nUcetMzdy  := 0

  PrednaNAKL( "mzddavitw")

  mzddavitw ->nDruhMzdy  := nDMZ

  do case
  case nDMZ = 122 .or. nDMZ = 120
    mzddavitw ->nDnyDoklad := if( nDMZ = 120, anFPD[14], anFPD[3])
    mzddavitw ->nHodDoklad := anFPD[5]

    mzddavitw ->nDnyFondKD := mzddavitw ->nDnyDoklad
    mzddavitw ->nDnyFondPD := mzddavitw ->nDnyDoklad
    mzddavitw ->nHodFondKD := mzddavitw ->nHodDoklad
    mzddavitw ->nHodFondPD := mzddavitw ->nHodDoklad

  case nDMZ = 127
    do case
    case nTypAutGHM = 1
      mzddavitw ->nSazbaDokl := fSazZAM( Date())[2]
//                        nX                 := Round( anFPD[15] +anFPD[16] / anFPD[13], 2)
//                        nX                 := anFPD[15] +anFPD[16]
//                  m_Dav ->nMnPDoklad := IF( nX > 1, 1, nX)
      mzddavitw ->nMnPDoklad := anFPD[5]
    otherwise
      mzddavitw ->nDnyDoklad := anFPD[3]
      mzddavitw ->nHodDoklad := anFPD[5]
    endcase
//    m_Dav ->nHodDoklad := anFPD[4]

  case nDMZ = 150
    mzddavitw ->nSazbaDokl := nTMPsazba
    mzddavitw ->nMnPDoklad := fSazZAM( Date())[1] / 100

/*
                IF lTREFAL
                        IF MsPrc_Mz ->cTypTarMZD == "CASOVA  "
                                nX := fSazZAM( Date())[1]
        m_Dav ->nSazbaDokl := nTMPsazba * ( fSazZAM( Date())[1] / 100)
                    m_Dav ->nMnPDoklad := anFPD[5]
                        ELSE
                                nX := fSazZAM( Date())[1]
        m_Dav ->nSazbaDokl := (nTMPsazba/anFPD[5]) * ( fSazZAM( Date())[1] / 100)
                    m_Dav ->nMnPDoklad := anFPD[5]
                        ENDIF
                ELSE
      m_Dav ->nSazbaDokl := nTMPsazba
                  m_Dav ->nMnPDoklad := fSazZAM( Date())[1] / 100
                ENDIF
*/

  case nDMZ = 156
    mzddavitw ->nSazbaDokl := fSazZAM( Date())[3]
//                nX                 := Round( ( ( anFPD[15] + anFPD[16]) / anFPD[13]), 2)
//                nX                 :=  anFPD[15] + anFPD[16]
//                m_Dav ->nMnPDoklad :=  nX
    mzddavitw ->nMnPDoklad := anFPD[5]

  case nDMZ = 199
    mzddavitw ->nDnyDoklad := anFPD[1]
    mzddavitw ->nHodDoklad := anFPD[2]

    mzddavitw ->nDnyFondKD := anFPD[3]
    mzddavitw ->nHodFondKD := anFPD[4]
  otherwise
    mzddavitw ->nDnyDoklad := anFPD[1]
    mzddavitw ->nHodDoklad := anFPD[2]
    mzddavitw ->nMnPDoklad := anFPD[11]

    mzddavitw ->nDnyFondKD := anFPD[3]
    mzddavitw ->nHodFondKD := anFPD[4]

    mzddavitw ->nDnyFondPD := anFPD[5]
    mzddavitw ->nHodFondPD := anFPD[6]

    mzddavitw ->nHodPresc  := anFPD[7]
    mzddavitw ->nHodPripl  := anFPD[8]
  endcase

//  anX := fSAZBA( ( cFILE) ->nDruhMzdy, cFILE)
//  VypocHm( anX, cFILE)
  if mzddavitw ->nDnyDoklad == 0 .and. mzddavitw ->nHodDoklad == 0             ;
     .and. mzddavitw ->nSazbaDokl == 0 .and. mzddavitw ->nMzda == 0
    mzddavitw ->( dbDelete())
  endif
*  MsPrc_Mz ->( OrdSetFOCUS( cTagMSp))
*  MsPrc_Mz ->( dbGoTo( nRecMSp))

return nil

// Vrací celkem nemoc za pracovn¡ka za obdob¡
static function ArrNEMo( xKEY)
  local aNEM := { 0, 0, 0, 0}

  xKEY := xKEY + Upper('MN')

  drgDBMS:open('MzdDavHD',,,,,'mzddavhdb')
  drgDBMS:open('MzdDavIt',,,,,'mzddavitb')

  if mzddavitb ->( dbSeek( xKEY))
    mzddavitb ->( AdsSetOrder('MZDDAVIT17'),dbsetScope(SCOPE_BOTH,xKEY),dbgotop())
     do while !mzddavitb ->( Eof())
       aNEM[1] += mzddavitb ->nVykazN_PD
       aNEM[2] += mzddavitb ->nVykazN_VD
       aNEM[3] += mzddavitb ->nHodFondPD
       aNEM[4] += mzddavitb ->nNemocNiSa + mzddavitb ->nNemocVySa
       mzddavitb ->( dbSkip())
     enddo
    mzddavitb ->( dbClearScope())
  endif

return( aNEM)


// Vrací celkem ostaní odpracovanou dobu za pracovníka za období
static function ArrOSTo( xKEY)
  local aOST := { 0, 0, 0, 0, 0, 0, 0, 0}
*  local nREC := m_Dav ->( Recno())
*  local nTAG := m_Dav ->( OrdSetFOCUS())

  xKEY := xKEY + Upper('MH')

  drgDBMS:open('MzdDavHD',,,,,'mzddavhdb')
  drgDBMS:open('MzdDavIt',,,,,'mzddavitb')

  if mzddavitb ->( dbSeek( xKEY))
    mzddavitb ->( AdsSetOrder('MZDDAVIT17'),dbsetScope(SCOPE_BOTH,xKEY),dbgotop())
     do while !mzddavitb ->( Eof())
       aOST[1] += mzddavitb ->nDnyFondPD
       aOST[2] += mzddavitb ->nHodFondPD
       aOST[3] += mzddavitb ->nHodPresc
       aOST[4] += mzddavitb ->nHodPrescS
       aOST[5] += mzddavitb ->nDnyFondKD
       aOST[6] += mzddavitb ->nHodFondKD
       if mzddavitb ->nDruhMzdy == 142
         aOST[7] += mzddavitb ->nHodDoklad
       endif
       aOST[8] += IF( C_TypDMZ ->cTypNapHoC == "OD", mzddavitb ->nHodDoklad, 0)
       aOST[8] -= IF( C_TypDMZ ->cTypNapHoC == "PR", mzddavitb ->nHodPresc, 0)

       mzddavitb ->( dbSkip())
     enddo
    mzddavitb ->( dbClearScope())
  endif

return( aOST)

/*
static function AUTGenPREM()
  LOCAL  nPOR
  LOCAL  anFOND, aDNnem, aOST
  LOCAL  xKEYod, xKEYdo
  LOCAL  lOK, nZaklad
  LOCAL  dDatFirst
  LOCAL  dDatLast
  LOCAL  dDatOd, dDatDo

  DruhyMZD ->( OrdSetFOCUS( 1))

  M_Dav ->( dbSetRelation( 'DruhyMZD'  , ;
            { || M_Dav ->nDruhMzdy } , ;
                 'M_Dav ->nDruhMzdy'   ) )
  M_Dav ->( dbSkip( 0))

  dDatFirst := CtoD( "01/" +StrZero( ACT_OBDon(), 2) +"/"     ;
                                  +StrZero( ACT_OBDyn(), 4))
        dDatLast  := CtoD( StrZero( LastDayOM( dDatFirst), 2) +"/"  ;
                                 +StrZero( ACT_OBDon(), 2) +"/"     ;
                                  +StrZero( ACT_OBDyn(), 4))

        IF Box_YesNo( "Vygenerovat pr‚mie z HV ") == 1

          MsPrc_Mz ->( dbGoTop())

          DO WHILE !MsPrc_Mz ->( Eof())
            lOK := .F.
                        dDatOd := IF( dDatFirst >= MsPrc_Mz ->dDatNast, dDatFirst, MsPrc_Mz ->dDatNast)
                        IF ( dDatLast >= MsPrc_Mz ->dDatVyst .AND. MsPrc_Mz ->dDatVyst > dDatFirst) ;
                                .OR. Empty( MsPrc_Mz ->dDatVyst)

                                lOK    := .T.
                                dDatDo := IF( Empty( MsPrc_Mz ->dDatVyst), dDatLast, MsPrc_Mz ->dDatVyst)
                        ENDIF
                        M_Dav ->( OrdSetFOCUS(1))
                  IF lOK .AND. MsPrc_Mz ->nMimoPrVzt = 0 .AND. MsPrc_Mz ->nSazPodHVP > 0  ;
                                  .AND. !M_Dav ->( dbSeek( ACT_OBDn()                                 ;
                                                                   +StrZero( MsPrc_Mz ->nOsCisPrac)         ;
                                                                                                                                                  +StrZero( MsPrc_Mz ->nPorPraVzt)        ;
                                                                                                                                                         +StrZero( 700000 +MsPrc_Mz ->nOsCisPrac, 6)))
                    GenRADEKdok( 154, 700000, 1)
                  ENDIF

                  MsPrc_Mz ->( dbSkip())
          ENDDO
        ENDIF

        DruhyMZD ->( dbClearRelat())

RETURN( NIL)
*/

/*
STATIC FUNCTION AUTGenDOCH()
        LOCAL  nPOR
        LOCAL  anFND, aDNnem, aOST
        LOCAL  xKEYod, xKEYdo
        LOCAL  lOK, nZaklad
        LOCAL  dDatFirst
        LOCAL  dDatLast
        LOCAL  dDatOd, dDatDo

        DruhyMZD ->( OrdSetFOCUS( 1))

  M_Dav ->( dbSetRelation( 'DruhyMZD'  , ;
            { || M_Dav ->nDruhMzdy } , ;
                 'M_Dav ->nDruhMzdy'   ) )
  M_Dav ->( dbSkip( 0))

  dDatFirst := CtoD( "01/" +StrZero( ACT_OBDon(), 2) +"/"     ;
                                  +StrZero( ACT_OBDyn(), 4))
        dDatLast  := CtoD( StrZero( LastDayOM( dDatFirst), 2) +"/"  ;
                                 +StrZero( ACT_OBDon(), 2) +"/"     ;
                                  +StrZero( ACT_OBDyn(), 4))

        IF Box_YesNo( "Vygenerovat data z modulu DOCHAZKA ") == 1

                TMPsumKON()

                C_Prerus ->( OrdSetFOCUS( 1))
          MsPrc_Mz ->( dbGoTop())
          TMp_OMETRp( .T.,, "Generov n¡ mezd z modulu DOCHAZKA...")
          TMp_OMETRp( 1, "MsPrc_Mz")

          DO WHILE !MsPrc_Mz ->( Eof())
            TMp_OMETRp( 0, "MsPrc_Mz")
            lOK := .F.
                        dDatOd := IF( dDatFirst >= MsPrc_Mz ->dDatNast, dDatFirst, MsPrc_Mz ->dDatNast)
                        IF ( dDatLast >= MsPrc_Mz ->dDatVyst .AND. MsPrc_Mz ->dDatVyst > dDatFirst) ;
                                .OR. Empty( MsPrc_Mz ->dDatVyst)

                                lOK    := .T.
                                dDatDo := IF( Empty( MsPrc_Mz ->dDatVyst), dDatLast, MsPrc_Mz ->dDatVyst)
                        ENDIF
                           M_Dav ->( OrdSetFOCUS(1))
                                IF lOK .AND. TmpSumKo ->( dbSeek( MsPrc_Mz ->nOsCisPrac))               ;
                                         .AND. !M_Dav ->( dbSeek( ACT_OBDn()                                  ;
                                                                   +StrZero( MsPrc_Mz ->nOsCisPrac)           ;
                                                                                                                                                  +StrZero( MsPrc_Mz ->nPorPraVzt)          ;
                                                                                                                                                         +StrZero( 800000 +MsPrc_Mz ->nOsCisPrac, 6)))
                                        nPOR  := 1
                             anFND := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                                  IF TmpSumKo ->nDovolenHo <> 0                                      ;
                                           .AND. C_Prerus ->( dbSeek( Cs_Upper( "DOV")))                   ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                               anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                        anFND[1] := TmpSumKo ->nDovolenDn
                        anFND[2] := TmpSumKo ->nDovolenHo
                                                anFND[5] :=        anFND[3] := anFND[1]
                                                anFND[6] :=        anFND[4] := anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nSvatkyHo <> 0                                        ;
                                           .AND. C_Prerus ->( dbSeek( Cs_Upper( "SVA")))                    ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0

                               anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                  anFND[1] := TmpSumKo ->nSvatkyDn
                  anFND[2] := TmpSumKo ->nSvatkyHo
                                                anFND[5] :=        anFND[3] := anFND[1]
                                                anFND[6] :=        anFND[4] := anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nNeplVolHo <> 0                                       ;
                                           .AND. C_Prerus ->( dbSeek( Cs_Upper( "NEV")))                    ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                               anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                  anFND[1] := TmpSumKo ->nNeplVolDn
                  anFND[2] := TmpSumKo ->nNeplVolHo
                                                anFND[5] :=        anFND[3] := anFND[1]
                                                anFND[6] :=        anFND[4] := anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nNahZMzdHo <> 0                                       ;
                                           .AND. C_Prerus ->( dbSeek( Cs_Upper( "NMZ")))                    ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                               anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                  anFND[1] := TmpSumKo ->nNahZMzdDn
                  anFND[2] := TmpSumKo ->nNahZMzdHo
                                                anFND[5] :=        anFND[3] := anFND[1]
                                                anFND[6] :=        anFND[4] := anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nRefuMzdHo <> 0                                      ;
                                           .AND. C_Prerus ->( dbSeek( Cs_Upper( "REF")))                   ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                               anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                  anFND[1] := TmpSumKo ->nRefuMzdDn
                  anFND[2] := TmpSumKo ->nRefuMzdHo
                                                anFND[5] :=        anFND[3] := anFND[1]
                                                anFND[6] :=        anFND[4] := anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nOstNahrHo <> 0                                    ;
                                           .AND. C_Prerus ->( dbSeek( Cs_Upper( "LEK")))                 ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                               anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                  anFND[1] := TmpSumKo ->nOstNahrDn
                  anFND[2] := TmpSumKo ->nOstNahrHo
                                                anFND[5] :=        anFND[3] := anFND[1]
                                                anFND[6] :=        anFND[4] := anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nAbsenceHo <> 0                                      ;
                                           .AND. C_Prerus ->( dbSeek( Cs_Upper( "ABS")))                   ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                               anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                  anFND[1] := TmpSumKo ->nAbsenceDn
                  anFND[2] := TmpSumKo ->nAbsenceHo
                                                anFND[5] :=        anFND[3] := anFND[1]
                                                anFND[6] :=        anFND[4] := anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nPresc25Ho <> 0                                     ;
                                           .AND. ( C_Prerus ->( dbSeek( Cs_Upper( "PPD")))                ;
                                                           .OR. C_Prerus ->( dbSeek( Cs_Upper( "MPD"))))        ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                               anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                        anFND[2] := TmpSumKo ->nPresc25Ho
                                                anFND[7] :=        anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nPresc50Ho <> 0                                     ;
                                           .AND. ( C_Prerus ->( dbSeek( Cs_Upper( "PSN")))                ;
                                                           .OR. C_Prerus ->( dbSeek( Cs_Upper( "MSN"))))        ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                               anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                        anFND[2] := TmpSumKo ->nPresc50Ho
                                                anFND[7] :=        anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nPripl10SN <> 0                                     ;
                                           .AND.  C_Prerus ->( dbSeek( Cs_Upper( "SNP")))                 ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                               anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                        anFND[2] := TmpSumKo ->nPripl10SN
                                                anFND[7] :=        anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nSvatPriHo <> 0                                     ;
                                           .AND. ( C_Prerus ->( dbSeek( Cs_Upper( "PSV")))                ;
                                                           .OR. C_Prerus ->( dbSeek( Cs_Upper( "MSV"))))        ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                              anFND     := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                        anFND[2] := TmpSumKo ->nSvatPriHo
                                                anFND[8] :=        anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nPripl10SV <> 0                                     ;
                                           .AND.  C_Prerus ->( dbSeek( Cs_Upper( "SVP")))                 ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                               anFND    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                        anFND[2] := TmpSumKo ->nPripl10SV
                                                anFND[7] :=        anFND[2]
                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF

                                  IF TmpSumKo ->nNocnPriHo <> 0                                     ;
                                           .AND. C_Prerus ->( dbSeek( Cs_Upper( "PNO")))                  ;
                                            .AND. C_Prerus ->nDruhMzdy <> 0
                              anFND     := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
                        anFND[2]  := TmpSumKo ->nNocnPriHo
                                                anFND[8]  :=        anFND[2]
                                                anFND[11] :=        anFND[2]

                         GenRADEKdok( C_Prerus ->nDruhMzdy, 800000, nPOR++, anFND)
                                        ENDIF


//                      TmpSumKo ->nNemocenHo += IF( cTYP == "NEM", DsPohyby ->nCasCelCPD, 0)
//                     TmpSumKo ->nOCRHo     += IF( cTYP == "OSE", DsPohyby ->nCasCelCPD, 0)

                                ENDIF

                  MsPrc_Mz ->( dbSkip())
          ENDDO
          TMp_OMETRp( -1)

        ENDIF

RETURN( NIL)


STATIC FUNCTION TMPsumKON()
        LOCAL  nROK  := ACT_OBDyn(), nMES := ACT_OBDon()
        LOCAL  lNewREC
        LOCAL  nREC_po
        LOCAL  cTAG_po
        LOCAL  cTYP
        LOCAL  paSETs
        LOCAL  n
        LOCAL  cALIAS := Alias()
        LOCAL  aPdDNY := {}, cFS_day
        LOCAL  lHRO   := .T.
        LOCAL  cScreen := SaveScreen()
        LOCAL  nCOUNT, nITEm := 1
        LOCAL  cKEY_prac
        LOCAL  nDNY_fond, nDNY_svat, aX := {}

        DC_DcOPEN( { 'DSPOHYBY,1', 'MsPrc_Mz,1' })
        DC_DcOPEN( { 'c_SVATKY,3', 'c_PRERUS,3', 'c_PRACSM,1', 'c_PRACDO,1'})

//        TmpSumKo ->( __dbZAP())

        nREC_po := DSPOHYBY ->( RECNO())
//         TmpSumKo ->( dbCloseArea())
        DCOpen( "TmpSumKo",, .T.)
  TmpSumKo ->( ORDsetFOCUS( 1),  __dbZAP(), sx_KILLTAG(.T.))
        dbSELECTAREA( 'TmpSumKo')
        INDEX on TmpSumKo ->nOsCisPrac TAG TmpSUK_01

        c_PRACDO ->( dbSEEK( CS_UPPER( MsPrc_Mz ->cDELKprDOB)))

        DSPOHYBY ->( dbSETRELATON( 'c_PRERUS', { || DSPOHYBY ->nKODPRER }, ;
                                                                                                                                                                                  'DSPOHYBY ->nKORPRER'   ))
        aX        := DOCH_kal()
        nDNY_fond := aX[1]
        nDNY_svat := aX[2]

  MsPrc_Mz ->( dbGoTop())

        TMp_OMETRp( .T.,, "Vytvoýen¡ podklad… pro generov n¡ mezd...")
        TMp_OMETRp( 1, "MsPrc_Mz")

  DSPOHYBY ->( OrdSetFOCUS( 1))
        nCOUNT := MsPrc_Mz ->( Sx_KeyCount())

        DO WHILE !MsPrc_Mz ->( Eof())
          TMp_OMETRp( 0, "MsPrc_Mz")
                aPdDNY    := {}
          cKEY_prac := STRZERO( MsPrc_Mz ->nOsCisPRAC) +ACT_OBDn()
          DSPOHYBY ->( Set_Scope( cKEY_prac))
                 DSPOHYBY ->( dbGoTop())
                 IF MsPrc_Mz ->nOsCisPrac == DSPOHYBY ->nOsCisPrac
             MH_CopyFld( "DSPOHYBY", "TmpSumKo", .T.)

             TmpSumKo ->nFondPDHo := DOCH_fond('HOD', 'PD', nDNY_fond, nDNY_svat)
             TmpSumKo ->nFondPDDn := DOCH_fond('DNY', 'PD', nDNY_fond, nDNY_svat)
             TmpSumKo ->nFondSVHo := DOCH_fond('HOD', 'SV', nDNY_fond, nDNY_svat)
             TmpSumKo ->nFondSVDn := DOCH_fond('DNY', 'SV', nDNY_fond, nDNY_svat)

             TmpSumKo ->nFondPSHo := TmpSumKo ->nFondPDHo +TmpSumKo ->nFondSVHo
             TmpSumKo ->nFondPSDn := TmpSumKo ->nFondPDDn +TmpSumKo ->nFondSVDn

             C_Svatky ->( OrdSetFOCUS( 1))

             DO WHILE !DSPOHYBY ->( EOF())
                     cTYP := AllTrim( DSPOHYBY ->cKodPrer)

                     IF cTYP == "PRI" .OR. cTYP == "MPR"
                       TmpSumKo ->nOdpracoHo += DsPohyby ->nCasCelCPD
                             IF cTYP == "PRI" .AND. DSPOHYBY ->cZkrDne <> "So"                     ;
                                        .AND. DSPOHYBY ->cZkrDne <> "Ne"                                  ;
                                                    .AND. !c_SVATKY ->( dbSEEK( DtoS( DSPOHYBY ->dDatum)))
                               IF( aScan( aPdDNY, DSPOHYBY ->nDen) == 0                            ;
                                                   , AAdd( aPdDNY, { DSPOHYBY ->nDen}), NIL)
                             ENDIF
                     ENDIF

                     TmpSumKo ->nDovolenHo += IF( cTYP == "DOV", DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nNemocenHo += IF( cTYP == "NEM", DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nSvatkyHo  += IF( cTYP == "SVA", DsPohyby ->nCasCelCPD, 0)
//                     TmpSumKo ->nNeplVolHo += IF( cTYP == "NEV", DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nOCRHo     += IF( cTYP == "OSE", DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nNahZMzdHo += IF( cTYP == "NMZ", DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nRefuMzdHo += IF( cTYP == "REF", DsPohyby ->nCasCelCPD, 0)
//                     TmpSumKo ->nAbsenceHo += IF( cTYP == "ABS", DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nOstNahrHo += IF( cTYP == "SOU" .OR. cTYP == "LEK"           ;
                                                    , DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nPresc25Ho += IF( cTYP == "PPD" .OR. cTYP == "MPD"           ;
                                                    , DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nPresc50Ho += IF( cTYP == "PSN" .OR. cTYP == "MSN"           ;
                                                    , DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nPripl10SN += IF( cTYP == "SNP", DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nSvatPriHo += IF( cTYP == "PSV" .OR. cTYP == "MSV"           ;
                                                    , DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nPripl10SV += IF( cTYP == "SVP", DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nNocnPriHo += IF( cTYP == "PNO", DsPohyby ->nCasCelCPD, 0)
                     TmpSumKo ->nOdmenyHo  += IF( cTYP == "MPR", DsPohyby ->nCasCelCPD, 0)

                                 IF cTYP == "NEV"
                       TmpSumKo ->nNeplVolHo += DsPohyby ->nCasCelCPD
                       TmpSumKo ->nNeplVolDn += IF( DsPohyby ->nCasCelCPD >= c_PRACDO ->nHodDen, 1, 0)
                                 ENDIF

                                 IF cTYP == "ABS"
                       TmpSumKo ->nAbsenceHo += DsPohyby ->nCasCelCPD
                       TmpSumKo ->nAbsenceDn += IF( DsPohyby ->nCasCelCPD >= c_PRACDO ->nHodDen, 1, 0)
                                 ENDIF

                     DSPOHYBY ->( dbSkip())
             ENDDO

             TmpSumKo ->nOdpracoDn := Len( aPdDNY)

             TmpSumKo ->nDovolenDn := MH_RoundNumb( TmpSumKo ->nDovolenHo /c_PRACDO ->nHodDen, 212)
             TmpSumKo ->nNemocenDn := MH_RoundNumb( TmpSumKo ->nNemocenHo /c_PRACDO ->nHodDen, 212)
             TmpSumKo ->nSvatkyDn  := MH_RoundNumb( TmpSumKo ->nSvatkyHo  /c_PRACDO ->nHodDen, 212)
//             TmpSumKo ->nNeplVolDn := MH_RoundNumb( TmpSumKo ->nNeplVolHo /c_PRACDO ->nHodDen, 212)
             TmpSumKo ->nOCRDn     := MH_RoundNumb( TmpSumKo ->nOCRHo     /c_PRACDO ->nHodDen, 212)
             TmpSumKo ->nNahZMzdDn := MH_RoundNumb( TmpSumKo ->nNahZMzdHo /c_PRACDO ->nHodDen, 212)
             TmpSumKo ->nRefuMzdDn := MH_RoundNumb( TmpSumKo ->nRefuMzdHo /c_PRACDO ->nHodDen, 212)

             TmpSumKo ->nOstNahrDn := MH_RoundNumb( TmpSumKo ->nOstNahrHo /c_PRACDO ->nHodDen, 212)
//             TmpSumKo ->nAbsenceDn := MH_RoundNumb( TmpSumKo ->nAbsenceHo /c_PRACDO ->nHodDen, 212)
                 ENDIF

          DSPOHYBY ->( Clr_Scope())

                nITEm++
                MsPrc_Mz ->( dbSkip())
        ENDDO

        TMp_OMETRp( -1)

        C_Prerus ->( dbClearRelat())

//        RESTSCREEN( ,,,, aSCREENs[1])
//        SETPOS( aSCREENs[2] +2, aSCREENs[3] +2 )

RETURN( NIL)


STATIC FUNCTION DOCH_fond( cTYP, cFND, nDNY_fond, nDNY_svat)            //Äzobrazen¡ FONDU_PDÄÄÄÄÄÄÄÄ
        Local nVAL := 0

  If     cTYP == 'DNY' .AND. cFND == "PD"  ;  nVAL := nDNY_fond
  ElseIf cTYP == 'DNY' .AND. cFND == "SV"  ;  nVAL := nDNY_svat
  ElseIf cTYP == 'HOD' .AND. cFND == "PD"  ;  nVAL := nDNY_fond * c_PRACDO ->nHODden
  ElseIf cTYP == 'HOD' .AND. cFND == "SV"  ;  nVAL := nDNY_svat * c_PRACDO ->nHODden
  EndIf

RETURN( nVAL)


Static Function DOCH_kal()
        Local  nFS_day, nLS_day, nPOS
        Local  dFs_day := CTOD( '01.' +STRTRAN( ACT_OBDnc(), '/', '.'))
        Local  cFS_day := UPPER( LEFT( CDOW( dFS_day), 2))
        Local  cOB_ym  := ACT_OBDn()
        Local  nDNY_fond
        Local         nDNY_svat

        C_Svatky ->( OrdSetFOCUS( 3))

        nDNY_fond := 0
        nDNY_svat := 0

        nLS_day   := LASTDAYOM( dFs_day)

        For nPOs := 1 To nLS_day STEP 1
                cFS_day := UPPER( LEFT( CDOW( dFS_day +nPOs -1), 2))
                If c_SVATKY ->( dbSEEK( cOB_ym +STRZERO( nPOs, 2)))        ;
                           .OR. cFS_day == 'SO' .OR. cFS_day == 'NE'
                        IF c_SVATKY ->( dbSEEK( cOB_ym +STRZERO( nPOs, 2)))        ;
                            .AND. cFS_day <> 'SO' .AND. cFS_day <> 'NE'
                          nDNY_svat++
                        ENDIF
                ELSE
                        nDNY_fond++
                EndIf
        Next

RETURN( { nDNY_fond, nDNY_svat })
*/


static function DEL_AutDOK( nDOKL, lPRAC)
  local  xKEYod, xKEYdo
  local  cTAG
  local  lOK := .F.

  default lPRAC TO .F.

  drgDBMS:open('MzdDavHD',,,,,'mzddavhdb')
  drgDBMS:open('MzdDavIt',,,,,'mzddavitb')

  if lPRAC
*    xKEYod := ACT_OBDn() +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt) +StrZero( nDOKL, 6)
*    xKEYdo := ACT_OBDn() +StrZero( MsPrc_Mz ->nOsCisPrac) +StrZero( MsPrc_Mz ->nPorPraVzt) +StrZero( nDOKL +99999, 6)
    xKEYod := StrZero(msprc_mo ->cRoObCpPPv,14) +StrZero( nDOKL, 6)
    xKEYdo := StrZero(msprc_mo ->cRoObCpPPv,14) +StrZero( nDOKL +99999, 6)
    cTAG   := 'MZDDAVIT01'
  else
    xKEYod := StrZero(uctOBDOBI:MZD:NROK,4) +StrZero(uctOBDOBI:MZD:NOBDOBI,2) +StrZero( nDOKL, 6)
    xKEYdo := StrZero(uctOBDOBI:MZD:NROK,4) +StrZero(uctOBDOBI:MZD:NOBDOBI,2) +StrZero( nDOKL +99999, 6)
    cTAG   := 'MZDDAVIT04'
  endif

  lOK := if( !lPRAC, drgIsYESNO(drgNLS:msg( "Zrušit doklady " +Str( nDOKL) +" - "+ Str( nDOKL+99999))), .T.)

  if lOK
    if( !lPRAC, drgNLS:msg(" Ruším doklady " +Str( nDOKL) +" - "+ Str( nDOKL+99999)), nil)
    mzddavhdb ->( AdsSetOrder(cTAG),dbsetScope(SCOPE_BOTH,xKEYod),dbsetscope(SCOPE_BOTTOM,xKEYdo),dbgotop())

*     IF( !lPRAC, Tmp_OMETRp( 1,"M_Dav"), NIL)
     do while !mzddavhdb ->( Eof())
*       IF( !lPRAC, Tmp_OMETRp( 0,"M_Dav"), NIL)
       if( mzddavhdb->(dbRLock()),mzddavhdb ->( dbDelete()), nil)
       mzddavhdb->( dbUnlock())
       mzddavhdb ->( dbSkip())
     enddo
    mzddavhdb ->( dbclearScope())
*    IF( !lPRAC, Tmp_OMETRp( -1), NIL)
  endif

return nil

function fCFGautVYP()
  local  cX := SysConfig( "Mzdy:cCFGAutVHM")
  local  aX := { 0, 0, 0, 0, 0, 0 }     //  122,127,120,150,183,199
  local  n

  for n := 1 to 6        ; aX[n] := Val( Token( cX, ",", n))
  next

return( aX)


function PrednaNakl( cFILE, cnaklst1)

  drgDBMS:open('c_nakstr',,,,,'c_nakstra')

  if c_nakstra->( dbSeek( Upper(cnaklst1) +"1",,'NAKSTR01'))
    ( cFILE)->cNazPol1 := c_nakstra->cNazPol1
    ( cFILE)->cNazPol2 := c_nakstra->cNazPol2
    ( cFILE)->cNazPol3 := c_nakstra->cNazPol3
    ( cFILE)->cNazPol4 := c_nakstra->cNazPol4
    ( cFILE)->cNazPol5 := c_nakstra->cNazPol5
    ( cFILE)->cNazPol6 := c_nakstra->cNazPol6
  else
//    BOX_Waring( "POZOR nenaçel jsem pro pracovn¡ka re§ijn¡ vazbu !!!" )
  endif


return nil