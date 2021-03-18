***************************************************************************
*
* VYR_PrimeNAKL_SEL.PRG
*
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*****************************************************************
* VYR_PrimeNAKL_SEL ...
*****************************************************************
CLASS VYR_PrimeNAKL_SEL FROM drgUsrClass

EXPORTED:
  VAR     nSumaKALK

  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled, getForm

HIDDEN:
  VAR     drgGet
*  METHOD  Brow_sel
ENDCLASS

*
*****************************************************************
METHOD VYR_PrimeNAKL_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::drgUsrClass:init(parent)
  ::nSumaKALK := 0.0000
RETURN self

*
**********************************************************************
METHOD VYR_PrimeNAKL_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

*
********************************************************************************
METHOD VYR_PrimeNAKL_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .T.   //.F.
  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN

*
********************************************************************************
METHOD VYR_PrimeNAKL_SEL:drgDialogStart(drgDialog)
  LOCAL cEvent := ::drgGet:event

  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  DO CASE
  CASE cEvent = 'KALK_CenMzdVDP' .OR. ;   // PLÁN  - Pøímé mzdy VD
       cEvent = 'KALK_CenEnergP'          //       - Kooperace 1
    KusTREE->( AdsSetOrder( 2), mh_SetSCOPE( '0' ))
  ENDCASE
  drgDialog:oMessageBar:writeMessage('ENTER = pøenos èástky do kalkulace ...',DRG_MSG_INFO)

RETURN self

*
********************************************************************************
METHOD VYR_PrimeNAKL_SEL:getForm()
LOCAL oDrg, drgFC
LOCAL UDCP := ::drgDialog:parent:UDCP
LOCAL cGET := UDCP:cActiveGET, cTITLE, cFILE
LOCAL nPrMatKAL

  ::nSumaKALK := UDCP:nSumaKALK
  *
  drgFC := drgFormContainer():new()
  DO CASE
  CASE  cGET = 'nCenMatZMP' .OR.  cGET = 'nCenMatMJP'
     cTITLE := IF( cGET = 'nCenMatZMP', 'Pøímý materiál v zahranièní mìnì ... PLÁN',;
                                        'Pøímý materiál v CZK ... PLÁN' )
     cFILE  := 'KusTREE'

     DRGFORM INTO drgFC SIZE 90, 10 DTYPE '10' ;
             TITLE cTITLE FILE cFILE  GUILOOK 'All:N,Border:Y,Message:y'

     if UDCP:fromNabVys
       DRGDBROWSE INTO drgFC SIZE 90,7.9 ;
                 FIELDS 'cSklPOL,' + ;
                        'cNazev:Název skl.položky:25,'  + ;
                        'nSpMnSklHR:Hmotn.hrubá,' + ;
                        'nSpMnSklCI:Hmotn.èistá,' + ;
                        'cZkratJEDN,' + ;
                        'VYR_CenaCELKEM(1;5):Cena nabídky::@N 99 999 999.9999,' + ;
                        'cZkratMeny'  ;
                 SCROLL 'ny' CURSORMODE 3 PP 7
     else
       DRGDBROWSE INTO drgFC SIZE 90,7.9 ;
                 FIELDS 'cSklPOL,' + ;
                        'cNazev:Název skl.položky,'  + ;
                        'nSpMnoNas,' + ;
                        'cZkratJEDN,' + ;
                        'VYR_CenaCELKEM():Cena skladová::@N 99 999 999.9999,' + ;
                        'cZkratMeny'  ;
                 SCROLL 'ny' CURSORMODE 3 PP 7

     endif

     DRGSTATIC INTO drgFC FPOS 0.5,8 SIZE 89,1.9 STYPE XBPSTATIC_TYPE_RECESSEDBOX  RESIZE 'ny'
       DRGTEXT INTO drgFC CPOS  52, 0.3 CLEN 14 CAPTION 'Cena CELKEM' FONT 5
       DRGTEXT INTO drgFC CPOS  68, 0.3 CLEN 13 NAME M->nSumaKALK FONT 5 BGND 13 CTYPE( 2)
     DRGEND  INTO drgFC

  CASE  cGET = 'nCenMzdVDP' .OR. cGET = 'nCenEnergP'
    cTITLE :=  IF( cGET = 'nCenMzdVDP', 'Pøímé mzdy VD ... PLÁN',;
                                        'Kooperace 1 ... PLÁN'   )
    cFILE  := 'KusTREE'

     DRGFORM INTO drgFC SIZE 90, 10 DTYPE '10' ;
             TITLE cTITLE FILE cFILE  GUILOOK 'All:N,Border:Y,Message:y'

     DRGDBROWSE INTO drgFC SIZE 90,7.9 ;
               FIELDS 'cVyrPOL,' + ;
                      'nVarCis,' + ;
                      'nVyrSt,' + ;
                      'nPriprCas,' + ;
                      'nPriprKC,' + ;
                      'nKusovCas,' + ;
                      'nKusovKC' ;
               SCROLL 'ny' CURSORMODE 3 PP 7

     DRGSTATIC INTO drgFC FPOS 0.5,8 SIZE 89,1.9 STYPE XBPSTATIC_TYPE_RECESSEDBOX  RESIZE 'ny'
       DRGTEXT INTO drgFC CPOS  52, 0.3 CLEN 14 CAPTION 'Cena CELKEM' FONT 5
       DRGTEXT INTO drgFC CPOS  68, 0.3 CLEN 13 NAME M->nSumaKALK FONT 5 BGND 13 CTYPE( 2)
     DRGEND  INTO drgFC

