#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "drgRes.ch"
#include "class.ch"
#include "adsdbe.ch"
*
#include "dbstruct.ch"

//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"
#include "..\UCTO\AKTUCDAT\UCT_aktucdat_.CH"


function UCT_aktucdatw_bc(ncolumn)
  local  retVal := 0
  local  cc     := 'aktucdatw->nob_' +strTran( str(ncolumn,2), ' ', '0')

  retval := if( DBGetVal(cc) = 1, MIS_ICON_ERR, 0)
return retVal



*
*************** UCT_aktucdat ***************************************************
CLASS UCT_aktucdat_kon_akt FROM drgUsrClass
exported:
  var     task, o_obdobi, o_rok, xbp_therm
  method  init, getForm, drgDialogInit, drgDialogStart
  method  switch, zpracuj, ext_verify, err_verify

  *  state1/ state2
  inline access assign method mainState() var mainState
    return if(aktucdatw->lroot, MIS_BOOKOPEN, 0)

  inline access assign method subState()  var subState
    local set_2  := aktucdatw->nset_2
    local group  := aktucdatw->cgroup
    local retVal := 0

    do case
    case( ::n_treeItem = 1 .or. ::n_treeItem = 2)
      retVal := MIS_ICON_OK
    otherwise
      do case
      case(group = '31' )  ;  retVal      := if(set_2 = 1,MIS_ICON_OK,MIS_NO_RUN)
                              ::contr_off := (set_2 = 0)
      case(group = '32' )  ;  retVal := 0
      case(group = '321')  ;  retVal := 0
      case(group = '33' )  ;  retVal := if(set_2 = 1,MIS_ICON_OK,MIS_NO_RUN)
      otherwise
        retVal := if(aktucdatw->nset_2 = 1, 172, 173)
      endcase
    endCase
    return retVal

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local cc, isAppend := .f., block

    do case
    case (nEvent = xbeBRW_ItemMarked)
*-      ::msg:WriteMessage(,0)
      return .f.

    case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
      ::switch()
      return .t.

    case (nEvent = drgEVENT_APPEND)
      return .t.

     case (nEvent = drgEVENT_DELETE .or. nEvent = drgEVENT_EDIT)
       return .t.

     case (nEvent = drgEVENT_SAVE)
        return .t.

     case (nEvent = xbeP_Keyboard)
       if( AppKeyState(xbeK_ALT) = 1 .and. mp1 = xbeK_ALT_ENTER, ::switch(), nil)

       if mp1 == xbeK_ESC .and. .not. ::inBrow()
         if IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
           oXbp:setColorBG( oXbp:cargo:clrFocus )
         endif

         SetAppFocus(::oabro[1]:oxbp)
         PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
         ::dm:refresh()
         return .t.
       else
         return .f.
       endif

    endcase
  return .f.

hidden:
* sys
  var     msg, dm, dc, df, brow, oabro, udcp
  var     m_udcp, m_cargo, n_treeItem, lVerify_Ok, pb_zpracuj, contr_off
  var     kontr_Ns
  var     sumUctMzd

  method  verify, obraty, automaty, saldo, no_runAkt

  * je aktivni BROw ?
  inline method inBrow()
    return (SetAppFocus():className() = 'XbpBrowse')
ENDCLASS


method UCT_aktucdat_kon_akt:init(parent)

  ::m_udcp     := parent:parent:udcp
  ::m_cargo    := ::m_udcp:cargo
  ::n_treeItem := ::m_udcp:n_treeItem
  ::lVerify_Ok := .t.
  ::contr_off  := .f.
  ::kontr_Ns   := SYSCONFIG( 'SYSTEM:nKONTR_ns' )
  ::sumUctMzd  := sysConfig( 'MZDY:nsumUctMzd'  )

  ::drgUsrClass:init(parent)
return self


