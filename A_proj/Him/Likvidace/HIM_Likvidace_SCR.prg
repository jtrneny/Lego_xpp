********************************************************************************
*
* HIM_Likvidace_SCR.PRG
*
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\HIM\HIM_HIM.ch"


********************************************************************************
* HIM_LikvDOK_SCR ... Likvidace dle dokladù
********************************************************************************
CLASS HIM_LikvDOK_SCR FROM drgUsrClass, HIM_Main

EXPORTED:
  METHOD  Init, Destroy, ItemMarked, drgDialogStart
  METHOD   Preuctuj

HIDDEN:
  VAR     cDenik
ENDCLASS

********************************************************************************
METHOD HIM_LikvDOK_SCR:init(parent, cTASK)

  DEFAULT cTASK TO 'HIM'
  ::drgUsrClass:init(parent)
  *
  ::HIM_Main:Init( parent, cTASK = 'HIM')
  drgDBMS:open( ::fiMAJ   )  ; AdsSetOrder(1)
  drgDBMS:open( ::fiZMAJU )
  drgDBMS:open( ::fiCIS   )
  drgDBMS:open('UCETPOL' )
*  (::fiZMAJU)->( DbSetRelation( ::fiCIS, { || (::fiZMAJU)->nDrPohyb }, ::fiZMAJU + '->nDrPohyb'))
  (::fiZMAJU)->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU))', 'C_TYPPOH05'))
  IF  ::isHIM
    drgDBMS:open('C_TypMAJ')
    ZMAJU->( DbSetRelation( 'C_TypMaj', { || ZMAJU->nTypMaj } ,'ZMAJU->nTypMaj'))
    ::cDenik := Padr(SysConfig( 'IM:cDenikIM'), 2)
  ELSE
    drgDBMS:open('C_UctSkZ')
    ZMAJUZ->( DbSetRelation( 'C_UctSkZ', { || ZMAJUZ->nUcetSkup } ,'ZMAJUZ->nUcetSkup'))
    ::cDenik := Padr( SysConfig( 'Zvirata:cDenikZv'), 2)
  ENDIF

RETURN self

********************************************************************************
METHOD HIM_LikvDOK_SCR:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN self

********************************************************************************
METHOD HIM_LikvDOK_SCR:ItemMarked()
  Local cScope := Upper( ::cDenik) + StrZero( (::fiZMAJU)->nDoklad, 10) +;
                  StrZERO( (::fiZMAJU)->nOrdItem, 5)

  UcetPOL->( mh_SetScope( cScope))
  *
  cScope := IF( ::isHIM, StrZero( ZMAJU->nTypMAJ,3 ), StrZero( ZMAJUZ->nUcetSkup,3 )) + ;
                StrZERO( (::fiZMAJU)->nInvCis, 15)

  (::fiMAJ)->( mh_SetScope( cScope))

RETURN SELF

********************************************************************************
METHOD HIM_LikvDOK_SCR:destroy()
  ::drgUsrClass:destroy()
  (::fiMAJ)->( mh_ClrScope())
  UcetPOL->( mh_ClrScope())
RETURN self

********************************************************************************
METHOD HIM_LikvDOK_SCR:preUctuj(parent)
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
    do while .not. ZMAJU->( Eof())
      if AScan(aselect,{|x| x == ZMAJU->(recno())}) = 0
        Preuctuj_HIM( ::isHIM )
      endif
      ZMAJU->( dbSkip())
    enddo

  case .not. Empty(aselect)
    for n:= 1 to Len(aselect)
      ZMAJU->( dbGoTo(aselect[n]))
      Preuctuj_HIM( ::isHIM)
    next
  otherwise
    Preuctuj_HIM( ::isHIM)
  endcase
  oMoment:destroy()
  *
  ::itemMarked()
  ::drgdialog:odBrowse[2]:refresh()

RETURN .T.


********************************************************************************
* HIM_LikvMAJ_SCR ... Likvidace dle MAJETKU
********************************************************************************
CLASS HIM_LikvMAJ_SCR FROM drgUsrClass, HIM_Main

EXPORTED:
  METHOD  Init, Destroy, drgDialogStart, ItMarked_MAJ, ItMarked_ZMAJU

HIDDEN:
  VAR     cDenik
ENDCLASS

*
********************************************************************************
METHOD HIM_LikvMAJ_SCR:init(parent, cTASK)

  DEFAULT cTASK TO 'HIM'
  ::drgUsrClass:init(parent)
  *
  ::HIM_Main:Init( parent, cTASK = 'HIM')
  drgDBMS:open( ::fiZMAJU )
  drgDBMS:open( ::fiCIS   )
  drgDBMS:open('UCETPOL')
