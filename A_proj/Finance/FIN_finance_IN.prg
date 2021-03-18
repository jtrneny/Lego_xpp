#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
#include "dbstruct.ch"
#include "Drgres.ch"
//
#include "..\Asystem++\Asystem++.ch"

*
** obecná funkce pro zobrazení øádkù výkazu DPH na SCR
function fin_vykdph_ibc()
  local  cky := strZero(vykdph_i->noddil_dph,2) + ;
                strZero(vykdph_i->nradek_dph,3) + ;
                strZero(vykdph_i->ndat_od,8)

  if(select('c_vykdph') = 0, drgDBMS:open('c_vykdph'), nil)
  c_vykdph->(dbseek(cky,,'VYKDPH4'))
return(c_vykdph->cradek_say)

*
** CLASS FIN_finance_IN ********************************************************
CLASS  FIN_finance_IN
EXPORTED:
  VAR  msg, dm, dc, df, ab, brow
  VAR  state                                    // 0 - inBrowse  1 - inEdit  2 - inAppend
  VAR  one_edt                                  // první prvek pro INS/ENTER
  VAR  que_del                                  // dotaz pøi rušení položky
  VAR  typ_lik                                  // interface pro FIN_likvidace_in
                                                // 'zav', 'poh', pok'
  var  in_scr                                   // poøizovací SCR má jiné zákonitosti zobrazení
  var  new_dok
  var  m_filter_parPrzal
  *
  METHOD init, handleEvent, ordItem, itSave, refresh, refreshGroup, copyfldto_w, openfiles
  METHOD fakprihd_act

  ** OBECNÉ **
  METHOD fin_cmdph, fin_kurzit, cobdobi, memoEdit
  METHOD FIN_vykdph_in, FIN_vykdph_mod
  METHOD FIN_likvidace_in, FIN_fakvnphd_lik_IN
  METHOD c_naklst_vld
  METHOD FIN_mapolSest_in

  ** FOR ALL **
  METHOD comboBoxInit
  *
  ** likvidace pøi poøízení dokladu FIN_fakprihd_IT_in, FIN_fakvyshd_in, FIN_pokladhd_in
  var set_likvidace_inOn

  inline method set_likvidace_in()
    ::set_likvidace_inOn := 1
    postAppEvent(drgEVENT_ACTION, drgEVENT_SAVE,'2',::dm:drgDialog:lastXbpInFocus)
    return self

  inline method inBrow()
    return (SetAppFocus():className() = 'XbpBrowse')

  inline method restColor()
    local members := ::df:aMembers

    oxbp := setAppFocus()
    aeval(members, {|X| if(ismembervar(x,'clrFocus'), x:oxbp:setcolorbg(x:clrfocus), nil) })

*    aeval(members, {|X| if(ismembervar(x,'clrFocus'), ;
*                        if( x:oxbp <> oxbp, x:oxbp:setcolorbg(x:clrfocus), nil), nil ) })
    return .t.

  inline method setfocus(state)
    local  members := ::df:aMembers, pos

    _clearEventLoop( .t. )

    ::state := isnull(state,0)

    do case
    case(::state = 2)
      PostAppEvent(drgEVENT_APPEND,,,::brow)
      SetAppFocus(::brow)
    otherwise
      pos := ascan(members,{|X| (x = ::brow:cargo)})
      ::df:olastdrg   := ::brow:cargo
      ::df:nlastdrgix := pos
      ::df:olastdrg:setFocus()
      if isobject(::brow)
*        PostAppEvent(xbeBRW_ItemMarked,,,::brow)
*        ::brow:refreshCurrent():hilite()
      endif
    endcase
    return .t.

*    inline method tabSelect(oTabPage,tabnum)
*      local it_file
*      if oTabPage:tabNumber = 2 .and. isobject(::brow)
*        it_file := ::brow:cargo:cfile
*        if (it_file)->(eof())
*          PostAppEvent(drgEVENT_APPEND,,,::brow)
*        endif
*      endif
*    return .t.

    * reakce na ESC
    inline method esc_focustobrow()
      ::restColor()
      ::setfocus()
      ::brow:refreshCurrent():hilite()
      ::dm:refresh()
    return

    inline method esc_confirmBox()
      local nsel := XBPMB_RET_YES

      if .not. isWorkVersion
        nsel := confirmBox(,'Požadujete ukonèit poøízení BEZ uložení dat ?', ;
                            'Data nebudou uložena ...'                     , ;
                             XBPMB_YESNO                                   , ;
                             XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE  , ;
                             XBPMB_DEFBUTTON2                                )
      endif
    return nsel

HIDDEN:
  var    m_parent

ENDCLASS


method FIN_finance_in:openfiles(afiles)
  local  nin,file,ordno

  aeval(afiles, { |x| ;
       if(( nin := at(',',x)) <> 0, (file := substr(x,1,nin-1), ordno := val(substr(x,nin+1))), ;
                                    (file := x                , ordno := nil                )), ;
       drgdbms:open(x)                                                                        , ;
       if(isnull(ordno), nil, (file)->(AdsSetOrder(ordno)))                                     })
return nil


