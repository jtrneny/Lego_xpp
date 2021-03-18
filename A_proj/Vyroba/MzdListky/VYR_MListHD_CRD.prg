/*==============================================================================
  VYR_MListHD_CRD.PRG                    ...
==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "drgres.Ch'
#include "..\VYROBA\VYR_Vyroba.ch"

#define   tab_LISTIT       1
#define   tab_POLOPER      2


********************************************************************************
*
********************************************************************************
CLASS VYR_MListHD_CRD FROM drgUsrClass
EXPORTED:
  VAR     lNewRec, Filter, nOperML, aCfg_KonVypNor, ScopeIT

  METHOD  Init, Destroy, drgDialogStart, EventHandled
  METHOD  tabSelect
  METHOD  PreValidate, PostValidate
  method  vyr_mlisthd_wrt_inTrans

  METHOD  DoAppend, DoEnter, DoDelete, DoEscape
  METHOD  VYR_MListIT_CRD, VYR_PolOper_CRD
  METHOD  VYR_VyrPol_SEL

  METHOD  ZAKAZKA_vyber // , ZAKAZKA_vse
  METHOD  ML_Uzavrit, ML_Rozdelit, ML_Planovat, ML_Prepocet, ML_Nulovat


  inline access assign method cnazevZak1() var cnazevZak1
    local  retVal := ''

    if isObject(::o_cisZakazi)
      vyrZakit->( dbseek( upper(::o_cisZakazi:value),, 'ZAKIT_4') )
      retVal := vyrZakit->cnazevZak1
    endif
  return retVal

 inline access assign method cnazev() var cnazev
    local  retVal := ''

    if isObject(::o_vyrPol) .and. isObject(::o_varCis)
      vyrPOL->( dbseek( upper(::o_vyrPol:value) + strZero(::o_varCis:value, 3),, 'VYRPOL4') )
      retVal := vyrPol->cnazev
    endif
  return retVal


HIDDEN:
  VAR     dc, dm, df, ab, oForm, broIT, broOP
  VAR     tabNUM, nRecNO, nRecZakIT
  *
  var     oxbpTab_listit, oxbpTab_poloper, oxbp_actionBord
  var     obtn_ML_Uzavrit, obtn_ML_Rozdelit, obtn_ML_Planovat, obtn_ML_Prepocet, obtn_ML_Nulovat

  var     obmp_no_Run, obmp_bookOpen

  var     ostat_listhd, sta_activeArea
  var     o_porCisLis, o_cisZakazi, o_vyrPol, o_varCis

  METHOD  VYR_ListHD_ReCMP
  METHOD  NazPOL1_OK
  METHOD  sumColumn, setFilter
  method  vyr_mlisthd_wrt
  *
  **
  inline method enable_or_disable_inFrm()
    local is_listit   := ( isNull(listit->sid , 0) <> 0 )
    local is_poloper  := ( isNull(polOper->sid, 0) <> 0 )
    local is_inAction := ( is_listit .or. is_polOper )
    *
    local  m_file := 'listhd'
    local  values := ::dm:vars:values, size := ::dm:vars:size(), x, file
    local  drgVar

    if( is_listit, ::oxbpTab_listit:enable() , ::oxbpTab_listit:disable()  )
    ::oxbpTab_listit:SetImage(  if( is_listit, ::obmp_bookOpen, ::obmp_no_Run ) )

    if( is_polOper, ::oxbpTab_polOper:enable(), ::oxbpTab_polOper:disable()  )
    ::oxbpTab_poloper:SetImage( if( is_polOper, ::obmp_bookOpen, ::obmp_no_Run ) )

    if( is_inAction, ::oxbp_actionBord:enable(), ::oxbp_actionBord:disable() )
    if( is_poloper , nil, ::obtn_ML_Prepocet:oxbp:disable() )

    * zablokujeme hlavièku
    for x := 1 to size step 1
      file := lower(if( ismembervar(values[x,2]:odrg,'name'),drgParse(values[x,2]:odrg:name,'-'), ''))

      if file = m_file .and. values[x,2]:odrg:isEdit
        drgVar := values[x,2]
      endif
    next
  return self

  inline method enable_or_disable_Area(isOk)
    if( isOk, ::oxbpTab_listit:enable() , ::oxbpTab_listit:disable()  )
    if( isOk, ::oxbpTab_poloper:enable(), ::oxbpTab_poloper:disable() )
    if( isOk, ::oxbp_actionBord:enable(), ::oxbp_actionBord:disable() )
  return self

  inline method restColor()
    local members := ::df:aMembers

    oxbp := setAppFocus()
    aeval(members, {|X| if(ismembervar(x,'clrFocus'), x:oxbp:setcolorbg(x:clrfocus), nil) })
  return .t.

  inline method postValidateForm()
    local  m_file := 'listhd'
    local  values := ::dm:vars:values, size := ::dm:vars:size(), x, file
    local  drgVar
    *
    begin sequence
      for x := 1 to size step 1
        file := lower(if( ismembervar(values[x,2]:odrg,'name'),drgParse(values[x,2]:odrg:name,'-'), ''))

        if file = m_file .and. values[x,2]:odrg:isEdit

          drgVar := values[x,2]

          if .not. ::postValidate(drgVar)
            ::df:olastdrg   := values[x,2]:odrg
            ::df:nlastdrgix := x
            ::df:olastdrg:setFocus()
            return .f.
    break
          endif
        endif
      next
    end sequence
  return .t.

ENDCLASS


********************************************************************************
METHOD VYR_MListHD_CRD:init(parent)

  ::drgUsrClass:init(parent)

  ::lNewREC   := !( parent:cargo = drgEVENT_EDIT)
  ::tabNUM    := tab_LISTIT
  ::nRecNO    := ListHD->( RecNO())
  * CFG
  ::nOperML        := SysCONFIG( 'Vyroba:nOperML')
  ::aCfg_KonVypNor := ListAsArray( AllTrim( SysConfig( 'Vyroba:cKonVypNOR')))
  ::aCfg_KonVypNor := AEVAL( ::aCfg_KonVypNor, {|X,i| ::aCfg_KonVypNor[i] := (X = '1')} )

  drgDBMS:open('Operace'  )
  drgDBMS:open('VyrPOL'   )
  drgDBMS:open('C_Tarif'  )
  drgDBMS:open('C_TypLis' )
  *
  ::Filter  := ListHD->( ADS_GetAOF())
  ::ScopeIT := ListIT->( dbScope())
RETURN self

********************************************************************************
METHOD VYR_MListHD_CRD:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members
  Local  cHLP := AllTrim( SysCONFIG( 'Vyroba:cNazPol1'))
  Local  aNazPOL1 := ListAsARRAY( cHLP)
  Local  cNazPOL1 := PADR( aNazPOL1[ 1], 8 )
  Local  x, Filter, cScope, bro, aRec := {}
  *
  local  acolors      := MIS_COLORS
  *
  local  odrg, groups, name, tipText, pa_groups
  local  obmp_no_Run   := XbpBitMap():new():create() // 316
  local  obmp_bookOpen := XbpBitMap():new():create() // 303

  ::dc    := ::drgDialog:dialogCtrl              // dataCtrl
  ::dm    := ::drgDialog:dataManager             // dataMabanager
  ::df    := ::drgDialog:oForm                   // form
  ::ab    := drgDialog:oActionBar:members        // actionBar

  *
  ::oxbp_actionBord := ::drgDialog:oActionBar:oBord
  ::obmp_no_Run     := XbpBitMap():new():create() // 316
  ::obmp_no_Run:load( ,316)
  ::obmp_no_Run:TransparentClr := obmp_no_Run:GetDefaultBGColor()

  ::obmp_bookOpen   := XbpBitMap():new():create() // 303
  ::obmp_bookOpen:load( ,303)
  ::obmp_bookOpen:TransparentClr := ::obmp_bookOpen:GetDefaultBGColor()

  for x := 1 to len(::ab) step 1
    do case
    case ::ab[x]:event = 'ML_Uzavrit'  ;  ::obtn_ML_Uzavrit  := ::ab[x]
    case ::ab[x]:event = 'ML_Rozdelit' ;  ::obtn_ML_Rozdelit := ::ab[x] // Val( ListIT->cStavListk ) > 3
    case ::ab[x]:event = 'ML_Planovat' ;  ::obtn_ML_Planovat := ::ab[x] // Val( ListIT->cStavListk ) > 3
    case ::ab[x]:event = 'ML_Prepocet' ;  ::obtn_ML_Prepocet := ::ab[x]
    case ::ab[x]:event = 'ML_Nulovat'  ;  ::obtn_ML_Nulovat  := ::ab[x]
    endcase
  next

  members  := drgDialog:oForm:aMembers
  FOR x := 1 TO LEN(members)
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')

    IF members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ groups
        pa_groups := ListAsArray(groups)
        nin       := ascan(pa_groups,'SETFONT')

        members[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            ::members[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          ::members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
      endif
    ENDIF

    if odrg:ClassName() =  'drgTabPage'
      do case
      case (odrg:tabBrowse = 'LISTIT' )  ;  ::oxbpTab_listit  := odrg:oxbp
      case (odrg:tabBrowse = 'POLOPER')  ;  ::oxbpTab_poloper := odrg:oxbp
      endcase
    endif

    if odrg:ClassName() = 'drgStatic'
      do case
      case groups = 'LISTHD'
        ::ostat_listhd := odrg
      case odrg:oxbp:type = XBPSTATIC_TYPE_ICON
         ::sta_activeArea := odrg
      endcase
    endif
  NEXT
  *
  ::oForm := ::drgDialog:oForm
  ::broIT := ::dc:oBrowse[ tab_LISTIT ]
  ::broOP := ::dc:oBrowse[ tab_POLOPER]
  *
  ::o_porCisLis := ::dm:has( 'listhd->nporCisLis' )
  ::o_cisZakazi := ::dm:has( 'listhd->ccisZakazi' )
  ::o_vyrPol    := ::dm:has( 'listhd->cvyrPol'    )
  ::o_varCis    := ::dm:has( 'listhd->nvarCis'    )

  ColorOfText( ::dc:members[1]:aMembers)
  *
  ListIT->( mh_ClrScope())
  *
  IF ::lNewRec
    Filter := Format( "nPorCisLis = %%", { 0 } )
    cScope := '-1'   // 0000000000000000'
    IF( ::nOperML = OPERML_STD, ::oForm:setNextFocus( 'ListHD->cCisZakazI'), NIL )
    IF  ::nOperML = OPERML_MOPAS
      ::oForm:setNextFocus( 'ListHD->nPorCisLis')
      ::preValidate( ::dm:has('ListHD->nPorCisLis'))
    ENDIF

    ::ostat_listhd:oxbp:setColorBG( GraMakeRGBColor( {210,255,233} ) )
    ::sta_activeArea:oxbp:setCaption(337)

    ::obtn_ML_Nulovat:oxbp:disable()
*    ::enable_or_disable_Area(.f.)
  ELSE
    Filter := Format( "nPorCisLis = %%", { ListHD->nPorCisLis } )
    cScope := StrZero( ListHD->nRokVytvor, 4) + StrZero( ListHD->nPorCisLis,12)
    SetAppFocus( ::broIT:oXbp)

    ::sta_activeArea:oxbp:setCaption(338)
  ENDIF
  *
  ::setFilter( Filter)
  PolOper->( mh_SetScope( cScope))
  *
  ::broIT:refresh()
  IsEditGET( { 'ListHD->lUzv'}, ::drgDialog, .F. )
  *
  ::sumColumn( .F.)
  IF( ::lNewRec, ::dm:refreshAndSetEmpty('ListHD'), ::dm:refresh() )

  ::enable_or_disable_inFrm()
  if( ::lnewRec, nil, ::eventHandled( xbeBRW_ItemMarked,,, ::broIT:oxbp ) )
RETURN self


METHOD VYR_MListHD_CRD:EventHandled(nEvent, mp1, mp2, oXbp)
  local  lok
  local  is_listit  := ( isNull(listit->sid , 0) <> 0 )
  local  nstavListk := Val(listit->cstavListk )

  if( nstavListk > 3, ( ::obtn_ML_Rozdelit:oxbp:disable(), ::obtn_ML_Planovat:oxbp:disable() ), ;
                      ( ::obtn_ML_Rozdelit:oxbp:enable() , ::obtn_ML_Planovat:oxbp:enable()  )  )

  if nEvent =  xbeM_LbClick
    do case
    case (oxbp:className() = 'XbpGet' .or. oxbp:className() = 'XbpCheckBox')
      if ::sta_activeArea:oxbp:caption <> 337
        ::ostat_listhd:oxbp:setColorBG( GraMakeRGBColor( {210,255,233} ) )
        ::sta_activeArea:oxbp:setCaption(337)

        ::obtn_ML_Nulovat:oxbp:disable()
      endif

    case (oxbp:className() = 'XbpImageTabPage')
      ::df:tabPageManager:active := nil
      oxbp:cargo:setFocus(oxbp:cargo:tabNumber)
    endCase
  endif

  if nEvent = xbeBRW_ItemMarked
    if ( is_listit .and. ::sta_activeArea:oxbp:caption <> 338 )
      ::restColor()
      ::ostat_listhd:oxbp:setColorBG(GRA_CLR_BACKGROUND)
      ::sta_activeArea:oxbp:setCaption(338)
    endif

    if  ::tabNum = tab_LISTIT .and. is_listit
      if( listit->nOsCisPrac = 0 .and. listit->nKusyCelk <> 0, ;
          ::obtn_ML_Nulovat:oxbp:enable() , ;
          ::obtn_ML_Nulovat:oxbp:disable()  )
    endif
  endif


  DO CASE
    CASE nEvent = drgEVENT_APPEND
      lOK := ::DoAPPEND( oXbp)
      RETURN lOK

    CASE nEvent = drgEVENT_EDIT
      lOK := ::DoENTER( oXbp, nEvent)
      RETURN lOK

    CASE nEvent = drgEVENT_DELETE
      ::DoDELETE( oXbp)
      RETURN .T.

    CASE nEvent = xbeP_Keyboard
      Do Case
        Case mp1 = xbeK_ENTER
          lOK := ::DoENTER( oXbp, nEvent)
          RETURN lOK
        Case mp1 = xbeK_ESC .and. ::oxbpTab_listit:isEnabled()
          RETURN( ::DoESCAPE( oXbp))
        Otherwise
          RETURN .F.
      EndCase

    CASE nEvent = xbeM_LbClick
      IF oXbp:ClassName() = 'XbpGet'
        IF !::dc:isAppend .and.  oXbp:cargo:isEdit
          PostAppEvent(drgEVENT_EDIT,,, oXbp)
        ENDIF
      ENDIF
      RETURN .F.

    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.


METHOD VYR_MListHD_CRD:tabSelect( tabPage, tabNumber)
  local oBro := if( tabNumber = tab_LISTIT, ::broIT:oxbp, ::broOP:oxbp )

  ::tabNUM := tabNumber
*  IF( ::tabNUM = tab_LISTIT, ::broIT:refresh(),::broOP:refresh() )
  postAppEvent( xbeBRW_ItemMarked,,, oBro )
RETURN .t.


********************************************************************************
METHOD VYR_MListHD_CRD:preValidate(drgVar)
  Local value := drgVar:Value
  Local Name := drgVar:Name, cKey
  Local cCisZakaz := Upper( ::dm:get('ListHD->cCisZakazI'))

  IF ::lNewRec
     IF Name = 'ListHD->nPorCisLis'
       IF EMPTY( value )
        ::dm:set('ListHD->nPorCisLis', VYR_NewCisLis() )
       ENDIF
       ::dm:set('ListHD->nRokVytvor', YEAR( Date()) )
     ENDIF

     IF ( Name = 'ListHD->cCisZakazI' .or. ;
          ( Name = 'ListHD->cVyrPOL' .and. !EMPTY( cCisZakaz) ))

       IF EMPTY( ::dm:Get('ListHD->nPorCisLis' ) )
        ::dm:set('ListHD->nPorCisLis', VYR_NewCisLis() )
       ENDIF
       ::dm:set('ListHD->nRokVytvor', YEAR( Date()) )
       IF !EMPTY( cCisZakaz)
         ::dm:set('ListHD->cCisZakazI', cCisZakaz )
       ENDIF
        IsEditGET( 'ListHD->cCisZakazI', ::drgDialog, EMPTY( cCisZakaz) )
     ENDIF
  ENDIF

  IF Name = 'ListHD->cVyrPol'
    cKey := ::dm:get('ListHD->cCisZakazI')
    /*
    IF( EMPTY( cKey), VyrPol->( dbClearScope()),;
                      VyrPol->( dbSetScope(SCOPE_BOTH, cKey), dbGOTOP() )  )
    */
    *
    IF EMPTY( cKey)
      VyrPol->( mh_ClrFilter())
    ELSE
      Filter := Format("cCisZakaz = '%%'", { Upper(Left( cKey, LEN(EMPTY_ZAKAZ))) } )
      VyrPOL->( mh_SetFilter( filter))
    ENDIF
    *
  ENDIF
