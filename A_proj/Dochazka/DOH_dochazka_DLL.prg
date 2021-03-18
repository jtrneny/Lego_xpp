#include "Common.ch"
#include "Xbp.ch"
#include "Drg.ch"
#INCLUDE 'DRGRES.ch'
#INCLUDE 'DBSTRUCT.ch'
#include "AppEvent.ch"
#include "Directry.ch"
#include "gra.ch"

#include "..\Asystem++\Asystem++.ch"


function AKTdspohyby( filedsp )
  local lOK, lZPET
  local nBEG, nEND
  local cKEYod, cKEYdo, cKEY
  local nLastDEN
  local dLastDAT
  local cTYP, cKEYs
  local cfiltr

  default filedsp to 'dspohybya'

  drgDBMS:open('dotermin',,,,,'dotermina')
  drgDBMS:open('dspohyby',,,,,filedsp)
  drgDBMS:open('c_prerus',,,,,'c_prerusa')
  drgDBMS:open('c_svatky')
  drgDBMS:open('c_pracsm',,,,,'c_pracsma')
  drgDBMS:open('kalendar',,,,,'kalendara')
  drgDBMS:open('osoby',,,,,'osobya')
  drgDBMS:open('osoby',,,,,'osobyp')


//  dotermina ->( dbSetRelation( 'Osobya'  , ;
//                     { || Upper( dotermina->cIdOsKarty) },   ;
//                         'Upper( dotermina->cIdOsKarty)'))
//  dotermina ->( dbSkip( 0))

  Osobya ->( dbSetRelation( 'c_pracsma'  , ;
                     { || Upper( Osobya->cTypSmeny) },   ;
                         'Upper( Osobya->cTypSmeny)'))
  Osobya ->( dbSkip( 0))

//  @ 5, 10 Say "Prùbìh aktualizace docházkového systému       "


  dotermina->( dbGoTop())
  cfiltr := Format("nStavAkt = 0", {})
  dotermina->( ads_setaof(cfiltr), dbGoTop())

  do while .not. dotermina->( Eof())
    lOK   := .T.
    lZPET := .F.
//    @ 5, 60 Say Str( Tmp_Term ->( Recno()))

// -----------------POZOR pøiøazení musí bít obrácennì -----------------
//

    do case
    case dotermina->cTypPrer = "IN"    ;    cTyp := 'ODC'
    case dotermina->cTypPrer = "OUT"   ;    cTyp := 'PRI'
    case dotermina->cTypPrer = "F1"    ;    cTyp := 'MPR'
    otherwise                          ;    cTyp := 'NIC'
    endcase

    cKEY := Padr( Upper( dotermina->cIdOsKarty), 25)              ;
                   + Upper(cTyp) +"00.00"                                ;
                    +StrZero( dotermina->nRok, 4)                 ;
                      +StrZero( dotermina->nMesic, 2)

    if dotermina->nDen <> 1
      cKEYod := cKEY +StrZero( dotermina->nDen -1, 2)
    else
      dLASTdat := dotermina->dDatum -1
      cKEYod   := Padr( Upper( dotermina->cIdOsKarty), 25) +Upper( cTyp) +"00.00"         ;
                   +StrZero( Year( dLASTdat), 4)    ;
                    +StrZero( Month( dLASTdat), 2)  ;
                     +StrZero( Day( dLASTdat), 2)
    endif

    do case
    case dotermina->ckodprer = "PRI"
      cKEYdo := cKEY +StrZero( dotermina->nDen+1, 2)
      ( filedsp)->( AdsSetOrder('DSPOHY07'), dbsetscope(SCOPE_TOP,cKEYod), dbsetscope(SCOPE_BOTTOM,cKEYdo), dbGoTop())
       do while .not.( filedsp) ->( Eof()) .and. lOK
         if ( filedsp)->nDen = dotermina->nDen
           if ( filedsp)->cCasEnd < dotermina->cCas
             lZPET := .T.
           else
             cKEYs := MODIpohyby( .F., "PRI",,,filedsp)
             lZPET := .F.
             lOK   := .F.
           endif
         else
           if ( filedsp)->cCasEnd < dotermina->cCas      // asi noŸn¡
             cKEYs := MODIpohyby( .F., "PRI",,,filedsp)
             lZPET := .F.
             lOK   := .F.
           endif
         endif
         ( filedsp)->( dbSkip())
       enddo

       if lOK
         if lZPET
           ( filedsp)->( dbSkip( -1))
           cKEYs := MODIpohyby( .F., "PRI",,,filedsp)
           lZPET := .F.
           lOK   := .F.
         else
           cKEYs := MODIpohyby( .T., "PRI",,,filedsp)
         endif
       endif
       ( filedsp)->( dbClearScope())

    case dotermina->ckodprer = "ODC"
      cKEYdo := cKEY +StrZero( dotermina->nDen, 2)
      ( filedsp)->( AdsSetOrder('DSPOHY06'), dbsetscope(SCOPE_TOP,cKEYod), dbsetscope(SCOPE_BOTTOM,cKEYdo), dbGoTop())
       do while .not.( filedsp)->( Eof()) .AND. lOK
         if ( filedsp)->nDen = dotermina->nDen
           if ( filedsp)->cCasBeg < dotermina->cCas
             lZPET := .T.
           else
             ( filedsp)->( dbSkip( -1))
             cKEYs := MODIpohyby( .F., "ODC",,,filedsp)
             lZPET := .F.
             lOK   := .F.
           endif
         else
           if ( filedsp)->cCasBeg > dotermina->cCas
             cKEYs := MODIpohyby( .F., "ODC",,,filedsp)
             lZPET := .F.
             lOK   := .F.
         // asi noŸn¡
           endif
         endif
         ( filedsp)->( dbSkip())
       enddo

       if lOK
         if lZPET
           ( filedsp)->( dbSkip( -1))
           cKEYs := MODIpohyby( .F., "ODC",,,filedsp)
         else
           cKEYs := MODIpohyby( .T., "ODC",,,filedsp)
         endif
       endif
      ( filedsp)->( dbClearScope())

      if( C_PracSma ->nTypPruzna = 2, PRUZnaSM_2(), NIL)

    case dotermina->ckodprer = "MPR"
      cKEYdo := cKEY +StrZero( dotermina->nDen, 2)
      ( filedsp)->( AdsSetOrder('DSPOHY06'), dbsetscope(SCOPE_TOP,cKEYod), dbsetscope(SCOPE_BOTTOM,cKEYdo), dbGoTop())
       do while !( filedsp)->( Eof()) .and. lOK
         if ( filedsp)->nDen = dotermina->nDen
           if ( filedsp)->cCasBeg < dotermina->cCas
             cKEYs := MODIpohyby( .F., "MPR",,,filedsp)
             lOK := .F.
           else
             lOK := .F.
           endif
         else
           if ( filedsp)->cCasBeg > dotermina->cCas
             cKEYs := MODIpohyby( .F., "MPR")  // asi noŸn¡
             lOK   := .F.
           endif
         endif
         ( filedsp)->( dbSkip())
       enddo
       if( lOK, cKEYs := MODIpohyby( .T., "MPR",,,,filedsp), NIL)
      ( filedsp)->( dbClearScope())

    endcase

    MODIcasy( cKEYs,0,filedsp)

    if dotermina->( Rlock())
      dotermina->nStavAkt := 1
      dotermina->( dbUnlock())
    endif

    dotermina->( dbSkip())

  enddo

  osobya->( DbClearRelation())
  dotermina->( ads_clearaof())

  osobyp->( dbGoTop())
  osobyp->( dbeval( {||if( rlock(), osobyp->nPritomen := PritomenDoch('osobyp'), nil) }))
  osobyp->( dbUnlock())

  dotermina->( dbCloseArea())
  (filedsp)->( dbCloseArea())
  c_prerusa->( dbCloseArea())
  c_svatky->( dbCloseArea())
  c_pracsma->( dbCloseArea())
  kalendara->( dbCloseArea())
  osobya->( dbCloseArea())
  osobyp->( dbCloseArea())

