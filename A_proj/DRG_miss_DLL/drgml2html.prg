//////////////////////////////////////////////////////////////////////
//
//  drgml2html.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       Convert drgml files into HTM files.
//
//   Remarks:
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "drg.ch"

PROCEDURE DBESYS()
RETURN

PROCEDURE Main(cDir)
LOCAL aD
PUBLIC arStyles, arTOC, cOutFileName
  DEFAULT cDir TO '*.drgml'
  ReadStyles()
  arTOC := {}

  QOUT(cDir)
  aD := DIRECTORY(cDir)
  AEVAL(aD, {|e| enFile(e[1]) } )
  createHHC()
  createHHP()

RETURN

************************************************************************
************************************************************************
PROCEDURE enFile(cFile)
LOCAL FI, FO, cExt, cName
LOCAL c, n, st
  cName := parseFileName(cFile,1)
  cExt  := parseFileName(cFile,2)
  cOutFileName := cName + '.htm'
* Read input file into array
  st := ''
  FI := FOPEN(cFile)
  WHILE FReadLn(FI,@c)
    st += c + ' ' + CRLF
  ENDDO
  FCLOSE(FI)
*
  c := parseIt(st)
*
  FO := FCREATE(cOutFileName)
  FWRITE(FO, c)
  FCLOSE(FO)
RETURN

*******************************************************************
*******************************************************************
FUNCTION parseIt(c)
LOCAL n1 := 0, n2, ar, nLast, n3
LOCAL co := '', cKey, cKey1
LOCAL cTAG, cTOC
  nLen := LEN(c)
  nLast := 1
  WHILE (n1 := AT('<', c, nLast) ) > 0

    co += drgSUBSTR(c, nLast, n1-1)
*    drgDump(drgSUBSTR(c, nLast, n1-1),'n1')
    FOR n2 := n1 + 1 TO nLen
      IF c[n2] = '>'
        EXIT
      ENDIF
*
      IF c[n2] = '<'
        co += drgSUBSTR(c,n1+1,n2-1)
*        drgDump(drgSUBSTR(c, n1+1, n2-1),'n1')
      EXIT; ENDIF
    NEXT
* End TAG marker
    IF c[n2] = '>'
      lEnd := .F.
      cKey1 := drgSUBSTR(c, n1, n2)
      cKey  := LOWER( ALLTRIM(drgSUBSTR(c, n1+1, n2-1) ) )
      IF cKey[1] = '/'
        lEnd := .T.
        cKey := RIGHT(cKey, LEN(cKey) - 1)
      ENDIF
* IF Found in styles array, replace
      IF (ar := arStyles:getByKey(cKey) ) = NIL
        DO CASE
        CASE cKey == 'toc'
          IF !EMPTY( cTAG := ALLTRIM( getTAG('toc', c, @n2) ) )
            cTOCIx  := drgParse(@cTAG,' ')
            AADD(arTOC, {cTOCix, cTAG, cOutFileName} )
          ENDIF
        OTHERWISE
          co += cKey1             // add tag anyway
        ENDCASE
      ELSE
        co += IIF(lEnd, ar[2], ar[1])
      ENDIF
    ENDIF
    nLast := n2 + 1
  ENDDO
RETURN co

*******************************************************************
*******************************************************************
FUNCTION getTAG(cTag, c, nRight)
LOCAL nStart, n1
LOCAL cTag1, cRet
  nStart  := nRight + 1
  n1      := AT('<', c, nStart)
  cTag    := '/' + cTag
  cTag1   := SUBSTR(c, n1+1, LEN(cTag) )
* Not the right tag
  IF cTag1 != cTag
    nRight := n1
    RETURN ''
  ENDIF
*
  cRet   := drgSUBSTR(c, nStart, n1 - 1)
  nRight := AT('>', c, n1)
RETURN cRet

*******************************************************************
*******************************************************************
PROCEDURE readStyles()
LOCAL F, c, st, an, n, x
  arStyles := drgArray():new(100)
  F  := FOPEN('styles.xst')
  st := ''
* Read styles file
  WHILE FREADLN(F, @c)
    st += c + CRLF
  ENDDO
  FCLOSE(F)
* Fill arStyles with styles read
  WHILE (cKey := _parse(@st, @c) ) != NIL
* Text without parenthisis
    IF (x := RAT(' ', cKey) ) > 0
      cKey := RIGHT(cKey, LEN(cKey) - x)
    ENDIF
* CRLF
    IF (x := RAT(CHR(10), cKey) ) > 0
      cKey := RIGHT(cKey, LEN(cKey) - x)
    ENDIF
*
    IF LEFT(cKey,1) = '/'
      n := 2
      cKey := RIGHT(cKey,LEN(cKey)-1)
    ELSE
      n := 1
    ENDIF
