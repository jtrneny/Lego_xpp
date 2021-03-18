#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "Gra.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define d_popup    'Kompletní ceník zboží            ,' + ;
                   'Zboží k objednání                ,' + ;
                   'Zboží k dodavateli               ,' + ;
                   'Zboží k dodavateli a k objednámí ,' + ;
                   'Zboží pod minStavem              ,' + ;
                   'Zboží pod minStavem  k dodaveteli,' + ;
                   'Zboží k objedání k hlDodavateli   '



*   CENÍK ZBOŽÍ pro OBJEDNÁVKY PØIJATÉ
**  CLASS for NAK_objvyshd_cen_sel *********************************************
CLASS NAK_objvyshd_cen_sel FROM drgUsrClass
exported:
  method  init, drgDialogStart, itemMarked, eventHandled
  method  createContext, fromContext

  * cenzboz - ceníková/neceníková položka
  inline access assign method cenPol() var cenPol
    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

hidden:
  method  relFiltrs
  var     dm ,drgVar, drgPush, popState
  var     nrok

ENDCLASS


method NAK_objvyshd_cen_sel:eventHandled(nEvent, mp1, mp2, oXbp)
  local oDialog, nExit

  do case
  case nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    cenzboz->(ads_clearAof())
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)

  case nEvent = drgEVENT_APPEND
    DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
    oXbp:refreshAll()

  case nEvent = drgEVENT_FORMDRAWN
     Return .T.

  case nEvent = xbeP_Keyboard
    do case
    case mp1 = xbeK_ESC  ;  PostAppEvent(xbeP_Close,,, oXbp)
    otherwise
      return .f.
    endcase

  otherwise
    return .f.
  endcase
return .t.


method NAK_objvyshd_cen_sel:init(parent)

  ::drgVar   := setAppFocus():cargo ///  parent:parent:lastXbpInFocus:cargo
  ::popState := 1
  ::nrok     := uctObdobi:SKL:nROK

  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('CENZB_ps')
  drgDBMS:open('C_SKLADY')

  drgDBMS:open('C_DPH'   )
  CENZBOZ->( DbSetRelation( 'C_DPH', {||CENZBOZ->nKlicDPH },'CENZBOZ->nKlicDPH' ))

  drgDBMS:open('C_KATZBO')
  CENZBOZ->( DbSetRelation( 'C_KATZBO', {||CENZBOZ->nZboziKat },'CENZBOZ->nZboziKat' ))

  drgDBMS:open('C_UCTSKP')
  CENZBOZ->( DbSetRelation( 'C_UCTSKP', {||CENZBOZ->nUcetSkup } ,'CENZBOZ->nUcetSkup' ))

  ::drgUsrClass:init(parent)
return self


method NAK_objvyshd_cen_sel:drgDialogStart(drgDialog)
  local  members  := drgDialog:oForm:aMembers
  local  showDlg  := .T., file_iv, varSym, tagNo, pa
  *
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog, apos, asize

  *
  **
  ::dm := drgDialog:dataManager

  if IsObject(::drgVar)
    apos := mh_GetAbsPosDlg(::drgVar:oXbp,drgDialog:dataAreaSize)
// ne    drgDialog:usrPos := {aPos[1],aPos[2] -25}
  endif

  *
  for x := 1 TO LEN(members) step 1
    IF( members[x]:ClassName() = 'drgPushButton', ::drgPush := members[x], NIL )
  next

  ::drgPush:oXbp:setFont(drgPP:getFont(5))
  ::drgPush:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
return self


method NAK_objvyshd_cen_sel:itemMarked()
  local  cky := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)

  pvpkumul->(AdsSetOrder('PVPKUM2'), dbSetScope(SCOPE_BOTH, cky), dbgotop())
return self


method NAK_objvyshd_cen_sel:createContext()
  LOCAL cSubMenu, oPopup, aPos, aSize, x, pa, nIn
  *
  local popUp := d_popup

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


method NAK_objvyshd_cen_sel:fromContext(aOrder, nMENU)
  local  obro := ::drgDialog:odbrowse[1]
  *
  local  crels := 'strZero(objvyshdw->ncisFirmy) +upper(cenzboz->ccisSklad) +upper(cenZboz ->csklPol)'
  local  filter, ex_filtr := "(cpolcen = 'C' .or. cpolCen = 'E')", ex_cond

  ::popState := aOrder
  ::drgPush:oxbp:setCaption(nMENU)

  do case
  case(aOrder = 1)                  ;  cenzboz->(ads_clearAof(), dbgoTop())
  case(aOrder = 2)                  ;  filter = ex_filtr + " .and. nmnozKZbo <> 0"
  case(aOrder = 3)
    filter  := ex_filtr
    ex_cond := 'objvyshdw->ncisFirmy = dodzboz->ncisFirmy'

  case(aOrder = 4)
    filter  := ex_filtr +" .and. nmnozKZbo <> 0"
    ex_cond := 'objvyshdw->ncisFirmy = dodzboz->ncisFirmy'

  case(aOrder = 5)
    filter := ex_filtr +" .and. nmnozSZbo < nminZbo"

  case(aOrder = 6)
    filter  := ex_filtr +" .and. nmnozSZbo < nminZbo"
    ex_cond := 'objvyshdw->ncisFirmy = dodzboz->ncisFirmy'

  case(aOrder = 7)
    filter  := ex_filtr +" .and. nmnozKZbo > 0"
    ex_cond := 'dodzboz->lhlavniDod'
  endcase

  if .not. isnull(filter)
    cenzboz->(ads_setAof(filter), dbgoTop())
    if .not. isnull(ex_cond)
      dodzboz->(AdsSetOrder('DODAV6'))
      cenzboz->(dbsetRelation('dodzboz', COMPILE(crels), crels ), dbskip(0))
      ::relFiltrs('cenzboz',ex_cond)
    endif
  endif
  obro:oxbp:refreshAll()
return self


method NAK_objvyshd_cen_sel:relfiltrs(mfile, ex_cond)
  local  pa := {}, filter := ''


  do while .not. (mfile)->(eof())
    if( DBGetVal(ex_cond), aadd(pa,(mfile)->(recno())), nil)

    (mfile)->(dbskip())
  enddo

  (mfile)->(ads_clearaof(), dbgotop())

  aeval(pa,{|x| filter += 'recno() = ' +str(x) +' .or. '})
  filter := left(filter, len(filter)-6)
  if( empty(filter), filter := 'recno() = 0', nil)

  (mfile)->(dbclearRelation(), ads_setaof(filter), dbgotop())
return self