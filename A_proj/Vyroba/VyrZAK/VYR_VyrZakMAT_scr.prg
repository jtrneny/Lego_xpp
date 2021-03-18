/*==============================================================================
  VYR_VyrZakMAT_scr.PRG
  Materiálové požadavky na zakázku
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
* SCR - Materiálové požadavky na zakázku
********************************************************************************
CLASS VYR_VyrZakMAT_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:

  METHOD  Init, drgDialogStart, eventHandled
  METHOD  ItemMarked

  METHOD  ZAK_MATERIAL        //  tl. Materiál
  METHOD  ZAK_PLANSKUT        //  tl. Plán vs. skut.
  METHOD  ZAK_MATERIAL_DEL    //  tl. Zrušit materiál

  inline access assign method cnazevStat() var cnazevStat
    c_staty->(dbSeek( upper( firmy->czkratStat),,'C_STATY1'))
    return c_staty->cnazevStat

hidden:
   var odBro_vyrZak
   var oBtn_zak_material, oBtn_zak_planSkut, oBtn_zak_material_del
ENDCLASS

*
********************************************************************************
METHOD VYR_VyrZakMAT_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('firmy'  )
  drgDBMS:open('c_staty')
  firmy  ->( dbseek( MyFIRMA,,'FIRMY1'))

  drgDBMS:open('objhead')
  drgDBMS:open('cenZboz')
  drgDBMS:open('kusov'  )

  drgDBMS:open('vyrPol' )
RETURN self


method VYR_VyrZakMAT_SCR:drgDialogStart(drgDialog)
  local  members := drgDialog:oActionBar:members, x, className
  *
  local  odesc, pa, pa_it := {},  pa_quick := {{ 'Kompletní seznam         ', ''                  }, ;
                                               { '(<>U) _neUkonèené zakázky', "cstavZakaz <> 'U'" }, ;
                                               { ''                         , ''                  }  }

  ::odBro_vyrZak := drgDialog:odBrowse[1]

  for x := 1 to len(members) step 1
    className := members[x]:ClassName()

    do case
    case className = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case lower(members[x]:event) = 'zak_material'     ;  ::oBtn_zak_material     := members[x]
        case lower(members[x]:event) = 'zak_planskut'     ;  ::oBtn_zak_planSkut     := members[x]
        case lower(members[x]:event) = 'zak_material_del' ;  ::oBtn_zak_material_del := members[x]
        endcase
      endif
    endcase
  next

  * quick stav zakázky
  if isObject( odesc := drgRef:getRef( 'cstavZakaz' ))
    pa := listAsArray( odesc:values )

    aeval( pa, {|x| ( pb := listAsArray(x, ':'), aadd( pa_it, {allTrim(pb[1]) +' ', '(' +allTrim(pb[1]) +') _' +pb[2]} ) ) } )
  endif
  aeval( pa_it, { |x| aadd( pa_quick, { x[2], format( "cstavZakaz = '%%'", {x[1]} ) } ) })
  ::quickFiltrs:init( self, pa_quick, 'stavZakázky' )
return self


METHOD VYR_VyrZakMAT_SCR:EventHandled( nEvent, mp1, mp2, oXbp)
  DO CASE
  CASE nEvent = drgEVENT_DELETE
  OTHERWISE

    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_VyrZakMAT_SCR:ItemMarked()
  local  cisZakaz := upper(vyrZak->ccisZakaz)
  local  sid
  *
  local  cfiltr, mky
  local  cflt     := "nextObj = 0 .and. ncisFirmy = %% .and. ccisZakaz = '%%'"

  cfiltr := format( cflt, { myFirma, vyrZak->ccisZakaz } )
  objhead->( ads_setAof(cfiltr), dbgoTop() )

  mky     := upper(objhead->ccislobint)
  objitem->( ordSetFocus('OBJITEM2'), dbsetScope( SCOPE_BOTH, mky), DbGoTop())
  vyrPol ->( dbsetscope(SCOPE_BOTH, cisZakaz),dbgotop())

/*
  objhead->( dbseek( strZero(MyFIRMA,5) +cisZakaz,, 'OBJHEAD1') )
  objitem->( mh_SetScope( Upper(VYRZAK->cCisZakaz)) )
  vyrPol ->( dbsetscope(SCOPE_BOTH, cisZakaz),dbgotop())
*/

  sid := isNull(objitem->sid, 0)

  if sid = 0
    ::oBtn_zak_material:oxbp:disable()
    ::oBtn_zak_planSkut:oxbp:disable()
    ::oBtn_zak_material_del:oxbp:disable()
  else
    ::oBtn_zak_material:oxbp:enable()
    ::oBtn_zak_planSkut:oxbp:enable()
    ::oBtn_zak_material_del:oxbp:enable()
  endif
