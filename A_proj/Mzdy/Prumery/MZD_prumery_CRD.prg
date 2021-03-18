#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"

#include "..\Asystem++\Asystem++.ch"
*
*****************************************************************
CLASS MZD_prumery_CRD FROM drgUsrClass
EXPORTED:

  method  Init, drgDialogInit, drgDialogStart
  method  postvalidate
  method  Destroy
  method  onSave

  method  mzd_prumery_cmp, mzd_pracKalendar_in

  inline method comboItemSelected(drgComboBox,mp2,o)
    local  value := drgComboBox:Value
    local  name  := drgComboBox:Name

    if drgComboBox:ovar:itemChanged()
      do case
      case Upper( "msvPrumW->nalgCelOdm") = name   ;   msvPrumW->nalgCelOdm := value
      case Upper( "msvPrumW->npocMesPr")  = name   ;   msvPrumW->npocMesPr  := value
      case Upper( "msvPrumW->lrucVypPru") = name   ;   msvPrumW->lrucVypPru := value
      case Upper( "msvPrumW->nStavZprac") = name   ;   msvPrumW->nStavZprac := value
      case Upper( "msvPrumW->nAlgPraPru") = name   ;   msvPrumW->nAlgPraPru := value
      endcase


      PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,drgComboBox:oxbp)
    endif
  return .t.


  inline access assign method den_KC_ppsum() var den_KC_ppsum
    return if( ::nalgDnu_PR < 4, msVPrumW->nHodPrumPP, msVPrumW->nKC_PPSUM )

  inline access assign method den_KC_odmcis() var den_KC_odmcis
    return if( ::nalgDnu_PR < 4, 0                   , msVPrumw->nKC_ODMcis )

  inline access assign method den_DNY_ppsum() var den_DNY_ppsum
    return if( ::nalgDnu_PR < 4, pru_nPrcDobaHz()    , msVPrumw->nDNY_ppsum )

HIDDEN:
  VAR   msg, dm, dc, df, ab
  var   rok, obdobi
  VAR   nalgDnu_PR, lnewRec

ENDCLASS

*
*****************************************************************
METHOD MZD_prumery_CRD:init(parent)
  local  table
  local  cky       := strZero( uctOBDOBI:MZD:NROK,4) +strZero( uctOBDOBI:MZD:NOBDOBI,2)
  local  algDnu_PR := SysConfig( "Mzdy:cAlgDNU_PR")

  ::drgUsrClass:init(parent)

  ::rok    := uctOBDOBI:MZD:NROK
  ::obdobi := uctOBDOBI:MZD:NOBDOBI

  drgDBMS:open('msvprum' )

  drgDBMS:open('druhyMzd')
  druhyMzd->( adsSetOrder('DRUHYMZD04') )

  table := ::drgDialog:parent:dbName

  do case
  case Upper(table) = 'MSPRC_MO'
    cky += strZero( msprc_mo->nosCisPrac,5) +strZero( msprc_mo->nporPraVzt,3)
    msvprum->( dbSeek( cky,,'PRUMV_03'))

  case Upper(table) = 'MSPRC_MOW'
    msvprum->( dbSeek( Upper(msprc_mo->cRoObCpPPv),,'PRUMV_06'))
  otherwise
  endcase

  INcSTATIC( .f., strZero(::rok, 4) +strZero(::obdobi, 2), 'msprc_mo')

  ::nalgDnu_PR := Val( Token( algDnu_PR, ",", 1))
  ::lnewRec    := ( msvPrum->(eof()) )

