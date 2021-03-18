#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


CLASS NAK_dodlstPhd_cen_SEL FROM drgUsrClass
EXPORTED:
  METHOD  Init, getForm, EventHandled, drgDialogStart, drgDialogEnd, itemMarked
  method  createContext, fromContext
  METHOD  KusOp_Copy

  * CENZBOZ ceníková položka / sestava
  inline access assign method cenPol() var cenPol
    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method isSest() var isSest
    local  retVal := 0, cky := space(30) +upper(cenzboz->csklPol)

    if cenzboz->ctypSklPol = 'S '
      retVal := if( kusov->(dbSeek(cky,,'KUSOV1')), MIS_BOOKOPEN, MIS_BOOK)
    endif
    return retVal

 * OBJVYSIT
  inline access assign method stav_objvysit() var stav_objvysit
    local retVal := 0

    do case
    case(objvysit->nmnozpldod = 0                    )  ;  retVal :=   0
    case(objvysit->nmnozpldod >= objvysit->nmnozobdod)  ;  retVal := 302
    case(objvysit->nmnozpldod <  objvysit->nmnozobdod)  ;  retVal := 303
    endcase
    return retVal


  * VYRPOL podle popisu má být vždy záznam z VYRPOL v CENZBOZ - ale není to pravda
  inline access assign method isin_cenZboz() var isin_cenZboz
    local  cky := upper(vyrpol->ccisSklad) +upper(vyrpol->csklPol)
    return if( cenZboz->( dbSeek( cky,, 'CENIK03')), MIS_ICON_OK, 0 )

HIDDEN:
  VAR     dc, dm, bro_Vyr
  var     in_file, obro, popState, drgPush, parent

ENDCLASS


