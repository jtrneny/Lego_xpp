********************************************************************************
*  SKL_CENZBOZ2_SCR
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "xbp.ch"

********************************************************************************
*
********************************************************************************
CLASS SKL_CenZboz2_SCR FROM drgUsrClass

EXPORTED:
  METHOD  Init, drgDialogStart, ItemMarked, eventHandled
  METHOD  Cenik_PREPOCET_CEN    // pøepoèet PC ze skladové ceny
  METHOD  PREPOCET_CEN_bDPH     // pøepoèet PC bez DPH

ENDCLASS

********************************************************************************
METHOD SKL_CenZboz2_SCR:init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('C_DPH'   )
  drgDBMS:open('CENZBOZ' )
  drgDBMS:open('CENPRODC')
  drgDBMS:open('CENPRODC',,,,,'CENPRODCa')
RETURN self

********************************************************************************
METHOD SKL_CenZboz2_SCR:drgDialogStart(drgDialog)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN self

*  Prodejní ceny ke skladové položce
********************************************************************************
METHOD SKL_CenZboz2_SCR:ItemMarked()
  Local cScope := UPPER(CenZboz->cCisSklad) +UPPER(CenZboz->cSklPol)

  CenProdC->( mh_SetScope( cScope))
RETURN SELF

********************************************************************************
METHOD SKL_CenZboz2_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
    CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
      drgMsgBox(drgNLS:msg('Položku lze pouze opravovat !'))
      Return .T.
    CASE nEvent = drgEVENT_DELETE
      SKL_CenProdC_DEL()
      Return .T.
    CASE nEvent = xbeP_Keyboard
      Do Case
        Case mp1 = xbeK_ESC
          PostAppEvent(xbeP_Close,nEvent,,oXbp)
      Otherwise
        RETURN .F.
      EndCase
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .F.

********************************************************************************
METHOD SKL_CenZboz2_SCR:Cenik_PREPOCET_CEN()
  LOCAL nRecNO    := CenZBOZ->( RecNO())
  LOCAL cMsgLOCK  := 'Pøepoèet cen nelze provést, nebo soubor je blokován jiný uživatelem ...'

IF drgIsYESNO(drgNLS:msg( 'Požadujete pøepoèet prodejních cen ?') )
  IF CenZboz->( FLock()) .AND. CenProdC->( FLock())

   CENZBOZ->( dbGoTop())
   CenProdC->( mh_ClrScope())
   drgServiceThread:progressStart(drgNLS:msg('Pøepoèet prodejních cen ...', 'CENZBOZ'), CenZboz->(LASTREC()) )

   DO WHILE !CenZboz->( EOF())
      cKey := Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPol)
      CenZboz->nCencnZBO   := CenZboz->nCenasZBO
      IF CenProdCa->( dbSEEK( cKey,,'CENPROD1'))
         C_Dph->( dbSEEK( CenZboz->nKlicDph))
         CenProdCa->nCencnZBO  := CenZboz->nCenasZBO
         CenProdCa->nCenapZBO  := CenZboz->nCenasZBO * ( 1 + CenProdCa->nProcMarz / 100 )
         CenProdCa->nCenamZBO  := CenProdCa->nCenapZBO * ( 1 + C_DPH->nProcDph / 100 )
         CenProdCa->nCenap1ZBO := CenZboz->nCenasZBO * ( 1 + CenProdCa->nProcMarz1 /100 )
         CenProdCa->nCenap2ZBO := CenZboz->nCenasZBO * ( 1 + CenProdCa->nProcMarz2 /100 )
         CenProdCa->nCenap3ZBO := CenZboz->nCenasZBO * ( 1 + CenProdCa->nProcMarz3 /100 )
         CenProdCa->nCenap4ZBO := CenZboz->nCenasZBO * ( 1 + CenProdCa->nProcMarz4 /100 )
**         CenProdC->dDatAkt    := DATE()
         *
         CenZboz->nCenapZBO   := CenProdCa->nCenapZBO
         CenZboz->nCenamZBO   := CenProdCa->nCenamZBO
      ENDIF
      CenZboz->( dbSKIP())
      drgServiceThread:progressInc()
   ENDDO

   drgServiceThread:progressEnd()
   ( CenZboz->( dbUnlock()), CenProdCa->( dbUnLock()) )
   drgMsgBOX( drgNLS:msg( 'Konec pøepoètu prodejních cen ...'), XBPMB_INFORMATION)
   *
   CenZBOZ->( dbGoTO( nRecNO))
   ::itemMarked()
   ::drgDialog:dataManager:refresh()

  ELSE
    drgMsgBOX( drgNLS:msg( cMsgLock, XBPMB_INFORMATION ))
  ENDIF
ENDIF

RETURN self


