#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
****** CLASS for PRO_stroje_IN **********************************************
CLASS HIM_pozemky_IN FROM drgUsrClass
EXPORTED:

  METHOD  drgDialogStart
  METHOD  preValidate
  METHOD  postValidate
  METHOD  postDelete
  method  ebro_beforeAppend

  method  fir_firmy_sel
  method  osb_osoby_sel

  method  copyPOZEMEK
//  method  rozpPOZEMEK

  VAR     newRec, drgGet

  inline method itemMarked()
    MAJ->( dbseek( pozemky->ninvCis,,'MAJ02'))
  return self



  inline method init(parent)
    local  olastDrg

    ::drgUsrClass:init(parent)

    *
    * tady se musí dát pozor, pokud to pùjde z parenta HIM_MAJ_SCR - BUTTON
    * ctypPohybu, ddatNAV_od, ddatNAV_do, czkratka je nastaveno noEdit
    *
    *
    ::isparent_mainScr := .f.

    if isObject( parent:parent )
      if lower(parent:parent:formName) = 'him_maj_scr'
        ::isparent_mainScr := .t.
      endif
    endif


    drgDBMS:open('firmy')
    drgDBMS:open('osoby')
    drgDBMS:open('maj')
    drgDBMS:open('maj',,,,,'majx')

    if isObject(parent:parent)
      if isObject( parent:parent:oform )
        if parent:parent:oform:olastDrg:className() = 'drgGet'
          ::drgGet := parent:parent:oform:olastDrg
        endif
      endif
    endif

    ::newRec := .F.
  return self

  inline method drgDialogInit(drgDialog)
    local  aPos, aSize
    local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

    if IsObject(::drgGet)
      **  XbpDialog:titleBar := .F.
      drgDialog:dialog:drawingArea:bitmap  := 1020
      drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

      if ::drgGet:oxbp:parent:className() = 'XbpCellGroup'
        aPos := mh_GetAbsPosDlg(::drgGet:oXbp:parent,drgDialog:dataAreaSize)
        aPos[1] := 50
        return self
//        ( apos[1] := 50, apos[2] += 24 )
      else
        aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
      endif
      drgDialog:usrPos := {aPos[1],aPos[2]}
    endif
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case  nEvent = drgEVENT_APPEND2
      if( oXbp:ClassName() <> 'XbpCheckBox', ::copyPOZEMEK(.T.), NIL)
//       if( oXbp:ClassName() <> 'XbpCheckBox', ::him_pozemky_modi_CRD(.T.), NIL)
      return .T.

    case  nEvent = drgEVENT_DELETE
      ::postDelete()
      return .T.

    case ( nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT ) .and. isObject(::drgGet)
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)

    otherwise
      return .f.
    endcase
  return .t.

HIDDEN:
  VAR     nFile, cFile, dm, msg
  var     isparent_mainScr

  var     cisFirmy, cisOsoby

ENDCLASS


METHOD him_pozemky_in:drgDialogStart(drgDialog)

  if( isObject(::drgGet), drgDialog:odbrowse[1]:enabled_enter := .f., nil )

  ::dm        := ::drgDialog:dataManager           // dataMananager
  ::msg       := drgDialog:oMessageBar             // messageBar

  ::cisFirmy  := ::dm:get('pozemky->ncisfirmy' , .f.)
  ::cisOsoby  := ::dm:get('pozemky->ncisosoby' , .f.)

  isEditGET( { 'maj->ntypMaj'   , ;
               'maj->ctypPohybu', ;
               'maj->ninvCis'   , ;
               'maj->cNazev'    , ;
               'maj->ddatPor'   , ;
               'maj->ddatZar'   , ;
               'maj->cobdZar'     }, drgDialog, .f. )

RETURN self


METHOD him_pozemky_in:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  ok    := .t.

  do case
  case( name = 'pozemky->ninvcis' )
    if ::isparent_mainScr
      drgVar:odrg:isEdit := .f.
      ::dm:set( 'pozemky->ninvcis', maj->ninvCis)
    endif
  endcase
RETURN ok