RETURN SELF


* možnost modifikace objitem /materiálových požadavkù/
********************************************************************************
METHOD VYR_VyrZakMAT_SCR:ZAK_MATERIAL()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VZakMAT_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
  *
  ObjITEM->( AdsSetOrder(9), dbGoTOP() )
  SetAppFocus(::drgDialog:dialogCtrl:oBrowse[1]:oXbp)
  ::drgDialog:dialogCtrl:oBrowse[2]:oXbp:refreshAll()
RETURN self


* pohled plán skuteènost objitem - pvpitem /výdejky/
********************************************************************************
METHOD VYR_VyrZakMAT_SCR:ZAK_PLANSKUT()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VZakPLSK_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

  ObjITEM->( AdsSetOrder(9), dbGoTOP() )
  SetAppFocus(::drgDialog:dialogCtrl:oBrowse[1]:oXbp)
  ::drgDialog:dialogCtrl:oBrowse[2]:oXbp:refreshAll()
RETURN self


* Zruší všechny materiálové požadavky ( obj.pøijaté) na zakázku
********************************************************************************
METHOD VYR_VyrZakMAT_SCR:ZAK_MATERIAL_DEL()
  local  cKey, nsel
  local  anObi := {}, anCen := {}, anKus := {}

  objitem->(dbgoTop())
  do while .not. objitem->( eof())
    aadd( anObi, objitem->( recNo()) )

    cKey := upper(objitem->ccisSklad) +upper(objitem->csklPol)
    cenZboz->( dbSeek( cKey,,'CENIK03'))
    aadd( anCen, cenZboz->( recNo()) )

    cKey := upper(objitem->ccislOBint) +strZero(objitem->ncislPOLob,5)
    if kusov->( dbSeek( cKey,,'KUSOV5'))
      aadd( anKus, kusov->( recNo()) )
    endif

    objitem->( dbskip())
  enddo

  nsel := ConfirmBox( ,'Požadujete zrušit materiálové požadavky na zakázku ...' +CRLF +CRLF+ padc( '_ ' +alltrim(vyrZak->ccisZakaz) +' _',53) , ;
                       'Zrušení materálových požadavkù ...' , ;
                        XBPMB_YESNO                         , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

  if nsel = XBPMB_RET_YES
    if objitem->( sx_rLock(anObi)) .and. ;
       cenZboz->( sx_rLock(anCen)) .and. ;
       kusov  ->( sx_rLock(anKus)) .and. ;
       objhead->( sx_rLock())

       objitem->( dbgoTop())
       do while .not. objitem->( eof())
         VYR_CenZboz_MODI( drgEVENT_DELETE, .T.)
         VYR_Kusov_MODI()
         DelREC( 'ObjITEM')

         objitem->( dbskip())
       enddo
       DelREC( 'ObjHead')

       ::odBro_vyrZak:oxbp:refreshAll()
       PostAppEvent(xbeBRW_ItemMarked,,,::odBro_vyrZak:oxbp)
       SetAppFocus(::odBro_vyrZak:oXbp)

    else
      ConfirmBox( ,'Materiálové požadavky na zakázku _' +alltrim(vyrZak->ccisZakaz) +'_' +' nelze zrušit ...', ;
                   'Zrušení materálových požadavkù (blokováno jiným uživatem) ...' , ;
                   XBPMB_CANCEL                    , ;
                   XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

      objhead->(dbunlock(),dbcommit())
      objitem->(dbunlock(),dbcommit())
      cenzboz->(dbunlock(),dbcommit())
      kusov  ->(dbunlock(),dbcommit())
    endif
  endif
RETURN self



* materiálové požadavky pro zakázku objitem
********************************************************************************
CLASS VYR_VZakMAT_SCR FROM drgUsrClass
EXPORTED:
  VAR     SklCena_MJ, SklCena_CELK
  var     lno_mnozOBodb_0

  METHOD  Init, drgDialogStart, drgDialogEnd, EventHandled, ItemMarked
  METHOD  PostValidate, PostLastField

  METHOD  VYR_VYRPOL_SEL, SKL_CENZBOZ_SEL


  inline method CheckItemSelected( CheckBox)
    local name := drgParseSecond( CheckBox:oVar:Name,'>')
    local s_filter

    self:&Name := CheckBox:Value

    s_filter := ::m_filter +if( ::lno_mnozOBodb_0, " and nmnozOBodb <> 0", "" )
    objitem->( ads_setAof(s_filter), dbgoTop())

    PostAppEvent(drgEVENT_OBJEXIT,,, checkBox:oXbp)

    ::oDbro_objitem:oxbp:goTop():refreshAll()
    ::df:setNextFocus( ::oDBro_objitem )
  return self

  Inline METHOD  post_bro_selectall( oBr)
    Local nRec := ObjItem->( RecNo())

    ObjItem->( dbGoTop())
    DO WHILE !ObjItem->( Eof())
      aAdd( oBr:arselect, ObjItem->(RecNo())  )
      ObjItem->( dbSkip())
    ENDDO
    ObjItem->( dbGoTo( nRec))
  RETURN nil

  Inline Access Assign  METHOD NazVyrPOL() VAR  NazVyrPOL
    Local cKEY := Upper( VyrZak->cCisZakaz) + Upper( ObjItem->cVyrPol) + ;
                  StrZero( ObjItem->nVarCis, 3)
    VyrPol->( dbSeek( cKey,,'VYRPOL1'))
  RETURN VyrPOL->cNazev


HIDDEN
  VAR   dm, dc, df, oDbro_objitem
  VAR   nCislPolOb, m_filter
ENDCLASS


METHOD VYR_VZakMAT_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::lno_mnozOBodb_0 := .t.
  *
  drgDBMS:open('VyrPOL'   ) ; AdsSetOrder(1)
  drgDBMS:open('CenZboz'  )
*  drgDBMS:open('Kusov'    )
  drgDBMS:open('ObjHEAD'  ) ; AdsSetOrder(2)
  *
RETURN self


METHOD VYR_VZakMAT_SCR:drgDialogStart(drgDialog)
  local  x, members  := drgDialog:oForm:aMembers
  local  s_filter

  ::dm := drgDialog:dataManager
  ::dc := drgDialog:dialogCtrl
  ::df := drgDialog:oForm                   // form
  *
  ColorOfTEXT( ::dc:members[1]:aMembers)
  *
  objhead->( dbseek( strZero(MyFIRMA,5) +upper(vyrZak->ccisZakaz),, 'OBJHEAD1') )
  ::m_filter := FORMAT("cCisZakaz = '%%'", { VyrZAK->cCisZakaz } )

  s_filter := ::m_filter +if( ::lno_mnozOBodb_0, " and nmnozOBodb <> 0", "" )
  objitem->( ads_setAof(s_filter), dbgoTop())

  VYRPOL ->( mh_SetScope( Upper(VYRZAK->cCisZakaz)) )
  *
  IsEditGET( {'OBJITEM->nVarCis'    ,;
              'OBJITEM->nMnPotVyr'} ,  drgDialog, .F. )
  *
  ::dc:isAppend := .f.
  ::SklCena_CELK := ObjItem->nCenNapDod * ObjItem->nMnozPoOdb
  *

  BEGIN SEQUENCE
    FOR x := 1 TO LEN(members)
      IF members[x]:ClassName() = 'drgDBrowse'
        ::oDbro_objitem := members[x]
  BREAK
      ENDIF
    NEXT
  ENDSEQUENCE

  drgDialog:oForm:nextFocus := x

  ::dc:oBrowse[1]:oXbp:refreshAll()
  ::dm:refresh()
RETURN SELF

*
********************************************************************************
METHOD VYR_VZakMAT_SCR:drgDialogEnd( drgDialog)
  local  nkey_count

  objitem->( dbgoTop())
  nkey_count := objitem->( ads_getKeyCount(1))

  * Po ukonèení dialogu se aktualizuje hlavièka obj.pøijaté
  if( nkey_count <> 0, VYR_ObjHEAD_Modi(), nil )
  *
  VYRPOL->( mh_ClrScope())
  ObjITEM->( mh_ClrFilter())
RETURN

*
********************************************************************************
METHOD VYR_VZakMAT_SCR:EventHandled( nEvent, mp1, mp2, oXbp)
  LOCAL  nRecNo, lOK
  local  nkey_count, mainOk

  DO CASE
    CASE nEvent = drgEVENT_APPEND
      ::dc:isAppend := .T.
      nRecNo := OBJITEM ->( RecNo())
      OBJITEM ->( DbGoTo(-1))
      ::dm:refresh()
      OBJITEM->( DbGoTo(nRecNo))
      *
      ::dm:set( 'ObjITEM->dDatDoOdb' , DATE() )
      ::dm:set( 'ObjITEM->nMnKalkul' , 1      )
      ::dm:set( 'ObjITEM->nMnozObOdb', 1      )
      ::nCislPolOb := VYR_NewCisObjITEM()
      *
      IsEditGET( {'OBJITEM->cSklPOL'}, ::drgDialog, .T. )
      ::drgDialog:oForm:setNextFocus('ObjITEM->cSklPOL',, .T. )
      RETURN .T.

    CASE nEvent = drgEVENT_EDIT
      ::dc:isAppend := .F.
      IsEditGET( {'OBJITEM->cSklPOL'}, ::drgDialog, .F. )
      ::drgDialog:oForm:setNextFocus('ObjITEM->dDatDoOdb',, .T. )
      ::nCislPolOb := ObjITEM->nCislPolOb
      RETURN .T.

** NEw
    case( nevent = drgEVENT_DELETE )
      nkey_count := objitem->( ads_getKeyCount(1))

      do case
      case nkey_count = 1              // rušíme poslední položku, zrušíme i hlavièku
        mainOk := (objitem->( sx_rlock()) .and. objhead->( sx_rlock()))
      otherwise
        mainOk := objitem->( sx_rlock())
      endcase

      if mainOk
        if drgIsYESNO(drgNLS:msg('Zrušit položku zakázky ?' ) )
          VYR_CenZboz_MODI( nEvent, .T. )
          VYR_Kusov_MODI()
          objitem->( dbDelete())

          ::dc:oaBrowse:oxbp:panHome()
          ::dc:oaBrowse:oXbp:refreshAll()
          ::dm:refresh()

          if nkey_count = 1
            objhead->( dbDelete())
            PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
          endif
        endif
      else
        drgMsgBox(drgNLS:msg('Nelze modifikovat ZAKÁZKU, blokováno uživatelem !!!'))
      endif

      objitem->(dbunlock(),dbcommit())
      objhead->(dbunlock(),dbcommit())
      return .t.

    CASE  nEvent = drgEVENT_SAVE
      IF( oXbp:ClassName() <> 'XbpBrowse')
        ::postLastField()
      ENDIF
      RETURN .T.

    CASE nEvent = xbeP_Keyboard
      IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
        IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
          oXbp:setColorBG( oXbp:cargo:clrFocus )
        ENDIF
        *
        SetAppFocus(::dc:oaBrowse:oXbp)
        ::dm:refresh()
        ::dc:isAppend := .F.
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    CASE nEvent = xbeM_LbClick
      IF oXbp:ClassName() = 'XbpGet' .and. oXbp:cargo:isEdit
        ::dc:isAppend := .F.
        ::nCislPolOb  := ObjITEM->nCislPolOb
*          PostAppEvent(drgEVENT_EDIT,,, oXbp)
      ENDIF
      RETURN .F.


    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_VZakMAT_SCR:postLastField()
  LOCAL lOK

  IF ::dm:changed()
    IF ( lOK := IF( ::dc:isAppend, AddREC('ObjITEM'), ReplREC('ObjITEM') ) )
      IF( .not. ::dc:isAppend, VYR_CenZboz_MODI( drgEVENT_EDIT, .T. ), Nil )
      ::dm:save()
      VYR_CenZboz_MODI( drgEVENT_APPEND, !::dc:isAppend  )
      If ::dc:isAppend
        ObjItem->cCislObInt  := VyrZak->cCisZakaz
        ObjItem->nCislPolOb  := ::nCislPolOb
        ObjItem->nCisFirmy   := 1  //MyFIRMA   // Firmy->nCisFirmy
        ObjItem->cCisZakaz   := VyrZak->cCisZakaz
        ObjItem->cNazZbo     := CenZboz->cNazZbo
        ObjItem->nKlicNaz    := CenZboz->nKlicNaz
        ObjItem->cSklPol     := CenZboz->cSklPol
        ObjItem->cPolCen     := CenZboz->cPolCen
        ObjItem->nZboziKat   := CenZboz->nZboziKat
        ObjItem->nKlicDph    := CenZboz->nKlicDph
        ObjItem->cCisSklad   := CenZboz->cCisSklad
        ObjItem->cZkratJedn  := CenZboz->cZkratJedn
        ObjItem->nUcetSkup   := CenZboz->nUcetSkup
        ObjItem->nRokRV      := YEAR( DATE())
        ObjItem->nPolObjRV   := VYR_PolObjRV()
      EndIf
      FOrdREC( { 'CenZBOZ, 3' } )
      IF !::dc:isAppend
        CenZBOZ->( dbSEEK( Upper( ObjITEM->cCisSklad) + Upper( ObjITEM->cSklPOL)) )
      ENDIF
      ObjItem->nMnozNeOdb  := ObjItem->nMnozObOdb - ObjItem->nMnozPoOdb
      ObjItem->nKcsBdObj   := ObjItem->nMnozObOdb *  CenZBOZ->nCenaSZBO // ObjItem->nCenProDod
      ObjItem->nKcsBdObj   += VYR_PrirazkaCMP( 'ObjItem->nKcsBdObj' )
      ObjItem->nKcsZdObj   := ObjItem->nMnozObOdb * ;
                             ( CenZboz->nCenaSZBO * ( 1 + ( SeekKodDph( CenZboz->nKlicDph) / 100)))
      FOrdREC()
      ObjITEM->( dbUnlock())
      *
      SetAppFocus(::dc:oaBrowse:oXbp)
      ::dc:oaBrowse:oXbp:refreshAll()
      ::dm:refresh()
      ::dc:isAppend := .F.
    Endif
  ENDIF
RETURN .T.

*
********************************************************************************
METHOD VYR_VZakMAT_SCR:ItemMarked()
  LOCAL cKEY := Upper( VyrZak->cCisZakaz) + Upper( ObjItem->cVyrPol) + ;
                StrZero( ObjItem->nVarCis, 3)

  VyrPol->( dbSeek( cKey))
  ::SklCena_CELK := ObjItem->nCenNapDod * ObjItem->nMnozPoOdb
  *
  CenZBOZ->( dbSEEK( Upper( ObjITEM->cCisSklad) + Upper( ObjITEM->cSklPol),, 'CENIK03') )
RETURN SELF
*
********************************************************************************
METHOD VYR_VZakMAT_SCR:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::dc:isAppend .or. lChanged ), lKeyFound
  LOCAL  cNAMe := UPPER(oVar:name)
  Local  nEvent := mp1 := mp2 := nil

  * F4
  nEvent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, lChanged := .t., nil)

  DO CASE
    CASE cName = 'ObjITEM->cSklPol'
      lKeyFound := CENZBOZ->(dbSEEK( Upper(xVar),,'CENIK01'))
      lOK := ::SKL_CENZBOZ_SEL( self, lKeyFound )

    CASE cName = 'ObjITEM->nMnKalkul'
      IF ( lOK := ControlDUE( oVar)) .AND. lValid
        ::dm:set( 'ObjITEM->nMnozObODB', xVar )
      ENDIF
    CASE cName = 'ObjITEM->nMnozObODB'
      lOK := ControlDUE( oVar)
    CASE cName = 'ObjITEM->nMnozPoODB'
      IF xVar > ::dm:get( 'ObjITEM->nMnozObODB')
        drgMsgBox(drgNLS:msg('Nelze potvrdit více než bylo objednáno !',, XBPMB_WARNING ))
        lOK := .F.
      ELSE
        ::dm:set( 'M->SklCena_CELK', xVar * CenZboz->nCenaSZbo )
      ENDIF
    CASE cName = 'ObjITEM->nMnozVpInt'
      If ( xVar + ::dm:get( 'ObjITEM->nMnozPoODB') > ::dm:get( 'ObjITEM->nMnozObODB') )
        drgMsgBox(drgNLS:msg('K výrobì + potvrzeno odbìratelem nemùže být vìtší než objednáno odbìratelem !',, XBPMB_WARNING ))
        lOk := .F.
      EndIf
    CASE cName = 'ObjITEM->cText2'
      If(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        ::postLastField()
      Endif

  ENDCASE
RETURN lOK

* Výbìr výrobní zakázky do karty objednávky pøijaté
********************************************************************************
METHOD VYR_VZakMAT_SCR:VYR_VYRPOL_SEL( Dialog, KeyFound)
  LOCAL oDialog, nExit, lOK := .F.

  DEFAULT KeyFound TO .F., lOK TO .F.
  IF !KeyFound
    DRGDIALOG FORM 'VYR_VYRPOL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. KeyFound )
    lOK := .T.
    ::dm:set( 'ObjITEM->cVyrPol', VYRPOL->cVyrPOL )
    ::dm:set( 'ObjITEM->nVarCis', VYRPOL->nVarCis )
  ENDIF
RETURN lOK

* Výbìr skladové položky do karty objednávky pøijaté
********************************************************************************
METHOD VYR_VZakMAT_SCR:SKL_CENZBOZ_SEL( Dialog, KeyFound)
  LOCAL oDialog, nExit, lOK := .F.

  DEFAULT KeyFound TO .F., lOK TO .F.
  IF !KeyFound
    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                     EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. KeyFound )
    lOK := .T.
    ::dm:set( 'ObjITEM->cSklPOL'   , CENZBOZ->cSklPol )
    ::dm:set( 'ObjITEM->cNazZBO'   , CENZBOZ->cNazZBO )
    ::dm:set( 'ObjITEM->nCenNapDod', CenZboz->nCenaSZbo )
    ::dm:set( 'M->SklCena_CELK'    , CenZboz->nCenaSZbo )
  ENDIF
