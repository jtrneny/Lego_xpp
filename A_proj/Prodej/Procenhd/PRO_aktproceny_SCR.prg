#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "dbstruct.ch'
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"
//
#include "..\FINANCE\FIN_finance.ch"


#define m_files  { 'c_sklady' , 'c_dph'   , ;
                   'firmy'                , ;
                   'cenzboz'  , 'cenprodc', 'procenho' }


*
** CLASS for PRO_aktproceny_SCR **********************************************
CLASS PRO_aktproceny_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  *
  method  init, drgDialogStart, drgDialogEnd
  method  postValidate, sys_tiskform_crd

  * info
  var      kDatumu

  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1016
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
    return self

  *
  **
  inline access assign method typSlevy() var typSlevy
    return ::get_typSlevy()

  inline access assign method procento() var procento
    return ::get_procSlevy()

  inline access assign method nCeJPrZBZ() var nCeJPrZBZ                         // záklCenaBDane
    return cenProdc->ncenapZbo

  inline access assign method nCeJPrKBZ() var nCeJPrKBZ                         // koncCenaBDane
    local procento := ::get_procSlevy()
    return cenprodc->ncenaPzbo -(cenprodc->ncenaPzbo * procento/100 )

  inline access assign method nCeJPrZDZ() var nCeJPrZDZ                         // záklCenaSDaní
    return cenProdc->ncenapZbo +(cenProdc->ncenapZbo * c_dph->nprocDph) /100

  inline access assign method nCeJPrKDZ() var nCeJPrKDZ                         // koncCenaSDaní
    local nCeJPrKBZ := ::nCeJPrKBZ
    return nCeJPrKBZ +( nCeJPrKBZ * c_dph->nprocDph) /100

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case(nevent = drgEVENT_PRINT)
      ::sys_tiskform_crd()
      return .t.

    case nEvent =  drgEVENT_DELETE
      return .t.
    endcase
  return .f.

hidden:
  var     cisFirmy, cisSklad
  var     oDbro, ocol_procento
  var     oBit_map
  method  create_tmpData

  inline method get_typSlevy()
    local ok       := .f., typSlevy := 0
    local cisFirmy := strZero( firmy ->ncisfirmy,5)
    local cisSklad := upper(cenZboz->ccisSklad), sklPol := upper(cenZboz->csklPol)
    local zboziKat := strZero( cenZboz->nzboziKat,4)
    *
    local cky_1  := '00001' +cisFirmy +cisSklad +sklPol
    local cky_2  := '00001' +'00000'  +cisSklad +sklPol
    local cky_3  := '00001' +cisFirmy +zboziKat
    local cky_4  := '00001' +'00000'  +zboziKat

    do case
    case proCenho->( dbseek( cKy_1,, 'PROCENHO04' ))  ;  typSlevy := 537
    case proCenho->( dbseek( cKy_2,, 'PROCENHO04' ))  ;  typSlevy := 538
    case proCenho->( dbseek( cKy_3,, 'PROCENHO11' ))  ;  typSlevy := 539
    case proCenho->( dbseek( cKy_4,, 'PROCENHO11' ))  ;  typSlevy := 540
    endcase
    return typSlevy


  inline method get_procSlevy()
    local ok       := .f., procento := 0
    local cisFirmy := strZero( firmy ->ncisfirmy,5)
    local cisSklad := upper(cenZboz->ccisSklad), sklPol := upper(cenZboz->csklPol)
    local zboziKat := strZero( cenZboz->nzboziKat,4)
    *
    local cky_1  := '00001' +cisFirmy +cisSklad +sklPol
    local cky_2  := '00001' +'00000'  +cisSklad +sklPol
    local cky_3  := '00001' +cisFirmy +zboziKat
    local cky_4  := '00001' +'00000'  +zboziKat

    do case
    case ( ok := proCenho->( dbseek( cKy_1,, 'PROCENHO04' )))
    case ( ok := proCenho->( dbseek( cKy_2,, 'PROCENHO04' )))
    case ( ok := proCenho->( dbseek( cKy_3,, 'PROCENHO11' )))
    case ( ok := proCenho->( dbseek( cKy_4,, 'PROCENHO11' )))
    endcase

    procento := if( ok, procento := procenho->nprocento, 0)
    return procento
