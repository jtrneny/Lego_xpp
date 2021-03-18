#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"

#include "..\Asystem++\Asystem++.ch"


*
*****************************************************************
CLASS MZD_odpocpol_CRD FROM drgUsrClass
EXPORTED:
  VAR     ColOBD
  VAR     ColROK

  METHOD  Init
  METHOD  drgDialogInit
  METHOD  drgDialogStart
  METHOD  Destroy
  METHOD  postValidate
  METHOD  onSave
  METHOD  GetInitValues
  METHOD  LeftAction
  METHOD  RightAction
  METHOD  mzd_c_odpoc_sel
  METHOD  fir_firmy_sel

  ** browColumn
  *  c_odpocW
  inline access assign method is_C_odpocet()  var is_C_odpocet
    return if( c_odpocW->lOdpocet, MIS_ICON_OK, 0 )

  inline access assign method is_C_danUleva() var is_C_danUleva
    return if( c_odpocW->ldanUleva, MIS_ICON_OK, 0 )

  * msOdpPolW
  inline access assign method is_M_odpocet()  var is_M_odpocet
    return if( msOdpPolW->lOdpocet, MIS_ICON_OK, 0 )

  inline access assign method is_M_danUleva() var is_M_danUleva
    return if( msOdpPolW->ldanUleva, MIS_ICON_OK, 0 )

  inline access assign method is_M_aktiv()    var is_M_aktiv
    return if( msOdpPolW->laktiv,    MIS_ICON_OK, MIS_NO_RUN )

  inline access assign method sum_odpocOBD() var sum_odpocOBD
    local n_sum := 0

    fordRec( {'msOdpPolW' } )
    msOdpPolW->(dbgoTop(), ;
                dbeval( { || n_sum += if( msOdpPolW->lAktiv                               , ;
                                        ( msOdpPolW->nodpocOBD +msOdpPolW->ndanUlOBD), 0 )} ))
    fordRec()
    return n_sum

  inline access assign method sum_odpocROK() var sum_odpocROK
    local n_sum := 0

    fordRec( {'msOdpPolW' } )
    msOdpPolW->(dbgoTop(), ;
                dbeval( { || n_sum += if( msOdpPolW->lAktiv                               , ;
                                        ( msOdpPolW->nodpocROK +msOdpPolW->ndanUlROK), 0 )} ))
    fordRec()
    return n_sum


  inline method save_marked()
    if ReSUModpocty()
      postAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    endif
  return

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc        := ::drgDialog:dialogCtrl
    LOCAL  dbArea    := ALIAS(SELECT(dc:dbArea))
    *
    local  rok       := msodppolw->nrok
    local  typOdpPol := upper(msOdpPolw->ctypOdpPol)

    if( c_odpocW ->(eof()), ::oBtn_LeftAction:disable() , ::oBtn_LeftAction:enable()  )


    if msOdpPolw->(eof())
      ::oBtn_RightAction:disable()
      ( ::oget_ctypodp:isEdit := .f., ::oget_ctypodp:oxbp:disable() )

    else
      if ::cobdobi_last > msOdpPolw->cobdod
        ::oBtn_RightAction:disable()
        ::oget_dplatnOD:isEdit := ::oget_cobdOD:isEdit := .f.
        ( ::oget_dplatnOD:isEdit := .f., ::oget_dplatnOD:oxbp:disable() )
        ( ::oget_cobdOD:isEdit   := .f., ::oget_cobdOD:oxbp:disable() )

      else
        ::oBtn_RightAction:enable()
        ( ::oget_dplatnOD:isEdit := .t., ::oget_dplatnOD:oxbp:enable() )
        ( ::oget_cobdOD:isEdit   := .t., ::oget_cobdOD:oxbp:enable() )
      endif

      if( rok >= 2015 .and. typOdpPol $ 'DIT1,DIT2,DIT3' )
        ( ::oget_ctypodp:isEdit := .t., ::oget_ctypodp:oxbp:enable() )
      else
        ( ::oget_ctypodp:isEdit := .f., ::oget_ctypodp:oxbp:disable() )
      endif

      if( typOdpPol $ 'STUD' )
        ( ::oget_cisfirmy:isEdit := .t., ::oget_cisfirmy:oxbp:enable() )
        ( ::oget_nazev:isEdit := .t., ::oget_nazev:oxbp:enable() )
      else
        ( ::oget_cisfirmy:isEdit := .f., ::oget_cisfirmy:oxbp:disable() )
        ( ::oget_nazev:isEdit := .f., ::oget_nazev:oxbp:disable() )
      endif


    endif


    DO CASE
    case nEvent = xbeP_Close
      if .not. ReSUModpocty()
        return .t.
      else
        return .f.
      endif

    case nEvent = drgEVENT_REFRESH
      if( oxbp:className() = 'XbpBrowse'   , ::itemMarked(oxbp)             , nil )
      return .f.

    case nEvent = xbeBRW_ItemMarked
      if( oxbp:className() = 'XbpBrowse'   , ::itemMarked(oxbp)             , nil )
      if( oXbp:className() = 'XbpCellGroup', ::itemMarked(oxbp:parent:cargo), nil )
      return .f.

    CASE (nEvent = drgEVENT_EXIT)

    CASE nEvent = drgEVENT_EDIT .and. .not. msOdpPolw->(eof())
      ::df:setNextFocus('MSODPPOLw->ctypOdpPol',, .T. )
      RETURN .T.


    CASE nEvent = drgEVENT_APPEND
      IF ALIAS(dc:dbArea) = 'W_PODRUC'                                          // not for C_PODRUCw
        PostAppEvent(drgEVENT_ACTION, drgEVENT_EDIT,'2',oXbp)
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    CASE nEvent = drgEVENT_DELETE
      IF ALIAS(SELECT(dc:dbArea)) = 'W_PODRUC'                                  // not for C_PODRUCw
        IF drgIsYESNO(drgNLS:msg('Delete record!;;Are you sure?') )
           // smazat a refresch
