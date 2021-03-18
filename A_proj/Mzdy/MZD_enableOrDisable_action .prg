#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
#include "dbstruct.ch"
#include "Drgres.ch"
#include "dll.ch"
//
#include "..\Asystem++\Asystem++.ch"

*
** prg je urèen pro blokování akcí na SCR pøi zavøeném období
*
** class for mzd_enableOrDisable_action ***************************************
class MZD_enableOrDisable_action
exported:
  var  mzd_is_open

  inline method init(drgDialog)

    ::ab_members := drgDialog:oActionBar:members
    ::m_Dialog   := drgDialog

    drgDBMS:open('mzdZavhd')

    ::mzd_is_open :=  .not. mzdZavHD->( dbseek( strZero(uctOBDOBI:MZD:NROK,4) +strZero(uctOBDOBI:MZD:NOBDOBI,2) +'1',,'MZDZAVHD13'))
  return self

  inline method enableOrDisable_action()
    local  x, npos, ab := ::ab_members
    *
    local  pa      := { 'mzd_importdokl_ml', 'ImportMzLOld', 'mzd_newObdNemocHD', 'mzd_import_vypDan' }
    local  isClose :=  mzdZavHD->( dbseek( strZero(uctOBDOBI:MZD:NROK,4) +strZero(uctOBDOBI:MZD:NOBDOBI,2) +'1',,'MZDZAVHD13'))

    for x := 1 to len(pa) step 1
      if( npos := ascan( ab, { |s| lower(s:event) = lower(pa[x]) } )) <> 0
         if( isClose, ab[npos]:disable(), ab[npos]:enable() )
      endif
    next

    ::mzd_is_open := .not. isClose
  return self

hidden:
  var     ab_members, m_Dialog

endclass

