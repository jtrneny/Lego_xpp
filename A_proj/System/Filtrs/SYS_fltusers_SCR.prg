#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "class.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

#include "GRA.CH"


/*
PostAppEvent(drgEVENT_ACTION, misEVENT_KILLFILTER,'0',::drgDialog:dialog)


PostAppEvent(drgEVENT_ACTION, misEVENT_KILLFILTER,'2',oXbp)
::misDialogKillFilter()


*/


*
** CLASS SYS_fltusers_SCR ******************************************************
CLASS SYS_fltusers_SCR FROM drgUsrClass, sys_filtrs
EXPORTED:

  METHOD  init, getForm, drgDialogStart
  METHOD  editFiltrs, selFiltrs, runFiltrs
  METHOD  onSave, delRec, addRec
  *
  METHOD  destroy
  method  preValidate, postValidate, ebro_afterAppend, ebro_saveEditRow

  VAR     cOLDfrmName


  * na FLTUSERS
  inline access assign method isact_Filter() var isact_Filter
    return if( fltusers->cidfilters = ::ID_act_Filter, .t., .f. )  // ::BMP_act_Filter, 0)

  inline access assign method ised_cvyraz_2() var ised_cvyraz_2
    return if(filtritw->lnoedt_2, MIS_NO_RUN, 0 )

  inline method isOk()
    local isOk := .t., pa  := ::aitw, x

    for x := 1 to len(pa) step 1
      if empty(pa[x,1])
        if( pa[x,2] .and. pa[x,3] <> 0, nil, isOk := .F. )
      endif
    next
    if( isOk, ::pushOk:enable(), ::pushOk:disable())
  RETURN isOk


