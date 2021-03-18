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

  * CENZBOZ cen�kov� polo�ka / sestava
  inline access assign method cenPol() var cenPol
    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method isSest() var isSest
    local  retVal := 0, cky := space(30) +upper(cenzboz->csklPol)

    if cenzboz->ctypSklPol = 'S '
      retVal := if( kusov->(dbSeek(cky,,'KUSOV1')), MIS_BOOKOPEN, MIS_BOOK)
    endif
    return retVal

  * VYRPOL podle popisu m� b�t v�dy z�znam z VYRPOL v CENZBOZ - ale nen� to pravda
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

  headTitle := if(::in_file = 'cenzboz'  , 'skladov�ch polo�ek', 'vyr�b�n�ch polo�ek')

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 110,15.2 DTYPE '10' TITLE 'Seznam ' +headTitle +' _ v�b�r' ;
                                              GUILOOK 'IconBar:n,Menu:n,Message:n,Border:y'

  do case
  case ::in_file = 'cenzboz'
  * P�evz�t z Cen�ku zbo��         ->cenzboz
    DRGACTION INTO drgFC CAPTION 'info ~Cen�k'      EVENT 'SKL_CENZBOZ_INFO' ;
                                                    TIPTEXT 'Informa�n� karta skladov� polo�ky'

    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 110,14 FILE 'CENZBOZ'      ;
      FIELDS 'M->cenPol:c:2.6::2,'                                 + ;
             'M->isSest:s:2.6::2,'                                 + ;
             'cCISSKLAD:�isSklad,'                                 + ;
             'nZBOZIKAT:katZbo,'                                   + ;
             'cSKLPOL:sklPolo�ka,'                                 + ;
             'cNAZZBO:n�zev zbo��:33,'                             + ;
             'cJKPOV:jkpov,'                                       + ;
             'nCENAPZBO:prodCena,'                                 + ;
             'nMNOZDZBO:mno�KDisp'                                   ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'

  otherWise
  * P�evz�t z Vyr�b�n�ch polo�ek   ->vyrpol
    DRGACTION INTO drgFC CAPTION 'info ~Cen�k'      EVENT 'SKL_CENZBOZ_INFO' ;
                                                    TIPTEXT 'Informa�n� karta skladov� polo�ky'
    DRGACTION INTO drgFC CAPTION 'oprava ~VyrPol'   EVENT 'VYRPOL_OPRAVA'  ;
                                                    TIPTEXT 'oprava vyr�b�n� polo�ky'
    DRGACTION INTO drgFC CAPTION 'kopie vyr~Pol'    EVENT 'VYRPOL_COPY'       ;
                                                    TIPTEXT 'Kopie vyr�b�n� polo�ky'
    DRGACTION INTO drgFC CAPTION 'kopie ~Z polo�ky' EVENT 'KUSOP_COPY'       ;
                                                    TIPTEXT 'Kopie kusovn�ku a operac� z vyr�b�n� polo�ky'
    DRGACTION INTO drgFC CAPTION '~Kusovn�k'        EVENT 'KusTree'       ;
                                                    TIPTEXT 'Strukturovan� kusovn�k'


    DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 110,14 FILE 'VYRPOL'       ;
      FIELDS 'M->isin_cenZboz:c:2.6::2,'                           + ;
             'VYR_isKusov(1;"VyrPol"):Ku:1::2,'                    + ;
             'VYR_isPolOp(1;"VyrPol"):Op:1::2,'                    + ;
             'cCISVYK:��sloV�kresu,'                               + ;
             'cNAZVYK:n�zevV�kresu:30,'                            + ;
             'cCISZAKAZ:��sloZak�zky:20,'                          + ;
             'cVYRPOL:vyrPolo�ka,'                                 + ;
             'nVARCIS:var,'                                        + ;
             'cCISSKLAD:�isSklad,'                                 + ;
             'cSKLPOL:sklPolo�ka,'                                 + ;
             'cNAZEV:n�zev zbo��:33,'                              + ;
             'cVARPOP:popisvarianty,'                              + ;
             'nMNZADVA:nno�KV�r'                                     ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y' ITEMMARKED 'itemMarked'

    DRGPUSHBUTTON INTO drgFC CAPTION 'Kompletn� seznam ' POS 71.5,0.05 SIZE 38,1 ;
                  EVENT 'createContext' TIPTEXT 'Volba zobrazen� dat'

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
  { 'kompletn� seznam              ' , ''                                                   }, ;
  { 'v�echny nezak�zkov�           ' ,  vsech_Nezak                                         }, ;
  { 'v�echny nab�dkov�             ' , 'ccisZakaz = "NAV"'                                  }, ;
  { 'nab�dkov� k dan� firm�        ' ,  nabid_KFirme                                        }, ;
  { 'nezak�zkov� a nab�dkov�       ' ,  vsech_Nezak + ' .or. ccisZakaz = "NAV"'             }, ;
  { 'nezak�zkov� a nab�dkov� k fim�' ,  vsech_Nezak + ' .or. ' +nabid_KFirme                }, ;
  { 'nezak�zkov� s v�kresem        ' ,  vsech_Nezak + ' .and. .not. (ccisVyk = "      ")'   }  }

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

  ::quickFiltrs:init( self, pa_quick, 'Vyr�b�n� polo�ky' )
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
    * 1 - vyrpol mus� m�t vazbu na cenzboz, jinak nejde p�evz�t
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

* Oprava vyr�b�n� polo�ky
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

* Strukt. kusovn�k
********************************************************************************
method PRO_nabvyshd_cen_SEL:kusTree()
  local oDialog
  *
  DRGDIALOG FORM 'VYR_KusTREE_SCR, 0' PARENT ::dm:drgDialog MODAL DESTROY
  ::obro:oXbp:refreshAll()
return self
