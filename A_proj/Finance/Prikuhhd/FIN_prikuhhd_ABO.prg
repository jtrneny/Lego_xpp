#include "Common.ch"


static fileExp

static function numat(csub,cstring)
  local x, cnt := 0

  for x := 1 to len(cstring) step 1
    if(substr(cstring,x,1) = csub, cnt++, nil)
  next
return cnt


*
** 0100 __KOMERÈNÍ BANKA___________
function B_0100(cpar,cfileExp)
  local  oldDateFormat := SET( _SET_DATEFORMAT, 'dd.mm.yy')

  fileExp := cfileExp

  Do Case
  Case( cpar == 'GET')
  Case( cpar == 'EXP')  ;  If( B_0x00 ->nCISSTA_KM == 0, B_0100_KBD(), B_0100_BES() )
  Case( cpar == 'IMP')
  EndCase

 SET( _SET_DATEFORMAT, oldDateFormat)
Return( Nil)


static function B_0100_KBD()                     //__FORMÁT pøenosu KB_DATA_____
  Local  nPOs, nFILE_KPC
  Local  cC, cDATe, cDEN , cMES, cTAJKOD, cKODBAN
  Local      cDATs, cDENs, cMESs
  Local  aITMs     := {}, aSKUp := { 0, 0, 3 }

  cDATs := DTOC  ( DATE())
  cDENs := LEFT  ( cDATs, 2)
  cMESs := SUBSTR( cDATs, 4, 2)

  nPOs    := If( VAL( cDENs) == 1, 1, (( VAL( cDENs) -1) *6) +1 )
  cTAJKOD := SUBSTR( MEMOLINE( MEMOREAD( B_0x00 ->cNazTAB_Km), 186, VAL( cMESs)), ;
                     nPOs, 6 )

  cDATe := DTOC  ( PRIKUHHD ->dPrikUHR)
  cDEN  := LEFT  ( cDATe, 2)
  cMES  := SUBSTR( cDATE, 4, 2)

  aADD( aITMs, 'UHL1'                           + ;
               STRTRAN( DTOC( DATE()), '.', '') + ;
               B_0x00 ->cNazKLI_Km              + ;
               B_0x00 ->cCisKLI_Km              + ;
               STR( B_0x00 ->nFileOD_Km)        + ;
               STR( B_0x00 ->nFileDO_Km)        + ;
               B_0x00 ->cPevKOD_Km              + ;
               cTAJKOD                            )

  aADD( aITMs, '1 1501 '                     + ;
               STR( PRIKUHHD ->nFILE_EXP, 3) + ;
               B_0x00 ->cCisPOB_Km + ' '     + ;
               BANKY_Cr ->cKodBAN_Cr           )
  aADD( aITMs, '2 '                                                      + ;
                B_0100_UCT( PRIKUHHd ->cBANK_UCT) +' '                   + ;
                ALLTRIM( STRTRAN( STR( PRIKUHHd ->nCENzakCEL, 14, 2), '.', '' )) +' ' + ;
                STRTRAN( DTOC( PRIKUHHd ->dPrikUHR), '.', '')              )

  Do While !PRIKUHIT ->( EOF())
    cKODBAN := ALLTRIM( SUBSTR( PRIKUHIT ->cUCET, RAT( '/', PRIKUHIT ->cUCET) +1))
    cC := B_0100_UCT( PRIKUHIT ->cUCET    ) +' '              + ;
          ALLTRIM( STRTRAN( STR( PRIKUHIT ->nPRIuhrCEL, 12, 2), '.', '' )) +' ' + ;
          ALLTRIM( PRIKUHIT ->cVARSYM )    +' '               + ;
          cKODBAN +STRZERO( PRIKUHIT ->nKONSTSYMB,4)  +' '      + ;
          ALLTRIM( PRIKUHIT ->cSPECSYMB)

    aSKUp[1]++
    If( aSKUp[1] >30, B_0100_SKU( @aSKUp, aITMs), Nil )
    aSKUp[2] += PRIKUHIT ->nPRIuhrCEL
    aADD( aITMs, cC )
    PRIKUHIT ->( dbSKIP())
  EndDo

  B_0100_SKU( @aSKUp, aITMs)
  aADD( aITMs, '3 +' )
  aADD( aITMs, '5 +' )

  nFILE_KPC := FCREATE( ALLTRIM( B_0x00 ->cPatEXP_Km) +fileExp)
  aEVAL( aITMs, { |X| FWRITE( nFILE_KPC, X +CHR( 13) +CHR( 10)) })
  FCLOSE( nFILE_KPC)
