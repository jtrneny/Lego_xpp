/***********************************
*     PROJECT :SLEpic
*        FILE :SLEPic.prg
*  Programmer :James Loughner and Olaf Teickner
*              jwrl@charter.net   olaf.teickner@t-online.de
*  Created    :03/24/02
*  Version    : 1.3
*
*  Usage:
*        Replace XbpSLE with SLEPic
*        Set Picture ivar with function/mask
*        All else is like working with XbpSle
*
*        Ivars:
*         Type
*          C   oSLE:Picture := cSaypicture
*                 cSayPicture If no Picture string is set defaults to standard XbpSLE behaviour
*                 except does have basic Clipper navigation. ie arrow keys and return
*
*              Supported functions
*              most functions are applied on loss of focus
*              Only one function per picture is currently supported except for @K
*                  Function  Data type  Formatting
*
*              @A         C          Only letters are allowed
*              @B         N          Displays numbers left justified
*              @C         N          Displays CR (Credit) after positive numbers
*              @D         C          Displays character strings in SET DATE format
*              @K         CDLN       Deletes edit buffer when the first key is not
*                                    a cursor key.  If the WindatK ivar is true
*                                    all characters are marked when focus is set,
*                                    and non-navigation keys will erase the current
*                                    value and start edit at the first character
*                                    This overrides the @K function
*                                    When @K is set and WindatK ivar is false the
*                                    cursor is set at the beginning and any non-
*                                    navigation key will erase the current value
*                                    as in Clipper.
*                                    @K can be used with other functions but must be
*                                    first. ie "@K@R 999-999-9999" this has clipper @K
*                                    behavior if WindatK is false and strips format on
*                                    Getdata()return value
*
*              @L<c>      N          Fills numeric values with the character <c>
*                                    from the left
*              @R         C          Inserts unknown formatting characters into the
*                                    display, but does not store in the variable
*              @S<n>      C          This is not supported since it is default SLE
*                                    behaviour
*              @X         N          Displays DB (Debit) behind negative numbers
*              @Z         N          Displays only blank spaces when the value is 0
*              @(         N          Displays negative numbers with leading blank
*                                    spaces in parentheses
*              @)         N          Displays negative numbers without leading blank
*                                    spaces in parentheses
*              @$         N          Places the country specific currency
*                                    character in front of a number
*              @!         C          Converts letter characters to upper case
*                                    Note:applied on dataentry
*
*              Supported Formatting characters for PICTURE masks
*
*              Character  Format
*              A          Only letter characters permitted
*              L          Only T, F, Y or N permitted (for logical values)As of
*                         Ver 0.9 Supports Locale settings
*              N          Only alphanumeric characters permitted
*              X          Any character is permitted
*              Y          Accept 'Y' or 'N' As of Ver 0.9 Supports Locale settings
*              9          Only digits and signs are permitted for numeric values
*              !          Lower case letters are converted to upper case
*              #          Digits, signed numbers and blank spaces are allowed
*              $          Use @$ function instead NOT SUPPORTED
*              ,          Displays comma place
*              .          Displays decimal point
*
*          C   oSLE:DataType := "N/D/C/L" default "C"
*                    Can be used to set/override the underlying datatype
*                    COntrols how the SLE views the data.
*                    Also see SetData() method
*
*          C   oSLE:orgDataType := "N/D/C/L" default "C"
*                    This ivar is set by SetData and defines the data type of
*                    original field or variable setting the value of the SLE.
*                    It controls what data type is returned via GetData() method
*                    Also see SetData()/GetData methods
*
*          B   oSLE:DateValidBlock := bTestDate  note return type D/C/blank
*                    bTestDate is an optional code block used to test the date or display
*                    a date selector etc. return a validated date or datestring
*                    or an empty value. An empty value will force focus back to
*                    date SLE. Executed on loss of focus (ie KillInputFocus event)
*                    Only applied with date types.
*                    Overrides default date sanity check.
*                    Passed cCurrentDate,NIL,Self
*
*          B   oSLE:RangeBlock := bTestRange  note return .T./.F.
*                    bTestRange is a code to test for range or other validation
*                    purposes. Return .T. to continue .F. to return to the SLE
*                    Passed cCurrentvalue,NIL,Self
*
*          L   oSLE:SetOnKillFocus := Set .T. to set orgValue to current on
*                    loss of focus  OrgValue is the value dispalyed with Undo()
*                    method
*
*          L   oSLE:WindatK := .T./.F.  default .F.
*                    If the WindatK ivar is true
*                    all characters are marked when focus is set
*                    and non-navigation keys will erase the current
*                    value and start edit at the first character
*                    This overrides the @K function (see @K function)
*                    Note: the basic difference in @K and Windatk is
*                    the way the SLE displays when recieving input focus.
*                    WindatK displays all charcters hilighted and @K puts
*                    the cursor to the left side.
*
*          L   oSLE:TestDate := .T./.F. default .T.
*                    Do a sanity test on a date value via SLEValidateDate(oSLE)
*                    or :DateValidBlock on loss of focus.
*
*          L   oSLE:HoldFormat := .T./.F. defualt .F.
*                    Hold the format positions on deleteing operations
*                    ex. :Picture := "@!AA-AAA"
*                    If true the - will remain positioned on delete operations
*                    note: does not work with numarics
*                    note: when true del key moves cursor to the right
*                    note: auto set true for date type ie @D or :setdata(dDate)
*
*        METHODS:
*              oSLE:SetData(value)
*                    Value may be type C/D/N/L
*                    :DataType and :orgDataType is set accordingly to the type
*                    of data passed.
*                    :orgValue is set to formatedstring(value)
*
*              oSLE:Getdata() returns data as type :orgDataType, strips formating
*                    if @R function is used
*
*              oSLE:Undo() Sets display to :orgValue
*
*   Fixes and additions:
*     Ver 0.9 - added full @K and WindatK behaviour.
*               fixed problem with masks ending in non-
*               format characters ie "(99999)" now the final charater is displayed on focus
*               loss. note only applies to character types
*               Set Y and L format to respect Locale settings.
*     Ver 1.0 - Added Clipper navigation to default SLE behaviour ie. no picture
*     Ver 1.1 - Fixes for editing of fixed formats, added :::HoldFormat ivar
*     Ver 1.2 - Minor fixes
*     Ver 1.3 - Fix numeric mask with negitives and entry like -0.56
*
*************************************/

