***************************************************************************
* SKL_CENZBOZ_SEL.PRG,  SKL_CENTERM_SKL, SKL_CENVYR
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"


********************************************************************************
* SKL_CENZBOZ_SEL ...
********************************************************************************
CLASS SKL_CENZBOZ_SEL FROM drgUsrClass, quickFiltrs

EXPORTED:
  METHOD  Init, EventHandled, drgDialogStart

ENDCLASS

********************************************************************************
METHOD SKL_CENZBOZ_SEL:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('C_SKLADY')
*  CENZBOZ->( DbSetRelation( 'C_SKLADY', {||CENZBOZ->cCisSklad },'CENZBOZ->cCisSklad' ))
  drgDBMS:open('C_DPH')
  CENZBOZ->( DbSetRelation( 'C_DPH', {||CENZBOZ->nKlicDPH },'CENZBOZ->nKlicDPH' ))
  drgDBMS:open('C_KATZBO')
  CENZBOZ->( DbSetRelation( 'C_KATZBO', {||CENZBOZ->nZboziKat },'CENZBOZ->nZboziKat' ))
  drgDBMS:open('C_UCTSKP')
  CENZBOZ->( DbSetRelation( 'C_UCTSKP', {||CENZBOZ->nUcetSkup } ,'CENZBOZ->nUcetSkup' ))
  *
RETURN self

********************************************************************************
METHOD SKL_CENZBOZ_SEL:drgDialogStart(drgDialog)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ::quickFiltrs:init( self                                             , ;
                      { { 'Kompletn� seznam       ', ''               }, ;
                        { 'Aktivn� polo�ky        ', 'laktivni = .t.' }, ;
                        { 'Neaktivn� polo�ky      ', 'laktivni = .f.' }  }, ;
                      'Cen�k'                                            )
RETURN

********************************************************************************
METHOD SKL_CENZBOZ_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)

  CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
    ::drgDialog:odBrowse[1]:oXbp:refreshAll()

  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,, oXbp)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.



#Define tabCENZBOZ        1
#Define tabPVPTERM        2
*
#define  ERR_TERM_PRIJEM_           1
#define  ERR_TERM_PRIJEM_CENA       1
#define  ERR_TERM_PRIJEM_NONE       2

#define  ERR_TERM_VYDEJ_            2
#define  ERR_TERM_VYDEJ_MNOZSKL     1
#define  ERR_TERM_VYDEJ_NAKLST      2
#define  ERR_TERM_VYDEJ_NONE        3


#Define  ERR_TERM_POPIS    { { 'Nen� cena na p��jmov�m dokladu                ',;
                               'Nedefinov�no                                  ' } ,;
                             { 'Vyd�van� mno�stv� p�esahuje mno�stv� skladov� ',;
                               'Nen� vypln�na n�kladov� struktura             ',;
                               'Nedefinov�no                                  ' }  }

********************************************************************************
* SKL_CENTERM_SEL ...
********************************************************************************
CLASS SKL_CENTERM_SEL FROM drgUsrClass, quickFiltrs