RETURN lOK

* Modifikace Ceníku pøi editaci objednávky pøijaté
*===============================================================================
PROCEDURE VYR_CenZboz_MODI( nEvent, lSeekCenik )
  Local cKey

  IF( Used('CenZboz') , NIL, drgDBMS:open('CenZboz'  ))
  fOrdRec( { 'CenZboz, 3' } )
  If lSeekCenik
     cKey := Upper( ObjItem->cCisSklad) + Upper( ObjItem->cSklPol)
     CenZboz->( dbSeek( cKey))
  Endif

  If ReplREC( 'CenZboz')
    Do Case
      Case ( nEvent == drgEVENT_APPEND)
        Do Case
          Case ObjItem ->nMnozPoOdb <= CenZboz ->nMnozDZbo
            ObjItem->nMnozKoDod := 0
            ObjItem->nMnozReOdb := ObjItem->nMnozPoOdb
            CenZboz->nMnozRZbo  += ObjItem->nMnozReOdb
            CenZboz->nMnozRSES  += ObjItem->nMnozReOdb
            CenZboz->nMnozDZbo  -= ObjItem->nMnozReOdb

          Case CenZboz ->nMnozDZbo <= 0
            ObjItem->nMnozKoDod := ObjItem->nMnozPoOdb
            CenZboz->nMnozKZbo  += ObjItem->nMnozPoOdb

          Case ( ObjItem->nMnozPoOdb > CenZboz->nMnozDZbo ) .and. ;
               CenZboz->nMnozDZbo > 0
            ObjItem->nMnozKoDod := ObjItem->nMnozPoOdb -CenZboz->nMnozDZbo
            CenZboz->nMnozKZbo  += ObjItem->nMnozKoDod
            Objitem->nMnozReOdb := CenZboz->nMnozDZbo
            CenZboz->nMnozRZbo  += ObjItem->nMnozReOdb
            CenZboz->nMnozRSES  += ObjItem->nMnozReOdb
            CenZboz ->nMnozDZbo -= ObjItem->nMnozReOdb
        EndCase
        ObjItem->nMnozNeOdb := ObjItem->nMnozObOdb - ObjItem->nMnozPoOdb
        If( CenZboz->nMnozDZbo < 0, CenZboz->nMnozDZbo := 0, Nil )

      Case ( nEvent == drgEVENT_EDIT) .or. ( nEvent == drgEVENT_DELETE)
        CenZboz->nMnozRZbo -= ObjItem->nMnozReOdb
        CenZboz->nMnozRSES -= ObjItem->nMnozReOdb
        CenZboz->nMnozKZbo -= ObjItem->nMnozKoDod
        CenZboz->nMnozDZbo += MIN ( ObjItem->nMnozReOdb,;
                                    Cenzboz->nMnozSZbo - Cenzboz->nMnozRZbo )
        If( CenZboz->nMnozRZbo < 0, CenZboz->nMnozRZbo := 0, Nil )
        If( CenZboz->nMnozRSES < 0, CenZboz->nMnozRSES := 0, Nil )
        If( CenZboz->nMnozKZbo < 0, CenZboz->nMnozKZbo := 0, Nil )
        If( CenZboz->nMnozDZbo < 0, CenZboz->nMnozDZbo := 0, Nil )
    EndCase
    CenZboz->( dbUnlock())
  EndIf
  fOrdRec()
