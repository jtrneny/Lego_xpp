#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
//
#include "dbstruct.ch"
#include "..\Asystem++\Asystem++.ch"


static anODB

*
** CLASS for PRO_objhead_nevykrOBL *********************************************
CLASS PRO_objhead_nevykrOBL from drgUsrClass
EXPORTED:
  var  ddatDO_od, ddatDO_do

  inline method init(parent)
    local nin

    ::drgUsrClass:init(parent)

    ::ddatDO_od := ctod('  .  .  ')
    ::ddatDo_do := ctod('  .  .  ')

    anODB := {}

    drgDBMS:open('c_oblast')
    drgDBMS:open('objhead' )
    drgDBMS:open('objitem' )
    drgDBMS:open('cenZboz' )

    ::caof_objitem     := ''
    ::caof_objitem_new := ''

    if( select('c_oblastW') <> 0, c_oblastw->(dbcloseArea()), nil)
    *
    drgDBMS:open('c_oblastW',.T.,.T.,drgINI:dir_USERfitm); ZAP
    ::cmp_nevykrOBL()
  return self


  inline method drgDialogStart(drgDialog)
    local  x, members  := drgDialog:oForm:aMembers

    ::dm             := drgDialog:dataManager             // dataMananager

    ::oDBro_main     := drgDialog:dialogCtrl:oBrowse[1]
    ::oget_ddatDO_od := ::dm:has('M->ddatDO_od'):odrg
    ::oget_ddatDO_do := ::dm:has('M->ddatDO_do'):odrg

    BEGIN SEQUENCE
      FOR x := 1 TO LEN(members)
        IF members[x]:ClassName() = 'drgDBrowse'
      BREAK
        ENDIF
      NEXT
    ENDSEQUENCE

    drgDialog:oForm:nextFocus := x
  return self


  inline method postValidate(drgVar)
    local  value  := drgVar:get()
    local  name   := lower(drgVar:name)
    local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')
    local  ok     := .T., changed := drgVAR:changed()
    *
    local  nevent := mp1 := mp2 := nil, isF4 := .F.
    * F4
    nevent  := LastAppEvent(@mp1,@mp2)
    If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


    if ( name = 'm->ddatdo_od' .or. name = 'm->ddatdo_do' )

      if( name = 'm->ddatdo_od', ::ddatDO_od := value, ::ddatDO_do := value )

      do case
      case(       empty(::ddatDO_od) .and.       empty(::ddatDO_do) )
        ::caof_objitem_new := ''

      case( .not. empty(::ddatDO_od) .and.       empty(::ddatDO_do) )
        ::caof_objitem_new := format( "ddatDOodb >= '%%'", {::ddatDO_od} )

      case(       empty(::ddatDO_od) .and. .not. empty(::ddatDO_do) )
        ::caof_objitem_new := format( "ddatDOodb <= '%%'", {::ddatDO_do} )

      otherwise
        if( ::ddatDO_od > ::ddatDO_do )
          ::ddatDO_do := ctod('  .  .  ')
          ::oget_ddatDO_do:ovar:set(::ddatDO_od )
        else
          ::caof_objitem_new := format( "ddatDOodb >= '%%' and ddatDOodb <= '%%'", {::ddatDO_od, ::ddatDO_do} )
        endif
      endcase

      if ( name = 'm->ddatdo_do' )
        if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
          if ::caof_objitem <> ::caof_objitem_new
            ::caof_objitem := ::caof_objitem_new

            objitem->( if( empty(::caof_objitem_new), ads_clearAof(), ads_setAof(::caof_objitem_new)), dbgotop())
            ::cmp_nevykrOBL()
            ::oDBro_main:oxbp:refreshAll()
          endif
        endif
      endif

    endif
  return ok


  inline method itemMarked()

    if ::caof_objitem <> ::caof_objitem_new
      ::caof_objitem := ::caof_objitem_new

      objitem->( if( empty(::caof_objitem_new), ads_clearAof(), ads_setAof(::caof_objitem_new)), dbgotop())
      ::cmp_nevykrOBL()
      ::oDBro_main:oxbp:refreshAll()
    endif
  return self


  inline method btn_START()
    local  odialog, nexit
    local  x  , anOBLAST := {}
    local  nin, anFIRMY  := {}, ncisFirmy, cky, cky_wds, nordItem, nmaxDoklad

    drgDBMS:open('OBJHEADww' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('OBJITEMww' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('OBJITEMwds',.T.,.T.,drgINI:dir_USERfitm); ZAP

    do case
    case      ::oDBro_main:is_selAllRec
      aeval( anODB, { |x| aadd( anOBDLAST, x[1] ) } )

    case len( ::oDBro_main:arSelect) <> 0
      fordRec({'c_oblastW'} )
      for x = 1 to len(::oDBro_main:arSelect) step 1
        c_oblastW->( dbgoTo(::oDBro_main:arSelect[x] ))
        aadd( anOBLAST, c_oblastW->nklicObl )
      next
      fordRec()

    otherWise
      aadd( anOBLAST, c_oblastW->nklicObl )

    endCase

    for x := 1 to len(anOBLAST) step 1
      nin := ascan( anODB, { |nobl| nobl[1] = anOBLAST[x] } )
      aeval( anODB[nin,2], { |x| aadd(anFIRMY, x) } )
    next


    if len(anFIRMY) <> 0
      objhead->( ordSetFocus('OBJHEAD1'))

      for nin := 1 to len(anFIRMY) step 1
        ncisFirmy := anFIRMY[nin]
        objhead->( dbSetScope(SCOPE_BOTH, strZero(ncisFirmy,5)), dbgoBottom() )

        mh_copyFld('objhead', 'objheadWW', .t., .t.)

        ( objheadWW->nmnozOBodb := 0, objheadWW->nmnozPLodb := 0, ;
          objheadWW->nkcsBDobj  := 0, objheadWW->nkcsZDobj  := 0  )

        cky := strZero(objhead->nklicObl,3) +strZero(objhead->ncisFirmy,5)
        objitem->( dbSetScope(SCOPE_BOTH, cky), dbgoTop())

        nordItem   := 0
        nmaxDoklad := 0

        do while .not. objitem->(eof())
          mh_copyFld('objitem', 'objitemWW', .t., .t. )
          nordItem   := nordItem +1
          nmaxDoklad := max(nmaxDoklad, objitemWW->ndoklad)

          cky_wds := upper(objitem->ccisSklad) +upper(objitem->csklPol)
          cenzboz->(dbseek(cky_wds,, 'CENIK03'))

          objitemWW->_nmnozkFak := (objitem->nmnozObOdb -objitem->nmnoz_FAKV)
          objitemWW->_nsidCENzb := cenZboz->sid
          objitemWW->_nsidDHww  := objheadWW->sID
          objitemWW->nordItem   := nordItem

          if .not. objitemWds->( dbseek(cky_wds,, 'OBJITEM1'))
            objitemWds->(dbAppend())
            objitemWds->ccisSklad  := cenZboz->ccisSklad
            objitemWds->csklPol    := cenZboz->csklPol
            objitemWds->nsumKFak   := (objitem->nmnozObOdb -objitem->nmnoz_FAKV)
            objitemWds->npocOdb    := 1
            objitemWds->_nsidCENzb := cenZboz->sid
          else
            objitemWds->nsumKFak += (objitem->nmnozObOdb -objitem->nmnoz_FAKV)
            objitemWds->npocOdb  := objitemWds->npocOdb +1
          endIf

          objheadWW->nmnozOBodb += objitem->nmnozOBodb
          objheadWW->nmnozPLodb += objitem->nmnozPLodb
          objheadWW->nkcsBDobj  += objitem->nkcsBDobj
          objheadWW->nkcsZDobj  += objitem->nkcsZDobj

          objitem->(dbskip())
        endDo

        objheadWW->nmaxDoklad := nmaxDoklad
        objitem->(dbClearScope())
      next

      objheadWW->( dbgoTop())

      odialog := drgDialog():new('PRO_objhead_nevykrOBJ', ::drgDialog)
      odialog:create(,,.T.)

    endif
  return self

HIDDEN:
  var  dm
  var  caof_objitem, caof_objitem_new
  var  oDBro_main, oget_ddatDO_od, oget_ddatDO_do

  *
  ** pøepoèítáme nevykryté oblasti na základì nastavení ddatDO_od - ddatDO_do
  inline method cmp_nevykrOBL()

    anODB := {}

    c_oblastW->( dbZap())
    c_oblast ->( dbeval( { || ( mh_copyFld('c_oblast', 'c_oblastW', .t., .t. ), ;
                                aadd( anODB, { c_oblast->nklicObl, {} }     )  ) } ) )

    objitem->( ordsetFocus( 'OBJITE35'), dbgoTop())

    do while .not. objitem->( eof())
      if c_oblastW->( dbseek( objitem->nklicObl,,'C_OBL1'))

        nin := ascan( anODB, { |x| x[1] = objitem->nklicObl } )
        if ascan( anOdb[nin,2], objitem->ncisFirmy ) = 0
          aadd( anODB[nin,2], objitem->ncisFirmy )
        endif

        c_oblastW->nnevykPol  := c_oblastW->nnevykPol  +1
        c_oblastW->nnevykMnoz := c_oblastW->nnevykMnoz +(objitem->nmnozOBodb - objitem->nmnoz_FAKV )
        c_oblastW->nnevykOdb  := len( anOdb[nin,2] )
      endif
      objitem->( dbskip())
    enddo

    c_oblastW->( dbeval( {|| if(c_oblastW->nnevykPol = 0, c_oblastW->(dbdelete()), nil ) } ) )
    c_oblastW->( dbgoTop())
  return self

ENDCLASS

*
** p.Gabriel chce vidìt na BRo barevnì doklady, které jsou starší než poslední doklad
function PRO_objitemWW_colorBlock( a, b, c )
  local useVisualStyle := if( isMemvar( 'visualStyle'), visualStyle, .f. )
  *
  local aCOL_ok := { , }
  local aCOL_er := { GraMakeRGBColor({255,128,128}), }

  if useVisualStyle .and. IsThemeActive(.T.)
    if objheadWW->nmaxDoklad <> objitemWW->nDoklad
      return { , GraMakeRGBColor( {255, 128, 128 } ) }
    else
      return aCOL_ok
    endif
  else
    return if( objheadWW->nmaxDoklad <> objitemWW->nDoklad, aCOL_er, aCOL_ok )
  endif
return aCol_ok


*
** CLASS for PRO_objhead_nevykrOBJ ********************************************
CLASS PRO_objhead_nevykrOBJ from drgUsrClass
EXPORTED:
  var    lNEWrec, hd_file, it_file
  var    dvystFak, ctypPohybu
  method comboBoxInit

  method objhead_to_fakvyshd_ed, objhead_to_fakvyshd_in

  * objheadW
  inline access assign method stav_objhead() var stav_objhead
    * nmnozOBodb  nmnozPLodb
    return if( objheadWW->nmnozPLodb = 0, 0, 303 )

  *  objitemW
  ** k dispozici pro fakturaci
  inline access assign method objitem_is_kFak() var objitem_is_kFak
    return if( (objitemWW->nmnozObOdb -objitemWW->nmnoz_FAKV) > 0, 6001, 0 )

  ** k dispozici na cenZboz
  inline access assign method objitem_is_kDis() var objitem_is_kDis
    local  cky := upper(objitemWW->ccisSklad) +upper(objitemWW->csklPol)
    *
    local  cenzboz_kDis, objitem_kDis, retVal := 0

    cenzboz->(dbseek(cky,, 'CENIK03'))

    if cenzboz->cpolcen = 'C'
      cenzboz_kDis := cenzboz->nmnozDzbo                              // ::m_udcp:wds_cenzboz_kDis
      objitem_kDis := (objitemWW->nmnozObOdb -objitemWW->nmnoz_FAKV)  // ::m_udcp:wsd_objitem_kDis

      do case
      case cenzboz_kDis = 0 .and. objitem_kDis =  0  ; retVal := MIS_NO_RUN
      case cenzboz_kDis = 0 .and. objitem_kDis <> 0  ; retVal := MIS_ICON_ERR
      case cenzboz_kDis      >=   objitem_kDis       ; retVal := MIS_ICON_OK
      otherwise                                      ; retVal := 6002
      endcase
    endif
    return retVal

  ** stav fakturace objiteWW
  inline access assign method stav_fakt() var stav_fakt
    local retVal := 0
    local stav_fakt := objitemWW->nstav_fakt

    do case
    case( stav_fakt = 1 )  ;  retVal := 303
    case( stav_fakt = 2 )  ;  retVal := 302
    endcase
    return retVal

  ** poèet odbìratelù položky
  inline access assign method objitem_pocOdb() var objitem_pocOdb
    objitemWds->( dbseek( objitemWW->_nsidCENzb,,'sidCENz'))
    return objitemWds->npocOdb

  ** množství objednané k fakturaci
  inline access assign method objitem_kFak() var objitem_kFak
    return (objitemWW->nmnozObOdb -objitemWW->nmnoz_FAKV)

  ** celkem k fakturaci za ccisSklad/csklPol na objitemWW
   inline access assign method objitem_sumKFak() var objitem_sumKFak
    objitemWds->( dbseek( objitemWW->_nsidCENzb,,'sidCENz'))
    return objitemWds->nsumKFak

  *
  ** množství skladové k dispozici
  inline access assign method cenZboz_kDis() var cenZboz_kDis
    local  cky := upper(objitemWW->ccisSklad) +upper(objitemWW->csklPol)

    cenzboz->(dbseek(cky,, 'CENIK03'))
    return cenZboz->nmnozDzbo

  *
  ** p.Gabriel poøád blbne s poøadím položek/ nìjak je mám pøeèíslovat
  inline method eBro_beforsaveEditRow(oEBro)
    local  inFile := lower(::dc:oaBrowse:cfile)
    local  recNo  := objitemWW->(recNo()), nold_Ord, nnew_Ord

    if inFile = 'objitemww'
      nold_Ord := objitemWW->nordItem
      nnew_Ord := ::dm:get('objitemWW->nordItem')

      if ( nold_Ord <> nnew_Ord )
        FOrdRec( {'objitemWW,OBJITEM5'} )

        if objitemWW->( dbseek( nnew_Ord,,'OBJITEM5'))
          objitemWW->nordItem := nold_Ord
        endif

        FOrdRec()
        ::oEBro_objitemWW:oxbp:refreshAll()
      endif
    endif
  return .t.

  *
  **
  inline method init(parent)
    ::drgUsrClass:init(parent)

    ( ::hd_file    := 'fakVyshdW', ::it_file := 'fakvysitW' )
    ::dvystFak   := date()
    ::ctypPohybu := 'FAKVBEZSKL'

    drgDBMS:open('c_typpoh')
    drgDBMS:open('typDokl' )
    drgDBMS:open('cenZboz' )

***************************  uvidíme ***
    drgDBMS:open('firmy'   )
    drgDBMS:open('firmyDA' )
    drgDBMS:open('firmyFI' )
    drgDBMS:open('firmyVA' )

    drgDBMS:open('c_bankuc')
    drgDBMS:open('c_typuhr')

    drgDBMS:open('fakvyshd')
    drgDBMS:open('fakvysit')
  return self


  inline method drgDialogStart(drgDialog)
    local  oBro_2, xbp_oBro_2, x, ocolumn

    ::msg      := drgDialog:oMessageBar             // messageBar
    ::dm       := drgDialog:dataManager             // dataMananager
    ::dc       := drgDialog:dialogCtrl              // dataCtrl
    ::df       := drgDialog:oForm                   // form
    ::ab       := drgDialog:oActionBar:members      // actionBar

    ::oabro    := drgDialog:dialogCtrl:obrowse

       obro_2  := ::oabro[2]
    xbp_obro_2 := ::oabro[2]:oXbp
    xbp_obro_2:itemRbDown := { |mp1,mp2,obj| obro_2:createContext(mp1,mp2,obj) }

    ::oget_dvystFak  := ::dm:has('M->dvystFak'  ):odrg
    ::ocmb_typPohybu := ::dm:has('M->ctypPohybu'):odrg

     for x := 1 to len(::ab) step 1
       do case
       case ::ab[x]:event = 'objhead_to_fakvyshd_in'  ; ::obtn_objhead_to := ::ab[x]
       endcase
     next

     ::oabro[1]:enabled_insCykl := .f.
     ::oabro[2]:enabled_insCykl := .f.
     ::oEBro_objitemWW          := ::oabro[2]

      * úprava pro objitemWW - odlišit barvou poslední objednávku
     for x := 1 to xbp_obro_2:colCount step 1
       ocolumn := xbp_obro_2:getColumn(x)
       ocolumn:colorBlock := &( '{|a,b,c| PRO_objitemWW_colorBlock( a, b, c ) }' )
     next
  return self


  inline method itemMarked()
    local  m_filter := "_nsidDHww = %%", filter

    filter := format( m_filter, { objheadWW->sID } )
    objitemWW->( ads_setAof(filter), dbgoTop() )
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local inFile

    ::dvystFak   := ::oget_dvystFak:ovar:value
    ::ctypPohybu := ::ocmb_typPohybu:value

    do case
    case(nevent = xbeBRW_ItemMarked)
      ::dm:refresh()

    case(nevent = drgEVENT_DELETE)
      inFile := lower(::dc:oaBrowse:cfile)

      if( (inFile)->(eof()), nil, ::postDelete(inFile) )
      return .t.

    case(nevent = drgEVENT_EDIT)
    case(nevent = drgEVENT_MSG )
    endcase
  return .f.


HIDDEN:
  var    msg, dm, dc, df, ab, oaBro
  *
  var    oEBro_objitemWW
  var    oget_dvystFak, ocmb_typPohybu, obtn_objhead_to


  inline method fakvyshdW_reFill()
    local  value := ::ocmb_typPohybu:Value, values := ::ocmb_typPohybu:values
    local  nin, pa, finTyp

    nIn    := ascan(values, {|X| X[1] = value })
     pa    := listasarray(values[nin,4])
    finTyp := if( len(pa) >= 2, val(pa[2]), 0 )

    fakvyshdW->ctypdoklad := values[nin,3]
    fakvyshdW->ctyppohybu := values[nin,1]
    fakvyshdW->czkrtypfak := pa[1]
    fakvyshdW->nfintyp    := finTyp
    fakvyshdW->ciszal_fak := if(finTyp = 2 .or. finTyp = 4, '1', '0')
    *
    fakvyshdW->ctask      := values[nin,5]
    fakvyshdW->csubTask   := values[nin,6]

    * jen pro jistotu, 8 - parametr je cvypSAZdan
    if len(values[nin]) = 8
      if( .not. empty(values[nin,8]), (::hd_file)->cvypSAZdan := values[nin,8], nil )
    endif

    fakvyshdW->ncisFak    := fin_range_key('FAKVYSHD')[2]
    fakvyshdW->cdanDoklad := ALLTRIM( STR(fakvyshdw ->ncisFak))
    fakvyshdw->cvarSym    := ALLTRIM( STR(fakvyshdw ->ncisFak))
    fakvyshdW->nkonstSymb := 8
    fakvyshdW->dvystFak   := ::oget_dvystFak:ovar:value
    fakvyshdW->dpovinFak  := ::oget_dvystFak:ovar:value
    fakvyshdw->ncislodl   := 0
    fakvyshdw->ncislopvp  := 0
    if( .not. empty(objheadWW->czkrZPUdop), fakvyshdw->czkrZPUdop := objheadWW->czkrZPUdop, nil )
    *
    ** pozor problém s obdobím na zlomu mìsíce
    fakvyshdW->(dbcommit())
  return self


  inline method postDelete(inFile)
    local  cMessage  := 'Požadujete zrušit'
    local  cTitle    := 'Zrušení'
    local  cInfo     := str(objheadWW->ncisFirmy) +'_ ' +allTrim(objheadWW->cNazev)
    *
    local  inBro     := 0, nsel
    local  cText     := 'Promiòte prosím,; požadujete zrušit ' +CRLF
    local  paButton  := { '   ~Ano    ', '    ~Ne   ', '    Ano ~S vykrytím   '  }

    do case
    case( inFile = 'objheadww' )
      cText    += ' objednávku pøijatou ;'     + ;
                    cInfo               + ';;' + ;
                  '            ... vèetne položek ...'
      cTitle   += ' objednávky pøijaté vèetnì položek ...'
      inBro    := 1
    otherWise
      cText    += ' položku objednávky pøijaté ...;;' + ;
                    cInfo
      cTitle   += ' položky objednávky pøijaté ...'
      inBro    := 2
    endCase


    nsel := alertBox( ::drgDialog:dialog, ;
                      cText             , ;
                      paButton          , ;
                      XBPSTATIC_SYSICON_ICONQUESTION, cTitle )
    _clearEventLoop(.t.)


    do case
    case( inFile = 'objheadww' )
      cMessage += ' objednávku pøijatou ' + CRLF +       ;
                    cInfo                 + CRLF +CRLF + ;
                  '            ... vèetne položek ...'
      cTitle   += ' objednávky pøijaté vèetnì položek ...'
      inBro    := 1
    otherWise
      cMessage += ' položku objednávky pøijaté ...' + CRLF +CRLF + ;
                    cInfo
      cTitle   += ' položky objednávky pøijaté ...'
      inBro    := 2
    endCase



    if( inBro <> 0 )
      nsel := ConfirmBox( , cMessage           , ;
                            cTitle             , ;
                            XBPMB_YESNO       , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

      if nsel = XBPMB_RET_YES
        if inBro = 1
          objitemWW->( dbgoTop())

          do while .not. objitemWW->( eof())
            objitemWds->( dbseek( objitemWW->_nsidCENzb,,'sidCENz'))

            objitemWds->nsumKFak := (objitemWds->nsumKFak -objitemWW->_nmnozkFak)
            objitemWds->npocOdb  := objitemWds->npocOdb   -1
            objitemWW->(dbDelete())

            objitemWW->( dbSkip())
          enddo
          objheadWW->( dbDelete())

        else
          objitemWds->nsumKFak := (objitemWds->nsumKFak -objitemWW->_nmnozkFak)
          objitemWds->npocOdb  := objitemWds->npocOdb   -1
          objitemWW->(dbDelete())
        endif

        ::dc:refreshPostDel()
      endif
    endif

  return .t.
ENDCLASS


method PRO_objhead_nevykrOBJ:comboBoxInit(drgComboBox)
  local  cname      := lower(drgParseSecond(drgComboBox:name,'>'))
  local  onSort     := 2, isOk := .f.
  local  acombo_val := {}, ky := F_POHLEDAVKY

  do case
  case('ctyppohybu' = cname)
    isOk := .t.

    c_typpoh->(dbsetscope(SCOPE_BOTH,ky), dbgotop())
    do while .not. c_typpoh ->(eof())
*      if upper(c_typpoh->ctypDoklad) = 'FIN_PODOPR'
        typdokl ->(dbseek(c_typpoh ->(sx_keyData())))
        aadd( acombo_val, { c_typpoh ->ctyppohybu       , ;
                            c_typpoh ->cnaztyppoh       , ;
                            c_typpoh ->ctypdoklad       , ;
                            alltrim(typdokl  ->ctypcrd) , ;
                            c_typpoh->ctask             , ;
                            c_typpoh->csubtask          , ;
                            c_typpoh->craddph091        , ;
                            c_typpoh->cvypSAZdan        , ;
                            c_typpoh->npokladEET          } )
*      endif
      c_typpoh->(dbskip())
    endDo
    c_typpoh ->(dbclearscope())
  endcase

  if isOk
    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[onSort] < aY[onSort] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
  endif

  * musíme nastavit startovací hodnotu *
  drgComboBox:value := drgComboBox:ovar:value
  drgComboBox:refresh()
return self


method PRO_objhead_nevykrOBJ:objhead_to_fakvyshd_ed(drgDialog)

  drgDialog:cargo_usr := 'ed'
  ::objhead_to_fakvyshd_in(drgDialog)
  drgDialog:cargo_usr := Nil
return self


method PRO_objhead_nevykrOBJ:objhead_to_fakvyshd_in(drgDialog)
  local  o_fin_fakVyshd_in, o_udcp, o_dm
  local  iz_file := 'objitem', hd_file, it_file
  local  fak_cisFirmy, fak_cislOBint, fak_faktMnoz, fak_cenaSzbo
  local  fak_zkrZPUdop
  local  pa_Recs := {}, x
*
  local  last_Cargo := drgDialog:cargo
  local  inEdit     := If( IsNull(drgDialog:cargo_usr), .F., .T.)
  local  isOk       := .f., is_Saved := .t.
  local  nrun_Sp, arSelect, lis_recOk, nrecNo
  local  nrec_count := objheadWW->( ads_getRecordCount()), nrec_work  := 1
  local  pa_delRecs := {}

  * asi by se mìlo zjistit jestli už existuje FA

  ::lNEWrec   := .t.
  ::drgDialog := ::dm:drgDialog

  o_fin_fakVyshd_in := drgDialog():new('FIN_fakVyshd_IN', drgDialog )
  o_fin_fakVyshd_in:cargo_Usr := 'EXT_FAK'
  o_fin_fakVyshd_in:create( ,,, .f. )

  o_fin_fakvyshd_in:dialog:disable()

  o_udcp  := o_fin_fakVyshd_in:udcp
  hd_file := o_udcp:hd_file
  it_file := o_udcp:it_file
  o_udcp:lnewrec := .t.
  *
  ** hlavièka, musíme vynutit uložení jak zmìnu
  fak_cisFirmy         := o_udcp:dm:has(hd_file +'->ncisFirmy')
  fak_cisFirmy:value   := objheadWW->ncisFirmy
  o_udcp:df:olastDrg   := fak_cisFirmy:odrg

  o_udcp:cmb_typPoh:values := ::ocmb_typPohybu:values

  o_udcp:cmb_typPoh:oxbp:clear()
  aeval(o_udcp:cmb_typPoh:values, { |a| o_udcp:cmb_typPoh:oXbp:addItem( a[2] ) } )
  * musíme nastavit startovací hodnotu *
  o_udcp:cmb_typPoh:value := ::ocmb_typPohybu:Value
  o_udcp:cmb_typPoh:refresh()

  ** smyèka nad objheadWW
  *
  ** objekty pro položky
  fak_cislOBint := o_udcp:dm:has(it_file +'->ccislOBint')
  fak_faktMnoz  := o_udcp:dm:has(it_file +'->nfaktMnoz' )
  fak_cenaSzbo  := o_udcp:dm:has(it_file +'->ncenaSzbo' )

  fak_zkrZPUdop := o_udcp:dm:has(hd_file +'->czkrZPUdop')


  do case
  case ( ::oaBro[1]:is_selAllRec .and. len(::oaBro[1]:arSelect) =  0 )
    nrun_Sp  := 1   // vše co je v seznamu
    arSelect := {}

  case ( ::oaBro[1]:is_selAllRec .and. len(::oaBro[1]:arSelect) <> 0 )
    nrun_Sp  := 1 // vylouèit odznaèené záznamy
    arSelect := ::oaBro[1]:arSelect

  case                                 len(::oaBro[1]:arSelect) <> 0
    nrun_Sp  := 3 // zpracovat je oznaèené záznamy
    arSelect := ::oaBro[1]:arSelect

  otherWise
    nrun_Sp  := 4 // zpracovat jen záznam na kterém stojí
    arSelect := {}
  endcase


  if nrun_Sp = 4
    nrec_count := 1
  else
    objheadWW->( dbgoTop())
    ::oaBro[1]:oxbp:goTop():refreshAll()
    ::oaBro[2]:oxbp:goTop():refreshAll()
    * refresh items
  endif


  do while ( nrec_count >= nrec_work )

    nrecNo    := objheadWW->( recNo())
    lis_recOk := if( nrun_Sp = 1, .t., ;
                   if( nrun_Sp = 2 .and. ascan( arSelect, nrecNo) = 0, .t., ;
                     if( nrun_Sp = 3 .and. ascan( arSelect, nrecNo) <> 0, .t., ;
                       if( nrun_Sp = 4, .t., .f. ) ) ) )

    if lis_recOk
      isOk     := .f.
      is_Saved := .f.

      SetAppFocus(::obtn_objhead_to:oxbp)
      ::fakvyshdW_reFill()

      fak_cisFirmy:value   := objheadWW->ncisFirmy
      o_udcp:df:olastDrg   := fak_cisFirmy:odrg
      o_udcp:fin_firmy_sel()

      if .not. empty(objheadWW->czkrZPUdop)
        fakvyshdw->czkrZPUdop := objheadWW->czkrZPUdop
        fak_zkrZPUdop:value   := objheadWW->czkrZPUdop
        fakvyshdW->(dbcommit())
      endif

      ::itemMarked()
      ::oaBro[2]:oxbp:goTop():refreshAll()

      do while .not. objitemWW->( eof())

        if ::cenZboz_kDis >= ::objitem_kFak
          SetAppFocus(::obtn_objhead_to:oxbp)

          cenZboz->( dbseek( objitemWW->_nsidCENzb,, 'ID' ))
          objitem->( dbseek( objitemWW->_nsidOR   ,, 'ID' ))

          o_udcp:takeValue(it_file, iz_file, 4, o_udcp )

          fak_faktMnoz:value := objitemWW->_nmnozkFak
          fak_cenaSzbo:value := cenZboz->ncenaSzbo

          o_udcp:postValidate(fak_faktMnoz)
          o_udcp:postLastField()

          isOk := .t.
        endif
        objitemWW->( dbskip())
      endDo

      if isOk
        if inEdit
          o_udcp:showGroup()
          _clearEventLoop(.t.)
          o_fin_fakvyshd_in:dialog:enable()
          o_fin_fakVyshd_in:quickShow(.t.,.t.)
          o_udcp:wds_disconnect()

          is_Saved := ( o_fin_fakVyshd_in:exitState = drgEVENT_SAVE )
        else
          *
          ** uložení v trasakci
          if .not. fin_fakvyshd_wrt_inTrans(o_udcp)
            return self
          else
            is_Saved := .t.
          endif
        endif

        if( is_Saved, aadd( pa_delRecs, objheadWW->( recNo()) ), nil )
      endif
    endif

    nrec_work++
    ::oaBro[1]:oxbp:down():refreshAll()
    ::oaBro[2]:oxbp:goTop():refreshAll()

    fakvysitw->(dbzap())
    dodlsthdw->(dbZap())
    dodlstitw->(dbZap())
    pvpheadw->(dbZap())
    pvpitemw->(dbZap())
  enddo

  drgServiceThread:setActiveThread(0)
  setAppFocus( ::dm:drgDialog:dialog )
  _clearEventLoop()

  o_fin_fakVyshd_in := nil
  *
  ** zrušímì zracované záznamy a šupnem to na bro,
  ** pokud tam nic není vrátíme se na parenta
  aeval( pa_delRecs, { |x| objheadWW->(dbgoTo(x),dbdelete()) })

  objheadWW->( dbgoTop())
  ::oaBro[1]:oxbp:goTop():refreshAll()
  ::itemMarked()
  ::oaBro[2]:oxbp:goTop():refreshAll()
return self



/*
********************************************************************************
postAppEvent(xbeP_Close,,,::dm:drgDialog:dialog)
PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)




  ::fakvyshdW_reFill()

  o_udcp:fin_firmy_sel()

  fakVyshdW->( dbcommit())

  *
  ** položky
  fak_cislOBint := o_udcp:dm:has(it_file +'->ccislOBint')
  fak_faktMnoz  := o_udcp:dm:has(it_file +'->nfaktMnoz')

  objitemWW->( dbgoTop())
  do while .not. objitemWW->( eof())
    if ::cenZboz_kDis >= ::objitem_kFak
      *
      ** vot problema, po uložení položky získá focus BRO,
      ** pak blbne s vyèítáním položek initValue a value pøestaví ...
      *
**      setAppFocus( fak_cislOBint:odrg:oxbp )

      objitem->( dbseek( objitemWW->_nsidOR,, 'ID' ))
      o_udcp:takeValue(it_file, iz_file, 4, o_udcp )

***      fak_faktMnoz:value := ::objitem_kFak
      fak_faktMnoz:value := objitemWW->_nmnozkFak
      o_udcp:postValidate(fak_faktMnoz)
      o_udcp:postLastField()
    endif
    objitemWW->( dbskip())
  enddo
  *
  ** je potøeba pøezobrazit typ položek, jinak to zblbne
  fakVyshdW->( dbcommit())
  fakVysitW->( dbcommit(), dbgoTop())

*  o_udcp:brow:goTop():refreshAll()
  o_udcp:showGroup()
  _clearEventLoop(.t.)

*  o_udcp:brow:goTop():refreshAll()
*  PostAppEvent(xbeBRW_ItemMarked,,,o_udcp:brow)

  o_fin_fakVyshd_in:quickShow(.t.,.t.)
  o_udcp:wds_disconnect()

  fakvyshdw->(dbclosearea())
  fakvysitw->(dbclosearea())
  fakvysi_w->(dbclosearea())
  *
  dodlsthdw->(dbclosearea())
  dodlstitw->(dbclosearea())

  _clearEventLoop()
return self

**  ::wds_postSave()
*/