EXPORTED:
  var  cpvpTerm_filter

  inline access assign method cenzboz_kDis() var cenzboz_kDis
    local mnozPrDod := 0, recNo
    local it_file   := ::it_file

    if ::is_vydej
      recNo := (it_file)->( recNo())
      (it_file)->( dbeval( { || mnozPrDod += (it_file)->nmnozPrDod    }, ;
                           { || (it_file)->csklPol = cenZboz->csklPol }  ), ;
                     dbgoto( recNo )                                            )

    endif
    return cenZboz->nmnozDZbo -mnozPrDod


  METHOD  Init, EventHandled, drgDialogStart, drgDialogEnd, itemMarked, tabSelect
  METHOD  TermToPVP, RefreshDATA, post_bro_colourCode, doAppend


  inline method comboBoxInit(drgComboBox)
    local  cname      := lower(drgParseSecond(drgComboBox:name,'>'))
    local  acombo_val := {}
    local  typPohybu  := allTrim( (::hd_file)->ctypPohybu)
    local  cc         := if( (::hd_file)->ntypPoh = 2, 'V�DEJ', 'P��JEM' )

    c_typPOH->( dbSEEK( S_DOKLADY + typPohybu,, 'C_TYPPOH02'))

    if( cname = 'cpvpterm_filter' )
      aadd( acombo_val, {  typPohybu                                               , ;
                           '( ' +typPohybu +' ) _ ' + allTrim(c_typPoh->cnazTypPoh)  } )
      aadd( acombo_val, {  ''                                                      , ;
                           '         _ z�sobn�k komletn� seznam ' +cc                } )

      drgComboBox:oXbp:clear()
      drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
      aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

      * mus�me nastavit startovac� hodnotu *
      drgComboBox:value := drgComboBox:ovar:value := typPohybu
      ::cpvpTerm_filter := typPohybu
    endif
  return self

  inline method comboItemSelected(drgComboBox)
    local  value

     if isobject(drgComboBox)
       value  := drgComboBox:Value

       if( 'cpvpterm_filter' $ lower(drgComboBox:name) )
         ::cpvpTerm_filter := value
         ::set_pvpTerm_filter()
       endif
     endif
   return self


   inline method set_pvpTerm_filter()
     local c_filter

     if empty(::cpvpTerm_filter)
       pvpTerm->( ads_setAof(::m_filter), dbgoTop())
     else
       c_filter := format( ::m_filter +" .and. ctypPohybu = '%%'", {::cpvpTerm_filter} )
       pvpTerm->( ads_setAof(c_filter), dbgoTop())
     endif

     ::dc:oaBrowse:oXbp:refreshAll()
     setAppFocus( ::dc:oaBrowse:oXbp )
     PostAppEvent(xbeBRW_ItemMarked,,,::dc:oaBrowse:oXbp)
   return self


HIDDEN:
  VAR     dm, dc, ab
  var     m_filter, tabNum
  var     ost_context, ost_pvpTerm_filter
  var     is_vydej, it_file, hd_file

  METHOD  PVPTerm_CTRL_ENTER, PVPTerm_CTRL_A
ENDCLASS

********************************************************************************
METHOD SKL_CENTERM_SEL:init(parent)
  ::drgUsrClass:init(parent)

  ::is_vydej        := .f.
  ::m_filter        := pvpTerm->( ads_getAof())
  ::cpvpTerm_filter := ''

  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('C_SKLADY')
  drgDBMS:open('C_DPH')
  CENZBOZ->( DbSetRelation( 'C_DPH', {||CENZBOZ->nKlicDPH },'CENZBOZ->nKlicDPH' ))
  drgDBMS:open('C_KATZBO')
  CENZBOZ->( DbSetRelation( 'C_KATZBO', {||CENZBOZ->nZboziKat },'CENZBOZ->nZboziKat' ))
  drgDBMS:open('C_UCTSKP')
  CENZBOZ->( DbSetRelation( 'C_UCTSKP', {||CENZBOZ->nUcetSkup } ,'CENZBOZ->nUcetSkup' ))
  *
  * Mo�n� na cfg.parametr budou cht�t se pozicovat na z�lo�ku nasn�man�ch dat - zat�m na cen�k
  ::tabNum   := tabCENZBOZ

  ::hd_file  := if( ismemberVar( parent:parent:udcp, 'HD'), lower(parent:parent:udcp:HD), '' )
  ::it_file  := if( ismemberVar( parent:parent:udcp, 'IT'), lower(parent:parent:udcp:IT), '' )
RETURN self