RETURN .T.

********************************************************************************
METHOD VYR_MListHD_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged )
  LOCAL  cName := oVar:name, cKey, nMjCas, nNm, nKcOper, nDivide := 60
  Local  nEvent := mp1 := mp2 := nil
  * F4
  nEvent  := LastAppEvent(@mp1,@mp2)

  DO CASE
  CASE cName = 'LISTHD->nPorCisLis'
    if(IsNUMBER(mp1) .and. mp1 =  xbeK_UP )
      Return .F.
    ENDIF
    IF lOK := ControlDUE( oVar)
      lOK := !VYR_DoubleML( self, xVar)
    ENDIF

  CASE cName = 'LISTHD->cCisZakazI'
    lok := ::Zakazka_vyber()

/*
    IF lOK := ControlDUE( oVar)
      IF VyrZAKIT->( dbSEEK( Upper( xVar),, 'ZAKIT_4'))
        ::nRecZakIT := VyrZakIT->( RecNO())
        IF ALLTRIM( VyrZAKIT->cStavZakaz) = 'U'
           cMsg := 'Zakázka < & > je již ukonèena !'
           drgMsgBox(drgNLS:msg( cMsg, VyrZakIT->cCisZakaz, ::drgDialog:dialog))
           RETURN .F.
        ENDIF
      ELSE
        ::Zakazka_vyber()
      ENDIF
    ENDIF
*/

  CASE cName = 'LISTHD->cVyrPol'
    lOK := ::VYR_VyrPOL_SEL()

  CASE cName = 'LISTHD->cOznOper'
    If lValid
      IF ::lNewRec
        ::dm:set('ListHD->cOznPrac', Operace->cOznPrac )
      ENDIF
      nNm := ::dm:get('ListHD->nKusyCelk') * Operace->nKusovCas
      ::dm:set('ListHD->nNhNaOpePl', nNm )
      cKey := Operace->cTarifStup + Operace->cTarifTrid
      C_Tarif->( dbSeek( Upper( cKey)))
      ::dm:set('ListHD->nNmNaOpePl', ( nNm * (( c_Tarif->nHodinSaz + c_Tarif->nHodinNav) / 60 )))
    Endif

    CASE cName = 'LISTHD->nCisOper' .or. cName = 'LISTHD->nUkonOper' .or. ;
         cName = 'LISTHD->nVarOper'
      /*
      IF lOK := ControlDUE( oVar)
        FOrdREC( { 'ListHD, 3'})
        cKEY :=  Upper( ::dm:get('ListHD->cCisZakaz'))      + ;
                 Upper( ::dm:get('ListHD->cVyrPol'))        + ;
                 StrZERO( ::dm:get('ListHD->nCisOper' ), 4) + ;
                 StrZERO( ::dm:get('ListHD->nUkonOper'), 2) + ;
                 StrZERO( ::dm:get('ListHD->nVarOper') , 3)
        IF( lOK := ListHD->( dbSeek( Upper( cKey))) )
          cMsg := 'Na danou operaci již byl vystaven mzdový lístek èíslo < & > !'
          drgMsgBox(drgNLS:msg( cMsg, ListHD->nPorCisLis, ::drgDialog:dialog))
        ENDIF
        lOK := !lOK
        FOrdREC()
      ENDIF
      */
    CASE cName = 'LISTHD->nKusovCas' .or. cName = 'LISTHD->nPriprCas'  .or. ;
         cName = 'LISTHD->nKusyCelk' .or. cName = 'LISTHD->nNhNaOpePl' .or. ;
         cName = 'LISTHD->nNmNaOpePl'

      IF cName = 'LISTHD->nNhNaOpePl' .or. cName = 'LISTHD->nNmNaOpePl'