*  inline method isOk()
*    LOCAL isOk := .not. Empty(::aitw)
*    AEval(::aitw, {|s| if( Empty(s), isOk := .F., NIL )})
*    if( isOk, ::pushOk:enable(), ::pushOk:disable())
*  RETURN isOk

  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    local  brow := ::dctrl:oBrowse[1], defOpr
    local  sid  := isNull(fltusers->sid, 0)
    *
    ** pro zrušení filtru
    local  nsel
    local  ctitle := 'Zrušení uživatelského filtru ...'
    local  cinfo  := 'Promiòte prosím,'                                    +CRLF + ;
                     'požadujete ZRUŠIT uživatelský filtr ?'               +CRLF + CRLF + ;
                     padC( '... ' +allTrim(fltusers->cfltname) +' ...', 30)


    * hodnì to blbne
    if .not. ::is_showItems
      ::is_showItems := .t.
      ::dctrl:oBrowse[2]:oxbp:show()
    endif

    ::isOk()
    *
    * bacha DIST nejde pravovat
    ::pushOprava_enableOrDisable()

    DO CASE
    CASE nEvent = drgEVENT_APPEND
      ::lnewrec := .T.
      ::selFiltrs()
      RETURN .T.

    CASE nEvent = drgEVENT_DELETE
      if ::dctrl:oaBrowse = ::dctrl:oBrowse[1]

        if ::isact_Filter
          cinfo += CRLF +CRLF +'Pozor, filtr je aktivní bude zrušeno nastavení !'
        endif

        nsel := confirmBox( , cInfo         , ;
                              ctitle        , ;
                              XBPMB_YESNO   , ;
                              XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

        if nsel = XBPMB_RET_YES
          if( ::isact_Filter, ::prevForm:del_act_filter(), nil )

          fltusers ->(dbRlock())
          fltusers ->(dbDelete())

          if( brow:oxbp:rowPos = 1, brow:oxbp:goTop(), nil )
          brow:oxbp:refreshAll()

          ::itemMarked()
          postAppEvent(xbeBRW_ItemMarked,,,::dctrl:oBrowse[1]:oxbp)
        endif
      endif
      RETURN .T.

    CASE nEvent = xbeP_Keyboard
      do case
      case oxbp:className() = 'XbpGet'
        if ascan(::noedit_get, {|x| x = oxbp}) <> 0
          if (mp1 >= 32 .and. mp1 <= 255)
            return .t.
          else
            return .f.
          endif
        endif
      endcase
      return .f.

    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

HIDDEN:
  var     msg, dm, bro, dctrl, pushOk, pushOprava, noedit_get
  var     prevForm, prevBro, prevFile, lnewrec
  var     ID_act_Filter, BMP_act_Filter
  *
  var     is_showItems
  var     defOpr

  inline method pushOprava_enableOrDisable()
    local  sid  := isNull(fltusers->sid, 0)
    local  isOk := if( At('DIST', ::defOpr) > 0, .t., (filtrs->ctypfiltrs = 'USER') )

    if sid = 0
      ::pushOprava:disable()
    else
      if( isOk, ::pushOprava:enable(), ::pushOprava:disable() )
    endif
  return self

ENDCLASS


method SYS_fltusers_SCR:init(parent)

  ::drgUsrClass:init(parent)

  ::prevForm       := parent:parent
  ::prevFile       := ''
  ::lnewrec        := .F.
  ::noedit_get     := {}
  ::ID_act_Filter  := '0'
  ::BMP_act_Filter := 0
  *
  ::is_showItems   := .f.
  ::defOpr   := defaultDisUsr('Filtrs','CTYPFILTRS')

  drgDBMS:open('FILTRS')
  drgDBMS:open('FLTUSERS')

  *
  drgDBMS:open('FILTRITw',.T.,.T.,drgINI:dir_USERfitm);ZAP
return self


METHOD SYS_fltusers_SCR:getForm()
  local drgFC := drgFormContainer():new(), _drgEBrowse  , odrg

  DRGFORM INTO drgFC SIZE 106,20 DTYPE '10' TITLE 'Uživatelské filtry' ;
                     GUILOOK 'All:Y,Border:Y,Action:N'                 ;
                     PRE 'preValidate' POST 'postValidate'

* Browser _fltusers                         9.9
  DRGEBROWSE INTO drgFC FPOS 0,0 SIZE 105.5,9 FILE 'FLTUSERS'      ;
             ITEMMARKED 'itemMarked' SCROLL 'ny' CURSORMODE 3 PP 7 ;
             GUILOOK 'ins:y,del:y,enter:y'                         ;
             RESIZE 'yy'

   _drgEBrowse             := oDrg
**   _drgEBrowse:stableBlock := 'stableBlock'
   _drgEBrowse:popupmenu   := 'y'

   DRGCHECKBOX M->isact_Filter INTO drgFC FLEN 3 FCAPTION '' VALUES 'T:.,F:.'
   odrg:rOnly := .t.

*   DRGTEXT INTO drgFC NAME M->isact_Filter               CLEN  2  CAPTION ''
*   oDrg:isbit_map := .t.

   DRGCHECKBOX fltusers->lbegUsers INTO drgFC FLEN 3 FCAPTION 'usr' VALUES 'T,F'
   DRGCHECKBOX fltusers->lfiltrYes INTO drgFC FLEN 3 FCAPTION 'res' VALUES 'T:.,F:.'

   DRGGET                  fltusers->cfltName INTO drgFC FLEN 80
   oDrg:push         := 'selFiltrs'
   oDrg:isedit_inrev := .f.

   DRGTEXT INTO drgFC NAME fltusers->cidFilters  CLEN  13 CAPTION  'ID_filtru'

   _drgEBrowse:createColumn(drgFC)
  DRGEND INTO drgFC

* Browser _filtritw
  DRGEBROWSE INTO drgFC FPOS 0,10.2 SIZE 105.5,8 FILE 'FILTRITw' ;
             SCROLL 'ny' CURSORMODE 3 PP 7                       ;
             GUILOOK 'ins:n,del:n,sizecols:n,headmove:n'         ;
             RESIZE 'yx'

    _drgEBrowse := oDrg

    DRGTEXT INTO drgFC NAME filtritW->clgate_1  CLEN  2 CAPTION  '('
    DRGTEXT INTO drgFC NAME filtritW->clgate_2  CLEN  2 CAPTION  '('
    DRGTEXT INTO drgFC NAME filtritW->clgate_3  CLEN  2 CAPTION  '('
    DRGTEXT INTO drgFC NAME filtritW->clgate_4  CLEN  2 CAPTION  '('

    DRGTEXT INTO drgFC NAME filtritW->cfile_1   CLEN  9 CAPTION  'table'

    DRGTEXT INTO drgFC NAME filtritW->cvyraz_1u CLEN 28 CAPTION  'výraz-L'
    DRGTEXT INTO drgFC NAME filtritW->crelace   CLEN  6 CAPTION  'oper'
    DRGGET  filtritW->cvyraz_2u INTO drgFC      CLEN 27 FCAPTION 'výraz-P'

    DRGTEXT INTO drgFC NAME M->ised_cvyraz_2    CLEN  2 CAPTION ''
    oDrg:isbit_map := .t.

    DRGTEXT INTO drgFC NAME filtritW->cfile_2   CLEN  9 CAPTION  'table'

    DRGTEXT INTO drgFC NAME filtritW->crgate_1  CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->crgate_2  CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->crgate_3  CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->crgate_4  CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->coperand  CLEN  7 CAPTION  '       '

    _drgEBrowse:createColumn(drgFC)
  DRGEND INTO drgFC

  DRGPushButton INTO drgFC POS  7,18.7 SIZE 20,1.2 CAPTION ' Oprava filtru'  EVENT 'editFiltrs'   ICON1 114 ICON2 214 ATYPE 3

  DRGPushButton INTO drgFC POS 78,18.7 SIZE 10,1.2 CAPTION 'OK'              EVENT 'runFiltrs'    ICON1 101 ICON2 201 ATYPE 3
  DRGPushButton INTO drgFC POS 89,18.7 SIZE 10,1.2 CAPTION '  Cancel'        EVENT drgEVENT_QUIT  ICON1 102 ICON2 202 ATYPE 3
RETURN drgFC


METHOD SYS_fltusers_SCR:drgDialogStart(drgDialog)
  LOCAL  broPos, members, x, ardef, optLevel
  local  filter

  ::sys_filtrs:init(drgDialog)
  *
  *
  ::prevForm := drgDialog:parent
  ::prevFile := ''
  members    := ::prevForm:oForm:aMembers
  BEGIN SEQUENCE
    for x := 1 TO len(members)
      if 'browse' $ lower(members[x]:className())
        ::prevBro  := members[x]
        ::prevFile := ::prevBro:cFile
  BREAK
      endif
    next
  END SEQUENCE

  * needitaèní gety pro FILTRS
  ardef := drgDialog:odbrowse[1]:ardef
  for x := 1 to len(ardef) step 1
    if lower(ardef[x].defName) = 'fltusers->cfltname'
      aadd(::noedit_get, ardef[x].drgEdit:oxbp)
    endif
  next
  *
  ::msg      := drgDialog:oMessageBar
  ::dm       := drgDialog:dataManager
  ::dctrl    := drgDialog:dialogCtrl
  ::prevForm := drgDialog:parent
  *

  members  := drgDialog:oForm:aMembers
  for x := 1 TO len(members)
    if members[x]:ClassName() = 'drgEBrowse'
       broPos := IsNull(broPos,x)
    elseif members[x]:ClassName() = 'drgPushButton'
      if( Upper(members[x]:caption) = 'OK'             , ::pushOk     := members[x], NIL)
      if(       members[x]:caption  = ' Oprava filtru' , ::pushOprava := members[x], NIL)
    endif
  next

  drgDialog:oForm:nextFocus := broPos

  filter := format("upper(cUser) = '%%' .and. upper(cCallForm) = '%%'", ;
                   {upper(usrName), upper(::prevForm:formName) })
  fltuserS->( ads_setAof(filter),dbgoTop())

  if ::prevForm:get_act_filter('usr', ::prevFile)
    ::id_act_filter  := ::prevForm:id_act_Filter
    ::bmp_act_filter := if(::prevForm:opt_act_filter = 0, 0, 6002 +::prevForm:opt_act_filter)

    fltusers->(dbseek(::ID_act_Filter,,'FLTUSERS05'))
  endif

*  ::dctrl:oBrowse[1]:refresh(.t.)
*  ::dctrl:oBrowse[1]:oxbp:refreshAll()
RETURN self


method SYS_fltusers_SCR:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := Lower(drgVar:name)
  local  ok    := .T., picture := ''

  do case
  case(name = 'fltusers->lbegusers')
    ok := .f.

    if filtrs->(dbSeek( upper( fltUsers->cidFilters),, AdsCtag(1) ))
      if (.not. empty(fltuserS->mfilterS_u) .or. ::is_complet() = MIS_ICON_OK)
        ok := .t.
      endif
    endif

  case(name = 'filtritw->cvyraz_2u')
    ok    := (at('->',filtritw ->cvyraz_2) = 0)
    ok    := if( ok, .not. filtritw->lnoedt_2, ok)

    odesc := drgDBMS:getFieldDesc(strtran(filtritw->cvyraz_1,' ',''))

    if ok .and. isObject(odesc)
      drgVar:block := { |x| filtritw->( iif( x == NIL, field->cvyraz_2u, field->cvyraz_2u := x) ) }

      do case
      case(odesc:type = 'N')
        picture := REPLICATE('9', odesc:len)
        if odesc:dec <> 0
          picture := Stuff( picture,odesc:len -odesc:dec +3,1,'.')
        endif

      case(odesc:type = 'D')
        picture := '@D'

      case(odesc:type = 'C')
        if lower(odesc:name) = 'cobdobi' .or. lower(odesc:name) = 'cobdobidan'
          picture := '99/99'
        else
          picture := replicate('X',odesc:len)
        endif
      endcase

      drgVar:oDrg:oXbp:picture('9')
      drgVar:oDrg:oXbp:picture(picture)

      if odesc:type = 'N'
        drgVar:block := { |x| filtritw->( iif( x == NIL, val( field->cvyraz_2u), field->cvyraz_2u := str(x)) ) }
      endif
    else
      ok := .f.
    endif
  endcase
return ok


method SYS_fltusers_SCR:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := Lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .T., changed := drgVAR:Changed()
  *
  local  recNo := filtritW->( recNo())

  do case
  case (file = 'fltusers')
    ok := if( item = 'cfltname', ::selFiltrs(), .t.)

  case (file = 'filtritw')
  endcase


  if lower(drgVar:name) = 'filtritw->cvyraz_2u'

    odesc := drgDBMS:getFieldDesc(strtran(filtritw->cvyraz_1,' ',''))

*    if drgVar:changed()

      if isObject(odesc) .and. odesc:type = 'N'
        filtritw ->cvyraz_2 := str(value)
      else
        filtritw ->cvyraz_2 := value
      endif
*    endif

*    ::aitw[recNo]   := filtritw ->cvyraz_2
    ::aitw[recNo,1] := filtritw ->cvyraz_2
    ::aitw[recNo,3] += 1
    ::isOk()
  endif
return ok


method sys_fltusers_scr:ebro_afterAppend(drgEBrowse)
  local  ardef      := drgEBrowse:ardef, npos
  local  new_colPos := 1

  if (npos := ascan(ardef, {|x| lower(x[2]) = 'fltusers->cfltName' })) <> 0
    new_colPos := npos
  endif

  ::itemMarked()
  ::dctrl:oBrowse[2]:oxbp:goTop():refreshAll():deHilite()
return new_colPos


method sys_fltusers_scr:ebro_saveEditRow(drgEBrowse)
  local recNo  := fltusers->(recNo()), oldNo := 0
  local pa     := drgEBrowse:ardef, drgVar
  local rowPos, restAll := .f.
  *
  local lbegUsers

  if lower(drgEBrowse:cfile) = 'fltusers'
    rowPos    := drgEBrowse:oxbp:rowPos
    lbegusers := fltusers->lbegusers

    ** tady musí být vyjímka pro fltusers->lbegusers = .t.
    *  jen jeden fitr si mùže uživatel pøednastavit
    if (nin := ascan( pa, {|x| lower(x[2]) = 'fltusers->lbegusers'} )) <> 0
      drgVar := pa[nin,7]:ovar

      if ((drgVar:value <> drgVar:prevValue) .and. drgVar:value)
        * pøednastvil filtr, msuí bý jen jeden
        fltusers->(dbeval( {|| if( fltusers->lbegusers .and. recNo <> fltusers->(recNo()), ;
                               oldNo := fltusers->(recNo()), nil ) } ))

        * byl pøednastavený jiny záznam
        if oldNo <> 0
          fltusers->(dbgoTo(oldNo))

          if fltusers->(dbRlock())  ;  fltusers->lbegusers := .f.
                                       restAll := .t.
          else                      ;  lbegusers := .f.
          endif

          fltusers->(dbRUnlock())
        endif

        fltusers->(dbgoTo(recNo), dbRLock())

      endif
    endif

    fltusers ->cuser      := usrName
    fltusers ->ccallform  := ::prevForm:formName
    fltusers ->cidfilters := filtrs ->cidfilters
    fltusers ->cmainFile  := filtrs ->cmainFile
    fltusers->lbegusers   := lbegusers

    if( restAll, drgEBrowse:oxbp:refreshAll(), nil)

    ::itemMarked()
    ::dctrl:oBrowse[2]:oxbp:refreshAll()
  endif
return

*
** pøevzetí záznamu z FILTRS -> FLTUSERS ***************************************
METHOD SYS_fltusers_SCR:selFiltrs(drgDialog)
  local  oDialog, nExit, keyFLT, filtrs
  *
  local  value, odesc, nlen, cfile
  local  ok

  odesc := drgDBMS:getFieldDesc('filtrs', 'cmainFile')
  nlen  := odesc:len
  cfile := upper(padR(::prevFile,10))

  filtrs ->(ads_setaof("upper(cmainfile) = '" +cfile +"'"), DbGoTop())

  value := padr(::dm:get('fltusers->cfltname'),50) +padr(::dm:get('fltusers->cidfilters'),10)
  ok    := filtrs->(dbseek( upper(value),,'FILTRS08'))

  if IsObject(drgDialog) .or. .not. ok
    keyFLT := Padr( Upper( usrName), 10) +Padr(Upper( ::prevForm:formName),50)

    DRGDIALOG FORM 'SYS_filtrs_SEL,' + keyFLT PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if nexit != drgEVENT_QUIT .or. ok
    ::dm:set("fltusers->cfltname"  , filtrs->cfltname  )
    ::dm:set('fltusers->cidfilters', filtrs->cidFilters)
    ok := .t.
  endif

  filtrs ->(ads_clearaof())
  ::lnewrec := .F.
RETURN ok

*
** oprava uživatelského filtru *************************************************
method SYS_fltusers_SCR:editFiltrs()
  local  odialog, nexit
  local  oxbp_Bro := ::dctrl:oBrowse[2]:oxbp
  *
  local  nEvent, mp1, mp2

  filtrs->(dbSeek( upper( fltUsers->cidFilters),, AdsCtag(1) ))

  odialog := drgDialog():new( 'sys_filtrs_in', ::drgDialog)
  odialog:cargo := drgEVENT_EDIT

  odialog:create(,,.T.)

  nexit := odialog:exitState
  *
  odialog:destroy()

  ::itemMarked()
  ::dctrl:oBrowse[2]:oxbp:refreshAll()
return self


*
** vlastní spouštìní filtru ****************************************************
static function gate(isL)
  local name := if(isL, 'cLGATE_', 'cRGATE_'), x, npos, cC := ''

  for x := 1 to 4 step 1
    if (npos := filtritw ->(FieldPos(name +str(x,1)))) <> 0
      cC += filtritw ->(FieldGet(npos))
    endif
  next
return strtran(cC, ' ', '')


method SYS_fltusers_SCR:runFiltrs()
  local  oini := flt_setcond():new(.f.,.f.), recCount, optLevel, nopt, p_memos
  *         admin
  *          programový
  *           uživatelský
  local  ft_apu_cond, ft_cond
  *
  local  i, aBitMaps  := { 0, 0, {nil,nil,nil,nil} }, nPHASe := MIS_WORM_PHASE1, oThread
  local     xbp_therm := ::msg:msgStatus
  *
  local  acolors := GRA_FILTER_OPTLEVEL, npos, oicon, oxbp, size


  if .not. empty(oini:ft_cond)
    ft_apu_cond := ::prevForm:get_APU_filter(::prevFile, 'apq')
    ft_cond     := if( empty(ft_apu_cond), '', ft_apu_cond +' .and. ') +'(' +oini:ft_cond +')'
    *
    ** nachystáme si èervíka v samostatném vláknì
    for i := 1 to 4 step 1
      aBitMaps[3,i] := XbpBitmap():new():create()
      aBitMaps[3,i]:load( ,nPHASe )
      nPHASe++
    next

    oThread := Thread():new()
    oThread:setInterval( 8 )
    oThread:start( "sys_fltusers_animate", xbp_therm, aBitMaps)

**    ft_cond := left(ft_cond,19) +" not empty(osoby->cidOsKarty)"

    (::prevFile)->(ads_setaof(ft_cond),dbgotop())

    if (.not. empty(filtrs->mdata) .and. .not. empty(oini:ex_cond))
      oini:relfiltrs(::prevFile,oini:ex_cond)
    endif

    recCount := (::prevFile)->(Ads_GetRecordCount())
    optLevel := (::prevFile)->(Ads_GetAOFOptLevel())

    if isObject(::prevForm:act_Filter)

      if optLevel <> 0
        if ( npos := ascan( acolors, 340 +optLevel )) <> 0

          oxbp  := ::prevForm:act_Filter:oxbp

          oIcon := xbpIcon():new():create()
          oIcon:load( , 340 +optLevel )

          if oxbp:className() = 'MyCommandButton_MyButton'
             size := oxbp:currentSize()

             oIcon:load( , 340 +optLevel, 16, 16 )  // size[1]-5, size[2]-5 )
             oxbp:setProperty( 'Picture', oIcon:GetIPicture() )
          else
            ::prevForm:act_Filter:oxbp:image := oIcon
          endif

        endif
      endif

      * zapamatujeme si poslední aktivní filtr
      ::prevForm:ID_act_Filter := fltusers->cidfilters
      ::prevForm:save_act_filter('usr', ::prevFile, oini:ft_cond, oini:ex_cond )          // optLevel)

      if isMemberVar(::prevForm:parent, 'a_act_filtrs')
        ::prevForm:parent:save_act_filter('usr', ::prevFile, oini:ft_cond, oini:ex_cond)  // optLevel)
      endif

**      aadd(::prevForm:pa_usr_filtrs, {::prevFile, fltusers->cidfilters, optLevel, optLevel+340, optLevel +6002})

    endif

    * vrátíme to
    oThread:setInterval( NIL )
    oThread:synchronize( 0 )
    oThread := nil

    ::prevBro:refresh(.T.)
    ::prevForm:dialog:setTitle( ::prevForm:Title +' . ' +allTrim(fltusers ->cfltname) +' = ' +allTrim(Str(recCount)))
  endif

  * uložíme si nastavení
  p_memos := ::build_memos()

  if fltusers->(dbRlock())
    fltusers->mfilterS   := filtrs->mfilterS
    fltusers->mfilterS_u := p_memos[1]
    fltusers->(dbUnlock())
  endif

*---  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)

  if( isObject(::prevBro), PostAppevent(xbeBRW_ItemMarked,,,::prevBro:oxbp), nil )
