/*==============================================================================
  VYR_PostupTech.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "gra.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_PostupTech FROM drgUsrClass
EXPORTED:
  METHOD  Init, drgDialogStart, eventhandled, ItemMarked
HIDDEN:
  VAR     dc
  METHOD  SumColumn
ENDCLASS

*
********************************************************************************
METHOD VYR_PostupTech:Init(parent)
  ::drgUsrClass:init(parent)
RETURN self

*
*****************************************************************
METHOD VYR_PostupTech:drgDialogStart(drgDialog)
  LOCAL  aHead := { 'cVyrPOL', 'cNazev'}
  LOCAL  members  := ::drgDialog:oActionBar:Members, x, oColumn

  ::dc    := drgDialog:dialogCtrl
  *
  AEVAL( aHead,;
   {|c| drgDialog:dataManager:has('VYRPOL->'+ c ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {220, 220, 250} )) })
  SEPARATORs( members)
*  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  *
  FOR x := 1 TO LEN( Members)
    IF members[x]:event $ 'VYR_VYRZAK_INFO'
      IF( EMPTY(VYRPOL->cCisZakaz), members[x]:oXbp:disable(), members[x]:oXbp:enable())
      members[x]:oXbp:setColorFG( If( EMPTY(VYRPOL->cCisZakaz), GraMakeRGBColor({128,128,128}),;
                                                                GraMakeRGBColor({0,0,0})))
    ENDIF
  NEXT
  *
  FOR x := 1 TO ::dc:oBrowse[1]:oXbp:colcount
    ocolumn := ::dc:oBrowse[1]:oXbp:getColumn(x)

    ocolumn:FooterLayout[XBPCOL_HFA_CAPTION]     := ''
    ocolumn:FooterLayout[XBPCOL_HFA_HEIGHT]      := drgINI:fontH - 2
    ocolumn:FooterLayout[XBPCOL_HFA_FRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
    ocolumn:FooterLayout[XBPCOL_HFA_ALIGNMENT]   := XBPALIGN_RIGHT
    ocolumn:FooterLayout[XBPCOL_HFA_FGCLR]       := GRA_CLR_DARKBLUE
    ocolumn:configure()
  NEXT
  *
  ::sumColumn()
RETURN self


********************************************************************************
METHOD VYR_PostupTech:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_DELETE
*      VYR_PolOPER_DEL()
*      ::drgDialog:dialogCtrl:oaBrowse:refresh()
*      oXbp:cargo:refresh()
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

*
********************************************************************************
METHOD VYR_PostupTech:ItemMarked()
  Local cKey := Upper( PolOper_W1->cCisZakaz) + Upper( PolOper_W1->cVyrPol) + StrZero( PolOper_W1->nCisOper, 4) + ;
                StrZero( PolOper_W1->nUkonOper, 2) + StrZero( PolOper_W1->nVarOper, 3)

  PolOper->( dbSeek( cKey,, 'POLOPER1' ))
  Operace->( dbSeek( Upper( PolOper_W1->cOznOper),, 'OPER1' ))
RETURN SELF

*
** HIDDEN **********************************************************************
METHOD VYR_PostupTech:sumColumn()
  LOCAL nRec := PolOper_w1->( RecNo())
  LOCAL nKcNaOper := 0
  Local aItems, x

  PolOper_w1->( dbGoTOP(),;
                dbEVAL( {|| nKcNaOper += PolOper_w1->nKcNaOper } ),;
                dbGoTO( nRec) )
  aItems := { { 'PolOper_w1->nKcNaOper', nKcNaOper } }
  *
  FOR x := 1 TO LEN( aItems)
    IF ( nPos := AScan( ::dc:oBrowse[1]:arDef, {|Col| Col[ 2] = aItems[ x, 1] } ) ) > 0
      ::dc:oBrowse[1]:oXbp:getColumn( nPos):Footing:hide()
      ::dc:oBrowse[1]:oXbp:getColumn( nPos):Footing:setCell(1, aItems[ x, 2] )
      ::dc:oBrowse[1]:oXbp:getColumn( nPos):Footing:show()
    ENDIF
  NEXT
  ::dc:oBrowse[1]:oXbp:refreshAll()
RETURN self