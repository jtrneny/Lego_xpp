#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "..\FINANCE\FIN_finance.ch"

static last



**
** CLASS for FIN_prikuhit_SCR **************************************************
CLASS FIN_prikuhit_SCR FROM drgUsrClass
EXPORTED:
  var     lnewRec, labo_New
  *
  ** pro nový export do bankou
  var     cpath_kom, cfile_kom, istuz
  *
  ** pro omezení nabídky pro pøíkazy FIN/MZD
  var     subtask

  METHOD  init, drgDialogStart, itemMarked

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nEvent = xbeBRW_ItemMarked)
    endcase
    return .f.

hidden:
  var     msg, csection


ENDCLASS


METHOD FIN_prikuhit_SCR:init(parent)
  local c_FIN_fltpruhr, filter := ''

  ::drgUsrClass:init(parent)

  drgDBMS:open('c_bankuc')
  drgDBMS:open('fakprihd')
  drgDBMS:open('banky_cr')
  drgDBMS:open('datkomhd')
  drgDBMS:open('c_typPoh')

  * mzdy
  drgDBMS:open('mzdzavhd')

  * pøidán nový parametr FIN_fltpruhr
  ::subtask := ''

  if isCharacter( c_FIN_fltpruhr := sysConfig('finance:cfltpruhr'))
    c_FIN_fltpruhr := upper( c_FIN_fltpruhr )

    do case
    case at( 'FIN', c_FIN_fltpruhr ) <> 0 .and. at( 'MZD', c_FIN_fltpruhr ) <> 0
      ** ALL **
    case at( 'FIN', c_FIN_fltpruhr ) <> 0
      ::subtask := 'FIN'
         filter := format("(upper(csubtask) <> '%%')", { 'MZD' })
    case at( 'MZD', c_FIN_fltpruhr ) <> 0
      ::subtask := 'MZD'
         filter := format("(upper(csubtask) =  '%%')", { 'MZD' })
    endcase
  endif

  if .not. empty( ::subtask )
*    ::drgDialog:set_prg_filter(filter, 'prikuhhd')
  endif

  ::lnewRec  := .f.
  ::labo_New := .f.
  ::csection := ''
RETURN self


METHOD FIN_prikuhit_SCR:drgDialogStart(drgDialog)
  ::msg       := drgDialog:oMessageBar             // messageBar

  ::cpath_kom := ''
  ::cfile_kom := ''
RETURN


METHOD FIN_prikuhit_SCR:itemMarked()
  local  cky       := StrZero(PRIKUHIT->nDOKLAD,10)


RETURN SELF

