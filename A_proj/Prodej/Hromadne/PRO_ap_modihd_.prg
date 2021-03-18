#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "dbstruct.ch"


Static  anHD
Static  nFINtyp, nROUNDdph, nKOE, nKODzaokr, nPROCdan_1, nPROCdan_2, ;
        nSAZdanf_1, nSAZdanf_2, ;
        nCENzahCEL, nZAOKR
Static  dDAT


*
****************** vpoèet na fakvyshdw ****************************************
# xTRANSLATE .nOSVodDAN   => anHD\[1 \]
# xTRANSLATE .nZAKLdan_1  => anHD\[2 \]
# xTRANSLATE .nZAKLdan_2  => anHD\[3 \]
# xTRANSLATE .nHODNslev   => anHD\[4 \]
# xTRANSLATE .nCENzahCEL  => anHD\[5 \]
# xTRANSLATE .nPARzalFAK  => anHD\[6 \]
# xTRANSLATE .nPARzahFAK  => anHD\[7 \]
# xTRANSLATE .nCENzdan_1  => anHD\[8 \]
# xTRANSLATE .nCENzdan_2  => anHD\[9 \]
# xTRANSLATE .nCENzakcel  => anHD\[10\]


Function PRO_ap_modihd(cHp)
  local  nRECNo, nORDno := c_DPH ->( AdsSetOrder( 1))
  local  cIp  := STRTRAN( upper(cHp), 'HDW', 'ITW')
  local  nZAOKR := 0
  local  nOBJEM := 0, nHMOTNOST := 0
  local  nTYP_v := 1
  local  nVYP_c := VAL( RIGHT( SYSCONFIG('FINANCE:cVYPsazDPH'),1))  // CFG
  local  nVYP_f := VAL( RIGHT( (cHp) ->cVYPsazDAN,1))               // FAKVYSHD
//
  local  nZAKLdan_1, nSAZdan_1, nZAKLdan_2, nSAZdan_2

  anHD := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  nFINtyp    := (cHp) ->nFinTYP
  nROUNDdph  := (cHp) ->nKODZAOKRD    //   SysConfig( 'Finance:nRoundDph')
  nKOE       := (cHp) ->nKURzahMEN/(cHp) ->nMNOZprep
  nKODzaokr  := (cHp) ->nKODzaokr
  nPROCdan_1 := (cHp) ->nPROCdan_1
  nPROCdan_2 := (cHp) ->nPROCdan_2

  nZAKLdan_1 := nSAZdan_1 := nZAKLdan_2 := nSAZdan_2 := 0

  ( nRECNo := (cIp) ->( RECNO()), (cIp) ->( dbGOTOP()) )

  Do While !(cIp) ->( EOF())
    // prepocet polozek KURZEM //
    (cIp) ->nCENAzakl  := (cIp) ->nCeJPrKBZ * nKOe
    (cIp) ->nCENjedzak := (cIp) ->nCeJPrKBZ * nKOe
    (cIp) ->nCENjedzad := (cIp) ->nCeJPrKDZ * nKOe
    (cIp) ->nCENAzakc  := (cIp) ->nCeCPrZBZ * nKOe
    (cIp) ->nCENzakcel := (cIp) ->nCeCPrKBZ * nKOe
    (cIp) ->nCENzakced := (cIp) ->nCeCPrKDZ * nKOe
    (cIp) ->nSAZdan    := (cIp) ->nCENzakced - (cIp) ->nCENzakcel

    C_DPH ->( dbSEEK( (cIp) ->nKlicDph))

    Do Case
    Case ( c_Dph ->nNapocet == 0 )
      If( (cIp) ->nNULLdph == 4 .or. (cIp) ->nNULLdph == 14 )
        ( .nPARzalFAK += (cIp) ->nCENzakCEL, .nPARzahFAK += (cIp) ->nCENzahCEL )
        If     (cIp) ->nNAPOCET == 1
          nZAKLdan_1 += (cIp) ->nCENzakCEL
          nSAZdan_1  += (cIp) ->nSAZdan
        ElseIf (cIp) ->nNAPOCET == 2
          nZAKLdan_2 += (cIp) ->nCENzakCEL
          nSAZdan_2  += (cIp) ->nSAZdan
        EndIf
      Else
        .nOSVodDAN  += (cIp) ->nCeCPrKDZ
      EndIf

    Case ( c_Dph ->nNapocet == 1 ) ; .nZAKLdan_1 += (cIp) ->nCeCPrKBZ   // 1
                                                                                                                                                .nCENzdan_1 += (cIp) ->nCeCPrKDZ // 2
    Case ( c_Dph ->nNapocet == 2 ) ; .nZAKLdan_2 += (cIp) ->nCeCPrKBZ   // 1                                                                                                                                                 .nCENzdan_2 += (cIp) ->nCeCPrKDZ // 2
    EndCase

    nOBJEM      += (cIp) ->nOBJEM
    nHMOTNOST   += (cIp) ->nHMOTNOST
    .nCENzahCEL += (cIp) ->nCeCPrKDZ
    .nHODNslev  += (cIp) ->nCELKslev
    .nCENzakcel += (cIp) ->nCENzakcel

    (cIp) ->( dbSKIP())
  EndDo

  (cHp) ->nOBJEM     :=  nOBJEM
  (cHp) ->nHMOTNOST  :=  nHMOTNOST

  Do Case
  Case( nVYP_f <> 0 )  ;  nTYP_v := nVYP_f
  Case( nVYP_c <> 0 )  ;  nTYP_v := nVYP_c
  OtherWise
    nTYP_v := If((cHp) ->dPOVINfak >= CTOD('01.05.04'), 2, 1 )
  EndCase

  If nTYP_v == 2                                             //NEw od 1.5.2004
    .nOSVoddan  := MH_roundnumb( .nOSVoddan , nKODzaokr)
    .nCENzdan_1 := MH_roundnumb( .nCENzdan_1, nKODzaokr)
    .nCENzdan_2 := MH_roundnumb( .nCENzdan_2, nKODzaokr)

    EU_comphd(cHp, nZAOKR)
  Else

    AP_comphd(cHp)
  EndIf

  (cHp) ->nSAZdaz_1  := nSAZdan_1
  (cHp) ->nZAKLdaz_1 := nZAKLdan_1
  (cHp) ->nSAZdaz_2  := nSAZdan_2
  (cHp) ->nZAKLdaz_2 := nZAKLdan_2

  (cHp) ->nHODNslev   := .nHODNslev
  (cHp) ->nPARzahFAK  := .nPARzahFAK
  (cHp) ->nPARzalFAK  := .nPARzahFAK * nKOe

  (cHp) ->nCENzahCEL  := MH_roundnumb(.nCENzdan_1 + .nCENzdan_2 + .nOSVodDAN, nKODzaokr);
                                                                                                          +(cHp) ->nPARzahFAK

  If (cHp) ->cZKRATmeny == (cHp) ->cZKRATmenz
    (cHp) ->nCENzakCEL := (cHp) ->nCENzahCEL
  Else
    (cHp) ->nCENzakCEL  := MH_roundnumb(((cHp) ->nOsvOdDan  + ;
                                         (cHp) ->nZaklDan_1 +(cHp) ->nSazDan_1 + ;
                                         (cHp) ->nZaklDan_2 +(cHp) ->nSazDan_2), nKODzaokr) ;
                                        +(cHp) ->nPARzalFAK
  EndIf

  (cHp) ->nCENdanCel  := (cHp) ->nOsvOdDan  + ;
                         (cHp) ->nZaklDan_1 +(cHp) ->nZaklDan_2 + ;
                         (cHp) ->nZAKLdar_1 +(cHp) ->nZAKLdar_2

  (cHp) ->nZUSTpozao  := (cHp) ->nCENzakCEL - ;
                         ( .nCENzakcel + (cHp) ->nSAZdan_1 +(cHp) ->nSAZdan_2 + ;
                         nSAZdan_1   + nSAZdan_2  )

  C_Dph ->( AdsSetOrder( nOrdNO))
  (cIp) ->( dbGOTO(nRECNo))
