***************************************************************************
*  SKL_CENZBIN_SCR  ... Inventury skladových karet
***************************************************************************
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Drgres.ch"
#include "..\SKLADY\SKL_Sklady.ch"

*
********************************************************************************
CLASS SKL_CenZbIN_SCR FROM drgUsrClass
EXPORTED:
  VAR     dDatumINS
  VAR     dDatumDEL, lALL

  METHOD  Init
  METHOD  DatumINV
  METHOD  Inventura_INS
  METHOD  Inventura_DEL, CheckItemSelected

ENDCLASS

*
*****************************************************************
METHOD SKL_CenZbIN_SCR:init(parent)
  ::drgUsrClass:init(parent)

  ::dDatumINS := DATE()
  ::dDatumDEL := DATE()
  ::lALL      := .F.
  *
  drgDBMS:open('CENZBOZ')  ; CenZBOZ->( AdsSetOrder(3))
RETURN self


METHOD SKL_CenZbIN_SCR:CheckItemSelected(drgVar)
  ::lALL := drgVar:value
RETURN self

*
********************************************************************************
METHOD SKL_CenZbIN_SCR:DatumINV( oVAR )

  IF oVAR:NAME = 'M->dDatumINS'
    ::dDatumINS := oVAR:value
  ELSEIF oVAR:NAME = 'M->dDatumDEL'
    ::dDatumDEL := oVAR:value
*  ELSEIF oVAR:NAME = 'M->lALL'
*    ::lAll := oVAR:value

  ENDIF
  ::drgDialog:oForm:setNextFocus(-1,.T. )
RETURN .T.

* Generování nové inventury k zadanému datu
********************************************************************************
METHOD SKL_CenZbIN_SCR:Inventura_INS()
  Local cZAPIS := SysCONFIG( 'System:cUserABB')
  Local msg := ::drgDialog:oMessageBar
  Local cKEY, lOK, lNew

  drgServiceThread:progressStart(drgNLS:msg('Generuji novou inventuru ...', 'CENZBOZ'), CenZboz->(LASTREC()) )
  CenZBOZ->( dbGoTOP())
  DO WHILE !CenZBOZ->( EOF())
    IF ( lOK := IF( ::lALL, .T., Upper( CenZboz->cPolCen) = 'C' ) )
      cKEY := Upper( CenZBOZ->cCisSKLAD) + Upper( CenZBOZ->cSklPOL) + ;
              DTOS( ::dDatumINS )

      lOK  := CenZB_IN->( dbSEEK( cKEY,,'CENINV01'))
      lNew := .not. lOK
      IF( lOK := IF( lOK, ReplREC( 'CenZB_IN'), AddREC( 'CenZB_IN') ) )
        mh_COPYFLD('CENZBOZ', 'CenZb_IN' )
        CenZB_IN->dDatInven := ::dDatumINS
        CenZB_IN->nMnozIZBO := CENZBOZ->nMnozSZBO
        mh_WRTzmena( 'CenZB_IN', lNew )
*        CenZB_IN->cZAPIS    := cZAPIS
*        CenZB_IN->dZAPIS    := DATE()
        CenZB_IN->( dbUnlock())
      ENDIF

    ENDIF
    CenZBOZ->( dbSKIP())
    drgServiceThread:progressInc()
  ENDDO
  CenZB_IN->( dbGoTOP() )
  drgServiceThread:progressEnd()
  *
  ::drgDialog:dialogCtrl:oaBrowse:refresh( .T.)
  SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
  msg:WriteMessage('Inventura ke dni  ' + DTOC(::dDatumINS) + '  ukonèena', DRG_MSG_INFO)
RETURN SELF

* Rušení inventury k zadanému datu
********************************************************************************
METHOD SKL_CenZbIN_SCR:Inventura_DEL()
  Local cTAG := CenZB_IN->( AdsSetOrder( 1))
  Local cKEY, lOK, n, nCount := 0
  Local msg := ::drgDialog:oMessageBar, cC := MIS_ICON_APPEND

  msg:WriteMessage('Probíhá rušení inventury ke dni  ' + DTOC(::dDatumDEL), DRG_MSG_INFO)
*  drgServiceThread:progressStart(drgNLS:msg('Ruším zadanou inventuru ...', 'CENZBOZ'), CenZboz->(LASTREC()) )
  CenZBOZ->( dbGoTOP())
  DO WHILE !CenZBOZ->( EOF())
    cKEY := Upper( CenZBOZ->cCisSKLAD) + Upper( CenZBOZ->cSklPOL) + ;
            DTOS( ::dDatumDEL )
    lOK := CenZB_IN->( dbSEEK( cKEY))
    IF( lOK, DelREC( 'CenZB_IN'), NIL )
    CenZBOZ->( dbSKIP())
    nCount++
    IF (( nCount % 200 ) == 0)
      cC := IF( cC == MIS_ICON_APPEND, MIS_ICON_QUIT, MIS_ICON_APPEND)
      msg:picStatus:setCaption( cC)
      msg:picStatus:show()
    ENDIF
*    drgServiceThread:progressInc()
  ENDDO
  CenZB_IN->( AdsSetOrder( cTAG), dbGoTOP() )
*  drgServiceThread:progressEnd()

  ::drgDialog:dialogCtrl:oaBrowse:refresh( .T.)
  SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
  msg:WriteMessage('Inventura ke dni  ' + DTOC(::dDatumDEL) + '  zrušena', DRG_MSG_WARNING)
RETURN self