method him_pozemky_in:postValidate(drgVar)
  local  value := drgVar:get()
  local  n     := 0
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  do case
  case name = 'pozemky->npozemek'

  case name = 'pozemky->ndruhpozem'
    if value <> 0  .and. ::newRec
      ::dm:set( 'pozemky->cnazpozem', c_pozem->cNazDruPoz)
    endif

  case name = 'pozemky->ninvcis'
    if value <> 0
      if .not. majx->( dbSeek( value,,'MAJ02'))
        drgMsgBox(drgNLS:msg('Zadané inventární èíslo neexistuje !!!'), XBPMB_CRITICAL )
      endif
    endif

  case name = 'pozemky->cparccis'
    if ( n := at('/',value)) > 0 .and. ::newRec
      ::dm:set( 'pozemky->nparccis1', Val(SubStr(value,1, n-1)))
      ::dm:set( 'pozemky->nparccis2', Val(SubStr(value,n+1)))
    endif

  case name = 'pozemky->nparccis1'
    if value = 0
      drgMsgBox(drgNLS:msg('Èíslo parcely musí být zadáno !!!'), XBPMB_CRITICAL )
    endif
  endcase
return ok


method him_pozemky_in:ebro_beforeAppend(o_ebro)

  ::dm:set( 'pozemky->npozemek', newIDpozem())
  ::newRec := .t.
return .t.

/*

method OSB_zdrstav_IN:postValidate(drgVar)
  local  value := drgVar:get(), lOk := .T.


  do case
  case lower(drgVar:name) = 'zdrstavy->nporzdrsta'
    if value = 0
      drgNLS:msg('Poøadí nesmí být nulové !!!')
//    lOk := .f.
//   ::dm:set( name, 'DOH' )
//    stavterm->ctask := 'DOH'
    endif

  case lower(drgVar:name) = 'zdrstavy->czkrzdrsta'
    ::dm:set( 'zdrstavy->cnazzdrsta', c_zdrsta->cnazzdrsta)

  case lower(drgVar:name) = 'zdrstavy->ntypduchod'
    ::dm:set( 'zdrstavy->cnazduchod', c_duchod->cnazduchod)


  endcase

*  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
*    if drgVar:changed()
*    endif

**    ::verifyActions(.T.)
*  endif
RETURN lOk


method OSB_zdrstav_IN:ebro_beforeAppend(o_ebro)
  local  nporadi := 1

//  zdrstavy->nporzdrsta := 1
  ::dm:set( "ZDRSTAVY->NPORZDRSTA", nporadi)


/*
  local m_file   := lower(o_ebro:cfile), s_filter, filter
  local m_filter := "NTYPPROCEN = %% .and. NCISPROCEN = %%"

  do case
  case (m_file = ::hd_file )
    filter := format(m_filter, { 0, 0 })

    (::it_file)->(ads_setAof(filter),dbgotop())
    ::oabro[2]:oxbp:refreshAll()

    ::panGroup := Str(if(procenhd->ntypProcen <= 4, 1, procenhd->ntypProCen), 1)

    filter := format(filter +" .and. NPOLPROCEN = %%", {(::it_file)->npolprocen})
    (::ho_file)->(ads_setAof(filter),dbgotop())
    ::oabro[3]:oxbp:refreshAll()

  case (m_file = ::it_file )
     filter   := format(m_filter +" .and. NPOLPROCEN = %%", { 0, 0, 0 } )

     (::ho_file)->(ads_setAof(filter),dbgotop())
     ::oabro[3]:oxbp:refreshAll()

  endcase
return .t.
*/


/*


method OSB_zdrstav_IN:ebro_afterAppend(o_ebro)
  local  cfile   := lower( o_EBro:cfile)


  ::dm:set( 'zdrstavy->ncisosoby' , osoby->ncisosoby)
*  ::dm:set( 'zdrstavy->czkrterm'  , c_termin->czkrterm)

/*

  do case
  case cfile = 'msmzdyhdw'

*    keyMatr := msMzdyhdW->( Ads_getLastAutoinc()) +1
    keyMatr := msMzdyhdW->( Ads_GetRecordCount()) +1

    ::dm:set( 'msMzdyhdw->laktivni', .t.)
    ::dm:set( 'msMzdyhdw->nkeyMatr', keyMatr)

    msMzdyitW->( dbsetScope( SCOPE_BOTH, strZero( keyMatr,4)), dbgoTop())
    ::oBRO_msMzdyitw:oxbp:refreshAll()

  case cfile = 'msmzdyitw'
    ::dm:set( 'msMzdyitw->laktivni', .t.)

  endcase


return .t.

*/