Return( Nil)


Static Function AP_comphd(cHp)

  nSAZdanf_1 := MH_roundnumb(( .nZAKLdan_1 / 100) * nPROCdan_1, nRoundDPH )
  nSAZdanf_2 := MH_roundnumb(( .nZAKLdan_2 / 100) * nPROCdan_2, nRoundDPH )

  (cHp) ->nSAZdan_1   := MH_roundnumb(nSAZdanf_1  * nKOe, nRoundDPH ) //nKODzaokr)
  (cHp) ->nZAKLdan_1  := .nZAKLdan_1 * nKOe
  (cHp) ->nSAZdan_2   := MH_roundnumb(nSAZdanf_2  * nKOe, nRoundDPH ) //nKODzaokr)
  (cHp) ->nZAKLdan_2  := .nZAKLdan_2 * nKOe
  (cHp) ->nOSVodDAN   := .nOSVodDAN  * nKOe

  .nCENzdan_1         := MH_roundnumb(nSAZdanf_1 + .nZAKLdan_1, nKODzaokr)
  .nCENzdan_2         := MH_roundnumb(nSAZdanf_2 + .nZAKLdan_2, nKODzaokr)
Return( Nil)


Static Function EU_comphd(cHp, nZAOKR)

  nSAZdanf_1 := ;
   MH_roundnumb(ROUND(.nCENzdan_1 * ROUND((nPROCdan_1/(100 +nPROCdan_1)),4),2), nROUNDdph)

  nSAZdanf_2 := ;
   MH_roundnumb(ROUND(.nCENzdan_2 * ROUND((nPROCdan_2/(100 +nPROCdan_2)),4),2), nROUNDdph)

  (cHp) ->nSAZdan_1   := nSAZdanf_1 * nKOe
  (cHp) ->nZAKLdan_1  := (.nCENzdan_1 - nSAZdanf_1) * nKOe
  (cHp) ->nSAZdan_2   := nSAZdanf_2 * nKOe
  (cHp) ->nZAKLdan_2  := (.nCENzdan_2 - nSAZdanf_2) * nKOe
  (cHp) ->nOSVodDAN   := .nOSVodDAN * nKOe
Return( Nil)
