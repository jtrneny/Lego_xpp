#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"



FUNCTION FIN_POKLADMS_BC(nCOLUMn)
  local  cky     := strZero(pokladmS->npokladna,3)
  local  xRETval := 0

  DO CASE
  CASE( nCOLUMn =  1)

    if pokladhd->( dbseek(cky,,'POKLADH2')) .or. poklhd->( dbseek(cky,,'POKLHD2'))
      xretVal := MIS_BOOKOPEN
    endif
  ENDCASE
RETURN xRETval


**
** CLASS for FIN_pokladms_IN ***********************************************
CLASS FIN_pokladms_IN FROM drgUsrClass
exported:
  *
  ** název promìnné pro sekci komunikace
  var     csection, mDefin_kom

  var     AKT_datum
  method  init, drgDialogStart, postValidate, postLastField
  method  comboBoxInit, comboItemSelected

  * bro col for pokladms
  inline access assign method isDatKomE() var isDatKomE
    local  is_IdDatKomE := .not. empty(pokladms->cIdDatKomE)
    local  is_defin_kom := .not. empty(pokladms->mdefin_kom)
    local  retVal     := 0

    do case
    case ( is_IdDatKomE .and.       is_defin_kom )
      retVal := 556   //  m_zelena.bmp

    case ( is_IdDatKomE .and. .not. is_defin_kom )
      retVal := 555   //  m_Zluta.bmp
    endCase
    return retVal


  inline access assign method isDatKomI() var isDatKomI
    return if( .not. empty(c_bankuc->cIdDatKomI), 505, 0 )


  inline access assign method pokl_inDPH() var pokl_inDPH
     return if( pokladms->lno_inDPH, 301, 0 )  // MIS_ICON_ERR


  inline method set_datkomE()
    local idDatKomE := allTrim(::dm:get( 'pokladms->ciddatkome'))

    ::csection  := 'ciddatkome'
    ::sel_datkomhd_usr(idDatKomE)
  return self

  inline method set_datkomI()
    local idDatKomI := allTrim(::dm:get( 'pokladms->ciddatkomi'))

    ::csection  := 'import'
    ::sel_datkomhd_usr(idDatKomI)
  return self

  *
  ** karta
  inline access assign method zaklMena() var zaklMena
    return SysConfig('Finance:cZaklMena')

  inline method set_typUhrady(isEdit)
    default isEdit to .f.

    if( isEdit,( ::ocmb_typUhrady:isEdit := .t., ::ocmb_typUhrady:oxbp:enable()  ), ;
               ( ::ocmb_typUhrady:isEdit := .f., ::ocmb_typUhrady:oxbp:disable() )  )
  return self

  inline method pocstTuz(isTuz)
    if( isTuz, (::pocTuz:isEdit := .f.,::pocTuz:oxbp:disable()), ;
               (::pocTuz:isEdit := .t.,::pocTuz:oxbp:enable() )  )
  return nil

  *
  ** BUTTON pro ctypPohybu
  inline method createContext()
    local  pa_context := { { '', '', '' } }, opopup
    local  x, aPos, aSize
    *
    local  ky := if( left(::dm:get('pokladms->ctypPoklad'),3) = 'FIN', F_POKLADNA, E_REGPOKLADNA )

    c_typpoh->(dbsetscope(SCOPE_BOTH,ky), dbgotop())
    do while .not. c_typpoh ->(eof())
      aadd( pa_context, { c_typpoh ->cnaztyppoh , ;
                          c_typpoh ->ctyppohybu , ;
                          c_typpoh ->ctypdoklad   } )
      c_typpoh->(dbskip())
    enddo
    c_typpoh ->(dbclearscope())

    if len(pa_context) > 0
      opopup         := XbpImageMenu( ::drgDialog:dialog ):new()
      opopup:barText := '' // 'docházka'
      opopup:create()

      for x := 1 to len(pa_context) step 1
        opopup:addItem( {pa_context[x,1]                       , ;
                         de_BrowseContext(self,x,pa_context[x]), ;
                                                               , ;
                              XBPMENUBAR_MIA_OWNERDRAW        }, ;
                        if( x = 1, 0, 0)                         )
      next

      aPos    := ::obtn_typPohybu:oXbp:currentPos()
      aSize   := ::obtn_typPohybu:oXbp:currentSize()
      opopup:popup( ::obtn_typPohybu:oxbp:parent, { apos[1] -21, apos[2] } )
    endif
  return self

  inline method fromContext(aorder,p_popUp, lin_Start)

    ::obtn_typPohybu:oxbp:setCaption( allTrim( p_popUp[1]))
