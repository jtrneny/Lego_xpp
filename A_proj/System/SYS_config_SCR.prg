#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


// CONFIGIT06 - UPPER(CTASK)+UPPER(CITEM)+IF(EMPTY(DPLATN_OD),"        ",DTOS(DPLATN_OD))
function COLsysVAL()
  local  cretVal := ''
  local  cKy     := Upper(CONFIGHD->cTask) +Upper(CONFIGHD->cItem) +dtoS(configHD->dPlatn_OD)

  if configit->(dbSeek( cky,, 'CONFIGIT06'))
    cretVal := configit->cvalue
  endif
return cretVal

// CONFIGUS06 - UPPER(CTASK)+UPPER(CITEM)+UPPER(CUSER)+IF(EMPTY(DPLATN_OD),"        ",DTOS(DPLATN_OD))
function COLusrVAL()
  local  cretVal := ''
  local  cky     := Upper(CONFIGHD->cTask) +Upper(CONFIGHD->cItem) +Upper(Users->cUser) +dtoS(configHD->dPlatn_OD)

  if configus->(dbSeek( cky,, 'CONFIGUS06'))
    cretVal := configus->cvalue
  endif
return cretVal


**
** CLASS for SYS_config_scr *************************************************
CLASS SYS_config_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  itemMarked, itemSelected
  METHOD  postValidate
  METHOD  getForm
  METHOD  onSave
  METHOD  postLastField

  VAR     sysVal, usrVal

  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected()
      return .T.

*    CASE nEvent = drgEVENT_APPEND
*      ::itemSelected(.T.)
*      Return .T.
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

  inline method comboBoxInit(drgComboBox)
    local  cname      := lower(drgParseSecond(drgComboBox:name,'>'))
    local  ctask
    local  acombo_val := {}
    local  pa         := ::pa_usersTask

    do case
    case ( cname = 'sel_ctask' )
      if( .not. empty(::sel_ctask) .and. empty(pa), drgComboBox:oxbp:disable(), nil )

      if empty(pa)
        aadd( acombo_val, {  ''                                                      , ;
                             '         _ komletní seznam parametrù'                    } )
      endif

      c_task->( dbgotop())
      do while .not. c_task->( eof())
        ctask := upper(c_task->ctask)

        if config_ts->( dbseek( ctask,,'CONFIGHD04'))
          if     empty(pa)
            aadd( acombo_val,{ c_task->ctask,c_task->ctask +' _ ' +c_task->cnazulohy } )

          elseif ascan( pa, { |x| upper(x) = ctask }) <> 0
            aadd( acombo_val,{ c_task->ctask,c_task->ctask +' _ ' +c_task->cnazulohy } )
          endif
        endif
        c_task->( dbskip())
      enddo

      drgComboBox:oXbp:clear()
      drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
      aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

      * musíme nastavit startovací hodnotu *
      drgComboBox:value := drgComboBox:ovar:value := ::sel_ctask
    endcase
  return self

  inline method comboItemSelected(drgComboBox)
    local  cname := lower(drgParseSecond(drgComboBox:name,'>'))
    local  cfilr

    if cname = 'sel_ctask'
      if drgComboBox:value <> ::sel_ctask
        ::sel_ctask := drgComboBox:value

        cFiltr := Format("UPPER(cTASKtm) = '%%'", { UPPER(::sel_ctask)})
        confighd->( ADS_SetAOF( cFiltr), dbgoTop() )

        ::oabro[1]:oxbp:forceStable()
        ::oabro[1]:oxbp:refreshAll()
        ::dm:refresh()

        PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
        SetAppFocus(::oabro[1]:oXbp)
      endif
    endif
  return .t.


  inline method drgDialogEnd(drgDialog)
    ::msg   := ;
    ::dm    := ;
    ::dc    := ;
    ::df    := ;
    ::oabro := ;
    ::udcp  := NIL

    if( .not. empty(confighd->( ads_getAof())), confighd->(ads_clearaof()), nil )
  return self

HIDDEN:
* sys
  var     msg, dm, dc, df, oabro, udcp
  var     typ, sel_ctask, pa_usersTask, is_configus


ENDCLASS