method UCT_aktucdat_kon_akt:getForm()
  local  oDrg, drgFC, headTitle := ::m_udcp:c_treeItem
  *
  local  x, p_obd := ::m_cargo:aOBD_AKT, cobd
  local  n_width   := round(3 +3 +60 +(3 * len(p_obd)),0) +1.5
  local  n_high    := min(22,::m_udcp:n_treeItems)

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 78,20.2 DTYPE '10' TITLE '' GUILOOK 'All:N,Border:Y'
  odrg:size := {n_width, n_high+4}

  DRGSTATIC INTO drgFC FPOS 0,0 SIZE 75,1.2 STYPE XBPSTATIC_TYPE_RAISEDBOX
  odrg:size[1] := n_width -3

    DRGTEXT INTO drgFC CAPTION ''   CPOS  2,.1 CLEN 75 FONT 5
    odrg:clen := n_width -3 -2 -1
    odrg:caption := headTitle
  DRGEND  INTO drgFC

  DRGDBROWSE INTO drgFC FPOS 0,1.3 SIZE 78,13 FILE 'AKTUCDATw'  ;
      FIELDS 'M->mainState::3::2,'                            + ;
             'M->subState::3::2,'                             + ;
             'ctext:popis zpracování:60'                        ;
      SCROLL 'nn' CURSORMODE 3 PP 6 POPUPMENU 'n'
  odrg:size     := { n_width, n_high+1.3}
  odrg:rest     := 'n'
  odrg:headMove := 'n'

  for x := 1 to len(p_obd) step 1
    cobd        := str( val( substr(p_obd[x],5,2)))
    odrg:fields += ',UCT_aktucdatw_bc(' +cobd +'):' +cobd +':3::2'
  next

  DRGPUSHBUTTON INTO drgFC POS 75,.2 SIZE 3,1.2 ATYPE 1 ;
                ICON1 146 ICON2 246 EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
  odrg:pos[1]:= n_width -3

  ** teplomìr **
  DRGSTATIC INTO drgFC FPOS 0,0 SIZE 75,1.1 STYPE XBPSTATIC_TYPE_RECESSEDBOX
    odrg:groups  := 'THERM'
    odrg:fpos    := {.5,n_high +4 -1.3}
    odrg:size[1] := n_width -12
  DRGEND  INTO drgFC

  DRGPUSHBUTTON INTO drgFC CAPTION '~Zpracuj'  ;
                           POS  75,19          ;
                           SIZE 10, 1.1        ;
                           ATYPE 3             ;
                           ICON1 DRG_ICON_SAVE ;
                           ICON2 gDRG_ICON_SAVE EVENT 'zpracuj' TIPTEXT 'Zpracuj dle zadání ...'
  odrg:pos := {n_width -10.5,n_high +4 -1.2}
RETURN drgFC


method UCT_aktucdat_kon_akt:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*-  XbpDialog:titleBar := .F.
  xbpDialog:maxButton := .f.
  xbpDialog:minButton := .f.

return


method UCT_aktucdat_kon_akt:drgDialogStart(drgDialog)
  local  x, arect, apos, odrg, ocolumn
  local  members := drgDialog:oForm:aMembers

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  ::oabro    := drgDialog:dialogCtrl:obrowse

  ::brow     := drgDialog:dialogCtrl:obrowse[1]:oxbp
  ::udcp     := drgDialog:parent:udcp

  for x := 1 to len(members) step 1
    odrg := members[x]
    if(odrg:className() = 'drgStatic' .and. odrg:groups = 'THERM')
      ::xbp_therm := odrg:oxbp

    elseif(odrg:className() = 'drgPushButton')
      if( isCharacter(odrg:event) .and. odrg:event = 'zpracuj' )
        ::pb_zpracuj := odrg:oxbp
      endif
    endif
  next

  *
  **
  ::brow:configure(,,,,drgPP:getPP(2))
  for x := 1 to ::brow:colCount step 1
    ocolumn := ::brow:getColumn(x)
    ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR] := GraMakeRGBColor( {255, 255, 200} )
    ocolumn:configure()
  next
  ::brow:refreshAll()

  * zakážeme reSice column / asi by to mìla být vlastnost DBrowse
  ::brow:Sizecols := .F.
return self


