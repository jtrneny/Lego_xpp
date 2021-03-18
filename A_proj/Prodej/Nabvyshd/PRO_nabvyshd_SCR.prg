#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "..\Asystem++\Asystem++.ch"


static function nab_browseContext(obj, ix, nMENU)
return {|| obj:nab_fromContext( ix, nMENU) }


*
** CLASS for PRO_nabvyshd_SCR **************************************************
CLASS PRO_nabvyshd_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked, postDelete
  method  pro_nabvyshd_new_CPY
  method  pro_nabvyshd_vykr
  *
  ** pro nabídku do -> objednávky 1:1
  method  pro_objhead_in
  method  int_cislObint
  method  pro_objhdead_cmp

  var     ldat_HD_to_IT

  class   var cv_prg_filter READONLY


  inline method createContext_ex()
    local  opopUp, x, apos
    local  pa := ::pa_stavDokl
    *
    local  stavDokl := nabvyshd->cstavDokl

    opopUp := XbpImageMenu( ::drgDialog:dialog ):new()
    opopUp:barText := 'stav dokladu'
    opopUp:create()

    for x := 1 to len(pa) step 1
      opopup:addItem( {pa[x,2]                        , ;
                       nab_BrowseContext(self,x,pA[x]), ;
                                                      , ;
                       XBPMENUBAR_MIA_OWNERDRAW         }, ;
                       if( stavDokl = pa[x,1], 500, 0)     )
    next

     apos     := ::drgPush:oXbp:currentPos()
     apos_parent := ::drgPush:oXbp:parent:currentPos()

     opopup:popup( ::drgPush:oxbp:parent, { apos[1] -30, apos[2] } )
  return self

  inline method nab_fromContext(aorder,p_popUp,apos)
    local  nsel
    local  ctitle := 'Zmìna stavu dokladu ...'
    local  cinfo  := 'Promiòte prosím,'                    +CRLF + ;
                     'požadujete ZMÌNIT stav dokladu ... ' +CRLF + CRLF

    if ::popState <> aorder

      nsel := confirmBox( , cInfo         , ;
                            ctitle        , ;
                            XBPMB_YESNO   , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

      if nsel = XBPMB_RET_YES
        ::popState := aorder

        if( nabvyshd->(RLock()), nabvyshd->cstavDokl := p_popUp[1], nil )
        nabvyshd->(dbUnLock())
      endif

    endif
  return self


  * bro nabvyshd
  inline access assign method nazFirmy() var nazFirmy
    local  ky := nabvyshd ->ncisfirmy
    firmy->(dbseek(ky,,'FIRMY1'))
    return firmy->cnazev

  inline access assign method nabVyshd_obj() var nabVyshd_obj
    local  retVal := 0
    local  cky    := strZero(nabVyshd->ndoklad,10)
    return if( objit_sHD->( dbseek( cky,, 'OBJITE37')), MIS_ICON_OK, 0)


  * bro nabvysit
  inline access assign method nabVysit_obj() var nabVysit_obj
    local  retVal := 0
    local  cky    := strZero(nabVysit->ndoklad,10) +strZero(nabvysit->nintCount,5)
    return if( objit_sIT->( dbseek( cky,, 'OBJITE37')), MIS_ICON_OK, 0)

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

  * nabvyshd
  inline access assign method stav_nabvyshd() var stav_nabvyshd
    local retVal := 0
//    local doklad := strZero(nabvyshd->ndoklad,10)
    *
//    local s_0    := objit_sth->(dbseek(doklad +'0'))
//    local s_1    := objit_sth->(dbseek(doklad +'1'))
//    local s_2    := objit_sth->(dbseek(doklad +'2'))

//    do case
//    case( .not. s_1 .and. .not. s_2)            ;  retVal := 0
//    case( .not. s_0 .and. .not. s_1) .and. s_2  ;  retVal := 302
//    otherwise                                   ;  retVal := 303
//    endcase
    return retVal

/*
    do case
    case(nabvyshd->nmnozplodb = 0                   )  ;  retVal := 301
    case(nabvyshd->nmnozplodb >= nabvyshd->nmnozobodb)  ;  retVal := 302
    case(nabvyshd->nmnozplodb <  nabvyshd->nmnozobodb)  ;  retVal := 303
    endcase
    return retVal
*/

  * objitem
  inline access assign method stav_objitem() var stav_objitem
    local retVal := 0
    *
//    local stav_fakt := objitem->nstav_fakt

//    do case
//    case( stav_fakt = 1 )  ;  retVal := 303
//    case( stav_fakt = 2 )  ;  retVal := 302
//    endcase
    return retVal

/*
    do case
    case(objitem->nmnozplodb = 0                   )  ;  retVal := 301
    case(objitem->nmnozplodb >= objitem->nmnozobodb)  ;  retVal := 302
    case(objitem->nmnozplodb <  objitem->nmnozobodb)  ;  retVal := 303
    endcase
    return retVal
*/

  * fakvysit
  inline access assign method stav_fakvysit() var stav_fakvysit
    local retVal := 0

//    if fakvyshd->(dbseek(fakvysit->ncisfak,,'FODBHD1'))
//      do case
//      case(fakvyshd->nuhrcelfak = 0                    )  ;  retVal := 301
//      case(fakvyshd->nuhrcelfak >= fakvyshd->ncenzakcel)  ;  retVal := H_big
//      case(fakvyshd->nuhrcelfak <  fakvyshd->ncenzakcel)  ;  retVal := H_low
//      endcase
//    endif
    return retVal

//  inline access assign method datvys_fakvysit() var datvys_fakvysit

//    fakvyshd->(dbseek(fakvysit->ncisfak,,'FODBHD1'))
//    return fakvyshd->dvystFak

  * objzak
//  inline access assign method stav_objzak_naz() var stav_objzak_naz
//    vyrzak->(dbseek(upper(objzak->cciszakaz),,'VYRZAK1'))
//    return vyrzak->cnazevzak1

//  inline access assign method stav_objzak_plm() var stav_objzak_plm
//    return vyrzak->nmnozplano

HIDDEN:
  var     msg, dm, dc, df, ab
  var     tabnum, brow
  var     drgPush, popState, pa_stavDokl


  method  nabvyshd_cpy
ENDCLASS


method PRO_nabvyshd_SCR:init(parent)
  local  pa_initParam

  ::drgUsrClass:init(parent)
  *
  ::tabnum        := 1
  ::lnewRec       := .f.
  ::cv_prg_filter := ''

  drgDBMS:open('objitem',,,,,'objit_sHD')
  drgDBMS:open('objitem',,,,,'objit_sIT')
  *
  drgDBMS:open( 'nabvyshd',,,,,'nabhd_iw' )
  drgDBMS:open( 'nabvyshd',,,,,'nabhd_cpw')
  drgDBMS:open( 'firmy'   )
  drgDBMS:open( 'c_staty' )
  drgDBMS:open( 'vyrpol'  )
  *
  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2

    ::cv_prg_filter := pa_initParam[2]
    ::drgDialog:set_prg_filter(pa_initParam[2], 'nabvyshd')
  endif

return self


method PRO_nabvyshd_SCR:drgDialogStart(drgDialog)
  local  x
  local  members := drgDialog:oActionBar:Members, cevent
  *
  local  odesc, pa, pa_it := {},  pa_quick := {{ 'Kompletní seznam       ', ''                 } }

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataManager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

  ::brow     := drgDialog:dialogCtrl:oBrowse
  ::popState := 1

  for x := 1 TO LEN(members) step 1
    do case
    case members[x]:ClassName() = "drgPushButton"
       cevent  := isNull(members[x]:event  , '' )
      if( cevent = 'createContext_ex',  ::drgPush := members[x], nil )
    endcase
  next

  if isObject( odesc := drgRef:getRef( 'cstavDokl' ))
    pa := listAsArray( odesc:values )

    aeval( pa, {|x| ( pb := listAsArray(x, ':'), aadd( pa_it, {allTrim(pb[1]) +' ', '(' +allTrim(pb[1]) +') _' +pb[2]} ) ) } )
  endif

  ::pa_stavDokl := pa_it

  aeval( pa_it, { |x| aadd( pa_quick, { x[2], format( "cstavDokl = '%%'", {x[1]} ) } ) })
  ::quickFiltrs:init( self, pa_quick, 'stavNabídky' )

return


method PRO_nabvyshd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
return .t.


method PRO_nabvyshd_SCR:itemMarked()
  local  mky := nabvyshd->ndoklad
  local  cf  := "cnazOdes = '%%'"

  nabvysit->( AdsSetOrder( 'NABVYSI8' ), dbsetScope( SCOPE_BOTH,mky),dbgotop())

  filter := format( cf, {nabVyshd->cnazOdes} )
  objitem->( ads_setAof(filter), dbgoTop())
return self


method PRO_nabvyshd_SCR:postDelete()
  local  nsel, nodel := .f.
  *
  local  cdoklad := allTrim( str( nabvyshd->ndoklad))

  if nabvyshd->ndoklad <> 0
    nsel := ConfirmBox( ,'Požadujete zrušit nabídku vystavenou _' +cdoklad +'_', ;
                         'Zrušení nabídky vystavené ...' , ;
                          XBPMB_YESNO                     , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      pro_nabvyshd_cpy(self)
      nodel := .not. pro_nabvyshd_del(self)
      *
      nabvyshdw->(dbclosearea())
       if( select('objitemw') <> 0, objitemw->(dbclosearea()), nil )
        if( select('objit_iw') <> 0, objit_iw->(dbclosearea()), nil )
    else
      nodel := .f.
    endif
  endif

  if nodel
    ConfirmBox( ,'Nabídku vystavenou _' +cdoklad +'_' +' nelze zrušit ...', ;
                 'Zrušení nabídky vystavené ...' , ;
                 XBPMB_CANCEL                       , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
**  postAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp)
return .not. nodel


method  PRO_nabvyshd_SCR:pro_nabvyshd_new_CPY()
  local  odialog, nexit := drgEVENT_QUIT
  local  o_nabvysit_in
  local  arSelect       := aclone( ::brow[1]:arselect)
  *
  local  doklad, datOdes
  local  pa_firmy := {}, pa_it, nstep_hd, nstep_it
  local  cInfo          := 'Promiòte prosím,' +CRLF

  if( len(arSelect) <> 0, aadd( arSelect, nabvyshd->(recNo())), nil )

  ::lnewRec             := .t.
  ::drgDialog:cargo_usr := 'cpy'
  o_nabvysit_in := pro_nabvyshd_in():new( ::drgDialog )

  * nabídky vystavené
  drgDBMS:open('NABVYSHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('NABVYSITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRPOLw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP


  * oznaèil si záznamy pro kopii
  * musíme zkontrolovat zda se jedná i stejnou firmu
  if len(arSelect) <> 0
    nabhd_cpw->(ads_setAof('.F.'))
    nabhd_cpw->(ads_customizeAOF(arSelect), dbgotop())

    do while .not. nabhd_cpw->(eof())
      if( npos := ascan( pa_Firmy, {|x| x[1] = nabhd_cpw->ncisFirmy })) = 0
        aadd( pa_Firmy, { nabhd_cpw->ncisFirmy   , ;
                          nabhd_cpw->cnazev      , ;
                          nabhd_cpw->(recNo())   , ;
                          { nabhd_cpw->ndoklad } } )
      else
        aadd( pa_Firmy[npos,4], nabhd_cpw->ndoklad )
      endif
      nabhd_cpw->(dbskip())
    enddo

    if len(pa_Firmy) > 1
      cinfo += 'máte oznaèené nabídky pro rùzné firmy ...' +CRLF
      aeval( pa_Firmy, { |x| cinfo += str(x[1]) +'_' +x[2] +CRLF }, 1, 2 )

      cinfo += if( len(pa_Firmy) > 2, ' ... ' +CRLF, '' )
      cinfo += CRLF +'požadujete vytvoøit jejich kopie ?' +CRLF

      nsel := confirmBox( , cinfo                           , ;
                           'Vytvoøit více kopií nabídky ...', ;
                            XBPMB_YESNO                     , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)
    endif
  endif

  nabvyshdw->(dbAppend())
  nabvyshdw->ddatOdes := date()

  odialog := drgDialog():new('PRO_nabvyshd_new_cpy',::drgDialog)
  odialog:create(,,.T.)
  nexit   := odialog:exitState

  datOdes := odialog:dataManager:get('nabVysHdw->ddatOdes')

  *
  ** holt chce kopii
  if nexit = drgEVENT_EXIT

    * hlavièka nabídky
    for nstep_hd := 1 to len(pa_Firmy) step 1

      nabvyshd->(dbgoto( pa_Firmy[nstep_hd, 3]))

      ::nabvyshd_cpy( datOdes, pa_Firmy[nstep_hd,4], o_nabvysit_in)

      PRO_nabvyshd_wrt_inTrans( self )
    next
  endif

  nabvyshdw ->(dbclosearea())
  nabvysitw ->(dbclosearea())
  vyrpolw   ->(dbclosearea())

  ::brow[1]:oxbp:refreshAll()
  postAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp)

  o_nabvysit_in:destroy()
  odialog:destroy()

  ::lnewRec             := .f.
  ::drgDialog:cargo_usr := nil
return self


method pro_nabvyshd_scr:nabvyshd_cpy( datOdes, pa_nabvysit, o_nabvysit_in)
  local  nstep_it, nintCount := 1

  mh_copyFld('nabvyshd', 'nabvyshdw', .t., .t. )

  * modifikace nabvyshdw
  nabvyshdw->ndoklad    := fin_range_key('NABVYSHD')[2]
  nabvyshdw->ddatodes   := datOdes
  nabvyshdw->cintpracov := logOsoba
  nabvyshdw->_nrecor    := 0

  o_nabvysit_in:int_cislNabidky(.f., .t.)

  * pro nápoèet z položek
  nabvyshdw ->ncenZakCel := ;
   nabvyshdw ->ncenDanCel := ;
    nabvyshdw ->nhodnSlev  := ;
     nabvyshdw ->nhmotnost  := ;
      nabvyshdw ->nobjem     := 0

  *
  ** pololožky nabídek / nabídky
  for nstep_it := 1 to len(pa_nabvysit) step 1

    nabvysit->( dbsetScope( SCOPE_BOTH, pa_nabvysit[nstep_it]),dbgotop())

    do while .not. nabvysit->(eof())
      mh_copyFld( 'nabvysit', 'nabvysitw', .t., .t.)

      nabvysitw->cfile_iv   := ''
      nabvysitw->nrecs_iv   := 0

      * vazba na vyrpol
      ky := upper(nabvysit->ccisZakaz) +upper(nabvysit->cvyrPol) +strZero(nabvysit->nvarCis,3)
      if vyrpol->(dbseek( ky,, 'VYRPOL1'))
        nabvysitw->cfile_iv   := 'vyrpol'
        nabvysitw->nrecs_iv   := vyrpol->(recNo())
      endif

      * modifikace nabvysitw
      nabvysitw->ndoklad   := nabvyshdw->ndoklad
      nabvysitw->cnazOdes  := nabvyshdw->cnazOdes
      nabvysitw->ncisOdes  := nabvyshdw->ncisOdes
      nabvysitw->nintCount := nintCount
      nabvysitw->_nrecor   := 0

      * nápoèty do hlavièky
      nabvyshdw ->ncenZakCel += nabvysitw ->ncenZakCel
      nabvyshdw ->ncenDanCel += nabvysitw ->ncenZakCeD
      nabvyshdw ->nhodnslev  += nabvysitw ->ncelkSlev
      nabvyshdw ->nhmotnost  += nabvysitw ->nhmotnost
      nabvyshdw ->nobjem     += nabvysitw ->nobjem

      * položka nabídky je vystavená z vyrzak, musí se vytvoøit vazby
      if lower(nabvysitw->cfile_iv) = 'vyrzak'
        vyrzak->(dbgoto( nabvysitw->nrecs_iv))
        o_nabvyshd_in:vyr_vyrpol_sel()
      endif

      nintCount++
      nabvysit->(dbskip())
    enddo
  next
return self


*
** bacha tohle je blina zkopírovanaá z objednávek
method  PRO_nabvyshd_SCR:pro_nabvyshd_vykr()
  local  anObj := {}

  FORDrec({'objitem'})

  objitem->( dbeval( {|| aadd( anObj, objitem->(recNo())) }), dbgoTop())

  if nabvyshd->(sx_rLock()) .and. objitem->(sx_rLock(anObj))
   if drgIsYesNo( drgNLS:msg('Opravdu požadujete ruèní vykrytí objednávky ?') )

     do while .not. objitem ->(eof())
       objitem->nmnozPLodb := objitem->nmnozOBodb
       objitem->nmnoz_fakt := objitem->nmnozOBodb
       objitem->nstav_fakt := 2
       objitem->ddatRvykr  := date()

       objitem->(dbskip())
     enddo
     nabvyshd->nmnozPLodb := nabvyshd->nmnozOBodb
     nabvyshd->ddatRvykr  := date()

   endif
  endif

  nabvyshd->(dbunlock(), dbcommit())
   objitem ->(dbunlock(), dbcommit())
    FORDrec()

  ::brow[1]:oxbp:refreshCurrent()
  postAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp)
return

*
** pro nabídku do -> objednávky 1:1
method PRO_nabvyshd_scr:PRO_objhead_in(drgDialog)
  local  dokladn, ncislPOLob := 1
  local  cky
  *
  local  nsel, zprava := 'Byla VYTVOØENA objednávka pøijatá cèíslo ->'
  local  ctitle := 'Vytvoøení objednávky z nabídky vystavené ...'
  local  cinfo  := 'Promiòte prosím,'                                         +CRLF + ;
                   'požadujete GENEROVAT objednávku z nabídky vystavené ... ' +CRLF + CRLF


  nsel := confirmBox( , cInfo         , ;
                        ctitle        , ;
                        XBPMB_YESNO   , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

  if nsel = XBPMB_RET_YES

    firmy->(dbseek(nabvyshd ->ncisfirmy,,'FIRMY1'))
    ::lnewRec       := .t.
    ::ldat_HD_to_IT := .f.

    drgDBMS:open( 'c_typuhr')
    drgDBMS:open( 'objhead' )
    drgDBMS:open( 'objitem' )
    drgDBMS:open( 'cenZboz' )
    drgDBMS:open( 'objhead',,,,,'objhd_iw' )
    *
    * objednávky pøijaté
    drgDBMS:open('OBJHEADw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('OBJITEMw',.T.,.T.,drgINI:dir_USERfitm); ZAP

    mh_copyFld( 'nabVyshd', 'objHeadW', .t. )

    doklad := fin_range_key('OBJHEAD')[2]

    ( objheadw->culoha     := 'P'                           , ;
      objheadW->ctask      := 'PRO'                         , ;
      objheadW->ctypDoklad := 'PRO_OBPR'                    , ;
      objheadW->ctypPohybu := 'OBJPRIJ'                     , ;
      objheadw->ndoklad    := doklad                        , ;
      objheadw->ddatobj    := date()                        , ;
      objheadw->ddatdoodb  := date()                        , ;
      objheadw->ddatodvvyr := date()                        , ;
      objheadw->czkratmeny := sysconfig('finance:czaklmena'), ;
      objheadw->cintpracov := logOsoba                      , ;
      objheadw->nextObj    := 1                               )

    nabVysit->( dbgoTop())
    do while .not. nabVysit->( eof())

      cky  := nabVysit->ccisSklad + nabVysit->csklPol
      cenzboz->( dbseek(upper(cky),,'CENIK03'))

      mh_copyFld('nabVysit', 'objitemW', .t. )

      ( objitemW->culoha     := 'P'                  , ;
        objitemW->ctask      := 'PRO'                , ;
        objitemW->ctypDoklad := 'PRO_OBPR'           , ;
        objitemW->ctypPohybu := 'OBJPRIJ'            , ;
        objitemW->nextObj    := 1                    , ;
        objitemw->ncislPOLob := ncislPOLob           , ;
        objitemw->ctypSKLpol := cenZboz->ctypSKLpol  , ;
        objitemw->CucetSkup  := cenZboz->cucetSkup   , ;
        objitemW->ddatObj    := date()               , ;
        objitemW->nmnozOBodb := nabvysit->nmnozNOdes , ;
        objitemW->nmnozNEodb := nabvysit->nmnozNOdes , ;
        objitemW->nkcsBDobj  := nabvysit->ncenZAKcel , ;
        objitemW->nkcsZDobj  := nabvysit->ncenZAKceD , ;
        objitemW->ncenaDLodb := nabvysit->ncenJEDzak , ;
        objitemW->nucetSkup  := cenZboz ->nucetSkup  , ;
        objitemW->ndokladNav := nabvyshd->ndoklad    , ;
        objitemW->ncountNav  := nabvysit->nintCount    )

        objitemw->_nrecor    := 0
        objitemw->nrecs_iv   := cenZboz->( recNo())

      ncislPOLob++
      nabVysit->( dbskip())
    enddo

    objheadW->( dbcommit())
    objitemW->( dbcommit())

    ::pro_objhdead_cmp()           // pøepoèet hlavièky

    pro_objhead_wrt_inTrans(self)  // uložení dokladu
    *
    ** konec
    objheadW->(dbclosearea())
    objitemW->(dbclosearea())
    ::lnewRec  := .f.

    drgMsgBox(drgNLS:msg(zprava +str(objhead->ndoklad) ), XBPMB_INFORMATION)

    if( nabvyshd->(RLock()), nabvyshd->cstavDokl := 'O', nil )
        nabvyshd->(dbUnLock())

    ::brow[1]:oxbp:refreshCurrent()
    ::brow[2]:oxbp:goTop():refreshAll()
  endif

return self


method PRO_nabvyshd_scr:pro_objhdead_cmp()

  objheadw->nkcsbdobj := ;
   objheadw->nkcszdobj := ;
    objheadw->nkcszdobjz := ;
     objheadw->nmnozobodb := ;
      objheadw->nmnozpoodb := ;
       objheadw->nmnozneodb := ;
        objheadw->nhodnslev  := ;
         objheadw->npocpolobj := objheadw->nhmotnost := objheadw->nobjem := 0

  objitemW->( dbgoTop())

  do while .not. objitemW->(eof())
    objheadw->nkcsbdobj  += objitemW->nkcsbdobj
    objheadw->nkcszdobj  += objitemW->nkcszdobj

    c_typuhr ->( dbseek(objheadw->czkrtypuhr))
    objheadw->nkcszdobjz := mh_roundnumb(objheadw->nkcszdobj, c_typuhr->nkodzaokr)

    objheadw->nmnozobodb += objitemW->nmnozobodb
    objheadw->nmnozpoodb += objitemW->nmnozpoodb
    objheadw->nhmotnost  += objitemW->nhmotnost
    objheadw->nobjem     += objitemW->nobjem

    objheadw->nmnozneodb := (objheadw ->nmnozobodb -objheadw ->nmnozpoodb)
    objheadw->nhodnslev  := objitemW->ncelkslev
    objheadw->npocpolobj++

    objitemW->(dbskip())
  enddo
return nil


method PRO_nabvyshd_scr:int_cislObint(in_wrt)
  local  m_filter := "ncisfirmy = %%", filter

  default in_wrt to .f.

  filter := format( m_filter, {objheadw->ncisFirmy})
  objhd_iw->(AdsSetOrder('OBJHEAD1'), ads_setAof(filter), dbGoBottom())

  objheadw->ncislObint := objhd_iw->ncislobint +1
  objheadw->ccislObint := left(firmy->cnazev,4)       +'-' + ;
                          strzero(firmy->ncisfirmy,5) +'/' + ;
                          strzero(objheadw->ndoklad,10)
  objhd_iw->(ads_clearAof())
return