return( Nil)


static function B_0100_BES()                     // FORMÁT pøenosu BEST_KB
  Local  nFILE_KPC, nODES_EXP := PRIKUHHD ->nODES_EXP
  Local  cC, cKODBAN
  Local  cFILE     := 'B_' +BANKY_Cr ->cKodBAN_Cr
  Local  aITMs     := {}, aSKUp := { 0, 0, 3 }

  *
  drgDBMS:open('prikuhhd',,,,,'best_kb')
  nodes_exp := 1

  best_kb->(AdsSetOrder('FDODHD2')                                          , ;
            dbsetScope(SCOPE_BOTH,upper(prikuhhd->ckodBan_cr) +dtos(date())), ;
            dbgotop()                                                       , ;
            dbeval({|| nodes_exp += best_kb->nitms_exp})                      )
  best_kb->(dbcloseArea())


  SET( _SET_DATEFORMAT, 'YY.MM.DD' )
  aADD( aITMs, 'HI'                             + ;
               '000'                            + ;
               STRZERO( B_0x00 ->nCISSTA_km, 6) + ;
               STRTRAN( DTOC( DATE()), '.', '') + ;
               SPACE(30)                        + ;
               B_0x00 ->cCISKLI_km              + ;
               B_0x00 ->cNAZKLI_km              + ;
               SPACE(274)                         )

  SET( _SET_DATEFORMAT, 'DD.MM.YY' )
  Do While !PRIKUHIT ->( EOF())
    cKODBAN   := ALLTRIM( SUBSTR( PRIKUHIT ->cUCET, RAT( '/', PRIKUHIT ->cUCET) +1))
    nODES_EXP := nODES_EXP +1

    cC := '01'                                                             + ;
          STRZERO( nODES_EXP, 5)                                           + ;
          DTOS( DATE())                                                    + ;
          DTOS( PRIKUHIT ->dUHRbanDNE )                                    + ;
          'CZK'                                                            + ;
          STRTRAN( STRZERO( PRIKUHIT ->nPRIuhrCEL, 16, 2 ), '.', '' )      + ;
          '0'                                                              + ;
          '0000'                                                           + ;
          STRZERO( PRIKUHIT ->nKONSTSYMB, 10)                              + ;
          SPACE(140)                                                       + ;
          SPACE(3)                                                         + ;
          BANKY_Cr ->cKODBAN_cr                                            + ;
          B_0100_UCT( PRIKUHHD ->cBANK_UCT, .T. )                          + ;
          STRZERO( VAL( LEFT( PRIKUHIT ->cVARSYM  , 10)), 10)              + ;
          STRZERO( VAL( LEFT( PRIKUHIT ->cSPECSYMB, 10)), 10)              + ;
          SPACE(30)                                                        + ;
          SPACE(3)                                                         + ;
          cKODBAN                                                          + ;
          B_0100_UCT( PRIKUHIT ->cUCET    , .T. )                          + ;
          STRZERO( VAL( LEFT( PRIKUHIT ->cVARSYM  , 10)), 10)              + ;
          STRZERO( VAL( LEFT( PRIKUHIT ->cSPECSYMB, 10)), 10)              + ;
          SPACE(30)                                                        + ;
          SPACE(9)

    aSKUp[1]++
    aSKUp[2] += PRIKUHIT ->nPRIuhrCEL
    aADD( aITMs, cC )
    PRIKUHIT ->( dbSKIP())
  EndDo

  SET( _SET_DATEFORMAT, 'YY.MM.DD' )
  aADD( aITMs, 'TI'                                                + ;
               '000'                                               + ;
               STRZERO( B_0x00 ->nCISSTA_km,6)                     + ;
               STRTRAN( DTOC( DATE()), '.', '')                    + ;
               STRZERO( aSKUp[1], 6)                               + ;
               STRTRAN( STRZERO( aSKUP[2], 19, 2 ), '.', '' )      + ;
               SPACE(177)                                          + ;
               '00000'                                             + ;
               SPACE(128)                                            )

  PRIKUHHD ->nITMS_EXP := aSKUP[1]

  nFILE_KPC := FCREATE( ALLTRIM( B_0x00 ->cPatEXP_Km) +fileExp )
  aEVAL( aITMs, { |X| FWRITE( nFILE_KPC, X +CHR( 13) +CHR( 10)) })
  FCLOSE( nFILE_KPC)
