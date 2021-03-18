
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_PolOPER_cpy FROM drgUsrClass
EXPORTED:
  VAR     cZak_src, cZakNaz_src, cPol_src, cPolNaz_src   // zdrojová
  VAR     cZak_trg, cZakNaz_trg, cPol_trg, cPolNaz_trg   // cílová

  METHOD  Init, Destroy
  METHOD  drgDialogStart, drgDialogEnd
  METHOD  PostValidate
  METHOD  VYR_VyrPol_sel
  * action
  METHOD  SubMenu_Copy, PolOPER_Sel_All, PolOPER_Sel_1kuN, PolOPER_Sel_1ku1
  METHOD  PolOPER_copy

  * Bro - polOper
  inline access assign method polOper_se_nazOper() var polOper_se_nazOper
    local  oznOper := upper( polOper_se->coznOper)

    operace->( dbSeek( oznOper,, 'OPER1'))
    return operace->cnazOper

  * Bro - polOper_w2
  inline access assign method polOper_w2_porCisLis() var polOper_w2_porCisLis
    return if( polOper_w2->nporCisLis = 0, 0, 552 )  // M_big_new  -  má vygenerovaný mlistHd ?

  inline access assign method polOper_w2_nazOper() var polOper_w2_nazOper
    local  oznOper := upper( POLOPER_w2->coznOper)

    operace->( dbSeek( oznOper,, 'OPER1'))
    return operace->cnazOper


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  oBro, nsid

    do case
    case nEvent = xbeBRW_ItemMarked
      do case
      case ( oxbp:className() = 'XbpBrowse')  ;  oBro := oxbp
      case ( oxbp:className() = 'XbpBrowse')  ;  oBro := oxbp:parent:cargo
      endCase

      if isObject(oBro)
        nsid := if( oBro = ::oBro_polOper_se, polOper_se->sid, polOper_w2->_nsidOr)
        polOper->( dbseek( nsid,,'ID'))
      endif
      return .f.

    case ( nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_EDIT )
      if ::dc:oaBrowse:oxbp = ::oBro_polOper_se
         if .not. polOper_se->(eof())
           ::copyfldto_w2()
           ::oBro_polOper_w2:goBottom():refreshAll()
         endif
       endif

    case nEvent = drgEVENT_DELETE
      if ::dc:oaBrowse:oxbp = ::oBro_polOper_w2
         if .not. polOper_w2->(eof())
           if ::polOper_w2_porCisLis() = 552
             fin_info_box( 'Položku operace, ' +CRLF +'nelze zrušit nebo již existuje mzdový lístek ...', XBPMB_CRITICAL )
             return .t.
           else
             if drgIsYESNO('Požadujete zrušit položku operace ... ?')
               polOper_w2->(dbdelete())
               ::oBro_polOper_w2:refreshAll()
             endif
           endif
         endif
       endif

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.


HIDDEN
  VAR     dm, dc, aRecOP
  var     oBro_polOper_se, oBro_polOper_w2
  *
  METHOD  CopyCONTROL, CopyToPOLOPER

  inline method copyfldto_w2()
    local  recNo := polOper_w2->( recNo())
    local  ncisOper

    polOper_w2->( dbgoBottom())
    ncisOper := polOper_w2->ncisOper +1

    mh_CopyFLD( 'polOper_se', 'PolOPER_w2', .T.)
    polOper_w2->cCisZAKAZ  := ::cZak_trg
    polOper_w2->cVyrPOL    := ::cPol_trg
    polOper_w2->ncisOper   := ncisOper
    polOper_w2->nRokVytvor := 0
    polOper_w2->nPorCisLis := 0
    polOper_w2->nPocCeZapZ := 0
    polOper_w2->nMnZadVK   := 0
    VYR_POLOPER_fill( polOper_w2->cCisZakaz, 'polOper_w2') // naplní ccisZakazI a  cvyrobCisl
  return self

ENDCLASS