*    ::obtn_typPohybu:oxbp:SetGradientColors( p_popUp[3]   )

    ::dm:set('pokladms->ctypPohybu', p_popUp[2] )
    ::dm:set('pokladms->ctypDoklad', p_popUp[3] )

    ::drgDialog:oForm:setNextFocus('POKLADMS->CIDDatKomE',, .T. )
  return self

  inline method restColor()
    local members := ::df:aMembers

    oxbp := setAppFocus()
    aeval(members, {|X| if(ismembervar(x,'clrFocus'), x:oxbp:setcolorbg(x:clrfocus), nil) })
    return .t.

  *
  ** EVENT *********************************************************************
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  nRECs, lUSEd
    LOCAL  dc     := ::drgDialog:dialogCtrl
    *
    local  sid    := isNull(pokladms->sid, 0)
    local  culoha := if( sid = 0, ' ', if( left(pokladms->ctypPoklad,3) = 'FIN', 'F', 'E') )
    local  cky    := culoha +pokladms->ctypDoklad +pokladms->ctypPohybu

    c_typPoh->( dbseek( cky,, 'C_TYPPOH05' ))

    DO CASE
    CASE (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      ::restColor()

      ::dm:refresh()

      ::nState := 0
      ::showGroup()

      ::pocstTuz(pokladms->czkratmeny = ::zaklMena)
      ::set_typUhrady( culoha = 'E' )
      ::obtn_typPohybu:oxbp:setCaption(allTrim(c_typpoh ->cnaztyppoh))
      RETURN .F.

    CASE nEvent = drgEVENT_EDIT
      ::nState := 1
      ::drgDialog:oForm:setNextFocus('pokladms->npokladna',, .T. )
      RETURN .T.

    case nEvent = drgEVENT_SAVE
      ::postLastField()
      return .t.

    CASE nEvent = drgEVENT_APPEND
      ::dm:refreshAndSetEmpty( 'pokladms' )

      ::dm:set('pokladms->cjmenopokl', SysConfig('SYSTEM:cUSERNAM'  ))
      ::dm:set('pokladms->czkratmeny', SysConfig('FINANCE:cZAKLMENA'))
      ::dm:set('pokladms->dpocstav'  , Date()                        )
      ::dm:set('M->zaklMena'         , SysConfig('FINANCE:cZAKLMENA'))

      ::nState := 2
      ::showGroup()

      ::pocstTuz(.t.)
      ::set_typUhrady()
      ::obtn_typPohybu:oxbp:setCaption('')

      ::showMena( SysConfig('FINANCE:cZAKLMENA'))
      ::drgDialog:oForm:setNextFocus('pokladms->ctypPoklad',, .T. )
      RETURN .T.

    CASE nEvent = drgEVENT_DELETE
      lUSEd := .not. Empty(FIN_POKLADMS_BC(1))

      IF     lUSEd ; drgMsgBox('Pokladna je POUŽITA, nelze zrušit ...')
      ELSEIF drgIsYESNO(drgNLS:msg('Zkušit nastavení pokladny < & > ?', POKLADMS ->nPOKLADNA))
       IF( POKLADMS ->(DbRLock()), ( POKLADMS ->(DbDelete()), ::bro:refresh()), ;
                                   drgMsgBox('Nelze uložit zmìny, BLOKOVÁNO uživatelem ...') )
      ENDIF

      POKLADMS ->( DbUnlock())
      RETURN .T.

    CASE nEvent = xbeP_Keyboard
      if oXbp:ClassName() = 'XbpImageButton'
        do case
        case mp1 = xbeK_ENTER
          ::drgDialog:oForm:setNextFocus('POKLADMS->CIDDatKomE',, .T. )
          return .t.
        case mp1 = xbeK_ALT_DOWN
          ::createContext()
        endcase
      endif

      IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
        ::nState := 0
        IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
          oXbp:setColorBG( oXbp:cargo:clrFocus )
        ENDIF

        SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
        IF(::nState = 2, ::bro:oXbp:GoTop():refreshAll(), ::bro:refresh())
        ::dm:refresh()
        ::showGroup()
        PostAppEvent(xbeBRW_ItemMarked,,,::bro:oXbp )
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.


HIDDEN:
  VAR     nState      // 0 - inBrowse  1 - inEdit  2 - inAppend
  VAR     msg, dm, df, bro, memb, pocTuz

  var     odrgVar_defin_kom, tmp_Dir
  var     ocmb_typPoklad, ocmb_typUhrady, obtn_typPohybu, obtn_datkomE, obtn_datkomI

  METHOD  showGroup, showMena, sel_datkomhd_usr

  inline method enable_datkom()
    local idDatKomE := allTrim(::dm:get( 'pokladms->ciddatkome'))
*    local idDatKomI := allTrim(::dm:get( 'c_bankuc->ciddatkomi'))

    if( empty(idDatKomE), ::obtn_datkomE:oxbp:disable(), ::obtn_datkomE:oxbp:enable() )
*    if( empty(idDatKomI), ::obtn_datkomI:oxbp:disable(), ::obtn_datkomI:oxbp:enable() )
    return self

ENDCLASS


METHOD FIN_pokladms_IN:init(parent)
  ::drgUsrClass:init(parent)

  ::AKT_datum := Date()
  ::nState    := 0
  ::tmp_Dir := drgINI:dir_USERfitm +userWorkDir() +'\'

  drgDBMS:open('DATKOMHD')
  drgDBMS:open('POKLADHD')  // finanèní    pokladna
  drgDBMS:open('POKLHD'  )  // registraèní pokladna
  drgDBMS:open('KURZIT'  )

  drgDBMS:open('c_typUhr')
  drgDBMS:open('c_typPoh')
RETURN self


METHOD FIN_pokladms_IN:drgDialogStart(drgDialog)
  local  x, members  := drgDialog:oForm:aMembers
  local  nbro_Focus
  local  pa_groups, acolors  := MIS_COLORS
  *
  local  ocmb_no_inDph, ocmb_idDATkomE

  ::msg  := drgDialog:oMessageBar
  ::dm   := drgDialog:dataManager
  ::df       := drgDialog:oForm                   // form
  ::memb := drgDialog:oForm:amembers

  ::odrgVar_defin_kom := ::dm:has('pokladms->mdefin_kom')

  BEGIN SEQUENCE
    FOR x := 1 TO LEN(members)
      IF members[x]:ClassName() = 'drgDBrowse'
        ::bro      := members[x]
        nbro_Focus := x
  BREAK
      ENDIF
    NEXT
  ENDSEQUENCE

  for x := 1 TO Len(members) step 1
    do case
    case members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
         pa_groups := ListAsArray(members[x]:groups)
         nin       := ascan(pa_groups,'SETFONT')

        members[x]:oXbp:setFontCompoundName(pa_groups[nin +1])

         if 'GRA_CLR' $ atail(pa_groups)
           if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
             members[x]:oXbp:setColorFG(acolors[nin,2])
           endif
         else
           members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
         endif
       endif

    case members[x]:ClassName() = 'drgPushButton'
      do case
      case members[x]:event = 'createContext'     ;  ::obtn_typPohybu := members[x]
      case members[x]:event = 'set_datkomE'       ;  ::obtn_datkomE   := members[x]
      case members[x]:event = 'set_datkomI'       ;  ::obtn_datkomI   := members[x]
      endcase
    endcase
  next

  ::ocmb_typPoklad := ::dm:has('pokladms->ctypPoklad'):odrg
    ocmb_no_inDph  := ::dm:has('pokladms->lno_inDph' ):odrg
  ::ocmb_typUhrady := ::dm:has('pokladms->czkrTypURP'):odrg
    ocmb_idDATkomE := ::dm:has('pokladms->cidDATkomE'):odrg
  *
  ** na xbpCombo vypneme visuální styl, je to blbì vidìt na focusu
  ::ocmb_typPoklad:oxbp:useVisualStyle := .f.
    ocmb_no_inDph:oxbp:useVisualStyle  := .f.
  ::ocmb_typUhrady:oxbp:useVisualStyle := .f.
    ocmb_idDATkomE:oxbp:useVisualStyle := .f.

  ::pocTuz         := ::dm:has('pokladms->npocst_tuz'):odrg
  ::obtn_typPohybu:oXbp:setFont(drgPP:getFont(5))

  IF( .not. POKLADMS ->(Eof()), drgDialog:oForm:nextFocus := nbro_Focus, NIL )
  ::dm:refresh()
RETURN self


method FIN_pokladms_in:comboBoxInit(drgComboBox)
  local  cname  := lower(drgComboBox:name)
  local  onSort := 1
  local  acombo_val := { { '          ', space(50) } }
  *
  if ( 'ciddatkom' $ cname )
    acombo_val := { { '          ', space(50) } }

    datkomhd->( ordSetFocus( 'DATKOMH09')           , ;
                DbSetScope( SCOPE_BOTH, 'FINEET_E' ), ;
                DbGoTop()                             )

    do case
    case ( 'ciddatkome' $ cname )
      datkomhd->( dbeval( { || aadd( acombo_val, { datkomhd->cidDatKom, datkomhd->cnazDatKom }) } ))

    case ( 'ciddatkomi' $ cname )
    endcase

    datkomhd->( dbClearScope())

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[onSort] < aY[onSort] } )
    AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgComboBox:value := drgComboBox:ovar:value
    drgComboBox:refresh()
  endif

  if ( 'czkrtypurp' $ cname )
    aCombo_val := {{ '    ', Space(50) }}
    c_typUhr->( dbEval( { || aadd( acombo_val, { c_typuhr->czkrTypUhr, c_typuhr->cpopisUhr +'(' +c_typuhr->czkrTypUhr +')' }) }, ;
                        { || c_typuhr->lisRegPok  } ) )

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[onSort] < aY[onSort] } )
    AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
  endif