********************************************************************************
METHOD SKL_CENTERM_SEL:drgDialogStart(drgDialog)
  Local cmb_pvpTerm_filter
  *
  ::dm  := drgDialog:dataManager             // dataMananager
  ::dc  := drgDialog:dialogCtrl
  ::ab  := drgDialog:oActionBar:Members
  
  ColorOfTEXT( ::dc:members[1]:aMembers )
  *
  ::hd_file  := if( ismemberVar( drgDialog:parent:udcp, 'HD'), lower(drgDialog:parent:udcp:HD), '' )
  ::it_file  := if( ismemberVar( drgDialog:parent:udcp, 'IT'), lower(drgDialog:parent:udcp:IT), '' )

  if ::hd_file = 'pvpheadw' .and. ::it_file = 'pvpitemww'
    ::is_vydej := ( (::hd_file)->ntypPoh = 2 )   // v�dejky
  endif
  *
  InCenZboz_akt()
  Check_TermERRs()
  ::drgDialog:odBrowse[2]:oXbp:refreshAll()
  *
    cmb_pvpTerm_filter := ::dm:has('M->cpvpTerm_filter'):odrg
  ::ost_pvpTerm_filter := cmb_pvpTerm_filter:oxbp:parent

  if ::tabNum = tabCENZBOZ
    ::ost_pvpTerm_filter:hide()

    IF ::drgDialog:parent:udcp:cfg_nTypNabPol = 2
      cenzboz->( dbGoTO( ::drgDialog:parent:udcp:recCenZbo))
      ::drgDialog:odBrowse[2]:oXbp:refreshAll()
    endif
    *
     ::quickFiltrs:init( self                                          , ;
                      { { 'Kompletn� seznam       ', ''               }, ;
                        { 'Aktivn� polo�ky        ', 'laktivni = .t.' }, ;
                        { 'Neaktivn� polo�ky      ', 'laktivni = .f.' }  }, ;
                      'Cen�k'                                            )

  endif

  ::ost_context     := ::pb_context:oXbp:parent

  ::set_pvpTerm_filter()
RETURN

********************************************************************************
METHOD SKL_CENTERM_SEL:drgDialogEnd(drgDialog)
RETURN self

********************************************************************************
METHOD SKL_CENTERM_SEL:ItemMarked()
  LOCAL members  := ::drgDialog:oActionBar:Members, x
  Local cKey := Upper( PVPTerm->cCisSklad) +  Upper( PVPTerm->cSklPol)

  IF !EMPTY( PVPTerm->cCisSklad)
    CenZboz->( dbSeek( cKey,, 'CENIK03'))
  ENDIF

  * zalo�it skl.kartu m��e pouze kdy� neexistuje ( tj. buton je enabled)
  FOR x := 1 TO LEN( Members)
    IF  ::ab[x]:event = 'TERM_CENZBOZ_CRD'
      IF( PVPterm->lInCenZBOZ, ::ab[x]:oXbp:disable(), ::ab[x]:oXbp:enable() )
      ::ab[x]:oXbp:setColorFG( If( PVPterm->lInCenZBOZ, GraMakeRGBColor({128,128,128}),;
                                                        GraMakeRGBColor({0,0,0})))
    ENDIF
  NEXT
RETURN self

********************************************************************************
METHOD SKL_CENTERM_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit, lOK, cKey

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT

    IF ::tabNUM = tabCENZBOZ
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
    ENDIF
    *
    IF ::tabNUM = tabPVPTERM
      IF ( lOK := InCenZboz_one( .T.) )
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
      ELSE
        drgMsgBox(drgNLS:msg( 'Polo�ka nenalezena v cen�ku zbo�� ...'  ))
      ENDIF
    ENDIF
    * ulo��me si, ze kter� z�lo�ky jsme p�eb�rali - 1 = CenZboz, 2 = PVPTERM
    ::drgDialog:parent:cargo_usr := ::tabNum

  CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
    ::dc:oBrowse[1]:oXbp:refreshAll()

  /*
  CASE nEvent = drgEVENT_ACTION
    IF isCharacter(mp1) .and.  mp1 = 'TermToPVP'
       PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
    ENDIF
   */
  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,, oXbp)

*    CASE( mp1 = xbeK_CTRL_ENTER)
*       lOK := ::PVPTerm_CTRL_ENTER()
*       RETURN lOK

    CASE( mp1 = xbeK_CTRL_A)
      ::PVPTerm_CTRL_A()

    CASE( mp1 = xbeK_ALT_F1)
      Check_ERRsBOX()
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_CENTERM_SEL:post_bro_colourCode()
*
* Touto metodou se p�ekr�v� kl�vesa CTRL+ENTER na browse.
* Pokud polo�ka nespl�uje podm�nky, nesm� j�t ozna�it.
RETURN ( ::PVPTerm_CTRL_ENTER())