*        lOK := ControlDUE( oVar, .F.)
        IF cName = 'LISTHD->nNhNaOpePl' .and. ::aCfg_KonVypNor[ 1]
          lOK := ControlDUE( oVar, .F.)
        ENDIF
        IF cName = 'LISTHD->nNmNaOpePl' .and. ::aCfg_KonVypNor[ 2]
          lOK := ControlDUE( oVar, .F.)
        ENDIF
        nDivide := IF( cName = 'LISTHD->nNhNaOpePl', 1, nDivide )
      ENDIF

      IF lOK .and. lValid
        IF cName = 'LISTHD->nNhNaOpePl'
          ::dm:set('ListHD->nNmNaOpePl', xVar * 60 )

        ELSEIF cName = 'LISTHD->nNmNaOpePl'
          ::dm:set('ListHD->nNhNaOpePl', xVar / 60 )

        ELSE
          nNm := (::dm:get('ListHD->nKusyCelk') * ::dm:get('ListHD->nKusovCas') ) + ;
                  ::dm:get('ListHD->nPriprCas')
          ::dm:set('ListHD->nNmNaOpePl', nNm )
          ::dm:set('ListHD->nNhNaOpePl', nNm / 60 )
        ENDIF

        cKey := Operace->cTarifStup + Operace->cTarifTrid
        C_Tarif->( dbSeek( Upper( cKey)))
        nMjCas  := SysCONFIG( 'Vyroba:nMjCas')
        nKcOper := ( (C_Tarif->nHodinSaz + C_Tarif->nHodinNav)/ nDivide )
        nKcOper := IIF( nMjCas == 1, nKcOper * 60,;
                   IIF( nMjCas == 3, nKcOper / 60, nKcOper ) )
        ::dm:set('ListHD->nKcNaOpePl', nKcOper * ::dm:get('ListHD->nKusyCelk') )
      ENDIF

      CASE cName = 'LISTHD->nKcNaOpePl'
        IF(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
          ::vyr_mlisthd_wrt_inTrans()
        ENDIF
  ENDCASE
RETURN lOK



********************************************************************************
METHOD VYR_MListHD_CRD:destroy()

  ::dc := ::dm := ::oForm := ::broIT := ::broOP := ;
  ::lNewREC    := ;
  ::tabNUM     := ;
  ::nOperML    := ;
                  NIL
  VyrZAK->( Ads_ClearAof())
  ListHD->( Ads_ClearAof())
  ListIT->( AdsSetOrder(1), mh_ClrFilter())
  VyrPOL->( mh_ClrFilter())
  IF !EMPTY( ::ScopeIT)
    ListIT->( mh_SetScope( ::ScopeIT))
  ENDIF
  IF !EMPTY( ::Filter)
    ListHD->( mh_SetFilter( ::Filter))
    ListHD->( dbGoTO( ::nRecNO))
    ::drgDialog:parent:dialogCtrl:oaBrowse:refresh()
  ENDIF
  ::nRecNo     := ;
  ::Filter     := nil

  ::drgUsrClass:destroy()
RETURN self

* Výbìr z položky zakázky
********************************************************************************
METHOD VYR_MListHD_CRD:ZAKAZKA_vyber( oDLG, oBTN)
  Local oDialog, nExit
  *
  local  cfiltr    := "cstavZakaz <> 'U'"
  local  cisZakazi := ::dm:get( 'listHd->ccisZakazI')
  local  lok       := .f.   //( .not. empty(ciszakazi) .and. vyrZakit->( dbseek( upper(cisZkazi),, ZAKIT_4')) )

  vyrZakit->( ads_setAof( cfiltr), dbgoTop() )

  if .not. empty(ciszakazi)
    lok := vyrZakit->( dbseek( upper(cisZakazi),, 'ZAKIT_4') )
    if( lok, nil, vyrZakit->( dbgoTop()) )
  endif

  IF IsObject( oDlg) .or. !lOK
    DRGDIALOG FORM 'VYR_VYRZAKIT_SEL' PARENT ::drgDialog MODAL DESTROY;
                                      EXITSTATE nExit
  ENDIF

  IF  nExit != drgEVENT_QUIT .or. lok
    ::nRecZakIT := VyrZakIT->( RecNO())
    ::dm:set( 'ListHD->cCisZakazI', VYRZAKIT->cCisZakazI)
    lok := .t.

    ::dm:refresh()
    ::df:setNextFocus('listhd->cvyrPol',,.t.)
  ENDIF

  vyrZakit->( ads_clearAof() )
RETURN lok


* Výbìr vyrábìné položky do karty hlavièky ML
********************************************************************************
METHOD VYR_MListHD_CRD:VYR_VYRPOL_SEL( oDlg)
  LOCAL oDialog, nExit
  Local cVyrPol := ::dm:get( 'ListHD->cVyrPOL')
  Local nVarCis := MAX( ::dm:get( 'ListHD->nVarCis'), 1 )
  LOCAL lOK := ( !Empty( AllTrim(cVyrPol))  .and. VyrPOL->( dbSEEK( Upper(cVyrPol) + StrZero(nVarCis, 3),, 'VYRPOL4')) )

  IF IsObject( oDlg) .or. !lOK
    DRGDIALOG FORM 'VYR_VYRPOL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    ::dm:set( 'ListHD->nVarCis', VyrPOL->nVarCis )
    ::dm:set( 'ListHD->cVyrPOL', VyrPOL->cVyrPol )
    lOK := .T.

    ::dm:refresh()
    ::df:setNextFocus('listhd->nvarCis',,.t.)
  ENDIF
RETURN lOK

/*
********************************************************************************
METHOD VYR_MListHD_CRD:ZAKAZKA_vyber( oDLG, oBTN)
  Local oDialog, nExit

  DRGDIALOG FORM 'VYR_VYRZAK_SEL' PARENT ::drgDialog MODAL DESTROY;
                                  EXITSTATE nExit
  IF  nExit != drgEVENT_QUIT
    ::dm:set( 'ListHD->cCisZakaz', VYRZAK->cCisZakaz)
*    ::cNazZakaz  := VYRZAK->cNazevZak1
*    ::MLnaZAKAZKU()
*    ::dm:refresh()
  ENDIF
RETURN self
*/
/*
********************************************************************************
METHOD VYR_MListHD_CRD:ZAKAZKA_vse( oDLG, oBTN)
  ::cCisZakaz  := ''
  ::MLnaZAKAZKU()
  ::dm:refresh()
RETURN self
*/

* DoAPPEND
********************************************************************************
METHOD VYR_MListHD_CRD:DoAppend( oXbp)
  Local cAlias := ::dc:oaBrowse:cFile

   IF cALIAS == 'LISTIT'
    IF VYR_AllOK( ListHD->cCisZakaz)
      IF ::NazPol1_OK()
        IF NazPol1_TST( 'ListIT', xbeK_INS, '12' )
          ::VYR_MListIT_CRD()
          ::sumColumn()
          *
          SetAppFocus( ::broIT:oXbp )
** JS          ListIT->( dbGoBottom())
          ::broIT:oXbp:refreshAll()
          *
        ENDIF
      ENDIF
    ENDIF
    RETURN .T.

  ELSEIF cALIAS = 'PolOper'
    cKEY := UPPER( ListHD->cCisZakaz) + UPPER( ListHD->cVyrPOL)
*    IF VyrPOL->( dbSEEK( cKEY,,'VYRPOL1'))
*      ::VYR_PolOper_CRD()
*      ::VYR_ListHD_ReCMP()
*      *
*      ::broOP:refresh()
*      SetAppFocus( ::broOP:oXbp )
*    ELSE
*       drgMsgBox(drgNLS:msg( 'Vyrábìná položka neexistuje, nelze poøídit operace !'))
*    ENDIF
    RETURN .T.
  ENDIF

  ::dm:refresh()
RETURN .F.   //.T.

* DoENTER
********************************************************************************
METHOD VYR_MListHD_CRD:DoEnter( oXbp, nEvent)
  Local cAlias := ::dc:oaBrowse:cFile, nRec

IF oXbp:ClassName() = 'XbpBrowse'
  ::lNewRec := .F.
  IF cALIAS = 'ListHD'
    IF VYR_AllOK( ListHD->cCisZakaz)
      ::nRecNo := (cALIAS)->( RecNO())
      IsEditGET( 'ListHD->cCisZakazI', ::drgDialog, .F. )
      ::oForm:setNextFocus('ListHD->cVyrPol')
    ENDIF

  ELSEIF cAlias = 'ListIT'
    IF EMPTY( ListIT->nPorCisLis)
*      drgMsgBox(drgNLS:msg( 'Mzdový lístek nemá položku, není co opravovat !', XBPMB_INFORMATION ))
      drgMsgBox(drgNLS:msg( 'Mzdový lístek nemá položku, nejprve je tøeba nìjakou poøídit !', XBPMB_INFORMATION ))
      RETURN .T.
    ENDIF
    IF VYR_AllOK( ListHD->cCisZakaz)
      IF NazPol1_TST( 'ListIT', xbeK_ENTER, '12' )
        nRec := ListIT->(RecNo())
        ::VYR_MListIT_CRD()
        ::broIT:refresh()
        SetAppFocus(  ::broIT:oXbp )
        ::sumColumn()
        ListIT->( dbGoTO(nRec))
      ENDIF
    ENDIF
    RETURN .T.

  ELSEIF cALIAS = 'PolOper'
    ::VYR_PolOper_CRD( nEvent)
    ::VYR_ListHD_ReCMP()
    ::broOP:refresh()
    SetAppFocus( ::broOP:oXbp )
    RETURN .T.
  ENDIF
ENDIF
RETURN .F.

* DoDELETE
********************************************************************************
METHOD VYR_MListHD_CRD:DoDELETE( oXbp)
  Local cAlias := ::dc:oaBrowse:cFile
  *
  IF cAlias = 'ListIT'
    VYR_MListIT_DEL()
    ::broIT:refresh()
    ::sumColumn()
    ::dm:refresh()
    * zrušením poslední položky se zruší hlavièka a dialog ML se zavøe
    IF EMPTY( ListIT->nPorCisLis)
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    ENDIF
  ENDIF
  *
  IF cAlias = 'PolOper'
*    VYR_POLOPER_del( self)
*    ::VYR_ListHD_ReCMP()
*    ::broOP:refresh()
  ENDIF
RETURN .T.

* DoESCAPE
********************************************************************************
METHOD VYR_MListHD_CRD:DoEscape( oXbp)
  Local cAREA := ::dc:oaBrowse:cFile

  IF oXbp:ClassName() <> 'XbpBrowse'
    IF( IsNumber( ::nRecNO), (cAREA)->( dbGoTO( ::nRecNO)), NIL )
//    AEval( ::dc:oBrowse, {|oB| oB:REFRESH() } )
    SetAppFocus( ::dc:oaBrowse:oXbp)
    ::lNewREC := .F.
    RETURN .T.
  ELSE
    RETURN .F.
  ENDIF
RETURN .F.

* Volání karty Plnìní ML
********************************************************************************
METHOD VYR_MListHD_CRD:VYR_MListIT_CRD()
  LOCAL  oDialog,  nExit

  oDialog := drgDialog():new('VYR_MListIT_CRD',self:drgDialog)
//  oDialog:cargo := nEvent
  oDialog:create(,self:drgDialog:dialog,.T.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
RETURN self

* Volání karty Plnìní ML
********************************************************************************
METHOD VYR_MListHD_CRD:VYR_PolOper_CRD( nEvent)
  LOCAL  oDialog,  nExit

  oDialog := drgDialog():new('VYR_PolOper_CRD',self:drgDialog)
  oDialog:cargo := nEvent
  oDialog:create(,self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
RETURN self


*
** uložení listhd v transakci **************************************************
method vyr_mlisthd_crd:vyr_mlisthd_wrt_inTrans()
  local  lDone   := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone :=  ::vyr_mlisthd_wrt()
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE

  if( lDone, ::enable_or_disable_inFrm(), nil )

*  postAppEvent( xbeBRW_ItemMarked,,, ::broIT:oxbp )
return lDone

method vyr_mlisthd_crd:vyr_mlisthd_wrt()
  local  cTypListku := '   ', Filter
  local  cisZakazi  := ::dm:get( 'listHd->ccisZakazI')

*  IF !isBefore
    IF ::lNewRec
      AddRec( 'ListHD')
      ::dm:save()

      vyrZakit->( dbseek( upper(cisZakazi),, 'ZAKIT_4') )
      ListHD->cCisZakaz  := VYRZAKIT->cCisZakaz
      ListHD->nRokVytvor := YEAR( DATE())
      ListHD->cNazev     := VyrPol->cNazev
      ListHD->cNazOper   := Operace->cNazOper
      ListHD->cStred     := Operace->cStred
      ListHD->cPracZar   := Operace->cPracZar
      mh_WRTzmena( 'ListHD', .T.)
      ListHD->( dbUnlock())
      *
      If AddRec( 'ListIT')
         mh_COPYFLD('ListHD', 'ListIT' )
         ListIT->nDruhMzdy  := Operace->nDruhMzdy
         ListIT->cTarifStup := Operace->cTarifStup
         ListIT->cTarifTrid := Operace->cTarifTrid
         ListIT->cStavListk := '1'
         ListIT->cDruhListk := '7'

         C_TypLis->( dbEVAL( ;
                     {|| cTypListku := IF( UPPER( ALLTRIM( C_TypLis->cKodListku)) == 'A',;
                                           C_TypLis->cTypListku, cTypListku ) }))
         ListIT->cTypListku := cTypListku
         mh_WRTzmena( 'ListIT', .T.)
         ListIT->( dbUnlock())
      ENDIF
      *
      ::lNewRec := .F.
      *
*      Filter  := Format("StrZero(ListIT->nRokVytvor,4) = '%%' .and. StrZero(ListIT->nPorCisLis,12) = '%%' ",;
*                        { StrZero(ListHD->nRokVytvor,4), StrZero(ListHD->nPorCisLis,12) })
      Filter  := Format("StrZero(nRokVytvor,4) = '%%' .and. StrZero(nPorCisLis,12) = '%%' ",;
                        { StrZero(ListHD->nRokVytvor,4), StrZero(ListHD->nPorCisLis,12) })

      Filter := Format( "nPorCisLis = %%", { ListHD->nPorCisLis } )

      ListIT->( mh_ClrFilter())
      ::setFilter( Filter)
**      ::broIT:refresh()
**      ListIT->( dbGoBottom())

** ok
      ::broit:oxbp:gobottom():refreshAll()

      SetAppFocus( ::broIT:oXbp )

    ELSEIF ListHD->( sx_RLock())
      ::dm:save()
      ListHD->cNazOper := Operace->cNazOper

      ListHD->( dbUnlock())
    ENDIF
*  ENDIF
RETURN .T.


* Uzavøení / Otevøení mzdového lístku
********************************************************************************
METHOD VYR_MListHD_CRD:ML_Uzavrit()
  LOCAL cMsg := IF( ListHD->lUzv, 'Požadujete zrušit uzavøení mzdového lístku < & > ?',;
                                  'Požadujete uzavøít mzdový lístek < & > ?' )

  IF drgIsYESNO(drgNLS:msg( cMsg , ListHD->nPorCisLis) )
    IF ListHD->( sx_RLock())      // ReplREC( 'ListHD')
      ListHD->lUzv := !ListHD->lUzv
      ListHD->( dbUnlock())
    ENDIF
  ENDIF
  ::dm:refresh()
RETURN

* Rozdìlení položky mzdového lístku
********************************************************************************
METHOD VYR_MListHD_CRD:ML_Rozdelit()
  VYR_ML_Rozdelit( ::drgDialog)
RETURN self

* Zaplánování položky mzdového lístku
********************************************************************************
METHOD VYR_MListHD_CRD:ML_Planovat()
  VYR_ML_Planovat( ::drgDialog)
RETURN self

* Pøi zmìnì Ceny celkem na HLA ML, pøepoèítá èasy v PolOper - viz. VYR_PolOper_CRD:VYR_PrepocetCASU()
* Pøepoèítá èas operací z ceny mzdového lístku
********************************************************************************
METHOD VYR_MListHD_CRD:ML_Prepocet()
  LOCAL cKey, nKCas, nKusovCas, nCelKusCas, nRound
  LOCAL nKcNaOper   // := ListHD->nKcNaOpePl   // ::dm:get( 'POLOPERw->nKcNaOper')
  LOCAL nKoefKusCa  // := POLOPER->nKoefKusCa   // ::dm:get( 'POLOPERw->nKoefKusCa')

  nKcNaOper  := ListHD->nKcNaOpePl
  nKoefKusCa := POLOPER->nKoefKusCa

  IF nKcNaOper = 0
    drgMsgBox(drgNLS:msg( 'Cena je nulová, není tedy co pøepoèítat !'))
  ELSE
    cKey := POLOPER->cOznOper          // Upper( ::dm:get('POLOPERw->cOznOper') )
    Operace->( dbSeek( cKey,,'OPER1'))
    c_Tarif->( dbSeek( Upper( Operace->cTarifStup + Operace->cTarifTrid),, 'C_TARIF1'))
    nKCas := nKcNaOper / (( C_Tarif->nHodinSaz + C_Tarif->nHodinNav) / 60)
    nKCas := MjCAS( nKCas, 1 )
    nCelkKusCa := ROUND( nKCas / ( Operace->nKoefSmCas * Operace->nKoefViOb / Operace->nKoefViSt), 4 )
*    ::dm:set( 'POLOPERw->nCelkKusCa', nCelkKusCa )
    nKusovCas := ROUND( nCelkKusCa / nKoefKusCa, 4 )
*    ::dm:set( 'POLOPERw->nKusovCas', nKusovCas )
    IF PolOPER->( dbRLock())
      POLOPER->nKcNaOper  := nKcNaOper
      POLOPER->nCelkKusCa := nCelkKusCa
      POLOPER->nKusovCas  := nKusovCas
      PolOPER->( dbRUnlock())
      ::VYR_ListHD_ReCMP()    // ???
    ENDIF
  ENDIF
RETURN self

* Zanulovat nkusyCelk položky mzdového lístku
********************************************************************************
method VYR_MListHD_CRD:ML_Nulovat()
  local  cMsg := 'Požadujete zanulovat kusyCelkem položky lístku < & > ?'

  if drgIsYESNO(drgNLS:msg( cMsg , ListHD->nPorCisLis) )
    if listit->( sx_RLock())
      listit->nkusyCelk := 0
      listit->( dbUnlock())

      ::broIT:oxbp:refreshCurrent()
      ::sumColumn( .f.)

      ::eventHandled( xbeBRW_ItemMarked,,, ::broIT:oxbp )
    endif
  endif
return self



*  Pøepoèet hlavièky ML pøi modifikaci PolOper
** HIDDEN **********************************************************************
METHOD VYR_MListHD_CRD:VYR_ListHD_ReCMP()
  Local nSumaKc := 0, nSumaNm := 0, nSumaKoef := 0
  Local nRec := PolOper->( RecNO()), aRECs := {}, Lock, x

  PolOper->( dbGoTOP(),;
             dbEval({|| nSumaKc   += PolOPER->nKcNaOper   ,;
                        nSumaNm   += PolOPER->nCelkKusCa  ,;
                        nSumaKoef += PolOPER->nKoefKusCa} ) ,;
             dbGoTO( nRec) )

  * Aktualizace ListHD
  IF ListHD->( dbRLock())
     ListHD->nKusovCas  := nSumaNM / nSumaKoef
*     listHd->nprirCas
     listHd->nNmNaOpePL := (listHd->nkusyCelk * listHd->nkusovCas) +listHd->npriprCas
     listHd->nNhNaOpePL := listHd->nNmNaOpePL / 60
     ListHD->nKcNaOpePL := nSumaKc * ListHD->nKusyCelk

     ListHD->( dbUnlock())
     ::dm:refresh()
  ENDIF

  * Aktualizace ListIT
  *   - aktualizují se záznamy LISTIT, u nichž nOsCisPrac = 0
  nRec := ListIT->( RecNO())
  ListIT->( dbGoTOP(),;
            dbEval({|| IF( ListIT->nOsCisPrac = 0,;
                           AADD( aRECs, ListIT->( RecNO())), NIL ) } ))
  Lock := IF( LEN( aRECs) = 0, .T., ListIT->( sx_RLock( aRECs)) )
  IF Lock
    FOR x := 1 TO LEN( aRECs)
      ListIT->( dbGoTO( aRECs[x]))
      ListIT->nMzdaZaKUS := nSumaKc / nSumaKoef
    NEXT
    ListIT->( dbUnlock(), dbGoTO( nRec) )
  ENDIF
RETURN NIL


/* Zobrazí mzdové lístky na vybranou zakázku / všechny zakázky
********************************************************************************
METHOD VYR_MListHD_CRD:MLnaZAKAZKU()
  Local Filter

  IF EMPTY( ::cCisZakaz)
    ListHD->( Ads_ClearAof())
    ::cNazZakaz := 'VŠECHNY ZAKÁZKY'
  ELSE
    Filter := Format("cCisZakaz = '%%'", { ::cCisZakaz} )
    ListHD->( Ads_SetAof( Filter))
  ENDIF
  IsEditGET( 'ListHD->cCisZakaz', ::drgDialog, EMPTY( ::cCisZakaz) )
  LISTHD->( dbGoTOP())
   SetAppFocus( ::dc:oBrowse[ 1]:oXbp)
  ::dc:oBrowse[ 1]:oXbp:refreshAll()
  ::itemMarked()
  ::dc:oBrowse[ ::tabNUM]:oXbp:refreshAll()
RETURN self
*/

** HIDDEN **********************************************************************
METHOD VYR_MListHD_CRD:setFilter( Filter)
  Local aRec := {}

  ListIT->( mh_SetFilter( Filter))
  DO WHILE !ListIt->(Eof())
    IF ListIT->nRokVytvor = ListHD->nRokVytvor
      aadd( aRec, ListIT->( RecNo()))
    ENDIF
    ListIT->( dbSkip())
  ENDDO
  ListIT->( mh_SetFilter( ".F."))
  IF Len( aRec) > 0
    ListIT->(Ads_customizeAOF(aRec, 1))
  ENDIF

RETURN self

* Zkontroluje, zda støedisko zakázky je v konfiguraèním seznamu
** HIDDEN **********************************************************************
METHOD VYR_MListHD_CRD:NazPOL1_OK()
  Local lOK  // , cZak := VyrZAK->cCisZakaz
  Local cMsg := 'Støedisko zakázky < & > není v konfiguraèním seznamu !'

  VyrZak->( dbSeek( Upper( ListHD->cCisZakaz),, 'VYRZAK1'))
  lOK := VYR_StredInCFG( VyrZAK->cNazPol1 )
  IF !lOK
    drgMsgBox(drgNLS:msg( cMsg, ListHD->cCisZakaz ))
  ENDIF
RETURN lOK

*
** HIDDEN **********************************************************************
METHOD VYR_MListHD_CRD:sumColumn( lWrtHD)
  LOCAL nRec   := ListIT->( RecNo())
  local is_Eof := listIT->( eof())

  LOCAL nKusyHotov := 0, nNmNaOpeSk := 0, nNhNaOpeSk := 0, nKcNaOpeSk := 0
  Local arrDef, aItems, x
  * lWrtHD = .F. pøi práci s položkami ListIT ( INS, ENTER, DEL) se neaktualizuje v ListHD skuteènost
  DEFAULT lWrtHD TO .T.

  IF ::tabNUM = tab_LISTIT
    ListIT->( dbGoTOP(),;
              dbEVAL( {|| nKusyHotov += ListIT->nKusyHotov    ,;
                          nKcNaOpeSk += ListIT->nKcNaOpeSk    ,;
                          nNmNaOpeSk += ListIT->nNmNaOpeSk    ,;
                          nNhNaOpeSk += ListIT->nNhNaOpeSk } ) )

    if is_Eof
      listIT->( dbgoTop())
    else
      listIT->(dbgoTo( nrec))
    endif

**    IF( ListIT->( EOF()), ListIT->( dbGoTOP()), ListIT->( dbGoTO(nRec)) )

    aItems := { { 'ListIT->nKusyHotov', nKusyHotov },;
                { 'ListIT->nKcNaOpeSk', nKcNaOpeSk },;
                { 'ListIT->nNmNaOpeSk', nNmNaOpeSk },;
                { 'ListIT->nNhNaOpeSk', nNhNaOpeSk } }
    FOR x := 1 TO LEN( aItems)
      IF ( nPos := AScan( ::broIT:arDef, {|Col| Col[ 2] = aItems[ x, 1] } ) ) > 0
        ::broIT:oXbp:getColumn( nPos):Footing:hide()
        ::broIT:oXbp:getColumn( nPos):Footing:setCell(1, aItems[ x, 2] )
        ::broIT:oXbp:getColumn( nPos):Footing:show()
      ENDIF
    NEXT
    *
    IF lWrtHD
      IF ListHD->( sx_RLock())
        ListHD->nKusyHotov := nKusyHotov
        ListHD->nNmNaOpeSk := nNmNaOpeSk
        ListHD->nNhNaOpeSk := nNhNaOpeSk
        ListHD->nKcNaOpeSk := nKcNaOpeSk
        ListHD->( dbUnlock())
      ENDIF
    ENDIF

  ELSEIF ::tabNUM = tab_POLOPER
  /*
    nRec := PolOper->( RecNO())
    PolOPER->( dbGoTop() ,;
               dbEval( {|| nPriprCas_sum += PolOper->nPriprCas   ,;
                           nKusovCas_sum += PolOper->nCelkKusCa  ,;
                           nKcOper_sum   += PolOper->nKcNaOper   }) ,;
               dbGoTO( nRec))

    ::broOP:oXbp:getColumn(5):Footing:hide()
    ::broOP:oXbp:getColumn(5):Footing:setCell(1, nPriprCas_sum)
    ::broOP:oXbp:getColumn(5):Footing:show()
    ::broOP:oXbp:getColumn(6):Footing:hide()
    ::broOP:oXbp:getColumn(6):Footing:setCell(1, nKusovCas_sum)
    ::broOP:oXbp:getColumn(6):Footing:show()
    ::broOP:oXbp:getColumn(7):Footing:hide()
    ::broOP:oXbp:getColumn(7):Footing:setCell(1, nKcOper_sum)
    ::broOP:oXbp:getColumn(7):Footing:show()
    ::dm:refresh()
    */
    ENDIF
    ::dm:refresh()
RETURN self



********************************************************************************
* Formuláø pro rozdìlení položky mzdového lístku
********************************************************************************
CLASS ROZDELIT_ML FROM drgUsrClass
EXPORTED:
  VAR     nPocetML

  METHOD  getForm, destroy
ENDCLASS

*
********************************************************************************
METHOD ROZDELIT_ML:getForm()
LOCAL drgFC, oDrg
  drgFC  := drgFormContainer():new()
  ::nPocetML := ::drgDialog:cargo

  DRGFORM INTO drgFC SIZE 30,5 DTYPE '0' TITLE 'Rozdìlìní lístku' GUILOOK 'ALL:N'

  DRGGET nPocetML INTO drgFC FPOS 20,1 FLEN 5 FCAPTION 'Poèet nových lístkù:' CPOS 1,1 PICTURE '@N 99'

  DRGPUSHBUTTON INTO drgFC CAPTION 'OK' EVENT drgEVENT_SAVE PRE '0' SIZE 12,1.2 POS 2,3 ;
    ICON1 DRG_ICON_SAVE ICON2 gDRG_ICON_SAVE ATYPE 3
  DRGPUSHBUTTON INTO drgFC CAPTION 'Cancel' EVENT drgEVENT_QUIT PRE '0' SIZE 12,1.2 POS 16,3 ;
    ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ATYPE 3

RETURN drgFC

*
********************************************************************************
METHOD ROZDELIT_ML:destroy()
  ::drgUsrClass:destroy()
  ::nPocetML := ;
                NIL
RETURN

********************************************************************************
* Formuláø pro zaplánování položky mzdového lístku
********************************************************************************
CLASS PLANOVAT_ML FROM drgUsrClass
EXPORTED:

  METHOD  getForm, destroy
ENDCLASS

*
********************************************************************************
METHOD PLANOVAT_ML:getForm()
LOCAL drgFC, oDrg

  drgDBMS:open('LISTITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  mh_COPYFLD('LISTIT', 'LISTITw', .T.)
  ListITw->dVyhotPlan := ::drgDialog:cargo[ 1]
  ListITw->nOsCisPrac := ::drgDialog:cargo[ 2]
  ListITw->cSmena     := ::drgDialog:cargo[ 3]

  drgFC  := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 60,7 DTYPE '0' TITLE 'Plánování lístku' FILE 'ListITw' ;
   GUILOOK 'ALL:N'

  DRGGET ListITw->dVyhotPlan INTO drgFC FPOS 20,1 FLEN 10 FCAPTION 'Plánované vyhotovení' CPOS 1,1
  DRGGET ListITw->nOsCisPrac INTO drgFC FPOS 20,2 FLEN 10 FCAPTION 'Os. èíslo pracovníka' CPOS 1,2 PICTURE '@N 99999'
  DRGTEXT INTO drgFC CPOS 32,2 CLEN 25 NAME MsPrc_MO->cPracovnik PP 2 BGND 13
  DRGGET ListITw->cSmena     INTO drgFC FPOS 20,3 FLEN 10 FCAPTION 'Smìna'                CPOS 1,3 PICTURE '&4X'

  DRGPUSHBUTTON INTO drgFC CAPTION 'OK' EVENT drgEVENT_SAVE PRE '0' SIZE 12,1.2 POS 2,5 ;
    ICON1 DRG_ICON_SAVE ICON2 gDRG_ICON_SAVE ATYPE 3
  DRGPUSHBUTTON INTO drgFC CAPTION 'Cancel' EVENT drgEVENT_QUIT PRE '0' SIZE 12,1.2 POS 16,5 ;
    ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ATYPE 3

RETURN drgFC

*
********************************************************************************
METHOD PLANOVAT_ML:destroy()
  ::drgUsrClass:destroy()
RETURN