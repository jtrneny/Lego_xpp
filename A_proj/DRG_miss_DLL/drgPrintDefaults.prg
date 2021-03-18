//////////////////////////////////////////////////////////////////////
//
//  drgPrint.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//        Implementation of text drgPrint classes.
//        This source covers these printer types:
//        - EPSONFX
//        - EPSONLQ
//        - HPPCL
//        - HTML
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "drg.ch"

CLASS drgPrint_EPSONFX FROM drgPrint
EXPORTED:
  METHOD  init
  METHOD  create
*  METHOD  destroy

ENDCLASS

*********************************************************************
* Initialization part of drgPrint_FX.
*********************************************************************
METHOD drgPrint_EPSONFX:init(prHdrFile, prPageLen, prLastLine)
  ::type := 'EPSONFX'
  ::prReset    := ESC + CHR(64)
  ::prFormLen  := ESC + 'C'

  ::prCPI10    := CHR(18) + ESC + 'P'
  ::prCPI12    := CHR(18) + ESC + 'M'
  ::prCPI15    := CHR(18) + ESC + 'g'
  ::prCPI17    := CHR(15)
  ::prCPI20    := CHR(15)
  ::prNextLine := CHR(13) + CHR(10)
  ::prFormFeed := CHR(12)

  ::prExp_ON   := ESC + 'W' + CHR(1)
  ::prExp_OFF  := ESC + 'W' + CHR(0)
  ::prExt_ON   := ESC + 'w' + CHR(1)
  ::prExt_OFF  := ESC + 'w' + CHR(0)
  ::prCPI5     := ::prExt_ON
  ::prCond_ON  := CHR(15)
  ::prCond_OFF := CHR(18)

  ::prBold_ON  := ESC + 'E'
  ::prBold_OFF := ESC + 'F'
  ::prItal_ON  := ESC + '4'
  ::prItal_OFF := ESC + '5'

  ::prULin_ON  := ESC + '-' + CHR(1)
  ::prULin_OFF := ESC + '-' + CHR(0)
  ::prLQ_ON    := ESC + 'x' + CHR(1)
  ::prLQ_OFF   := ESC + 'x' + CHR(0)

  ::prPrefix   := ''
********************************************************
  ::drgPrint:init(prHdrFile, prPageLen, prLastLine)

RETURN self

*********************************************************************
* Create print object.
*********************************************************************
METHOD drgPrint_EPSONFX:create()
  ::drgPrint:create()
  ::write(::prFormLen + CHR(::prPageLen) )
RETURN self

*********************************************************************
*
*  Implementation of drgPrint class for EPSON FX type of printers.
*
********************************************************************
CLASS drgPrint_EPSONLQ FROM drgPrint_EPSONFX
EXPORTED:
  METHOD  init
*  METHOD  create
*  METHOD  destroy

ENDCLASS

*********************************************************************
* Initialization part of drgPrint_FX.
*********************************************************************
METHOD drgPrint_EPSONLQ:init(prHdrFile, prPageLen, prLastLine)
  ::drgPrint_EPSONFX:init(prHdrFile, prPageLen, prLastLine)
  ::prCPI20    := ::prCPI12 + ::prCPI17
  ::type := 'EPSONLQ'
RETURN self

*********************************************************************
*
*
* Implementation of drgPrint class for HP PCL printer language.
*
*
*********************************************************************
CLASS drgPrint_HPPCL FROM drgPrint
EXPORTED:
  METHOD  init
*  METHOD  destroy

ENDCLASS

*********************************************************************
* Initialization part of drgPrint_HPPCL.
*********************************************************************
METHOD drgPrint_HPPCL:init(prHdrFile, prPageLen, prLastLine)
LOCAL Tmp
  Tmp:=ESC+'&k'

  ::type := 'HPPCL'
  ::prReset    := ESC+CHR(69)+ESC+'(s1Q'+ESC+'&l6D'+ESC+'&l0L' // +ESC+'(17U' CP852
  ::prFormLen  := ''

  ::prCPI10    := Tmp+'0S'
  ::prCPI12    := Tmp+'4S'
  ::prCPI17    := Tmp+'2S'
  ::prCPI15    := ::prCPI17
  ::prCPI20    := ::prCPI17
  ::prNextLine := CHR(13) + CHR(10)
  ::prFormFeed := CHR(12)

  ::prExp_ON   := Tmp+'24S'
  ::prExp_OFF  := ::prCPI10
  ::prExt_ON   := ''
  ::prExt_OFF  := ''
  ::prCPI5     := ::prExt_ON
  ::prCond_ON  := ::prCPI17
  ::prCond_OFF := ::prCPI10

  ::prBold_ON  := Tmp+'3B'
  ::prBold_OFF := Tmp+'0B'
  ::prItal_ON  := Tmp+'1S'
  ::prItal_OFF := Tmp+'0S'

  ::prULin_ON  := ESC+'&d0D'
  ::prULin_OFF := ESC+'&d@'
  ::prLQ_ON    := Tmp+'2Q'
  ::prLQ_OFF   := Tmp+'1Q'

  ::prPrefix   := ''
********************************************************
  ::drgPrint:init(prHdrFile, prPageLen, prLastLine)

RETURN self