ENDCLASS


method PRO_aktproceny_SCR:init(parent)
  local pa_initParam, ncisFirmy
  *
  local m_filtr

  ::drgUsrClass:init(parent)
  *
  * základní soubory
  ::openfiles(m_files)

  m_filtr := "ntypProCen = 1 .and. empty(dplatnyOd)"
  procenho->(ads_setAof(m_filtr),dbgoTop())


  cenZboz->( dbsetRelation( 'cenProdc', { || upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol) }, ;
                                            'upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)' , ;
                                            'CENPROD1'                                             ))
  cenZboz->( dbsetRelation( 'C_DPH'   , { || cenZboz->nklicDPH },'cenZboz->nklicDPH'))

  ::kDatumu := ctod('  .  .    ')
  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2

    ncisFirmy := val( pa_initParam[2])
    firmy->( dbseek( ncisFirmy,,'FIRMY1'))
  endif
return self


method PRO_aktproceny_SCR:drgDialogStart(drgDialog)
  local  x

  ::msg   := drgDialog:oMessageBar             // messageBar
  ::oDbro := drgDialog:dialogCtrl:oBrowse[1]

  for  x := 1 to ::oDbro:oxbp:colCount step 1
    ocol := ::oDbro:oxbp:getColumn(x)

    do case
    case 'M->procento' $ ocol:frmColum
      ::ocol_procento := ocol:dataArea
    endcase
  next
return self


method PRO_aktproceny_SCR:postValidate(drgVar)
  local  dm     := ::drgDialog:dataManager
  local  name   := lower( drgVAR:name )
  lOCAL  value  := drgVar:get()
  local  ok     := .T., changed := drgVAR:changed()
  *
  local  filtr, m_filtr

  do case
  case ( 'kdatumu' $ name )
    dm:set( 'M->kDatumu', value)
    ::kDatumu := value

    if changed
      do case
      case( empty( value))
        m_filtr := "ntypProCen = 1 .and. empty(dplatnyOd)"
      otherWise
        filtr   := "ntypProcen = 1 .and. " + ;
                   "empty(dplatnyOd) .or. (dplatnyOd <= ctod('%%') .and. dplatnyDo >= ctod('%%'))"
        m_filtr := format( filtr, { value, value } )
      endcase

      procenho->(ads_setAof(m_filtr),dbgoTop())

      cenZboz->(dbgotop())
      ::oDbro:oxbp:refreshAll()

      PostAppEvent(xbeBRW_ItemMarked,,,::oDbro:oxbp)
      SetAppFocus(::oDbro:oxbp)
    endif
  endcase
return .t.


method PRO_aktproceny_SCR:drgDialogEnd(drgDialog)
return