return( .t. )


function MODIpohyby( lNEW, cTYP, nDEN, cCAS, filedsp)
  local  nBEG, nEND
  local  cKEYs, cDEN

  default cCAS to dotermina->cCas
  default nDEN to dotermina->nDen

  cDEN := Str( nDEN)

  c_prerusa ->( dbseek( 'DOH'+Upper(cTYP),,'C_PRERUS05'))
//  C_Prerusa ->( dbSeek( Upper( cTYP)))
  osobya ->( dbSeek( dotermina->cIdOsKarty,,'OSOBY22'))

  if lNEW
//    AddREC( filedsp)
    mh_copyFld('osobya', filedsp, .t.)

//    ( filedsp)->nOsCisPrac := osobya->nOsCisPrac
//    ( filedsp)->cKmenStrPr := osobya->cKmenStrPr
//    ( filedsp)->cNazPol4   := osobya->cNazPol4
//    ( filedsp)->cRodCisPra := osobya->cRodCisOsb
//    ( filedsp)->cIdOsKarty := dotermina->cIdOsKarty
    ( filedsp)->cObdobi    := StrZero( dotermina->nMesic, 2) + "/"  ;
                              +SubStr( StrZero( dotermina->nRok, 4), 3, 4)
    ( filedsp)->nRok       := dotermina->nRok
    ( filedsp)->nObdobi    := dotermina->nMesic
    ( filedsp)->nMesic     := dotermina->nMesic
    ( filedsp)->nDen       := nDEN
    ( filedsp)->dDatum     := cTod( cDEN +"/" +dotermina->cMesic +"/"        ;
                                                 +dotermina->cRok)
    ( filedsp)->cZkrDne    := Left( cDOw( ( filedsp)->dDatum), 2)

    ( filedsp)->nCasTMP    := TimeToSec( cCas)/3600
  else
    ( filedsp)->( dbRlock())
  endif

  do case
  case cTYP = "PRI" .or. cTYP = "ODC"
    do case
    case cTYP = "PRI"
      if !lNEW
        ( filedsp)->cObdobi   := StrZero( dotermina->nMesic, 2) + "/"  ;
                                 +SubStr( StrZero( dotermina->nRok, 4), 3, 4)
        ( filedsp)->nRok      := dotermina->nRok
        ( filedsp)->nObdobi   := dotermina->nMesic
        ( filedsp)->nMesic    := dotermina->nMesic
        ( filedsp)->nDen      := nDEN
        ( filedsp)->dDatum    := cTod( cDEN +"/" +dotermina->cMesic +"/" +dotermina->cRok)
        ( filedsp)->cZkrDne   := Left( cDOw( ( filedsp)->dDatum), 2)
      endif
      ( filedsp)->cKodPrer   := "PRI"
      ( filedsp)->nKodPrer   := 1
      ( filedsp)->nKodZaokr  := c_prerusa ->nKodZaokr
      ( filedsp)->cCasBeg    := cCAS
      ( filedsp)->nCasBeg    := TimeToSec( ( filedsp)->cCasBeg)/3600
      ( filedsp)->nCasBegPD  := MH_RoundNumb( ( filedsp)->nCasBeg, C_Prerusa ->nKodZaokr)
      ( filedsp)->cAdrTerm   := dotermina->cAdrTerm
      ( filedsp)->cSNTerm    := dotermina->cSNTerm

    case cTYP = "ODC"
      ( filedsp)->cKodPrerE   := "ODC"
      ( filedsp)->nKodPrerE   := 2
      ( filedsp)->nKodZaokrE  := c_prerusa ->nKodZaokr
      ( filedsp)->cCasEnd     := cCAS
      ( filedsp)->nCasEnd     := TimeToSec( ( filedsp)->cCasEnd)/3600
      ( filedsp)->nCasEndPD   := MH_RoundNumb( ( filedsp)->nCasEnd, C_Prerusa ->nKodZaokr)
      ( filedsp)->cAdrTermE   := dotermina->cAdrTerm
      ( filedsp)->cSNTermE    := dotermina->cSNTerm
    endcase

  case cTYP = "MPR"
    if Empty( ( filedsp)->cCasBeg)
      ( filedsp)->cKodPrer   := "MPR"
      ( filedsp)->nKodPrer   := 8
      ( filedsp)->nKodZaokr  := c_prerusa ->nKodZaokr
      ( filedsp)->cCasBeg    := cCAS
      ( filedsp)->nCasBeg    := TimeToSec( ( filedsp)->cCasBeg)/3600
      ( filedsp)->nCasBegPD  := MH_RoundNumb( ( filedsp)->nCasBeg, C_Prerusa ->nKodZaokr)
      ( filedsp)->cAdrTerm   := dotermina->cAdrTerm
      ( filedsp)->cSNTerm    := dotermina->cSNTerm
    else
      ( filedsp)->cKodPrerE  := "MPR"
      ( filedsp)->nKodPrerE  := 8
      ( filedsp)->nKodZaokrE := c_prerusa ->nKodZaokr
      ( filedsp)->cCasEnd    := cCAS
      ( filedsp)->nCasEnd    := TimeToSec( ( filedsp)->cCasEnd)/3600
      ( filedsp)->nCasEndPD  := MH_RoundNumb( ( filedsp)->nCasEnd, C_Prerusa ->nKodZaokr)
      ( filedsp)->cAdrTermE  := dotermina->cAdrTerm
      ( filedsp)->cSNTermE   := dotermina->cSNTerm
    endif
  endcase

  ( filedsp)->nNapPrer   := C_Prerusa ->nNapPrer
  ( filedsp)->nSaySCR    := C_Prerusa ->nSaySCR
  ( filedsp)->nSayCRD    := C_Prerusa ->nSayCRD
  ( filedsp)->nSayPRN    := C_Prerusa ->nSayPRN
  ( filedsp)->nPritPrac  := C_Prerusa ->nPritPrac

  ( filedsp)->cRoObCpPPv := StrZero( ( filedsp)->nrok, 4) + ;
                             StrZero( ( filedsp)->nobdobi, 2) + ;
                               StrZero( ( filedsp)->noscisprac, 5) + ;
                                StrZero( ( filedsp)->nporpravzt, 3)

  mh_WRTzmena( filedsp, lNEW)

  ( filedsp)->( dbCommit(), dbUnlock())

  cKEYs := Padr( Upper( ( filedsp)->cIdOsKarty), 25)    ; //  StrZero( MsPrc_Md ->nOsCisPrac)            ;
            +StrZero( ( filedsp)->nRok, 4)      ;
             +StrZero( ( filedsp)->nMesic, 2)   ;
              +StrZero( ( filedsp)->nDen, 2)

