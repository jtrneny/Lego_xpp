/*==============================================================================
  VYR_VyrPolKAL_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"


function vyr_kalkul_oW_isOk()
  local nretVal := 0, sid := isNull( kalkul_oW->sid, 0)

  if select('pvpitem_ka') = 0
     drgDBMS:open( 'pvpitem',,,,,'pvpitem_ka')
  endif

  nretVal := if( pvpitem_ka->( dbseek( sid,,'KALKUL')), 558, 0 )
retur nretVal


function vyr_kalkul_oW_stav()
  return if( kalkul_oW->nStavKALK = -1, MIS_ICON_OK, 0)


********************************************************************************
*
********************************************************************************
CLASS VYR_VyrPolKAL_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:

  METHOD  Init, Destroy, drgDialogStart

  METHOD  VYR_KALKUL_SCR        // Editaèní mechanismus pro KALKUL
  METHOD  KalkHR_CMP            // Hromadný výpoèet kalkulací
  METHOD  KalkHR_DEL            // Hromadné rušení kalkulací
  METHOD  KalkHR_AKT            // Hromadné nastavení aktuální kalkulace

  inline method itemMarked()
    local cKy := upper(vyrPol->cCisZakaz) +upper(vyrPol->cVyrPol) +strZero(vyrPol->nVarCis, 3)

    kalkul_oW->(mh_ordSetScope(cky,'KALKUL9'))
    ::info_in_msgStatus()
  return self

  inline access assign method is_kalkul()
    local cky := Upper(vyrPol->cCisZakaz) + Upper(vyrPol->cVyrPol) + StrZero(vyrPol->nVarCis, 3)
  return if( kalkul->( dbseek( cky,,'KALKUL2')), MIS_ICON_OK, 0 )

  * pro EX_pres klakulace plán VYR_kalkHRcmp_ex_CRD
  inline method kalkHRcmp_ex()
    local  oDialog, nexit, recNo := vyrPol->(recNo())

    oDialog := drgDialog():new('VYR_kalkHRcmp_ex_CRD',self:drgDialog)
    oDialog:create( , self:drgDialog:dialog,.F.)

    oDialog:destroy(.T.)
    oDialog := NIL
    VyrPOL->( dbGoTO(recNo))
  return self

HIDDEN:
  VAR     msg, dm, dc, df, ab

  inline method info_in_msgStatus()
    local  msgStatus := ::msg:msgStatus, picStatus := ::msg:picStatus
    local  ncolor, cinfo := '', oPs
    *
    local  curSize  := msgStatus:currentSize()
    *
    local  paColors := { { graMakeRGBColor( {174, 255, 255} ), graMakeRGBColor( {  0, 183, 173} ) }, ;
                         { graMakeRGBColor( {255, 255,  13} ), graMakeRGBColor( {255, 255, 166} ) }, ;
                         { graMakeRGBColor( {255, 183, 173} ), graMakeRGBColor( {251,  51,  40} ) }  }
    *
    local  cky := upper(vyrPol->ccisZakaz) +upper(vyrPol->cvyrPol) +strZero(vyrPol->nvarCis,3)


    cinfo := if( vyrZak->( dbseek( cky,, 'VYRZAK1')),'Zakázkový - ', 'Ne_Zakázkový - ' )

    if c_typPol->( dbseek( upper(vyrPol->ctypPol),,'TYPPOL1'))
      if right( allTrim(c_typPol->cnazTYPpol), 1) $ 'a,á'
        cinfo := strTran(cinfo, 'ý', 'á' )
      endif

      cinfo += c_typPol->cnazTYPpol
    endif

    msgStatus:setCaption( '' )
    picStatus:hide()

    ncolor := if( c_typPol->lfinal, 3, 1 )

    oPs := msgStatus:lockPS()
    GraGradient( oPs, {  0, 0 }    , ;
                      { curSize }, paColors[ncolor], GRA_GRADIENT_HORIZONTAL )
    graStringAT( oPs, { 20, 4 }, cinfo )
    msgStatus:unlockPS()

    picStatus:setCaption( if(c_typPol->lfinal, DRG_ICON_MSGWARN, 0 ))
    picStatus:show()
  return

ENDCLASS

*
********************************************************************************
METHOD VYR_VyrPolKAL_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('kalkul'  )
  drgDBMS:open('c_typPol')

  drgDBMS:open('kalkul',,,,,'kalkul_oW')
RETURN self
*
********************************************************************************
METHOD VYR_VyrPolKAL_scr:drgDialogStart(drgDialog)
 local  pa_quick := { { 'Kompletní seznam       ', ''                               }, ;
                      { 'Jen nezakázkové        ', 'ccisZakaz  = "               "' }, ;
                      { 'Jen   zakázkové        ', 'ccisZakaz <> "               "' }, ;
                      { ''                       , ''                               }  }

  c_typPol->( dbEval( { || aadd( pa_quick, { '(' +c_typPol->ctypPol +') _ ' +c_typPol->cnazTYPpol, ;
                                             'ctypPol = "' +c_typPol->ctypPol +'"' } ) }         ) )

  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)

  ::msg       := drgDialog:oMessageBar             // messageBar
  ::dc        := drgDialog:dialogCtrl              // dataCtrl
  ::dm        := drgDialog:dataManager             // dataMananager
  ::df        := drgDialog:oForm                   // form

  ::msg:can_writeMessage := .f.

  ::quickFiltrs:init( self, pa_quick, 'vyrPoložky' )
RETURN self
*
********************************************************************************
METHOD VYR_VyrPolKAL_scr:destroy()
  ::drgUsrClass:destroy()
RETURN self

* KALKULACE Skuteèná
********************************************************************************
METHOD VYR_VyrPolKAL_SCR:VYR_KALKUL_SCR()
LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_KALKUL_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

* Hromadná kalkulace - výpoèet
********************************************************************************
METHOD VYR_VyrPolKal_SCR:KalkHR_CMP()
  LOCAL  oDialog,  nExit, nRec := VyrPOL->( RecNO())

  oDialog := drgDialog():new('VYR_KALKHRCMP_CRD',self:drgDialog)
  oDialog:create( , self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL
  VyrPOL->( dbGoTO( nRec))
RETURN self

* Hromadné rušení kalkulací
********************************************************************************
METHOD VYR_VyrPolKal_SCR:KalkHR_DEL()
  LOCAL  oDialog,  nExit

  oDialog := drgDialog():new('VYR_KALKHRDEL_CRD',self:drgDialog)
  oDialog:create( , self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL
RETURN self

* Nastavení aktuální kalkulace
********************************************************************************
METHOD VYR_VyrPolKal_SCR:KalkHR_AKT()
  LOCAL  oDialog,  nExit, nRec := VyrPOL->( RecNO())

  oDialog := drgDialog():new('VYR_KALKHRAKT_CRD',self:drgDialog)
  oDialog:create( , self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL
  VyrPOL->( dbGoTO( nRec))

RETURN self

********************************************************************************
*
********************************************************************************
CLASS VYR_VyrZakKAL_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init, Destroy, drgDialogStart, itemMarked

  METHOD  VYR_KALKUL_SCR        // Editaèní mechanismus pro KALKUL
  METHOD  KalkHr_CMP


  inline access assign method is_kalkul()
    local cky := Upper(vyrZak->cCisZakaz) + Upper(vyrZak->cVyrPol) + StrZero(vyrZak->nVarCis, 3)
  return if( kalkul->( dbseek( cky,,'KALKUL2')), MIS_ICON_OK, 0 )

  * pro EX_pres klakulace skuteèná VYR_kalkHRcmp_ex_CRD
  inline method kalkHRcmp_ex()
    local  oDialog, nexit, recNo := vyrZak->(recNo())

    oDialog := drgDialog():new('VYR_kalkHRcmp_ex_CRD',self:drgDialog)
    oDialog:create( , self:drgDialog:dialog,.F.)

    oDialog:destroy(.T.)
    oDialog := NIL
    vyrZak->( dbGoTO(recNo))
  return self

ENDCLASS

*
********************************************************************************
METHOD VYR_VyrZakKAL_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('kalkul'  )
  drgDBMS:open('kalkul',,,,,'kalkul_oW')
RETURN self
*
********************************************************************************
METHOD VYR_VyrZakKAL_scr:drgDialogStart(drgDialog)
  ColorOfText( ::drgDialog:dialogCtrl:members[1]:aMembers)
RETURN self
*
********************************************************************************
METHOD VYR_VyrZakKAL_scr:itemMarked()
  Local cKEY := UPPER( VyrZAK->cCisZakaz) + UPPER( VyrZAK->cVyrPol) + ;
              STRZERO( VyrZAK->nVarCis, 3)

  ColorOfText( ::drgDialog:dialogCtrl:members[1]:aMembers)
  *
  VyrPol   ->( dbSEEK( cKEY,, 'VYRPOL1'))
  kalkul_oW->(mh_ordSetScope(cKey,'KALKUL9'))
RETURN self

*
********************************************************************************
METHOD VYR_VyrZakKAL_scr:destroy()
  ::drgUsrClass:destroy()
RETURN self
*
********************************************************************************
METHOD VYR_VyrZakKAL_SCR:VYR_KALKUL_SCR()
LOCAL oDialog
Local cKEY := UPPER( VyrZAK->cCisZakaz) + UPPER( VyrZAK->cVyrPol) + ;
              STRZERO( VyrZAK->nVarCis, 3)

  ::drgDialog:pushArea()                  // Save work area
*  VyrPol->( dbSEEK( cKEY))
  DRGDIALOG FORM 'VYR_KALKUL_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

RETURN self

* Hromadná kalkulace - výpoèet
********************************************************************************
METHOD VYR_VyrZakKal_SCR:KalkHR_CMP()
  LOCAL  oDialog,  nExit, nRec := VyrZAK->( RecNO())

  oDialog := drgDialog():new('VYR_KALKHRCMP_CRD', self:drgDialog)
  oDialog:create( , self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL
  VyrZAK->( dbGoTO( nRec))
RETURN self

*------------------
********************************************************************************
*
********************************************************************************
CLASS VYR_VyrobekKAL_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init, Destroy, drgDialogStart, itemMarked

  METHOD  VYR_KALKUL_SCR        // Editaèní mechanismus pro KALKUL
ENDCLASS

*
********************************************************************************
METHOD VYR_VyrobekKAL_SCR:Init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('VyrZAK'   )
RETURN self
*
********************************************************************************
METHOD VYR_VyrobekKAL_scr:drgDialogStart(drgDialog)
  Local Filter
  *
  ColorOfText( ::drgDialog:dialogCtrl:members[1]:aMembers)
  *
  * Jen nezakázkové vyr.položky
  Filter := "cCisZakaz = '%%'"
  Filter := Format( Filter,{ EMPTY_ZAKAZ})
  VyrPol->( mh_SetFilter( Filter))
RETURN self
*
********************************************************************************
METHOD VYR_VyrobekKAL_scr:itemMarked()
*  Local cKEY := UPPER( VyrPOL->cCisZakaz) + UPPER( VyrPOL->cVyrPol) + ;
*              STRZERO( VyrPOL->nVarCis, 3)

*  ColorOfText( ::drgDialog:dialogCtrl:members[1]:aMembers)
  *
*  VyrZAK->( dbSEEK( cKEY,, 1))
RETURN self

*
********************************************************************************
METHOD VYR_VyrobekKAL_scr:destroy()
  ::drgUsrClass:destroy()
  VyrPol->( mh_ClrFilter())
RETURN self
*
********************************************************************************
METHOD VYR_VyrobekKAL_SCR:VYR_KALKUL_SCR()
LOCAL oDialog
*Local cKEY := UPPER( VyrZAK->cCisZakaz) + UPPER( VyrZAK->cVyrPol) + ;
*              STRZERO( VyrZAK->nVarCis, 3)

  ::drgDialog:pushArea()                  // Save work area
*  VyrPol->( dbSEEK( cKEY))
  DRGDIALOG FORM 'VYR_KALKULVP_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

RETURN self