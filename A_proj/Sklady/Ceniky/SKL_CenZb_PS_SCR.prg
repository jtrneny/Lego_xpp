********************************************************************************
*  SKL_CenZb_PS_SCR
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "xbp.ch"

********************************************************************************
* Kontrolní pøepoèet souboru poèáteèních stavù skladových karet
********************************************************************************
CLASS SKL_CenZb_PS_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  VAR     nRok_filter

  METHOD  Init, eventHandled, drgDialogStart, comboItemSelected
  METHOD  PREPOCET_PocStavu
HIDDEN
  VAR     pa_Rok, mainBro
ENDCLASS

********************************************************************************
METHOD SKL_CenZb_PS_SCR:init(parent)
  local  pa_Rok, nrok

  ::drgUsrClass:init(parent)
  drgDBMS:open('CENZBOZ'  )
  drgDBMS:open('PVPITEM'  )
  drgDBMS:open('cenZb_ps')

  drgDBMS:open('ucetSys' )
  ucetSys->( ordSetFocus('UCETSYS2'), dbsetscope(SCOPE_BOTH,'S'), dbgoTop())

  ::pa_Rok := pa_Rok := {}

  do while .not. ucetSys->(eof())
    nrok := ucetSys->nrok
    if ( cenZb_ps->( dbseek( strZero(nrok,4),, 'CENPS02')) .and. ascan( pa_rok, nrok) = 0 )
      aadd(pa_rok, nrok)
    endif
    ucetSys->(dbskip())
  enddo
  ucetSys->(dbclearscope())

  ::nRok_filter := 1   // nastaví se zobrazení "všechny roky"
RETURN self

********************************************************************************
METHOD SKL_CenZb_PS_SCR:drgDialogStart(drgDialog)
  local  pa_it := {}, pa_quick := {{ 'Kompletní poèáteèní stavy karet', ''               }  }

  *
  for x := 1 to len(::pa_Rok) step 1
    aadd( pa_quick, { 'Poèáteèní stavy karet pro rok _ ' +str(::pa_Rok[x]), 'nrok = ' +str(::pa_Rok[x]) } )
  next


  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  CenZb_PS->( DbSetRelation( 'CenZboz'  , {|| Upper(CenZb_PS->cCisSklad) + Upper(CenZb_PS->cSklPol)   } ,;
                                              'Upper(CenZb_PS->cCisSklad) + Upper(CenZb_PS->cSklPol)'   ,;
                                          'CENIK12'    ))
  ::mainBro := drgDialog:odBrowse[1]
  ::mainBro:oxbp:refreshAll()

  drgDialog:set_uct_ucetsys_inlib()

  ::quickFiltrs:init( self, pa_quick, 'stavyKaret' )
RETURN SELF

********************************************************************************
METHOD SKL_CenZb_PS_SCR:comboItemSelected( Combo)
  Local Filter, nRok

  ::nRok_filter := Combo:value
  Do Case
  Case Combo:value = 1               // Všechny roky
    IF( EMPTY(CenZb_ps->(ads_getAof())), NIL, CenZb_ps->(ads_clearAof(),dbGoTop()) )

  otherwise                          // konkrétní rok
    Filter := "nRok = %%"
    nRok   := VAL( RIGHT( ALLTRIM( Combo:values[Combo:value, 2]), 4))
    Filter := Format( Filter, { nRok } )
    CenZb_ps->( mh_SetFilter( Filter))
  EndCase
  *
  ::mainBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::mainBro:oxbp)
  SetAppFocus(::mainBro:oXbp)

RETURN .T.

********************************************************************************
METHOD SKL_CenZb_PS_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
    CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    CASE nEvent = drgEVENT_DELETE
    CASE nEvent = xbeP_Keyboard
      Do Case
        Case mp1 = xbeK_ESC
          PostAppEvent(xbeP_Close,nEvent,,oXbp)
      Otherwise
        RETURN .F.
      EndCase
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .F.

********************************************************************************
METHOD SKL_CenZb_PS_SCR:PREPOCET_PocStavu()

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SKL_CtrlPocStavy' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
RETURN self