return( cKEYs)


function MODIprest(filedsp)
  local  nX  := 0
  local  n   := 1
  local  lOK := .T.
  local  nCAStmp := (filedsp)->nCasCelCPD
  local  nPresCAS, nPresZaCAS

  nPresCAS   := IF( Empty( C_PracSma ->cTypSmeny), 0.5, C_PracSma ->nPresCas)
  nPresZaCAS := IF( Empty( C_PracSma ->cTypSmeny), 4.5, C_PracSma ->nPresZaCas)

  do while lOK .and. nX < 24
    nX := ( n - 1) * nPresCAS
    if (filedsp)->nCasCelCPD > ( ( nPresZaCAS *n) + nX)
      n++
    else
      (filedsp)->nCasPresta := nX
      lOK := .F.
    endif
  enddo

  (filedsp)->nCasCelCPD := (filedsp)->nCasCelCPD -(filedsp)->nCasPresta

return( nil)


function MODICasy( cKEYs, nGEN, filedsp)
  local  nTIME, nMIN
  local  cKEY, lNEW, nPOS, cTYP
  local  cNASTUPSM := ''
  local  nCelkPRI  := 0,  nCelkMPR := 0
  local  nCASnoc   := 0
  local  nCASrec   := 0
  local  nPrescas  := 0, nPrescasM := 0, nPrestavka := 0
  local  lEDIT     := .F.
  local  dFs_day
  local  cFS_day
  local  cTypPresc, cTypPrescM
  local  nRecPres := 0, nRecNoc := 0, nRecPresM := 0, nRecPresPr := 0
  local cOLDtag, nVAL, cVAL, cTMP
  local  nLastREC  := 0, nLastRECm := 0
  local  nCelkROZD := 0
  local  cOB_ym

  default nGEN to 0