#include "Gra.ch"
#include "Xbp.ch"
#include "Common.ch"
#include "Appevent.ch"
#include "Font.ch"
#include "Appbrow.ch"
#include "Dmlb.ch"
#include "dll.ch"
#include "inkey.ch"
#include "Nls.ch"


// Error messages for date format errors.
// You can translate these to your language
#define SLE_BADDATE_ERR1            "Bad date format! Month MM/DD/YY"
#define SLE_BADDATE_ERR2            "Bad date format! Day MM/DD/YY"
#define SLE_BADDATE_ERR3            "Bad date format! Month DD/MM/YY"
#define SLE_BADDATE_ERR4            "Bad date format! Day DD/MM/YY"
#define SLE_BADDATE_ERR5            "Bad date format! Month YYYY/MM/DD"
#define SLE_BADDATE_ERR6            "Bad date format! Month YY/MM/DD"
#define SLE_BADDATE_ERR7            "Bad date format! Day YYYY/MM/DD"
#define SLE_BADDATE_ERR8            "Bad date format! Day YY/MM/DD"
#define SLE_BADDATE_ERR9            "Bad date format! Missing Delimiter."
#define SLE_BADDATE_ERR0            "Bad date format! Unable to parse."

// Remark out next line to use in your code
//#define TEST

#ifdef TEST
PROCEDURE Main()
   LOCAL nEvent, mp1, mp2, oXbp
   LOCAL oDlg,oSLE,oSLE1,oSLE2,oSLE3,oSLE4,oSLE5,oSLE6,oSLE7

   oDlg := XbpDialog():new( AppDesktop(),,{30,50}, {400,450} )
   oDlg:title := "Test"
   oDlg:create()

   oSLE7 := SLEPic():New(oDlg:drawingarea,,{10,250}, {100,20})
//   oSLE2:DataType := "D"
   oSLE7:Picture := "@!"
//   oSLE7:DataType := "N"
   oSLE7:TabStop := .T.
   oSle7:Bufferlength := 10  // test short buffer
//   oSle7:SetonKillFocus := .T.
   oSle7:Create()        // note no picture => standard SLE behaviour
   oSle7:setData("ABC")

   oSLE7 := SLEPic():New(oDlg:drawingarea,,{10,220}, {100,20})
//   oSLE2:DataType := "D"
   oSLE7:Picture := "@D"
   oSLE7:TabStop := .T.
   oSle7:Bufferlength := 10
   oSle7:SetonKillFocus := .T.
   oSle7:Create()

   oSLE6 := SLEPic():New(oDlg:drawingarea,,{10,190}, {100,20})
//   oSLE2:DataType := "D"
   oSLE6:Picture := "@K@R 99 99 99 99 99"
   oSLE6:TabStop := .T.
   oSle6:Bufferlength := 14
   oSle6:WindatK := .F.
   oSle6:HoldFormat := .T.
   oSle6:Create()
   oSle6:setData("0123456789")

   oSLE5 := SLEPic():New(oDlg:drawingarea,,{10,160}, {100,20})
//   oSLE2:DataType := "D"
   oSLE5:Picture := "99:99"
   oSLE5:TabStop := .T.
   oSle5:Bufferlength := 5
   oSle5:Create()
//   oSle5:setData("12:55")

// note numerics must be set as Datatype "N"
   oSLE := SLEPic():New(oDlg:drawingarea,,{10,130}, {100,20})
   oSLE:DataType := "N"
   oSLE:Picture := "@$ 999,999.99"
   oSLE:TabStop := .T.
   oSle:Bufferlength := 11
   oSLE:holdformat := .T.
   oSle:Create()



   oSLE1 := SLEPic():New(oDlg:drawingarea,,{10,100}, {100,20})
   oSLE1:Picture := "@!AA-#AAA"   //"!XX!XXXXXX"
   oSLE1:TabStop := .T.
   oSle1:Bufferlength := 7
   oSle1:holdformat := .T.
   oSle1:Create()


// Dates must be defined as datatype "D" to test there validity on exit
   oSLE2 := SLEPic():New(oDlg:drawingarea,,{10,70}, {100,20})
   oSLE2:DataType := "D"
   oSLE2:Picture := "99/99/99"
   oSLE2:TabStop := .T.
   oSle2:Bufferlength := 10
   oSle2:Create()

   oSLE3 := SLEPic():New(oDlg:drawingarea,,{10,40}, {100,20})
   oSLE3:TabStop := .T.
   oSLE3:Picture:="@R (999) 999-9999"
   oSLE3:HoldFormat:=.T.
   oSLE3:Bufferlength := 14
   oSLE3:SetData("          ")
   oSLE3:WinDatK:=.T.
   oSLE3:Create()


   oSLE4 := SLEPic():New(oDlg:drawingarea,,{160,220}, {100,20})
   oSLE4:Picture := "(999999999)"
   oSLE4:TabStop := .T.
   oSle4:Bufferlength := 11
   oSle4:Create()

   oSLE4 := SLEPic():New(oDlg:drawingarea,,{160,190}, {100,20})
   oSLE4:Picture := "Y"
   oSLE4:TabStop := .T.
   oSle4:Bufferlength := 1
   oSle4:Create()
   oSle4:SetData(.T.)
   nEvent := 0
   DO WHILE nEvent <> xbeP_Close
      nEvent := AppEvent( @mp1, @mp2, @oXbp )
      oXbp:handleEvent( nEvent, mp1, mp2 )
   ENDDO
RETURN

PROCEDURE APPSYS()
RETURN

#endif


