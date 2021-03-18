/*==============================================================================
  ZVI_zsbKarty_SCR.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Xbp.ch"
#include "Gra.ch"

********************************************************************************
*
********************************************************************************
CLASS ZVI_zsbKarty_SCR FROM drgUsrClass
EXPORTED:
  VAR     NazTypEvid

  METHOD  Init, drgDialogStart, EventHandled, ItemMarked
*  METHOD  onSave

ENDCLASS

*
********************************************************************************
METHOD ZVI_zsbKarty_SCR:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('KategZVI'  )
  drgDBMS:open('C_UctSkZ'  )
  drgDBMS:open('C_DrPohZ'  )
  *
RETURN self

********************************************************************************
METHOD ZVI_zsbKarty_SCR:drgDialogStart(drgDialog)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ZvKarty->( DbSetRelation( 'KategZvi'  , {|| ZvKarty->nZvirKat  } ,'ZvKarty->nZvirKat'  ))
  ZvKarty->( DbSetRelation( 'C_UctSkZ'  , {|| ZvKarty->nUcetSkup } ,'ZvKarty->nUcetSkup' ))
  ZvZmenHD->( DbSetRelation( 'C_DrPohZ' , {|| ZvZmenHD->nDrPohyb } ,'ZvZmenHD->nDrPohyb' ))
RETURN

********************************************************************************
METHOD ZVI_zsbKarty_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
    CASE nEvent = drgEVENT_DELETE
**      SKL_CENZBOZ_DEL()
      ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
*      VYR_VYRZAK_Del()
*      ::RefreshBROW('VyrZAK')
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

*******************************************************************************
METHOD ZVI_zsbKarty_SCR:ItemMarked()
*  Local cScope := Upper(CENZBOZ->cCisSklad) + Upper(CENZBOZ->cSklPol)

*  PVPITEM ->( mh_SetScope( cScope))
  ::NazTypEvid := IF( ZvKarty->cTypEvid = 'S', 'Skupinová', 'Individuální' )
RETURN SELF

/*
*****************************************************************
METHOD SKL_CenZboz_SCR:Cenik_DODAVATELE()

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SKL_DODZBOZ_CRD' PARENT ::drgDialog DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

*  Místa uložení skladové položky
*****************************************************************
METHOD SKL_CenZboz_SCR:Cenik_MISTAULOZ()
*   MsgBOX( 'Cenik_MISTAULOZ ...')
  IF SysCONFIG( 'Sklady:lMistaUloz')
    ::drgDialog:pushArea()
    DRGDIALOG FORM 'SKL_ULOZENI_POL' PARENT ::drgDialog DESTROY
    ::drgDialog:popArea()
  ELSE
    drgMsgBox(drgNLS:msg( 'Není zapnut mechanismus pro evidenci skl. položek na více místech uložení !'))
  ENDIF
RETURN self

*
*****************************************************************
METHOD SKL_CenZboz_SCR:Cenik_POHYBY( oDlg)

  ::drgDialog:pushArea()
  SKL_VyberPOHYB( oDlg)
  ::drgDialog:popArea()
/*
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SKL_SelPOHYB' CARGO lCallDlg PARENT ::drgDialog MODAL DESTROY
*  DRGDIALOG FORM 'SKL_POHYBY_CRDI' CARGO .T. PARENT ::drgDialog DESTROY
  ::drgDialog:popArea()                  // Restore work area

RETURN self
*/
*

/* Pøecenìní skladu z kalkulací
*****************************************************************
METHOD SKL_CenZboz_SCR:Cenik_Preceneni()
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('VYR_KalkToCEN, MAT', ::drgDialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  oDialog:destroy(.T.)
  oDialog := Nil
RETURN self
*/