********************************************************************************
METHOD SKL_CenZboz2_SCR:PREPOCET_CEN_bDPH()
  LOCAL oDialog, nExit
  *
  *
  oDialog := drgDialog():new('SKL_prepocetPC_bDPH', ::drgDialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  oDialog:destroy(.T.)
  oDialog := Nil
  *
  ::itemMarked()
  ::drgDialog:dataManager:refresh()

RETURN self


********************************************************************************
*
********************************************************************************
CLASS SKL_prepocetPC_bDPH FROM drgUsrClass
EXPORTED:
  VAR     nProcEdit, nZpusZaok
  METHOD  Init, drgDialogStart, destroy, itemMarked, postValidate
  METHOD  btn_Start, ProcMARZ, Replace_PC
*  METHOD  CenapZBO
*  METHOD  CenamZBO

HIDDEN:
  VAR     dm, msg
ENDCLASS

********************************************************************************
METHOD SKL_prepocetPC_bDPH:init(parent)
  ::drgUsrClass:init(parent)
  *
  ::nProcEdit := 0.00
  ::nZpusZaok := 11

RETURN self

********************************************************************************
METHOD SKL_prepocetPC_bDPH:drgDialogStart(drgDialog)
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN self

********************************************************************************
METHOD SKL_prepocetPC_bDPH:ItemMarked()
  CenProdC->( mh_SetScope( UPPER(CenZboz->cCisSklad) +UPPER(CenZboz->cSklPol) ))
RETURN SELF

********************************************************************************
METHOD SKL_prepocetPC_bDPH:destroy()
  *
  ::nProcEdit := NIL
  ::nZpusZaok := NIL

RETURN self

********************************************************************************
METHOD SKL_prepocetPC_bDPH:postValidate( oVar)
  LOCAL xVar  := oVar:get()
  LOCAL cName := UPPER(oVar:name), lOK := .T.

  DO CASE
    CASE cName = 'M->nProcEdit'
      if xVar = 0
        drgMsgBOX( drgNLS:msg( 'Procento musí být vyplnìno ...'))
        lOk := .f.
      else
        ::nProcEdit := oVar:value
      endif
    CASE cName = 'M->nZpusZaok'
      if xVar = 0
        drgMsgBOX( drgNLS:msg( 'Zpùsob zaokrouhlení musí být vyplnìno ...'))
        lOk := .f.
      else
        ::nZpusZaok := oVar:value
      endif
  ENDCASE

RETURN lOK

*
********************************************************************************
METHOD SKL_prepocetPC_bDPH:btn_Start()
  LOCAL nRecNO := CenZBOZ->( RecNO()), n
  Local arSelect := ::drgDialog:parent:odBrowse[1]:arSelect
  Local is_SelAllRec := ::drgDialog:parent:odBrowse[1]:is_SelAllRec
  Local oMoment, cMsg, cKey

  if( is_SelAllRec .or. !empty( arselect), 'Pøepoèet vybraných položek ... ' ,;
                                           'Pøepoèet vybrané položky ...' )

  IF drgIsYESNO(drgNLS:msg( 'Požadujete provést pøepoèet prodejních cen ?') )
    oMoment := SYS_MOMENT( cMsg)

    Do case
    case   is_SelAllRec
       CenZboz->( dbGoTop())
       Do while !CenZboz->( eof())
         ::Replace_PC()
         CenZboz->( dbSkip())
       Enddo

    case   Len( arSelect) > 0
      For n := 1 to Len(arselect)
        CenZboz->( dbGoTo(arselect[n]))
        ::Replace_PC()
      next

    otherwise
      ::Replace_PC()
    endcase

    oMoment:destroy()
    CenZBOZ->( dbGoTO( nRecNO))
  ENDIF
RETURN self

********************************************************************************
METHOD SKL_prepocetPC_bDPH:Replace_PC()
  Local cKey := Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPol)
  LOCAL nCenap := 0.00

  IF CenProdCa->( dbSEEK( cKey,,'CENPROD1'))
    IF CenProdCa->( dbRLock()) .and. CenZboz->( dbRLock())
      C_Dph->( dbSEEK( CenZboz->nKlicDph,, 'C_DPH1'))
      *
      nCenap              := CenProdCa->nCenaPZBO * ( 1 + ::nProcEdit / 100 )
      CenProdCa->nCenaPZBO := mh_ROUNDNUMB( nCenap, ::nZpusZaok)
      CenProdCa->nCenaMZBO := CenProdCa->nCenapZBO * ( 1 + C_DPH->nProcDph / 100 )   // ::CenaMZBO()
      CenProdCa->nProcMARZ := ::ProcMARZ()

      CenZboz->nCenapZBO  := CenProdCa->nCenapZBO
      CenZboz->nCenamZBO  := CenProdCa->nCenamZBO
      *
      ( CenProdCa->( dbRUnLock()),  CenZboz->( dbRUnLock()) )
    ENDIF
  ENDIF
