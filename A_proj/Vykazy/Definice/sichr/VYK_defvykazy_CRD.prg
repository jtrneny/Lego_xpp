#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


//-----+ FI_fakprihd_SCR0 +-------------------------------------------------------
CLASS VYK_defvykazy_CRD FROM drgUsrClass
EXPORTED:
//  VAR     KUHRADE_vzm    // k �hrad� v z�kladn� m�n�

  METHOD  Init
  METHOD  ItemMarked1
  METHOD  ItemMarked2
//  METHOD  ItemSelected
  METHOD  InFocus
  METHOD  drgDialogStart
  METHOD  onSave
  METHOD  postAppend
  METHOD  preValidate
  METHOD  postValidate
  METHOD  postDelete
  METHOD  TypyNapoctu
  METHOD  CopyRecord
  METHOD  CopyItem_CRD
  METHOD  Copy_CRD
  method  SelTypyNap
  method  SelTypNapHb, SelTypNapHe
  method  SelTypNapIn,SelTypNapIb,SelTypNapIe
  method  ebro_beforeAppend, ebro_afterAppend, ebro_saveEditRow
  method  comboBoxInit
  method  destroy
  *
//   method  stableBlock


  VAR     newRec


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL appFocus
    LOCAL oA
    LOCAL file, filew

    DO CASE
    CASE nEvent = drgEVENT_APPEND
*      if ::drgDialog:dialogCtrl:oaBrowse:cfile == 'C_TYPPOH'
*        ::msg:writeMessage('P�id�vat lze jen u polo�ek ��etn�ho p�edpisu ...',DRG_MSG_WARNING)
//        drgMSGBox('P�id�vat lze jen u polo�ek ��etn�ho p�edpisu ...')
*        RETURN .T.
*      else
*        RETURN .F.
*      endif
    CASE nEvent = drgEVENT_APPEND2
      file  := ::drgDialog:dialogCtrl:oaBrowse:cfile
      filew := file+'w'
      if file == 'DEFVYKHD'
        ::copy_CRD()
        RETURN .T.
      else
        ::CopyRecord(file)
        ::drgDialog:dialogCtrl:oBrowse[2]:Refresh()
        RETURN .F.
      endif
*      if ::drgDialog:dialogCtrl:oaBrowse:cfile == 'DEFVYKHD'
*        ::msg:writeMessage('P�id�vat lze jen u polo�ek ��etn�ho p�edpisu ...',DRG_MSG_WARNING)
//        drgMSGBox('P�id�vat lze jen u polo�ek ��etn�ho p�edpisu ...')
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
  var     obro_hd, obro_it

ENDCLASS

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD VYK_defvykazy_CRD:Init(parent)
  local  sName   := drgINI:dir_USERfitm +userWorkDir() +'\c_opravn.mem'
  local  lenBuff := 40960, buffer := space(lenBuff), cpar

  ::drgUsrClass:init(parent)

  ::newRec := .F.
  ::dm     := ::drgDialog:dataManager             // dataMabanager

  drgDBMS:open('DEFVYKHD')
  drgDBMS:open('DEFVYKIT')
  drgDBMS:open('defvykit',,,,,'defvykita')
  drgDBMS:open('DEFVYKSY')

  * c_opravn v mBlock obsahuje popis povolen�ch nasaven� pro filtr
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
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

  ::obro_hd  := drgDialog:dialogCtrl:obrowse[1]:oxbp
  ::obro_it  := drgDialog:dialogCtrl:obrowse[2]:oxbp

  ::typVyk  := ::dm:get('defvykhd->cid' , .f.)
  (::typVyk:odrg:isEdit  := .f.,::typVyk:odrg:oxbp:disable())
  (::typVyk:odrg:isedit_inrev := .f.)

//  ::idVyk   := ::dm:get('defvykhd->cidvykazu' , .f.)

 * TEST
//  ::obro_hd:stableBlock := { |a| ::stableBlock(a) }
//  ::obro_it:stableBlock := { |a| ::stableBlock(a) }
RETURN self


// method vyk_defvykazy_crd:stableBlock(oxbp)
//  xx := 123
// return self


