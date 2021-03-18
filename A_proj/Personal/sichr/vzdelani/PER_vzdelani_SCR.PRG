#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  OSOBY - VZDELANI
** CLASS PER_vzdelani_SCR *****************************************************
CLASS PER_vzdelani_SCR FROM drgUsrClass, OSB_osoby_IN

EXPORTED:
  METHOD  init
  METHOD  itemMarked
  METHOD  drgDialogStart
  *
  ** c_Vzdel->cNazVzdela
  inline access assign method nazVzdela() var nazVzdela
    c_vzdel->( dbseek( upper( vzdelani->czkrVzdel),,'C_VZDEL01'))
    return c_Vzdel->cnazVzdela
ENDCLASS


METHOD PER_vzdelani_SCR:init(parent)

  ::drgUsrClass:init(parent)

  drgDBMS:open('c_vzdel' )
  drgDBMS:open('c_vzdeUk')
  drgDBMS:open('c_psc'   )
  drgDBMS:open('c_staty' )

  drgDBMS:open('msPrc_mo')
RETURN self


METHOD PER_vzdelani_SCR:drgDialogStart()
RETURN self


METHOD PER_vzdelani_SCR:itemMarked(arowco,unil,oxbp)
  local  nky  := osoby->ncisOsoby

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     if m_file = 'osoby'
       vzdelani ->( mh_ordSetScope(nky,5))
     endif
   endif

  * relFor txt
  c_psc   ->(dbseek( vzdelani->cpsc      ,, 'C_PSC1'  ))
  c_staty ->(dbseek( vzdelani->czkratStat,, 'C_STATY1'))
RETURN SELF