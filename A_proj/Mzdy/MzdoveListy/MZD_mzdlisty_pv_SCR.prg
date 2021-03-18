#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


//-----+ FI_fakprihd_SCR +-------------------------------------------------------
CLASS MZD_mzdlisty_pv_SCR FROM drgUsrClass
EXPORTED:
//  VAR     KUHRADE_vzm    // k úhradì v základní mìnì

  METHOD  Init
  METHOD  ItemMarked
//  METHOD  ItemSelected
  METHOD  InFocus
//  METHOD  CardOfKmenMzd
  METHOD  drgDialogStart

  method  aktMzdListy

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
METHOD MZD_mzdlisty_pv_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('MZDLISTH')
  drgDBMS:open('MZDLISTI')
  drgDBMS:open('MSPRC_MO')
  drgDBMS:open('MSPRC_OS')


//  MZDLISTI->( DbSetRelation( 'C_NAZRML',  { || MZDLISTI->nRadMzdLis }, 'MZDLISTI->nRadMzdLis'))
//    MZD_MsPrc_MO->( DbSetRelation( 'PER_PRSMLDOH', { || Upper(MZD_MsPrc_MO->cRodCisPra)}, 'Upper(MZD_MsPrc_MO->cRodCisPra)',"PrcSml02",,.T.))

RETURN self


METHOD MZD_mzdlisty_pv_SCR:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.

**
METHOD MZD_mzdlisty_pv_SCR:drgDialogStart(drgDialog)
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr

  nROK    := uctOBDOBI:MZD:NROK
  nOBDOBI := uctOBDOBI:MZD:NOBDOBI

  cFiltr := Format("nROK = %% .and. nOBDOBI = %%", {nROK, nOBDOBI})
  cFiltr += ' .and. lStavem'
  msprc_mo->( ADS_SetAOF( cFiltr))

  cFiltr := Format("nROK = %%", {nROK})
  cFiltr += ' .and. nporpravzt <> 0'
  mzdlisth->( ADS_SetAOF( cFiltr))

RETURN self



*/

METHOD MZD_mzdlisty_pv_SCR:ItemMarked()
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP
  local  cfiltr


  cFiltr  := format( "crocpppv = '%%'", { mzdlisth->crocpppv } )
  mzdlisti->( ads_setAof( cfiltr ), dbgoTop())

  aEVAL(dc:members[1]:aMembers,{|X| If( X:ClassName() = 'drgDBrowse', X:Refresh(.T.), NIL )} )

RETURN SELF



method MZD_mzdlisty_pv_SCR:aktMzdListy()

  AktMzdListy()
//  dc:oBrowse:Refresh(.T.)

return self


