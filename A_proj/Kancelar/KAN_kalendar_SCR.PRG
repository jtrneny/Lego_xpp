#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  KALENDAR
** CLASS KAN_kalendar_SCR ******************************************************
CLASS KAN_kalendar_SCR FROM drgUsrClass
EXPORTED:

  METHOD  init
  METHOD  itemMarked
  METHOD  drgDialogStart
ENDCLASS


METHOD KAN_kalendar_SCR:init(parent)

  ::drgUsrClass:init(parent)

  drgDBMS:open('osoby'   )
  drgDBMS:open('msPrc_mo')
  *
  drgDBMS:open('ukoly'   )
  drgDBMS:open('vazUkoly')

**  vazUkoly->( dbsetRelation( 'osoby', { || vazUkoly->cinUniqID },, 'uniqeIDRec' ))
RETURN self


method KAN_kalendar_SCR:drgDialogStart()
  local curr_Date := dtos( date())

  kalendar ->(dbseek( curr_Date,, 'KALENDAR01'))
RETURN self


METHOD KAN_kalendar_SCR:itemMarked()
  local  cf := "ctod('%%') >= dzacUkolu .and. dkonUkolu >= ctod('%%')", filtrs

  filtrs := format( cf, { dtoc(kalendar->ddatum), dtoc(kalendar->ddatum) })

  ukoly->( ads_setAof( filtrs ), dbgoTop())
RETURN SELF