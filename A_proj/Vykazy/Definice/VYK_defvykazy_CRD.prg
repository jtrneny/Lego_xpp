#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"



//-----+ FI_fakprihd_SCR0 +-------------------------------------------------------
CLASS VYK_defvykazy_CRD FROM drgUsrClass
EXPORTED:

  METHOD  Init

  METHOD  InFocus
  METHOD  drgDialogStart

  METHOD  postAppend

  METHOD  postValidate
  METHOD  postDelete
  METHOD  TypyNapoctu
  METHOD  CopyRecord
  METHOD  CopyItem_CRD
  METHOD  CopyVyk_CRD
  method  SelTypyNap
  method  SelTypNapHb, SelTypNapHe
  method  SelTypNapIn,SelTypNapIb,SelTypNapIe
  method  ebro_beforeAppend, ebro_afterAppend, ebro_saveEditRow

  method  destroy
  *
  method  stableBlock


  VAR     newRec


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL appFocus
    LOCAL oA
    LOCAL file, filew

    * hodnì to blbne
    if .not. ::is_showItems
      ::is_showItems := .t.
      ::obro_it:show()
    endif


    DO CASE
    CASE nEvent = drgEVENT_APPEND
*      if ::drgDialog:dialogCtrl:oaBrowse:cfile == 'C_TYPPOH'
*        ::msg:writeMessage('Pøidávat lze jen u položek úèetního pøedpisu ...',DRG_MSG_WARNING)
//        drgMSGBox('Pøidávat lze jen u položek úèetního pøedpisu ...')
*        RETURN .T.
*      else
*        RETURN .F.
*      endif

    CASE nEvent = drgEVENT_APPEND2
      file  := ::drgDialog:dialogCtrl:oaBrowse:cfile
      filew := file+'w'
      if Upper(file) == 'DEFVYKHD'
        ::CopyVyk_CRD()
        RETURN .T.
      else
        ::CopyRecord(file)
        ::drgDialog:dialogCtrl:oBrowse[2]:Refresh()
        RETURN .F.
      endif
*      if ::drgDialog:dialogCtrl:oaBrowse:cfile == 'DEFVYKHD'
*        ::msg:writeMessage('Pøidávat lze jen u položek úèetního pøedpisu ...',DRG_MSG_WARNING)
//        drgMSGBox('Pøidávat lze jen u položek úèetního pøedpisu ...')
*        RETURN .T.
*      else
*        RETURN .F.
*      endif

    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.


*    CASE nEvent = xbeP_Keyboard
*      Do Case
*      Case mp1 = xbeK_INS   ;   ::CardOfKmenMzd(.T.)
*      Case mp1 = xbeK_ENTER ;   ::CardOfKmenMzd(.F.)
*      Case mp1 = xbeK_ESC   ;   PostAppEvent(xbeP_Close,nEvent,,oXbp)
*      Otherwise
 *       RETURN .F.
 *     EndCase
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

HIDDEN:
  VAR     nFile, cFile, typVyk, idVyk, u_typDefVyk
  var     msg, dm, dc, df
  var     hd_file, it_file
  var     obro_hd, obro_it
  *
  var     is_showItems
ENDCLASS


METHOD VYK_defvykazy_CRD:Init(parent)
  local  sName   := drgINI:dir_USERfitm +userWorkDir() +'\c_opravn.mem'
  local  lenBuff := 40960, buffer := space(lenBuff), cpar

  ::drgUsrClass:init(parent)

  ( ::hd_file    := 'defvykhd', ::it_file := 'defvykit' )
  ::newRec       := .F.
  *
  ::is_showItems := .f.

  drgDBMS:open('DEFVYKHD')
  drgDBMS:open('DEFVYKIT')
  drgDBMS:open('defvykit',,,,,'defvykita')
  drgDBMS:open('DEFVYKSY')

  * c_opravn v mBlock obsahuje popis povolených nasavení pro filtr
  drgDBMS:open('c_opravn')
  c_opravn->(dbseek(syOpravneni,,'C_OPRAVN01'))
  memoWrit(sName,c_opravn->mBlock)

  getPrivateProfileStringA('DefVyk', 'CID', '', @buffer, lenBuff, sName)
  ::u_typDefVyk := substr(buffer,1,len(trim(buffer))-1)
