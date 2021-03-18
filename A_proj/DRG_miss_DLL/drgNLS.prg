//////////////////////////////////////////////////////////////////////
//
//  drgNLS.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgNLS class menages menages country specific messages that are to be \
//       processed within project.
//
//   Remarks:
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "nls.ch"

CLASS drgNLS
  EXPORTED:
    VAR     yesNO           // array holding custom application messages in current language

    VAR     arCPdata
    VAR     arCPapp
    VAR     arCPprint
    VAR     arTAB

    METHOD  init            // object initialization
    METHOD  destroy         // release all resources used by this object
    METHOD  readMsgFile     // reads message file
    METHOD  msg             // concerts drg message to standard message

    METHOD  setPrinterCP    // set data for printer codepage
    METHOD  prConvert       // converts printer output stream
    METHOD  dataConvert     // converts data

 HIDDEN:
    VAR     hasMsg
    VAR     msgOrg          // holds standard DRG application msgs in ENGLISH
    VAR     msgLoc          // hold standard DRG application msgs in current lang.
    METHOD  getHash         // returns hash code for message

ENDCLASS

***************************************************************************
* Initialize drgNLS object.
***************************************************************************
METHOD drgNLS:init()
  ::yesNo := ARRAY(2)
* Under Win/NT this doesn't work OK.
  IF drgINI:nlsDRGloc = 'SI'
    ::yesNo:={'D','N'}
  ELSE
    ::yesNo[1] := SetLocale( NLS_SYES )
    ::yesNo[2] := SetLocale( NLS_SNO )
  ENDIF
  ::arCPdata := {}
  ::arCPapp  := {}
  ::arCPprint:= {}
  ::msgLoc := drgArray():new(2000)
  ::msgOrg := drgArray():new(2000)
  ::hasMsg := .F.
  ::arTAB  := {}

RETURN self

***************************************************************************
* Reads message file
***************************************************************************
METHOD drgNLS:readMsgFile(cFileName, lDRGMsg)
LOCAL F, st, fName, nRsrc
LOCAL fNameOrg, fNameLoc, n
LOCAL msg, msgID, hash
  DEFAULT lDRGMsg TO .F.
* Original DRG messages
  fNameOrg := drgINI:dir_RSRC + cFileName + '.' + IIF(lDRGMsg, drgINI:nlsDRGorg, drgINI:nlsAPPorg )
  WHILE ( st := _drgGetSection(@F, @fNameOrg, @nRsrc) ) != NIL
    st    := ALLTRIM(st)
    msgID := LEFT(st, 7)
    msg   := SUBSTR(st, 9, LEN(st) )
    hash  := ::getHash(msg)
    ::msgOrg:add(msgID, hash)         // original messages are sorted by hash
  ENDDO
  ::msgOrg:reSort()

* Localized DRG messages
  nRsrc := NIL                       // must be set
  fNameLoc := drgINI:dir_RSRC + cFileName + '.' + IIF(lDRGMsg, drgINI:nlsDRGloc, drgINI:nlsAPPloc )
  WHILE ( st := _drgGetSection(@F, @fNameLoc, @nRsrc) ) != NIL
    st    := ALLTRIM(st)
    msgID := LEFT(st, 7)
    msg   := SUBSTR(st, 9, LEN(st) )
    ::msgLoc:add(msg, msgID)
  ENDDO
  ::msgLoc:reSort()
  ::hasMsg := ::msgLoc:size() > 0
RETURN self

***************************************************************************
***************************************************************************
METHOD drgNLS:getHash(st)
LOCAL hash := 0, x := 0
  WHILE ++x <= LEN(st) .AND. x < 40
    hash += ASC(st[x])*x
  ENDDO
RETURN ALLTRIM( STR(hash) )

***********************************************************************
* Returns standard DRG message
***********************************************************************
METHOD drgNLS:msg(msg)
LOCAL msgID, start, x, i, cMsg, cParm
  IF EMPTY(msg)
    RETURN msg
  ENDIF
* Search in DRG original messages with hash
  IF ::hasMSG
    IF (msgID := ::msgOrg:getByKey(::getHash(msg)) ) != NIL
* Search in localized messages by msgID
      IF (cMsg := ::msgLoc:getByKey(msgID) ) != NIL
        msg := cMsg
      ENDIF
    ENDIF
  ENDIF
* Replace parameters
  start := i := 1
  WHILE (x := AT('&', msg, start) ) > 0
