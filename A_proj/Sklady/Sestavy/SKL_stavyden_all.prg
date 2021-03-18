#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "class.ch"
*
#include "..\Asystem++\Asystem++.ch"


// podklad pro inventuru ke dni
*************** SKL_cenikstav_kdnw ***********************************************
CLASS SKL_stavyden_allw FROM drgUsrClass
exported:
  var     task
  method  init, itemMarked, drgDialogStart, drgDialogEnd
  method  comboBoxInit, comboItemSelected
  method  zpracuj_podklady
  method  createKumul

  * bro col for ucetsys
  ** 1
  inline access assign method setfor_sw     var setfor_sw

    if AScan( ::pa_obdZpr, ucetsys->cobdobi ) <> 0
      return 6001
    endif
    return 0

  **
  inline method post_bro_colourCode()
    return ::set_obdZpr()

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      return .f.

    case ( nEvent = drgEVENT_APPEND .or. ;
           nEvent = drgEVENT_EDIT   .or. ;
           nEvent = drgEVENT_DELETE .or. ;
           nEvent = drgEVENT_SAVE        )
      return .t.

    endcase
  return .f.

hidden:
* sys
  var     msg, dm, dc, df, ab, oabro, xbp_therm, cparm
* datové
  var     culoha, nrok, nobdobi, pa_obdZpr, radek
  var     oneSklPol
  var     nObdPoc, nObdKon
  var     dDatePOC, dDateKON
  var     dDatKum
  var     nMnozPoc, nCenaPoc,nMnozKon,nCenaKon
  var     nMnozPrij,nCenaPrij,nMnozVydej,nCenaVydej
  var     m_oDBro

  method  set_obdZpr

   * filtr
  inline method setFilter()
    local m_filter := "nrok = %%", filter, x

    if( .not. empty(kalendar->(ads_getaof())), kalendar->(ads_clearaof(),dbgotop()), nil)

    filter := format(m_filter,{::nrok})
    kalendar ->(ads_setaof(filter))
    kalendar ->( dbSeek( dtos( Date()),,'KALENDAR01'))

    ::oabro[1]:oxbp:forceStable()
    ::oabro[1]:oxbp:refreshAll()
    ::dm:refresh()

    PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
    SetAppFocus(::oabro[1]:oXbp)
    return self

  * je aktivni BROw ?
  inline method inBrow()
    return (SetAppFocus():className() = 'XbpBrowse')
ENDCLASS



method SKL_stavyden_allw:init(parent)
  local  task := 'skl'

  ::drgUsrClass:init(parent)
  ::cParm    := AllTrim( drgParseSecond(::drgDialog:initParam))
  ::cParm    := Left( ::cParm,1)
  ::radek    := 0

  drgDBMS:open('c_task' )
  drgDBMS:open('ucetsys')
  drgDBMS:open('ucetsys',,,,,'ucetsys_w')
  drgDBMS:open('kalendar')
  drgDBMS:open('kalendar',,,,,'kalendarw')
  *
  drgDBMS:open('firmy'   )
  drgDBMS:open('c_staty' )

  drgDBMS:open('cenzboz' )
  drgDBMS:open('cenzb_ps' )
  drgDBMS:open('odbzboz' )

  drgDBMS:open('pvpitem',,,,.t.,'pvpit_1' )
  PVPIT_1->( AdsSetOrder( 'PVPITEM27'))
  *
  ::oneSklPOL := .f.
