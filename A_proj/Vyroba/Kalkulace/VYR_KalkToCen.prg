#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"


* 26.7.2016


********************************************************************************
*
********************************************************************************
CLASS VYR_KalkToCEN FROM drgUsrClass

EXPORTED:
  VAR     cCisSklad, cTypPol, cPrm, nCislPoh
  VAR     nCenMatMJP, nCenMzdVDP
  VAR     nAction, aAction, cAction

  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled
  METHOD  postValidate
  METHOD  Sklady_sel, TypPol_sel
  METHOD  Start

HIDDEN
  VAR     dm, df, msg, xbp_therm

ENDCLASS

*
********************************************************************************
METHOD VYR_KalkToCEN:init(parent)
  ::drgUsrClass:init(parent)

  ::cPrm    := ALLTRIM( drgParseSecond( parent:initParam, ','))
  ::nAction :=  IF( ::cPrm = "MAT", 1, 2 )
  ::aAction := { 'Pøecenìní skladu ', 'Aktualizace pøímých mezd '}
  ::cAction := ::aAction[ ::nAction]

  ::cCisSklad  := space(8)
  ::cTypPol    := space(3)
  ::nCenMatMJP := ::nCenMzdVDP := 0
  *
  drgDBMS:open('CenZBOZw'  ,.T.,.T.,drgINI:dir_USERfitm)
  drgDBMS:open('CenProdCw' ,.T.,.T.,drgINI:dir_USERfitm)
  *
RETURN self

*
********************************************************************************
METHOD VYR_KalkToCEN:drgDialogInit(drgDialog)
  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
RETURN self

*
********************************************************************************
METHOD VYR_KalkToCEN:drgDialogStart(drgDialog)

  ::dm        := drgDialog:dataManager
  ::df        := drgDialog:oForm                   // form
  ::msg       := drgDialog:oMessageBar
  ::xbp_therm := drgDialog:oMessageBar:msgStatus

  C_SKLADY->( dbSEEK( ::cCisSklad,, 'C_SKLAD1'))
  C_TYPPOL->( dbSEEK( ::cTypPOL  ,, 'TYPPOL1' ))
  ::dm:refresh()
RETURN self

*
********************************************************************************
METHOD VYR_KalkToCEN:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT   //.or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_SAVE

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

*
********************************************************************************
METHOD VYR_KalkToCEN:postValidate( oVar)
  LOCAL xVar  := oVar:get()
  LOCAL cName := UPPER(oVar:name), lOK := .T.

  DO CASE
    CASE cName = 'M->cCisSklad'
      lOK := ::Sklady_sel( xVar)
    CASE cName = 'M->cTypPol'
      lOK := ::TypPOL_sel( xVar)
  ENDCASE

RETURN lOK

********************************************************************************
METHOD VYR_KalkToCEN:Sklady_sel( xVar)
  Local cSklad :=  Upper(::dm:get('M->cCisSklad'))
  Local ret, lOK := C_SKLADY->( dbSEEK( cSklad,, 'C_SKLAD1'))

  IF IsObject( xVar) .or. !lOK
    ret := drgCallSearch( ::drgDialog, 'C_SKLADY', cSklad, '1' )
    IF  ( lOK := (ret <> nil ))
      ::dm:set('M->cCisSklad'       , ret )
    ENDIF
  ENDIF

  if( lok, ::dm:refresh(), nil )
RETURN lOK

********************************************************************************
METHOD VYR_KalkToCEN:TypPOL_sel( xVar)
  Local cTypPOL :=  Upper(::dm:get('M->cTypPOL'))
  Local ret, lOK := C_TYPPOL->( dbSEEK( cTypPOL,, 'TYPPOL1'))

  IF IsObject( xVar) .or. !lOK
    ret := drgCallSearch( ::drgDialog, 'C_TYPPOL', cTypPol, '1' )
    IF  ( lOK := (ret <> nil ))
      ::dm:set('M->cTypPOL'          , ret)
    ENDIF
  ENDIF

  if( lok, ::dm:refresh(), nil )
RETURN lOK