return self


method FIN_pokladms_in:ComboItemSelected(drgComboBox)
  local  cname := lower(drgComboBox:name)
  local  value

  if ( 'ciddatkom' $ cname )
    ::enable_datkom()
  endif

  if ( 'ctyppoklad' $ cname )
    if( left(drgComboBox:Value,3) = 'PRO', ::ocmb_typUhrady:oxbp:enable(), ::ocmb_typUhrady:oxbp:disable() )
  endif
return self


method FIN_pokladms_in:postValidate(drgVar)
  local  value   := drgVar:get()
  local  name    := lower(drgVar:name)
  local  changed := drgVAR:itemChanged()
  *
  local  pocStav   := ::dm:get('pokladms->npocStav'  )
  local  zkratMeny := ::dm:get('pokladms->czkratMeny')
  local  pocST_tuz := ::dm:has('pokladms->npocST_tuz')
  local  aktStav   := ::dm:has('pokladms->naktStav')
  local  pa        := {'pokladms->npocStav', 'pokladms->nposPrijem', 'pokladms->nposVydej'}
  local  nevent    := mp1 := mp2 := nil, isF4 := .F., nkoe
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case( name = 'pokladms->npocstav' )
    if zkratMeny = ::zaklMena
      pocST_tuz:set( value )
    endif

  case(name = 'pokladms->czkratmeny' .and. changed)
    ::pocstTuz(value = ::zaklMena)
    ::showMena(value)

    if value <> ::zaklMena
      kurzit->( dbseek( upper(value),,'KURZIT9'))
      nkoe := kurzit->nkurzStred/ kurzit->nmnozPrep

      pocST_tuz:set( pocStav * nkoe )
    endif
  endCase

  aktStav:set(::dm:get(pa[1]) +::dm:get(pa[2]) -::dm:get(pa[3]))

  if ( name = 'pokladms->ciddatkome' )
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      if empty(value)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif
    endif
  endif
