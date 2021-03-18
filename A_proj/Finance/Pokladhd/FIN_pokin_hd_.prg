#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"


*
** CLASS for FRM FIN_pokin_hd_SCR *********************************************
**
CLASS FIN_pokin_hd_scr FROM drgUsrClass
EXPORTED:

  inline access assign method nazPokl() var nazPokl
    pokladms->(dbseek(pokin_hd->npokladna,,'POKLADM1'))
    return pokladms->cnazpoklad


  inline method itemMarked()
    local  cky := strZero(pokin_hd->npokladna,3) +dtos(pokin_hd->ddat_inv) +strZero(pokin_hd->ncnt_inv,2)

    pokin_it->( dbsetScope( SCOPE_BOTH,cky),dbgoTop())
  return self


  inline method init(parent)
    ::drgUsrClass:init(parent)

    drgDBMS:open('pokladms')
  return self

  inline method FIN_c_meny_mince(drgDialog)
    local  odialog, nexit

*    local  filter   := format("ndoklad = %%",{fakvyshd->ncislodl})
*    local  oldFocus := fakvysit->(AdsSetOrder())

*    if(select('dodlsthd') = 0, drgDBMS:open('dodlsthd'), nil)
*    dodlsthd->(ads_setAof(filter), dbgotop())

    oDialog := drgDialog():new('FIN_c_meny_mince',drgDialog)
    odialog:create(,,.T.)

*    dodlsthd->(ads_clearAof())
*    fakvysit->(dbclearScope(), AdsSetOrder(oldFocus))

    odialog:destroy()
    odialog := nil
  return

ENDCLASS



**
** CLASS for FIN_pokin_hd_in ***************************************************
CLASS FIN_pokin_hd_in FROM drgUsrClass  //, FIN_finance_IN
exported:
  var     lnewRec, hd_file, it_file

  method  init, postValidate
  method  drgDialogInit, drgDialogStart, drgDialogEnd
  method  fin_pokladms_sel, osb_osoby_sel

  *
  ** pokin_hdW
  inline access assign method nazPoklad() var nazPoklad
    pokladMs_x->( dbseek( pokin_hdW->npokladna,, 'POKLADM1'))
    return pokladMs_x->cnazPoklad

  *
  ** pokin_itW
  inline access assign method L_gate() var L_gate
    return if( pokin_itW->sid = 0, '', '(' )

  inline access assign method multiply() var multiply
    return if( pokin_itW->sid = 0, '', 'X' )

  inline access assign method R_gate() var R_gate
    return if( pokin_itW->sid = 0, '', ')' )

  inline access assign method result() var result
    return if( pokin_itW->sid = 0, '', '=' )

  inline method itemMarked()
*    ::sumColumn()
  return self

  inline method showGroup(istuz_uc)
     pokin_hdW->npokladna  := pokladMs->npokladna
     pokin_hdW->naktStav   := pokladMs->naktStav
     pokin_hdW->czkratMeny := pokladMs->czkratMeny

     ::dm:refresh()
  return self

  inline method ebro_saveEditRow( drgEBrowse )
    ::sumColumn()
  return .t.

  inline method onSave()
    return .t.


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl, msg := ::drgDialog:oMessageBar

    do case
    case(nEvent = xbeBRW_ItemMarked)
      msg:WriteMessage(,0)
      return .f.

    CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_DELETE
      return .t.

   case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT

      if ( lower( ::df:oLastDrg:classname()) $ 'drgebrowse' )
        if .not. ::lnewRec
           drgMsg(drgNLS:msg('Oravovat inventuru pokladny není povoleno, doklad nelze uložit - omlouvám se ...'),,::dm:drgDialog)
           return .t.

        else

          if ::sumcel_mince <> pokin_hdW->naktStav
            fin_info_box( 'Aktuální STAV pokladny nesouhlasí s poètem MINCÍ, ' +CRLF +'doklad nelze uložit ...', XBPMB_CRITICAL )
            return .t.
          else
            if ::postSave()
              PostAppEvent(xbeP_Close, nEvent,,oXbp)
              return .t.
            endif
          endif
        endif
      endif

    CASE nEvent = drgEVENT_FORMDRAWN
      return .T.

    OTHERWISE
      RETURN .F.
    ENDCASE
  return .T.


