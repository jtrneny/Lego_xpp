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

#include "..\A_main\WinApi_.ch"

#include "activex.ch"
#include "excel.ch"

#include "XbZ_Zip.ch"


#DEFINE  DBGETVAL(c)     Eval( &("{||" + c + "}"))

#pragma Library( "ASINet10.lib" )

STATIC  sName, sNameExt


static function fVAR( xVAR)     ;  return( Chr(34)+ xVAR +Chr(34))

//static function fVAR( xVAR)     ;  return( xVAR)

static function DElspace( cX )  ;  return( AllTrim( StrTran( cX," ","")))

static function DTOCuni( dDATE)
  LOCAL  cRET := ""

  IF !Empty(dDATE)
    cRET := StrZero( Year( dDATE), 4) +"-" +StrZero( Month( dDATE), 2) +"-"  ;
             +StrZero( Day( dDATE), 2)
  ENDIF
RETURN(cRET)

static function LAT_UTF8( cVAL)
   LOCAL cRET, cZNAK, j, n

   cret := cval
return(cret)

/*
static function LAT_UTF8( cVAL)
   LOCAL cRET, cZNAK, j, n
   LOCAL aCHAR := { { "Ø", "Ä›", .F.}, { "ç", "Å¡", .F.}, { "Ÿ", "Ä", .F.}, ;
                    { "ý", "Å™", .F.}, { "§", "Å¾", .F.}, { "œ", "Å¥", .F.}, ;
                    { "Ô", "Ä", .F.}, { "å", "Åˆ", .F.}, { "ì", "Ã½", .F.}, ;
                    { " ", "Ã¡", .F.}, { "¡", "Ã­", .F.}, { "‚", "Ã©", .F.}, ;
                    { "¢", "Ã³", .F.}, { "£", "Ãº", .F.}, { "…", "Å¯", .F.}, ;
                    { "·", "Äš", .F.}, { "æ", "Å ", .F.}, { "¬", "ÄŒ", .F.}, ;
                    { "ü", "Å˜", .F.}, { "¦", "Å½", .F.}, { "›", "Å¤", .F.}, ;
                    { "Ò", "ÄŽ", .F.}, { "Õ", "Å‡", .F.}, { "í", "Ã", .F.}, ;
                    { "µ", "Ã", .F.}, { "Ö", "Ã", .F.}, { "", "Ã‰", .F.}, ;
                    { "à", "Ã“", .F.}, { "é", "Ãš", .F.}, { "Ó", "Ã‹", .F.}, ;
                    { "™", "Ã–", .F.}, { "š", "Ãœ", .F.}, { "„", "Ã¤", .F.}, ;
                    { "‰", "Ã«", .F.}, { "”", "Ã¶", .F.}, { "•", "Ä½", .F.}, ;
                    { "–", "Ä¾", .F.}, { "Þ", "Å®", .F.}, { "", "Ã¼", .F.} }

  cRET := ""
  FOR n := 1 TO Len( cVAL)
    cZNAK := SubStr( cVAL, n, 1)
    j     := aSCAN( aCHAR, { |X| X[1] == cZnak})
    cRET  := cRET +IF( j > 0, aCHAR[j,2], cZNAK)
  NEXT
RETURN( cRET)
*/


// Export do Èeské spoøitelny - nový formát -NFO- ÈS - do txt formátu
function DIST000069( oxbp ) // oxbp = drgDialog
  local tm
  local cx, ddate, cext
  local cSberUcCS
  local crokzprac,cdatum,nporfile
  local nKodObrDal,nKodObrMd
  local aRadek    := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  local aSuma     := {}
  local aSumaTr
  local x1 := 0
  local x2 := 0
  local in_Dir

  crokzprac := Str( if( mzdzavhd->nobdobi=12,mzdzavhd->nrok+1,mzdzavhd->nrok),4)
  cDatum    := DtoC( Date() )
  aSumaTr   := { { 11, 0, 0 },{ 32, 0, 0 } }
  cSberUcCS := Padl( AllTrim( Str( SysConfig( "Mzdy:nSberUcCS"))), 10, "0")
  cDatum    := Substr( cDatum, 9, 2) + Substr( cDatum, 4, 2)  +  Substr( cDatum, 1, 2)
  nporfile  := 284

  cext := Right( cSberUcCS, 2) + 'A'
  cX   := Left( cSberUcCS, 8)  //+ "." + cext
  tm   := "*." + cext
  * výstupní soubor
  in_Dir := retDir(odata_datKom:PathExport)
  file := selFILE( cX,cext,in_Dir,'Výbìr souboru pro export',{{cext+ " - soubory", tm}})
//  file := selFILE( cX,'Txt',,'Výbìr souboru pro export',{{"TXT soubory", "*.TXT"}})
//    afile_e := { {'procenho_e','procenhow'} }
  recNo   := mzdzavhd->(recNo())

  drgDBMS:open( 'mzdzavit',,,,, 'mzdzavita' )
//    drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP

  filtr     := format( "ndoklad = %%", { mzdzavhd->ndoklad})
  mzdzavita->( ads_setAof(filtr),dbgoTop())

  if .not. Empty(file)
    nHandle := FCreate( file )

    nKodObrDal := SysConfig( "Mzdy:nKodObrDCS")
    nKodObrMd  := SysConfig( "Mzdy:nKodObrMCS")

    cx := "UZ:" + "N" + Padl( Alltrim( Str(SysConfig( "Mzdy:nPredCisCS"))), 6, "0" ) +  ;
               cSberUcCS + Padl( Alltrim( Str(nPorFile)), 4, "0" ) +    ;
                cDatum + Right( Alltrim( cRokZprac),2) +                ;
                 Substr(cDatum, 3, 2 ) +                                ;
                  Padl( Alltrim( Str( SysConfig( "Mzdy:nCisPodCS"))), 5, "0" ) +   ;
                   Padl( Alltrim( Str( nKodObrDal)), 2, "0") +          ;
                    Padl( Alltrim( Str( nKodObrMd)), 2, "0")  +CRLF
    FWrite( nHandle, cx)
//                  Padl( Alltrim( Str( SysConfig( "Mzdy:nCisPodCS"))), 5, "0" ) +          ;

    cx := "NP:" + ConvToOemCP( Substr( Alltrim( SysConfig( "System:cPodnik")), 1, 20))  +CRLF
    FWrite( nHandle, cx)

     mzdzavita->( dbGoTop())
      do while .not. mzdzavita->(Eof())
        cx :=  AllTrim(mzdzavita->cdoplntxt) +CRLF
        FWrite( nHandle, cx)

        cx := 'TE:MZDA061795' + Padr( Left(AllTrim(ConvToOemCP( mzdzavita->cnazzbo)),7),7) +CRLF
        FWrite( nHandle, cx)

        If ( n := ascan( aSuma, { |x| x[ 1] = Val(SubStr(mzdzavita->ctmSort,1,5)) .and. ;
                                       x[ 2] = Val(SubStr(mzdzavita->ctmSort,8,3))  .and. ;
                                         x[ 3] = Val(SubStr(mzdzavita->ctmSort,13,2)) } ) ) = 0
          ax := aClone( aRadek )
          aadd( aSuma, ax )

          nPos := Len( aSuma )
          aSuma[nPos, 1] := Val(SubStr(mzdzavita->ctmSort,1,5))
          aSuma[nPos, 2] := Val(SubStr(mzdzavita->ctmSort,8,3))
          aSuma[nPos, 3] := Val(SubStr(mzdzavita->ctmSort,13,2))
        Else
          nPos := n
        EndIf

        Do Case
        Case Val(SubStr(mzdzavita->ctmSort,15,1)) = 1
          x1 := 4
          x2 := 5
        Case Val(SubStr(mzdzavita->ctmSort,15,1)) = 2
          x1 := 6
          x2 := 7
        Case Val(SubStr(mzdzavita->ctmSort,15,1)) = 3
          x1 := 8
          x2 := 9
        EndCase

        aSuma[ nPos, x1 ] := aSuma[ nPos, x1 ] + 1
        aSuma[ nPos, x2 ] := aSuma[ nPos, x2 ] + mzdzavita->nCenZahCel
        aSuma[ nPos, 10 ] := aSuma[ nPos, 10 ] + 1
        aSuma[ nPos, 11 ] := aSuma[ nPos, 11 ] + mzdzavita->nCenZahCel

        mzdzavita->( dbSkip())
      enddo

      For nPos = 1 to Len( aSuma)
        do case
        case aSuma[nPos, 3] == 11
          aSumaTr [ 1, 2 ] := aSumaTr[ 1, 2 ] + aSuma[nPos,10]
          aSumaTr [ 1, 3 ] := aSumaTr[ 1, 3 ] + aSuma[nPos,11]
        case aSuma[nPos, 3] == 32
          aSumaTr [ 2, 2 ] := aSumaTr[ 2, 2 ] + aSuma[nPos,10]
          aSumaTr [ 2, 3 ] := aSumaTr[ 2, 3 ] + aSuma[nPos,11]
        endcase
      Next

      cx := 'KZ:' + Padl( Alltrim( Str( aSumaTr[ 1, 2 ], 5 ) ), 7, '0' ) +           ;
                     Padl( Alltrim( Str( aSumaTr[ 1, 3 ] * 100, 9 ) ), 15, '0' ) +   ;
                      Padl( Alltrim( Str( aSumaTr[ 2, 2 ], 5 ) ), 7, '0' ) +         ;
                       Padl( Alltrim( Str( aSumaTr[ 2, 3 ] * 100, 9) ), 15, '0' ) +CRLF
      FWrite( nHandle, cx)

      mzdzavita->(ads_clearAof())

//      FWrite( nHandle, Chr( 26), 1)
      FClose( nHandle)

//      cPATHold := CurDrive() + ':\'+CurDir( CurDrive())
//      cexe     := cPATHelco +"\TxtAlpha.exe"
//      cline    := " 3 " +AllTrim( Str( nCOM, 1))

//      CurDir( cPATHelco)
//      RunShell( cline, cexe, .T. )
//      CurDir( cPATHold)


//          clsFileCom( afile_e)

    * picnem to ven
//    zipCom( afile_e, 'DIST000010_'+AllTrim(Str(usrIdDB)))

    endif

//            delFileCom( afile_e)
    drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)

return( nil)


// Export na penzijní pojišovnu - KB - do txt formátu
function DIST000070( oxbp ) // oxbp = drgDialog
  local inDir
  local file
  local cx, recNo

  drgDBMS:open( 'firmy',,,,,'firmyp')

  firmyp ->( dbSeek( mzdzavhd->ncisfirmy,,'FIRMY1'))

  cX := "K" +AllTrim(Left( firmyp->cIdKoduPoj, 5)) +"1"+ Right( StrZero( Month( Date()), 2), 1)

  * exportní soubor pro penzijní pojišovnu
  inDir := retDir(odata_datKom:PathExport)
  file  := inDir + cX + '.txt'
  file := selFILE( cX,'txt',inDir,'Výbìr souboru pro export',{{"TXT soubory", "*.txt"}})
  recNo := mzdzavhd->(recNo())

  if( .not. Empty(file), GenHroPlPF( file), nil)

return( nil)


// Export na hlášení o zmìnách na ÈSSZ - formát XML  - ONZ
function DIST000071( oxbp ) // oxbp = drgDialog
  local tm
  local cx
  local nit
  local file
  local in_Dir

//  drgDBMS:open( 'mzdzavit',,,,, 'mzdzavita' )
//    drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP

    nIT := 1

  do case
  case !Empty( SysConfig( "System:cZkrNazPod"))
    cX := AllTrim( SysConfig( "System:cZkrNazPod"))
  case !Empty( SysConfig( "System:nICO"))
    cX := AllTrim( StrZero( SysConfig( "System:nICO" ), 8))
  otherwise
    cX := "REGCSSZ"
  endcase

//  cX := "R_" +SubStr( cX, 1, 6)
  cX := "ONZ2009_1"

  cDATE := StrZero( Day( Date()), 2) +StrZero( Month( Date()), 2)      ;
                 +StrZero( Val( SubStr( Str(Year( Date())),3,2)), 2)
//    cOutFILE_1 := cTmpPath + cX +".xml"
  * výstupní soubor
  in_Dir := retDir(odata_datKom:PathExport)
  file := selFILE( cX,'Xml',in_Dir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})


  if .not. Empty(file)
//    do while .not.

    nHandle := FCreate( file )
    cX  := "<?xml version=" +Chr(34) +"1.0" +Chr(34) +" encoding=" ;
              + Chr(34)+ "windows-1250" +Chr(34) + "?>"
//              + Chr(34)+ "UTF-8" +Chr(34) + "?>"
    FWrite(nHandle, cX +CRLF)

    cX  := "<ONZ version="+Chr(34)+"2009.1"+Chr(34)+" xmlns="+ Chr(34)+"http://schemas.cssz.cz/ONZ2009" +Chr(34) + ">"
    FWrite(nHandle, cX +CRLF)

    cX := "   <employee sqnr="+fVAR( AllTrim(Str( nIT)))                    ;
                      + " dep=" +fVAR( AllTrim( Str( tmhlassow ->nKodOkrSoc,3,0)))        ;
                      + " act=" +fVAR( AllTrim( Str( tmhlassow ->nTypAkce)))         ;
                      + " fro=" +fVAR( DTOCuni( tmhlassow ->dPlatAkce))    ;
                      + " dat=" +fVAR( DTOCuni( tmhlassow ->dDatZprac))     ;
                      + " ver=" +fVAR( AllTrim(Str( 2)))                    ;
                      + ">"
    FWrite(nHandle, cX +CRLF)

    cX := "       <client bno=" +fVAR( DELspace( StrTran( StrTran( tmhlassow ->cRodCisPra,'-',''),'/','')))   ;
                      + ">"
    FWrite(nHandle, cX +CRLF)

    cX := "           <name sur=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cPrijOsob)))  ;
                           +" ona=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cPrijDalsi))) ;
                           +" fir=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cJmenoOsob))) ;
                           +" tit=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cTitul))) ;
                           + "/>"
    FWrite(nHandle, cX +CRLF)
    cX := "           <birth dat=" +fVAR( DTOCuni( tmhlassow ->dDatNaroz)) ;
                           +" nam=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cJmenoRod))) ;
                           +" cit=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cMistoNar))) ;
                           + "/>"
    FWrite(nHandle, cX +CRLF)
    cX := "           <stat mal=" +fVAR( AllTrim( LAT_UTF8( Str(tmhlassow ->nPohlavi,1,0))))    ;
                           +" cnt=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cZkrStatPr)))  ;     // státní pøíslušnost
                           + "/>"
    FWrite(nHandle, cX +CRLF)
    cX := "           <adr str=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cUlice)))    ;
                          +" num=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cCisPopis))) ;
                          +" pnu=" +fVAR( DELspace( tmhlassow ->cPSC))       ;
                          +" cit=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cMisto)))    ;
                          +" cnt=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cZkratStat)))    ;
                          +" pos=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cPosta)))    ;    // pošta
                          + "/>"
    FWrite(nHandle, cX +CRLF)
    cX := "             <fdr cit=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cMistoC)))    ;
                          +" str=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cUliceC)))    ;
                          +" num=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cCisPopisC))) ;
                          +" pnu=" +fVAR( DELspace( tmhlassow ->cPscC))       ;
                          + "/>"
    FWrite(nHandle, cX +CRLF)
    cX := "           <cdr str=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cUliceK)))    ;
                          +" num=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cCisPopisK))) ;
                          +" pnu=" +fVAR( DELspace( tmhlassow ->cPscK))       ;
                          +" cit=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cMistoK)))    ;
                          +" cnt=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cZkratStaK)))    ;
                          +" pos=" +fVAR( AllTrim( LAT_UTF8( tmhlassow ->cPostaK)))    ;
                          + "/>"
    FWrite(nHandle, cX +CRLF)

    cX := "       </client>"
    FWrite(nHandle, cX +CRLF)

    cX := "       <comp vs="  +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cVarSymSoc))) ;
                                +" nvs=" +fVAR( Alltrim( LAT_UTF8(""))) ;                  // nový VS
                                +" id="  +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cIco))) ;
                                +" nam=" +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cNazevZame))) ;
                                                           +"/>"
    FWrite(nHandle, cX +CRLF)

    cX := "       <job fro="  +fVAR( DTOCuni( tmhlassow ->dDatNast))           ;
                                +" to="  +fVAR( DTOCuni( tmhlassow ->dDatVyst))           ;
                                +" rel=" +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cTypPPVReg))) ;
                                +" per=" +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cZkratStaV))) ;
                                +" sme=" +fVAR( Alltrim( LAT_UTF8( if(tmhlassow ->lZamMalRoz,'A','N')))) ;
                                +"/>"
    FWrite(nHandle, cX +CRLF)

    cX := "       <forin nam=" +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cNazevCizo)))   ;
                                 +" str=" +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cUliceZ))) ;
                                 +" num=" +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cCisPopisZ))) ;
                                 +" pnu=" +fVAR( DELspace(  tmhlassow ->cPscZ))            ;
                                 +" cit=" +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cMistoZ))) ;
                                 +" cnt=" +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cZkratStaZ))) ;
                                 +" id="  +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cCisloCizo))) ;
                                 +" cur=" +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cSpeciCizo))) ;
                                 +"/>"
    FWrite(nHandle, cX +CRLF)

    cX := "       <pens typ="  +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cTypDucReg))) ;
                                 +" tak="  +fVAR( DTOCuni( tmhlassow ->dDuchodOd))  ;
                                 +"/>"
    FWrite(nHandle, cX +CRLF)

    cX := "       <insh cnr="  +fVAR( Str( tmhlassow ->nZdrPojis,3,0)) ;
                                 +"/>"
    FWrite(nHandle, cX +CRLF)

    cX := "       <inso nam="  +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cNazOrgSou))) ;
                                 +"/>"
    FWrite(nHandle, cX +CRLF)

    cX := "       <insp nam="  +fVAR( Alltrim( LAT_UTF8( tmhlassow ->cNazOrgPre))) ;
                                 +"/>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </employee>"
    FWrite(nHandle, cX +CRLF)