CLASS SLEPic FROM XbpSLE
EXPORTED:
   METHOD Init, Create, Keyboard, Chkkey, TestPic,KillInputFocus,SetInputFocus
   METHOD Pasteclipboard, ProcessKey
   VAR Picture,IsatK,DataType,FirstTime,WindatK,TestDate,Pindex1,Pindex2,DateValidBlock
   VAR RangeBlock,SetonKillFocus
   VAR cDecimalPoint
   VAR cThousand
   VAR cDateSeperator
   VAR cCurrency
   VAR cMask
   VAR cFunc
   VAR isAtR
   VAR orgValue
   VAR orgDataType
   VAR changed
   VAR Holdformat
   ASSIGN METHOD setPicture VAR Picture
   ASSIGN METHOD setChanged VAR changed
   ACCESS METHOD isChanged VAR changed
   METHOD setData
   METHOD getData
   METHOD undo
   METHOD transformToOrgDataType
ENDCLASS

METHOD SLEPic:Init(oParent,oOwner,aPos,aSize,aPresParam,lVisible)
   ::XbpSLE:Init(oParent,oOwner,aPos,aSize,aPresParam,lVisible)
   ::Pindex1 := 1
   ::Pindex2 := 2
   ::Picture := ""
   ::IsatK := .F.
   ::DataType := "C"
   ::FirstTime := .T.
   ::WindatK := .T.
   ::isAtR := .F.
   ::TestDate := .T.
   ::cDecimalPoint := SETLOCALE(NLS_SDECIMAL)
   ::cThousand     := SETLOCALE(NLS_STHOUSAND)
   ::cDateSeperator:= SETLOCALE(NLS_SDATE)
   ::cCurrency     := SetLocale(NLS_SCURRENCY)
   ::cMask := ""
   ::cFunc := ""
   ::orgValue := ""
   ::orgDataType := "C"
   ::RangeBlock :=""
   ::SetonKillFocus := .F.
   ::HoldFormat := .F.
RETURN Self

METHOD SLEPic:Create(oParent,oOwner,aPos,aSize,aPresParam,lVisible)
   ::XbpSLE:Create(oParent,oOwner,aPos,aSize,aPresParam,lVisible)
   IF ::orgDataType != ::DataType //JWL 8-3
      ::orgDataType = ::DataType
   ENDIF
RETURN Self

METHOD SLEPic:Pasteclipboard()
LOCAL oClip,aFormats,I,cText,aTmp
   oClip := XbpClipBoard():new():create()
   aTmp := ::QueryMarked()
   ::Setmarked({Min(aTmp[1],aTmp[2]),Min(aTmp[1],aTmp[2])})
   oClip:Open()
   aFormats := oClip:queryFormats()
   IF AScan( aFormats, XBPCLPBRD_TEXT ) > 0
      cText := oClip:getBuffer( XBPCLPBRD_TEXT )
      FOR I = 1 TO Min((Max(aTmp[1],aTmp[2])-Min(aTmp[1],aTmp[2])),LEN(cText))
        ::SLEPIC:Keyboard(ASC(cText[I]))
      NEXT I
      oClip:clear()
      oClip:SetBuffer(cText,XBPCLPBRD_TEXT)
   ENDIF
   Sleep(10)
   oClip:close()
   Sleep(10)
   oClip:destroy()
RETURN .T.

METHOD SLEPic:KillInputfocus()
LOCAL cTemp,dTemp
   ::FirstTime := .T.
   IF ::DataType = "N" .AND. !EMPTY(::Picture)
      cTemp := StrTran(::EditBuffer(),::cThousand,"")
      cTemp := StrTran(cTemp,::cDecimalPoint,".")
      cTemp := StrTran(cTemp,::cCurrency,"")
      cTemp := StrTran(cTemp,"(","")
      cTemp := StrTran(cTemp,")","")
      ::XbpSLE:SetData(Transform(VAL(cTemp),::Picture))
   ENDIF
   IF ::DataType = "D" .AND. ::TestDate
      IF ValType(::DateValidBlock) = "B"
         dTemp := Eval(::DateValidBlock,::EditBuffer(),NIL,Self)
         IF ValType(dTemp) = "D"
            ::XbpSLE:SetData(DTOC(dTemp))
         ELSEIF ValType(dTemp) = "C"
            ::XbpSLE:SetData(dTemp)
         ELSE
            SetAppFocus(Self)
         ENDIF
      ELSE
         IF !SLEValidateDate(Self)
            SetAppFocus(Self)
         ENDIF
      ENDIF
****************** old string*****************************************
//   ELSEIF ::orgDataType # "C"
***********************************************************************
***** My string....
   ELSEIF ::orgDataType # "C" .and. ::orgDataType # "N"
*****
      cTemp := ::transformToOrgDataType()
      ::XbpSLE:SetData(TRANSFORM(cTemp,::Picture))
   ENDIF
   IF ::DataType = "C" .AND. !EMPTY(::cMask) .AND. !::cMask[LEN(::cMask)]$"AXN9#LY!, "
      cTemp := PADR(::EditBuffer(),LEN(::cMask))
      ::XbpSLE:SetData(Stuff(cTemp,LEN(::cMask),1,::cMask[LEN(::cMask)]))
   ENDIF
   IF ::DataType = "C" .AND. !EMPTY(::cMask) .AND. !::cMask[1]$"AXN9#LY!, "
      cTemp := ::EditBuffer()
      IF EMPTY(cTemp)
         cTemp := Space(LEN(::cMask))
      ENDIF
      ::XbpSLE:SetData(Stuff(cTemp,1,1,::cMask[1]))
   ENDIF
   IF ValType(::RangeBlock) = "B"
      IF !Eval(::RangeBlock,,::EditBuffer(),NIL,Self)
         SetAppFocus(Self)
      ENDIF
   ENDIF
   IF ::SetonKillFocus
      ::setChanged()
   ENDIF
RETURN Self

