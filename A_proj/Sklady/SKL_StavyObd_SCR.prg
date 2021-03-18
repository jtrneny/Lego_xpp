********************************************************************************
* SKL_StavyObd_SCR.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Gra.ch"

#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
* SKL_StavyObd_SCR ... Stavy za obdob�
********************************************************************************
CLASS SKL_StavyObd_SCR FROM drgUsrClass
EXPORTED:
  VAR     nROK, nObdPOC, nObdKON, oneSklPOL
  VAR     nMnozPoc, nCenaPoc, nMnozKon, nCenaKon
  VAR     nMnozPrij, nCenaPrij, nMnozVydej, nCenaVydej
  VAR     lPrintTMP
*  VAR     nMnozRozdil, nCenaRozdil

  METHOD  Init, ItemMarked, drgDialogStart, eventHandled
  METHOD  SKL_KUMUL, createKUMUL

HIDDEN
  VAR     dc, dm, msg, cUser, dDate, cTime
  METHOD  copyToKUMUL
ENDCLASS

********************************************************************************
METHOD SKL_StavyObd_SCR:init(parent)
  *
*  ::drgUsrClass:init(parent)
  drgDBMS:open('CENZBOZ'  )
  drgDBMS:open('CENZB_ps' )
  drgDBMS:open('PVPKUMULw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('PVPITEM',,,,.T.,'PVPIT_1')
  PVPIT_1->( AdsSetOrder( 16))
  *
  ::oneSklPOL := .T.
  ::cUser     := SysConfig( "System:cUserABB")
  ::dDate     := Date()
  ::cTime     := Time()
  *
  ::nROK    := uctObdobi:SKL:nROK
  ::nObdPOC := 1
  ::nObdKON := uctObdobi:SKL:nOBDOBI
  ::lprintTmp := .f.

RETURN self

********************************************************************************
METHOD SKL_StavyObd_SCR:drgDialogStart(drgDialog)
  local  ocol_Rok, ocol_obd

  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar

  ocol_Rok := ::dc:oBrowse[2]:getColumn_byName( 'PVPKUMULw->nrok')
  ocol_Rok:colorBlock := { |xval| if( pvpKumulW->nMnozPrij +pvpKumulW->nMnozVydej = 0, {,}, { , GraMakeRGBColor({255,255,0}) } ) }

  ocol_Obd := ::dc:oBrowse[2]:getColumn_byName( 'PVPKUMULw->nobdobi')
  ocol_Obd:colorBlock := { |xval| if( pvpKumulW->nMnozPrij +pvpKumulW->nMnozVydej = 0, {,}, { , GraMakeRGBColor({255,255,0}) } ) }
RETURN self

********************************************************************************
METHOD SKL_StavyObd_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local lOK := .T.

  DO CASE
    CASE nEvent = drgEVENT_OBDOBICHANGED

      ::nROK    := uctObdobi:SKL:nROK
      ::nObdKON := uctObdobi:SKL:nOBDOBI
      PVPKUMULw->( dbZap())
      ::itemMarked()

      RETURN .T.
    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_StavyObd_SCR:ItemMarked()
  Local cKey    := Upper(CenZboz->cCisSklad) + Upper(CenZboz->cSklPol)
  Local nRok    := IF( PVPKUMULw->( LastRec()) = 0, ::nRok   , PVPKUMULw->nRok    )
  Local nObdobi := IF( PVPKUMULw->( LastRec()) = 0, ::nObdKon, PVPKUMULw->nObdobi )

  PVPKUMULw->( mh_SetScope( cKey))
  *
  IF ::oneSklPOL
    ::createKUMUL()
    *
    PVPKUMULw->( dbSeek( cKey + StrZero(nRok,4) + StrZero(nObdobi,2),,'PVPKUMw1'))
    ::dc:oBrowse[2]:oXbp:refreshAll()
    ::dm:refresh()
  ENDIF
RETURN SELF

********************************************************************************
METHOD SKL_StavyObd_SCR:createKUMUL()
  Local cKey := Upper(CenZboz->cCisSklad) + Upper(CenZboz->cSklPol)
  Local nMes, cKarta
  Local saveTmp
  *
  IF( ::oneSklPOL, PVPKUMULw->( dbZAP()), NIL )
  *
  ::nMnozPoc  := ::nCenaPoc  := ::nMnozKon   := ::nCenaKon   := 0
  ::nMnozPrij := ::nCenaPrij := ::nMnozVydej := ::nCenaVydej := 0

  saveTmp := .t.

  IF CenZb_ps->( dbSEEK( cKEY + StrZero(::nRok, 4),,'CENPS01'))
    ::nMnozPoc := CenZb_ps->nMnozPoc
    ::nCenaPoc := CenZb_ps->nCenaPoc
  ENDIF

  FOR nMes := ::nObdPOC TO ::nObdKON
    * kumulace pohyb�
    cKey := Upper(CenZboz->cCisSklad) + Upper(CenZboz->cSklPol) + ;
            StrZero(::nRok, 4) + StrZero(nMes, 2)
    PVPIT_1->( mh_SetScope( cKey))

    if ::lPrintTmp
      saveTmp := nMes = ::nObdKON
    endif

    *
    Do While !PVPIT_1->( Eof())
       cKarta := Right( alltrim( PVPIT_1->cTypDoklad), 3)
       IF cKarta <> '400'
         ::nMnozPrij  += If( PVPIT_1->nTypPoh =  1 , PVPIT_1->nMnozPrDod, 0 )
         ::nMnozVydej += If( PVPIT_1->nTypPoh = -1 , PVPIT_1->nMnozPrDod, 0 )
       ENDIF
       ::nCenaPrij  += If( PVPIT_1->nTypPoh =  1 , PVPIT_1->nCenaCelk , 0 )
       ::nCenaVydej += If( PVPIT_1->nTypPoh = -1 , PVPIT_1->nCenaCelk , 0 )
       PVPIT_1->( dbSkip())
    EndDo

    * z�pis do KUMULU
*    IF ::nMnozPrij <> 0 .OR. ::nMnozVydej <> 0

    if saveTmp
      mh_CopyFLD( 'CenZboz', 'PVPKUMULw', .T.)
      PVPKUMULw->nRok     := ::nROK
      PVPKUMULw->nObdobi  := nMes
      PVPKUMULw->cObdPoh  := StrZero( nMes, 2) + '/' + RIGHT( STR(::nROK), 2)
      *
      PVPKUMULw->nMnozPoc   := ::nMnozPoc
      PVPKUMULw->nCenaPoc   := ::nCenaPoc

      PVPKUMULw->nMnozPrij  := ::nMnozPrij
      PVPKUMULw->nCenaPrij  := ::nCenaPrij
      PVPKUMULw->nMnozVydej := ::nMnozVydej
      PVPKUMULw->nCenaVydej := ::nCenaVydej
      PVPKUMULw->nMnozKon   := ::nMnozPoc + ::nMnozPrij - ::nMnozVydej
      PVPKUMULw->nCenaKon   := ::nCenaPoc + ::nCenaPrij - ::nCenaVydej
      *
*      mh_WRTzmena( 'PVPKUMULw', .T.)
    endif
    *
//    ::nMnozKon := PVPKUMULw->nMnozKon
//    ::nCenaKon := PVPKUMULw->nCenaKon
    ::nMnozKon := ::nMnozPoc + ::nMnozPrij - ::nMnozVydej
    ::nCenaKon := ::nCenaPoc + ::nCenaPrij - ::nCenaVydej
    ::nMnozPoc := ::nMnozKon
    ::nCenaPoc := ::nCenaKon
    ::nMnozPrij := ::nCenaPrij := ::nMnozVydej := ::nCenaVydej := 0
    *
    PVPIT_1->( mh_ClrScope())
  NEXT
  PVPKUMULw->( dbGoTOP())

RETURN SELF

********************************************************************************
METHOD SKL_StavyObd_SCR:SKL_KUMUL()
  Local cC := 'Po�adujete prov�st v�po�et kumulac� pro cel� cen�k ?'
  Local cMsg := drgNLS:msg('MOMENT PROS�M - generuji v� po�adavek ...')
  Local nRec := CenZBOZ->( RecNO()), nCount := 0

  IF drgIsYESNO(drgNLS:msg( cC))
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg('Generuji stavy za obdob� ...', 'CENZBOZ'), CenZboz->(LASTREC()) )
    ::oneSklPOL := .F.
    PVPKUMULw->( dbZAP())
    CenZBOZ->( dbGoTOP())
    DO WHILE !CenZBOZ->( EOF())
      ::createKUMUL( .F.)