/*
                        IF ReplREC( cRYOFILE)
                                ( cRYOFILE) ->dOdeRegSSZ := Date()
                    ( cRYOFILE) ->cCasOdRSSZ := Time()
                                ( cRYOFILE) ->mOdeRegSSZ += SysConfig( "System:cUserABB") + " "    ;
                                                             + DtoC( ( cRYOFILE) ->dOdeRegSSZ) + " " ;
                                                               + ( cRYOFILE) ->cCasOdRSSZ  + ", "
                                IF cRYOFILE == "RegSSZIt"
                                  IF RegSSZHd ->( dbSeek( StrZero( RegSSZIt ->nOsCisPrac)            ;
                                                                 + StrZero( RegSSZIt ->nOsCisPrac)))       ;
                                      .AND. ReplREC("RegSSZHd")
                                    RegSSZHd ->dOdeRegSSZ := Date()
                                    RegSSZHd ->cCasOdRSSZ := Time()
                                    RegSSZHd ->mOdeRegSSZ += SysConfig( "System:cUserABB") + " "    ;
                                                               + DtoC( RegSSZHd ->dOdeRegSSZ) + " " ;
                                                                + RegSSZHd ->cCasOdRSSZ  + ", "
                                          RegSSZHd ->( Sx_Unlock())
                                  ENDIF
                           ENDIF
                        ENDIF
*/
                        nIT++
//      tmhlassow ->( dbSkip())
//    ENDDO

    cX  := "</ONZ>"
    FWrite(nHandle, cX +CRLF)
//    TMp_OMETRa()

    FClose( nHandle)

//      cPATHold := CurDrive() + ':\'+CurDir( CurDrive())
//      cexe     := cPATHelco +"\TxtAlpha.exe"
//      cline    := " 3 " +AllTrim( Str( nCOM, 1))

//      CurDir( cPATHelco)
//      RunShell( cline, cexe, .T. )
//      CurDir( cPATHold)



//      clsFileCom( afile_e)

    * picnem to ven
//    zipCom( afile_e, 'DIST000010_'+AllTrim(Str(usrIdDB)))

    endif

//    delFileCom( afile_e)
    drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)


return( nil)



// Export pøehled o výši pojistné.2015 na ÈSSZ v XML - PVPOJ
function DIST000072( oxbp ) // oxbp = drgDialog
  local tm
  local cx
  local nit
  local file
  local in_Dir

//  drgDBMS:open( 'mzdzavit',,,,, 'mzdzavita' )
//    drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP

  nIT := 1

  do case
  case !Empty( SysConfig( "System:cZkrNazPod"))
    cX := AllTrim( SysConfig( "System:cZkrNazPod"))
  case !Empty( SysConfig( "System:nICO"))
    cX := AllTrim( StrZero( SysConfig( "System:nICO" ), 8))
  otherwise
    cX := "REGCSSZ"
  endcase

  cX := "PVPOJ2015" +SubStr( cX, 1, 6)

  cDATE := StrZero( Day( Date()), 2) +StrZero( Month( Date()), 2)      ;
                 +StrZero( Val( SubStr( Str(Year( Date())),3,2)), 2)
//    cOutFILE_1 := cTmpPath + cX +".xml"
  * výstupní soubor
  in_Dir := retDir(odata_datKom:PathExport)
  file := selFILE( cX,'Xml',in_Dir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})


  if .not. Empty(file)
//    do while .not.

    nHandle := FCreate( file )
    cX  := "<?xml version=" +Chr(34) +"1.0" +Chr(34) +" encoding=" ;
              + Chr(34)+ "windows-1250" +Chr(34) + "?>"
//              + Chr(34)+ "UTF-8" +Chr(34) + "?>"
    FWrite(nHandle, cX +CRLF)

    cX  := "<pvpoj xmlns="+ Chr(34)+"http://schemas.cssz.cz/POJ/PVPOJ2015" +Chr(34) + ">"
    FWrite(nHandle, cX +CRLF)

    cX := "   <prehled typPrehledu="+fVAR(AllTrim(LAT_UTF8("N")))+" verze=" + Chr(34)+ "2015.0" + Chr(34)+ ">"
    FWrite(nHandle, cX +CRLF)

    cX := "   <okres>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <kodOSSZ>"+AllTrim(Str(tmprposow->nKodOkrSoc,3,0))+"</kodOSSZ>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <nazevOSSZ>"+AllTrim( LAT_UTF8(tmprposow->cNazMisSoc))+"</nazevOSSZ>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </okres>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <obdobi>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <mesic>"+AllTrim( StrZero(tmprposow->nobdobi,2))+"</mesic>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <rok>"+AllTrim( StrZero(tmprposow->nrok,4))+"</rok>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </obdobi>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <zamestnavatel>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <vs>"+AllTrim( LAT_UTF8(tmprposow->cVarSymSoc))+"</vs>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <IC>"+AllTrim( LAT_UTF8(tmprposow->cIco))+"</IC>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <nazev>"+AllTrim( LAT_UTF8(tmprposow->cNazevZame))+"</nazev>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <adresa>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <ulice>"+AllTrim( LAT_UTF8(tmprposow->cUlice))+"</ulice>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <cisloDomu>"+AllTrim( LAT_UTF8(tmprposow->cCisPopis))+"</cisloDomu>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <obec>"+AllTrim( LAT_UTF8(tmprposow->cMisto))+"</obec>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <PSC>"+AllTrim( LAT_UTF8(tmprposow->cPsc))+"</PSC>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <stat>"+AllTrim( LAT_UTF8(tmprposow->cZkratStat))+"</stat>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </adresa>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </zamestnavatel>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <pojistne>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <uhrnVymerovacichZakladuPbezDS>"+AllTrim(Str(tmprposow->nVymZaklZa,13,0))+"</uhrnVymerovacichZakladuPbezDS>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <uhrnPojistnehoPbezDS>"+AllTrim(Str(tmprposow->nUhrnPojZa,13,0))+"</uhrnPojistnehoPbezDS>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <uhrnVymerovacichZakladuPsDS>"+AllTrim(Str(tmprposow->nVymZaklDS,13,0))+"</uhrnVymerovacichZakladuPsDS>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <uhrnPojistnehoPsDS>"+AllTrim(Str(tmprposow->nUhrnPojDS,13,0))+"</uhrnPojistnehoPsDS>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <uhrnVymerovacichZakladu>"+AllTrim(Str(tmprposow->nVymZakl,13,0))+"</uhrnVymerovacichZakladu>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <uhrnPojistneho>"+AllTrim(Str(tmprposow->nUhrnPoj,13,0))+"</uhrnPojistneho>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <pojistneCelkem>"+AllTrim(Str(tmprposow->nPojistne,13,0))+"</pojistneCelkem>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </pojistne>"
    FWrite(nHandle, cX +CRLF)


    cX := "   <platebniUdaje>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <bankaCisloUctu>"+AllTrim( LAT_UTF8(tmprposow->cUcet))+"</bankaCisloUctu>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </platebniUdaje>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <pracovnik>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <jmeno>"+AllTrim( LAT_UTF8(tmprposow->cJmenoOsob))+"</jmeno>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <prijmeni>"+AllTrim( LAT_UTF8(tmprposow->cPrijOsob))+"</prijmeni>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <telefon>"+AllTrim( LAT_UTF8(tmprposow->cTelefon))+"</telefon>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <email>"+AllTrim( LAT_UTF8(tmprposow->cEmail))+"</email>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </pracovnik>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <datumVyplneni>"+DTOCuni( tmprposow->dDatZprac)+"</datumVyplneni>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <poznamka>"+LAT_UTF8(tmprposow->mpoznamka)+"</poznamka>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </prehled>"
    FWrite(nHandle, cX +CRLF)

    cX := "</pvpoj>"
    FWrite(nHandle, cX +CRLF)

//    TMp_OMETRa()

//    FWrite( nHandle, Chr( 26), 1)
    FClose( nHandle)

//      cPATHold := CurDrive() + ':\'+CurDir( CurDrive())
//      cexe     := cPATHelco +"\TxtAlpha.exe"
//      cline    := " 3 " +AllTrim( Str( nCOM, 1))

//      CurDir( cPATHelco)
//      RunShell( cline, cexe, .T. )
//      CurDir( cPATHold)



//      clsFileCom( afile_e)

    * picnem to ven
//    zipCom( afile_e, 'DIST000010_'+AllTrim(Str(usrIdDB)))

    endif

//    delFileCom( afile_e)
    drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)


return( nil)


// Export pøílohy k žádosti o nem.dávku na ÈSSZ v XML - NEMPRI
//  zmìna 15.03.2018  - NEMPRI18
function DIST000073( oxbp ) // oxbp = drgDialog
  local tm
  local cx
  local n
  local nit
  local file
  local nBeg, nEnd
  local in_Dir

//  drgDBMS:open( 'mzdzavit',,,,, 'mzdzavita' )
//    drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP

    nIT := 1

  do case
  case !Empty( SysConfig( "System:cZkrNazPod"))
    cX := AllTrim( SysConfig( "System:cZkrNazPod"))
  case !Empty( SysConfig( "System:nICO"))
    cX := AllTrim( StrZero( SysConfig( "System:nICO" ), 8))
  otherwise
    cX := "REGCSSZ"
  endcase

//  cX := "R_" +SubStr( cX, 1, 6)
  cX := "NEMPRI_2018"

  cDATE := StrZero( Day( Date()), 2) +StrZero( Month( Date()), 2)      ;
                 +StrZero( Val( SubStr( Str(Year( Date())),3,2)), 2)
//    cOutFILE_1 := cTmpPath + cX +".xml"
  * výstupní soubor
  in_Dir := retDir(odata_datKom:PathExport)
  file := selFILE( cX,'Xml',in_Dir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})


  if .not. Empty(file)
//    do while .not.

    nHandle := FCreate( file )

    cX  := "<?xml version=" +Chr(34) +"1.0" +Chr(34) +" encoding=" ;
              + Chr(34)+ "windows-1250" +Chr(34) +" standalone="   ;
                +Chr(34) +"yes" +Chr(34) +"?>"
//              + Chr(34)+ "UTF-8" +Chr(34) + "?>"
    FWrite(nHandle, cX +CRLF)

    cX  := "<NEMPRI xmlns="+ Chr(34)+"http://schemas.cssz.cz/nem/NEMPRI18"  ;
              + Chr(34) + " version=" + Chr(34) + "2018.0"                  ;
               + Chr(34) + " partialAccept=" + Chr(34) +"A"+ Chr(34) + ">"
    FWrite(nHandle, cX +CRLF)

    cX  := "<VENDOR productName="+ Chr(34) +LAT_UTF8( "Asystem++")           ;
              + Chr(34) + " productVersion=" + Chr(34) + verzeAsys[3,2]     ;
               + Chr(34) + "></VENDOR>"
    FWrite(nHandle, cX +CRLF)

    cX  := "<SENDER EmailNotifikace="+ Chr(34)+ AllTrim(tmprinemw->cEmailNotif)      ;
              + Chr(34) + " ISDSreport=" + Chr(34) + "3" +Chr(34) + "></SENDER>"
    FWrite(nHandle, cX +CRLF)


    cX := "  <datovaVeta poradoveCislo=" + Chr(34)+ AllTrim(Str( nIT,4,0)) + Chr(34) + ">"
    FWrite(nHandle, cX +CRLF)

    cX := "   <dokument>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <zahranicni>"  +AllTrim( LAT_UTF8( if( tmprinemw->lZahranicn, 'A','N')))             ;  // N
                +"</zahranicni>"
    FWrite(nHandle, cX +CRLF)