return( Nil)


static function B_0100_SKU( paSKUp, aITMs)       //__SUMA za SKUPIN____________
  Local  cSKUP := '2 '                                                      + ;
                  B_0100_UCT( PRIKUHHd ->cBANK_UCT) +' '                    + ;
                  ALLTRIM( STRTRAN( STR( paSKUp[2], 14, 2), '.', '' )) +' ' + ;
                  STRTRAN( DTOC( PRIKUHHd ->dPrikUHR), '.', '')

  aITMs[ paSKUp[3]] := cSKUP
  If( PRIKUHIT ->( EOF()), Nil, ( aADD( aITMs, '3 +' ) , ;
                                  aADD( aITMs, 'úú'  ) , ;
                                  paSKUp := { 0, 0, LEN( aITMs) } ))
return( Nil)


static function B_0100_UCT( cBANK_UCT, lIsBEST)  //__ÚPRAVA èísl úètu__________
  Local  nPOs
  Local  cUCET := ALLTRIM( cBANK_UCT), cUCETn

  DEFAULT lIsBEST TO .F.

  If( nPOs := RAT( '/', cBANK_UCT)) <> 0
    cUCET  := ALLTRIM( SubSTR( cBANK_UCT, 1, nPOs -1))
  EndIf

  cUCETn := cUCET

  Do Case
  Case NUMAT( '-', cUCET) == 0
  Case NUMAT( '-', cUCET) == 1
    If LEN( cUCET) > 11
      If LEN( SUBSTR( cUCET, AT( '-', cUCET) +1)) > 10
        cUCETn := STRTRAN( cUCET , '-', '' )
        cUCETn := STUFF  ( cUCETn, LEN( cUCETn) -9, 0, '-' )
      EndIf
    Else
      nPOs := AT( '-', cUCETn)
      If( LEN(cUCETn) -nPOs <= 3 )
        cUCETn := STRTRAN( cUCET, '-', '' )
      EndIf
    EndIf
  Case NUMAT( '-', cUCET) == 2
    nPOs   := AT( '-', cUCET)
    cUCETn := SUBSTR ( cUCET, 1, nPOs) + ;
              STRTRAN( SUBSTR( cUCET, nPOs +1), '-', '' )
  EndCase

  If lIsBEST
    If( nPOs := AT( '-', cUCETn)) <> 0
      cUCET  := PADL( SUBSTR( cUCETn, 1, nPOs -1),  6, '0' ) + ;
                PADL( SUBSTR( cUCETn,    nPOs +1), 10, '0' )
      cUCETn := cUCET
    Else
      If LEN(cUCETn) < 16
        cUCET  := PADL( cUCETn, 16, '0')
        cUCETn := cUCET
      EndIf
    EndIf
  EndIf
return( cUCETn)


*
** 0600 __GE Capital Bank, a.s._________________________________________________
function B_0600(cpar,cfileExp)
  local  oldDateFormat := SET( _SET_DATEFORMAT, 'dd.mm.yy')

  fileExp := cfileExp

  Do Case
  Case( cpar == 'GET')
  Case( cpar == 'EXP')  ;  B_0600_EXP()
  Case( cpar == 'IMP')
  EndCase

  SET( _SET_DATEFORMAT, oldDateFormat)
return( Nil)


