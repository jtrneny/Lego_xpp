***************************************************************************
*
* SKL_Likvidace_SCR.PRG
*
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\SKLADY\SKL_Sklady.ch"

*****************************************************************
* SKL_LikvPOL_SCR ... Likvidace dle položek dokladù
*****************************************************************
CLASS SKL_LikvPOL_SCR FROM drgUsrClass

EXPORTED:
  METHOD  Init, ItemMarked

HIDDEN:
  VAR     cDenik
ENDCLASS

*
*****************************************************************
METHOD SKL_LikvPOL_SCR:init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('PVPHEAD')
  drgDBMS:open('PVPITEM')
  drgDBMS:open('C_DRPOHY')
  drgDBMS:open('C_TYPPOH')
  drgDBMS:open('UCETPOL')
  *
  PVPHEAD->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU))', 'C_TYPPOH05'))
  ::cDenik := Padr( SysConfig( 'Sklady:cDenik'), 2)
RETURN self

*
*****************************************************************
METHOD SKL_LikvPOL_SCR:ItemMarked()
  Local cScope := Upper( ::cDenik) + StrZero( PVPITEM->nDoklad, 10) +;
                  StrZERO( PVPITEM->nOrdItem, 5)
  UCETPOL->( mh_SetScope( cScope))
  PVPHEAD->( dbSEEK( PVPITEM->nDoklad,,'PVPHEAD01'))
RETURN SELF

*****************************************************************
* SKL_LikvDOKL1_SCR ... Likvidace za doklad po položkách
*****************************************************************
CLASS SKL_LikvDOKL1_SCR FROM drgUsrClass

EXPORTED:
  METHOD  Init, ItemMarkedHD, itemMarkedIT
  METHOD  preUctuj

  inline method drgDialogStart(drgDialog)
    ::brow :=  drgDialog:dialogCtrl:oBrowse
    return self

HIDDEN:
  VAR     cDenik, brow
ENDCLASS

*
*****************************************************************
METHOD SKL_LikvDOKL1_SCR:init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('PVPHEAD')
  drgDBMS:open('PVPITEM')
  drgDBMS:open('TYPDOKL')
  drgDBMS:open('C_TYPPOH')
  drgDBMS:open('UCETPOL')
  *
  PVPHEAD->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU))', 'C_TYPPOH05'))
  PVPHEAD->( DbSetRelation( 'TYPDOKL', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) },'UPPER(cULOHA)+UPPER(cTYPDOKLAD))', 'TYPDOKL02'))
  ::cDenik    := Padr( SysConfig( 'Sklady:cDenik'), 2)
RETURN self

*
*****************************************************************
METHOD SKL_LikvDOKL1_SCR:ItemMarkedHD()

  PVPITEM->( mh_SetScope( PVPHEAD->nDoklad))
  ::itemMarkedIT()
RETURN SELF

*****************************************************************
METHOD SKL_LikvDOKL1_SCR:ItemMarkedIT()
  Local cScope := Upper( ::cDenik) + StrZero( PVPHEAD->nDoklad, 10) + StrZERO( PVPITEM->nOrdItem, 5)

  UCETPOL->( mh_SetScope( cScope))
RETURN SELF


METHOD SKL_LikvDOKL1_SCR:preUctuj(parent)
  local aselect, n, all, oMoment, cMsg
  local tag, recno, key

  aselect := ::drgdialog:odBrowse[1]:arselect
  all     := ::drgdialog:odBrowse[1]:is_selAllRec
  *
  cMsg := if( all .or. !empty( aselect), 'Úètuji vybrané doklady ...',;
                                         'Úètuji vybraný doklad ...'  )
  oMoment := SYS_MOMENT( cMsg)
  recno  := PVPHead->( Recno())
//  tag    := PVPItem->( OrdSetFocus('nPVPHEAD'))
  tag    := PVPItem->( OrdSetFocus('PVPITEM29'))

  do case
  case all
    do while .not. PVPHead->( Eof())
      if AScan(aselect,{|x| x == pvphead->(recno())}) = 0
//        PVPITEM->( mh_SetScope( PVPHEAD->nDoklad))
//        PVPITEM->( mh_SetScope( PVPHEAD->sID))
        key := StrZero(pvphead->nrok,4) +Upper(pvphead->ctyppohybu) +StrZero(pvphead->ndoklad,10)
        PVPITEM->( mh_SetScope( key))
        SklPreuctuj()
      endif
      PVPHead->( dbSkip())
    enddo
  case .not. Empty(aselect)
    for n:= 1 to Len(aselect)
      PVPHead->( dbGoTo(aselect[n]))
