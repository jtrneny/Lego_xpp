***************************************************************************
* SKL_RezerOBJPRI.PRG
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*****************************************************************
* SKL_RezerOBJPRI ... Pøedisponování rezervací na obj. pøijatou
*****************************************************************
CLASS SKL_RezerOBJPRI FROM drgUsrClass
EXPORTED:
  VAR     CislObInt
  VAR     nRezORIG, nRezEDIT, nKDispozCELK
//  VAR     anREC, anCEN

  METHOD  Init, itemMarked
  METHOD  drgDialogStart, drgDialogEnd, PreValidate, PostValidate
  METHOD  ODB_OBJHEAD_SEL
  METHOD  SetObjITEM, KDispozCelk, Save_Rezerv, SaveCENIK
  METHOD  Empty_KObj, Empty_Rezer

HIDDEN
  VAR     dm, dc, msg
ENDCLASS

*
*****************************************************************
METHOD SKL_RezerOBJPRI:init(parent)
  Local Filter := ''

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('CENZBOZ'  )
  drgDBMS:open('OBJITEMw'  ,.T.,.T.,drgINI:dir_USERfitm ); ZAP  // ObjItTMP
  drgDBMS:open('OBJITEMw1' ,.T.,.T.,drgINI:dir_USERfitm ); ZAP  // ObjItORG
  drgDBMS:open('CENZBOZw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  *
  ::CislObInt := ObjHead->cCislObInt
  ::nRezOrig := ::nRezEDIT := ::nKDispozCELK := 0
  *
  OBJHEAD->( DbSetRelation( 'FIRMY', { || OBJHEAD->nCisFirmy },'OBJHEAD->nCisFirmy'))
RETURN self

*
********************************************************************************
METHOD SKL_RezerOBJPRI:drgDialogStart(drgDialog)
  LOCAL oBrowse := drgDialog:dialogCtrl:oBrowse[ 1]
  *
  ::dm  := drgDialog:dataManager
  ::dc  := drgDialog:dialogCtrl
  ::msg := drgDialog:oMessageBar
  *
  SEPARATORs( drgDialog:oActionBar:Members)
  ColorOfTEXT( ::dc:members[1]:aMembers )
  *
  ObjITEMw->( AdsSetOrder( 2))
  ::SetObjItem()
*  oBrowse:refresh()
  VyrZAK->( AdsSetOrder(1))
  CenZBOZ->( AdsSetOrder(3))
RETURN self

*
********************************************************************************
METHOD SKL_RezerOBJPRI:drgDialogEnd(drgDialog)
  OBJITEMw->( dbCloseArea())
  OBJITEMw1->( dbCloseArea())
  CenZBOZw->( dbCloseArea())
RETURN self

*
********************************************************************************
METHOD SKL_RezerOBJPRI:ItemMarked()
  Local cKey := Upper(ObjITEMw->cCisSklad) + Upper( ObjITEMw->cSklPol)
  Local cMsg :=  Alltrim( Str( ObjITEMw->( OrdKeyNO()))) + ' / ' + Alltrim( Str( ObjITEMw->( LastRec())))

  ::msg:writeMessage( cMsg)
*
  ObjITEM->( dbGoTO( ObjITEMw->_nRecOr))
  CenZboz->( dbSEEK( cKey,,'CENIK03') )
  VyrZAK->( dbSEEK( Upper( ObjHEAD->cCisZakaz ) ))
  *
  ::KDispozCELK()
*  ::dm:refresh()
RETURN SELF

*
********************************************************************************
METHOD SKL_RezerOBJPRI:preValidate(drgVar)
  Local Name := drgVar:Name, lOK := .T., lAcces

  IF (Name = 'ObjITEMw->nMnozKoDod') // .or. (Name = 'ObjITEMw->nMnozReOdb')
    lOK := AccesToOBJ( 'ObjITEMw')
  ENDIF
RETURN lOK

*
********************************************************************************
METHOD SKL_RezerOBJPRI:postValidate(drgVar)
  Local Value := drgVAR:value, oVAR, nMnKObj, nMnRez, nKDispozCELK
  Local Name := drgVar:Name, cMsg, lOK := .T.

    DO CASE
    CASE ( NAME = 'M->CislObInt' )
       IF( lOK := ::ODB_OBJHEAD_SEL() )
         SetAppFocus(::dc:oBrowse[ 1]:oXbp)
       ENDIF

*    CASE ( Name = 'ObjITEMw->nMnozVpInt' ).or. ( Name = 'ObjITEMw->nMnozKoDod' )
    CASE ( Name = 'ObjITEMw->nMnozKoDod' )
      nMnKObj := Value
      IF nMnKObj > 0   // >=
        IF nMnKObj > ObjITEMw->nMnozObOdb - ;
                     ObjITEMw->nMnozReODB - ObjITEMw->nMnozPlODB
           cMsg := 'Nelze více, než je  OBJEDNÁNO - REZERVACE - PLNÌNÍ !;;' + ;
                   'Objednáno odbìratelem     = [ & ] ;' + ;
                   'Rezervace pro odbìratele  = [ & ] ;' + ;
                   'Plnìní pro odbìratele     = [ & ]'
          drgMsgBox(drgNLS:msg( cMsg, ObjITEMw->nMnozObODB, ObjITEMw->nMnozReODB,ObjITEMw->nMnozPlODB ))
          lOK := .F.
        ENDIF
      ELSEIF nMnKObj < 0
        drgMsgBox(drgNLS:msg( 'Nelze záporné množství !'))
        lOK := NO
      ENDIF
      IF lOK
        ObjITEMw->dRezerv := DATE()
        ObjITEMw->cRezerv := SysCONFIG( 'System:cUserABB' )
      ENDIF

    CASE ( Name = 'ObjITEMw->nMnozReOdb' )
      nMnREZ := Value
      ObjITEMw->nMnozReODB := Value
      IF nMnREZ > ObjITEMw->nMnozObOdb - ObjITEMw->nMnozPlODB
         cMsg := 'Nelze rezervovat více, než je  OBJEDNÁNO - PLNÌNÍ !;;' + ;
                 'Objednáno odbìratelem  = [ & ] ;' + ;
                 'Plnìní pro odbìratele  = [ & ] ;' + ;
                 'Objednáno - Plnìní     = [ & ] ;' + ;
                 'c.obj                  = [ & ] '
        drgMsgBox(drgNLS:msg( cMsg, ObjITEMw->nMnozObODB,ObjITEMw->nMnozPlODB, ObjITEMw->nMnozObODB - ObjITEMw->nMnozPlODB, ObjITEMw->cCislObInt ))
        lOK := NO
      ELSE
*      /*
         ::KDispozCELK()
         nKDispozCELK := ::nKDispozCELK - ObjITEMw->nMnozReODB + nMnREZ
         nkDispozCELK := ROUND( nkDispozCELK, 2)
         IF nKDispozCELK < 0
            drgMsgBox(drgNLS:msg( 'Jste za hranicí množství k dispozici !'))
            lOK := NO
         ENDIF
*       */
      ENDIF
      *
      IF lOK
**        IF ::lKVyrobe
**        ELSE
          ObjITEMw->nMnozKoDod := ;
            MIN( ObjItem->nMnozKoDod + ( ObjItem->nMnozReOdb - ObjITEMw->nMnozReODB),;
                 ObjItem->nMnozKoDod + ( ObjItem->nMnozObODB - ObjItem->nMnozObDod - ObjITEMw->nMnozReODB) )
          ObjITEMw->nMnozKoDod := MAX( ObjITEMw->nMnozKoDod, 0)
* ???          ObjITEMw->nMnozEDIT := ObjITEMw->nMnozKoDOD
**        ENDIF
        ObjITEMw->dRezerv := DATE()
        ObjITEMw->cRezerv := SysCONFIG( 'System:cUserABB' )
      ENDIF

    ENDCASE

RETURN lOK

* Výbìr obj. pøijaté z OBJHEAD
********************************************************************************
METHOD SKL_RezerOBJPRI:ODB_OBJHEAD_SEL( oDlg)
  LOCAL oDialog, nExit
  LOCAL Value := Upper( ::dm:get('M->CislObInt'))
  LOCAL lOK := ( !Empty(value) .and. ObjHEAD->( dbSEEK( Value,,'OBJHEAD0')) )

  IF IsObject( oDlg) .or. !lOK
    DRGDIALOG FORM 'ODB_OBJHEAD_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                     EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK  )
    lOK := .T.
    ::dm:set('M->CislObInt'   , ObjHead->cCislObInt )
    ::dm:save()
    ::dm:refresh()
    *
    ::SetObjITEM()
  ENDIF

RETURN lOK

*
*****************************************************************
METHOD SKL_RezerOBJPRI:SetObjitem()
  Local cKey
  *
  cKey := Upper( ObjHead->cCislObINT)
  ObjItem->( AdsSetOrder( 3), mh_SetScope( cKey ))
  ObjITEMw->( dbZAP())
  ObjITEMw1->( dbZAP())

  ::nRezORIG := 0  // Suma nMnozReODB
  ObjItem->( dbGoTOP())
  Do While ! ObjItem->( Eof())
     If ObjItem->nMnozObOdb > 0
        ::nRezORIG += ObjItem->nMnozReODB
        * editaèní soubor objednávek
        mh_CopyFld( 'ObjItem', 'ObjITEMw', .T. )
        ObjITEMw->nMnozEDIT := ObjITEM->nMnozKoDod
        * originály objednávek
        mh_CopyFld( 'ObjItem', 'ObjITEMw1', .T. )
        * originály skl.položek
        cKey := Upper( ObjItem->cCisSklad) + Upper( ObjItem->cSklPol)
        CenZboz->( dbSEEK( cKey,,'CENIK03'))
        mh_CopyFld( 'CenZboz', 'CenZbozw', .T. )

     EndIf
     ObjItem->( dbSkip())
  EndDo
  ObjItem->( mh_ClrScope())

  OBJITEMw->( dbSetRelation( 'Firmy', { || OBJITEMw->nCisFirmy   } ,;
                                          'OBJITEMw->nCisFirmy' ),;
              dbGoTop() )
  ObjITEM->( dbGoTO( ObjITEMw->_nRecOr))
  *
  ::dc:oBrowse[1]:oXbp:refreshAll()
  SetAppFocus( ::dc:oBrowse[1]:oXbp)
  *
  ::KDispozCELK()

RETURN self

* STATIC FUNC SaveREZ_2()
*****************************************************************
METHOD SKL_RezerOBJPRI:Save_Rezerv()
  Local lOkObj := YES, lOkCen := YES
  Local cTEXT := 'Nelze uložit, nebo došlo k aktualizaci '

  * Test, zda nedošlo ke zmìnì hodnot v ObjItem
  ObjITEMw1->( dbGoTop())
  ObjITEMw1->( dbEVAL( {|| ;
             ObjItem->( dbGoTo( ObjITEMw1->_nrecor))                  ,;
             lOkObj := IF( ObjItem->nMnozKoDod == ObjITEMw1->nMnozKoDod .AND. ;
                           ObjItem->nMnozReOdb == ObjITEMw1->nMnozReOdb .AND. ;
                           ObjItem->nMnozObOdb == ObjITEMw1->nMnozObOdb .AND. ;
                           ObjItem->nMnozPlOdb == ObjITEMw1->nMnozPlOdb      ,;
                           lOkObj, NO  )   }))
  * Test, zda nedošlo ke zmìnì hodnot v CenZboz
  CenZBOZw->( dbGoTop())
  CenZBOZw->( dbEVAL( {|| ;
             CenZboz->( dbGoTo( CenZBOZw->_nrecor))        ,;
             lOkCen := IF( CenZboz->nMnozRZBO == CenZBOZw->nMnozRZBO .AND. ;
                           CenZboz->nMnozDZBO == CenZBOZw->nMnozDZBO .AND. ;
                           CenZboz->nMnozKZBO == CenZBOZw->nMnozKZBO      ,;
                           lOkCen, NO  )   }))

  IF lOkObj .and. lOkCen
    * Aktualizace OBJITEM + CENZBOZ
    ObjITEMw->( dbGoTop())
    ObjITEMw->( dbEVAL( {|| ;
               ObjItem->( dbGoTo( ObjITEMw->_nRecOr))               ,;
               ::SaveCENIK()                                          ,;
               ObjItem->( dbRLock())                                ,;
               mh_CopyFLD( 'ObjITEMw', 'ObjITEM')                   ,;
               ObjItem->nMnozReOdb := ObjITEMw->nMnozReOdb          ,;
               ObjItem->nMnozKoDod := ObjITEMw->nMnozKoDod          ,;
               ObjItem->nMnozReOdb := MAX( 0, ObjItem->nMnozReOdb ) ,;
               ObjItem->nMnozKoDod := MAX( 0, ObjItem->nMnozKoDod ) ,;
               ObjItem->( dbRUnlock())          }))
    ObjItem->( dbCOMMIT())
    ObjITEMw->( dbGoTop())
    *
    ::SetObjITEM()
    drgMsgBox(drgNLS:msg( 'Pøedisponování rezervací bylo provedeno !'))
  ELSE
    cText += IIF( !lOkObj .and.  lOkCen, 'objednávek pøijatých.',;
             IIF(  lOkObj .and. !lOkCen, 'ceníku.'              ,;
             IIF( !lOkObj .and. !lOkCen, 'objednávek i ceníku.', '' )))
    drgMsgBox(drgNLS:msg( cText))
  ENDIF
RETURN Nil

* STATIC FUNC SaveCENIK()
*****************************************************************
METHOD SKL_RezerOBJPRI:SaveCENIK()
  Local cKey := Upper( ObjITEMw->cCisSklad) + Upper( ObjITEMw->cSklPol)
  * Aktualizace CENZBOZ
  IF CenZboz->( dbSeek( cKey,,'CENIK03'))
     IF ObjItem->nMnozReODB <> ObjITEMw->nMnozReODB .or. ;
        ObjItem->nMnozKoDOD <> ObjITEMw->nMnozKoDOD
        IF ReplRec( 'CenZboz')
           CenZboz->nMnozRZBO += - ObjItem->nMnozReODB + ObjITEMw->nMnozReODB
           CenZboz->nMnozRZBO := MAX( 0, CenZboz->nMnozRZBO)
           CenZboz->nMnozDZBO := CenZboz->nMnozSZBO - CenZboz->nMnozRZBO
           CenZboz->nMnozKZBO += - ObjItem->nMnozKoDOD + ObjITEMw->nMnozKoDOD
           CenZboz->( dbUnlock())
        ENDIF
     ENDIF
  ENDIF
RETURN Nil


* K dispozici celkem
********************************************************************************
METHOD SKL_RezerOBJPRI:KDispozCELK()
  ::nKDispozCELK := CenZboz->nMnozDZBO + ObjITEM->nMnozReODB - ObjITEMw->nMnozReODB
  ::dm:refresh()
RETURN self

* Vynuluje sloupec K obj. u dodavatele
********************************************************************************
METHOD SKL_RezerOBJPRI:Empty_KObj(X)
  Local nREC := ObjITEMw->( RecNO())

  ::msg:writeMessage( 'MOMENT PROSÍM ...')
  ObjITEMw->( dbGoTop(),;
              dbEVAL( {|| ObjITEMw->nMnozKoDOD := 0 } ),;
              dbGoTo( nREC))
  ::dc:oBrowse[ 1]:refresh()
  ::dm:refresh()
  ::msg:writeMessage( ,0)
RETURN NIL

* Vynuluje sloupec Rezervováno
********************************************************************************
METHOD SKL_RezerOBJPRI:Empty_Rezer()
  Local nREC := ObjITEMw->( RecNO())

  ObjITEMw->( dbGoTop(),;
              dbEVAL( {|| ObjITEMw->nMnozReODB := 0 } ),;
              dbGoTo( nREC))
  ::dc:oBrowse[ 1]:refresh()
  ::dm:refresh()

RETURN NIL