*
    IF (an := arStyles:getByKey(cKey) ) = NIL
      an := ARRAY(2)
    ENDIF
    an[n] := c
    arStyles:update(an, cKey)
  ENDDO
/*
  FOR n := 1 TO arStyles:size()
    an := arStyles:getNth(n)
    drgDump(an,arStyles:getKey())
  NEXT
*/
RETURN

***************************************************************************
* Creates prgdoc.HHC file
***************************************************************************
PROCEDURE createHHC()
LOCAL st, F, nLen
LOCAL nN, nL
  nN := ARRAY(4)
  nL := ARRAY(4)
  ASort( arTOC,,, {|aX,aY| aX[1] < aY[1] } )
  nLen := LEN(arTOC)
*
  St := '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">' + CRLF + ;
        '<HTML>' + CRLF + ;
        '<HEAD>' + CRLF + ;
        '<meta name="GENERATOR" content="DRGS&reg; drgDOC 1.0">' + CRLF + ;
        '<!-- Sitemap 1.0 -->' + CRLF + ;
        '</HEAD><BODY>' + CRLF + ;
        '<OBJECT type="text/site properties">' + CRLF + ;
      	'<param name="Window Styles" value="0x800025">' + CRLF + ;
        '</OBJECT><UL>' + CRLF
  n := 0
  nLevel := 1
  lastIX := '0.0.0.0'

  WHILE ++n <= LEN(arTOC)
    cL := lastIX
    cN := arTOC[n,1]
*
    nL[1] := VAL( drgPARSE(@cL,'.') )
    nL[2] := VAL( drgPARSE(@cL,'.') )
    nL[3] := VAL( drgPARSE(@cL,'.') )
    nL[4] := VAL( cl )
*
    nN[1] := VAL( drgPARSE(@cN,'.') )
    nN[2] := VAL( drgPARSE(@cN,'.') )
    nN[3] := VAL( drgPARSE(@cN,'.') )
    nN[4] := VAL( cl )
*
    FOR x := 1 TO 3
      IF nL[x] != nN[x]
        EXIT
      ENDIF
    NEXT
    c :=  SPACE(nLevel) + '<LI><OBJECT type="text/sitemap">' + CRLF + ;
          SPACE(nLevel) + '<param name="Name" value="' + arTOC[n, 2] + '">' + CRLF + ;
          SPACE(nLevel) + '<param name="Local" value="' + arTOC[n, 3] +  '">' + CRLF + ;
          SPACE(nLevel) + '</OBJECT>' + CRLF

      drgDump(x,'x')
      drgDump(nLevel,'nLevel')
      drgDump(arTOC[n,1],'arTOC[n,1]')
      drgDump('','')

* Nulti nivo
    IF x = 4
      st += c + CRLF
    ELSEIF x = nLevel
      st += c  + CRLF
      IF nN[nLevel+1] = 0 .AND. nLevel < 3
        nLevel++
        st += '<UL>' + CRLF
      ENDIF
* Nivo nizje
*    ELSEIF x = nLevel + 1
*      st += c + CRLF
*      nLevel++
    ELSE
      WHILE x < nLevel
        st += '</UL>'
        nLevel--
      ENDDO
      st += c + CRLF
*
      IF nN[nLevel+1] = 0 .AND. nLevel < 3
        nLevel++
        st += '<UL>' + CRLF
      ENDIF
    ENDIF
    lastIX :=arTOC[n,1]
  ENDDO
  st += '</UL></BODY></HTML>' + CRLF

  F := FCREATE('drgDOC.HHC')
  FWRITE(F, st)
  FCLOSE(F)
RETURN

***************************************************************************
* Creates prgdoc.HHP file
*
* \bParameters:b\
* \b< dirList >b\ : String : Data passed as String
***************************************************************************
PROCEDURE createHHP()
LOCAL st, F
  F := FCREATE('drgDOC.HHP')
  st := '[OPTIONS]' + CRLF + ;
        'Compatibility=1.1 or later' + CRLF + ;
        'Compiled file=drgDOC.chm'  + CRLF + ;
        'Contents file=drgDOC.hhc' + CRLF + ;
        'Default topic=Preface.htm' + CRLF + ;
        'Display compile progress=No' + CRLF + ;
        'Index file=drgDOC.hhk' + CRLF + ;  //        Language=0x424 Slovenian
        'Title=Dokumentacija programa' + CRLF + CRLF
  FWRITE(F,st)
  st := '[FILES]' + CRLF
  AEVAL(arTOC, { |ix| st += ix[3] + CRLF } )

  st += CRLF + '[INFOTYPES]' + CRLF
  FWRITE(F,st)
  FCLOSE(F)
RETURN
RETURN

