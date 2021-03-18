********************************************************************************
* Karta VyrZAK - mechanismus nad objedn�vkama p�ijat�ma
*                polo�ka Mn.pl�novan� z objedn�vek
********************************************************************************
#include "Xbp.ch"
#include "GRA.ch"
#include "appevent.ch"
#include "Drg.ch"

********************************************************************************
CLASS VYR_OBJZAK_SCR FROM drgUsrClass
EXPORTED:
  VAR     cCisZakaz, cVyrPOL, nCisVar
  METHOD  Init, Destroy, drgDialogStart, postValidate
  METHOD  ObjITEM_wrt

HIDDEN:
   VAR    dm, dmParent, broObjZAK
   METHOD ObjZakW_PUT, ObjZakW_ITEM, sumColumn

ENDCLASS

********************************************************************************
METHOD VYR_OBJZAK_SCR:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('VYRPOL' )
  drgDBMS:open('VYRZAK' )
  drgDBMS:open('OBJZAKw'   ,.T.,.T.,drgINI:dir_USERfitm); ZAP

RETURN self

********************************************************************************
METHOD VYR_OBJZAK_SCR:destroy()
  ::drgUsrClass:destroy()
  *
  ::cCisZakaz := ::cVyrPOL := ::nCisVar := ;
  NIL
RETURN self

********************************************************************************
METHOD VYR_OBJZAK_SCR:drgDialogStart(drgDialog)
  Local oMoment, oDlg, oDraw, oStatic

  ::dm        := drgDialog:datamanager
  ::dmParent  := drgDialog:parent:datamanager
  ::broObjZAK := drgDialog:dialogCtrl:oBrowse[1]
  *
  ::cCisZakaz := ::dmParent:get( 'VyrZAKw->cCisZakaz')
  ::cVyrPOL   := ::dmParent:get( 'VyrZAKw->cVyrPOL'  )
  ::nCisVar   := ::dmParent:get( 'VyrZAKw->nVarCis'  )

  oMoment := SYS_MOMENT()
  *
  ::ObjZakW_PUT()
  ::sumColumn()
  *
  oMoment:destroy()
RETURN self

********************************************************************************
METHOD VYR_OBJZAK_SCR:PostValidate( oVar)
  Local lOK := .F.
  LOCAL xVar := oVar:get(), cNAMe := oVar:name

  DO CASE
    CASE cName = 'ObjZAKw->nMnPotVyrZ'
      If xVar < 0
        drgMsgBox(drgNLS:msg( 'Nelze potvrdit z�porn� mno�stv� !' ))
      ElseIf xVar > ObjZakW->nMnVpIntO + ObjZakW->nMnPotZakO
        drgMsgBox(drgNLS:msg( 'Nelze potvrdit vy��� mno�stv� na objedn�vku,' + ;
                              'ne� kolik je na ni po�adov�no k v�rob� !' ))
      ElseIf xVar < ObjZakW->nMnozDodVy
        drgMsgBox(drgNLS:msg( 'Nelze potvrdit men�� mno�stv� na objedn�vku,' + ;
                              'objedn�vka byla p�ijata do expedice !' ))
      Else
        lOK := .T.
      EndIf
  ENDCASE

RETURN lOK

