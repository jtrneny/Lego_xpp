***************************************************************************
* SKL_RezerSKLPOL.PRG
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


********************************************************************************
* SKL_RezerSKLPOL ... P�edisponov�n� rezervac� na skl. polo�ku
********************************************************************************
CLASS SKL_RezerSKLPOL FROM drgUsrClass
EXPORTED:
  VAR     SklPol
  VAR     lKVyrobe
  VAR     nRezORIG, nRezEDIT, nKDispozCELK
  VAR     anREC, anCEN


  METHOD  Init, ItemMarked
  METHOD  drgDialogStart, drgDialogEnd, PreValidate, PostValidate
  METHOD  SKL_CENZBOZ_SEL
  METHOD  SetObjITEM, KDispozCELK, Save_Rezerv

HIDDEN
  VAR     dm, dc, msg
ENDCLASS

*
********************************************************************************
METHOD SKL_RezerSKLPOL:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('NAKPOL'  )
  drgDBMS:open('OBJITEMw'  ,.T.,.T.,drgINI:dir_USERfitm ); ZAP  // ObjItTMP
  drgDBMS:open('OBJITEMw1' ,.T.,.T.,drgINI:dir_USERfitm ); ZAP  // ObjItORG
  drgDBMS:open('CENZBOZw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  *
  ::SklPol   := ''
  ::lKVyrobe := .f.
  ::nRezOrig := ::nRezEDIT := ::nKDispozCELK := 0
RETURN self

*
********************************************************************************
METHOD SKL_RezerSKLPOL:drgDialogStart(drgDialog)
  *
  ::dm := drgDialog:dataManager
  ::dc := drgDialog:dialogCtrl
  ::msg := ::drgDialog:oMessageBar
  *
  ColorOfTEXT( ::dc:members[1]:aMembers )
  * Zobraz� sloupec nMnozVpInt nebo nMnozKoDod
*  oBrowse := ::dc:oBrowse[ 1]
  *
  CenZboz->( dbGoTo( 0))
  ObjITEMw->( AdsSetOrder( 2))
  ::dc:oBrowse[1]:refresh()
*  ::itemMarked()

RETURN self

********************************************************************************
METHOD SKL_RezerSKLPOL:itemMarked()
  Local cMsg :=  Alltrim( Str( ObjITEMw->( OrdKeyNO()))) + ' / ' + Alltrim( Str( ObjITEMw->( LastRec())))

  ::msg:writeMessage( cMsg)
  ObjITEM->( dbGoTO( ObjITEMw->_nRecOr))
  VyrZak->( dbSeek( Upper( ObjITEMw->cCislObINT),,'VYRZAK1'))
  ::dm:refresh()
RETURN self

*
********************************************************************************
METHOD SKL_RezerSKLPOL:preValidate(drgVar)
  Local Name := drgVar:Name
  Local lOK := .T., lAcces

  IF (Name = 'ObjITEMw->nMnozEDIT') // .or. (Name = 'ObjITEMw->nMnozReOdb')
    lOK := AccesToOBJ( 'ObjITEMw')
  ENDIF

RETURN lOK

*
********************************************************************************
METHOD SKL_RezerSKLPOL:postValidate(drgVar)
  Local Value := drgVAR:value, oVAR, nMnKObj, nMnRez, nKDispozCELK
  Local Name := drgVar:Name, cMsg, lOK := .T.

  DO CASE
  CASE ( NAME = 'M->SklPol' )
     IF( lOK := ::SKL_CENZBOZ_SEL() )
       SetAppFocus(::dc:oBrowse[ 1]:oXbp)
     ENDIF

*    CASE ( Name = 'ObjITEMw->nMnozVpInt' ).or. ( Name = 'ObjITEMw->nMnozKoDod' )
  CASE ( Name = 'ObjITEMw->nMnozEDIT' )
    nMnKObj := Value
    IF nMnKObj > 0   // >=
      IF nMnKObj > ObjITEMw->nMnozObOdb - ;
                   ObjITEMw->nMnozReODB - ObjITEMw->nMnozPlODB
         cMsg := 'Nelze v�ce, ne� je  OBJEDN�NO - REZERVACE - PLN�N� !;;' + ;
                 'Objedn�no odb�ratelem     = [ & ] ;' + ;
                 'Rezervace pro odb�ratele  = [ & ] ;' + ;
                 'Pln�n� pro odb�ratele     = [ & ]'
        drgMsgBox(drgNLS:msg( cMsg, ObjITEMw->nMnozObODB, ObjITEMw->nMnozReODB,ObjITEMw->nMnozPlODB ))
        lOK := .F.
      ENDIF
    ELSEIF nMnKObj < 0
      drgMsgBox(drgNLS:msg( 'Nelze z�porn� mno�stv� !'))
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
       cMsg := 'Nelze rezervovat v�ce, ne� je  OBJEDN�NO - PLN�N� !;;' + ;
               'Objedn�no odb�ratelem  = [ & ] ;' + ;
               'Pln�n� pro odb�ratele  = [ & ] ;' + ;
               'Objedn�no - Pln�n�     = [ & ] ;' + ;
               'c.obj                  = [ & ] '
      drgMsgBox(drgNLS:msg( cMsg, ObjITEMw->nMnozObODB,ObjITEMw->nMnozPlODB, ObjITEMw->nMnozObODB - ObjITEMw->nMnozPlODB, ObjITEMw->cCislObInt ))
      lOK := NO
    ELSE
*      /*
       ::KDispozCELK()
       nKDispozCELK := ::nKDispozCELK - ObjITEMw->nMnozReODB + nMnREZ
       nkDispozCELK := ROUND( nkDispozCELK, 2)
       IF nKDispozCELK < 0
          drgMsgBox(drgNLS:msg( 'Jste za hranic� mno�stv� k dispozici !'))
          lOK := NO
       ENDIF
*       */
    ENDIF
    *
    IF lOK
      IF ::lKVyrobe
      ELSE
        ObjITEMw->nMnozKoDod := ;
          MIN( ObjItem->nMnozKoDod + ( ObjItem->nMnozReOdb - ObjITEMw->nMnozReODB),;
               ObjItem->nMnozKoDod + ( ObjItem->nMnozObODB - ObjItem->nMnozObDod - ObjITEMw->nMnozReODB) )
        ObjITEMw->nMnozKoDod := MAX( ObjITEMw->nMnozKoDod, 0)
* ???          ObjITEMw->nMnozEDIT := ObjITEMw->nMnozKoDOD
      ENDIF
      ObjITEMw->dRezerv := DATE()
      ObjITEMw->cRezerv := SysCONFIG( 'System:cUserABB' )
    ENDIF

  ENDCASE

RETURN lOK

*
********************************************************************************
METHOD SKL_RezerSKLPOL:drgDialogEnd(drgDialog)
*  ObjITEMw->( dbCloseArea())
  ObjITEMw1->( dbCloseArea())
  CenZBOZw->( dbCloseArea())
RETURN self

* V�b�r skladov� polo�ky z CENZBOZ
********************************************************************************
METHOD SKL_RezerSklPol:SKL_CENZBOZ_SEL( oDlg)
  LOCAL oDialog, nExit
  LOCAL Value := Upper( ::dm:get('M->SklPol'))
  LOCAL lOK := ( !Empty(value) .and. CenZboz->( dbSEEK( Value,,'CENIK01')) )

  IF IsObject( oDlg) .or. !lOK
    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                     EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK  )
    lOK := .T.
    ::dm:set('M->SKLPOL'   , CENZBOZ->CSKLPOL )
    ::dm:save()
    ::dm:refresh()
    * Zjist� v NakPOL, zda jde o v�robek ( R) nebo o polotovar ( P)
    *    Pokud ANO => aktualizuje se Mn. k v�rob�, jinak Mn. k obj. u DOD.
    cKEY := Upper( CenZBOZ->cCisSKLAD) + Upper( CenZBOZ->cSklPOL)
    NakPOL->( dbSEEK( cKEY,, 'NAKPOL3'))
    ::lKVyrobe := ALLTRIM( UPPER( NakPOL->cKodTPV)) == 'R'  .OR. ;
                  ALLTRIM( UPPER( NakPOL->cKodTPV)) == 'P'
    *
    ::SetObjITEM()
  ENDIF