* Ozna�en� jednotliv�ho z�znamu k p�enosu
********************************************************************************
METHOD SKL_CENTERM_SEL:PVPTerm_CTRL_ENTER()
  Local lOK := ( PVPterm->lInCenZboz .and. empty( PVPterm->cTermERRs ))
  *
  IF lOK
    RETURN .F.
  ELSE
      Check_ERRsBOX()
    RETURN .T.
  ENDIF
RETURN .T.

* Na CTRL+A se ozna�� v�echny z�znamy, kter� spl�uj� podm�nky pro p�enos do dokladu
********************************************************************************
METHOD SKL_CENTERM_SEL:PVPTerm_CTRL_A()
  Local x

  PVPterm->( dbGoTOP())
  DO WHILE !PVPterm->( eof())
    * K p�enosu se ozna�� jen polo�ky, kter� jsou v cen�ku a neobsahuj� chyby
    lOK := ( PVPterm->lInCenZboz .and. empty( PVPterm->cTermERRs ))
    IF lOK
       aadd( ::dc:oaBrowse:arselect, PVPTERM->( RecNo()) )
    ENDIF
    PVPterm->( dbSKIP())
  ENDDO
  PVPterm->( dbGoTOP())
  ::dc:oaBrowse:refresh()

RETURN self

********************************************************************************
METHOD SKL_CENTERM_SEL:tabSelect( tabPage, tabNumber)
  LOCAL  x, lOk, oAktivni := ::dataManager:get('m->nAktivni', .f.)

  ::tabNUM := tabNumber
  lOk := ( ::tabNum = tabPVPTERM)
  *  aktivace/deaktivace tla��tek pro z�lo�ky
  FOR x := 1 TO LEN( ::ab)
    IF Upper( ::ab[x]:event) $ 'REFRESHDATA,TERMTOPVP'
      IF( lOk, ::ab[x]:oXbp:enable(), ::ab[x]:oXbp:disable() )
    ENDIF
    *
    IF Upper( ::ab[x]:event) $ 'TERM_CENZBOZ_CRD'
      IF( lOk, nil,  ::ab[x]:oXbp:disable() )
    ENDIF
    ::ab[x]:oXbp:setColorFG( If( !lOk, GraMakeRGBColor({128,128,128}),;
                                       GraMakeRGBColor({0,0,0})))
   NEXT

   * aktivace/deaktivace quickfiltru a comba
   if tabNumber = 1
     ( ::ost_pvpTerm_filter:hide(), ::ost_context:show() )
   else
     ( ::ost_context:hide(), ::ost_pvpTerm_filter:show() )
   endif
RETURN .T.