*  ::lnewRec    := (parent:cargo = drgEVENT_APPEND .and. msvPrum ->(eof()))

  drgDBMS:open('msvprumw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  IF ::lnewRec
    mh_copyFld( 'msPrc_mo', 'msvprumw', .t. )
    msvPrumW->lrucVypPru := .t.
    msvPrumW->nStavZprac :=  9
    msvPrumW->nmsprc_mo  := isNull( msprc_mo->sid, 0)
  ELSE
    mh_COPYFLD('msvprum', 'msvprumw', .t., .t.)
  ENDIF
RETURN self


method MZD_prumery_CRD:drgDialogInit(drgDialog)
  drgDialog:dialog:drawingArea:bitmap  := 1019
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
RETURN self


method MZD_prumery_CRD:drgDialogStart(drgDialog)
  LOCAL  x, cfield
  LOCAL  members := drgDialog:oForm:aMembers, oColumn
  *
  local  acolors  := MIS_COLORS
  local  pa_groups, nin

  * NEWs *
  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager
  ::dc     := drgDialog:dialogCtrl              // dataCtrl
  ::df     := drgDialog:oForm                   // dialogForm
  ::ab     := drgDialog:oActionBar:members      // actionBar

/*
  for x := 1 to LEN(members) step 1
    if members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
        pa_groups := ListAsArray(members[x]:groups)
        nin       := ascan(pa_groups,'SETFONT')

        members[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            members[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
      endif

    elseif members[x]:ClassName() = 'drgText'
      members[x]:oXbp:setColorFG(GRA_CLR_BLUE)

    endif
  next
*/
return self



method MZD_prumery_CRD:postValidate(drgVar, lis_formValidate)
  LOCAL  name := Lower(drgVar:name)
  local  file := drgParse(name,'-')
  local  item := drgParseSecond( name, '>' )
  local value := drgVar:get(), changed := drgVAR:changed()
  *
  local  lOK  := .T., pa, xval
  local  cobdtm
  local  nkc_PPsum, nkc_odmcis, nhod_PPsum, nhodPrumPP, nhodPrumNA
  local                         ndny_PPsum, ndenPrumPP
  *
  local  nkc_NMsum, nkd_NMsum , nkdo_NMsum, anpruNem

  default lis_formValidate to .f.

  ** PP
  *  hodinový prùmìr
  nkc_PPsum  := ::dm:get( 'msvPrumW->nkc_PPsum' )
  nkc_odmcis := ::dm:get( 'msvPrumW->nkc_odmcis')
  nhod_PPsum := ::dm:get( 'msvPrumW->nhod_PPsum')
  nhodPrumPP := ::dm:get( 'msvPrumW->nhodPrumPP')
  nhodPrumNA := ::dm:get( 'msvPrumW->nhodPrumNA')


  if msvPrumW->nStavZprac = 3
    cobdTm := StrZero(msvPrumW->nrokobd,6)
    fVYPprumer( ,.t.,,cobdTm,,'msvPrumw')
//    fVYPprumer( lNewGen, .t., lEXT, cOBDnz, nTYP, 'msvPrum', typZpr )
  endif

  if msvPrumW->nStavZprac <> 9  //            .not. msvPrumW->lrucVypPru
    nhodPrumPP := mh_roundNumb( (nkc_PPsum +nkc_odmcis)/nhod_PPsum, pru_aAlgHOD()[2] )
    ::dm:set( 'msvPrumW->nhodPrumPP', nhodPrumPP )
  endif

  *  denní prùmìr
  ndny_PPsum := ::dm:get( 'msvPrumW->ndny_PPsum' )
  ndenPrumPP := VypDENpru( nhodPrumPP, 0, ndny_PPsum, nkc_PPsum, nkc_odmcis)

  ::dm:set( 'msvPrumW->ndenPrumPP', ndenPrumPP )

  ** NM
  *  nemocenské pojištìní
  nkc_NMsum  := ::dm:get( 'msvPrumW->nkc_NMsum' )
  nkd_NMsum  := ::dm:get( 'msvPrumW->nkd_NMsum' )
  nkdo_NMsum := ::dm:get( 'msvPrumW->nkdo_NMsum')

  anpruNem   := F_VypPrumNem( nkc_NMsum, nkd_NMsum, nkdo_NMsum, pru_nACTrok() )

  ::dm:set( 'msvPrumW->ndenVZhruN', anpruNem[1] )
  ::dm:set( 'msvPrumW->ndenVZciKN', anpruNem[5] )
  ::dm:set( 'msvPrumW->nsazDenNiN', anpruNem[3] )
  ::dm:set( 'msvPrumW->nsazDenVkN', anpruNem[6] )
  ::dm:set( 'msvPrumW->nsazDenVyN', anpruNem[4] )
return lOk


method mzd_prumery_crd:onSave(lisCheck,lisAppend)
  local anNem

  if ::lnewRec .or. msvPrumW->nStavZprac = 9   // msvPrumW->lrucVypPru

    if msvPrumW->nStavZprac = 9 .and. ( msvPrumW->nHodPrumPP > 0 .OR. msvPrumW->nHodPrumNA > 0)
      if SysConfig( "Mzdy:lNezPrumNA")
        anNem := F_VypPrumNem( msvPrumW->nHodPrumNA, 0, 0, msvPrumW->nrok, .t.)
      else
        anNem := F_VypPrumNem( msvPrumW->nHodPrumPP, 0, 0, msvPrumW->nrok, .t.)
      endif

      msvPrumW->nDenVZhruH := anNem[1]
      msvPrumW->nDenVZcisH := anNem[2]
      msvPrumW->nDenVZcikH := anNem[5]

      msvPrumW->nSazDenH_1 := anNem[8]
      msvPrumW->nSazDenH_2 := anNem[3]
    endif

    ::dm:save()

    if ::lnewRec
      mh_copyFld( 'msvPrumW', 'msvPrum', .t. )

    else
      if msvPrum->( sx_Rlock())
        mh_copyFld( 'msvPrumW', 'msvPrum' )
      endif
    endif

    msvPrum->( dbcommit(), dbunlock() )
  else
    if msvPrum->( sx_Rlock())
      msvPrum->nalgCelOdm := msvPrumw->nalgCelOdm
      msvPrum->npocMesPr  := msvPrumw->npocMesPr
      msvPrum->( dbcommit(), dbunlock() )
    endif
  endif

  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
return .t.


*
**  metoda pro volání pracovního kalendáøe
**  MZD
method MZD_prumery_CRD:mzd_prackalendar_in()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'MZD_prackal_in' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self


method MZD_prumery_crd:mzd_prumery_cmp()
  local  cOBDnz := strZero( ::rok, 4) +strZero( ::obdobi, 2)

  fVYPprumer( .t.,,, cOBDnz,, 'msvPrumW' )

  ::dm:refresh()
return self



METHOD MZD_prumery_CRD:destroy()
// ::drgUsrClass:destroy()

//   msvprum->(DbCloseArea())
//   msvprumw->(DbCloseArea())

RETURN SELF