RETURN lOK

*
*****************************************************************
METHOD SKL_RezerSklPol:SetObjitem()
  Local cKey, cSklPol, oMoment

  oMoment := SYS_MOMENT()
  *
  ( ::anREC := {}, ::anCEN := {} )
  * origin�l cen�ku
  mh_CopyFld( 'CenZBOZ', 'CenZBOZw', .T. )
  *
  cKey := Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPol)
  ObjItem->( AdsSetOrder( 4), mh_SetScope( cKey ))
  ObjITEMw->( dbZAP())
  ObjITEMw1->( dbZAP())

  ::nRezORIG := 0  // Suma nMnozReODB
  ObjItem->( dbGoTOP())
  Do While ! ObjItem->( Eof())
     If ObjItem->nMnozObOdb > 0
        cSklPol := ObjItem->cSklPol
        aAdd( ::anREC, ObjItem->( RecNo()) )
        ::nRezORIG += ObjItem->nMnozReODB
        * edita�n� soubor objedn�vek
        mh_CopyFld( 'ObjItem', 'ObjITEMw', .T., .T. )
        ObjITEMw->nMnozEDIT := IF( ::lKVyrobe, ObjITEM->nMnozVpInt, ObjITEM->nMnozKoDod )

        * origin�ly objedn�vek
        mh_CopyFld( 'ObjItem', 'ObjITEMw1', .T., .T. )
        /*
        * origin�ly skl.polo�ek
        IF ::typREZ = REZ_OBJITEM
           cKey := Upper( ObjItem->cCisSklad) + Upper( ObjItem->cSklPol)
           CenZboz->( dbSEEK( cKey,,3))
           aAdd( ::anCEN, CenZboz->( RecNo()) )
           mh_CopyFld( 'CenZboz', 'CenZbozw', .T. )
        ENDIF
        */
     EndIf
     ObjItem->( dbSkip())
  EndDo
  OBJITEMw->( dbSetRelation( 'Firmy', { || OBJITEMw->nCisFirmy   } ,;
                                          'OBJITEMw->nCisFirmy' ),;
              dbGoTop() )

  ObjItem->( mh_ClrScope())
  *
  oMoment:destroy()
  *
  ::dc:oBrowse[1]:oXbp:refreshAll()
  SetAppFocus( ::dc:oBrowse[1]:oXbp)
  *
  ::KDispozCELK()