********************************************************************************
METHOD SKL_CENTERM_SEL:TermToPVP(drgDialog)
  Local nOrdItem := 0, nMn, isLock := PVPTERM->( FLock()), lOK, aRECs, n

  IF !isLock
    RETURN nil
  ENDIF
  *
  aRECs := ::dc:oaBrowse:arselect
  IF LEN( aRECs) = 0
    drgMsgBox(drgNLS:msg( 'Nebyla ozna�ena ��dn� polo�ka k p�enosu ! ;' + ;
                          'K ozna�en� pou�ijte CTRL+ENTER (jednotliv�) nebo CTRL+A (hromadn�)...' ))
    RETURN nil
  ENDIF
  *
  IF drgIsYESNO(drgNLS:msg( 'P�en�st v�echny ozna�en� polo�ky z termin�lu do dokladu ?' ) )
    _clearEventLoop(.t.)

    PVPITEMww->_delrec := '9'
    * zjist�me po�et polo�ek v dokladu, abysme mohli nav�zat s nOrdItem
    PVPITEMww->( dbGoBottom())
    nOrdItem := PVPITEMww->nOrdItem
    *
    PVPterm->( dbGoTOP())
    FOR n := 1 TO LEN( aRECs)
      PVPTERM->( dbGoTO( aRECs[ n]))
      * Do dokladu se p�enesou jen polo�ky, kter� jsou v cen�ku a neobsahuj� chyby
      lOK := ( PVPterm->lInCenZboz .and. empty( PVPterm->cTermERRs ))
      IF lOK
        PVPITEMww->( dbAppend())
        mh_copyFld( 'PVPterm', 'PVPITEMww'  )
        mh_copyfld( 'PVPHEADw', 'PVPITEMww' )
        CenZboz->( dbSeek( Upper(PVPterm->cCisSklad) + Upper(PVPterm->cSklPol),,'CENIK03'))
        *
        PVPITEMww->cNazPol1 := PVPTerm->cStredisko
        PVPITEMww->cNazPol2 := PVPTerm->cVyrobek
        PVPITEMww->cNazPol3 := PVPTerm->cZakazka
        PVPITEMww->cNazPol4 := PVPTerm->cVyrMisto
        PVPITEMww->cNazPol5 := PVPTerm->cStroj
        PVPITEMww->cNazPol6 := PVPTerm->cOperace
        *
        PVPITEMww->nrec_Term := PVPTERM->( RecNo()) //9.11.
        nOrdItem++
        PVPITEMww->nOrdItem := nOrdItem
        *
        nMn := KoefPrVC_MJ( PVPITEMww->cMJDokl1 ,;
                            CenZboz->cZkratJedn ,;
                            'CenZboz' )
        PVPITEMww->nCenNapDod := PVPITEMww->nCenaDokl1 / nMn
        *
        nMn := PrepocetMJ( PVPITEMww->nMnozDokl1,;
                           PVPITEMww->cMJDokl1  ,;
                           CenZboz->cZkratJedn, 'CenZboz' )
        PVPITEMww->nMnozPrDod := nMn
        *
        PVPITEMww->nCenaCelk := PVPITEMww->nCenNapDod * PVPITEMww->nMnozPrDod
        * Aktualizace pln�n� v PVPTERM
        PVPTERM->nMnoz_PLN := PVPITEMww->nMnozDokl1
        PVPTERM->nStav_PLN := IF( PVPTERM->nMnoz_PLN > 0 .and. PVPTERM->nMnoz_PLN < PVPTERM->nMnozDokl1, 1,;
                                  IF( PVPTERM->nMnoz_PLN = PVPTERM->nMnozDokl1, 2, 0))
        *
        * z CenZBOZ
        PVPITEMww->nKlicDPH   := CenZboz->nKlicDPH
        PVPITEMww->nUcetSkup  := CenZboz->nUcetSkup
        PVPITEMww->cUcetSkup  := PADR( CenZboz->nUcetSkup, 10)
        PVPITEMww->cZkratMENY := CenZboz->cZkratMENY
        PVPITEMww->cZkratJedn := CenZboz->cZkratJedn
        PVPITEMww->nKlicNAZ   := CenZboz ->nKlicNaz
        PVPITEMww->nZboziKAT  := CenZboz ->nZboziKAT
        PVPITEMww->cPolCen    := CenZboz->cPolCen
        PVPITEMww->cTypSKP    := CenZboz->cTypSKP
        PVPITEMww->cUctovano  := ' '
        PVPITEMww->nTypPOH    := IIF( PVPHEADw->nKARTA < 200,  1,;
                                 IIF( PVPHEADw->nKARTA < 300, -1,;
                                 IIF( PVPHEADw->nKARTA = 400,  1, 0 )))
        PVPITEMww->cCisZakaz  := IF( PVPITEMww->nTypPoh = -1, PVPITEMww->cNazPol3, PVPITEMww->cCisZakaz )
        PVPITEMww->cCisZakazI := PVPITEMww->cCisZakaz
        PVPITEMww->cCasPVP    := time()
        PVPITEMww->nRec_CenZb := CenZboz ->( RecNo())
        PVPITEMww->_nRecor    := 0
      ENDIF
    NEXT
    PVPITEMww->( dbGoTop())

    IF nOrdItem = 0
       drgMsgBox(drgNLS:msg( 'Do dokladu nebyla p�enesena ��dn� polo�ka ...'  ))
    Else
       * nastav� stav dokladu na "rozpracov�n"
       drgDialog:parent:UDCP:uHd:set_saveBut(1)
*       drgMsgBox(drgNLS:msg( 'P�enos polo�ek do dokladu prob�hl OK ...'  ))
    ENDIF
    * ukon�� edita�n� kartu polo�ky ???