*      nCount++
*      IF( nCount % 500 = 0, ::msg:writeMessage( cMsg + ' - ' + Str( nCount) ,DRG_MSG_WARNING), NIL )
      CenZBOZ->( dbSkip())
      drgServiceThread:progressInc()
    ENDDO
    CenZBOZ->( dbGoTO( nRec))
    drgServiceThread:progressEnd()
    ::msg:WriteMessage(,0)
    *
    ::copyToKUMUL()
  ENDIF
RETURN SELF

********************************************************************************
METHOD SKL_StavyObd_SCR:copyToKUMUL()
  Local cTAG
  Local cMsg := drgNLS:msg('MOMENT PROS�M - generuji v� po�adavek ...')

  IF drgIsYESNO(drgNLS:msg( 'Po�adujete ulo�it v�po�tenou kumulaci pro cel� cen�k ?'))

   drgDBMS:open('PVPKUMUL',.t.)
   IF PVPKUMUL->( FLock())
      ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
      drgServiceThread:progressStart(drgNLS:msg('Ukl�d�m vypo�ten� kumulace ...', 'PVPKUMULw'), PVPKUMULw->(LASTREC()) )
*      PVPKUMUL->( dbZAP())
      * Zru��me pouze z�znamy roku, kter� se p�epo��t�val
      Filter := FORMAT( "nROK = %%", { ::nROK} )
      PVPKUMUL->( mh_SetFilter( Filter), dbGoTop() )
      DO WHILE !PVPKUMUL->( EOF())
