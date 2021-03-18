#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"

* Vytv��� podkladov� soubor PVPITEMw2 pro tisk sestavy
* Ur�eno pro: MOPAS                                                    3.3.2011
*===============================================================================
FUNCTION VYR_rep_02()
  Local oDialog, oParent

  oParent := XbpDialog():new( AppDesktop(), , {10, 10}, {10, 10},,.F.)
  oParent:taskList := .F.
  oParent:create()
  *
  DRGDIALOG FORM 'VYR_report_02' PARENT oParent MODAL DESTROY
  *
  ( oParent:Destroy(), oParent := Nil )
RETURN NIL

*
********************************************************************************
CLASS VYR_Report_02 FROM drgUsrClass

EXPORTED:
  VAR     cPopisRep, aZAK
  METHOD  Init, Destroy, drgDialogStart, eventHandled
  METHOD  Start_ZPRAC, GenPVP, GenML

HIDDEN
  VAR     dc
ENDCLASS

********************************************************************************
METHOD VYR_Report_02:init(parent)
  *
  ::drgUsrClass:init(parent)
  ::cPopisRep := 'Vytv��� podkladov� soubor  ?????????? .'
  *
RETURN self

********************************************************************************
METHOD VYR_Report_02:drgDialogStart(drgDialog)
  *
  ::dc := ::drgDialog:dialogCtrl
RETURN self

********************************************************************************
METHOD VYR_Report_02:destroy()
  ::drgUsrClass:destroy()
  ::cPopisRep := ;
  Nil
RETURN self

********************************************************************************
METHOD VYR_Report_02:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
      *
    CASE nEvent = xbeP_Keyboard
      Do Case
        Case mp1 = xbeK_ESC
          PostAppEvent(xbeP_Close,nEvent,,oXbp)
        CASE mp1 = xbeK_CTRL_A
          ::dc:oaBrowse:is_SelAllRec := !::dc:oaBrowse:is_SelAllRec
          ::dc:oaBrowse:refresh()
      Otherwise
        RETURN .F.
      EndCase
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .F.

********************************************************************************
METHOD  VYR_Report_02:Start_zprac()
  *
  Local arSelect := ::dc:oBrowse[1]:arSelect
  Local is_SelAllRec := ::dc:oBrowse[1]:is_SelAllRec
  Local oMoment, cMsg, cKey

  cMsg := if( is_SelAllRec .or. !empty( arselect), 'Zpracov�v�m vybran� zak�zky ... ' ,;
                                                   'Zpracov�v�m vybranou zak�zku ...' )

  IF drgIsYESNO(drgNLS:msg( 'Po�adujete vytvo�it podklady pro sestavu ?') )
    *
    drgDBMS:open( 'VYRZAK',,,,, 'VYRZAKa' )
    drgDBMS:open( 'VYRZAK',,,,, 'VYRZAKb' )
    drgDBMS:open( 'VYRCISV' )
    drgDBMS:open( 'PVPITEM' )
    drgDBMS:open( 'PVPITEM',,,,, 'PVPITEMa' )
    drgDBMS:open( 'PVPITEMw2' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
    drgDBMS:open( 'LISTIT' )
    drgDBMS:open( 'LISTIT',,,,, 'LISTITa' )

    *
    oMoment := SYS_MOMENT( cMsg)

    Do case
    case   is_SelAllRec
       VyrZak->( dbGoTop())
       Do while !VyrZak->( eof())
         ::genPVP()
         ::genML()
         VyrZak->( dbSkip())
       Enddo

    case   Len( arSelect) > 0
      For n := 1 to Len(arselect)
        VyrZak->( dbGoTo(arselect[n]))
        ::genPVP()
        ::genML()
      next

    otherwise
      ::genPVP()
      ::genML()
    endcase

    oMoment:destroy()
  ENDIF
*  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN self

* Generuje se materi�l
********************************************************************************
METHOD  VYR_Report_02:GenPVP()
  Local cKey, cScope := Upper( VyrZak->cCisZakaz) + '-1'

  ::aZAK := {}

  * omez� se na v�deje k dan� zak�zce
  PVPITEM->( OrdSetFocus('PVPITEM09'),;
             mh_SetScope( cScope) )
  AADD( ::aZAK, { VyrZak->cCisZakaz, VyrZak->nMnozPlano, VyrZak->nMnozPlano} )

  DO WHILE ! PVPITEM->( Eof())
    *
    mh_COPYFLD( 'PVPITEM', 'PVPITEMw2', .t.)
    *
    cKey := StrZero( PVPITEM->nDoklad,10) + StrZero( PVPITEM->nOrdItem, 5)
    IF VyrCISV->( dbSeek( cKey,, 'C_VYRCV3' ))

      vyrzakb->( dbSeek( VyrCISV->cVyrobcis,, 'VYRZAK10' ))
      AADD( ::aZAK, { VyrCISV->cVyrobcis,VyrCisV->nMnozV,vyrzakb->nMnozPlano } )
      cKey := Upper( VyrCISV->cVyrobcis) + '          -1'
      PVPITEMa->( OrdSetFocus('PVPITEM09'),;
                  mh_SetScope( cKey))

      DO WHILE ! PVPITEMa->( Eof())
        mh_COPYFLD( 'PVPITEMa', 'PVPITEMw2', .t.)
        PVPITEMw2->cCisZakaz  := VyrZak->cCisZakaz
        PVPITEMw2->cCisZakazI := VyrZak->cCisZakaz
        PVPITEMw2->cVyrobCis  := VyrCISV->cVyrobcis
        PVPITEMw2->nMnozPrDod := PVPITEM->nMnozPrDod
        PVPITEMw2->nCenaCelk  := PVPITEM->nMnozPrDod * PVPITEMa->nCenNapDod
        PVPITEMa->( dbSkip())
      ENDDO
    ENDIF

    PVPITEM->( dbSkip())
  ENDDO
  *
*  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN self

* Generuj� se mzdy
********************************************************************************
METHOD  VYR_Report_02:GenML()
  Local cCisZakaz, x, nKc := 0, nHod := 0

  if LEN( ::aZAK) > 0
    for x := 1 to LEN( ::aZAK)
      cCisZakaz := ::aZAK[ x, 1 ]
      LISTITa->( OrdSetFocus('LISTIT6'),;
                  mh_SetScope( cCisZakaz))
      nKc  := 0
      nHod := 0
      DO WHILE ! LISTITa->( Eof())
        nKc  += LISTITa->nKcNaOpeSk
        nHod += LISTITa->nNhNaOpeSk
        LISTITa->( dbSkip())
      ENDDO
      mh_COPYFLD( 'LISTITa', 'PVPITEMw2', .t.)
      PVPITEMw2->cTypPohybu  := '900'
      PVPITEMw2->nCislPoh    := 900
      PVPITEMw2->nCenaCelk   := ( nKc  / ::aZAK[ x, 3] ) * ::aZAK[ x, 2]  //VyrZak->nMnozPlano
      PVPITEMw2->nHodiny     := ( nHod / ::aZAK[ x, 3] ) * ::aZAK[ x, 2]
      PVPITEMw2->cCisZakaz   := VyrZak->cCisZakaz
      PVPITEMw2->cCisZakazI  := VyrZak->cCisZakaz
      PVPITEMw2->cVyrobCis   := cCisZakaz
*      PVPITEMw2->cCisZakaz   := cCisZakaz
      PVPITEMw2->cNazZBO     := 'MZDOV� L�STKY'
    next
  endif
RETURN self