Return

* Modifikace KUSOV pøi zrušení obj. pøijaté
*===============================================================================
PROCEDURE VYR_Kusov_MODI()
  Local cKEY := Upper( ObjITEM->cCislObINT) + StrZERO( ObjITEM->nCislPolOB, 5 )

  IF( Used('KUSOV'), NIL, drgDBMS:open('KUSOV') )
  nREC := KUSOV->( RecNO())
  IF KUSOV->( dbSEEK( cKEY,,'KUSOV5'))
    IF ReplREC( 'KUSOV')
      KUSOV->cCislObINT := SPACE( 30)
      KUSOV->nCislPolOB := 0
      KUSOV->( dbUnlock())
    ENDIF
  ENDIF
  KUSOV->( dbGoTO( nREC))
RETURN

* Modifikace ObjHead pøi generování materiálových požadavkù
*===============================================================================
STATIC FUNCTION VYR_ObjHead_Modi()
  Local cKey := StrZero( 1, 5) + VyrZak->cCisZakaz
  Local nRec := ObjItem->( RecNo())
  Local lExist, lOK
  Local aX := { 0, 0, 0, 0, 0 }

  if replRec('objHead')
    ObjItem->( dbGoTop())
    ObjItem->( dbEval( {||  aX[ 1] += 1                    ,;
                            aX[ 2] += ObjItem->nKcsBdObj   ,;
                            aX[ 3] += ObjItem->nKcsZdObj   ,;
                            aX[ 4] += ObjItem->nMnozObODB  ,;
                            aX[ 5] += ObjItem->nMnozPoODB   }))

    ObjHead->nPocPolObj := aX[ 1]
    ObjHead->nKcsBdObj  := aX[ 2]
    ObjHead->nKcsZdObj  := aX[ 3]
    ObjHead->nMnozObODB := aX[ 4]
    ObjHead->nMnozPoODB := aX[ 5]
    ObjHead->nCenaZakl  := ObjHead->nKcsBdObj
    ObjItem->( dbGoTo( nRec))
    ObjHead->( dbUnlock())
  endif


