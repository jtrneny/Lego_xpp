#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
*
** CLASS MZD_kmenove_SCR *******************************************************
CLASS DOH_zamdny_SCR FROM drgUsrClass
EXPORTED:
  var     obdobi
  var     stavem

  method  Init
  method  InFocus
  method  drgDialogStart
*  method  comboBoxInit
*  method  comboItemSelected
  method  InputOfDochazka
*  method  setSysFilter

  method  stableBlock
  *
*  method  mzd_doklhrmzdo_scr

  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
*       ::setSysFilter()
       ::obdobi := uctOBDOBI:MZD:NOBDOBI
       return .t.
    otherwise
      return .f.
    endcase
  return .f.

hidden:
  var  brow

endclass

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD DOH_zamdny_SCR:Init(parent)
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr
  LOCAL cX

  ::drgUsrClass:init(parent)

  ::obdobi := uctOBDOBI:MZD:NOBDOBI
  ::stavem := '1'

  drgDBMS:open('CNAZPOL4')
  drgDBMS:open('MSPRC_MO')
  drgDBMS:open('C_PRACDO')
  drgDBMS:open('OSOBY')
  drgDBMS:open('DRUHYMZD')

RETURN self


METHOD DOH_zamdny_SCR:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


METHOD DOH_zamdny_SCR:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse
RETURN self


method DOH_zamdny_SCR:stableBlock(oxbp)
  local m_file, cfiltr

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'osoby' )
       cfiltr := Format("nCISOSOBY= %%", {OSOBY->nCISOSOBY})
       DSPOHYBY->(ads_setaof(cfiltr), dbGoTop())

       aeval( ::brow, { |o| if( o:oxbp = oxbp, nil, o:oxbp:refreshAll() ) })
     endcase
  endif
return self


METHOD DOH_zamdny_SCR:InputOfDochazka()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'DOH_dochazkadny_IN' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self

