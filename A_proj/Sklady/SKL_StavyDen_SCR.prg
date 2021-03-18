********************************************************************************
* SKL_StavyDen_SCR.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"

#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
* SKL_StavyDen_SCR ... Stavy k danému dni
********************************************************************************
CLASS SKL_StavyDen_SCR FROM drgUsrClass
EXPORTED:
  VAR     nROK, nObdPOC, nObdKON, oneSklPOL
  VAR     dDatePOC, dDateKON
  VAR     nMnozPoc, nCenaPoc, nMnozKon, nCenaKon
  VAR     nMnozPrij, nCenaPrij, nMnozVydej, nCenaVydej

  METHOD  Init, ItemMarked, drgDialogStart, eventHandled
  METHOD  createKUMUL
*  METHOD  SKL_KUMUL

HIDDEN
  VAR     dc, dm, msg, cUser, dDate, cTime
*  METHOD  copyToKUMUL
ENDCLASS

********************************************************************************
METHOD SKL_StavyDen_SCR:init(parent)
  *
*  ::drgUsrClass:init(parent)
  drgDBMS:open('CENZBOZ'  )
  drgDBMS:open('CENZB_ps' )
  drgDBMS:open('PVPKUMDENw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('PVPITEM',,,,.T.,'PVPIT_1')
  PVPIT_1->( AdsSetOrder( 27))
  *
  ::oneSklPOL := .T.
  ::cUser     := SysConfig( "System:cUserABB")
  ::dDate     := Date()
  ::cTime     := Time()
  *
  ::nROK    := uctObdobi:SKL:nROK
  ::nObdPOC := 1
  ::nObdKON := uctObdobi:SKL:nOBDOBI
  *
  ::dDatePOC := CTOD('01.01.' + STR(::nROK,4))
  ::dDateKON := mh_LastODate( ::nROK, ::nObdKON )

RETURN self

********************************************************************************
METHOD SKL_StavyDen_SCR:drgDialogStart(drgDialog)
  local ocol_datKum

  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar

  ocol_datKum := ::dc:oBrowse[2]:getColumn_byName( 'PVPKUMDENw->ddatKum')
  ocol_datKum:colorBlock := { |xval| if( PVPKUMDENw->nMnozPrij +PVPKUMDENw->nMnozVydej = 0, {,}, { , GraMakeRGBColor({255,255,0}) } ) }
RETURN self

********************************************************************************
METHOD SKL_StavyDen_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local lOK := .T.

  DO CASE
    CASE nEvent = drgEVENT_OBDOBICHANGED

      ::nROK    := uctObdobi:SKL:nROK
      ::nObdKON := uctObdobi:SKL:nOBDOBI
      PVPKUMDENw->( dbZap())
      ::itemMarked()

      RETURN .T.
    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_StavyDen_SCR:ItemMarked()
  Local cKey    := Upper(CenZboz->cCisSklad) + Upper(CenZboz->cSklPol)
  Local dDatKum := IF( PVPKUMDENw->( LastRec()) = 0, ::dDateKON, PVPKUMDENw->dDatKUM )

  PVPKUMDENw->( mh_SetScope( cKey))
  *
  IF ::oneSklPOL
    ::createKUMUL()
    *
    PVPKUMDENw->( dbSeek( cKey + DTOS(dDatKum),,'KUMDENw1'))
    ::dc:oBrowse[2]:oXbp:refreshAll()
    ::dm:refresh()
  ENDIF
RETURN SELF

********************************************************************************
METHOD SKL_StavyDen_SCR:createKUMUL()
  Local cKey := Upper(CenZboz->cCisSklad) + Upper(CenZboz->cSklPol)
  Local nDen, nMes, dDatKum, cKarta, cScope
  *
  IF( ::oneSklPOL, PVPKUMDENw->( dbZAP()), NIL )
  *
  ::nMnozPoc  := ::nCenaPoc  := ::nMnozKon   := ::nCenaKon   := 0
  ::nMnozPrij := ::nCenaPrij := ::nMnozVydej := ::nCenaVydej := 0

  IF CenZb_ps->( dbSEEK( cKEY + StrZero(::nRok, 4),,'CENPS01'))
    ::nMnozPoc := CenZb_ps->nMnozPoc
    ::nCenaPoc := CenZb_ps->nCenaPoc
  ENDIF

  FOR nMes := ::nObdPOC TO ::nObdKON
    nDnyVMes := mh_LastDayOM( mh_LastODate( ::nROK, nMes ))
    FOR nDen := 1 TO nDnyVMes
      * kumulace pohybù
      ::nMnozPrij  := 0
      ::nCenaPrij  := 0
      ::nMnozVydej := 0
      ::nCenaVydej := 0

      dDatKum  := CTOD( StrZero(nDen,2)+'.'+StrZero( nMes, 2)+'.'+StrZero(::nROK,4) )
      cScope   := cKey + DTOS( dDatKum)

      PVPIT_1->( mh_SetScope( cScope))
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

      * zápis do KUMULU
        mh_CopyFLD( 'CenZboz', 'PVPKUMDENw', .T.)
        PVPKUMDENw->nRok       := ::nROK
        PVPKUMDENw->nObdobi    := nMes
        PVPKUMDENw->cObdPoh    := StrZero( nMes, 2) + '/' + RIGHT( STR(::nROK), 2)
        PVPKUMDENw->dDatKUM    := dDatKum
        *
        PVPKUMDENw->nMnozPoc   := ::nMnozPoc
        PVPKUMDENw->nCenaPoc   := ::nCenaPoc

        PVPKUMDENw->nMnozPrij  := ::nMnozPrij
        PVPKUMDENw->nCenaPrij  := ::nCenaPrij
        PVPKUMDENw->nMnozVydej := ::nMnozVydej
        PVPKUMDENw->nCenaVydej := ::nCenaVydej
        PVPKUMDENw->nMnozKon   := ::nMnozPoc + ::nMnozPrij - ::nMnozVydej
        PVPKUMDENw->nCenaKon   := ::nCenaPoc + ::nCenaPrij - ::nCenaVydej
        *
  *      mh_WRTzmena( 'PVPKUMULw', .T.)
      *
      ::nMnozPoc := PVPKUMDENw->nMnozKon
      ::nCenaPoc := PVPKUMDENw->nCenaKon

** js      ::nMnozKon := PVPKUMDENw->nMnozKon
** js      ::nCenaKon := PVPKUMDENw->nCenaKon
*      ::nMnozPoc := ::nMnozKon
*      ::nCenaPoc := ::nCenaKon
*      ::nMnozPrij := ::nCenaPrij := ::nMnozVydej := ::nCenaVydej := 0
      *
      PVPIT_1->( mh_ClrScope())
    NEXT
  NEXT
  PVPKUMDENw->( dbGoTOP())

RETURN SELF

/********************************************************************************
METHOD SKL_StavyDen_SCR:SKL_KUMUL()
  Local cC := 'Požadujete provést výpoèet kumulací pro celý ceník ?'
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')
  Local nRec := CenZBOZ->( RecNO()), nCount := 0

  IF drgIsYESNO(drgNLS:msg( cC))
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg('Generuji stavy za období ...', 'CENZBOZ'), CenZboz->(LASTREC()) )
    ::oneSklPOL := .F.
    PVPKUMDENw->( dbZAP())
    CenZBOZ->( dbGoTOP())
    DO WHILE !CenZBOZ->( EOF())
      ::createKUMUL( .F.)
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
METHOD SKL_StavyDen_SCR:copyToKUMUL()
  Local cTAG
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')

  IF drgIsYESNO(drgNLS:msg( 'Požadujete uložit výpoètenou kumulaci pro celý ceník ?'))

    drgDBMS:open('PVPKUMUL', .T. )
    IF PVPKUMUL->( FLock())
      ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
      drgServiceThread:progressStart(drgNLS:msg('Ukládám vypoètené kumulace ...', 'PVPKUMDENw'), PVPKUMDENw->(LASTREC()) )
*      PVPKUMUL->( dbZAP())
      * Zrušíme pouze záznamy roku, který se pøepoèítával
      Filter := FORMAT( "nROK = %%", { ::nROK} )
      PVPKUMUL->( mh_SetFilter( Filter), dbGoTop() )
      DO WHILE !PVPKUMUL->( EOF())
        PVPKUMUL->( dbDelete())
        PVPKUMUL->( dbSkip())
      ENDDO
      PVPKUMUL->( mh_ClrFilter())
      *
      cTag := PVPKUMDENw->( AdsSetOrder(0))
      PVPKUMDENw->( dbGoTOP())
      DO WHILE !PVPKUMDENw->( EOF())
        mh_CopyFLD( 'PVPKUMDENw', 'PVPKUMUL', .T.)
        PVPKUMDENw->( dbSkip())
        drgServiceThread:progressInc()
      ENDDO
      PVPKUMDENw->( AdsSetOrder( cTag))

      PVPKUMUL->( dbUnlock(), dbCloseArea() )
      drgServiceThread:progressEnd()
      ::msg:WriteMessage(,0)
    ELSE
      drgMsgBox(drgNLS:msg( 'Kumulativní soubor se nepodaøilo uzamknout ... '))
    ENDIF
  ENDIF

RETURN SELF
*/