/*
 If ObjItem->( RecNo()) <= ObjItem->( LastRec())
   lExist := ObjHead->( dbSeek( Upper( cKey)))
   If ( lOK := If( lExist, ReplRec( 'ObjHead'), AddRec( 'ObjHead')) )
      If !lExist
        // ... dosud neexistuje Hl. obj. pøijaté, založí se.
        ObjHead->nCisFirmy  := 1  // MyFIRMA
        ObjHead->nCislObInt := VYR_NewCisObjHEAD( VyrZak->cCisZakaz)
        ObjHead->cCislObInt := VyrZak->cCisZakaz
        ObjHead->dDatObj    := Date()
        ObjHead->dDatDoOdb  := VyrZak->dOdvedZaka - VyrZak->nPlanPruZa
        ObjHead->cNazPracov := SysConfig( 'System:cUserAbb')
        ObjHead->cCisZakaz  := VyrZak->cCisZakaz
      Endif
      ObjItem->( dbGoTop())
      ObjItem->( dbEval( {||  aX[ 1] += 1                    ,;
                              aX[ 2] += ObjItem->nKcsBdObj   ,;
                              aX[ 3] += ObjItem->nKcsZdObj   ,;
                              aX[ 4] += ObjItem->nMnozObODB  ,;
                              aX[ 5] += ObjItem->nMnozPoODB   }))
      ObjHead->nPocPolObj := aX[ 1]
      ObjHead->nKcsBdObj  := aX[ 2]
      ObjHead->nKcsZdObj  := aX[ 3]
      ObjHead->nMnozObODB := aX[ 4]
      ObjHead->nMnozPoODB := aX[ 5]
      ObjHead->nCenaZakl  := ObjHead->nKcsBdObj
      ObjItem->( dbGoTo( nRec))
      ObjHead->( dbUnlock())
   Endif
 Endif
*/
Return( Nil)