*
********************************************************************************
METHOD VYR_PolOPER_cpy:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('OPERACE'  )
  drgDBMS:open('polOper',,,,,'polOper_se')

  drgDBMS:open('POLOPER_w2' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  *
  ::cZak_src    := EMPTY_ZAKAZ
  ::cPol_src    := EMPTY_VYRPOL
  ::cZakNaz_src := ::cPolNaz_src := space(30)

  ::cZak_trg    := KusTREE->cCisZAKAZ
  ::cZakNaz_trg := VyrZAK->cNazevZAK1
  ::cPol_trg    := IF( KusTREE->lNakPol, KusTREE->cSklPOL, KusTREE->cVyrPOL)
  ::cPolNaz_trg := KusTREE->cNazev

  ::aRecOP      := {}
RETURN self

*
********************************************************************************
METHOD VYR_PolOPER_cpy:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, aRec := {}
  LOCAL aInfo := { 'M->cZakNaz_src', 'M->cPolNaz_src', 'M->cZakNaz_trg', 'M->cPolNaz_trg'}

  AEVAL( aInfo,;
   {|c| drgDialog:dataManager:has(c):oDrg:oXbp:setColorBG( GraMakeRGBColor( {221, 221, 221} )) })
  *
  colorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ::dm := ::drgDialog:dataManager
  ::dc := ::drgDialog:dialogCtrl
  *
  ::oBro_polOper_se := ::dc:oBrowse[1]:oxbp
  ::oBro_polOper_w2 := ::dc:oBrowse[2]:oxbp

  *
  PolOPER->( dbGoTOP(), dbEVAL( {|| mh_CopyFLD( 'PolOPER', 'PolOPER_w2', .T.),;
                                    AADD( aRec, PolOPER->( RecNO()) )  }) )

  PolOPER_w2->( dbGoTOP())
  ::aRecOP := aClone( aREC)
  *
  VYR_ScopeOPER( .F.)
  *
  IsEditGet( {'M->cZak_trg', 'M->cPol_trg'}, drgDialog, .F. )
  *
   ::dc:oBrowse[1]:oXbp:refreshAll()
   ::dc:oBrowse[2]:oXbp:refreshAll()  // 28.1.08

RETURN self

*
********************************************************************************
METHOD VYR_PolOPER_cpy:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  cNAMe := oVar:name, cKey, nRec, nCount := 0
  Local  cField := drgParseSecond(cName, '>')

  DO CASE
    CASE cName $ Upper('M->cZak_src, M->cPol_src')
      IF oVar:changed()
        IF (lOK := ::VYR_VyrPOL_SEL() )
          ::dm:save()
*          PolOPER->( mh_SetSCOPE( ::cZak_src + ::cPol_src))

          ::dc:oBrowse[1]:oXbp:refreshAll()
          SetAppFocus(::dc:oaBrowse:oXbp)
        ENDIF
      ENDIF

    CASE cField $ Upper('nCisOper, nUkonOper,nVarOper')
      nRec := PolOPER_w2->(RecNO())
      cKey := Upper(::cZak_trg) + Upper(::cPol_trg) + ;
              StrZero( IF( cField = 'nCisOper' , xVar, PolOPER_w2->nCisOPER ), 4 ) + ;
              StrZero( IF( cField = 'nUkonOper', xVar, PolOPER_w2->nUkonOPER), 2 ) + ;
              StrZero( IF( cField = 'nVarOper' , xVar, PolOPER_w2->nVarOper ), 3 )
      PolOPER_w2->( mh_SetSCOPE( cKey) )
      PolOPER_w2->( dbEval({|| IF( PolOPER_w2->(RecNO()) <> nRec, nCount++, NIL) }) )
      PolOPER_w2->( mh_ClrSCOPE(), dbGoTo( nRec) )
      IF nCount > 0
        drgMsgBox(drgNLS:msg( 'Duplicitní klíè ...'))
        lOK := ( cField <> 'nVarOper')
      ENDIF
  ENDCASE
RETURN lOK

*
********************************************************************************
METHOD VYR_PolOPER_cpy:drgDialogEnd(drgDialog)

  if .not. empty( polOper_se->( ads_getAof()))
    polOper_se->( ads_clearAof())
  endif
  PolOPER_w2->( dbCloseArea())

  VYR_ScopeOPER()
  *
  drgDialog:parent:dialogCtrl:oaBrowse:oXbp:refreshAll()
RETURN self

*
********************************************************************************
METHOD VYR_PolOPER_cpy:destroy()
  ::drgUsrClass:destroy()
  *
  ::cZak_src := ::cZakNaz_src := ::cPol_src := ::cPolNaz_src := ;
  ::cZak_trg := ::cZakNaz_trg := ::cPol_trg := ::cPolNaz_trg := ;
  ::dm := ::aRecOP :=  NIL
RETURN self

*
********************************************************************************
METHOD VYR_PolOPER_cpy:VYR_VYRPOL_SEL( oDlg)
  LOCAL  oDialog, nExit
  *
  local  drgVar := ::dm:drgDialog:lastXbpInFocus:cargo:ovar
  local  name   := lower(drgVar:name)
  *
  local  czak_Src := upper( ::dm:get('M->cZak_src'))
  local  cpol_Src := upper( ::dm:get('M->cPol_src'))
  local  lOK,  cfiltrs

  do case
  case         empty(czak_Src)   .and.     empty(cpol_Src)
    lok := .t.
    vyrPol->( dbseek( czak_Src +cpol_Src,, 'VYRPOL1' ))
  case ( .not. empty(czak_Src) .and.       empty(cpol_Src) )
    lok := vyrPol->( dbseek( czak_Src,, 'VYRPOL1' ))
  case (       empty(czak_Src) .and. .not. empty(cpol_Src) )
    lok := vyrPol->( dbseek( cpol_Src,, 'VYRPOL4' ))
  otherWise
    lok := vyrPol->( dbseek( czak_Src +cpol_Src,, 'VYRPOL1' ))
  endCase

  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'VYR_VYRPOL_SEL' PARENT ::drgDialog  MODAL DESTROY EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.

     if name = 'm->czak_src'
      ::dm:set( 'M->cZak_src'   , VYRPOL->cCisZakaz  )
      ::dm:set( 'M->cZakNaz_src', VYRZAK->cNazevZak1 )

      ::cZakNaz_src := ::dm:get('M->cZakNaz_src')
    else
      ::dm:set( 'M->cPol_src'   , VYRPOL->cVyrPOL )
      ::dm:set( 'M->cPolNaz_src', VYRPOL->cNazev  )

      ::cPolNaz_src := ::dm:get('M->cPolNaz_src')
    endif
  endif


  if lok
    czak_Src := ::dm:get( 'M->cZak_src' )
    cpol_Src := ::dm:get( 'M->cPol_src' )

    do case
    case (       empty(czak_Src) .and.       empty(cpol_Src) )
      cfiltrs := ''
    case ( .not. empty(czak_Src) .and.       empty(cpol_Src) )
      cfiltrs := format( "ccisZakaz = '%%'", {czak_Src} )
    case (       empty(czak_Src) .and. .not. empty(cpol_Src) )
      cfiltrs := format( "cvyrPol = '%%'"  , { cpol_Src } )
    otherWise
      cfiltrs := format( "ccisZakaz = '%%' and cvyrPol = '%%'", { czak_Src, cpol_Src } )
    endcase

    if empty(cfiltrs) .and. .not. empty( polOper_se->( ads_getAof()))
      polOper_se->( ads_clearAof(), dbgoTop())
    else
      polOper_se->( ads_setAof(cfiltrs), dbgoTop())
    endif

    ::oBro_polOper_se:forceStable()
    ::oBro_polOper_se:refreshAll()
  endif
RETURN lOK

* Popup menu ...
*****************************************************************
METHOD VYR_PolOPER_cpy:SubMenu_Copy()
  LOCAL cSubMenu, oPopup, aPos, aSize

*  cSubMenu := drgNLS:msg('Vyber všechny,Vyber akt.-> na n var.,Vyber akt.->na 1.var.')
  cSubMenu := drgNLS:msg('Vyber všechny,Z akt. varianty vytvoø n var.,Z akt. varianty vytvoø 1.var.')
  oPopup := XbpMenu():new( ::drgDialog:dialog ):create()
  oPopup:addItem( {drgParse(@cSubMenu) , ;
                {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'POLOPER_Sel_ALL', '0', obj ) }} )
  oPopup:addItem( {drgParse(@cSubMenu) , ;
                {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'POLOPER_Sel_1kuN', '0', obj ) }} )
  oPopup:addItem( {drgParse(@cSubMenu) , ;
                {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'POLOPER_Sel_1ku1', '0', obj ) }} )

  aPos  := ::drgDialog:oActionBar:oBord:currentPos()
  aSize := ::drgDialog:oActionBar:oBord:currentSize()
  aPos[ 2] += aSize[ 2] - 3.5 * drgINI:FontH
  oPopup:popup( ::drgDialog:dialog, aPos )