RETURN self

* STATIC FUNC SaveREZ_1()
*****************************************************************
METHOD SKL_RezerSklPol:Save_Rezerv()
  Local nKobORIG := 0, nKobEDIT := 0, lOkObj := YES, lOkCen := YES, lOkMn
  Local cTEXT := 'Nelze ulo�it, nebo� do�lo k aktualizaci '

  * Test, zda nedo�lo ke zm�n� hodnot v ObjItem
  ObjITEMw1->( dbGoTop())
  ObjITEMw1->( dbEVAL( {|| ;
             ObjItem->( dbGoTo( ObjITEMw1->_nrecor))        ,;
             lOkMn := IF( ::lKVyrobe, ObjItem->nMnozVpInt == ObjITEMw1->nMnozVpInt,;
                                      ObjItem->nMnozKoDod == ObjITEMw1->nMnozKoDod ) ,;
             lOkObj := IF( lOkMn                                       .AND. ;
                           ObjItem->nMnozReOdb == ObjITEMw1->nMnozReOdb .AND. ;
                           ObjItem->nMnozObOdb == ObjITEMw1->nMnozObOdb .AND. ;
                           ObjItem->nMnozPlOdb == ObjITEMw1->nMnozPlOdb      ,;
                           lOkObj, NO  )   }))
  * Test, zda nedo�lo ke zm�n� hodnot v CenZboz
  lOkCen := IF( CenZboz->nMnozRZBO == CenZbozw->nMnozRZBO .AND. ;
                CenZboz->nMnozDZBO == CenZbozw->nMnozDZBO .AND. ;
                CenZboz->nMnozKZBO == CenZbozw->nMnozKZBO       , lOkCen, NO )

  IF lOkObj .and. lOkCen
    * Aktualizace OBJITEM
    ObjITEMw->( dbGoTop())
    ObjITEMw->( dbEVAL( {|| ;
               ObjItem->( dbGoTo( ObjITEMw->_nrecor))                 ,;
               nKobORIG += ObjItem->nMnozKoDOD                        ,;
               ObjItem->( dbRLock())                                  ,;
               mh_CopyFLD( 'ObjITEMw', 'ObjITEM')                     ,;
               ObjItem->nMnozVpInt := IF( ::lKVyrobe, ObjITEMw->nMnozEDIT, ObjITEMw->nMnozVpInt) ,;
               ObjItem->nMnozKoDod := IF( ::lKVyrobe, ObjITEMw->nMnozKoDod, ObjITEMw->nMnozEDIT ),;
               ObjItem->nMnozReOdb := MAX( 0, ObjItem->nMnozReOdb )   ,;
               ObjItem->nMnozKoDod := MAX( 0, ObjItem->nMnozKoDod )   ,;
               ObjItem->nMnozVpInt := MAX( 0, ObjItem->nMnozVpInt )   ,;
               nKobEDIT += ObjItem->nMnozKoDOD                        ,;
               ObjItem->( dbRUnlock())          }))