method UCT_aktucdat_kon_akt:zpracuj()
  local  p_obd       := ::m_cargo:aOBD_AKT
  local  i, aBitMaps := { 0, {nil,nil,nil} }, nPHASe := MIS_PHASE1, oThread, ncolPos
  local  x, cmeth, isLast := .f., lVerify_Ok := ::lVerify_Ok
  *
  local  ctxt_er  := 'Pøi kontrole byly zjištìny chyby, nelze pokraèovat ...'
  local  ctxt_ok  := 'Zpracování dokonèeno ...'

  *
  ** nachystáme si vrtítko
  for i := 1 to 3 step 1
    aBitMaps[2,i] := XbpBitmap():new():create()
    aBitMaps[2,i]:load( ,nPHASe )
    nPHASe++
  next

  aktucdatw->(dbGoTop())
  ::brow:refreshAll()

  if uceterr->(flock()) .and. uceterri->(flock())

    for x := 1 to len(p_obd) step 1
      isLast  := .f.

      ncolPos := col_for_animate(::brow,p_obd[x])
      oThread := Thread():new()

      oThread:setInterval( 10 )
      oThread:start( "uct_aktucdat_animate", ::brow, ncolPos, aBitMaps)

      do while .not. isLast
        isLast := aktucdatW->isLast
        cmeth  := allTrim(aktucdatw->cmethod)

        if isMethod(self, cmeth, CLASS_HIDDEN) .and. aktucdatw->nset_2 = 1
           self:&cmeth(p_obd[x])
           *
           if cmeth = 'verify' .and. .not. ::lVerify_Ok
             if lVerify_Ok <> ::lVerify_Ok
               lVerify_Ok := ::lVerify_Ok
               ::no_runAkt()
             endif
           endif
        else
          ::brow:down():refreshAll()
        endif
      enddo

      if( .not. ::lVerify_Ok, ::no_runAkt(), nil)

      * vrátíme to
      oThread:setInterval( NIL )
      oThread:synchronize( 0 )
      oThread := nil

      sleep(10)
      setAppFocus(::brow)
      aktucdatw->(dbGoTop())
      ::brow:refreshAll()
      postAppEvent(xbeBRW_ItemMarked,,,::brow)
    next

    if( .not. ::lVerify_Ok, aktucdat_INF(::xbp_therm, ctxt_er ), ;
                            aktucdat_INF(::xbp_therm, ctxt_ok )  )

  else
    ConfirmBox( ,'Je mì líto, ale jiný uživatel již zpustil aktualizaci, nelze zpracovat ...', ;
                 'Nelze zpracovat požadavek ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  uceterr->(dbUnlock())
   uceterri->(dbUnlock())
return

static function col_for_animate(obrow,cobd_Zpr)
  local  ncolPos, cobd := str( val( substr(cobd_Zpr,5,2))), ocolumN

  BEGIN SEQUENCE
  for ncolPos := 1 to obrow:colCount step 1
    ocolumN := obrow:getColumn(ncolPos)
    if 'uct_aktucdatw_bc(' +cobd +')' $ lower(ocolumN:frmColum)
  BREAK
    endif
  next
  END SEQUENCE
return ncolPos

procedure uct_aktucdat_animate(obrow,ncolPos,aBitMaps)
  local  ocolumN, aRect, oPS, nXD, nYD

  ocolumN := obrow:getColumn(ncolPos)
  aRect   := ocolumN:dataArea:cellRect(obrow:rowPos)
  oPS     := ocolumN:dataArea:lockPS()

  nXD     := aRect[1]
  nYD     := aRect[2]

  aBitMaps[1] ++
  if aBitMaps[1] > len(aBitMaps[2])
    aBitMaps[1] := 1
  endif

  aBitMaps[ 2, aBitMaps[1] ]:draw( oPS, {nXD,nYD} )
  ocolumN:unlockPS( oPS )
return
**
*


method UCT_aktucdat_kon_akt:switch()
  local group := aktucdatw->cgroup
  local recNo := aktucdatw->(recNo())

  if( group = '31' .or. group = '33')
    aktucdatw->(dbEval({|| aktucdatw->nset_2 := if( aktucdatw->nset_2 = 0, 1, 0) }, ;
                       {|| left(aktucdatw->cgroup,2) = left(group,2)             }  ), ;
                dbGoTo(recNo)                                                          )

    ::oabro[1]:oxbp:refreshAll()
  endif
return .t.

*
** Kontrola základních souborù ÚÈTO **
method UCT_aktucdat_kon_akt:verify(c_obdZpr)
  local  pc := bin2var(aktucdatw->mconds), pa
  *
  local  m_file, m_tag, npos := at(',', .file_tag)
  local  nkcMD := 0, nkcDAL := 0, lok := .t., lok_m, c_denikDokl
  local  recCnt, keyCnt, keyNo := 1
  *
  local  pa_denikDokl := {}

  m_file := lower(subStr(.file_tag,      1, npos -1))
  m_tag  :=   val(subStr(.file_tag,npos +1         ))

  drgDBMS:open(m_file)
  recCnt := uct_setScope(m_file,m_tag,c_obdZpr)
  keyCnt := recCnt / Round(::xbp_therm:currentSize()[1]/(drgINI:fontH -6),0)

  do case
  case ( ( m_file = 'mzddavhd' .or. m_file = 'mzdyhd' ) .and. ::sumUctMzd = 1 )

     do while .not. (m_file)->(eof())
      aktucdat_PB(::xbp_therm,keyCnt,keyNo,recCnt)

      nkcMD       := 0
      nkcDAL      := 0
      c_denikDokl := DBGetVal( .file_denik)

      if ascan(pa_denikDokl, c_denikDokl) = 0
        aadd(pa_denikDokl, c_denikDokl)

        ucetpol->(AdsSetOrder('UCETPO12'), dbsetScope(SCOPE_BOTH, c_obdZpr +c_denikDokl), dbGoTop())
        *
        uc_errS->(dbZap())
        (pa  := .errs,  AEval( pa, { |x| DBGetVal(X) }))
        *
        ** pøi sumaèní úètování mezd, doklad neexistuje
        ucetErrw->ndoklad := ucetpol->ndoklad

        ucetpol->(dbEval( { || nkcMD  += ucetpol->nkcMD , ;
                               nkcDAL += ucetpol->nkcDAL, ;
                               ::ext_verify()             } ))

        lok_m :=  ( round(nkcMD,2) = round(nkcDAL,2) )

        uceterrW->cErr := stuff(uceterrW->cErr, 3, 1, if(lok_m, '0', '1'))
        if(uceterrW->cErr = '0000000', nil, (::err_verify(.t.), ::lVerify_Ok := .f.) )

        ucetpol->(dbClearScope())
      endif

      (m_file)->(dbSkip())
      keyNo++
    enddo

  otherwise

    do while .not. (m_file)->(eof())
      aktucdat_PB(::xbp_therm,keyCnt,keyNo,recCnt)

      nkcMD       := 0
      nkcDAL      := 0
      c_denikDokl := DBGetVal( .file_denik) +upper((m_file)->ctypPohybu) +strZero( DBGetVal(.doklad),10)

      ucetpol->(AdsSetOrder('UCETPO14'), dbsetScope(SCOPE_BOTH, c_denikDokl), dbGoTop())
      *
      uc_errS->(dbZap())
      (pa  := .errs,  AEval( pa, { |x| DBGetVal(X) }))

      ucetpol->(dbEval( { || nkcMD  += ucetpol->nkcMD , ;
                             nkcDAL += ucetpol->nkcDAL, ;
                             ::ext_verify()             } ))

      if m_file = 'mzddavhd' .or. m_file = 'mzdyhd'
        lok_m :=  ( ((m_file)->nklikvid          = (m_file)->nzlikvid) .and. ;
                    (round(nkcMD,2)              = round(nkcDAL,2)   )       )
      else
        lok_m :=  ( ((m_file)->nklikvid          = (m_file)->nzlikvid) .and. ;
                    (round(nkcMD,2)              = round(nkcDAL,2)   ) .and. ;
                    (round((m_file)->nklikvid,2) = round(nkcMD,2)    )       )
      endif

      uceterrW->cErr := stuff(uceterrW->cErr, 3, 1, if(lok_m, '0', '1'))
      if(uceterrW->cErr = '0000000', nil, (::err_verify(), ::lVerify_Ok := .f.) )

      lok := (lok .and. lok_m)
      ucetpol->(dbClearScope())
      (m_file)->(dbSkip())

      keyNo++
    enddo

  endcase

  uct_clearScope(m_file)
  ::xbp_therm:configure()

  if .not. lok
    DBPutVal('aktucdatw->nob_' +right(c_obdZpr,2),1)
    ::brow:refreshCurrent()
  endif

  ::brow:down():refreshAll()
return .t.


method UCT_aktucdat_kon_akt:ext_verify()
  local  pD     := ::m_cargo:aDENIKY
  local  cC     := '', cns := '', ns, denik := left( upper(ucetpol->cdenik),1)
  local  n_End  := if( ::kontr_Ns = 0, 6, min( ::kontr_Ns, 6))
  *
  local  cC_dokl_old := uceterrW->cErr
  local  cC_dokl_new

  for ns := 1 to n_End step 1
    cns += DBGetVal('ucetpol->cnazpol' +str(ns,1))
  next

  cC += if(ascan( pD, {|x| x[1] = ucetpol->cdenik}) = 0     , '1', '0')
  cC += if(empty(ucetpol->ndoklad)                          , '1', '0')
  cC += '0'
  cC += if(c_uctosn->(dbSeek(ucetpol->cucetMd,,'UCTOSN1'))  , '0', '1')
  cC += if(c_uctosn->lsaldoUct .and. empty(ucetpol->csymbol), '1', '0')
  cC += if(empty(ucetpol->ddatPoriz)                        , '1', '0')

  if (denik <> 'A' .or. denik <> 'X') .and. c_uctosn->lnaklStr
    cC += if(empty(cns),'1',if( .not. c_naklst->(dbSeek(upper(cns),, AdsCtag(1) )),'1','0'))
  else
    cC += '0'
  endif

  cC_dokl_new := cC
  for x := 1 to len(cC_dokl_old) step 1
    if subStr( cC_dokl_old, x, 1) = '1'
      cC_dokl_new := stuff( cC_dokl_new, x, 1, '1' )
    endif
  next

  uceterrW->cErr   := cC_dokl_new
  uceterrW->nkcMd  += ucetpol->nkcMd
  uceterrW->nkcDal += ucetpol->nkcDal
  *
  uc_errS->(dbAppend())
  uc_errS->nrecS := ucetpol->(recNo())
  uc_errS->cerrS := cC
return cC


method UCT_aktucdat_kon_akt:err_verify( lonlyErrs )

  default lonlyErrs to .f.

  mh_copyFld('uceterrW', 'uceterr', .t.)
  *
  uc_errS->(dbGoTop())
  do while .not. uc_errS->(eof())
    do case
    case lonlyErrs
      if uc_errS->cerrS <> '0000000'
        ucetpol->(dbGoTo(uc_errS->nrecS))
        mh_copyFld('ucetpol','uceterri', .t.)
        uceterri->cErr := uc_errS->cerrS
      endif
    otherwise
      ucetpol->(dbGoTo(uc_errS->nrecS))
      mh_copyFld('ucetpol','uceterri', .t.)
      uceterri->cErr := uc_errS->cerrS
    endcase
    *
    uc_errS->(dbSkip())
  enddo
return .t.


method UCT_aktucdat_kon_akt:no_runAkt()
  local  recNo := aktucdatW->(recNo())

  ::pb_zpracuj:hide()

  if ::n_treeItem = 3
    aktucdatW->(dbGoTop())

    do while .not. aktucdatW->(eof())
      if aktucdatW->cgroup = '321' .or. aktucdatW->cgroup = '33'
        aktucdatW->nset_2 := 0
      endif
      aktucdatW->(dbskip())
    enddo

    aktucdatW->(dbGoTo(recNo))
  endif
return .t.


*
** Zpracování aktualizace zùstatkù a obratù **
method UCT_aktucdat_kon_akt:obraty(c_obdZpr)
  local  c_obdPs := ::udcp:cobd_psn

  uct_aktucdat_ob(c_obdZpr,c_obdPs,::xbp_therm)

  ::xbp_therm:configure()
  ::brow:down():refreshAll()

  ucetsys->(dbRlock())
  ucetsys->lcontr_off := ::contr_off
  ucetsys->(dbUnlock())
return .t.

*
** Rozbìh všech nabídek automatik
method UCT_aktucdat_kon_akt:automaty(c_obdZpr)

  ::brow:down():refreshAll()
  AUTUc_MAIv(c_obdZpr,::brow,::xbp_therm)
return .t.

*
** Zpracování saldokonta **
method UCT_aktucdat_kon_akt:saldo(c_obdZpr)
  local  c_obdPs := ::udcp:cobd_psn

  ** zatím pro kontrolu zpracování ucetkuM **
  uct_aktucdat_kumU(c_obdZpr,::xbp_therm)

  **
  uct_aktucdat_sa(c_obdZpr,::xbp_therm)
  ::xbp_therm:configure()
  ::brow:down():refreshAll()
return .t.