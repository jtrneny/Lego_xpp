********************************************************************************
* ZVI_zsbLikvid_SCR.PRG   ... Likvidace zásobových zvíøat
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\Zvirata\ZVI_Zvirata.ch"

********************************************************************************
* ZVI_zsbLikvDOK_SCR ... Likvidace dle dokladù
********************************************************************************
CLASS ZVI_zsbLikvDOK_SCR FROM drgUsrClass

EXPORTED:
  METHOD  Init, Destroy, drgDialogStart, ItemMarked
  METHOD  Preuctuj

HIDDEN:
  VAR     cDenik
ENDCLASS

********************************************************************************
METHOD ZVI_zsbLikvDOK_SCR:init(parent)
  *
  ::drgUsrClass:init(parent)
  drgDBMS:open('C_TYPPOH')
  *
  ::cDenik := Padr( SysConfig( 'Zvirata:cDenikZvZ'), 2)
RETURN self

********************************************************************************
METHOD ZVI_zsbLikvDOK_SCR:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ZvZmenHD->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },;
                                         'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU))', 'C_TYPPOH05'))
RETURN self

********************************************************************************
METHOD ZVI_zsbLikvDOK_SCR:ItemMarked()
  Local cScope := Upper( ::cDenik) + StrZero( ZvZmenHD->nDoklad, 10) +;
                  StrZERO( ZvZmenHD->nOrdItem, 5)

  UcetPOL->( mh_SetScope( cScope))
RETURN SELF

********************************************************************************
METHOD ZVI_zsbLikvDOK_SCR:destroy()
  ::drgUsrClass:destroy()
  ::cDenik := nil
  UcetPOL->( mh_ClrScope())
RETURN self

********************************************************************************
METHOD ZVI_zsbLikvDOK_SCR:preUctuj(parent)
  local aselect, n, all, oMoment, cMsg

  aselect := ::drgdialog:odBrowse[1]:arselect
  all     := ::drgdialog:odBrowse[1]:is_selAllRec
  *
  cMsg := if( all .or. !empty( aselect), 'Úètuji vybrané doklady ...',;
                                         'Úètuji vybraný doklad ...'  )
  oMoment := SYS_MOMENT( cMsg)

  do case
  case all
    *
    do while .not. ZvZmenHD->( Eof())
      if AScan(aselect,{|x| x == ZvZmenHD->(recno())}) = 0
        Preuctuj_ZSB( )
      endif
      ZvZmenHD->( dbSkip())
    enddo

  case .not. Empty(aselect)
    for n:= 1 to Len(aselect)
      ZvZmenHD->( dbGoTo(aselect[n]))
      Preuctuj_ZSB()
    next
  otherwise
    Preuctuj_ZSB()
  endcase
  oMoment:destroy()
  *
  ::itemMarked()
  ::drgdialog:odBrowse[2]:refresh()

RETURN .T.


********************************************************************************
* ZVI_zsbLikvUCT_SCR ... Likvidace dle úèetních pøedpisù
********************************************************************************
CLASS ZVI_zsbLikvUCT_SCR FROM drgUsrClass

EXPORTED:
  METHOD  Init, Destroy, ItemMarked, drgDialogStart
ENDCLASS

********************************************************************************
METHOD ZVI_zsbLikvUCT_SCR:init(parent)
  Local cDenik, Filter

  ::drgUsrClass:init(parent)
  drgDBMS:open('ZvKarty') ; ZvKarty->( AdsSetOrder( 1))
RETURN self

********************************************************************************
METHOD ZVI_zsbLikvUCT_SCR:destroy()
  ::drgUsrClass:destroy()
  UCETPOL->( mh_ClrFILTER())
  ZvZmenHD->( mh_ClrScope())
  ZvKarty->( mh_ClrScope())
RETURN self

********************************************************************************
METHOD ZVI_zsbLikvUCT_SCR:drgDialogStart(drgDialog)
  Local cDenik, Filter
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  cDenik := SysConfig( 'Zvirata:cDenikZvZ')
  Filter := FORMAT("Upper(cDenik) = '%%'", { Upper(cDenik)} )
  UCETPOL->( mh_SetFilter( Filter))
  *
  ZvZmenHD->( AdsSetOrder( 3))
RETURN self

********************************************************************************
METHOD ZVI_zsbLikvUCT_SCR:ItemMarked()
  Local cScope := StrZero( UcetPOL->nDoklad, 10) + StrZero( UcetPOL->nOrdItem, 5)
  *
  ZvZmenHD ->( mh_SetScope( cScope ))
  *
  cScope := Upper(ZvZmenHD->cNazPol1) + Upper(ZvZmenHD->cNazPol4) + StrZero( ZvZmenHD->nZvirKat, 6)
  ZvKarty->( mh_SetScope( cScope))
RETURN SELF

*===============================================================================
FUNCTION Preuctuj_ZSB()
  local  cFile := 'ZvZmenHD', cFileW := cFile + 'w', uctLikv
  local  obdDokl := Strzero( ZvZmenHD->nrok,4) + Strzero( ZvZmenHD->nobdobi,2)

  drgDBMS:open( cFileW, .T.,.T.,drgINI:dir_USERfitm); ZAP
  mh_COPYFLD( cFile, cFileW, .T.,,, .F.)
  *
  uctLikv  := UCT_likvidace():New(upper((cFileW)->cUloha) +upper((cFileW)->ctypdoklad),.t.)
  ucetpolw->(dbcommit(),dbgotop())
  *
*  Ucetsys_ks( obdDokl)
  *
  (cFile)->(dbunlock(), dbcommit())
  ucetpol->(dbunlock(), dbcommit())

Return nil