//  drgDump( 'jsem v modi casy pøed otevøením souborù')

//  cOB_ym := uctOBDOBI:DOH:COBDOBI

  drgDBMS:open('c_pracsm',,,,,'c_pracsma')
  drgDBMS:open('c_prerus',,,,,'c_prerusa')
  drgDBMS:open('c_prerus',,,,,'c_prerusp')

//        LOCAL  nOldTAG := DsPohyby ->( OrdSetFOCUS())

  if IsNIL( cKEYs )
    cKEY := Padr( Upper( dotermina->cIdOsKarty), 25)    ; //  StrZero( MsPrc_Md ->nOsCisPrac)            ;
             +StrZero( dotermina->nRok, 4)      ;
              +StrZero( dotermina->nMesic, 2)   ;
               +StrZero( dotermina->nDen, 2)
  else
    if Select( 'DSPOHYBY') <> 0
      FORDREC( { 'DSPOHYBY,10' } )
    endif
    cKEY := cKEYs
  endIf

  nPOS    := Val( Right( cKEY, 2))

  dFs_day := CTOD( Right( cKEY,2) +'.'+Left( Right( cKEY,4),2)+'.'+Left( Right( cKEY,8),4))
  cFS_day := UPPER( LEFT( CDOW( dFS_day), 2))

  if c_SVATKY ->( dbSEEK( Right( cKEY, 8),,'C_SVATKY03'))
    cTYPpresc  := "PSV"
    cTYPprescM := "MSV"
  else
    cTYPpresc  := if( cFS_day = 'SO' .or. cFS_day = 'NE', "PSN", "PPD")
    cTYPprescM := if( cFS_day = 'SO' .or. cFS_day = 'NE', "MSN", "MPD")
  endIf

  (filedsp)->( AdsSetOrder('DSPOHY08'), dbsetscope(SCOPE_BOTH,cKEY), dbGoTop())
   do while .not.(filedsp)->( Eof())
     ReplREC( filedsp)

     lEDIT := if( .not.lEDIT, (filedsp)->lIsMANUAL, lEDIT)
     if (filedsp)->cKodPrer = "PPD" .or. (filedsp)->cKodPrer = "PSN" .or. (filedsp)->cKodPrer = "PSV"
       nRecPres := (filedsp)->( Recno())
     endif

     if (filedsp)->cKodPrer = "SNP" .or. (filedsp)->cKodPrer = "SVP"
       nRecPresPr := (filedsp)->( Recno())
     endif

     if (filedsp)->cKodPrer = "MPD" .or. (filedsp)->cKodPrer = "MSN" .or. (filedsp)->cKodPrer = "MSV"
       nRecPresM := (filedsp)->( Recno())
     endif

     if (filedsp)->cKodPrer = "PNO"
       nRecNoc := (filedsp)->( Recno())
     endif

     if Empty( cNASTUPSM)
       if (filedsp)->cKodPrer = "PRI" .OR. (filedsp)->cKodPrer = "MPR"
         do case
         case (filedsp)->cCasBeg > C_PracSma ->cRanSmeZac .and. !Empty( C_PracSma ->cRanSmeZac)
           (filedsp)->nCasBegPD := mh_RoundNumb( TimeToSec( (filedsp)->cCasBeg) /3600, (filedsp)->nKODzaokr)
           cNASTUPSM            := "RAN"

         case (filedsp)->cCasBeg <= C_PracSma ->cRanSmeZac                          ;
               .and. Padl( AllTrim( (filedsp)->cCasBeg), 5, "0") >= "05:00"        ;
                .and. !Empty( C_PracSma ->cRanSmeZac)                               ;
                 .and. !C_PracSma ->lRanPruzna
           (filedsp)->nCasBegPD := mh_RoundNumb( TimeToSec( C_PracSma ->cRanSmeZac) /3600, (filedsp)->nKODzaokr)
           cNASTUPSM            := "RAN"

         case (filedsp)->cCasBeg <= C_PracSma ->cOdpSmeZac                          ;
               .and. (filedsp)->cCasBeg >= "12:00"                                 ;
                .and. .not. Empty( C_PracSma ->cOdpSmeZac)                          ;
                 .and. .not. C_PracSma ->lOdpPruzna
           (filedsp)->nCasBegPD := mh_RoundNumb( TimeToSec( C_PracSma ->cOdpSmeZac) /3600, (filedsp)->nKODzaokr)
           cNASTUPSM            := "ODP"

         case (filedsp)->cCasBeg <= C_PracSma ->cNocSmeZac                          ;
               .and. (filedsp)->cCasBeg >= "20:00"                                 ;
                .and. !Empty( C_PracSma ->cNocSmeZac)                               ;
                 .and. !C_PracSma ->lNocPruzna
           (filedsp)->nCasBegPD := mh_RoundNumb( TimeToSec( C_PracSma ->cNocSmeZac) /3600, (filedsp)->nKODzaokr)
           cNASTUPSM            := "NOC"
         endcase
       endif
     endif

     if !Empty( cNASTUPSM) .and. (filedsp)->cKodPrerE = "ODC"
       do case
       case cNASTUPSM = "RAN"                                                          ;
             .and. (filedsp)->nCasEnd >= TimeToSec( C_PracSma ->cRanSmeKon) /3600       ;
              .and. (filedsp)->nCasEnd < mh_RoundNumb( TimeToSec( C_PracSma ->cRanSmeKon) /3600, C_PracSma ->nKodZaokKS)
