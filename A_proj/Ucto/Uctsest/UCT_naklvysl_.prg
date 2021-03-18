#include "Common.ch"
#include "drg.ch"
#include "gra.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\A_main\ace.ch"
//
#include "..\Asystem++\Asystem++.ch"


#define m_files    { 'ucetsys,3' , 'c_naklst'  ,'uceterr'      , ;
                     'c_uctosn,1'                              , ;
                     'ucetkum,1' , 'ucetkumk,1', 'ucetplan,1'    }

#define sum_files  { { 'ucetkum', 'uc_kumW' , ;
                       { 'nKcMDpsO'   , 'nKcDALpsO' , 'nKcMDobrO' , 'nKcDALobrO' , ;
                         'nKcMDpsR'   , 'nKcDALpsR' , 'nKcMDobrR' , 'nKcDALobrR' , ;
                         'nKcMDksR'   , 'nKcDALksR' , 'nMnozNAT'  , 'nMnozNAT2'  , ;
                         'nMnozNATR'  , 'nMnozNAT2R'     }                         }, ;
                     { 'ucetkum', 'uc_kummW', ;
                       { 'nKcMDpsO'   , 'nKcDALpsO' , 'nKcMDobrO' , 'nKcDALobrO' , ;
                         'nKcMDpsR'   , 'nKcDALpsR' , 'nKcMDobrR' , 'nKcDALobrR' , ;
                         'nKcMDksR'   , 'nKcDALksR' , 'nMnozNAT'  , 'nMnozNAT2'  , ;
                         'nMnozNATR'  , 'nMnozNAT2R'     }                         }, ;
                     { 'ucetplan','uc_planW', ;
                       { 'nPLANzaOBD' ,  'nPLANkOBD' , 'nPLANROK' , 'nPLANzaoOR' , ;
                         'nMnozNAT'   ,  'nMnozNAT2'                                }  }  }


static nskip


function UCT_naklvysl_BC(nCOLUMn)
  local  xRETval := 0

  do case
  case ncolumn = 2  ;  xRETval := If( ucetsys->laktObd, 300, 0)
  case ncolumn = 3  ;  xRETval := if( uceterr->( mh_SEEK( ucetsys->cobdobi, 1, .T. )), 301, ;
                                  if( ucetsys->lzavren, 302, 0 ))
  case ncolumn = 4  ;  xRETval := if( ucetsys->naktuc_ks = 1, 316, ;
                                  if( ucetsys->naktuc_ks = 2, 300, 0))
  case ncolumn = 5  ;  xRETval := str (ucetsys->nobdobi,2) +'/' +str(ucetsys->nrok,4)
  case ncolumn = 6  ;  xRETval := dtoc(ucetsys->ductDat)   +'     ' +ucetsys->cuctKdo
  endcase
return(xRETVAL)


