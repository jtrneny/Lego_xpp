#include "Appevent.ch"
#include "Common.ch"
#include "Class.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"

#pragma Library( "XppUI2.LIB" )


function newIDfiltrs(typ)
  local newID, filtr

  drgDBMS:open('FILTRS',,,,,'FILTRSa')
  filtrsA->(dbclearFilter(), dbgoTop())

  filtr := Format("cIDfilters = '%%'", {typ})
  filtrsA->( AdsSetOrder(1), dbSetFilter(COMPILE(filtr)), dbgoBottom())

  filtrsW->ctypFiltrs := typ
  filtrsW->ncisFiltrs := val(subStr(filtrsA->cIDfilters,5,6))+1
  filtrsW->cidFilters := filtrsW->ctypFiltrs +strZero(filtrsW->ncisFiltrs,6)
return filtrsW->cidFilters


*
**
CLASS sys_filtrs
EXPORTED:
  var     msg, dm, dc, df, brow
  var     aitw, relDef, m_file, popUp, a_files
  *
  var     R_tree, R_rootItem
  method  R_treeViewInit, R_fillRoot
  *
  method  itemMarked
  method  build_memos, build_memo_rel

  inline method init(parent)
    local drgDialog := parent:drgDialog

      ::aitw          := {}
      ::relDef        := {}
      ::popUp         := ''
      ::a_files       := {}
      *
      ::msg      := drgDialog:oMessageBar             // messageBar
      ::dm       := drgDialog:dataManager             // dataMabanager
      ::dc       := drgDialog:dialogCtrl              // dataCtrl
      ::df       := drgDialog:oForm                   // form
      ::udcp     := drgDialog:udcp                    // udcp
      *
      ::m_parent := parent
  return self

  * je zadán filtr vèetnì hodnot ?
  inline access assign method is_complet() var is_complet
    local buffer := strTran(memoTran(filtrs ->mfilters,chr(0)), ' ', '')
    local cname, pos, fld, val, isComplet := .t.
    *
    local avyraz_2 := {}

    while(asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0)

      cname := substr(buffer,1, n-1)
      pos   := at(':',cname)
      fld   := substr(cname, 1, pos-1)
      val   := substr(cname, pos+1)

      if(lower(fld) = 'cvyraz_2', aadd(avyraz_2, val), nil)

      buffer := substr(buffer, n +1)
    end

    aeval( avyraz_2, { |x| if( .not. empty(x), nil, isComplet := .f.) } )
  return if(isComplet, MIS_ICON_OK, 0)

  * je filtr optimální pro spuštìní ?
  *   0, 341, 342, 343
  **     FULL PART NONE
  inline access assign method opt_level() var opt_level
    return filtrs->noptlevel

HIDDEN:
  var     udcp, m_parent, nrec_fltUsers
  method  fillTree
ENDCLASS


method sys_filtrs:itemMarked(a,b,c)
  local  buffer, cname, pos, fld, val, typ, ppos, file, ncount := 1
  *
  local  nBRo, ok := .t., mfilterS, sid_mfile := -1
  local  lcanBeEmpty

  do case
  case lower(::udcp:className()) $ 'sys_fltusers_scr,sys_tiskform_crd'
    if(ok := filtrs->( DbSeek( upper( fltUsers->cidFilters),, AdsCtag(1) )))

      sid_mfile := isNull( filtrs->sid, 0)

      if (filtrs->mfilterS = fltuserS->mfilterS) .and. ;
              .not. empty(fltuserS->mfilterS_u)  .and. fltusers->lfiltrYes

        mfilterS  := fltuserS->mfilterS_u

      endif
    endif

  case lower(::udcp:className()) $ 'sys_forms_in'
    ok := filtrs->( DbSeek( upper( FILTRSs->cidFilters),, AdsCtag(1)) )
    mfilterS  := FILTRSs->mFilterS
    sid_mfile := isNull( FILTRSs->sid, 0)

  endCase

  ::aitw       := {}
  if( .not. ok, filtritW->(dbgotop(), dbZap()), nil )

  if ok
    filtritW->(dbZap())

    filtritW->( DbAppend())
    filtritW->ncount    := ncount
    filtritW->sid_mfile := sid_mfile
    ncount++

    if( isNull(mfilterS), mfilterS := filtrS ->mFilterS, nil)

    buffer := MemoTran(mfilterS,chr(0))