//              .and. (filedsp)->nCasEnd < TimeToSec( C_PracSma ->cRanSmeKon) /3600 +0.5
         (filedsp)->nCasEndPD := mh_RoundNumb( TimeToSec( C_PracSma ->cRanSmeKon) /3600, (filedsp)->nKODzaokrE)
         (filedsp)->nCasEndSM := mh_RoundNumb( TimeToSec( C_PracSma ->cRanSmeKon) /3600, (filedsp)->nKODzaokrE)

       case cNASTUPSM = "ODP"                                                          ;
             .and. (filedsp)->nCasEnd >= TimeToSec( C_PracSma ->cOdpSmeKon) /3600       ;
              .and. (filedsp)->nCasEnd < mh_RoundNumb( TimeToSec( C_PracSma ->cOdpSmeKon) /3600, C_PracSma ->nKodZaokKS)
//            .and. (filedsp)->nCasEnd < TimeToSec( C_PracSma ->cOdpSmeKon) /3600 +0.5
         (filedsp)->nCasEndPD := mh_RoundNumb( TimeToSec( C_PracSma ->cOdpSmeKon) /3600, (filedsp)->nKODzaokrE)
         (filedsp)->nCasEndSM := mh_RoundNumb( TimeToSec( C_PracSma ->cOdpSmeKon) /3600, (filedsp)->nKODzaokrE)

       case cNASTUPSM == "NOC"                                                         ;
             .and. (filedsp)->nCasEnd >= TimeToSec( C_PracSma ->cNocSmeKon) /3600       ;
              .and. (filedsp)->nCasEnd < mh_RoundNumb( TimeToSec( C_PracSma ->cNocSmeKon) /3600, C_PracSma ->nKodZaokKS)
