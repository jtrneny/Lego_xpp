#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "dmlb.ch"
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"
#include "Fileio.ch"
#include "class.ch"

#include "Deldbe.ch"
#include "Sdfdbe.ch"
#include "DbStruct.ch"
#include "Directry.ch"


#include "XbZ_Zip.ch"


#DEFINE  DBGETVAL(c)     Eval( &("{||" + c + "}"))

#pragma Library( "ASINet10.lib" )

*
** vnitøní formát èísla úètu u KB  - .gpc
# xTranslate  .c_n1   => SubStr(cbank_uct_int,11,1)
# xTranslate  .c_n2   => SubStr(cbank_uct_int,12,1)
# xTranslate  .c_n3   => SubStr(cbank_uct_int,13,1)
# xTranslate  .c_n4   => SubStr(cbank_uct_int,14,1)
# xTranslate  .c_n5   => SubStr(cbank_uct_int,15,1)
# xTranslate  .c_n6   => SubStr(cbank_uct_int,16,1)
# xTranslate  .c_n7   => SubStr(cbank_uct_int, 5,1)
# xTranslate  .c_n8   => SubStr(cbank_uct_int, 6,1)
# xTranslate  .c_n9   => SubStr(cbank_uct_int, 7,1)
# xTranslate  .c_n10  => SubStr(cbank_uct_int, 8,1)
# xTranslate  .c_n11  => SubStr(cbank_uct_int, 9,1)
# xTranslate  .c_n12  => SubStr(cbank_uct_int, 4,1)
# xTranslate  .c_n13  => SubStr(cbank_uct_int,10,1)
# xTranslate  .c_n14  => SubStr(cbank_uct_int, 2,1)
# xTranslate  .c_n15  => SubStr(cbank_uct_int, 3,1)
# xTranslate  .c_n16  => SubStr(cbank_uct_int, 1,1)


// import bankovního výpisu - KB - formát KM (DIST000021)
// Import bankovních výpisù - ÈS - formát KM - pøípona GPC (DIST000025)
// Import bankovních výpisù - GM - formát KM - pøípona GPC (DIST000035)
function DIST000021( oxbp )
  local  cpath_kom  := oXbp:cpath_kom
  local  cfile_kom  := oXbp:cfile_kom
  local  cdatuhrzhl := oXbp:DatUhrZHL
  local  istuz      := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nrok_vyp

  afiles := Directory( cpath_kom + cfile_kom )

  for x := 1 to len(afiles) step 1
    file := cpath_kom +afiles[x, F_NAME]

    nHandle  := FOpen( file, FO_READ )
    cBuffer  := FReadStr(nHandle,3)
    nPointer := 0

    do while cBuffer <> ''
      do case
      case cbuffer = '074' .or. cbuffer = '075'
        n  := 127
      case cbuffer = '078' .or. cbuffer = '079'
        n := 72
      endcase

      ny := Val(cbuffer)

//          FSeek( nHandle, -3, S_RELATIVE )

      cBuffer := space(n)
      cBuffer := FReadStr(nHandle, n) // result: 4

      do case
      case ny = 74
        cbank_uct_int  := SubStr( cBuffer, 1,16)
        cbank_uct      := .c_n1 + .c_n2 + .c_n3 + .c_n4  + .c_n5  + .c_n6  + ;
                            .c_n7 + .c_n8 + .c_n9 + .c_n10 + .c_n11 + .c_n12 + .c_n13  + .c_n14  + .c_n15 + .c_n16
        *
        dDatPoVyp := CtoD( SubStr( cBuffer, 106,2) +'.' +  ;
                           SubStr( cBuffer, 108,2) +'.' +  ;
                           SubStr( cBuffer, 110,2))
        nrok_vyp  := year( dDatPoVyp )
        *
        ncispovyp := Val( SubStr( cBuffer, 103,3))

        *
        cky       := strZero(nrok_vyp,4) +upper(cbank_uct) +strZero(ncispovyp,6)
        lis_ok    := .f.

        if .not. banvyph_im->(dbseek( cky,, 'BANIMPH_2'))
          banvyph_im ->( dbAppend())
          lis_ok := .t.

          banvyph_im ->cBank_Uce := cbank_uct
          banvyph_im ->cfile_imp := parseFileName( file,4 )
          banvyph_im ->dDatPoVyp := CtoD( SubStr( cBuffer, 106,2) +'.' +  ;
                                          SubStr( cBuffer, 108,2) +'.' +  ;
                                          SubStr( cBuffer, 110,2))
          banvyph_im ->nposzust  := Val( SubStr( cBuffer, 43,14))/100 *      ;
                                         if(SubStr( cBuffer, 57,1)='-',-1,1)
          banvyph_im ->nzustatek := Val( SubStr( cBuffer, 59,14))/100 *      ;
                                         if(SubStr( cBuffer, 72,1)='-',-1,1)
          banvyph_im ->nvydej    := Val( SubStr( cBuffer, 73,14))/100 *      ;
                                         if(SubStr( cBuffer, 87,1)='-',-1,1)
          banvyph_im ->nprijem   := Val( SubStr( cBuffer, 88,14))/100 *      ;
                                         if(SubStr( cBuffer, 102,1)='-',-1,1)
          banvyph_im ->ncispovyp := Val( SubStr( cBuffer, 103,3))
          banvyph_im ->dDatZust  := CtoD( SubStr( cBuffer, 106,2) +'.' + ;
                                          SubStr( cBuffer, 108,2) +'.' + ;
                                          SubStr( cBuffer, 110,2))
          banvyph_im ->ciban     := SubStr( cBuffer, 112,8)
          banvyph_im ->dDatPoriz := banvyph_im ->dDatZust
          banvyph_im ->nrok_vyp  := year( banvyph_im ->dDatPoVyp )
        endif

      case ny = 75
        if lis_ok
          banvypi_im ->( dbAppend())
          banvyph_im ->npocPoloz := banvyph_im ->npocPoloz +1
          banvypi_im ->cfile_imp := banvyph_im ->cfile_imp
          banvypi_im ->nrok_vyp  := banvyph_im ->nrok_vyp
          banvypi_im ->cbank_uce := banvyph_im ->cbank_uce
          banvypi_im ->ncisPoVyp := banvyph_im ->ncisPoVyp

          do case
          case SubStr( cBuffer, 58,1) = '1'
            banvypi_im ->nvydej    := Val( SubStr( cBuffer, 46,12))/100
          case SubStr( cBuffer, 58,1) = '4'
            banvypi_im ->nvydej    := Val( SubStr( cBuffer, 46,12))/100 * -1
          case SubStr( cBuffer, 58,1) = '2'
            banvypi_im ->nprijem   := Val( SubStr( cBuffer, 46,12))/100
          case SubStr( cBuffer, 58,1) = '5'
            banvypi_im ->nprijem   := Val( SubStr( cBuffer, 46,12))/100 * -1
          endcase

          cx                      := SubStr( cBuffer, 58,1)
          banvypi_im->ntypObratu  := if( cx = '1' .or. cx = '4', 2, 1)

          cx                      := SubStr( cBuffer, 59,10)
          banvypi_im ->cvarsym    := allTrim( str( val( cx ), 15, 0))
          banvypi_im ->cvarSymBan := padL( cx, 15, '0' )

          if Upper( cdatuhrzhl) = 'ANO'
            banvypi_im ->dDatUhrady := banvyph_im ->dDatPoVyp
          else
            banvypi_im ->dDatUhrady := CtoD(SubStr( cBuffer, 120,2) +'.' +  ;
                                            SubStr( cBuffer, 122,2) +'.' +  ;
                                            SubStr( cBuffer, 124,2))
          endif

          if istuz
            banvypi_im ->nCenZakCel := if( empty(banvypi_im ->nprijem), ;
                                                 banvypi_im ->nvydej  , ;
                                                 banvypi_im ->nprijem   )
            banvypi_im ->nUhrCelFak := banvypi_im ->nCenZakCel
            banvypi_im ->nLikPolBAv := banvypi_im ->nCenZakCel
          else
            banvypi_im ->nCenZahCel := if( empty(banvypi_im ->nprijem), ;
                                                 banvypi_im ->nvydej  , ;
                                                 banvypi_im ->nprijem   )
            banvypi_im ->nUhrCelFaz := banvypi_im ->nCenZakCel
          endif

          banvypi_im ->ctext      := subStr( cBuffer, 95, 20 )
        endif
      case ny = 78
      case ny = 79
      endcase

      cBuffer  := FReadStr(nHandle,3)
    enddo

    FClose( nHandle)
    n  := 0
    ny := 0
  next

  *
  ** smažeme naètené soubory
  AEval( afiles, { |a| FErase(cpath_kom +a[F_NAME]) } )
return(NIL)