//    tm := if( .not. Empty( tmprinemw->cCisRozNem), tmprinemw->cCisRozNem, tmprinemw->cCisRozOcr)
    tm := '' // if( .not. Empty( tmprinemw->cCisRozNem), tmprinemw->cCisRozNem, tmprinemw->cCisRozOcr)

    do case
    case .not. Empty( tmprinemw->cCisRozNem)   ;   tm := tmprinemw->cCisRozNem
    case .not. Empty( tmprinemw->cCisRozOcr)   ;   tm := tmprinemw->cCisRozOcr
    case .not. Empty( tmprinemw->cCisRozDlP)   ;   tm := tmprinemw->cCisRozDlP
    endcase

    cX := "     <cisloPotvrzeni>"  + AllTrim( LAT_UTF8( tm))     ;     //B1820786
                + "</cisloPotvrzeni>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <poznamka>"   +AllTrim( LAT_UTF8( tmprinemw->mpoznamka))     ;        // Pøíklad typu "Nemocenské" - fiktivní
                + "</poznamka>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <kodOSSZ>"   +AllTrim( Str( tmprinemw->nKodOkrSoc,3,0))    ;     //772
                +"</kodOSSZ>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <nazevOSSZ>" +AllTrim( LAT_UTF8( tmprinemw->cNazMisSoc))    ;     // Brno
                +"</nazevOSSZ>"
    FWrite(nHandle, cX +CRLF)

    do case
    case .not. Empty( tmprinemw->cCisRozNem)  ;     tm := 'NEM'
    case .not. Empty( tmprinemw->cCisRozOcr)  ;     tm := 'OCR'
    case .not. Empty( tmprinemw->cCisRozDlP)  ;     tm := 'DLO'
    case tmprinemw->lPenPomMat                ;     tm := 'PPM'
    case tmprinemw->lVyrPriTeh                ;     tm := 'VPM'
    case tmprinemw->lOtcovska                 ;     tm := 'DLO'
    endcase

    cX := "     <druhDavky>" +AllTrim( LAT_UTF8( tm))     ;     //NEM
                +"</druhDavky>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </dokument>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <pojistenec>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <jmeno>" +AllTrim( LAT_UTF8( tmprinemw->cJmenoOsob))       ;    // Boleslav
                +"</jmeno>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <prijmeni>" +AllTrim( LAT_UTF8( tmprinemw->cPrijOsob))    ;    //  Prvni
                +"</prijmeni>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <rodneCislo>" +AllTrim( LAT_UTF8( tmprinemw->cRodCisPrN))    ;  // 7403231847
                +"</rodneCislo>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </pojistenec>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <zamestnani>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <VSZamestnavatel>" +AllTrim( LAT_UTF8( tmprinemw->cVarSymSoc))    ;  //   9890108577
                +"</VSZamestnavatel>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <ICZamestnavatel>" +AllTrim( LAT_UTF8( tmprinemw->cIco ))    ;  //  41031709
                +"</ICZamestnavatel>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <nazevZamestnavatel>" +AllTrim( LAT_UTF8( tmprinemw->cNazevZame))    ;  //  Spolehlivýpodnik
                +"</nazevZamestnavatel>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <zamestnanOd>" +DTOCuni( tmprinemw->dDatNast)    ;  //   2001-09-03
                +"</zamestnanOd>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <zamestnanDo>" +DTOCuni( tmprinemw->dDatVyst)    ;  //
                +"</zamestnanDo>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <druhCinnosti>" +AllTrim( LAT_UTF8( tmprinemw->cTypPPVReg))    ;  // 1
                +"</druhCinnosti>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </zamestnani>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <rozhodneObdobi>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <rozhodneObdobiOd>" +DTOCuni( tmprinemw->dRozhObdOd)    ;   //  2009-06-01
                +"</rozhodneObdobiOd>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <rozhodneObdobiDo>" +DTOCuni( tmprinemw->dRozhObdDo)   ;   //  2010-05-31
                 +"</rozhodneObdobiDo>"
    FWrite(nHandle, cX +CRLF)

    if Year( tmprinemw->dRozhObdOd) < Year( tmprinemw->dRozhObdDo)
      nEnd := 12 - Month(tmprinemw->dRozhObdOd) + 1
      nEnd := nEnd + Month( tmprinemw->dRozhObdDo)
    else
      nEnd := Month( tmprinemw->dRozhObdDo) - Month( tmprinemw->dRozhObdOd) +1
    endif

    if nEnd = 1 .and. tmprinemw->nZapPrij01 = 0 .and. tmprinemw->nVylDoba01 = 0

    else
      cX := "     <polozky>"
      FWrite(nHandle, cX +CRLF)

  ///   zde musí být cyklus
      for m := 1 to nEnd
        cKalMeRo := 'cKalMeRo' +StrZero( m,2)
        nZapPrij := 'nZapPrij' +StrZero( m,2)
        nVylDoba := 'nVylDoba' +StrZero( m,2)


        cX := "       <polozka>"
        FWrite(nHandle, cX +CRLF)
        cX := "         <kalendarniMesic>" +AllTrim( LAT_UTF8( Str(Val(Left(tmprinemw->&cKalMeRo,2)))))    ;   //  6
                        +"</kalendarniMesic>"
        FWrite(nHandle, cX +CRLF)
        cX := "         <kalendarniRok>" +AllTrim( LAT_UTF8( Str(Val(SubStr(tmprinemw->&cKalMeRo,4,4)))))    ;   // 2009
                        +"</kalendarniRok>"
        FWrite(nHandle, cX +CRLF)
        cX := "         <zapocitatelnyPrijem>"  +AllTrim( Str( tmprinemw->&nZapPrij,10,0))    ;   // 22357
                        +"</zapocitatelnyPrijem>"
        FWrite(nHandle, cX +CRLF)
  //      cX := "         <vylouceneDny>"  +if( Empty( tmprinemw->&nVylDoba),'', AllTrim( Str( tmprinemw->&nVylDoba,10,0)))       ;   // 0
        cX := "         <vylouceneDny>"  + AllTrim( Str( tmprinemw->&nVylDoba,10,0))       ;   // 0
                        +"</vylouceneDny>"
        FWrite(nHandle, cX +CRLF)
        cX := "       </polozka>"
        FWrite(nHandle, cX +CRLF)
      next

      cX := "     </polozky>"
      FWrite(nHandle, cX +CRLF)
    endif

    cX := "     <zapocitatelnyPrijemCelkem>"  +if( tmprinemw->nZapPrijCe = 0,'0', AllTrim( Str( tmprinemw->nZapPrijCe,10,0)) )       ;   //  285553
                +"</zapocitatelnyPrijemCelkem>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <vylouceneDnyCelkem>"  + if( tmprinemw->nVylDobaCe = 0,'0', AllTrim( Str( tmprinemw->nVylDobaCe,10,0)) )             ;   //0
                +"</vylouceneDnyCelkem>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <pravdepodobnaVysePrijmu>" + if( tmprinemw->nPravdPrij = 0,'', AllTrim( Str( tmprinemw->nPravdPrij,10,0)) )        ;
                +"</pravdepodobnaVysePrijmu>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </rozhodneObdobi>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <potvrzeniZamestnavatele>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <pocetOdpracovanychHodin>"  +if( tmprinemw->nOdpHodNem = 0,'', AllTrim( Str( tmprinemw->nOdpHodNem,5,2))  )        ;
                +"</pocetOdpracovanychHodin>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <pracovniDoba>"  +if( tmprinemw->nDelkSmDeN = 0,'', AllTrim( Str( tmprinemw->nDelkSmDeN,5,2)) )                  ;
                +"</pracovniDoba>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </potvrzeniZamestnavatele>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <prilohaStrana2>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <pracoval>"  +AllTrim( LAT_UTF8( if( tmprinemw->lPracNem, 'A','N')))             ;  // N
                +"</pracoval>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <prijemMalyRozsah>"  +if( tmprinemw->nZaMaRoPri = 0,'', AllTrim( Str( tmprinemw->nZaMaRoPri,10,0)) )                   ;  // 0
                +"</prijemMalyRozsah>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <pobiraDuchod>"  +AllTrim( LAT_UTF8( if( tmprinemw->lDuchod, 'A','N')))                    ;  // N
                +"</pobiraDuchod>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <druhDuchodu>"   +if( Empty( tmprinemw->cTypDucReg),'', AllTrim( LAT_UTF8( tmprinemw->cTypDucReg )) ) ;  //
                +"</druhDuchodu>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <jeStudentem>"   +AllTrim( LAT_UTF8( if( tmprinemw-> lStudent, 'A','N')))                    ;  //N
                +"</jeStudentem>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <spadaDoPrazdnin>" +AllTrim( LAT_UTF8( if( tmprinemw-> lObdPrazd, 'A','N')))                    ;  //N
                +"</spadaDoPrazdnin>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <dobaVolnaPrvniZamestnani>"  +AllTrim( LAT_UTF8( if( tmprinemw->lNemVDovol, 'A','N')))           ;  //NN
                +"</dobaVolnaPrvniZamestnani>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <volnoBezNahrady>"  +AllTrim( LAT_UTF8( if( tmprinemw->lNemBezPrij, 'A','N')))           ;  //NN
                +"</volnoBezNahrady>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <volnoBezNahradyOd>"   +if( Empty( tmprinemw->dPrVolNeOd),'', DTOCuni( tmprinemw->dPrVolNeOd)  )                ;  //
                + "</volnoBezNahradyOd>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <volnoBezNahradyDo>"  +if( Empty( tmprinemw->dPrVolNeDo),'', DTOCuni( tmprinemw->dPrVolNeDo)  )                ;  //
                +"</volnoBezNahradyDo>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <nastupujePPM>"   +AllTrim( LAT_UTF8( if( tmprinemw->lPenPoMat4R, 'A','N')))                       ;  // N
                +"</nastupujePPM>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <narozeniDitete>"   +if( Empty( tmprinemw->dNarPredDit),'', DTOCuni( tmprinemw->dNarPredDit)  )                  ;  //
                +"</narozeniDitete>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <neredukovanyDVZPPM>"   +if( tmprinemw->nRedVymZaPM = 0,'', AllTrim( Str( tmprinemw->nRedVymZaPM,10,0))  )                  ;  //
                +"</neredukovanyDVZPPM>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <prevedenaNaJinouPraci>"  +AllTrim( LAT_UTF8( if( tmprinemw->lPreJinZam, 'A','N')))                    ;  //
                +"</prevedenaNaJinouPraci>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <exekuce>"  +AllTrim( LAT_UTF8( if( tmprinemw->lZamExekuce, 'A','N')))                    ;  //
                +"</exekuce>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <insolvence>"  +AllTrim( LAT_UTF8( if( tmprinemw->lZamInsolve, 'A','N')))                    ;  //
                +"</insolvence>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <dalsiSdeleni>"   +if( Empty( tmprinemw->mPoznamka),'', AllTrim( LAT_UTF8( tmprinemw->mPoznamka))  )                  ;  //
                +"</dalsiSdeleni>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <kontaktniPracovnik>"   +AllTrim( LAT_UTF8( tmprinemw->cOsoba))                    ;  //První Boleslav
                +"</kontaktniPracovnik>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <kontaktniTelefon>"   +AllTrim( LAT_UTF8( StrTran( tmprinemw->cTelefon,' ', '')))                    ;  //
                +" </kontaktniTelefon>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <kontaktniEmail>"   +AllTrim( LAT_UTF8( StrTran( tmprinemw->cEmail,' ', '')))                    ;  //
                +" </kontaktniEmail>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <podanoV>" +AllTrim( LAT_UTF8( tmprinemw->cMisto))                    ;  //Praha
                +"</podanoV>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <prilohy coun=" +Chr(34) +if( tmprinemw->nPocPriloh = 0,'0', AllTrim( Str( tmprinemw->nPocPriloh,2,0)))        ;
                    +Chr(34) +">"
       FWrite(nHandle, cX +CRLF)

    if tmprinemw->nPocPriloh > 0
      for n := 1 to tmprinemw->nPocPriloh
        cX := "     <priloha nazev=" + +Chr(34)+ "" +Chr(34)
        FWrite(nHandle, cX +CRLF)
        cX := "     typ=" + Chr(34)+ ";;" +Chr(34)
        FWrite(nHandle, cX +CRLF)
        cX := "     komentar=" + Chr(34)+ "" +Chr(34)
        FWrite(nHandle, cX +CRLF)
        cX := "     base64data=" + Chr(34)+ "" +"/Cpw0K" +Chr(34) +">"
        FWrite(nHandle, cX +CRLF)
      next
    endif

    cX := "     </prilohy>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </prilohaStrana2>"
    FWrite(nHandle, cX +CRLF)

    cX := " </datovaVeta>"
    FWrite(nHandle, cX +CRLF)

    cX := "</NEMPRI>"
    FWrite(nHandle, cX +CRLF)

//    FWrite(nHandle, cX +CRLF)
//    TMp_OMETRa()

    FClose( nHandle)

  endif

return nil

*
** Export ELDP od roku 2012 na ÈSSZ v XML --- ( oxbp = drgDialog )
function DIST000074( oXbp, o_mainDBro )
  local  file, nhandle, in_Dir
  *
  local  npoc := 1, nX, nstep
  local  nokr := SysConfig( "System:nCisOkresu")
  local  aX
  *
  local  is_selAllRec := o_mainDBro:is_selAllRec
  local  arSelect     := o_mainDBro:arSelect
  *
  local  recNo := mzEldphd->( recNo()), lok := .t.

  do case
  case  is_selAllRec         ;  mzEldphd->( dbgoTop())
  case  len( arSelect ) <> 0 ;  mzEldphd->( dbgoTo( arSelect[1]))
  endcase


  * výstupní soubor
  in_Dir := retDir(odata_datKom:PathExport)
  file := selFILE('MzdELDP12', 'Xml',in_Dir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})


  if .not. empty( file )

    nHandle := FCreate( file )

    cX  := "<?xml version=" +Chr(34) +"1.0" +Chr(34) +" encoding=" ;
                                            +Chr(34) + "windows-1250" +Chr(34) + "?>"
//                                            +Chr(34) + "UTF-8" +Chr(34) + "?>"
    FWrite(nHandle, cX +CRLF)

    cX  := "<RELDP version=" +Chr(34) +"2009.1"+Chr(34) +" xmlns="+Chr(34) ;
                                      +"http://schemas.cssz.cz/ELDP09" +Chr(34) +">"
    FWrite(nHandle, cX +CRLF)

    do while lok // .not. mzEldphd->( eof())

      * 1
      cX := "   <eldp09 sqnr=" +fVAR( Alltrim(Str(nPoc)))              ;
                  + " yer=" +fVAR( mzEldphd ->cRok)                    ;
                  + " typ=" +fVAR( mzEldphd ->cTypELDP)                ;
                  + IF( Empty( mzEldphd ->dOprELDP), ""                ;
                    ," dre=" +fVAR( DTOCuni( mzEldphd ->dOprELDP)))    ;
                  + " tco=" +fVAR("")                                  ;
                  + " dep=" +fVAR(AllTrim(Str(mzEldphd ->nKodOkrSoc))) ;
                  + " nam=" +fVAR("")                                  ;
                  + ">"
      FWrite(nHandle, cX +CRLF)

      * 2
      cX := "       <client bno=" +fVAR( DELspace( mzEldphd ->cRodCisPrE))  ;
                           + ">"
      FWrite(nHandle, cX +CRLF)

      * 3
      cX := "           <name sur=" +fVAR( AllTrim( LAT_UTF8( mzEldphd ->cPrijOsob)))     ;
                             +" fir=" +fVAR( AllTrim( LAT_UTF8( mzEldphd ->cJmenoOsob)))  ;
                             + IF( Empty( mzEldphd ->cTitulPrac), ""          ;
                             ," tit=" +fVAR( AllTrim( LAT_UTF8( mzEldphd ->cTitulPrac)))) ;
                             + "/>"
      FWrite(nHandle, cX +CRLF)

      * 4
      cX := "           <adr cit=" +fVAR( AllTrim( LAT_UTF8( mzEldphd ->cMisto)))    ;
                          +" str=" +fVAR( AllTrim( LAT_UTF8( mzEldphd ->cUlice)))    ;
                          +" num=" +fVAR( AllTrim( LAT_UTF8( mzEldphd ->cCisPopis))) ;
                          +" pos=" +fVAR( AllTrim( LAT_UTF8( mzEldphd ->cPosta)))    ;
                          +" pnu=" +fVAR( DELspace( mzEldphd ->cPSC))                ;
                          +" cnt=" +fVAR( DELspace( mzEldphd ->cZkratStat))          ;
                          + "/>"
      FWrite(nHandle, cX +CRLF)

      * 5
      cX := "           <birth dat=" +fVAR( DTOCuni( mzEldphd ->dDatNaroz))            ;
                            +" nam=" +fVAR( AllTrim( LAT_UTF8( mzEldphd ->cJmenoRod))) ;
                            +" cit=" +fVAR( AllTrim( LAT_UTF8( mzEldphd ->cMistoNar))) ;
                            + "/>"
      FWrite(nHandle, cX +CRLF)

      * 6
      cX := "       </client>"
      FWrite(nHandle, cX +CRLF)

      * položky
      aX := ELDPit()
      nX := Len( aX)

      cX := "       <items coun=" +fVAR( Str( nX, 1))                       ;
                        + IF( Empty( mzEldphd ->cCelVylDob), ""             ;
                        ," sdex=" +fVAR( DELspace( mzEldphd ->cCelVylDob))) ;
                        + IF( Empty( mzEldphd ->cCelVymZak), ""             ;
                        ," sinc=" +fVAR( DELspace( mzEldphd ->cCelVymZak))) ;
                        + IF( Empty( mzEldphd ->cCelDobOde), ""             ;
                        ," sdar=" +fVAR( DELspace( mzEldphd ->cCelDobOde))) ;
                        + ">"
      FWrite(nHandle, cX +CRLF)

      for nstep := 1 TO nX step 1  ;  FWrite(nHandle, aX[nstep] +CRLF)  ; next

      cX := "       </items>"
      FWrite(nHandle, cX +CRLF)

      * konec
      cX := "       <comp nam=" +fVAR( Alltrim( LAT_UTF8( mzEldphd ->cPodnik)))  ;
                        +" id="  +fVAR( StrZero(mzEldphd ->nIcoOrg,8))           ;
                        +" vs="  +fVAR( Alltrim( LAT_UTF8( mzEldphd ->cVarSym))) ;
                        +" cre=" +fVAR( DTOCuni( mzEldphd ->dDatVyhoEL))         ;
                        + IF( Empty( mzEldphd ->dDatNast), ""                    ;
                                ," fro=" +fVAR( DTOCuni( mzEldphd ->dDatNast)))  ;
                        +"/>"
      FWrite(nHandle, cX +CRLF)

      cX := "     </eldp09>"
      FWrite(nHandle, cX +CRLF)

      mzEldphd->( dbskip())
      nPoc++

      do case
      case is_selAllRec         ;  lok := .not. mzEldphd->( eof())
      case len( arSelect) <> 0  ;  if( len(arSelect) < npoc, lok := .f., mzEldphd->( dbgoTo(arSelect[npoc])) )
      otherwise                 ;  lok := .f.
      endcase

    enddo

    cX  := "</RELDP>"
    FWrite(nHandle, cX +CRLF)

    FClose(nHandle)
  endif

  mzEldphd->( dbgoTo( recNo))
