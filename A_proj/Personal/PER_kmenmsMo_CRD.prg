#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
#include "common.ch"
#include "drg.ch"
#include "CLASS.CH"

#include "..\Asystem++\Asystem++.ch"
#include "..\Mzdy\Kmenove\MZD_kmenove_.ch"



*  PERSONAL Kmenové údaje zamìstnancù _ PER_kmenmsMo_CRD **********************
CLASS PER_kmenmsMo_CRD FROM MZD_kmenove_CRD
EXPORTED:
  METHOD  init
ENDCLASS

METHOD PER_kmenmsMo_CRD:init(parent)
    parent:formName  := 'PER_kmenmsMo_CRD'
    parent:initParam := 'MZD_kmenove_CRD'

  ::drgUsrClass:init(parent)
  ::MZD_kmenove_CRD:init(parent,'per')
RETURN self