// import bankovního výpisu - KB - formát BEST
function DIST000022( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nrok_vyp


  afiles := Directory( cpath_kom + cfile_kom )

  for x := 1 to len(afiles) step 1
    file := cpath_kom +afiles[x, F_NAME]

    nHandle  := FOpen( file, FO_READ )
    cBuffer  := FReadStr(nHandle,3)
    nPointer := 0
    n        := 475

    do while cBuffer <> ''
      ny := Val(cbuffer)

//          FSeek( nHandle, -3, S_RELATIVE )

      cBuffer := space(n)
      cBuffer := FReadStr(nHandle, n) // result: 4

      do case
      case SubStr(cBuffer,1,2) = 'HO'
      case SubStr(cBuffer,1,2) = '51'

        cBank_Uce := SubStr( cBuffer, 3,16)
        *
        dDatPoVyp := CtoD( SubStr( cBuffer, 36,2) +'.' +  ;
                           SubStr( cBuffer, 34,2) +'.' +  ;
                           SubStr( cBuffer, 30,4))
        nrok_vyp  := year( dDatPoVyp )
        *
        ncispovyp := Val( SubStr( cBuffer, 27,3))

        *
        cky       := strZero(nrok_vyp,4) +upper(cbank_uct) +strZero(ncispovyp,6)
        lis_ok    := .f.

        if .not. banvyph_im->(dbseek( cky,, 'BANIMPH_2'))
          lis_ok := .t.

          banvyph_im ->( dbAppend())
          banvyph_im ->cBank_Uce := SubStr( cBuffer, 3,16)
          banvyph_im ->cfile_imp := parseFileName( file,4 )
          banvyph_im ->dDatPoVyp := CtoD( SubStr( cBuffer, 36,2) +'.' +  ;
                                          SubStr( cBuffer, 34,2) +'.' +  ;
                                          SubStr( cBuffer, 30,4))
          banvyph_im ->nposzust  := Val( SubStr( cBuffer, 43,15))/100 *      ;
                                         if(SubStr( cBuffer, 58,1)='-',-1,1)
          banvyph_im ->nzustatek := Val( SubStr( cBuffer, 59,15))/100 *      ;
                                         if(SubStr( cBuffer, 74,1)='-',-1,1)
          banvyph_im ->nvydej    := Val( SubStr( cBuffer, 75,15))/100 *      ;
                                         if(SubStr( cBuffer, 90,1)='-',-1,1)
          banvyph_im ->nprijem   := Val( SubStr( cBuffer, 91,15))/100 *      ;
                                         if(SubStr( cBuffer, 106,1)='-',-1,1)
          banvyph_im ->ncispovyp := Val( SubStr( cBuffer, 27,3))
          banvyph_im ->dDatZust  := CtoD( SubStr( cBuffer, 25,2) +'.' + ;
                                          SubStr( cBuffer, 23,2) +'.' + ;
                                          SubStr( cBuffer, 19,4))
          banvyph_im ->ciban     := SubStr( cBuffer, 137,24)
          banvyph_im ->dDatPoriz := banvyph_im ->dDatZust
          banvyph_im ->nrok_vyp  := year( banvyph_im ->dDatPoVyp )
        endif

      case SubStr(cBuffer,1,2) = '52'
        if lis_ok
          banvypi_im ->( dbAppend())
          banvyph_im ->npocPoloz := banvyph_im ->npocPoloz +1
          banvypi_im ->cfile_imp := banvyph_im ->cfile_imp
          banvypi_im ->nrok_vyp  := banvyph_im ->nrok_vyp
          banvypi_im ->cbank_uce := banvyph_im ->cbank_uce
          banvypi_im ->ncisPoVyp := Val( SubStr( cBuffer, 3,5))

          do case
          case SubStr( cBuffer, 47,1) = '0'
            banvypi_im ->nvydej    := Val( SubStr( cBuffer, 51,15))/100
          case SubStr( cBuffer, 47,1) = '2'
            banvypi_im ->nvydej    := Val( SubStr( cBuffer, 51,15))/100 * -1
          case SubStr( cBuffer, 47,1) = '1'
            banvypi_im ->nprijem   := Val( SubStr( cBuffer, 51,15))/100
          case SubStr( cBuffer, 47,1) = '3'
            banvypi_im ->nprijem   := Val( SubStr( cBuffer, 51,15))/100 * -1
          endcase

          cx                      := SubStr( cBuffer, 47,1)
          banvypi_im->ntypObratu  := if( cx = '0' .or. cx = '2', 2, 1)

          cx                      := SubStr( cBuffer, 128,10)
          banvypi_im ->cvarsym    := allTrim( str( val( cx ), 15, 0))
          banvypi_im ->cvarSymBan := padL( cx, 15, '0' )
          banvypi_im ->dDatUhrady := CtoD(SubStr( cBuffer, 182,2) +'.' +  ;
                                          SubStr( cBuffer, 180,2) +'.' +  ;
                                          SubStr( cBuffer, 176,4))

          if istuz
            banvypi_im ->nCenZakCel := if( empty(banvypi_im ->nprijem), ;
                                                 banvypi_im ->nvydej  , ;
                                                 banvypi_im ->nprijem   )
            banvypi_im ->nUhrCelFak := banvypi_im ->nCenZakCel
            banvypi_im ->nLikPolBAv := banvypi_im ->nCenZakCel
          else
            banvypi_im ->nCenZahCel := if( empty(banvypi_im ->nprijem), ;
                                                 banvypi_im ->nvydej  , ;
                                                 banvypi_im ->nprijem   )
            banvypi_im ->nUhrCelFaz := banvypi_im ->nCenZakCel
          endif

          banvypi_im ->ctext      := subStr( cBuffer, 95, 20 )
        endif

      case SubStr(cBuffer,1,2) = 'TO'

      endcase

    enddo

    FClose( nHandle)
  next

  *
  ** smažeme naètené soubory
  AEval( afiles, { |a| FErase(cpath_kom +a[F_NAME]) } )
return(NIL)


// Import bankovních výpisù - ÈSOB - formát KM - pøípona GPC
function DIST000028( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nrok_vyp


  afiles := Directory( cpath_kom + cfile_kom )

  for x := 1 to len(afiles) step 1
    file := cpath_kom +afiles[x, F_NAME]

    nHandle  := FOpen( file, FO_READ )
    cBuffer  := FReadStr(nHandle,3)
    nPointer := 0

    do while cBuffer <> ''
/*
      do case
      case cbuffer = '074' .or. cbuffer = '075'
        n  := 127   //130
      case cbuffer = '078' .or. cbuffer = '079'
        n := 72    //130
      endcase
*/
      n  := 127
      ny := Val(cbuffer)

//          FSeek( nHandle, -3, S_RELATIVE )

      cBuffer := space(n)
      cBuffer := FReadStr(nHandle, n) // result: 4

      do case
      case ny = 74
        cbank_uct_int  := SubStr( cBuffer, 1,16)
        cbank_uct      := cbank_uct_int
        *
        dDatPoVyp := CtoD( SubStr( cBuffer, 106,2) +'.' +  ;
                           SubStr( cBuffer, 108,2) +'.' +  ;
                           SubStr( cBuffer, 110,2))
        nrok_vyp  := year( dDatPoVyp )
        *
        ncispovyp := Val( SubStr( cBuffer, 103,3))

        *
        cky       := strZero(nrok_vyp,4) +upper(cbank_uct) +strZero(ncispovyp,6)
        lis_ok    := .f.

        if .not. banvyph_im->(dbseek( cky,, 'BANIMPH_2'))
          banvyph_im ->( dbAppend())
          lis_ok := .t.

          banvyph_im ->cBank_Uce := cbank_uct
          banvyph_im ->cfile_imp := parseFileName( file,4 )
          banvyph_im ->dDatPoVyp := CtoD( SubStr( cBuffer, 106,2) +'.' +  ;
                                          SubStr( cBuffer, 108,2) +'.' +  ;
                                          SubStr( cBuffer, 110,2))
          banvyph_im ->nposzust  := Val( SubStr( cBuffer, 43,14))/100 *      ;
                                         if(SubStr( cBuffer, 57,1)='-',-1,1)
          banvyph_im ->nzustatek := Val( SubStr( cBuffer, 59,14))/100 *      ;
                                         if(SubStr( cBuffer, 72,1)='-',-1,1)
          banvyph_im ->nvydej    := Val( SubStr( cBuffer, 73,14))/100 *      ;
                                         if(SubStr( cBuffer, 87,1)='-',-1,1)
          banvyph_im ->nprijem   := Val( SubStr( cBuffer, 88,14))/100 *      ;
                                         if(SubStr( cBuffer, 102,1)='-',-1,1)
          banvyph_im ->ncispovyp := Val( SubStr( cBuffer, 103,3))
          banvyph_im ->dDatZust  := CtoD( SubStr( cBuffer, 106,2) +'.' + ;
                                          SubStr( cBuffer, 108,2) +'.' + ;
                                          SubStr( cBuffer, 110,2))
          banvyph_im ->ciban     := SubStr( cBuffer, 112,8)
          banvyph_im ->dDatPoriz := banvyph_im ->dDatZust
          banvyph_im ->nrok_vyp  := year( banvyph_im ->dDatPoVyp )
        endif

      case ny = 75
        if lis_ok
          banvypi_im ->( dbAppend())
          banvyph_im ->npocPoloz := banvyph_im ->npocPoloz +1
          banvypi_im ->cfile_imp := banvyph_im ->cfile_imp
          banvypi_im ->nrok_vyp  := banvyph_im ->nrok_vyp
          banvypi_im ->cbank_uce := banvyph_im ->cbank_uce
          banvypi_im ->ncisPoVyp := banvyph_im ->ncisPoVyp

          do case
          case SubStr( cBuffer, 58,1) = '1'
            banvypi_im ->nvydej    := Val( SubStr( cBuffer, 46,12))/100
          case SubStr( cBuffer, 58,1) = '4'
            banvypi_im ->nvydej    := Val( SubStr( cBuffer, 46,12))/100 * -1
          case SubStr( cBuffer, 58,1) = '2'
            banvypi_im ->nprijem   := Val( SubStr( cBuffer, 46,12))/100
          case SubStr( cBuffer, 58,1) = '5'
            banvypi_im ->nprijem   := Val( SubStr( cBuffer, 46,12))/100 * -1
          endcase

          cx                      := SubStr( cBuffer, 58,1)
          banvypi_im->ntypObratu  := if( cx = '1' .or. cx = '4', 2, 1)

          cx                      := SubStr( cBuffer, 59,10)
          banvypi_im ->cvarsym    := allTrim( str( val( cx ), 15, 0))
          banvypi_im ->cvarSymBan := padL( cx, 15, '0' )

          banvypi_im ->dDatUhrady := CtoD(SubStr( cBuffer, 120,2) +'.' +  ;
                                          SubStr( cBuffer, 122,2) +'.' +  ;
                                          SubStr( cBuffer, 124,2))

          if istuz
            banvypi_im ->nCenZakCel := if( empty(banvypi_im ->nprijem), ;
                                                 banvypi_im ->nvydej  , ;
                                                 banvypi_im ->nprijem   )
            banvypi_im ->nUhrCelFak := banvypi_im ->nCenZakCel
            banvypi_im ->nLikPolBAv := banvypi_im ->nCenZakCel
          else
            banvypi_im ->nCenZahCel := if( empty(banvypi_im ->nprijem), ;
                                                 banvypi_im ->nvydej  , ;
                                                 banvypi_im ->nprijem   )
            banvypi_im ->nUhrCelFaz := banvypi_im ->nCenZakCel
          endif

          banvypi_im ->ctext      := subStr( cBuffer, 95, 20 )
        endif
      case ny = 78
      case ny = 79
      endcase

      cBuffer  := FReadStr(nHandle,3)
    enddo

    FClose( nHandle)
    n  := 0
    ny := 0
  next

  *
  ** smažeme naètené soubory
  AEval( afiles, { |a| FErase(cpath_kom +a[F_NAME]) } )
return(NIL)

// Export bankovních platebních pøíkazù - UniCredit Bank - formát MTC - tuzemský
function DIST000046( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aSum

  aSum := {{0,0},{0,0},{0,0}}

  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )

  Do While .not.prikuhit ->( Eof())
    cBuffer := 'HD:'                                                   + ;
               '11' +' '                              + ;
               SubStr( DTOS(prikuhit->dUhrBanDne ),3) +' '             + ;
               Bank_KOD(prikuhhd ->cBank_Uct) +' '                     + ;
               AllTrim( Str( nRadek)) +' '                             + ;
               Bank_KOD(prikuhit ->cUcet) +CRLF
    fWrite( nfile_kom, cBuffer )
*               prikuhit ->cTypPlatby +' '                              + ;

    cBuffer := 'KC:'                                                   + ;
               AllTrim( StrTran( Str( prikuhit ->nPriUhrCel),'.','') ) +' '       + ;
               '000000' +' '                                           + ;
               AllTrim( prikuhit ->cZkratMenZ)  +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'UD:'                                                   + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[1])+' '        + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[2])+' '        + ;
               Left( AllTrim( prikuhhd ->cBank_Naz), 20)  +CRLF
    fWrite( nfile_kom, cBuffer )

