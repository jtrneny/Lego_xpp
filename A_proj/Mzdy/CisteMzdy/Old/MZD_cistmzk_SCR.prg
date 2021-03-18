#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


//-----+ FI_fakprihd_SCR +-------------------------------------------------------
CLASS MZD_cistmzk_SCR FROM drgUsrClass
EXPORTED:
//  VAR     KUHRADE_vzm    // k úhradì v základní mìnì

  METHOD  Init
  METHOD  ItemMarked
//  METHOD  ItemSelected
  METHOD  InFocus
//  METHOD  CardOfKmenMzd
  METHOD  drgDialogStart

/*
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT   ;   ::CardOfKmenMzd()
    CASE nEvent = xbeP_Keyboard
      Do Case
      Case mp1 = xbeK_INS   ;   ::CardOfKmenMzd(.T.)
      Case mp1 = xbeK_ENTER ;   ::CardOfKmenMzd(.F.)
      Case mp1 = xbeK_ESC   ;   PostAppEvent(xbeP_Close,nEvent,,oXbp)
      Otherwise
        RETURN .F.
      EndCase
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.
*/
ENDCLASS

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD MZD_cistmzk_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('MZDY')

  MZDY->( DbSetRelation( 'DRUHYMZD',  { || MZDY->nDruhMzdy },  'MZDY->nDruhMzdy'))

//    MZD_MsPrc_MO->( DbSetRelation( 'PER_PRSMLDOH', { || Upper(MZD_MsPrc_MO->cRodCisPra)}, 'Upper(MZD_MsPrc_MO->cRodCisPra)',"PrcSml02",,.T.))

//  drgDBMS:open('SKL_PVPHEAD')
//  SKL_PVPHEAD->( DbSetRelation( 'SKL_CDRPOHY', { || SKL_PVPHEAD->nCislPoh },'SKL_PVPHEAD->nCislPoh'))
//  SKL_PVPITEM->( DbSetRelation( 'CIS_CDPH', { || SKL_PVPITEM->nKlicDPH },'SKL_PVPITEM->nKlicDPH'))

//  ::KUHRADE_vzm := 0
RETURN self


METHOD MZD_cistmzk_SCR:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.

**
METHOD MZD_cistmzk_SCR:drgDialogStart(drgDialog)
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr

  nROK    := uctOBDOBI:MZD:NROK
  nOBDOBI := uctOBDOBI:MZD:NOBDOBI

  cFiltr := Format("nROK = %% .and. nOBDOBI = %%", {nROK, nOBDOBI})
  cFiltr += ' .and. lStavem'
  MSPRC_MO->( ADS_SetAOF( cFiltr))

RETURN self



*****************************************************************
* Pøi pohybu v seznamu
*****************************************************************
/*
METHOD MZD_kmenove_SCR:ItemMarked()
  Local  dc := ::drgDialog:dialogCtrl
  Local  nTabPage := GetTabPage( dc)

  Do Case
  Case nTabPage == 1   // dle Dokladù
//    SKL_PVPITEM->( AdsSetOrder( 0))
//    SKL_PVPITEM->( DbSetFilter( ;
//               {|| SKL_PVPITEM->nDoklad == SKL_PVPHEAD->nDoklad },;
//                   'SKL_PVPITEM->nDoklad == ' + STR( SKL_PVPHEAD->nDoklad)))
//    SKL_PVPITEM->( dbGoTOP())
    ::drgDialog:dataManager:Refresh()    // refrešne INFO-kartu

//  Case nTabPage == 2   // dle Položek
//    ::drgDialog:dataManager:Refresh()    // refrešne INFO-kartu
  EndCase
  aEVAL(dc:members[1]:aMembers,{|X| If( X:ClassName() = 'drgBrowse', X:Refresh(.T.), NIL )} )

RETURN SELF

*/