function UCT_naklvysl_Ns()
  local  aNs := { {'støedisko'      , 'støedisko' , 'CNAZPOL1'}, ;
                  {'výrobek'        , 'výrobek'   , 'CNAZPOL2'}, ;
                  {'zakázka'        , 'zakázka'   , 'CNAZPOL3'}, ;
                  {'výrobní místo'  , 'výrMísto'  , 'CNAZPOL4'}, ;
                  {'stroj'          , 'stroj'     , 'CNAZPOL5'}, ;
                  {'výrobní operace', 'výrOperace', 'CNAZPOL6'}  }

  drgDBMS:open('c_naklstW',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  *
  AEval( aNs, { |x,m| c_naklstW->(dbAppend())          , ;
                    c_naklstW->nporadi   :=        0   , ;
                    c_naklstW->cnazev_Ns := ' _ ' +x[1], ;
                    c_naklstW->cheads_Ns :=        x[2], ;
                    c_naklstW->citems_Ns :=        x[3]  } )
return nil


*
** CLASS for UCT_naklvysl_IN **************************************************
CLASS UCT_naklvysl_IN FROM drgUsrClass
exported:
  method  init, drgDialogStart
  method  comboBoxInit, comboItemSelected
  *
  method  sys_tiskform_crd


  *  ucetsys
  ** ncolumn - 1
  inline access assign method obd_Select() var obd_Select
    return 0  // if(ucetsys->cobdobi = ::selObd, 172, 0)

  * c_naklstW
  inline access assign method porNs_Select() var porNs_Select
    local porNs := c_naklstW->nporadi
    return if(porNs = 0, '    ', str(porNs,3) +'.')

  * c_naklst
  inline access assign method col0Ns_Select() var col0Ns_Select
    local  pa := ::selrowNs
    return if( AScan( pa, c_naklst->(recNo())) = 0, 0, 172)

  inline access assign method col1Ns_Select() var col1Ns_Select
    return if( empty(::selcolNs[1]), '', DBGetVal('c_naklst->' +::selcolNs[1]) )

  inline access assign method col2Ns_Select() var col2Ns_Select
    return if( empty(::selcolNs[2]), '', DBGetVal('c_naklst->' +::selcolNs[2]) )

  inline access assign method col3Ns_Select() var col3Ns_Select
    return if( empty(::selcolNs[3]), '', DBGetVal('c_naklst->' +::selcolNs[3]) )

  inline access assign method col4Ns_Select() var col4Ns_Select
    return if( empty(::selcolNs[4]), '', DBGetVal('c_naklst->' +::selcolNs[4]) )

  inline access assign method col5Ns_Select() var col5Ns_Select
    return if( empty(::selcolNs[5]), '', DBGetVal('c_naklst->' +::selcolNs[5]) )

  inline access assign method col6Ns_Select() var col6Ns_Select
    return if( empty(::selcolNs[6]), '', DBGetVal('c_naklst->' +::selcolNs[6]) )


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local inFile := if(isObject(::dc:oaBrowse), lower(::dc:oaBrowse:cfile), 'ucetsys')
    local recNo, pa := ::selrowNs, filter := ''
    *
    local nin, obro

    do case
    case(nevent = xbeBRW_ItemMarked)
     if ::isStart
        obro := ::oabro[1]:oxbp

// ne        obro:gotop():forceStable()

        for nin := 1 to nskip -1 ; obro:down() ; NEXT
        obro:forceStable()

        ::isStart := .f.
        return .t.
      endif
      return .f.

    case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
      do case
// ne      case(inFile = 'ucetsys'  )  ;  ::set_Obd()
      case(inFile = 'c_naklstw')  ;  ::set_porNs()
      case(inFile = 'c_naklst' )  ;  ::set_rowNs()
      endcase
      return .t.

    case (nEvent = xbeP_Keyboard)
      if mp1 = xbeK_CTRL_ENTER
        do case
// ne        case(inFile = 'ucetsys'  )  ;  ::set_Obd()
        case(inFile = 'c_naklstw')  ;  ::set_porNs()
        case(inFile = 'c_naklst' )  ;  ::set_rowNs()
        endcase
       endif

     if mp1 = xbeK_CTRL_A .and. (inFile = 'c_naklst')
       if ::selporNs <> 0
         pa := {}
         if .not. ::selrowNs_all
           recNo := c_naklst->(recNo())
           c_naklst->(DBEval( { || AAdd(pa, c_naklst->(recNo())) }), ;
                      dbgoTo(recNo)                                  )
         endif
         ::selrowNs     := AClone(pa)
         ::selrowNs_all := .not. ::selrowNs_all
         ::oabro[3]:oxbp:refreshAll()
       endif
     endif

     case(nevent = drgEVENT_PRINT)
       AEval( ::selrowNs, {|x| filter += 'recno() = ' +str(x) +' .or. '})
       filter := left(filter, len(filter)-6)
       if empty(filter)
         ConfirmBox( ,'Nelze zpracovat, nutno nastavit podmínky ...', ;
                      'Nelze zpracovat ...' , ;
                       XBPMB_CANCEL                    , ;
                       XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
       else
         ::sys_tiskform_crd()
         c_naklst->(ordSetFocus('naklvyslW'), dbgoTop())
       endif
       return .t.

    endcase
  return .f.

hidden:
  var    msg, dm, dc, df, oabro, udcp, cdirW, xbp_therm, isStart
  var    selRok, selObd, selPorNs, selcolNs, selrowNs, selrowNs_all
  *

  method uct_naklvysl_gen

  inline method openfiles(afiles)
    local  nin,file,ordno

    aeval(afiles, { |x| ;
         if(( nin := at(',',x)) <> 0, (file := substr(x,1,nin-1), ordno := val(substr(x,nin+1))), ;
                                      (file := x                , ordno := nil                )), ;
         drgdbms:open(file)                                                                        , ;
         if(isnull(ordno), nil, (file)->(ordsetfocus( AdsCtag( ordno ))))                            })
  return nil

  * ucetsys
  inline method set_Rok()
    local m_filter := "culoha = '%%' .and. nrok = %%", filter, x

    if( .not. empty(ucetsys->(ads_getaof())), ucetsys->(ads_clearaof(),dbgotop()), nil)

    filter := format(m_filter,{'U',::selRok})
    ucetsys ->(ads_setaof(filter),dbgotop())

    ::oabro[1]:oxbp:gotop():forceStable()
    ::oabro[1]:oxbp:refreshAll()
    ::dm:refresh()

    PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
    SetAppFocus(::oabro[1]:oXbp)
    return self

  inline method set_Obd()
    ::selObd := ucetsys->cobdobi
    ::oabro[1]:oxbp:refreshAll()
    return nil

  * c_naklstW
  inline method set_porNs()
    local oldPorNs, setPorNs, recNo := c_naklstW->(recNo())
    *
    local pa := {}, x, obro := ::oabro[3]:oxbp, ocol, clr, indexKey := ''
    local hIndex, cKy, pa_cKy := {}, searchKey := ''
    *

    if c_naklstW->nporadi = 0
      (::selPorNs++ , c_naklstW->nporadi := ::selPorNs)
    else
      oldPorNs := c_naklstW->nporadi
      (::selPorNs-- , c_naklstW->nporadi := 0         )

      c_naklstW->(dbgoTop())
      do while .not. c_naklstW->(eof())
        setPorNs := c_naklstW->nporadi

        c_naklstW->nporadi := if(setPorNs > oldPorNs, setPorNs-1, setPorNs)
        c_naklstW->(dbSkip())
      enddo
    endif

    c_naklstW->(dbGoTo(recNo))
    ::oabro[2]:oxbp:refreshAll()
    *
    * modifikace c_naklst dle nastavní c_naklstW
    c_naklstW->(dbeval( {|| AAdd(pa, { if(c_naklstW->nporadi = 0, 9, c_naklstW->nporadi), ;
                                       c_naklstW->cheads_Ns                             , ;
                                       c_naklstW->citems_Ns                               }) } ))
    c_naklstW->(dbGoTo(recNo))

    ASort( pa,,, {|aX,aY| aX[1] < aY[1] } )

    obro:lockUpdate(.t.)
    for x := 1 to len(pa) step 1
      ocol := obro:getColumn(x+1)

      ::selcolNs[x] := if(pa[x,1] = 9, '', pa[x,3])

      if pa[x,1] <> 9
        ocol:HeaderLayout[XBPCOL_HFA_CAPTION]      := pa[x,2]
        ocol:HeaderLayout[XBPCOL_HFA_FRAMELAYOUT]  := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
        ocol:HeaderLayout[XBPCOL_HFA_ALIGNMENT]    := XBPALIGN_HCENTER
      else
        ocol:HeaderLayout[XBPCOL_HFA_CAPTION]      := ''
        ocol:HeaderLayout[XBPCOL_HFA_FRAMELAYOUT]  := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_THICK
      endif

      ocol:heading:setFont(drgPP:getFont(5))
      ocol:configure()
    next

    * indexace
    if ::selporNs > 0
      DbSelectArea('c_naklst')
      AEval( ::selcolNs, {|x| indexKey += 'upper(' +x+ ')+' },1,::selPorNs)
      indexKey := substr(indexKey,1,len(indexKey) -1)

      AEval( ::selcolNs, {|x| searchKey += 'upper( c_naklst->' +x+ ')+' },1,::selPorNs)
      searchKey := substr(searchKey,1,len(searchKey) -1)

      c_naklst->( ordSetFocus(0), ordListClear())
      ferase( ::cdirW +'NAKLVYSLw.ADI' )

      hIndex := c_naklst->(Ads_CreateTmpIndex( ::cdirW +'naklvyslW' , ;
                                                        'naklvyslW' , ;
                                                         indexKey   , ;
                                                                    , ;
                                                                    , ;
                                                         ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                         .f.          ))

      c_naklst ->( ordSetFocus(0), dbGoTop())

      do while .not. c_naklst->(eof())
        cky   := c_naklst->( DBGetVal( searchKey ) )

        if AScan( pa_cKy, cKy ) = 0
          c_naklst->( AdsAddCustomKey( hIndex ))

          AAdd( pa_cKy, cKy)
        endif
        c_naklst->(dbSkip())
      enddo

      c_naklst->(ordSetFocus('naklvyslW'), dbgoTop())
    endif

    ::selrowNs     := {}
    ::selrowNs_all := .f.

    obro:configure():refreshAll()
    ::oabro[3]:refresh(.t.)
    obro:lockUpdate(.f.)

    obro:cursorMode := XBPBRW_CURSOR_ROW
    obro:hilite()
    PostAppevent(xbeBRW_ItemMarked,,,::oabro[2]:oxbp)
    return nil

  * c_naklst
  inline method set_rowNs()
    local  pa := ::selrowNs, recNo := c_naklst->(recNo()), nIn

    if ::selporNs <> 0
      if (nIn := AScan(pa, recNo)) = 0
        AAdd(pa, recNo)
      else
        (ADel(pa, nIn), ASize(pa, len(pa) -1))
      endif
      ::selrowNs_all := .f.
      ::oabro[3]:oxbp:refreshAll()
    endif
    return nil
ENDCLASS


method uct_naklvysl_in:init(parent)
  local m_filter := "culoha = '%%' .and. nrok = %%", filter

  ::drgUsrClass:init(parent)

  nskip          := 0
  ::isStart      := .t.

  ::selRok       := uctOBDOBI:UCT:NROK
  ::selObd       := uctOBDOBI:UCT:COBDOBI
  ::selporNs     := 0
  ::selcolNs     := { '', '', '', '', '', '' }
  ::selrowNs     := {}
  ::selrowNs_all := .f.
  *
  ::openfiles(m_files)

  filter := format(m_filter,{'U',::selRok})
  ucetsys ->(ads_setaof(filter)                                          , ;
             dbgotop()                                                   , ;
             dbeval( { || if( ucetsys->naktuc_ks = 2, nskip++, nil ) } ) , ;
             dbgotop()                                                     )
  *
  * Nákladové
  UCT_naklvysl_Ns()
return self

method UCT_naklvysl_in:drgDialogStart(drgDialog)
  local  x, arect, apos
  local  members := drgDialog:oForm:aMembers
  *
  ::msg        := drgDialog:oMessageBar             // messageBar
  ::dm         := drgDialog:dataManager             // dataMabanager
  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::df         := drgDialog:oForm                   // form
  ::oabro      := drgDialog:dialogCtrl:obrowse
  ::udcp       := drgDialog:parent:udcp
  ::xbp_therm  := drgDialog:oMessageBar:msgStatus
  *
  ::cdirW    := drgINI:dir_USERfitm +userWorkDir() +'\'

  ucetsys->(ads_setaof("culoha = 'U'"), ;
                dbseek( 'U' +strZero(::selRok,4),,'UCETSYS3'))

  ::oabro[1]:oxbp:configure()

// ne  ::set_Rok()

  * font c_naklstW  1.col
  oxbp := ::oabro[2]:oxbp
  ocol := oxbp:getColumn(1):dataArea
  ocol:setFont(drgPP:getFont(5))
return self


method UCT_naklvysl_in:comboBoxInit(drgComboBox)
  local  acombo_val := {}

  if  ('SELROK'   $ drgComboBox:name)
    do case
    case ('SELROK'   $ drgComboBox:name)
      drgComboBox:value := ::selRok
      ucetsys ->(dbgotop()       , ;
                 dbeval( { ||      ;
                 if( ascan(acombo_val,{|X| x[1] == ucetsys->nrok}) = 0 , ;
                     aadd(acombo_val,{ucetsys->nrok,'ROK _ ' +strzero(ucetsys->nrok,4)}), nil ) }))
      if empty(acombo_val)
        aadd(acombo_val, {::selRok-1, 'ROK _ ' +strzero(::selRok-1,4)})
        aadd(acombo_val, {::selRok  , 'ROK _ ' +strzero(::selRok  ,4)})
      endif
    endcase

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[2] < aY[2] } )
    AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
  endif
