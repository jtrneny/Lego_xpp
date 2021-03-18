//////////////////////////////////////////////////////////////////////
//
//  MENUDEMO.PRG
//
//  Copyright:
//      Alaska Software, (c) 1997-2009. All rights reserved.
//
//  Contents:
//      The example demonstrates how a menu including sub-menus is programmed.
//      A menu system in the window and a context menu is created.
//
//      Two possibilities for branching program flow via a menu are shown.
//      The first one uses a dispatcher procedure while the other uses
//      code blocks executed by a menu object.
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Xbp.ch"

#include "Common.ch"
#include "dll.ch"
#include "drg.ch"
#include "gra.ch"

#include "simpleio.ch"
#include "asxml.ch"
#include "Fileio.ch"

#include "Asystem++.ch"

#pragma Library( "XppUI2.LIB"  )
#pragma Library( "ASINet10.lib")
#pragma Library( "ASXML10.lib")
#pragma Library( "HrfClass.lib" )


   #define BUFFER_SIZE  2^16

static pa

***
Function RetICO_ARES( cICO)
  local  ccnbHost
  local  cString

  local  curl_UTF8, curl_ANSI, pa, x, pa_kurz

  local  nTarget, cBuffer, nBytes

  local  nXMLtag
  local  nXMLdoc, aXMLtag, cXMLatr

  pa := {'','','','','','','','','',''}

  ccnbHost := "http://wwwinfo.mfcr.cz/cgi-bin/ares/darv_bas.cgi?ico=" +cICO
  curl_UTF8 := loadFromUrl(ccnbHost)

  nXMLDoc := XMLDocOpenString( curl_UTF8)

  if (nXMLDoc = 0)
    MsgBox( 'Chybnì zadané IÈO nebo není pøipojení na ARES !!!', 'CHYBA...' )
    QUIT
  endif

  nXMLtag := XMLDocGetRootTag(nXMLDoc)
  SelectTag( nXMLtag)

return( pa)


Function SelectTag(nTag)
  local aMember, n

  if !XMLGetTag(nTag, @aMember)
    return
  endif

//  AADD( aXMLdoc, aMember)

  do case
  case aMember[XMLTAG_NAME] = 'D:OF'      // název firmy
    pa[1] := aMember[XMLTAG_CONTENT]
  case aMember[XMLTAG_NAME] = 'D:NU'      // ulice firmy
    pa[2] := aMember[XMLTAG_CONTENT]
  case aMember[XMLTAG_NAME] = 'D:CD'      // èíslo firmy
    pa[3] := aMember[XMLTAG_CONTENT]
  case aMember[XMLTAG_NAME] = 'D:N'       // obec firmy
    pa[4] := aMember[XMLTAG_CONTENT]
  case aMember[XMLTAG_NAME] = 'D:PSC'     // psè firmy
    pa[5] := aMember[XMLTAG_CONTENT]
  case aMember[XMLTAG_NAME] = 'D:NS'      // stát firmy
    pa[6] := aMember[XMLTAG_CONTENT]
  case aMember[XMLTAG_NAME] = 'D:DIC'     // diè firmy
    pa[7] := aMember[XMLTAG_CONTENT]
  endcase

/*
    ?
    ? "--- Tag (", AllTrim(Str(nTag)), ")---"
    ? "Name   : ", aMember[XMLTAG_NAME]
    ? "Content: ", aMember[XMLTAG_CONTENT]
    ? "Attrib : ", aMember[XMLTAG_ATTRIB]
    ? "Child  : ", aMember[XMLTAG_CHILD]

*/
  if aMember[XMLTAG_CHILD] != NIL
    for n := 1 TO Len(aMember[XMLTAG_CHILD])
      SelectTag(aMember[XMLTAG_CHILD][n])
    next
  endif

Return .t.