//        if PVPKUMUL->( dbRlock())
          PVPKUMUL->( dbDelete())
//        endif
        PVPKUMUL->( dbSkip())
      ENDDO
//      PVPKUMUL->( dbUnlock())
      PVPKUMUL->( mh_ClrFilter())
      *
      cTag := PVPKUMULw->( AdsSetOrder(0))
      PVPKUMULw->( dbGoTOP())
      DO WHILE !PVPKUMULw->( EOF())
        mh_CopyFLD( 'PVPKUMULw', 'PVPKUMUL', .T.)
        PVPKUMULw->( dbSkip())
        drgServiceThread:progressInc()
      ENDDO
      PVPKUMULw->( AdsSetOrder( cTag))

      PVPKUMUL->( dbUnlock(), dbCloseArea() )
      drgServiceThread:progressEnd()
      ::msg:WriteMessage(,0)
    ELSE
      drgMsgBox(drgNLS:msg( 'Kumulativn� soubor se nepoda�ilo uzamknout ... '))
    ENDIF
  ENDIF

RETURN SELF

* Pro TISK
*===============================================================================
FUNCTION SKL_PVPKUMUL_TMP()
  Local StavyObd

  StavyObd           := SKL_StavyObd_SCR():new()
  StavyObd:nObdPOC   := 1
  StavyObd:nObdKON   := VAL( LEFT( obdReport,2))   // generovat pouze za vybran� obdob�
  StavyObd:nRok      := VAL( RIGHT( obdReport, 4))
  StavyObd:oneSklPOL := .F.                      // generovat za v�echny polo�ky CENZBOZ
  StavyObd:lPrintTmp := .t.
  *
  drgServiceThread:progressStart(drgNLS:msg('Generuji stavy za obdob� ' + obdReport + ' ...', 'CENZBOZ'), CenZboz->(LASTREC()) )

  PVPKUMULw->( dbZAP())
  CenZBOZ->( dbGoTOP())
  DO WHILE !CenZBOZ->( EOF())
    StavyObd:createKUMUL()
    CenZBOZ->( dbSkip())
    drgServiceThread:progressInc()
  ENDDO
  *
  drgServiceThread:progressEnd()

RETURN NIL