return nil


// Export na penzijní pojišovnu - ÈP - do txt formátu
function DIST000076( oxbp ) // oxbp = drgDialog
  local inDir
  local file
  local cx, ext, recNo

  drgDBMS:open( 'firmy',,,,,'firmyp')

  firmyp ->( dbSeek( mzdzavhd->ncisfirmy,,'FIRMY1'))

  cX := AllTrim(Left( firmyp->cIdKoduPoj, 5)) +StrZero( Month( Date()), 2) +'0'

  * exportní soubor pro penzijní pojišovnu
  inDir := retDir(odata_datKom:PathExport)
  ext   := 'hpa'
  file  := inDir + cX + '.'+ ext
  file  := selFILE( cX,ext,inDir,'Výbìr souboru pro export',{{"TXT soubory", ext}})
  recNo := mzdzavhd->(recNo())

  if( .not. Empty(file), GenHroPlPF( file), nil)

return( nil)

// Export na penzijní pojišovnu - ÈSOB - do txt formátu
function DIST000080( oxbp ) // oxbp = drgDialog
  local inDir
  local file
  local cx, ext, recNo

  drgDBMS:open( 'firmy',,,,,'firmyp')

  firmyp ->( dbSeek( mzdzavhd->ncisfirmy,,'FIRMY1'))

  cX := AllTrim( Str( SysConfig( "System:nICO")))

  * exportní soubor pro penzijní pojišovnu
  inDir := retDir(odata_datKom:PathExport)
  ext   := StrZero( Month( Date()), 2)
  file  := inDir + cX + '.'+ ext
  file  := selFILE( cX,ext,inDir,'Výbìr souboru pro export',{{"TXT soubory", ext}})
  recNo := mzdzavhd->(recNo())

  if( .not. Empty(file), GenHroPlPF( file), nil)

return( nil)

// Export na penzijní pojišovnu - AXA - do txt formátu
function DIST000081( oxbp ) // oxbp = drgDialog
  local inDir
  local file
  local cx, ext, recNo

  drgDBMS:open( 'firmy',,,,,'firmyp')

  firmyp ->( dbSeek( mzdzavhd->ncisfirmy,,'FIRMY1'))

  cX := 'PP' +AllTrim( Str( SysConfig( "System:nICO")))

  * exportní soubor pro penzijní pojišovnu
  inDir := retDir(odata_datKom:PathExport)
  ext   := StrZero( Month( Date()), 2)
  file  := inDir + cX + '.'+ ext
  file  := selFILE( cX,ext,inDir,'Výbìr souboru pro export',{{"TXT soubory", ext}})
  recNo := mzdzavhd->(recNo())

  if( .not. Empty(file), GenHroPlPF( file), nil)

return( nil)


// Export na penzijní pojišovnu - ALIANZ - do txt formátu
function DIST000082( oxbp ) // oxbp = drgDialog
  local inDir
  local file
  local cx, ext, recNo
  local obd := {'1','2','3','4','5','6','7','8','9','A','B','C',}
  local n

  drgDBMS:open( 'firmy',,,,,'firmyp')

  firmyp ->( dbSeek( mzdzavhd->ncisfirmy,,'FIRMY1'))

  cX := 'A' +Left(AllTrim( Str( SysConfig( "System:nICO"))),7)
  n  := Month( Date())
  * exportní soubor pro penzijní pojišovnu
  inDir := retDir(odata_datKom:PathExport)
  ext   := obd[n]+ '00'
  file  := inDir + cX + '.'+ ext
  file  := selFILE( cX,ext,inDir,'Výbìr souboru pro export',{{"TXT soubory", ext}})
  recNo := mzdzavhd->(recNo())

  if( .not. Empty(file), GenHroPlPF( file), nil)

return( nil)

// Export na penzijní pojišovnu - ÈS - do txt formátu
function DIST000083( oxbp ) // oxbp = drgDialog
  local inDir
  local file
  local cx, recNo

  drgDBMS:open( 'firmy',,,,,'firmyp')

  firmyp ->( dbSeek( mzdzavhd->ncisfirmy,,'FIRMY1'))

  cX := AllTrim(Left( firmyp->cIdKoduPoj, 5)) +StrZero( Month( Date()), 2) +'0'

  * exportní soubor pro penzijní pojišovnu
  inDir := retDir(odata_datKom:PathExport)
  file  := inDir + cX + '.hpa'
  recNo := mzdzavhd->(recNo())

  if( .not. Empty(file), GenHroPlPF( file), nil)

return( nil)

// Export na penzijní pojišovnu - GENERALI - do txt formátu
function DIST000084( oxbp ) // oxbp = drgDialog
  local inDir
  local file
  local cx, ext, recNo

  drgDBMS:open( 'firmy',,,,,'firmyp')

  firmyp ->( dbSeek( mzdzavhd->ncisfirmy,,'FIRMY1'))

  cX := AllTrim(Left( firmyp->cIdKoduPoj, 5)) +StrZero( Month( Date()), 2) +'0'

  * exportní soubor pro penzijní pojišovnu
  inDir := retDir(odata_datKom:PathExport)
  ext   := 'hpa'
  file  := inDir + cX + '.'+ ext
  file  := selFILE( cX,ext,inDir,'Výbìr souboru pro export',{{"TXT soubory", ext}})
  recNo := mzdzavhd->(recNo())

  if( .not. Empty(file), GenHroPlPF( file), nil)

return( nil)

// Export na penzijní pojišovnu - ING - do txt formátu
function DIST000085( oxbp ) // oxbp = drgDialog
  local inDir
  local file
  local cx, ext, recNo

  drgDBMS:open( 'firmy',,,,,'firmyp')

  firmyp ->( dbSeek( mzdzavhd->ncisfirmy,,'FIRMY1'))

  cX := AllTrim(Left( firmyp->cIdKoduPoj, 5)) +StrZero( Month( Date()), 2) +'0'

  * exportní soubor pro penzijní pojišovnu
  inDir := retDir(odata_datKom:PathExport)
  ext   := 'hpa'
  file  := inDir + cX + '.'+ ext
  file  := selFILE( cX,ext,inDir,'Výbìr souboru pro export',{{"TXT soubory", ext}})
  recNo := mzdzavhd->(recNo())

  if( .not. Empty(file), GenHroPlPF( file), nil)

return( nil)

// Export na penzijní pojišovnu - RAIFFESEIN - do txt formátu
function DIST000086( oxbp ) // oxbp = drgDialog
  local inDir
  local file
  local cx, ext, recNo

  drgDBMS:open( 'firmy',,,,,'firmyp')

  firmyp ->( dbSeek( mzdzavhd->ncisfirmy,,'FIRMY1'))

  cX := AllTrim(Left( firmyp->cIdKoduPoj, 5)) +StrZero( Month( Date()), 2) +'0'

  * exportní soubor pro penzijní pojišovnu
  inDir := retDir(odata_datKom:PathExport)
  ext   := 'hpa'
  file  := inDir + cX + '.'+ ext
  file  := selFILE( cX,ext,inDir,'Výbìr souboru pro export',{{"TXT soubory", ext}})
  recNo := mzdzavhd->(recNo())

  if( .not. Empty(file), GenHroPlPF( file), nil)

return( nil)


// Export na ISPV
function DIST000090( oxbp ) // oxbp = drgDialog
  local tm
  local cx
  local nx, nx1, nx2
  local nit
  local file
  local in_Dir
  local aSUM := {0,0,0,0,0,0,0,0,0}
  local cBuff
  local cROKzpr, cKeyObdOD, cKeyObdDO

//  drgDBMS:open( 'mzdzavit',,,,, 'mzdzavita' )
//    drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('mzdyhd',,,,,'mzdyhdt')

  cROKzpr   := Str( uctOBDOBI:MZD:NROK,4,0)
  cKeyObdOD := cROKzpr +StrZero(      1, 2)
  cKeyObdDO := cROKzpr +StrZero( uctOBDOBI:MZD:NOBDOBI, 2)

  nIT := 1

  cX := "ISPVData"

  cDATE := StrZero( Day( Date()), 2) +StrZero( Month( Date()), 2)      ;
                 +StrZero( Val( SubStr( Str(Year( Date())),3,2)), 2)
