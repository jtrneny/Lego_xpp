#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "gra.ch"
#include "dll.ch"

#include "..\Asystem++\Asystem++.ch"

*
*  MSPRC_MO
** CLASS PER_kmenmsMo_SCR *****************************************************
CLASS PER_kmenmsMo_SCR FROM MZD_kmenove_SCR
EXPORTED:
  METHOD  init
ENDCLASS

METHOD PER_kmenmsMo_SCR:init(parent)
    parent:formName  := 'PER_kmenmsMo_SCR'
    parent:initParam := 'MZD_kmenove_SCR'

  ::drgUsrClass:init(parent)
  ::MZD_kmenove_SCR:init(parent,'per')
RETURN self