*
METHOD FIN_finance_IN:init(parent,typ_lik,one_edt,que_del,has_foot)
  local drgDialog := parent:drgDialog, members, x, in_file

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  ::m_parent := parent
  if isobject(drgDialog:oActionBar)
    ::ab      := drgDialog:oActionBar:members    // actionBar
  endif

  ::typ_lik            := typ_lik
  ::one_edt            := one_edt
  ::que_del            := que_del
  ::set_likvidace_inOn := 0
  ::in_scr             := .f.
  *
  ::new_dok := (drgDialog:cargo = drgEVENT_APPEND .or. drgDialog:cargo = drgEVENT_APPEND2)

  * pøí opravì se pozicujeme vžda na 1.BROw pokud je na FRM a má data *
  members  := ::df:aMembers
  BEGIN SEQUENCE
    FOR x := 1 TO LEN(members)
      IF lower(members[x]:ClassName()) $ 'drgbrowse,drgdbrowse,drgebrowse'
        ::brow  := members[x]:oXbp
        in_file := members[x]:cfile
  BREAK
      ENDIF
    NEXT
  ENDSEQUENCE

  if IsObject(::brow) .and. (in_file) ->(LastRec()) <> 0
     ::df:nextFocus := x
  endif

  * patièky *
  if isobject(::brow) .and. IsNull(has_foot,.f.)
    for x := 1 to ::brow:colCount step 1
      ocolumn := ::brow:getColumn(x)

      ocolumn:FooterLayout[XBPCOL_HFA_CAPTION]     := ''
      ocolumn:FooterLayout[XBPCOL_HFA_HEIGHT]      := drgINI:fontH - 2
      ocolumn:FooterLayout[XBPCOL_HFA_FRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
      ocolumn:FooterLayout[XBPCOL_HFA_ALIGNMENT]   := XBPALIGN_RIGHT
      ocolumn:configure()
    next
    ::brow:configure():refreshAll()
  endif
RETURN self


METHOD FIN_finance_IN:handleEvent(nEvent,mp1,mp2,oXbp)
  local curRec, inFile, lastDrg := ::df:oLastDrg, field_name, isBlocked := .f., hd_file, lastXbp, ok
  local nsel

  if nevent = xbeM_LbClick
    if (oxbp:classname() = 'XbpTabPage')
      if isobject(::brow) .and. .not. ::in_scr
        if ::brow:parent:parent:parent = oxbp
          ::brow:refreshCurrent():hilite()
          ::restColor()
        endif
      endif
    elseif .not. (oxbp:classname() = 'XbpCellGroup')

* ???      if(isobject(::brow) .and. .not. ::in_scr, ::brow:refreshCurrent():DeHilite(),nil)
*---    else
*---      if .not. ('_SCR' $ upper(::dm:drgDialog:formName))
*---        if(isobject(::brow) .and. .not. ::in_scr, ::brow:refreshCurrent():hilite(), nil)
*---        ::restColor()
*---      endif
    endif
  endif

  do case
  case nEvent = xbeBRW_ItemMarked
    ::msg:editState:caption := 0
    ::msg:WriteMessage(,0)
    ::state := 0
    if(isobject(::brow), ::brow:hilite(), nil)
    ::restColor()
    RETURN .F.

  case nEvent = drgEVENT_APPEND
     _clearEventLoop(.t.)

    if IsObject(::brow)
      ok := if(isMethod(self,'overPostAppend'), ::overPostAppend(), .t.)

      if ok
        setAppFocus(::brow)
        inFile := ::brow:cargo:cFile

        *
        ** nová metoda na drgDataManager
        ** nastaví pro daný soubor prázdné hodnoty

        ::dm:refreshAndSetEmpty( inFile )

        if(IsMethod(self, 'postAppend'), ::postAppend(), Nil)
        ::state := 2
        if(isobject(::brow),::brow:refreshCurrent():DeHilite(),nil)
        ::df:setNextFocus(::one_edt,, .T. )
      else
        ::esc_focustobrow()
      endif
      RETURN .T.
    endif

  case nEvent = drgEVENT_APPEND2
    if IsObject(::brow)
      _clearEventLoop()
      PostAppEvent(drgEVENT_APPEND,,,::brow)
      return .t.
    endif

  case nEvent = drgEVENT_EDIT
    ::state := 1
    if(isobject(::brow),::brow:refreshCurrent():DeHilite(),nil)
    if(IsMethod(self, 'postEdit'), ::postEdit(), Nil)
    ::df:setNextFocus(::one_edt,, .T. )
    return .T.

  case nEvent = drgEVENT_DELETE
     if( lastDRG:className() = 'drgDBrowse' .or. oxbp:className() = 'XbpBrowse') .and. isobject(::brow)

       inFile := ::brow:cargo:cFile
       if drgIsYESNO('Zrušit položku ' +::que_del +' ?')

         (inFile) ->_delrec := '9'
         if(IsMethod(self, 'postDelete'), ::postDelete(), Nil)

         ::brow:panHome()
         ::brow:refreshAll()
         ::dm:refresh()
       else
         ::setFocus()
       endif
       RETURN .T.
     endif

    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()

      if .not. (lower(::df:oLastDrg:classname()) $ 'drgbrowse,drgdbrowse') .and. isobject(::brow)
        ok := if(isMethod(self,'overPostLastField'), ::overPostLastField(), .t.)

        if(IsMethod(self, 'postLastField') .and. ok, ::postLastField(), Nil)
      else
        if isMethod(self,'postSave')
           hd_file := left(::m_parent:hd_file, len(::m_parent:hd_file)-1)

           if FIN_postsave():new(hd_file,::m_parent):ok
             if ::postSave()
               if( .not. ::new_dok,PostAppEvent(xbeP_Close, nEvent,,oXbp),nil)
               return .t.
             endif
           endif
        else
          drgMsg(drgNLS:msg('Doklad je ve stavu rozpracován -nebude uložen- omlouvám se ...'),,::dm:drgDialog)
          return .t.
        endif
      endif

*   case nEvent = xbeP_Keyboard .or. nEvent = xbeP_Close
*     if( nEvent = xbeP_Close, mp1 := xbeK_ESC, nil )

   case nEvent = xbeP_Keyboard
     * blokování položek
     if lastDrg:className() = 'drgGet'
       field_name := lower(drgParseSecond(lastDrg:name, '>'))
       do case
       case(lower(lastDrg:name) = 'fakprihdw->nparzahfak')  ;  isBlocked := .t.
       case(lower(lastDrg:name) = 'fakvyshdw->nparzahfak')  ;  isBlocked := .t.
*-       case(lower(lastDrg:name) = 'fakvysitw->ncejPrZbz' )
*-         isBlocked := if( isMethod(self,'cejPrZbz_push'), ::cejPrZbz_push(), .f.)
       case(lower(lastDrg:name) = 'objvysitw->nmnozobodb')  ;  isBlocked := .t.
       case(lower(lastDrg:name) = 'pvpitemww->nmnozprdod')  ;  isBlocked := .t.
       endcase

       if isBlocked .and. (mp1 >= 32 .and. mp1 <= 255)
         return .t.
       endif
     endif

     if mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse' .and. isobject(::brow)
       if( isMethod(self,'postEscape'), ::postEscape(), nil)

       * na kase blbnou s TAB a ESC
       if lower(::brow:cargo:cfile) $ lower( isNull(lastDrg:name, '') )
         ::esc_focustobrow()
         return .t.
       else
         if isobject(::df:tabPageManager:active)
           if ::esc_confirmBox() = XBPMB_RET_YES
             return .f.
           else
             return .t.
           endif
         else
           if( lower(lastDrg:name) = 'poklhdw->ncisfirmy')
             if ::m_parent:udcp:on_firmySel = '1' .and. lastDrg:oVar:value = 0
               if ::esc_confirmBox() = XBPMB_RET_YES
                 return .f.
               else
                 return .t.
               endif
             endif
           endif

           ::esc_focustobrow()
           return .t.
         endif
       endif

     else
       if mp1 = xbeK_ESC // .and. .not. isWorkVersion

         if .not. isWorkVersion
           nsel := confirmBox(,'Požadujete ukonèit poøízení BEZ uložení dat ?', ;
                               'Data nebudou uložena ...'                     , ;
                                XBPMB_YESNO                                   , ;
                                XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE  , ;
                                XBPMB_DEFBUTTON2                                )
         else

           nsel := XBPMB_RET_YES
         endif


         if (nsel = XBPMB_RET_YES)
           if( isMethod(self,'postEscape'), ::postEscape(), nil)
           _clearEventLoop(.t.)

             if isObject(::dm)
               postAppEvent(xbeP_Close,,,::dm:drgDialog:dialog)
             endif
           return .f.
         else
           return .t.
         endif
       endif

       return .f.

     endif
   endcase
return .F.


*
** vnucené naèetní dat pro zobrazení celé nebo skupiny GROUPS
method FIN_finance_in:refreshGroup(drgvar,panGroup,nextFocus)
  local  nin, ovar, vars, new_val, dbarea, ok

  default nextFocus to .f.

  dbarea := lower(drgParse(drgVar:name,'-'))
  vars   := drgVar:drgDialog:dataManager:vars

  for x := 1 to vars:size() step 1
    ovar := vars:getNth(x)
    if(empty(ovar:odrg:groups) .or. ovar:odrg:groups = panGroup)
      if (dbArea == lower(drgParse(oVar:name,'-')) .or. 'M' == drgParse(oVar:name,'-')) .and. isblock(ovar:block)
        if(new_val := eval(ovar:block)) <> ovar:value
          ovar:set(new_val)
        endif
      endif
    endif
  next

  if nextFocus
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
  endif
return .t.


method FIN_finance_IN:refresh(drgVar,nextFocus,vars_)
  local  nin, ovar, vars, new_val, dbArea

  default nextFocus to .f.

  if isobject(drgVar)  ;  dbarea := lower(drgParse(drgVar:name,'-'))
                          vars   := drgVar:drgDialog:dataManager:vars
  else                 ;  dbarea := lower(drgVar)
                          vars   := vars_
  endif

  for nIn := 1 TO vars:size() step 1
    oVar := vars:getNth(nIn)

    if (dbArea == lower(drgParse(oVar:name,'-')) .or. 'M' == drgParse(oVar:name,'-')) .and. isblock(ovar:block)
      if(new_val := eval(ovar:block)) <> ovar:value
        ovar:set(new_val)
      endif
      ovar:initValue := ovar:prevValue := ovar:value
    endif
  next

  if nextFocus
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
  endif
return .t.


method FIN_finance_IN:copyfldto_w(from_db,to_db,app_db)
  local npos, xval, afrom := (from_db)->(dbstruct()), x

  if(isnull(app_db,.f.),(to_db)->(dbappend()),nil)
  for x := 1 to len(afrom) step 1
    if .not. (lower(afrom[x,DBS_NAME]) $ '_nrecor,_delrec,nfaktm_org')
      xval := (from_db)->(fieldget(x))
      npos := (to_db)->(fieldpos(afrom[x,DBS_NAME]))

      if(npos <> 0, (to_db)->(fieldput(npos,xval)), nil)
    endif
  next
return nil


** èitaè poøadí položek dokladu
METHOD FIN_finance_IN:ordItem()
  local recNo, ordNo, ordItem := 0

  if IsObject(::brow)
    inFile  := ::brow:cargo:cFile
    recNo := (inFile)->(recno())
    ordNo := (inFile)->(ordSetFocus())
             (inFile)->(AdsSetOrder(0))

    do case
    case (infile)->(fieldpos('norditem')) <> 0
      (inFile) ->(dbgotop(), dbeval({|| ordItem := max(ordItem,(inFile)->norditem) }))

    case (infile)->(fieldpos('nintcount')) <> 0
      (inFile) ->(dbgotop(), dbeval({|| ordItem := max(ordItem,(inFile)->nintcount)}))

    case (infile)->(fieldpos('ncislpolob')) <> 0
      (inFile) ->(dbgotop(), dbeval({|| ordItem := max(ordItem,(inFile)->ncislpolob) }))

    endcase

    (inFile)->(AdsSetOrder(ordNo),dbgoto(recNo))
  endif
RETURN ordItem


method FIN_finance_IN:itSave(panGroup)
  local  x, ok := .t., vars := ::dm:vars, drgVar

  for x := 1 to ::dm:vars:size() step 1
    drgVar := ::dm:vars:getNth(x)
    if ISCHARACTER(panGroup)
      ok := (empty(drgVar:odrg:groups) .or. drgVar:odrg:groups = panGroup)
    endif

    if isblock(drgVar:block) .and. at('M->',drgVar:name) = 0 .and. ok
      if (eval(drgvar:block) <> drgVar:value) // .and. .not. drgVar:rOnly
        eval(drgVar:block,drgVar:value)
      endif
      drgVar:initValue := drgVar:value
    endif
  next
return self


*
** OBECNÉ **
METHOD FIN_finance_IN:fin_cmdph(drgDialog)
  LOCAL oDialog, nExit, odrg := ::df:olastdrg, m_file

  DRGDIALOG FORM 'FIN_CMDPH' PARENT drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit != drgEVENT_QUIT
*-->    ::fin_finance_in:refresh(odrg,.f.)

    m_file := lower(drgParse(odrg:name,'-'))

    if m_file = 'fakvysitw' .or. m_file = 'fakpriitw'  ;  ::dm:set(m_file +'->nvypsazdan',1)
    else                                               ;  ::fin_finance_in:refresh(odrg,.f.)
                                                          ::fin_vykdph_mod(m_file)
    endif
    PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,odrg:oxbp)
  endif
