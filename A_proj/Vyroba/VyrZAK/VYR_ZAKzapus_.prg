/*==============================================================================
  VYR_ZAKzapus_.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
  VYR_ZakKUSOV()       ZakKUSOV()         ZakZAP.Prg
  VYR_VyrPolDT()       VyrPolDT()         ZakZAP.Prg
  VYR_SetZAPUSTIT()    SetZAPUSTIT()      Kusov.Prg
  VYR_NewCisObjHEAD    NewCislOb()        ZAKZAP.prg
  VYR_NewCisObjITEM()  NewCislPol()       ZakZAP.Prg
  VYR_PolObjRV()       PolObjRV()         ZakZAP.Prg
  VYR_PrepocetCEN()    PrepocetCEN()      ZakZAP.Prg
==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

* Tvorba zak�zkov�ho kusovn�ku
*===============================================================================
FUNCTION VYR_ZakKUSOV()
  Local lOK, nRec := VyrPOL->( RecNO()), cMsg
  Local cKey := Upper( VyrZak->cCisZakaz) + Upper( VyrZak->cVyrPol)

  IF( lOK := Kusov->( dbSeek( cKey)) )
    * Existuje zak�zkov� kusovn�k, ...
  ELSE
    * Neexistuje zak�zkov� kusovn�k, ...
    cKey := EMPTY_ZAKAZ + VyrZak->cVyrPol
    IF ( lOK := Kusov->( dbSeek( Upper( cKey))) )
      * ... ale existuje nezak�zkov�, tj. bez vztahu na zak�zku
      cMsg := 'K vyr�b�n� polo�ce neexistuje zak�zkov� kusovn�k !;;' + ;
              'Po�adujete jeho vytvo�en� v�etn� postup� z nezak�zkov�ho kusovn�ku t�to polo�ky ?'
      IF drgIsYesNo(drgNLS:msg( cMsg ))
         *  Mechanismus vytvo�en� nezak�zkov�ho kusovn�ku ( Kusov, PolOper, Vyrpol)
         VYR_KusForRV( VyrZak->cCisZakaz, EMPTY_ZAKAZ, VyrZak->cVyrPol, VyrZak->nVarCis, YES )
      ELSE
        cMsg := 'K vyr�b�n� polo�ce neexistuje zak�zkov� kusovn�k, ;' + ;
                'a nen� tedy pro co prov�d�t kontroln� rozpad !'
        drgMsgBox(drgNLS:msg( cMsg ))
        lOK := FALSE
      ENDIF
    ELSE
      * ... neexistuje zak�zkov� ani nezak�zkov� kusovn�k
      cMsg := 'K vyr�b�n� polo�ce neexistuje ani zak�zkov� ani nezak�zkov� kusovn�k !;;' + ;
              'Po�adujete pokra�ovat v zapou�t�n� ?'
      IF drgIsYesNo(drgNLS:msg( cMsg ))
         VYR_KusForRV( VyrZak->cCisZakaz, EMPTY_ZAKAZ, VyrZak->cVyrPol, VyrZak->nVarCis, YES )
         lOK := YES
      ENDIF
    ENDIF
  ENDIF
  VyrPOL->( dbGoTO( nREC))
RETURN( lOK)

* Test na zm�nu po�tu operac� p�i importu dat z TPV
*===============================================================================
FUNCTION VYR_VyrPolDT()
  Local cCisZAKAZ := VyrZAK->cCisZAKAZ, cKEY, N
  Local aZAK := {}, aREC1 := {}, aREC2 := {}, lOK := YES, nCHo
  Local cMsg := 'Chcete pokra�ovat v tomto zapu�t�n� ?'

  VyrPOLDT->( mh_SetScope( Upper( cCisZAKAZ) ) )
    VyrPOLDT->( dbEVAL( {|| ;
    AADD( aZAK, { VyrPolDT->( RecNO()), VyrPolDT->cVyrPOL, VyrPolDT->nVarCIS, VyrPolDT->nCelPocOP}) }))
  VyrPOLDT->( mh_ClrScope(), dbGoTOP())

  cCisZAKAZ := EMPTY_ZAKAZ  // SPACE( 15)
  FOR N := 1 TO LEN( aZAK)
    cKEY := cCisZAKAZ + Upper( aZAK[ N, 2]) + STRZERO( aZAK[ N, 3])
    IF VyrPolDT->( dbSEEK( cKEY))
      IF VyrPolDT->nCelPocOp < aZAK[ N, 4]
         AADD( aREC1, { aZAK[ N, 1], aZAK[ N, 4] } )
      ELSEIF VyrPolDT->nCelPocOp > aZAK[ N, 4]
         AADD( aREC2, { aZAK[ N, 1], aZAK[ N, 4] } )
      ENDIF
    ENDIF
  NEXT
  IF LEN( aREC1) > 0
*!     BROW_DT( aREC1, 1 )
    lOK := drgIsYesNo(drgNLS:msg( cMsg))
  ENDIF
  IF LEN( aREC2) > 0 .AND. lOK
*!    BROW_DT( aREC2, 2 )
    lOK := drgIsYesNo(drgNLS:msg( cMsg))
  ENDIF

RETURN lOK

*
*===============================================================================
FUNCTION VYR_SetZAPUSTIT( lZapustit, nPARAM)
  Local nREC := KusTREE->( RecNO()), nVyrST := KusTREE->nVyrST

  KusTREE->lZapustit := IF( nPARAM == 2, lZapustit, KusTREE->lZapustit )
  KusTREE->( dbSKIP())
*orig  DO WHILE KusTREE->nVyrST > nVyrST
  DO WHILE KusTREE->nVyrST > nVyrST .and. !KusTree->( eof())
     IF nPARAM == 1                     // u v�ech ni���ch        29.4.2002
        KusTREE->lZapustit := lZapustit
     ELSEIF nPARAM == 2                 // u v�ech nejbli���ch ni���ch
         IF KusTREE->nVyrST - 1 == nVyrST .AND. KusTREE->lNakPOL
            KusTREE->lZapustit := lZapustit
         ENDIF
     ENDIF
     KusTREE->( dbSKIP())
  ENDDO
  KusTREE->( dbGoTO( nREC))
RETURN NIL

* Generuje ��slo objedn�vky p�ijat�
*===============================================================================
FUNCTION VYR_NewCisObjHEAD( cCisZakaz)
  Local nCis, cKEY := StrZero( 1, 5) + Upper( cCisZakaz)

  fOrdRec( { 'ObjHead, 2' })
   ObjHEAD ->( mh_SetScope( cKEY) )
     ObjHead->( dbGoBottom())
     nCis := ObjHead->nCislObInt + 1
   ObjHEAD ->( mh_ClrScope())
  fOrdRec()
RETURN( nCis)

* Generuje po�adov� ��slo polo�ky objedn�vky p�ijat�
*===============================================================================
FUNCTION VYR_NewCisObjITEM()
  Local cKey := StrZero( MyFIRMA,5) + VyrZak->cCisZakaz   //StrZero( MyFIRMA, 5) + VyrZak->cCisZakaz
  Local nRec := OBJITEM->( RecNo()), nCis
  Local cTag := OBJITEM->( AdsSetOrder(11))

  OBJITEM->( mh_SetScope( Upper( cKEY)), dbGoBottom() )
    nCis := OBJITEM->nCislPolOb + 1
  OBJITEM->( mh_ClrScope())
  OBJITEM->( AdsSetOrder( cTag), dbGoTo( nRec))
RETURN( nCis)

* Generuje ID polo�ky objedn�vky p�ijat�
*===============================================================================
FUNCTION VYR_PolObjRV()
  Local cKey := ALLTRIM( STR( YEAR( DATE())))
  Local nRec := OBJITEM->( RecNo()), nCis
  Local cTag := OBJITEM->( AdsSetOrder(12))

  OBJITEM->( mh_SetScope( Upper( cKEY)), dbGoBottom() )
    nCis := ObjItem->nPolObjRV + 1
  OBJITEM->( mh_ClrScope())
  OBJITEM->( AdsSetOrder( cTag), dbGoTo( nRec))
RETURN( nCis)

* Kontroln� p�epo�et mno�stv� v CenZboz
*================================================================ 16.5.2003 ====
FUNCTION VYR_PrepocetCEN()
  Local nREC := OBJITEM->( RECNO())
  Local cTAG := OBJITEM->( AdsSetOrder( 4))
  Local cKEY := Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPol)
  Local nMnozRZBO := 0, nMnozKZBO := 0, nMnozDZBO := 0, nMnozRVYR := 0
  Local lRozdil

  OBJITEM->( mh_SetScope( cKEY) )
  ObjItem->( dbEVAL( {||  nMnozRZBO += ObjItem->nMnozReODB ,;
                          nMnozKZBO += ObjItem->nMnozKoDOD   } ))

  nMnozRZBO := ROUND( IF( nMnozRZBO < 0, 0, nMnozRZBO ), 2)
  nMnozKZBO := ROUND( IF( nMnozKZBO < 0, 0, nMnozKZBO ), 2)
  nMnozDZBO := CenZboz->nMnozSZBO - nMnozRZBO
  nMnozDZBO := ROUND( IF( nMnozDZBO < 0, 0, nMnozDZBO ), 2)
  nMnozRVYR := nMnozRZBO
  OBJITEM->( mh_ClrScope())

  lRozdil := nMnozRZBO <> CenZboz->nMnozRZBO .or. nMnozKZBO <> CenZboz->nMnozKZBO .or. ;
             nMnozDZBO <> CenZboz->nMnozDZBO

  //- aktualizuje Cenik zbo��
  IF lRozdil
     CenZboz->nMnozRZBO  := nMnozRZBO   // Mn. rezervov�no
     CenZboz->nMnozKZBO  := nMnozKZBO   // Mn. k objedn�n�
     CenZboz->nMnozDZBO  := nMnozDZBO   // Mn. k dispozici
     CenZboz->nMnozRSES  := nMnozRVYR   // Mn. rezervov�no pro v�robu
  ENDIF
  ObjITEM->( AdsSetOrder( cTAG), dbGoTO( nREC) )
RETURN NIL