METHOD NAK_dodlstPhd_cen_SEL:init(parent)
  local  odrg := parent:parent:lastXbpInFocus:cargo
  *
  local  items

  ::drgUsrClass:init(parent)

  drgDBMS:open('VYRPOL'  )
  drgDBMS:open('VYRPOLw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('C_SKLADY')
  drgDBMS:open('C_DPH')
  CENZBOZ->( DbSetRelation( 'C_DPH', {||CENZBOZ->nKlicDPH },'CENZBOZ->nKlicDPH' ))
  drgDBMS:open('C_KATZBO')
  CENZBOZ->( DbSetRelation( 'C_KATZBO', {||CENZBOZ->nZboziKat },'CENZBOZ->nZboziKat' ))
  drgDBMS:open('C_UCTSKP')
  CENZBOZ->( DbSetRelation( 'C_UCTSKP', {||CENZBOZ->nUcetSkup } ,'CENZBOZ->nUcetSkup' ))
  *
  items      := Lower(drgParseSecond(odrg:name,'>'))
  ::in_file  := if( items = 'csklpol', 'cenzboz', 'vyrpol')
  ::popState := 1
  ::parent   := parent:parent:udcp
RETURN self


METHOD NAK_dodlstPhd_cen_SEL:getForm()
  local  oDrg, drgFC, headTite

  headTitle := if(::in_file = 'cenzboz'  , 'skladových položek', 'vyrábìných položek')

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 110,15.2 DTYPE '10' TITLE 'Seznam ' +headTitle +' _ výbìr' ;
                                              GUILOOK 'IconBar:n,Menu:n,Message:n,Border:y'

  do case
  case ::in_file = 'cenzboz'
  * Pøevzít z Ceníku zboží         ->cenzboz
    DRGACTION INTO drgFC CAPTION 'info ~Ceník'      EVENT 'SKL_CENZBOZ_INFO' ;
                                                    TIPTEXT 'Informaèní karta skladové položky'

    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 110,14 FILE 'CENZBOZ'      ;
      FIELDS 'M->cenPol:c:2.6::2,'                                 + ;
             'M->isSest:s:2.6::2,'                                 + ;
             'cCISSKLAD:èisSklad,'                                 + ;
             'nZBOZIKAT:katZbo,'                                   + ;
             'cSKLPOL:sklPoložka,'                                 + ;
             'cNAZZBO:název zboží:33,'                             + ;
             'cJKPOV:jkpov,'                                       + ;
             'nCENAPZBO:prodCena,'                                 + ;
             'nMNOZDZBO:množKDisp'                                   ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'

 case ::in_file = 'objitem'
 * Pøevzít z Objednávek vystavených  ->objitem

    DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 110,14 FILE 'OBJVYSIT'     ;
      FIELDS 'M->stav_objvysit::2.6::2,'                           + ; 
             'ccisObj:èísloObjednávky,'                            + ; 
             'nintCount:polObj,'                                   + ;
             'cCISSKLAD:èisSklad,'                                 + ;
             'cSKLPOL:sklPoložka,'                                 + ;
             'cNAZEV:název zboží:33,'                              + ;
             'nmnozObDod:množObj,'                                 + ;          
             'nmnozPlDod:množPln,'                                 + ;
             'ncenNaoDodo:cenaNák,'                                + ;
             'nzboziKat:katZbož,'                                  + ;
             'ndoklad:èísloDkl,'                                   + ;
             'ccisZakaz:èísloZakázky,'                             + ;
             'ccisZakazI:výrÈíslo'                                   ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y' ITEMMARKED 'itemMarked'

    DRGPUSHBUTTON INTO drgFC CAPTION 'Kompletní seznam ' POS 65.5,0.05 SIZE 38,1 ;
                  EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'

    DRGPUSHBUTTON INTO drgFC POS 103.5,.05 SIZE 3,1.1 ATYPE 1 ;
                  ICON1 MIS_ICON_CHECK ICON2 gMIS_ICON_CHECK  ;
                  EVENT 'mark_doklad' TIPTEXT 'Oznaè vstupní doklad ...'

    DRGPUSHBUTTON INTO drgFC POS 106.5,.05 SIZE 3,1.1 ATYPE 1    ;
                  ICON1 MIS_ICON_SAVE_AS ICON2 gMIS_ICON_SAVE_AS ;
                  EVENT 'save_marked' TIPTEXT 'Pøevzít položky do dokladu ...'

  otherWise
  * Pøevzít z Výrobních zakázek    ->vyrzakit

    DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 110,13 FILE 'VYRZAKIT'     ;
      FIELDS 'cCISZAKAZ:èísloZakázky:20,'                          + ;
             'cCISZAKAZI:výrÈíslo:20,'                             + ;
             'cNAZEVZAK1:název zakázky:39,'                        + ;
             'CNAZFIRMY::20,'                                      + ;
             'cSKP:skp,'                                           + ;
             'cZKRATMENZ:mìna,'                                    + ;
             'nCENAMJ:cena/mj,'                                    + ;
             'nmnozPlano:množPlan,'                                + ;
             'nmnozVyrob:množVyr,'                                 + ;
             'nRozm_del:délka,'                                    + ;
             'nRozm_sir:šíøka,'                                    + ;
             'nRozm_vys:výška,'                                    + ;
             'cRozm_MJ:mj'                                           ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'

    DRGPUSHBUTTON INTO drgFC CAPTION 'Kompletní seznam ' POS 65.5,0.05 SIZE 38,1 ;
                  EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'

    DRGPUSHBUTTON INTO drgFC POS 103.5,.05 SIZE 0,0 ATYPE 1 ;
                  ICON1 MIS_ICON_CHECK ICON2 gMIS_ICON_CHECK  ;
                  EVENT 'mark_doklad' TIPTEXT 'Oznaè vstupní doklad ...'

    DRGPUSHBUTTON INTO drgFC POS 106.5,.05 SIZE 0,0 ATYPE 1    ;
                  ICON1 MIS_ICON_SAVE_AS ICON2 gMIS_ICON_SAVE_AS ;
                  EVENT 'save_marked' TIPTEXT 'Pøevzít položky do dokladu ...'
  endcase

  DRGEND INTO drgFC
RETURN drgFC


METHOD NAK_dodlstPhd_cen_SEL:drgDialogStart(drgDialog)
  local members  := drgDialog:oForm:aMembers, x
  *
  local pa       := { GraMakeRGBColor({ 78,154,125}), ;
                      GraMakeRGBColor({157,206,188})  }

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


METHOD NAK_dodlstPhd_cen_SEL:drgDialogEnd(drgDialog)
RETURN self

method NAK_dodlstPhd_cen_SEL:itemMarked()
  local  cky := upper(vyrpol->ccisSklad) +upper(vyrpol->csklPol)

  ok := cenZboz->( dbSeek( cky,, 'CENIK03'))
return self


method NAK_dodlstPhd_cen_SEL:eventHandled(nEvent, mp1, mp2, oXbp)

  do case
  case nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    if ::in_file = 'cenzboz'
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
      return .t.

    else
    *     vyrpol
    * 1 - vyrpol musí mít vazbu na cenzboz, jinak nejde pøevzít
      if ::parent:vyr_vyrpol_sel()
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
        return .t.
      endif
    endif

  case nEvent = drgEVENT_APPEND
    if ::in_file = 'cenzboz'
      DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
      ::obro:oXbp:refreshAll()

    else
      DRGDIALOG FORM 'VYR_VYRPOL_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
      ::obro:oXbp:refreshAll()
    endif

  otherwise

    return .f.
  endcase
return .f.


* Kopie
********************************************************************************
METHOD NAK_dodlstPhd_cen_SEL:KusOp_Copy()
  Local  cZdroj_VyrPol := STR( VyrPOL->( RecNO()) )
  Local  cCil_VyrPol   := STR( VyrPOL->( RecNO()) )

  DRGDIALOG FORM 'VYR_VYRPOL_copy' CARGO cZdroj_VyrPol + ',' + cCil_VyrPol ;
                                   PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:odBrowse[1]:oxbp:refreshAll()
  /*
  DRGDIALOG FORM 'VYR_VYRPOL_copy' CARGO ::cZdroj_VyrPol + ',' + ::cCil_VyrPol ;
                                   PARENT ::drgDialog MODAL DESTROY
  ::mainBro:oxbp:refreshAll()
  */
RETURN self


method NAK_dodlstPhd_cen_SEL:createContext()
  LOCAL cSubMenu, oPopup, aPos, aSize, x, pa, nIn
  *
  local popUp := 'kompletní seznam, všechny nezakázkové, všechny nabídkové, nabídkové k dané firmì'

  pA       := ListAsArray(popup)
  cSubMenu := drgNLS:msg(popUp)
  oPopup   := XbpMenu():new( ::drgDialog:dialog ):create()

  for x := 1 TO LEN(pA) step 1
    oPopup:addItem( {drgParse(@cSubMenu), de_BrowseContext(self,x,pA[x]) } )
  next

  oPopup:disableItem(::popState)

  aPos    := ::drgPush:oXbp:currentPos()
  oPopup:popup(::drgDialog:dialog, aPos)
return self


method NAK_dodlstPhd_cen_SEL:fromContext(aOrder, nMENU)
  local  cf   := "cCisZakaz = '%%'" , filter
  local  pa   :={ nil, EMPTY_VYRPOL, 'NAV', 'NAV-' + StrZero( NABVYSHDw->nCisFirmy, 5)}
  local  obro := ::drgDialog:odbrowse[1]

  ::popState := aOrder
  ::drgPush:oxbp:setCaption(nMENU)

  do case
  case(aOrder = 1)  ;  vyrpol->( ads_clearAof())
  otherWise
    filter := format( cf, {pa[::popState]} )
    vyrpol->(ads_setAof( filter))
  endcase

  vyrpol->(dbgotop())
  obro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,obro:oxbp)
  SetAppFocus( obro:oXbp)
return self