**HIDDEN************************************************************************
METHOD VYR_OBJZAK_SCR:ObjZakW_PUT()
  Local cTag1 := ObjItem->( AdsSetOrder( 3))
  Local cTag2 := ObjZak->( AdsSetOrder( 2))
  Local cTag3 := VyrPol->( AdsSetOrder( 4)), cKey
  Local nRecVyrPOL := VyrPol->( RecNO())

  * Napln�n� ObjZakW z ObjZak  ... ji� existuj�c�
  cKey := Upper( ::cCisZAKAZ)
  ObjZAK->( mh_SetScope( cKey))
  DO WHILE !ObjZAK->( EOF())
     cKey := Upper( ObjZAK->cCislObINT) + StrZERO( ObjZAK->nCislPolOB, 5)
     ObjITEM->( dbSEEK( cKey,, 'OBJITEM2'))
     mh_CopyFLD('ObjZAK', 'ObjZAKw', .T.)
     ObjZakW->cCisZakaz  := ::cCisZakaz
     ::ObjZakW_ITEM( 'OBJZAK')
     ObjZAK->( dbSKIP())
  ENDDO
  ObjZakW->( dbCOMMIT())
  ObjZAK->( mh_ClrScope())

  * Napln�n� ObjZakW z ObjItem ... nov�
  ObjItem->( AdsSetOrder( 0))
  cKey := Upper( ::cVyrPol) + StrZero( ::nCisVar, 3)
  VyrPol->( dbSeek( cKey,, 'VYRPOL4'))
  ObjItem->( dbGoTop())
  Do While !ObjItem->( Eof())
     IF ( ObjItem->cSklPol = VyrPol->cSklPol) .and. ( ObjItem->nMnozVpINT > 0)
       cKey := UPPER( ::cCisZakaz) + UPPER( ObjItem->cCislObINT) + ;
               StrZERO( ObjItem->nCislPolOb, 5 )
       IF ObjZak->( dbSEEK( cKey,, 'OBJZAK2'))
         ObjZAKW->( dbSEEK( RIGHT( cKEY, 20)))
         ObjZakW->nMnozVpInt := ObjItem->nMnozVpInt
         ObjZakW->nMnVpIntO  := ObjItem->nMnozVpInt
         ObjZakW->nMnVpInt2  := ObjItem->nMnozVpInt
       ELSE
         mh_CopyFLD('ObjITEM', 'ObjZAKw', .T.)
         ObjZakW->cCisZakaz  := ::cCisZakaz
         ::ObjZakW_ITEM( 'OBJITEM')
       ENDIF
     EndIf
     ObjItem->( dbSkip())
  EndDo
  ObjZakW->( dbCOMMIT())
  ObjItem->( AdsSetOrder( cTag1 ))
  ObjZak->( AdsSetOrder( cTag2))
  VyrPol->( AdsSetOrder( cTag3), dbGoTO( nRecVyrPOL) )

RETURN self

**HIDDEN************************************************************************
METHOD VYR_OBJZAK_SCR:ObjZakW_ITEM( cAlias)
  Local cZAKAZ, cTAG, nREC

  ObjZakW->nMnozObODB := ObjITEM->nMnozObODB
  ObjZakW->nMnozVpINT := ObjITEM->nMnozVpINT
  ObjZakW->cPopPolObj := ObjITEM->cPopPolOBJ
  ObjZakW->nMnPotVyrZ := ObjZak->nMnPotVyrZ
  ObjZakW->nMnVpIntO  := ObjItem->nMnozVpInt
  ObjZakW->nMnPotVyrO := ObjItem->nMnPotVyr
  ObjZakW->nMnPotZakO := ObjZak->nMnPotVyrZ
  ObjZakW->nMnVpInt2  := ObjItem->nMnozVpInt
  ObjZakW->nMnPotVyr2 := ObjItem->nMnPotVyr
  ObjZakW->nMnPotZak2 := ObjZak->nMnPotVyrZ
  ObjZakW->lZmena     := .F.
  IF EMPTY( ObjITEM->dDatOdvVYR)
     ( nREC := VyrZAK->( RecNO()), cTAG := VyrZAK->( AdsSetOrder( 1)) )
     cZAKAZ := IF( cALIAS == 'OBJZAK', ObjZAK->cCislObInt, ObjITEM->cCisZAKAZ )
     VyrZAK->( dbSEEK( UPPER( cZAKAZ)) )
     ObjZakW->dDatOdvVyr := VyrZAK->dOdvedZAKA
     VyrZAK->( AdsSetOrder( cTAG), dbGoTO( nREC) )
  ELSE
     ObjZakW->dDatOdvVyr := ObjITEM->dDatOdvVyr
  ENDIF

RETURN self