METHOD SLEPic:SetInputfocus()
LOCAL cTemp
   IF ::DataType = "N" .AND. !EMPTY(::Picture)
      cTemp := StrTran(::EditBuffer(),::cCurrency,"")
      cTemp := StrTran(cTemp,"(","")
      cTemp := StrTran(cTemp,")","")
      ::XbpSLE:SetData(IIF(::isAtR,TRANSFORM(VAL(cTemp),::Picture),cTemp))
   ENDIF
   IF ::DataType != "N" .AND. EMPTY(::EditBuffer()).AND. !EMPTY(::Picture) .AND. !::isAtR
      cTemp := StrTran(::cMask,"A"," ")
      cTemp := StrTran(cTemp,"X"," ")
      cTemp := StrTran(cTemp,"N"," ")
      cTemp := StrTran(cTemp,"9"," ")
      cTemp := StrTran(cTemp,"#"," ")
      cTemp := StrTran(cTemp,"L"," ")
      cTemp := StrTran(cTemp,"!"," ")
      cTemp := StrTran(cTemp,","," ")
      IF ::DataType == "D"
          cTemp := StrTran(cTemp,"/",::cDateSeperator)
      ENDIF
      ::XbpSLE:SetData(IIF(::isAtR,TRANSFORM(cTemp,::Picture),cTemp))
   ELSEIF ::DataType != "N" .AND. ::isAtR
ALTD()
      cTemp := ::transformToOrgDataType()
      ::XbpSLE:SetData(TRANSFORM(cTemp,::Picture))
   ENDIF
   IF ::WindatK
      ::SetMarked({1,LEN(::EditBuffer())+1})
   ELSE
      ::SetMarked({1,1})
   ENDIF
RETURN Self

METHOD SLEPic:setPicture(inPicture)
LOCAL I,lGotK:=.F.,lGotat:=.F.,cTemp:=""
   ::isAtR := .F.
   IF "@K"$inPicture
      ::IsatK := .T.
      FOR I = 1 TO LEN(inPicture)
         IF IF(lGotat,.T.,inPicture[I]!="@") .AND. IF(lGotK,.T.,inPicture[I]!="K")
            ctemp += inPicture[I]
         ENDIF
         IF inPicture[I]=="K"
            lGotK := .T.
         ENDIF
         IF inPicture[I]=="@"
            lGotat := .T.
         ENDIF
      NEXT I
      inPicture := LTRIM(ctemp)
   ELSE
      ::IsatK := .F.
   ENDIF
   ::Picture := inPicture
   IF "@"$::Picture
      ::cMask := LTRIM(RIGHT(::Picture,LEN(::Picture)-AT("@",::Picture)-1))
      ::cFunc := TRIM(LEFT(::Picture,AT("@",::Picture)+1))
      DO CASE
        CASE ::cFunc == "@D" .AND. EMPTY(::cMask)
          ::DataType := "D"
          ::HoldFormat := .T.  //jwl force holdformat for datetypes 8/3
          DO CASE
            CASE Setlocale(NLS_IDATE) $ "01"    // 0-MM/DD/YY 1-DD/MM/YY
               ::cMask := "99/99/"+IIF(Setlocale(NLS_ICENTURY)=="1","9999","99")
               ::cFunc := ""
            CASE Setlocale(NLS_IDATE)=="2"    // YY/MM/DD
               ::cMask := IIF(Setlocale(NLS_ICENTURY)=="1","9999","99")+"/99/99"
               ::cFunc := ""
          ENDCASE
        CASE ::cFunc == "@R"
          ::isAtR := .T.
      ENDCASE
   ELSE
      ::cMask := ::Picture
      ::cFunc := ""
      IF ::DataType = "D"     //jwl force holdformat for datetypes 8/3
         ::HoldFormat := .T.
      ENDIF
   ENDIF
RETURN self


METHOD SLEPic:setChanged(inChanged)
LOCAL cRtn := ::orgValue
Default inChanged to .F.
  IF !inChanged
     ::orgValue := ::EditBuffer()
  ENDIF
RETURN cRtn