return .t.


METHOD FIN_pokladms_IN:postLastField(drgVar)
  Local  lZMENa := .t. // ::dm:changed()

  // ukládáme POKLADMS na posledním PRVKU //
  IF lZMENa .and. IF(::nState = 2, ADDrec('POKLADMS'), REPLrec( 'POKLADMS'))
    pokladms->naktStav   := ::dm:get('pokladms->naktStav')
    pokladms->listuz_uc  := upper(::zaklMena) = upper(::dm:get('pokladms->czkratmeny'))
    pokladms->ctypPohybu := ::dm:get('pokladms->ctypPohybu')
    pokladms->ctypDoklad := ::dm:get('pokladms->ctypDoklad')
    pokladms->npokladEET := if( 'EET' $ pokladms->ctypPoklad, 1, 0 )

    ::dm:save()
    ::bro:refresh(.t.)
  ENDIF

  pokladms->(dbunlock(), dbcommit())

  ::nState := 0
  SetAppFocus(::bro:oXbp)
  PostAppEvent(xbeBRW_ItemMarked,,,::bro:oXbp )
RETURN .T.


**
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_pokladms_IN:showGroup()
  local  nIn, NoEdit := GraMakeRGBColor( {221, 221, 221} )
  local  lOk := (::nState = 2 )                                                 // INS
  local  pA  := {'pokladms->ctypPoklad', 'pokladms->npokladna', 'pokladms->czkratmeny'  }
  LOCAL  drgVar

  FOR nIn := 1 TO LEN(pA)
    drgVar        := ::dm:has(pA[nIn]):oDrg
    drgVar:isEdit := lOk
    if( lok, drgVar:oXbp:enable(), drgVar:oXbp:disable() )

