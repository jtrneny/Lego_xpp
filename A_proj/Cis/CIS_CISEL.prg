#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Xbp.ch"

#include "..\Asystem++\Asystem++.ch"



*  Základní tøída pro èíselníky
********************************************************************************
CLASS Cis_BaseClass FROM drgUsrClass
EXPORTED:
  VAR    lSearch, oVar, tabNum
  METHOD init, drgDialogInit, drgDialogStart, eventHandled, tabSelect//, getform

  * pro c_typmaj
  inline access assign method isEv_pozemky() var isEv_pozemky
    return if( c_typMaj->lpozemky, 300, 0)


  * pro c_carKod
  inline access assign method isMain_ean() var isMain_ean
    return if( c_carKod->lisMain, 300, 0)


  inline method save_c_carKod( inSave, isAppend)
    local  dm      := ::dataManager             // dataManager
    local  lisMain := dm:get( 'c_carKod->lisMain' )
    *
    local oStatement, cStatement := 'update c_carKod set lisMain = .f.'

    if inSave .and. lisMain
      oStatement := AdsStatement():New(cStatement,oSession_data)

      if oStatement:LastError > 0
*        return .f.
      else
        oStatement:Execute( 'test', .f. )
      endif

      oStatement:Close()
    endif
  return .t.

  *
  ** pro uložení c_katZbo
  inline method save_c_katZbo( inSave, isAppend)
    local  dm        := ::dataManager             // dataManager
    local  o_drgVar  := dm:has( 'c_katZbo->crozPoradi' )
    local  initValue := o_drgVar:initValue, value := o_drgVar:value
    *
    local  oStatement, cStatement
    local  stmt := "update cenZboz set crozPoradi = '%value' where (nzboziKat = %nkat and " + ;
                   if( empty(initValue), "( crozPoradi = '' or crozPoradi is null))",  "crozPoradi = '%croz')"       )


    if inSave .and. ( initValue <> value )
      cStatement := strTran( stmt      , '%value', value                    )
      cStatement := strTran( cStatement, '%nkat' , str(c_katZbo->nzboziKat) )

      if .not. empty(initValue)
        cStatement := strTran( cStatement, '%croz' , initValue              )
      endif

      oStatement := AdsStatement():New(cStatement, oSession_data)

      if oStatement:LastError > 0
        *  return .f.
      else
        oStatement:Execute( 'test', .f. )
      endif

      oStatement:Close()
    endif
  return .t.


  * pro c_skuMis výdejna náøadí
  inline access assign method is_vydejNar() var is_vydejnar
    return if( c_skuMis->lvydejNar, 565, 0 )


  inline access assign method is_vyrZak_U() var is_vyrZak_U
   local  retVal := 0

   if( select('vyrZak') = 0, drgDBMS:open('vyrZak'), nil )
   if vyrZak->( dbseek( upper(cnazpol3->cnazPol3),,'CNAZPOL1'))
     retVal := if( vyrZak->cstavZakaz = 'U', MIS_ICON_ERR, 0 )
   endif
   return retVal

HIDDEN:
  var    drgGet, file, citem, recNo, srchReturn

ENDCLASS

********************************************************************************
METHOD Cis_BaseClass:init(parent)
  Local nEvent,mp1,mp2,oXbp
  local srchDBD, srchDEF, rOrd := 1

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))
  *
  ::drgUsrClass:init(parent)
  ::oVar := parent:cargo
  IF( ::lSearch := ::oVar <> NIL )
    ::file  := (::drgDialog:initParam)
    if( empty(::oVar) .or. (::file)->(eof()), (::file)->( dbGoTOP()), NIL )
    ::recNo := (::file)->( recNo())

    srchDBD      := drgDBMS:getDBD(::file)

    * na c_Dph jsou dvì SEARCH nastavení, pro nKlicDph/1 a nprocDph/2
    * moc se to nepožívá asi jen u c_DPH/ c_banky/ c_staty/ c_okresy.3/
    *
    if( lower(::file) = 'c_dph' .and. isObject(::drgGet) )
      rOrd  := IsNull(::drgGet:arRelate[1,3],1)
    endif

    srchDEF      := srchDBD:srchDEF[rOrd]
    ::citem      := srchDEF:srchReturn
    ::srchReturn := ::file +'->' +srchDEF:srchReturn
  ENDIF
RETURN self