return self


method UCT_naklvysl_in:comboItemSelected(mp1, mp2, o)

  ::selRok := mp1:value
  ::set_Rok()
return .t.


*
** zpracování požadavku a spuštìní dialogu sys_tiskform_crd
method UCT_naklvysl_in:sys_tiskform_crd()
  local  oDialog, nExit
  *
  local  formName := ::drgDialog:formName, cRELs := 'upper(uc_kumW->cucetMd)'

  * pokud si vybral jiné období pøednastavíme
  obdReport := strZero(ucetsys->nobdobi,2) +'/' +strZero(ucetsys->nrok,4)
  ::selRok  := ucetsys->nrok
  ::selObd  := ucetsys->cobdobi

  ::uct_naklvysl_gen()

  * otevøeme TMP soubory pro sestavy
  drgDBMS:open('uc_kumW' , .T., .T., drgINI:dir_USERfitm, , , .T.)
  drgDBMS:open('uc_kummW', .T., .T., drgINI:dir_USERfitm, , , .T.)
  drgDBMS:open('uc_planW', .T., .T., drgINI:dir_USERfitm, , , .T.)

  * relace
  uc_kumW->(dbSetRelation('uc_kummW', COMPILE(cRELs), cRELs))
  uc_kumW->(dbSetRelation('uc_planW', COMPILE(cRELs), cRELs))
  uc_kumW->(dbSetRelation('c_uctosn', COMPILE(cRELs), cRELs))
  uc_kumW->(dbgotop())

  * zavoláme dialog pro zparcování sestavy
  ::drgDialog:formName := 'drgMenu'

  oDialog := drgDialog():new('sys_tiskform_crd,uct_naklvysl_lst',self:drgDialog)
  oDialog:create(,self:drgDialog:dialog,.F.)

  oDialog:destroy(.T.)
  oDialog := NIL

  ::drgDialog:formName := formName

  PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
  SetAppFocus(::oabro[1]:oXbp)

  * konec
  uc_kumW ->(dbCloseArea()) ; FErase(::cdirW +'uc_kumW.adi' )
  uc_kummW->(dbCLoseArea()) ; FErase(::cdirW +'uc_kummW.adi')
  uc_planW->(dbCloseArea()) ; FErase(::cdirW +'uc_planW.adi')