RETURN Self

* Všechny operace v horním browse vybere ke kopírování
********************************************************************************
METHOD VYR_PolOPER_cpy:PolOPER_Sel_ALL()
LOCAL oDialog, nRec

  nREC := PolOPER->( RecNO())
  PolOPER->( dbEVAL( {|| mh_CopyFLD( 'PolOPER', 'PolOPER_w2', .T.),;
                         PolOPER_w2->cCisZAKAZ := ::cZak_trg,;
                         PolOPER_w2->cVyrPOL   := ::cPol_trg  }))
  PolOPER->( dbGOTO( nREC))
  ::dc:oBrowse[2]:oXbp:refreshAll()
RETURN self


* Vybere a ze zdrojové operace vytvoøí n-cílových operací
********************************************************************************
METHOD VYR_PolOPER_cpy:PolOPER_Sel_1kuN()
  LOCAL oDialog
  LOCAL nREC := PolOPER->( RecNO()), nVarOper := PolOPER->nVarOper
  Local nPolZAK := 0, cMsg

  drgDBMS:open('VyrZAKIT'  ,,,,, 'VyrZAKITa' )
  VyrZAKITa->( AdsSetOrder( 1),;
               mh_SetScope( Upper( ::cZak_trg)),;
               dbEVAL( {|| nPolZAK++ } ),;
               dbCloseArea() )

  cMsg := 'Požadujete ze zdrojové položky zakázky èíslo [ & ];' + ;
          'vytvoøit operace pro všechny položky cílové zakázky ?'
  IF  drgIsYESNO(drgNLS:msg(  cMsg, nVarOper))
    *
    PolOPER->( dbGoTOP())
    DO WHILE !PolOPER->( EOF())
      IF PolOPER->nVarOper = nVarOper
        FOR n := 1 TO nPolZAK
          mh_CopyFLD( 'PolOPER', 'PolOPER_w2', .T.)
          PolOPER_w2->cCisZAKAZ := ::cZak_trg
          PolOPER_w2->cVyrPOL   := ::cPol_trg
          PolOPER_w2->nVarOper  := n
        NEXT
      ENDIF
      PolOPER->( dbSKIP())
    ENDDO
    *
    PolOPER->( dbGOTO( nREC))
    ::dc:oBrowse[2]:oXbp:refreshAll()
  ENDIF