********************************************************************************
METHOD Cis_BaseClass:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += IF( ::lSearch, ' - VÝBÌR ...', '' )
RETURN

********************************************************************************
METHOD Cis_BaseClass:drgDialogStart(drgDialog)
  Local aPP := drgPP:getPP(2), oColumn, x
  Local oBro := ::drgDialog:dialogCtrl:oBrowse

  IF ::lSearch
     FOR x := 1 TO oBro:oXbp:colcount
        ocolumn := oBro:oXbp:getColumn(x)
        ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
        ocolumn:configure()
      NEXT
      oBro:oXbp:refreshAll()
      (::file)->( dbGoTo( ::recNo))
  ENDIF
RETURN

********************************************************************************
METHOD Cis_BaseClass:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit, cfile, citem

  DO CASE
  CASE nEvent = drgEVENT_EDIT
    IF   ::lSearch
      if isObject(::drgGet)
         cfile := ::file  // oxbp:cargo:cfile *** err zmáènke na lištì EDIT oxbp ... abpToolBar
         citem := ::citem // drgParseSecond(::drgGet:name,'>')
         *
         **
         if( lower(cfile) = 'c_dph' .and. lower(citem) = 'nprocdphpp')
           citem := 'nprocdph'
         endif

         IF (cfile)->( FieldPos( citem)) = 0
           ::drgDialog:cargo := &(::srchReturn)  // &(oXbp:cargo:arDef[1,2])
         ELSE
           ::drgDialog:cargo := &(cfile + '->' + citem)
         ENDIF
      else
        ::drgDialog:cargo := &(::srchReturn)     // &(oXbp:cargo:arDef[1,2])
      endif
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)
    ELSE
      RETURN .F.
    ENDIF

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ENTER
      IF oXbp:ClassName() = 'xbpGet'
        RETURN .F.
      ELSE
        IF   ::lSearch
          ::drgDialog:cargo := &(::srchReturn)     // &(::drgDialog:odBrowse[1]:arDef[1,2])  //
          PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)
        ELSE
          RETURN .F.
        ENDIF
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE

  CASE nEvent = drgEVENT_FORMDRAWN
    Return ::lSearch

  case(nevent = drgEVENT_MSG)
    if mp2 = DRG_MSG_ERROR
      _clearEventLoop()
       SetAppFocus(::drgDialog:dialogCtrl:oBrowse:oXbp)
       return .t.
    endif
    return .f.

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD Cis_BaseClass:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
RETURN .T.

*===============================================================================

* Systémové
CLASS C_TASK     FROM Cis_BaseClass
ENDCLASS
CLASS C_TYPDOK   FROM Cis_BaseClass
ENDCLASS
CLASS C_PRIPOM   FROM Cis_BaseClass
ENDCLASS

* Podnikové
CLASS C_DPH      FROM Cis_BaseClass
ENDCLASS
CLASS C_PSC      FROM Cis_BaseClass
ENDCLASS
*CLASS C_TYPPOH   FROM Cis_BaseClass
*ENDCLASS
CLASS C_ZAOKR    FROM Cis_BaseClass
ENDCLASS
*CLASS C_JEDNOT   FROM Cis_BaseClass  ;      ENDCLASS

CLASS C_MENY     FROM Cis_BaseClass
ENDCLASS

CLASS C_TYPSKP   FROM Cis_BaseClass
ENDCLASS
CLASS C_ZAMEST   FROM Cis_BaseClass
ENDCLASS
CLASS C_CELSAZ   FROM Cis_BaseClass
ENDCLASS
CLASS C_ODPMIS   FROM Cis_BaseClass
ENDCLASS
CLASS C_SKUMIS   FROM Cis_BaseClass
ENDCLASS


* Nákladové
CLASS C_NAKLST   FROM Cis_BaseClass
ENDCLASS
CLASS CNAZPOL1  FROM Cis_BaseClass
ENDCLASS
CLASS CNAZPOL2  FROM Cis_BaseClass
ENDCLASS
CLASS CNAZPOL3  FROM Cis_BaseClass
ENDCLASS
CLASS CNAZPOL4  FROM Cis_BaseClass
ENDCLASS
CLASS CNAZPOL5  FROM Cis_BaseClass
ENDCLASS
CLASS CNAZPOL6  FROM Cis_BaseClass
ENDCLASS