//    cOutFILE_1 := cTmpPath + cX +".xml"

  * výstupní soubor
  in_Dir := retDir(odata_datKom:PathExport)
  file := selFILE( cX,'Xml',in_Dir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

  if .not. Empty(file)
    nHandle := FCreate( file )

    cX  := "<?xml version=" +Chr(34) +"1.0" +Chr(34) +" encoding=" ;
                                    + Chr(34)+ "windows-1250" +Chr(34) + "?>"
    FWrite( nHandle, cX +CRLF)

    cX  := "<ispv struktura=" +Chr(34) +"2017" +Chr(34)                    ;
              +" verze="+Chr(34) +"1" +Chr(34) +" podverze="+Chr(34) +"1" +Chr(34) ;
              +" xmlns=" +Chr(34) +"http://www.ispv.cz/schema/ispv2009/1"     ;
              +Chr(34) +" xmlns:xsi=" +Chr(34)                                   ;
              +"http://www.w3.org/2001/XMLSchema-instance" +Chr(34)              ;
              +" xsi:schemaLocation=" +Chr(34)+                                  ;
              +"http://www.ispv.cz/schema/ispv2017 http://www.ispv.cz/schema/ispv2017.xsd";
              +Chr(34)+">"
    FWrite( nHandle, cX +CRLF)

    FWrite( nHandle, "  <parametry>" +CRLF)
    FWrite( nHandle, "    <desTeckaCarka></desTeckaCarka>" +CRLF)
    FWrite( nHandle, "  </parametry>" +CRLF)
    FWrite( nHandle, "  <odesilatel>" +CRLF)

    cX := LAT_UTF8( AllTrim( SysConfig( "System:cPodnik" )))
    FWrite( nHandle, "    <firma>" +cX +"</firma>" +CRLF)

    cX := LAT_UTF8( AllTrim( SysConfig( "System:cUserNam" )))
    FWrite( nHandle, "    <jmeno>" +cX +"</jmeno>" +CRLF)

    cX := AllTrim( SysConfig( "System:cEmail" ))
    FWrite( nHandle, "    <email>" +cX +"</email>" +CRLF)

    cX := AllTrim( SysConfig( "System:cTelefon" ))
    FWrite( nHandle, "    <telefon>" +cX +"</telefon>" +CRLF)

    FWrite( nHandle, "    <zprava></zprava>" +CRLF)
    FWrite( nHandle, "  </odesilatel>" + CRLF)

    cX := Chr(34) +AllTrim( StrZero( SysConfig( "System:nICO" ), 8)) +Chr(34)
    FWrite( nHandle, "  <zamestnavatel ico=" +cX +">" +CRLF)

    FWrite( nHandle, "    <ekonomickySubjekt>" +CRLF)

    cX := LAT_UTF8( AllTrim( SysConfig( "System:cPodnik")))
    FWrite( nHandle, "      <nazev>" +cX +"</nazev>" +CRLF)

    cX := LAT_UTF8( AllTrim( SysConfig( "System:cUlice")))
    FWrite( nHandle, "      <ulicecp>" +cX +"</ulicecp>" +CRLF)

    cX := LAT_UTF8( AllTrim( SysConfig( "System:cSidlo")))
    FWrite( nHandle, "      <misto>" +cX +"</misto>" +CRLF)

    cX := StrTran( SysConfig( "System:cPSC"), " ", "")
    FWrite( nHandle, "      <psc>" +cX +"</psc>" +CRLF)

    cX := AllTrim( SysConfig( "System:cKodUzemJe"))
    FWrite( nHandle, "      <lau1>" +cX +"</lau1>" +CRLF)

    tmhlispvw->( dbGoTop())
    do while .not. tmhlispvw->( Eof())
      aSum[1] += tmhlispvw->qMZDA + tmhlispvw->qNAHRADY + tmhlispvw->qPOHOTOV
      aSum[2] += tmhlispvw->qPONEPRAV
      aSum[3] += tmhlispvw->qODPRACD
      aSum[4] += tmhlispvw->qPRESCAS
      aSum[5] += tmhlispvw->qABSCELK
      aSum[6] += tmhlispvw->qABSPLAC
      aSum[7] += 0
      aSum[8] += 0
      aSum[9] += 0

      tmhlispvw->( dbSkip())
    enddo

    cX := AllTrim( Str(aSum[1],12,0))
    FWrite( nHandle, "      <hrmzdyq>" +cX +"</hrmzdyq>" +CRLF)

    cX := AllTrim( Str(aSum[2],12,0))
    FWrite( nHandle, "      <poneq>" +cX +"</poneq>" +CRLF)

    cX := AllTrim( Str(aSum[3],12,0))
    FWrite( nHandle, "      <odpracdq>" +cX +"</odpracdq>" +CRLF)

    cX := AllTrim( Str(aSum[4],12,0))
    FWrite( nHandle, "      <prescasq>" +cX +"</prescasq>" +CRLF)

    cX := AllTrim( Str(aSum[5],12,0))
    FWrite( nHandle, "      <abscelkq>" +cX +"</abscelkq>" +CRLF)

    cX := AllTrim( Str(aSum[6],12,0))
    FWrite( nHandle, "      <absplacq>" +cX +"</absplacq>" +CRLF)

    nX := nX1 := nX2 := 0

//    filtrs := Format( "nrokobd >= %% and nrokobd <= %%", { Val(cKeyObdOd),Val(cKeyObdDo)})
    filtrs := Format( "nrok = %% and nctvrtleti = %%", { uctOBDOBI:MZD:NROK, mh_CTVRTzOBDn( uctOBDOBI:MZD:NOBDOBI) })

    mzdyhdt->( Ads_setAOF(filtrs), dbGotop())
     do while .not. mzdyhdt->( Eof())
       if mzdyhdt->cDruPraVzt = "HLAVNI"
         nX1 += mzdyhdt->nFyzStavOb
         nX2 += mzdyhdt->nFyzStavPr
//       nX1 += mzdyhdt->nPreVPZaFy
//       nX2 += mzdyhdt->nPreVPZaPr
//         nX++
       endif
       mzdyhdt->( dbSkip())
     enddo
    mzdyhdt->( Ads_ClearAOF())

    cX := AllTrim( Str( Round(nX1/3,0),12,0))
    FWrite( nHandle, "      <pocfyzq>" +cX +"</pocfyzq>" +CRLF)

    cX := AllTrim( Str( Round(nX2/3,0),12,0))
    FWrite( nHandle, "      <pocprepq>" +cX +"</pocprepq>" +CRLF)

    cX := AllTrim( Str(aSum[7],12,0))
    FWrite( nHandle, "      <oonq>" +cX +"</oonq>" +CRLF)

    cX := AllTrim( Str(aSum[8],12,0))
    FWrite( nHandle, "      <odmdpcq>" +cX +"</odmdpcq>" +CRLF)

    cX := AllTrim( Str(aSum[9],12,0))
    FWrite( nHandle, "      <hoddpcq>" +cX +"</hoddpcq>" +CRLF)

// nové   25.10.2018 JT
    cX := AllTrim( Str( 0,12,0))
    FWrite( nHandle, "      <odmdppq>" +cX +"</odmdppq>" +CRLF)

    cX := AllTrim( Str( 0,12,0))
    FWrite( nHandle, "      <hoddppq>" +cX +"</hoddppq>" +CRLF)

    cX := AllTrim( Str( 0,12,0))
    FWrite( nHandle, "      <odmstatq>" +cX +"</odmstatq>" +CRLF)

    cX := AllTrim( Str( 0,12,0))
    FWrite( nHandle, "      <odstupq>" +cX +"</odstupq>" +CRLF)
// nové


    FWrite( nHandle, "    </ekonomickySubjekt>" +CRLF)
    FWrite( nHandle, "  </zamestnavatel>" +CRLF)

    if uctOBDOBI:MZD:NOBDOBI = 6 .or. uctOBDOBI:MZD:NOBDOBI = 12
      cX := Chr(34) +AllTrim( StrZero( SysConfig( "System:nICO" ), 8)) +Chr(34)
      FWrite( nHandle, "  <zamestnanci ico=" +cX +">" +CRLF)

      tmhlispvw->( dbGoTop())
      do while .not.tmhlispvw->( Eof())
        FWrite( nHandle, "    <zamestnanec>" +CRLF)

        for n = 2 to 36 // tmhlispvw->( FCount())
          cX      := AllTrim( tmhlispvw->( FieldName( n)))
          xValue  := tmhlispvw->( FieldGet( n))
          if ValType( tmhlispvw->&cX) = "C"
            xValue := AllTrim( tmhlispvw->&cX)
          else
            xValue := AllTrim( Str( tmhlispvw->&cX))
          endif
          cBUFF :="      " + "<" +Lower(cX) +">" +xValue +"</" +Lower(cX) +">"
          FWrite( nHandle, cBuff +CRLF)
        Next
        FWrite( nHandle, "    </zamestnanec>" +CRLF)
        tmhlispvw->( dbSkip())
      enddo

      FWrite( nHandle, "  </zamestnanci>" +CRLF)
    endif

    FWrite( nHandle, "</ispv>" +CRLF)

    FClose( nHandle)

  endif

return( nil)


STATIC FUNCTION ELDPit()
  LOCAL  n, nIT, nRok, j
  LOCAL  cX, aX, cY, cIT
  LOCAL  aRET :={}

  FOR n := 1 TO 3
    cY   := ""
    nRok := 0
    cX := "cR" +Str(n,1) +"_Kod"
    IF !Empty( mzEldphd ->&(cX))
      cIT := "           <t1 row=" +fVAR( DELspace( Str( n)))
      cIT := cIT +" cod=" +fVAR( DELspace( mzEldphd ->&(cX)))

      cX  := "lR" +Str(n,1) +"_MR"
      if mzEldphd ->&(cX)
        cIT := cIT +" sre=" +fVAR( "A")
      else
        cIT := cIT +" sre=" +fVAR( "N")
      endif

      cX  := "cR" +Str(n,1) +"_Znepl"
      IF !Empty( mzEldphd ->&(cX))
        cIT := cIT +" sre=" +fVAR( DELspace( mzEldphd ->&(cX)))
      ENDIF

      cX  := "cR" +Str(n,1) +"_Od"
      IF !Empty( mzEldphd ->&(cX))
        cX  := Alltrim( mzEldphd ->&(cX)) +"." +mzEldphd ->cRok
        cIT := cIT +" fro=" +fVAR( DTOCuni( CTOD( cX)))
      ENDIF
      cX  := "cR" +Str(n,1) +"_Do"
      IF !Empty( mzEldphd ->&(cX))
        cX  := AllTrim( mzEldphd ->&(cX)) +"." +mzEldphd ->cRok
        cIT := cIT +" to=" +fVAR( DTOCuni( CTOD( cX)))
      ENDIF
      cX  := "cR" +Str(n,1) +"_Dny"
      IF !Empty( mzEldphd ->&(cX))
        cIT := cIT +" din=" +fVAR( DELspace( mzEldphd ->&(cX)))
      ENDIF

      FOR j := 1 TO 12
        cX := "cR" +Str(n,1) +"_Obd" +StrZero( j, 2)
        IF !Empty( mzEldphd ->&(cX))
          cY := cY +" m" +AllTrim( Str(j)) +"=" +fVAR("x")
          nRok++
        ELSE
          cY := cY +" m" +AllTrim( Str(j)) +"=" +fVAR("")
        ENDIF
      NEXT

      cX := "cR" +Str(n,1) +"_Rok"
      IF nRok > 0 .or. !Empty( mzEldphd ->&(cX))
        cIT := cIT +IF( nRok == 12 .or. !Empty( mzEldphd ->&(cX)), " m13=" +fVAR("x"), cY)
      ENDIF

      cX  := "cR" +Str(n,1) +"_VylDob"
      IF !Empty( mzEldphd ->&(cX))
        cIT := cIT +" dex=" +fVAR( DELspace( mzEldphd ->&(cX)))
      ENDIF
      cX  := "cR" +Str(n,1) +"_VymZak"
      IF !Empty( mzEldphd ->&(cX))
        cIT := cIT +" inc=" +fVAR( DELspace( mzEldphd ->&(cX)))
      ENDIF
      cX  := "cR" +Str(n,1) +"_DobOde"
      IF !Empty( mzEldphd ->&(cX))
        cIT := cIT +" dar=" +fVAR( DELspace( mzEldphd ->&(cX)))
      ENDIF
      cIT := cIT +"/>"
      AADD( aRET, cIT)
    ENDIF
  NEXT

/*
  IF !Empty( mzEldphd ->cVCM1_druh)
    cIT := "           <t2 row=" +fVAR( "1")
    cIT := cIT +" cod=" +fVAR( Alltrim( mzEldphd ->cVCM1_Druh))
    cX  := Alltrim( mzEldphd ->cVCM1_Od) +"." +mzEldphd ->cRok
    cIT := cIT +" fro=" +fVAR( DTOCuni( CTOD( cX)))
    cX  := Alltrim( mzEldphd ->cVCM1_Do) +"." +mzEldphd ->cRok
    cIT := cIT +" to=" +fVAR( DTOCuni( CTOD( cX)))
    cIT := cIT +"/>"
    AADD( aRET, cIT)
  ENDIF

  IF !Empty( mzEldphd ->cVCM2_druh)
    cIT := "           <t2 row="   +fVAR( "2")
    cIT := cIT +" cod=" +fVAR( AllTrim( mzEldphd ->cVCM2_Druh))
    cX  := AllTrim( mzEldphd ->cVCM2_Od) +"." +mzEldphd ->cRok
    cIT := cIT +" fro=" +fVAR( DTOCuni( CTOD( cX)))
    cX  := AllTrim( mzEldphd ->cVCM2_Do) +"." +mzEldphd ->cRok
    cIT := cIT +" to="  +fVAR( DTOCuni( CTOD( cX)))
    cIT := cIT +"/>"
    AADD( aRET, cIT)
  ENDIF
*/


RETURN(aRET)


static function GenHroPlPF( file)
  local tm
  local cx
  local filtr

  drgDBMS:open( 'mzdzavit',,,,, 'mzdzavita' )

  filtr     := format( "ndoklad = %%", { mzdzavhd->ndoklad})
  mzdzavita->( ads_setAof(filtr),dbgoTop())

  nHandle := FCreate( file )

  mzdzavita->( dbGoBotTom())

  tm := StrZero( Year( Date()), 4) +StrZero( Month( Date()), 2)
  cx := 'S' +";" +AllTrim( Str( SysConfig( "System:nICO"))) +";"           ;
                 +AllTrim( firmyp ->cIdKoduPoj) +";"                   ;
                 +AllTrim( SysConfig( "System:cPodnik")) +";"            ;
                 +AllTrim( Str( mzdzavhd->nICO,8)) +";"                  ;
                 +odata_datKom:TypPenPoj +";"                                            ;
                 +AllTrim( Str( mzdzavhd->ncenfakcel, 12, 2)) +";"       ;
                 +AllTrim( Str( mzdzavhd->nKonstSymb,8)) +";"            ;
                 +AllTrim( mzdzavhd->cVarSym) +";"                      ;
                 +AllTrim( mzdzavhd->cSpecSymb) +";"                     ;
                 +tm +";" +"1" +";"                                      ;
                 +AllTrim( Str( mzdzavita->nintcount,6,0)) +CRLF

  FWrite( nHandle, cx)

  mzdzavita->( dbGoTop())
  do while .not. mzdzavita->(Eof())
    cx :=  AllTrim(mzdzavita->cdoplntxt) +CRLF

    FWrite( nHandle, cx)
    mzdzavita->( dbSkip())
  enddo
  mzdzavita->(ads_clearAof())

  FWrite( nHandle, Chr( 26), 1)
  FClose( nHandle)

  drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)

return .t.


// Import do podkladù pro obìdy - KOVAR - v CSV ( z XLS tabulky)
function DIST000093( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, inDir
  local j, n := 0
  local line, aline
  local afiles := {}

  drgDBMS:open( 'mzpobedo',,,,, 'mzpobedoi' )
  drgDBMS:open( 'msprc_mo',,,,, 'msprc_moi' )

  m_oDBro  := oxbp:parent:odBrowse[1]
  m_File   := lower(m_oDBro:cFile)

  arSelect   := aclone(m_oDBro:arSelect)
  inDir := retDir(odata_datKom:PathImport)   // + odata_datKom:FileImport

  if Upper(oxbp:formName) = 'SYS_SELECTKOM_CRD'
    file := selFILE('','CSV',inDir,'Výbìr souborù',{{"CSV soubory", "*.CSV"}})
    AAdd( afiles, file)
  else
    afiles := FileInDirs( inDir, '*.csv', .t.)
  endif

  for j := 1 to len( afiles)
    nHandle  := FOpen( afiles[j], FO_READ )
    cBuffer  := FReadStr(nHandle,128)

    do while cBuffer <> ''
      do while ( n := At( CRLF, cBuffer)) > 0
        line := SubStr( cBuffer,1,n-1)

        aline  := ListAsArray( line,';')
        key := StrZero(uctOBDOBI:MZD:NROKOBD,6)  + StrZero( Val(aline[1]), 5) + '1' // klíè pro hledání pracovníka

        if msprc_moi->( dbSeek( key,,'MSPRMO25'))      // hledání pracovníka
          mh_copyFld('msprc_moi','mzpobedoi',.t.)

          mzpobedoi->ctypimport := 'K'
          mzpobedoi->ddatimpex  := Date()
          mzpobedoi->nCenaObedy := Val(aline[2])
          mzpobedoi->nmsprc_mo  := isNull( msprc_moi->sid, 0)

          mzpobedoi->( dbCommit())
        endif
        cBuffer := SubStr( cBuffer,n+2)
      enddo
      cBuffer := cBuffer +FReadStr(nHandle, 128)  // result: 4
    enddo

    FClose( nHandle)

  next

  drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)

return( nil)


