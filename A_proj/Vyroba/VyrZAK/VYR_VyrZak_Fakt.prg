
********************************************************************************
* Fakturace výrobní zakázky
********************************************************************************
CLASS VYR_VyrZak_Fakt FROM drgUsrClass
EXPORTED:
  METHOD Init, Destroy, drgDialogStart

HIDDEN
  VAR     dc, dm, broFakIT
  METHOD  sumColumn
ENDCLASS

********************************************************************************
METHOD VYR_VyrZak_Fakt:Init( parent)
RETURN self

********************************************************************************
METHOD VYR_VyrZak_Fakt:Destroy()
  ::dc := ::dm := ::broFakIT := Nil
  FakVysIT->( DbClearRelation())  
RETURN self

********************************************************************************
METHOD VYR_VyrZak_Fakt:sumColumn()
  LOCAL nRecF := FakVysIT->( RecNo())
  Local nSumZAKcel := 0.00, nSumZAHcel := 0.00, nPos
  Local aItems, x

  FakVysIT->( dbGoTOP(),;
              dbEVAL( {|| nSumZAKcel += FakVysIT->nCenZakCel,;
                          nSumZAHcel += FakVysIT->nCenZahCel }),;
              dbGoTO( nRecF) )

  aItems := { {'FakVysIT->nCenZakCel', nSumZAKcel, ::broFakIT },;
              {'FakVysIT->nCenZahCel', nSumZAHcel, ::broFakIT } }

  FOR x := 1 TO LEN( aItems)
    IF ( nPos := AScan( (aItems[ x,3]):arDef, {|Col| Col[ 2] = aItems[ x, 1] } ) ) > 0
      (aItems[ x,3]):oXbp:getColumn( nPos):Footing:hide()
      (aItems[ x,3]):oXbp:getColumn( nPos):Footing:setCell(1, aItems[ x, 2] )
      (aItems[ x,3]):oXbp:getColumn( nPos):Footing:show()
    ENDIF
  NEXT

  ::dm:refresh()
RETURN self

********************************************************************************
METHOD VYR_VyrZak_Fakt:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ::dc       := drgDialog:dialogCtrl
  ::dm       := drgDialog:dataManager
  ::broFakIT := ::dc:oBrowse[1]
  FakVysIT->( mh_SetScope( Upper( VYRZAK->cCisZakaz)))
  ::sumColumn()
  *
  FakVysIT->( DbSetRelation( 'FakVysHD', {||FakVysIT->nCisFak },'FakVysIT->nCisFak' ))
RETURN self