METHOD VYK_defvykazy_CRD:ItemMarked1(a,b,c,newflt)
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP

  default newflt to .F.

  if isObject(dc:oaBrowse)
    if dc:oaBrowse:cFile == "DEFVYKHD" .or. newflt
      cFiltr := Format("Lower(cIDVYKAZU) = '%%'",{Lower(DEFVYKHD->cIDVYKAZU)})
      DEFVYKIT->(ads_setaof(cFiltr), dbGoTop())
    endif

    cFiltr := Format("Lower(CIDSYSVYK) = '%%'", {Lower(DEFVYKIT->CIDSYSVYKN)})
    DEFVYKSY->(ads_setaof( cFiltr), dbGoTop())
  endif

RETURN SELF



METHOD VYK_defvykazy_CRD:ItemMarked2()
  Local  cFiltr

  cFiltr := Format("Lower(CIDSYSVYK) = '%%'", {Lower(DEFVYKIT->CIDSYSVYKN)})
  DEFVYKSY->(ads_setaof( cFiltr), dbGoTop())

RETURN SELF


method VYK_defvykazy_CRD:postAppend(parent)
  local file := parent:cfile

  defvykit->cidvykazu := defvykhd->cidvykazu
  defvykit->ctask     := defvykhd->ctask
  defvykit->culoha    := defvykhd->culoha
  defvykit->ctypvykazu:= defvykhd->ctypvykazu


return


method VYK_defvykazy_CRD:comboBoxInit(drgComboBox)
/*
  local  cname      := lower(drgComboBox:name)
  local  acombo_val := {}, ok := .f., x, obj, task, isTask := .f., pa, pos
  *
  local  values := drgDBMS:dbd:values
  local  dm     := drgComboBox:drgDialog:dataManager

  do case
  case(cname = 'defvykhd->cid')
    ok := .t.
    pa := listAsArray(::u_typDefVyk,';')

    for x := 1 to len(pa) step 1
      pos := at(':',pa[x])
      aadd(acombo_val, { subStr(pa[x],1,pos-1), substr(pa[x],pos+1) })
    next

  endcase

  if ok
    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * mus�me nastavit startovac� hodnotu *
    drgComboBox:value := drgComboBox:ovar:value
  endif
*/
return self


METHOD VYK_defvykazy_CRD:preValidate(drgVar)
  local lOk := .T.
  local cFiltr


  xx := 1
*  if lower(drgVar:name) = 'ucetprit->npoluctpr' .and. ::dm:get("ucetprit->npoluctpr") == 0
*    ::dm:set("ucetprit->npoluctpr",    UCETPRIT->(Ads_GetRecordCount())+1)
*  endif

RETURN lOk


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
      ::dm:set("defvykhd->nid", Val(xval))

      (::typVyk:odrg:isEdit  := .f.,::typVyk:odrg:oxbp:disable())
      (::typVyk:odrg:isedit_inrev := .f.)

      ok := .not. empty(value)
    endcase

  case (file = 'defvykit')
    do case
    case item = 'nradekvyk' .and. empty(value)
      ::msg:writeMessage('��dek v�kazu je povinn� �daj ...',DRG_MSG_ERROR)
      ok := .f.
    case item = 'nsloupvyk' .and. empty(value)
      ::msg:writeMessage('Sloupec v�kazu je povinn� �daj ...',DRG_MSG_ERROR)
      ok := .f.
    case item = 'cnazradvyk' .and. empty(value)
      ::msg:writeMessage('N�zev ��dku v�kazu je povinn� �daj ...',DRG_MSG_ERROR)
      ok := .f.
    case item = 'cnazslovyk' .and. empty(value)
      ::msg:writeMessage('N�zev sloupce v�kazu je povinn� �daj ...',DRG_MSG_ERROR)
      ok := .f.
    endcase

  endcase

*-  cnazradvyk

*  do case
*  case(name = 'ucetprit->ctypuct')
*    if Empty(value)
*      ::msg:writeMessage('Typ pohybu je povinn� �daj ...',DRG_MSG_ERROR)
*      lOk := .F.
*    endif
*  endcase

//  if( changed .and. lOK, ( ::onSave(), ::dm:refresh(.T.)), NIL )

RETURN ok


METHOD VYK_defvykazy_CRD:onSave()
RETURN .T.