//              .and. (filedsp)->nCasEnd < TimeToSec( C_PracSma ->cNocSmeKon) /3600 +0.5
         (filedsp)->nCasEndPD := mh_RoundNumb( TimeToSec( C_PracSma ->cNocSmeKon) /3600, (filedsp)->nKODzaokrE)
         (filedsp)->nCasEndSM := mh_RoundNumb( TimeToSec( C_PracSma ->cNocSmeKon) /3600, (filedsp)->nKODzaokrE)

       endcase
     endif

     if !Empty( (filedsp)->cKodPrer) .and. !Empty( (filedsp)->cKodPrerE)
       if (filedsp)->nCasBeg <> 0 .or. (filedsp)->nCasEnd <> 0
         if (filedsp)->nCasEnd >= (filedsp)->nCasBeg
           (filedsp)->nCasCel    := (filedsp)->nCasEnd   -(filedsp)->nCasBeg
           (filedsp)->nCasCelPD  := (filedsp)->nCasEndPD -(filedsp)->nCasBegPD
           (filedsp)->nCasCelCPD := (filedsp)->nCasEndPD -(filedsp)->nCasBegPD
         else
           (filedsp)->nCasCel    := 24 -(filedsp)->nCasBeg
           (filedsp)->nCasCelPD  := 24 -(filedsp)->nCasBegPD
           (filedsp)->nCasCelCPD := 24 -(filedsp)->nCasBegPD
           (filedsp)->nCasCel    += (filedsp)->nCasEnd
           (filedsp)->nCasCelPD  += (filedsp)->nCasEndPD
           (filedsp)->nCasCelCPD += (filedsp)->nCasEndPD
         endif

         nTIME                 := (filedsp)->nCasCel*3600
         (filedsp)->cCasCel    := SubStr( SecToTime( nTIME), 1, 5)
         (filedsp)->nCasCelCPD := MH_RoundNumb( (filedsp)->nCasCelCPD, C_PracSma->nKodZaokr)

         if (filedsp)->nCasCelPD <> 0
           if C_Prerusa->( dbSeek( 'DOH'+ StrZero((filedsp)->nKodPrer,3),,'C_PRERUS06'))
             if C_Prerusa->lPrestavka
               MODIprest(filedsp)
               nPrestavka := (filedsp)->nCasPresta
             endif
           endif
         endif

         nCelkMPR  += if( (filedsp)->cKodPrer = "MPR", (filedsp)->nCasCelCPD, 0)
         nCelkPRI  += if( (filedsp)->cKodPrer = "PRI", (filedsp)->nCasCelCPD, 0)
         nCelkROZD += if( (filedsp)->cKodPrer == "PRI",(filedsp)->nCasCelCPD, 0)

         if nCelkPRI > TimeToSec( C_PracSma ->cRanSmeDel) /3600 .and. cTYPpresc = "PPD"
           nPrescas := nCelkPRI -TimeToSec( C_PracSma ->cRanSmeDel) /3600
         endif

         if nCelkPRI > 0 .and. ( cTYPpresc = "PSN" .or. cTYPpresc = "PSV")
           nPrescas := nCelkPRI
         endif

         if nCelkMPR > 0 .and. ( cTYPprescM = "MPD" .or. cTYPprescM = "MSN" .or. cTYPprescM = "MSV")
           nPrescasM := nCelkMPR
         endif

         if (!Empty( (filedsp)->cCasEnd) .and. (filedsp)->cCasEnd >= "22:00" ;
               .or.  (filedsp)->cCasEnd < (filedsp)->cCasBeg)                ;
                .and. ( (filedsp)->cKodPrer = "PRI" .or.  (filedsp)->cKodPrer = "MPR")
           if (filedsp)->cCasEnd < (filedsp)->cCasBeg
             if (filedsp)->cCasEnd < "06:00"
               if (filedsp)->nCasBeg > 22
                 nCASnoc += (filedsp)->nCasEnd +( 24 -(filedsp)->nCasBeg)  //CelPD
                 nCASrec := (filedsp)->nCasEnd +( 24 -(filedsp)->nCasBeg)  //CelPD
               else
                 nCASnoc += (filedsp)->nCasEnd + 2  //CelPD
                 nCASrec := (filedsp)->nCasEnd + 2  //CelPD
               endif
             else
               nCASnoc += 8.00                      //CelPD
               nCASrec := 8.00                      //CelPD
             endif
           endif
           if (filedsp)->cCasEnd >= "22:00"
             nCASnoc +=  (filedsp)->nCasEnd - 22.00  //   CelPD
             nCASrec :=  (filedsp)->nCasEnd  - 22.00  //   CelPD
           endif
         endif
       endif
     endif

     (filedsp)->nCasPresca := 0
     (filedsp)->nCasNocPri := 0
     (filedsp)->nRozdCasDe := 0

     if (filedsp)->nSaySCR = 1
       nLastREC  := if( (filedsp)->cKodPrer = "PRI", (filedsp)->( Recno()), 0)
       nLastRECm := if( (filedsp)->cKodPrer = "MPR", (filedsp)->( Recno()), 0)
     endif

     (filedsp)->( dbUnlock())
     (filedsp)->( dbSkip())
   enddo
   (filedsp)->( dbClearScope())

  if nPrescas > 0
    if !( lNEW := nRecPres = 0)
      (filedsp)->( dbGoTo( nRecPres))
      if( (filedsp)->lIsManual, nPrescas := (filedsp)->nCasCelPD, NIL)
    endif

    if ( cVAL = "PSN" .OR. cVAL = "PSV") .AND. nPrestavka <> 0
      nPrescas := nPrescas -nPrestavka
    endif

    cVAL := cTYPpresc
//    nVAL := MH_RoundNumb( nPrescas, 222)
    C_Prerusp->( dbSeek( 'DOH' +Upper( cVAL),,'C_PRERUS05'))
    nVAL := MH_RoundNumb( nPrescas, C_Prerusp->nKodZaokr)

    if !lEDIT .or. nGEN = 4
      MODIgenpoh( lNEW, cVAL, cKEY, nGEN, filedsp)

      (filedsp)->nCasCel    := nVAL
      (filedsp)->nCasCelPD  := (filedsp)->nCasCel
      (filedsp)->nCasCelCPD := (filedsp)->nCasCel

      nTIME := (filedsp)->nCasCel*3600
      (filedsp)->cCasCel := SubStr( SecToTime( nTIME), 1, 5)
      (filedsp)->( dbUnlock())
      if ( cTYPpresc = "PSN" .or. cTYPpresc = "PSV")
        if( !lNEW, (filedsp)->( dbGoTo( nRecPresPr)), NIL)
        if( (filedsp)->lIsManual, nPrescas := (filedsp)->nCasCelPD, NIL)
        cTMP := if( cTYPpresc = "PSN", "SNP", "SVP")
        MODIgenpoh( lNEW, cTMP, cKEY, nGEN, filedsp)

        (filedsp)->nCasCel    := nVAL
        (filedsp)->nCasCelPD  := (filedsp)->nCasCel
        (filedsp)->nCasCelCPD := (filedsp)->nCasCel
        nTIME                 := (filedsp)->nCasCel*3600
        (filedsp)->cCasCel    := SubStr( SecToTime( nTIME), 1, 5)
        (filedsp)->( dbUnlock())
      endif
    endif

    (filedsp)->( dbGoTo( nLastREC))
    if ReplREC( filedsp)
      (filedsp)->nCasPresca := nVAL
      (filedsp)->( dbUnlock())
    endif
  endif

  if nPrescasM > 0
    if !( lNEW := nRecPresM == 0)
      (filedsp)->( dbGoTo( nRecPresM))
    endif
    cVAL := cTYPprescM