///    buffer := StrTran(MemoTran(mfilterS,chr(0)), ' ', '')

    while( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
      if left(buffer,1) = ';'
        if .not. filtritW->lnoedt_2 .and. at('->',filtritw ->cvyraz_2) <> 0
          filtritW->lnoedt_2 := .t.
        endif

        filtritW ->(DbAppend())
        filtritW->ncount    := ncount
        filtritW->sid_mfile := sid_mfile
        ncount++

      else
        cname := substr(buffer,1, n-1)
        pos   := at(':',cname)
        fld   := substr(cname, 1, pos-1)
        val   := substr(cname, pos+1)
        typ   := type('filtritw->' +fld)

        if (npos := FILTRITw ->(FieldPos(fld))) <> 0
          filtritW ->( FieldPut(npos,if( typ = 'L', if(val = '1', .t., .f.), val)))

          if (ppos := at('->', val)) <> 0
             if lower(fld) = 'cvyraz_1' .or. lower(fld) = 'cvyraz_2'
               DBPutVal('filtritW->cfile_' +right(fld,1), lower(left(val,ppos-1)))

               if lower(fld) = 'cvyraz_1'
                 if isobject(odesc := drgDBMS:getFieldDesc(allTrim(val)))

                   filtritW->ctype_1 := odesc:type
                   filtritW->nlen_1  := odesc:len
                   filtritW->ndec_1  := odesc:dec
                 endif
               endif
             endif
          endif

          if (npos := filtritW ->(FieldPos(fld +'u'))) <> 0
            if isObject(odesc := drgDBMS:getFieldDesc(allTrim(val)))
              cC   := if( .not. IsNil(odesc:desc), odesc:desc, odesc:caption)
            else
              cC   := val
            endif
            filtritW ->(FieldPut(npos,cC))
          endif

          if 'gate' $ lower(fld)
            if( npos := filtritW->(fieldPos('L' +substr(fld,2)))) <> 0
              filtritW->(fieldPut(npos, .not. empty(val)))
            endif
          endif

        endif
      endif

      buffer := substr(buffer, n +1)
    end

    if .not. filtritW->lnoedt_2 .and. at('->',filtritw ->cvyraz_2) <> 0
      filtritW->lnoedt_2 := .t.
    endif

*    filtritW->( dbgotop(), dbeval( {||  AAdd( ::aitw, filtritW ->cVYRAZ_2) }))

    filtritW->( dbgotop())
    do while .not. filtritW->( eof())
      lcanBeEmpty := .f.

      if upper(filtritW->ctype_1) = 'C'
        if at('cobdobi', lower(filtritW->cvyraz_1)) = 0
          lcanBeEmpty := .t.
        endif
      endif

      aadd( ::aitw, { filtritW ->cVYRAZ_2, lcanBeEmpty, 0 } )
      filtritW->( dbskip())
    enddo
    filtritW->( dbgoTop())
  endif

*  filtritW ->(DbGoTop())

  nBRo := if( ::udcp:className() = 'sys_filtrs_in', 1, 2)
return self

*
**
method sys_filtrs:build_memos()
  local  ofile   := drgDBMS:dbd:getByKey('filtritW'), pa := {}, x
  local  paFiles , cfile_1, cfile_2
  local  recNo   := filtritW->(recNo())
  *
  local  mfilterS := '', item, value, n_lgate, n_rgate, pa_operand
  local  mdata    := ''
  *
  local  isOk     := .t.

  paFiles := { upper( if( used('filtrsW'), filtrsW->cmainFile, filtrs->cmainFile) ) }

  for x := 1 to len( ofile:desc) step 1
    if( ofile:desc[x]:desc = 'S', aadd( pa, ofile:desc[x]:name), nil)
  next
  *
  * 1 - poèet levých a pravých závorek musí být shodný   clgate_ a crgate_
  * 2 - výraz smí být prázdný jen u posledního záznamu   coperand
  n_lgate    := 0
  n_rgate    := 0
  pa_operand := {}

  filtritW->(dbgoTop())

  do while .not. filtritW->(eof())
    cfile_1 := upper(alltrim(filtritW->cfile_1))
    cfile_2 := upper(alltrim(filtritW->cfile_2))

    for x := 1 to len(pa) step 1
      item    := pa[x]
      value   := DBGetVal('filtritW->' +item)

      if('gate' $ lower(item) .and. .not. empty(value))
        if('lgate' $ lower(item), n_lgate++, n_rgate++)
      endif

      if('coperand' = lower(item), aadd( pa_operand, value ), nil )

      if .not. empty(value)
        mfilterS += item +':' +if( isLogical(value), if(value, '1', '0'), value) +CRLF
      endif
    next

    ** relaèní prvky
    if( ascan( paFiles, { |a| a = cfile_1 }) = 0, aadd(paFiles,cfile_1), nil)

    if .not. empty(cfile_2) .and. (cfile_1 <> cfile_2)
      if( ascan( paFiles, { |a| a = cfile_2 }) = 0, aadd(paFiles,cfile_2), nil)
    endif
    **

    filtritW->(dbskip())

    mfilterS += if( .not. filtritW->(eof()), ';' +CRLF, '' )
  enddo

  filtritW->(dbgoTo(recNo))

  if( len(::relDef) > 0 .and. len(paFiles) > 1, mdata := ::build_memo_rel(paFiles), nil)

  * kromì posledního záznamu musí být operand vyplnìný
  if( ascan( pa_operand, {|x| empty(x) }, 1, len(pa_operand) -1) <> 0, isOk := .f., nil )
  isOk := ( isOk .and. ( n_lgate == n_rgate))

return { mfilterS, mdata, isOk }


#xtranslate  .relFile   =>  \[ 1\]
#xtranslate  .relKey    =>  \[ 2\]
#xtranslate  .relOrder  =>  \[ 3\]
#xtranslate  .mainFile  =>  \[ 4\]


method sys_filtrs:build_memo_rel(paFiles)
  local  mdata := '', x, y, z, relFile, tagDef, pa, relKey, ckey
  *
  local  relDef := ::relDef, u_relDef := {}, p_relDef

  mdata += '[DefineField]'              +CRLF
  mdata += '  [Table:' +paFiles[1] +']' +CRLF
  mdata += '    [Relations]'            +CRLF

  for x := 2 to len(paFiles) step 1
    relFile := paFiles[x]

    begin sequence
      for y := 1 to len(relDef) step 1
        aadd(u_relDef, { relDef[y]:relFile, relDef[y]:relKey, relDef[y]:relOrder, relDef[y]:mainFile })

        if upper(relDef[y]:relFile) = relFile
    break
        else

          begin sequence
            for z := 1 to len(relDef[y]:relSubs) step 1
              p_relDef := relDef[y]:relSubs[z]
              aadd(u_relDef, { p_relDef:relFile, p_relDef:relKey, p_relDef:relOrder, p_relDef:mainFile })

              if upper(p_relDef:relFile) = relFile
           break
               endif
            next
          end sequence

        endif
      next

    end sequence
  next

  ** uložím požadovanou relaci do mdata
  for x := 1 to len(u_relDef) step 1
     relFile := u_relDef[x].relFile
     relKey  := ''
    tagDef   := drgDBMS:dbd:getByKey(relFile):indexDef[u_relDef[x].relOrder]
        pa   := listAsArray(u_relDef[x].relKey,'+')
        pb   := listAsArray(tagDef:cindexKey  ,'+')

    for y := 1 to len(pa) step 1
      ckey   := strTran(allTrim(lower(pb[y])), allTrim(lower(pa[y])), u_relDef[x].mainFile +'->' +pa[y])
      relKey += ckey +'+'
    next
    relKey := subStr(relKey,1, len(relKey) -1)
    *
    mdata    += '    ' +str(u_relDef[x].relOrder,2) +':' ;
                       +str(x,2)                    +':' ;
                       +relKey                      +':' ;
                       +u_relDef[x].mainFile        +':' ;
                       +u_relDef[x].relFile              +CRLF
  next
return if(len(u_relDef) > 0, mdata, '')
**
*

method sys_filtrs:R_treeViewInit(drgObj)
  ::R_tree := drgObj:oXbp

  if( empty(::m_file), nil, ::R_fillRoot())
return


method sys_filtrs:R_fillRoot()
  local  oDbd  := drgDBMS:getDBD(::m_file)

  if( isObject(::R_rootItem), (::R_rootItem:destroy(), ::R_tree:configure()), nil)
  ::popUp   := ''
  ::a_files := {}
  *
  ::R_rootItem := relXbpTreeViewItem():New()
  * Set icon images
  ::R_rootItem:image         := DRG_ICON_PGM1
  ::R_rootItem:expandedImage := DRG_ICON_PGM2
  ::R_rootItem:markedImage   := DRG_ICON_PGM3
  ::R_rootItem:caption       := oDbd:description + '[' +upper(::m_file) +']'

  ::R_rootItem:create()
  ::R_tree:rootitem:additem(::R_rootItem)

  * popup
  ::popUp   += '[ ' +odbd:fileName +' ] - ' +  odbd:description +','
  aadd(::a_files, odbd:fileName)

  ::fillTree()
return self


method sys_filtrs:fillTree()
  local  oDbd := drgDBMS:getDBD(::m_file)
  local  x, y, oRELa, oRELs, o_file
  *
  local  o_rootItem := ::R_rootItem, oSUBitm, oSSUBitm, oItem

  oRELa := ::relDef := oDbd:relDef

  for x := 1 to len(oRELa) step 1
    oItem  := relXbpTreeViewItem():New()
    o_file := drgDBMS:getDBD(oRELa[x]:relFile)

    * Set icon images
    oItem:image         := DRG_ICON_PGM1
    oItem:expandedImage := DRG_ICON_PGM2
    oItem:markedImage   := DRG_ICON_PGM3

    oItem:caption       := o_file:description + '[' +oRELa[x]:relKey +']'
    oItem:cargo         := oRELa[x]

    oItem:create()
    o_rootItem:additem(oItem)

    * popup
    ::popUp += '[ ' +o_file:fileName +' ] - ' +  o_file:description +','
    aadd(::a_files, o_file:fileName)

    for y := 1 to len(oRELa[x]:relSubs) step 1
      otree_itm := relXbpTreeViewItem():New()
      oRELs     := oRELa[x]:relSubs[y]
      o_file    := drgDBMS:getDBD(oRELs:relFile)

      otree_itm:caption := o_file:description + '[' +oRELs:relKey +']'
      otree_itm:cargo   := oRELs

      otree_itm:create()
      oItem:addItem(otree_itm)

      * popup
      ::popUp += '[ ' +o_file:fileName +' ] - ' +  o_file:description +','
      aadd(::a_files, o_file:fileName)

      oItem := otree_itm
    next
  next
return self


*
**
CLASS relXbpTreeViewItem FROM XbpTreeViewItem
EXPORTED:
   VAR     idMenu, MenuType, MenuLevel, MenuCaption, MenuData

   METHOD  Init, Destroy, EventHandled
ENDCLASS

METHOD relXbpTreeViewItem:Init( parent)
  ::XbpTreeViewItem:init(parent)
  *
  ::idMenu      := ''
  ::MenuType    := ''
  ::MenuLevel   := 0
  ::MenuCaption := ''
  ::MenuData    := ''
RETURN self

METHOD relXbpTreeViewItem:Destroy()
  ::idMenu := ::MenuType := ::MenuLevel := ::MenuCaption := ::MenuData := NIL
RETURN self

********************************************************************************
METHOD relXbpTreeViewItem:EventHandled(nEvent, mp1, mp2, oXbp)

  ::XbpTreeViewItem:EventHandled(nEvent, mp1, mp2, oXbp)
RETURN .t.


*
**
CLASS SYS_fieldsW_SEL FROM drgUsrClass
EXPORTED:
  var     drgPush, drgStatic
  method  init, getForm, drgDialogStart, itemSelected
  method  createContext, fromContext

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected()

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

HIDDEN:
  var     brow
  var     p_udcp, p_drgGet, p_relDef
  var     m_file, m_item, m_desc, m_filter, m_value
  var     popUp, popState

  method  set_fieldW

ENDCLASS


method sys_fieldsW_sel:init(parent)
  local  nevent := mp1 := mp2 := oxbp := nil, name, value, o_file, filter
  *
  local  ctype_1

  ::drgUsrClass:init(parent)
  ::p_udcp   := parent:parent:udcp
  ::m_desc   := ''
  ::m_filter := "cfile = '%%'"
  ctype_1    := ::p_udcp:dm:get('filtritW->ctype_1')

  * relaèní soubory pro nabídku
  ::popUp    := subStr(::p_udcp:popUp, 1, len(::p_udcp:popUp) -1)
  ::popState := 1

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if isOBJECT(oXbp:cargo)
    ::p_drgGet := oXbp:cargo
    *
         name  := lower(::p_drgGet:name)
         name  := left(name, len(name) -1)

    if .not. empty(value := DBGetVal(name))
      if( at('->',value) <> 0, ::m_file   := drgParse(value,'-'), nil)
    endif
    ::m_item   := drgParseSecond(name,'>')
  endif

  if(empty(::m_file), ::m_file := ::p_udcp:m_file, nil)

  if .not. empty(::m_file)
    o_file   := drgDBMS:getDBD(::m_file)
    ::m_desc := '[ ' +::m_file +' ] - ' +  o_file:description

    ::set_fieldW( ::p_udcp:a_files )

    ::m_filter += if( 'cvyraz_1' $ name, "", " .and. ctype = '" +ctype_1 + "'" )

    filter := format(::m_filter, {lower(::m_file)} )
    fieldsW ->(ads_setAof(filter))
    ::m_value := if( at('->',value) <> 0, lower(value), nil)

  else
    drgMsgBox(drgNLS:msg('Zatím nebyl vybrán žádný hlavní soubor !!!'))
    return
  endif
return self


method sys_fieldsW_sel:getForm()
  local drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 89,20 DTYPE '10' TITLE 'Pole - výbìr' GUILOOK 'All:N,Border:Y'

* Browser definition
  DRGDBROWSE INTO drgFC FPOS 0.5,1.05 SIZE 88.5,18 FILE 'FIELDSw'    ;
    FIELDS 'cfile:soubor,'                    +  ;
           'cvyraz_u:Uživatelský název pole,' +  ;
           'cfield:promìnná,'                 +  ;
           'ctype:typ,'                       +  ;
           'nlen:len,'                        +  ;
           'ndec:dec'                            ;
            ITEMMARKED 'itemMarked' ITEMSELECTED 'itemSelected' SCROLL 'ny' CURSORMODE 3 PP 7 POPUP 'y'

  DRGSTATIC INTO drgFC FPOS 0.2,0 SIZE 88.8,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX
    DRGPUSHBUTTON INTO drgFC CAPTION ::m_desc POS 0,0 SIZE 39,1 ;
                  EVENT 'createContext' TIPTEXT 'Volba zobrazení dat'
    DRGPUSHBUTTON INTO drgFC                                    POS 85.7,0 SIZE 3,1 ;
                  ATYPE 1 ICON1 102 ICON2 202 EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'

  DRGEND  INTO drgFC
return drgFC


method sys_fieldsW_sel:drgDialogStart(drgDialog)
  local members  := drgDialog:oForm:aMembers
  local aSize    := drgDialog:dataAreaSize, xSize, value

  ::brow    := drgDialog:dialogCtrl:oBrowse[1]

  for x := 1 TO LEN(members) step 1
    if members[x]:className() = 'drgStatic'
      ::drgStatic := members[x]
    elseif members[x]:ClassName() = 'drgPushButton'
      if( ischaracter(members[x]:event), ::drgPush := members[x], nil)
    endif
  next

  xSize := ::drgPush:oxbp:currentSize()

  ::drgPush:oxbp:setSize({aSize[1] -3.2*drgINI:fontW,xSize[2]})
  ::drgPush:oXbp:setFont(drgPP:getFont(5))
  ::drgPush:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )

  if .not. empty(value := ::m_value)
    fieldsW->(dblocate({ || value $ fieldsW->cvyraz }))
  endif

  ::brow:oXbp:refreshAll()