static Function B_0600_EXP()
  Local  nPOs, nFILE_KPC
  Local  cC, cDATe, cDEN, cMES, cTAJKOD, cKODBAN
  Local  aITMs     := {}

  cDATe := DTOC  ( PRIKUHHD ->dPrikUHR)
  cDEN  := LEFT  ( cDATe, 2)
  cMES  := SUBSTR( cDATE, 4, 2)

  Do While !PRIKUHIT ->( EOF())
    cC := B_0600_UCT( PRIKUHHD ->cBANK_UCT, .F. )                   + ;
          B_0600_UCT( PRIKUHIT ->cUCET    , .T. )                   + ;
          '000'                                                     + ;
          '0000000000'                                              + ;
          B_0600_SYM( PRIKUHIT ->cSPECSYMB )                        + ;
          '0000000000'                                              + ;
          B_0600_SYM( PRIKUHIT ->cVARSYM   )                        + ;
          '                    '                                    + ;
          '                    '                                    + ;
          B_0600_SYM( PRIKUHIT ->nKONSTSYMB )                       + ;
          STRTRAN( STRZERO( PRIKUHIT ->nPRIuhrCEL, 15, 2), '.', '') + ;
          ' '                                                       + ;
          DTOS( PRIKUHHD ->dPRIKUHR )                               + ;
          '   '                                                     + ;
          '1'                                                       + ;
          '000'                                                     + ;
          '00'                                                      + ;
          '   '                                                     + ;
          '  '                                                      + ;
          '00000000'                                                + ;
          DTOS( DATE())                                             + ;
          '             '
    aADD( aITMs, cC)
    PRIKUHIT ->( dbSKIP())
  EndDo

  nFILE_KPC := FCREATE( ALLTRIM( B_0x00 ->cPatEXP_Km) +fileExp )
  aEVAL( aITMs, { |X| FWRITE( nFILE_KPC, X +CHR( 13) +CHR( 10)) })
  FCLOSE( nFILE_KPC)
return( Nil)


static Function B_0600_UCT( cBANK_UCT, lKODB)    //__ÚPRAVA èísla úètu__________
  Local  nPOs
  Local  cUCET := ALLTRIM( cBANK_UCT), cKODB, cUCETn
  Local  cZAKLuct, cPREDuct

  If( nPOs := RAT( '/', cBANK_UCT)) <> 0
    cUCET := ALLTRIM( SubSTR( cBANK_UCT, 1, nPOs -1))
    cKODB := ALLTRIM( SUBSTR( cBANK_UCT, nPOs +1))
  EndIf

  cUCETn := cUCET

  Do Case
  Case NUMAT( '-', cUCET) == 0
  Case NUMAT( '-', cUCET) == 1
    If LEN( cUCET) > 11
      If LEN( SUBSTR( cUCET, AT( '-', cUCET) +1)) > 10
        cUCETn := STRTRAN( cUCET , '-', '' )
        cUCETn := STUFF  ( cUCETn, LEN( cUCETn) -9, 0, '-' )
      EndIf
    Else
      nPOs := AT( '-', cUCETn)
      If( LEN(cUCETn) -nPOs <= 3 )
        cUCETn := STRTRAN( cUCET, '-', '' )
      EndIf
    EndIf
  Case NUMAT( '-', cUCET) == 2
    nPOs   := AT( '-', cUCET)
    cUCETn := SUBSTR ( cUCET, 1, nPOs) + ;
              STRTRAN( SUBSTR( cUCET, nPOs +1), '-', '' )
  EndCase

  If( nPOs := AT( '-', cUCETn)) <> 0
    cZAKLuct := STRTRAN( PADL( SUBSTR( cUCETn,    nPOs +1 ), 10 ), ' ', '0' )
    cPREDuct := STRTRAN( PADL( SUBSTR( cUCETn, 1, nPOs -1 ),  6 ), ' ', '0' )
  Else
    cZAKLuct := STRTRAN( PADL( cUCETn, 10 ), ' ', '0' )
    cPREDuct := '000000'
  EndIf
return( cZAKLuct +cPREDuct +If( lKODB, cKODB, ''))


static function B_0600_SYM(xSYMBOL)              // ÚPRAVA cspecsymb/nkonstsymb_
  Local  cC

  If IsCHARACTER( xSYMBOL )
    cC := PADL( ALLTRIM( SUBSTR( xSYMBOL, 1, 10 )), 10 )
  Else
    cC := PADL( ALLTRIM( STR( xSYMBOL )), 10 )
  EndIf
return( STRTRAN( cC, ' ', '0' ) )


*
** 0300 __OBCHODNÍ banka________________________________________________________
function B_0300(cpar,cfileExp)
  local  oldDateFormat :=  SET( _SET_DATEFORMAT, 'dd.mm.yy')

  fileExp := cfileExp

  Do Case
  Case( cpar == 'GET')
  Case( cpar == 'EXP')  ;  B_0800_EXP()
  Case( cpar == 'IMP')
  EndCase

  SET( _SET_DATEFORMAT, oldDateFormat)