//           mh_BLANKREC('W_PODRUC',2)
           PostAppEvent(drgEVENT_ACTION,drgEVENT_REFRESH,'1',oXbp)
         ENDIF
       RETURN .T.
      ENDIF
    CASE (nEvent = drgEVENT_QUIT)
      if ReSUModpocty()
        return .F.
      else
        RETURN .T.
      endif

    case( nevent = xbeP_Keyboard )

      if mp1 = xbeK_ESC
        do case
        case oXbp:ClassName() <> 'XbpBrowse'
           SetAppFocus(::obro_2)
           ::obro_2:refreshAll()
           return .t.

        otherwise
          if ReSUModpocty()
            postAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
            return .t.
          endif
        endcase
      endif
      return .f.

    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

HIDDEN:
 VAR   msg, dm, dc, df, ab
 VAR   lNEWrec
 VAR   drgGet
 *
 var   cobdobi_last
 var   oBtn_LeftAction, oBtn_RightAction
 var   obro_1, obro_2
 var   ctypodp
 var   cisFirmy

 var   oget_ctypOdp, oget_nazOdpPol, oget_cisFirmy, oget_nazev, oget_dplatnOD, oget_cobdOD

 inline method itemMarked(oxbp)
    local  o_msg := ::msg:msgStatus, oPS
    local  c_file := ::dc:oaBrowse:cfile
    local  n_cisOsoRP
    *
    local curSize  := o_msg:currentSize()
    local pa       := { GraMakeRGBColor({ 78,154,125}), ;
                        GraMakeRGBColor({157,206,188})  }
    *
    local  oFont := XbpFont():new():create( "10.Arial Bold CE" )
    local  aAttr := ARRAY( GRA_AS_COUNT )


    if isObject(oxbp)
      o_msg:setCaption( '' )
      oPS := o_msg:lockPS()

      GraSetFont( oPS, oFont )
*      aAttr [ GRA_AS_COLOR     ] := GRA_CLR_RED
*      GraSetAttrString( oPS, aAttr )

*      GraGradient( ops               , ;
*                 { 2,2 }           , ;
*                 { curSize }, pa, GRA_GRADIENT_HORIZONTAL)

      if ( n_cisOsoRP := (c_file)->ncisOsoRP ) <> 0
        osoby->( dbseek( n_cisOsoRP,, 'OSOBY01' ))
        GraStringAt( oPS, {   4, 4}, osoby->cjmenoRozl )
      endif

      o_msg:unlockPS()
    endif
  return