* ok
method VYK_defvykazy_CRD:ebro_beforeAppend(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky

  do case
  case (cfile = 'defvykhd')
//    ::itemMarked1()
//    ::obro_it:refreshAll()
//    ::stableBlock(o_ebro:oxbp)
*---    ::itemMarked( ,,o_ebro:oxbp)


  case (cfile = 'defvykit')
    ::dm:set("defvykit->cidvykazu",defvykhd->cidvykazu)

  endcase

return .t.


method VYK_defvykazy_CRD:ebro_afterAppend(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky

//    ::stableBlock(o_ebro:oxbp)
*---    ::itemMarked( ,,o_ebro:oxbp)

return .t.


method VYK_defvykazy_CRD:ebro_saveEditRow(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky

  do case
  case (cfile = 'defvykhd')
    if empty((cfile)->cidvykazu)
      (cfile)->nid        := ::dm:get("defvykhd->nid")
      (cfile)->cidvykazu  := ::dm:get("defvykhd->cidvykazu")
    endif
    (cfile)->cidsysvykb := ::dm:get("defvykhd->cidsysvykb")
    (cfile)->cidsysvyke := ::dm:get("defvykhd->cidsysvyke")

//   if (::hd_file)->ncisprocen = 0
//      cky := strZero(::typProCen:value,5)
//      procenhd_w->(AdsSetOrder('PROCENHD02'), dbsetScope(SCOPE_BOTH,cky), dbgoBottom())
//
//      (::hd_file)->ncisprocen := procenhd_w->ncisprocen+1
//    endif

  case (cfile = 'defvykit')
    (cfile)->cidsysvykn := ::dm:get("defvykit->cidsysvykn")
    (cfile)->cidsysvykb := ::dm:get("defvykit->cidsysvykb")
    (cfile)->cidsysvyke := ::dm:get("defvykit->cidsysvyke")

  endcase

return


method VYK_defvykazy_CRD:postDelete()
  local  nsel, nodel := .f.
  *
  local  pa_it := {}

  if .not. Empty( defvykhd->cidvykazu)
    nsel := ConfirmBox( ,'Po�adujete zru�it definici v�kazu', ;
                         'Zru�en� definice v�kazu ...' , ;
                          XBPMB_YESNO                            , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES

      cFiltr := Format("Lower(cIDVYKAZU) = '%%'",{Lower(DEFVYKHD->cIDVYKAZU)})
      defvykita->(ads_setaof(cFiltr), dbGoTop())

      defvykita->(dbeval( { || aadd(pa_it, defvykita->(recNo()) ) } ))

      if defvykhd->( sx_RLock()) .and. defvykit->( sx_Rlock( pa_it))
        aeval( pa_it, {|x| defvykit->(dbgoto(x), dbdelete()) } )
        defvykhd->(dbdelete())
      endif

      defvykhd->(dbunlock(), dbcommit())
      defvykit->(dbunlock(), dbcommit())

/*
      do while .not. defvykita->(Eof())
        if( defvykita->( dbRlock()), (defvykita->( dbDelete()), defvykita->( dbUnlock())),nil)
        defvykita->( dbSkip())
      enddo
      if( defvykhd->( dbRlock()), (defvykhd->( dbDelete()), defvykhd->( dbUnlock())),nil)
      defvykhd->( dbDelete())

      defvykita->( dbCloseArea())
*      sys_pripominky_cpy(self)
*      nodel := .not. sys_pripominky_del(self)
*/

    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Definici v�kazu _' +alltrim(defvykhd->cidvykazu) +'_' +' nelze zru�it ...', ;
                 'Zru�en� definice v�kazu ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
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


METHOD VYK_defvykazy_CRD:copy_CRD()
  LOCAL oDialog

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'VYK_defvykazy_copy_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()

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



 *  Kop�rov�n� definice v�kaz�
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
  * tady nev�m jestli zap *
  drgDBMS:open('defvykhdw',.T.,.T.,drgINI:dir_USERfitm);ZAP
  drgDBMS:open('defvykitw',.T.,.T.,drgINI:dir_USERfitm);ZAP

  mh_COPYFLD('defvykhd', 'defvykhdw', .T.)

  filtr := Format("cIDvykazu = '%%'", {defvykhd->cIDvykazu})
  defvykitc->( ads_setaof(filtr), DBGoBotTom())

  defvykitc->(dbGoTop())
  defvykitc->( dbEval( {||mh_COPYFLD('defvykitc', 'defvykitw', .T.)}))
  defvykitc->( ads_clearaof())

RETURN self


METHOD VYK_defvykazy_copy_CRD:getForm()
  LOCAL drgFC
  local n
  LOCAL cVal := ''

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,5 DTYPE '10' TITLE 'Kopie definice v�kazu' ;
                       GUILOOK 'All:Y,Border:Y,Action:N';
                       PRE 'preValidate' POST 'postValidate'

  DRGSTATIC INTO drgFC STYPE 14 SIZE 98,4.1 FPOS 1,0.4
  DRGTEXT INTO drgFC CAPTION '�daje o nov� definici v�kazu'  CPOS 2,0.3 CLEN 35 PP 3// FCAPTION 'Distribu�n� hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Typ v�kazu'  CPOS 2,1.6 CLEN 15 // FCAPTION 'Distribu�n� hodnota' CPOS 1,2
   DRGCOMBOBOX defvykhdw->cID INTO drgFC FPOS 2,2.6 FLEN 15 VALUES 'DIST:Distriu�n�,USER:U�ivatelsk�' PP 2 //PUSH osoby// FCAPTION 'Distribu�n� hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Id v�kazu'  CPOS 18,1.6 CLEN 10 // FCAPTION 'Distribu�n� hodnota' CPOS 1,2
   DRGGET defvykhdw->cIDvykazu   INTO drgFC FPOS 18,2.6 FLEN 10 PP 2 //PUSH osoby// FCAPTION 'Distribu�n� hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Zkratka v�kazu'  CPOS 31,1.6 CLEN 12 // FCAPTION 'Distribu�n� hodnota' CPOS 1,2
   DRGGET defvykhdw->cTypVykazu  INTO drgFC FPOS 31,2.6 FLEN 12 PP 2//PUSH osoby// FCAPTION 'Distribu�n� hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'N�zev v�kazu'  CPOS 45,1.6 CLEN 20 // FCAPTION 'Distribu�n� hodnota' CPOS 1,2
   DRGGET defvykhdw->cNazVykazu  INTO drgFC FPOS 45,2.6 FLEN 50 PP 2//PUSH osoby// FCAPTION 'Distribu�n� hodnota' CPOS 1,2

RETURN drgFC


METHOD VYK_defvykazy_copy_CRD:drgDialogStart(drgDialog)

  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager

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
      ::dataManager:set("defvykhdw->cid", cval)
    endif

  case(name = 'defvykhdw->cidvykazu')
    if !Empty( value) .or.  changed
      if defvykhdc->(dbSeek(Upper(value),,'DEFVYKHD03' ))
         drgNLS:msg('Pod t�mto ID ji� v�kaz existuje ...')
         lOK := .F.
      endif
    endif

  case(name = 'defvykhdw->ctypvykazu')
    if !Empty( value) .or.  changed
      if defvykhdc->(dbSeek(Upper(value),,'DEFVYKHD01' ))
         drgNLS:msg('Pod touto zkratkou ji� v�kaz existuje ...')
         lOK := .F.
      endif
    endif

  case(name = 'defvykhdw->cnazvykazu')
    if Empty( value)
      drgNLS:msg('N�zev v�kazu je povinn� �daj ...')
      lOk := .F.
    endif

  endcase

//  if( changed .and. .not. ::changeFRM, ::changeFRM := .T., NIL)

  ** ukl�d�me p�i zm�n� do tmp **
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
//  VAR     KUHRADE_vzm    // k �hrad� v z�kladn� m�n�

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

  ::drgDialog:dataManager:Refresh()    // refre�ne INFO-kartu

RETURN SELF



METHOD VYK_typynapoctu_CRD:ItemSelected()
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP

*  ::drgDialog:dataManager:Refresh()    // refre�ne INFO-kartu

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
//  VAR     KUHRADE_vzm    // k �hrad� v z�kladn� m�n�

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