RETURN .T.


procedure sys_fltusers_animate(xbp_therm,aBitMaps)
  local  aRect, oPS, nXD, nYD

  xbp_therm:setCaption('')

  aRect   := xbp_therm:currentSize()
  oPS     := xbp_therm:lockPS()

  nXD     := abitMaps[2]
  nYD     := 0

  aBitMaps[1] ++
  if aBitMaps[1] > len(aBitMaps[3])
    aBitMaps[1] := 1
  endif

  aBitMaps[ 3, aBitMaps[1] ]:draw( oPS, {nXD,nYD} )
  xbp_therm:unlockPS( oPS )

  if abitMaps[2] +10 > aRect[1]
    abitMaps[2] := 0
  else
    abitMaps[2] := abitMaps[2] +10
  endif
return

*
** END of CLASS ****************************************************************
METHOD SYS_fltusers_SCR:destroy()
  ::drgUsrClass:destroy()

  ::aitw     := ;
  ::msg      := ;
  ::dm       := ;
  ::bro      := ;
  ::dctrl    := ;
  ::pushOk   := ;
  ::prevForm := NIL
RETURN NIL


*
** ???? **
METHOD SYS_fltusers_SCR:onSave(parent)

//  xx := 1
//  ::drgUsrClass:init(parent)
//  drgDBMS:open('FLTUSERS')
//  drgDBMS:open('CONFIGIT')
//  drgDBMS:open('CONFIGUS')