********************************************************************************
METHOD VYR_KalkToCEN:Start()
  Local  oDialog, nExit
  Local  Filter, cScope, cKey, cMsg := drgNLS:msg('MOMENT PROSÍM ...')
  Local  nCount := 0, nVlNaklady := 0
  *
  local  lok := .f., ctypPohPRC
  *
  local  nreccnt, nkeycnt, nkeyno
  local  nSize     := ::xbp_therm:currentSize()[1]
  local  nHight    := ::xbp_therm:currentSize()[2]


  ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
  *
  ::dm:save()
  drgDBMS:open( 'VyrPOL'  ) ; VyrPOL->( AdsSetOrder( 6))
  drgDBMS:open( 'KalKUL'  ) ; Kalkul->( AdsSetOrder( 4))
  drgDBMS:open( 'CenZboz' )
  drgDBMS:open( 'CenProdC')
  drgDBMS:open( 'C_DrPohy')
  drgDBMS:open( 'C_TypPoh' )

  CenZBOZw->( dbZAP())
  CenProdCw->( dbZAP())
  *
  IF ::cPrm = 'MAT'           // Pøecenìní
    if isCharacter( ctypPohPRC := SysConfig( 'Vyroba:ctypPohPRC' ) )
      lok := c_typPoh->( dbseek( 'SDOKLADY        ' + ctypPohPRC,,'C_TYPPOH02'))
    endif

    if .not. lok
      drgMsgBox(drgNLS:msg('Nelze pøecenit, není definován pøíslušný pohyb pro pøecenìní !'), XBPMB_CRITICAL )
      RETURN NIL
    endif
  ENDIF

  *
  Filter := "Kalkul->nStavKalk = -1 .and. Kalkul->nVarCis <> 0"
  Kalkul->( mh_SetFilter( Filter))
  nCount := Kalkul->( mh_COUNTREC())

  nkeycnt := kalkul->( ads_getKeyCount(1) )   // ADS_RESPECTSFILTERS
  nkeyno  := 1
  nstep   := 0

  *
  DO WHILE !KALKUL->( EOF())
    cKey := Upper( Kalkul->cCisZakaz) + Upper( Kalkul->cVyrPol) + StrZero( Kalkul->nVarCis, 3)

    IF VyrPOL->( dbSEEK( cKey,, 'VYRPOL1'))
      IF (  VyrPOL->cTypPol = ::cTypPOL)
        cKey := Padr(Upper( ::cCisSklad),8) + Upper( VyrPol->cSklPol)
        IF CenZboz->( dbSeek( cKey,,'CENIK03'))
          nVlNaklady  := ROUND( Kalkul->nCenMatMJP + Kalkul->nCenMzdVDP + Kalkul->nCenEnergP + ;
                                Kalkul->nRezVyrobP + Kalkul->nCenOstatP, 4 )
          IF ( ( Round( CenZboz->nCenaSZBO, 4) <> nVlNaklady ) .and. ( nVlNaklady <> 0) )
             mh_CopyFld( 'CenZBOZ', 'CenZBOZw', .t., .t. )
             CenZBOZw->nCenMatMJP := nVlNaklady
             CenZBOZw->ctypskp    := Str( Kalkul->sid)
             cenZbozW->nKALKUL    := kalkul->sID
          ENDIF
        ENDIF
        *
        IF CenProdC->( dbSeek( cKey,,'CENPROD1'))
          IF CenProdC->NCENAP4ZBO <> Kalkul->nCenMzdVDP
             mh_CopyFld( 'CenProdC', 'CenProdCw', .t., .t. )
             CenProdCw->nCenMzdVDP := Kalkul->nCenMzdVDP
          ENDIF
        ENDIF
      ENDIF
    ENDIF
    Kalkul->( dbSkip())

    nkeyNo++
    vyr_kalktocen_pb(::xbp_therm, nkeyCnt, nkeyNo, nsize, nhight)
  ENDDO
  KALKUL->( mh_ClrFilter())
  vyr_kalktocen_inf(::xbp_therm,'zpracování podkladù - dokonèeno', nSize, nHight)


  * Návrh dokladu o pøecenìní / aktualizace pøímých mezd
  oDialog := drgDialog():new('Bro_KalkToCen', ::drgDialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState
  oDialog:destroy(.T.)
  oDialog := Nil

  ::xbp_therm:setCaption( '  ' )
  ::msg:WriteMessage( 'Operace ukonèena ...', DRG_MSG_WARNING)
  sleep(150)

  ::msg:WriteMessage( '' )
  ( ::dm:set('M->cCisSklad', space(8)), ::dm:set( 'c_sklady->cnazSklad' , space(30)) )
  ( ::dm:set('M->cTypPOL'  , space(3)), ::dm:set( 'c_typPol->cnazTYPpol', space(30)) )
  ::df:setNextFocus( 'M->cCisSklad',,.t.)

RETURN self


*****************************************************************
* Bro_KalkToCen
*****************************************************************
CLASS Bro_KalkToCen FROM drgUsrClass

EXPORTED:
  var     NEWhd, nkarta, in_kalkToCen

  VAR     cFILE, cPrm, cCisSklad, nCislPoh

  METHOD  Init, getForm, itemMarked, drgDialogStart
  METHOD  SavePreceneni, SavePCeny
HIDDEN
  VAR     msg, oDBro_main, xbp_therm
  var     arSelected
ENDCLASS

*****************************************************************
METHOD Bro_KalkToCen:init(parent )
  ::drgUsrClass:init(parent)
  *
  ::NEWhd     := .t.
  ::nkarta    := val ( right( allTrim(c_typPoh->ctypDoklad), 3))

  ::cPrm      := parent:parent:UDCP:cPrm
  ::cCisSklad := parent:parent:UDCP:cCisSklad
  ::nCislPoh  := parent:parent:UDCP:nCislPoh
  ::cFile     := IF( ::cPrm = 'MAT', 'CenZBOZw', 'CenProdCw')
  (::cFile)->( dbGoTOP())
  IF ::cPrm = 'MAT'
    CenZBOZw->( OrdSetFocus('CENIKw01'))
  ENDIF
RETURN self

********************************************************************************
METHOD Bro_KalkToCen:drgDialogStart(drgDialog)

  ::msg        := drgDialog:oMessageBar
  ::oDBro_main := drgDialog:dialogCtrl:oBrowse[1]
  ::xbp_therm  := drgDialog:oMessageBar:msgStatus

  _clearEventLoop(.t.)
RETURN self


********************************************************************************
METHOD Bro_KalkToCen:getForm()
  LOCAL oDrg, drgFC
  LOCAL cTitle := IF( ::cPrm = 'MAT', 'NÁVRH dokladu na pøecenìní',;
                  IF( ::cPrm = 'MZD', 'NAVRH zmìn prodejních cen', ''))

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 105, 25 DTYPE '10' TITLE cTitle             ;
                                             FILE ::cFILE             ;
                                             GUILOOK 'Message:y,Action:y,IconBar:y:drgStdBrowseIconBar'

  IF ::cPrm = 'MAT'
*    DRGACTION INTO drgFC CAPTION 'info ~Ceník'  EVENT 'SKL_CENZBOZ_INFO' TIPTEXT 'Informaèní karta skladové položky'
    DRGACTION INTO drgFC CAPTION '~Pøecenit'    EVENT 'SavePreceneni'    TIPTEXT 'Vygenerovat doklad o pøecenìní'

    DRGDBROWSE INTO drgFC SIZE 104,24.9 FILE ::cFILE INDEXORD 1  ;
                        FIELDS 'cCisSklad,'   + ;
                               'cSklPol,'     + ;
                               'cNazZbo::45,' + ;
                               'nCenaSZbo,'   + ;
                               'nCenMatMJP:Pøímý mat. z kalk.'  ;
                        SCROLL 'ny' CURSORMODE 3 PP 7 ITEMMARKED 'ItemMarked' POPUPMENU 'y'
  ELSE
*    DRGACTION INTO drgFC CAPTION 'info ~Ceník'       EVENT 'SKL_CENZBOZ_INFO' TIPTEXT 'Informaèní karta skladové položky'
    DRGACTION INTO drgFC CAPTION '~Aktualizovat PC'  EVENT 'SavePCeny'        TIPTEXT 'Aktualizovat prodejní ceny '

    DRGDBROWSE INTO drgFC SIZE 104,24.9 FILE ::cFILE INDEXORD 1 ;
                        FIELDS 'cCisSklad,'   + ;
                               'cSklPol,'     + ;
                               'cNazZbo::45,' + ;
                               'nCenaP4Zbo,'  + ;
                               'nCenMzdVDP:Pøímé mzdy z kalk.'  ;
                        SCROLL 'ny' CURSORMODE 3 PP 7 ITEMMARKED 'ItemMarked' POPUPMENU 'y'
  ENDIF
RETURN drgFC

********************************************************************************
METHOD Bro_KalkToCen:itemMarked()
  IF ::cPrm = 'MAT'
    CenZBOZ->( dbGoTO( CenZBOZw->_nRecOr))
  ELSE
    CenProdC->( dbGoTO( CenPRODCw->_nRecOr))
    CenZBOZ->( dbSEEK( Upper( CenPRODC->cCisSklad) + Upper( CenPRODC->cSklPol),, 'CENIK03'))
  ENDIF
  dbSelectArea(::cFile)
RETURN self

********************************************************************************
METHOD Bro_KalkToCen:SavePreceneni()
  local  lok, x
  Local  aCen := {}, aIt := {}, nOrdItem := 0, nCount
  *
  local  pa
   *
  local  nreccnt, nkeycnt, nkeyno
  local  nSize     := ::xbp_therm:currentSize()[1]
  local  nHight    := ::xbp_therm:currentSize()[2]


  pa := ::arSelected := {}

  drgDBMS:open( 'PVPHEAD' )
  drgDBMS:open( 'PVPITEM' )

  * vazba na sklady
  drgDBMS:open( 'pvpTerm'  )
  drgDBMS:open( 'objVyshd' )
  drgDBMS:open( 'objVysit' )
  drgDBMS:open( 'objHead'  )
  drgDBMS:open( 'objItem'  )


  * oznanèil vše
  if .not. cenZbozW->( eof())

    do case
    case ::drgDialog:dialogCtrl:oaBrowse:is_selAllRec
      CenZBOZw->( dbeval( { || ( AADD( aCen, CenZBOZw->_nRecOr)   , ;
                                 aadd( pa  , cenZbozW->( recNo()))  ) }) )

    case len(::drgDialog:dialogCtrl:oaBrowse:arSelect) <> 0
      ::arSelected := ::drgDialog:dialogCtrl:oaBrowse:arSelect

      FOR x := 1 TO LEN( ::arSelected) step 1
        CenZBOZw->( dbGoTo( ::arSelected[ x] ))
        AADD( aCen, CenZBOZw->_nRecOr)
      NEXT

    otherwise

      aadd( pa  , cenZbozW->( recNo()) )
      AADD( aCen, CenZBOZw->_nRecOr    )
    endcase
  endif

  *
  IF Len(aCen) = 0
    drgMsgBox(drgNLS:msg( 'Nebyly nalezeny (oznaèeny) položky k pøecenìní !'))

  ELSEIF CenZBOZ->( sx_RLock( aCen))
    cenZboz->( dbCommit(), dbUnlock() )

    nkeycnt := len( acen )
    nkeyno  := 1
    nstep   := 0

    if drgIsYesNO(drgNLS:msg('Uložit navržený doklad o pøecenìní ?'))

      skl_pvpHead_cpy(self)

      for x := 1 to len(acen) step 1
        cenZboz ->( dbgoTo( aCen[x]        ))
        cenZbozW->( dbgoTo( ::arSelected[x]))

        mh_copyFld( 'cenZboz' , 'pvpitemWW', .t. )
        mh_copyFld( 'pvpHeadW', 'pvpitemWW'      )

        nordItem++
        pvpitemWW->nordItem := nordItem
        pvpitemWW->ddatPVP  := date()
        pvpitemWW->ccasPVP  := time()
        pvpitemWW->ntypPoh  := pvpheadW->ntypPohyb
        pvpitemWW->nKALKUL  := cenZbozW->nKALKUL

        * Pùvodní cena skladová je zapsána do významovì jiné položky !!!
        pvpItemWW->ncelkSlev  :=  cenZboz  ->ncenaSzbo                            // Pùvodní cena skladová

        pvpItemWW->nmnozPRdod :=  cenZboz  ->nmnozSzbo
        pvpItemWW->ncenNAPdod :=  cenZbozW ->ncenMatMJP                           // Nová cena skladová
//        pvpItemWW->ncenaCzbo  :=  pvpItemWW->ncenNAPdod * pvpItemWW->nmnozPRdod
        pvpItemWW->ncenaCzbo  := cenZboz  ->ncenaCzbo
//        pvpItemWW->ncenaCelk  := (pvpItemWW->ncenNAPdod - cenZboz  ->ncenaSzbo) * pvpItemWW->nmnozPRdod
        pvpItemWW->ncenaCelk  := (pvpItemWW->ncenNAPdod * pvpItemWW->nmnozPRdod) - pvpItemWW->ncenaCzbo

        nkeyNo++
        vyr_kalktocen_pb(::xbp_therm, nkeyCnt, nkeyNo, nsize, nhight)
      next

      vyr_kalktocen_inf(::xbp_therm,' ', nSize, nHight)

      skl_pvphead_wrt_inTrans(self)

      pvpHeadw  ->(dbclosearea())
      pvpItemww ->(dbclosearea())

      drgMsgBox(drgNLS:msg( 'Doklad  [ & ] o pøecenìní byl vygenerován !', pvpHead->ndoklad))
      *
      pa := ::arSelected
      aeval( pa, { |x| cenZbozW->( dbgoTo(x), dbDelete()) } )
      cenZbozW->( dbgoTop())

      ( ::oDBro_main:arSelect := {}, ::oDBro_main:is_selAllRec := .f. )
      ::oDBro_main:refresh()

      if cenZbozW->( eof())
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      endif

    endif

** konec šmytec **
  ENDIF
RETURN self

********************************************************************************
METHOD Bro_KalkToCen:SavePCeny()
  Local aCen := {}

  CenPRODCw->( dbGoTOP() ,;
               dbEVAL( {|| AADD( aCen, CenPRODCw->_nRecOr) } ) )
  IF CenPRODC->( sx_RLock( aCen))

    IF drgIsYesNO(drgNLS:msg('Uložit prodejní ceny z kalkulací do ceníku prodejních cen ?'))
      CenPRODCw->( dbGoTOP())
      DO WHILE !CenPRODCw->( Eof())
        CenPRODC->( dbGoTO( CenPRODCw->_nRecOr))
        CenPRODC->nCenaP4Zbo := CenPRODCw->nCenMzdVDP
        CenPRODCw->( dbSkip())
      ENDDO
      CenPRODC->( dbUnlock())
    ENDIF
  ELSE

  ENDIF

RETURN self

*
** PROGRESS BAR zpracování *****************************************************
static function vyr_kalktocen_pb(oxbp, nkeyCnt, nkeyNo, nsize, nhight)
  local  charInf
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  GraGradient( ops               , ;
               { 2,2 }           , ;
               { {newPos, nhight}}, ;
               GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

  if newPos < (nSize/2) -20
    GraGradient( ops                , ;
                 { newPos+1,2 }, ;
                 { { nsize -newPos, nhight }}, ;
                 {0,15,0}, GRA_GRADIENT_HORIZONTAL)
  endif

  GraStringAt( oPS, {(nSize/2) -20,6}, prc)
  oXbp:unlockPS(oPS)
return .t.



function vyr_kalktocen_inf(oXbp, ctext, nsize, nhight)
  local  oPS, oFont, aAttr, nwidth

  if .not. empty(oPS := oXbp:lockPS())
    GraGradient( ops               , ;
                 { 2,2 }           , ;
                 { {nsize, nhight}}, ;
                 {0,15,0}, GRA_GRADIENT_HORIZONTAL)


    oFont := XbpFont():new():create( "9.Arial CE" )
    aAttr := ARRAY( GRA_AS_COUNT )

    nwidth := oFont:width

    GraSetFont( oPS, oFont )

    aAttr [ GRA_AS_COLOR     ] := GRA_CLR_RED
    GraSetAttrString( oPS, aAttr )
    GraStringAt( oPS, {(nSize/2) -(len(ctext) * nwidth)/2,4}, ctext)
    oXbp:unlockPS(oPS)
  endif
return .t.