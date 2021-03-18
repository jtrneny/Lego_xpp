#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


function PRO_firmyset()
   local ky := strzero(procenhd->ntypprocen,5)  + ;
               strzero(procenhd->ncisprocen,10) + ;
               strzero(firmy->ncisfirmy,5)
return .not. procenfi_w->(dbseek(ky,,'PROCENHFI1'))


function PRO_typprocen(typ)
  local  retVal := '', pos
  local  typProCen := { {1, 'Prodejní cena             '}, {2, 'Množstevní sleva          '}, ;
                        {3, 'Sleva na zboží  -obrat    '}, {4, 'Sleva na zboží  -fakturace'}, ;
                        {5, 'Sleva na doklad -obrat    '}, {6, 'Sleva na doklad -fakturace'}  }
  if isnull(typ)
    retval := typProCen
  else
    if (pos := ascan(typProCen,{|x| x[1] = typ})) <> 0
      retVal := typProCen[pos,2]
    endif
  endif
return retVal


*
** CLASS for PRO_procenfi_IN *******************************************
CLASS PRO_procenfi_IN FROM drgUsrClass
exported:
  method  init, getForm, drgDialogInit, drgDialogStart
  method  leftACtion, rightAction
  method  drgDialogEnd

  * procenhd
  inline access assign method hlaProCen() var hlaProCen
    return if( procenhd->lhlaProCen, 172, 0)

  inline access assign method typProCen() var typProCen
    return PRO_typprocen(procenhd->ntypprocen)

  * procenfi
  inline access assign method nazFirmy() var nazFirmy
  firmy_pc->(dbseek(procenfi->ncisfirmy,,'FIRMY1'))
  return firmy_pc->cnazev

hidden:
*  sys
   var     msg, dm, dc
ENDCLASS


method PRO_procenfi_IN:init(parent)
  local  filtr := format("ntypprocen = %% .and. ncisprocen = %%",{procenhd->ntypprocen,procenhd->ncisprocen})
  ::drgUsrClass:init(parent)

  drgDBMS:open('firmy',,,,,'firmy_pc')
  drgDBMS:open('procenfi',,,,,'procenfi_w')
  *
  drgDBMS:open('procenfi')
  procenfi->(dbsetfilter(COMPILE(filtr)), dbgotop())
  firmy->(dbsetfilter({|| PRO_firmyset()}), dbgotop())
return self


method PRO_procenfi_IN:getForm()
  local  oDrg, drgFC
  *
  local  typProCen := procenhd->ntypprocen

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,17 DTYPE '10' TITLE 'Nastavení prodejních cen a slev pro firmy ...' ;
                                            FILE 'procenfi'                                       ;
                                            GUILOOK 'All:N,Border:Y'


* 1 - firmy
  DRGDBROWSE INTO drgFc FPOS  0,1.3 SIZE 42,15 FILE 'firmy'   ;
    FIELDS 'ncisfirmy:èísloFirmy,' + ;
           'cnazev:názevFirmy:30'    ;
    CURSORMODE 3 INDEXORD 1 PP(7) SCROLL 'ny'

* 2 - procenfi
  DRGDBROWSE INTO drgFc FPOS 58,1.3 SIZE 42,15 FILE 'procenfi' ;
    FIELDS 'ncisfirmy:èísloFirmy,'    + ;
           'M->nazFirmy:názevFirmy:30'  ;
    CURSORMODE 3 SCROLL 'ny' PP 7

  DRGCHECKBOX procenhd->lhlaprocen INTO drgFc FPOS    .5,.07 FLEN  2 VALUES 'T: ,F: '
    odrg:rOnly := .t.

  DRGSTATIC INTO drgFC FPOS 3,0 SIZE 93,1.2 STYPE XBPSTATIC_TYPE_RECESSEDBOX
    odrg:ctype := 2

    DRGTEXT     M->typprocen         INTO drgFc CPOS   .2,.07 CLEN 26 FONT 5

    DRGTEXT INTO drgFC CAPTION '['      CPOS 26,.07 CLEN  2 FONT 5
      DRGTEXT     procenhd->coznprocen INTO drgFc CPOS  28,.07 CLEN 15
      DRGTEXT     procenhd->cnazprocen INTO drgFc CPOS  43,.07 CLEN 36
      DRGTEXT     procenhd->czkratmeny INTO drgFc CPOS  78,.07 CLEN  4
    DRGTEXT INTO drgFC CAPTION ']'      CPOS 82,.07 CLEN 10.6 FONT 5
  DRGEND  INTO drgFC

  DRGPUSHBUTTON INTO drgFC POS 97,0 SIZE 3,1 ATYPE 1 ICON1 102 ICON2 202 EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
  DRGPUSHBUTTON INTO drgFC CAPTION '>>' POS 45, 6 SIZE 10,1  EVENT 'leftAction'
  DRGPUSHBUTTON INTO drgFC CAPTION '<<' POS 45,10 SIZE 10,1  EVENT 'rightAction'
return drgFC


method PRO_procenfi_IN:drgDialogInit(drgDialog)
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  drgDialog:hasIconArea := drgDialog:hasActionArea := ;
  drgDialog:hasMsgArea  := drgDialog:hasMenuArea   := drgDialog:hasBorder := .F.
  XbpDialog:titleBar    := .F.
return


method  PRO_procenfi_IN:drgDialogStart(drgDialog)
  local  x, members := drgDialog:oForm:aMembers, odrg
  local        obro := drgDialog:dialogCtrl:obrowse[1], ocolumn
  local       obord := drgDialog:obord

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl


   for x := 1 TO LEN(members) step 1
    odrg := members[x]

    if odrg:className() <> 'drgCheckBox'
      if((odrg:className() = 'drgStatic') .or. ;
         (odrg:className() = 'drgText' .and. odrg:obord:type = 1), ;
          odrg:oxbp:setcolorbg(GraMakeRGBColor( {0, 255, 0} )), nil)
    endif
  next

  for x := 1 to obro:oXbp:colcount step 1
    ocolumn := oBro:oXbp:getColumn(x)
    ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
    ocolumn:configure()
  next
  obro:oXbp:refreshAll()
return self


method PRO_procenfi_IN:leftAction()
  mh_copyfld('firmy','procenfi', .t., .f.)
    procenfi->ntypprocen := procenhd->ntypprocen
    procenfi->ncisprocen := procenhd->ncisprocen

    procenfi->(dbcommit())

    ::dc:obrowse[1]:oxbp:gotop()
    PostAppEvent(xbeK_CTRL_PGDN,,::dc:obrowse[1]:oxbp)
    ::dc:obrowse[1]:oxbp:refreshAll()

    ::dc:obrowse[2]:oxbp:refreshAll()
return.t.


method PRO_procenfi_IN:rightAction()

  if procenfi->(dbrlock())
    procenfi->(dbdelete())
    ::dc:obrowse[1]:oxbp:refreshAll()
    ::dc:obrowse[2]:oxbp:refreshAll()
  endif
  procenfi->(dbunlock())
return .t.



method PRO_procenfi_IN:drgDialogEnd()
  procenfi->(dbclearfilter(), dbgotop())
  firmy->(dbclearfilter(), dbgotop())
return self