Return( Nil)


*
** 0800 __SPOØITELNA___________________________________________________________
function B_0800(cpar,cfileExp)
  local  oldDateFormat :=  SET( _SET_DATEFORMAT, 'dd.mm.yy')

  fileExp := cfileExp

  Do Case
  Case( cpar == 'GET')
  Case( cpar == 'EXP')  ;  B_0800_EXP()
  Case( cpar == 'IMP')
  EndCase

  SET( _SET_DATEFORMAT, oldDateFormat)
return( Nil)


*
** 3400 __UNION banka___________________________________________________________
function B_3400(cpar,cfileExp)
  local  oldDateFormat :=  SET( _SET_DATEFORMAT, 'dd.mm.yy')

  fileExp := cfileExp

  Do Case
  Case( cpar == 'GET')
  Case( cpar == 'EXP')  ;  B_0800_EXP()
  Case( cpar == 'IMP')
  EndCase

  SET( _SET_DATEFORMAT, oldDateFormat)
return( Nil)

*
** 6700 __Všeobecná úvìrová_____________________________________________________
function B_6700(cpar,cfileExp)
  local  oldDateFormat :=  SET( _SET_DATEFORMAT, 'dd.mm.yy')

  fileExp := cfileExp

  Do Case
  Case( cpar == 'GET')
  Case( cpar == 'EXP')  ;  B_0800_EXP()
  Case( cpar == 'IMP')
  EndCase

  SET( _SET_DATEFORMAT, oldDateFormat)
return( Nil)


static Function B_0800_EXP()
  Local  nPOs, nFILE_KPC
  Local  cC, cDATe, cDEN , cMES, cTAJKOD, cKODBAN
  Local      cDATs, cDENs, cMESs
  Local  aITMs     := {}, aSKUp := { 0, 0, 3 }

  cDATs := DTOC  ( DATE())
  cDENs := LEFT  ( cDATs, 2)
  cMESs := SUBSTR( cDATs, 4, 2)

  nPOs    := If( VAL( cDENs) == 1, 1, (( VAL( cDENs) -1) *6) +1 )
  cTAJKOD := SUBSTR( MEMOLINE( MEMOREAD( B_0x00 ->cNazTAB_Km), 186, VAL( cMESs)), ;
                     nPOs, 6 )

  cDATe := DTOC  ( PRIKUHHD ->dPrikUHR)
  cDEN  := LEFT  ( cDATe, 2)
  cMES  := SUBSTR( cDATE, 4, 2)

  aADD( aITMs, 'UHL1'                    + ;
               STRTRAN( cDATe, '.', '')  + ;
               B_0x00 ->cNazKLI_Km       + ;
               B_0x00 ->cCisKLI_Km       + ;
               STR( B_0x00 ->nFileOD_Km) + ;
               STR( B_0x00 ->nFileDO_Km) + ;
               B_0x00 ->cPevKOD_Km       + ;
               cTAJKOD                     )
  aADD( aITMs, '1 1501 '                     + ;
               STR( PRIKUHHD ->nFILE_EXP, 3) + ;
               B_0x00 ->cCisPOB_Km + ' '     + ;
               BANKY_Cr ->cKodBAN_Cr           )
  aADD( aITMs, '2 '                                                      + ;
                B_0800_UCT( PRIKUHHd ->cBANK_UCT) +' '                   + ;
                ALLTRIM( STRTRAN( STR( PRIKUHHd ->nCENzakCEL, 14, 2), '.', '' )) +' ' + ;
                STRTRAN( DTOC( PRIKUHHd ->dPrikUHR), '.', '')              )

  Do While !PRIKUHIT ->( EOF())
    cKODBAN := ALLTRIM( SUBSTR( PRIKUHIT ->cUCET, RAT( '/', PRIKUHIT ->cUCET) +1))
    cC := B_0800_UCT( PRIKUHIT ->cUCET    ) +' '              + ;
          ALLTRIM( STRTRAN( STR( PRIKUHIT ->nPRIuhrCEL, 12, 2), '.', '' )) +' ' + ;
          ALLTRIM( PRIKUHIT ->cVARSYM )    +' '               + ;
          cKODBAN +STRZERO( PRIKUHIT ->nKONSTSYMB,4)  +' '      + ;
          ALLTRIM( PRIKUHIT ->cSPECSYMB)            +' '      + ;
          LEFT(prikuhit->cTextPol,35)

    aSKUp[1]++
    If( aSKUp[1] >30, B_0800_SKU( @aSKUp, aITMs), Nil )
    aSKUp[2] += PRIKUHIT ->nPRIuhrCEL
    aADD( aITMs, cC )
    PRIKUHIT ->( dbSKIP())
  EndDo

  B_0800_SKU( @aSKUp, aITMs)
  aADD( aITMs, '3 +' )
  aADD( aITMs, '5 +' )

  nFILE_KPC := FCREATE( ALLTRIM( B_0x00 ->cPatEXP_Km) +fileExp )
  aEVAL( aITMs, { |X| FWRITE( nFILE_KPC, X +CHR( 13) +CHR( 10)) })
  FCLOSE( nFILE_KPC)
