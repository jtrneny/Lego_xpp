#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  AKCIONAR
** CLASS AKC_akcionar_SCR *****************************************************
CLASS AKC_akcionar_SCR FROM drgUsrClass, quickFiltrs, AKC_doplnujici_in
EXPORTED:
  METHOD  Init
  method  drgDialogStart
  METHOD  EventHandled
  METHOD  itemMarked

  * browColumn
  * AKCIE
  inline access assign method nazevAkc() var nazevAkc      // název typu akcie c_typAkc
    c_typAkc->( dbseek( upper(akcie->cZkrTypAkc),,'C_TYPAKC01'))
    return c_typAkc->cnazevAkc

  inline access assign method zpusNab() var zpusNab
    local  sID := isNull(akcionar->sID,0)
    local  cky := strZero(sID,10,0) +upper(akcie->cserCISakc)

    apohybAk->( dbseek( cky,,'ApohybAK03'))
    return upper(apohybAk->czkrTYPpoh)


  * BUTTONky
  inline  method akc_akcionar_novy(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'AKC_akcionar_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND
    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
  return .t.


  inline method akc_akcionar_oprava(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'AKC_akcionar_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT
    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
  return .t.


  inline method akc_akcie_pohyb(drgDialog)
    local oDialog, nExit

    akcie_p->( dbseek( akcie->sID,, 'ID'))

    DRGDIALOG FORM 'AKC_akcie_IN' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT
    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
  return .t.

  inline method tabSelect(oTabPage,tabnum)
    ::tabNum := tabnum
  return .t.

HIDDEN:
  var  tabNum, brow, act_akcie_pohyb

ENDCLASS


*
********************************************************************************
METHOD AKC_akcionar_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL  dc := ::drgDialog:dialogCtrl

  if( .not. akcie->( eof()) .and. ::tabNum = 1, ::act_akcie_pohyb:oxbp:enable(), ::act_akcie_pohyb:oxbp:disable() )

  DO CASE
*  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
*    ::itemSelected()

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.


METHOD AKC_akcionar_SCR:init(parent)
  local ctmpW  := drgINI:dir_USERfitm +userWorkDir() +'\akcie_w'

  ::drgUsrClass:init(parent)

  drgDBMS:open('OSOBY')

  drgDBMS:open('c_typAr' )   // typ akcionáøe
  drgDBMS:open('c_oblasA')   // typ akcionáøe
  drgDBMS:open('c_typAkc')   // typ akcií

  drgDBMS:open('apohybAk')   // pohyb akcií

  *
  ** pro možnost zavolání AKC_akcie_IN BUTTON
  ::tabNum := 1
  drgDBMS:open('akcie',,,,,'akcie_p')

RETURN self


method AKC_akcionar_SCR:drgDialogStart( drgDialog )
  local  members := drgDialog:oActionBar:members, x
  *
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby    v pracovnì právním vztahu', 'nis_ZAM = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah ', 'nis_ZAM = 0' }, ;
  { 'Osoby    v personální evidenci    ', 'nis_PER = 1' }, ;
  { 'Osoby mimo personální evidenci    ', 'nis_PER = 0' }  }

  for x := 1 to len(members) step 1
    if( members[x]:event = 'akc_akcie_pohyb' , ::act_akcie_pohyb  := members[x], nil)
  next

  ::brow := drgDialog:dialogCtrl:oBrowse
  ::quickFiltrs:init( self, pa_quick, 'Osoby' )

  ** doplòující nabídka
  ::AKC_doplnujici_in:init(drgDialog)
return self


METHOD AKC_akcionar_SCR:itemMarked()
  local  nAKCIONAR := isNull(akcionar->sID, 0 )
  local  cf := "nAKCIONAR = %%", filter

  c_typAr ->( dbseek( akcionar->cZkrTypAr ,,'C_TYPAR01' ))
  c_oblasA->( dbseek( akcionar->czkrOblast,,'C_OBLASA01'))
  c_psc   ->( dbseek( akcionar->cpsc      ,,'C_PSC1'    ))

  filter := format( cf, {nAKCIONAR} )
  akcie   ->( ads_setAof(filter), dbgoTop())

  cf     += " or nAKCIONARp = %%"
  filter := format( cf, {nAKCIONAR,nAKCIONAR} )
  apohybak->( ads_setAof(filter), dbgoTop())

**  if( ::tabNum = 3, ::brow[3]:refresh(.T.), nil )
RETURN self


*METHOD AKC_akcionar_SCR:itemSelected()
*  DRGDIALOG FORM 'FIR_FIRMY_SCR' PARENT ::drgDialog DESTROY
*  PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
*RETURN self


*
** CLASS for AKC_akcionar_sel **************************************************
CLASS AKC_akcionar_sel FROM drgUsrClass
EXPORTED:
  method  init

  * BUTTONky
  inline  method akc_akcionar_novy(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'AKC_akcionar_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND
    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
    ::dm:refresh(.t.)
  return .t.


  inline method akc_akcionar_oprava(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'AKC_akcionar_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT
    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
    ::dm:refresh(.t.)
  return .t.


  inline method drgDialogStart(drgDialog)
     ::dm  := drgDialog:dataManager             // dataManager
   return self

  *
  ** BODY method
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

    do case
    case nEvent = drgEVENT_EXIT   ;  ::recordSelected()
    case nEvent = drgEVENT_EDIT   ;  ::recordSelected()
    case nEvent = drgEVENT_APPEND
      ::recordEdit()
    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        return .f.
      endcase

    otherwise
      return .f.
    endcase
  return .t.


  inline method recordSelected()
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self


  inline method recordEdit()
    ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'AKC_akcionar_CRD' PARENT ::drgDialog DESTROY MODAL
    ::drgDialog:popArea()                  // Restore work area
  return self

hidden:
  var  dm

ENDCLASS


method AKC_akcionar_sel:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('akcionar',,,,,'akcionar_S')
return self


*
** CLASS for AKC_akcionar_crd **************************************************
CLASS AKC_akcionar_crd FROM drgUsrClass
EXPORTED:
  var     lnewRec

  method  init, drgDialogStart
  method  postValidate

  *
  * onSave
  inline method onSave(lOk,isAppend,oDialog)
    local  mainOk := .t.

    if .not. ::lnewRec
      akcionar->( dbgoTo( akcionarW->_nrecOr))
      mainOk := akcionar->(sx_rLock())
    endif

    if mainOk
      mh_copyFld( 'akcionarW', 'akcionar', ::lnewRec, .f. )
      if( .not. ::lnewRec, ::onSave_akcionar(), nil )
    else
      drgMsgBox(drgNLS:msg('Nelze modifikovat AKCIONÁØE, blokováno uživatelem ...'))
    endif

    akcionar->(dbunlock(),dbcommit())
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  return mainOk

hidden:
* sys
  var     msg, dm, dc, df
  var     m_file     // main file ze akc_akcionar_scr.akcionar, z akc_akcionar_sel.akcionar_S
  var     hd_file

  inline method onSave_akcionar()
    local  oStatement, cStatement
    local  stmt :=  "update akcie set akcie.cjmenoAkci = '%cjmenoAkci', " + ;
                                     "akcie.czkrTYPar  = '%czkrTYPar' , " + ;
                                     "akcie.crodCISakc = '%crodCISakc'  " + ;
                                 "where ( akcie.nAKCIONAR = %sid );"

    cStatement := strTran( stmt      , '%cjmenoAkci', akcionar->cjmenoAkci )
    cStatement := strTran( cStatement, '%czkrTYPar' , akcionar->czkrTYPar  )
    cStatement := strTran( cStatement, '%crodCISakc', akcionar->crodCISakc )
    cStatement := strTran( cStatement, '%sid'       , str(akcionar->sID,10))
    oStatement := AdsStatement():New(cStatement, oSession_data)

    if oStatement:LastError > 0
       *  return .f.
     else
       oStatement:Execute( 'test', .f. )
       oStatement:Close()
     endif
   return .t.

ENDCLASS


method AKC_akcionar_crd:init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .not. (parent:cargo = drgEVENT_EDIT)
  ::hd_file := 'akcionarW'
  ::m_file  := if( lower(parent:parent:formName) = 'akc_akcionar_scr', 'akcionar', 'akcionar_S' )

  *
  drgDBMS:open('c_typAr' )   // typ akcionáøe
  drgDBMS:open('c_oblasA')   // typ akcionáøe
  drgDBMS:open('c_typAkc')   // typ akcií
  *
  ** tmp soubory **
  drgDBMS:open('AKCIONARw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  if ::lnewRec
    AKCIONARw->( dbappend())
  else
    mh_copyFld( ::m_file, 'AKCIONARw', .t., .t. )
  endif
return self


method AKC_akcionar_CRD:drgDialogStart(drgDialog)
  local x

  ::msg           := drgDialog:oMessageBar             // messageBar
  ::dm            := drgDialog:dataManager             // dataManager
  ::dc            := drgDialog:dialogCtrl              // dataCtrl
  ::df            := drgDialog:oForm                   // form
return self


METHOD AKC_akcionar_CRD:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  local  recNo  := akcionar->( recNo())

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


  do case

  * kontroly na hlavièce akcionar
  case( file = ::hd_file )
    do case
    case( name = ::hd_file +'->cjmenoakci' )
      ** povinný údaj
      if empty(value)
        ::msg:writeMessage('Jméno akcionáøe je povinný údaj ...',DRG_MSG_WARNING)
        ok := .f.
      endif

    case( name = ::hd_file +'->crodcisakc' )
      ** povinné/ kontrola správnosti, picture
      ** kontrola na duplicitu akcionar.crodcisakc
      if empty(value)
        ::msg:writeMessage('Rodné èíslo akcionáøe je povinný údaj ...',DRG_MSG_WARNING)
        ok := .f.
      else
        if akcionar->( dbseek(value,,'AKCIONAR01'))
          ::msg:writeMessage('Rodné èíslo akcionáøe již v seznamu akcionáøù exituje ...',DRG_MSG_WARNING)
          ok := .f.
        endif
      endif
    endcase
  endcase

  * na akcionar ukládme vždy
  if('akcionarw' $ name .and. ok, drgVAR:save(),nil)
return ok