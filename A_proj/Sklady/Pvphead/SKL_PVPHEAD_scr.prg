#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


#define  nbmp_FAKVYSHD       551            // F_big_new.bmp
#define  nbmp_DODLSTHD       550            // D_big_new.bmp
#define  nbmp_POKLHD         560            // P_big_new.bmp
*
#define  nbmp_PVPHEAD_PREV   MIS_ICON_ERR   // ERR.bmp   301



class skl_datainfo
exported:

  var  cfile_hd, cfile_it, NEWhd
  var  ok, ntypPoh, ntypPvp
  var  lwatchPrij

  inline method init( cfile_hd, cfile_it, NEWhd )
    local lwatchPrij := sysConfig('SKLADY:lwatchPrij')

    ::NEWhd      := NEWhd
    ::cfile_hd   := lower(cfile_hd)
    ::cfile_it   := lower(cfile_it)
    *
    ** Hlídat príjmové položky na datum a cas proti výdeji ANO/NE, default bude ANO,
    ::lwatchPrij := if( isLogical(lwatchPrij), lwatchPrij, .t. )

    *
    ** pro kontrolu na parenta dokladu
    drgDBMS:open('c_typPoh',,,,,'c_typPoh_i')

    drgDBMS:open('DodLstHd')
    drgDBMS:open('FakVysHd')
    drgDBMS:open('PoklHd'  )
  return self


  inline method canBe_append()
    local  cobdobi := uctObdobi:SKL:cOBDOBI

    if .not.(::ok := ::ucuzav( cobdobi ))
       ConfirmBox( ,'Pracujete v uzavøeném úèetním období doklad nelze založit ...', ;
                    'Nelze založit doklad ...'     , ;
                    XBPMB_CANCEL                   , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
    endif
  return ::ok

  inline method canBe_edit()
    local  ctypDoklad := (::cfile_hd)->ctypDoklad, ;
           ctypPohybu := (::cfile_hd)->ctypPohybu

    ::ok := .t.

    if ( ::pvphead_mainTask = nbmp_PVPHEAD_PREV )
       ::ok := .f.
        ConfirmBox( ,'Pohyb (' +allTrim(ctypPohybu) +') je modifikován automatizovanì ' +CRLF + ;
                    '             - pøi opravì pohybu -      '                          +CRLF + ;
                    '      ... pøevod mezi sklady/støedisky ... '                            , ;
                    'Nelze opravit doklad ...'        , ;
                     XBPMB_CANCEL                   , ;
                     XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
    endif
  return ::ok


  inline method pvphead_canBe_Delete()
    local  cobdobi    := (::cfile_hd)->cobdobi
    local  ctypDoklad := (::cfile_hd)->ctypDoklad, ;
           ctypPohybu := (::cfile_hd)->ctypPohybu

    if( select('cenZboz') = 0, drgDBMS:open('cenZboz'), nil )
    if( select('vyrCis' ) = 0, drgDBMS:open('vyrCis' ), nil )

    ::ok      := .t.
    ::ntypPoh := (::cfile_hd)->ntypPoh
    ::ntypPvp := (::cfile_hd)->ntypPvp

    do case
    case  ::ucuzav( cobdobi )
      ::ok := .f.
      ConfirmBox( ,'Pracujete v uzavøeném období doklad nelze zrušit ...', ;
                   'Nelze zrušit doklad ...'       , ;
                    XBPMB_CANCEL                   , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    case ( ::pvphead_mainTask = nbmp_PVPHEAD_PREV )
       ::ok := .f.
       ConfirmBox( ,'Pohyb (' +allTrim(ctypPohybu) +') je modifikován automatizovanì ' +CRLF + ;
                    '             - pøi opravì pohybu -      '                         +CRLF + ;
                    '      ... pøevod mezi sklady/støedisky ... '                            , ;
                    'Nelze rušit doklad ...'        , ;
                     XBPMB_CANCEL                   , ;
                     XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )


    case ( ::pvphead_mainTask = nbmp_FAKVYSHD .or. ;
           ::pvphead_mainTask = nbmp_DODLSTHD .or. ;
           ::pvphead_mainTask = nbmp_POKLHD        )

      ::ok := .f.
      ConfirmBox( ,'Snažíte se zrušit, '                          +CRLF       + ;
                   'automaticky generovaný doklad ...'            +CRLF +CRLF + ;
                   '      ... NELZE ZRUšIT DOKLAD ...   '                     , ;
                   'Nelze rušit doklad ...'      , ;
                    XBPMB_CANCEL                 , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    case ( ::ntypPvp = 4 )          // pøecenìní je secifikum, doklad nelze zrušit ani modifikovat
      ::ok := .f.
      ConfirmBox( ,'Snažíte se zrušit, '                          +CRLF       + ;
                   'doklad o pøecenìní ceníku zboží ...'          +CRLF +CRLF + ;
                   '      ... NELZE ZRUšIT DOKLAD ...   '                     , ;
                   'Nelze rušit doklad ...'      , ;
                    XBPMB_CANCEL                 , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    endcase

    if ::ok
      if ( .not. ::canBe_hd_modi() .and. ::lwatchPrij )
        ::ok := .f.
        ConfirmBox( ,'Doklad nelze zrušit, '                         +CRLF       + ;
                     'existují již pozdejší výdejky na položku  ...' +CRLF +CRLF + ;
                     '      ... NELZE ZRUšIT DOKLAD ...   '                      , ;
                    'Nelze rušit doklad ...'      , ;
                     XBPMB_CANCEL                 , ;
                     XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
      endif
    endif

  return ::ok


  inline method canBe_Save()
    local  cobdobi := uctObdobi:SKL:cOBDOBI

    ::ok := .t.

    do case
    case ::ucuzav( cobdobi )
      ::ok := .f.
      ConfirmBox( ,'Pracujete v uzavøeném skladovém/úèetním období doklad nelze uložit ...', ;
                   'Nelze uložit doklad ...'       , ;
                    XBPMB_CANCEL                   , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    case ( ::pvphead_mainTask = nbmp_FAKVYSHD .or. ;
           ::pvphead_mainTask = nbmp_DODLSTHD .or. ;
           ::pvphead_mainTask = nbmp_POKLHD        )

      ::ok := .f.
      ConfirmBox( ,'Snažíte se uložit, '                          +CRLF       + ;
                   'automaticky generovaný doklad ...'            +CRLF +CRLF + ;
                   '      ... NELZE ULOŽIT DOKLAD ...   '                     , ;
                   'Nelze uložit doklad ...'     , ;
                    XBPMB_CANCEL                 , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
    endCase

    if ::ok
      if ( .not. ::canBe_hd_modi() .and. ::lwatchPrij )
        ::ok := .f.
        ConfirmBox( ,'Doklad nelze uložit, '                         +CRLF       + ;
                     'existují již pozdejší výdejky na položku  ...' +CRLF +CRLF + ;
                     '      ... NELZE ULOŽIT DOKLAD ...   '                      , ;
                    'Nelze uložit doklad ... '    , ;
                     XBPMB_CANCEL                 , ;
                     XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
      endif
    endif

  return ::ok


*  fakVyshd.FODBHD1 cisFak
*  dodLsthd.DODLHD1 cisloDl
*  poklHd.POKLHD3   cisFak
  inline access assign method pvphead_mainTask() var pvphead_mainTask
    local  retVal    := 0
    local  subTask   := upper( (::cfile_hd)->csubTask )
    local  cisloDl   := (::cfile_hd)->ncisloDl, ;
           cisFak    := (::cfile_hd)->ncisFak , ;
           dokladVyd := (::cfile_hd)->ndokladVyd
    *
    local  ctypDoklad := (::cfile_hd)->ctypDoklad, ;
           ctypPohybu := (::cfile_hd)->ctypPohybu


    do case
    * FIN    - FAKVYSHD faktura vystavená skladová
    *        - generuje DODLSTHD a Nx pvpHead pro ccisSklad
    *        - na PVPHEAD je ncisloDl <> 0 a ncisFak <> 0
    *
    case ( subTask = 'FIN' )
      retVal := nbmp_FAKVYSHD                                                   // F_big_new.bmp

    *
    * PRO    - DODLSTHD dodací list skladový/ POKLHD registraèní pokladna
    *        - generuje Nx pvpHead pro ccisSklad
    *        - pokud na PVPHEAD je ncisloDl <> 0 a ncisFak  = 0 -> DODLSTHD
    *        - pokud na PVPHEAD je ncisloDl = 0  a ncisFak <> 0 -> POKLHD
    *        ? na POKLHD se nevím proè strká ncisFak do ncisloDl ?
    *
    case ( subTask = 'PRO' )
      do case
      case dodLstHd->( dbseek( cisloDl,,'DODLHD1'))  ;  retVal := nbmp_DODLSTHD // D_big_new.bmp
      case poklHd  ->( dbseek( cisFak ,,'POKLHD3'))  ;  retVal := nbmp_POKLHD   // P_big_new.bmp
      endcase

    *
    * SKL    - pro nové doklady pøevodu se plní pro pøíjmový doklad
    *        - u starých je prázdný
    *
    case ( subTask = 'SKL' .or. empty(subTask) )
      do case
      case ( subTask = 'SKL' .and. dokladVyd <> 0)
        retVal := nbmp_PVPHEAD_PREV                                             // ERR.bmp   301

      case ( ctypDoklad = 'SKL_PRE305' .and. ctypPohybu = '40' )
        retVal := nbmp_PVPHEAD_PREV                                             // ERR.bmp   301
      endcase
    endcase
  return retVal

  inline method show_mainTask()
    local  retVal   := '', cky
    local  ncisloDl := (::cfile_hd)->ncisloDl, ;
           ncisFak  := (::cfile_hd)->ncisFak

    do case
    case ( ::pvphead_mainTask = nbmp_FAKVYSHD )
      if fakVysHd->( dbseek( ncisFak,,'FODBHD1' ))
        cky := upper(fakVysHd->culoha) +upper(fakVysHd->ctypdoklad) +upper(fakVysHd->ctyppohybu)

        if  c_typPoh_i->(dbseek(cky,,'C_TYPPOH05'))
          retVal := c_typPoh_i->cnazTYPpoh +' ( ' +str(ncisFak,10) +' )'
        endif
      endif

    case ( ::pvphead_mainTask = nbmp_DODLSTHD )
      if dodLstHd->( dbseek( ncisloDl,,'DODLHD1' ))
        cky := upper(dodLstHd->culoha) +upper(dodLstHd->ctypdoklad) +upper(dodLstHd->ctyppohybu)

        if  c_typPoh_i->(dbseek(cky,,'C_TYPPOH05'))
          retVal := c_typPoh_i->cnazTYPpoh +' ( ' +str(ncisloDl,10) +' )'
        endif
      endif

    case ( ::pvphead_mainTask = nbmp_POKLHD   )
      if poklHd->( dbseek( ncisFak,,'POKLHD3' ))
        cky := upper(poklHd->culoha) +upper(poklHd->ctypdoklad) +upper(poklHd->ctyppohybu)

        if  c_typPoh_i->(dbseek(cky,,'C_TYPPOH05'))
          retVal := c_typPoh_i->cnazTYPpoh +' ( ' +str(ncisFak,10) +' )'
        endif
      endif

    endCase
  return retVal


  inline access assign method pvphead_existVn() var pvphead_existVn
    local  nutneVN
    local  retVal  := 0

    if isCharacter(::cfile_hd)
      nutneVN := (::cfile_hd)->nnutneVNzm +(::cfile_hd)->nnutneVN
      retVal  := if( nutneVN <> 0, 565, 0 )      // Vn.
    endif
   return retVal


  inline access assign method pvpitem_isOk() var pvpitem_isOk
    local typSklCen, typPvp, typPoh
    local cky, retVal := 0, lok := .t.

    if isCharacter(::cfile_hd)

      if( select('cenZbozA') = 0, drgDBMS:open( 'cenZboz',,,,, 'cenZbozA' ), nil )
      if( select('pvpitemA') = 0, drgDBMS:open( 'pvpitem',,,,, 'pvpitemA' ), nil )

      typPvp := (::cfile_hd)->ntypPvp
      typPoh := (::cfile_it)->ntypPoh  // na pvpitem +1 / -1

      if lower(::cfile_hd) = 'pvphead'
        cenZbozA->( dbseek( upper((::cfile_it)->ccisSklad) +upper((::cfile_it)->csklPol),,'CENIK03'))
        typSklCen := cenZbozA->ctypSKLcen
      else
        typSklCen := (::cfile_it)->ctypSKLcen
      endif

      if (( typPvp = 1 .or. typPvp = 3 ).and. typSklCen = 'PRU' )

        if typPvp = 1
          cky := upper( (::cfile_it)->ccisSklad) +upper( (::cfile_it)->csklPol)
        else
          cky := if( typpoh = 1, upper( (::cfile_it)->ccisSklad) +upper( (::cfile_it)->csklPol), ;
                                 upper( (::cfile_it)->cskladKAM) +upper( (::cfile_it)->csklPolKAM) )
        endif

        if .not. empty((::cfile_it)->dpohPvp)
          pvpitemA->( ordSetFocus( 'PVPITEM21'), dbsetScope(SCOPE_BOTH, cky +'-1'), dbgoBottom() )
          lok := if( pvpitemA->( eof()), .t., ;
                   ( (::cfile_it)->dpohPvp > pvpitemA->dpohPvp ) .or. ;
                   ( (::cfile_it)->dpohPvp = pvpitemA->dpohPvp  .and. val( strTran( (::cfile_it)->ccasPvp,':')) >= val( strTran(pvpitemA->ccasPvp, ':' )) ) )
          pvpitemA->( dbclearScope() )
        endif

        *
        ** SCR
        if lower(::cfile_hd) = 'pvphead'
          retVal := if( lok, if( ::pvphead_existVn = 0, 556, 555 ), 558 )       // 555 - žlutá, 556 - zelená, 558 - èervená
        else
          retVal := if( lok, if( ::pvphead_existVn = 0, 556, 555 ), 558 )       // 555 - žlutá, 556 - zelená, 558 - èervená
        endif

      endif
    endif
  return retVal


  inline access assign method pvpitem_datPoh() var pvpitem_datPoh
    local  retVal := space(20)

    if isCharacter(::cfile_it)
      retVal :=  dtoc( (::cfile_it)->ddatPvp) +' ' +(::cfile_it)->ccasPvp
    endif
  return retVal


  inline access assign method pvpitem_lastVyd() var pvpitem_lastVyd
    local  typPvp, typPoh
    local  retVal := space(30)

    if isCharacter(::cfile_hd)
      if( select('pvpitemA') = 0, drgDBMS:open( 'pvpitem',,,,, 'pvpitemA' ), nil )

      typPvp := (::cfile_hd)->ntypPvp
      typPoh := (::cfile_it)->ntypPoh  // na pvpitem +1 / -1

      if typPvp = 1 .or. typPvp = 2
        cky := upper( (::cfile_it)->ccisSklad) +upper( (::cfile_it)->csklPol)
      else
        cky := if( typpoh = 1, upper( (::cfile_it)->ccisSklad) +upper( (::cfile_it)->csklPol), ;
                               upper( (::cfile_it)->cskladKAM) +upper( (::cfile_it)->csklPolKAM) )
      endif

      pvpitemA->( ordSetFocus( 'PVPITEM21'), dbsetScope(SCOPE_BOTH, cky +'-1'), dbgoBottom() )

      retVal :=  str( pvpitemA->ndoklad,10) +' ' +dtoc( pvpitemA->dpohPvp) +' ' +pvpitemA->ccasPvp
      pvpitemA->( dbclearScope() )
    endif
  return retVal


hidden:

  inline method ucuzav( cobdobi )
    local lzavr_uc := .f., cky_uc := 'U' +cobdobi
    local lzavr_hd := .f., cky_hd := 'S' +cobdobi

    if( select('ucetSys') = 0, drgDBMS:open('ucetSys'), nil )

    ucetSys->( dbseek( cky_uc,,'UCETSYS2'))
      lzavr_uc := ucetsys->lzavren

    ucetSys->( dbseek( cky_hd,,'UCETSYS2'))
      lzavr_hd := ucetsys->lzavren
   return ( lzavr_uc .or. lzavr_hd )


   inline method canBe_hd_modi()
     local  recNo := (::cfile_it)->( recNo())
     local  lok   := .t.

     (::cfile_it)->( dbgoTop())
     begin sequence
       do while .not. (::cfile_it)->(eof())
         if ::pvpitem_isOk() = 558
           lok := .f.
     break
         endif
         (::cfile_it)->(dbskip())
       enddo
     end sequence

     (::cfile_it)->( dbgoto( recNo))
   return lok


   inline method canBe_it_del()
     local lok_mn := .t., cky_it, nnnozPRdod

     (::cfile_it)->( dbgoTop())
     do while .not. (::cfile_it)->( eof())
       cky_it     := upper( (::cfile_it)->ccisSklad) +upper( (::cfile_it)->csklPol )
       nmnozPRdod := (::cfile_it)->nmnozPRdod * ::ntypPoh

       if cenZboz->( dbseek( cky_it,,'CENIK03'))
         lok_mn := if( nmnozPRdod <= cenZboz->nmnozSzbo, lok_mn, .f. )
       endif

       (::cfile_it)->( dbskip())
     enddo
   return lok_mn

endClass

*
** spoleèné funkce pro zobrazení stavu úèetní uzávìrky a stavu likvidace pvpHead/pvpItem
** FRM --> skl_pohyby_crd, skl_pvpHead_scr, skl_pvpItem_scr
function isUctovano( nIDcol, cFILE)
  local  nkLikvid := (cFILE)->nkLikvid, nzLikvid := (cFILE)->nzLikvid
  local  retVal := 0

  retval := if((nkLikvid =  0 .and. nzLikvid = 0) .or. (nkLikvid <> 0 .and. nzLikvid = 0), 0, ;
            if (nkLikvid = nzLikvid, L_big, L_low))
return retval

function isucUzav( cfile )
  local  cobdobi := (cfile)->cobdobi

  if( select('ucetSys') = 0, drgDBMS:open('ucetSys'), nil )

  ucetSys->( dbseek( 'U' +cobdobi,,'UCETSYS2' ))
  if  ucetsys->lzavren
    return U_big
  endif

  ucetSys->( dbseek( 'S' +cobdobi,,'UCETSYS2' ))
  if  ucetsys->lzavren
    return U_low
  endif
return 0



********************************************************************************NEW
* SKL_PVPHEAD_SCR ... Pohybové doklady - dle dokladù
********************************************************************************
CLASS SKL_PVPHead_SCR FROM drgUsrClass, skl_datainfo
EXPORTED:
  var     NEWhd
  VAR     parentFRM
  VAR     cfg_cDenik, cVarSym
  METHOD  Init, drgDialogStart, drgDialogEnd, HeadMarked, ItemMarked, EventHandled, tabSelect
  METHOD  PARUJ_VS_PRIJEM, PARUJ_VS_VYDEJ


  inline access assign method is_evidvyrCis() var is_evidvyrCis
    local  pa_vyrCis := { 'A', 'B', 'C' }, npos
    local  retVal    := 0
    local  cky       := upper(pvpitem->ccisSklad) +upper(pvpitem->csklPol)

    if cenZboz_ow->( dbseek( cky,,'CENIK12'))
      vyrCis := cenZboz_ow->cvyrCis
      if ( npos := ascan( pa_vyrCis, vyrCis )) <> 0
        retVal := 560 +npos
      endif
    endif
  return retVal

  inline method info_in_msgStatus()
    local  msgStatus := ::msg:msgStatus, picStatus := ::msg:picStatus
    local  ncolor, cinfo, oPs
    *
    local  curSize  := msgStatus:currentSize()
    local  paColors := { { graMakeRGBColor( {  0, 183, 183} ), graMakeRGBColor( {174, 255, 255} ) }, ;
                         { graMakeRGBColor( {255, 255,  13} ), graMakeRGBColor( {255, 255, 166} ) }, ;
                         { graMakeRGBColor( {251,  51,  40} ), graMakeRGBColor( {254, 183, 173} ) }  }
    *
    local  cmainTask := ::show_mainTask()

    msgStatus:setCaption( '' )
    picStatus:hide()

    if .not. empty(cmainTask)
      ncolor := 2
      cinfo  := cmainTask

      oPs := msgStatus:lockPS()
      GraGradient( oPs, {  0, 0 }    , ;
                        { curSize }, paColors[ncolor], GRA_GRADIENT_HORIZONTAL )
      graStringAT( oPs, { 20, 4 }, cinfo )
      msgStatus:unlockPS()

      picStatus:setCaption(DRG_ICON_MSGWARN)
      picStatus:show()
    endif
  return


HIDDEN:
  VAR     dc, df, msg
  var     tabNum, abMembers
  var     obtn_PARUJ_VS_PRIJEM, obtn_PARUJ_VS_VYDEJ

  INLINE METHOD  UcetPol_Item()
    UCETPOL->( mh_ClrScope(),;
               mh_SetScope(Upper( ::cfg_cDenik) + StrZero( PVPITEM->nDoklad, 10) + StrZero( PVPITEM->nOrdItem, 5 )))
  RETURN self

  INLINE METHOD  UcetPol_Doklad()
    UCETPOL->( mh_ClrScope(),;
               mh_SetScope(Upper( ::cfg_cDenik) + StrZero( PVPITEM->nDoklad, 10)))
  RETURN self


  inline method postDelete()
    local  nsel, nodel := .f.
    local  cc := space(20) +if( pvpHead->ntypPvp = 1, '_ PØÍJEM _', ;
                              if( pvpHead->ntypPvp = 2, '_ VÝDEJ _', '_ PØEVOD _' ))


    if ::pvphead_canBe_Delete()
      nsel := ConfirmBox( ,'Požadujete zrušit doklad èíslo _' +alltrim(str(pvpHead->ndoklad)) +'_' +CRLF +CRLF +cc, ;
                           'Zrušení skladového dokladu ...' , ;
                            XBPMB_YESNO                    , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

      if nsel = XBPMB_RET_YES
        skl_pvpHead_cpy(self)
        nodel := .not. skl_pvpHead_del(self)
      endif
    else
      nodel := .f.
    endif

    if nodel
      ConfirmBox( ,'Doklad èíslo _' +alltrim(str(pvpHead->ndoklad)) +'_' +' nelze zrušit ...', ;
                   'Zrušení skladového dokladu ...' , ;
                   XBPMB_CANCEL                     , ;
                   XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
    endif

    ::drgDialog:dialogCtrl:refreshPostDel()
  return .not. nodel

ENDCLASS

*
********************************************************************************
METHOD SKL_PVPHead_SCR:init(parent)
  *
  ::drgUsrClass:init(parent)
  drgDBMS:open('PVPITEM')
  drgDBMS:open('PVPHEAD')
  drgDBMS:open('C_DRPOHY')
  drgDBMS:open('C_DPH')
  drgDBMS:open('C_TYPPOH')
  drgDBMS:open('VYRCIS')
  drgDBMS:open('CENZBOZ')
  *
  ** evidence výrobních èísel na pvpItem cenZboz
  drgDBMS:open( 'cenZboz',,,,,'cenZboz_ow' )
  *
  ** položky dokladu pøevodu KAM 80 -> 40
  drgDBMS:open( 'pvpitem',,,,,'pvpitem_40' )

  ::NEWhd      := .f.
  ::parentFRM  := parent:parent:formName
  ::cfg_cDenik := Padr( AllTrim( SysConfig( 'Sklady:cDenik')),2)
  ::cVarSym    := ''

  ::skl_datainfo:init( 'pvpHead', 'pvpItem', .f. )
RETURN self

********************************************************************************
METHOD SKL_PVPHead_SCR:drgDialogStart(drgDialog)
  local  x

  ::dc        := drgDialog:dialogCtrl              // dataCtrl
  ::df        := drgDialog:oForm                   // form
  ::msg       := drgDialog:oMessageBar             // messageBar

  ::abMembers := drgDialog:oActionBar:Members
  *
*  ::msg:can_writeMessage := .f.
*  ::msg:msgStatus:paint  := { |aRect| ::info_in_msgStatus(aRect) }
  *
  ColorOfTEXT( ::dc:members[1]:aMembers )

  for x := 1 to len(::abMembers) step 1
    if isCharacter(::abMembers[x]:event)
      do case
      case ::abMembers[x]:event $ 'PARUJ_VS_PRIJEM' ; ::obtn_PARUJ_VS_PRIJEM := ::abMembers[x]
      case ::abMembers[x]:event $ 'PARUJ_VS_VYDEJ'  ; ::obtn_PARUJ_VS_VYDEJ  := ::abMembers[x]
      endcase
    endif
  next

  ::tabNum := 1
  * Pohyby  jsou volány tlaèítkem pohyby z obrazovky ceníku zboží
  IF ::parentFRM = 'skl_cenzboz_scr'
    PVPITEM->( DbClearRelation())
  endif
  *
  PVPHEAD->( DbSetRelation( 'C_TypPoh', { || UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU) },;
                                            'UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU)', 'C_TYPPOH06'))
  PVPITEM->( DbSetRelation( 'C_DPH', { || PVPITEM->nKlicDPH },'PVPITEM->nKlicDPH'))
  PVPITEM ->( AdsSetOrder( 'PVPITEM02'))
RETURN


METHOD SKL_PVPHEAD_SCR:drgDialogEnd(drgDialog)

  IF ::parentFRM = 'skl_cenzboz_scr'
    PVPITEM->( DbClearRelation())
    PVPITEM->( DbSetRelation( 'C_DRPOHY', { || PVPITEM->nCislPoh } ,'PVPITEM->nCislPoh' ))
    PVPITEM->( DbSetRelation( 'PVPHEAD',  { || PVPITEM->nDoklad }  ,'PVPITEM->nDoklad' ))
  ENDIF
RETURN self


METHOD SKL_PVPHead_SCR:HeadMarked()
  Local lOk       := PVPHEAD->nTypPoh <> 1
  Local lPrijem   := PVPHEAD->nTypPoh = 1, lVydej := PVPHEAD->nTypPoh = 2
  local cmainTask
  *
  local cf := "ndokladVyd = %%", filter_40

  PVPITEM ->( mh_SetScope( Upper( PVPHEAD->cCisSklad) + StrZERO(PVPHEAD->nDoklad,10)) )

  filter_40 := format(cf, { pvphead->ndoklad })
  pvpitem_40->( ads_setAof(filter_40), dbgoTop() )

  IF( ::tabNum = 4, ::UcetPol_Item(), ::UcetPol_Doklad() )
  *
  do case
  case lPrijem
    ::obtn_PARUJ_VS_PRIJEM:oxbp:enable()
    ::obtn_PARUJ_VS_VYDEJ:oxbp:disable()
  case lVydej
    ::obtn_PARUJ_VS_PRIJEM:oxbp:disable()
    ::obtn_PARUJ_VS_VYDEJ:oxbp:enable()
  otherwise
    ::obtn_PARUJ_VS_PRIJEM:oxbp:disable()
    ::obtn_PARUJ_VS_VYDEJ:oxbp:disable()
  endcase

  *
  ::info_in_msgStatus()
RETURN SELF


METHOD SKL_PVPHead_SCR:ItemMarked()
  ::UcetPol_Item()
  *
RETURN SELF

********************************************************************************
METHOD SKL_PVPHead_SCR:tabSelect( tabPage, tabNumber)
  *
  ::tabNUM := tabNumber
  IF( ::tabNum = 4, ::UcetPol_Item(),;
  IF( ::tabNum = 5, ::UcetPol_Doklad(), NIL))
RETURN .T.

********************************************************************************
METHOD SKL_PVPHead_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  *

  DO CASE
    CASE nEvent = drgEVENT_APPEND
      IF  Skl_allOK( .T. ,, 'PVPHEAD', 'PVPITEM' )
        RETURN .F.
      ENDIF

    CASE nEvent = drgEVENT_DELETE
      if( isNull(pvpHead->sID,0) <> 0, ::postDelete(), nil )

    CASE nEvent = drgEVENT_EDIT
      return .not. ::canBe_edit()

    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_PVPHead_SCR:Paruj_VS_PRIJEM()
  Paruj_VS( ::drgDialog, 'SKL_PAROVANI_VSprijem')
RETURN self

********************************************************************************
METHOD SKL_PVPHead_SCR:Paruj_VS_VYDEJ()
  Paruj_VS( ::drgDialog, 'SKL_PAROVANI_VSvydej')
RETURN self

*===============================================================================
FUNCTION Paruj_VS( dialog, cNameFRM)
  LOCAL oDialog, nExit

*  oDialog := drgDialog():new('SKL_PAROVANI_VS', dialog)
  oDialog := drgDialog():new(cNameFRM, dialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  oDialog:destroy(.T.)
  oDialog := Nil

RETURN NIL


********************************************************************************
* SKL_PVPITEM_SCR ... Pohybové doklady - dle položek
********************************************************************************
CLASS SKL_PVPItem_SCR FROM drgUsrClass, skl_datainfo
EXPORTED:
  VAR     cfg_cDenik
  METHOD  Init, drgDialogStart, EventHandled, itemMarked, tabSelect
HIDDEN
  VAR     dc, tabNum
ENDCLASS

*****************************************************************
METHOD SKL_PVPItem_SCR:init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('PVPITEM')
  drgDBMS:open('PVPHEAD')
  drgDBMS:open('C_DRPOHY')
  drgDBMS:open('C_DPH')
  drgDBMS:open('C_TYPPOH')
  *
  ::cfg_cDenik := SysConfig( 'Sklady:cDenik')
  *
  PVPITEM->( DbSetRelation( 'C_DRPOHY', { || PVPITEM->nCislPoh },'PVPITEM->nCislPoh'))
  PVPITEM->( DbSetRelation( 'C_DPH', { || PVPITEM->nKlicDPH },'PVPITEM->nKlicDPH'))
  PVPITEM->( AdsSetOrder('PVPITEM05'))
  PVPHEAD->( DbSetRelation( 'C_TypPoh', { || UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU) },;
                                            'UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU)', 'C_TYPPOH06'))
RETURN self

********************************************************************************
METHOD SKL_PVPItem_SCR:drgDialogStart(drgDialog)

  ::dc  := drgDialog:dialogCtrl
  ::skl_datainfo:init( 'pvpHead', 'pvpItem', .f. )

  ColorOfTEXT( ::dc:members[1]:aMembers )
  ::tabNum := 1
RETURN

********************************************************************************
METHOD SKL_PVPItem_SCR:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE nEvent = drgEVENT_DELETE
     X := 1
    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_PVPItem_SCR:ItemMarked()
  Local cKey := Upper( ::cfg_cDenik) + StrZero( PVPITEM->nDoklad, 10)
  *
  cKey += IF( ::tabNum = 2, StrZero( PVPITEM->nOrdItem, 5 ), '' )
  UCETPOL->( mh_ClrScope())
  IF ::tabNum = 2 .or. ::tabNum = 4
     UCETPOL->( mh_SetScope( cKey))
  ENDIF
  PVPHead->( dbSeek( PVPITEM->nDoklad,, 'PVPHEAD01'))
RETURN SELF

********************************************************************************
METHOD SKL_PVPItem_SCR:tabSelect( tabPage, tabNumber)
  *
  ::tabNUM := tabNumber
  ::itemMarked()
RETURN .T.