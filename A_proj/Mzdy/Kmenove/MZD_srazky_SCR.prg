#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "gra.ch"
#include "dll.ch"

#include "..\Asystem++\Asystem++.ch"


//-----+ MZD_srazky_SCR +-------------------------------------------------------
CLASS MZD_srazky_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  method  Init
  method  drgDialogStart

  method  InFocus
  method  stableBlock
  method  CardOfSrazkyMzd

  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::rok    := uctOBDOBI:MZD:NROK
       ::obdobi := uctOBDOBI:MZD:NOBDOBI

       rokobd := (::rok*100) + ::obdobi
       cfiltr := Format("nROKOBD = %%", {rokobd})
       ::drgDialog:set_prg_filter( cfiltr, 'mssrz_mo')

       * zmìna na < p >- programovém filtru
       ::quick_setFilter( , 'apuq' )
       return .t.

    otherwise
      return .f.
    endcase
  return .f.

hidden:
  var  brow, rok, obdobi
  var  pa_relForText

endclass

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD MZD_srazky_SCR:Init(parent)
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr
  LOCAL cX

  ::drgUsrClass:init(parent)

  ::rok           := uctOBDOBI:MZD:NROK
  ::obdobi        := uctOBDOBI:MZD:NOBDOBI
  ::pa_relForText := {}

  drgDBMS:open('CNAZPOL4')
  drgDBMS:open('C_VYPLMI')
  drgDBMS:open('C_ZDRPOJ')
  drgDBMS:open('MSSRZ_MO')
  drgDBMS:open('C_STATY')
  drgDBMS:open('C_PSC')

  * programový filtr
  rokobd := (::rok*100) + ::obdobi
  cfiltr := Format("nROKOBD = %%", {rokobd})
  ::drgDialog:set_prg_filter( cfiltr, 'mssrz_mo')

RETURN self


METHOD MZD_srazky_SCR:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.

**
METHOD MZD_srazky_SCR:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:amembers, x, oDrg
  *
  local  pa := ::pa_relForText

  ::quickFiltrs:init( self                                             , ;
                      { { 'Kompletní seznam       ', ''            }, ;
                        { 'Pracovníci ve stavu    ', 'nstavem = 1' }, ;
                        { 'Pracovníci mimo stav   ', 'nstavem = 0' }  }, ;
                      'Zamìstnanci'                                      )


  ::brow := drgDialog:dialogCtrl:oBrowse

   for x := 1 to len(members) step 1
     odrg := members[x]
     if lower(odrg:ClassName()) $ 'drgtext'

       if( isArray(odrg:arRelate) .and. len(odrg:arRelate) <> 0, aadd( pa, odrg ), nil )
     endif
   next

RETURN self


*****************************************************************
* Pøi pohybu v seznamu
*****************************************************************

method MZD_srazky_scr:stableBlock(oxbp)
  local m_file, cfiltr

/*
  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'msprc_mo' )
       cfiltr := Format("nROK = %% .and. cRodCisPra = '%%'", {MSPRC_MO->nROK, MSPRC_MO->cRODCISPRA})
*       PRSMLDOH->(ads_setaof(cfiltr), dbGoTop())
       ::drgDialog:set_prg_filter(cfiltr, 'PRSMLDOH')

       cfiltr := Format("nROKOBD = %% .and. nOSCISPRAC = %% .and. nPORPRAVZT = %%"  ;
                       , {MSPRC_MO->nROKOBD, MSPRC_MO->nOSCISPRAC, MSPRC_MO->nPORPRAVZT})
*       MSSRZ_MO->(ads_setaof(cfiltr), dbGoTop())
       ::drgDialog:set_prg_filter(cfiltr, 'MSSRZ_MO')

       aeval( ::brow, { |o| if( o:oxbp = oxbp, nil, o:oxbp:refreshAll() ) })
     endcase
  endif
*/

return self


METHOD MZD_srazky_SCR:CardOfSrazkyMzd()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'MZD_srazky_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self