//      PVPITEM->( mh_SetScope( PVPHEAD->nDoklad))
//      PVPITEM->( mh_SetScope( PVPHEAD->sID))
      key := StrZero(pvphead->nrok,4) +Upper(pvphead->ctyppohybu) +StrZero(pvphead->ndoklad,10)
      PVPITEM->( mh_SetScope( key))
      SklPreuctuj()
    next
  otherwise
//    PVPITEM->( mh_SetScope( PVPHEAD->sID))
    key := StrZero(pvphead->nrok,4) +Upper(pvphead->ctyppohybu) +StrZero(pvphead->ndoklad,10)
    PVPITEM->( mh_SetScope( key))
    SklPreuctuj()
  endcase
  oMoment:destroy()

  PVPItem->( OrdSetFocus(tag))
  PVPHead->( dbGoTo( recno))

  ::itemMarkedHD()
  ( ::brow[2]:oxbp:refreshAll(), ::brow[3]:oxbp:refreshAll() )
RETURN .T.


*****************************************************************
* SKL_LikvDOKL2_SCR ... Likvidace za doklad celkem
*****************************************************************
CLASS SKL_LikvDOKL2_SCR FROM drgUsrClass

EXPORTED:
  METHOD  Init, ItemMarked

HIDDEN:
  VAR     cDenik
ENDCLASS

*
*****************************************************************
METHOD SKL_LikvDOKL2_SCR:init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('PVPHEAD')
  drgDBMS:open('C_DRPOHY')
  drgDBMS:open('UCETPOL')
  *
  PVPHEAD->( DbSetRelation( 'C_DRPOHY', { || PVPHEAD->nCislPoh },'PVPHEAD->nCislPoh'))
  ::cDenik := Padr( SysConfig( 'Sklady:cDenik'), 2)
RETURN self

*
*****************************************************************
METHOD SKL_LikvDOKL2_SCR:ItemMarked()
  Local cScope := Upper( ::cDenik) + StrZero( PVPHEAD->nDoklad, 10)

 UCETPOL->( mh_SetScope( cScope))
RETURN SELF

*****************************************************************
* SKL_LikvUCT_SCR ... Likvidace dle úèetních pøedpisù
*****************************************************************
CLASS SKL_LikvUCT_SCR FROM drgUsrClass

EXPORTED:
  METHOD  Init
  METHOD  Destroy
  METHOD  ItemMarked

ENDCLASS

*
*****************************************************************
METHOD SKL_LikvUCT_SCR:init(parent)
  Local cDenik, Filter

  ::drgUsrClass:init(parent)
  drgDBMS:open('PVPHEAD')  ; PVPHEAD->( AdsSetOrder( 1))
  drgDBMS:open('PVPITEM')  ; PVPITEM->( AdsSetOrder( 2))
  drgDBMS:open('C_DRPOHY')
  drgDBMS:open('UCETPOL')
  *
  PVPHEAD->( DbSetRelation( 'C_DRPOHY', { || PVPHEAD->nCislPoh },'PVPHEAD->nCislPoh'))
  cDenik := SysConfig( 'Sklady:cDenik')
**  Filter := FORMAT("cDenik == '%%'", { cDenik} )
  Filter := FORMAT("Upper(cDenik) = '%%'", { Upper(cDenik)} )
  UCETPOL->( mh_SetFilter( Filter))
**  UCETPOL->( dbSetFILTER( COMPILE( Filter)))
RETURN self

*
*****************************************************************
METHOD SKL_LikvUCT_SCR:destroy()
  ::drgUsrClass:destroy()
  UCETPOL->( mh_ClrFILTER())
RETURN self

*
*****************************************************************
METHOD SKL_LikvUCT_SCR:ItemMarked()
  Local cAlias := ::drgDialog:dialogCtrl:oBrowse[1]:cFile
  Local cScope

  PVPHEAD ->( mh_SetScope( UCETPOL->nDoklad))

  cScope := Upper( PVPHEAD->cCisSklad) + StrZero( PVPHEAD->nDoklad, 10) + ;
            StrZero( UcetPOL->nOrdItem, 5)
  PVPITEM->( mh_SetScope( cScope))
RETURN SELF