*    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, drgDialog:parent:dialog )

    * ukon�� v�b�rov� dialog z PVPTerm
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, ::drgDialog:dialog )

    * ukon�� edita�n� kartu polo�ky ???
    drgDialog:parentdialog:cargo:udcp:lPrevzitTT := .T.
*    PostAppEvent(xbeP_Keyboard, xbeK_ESC,,  ::dc:oBrowse[ 2]:oXbp )
  ENDIF
  PVPTERM->( dbUnlock())
RETURN .t.

* Aktualizece - refre� dat
********************************************************************************
METHOD SKL_CENTERM_SEL:RefreshDATA()
  *
  InCenZboz_akt()
  Check_TermERRs()
  ::drgDialog:odBrowse[2]:oXbp:refreshAll()
RETURN self

********************************************************************************
METHOD SKL_CENTERM_SEL:doAppend( nEvent)
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('SKL_CENZBOZ_CRD', ::drgDialog)
  oDialog:cargo := nEvent   // drgEVENT_APPEND
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  IF nExit = drgEVENT_SAVE
*    ::OnSave(,, oDialog )
    oDialog:dataManager:save()
    IF( oDialog:dialogCtrl:isAppend, CENZBOZ->( DbAppend()), Nil )
    IF CENZBOZ->(sx_RLock())
       mh_COPYFLD('CENZBOZw', 'CENZBOZ' )
*       mh_WRTzmena( 'C_PRACOV', ::lNewREC)
       CENZBOZ->( dbUnlock())
       ::drgDialog:dialogCtrl:browseRefresh()
    ENDIF

  ENDIF
  oDialog:destroy(.T.)
  oDialog := Nil
RETURN .T.

* Zobrazen� zji�t�n�ch chyb na termin�lov�ch polo�k�ch - ALT + F1
*===============================================================================
FUNCTION Check_ERRsBOX()
  Local n, x, nTypPVP, cText := 'Termin�lov� polo�ka obsahuje chyby : ;'
  *
  IF EMPTY( PVPTERM->cTermERRs)
    RETURN NIL
  ENDIF
  *
  FOR n := 1 TO LEN( Alltrim(PVPTERM->cTermERRs))
    x := Val( Substr( Alltrim(PVPTERM->cTermERRs), n, 1 ))
    cText += ' ;  ' + ERR_TERM_POPIS[ PVPTERM->nTypPVP, x]
  NEXT
  *
  drgMsgBox(drgNLS:msg( cText))
RETURN NIL

*===============================================================================
FUNCTION Check_TermERRs()
  Local cERR := '', cNs := ''

  IF PVPTerm->( FLock())
    drgDBMS:open('CENZBOZ',,,,, 'CenZBOZa' )
    PVPTerm->( dbGoTop())
    DO WHILE ! PVPterm->( Eof())
      CenZBOZa->( dbSeek( Upper(PVPterm->cCisSklad) + Upper(PVPterm->cSklPol),,'CENIK03'))
      cERR := ''
      cNs  := ''

      DO CASE
      Case PVPTERM->nTypPVP = 1        // P��jem
        * 1 = kontrola, zda cena p�ij�man� polo�ky nen� nulov�
        cERR += IF( PVPTERM->nCenaDokl1 = 0, STR( ERR_TERM_PRIJEM_CENA, 1), '' )

      Case PVPTERM->nTypPVP = 2        // V�dej
        * 1 = kontrola, zda vyd�van� mno�stv� nep�esahuje mn. skladov�
        cERR += IF( (PVPTERM->nMnozDokl1 - PVPTERM->nMnoz_PLN) > CenZBOZa->nMnozsZBO,;
                    STR( ERR_TERM_VYDEJ_MNOZSKL, 1), '' )

        * 2 = kontrola, zda je vypln�na n�kladov� struktura
         cNS += AllTrim( PVPTERM->cStredisko) + AllTrim( PVPTERM->cVyrobek)  + ;
                AllTrim( PVPTERM->cZakazka)   + AllTrim( PVPTERM->cVyrMisto) + ;
                AllTrim( PVPTERM->cStroj)     + AllTrim( PVPTERM->cOperace)
         cERR += IF( EMPTY( cNs), STR( ERR_TERM_VYDEJ_NAKLST, 1), '' )

      ENDCASE
      *
      PVPTERM->cTermERRs  := cERR

      PVPTerm->( dbSkip())
    ENDDO
    PVPterm->( dbUnlock(), dbGoTop())
    CenZBOZa->( dbCloseArea())
  ENDIF

