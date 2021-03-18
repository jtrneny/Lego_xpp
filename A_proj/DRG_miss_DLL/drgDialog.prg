 //////////////////////////////////////////////////////////////////////
//
//  drgDialog.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgDialog class represents one dialog window on the screen.
//
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
*
#include "Font.ch"
#include "Gra.ch"
*
#include "..\Asystem++\Asystem++.ch"


****************************************************************************
****************************************************************************
*
* Abstract drgUsrClass class definition
*
****************************************************************************
****************************************************************************
CLASS drgUsrClass
EXPORTED:
  VAR     drgDialog
  VAR     dataManager
  VAR     formManager

  VAR     dialogIcon
  VAR     dialogTitle

  METHOD  init, destroy, eventHandled
ENDCLASS

METHOD drgUsrClass:init(parent)
  ::drgDialog   := parent
  ::dataManager := ::drgDialog:dataManager
  ::formManager := ::drgDialog:oForm
RETURN self


METHOD drgUsrClass:eventHandled(nEvent, mp1, mp2, oXbp)
RETURN .F.

METHOD drgUsrClass:destroy()
  ::dialogIcon  := ;
  ::dialogTitle := ;
  ::drgDialog   := ;
  ::dataManager := ;
  ::formManager := ;
                    NIL
RETURN

****************************************************************************
****************************************************************************
*
* drgDialog class definition
*
****************************************************************************
****************************************************************************
CLASS drgDialog
  EXPORTED:
  VAR     cargo
  VAR     cargo_usr
  VAR     exitState
  VAR     parent
  VAR     parentDialog
  VAR     dialog
  VAR     dialogCtrl
  VAR     initParam                         // initialization parameters
  VAR     title
  VAR     oBord
  VAR     dataAreaSize
  VAR     members

  VAR     formName
  VAR     helpName
  VAR     formObject
  VAR     formHeader
  VAR     oForm

  VAR     dataManager
  VAR     UDCP                            // user control program
  VAR     actionManager
  VAR     lastXbpInFocus
  VAR     lastRECNO

  VAR     hasActionArea
  VAR     hasIconArea
  VAR     hasMenuArea
  VAR     hasMsgArea
  VAR     hasBorder
  VAR     usrIconArea
  VAR     usrMenuArea
  VAR     usrMsgArea
  VAR     usrPos                          // pole {X,Y} pro možnost pozicování z programu MISs
  VAR     oIconBar
  VAR     oActionBar
  VAR     oMessageBar
  VAR     asysact

  VAR     dbName, odbrowse,    act_Filter, act_killFilter
  var                       id_act_Filter, opt_act_Filter

  *
  var     master_brow
  var     a_bro_popup       // pole BRO umožòujících popup
  var     a_act_filtrs      // pole aktivních filtrù na dialogu, ukládá se do asysini
                            // { { file, { adm }, { prg }, { usr } } ...

**                 ID                    COND          EX_COND       ACT
** struktura ADM  {fltusers->cidfilters, oini:ft_cond, oini:ex_cond, .f.}
** struktura PRG  {                    , oini:ft_cond,             , .t.}
** struktura USR  {fltusers->cidfilters, oini:ft_cond, oini:ex_cond, .f.}
** sakra jak poznat soubor
**
  var     ostart_dialog
  var     odata_datKom
  var     isSpecFRM                // FRM u kterého nedochází k obnovì a uložení

  METHOD  init
  METHOD  create
  METHOD  quickShow
  METHOD  destroy
  METHOD  setDisplayFocus
  METHOD  killDisplayFocus
  METHOD  setTitle
  METHOD  getMethod
  METHOD  getVarBlock
  METHOD  pushArea
  METHOD  popArea
  METHOD  setReadOnly

  *  je potøeba ovlivnit zobrazení období, active/ inActive
  ** uct_ucetsys_inlib
  *  základní funce pro volání dialogu UCT_ucetsys
  inline method set_uct_ucetsys_inlib( lDisable )
    local  o_obd, x_event

    default lDisable to .t.

    if isObject( ::oIconbar )
      o_obd   := atail( ::oIconBar:members )
      x_event := isNull( o_obd:event, '' )

      if isCharacter(x_event) .and. lower(x_event ) = 'uct_ucetsys_inlib'
        if lDisable
          o_obd:oxbp:disable()
        else
          o_obd:oxbp:enable()
        endif
      endif
    endif
  return


  * v metodì INIT na UDCP nastavíme programový filtr
  inline method set_PRG_filter(prg_filter, cfile, lrunFiltrs)
    local  npos

    default lrunFiltrs to .f.

    if (npos := ascan( ::a_act_filtrs, {|p| p[1] = lower(cfile)} )) = 0
      aadd( ::a_act_filtrs, { cfile, {}, { ,prg_filter, , .t.}, {} })
    else
      ::a_act_filtrs[npos,3] := { ,prg_filter, , .t.}
    endif

    if( lrunFiltrs, ::runFiltrs(), nil )
  return
  *
  * vrátíme nastavení filtrù pro konkrétní soubor - dle parametru APU defaut APU
  inline method get_APU_filter(cfile,capu)
    local  npos, nfile, ft_APU_cond := ''
    local    adm_cond      ,   prg_cond      ,   usr_cond
    local  c_adm_cond := '', c_prg_cond := '', c_usr_cond := '', c_quick_cond := ''

    default capu to ''

    capu := lower(capu)

    if (npos := ascan( ::a_act_filtrs, {|p| p[1] = lower(cfile)} )) <> 0
      adm_cond := ::a_act_filtrs[npos,2]
      prg_cond := ::a_act_filtrs[npos,3]
      usr_cond := ::a_act_filtrs[npos,4]

      ** ADM
      if 'a' $ capu
        c_adm_cond := if( len(adm_cond) <> 0, ;
                      if( len(adm_cond[2]) <> 0, '(' +adm_cond[2] +')', ''), '' )
      endif

      ** PRG
      if 'p' $ capu
        c_prg_cond := if( len(prg_cond) <> 0, ;
                      if( len(prg_cond[2]) <> 0, '(' +prg_cond[2] +')', ''), '' )
      endif

      ** USR
      if 'u' $ capu
        c_usr_cond := if( len(usr_cond) <> 0, ;
                      if( len(usr_cond[2]) <> 0, '(' +usr_cond[2] +')', ''), '' )
      endif

      ** QUICK
      if 'q' $ capu
        if IsMemberVar( ::udcp, 'sel_Item'  ) .and. IsMemberVar( ::udcp, 'sel_Filtrs')
          if .not. empty(sel_Filtrs := ::udcp:sel_Filtrs)
            if( nfile := ascan( sel_Filtrs, {|x| lower(x[1]) = lower(cfile) } )) <> 0
              c_quick_cond := if( len(sel_Filtrs[nfile,2,2]) <> 0, '(' +sel_Filtrs[nfile,2,2] +')', '')
            endif
          endif
        endif
      endif


      ft_APU_cond := if( .not. empty(c_adm_cond), c_adm_cond, '')
      ft_APU_cond += if( .not. empty(c_prg_cond), ;
                     if( empty(ft_APU_cond), '' +c_prg_cond, ' .and. ' +c_prg_cond), c_prg_cond)
      ft_APU_cond += if( .not. empty(c_usr_cond), ;
                     if( empty(ft_APU_cond), '' +c_usr_cond, ' .and. ' +c_usr_cond), c_usr_cond)
      ft_APU_cond += if( .not. empty(c_quick_cond), ;
                     if( empty(ft_APU_cond), '' +c_quick_cond, ' .and. ' +c_quick_cond), c_quick_cond)

    endif
  return ft_APU_cond


  inline method save_act_filter(ctyp, cfile, ft_cond, ex_cond)
    local  npos

    default ft_cond to '', ;
            ex_cond to ''

    if (npos := ascan( ::a_act_filtrs, {|p| p[1] = lower(cfile)} )) = 0
      aadd( ::a_act_filtrs, { cfile, {}, {}, { fltusers->cidfilters, ft_cond, ex_cond, .t. } })
    else
      ::a_act_filtrs[npos,4] := { fltusers->cidfilters, ft_cond, ex_cond, .t. }
    endif
  return


  inline method del_act_filter()
    ::misDialogKillFilter()
  return


  inline method get_act_filter(ctyp, cfile)
    local npos, pa, ok := .f.

    ::id_act_filter  := ''
    ::opt_act_filter := 0

    if (npos := ascan( ::a_act_filtrs, {|p| p[1] = lower(cfile)} )) <> 0
      pa := ::a_act_filtrs[npos, if(ctyp = 'adm', 1, 4)]
      ok := (len(pa) <> 0)

      ::id_act_filter  := if(ok, pa[1], '')
      ::opt_act_filter := 0
    endif
  return ok
  *
  ** quickFilter na SEL dialogu
  inline method sel_dbseek( sel_ky, IndexKeyValue, lSoftSeek, xTagName, lLast )
    local  cfile := lower( Alias( Select()))
    local  ok    := .f., sel_Cond := '.t.', nfile
    *
    local  ky    := upper(padr(usrName,10))    + ;
                    upper(padr(::formName,50)) + ;
                    sel_ky

    if(select('asysini') = 0, drgDBMS:open('asysini'), nil)

    if asysini->(dbseek( ky,,'ASYSINI02'))
      if .not. empty( asysini->sel_Filtrs)
        sel_Filtrs:= bin2Var( asysini->sel_Filtrs )

        if( nfile := ascan( sel_Filtrs, {|x| lower(x[1]) = cfile } )) <> 0
          sel_Cond := sel_Filtrs[nfile,2,2]
        endif
      endif
    endif

    if dbseek( IndexKeyValue, lSoftSeek, xTagName, lLast )
      ok := if( .not. empty(sel_Cond), DBGetVal( sel_Cond ), .t. )
    endif
  return ok

