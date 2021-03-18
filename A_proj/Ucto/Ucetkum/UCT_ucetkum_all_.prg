#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


function uct_ucetkum_all_(column)
  local  xretVal := ''

  ucetsys->(dbseek('U' +upper(ucetkum->cobdobi),,'UCETSYS2'))

  do case
  case(column = 'uzav')  ;  xretVal := if(ucetsys->lzavren      ,U_big   ,0)
  case(column = 'aktu')  ;  xretVal := if(ucetsys->naktuc_ks = 2,MIS_BOOK,0)
  case(column = 'obdo')  ;  xretVal := str(ucetkum->nobdobi,2) +'/' +str(ucetkum->nrok,4)
  endcase
return xretVal


function uct_ucetkumu_all_(column)
  local  xretVal := ''

  ucetsys->(dbseek('U' +upper(ucetkumu->cobdobi),,'UCETSYS2'))

  do case
  case(column = 'uzav')  ;  xretVal := if(ucetsys->lzavren      ,U_big   ,0)
  case(column = 'aktu')  ;  xretVal := if(ucetsys->naktuc_ks = 2,MIS_BOOK,0)
  case(column = 'obdo')  ;  xretVal := str(ucetpol->nobdobi,2) +'/' +str(ucetpol->nrok,4)
  endcase
return xretVal


*
** CLASS for UCT_ucetkum_obraty_SCR ********************************************
CLASS UCT_ucetkum_obraty_SCR FROM drgUsrClass
EXPORTED:
  VAR     cDENIK

  METHOD  Init, comboItemSelected, itemSelected

  inline access assign method nazevUctu()  var nazevUctu
    c_uctosn->(dbSeek(upper(ucetkum->cucetmd)))
    return c_uctosn->cnaz_uct


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected()
    CASE nEvent = drgEVENT_DELETE
      RETURN .T.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

ENDCLASS


METHOD UCT_ucetkum_obraty_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::cDENIK := 'A'

  drgDBMS:open('UCETPOL')
  drgDBMS:open('C_UCTOSN')

  drgDBMS:open('UCETSYS')

  // relace //
//  UCETPOLA ->( DbSetRelation( 'C_UCTOSN', { || UPPER(UCETPOLA->CUCETMD) }))
RETURN self


METHOD UCT_ucetkum_obraty_SCR:comboItemSelected(mp1, mp2, o)
  LOCAL  dc     := ::drgDialog:dialogCtrl

  IF ::cDENIK <> mp1:value
    UCETPOLA ->( Ads_SetAof("cDENIK = '" +mp1:value +"'"), ;
                 dbGoTop()                                   )

    dc:oaBrowse:refresh(.T.)
    SetAppFocus(dc:oaBrowse:oXbp)
  ENDIF
RETURN .T.


METHOD UCT_ucetkum_obraty_SCR:itemSelected()
/*
  Local  nRECs  := UCETPOLA ->(RECNO())
  Local  nORDs  := UCETPOLA ->(OrdSetFocus())
  Local  oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'UCT_ucetpola_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

  UCETPOLA ->(OrdSetFocus(nORDs), DBGoTo(nRECs))
*/
Return self


*
** CLASS for UCT_ucetkum_karty_SCR ********************************************
CLASS UCT_ucetkum_karty_SCR FROM drgUsrClass
EXPORTED:
  var     cDENIK
  method  init, comboItemSelected, itemMarked, drgDialogEnd

  inline access assign method obdDokl() var obdDokl
    return str(ucetkum->nobdobi,2) +'/' +str(ucetkum->nrok,4)

  inline access assign method nazevUctu()  var nazevUctu
    c_uctosnw->(dbSeek(upper(ucetkum->cucetmd)))
    return c_uctosnw->cnaz_uct

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT
*-      ::itemSelected()
    CASE nEvent = drgEVENT_DELETE
      RETURN .T.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

ENDCLASS


