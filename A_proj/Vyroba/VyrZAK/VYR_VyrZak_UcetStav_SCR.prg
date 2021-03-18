/*==============================================================================
  VYR_VyrZAK_scr.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"


********************************************************************************
* Screen - Výrobní zakázky dle Fakturace
********************************************************************************
CLASS VYR_VyrZak_UcetStav_SCR FROM  drgUsrClass   // VYR_VyrZak_SCR
EXPORTED:
  VAR    VyrZakSCR
  METHOD Init, drgDialogStart, Destroy

  * bro vyrZak
  * bro fakvysit
//  inline access assign method cenPol() var cenPol
//    return if(fakvysit->cpolcen = 'C', MIS_ICON_OK, 0)

  * bro fakvnpit


  inline method ItemMarked()
//    local  cky := upper(vyrZak->ccisZakaz)

//    fakVysit->(AdsSetOrder('FVYSIT10'), dbsetscope(SCOPE_BOTH, cky), dbGotop())
//    fakVnpit->(AdsSetOrder('FVYSIT6' ), dbsetscope(SCOPE_BOTH, cky), dbGotop())


*    FakVysIT->( mh_SetScope( LEFT( Upper(VYRZAK->cCisZakaz), 8)) )
*    FakVnpIT->( mh_SetScope( LEFT( Upper(VYRZAK->cCisZakaz), 8)) )
  return self

/*
*****************************************************************
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)

    DO CASE
      CASE nEvent = drgEVENT_DELETE
        VYR_VYRZAK_Del()
*        ::RefreshBROW('VyrZAK')
      OTHERWISE
        RETURN .F.
    ENDCASE
  RETURN .T.
*/
ENDCLASS

********************************************************************************
METHOD VYR_VyrZak_UcetStav_SCR:Init( parent)
//  ::VyrZakSCR := VYR_VyrZak_SCR():new( parent)


//  drgDBMS:open( 'UCETPOL',,,,,'UCETPOLn')
  drgDBMS:open('UCETPOL',,,,,'UCETPOLt')
  drgDBMS:open('ucetpolw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  ::drgUsrClass:init(parent)

RETURN self


********************************************************************************
METHOD VYR_VyrZak_UcetStav_SCR:drgDialogStart(drgDialog)
  LOCAL  n, x, oColumn , nRecCount, nArea
  LOCAL  cFilter
//  LOCAL  members  := ::drgDialog:oActionBar:Members

  *
//  ::dc := drgDialog:dialogCtrl
//  ::dm := drgDialog:dataManager
  *
//  SEPARATORs( members)
//  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  *
  cFilter := FORMAT("cNazPol3 = '%%' and norducto = 1 and cdenik <> 'O'",{ VyrZAK->cNazPol3 } )
  UcetPol->( mh_SetFilter( cFilter), dbGoTOP())

  cFilter := FORMAT("cNazPol3 = '%%' and norducto = 1 and cdenik = 'O'",{ VyrZAK->cNazPol3 } )
  UcetPolt->( mh_SetFilter( cFilter), dbGoTOP())

  do while .not. UcetPolt->( Eof())
    mh_copyfld('ucetpolt','ucetpolw',.t.)
    UcetPolt->( dbSkip())
  enddo

*  VyrZakIT->( ads_SetAOF( ::Filter), dbGoTOP() )
*  nRecCount := VyrZakIT->( ads_GetRecordCount())
*  nArea := VyrZakIT->( Select() )

/*
  * VyrZakIT
  FOR n := 1 TO 2
    FOR x := 1 TO ::dc:oBrowse[n]:oXbp:colcount
      ocolumn := ::dc:oBrowse[n]:oXbp:getColumn(x)

      ocolumn:FooterLayout[XBPCOL_HFA_CAPTION]     := ''
      ocolumn:FooterLayout[XBPCOL_HFA_HEIGHT]      := drgINI:fontH - 2
      ocolumn:FooterLayout[XBPCOL_HFA_FRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
      ocolumn:FooterLayout[XBPCOL_HFA_ALIGNMENT]   := XBPALIGN_RIGHT
      ocolumn:FooterLayout[XBPCOL_HFA_FGCLR]       := GRA_CLR_DARKBLUE
      ocolumn:configure()
    NEXT
    IF( n = 1, ::sumColumn(), )
  NEXT
  *

  *
  drgDialog:odBrowse[2]:oxbp:refreshAll()
  drgDialog:odBrowse[1]:oxbp:refreshAll()
  *
  IsEditGet( { 'nOrdItem', 'cVyrobCisl'}, drgDialog, .F. )
*/


RETURN self



********************************************************************************
METHOD VYR_VyrZak_UcetStav_SCR:Destroy()
//  ::VyrZakSCR:destroy()
//  ::VyrZakSCR := NIL
RETURN self