//    nVAL := MH_RoundNumb( nPrescasM, 222)
    C_Prerusp->( dbSeek( 'DOH' +Upper( cVAL),,'C_PRERUS05'))
    nVAL := MH_RoundNumb( nPrescas, C_Prerusp->nKodZaokr)

    if !lEDIT .or. nGEN = 4
      MODIgenpoh( lNEW, cVAL, cKEY, nGEN, filedsp)

      (filedsp)->nCasCel    := nVAL
      (filedsp)->nCasCelPD  := (filedsp)->nCasCel
      (filedsp)->nCasCelCPD := (filedsp)->nCasCel
      nTIME                 := (filedsp)->nCasCel*3600
      (filedsp)->cCasCel    := SubStr( SecToTime( nTIME), 1, 5)
      (filedsp)->( dbUnlock())
    endif

    (filedsp)->( dbGoTo( nLastRECm))
    if ReplREC( filedsp)
      (filedsp)->nCasPresca := nVAL
      (filedsp)->( dbUnlock())
    endif
  endif

  if nCASnoc > 3.00
    if !( lNEW := nRecNoc = 0)
      (filedsp)->( dbGoTo( nRecNoc))
    endif

    C_Prerusp->( dbSeek( 'DOH' +Upper( "PNO"),,'C_PRERUS05'))

    if C_Prerusp->lAktivni
      nVAL := MH_RoundNumb( nCASnoc, C_Prerusp->nKodZaokr)

      MODIgenpoh( lNEW, "PNO", cKEY, nGEN, filedsp)
      (filedsp)->nCasCel    := nVAL
      (filedsp)->nCasCelPD  := (filedsp)->nCasCel
      (filedsp)->nCasCelCPD := (filedsp)->nCasCel

      nTIME                 := (filedsp)->nCasCel*3600
      (filedsp)->cCasCel    := SubStr( SecToTime( nTIME), 1, 5)
      (filedsp)->( dbUnlock())

      (filedsp)->( dbGoTo( nLastREC))
      if ReplREC( filedsp)
        (filedsp)->nCasNocPri := nVAL
        (filedsp)->( dbUnlock())
      endif
    endif
  endif

  if nCelkROZD > 0
    (filedsp)->( dbGoTo( nLastREC))
    if ReplREC( filedsp)
      (filedsp)->nRozdCasDe := nCelkROZD -TimeToSec( C_PracSma ->cRanSmeDel) /3600
      (filedsp)->( dbUnlock())
    endif
  endif

  if .not. IsNIL( cKEYs)
    if Select( 'DSPOHYBY') <> 0
      FORDREC()
    endif
  endif

return( nil)


function MODIgenpoh( lNEW, cTYP, cKEY, nGEN, filedsp)
  local  nBEG, nEND
//  local  cOLDtag := C_Prerusa ->( OrdSetFOCUS( 1))

  default nGEN TO 1

  C_Prerusa ->( dbSeek( 'DOH' +Upper( cTYP),,'C_PRERUS05'))
  osobya ->( dbseek( SubStr( cKEY, 1, 25),,'OSOBY22'))

  if lNEW
//    AddREC( filedsp)
    mh_copyFld('osobya', filedsp, .t.)

//    (filedsp)->nOsCisPrac := osobya ->nOsCisPrac
//    (filedsp)->cKmenStrPr := osobya ->cKmenStrPr
//    (filedsp)->cNazPol4   := osobya ->cNazPol4
//    (filedsp)->cRodCisPra := osobya ->cRodCisOsb
//    (filedsp)->cIdOsKarty := SubStr( cKEY, 1, 25)     //    Tmp_Term ->cIdOsKarty
    (filedsp)->cObdobi    := SubStr( cKEY, 30, 2) +"/"              ;
                              +SubStr( cKEY, 28, 2)
    (filedsp)->nRok       := Val( SubStr( cKEY, 26, 4))
    (filedsp)->nObdobi    := Val( SubStr( cKEY, 30, 2))
    (filedsp)->nMesic     := Val( SubStr( cKEY, 30, 2))
    (filedsp)->nDen       := Val( SubStr( cKEY, 32, 2))
    (filedsp)->dDatum     := cTod( SubStr( cKEY, 32, 2) +"/"        ;
                               +SubStr( cKEY, 30, 2) +"/"    ;
                                +SubStr( cKEY, 26, 4))
    (filedsp)->cZkrDne    := Left( cDOw( (filedsp)->dDatum), 2)
    (filedsp)->nCasTMP    := 99.99
  else
    (filedsp)->(dbRlock())
  endif

  (filedsp)->cKodPrer  := cTYP
  (filedsp)->nKodPrer  := C_Prerusa->nKodPrer
  (filedsp)->cKodPrerE := cTYP
  (filedsp)->nKodPrerE := C_Prerusa->nKodPrer
  (filedsp)->nNapPrer  := C_Prerusa->nNapPrer
  (filedsp)->nSaySCR   := C_Prerusa->nSaySCR
  (filedsp)->nSayCRD   := C_Prerusa->nSayCRD
  (filedsp)->nSayPRN   := C_Prerusa->nSayPRN
  (filedsp)->nPritPrac := C_Prerusa->nPritPrac

  (filedsp)->nGenREC   := nGEN
  mh_WRTzmena( filedsp, lNew)