ENDCLASS

*
*****************************************************************
METHOD MZD_odpocpol_CRD:init(parent)
  LOCAL nEvent,mp1,mp2,oXbp
  LOCAL cKEYs  := ' '
  LOCAL lDOPLN := .T.
  LOCAL lGENrec
  LOCAL x

  drgDBMS:open( 'ucetsys' )
  drgDBMS:open( 'c_odpoc',,,,,'c_odpocR')

***  _cpyMSODPPOL()

  ::drgUsrClass:init(parent)
  ::lNEWrec      := .T.
  ::drgGet       := NIL
  ::cobdobi_last := uctOBDOBI_LAST:MZD:cobdobi

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))
  IF parent:cargo = drgEVENT_EDIT
    cKy     := STRZERO(MSPRC_MOw->nRok,4) +STRZERO(MSPRC_MOw->nObdobi,2)           ;
                +STRZERO(MSPRC_MOw->nOsCisPrac,5) +STRZERO(MSPRC_MOw->nPorPraVzt,3)
    ::lNEWrec := .F.
  ENDIF
RETURN self



METHOD MZD_odpocpol_CRD:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*  drgDialog:hasIconArea := drgDialog:hasActionArea := ;
*  drgDialog:hasMsgArea  := drgDialog:hasMenuArea   := drgDialog:hasBorder := .F.
*  XbpDialog:titleBar    := .F.

  drgDialog:dialog:drawingArea:bitmap  := 1016
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED


  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN


METHOD MZD_odpocpol_CRD:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers
  local  lOk     := ( LAST_OBDn( 'M') = strZero(msprc_moW->nrok,4) +strZero(msprc_moW->nobdobi,2))
  local  cfiltr

  * NEWs *
  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager
  ::dc     := drgDialog:dialogCtrl              // dataCtrl
  ::df     := drgDialog:oForm                   // dialogForm
* nemá   ::ab     := drgDialog:oActionBar:members      // actionBar

  ::obro_1 := ::dc:obrowse[1]:oxbp
  ::obro_2 := ::dc:obrowse[2]:oxbp

  for x := 1 TO Len(members) step 1
    if members[x]:ClassName() = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case members[x]:event = 'LeftACTION'  ;  ::obtn_leftACTION  := members[x]
        case members[x]:event = 'RightACTION' ;  ::obtn_rightACTION := members[x]
        endcase
      endif
    endif
  next

  if isObject(::obtn_rightACTION) .and. .not. lOk
    ::obtn_rightACTION:disable()
  endif

  msOdppolW->( OrdSetFocus('MSODPPOW03'), dbgoTop() )

  ::ctypOdp       := ::dm:get( 'MSODPPOLw->ctypodppol', .F.)

  ::oget_ctypOdp   := ::dm:has( 'MSODPPOLw->ctypodppol'):odrg
  ::oget_nazOdpPol := ::dm:has( 'msOdpPolW->cnazOdpPol'):odrg
  ::oget_nazOdpPol:isEdit := .f.

  ::cisFirmy  := ::dm:get( 'MSODPPOLw->ncisfirmy', .F.)

  ::oget_cisFirmy  := ::dm:has( 'msOdpPolW->ncisFirmy'):odrg
  ::oget_nazev     := ::dm:has( 'msOdpPolW->cnazev'):odrg


  ::oget_dplatnOD  := ::dm:has( 'MSODPPOLw->dPlatnOD'  ):odrg
  ::oget_cobdOD    := ::dm:has( 'MSODPPOLw->cObdOD'    ):odrg

  ::sum_odpocOBD()
  ::sum_odpocROK()
RETURN

*
*****************************************************************
METHOD MZD_odpocpol_CRD:postValidate(drgVar)
  LOCAL cName    := drgVar:Name
  LOCAL xVar     := drgVar:get()
  Local lNewRec  := ::drgDialog:dialogCtrl:isAppend
  Local lChanged := drgVar:changed()
  Local dm       := ::drgDialog:dataManager
  Local aValues  := dm:vars:values
  LOCAL lRefreshALL := .T.
  LOCAL lFound, cKey, xX, nFs, cobd
  local ok := .t.
  local oldRec
  local typOdp := ''


