#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


//-----+ FI_fakprihd_SCR +-------------------------------------------------------
CLASS MZD_doklsrazk_CRD FROM drgUsrClass
EXPORTED:
//  VAR     KUHRADE_vzm    // k úhradì v základní mìnì

  METHOD  Init
  METHOD  ItemMarked
  METHOD  EdItemMarked
  METHOD  ItemSelected
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
METHOD MZD_doklsrazk_CRD:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('C_SRAZKY')
  drgDBMS:open('M_DAVHD')
  drgDBMS:open('M_DAV')
  drgDBMS:open('M_SRZ')

  drgDBMS:open('M_SRZw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  M_SRZw->( DbSetRelation( 'DRUHYMZD', { || M_SRZw->nDruhMzdy }, 'M_SRZw->nDruhMzdy'))
  M_SRZw->( DbSetRelation( 'C_SRAZKY', { || M_SRZw->cZkrSrazky },'M_SRZw->cZkrSrazky'))

//    MZD_MsPrc_MO->( DbSetRelation( 'PER_PRSMLDOH', { || Upper(MZD_MsPrc_MO->cRodCisPra)}, 'Upper(MZD_MsPrc_MO->cRodCisPra)',"PrcSml02",,.T.))

//  drgDBMS:open('SKL_PVPHEAD')
//  SKL_PVPHEAD->( DbSetRelation( 'SKL_CDRPOHY', { || SKL_PVPHEAD->nCislPoh },'SKL_PVPHEAD->nCislPoh'))
//  SKL_PVPITEM->( DbSetRelation( 'CIS_CDPH', { || SKL_PVPITEM->nKlicDPH },'SKL_PVPITEM->nKlicDPH'))

//  ::KUHRADE_vzm := 0



RETURN self

**
METHOD MZD_doklsrazk_CRD:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


**
METHOD MZD_doklsrazk_CRD:ItemSelected()
  x := "jdu sem"
RETURN self


**
METHOD MZD_doklsrazk_CRD:EdItemMarked()

RETURN self

**
METHOD MZD_doklsrazk_CRD:drgDialogStart(drgDialog)
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr

  nROK    := uctOBDOBI:MZD:NROK
  nOBDOBI := uctOBDOBI:MZD:NOBDOBI

  cFiltr := Format("nROK = %% .and. nOBDOBI = %% .and. nOsCisPrac = %% .and. nPorPraVzt = %%", {nROK, nOBDOBI, MSPRC_MO->nOsCisPrac,MSPRC_MO->nPorPraVZT})
  M_DAVHD->( ADS_SetAOF( cFiltr))

RETURN self



*****************************************************************
* Pøi pohybu v seznamu
*****************************************************************
/*
METHOD MZD_doklsrazk_SCR:ItemMarked()
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

METHOD MZD_doklsrazk_CRD:ItemMarked()
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP
*  LOCAL  cFiltr

  cKy_BP := StrZero( M_DAVHD->nROK, 4)+ StrZero( M_DAVHD->nOBDOBI,2)         ;
             +StrZero( M_DAVHD->nOscisPrac, 5) +StrZero( M_DAVHD->nPorPraVzt ,3) ;
              +StrZero( M_DAVHD->nDoklad, 10)

  drgDBMS:open('M_SRZw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  mh_COPYFLD('M_SRZ', 'M_SRZw', .T.)

*  cFiltr := Format("nROK = %% .and. nOBDOBI = %% .AND. nOscisPrac = %% .and. nPorPraVzt = %%", {MSPRC_MO->nROK, MSPRC_MO->nOBDOBI, MSPRC_MO->nOscisPrac, MSPRC_MO->nPorPraVzt})
*  M_DAV->( ADS_SetAOF( cFiltr))


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




/*METHOD MZD_doklsrazk_SCR:CardOfKmenMzd()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'MZD_kmenove_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self      */