hidden:
  var     msg, dm, dc, df
  var     otxt_aktStav, otxt_zkratMeny, oget_pokladna, sumcel_mince
  var     oBrow

  inline method pokin_hd_cpy()

    drgDBMS:open('POKIN_HDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('POKIN_ITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

    if ::lnewRec
      pokladMs->( dbgoTop())
      mh_copyFld( 'pokladMs', 'pokin_hdW', .t. )
      ( pokin_hdW->ddat_inv   := date()   , ;
        pokin_hdW->ncnt_inv   := 1        , ;
        pokin_hdW->ccas_inv   := time()   , ;
        pokin_hdW->cjmenoPred := logOsoba   )

    else
      mh_copyFld( 'pokin_hd', 'pokin_hdW', .t. )

      pokin_it->( dbgoTop())
      do while .not. pokin_it->(eof())
        mh_copyFld( 'pokin_it', 'pokin_itW', .t. )

        pokin_it->( dbskip())
      enddo
    endif
  return .t.

  inline method sumColumn()
    local  recNo     := pokin_itW->( recNo())
    local  sumCol
    local  sumcel_mince := 0

    pokin_itW->( dbeval( { || sumcel_mince += pokin_itW->ncel_mince } ), ;
                 dbgoTo( recNo )                                      )

    ::sumcel_mince := sumcel_mince
    sumCol         := ::oBrow:cargo:getColumn_byName( 'pokin_itW->ncel_mince' )

    sumCol:Footing:setCell(1, sumcel_mince )
    sumCol:footing:invalidateRect()
    sumCol:Footing:show()
  return self


  inline method postSave()
    local  hConnect := oSession_data:getConnectionHandle()
    local  lDone    := .t.
    *
    local cf := "npokladna = %% and ddat_inv = '%%'"
    local filter

    filter := format( cf, { pokin_hdW->npokladna, pokin_hdW->ddat_inv })

    pokin_hd_x->( ordsetFocus( 'POKIN_01'), ads_setAof( filter ), dbgoBottom() )

    pokin_hdW->ncnt_inv := pokin_hd_x->ncnt_inv +1

    oSession_data:beginTransaction()

    BEGIN SEQUENCE
      mh_copyFld( 'pokin_hdW', 'pokin_hd', .t. )

      pokin_itW->( dbgoTop())
      do while .not. pokin_itW->( eof())

        pokin_itW->ncnt_inv := pokin_hd->ncnt_inv
        mh_copyFld( 'pokin_itW', 'pokin_it', .t. )
        pokin_itW->( dbskip())
      enddo

      lDone := .t.
      oSession_data:commitTransaction()

    RECOVER USING oError
      lDone := .f.
      oSession_data:rollbackTransaction()

    END SEQUENCE

    pokin_hd->(dbunlock(), dbcommit())
    pokin_it->(dbunlock(), dbcommit())
  return lDone

ENDCLASS


method FIN_pokin_hd_in:init(parent)

   ::drgUsrClass:init(parent)

   drgDBMS:open('pokin_hd',,,,, 'pokin_hd_x')
   drgDBMS:open('pokladMs')
   drgDBMS:open('pokladMs',,,,, 'pokladMs_x')
   drgDBMS:open('c_meny'  )
   drgDBMS:open('c_mince' )

   (::hd_file     := 'pokin_hdW', ::it_file := 'pokin_itW')
   ::lnewRec      := .not. (parent:cargo = drgEVENT_EDIT)
   ::sumcel_mince := 0

   ::pokin_hd_cpy()
return self


method FIN_pokin_hd_in:drgDialogInit(drgDialog)
  drgDialog:dialog:drawingArea:bitmap  := 1019
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
return self


method FIN_pokin_hd_in:drgDialogStart(drgDialog)

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataManager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

  ::oBrow    := ::dc:obrowse[1]:oxbp

  ::sumColumn()

  if ::lnewRec
    PostAppEvent(xbeP_Keyboard,xbeK_F4,,::dm:has('pokin_hdW->npokladna'):odrg:oxbp)
  endif
return self


method FIN_pokin_hd_in:postValidate(drgVar)
  local  value := drgVar:get(), m_file
  local  name  := lower(drgVar:name), file, field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .T., changed := drgVAR:changed()

  do case
  case (name = 'pokin_hdW->cjmenoPrev' )
    pokin_hdW->cjmenoPrev := value

  case (name = 'pokin_itw->npoc_mince' )
    pokin_itw->ncel_mince := pokin_itW->nvalMince * value
    ::dm:set('pokin_itw->ncel_mince', pokin_itW->nvalMince * value)
  endcase
return ok


method FIN_pokin_hd_in:drgDialogEnd(drgDialog)
  (::it_file)->(DbCloseArea())
  (::hd_file)->(DbCloseArea())
return

*
** SELL METHOD *****************************************************************
method FIN_pokin_hd_in:fin_pokladms_sel(drgDialog)
  LOCAL oDialog, nExit
  *
  local drgVar := ::dataManager:get('pokin_hdW->npokladna', .F.)
  local value  := drgVar:get()
  local ok     := (.not. Empty(value) .and. pokladms ->(dbseek(value,,'POKLADM1')))


  if IsObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'FIN_POKLADMS_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                      EXITSTATE nExit CARGO drgVar:odrg

    if nexit = drgEVENT_SELECT
      pokin_itW->( dbzap())

      c_mince->( ordsetFocus('C_MINC1')                             , ;
                 dbsetScope(SCOPE_BOTH, upper(pokladMs->czkratMeny)), ;
                 dbgoTop()                                            )

      do while .not. c_mince->( eof())
        mh_copyFld( 'c_mince', 'pokin_itW', .t. )

        pokin_itW->npokladna := pokin_hdW->npokladna
        pokin_itW->ddat_inv  := pokin_hdW->ddat_inv
        pokin_itW->ncnt_inv  := pokin_hdW->ncnt_inv

        c_mince->( dbskip())
      enddo

      pokin_itW->( dbgoTop())
      ::oBrow:refreshAll()

    endif
  endif
RETURN (nexit = drgEVENT_SELECT .or. ok)


method FIN_pokin_hd_in:osb_osoby_sel(drgDialog)
  local  odialog, nexit,  odrg := drgDialog:lastXbpInFocus:cargo

  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit != drgEVENT_QUIT
    pokin_hdW->cjmenoPrev := osoby->cosoba
    ::dm:set(odrg:name, osoby->cosoba)
  endif
return .t.