// Import ML z výroby - ECompany
function DIST000094( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, inDir
  local j, n := 0
  local line, aline
  local afiles := {}
  local nhrmzda, nprocprem

  drgDBMS:open('mzddavhd',,,,,'mzddavhdx')
  drgDBMS:open('mzddavit',,,,,'mzddavitx')
  drgDBMS:open('msprc_mo',,,,,'msprc_mox')
  drgDBMS:open('druhymzd',,,,,'druhymzdx')
  drgDBMS:open('mzddavitw',.t.,.t.,drgINI:dir_USERfitm,,,.t.) ; ZAP

  rok     := uctOBDOBI:MZD:NROK
  mes     := uctOBDOBI:MZD:NOBDOBI
  rokobd  := (rok*100)+ mes
  nhrmzda := 0

  key := StrZero( rokobd,6) + '0120'
  if .not. druhymzdx->( dbSeek( key,,'DRUHYMZD04'))
    drgMsgBox(drgNLS:msg('Není nastaven druh mzdy 120'), XBPMB_INFORMATION)
    return( nil)
  endif

  m_oDBro  := oxbp:parent:odBrowse[1]
  m_File   := lower(m_oDBro:cFile)

  arSelect   := aclone(m_oDBro:arSelect)
  inDir := retDir(odata_datKom:PathImport)   // + odata_datKom:FileImport

  if Upper(oxbp:formName) = 'SYS_SELECTKOM_CRD'
    file := selFILE('*','CSV',inDir,'Výbìr souborù',{{"CSV soubory", "*.CSV"}})
    AAdd( afiles, file)
  endif

  nHandle  := FOpen( afiles[1], FO_READ )
  cBuffer  := FReadStr(nHandle,128)

  do while cBuffer <> ''
    do while ( n := At( CRLF, cBuffer)) > 0
      line := SubStr( cBuffer,1,n-1)
      aline  := ListAsArray( line,';')
      mzddavitw->( dbAppend())

      mzddavitw->noscisprac := Val( aline[1])
      mzddavitw->nhoddoklad := mh_roundNumb( Val( StrTran(aline[2],',','.') ),12)

      mzddavitw->( dbCommit())

      cBuffer := SubStr( cBuffer,n+2)
    enddo
    cBuffer := cBuffer +FReadStr(nHandle, 128)  // result: 4
  enddo

  FClose( nHandle)

  mzddavitw->( dbGoTop())
//    drgNLS:msg('probíhá generování dokladù')

    do while .not. mzddavitw->( eof())
      nhrmzda   := 0
      nprocprem := 0
*      if .not. mzddavhdx->( dbSeek( msmzdyhdx->sid,,'nMSMZDYHD'))
      key := StrZero( rokobd,6) +StrZero(mzddavitw->noscisprac,5) + '1'
      if msprc_mox->( dbSeek( key,,'MSPRMO26'))
        mh_copyfld('msprc_mox','mzddavhdx',.t.)
        mzddavhdx ->cdenik     := 'MH'
        mzddavhdx ->ctypDoklad := 'MZD_PRIJEM'
        mzddavhdx ->ctypPohybu := 'HRUBMZDA'
        mzddavhdx ->ndoklad    := fin_range_key('MZDDAVHD:VY')[2]
        mzddavhdx ->ddatPoriz  := mh_LastODate( rok, mes)
        mzddavhdx ->nautoGen   := 5
      *
*        mzddavhdx->nmsmzdyhd := msmzdyhdx->sid

        if mzddavitw->nhoddoklad <> 0
          key := StrZero( rokobd,6) + '0109'
          if druhymzdx->( dbSeek( key,,'DRUHYMZD04'))
            mh_copyfld('mzddavhdx','mzddavitx',.t.)
            mzddavitx->norditem   := 10
            mzddavitx->cnazpol1   := msprc_mox->cnazpol1
            mzddavitx->ndruhmzdy  := druhyMzdx->ndruhmzdy
            mzddavitx->cucetskup  := druhyMzdx->cucetskup
            mzddavitx->nhoddoklad := mh_roundNumb( mzddavitw->nhoddoklad, druhyMzdx->nKodZaokr )
            mzddavitx->ndnydoklad := mh_roundNumb( mzddavitw->nhoddoklad/fPracDOBA( msprc_mox->cDelkPrDob)[3], 212)

            mzddavitx->nhodfondkd := mzddavitx->nhoddoklad
            mzddavitx->nhodfondpd := mzddavitx->nhoddoklad
            mzddavitx->ndnyfondkd := mzddavitx->ndnydoklad
            mzddavitx->ndnyfondpd := mzddavitx->ndnydoklad

            mzddavhdx->nhodfondkd := mzddavitx->nhoddoklad
            mzddavhdx->nhodfondpd := mzddavitx->nhoddoklad
            mzddavhdx->ndnyfondkd := mzddavitx->ndnydoklad
            mzddavhdx->ndnyfondpd := mzddavitx->ndnydoklad

            mzddavitx->( dbcommit() )
          endif

          key := StrZero( rokobd,6) + '0115'
          if druhymzdx->( dbSeek( key,,'DRUHYMZD04'))
            mh_copyfld('mzddavhdx','mzddavitx',.t.)

            mzddavitx->norditem   := 20
            mzddavitx->cnazpol1   := msprc_mox->cnazpol1
            mzddavitx->ndruhmzdy  := druhyMzdx->ndruhmzdy
            mzddavitx->cucetskup  := druhyMzdx->cucetskup
            mzddavitx->nhoddoklad := mzddavitw->nhoddoklad
            mzddavitx->nsazbadokl := fSazTar(mzddavhdx ->ddatPoriz,'msprc_mox')[1]

            nhrmzda := Mh_RoundNumb( mzddavitx->nhoddoklad * mzddavitx->nsazbadokl, druhyMzdx->nKodZaokr)

            mzddavitx->nHrubaMZD  := nhrmzda
            mzddavitx->nMzda      := nhrmzda
            mzddavitx->nZaklSocPo := mzddavitx->nHrubaMZD
            mzddavitx->nZaklZdrPo := mzddavitx->nHrubaMZD

            mzddavitx->( dbcommit() )
          endif
        endif

        nprocprem := fSazZAM('PRCPREHLCI',mzddavhdx ->ddatPoriz,'msprc_mox')
        if nprocprem <> 0 .and. nhrmzda <> 0
          key := StrZero( rokobd,6) + '0150'
          if druhymzdx->( dbSeek( key,,'DRUHYMZD04'))
            mh_copyfld('mzddavhdx','mzddavitx',.t.)
            mzddavitx->norditem   := 30
            mzddavitx->cnazpol1   := msprc_mox->cnazpol1
            mzddavitx->ndruhmzdy  := druhyMzdx->ndruhmzdy
            mzddavitx->cucetskup  := druhyMzdx->cucetskup
            mzddavitx->nhoddoklad := 0
            mzddavitx->npremie    := nprocprem
            mzddavitx->nsazbadokl := mh_roundNumb( nhrmzda * nprocprem/100, druhyMzdx->nKodZaokr )
            mzddavitx->nHrubaMZD  := mzddavitx->nsazbadokl
            mzddavitx->nMzda      := mzddavitx->nsazbadokl
            mzddavitx->nZaklSocPo := mzddavitx->nHrubaMZD
            mzddavitx->nZaklZdrPo := mzddavitx->nHrubaMZD
            nprocprem             := mzddavitx->nsazbadokl
            mzddavitx->( dbcommit() )
          else
            nprocprem := 0
          endif
        endif

        mzddavhdx->nHrubaMZD  := nhrmzda + nprocprem
        mzddavhdx->nMzda      := mzddavhdx->nHrubaMZD
        mzddavhdx->nZaklSocPo := mzddavhdx->nHrubaMZD
        mzddavhdx->nZaklZdrPo := mzddavhdx->nHrubaMZD

        mzddavhdx->( dbcommit() )

      endif

      mzddavitw->( dbSkip())
    enddo


*      endif

/*
      filtr   := Format("nmsmzdyhd = %% .and. lAktivni", {msmzdyhdx->sid})
      msmzdyitx ->( ads_setaof( filtr), dbGoTop())

      msmzdyitx->( dbGoTop())
      do while .not. msmzdyitx->( eof())
        if .not. mzddavitx->( dbSeek( msmzdyitx->sid,,'nMSMZDYIT'))
          mh_copyfld('msmzdyitx','mzddavitx',.t.)
          mzddavitx->nrok       := mzddavhdx->nrok
          mzddavitx->nobdobi    := mzddavhdx->nobdobi
          mzddavitx->nrokobd    := mzddavhdx->nrokobd
          mzddavitx->cobdobi    := mzddavhdx->cobdobi
          mzddavitx->ndoklad    := mzddavhdx->ndoklad

          mzddavitx->croobcpppv := mzddavhdx->croobcpppv
          mzddavitx->crocpppv   := mzddavhdx->crocpppv
          mzddavitx->nmsmzdyit  := msmzdyitx->sid
        endif
        mzddavitx->( dbcommit() )
        mzddavitx->( dbunlock() )
        msmzdyitx->( dbSkip())
      enddo

      msmzdyitx ->( ads_clearAof() )
      msmzdyhdx->( dbSkip())
    enddo
    mzddavhdx->( dbunlock() )
    mzddavhdx->( dbcommit() )

    mzddavitx ->( ads_clearAof() )
    mzddavhdx ->( ads_clearAof() )
  endif
*/
  drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)

return( nil)



// Export pøehled o výši pojistné.2016 na ÈSSZ v XML - PVPOJ
function DIST000111( oxbp ) // oxbp = drgDialog
  local tm
  local cx
  local nit
  local file
  local in_Dir

//  drgDBMS:open( 'mzdzavit',,,,, 'mzdzavita' )
//    drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP

  nIT := 1

  do case
  case !Empty( SysConfig( "System:cZkrNazPod"))
    cX := AllTrim( SysConfig( "System:cZkrNazPod"))
  case !Empty( SysConfig( "System:nICO"))
    cX := AllTrim( StrZero( SysConfig( "System:nICO" ), 8))
  otherwise
    cX := "REGCSSZ"
  endcase

  cX := "PVPOJ2016" +SubStr( cX, 1, 6)

  cDATE := StrZero( Day( Date()), 2) +StrZero( Month( Date()), 2)      ;
                 +StrZero( Val( SubStr( Str(Year( Date())),3,2)), 2)
//    cOutFILE_1 := cTmpPath + cX +".xml"
  * výstupní soubor
  in_Dir := retDir(odata_datKom:PathExport)
  file := selFILE( cX,'Xml',in_Dir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})


  if .not. Empty(file)
//    do while .not.

    nHandle := FCreate( file )
    cX  := "<?xml version=" +Chr(34) +"1.0" +Chr(34) +" encoding=" ;
              + Chr(34)+ "windows-1250" +Chr(34) + "?>"
//              + Chr(34)+ "UTF-8" +Chr(34) + "?>"
    FWrite(nHandle, cX +CRLF)

    cX  := "<pvpoj xmlns="+ Chr(34)+"http://schemas.cssz.cz/POJ/PVPOJ2016" +Chr(34) + ">"
    FWrite(nHandle, cX +CRLF)

    cX  := "<VENDOR productName="+ Chr(34)+"FormApps Server" +Chr(34) +" productVersion=" +Chr(34)+"1.4.0"+Chr(34)+ "/>"
    FWrite(nHandle, cX +CRLF)
    cX  := "<SENDER EmailNotifikace="+ Chr(34)+"jmeno.prijmeni@domena.cz" +Chr(34) +" ISDSreport=" +Chr(34)+"XML+HTML"+Chr(34)+ "/>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <prehled typPrehledu="+fVAR(AllTrim(LAT_UTF8("N")))+" verze=" + Chr(34)+ "2016.0" + Chr(34)+ ">"
    FWrite(nHandle, cX +CRLF)

    cX := "   <okres>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <kodOSSZ>"+AllTrim(Str(tmprposow->nKodOkrSoc,3,0))+"</kodOSSZ>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <nazevOSSZ>"+AllTrim( LAT_UTF8(tmprposow->cNazMisSoc))+"</nazevOSSZ>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </okres>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <obdobi>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <mesic>"+AllTrim( StrZero(tmprposow->nobdobi,2))+"</mesic>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <rok>"+AllTrim( StrZero(tmprposow->nrok,4))+"</rok>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </obdobi>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <zamestnavatel>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <vs>"+AllTrim( LAT_UTF8(tmprposow->cVarSymSoc))+"</vs>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <IC>"+AllTrim( LAT_UTF8(tmprposow->cIco))+"</IC>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <nazev>"+AllTrim( LAT_UTF8(tmprposow->cNazevZame))+"</nazev>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <adresa>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <ulice>"+AllTrim( LAT_UTF8(tmprposow->cUlice))+"</ulice>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <cisloDomu>"+AllTrim( LAT_UTF8(tmprposow->cCisPopis))+"</cisloDomu>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <obec>"+AllTrim( LAT_UTF8(tmprposow->cMisto))+"</obec>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <PSC>"+AllTrim( LAT_UTF8(tmprposow->cPsc))+"</PSC>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <stat>"+AllTrim( LAT_UTF8(tmprposow->cZkratStat))+"</stat>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </adresa>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </zamestnavatel>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <pojistne>"
    FWrite(nHandle, cX +CRLF)
//    cX := "   <uhrnVymerovacichZakladuPbezDS>"+AllTrim(Str(tmprposow->nVymZaklZa,13,0))+"</uhrnVymerovacichZakladuPbezDS>"
//    FWrite(nHandle, cX +CRLF)
//    cX := "   <uhrnPojistnehoPbezDS>"+AllTrim(Str(tmprposow->nUhrnPojZa,13,0))+"</uhrnPojistnehoPbezDS>"
//    FWrite(nHandle, cX +CRLF)
//    cX := "   <uhrnVymerovacichZakladuPsDS>"+AllTrim(Str(tmprposow->nVymZaklDS,13,0))+"</uhrnVymerovacichZakladuPsDS>"
//    FWrite(nHandle, cX +CRLF)
//    cX := "   <uhrnPojistnehoPsDS>"+AllTrim(Str(tmprposow->nUhrnPojDS,13,0))+"</uhrnPojistnehoPsDS>"
//    FWrite(nHandle, cX +CRLF)


    cX := "   <uhrnVymerovacichZakladu>"+AllTrim(Str(tmprposow->nVymZakl,13,0))+"</uhrnVymerovacichZakladu>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <pojistneZamestnance>"+AllTrim(Str(tmprposow->nUhrnPojZa,13,0))+"</pojistneZamestnance>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <pojistneZamestnavatele>"+AllTrim(Str(tmprposow->nUhrnPoj,13,0))+"</pojistneZamestnavatele>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <pojistneCelkem>"+AllTrim(Str(tmprposow->nPojistne,13,0))+"</pojistneCelkem>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </pojistne>"
    FWrite(nHandle, cX +CRLF)


    cX := "   <platebniUdaje>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <bankaCisloUctu>"+AllTrim( LAT_UTF8(tmprposow->cUcet))+"</bankaCisloUctu>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </platebniUdaje>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <pracovnik>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <jmeno>"+AllTrim( LAT_UTF8(tmprposow->cJmenoOsob))+"</jmeno>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <prijmeni>"+AllTrim( LAT_UTF8(tmprposow->cPrijOsob))+"</prijmeni>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <telefon>"+AllTrim( LAT_UTF8(tmprposow->cTelefon))+"</telefon>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <email>"+AllTrim( LAT_UTF8(tmprposow->cEmail))+"</email>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </pracovnik>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <datumVyplneni>"+DTOCuni( tmprposow->dDatZprac)+"</datumVyplneni>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <poznamka>"+LAT_UTF8(tmprposow->mpoznamka)+"</poznamka>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </prehled>"
    FWrite(nHandle, cX +CRLF)

    cX := "</pvpoj>"
    FWrite(nHandle, cX +CRLF)

//    TMp_OMETRa()

//    FWrite( nHandle, Chr( 26), 1)
    FClose( nHandle)

//      cPATHold := CurDrive() + ':\'+CurDir( CurDrive())
//      cexe     := cPATHelco +"\TxtAlpha.exe"
//      cline    := " 3 " +AllTrim( Str( nCOM, 1))

//      CurDir( cPATHelco)
//      RunShell( cline, cexe, .T. )
//      CurDir( cPATHold)



//      clsFileCom( afile_e)

    * picnem to ven
//    zipCom( afile_e, 'DIST000010_'+AllTrim(Str(usrIdDB)))

    endif

//    delFileCom( afile_e)
    drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)


return( nil)


// Export zelená nafta -
function DIST000123( oxbp ) // oxbp = drgDialog
  local tm
  local cx
  local nx, nx1, nx2
  local nit
  local file
  local in_Dir
  local dOD, dDO
  local nphm
  local aSUM := {0,0,0,0,0,0,0,0,0}
  local cBuff
  local cROKzpr, cKeyObdOD, cKeyObdDO


//  MZD_hlasispv_()

//  drgDBMS:open( 'mzdzavit',,,,, 'mzdzavita' )
//    drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('mzddavit',,,,,'mzddavite')
  drgDBMS:open('cnazpol4',,,,,'cnazpol4e')

  cROKzpr   := Str( uctOBDOBI:MZD:NROK,4,0)
  cKeyObdOD := cROKzpr +StrZero(      1, 2)
  cKeyObdDO := cROKzpr +StrZero( uctOBDOBI:MZD:NOBDOBI, 2)

  nIT := 1

  cX := "ZelNafta_" +StrZero(uctOBDOBI:MZD:NROKOBD,6)

  cDATE := StrZero( Day( Date()), 2) +StrZero( Month( Date()), 2)      ;
                 +StrZero( Val( SubStr( Str(Year( Date())),3,2)), 2)