RETURN self


METHOD VYK_defvykazy_CRD:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.

**
METHOD VYK_defvykazy_CRD:drgDialogStart(drgDialog)

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

  ::obro_hd  := drgDialog:dialogCtrl:obrowse[1]:oxbp
  ::obro_it  := drgDialog:dialogCtrl:obrowse[2]:oxbp

  ::typVyk  := ::dm:get('defvykhd->cid' , .f.)
  (::typVyk:odrg:isEdit  := .f.,::typVyk:odrg:oxbp:disable())
  (::typVyk:odrg:isedit_inrev := .f.)

  * TEST
  ::obro_hd:stableBlock := { |a| ::stableBlock(a) }
  ::obro_it:stableBlock := { |a| ::stableBlock(a) }
RETURN self


method vyk_defvykazy_crd:stableBlock(oxbp)
  local m_file, s_filter, filter
  *
  local m_filter := "lower(cidVykazu) = '%%'"

  if isobject(oxbp)
    m_file := lower(oxbp:cargo:cfile)

    oxbp:cargo:last_ok_rowPos := oxbp:rowPos
    oxbp:cargo:last_ok_recNo  := if( (m_file)->(eof()), 0, (m_file)->(recNo()) )

    do case
    case( m_file = ::hd_file )
      s_filter := (::it_file)->(ads_getAof())
      filter   := format(m_filter, {lower((::hd_file)->cidVykazu)})

      if .not. Equal( s_filter, filter )
        (::it_file)->(ads_setAof(filter), dbgoTop())
        ::obro_it:refreshAll()

      endif
    endcase
  endif

  defvyksy->(dbseek( upper( defvykit->cidSysVykn),,'DEFVYKSY03'))
return self


method VYK_defvykazy_CRD:postAppend(parent)
  local file := parent:cfile

  defvykit->cidvykazu := defvykhd->cidvykazu
  defvykit->ctask     := defvykhd->ctask
  defvykit->culoha    := defvykhd->culoha
  defvykit->ctypvykazu:= defvykhd->ctypvykazu
return


METHOD VYK_defvykazy_CRD:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := Lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .T., changed := drgVAR:Changed()
  *
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  LOCAL  lOK  := .T., pa, xval
  LOCAL  lZmPoh := .F.

  do case
  case (file = 'defvykhd')
    do case
    case item = 'cid'
      xval := newIDdefvyk(value)
      ::dm:set("defvykhd->cidvykazu", xval)
      ::dm:refresh("defvykhd->cidvykazu")
      ::dm:set("defvykhd->nid", val( strTran( xval, value, '')))

      (::typVyk:odrg:isEdit  := .f.,::typVyk:odrg:oxbp:disable())
      (::typVyk:odrg:isedit_inrev := .f.)

      ok := .not. empty(value)
    endcase

  case (file = 'defvykit')
    do case
    case item = 'nradekvyk' .and. empty(value)
      ::msg:writeMessage('Øádek výkazu je povinný údaj ...',DRG_MSG_ERROR)
      ok := .f.
    case item = 'nsloupvyk' .and. empty(value)
      ::msg:writeMessage('Sloupec výkazu je povinný údaj ...',DRG_MSG_ERROR)
      ok := .f.
    case item = 'cnazradvyk' .and. empty(value)
      ::msg:writeMessage('Název øádku výkazu je povinný údaj ...',DRG_MSG_ERROR)
      ok := .f.
    case item = 'cnazslovyk' .and. empty(value)
      ::msg:writeMessage('Název sloupce výkazu je povinný údaj ...',DRG_MSG_ERROR)
      ok := .f.
    endcase

  endcase

*-  cnazradvyk

*  do case
*  case(name = 'ucetprit->ctypuct')
*    if Empty(value)
*      ::msg:writeMessage('Typ pohybu je povinný údaj ...',DRG_MSG_ERROR)
*      lOk := .F.
*    endif
*  endcase