RETURN NIL


#define  tabVYRPOL    2

********************************************************************************
* SKL_CENVYR_SEL ...     V�b�r z CenZboz a VyrPol
********************************************************************************
CLASS SKL_CENVYR_SEL FROM drgUsrClass

EXPORTED:
  VAR     nFilter
  METHOD  Init, EventHandled, drgDialogStart, drgDialogEnd, itemMarked, tabSelect
  METHOD  ComboItemSelected, KusOp_Copy

HIDDEN:
  VAR     dc, dm, tabNum, bro_Vyr
  METHOD  FilterOnVyrPol
ENDCLASS

********************************************************************************
METHOD SKL_CENVYR_SEL:init(parent)
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
  ::tabNum  := tabCENZBOZ
  ::nFilter := 1
RETURN self

********************************************************************************
METHOD SKL_CENVYR_SEL:drgDialogStart(drgDialog)
  *
  ::dc  := drgDialog:dialogCtrl
  ::dm  := drgDialog:dataManager
  ColorOfTEXT( ::dc:members[1]:aMembers )
  *
  ::bro_Vyr := drgDialog:odBrowse[tabVYRPOL]
  ::filterOnVyrPol()
*  ::drgDialog:odBrowse[2]:oXbp:refreshAll()
  *
RETURN

********************************************************************************
METHOD SKL_CENVYR_SEL:drgDialogEnd(drgDialog)
RETURN self

********************************************************************************
METHOD SKL_CENVYR_SEL:ItemMarked()
  LOCAL members  := ::drgDialog:oActionBar:Members, x
  Local cKey := Upper( VYRPOL->cCisSklad) +  Upper( VYRPOL->cSklPol)

  IF !EMPTY( VYRPOL->cCisSklad)
    CenZboz->( dbSeek( cKey,, 'CENIK03'))
  ENDIF

RETURN self
*
********************************************************************************
METHOD SKL_CENVYR_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit, lOK, cKey, cCilZakaz, nRec, existPROCEN, existVYRPOL

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
    * ulo��me si, ze kter� z�lo�ky jsme p�eb�rali - 1 = CenZboz, 2 = VYRPOL
    ::drgDialog:parent:cargo_usr := ::tabNum

    if ::tabNum = tabCENZBOZ
      cKey := Upper(CenZboz->cCisSklad) + Upper(CenZboz->cSklPol)
      existPROCEN := PROCENHO->( dbSeek( cKey,,'PROCENHO09'))
      existVYRPOL := VYRPOL->( dbSeek( cKey,,'VYRPOL9'))
    elseif ::tabNum = tabVYRPOL
      cKey := Upper(VyrPOL->cCisSklad) + Upper(VyrPOL->cSklPol)
      existPROCEN := PROCENHO->( dbSeek( cKey,,'PROCENHO09'))
      existVYRPOL := .T.
    endif
    * pro test
*    existPROCEN := .T.
*    existVYRPOL := .T.
    *
    ::drgDialog:parent:udcp:existPROCEN := existPROCEN
    ::drgDialog:parent:udcp:existVYRPOL := existVYRPOL

    IF nEvent = drgEVENT_EDIT .AND. existVYRPOL // ::tabNum = tabVYRPOL

      cCilZakaz := 'NAV-' + StrZero(NABVYSHDw->nCisFirmy, 5) + '-' + StrZero(NABVYSHDw->nDoklad,10)
      mh_CopyFld( 'VYRPOL' , 'VYRPOLw', .t.)
      *
      mh_CopyFld( 'VYRPOLw', 'VYRPOL' , .t.)
      VyrPOL->cCisZakaz  := cCilZakaz
      VyrPOL->nCisNabVys := NABVYSHDw->nDoklad