METHOD MZD_cistmzk_SCR:ItemMarked()
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP

  cKy_BP := StrZero( MSPRC_MO->nROK, 4)+ StrZero( MSPRC_MO->nOBDOBI, 2)           ;
          + StrZero( MSPRC_MO->nOscisPrac, 5) +StrZero( MSPRC_MO->nPorPraVzt, 3)
  MZKUM_RO->( AdsSetOrder(1), dbSetScope(SCOPE_BOTH, cKy_BP),dbGOTOP())

  cKy_BP := StrZero( MZKUM_RO->nOscisPrac, 5) +StrZero( MZKUM_RO->nROK, 4)  +StrZero( MZKUM_RO->nPorPraVzt, 3)
  MZDY->( AdsSetOrder(13), dbSetScope(SCOPE_BOTH, cKy_BP),dbGOTOP())


/*
  For N := 1 To LEN(aVALUEs)
    drgVar := aVALUEs[N,2]
    If IsOBJECT(drgVar)
      drgVar:oDrg:Disabled := .T.
      drgVar:Refresh()
    EndIf
  Next
/*
  Do Case
  Case nTabPage == 1
//    ::drgDialog:dataManager:Refresh()    // refrešne INFO-kartu
//    If( EMPTY(FIN_FAKPRIHD ->(dbFILTER())), NIL, FIN_FAKPRIHD ->(dbCLEARFILTER(), dbGOTOP()))
//    ::KUHRADE_vzm := (FIN_FAKPRIHD ->nCENzakCEL -FIN_FAKPRIHD ->nUHRcelFAK)
//    ::KUHRADE_vcm := (FIN_FAKPRIHD ->nCENzahCEL -FIN_FAKPRIHD ->nUHRcelFAZ)
  Case nTabPage == 2
    cKy_BP := "2004" +UPPER(MZD_MsPrc_MO ->cRodCisPra)
    PER_PRSMLDOH ->( AdsSetOrder(6))
//    PER_PRSMLDOH ->( DbSetDescend(.T.))
    PER_PRSMLDOH ->( dbSetScope(SCOPE_BOTH, cKy_BP),dbGOTOP())
//    MZD_MsPrc_MO->( DbSetRelation( 'PER_PRSMLDOH', { || Upper(MZD_MsPrc_MO->cRodCisPra)}, 'Upper(MZD_MsPrc_MO->cRodCisPra)',"PrcSml02",,.T.))

//     FIN_FAKPRIHD ->( AdsSetOrder(0),dbSETFILTER( { || FIN_FAKPRIHD ->nCISFIRMY == FIR_FIRMY ->nCISFIRMY} ), dbGOTOP())
  Case nTabPage == 3
    cKy_BP := STRZERO( MZD_MsPrc_MO ->nOsCisPrac)        ;
               + STRZERO( MZD_MsPrc_MO ->nPorPraVzt)
    MZD_MSSRZ_MZ ->( AdsSetOrder(1))
    MZD_MSSRZ_MZ ->( dbSetScope(SCOPE_BOTH, cKy_BP),dbGOTOP())
//    cFT_BP  := "MZD_MsPrc_MO ->nOsCisPrac == MZD_MSSRZ_MZ->nOsCisPrac .and. " + ;
//                    "MZD_MsPrc_MO ->nPorPraVzt == MZD_MSSRZ_MZ->nPorPraVzt"
//    MZD_MSSRZ_MZ ->( AdsSetOrder(0), dbSETFILTER( cFT_BP ), dbGOTOP())
//    If( EMPTY(FIN_FAKPRIHD ->(dbFILTER())), NIL, FIN_FAKPRIHD ->(dbCLEARFILTER(), dbGOTOP()))
   EndCase
*/
  aEVAL(dc:members[1]:aMembers,{|X| If( X:ClassName() = 'drgBrowse', X:Refresh(.T.), NIL )} )
//  dc:oBrowse:Refresh(.T.)
RETURN SELF


/*METHOD MZD_DoklPra_SCR:CardOfKmenMzd()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'MZD_kmenove_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self      */