*
** zpracování požadavku a spuštìní dialogu sys_tiskform_crd
method PRO_aktproceny_SCR:sys_tiskform_crd()
  local  oDialog, nExit
  local  arSelect     := ::oDbro:arSelect
  local  is_selAllRec := ::oDbro:is_selAllRec
  *
  local  i, aBitMaps  := { 0, 0, {nil,nil,nil,nil} }, nPHASe := MIS_WORM_PHASE1, oThread
  local     xbp_therm := ::msg:msgStatus

  drgDBMS:open('AktProCenW' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  *
  ** nachystáme si èervíka v samostatném vláknì
  for i := 1 to 4 step 1
    aBitMaps[3,i] := XbpBitmap():new():create()
    aBitMaps[3,i]:load( ,nPHASe )
    aBitMaps[3,i]:TransparentClr := aBitMaps[3,i]:GetDefaultBGColor()
    nPHASe++
  next

  oThread := Thread():new()
  oThread:setInterval( 8 )
  oThread:start( "PRO_aktproceny_scr_animate", xbp_therm, aBitMaps)

  if len(arSelect) <> 0
    for x := 1 to len(arSelect) step 1
      cenZboz->( dbgoto( arselect[x]))
      ::create_tmpData()
    next
  else
    cenZboz->(dbgoTop())
    do while .not. cenZboz->(eof())
      ::create_tmpData()
      cenZboz->(dbskip())
    enddo
  endif

  * vrátíme to
  oThread:setInterval( NIL )
  oThread:synchronize( 0 )
  oThread := nil

  xbp_therm:setCaption('')
  *
  ** nabídneme formuláø pro tisk
  AktProCenW->(dbcommit(), dbgoTop())

  ::oDBro:cFile        := 'AktProCenW'
  ::oDBro:is_selAllRec := .t.
  ::oDBro:arSelect     := {}

  oDialog := drgDialog():new('sys_tiskform_crd',self:drgDialog)
  oDialog:create(,self:drgDialog:dialog,.F.)

  * vrátíme nastavení na pùvodní BRO
  ::oDBro:arSelect     := arSelect
  ::oDBro:is_selAllRec := is_selAllRec
  ::oDBro:cFile        := 'cenZboz'

  oDialog:destroy(.T.)
  oDialog := NIL

  cenZboz->(dbgotop())
  ::oDbro:oxbp:refreshAll()

  PostAppEvent(xbeBRW_ItemMarked,,,::oDbro:oxbp)
  SetAppFocus(::oDbro:oxbp)
return self


method PRO_aktproceny_SCR:create_tmpData()
  local  nprocento := ::get_procSlevy()
  local  ncenaPzbo := cenprodc->ncenaPzbo

  c_dph->(dbseek(cenZboz->nklicDph,,'C_DPH1'))

  *                                               ;
  AktProCenW->(dbappend())
  AktProCenW->ncisFirmy   := firmy->ncisFirmy
  AktProCenW->ccisSklad   := cenZboz->ccisSklad
  AktProCenW->csklPol     := cenZboz->csklPol
  AktProCenW->nzboziKat   := cenZboz->nzboziKat
  AktProCenW->cnazZbo     := cenZboz->cnazZbo
  AktProCenW->czkratJedn  := cenZboz->czkratJedn
  AktProCenW->nprocDph    := c_dph->nprocDph

  AktProCenW->nprocento   := nprocento
  AktProCenW->ncenaPZbo   := ncenaPzbo
  AktProCenW->nCeJPrZBZ   := ncenaPzbo                                          // záklCenaBDane
  AktProCenW->nCeJPrKBZ   := ncenaPzbo -(ncenaPzbo * nprocento/100 )            // koncCenaBDane
  AktProCenW->nCeJPrZDZ   := ncenapZbo +(ncenapZbo * c_dph->nprocDph) /100      // záklCenaSDaní
                                                                                // koncCenaSDaní
  AktProCenW->nCeJPrKDZ   := AktProCenW->nCeJPrKBZ +(AktProCenW->nCeJPrKBZ * c_dph->nprocDph) /100                         // koncCenaSDaní
return .t.


static function is_datumOk(datum)
  local  ok :=  empty(procenho->dplatnyOD) .or. ;
                (procenho->dplatnyOD <= datum .and. procenho->dplatnyDO >= datum)
return ok


static function is_datumEmty()
  local  ok :=  empty(procenho->dplatnyOD)
return ok


procedure PRO_aktproceny_scr_animate(xbp_therm,aBitMaps)
  local  aRect, oPS, nXD, nYD

  xbp_therm:setCaption('')

  aRect   := xbp_therm:currentSize()
  oPS     := xbp_therm:lockPS()

  nXD     := abitMaps[2]
  nYD     := 0

  aBitMaps[1] ++
  if aBitMaps[1] > len(aBitMaps[3])
    aBitMaps[1] := 1
  endif

  aBitMaps[ 3, aBitMaps[1] ]:draw( oPS, {nXD,nYD} )
  xbp_therm:unlockPS( oPS )

  if abitMaps[2] +10 > aRect[1]
    abitMaps[2] := 0
  else
    abitMaps[2] := abitMaps[2] +10
  endif
return

**
*