* Somebody migh want to have & too. This can be done by applaying && to message
    IF msg[x+1] = '&'
      msg := STUFF(msg, x, 1,'')
      start := x + 1
* Parameters are counted
    ELSEIF ISDIGIT( msg[x+1] )
      i := VAL( msg[x+1] )
      cParm := ALLTRIM( drg2String(PVALUE(i) ) )
      msg := STUFF(msg, x, 2, cParm)
      start := x
    ELSE
      i++
      cParm := ALLTRIM( drg2String(PVALUE(i) ) )
      msg := STUFF(msg, x, 1, cParm)
      start := x
    ENDIF
  ENDDO
RETURN msg

***********************************************************************
* Converts string for printer if drgINI:nlsCP_APP != drgINI:nlsCP_PRINT.
*
* Parameters:
* < st > : String : string to convert charachters.
*
* Return: String : converted string
***********************************************************************
METHOD drgNLS:prConvert(st)
  IF drgINI:nlsCP_APP != drgINI:nlsCP_PRINT
    AEVAL( ::arCPprint, {|ch, i| st := STRTRAN(st, ::arCPapp[i], ch) } )
  ENDIF
*
  IF drgINI:nlsCP_DATA != drgINI:nlsCP_PRINT
    AEVAL( ::arCPprint, {|ch, i| st := STRTRAN(st, ::arCPData[i], ch) } )
  ENDIF
RETURN st

***********************************************************************
* Converts string for printer if drgINI:nlsCP_APP != drgINI:nlsCP_PRINT.
*
* Parameters:
* < cCP > : character : Code page to be set for printer. IF pased empty then \
* appliaction codepage will be used
*
* Return: self
***********************************************************************
METHOD drgNLS:setPrinterCP(cCP)
LOCAL n
  drgINI:nlsCP_PRINT := IIF(EMPTY(cCP), drgINI:nlsCP_APP, VAL(ALLTRIM(cCP)) )
  n := ASCAN(::arTAB, {|e| e[1] = drgINI:nlsCP_PRINT } )
  IF n > 0
    ::arCPprint := ::arTAB[n, 2]
  ELSE
    drgINI:nlsCP_PRINT := drgINI:nlsCP_APP
  ENDIF
RETURN self

***********************************************************************
* Converts string if drgINI:nlsCP_DATA != drgINI:nlsCP_APP.
*
* Parameters:
* < st > : String : string to convert charachters.
*
* Return: String : converted string
***********************************************************************
METHOD drgNLS:dataConvert(st, lFromDB)
  IF drgINI:nlsCP_APP != drgINI:nlsCP_DATA
    IF lFromDB
      AEVAL( ::arCPdata, {|ch, i| st := STRTRAN(st, ch, ::arCPapp[i]) } )
    ELSE
      AEVAL( ::arCPdata, {|ch, i| st := STRTRAN(st, ::arCPapp[i], ch) } )
    ENDIF
  ENDIF
RETURN st

***********************************************************************
* Destroys all objects assiciated with drgNLS
***********************************************************************
METHOD drgNLS:destroy()

  ::msgOrg:destroy()
  ::msgLoc:destroy()

  ::msgLoc      := ;
  ::msgOrg      := ;
  ::arCPdata    := ;
  ::arCPapp     := ;
  ::arCPprint   := ;
  ::arTAB       := ;
  ::yesNO       := ;
                   NIL
RETURN

**************************************************************************
* Procedura doloËi vsebino tabel za prevod slovenskih znakov v drgNLS objektu.
**************************************************************************
PROCEDURE drgSetNLSChars_SI()
LOCAL n
  AADD(drgNLS:arTAB, {  0, { 'C', 'S', 'Z', 'c', 's', 'z','c','C','d','D' } } )