*********************************************************************
*
*
* Implementation of drgPrint class for HP PCL printer language.
*
*
*********************************************************************
CLASS drgPrint_TAB FROM drgPrint
EXPORTED:
  METHOD  init
*  METHOD  create
*  METHOD  convert
  METHOD  destroy

ENDCLASS

*********************************************************************
* Initialization part of drgPrint_FX.
*********************************************************************
METHOD drgPrint_TAB:init(prHdrFile, prPageLen, prLastLine)
  ::type := 'TAB'
  ::prReset    :=  ;
  ::prFormLen  :=  ;
  ::prCPI10    :=  ;
  ::prCPI12    :=  ;
  ::prCPI15    :=  ;
  ::prCPI17    :=  ;
  ::prCPI20    :=  ;
  ::prFormFeed :=  ;
  ::prExp_ON   :=  ;
  ::prExp_OFF  :=  ;
  ::prExt_ON   :=  ;
  ::prExt_OFF  :=  ;
  ::prCPI5     :=  ;
  ::prCond_ON  :=  ;
  ::prCond_OFF :=  ;
  ::prBold_ON  :=  ;
  ::prBold_OFF :=  ;
  ::prItal_ON  :=  ;
  ::prItal_OFF :=  ;
  ::prULin_ON  :=  ;
  ::prULin_OFF :=  ;
  ::prLQ_ON    :=  ;
  ::prLQ_OFF   :=  ;
  ::prPrefix   := ''
  ::prNextLine := CRLF
********************************************************
  ::drgPrint:init(prHdrFile, prPageLen, prLastLine)
  ::prOutFile := drgINI:dir_WORK + 'prOut.TXT'

  ::prDelimited := .T.

RETURN self

*********************************************************************
* Clean up
*********************************************************************
METHOD drgPrint_TAB:destroy()
  ::drgPrint:destroy()
  drgMsgBox(drgNLS:msg('Output file saved as &.', ::prOutFile ) )
RETURN self

*********************************************************************
*
*
* Implementation of drgPrint class for HP PCL printer language.
*
*
*********************************************************************
CLASS drgPrint_HTML FROM drgPrint
EXPORTED:
  METHOD  init
  METHOD  destroy

ENDCLASS

*********************************************************************
* Initialization part of drgPrint_FX.
*********************************************************************
METHOD drgPrint_HTML:init(prHdrFile, prPageLen, prLastLine)
LOCAL aTag := '</FONT>'

  ::type := 'HTML'
  ::prReset  :=  '<html> <head>'                         +CRLF+ ;
                 '<meta http-equiv="Content-Type"'       +CRLF+ ;
                 'content="text/html;">'                 +CRLF+ ;
                 '<meta name="GENERATOR" content="DRG">' +CRLF+ ;
                 '<title>Printout preview</title>'       +CRLF+ ;
                 '<basefont face="Lucida Console" monospace>' +CRLF+ ;
                 '<STYLE TYPE="text/css">'  +CRLF+ ;
                 '<!--'                     +CRLF+ ;
                 '  .cpi5  {font: 18pt}'    +CRLF+ ;
                 '  .cpi10 {font: 12pt}'    +CRLF+ ;
                 '  .cpi12 {font: 10pt}'    +CRLF+ ;
                 '  .cpi15 {font: 8pt}'     +CRLF+ ;
                 '  .cpi17 {font: 7pt}'     +CRLF+ ;
                 '  .cpi20 {font: 6pt}'     +CRLF+ ;
                 '-->'                      +CRLF+ ;
                 '</STYLE>'                 +CRLF+ ;
                 '</head> <body bgcolor="#F0FFFF"> <PRE>'+CRLF

  ::prFormLen  := ''

  ::prCPI10    := aTag + '<FONT class=cpi10>'
  ::prCPI12    := aTag + '<FONT class=cpi12>'
  ::prCPI15    := aTag + '<FONT class=cpi15>'
  ::prCPI17    := aTag + '<FONT class=cpi17>'
  ::prCPI20    := aTag + '<FONT class=cpi20>'
  ::prNextLine := CRLF
*  ::prFormFeed := '<BR><HR>'
  ::prFormFeed := '<div style="page-break-after:always"></div>'
  ::prExp_ON   := aTag + '<FONT class=cpi5>'
  ::prExp_OFF  := ::prCPI10
  ::prExt_ON   := ''
  ::prExt_OFF  := ''
  ::prCPI5     := ''
  ::prCond_ON  := ::prCPI17
  ::prCond_OFF := ::prCPI10

  ::prBold_ON  := '<B>'
  ::prBold_OFF := '</B>'
  ::prItal_ON  := ''
  ::prItal_OFF := ''

  ::prULin_ON  := ''
  ::prULin_OFF := ''
  ::prLQ_ON    := ''
  ::prLQ_OFF   := ''

  ::prPrefix   := ''
********************************************************
  ::drgPrint:init(prHdrFile, prPageLen, prLastLine)
  ::prOutFile := 'prOut.HTM'

RETURN self

*********************************************************************
* Clean up
*********************************************************************
METHOD drgPrint_HTML:destroy()
  ::write('</PRE> </BODY> </HTML>')
  RunShell( "/C START EXPLORER.EXE " + ::prOutFile )
  ::drgPrint:destroy()
RETURN self