* Sklady
*CLASS C_SKLADY   FROM Cis_BaseClass  ;      ENDCLASS
CLASS C_DRPOHY   FROM Cis_BaseClass
ENDCLASS
* CLASS C_NAZZBO  FROM Cis_BaseClass  ;      ENDCLASS
CLASS C_KATZBO   FROM Cis_BaseClass
ENDCLASS
CLASS C_UCTSKP   FROM Cis_BaseClass
ENDCLASS
*CLASS C_ULOZMI   FROM Cis_BaseClass  ;      ENDCLASS
CLASS C_CARKOD   FROM Cis_BaseClass
ENDCLASS
CLASS C_TYPKAR   FROM Cis_BaseClass
ENDCLASS
CLASS C_KOEFMN   FROM Cis_BaseClass
ENDCLASS

* Výroba  - TPV
CLASS C_STRED    FROM Cis_BaseClass
ENDCLASS
CLASS C_TYPPOL   FROM Cis_BaseClass
ENDCLASS
CLASS C_SKUPOL   FROM Cis_BaseClass
ENDCLASS
CLASS C_TYPMAT   FROM Cis_BaseClass
ENDCLASS
CLASS C_MATPOL   FROM Cis_BaseClass
ENDCLASS
CLASS C_TYPOP    FROM Cis_BaseClass
ENDCLASS
CLASS C_ATRIB    FROM Cis_BaseClass
ENDCLASS
CLASS C_TARIF    FROM Cis_BaseClass
ENDCLASS
CLASS C_KOEF     FROM Cis_BaseClass
ENDCLASS
CLASS C_ALGREZ   FROM Cis_BaseClass
ENDCLASS
CLASS C_TYPVYKR  FROM Cis_BaseClass
ENDCLASS


* Výroba  - RV
CLASS C_TYPZAK   FROM Cis_BaseClass
ENDCLASS
CLASS C_TYPLIS   FROM Cis_BaseClass
ENDCLASS
CLASS C_PRIPL    FROM Cis_BaseClass
ENDCLASS

* Opravy a Emise
CLASS C_OPRAVY   FROM Cis_BaseClass
ENDCLASS
CLASS C_STROJE   FROM Cis_BaseClass
ENDCLASS
CLASS C_OPACIM   FROM Cis_BaseClass
ENDCLASS
CLASS C_DALPRO   FROM Cis_BaseClass
ENDCLASS
CLASS C_VOZTYP   FROM Cis_BaseClass
ENDCLASS
CLASS C_VOZDR    FROM Cis_BaseClass
ENDCLASS
CLASS C_VOZKAT   FROM Cis_BaseClass
ENDCLASS

* HIM
CLASS C_TYPMAJ   FROM Cis_BaseClass
ENDCLASS
CLASS C_DANSKP   FROM Cis_BaseClass
ENDCLASS
CLASS C_UCETSKP   FROM Cis_BaseClass
ENDCLASS
CLASS C_DRPOHI   FROM Cis_BaseClass
ENDCLASS
CLASS C_AKTIV    FROM Cis_BaseClass
ENDCLASS
CLASS C_AKTIVD   FROM Cis_BaseClass
ENDCLASS
CLASS C_TYPKAI   FROM Cis_BaseClass
ENDCLASS
CLASS C_KLASSD   FROM Cis_BaseClass
ENDCLASS
CLASS C_KATAST   FROM Cis_BaseClass
ENDCLASS
CLASS C_LISTVL   FROM Cis_BaseClass
ENDCLASS

* MZDY
CLASS C_vzdel    FROM Cis_BaseClass
ENDCLASS

* PER - personalistika
CLASS c_lekPro   FROM Cis_BaseClass
ENDCLASS
CLASS c_lekari   FROM Cis_BaseClass
ENDCLASS

CLASS c_skolen   FROM Cis_BaseClass
ENDCLASS
CLASS c_skolit   FROM Cis_BaseClass
ENDCLASS

********************************************************************************
********************************************************************************
CLASS C_JEDNOT   FROM Cis_BaseClass
EXPORTED:
  METHOD Prepocty
ENDCLASS