return self


method sys_fieldsW_sel:itemSelected()
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return self


method sys_fieldsW_sel:createContext()
  local csubMenu, opopUp, apos
  *
  local pa := listasarray(::popUp +',Kompletní seznam položek')

  csubmenu := drgNLS:msg(::popUp +',Kompletní seznam položek')
  oPopup   := XbpMenu():new( ::drgDialog:dialog ):create()

  for x := 1 TO LEN(pa) step 1
    opopUp:addItem( {drgParse(@cSubMenu), de_BrowseContext(self,x,pA[x]) } )
  next

  oPopup:disableItem(::popState)

  aPos    := ::drgStatic:oXbp:currentPos()
  oPopup:popup(::drgDialog:dialog, aPos)
return self



method sys_fieldsW_sel:fromContext(aOrder, nMENU)
  local  a_files := ::p_udcp:a_files, cfile, filter
  local  obro := ::drgDialog:odbrowse[1]:oxbp

  ::popState := aOrder
  ::drgPush:oxbp:setCaption(nmenu)

  if len(a_files) >= aorder
    cfile  := a_files[aorder]
    filter := format(::m_filter,{ lower(cfile)})

    fieldsW->(ads_setAof(filter), dbgoTop())
  else

    if 'ctype' $ ::m_filter
     filter := "ctype = '" +filtritW->ctype_1 + "'"
     fieldsW->(ads_setAof(filter))
    else
      fieldsW->(ads_clearAof())
    endif
    fieldsW->(dbgoTop())
  endif

  obro:refreshAll()
return self


method sys_fieldsW_sel:set_fieldW( afile)
  LOCAL file, ofile, tmdesc
  local j,n

  drgDBMS:open('FIELDSw',.T.,.T.,drgINI:dir_USERfitm);ZAP
  if .not. IsNil(afile)
    for j :=1 to Len(afile)
      ofile := drgDBMS:dbd:getByKey(afile[j])

      for n := 1 to len( ofile:desc) step 1
        if .not. empty(ofile:desc[n]:desc)
          FIELDSw->(dbAppend())

          fieldsW->cfile    := lower(afile[j])
          fieldsW->cvyraz   := lower(afile[j] +'->' +ofile:desc[n]:name)
          fieldsW->cvyraz_u := ofile:desc[n]:desc
          fieldsW->cfield   := ofile:desc[n]:name
          fieldsW->ctype    := ofile:desc[n]:type
          fieldsW->nlen     := ofile:desc[n]:len
          fieldsW->ndec     := ofile:desc[n]:dec
        endif
      next
    next
  endif
return