* Windows
  AADD(drgNLS:arTAB, {238, { '»', 'ä', 'é', 'Ë', 'ö', 'û','Ê','∆','','–' } } )
  AADD(drgNLS:arTAB, {437, { '^', '[', '@', '~', '{', '`','}',']','|','\' } } )
  AADD(drgNLS:arTAB, {852, { '¨', 'Ê', '¶', 'ü', 'Á', 'ß','Ü','è','–','—' } } )
* Set values of arCPdata based on value of drgINI:nlsCP_DATA
  n := ASCAN(drgNLS:arTAB, {|e| e[1] = drgINI:nlsCP_DATA } )
  drgNLS:arCPdata := drgNLS:arTAB[n, 2]
* Set values of arCPapp based on value of drgINI:nlsCP_APP
  n := ASCAN(drgNLS:arTAB, {|e| e[1] = drgINI:nlsCP_APP } )
  drgNLS:arCPapp := drgNLS:arTAB[n, 2]
* Set default values of arCPprint based on value of drgINI:nlsCP_PRINT
  n := ASCAN(drgNLS:arTAB, {|e| e[1] = drgINI:nlsCP_PRINT } )
  drgNLS:arCPprint := drgNLS:arTAB[n, 2]
RETURN

/*  STARO
***************************************************************************
* Initialize drgNLS object.
***************************************************************************
METHOD drgNLS:init()
  ::readMsgFiles()
  ::hasDRGLocal := ::drgOrg != NIL
  ::hasAPPLocal := ::appOrg != NIL

  ::yesNo := ARRAY(2)
* Under Win/NT this doesn't work OK.
  IF drgINI:nlsDRGloc = 'SI'
    ::yesNo:={'D','N'}
  ELSE
    ::yesNo[1] := SetLocale( NLS_SYES )
    ::yesNo[2] := SetLocale( NLS_SNO )
  ENDIF
  ::arCPdata := {}
  ::arCPapp  := {}

RETURN self

***************************************************************************
* Reads message file
***************************************************************************
METHOD drgNLS:readMsgFiles()
LOCAL F, st, fName, nRsrc
LOCAL fNameOrg, fNameLoc, n
* Original DRG messages
  fNameOrg := drgINI:dir_App + 'drgMSG.'+ drgINI:nlsDRGorg
  fNameLoc := drgINI:dir_App + 'drgMSG.'+ drgINI:nlsDRGloc
  IF !(drgINI:nlsDRGloc == drgINI:nlsDRGorg) .AND. FILE(fNameOrg) .AND. FILE(fNameLoc)
    ::drgOrg := drgArray():new(1000)
    WHILE ( st := _drgGetSection(@F, @fNameOrg, @nRsrc) ) != NIL
      st    := ALLTRIM(st)
      msgID := LEFT(st, 7)
      msg   := SUBSTR(st, 9, LEN(st) )
      hash  := ::getHash(msg)
      ::drgOrg:add(msgID, hash)         // original messages are sorted by hash
    ENDDO
    ::drgOrg:reSort()
* Localized DRG messages
    ::drgLoc := drgArray():new(1000)
    nRsrc := NIL                       // must be set
    WHILE ( st := _drgGetSection(@F, @fNameLoc, @nRsrc) ) != NIL
      st    := ALLTRIM(st)
      msgID := LEFT(st, 7)
      msg   := SUBSTR(st, 9, LEN(st) )
      ::drgLoc:add(msg, msgID)
    ENDDO
    ::drgLoc:reSort()
  ELSE
    ::drgOrg := NIL
    ::drgLoc := NIL
  ENDIF
* Original Application messages. They might not be defined.
  fNameOrg := drgINI:dir_App + 'appMSG.'+ drgINI:nlsAPPorg
  fNameLoc := drgINI:dir_App + 'appMSG.'+ drgINI:nlsAPPloc

  IF !(drgINI:nlsAPPloc == drgINI:nlsAPPorg) .AND. FILE(fNameOrg) .AND. FILE(fNameLoc)
    ::appOrg := drgArray():new(1000)
    WHILE ( st := _drgGetSection(@F, @fName, @nRsrc) ) != NIL
      st    := ALLTRIM(st)
      msgID := LEFT(st, 7)
      msg   := SUBSTR(st, 9, LEN(st) )
      hash  := ::getHash(msg)
      ::appOrg:add(msgID, hash)
    ENDDO
    ::appOrg:reSort()
* Localized app messages
    ::appLoc := drgArray():new(1000)
    fName := drgINI:dir_App + 'appMSG.'+ drgINI:nlsAPPloc
    nRsrc := NIL
    WHILE ( st := _drgGetSection(@F, @fName, @nRsrc) ) != NIL
      st    := ALLTRIM(st)
      msgID := LEFT(st, 7)
      msg   := SUBSTR(st, 9, LEN(st) )
      ::appLoc:add(msg, msgID)
    ENDDO
    ::appLoc:reSort()
  ELSE
    ::appOrg := NIL
    ::appLoc := NIL
  ENDIF
RETURN
*/
