#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "dll.ch"
#include "dbstruct.ch"
#include "dmlb.ch"
*
#include "..\Asystem++\Asystem++.ch"

static function setCursorPos( nX, nY)
  DllCall( "user32.dll", DLL_STDCALL, "SetCursorPos", nX, nY)
return nil

static function getWindowPos(o)
   LOCAL nLeft       := 0
   LOCAL nTop        := 0
   LOCAL nRight      := 0
   LOCAL nBottom     := 0
   LOCAL cBuffer     := Space(16)
   LOCAL aObjPosXY   := {nil,nil}

   DllCall("User32.DLL", DLL_STDCALL,"GetWindowRect", o:GetHwnd(), @cBuffer)

   nLeft    := Bin2U(substr(cBuffer,  1, 4))
   nTop     := Bin2U(substr(cBuffer,  5, 4))
   nRight   := Bin2U(substr(cBuffer,  9, 4))
   nBottom  := Bin2U(substr(cBuffer, 13, 4))

   aObjPosXY[1]  := nLeft
   aObjPosXY[2]  := nTop  //AppDeskTop():currentSize()[2] - nBottom
RETURN(aObjPosXY)



*
** class MZD_vyucDane_imp *****************************************************
class MZD_vyucDane_imp from drgUsrClass
  exported:
  method  drgDialogInit, drgDialogStart, drgDialogEnd
  method  mzd_import_vypDan

  *
  ** BRO column
  inline access assign method c_Vyuctovani() var c_Vyuctovani
    return if( empty(vyucDane->cprepNedop), vyucDane->cKVR_danbo, vyucDane->cprepNedop)

  inline access assign method n_Hodnota() var n_Hodnota
    return (vyucDane->nprepNedop +vyucDane->nKVR_danbo) - vyucDane->nZuctovano
//    return if( empty(vyucDane->nprepNedop), vyucDane->nKVR_danbo, vyucDane->nprepNedop)

  inline method init(parent)
    ::drgUsrClass:init(parent)

    ::nrok           := uctOBDOBI:MZD:NROK
    ::nobdobi        := uctOBDOBI:MZD:NOBDOBI
    ::cobdobi        := uctOBDOBI:MZD:COBDOBI
    ::cfg_lauKmStroj := sysConfig( "Mzdy:lAuKmStroj")

    drgDBMS:open( 'msPrc_mo',,,,, 'msPrc_moW' )
    drgDBMS:open( 'mzdDavhd' )
    drgDBMS:open( 'mzdDavit' )
    drgDBMS:open( 'mzdDavit',,,,, 'mzdDavitS' )
    drgDBMS:open( 'druhyMzd' )
  return self


  inline method getForm()
    local oDrg, drgFC := drgFormContainer():new()

    DRGFORM INTO drgFC SIZE 92,20 DTYPE '10' TITLE 'Roèní vyúètování danì z pøíjmu ...' ;
                                             FILE 'vyucDane'                            ;
                                             GUILOOK 'IconBar:n,Menu:n,Action:n,Message:y,Border:Y'

    DRGDBROWSE INTO drgFC FPOS 0,0.1 SIZE 92,17.8 FILE 'vyucDane' ;
      FIELDS 'nosCisPrac:osÈíslo,'                                  + ;
             'cjmenoRozl:Pøíjmení_jméno a rozlišení pracovníka:30,' + ;
             'crodCisPra:rodnÈíslo,'                                + ;
             'M->c_Vyuctovani:vyúètování:20,'                       + ;
             'M->n_Hodnota:hodnota:10,'                             + ;
             'nDZD_celk:dílèíZákl_celk,'                            + ;
             'nzaklDane:záklDanì,'                                  + ;
             'nvypocDan:vypoèDaò,'                                  + ;
             'nUSZ_celk:úhrnSrZá'                                     ;
      SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'

    DRGSTATIC INTO drgFC FPOS .2,18.25 SIZE 91.6,1.6 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
      odrg:ctype := 2

      DRGPUSHBUTTON INTO drgFC CAPTION '   ~Ok'    ;
                               POS 63,.3           ;
                               SIZE 13,1.1         ;
                               ATYPE 3             ;
                               ICON1 429           ;
                               ICON2 430           ;
                               EVENT 'mzd_import_vypDan' TIPTEXT 'Generuj podklady pro zpracování mezd ...'

      DRGPUSHBUTTON INTO drgFC CAPTION '   ~Storno' ;
                               POS 77,.3            ;
                               SIZE 13,1.1          ;
                               ATYPE 3              ;
                               ICON1 102            ;
                               ICON2 202            ;
                               EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
    DRGEND  INTO drgFC
  return drgFC


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

    do case
    case nEvent = drgEVENT_EDIT
      _clearEventLoop()
      ::drgDialog:oform:setNextFocus(::opb_import_vypDan,.t.,.t.)

      apos_pb  := getWindowPos( ::opb_import_vypDan:oxbp  )
      asize_pb := ::opb_import_vypDan:oxbp:currentSize()
      apos     := { apos_pb[1] +asize_pb[1]/2, apos_pb[2] +asize_pb[2]/2 }

      setCursorPos( apos[1], apos[2] )
      setAppFocus( ::opb_import_vypDan:oxbp )
      return .f.

    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    case nEvent = drgEVENT_APPEND
    case nEvent = drgEVENT_FORMDRAWN
      Return .T.

    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        RETURN .F.
      endcase

    otherwise
      RETURN .F.
    endcase
  RETURN .T.

  hidden:
  var  nrok, nobdobi, cobdobi, cfg_lauKmStroj
  var  oDBro_main, xbp_therm, opb_import_vypDan

  inline method copyfldto_w(from_db,to_db,app_db)
    local  npos, xval, afrom := (from_db)->(dbstruct()), x
    *
    local  citem

    if(isnull(app_db,.f.),(to_db)->(dbappend()),nil)
    for x := 1 to len(afrom) step 1
      citem := to_Db +'->' +(to_Db)->(fieldName(x))

      if .not. (lower(afrom[x,DBS_NAME]) $ 'nmzda,_nrecor,_delrec,nautogen')
        xval := (from_db)->(fieldget(x))
        npos := (to_db)->(fieldpos(afrom[x,DBS_NAME]))

        if(npos <> 0, (to_db)->(fieldput(npos,xval)), nil)
      endif
    next
  return nil

