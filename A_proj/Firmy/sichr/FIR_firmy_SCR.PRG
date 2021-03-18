#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'firmy'    , 'firmyfi' , 'firmyuc', 'firmyda', 'firmysk', 'firmyva', 'firmybcd', ;
                   'c_firmysk', 'c_podruc', ;
                   'fakprihd' , 'fakvyshd', 'objhead', 'objvyshd'             }


// RUŠENÍ FIRMY //


*
** CLASS FOR FIR_firmy_SCR *****************************************************
CLASS FIR_firmy_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  METHOD  init, itemMarked, drgDialogStart, drgDialogEnd
  *
  METHOD  fin_fakprihd_scr, fin_fakvyshd_scr
  method  pro_objhead_scr,  pro_nabvyshd_scr, pro_procenhd_in, pro_aktproceny_scr
  method  nak_objvyshd_scr
  *
  METHOD  fir_firmybcd_in, fir_firmy_Ares_scr
  METHOD  Cenik_ODBERATELE

  *
  * firmy aktivni/neaktivni
   inline access assign method is_aktivni() var is_aktivni
     return if( firmy->lAktivni, MIS_ICON_OK, MIS_NO_RUN )
  *
  ** firmyuc
  inline access assign method is_aktivniUc() var is_aktivniUc
    return if( firmyuc->(eof()), 0, if( firmyuc->lAktivni, MIS_ICON_OK, MIS_NO_RUN ))
  *
  * firmySK
  inline access assign method setSkup() var setSkup
    return MIS_ICON_OK

  inline access assign method cnaz_Skup() var cnaz_Skup
     c_firmySk->(dbSeek( upper(firmySK->czkr_Skup)))
     return c_firmySk->cnaz_Skup

  *
  ** firmyVA
  inline access assign method nazev_vaw() var nazev_vaw
    if firmy_vaw->ncisFirmy <> firmyVA->ncisFirVa
      firmy_vaw->(dbseek( firmyVA->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->cnazev

  inline access assign method ico_vaw() var ico_vaw
    if firmy_vaw->ncisFirmy <> firmyVA->ncisFirVa
      firmy_vaw->(dbseek( firmyVA->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->nico

  inline access assign method dic_vaw() var dic_vaw
    if firmy_vaw->ncisFirmy <> firmyVA->ncisFirVa
      firmy_vaw->(dbseek( firmyVA->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->cdic

  inline access assign method psc_vaw() var psc_vaw
    if firmy_vaw->ncisFirmy <> firmyVA->ncisFirVa
      firmy_vaw->(dbseek( firmyVA->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->cpsc

  inline access assign method sidlo_vaw() var sidlo_vaw
    if firmy_vaw->ncisFirmy <> firmyVA->ncisFirVa
      firmy_vaw->(dbseek( firmyVA->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->csidlo

  inline access assign method ulice_vaw() var ulice_vaw
    if firmy_vaw->ncisFirmy <> firmyVA->ncisFirVa
      firmy_vaw->(dbseek( firmyVA->ncisFirVa,, AdsCtag(1) ))
    endif
    return firmy_vaw->culice

HIDDEN:

  inline method openfiles(afiles)
    local  nin,file,ordno

    aeval(afiles, { |x| ;
         if(( nin := at(',',x)) <> 0, (file := substr(x,1,nin-1), ordno := val(substr(x,nin+1))), ;
                                      (file := x                , ordno := nil                )), ;
         drgdbms:open(file)                                                                        , ;
         if(isnull(ordno), nil, (file)->(AdsSetOrder(ordno)))                                     })
  return nil
ENDCLASS


method FIR_firmy_scr:init(parent)
  ::drgUsrClass:init(parent)

  ::openFiles(m_files)

  drgDBMS:open('firmy',,,,,'firmy_vaw')
return self


method FIR_firmy_scr:itemMarked()
  local nky := firmy->ncisFirmy

  firmyDa->(AdsSetOrder('FIRMYDA1' ), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
  firmyFi->(AdsSetOrder('FIRMYFI1' ), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
  firmyUc->(AdsSetOrder('FIRMYUC1' ), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
  firmySk->(AdsSetOrder('FIRMYSK01'), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
  firmyVa->(AdsSetOrder('FIRMYVA01'), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
return self


method FIR_firmy_scr:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam  ', ''          }, ;
  { 'Aktivní   Firmy   ', 'laktivni'  }, ;
  { 'Neaktivní Firmy   ', '!laktivni' }  }

  * najíží filtr jen AKTIVNÍ firmy
***  ::sel_filtrs := { { 'firmy', { 'Aktivní   Firmy   ', 'laktivni' } } }
  ::quickFiltrs:init( self, pa_quick, 'firmy' )
return self

*
** metody pro volání výkonných obrazovek
**  FIN
method fir_firmy_scr:fin_fakprihd_scr(drgDialog)
  local  othread
  local  filter := format("ncisFirmy = %%", {firmy->ncisFirmy})

  oThread := drgDialogThread():new()
  oThread:start( ,'fin_fakprihd_scr,' +filter, drgDialog)
return

method fir_firmy_scr:fin_fakvyshd_scr(drgDialog)
  local  othread
  local  filter := format("ncisFirmy = %%", {firmy->ncisFirmy})

  oThread := drgDialogThread():new()
  oThread:start( ,'fin_fakvyshd_scr,' +filter, drgDialog)
return

** PRO
method fir_firmy_scr:pro_objhead_scr(drgDialog)
  local  othread
  local  filter := format("ncisFirmy = %%", {firmy->ncisFirmy})

  oThread := drgDialogThread():new()
  oThread:start( ,'pro_objhead_scr,' +filter, drgDialog)
return

method fir_firmy_scr:pro_nabvyshd_scr(drgDialog)
  local  othread
  local  filter := format("ncisFirmy = %%", {firmy->ncisFirmy})

  oThread := drgDialogThread():new()
  oThread:start( ,'pro_nabvyshd_scr,' +filter, drgDialog)
return


method fir_firmy_scr:pro_procenhd_in(drgDialog)
  local  othread
  local  filter := format("ncisFirmy = %%", {firmy->ncisFirmy})

  oThread := drgDialogThread():new()
  oThread:start( ,'pro_procenhd_in,' +filter, drgDialog)
return


method fir_firmy_scr:pro_aktproceny_scr(drgDialog)
  local  othread
  local  filter := str( firmy->ncisFirmy)
*  local  filter := format("ncisFirmy = %%", {firmy->ncisFirmy})

  oThread := drgDialogThread():new()
  oThread:start( ,'pro_aktproceny_scr,' +filter, drgDialog)
return


** NAK
method fir_firmy_scr:nak_objvyshd_scr(drgDialog)
  local  othread
  local  filter := format("ncisFirmy = %%", {firmy->ncisFirmy})

  oThread := drgDialogThread():new()
  oThread:start( ,'pro_objvyshd_scr,' +filter, drgDialog)
return
**
*

method fir_firmy_scr:fir_firmybcd_in(drgDialog)
  local  odialog, nexit
  local  filter := format("ncisFirmy = %%", {firmy->ncisFirmy})

  firmybcd->(ads_setAof(filter), dbgotop())

  oDialog := drgDialog():new('fir_firmybcd_in',drgDialog)
  odialog:create(,,.T.)

  firmybcd->(ads_clearAof())

  odialog:destroy()
  odialog := nil
return


method fir_firmy_scr:fir_firmy_Ares_scr(drgDialog)
  local  odialog, nexit
*  local  filter := format("ncisFirmy = %%", {firmy->ncisFirmy})

*  firmybcd->(ads_setAof(filter), dbgotop())

  oDialog := drgDialog():new('fir_firmy_Ares_scr',drgDialog)
  odialog:create(,,.T.)

*  firmybcd->(ads_clearAof())

  odialog:destroy()
  odialog := nil
return


********************************************************************************
METHOD fir_firmy_scr:Cenik_ODBERATELE()

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'FIR_odbzboz_IN' PARENT ::drgDialog MODAL   //DESTROY
  ::drgDialog:popArea()                  // Restore work area

RETURN self


/*
method fin_fakvyshd_scr:fin_dodlsthd(drgDialog)
  local  odialog, nexit
  *
  local  filter   := format("ndoklad = %%",{fakvyshd->ncislodl})
  local  oldFocus := fakvysit->(AdsSetOrder())

  if(select('dodlsthd') = 0, drgDBMS:open('dodlsthd'), nil)
  dodlsthd->(ads_setAof(filter), dbgotop())

  oDialog := drgDialog():new('fin_fakvyshd_dodlsthd',drgDialog)
  odialog:create(,,.T.)

  dodlsthd->(ads_clearAof())
  fakvysit->(dbclearScope(), AdsSetOrder(oldFocus))

  odialog:destroy()
  odialog := nil
return

*/


method fir_firmy_scr:drgDialogEnd(drgDialog)
  firmyDa->(dbclearscope())
  firmyFi->(dbclearscope())
  firmyUc->(dbclearscope())
return


**
** CLASS for FIR_firmyuc_SEL ***************************************************
CLASS FIR_firmyuc_SEL FROM drgUsrClass, quickFiltrs
EXPORTED:
  METHOD  init, drgDialogStart, itemMarked, fir_firmy_scr

  *
  ** firmyucW aktivní/neaktivní úèet
  inline access assign method is_aktivni() var is_aktivni
    return if( firmyuc->lAktivni, MIS_ICON_OK, MIS_NO_RUN )

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EXIT
      ::recordSelected()

    CASE nEvent = drgEVENT_EDIT
      ::recordSelected()

    CASE nEvent = drgEVENT_APPEND
**      ::recordEdit()

    CASE nEvent = drgEVENT_FORMDRAWN
      Return .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

      case(mp1 = xbeK_RETURN)
        ::recordSelected()
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.


  INLINE METHOD recordSelected
**    ::drgDialog:cargo := &( 'CENZBOZ->' + ::selFLD)
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  RETURN SELF


  INLINE METHOD recordEdit
*    ::drgDialog:pushArea()                  // Save work area
*    DRGDIALOG FORM 'FIR_FIMY_SCR_SCR' PARENT ::drgDialog DESTROY MODAL
*    ::drgDialog:popArea()                  // Restore work area
  RETURN self

ENDCLASS


METHOD FIR_firmyuc_SEL:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('FIRMYUC')
  drgDBMS:open('FIRMY'  )
RETURN self


method FIR_firmyuc_SEL:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam    ', 'laktivni = .t. .or. laktivni = .f.' }, ;
  { 'Aktivní   úèty Firem', 'laktivni = .t.'                     }, ;
  { 'Neaktivní úèty Firem', 'laktivni = .f.'                     }  }

  ::quickFiltrs:init( self, pa_quick, 'firmyUc' )
return self



method FIR_firmyuc_sel:itemMarked()

  firmy->(dbseek(firmyuc->ncisfirmy,,'FIRMY1'))
return self


method fir_firmyuc_sel:fir_firmy_scr(drgDialog)
  local oDialog, nExit
  *
  local ctagName := firmyuc->( ordSetFocus())

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'FIR_FIRMY_SCR' PARENT drgDialog MODAL DESTROY EXITSTATE nExit
  ::drgDialog:popArea()

  firmyuc->(AdsSetOrder( ctagName ))
return .t.



*
** CLASS for FIR_firmyico_sel **************************************************
CLASS FIR_firmyico_sel FROM drgUsrClass
EXPORTED:
  method  init

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

    do case
    case nEvent = drgEVENT_EXIT   ;  ::recordSelected()
    case nEvent = drgEVENT_EDIT   ;  ::recordSelected()
    case nEvent = drgEVENT_APPEND
**      ::recordEdit()
    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        return .f.
      endcase

    otherwise
      return .f.
    endcase
  return .t.


  inline method recordSelected()
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self


  inline method recordEdit()
*    ::drgDialog:pushArea()                  // Save work area
*    DRGDIALOG FORM 'FIR_FIMY_SCR_SCR' PARENT ::drgDialog DESTROY MODAL
*    ::drgDialog:popArea()                  // Restore work area
  return self
ENDCLASS


method FIR_firmyico_sel:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('FIRMYUC')
return self