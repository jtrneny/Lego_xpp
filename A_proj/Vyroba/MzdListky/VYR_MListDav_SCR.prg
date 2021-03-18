********************************************************************************
* Mzdové lístky - dle dávek
********************************************************************************
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


CLASS VYR_MListDAV_SCR FROM drgUsrClass
EXPORTED:
  METHOD  Init, drgDialogStart, EventHandled, tabSelect, ItemMarked
  METHOD  Oprava_ML
HIDDEN:
  VAR     dc, dm, broDAV, broIT, tabNUM
  METHOD  sumColumn
ENDCLASS

********************************************************************************
METHOD VYR_MListDAV_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('MsPrc_MO' )
  drgDBMS:open('Osoby' )
  drgDBMS:open('C_Stred'  )
  drgDBMS:open('ListHD'   )
  drgDBMS:open('Operace'  )
  drgDBMS:open('VyrZAK'   )
  ::tabNUM := 1
RETURN self

********************************************************************************
METHOD VYR_MListDAV_SCR:drgDialogStart(drgDialog)

  ::dm     := drgDialog:dataManager
  ::dc     := drgDialog:dialogCtrl
  ::broDAV := ::dc:oBrowse[1]:oXbp
  ::broIT  := ::dc:oBrowse[2]:oXbp
  *
*  ListHD->( AdsSetOrder( 1))
*  LISTIT->( DbSetRelation( 'VyrZAK'   , {|| Upper(ListIT->cCisZakaz)  },'Upper(ListIT->cCisZakaz)'))
  Osoby->( OrdSetFocus('ID'))
  C_Stred->( OrdSetFocus('STRED1'))

  LIST_DAV->( DbSetRelation( 'Osoby' ,    {|| LIST_DAV->nOSOBY }        ,'LIST_DAV->nOSOBY'))
  LIST_DAV->( DbSetRelation( 'C_Stred'  , {|| Upper(LIST_DAV->cStred)}  ,'Upper(LIST_DAV->cStred)'))
  *
  IF LIST_DAV->( Eof()) .and. LIST_DAV->( Bof())
*    ListIT->( AdsSetOrder( 1))
  ENDIF
  *

RETURN self

********************************************************************************
METHOD VYR_MListDAV_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local cAlias, x, aIT

    DO CASE
    CASE nEvent = drgEVENT_DELETE
      cAlias := oXbp:cargo:cFile
      *
      IF cAlias = 'List_DAV'
        IF drgIsYESNO(drgNLS:msg( 'Zrušit všechny mzdové lístky v dávce èíslo [ & ]  ?',;
                                  List_DAV->nDavka ) )
          aIT := {}
          ListIT->( dbEval( {|| aAdd( aIT, ListIT->( Recno()) ) } ))
          IF ListIT->( Sx_RLock( aIT)) .and. List_DAV->( Sx_RLock())
            * ??? podmínky pro zrušení ListIT
            For x := 1 To LEN( aIT)
              ListIT->( dbGoTO( aIT[ x] ), dbDelete() )
            Next
            ListIT->( dbUnlock(), dbGoTOP() )
            List_DAV->( dbDelete(), dbUnlock())
          ENDIF
        ENDIF
      ENDIF
      *
      IF cAlias = 'ListIT'
        IF drgIsYESNO(drgNLS:msg( 'Zrušit mzdový lístek [ & ] v dávce èíslo [ & ]  ?',;
                                  ListIT->nPorCisLis, ListIT->nDavka ) )
          * ??? podmínky pro zrušení ListIT
          IF ListIT->( Sx_RLock())
              ListIT->( dbDelete() )
          ENDIF

        ENDIF
      ENDIF
      *
      AEval( ::drgDialog:oDBrowse, {|oB| oB:REFRESH() } )
      ::dm:refresh()
    *
    OTHERWISE
      RETURN .F.
    ENDCASE
RETURN .T.

********************************************************************************
METHOD VYR_MListDAV_SCR:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
  ::itemMarked()
RETURN .T.

********************************************************************************
METHOD VYR_MListDAV_SCR:ItemMarked()
  ListIT->( mh_SetScope( IF( List_DAV->nDoklad = 0, 9999999999, List_DAV->nDoklad ) ))
*  ListIT->( mh_SetScope( List_DAV->nDoklad ) )
  ::sumColumn()
RETURN SELF

********************************************************************************
METHOD VYR_MListDAV_SCR:Oprava_ML()
LOCAL oDialog

/*

  ::drgDialog:pushArea()                  // Save work area
  * Napoyicovat soubory pot5ebn0 k editaci ML
  ListHD->( dbSeek( StrZero( ListIT->nRokVytvor,4) + StrZero( ListIT->nPorCisLis,12),,'LISTHD1'))
  Operace->( dbSeek( Upper( ListIT->cOznOper),, 'OPER1'))
  VyrZAK->( dbSeek( Upper( ListIT->cCisZakaz),, 'VYRZAK1'))
  *
*  DRGDIALOG FORM 'VYR_MLISTDAV_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

*/

RETURN self


** HIDDEN **********************************************************************
METHOD VYR_MListDAV_SCR:sumColumn()
  LOCAL nRec := LISTIT->( RecNo()), nHodinySUM := 0.00, nPos
  Local aItems, x

  LISTIT->( dbGoTOP(),;
            dbEVAL( {|| nHodinySUM += LISTIT->nNhNaOpeSK  }) ,;
            dbGoTO( nRec) )
  aItems := { {'LISTIT->nNhNaOpeSK', nHodinySUM } }

  FOR x := 1 TO LEN( aItems)
    IF ( nPos := AScan( ::dc:oBrowse[2]:arDef, {|Col| Col[ 2] = aItems[ x, 1] } ) ) > 0
      ::broIT:getColumn( nPos):Footing:hide()
      ::broIT:getColumn( nPos):Footing:setCell(1, aItems[ x, 2] )
      ::broIT:getColumn( nPos):Footing:show()
    ENDIF
  NEXT

*  ::dm:refresh()
RETURN self