HIDDEN:
  VAR     dbAreaStack
  VAR     dbAreaIndex
  var     frameState

  METHOD  setGUILOOK
  METHOD  loadForm, getBroFields
  METHOD  createGUILOOK
  METHOD  eventLoop

****************
 inline method get_preset_filtrs()
    local  ky := upper(padr(usrName,10)) +upper(padr(::formName,50))
    local  npos, nitem

    drgDBMS:open('filtrs')
    drgDBMS:open('fltusers',,,,, 'flt_userw')

    flt_userW->(AdsSetOrder('FLTUSERS01'), dbsetScope(SCOPE_BOTH, ky), dbgoTop())

    do while .not. flt_userW->(eof())
      if flt_userW->lbegAdmin .or. flt_userW->lbegUsers

        if filtrs->(dbSeek( upper(flt_userW->cidFilters),,1))

          if (npos := ascan( ::a_act_filtrs, {|p| p[1] = lower(flt_userW->cmainFile)} )) = 0
            aadd( ::a_act_filtrs, { flt_userW->cmainFile, {}, {}, {} } )
            npos := len(::a_act_filtrs)
          endif

          if ::read_preset_filtrs()
            oini := flt_setcond():new(.f.,.f.)
            nin  := if( flt_userW->lbegAdmin, 2, 4)

            ::a_act_filtrs[npos,nin] := {flt_userW->cidfilters, oini:ft_cond, oini:ex_cond, .f.}
          endif
        endif
      endif
      flt_userW->(dbskip())
    enddo

    flt_userW->(dbclearScope())
  return self

  inline method read_preset_filtrs()
    local  buffer, cname, pos, fld, val, ppos, file, ncount := 1
    *
    local  mfilterS  := flt_userW->mfilterS_u
    local  isComplet := .t.

    if( select('filtritw') <> 0, filtritW->(DbCloseArea()), nil )

    drgDBMS:open('filtritw',.T.,.T.,drgINI:dir_USERfitm)


    filtritW->(dbZap())
    filtritW->(dbAppend())
    filtritW->ncount := ncount
    ncount++

    buffer := StrTran(MemoTran(mfilterS,chr(0)), ' ', '')

    while( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
      if left(buffer,1) = ';'
        if .not. filtritW->lnoedt_2 .and. at('->',filtritw ->cvyraz_2) <> 0
          filtritW->lnoedt_2 := .t.
        endif

        filtritW ->(DbAppend())
        filtritW->ncount := ncount
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
               &('filtritW->cfile_' +right(fld,1)) := lower(left(val,ppos-1))

               if lower(fld) = 'cvyraz_1'
                 if isobject(odesc := drgDBMS:getFieldDesc(val))

                   filtritW->ctype_1 := odesc:type
                   filtritW->nlen_1  := odesc:len
                   filtritW->ndec_1  := odesc:dec
                 endif
               endif
             endif
          endif

          if (npos := filtritW ->(FieldPos(fld +'u'))) <> 0
            if isObject(odesc := drgDBMS:getFieldDesc(val))
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

// ne    filtritW->(dbeval( {|| if( empty(filtritW->cvyraz_2), isComplet := .f., nil ) } ), ;
//                  dbgotop()                                                        )
  return isComplet


  inline method runFiltrs()
    local  pa := ::a_act_filtrs, x
    local  pft_cond, adm_cond, prg_cond, usr_cond, quick_cond
    local  cfile, ft_cond := ''
    *
    local  npos, recCount, optLevel, n, is_USR := .f.
    local  acolors := GRA_FILTER_OPTLEVEL, oicon
    *
    local  nfile
    local  cusAof_pulRecords := {}, cusAof_usOption := 2


    for x := 1 to len(pa) step 1
      pft_cond := pa[x]

      cfile    := allTrim(pft_cond[1])
      adm_cond := pft_cond[2]
      prg_cond := pft_cond[3]
      usr_cond := pft_cond[4]

      ** ADM
      if len(adm_cond) <> 0
        ft_cond += if( empty(ft_cond), '', ' .and. ') +adm_cond[2]
      endif

      ** PRG
      if len(prg_cond) <> 0
        ft_cond += if( empty(ft_cond), '', ' .and. ') +prg_cond[2]
      endif

      ** USR
      if len(usr_cond) <> 0
        ft_cond += if( empty(ft_cond), '', ' .and. ') +usr_cond[2]
        is_USR  := .t.
      endif

      ** QUCK
      if IsMemberVar( ::udcp, 'sel_Item'  ) .and. IsMemberVar( ::udcp, 'sel_Filtrs')
        if .not. empty(sel_Filtrs := ::udcp:sel_Filtrs)
          if( nfile := ascan( sel_Filtrs, {|x| lower(x[1]) = lower(cfile) } )) <> 0
            if .not. empty( quick_cond := sel_Filtrs[nfile,2,2])

              ft_cond += if( empty(ft_cond), '', ' .and. ') +'(' +quick_cond +')'
            endif
          endif
        endif
      endif

      ** na QUICK cusAof_pulRecords -- cusAof_usOption
      if IsMemberVar( ::udcp, 'cusAof_pulRecords'  ) .and. IsMemberVar( ::udcp, 'cusAof_usOption')
         cusAof_pulRecords := ::udcp:cusAof_pulRecords
         cusAof_usOption   := ::udcp:cusAof_usOption

      endif


      if .not. empty(ft_cond)
                    (cfile)->(ads_setaof(ft_cond) )    //   ,dbgoBottom())
                    if len(cusAof_pulRecords) <> 0
                      (cfile) ->(ads_customizeAof( cusAof_pulRecords, cusAof_usOption))
                    endif
                    (cfile)->(dbskip(1),dbskip(-1))

        recCount := (cfile)->(Ads_GetRecordCount())
        optLevel := (cfile)->(Ads_GetAOFOptLevel())

        if (npos := ascan(::odbrowse, { |o| lower(o:cfile) = lower(cfile) })) <> 0
          ::odbrowse[npos]:oxbp:refreshAll()

          * pouze pro USR indikujeme nastavení
          if is_USR .and. optLevel <> 0
            if ( npos := ascan( acolors, 340 +optLevel )) <> 0
              oIcon := xbpIcon():new():create()
              oIcon:load( , 340 +optLevel )

              ::act_Filter:oxbp:image := oIcon
              ::dialog:setTitle( ::Title +' . ' +allTrim(filtrs->cfltname) +' = ' +allTrim(Str(recCount)))
            endif
          endif
        endif
      else

        if len(cusAof_pulRecords) <> 0
          (cfile)->( ads_setAof('1=1'))
          (cfile) ->(ads_customizeAof( cusAof_pulRecords, cusAof_usOption))
          (cfile)->(dbskip(1),dbskip(-1))
        endif

      endif
    next
  return


  inline method is_master_brow()
    local  npos

    do case
    case len(::a_bro_popup) = 0  ;  ::master_brow := nil
    case len(::a_bro_popup) = 1  ;  ::master_brow := ::a_bro_popup[1]
    case len(::a_bro_popup) > 1
      if ::lastXbpInFocus:className() = 'XbpBrowse'
        npos := ascan(::a_bro_popup, { |o| o:oxbp = ::lastXbpInFocus })
        ::master_brow := if( npos = 0, nil, ::a_bro_popup[npos]      )
      endif
    endcase
  return .not. empty(::master_brow)


  inline method misDialogSort()
    local  obro, cfile, adbd
    local  omenu, x, nPos := 0, pa := {}, st, members, ic_sort := 0, x_pos, y_pos
    local  ctagName, indexDef
    local  cname_Def
    *
    local  odlg := ::dialog, arect

    if len(::odbrowse) > 0 .and. ::is_master_Brow()
       obro  := ::master_brow
       cfile := obro:cfile
       adbd  := drgDBMS:getDBD(cfile)

       omenu := XbpImageMenu():new(obro:oxbp)
       omenu:title   := ''
       omenu:barText := drgNLS:msg('Sorted')
       omenu:create()

       if len(adbd:indexDef) > 0
         * definované tágy ze seznamu vyøadí
         ctagName := lower( (cfile)->(ordSetFocus()) )

         for x := 1 to len(adbd:indexDef) step 1
           if adbd:indexDef[x]:lInSort
             nPos++
             cname_Def := lower(adbd:indexDef[x]:cName)
             aadd( pa, { nPos, x, adbd:indexDef[x]:cName })
             st := str(x,2) +':' + adbd:indexDef[x]:ccaption

             omenu:addItem({ st, ;
                           {|x| obro:fromContext(8,,pa[x,2],,pa[x,3])},, ;
                            XBPMENUBAR_MIA_OWNERDRAW }         , ;
                            if( ctagName = cname_Def, 500, NIL ))
*             omenu:checkItem(nPos,.f.)
           endif
         next

         if isObject(::oiconBar)
           members := ::oiconBar:members
         endif

         apos  := obro:oxbp:currentPos()
         asize := obro:oxbp:currentSize()

         x_pos := if(ic_sort = 0, asize[1]/2, members[ic_sort]:oxbp:currentPos()[1])
         y_pos := asize[2] +10

         omenu:popup(obro:oxbp, { x_pos, y_pos })
       endif
    endif
  return


  inline method misDialogFilter()
    local oDialog, nExit

    if ( ::is_master_brow() .and. isObject(::oIconBar) )
      DRGDIALOG FORM drgIni:stdDialogFilter PARENT ::drgDialog MODAL DESTROY ;
                                                               EXITSTATE nExit

      if nexit = drgEVENT_SELECT
        ::master_brow:oxbp:refreshAll()
      endif
    endif
  return .t.

  inline method misDialogKillFilter()
    local  obro, cfile, ft_AP_cond, ft_APUQ_cond, npos
    local  oicon
    *
    local  cfiltr, ldel_USR := .t.

    if ( ::is_master_brow() .and. isObject(::oIconBar) )
      obro  := ::master_brow
      cfile := ::master_brow:cfile

      if .not. empty(cfiltr := (cfile)->(ads_getAof()))

        ft_APUQ_cond := ::get_APU_filter(cfile,'apuq')
        *
        ** ruší filtr, musíme se podívat jestli nemìl nastavený F-filtr
        if .not. Equal( strTran( strTran(cfiltr, '(', ''), ')', ''), strTran( strTran(ft_APUQ_cond, '(', ''), ')', '') )

//        if .not. Equal( cfiltr, ft_APUQ_cond )
          ft_AP_cond := ft_APUQ_cond
          ldel_USR   := .f.
        else
          ft_AP_cond   := ::get_APU_filter(cfile,'apq')
        endif

        if( empty(ft_AP_cond), (cfile)->(ads_clearAof()), (cfile)->(ads_setAOF(ft_AP_cond)))
        if((cfile)->(eof()), (cfile)->(dbgoTop()), nil)

        * musíme zrušit vazbu usr
        if ldel_USR
          if (npos := ascan( ::a_act_filtrs, {|p| p[1] = lower(cfile)} )) <> 0
            if len( ::a_act_filtrs[npos,4]) <> 0
              ::a_act_filtrs[npos,4] := {}
              ::id_act_Filter        := ''
            endif
          endif
        endif

        if ldel_USR
          oIcon := xbpIcon():new():create()
          oIcon:load( , MIS_ICON_FILTER )

          ::act_Filter:oxbp:image := oIcon
          ::dialog:setTitle(::title)
        endif

        obro:oxbp:refreshAll()
        setAppFocus(obro:oxbp)
        postAppEvent( xbeBRW_ItemMarked,,,obro:oxbp )

      endif
    endif
  return .t.

  inline method misDialogDocuments()
    local oDialog, obro, cfile

    if len(::odbrowse) > 0
      obro  := ::odbrowse[1]
      cfile := obro:cfile

      DRGDIALOG FORM drgIni:stdDialogDocs PARENT ::drgDialog MODAL DESTROY
    endif
  return .t.

  inline method misDialogDataComunic()
    local oDialog, obro, cfile

    if len(::odbrowse) > 0
      obro  := ::odbrowse[1]
      cfile := obro:cfile

      DRGDIALOG FORM drgIni:stdDialogDataCom PARENT ::drgDialog MODAL DESTROY
    endif
  return .t.

  inline method misDialogSwHelp()
    local oDialog, obro, cfile

    if len(::odbrowse) > 0
      obro  := ::odbrowse[1]
      cfile := obro:cfile

      DRGDIALOG FORM drgIni:stdDialogSwHelp PARENT ::drgDialog MODAL DESTROY
    endif
  return .t.

  inline method misDialogBroRefresh()
    local  obro, nstep

    if len(::odbrowse) > 0 .and. (SetAppFocus():className() = 'XbpBrowse')
      obro  := ::odbrowse[1]

      obro:oxbp:lockUpdate(.t.)
      obro:oxbp:configure():refreshAll()
      obro:oxbp:lockUpdate(.f.)

      for nstep := 2 to len(::odbrowse) step 1
        ::odbrowse[nstep]:oxbp:lockUpdate(.t.)
        ::odbrowse[nstep]:oxbp:configure():refreshAll()
        ::odbrowse[nstep]:oxbp:lockUpdate(.f.)
      next

      setAppFocus(obro:oxbp)
    endif
  return .t.
ENDCLASS


****************************************************************************
* Class initialization
****************************************************************************
METHOD drgDialog:init(cInitParam, oParent)
LOCAL cPGM, cPgmBlock
  ::initParam   := cInitParam
* Determine the type of parent and set internal VARs for parent
  IF oParent:isDerivedFrom( "XbpDialog" )
    ::parentDialog := oParent
  ELSE
    ::parent       := oParent
    ::parentDialog := oParent:dialog
  ENDIF
* Create workArea stack
  ::dbAreaStack := ARRAY(8,3)
  ::dbAreaIndex := 0
*
  ::members  := {}
  ::odbrowse := {}
  ::lastXbpInFocus := NIL
* create managers
  ::dataManager := drgDataManager():new(self)
  AADD(::members, ::dataManager)
  ::actionManager := drgActionManager():new(self)
  AADD(::members, ::actionManager)

  //  oprávnìní    act, dis, dea, beg, new, del, mod, sav
  ::asysact  := {  .f., .f., .f., .f., .f., .f., .f., .f. }

  ::a_bro_popup   := {}
  ::a_act_filtrs  := {}
  ::isSpecFRM     := .f.
RETURN self

****************************************************************************
* Create new dialog
****************************************************************************
METHOD drgDialog:create(cTitle, owner, lModal, can_showDialog)
  LOCAL fForm, aPos, aSize, pos, size
  LOCAL oHlp, oBar, oFunction
  LOCAL cPGM, cPgmBlock, defGUI, oldFocus
  LOCAL oDesktop, winRes
  LOCAL aPosSiz, cForm, hWnd, centerPos
  *
  LOCAL showDialog := .T.
  LOCAL firma      := ''
  LOCAL user       := ''
  *
  local ostart_dialog
  local formName, obj, paFormsModal, npos
  *
  default lModal         TO .f., ;
          can_showDialog to .t.


  if .not. ('drgmenu'      $ lower(::initParam) .or. ;
            'asystemlogin' $ lower(::initParam) .or. ;
            'loginfirma'   $ lower(::initParam) .or. ;
            'loginuser'    $ lower(::initParam)      )

    * tohle je úprava pro reinstalaci
    if isObject( osplash_for_dialog )
      osplash_for_dialog:show()
      ::ostart_dialog :=  ostart_dialog := 1
    endif
  endif

  * FRM se neukládá ani neobnovuje
  ::isSpecFRM := ( 'asystemlogin' $ lower(::initParam) .or. ;
                   'loginfirma'   $ lower(::initParam) .or. ;
                   'loginuser'    $ lower(::initParam)      )

  oDesktop := AppDesktop()
  winRes := oDesktop:currentSize()
* Owner of the dialog must be set when lModal is requested
  IF lModal .AND. owner = NIL
    owner := ::parentDialog
  ENDIF
  oldFocus := SetAppFocus()

  *
  IF !::loadForm()
    if( isObject(ostart_dialog), ostart_dialog:stop(), nil )
    if ::asysact[1] .and. .not. ::asysact[4]
      drgMSGBox('Nemáte povolený pøístup !')
    endif
    RETURN NIL
  ENDIF

  ::setGUILOOK()

  *  Size of main area
  ::dataAreaSize  := { ::formHeader:size[1]*drgINI:fontW, (::formHeader:size[2]+0)*drgINI:fontH }
  aSize := ACLONE(::dataAreaSize)

  * Create dialog
  ::dialog := XbpDialog():new( oDesktop, owner , {1,1}, oDesktop:currentSize() , , .f. )

  * Check for dialogStart user method
  IF (cPgmBlock := ::getMethod(, 'drgDialogInit') ) != NIL
    EVAL( cPgmBlock, self )
  ENDIF

  ::dialog:taskList := .T.
  ::dialog:Border   := ::formHeader:border

  * Set title AND icon. They may also be set in USR program
  ::title := IIF(cTitle = NIL, ::formHeader:title, cTitle)
  ::title := drgNLS:msg(::title)
  if !isWorkVersion
    ::title += '  [' +logFirma +':'+logUser +']'
  else
    ::title += '  [' +AllTrim(drgINI:dir_DATA) +':' +AllTrim( usrName)+ ']'
  endif

  ::dialog:title := IIF(::UDCP != NIL .AND. ::UDCP:dialogTitle != NIL, ;
                        ::UDCP:dialogTitle, ::title )
  ::dialog:icon  := IIF(::UDCP != NIL .AND. ::UDCP:dialogIcon != NIL, ;
                        ::UDCP:dialogIcon, drgINI:appIcon )

  ::dialog:create()
  AADD(::members, ::dialog)
**
  if( isNumber( ostart_dialog ), osplash_for_dialog:show(), nil )

* Set database file name
  IF ( ::dbName := ::formHeader:file ) = NIL
    ::dbName := 'M'
  ELSEIF !(::dbName == 'M')
    drgDBMS:open(::dbName)                        // open file
  ENDIF

* Set controllers dbArea
  ::dialogCtrl:dbArea := IIF(EMPTY(::dbName), 0, SELECT() )

* Create main border area
  pos := IIF(::hasMsgArea, {0, drgINI:fontH + 1}, {0, 0} )
  ::oBord := XbpStatic():new(::dialog:drawingArea, ,pos, aSize )
  ::oBord:type := IIF(::hasBorder, XBPSTATIC_TYPE_RAISEDBOX, XBPSTATIC_TYPE_TEXT)
  ::oBord:create()
  AADD(::members, ::oBord)

* Create GUILOOK objects on drawing area
  ::createGUILOOK(aSize)

* Create Form
  cForm   := '{ |a| ' + ::formHeader:type + '():new(a) }'
  ::oForm := EVAL( &cForm, self)       // Macro operator is essential
  AADD(::members, ::oForm)

* Add actions to menuBar
  IF ::hasActionArea
    ::oActionBar:addAction2Menu()
  ENDIF

* Register handler procedures to dialog controller
  ::dialogCtrl:register(::oForm)
  ::dialogCtrl:register(::UDCP)

* Set lModal state
  IF lModal
    ::dialog:setModalState(XBP_DISP_APPMODAL)
  ENDIF

* Set dialog callbacks
  ::dialog:setDisplayFocus  := {|mp1,mp2,obj| ::setDisplayFocus(mp1,mp2,obj) }
  ::dialog:killDisplayFocus := {|mp1,mp2,obj| ::killDisplayFocus(mp1,mp2,obj) }
*
**
  aeval(::odbrowse, {|o| if( isBlock(o:oxbp:itemRbDown), aadd(::a_bro_popup,o), nil ) })
**
*
  drgLog:cargo   := NIL
  ::dialog:cargo := self

*************************************************************************
* Recalculate dialog size
  ::dataAreaSize[1] += winRes[1] - ::dialog:drawingArea:currentSize()[1] + 0
  ::dataAreaSize[2] += winRes[2] - ::dialog:drawingArea:currentSize()[2] + 0
  ::dialog:setSize(::dataAreaSize,.F.)
  ::dialog:minSize := ::dataAreaSize
* Set position of dialog
  aPosSiz := GetSaveDialogPos(::formName, ::dialog, .T.)

  IF (cPgmBlock := ::getMethod(, 'drgDialogStart') ) != NIL
    * je možné zakázat zobrazení dialogu pokud nejsou splnìny podmínky
    showDialog := EVAL( cPgmBlock, self )
    IF( IsLOGICAL(showDialog), NIL, showDialog := .T. )
  ENDIF

  * ze _centerPos vrátí jen {x,y}
  if len(aposSiz) = 2
    asize(aposSiz,5)
    aposSiz[3] := 0
    aposSiz[4] := 0
    aposSiz[5] := 0
  endif
  *

  IF IsNULL(::usrPos)
    if aposSiz[5] = 1
      centerPos := _CenterPos(::dialog)
      ::dialog:setPos( {centerPos[1], centerPos[2]} )
    else
      ::dialog:setPos ({aPosSiz[1],aPosSiz[2]}, .F.)
      *
      aSize := ::dialog:currentSize()
      if (aPosSiz[3]+aPosSiz[4]) > 0
        ::dialog:setSize({aPosSiz[3],aPosSiz[4]}, .F.)
        ::oForm:resize(aSize, {aPosSiz[3],aPosSiz[4]} )
      endif
    endif
  ELSE
    ::dialog:setPos({::usrPos[1],::usrPos[2]}, .F.)
  ENDIF

  if isNumber( ostart_dialog )
    if len( ::odbrowse ) <> 0
      ( ::get_preset_filtrs(), ::runFiltrs() )
    endif
    osplash_for_dialog:hide()
  endif

  *
  * lze spustit dialog ??
  IF showDialog .and. can_showDialog
    _clearEventLoop()

    if ::hasIconArea
      if isObject( ::oIconBar:oToolBar)
        ::oIconBar:oBord:show()
      endif
    endif

*    aeval( ::odbrowse, { |o| ;
*         ( if( isblock(o:itemMarked), eval(o:itemMarked,{o:oxbp:rowPos,o:oxbp:colPos},,o:oxbp), nil ), ;
*           o:oxbp:show()         ) })

    * max režim okna
    if aposSiz[5] = 1
      asize := ::dialog:currentSize()

      ::oForm:resize(asize, {aPosSiz[3],aPosSiz[4]} )
      ::dialog:setFrameState( XBPDLG_FRAMESTAT_MAXIMIZED )

      if ::hasIconArea
        if isObject( ::oIconBar:oToolBar)
          ::oIconBar:oToolBar:refresh()
        endif
      endif

      aeval( ::odbrowse, { |o| ;
         ( if( isblock(o:itemMarked), eval(o:itemMarked,{o:oxbp:rowPos,o:oxbp:colPos},,o:oxbp), nil ), ;
           o:oxbp:show()         ) })

    else

      ::dialog:show()
      aeval( ::odbrowse, { |o| ;
         ( if( isblock(o:itemMarked), eval(o:itemMarked,{o:oxbp:rowPos,o:oxbp:colPos},,o:oxbp), nil ), ;
           o:oxbp:show()         ) })


      _clearEventLoop()
    endif


// ne    aeval( ::odbrowse, { |o| ;
// ne           ( if( isblock(o:itemMarked), eval(o:itemMarked,{o:oxbp:rowPos,o:oxbp:colPos},,o:oxbp), nil ), ;
// ne           o:oxbp:show()         ) })

    ::frameState := ::dialog:getFrameState()
    setAppFocus(::dialog)
*************************************************************************
* Dialog main event loop
    drgServiceThread:setActiveThread( ThreadID() )
    *
    ** až je nastartované menu, mùžem spustit úlohy v drgTaskManager
    if( lower(::formName) = 'drgmenu' .and. isObject(drgTaskManager) )
       drgTaskManager:odrgMenu      := self
       drgTaskManager:is_menuActive := .t.
     endif

    ::eventLoop()

* Check for dialogEnd user method
    IF (cPgmBlock := ::getMethod(, 'drgDialogEnd') ) != NIL
      EVAL( cPgmBlock, self )
    ENDIF

* pokud je na dialogu použit quickFilter, musíme ho uložit
    IF (cPgmBlock := ::getMethod(, 'quickFilterEnd') ) != NIL
      EVAL( cPgmBlock, self )
    ENDIF


    drgServiceThread:setActiveThread(0)
    GetSaveDialogPos(::formName, ::dialog, .F. )
* Must be set modeless. Otherwise parent doesn't receive focus properly
    IF lModal
      ::dialog:setModalState(XBP_DISP_MODELESS)
    ENDIF
    ::dialog:hide()
  endif

  SetAppFocus(oldFocus)
RETURN self


method drgDialog:quickShow(lmodal)
  local  oldFocus := SetAppFocus()

  default lModal TO .f.

  ::dialog:show()

  ::frameState := ::dialog:getFrameState()

  setAppFocus(::dialog)
*************************************************************************
* Dialog main event loop
   drgServiceThread:setActiveThread( ThreadID() )
   ::eventLoop()

* Check for dialogEnd user method
    IF (cPgmBlock := ::getMethod(, 'drgDialogEnd') ) != NIL
      EVAL( cPgmBlock, self )
    ENDIF

* pokud je na dialogu použit quickFilter, musíme ho uložit
    IF (cPgmBlock := ::getMethod(, 'quickFilterEnd') ) != NIL
      EVAL( cPgmBlock, self )
    ENDIF


    drgServiceThread:setActiveThread(0)
    GetSaveDialogPos(::formName, ::dialog, .F. )
* Must be set modeless. Otherwise parent doesn't receive focus properly
    IF lModal
      ::dialog:setModalState(XBP_DISP_MODELESS)
    ENDIF
    ::dialog:hide()

  SetAppFocus(oldFocus)
RETURN self


***********************************************************************
* This dialogs event loop
***********************************************************************
METHOD drgDialog:eventLoop()
  local  nEvent   := NIL, mp1   := NIL, mp2   := NIL, oXbp   := NIL, obj, p_obj
  *
  local  frameState, ok := .t.


  WHILE .T.
    nEvent := AppEvent( @mp1, @mp2, @oXbp )
    *
    ** pøístupová práva
    if ::asysact[1]
      if nEvent = drgEVENT_ACTION  .and. isNumber(mp1)
        do case
        case mp1 = drgEVENT_APPEND .and. .not. ::asysact[5]
          ok := .f.

        case mp1 = drgEVENT_EDIT   .and. .not. ::asysact[7]
          ok := .f.

        case mp1 = drgEVENT_DELETE .and. .not. ::asysact[6]
          ok := .f.

        case mp1 =drgEVENT_SAVE    .and. .not. ::asysact[8]
          ok := .f.
        endcase

        if( .not. ok, (mp1 := 0, drgMSGBox('Nemáte povolenou tuto akci !')), nil)
      endif
    endif
    *
    **
    if nEvent = drgEVENT_ACTION  .and. isNumber(mp1) .and. ok
      do case
      case mp1 = misEVENT_SORT        ;  ::misDialogSort()
      case mp1 = misEVENT_FILTER      ;  ::misDialogFilter()
      case mp1 = misEVENT_KILLFILTER  ;  ::misDialogKillFilter()
      case mp1 = misEVENT_DOCUMENTS   ;  ::misDialogDocuments()
      case mp1 = misEVENT_DATACOM     ;  ::misDialogDataComunic()
      case mp1 = misEVENT_SWHELP      ;  ::misDialogSwHelp()
      case mp1 = misEVENT_BROREFRESH  ;  ::misDialogBroRefresh()
      endcase
    endif


    if (frameState := ::dialog:getFrameState())<> ::frameState
      if frameState = XBPDLG_FRAMESTAT_NORMALIZED
        ::setDisplayFocus()
      endif
      ::frameState := frameState
    endif

    obj    := NIL

    IF IsObject(oXbp:cargo)
      if oXbp:cargo:className() $ 'drgEBrowse,drgDBrowse'
         obj := oXbp:cargo
      *
      elseIf IsObject(oXbp:parent:cargo)
        IF oXbp:parent:cargo:className() $ 'drgEBrowse,drgDBrowse'
          obj := oXbp:parent:cargo
        ENDIF
      ENDIF
    ENDIF

    if(isnull(obj) .and. ::drgDialog:oform:olastdrg:className() $ 'drgEBrowse,drgDBrowse', obj := ::drgDialog:oform:olastdrg, nil)
*
**
    if isnull(obj) .and. isObject(::lastXbpInFocus) .and. nevent = drgEVENT_ACTION
      if ::lastXbpInFocus:parent:className() = 'XbpCellGroup'
        p_obj := ::lastXbpInFocus
        if isObject(p_obj:cargo)
          if p_obj:cargo:className() = 'drgEBrowse'
             obj := p_obj:cargo
            oxbp := ::lastXbpInFocus
          endif
        endif
      endif
    endif
**
*
    * Keyboard events
    IF nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        IF !_clearEventLoop(.T.)
          IF drgINI:escIsClose
            PostAppEvent(xbeP_Close,,,oXbp)
            LOOP
          ENDIF
        ENDIF

      CASE ::actionManager:shortcut(mp1)
        LOOP
      CASE ::oForm:tabPageManager:shortcut(mp1)
        LOOP
      CASE ::dialogCtrl:shortcut(mp1, oXbp)
        LOOP

*      OTHERWISE
*        oXbp:HandleEvent( nEvent, mp1, mp2 )
      ENDCASE
    ENDIF

    * test v drgDBrowse - drgEBrowse *
*    IF( IsObject(obj), IF( obj:eventHandled(nEvent,mp1,mp2,oXbp), nEvent := xbe_None, NIL ), NIL)

    if isObject(obj)
      if obj:eventHandled(nEvent,mp1,mp2,oXbp)
        nEvent := xbe_None
      endif
    endif


    DO CASE
    CASE ::dialogCtrl:eventHandled(nEvent, mp1, mp2, oXbp)
      LOOP

    * Messages from objects drawn on screen
    CASE nEvent = drgEVENT_FORMDRAWN
      ::actionManager:collect()
      ::oForm:setDisabledActions(::actionManager)
      ::dialogCtrl:setDisabledActions(::actionManager)

    * Service thread informs that action must be activated
    CASE nEvent = drgEVENT_ACTIVATE
      mp1:activate()

    * Message must be written
    CASE nEvent = drgEVENT_MSG
      IF ::oMessageBar != NIL
        ::oMessageBar:writeMessage(mp1, mp2)
      ENDIF
    OTHERWISE
      oXbp:HandleEvent(nEvent,mp1,mp2)
    ENDCASE

******************
    IF nEvent = xbeP_Close
      EXIT
    ENDIF
  ENDDO
  ::exitState := IIF(EMPTY(mp1), drgEVENT_QUIT, mp1)

RETURN

****************************************************************************
* Load new form, create controller object and UDCP
****************************************************************************
METHOD drgDialog:loadForm()
  LOCAL  cPGM, cPgmBlock, recno[3]
  local  obj := ThreadObject()
  *
  * Load form and create UDCP
  ::formName    := ALLTRIM(drgParse(::initParam))

  if .not. Empty(usrName)
    drgDBMS:open('users'  )
    drgDBMS:open('asystem')
    drgDBMS:open('asysact')

    recno[1] := asystem->( recno())
    recno[2] := asysact->( recno())
    recno[3] := users->( recno())

    if asystem->(dbseek(Upper(::formName),,'ASYSTEM07')) .and.         ;
         users->(dbseek(Upper(Padr(usrName,10)),,'USERS01'))

      do case
      case asysact->(dbseek(Upper(users->cuser)+Upper(asystem->cidobject),,'ASYSACT06'))
        ::asysact[1] := .t.
      case .not. Empty(users->cgroup) .and. asysact->(dbseek(Upper(users->cgroup)+Upper(asystem->cidobject),,'ASYSACT07'))
        ::asysact[1] := .t.
      endcase

      if ::asysact[1]
        ::asysact[4]:= asysact->lBegAct
        if ::asysact[4]
          ::asysact[5] := asysact->lNewAct
          ::asysact[6] := asysact->lDelAct
          ::asysact[7] := asysact->lModAct
          ::asysact[8] := asysact->lSavAct
        else
          RETURN .F.
        endif
      endif
    endif
    asystem->( dbgoto(recno[1]))
    asysact->( dbgoto(recno[2]))
    users->( dbgoto(recno[3]))
  endif


* Remove & and @
  IF LEFT(::formName,1) $ '&@'
    ::formName := RIGHT(::formName, LEN(::formName) - 1)  // remove leading &
  ENDIF
* UDCP exists
  cPGM := ALLTRIM(::formName)
  IF ClassObject( cPGM ) != NIL
    cPgmBlock := '{ |a| ' + cPGM + '():new(a) }'
    ::UDCP := EVAL(&cPgmBlock, self)
* Load form from UDCP if getForm method exists
    IF IsMethod( ::UDCP, 'getForm')
      ::formObject := ::UDCP:getForm()
    ENDIF
  ENDIF
* Form has not been loaded yet. Load it from FILE definition.
  IF ::formObject = NIL
*    ::formObject := drgFormManager:getForm(::formName)
    IF ( ::formObject := drgFormContainer():new():loadForm(::formName) ) = NIL
* Stil NIL. This must be an error.
      RETURN .F.
    ENDIF
  ENDIF
* Get forms header
  ::formHeader := ::formObject:getLine()
* Help filename
  if empty(::helpName)
    ::helpName := IIF(EMPTY(::formHeader:help), ::formName, ::formHeader:help)
  endif
* Create dialog controller
  IF ISDIGIT(::formHeader:dType)
    cPGM := 'drgDC' + ::formHeader:dType
  ELSE
    cPGM := ::formHeader:dType
  ENDIF
* If controler object not found set to default controller
  IF ClassObject( cPGM ) = NIL
    cPGM := 'drgDC0'
  ENDIF
  cPgmBlock    := '{ |a| ' + cPGM + '():new(a) }'
  ::dialogCtrl := EVAL(&cPgmBlock, self)
  ::dialogCtrl:isReadOnly := ::formHeader:isReadOnly
  AADD(::members, ::dialogCtrl)

  * zkusíme obnovit BRo jak si ho nadefinoval uživatel, ale musíme se vyhnout pøihlášení uživatele
  if( .not. ::isSpecFRM, ::getBroFields(), nil )
RETURN .T.


method drgDialog:getBroFields()
  local  dialogName := if(upper(::formName) = upper(::helpName), ::formName, ::helpName)
  local  cparent    := if(isNull(::parent), '',::parent:formName)
  local  ky         := upper(padr(usrName,10)) +upper(padr(cparent,50)) +upper(padr(dialogName,50))
  *
  local  sName      := drgINI:dir_USERfitm +dialogName, lenBuff, buffe
  *
  local  x, obj, file, fields
  local  pa_Frm, pa_Ini, n_it, pa_it
  *
  local  crest_Bro  := '_drgDBrowse,_drgEBrowse'
  local  ncnt := 0, members, npos, m_file := ''
  local  ok := .f.

  if(select('asysini') = 0, drgDBMS:open('asysini'), nil)

  *
  ** existují shodné FRM, ale obsahují rùzné soubory
  asysini->( ordSetFocus( 'ASYSINI02'  ), ;
             dbsetScope( SCOPE_BOTH, ky), ;
             dbgoTop()                  , ;
             dbeval( { || ncnt++ } )    , ;
             dbclearScope()               )

  if ncnt > 1
    members := ::formObject:members
    if ( npos := ascan( members, { |o| o:className() $ crest_Bro })) <> 0
      m_file := upper( padr( members[npos]:file, 10))
    endif
  endif
  **
  *

  if  asysini->(dbseek( ky +m_file,, 'ASYSINI02')) .and. isRestFRM
    if .not. empty(asysini->mbrowse)
      MemoWrit(sName,asysini->mbrowse)

      for x := 1 to len(::formObject:members) step 1
        if ::formObject:members[x]:className() $ crest_Bro   // = '_drgDBrowse'
          obj     := ::formObject:members[x]

          if obj:rest = 'y'
            file    := upper( coalesce(obj:file,::formHeader:file))
            lenBuff := 40960
            buffer  := space(lenBuff)

            GetPrivateProfileStringA('browse-' +file, 'frmColum', '', @buffer, lenBuff, sName)

            if .not. empty(fields := substr(buffer,1,len(trim(buffer))-1))
              * musíme zkontrolovat jestli sedí FRM a INI
              pa_Frm := listAsArray( strTran( ::formObject:members[x]:fields, ' ', '' ))
              pa_Ini := listAsArray( strTran( fields                        , ' ', '' ))

              do case
              case len( pa_Frm ) <> len( pa_Ini )  ;  fields := ''
              otherwise

                begin sequence
                  for n_it := 1 to len( pa_Frm ) step 1
                    pa_it := listAsArray( pa_Frm[ n_it ], ':' )

                    if ascan( pa_Ini, { |it| lower( pa_it[1] ) $ lower( it ) } ) = 0
                      fields := ''
                break
                    endif
                  next
                end sequence
              endcase

              if(.not. empty(fields), ::formObject:members[x]:fields := fields, nil)
            endif
          endif
        endif
      next

      FErase(sName)
    endif
  endif
return self


***********************************************************************
* setDisplayFocus callback for this dialog
***********************************************************************
METHOD drgDialog:setDisplayFocus()
  local ar := {}

  drgServiceThread:setActiveThread( ThreadID() )

  if ::lastXbpInFocus != NIL
    if setAppFocus() <> ::lastXbpInFocus
      do while (nEvent := AppEvent(@mp1, @mp2, @oXbp, 1) ) != xbe_None
        if nEvent < drgEVENT_MIN .OR. nEvent > drgEVENT_MAX
        else
*        if nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_MSG .or. nEvent = drgDIALOG_END
          aadd(ar, {nEvent, mp1, mp2, oXbp } )
        endif
      enddo
      aeval(ar, { |el, n| PostAppEvent(ar[n,1], ar[n,2], ar[n,3], ar[n,4] ) } )

      SetAppFocus(::lastXbpInFocus)
    endif
  ENDIF
RETURN

***********************************************************************
* killDisplayFocus callback for this dialog
***********************************************************************
METHOD drgDialog:killDisplayFocus()

*  ::lastXbpInFocus := SetAppFocus()
*  drgServiceThread:setActiveThread(0)
RETURN

***********************************************************************
* Sets this dialog window title. Must be called before create method.
*
* \b< Parameters: b\
* \b< cTitle >b\     : character  : Title
*
* \b< Returns: >b\  : Self
***********************************************************************
METHOD drgDialog:setTitle(cTitle)
  ::title := cTitle
RETURN self

***********************************************************************
* Gets control method or function for a dialog. It first checks if method \
* exists in control program which is initialized on the begining, than it checks for \
* function with the same name.
*
* \b< Parameters: b\
* \b< methodName >b\   : String  : method or function name to search
* \b< defaultName >b\  : String  : default method name if method name not defined (is NIL)
*
* \b< Returns: >b\     : block   : Code block to access the function NIL if not found.
***********************************************************************
METHOD drgDialog:getMethod(cMethodName, cDefaultName)
  DEFAULT cMethodName TO cDefaultName

  IF cMethodName != NIL
* Search for exported method within user defined object
    IF ::UDCP != NIL .AND. isMethod(::UDCP, cMethodName)
      RETURN {|a, b, c| ::UDCP:&cMethodName(a, b, c) }
    ENDIF
* Search for public defined function
    IF isFunction(cMethodName)
      RETURN &('{|a, b, c| ' + cMethodName + '(a, b, c) }')
    ENDIF
  ENDIF
RETURN NIL

***********************************************************************
* Returns variable block. Parameter name may be passed as FILE->Name or \
* object:var or array:index. Method first searches for variable in user defined class \
* and then in private or public variables. File names are searched in coresponding file.
*
* \b< Parameters: b\
* \b< cName >b\      : String  : Memory variable name to be searched
* \b< aVar >b\      : object  : Pointer to object requesting varBlock memVar:self
*
* \b< Returns: >b\  : block   : Code block to access the memory variable or NIL if not found.
***********************************************************************
METHOD drgDialog:getVarBlock(cName, oVar)
LOCAL cFldName, cFile, bBlock, oRef, nIndex, x, cc
* File field
  IF (x := AT('->', cName )) != 0
    cFile    := drgParse(cName,'-')
    cFldName := drgParseSecond(cName, '>' )
    IF !(cFile == 'M')
* Set pointer to reference
      oRef  := drgDBMS:getFieldDesc(cFile, cFldName)
      IF oVar != NIL
        oVar:ref := oRef
      ENDIF
      bBlock := FIELDWBLOCK(cFldName, cFile)
* Take care if data in file is saved in different code page
      IF drgINI:nlsCP_DATA = drgINI:nlsCP_APP .OR. oRef:type != 'C'
        RETURN bBlock
      ELSE
        RETURN {|a| IIF(a = NIL, _drgUsrCPconvert( EVAL(bBlock), .T. ), ;
                                 EVAL(bBlock, _drgUsrCPconvert(a, .F.)) ) }
      ENDIF
* Memory variable striped from ->
    ELSE
      cName := cFldName
    ENDIF
  ENDIF

* Check for normal variable
  IF (x := AT(':', cName )) = 0
* Is var in user defined class

    if at('|',cname) <> 0
       cc    := substr(cname,1,at('|',cname)-1)
       cname := substr(cname  ,at('|',cname)+1)

       if ::udcp != nil .and. ismembervar(::udcp:&cc,cname)
         return drgvarblock(@::udcp:&cc:&cname)
       endif
    endif


    IF ::UDCP != NIL .AND. isMemberVar(::UDCP, cName)
*      RETURN {|a| IIF(a=NIL, ::UDCP:&name, ::UDCP:&cName = a) }
       RETURN drgVarBlock(@::UDCP:&cName)

    ELSEIF ISMEMVAR( cName )
      RETURN MEMVARBLOCK(cName)
    ENDIF
* Return NIL if not found
    RETURN NIL
  ENDIF

* Check if VAR is in array
  cFldName := ALLTRIM(drgParse(cName,':'))
  nIndex   := ALLTRIM(drgParseSecond(cName,':'))
  IF IsDigit(nIndex)
    IF ::UDCP != NIL .AND. isMemberVar(::UDCP, cFldName)
      RETURN {|a| IIF(a=NIL, ::UDCP:&cFldName[VAL(nIndex)], ::UDCP:&cFldName[VAL(nIndex)] := a) }
    ELSEIF ISMEMVAR( cFldName )
      RETURN {|a| IIF(a=NIL, &cFldName[VAL(nIndex)], &cFldName[VAL(nIndex)] := a) }
    ENDIF
* Return NIL if not found
    RETURN NIL
  ENDIF

* Finaly check if var is in object
  IF ::UDCP != NIL .AND. isMemberVar(::UDCP, cFldName)
* If Object then call it's getset() method inside UDCP
     IF UPPER( LEFT(cFldName, 3) ) = 'OBT'
       RETURN {|a| IIF(a=NIL, ::UDCP:&(cFldName):getSet(nIndex), ::UDCP:&(cFldName):getSet(nIndex, a) ) }
* If UDCP then call UDCP:getset() method
     ELSEIF UPPER( LEFT(cFldName, 4) ) = 'UDCP'
       RETURN { |a| ::UDCP:getSet(nIndex, a) }
     ELSE
       RETURN drgVarBlock(@::UDCP:&(cFldName):&(nIndex))
     ENDIF
  ELSEIF ISMEMVAR( cFldName )
    RETURN {|a| IIF(a=NIL, &cFldName:&nIndex, &cFldName:&nIndex := a) }
  ENDIF
RETURN NIL

****************************************************************************
* Sets parameters for GUILOOK of dialog. GUILOOK parameter defines if IconBar, \
* Action bar, Menu Bar and Message bar are displayed in dilog.
****************************************************************************
METHOD drgDialog:setGUILOOK()
LOCAL defGUI, parsed, p, pKey, pVal, pUsr
* GUILOOK
  ::hasIconArea := ::hasActionArea := ::hasMenuArea := ::hasMsgArea := ::hasBorder := .T.
  IF ::formHeader:guiLook != NIL
    p := ::formHeader:guiLook
* Set default GUI if ALL keyword present at start
    parsed := drgParse(p, ',')
    pKey := LOWER( drgParse(@parsed,':') )
    pVal := LOWER( drgParse(@parsed,':') )
    IF pKey = 'all'
      defGUI := pVal == 'y'
      ::hasIconArea := ::hasActionArea := ::hasMenuArea := ::hasMsgArea := ::hasBorder := defGUI
    ENDIF
* Parse other GUI parameters
    WHILE !EMPTY(parsed := drgParse(@p, ',') )
      pKey := LOWER( drgParse(@parsed,':') )
      pVal := LOWER( drgParse(@parsed,':') )
* IF is empty pUsr must be set to NIL
      IF EMPTY( pUsr := drgParse(@parsed,':') )
        pUsr := NIL
      ENDIF

      DO CASE
      CASE pKey = 'iconbar'
        ::hasIconArea   := pVal == 'y'
        ::usrIconArea   := pUsr
      CASE pKey = 'action'
        ::hasActionArea := pVal == 'y'
      CASE pKey = 'menu'
        ::hasMenuArea   := pVal == 'y'
        ::usrMenuArea   := pUsr
      CASE pKey = 'message'
        ::hasMsgArea    := pVal == 'y'
        ::usrMsgArea    := pUsr
      CASE pKey = 'border'
        ::hasBorder     := pVal == 'y'
      ENDCASE
    ENDDO
  ENDIF
* Default GUI object names acording to controller name
  IF EMPTY(::usrIconArea) .AND. isFunction('drgIconBar'+::formHeader:dType)
    ::usrIconArea := 'drgIconBar'+::formHeader:dType
  ENDIF
*
  IF EMPTY(::usrMenuArea) .AND. isFunction('drgMenuBar'+::formHeader:dType)
    ::usrMenuArea := 'drgMenuBar'+::formHeader:dType
  ENDIF
*
  IF EMPTY(::usrMsgArea) .AND. isFunction('drgMsgBar'+::formHeader:dType)
    ::usrMenuArea := 'drgMsgBar'+::formHeader:dType
  ENDIF
RETURN

****************************************************************************
* Creates standard GUILOOK. Searches for custom menuBar, iconBar and message area \
* functions and if not found calls standard defined functions.
****************************************************************************
METHOD drgDialog:createGUILOOK(size)
LOCAL oBar, oMethod, pos

  * Create standard menu bar for dialog. Call user defined function drgINI:stdDialogMenu
  * if it exists otherwise call drgUsrDialogMenu defined inside this PRG
  IF ::hasMenuArea
    oBar := ::dialog:menuBar()
    IF (oMethod := ::getMethod(::usrMenuArea, 'drgUsrDialogMenu') ) = NIL
      oMethod := ::getMethod(drgINI:stdDialogMenu, 'drgStdDialogMenu')
    ENDIF
    EVAL( oMethod, oBar, self )
  ELSE
    ::dataAreaSize[2] += 2
  ENDIF


* Create Action area
  IF ::hasActionArea
    pos  := { size[1] + 0, 0}
    size[1] := 12*drgINI:fontW
    IF ::hasMsgArea; pos[2] += drgINI:fontH + 1; ENDIF
    ::oActionBar := drgActions():new(self)
    ::oActionBar:create(::dialog:drawingArea, pos, size)
    AADD(::members, ::oActionBar)
    ::dataAreaSize[1] += 12*drgINI:fontW
  ENDIF

* Create Message area
  IF ::hasMsgArea
* Usr defined msgArea on FORM
    IF EMPTY(::usrMsgArea) .OR. ClassObject( ::usrMsgArea ) = NIL
      ::usrMsgArea := drgINI:stdMessageBar        // Global application
      IF ClassObject( ::usrMsgArea ) = NIL
        ::usrMsgArea := 'drgMessageBar'       // Nope. Than standard.
      ENDIF
    ENDIF
    oMethod := '{ |a| ' + ::usrMsgArea + '():new(a) }'
    ::oMessageBar := EVAL(&oMethod, self)
    ::oMessageBar:create(::dialog:drawingArea)
    AADD(::members, ::oMessageBar)
    ::dataAreaSize[2] += drgINI:fontH + 1
  ENDIF

* Create icon area. Logic is same as for stdMenuArea
  IF ::hasIconArea
    IF (oMethod := ::getMethod(::usrIconArea, 'drgUsrIconBar') ) = NIL
      oMethod := ::getMethod(drgINI:stdIconBar, 'drgStdIconBar')
    ENDIF
    ::oIconBar := EVAL( oMethod, self, ::dialog:drawingArea )
    AADD(::members, ::oIconBar)
    * Size dataAreaSize
    ::dataAreaSize[2] += ::oIconBar:oBord:currentSize()[2]
  ENDIF
RETURN

****************************************************************************
* Pushes currently active area and index to dbAreaStack
****************************************************************************
METHOD drgDialog:pushArea()
  ::dbAreaIndex++
  ::dbAreaStack[::dbAreaIndex,1] := SELECT()
  ::dbAreaStack[::dbAreaIndex,2] := ORDSETFOCUS()
  ::dbAreaStack[::dbAreaIndex,3] := RECNO()
RETURN

****************************************************************************
* Pops last active area from stack
****************************************************************************
METHOD drgDialog:popArea( lRecNO)
  DEFAULT lRecNO TO .F.
  DBSELECTAREA(::dbAreaStack[::dbAreaIndex,1])
  AdsSetOrder(::dbAreaStack[::dbAreaIndex,2])
  IF lRecNO
    DBGOTO(::dbAreaStack[::dbAreaIndex,3])
  ENDIF
  ::dbAreaIndex--
RETURN

****************************************************************************
* Set dialog to readonly state
****************************************************************************
METHOD drgDialog:setReadOnly(lSet)
  DEFAULT lSet TO .T.
  IF ::dialogCtrl:isReadOnly != lSet
    ::dialogCtrl:isReadOnly := lSet
* Inform message line
    PostAppEvent(drgEVENT_MSG,,drgEVENT_FIND, ::drgDialog:dialog)
  ENDIF
RETURN


****************************************************************************
* CleanUP
****************************************************************************
METHOD drgDialog:destroy()
LOCAL x
  FOR x := LEN(::members) TO 1 STEP -1
    ::members[x]:destroy()
  NEXT
*
  IF ::UDCP != NIL
    ::UDCP:destroy()
  ENDIF
*
  IF ::formObject != NIL
    ::formObject:destroy()
  ENDIF

  ::cargo          := ;
  ::cargo_usr      := ;
  ::initParam      := ;
  ::exitState      := ;
  ::parent         := ;
  ::parentDialog   := ;
  ::dialog         := ;
  ::dialogCtrl     := ;
  ::title          := ;
  ::oBord          := ;
  ::dataAreaSize   := ;
  ::members        := ;
  ::formName       := ;
  ::helpName       := ;
  ::formObject     := ;
  ::formHeader     := ;
  ::oForm          := ;
  ::dataManager    := ;
  ::UDCP           := ;
  ::actionManager  := ;
  ::lastXbpInFocus := ;
  ::lastRECNO      := ;
  ::hasActionArea  := ;
  ::hasIconArea    := ;
  ::hasMenuArea    := ;
  ::hasMsgArea     := ;
  ::hasBorder      := ;
  ::usrIconArea    := ;
  ::usrMenuArea    := ;
  ::usrMsgArea     := ;
  ::usrPos         := ;
  ::oIconBar       := ;
  ::oActionBar     := ;
  ::oMessageBar    := ;
  ::asysact        := ;
  ::dbName         := ;
  ::act_Filter     := ;
  ::act_killFilter := ;
  ::id_act_Filter  := ;
  ::opt_act_Filter := ;
  ::master_brow    := ;
  ::a_bro_popup    := ;
  ::a_act_filtrs   := ;
  ::ostart_dialog  := ;
  ::dbAreaStack    := ;
  ::dbAreaIndex    := ;
  ::odbrowse       := NIL

RETURN

************************************************************************
************************************************************************
* drgDialogThread objects for starting threaded dialogs
************************************************************************
************************************************************************
CLASS drgDialogThread FROM Thread
EXPORTED:
  var     paFiles

PROTECTED:
  METHOD  atStart, execute, atEnd
ENDCLASS

************************************************************************
************************************************************************
METHOD drgDialogThread:atStart()
  ::paFiles      := {}
RETURN self

************************************************************************
* Execution part of thread.
*
* \bParameters:b\
* \b< formName >b\    : string    : Form name used by this dialog
* \b[ parent ]b\      : drgDialog : Reference to dialog which started new dialog
************************************************************************
METHOD drgDialogThread:execute(formName, parent, lModal)
LOCAL dialog, parentDialog := NIL
LOCAL oError, bError

  DEFAULT lModal TO .F.
*Error traping
  IF !( EMPTY(drgINI:stdErrorHandler) .OR. LOWER(drgINI:stdErrorHandler) = 'standardeh' )
    bError := ErrorBlock( &('{|e| ' + drgINI:stdErrorHandler + '(e) }') )
  ENDIF

  BEGIN SEQUENCE
  dialog := drgDialog():new(formName, parent)
* Inform parent that new dialog has started. Returns thread ID and dialog reference
  IF parent != NIL
    IF parent:isDerivedFrom( "XbpDialog" )
      parentDialog := parent
    ELSE
      parentDialog := parent:dialog
    ENDIF
    postAppEvent(drgDIALOG_START, THREADID(), dialog, parentDialog)
  ENDIF
*
*
    IF dialog:create(,,lModal) = NIL
      if .not. dialog:asysact[1]
        drgMSGBox('Dialog není definován !')
      endif
    ENDIF
*
*
*******************************
* ERROR occured
*******************************
  RECOVER using oError

    if isObject(dialog:ostart_dialog)
      if( isObject(dialog:ostart_dialog:odlg), dialog:ostart_dialog:stop(), nil)
    endif
  END SEQUENCE

  IF !EMPTY(bError)
    ErrorBlock(bError)            // establish prior error block
  ENDIF

* Inform parent that dialog has ended
  IF parentDialog != NIL
    postAppEvent(drgDIALOG_END, THREADID(),, parentDialog)
    setAppFocus(parentDialog)
  ENDIF
* Destroy dialog
  IF dialog != NIL
    dialog:destroy()
    dialog := NIL
  ENDIF
  ::setInterval( NIL )
RETURN self

***************************************************************************
***************************************************************************
METHOD drgDialogThread:atEnd( formName, parent )
  local a_alias, cargo := isNull( ::cargo, 0 )

  ::paFiles    := nil

  if 'QUERY' $ WorkSpaceList()
    a_alias := WorkSpaceList()

    aeval( a_alias, { |a| if ( 'QUERY' $ a                       , ;
                               Nil                               , ;
                               (a)->(dbCommit(), dbCloseArea() ) ) } )

*    aeval( a_alias, { |a| if ( 'QUERY' $ a                       , ;
*                               (a)->(AdsCloseTable())            , ;
*                               (a)->(dbCommit(), dbCloseArea() ) ) } )
  else
    if cargo = 0
      DBCOMMITALL()
      DBCLOSEALL()
    endif
  endif
RETURN self


***************************************************************************
* Gets or saves dialog position specified with name.
*
* \bParameters:b\
* \b< dialogName >b\    : string   : dialog name
* \b[ pos ]b\           : ARRAY[2] : array containing 2 numeric values \
* representing x and y coordinates of windows. Used only when saving dialog position.
*
* \bReturn:b\           : ARRAY[2] : array containing 2 numeric values
* representing x and y coordinates of windows. Returned only when geting position.
***************************************************************************
FUNCTION GetSaveDialogPos(cDialogName, oDialog, lGet, lOrd)
  local oReg, aVal, aPos
  *
  local helpName := odialog:cargo:helpName

  DEFAULT lOrd To .F.

  * musíme se vyhnout pøihlášení uživatele
  if .not. oDialog:cargo:isSpecFRM

    IF ISMEMVAR('drgScrPos')
      cdialogName := if(upper(cdialogName) = upper(helpName), cdialogName, helpName)

      IF lGet
        if isRestFRM
          IF (aPos := drgScrPos:getPos(cDialogName, odialog) ) = NIL
            RETURN if( .not. lOrd, _CenterPos(oDialog), NIL)
          ELSE
            RETURN aPos
          ENDIF
        endif
      ELSE
        RETURN drgScrPos:savePos(cDialogName, oDialog, lOrd)
      ENDIF
    ENDIF
  endif
RETURN _CenterPos(oDialog)


/*
  oReg := XbpReg():NEW( 'HKEY_CURRENT_USER\Software\DRG\'+drgINI:appName +'\DIALOG')
  IF ! oReg:Status()
    oReg:Create()
  ENDIF

  IF pos = NIL
    IF (aVal := oReg:getValue(dialogName) ) = NIL
      oReg:setValue(dialogName,'1,1')
    ELSE
      aPos[1] := VAL(ALLTRIM(drgParse(@aVal)) )
      aPos[2] := VAL(ALLTRIM(aVal))
    ENDIF
    RETURN aPos
  ELSE
    oReg:setValue(dialogName,STR(pos[1]) + ',' + STR(pos[2]) )
  ENDIF
RETURN drgScrPos:getPos(dialogName)
*/



*
**
STATIC CLASS start_dilalog from thread
exported:
  var  odlg, m_parent

  inline method atStart()
    ::odlg:show()

    ::setInterval(25)
  return self

  inline method execute()
    local oPS := ::ophase:lockPS()

    ::nphase := if( ::nphase +1 > 3, 1, ::nphase+1)

    ::abitmaps[::nphase]:draw( oPS, {1,1})
    ::ophase:unlockPS( oPS )

    if( isWorkVersion, ::otime:setCaption(str(seconds() - ::nstart)), nil )
  return self

  inline method stop()
     ::setInterval( NIL )
     ::synchronize( 0 )

     ::destroy()
  return self

  inline method init(parent)
    local  apos, asize
    local  nPHASe := MIS_PHASE1
    *
    local  aPPos  := AppDesktop():currentPos()
    local  aPSize := AppDesktop():currentSize()

    ::thread:init()

    ::m_parent     := parent
    ::formName     := allTrim(drgParse(parent:initParam))

    ::odlg := XbpDialog():new(AppDesktop(),,,,,.F.)

    apos   := { aPPos[1] + (aPSize[1]-( 200 +60)), aPPos[2] + (aPSize[2]-( 60 +20)) }
*    apos  := _centerPos(::odlg)
    asize := { 200, 60 }

*    apos[1] += apos[1] / 2
*    apos[2] += apos[2] / 2

    ::odlg:drawingArea:bitmap   := 1016
    ::odlg:drawingArea:options  := XBP_IMAGE_SCALED

    ::odlg:MinButton   := .F.
    ::odlg:MaxButton   := .F.
    ::odlg:HideButton  := .F.
    ::odlg:TitleBar    := .F.
    ::odlg:SysMenu     := .F.
    ::odlg:TaskList    := .F.
    ::odlg:alwaysOnTop := .T.
    ::odlg:Border      :=  XBPDLG_DLGBORDER
    ::odlg:create( ,, apos, asize )
*
    ::otext         := XbpStatic():new( ::odlg:drawingArea, , {1,20}, {200,24} )
    ::otext:caption := '... start dialogu ...'
    ::otext:setFontCompoundName( FONT_DEFPROP_MEDIUM + FONT_STYLE_BOLD )
    ::otext:options := XBPSTATIC_TEXT_VCENTER+XBPSTATIC_TEXT_CENTER

    ::otext:setColorBG(XBPSYSCLR_TRANSPARENT)
    ::otext:setColorFG(XBPSYSCLR_APPWORKSPACE)
    ::otext:create()
*
    ::ophase         := XbpStatic():new( ::odlg:drawingArea, , {85,2}, {20,20} )
    ::ophase:options := XBPSTATIC_BITMAP_TILED
    ::ophase:create()
*
    ::nstart         := seconds()

    if isWorkVersion
      ::otime          := XbpStatic():new( ::odlg:drawingArea, , {140,-5}, {60,24} )
      ::otime:options  := XBPSTATIC_TEXT_LEFT

      ::otime:setFontCompoundName( '8.Arial CE' )
      ::otime:setColorBG(XBPSYSCLR_TRANSPARENT)
      ::otime:create()
    endif

    ::abitmaps := { nil,nil,nil }
    ::nphase   := 1
    *
    ** nachystáme si vrtítko
    for i := 1 to 3 step 1
      ::abitmaps[i] := XbpBitmap():new():create()
      ::abitmaps[i]:load( ,nPHASe )
      nPHASe++
    next
  return self

  inline method show()
    ::odlg:show()
  return self

  inline method destroy()
    ::odlg:hide()
    ::odlg:destroy()

    aeval( ::abitmaps, {|o| o:destroy()} )

    ::odlg     := ;
    ::formName := ;
    ::otext    := ;
    ::abitmaps := ;
    ::ophase   := ;
    ::nphase   := ;
    ::otime    := ;
    ::nstart   := nil
  return

hidden:
  var  formName, otext, abitmaps, ophase, nphase, otime, nstart

ENDCLASS