********************************************************************************
* Materiál na zakázku - Porovnání plánu a skuteènosti
********************************************************************************
CLASS VYR_VZakPLSK_SCR FROM drgUsrClass

EXPORTED:
  METHOD  Init, ItemMarked, drgDialogStart

  inline method drgDialogEnd(drgDialog)
    objitem->( ads_clearAof())
  return

HIDDEN
  VAR     broVydej
  METHOD  sumColumn
ENDCLASS

*
********************************************************************************
METHOD VYR_VZakPLSK_SCR:Init(parent)
  ::drgUsrClass:init(parent)
RETURN self

*
********************************************************************************
METHOD VYR_VZakPLSK_SCR:drgDialogStart(drgDialog)
  Local Filter, x, oColumn

  ::broVydej := drgDialog:dialogCtrl:oBrowse[ 2]

  filter := format( "ncisFirmy = %% and ccisZakaz = '%%'", { MyFIRMA, VYRZAK->cCisZakaz} )
  objitem->( ads_setAof(filter),dbgoTop())

*  Filter  := Format("StrZero( ObjITEM->nCisFirmy, 5) = '%%' .and. Upper(ObjITEM->cCisZakaz) = '%%' ",;
*                   { '00001', Upper(VYRZAK->cCisZakaz) })
*  ObjItem->( mh_SetFilter( Filter))

  * Výdejky na zakázku