//  ::cUser     := SysConfig( "System:cUserABB")
//  ::dDate     := Date()
//  ::cTime     := Time()
  *

  * holt jedeme znovu
  if select('pvpkumdenw') <> 0
    pvpkumdenw->(dbclosearea())
    FErase( drgINI:dir_USERfitm +'pvpkumdenw.adt')
    FErase( drgINI:dir_USERfitm +'pvpkumdenw.adi')
  endif

  drgDBMS:open('pvpkumdenw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  ::task      := task
  ::nobdobi   := 0
  ::pa_obdZpr := {}


  ::m_oDBro   := parent:parent:parent:odBrowse[1]

  if isobject(uctOBDOBI:&task)
    ::culoha  := uctOBDOBI:&task:culoha
    ::nrok    := uctOBDOBI:&task:nrok
    ::nobdobi := uctOBDOBI:&task:nobdobi
  *
    ::nobdpoc := 1
    ::nobdkon := uctObdobi:&task:nobdobi
  endif

  c_task->(dbseek(upper(task),,'C_TASK01'))
  if(empty(::culoha), ::culoha := c_task->culoha, nil)
  if(empty(::nrok)  , ::nrok   := Year(date())  , nil)

  ::dDatePOC := CTOD('01.01.' + STR(::nROK,4))
  ::dDateKON := mh_LastODate( ::nROK, ::nObdKON )

return self



method SKL_stavyden_allw:drgDialogStart(drgDialog)

  ::msg        := drgDialog:oMessageBar             // messageBar
  ::dm         := drgDialog:dataManager             // dataMabanager
  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::df         := drgDialog:oForm                   // form
  ::ab         := drgDialog:oActionBar:members      // actionBar
  ::oabro      := drgDialog:dialogCtrl:obrowse
  *
  ::xbp_therm  := drgDialog:oMessageBar:msgStatus

  ::setFilter()
return self


method SKL_stavyden_allw:drgDialogEnd(drgDialog)
  ::msg   := ;
  ::dm    := ;
  ::dc    := ;
  ::df    := ;
  ::oabro := NIL

  kalendar->(ads_clearaof())
return self


method SKL_stavyden_allw:comboBoxInit(drgComboBox)
  local  acombo_val := {}

  if ('NROK'   $ drgComboBox:name)
    drgComboBox:value := ::nrok
    ucetsys_w ->(ads_clearaof()  , ;
                 dbgotop()       , ;
                 dbeval( { ||      ;
                 if( ascan(acombo_val,{|X| x[1] == ucetsys_w->nrok}) = 0 , ;
                     aadd(acombo_val,{ucetsys_w->nrok,'ROK _ ' +strzero(ucetsys_w->nrok,4)}), nil ) }))
    if empty(acombo_val)
      aadd(acombo_val, {::nrok-1, 'ROK _ ' +strzero(::nrok-1,4)})
      aadd(acombo_val, {::nrok  , 'ROK _ ' +strzero(::nrok  ,4)})
    endif

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[2] < aY[2] } )
    AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
  endif
return self


method SKL_stavyden_allw:comboItemSelected(mp1, mp2, o)
  ::pa_obdZpr := {}
  ::nrok      := mp1:value
  ::setFilter()
return .t.


method SKL_stavyden_allw:itemMarked(arowco,unil,oxbp)
  local  ky, rest := ''
  *
  local  x, ev, om, ok := ( len( ::pa_obdZpr) <> 0 )

/*
  BEGIN SEQUENCE
    for x := 1 to len(::ab) step 1
      ev := Lower(::ab[x]:event)
      om := ::ab[x]:parent:aMenu

      if ev $ 'zpracuj_podklady'
        ::ab[x]:oXbp:setColorFG(If(ok, GraMakeRGBColor({0,0,0}), GraMakeRGBColor({128,128,128})))
        ::ab[x]:oXbp:configure()
        if(ok, ::ab[x]:enable(), ::ab[x]:disable())

  BREAK
      endif
    next
  END SEQUENCE
*/

return self


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method SKL_stavyden_allw:set_obdZpr()
  local npos, pa := ::pa_obdZpr

  if( npos := AScan( pa, ucetsys->cobdobi )) = 0
    AAdd( pa, ucetsys->cobdobi )
  else
    ARemove( pa, npos )
  endif

  ::oabro[1]:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
return .t.


method SKL_stavyden_allw:zpracuj_podklady()
  local  pa  := ::pa_obdZpr
  local  cc, x, pa_napocet, npos
  local  cf  := ".not. empty(cdic) .and. ", cfilter
  local  cf_pvp, cfilter_pvp
  *
  local  cky, ncisRadku := 1, ncisListu := 1
  local  nSize     := ::xbp_therm:currentSize()[1]
  local  nHight    := ::xbp_therm:currentSize()[2]
  local  celkem    := 0
  local  m_File, arSelect
  *

  ::dDatKum  := CTOD( StrZero(kalendar->nDen,2)+'.'+StrZero( kalendar->nMesic, 2)+'.'+StrZero(::nROK,4) )

  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro stav skladových karet ke dni: ' + dtoc(::dDatKum) , nSize, nHight)

