********************************************************************************
* HIM_MINOBD.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch"
#include "XBP.Ch"
#include "dmlb.ch"
#include "..\HIM\HIM_Him.ch"
#include "..\A_main\ace.ch"

********************************************************************************
* HIM_MINOBD ... Návrat do minulého období
********************************************************************************
CLASS HIM_MINOBD  FROM drgUsrClass, HIM_Main
EXPORTED:
  VAR     nRok, nObdobi, nPrevROK, nPrevObdobi, cLastOBD, cPrevOBD
  VAR     parent, cTask
  *
  METHOD  Init, Destroy, drgDialogInit, drgDialogStart
  METHOD  Start

HIDDEN
  VAR     msg, dm
  METHOD  Set_PrevOBD

ENDCLASS

********************************************************************************
METHOD HIM_MINOBD:init(parent, cTASK)
  Local cKEY, cLastObd

  DEFAULT cTASK TO 'HIM'
  ::drgUsrClass:init(parent)
  *
  ::HIM_Main:Init( parent, cTASK = 'HIM')
  ::parent          := parent:drgDialog
  ::cTASK           := cTASK
  * Stejný FRM je použit pro HIM a ZVI
  ::parent:formName := 'HIM_MINOBD'
  *
  ::cLastOBD    := LastOBDOBI( IF( cTASK = 'HIM', 'I', 'Z'), 2 )
  ::nROK        := VAL( Right( ::cLastObd, 4))
  ::nObdobi     := VAL( Left(  ::cLastObd, 2))
  ::nPrevROK    := if( ::nObdobi = 1, ::nROK-1, ::nROK     )
  ::nPrevObdobi := if( ::nObdobi = 1, 12      , ::nObdobi-1)
  ::cPrevOBD    := Alltrim( Str( ::nPrevObdobi, 2)) + '/' + Alltrim( Str( ::nPrevROK   , 4))
  *
RETURN self

********************************************************************************
METHOD HIM_MINOBD:drgDialogInit(drgDialog)
  drgDialog:formHeader:title := ::cTASK + ' - ' + drgDialog:formHeader:title
RETURN

********************************************************************************
METHOD HIM_MINOBD:drgDialogStart(drgDialog)
  ::dm := drgDialog:dataManager
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN

*******************************************************************************
METHOD HIM_MINOBD:Start()
  Local lOK
  *
  IF drgIsYESNO(drgNLS:msg( 'Provést návrat do období [ & ]  ?' , ::cPrevOBD ) )
    *
    drgDBMS:open( ::fiMAJ   )
    drgDBMS:open( ::fiZMAJU )
    drgDBMS:open( ::fiZMAJN )
    drgDBMS:open( ::fiSUMMAJ)
    drgDBMS:open( ::fiUMAJ  )
    drgDBMS:open( ::fiDMAJ  )
    drgDBMS:open( ::fiMajObd)
    drgDBMS:open( 'UCETSYS')
    *
    oSession_data:beginTransaction()
    BEGIN SEQUENCE
      ::Set_PrevOBD()
      oSession_data:commitTransaction()

    RECOVER USING oError
      oSession_data:rollbackTransaction()

    END SEQUENCE
    *
*    ::Set_PrevOBD()
    *
  Endif

RETURN Nil

********************************************************************************
METHOD HIM_MINOBD:Set_PrevOBD()
  Local cScope, cTag, cUloha, oMoment
  Local cDenik := IF( ::cTASK = 'HIM', PadR( SysConfig( 'Im:cDenikIm'     ), 2 ),;
                                       PadR( SysConfig( 'Zvirata:cDenikZv'), 2 ) )

  oMoment := SYS_MOMENT( 'Probíhá návrat do obobí < ' + ::cPrevObd + ' > ...')
  *
  IF( Select(::fiMAJ) <> 0, (::fiMAJ)->( dbCloseArea()), NIL )
  * otevøeme exclusive
  drgDBMS:open(::fiMAJ, .T. )
  * MAJ(Z) naplníme z MAJ(Z)OBD
  IF (::fiMAJ)->( FLock())