return( Nil)


static Function B_0800_SKU( paSKUp, aITMs)       //__SUMA za skupinu____________
  Local  cSKUP := '2 '                                                      + ;
                  B_0800_UCT( PRIKUHHd ->cBANK_UCT) +' '                    + ;
                  ALLTRIM( STRTRAN( STR( paSKUp[2], 14, 2), '.', '' )) +' ' + ;
                  STRTRAN( DTOC( PRIKUHHd ->dPrikUHR), '.', '')

  aITMs[ paSKUp[3]] := cSKUP
  If( PRIKUHIT ->( EOF()), Nil, ( aADD( aITMs, '3 +' ) , ;
                                  aADD( aITMs, 'úú'  ) , ;
                                  paSKUp := { 0, 0, LEN( aITMs) } ))
return( Nil)


Static Function B_0800_UCT( cBANK_UCT)           //__úprava èísla úètu__________
  Local  nPOs
  Local  cUCET := ALLTRIM( cBANK_UCT), cUCETn

  If( nPOs := RAT( '/', cBANK_UCT)) <> 0
    cUCET  := ALLTRIM( SubSTR( cBANK_UCT, 1, nPOs -1))
  EndIf

  cUCETn := cUCET

  Do Case
  Case NUMAT( '-', cUCET) == 0
  Case NUMAT( '-', cUCET) == 1
    If LEN( cUCET) > 11
      If LEN( SUBSTR( cUCET, AT( '-', cUCET) +1)) > 10
        cUCETn := STRTRAN( cUCET , '-', '' )
        cUCETn := STUFF  ( cUCETn, LEN( cUCETn) -9, 0, '-' )
      EndIf
    Else
      nPOs := AT( '-', cUCETn)
      If( LEN(cUCETn) -nPOs <= 3 )
        cUCETn := STRTRAN( cUCET, '-', '' )
      EndIf
    EndIf
  Case NUMAT( '-', cUCET) == 2
    nPOs   := AT( '-', cUCET)
    cUCETn := SUBSTR ( cUCET, 1, nPOs) + ;
              STRTRAN( SUBSTR( cUCET, nPOs +1), '-', '' )
  EndCase
return( cUCETn)


*
** 5500 __Raiffeisenbank, a.s._________________________________________________
Function B_5500(cpar,cfileExp)
  local  oldDateFormat := SET( _SET_DATEFORMAT, 'yy.mm.dd')

  fileExp := cfileExp

  Do Case
  Case( cpar == 'GET')
  Case( cpar == 'EXP')  ;  B_5500_EXP()
  Case( cpar == 'IMP')
  EndCase

  SET( _SET_DATEFORMAT, oldDateFormat)
return( Nil)