RETURN self

* Vybere a ze zdrojové operace vytvoøí 1 sadu operací, vždy s variantou 1.
********************************************************************************
METHOD VYR_PolOPER_cpy:PolOPER_Sel_1ku1()
  LOCAL oDialog
  LOCAL nREC := PolOPER->( RecNO()), nVarOper := PolOPER->nVarOper, cMsg
  *
  cMsg := 'Požadujete ze zdrojové položky zakázky èíslo [ & ];' + ;
          'vytvoøit operace s variantou 1 pro cílovou zakázku ?'
  IF  drgIsYESNO(drgNLS:msg(  cMsg, nVarOper))
    *
    PolOPER->( dbGoTOP())
    DO WHILE !PolOPER->( EOF())
      IF PolOPER->nVarOper = nVarOper
          mh_CopyFLD( 'PolOPER', 'PolOPER_w2', .T.)
          PolOPER_w2->cCisZAKAZ := ::cZak_trg
          PolOPER_w2->cVyrPOL   := ::cPol_trg
          PolOPER_w2->nVarOper  := 1
      ENDIF
      PolOPER->( dbSKIP())
    ENDDO
    *
    PolOPER->( dbGOTO( nREC))
    PolOPER_w2->( dbGOTOP())
    ::dc:oBrowse[2]:oXbp:refreshAll()
  ENDIF