*     (::fiMAJ)->( dbZAP())
     (::fiMAJ)->( dbEval( {|| dbDelete() }))
     (::fiMAJ)->( dbCommit())
     *
     cTag := IF( ::cTASK = 'HIM', 'MAJOBD_1', 'MAJZOBD_1')
     cScope := StrZero(::nPrevROK,4) + StrZero(::nPrevObdobi,2)
     (::fiMajOBD)->( AdsSetOrder( cTag), mh_SetSCOPE( cScope))
     DO WHILE !(::fiMajOBD)->(EOF())
       mh_CopyFld( ::fiMAJOBD, ::fiMAJ, .T. )
       (::fiMajOBD)->( dbSkip())
     ENDDO
     (::fiMAJ)->( dbUnLock())
  ENDIF
  *
  IF( Select(::fiMAJOBD) <> 0, (::fiMAJOBD)->( dbCloseArea()), NIL )
  * otevøeme exclusive
  drgDBMS:open(::fiMAJOBD, .T. )
  * Z MAJOBD(Z) vymažeme poslední založené období
  IF (::fiMAJOBD)->( FLock())
      cScope := StrZero(::nPrevROK,4) + StrZero(::nPrevObdobi,2)
      cTag := IF( ::cTASK = 'HIM', 'MAJOBD_1', 'MAJZOBD_1')
      (::fiMajOBD)->( AdsSetOrder( cTag), mh_ClrScope(), mh_SetSCOPE( cScope))
      DO WHILE !(::fiMajOBD)->(EOF())
        (::fiMajOBD)->( dbDelete())
        (::fiMajOBD)->( dbSkip())
      ENDDO
  ENDIF

  IF( Select(::fiZMAJU) <> 0, (::fiZMAJU)->( dbCloseArea()), NIL )
  * otevøeme exclusive
  drgDBMS:open(::fiZMAJU, .T. )
  * Ze ZMAJU(Z) vymažeme poslední založené období
  IF (::fiZMAJU)->( FLock())
    cTag := IF( ::cTASK = 'HIM', 'ZMAJU6', 'ZMAJUZ6')
    cScope := StrZero(::nROK,4) + StrZero(::nObdobi,2)
    (::fiZMAJU)->( AdsSetOrder( cTag), mh_SetSCOPE( cScope))
    DO WHILE !(::fiZMAJU)->(EOF())
      (::fiZMAJU)->( dbDelete())
      (::fiZMAJU)->( dbSkip())
    ENDDO
  ENDIF
  *
  IF( Select( 'UcetPOL') <> 0, UcetPOL->( dbCloseArea()), NIL )
  * otevøeme exclusive
  drgDBMS:open( 'UcetPOL', .T. )
  * Z UCETPOL vymažeme poslední založené období
  IF UcetPOL->( FLock())
    cScope := StrZero(::nROK,4) + StrZero(::nObdobi,2) + Upper( cDenik)
    UcetPOL->( AdsSetOrder( 'UCETPOL12'), mh_SetSCOPE( cScope))
    DO WHILE !UcetPOL->(EOF())
      UcetPOL->( dbDelete())
      UcetPOL->( dbSkip())
    ENDDO
  ENDIF
  *
  cUloha := IF( ::cTASK = 'HIM', 'I', 'Z')
  cScope := cUloha + StrZero(::nROK,4) + StrZero(::nObdobi,2)
  IF UcetSYS->( dbSEEK( cScope,, 'UCETSYS3'))
    IF UcetSYS->( RLock())
       UcetSYS->( dbDelete(), dbUnLock())
    ENDIF
  ENDIF
  *
  oMoment:destroy()

RETURN Nil

********************************************************************************
METHOD HIM_MINOBD:destroy()
  *
  ::cTASK    := ::isHIM   := ::fiMAJ  := ::fiZMAJU  := ::fiCIS :=  ;
  ::fiSUMMAJ := ::fiUMAJ  := ::fiDMAJ := ::fiRokUZV := ;
  ::nROK     := ::nObdobi := ::parent :=  ;
   Nil
RETURN self