METHOD SLEPic:isChanged()
RETURN (::orgValue # ::EditBuffer())


METHOD SLEPic:undo()
   ::XbpSLE:setData(::orgValue)
RETURN self

METHOD SLEPic:setData(inVar)
  IF PCOUNT() == 0 .AND. VALTYPE(::DataLink) == "B"
     inVar := EVAL(::DataLink)
  ENDIF
  ::orgDataType := VALTYPE(inVar)
  IF ::BufferLength < LEN(::cMask)  // adjust buffer if needed jwl 4/1
     ::BufferLength := LEN(::cMask)
  ENDIF
  DO CASE
    CASE ::orgDataType == "N"
         ::DataType := "N"                // Olaf Teickner 04.01.2002
         IF EMPTY(::Picture)
            // ::DataType := "N"       // Olaf Teickner 04.01.2002
            inVar := STR(inVar)
         ELSE
            inVar := TRANSFORM(inVar,::Picture)
         ENDIF
    CASE ::orgDataType == "D"
         ::DataType := "D"          // Olaf Teickner 04.01.2002
         ::HoldFormat := .T.
         IF EMPTY(::Picture)
            // ::DataType := "D" // Olaf Teickner 04.01.2002
            inVar := DTOC(inVar)
         ELSE
            inVar := TRANSFORM(inVar,::Picture)
         ENDIF
    CASE ::orgDataType == "L"
         ::DataType := "L"        // Olaf Teickner 04.01.2002
         IF EMPTY(::Picture)
            // ::DataType := "L" // Olaf Teickner 04.01.2002
            inVar := IIF(inVar,SetLocale(NLS_SYES),SetLocale(NLS_SNO))
         ELSE
            inVar := TRANSFORM(inVar,::Picture)
         ENDIF
    OTHERWISE
         if ::isAtR
            inVar:=PADR(inVar,::bufferlength) // avoid space on end jwl 8/5
            inVar := TRANSFORM(inVar,::Picture)
         ENDIF
  ENDCASE
  ::orgValue := inVar
RETURN ::XbpSLE:setData(inVar)

METHOD SLEPic:transformToOrgDataType()
LOCAL cTemp := PADR(::EditBuffer(),::BufferLength),i
  DO CASE
    CASE ::orgDataType == "N"
       IF ::isAtR
         FOR i:=1 TO LEN(::cMask)
             IF !::cMask[i]$"-,.#9"
                cTemp := StrTran(cTemp,::cMask[i],"")
             ENDIF
         NEXT i
      ENDIF
      IF !EMPTY(::Picture)
        cTemp := StrTran(cTemp,::cThousand,"")
        cTemp := StrTran(cTemp,::cDecimalPoint,".")
        cTemp := StrTran(cTemp,::cCurrency,"")
        cTemp := StrTran(cTemp,"(","")
        cTemp := StrTran(cTemp,")","")
      ENDIF
      cTemp := VAL(cTemp)
    CASE ::orgDataType == "D"
         cTemp := CTOD(cTemp)
    CASE ::orgDataType == "L"
         cTemp := UPPER(cTemp)
         cTemp := (cTemp == SetLocale(NLS_SYES))  //(cTemp == "Y" .OR. cTemp == "T" .OR. cTemp == "J")
    CASE ::isAtR
         FOR i:=1 TO LEN(::cMask)
             IF !::cMask[i]$",#9AXLN" .AND. LEN(cTemp) >= i
                IF LEN(cTemp) > i
                  cTemp := SUBSTR(cTemp,1,i-1)+ CHR(9) + SUBSTR(cTemp,i+1)
                ELSE
                  cTemp := SUBSTR(cTemp,1,i-1)+ CHR(9)
                ENDIF
             ENDIF
         NEXT i
ALTD()
         cTemp := StrTran(cTemp,CHR(9),"")
    CASE !::isAtR .AND. ::orgDataType == "C" .AND. LEN(::cMask) > LEN(cTemp)
         cTemp := PADR(cTemp,LEN(::cMask))
  ENDCASE
RETURN cTemp

METHOD SLEPic:getData()
LOCAL cTemp := ::transformToOrgDataType()
  IF VALTYPE(::datalink) == "B"
     EVAL(::datalink,cTemp)
  ENDIF
RETURN cTemp


METHOD SLEPic:Keyboard(nKey)

   IF !EMPTY(::Picture)
      DO CASE  // get Clipper like navigation
         CASE nKey = xbeK_RETURN
             PostAppEvent(xbeP_Keyboard,xbeK_TAB,,Self)
         CASE nKey = xbeK_DOWN
             PostAppEvent(xbeP_Keyboard,xbeK_TAB,,Self)
         CASE nKey = xbeK_UP
             PostAppEvent(xbeP_Keyboard,xbeK_SH_TAB,,Self)
         CASE nKey = xbeK_DEL
             ::ChkKey(nKey)
         CASE nKey = xbeK_BS
             ::ChkKey(nKey)
         CASE nKey = xbeK_CTRL_U
             ::Undo()
             ::FirstTime := .T.
         CASE nKey = xbeK_CTRL_V
             ::Pasteclipboard()
         CASE nKey = xbeK_SH_INS
             ::Pasteclipboard()
         CASE nKey == xbeK_INS
            Set( _SET_INSERT, ! Set( _SET_INSERT) )

         OTHERWISE
             IF nKey >= 32 .AND. nKey < 255
                ::ChkKey(nKey)
             ELSE
                ::FirstTime := .F.
                ::XbpSLE:Keyboard(nKey) // anything else pass to the normal handler
             ENDIF
      ENDCASE
   ELSE
      DO CASE  // Clipper like navigation even with otherwise standard SLE jwl 4/1
         CASE nKey = xbeK_RETURN
             PostAppEvent(xbeP_Keyboard,xbeK_TAB,,Self)
         CASE nKey = xbeK_DOWN
             PostAppEvent(xbeP_Keyboard,xbeK_TAB,,Self)
         CASE nKey = xbeK_UP
             PostAppEvent(xbeP_Keyboard,xbeK_SH_TAB,,Self)
         OTHERWISE
         ::XbpSLE:Keyboard(nKey) //Normal SLE behaviour
      ENDCASE
   ENDIF
RETURN Self

METHOD SLEPic:ChkKey(nKey)
LOCAL cRtn := "" ,nPos,aPos,aMark,SpaceCount := 0
   IF ::QueryMarked()[::Pindex2]!= ::QueryMarked()[::Pindex1]
      aMark := ::QueryMarked()
      ::XbpSLE:SetData(RTRIM(Stuff(::EditBuffer(),Min(aMark[::Pindex1],aMark[::Pindex2]),ABS(aMark[::Pindex2]-aMark[::Pindex1]),'' ))) //jwl added rtrim 8/5
      ::SetMarked({Min(aMark[::Pindex1],aMark[::Pindex2]),Min(aMark[::Pindex1],aMark[::Pindex2])})
      ::FirstTime := .F.

      RETURN cRtn
   ENDIF
   nPos := ::QueryMarked()[::Pindex2]
//   nPos := IF(::QueryMarked()[::Pindex2]>Len(::cMask),(::SetMarked({::QueryMarked()[::Pindex1],Len(::cMask)}),Len(::cMask)),::QueryMarked()[::Pindex2])
   DO CASE
      CASE ::cFunc == "@!" .AND. EMPTY(::cMask)       // jwl moved case to top 8/5
         cRtn := ::TestPic(nKey,::QueryMarked()[::Pindex2])
         nPos := ::QueryMarked()[::Pindex2]
         ::XbpSLE:SetData(Upper(::EditBuffer()))
         ::SetMarked({nPos,nPos})
      CASE nKey == xbeK_DEL
         IF ::DataType != "N" .AND. nPos <= ::BufferLength +1 .AND. nPos<=LEN(::EditBuffer())
            IF ::cMask[nPos]$"AXN9#LY!, "
               ::XbpSLE:SetData(Stuff(::Editbuffer(),nPos,1,IF(::HoldFormat," ",""))) // jwl 8/3
               ::SetMarked({IF(::HoldFormat,nPos+1,nPos),IF(::HoldFormat,nPos+1,nPos)})
            ELSE
               ::SetMarked({nPos+1,nPos+1})
            ENDIF
         ELSE
            IF ::DataType == "N" .AND. AT(::cDecimalPoint,::EditBuffer()) >= nPos
               IF "," $ ::cMask .AND. AT(::cDecimalPoint,::EditBuffer()) != nPos  // del did not move right jwl 4/1
                  ::XbpSLE:setData(" "+Stuff(::Editbuffer(),nPos,1,""))
                  ::XbpSLE:setData(Transform(::transformToOrgDataType(),::cmask) )
               ELSE   // at decplace
                  ::XbpSLE:setData(" "+Stuff(::Editbuffer(),nPos,1,::cDecimalPoint))  // del did not move right jwl 4/1
                  ::XbpSLE:setData(Transform(::transformToOrgDataType(),::cmask) )
               ENDIF
               ::SetMarked({nPos+1,nPos+1})  // del did not move right jwl 4/1
            ELSE
               ::XbpSLE:Keyboard(nKey) //Normal SLE behaviour
            ENDIF
         ENDIF
         IF ::isAtR .AND. nPos > 1 .AND. !::cMask[--nPos]$"AXN9#LY!, "
               ::XbpSLE:SetData(Stuff(::Editbuffer(),nPos,1," "))
               ::SetMarked({nPos+1,nPos+1})
         ENDIF
      CASE nKey == xbeK_BS
         IF ::DataType != "N" .AND. nPos>1
            IF ::cMask[nPos-1]$"AXN9#LY!, "
               ::XbpSLE:SetData(Stuff(::Editbuffer(),nPos-1,1,IF(::HoldFormat," ",""))) // jwl 8/3
               ::SetMarked({nPos-1,nPos-1})
            ELSEIF nPos > 0
               ::SetMarked({nPos-1,nPos-1})
            ENDIF
         ELSE
            IF ::DataType == "N" .AND. AT(::cDecimalPoint,::EditBuffer()) >= nPos
               IF ::cMask[Max(nPos-1,1)]=::cThousand  // fix commas  jwl 4/1
                  --nPos
               ENDIF
               ::XbpSLE:setData(" "+Stuff(::Editbuffer(),nPos-1,1,""))
               IF AT(",",::cMask) <= nPos
                  ::XbpSLE:setData(Transform(::transformToOrgDataType(),::cmask) )
               ENDIF
               ::SetMarked({nPos,nPos})
            ELSE
               ::XbpSLE:Keyboard(nKey) //Normal SLE behaviour
            ENDIF
         ENDIF
         IF ::isAtR .AND. nPos > 1 .AND. !::cMask[--nPos]$"AXN9#LY!, "
               ::XbpSLE:SetData(Stuff(::Editbuffer(),nPos,1,""))
               ::SetMarked({nPos+1,nPos+1})
         ENDIF
      CASE ::cFunc == "@!"
         cRtn := ::TestPic(nKey,::QueryMarked()[::Pindex2])
         nPos := ::QueryMarked()[::Pindex2]
         ::XbpSLE:SetData(RTRIM(Upper(::EditBuffer())))
         ::SetMarked({nPos,nPos})
      OTHERWISE
         cRtn := ::TestPic(nKey,::QueryMarked()[::Pindex2])
   ENDCASE

RETURN cRtn

METHOD SLEPic:TestPic(nKey,nPos)
LOCAL cRtn:="",I,nOldPos,cTemp,lSendKey := .F.,nRep:=0,cSign:=""
   IF EMPTY(::cMask)
      ::XbpSle:Keyboard(nKey) // no mask process as normal SLE function will be applied later
      RETURN CHR(nKey)
   ENDIF
   IF nPos <= LEN(::cmask).OR.::QueryMarked()[::Pindex1]!=::QueryMarked()[::Pindex2]
      IF nPos > LEN(::cmask)
         nPos = IF(::FirstTime,1,LEN(::cmask))
      ENDIF
      DO CASE
         CASE ::cmask[nPos] == "A"
            IF (nKey >= 65 .AND. nKey <= 90) .OR. (nKey >= 97 .AND. nKey < 122)
               cRtn := CHR(nKey)
               ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
            ENDIF
         CASE ::cmask[nPos] == "N"
            IF (nKey >= 65 .AND. nKey <= 90) .OR. (nKey >= 97 .AND. nKey < 122).OR.(nKey >= 48 .AND. nKey < 57)
               cRtn := CHR(nKey)
               ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
            ENDIF
         CASE ::cmask[nPos] == "X"
            IF nKey >= 32 .AND. nKey < 255
               cRtn := CHR(nKey)
               ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
            ENDIF
         CASE (::cmask[nPos] == "9" .OR. ::cmask[nPos] == "#") .AND. ::DataType = "N"
            IF (nKey == 45 .OR. nKey == ASC(::cDecimalPoint) .OR. ( nKey > 46.AND. nKey <= 57) )
               cRtn := CHR(nKey)
               IF cRtn == ::cDecimalPoint
                  IF ::cDecimalPoint$::EditBuffer() .OR. !"."$RIGHT(::cmask,LEN(::cmask)-nPos)  // no period in sight ignor
                     RETURN ""
                  ELSE //adjust to align with "."
                     nOldPos := nPos
                     FOR I = nPos TO LEN(::cmask)
                        IF ::cmask[I] = "."
                           nPos := I
                           Exit
                        ENDIF
                     NEXT I
                     cTemp := ::EditBuffer()
                     IF .NOT."-"$cTemp .AND. VAL(cTemp)<>0
                        IF ","$::cmask
                           //nPos += CountChr(cTemp,::cThousand)
                           cTemp := StrTran(cTemp,::cThousand,"")
                           cTemp := TRIM( Transform(INT(VAL(cTemp)),LEFT(::cmask,nPos-1)) )
                        ELSEIF nOldPos < AT(".",::cMask)
                           cTemp := TRIM( Transform(INT(VAL(cTemp)),LEFT(::cmask,nPos-1)) )
                        ENDIF
                     ELSE
                        cTemp:=PADL(cTemp,nPos-1)
                     ENDIF
                     ::XbpSLE:SetData(cTemp)
                  ENDIF
               ENDIF
               ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
            ENDIF
         CASE ::cmask[nPos] == "9"   // non numeric datatype only allow digits
            IF (nKey >= 48 .AND. nKey <= 57)
               cRtn := CHR(nKey)
               ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
            ENDIF
         CASE ::cmask[nPos] == "#"
            IF (nKey >= 43 .AND. nKey <= 57) .OR. (nKey = 32)
               cRtn := CHR(nKey)
               ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
            ENDIF
         CASE ::cmask[nPos] == "L"
            IF UPPER(CHR(nKey)) = SetLocale(NLS_SYES) .OR. UPPER(CHR(nKey)) = "T"
               nKey := ASC(UPPER(CHR(nKey)))
               cRtn := CHR(nKey)
               ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
            ELSEIF UPPER(CHR(nKey)) = "F"
               nKey := ASC(UPPER(CHR(nKey)))
               cRtn := CHR(nKey)
               ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
            ELSE
               nKey := ASC(UPPER(SetLocale(NLS_SNO)))
               cRtn := CHR(nKey)
               ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
            ENDIF
         CASE ::cmask[nPos] == "Y"
            IF UPPER(CHR(nKey)) = SetLocale(NLS_SYES)
               nKey := ASC(UPPER(CHR(nKey)))
               cRtn := CHR(nKey)
               ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
            ELSE
               nKey := ASC(UPPER(SetLocale(NLS_SNO)))
               cRtn := CHR(nKey)
               ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
            ENDIF
         CASE ::cmask[nPos] == "!"
            IF (nKey >= 97 .AND. nKey < 122)
               cRtn := UPPER(CHR(nKey))
            ELSE
               cRtn := CHR(nKey)
            ENDIF
            ::ProcessKey(nPos,cRtn,nKey,lSendKey,2)
         CASE ::cmask[nPos] == ","
            cRtn := CHR(nKey)
            IF ::DataType = "N" .AND. cRtn = ::cDecimalPoint
               IF ::cDecimalPoint$::EditBuffer() .OR. !"."$RIGHT(::cmask,nPos)  // no period in sight ignor
                  RETURN ""
               ELSE //adjust to align with "."
                  nOldPos := nPos
                  FOR I = nPos TO LEN(::cmask)
                     IF ::cmask[I] = "."
                        nPos := I
                        Exit
                     ENDIF
                  NEXT I
                  cTemp := ::EditBuffer()
                  IF ","$::cmask
                     nPos += CountChr(cTemp,::cThousand)
                     cTemp := StrTran(cTemp,::cThousand,"")
                     cTemp := TRIM( Transform(INT(VAL(cTemp)),LEFT(::cmask,RAT(".",::cmask)-1)) )
                  ENDIF
                  ::XbpSLE:SetData(cTemp)
               ENDIF
            ELSEIF ::DataType = "N" .AND. cRtn != ::cThousand
               IF IsDigit(cRtn)
                  IF IsDigit(::EditBuffer()[Max(nPos-1,1)]) .AND. (IsDigit(::EditBuffer()[Min(nPos+1,LEN(::EditBuffer()))]) .OR. ::EditBuffer()[Min(nPos+1,LEN(::EditBuffer()))] == " " ) //fix for leading comma problem jwl 4/1
                     cRtn := ::cThousand //+cRtn
                     lSendKey := .T.          //fix for decimal problem jwl 4/1
                  ELSEIF !IsDigit(::EditBuffer()[Max(nPos-1,1)]) .AND. IsDigit(::EditBuffer()[Min(nPos+1,LEN(::EditBuffer()))])
                     --nPos
                     cRtn := CHR(nKey)
                     nKey := ASC(::cThousand)
                     lSendKey := .T.          //fix for decimal problem jwl 4/1
                  ELSE
                     cRtn := " "
                     lSendKey := .T.          //fix for decimal problem jwl 4/1
                  ENDIF
               ELSE
                  cRtn := ""
               ENDIF
            ELSEIF cRtn != ::cThousand
               cRtn := ::cThousand //+cRtn
               lSendKey := .T.          //fix for decimal problem jwl 4/1
            ENDIF
            ::ProcessKey(nPos,cRtn,nKey,lSendKey,1) //fix for decimal problem jwl 4/1
         CASE ::cmask[nPos] == "."
            IF ::cThousand == CHR(nKey)
               cRtn := ""
            ELSEIF ::cDecimalPoint == CHR(nKey)
               cRtn := CHR(nKey)
            ELSE
               cRtn := ::cDecimalPoint  //+CHR(nKey)
               lSendKey := .T.          //fix for decimal problem jwl 4/1
            ENDIF
            ::ProcessKey(nPos,cRtn,nKey,lSendKey,1) //fix for decimal problem jwl 4/1
         CASE ::cmask[nPos] == "/"  //.AND. ::DataType == "D"
            cRtn := ::cDateSeperator
            IF CHR(nKey) != ::cDateSeperator
               lSendKey := .T.
            ENDIF
            ::FirstTime := .F.
            ::ProcessKey(nPos,cRtn,nKey,lSendKey,1)
         OTHERWISE
            IF ::cmask[nPos] = CHR(nKey)
               cRtn := CHR(nKey)
            ELSE
               cRtn := ::cmask[nPos] //+CHR(nKey)
               lSendKey := .T.
            ENDIF
            ::ProcessKey(nPos,cRtn,nKey,lSendKey,1)
      ENDCASE
   ENDIF
RETURN cRtn

METHOD SLEPic:ProcessKey(nPos,cChr,nKey,lSendKey,nModel)
LOCAL nRep
   IF !::IsatK .AND. !::WindatK
      ::FirstTime := .F.
   ENDIF
   DO CASE
      CASE nModel = 1
         IF (nPos == 1 .AND. ::FirstTime .AND. ::cmask[1]$"AXN9#LY!, " ) .OR.(::QueryMarked()[1]=1 .AND. ::QueryMarked()[::Pindex2]=::Bufferlength+1)
            ::FirstTime := .F.
            ::XbpSLE:SetData(cChr)
            ::SetMarked({2,2})
         ELSE
            ::FirstTime := .F.
            IF ::QueryMarked()[::Pindex2]<=::Bufferlength+1 .OR.::QueryMarked()[1]!=::QueryMarked()[::Pindex2]
               IF ::QueryMarked()[1]=::QueryMarked()[::Pindex2]
                  nRep := 1
               ELSE
                  nRep := ABS(::QueryMarked()[::Pindex2]-::QueryMarked()[1])
               ENDIF
               ::XbpSLE:SetData(Stuff(::Editbuffer(),nPos,nRep,cChr))
               ::SetMarked({nPos+Len(cChr),nPos+Len(cChr)})
               IF lSendKey
                  ::TestPic(nKey,nPos+Len(cChr))
               ENDIF
            ENDIF
         ENDIF
      CASE nModel = 2
         IF (nPos == 1 .AND. ::FirstTime) .OR.(::QueryMarked()[1]=1 .AND. ::QueryMarked()[::Pindex2]=::Bufferlength+1)
            ::FirstTime := .F.
            ::XbpSLE:SetData(cChr)
            ::SetMarked({2,2})
         ELSE
            ::FirstTime := .F.
            IF ::QueryMarked()[::Pindex2]<=::Bufferlength+1.OR.::QueryMarked()[1]!=::QueryMarked()[::Pindex2]
               IF ::QueryMarked()[1]=::QueryMarked()[::Pindex2]
                  nRep := 1
               ELSE
                  nRep := ABS(::QueryMarked()[::Pindex2]-::QueryMarked()[1])
               ENDIF
               ::XbpSLE:SetData(Stuff(::Editbuffer(),nPos,nRep,cChr))
               ::SetMarked({nPos+Len(cChr),nPos+Len(cChr)})
            ENDIF
         ENDIF
   ENDCASE
RETURN cChr

FUNCTION CountChr(cStr,cChr)
LOCAL nRtn:=0,I
   FOR I = 1 TO LEN(cStr)
     IF cStr[I] = cChr
        ++nRtn
     ENDIF
   NEXT I
RETURN nRtn

STATIC FUNCTION SLEValidateDate(o)
LOCAL Rtn := .T.,cDate,lIsdigit:=.F.,I:=1
   cDate := o:EditBuffer()
   DO WHILE I<=Len(cDate).AND.!lIsDigit
      IF IsDigit(cDate[I])
         lIsdigit := .T.
      ENDIF
      ++I
   ENDDO
   IF !lIsdigit    // there are no digits so let it pass
      RETURN Rtn
   ENDIF

   DO CASE
      CASE Setlocale(NLS_IDATE)=="0"    // MM/DD/YY
         IF VAL(SUBSTR(cdate,1,2))=0 .OR. VAL(SUBSTR(cdate,1,2))>12
            MSGBOX(StrTran(SLE_BADDATE_ERR1,"/",o:cDateSeperator))
         ENDIF
         IF VAL(SUBSTR(cdate,4,2))=0 .OR. VAL(SUBSTR(cdate,4,2))>31
            MSGBOX(StrTran(SLE_BADDATE_ERR2,"/",o:cDateSeperator))
            Rtn := .F.
         ENDIF
      CASE Setlocale(NLS_IDATE)=="1"    // DD/MM/YY
         IF VAL(SUBSTR(cdate,4,2))=0 .OR. VAL(SUBSTR(cdate,4,2))>12
            MSGBOX(StrTran(SLE_BADDATE_ERR3,"/",o:cDateSeperator))
         ENDIF
         IF VAL(SUBSTR(cdate,1,2))=0 .OR. VAL(SUBSTR(cdate,1,2))>31
            MSGBOX(StrTran(SLE_BADDATE_ERR4,"/",o:cDateSeperator))
            Rtn := .F.
         ENDIF
      CASE Setlocale(NLS_IDATE)=="2"    // YY/MM/DD
         IF Setlocale(NLS_ICENTURY)=="1"  //YYYY
            IF VAL(SUBSTR(cdate,6,2))=0 .OR. VAL(SUBSTR(cdate,6,2))>12
            MSGBOX(StrTran(SLE_BADDATE_ERR5,"/",o:cDateSeperator))
            ENDIF
         ELSE                        //YY
            IF VAL(SUBSTR(cdate,6,2))=0 .OR. VAL(SUBSTR(cdate,6,2))>12
            MSGBOX(StrTran(SLE_BADDATE_ERR6,"/",o:cDateSeperator))
            ENDIF
         ENDIF
         IF Setlocale(NLS_ICENTURY)=="1"  //YYYY
            IF VAL(SUBSTR(cdate,9,2))=0 .OR. VAL(SUBSTR(cdate,9,2))>31
            MSGBOX(StrTran(SLE_BADDATE_ERR7,"/",o:cDateSeperator))
               Rtn := .F.
            ENDIF
         ELSE                       //YY
            IF VAL(SUBSTR(cdate,7,2))=0 .OR. VAL(SUBSTR(cdate,7,2))>31
            MSGBOX(StrTran(SLE_BADDATE_ERR8,"/",o:cDateSeperator))
               Rtn := .F.
            ENDIF
         ENDIF
   ENDCASE
   IF SUBSTR(cdate,3,1)!=o:cDateSeperator
            MSGBOX(StrTran(SLE_BADDATE_ERR9,"/",o:cDateSeperator))
      RETURN .F.
   ENDIF
   IF SUBSTR(cdate,3,1)!=o:cDateSeperator
            MSGBOX(StrTran(SLE_BADDATE_ERR9,"/",o:cDateSeperator))
      RETURN .F.
   ENDIF
   IF Rtn .AND. EMPTY(CTOD(cDate))  // this catches errors like 31 days in feb
            MSGBOX(StrTran(SLE_BADDATE_ERR0,"/",o:cDateSeperator))
      RETURN .F.
   ENDIF
   IF !Rtn
     SetAppFocus(o)
   ENDIF
RETURN Rtn
