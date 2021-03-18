#include "Appevent.ch"
#include "Common.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"

#pragma Library( "XppUI2.LIB" )


*
**
CLASS SYS_filtrs_SCR FROM drgUsrClass, sys_filtrs
EXPORTED:
  var     bro
  method  init, getForm, drgDialogStart
  method  flt_export, flt_import, flt_copy, flt_verify

  * na filtritw
  inline access assign method ised_cvyraz_2() var ised_cvyraz_2
    return if(filtritw->lnoedt_2, MIS_NO_RUN, 0 )

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_APPEND2
      if( oXbp:ClassName() <> 'XbpCheckBox', ::flt_copy(), NIL)
      Return .T.
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.

    endcase
  return .f.

HIDDEN:
  VAR     msg, dm, pushOk
  method  postDelete
ENDCLASS


method sys_filtrs_scr:init(parent)
  ::drgUsrClass:init(parent)

  ::aitw := {}

  drgDBMS:open('fltusers')

  drgDBMS:open('FILTRSw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('FILTRITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
return self


method sys_filtrs_scr:getForm()
  local drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 102,25 DTYPE '10'             ;
                     TITLE 'Seznam definovaných filtrù' ;
                     GUILOOK 'All:Y,Border:Y,Action:Y'  ;
                     CARGO 'SYS_filtrs_IN'

  DRGDBROWSE INTO drgFC FPOS 0.5,0.1 SIZE 102,11.4 FILE 'FILTRS'    ;
    FIELDS 'M->is_complet::2.7::2,'      + ;
           'M->opt_level::2.7::2,'       + ;
           'CFLTNAME:Název filtru:60,'   + ;
           'cTASK:úloha:10,'             + ;
           'cMAINFILE:hlavní soubor:10,' + ;
           'CIDFILTERS:ID_filtru:17'       ;
            ITEMMARKED 'itemMarked' ITEMSELECTED 'itemSelected'  CURSORMODE 3 PP 7 POPUPMENU 'yy'

  DRGDBROWSE INTO drgFC FPOS 0.5,11.8 SIZE 102,13.2 FILE 'FILTRITw' ;
    FIELDS 'CLGATE_1:(,'             + ;
           'CLGATE_2:(,'             + ;
           'CLGATE_3:(,'             + ;
           'CLGATE_4:(,'             + ;
           'CFILE_1:table:9,'        + ;
           'CVYRAZ_1u:výraz-L:24,'   + ;
           'CRELACE:oper:6.5,'       + ;
           'CVYRAZ_2u:výraz-P:24,'   + ;
           'M->ised_cvyraz_2::2::2,' + ;
           'CFILE_2:table:9,'        + ;
           'CRGATE_1:),'             + ;
           'CRGATE_2:),'             + ;
           'CRGATE_3:),'             + ;
           'CRGATE_4:),'             + ;
           'COPERAND::7'               ;
            SCROLL 'ny' CURSORMODE 3 PP 7 HEADMOVE 'n'

  DRGAction INTO drgFC CAPTION '~Export' EVENT 'flt_export' TIPTEXT 'Export filtrù'
  DRGAction INTO drgFC CAPTION '~Import' EVENT 'flt_import' TIPTEXT 'Import filtrù'

  #ifdef WORK_VERSION
    DRGAction INTO drgFC CAPTION '~Kontrola' EVENT 'flt_verify' TIPTEXT 'Kontrola nastavého filtr'
  #endif
return drgFC


method sys_filtrs_scr:drgDialogStart(drgDialog)
  ::bro := drgDialog:oDBrowse[1]

  ::sys_filtrs:init(drgDialog)
return self


method sys_filtrs_scr:flt_export()
  local  cfile, lok := .t.
  local  arSel := if(len(::bro:arSelect) =0, {filtrs->(recNo())}, ::bro:arSelect)
  local  cmess := 'Výstupní soubor ', csubs := 'Chcete ho pøepsat ?', nsel
  *
  local  astru, nrecs

  if .not. empty(cfile := selFile('filtrs_exp','adt'))
    if file(cfile)
      cmess += cfile +' již existuje ...'
      nsel  := ConfirmBox( ,cmess +chr(13)+chr(10) +csubs  , ;
                           'Výstupní soubor již existuje ...' , ;
                            XBPMB_YESNOCANCEL                 , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)
      lok := (nsel = XBPMB_RET_YES)
    endif

    if lok
      astru := filtrs->(dbStruct())
      nrecs := filtrs->(recNo())

      dbCreate( cfile, astru, oSession_free)
      dbUseArea(.T., oSession_free, cfile, 'fileexp', .F.)

      aEval(arSel, {|x| (filtrs->(dbgoTo(x)), mh_copyFld('filtrs','fileexp',.t.,,,.f.)) })
      fileexp->(dbcloseArea())

      filtrs->(dbgoTo(nrecs))
      ConfirmBox( ,'Expotr vybraných položek filtrù je uložen v ' +cfile +' ...', ;
                   'Export filtrù byl dokonèen ...' , ;
                   XBPMB_CANCEL                     , ;
                   XBPMB_INFORMATION+XBPMB_APPMODAL+XBPMB_MOVEABLE )
    endif
  endif
return self


method sys_filtrs_scr:flt_import()
  local  cfile, lok := .t.
  local  cmess := 'Nastavený filtr ', csubs := 'Chcete ho pøepsat ?', nsel
  *
  local  nrecs := filtrs->(recNo())

  if .not. empty(cfile := selFile('filtrs_exp','adt'))
    dbuseArea(.t., oSession_free, cfile, 'fileimp', .f.)

    do while .not. fileimp->(eof())
      nsel := 0
      if filtrs->(dbseek(upper(fileimp->cidFilters),, AdsCtag(1) ))
        nsel := ConfirmBox(,cmess +alltrim(filtrs->cfltName) +' již existuje ...' +chr(13)+chr(10) +csubs, ;
                            'Vybraný filtr již existuje ...' , ;
                            XBPMB_YESNO                      , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

        if(nsel = XBPMB_RET_YES)
          if(filtrs->(dbRlock()), (mh_copyFld('fileimp','filtrs',.f.),filtrs->(dbUnlock())), nil)
        endif
      else
        mh_copyFld('fileimp','filtrs',.t.)
      endif

      fileimp->(dbskip())
    enddo

    fileimp->(dbcloseArea())
    filtrs ->(dbgoTo(nrecs))

    ConfirmBox( ,'Iport vybraných položek filtrù ze souboru ' +cfile +' byl dokonèen ...', ;
                 'Import filtrù byl dokonèen ...' , ;
                  XBPMB_CANCEL                    , ;
                  XBPMB_INFORMATION+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif
return self


method SYS_filtrs_scr:flt_copy()
  local oDialog

  ::drgDialog:pushArea()

  DRGDIALOG FORM 'SYS_filtrs_copy' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
RETURN self


method SYS_filtrs_scr:flt_verify()
  local  oDialog
  local  cfile := allTrim(filtrs->cmainFile)
  local  oini  := flt_setcond():new(.f.,.f.)


  drgDBMS:open(cfile)

  optLevel := (cfile)->(ads_evalAOF(oini:ft_cond))

  if filtrs->(dbrlock())
*---    filtrs->noptLevel := if( optLevel = 1, 6003, if( optLevel = 2, 6004, 6005))

    filtrs->(dbunlock())

    ::bro:oxbp:refreshCurrent()
  endif


/*
  ::drgDialog:pushArea()

  DRGDIALOG FORM 'SYS_filtrs_verify' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
*/
RETURN self


method sys_filtrs_scr:postDelete()
  local  nsel, nodel := .f.

  if .not. fltusers->(dbseek( upper( filtrs->cidFilters),,'FLTUSERS05'))
    nsel := ConfirmBox( ,'Požadujete rušit definici filtru->' +allTrim(filtrs->cfltName) +'_', ;
                         'Zrušení definice filtru ...'                , ;
                          XBPMB_YESNO                                 , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, ;
                          XBPMB_DEFBUTTON2                              )

    if nsel = XBPMB_RET_YES
      if( filtrs->(dbRlock()), (filtrs->(dbDelete()), nodel := .f.), nodel := .t.)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Definici filtru _' +allTrim(filtrs->cfltName) +'_' +' nelze zrušit ...', ;
                 'Zrušení definice filtru ...' , ;
                 XBPMB_CANCEL                  , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  filtrs->(dbUnlock())
  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel



*  Kopírování filtru
** CLASS for SYS_filtrs_copy ***************************************************
CLASS SYS_filtrs_copy FROM drgUsrClass
EXPORTED:
  method  init, getForm, drgDialogInit, drgDialogStart, postValidate
  method  doSave

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::doSave()
      RETURN .t.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
        RETURN .F.
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR     dm, msg, m_bro

ENDCLASS


method SYS_filtrs_copy:init(parent)
  local  typ

  ::drgUsrClass:init(parent)

  ::m_bro := parent:parent:udcp:bro
  typ     := defaultDisUsr('Filtrs', 'DEFAULTOPR')

  filtrsW->(flock(), dbZap())
  mh_copyFld('filtrs', 'filtrsW', .T.)
  *
  newIDfiltrs(typ)

//  filtrsW->ctypFiltrs := 'USER'
//  filtrsW->cidFilters := newIDfiltrs('USER')
//  filtrsW->cfltName   := filtrs->cfltName
return self


method SYS_filtrs_copy:getForm()
  local  drgFC, odrg
  local  defOpr

  drgFC  := drgFormContainer():new()
  defOpr := defaultDisUsr( 'Filtrs', 'CTYPFILTRS')

  DRGFORM INTO drgFC SIZE 100,5.1 DTYPE '10' TITLE '' GUILOOK 'All:N,Border:Y' ;
                                                      PRE 'preValidate'        ;
                                                      POST 'postValidate'

    DRGSTATIC INTO drgFC FPOS .2,0 SIZE 99.9,3.9 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION ' Vytvoøit kopii vybraného filtru ...' ;
                         CPOS  .1,0 CLEN 96.8 FONT 5 BGND 12
      odrg:groups  := 'HEAD'

      DRGTEXT INTO drgFC CAPTION 'Typ filtru'           CPOS  2,1.4 CLEN 15
      DRGTEXT INTO drgFC CAPTION 'Id filtru'            CPOS 20,1.4 CLEN 21
      DRGTEXT INTO drgFC CAPTION 'Název filtru'         CPOS 45,1.4 CLEN 20

      DRGCOMBOBOX FILTRSw->CTYPFILTRS INTO drgFC FPOS  2,2.4 FLEN 15 VALUES defOpr PP 2
      DRGGET      FILTRSw->CIDFILTERS INTO drgFC FPOS 20,2.4 FLEN 20 PP 2
      DRGGET      FILTRSw->CFLTNAME   INTO drgFC FPOS 45,2.4 FLEN 50 PP 2
    DRGEND  INTO drgFC

  DRGPUSHBUTTON INTO drgFC CAPTION '      ~Ulož';
                           POS 70,4             ;
                           SIZE 15,1.1          ;
                           ATYPE 3              ;
                           ICON1 101            ;
                           ICON2 201            ;
                           EVENT 'doSave' TIPTEXT 'Ulož kopii filtru'
  DRGPUSHBUTTON INTO drgFC CAPTION '    ~Storno';
                           POS 85,4             ;
                           SIZE 15,1.1          ;
                           ATYPE 3              ;
                           ICON1 102            ;
                           ICON2 202            ;
                           EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'

  DRGPUSHBUTTON INTO drgFC POS 97,0             ;
                           SIZE 3,1.1           ;
                           ATYPE 1              ;
                           ICON1 146            ;
                           ICON2 246            ;
                           EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
RETURN drgFC


method SYS_filtrs_copy:drgDialogInit(drgDialog)
  local  ocolumN, aPos, aRect, nW, nY
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog
  *
  local  obro := ::m_bro:oxbp

  XbpDialog:titleBar := .F.

  if IsObject(obro)
    ocolumN := obro:getColumn(2)
    aRect   := ocolumN:dataArea:cellRect(obro:rowPos)
    nW      := (aRect[4] -aRect[2])

    aa := ::m_bro:oxbp:rowCount
    bb := ::m_bro:oxbp:rowPos

    nY      := (::m_bro:oxbp:rowCount - ::m_bro:oxbp:rowPos) * nW

    aPos    := mh_GetAbsPosDlg(ocolumN:dataArea,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1] +2,aPos[2] +2 +nY -19}
  endif
return


method SYS_filtrs_copy:drgDialogStart(drgDialog)
  local  x, odrg, members := drgDialog:oForm:aMembers

  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager

   for x := 1 to len(members) step 1
     odrg := members[x]
     if(odrg:className() = 'drgText' .and. odrg:groups = 'HEAD')
       odrg:oxbp:setColorBG(GraMakeRGBColor({53, 189, 255}))
     endif
   next

  ::dm:refresh()
return self


METHOD SYS_filtrs_copy:postValidate(drgVar)
  local  name  := Lower(drgVar:name)
  local  value := drgVar:get(), changed := drgVAR:changed()
  *
  local  lok   := .t., cval

  do case
  case(name = 'filtrsw->ctypfiltrs')
    if changed
      cval := newIDfiltrs(value)
      ::dataManager:set("filtrsw->cidfilters", cval)
    endif

  case(name = 'filtrsw->cidfilters')
    if !Empty( value) .or.  changed
      if filtrs->(dbSeek(Upper(value),, AdsCtag(1) ))
         drgNLS:msg('Pod tímto ID již filtr existuje ...')
         lOK := .F.
      endif
    endif

  case(name = 'filtrsw->cfltname')
    if Empty( value)
      drgNLS:msg('Název filtru je povinný údaj ...')
      lOk := .F.
    endif
  endcase
RETURN lOk


METHOD SYS_filtrs_copy:doSave()
  ::dm:save()

  mh_COPYFLD('FILTRSw', 'FILTRS', .T.)
  filtrs->ncisfiltrs := Val(Right(filtrsw->cidfilters,6))

  postAppEvent(xbeP_Close,,,::drgDialog:dialog)
RETURN .T.