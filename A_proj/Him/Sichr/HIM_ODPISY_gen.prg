********************************************************************************
* HIM_ODPISY_gen.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "dmlb.ch"
#include "..\HIM\HIM_Him.ch"

********************************************************************************
* HIM_ODPISY_gen ... Generování mìsíèních odpisù
********************************************************************************
CLASS HIM_ODPISY_gen
EXPORTED:
  VAR     cTASK, isHIM, fiMAJ, fiZMAJU, fiZMAJUw, fiCIS, fiSUMMAJ, parent
  VAR     cNewOBD, nNewOBD, nNewROK, cDP_UcOdpis

  METHOD  Init, Destroy
  METHOD  genODPISY

ENDCLASS

********************************************************************************
METHOD HIM_ODPISY_gen:init(parent, cTASK)
  Local cKEY

  DEFAULT cTASK TO 'HIM'
  ::parent   := parent:drgDialog
  ::cTASK    := cTASK
  ::isHIM    := ( ::cTASK = 'HIM')
  ::fiMAJ    := IF( ::isHIM, 'MAJ'   , 'MAJZ'  )
  ::fiZMAJU  := IF( ::isHIM, 'ZMAJU' , 'ZMAJUZ')
  ::fiZMAJUw := ::fiZMAJU + 'w'
  ::fiSUMMAJ := IF( ::isHIM, 'SUMMAJ', 'SUMMAJZ')
  ::fiCIS    := 'C_TypPOH'
  ::cDP_UcOdpis := IF( ::isHIM, UCETNI_ODPIS_HIM, UCETNI_ODPIS_ZS )
  *
  drgDBMS:open( ::fiZMAJU )
  drgDBMS:open( ::fiMAJ )
  *
  ::nNewOBD  :=  parent:udcp:o_Obdobi:value  // uctOBDOBI:&(::cTask):nObdobi
  ::nNewROK  :=  parent:udcp:o_Rok:value     // uctOBDOBI:&(::cTask):nRok
  ::cNewOBD  :=  StrZero( ::nNewOBD, 2 ) + '/' + Right( StrZero( ::nNewROK, 4), 2 )
  *
  cKEY := StrZERO(::nNewROK,4) + StrZERO(::nNewOBD,2) + ::cDP_UcOdpis
  IF (::fiZMAJU)->( dbSEEK( cKEY,, AdsCtag(6) ))
    drgMsgBox(drgNLS:msg('Mìsíèní odpisy na období [ & / & ] již byly vygenerovány !', ::nNewOBD, ::nNewROK ))
  ELSE
    ::genODPISY()
  ENDIF

RETURN self