*  CASE  cGET = 'nCenEnergP'
*    cTITLE := 'Kooperace 1 ... PLÁN'

  CASE  cGET = 'nCenMajetP'
    cTITLE := 'Kooperace 2 ... PLÁN'

  CASE  cGET = 'nCenMatZMS' .OR.  cGET = 'nCenMatMJS'

    nPrMatKal := SysConfig('Vyroba:nPrMatKal')
    cFILE  := IF( nPrMatKal = 1, 'PVPITEMw', 'UCETPOLw')
    cTITLE := IF( cGET = 'nCenMatZMS', 'Pøímý materiál v zahranièní mìnì ... SKUTEÈNOST',;
                                       'Pøímý materiál v CZK ... SKUTEÈNOST' )

     DRGFORM INTO drgFC SIZE 90, 10 DTYPE '10' ;
             TITLE cTITLE FILE cFILE  GUILOOK 'All:N,Border:Y,Message:y'

     IF nPrMatKal = 1                      // ze skladových pohybù
       DRGDBROWSE INTO drgFC SIZE 90,7.9 ;
                 FIELDS 'nDoklad,' + ;
                        'cSklPOL,' + ;
                        'cNazZbo::30,' + ;
                        'nMnozPrDod,' + ;
                        'cZkratJEDN,' + ;
                        'nCenaCelk' ;
                 SCROLL 'ny' CURSORMODE 3 PP 7
     ELSE                                  // z úèetních položek
       DRGDBROWSE INTO drgFC SIZE 90,7.9 ;
                 FIELDS 'nDoklad,' + ;
                        'cDenik ,' + ;
                        'cText::25  ,' + ;
                        'cObdobi,' + ;
                        'nMnozNAT,' + ;
                        'cZkratJEDN,' + ;
                        'nKcMD'      ;
                 SCROLL 'ny' CURSORMODE 3 PP 7
     ENDIF

     DRGSTATIC INTO drgFC FPOS 0.5,8 SIZE 89,1.9 STYPE XBPSTATIC_TYPE_RECESSEDBOX  RESIZE 'ny'
       DRGTEXT INTO drgFC CPOS  52, 0.3 CLEN 14 CAPTION 'Cena CELKEM' FONT 5
       DRGTEXT INTO drgFC CPOS  68, 0.3 CLEN 13 NAME M->nSumaKALK FONT 5 BGND 13 CTYPE( 2)
     DRGEND  INTO drgFC


  CASE  cGET = 'nCenMzdVDS'  .OR.  cGET = 'nCenSluzbS'
    cFILE  := 'ListITw'
    cTITLE := IF( cGET = 'nCenMzdVDS', 'Pøímé mzdy VD',;
                                       'Ostatní pøímé mzdy') + ' ... SKUTEÈNOST'

     DRGFORM INTO drgFC SIZE 90, 10 DTYPE '10' ;
             TITLE cTITLE FILE cFILE  GUILOOK 'All:N,Border:Y,Message:y'

     DRGDBROWSE INTO drgFC SIZE 90,7.9 ;
               FIELDS 'nOsCisPrac,' + ;
                      'VYR_MlOperace():Název operace:30,' + ;
                      'cObdobi,' + ;
                      'nKusyHotov,' + ;
                      'nNhNaOpeSk,' + ;
                      'nKcNaOpeSk' ;
               SCROLL 'ny' CURSORMODE 3 PP 7
*                      'VYR_kcnaopesk():KÈ/oper. SK.' ;

     DRGSTATIC INTO drgFC FPOS 0.5,8 SIZE 89,1.9 STYPE XBPSTATIC_TYPE_RECESSEDBOX  RESIZE 'ny'
       DRGTEXT INTO drgFC CPOS  52, 0.3 CLEN 14 CAPTION 'Cena CELKEM' FONT 5
       DRGTEXT INTO drgFC CPOS  68, 0.3 CLEN 13 NAME M->nSumaKALK FONT 5 BGND 13 CTYPE( 2)
     DRGEND  INTO drgFC


  CASE  cGET = 'nCenEnergS' .or. cGET = 'nCenMajetS'

    cFILE  := 'UCETPOLw'
    cTITLE := IF( cGET = 'nCenMatZMS', 'Kooperace 1 ... SKUTEÈNOST',;
                                       'Kooperace 2 ... SKUTEÈNOST')

    DRGFORM INTO drgFC SIZE 90, 10 DTYPE '10' ;
            TITLE cTITLE FILE cFILE  GUILOOK 'All:N,Border:Y,Message:y'

    DRGDBROWSE INTO drgFC SIZE 90,7.9 ;
                 FIELDS 'nDoklad,' + ;
                        'cDenik ,' + ;
                        'cText::25  ,' + ;
                        'cObdobi,' + ;
                        'nMnozNAT,' + ;
                        'cZkratJEDN,' + ;
                        'nKcMD'      ;
                 SCROLL 'ny' CURSORMODE 3 PP 7

    DRGSTATIC INTO drgFC FPOS 0.5,8 SIZE 89,1.9 STYPE XBPSTATIC_TYPE_RECESSEDBOX  RESIZE 'ny'
      DRGTEXT INTO drgFC CPOS  52, 0.3 CLEN 14 CAPTION 'Cena CELKEM' FONT 5
      DRGTEXT INTO drgFC CPOS  68, 0.3 CLEN 13 NAME M->nSumaKALK FONT 5 BGND 13 CTYPE( 2)
    DRGEND  INTO drgFC

  ENDCASE

RETURN drgFC