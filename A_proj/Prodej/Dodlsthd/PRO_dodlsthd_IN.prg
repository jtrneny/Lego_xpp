#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
//
#include "..\Asystem++\Asystem++.ch"


// 1_Bìžná faktura      6_Faktura do EU
// 2_Zálohová faktura   5_Penalizaèní faktura
// 3_Zahranièní faktura 4_Zálohová zahranièní


#define  m_files   {'c_dph','c_meny','firmy','firmyfi','firmyuc','c_staty','kurzit', ;
                    'dodlstit','vyrzak','vyrzakit', 'objitem','cenzboz', 'ucetpol', 'kusov' }

*
** CLASS for PRO_dodlsthd_IN ***************************************************
CLASS PRO_dodlsthd_IN FROM drgUsrClass, FIN_finance_IN, FIN_fakturovat_z_vld, FIN_PRO_fakdol, SYS_ARES_forAll
exported:
  method  init, drgDialogStart, postSave, postDelete, onSave, destroy
  method  overPostLastField, postLastField

  *
  * hlavièka info
  * 1 -bìžná faktura/ 6 -euro faktura
  * 'Bez DpH    <infoval_11>   DpH  <infoval_12> Celkem                               '
  inline access assign method infoval_11 var infoval_11
    return (dodlsthdw->ncendancel +dodlsthdw->nzakldaz_1 +dodlsthdw->nzakldaz_2)
  inline access assign method infoval_12 var infoval_12
    return (dodlsthdw->nsazdan_1 +dodlsthdw->nsazdan_2 +dodlsthdw->nsazdaz_1 +dodlsthdw->nsazdaz_2)

  * položky - bro
  inline access assign method cenPol() var cenPol
    return if(dodlstitw->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method cena_za_mj() var cena_za_mj
    local retval := 0

    retval := if(dodlsthdw->nfintyp > 2 .or. dodlsthdw->nfintyp = 6, ;
              if(dodlsthdw->nfintyp = 4, dodlstitw->ncenzakcel,dodlstitw->ncejprkbz), dodlstitw->ncejprkbz)
    return retval

  inline method eventHandled(nevent,mp1,mp2,oxbp)

    * jedná se o dodací list vystavený v úloze FIN ?
    if dodlsthdw->ncisfak <> 0
      if (nevent = drgEVENT_SAVE .or. nevent = drgEVENT_DELETE)
        ::msg:writeMessage('POZOR, dodací list nelze modifikovat, je vystavený v jiné úloze ...', DRG_MSG_WARNING)
        return .t.
      endif
    endif

    return ::fakdol_handleEvent(nevent,mp1,mp2,oxbp)

  method  showGroup

HIDDEN:
*  var     lVSYMBOL
  var     members_fak, members_pen, members_inf, canBe_save
ENDCLASS


method PRO_dodlsthd_in:init(parent)
  ::drgUsrClass:init(parent)
  *
  (::hd_file   := 'dodlsthdw',::it_file  := 'dodlstitw')
  ::lnewrec    := .not. (parent:cargo = drgEVENT_EDIT)

  ::canBe_save := if( ::lnewRec, .t., fakvysit->(eof()) )

  * základní soubory
  ::openfiles(m_files)

  drgDBMS:open('pvphead',,,,,'pvp_head')
  drgDBMS:open('pvpitem',,,,,'pvp_item')

  * pøednastavení z CFG
  ::lVSYMBOL       := sysconfig('finance:lvsymbol')
  ::SYSTEM_nico    := sysconfig('system:nico'     )
  ::SYSTEM_cdic    := sysconfig('system:cdic'     )
  ::SYSTEM_cpodnik := sysconfig('system:cpodnik'  )
  ::SYSTEM_culice  := sysconfig('system:culice'   )
  ::SYSTEM_cpsc    := sysconfig('system:cpsc'     )
  ::SYSTEM_csidlo  := sysconfig('system:csidlo'   )

  * likvidace
  ::FIN_finance_in:typ_lik := 'poh'

  PRO_dodlsthd_cpy(self)
return self


METHOD PRO_dodlsthd_IN:drgDialogStart(drgDialog)
  local  members  := drgDialog:dialogCtrl:members[1]:aMembers, odrg, groups
  local  fst_item := if(::lnewrec,'ctyppohybu','ccisobj'), pa
  *
  local  ardef    := drgDialog:odbrowse[1]:ardef, npos_isSest, ocolumn

  ::members_fak := {}
  ::members_pen := {}
  pa := ::members_inf := {}

  aeval(members, {|x| if(ismembervar(x,'groups') .and. .not. isnull(x:groups), ;
                        if(x:groups $ '16,25,34', aadd(pa,x), nil),nil) })

  for x := 1 TO Len(members)
    if members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
        members[x]:oXbp:setFontCompoundName(ListAsArray(members[x]:groups)[2])
        members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
      endif
    endif
  next

  *
  ::fin_finance_in:init(drgDialog,'poh',::it_file +'->csklpol',' položku dodacího listu')

  ::cmb_typPoh := ::dm:has(::hd_file +'->ctyppohybu'):odrg

   * cenzboz
  ::cisSklad   := ::dm:get(::it_file +'->ccissklad' , .F.)
  ::sklPol     := ::dm:get(::it_file +'->csklpol'   , .F.)
  * objitem
  ::cislObInt  := ::dm:get(::it_file +'->ccislobint', .F.)
  ::cislPolob  := ::dm:get(::it_file +'->ncislPolob', .F.)
  * vyrzakit
  ::cisZakazi  := ::dm:get(::it_file +'->cciszakazi', .F.)


  for x := 1 to len(members) step 1
    if members[x]:classname() = 'drgPushButton'
      do case
      case isobject(members[x]:oxbp:cargo) .and. members[x]:oxbp:cargo:classname() = 'drgGet'
        odrg := members[x]:oxbp:cargo

      case members[x]:event = 'memoEdit'
        members[x]:isEdit := .f.
      endcase
    else
      odrg := members[x]
    endif

    groups := if( ismembervar(odrg,'groups'), isnull(members[x]:groups,''), '')

    do case
    case empty(groups)
      aadd(::members_fak,members[x])
      aadd(::members_pen,members[x])
    otherwise
      do case
      case('FAK' $ groups)  ;  aadd(::members_fak,members[x])
      case('PEN' $ groups)  ;  aadd(::members_pen,members[x])
      otherwise
        aadd(::members_fak,members[x])
        aadd(::members_pen,members[x])
      endcase
    endcase
  next

  * projka FAKPIHD-DODLSTHD
  ::fin_pro_fakdol:init(drgDialog:udcp)

  * propojka pro ARES
  ::sys_ARES_forAll:init(drgDialog)


  if(::lnewrec, ::comboItemSelected(::cmb_typPoh,0),nil)
  ::df:setNextFocus((::hd_file) +'->' +fst_item,, .T. )

   * úprava pro sloucec isSest vazba na CENZBOZ + KLAKUL(cvysPol = csklPol)
   npos_isSest := ascan(ardef, {|x| x.defName = 'm->isSest'})
   ocolumn    :=  ::brow:getColumn(npos_isSest)

   ocolumn:dataAreaLayout[XBPCOL_DA_FRAMELAYOUT]       := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
   ocolumn:dataAreaLayout[XBPCOL_DA_HILITEFRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
   ocolumn:dataAreaLayout[XBPCOL_DA_CELLFRAMELAYOUT]   := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
   ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]             := GraMakeRGBColor( {221,221,221})

   ocolumn:configure()
   ::brow:refreshAll()
RETURN


method pro_dodlsthd_in:overPostLastField(in_spcykl)
  local  o_nazPol1 := ::dm:has(::it_file +'->cnazPol1')
  local  ucet      := ::dm:get(::it_file +'->cucet'   )
  local  ok
  *
  local  lnewRec  := (::state = 2)
  local  intCount := if( lnewRec, ::ordItem() +1, (::it_file)->nintCount )

  default in_spcykl to .f.

* 2 wds - èást kontrol na množství pøi ukádání položky
  if((::it_file)->(eof()),::state := 2,nil)

  * napøed musíme zkontrolovat NS
  ok := ::c_naklst_vld(o_nazPol1,ucet)
  if .not. ok
    return .f.
  endif

  if .not. ::wds_watch_mnoz( lnewRec, intCount )
    if .not. in_spcykl
      ::df:setNextFocus((::it_file) +'->nfaktmnoz',, .t.)
*-    ::msg:writeMessage('Dispozièní množství je pouze [ NECO ] ...', DRG_MSG_ERROR)
    endif
    return .f.
  endif
return ok


method PRO_dodlsthd_in:postLastField()
  local  isChanged := ::dm:changed()                                  , ;
         file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value
  local  cisZakaz, cisloPvp


  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
    if ::state = 2  ;  if .not. empty(file_iv)
                         ::copyfldto_w(file_iv,::it_file)
                       endif

                       cisZakaz := (::it_file)->ccisZakaz
                       cisloPvp := (::it_file)->ncisloPvp
                       ::copyfldto_w(::hd_file,::it_file)

                       (::it_file)->nintcount  := ::ordItem()+1
                       (::it_file)->ccisZakaz  := cisZakaz
                       (::it_file)->ncisloPvp  := cisloPvp
    endif

    ::itsave()

    if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
    (::it_file)->(flock())
  endif

  (::it_file)->nhmotnost := ((::it_file)->nfaktmnoz * (::it_file)->nhmotnostJ)
  (::it_file)->nobjem    := ((::it_file)->nfaktmnoz * (::it_file)->nobjemJ   )
  pro_ap_modihd('DODLSTHDW')

  ::setfocus(::state)
  ::dm:refresh()
return .t.


method PRO_dodlsthd_IN:postSave()
  local  ok
  *
  local  m_file := upper(left(::hd_file, len(::hd_file)-1))
  local  doklad := (::hd_file)->ndoklad
  *
  local  file_name
  local  cInfo     := 'Promiòte prosím,' +CRLF

  if .not. ::canBe_save
    cInfo += 'tento dodací list byl již fakturován ...' +CRLF +CRLF + ;
             '__data NELZE uložit__'
    fin_info_box( cInfo, XBPMB_CRITICAL )
    return .f.
  endif

  * pøepoèet hlavièky *
  pro_ap_modihd( ::hd_file )

  if ::new_dok
    if .not. fin_range_key(m_file,doklad,,::msg)[1]
      ::df:tabPageManager:toFront(1)
      ::df:setnextfocus(::hd_file +'->ndoklad',,.t.)
      return .f.
    endif
  endif

  *
  ** uložení v trasakci
  ok := PRO_dodlsthd_wrt_inTrans(self)
*  ok := pro_dodlsthd_wrt(self)

  if(ok .and. ::new_dok)
    dodlsthdw->(dbclosearea())
    dodlstitw->(dbclosearea())
    pvpheadw ->(dbclosearea())
    pvpitemw ->(dbclosearea())

    pro_dodlsthd_cpy(self)

    ::brow:refreshAll()

    setAppFocus(::brow)
    ::dm:refresh()

    ::df:tabPageManager:toFront(1)
    ::df:setnextfocus('dodlsthdw->ctyppohybu',,.t.)

  elseif(ok .and. .not. ::new_dok)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return ok


METHOD PRO_dodlsthd_IN:onSave(lIsCheck,lIsAppend)                              // cmp_AS FIN_FAKVYSITw
  LOCAL  dc     := ::drgDialog:dialogCtrl
  LOCAL  cALIAs := ALIAS(dc:dbArea)
  LOCAL  nKOe   := (DODLSTHDw ->nKURZAHMEN /DODLSTHDw ->nMNOZPREP)

  IF !lIsCheck .and. cALIAs = 'DODLSTITW'
    // doplnìní údajù do položek //
    C_DPH ->(mh_SEEK(DODLSTITw ->nPROCDPH,2))
    DODLSTITw ->nKLICDPH := C_DPH ->nKLICDPH
    DODLSTITw ->nNAPOCET := C_DPH ->nNAPOCET
    // pøepoètem hlavièku //
    pro_ap_modihd('DODLSTHDW')
  ENDIF
RETURN .T.


method PRO_dodlsthd_in:postDelete()
  pro_ap_modihd('DODLSTHDW')
return


method PRO_dodlsthd_IN:showGroup()
  local  x, odrg, avars, members := ::df:aMembers
  local  panGroup := if((::hd_file)->nfintyp = 5, 'PEN', 'FAK')

* off
  aeval(members,{|o| ::modi_memvar(o,.f.)})

* on
  members := if( panGroup = 'FAK', ::members_fak, ::members_pen)
  aeval(members,{|o| ::modi_memvar(o,.t.)})

  avars := drgArray():new()
  for x := 1 to len(members) step 1
    if ismembervar(members[x],'ovar') .and. isobject(members[x]:ovar)
      if members[x]:ovar:className() = 'drgVar'
        avars:add(members[x]:ovar,lower(members[x]:ovar:name))
      endif
    endif
  next

  ::df:aMembers := members
  ::dm:vars     := avars

**  ::dm:refresh()
return


*
*****************************************************************
METHOD PRO_dodlsthd_IN:destroy()

  ::wds_disconnect()

  ::drgUsrClass:destroy()
RETURN self