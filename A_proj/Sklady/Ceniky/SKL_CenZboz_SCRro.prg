/*==============================================================================
  SKL_CenZBOZ_SCRro.PRG
==============================================================================*/

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Xbp.ch"
#include "Gra.ch"
#include "..\SKLADY\SKL_Sklady.ch"

*===============================================================================
FUNCTION NazMistULOZ()
  C_UlozMi->( dbSEEK( Upper( ULOZENI->cUlozZbo),,'C_ULOZM2'))
RETURN C_UlozMi->cNazevMist
********************************************************************************
*
********************************************************************************
CLASS SKL_CenZboz_SCRro FROM drgUsrClass, quickFiltrs
EXPORTED:
*  VAR     nAktivni, FormIsRO
  METHOD  Init, drgDialogInit, drgDialogStart, ItemMarked, ItemMarked1, tabSelect
HIDDEN
  VAR     tabNUM, mainbro
ENDCLASS

********************************************************************************
METHOD SKL_CenZboz_SCRro:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('CENZBOZ'  )
  drgDBMS:open('C_TYPPOH' )
  drgDBMS:open('C_UlozMi' )
  drgDBMS:open('PVPITEM'  )
  drgDBMS:open('PVPHEAD'  )
*  drgDBMS:open('CenZB_NS' )
  drgDBMS:open('C_DPH'    )
  drgDBMS:open('C_SKLADY' )
  drgDBMS:open('DODZBOZ'  )
  drgDBMS:open('ULOZENI'  )
  *
  PVPITEM->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU)', 'C_TYPPOH05'))
  PVPITEM->( DbSetRelation( 'PVPHEAD',  { || PVPITEM->nDoklad }  ,'PVPITEM->nDoklad' ))
  CENZBOZ->( DbSetRelation( 'C_DPH'   , { || CENZBOZ->nKlicDPH } ,'CENZBOZ->nKlicDPH' ))
  CENZBOZ->( DbSetRelation( 'C_SKLADY', { || Upper(CENZBOZ->cCisSklad) },'Upper(CENZBOZ->cCisSklad)'))
  *
  ::tabNum    := 1
  *
RETURN self

********************************************************************************
METHOD SKL_CENZBOZ_SCRro:drgDialogInit(drgDialog)
*  drgDialog:formHeader:title += IF( ::FormIsRO, ' - INFO', '' )
RETURN

********************************************************************************
METHOD SKL_CENZBOZ_SCRro:drgDialogStart(drgDialog)
*  Local aEventsDisabled := 'cenik_dodavatele,cenik_mistauloz,cenik_vyrobcis,cenik_pohyby,cenik_prepoctymj,cenik_preceneni'
  Local x, oActions := drgDialog:oActionBar:members
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ::mainBro := drgDialog:odBrowse[1]
  drgDialog:SetReadOnly( .t.)
  *
  ::quickFiltrs:init( self                                             , ;
                      { { 'Kompletní seznam       ', ''               }, ;
                        { 'Aktivní položky        ', 'laktivni = .t.' }, ;
                        { 'Neaktivní položky      ', 'laktivni = .f.' }  }, ;
                      'Ceník'                                            )
RETURN

/********************************************************************************
METHOD SKL_CenZboz_SCRro:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
    CASE nEvent = drgEVENT_DELETE
      /*
      SKL_CENZBOZ_DEL()
      *
      if ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:rowpos = 1
        ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:dehilite()
        ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:rowpos := 2
      endif
      *
      ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
      ::ItemMarked()
      ::ItemMarked1()
      ::drgDialog:datamanager:refresh()
      *
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.
*/

*******************************************************************************
METHOD SKL_CenZboz_SCRro:ItemMarked()
  Local cFilter, aFilter, Filter
  Local cScope := Upper(CENZBOZ->cCisSklad) + Upper(CENZBOZ->cSklPol)
  *
  PVPITEM->( mh_SetScope( cScope ))
  ULOZENI->( mh_SetScope( cScope ))
  C_PREPMJ->( mh_SetScope( cScope ))
  *
  cFilter := "Upper(cCisSklad) = '%%' .and. Upper(cSklPol) = '%%' .and. nCisFirmy > 0"
  aFilter := { Upper(CENZBOZ->cCisSklad), Upper(CENZBOZ->cSklPol)}
  Filter  := Format( cFilter, aFilter )
  DodZboz->( mh_SetFilter( Filter))
  *
RETURN SELF

*******************************************************************************
METHOD SKL_CenZboz_SCRro:ItemMarked1()
  PVPHEAD->( dbSeek( PVPItem->nDoklad,,'PVPHEAD01'))
RETURN SELF

********************************************************************************
METHOD SKL_CenZboz_SCRro:tabSelect( tabPage, tabNumber)
  ::tabNUM := tabNumber
RETURN .T.