// kotroly a výpoèty
// nastavení doprovodných textù u nejednoznaèných položek

  IF lNewRec .OR. lChanged
    DO CASE
    CASE cName = 'MSODPPOLw->cTypOdpPol'
      ok := ::mzd_c_odpoc_sel()

      c_odpoc ->( dbSeek( StrZero( msodppolw->nrok,4) +Upper( xVar),,'C_ODPOC04'))
      msodppolw->nDanUlOBD := c_odpoc->nDanUlOBD
      msodppolw->nDanUlROK := c_odpoc->nDanUlROK

    CASE cName = 'MSODPPOLw->ncisFirmy'
      ok := ::fir_firmy_sel()

    CASE cName = 'MSODPPOLw->dPlatnOD'

      nFs := AScan(aValues, {|X| X[1] $ Lower("MSODPPOLw->cObdOD")})
      oVar         := dm:vars:getNth(nFs)
      oVar:Value   := COBDzDAT(xVar)
      oVar:refresh()
      MSODPPOLw->cObdOD := COBDzDAT(xVar)

    CASE cName = 'MSODPPOLw->dPlatnDO'

      cobd := if( empty(xvar), '12' +right( uctOBDOBI:MZD:cobdobi,3), COBDzDAT(xVar) )

      ::dm:set( 'msOdppolW->cObdDO', cobd )
      msOdppolW->cObdDO := cobd
      msOdppolW->laktiv := .f.
      if (year( xvar) *100 +month( xvar)) < ;
           (uctOBDOBI:MZD:nROK*100 +uctOBDOBI:MZD:nOBDOBI) .and. .not. Empty(xvar) .and.  ;
             .not. c_OdpocW->( dbseek( msOdppolW->nCisOsoRP,,'C_ODPOCw02'))
        mh_COPYFLD( 'MSODPPOLw', 'C_ODPOCw', .T.)
        ReTYPdite( , .t.)
        ::obro_1:goTop():refreshAll()
        ::obro_2:refreshCurrent()
        ::obro_2:goBottom():refreshAll()
      endif
    ENDCASE

    if ok
      dm:save()
      dm:refresh(.T.)
    endif

    if (year( msOdppolW->dplatnDo) *100 +month( msOdppolW->dplatnDo)) >= ;
       (uctOBDOBI:MZD:nROK*100 +uctOBDOBI:MZD:nOBDOBI) .or. empty( msOdppolW->dplatnDo)
      msOdppolW->laktiv := .t.

/*
      if Left(msOdppolW->ctypodppol,3) = 'DIT' .and. msOdppolW->ctypodppol <> 'DIT1'
        oldRec := msOdppolW->( Recno())
        do case
        case msOdppolW->ctypodppol = 'DIT2'
          typOdp := if( .not. msOdppolW->( dbseek( 'DIT11',,'MsOdpPoW05')), 'DIT1', '')

        case msOdppolW->ctypodppol = 'DIT3'
          typOdp := if( .not. msOdppolW->( dbseek( 'DIT11',,'MsOdpPoW05')), 'DIT1', '')
          typOdp := if( .not. msOdppolW->( dbseek( 'DIT21',,'MsOdpPoW05')) .and. typOdp = '', 'DIT2', '')
        endcase

        msOdppolW->( dbGoTo( oldRec))
        if typOdp <> ''
          if c_odpoc ->( dbSeek( StrZero( msodppolw->nrok,4) +Upper( typOdp),,'C_ODPOC04'))
            msOdppolW->ctypodppol := c_odpocR ->ctypodppol
            msOdppolW->nDanUlObd  := c_odpocR ->nDanUlObd
            msOdppolW->nDanUlRok  := c_odpocR ->nDanUlRok
          endif
        endif
      endif
*/

      ReTYPdite( , .t.)
      ::obro_1:goTop():refreshAll()
    endif
    ::obro_2:refreshCurrent()
  ENDIF
RETURN ok


*
*****************************************************************
METHOD MZD_odpocpol_CRD:onSave(lIsCheck,lIsAppend)                                 // kotroly a výpoèty po uložení
  LOCAL  dc       := ::drgDialog:dialogCtrl
  LOCAL  cALIAs   := ALIAS(dc:dbArea)

  IF !lIsCheck