*  PVPITEM->( dbSetScope(SCOPE_BOTH, Upper(VYRZAK->cCisZakaz) + '-1')   , dbGoTOP() )
*
  Filter  := Format("Upper(PVPITEM->cCisZakaz) = '%%' .and. StrZero( PVPITEM->nTypPoh, 2) = '%%'",;
                   { Upper(VYRZAK->cCisZakaz), '-1' })
  PVPItem->( mh_SetFilter( Filter))
*

/*
  FOR x := 1 TO ::broVydej:oXbp:colcount
    ocolumn := ::broVydej:oXbp:getColumn(x)

    ocolumn:FooterLayout[XBPCOL_HFA_CAPTION]     := ''
    ocolumn:FooterLayout[XBPCOL_HFA_HEIGHT]      := drgINI:fontH - 2
    ocolumn:FooterLayout[XBPCOL_HFA_FRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
    ocolumn:FooterLayout[XBPCOL_HFA_ALIGNMENT]   := XBPALIGN_RIGHT
    ocolumn:FooterLayout[XBPCOL_HFA_FGCLR]       := GRA_CLR_DARKBLUE
    ocolumn:configure()
  NEXT
*/

  ::sumColumn()
RETURN SELF

*
********************************************************************************
METHOD VYR_VZakPLSK_SCR:ItemMarked()
  Local cScope := Upper(VYRZAK->cCisZakaz) + '-1'
  Local cKey := Upper( ObjItem->cCisSklad) + Upper( ObjItem->cSklPol)
  Local nRecNO := PVPItem->( RecNO())

  * Pøi pohybu nad objednávkami se dohledává PVPITEM
  If( PVPItem->( dbSeek( cScope + cKey )), NIL, PVPItem->( dbGoTO( nRecNO)) )
  ::broVydej:oXbp:refreshAll()

RETURN SELF

** HIDDEN **********************************************************************
METHOD VYR_VZakPLSK_SCR:sumColumn()
  LOCAL nRec := PVPItem->( RecNo()), nCenaCelk := 0, nPos
  Local arrDef, aItems, x

  PVPItem->( dbGoTOP(),;
            dbEVAL( {|| nCenaCelk += PVPItem->nCenaCelk }),;
            dbGoTO( nRec) )
  aItems := { { 'PVPItem->nCenaCelk', nCenaCelk } }

  FOR x := 1 TO LEN( aItems)
    IF ( nPos := AScan( ::broVydej:arDef, {|Col| Col[ 2] = aItems[ x, 1] } ) ) > 0
      ::broVydej:oXbp:getColumn( nPos):Footing:hide()
      ::broVydej:oXbp:getColumn( nPos):Footing:setCell(1, aItems[ x, 2] )
      ::broVydej:oXbp:getColumn( nPos):Footing:show()
    ENDIF
  NEXT

  ::drgDialog:dataManager:refresh()
RETURN self