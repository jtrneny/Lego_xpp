#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"


CLASS PRO_nabvyshd_cen_SEL FROM drgUsrClass, quickFiltrs
EXPORTED:
  METHOD  Init, getForm, EventHandled, drgDialogStart, drgDialogEnd, itemMarked
  METHOD  VyrPol_Copy, KusOp_Copy, KusTree, VyrPOL_Oprava
  *
  var     m_udcp
  var     smallBasket_ncenaZakl, smallBasket_nhodnSlev, smallBasket_nprocSlev, smallBasket_nmnozOdes

  * CENZBOZ ceníková položka / sestava
  inline access assign method cenPol() var cenPol
    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method isSest() var isSest
    local  retVal := 0, cky := space(30) +upper(cenzboz->csklPol)

    if cenzboz->ctypSklPol = 'S '
      retVal := if( kusov->(dbSeek(cky,,'KUSOV1')), MIS_BOOKOPEN, MIS_BOOK)
    endif
    return retVal

  * VYRPOL podle popisu má být vždy záznam z VYRPOL v CENZBOZ - ale není to pravda
  inline access assign method isin_cenZboz() var isin_cenZboz
    local  cky := upper(vyrpol->ccisSklad) +upper(vyrpol->csklPol)
    return if( cenZboz->( dbSeek( cky,, 'CENIK03')), MIS_ICON_OK, 0 )

  *
  ** smallBasket
  inline method smallBasket()
    local  state_y
    local  oIcon := XbpIcon():new():create()

    if isObject(::pb_smallBasket)

      ::smallBasket_State := .not. ::smallBasket_State
      state_y := if( ::smallBasket_State, DRG_ICON_APPEND2, gDRG_ICON_APPEND2 )
      oicon:load( NIL, state_y)

      ::pb_smallBasket:oxbp:setImage( oicon )
      ::enable_or_disable_Gets()
      ::set_focus_dBro()
    endif
  return .t.

  inline method post_drgEvent_Refresh()
    local  cfile := lower(::dc:oaBrowse:cfile)

    if ::in_file = 'cenzboz'
      ::sta_activeBro:oxbp:setCaption( if( cfile = 'cenzboz', 337, 338 ) )
    endif
  return self


HIDDEN:
  VAR     dc, dm, df, bro_Vyr, drgVar
  var     in_file, obro, popState, drgPush, parent

  var     hd_file, it_file

  *       cenZboz/nabVysit  nabVysitW
  var     o_dBro        , o_dBro_basketW
  var     o_parent_udcp , o_parent_dm, o_parent_dBro
  var     pb_smallBasket, smallBasket_State, smallBasket_Gets
  var     sta_activeBro     // UP, DOWN

  *
  ** smallBasket
  inline method enable_or_disable_Gets()
    local pa := ::smallBasket_Gets, x, odrg

    if ::in_file = 'cenzboz'
      for x := 1 to len( pa) step 1
        odrg        := ::dm:has(pa[x]):odrg
        odrg:IsEdit := ::smallBasket_State
        if( ::smallBasket_State, odrg:oxbp:enable(), odrg:oxbp:disable() )
      next
    endif
  return self

 inline method set_focus_dBro()
    local  o_dBro  := ::o_dBro
    local  members := ::df:aMembers, pos

    pos := ascan(members,{|X| (x = o_dBro )})
    ::df:olastdrg   := ::o_dBro
    ::df:nlastdrgix := pos
    ::df:olastdrg:setFocus()

    setAppFocus( ::o_dBro:oxbp )
    postAppEvent( xbeBRW_ItemMarked,,, ::o_dBro:oxbp)
  return self

ENDCLASS


method PRO_nabvyshd_cen_SEL:eventHandled(nEvent, mp1, mp2, oXbp)

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


METHOD PRO_nabvyshd_cen_SEL:init(parent)
  local  odrg := parent:parent:lastXbpInFocus:cargo
  *
  local  items

  ::drgUsrClass:init(parent)

  ::o_parent_udcp := parent:parent:udcp
  ::o_parent_dm   := parent:parent:dataManager
  ::o_parent_dBro := parent:parent:odBrowse[1]

  ::m_udcp   := parent:parent:udcp
  ::drgVar   := setAppFocus():cargo
//  ::popState := 1
//  ::nrok     := uctObdobi:SKL:nROK

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

  * pro smallBasket
  ::hd_file           := ::o_parent_udcp:hd_file
  ::it_file           := ::o_parent_udcp:it_file
  ::smallBasket_Gets  := {'nabVysitW->nmnoznOdes', 'nabVysitW->czkratJedn', 'nabVysitW->nprocDph'  , ;
                          'nabVysitW->ncenaZakl' , 'nabVysitW->nhodnslev' , 'nabVysitW->nprocSlev'  }

  ::smallBasket_ncenaZakl := 0.00
  ::smallBasket_nhodnSlev := 0.00
  ::smallBasket_nprocSlev := 0.00
  ::smallBasket_ncenaZakl := 0.0
  ::smallBasket_nmnozOdes := 0.0