//    IF (cALIAs) ->nCISFIRMY == 0
//      (cALIAs) ->nCISFIRMY := FIRMYw ->nCISFIRMY
//    ENDIF
  ENDIF
RETURN .T.


METHOD MZD_odpocpol_CRD:destroy()

  ReSUModpocty()
RETURN SELF


*
*********FIRMY_FIRMYUC_FIRMYFI_FIRMYDA_CPODRUC**********************************
STATIC FUNCTION MzODPOCPOL_WRT(lNEWrec)
  LOCAL  nCISFIRMY := FIRMYw ->nCISFIRMY
RETURN .T.


METHOD MZD_odpocpol_CRD:GetInitValues(oComboBox)
  Local  cTYPfak := ''
RETURN( cTYPfak)



method MZD_odpocpol_CRD:mzd_c_odpoc_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  local  cfiltr, ok := .f.
  local  typOdpPol := upper(::oget_ctypOdp:oVar:get())
  *
  **
  if msodppolw->nrok >= 2015 .and. ( typOdpPol $ 'DIT1,DIT2,DIT3' )
    cfiltr := "nrok = %% .and. Left(ctypodppol,3) = 'DIT'"
    cfiltr := format( cfiltr, {msprc_mow->nrok})

    c_odpoc->( ads_setaof(cfiltr), dbGoTop())
    ok := c_odpoc->( dbseek( upper( typOdpPol),,'C_ODPOC02'))
    if( .not. ok , c_odpoc->( dbgoTop()), nil )
  endif

  if IsObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'MZD_C_ODPOC_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                     EXITSTATE nExit
  endif


  if (ok .and. ::oget_ctypOdp:oVar:itemChanged())
  elseif nexit = drgEVENT_SAVE
    ok := .t.
  endif

  if ok
    ::oget_ctypOdp:oVar:set( c_odpoc->ctypodppol, .t. )
    ::oget_nazOdpPol:oVar:set(c_odpoc->cnazOdpPol, .t.)
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,::oget_ctypOdp:oXbp)
  endif
return ok



method MZD_odpocpol_CRD:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  local  cfiltr, ok := .f.
  local  typOdpPol := upper(::oget_ctypOdp:oVar:get())
  local  cisFirmy := ::oget_cisFirmy:oVar:get()
  *
  **

  if ( typOdpPol $ 'STUD' )
//    c_odpoc->( ads_setaof(cfiltr), dbGoTop())
    ok := firmy->( dbseek( cisFirmy,,'FIRMY1'))
    if( .not. ok , firmy->( dbgoTop()), nil )
  endif

  if IsObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                             EXITSTATE nExit

  endif


  if (ok .and. ::oget_cisfirmy:oVar:itemChanged())
  elseif nexit = drgEVENT_SAVE .or. nexit = 140000000   //drgEVENT_EDIT
    ok := .t.
  endif

  if ok
    ::oget_cisfirmy:oVar:set( firmy->ncisfirmy, .t. )
    ::oget_nazev:oVar:set(firmy->cnazev, .t.)
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,::oget_cisfirmy:oXbp)
  endif                                                   $
return ok




METHOD MZD_odpocpol_CRD:LeftACTION()
  LOCAL dm := ::drgDialog:dataManager
  LOCAL dc := ::drgDialog:dialogCtrl
  LOCAL rest
  LOCAL nID
  local recNo := msOdpPolw->(recNo())

  MSODPPOLw ->( DbGoBottom())
  nID := MSODPPOLw ->nPorOdpPol +1
  msOdpPolw->(dbGoTo( recNo))

  mh_copyFld( 'msprc_moW', 'msOdpPolW', .t.)
  mh_COPYFLD( 'C_ODPOCw' , 'MSODPPOLw'     )

  MSODPPOLw->dPlatnOD := mh_FirstODate( uctOBDOBI:MZD:nROK, uctOBDOBI:MZD:nOBDOBI)
  MSODPPOLw->cObdOD   := COBDzDAT(MSODPPOLw->dPlatnOD)
  MSODPPOLw->cObdDO   := '12' +right( uctOBDOBI:MZD:cobdobi,3)

  MSODPPOLw ->nPorOdpPol := nID
  msOdpPolW->lAktiv      := .t.

  msOdpPolW->_nrecOr     := 0

  ReTYPdite()

  C_ODPOCw ->(Ads_DeleteRecord())