return self


method UCT_naklvysl_in:uct_naklvysl_gen()
  local pa    := sum_files
  local cdirW := drgINI:dir_USERfitm +userWorkDir() +'\'
  local cfile_M, cfile_W
  *
  local flt_Obd   := 'nrok = %% .and. nobdobi = %%', cobd_Zpr, bobd_Zpr
  local mainKey   := '', indexKey, b_indexKey, b_forKey, filter := ''
  *
  local nSize     := ::xbp_therm:currentSize()[1]
  local nHight    := ::xbp_therm:currentSize()[2] // -2


  uct_naklvysl_inf(::xbp_therm,'zpracování podkladù pro výsledovky', nsize, nhight)

  AEval( ::selcolNs, {|x| mainKey += 'upper(' +x+ ')+' },1,::selPorNs)
  mainKey := substr(mainKey,1,len(mainKey) -1)

  AEval( ::selrowNs, {|x| filter += 'recno() = ' +str(x) +' .or. '})
  filter := left(filter, len(filter)-6)
  c_naklst->(ads_setaof(filter),dbgotop())
  ::oabro[3]:oxbp:refreshAll()

  for x := 1 to len(pa) step 1
    cobd_Zpr := format(flt_obd, { if(x = 2, ::selRok-1, ::selRok), val(::selObd) })
    bobd_Zpr := COMPILE(cobd_Zpr)

    cfile_M  := pa[x,1]
    cfile_W  := pa[x,2]

    dbSelectArea(cfile_M)
    indexKey := 'upper(cucetMD) +' +mainKey

    (cfile_M) ->(ordSetFocus(0), ordListClear())
    FErase(cdirW +cfile_M +'W' +'.adi')

    (cfile_M)->( Ads_CreateTmpIndex( cdirW +cfile_M +'w', ;
                                     cfile_M +'w'       , ;
                                     indexKey           , ;
                                     cobd_Zpr           , ;
                                                        , ;
                                                          ) )
    (cfile_M)->(ordSetFocus(cfile_M +'W'), dbGotop())


    b_indexKey := COMPILE(indexKey)
    b_forKey   := COMPILE(mainKey)
    (cfile_M)->( dbTotal( (cdirW +cfile_W)       , ;
                 _EarlyBoundCodeblock(b_indexKey), ;
                 pa[x,3]                         , ;
                 _EarlyBoundCodeblock({|| uct_naklvysl_selNs(cfile_M,b_forKey) }),,,,.F. ) )


    uct_naklvysl_pb(::xbp_therm,len(pa),x,nsize,nhight)

  next

  uct_naklvysl_inf(::xbp_therm, 'zpracování podkladù pro výsledovky dokonèeno', nsize, nhight)
  (tone(100,13), tone(200,13), tone(300,13), tone(500,16))

  sleep(10)
  ::xbp_therm:setCaption('')

  c_naklst->(ads_clearAOF(), dbGoTop())
  ::oabro[3]:oxbp:refreshAll()