//  if( changed .and. lOK, ( ::onSave(), ::dm:refresh(.T.)), NIL )

RETURN ok


* ok
method VYK_defvykazy_CRD:ebro_beforeAppend(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky

  do case
  case (cfile = 'defvykhd')
  case (cfile = 'defvykit')
    ::dm:set("defvykit->cidvykazu",defvykhd->cidvykazu)
  endcase
return .t.


method VYK_defvykazy_CRD:ebro_afterAppend(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky

  do case
  case (cfile = 'defvykhd')
    ::stableBlock(o_ebro:oxbp)

  case (cfile = 'defvykit')
    ::dm:set("defvykit->cidvykazu",defvykhd->cidvykazu)
  endcase
return .t.


method VYK_defvykazy_CRD:ebro_saveEditRow(o_ebro)
  local  cfile   := lower(o_ebro:cfile), cky
  local  odata   := o_EBro:odata
  local  lnewRec := .f.

  do case
  case (cfile = 'defvykhd')
    * nový záznam defvykhd
    if empty((cfile)->nid)
      (cfile)->cidvykazu := ::dm:get("defvykhd->cidvykazu")
      (cfile)->nid       := ::dm:get("defvykhd->nid"      )
      (cfile)->culoha    := c_task->culoha
      (cfile)->ndistrib  := if( (cfile)->cid = 'DIST', 1, 0)
    endif

    (cfile)->cidsysvykb := ::dm:get("defvykhd->cidsysvykb")
    (cfile)->cidsysvyke := ::dm:get("defvykhd->cidsysvyke")

  case (cfile = 'defvykit')
    * nová položka výkazu
    if empty( (cfile)->cidvykazu)
      lnewRec := .t.

      (cfile)->cidvykazu  := defvykhd->cidvykazu
      (cfile)->ctask      := defvykhd->ctask
      (cfile)->culoha     := defvykhd->culoha
      (cfile)->ctypVykazu := defvykhd->ctypVykazu
      (cfile)->ndistrib   := defvykhd->ndistrib
    endif

    (cfile)->cidsysvykn := ::dm:get("defvykit->cidsysvykn")
    (cfile)->cidsysvykb := ::dm:get("defvykit->cidsysvykb")
    (cfile)->cidsysvyke := ::dm:get("defvykit->cidsysvyke")

    if .not. lnewRec
      if o_EBro:odata:nradekVyk <> defVykit->nradekVyk .or. ;
         o_EBro:odata:nsloupVyk <> defVykit->nsloupVyk

        o_EBro:oxbp:refreshAll()
      endif
    endif
  endcase
return


method VYK_defvykazy_CRD:postDelete()
  local  inFile    := lower(::dc:oaBrowse:cfile)
  local  cMessage  := 'Požadujete zrušit'
  local  cTitle    := 'Zrušení'
  local  cInfo     := '       ' +defvykhd->cidVykazu
  local  nsel, nodel := .f., obro
  *
  local  an_hd := {}, an_it := {}, lLock := .t.

  fordRec( {'defvykit'} )

  do case
  case( inFile = 'defvykhd' )
    obro     := ::obro_hd
    cMessage += ' definici výkazu ' + CRLF + ;
                  cInfo             + CRLF + ;
                ' vèetne položek ...'
    cTitle   += ' definice výkazu vèetnì položek ...'

    aadd( an_hd, defvykhd->( recNo()) )
    defvykit->( dbgotop(), ;
                dbeval( { || aadd(an_it, defvykit->(recNo()) ) } ) )

    lLock    := defvykhd->( sx_RLock(an_hd)) .and. ;
                defvykit->( sx_RLock(an_it))
  otherwise

    obro     := ::obro_it
    cMessage += ' položku definice výkazu ' + CRLF + ;
                  cInfo
    cTitle   += ' položky definice výkazu ...'

    aadd( an_it, defvykit->( recNo()) )
    lLock    := defvykit->( sx_RLock(an_it))
  endcase

  fordRec()

  if lLock
    nsel := ConfirmBox( , cMessage           , ;
                          cTitle             , ;
                          XBPMB_YESNO       , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      aeval( an_hd, { |x| defvykhd->( DbGoTo(x), DbDelete() ) })
      aeval( an_it, { |x| defvykit->( DbGoTo(x), DbDelete() ) })
    else
      nodel := .t.
    endif
  endif

  if nodel
    if .not. lLock
      ConfirmBox( ,'Záznamy definice výkazu'   +CRLF + ;
                    cInfo                      +CRLF + ;
                   'blokovány uživatelem ...'          , ;
                    cTitle                             , ;
                    XBPMB_CANCEL                       , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    endif
  endif

  defvykhd->(dbunlock(), dbcommit())
   defvykit->(dbunlock(), dbcommit())

  if( obro:rowPos = 1, obro:goTop(), nil )
  obro:refreshAll()
return .not. nodel




method VYK_defvykazy_CRD:SelTypNapHb(a,b,c)
  ::SelTypyNap('Hb')
return .t.

method VYK_defvykazy_CRD:SelTypNapHe()
  ::SelTypyNap('He')
return .t.


method VYK_defvykazy_CRD:SelTypNapIn()
  ::SelTypyNap('In')
return .t.

method VYK_defvykazy_CRD:SelTypNapIb()
  ::SelTypyNap('Ib')
return .t.

method VYK_defvykazy_CRD:SelTypNapIe()
  ::SelTypyNap('Ie')
return .t.


METHOD VYK_defvykazy_CRD:SelTypyNap(typ)
  LOCAL oDialog
  LOCAL dopln  := .F.
  LOCAL newpol := 0

  filtr := Format("cTypPouNap = '%%'", {Left(typ,1)})
  defvyksy->( ads_setaof(filtr), DBGoBotTom())

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYK_typynapoctu_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  ::drgDialog:popArea()                  // Restore work area

  if nExit != drgEVENT_QUIT
    do case
    case typ == 'Hb'
      ::dm:set("defvykhd->ctypnapvyb", defvyksy->ctypnapvyk)
      ::dm:set("defvykhd->cidsysvykb", defvyksy->cidsysvyk)
    case typ == 'He'
      ::dm:set("defvykhd->ctypnapvye", defvyksy->ctypnapvyk)
      ::dm:set("defvykhd->cidsysvyke", defvyksy->cidsysvyk)
    case typ == 'In'
      ::dm:set("defvykit->ctypnapvyk", defvyksy->ctypnapvyk)
      ::dm:set("defvykit->cidsysvykn", defvyksy->cidsysvyk)
    case typ == 'Ib'
      ::dm:set("defvykit->ctypnapvyb", defvyksy->ctypnapvyk)
      ::dm:set("defvykit->cidsysvykb", defvyksy->cidsysvyk)
    case typ == 'Ie'
      ::dm:set("defvykit->ctypnapvye", defvyksy->ctypnapvyk)
      ::dm:set("defvykit->cidsysvyke", defvyksy->cidsysvyk)
    endcase
  endif

  defvyksy->(ads_clearaof())

// ::dm:refresh("ucetprit->cmainfile")

RETURN self



METHOD VYK_defvykazy_CRD:CopyRecord(file)

  drgDBMS:open('defvykitw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  mh_COPYFLD('defvykit', 'defvykitw', .T.)
  ::CopyItem_CRD()

RETURN SELF


METHOD VYK_defvykazy_CRD:CopyItem_CRD()
LOCAL oDialog
*  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYK_typnapcopy_CRD' PARENT ::drgDialog MODAL DESTROY
*  ::drgDialog:popArea()                  // Restore work area
RETURN self


METHOD VYK_defvykazy_CRD:CopyVyk_CRD()
  LOCAL oDialog
  local newId

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'VYK_defvykazy_copy_CRD' PARENT ::drgDialog MODAL DESTROY
  newId := defvykhdw->cidvykazu
  ::drgDialog:popArea()

  defvykhd->( dbSeek( Upper(newId),,'DEFVYKHD03'))

RETURN self


METHOD VYK_defvykazy_CRD:TypyNapoctu()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area                  =
  DRGDIALOG FORM 'VYK_typynapoctu_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self



*
*****************************************************************
METHOD VYK_defvykazy_CRD:destroy()
  ::drgUsrClass:destroy()
RETURN self



 *  Kopírování definice výkazù
** CLASS for VYK_forms_copy_CRD *********************************************
CLASS VYK_defvykazy_copy_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  getForm
  METHOD  drgDialogStart
  METHOD  postValidate, onSave
  METHOD  destroy

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::onSave()
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
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
  VAR     dm, msg


ENDCLASS


METHOD VYK_defvykazy_copy_CRD:init(parent)
  local  filename, filedesc

  ::drgUsrClass:init(parent)
  drgDBMS:open('defvykhd',,,,,'defvykhdc')
  drgDBMS:open('defvykit',,,,,'defvykitc')
  * tady nevím jestli zap *
  drgDBMS:open('defvykhdw',.T.,.T.,drgINI:dir_USERfitm);ZAP
  drgDBMS:open('defvykitw',.T.,.T.,drgINI:dir_USERfitm);ZAP

RETURN self


METHOD VYK_defvykazy_copy_CRD:getForm()
  LOCAL drgFC
  local n
  LOCAL cVal := ''

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,5 DTYPE '10' TITLE 'Kopie definice výkazu' ;
                       GUILOOK 'All:Y,Border:Y,Action:N';
                       PRE 'preValidate' POST 'postValidate'

  DRGSTATIC INTO drgFC STYPE 14 SIZE 98,4.1 FPOS 1,0.4
  DRGTEXT INTO drgFC CAPTION 'Údaje o nové definici výkazu'  CPOS 2,0.3 CLEN 35 PP 3// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Typ výkazu'  CPOS 2,1.6 CLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGCOMBOBOX defvykhdw->cID INTO drgFC FPOS 2,2.6 FLEN 15 VALUES 'DIST:Distriuèní,USER:Uživatelský' PP 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Id výkazu'  CPOS 18,1.6 CLEN 10 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGGET defvykhdw->cIDvykazu   INTO drgFC FPOS 18,2.6 FLEN 10 PP 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Zkratka výkazu'  CPOS 31,1.6 CLEN 12 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGGET defvykhdw->cTypVykazu  INTO drgFC FPOS 31,2.6 FLEN 12 PP 2//PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Název výkazu'  CPOS 45,1.6 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGGET defvykhdw->cNazVykazu  INTO drgFC FPOS 45,2.6 FLEN 50 PP 2//PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2

RETURN drgFC


METHOD VYK_defvykazy_copy_CRD:drgDialogStart(drgDialog)
  local filtr
  local cval

  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager

  mh_COPYFLD('defvykhd', 'defvykhdw', .T.)

  filtr := Format("cIDvykazu = '%%'", {defvykhd->cIDvykazu})
  defvykitc->( ads_setaof(filtr), DBGoBotTom())

  defvykitc->(dbGoTop())
  defvykitc->( dbEval( {||mh_COPYFLD('defvykitc', 'defvykitw', .T.)}))
  defvykitc->( ads_clearaof())

  ::dm:refresh()

  cval := newIDdefvyk(defvykhd->cID)
  ::dataManager:set("defvykhdw->cidvykazu", cval)

RETURN self


METHOD VYK_defvykazy_copy_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval

  do case
  case(name = 'defvykhdw->cID')
    if !Empty( value) .and. changed
      cval := newIDdefvyk(value)
      ::dataManager:set("defvykhdw->cid", Left( cval,4))
      ::dataManager:set("defvykhdw->cidvykazu", cval)
    endif

  case(name = 'defvykhdw->cidvykazu')
    if !Empty( value) .or.  changed
      if defvykhdc->(dbSeek(Upper(value),,'DEFVYKHD03' ))
         drgNLS:msg('Pod tímto ID již výkaz existuje ...')
         lOK := .F.
      endif
    endif

  case(name = 'defvykhdw->ctypvykazu')
    if !Empty( value) .or.  changed
      if defvykhdc->(dbSeek(Upper(value),,'DEFVYKHD01' ))
         drgNLS:msg('Pod touto zkratkou již výkaz existuje ...')
         lOK := .F.
      endif
    endif

  case(name = 'defvykhdw->cnazvykazu')
    if Empty( value)
      drgNLS:msg('Název výkazu je povinný údaj ...')
      lOk := .F.
    endif

  endcase

//  if( changed .and. .not. ::changeFRM, ::changeFRM := .T., NIL)

  ** ukládáme pøi zmìnì do tmp **
//  if(lOK, ::msg:writeMessage(), NIL)
//  if( changed, ::dm:refresh(.T.), NIL )

RETURN lOk


METHOD VYK_defvykazy_copy_CRD:onSave()

  ::dm:save()
  mh_COPYFLD('defvykhdw', 'defvykhd', .T.)
  defvykhd->nID := Val(Right(defvykhdw->cidvykazu,6))

  defvykitw->(dbGoTop())
  do while .not.defvykitw->( Eof())
    defvykitw->cIDvykazu  := defvykhdw->cIDvykazu
    defvykitw->cTypVykazu := defvykhdw->cTypVykazu
    defvykitw->(dbSkip())
  enddo
  defvykitw->(dbGoTop())
  defvykitw->( dbEval( {||mh_COPYFLD('defvykitw', 'defvykit', .T.)}))

RETURN .T.


*
*****************************************************************
METHOD VYK_defvykazy_copy_CRD:destroy()
  ::drgUsrClass:destroy()
RETURN self



//-----+ FI_fakprihd_SCR0 +-------------------------------------------------------
CLASS VYK_typynapoctu_CRD FROM drgUsrClass
EXPORTED:
//  VAR     KUHRADE_vzm    // k úhradì v základní mìnì

  METHOD  Init
  METHOD  ItemMarked
  METHOD  ItemSelected
  METHOD  postValidate
*  METHOD  postAppend
  METHOD  InFocus
  METHOD  drgDialogStart
  METHOD  onSave
  method  ebro_saveEditRow

  VAR     newRec


/*
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_APPEND
      ::newRec := .T.
      UCETPRSY->(dbAppend())
      ::drgDialog:dialogCtrl:oBrowse[1]:Refresh()
      RETURN .F.
    CASE nEvent = drgEVENT_EDIT
      ::newRec := .F.

*    CASE nEvent = xbeP_Keyboard
*      Do Case
*      Case mp1 = xbeK_INS   ;   ::CardOfKmenMzd(.T.)
*      Case mp1 = xbeK_ENTER ;   ::CardOfKmenMzd(.F.)
*      Case mp1 = xbeK_ESC   ;   PostAppEvent(xbeP_Close,nEvent,,oXbp)
*      Otherwise
*        RETURN .F.
*      EndCase
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

*/

HIDDEN:
  VAR  dm, typvyk   //, msg


ENDCLASS

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD VYK_typynapoctu_CRD:Init(parent)
  ::drgUsrClass:init(parent)

  ::newRec := .F.

  drgDBMS:open('DEFVYKSY')
  DEFVYKSY->(ads_clearaof())

RETURN self


METHOD VYK_typynapoctu_CRD:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.

**
METHOD VYK_typynapoctu_CRD:drgDialogStart(drgDialog)
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr

  ::dm  := drgDialog:dataManager             // dataMabanager
  ::typVyk  := ::dm:get('defvyksy->cid' , .f.)
  (::typVyk:odrg:isEdit  := .f.,::typVyk:odrg:oxbp:disable())
  (::typVyk:odrg:isedit_inrev := .f.)

RETURN self



METHOD VYK_typynapoctu_CRD:ItemMarked()
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP

  ::drgDialog:dataManager:Refresh()    // refrešne INFO-kartu

RETURN SELF



METHOD VYK_typynapoctu_CRD:ItemSelected()
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP

*  ::drgDialog:dataManager:Refresh()    // refrešne INFO-kartu

RETURN SELF



METHOD VYK_typynapoctu_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  xval
  *
  LOCAL  lOK  := .T.


  do case
  case name = 'defvyksy->cid'
    xval := newIDdefvyksys(value)
    ::dm:set("defvyksy->cidsysvyk", xval)
    ::dm:refresh("defvyksy->cidsysvyk")
    ::dm:set("defvyksy->nid", Val(xval))
    ok := .not. empty(value)
  endcase

*  if(lOK, ::msg:writeMessage(), NIL)
*  if( changed, ::dm:refresh(.T.), NIL )
*  if( changed, ::onSave(), NIL )

RETURN lOk


method VYK_typynapoctu_CRD:ebro_saveEditRow(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky

  if Empty( defvyksy->cidsysvyk)
    defvyksy->nid        := ::dm:get("defvyksy->nid")
    defvyksy->cidsysvyk  := ::dm:get("defvyksy->cidsysvyk")
  endif

return


METHOD VYK_typynapoctu_CRD:onSave()
  LOCAL n

//  IF( .not. ::newRec, DEFVYKSY->(dbRlock()), NIL)
//  ::dm:save()
//  DEFVYKSY->(dbUnlock())

RETURN .T.


CLASS VYK_typnapcopy_CRD FROM drgUsrClass
EXPORTED:
//  VAR     KUHRADE_vzm    // k úhradì v základní mìnì

  METHOD  Init
*  METHOD  ItemMarked
*  METHOD  ItemSelected
*  METHOD  postValidate
*  METHOD  postAppend
*  METHOD  InFocus
  METHOD  drgDialogStart
  METHOD  onSave

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL appFocus

    DO CASE
    CASE nEvent = drgEVENT_EXIT
      ::onSave()
      RETURN .F.
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

*  VAR     newRec
HIDDEN:
  VAR  dm   //, msg


ENDCLASS

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD VYK_typnapcopy_CRD:Init(parent)
  ::drgUsrClass:init(parent)

*  ::newRec := .F.
   dbSelectArea('DEFVYKITw')
*  drgDBMS:open('DEFVYKSY')
*  DEFVYKSY->(ads_clearaof())

RETURN self

METHOD VYK_typnapcopy_CRD:drgDialogStart(drgDialog)

  ::dm  := drgDialog:dataManager             // dataMabanager

RETURN self

METHOD VYK_typnapcopy_CRD:onSave()
  LOCAL n

  ::dm:save()
  MH_CopyFLD( 'DEFVYKITw','DEFVYKIT',.T.)

RETURN .T.


*
********* CLASS for UCT_typyuct_SEL ********************************************
CLASS VYK_typynapoctu_SEL FROM drgUsrClass
EXPORTED:
  METHOD  drgDialogStart

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

ENDCLASS


**
METHOD VYK_typynapoctu_SEL:drgDialogStart(drgDialog)

*  if( .not. Empty(UCETPRIT->cTypUct), UCETPRSY->(dbSeek(Upper(UCETPRIT->cTypUct))),NIL)

RETURN self



FUNCTION newIDdefvyk(typ)
  local newID
  local filtr

  drgDBMS:open('defvykhd',,,,,'defvykhda')
  filtr := Format("cIDvykazu = '%%'", {typ})
  defvykhda->( AdsSetOrder('DEFVYKHD03'), ads_setaof(filtr), DBGoBotTom())
  newID := typ + StrZero( Val( SubStr(defvykhda->cIDvykazu,5,6))+1, 6)
  defvykhda->(ads_clearaof(), dbCloseArea())
RETURN(newID)


FUNCTION newIDdefvyksys(typ)
  local newID
  local filtr

  drgDBMS:open('defvyksy',,,,,'defvyksya')
  filtr := Format("cIDsysvyk = '%%'", {typ})
  defvyksya->( AdsSetOrder('DEFVYKSY03'), ads_setaof(filtr), DBGoBotTom())
  newID := typ + StrZero( Val( SubStr(defvyksya->cIDsysvyk,5,6))+1, 6)
  defvyksya->(ads_clearaof(), dbCloseArea())

RETURN(newID)