METHOD SYS_config_CRD:init(parent)
  LOCAL cFiltr, cParm

  ::drgUsrClass:init(parent)

  if lower(parent:parent:formName) = 'sys_users_scr'
    ::pa_usersTask := asort( parent:parent:udcp:pa_usersTask )
  else
    ::pa_usersTask := {}
  endif

  cParm         := drgParseSecond(::drgDialog:initParam)
  ::typ         := cParm
  ::sel_ctask   := if( .not. Empty(::typ) .and. ::typ <> 'USER', ::typ, '' )
  ::is_configus := ( .not. Empty(::typ) .or. ::typ =  'USER' )

  ::sysVal := ''
  ::usrVal := ''

  drgDBMS:open( 'c_task' )
  drgDBMS:open( 'confighd',,,,,'config_ts')

  drgDBMS:open('CONFIGHD')
  drgDBMS:open('CONFIGIT')
  drgDBMS:open('CONFIGUS')

  dbSelectAREA('CONFIGIT')

  if .not. Empty(::typ) .and. ::typ <> 'USER'
    cFiltr := Format("UPPER(cTASKtm) = '%%'", { UPPER(::typ)})
    confighd->( ADS_SetAOF( cFiltr) )

  elseif ::typ = 'USER' .and. len(::pa_usersTask) <> 0
    ::typ       := ::pa_usersTask[1]
    ::sel_ctask := ::typ

    cFiltr := Format("UPPER(cTASKtm) = '%%'", { UPPER(::typ)})
    confighd->( ADS_SetAOF( cFiltr) )
  endif
RETURN SELF


METHOD SYS_config_CRD:getForm()
  LOCAL odrg, drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 115,22 DTYPE '10' TITLE 'Konfigurace parametrù systému' GUILOOK 'All:Y,Border:Y,Action:N'

* Browser definition
//  if .not. Empty(::typ)  // typ FIN,SKL,PRO ... nebo USER

  if ::is_configus         // typ FIN,SKL,PRO ... nebo USER
    DRGDBROWSE INTO drgFC FPOS .2,1.5 SIZE 115,12.5 FILE 'CONFIGHD'               ;
               FIELDS 'CTASK:úloha:10,'                                         + ;
               'CNAME:Název parametru:25,'                                      + ;
               'DPLATN_OD:Platnost OD:13,'                                      + ;
               'CVALUE:Hodnota - Distribuce:25,'                                + ;
               'COLsysVAL():Hodnota - Systém:25,'                               + ;
               'COLusrVAL():Hodnota - Uživatel:25,'                             + ;
               'DPLATN_DO:Platnost DO:13'                                         ;
                ITEMMARKED 'itemMarked' ITEMSELECTED 'itemSelected' SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'yy'

      DRGSTATIC INTO drgFC FPOS .2,.1 SIZE 114.6,1.3 STYPE 12 RESIZE 'yn'
        odrg:ctype := 2

        DRGSTATIC INTO drgFC FPOS 83, .15 SIZE 30, 1.2 RESIZE 'nx'
          DRGCOMBOBOX M->sel_ctask INTO drgFC FPOS 0,0 FLEN 30 VALUES 'a,a,a,a,a,a,a'  ;
                                   COMBOINIT 'comboBoxInit' ITEMSELECTED 'comboItemSelected'
        DRGEND INTO drgFC
      DRGEND INTO drgFC

      DRGTABPAGE INTO drgFC CAPTION 'Parametr' SIZE 114,7.5 OFFSET 1,82 TTYPE 3 FPOS 0.5,14.2 PRE 'tabSelect' TABHEIGHT .8 RESIZE 'yx'
        DRGSTATIC INTO drgFC FPOS .8,.3 SIZE 112,5.8 STYPE XBPSTATIC_TYPE_RECESSEDRECT RESIZE 'yx'
          odrg:ctype := 2

         DRGTEXT INTO drgFC CAPTION 'Název parametru'  CPOS 1,0.4 CLEN 25
           DRGTEXT CONFIGHD->cNAME INTO drgFC CPOS 30,0.4 CLEN 80 PP 3 BGND 13 FONT 5

         DRGTEXT INTO drgFC CAPTION 'Distribuèní hodnota'  CPOS 1,1.6 CLEN 25
           DRGTEXT CONFIGHD->cVALUE INTO drgFC CPOS 30,1.6 CLEN 80 PP 3 BGND 13 FONT 5

         DRGTEXT INTO drgFC CAPTION 'Firemní hodnota'  CPOS 1,2.8 CLEN 25
           DRGTEXT M->sysVAL INTO drgFC CPOS 30,2.8 CLEN 80 BGND 13 FONT 5

         DRGTEXT INTO drgFC CAPTION 'Uživatelská hodnota'  CPOS 1,4.3 CLEN 25
           DRGGET M->usrVAL INTO drgFC FPOS 30,4.3 FLEN 79 POST 'postLastField'

        DRGEND INTO drgFC
      DRGEND INTO drgFC

      DRGTABPAGE INTO drgFC CAPTION 'Metodika' SIZE 114,7.5 OFFSET 16,68 TTYPE 3 FPOS 0.5,14.2 PRE 'tabSelect' TABHEIGHT .8  RESIZE 'yx'
        DRGMLE CONFIGHD->mMetodika INTO drgFC FPOS .8,.3 SIZE 112.1,6 POST 'postLastField' RESIZE 'yx'
        odrg:ronly := .t.
      DRGEND INTO drgFC
      DRGEND INTO drgFC

    else

      DRGDBROWSE INTO drgFC FPOS .2,1.5 SIZE 115,12.5 FILE 'CONFIGHD'             ;
        FIELDS 'CTASK:úloha:10,'                                                + ;
               'CNAME:Název parametru:25,'                                      + ;
               'DPLATN_OD:Platnost OD:13,'                                      + ;
               'CVALUE:Hodnota - Distribuce:38,'                                + ;
               'COLsysVAL():Hodnota - Systém:38,'                               + ;
               'DPLATN_DO:Platnost DO:13'                                         ;
                ITEMMARKED 'itemMarked' ITEMSELECTED 'itemSelected' SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'yy'

      DRGSTATIC INTO drgFC FPOS .2,.1 SIZE 114.6,1.3 STYPE 12 RESIZE 'yn'
        odrg:ctype := 2

        DRGSTATIC INTO drgFC FPOS 83, .15 SIZE 30, 1.2 RESIZE 'nx'
          DRGCOMBOBOX M->sel_ctask INTO drgFC FPOS 0,0 FLEN 30 VALUES 'a,a,a,a,a,a,a'  ;
                                   COMBOINIT 'comboBoxInit' ITEMSELECTED 'comboItemSelected'
         DRGEND INTO drgFC
      DRGEND INTO drgFC

      DRGTABPAGE INTO drgFC CAPTION 'Parametr' SIZE 114,7.5 OFFSET 1,82 TTYPE 3 FPOS 0.5,14.2 PRE 'tabSelect' TABHEIGHT .8  RESIZE 'yx'
        DRGSTATIC INTO drgFC FPOS .8,.3 SIZE 112.5,5.8 STYPE XBPSTATIC_TYPE_RECESSEDRECT RESIZE 'yx'
          odrg:ctype := 2

          DRGTEXT INTO drgFC CAPTION 'Název parametru'  CPOS 1,0.8 CLEN 25
            DRGTEXT CONFIGHD->cNAME INTO drgFC CPOS 30,0.8 CLEN 80 PP 3 BGND 13 FONT 5

          DRGTEXT INTO drgFC CAPTION 'Distribuèní hodnota'  CPOS 1,2 CLEN 25
            DRGTEXT CONFIGHD->cVALUE INTO drgFC CPOS 30,2 CLEN 80 PP 3 BGND 13  FONT 5

          DRGTEXT INTO drgFC CAPTION 'Firemní hodnota'  CPOS 1,4.0 CLEN 25
            DRGGET M->sysVAL INTO drgFC FPOS 30,4.0 FLEN 79 POST 'postLastField'

        DRGEND INTO drgFC
      DRGEND INTO drgFC

      DRGTABPAGE INTO drgFC CAPTION 'Metodika' SIZE 114,7.5 OFFSET 16,68 TTYPE 3 FPOS 0.5,14.2 PRE 'tabSelect' TABHEIGHT .8 RESIZE 'yx'
        DRGMLE CONFIGHD->mMetodika INTO drgFC FPOS .8,.3 SIZE 112.1,5.8 POST 'postLastField' RESIZE 'yx'
        odrg:ronly := .t.
      DRGEND INTO drgFC
      DRGEND INTO drgFC

    endif

  DRGEND  INTO drgFC