RETURN (nExit != drgEVENT_QUIT)


method FIN_finance_in:fin_kurzit(odrg,dporiz,dvyst)
  local  changed    := odrg:itemChanged()
  local  item_name  := lower(odrg:name)
  local  field_name := lower(drgParseSecond(item_name, '>'))
  local  file_name  := drgParse(item_name,'-')
  *
  local  ncntKurzit := 0

  do case
  case( field_name $ 'czkratstat,czkratmenz,cbank_uct,czkratmenu') .and. changed
    do case
    case field_name $ 'czkratstat'
      c_staty->(dbseek(upper(odrg:value),,'C_STATY1'))
      zkrMeny := upper(c_staty->czkratmeny)

    case field_name $ 'czkratmenz,czkratmenu,czahrmena'
      c_meny->(dbseek(upper(odrg:value),,'C_MENY1'))
      zkrMeny := upper(c_meny->czkratmeny)

    otherWise
      zkrMeny := upper(c_bankuc->czkratmeny)

    endCase

**    kurzit->(AdsSetOrder(9), dbsetscope(SCOPE_BOTH,zkrMeny))
    kurzit->( ordSetFocus( 'KURZIT9' ), dbsetscope(SCOPE_BOTH,zkrMeny))
    cky := zkrMeny +dtos(dporiz)

    kurzit->(dbseek(cky,.t.))
    if( kurzit->nkurzstred = 0, kurzit->(dbgobottom()),nil)
    (file_name)->czkratmenz := zkrMeny
    (file_name)->nkurzahmen := kurzit->nkurzstred
    (file_name)->nmnozprep  := kurzit->nmnozprep

    if .not. isnull(dvyst)
      cky := zkrMeny +dtos(dvyst)

      kurzit->(dbseek(cky,.t.))
      if( kurzit->nkurzstred = 0, kurzit->(dbgobottom()),nil)
      (file_name)->nkurzahmed := kurzit->nkurzstred
      (file_name)->nmnozpred  := kurzit->nmnozprep
    endif

    kurzit->(dbclearscope())

    eval(odrg:block,odrg:value)
    ::fin_finance_in:refresh(odrg)

    if odrg:odrg:className() = 'drgComboBox'
      PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,odrg:odrg:oxbp)
    endif
  endcase