METHOD UCT_ucetkum_karty_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::cDENIK := 'A'

  drgDBMS:open('UCETPOL')
  drgDBMS:open('C_UCTOSN')
  drgDBMS:open('C_UCTOSN',,,,,'c_uctosnw')

  drgDBMS:open('UCETSYS')

  // relace //
//  UCETPOLA ->( DbSetRelation( 'C_UCTOSN', { || UPPER(UCETPOLA->CUCETMD) }))
RETURN self


METHOD UCT_ucetkum_karty_SCR:comboItemSelected(mp1, mp2, o)
  LOCAL  dc     := ::drgDialog:dialogCtrl

  IF ::cDENIK <> mp1:value
    UCETPOLA ->( Ads_SetAof("cDENIK = '" +mp1:value +"'"), ;
                 dbGoTop()                                   )

    dc:oaBrowse:refresh(.T.)
    SetAppFocus(dc:oaBrowse:oXbp)
  ENDIF
RETURN .T.


METHOD UCT_ucetkum_karty_SCR:itemMarked()
  local  ky := upper(c_uctosn->cucet)

  ucetkum->(ordSetFocus('UCETK_04'),dbSetScope(SCOPE_BOTH,ky), dbGoTop())
Return self


method uct_ucetkum_karty_SCR:drgDialogEnd()
  ucetkum->(dbClearScope())
return self



*
** CLASS for UCT_ucetkumu_karty_SCR ********************************************
CLASS UCT_ucetkumu_karty_SCR FROM drgUsrClass
EXPORTED:
  var     cDENIK
  method  init, comboItemSelected, itemMarked, drgDialogEnd

  inline access assign method obdDokl() var obdDokl
    return str(ucetkumu->nobdobi,2) +'/' +str(ucetkumu->nrok,4)

  inline access assign method nazevUctu()  var nazevUctu
    c_uctosnw->(dbSeek(upper(ucetkumu->cucetmd)))
    return c_uctosnw->cnaz_uct

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT
*-      ::itemSelected()
    CASE nEvent = drgEVENT_DELETE
      RETURN .T.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

ENDCLASS


METHOD UCT_ucetkumu_karty_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::cDENIK := 'A'

  drgDBMS:open('UCETPOL')
  drgDBMS:open('C_UCTOSN')
  drgDBMS:open('C_UCTOSN',,,,,'c_uctosnw')

  drgDBMS:open('UCETSYS')
RETURN self


METHOD UCT_ucetkumu_karty_SCR:comboItemSelected(mp1, mp2, o)
  LOCAL  dc     := ::drgDialog:dialogCtrl

  IF ::cDENIK <> mp1:value
    UCETPOLA ->( Ads_SetAof("cDENIK = '" +mp1:value +"'"), ;
                 dbGoTop()                                   )

    dc:oaBrowse:refresh(.T.)
    SetAppFocus(dc:oaBrowse:oXbp)
  ENDIF
RETURN .T.


METHOD UCT_ucetkumu_karty_SCR:itemMarked()
  local  obro  := ::drgDialog:dialogCtrl:oaBrowse
  local  cfile := if( isnull(obro), 'c_uctosn', lower(obro:cfile))
  local  ky    := upper(c_uctosn->cucet)

  do case
  case(cfile = 'c_uctosn')
    ucetkumu->(ordSetFocus('UCETK_01'),dbSetScope(SCOPE_BOTH,ky), dbGoTop())

    ky := upper(ucetkumu->cucetMd) +strZero(ucetkumu->nrok,4) +strZero(ucetkumu->nobdobi,2)
    ucetpol->(ordSetFocus('UCETPO08'), dbSetScope(SCOPE_BOTH,ky), dbGoTop())

  case(cfile = 'ucetkumu')
    ky := upper(ucetkumu->cucetMd) +strZero(ucetkumu->nrok,4) +strZero(ucetkumu->nobdobi,2)
    ucetpol->(ordSetFocus('UCETPO08'), dbSetScope(SCOPE_BOTH,ky), dbGoTop())

  endcase
Return self


method uct_ucetkumu_karty_SCR:drgDialogEnd()
  ucetkumu->(dbClearScope())
return self