endclass


method MZD_vyucDane_imp:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*  XbpDialog:titleBar := .F.
return


method MZD_vyucDane_imp:drgDialogStart(drgDialog)
  local  x, members := drgDialog:oForm:aMembers
  local  cf := "nrok = %% .and. " + ;
               "((nprepNedop +nKVR_danBo) > 0 .and. " + ;
               "(nprepNedop +nKVR_danBo) > if( Empty(nZuctovano), 0, nZuctovano ))"
  local  cfilter

  ::oDBro_main := drgDialog:dialogCtrl:oBrowse[1]
  ::xbp_therm  := drgDialog:oMessageBar:msgStatus

  for x := 1 to len(members) step 1
    if members[x]:classname() = 'drgPushButton'
      if isCharacter( members[x]:event )
        if( members[x]:event = 'mzd_import_vypDan', ::opb_import_vypDan := members[x], nil)
      endif
    endif
  next

 cfilter := format( cf, { ::nrok-1 } )
 ::drgDialog:set_prg_filter( cfilter, 'vyucDane', .t.)
return self


method MZD_vyucDane_imp:drgDialogEnd(drgDialog)

  msPrc_moW->( dbcloseArea())
   mzdDavitS->( dbcloseArea())
return self


method MZD_vyucDane_imp:mzd_import_vypDan()
  local  arecs  := {}, nhodnota := 0
  local  nrecCnt, nkeyCnt, nkeyNo := 1
  local  zuctovano
  local  key_cp
  local  lok
  local  cerror := 'Zamìstnanci mimo stav - bez aktivního prac.vztahu' + CRLF

  * pro bìžné poøízení
  drgDBMS:open('MZDDAVHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('MZDDAVITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  do case
  case ::oDBro_main:is_selAllRec
    vyucDane->( dbgoTop())

  case len( ::oDBro_main:arSelect) <> 0
    fordRec( {'vyucDane'} )

    for x := 1 to len( ::oDBro_main:arSelect) step 1
      vyucDane->( dbgoTo( ::oDBro_main:arSelect[x]))
      aadd( aRecs, vyucDane->( recNo()) )
    next
    fordRec()
    vyucDane->( ads_setAof(".f."), ads_customizeAof( aRecs,1), dbgoTop() )

  otherWise
    aadd( aRecs, vyucDane->( recNo()) )
    vyucDane->( ads_setAof(".f."), ads_customizeAof( aRecs,1), dbgoTop() )
  endcase

  mzdDavhdw->( dbappend())
  mzdDavitw->( dbappend())

  nrecCnt := vyucDane->( ads_getKeyCount(1))
  nkeyCnt := nrecCnt

  do while .not. vyucDane->( eof())

//    msPrc_moW->( dbseek( vyucDane->nMSPRC_MO,, 'ID'))
    key_cp := StrZero(::nrok,4)+StrZero(::nobdobi,2)+StrZero(vyucDane->nOsCisPrac,5)

    do case
    case msPrc_moW->( dbseek( key_cp +'1' +'HLAVNI',, 'MSPRMO27',.t.))    ;  lok := .t.
    case msPrc_moW->( dbseek( key_cp +'1',, 'MSPRMO27',.t.))              ;  lok := .t.
    case msPrc_moW->( dbseek( key_cp +'1',, 'MSPRMO28',.t.))              ;  lok := .t.
    otherwise
      if  msPrc_moW->( dbseek( key_cp,, 'MSPRMO01',.t.))
        cerror += key_cp +' '+msPrc_moW->cjmenorozl + CRLF
      else
        cerror += key_cp +' tento klíè neexistuje' + CRLF
      endif
      lok := .f.
    endcase

//    case msPrc_moW->( dbseek( key_cp,, 'MSPRMO01',.t.))

    if lok
      ::copyFldto_W( 'msPrc_moW', 'mzdDavhdw' )
      *
      ** naplníme hlavièku
      mzdDavhdw ->ctask      := 'MZD'
      mzdDavhdw ->culoha     := "M"
      mzdDavhdw ->cdenik     := 'MS'
      mzdDavhdw ->nRok       := ::nrok
      mzdDavhdw ->nObdobi    := ::nobdobi
      mzdDavhdw ->cObdobi    := ::cobdobi
      mzdDavhdw ->nRokObd    := (mzdDavhdw ->nROK *100)+mzdDavhdw ->nOBDOBI

      mzdDavhdw ->cRoObCpPPv := StrZero(mzdDavhdw->nrokobd,6)+StrZero(msPrc_moW->noscisprac,5) +;
                                +StrZero(msPrc_moW->nporpravzt,3)
      mzdDavhdw->cRoCpPPv    := StrZero(mzdDavhdw->nrok,4)+StrZero(msPrc_moW->noscisprac,5) +;
                                +StrZero(msPrc_mow->nporpravzt,3)
      mzdDavhdw->cCpPPv      := StrZero(msPrc_mow->noscisprac,5) +StrZero(msPrc_mow->nporpravzt,3)

      mzdDavhdw ->ctypDoklad := 'MZD_SRAZKY'
      mzdDavhdw ->ctypPohybu := 'SRAZKA'
      mzdDavhdw ->ndoklad    := fin_range_key('MZDDAVHD:MS')[2]
      mzdDavhdw ->ddatPoriz  := date()
      mzdDavhdw ->nVYUCDANE  := isNull( vyucDane->sID, 0)
      mzdDavhdw ->nautoGen   := 3
      *
      ** Automaticky dotahovat kmenové støedisko stroje
      if( .not. ::cfg_lAuKmStroj, mzdDavhdw->ckmenStrSt := msPrc_moW->ckmenStrPr, nil )
      *
      ** naplníme položku bude jen jedna
      ::copyFldto_W( 'mzdDavhdw', 'mzdDavitw' )

      nhodnota := (vyucDane->nprepNedop +vyucDane->nKVR_danbo) - vyucDane->nZuctovano

      mzdDavitw->nordItem    := 10
      mzdDavitw->ndruhMzdy   := 500
      mzdDavitw->nsazbaDokl  := nhodnota * (-1)
      mzdDavitw->nMzda       := mzdDavitw->nsazbaDokl
      mzdDavitw->nHrubaMzd   := mzdDavitw->nMzda
      mzdDavitw->nVYUCDANE   := isNull( vyucDane->sID, 0)

      * pro generování pøíkazu k úhradì
      druhyMzd->( dbseek( strZero(::nrok,4) +strZero(::nobdobi,2) +strZero(mzdDavitw->ndruhMzdy,4),,'DRUHYMZD04'))

      mzdDavitw->ctypPohZav  := druhyMzd->ctypPohZav
      mzdDavitw->cZkratStat  := SysConfig( 'System:cZkrStaOrg' )
      mzdDavitw->czkratMeny  := SysConfig( 'Finance:cZaklMENA' )
      mzdDavitw->czkratMenZ  := SysConfig( 'Finance:cZaklMENA' )
      mzdDavitw->nMNOZPREP   := 1
      mzdDavitw->nKURZAHMEN  := 1

      * modifikace položky pøed nápoètem
      mzdDavitw->cucetskup  := allTrim( Str( mzdDavitw->ndruhMzdy))
      mzdDavItw->nzaklSocPo := 0
      mzdDavItw->nzaklZdrPo := 0

      mzd_mzddavhd_cmp(.t.)
      mzdDavhdw->( dbcommit())
      mzdDavitw->( dbcommit())
      *
      ** uložíme do dat originálu
      if vyucDane->( sx_RLock())
        mh_copyFld( 'mzdDavhdw', 'mzdDavhd', .t. )
        mh_copyFld( 'mzdDavitw', 'mzdDavit', .t. )

        mzdDavhd->( dbUnlock(), dbCommit())
        mzdDavit->( dbUnlock(), dbCommit())

        vyucDane->nMZDDAVHD := isNull( mzdDavhd->sID, 0)
        vyucDane->nMZDDAVIT := isNull( mzdDavit->sID, 0)

        zuctovano := 0
        mzdDavitS->( ordSetFocus('VYUCDANE')                            , ;
                     dbsetScope(SCOPE_BOTH, isNull( vyucDane->sID, 0))              , ;
                     dbeval( { || zuctovano +=  mzdDavitS->nHrubaMzd } ), ;
                     dbclearScope()                                       )
        vyucDane->nZuctovano := zuctovano *(-1)

        vyucDane->( dbUnlock(), dbCommit())
      endif
    endif

    vyucDane->( dbskip())

    nkeyNo++
    if( vyucDane->(eof()), nkeyno := nkeyCnt, nil )
    fin_bilancew_pb(::xbp_therm, nkeycnt, nkeyno)
  enddo

  if( .not. empty( vyucDane->( ads_getAof())), vyucDane->( ads_clearAof()), nil )
  ::oDBro_main:oxbp:refreshAll()

  confirmBox(, 'Dobrý den p. ' +logOsoba +CRLF +                                     ;
               'Probìhlo generování mzdových dokladù z roèního zúètování danì ...' , ;
               'Dokonèeno generování dokladù ...'                                  , ;
                XBPMB_OK                                                           , ;
                XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE                         )
  _clearEventLoop(.t.)

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return self


static function fin_bilancew_pb(oxbp, nkeyCnt, nkeyNo, ncolor)
  local  charInf
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()
  local  nSize   := oxbp:currentSize()[1]
  local  nHight  := oxbp:currentSize()[2] -2

  default ncolor to GRA_CLR_PALEGRAY

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  GraGradient( ops             , ;
              {2,2}            , ;
              {{newPos,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

  GraGradient( ops                 , ;
               { newPos+1,2 }      , ;
               { { nsize, nhight }}, ;
               {ncolor,0,0}, GRA_GRADIENT_HORIZONTAL)

  GraStringAt( oPS, {(nSize/2) -20,6}, prc)
  oXbp:unlockPS(oPS)
return .t.