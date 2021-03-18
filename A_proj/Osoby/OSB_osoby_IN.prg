#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "gra.ch"
#include "dll.ch"

#include "..\Asystem++\Asystem++.ch"

* KANCELAR
function vazDokum_osoby(cfield)
  local  npos := osoby->(fieldPos(cfield))

  osoby->( dbseek( vazDokum->nOSOBY,, 'ID'))
  return osoby->(fieldGet(npos))

function vazUkoly_osoby(cfield)
  local  npos := osoby->(fieldPos(cfield))

  osoby->( dbseek( vazUkoly->nOSOBY,, 'ID'))
  return osoby->(fieldGet(npos))

function vazSpoje_osoby(cfield)
  local  npos := osoby->(fieldPos(cfield))

  osoby->( dbseek( vazSpoje->nOSOBY,, 'ID'))
  return osoby->(fieldGet(npos))


* OSBOBY
function vazSpoje_spojeni(cfield)
  local  npos := spojeni->(fieldPos(cfield))

  spojeni ->( dbseek( vazSpoje->SPOJENI,, 'ID'))
  return spojeni->(fieldGet(npos))

function vazFirmy_firmy(cfield)
  local  npos := firmy->(fieldPos(cfield))

  firmy ->( dbseek( vazFirmy->FIRMY,, 'ID'))
  return firmy->(fieldGet(npos))

function vazUkoly_ukoly(cfield)
  local  npos := ukoly->(fieldPos(cfield))

  ukoly ->( dbseek( vazUkoly->UKOLY,, 'ID'))
  return ukoly->(fieldGet(npos))

function vazDokum_dokument(cfield)
  local  npos := dokument->(fieldPos(cfield))

  dokument ->( dbseek( vazDokum->DOKUMENT,, 'ID'))
  return dokument->(fieldGet(npos))


* PERSONAL_scr
function vazSkol_osoby(cfield)
 local  npos := osoby->(fieldPos(cfield))

  osoby->( dbseek( vazSkol->nOSOBY,, 'ID'))
  return osoby->(fieldGet(npos))

function vazLekpr_osoby(cfield)
 local  npos := osoby->(fieldPos(cfield))

  osoby->( dbseek( vazLekpr->nOSOBY,, 'ID'))
  return osoby->(fieldGet(npos))

function vazOsoby_osoby_Rp(cfield)
 local  npos := osoby_Rp->(fieldPos(cfield))

  osoby_Rp->( dbseek( vazOsoby->nOSOBY,, 'ID'))
  return osoby_Rp->(fieldGet(npos))

function vazLekpr_lekProhl(cfield)
 local  npos := lekProhl->(fieldPos(cfield))

  lekProhl->( dbseek( vazLekpr->LEKPROHL,, 'ID'))
  return lekProhl->(fieldGet(npos))

function vazSkol_skoleni(cfield)
 local  npos := skoleni->(fieldPos(cfield))

  skoleni->( dbseek( vazSkol->SKOLENI,, 'ID'))
  return skoleni->(fieldGet(npos))


*
** CLASS OSB_osoby_IN *********************************************************
CLASS OSB_osoby_IN
EXPORTED:

  inline access assign method is_inPersonal() var is_inPersonal
    return if( osoby->nis_PER = 1, MIS_ICON_OK, 0 )

  inline access assign method is_inMsPrc_mo() var is_inMsPrc_mo
    local  retVal := 0

    if msPrc_mo->(dbseek( osoby->ncisOsoby,,'MSPRMO13'))
      retVal := if( msPrc_mo->nosCisprac = osoby->nosCisPrac, MIS_ICON_OK, 0 )
    endif
    return retVal

  * browColumn
  inline access assign method is_isZAM() var is_isZAM      // ? je v msPrc_mo
    return if( osoby->nis_ZAM = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isPER() var is_isPER      // ? je v personal
    return if( osoby->nis_PER = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isDOH() var is_isDOH      // ? je v dsPohyby
    return if( osoby->nis_DOH = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isRPR() var is_isRPR      // ? je v rodPrisl
    return if( osoby->nis_RPR = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isEXT() var is_isEXT      // ? je to extreníPracovník
    return if( osoby->nis_EXT = 1, MIS_ICON_OK, 0 )

ENDCLASS