return


*
** modifikace vykdph_iw pøi zmìnì dat základního souboru
method FIN_finance_in:FIN_vykdph_mod(mainFile)
  local  ordNo := vykdph_iw->(AdsSetOrder('VYKDPH_4'))
  local  zakld_dph, sazba_dph

  vykdph_iw->(Flock())

  for x := 0 to 3 step 1
    zakld_dph := sazba_dph := 0
    vykdph_iw->(dbsetscope(SCOPE_BOTH,str(x,1)), ;
                dbgotop()                      , ;
                dbeval({|| (zakld_dph += vykdph_iw->nzakld_dph, sazba_dph += vykdph_iw->nsazba_dph) }))

    do case
    case(x == 0)
      if (mainFile)->nosvoddan <> zakld_dph
        vykdph_iw->(dbeval({|| (vykdph_iw->nzakld_dph := 0, vykdph_iw->nsazba_dph := 0) }), dbgotop())

        if .not. vykdph_iw->( dbseek( str(x,1) +'1',, 'VYKDPH_4'))
          vykdph_iw->(dbgoTop())
        endif

        vykdph_iw->nzakld_dph := (mainFile)->nosvoddan
        vykdph_iw->nsazba_dph := 0
      endif

    case(x == 1)
      if (mainFile)->nzakldan_1 <> zakld_dph .or. (mainFile)->nsazdan_1 <> sazba_dph
        vykdph_iw->(dbeval({|| (vykdph_iw->nzakld_dph := 0, vykdph_iw->nsazba_dph := 0) }), dbgotop())

        * pøednastavený ØV ?
        if .not. vykdph_iw->( dbseek( str(x,1) +'1',, 'VYKDPH_4'))
          if .not. vykdph_iw->( dblocate( { || .not. vykdph_iw->lsetPreDan } ))
            vykdph_iw->(dbgoTop())
          endif
        endif

        vykdph_iw->nzakld_dph := (mainFile)->nzakldan_1
        vykdph_iw->nsazba_dph := (mainFile)->nsazdan_1
      endif

    case(x == 2)
      if (mainFile)->nzakldan_2 <> zakld_dph .or. (mainFile)->nsazdan_2 <> sazba_dph
        vykdph_iw->(dbeval({|| (vykdph_iw->nzakld_dph := 0, vykdph_iw->nsazba_dph := 0) }), dbgotop())

        * pøednastavený ØV ?
        if .not. vykdph_iw->( dbseek( str(x,1) +'1',, 'VYKDPH_4'))
          if .not. vykdph_iw->( dblocate( { || .not. vykdph_iw->lsetPreDan } ))
            vykdph_iw->(dbgoTop())
          endif
        endif

        vykdph_iw->nzakld_dph := (mainFile)->nzakldan_2
        vykdph_iw->nsazba_dph := (mainFile)->nsazdan_2
      endif

    case(x == 3)
      if (mainFile)->nzakldan_3 <> zakld_dph .or. (mainFile)->nsazdan_3 <> sazba_dph
        vykdph_iw->(dbeval({|| (vykdph_iw->nzakld_dph := 0, vykdph_iw->nsazba_dph := 0) }), dbgotop())

        * pøednastavený ØV ?
        if .not. vykdph_iw->( dbseek( str(x,1) +'1',, 'VYKDPH_4'))
          if .not. vykdph_iw->( dblocate( { || .not. vykdph_iw->lsetPreDan } ))
            vykdph_iw->(dbgoTop())
          endif
        endif

        vykdph_iw->nzakld_dph := (mainFile)->nzakldan_3
        vykdph_iw->nsazba_dph := (mainFile)->nsazdan_3
      endif

    endcase
  next

  vykdph_iw->(AdsSetOrder(ordNo))
return .t.


method FIN_finance_in:FIN_vykdph_in(drgDialog)
  local  oDialog, nExit, block, oXbp := drgDialog:lastXbpInFocus, value
  *
  local  inEdit := If( IsNull(drgDialog:cargo), .F., .T.)
  local  cb_cpy := SubStr(drgDialog:formName,1,Rat('_',drgDialog:formName))+'cpy()'
  local  mainFile

  IF Lower(cb_cpy) $ 'fin_fakprihdzz_cpy(),fin_fakvyshdzz_cpy()'
    cb_cpy := 'FIN_ucetdohd_cpy()'
  ENDIF

  IF( inEdit, NIL, Eval( &("{||" + cb_cpy + "}")))

  oDialog := drgDialog():new('FIN_vykdph_IN',drgDialog)
  oDialog:cargo_Usr := inEdit
  oDialog:create(,,.T.)

  * režim dokladu
  if isnumber(drgDialog:cargo)
    mainFile := odialog:udcp:mainFile

    (mainFile)->nosvoddan  := odialog:udcp:nosvoddan
    (mainFile)->nzakldan_1 := odialog:udcp:nzakldan_1
    (mainFile)->nsazdan_1  := odialog:udcp:nsazdan_1
    (mainFile)->nzakldan_2 := odialog:udcp:nzakldan_2
    (mainFile)->nsazdan_2  := odialog:udcp:nsazdan_2

    ::fin_finance_in:refresh( mainFile,,drgDialog:dataManager:vars)

    if isobject(oXbp) .and. oXbp:className() = 'XbpGet'
      value := DBGetVal(oXbp:cargo:name)
      oXbp:cargo:oVar:prevValue := value
    endif
  endif


  oDialog:destroy(.T.)
  oDialog := NIL