**HIDDEN************************************************************************
METHOD VYR_OBJZAK_SCR:sumColumn()
  LOCAL nRec := OBJZAKw->( RecNo())
  Local nMnPotVyr := 0.00, nPos
  Local aItems, x

  OBJZAKw->( dbGoTOP(),;
             dbEVAL( {|| nMnPotVyr += OBJZAKw->nMnPotVyrZ }),;
             dbGoTO( nRec) )

  aItems := { {'OBJZAKw->nMnPotVyrZ', nMnPotVyr, ::broObjZAK } }

  FOR x := 1 TO LEN( aItems)
    IF ( nPos := AScan( (aItems[ x,3]):arDef, {|Col| Col[ 2] = aItems[ x, 1] } ) ) > 0
      (aItems[ x,3]):oXbp:getColumn( nPos):Footing:hide()
      (aItems[ x,3]):oXbp:getColumn( nPos):Footing:setCell(1, aItems[ x, 2] )
      (aItems[ x,3]):oXbp:getColumn( nPos):Footing:show()
    ENDIF
  NEXT

  ::dm:refresh()
RETURN self

* Aktualizace ObjITEM, ObjZAK
********************************************************************************
METHOD VYR_OBJZAK_SCR:ObjITEM_wrt()
  Local cKey

  ObjZakW->( dbGoTop())
  Do While !ObjZakW->( Eof())
     * Aktualizace ObjItem
     cKey := Upper( ObjZakW->cCislObINT) + StrZero( ObjZakW->nCislPolOb, 5)
     If ObjItem->( dbSeek( cKey,, 'OBJITEM2' ))
       IF ObjITEM->( dbRLock())
         ObjItem->nMnozVpInt := ObjZakW->nMnozVpInt
         ObjItem->nMnPotVyr  -= ObjZakW->nMnPotZakO - ObjZakW->nMnPotVyrZ
         ObjItem->( dbRUnlock())
       Endif
     Endif
     * Aktualizace ObjZak
     cKey := Upper( ObjZakW->cCisZakaz) + Upper( ObjZakW->cCislObINT) + ;
             StrZero( ObjZakW->nCislPolOb, 5)
     If ObjZak->( dbSEEK( cKey,, 'OBJZAK2'))
       * zru�en�
       If ObjZakW->nMnPotVyrZ == 0
         DelRec( 'ObjZak')
       * oprava
       ElseIf ReplRec( 'ObjZak')
         mh_CopyFLD( 'ObjZAKw', 'ObjZAK')
         mh_WRTzmena( 'ObjZak', .F. )
         ObjZak->( dbUnlock())
       EndIf
     * nov� vztah
     ElseIf ObjZakW->nMnPotVyrZ > 0 .and. AddRec( 'ObjZak')
* pro test     ElseIf ObjZakW->nMnPotVyrZ = 0 .and. AddRec( 'ObjZak')
       mh_CopyFLD( 'ObjZAKw', 'ObjZAK')
       ObjZAK->dTermPoVyr := DATE()
       mh_WRTzmena( 'ObjZak', .T. )
       ObjZak->( dbUnlock())
     Endif
     ObjZakW->( dbSkip())
  EndDo

RETURN self

/********************************************************************************
CLASS SYS_MOMENT  //FROM drgUsrClass
EXPORTED:
*  VAR     oDlg, oDraw, oStatic
  METHOD  Init, Destroy
ENDCLASS

********************************************************************************
METHOD SYS_MOMENT:Init( parent)
  Local aPP := { { XBP_PP_FGCLR  , GRA_CLR_BLUE   }  }
*                 { XBP_PP_BGCLR  , GRA_CLR_PALEGRAY }  }

*  ::drgUsrClass:init(parent)

  ::oDlg          := XbpDialog():new( parent)
  ::oDlg:title    := "... MOMENT PROS�M ..."
  ::oDlg:create( ,, {400,400}, {300,80} )

  ::oDraw := ::oDlg:drawingArea

  ::oStatic := XbpStatic():new(::oDraw ,, {1, 20}, {299,20} )
  ::oStatic:autosize := .T.
  ::oStatic:type     := XBPSTATIC_TYPE_TEXT
  ::oStatic:options  := XBPSTATIC_TEXT_CENTER
  ::oStatic:caption  := '               ... PROB�H� ZPRACOV�N� ...'
  ::oStatic:create()

RETURN self

********************************************************************************
METHOD SYS_MOMENT:destroy()
*  ::drgUsrClass:destroy()
  ::oDlg := ::oDraw := ::oStatic := NIL
RETURN self
*/

*===============================================================================