RETURN self

*/

/********************************************************************************
METHOD SKL_prepocetPC_bDPH:btn_Start()
  LOCAL nCenap    := 0.00
  LOCAL nRecNO    := CenZBOZ->( RecNO())
  LOCAL cMsgLOCK  := 'Pøepoèet cen nelze provést, nebo soubor je blokován jiný uživatelem ...'

  IF drgIsYESNO(drgNLS:msg( 'Požadujete provést pøepoèet prodejních cen ?') )
    IF CenZboz->( FLock()) .AND. CenProdC->( FLock())

     CENZBOZ->( dbGoTop())
     CenProdC->( mh_ClrScope())
     drgServiceThread:progressStart(drgNLS:msg('Pøepoèet prodejních cen ...', 'CENZBOZ'), CenZboz->(LASTREC()) )

     do while !CenZboz->( EOF())
       cKey := Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPol)
       if CenProdC->( dbSEEK( cKey,,'CENPROD1'))
         C_Dph->( dbSEEK( CenZboz->nKlicDph,, 'C_DPH1'))
         if CenZboz->( RLock()) .AND. CenProdC->( RLock())

           nCenap              := CenProdC->nCenaPZBO * ( 1 + ::nProcEdit / 100 )
           CenProdC->nCenaPZBO := mh_ROUNDNUMB( nCenap, 11)
           CenProdC->nCenaMZBO := CenProdC->nCenapZBO * ( 1 + C_DPH->nProcDph / 100 )   // ::CenaMZBO()
           CenProdC->nProcMARZ := ::ProcMARZ()

           CenZboz->nCenapZBO  := CenProdC->nCenapZBO
           CenZboz->nCenamZBO  := CenProdC->nCenamZBO

         endif
       endif

       CenZboz->( dbSKIP())
       drgServiceThread:progressInc()
     ENDDO

     drgServiceThread:progressEnd()
     ( CenZboz->( dbUnlock()), CenProdC->( dbUnLock()) )
     drgMsgBOX( drgNLS:msg( 'Konec pøepoètu prodejních cen ...'), XBPMB_INFORMATION)
     *
     CenZBOZ->( dbGoTO( nRecNO))
     ::itemMarked()
     ::drgDialog:dataManager:refresh()

    ELSE
      drgMsgBOX( drgNLS:msg( cMsgLock, XBPMB_INFORMATION ))
    ENDIF
  ENDIF

RETURN self
*/

* Z pøíslušné prodejní ceny vypoèítá pøíslušnou marži
* Parametry:
* /nTypPC/ ...typ prodejní ceny ( 0 = základní, 1-4 = PC1 - PC4 )
********************************************************************************
METHOD SKL_prepocetPC_bDPH:ProcMARZ( nTypPC)
  Local nProcMarz := 0, nPC
  Local nCenCNZBO := CenProdCa->nCenCNZBO

  DEFAULT nTypPC TO 0
  IF nCenCNZBO <> 0
    nPC := IIF( nTypPC = 0, CenProdCa->nCenaPZBO,;
            IIF( nTypPC = 1, CenProdCa->nCenaP1ZBO,;
             IIF( nTypPC = 2, CenProdCa->nCenaP2ZBO,;
              IIF( nTypPC = 3, CenProdCa->nCenaP3ZBO,;
               IIF( nTypPC = 4, CenProdCa->nCenaP4ZBO, 0 )))))
    *
    nProcMarz := (( nPC - nCenCNZBO ) * 100 )/ nCenCNZBO
    nProcMarz := IF( nPC <= 0, 0, ROUND( nProcMarz, 2) )
  ENDIF

RETURN( nProcMarz )


* Fce vymaže prodejní ceny, pokud existují
*===============================================================================
FUNCTION SKL_CenProdC_DEL()

  IF EMPTY( CENPRODC->cCisSklad)
    drgMsgBox(drgNLS:msg('K položce neexistují prodejní ceny !'))
  ELSE
    IF drgIsYESNO(drgNLS:msg('ZRUŠIT ZÁZNAM!;;' + ;
                             'Opravdu chcete zrušit prodejní ceny ke skladové položce < & > ?',;
                              CenProdC->CsKLpOL) )
      IF CenZBOZ->( sx_RLock()) .AND. CenProdC->( sx_RLock())
        CenZBOZ->lViceCenP := .F.
        CenZBOZ->( dbUnlock())
        CenProdC->( dbDelete(), dbUnlock())
      ENDIF
    ENDIF
  ENDIF

RETURN NIL