return self


function uct_naklvysl_selNs(cfile_M, b_forKey)
  local  cKy := (cfile_M)->(Eval(b_forKey))
  local  ok  := .t.

  ok := c_naklst->(dbSeek(cKy))
return ok


*
** PROGRESS BAR zpracování *****************************************************
static function uct_naklvysl_pb(oxbp, nkeyCnt, nkeyNo, nsize, nhight)
  local  charInf
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  if nkeyNo = 1
    GraGradient( ops               , ;
                 { 2,2 }           , ;
                 { {nsize, nhight}}, ;
                 {0,15,0}, GRA_GRADIENT_HORIZONTAL)
  endif

  GraGradient( ops             , ;
              {2,2}            , ;
              {{newPos,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

/*
  if newPos < (nSize/2) -20
    GraGradient( ops                , ;
                 { newPos+1,2 }, ;
                 { { nsize -newPos, nhight }}, ;
                 {0,15,0}, GRA_GRADIENT_HORIZONTAL)
  endif
*/

  GraStringAt( oPS, {(nSize/2) -20,6}, prc)
  oXbp:unlockPS(oPS)
return .t.

/*
function uct_naklvysl_pb(oXbp,nKeyCNT,nKeyNO, nRecCNT, lIsRED)
  LOCAL  oPS
  LOCAL  aAttr[GRA_AA_COUNT], aPos := {2,0}, newPos
  local  nclrs := GraMakeRGBColor({1, 211, 228})
  *
  LOCAL  nCharINF, prc, nSize := oxbp:currentSize()[1], nHight := oxbp:currentSize()[2] -2

  IF !EMPTY(oPS := oXbp:lockPS())
    aAttr [ GRA_AA_COLOR ] := If( IsNULL(lIsRED),nclrs, GRA_CLR_RED )
    GraSetAttrArea( oPS, aAttr )

    ncharInf := int(nkeyNo/ nkeyCnt)
    newPos   := apos[1] +drgINI:fontH -6 +((drgINI:fontH -6) * ncharInf)
    GraBox( oPS, {aPos[1],2}, {newPos, nHight}, GRA_OUTLINEFILL )

    aAttr [ GRA_AA_COLOR ] := GRA_CLR_BACKGROUND
    GraSetAttrArea( oPS, aAttr )
    GraBox( oPS, {newPos + .1,2}, {nSize,nHight}, GRA_FILL)

    val := int((newPos/nSize *100))
    prc := if( val > 100, '100', str(val)) +' %'
    GraStringAt( oPS, {(nSize/2) -20,6}, prc)

    oXbp:unlockPS(oPS)
  ENDIF
RETURN prc
*/

function uct_naklvysl_inf(oXbp, ctext, nsize, nhight)
  local  oPS, oFont, aAttr

  if .not. empty(oPS := oXbp:lockPS())
    GraGradient( ops               , ;
                 { 2,2 }           , ;
                 { {nsize, nhight}}, ;
                 {0,15,0}, GRA_GRADIENT_HORIZONTAL)


    oFont := XbpFont():new():create( "12.Arial CE" )
    aAttr := ARRAY( GRA_AS_COUNT )

    GraSetFont( oPS, oFont )

    aAttr [ GRA_AS_COLOR     ] := GRA_CLR_RED
    GraSetAttrString( oPS, aAttr )
    GraStringAt( oPS, {(nSize/2) -(len(ctext) * 9)/2,4}, ctext)
//    GraStringAt( oPS, { 20, 4}, ctext)

    oXbp:unlockPS(oPS)
  endif
return .t.