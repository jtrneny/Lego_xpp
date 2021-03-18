#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "class.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


*
** CLASS SYS_fltusers_SCR ******************************************************
CLASS SYS_fltusers_SCR FROM drgUsrClass, sys_filtrs
EXPORTED:

  METHOD  init, getForm, drgDialogStart, preValidate, postValidate
  METHOD  selFiltrs, runFiltrs
   *
  METHOD  onSave, delRec, addRec
   *
  METHOD  destroy
  *
  **
  VAR     cOLDfrmName

  * NEW
  method  ebro_saveEditRow


  *
  INLINE METHOD isOk()
    LOCAL isOk := .not. Empty(::aitw)
    AEval(::aitw, {|s| if( Empty(s), isOk := .F., NIL )})
    if( isOk, ::pushOk:enable(), ::pushOk:disable())
  RETURN isOk
  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)

    DO CASE
    CASE nEvent = drgEVENT_APPEND
      ::lnewrec := .T.
      ::selFiltrs()
      RETURN .T.

    CASE nEvent = drgEVENT_EDIT

    CASE nEvent = drgEVENT_DELETE
      if ::dctrl:oaBrowse = ::dctrl:oBrowse[1]
         if drgIsYESNO(drgNLS:msg( 'Zrušit uživatelský filtr <&> ?' , fltusers->cfltname))
          fltusers ->(dbRlock())
          fltusers ->(dbDelete())
          ::dctrl:oBrowse[1]:refresh()
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
  var     msg, dm, bro, dctrl, pushOk, noedit_get
  var     prevForm, prevBro, prevFile, lnewrec
ENDCLASS


method SYS_fltusers_SCR:init(parent)
  local  filter

  ::drgUsrClass:init(parent)

  ::prevForm   := parent:parent
  ::prevFile   := ''
  ::lnewrec    := .F.
  ::noedit_get := {}

  drgDBMS:open('FILTRS')
  drgDBMS:open('FLTUSERS')

  *
  drgDBMS:open('FILTRITw',.T.,.T.,drgINI:dir_USERfitm);ZAP

  filter := format("cUser = '%%' .and. cCallForm = '%%'", {usrName,::prevForm:formName})
  fltuserS->( ads_setAof(filter))
return self


METHOD SYS_fltusers_SCR:getForm()
  local drgFC := drgFormContainer():new(), _drgEBrowse, odrg

  DRGFORM INTO drgFC SIZE 106,20 DTYPE '10' TITLE 'Uživatelské filtry' ;
                     GUILOOK 'All:Y,Border:Y,Action:N';
                     PRE 'preValidate' POST 'postValidate'

* Browser _fltusers
  DRGEBROWSE INTO drgFC FPOS 0,0 SIZE 105.5,9.9 FILE 'FLTUSERS'  ;
             ITEMMARKED 'itemMarked' SCROLL 'ny' CURSORMODE 3 PP 7
   _drgEBrowse := oDrg
   _drgEBrowse:popupmenu := 'y'

   DRGGET                  fltusers->cfltName INTO drgFC FLEN 89
   oDrg:push         := 'selFiltrs'
   oDrg:isedit_inrev := .f.

   DRGTEXT INTO drgFC NAME fltusers->cidFilters  CLEN  13 CAPTION  'ID_filtru'

   _drgEBrowse:createColumn(drgFC)
  DRGEND INTO drgFC

* Browser _filtritw
  DRGEBROWSE INTO drgFC FPOS 0,10.2 SIZE 105.5,8 FILE 'FILTRITw'             ;
             SCROLL 'ny' CURSORMODE 3 PP 7 GUILOOK 'ins:n,del:n,sizecols:n,headmove:n'
    _drgEBrowse := oDrg

    DRGTEXT INTO drgFC NAME filtritW->clgate_1  CLEN  2 CAPTION  '('
    DRGTEXT INTO drgFC NAME filtritW->clgate_2  CLEN  2 CAPTION  '('
    DRGTEXT INTO drgFC NAME filtritW->clgate_3  CLEN  2 CAPTION  '('
    DRGTEXT INTO drgFC NAME filtritW->clgate_4  CLEN  2 CAPTION  '('

    DRGTEXT INTO drgFC NAME filtritW->cfile_1   CLEN  9   CAPTION  'table'

    DRGTEXT INTO drgFC NAME filtritW->cvyraz_1u CLEN 28 CAPTION  'výraz-L'
    DRGTEXT INTO drgFC NAME filtritW->crelace   CLEN  6 CAPTION  'oper'
    DRGGET  filtritW->cvyraz_2u INTO drgFC      CLEN 27 FCAPTION 'výraz-P'

    DRGTEXT INTO drgFC NAME filtritW->cfile_2   CLEN  9   CAPTION  'table'

    DRGTEXT INTO drgFC NAME filtritW->crgate_1  CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->crgate_2  CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->crgate_3  CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->crgate_4  CLEN  2 CAPTION  ')'
    DRGTEXT INTO drgFC NAME filtritW->coperand  CLEN  7

    _drgEBrowse:createColumn(drgFC)
  DRGEND INTO drgFC

  DRGPushButton INTO drgFC POS 78,18.7 SIZE 10,1.2 CAPTION 'OK'     EVENT 'runFiltrs' ICON1 101 ICON2 201 ATYPE 3
  DRGPushButton INTO drgFC POS 89,18.7 SIZE 10,1.2 CAPTION 'Cancel' EVENT drgEVENT_QUIT ICON1 102 ICON2 202 ATYPE 3
