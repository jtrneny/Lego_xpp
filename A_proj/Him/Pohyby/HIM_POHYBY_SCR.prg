********************************************************************************
* HIM_POHYBY_SCR.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\HIM\HIM_Him.ch"

********************************************************************************
* HIM_POHYBY_SCR ... Pohybové doklady - dle dokladù
********************************************************************************
CLASS HIM_POHYBY_SCR FROM drgUsrClass
EXPORTED:
  VAR     isHIM, fiZMAJU, fiMAJ, cTASK

  METHOD  Init, ItemMarked, drgDialogStart
  METHOD  VYBER_POHYB, Odpisy_GEN

  Inline Access Assign  METHOD IsDoklad_LIK() VAR IsDoklad_LIK
   RETURN  IF( (::fiZMAJU)->nLikCelDok = 0, '  ', 'L ')

ENDCLASS

*
********************************************************************************
METHOD HIM_POHYBY_SCR:init(parent, cTASK)

  ::drgUsrClass:init(parent)
  *
  DEFAULT cTASK TO 'HIM'
  ::cTASK := cTASK
  IF  ::isHIM := ( ::cTASK = 'HIM')
    drgDBMS:open('ZMAJU'   ) ; ZMAJU->( AdsSetOrder(3))
    drgDBMS:open('MAJ'     ) ; MAJ->( AdsSetOrder(1))
    drgDBMS:open('C_TYPMAJ')
    ZMAJU->( DbSetRelation( 'C_TypMaj', { || ZMAJU->nTypMaj } ,'ZMAJU->nTypMaj'))
  ELSE
    drgDBMS:open('ZMAJUZ'  ) ; ZMAJUZ->( AdsSetOrder(3))
    drgDBMS:open('MAJZ'    ) ; MAJZ->( AdsSetOrder(1))
    drgDBMS:open('C_UCTSKZ')
    ZMAJUZ->( DbSetRelation( 'C_UCTSKZ', { || ZMAJUZ->nUcetSkup },'ZMAJUz->nUcetSkup'))
  ENDIF
  ::fiZMAJU := IF( ::isHIM, 'ZMAJU', 'ZMAJUZ')
  ::fiMAJ   := IF( ::isHIM, 'MAJ'  , 'MAJZ'  )
  drgDBMS:open('C_TYPPOH')
  (::fiZMAJU)->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU))', 'C_TYPPOH05'))

RETURN self

********************************************************************************
METHOD HIM_POHYBY_SCR:drgDialogStart(drgDialog)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN self

********************************************************************************
METHOD HIM_POHYBY_SCR:ItemMarked()
  LOCAL cKEY

  IF ::isHIM
    cKEY := StrZero( ZMAJU->nTypMAJ,3 ) + StrZERO( ZMAJU->nInvCis, 15)
    MAJ->( dbSEEK( cKEY,,'MAJ01'))
  ELSE
    cKEY := StrZero( ZMAJUZ->nUcetSkup,3 ) + StrZERO( ZMAJUZ->nInvCis, 15)
    MAJZ->( dbSEEK( cKEY,,'MAJZ_01'))
  ENDIF
RETURN SELF

* Tlaèítko: Tvorba dokladù
********************************************************************************
METHOD HIM_Pohyby_SCR:Vyber_POHYB()
  Local oDialog
  Local nREC := (::fiZMAJU)->( RecNO()), cTag := (::fiZMAJU)->( AdsSetOrder())

  IF (::fiMAJ)->nInvCis = 0
    drgMsgBox(drgNLS:msg( 'Karta investièního majetku není k didpozici - NELZE k ní tedy dìlat pohyby ...' ))
    RETURN NIL
  ENDIF

*  DRGDIALOG FORM 'HIM_POHYBY_CRD,' + ::cTASK PARENT ::drgDialog MODAL DESTROY
  DRGDIALOG FORM ::cTASK + '_POHYBY_CRD' PARENT ::drgDialog MODAL DESTROY
  *
  (::fiZMAJU)->( mh_ClrSCOPE(), AdsSetOrder( cTag), dbGoTO( nRec) )
  ::itemMarked()

RETURN Self

* Tlaèítko: Úèetní odpisy
********************************************************************************
METHOD HIM_Pohyby_SCR:ODPISY_gen()
  Local OdpisyGen

  OdpisyGen := HIM_ODPISY_gen():New( self, ::cTASK)

RETURN Self