RETURN self


METHOD FIN_finance_in:FIN_likvidace_in(drgDialog)
  LOCAL  oDialog,  nExit, last_Cargo := drgDialog:cargo
  local  ordNo := ucetpol->(AdsSetOrder()), ascope := ucetpol->(dbscope(SCOPE_BOTH))
  *
  LOCAL  inEdit := If( IsNull(drgDialog:cargo), .F., .T.)
  LOCAL  cb_cpy := SubStr(drgDialog:formName,1,Rat('_',drgDialog:formName)) +'cpy()'

  if Lower(cb_cpy) $ 'fin_fakprihdzz_cpy(),fin_fakvyshdzz_cpy()'
    cb_cpy := 'FIN_ucetdohd_cpy()'
  endif

  if lower(cb_cpy) $ 'fin_banvyphd_vzz_cpy()'
    cb_cpy := 'fin_banvyp_cpy()'
  endif

  IF( inEdit, NIL, Eval( &("{||" + cb_cpy + "}")))

  oDialog := drgDialog():new('FIN_likvidace_IN',drgDialog)

  if( inEdit, drgDialog:cargo := Nil, nil )
  *
  **
  oDialog:create(,drgDialog:dialog, .t. )  // inEdit)
  **
  *
  if( inEdit, drgDialog:cargo := last_Cargo, nil )

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL

  ucetpol->(AdsSetOrder(ordNo))
  if( isarray(ascope) .and. .not. isnull(ascope[1]), ucetpol->(dbsetscope(SCOPE_BOTH,ascope[1]),dbgotop()), nil)

  if  .not. inedit
    PostAppEvent(xbeBRW_ItemMarked,,,drgDialog:dialogCtrl:oaBrowse:oXbp)
  endif
RETURN self

*
** likvidace vnitro_podnikov0 faktury
METHOD FIN_finance_in:FIN_fakvnphd_lik_in(drgDialog)
  LOCAL  oDialog,  nExit, last_Cargo := drgDialog:cargo
  local  ordNo := ucetpol->(AdsSetOrder()), ascope := ucetpol->(dbscope(SCOPE_BOTH))
  *
  LOCAL  inEdit := If( IsNull(drgDialog:cargo), .F., .T.)
  LOCAL  cb_cpy := SubStr(drgDialog:formName,1,Rat('_',drgDialog:formName)) +'cpy()'

  if Lower(cb_cpy) $ 'fin_fakprihdzz_cpy(),fin_fakvyshdzz_cpy()'
    cb_cpy := 'FIN_ucetdohd_cpy()'
  endif

  if lower(cb_cpy) $ 'fin_banvyphd_vzz_cpy()'
    cb_cpy := 'fin_banvyp_cpy()'
  endif

  IF( inEdit, NIL, Eval( &("{||" + cb_cpy + "}")))

  oDialog := drgDialog():new('FIN_fakvnphd_lik_in',drgDialog)

  if( inEdit, drgDialog:cargo := Nil, nil )
  *
  **
  oDialog:create(,drgDialog:dialog, .t. )  // inEdit)
  **
  *
  if( inEdit, drgDialog:cargo := last_Cargo, nil )

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL

  ucetpol->(AdsSetOrder(ordNo))
  if( isarray(ascope) .and. .not. isnull(ascope[1]), ucetpol->(dbsetscope(SCOPE_BOTH,ascope[1]),dbgotop()), nil)

  if  .not. inedit
    PostAppEvent(xbeBRW_ItemMarked,,,drgDialog:dialogCtrl:oaBrowse:oXbp)
  endif
RETURN self

*
** povolení/zákaz akcí pro daný typ dokladu ************************************
METHOD FIN_finance_IN:fakprihd_act(drgDialog)
  LOCAL  ab     := drgDialog:oActionBar:members      // actionBar
  LOCAL  inEdit := If( IsNull(drgDialog:cargo), .F., .T.)
  LOCAL  x, ev, om, ok
  *
  LOCAL  finTyp := Str(IF(inEdit, FAKPRIHDw ->nFINTYP, FAKPRIHD ->nFINTYP),1), typZal
  *
  local  filter := "strzero(ncisFirmy,5) = '%%' .and. strZero(nfinTyp,1) = '%%' .and. (nUHRCELFAK <> 0)"


  FOR x := 1 TO LEN(ab) STEP 1
    ev := Lower( isNull( ab[x]:event, ''))
    om := ab[x]:parent:aMenu

    IF ev $ 'fin_likvidace_in,fin_vykdph_in,fin_parprzal'
      DO case
      CASE(ev = 'fin_likvidace_in')
        ok := (finTyp $ '1,2,4,6')
      CASE(ev = 'fin_vykdph_in'   )
        ok := (finTyp $ '1,2,6'  )
      CASE(ev = 'fin_parprzal'    )
        ok := (finTyp $ '1,4,6'  )
        IF ok
          * test zda pro firmu,typFak,uhrFak -   existují uhrazené zálFak *
          typZal := If(finTyp = '4' .or. finTyp = '6', '5', '3')
          fakprih_ow->(ads_setAof(format(filter,{strZero(fakprihdw->ncisFirmy,5),typZal})), dbGoTop())
          ok := .not. fakprih_ow->(Eof())
          IF(ok, drgDialog:UDCP:butPar:enable(), drgDialog:UDCP:butPar:disable())

          fakprih_ow->(ads_clearAof())

          ::m_filter_parprZal := format(filter,{strZero(fakprihdw->ncisFirmy,5),typZal})
        ENDIF
      ENDCASE

      ab[x]:disabled := .not. ok

      if(ok, ab[x]:oxbp:enable(), ab[x]:oxbp:disable() )
    ENDIF
  NEXT
RETURN