//  cfilter := format("ncisfirmy = %% .and. ( csklpol = '%%' .and. nrok = %% .and. ddatpvp <= '%%'",{odbzboz->ccissklad,odbzboz->csklpol,::nrok,::dDatKum})
//  odbzboz->( Ads_SetAOF( cfilter), dbGotop())

  m_File    := lower(::m_oDBro:cFile)

  if ::m_oDBro:is_selAllRec
    (m_File)->( dbgoTop())
    do while .not. (m_File)->(eof())
      ::createKumul()
      (m_File)->( dbSkip())
    enddo
  else
    arSelect  := aclone(::m_oDBro:arSelect)
    if( len(arSelect) = 0, aadd( arSelect, (m_File)->( recNo()) ), nil )
    for x := 1 to len( arSelect) step 1
      ::createKumul()
    next
  endif

  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro stav skladových karet ke dni: ' + dtoc(::dDatKum) +' - dokonèeno', nSize, nHight)
  Sleep(150)
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return .t.



********************************************************************************
method SKL_stavyden_allw:createKumul()
  Local cKey
  Local cKarta, cScope


  cKey := Upper(odbzboz->cCisSklad) + Upper(odbzboz->cSklPol)
  *
  IF( ::oneSklPOL, PVPKUMDENw->( dbZAP()), NIL )
  *
  ::nMnozPoc  := ::nCenaPoc  := ::nMnozKon   := ::nCenaKon   := 0
  ::nMnozPrij := ::nCenaPrij := ::nMnozVydej := ::nCenaVydej := 0

  IF CenZb_ps->( dbSEEK( cKEY + StrZero(::nRok, 4),,'CENPS01'))
    ::nMnozPoc := CenZb_ps->nMnozPoc
    ::nCenaPoc := CenZb_ps->nCenaPoc
  ENDIF

  CenZboz->( dbSEEK( cKEY,,'CENIK03'))

  * kumulace pohybù
  ::nMnozPrij  := 0
  ::nCenaPrij  := 0
  ::nMnozVydej := 0
  ::nCenaVydej := 0

  cfilter := format("ccissklad = '%%' .and. csklpol = '%%' .and. nrok = %% .and. ddatpvp <= '%%'",{odbzboz->ccissklad,odbzboz->csklpol,::nrok,::dDatKum})
  PVPIT_1->( Ads_SetAOF( cfilter), dbGotop())
      *
  Do While !PVPIT_1->( Eof())
    cKarta := Right( alltrim( PVPIT_1->cTypDoklad), 3)
    IF cKarta <> '400'
      ::nMnozPrij  += If( PVPIT_1->nTypPoh =  1 , PVPIT_1->nMnozPrDod, 0 )
      ::nMnozVydej += If( PVPIT_1->nTypPoh = -1 , PVPIT_1->nMnozPrDod, 0 )
    ENDIF
    ::nCenaPrij  += If( PVPIT_1->nTypPoh =  1 , PVPIT_1->nCenaCelk , 0 )
    ::nCenaVydej += If( PVPIT_1->nTypPoh = -1 , PVPIT_1->nCenaCelk , 0 )
    PVPIT_1->( dbSkip())
  EndDo

  * zápis do KUMULU
  mh_CopyFLD( 'CenZboz', 'PVPKUMDENw', .T.)

  PVPKUMDENw->nRok       := ::nROK
  PVPKUMDENw->nObdobi    := kalendar->nMesic
  PVPKUMDENw->cObdPoh    := StrZero( kalendar->nMesic, 2) + '/' + RIGHT( STR(::nROK), 2)
  PVPKUMDENw->dDatKUM    := ::dDatKum
  *
  PVPKUMDENw->nMnozPoc   := ::nMnozPoc
  PVPKUMDENw->nCenaPoc   := ::nCenaPoc
  PVPKUMDENw->nMnozPrij  := ::nMnozPrij
  PVPKUMDENw->nCenaPrij  := ::nCenaPrij
  PVPKUMDENw->nMnozVydej := ::nMnozVydej
  PVPKUMDENw->nCenaVydej := ::nCenaVydej
  PVPKUMDENw->nMnozKon   := ::nMnozPoc + ::nMnozPrij - ::nMnozVydej
  PVPKUMDENw->nCenaKon   := ::nCenaPoc + ::nCenaPrij - ::nCenaVydej

  PVPKUMDENw->nOdbZboz    := odbzboz->sid
  *
  *
  ::nMnozPoc := PVPKUMDENw->nMnozKon
  ::nCenaPoc := PVPKUMDENw->nCenaKon
  *
  PVPIT_1->( ads_clearAof())

RETURN SELF