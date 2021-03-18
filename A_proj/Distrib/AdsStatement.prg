#include "adsdbe.ch"
#include "common.ch"
#include "dbstruct.ch"

#define KEYWORD_SELECT  "SELECT "


class AdsStatement
  exported:
  var Handle, Statement, Alias, Session, Cursor, LastError, hCursor

  *
  **
  inline method GetLastError()
  return(::LastError)

  *
  **
  inline method Init(cStatement, oSession)

    if(ValType(oSession)!="O")
       MsgBox( 'Parameter Type error : oSession' + Chr(13) + '(passed to AdsStatement:Init())' )
       ::LastError := 3
       return self
    endif

    if(!oSession:IsDerivedFrom("DacSession"))
      MsgBox( 'Parameter passed is not a DacSession : oSession' + chr(13) +'(passed to AdsStatement:Init())' )
      ::LastError := 4
      return Self
    endif

    ::Session := oSession
  return ::Open(cStatement)

  *
  **
  inline method Close()

    if(::HANDLE==NIL)
      return .F.
    endif

   if (Used(::Alias))
      (::Alias)->(DbCloseArea())
   endif

   ::LastError := AdsCloseSQLStatement( ::HANDLE)
   ::Statement := NIL
   ::HANDLE    := NIL
   ::Alias     := NIL
  return .t.

  *
  **
  inline method Open(cStatement)
    local nH, nError, nErrorLen, cErrorString

    if ValType(cStatement)!="C"
      MsgBox( 'Parameter Type Invalid : Statement' + Chr(13) +'(passed to AdsStatement:Open())' )
      ::LastError := 1
      return self
    endif

    ::Statement := cStatement
    nH          := 0x0
    ::LastError := AdsCreateSQLStatement( ::Session:getConnectionHandle(), @nH )
    ::HANDLE    := nH

    if ::LastError > 0
      cErrorString := _AdsGetLastError()
      MsgBox(cErrorString)
    else
      ::LastError := AdsVerifySQL( nH, cStatement )
      if ::LastError > 0
        cErrorString := _AdsGetLastError()
        MsgBox(cErrorString)
      endif
    endif
  return self

  *
  **
  inline method Execute( cAlias, lDbUse )
    local rc := 0x0, nCursor := 0x0, cErrorString, nErrorLen, nError

    default lDbUse to .t.

    ::LastError := AdsExecuteSQLDirect( ::HANDLE , ::Statement , @nCursor )
    ::Alias     := cAlias
    ::Cursor    := L2Bin(nCursor)
    ::hCursor   := nCursor

    if ::LastError > 0
      cErrorString := _AdsGetLastError()
      MsgBox(cErrorString)
      return ''
    endif


    if lDbUse
      DbUseArea( .T. ,::Session, "<CURSOR>"+L2Bin(nCursor)+"</CURSOR>",cAlias)

      if (Used())
        ::Alias   := Alias()
        ::Cursor  := L2Bin(nCursor)
        ::hCursor := nCursor
      endif
    endif
  return ::Alias
endclass



*
**
FUNCTION _AdsGetLastError()
  LOCAL cErrorString, nErrorLen, nError

  cErrorString := Space(500)
  nErrorLen := 500
  nError := 0

*  AdsGetLastError(@nError,@cErrorString,@nErrorLen)
  cErrorString := Strtran(Pad(cErrorString,nErrorLen),';',Chr(13))
RETURN cErrorString