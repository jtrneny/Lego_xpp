
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
CLASS VYR_Kalkul_all_scr FROM drgUsrClass
EXPORTED:
  METHOD  Init, Destroy, ItemMarked
ENDCLASS

********************************************************************************
METHOD VYR_Kalkul_all_scr:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('VyrZAK'  )
  drgDBMS:open('VyrPOL' )
RETURN self

********************************************************************************
METHOD VYR_Kalkul_all_scr:ItemMarked()
  Local cKey := Upper( KALKUL->cCisZakaz)+ Upper(KALKUL->cVyrPol) + StrZero( KALKUL->nVarCis, 3)

  VyrPOL->( dbSeek( cKey,, 'VYRPOL1'))
  VyrZAK->( dbSeek( cKey,, 'VYRZAK1'))
RETURN SELF

********************************************************************************
METHOD VYR_Kalkul_all_scr:destroy()
  ::drgUsrClass:destroy()
RETURN self