*    cBuffer := 'AD:'                                                   + ;
*                  +CRLF
*    fWrite( nfile_kom, cBuffer )

    cBuffer := 'DI:'                                                   + ;
               Left(AllTrim( SysConfig('System:cPodnik')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cUlice')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cSidlo')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cPsc')),35) + ', '      + ;
               Left(AllTrim( SysConfig('System:cZkrStaOrg')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := 'UK:'                                                   + ;
               AllTrim( Bank_UCET(prikuhit ->cUcet)[1])+' '            + ;
               AllTrim( Bank_UCET(prikuhit ->cUcet)[2])+' '            + ;
               Left( AllTrim( prikuhit ->cBank_Naz), 20) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'AK:'                                                   + ;
               AllTrim( prikuhit ->cSpecSymb) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'KI:'                                                   + ;
               Left( AllTrim( prikuhit ->cNazev),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := '   '                                                   + ;
               Left( AllTrim( prikuhit ->cUlice),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := '   '                                                   + ;
               Left( AllTrim( prikuhit ->cSidlo),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := '   '                                                   + ;
               Left( AllTrim( prikuhit ->cPsc),35) + ', '              + ;
               Left( AllTrim( prikuhit ->cZkratStat),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'EC:'                                                   + ;
               AllTrim( Str( prikuhit ->nKonstSymb)) +CRLF
    fWrite( nfile_kom, cBuffer )

*    cBuffer := 'ZD:'                                                   + ;
*               AllTrim( prikuhit ->cVarSym) +CRLF
*    fWrite( nfile_kom, cBuffer )

    cBuffer := 'ZK:'                                                   + ;
               AllTrim( prikuhit ->cVarSym) +CRLF
    fWrite( nfile_kom, cBuffer )


    do case
    case prikuhit ->cTypPlatby = '01'
      aSum[1,1]++
      aSum[1,2] += prikuhit ->nPriUhrCel
    case prikuhit ->cTypPlatby = '32'
      aSum[3,1]++
      aSum[3,2] += prikuhit ->nPriUhrCel
    otherwise       //prikuhit ->cTypPlatby = '11'
      aSum[2,1]++
      aSum[2,2] += prikuhit ->nPriUhrCel
   endcase

    prikuhit ->( dbSkip())
    nRadek++
  EndDo

  if aSum[1,1] > 0
    cBuffer := 'S0:'                                                      + ;
               StrZero(aSum[1,1],9) +' '                                  + ;
               if( aSum[1,2] = 0, '000',AllTrim( StrTran(Str( aSum[1,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
  endif

  if aSum[2,1] > 0
    cBuffer := 'S1:'                                                      + ;
               StrZero(aSum[2,1],9) +' '                                  + ;
               if( aSum[2,2] = 0, '000',AllTrim( StrTran(Str( aSum[2,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
    if aSum[3,1] = 0
      cBuffer := 'S3:'                                                    + ;
                 StrZero( 0,9) +' '                                       + ;
                 '000' +CRLF
      fWrite( nfile_kom, cBuffer )
    endif
  endif

  if aSum[3,1] > 0
    cBuffer := 'S3:'                                                      + ;
               StrZero(aSum[3,1],9) +' '                                  + ;
               if( aSum[3,2] = 0, '000', AllTrim( StrTran(Str( aSum[3,2]),'.','' )))+CRLF
    fWrite( nfile_kom, cBuffer )
  endif

  FCLOSE( nfile_kom)

return(NIL)


// Export bankovních platebních pøíkazù - UniCredit Bank - formát MTC - zahranièní
function DIST000047( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aPrikUhr
  local  aLineUhr
  local  aSum

  aPrikUhr := {{},'',0,0,'',''}
  aSum     := {{0,0},{0,0},{0,0}}
  aLineUhr := {}

  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )


  Do While .not.prikuhit ->( Eof())
    cBuffer := ':20'                                                   + ;
               'REFERENCE ZAKAZNIKA' +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':32A:'                                                 + ;
               SubStr( DTOS(prikuhit->dUhrBanDne ),3)                  + ;
               AllTrim( prikuhit ->cZkratMenZ)                         + ;
               AllTrim( Str( prikuhit ->nPriUhrCel,2))   +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':50:'                                                 + ;
               Left(AllTrim( SysConfig('System:cPodnik')),35) +CRLF
    AAdd( aLineUhr, cBuffer )
    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cUlice')),35) +CRLF
    AAdd( aLineUhr, cBuffer )
    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cSidlo')),35) +CRLF
    AAdd( aLineUhr, cBuffer )
    cBuffer := Left(AllTrim( SysConfig('System:cPsc')),35) + ', '      + ;
               Left(AllTrim( SysConfig('System:cZkrStaOrg')),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := '52D:'                                                   + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[1])+            + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[2])+CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[1])+            + ;
               AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[2])+CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[1])+            + ;
               AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[2])+CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := AllTrim( prikuhhd ->cZkratMeny) + ' '                     + ;
               AllTrim( prikuhit ->cZkratMenP) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := if( Empty(prikuhit ->cPlatTitul),'000', AllTrim( prikuhit ->cPlatTitul)) + ' '+ ;
                 AllTrim( prikuhit ->cZkratStat) +' '                    + ;
                  AllTrim( prikuhit ->cBank_Sta) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':57A:'                                                   + ;
                 AllTrim( prikuhit ->cBIC) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':57D:'                                                   + ;
                 Left( AllTrim( prikuhit ->cBank_Naz),35) +CRLF          + ;
                 Space(2)  +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer :=   Left( AllTrim( prikuhit ->cBank_Uli),35) +CRLF          + ;
                 Left( AllTrim( prikuhit ->cBank_Sid),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':59:'                                                    + ;
                 '/'                                                     + ;
                 Left( AllTrim( prikuhit ->cIBAN),34) +CRLF               + ;
                 SubStr( AllTrim( prikuhit ->cNazev),1,35) +CRLF          + ;
                 SubStr( AllTrim( prikuhit ->cNazev),36) +CRLF            + ;
                 Left( AllTrim( prikuhit ->cUlice),35) +CRLF              + ;
                 Left( AllTrim( prikuhit ->cSidlo),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':70:'                                                    + ;
                 Left( AllTrim( prikuhit ->cPopis1Uhr),35) +CRLF         + ;
                 Left( AllTrim( prikuhit ->cPopis2Uhr),35) +CRLF         + ;
                 Left( AllTrim( prikuhit ->cPopis3Uhr),35) +CRLF         + ;
                 Left( AllTrim( prikuhit ->cPopis4Uhr),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':71A:'
    do case
    case prikuhit ->cPoplatUhr = 'SHA'  ;   cBuffer += 'BN1' + CRLF
    case prikuhit ->cPoplatUhr = 'OUR'  ;   cBuffer += 'OUR' + CRLF
    case prikuhit ->cPoplatUhr = 'BEN'  ;   cBuffer += 'BN2' + CRLF
    endcase
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':72:'                                                    + ;
               '00 00 00 00' + CRLF                                      + ;
               Space(35) +CRLF                                           + ; // kontaktní osoba
               Space(35) +CRLF                                           + ; // rozšíøený text
               Left( AllTrim( prikuhit ->cPopis1Ban),35) +CRLF           + ;
               Left( AllTrim( prikuhit ->cPopis2Ban),35) +CRLF           + ;
               Left( AllTrim( prikuhit ->cPopis3Ban),35) +CRLF
    AAdd( aLineUhr, cBuffer )

//   cBuffer := '-}'
//    AAdd( aLineUhr, cBuffer )

    AAdd( aPrikUhr[1], {aLineUhr, prikuhhd ->cBANIS,prikuhit ->cBic} )
    aPrikUhr[3]++
    aPrikUhr[4] += prikuhit ->nUhrCelFak
    prikuhit ->( dbSkip())
  EndDo

// vygeneruje záhlaví souboru

  cBuffer := ':01:'                                                       + ;
                    '000' +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':02:'                                                       + ;
                 Str( aPrikUhr[4],2) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':03:'                                                       + ;
                 StrZero( aPrikUhr[3],5) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':04:'                                                       + ;
                   AllTrim( prikuhhd ->cBic) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':05:'                                                         + ;
             Left(AllTrim( SysConfig('System:cPodnik')),35) +CRLF
  fWrite( nfile_kom, cBuffer )
  cBuffer := '   '                                                          + ;
             Left(AllTrim( SysConfig('System:cUlice')),35) +CRLF
  fWrite( nfile_kom, cBuffer )
  cBuffer := '   '                                                          + ;
             Left(AllTrim( SysConfig('System:cSidlo')),35) +CRLF
  fWrite( nfile_kom, cBuffer )
  cBuffer := Left(AllTrim( SysConfig('System:cPsc')),35) + ', '             + ;
             Left(AllTrim( SysConfig('System:cZkrStaOrg')),35) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':07:'                                                         + ;
                   Left( AllTrim( cfile_kom), 12) +CRLF
  fWrite( nfile_kom, cBuffer )

  for n = 1 to Len( aPrikUhr[1])
    cBuffer := if( n = 1, '', '-}$')                                          + ;
                '{1:F01' +aPrikUhr[1,2] +'XXXXAXXX' + StrZero( 1, 4)         + ;
                  StrZero( 0, 6) + '}'                                       + ;
                  '{2:I100' + PadR( aPrikUhr[1,3],12) +'N' +'1}'             + ;
                    '{4:' +CRLF
    fWrite( nfile_kom, cBuffer )
    for i = 1 to Len( aPrikUhr[1,1])
      cBuffer := aPrikUhr[1,1,i]
      fWrite( nfile_kom, cBuffer )
    next
  next

  cBuffer := '-}' +CRLF
  fWrite( nfile_kom, cBuffer )

  FCLOSE( nfile_kom)


/*
  if aSum[1,1] > 0
    cBuffer := 'S0:'                                                      + ;
               StrZero(aSum[1,1],9) +' '                                  + ;
               if( aSum[1,2] = 0, '000',AllTrim( StrTran(Str( aSum[1,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
  endif

  if aSum[2,1] > 0
    cBuffer := 'S1:'                                                      + ;
               StrZero(aSum[2,1],9) +' '                                  + ;
               if( aSum[2,2] = 0, '000',AllTrim( StrTran(Str( aSum[2,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
    if aSum[3,1] = 0
      cBuffer := 'S3:'                                                    + ;
                 StrZero( 0,9) +' '                                       + ;
                 '000' +CRLF
      fWrite( nfile_kom, cBuffer )
    endif
  endif

  if aSum[3,1] > 0
    cBuffer := 'S3:'                                                      + ;
               StrZero(aSum[3,1],9) +' '                                  + ;
               if( aSum[3,2] = 0, '000', AllTrim( StrTran(Str( aSum[3,2]),'.','' )))+CRLF
    fWrite( nfile_kom, cBuffer )
  endif
*/
  FCLOSE( nfile_kom)

return(NIL)


// Import bankovních výpisù - UnCrBa-formát MTC-MT942 struktur - pøípona - STA
function DIST000048( oxbp )


return( nil)


// Import bankovních výpisù - UnCrBa-formát MTC-MT940 struktur - pøípona - STA
function DIST000049( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  local  lenBuff, start
  local  begsekce, endsekce
  local  strsekce, aSekce
  local  item
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nrok_vyp


  afiles := Directory( cpath_kom + cfile_kom )

  for x := 1 to len(afiles) step 1
    file := cpath_kom +afiles[x, F_NAME]

    nHandle  := FOpen( file, FO_READ )
    lenBuff  := FSize(nHandle)
    cBuffer  := FReadStr(nHandle,lenBuff)
//    cBuffer  := ConvToAnsiCP(cBuffer)
    nPointer := 0
    start    := At('{4:', cbuffer)
//    konec    := At('-}', cbuffer, start)
// zaèátek výpisu
    do while start > 0
//     pole  :20
      if ( begsekce := At(':20:', cbuffer, start)) > 0
        aSekce :=  MTCsekce( ':20:', begsekce, cbuffer)
        start := aSekce[2]
       endif
//     pole  :21
      if ( begsekce := At(':21:', cbuffer, start)) > 0
        aSekce :=  MTCsekce( ':21:', begsekce, cbuffer)
        start := aSekce[2]

      endif
//     pole  :25
      if ( begsekce := At(':25:', cbuffer, start)) > 0
        aSekce :=  MTCsekce( ':25:', begsekce, cbuffer)
        start := aSekce[2]

        cbank_uct := SubStr( aSekce[1], At('/',aSekce[1])+1)
        cbank_uct := StrTran( cbank_uct, Chr(10),'')
        cbank_uct := StrTran( cbank_uct, Chr(13),'')
//        cbank_uct := AllTrim(SubStr( aSekce[1], At('/',aSekce[1])+1))
        if At('-', cbank_uct) > 0
        else
          cbank_uct := Padl( cbank_uct, 16,'0')
        endif
//        cbank_uct += '/' +AllTrim(SubStr( aSekce[1],1, At('/',aSekce[1])-1))
      endif
//     pole  :28C
      if ( begsekce := At(':28C:', cbuffer, start)) > 0
        aSekce :=  MTCsekce( ':28C:', begsekce, cbuffer)
        start := aSekce[2]

        ncispovyp := Val( SubStr( aSekce[1],1, At('/',aSekce[1])-1))
      endif

//     pole  :60F
      if ( begsekce := At(':60F:', cbuffer, start)) > 0
        aSekce :=  MTCsekce( ':60F:', begsekce, cbuffer)
        start := aSekce[2]

        dDatPoVyp := CtoD( SubStr( aSekce[1], 6,2) +'.' +  ;
                            SubStr( aSekce[1], 4,2) +'.' +  ;
                             SubStr( aSekce[1], 2,2))
        nrok_vyp  := year( dDatPoVyp )
      endif

//     pole  :60M
      if ( begsekce := At(':60M:', cbuffer, start)) > 0
        aSekce :=  MTCsekce( ':60M:', begsekce, cbuffer)
        start := aSekce[2]

      endif

      cky       := strZero(nrok_vyp,4) +upper(cbank_uct) +strZero(ncispovyp,6)
      lis_ok    := .f.

      if .not. banvyph_im->(dbseek( cky,, 'BANIMPH_2'))
        banvyph_im ->( dbAppend())
        lis_ok := .t.

        banvyph_im ->cBank_Uce := cbank_uct
        banvyph_im ->cfile_imp := parseFileName( file,4 )
        banvyph_im ->dDatPoVyp := dDatPoVyp

        banvyph_im ->nposzust  := Val( SubStr( aSekce[1], 10))


        banvyph_im ->ncispovyp := ncispovyp
        banvyph_im ->dDatZust  := dDatPoVyp
//        banvyph_im ->ciban     := SubStr( cBuffer, 112,8)
        banvyph_im ->dDatPoriz := dDatPoVyp
        banvyph_im ->nrok_vyp  := year( dDatPoVyp )

        banvyph_im ->(dbCommit())

  //     pole  :61      -  prùchod pøes položky
        if ( begsekce := At(':61:', cbuffer, start)) > 0
          item     := .t.
          do while item
            if ( begsekce := At(':61:', cbuffer, start)) > 0
              aSekce :=  MTCsekce( ':61:', begsekce, cbuffer)
              start := aSekce[2]

              if lis_ok
                banvypi_im ->( dbAppend())
                banvyph_im ->npocPoloz := banvyph_im ->npocPoloz +1
                banvypi_im ->cfile_imp := banvyph_im ->cfile_imp
                banvypi_im ->nrok_vyp  := banvyph_im ->nrok_vyp
                banvypi_im ->cbank_uce := banvyph_im ->cbank_uce
                banvypi_im ->ncisPoVyp := banvyph_im ->ncisPoVyp

                ny := At( ',', aSekce[1],11) + 3

                do case
                case SubStr( aSekce[1], 11,1) = 'D'
                  banvypi_im ->nvydej    := Val( SubStr( aSekce[1],12,ny - 12))
                  banvypi_im->ntypObratu := 2
                case SubStr( aSekce[1], 11,1) = 'C'
                  banvypi_im ->nprijem   := Val( SubStr( aSekce[1],12,ny - 12))
                  banvypi_im->ntypObratu := 1
                case SubStr( aSekce[1], 11,2) = 'RD'
                  banvypi_im ->nvydej    := Val( SubStr( aSekce[1], 13,ny - 13)) * -1
                  banvypi_im->ntypObratu := 2
                case SubStr( aSekce[1], 11,2) = 'RC'
                  banvypi_im ->nprijem   := Val( SubStr( aSekce[1], 13,ny - 13)) * -1
                  banvypi_im->ntypObratu := 1
                endcase

                banvypi_im ->dDatUhrady := CtoD(SubStr( aSekce[1], 5,2) +'.' +  ;
                                                SubStr( aSekce[1], 3,2) +'.' +  ;
                                                SubStr( aSekce[1], 1,2))

                if istuz
                  banvypi_im ->nCenZakCel := if( empty(banvypi_im ->nprijem), ;
                                                       banvypi_im ->nvydej  , ;
                                                       banvypi_im ->nprijem   )
                  banvypi_im ->nUhrCelFak := banvypi_im ->nCenZakCel
                  banvypi_im ->nLikPolBAv := banvypi_im ->nCenZakCel
                else
                  banvypi_im ->nCenZahCel := if( empty(banvypi_im ->nprijem), ;
                                                       banvypi_im ->nvydej  , ;
                                                       banvypi_im ->nprijem   )
                  banvypi_im ->nUhrCelFaz := banvypi_im ->nCenZakCel
                endif

//                banvypi_im ->ctext      := subStr( cBuffer, 95, 20 )

    //     pole  :86
                if ( begsekce := At(':86:', cbuffer, start)) > 0
                  aSekce :=  MTCsekce( ':86:', begsekce, cbuffer)
                  start := aSekce[2]

                  ny := At( '?23', aSekce[1]) - At('?22', aSekce[1])-3
                  cx                      := SubStr( aSekce[1], At('?22', aSekce[1])+3, ny)

                  banvypi_im ->cvarsym    := allTrim( str( val( cx ), 15, 0))
                  banvypi_im ->cvarSymBan := padL( cx, 15, '0' )

                endif
              endif
            else
              item := .f.
            endif
          enddo
        endif


  //     pole  :62F
        if ( begsekce := At(':62F:', cbuffer, start)) > 0
          aSekce :=  MTCsekce( ':62F:', begsekce, cbuffer)
          start := aSekce[2]


          banvyph_im ->nzustatek := Val( SubStr( cBuffer, 59,14))/100 *      ;
                                       if(SubStr( cBuffer, 72,1)='-',-1,1)


        endif
  //     pole  :62M
        if ( begsekce := At(':62M:', cbuffer, start)) > 0
          aSekce :=  MTCsekce( ':62M:', begsekce, cbuffer)
          start := aSekce[2]

        endif

  //     pole  :64
        if ( begsekce := At(':64:', cbuffer, start)) > 0
          aSekce :=  MTCsekce( ':64:', begsekce, cbuffer)
          start := aSekce[2]

          banvyph_im ->nvydej    := Val( SubStr( cBuffer, 73,14))/100 *      ;
                                       if(SubStr( cBuffer, 87,1)='-',-1,1)
          banvyph_im ->nprijem   := Val( SubStr( cBuffer, 88,14))/100 *      ;
                                         if(SubStr( cBuffer, 102,1)='-',-1,1)


        endif
  //     pole  :65
        if ( begsekce := At(':65:', cbuffer, start)) > 0
          aSekce :=  MTCsekce( ':65:', begsekce, cbuffer)
          start := aSekce[2]

          banvyph_im ->nvydej    := Val( SubStr( cBuffer, 73,14))/100 *      ;
                                       if(SubStr( cBuffer, 87,1)='-',-1,1)
          banvyph_im ->nprijem   := Val( SubStr( cBuffer, 88,14))/100 *      ;
                                         if(SubStr( cBuffer, 102,1)='-',-1,1)


        endif
      endif

      start := At('{4:', cbuffer, start)

    enddo
/*

    do while cBuffer <> ''
      do case
      case cbuffer = '074' .or. cbuffer = '075'
        n  := 127
      case cbuffer = '078' .or. cbuffer = '079'
        n := 72
      endcase

      ny := Val(cbuffer)

//          FSeek( nHandle, -3, S_RELATIVE )

      cBuffer := space(n)
      cBuffer := FReadStr(nHandle, n) // result: 4

      do case
      case ny = 74
        cbank_uct_int  := SubStr( cBuffer, 1,16)
        cbank_uct      := .c_n1 + .c_n2 + .c_n3 + .c_n4  + .c_n5  + .c_n6  + ;
                            .c_n7 + .c_n8 + .c_n9 + .c_n10 + .c_n11 + .c_n12 + .c_n13  + .c_n14  + .c_n15 + .c_n16
        *
        dDatPoVyp := CtoD( SubStr( cBuffer, 106,2) +'.' +  ;
                           SubStr( cBuffer, 108,2) +'.' +  ;
                           SubStr( cBuffer, 110,2))
        nrok_vyp  := year( dDatPoVyp )
        *
        ncispovyp := Val( SubStr( cBuffer, 103,3))

        *
        cky       := strZero(nrok_vyp,4) +upper(cbank_uct) +strZero(ncispovyp,6)
        lis_ok    := .f.

        if .not. banvyph_im->(dbseek( cky,, 'BANIMPH_2'))
          banvyph_im ->( dbAppend())
          lis_ok := .t.

          banvyph_im ->cBank_Uce := cbank_uct
          banvyph_im ->cfile_imp := parseFileName( file,4 )
          banvyph_im ->dDatPoVyp := CtoD( SubStr( cBuffer, 106,2) +'.' +  ;
                                          SubStr( cBuffer, 108,2) +'.' +  ;
                                          SubStr( cBuffer, 110,2))
          banvyph_im ->nposzust  := Val( SubStr( cBuffer, 43,14))/100 *      ;
                                         if(SubStr( cBuffer, 57,1)='-',-1,1)
          banvyph_im ->nzustatek := Val( SubStr( cBuffer, 59,14))/100 *      ;
                                         if(SubStr( cBuffer, 72,1)='-',-1,1)
          banvyph_im ->nvydej    := Val( SubStr( cBuffer, 73,14))/100 *      ;
                                         if(SubStr( cBuffer, 87,1)='-',-1,1)
          banvyph_im ->nprijem   := Val( SubStr( cBuffer, 88,14))/100 *      ;
                                         if(SubStr( cBuffer, 102,1)='-',-1,1)
          banvyph_im ->ncispovyp := Val( SubStr( cBuffer, 103,3))
          banvyph_im ->dDatZust  := CtoD( SubStr( cBuffer, 106,2) +'.' + ;
                                          SubStr( cBuffer, 108,2) +'.' + ;
                                          SubStr( cBuffer, 110,2))
          banvyph_im ->ciban     := SubStr( cBuffer, 112,8)
          banvyph_im ->dDatPoriz := banvyph_im ->dDatZust
          banvyph_im ->nrok_vyp  := year( banvyph_im ->dDatPoVyp )
        endif

      case ny = 75
        if lis_ok
          banvypi_im ->( dbAppend())
          banvyph_im ->npocPoloz := banvyph_im ->npocPoloz +1
          banvypi_im ->cfile_imp := banvyph_im ->cfile_imp
          banvypi_im ->nrok_vyp  := banvyph_im ->nrok_vyp
          banvypi_im ->cbank_uce := banvyph_im ->cbank_uce
          banvypi_im ->ncisPoVyp := banvyph_im ->ncisPoVyp

          do case
          case SubStr( cBuffer, 58,1) = '1'
            banvypi_im ->nvydej    := Val( SubStr( cBuffer, 46,12))/100
          case SubStr( cBuffer, 58,1) = '4'
            banvypi_im ->nvydej    := Val( SubStr( cBuffer, 46,12))/100 * -1
          case SubStr( cBuffer, 58,1) = '2'
            banvypi_im ->nprijem   := Val( SubStr( cBuffer, 46,12))/100
          case SubStr( cBuffer, 58,1) = '5'
            banvypi_im ->nprijem   := Val( SubStr( cBuffer, 46,12))/100 * -1
          endcase

          cx                      := SubStr( cBuffer, 58,1)
          banvypi_im->ntypObratu  := if( cx = '1' .or. cx = '4', 2, 1)

          cx                      := SubStr( cBuffer, 59,10)
          banvypi_im ->cvarsym    := allTrim( str( val( cx ), 15, 0))
          banvypi_im ->cvarSymBan := padL( cx, 15, '0' )

          banvypi_im ->dDatUhrady := CtoD(SubStr( cBuffer, 120,2) +'.' +  ;
                                          SubStr( cBuffer, 122,2) +'.' +  ;
                                          SubStr( cBuffer, 124,2))

          if istuz
            banvypi_im ->nCenZakCel := if( empty(banvypi_im ->nprijem), ;
                                                 banvypi_im ->nvydej  , ;
                                                 banvypi_im ->nprijem   )
            banvypi_im ->nUhrCelFak := banvypi_im ->nCenZakCel
            banvypi_im ->nLikPolBAv := banvypi_im ->nCenZakCel
          else
            banvypi_im ->nCenZahCel := if( empty(banvypi_im ->nprijem), ;
                                                 banvypi_im ->nvydej  , ;
                                                 banvypi_im ->nprijem   )
            banvypi_im ->nUhrCelFaz := banvypi_im ->nCenZakCel
          endif

          banvypi_im ->ctext      := subStr( cBuffer, 95, 20 )
        endif
      case ny = 78
      case ny = 79
      endcase

      cBuffer  := FReadStr(nHandle,3)
    enddo
*/

    banvyph_im ->(dbCommit())
    banvypi_im ->(dbCommit())
    FClose( nHandle)
    n  := 0
    ny := 0
  next

  *
  ** smažeme naètené soubory
  AEval( afiles, { |a| FErase(cpath_kom +a[F_NAME]) } )


return( nil)



// Export bankovních platebních pøíkazù - KB - formát KM - tuzemský
function DIST000051( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  npor_file := 0
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aSum

  aSum := {{0,0},{0,0},{0,0}}

  npor_file++
  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  cfile_kom := &cfile_kom
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )


  cBuffer := 'UHL1'                                                     + ;
             mh_DDMMYY( DATE())                                         + ;
             Padr(Left(AllTrim( SysConfig('System:cPodnik')),20),20)    + ;
             Str( 1,10,0)                                               + ;
             Str( nPor_file,3)                                          + ;
             '999'                                                      + ;
             Space(12) +CRLF
  fWrite( nfile_kom, cBuffer )
*               prikuhit ->cTypPlatby +' '                              + ;

  cBuffer := '1 1501'                                                   + ;
             ' '                                                        + ;
             Str( nPor_file,3)                                          + ;
             '   '                                                      + ;
             ' '                                                        + ;
             prikuhhd ->cbanis  +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := '2'                                                        + ;
             ' '                                                        + ;
             AllTrim( Bank_UCET(prikuhhd->cBank_Uct)[1])+'-'            + ;
             AllTrim( Bank_UCET(prikuhhd->cBank_Uct)[2])                + ;
             ' '                                                        + ;
             AllTrim( StrTran( Str( prikuhhd ->nCENzakCEL, 14, 2), '.', '' )) + ;
             ' '                                                        + ;
             mh_DDMMYY( prikuhhd ->dPrikUHR) +CRLF
  fWrite( nfile_kom, cBuffer )

  Do While .not.prikuhit ->( Eof())
    cBuffer := AllTrim( Bank_UCET(prikuhit ->cBank_Uct)[1])+'-'         + ;
               AllTrim( Bank_UCET(prikuhit ->cBank_Uct)[2])             + ;
               ' '                                                      + ;
               AllTrim( StrTran( Str( prikuhit ->nPRIuhrCEL, 12, 2), '.', '' )) + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cVARSYM )                            + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cBanis )                             + ;
               StrZero( prikuhit ->nKonstSymb,4)                        + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cSpecSymb)  +CRLF
    fWrite( nfile_kom, cBuffer )

    prikuhit ->( dbSkip())
    nRadek++
  EndDo

  cBuffer := '3 +'  +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := '5 +'  +CRLF
  fWrite( nfile_kom, cBuffer )

  FCLOSE( nfile_kom)

return(NIL)


// Export bankovních platebních pøíkazù - KB - formát BEST - tuzemský
function DIST000052( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  npor_file := 0
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aSum

  aSum := {{0,0},{0,0},{0,0}}

  npor_file++
  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )

  cBuffer := 'HI'                                                       + ;
             '000000000'                                                + ;
             Right( DtoS(Date()),6)                                     + ;
             Padr(Left(AllTrim( SysConfig('System:cPodnik')),14),14)    + ;
             Space(35)                                                  + ;
             '   '                                                      + ;
             SPACE(282)  +CRLF
  fWrite( nfile_kom, cBuffer )
*               prikuhit ->cTypPlatby +' '                              + ;

  Do While .not.prikuhit ->( Eof())
    cBuffer := '01'                                                         + ;
               StrZero( Val( Right( Str( isNull( prikuhit ->sID, 0), 10),5)), 5)       + ;
               DtoS( Date())                                               + ;
               DtoS( prikuhit ->dUHRbanDNE )                               + ;
               AllTrim( prikuhhd ->czkratmeny)                             + ;
               StrTran( StrZero( prikuhit ->nPRIuhrCEL, 16, 2 ), '.', '' ) + ;
               '0'                                                         + ;
               AllTrim( prikuhit ->czkratmenu)                             + ;
               'P'                                                         + ;
               StrZero( prikuhit ->nKonstSYMB, 10)                         + ;
               Padr( Alltrim( prikuhit ->cPopis1Plt),140)                  + ;
               Space(3)                                                    + ;
               Padr( AllTrim( prikuhhd ->cBanis ),4,'0')                   + ;
               AllTrim( Bank_UCET( prikuhhd->cBank_Uct)[1])                + ;
               AllTrim( Bank_UCET( prikuhhd->cBank_Uct)[2])                + ;
               StrZero( Val( Left( prikuhit->cVARSYM  , 10)), 10)          + ;
               StrZero( Val( Left( prikuhit->cSPECSYMB, 10)), 10)          + ;
               Padr( Alltrim( prikuhit ->cPopis2Plt),30)                   + ;
               Space(3)                                                    + ;
               Padr( AllTrim( prikuhit ->cBanis ),4,'0')                   + ;
               AllTrim( Bank_UCET(prikuhit->cBank_Uct)[1])                 + ;
               AllTrim( Bank_UCET(prikuhit->cBank_Uct)[2])                 + ;
               StrZero( Val( Left( prikuhit->cVARSYM  , 10)), 10)          + ;
               StrZero( Val( Left( prikuhit->cSPECSYMB, 10)), 10)          + ;
               Padr( Alltrim( prikuhit ->cPopis1Uhr),30)                   + ;
               if( prikuhit->nPrioriUhr = 1, 'E',                            ;
                 if( prikuhit->nPrioriUhr = 2, 'A', 'S'))                  + ;
               '0'                                                         + ;
               Space(7) +CRLF
    fWrite( nfile_kom, cBuffer )

    aSum[1,1]++
    aSum[1,2] += prikuhit ->nPriUhrCel

    prikuhit ->( dbSkip())
  EndDo

  cBuffer := 'TI'                                                       + ;
             '000000000'                                                + ;
             Right( DtoS(Date()),6)                                     + ;
             StrZero( aSum[1,1], 6)                                     + ;
             StrTran( StrZero( aSum[1,2], 19, 2 ), '.', '' )            + ;
             Space(310) +CRLF
  fWrite( nfile_kom, cBuffer )

  FCLOSE( nfile_kom)

return(NIL)


// Export bankovních platebních pøíkazù - KB - formát BEST - zahranièní
function DIST000053( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  npor_file := 0
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aSum

  aSum := {{0,0},{0,0},{0,0}}

  npor_file++
  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )

  cBuffer := 'HI'                                                       + ;
             '000000000'                                                + ;
             Right( DtoS(Date()),6 )                                    + ;
             Padr(Left(AllTrim( SysConfig('System:cPodnik')),14),14)    + ;
             Space(35)                                                  + ;
             '   '                                                      + ;
             SPACE(813)  +CRLF
  fWrite( nfile_kom, cBuffer )
*               prikuhit ->cTypPlatby +' '                              + ;

  Do While .not.prikuhit ->( Eof())
    cBuffer := '02'                                                        + ;
               '000000'                                                    + ;
               StrZero( Val( Right( Str( isNull( prikuhit ->sID, 0), 10),5)), 5)       + ;
               DtoS( Date())                                               + ;
               DtoS( prikuhit ->dUHRbanDNE )                               + ;
               AllTrim( prikuhhd ->czkratmenU)                             + ;
               StrTran( StrZero( prikuhit ->nPRIuhrCEL, 16, 2 ), '.', '' ) + ;
               AllTrim( prikuhit ->cPoplatUhr)                             + ;
               AllTrim( Bank_UCET( prikuhit->cPoplatUct)[1])               + ;
               AllTrim( Bank_UCET( prikuhit->cPoplatUct)[2])               + ;
               Padr( AllTrim( prikuhit ->czkratmenP),3)                    + ;
               if( prikuhit->nPrioriUhr = 2, 'A', 'E')                     + ;
               Space(10)                                                   + ;
               Space(10)                                                   + ;
               Space(10)                                                   + ;
               ' '                                                         + ;
               Space(16)                                                   + ;
               Space( 3)                                                   + ;
               Padr( AllTrim( prikuhhd ->cBanis ),4,'0')                   + ;
               AllTrim( Bank_UCET( prikuhhd->cBank_Uct)[1])                + ;
               AllTrim( Bank_UCET( prikuhhd->cBank_Uct)[2])                + ;
               AllTrim( prikuhhd ->czkratmeny)                             + ;
               Space(105)                                                  + ;
               Padr( AllTrim( prikuhit ->cBIC), 35)                        + ;
               Space(35)                                                   + ;
               Space(35)                                                   + ;
               Space(35)                                                   + ;
               Space(35)                                                   + ;
               '/VS/' +StrZero( Val( Left( prikuhit->cVARSYM,10)),10)      + ;
               Space(6)                                                    + ;
               '/KS/' +StrZero( prikuhit->nKonstSYMB,7)                    + ;
               Space(9)                                                    + ;
               Space(100)                                                  + ;
               '/'                                                         + ;
               Padr( Alltrim( prikuhit ->cIban),34)                        + ;
               Padr( Alltrim( Left( prikuhit ->cnazev,35)),35)             + ;
               Padr( Alltrim( Left( prikuhit ->culice,35)),35)             + ;
               Padr( Alltrim( Left( prikuhit ->csidlo,28))+ ' ' +            ;
                      Alltrim( Left( prikuhit ->cpsc,6)) ,35)              + ;
               Padr( Alltrim( Left( prikuhit ->czkratstat, 35)),35)        + ;
               Padr( Alltrim( Left( prikuhit ->cbank_naz,35)),35)          + ;
               Padr( Alltrim( Left( prikuhit ->cbank_uli,35)),35)          + ;
               Padr( Alltrim( Left( prikuhit ->cbank_sid,28))+ ' ' +         ;
                      Alltrim( Left( prikuhit ->cbank_psc,6)) ,35)         + ;
               Padr( Alltrim( Left( prikuhit ->cbank_sta, 35)),35)         + ;
               'N'                                                         + ;
               'N'                                                         + ;
               '  ' +CRLF
    fWrite( nfile_kom, cBuffer )

    aSum[1,1]++
    aSum[1,2] += prikuhit ->nPriUhrCel

    prikuhit ->( dbSkip())
  EndDo

  cBuffer := 'TI'                                                       + ;
             '000000000'                                                + ;
             Right( DtoS(Date()),6 )                                    + ;
             StrZero( aSum[1,1], 6)                                     + ;
             StrTran( StrZero( aSum[1,2], 19, 2 ), '.', '' )            + ;
             Space(841) +CRLF
  fWrite( nfile_kom, cBuffer )

  FCLOSE( nfile_kom)

return(NIL)


// Export bankovních platebních pøíkazù - KB - formát EDI-BEST - tuzemský
function DIST000054( oxbp )

return(NIL)


// Export bankovních platebních pøíkazù - KB - formát EDI-BEST - zahranièní
function DIST000055( oxbp )

return(NIL)


// Export bankovních platebních pøíkazù - KB - formát XML-SEPA
function DIST000056( oxbp )

return(NIL)


// Export bankovních platebních pøíkazù - ÈS - formát KM - tuzemský
function DIST000057( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  npor_file := 0
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aSum

  aSum := {{0,0},{0,0},{0,0}}

  npor_file++
  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )


  cBuffer := 'UHL1'                                                     + ;
             mh_DDMMYY( DATE())                                         + ;
             Padr(Left(AllTrim( SysConfig('System:cPodnik')),20),20)    + ;
             Str( 1,10,0)                                               + ;
             Str( nPor_file,3)                                          + ;
             '999'                                                      + ;
             Space(12) +CRLF
  fWrite( nfile_kom, cBuffer )
*               prikuhit ->cTypPlatby +' '                              + ;

  cBuffer := '1 1501'                                                   + ;
             ' '                                                        + ;
             Str( nPor_file,3)                                          + ;
             '   '                                                      + ;
             ' '                                                        + ;
             prikuhhd ->cbanis  +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := '2'                                                        + ;
             ' '                                                        + ;
             AllTrim( Bank_UCET(prikuhhd->cBank_Uct)[1])+'-'            + ;
             AllTrim( Bank_UCET(prikuhhd->cBank_Uct)[2])                + ;
             ' '                                                        + ;
             AllTrim( StrTran( Str( prikuhhd ->nCENzakCEL, 14, 2), '.', '' )) + ;
             ' '                                                        + ;
             mh_DDMMYY( prikuhhd ->dPrikUHR) +CRLF
  fWrite( nfile_kom, cBuffer )

  Do While .not.prikuhit ->( Eof())
    cBuffer := AllTrim( Bank_UCET(prikuhit ->cBank_Uct)[1])+'-'         + ;
               AllTrim( Bank_UCET(prikuhit ->cBank_Uct)[2])             + ;
               ' '                                                      + ;
               AllTrim( StrTran( Str( prikuhit ->nPRIuhrCEL, 12, 2), '.', '' )) + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cVARSYM )                            + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cBanis )                             + ;
               StrZero( prikuhit ->nKonstSymb,4)                        + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cSpecSymb)  +CRLF
    fWrite( nfile_kom, cBuffer )

    prikuhit ->( dbSkip())
    nRadek++
  EndDo

  cBuffer := '3 +'  +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := '5 +'  +CRLF
  fWrite( nfile_kom, cBuffer )

  FCLOSE( nfile_kom)

return(NIL)


// Export bankovních platebních pøíkazù - ÈS - formát MTC - tuzemský
function DIST000058( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aSum

  aSum := {{0,0},{0,0},{0,0}}

  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )

  Do While .not.prikuhit ->( Eof())
    cBuffer := 'HD:'                                                   + ;
               '11' +' '                              + ;
               SubStr( DTOS(prikuhhd->dUhrBanDne ),3) +' '             + ;
               Bank_KOD(prikuhit ->cBank_Uct) +' '                     + ;
               AllTrim( Str( nRadek)) +' '                             + ;
               Bank_KOD(prikuhit ->cUcet) +CRLF
    fWrite( nfile_kom, cBuffer )
*               prikuhit ->cTypPlatby +' '                              + ;

    cBuffer := 'KC:'                                                   + ;
               AllTrim( StrTran( Str( prikuhit ->nPriUhrCel),'.','') ) +' '       + ;
               '000000' +' '                                           + ;
               AllTrim( prikuhit ->cZkratMenZ)  +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'UD:'                                                   + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[1])+' '        + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[2])+' '        + ;
               Left( AllTrim( prikuhhd ->cBank_Naz), 20)  +CRLF
    fWrite( nfile_kom, cBuffer )

*    cBuffer := 'AD:'                                                   + ;
*                  +CRLF
*    fWrite( nfile_kom, cBuffer )

    cBuffer := 'DI:'                                                   + ;
               Left(AllTrim( SysConfig('System:cPodnik')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cUlice')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cSidlo')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cPsc')),35) + ', '      + ;
               Left(AllTrim( SysConfig('System:cZkrStaOrg')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := 'UK:'                                                   + ;
               AllTrim( Bank_UCET(prikuhit ->cUcet)[1])+' '            + ;
               AllTrim( Bank_UCET(prikuhit ->cUcet)[2])+' '            + ;
               Left( AllTrim( prikuhit ->cBank_Naz), 20) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'AK:'                                                   + ;
               AllTrim( prikuhit ->cSpecSymb) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'KI:'                                                   + ;
               Left( AllTrim( prikuhit ->cNazev),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := '   '                                                   + ;
               Left( AllTrim( prikuhit ->cUlice),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := '   '                                                   + ;
               Left( AllTrim( prikuhit ->cSidlo),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := '   '                                                   + ;
               Left( AllTrim( prikuhit ->cPsc),35) + ', '              + ;
               Left( AllTrim( prikuhit ->cZkratStat),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'EC:'                                                   + ;
               AllTrim( Str( prikuhit ->nKonstSymb)) +CRLF
    fWrite( nfile_kom, cBuffer )

*    cBuffer := 'ZD:'                                                   + ;
*               AllTrim( prikuhit ->cVarSym) +CRLF
*    fWrite( nfile_kom, cBuffer )

    cBuffer := 'ZK:'                                                   + ;
               AllTrim( prikuhit ->cVarSym) +CRLF
    fWrite( nfile_kom, cBuffer )


    do case
    case prikuhit ->cTypPlatby = '01'
      aSum[1,1]++
      aSum[1,2] += prikuhit ->nPriUhrCel
    case prikuhit ->cTypPlatby = '32'
      aSum[3,1]++
      aSum[3,2] += prikuhit ->nPriUhrCel
    otherwise       //prikuhit ->cTypPlatby = '11'
      aSum[2,1]++
      aSum[2,2] += prikuhit ->nPriUhrCel
   endcase

    prikuhit ->( dbSkip())
    nRadek++
  EndDo

  if aSum[1,1] > 0
    cBuffer := 'S0:'                                                      + ;
               StrZero(aSum[1,1],9) +' '                                  + ;
               if( aSum[1,2] = 0, '000',AllTrim( StrTran(Str( aSum[1,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
  endif

  if aSum[2,1] > 0
    cBuffer := 'S1:'                                                      + ;
               StrZero(aSum[2,1],9) +' '                                  + ;
               if( aSum[2,2] = 0, '000',AllTrim( StrTran(Str( aSum[2,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
    if aSum[3,1] = 0
      cBuffer := 'S3:'                                                    + ;
                 StrZero( 0,9) +' '                                       + ;
                 '000' +CRLF
      fWrite( nfile_kom, cBuffer )
    endif
  endif

  if aSum[3,1] > 0
    cBuffer := 'S3:'                                                      + ;
               StrZero(aSum[3,1],9) +' '                                  + ;
               if( aSum[3,2] = 0, '000', AllTrim( StrTran(Str( aSum[3,2]),'.','' )))+CRLF
    fWrite( nfile_kom, cBuffer )
  endif

  FCLOSE( nfile_kom)

return(NIL)


// Export bankovních platebních pøíkazù - Èeská spoøitelna - formát MTC - zahranièní
function DIST000059( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aPrikUhr
  local  aLineUhr
  local  aSum

  aPrikUhr := {{},'',0,0,'',''}
  aSum     := {{0,0},{0,0},{0,0}}
  aLineUhr := {}

  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )


  Do While .not.prikuhit ->( Eof())
    cBuffer := ':20'                                                   + ;
               'REFERENCE ZAKAZNIKA' +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':32A:'                                                 + ;
               SubStr( DTOS(prikuhit->dUhrBanDne ),3)                  + ;
               AllTrim( prikuhit ->cZkratMenZ)                         + ;
               AllTrim( Str( prikuhit ->nPriUhrCel,2))   +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':50:'                                                 + ;
               Left(AllTrim( SysConfig('System:cPodnik')),35) +CRLF
    AAdd( aLineUhr, cBuffer )
    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cUlice')),35) +CRLF
    AAdd( aLineUhr, cBuffer )
    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cSidlo')),35) +CRLF
    AAdd( aLineUhr, cBuffer )
    cBuffer := Left(AllTrim( SysConfig('System:cPsc')),35) + ', '      + ;
               Left(AllTrim( SysConfig('System:cZkrStaOrg')),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := '52D:'                                                   + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[1])+            + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[2])+CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[1])+            + ;
               AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[2])+CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[1])+            + ;
               AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[2])+CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := AllTrim( prikuhhd ->cZkratMeny) + ' '                     + ;
               AllTrim( prikuhit ->cZkratMenP) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := if( Empty(prikuhit ->cPlatTitul),'000', AllTrim( prikuhit ->cPlatTitul)) + ' '+ ;
                 AllTrim( prikuhit ->cZkratStat) +' '                    + ;
                  AllTrim( prikuhit ->cBank_Sta) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':57A:'                                                   + ;
                 AllTrim( prikuhit ->cBIC) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':57D:'                                                   + ;
                 Left( AllTrim( prikuhit ->cBank_Naz),35) +CRLF          + ;
                 Space(2)  +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer :=   Left( AllTrim( prikuhit ->cBank_Uli),35) +CRLF          + ;
                 Left( AllTrim( prikuhit ->cBank_Sid),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':59:'                                                    + ;
                 '/'                                                     + ;
                 Left( AllTrim( prikuhit ->cIBAN),34) +CRLF               + ;
                 SubStr( AllTrim( prikuhit ->cNazev),1,35) +CRLF          + ;
                 SubStr( AllTrim( prikuhit ->cNazev),36) +CRLF            + ;
                 Left( AllTrim( prikuhit ->cUlice),35) +CRLF              + ;
                 Left( AllTrim( prikuhit ->cSidlo),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':70:'                                                    + ;
                 Left( AllTrim( prikuhit ->cPopis1Uhr),35) +CRLF         + ;
                 Left( AllTrim( prikuhit ->cPopis2Uhr),35) +CRLF         + ;
                 Left( AllTrim( prikuhit ->cPopis3Uhr),35) +CRLF         + ;
                 Left( AllTrim( prikuhit ->cPopis4Uhr),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':71A:'
    do case
    case prikuhit ->cPoplatUhr = 'SHA'  ;   cBuffer += 'BN1' + CRLF
    case prikuhit ->cPoplatUhr = 'OUR'  ;   cBuffer += 'OUR' + CRLF
    case prikuhit ->cPoplatUhr = 'BEN'  ;   cBuffer += 'BN2' + CRLF
    endcase
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':72:'                                                    + ;
               '00 00 00 00' + CRLF                                      + ;
               Space(35) +CRLF                                           + ; // kontaktní osoba
               Space(35) +CRLF                                           + ; // rozšíøený text
               Left( AllTrim( prikuhit ->cPopis1Ban),35) +CRLF           + ;
               Left( AllTrim( prikuhit ->cPopis2Ban),35) +CRLF           + ;
               Left( AllTrim( prikuhit ->cPopis3Ban),35) +CRLF
    AAdd( aLineUhr, cBuffer )

//   cBuffer := '-}'
//    AAdd( aLineUhr, cBuffer )

    AAdd( aPrikUhr[1], {aLineUhr, prikuhhd ->cBANIS,prikuhit ->cBic} )
    aPrikUhr[3]++
    aPrikUhr[4] += prikuhit ->nUhrCelFak
    prikuhit ->( dbSkip())
  EndDo

// vygeneruje záhlaví souboru

  cBuffer := ':01:'                                                       + ;
                    '000' +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':02:'                                                       + ;
                 Str( aPrikUhr[4],2) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':03:'                                                       + ;
                 StrZero( aPrikUhr[3],5) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':04:'                                                       + ;
                   AllTrim( prikuhhd ->cBic) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':05:'                                                         + ;
             Left(AllTrim( SysConfig('System:cPodnik')),35) +CRLF
  fWrite( nfile_kom, cBuffer )
  cBuffer := '   '                                                          + ;
             Left(AllTrim( SysConfig('System:cUlice')),35) +CRLF
  fWrite( nfile_kom, cBuffer )
  cBuffer := '   '                                                          + ;
             Left(AllTrim( SysConfig('System:cSidlo')),35) +CRLF
  fWrite( nfile_kom, cBuffer )
  cBuffer := Left(AllTrim( SysConfig('System:cPsc')),35) + ', '             + ;
             Left(AllTrim( SysConfig('System:cZkrStaOrg')),35) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':07:'                                                         + ;
                   Left( AllTrim( cfile_kom), 12) +CRLF
  fWrite( nfile_kom, cBuffer )

  for n = 1 to Len( aPrikUhr[1])
    cBuffer := if( n = 1, '', '-}$')                                          + ;
                '{1:F01' +aPrikUhr[1,2] +'XXXXAXXX' + StrZero( 1, 4)         + ;
                  StrZero( 0, 6) + '}'                                       + ;
                  '{2:I100' + PadR( aPrikUhr[1,3],12) +'N' +'1}'             + ;
                    '{4:' +CRLF
    fWrite( nfile_kom, cBuffer )
    for i = 1 to Len( aPrikUhr[1,1])
      cBuffer := aPrikUhr[1,1,i]
      fWrite( nfile_kom, cBuffer )
    next
  next

  cBuffer := '-}' +CRLF
  fWrite( nfile_kom, cBuffer )

  FCLOSE( nfile_kom)


/*
  if aSum[1,1] > 0
    cBuffer := 'S0:'                                                      + ;
               StrZero(aSum[1,1],9) +' '                                  + ;
               if( aSum[1,2] = 0, '000',AllTrim( StrTran(Str( aSum[1,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
  endif

  if aSum[2,1] > 0
    cBuffer := 'S1:'                                                      + ;
               StrZero(aSum[2,1],9) +' '                                  + ;
               if( aSum[2,2] = 0, '000',AllTrim( StrTran(Str( aSum[2,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
    if aSum[3,1] = 0
      cBuffer := 'S3:'                                                    + ;
                 StrZero( 0,9) +' '                                       + ;
                 '000' +CRLF
      fWrite( nfile_kom, cBuffer )
    endif
  endif

  if aSum[3,1] > 0
    cBuffer := 'S3:'                                                      + ;
               StrZero(aSum[3,1],9) +' '                                  + ;
               if( aSum[3,2] = 0, '000', AllTrim( StrTran(Str( aSum[3,2]),'.','' )))+CRLF
    fWrite( nfile_kom, cBuffer )
  endif
*/
  FCLOSE( nfile_kom)

return(NIL)


// Export bankovních platebních pøíkazù - Èeská spoøitelna - formát CSV - zahranièní
function DIST000060( oxbp )

return(NIL)


// Export bankovních platebních pøíkazù - ÈSOB - formát KM - tuzemský
function DIST000061( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  npor_file := 0
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aSum

  aSum := {{0,0},{0,0},{0,0}}

  npor_file++
  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )


  cBuffer := 'UHL1'                                                     + ;
             mh_DDMMYY( DATE())                                         + ;
             Padr(Left(AllTrim( SysConfig('System:cPodnik')),20),20)    + ;
             Str( 1,10,0)                                               + ;
             Str( nPor_file,3)                                          + ;
             '999'                                                      + ;
             Space(12) +CRLF
  fWrite( nfile_kom, cBuffer )
*               prikuhit ->cTypPlatby +' '                              + ;

  cBuffer := '1 1501'                                                   + ;
             ' '                                                        + ;
             Str( nPor_file,3)                                          + ;
             '   '                                                      + ;
             ' '                                                        + ;
             prikuhhd ->cbanis  +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := '2'                                                        + ;
             ' '                                                        + ;
             AllTrim( Bank_UCET(prikuhhd->cBank_Uct)[1])+'-'            + ;
             AllTrim( Bank_UCET(prikuhhd->cBank_Uct)[2])                + ;
             ' '                                                        + ;
             AllTrim( StrTran( Str( prikuhhd ->nCENzakCEL, 14, 2), '.', '' )) + ;
             ' '                                                        + ;
             mh_DDMMYY( prikuhhd ->dPrikUHR) +CRLF
  fWrite( nfile_kom, cBuffer )

  Do While .not.prikuhit ->( Eof())
    cBuffer := AllTrim( Bank_UCET(prikuhit ->cBank_Uct)[1])+'-'         + ;
               AllTrim( Bank_UCET(prikuhit ->cBank_Uct)[2])             + ;
               ' '                                                      + ;
               AllTrim( StrTran( Str( prikuhit ->nPRIuhrCEL, 12, 2), '.', '' )) + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cVARSYM )                            + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cBanis )                             + ;
               StrZero( prikuhit ->nKonstSymb,4)                        + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cSpecSymb)  +CRLF
    fWrite( nfile_kom, cBuffer )

    prikuhit ->( dbSkip())
    nRadek++
  EndDo

  cBuffer := '3 +'  +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := '5 +'  +CRLF
  fWrite( nfile_kom, cBuffer )

  FCLOSE( nfile_kom)

return(NIL)


// Export bankovních platebních pøíkazù - ÈSOB - formát MTC - tuzemský
function DIST000062( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aSum

  aSum := {{0,0},{0,0},{0,0}}

  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )

  Do While .not.prikuhit ->( Eof())
    cBuffer := 'HD:'                                                   + ;
               '11' +' '                              + ;
               SubStr( DTOS(prikuhit->dUhrBanDne ),3) +' '             + ;
               Bank_KOD(prikuhhd ->cBank_Uct) +' '                     + ;
               AllTrim( Str( nRadek)) +' '                             + ;
               Bank_KOD(prikuhit ->cUcet) +CRLF
    fWrite( nfile_kom, cBuffer )
*               prikuhit ->cTypPlatby +' '                              + ;

    cBuffer := 'KC:'                                                   + ;
               AllTrim( StrTran( Str( prikuhit ->nPriUhrCel),'.','') ) +' '       + ;
               '000000' +' '                                           + ;
               AllTrim( prikuhit ->cZkratMenZ)  +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'UD:'                                                   + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[1])+' '        + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[2])+' '        + ;
               Left( AllTrim( prikuhhd ->cBank_Naz), 20)  +CRLF
    fWrite( nfile_kom, cBuffer )

*    cBuffer := 'AD:'                                                   + ;
*                  +CRLF
*    fWrite( nfile_kom, cBuffer )

    cBuffer := 'DI:'                                                   + ;
               Left(AllTrim( SysConfig('System:cPodnik')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cUlice')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cSidlo')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cPsc')),35) + ', '      + ;
               Left(AllTrim( SysConfig('System:cZkrStaOrg')),35) +CRLF
    fWrite( nfile_kom, cBuffer)

    cBuffer := 'UK:'                                                   + ;
               AllTrim( Bank_UCET(prikuhit ->cUcet)[1])+' '            + ;
               AllTrim( Bank_UCET(prikuhit ->cUcet)[2])+' '            + ;
               Left( AllTrim( prikuhit ->cBank_Naz), 20) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'AK:'                                                   + ;
               AllTrim( prikuhit ->cSpecSymb) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'KI:'                                                   + ;
               Left( AllTrim( prikuhit ->cNazev),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := '   '                                                   + ;
               Left( AllTrim( prikuhit ->cUlice),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := '   '                                                   + ;
               Left( AllTrim( prikuhit ->cSidlo),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := '   '                                                   + ;
               Left( AllTrim( prikuhit ->cPsc),35) + ', '              + ;
               Left( AllTrim( prikuhit ->cZkratStat),35) +CRLF
    fWrite( nfile_kom, cBuffer )

    cBuffer := 'EC:'                                                   + ;
               AllTrim( Str( prikuhit ->nKonstSymb)) +CRLF
    fWrite( nfile_kom, cBuffer )

*    cBuffer := 'ZD:'                                                   + ;
*               AllTrim( prikuhit ->cVarSym) +CRLF
*    fWrite( nfile_kom, cBuffer )

    cBuffer := 'ZK:'                                                   + ;
               AllTrim( prikuhit ->cVarSym) +CRLF
    fWrite( nfile_kom, cBuffer )


    do case
    case prikuhit ->cTypPlatby = '01'
      aSum[1,1]++
      aSum[1,2] += prikuhit ->nPriUhrCel
    case prikuhit ->cTypPlatby = '32'
      aSum[3,1]++
      aSum[3,2] += prikuhit ->nPriUhrCel
    otherwise       //prikuhit ->cTypPlatby = '11'
      aSum[2,1]++
      aSum[2,2] += prikuhit ->nPriUhrCel
   endcase

    prikuhit ->( dbSkip())
    nRadek++
  EndDo

  if aSum[1,1] > 0
    cBuffer := 'S0:'                                                      + ;
               StrZero(aSum[1,1],9) +' '                                  + ;
               if( aSum[1,2] = 0, '000',AllTrim( StrTran(Str( aSum[1,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
  endif

  if aSum[2,1] > 0
    cBuffer := 'S1:'                                                      + ;
               StrZero(aSum[2,1],9) +' '                                  + ;
               if( aSum[2,2] = 0, '000',AllTrim( StrTran(Str( aSum[2,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
    if aSum[3,1] = 0
      cBuffer := 'S3:'                                                    + ;
                 StrZero( 0,9) +' '                                       + ;
                 '000' +CRLF
      fWrite( nfile_kom, cBuffer )
    endif
  endif

  if aSum[3,1] > 0
    cBuffer := 'S3:'                                                      + ;
               StrZero(aSum[3,1],9) +' '                                  + ;
               if( aSum[3,2] = 0, '000', AllTrim( StrTran(Str( aSum[3,2]),'.','' )))+CRLF
    fWrite( nfile_kom, cBuffer )
  endif

  FCLOSE( nfile_kom)

return(NIL)



// Export bankovních platebních pøíkazù - ÈSOB - formát MTC - zahranièní
function DIST000063( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aPrikUhr
  local  aLineUhr
  local  aSum

  aPrikUhr := {{},'',0,0,'',''}
  aSum     := {{0,0},{0,0},{0,0}}
  aLineUhr := {}

  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )


  Do While .not.prikuhit ->( Eof())
    cBuffer := ':20'                                                   + ;
               'REFERENCE ZAKAZNIKA' +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':32A:'                                                 + ;
               SubStr( DTOS(prikuhit->dUhrBanDne ),3)                  + ;
               AllTrim( prikuhit ->cZkratMenZ)                         + ;
               AllTrim( Str( prikuhit ->nPriUhrCel,2))   +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':50:'                                                 + ;
               Left(AllTrim( SysConfig('System:cPodnik')),35) +CRLF
    AAdd( aLineUhr, cBuffer )
    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cUlice')),35) +CRLF
    AAdd( aLineUhr, cBuffer )
    cBuffer := '   '                                                   + ;
               Left(AllTrim( SysConfig('System:cSidlo')),35) +CRLF
    AAdd( aLineUhr, cBuffer )
    cBuffer := Left(AllTrim( SysConfig('System:cPsc')),35) + ', '      + ;
               Left(AllTrim( SysConfig('System:cZkrStaOrg')),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := '52D:'                                                   + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[1])+            + ;
               AllTrim( Bank_UCET(prikuhhd ->cBank_Uct)[2])+CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[1])+            + ;
               AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[2])+CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[1])+            + ;
               AllTrim( Bank_UCET(prikuhit ->cPoplatUct)[2])+CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := AllTrim( prikuhhd ->cZkratMeny) + ' '                     + ;
               AllTrim( prikuhit ->cZkratMenP) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := if( Empty(prikuhit ->cPlatTitul),'000', AllTrim( prikuhit ->cPlatTitul)) + ' '+ ;
                 AllTrim( prikuhit ->cZkratStat) +' '                    + ;
                  AllTrim( prikuhit ->cBank_Sta) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':57A:'                                                   + ;
                 AllTrim( prikuhit ->cBIC) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':57D:'                                                   + ;
                 Left( AllTrim( prikuhit ->cBank_Naz),35) +CRLF          + ;
                 Space(2)  +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer :=   Left( AllTrim( prikuhit ->cBank_Uli),35) +CRLF          + ;
                 Left( AllTrim( prikuhit ->cBank_Sid),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':59:'                                                    + ;
                 '/'                                                     + ;
                 Left( AllTrim( prikuhit ->cIBAN),34) +CRLF               + ;
                 SubStr( AllTrim( prikuhit ->cNazev),1,35) +CRLF          + ;
                 SubStr( AllTrim( prikuhit ->cNazev),36) +CRLF            + ;
                 Left( AllTrim( prikuhit ->cUlice),35) +CRLF              + ;
                 Left( AllTrim( prikuhit ->cSidlo),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':70:'                                                    + ;
                 Left( AllTrim( prikuhit ->cPopis1Uhr),35) +CRLF         + ;
                 Left( AllTrim( prikuhit ->cPopis2Uhr),35) +CRLF         + ;
                 Left( AllTrim( prikuhit ->cPopis3Uhr),35) +CRLF         + ;
                 Left( AllTrim( prikuhit ->cPopis4Uhr),35) +CRLF
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':71A:'
    do case
    case prikuhit ->cPoplatUhr = 'SHA'  ;   cBuffer += 'BN1' + CRLF
    case prikuhit ->cPoplatUhr = 'OUR'  ;   cBuffer += 'OUR' + CRLF
    case prikuhit ->cPoplatUhr = 'BEN'  ;   cBuffer += 'BN2' + CRLF
    endcase
    AAdd( aLineUhr, cBuffer )

    cBuffer := ':72:'                                                    + ;
               '00 00 00 00' + CRLF                                      + ;
               Space(35) +CRLF                                           + ; // kontaktní osoba
               Space(35) +CRLF                                           + ; // rozšíøený text
               Left( AllTrim( prikuhit ->cPopis1Ban),35) +CRLF           + ;
               Left( AllTrim( prikuhit ->cPopis2Ban),35) +CRLF           + ;
               Left( AllTrim( prikuhit ->cPopis3Ban),35) +CRLF
    AAdd( aLineUhr, cBuffer )

//   cBuffer := '-}'
//    AAdd( aLineUhr, cBuffer )

    AAdd( aPrikUhr[1], {aLineUhr, prikuhhd ->cBANIS,prikuhit ->cBic} )
    aPrikUhr[3]++
    aPrikUhr[4] += prikuhit ->nUhrCelFak
    prikuhit ->( dbSkip())
  EndDo

// vygeneruje záhlaví souboru

  cBuffer := ':01:'                                                       + ;
                    '000' +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':02:'                                                       + ;
                 Str( aPrikUhr[4],2) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':03:'                                                       + ;
                 StrZero( aPrikUhr[3],5) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':04:'                                                       + ;
                   AllTrim( prikuhhd ->cBic) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':05:'                                                         + ;
             Left(AllTrim( SysConfig('System:cPodnik')),35) +CRLF
  fWrite( nfile_kom, cBuffer )
  cBuffer := '   '                                                          + ;
             Left(AllTrim( SysConfig('System:cUlice')),35) +CRLF
  fWrite( nfile_kom, cBuffer )
  cBuffer := '   '                                                          + ;
             Left(AllTrim( SysConfig('System:cSidlo')),35) +CRLF
  fWrite( nfile_kom, cBuffer )
  cBuffer := Left(AllTrim( SysConfig('System:cPsc')),35) + ', '             + ;
             Left(AllTrim( SysConfig('System:cZkrStaOrg')),35) +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := ':07:'                                                         + ;
                   Left( AllTrim( cfile_kom), 12) +CRLF
  fWrite( nfile_kom, cBuffer )

  for n = 1 to Len( aPrikUhr[1])
    cBuffer := if( n = 1, '', '-}$')                                          + ;
                '{1:F01' +aPrikUhr[1,2] +'XXXXAXXX' + StrZero( 1, 4)         + ;
                  StrZero( 0, 6) + '}'                                       + ;
                  '{2:I100' + PadR( aPrikUhr[1,3],12) +'N' +'1}'             + ;
                    '{4:' +CRLF
    fWrite( nfile_kom, cBuffer )
    for i = 1 to Len( aPrikUhr[1,1])
      cBuffer := aPrikUhr[1,1,i]
      fWrite( nfile_kom, cBuffer )
    next
  next

  cBuffer := '-}' +CRLF
  fWrite( nfile_kom, cBuffer )

  FCLOSE( nfile_kom)


/*
  if aSum[1,1] > 0
    cBuffer := 'S0:'                                                      + ;
               StrZero(aSum[1,1],9) +' '                                  + ;
               if( aSum[1,2] = 0, '000',AllTrim( StrTran(Str( aSum[1,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
  endif

  if aSum[2,1] > 0
    cBuffer := 'S1:'                                                      + ;
               StrZero(aSum[2,1],9) +' '                                  + ;
               if( aSum[2,2] = 0, '000',AllTrim( StrTran(Str( aSum[2,2]),'.','' ))) +CRLF
    fWrite( nfile_kom, cBuffer )
    if aSum[3,1] = 0
      cBuffer := 'S3:'                                                    + ;
                 StrZero( 0,9) +' '                                       + ;
                 '000' +CRLF
      fWrite( nfile_kom, cBuffer )
    endif
  endif

  if aSum[3,1] > 0
    cBuffer := 'S3:'                                                      + ;
               StrZero(aSum[3,1],9) +' '                                  + ;
               if( aSum[3,2] = 0, '000', AllTrim( StrTran(Str( aSum[3,2]),'.','' )))+CRLF
    fWrite( nfile_kom, cBuffer )
  endif
*/
  FCLOSE( nfile_kom)

return(NIL)



// Export bankovních platebních pøíkazù - GM - KB formát KM - tuzemský
function DIST000092( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  npor_file := 0
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aSum

  aSum := {{0,0},{0,0},{0,0}}

  npor_file++
  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  cfile_kom := DBGETVAL(cfile_kom)
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom ))


  cBuffer := 'UHL1'                                                     + ;
             mh_DDMMYY( DATE())                                         + ;
             Padr(Left(AllTrim( SysConfig('System:cPodnik')),20),20)    + ;
             Str( 1,10,0)                                               + ;
             Str( nPor_file,3)                                          + ;
             '999'                                                      + ;
             Space(12) +CRLF
  fWrite( nfile_kom, cBuffer )
*               prikuhit ->cTypPlatby +' '                              + ;

  cBuffer := '1 1501'                                                   + ;
             ' '                                                        + ;
             Str( nPor_file,3)                                          + ;
             '   '                                                      + ;
             ' '                                                        + ;
             prikuhhd ->cbanis  +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := '2'                                                        + ;
             ' '                                                        + ;
             AllTrim( Bank_UCET(prikuhhd->cBank_Uct)[1])+'-'            + ;
             AllTrim( Bank_UCET(prikuhhd->cBank_Uct)[2])                + ;
             ' '                                                        + ;
             AllTrim( StrTran( Str( prikuhhd ->nCENzakCEL, 14, 2), '.', '' )) + ;
             ' '                                                        + ;
             mh_DDMMYY( prikuhhd ->dPrikUHR) +CRLF
  fWrite( nfile_kom, cBuffer )

  Do While .not.prikuhit ->( Eof())
    cBuffer := AllTrim( Bank_UCET(prikuhit ->cBank_Uct)[1])+'-'         + ;
               AllTrim( Bank_UCET(prikuhit ->cBank_Uct)[2])             + ;
               ' '                                                      + ;
               AllTrim( StrTran( Str( prikuhit ->nPRIuhrCEL, 12, 2), '.', '' )) + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cVARSYM )                            + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cBanis )                             + ;
               StrZero( prikuhit ->nKonstSymb,4)                        + ;
               ' '                                                      + ;
               AllTrim( prikuhit ->cSpecSymb)  +CRLF
    fWrite( nfile_kom, cBuffer )

    prikuhit ->( dbSkip())
    nRadek++
  EndDo

  cBuffer := '3 +'  +CRLF
  fWrite( nfile_kom, cBuffer )

  cBuffer := '5 +'  +CRLF
  fWrite( nfile_kom, cBuffer )

  FCLOSE( nfile_kom)

return(NIL)


// Export bankovních platebních pøíkazù - CITIBANK - formát ASCII delimited - pøípona TXT - tuzemský
function DIST000097( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aSum

  aSum := {{0,0},{0,0},{0,0}}

  drgDBMS:open('prikuhhd',,,,,'prikuhhda')

  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )

  cfile_kom := StrTran( cfile_kom, "XXXXXXXXXX", Bank_UCET(prikuhhd ->cBank_Uct)[2])
  cfile_kom := StrTran( cfile_kom, "YYYYMMDD", DTOS(prikuhhd ->dprikuhr))
  cfile_kom := StrTran( cfile_kom, "SSS", StrZero(1,3))
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )

  Do While .not.prikuhit ->( Eof())
    cBuffer := '1' + ','                                                        + ;
                fVAR( StrZero( nRadek, 3)) + ','                                + ;
                fVAR( Bank_UCET(prikuhhd ->cBank_Uct)[2]) + ','                 + ;
                fVAR( '') + ','                                                 + ;
                fVAR( mh_DDMMYYYY( prikuhit->dUhrBanDne)) + ','                 + ;
                AllTrim(Str( prikuhit ->nPriUhrCel)) + ','                      + ;
                fVAR( Bank_UCET(prikuhit ->cUcet)[1]) + ','                     + ;
                fVAR( Bank_UCET(prikuhit ->cUcet)[2]) + ','                     + ;
                fVAR( Bank_KOD(prikuhit ->cUcet)) + ','                         + ;
                fVAR( StrZero( prikuhit ->nKonstSymb,4)) + ','                  + ;
                fVAR( Padl( AllTrim( prikuhit ->cVarSym), 10, '0')) + ','       + ;
                fVAR( AllTrim( prikuhit ->cSpecSymb)) + ','                     + ;
                fVAR( DelDiakr( Upper( Left( AllTrim( prikuhit ->cNazev),35)))) +CRLF
    fWrite( nfile_kom, cBuffer )

    aSum[1,1]++
    aSum[1,2] += prikuhit ->nPriUhrCel

    prikuhit ->( dbSkip())
    nRadek++
  EndDo

  if aSum[1,1] > 0
    cBuffer := '9' +','                                                         + ;
               fVAR( StrZero(nRadek,3)) +','                                    + ;
               AllTrim(Str( aSum[1,2])) +CRLF
    fWrite( nfile_kom, cBuffer )
  endif

  FCLOSE( nfile_kom)

return(NIL)



// Export bankovních platebních pøíkazù - CITIBANK - formát ASCII delimited - pøípona TXT - zahranièní
function DIST000098( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  nfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nRadek := 1
  local  aPrikUhr
  local  aLineUhr
  local  aSum

  aPrikUhr := {{},'',0,0,'',''}
  aSum     := {{0,0},{0,0},{0,0}}
  aLineUhr := {}

  prikuhhd ->( dbSeek( prikuhit ->nDoklad,,'FDODHD1'))
  prikuhit ->( dbGoTop())
*  afiles := Directory( cpath_imp + cfile_imp )
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )

  cfile_kom := StrTran( cfile_kom, "XXXXXXXXXX", Bank_UCET(prikuhhd ->cBank_Uct)[2])
  cfile_kom := StrTran( cfile_kom, "YYYYMMDD", DTOS(prikuhhd ->dprikuhr))
  cfile_kom := StrTran( cfile_kom, "SSS", StrZero(1,3))
  nfile_kom := fCreate( AllTrim( cpath_kom) +AllTrim( cfile_kom) )

  Do While .not.prikuhit ->( Eof())
    cBuffer := '1' + ','                                                                   + ;
                fVAR( StrZero( nRadek, 3)) + ','                                           + ;
                fVAR( Bank_UCET(prikuhhd ->cBank_Uct)[2]) + ','                            + ;
                fVAR( '') + ','                                                            + ;
                fVAR( mh_DDMMYYYY( prikuhit->dUhrBanDne)) + ','                            + ;
                AllTrim(Str( prikuhit ->nPriUhrCel)) + ','                                 + ;
                fVAR( DelDiakr( Upper( AllTrim( prikuhit ->cZkratMenZ)))) + ','            + ;
                fVAR( prikuhit ->cUcet) + ','                                              + ;
                fVAR( DelDiakr( Upper( SubStr( AllTrim( prikuhit ->cNazev),1,35)))) + ','  + ;
                fVAR( DelDiakr( Upper( Left( AllTrim( prikuhit ->cUlice),35)))) + ','      + ;
                fVAR( DelDiakr( Upper( Left( AllTrim( prikuhit ->cSidlo),35)))) + ','      + ;
                fVAR( '') + ','                                                            + ;
                fVAR( DelDiakr( Upper( Left( AllTrim( prikuhit ->cBank_Naz),35)))) + ','   + ;
                fVAR( DelDiakr( Upper( Left( AllTrim( prikuhit ->cBank_Uli),35)))) + ','   + ;
                fVAR( DelDiakr( Upper( Left( AllTrim( prikuhit ->cBank_Sid),35)))) + ','   + ;
                fVAR( '') + ','                                                            + ;
                fVAR( AllTrim( prikuhit ->cVarSym)) + ','                                  + ;
                fVAR( '') + ','                                                            + ;
                fVAR( '') + ','                                                            + ;
                fVAR( '') + ','                                                            + ;
                fVAR( DelDiakr( Upper( AllTrim( prikuhit ->cPoplatUhr)))) + ','            + ;
                fVAR( '1') + ','                                                           + ;
                fVAR( DelDiakr( Upper( Left( AllTrim( prikuhit ->cPlatTitul),7))))         +CRLF
    fWrite( nfile_kom, cBuffer )

    aSum[1,1]++
    aSum[1,2] += prikuhit ->nPriUhrCel

    prikuhit ->( dbSkip())
    nRadek++
  EndDo

  if aSum[1,1] > 0
    cBuffer := '9' +','                                                                    + ;
               fVAR( StrZero(nRadek,3)) +','                                               + ;
               AllTrim(Str( aSum[1,2])) +CRLF
    fWrite( nfile_kom, cBuffer )
  endif

  FCLOSE( nfile_kom)



return(NIL)




// Import bankovních výpisù - CITIBANK - formát ASCII delimited - pøípona CSV
function DIST000099( oxbp )
  local  cpath_kom := oXbp:cpath_kom
  local  cfile_kom := oXbp:cfile_kom
  local  istuz     := oXbp:istuz
  *
  local  cbank_uct_int
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  local  alines, aline, i, j
  local  read_ok
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  local  dDatPoVyp, cbank_uct, ncispovyp
  local  nrok_vyp


  afiles := Directory( cpath_kom + cfile_kom )

  for x := 1 to len(afiles) step 1
    file := cpath_kom +afiles[x, F_NAME]

    nHandle  := FOpen( file, FO_READ )
    cBuffer  := FReadStr(nHandle,1024)
    alines := mh_token( cBuffer, CRLF)

    do while cBuffer <> ''
      read_ok := .t.
      for i := 1 to len( alines)
        aline := mh_token( alines[i], ',')

        if len( aline) > 0
          do case
          case Val(aline[1]) = 1 .and. Len(aline) = 15
          // hlavièka
            cBank_Uct := aline[2]
            *
            dDatPoVyp := CtoD( SubStr( aline[5], 2,2) +'.' +  ;
                               SubStr( aline[5], 4,2) +'.' +  ;
                               SubStr( aline[5], 6,4))
            nrok_vyp  := year( dDatPoVyp )
            *
            ncispovyp := DoY( dDatPoVyp)

            *
            cky       := strZero(nrok_vyp,4) +upper(cbank_uct) +strZero(ncispovyp,6)
            lis_ok    := .f.

            if .not. banvyph_im->(dbseek( cky,, 'BANIMPH_2'))
              lis_ok := .t.

              banvyph_im ->( dbAppend())
              banvyph_im ->cBank_Uce := padL( AllTrim( aline[2]),16,'0')
              banvyph_im ->cfile_imp := parseFileName( file,4 )
              banvyph_im ->dDatPoVyp := CtoD( SubStr( aline[5], 2,2) +'.' +  ;
                                              SubStr( aline[5], 4,2) +'.' +  ;
                                              SubStr( aline[5], 6,4))
              banvyph_im ->nposzust  := Val(aline[7]) *      ;
                                             if(aline[6]='-',-1,1)
              banvyph_im ->nzustatek := Val(aline[9]) *      ;
                                             if(aline[10]='-',-1,1)
              banvyph_im ->nvydej    := Val(aline[11])
              banvyph_im ->nprijem   := Val(aline[13])
              banvyph_im ->ncispovyp := DoY( dDatPoVyp)
              banvyph_im ->dDatZust  := dDatPoVyp
              banvyph_im ->ciban     := c_bankuc->cIban   // SubStr( cBuffer, 137,24)
              banvyph_im ->dDatPoriz := banvyph_im->dDatZust
              banvyph_im ->nrok_vyp  := year( banvyph_im ->dDatPoVyp )
            endif
            banvyph_im ->(dbCommit())

          case Val(aline[1]) = 2 .and. Len(aline) = 45
          // položka
            if lis_ok
              banvypi_im ->( dbAppend())
              banvyph_im ->npocPoloz := banvyph_im ->npocPoloz +1
              banvypi_im ->cfile_imp := banvyph_im ->cfile_imp
              banvypi_im ->nrok_vyp  := banvyph_im ->nrok_vyp
              banvypi_im ->cbank_uce := banvyph_im ->cbank_uce
              banvypi_im ->ncisPoVyp := banvyph_im ->ncispovyp

              do case
              case Val(aline[8]) = 1
                banvypi_im ->nvydej    := Val(aline[7])
              case Val(aline[8]) = 2
                banvypi_im ->nprijem   := Val(aline[7])
              endcase

              cx                      := SubStr( cBuffer, 47,1)
              banvypi_im->ntypObratu  := if( Val(aline[8]) = 1, 2, 1)

              cx                      := SubStr( cBuffer, 128,10)
              banvypi_im ->cvarsym    := StrTran( aline[13],'"', '')
              banvypi_im ->cvarSymBan := padL( AllTrim(banvypi_im ->cvarsym), 15, '0' )
//              banvypi_im ->cvarSymBan := padL( aline[13], 15, '0' )
              banvypi_im ->dDatUhrady := CtoD(SubStr( aline[6], 1,2) +'.' +  ;
                                              SubStr( aline[6], 4,2) +'.' +  ;
                                              SubStr( aline[6], 6,4))

              if istuz
                banvypi_im ->nCenZakCel := if( empty(banvypi_im ->nprijem), ;
                                                     banvypi_im ->nvydej  , ;
                                                     banvypi_im ->nprijem   )
                banvypi_im ->nUhrCelFak := banvypi_im ->nCenZakCel
                banvypi_im ->nLikPolBAv := banvypi_im ->nCenZakCel
              else
                banvypi_im ->nCenZahCel := if( empty(banvypi_im ->nprijem), ;
                                                     banvypi_im ->nvydej  , ;
                                                     banvypi_im ->nprijem   )
                banvypi_im ->nUhrCelFaz := banvypi_im ->nCenZakCel
              endif

              banvypi_im ->ctext        := aline[15]
            endif

          otherwise
            cBuffer  := alines[i] +FReadStr(nHandle,1024)
            alines := mh_token( cBuffer, CRLF)
            read_ok := .f.
          endcase
        endif
      next
      if read_ok
        cBuffer  := FReadStr(nHandle,1024)
        alines := mh_token( cBuffer, CRLF)
      endif
    enddo

    banvypi_im ->(dbCommit())

    FClose( nHandle)
  next

  *
  ** smažeme naètené soubory
  AEval( afiles, { |a| FErase(cpath_kom +a[F_NAME]) } )
return(NIL)





static Function Bank_KOD(cBANK_uct)            //__kód banky pøíjemce_________
  Local  nPOs
  Local  cKODB := '0000'

  If( nPOs := RAT( '/', cBANK_uct)) <> 0
    cKODB := ALLTRIM( SUBSTR( cBANK_UCT, nPOs +1))
  EndIf
return( cKODB)


static Function Bank_UCET(cBANK_UCT)            //__úprava èísla úètu__________
  Local  nPOs
  Local  cUCET := ALLTRIM( cBANK_UCT), cKODB, cUCETn
  Local  cZAKLuct, cPREDuct
  local  aUcet[2]

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
  aUcet[1] := cPREDuct
  aUcet[2] := cZAKLuct

Return( aUcet )


Function MTCsekce( sekce,odstr,buffer)
  local zacatek, konec
  local asekce := {':20:',':21:',':25:',':28C:',':60F:',':60M:',':61:',':86:',':62F:',':62M:',':64:',':65:','-}' }
  local aret := {'', 0}

  if sekce == ':86:'
    start := 7
  else
    start := aScan( asekce,{|x| x == sekce }) +1
  endif

  for n := start to len( asekce)
    if (konec := At( asekce[n],buffer,odstr)) > 0
      exit
    endif
  next

  if konec > 0
    aret[1] := SubStr( buffer, odstr+Len(sekce), konec - odstr-4 )
    aret[2] := konec
  endif

Return( aret)