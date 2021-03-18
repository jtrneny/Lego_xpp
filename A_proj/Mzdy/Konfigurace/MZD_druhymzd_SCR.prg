#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

*
*
** CLASS MZD_druhyMzd_SCR ******************************************************
CLASS MZD_druhymzd_SCR FROM drgUsrClass
EXPORTED:
  METHOD  Init
  METHOD  CardOfPrumMzd
  METHOD  drgDialogStart
  METHOD  Destroy

  method  DoplnDMZ_RML

  inline access assign method is_danZaklad() var is_danZaklad
    return if( druhyMzd->ldanZaklad,  MIS_ICON_OK, 0)

  inline access assign method is_vypocCM()   var is_vypocCM
    return if( druhyMzd->lvypocCM,    MIS_ICON_OK, 0)

  inline access assign method is_uctuj()     var is_uctuj
    return if( druhyMzd->luctuj,      MIS_ICON_OK, 0)

  inline access assign method is_socPojis()  var is_socPojis
    return if( druhyMzd->lsocPojis,   MIS_ICON_OK, 0)

  inline access assign method is_zdrPojis()  var is_zdrPojis
    return if( druhyMzd->lzdrPojis,   MIS_ICON_OK, 0)

  inline access assign method is_napEvidLi() var is_napEvidLi
    return if( druhyMzd->lnapEvidLi,  MIS_ICON_OK, 0)

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  rokObd, cfiltr

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::setSysFilter()

*       ::rok    := uctOBDOBI:MZD:NROK
*       ::obdobi := uctOBDOBI:MZD:NOBDOBI

*       rokobd := (::rok*100) + ::obdobi
*       cfiltr := Format("nROKOBD = %%", {rokobd})
*       ::drgDialog:set_prg_filter( cfiltr, 'druhyMzd')
       return .t.

    otherwise
      return .f.
    endcase
  return .f.

hidden:
  var  brow, rok, obdobi

  inline method setSysFilter( ini )
    local cfiltr, ft_APU_cond, filtrs

    default ini to .f.

    ::rok    := uctOBDOBI:MZD:NROK
    ::obdobi := uctOBDOBI:MZD:NOBDOBI
    rokobd   := (::rok*100) + ::obdobi

    cfiltr  := Format("nROKOBD = %%", {rokObd})

    if ini
      ::drgDialog:set_prg_filter(cfiltr, 'druhyMzd')

    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('druhyMzd', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      ::drgDialog:set_prg_filter(cfiltr, 'druhyMzd')

      druhyMzd->( ads_setaof(filtrs), dbGoTop())
      ::brow[1]:oxbp:refreshAll()
    endif
  return self


ENDCLASS


*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD MZD_druhymzd_SCR:Init(parent)
  local rokObd, cfiltr

  ::drgUsrClass:init(parent)

  ::rok    := uctOBDOBI:MZD:NROK
  ::obdobi := uctOBDOBI:MZD:NOBDOBI

* programový filtr
  rokObd := (::rok*100) + ::obdobi
  cfiltr := Format("nROKOBD = %%", {rokobd})
  ::drgDialog:set_prg_filter( cfiltr, 'druhyMzd')
RETURN self


METHOD MZD_druhymzd_SCR:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse
RETURN self


METHOD MZD_druhymzd_SCR:CardOfPrumMzd()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'MZD_druhymzd_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self


METHOD MZD_druhymzd_SCR:DoplnDMZ_RML()
  local n, i, key, poc

*  drgDBMS:open('druhyMzd',,,,,'druhyMz_S')
  drgDBMS:open('c_nazrml')

  c_nazrml->(dbGoTop())
  do while .not. c_nazrml->( Eof())
    if c_nazrml->( dbRlock())
      c_nazrml->mvyber := ''
      c_nazrml->( dbUnlock())
    endif
    c_nazrml->( dbSkip())
  enddo

  druhymzd->( dbGoTop())

  do while .not. druhymzd->( Eof())
    if .not. Empty(druhymzd->dny)
      poc := Len( AllTrim( druhymzd->dny))/3
      i := 1
      for n:= 1 to poc
        key := SubStr( druhymzd->dny, i, 3)
        if c_nazrml->( dbSeek( Val(key),,'C_NAZRML03'))
          if c_nazrml->( dbRlock())
            if .not. Empty(c_nazrml->mvyber)
              c_nazrml->mvyber := c_nazrml->mvyber + ','
            endif
            c_nazrml->mvyber := c_nazrml->mvyber + AllTrim(Str(druhymzd->ndruhmzdy))
            c_nazrml->( dbUnlock())
          endif
        endif
        i := i + 3
      next
    endif

    if .not. Empty(druhymzd->hodiny)
      poc := Len( AllTrim( druhymzd->hodiny))/3
      i := 1
      for n:= 1 to poc
        key := SubStr( druhymzd->hodiny, i, 3)
        if c_nazrml->( dbSeek( Val(key),,'C_NAZRML03'))
          if c_nazrml->( dbRlock())
            if .not. Empty(c_nazrml->mvyber)
              c_nazrml->mvyber := c_nazrml->mvyber + ','
            endif
            c_nazrml->mvyber := c_nazrml->mvyber + AllTrim(Str(druhymzd->ndruhmzdy))
            c_nazrml->( dbUnlock())
          endif
        endif
        i := i + 3
      next
    endif

    if .not. Empty(druhymzd->Hruba_mzda)
      poc := Len( AllTrim( druhymzd->Hruba_mzda))/3
      i := 1
      for n:= 1 to poc
        key := SubStr( druhymzd->Hruba_mzda, i, 3)
        if c_nazrml->( dbSeek( Val(key),,'C_NAZRML03'))
          if c_nazrml->( dbRlock())
            if .not. Empty(c_nazrml->mvyber)
              c_nazrml->mvyber := c_nazrml->mvyber + ','
            endif
            c_nazrml->mvyber := c_nazrml->mvyber + AllTrim(Str(druhymzd->ndruhmzdy))
            c_nazrml->( dbUnlock())
          endif
        endif
        i := i + 3
      next
    endif

    druhymzd->( dbSkip())
  enddo

return .t.


METHOD MZD_druhymzd_SCR:destroy()
 ::drgUsrClass:destroy()

RETURN SELF