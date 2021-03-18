/*==============================================================================
  VYR_IKUSOV_scr.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
* Inverzní kusovníky
********************************************************************************
CLASS VYR_IKUSOV_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init, drgDialogStart, EventHandled, getForm
  METHOD  GenIKUSOV
HIDDEN
  VAR     msg, nTypPOL
ENDCLASS

*
********************************************************************************
METHOD VYR_IKUSOV_SCR:Init(parent)
  ::drgUsrClass:init(parent)
  ::nTypPOL := parent:cargo

  drgDBMS:open('Kusov'   )
  drgDBMS:open('VyrPol'  )
  drgDBMS:open('IKUSOV' ,.T.,.T.,drgINI:dir_USERfitm)

RETURN self

*
********************************************************************************
METHOD VYR_IKUSOV_SCR:drgDialogStart(drgDialog)
  ::msg := drgDialog:parent:oMessageBar
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ::GenIKUSOV()
  drgDialog:dialogCtrl:oBrowse[1]:refresh()
RETURN self

*
********************************************************************************
METHOD VYR_IKUSOV_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_APPEND
      *  Insert není povolen
      RETURN .T.
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

*
********************************************************************************
METHOD VYR_IKUSOV_SCR:GenIKUSOV()
  Local lOK := YES, n, nPos, cTag, cKey, cTopPol
  Local nRecVP := VyrPOL->( RecNO()), cTagVP := VyrPOL->( AdsSetOrder( 1))
  Local aN, aV
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji inverzní kusovník ...')

  ::msg:writeMessage( cMsg, DRG_MSG_WARNING)

  cTag    := Kusov->( AdsSetOrder( IF( ::nTypPol = 0, 7, 6)))
  cTopPol := IF( ::nTypPol == 0, NakPol->cSklPol, VyrPol->cVyrPol )
  aN := { cTopPol }
  aV := {}

  IKusov->( AdsSetOrder( 1), dbZap() )
  IF ::nTypPol == 0    // Skl. položky
*     aN := { NakPol->cSklPol }
     KUSOV->( mh_SetScope( Upper( aN[ 1])) )
     DO WHILE !Kusov->( EOF())
        mh_CopyFLD( 'KUSOV', 'IKUSOV', .T.)
        IKusov->cVyrPol  := cTopPol
        cKey := Kusov->cCisZakaz + Kusov->cVysPol
        VyrPol->( dbSEEK( Upper( cKey),, 'VYRPOL1'))
        IKusov->cTypPol := VyrPol->cTypPol
        IF( ( nPos := ASCAN( aV, Kusov->cVysPol)) == 0)
           aADD( aV, Kusov->cVysPol)
        ENDIF
        Kusov->( dbSKIP())
     ENDDO
     KUSOV->( mh_ClrScope())
     ( aN := aV, aV := {} )
     Kusov->( AdsSetOrder( 6))
  ELSE
*     aN := { VyrPol->cVyrPol }
  ENDIF

  DO WHILE lOK
     FOR n := 1 TO LEN( aN)
       KUSOV->( mh_SetScope( Upper( aN[ n])) )
         DO WHILE !Kusov->( EOF())
            mh_CopyFLD( 'KUSOV', 'IKUSOV', .T.)
            IKusov->cVyrPol  := cTopPol
            cKey := Kusov->cCisZakaz + Kusov->cVysPol
            VyrPol->( dbSEEK( Upper( cKey),, 'VYRPOL1'))
            IKusov->cTypPol := VyrPol->cTypPol
            IF( ( nPos := ASCAN( aV, Kusov->cVysPol)) == 0)
               aADD( aV, Kusov->cVysPol)
            ENDIF
            Kusov->( dbSKIP())
         ENDDO
     KUSOV->( mh_ClrScope())
     NEXT
     ( aN := aV, aV := {} )
     lOK := ( LEN( aN) <> 0 )
  ENDDO
  Kusov->( AdsSetOrder( cTag))
  *
  VyrPOL->( AdsSetOrder( cTagVP), dbGoTO( nRecVP) )
  IKUSOV->( dbGoTOP())
  *
 ::msg:WriteMessage(,0)

RETURN Nil

*
********************************************************************************
METHOD VYR_IKUSOV_SCR:getForm()
  LOCAL oDrg, drgFC
  LOCAL cTitle := IF( ::nTypPol =  0, 'skladové položky', 'vyrábìné položky' )

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 110, 24 DTYPE '10' TITLE 'Inverzní kusovník ' + cTitle  ;
                                             FILE 'IKUSOV'                   ;
                                             GUILOOK 'All:N,Border:Y,IconBar:Y,Message:Y'

  DRGSTATIC INTO drgFC FPOS 0.5,0.1 SIZE 109,2.7 STYPE XBPSTATIC_TYPE_RAISEDBOX
  IF ::nTypPol = 0
    DRGTEXT INTO drgFC CAPTION 'Skladová položka'  CPOS  2, .1 CLEN 20 FONT 2
    DRGTEXT INTO drgFC CAPTION 'Název položky'     CPOS 37, .1 CLEN 20 FONT 2
    DRGTEXT INTO drgFC CAPTION 'Sklad'             CPOS 90, .1 CLEN 10 FONT 2
    DRGTEXT INTO drgFC NAME NAKPOL->cSklPOL        CPOS  2,1.3 CLEN 33 BGND 13 FONT 5
    DRGTEXT INTO drgFC NAME NAKPOL->cNazTPV        CPOS 37,1.3 CLEN 50 BGND 13 FONT 5
    DRGTEXT INTO drgFC NAME NAKPOL->cCisSklad      CPOS 90,1.3 CLEN 15 BGND 13 FONT 5

  ELSEIF ::nTypPol = 1
    DRGTEXT INTO drgFC CAPTION 'Vyrábìná položka'  CPOS  2, .1 CLEN 20 FONT 2
    DRGTEXT INTO drgFC CAPTION 'Název položky'     CPOS 37, .1 CLEN 20 FONT 2
    DRGTEXT INTO drgFC NAME VYRPOL->cVyrPOL        CPOS  2,1.3 CLEN 33 BGND 13 FONT 5
    DRGTEXT INTO drgFC NAME VYRPOL->cNAZEV         CPOS 37,1.3 CLEN 60 BGND 13 FONT 5
  ENDIF
  DRGEND  INTO drgFC

    DRGDBROWSE INTO drgFC SIZE 110,20.8 FPOS 0, 3.1 ;
                         FIELDS 'cCisZakaz, cVysPol, cNizPol, nNizVar, cSklPol,nPozice,nVarPoz,cStav,nCiMno,nSpMno'  ;
                         INDEXORD 1 SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y'

RETURN drgFC