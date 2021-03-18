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

HIDDEN:
  VAR     dc, dm, bro_Vyr
  var     in_file, obro, popState, drgPush, parent

ENDCLASS


METHOD PRO_nabvyshd_cen_SEL:init(parent)
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


METHOD PRO_nabvyshd_cen_SEL:getForm()
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

  ::quickFiltrs:init( self, pa_quick, 'Vyrábìné položky' )
RETURN


METHOD PRO_nabvyshd_cen_SEL:drgDialogEnd(drgDialog)
RETURN self

method PRO_nabvyshd_cen_SEL:itemMarked()
  local  cky := upper(vyrpol->ccisSklad) +upper(vyrpol->csklPol)

  ok := cenZboz->( dbSeek( cky,, 'CENIK03'))
return self


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