METHOD C_JEDNOT:Prepocty()
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('C_PrepMJ,C_JEDNOT->cZkratJEDN', ::drgDialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState
  *
  oDialog:destroy(.T.)
  oDialog := Nil

RETURN self

********************************************************************************
CLASS C_PrepMJ FROM drgUsrClass
EXPORTED:
  VAR    cVychoziMJ, cItemMJ, cFileMJ

  METHOD  Init, drgDialogStart, drgDialogEnd, PostValidate, PreValidate
  method  ebro_beforeAppend   //, ebro_afterAppend, ebro_saveEditRow

  METHOD jednot_sel

  *
  ** BRO_column
  inline access assign method is_equal() var is_equal
    return 314


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  sid := isNull(c_prepmj->sid,0)
    local  cky := c_prepmj->cvychozimj +'->' +c_prepmj->ccilovamj +' _'

    do case
    case ( nEvent = drgEVENT_DELETE )

     if sid <> 0 .and. drgIsYesNo( 'Zrušit položku èíselníku _ ' +cky )

       if c_prepmj->(sx_Rlock())
         c_prepmj->(dbdelete(), dbcommit(), dbunlock())

         if( c_prepmj->( ads_GetRecordCount()) = 0, c_prepmj->(dbgoTop()), nil )
         ::drgDialog:dialogCtrl:refreshPostDel()
       endif
     endif
     return .t.

    endcase
  return .f.


  inline method ebro_beforSaveEditRow()
    local  cky, ok := .t.
    local  isAppend  := ( ::oEBro:state = 2 .or. c_prepmj->(eof()))

    if isAppend
      if ::is_form_c_jednot
        cky := space(8) +space(15)
      else
        cky := upper( (::cFileMJ)->ccisSklad) +upper((::cFileMJ)->csklPol)
      endif

      cky += upper( ::dm:get('c_prepmj->cvychozimj')) + upper( ::dm:get('c_prepmj->ccilovamj'))

      if c_prepmjS->( dbseek( cky,,'C_PREPMJ02'))
        drgMsgBox(drgNLS:msg( 'Duplicitní pøevodní vztah !'))
        return .f.
      endif
    endif
  return ok


  inline method ebro_afterAppend()
    ::dm:set( 'c_prepmj->npocVYCHmj', 1 )
    ::dm:set( 'c_prepmj->npocCILmj' , 1 )

    if .not. ::is_form_c_jednot
      ::dm:set('c_prepmj->ccilovaMJ', cenZboz->czkratJedn)
    endif
  return self


  inline method ebro_saveEditRow()

    c_prepmj->npocVYCHmj := ::dm:get('c_prepmj->npocVYCHmj')
    c_prepmj->npocCILmj  := ::dm:get('c_prepmj->npocCILmj' )

    if .not. ::is_form_c_jednot
      c_prepmj->ccisSklad := (::cFileMJ)->ccisSklad
      c_prepmj->csklPol   := (::cFileMJ)->csklPol
    endif
  return self

HIDDEN:
  VAR    dc, dm, df, isAppend, nRec, oEBro
  var    is_form_c_jednot

  //                     C_JEDNOT
  //                     x
  var    get_nPocVychMJ, get_cVychoziMJ, get_cCilovaMJ, get_nPocCilMJ, get_nKoefPrVC
ENDCLASS

******
METHOD C_PrepMJ:init(parent)
  ::drgUsrClass:init(parent)
  ::isAppend := .F.
  *
  ::cItemMJ    := Upper(ALLTRIM( drgParseSecond( parent:initParam, ',' )))
  ::cFileMJ    := drgParse( ::cItemMJ, '->')
  ::cVychoziMJ := &(::cItemMJ)
  *
  drgDBMS:open('C_Jednot' )
  drgDBMS:open('c_prepmj',,,,, 'c_prepmjS' )
RETURN self

*
******
METHOD C_PrepMJ:drgDialogStart(drgDialog)
  Local Filter
  Local cCisSklad := ::cFileMJ + '->cCisSklad'
  Local cSklPol   := ::cFileMJ + '->cSklPol'

  ::dc    := drgDialog:dialogCtrl
  ::dm    := drgDialog:dataManager
  ::df    := drgDialog:oForm
  ::oEBro := drgDialog:dialogCtrl:obrowse[1]

  ::nRec := C_PrepMJ->( RecNO())

  IF 'C_JEDNOT' = ::cFileMJ
     ::is_form_c_jednot := .t.
     Filter := FORMAT("Upper(cVychoziMJ) = '%%' .and. cCisSklad  = ' ' .and.  cSklPol = ' ' ", { Upper( ::cVychoziMJ)} )
  ELSE
    ::is_form_c_jednot := .f.
    Filter := FORMAT( "cCisSklad  = '%%' .and.  cSklPol = '%%'", { &cCisSklad, &cSklPol } )
  ENDIF

  C_PrepMJ->( mh_SetFilter( Filter))
RETURN self

*
******
METHOD C_PrepMJ:drgDialogEnd(drgDialog)
  C_PrepMJ->( mh_ClrFilter())
RETURN self

* ok
method c_prepmj:preValidate(drgVar)
  local  value := drgVar:value
  local  name  := lower(drgVar:name)
  local  ok    := .t.


  do case
  case(name = 'c_prepmj->cvychozimj')
    if ::is_form_c_jednot
      drgVar:odrg:isEdit := .f.
*      ::dm:set('c_prepmj->cvychozimj', c_jednot->czkratJedn)
    endif

  case(name = 'c_prepmj->ccilovamj')
    if .not. ::is_form_c_jednot
      drgVar:odrg:isEdit := .not.( c_prepmj->(eof()) ) // .or. upper((::cfileMj)->czkratJedn) = upper(c_prepmj->ccilovamj) )
    endif

  endcase
return .t.


method c_prepmj:postValidate(drgvar)
  local  value       := drgVar:get()
  local  name        := Lower(drgVar:name)
  local  ok          := .T., changed := drgVAR:Changed()

  do case
  case empty(value)
*    drgMsgBox('Údaj je povinný ...')
*    return .f.

  case( name = 'c_prepmj->cvychozimj' .or. name = 'c_prepmj->ccilovamj')
    ok := ::jednot_sel()

  endcase
return ok


* ok
method c_prepmj:ebro_beforeAppend(o_eBro)
  local  cfile := lower(o_ebro:cfile), cky

  if ::is_form_c_jednot
    ::dm:set('c_prepmj->cvychozimj', c_jednot->czkratJedn)
  endif
return .t.


* ok
method c_prepmj:jednot_sel( oDlg, cName)
  local  drgVar := ::df:olastDrg:oVar
  local  name   := lower(drgvar:name)
  local  value  := drgVar:value
  local  arec   := {}, lok := .t.

  if( name = 'c_prepmj->cvychozimj' .or. name = 'c_prepmj->ccilovamj')

    if ::is_form_c_jednot
      fordRec({'c_jednot'})
    else
      *
      * Pokud poøizuje ke skladové položce, èíselník pro cílovou MJ omezit jen
      * na skladovou MJ a již definované vztahy !
      *
      if name = 'c_prepmj->ccilovamj'
        aREC := CiloveMJ( ::cFileMJ )
        mh_RyoFILTER( aREC, 'C_JEDNOT')
      endif
    endif

    lok := c_jednot->( dbseek( upper(value),, 'C_JEDNOT1' ))

    IF IsObject( oDlg) .or. !lOK
      *
      ret := drgCallSearch( ::drgDialog, 'C_JEDNOT', upper(value), '1' )

      IF  ( lOK := (ret <> nil ))
        ::dm:set( name, ret)
      ENDIF
      *
      IF name = 'c_prepmj->ccilovamj' .and. ::cFileMJ <> 'C_JEDNOT'
        C_Jednot->( ads_ClearAOF())
      ENDIF
    *
    ENDIF

    if(::is_form_c_jednot, fordRec(), nil )
  endif
RETURN lOK


*
*===============================================================================
function SKL_prepocetMj(npocVychMJ, cvychoziMJ, ccilovaMJ, cfromFILE )
  local  pocCILmj  := npocVYCHmj
  local  vychoziMj := upper(cvychoziMJ)
  local  cilovaMj  := upper(ccilovaMJ )
  *
  local  cky := upper((cfromFile)->ccisSklad) +upper((cfromFile)->csklPol)
  local  pa  := {}, x


  if vychoziMj = cilovaMj
    return pocCILmj
  endif

  if c_prepmj->( dbseek( cky +vychoziMj +cilovaMj,,'C_PREPMJ02'))
    pocCILmj := npocVYCHmj * (c_prepmj->npocCILmj * c_prepmj->nkoefPRvc )

  else
    c_prepmj->( ordSetFocus('C_PREPMJ02')                                                 , ;
                dbsetScope( SCOPE_BOTH, cky )                                             , ;
                dbgoTop()                                                                 , ;
                dbeval( { || aadd( pa, { upper(c_prepmj->cvychoziMj), ;
                                         upper(c_prepmj->ccilovaMj) , ;
                                         c_prepmj->npocCILmj * c_prepmj->nkoefPRvc } ) } ), ;
                                         dbclearScope()                                     )

    begin sequence
      for x := 1 to len(pa) step 1
        if pa[x,1] = vychoziMj .and. pa[x,2] = cilovaMj
          pocCILmj := pocCILmj * pa[x,3]
    break

        else

          vychoziMj := pa[x,1]
          pocCILmj  := pocCILmj * pa[x,3]
        endif
      next
    end sequence
  endif

return pocCILmj


FUNCTION PrepocetMJ( nPocVychMJ, cVychoziMJ, cCilovaMJ, cFromFILE )
  Local nPocCilMJ := nPocVychMJ
  Local cKey

  DEFAULT cFromFILE TO 'C_Jednot'

  drgDBMS:open('C_PrepMJ',,,,, 'C_PrepMJw' )
  *
// úprava JT
  if( Empty(cVychoziMJ), cVychoziMJ := cCilovaMJ, nil)

  IF cVychoziMJ = cCilovaMJ
    RETURN nPocCilMJ
  ENDIF
  * new
  cKey := Upper((cFromFILE)->cCisSklad) + Upper((cFromFILE)->cSklPol) + ;
          Upper( cVychoziMJ) + Upper( cCilovaMJ)   //  Upper( cVychoziMJ)
  IF C_PrepMJw->( dbSEEK( cKey,, AdsCtag(2) ))
    nPocCilMJ := nPocVychMJ * (C_PrepMJw->nPocCilMJ * C_PrepMJw->nKoefPrVC)
    RETURN nPocCilMJ
  ENDIF
  * Pokud nenajde vztah V->C, hledá opaèný vztah C->V a použije inverzní koeficient
  cKey := Upper((cFromFILE)->cCisSklad) + Upper((cFromFILE)->cSklPol) + ;
          Upper( cCilovaMJ) + Upper( cVychoziMJ)
  IF C_PrepMJw->( dbSEEK( cKey,,'C_PREPMJ02'))
    nPocCilMJ := nPocVychMJ * ( 1 / (C_PrepMJw->nPocCilMJ * C_PrepMJw->nKoefPrVC) )
    RETURN nPocCilMJ
  ENDIF
  *
  cKey := Upper( cVychoziMJ) + Upper( cCilovaMJ)
  IF C_PrepMJw->( dbSEEK( cKey,,'C_PREPMJ01'))
    nPocCilMJ := nPocVychMJ * (C_PrepMJw->nPocCilMJ *C_PrepMJw->nKoefPrVC)
  ENDIF

  /* old
  cKey := Upper((cFromFILE)->cCisSklad) + Upper((cFromFILE)->cSklPol) + ;
          Upper( cVychoziMJ) + Upper( cCilovaMJ)   //  Upper( cVychoziMJ)
  IF C_PrepMJw->( dbSEEK( cKey,, AdsCtag(2) ))
    nPocCilMJ := nPocVychMJ * C_PrepMJw->nKoefPrVC
  ELSE
    cKey := Upper( cVychoziMJ) + Upper( cCilovaMJ)
    IF C_PrepMJw->( dbSEEK( cKey,, AdsCtag(1) ))
      nPocCilMJ := nPocVychMJ * C_PrepMJw->nKoefPrVC
    ENDIF
  ENDIF
  */
RETURN nPocCilMJ

*===============================================================================
FUNCTION CiloveMJ( cFromFILE )
  Local aREC := {}, cKey

  drgDBMS:open('C_PrepMJ',,,,, 'C_PrepMJw' )
  C_PrepMJw->( AdsSetOrder( 2))
  cKey := Upper((cFromFILE)->cCisSklad) + Upper((cFromFILE)->cSklPol)
  C_PrepMJw->( mh_SetScope( cKey))

  IF C_Jednot->( dbSEEK( Upper((cFromFile)->cZkratJedn),, 'C_JEDNOT1'))
    AADD( aREC, C_Jednot->( RecNO()))
  ENDIF

  DO WHILE !C_PrepMJw->( EOF())
    IF C_Jednot->( dbSEEK( Upper( C_PrepMJw->cVychoziMJ),, 'C_JEDNOT1' ))
      AADD( aREC, C_Jednot->( RecNO()))
    ENDIF
    C_PrepMJw->( dbSKIP())
  ENDDO
  C_PrepMJw->( dbCloseArea())
RETURN aREC