//    cOutFILE_1 := cTmpPath + cX +".xml"

  * výstupní soubor
  in_Dir := retDir(odata_datKom:PathExport)
  file := selFILE( cX,'Xml',in_Dir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

  if .not. Empty(file)
    nHandle := FCreate( file )

    cX  := "<?xml version=" +Chr(34) +"1.0" +Chr(34) +" encoding=" ;
                                    + Chr(34)+ "windows-1250" +Chr(34) + "?>"
    FWrite( nHandle, cX +CRLF)

    cX  := "<zelenanafta struktura=" +Chr(34) +"2018" +Chr(34)                    ;
              +" verze="+Chr(34) +"1" +Chr(34) +" podverze="+Chr(34) +"01" +Chr(34) ;
              +" xmlns=" +Chr(34) +"http://www.aplus.cz/schema/zelphm2018/1"     ;
              +Chr(34) +" xmlns:xsi=" +Chr(34)                                   ;
              +"http://www.w3.org/2001/XMLSchema-instance" +Chr(34)              ;
              +" xsi:schemaLocation=" +Chr(34)+                                  ;
              +"http://www.aplus.cz/schema/zelphm2018 http://www.aplus.cz/schema/zelphm2018.xsd";
              +Chr(34)+">"

//    cX  := "<zelenanafta struktura=" +Chr(34) +"2018" +Chr(34)                    ;
//              +" verze="+Chr(34) +"1" +Chr(34) +" podverze="+Chr(34) +"1" +Chr(34) ;
//              +Chr(34)+">"
    FWrite( nHandle, cX +CRLF)

    FWrite( nHandle, "  <odesilatel>" +CRLF)

    cX := AllTrim( StrZero( SysConfig( "System:nICO" ), 8))
    FWrite( nHandle, "    <ico>" +cX +"</ico>" +CRLF)

    cX := LAT_UTF8( AllTrim( SysConfig( "System:cPodnik" )))
    FWrite( nHandle, "    <firma>" +cX +"</firma>" +CRLF)

    cX := LAT_UTF8( AllTrim( SysConfig( "System:cUlice")))
    FWrite( nHandle, "    <ulicecp>" +cX +"</ulicecp>" +CRLF)

    cX := LAT_UTF8( AllTrim( SysConfig( "System:cSidlo")))
    FWrite( nHandle, "    <misto>" +cX +"</misto>" +CRLF)

    cX := StrTran( SysConfig( "System:cPSC"), " ", "")
    FWrite( nHandle, "    <psc>" +cX +"</psc>" +CRLF)

    cX := LAT_UTF8( AllTrim( SysConfig( "System:cUserNam" )))
    FWrite( nHandle, "    <jmeno>" +cX +"</jmeno>" +CRLF)

    cX := AllTrim( SysConfig( "System:cEmail" ))
    FWrite( nHandle, "    <email>" +cX +"</email>" +CRLF)

    cX := AllTrim( SysConfig( "System:cTelefon" ))
    FWrite( nHandle, "    <telefon>" +cX +"</telefon>" +CRLF)

    FWrite( nHandle, "    <zprava></zprava>" +CRLF)

    FWrite( nHandle, "  </odesilatel>" + CRLF)

//    filtrs := Format( "nrokobd >= %% and nrokobd <= %%", { Val(cKeyObdOd),Val(cKeyObdDo)})
    filtrs := Format( "nrok = %% and nobdobi = %% and nspotrphm <> 0", { uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI })
    mzddavite->( Ads_setAOF(filtrs), dbGotop())

    FWrite( nHandle, "  <dataphm>" +CRLF)

    do while .not.mzddavite->( Eof())
      dod  := mzddavite->ddatumod
      nphm := mzddavite->nspotrphm

      if Empty(mzddavite->ddatumdo)
        ddo := mzddavite->ddatumod
      else
        ddo  := mzddavite->ddatumdo
        nx   := (ddo - dod) + 1
        nphm := mzddavite->nspotrphm/nx
      endif

      do while dod <= ddo
        FWrite( nHandle, "    <radekphm>" +CRLF)

        xValue := AllTrim(Str( mzddavite->sid))
        cBUFF  :="      " + "<id>" +xValue +"</id>"
        FWrite( nHandle, cBuff +CRLF)

        xValue := DtoC( dod)
        cBUFF  :="      " + "<datum>" +xValue +"</datum>"
        FWrite( nHandle, cBuff +CRLF)

        xValue := AllTrim( mzddavite->cnazpol5)
        cBUFF  :="      " + "<stroj>" +xValue +"</stroj>"
        FWrite( nHandle, cBuff +CRLF)

        xValue := AllTrim(Str( mzddavite->ncisprace))
        cBUFF  :="      " + "<cisprace>" +xValue +"</cisprace>"
        FWrite( nHandle, cBuff +CRLF)

        if cnazpol4e->( dbSeek(mzddavite->cnazpol4,,'CNAZPOL1'))
          xValue := AllTrim( cnazpol4e->cKodPozZN)
          cBUFF  :="      " + "<pozemek>" +xValue +"</pozemek>"
          FWrite( nHandle, cBuff +CRLF)
          xValue := AllTrim( cnazpol4e->cnazev)
          cBUFF  :="      " + "<nazevpozemek>" +xValue +"</nazevpozemek>"
          FWrite( nHandle, cBuff +CRLF)
        else
          xValue := ''
          cBUFF  :="      " + "<pozemek>" +xValue +"</pozemek>"
          FWrite( nHandle, cBuff +CRLF)
          xValue := ''
          cBUFF  :="      " + "<nazevpozemek>" +xValue +"</nazevpozemek>"
          FWrite( nHandle, cBuff +CRLF)
        endif

        xValue := AllTrim(Str( nphm))
        cBUFF  :="      " + "<spotrphm>" +xValue +"</spotrphm>"
        FWrite( nHandle, cBuff +CRLF)

        FWrite( nHandle, "    </radekphm>" +CRLF)
        dod++
      enddo
      mzddavite->( dbSkip())
    enddo

    FWrite( nHandle, "  </dataphm>" +CRLF)
    FWrite( nHandle, "</zelenanafta>" +CRLF)

    FClose( nHandle)

    drgMsgBox(drgNLS:msg('XML soubor byl vytvoøen.'), XBPMB_INFORMATION)

  endif

return( nil)


// Export pøílohy k žádosti o nem.dávku na ÈSSZ v XML - NEMPRI
//  zmìna 31.12.2019  - NEMPRI20
function DIST000125( oxbp ) // oxbp = drgDialog
  local tm
  local cx
  local n
  local nit
  local file
  local nBeg, nEnd
  local in_Dir

//  drgDBMS:open( 'mzdzavit',,,,, 'mzdzavita' )
//    drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP

    nIT := 1

  do case
  case !Empty( SysConfig( "System:cZkrNazPod"))
    cX := AllTrim( SysConfig( "System:cZkrNazPod"))
  case !Empty( SysConfig( "System:nICO"))
    cX := AllTrim( StrZero( SysConfig( "System:nICO" ), 8))
  otherwise
    cX := "REGCSSZ"
  endcase

//  cX := "R_" +SubStr( cX, 1, 6)
  cX := "NEMPRI_2020"

  cDATE := StrZero( Day( Date()), 2) +StrZero( Month( Date()), 2)      ;
                 +StrZero( Val( SubStr( Str(Year( Date())),3,2)), 2)
//    cOutFILE_1 := cTmpPath + cX +".xml"
  * výstupní soubor
  in_Dir := retDir(odata_datKom:PathExport)
  file := selFILE( cX,'Xml',in_Dir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})


  if .not. Empty(file)
//    do while .not.

    nHandle := FCreate( file )

    cX  := "<?xml version=" +Chr(34) +"1.0" +Chr(34) +" encoding=" ;
              + Chr(34)+ "windows-1250" +Chr(34) +" standalone="   ;
                +Chr(34) +"yes" +Chr(34) +"?>"
//              + Chr(34)+ "UTF-8" +Chr(34) + "?>"
    FWrite(nHandle, cX +CRLF)

    cX  := "<NEMPRI xmlns="+ Chr(34)+"http://schemas.cssz.cz/nem/NEMPRI20"  ;
              + Chr(34) + " version=" + Chr(34) + "2020.0"                  ;
               + Chr(34) + " partialAccept=" + Chr(34) +"A"+ Chr(34) + ">"
    FWrite(nHandle, cX +CRLF)

    cX  := "<VENDOR productName="+ Chr(34) +LAT_UTF8( "Asystem++")           ;
              + Chr(34) + " productVersion=" + Chr(34) + verzeAsys[3,2]     ;
               + Chr(34) + "></VENDOR>"
    FWrite(nHandle, cX +CRLF)

    cX  := "<SENDER EmailNotifikace="+ Chr(34)+ AllTrim(tmprinemw->cEmailNotif)      ;
              + Chr(34) + " ISDSreport=" + Chr(34) + "3" +Chr(34) + "></SENDER>"
    FWrite(nHandle, cX +CRLF)


    cX := "  <datovaVeta poradoveCislo=" + Chr(34)+ AllTrim(Str( nIT,4,0)) + Chr(34) + ">"
    FWrite(nHandle, cX +CRLF)

    cX := "   <dokument>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <zahranicni>"  +AllTrim( LAT_UTF8( if( tmprinemw->lZahranicn, 'A','N')))             ;  // N
                +"</zahranicni>"
    FWrite(nHandle, cX +CRLF)

