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
CLASS VYR_VyrZak_Fakt_SCR FROM  drgUsrClass   // VYR_VyrZak_SCR
EXPORTED:
  VAR    VyrZakSCR
  METHOD Init, Destroy, ZAK_FAKTMNOZ

  * bro vyrZak
  * bro fakvysit
  inline access assign method cenPol() var cenPol
    return if(fakvysit->cpolcen = 'C', MIS_ICON_OK, 0)

  * bro fakvnpit


  inline method ItemMarked()
    local  cky := upper(vyrZak->ccisZakaz)

    fakVysit->(AdsSetOrder('FVYSIT10'), dbsetscope(SCOPE_BOTH, cky), dbGotop())
    fakVnpit->(AdsSetOrder('FVYSIT6' ), dbsetscope(SCOPE_BOTH, cky), dbGotop())


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
METHOD VYR_VyrZak_Fakt_SCR:Init( parent)
//  ::VyrZakSCR := VYR_VyrZak_SCR():new( parent)

  ::drgUsrClass:init(parent)
RETURN self

********************************************************************************
METHOD VYR_VyrZak_Fakt_SCR:Destroy()
//  ::VyrZakSCR:destroy()
  ::VyrZakSCR := NIL
RETURN self

* Materiál ( žádanky) na zakázku - pomocná funkce pro sestavy
*===============================================================================
FUNCTION VYR_MatForZAK( nPrm)
  Local nTag, cZak

  drgDBMS:open('OBJITEM' )
  drgDBMS:open('OBJITEMw'  ,.T.,.T.,drgINI:dir_USERfitm ); ZAP
  *
  IF nPrm = 1        // nad VyrZAK
    nTag := 14
    cZak := Upper( VyrZAK->cCisZakaz)
  ELSEIF nPrm = 2   // nad VyrZAKIT
    nTag := 19
    cZak := Upper( VyrZAKIT->cCisZakazI)
  ENDIF
  *
  ObjITEM->( AdsSetOrder( nTag), mh_SetScope( cZak ))
  DO WHILE !ObjITEM->( EOF())
    mh_CopyFLD( 'ObjITEM',  'ObjITEMw', .T.)
    ObjITEM->( dbSkip())
  ENDDO
  ObjITEMw->( dbGoTOP())
  ObjITEM->( mh_ClrScope())
RETURN NIL