RETURN self


METHOD PRO_nabvyshd_cen_SEL:drgDialogStart(drgDialog)
  local members  := drgDialog:oForm:aMembers, x
  local cisFirmy := strZero(nabvyshdw->ncisFirmy,5)
  *
  local pa       := { GraMakeRGBColor({ 78,154,125}), ;
                      GraMakeRGBColor({157,206,188})  }
  *
  local vsech_Nezak  := format( "cCisZakaz = '%%'"    , { EMPTY_VYRPOL } )
  local nabid_KFirme := format( "ccisZakaz = 'NAV-%%'", { cisFirmy     } )
  *
  local pa_quick := { ;
  { 'kompletní seznam              ' , ''                                                   }, ;
  { 'všechny nezakázkové           ' ,  vsech_Nezak                                         }, ;
  { 'všechny nabídkové             ' , 'ccisZakaz = "NAV"'                                  }, ;
  { 'nabídkové k dané firmì        ' ,  nabid_KFirme                                        }, ;
  { 'nezakázkové a nabídkové       ' ,  vsech_Nezak + ' .or. ccisZakaz = "NAV"'             }, ;
  { 'nezakázkové a nabídkové k fimì' ,  vsech_Nezak + ' .or. ' +nabid_KFirme                }, ;
  { 'nezakázkové s výkresem        ' ,  vsech_Nezak + ' .and. .not. (ccisVyk = "      ")'   }  }

  ::dc     := drgDialog:dialogCtrl
  ::dm     := drgDialog:dataManager
  ::df     := drgDialog:oForm                     // form
  ::o_dBro := drgDialog:odBrowse[1]

  *
  for x := 1 TO LEN(members) step 1
    if     members[x]:ClassName() = 'drgPushButton'
      if( ischaracter(members[x]:event)   , ::drgPush := members[x], nil)
      if( members[x]:event = 'smallBasket', ::pb_smallBasket := members[x], nil )

    elseif members[x]:ClassName() = 'drgDBrowse'
      ::obro := members[x]

    elseif members[x]:ClassName() = 'drgStatic'
      ::sta_activeBro := if( members[x]:oxbp:type = XBPSTATIC_TYPE_ICON, members[x], nil )

    endif
  next

  if isObject( ::drgPush )
    ::drgPush:oXbp:setFont(drgPP:getFont(5))
    ::drgPush:oxbp:SetGradientColors( pa )
  endif
  *
  ** smallBasket
  if isObject(::pb_smallBasket)
    ::pb_smallBasket:oxbp:setImageAlign( XBPALIGN_VCENTER +XBPALIGN_HCENTER )
  endif

  ::o_dBro_basketW    := drgDialog:odBrowse[ if( ::in_file = 'cenzboz', 2, 1 )]
  ::smallBasket_State := .f.
  ::enable_or_disable_Gets()

  ::quickFiltrs:init( self, pa_quick, 'Vyrábìné položky' )
RETURN


METHOD PRO_nabvyshd_cen_SEL:getForm()
  local  oDrg, drgFC, headTite

  headTitle := if(::in_file = 'cenzboz'  , 'skladových položek', 'vyrábìných položek')

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 117,25 DTYPE '10' TITLE 'Seznam ' +headTitle +' _ výbìr' ;
                                            GUILOOK 'IconBar:n,Menu:n,Message:n,Border:y'

  do case
  case ::in_file = 'cenzboz'
  * Pøevzít z Ceníku zboží         ->cenzboz
    DRGACTION INTO drgFC CAPTION 'info ~Ceník'      EVENT 'SKL_CENZBOZ_INFO' ;
                                                    TIPTEXT 'Informaèní karta skladové položky'


    DRGSTATIC INTO drgFC FPOS 0,0 SIZE 117,10.8 STYPE 1 RESIZE 'yy'
      DRGDBROWSE INTO drgFC FPOS -.5,-.2 FILE 'CENZBOZ'            ;
        FIELDS 'M->cenPol:c:2.6::2,'                             + ;
               'M->isSest:s:2.6::2,'                             + ;
               'cCISSKLAD:èisSklad,'                             + ;
               'cSKLPOL:sklPoložka,'                             + ;
               'cNAZZBO:název zboží:33,'                         + ;
               'nZBOZIKAT:katZbo,'                               + ;
               'cJKPOV:jkpov,'                                   + ;
               'nMnozSZBO:množSkl,'                              + ;
               'nMNOZDZBO:množKDisp,'                            + ;
               'cZkratJedn:mj,'                                  + ;
               'nCenaSZBO:cenaSkl,'                              + ;
               'nCenaPZBO:cenaProd,'                             + ;
               'nCenaNZBO:cenaNák'                                 ;
        SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y' RESIZE 'yy'
     DRGEND INTO drgFC