//    tm := if( .not. Empty( tmprinemw->cCisRozNem), tmprinemw->cCisRozNem, tmprinemw->cCisRozOcr)
    tm := '' // if( .not. Empty( tmprinemw->cCisRozNem), tmprinemw->cCisRozNem, tmprinemw->cCisRozOcr)

    do case
    case .not. Empty( tmprinemw->cCisRozNem)   ;   tm := tmprinemw->cCisRozNem
    case .not. Empty( tmprinemw->cCisRozOcr)   ;   tm := tmprinemw->cCisRozOcr
    case .not. Empty( tmprinemw->cCisRozDlP)   ;   tm := tmprinemw->cCisRozDlP
    endcase

    cX := "     <cisloPotvrzeni>"  + AllTrim( LAT_UTF8( tm))     ;     //B1820786
                + "</cisloPotvrzeni>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <poznamka>"   +AllTrim( LAT_UTF8( tmprinemw->mpoznamka))     ;        // Pøíklad typu "Nemocenské" - fiktivní
                + "</poznamka>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <kodOSSZ>"   +AllTrim( Str( tmprinemw->nKodOkrSoc,3,0))    ;     //772
                +"</kodOSSZ>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <nazevOSSZ>" +AllTrim( LAT_UTF8( tmprinemw->cNazMisSoc))    ;     // Brno
                +"</nazevOSSZ>"
    FWrite(nHandle, cX +CRLF)

    do case
    case .not. Empty( tmprinemw->cCisRozNem)  ;     tm := 'NEM'
    case .not. Empty( tmprinemw->cCisRozOcr)  ;     tm := 'OCR'
    case .not. Empty( tmprinemw->cCisRozDlP)  ;     tm := 'DLO'
    case tmprinemw->lPenPomMat                ;     tm := 'PPM'
    case tmprinemw->lVyrPriTeh                ;     tm := 'VPM'
    case tmprinemw->lOtcovska                 ;     tm := 'DLO'
    endcase

    cX := "     <druhDavky>" +AllTrim( LAT_UTF8( tm))     ;     //NEM
                +"</druhDavky>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </dokument>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <pojistenec>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <jmeno>" +AllTrim( LAT_UTF8( tmprinemw->cJmenoOsob))       ;    // Boleslav
                +"</jmeno>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <prijmeni>" +AllTrim( LAT_UTF8( tmprinemw->cPrijOsob))    ;    //  Prvni
                +"</prijmeni>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <rodneCislo>" +AllTrim( LAT_UTF8( tmprinemw->cRodCisPrN))    ;  // 7403231847
                +"</rodneCislo>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </pojistenec>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <zamestnani>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <VSZamestnavatel>" +AllTrim( LAT_UTF8( tmprinemw->cVarSymSoc))    ;  //   9890108577
                +"</VSZamestnavatel>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <ICZamestnavatel>" +AllTrim( LAT_UTF8( tmprinemw->cIco ))    ;  //  41031709
                +"</ICZamestnavatel>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <nazevZamestnavatel>" +AllTrim( LAT_UTF8( tmprinemw->cNazevZame))    ;  //  Spolehlivýpodnik
                +"</nazevZamestnavatel>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <zamestnanOd>" +DTOCuni( tmprinemw->dDatNast)    ;  //   2001-09-03
                +"</zamestnanOd>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <zamestnanDo>" +DTOCuni( tmprinemw->dDatVyst)    ;  //
                +"</zamestnanDo>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <druhCinnosti>" +AllTrim( LAT_UTF8( tmprinemw->cTypPPVReg))    ;  // 1
                +"</druhCinnosti>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </zamestnani>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <rozhodneObdobi>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <rozhodneObdobiOd>" +DTOCuni( tmprinemw->dRozhObdOd)    ;   //  2009-06-01
                +"</rozhodneObdobiOd>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <rozhodneObdobiDo>" +DTOCuni( tmprinemw->dRozhObdDo)   ;   //  2010-05-31
                 +"</rozhodneObdobiDo>"
    FWrite(nHandle, cX +CRLF)

    if Year( tmprinemw->dRozhObdOd) < Year( tmprinemw->dRozhObdDo)
      nEnd := 12 - Month(tmprinemw->dRozhObdOd) + 1
      nEnd := nEnd + Month( tmprinemw->dRozhObdDo)
    else
      nEnd := Month( tmprinemw->dRozhObdDo) - Month( tmprinemw->dRozhObdOd) +1
    endif

    if nEnd = 1 .and. tmprinemw->nZapPrij01 = 0 .and. tmprinemw->nVylDoba01 = 0

    else
      cX := "     <polozky>"
      FWrite(nHandle, cX +CRLF)

  ///   zde musí být cyklus
      for m := 1 to nEnd
        cKalMeRo := 'cKalMeRo' +StrZero( m,2)
        nZapPrij := 'nZapPrij' +StrZero( m,2)
        nVylDoba := 'nVylDoba' +StrZero( m,2)


        cX := "       <polozka>"
        FWrite(nHandle, cX +CRLF)
        cX := "         <kalendarniMesic>" +AllTrim( LAT_UTF8( Str(Val(Left(tmprinemw->&cKalMeRo,2)))))    ;   //  6
                        +"</kalendarniMesic>"
        FWrite(nHandle, cX +CRLF)
        cX := "         <kalendarniRok>" +AllTrim( LAT_UTF8( Str(Val(SubStr(tmprinemw->&cKalMeRo,4,4)))))    ;   // 2009
                        +"</kalendarniRok>"
        FWrite(nHandle, cX +CRLF)
        cX := "         <zapocitatelnyPrijem>"  +AllTrim( Str( tmprinemw->&nZapPrij,10,0))    ;   // 22357
                        +"</zapocitatelnyPrijem>"
        FWrite(nHandle, cX +CRLF)
  //      cX := "         <vylouceneDny>"  +if( Empty( tmprinemw->&nVylDoba),'', AllTrim( Str( tmprinemw->&nVylDoba,10,0)))       ;   // 0
        cX := "         <vylouceneDny>"  + AllTrim( Str( tmprinemw->&nVylDoba,10,0))       ;   // 0
                        +"</vylouceneDny>"
        FWrite(nHandle, cX +CRLF)
        cX := "       </polozka>"
        FWrite(nHandle, cX +CRLF)
      next

      cX := "     </polozky>"
      FWrite(nHandle, cX +CRLF)
    endif

    cX := "     <zapocitatelnyPrijemCelkem>"  +if( tmprinemw->nZapPrijCe = 0,'0', AllTrim( Str( tmprinemw->nZapPrijCe,10,0)) )       ;   //  285553
                +"</zapocitatelnyPrijemCelkem>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <vylouceneDnyCelkem>"  + if( tmprinemw->nVylDobaCe = 0,'0', AllTrim( Str( tmprinemw->nVylDobaCe,10,0)) )             ;   //0
                +"</vylouceneDnyCelkem>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <pravdepodobnaVysePrijmu>" + if( tmprinemw->nPravdPrij = 0,'', AllTrim( Str( tmprinemw->nPravdPrij,10,0)) )        ;
                +"</pravdepodobnaVysePrijmu>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </rozhodneObdobi>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <potvrzeniZamestnavatele>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <pocetOdpracovanychHodin>"  +if( tmprinemw->nOdpHodNem = 0,'', AllTrim( Str( tmprinemw->nOdpHodNem,5,2))  )        ;
                +"</pocetOdpracovanychHodin>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <pracovniDoba>"  +if( tmprinemw->nDelkSmDeN = 0,'', AllTrim( Str( tmprinemw->nDelkSmDeN,5,2)) )                  ;
                +"</pracovniDoba>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </potvrzeniZamestnavatele>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <prilohaStrana2>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <pracoval>"  +AllTrim( LAT_UTF8( if( tmprinemw->lPracNem, 'A','N')))             ;  // N
                +"</pracoval>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <prijemMalyRozsah>"  +if( tmprinemw->nZaMaRoPri = 0,'', AllTrim( Str( tmprinemw->nZaMaRoPri,10,0)) )                   ;  // 0
                +"</prijemMalyRozsah>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <pobiraDuchod>"  +AllTrim( LAT_UTF8( if( tmprinemw->lDuchod, 'A','N')))                    ;  // N
                +"</pobiraDuchod>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <druhDuchodu>"   +if( Empty( tmprinemw->cTypDucReg),'', AllTrim( LAT_UTF8( tmprinemw->cTypDucReg )) ) ;  //
                +"</druhDuchodu>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <jeStudentem>"   +AllTrim( LAT_UTF8( if( tmprinemw-> lStudent, 'A','N')))                    ;  //N
                +"</jeStudentem>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <spadaDoPrazdnin>" +AllTrim( LAT_UTF8( if( tmprinemw-> lObdPrazd, 'A','N')))                    ;  //N
                +"</spadaDoPrazdnin>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <dobaVolnaPrvniZamestnani>"  +AllTrim( LAT_UTF8( if( tmprinemw->lNemVDovol, 'A','N')))           ;  //NN
                +"</dobaVolnaPrvniZamestnani>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <volnoBezNahrady>"  +AllTrim( LAT_UTF8( if( tmprinemw->lNemBezPrij, 'A','N')))           ;  //NN
                +"</volnoBezNahrady>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <volnoBezNahradyOd>"   +if( Empty( tmprinemw->dPrVolNeOd),'', DTOCuni( tmprinemw->dPrVolNeOd)  )                ;  //
                + "</volnoBezNahradyOd>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <volnoBezNahradyDo>"  +if( Empty( tmprinemw->dPrVolNeDo),'', DTOCuni( tmprinemw->dPrVolNeDo)  )                ;  //
                +"</volnoBezNahradyDo>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <nastupujePPM>"   +AllTrim( LAT_UTF8( if( tmprinemw->lPenPoMat4R, 'A','N')))                       ;  // N
                +"</nastupujePPM>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <narozeniDitete>"   +if( Empty( tmprinemw->dNarPredDit),'', DTOCuni( tmprinemw->dNarPredDit)  )                  ;  //
                +"</narozeniDitete>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <neredukovanyDVZPPM>"   +if( tmprinemw->nRedVymZaPM = 0,'', AllTrim( Str( tmprinemw->nRedVymZaPM,10,0))  )                  ;  //
                +"</neredukovanyDVZPPM>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <prevedenaNaJinouPraci>"  +AllTrim( LAT_UTF8( if( tmprinemw->lPreJinZam, 'A','N')))                    ;  //
                +"</prevedenaNaJinouPraci>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <exekuce>"  +AllTrim( LAT_UTF8( if( tmprinemw->lZamExekuce, 'A','N')))                    ;  //
                +"</exekuce>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <insolvence>"  +AllTrim( LAT_UTF8( if( tmprinemw->lZamInsolve, 'A','N')))                    ;  //
                +"</insolvence>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <dalsiSdeleni>"   +if( Empty( tmprinemw->mPoznamka),'', AllTrim( LAT_UTF8( tmprinemw->mPoznamka))  )                  ;  //
                +"</dalsiSdeleni>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <kontaktniPracovnik>"   +AllTrim( LAT_UTF8( tmprinemw->cOsoba))                    ;  //První Boleslav
                +"</kontaktniPracovnik>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <kontaktniTelefon>"   +AllTrim( LAT_UTF8( StrTran( tmprinemw->cTelefon,' ', '')))                    ;  //
                +" </kontaktniTelefon>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <kontaktniEmail>"   +AllTrim( LAT_UTF8( StrTran( tmprinemw->cEmail,' ', '')))                    ;  //
                +" </kontaktniEmail>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <podanoV>" +AllTrim( LAT_UTF8( tmprinemw->cMisto))                    ;  //Praha
                +"</podanoV>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <platebniSpojeni>"
    FWrite(nHandle, cX +CRLF)

    do case
    case tmprinemw->lVyplUcCR
      cX := "       <vyplatitUcetCR>"  +AllTrim( LAT_UTF8( if( tmprinemw->lVyplUcCR, 'A','N')))                    ;  //
                    +"</vyplatitUcetCR>"
      FWrite(nHandle, cX +CRLF)
      cX := "         <ucetCR>"
      FWrite(nHandle, cX +CRLF)
      cX := "           <predcisli>"   +AllTrim( LAT_UTF8( tmprinemw->cBankUctPr))                ;  //
                         +"</predcisli>"
      FWrite(nHandle, cX +CRLF)
      cX := "           <ucetCislo>"   +AllTrim( LAT_UTF8( tmprinemw->cBankUctCi))                ;  //
                         +"</ucetCislo>"
      FWrite(nHandle, cX +CRLF)
      cX := "           <specSymbol>"   +AllTrim( LAT_UTF8( tmprinemw->cSpecSymb))                ;  //
                          +"</specSymbol>"
      FWrite(nHandle, cX +CRLF)
      cX := "         </ucetCR>"
      FWrite(nHandle, cX +CRLF)

    case tmprinemw->lVyplUcCIZ
    case tmprinemw->lVyplAdr
    case tmprinemw->lVyplHot
    endcase

    cX := "     </platebniSpojeni>"
    FWrite(nHandle, cX +CRLF)

    cX := "     <prilohy coun=" +Chr(34) +if( tmprinemw->nPocPriloh = 0,'0', AllTrim( Str( tmprinemw->nPocPriloh,2,0)))        ;
                    +Chr(34) +">"
       FWrite(nHandle, cX +CRLF)

    if tmprinemw->nPocPriloh > 0
      for n := 1 to tmprinemw->nPocPriloh
        cX := "     <priloha nazev=" + +Chr(34)+ "" +Chr(34)
        FWrite(nHandle, cX +CRLF)
        cX := "     typ=" + Chr(34)+ ";;" +Chr(34)
        FWrite(nHandle, cX +CRLF)
        cX := "     komentar=" + Chr(34)+ "" +Chr(34)
        FWrite(nHandle, cX +CRLF)
        cX := "     base64data=" + Chr(34)+ "" +"/Cpw0K" +Chr(34) +">"
        FWrite(nHandle, cX +CRLF)
      next
    endif

    cX := "     </prilohy>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </prilohaStrana2>"
    FWrite(nHandle, cX +CRLF)

    cX := " </datovaVeta>"
    FWrite(nHandle, cX +CRLF)

    cX := "</NEMPRI>"
    FWrite(nHandle, cX +CRLF)

//    FWrite(nHandle, cX +CRLF)
//    TMp_OMETRa()

    FClose( nHandle)

  endif

return nil


// Export pøehled o výši pojistné.2016 na ÈSSZ v XML - PVPOJ
function DIST000126( oxbp ) // oxbp = drgDialog
  local tm
  local cx
  local nit
  local file
  local in_Dir

//  drgDBMS:open( 'mzdzavit',,,,, 'mzdzavita' )
//    drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP

  nIT := 1

  do case
  case !Empty( SysConfig( "System:cZkrNazPod"))
    cX := AllTrim( SysConfig( "System:cZkrNazPod"))
  case !Empty( SysConfig( "System:nICO"))
    cX := AllTrim( StrZero( SysConfig( "System:nICO" ), 8))
  otherwise
    cX := "REGCSSZ"
  endcase

  cX := "PVPOJ2020" +SubStr( cX, 1, 6)

  cDATE := StrZero( Day( Date()), 2) +StrZero( Month( Date()), 2)      ;
                 +StrZero( Val( SubStr( Str(Year( Date())),3,2)), 2)
//    cOutFILE_1 := cTmpPath + cX +".xml"
  * výstupní soubor
  in_Dir := retDir(odata_datKom:PathExport)
  file := selFILE( cX,'Xml',in_Dir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})


  if .not. Empty(file)
//    do while .not.

    nHandle := FCreate( file )
    cX  := "<?xml version=" +Chr(34) +"1.0" +Chr(34) +" encoding=" ;
              + Chr(34)+ "windows-1250" +Chr(34) + "?>"
//              + Chr(34)+ "UTF-8" +Chr(34) + "?>"
    FWrite(nHandle, cX +CRLF)

    cX  := "<pvpoj xmlns="+ Chr(34)+"http://schemas.cssz.cz/POJ/PVPOJ2020" +Chr(34) + ">"
    FWrite(nHandle, cX +CRLF)

    cX  := "<VENDOR productName="+ Chr(34)+"FormApps Server" +Chr(34) +" productVersion=" +Chr(34)+"1.4.0"+Chr(34)+ "/>"
    FWrite(nHandle, cX +CRLF)
    cX  := "<SENDER EmailNotifikace="+ Chr(34)+"jmeno.prijmeni@domena.cz" +Chr(34) +" ISDSreport=" +Chr(34)+"XML+HTML"+Chr(34)+ "/>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <prehled typPrehledu="+fVAR(AllTrim(LAT_UTF8("N")))+" verze=" + Chr(34)+ "2016.0" + Chr(34)+ ">"
    FWrite(nHandle, cX +CRLF)

    cX := "   <okres>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <kodOSSZ>"+AllTrim(Str(tmprposow->nKodOkrSoc,3,0))+"</kodOSSZ>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <nazevOSSZ>"+AllTrim( LAT_UTF8(tmprposow->cNazMisSoc))+"</nazevOSSZ>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </okres>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <obdobi>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <mesic>"+AllTrim( StrZero(tmprposow->nobdobi,2))+"</mesic>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <rok>"+AllTrim( StrZero(tmprposow->nrok,4))+"</rok>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </obdobi>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <zamestnavatel>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <vs>"+AllTrim( LAT_UTF8(tmprposow->cVarSymSoc))+"</vs>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <IC>"+AllTrim( LAT_UTF8(tmprposow->cIco))+"</IC>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <nazev>"+AllTrim( LAT_UTF8(tmprposow->cNazevZame))+"</nazev>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <adresa>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <ulice>"+AllTrim( LAT_UTF8(tmprposow->cUlice))+"</ulice>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <cisloDomu>"+AllTrim( LAT_UTF8(tmprposow->cCisPopis))+"</cisloDomu>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <obec>"+AllTrim( LAT_UTF8(tmprposow->cMisto))+"</obec>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <PSC>"+AllTrim( LAT_UTF8(tmprposow->cPsc))+"</PSC>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <stat>"+AllTrim( LAT_UTF8(tmprposow->cZkratStat))+"</stat>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </adresa>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </zamestnavatel>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <pojistne>"
    FWrite(nHandle, cX +CRLF)
//    cX := "   <uhrnVymerovacichZakladuPbezDS>"+AllTrim(Str(tmprposow->nVymZaklZa,13,0))+"</uhrnVymerovacichZakladuPbezDS>"
//    FWrite(nHandle, cX +CRLF)
//    cX := "   <uhrnPojistnehoPbezDS>"+AllTrim(Str(tmprposow->nUhrnPojZa,13,0))+"</uhrnPojistnehoPbezDS>"
//    FWrite(nHandle, cX +CRLF)
//    cX := "   <uhrnVymerovacichZakladuPsDS>"+AllTrim(Str(tmprposow->nVymZaklDS,13,0))+"</uhrnVymerovacichZakladuPsDS>"
//    FWrite(nHandle, cX +CRLF)
//    cX := "   <uhrnPojistnehoPsDS>"+AllTrim(Str(tmprposow->nUhrnPojDS,13,0))+"</uhrnPojistnehoPsDS>"
//    FWrite(nHandle, cX +CRLF)


    cX := "   <uhrnVymerovacichZakladu>"+AllTrim(Str(tmprposow->nVymZaklZa,13,0))+"</uhrnVymerovacichZakladu>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <pojistneZamestnance>"+AllTrim(Str(tmprposow->nUhrnPojZa,13,0))+"</pojistneZamestnance>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <uplatneniSnizeniVymerovacihoZakladu>"+AllTrim( LAT_UTF8(if(tmprposow->nSnizVymZa=1,'A','N')))+"</uplatneniSnizeniVymerovacihoZakladu>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <snizenyVymerovaciZakladZamestnavatele>"+AllTrim(Str(tmprposow->nVymZakl,13,0))+"</snizenyVymerovaciZakladZamestnavatele>"
    FWrite(nHandle, cX +CRLF)


    cX := "   <pojistneZamestnavatele>"+AllTrim(Str(tmprposow->nUhrnPoj,13,0))+"</pojistneZamestnavatele>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <pojistneCelkem>"+AllTrim(Str(tmprposow->nPojistne,13,0))+"</pojistneCelkem>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </pojistne>"
    FWrite(nHandle, cX +CRLF)


    cX := "   <platebniUdaje>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <bankaCisloUctu>"+AllTrim( LAT_UTF8(tmprposow->cUcet))+"</bankaCisloUctu>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </platebniUdaje>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <pracovnik>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <jmeno>"+AllTrim( LAT_UTF8(tmprposow->cJmenoOsob))+"</jmeno>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <prijmeni>"+AllTrim( LAT_UTF8(tmprposow->cPrijOsob))+"</prijmeni>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <telefon>"+AllTrim( LAT_UTF8(tmprposow->cTelefon))+"</telefon>"
    FWrite(nHandle, cX +CRLF)
    cX := "   <email>"+AllTrim( LAT_UTF8(tmprposow->cEmail))+"</email>"
    FWrite(nHandle, cX +CRLF)

    cX := "   </pracovnik>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <datumVyplneni>"+DTOCuni( tmprposow->dDatZprac)+"</datumVyplneni>"
    FWrite(nHandle, cX +CRLF)

    cX := "   <poznamka>"+LAT_UTF8(tmprposow->mpoznamka)+"</poznamka>"
    FWrite(nHandle, cX +CRLF)
    cX := "   </prehled>"
    FWrite(nHandle, cX +CRLF)

    cX := "</pvpoj>"
    FWrite(nHandle, cX +CRLF)

//    TMp_OMETRa()

//    FWrite( nHandle, Chr( 26), 1)
    FClose( nHandle)

//      cPATHold := CurDrive() + ':\'+CurDir( CurDrive())
//      cexe     := cPATHelco +"\TxtAlpha.exe"
//      cline    := " 3 " +AllTrim( Str( nCOM, 1))

//      CurDir( cPATHelco)
//      RunShell( cline, cexe, .T. )
//      CurDir( cPATHold)



//      clsFileCom( afile_e)

    * picnem to ven
//    zipCom( afile_e, 'DIST000010_'+AllTrim(Str(usrIdDB)))

    endif

//    delFileCom( afile_e)
    drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)


return( nil)