* Výpoèet mìsíèních odpisù na aktuální období
*******************************************************************************
METHOD HIM_ODPISY_gen:genODPISY()
  Local nCount := 1, nRecCount := 0, lLock
  Local nRecM := (::fiMAJ)->( RecNo())  , cTagM := (::fiMAJ)->( AdsSetOrder( 0))
  Local nRecZ := (::fiZMAJU)->( RecNo()), cTagZ := (::fiZMAJU)->( AdsSetOrder( 0))
  Local HimPohyby := HIM_Pohyby_Crd():new( ::parent, ::cTask)

  drgDBMS:open( ::fiZMAJUw ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  *
  IF lLock := (::fiMAJ)->( FLock())
    HimPohyby:nKarta    := 204
    HimPohyby:cAktOBD   := ::cNewOBD
    HimPohyby:nAktOBD   := ::nNewOBD
    HimPohyby:nAktROK   := ::nNewROK
    *
    (::fiMAJ)->( dbGoTop())
    drgServiceThread:progressStart(drgNLS:msg('Probíhá výpoèet mìsíèních odpisù ...', ::fiMAJ), (::fiMAJ)->( LastREC()) )
    *
    DO WHILE ! (::fiMAJ)->( Eof())
      *
      DO CASE
        CASE (::fiMAJ)->nZnAkt == AKTIVNI .and. ;
            ( (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct) >= (::fiMAJ)->nUctOdpMes
          (::fiMAJ)->nOprUct    += (::fiMAJ)->nUctOdpMes
          (::fiMAJ)->cObdPosOdp := ::cNewOBD
          * Poèet mìsíèních odpisù = nová položka
          (::fiMAJ)->nPocMesUO += 1
*            (::fiMAJ)->nPocMesOdp += 1   // Poèet mìsíèních odpisù
          IF !(::fiMaj)->lHmotnyIM .and. (::fiMAJ)->nOdpiSk = 8
            (::fiMAJ)->nPocMesUOZ += 1   // Poèet mìsíèních odpisù po zmìnì
          ENDIF
          *
          IF AddRec( ::fiZMAJUw)
             ( ::fiZMAJUw)->nDrPohyb   := VAL(::cDP_UcOdpis)   // UCETNI_ODPIS - doèasnì
             ( ::fiZMAJUw)->cTypPohybu := ::cDP_UcOdpis        // UCETNI_ODPIS
             HimPohyby:ZmajU_Modi( xbeK_INS, .F. )
             ( ::fiZMAJUw)->( dbUnlock())
          ENDIF

        CASE (::fiMAJ)->nZnAkt == AKTIVNI .and. ;
            ( (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct) <  (::fiMAJ)->nUctOdpMes .and. ;
            ( (::fiMAJ)->nCenaVstU > (::fiMAJ)->nOprUct)
          (::fiMAJ)->nUctOdpMes := (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct
          (::fiMAJ)->nOprUct    += (::fiMAJ)->nCenaVstU - (::fiMAJ)->nOprUct
          (::fiMAJ)->cObdPosOdp := ::cNewOBD
          * Poèet mìsíèních odpisù = nová položka
          (::fiMAJ)->nPocMesUO += 1
*            (::fiMAJ)->nPocMesOdp += 1
          IF !(::fiMaj)->lHmotnyIM .and. (::fiMAJ)->nOdpiSk = 8
            (::fiMAJ)->nPocMesUOZ += 1   // Poèet mìsíèních odpisù po zmìnì
          ENDIF

          IF AddRec( ::fiZMAJUw)
             ( ::fiZMAJUw)->nDrPohyb := VAL(::cDP_UcOdpis)  //  UCETNI_ODPIS
             ( ::fiZMAJUw)->cTypPohybu := ::cDP_UcOdpis     // UCETNI_ODPIS
             HimPohyby:ZmajU_Modi( xbeK_INS, .F. )
             ( ::fiZMAJUw)->( dbUnlock())
          ENDIF

        CASE (::fiMAJ)->nZnAkt == AKTIVNI .and. (::fiMAJ)->nCenaVstU = (::fiMAJ)->nOprUct
          (::fiMAJ)->nZnAkt := ODEPSAN

      ENDCASE
      *
      ** new_HIM
      IF ((::fiMAJ)->cOdpiSkD = '1M' .or. (::fiMAJ)->cOdpiSkD = '2M' .or. ;
          (::fiMAJ)->cOdpiSkD = '10' .or. (::fiMAJ)->cOdpiSkD = '11' .or. ;
          (::fiMAJ)->cOdpiSkD = '12' .or. (::fiMAJ)->cOdpiSkD = '13' )
        IF (::fiMAJ)->nZnAktD == AKTIVNI .and. ( (::fiMAJ)->nCenaVstD - (::fiMAJ)->nOprDan) > 0
           (::fiMAJ)->nPocMesDO += 1
        ENDIF
      ENDIF
      *
      (::fiMAJ)->( dbSkip())
      drgServiceThread:progressInc()
    ENDDO
    *
    drgServiceThread:progressEnd()
*    (::fiMAJ)->( dbUnlock(), AdsSetOrder( cTagM), dbGoTo( nRecM) )
*    (::fiZMAJU)->( AdsSetOrder( cTagZ), dbGoTo( nRecZ) )
  ELSE
    drgMsgBox(drgNLS:msg('NELZE - soubor majetku je blokován jiným uživatelem ...'))
  ENDIF

  if oSession_data:inTransaction()
    (::fiMAJ)->( AdsSetOrder( cTagM), dbGoTo( nRecM) )
  else
    (::fiMAJ)->( dbUnlock(), AdsSetOrder( cTagM), dbGoTo( nRecM) )
  endif

  (::fiZMAJU)->( AdsSetOrder( cTagZ), dbGoTo( nRecZ) )

RETURN self

********************************************************************************
METHOD HIM_ODPISY_gen:destroy()
  *
  (::fiZMajUw)->( dbCloseArea())
*  (::fiCIS)->( dbClearFilter())
  *
  ::cTASK := ::isHIM := ::fiMAJ := ::fiZMAJU := ::fiZMAJUw := ::fiCIS :=  ;
  ::fiSUMMAJ := ::cNewObd := ::nNewOBD := ::nNewROK := ::parent := ;
   Nil
RETURN self