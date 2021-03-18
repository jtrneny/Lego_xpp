#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\SKLADY\SKL_Sklady.ch"


CLASS SKL_prepklicdph_IN FROM drgUsrClass
EXPORTED:
  METHOD  Init, getForm, EventHandled, drgDialogStart, drgDialogEnd
  method  upravKey

  var     nkey_1o, nkey_2o, nkey_1, nkey_2
*  , itemMarked
*  METHOD  VyrPol_Copy, KusOp_Copy, KusTree, VyrPOL_Oprava

  * CENZBOZ ceníková položka / sestava
*  inline access assign method cenPol() var cenPol
*    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

*  inline access assign method isSest() var isSest
*    local  retVal := 0, cky := space(30) +upper(cenzboz->csklPol)

*    if cenzboz->ctypSklPol = 'S '
*      retVal := if( kusov->(dbSeek(cky,,'KUSOV1')), MIS_BOOKOPEN, MIS_BOOK)
*    endif
*    return retVal

  * VYRPOL podle popisu má být vždy záznam z VYRPOL v CENZBOZ - ale není to pravda
*  inline access assign method isin_cenZboz() var isin_cenZboz
*    local  cky := upper(vyrpol->ccisSklad) +upper(vyrpol->csklPol)
*    return if( cenZboz->( dbSeek( cky,, 'CENIK03')), MIS_ICON_OK, 0 )

HIDDEN:
  VAR     dc, dm, bro_Vyr
*  var     nkey_1, nkey_2
  var     in_file, obro, popState, drgPush, parent

ENDCLASS


METHOD SKL_prepklicdph_IN:init(parent)
  local  odrg := parent:parent:lastXbpInFocus:cargo
  *
  local  items, filter, cf

  ::drgUsrClass:init(parent)

  drgDBMS:open('CenZBOZ' )
*  drgDBMS:open('C_SKLADY')
  drgDBMS:open('C_DPH')
*  CENZBOZ->( DbSetRelation( 'C_DPH', {||CENZBOZ->nKlicDPH },'CENZBOZ->nKlicDPH' ))
*  drgDBMS:open('C_KATZBO')
*  CENZBOZ->( DbSetRelation( 'C_KATZBO', {||CENZBOZ->nZboziKat },'CENZBOZ->nZboziKat' ))
  *
  items      := Lower(drgParseSecond(odrg:name,'>'))
  ::in_file  := 'cenzboz'
  ::popState := 1
  ::parent   := parent:parent:udcp
  ::nkey_1o  := 0
  ::nkey_2o  := 0

  cf := "nprocdph = %%"

  filter := format( cf, { SysConfig('Finance:nHodnDph1')} )
  C_DPH ->( ads_setAof( filter), dbGoTop())

  if C_DPH ->( Ads_GetRecordCount()) > 0
    ::nkey_1 := C_DPH ->nKlicDPH
  endif

  filter := format( cf, { SysConfig('Finance:nHodnDph2')} )
  C_DPH ->( ads_setAof( filter), dbGoTop())

  if C_DPH ->( Ads_GetRecordCount()) > 0
    ::nkey_2 := C_DPH ->nKlicDPH
  endif

RETURN self


METHOD SKL_prepklicdph_IN:getForm()
  local  oDrg, drgFC, headTite

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 60,5.2 DTYPE '10' TITLE 'Zmìna klíèe DPH ' ;
                                              GUILOOK 'IconBar:n,Menu:n,Message:n,Border:n,Action:n'

   DRGSTATIC INTO drgFC FPOS .3,0.2 SIZE 59.4,2.6 STYPE XBPSTATIC_TYPE_RAISEDBOX
     DRGTEXT INTO drgFC CAPTION 'Klíè pro nižší sazbu'      CPOS  3, .1 CLEN 20
     DRGTEXT INTO drgFC CAPTION 'na'                        CPOS  10, 1.1 CLEN 4
     DRGGET  M->nkey_1o INTO drgFC      FPOS 3,1.1  FLEN 5
     DRGGET  M->nkey_1  INTO drgFC      FPOS 13,1.1 FLEN 5

     DRGTEXT INTO drgFC CAPTION 'Klíè pro základní sazbu'   CPOS 27, .1 CLEN  28
     DRGTEXT INTO drgFC CAPTION 'na'                        CPOS 34, 1.1 CLEN 4
     DRGGET M->nkey_2o  INTO drgFC      FPOS 27,1.1 FLEN 5
     DRGGET M->nkey_2   INTO drgFC      FPOS 37,1.1 FLEN 5