*    košík
     DRGSTATIC INTO drgFC FPOS 110,11 SIZE 6,4.1 RESIZE 'yy'
       DRGPUSHBUTTON INTO drgFC CAPTION '2' POS .1,3.1 SIZE 6,4.1 ;
                                EVENT 'smallBasket' ICON1 208 ICON2 108 ATYPE 1
     DRGEND INTO drgFC


     DRGSTATIC INTO drgFC FPOS .5,11 SIZE 109,4 STYPE 13 RESIZE 'yn'
       odrg:ctype := 2

       DRGSTATIC INTO drgFC FPOS -.3, .5 SIZE 23,65 STYPE 3 CAPTION '337'

* množství
       DRGTEXT INTO drgFC CAPTION 'Množství v '          CPOS  3,  .5  CLEN  9
       DRGGET  nabVysitW->nmnoznOdes INTO drgFC          FPOS 14,  .5  FLEN 13 PP 2
       DRGGET  nabVysitW->czkratJedn INTO drgFC          FPOS 29,  .5  FLEN  6 PP 2
       DRGTEXT INTO drgFC CAPTION 'dph'                  CPOS 40,  .5  CLEN  5 CTYPE 1
       DRGGET  nabVysitW->NPROCDPH   INTO drgFC          FPOS 48,  .5  FLEN  7 PP 2
       DRGTEXT INTO drgFC CAPTION '%'                    CPOS 56,  .5  CLEN  3 CTYPE 1

* ceny
       DRGTEXT INTO drgFC CAPTION 'Ceny v'               CPOS  3  ,2.7 CLEN  6
       DRGTEXT INTO drgFC NAME     nabVyshdW->czkratmenZ CPOS  9  ,2.7 CLEN  5 FONT 5

       DRGTEXT INTO drgFC CAPTION 'cenaZákladní'         CPOS 16  ,1.7 CLEN 10
       DRGGET  nabVysitW->ncenaZakl  INTO drgFC          FPOS 14  ,2.7 FLEN 13 PICTURE '@N 9999999.99'

       DRGTEXT INTO drgFC CAPTION 'slevaZákladní'        CPOS 31  ,1.7 CLEN 11
       DRGGET  nabVysitW->nhodnSlev INTO drgFC           FPOS 29  ,2.7 FLEN 13 PICTURE '@N 99999999.9999'

       DRGTEXT INTO drgFC CAPTION '['                    CPOS 44  ,1.7 CLEN 2 CTYPE 2
         odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_BLUE'
       DRGTEXT nabVyshdW->nprocSlFAO INTO drgFC          CPOS 44  ,1.7 CLEN 5 PICTURE '@N 99.9' CTYPE 2

       DRGTEXT INTO drgFC CAPTION '+'                    CPOS 48  ,1.7 CLEN 3 CTYPE 2
         odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_BLUE'
       DRGTEXT nabVyshdW->nprocSlHOT INTO drgFC          CPOS 50  ,1.7 CLEN 4 PICTURE '@N 99.9' CTYPE 2

       DRGTEXT INTO drgFC CAPTION '+ 0,0 '               CPOS 54  ,1.7 CLEN 6 CTYPE 2
         odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_BLUE'
       DRGTEXT INTO drgFC CAPTION ']'                    CPOS 59.2,1.7 CLEN 2 CTYPE 2
         odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_BLUE'

       DRGGET nabVysitW->nprocSlev INTO drgFC            FPOS 47  ,2.7 FLEN 9 PICTURE '@N 999.9999'
       DRGTEXT INTO drgFC CAPTION '%'                    CPOS 57.2,2.7 CLEN 3
         odrg:groups := 'SETFONT,7.Arial CE,GRA_CLR_GREEN'

       DRGTEXT INTO drgFC CAPTION 'prodejní cena'        CPOS 64  ,1.7 CLEN 11 CTYPE 2
       DRGTEXT nabVysitW->ncenaZakl INTO drgFC           CPOS 63  ,2.7 CLEN 13 BGND 13 CTYPE 2

       DRGTEXT INTO drgFC CAPTION 'celkem bez danì'      CPOS 78  ,1.7 CLEN 13 CTYPE 2
       DRGTEXT nabVysitW->ncenZakCel INTO drgFC          CPOS 78  ,2.7 CLEN 13 BGND 13 CTYPE 2

       DRGTEXT INTO drgFC CAPTION 'celkem s daní'        CPOS 95  ,1.7 CLEN 10 CTYPE 2
       DRGTEXT nabVysitW->ncenZakCed INTO drgFC          CPOS 93,  2.7 CLEN 14 BGND 13 CTYPE 2
     DRGEND INTO drgFC


     DRGTABPAGE INTO drgFC CAPTION 'Košík' FPOS .5,15.6 SIZE 116,9 OFFSET 13,74 PRE 'tabSelect' TABHEIGHT 0 TTYPE 3
       DRGDBROWSE INTO drgFC FPOS -.5, .2 SIZE 116,8 FILE 'nabVysitW'  ;
           FIELDS 'nintcount:polDokl,'                               + ;
                  'ccisSklad:sklad,'                                 + ;
                  'csklPol:sklPoložka,'                              + ;
                  'cnazZbo:název zboží:39,'                          + ;
                  'nmnozNOdes:mn_nabízeno,'                          + ;
                  'czkratJedn:mj,'                                   + ;
                  'ncenZakCel:cenCelk,'                              + ;
                  'ncenZakCed:cenaCelksDPH'                            ;
          CURSORMODE 3 PP 9 INDEXORD 1 RESIZE 'yy' SCROLL 'ny'
     DRGEND INTO drgFC