*
** comboboxinit pro dané typy datových položek
method FIN_finance_IN:comboBoxInit(drgComboBox)
  LOCAL  cname      := drgParseSecond(drgComboBox:name,'>')
  local  in_file    := lower(drgParse(drgComboBox:name,'-'))
  LOCAL  afields    := {'x-NRADVYKDPH', 'NPROCDAN_1', 'NPROCDAN_2', 'NPROCDAN_3'              , ;
                        'CTYPPOHYBU'  , 'COBDOBI'   , 'COBDOBIDAN', 'CTYPDOKLAD', 'CTYPOBRATU'  }
  local  acombo_val := {}, nnapocet, ky, pa, block := { || .t. }, x, ncol, nrow

  * ?? doklad v režimu opravy
  local  inRevision := (drgComboBox:drgDialog:cargo = drgEVENT_EDIT), onSort := 2, filter, uloha
  local  value, rok, typ_dokl, ctypKurzu


  drgDBMS:open('c_typpoh')
  drgDBMS:open('typdokl' )  ;  typdokl->(AdsSetOrder('TYPDOKL01'))

  IF AScan(aFIELDs,cNAMe) <> 0
    DO CASE
    CASE ('x-NRADVYKDPH' $ cNAME)
      aadd(acombo_val, {0,'                     ','111','111111'})
      c_vykdph->(dbeval( {|| aadd(acombo_val, ;
                                  {c_vykdph->nradek_dph                                , ;
                                   str(c_vykdph->nradek_dph) +'_' +c_vykdph->cradek_say, ;
                                   c_vykdph->cmaska_dph                                , ;
                                   c_vykdph->fakvysit                                    } ) }, ;
                         {|| c_vykdph->ndat_od    = 20040501 .and. ;
                             c_vykdph->nradek_dph <> 0       .and. ;
                             .not. empty(c_vykdph->fakvysit)       } ))
      drgComboBox:groups := aclone(acombo_val)

    CASE ('NPROCDAN_'  $ cNAME)
      nNAPOCET := Val(Right(drgComboBox:name,1))
      c_dph->(dbeval( {|| aadd( aCOMBO_val, {c_dph->nprocDph, strTran( str(c_dph->nprocDph), ' ', '')} ) }, ;
                      {|| c_dph->nnapocet = nnapocet }                                   ))

    case('CTYPPOHYBU' = cname)
      do case
      case(in_file = 'fakprihdw')  ;  ky := F_ZAVAZKY
      case(in_file = 'prikuhhdw')  ;  ky := F_BANKAPR
        if IsMemberVar( drgComboBox:drgDialog:UDCP, 'cblock' )
          if .not. empty( drgComboBox:drgDialog:UDCP:cblock )
            block := COMPILE( drgComboBox:drgDialog:UDCP:cblock )
          endif
        endif

      case(in_file = 'fakvyshdw')  ;  ky := F_POHLEDAVKY
        if lower(left(drgComboBox:drgDialog:parent:formName,3)) = 'pro'
          block := COMPILE("lower(c_typpoh->csubtask) = 'pro'")
        endif

      case(in_file = 'banvyphdw')
        typ_dokl := drgcombobox:drgdialog:udcp:typ_dokl
        ky       := if(typ_dokl = 'ban', F_BANKA, if(typ_dokl = 'vzz', F_ZAPOCET, F_UHRADY))
      case(in_file = 'pokladhdw')  ;  ky := F_POKLADNA
      case(in_file = 'ucetdohdw')
        do case
        case ismembervar(drgcombobox:drgdialog:udcp,'typ_zz')
          ky := if(drgcombobox:drgdialog:udcp:typ_zz = 'zav',F_ZAVAZKYZAPZ,F_POHLEDAVKYZAPZ)
        otherwise
          ky := F_UCETDOKL
        endcase

      * vnitro_podniková faktura
      case(in_file = 'fakvnphdw' )  ;  ky := F_VNITROFAK

      * nákup
      case(in_file = 'dodlstphdw')  ;  ky := N_DODLISTY
      case(in_file = 'objvyshdw' )  ;  ky := N_OBJEDNAVKY
      case(in_file = 'nabprihdw' )  ;  ky := N_NABIDKY

      * prodej
      case(in_file = 'dodlsthdw' )  ;  ky := E_DODLISTY
      case(in_file = 'objheadw'  )  ;  ky := E_OBJEDNAVKY
      case(in_file = 'nabvyshdw' )  ;  ky := E_NABIDKY
      case(in_file = 'poklhdw'   )  ;  ky := E_REGPOKLADNA
      case(in_file = 'explsthdw' )  ;  ky := E_EXPEDICE

      * ucto
      case(in_file = 'uctdokhdw' )  ;  ky := U_UCETDOKL
      endcase

      c_typpoh->(dbsetscope(SCOPE_BOTH,ky), dbgotop())
      do while .not. c_typpoh ->(eof())
        if eval(block)
          typdokl ->(dbseek(c_typpoh ->(sx_keyData())))
          ctypKurzu := CoalesceEmpty(c_typpoh->ctypKurzu, 'DEN')

          aadd( acombo_val, { c_typpoh ->ctyppohybu       , ;
                              c_typpoh ->cnaztyppoh       , ;
                              c_typpoh ->ctypdoklad       , ;
                              alltrim(typdokl  ->ctypcrd) , ;
                              c_typpoh->ctask             , ;
                              c_typpoh->csubtask          , ;
                              c_typpoh->craddph091        , ;
                              c_typpoh->cvypSAZdan        , ;
                              c_typpoh->npokladEET        , ;
                              ctypKurzu                     } )
        endif
        c_typpoh->(dbskip())
      ENDDO
      c_typpoh ->(dbclearscope())

    case('CTYPDOKLAD' = cname) .and. (in_file = 'ucetdohdw')
      ky := if(in_file = 'ucetdohdw', F_UCETDOKL, F_BANKA)
      c_typpoh->(AdsSetOrder('C_TYPPOH01'),dbsetscope(SCOPE_BOTH,ky),dbgotop())
      do while .not. c_typpoh->(eof())
        typdokl->(dbseek(c_typpoh->(sx_keydata())))
        pa := listasarray(typdokl->ctypcrd)
        aadd( acombo_val, {c_typpoh->ctypdoklad, ;
                           c_typpoh->cnaztyppoh , ;
                           c_typpoh->ctypdoklad,c_typpoh->ctyppohybu,val(pa[2]),pa[1] })

        c_typpoh->(dbskip())
      enddo
      c_typpoh->(dbclearscope())

    case ('COBDOBI'    = cNAME)
      (uloha := upper((in_file)->culoha), onSort := 3)
       uloha := if(uloha = 'E' .or. uloha = 'N', 'S', uloha)

      if inRevision .and. .not. drgComboBox:isEdit
        * doklad v režimu ->oprava / položka ->noEdit ==> nelze zmìnit položku

        ucetsys ->( DbSeek(uloha +drgComboBox:oVar:value,,'UCETSYS2'))
        AAdd(acombo_val, { ucetsys->cobdobi                                           , ;
                           StrZero(ucetsys->nobdobi,2) +'/' +StrZero(ucetsys->nrok,4) , ;
                           uloha +StrZero(ucetsys->nrok,4) +StrZero(ucetsys->nobdobi,2) } )
      else
        * doklad v režimu ->nový   / nabízet prázdné +neZavøené období
        AAdd(acombo_val,{ '  /  ', '__/____', '000000'})
        *
        filter := Format("culoha = '%%' .and. .not. lzavren", {uloha})
        *
        ucetsys->(DbSetFilter(COMPILE(filter)),DbGoTop(), ;
                  DbEval( {|| AAdd(acombo_val, ;
                          { ucetsys->cobdobi                                           , ;
                            StrZero(ucetsys->nobdobi,2) +'/' +StrZero(ucetsys->nrok,4) , ;
                            uloha +StrZero(ucetsys->nrok,4) +StrZero(ucetsys->nobdobi,2) }) }), ;
                  DbClearFilter() )

        if inRevision
          value := drgComboBox:ovar:value

          ucetsys->(dbseek(uloha +value,,'UCETSYS2'))
          if ucetsys->lzavren
            (drgComboBox:isEdit := .f., drgComboBox:oxbp:disable())
          endif

          if ascan(acombo_val,{|x| x[1] = value }) = 0
            rok := year(ctod('01.' +left(value,2) +'.' +right(value,2)))
            aadd(acombo_val, {value, left(value,3) +str(rok,4), uloha +str(rok,4) +left(value,2)})

