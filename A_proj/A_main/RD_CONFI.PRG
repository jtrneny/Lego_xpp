//xpp  #Include  'SixCdx2.Ch'

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


Static  axConfig


Function ATADJUST(cSearchFor,cString,nEndPoint)
  Local  nPos := AT(cSearchFor,cString)
  Local  cResult

  cResult := PADR( SUBSTR( cString, 1, nPos -1), nEndPoint -1) +cSearchFor + ;
                   SUBSTR( cString, nPos +1)
Return(cResult)

/*
//____________PRVKY PRO GS______________________________________________________
Function  UserConfig()
  Local  N, nField := 9
  Local  xScope, nTagNo
  Local  aX

  If Empty( axConfig)
    axConfig := {}
    If( Config ->( Sx_TagCount()) == 2, ( xScope :=  1, nTagNo  := 2 ) , ;
                                                                                                                                                    ( xScope := '1', nTagNo := 3 )   )
    Config ->( Sx_SetTagNo( nTagNo))
    Config ->( Sx_SetScope( 0, xScope), Sx_SetScope( 1, xScope), dbGoTop())
    Do While !Config ->( Eof())
      aX := {}
      For N := 1 To nField ; aAdd( aX, Config ->( FieldGet( N)) )
      Next
      aAdd( axConfig, aX )
      Config ->( dbSkip())
    EndDo
    Config ->( Sx_SetTagNo( 1))
    Config ->( Sx_ClrScope( 0), Sx_ClrScope( 1))
  EndIf
Return( axConfig)
*/

Function TXTConfig( cItems)
  Local  cKey  := PadR( Upper( AtAdJust( ':', cItems, 9 )), 19 )

  Config ->( dbSeek( cKey))
Return( Config ->cName)



Function SysConfig( cItems, cdate)
  Local  cKey, cFile
  Local  cTyp, cValue, cPicture
  Local  lRange
  Local  lOk := .F.
  Local  axRet := { 'Nic', Nil }

  default cdate to Date()

  drgDBMS:open('CONFIGHD')
  drgDBMS:open('CONFIGIT')
  drgDBMS:open('CONFIGUS')

  cKey := Upper( Padr( SubStr( cItems, 1, At(":", cItems)-1), 10)             ;
                  +Padr( SubStr( cItems, At(":", cItems)+1), 10)              ;
                   +Padr(usrName, 10))

//  If     (lOk := RetRecOk("CONFIGUS",cdate,cKey))            ;  cFile := "CONFIGUS"
//  ElseIf (lOk := RetRecOk("CONFIGIT",cdate,Left( cKey,20)))  ;  cFile := "CONFIGIT"
//  ElseIf (lOk := RetRecOk("CONFIGHD",cdate,Left( cKey,20)))  ;  cFile := "CONFIGHD"
//  End

  If (lOk := RetRecOk("CONFIGUS",cdate,cKey))
    cFile := "CONFIGUS"
  Else
    If (lOk := RetRecOk("CONFIGIT",cdate,Left( cKey,20)))
      cFile := "CONFIGIT"
    Else
      If (lOk := RetRecOk("CONFIGHD",cdate,Left( cKey,20)))
        cFile := "CONFIGHD"
      End
    End
  End

  IF lOk
    ( cTyp   := (cFile)->cTyp  , cValue   := allTrim( (cFile)->cValue)  )
    ( lRange := (cFile)->lRange, cPicture := allTrim( (cFile)->cPicture))

    Do Case
    Case( cTyp == 'N' )
      axRet := If( lRange, { Val( Left  ( cValue, At( ':', cValue) - 1))   , ;
                             Val( SubStr( cValue, At( ':', cValue) + 1)) } , ;
                   Val( cValue)                                              )

      If !lRange .and. !Empty( cPicture)
//        axRet := Val( Transform( axRet, cPicture))
//        axRet := Val( Transform( axRet, AllTrim( cPicture) ) )
      EndIf

    Case( cTyp == 'C')
      if .not. empty(cPicture)
        ckey  := padr( cValue, len(cPicture) )
        axRet := transForm( ckey, cPicture)
      else
        axRet := cValue
      endif

* JS 29.10.2012
//      If !Empty( cValue) ;  axRet := TransForm( cValue, Trim( cPicture) )
//      Else               ;  axRet := cValue
//      EndIf

    Case( cTyp == 'L')
      axRet := If( Upper( AllTrim( cValue)) == 'ANO', .T., .F. )

    Case( cTyp == 'D') ;  axRet := CToD( cValue)
    EndCase
  EndIf
Return( axRet)


Static Function RetRecOk( cFile, date, cKey)
  Local lOk  := .T.
  Local cOrder

  cOrder := cFile +'06'

  (cFile)->( AdsSetOrder( cOrder))
  (cFile)->( dbSetScope(SCOPE_BOTH, cKey),dbGOTOP())
    Do While !(cFile)->( Eof()) .AND. lOk
      If( (cFile)->dPlatn_Od <= date, lOk := .F., Nil)    // upravit na myDate
      If( !lOk .and. ( (cFile)->dPlatn_Do > date .or. Empty((cFile)->dPlatn_Do)), lOk := .F., Nil)    // upravit na myDate
      If( lOk, (cFile)->( dbSkip()), Nil)
    EndDo

Return( !lOk)