**   DRGEND INTO drgFC

  otherWise
  * Pøevzít z Vyrábìných položek   ->vyrpol
    DRGACTION INTO drgFC CAPTION 'info ~Ceník'      EVENT 'SKL_CENZBOZ_INFO' ;
                                                    TIPTEXT 'Informaèní karta skladové položky'
    DRGACTION INTO drgFC CAPTION 'oprava ~VyrPol'   EVENT 'VYRPOL_OPRAVA'  ;
                                                    TIPTEXT 'oprava vyrábìné položky'
    DRGACTION INTO drgFC CAPTION 'kopie vyr~Pol'    EVENT 'VYRPOL_COPY'       ;
                                                    TIPTEXT 'Kopie vyrábìné položky'
    DRGACTION INTO drgFC CAPTION 'kopie ~Z položky' EVENT 'KUSOP_COPY'       ;
                                                    TIPTEXT 'Kopie kusovníku a operací z vyrábìné položky'
    DRGACTION INTO drgFC CAPTION '~Kusovník'        EVENT 'KusTree'       ;
                                                    TIPTEXT 'Strukturovaný kusovník'


    DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 110,14 FILE 'VYRPOL'       ;
      FIELDS 'M->isin_cenZboz:c:2.6::2,'                           + ;
             'VYR_isKusov(1;"VyrPol"):Ku:1::2,'                    + ;
             'VYR_isPolOp(1;"VyrPol"):Op:1::2,'                    + ;
             'cCISVYK:èísloVýkresu,'                               + ;
             'cNAZVYK:názevVýkresu:30,'                            + ;
             'cCISZAKAZ:èísloZakázky:20,'                          + ;
             'cVYRPOL:vyrPoložka,'                                 + ;
             'nVARCIS:var,'                                        + ;
             'cCISSKLAD:èisSklad,'                                 + ;
             'cSKLPOL:sklPoložka,'                                 + ;
             'cNAZEV:název zboží:33,'                              + ;
             'cVARPOP:popisvarianty,'                              + ;
             'nMNZADVA:nnožKVýr'                                     ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y' ITEMMARKED 'itemMarked'

    DRGPUSHBUTTON INTO drgFC CAPTION 'Kompletní seznam ' POS 71.5,0.05 SIZE 38,1 ;
                  EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'

  endcase

  DRGEND INTO drgFC

RETURN drgFC



METHOD PRO_nabvyshd_cen_SEL:drgDialogEnd(drgDialog)
RETURN self

method PRO_nabvyshd_cen_SEL:itemMarked()
  local  cky := upper(vyrpol->ccisSklad) +upper(vyrpol->csklPol)

  ok := cenZboz->( dbSeek( cky,, 'CENIK03'))
return self



* Oprava vyrábìné položky
********************************************************************************
method PRO_nabvyshd_cen_SEL:VyrPOL_oprava(drgDialog)
  local oDialog, nExit

  DRGDIALOG FORM 'VYR_VYRPOL_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT

  ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
return .t.

* Kopie
********************************************************************************
METHOD PRO_nabvyshd_cen_SEL:KusOp_Copy()
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

********************************************************************************
METHOD PRO_nabvyshd_cen_SEL:VyrPol_Copy()
  Local oDialog

  DRGDIALOG FORM 'VYR_VYRPOL_CRD' CARGO drgEVENT_APPEND2 ;
                                  PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:odBrowse[1]:oxbp:refreshAll()
RETURN self

* Strukt. kusovník
********************************************************************************
method PRO_nabvyshd_cen_SEL:kusTree()
  local oDialog
  *
  DRGDIALOG FORM 'VYR_KusTREE_SCR, 0' PARENT ::dm:drgDialog MODAL DESTROY
  ::obro:oXbp:refreshAll()
return self