/*
               ObjItem->nMnozVpInt := IF( ::lKVyrobe, ObjITEMw->nMnozEDIT, ObjITEMw->nMnozVpInt)
               ObjItem->nMnozKoDod := IF( ::lKVyrobe, ObjITEMw->nMnozKoDod, ObjITEMw->nMnozEDIT )

*/

    ObjItem->( dbCOMMIT())
    ObjITEMw->( dbGoTop())
    * Aktualizace CENZBOZ
    IF ReplRec( 'CenZboz')
       CenZboz->nMnozRZBO := ::nRezEDIT
       CenZboz->nMnozRZBO := MAX( 0, CenZboz->nMnozRZBO)
       CenZboz->nMnozDZBO += ::nRezORIG - ::nRezEDIT
       IF !::lKVyrobe
          CenZboz->nMnozKZBO += - nKobORIG + nKobEDIT
       ENDIF
       CenZboz->( dbUnlock())
    ENDIF
    ::SetObjITEM()
    drgMsgBox(drgNLS:msg( 'P�edisponov�n� rezervac� bylo provedeno !'))
  ELSE
    cText += IIF( !lOkObj .and.  lOkCen, 'objedn�vek p�ijat�ch.',;
             IIF(  lOkObj .and. !lOkCen, 'cen�ku.'              ,;
             IIF( !lOkObj .and. !lOkCen, 'objedn�vek i cen�ku.' , '' )))
    drgMsgBox(drgNLS:msg( cText))
  ENDIF

RETURN self

* K dispozici celkem pro skl.polo�ku ve v�ech obj.p�ijat�ch
********************************************************************************
METHOD SKL_RezerSklPol:KDispozCELK()
  Local nRec := ObjITEMw->( RecNo())

  * Suma nov� vyeditovan�ch rezerva�n�ch mn. nMnozReODB
  ::nRezEDIT := 0
  ObjITEMw->( dbEVAL( {|| ::nRezEDIT += ObjITEMw->nMnozReODB }),;
              dbGoTo( nREC))
  ::nKDispozCELK := CenZboz->nMnozDZBO + ( ::nRezORIG - ::nRezEDIT)
RETURN self


*  P��stup k objedn�vk�m dle nastaven� v CFG
*===============================================================================
FUNCTION AccesToOBJ( cALIAS)
  Local lOK := NO, nObjPRIJ := SysConfig('Sklady:nObjPrij')  // GetCFG( 'cObjPrij')
  Local lObjTUZEM, cText := 'Nem�te p��stup do ', cSTAT

  IF nObjPRIJ == 1            // Bez p��stupu
     cText += '��dn�ch objedn�vek !'
  ELSEIF FIRMY->( dbSEEK( ( cALIAS)->nCisFIRMY,, 'FIRMY1'))
     cSTAT := ALLTRIM( UPPER( FIRMY->cZkratStat))
     lObjTUZEM := ( cSTAT == 'CZ' )
     IF     nObjPRIJ == 2     // Tuzemsk� obj.
       lOK := lObjTUZEM
       IF( !lOK, cText += 'zahrani�n�ch objedn�vek ( ' + cSTAT + ' ) !', NIL)
     ELSEIF nObjPRIJ == 3     // Zahrani�n� obj.
       lOK := !lObjTUZEM
       IF( !lOK, cText += 'tuzemsk�ch objedn�vek !', NIL)
     ELSEIF nObjPRIJ == 4     // Tuzemsk� i zahrani�n�
       lOK := YES
     ENDIF
  ELSE
    cText += 'objedn�vek - firma neexistuje !'
  ENDIF
  IF( !lOK, drgMsgBox(drgNLS:msg( cText)), NIL )
RETURN lOK