RETURN self


*
********************************************************************************
METHOD VYR_PolOPER_cpy:PolOPER_copy()
  Local lOK

*  IF ::dc:oaBrowse:cFile = 'PolOPER_w2'
    IF lOK := ::CopyCONTROL()
      ::CopyToPOLOPER()
      PostAppEvent(xbeP_Close,drgEVENT_EXIT,,::drgDialog:dialog)
    ENDIF
*  ENDIF
RETURN self

* Kontrola, zda mezi kopírovanými operacemi neexistují operace duplicitním klíèem
*-------------------------------------------------------------------------------
METHOD VYR_PolOPER_cpy:CopyCONTROL()
  Local lOK, lVALID := YES, nStartREC := PolOPER_w2->( RecNO()), nREC, cKEY

  PolOPER_w2->( dbGoTOP())
  DO WHILE !PolOPER_w2->( EOF())
    nREC := PolOPER_w2->( RecNO())
    cKEY := PolOPER_w2->( sx_KeyData())  // UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)

    PolOPER_w2->( mh_SetSCOPE( cKey) )
    nCount := PolOPER_w2->( mh_CountREC())
    PolOPER_w2->( mh_ClrSCOPE(), dbGoTo( nRec) )
    lValid := IF( lValid, (nCount = 1), lValid )
    PolOPER_w2->( dbGoTO( nREC), dbSKIP())
  ENDDO
  IF !lValid
    PolOPER_w2->( dbGoTO( nStartREC))
    ( TONE( 125, 0 ), TONE( 80, 1 ), TONE( 125, 0 ) )
    drgMsgBox(drgNLS:msg( 'NELZE KOPÍROVAT !;;Existují duplicitní operace ...'))
  ENDIF
RETURN lVALID

* Vlastní kopírování operací z PolOPER_w2 do PolOPER
*-------------------------------------------------------------------------------
METHOD VYR_PolOPER_cpy:CopyToPOLOPER()
  Local cKEY
  * zruší pùvodní operace uložené v ::aRecOP
  IF PolOPER->( sx_RLock( ::aRecOP))
    AEVAL( ::aRecOP, {|Rec| PolOPER->( dbGoTO( Rec), dbDelete() ) } )
  ENDIF
  * nakopíruje vybrané operace
  PolOPER_w2->( dbGoTOP())
  DO WHILE !PolOPER_w2->( EOF())
    mh_CopyFLD( 'PolOPER_w2', 'PolOPER', .T.)
*    PolOPER->nRokVytvor := 0
*    PolOPER->nPorCisLis := 0
*    PolOPER->nPocCeZapZ := 0
*    PolOPER->nMnZadVK   := 0
*    VYR_POLOPER_fill( PolOper->cCisZakaz)
    PolOPER_w2->( dbSKIP())
  ENDDO
  PolOPER->( dbCOMMIT(), dbUnLOCK())
  * obnoví omezení nad PolOPER
  VYR_ScopeOPER()
RETURN NIL