//  ( filedsp)->( dbCommit(), dbUnlock())

//  C_Prerusa->( OrdSetFOCUS( cOLDtag))

return( nil)


function PRUZnaSM_2(filedsp)
  local  cKEY, cKEYs
//  local  nTAGold := (filedsp)->( OrdSetFOCUS( 6))
  local  nOD, n
  local  nTMcas, cTMcas

  for nOD := 1 to dotermina->nDen
    cKEY   := Padr( Upper( dotermina->cIdOsKarty), 25) +Upper( "PRI") +"00.00"      ;
                +StrZero( dotermina->nRok, 4)+StrZero( dotermina->nMesic, 2)+StrZero( nOD, 2)
    if (filedsp)->( dbSeek( cKEY,,'DSPOHY06'))
      LOOP
    endif
  next

  if nOD < dotermina->nDen
// --------- doplnit prvn¡ den kdy byl na cest ch a nemØl konec smØny --------
    nTMcas := (filedsp)->nCasBeg +TimeToSec( C_PracSma ->cRanSmDel)/3600
    if nTMcas <= 24
      cTMcas := SubStr( SecToTime( nTMcas *3600), 1, 5)
    else
      nTMcas := 24 - nTMcas
      cTMcas := SubStr( SecToTime( nTMcas *3600), 1, 5)
    endif

    cKEYs  := MODIpohyby( .F., "ODC", nOD, cTMcas,filedsp)
    MODIcasy( cKEYs,0,filedsp)
    nOD++

    for n := nOD to dotermina->nDen
      MODIpohyby( .T., "PRI", n, C_PracSma ->cRanSmeZac,filedsp)
      cTMcas := if( n = dotermina->nDen, dotermina->cCas, C_PracSma ->cRanSmeKon)
      cKEYs  := MODIpohyby( .F., "ODC", n, cTMcas,filedsp)
      MODIcasy( cKEYs,0,filedsp)
    next
  endif

//  (filedsp)->( OrdSetFOCUS( nTAGold))

return( nil)



function DOCH_cas( nBEG, nEND, cBEG, cEND, filedsp)
  local  cCasBeg, cCasEnd, cCasCel, cCasHod, cCasMin
  local  nCasBeg, nCasEnd
  local  nDaySec, nSecBeg, nSecEnd
  local  nCasCel, nCasDes
  local  ret
  local  aret := {'',0}

  default filedsp to 'dspohybya'

  nCasBeg := if( IsNIL( nBEG), (filedsp)->nCASbeg, nBEG)
  nCasEnd := if( IsNIL( nEND), (filedsp)->nCASend, nEND)
  cCasBeg := if( IsNIL( cBEG), (filedsp)->cCASbeg, cBEG)
  cCasEnd := if( IsNIL( cEND), (filedsp)->cCASend, cEND)

  nDaySec := if( nCasEnd <> 0 .and. ( nCasBeg > nCasEnd), 86400, 0 )

  nSecBeg := TimeToSec( cCasBeg)
  nSecEnd := ( nDaySec +TimeToSec( cCasEnd))

  cCasCel := SecToTime( Abs( nSecEnd -nSecBeg) )

  cCasHod := SubStr( cCasCel, 1, 2)
  cCasMin := SubStr( cCasCel, 4, 2)
  aret[1] := cCasHod + ':' + cCasMin

  nCasDes := Val( cCasMin)/60
  nCasCel := Val( cCasHod) +nCasDes
  aret[2] := nCasCel

  ret     :=  Val( Transform( Val( cCasHod) +nCasDes, '99.99' ))

//return( ret)
return( aret)


function PritomenDoch( file)
  local  isPritomen := .f.
  local  x_lastin, d_lastin
  local  x_lastout, d_lastout
//  local  file := Alias()

  x_lastin   := mh_DaTiAMPM_24((file)->tLastIn)
  x_lastout  := mh_DaTiAMPM_24((file)->tLastOut)

  d_lastin  := if( isCharacter(x_lastin) , ctod( left( x_lastin , 10 )), ctod('  .  .  ' ) )
  d_lastout := if( isCharacter(x_lastout), ctod( left( x_lastout, 10 )), ctod('  .  .  ' ) )

  if ( d_lastin = date() )
    isPritomen := .t.
    if ( d_lastin = d_lastout )
      isPritomen := isPritomen .and. x_lastin >= x_lastout
    endif
  endif

return if( isPritomen, 1, 0 )