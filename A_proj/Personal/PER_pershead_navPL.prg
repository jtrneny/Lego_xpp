#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
//
#include "dbstruct.ch"
#include "..\Asystem++\Asystem++.ch"


static anODB

*
**
static function dbro_record(cVarName,cfile)
  LOCAL aIVar, oClass, nAttr

  oClass := ClassObject(cVarName)

  IF oClass <> NIL
    RETURN oClass                 // Class already exists
  ENDIF

  nAttr   := CLASS_EXPORTED + VAR_INSTANCE
  aIVar   := AEval( (cfile)->(DbStruct()), {|a| a:={a[1], nAttr} } ,,, .T.)
  nAttr   := CLASS_EXPORTED + METHOD_INSTANCE
return classCreate( cVarName,, aIVar )


static function GetRecord( oRecord,cfile)
  local astru := (cfile)->(dbstruct())

  aeval(astru,{|a,i| orecord:&(a[1]) := (cfile)->(fieldget(i)) })
return oRecord
**
*

class per_cmp_navrhPL
exported:
  var  nrangeNAV, ddatNAV_od, ddatNAV_do
  var  cond_inRange, caof_persitem, caof_persitem_new

  inline method init()

    ::nrangeNav  := 60                    // bude to CFG - parametr
    ::ddatNAV_od := ctod( '18.11.2017' )  //date()
    ::ddatNAV_do := ::ddatNAV_od + ::nrangeNav

     * lekProhl
    drgDBMS:open('c_lekpro')
    drgDBMS:open('c_lekari')

    * skoleni
    drgDBMS:open('c_skolen')
    drgDBMS:open('c_skolit')

    drgDBMS:open('persitem')
    drgDBMS:open('lekprohl',,,,,'lekprohl_S')   // lekprohl pro návrh plánu
    drgDBMS:open('skoleni' ,,,,,'skoleni_S' )   // skoleni  pro návrh plánu

    drgDBMS:open('c_persAKCw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('persHeadW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('persitemW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  return self

  *
  ** pøepoèítáme návrh plánu školení/lékProhlídek na základì nastavení ddatDO_od - ddatDO_do
  inline method cmp_navrhPL()
    local  dposlAkc, nperioda, ncmp, ddatPREDko, nstav_Pol, czkratka, block
    local  cond_inRange := "( " +::cond_inRange +" ) .and. nstav_Pol <> 1"
    *
    local  m_file, c_file, c_fileTag, c_posl, c_peri, c_typPoh, c_cisLS, c_tagLS, c_zkrat, cfile_iv
    local  pa        := { { 'lekProhl_S', 'c_lekpro', 'C_LEKPRO01', 'lekProhl_S->dposlLEKpr', 'lekProhl_S->nperioOpak', 'c_lekari', 'C_LEKARI01', 'lekProhl_S->czkratka' }, ;
                          { 'skoleni_S' , 'c_skolen', 'C_SKOLEN01', 'skoleni_S->dposlSKOLE' , 'skoleni_S->nperioOpak' , 'c_skolit', 'C_SKOLIT01', 'skoleni_S->czkratka'  }  }

*    block := &( "{|ddatPREDko| " + ::cond_inRange +"}" )
    block := &( "{|ddatPREDko,nstav_Pol| " + cond_inRange +"}" )

    persitemW  ->( dbZap())
    c_persAKCw ->( dbZap())


    for x := 1 to len(pa) step 1
      m_file    := pa[x,1]
      c_file    := pa[x,2]
      c_fileTag := pa[x,3]
      c_posl    := pa[x,4]
      c_peri    := pa[x,5]
      c_cisLS   := pa[x,6]
      c_tagLS   := pa[x,7]
      c_zkrat   := pa[x,8]
      cfile_iv  := upper(strTran( m_file, '_S', '' ))
      c_typPoh  := strTran( m_file, '_S', '' )

      (m_file)->( dbgoTop())

      do while .not. (m_file)->( eof())
        dposlAkc := DBGetVal( c_posl )
        nperioda := DBGetVal( c_peri )
        czkratka := DBGetVal( c_zkrat)
        ncmp     := ( round( ( year(::ddatNAV_od) -year(dposlAkc) ) / nperioda, 0 ) * nperioda ) * 365

        ddatPREDko := dposlAkc + ncmp
        nstav_Pol  := (m_file)->nstav_Pol

        if( eval(block, ddatPREDko, nstav_Pol) .and. if( empty(persHeadW->czkratka), .t., Equal(czkratka, persHeadW->czkratka)) )

          mh_copyFld( m_file, 'persitemW', .t. )
          persitemW->ddatPREDko := dposlAkc + ncmp
          persitemW->ctypPohybu := c_typPoh
          persitemW->ctypAkce   := c_typPoh
          persitemW->cfile_iv   := cfile_iv
          persitemW->nfile_iv   := (m_file)->sID

          (c_file)->(dbseek( upper( (m_file)->czkratka),,c_fileTag))
          persitemW->cnazevT_LS := (c_file)->cnazev
          persitemW->czkratk_LS := if( x = 1, (m_file)->cZkratLeka, (m_file)->cZkratSkol )
          persitemW->cnazev_LS  := if( x = 1, (m_file)->cNazevLeka, (m_file)->cNazevSkol )

          (c_cisLS)->( dbseek( upper(persitemW->czkratk_LS),,c_tagLS))
          persitemW->codborn_LS := if( x = 1, (c_cisLS)->cOdbornLek, (c_cisLS)->cLektor )

          if .not. c_persAKCw->( dbseek( upper( (m_file)->czkratka),,'c_perAkcW1'))
            (c_file)->(dbseek( upper( (m_file)->czkratka),,c_fileTag))
            mh_copyFld( c_file, 'c_persAKCw', .t. )
            c_persAKCw->ctypAkce := c_typPoh
            c_persAKCw->ndelka   := 1
          else
            c_persAKCw->ndelka   += 1
          endif
        endif

        (m_file)->( dbskip())
      enddo
    next
  return self

endClass


*
** CLASS for PER_pershead_navPL ***********************************************
CLASS PER_pershead_navPL from drgUsrClass, per_cmp_navrhPL
EXPORTED:
  var  odata

  inline method init(parent)
    local nin

    ::drgUsrClass:init(parent)
    ::per_cmp_navrhPL:init()

    ::tabNum     := 1
    anODB        := {}

    ::odata         := dbro_record( 'dbro_persitemW', 'persitemW' ):new()
    ::caof_persitem := format( "ddatPREDko >= '%%' and ddatPREDko <= '%%'", {::ddatNAV_od, ::ddatNAV_do} )
    ::cond_inRange  := "ddatPREDko >= ctod('" +dtoc(::ddatNAV_od) +"') .and. " +"ddatPREDko <= ctod('" +dtoc(::ddatNAV_do) +"')"
    ::cmp_navrhPL()
  return self


  inline method drgDialogStart(drgDialog)
    local  x, members  := drgDialog:oForm:aMembers

    ::msg      := drgDialog:oMessageBar             // messageBar
    ::dm       := drgDialog:dataManager             // dataManager
    ::dc       := drgDialog:dialogCtrl              // dataCtrl
    ::df       := drgDialog:oForm                   // form

    ::oDBro_main        := drgDialog:dialogCtrl:oBrowse[1]
    ::oDBro_c_persAKCw  := drgDialog:dialogCtrl:oBrowse[2]
    ::oget_ddatNAV_od   := ::dm:has('M->ddatNAV_od'):odrg
    ::oget_ddatNAV_do   := ::dm:has('M->ddatNAV_do'):odrg

    BEGIN SEQUENCE
      FOR x := 1 TO LEN(members)
        IF members[x]:ClassName() = 'drgDBrowse'
      BREAK
        ENDIF
      NEXT
    ENDSEQUENCE

    drgDialog:oForm:nextFocus := x
  return self


  inline method postValidate(drgVar)
    local  value  := drgVar:get()
    local  name   := lower(drgVar:name)
    local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')
    local  ok     := .T., changed := drgVAR:changed()
    *
    local  nevent := mp1 := mp2 := nil, isF4 := .F.
    * F4
    nevent  := LastAppEvent(@mp1,@mp2)
    If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


    if ( name = 'm->ddatnav_od' .or. name = 'm->ddatnav_do' )

      if( name = 'm->ddatnav_od', ::ddatNAV_od := value, ::ddatNAV_do := value )
      *
      ** od - do nemùže být prázdné
      if ( name = 'm->ddatnav_do' )
        if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
          if ( empty(::ddatNAV_od) .and. empty(::ddatNAV_do) )
            ::ddatNAV_od := date()
            ::oget_ddatNAV_od:ovar:set(::ddatNAV_od )

            ::ddatNAV_do := ::ddatNAV_od + ::nrangeNav
            ::oget_ddatNAV_do:ovar:set(::ddatNAV_do )
          endif
        endif
      endif


      do case
      case( .not. empty(::ddatNAV_od) .and.       empty(::ddatNAV_do) )
        ::caof_persitem_new := format( "ddatPREDko >= '%%'", {::ddatNAV_od} )
        ::cond_inRange      := "ddatPREDko >= ctod('" +dtoc(::ddatNAV_od) +"')"

      case(       empty(::ddatNAV_od) .and. .not. empty(::ddatNAV_do) )
        ::caof_persitem_new := format( "ddatPREDko <= '%%'", {::ddatNAV_do} )
        ::cond_inRange      := "ddatPREDko <= ctod('" +dtoc(::ddatNAV_do) +"')"

      otherwise
        if( ::ddatNAV_od > ::ddatNAV_do )
          ::ddatNAV_do := ctod('  .  .  ')
          ::oget_ddatNAV_do:ovar:set(::ddatNAV_od )
        else
          ::caof_persitem_new := format( "ddatPREDko >= '%%' and ddatPREDko <= '%%'", {::ddatNAV_od, ::ddatNAV_do} )
          ::cond_inRange      := "ddatPREDko >= ctod('" +dtoc(::ddatNAV_od) +"') .and. " +"ddatPREDko <= ctod('" +dtoc(::ddatNAV_do) +"')"
        endif
      endcase

      if ( name = 'm->ddatnav_do' )
        if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
          if ::caof_persitem <> ::caof_persitem_new
             ::caof_persitem := ::caof_persitem_new

             persitem->( ads_setAof(::caof_persitem_new), dbgotop())
             ::cmp_navrhPL()
             ::oDBro_main:oxbp:refreshAll()
           endif
         endif
       endif

    endif
  return ok


  inline method tabSelect(oTabPage,tabNum)
    local  oxbp := if( tabNum = 1, ::oDBro_main:oxbp, ::oDBro_c_persAKCw:oxbp )

    if ( tabNum = 1 .and. ::tabNum = 2 )
      persitemW->( ads_clearAof())
    endif

    ::tabNum := tabNum
    postAppevent( xbeBRW_ItemMarked,,, oxbp )
   return .t.


  inline method itemMarked(arowCol,unil,oxbp)
    local  cfile
    local  cf := "ctypAkce = '%%' and czkratka = '%%'", filter

     if ::tabNum = 2
      if isObject(oxbp)
         cfile := lower(oxbp:cargo:cfile)

         if cfile = 'c_persakcw'
           filter := format( cf, { c_persAKCw->ctypAkce, c_persAKCw->czkratka } )
           persitemW->( ads_setAof(filter), dbgoTop())
         endif
      endif
    endif
  return self


  * BUTTONky
  inline  method PER_pershead_in(drgDialog)
    local  oxbp_Bro := if( ::tabNum = 1, ::oDBro_main:oxbp, ::oDBro_c_persAKCw:oxbp )
    local  oThread
    local  nevent, mp1 := NIL, mp2 := NIL, oXbp := NIL

    local astru := persitemW->(dbstruct()), orecord := ::odata

    aeval(astru,{|a,i| orecord:&(a[1]) := persitemW->(fieldget(i)) })

    oThread       := drgDialogThread():new()
    oThread:start( ,'PER_pershead_in', ::drgDialog, .t.)

    do while .not. ( nEvent = drgDIALOG_END )
      nEvent := AppEvent( ,,,0 )
    endDo

    * ? uložil plán, je potøeba pøebudovat návrh
    PostAppEvent(drgEVENT_SAVE,,, oxbp_Bro )
  return .t.

  
  inline method onSave(lOk,isAppend,oDialog)
    local  oxbp_Bro  := if( ::tabNum = 1, ::oDBro_main:oxbp, ::oDBro_c_persAKCw:oxbp )
    local  nstav_Pol := ::odata:nstav_Pol

    if nstav_Pol = 1
      ::cmp_navrhPL()
      oxbp_Bro:refreshAll()
      postAppevent( xbeBRW_ItemMarked,,, oxbp_Bro )

      ::odata:nstav_Pol := 0
    endif
  return .t.


HIDDEN:
  var  msg, dm, dc, df
  var  oDBro_main, oDBro_c_persAKCw, oget_ddatNAV_od, oget_ddatNAV_do
  var  tabNum

ENDCLASS