
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


*****************************************************************
* SKL_Rezervace_SCR ... Rezervace
*****************************************************************
CLASS SKL_Rezervace_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init, Destroy, ItemMarked, drgDialogStart
  METHOD  RezervaceMenu
  METHOD  RezerSklPol    // Rezervace na skl. položku
  METHOD  RezerObjPri    // Rezervace na objednávku pøijatou

ENDCLASS

*
*****************************************************************
METHOD SKL_Rezervace_SCR:init(parent)
  ::drgUsrClass:init(parent)
RETURN self

*
*****************************************************************
METHOD SKL_Rezervace_SCR:destroy()
  ::drgUsrClass:destroy()
RETURN self

*
********************************************************************************
METHOD SKL_Rezervace_SCR:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN self

*
*****************************************************************
METHOD SKL_Rezervace_SCR:ItemMarked()
  LOCAL cScope := StrZero( ObjHEAD->nCisFirmy, 5) + Upper( ObjHead->cCislObInt)

  ObjItem->( mh_SetScope( cScope))
RETURN SELF

* Popup menu ...
*****************************************************************
METHOD SKL_Rezervace_SCR:RezervaceMenu()
  LOCAL cSubMenu, oPopup, aPos, aSize

  cSubMenu := drgNLS:msg('Na skl.položku,Na obj.pøijatou')
  oPopup := XbpMenu():new( ::drgDialog:dialog ):create()
  oPopup:addItem( {drgParse(@cSubMenu) , ;
                {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'RezerSKLPOL', '0', obj ) }} )
  oPopup:addItem( {drgParse(@cSubMenu) , ;
                {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'RezerOBJPRI', '0', obj ) }} )

  aPos  := ::drgDialog:oActionBar:oBord:currentPos()
  aSize := ::drgDialog:oActionBar:oBord:currentSize()
  aPos[ 2] += aSize[ 2] - drgINI:FontH
  oPopup:popup( ::drgDialog:dialog, aPos )

RETURN Self

* Rezervace na skl. položku
*****************************************************************
METHOD SKL_Rezervace_SCR:RezerSklPol()
  LOCAL  oDialog, nExit, cTag := ObjITEM->( OrdSetFocus())

  oDialog := drgDialog():new('SKL_RezerSklPol',self:drgDialog)
  oDialog:create(,self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL
  ObjITEM->( AdsSetOrder( cTag))

RETURN Self

* Rezervace na obj. pøijatou
*****************************************************************
METHOD SKL_Rezervace_SCR:RezerObjPri()
  LOCAL  oDialog, nExit, cTag := ObjITEM->( OrdSetFocus())

  oDialog := drgDialog():new('SKL_RezerObjPri',self:drgDialog)
  oDialog:create(,self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL
  ObjITEM->( AdsSetOrder( cTag))

RETURN Self