static Function B_5500_EXP()
  Local  nRADEK := 1, nFILE_KPC
  Local  cC
  Local  aITMs     := {}

  Do While !PRIKUHIT ->( EOF())
    cC := STRZERO( nRADEK,6)                                        + ;
          '11'                                                      + ;
          SUBSTR( DTOS(DATE()),3)                                   + ;
          '5500'                                                    + ;
          '   '                                                     + ;
          B_5500_KOD( PRIKUHIT ->cUCET      )                       + ;
          '   '                                                     + ;
          STRTRAN( STRZERO( PRIKUHIT ->nPRIuhrCEL, 16, 2), '.', '') + ;
          SUBSTR( DTOS( PRIKUHHD ->dPRIKUHR ),3)                    + ;
          B_5500_SYM( PRIKUHIT ->nKONSTSYMB )                       + ;
          B_5500_SYM( PRIKUHIT ->cVARSYM    )                       + ;
          B_5500_SYM( PRIKUHIT ->cSPECSYMB  )                       + ;
          B_5500_UCT( PRIKUHHD ->cBANK_UCT  )                       + ;
          B_5500_UCT( PRIKUHIT ->cUCET      )                       + ;
          SPACE(140)                                                + ;
          SPACE( 20)                                                + ;
          SPACE( 20)                                                + ;
          '0000000000'                                              + ;
          '0000000000'                                              + ;
          SPACE(140)                                                + ;
          SPACE(140)

    aADD( aITMs, cC)
    PRIKUHIT ->( dbSKIP())
    nRADEK++
  EndDo

  nFILE_KPC := FCREATE( ALLTRIM( B_0x00 ->cPatEXP_Km) +fileExp )
  aEVAL( aITMs, { |X| FWRITE( nFILE_KPC, X +CHR( 13) +CHR( 10)) })
  FCLOSE( nFILE_KPC)
return( Nil)


static Function B_5500_KOD(cBANK_uct)            //__kód banky pøíjemce_________
  Local  nPOs
  Local  cKODB := '0000'

  If( nPOs := RAT( '/', cBANK_uct)) <> 0
    cKODB := ALLTRIM( SUBSTR( cBANK_UCT, nPOs +1))
  EndIf
return( cKODB)


static Function B_5500_UCT(cBANK_UCT)            //__úprava èísla úètu__________
  Local  nPOs
  Local  cUCET := ALLTRIM( cBANK_UCT), cKODB, cUCETn
  Local  cZAKLuct, cPREDuct

  If( nPOs := RAT( '/', cBANK_UCT)) <> 0
    cUCET := ALLTRIM( SubSTR( cBANK_UCT, 1, nPOs -1))
    cKODB := ALLTRIM( SUBSTR( cBANK_UCT, nPOs +1))
  EndIf

  cUCETn := cUCET

  Do Case
  Case NUMAT( '-', cUCET) == 0
  Case NUMAT( '-', cUCET) == 1
    If LEN( cUCET) > 11
      If LEN( SUBSTR( cUCET, AT( '-', cUCET) +1)) > 10
        cUCETn := STRTRAN( cUCET , '-', '' )
        cUCETn := STUFF  ( cUCETn, LEN( cUCETn) -9, 0, '-' )
      EndIf
    Else
      nPOs := AT( '-', cUCETn)
      If( LEN(cUCETn) -nPOs <= 3 )
        cUCETn := STRTRAN( cUCET, '-', '' )
      EndIf
    EndIf
  Case NUMAT( '-', cUCET) == 2
    nPOs   := AT( '-', cUCET)
    cUCETn := SUBSTR ( cUCET, 1, nPOs) + ;
              STRTRAN( SUBSTR( cUCET, nPOs +1), '-', '' )
  EndCase

  If( nPOs := AT( '-', cUCETn)) <> 0
    cZAKLuct := STRTRAN( PADL( SUBSTR( cUCETn,    nPOs +1 ), 10 ), ' ', '0' )
    cPREDuct := STRTRAN( PADL( SUBSTR( cUCETn, 1, nPOs -1 ),  6 ), ' ', '0' )
  Else
    cZAKLuct := STRTRAN( PADL( cUCETn, 10 ), ' ', '0' )
    cPREDuct := '000000'
  EndIf
Return( cPREDuct +cZAKLuct )


static Function B_5500_SYM( xSYMBOL )            //__úprava cspecsymb/nkonstsym_
  Local  cC

  If IsCHARACTER( xSYMBOL )
    cC := PADL( ALLTRIM( SUBSTR( xSYMBOL, 1, 10 )), 10 )
  Else
    cC := PADL( ALLTRIM( STR( xSYMBOL )), 10 )
  EndIf
Return( STRTRAN( cC, ' ', '0' ) )