*     DRGSTATIC INTO drgFC FPOS .4, .5 SIZE 56.5, .2 STYPE XBPSTATIC_TYPE_RAISEDBOX
*     DRGEND  INTO drgFC
   DRGEND  INTO drgFC


    DRGPUSHBUTTON INTO drgFC CAPTION 'Start ' POS 41.5,3.6 SIZE 18,1 ;
                  EVENT 'upravKey' TIPTEXT 'Úprava klíèe'


  DRGEND INTO drgFC
RETURN drgFC


METHOD SKL_prepklicdph_IN:drgDialogStart(drgDialog)
  local members  := drgDialog:oForm:aMembers, x
  *
  local pa       := { GraMakeRGBColor({ 78,154,125}), ;
                      GraMakeRGBColor({157,206,188})  }


  cf := "nprocdph = %%"

  filter := format( cf, { SysConfig('Finance:nHodnDph1')} )
  C_DPH ->(ads_setAof( filter))

  if C_DPH ->( Ads_GetRecordCount()) > 0
    ::nkey_1 := C_DPH ->nKlicDPH
  endif

  filter := format( cf, { SysConfig('Finance:nHodnDph2')} )
  C_DPH ->(ads_setAof( filter))

  if C_DPH ->( Ads_GetRecordCount()) > 0
    ::nkey_2 := C_DPH ->nKlicDPH
  endif

  *
  ::dc  := drgDialog:dialogCtrl
  ::dm  := drgDialog:dataManager
  *
  for x := 1 TO LEN(members) step 1
    if     members[x]:ClassName() = 'drgPushButton'
      if( ischaracter(members[x]:event), ::drgPush := members[x], nil)
    elseif members[x]:ClassName() = 'drgDBrowse'
      ::obro := members[x]
    endif
  next

  if isObject( ::drgPush )
    ::drgPush:oXbp:setFont(drgPP:getFont(5))
    ::drgPush:oxbp:SetGradientColors( pa )
  endif

RETURN


METHOD SKL_prepklicdph_IN:drgDialogEnd(drgDialog)
RETURN self

*method SKL_prepklicdph_:itemMarked()
*  local  cky := upper(vyrpol->ccisSklad) +upper(vyrpol->csklPol)
*
*  ok := cenZboz->( dbSeek( cky,, 'CENIK03'))
*return self


method SKL_prepklicdph_IN:eventHandled(nEvent, mp1, mp2, oXbp)

  do case
  case nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
*    if ::in_file = 'cenzboz'
*      PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
*      return .t.

*    else
    *     vyrpol
    * 1 - vyrpol musí mít vazbu na cenzboz, jinak nejde pøevzít
*      if ::parent:vyr_vyrpol_sel()
*        PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
*        return .t.
*      endif
*    endif

  case nEvent = drgEVENT_APPEND
*    if ::in_file = 'cenzboz'
*      DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
*      ::obro:oXbp:refreshAll()

*    else
*      DRGDIALOG FORM 'VYR_VYRPOL_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
*      ::obro:oXbp:refreshAll()
*    endif

  otherwise

    return .f.
  endcase
return .f.


METHOD SKL_prepklicdph_IN:upravKey(drgDialog)
  local dm

  dm := drgDialog:dataManager

   cenzboz->( dbGoTop())
   do while .not. cenzboz->( Eof())
     do case
     case cenzboz->nklicdph = dm:get( 'M->nkey_1o' )
       if cenzboz->( dbRlock())
         cenzboz->nklicdph := dm:get( 'M->nkey_1' )
         cenzboz->( dbUnlock())
       endif

     case cenzboz->nklicdph = dm:get( 'M->nkey_2o' )
       if cenzboz->( dbRlock())
         cenzboz->nklicdph := dm:get( 'M->nkey_2' )
         cenzboz->( dbUnlock())
       endif
     endcase

     cenzboz->( dbSkip())
   enddo

   cenzboz->( dbCommit())

RETURN self