//            (drgComboBox:isEdit := .f., drgComboBox:oxbp:disable())
          endif
        endif
      endif

    CASE ('COBDOBIDAN' = cNAME)
      (uloha := upper((in_file)->culoha), onSort := 3)
       uloha := if(uloha = 'E' .or. uloha = 'N', 'S', uloha)

      FOrdRec({'UCETSYS,3'})
      UCETSYS ->( DbSetScope(SCOPE_BOTH, uloha), ;
                             DBGoTop()         , ;
                  DbEval( { || AAdd( aCOMBO_val, { ucetsys ->cobdobiDan                                       , ;
                                                   left(ucetsys->cobdobiDan,3) +strZero(ucetsys->nrok,4)      , ;
                                                   uloha +strZero(ucetsys->nrok,4) +left(ucetsys->cobdobiDan,2) } ) }, ;
                          { || DAN_obd_OK(aCOMBO_val) }                                      ), ;
                  DbClearScope()               )
      FOrdRec()

      * oprava dokladu / zavøené daòové období
      if inRevision
        value := drgComboBox:ovar:value

        if(select('dph_2009') = 0, drgDBms:open('dph_2009'), nil)
        if(select('dph_2011') = 0, drgDBms:open('dph_2011'), nil)

        if ( dph_2009->(dbseek(value,,'DPHDATA')) .or. dph_2011->(dbseek(value,,'DPHDATA')) )
          (drgComboBox:isEdit := .f., drgComboBox:oxbp:disable())
        endif

      else
        value := uctOBDOBI:FIN:COBDOBIDAN
      endif

      if ascan(acombo_val,{|x| x[1] = value }) = 0
        rok := year(ctod('01.' +left(value,2) +'.' +right(value,2)))
        aadd(acombo_val, {value, left(value,3) +str(rok,4), uloha +str(rok,4) +left(value,2)})
      endif
    ENDCASE

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[onSort] < aY[onSort] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    drgComboBox:value := drgComboBox:ovar:value

  ENDIF
RETURN self


method fin_finance_in:cobdobi(drgComboBox)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nin, obdobi, cfile, obdobi_dan
  *
  local  dm := drgComboBox:drgDialog:dataManager

  nin    := ascan(values, {|X| X[1] = value })
  obdobi := values[nin,3]
  cfile  := drgParse(drgComboBox:name,'-')

  (cfile)->cobdobi := values[nin,1]
  (cfile)->nrok    := val(substr(obdobi,2,4))
  (cfile)->nobdobi := val(substr(obdobi,6,2))


*-  if isobject(obdobi_dan := dm:has(cfile +'->cobdobidan'))
*-    ucetsys->(dbseek(obdobi,,'UCETSYS3'))
*-    obdobi_dan:set(ucetsys->cobdobidan)
*-  endif
return self


method fin_finance_in:memoEdit(drgDialog)
  local odialog, nexit
  *
  local nEvent,mp1,mp2,oXbp,pa, value
  local is_inBro

  nEvent   := LastAppEvent(@mp1,@mp2,@oXbp)
  pa       := ListAsArray(oxbp:cargo:caption)
  is_inBro := ( drgDialog:lastXbpInFocus:className() = 'XbpBrowse' )

  odialog       := drgDialog():new('MEMOEDIT', drgDialog)
  odialog:cargo := pa[1]
  odialog:create(,,.T.)

  *
  value := odialog:dataManager:get(pa[1])
  do case
  case(val(pa[2]) = 1)                           // ukládame na hlavièce
    DBPutVal(pa[1],value)
  otherwise                                      // ukládáme až pøi položky
    if isobject(odrg := drgDialog:dataManager:has(pa[1]))
      odrg:value := value
    endif
  endcase
  odialog:destroy(.T.)
  odialog := nil

  if( ::inBrow() .or. is_inBro, PostAppEvent(drgEVENT_EDIT,,,::brow), nil)
return .t.