*  (::fiZMAJU)->( DbSetRelation( ::fiCIS, { || (::fiZMAJU)->nDrPohyb }, ::fiZMAJU + '->nDrPohyb'))
  (::fiZMAJU)->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU))', 'C_TYPPOH05'))
  IF  ::isHIM
    drgDBMS:open('C_TypMAJ')
    ZMAJU->( DbSetRelation( 'C_TypMaj', { || ZMAJU->nTypMaj } ,'ZMAJU->nTypMaj'))
    ::cDenik := Padr( SysConfig( 'IM:cDenikIM'), 2)
  ELSE
    drgDBMS:open('C_UctSkZ')
    ZMAJUZ->( DbSetRelation( 'C_UctSkZ', { || ZMAJUZ->nUcetSkup } ,'ZMAJUZ->nUcetSkup'))
    ::cDenik := Padr( SysConfig( 'Zvirata:cDenikZv'), 2)
  ENDIF

RETURN self

********************************************************************************
METHOD HIM_LikvMAJ_SCR:drgDialogStart(drgDialog)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN self

*****************************************************************
METHOD HIM_LikvMAJ_SCR:ItMarked_MAJ()
  Local cScope := IF( ::isHIM, StrZero( MAJ->nTypMAJ,3 ), StrZero( MAJZ->nUcetSkup,3 )) + ;
                      StrZERO( (::fiMAJ)->nInvCis, 15)
  (::fiZMAJU)->( mh_SetScope( cScope))
  *
  ::itMarked_zmaju()
RETURN SELF

********************************************************************************
METHOD HIM_LikvMAJ_SCR:ItMarked_ZMAJU()
  Local cScope := Upper( ::cDenik) + StrZero( (::fiZMAJU)->nDoklad, 10) +;
                  StrZERO( (::fiZMAJU)->nOrdItem, 5)
  *
  UCETPOL->( mh_SetScope( cScope))
RETURN SELF

********************************************************************************
METHOD HIM_LikvMAJ_SCR:destroy()
  ::drgUsrClass:destroy()
  (::fiZMAJU)->( mh_ClrScope())
  UcetPOL->( mh_ClrScope())
RETURN self


********************************************************************************
* HIM_LikvUCT_SCR ... Likvidace dle úèetních pøedpisù
********************************************************************************
CLASS HIM_LikvUCT_SCR FROM drgUsrClass, HIM_Main

EXPORTED:
  METHOD  Init, Destroy, ItemMarked, drgDialogStart
ENDCLASS

********************************************************************************
METHOD HIM_LikvUCT_SCR:init(parent, cTASK)
  Local cDenik, Filter

  DEFAULT cTASK TO 'HIM'
  ::drgUsrClass:init(parent)
  *
  ::HIM_Main:Init( parent, cTASK = 'HIM')
  drgDBMS:open( ::fiMAJ   )  ; AdsSetOrder(1)
  drgDBMS:open( ::fiZMAJU )  ; AdsSetOrder(3)
  drgDBMS:open( ::fiCIS   )
  drgDBMS:open('UCETPOL' )
*  (::fiZMAJU)->( DbSetRelation( ::fiCIS, { || (::fiZMAJU)->nDrPohyb }, ::fiZMAJU + '->nDrPohyb'))
  (::fiZMAJU)->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU))', 'C_TYPPOH05'))

  cDenik := IF( ::isHIM, SysConfig( 'IM:cDenikIM'), SysConfig( 'Zvirata:cDenikZv') )
  Filter := FORMAT("cDenik == '%%'", { cDenik} )
  UCETPOL->( dbSetFilter( COMPILE( Filter)))

RETURN self

********************************************************************************
METHOD HIM_LikvUCT_SCR:destroy()
  ::drgUsrClass:destroy()
  UCETPOL->( dbClearFilter())
  (::fiZMAJU)->( mh_ClrScope())
  (::fiMAJ)->( mh_ClrScope())
RETURN self

********************************************************************************
METHOD HIM_LikvUCT_SCR:drgDialogStart(drgDialog)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN self

********************************************************************************
METHOD HIM_LikvUCT_SCR:ItemMarked()
  Local cScope := StrZero(UCETPOL->nDoklad,10) + StrZero(UCETPOL->nOrdItem,5)

  (::fiZMAJU)->( mh_SetScope( cScope))

  cScope := IF( ::isHIM, StrZero( (::fiZMAJU)->nTypMAJ,3 ), StrZero((::fiZMAJU)->nUcetSkup,3 )) + ;
                         StrZERO( (::fiZMAJU)->nInvCis, 15)
  (::fiMAJ)->( mh_SetScope( cScope))

RETURN SELF


*===============================================================================
FUNCTION Preuctuj_HIM( isHIM)
  Local cFile := if( isHIM, 'Zmaju', 'ZmajuZ'), cFileW := cFile + 'w', uctLikv
  Local obdDokl := Strzero( (cFile)->nRok,4) + Strzero( (cFile)->nObdobi,2)

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