*  C_ODPOCw ->( dbDelete())

  if( ::obro_1:rowPos = 1, ::obro_1:goTop(), nil )

  ::obro_1:panhome():forcestable()
  ::obro_1:refreshAll()
  ::obro_2:goBottom():refreshAll()

  setAppFocus( ::obro_1 )
  ::itemMarked( ::obro_1 )

  ::sum_odpocOBD()
  ::sum_odpocROK()
  dm:refresh()
RETURN .T.


METHOD MZD_odpocpol_CRD:RightACTION()
  LOCAL dm := ::drgDialog:dataManager
  LOCAL dc := ::drgDialog:dialogCtrl
  LOCAL restRec := .t.
  local oldRec, recOld
  local typOdp

  mh_COPYFLD( 'MSODPPOLw', 'C_ODPOCw', .T.)

  msOdpPolW->_delrec := '9'
  if msOdpPolW->_nrecor = 0

    msOdpPolW->( Ads_DeleteRecord())
*    msOdpPolW->( dbdelete())
    restRec := .f.
  endif

  if .not. restRec
    recOld := msOdppolW->( Recno())
    msOdppolW->( dbGoTop())
    do while .not. msOdppolW->( Eof())
      if msOdppolW->laktiv
        if Left(msOdppolW->ctypodppol,3) = 'DIT' .and. msOdppolW->ctypodppol <> 'DIT1'
          oldRec := msOdppolW->( Recno())
          do case
          case msOdppolW->ctypodppol = 'DIT2'
            typOdp := if( .not. msOdppolW->( dbseek( 'DIT11',,'MsOdpPoW05')), 'DIT1', '')

          case msOdppolW->ctypodppol = 'DIT3'
            typOdp := if( .not. msOdppolW->( dbseek( 'DIT11',,'MsOdpPoW05')), 'DIT1', '')
            typOdp := if( .not. msOdppolW->( dbseek( 'DIT21',,'MsOdpPoW05')) .and. typOdp = '', 'DIT2', '')
          endcase

          msOdppolW->( dbGoTo( oldRec))
          if typOdp <> ''
            if c_odpocR ->( dbSeek( StrZero( msodppolw->nrok,4) +Upper( typOdp),,'C_ODPOC04'))
              msOdppolW->ctypodppol := c_odpocR ->ctypodppol
              msOdppolW->nDanUlObd  := c_odpocR ->nDanUlObd
              msOdppolW->nDanUlRok  := c_odpocR ->nDanUlRok
            endif
          endif
        endif
      endif
      msOdppolW->( dbSkip())
    enddo
  endif
//msOdppolW->( dbGoTo( recOld))

  ReTYPdite( restRec)

  if( ::obro_2:rowPos = 1, ::obro_2:goTop(), nil )
  ::obro_2:refreshAll()
  ::obro_1:goTop():refreshAll()

  setAppFocus( ::obro_2 )
  ::itemMarked( ::obro_2 )

  ::sum_odpocOBD()
  ::sum_odpocROK()
  dm:refresh()

RETURN .T.


FUNCTION ReTYPdite(restMsO, noaction)
  local filtr
  local recCis := c_odpocW->( recno())
  local rec    := msOdppolW->( recno())
  local ldel   := .f.

  default restMsO to .t.
  default noaction  to .f.

  cfiltr := "nrok = %% .and. Left(ctypodppol,3) = 'DIT'"
  cfiltr := format( cfiltr, {msprc_mow->nrok})

  c_odpocR->( ads_setaof(cfiltr), dbGoTop())

  do case
  case .not. msOdppolW->( dbseek( 'DIT11',,'MsOdpPoW05'))
    c_odpocR->( dbseek( 'DIT1',,'C_ODPOC02'))
  case .not. msOdppolW->( dbseek( 'DIT21',,'MsOdpPoW05'))
    c_odpocR->( dbseek( 'DIT2',,'C_ODPOC02'))
  otherwise
    c_odpocR->( dbseek( 'DIT3',,'C_ODPOC02'))
  endcase

  c_odpocW ->( dbGoTop())
  do while .not. c_odpocW ->( Eof())
    if Left(c_odpocW ->ctypodppol,3) = 'DIT'
      if msOdppolW->( dbseek( StrZero( c_odpocW->nCisOsoRP,6)+'1',,'MsOdpPoW06')) .and. noaction

        c_odpocW->( Ads_DeleteRecord())