RETURN drgFC


METHOD SYS_config_CRD:drgDialogStart(drgDialog)
  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  ::oabro    := drgDialog:dialogCtrl:obrowse

  ::udcp     := drgDialog:parent:udcp
RETURN self


METHOD SYS_config_CRD:itemMarked()

  ::usrVal := if( ::is_configus, COLusrVAL(), '' )
  ::sysVal := COLsysVAL()
RETURN self


METHOD SYS_config_CRD:itemSelected()

  if ::is_configus
    ::drgDialog:oForm:setNextFocus('M->usrVAL',, .T. )
  else
    ::drgDialog:oForm:setNextFocus('M->sysVAL',, .T. )
  endif
RETURN self


METHOD SYS_config_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL lOK := .T.

  if( changed, ::onSave(), NIL)
RETURN lOk


METHOD SYS_config_CRD:postLastField()
  ::onSave()
RETURN .T.


METHOD SYS_config_CRD:onSave()
  LOCAL  val, file, cKy := Upper( CONFIGHD->cTask) +Upper( CONFIGHD->cItem)

  ::dm:save()

  do case
  case ::is_configus
    ( val := ::usrVal , file := 'CONFIGUS')
    cKy := Upper( Users->cUser) +dtoS(configHD->dPlatn_OD)

  otherwise
    ( val := ::sysVal , file := 'CONFIGIT')
    cKy += dtoS(configHD->dPlatn_OD)
  endcase

  if (file)->( dbSeek( cKy,, AdsCtag(6) ))
    (file)->(dbRlock())
  else
    mh_CopyFLD('CONFIGHD', file, .T.)
    if( .not. Empty(::typ), (file)->cUser := Upper( Users->cUser), nil)
  endif

  (file)->cValue := val
  if( Empty((file)->cValue), (file)->(dbDelete()), NIL)
  (file)->(dbUnlock())

RETURN .T.