*===============================================================================
*FUNCTION ZAK_FAKTMNOZ()
METHOD VYR_VyrZak_Fakt_SCR:ZAK_FAKTMNOZ()
  Local cScope, lRozdil := .F., lZmena, lDO
  Local nSuma_ZakIT, nSuma_FakIT

  IF drgIsYESNO(drgNLS:msg( 'Provést kontrolu fakturovaného množství na zakázku ?' ))
    drgDBMS:open('VyrZAK'  ,,,,, 'VyrZAKa'  )
    drgDBMS:open('VyrZAKIT',,,,, 'VyrZakITa')
    VyrZAKITa->( AdsSetOrder( 1))
    drgDBMS:open('FakVysIT',,,,, 'FakVysITa')
    FakVysITa->( AdsSetOrder( 12))  // new tag cCisZakazI
    *
    drgDBMS:open('VYRZAKw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('VYRZAKITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    *
    VyrZAKa->( dbGoTOP())

    drgServiceThread:progressStart(drgNLS:msg('Provádím kontrolu fakturovaného množství na zakázku  ...', 'VyrZAKa'), VyrZAKa->(LASTREC()) )

    DO WHILE !VyrZAKa->( EOF())
      lDO := (( VyrZAKa->cStavZakaz <> 'U ' ) .or. ;
              ( VyrZAKa->cStavZakaz =  'U ' .and. VyrZAKa->dUzavZaka > CTOD('31.08.2007') ))

      IF lDO
        cScope := Upper( VyrZAKa->cCisZakaz)
        VyrZakITa->( mh_SetScope( cScope))
        nSuma_ZakIT := 0
        DO WHILE !VyrZAKITa->( EOF())
          cScope := Upper( VyrZAKITa->cCisZakazI)
          FakVysITa->( mh_SetScope( cScope))
          nSuma_FakIT := 0
          DO WHILE !FakVysITa->( EOF())
            nSuma_FakIT += FakVysITa->nFaktMnoz
            FakVysITa->( dbSKIP())
          ENDDO
          FakVysITa->( mh_ClrScope())
          *
          lRozdil := .F.
          IF VyrZAKITa->nMnozFakt <> nSuma_FakIT
            * zápis nìkam
            lRozdil := .T.
            mh_CopyFLD( 'VyrZAKITa', 'VyrZakITw', .t. )
            VyrZakITw->nSumFaktMn := nSuma_FakIT
            VyrZakITw->_nrecor    := VyrZakITa->( RecNO())
          ENDIF
          nSuma_ZakIT += nSuma_FakIT

          VyrZAKITa->( dbSKIP())
        ENDDO
        VyrZAKITa->( mh_ClrScope())
        *
        lRozdil := .F.
        IF  VyrZAKa->nMnozFakt <> nSuma_ZakIT
          lRozdil := .T.
          * zápis nìkam
          mh_CopyFLD( 'VyrZAKa', 'VyrZAKw', .t. )
          VyrZAKw->nSumFaktMn := nSuma_ZakIT
          VyrZAKw->_nrecor    := VyrZAKa->( RecNO())
        ENDIF
      ENDIF
      *
      VyrZAKa->( dbSKIP())
      *
      drgServiceThread:progressInc()
    ENDDO
    *
    drgServiceThread:progressEnd()
    Tone(300,3)
    *
    DRGDIALOG FORM 'VYR_VYRZAK_FAKT_CTRL' PARENT ::drgDialog MODAL DESTROY

  ENDIF
RETURN SELF



********************************************************************************
* Výrobní zakázky dle Fakturace - kontrolní obrazovka
********************************************************************************
CLASS VYR_VyrZak_Fakt_CTRL FROM drgUsrClass
EXPORTED:
*  VAR    nSumFakIT, nSumZakIT
  METHOD Init, Destroy, drgDialogStart, drgDialogEnd, vyrzak_modi

  INLINE METHOD  ItMarked_ZAKIT()
    VyrZakITw->( mh_SetScope( Upper(VYRZAKw->cCisZakaz)))
    FakVysIT->( mh_SetScope( Upper(VYRZAKITw->cCisZakazI)))
    ::sumColumn()
  RETURN SELF

  INLINE METHOD  ItMarked_FAKIT()
    FakVysIT->( mh_SetScope( Upper(VYRZAKITw->cCisZakazI)))
    ::sumColumn()
  RETURN SELF

HIDDEN
  VAR     dc, dm, broZakIT, broFakIT
  METHOD  sumColumn
ENDCLASS

********************************************************************************
METHOD VYR_VyrZak_Fakt_CTRL:Init( parent)
RETURN self

********************************************************************************
METHOD VYR_VyrZak_Fakt_CTRL:Destroy()
  ::dc := ::dm := ::broZakIT := ::broFakIT := Nil
RETURN self

********************************************************************************
METHOD VYR_VyrZak_Fakt_CTRL:sumColumn()
  LOCAL nRecV := VyrZakITw->( RecNo()), nRecF := FakVysIT->( RecNo())
  Local nSumFakIT := 0.00, nSumZakIT := 0.00, nPos
  Local aItems, x

  VyrZakITw->( dbGoTOP(),;
               dbEVAL( {|| nSumZakIT += VyrZakITw->nMnozFakt }),;
               dbGoTO( nRecV) )
  FakVysIT->( dbGoTOP(),;
              dbEVAL( {|| nSumFakIT += FakVysIT->nFaktMnoz }),;
              dbGoTO( nRecF) )

  aItems := { {'VyrZakITw->nMnozFakt', nSumZakIT, ::broZakIT },;
              {'FakVysIT->nFaktMnoz' , nSumFakIT, ::broFakIT } }

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
METHOD VYR_VyrZak_Fakt_CTRL:drgDialogStart(drgDialog)

  ::dc       := drgDialog:dialogCtrl
  ::dm       := drgDialog:dataManager
  ::broZakIT := ::dc:oBrowse[2]
  ::broFakIT := ::dc:oBrowse[3]
  *
RETURN self

********************************************************************************
METHOD VYR_VyrZak_Fakt_CTRL:drgDialogEnd( drgDialog)

  FakVysIT->( mh_ClrScope(), AdsSetOrder(5) )
RETURN

********************************************************************************
METHOD VYR_VyrZak_Fakt_CTRL:vyrzak_modi( parent)
  LOCAL nRecHD := VyrZakITw->( RecNo()), nRecIT := VyrZakITw->( RecNo())
  Local hdLock, itLock

  IF drgIsYESNO(drgNLS:msg( 'Chcete pøepsat fakt.množství na zakázce novými hodnotami ?'))

    hdLock := VyrZAK->( FLOCK())
    itLock := VyrZAKIT->( FLOCK())
    IF hdLock .and. itLock

      VyrZAKw->( AdsSetOrder( 0), dbGoTOP(),;
                 dbEval( {|| VyrZak->( dbGoTo( VyrZAKw->_nrecor)),;
                             VyrZak->nMnozFakt := VyrZAKw->nSumFaktMn }) ,;
                  AdsSetOrder( 1), dbGoTO( nRecHD))

      VyrZAKITw->( AdsSetOrder( 0), dbGoTOP(),;
                   dbEval( {|| VyrZakIT->( dbGoTo( VyrZAKITw->_nrecor)),;
                               VyrZakIT->nMnozFakt := VyrZAKITw->nSumFaktMn }) ,;
                   AdsSetOrder( 1), dbGoTO( nRecIT))

      drgMsgBox(drgNLS:msg( 'Zpracování ukonèeno ... '))
    ELSE
      drgMsgBox(drgNLS:msg( 'Soubory zakázek jsou blokovány jiným uživatelem ... '))
    ENDIF
    IF( hdLock, VyrZAK->( dbUnLock()), NIL )
    IF( itLock, VyrZAKIT->( dbUnLock()), NIL )

  ENDIF
RETURN self