*      VyrPOL->nIntCount  := NABVYSITw->
//      VyrPOL->cUniqIdRec := VyrPOL->( mh_GetLastUniqID())
      VyrPOL->mUserZmenR := mh_WRTzmena( 'VyrPOL', .T.)
      nRec      := VyrPOL->( RecNo())
      VYR_VyrPOL_cpy( NIL, VyrPOLw->cCisZakaz, VyrPOLw->cVyrPol, VyrPOLw->nVarCis ,;
                           cCilZakaz         , VyrPOL->cVyrPol , VyrPOL->nVarCis  ,;
                     .T., .T.,.F. )

      VyrPOL->( dbGoTo(nRec))
      *
      NabVysITw->cCisZakaz  := cCilZakaz
      NabVysITw->cCisZakazI := cCilZakaz
      *
      ::itemMarked()
    ENDIF
    *
    IF nEvent = drgEVENT_EDIT .AND. existPROCEN
      * ??? zat�m nev�me
    ENDIF

  CASE nEvent = drgEVENT_APPEND
    IF ::tabNum = tabCENZBOZ
      DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
      ::dc:oBrowse[1]:oXbp:refreshAll()
    ELSEIF ::tabNum = tabVYRPOL
      DRGDIALOG FORM 'VYR_VYRPOL_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
      ::dc:oBrowse[2]:oXbp:refreshAll()
    ENDIF

  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,, oXbp)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_CENVYR_SEL:tabSelect( tabPage, tabNumber)
  LOCAL odrg := ::dm:has('m->nFilter'), oActions

  ::tabNUM := tabNumber
  odrg:oDrg:disabled := ( ::tabNUM = 1)
  odrg:oDrg:isEdit   := ( ::tabNUM = 2)
  *
  if ::tabNUM = 1
    odrg:oDrg:oXbp:hide()
  elseif ::tabNUM = 2
    odrg:oDrg:oXbp:show()
  endif
  *
  oActions := ::drgDialog:oActionBar:members
  for x := 1 to len(oActions)
    if ( lower( oActions[x]:event) $ 'vyr_vyrpol_info,kusop_copy' )   //aEventsDisabled)
      if ::tabNUM = 1
        oActions[x]:oXbp:hide()
      elseif ::tabNUM = 2
        oActions[x]:oXbp:show()
      endif
    endif
  next
  *
RETURN .T.

********************************************************************************
METHOD SKL_CENVYR_SEL:comboItemSelected( Combo)
  ::nFilter := Combo:value
  ::filterOnVyrPol()
RETURN .T.

* Kopie
********************************************************************************
METHOD SKL_CENVYR_SEL:KusOp_Copy()
  Local  cZdroj_VyrPol := STR( VyrPOL->( RecNO()) )
  Local  cCil_VyrPol   := STR( VyrPOL->( RecNO()) )
  /* ORG
  DRGDIALOG FORM 'VYR_VYRPOL_copy' CARGO cZdroj_VyrPol + ',' + cCil_VyrPol ;
                                   PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:odBrowse[1]:oxbp:refreshAll()
  */
  DRGDIALOG FORM 'VYR_VYRPOL_CRD' CARGO drgEVENT_APPEND2 ;
                                   PARENT ::drgDialog MODAL DESTROY
  ::mainBro:oxbp:refreshAll()
  */
RETURN self

*** HIDDEN *********************************************************************
METHOD SKL_CENVYR_SEL:filterOnVyrPol()
  Local cFilter := "cCisZakaz = '%%'"
  Local aFilter := ;
        { { EMPTY_VYRPOL},;                            // V�echny nezak�zkov�
        { 'NAV'}         ,;                            // V�echny nab�dkov�
        { 'NAV-' + StrZero( NABVYSHDw->nCisFirmy, 5)}} // Nab�dkov� k firm�
  *
  cFilter := Format( cFilter, aFilter[ ::nFilter] )
  VyrPol->( mh_SetFilter( cFilter))
  *
  ::bro_Vyr:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::bro_Vyr:oxbp)
  SetAppFocus(::bro_Vyr:oXbp)
RETURN .T.