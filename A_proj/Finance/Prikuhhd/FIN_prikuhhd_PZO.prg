#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"
#include "dbstruct.ch"
#include "dmlb.ch"
//
#include "..\FINANCE\FIN_finance.ch"


*
** CLASS for FIN_prikuhhd_IN_pzo ***********************************************
**                            P_øíjemce Z_právy O_známení
**
class FIN_prikuhhd_IN_pzo from drgUsrClass
exported:
  method init, drgDialogStart

  var    msg, dm, df
  var    o_ucet, o_nazev, o_bank_Naz

  *
  **
  inline method drgDialogEnd( drgDialog)
    local  pa, isOk := .t.

    pa   := ::pa_nazev_info
    isOk := .t.
    aeval( pa, { |o| if( empty(o:value), isOk := .f., nil ) })
    ::m_parent:o_nazev_info:oxbp:setCaption( if( isOk, 101, 170))

    pa   := ::pa_ucet_info
    isOk := .t.
    aeval( pa, { |o| if( empty(o:value), isOk := .f., nil ) })
    ::m_parent:o_ucet_info:oxbp:setCaption( if( isOk, 101, 170))

    pa   := ::pa_bank_Naz_info
    isOk := .t.
    aeval( pa, { |o| if( empty(o:value), isOk := .f., nil ) })
    ::m_parent:o_bank_Naz_info:oxbp:setCaption( if( isOk, 101, 170))

    ::o_ucet:set( ::dm:get('prikuhItw->cucet'        ))
    ::o_nazev:set( ::dm:get('prikuhItw->cnazev'      ))
    ::o_bank_Naz:set( ::dm:get('prikuhItw->cBank_naz'))
    return self

hidden:
  var    m_parent, state
  var    pa_nazev_info, pa_ucet_info, pa_bank_Naz_info
endClass



method FIN_prikuhhd_IN_pzo:init(parent)

  ::drgUsrClass:init(parent)

  ::m_parent := parent:parent:udcp
  ::state    := 0

  if isMemberVar( ::m_parent, 'state' )
    ::state      := ::m_parent:state

    ::o_nazev    := ::m_parent:dm:has('prikuhItw->cnazev'   )
    ::o_ucet     := ::m_parent:dm:has('prikuhItw->cucet'    )
    ::o_bank_Naz := ::m_parent:dm:has('prikuhItw->cBank_naz')
  endif
retur self


method FIN_prikuhhd_IN_pzo:drgDialogStart(drgDialog)

  ::msg := drgDialog:oMessageBar
  ::dm  := drgDialog:dataManager
  ::df  := drgDialog:oForm

  * povinné údaje pro kotrolu zahranièního pøíkazu
  ::pa_nazev_info   := { ::o_nazev                         , ;
                         ::dm:has( 'prikUhitw->culice'    ), ;
                         ::dm:has( 'prikUhitW->cpsc'      ), ;
                         ::dm:has( 'prikUhitW->csidlo'    ), ;
                         ::dm:has( 'prikUhitW->czkratStat')  }

  ::pa_ucet_info     := { ::o_ucet                         , ;
                          ::dm:has( 'prikUhitW->ciban')      }

  ::pa_bank_Naz_info := { ::dm:has( 'prikUhitW->cbic')     , ;
                          ::o_bank_naz                     , ;
                          ::dm:has( 'prikUhitW->cbank_Uli'), ;
                          ::dm:has( 'prikUhitW->cbank_Psc'), ;
                          ::dm:has( 'prikUhitW->cbank_Sid'), ;
                          ::dm:has( 'prikUhitW->cbank_Sta')  }

  if ::state = 2
    ::dm:refreshAndSetEmpty('prikuhitw')

    * pøíjemce
    ::dm:set( 'prikUhItW->cNazev'    , ::o_nazev:value     )
    ::dm:set( 'prikUhItW->cULICE'    , fakPrihd->cULICE    )
    ::dm:set( 'prikUhItW->CPSC'      , fakPrihd->CPSC      )
    ::dm:set( 'prikUhItW->CSIDLO'    , fakPrihd->CSIDLO    )
    ::dm:set( 'prikUhItW->CZKRATSTAT', fakPrihd->CZKRATSTAT)
    ::dm:set( 'prikUhItW->cDIC'      , fakPrihd->cDIC      )

    * Ve prospìch úètu
    firmyUc->( dbseek( upper(::o_ucet:value),,'FIRMYUC2'  ))

    ::dm:set( 'prikUhItW->cUCET'     , ::o_ucet:value      )
    ::dm:set( 'prikUhItW->cIBAN'     , firmyUc->cIBAN      )

    * Banka pøíjemce
    ::dm:set( 'prikUhItW->cBIC'      , firmyUc->cBIC       )
    ::dm:set( 'prikUhItW->cBANK_NAZ' , ::o_bank_naz:value  )
    ::dm:set( 'prikUhItW->CBANK_ULI' , firmyUc->CBANK_ULI  )
    ::dm:set( 'prikUhItW->CBANK_PSC' , firmyUc->CBANK_PSC  )
    ::dm:set( 'prikUhItW->CBANK_SID' , firmyUc->CBANK_SID  )
    ::dm:set( 'prikUhItW->cBANK_STA' , firmyUc->cBANK_STA  )

  else
    ::dm:set( 'prikUhItW->cUCET'     , ::o_ucet:value      )
    ::dm:set( 'prikUhItW->cNazev'    , ::o_nazev:value     )
    ::dm:set( 'prikUhItW->cBANK_NAZ' , ::o_bank_naz:value  )

  endif

  isEditGet( { 'prikUhItW->cUCET' }, drgDialog, .f. )
return self