*        c_odpocW ->( dbDelete())
        ldel := .t.
      else
        c_odpocW ->ctypodppol := c_odpocR ->ctypodppol
        c_odpocW ->nDanUlObd  := c_odpocR ->nDanUlObd
        c_odpocW ->nDanUlRok  := c_odpocR ->nDanUlRok
      endif
    endif
    c_odpocW ->( dbSkip())
  enddo

  if( ldel, c_odpocW->( dbGoTop()), c_odpocW->( dbGoto(recCis)))
//  if( c_odpocW->( Deleted()), c_odpocW->( dbSkip(-1)), nil)

  if( restMsO, msOdppolW->( dbGoto(rec)), nil)
//  if( msOdppolW->( Deleted()), msOdppolW->( dbSkip(-1)), nil)

RETURN .T.

FUNCTION RetCOLcisOBD()
  RETURN( if( c_odpocW->( eof()), 0, IF( C_ODPOCw->lODPOCET, C_ODPOCw->nOdpocOBD, C_ODPOCw->nDanUlOBD)) )

FUNCTION RetCOLcisROK()
  RETURN( if( c_odpocW->( eof()), 0, IF( C_ODPOCw->lODPOCET, C_ODPOCw->nOdpocROK, C_ODPOCw->nDanUlROK)) )

FUNCTION RetCOLmsOBD()
  RETURN( if( msOdpPolW->( eof()), 0, IF( MSODPPOLw->lODPOCET, MSODPPOLw->nOdpocOBD, MSODPPOLw->nDanUlOBD)) )

FUNCTION RetCOLmsROK()
  RETURN( if( msOdpPolW->( eof()), 0, IF( MSODPPOLw->lODPOCET, MSODPPOLw->nOdpocROK, MSODPPOLw->nDanUlROK)) )

FUNCTION ReSUModpocty()
  local  n_DITE1 := 0, n_DITE2 := 0
  local  recNo   := msOdpPolw->(recNo())

  local  ctitle := 'Možná chyba u nastavení daòové úlevy na dìti'
  local  cinfo  := 'Upozornìní,'                                +CRLF + ;
                   'u nastavení daòové úlevy na dìti'           +CRLF + ;
                   'existují dvì shodná poøadí u 1 nebo 2 dítìte ... ' +CRLF


  if msodppolw->nrok >= 2015
    msOdpPolW->( dbgoTop())
    do while .not. msOdpPolW->( eof())
      if     upper(msOdpPolW->ctypOdpPol) = 'DIT1' .and. msOdpPolW->lAktiv
        n_DITE1 += 1
      elseif upper(msOdpPolW->ctypOdpPol) = 'DIT2' .and. msOdpPolW->lAktiv
        n_DITE2 += 1
      endif
      msOdpPolW->(dbskip())
    enddo

    if n_DITE1 > 1 .or. n_DITE2 > 1
      confirmBox( , cinfo, ctitle, ;
                    XBPMB_CANCEL , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

      msOdpPolW->( dbgoTo( recNo))
//      return .f.
    endif
  endif

  MSPRC_MOw ->nOdpocOBD := 0
  MSPRC_MOw ->nOdpocROK := 0
  MSPRC_MOw ->nDanUlOBD := 0
  MSPRC_MOw ->nDanUlROK := 0
  MSODPPOLw ->( dbGoTop()                                                     , ;
                dbEval({|| if( msOdpPolW->lAktiv                              , ;
                             ( MSPRC_MOw ->nOdpocOBD += MSODPPOLw ->nOdpocOBD , ;
                               MSPRC_MOw ->nOdpocROK += MSODPPOLw ->nOdpocROK , ;
                               MSPRC_MOw ->nDanUlOBD += MSODPPOLw ->nDanUlOBD , ;
                               MSPRC_MOw ->nDanUlROK += MSODPPOLw ->nDanUlROK ), nil ) }) )
RETURN .t.