RETURN .T.

METHOD SYS_fltusers_SCR:delRec()

  fltusers ->(dbDelete())

/*
  IF FLTUSERS->(DbRlock())
    FLTUSERS->(dbDelete())
    FLTUSERS->(DbUnLock())
  ENDIF
  FLTUSERS->(DbCommit())
*/

  ::drgDialog:dataManager:refresh(.T.)
  ::drgDialog:dialogCtrl:oBrowse[1]:refresh(.T.)
RETURN .F.


METHOD SYS_fltusers_SCR:addRec(parent)
  FLTUSERS->( dbAppend())
  FLTUSERS->cUser      := usrName
  FLTUSERS->cCallForm  := ::cOLDfrmName
  FLTUSERS->(DbCommit())
  ::drgDialog:dataManager:refresh(.T.)
  ::drgDialog:dialogCtrl:oBrowse[1]:refresh(.T.)
RETURN self



*
**
CLASS flt_setcond
EXPORTED:
  var    ft_cond, ex_cond, file, indexName READONLY
  method init, destroy, relfiltrs
HIDDEN:
  var    isVariable, inDesign, isdesc
  method setCond, SortOrder, Relations, ResetKey
ENDCLASS


method flt_setcond:init(inDesign,isdesc)
  LOCAL  buffer := StrTran(MemoTran(filtrs->mdata,chr(0)), ' ', ''), n, cname
  local  extBlock

  cresetKey  := xresetKey := ''

  ::inDesign := inDesign
  ::isdesc   := isdesc

  while( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
    if Left(buffer,1) = '['
      cname := lower(substr(buffer,2,n -3))

      do case
      case cname         = 'definevariable'
        ::isVariable := .T.
      case cname         = 'definefield'
        ::isVariable := .F.
      case left(cname,5) ='table'
        ::file := substr(cname,at(':',cname) +1)
        drgDBMS:open(::file)

        (::file)->(dbGoTop())
      case IsMethod(self, cNAMe, CLASS_HIDDEN)
        self:&cname(substr(buffer, n +1))
      endcase
    endif
    buffer := substr(buffer, n +1)
  end

  ::setCond()
RETURN self


*
**
method flt_setcond:SortOrder(buffer)
  LOCAL  pa, isCompound, x, indexKey := '', n, cc
  *
  LOCAL  odesc, type, len, dec, indexDef, tagNo
  LOCAL  oldEXACT

  if( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
    pa         := ListAsArray(substr(buffer,1,n -1))
    isCompound := (Len(pa) > 1)

    *
    for x := 1 to len(pa) step 1
      cc := pa[x]
      odesc := drgDBMS:getFieldDesc(::file, pa[x])
      type  := odesc:type
      len   := odesc:len
      dec   := odesc:dec

      indexKey += if(type = 'C', 'Upper(' +pa[x] +')', ;
                   if(type = 'D', 'DToS(' +pa[x] +')', ;
                    if(type = 'N' .and. isCompound, 'StrZero(' +pa[x] +',' +Str(len) +')', pa[x])))
      indexKey += if(isCompound .and. x < len(pa), '+', '')
    next

    *
    ::indexName := (::file) ->(Ads_GetIndexFilename())
    indexDef    := drgDBMS:dbd:getByKey(::file):indexDef

    oldEXACT    := Set(_SET_EXACT, .F.)
    tagNo       := AScan(indexDef, {|X| Upper(StrTran(X:cIndexKey, ' ', '')) = Upper(indexKey)})
    Set(_SET_EXACT, oldEXACT)

    do case
    case(tagNo <> 0)
      (::file) ->(AdsSetOrder(tagNo))
    case(tagNo =  0 .and. .not. empty(indexKey))
      DbSelectArea(::file)

**      INDEX ON &(indexKey) TO (drgINI:dir_USERfitm +'TISKY') ADDITIVE

      (::file) ->(Ads_CreateTmpIndex( drgINI:dir_USERfitm +'TISKY', 'TISKY',  indexKey ))
      (::file) ->(AdsSetOrder('TISKY'))
    endcase
  endif
RETURN self


method flt_setcond:Relations(buffer)
  LOCAL pa, n, crel_Alias

  while(asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0)

    if Left(buffer,1) <> '['
      pa         := ListAsArray(lower(substr(buffer,1,n -1)),':')
      crel_Alias := if( len(pa) = 6, pa[6], pa[5] )
      *
      drgDBMS:open(pa[5])

      if( Val(pa[1]) = 0, (crel_Alias)->( AdsSetOrder(     pa[1])) , ;
                          (crel_Alias)->( AdsSetOrder( Val(pa[1])))  )
      (pa[4])     ->( DbSetRelation( crel_Alias, COMPILE(pa[3]), pa[3]), dbSkip(0))

*      (pa[5]) ->(AdsSetOrder(Val(pa[1])))
*      (pa[4]) ->(DbSetRelation(pa[5], COMPILE(pa[3]), pa[3]), dbSkip(0))
    endif
    buffer := substr(buffer, n +1)
  enddo
RETURN self


method flt_setcond:relfiltrs(mfile, ex_cond)
  local  pa := {}, filter := '', bcond

  (mfile)->(dbsetFilter( COMPILE(ex_cond) ), dbgotop() )
  *
  ** musíme shodit relaci, pokud to jede znovu padne to na nastavení jiné relace
  ** FLT - user57 nejel ...
//   (mfile)->(DbClearRelation())

/*
  do while .not. (mfile)->(eof())
    if( DBGetVal(ex_cond), aadd(pa,(mfile)->(recno())), nil)

    (mfile)->(dbskip())
  enddo

  (mfile)->(ads_clearaof(), dbgotop())

  aeval(pa,{|x| filter += 'recno() = ' +str(x) +' .or. '})
  filter := left(filter, len(filter)-6)
  if( empty(filter), filter := 'recno() = 0', nil)

  (mfile)->(ads_setaof(filter),dbgotop())
*/
return self


method flt_setcond:ResetKey(buffer)
  cresetKey := buffer
  xresetKey := ''  //DBGETVAL(cresetKey)
return self


method flt_setcond:destroy()

  if (::file) ->(AdsSetOrder()) = 'TISKY'
    (::file) ->(OrdListClear(), OrdListAdd(::indexName), AdsSetOrder(1))

//    FErase(drgINI:dir_USERfitm +'TISKY.adi')
    FErase(drgINI:dir_USERfitm +'TISKY.cdx')
  endif
RETURN


method flt_setcond:setCond()
  local clga, cnam, ctyp, nlen, crel, cval, cvyr, crga, cond := ''
  local odesc, recCount, recs := filtritw ->(recNo())
  local ok
  *
  ::ft_cond := ''
  ::ex_cond := ''
  *
  filtritw ->(DbGoTop())


  do while .not. filtritw ->(Eof())
    clga  := gate(.T.)
    cnam  := alltrim(filtritw ->cVYRAZ_1)
    if isObject(odesc := drgDBMS:getFieldDesc(cnam))
      ctyp := odesc:type
      nlen := odesc:len
    endif
    crel  := alltrim(filtritw ->cRELACE )
    cval  := alltrim(filtritw ->cVYRAZ_2)
    cvyr  := alltrim(filtritw ->cOPERAND)
    crga  := gate(.F.)

    cond += clga

    do case
    case ctyp = 'N'
      if !isObject(odesc := drgDBMS:getFieldDesc(cval))
        cVal:= Str(Val(cval))
      endif
      cond += cnam +' ' +crel +' ' +cval +' '

    case ctyp = 'C'

      * tohle je pìkná blbost == je binární shoda, nemìla by se používat pro *,? kovenci
      if at('?', cval) <> 0 .or. at( '*', cval) <> 0
        crel := if( crel = '==', '=', crel)
      endif
      *
      * u * konvence se požije contains *123* - kdekoliv v øetìzci
      *                                 *123  - na konci   øetìzce
      *                                  123* - na zaèátku øetìzce
      do case
      case( crel = '=' .or. crel = '!=' .or. crel = '<>')
        if at('?', cval) <> 0 .or. at( '*', cval) <> 0
          crel := if(crel = '=', '', '!' )
          cval := upper(cval)
          cnam := 'upper(' +cnam + ')'

          if lower(alltrim(filtrs->cmainfile)) $ ;
             lower(alltrim(filtritw ->cVYRAZ_1)) .and. at( '*', cval) <> 0
            cond += crel +'contains(' +cnam + ',"' +cval + '")' +' '
          else
// like není na ADS            cond += crel +'like("' +cval +'", ' +cNam +' )' +' '
            cond += crel +flt_setcond_like(cnam,cval) +' '
          endif

        else
          cvAL := upper(cvAL)
          *
          ** požadavek na prázdný údaj ve filtru, nusíme jít na fci, empty, pøekrývá i NULL value
          if empty(cval)
            cond += if( crel = '!=' .or. crel = '<>', ' .not. ', '' ) +' empty(' +cnam +')'
          else
*           cond += 'upper(' +cnam +')' +' ' +crel +'"' +cval +'" '

            cond += 'upper(' +cnam +')' +' ' +crel

            if at('->', cval) <> 0
              cond += 'upper(' +cval +')'  // údaj ze stejného souboru
            else
              cond += '"' +cval +'" '      // hodnota
            endif
          endif

        endif
      case at( '->', cval ) <> 0
        cond += cnam + ' ' +crel +' ' +cval +' '
      otherWise
        cval := padr(cval,nlen)
        cond += cNAM + ' ' +cREL +' ' +'"' +cVAL +'" '
      endcase

    case ctyp = 'D'
      cnam := 'dtos(' +cnam +')'
      if at('->', cval) <> 0
        cond += cnam +' ' +crel +' ' +'dtos(' +cval +')' +' '
      else
        cond += cnam +' ' +crel +' ' +'dtos(ctod(' +'"' +cval +'"))' +' '
      endif

    case ctyp = 'L'
      crel := if( crel = '==', '', '!' )
      cond += crel +if( Equal(cvAL, 'Ne'), '!' +cnam, cnam) +' '
    endcase

    cond += crga +' ' +cvyr +' '

    ok := if( at('->',filtritw ->cVYRAZ_2) <> 0                                      , ;
              lower(alltrim(filtrs->cmainfile)) $ lower(alltrim(filtritw ->cVYRAZ_2)), ;
              .t.                                                                      )

    if lower(alltrim(filtrs->cmainfile)) $ lower(alltrim(filtritw ->cVYRAZ_1)) .and. ok
      ::ft_cond += cond
    else
      ::ft_cond += '(1 = 1)' +' ' +cvyr +' '
      ::ex_cond += cond
    endif
    cond := ''
    filtritw ->(DbSkip())
  enddo

  * upravíme vzor filtru
  do case
  case lower(right(::ft_cond,6)) = '.and. '                // .and.
    ::ft_cond := substr(::ft_cond, 1, len(::ft_cond) -7)

  case lower(right(::ft_cond,5)) = '.or. '                 // .or.
     ::ft_cond := substr(::ft_cond, 1, len(::ft_cond) -6)

 * ex_cond nelze realizovat pøes AOF
  case lower(right(::ex_cond,6)) = '.and. '                // .and.
    ::ex_cond := substr(::ex_cond, 1, len(::ex_cond) -7)

  case lower(right(::ex_cond,5)) = '.or. '                 // .or.
     ::ex_cond := substr(::ex_cond, 1, len(::ex_cond) -6)

  endcase

  filtritw ->(dbGoTo(recs))
return .t.


*
**
static function flt_setcond_like(cnam, cval)
  local  pa := listAsArray(cval,'?'), px := {}
  local  x, nstart := 1, ncount
  *
  local  cond := '( '

  for x := 1 to len(pa) step 1
    if empty(pa[x])
      nstart++
    else
      ncount := len(pa[x])
      cond   += 'substr(' +cnam+              ',' + ;
                        allTrim(str(nstart)) +',' + ;
                        allTrim(str(ncount)) +') = ' +'"' +pa[x] +'"' + ;
                        ' .and. '

      aadd( px, { nstart, len(pa[x]) })
      nstart += len(pa[x])
    endif
  next

  cond := subStr( cond, 1, len(cond) -7) +')'
return cond