method him_pozemky_in:postDelete()
  local  nsel, nodel := .f.

  nsel := ConfirmBox( ,'Požadujete zrušit pozemek->' +allTrim(pozemky->cparccis) +'_', ;
                       'Zrušení pozemku ...'                , ;
                        XBPMB_YESNO                                 , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, ;
                        XBPMB_DEFBUTTON2                              )

  if nsel = XBPMB_RET_YES
    if( pozemky->(dbRlock()), (pozemky->(dbDelete()), nodel := .f.), nodel := .t.)
  endif

  if nodel
    ConfirmBox( ,'Pozemek_' +allTrim(pozemky->cparccis) +'_' +' nelze zrušit ...', ;
                 'Zrušení pozemku ...' , ;
                 XBPMB_CANCEL                  , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  pozemky->(dbUnlock())
//  ::drgDialog:dialogCtrl:refreshPostDel()
  ::drgDialog:odbrowse[1]:oxbp:refreshAll()

return .not. nodel


method him_pozemky_in:copyPOZEMEK( parent)
  local  filtr, newID
  local  typ, typInfo

  if drgIsYESNO(drgNLS:msg('Vytvoøit kopii pozemku - ' +alltrim(pozemky ->cParcCis)))
    newID := newIDpozem()
    drgDBMS:open('pozemky',,,,,'pozemkyb')
    pozemkyb->( dbGoTo( pozemky->(recno())))
    mh_COPYFLD( 'pozemkyb', 'pozemky', .T.)

    pozemky->npozemek   := newID
    pozemky->nparccis1  := 0
    pozemky->nparccis2  := 0
    pozemky->npodil     := 0
    pozemky->cpodil     := ''
    pozemky->nvymera_m2 := 0
    pozemky->nvymera_ha := 0
    pozemky->npodvym_m2 := 0
    pozemky->npodvym_ha := 0
    pozemky->ncenapoz   := 0
    pozemky->ndannabpoz := 0
    pozemky->ncenasdana := 0
    pozemky->ncenazapod := 0
    pozemky->nstavpozem := 0

//    pozemkyb->(ads_clearaof(), dbCloseArea())
    drgNLS:msg('Kopie pozemku byla vytvoøena')
//    pozemky->( dbGoTo( pozemky->(recno())))
    ::drgDialog:odbrowse[1]:oxbp:refreshAll()
  endif

return self

/*
method him_pozemky_in:rozpPOZEMEK()
  local oDialog

//  ::drgdialog:odbrowse[1]:arselect

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'him_pozemky_rozp_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()

RETURN self
*/

method him_pozemky_in:fir_firmy_sel(drgDialog)
  local  oDialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    oDialog := drgDialog():new('FIR_FIRMY_SEL', ::dm:drgDialog)
    oDialog:cargo_usr := ::cisFirmy:value
    oDialog:create(,,.T.)

    nExit := oDialog:exitState
    oDialog:destroy(.T.)
    oDialog := NIL
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::cisFirmy:set(firmy->ncisfirmy)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method him_pozemky_in:osb_osoby_sel(drgDialog)
  local  oDialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  ok := osoby->(dbseek(::cisOsoby:value,,'OSOBY1'))

  if isobject(drgdialog) .or. .not. ok
    oDialog := drgDialog():new('OSB_OSOBY_SEL', ::dm:drgDialog)
    oDialog:cargo_usr := ::cisOsoby:value
    oDialog:create(,,.T.)

    nExit := oDialog:exitState
    oDialog:destroy(.T.)
    oDialog := NIL
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::cisOsoby:set(osoby->ncisosoby)
  endif
return (nexit != drgEVENT_QUIT) .or. ok





Function newIDpozem()
  local newID

  drgDBMS:open('pozemky',,,,,'pozemkyq' )

  pozemkyq->( OrdSetFocus('POZEMKY01'), dbGoBotTom())
  newID := pozemkyq->npozemek + 1

return( newID)