RETURN drgFC


METHOD SYS_fltusers_SCR:drgDialogStart(drgDialog)
  LOCAL broPos, members, x, ardef

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

  * needitaèní gety
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
      if( Upper(members[x]:caption) = 'OK', ::pushOk := members[x], NIL)
    endif
  next

  drgDialog:oForm:nextFocus := broPos
RETURN self


METHOD SYS_fltusers_SCR:preValidate(drgVar)
  local  lOk := .T., odesc, picture

*-  drgVar:oDrg:oXbp:enable()

  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    lOk   := (at('->',filtritw ->cvyraz_2) = 0)
    odesc := drgDBMS:getFieldDesc(strtran(filtritw->cvyraz_1,' ',''))


    if lOK .and. IsObject(odesc)
      do case
      case odesc:type = 'D'
        drgVar:odrg:oxbp:picture := '@D'
      otherwise
        picture := if(odesc:name = 'COBDOBI','99/99',odesc:picture)
        drgVar:oDrg:oXbp:picture := picture
      endcase

    else
*-      drgVar:oDrg:oXbp:disable()
      lOk := .f.
    endif
  endif

RETURN lOk


method SYS_fltusers_SCR:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := Lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .T., changed := drgVAR:Changed()

  do case
  case (file = 'fltusers')
    ok := if( item = 'cfltname', ::selFiltrs(), .t.)

  case (file = 'filtritw')

  endcase


  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    if drgVar:changed()
      filtritw ->cvyraz_2         := value
*-      ::aitw[filtritw->(RecNo())] := value
    endif

*-    ::isOk()
  endif
return ok


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
  local  oini := flt_setcond():new(.f.,.f.), recCount, optLevel, nopt
  *
  local  i, aBitMaps  := { 0, 0, {nil,nil,nil,nil} }, nPHASe := MIS_WORM_PHASE1, oThread
  local     xbp_therm := ::msg:msgStatus

  if .not. empty(oini:ft_cond)
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

    (::prevFile)->(ads_setaof(oini:ft_cond),dbgotop())

    if (.not. empty(filtrs->mdata) .and. .not. empty(oini:ex_cond))
      oini:relfiltrs(::prevFile,oini:ex_cond)
    endif

    recCount := (::prevFile)->(Ads_GetRecordCount())
    optLevel := (::prevFile)->(Ads_GetAOFOptLevel())

    if isObject(::prevForm:act_Filter)
      ::prevForm:act_Filter:oText:type := XBPSTATIC_TYPE_ICON
      ::prevForm:act_Filter:oText:configure()

      nopt := if(optLevel = 0, 0, 340 +optLevel)
      ::prevForm:act_Filter:oText:setCaption(nopt)
    endif

    * vrátíme to
    oThread:setInterval( NIL )
    oThread:synchronize( 0 )
    oThread := nil

    ::prevBro:refresh(.T.)
    ::prevForm:dialog:setTitle( ::prevForm:Title +' . ' +allTrim(fltusers ->cfltname) +' = ' +allTrim(Str(recCount)))
  endif

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
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
**
*


method  sys_fltusers_scr:ebro_saveEditRow(drgEBrowse)

  if lower(drgEBrowse:cfile) = 'fltusers'
    fltusers ->cuser      := usrName
    fltusers ->ccallform  := ::prevForm:formName
    fltusers ->cidfilters := filtrs ->cidfilters
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

RETURN self

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
      (::file) ->(OrdSetFocus(tagNo))
    case(tagNo =  0 .and. .not. empty(indexKey))
      DbSelectArea(::file)
      INDEX ON &(indexKey) TO (drgINI:dir_USERfitm +'TISKY') ADDITIVE
      (::file) ->(OrdSetFocus('TISKY'))
    endcase
  endif
RETURN self


method flt_setcond:Relations(buffer)
  LOCAL pa, n

  while(asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0)
    if Left(buffer,1) <> '['
      pa := ListAsArray(lower(substr(buffer,1,n -1)),':')
      *
      drgDBMS:open(pa[5])

      (pa[5]) ->(OrdSetFocus(Val(pa[1])))
      (pa[4]) ->(DbSetRelation(pa[5], COMPILE(pa[3]), pa[3]), dbSkip(0))
    endif
    buffer := substr(buffer, n +1)
  enddo
RETURN self


method flt_setcond:relfiltrs(mfile, ex_cond)
  local  pa := {}, filter := ''

  (mfile)->(dbsetFilter( COMPILE(ex_cond) ), dbgotop() )

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

  if (::file) ->(OrdSetFocus()) = 'TISKY'
    (::file) ->(OrdListClear(), OrdListAdd(::indexName), OrdSetFocus(1))

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

      do case
      case( crel = '=' .or. crel = '!=' )
        if at('?', cval) <> 0 .or. at( '*', cval) <> 0
          crel := if(crel = '=', '', '!' )
          cval := upper(cval)
          cnam := 'upper(' +cnam + ')'
          if lower(alltrim(filtrs->cmainfile)) $ lower(alltrim(filtritw ->cVYRAZ_1))
            cond += crel +'contains(' +cnam + ',"' +cval + '")' +' '
          else
            cond += crel +'like("' +cval +'", ' +cNam +' )' +' '
          endif

        else
          cvAL := upper(cvAL)
          cond += 'upper(' +cnam +')' +' ' +crel +'"' +cval +'" '
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