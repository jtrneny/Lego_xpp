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
CLASS SYS_komunikace_SCR FROM drgUsrClass
EXPORTED:
  var     bro
  method  init, getForm, drgDialogStart
  method  kom_copy, kom_verify

  * na filtritw
  inline access assign method ised_cvyraz_2() var ised_cvyraz_2
    return if(datkomitw->lnoedt_2, MIS_NO_RUN, 0 )

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_APPEND2
      if( oXbp:ClassName() <> 'XbpCheckBox', ::kom_copy(), NIL)
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


method sys_komunikace_scr:init(parent)
  ::drgUsrClass:init(parent)

//  drgDBMS:open('fltusers')

  drgDBMS:open('komusers')

  drgDBMS:open('datkomhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('datkomitw',.T.,.T.,drgINI:dir_USERfitm); ZAP
return self


method sys_komunikace_scr:getForm()
  local drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 102,25 DTYPE '10'             ;
                     TITLE 'Seznam definovaných komunikací' ;
                     GUILOOK 'All:Y,Border:Y,Action:Y'  ;
                     CARGO 'SYS_komunikace_IN'

  DRGDBROWSE INTO drgFC FPOS 0.5,0.1 SIZE 102,11.4 FILE 'datkomhd'    ;
    FIELDS 'cnazdatkom:Název dat_kom:60,'   + ;
           'cTASK:úloha:10,'                + ;
           'czkrdatkom:zkratka:12,'         + ;
           'ciddatkom:ID_datkom:17,'        + ;
           'cmainfile:hlavní soubor:12,'    + ;
           'cattr1:rozlišovací atribut:15'    ;
            ITEMMARKED 'itemMarked' ITEMSELECTED 'itemSelected'  CURSORMODE 3 PP 7 POPUPMENU 'yy'

//           'M->is_complet::2.7::2,'      + ;
//           'M->opt_level::2.7::2,'       + ;


  DRGDBROWSE INTO drgFC FPOS 0.5,11.8 SIZE 102,13.2 FILE 'datkomit' ;
    FIELDS 'cnazdatkom:Název dat_kom:60,'   + ;
           'cTASK:úloha:10,'             + ;
           'cmainfile:hlavní soubor:10,' + ;
           'ciddatkom:ID_datkom:17'       ;
            ITEMMARKED 'itemMarked' ITEMSELECTED 'itemSelected'  CURSORMODE 3 PP 7 POPUPMENU 'yy'
//      SCROLL 'ny' CURSORMODE 3 PP 7 HEADMOVE 'n'

//  DRGAction INTO drgFC CAPTION '~Export' EVENT 'flt_export' TIPTEXT 'Export filtrù'
//  DRGAction INTO drgFC CAPTION '~Import' EVENT 'flt_import' TIPTEXT 'Import filtrù'

//    FIELDS 'M->is_complet::2.7::2,'      + ;
//           'M->opt_level::2.7::2,'       + ;


  #ifdef WORK_VERSION
    DRGAction INTO drgFC CAPTION '~Kontrola' EVENT 'kom_verify' TIPTEXT 'Kontrola nastavené komunikace'
  #endif
return drgFC


method sys_komunikace_scr:drgDialogStart(drgDialog)
  ::bro := drgDialog:oDBrowse[1]
//  ::sys_komunikace:init(drgDialog)
return self


method SYS_komunikace_scr:kom_copy()
  local oDialog

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SYS_komunikace_copy' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
RETURN self


method SYS_komunikace_scr:kom_verify()
  local  oDialog
  local  cfile := allTrim(filtrs->cmainFile)
  local  oini  := flt_setcond():new(.f.,.f.)


/*
  drgDBMS:open(cfile)

  optLevel := (cfile)->(ads_evalAOF(oini:ft_cond))

  if filtrs->(dbrlock())

    filtrs->(dbunlock())

    ::bro:oxbp:refreshCurrent()
  endif
*/

RETURN self


method sys_komunikace_scr:postDelete()
  local  nsel, nodel := .f.

  if .not. komusers->(dbseek( upper( datkomhd->CIDDatKom),,'KOMUSERS04'))
    nsel := ConfirmBox( ,'Požadujete rušit definici komunikace->' +allTrim(datkomhd->cNazDatKom) +'_', ;
                         'Zrušení definice komunikace ...'                , ;
                          XBPMB_YESNO                                 , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, ;
                          XBPMB_DEFBUTTON2                              )

    if nsel = XBPMB_RET_YES
      if( datkomhd->(dbRlock()), (datkomhd->(dbDelete()), nodel := .f.), nodel := .t.)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Definici komunikace _' +allTrim(datkomhd->cdatkomName) +'_' +' nelze zrušit ...', ;
                 'Zrušení definice komunikace ...' , ;
                 XBPMB_CANCEL                  , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  datkomhd->(dbUnlock())
  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel



*  Kopírování datové komunikace
** CLASS for SYS_komunikace_copy ***************************************************
CLASS SYS_komunikace_copy FROM drgUsrClass
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


method SYS_komunikace_copy:init(parent)
  local typ

  typ := defaultDisUsr('Komunik','DefaultOpr')

  ::drgUsrClass:init(parent)

  ::m_bro := parent:parent:udcp:bro

  drgDBMS:open('datkomhd',,,,,'datkomhdc')

  datkomhdW->(flock(), dbZap())
  mh_copyFld('datkomhd', 'datkomhdW', .T.)
  *

  datkomhdw->cid        := typ
  datkomhdw->ciddatkom  := newIDdatcom(typ)
  datkomhdw->nid        := Val( Right( datkomhdw->ciddatkom, 6))
  datkomhdw->cnazdatkom := datkomhd->cnazdatkom
return self


method SYS_komunikace_copy:getForm()
  local  drgFC, odrg
  local  defOpr


  drgFC  := drgFormContainer():new()
  defOpr := defaultDisUsr('Komunik','CID')

  DRGFORM INTO drgFC SIZE 100,5.1 DTYPE '10' TITLE '' GUILOOK 'All:N,Border:Y' ;
                                                      PRE 'preValidate'        ;
                                                      POST 'postValidate'

    DRGSTATIC INTO drgFC FPOS .2,0 SIZE 99.9,3.9 STYPE XBPSTATIC_TYPE_RAISEDBOX
      DRGTEXT INTO drgFC CAPTION ' Vytvoøit kopii vybrané definice ...' ;
                         CPOS  .1,0 CLEN 96.8 FONT 5 BGND 12
      odrg:groups  := 'HEAD'

      DRGTEXT INTO drgFC CAPTION 'Typ dat_kom'           CPOS  2,1.4 CLEN 15
      DRGTEXT INTO drgFC CAPTION 'Id dat_kom'            CPOS 19,1.4 CLEN 10
      DRGTEXT INTO drgFC CAPTION 'Zkr dat_kom'           CPOS 31,1.4 CLEN 10
      DRGTEXT INTO drgFC CAPTION 'Název dat kom'         CPOS 45,1.4 CLEN 20

      DRGCOMBOBOX datkomhdw->cid INTO drgFC FPOS  2,2.4 FLEN 15 VALUES defOpr PP 2
      DRGGET      datkomhdw->ciddatkom INTO drgFC FPOS 19,2.4 FLEN 10 PP 2
      DRGGET      datkomhdw->czkrdatkom INTO drgFC FPOS 32,2.4 FLEN 10 PP 2
      DRGGET      datkomhdw->cnazdatkom  INTO drgFC FPOS 45,2.4 FLEN 50 PP 2
    DRGEND  INTO drgFC

  DRGPUSHBUTTON INTO drgFC CAPTION '      ~Ulož';
                           POS 70,4             ;
                           SIZE 15,1.1          ;
                           ATYPE 3              ;
                           ICON1 101            ;
                           ICON2 201            ;
                           EVENT 'doSave' TIPTEXT 'Ulož kopii datové komunikace'
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


method SYS_komunikace_copy:drgDialogInit(drgDialog)
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


method SYS_komunikace_copy:drgDialogStart(drgDialog)
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


METHOD SYS_komunikace_copy:postValidate(drgVar)
  local  name  := Lower(drgVar:name)
  local  value := drgVar:get(), changed := drgVAR:changed()
  *
  local  lok   := .t., cval

  do case
  case(name = 'datkomhdw->cid')
    if changed
      cval := newIDdatcom(value)
      ::dataManager:set("datkomhdw->ciddatkom", cval)
    endif

  case(name = 'datkomhdw->ciddatkom')
    if !Empty( value) .or.  changed
      if datkomhdc->(dbSeek(Upper(value),, 'DatKomH01'))
        MsgBox( 'Pod tímto ID již datová komunikace existuje ...')
        lOK := .F.
      endif
    endif

  case(name = 'datkomhdw->czkrdatkom')
    if !Empty( value) .or.  changed
      if datkomhdc->(dbSeek(Upper(value),, 'DatKomH02'))
        MsgBox( 'Tato zkratka je již použita. Zadejte jinou ...', 'CHYBA...' )
        lOK := .F.
      endif
    endif

  case(name = 'datkomhdw->cnazdatkom')
    if Empty( value)
      MsgBox( 'Název datové komunikace je povinný údaj ...')
      lOk := .F.
    endif
  endcase
RETURN lOk


METHOD SYS_komunikace_copy:doSave()
  ::dm:save()

  mh_COPYFLD('datkomhdw', 'datkomhd', .T.)
  postAppEvent(xbeP_Close,,,::drgDialog:dialog)
RETURN .T.