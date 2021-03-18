#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"

* Vytváøí podkladový soubor ListIT_P pro opis úkolových lístkù.
* Pro firmu MOPAS. - viz. RV_R09()
*===============================================================================
FUNCTION VYR_rep_01()
  Local oDialog, oParent

  oParent := XbpDialog():new( AppDesktop(), , {10, 10}, {10, 10},,.F.)
  oParent:taskList := .F.
  oParent:create()
  *
  DRGDIALOG FORM 'VYR_report_01' PARENT oParent MODAL DESTROY
  *
  ( oParent:Destroy(), oParent := Nil )
RETURN NIL

*
********************************************************************************
CLASS VYR_Report_01 FROM drgUsrClass

EXPORTED:
  VAR     dDatumOd, dDatumDo, cListSTR, cPopisRep
  METHOD  Init, Destroy, drgDialogStart, Start_ZPRAC

HIDDEN
  VAR     dm, df
ENDCLASS

********************************************************************************
METHOD VYR_Report_01:init(parent)
  ::drgUsrClass:init(parent)

  ::dDatumOd  := ::dDatumDo := CTOD('  .  .  ')
  ::cListSTR  := SPACE( 40)
  ::cPopisRep := 'Vytváøí podkladový soubor (ListIT_P) pro opis úkolových lístkù.'
  *
RETURN self

********************************************************************************
METHOD VYR_Report_01:drgDialogStart(drgDialog)
  *
  ::dm := drgDialog:dataManager
  ::df := drgDialog:oForm
RETURN self

********************************************************************************
METHOD VYR_Report_01:destroy()
  ::drgUsrClass:destroy()
  ::dDatumOd := ::dDatumDo := ::cListSTR := ::cPopisRep := ;
  Nil
RETURN self

********************************************************************************
METHOD  VYR_Report_01:Start_zprac()
  Local nAPPENDs := 0
  Local nRokVytvor := 0, nPorCisLis := 0, cOznOper := SPACE(10)
  Local dVyhotML, cKEY, lStredOK, lDateOK
  Local aStred

  ::dm:save()
  *
  lDateOK := ( !EMPTY( ::dDatumOD) .AND. !EMPTY( ::dDatumDO) .AND. ::dDatumOD <= ::dDatumDO )
  IF !lDateOK
    drgMsgBox(drgNLS:msg('Chybný datový interval ...'))
    ::df:setNextFocus('M->dDatumOd',, .T. )
    RETURN NIL
  ENDIF
  *
  IF drgIsYesNo(drgNLS:msg( 'Požadujete spustit zpracování ?' ))
    aStred := ListAsArray( ::cListStr)
    drgDBMS:open( 'ListIT')
    ListIT->( AdsSetOrder( 1))
    drgDBMS:open( 'ListIT_P' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
    drgDBMS:open( 'PolOPER',,,,, 'PolOPERa')
    PolOPERa->( AdsSetOrder( 5))

    drgServiceThread:progressStart(drgNLS:msg('Generuji podklady pro sestavu ...', 'LISTIT'), LISTIT->(LASTREC()) )
    ListIT->( dbGoTOP())

    DO WHILE !ListIT->( EOF())
      dVyhotML := ListIT->dVyhotSkut
      IF dVyhotML >= ::dDatumOD .AND. dVyhotML <= ::dDatumDO
         lStredOK := NO
         AEVAL( aStred, {|X| lStredOK := IF( ALLTRIM( X) = ALLTRIM( ListIT->cNazPOL1), YES, lStredOK) })
         IF lStredOK .AND. ListIT->nOsCisPrac > 0
            ListIT_P->( dbAPPEND())
            mh_CopyFLD( 'ListIT', 'ListIT_P')
            ListIT_P->nKusyCelk  := 0
            ListIT_P->nKcNaOpePl := 0
            ListIT_P->dDatOD_FLT := ::dDatumOD
            ListIT_P->dDatDO_FLT := ::dDatumDO
            ListIT_P->cStred_FLT := ::cListStr
            nAPPENDs++

            * Z PolOper se generují záznamy pro danou operaci jen jednou
            IF ( nRokVytvor <> ListIT->nRokVytvor ) .OR. ;
               ( nPorCisLis <> ListIT->nPorCisLis)  .OR. ;
               ( cOznOper <> ListIT->cOznOper )
              cKEY := StrZERO( ListIT->nRokVytvor, 4) + StrZERO( ListIT->nPorCisLis, 12)
              PolOPERa->( mh_SetSCOPE( cKey))
              DO WHILE !PolOPERa->( EOF())
                 ListIT_P->( dbAPPEND())
                 mh_CopyFLD( 'PolOPERa', 'ListIT_P')
                 ListIT_P->nKusyCelk  := PolOPERa->nKoefKusCa
                 ListIT_P->nNmNaOpePl := PolOPERa->nCelkKusCa
                 ListIT_P->nNhNaOpePl := PolOPERa->nCelkKusCa / 60
                 ListIT_P->nKcNaOpePl := PolOPERa->nKcNaOper
                 ListIT_P->dDatOD_FLT := ::dDatumOD
                 ListIT_P->dDatDO_FLT := ::dDatumDO
                 ListIT_P->cStred_FLT := ::cListStr
                 nAPPENDs++
                 PolOPERa->( dbSKIP())
              ENDDO
              PolOPERa->( mh_ClrScope())
            ENDIF
         ENDIF
      ENDIF
      nRokVytvor := ListIT->nRokVytvor
      nPorCisLis := ListIT->nPorCisLis
      cOznOper   := ListIT->cOznOper

      ListIT->( dbSKIP())
      drgServiceThread:progressInc()
    ENDDO
    ListIT->( dbCommit())
    drgServiceThread:progressEnd()
    *
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  ENDIF
RETURN NIL