*    IF( drgVar:className() = 'drgGet', drgVar:isEdit := lOk, NIL )
*    drgVar:oXbp:setColorBG(IF( drgVar:isEdit, drgVar:clrFocus, NoEdit))
  NEXT

  ::enable_datkom()
RETURN self


method FIN_pokladms_in:showMena(zkrMeny)
  local x, odrg

  for x := 1 to len(::memb) step 1
    if ::memb[x]:className() = 'drgText' .and. isobject(::memb[x]:ovar)
      odrg := ::memb[x]:ovar
      if lower(odrg:name) = 'pokladms->czkratmeny'
        odrg:set(zkrMeny)
      endif
    endif
  next
return self

*
** hiden
method FIN_pokladms_in:sel_datkomhd_usr(idDatKom)
  local  odialog, nExit := 0
  *
  local  sName, cc
  *
  local  idDatKomE := allTrim(::dm:get( 'pokladms->ciddatkome'))
*  local  idDatKomI := allTrim(::dm:get( 'pokladms->ciddatkomi'))

  ::mDefin_kom := ''
  if datkomhd->( dbseek( upper(idDatKomE),,'DATKOMH01'))
    cc           := strTran( datkomhd->mDefin_kom, 'Users', 'Users_ciddatkome')
    ::mDefin_kom += cc +CRLF +CRLF
  endif

*  if datkomhd->( dbseek( upper(idDatKomI),,'DATKOMH01'))
*    cc           := strTran( datkomhd->mDefin_kom, 'Users', 'Users_import'   )
*    ::mDefin_kom += cc +CRLF +CRLF
*  endif
  *
  ** pokud neexistuje musíme ho založit
  myCreateDir( ::tmp_Dir )
    datkomhd->( dbseek( upper(idDatKom),,'DATKOMH01'))
    sName  := ::tmp_Dir +datkomhd->cidDatKom +'.usr'
    memoWrit( sName, ::odrgVar_defin_kom:value )

  DRGDIALOG FORM 'SYS_DATKOMHD_USR' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit = drgEVENT_SELECT
    ::odrgVar_defin_kom:set( memoRead( sName) )
    PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
  endif
return .t.