*
** kontola dokladú na vazební èíselník c_naklst
** na banvypit je dvojí kontrola cnazPol1 .. 6 a cnazPol1K .. 6
method fin_finance_in:c_naklst_vld(drgVar_nazPol1,ucet)
  local  name  := Lower(drgVar_nazPol1:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  cEx   := if( item = 'cnazpol1k', 'k', '')
  *
  local  x, value := '', ok := .f., showDlg := .f.
  local  lnaklStr := .f.                         // nákladová struktura není povinná

  drgDBMS:open('c_naklst')
  drgDBMS:open('c_uctosn')

  if .not. isNull(ucet)
    c_uctosn->(dbSeek( upper(ucet),,'UCTOSN1'))
    lnaklStr := c_uctosn->lnaklStr
  endif

  for x := 1 to 6 step 1
    value += upper(::dm:get(file +'->cnazPol' +str(x,1) +cEx))
  next

  do case
  case( empty(value) .and. .not. lnaklStr)
    ok := .t.
  case( empty(value) .and.       lnaklStr)
    fin_info_box('Nákladová struktura je pro úèet >' +ucet +'<' +CRLF +' !!! POVINNÁ !!!')
  otherwise
    ok      := c_naklSt->(dbseek(value,,'C_NAKLST1'))
    showDlg := .not. ok
  endcase

  if showDlg
    DRGDIALOG FORM 'c_naklst_sel' PARENT ::dm:drgDialog MODAL           ;
                                                        DESTROY         ;
                                                        EXITSTATE nExit ;
                                                        CARGO drgVar_nazPol1

    if nexit != drgEVENT_QUIT .or. ok
      for x := 1 to 6 step 1
        ::dm:set(file + '->cnazPol' +str(x,1) +cEx, DBGetVal('c_naklSt->cnazPol' +str(x,1)))
      next
      postAppEvent(xbeP_Keyboard,xbeK_ESC,,drgVar_nazPol1:odrg:oxbp)
      ok := .t.
    else
      ::df:setNextFocus(file +'->cnazPol1' +cEx,,.t.)
    endif
  else

    if( empty(value) .and.       lnaklStr)
      ::df:setNextFocus(file +'->cnazPol1' +cEx,,.t.)
    endif
  endif
return ok


*
** obecná metoda pro získání dat pro ceníkové položky typu SESTAVA
method fin_finance_in:fin_mapolSest_in(hd_file)
  local cky_kus := space(30) +upper(cenzboz->csklPol), cky_cen := upper(cenzboz->ccisSklad)
  *
  local mapolSest := '', cky

  drgDBMS:open('KUSOV')
  drgDBMS:open('CENZBOZ',,,,,'cenzbozsw')

  * TMP
  if select('fakvysitsw') = 0
    drgDBMS:open('fakvysitsw',.T.,.T.,drgINI:dir_USERfitm)
  endif
  fakvysitsw->(dbzap())

  kusov->(AdsSetOrder(1), dbsetScope(SCOPE_BOTH, cky_kus), dbGotop())
  do while .not. kusov->(eof())
    cky := if( empty(kusov->cnizPol), kusov->csklPol, kusov->cnizPol)

    if cenzbozsw->(dbseek( cky_cen +upper(cky),,'CENIK03'))
      ::copyfldto_w('cenzbozsw', 'fakvysitsw', .t.)
      ::copyfldto_w(  hd_file  , 'fakvysitsw')
      *
      fakvysitsw->nfaktMnoz := kusov    ->nspMno
      fakvysitsw->ncejprzbz := cenzbozsw->ncenapzbo
      *
      mapolSest += cenzbozsw->ccisSklad     +',' + ;
                   cenzbozsw->csklPol       +',' + ;
                   str(cenzbozsw->ncenaSZbo)+',' + ;
                   str(cenzbozsw->ncenaPZbo)+',' + ;
                   str(cenzbozsw->nmnozSZbo)+',' + ;
                   str(cenzbozsw->ncenaCZbo)+',' + ;
                   str(kusov    ->nspMno)        +';'

    endif
    kusov->(dbskip())
  enddo

  mapolSest := subStr(mapolSest, 1, len(mapolSest) -1)

  kusov  ->(dbclearScope())
return mapolSest

*
******** DAN_obd_OK() **********************************************************
STATIC FUNCTION DAN_obd_OK(pA)
  LOCAL  cOBDOBIDAN := UCETSYS ->cOBDOBIDAN
  LOCAL  lOk := .T.

  if ucetsys ->lzavrend
    lOk := .F.
  ELSE
    lOk := ( AScan(pA, {|X| X[1] = cOBDOBIDAN}) = 0 )
  ENDIF
RETURN lOk



*
** CLASS for all_memo_edit ****************************************************
CLASS memoEdit FROM drgUsrClass
EXPORTED:
  method  init, getForm, drgDialogInit, drgDialogStart

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
  local dc := ::drgDialog:dialogCtrl

  do case
  case(nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_SAVE)
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  case(nEvent = drgEVENT_APPEND   )
  case(nEvent = drgEVENT_FORMDRAWN)
    return .T.

  case(nEvent = xbeP_Keyboard)
    do case
    case(mp1 = xbeK_ESC)
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    otherwise
      return .f.
    endcase

  otherwise
    return .f.
  endcase
return .t.

hidden:
  var  drgGet, m_item, m_odrg
ENDCLASS


method memoEdit:init(parent)
  Local nEvent,mp1,mp2,oXbp, odrg

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  endif

  ::m_item  := parent:cargo
  ::m_odrg  := parent:parent:dataManager:has(::m_item)

  ::drgUsrClass:init(parent)
return self


method memoEdit:getForm()
  local  oDrg, drgFC
  *
  local  subTitle := '... popis položky dokladu ...'

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 80,7 DTYPE '10' TITLE subTitle GUILOOK 'All:N,Border:Y,ICONBAR:N'

  DRGMLE '' INTO drgFC FPOS 0,1.2 SIZE 80,5.5 RESIZE 'yx' SCROLL 'ny'
    odrg:name := ::m_item

  DRGSTATIC INTO drgFC FPOS 0.2,0 SIZE 79.8,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX
    DRGTEXT INTO drgFC CAPTION '['      CPOS  2,.1 CLEN  2 FONT 5
    DRGTEXT INTO drgFC CAPTION subTitle CPOS  3,.1 CLEN 55 CTYPE 1 FONT 5
    DRGTEXT INTO drgFC CAPTION ']'      CPOS 60,.1 CLEN  2 FONT 5

    DRGPUSHBUTTON INTO drgFC POS 76.5,.05 SIZE 3,1 ATYPE 1 ICON1 102 ICON2 202 EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
  DRGEND  INTO drgFC
return drgFC


method memoEdit:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}   // -25}
  endif
return


method memoEdit:drgDialogStart(drgDialog)
  local odrg := drgDialog:dataManager:has(::m_item)

  if( isobject(::m_odrg), odrg:set(::m_odrg:value), nil)
return .t.