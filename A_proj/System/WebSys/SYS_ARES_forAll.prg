#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
#include "asxml.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "..\Asystem++\Asystem++.ch"

*  rozšíøit from FIR_firmy_ARES
*  v drgDialogStart
*  ::FIR_firmy_ARES:init(drgDialog)

#pragma library("asxml10.lib")
#pragma library("ot4xb.lib"  )

*
** pomocné funkce pro ARES *****************************************************
**
function SYS_ares_Test()   // test konektnutí na WEB na naše ICO
  local  ccnbHost, cares_UTF8
  local  lok := .f.

  ccnbHost   := "http://wwwinfo.mfcr.cz/cgi-bin/ares/darv_bas.cgi?ico=63488931"
  cares_UTF8 := loadFromUrl(ccnbHost)

  lok := ( at( '<are:Odpoved>', isNull(cares_UTF8, '')) <> 0 )
return lok


function SYS_ares_allToC( xVal, nlen)
  Local  cTyp := ValType( xVal)
  Local  cVal

  cVal := If( cTyp == 'L', If( xVal, 'Aktivní', 'NeAktivní' ) , ;
            If( cTyp == 'D', DToC( xVal)                      , ;
              If( cTyp == 'N', StrZero( xVal, nlen), xVal   ) ) )
return(allTrim(cVal))


function  SYS_ares_Miss(cContent, cvazba_Cis)
  local  pa, cfile, ctag, citem
  local  xval := ''

  pa := listAsArray(cvazba_Cis)
  cfile := pa[1]
  ctag  := pa[2]
  citem := pa[3]

  drgDBMS:open(cfile)
  (cfile)->(dbseek( upper(cContent),,ctag))
  xVal := DBGetVal( cfile +'->' +citem )
return xval


*
** prg je urèen pro kontrolu ARES kde je na vstupu nICO
*
** class for SYS_ARES_forAll ***************************************************
class SYS_ARES_forAll
exported
  var   m_File
  var   is_activeAres, pa_ares, dm
  var   nico, oxbp_nico, odrg_zkratStat

  var   hd_file, lnewRec

  inline method init(drgDialog)
    local  x, odrg, pa_ares
    local  members := drgDialog:oForm:amembers

    ::dm       := drgDialog:dataManager             // dataMananager

    ::m_Dialog := drgDialog
    ::m_udcp   := drgDialog:udcp

    ::hd_file  := ::m_udcp:hd_file
    ::lnewRec  := ::m_udcp:lnewRec
    ::pa_Ares  := {}

    ::nico            := ::dm:get(::hd_file +'->nico' )
    ::oxbp_nico       := ::dm:has(::hd_file +'->nico'):odrg:oxbp
    ::oxbp_nico:paint := { |apos, uNUL, obj| ::ares_postValid(obj) }

    ::odrg_zkratStat  := ::dm:has(::hd_file +'->czkratStat')

    ::is_activeAres :=  if( sysconfig('system:lares'), SYS_ares_Test(), .f.)


    drgDBMS:open('c_ares')
    ::pa_Ares := pa_ares := {}
    *  3-odpovedAres, 4- odrGet, 5-oxbpStaic, 6-c_ares->mpoznamka
    c_ares->( dbEval( { || aadd( pa_ares, { allTrim(c_ares->ctag_Name), allTrim(c_ares->cfield), '' , , ,c_ares->mares_Miss } ) } ))

    for x := 1 TO LEN(members) step 1
      odrg := members[x]

      if odrg:ClassName() = 'drgGet'
        field_Name := upper(drgParseSecond(odrg:name, '>'))
        if( nin := ascan( pa_ares, { |x| upper(x[2]) = field_Name } )) <> 0
          ::pa_ares[nin,4] := odrg

          apos  := members[x]:oxbp:currentPos()
          asize := members[x]:oxbp:currentSize()
          obord := members[x]:oxbp:parent
          oinfo := XbpStatic():new(obord,,{apos[1] +asize[1] +2,apos[2] +4},{13,13} ,, .f.)
          oinfo:type    := XBPSTATIC_TYPE_ICON // XBPSTATIC_TYPE_RECESSEDBOX
          oinfo:caption := 462                 // 'x'
          oinfo:create()

          oinfo:RbClick := {|aPos, uNIL, obj| ::firmy_fixValue(obj)}

          ::pa_ares[nin,5] := oinfo
        endif
      endif
    next

    if ::is_activeAres
      if( .not. ::lnewRec, ::firmy_Ares(), nil )
      ::firmy_infoAres()
    endif
  return self


  inline method ares_postValid(obj)
    local  nico := ::dm:get(::hd_file +'->nico')

    if ::nico <> nico .and. ::is_activeAres
      ::firmy_Ares()
      ::firmy_infoAres()

      ::nico := nico
    endif
  return self

  *
  ** naèteme ARES pro nICO
  inline method firmy_Ares()
    local  cdir_Rsrc := drgINI:dir_RSRC
    local  ctmp_Dir, cxml_File
    *
    local  ccnbHost, cares_UTF8, nTarget, cBuffer, nBytes
    local  cico := str(::dm:get(::hd_file +'->nico'))
    *
    local  nXMLDoc, nTag

    ctmp_Dir  := drgINI:dir_USERfitm +userWorkDir() +'\'
    cxml_File := ctmp_Dir +"odpoved_ares_bas.xml"
    *
    ** pokud neexistuje musíme ho založit a naèíst odpovìï pokut to jde
    myCreateDir( ctmp_Dir )
    ccnbHost   := "http://wwwinfo.mfcr.cz/cgi-bin/ares/darv_bas.cgi?ico=" +cico
    cares_UTF8 := loadFromUrl(ccnbHost)

    // sránka nenalezena, není pøipojení k internetu
    if isCharacter(cares_UTF8) .and. left(cares_UTF8,13) <> '<?xml version'
      // chyba asi hlášku a ven ???
    else
      nTarget := FCreate(cxml_File )
      cBuffer := cares_UTF8
      nBytes  := Len(cBuffer)
      FWrite( nTarget, Left(cBuffer, nBytes) )
      FClose( nTarget )
      *
      * ok jedeme
      nXMLDoc   := XMLDocOpenFile(cxml_File)
      nTag      := XMLDocGetRootTag(nXMLDoc)

      ::firmy_getAres(nTag)

      XMLDocClose(nXMLDoc)
    endif
  return self

  *
  ** firmyW - errAres
  inline access assign method firmy_errAres() var firmy_errAres
    local  nin, pa := ::pa_Ares, cErr := ''
    local  otxt_errAres

    if isNull(::is_activeAres, .f.)
      nin   := ascan( ::pa_ares, { |x| x[1] = 'D:ET' } )
      cErr  := if( ::is_czechRep, ::pa_ares[nin,3], '... zahranièní firma ...' )

      if isObject(::dm)
         otxt_errAres := ::dm:has('M->firmy_errAres')
         if isObject(otxt_errAres)
           otxt_errAres:odrg:oxbp:setFontCompoundName('11.Arial CE')
           otxt_errAres:odrg:oXbp:setColorFG(GRA_CLR_RED)
         endif
      endif
    endif
  return cErr
  *
  ** opravíme ARES pokud to jde
  inline method firmy_fixValue(oxbp)

    if ::is_activeAres .and. empty( ::firmy_errAres)

       if( oXbp:className() = 'XbpStatic' .and. oxbp:type = XBPSTATIC_TYPE_ICON )
         if( nin := ascan( ::pa_ares, { |x| x[5] = oxbp } )) <> 0
           if oxbp:caption = DRG_ICON_MSGWARN .or. oxbp:caption = DRG_ICON_MSGERR
             drgVar := ::pa_ares[nin,4]:ovar
             drgVar:set(::pa_ares[nin,3])
             eval(drgVar:block,drgVar:value)
             drgVar:initValue := drgVar:value
             ::firmy_infoAres()
           endif
         endif
       endif
     endif
   return .t.
   *
   ** pøebereme co se dá z ARESu do záznamu, ale jen u FIRMY
   inline method firmy_takeAres()
    local  nin, cerr := '', pa := ::pa_Ares, x, odrg
    *
    local  nsel
    local  ctitle := 'Chybné IÈO ...'
    local  cinfo  := 'Promiòte prosím,'                            +CRLF + ;
                     'zadané IÈO nebylo nalezeno v registru      ' +CRLF + ;
                     'ekonomických subjekù (ARES), pokud se jedná' +CRLF + ;
                     'o zahranièní firmu, bude kotrola vypnuta   ' +CRLF +CRLF + ;
                     '... požadujete vypnout kontroly ARES ...'    +CRLF


    if ::is_activeAres
      ::firmy_Ares()

      nin   := ascan( ::pa_ares, { |x| x[1] = 'D:ET' } )
      cErr  := ::pa_ares[nin,3]

      if .not. empty(cErr)        // ARES vrátil chybu
        nsel := confirmBox( , cinfo, ctitle     , ;
                              XBPMB_YESNOCANCEL , ;
                              XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
        return ( nsel = XBPMB_RET_YES )

*        msgBox( cErr, DRG_MSG_ERROR )
*        return .f.
      else
        for x := 1 to len(pa) step 1
          if pa[x,2] <> 'nico' .and. isObject(pa[x,4])
            drgVar := pa[x,4]:ovar
            drgVar:set(pa[x,3])
            eval(drgVar:block,drgVar:value)
            drgVar:initValue := drgVar:value
          endif
        next
      endif
    endif
  return .t.


hidden:
  var     m_Dialog, m_udcp


  inline access assign method is_czechRep() var is_czechRep
    local  lOk := .f.

    if isObject(::odrg_zkratStat)
      lOk := ( upper(::odrg_zkratStat:value) $ 'CZ ,CZE' )
    endif
  return lOk


  inline method firmy_getAres(ntag)
    local  aMember, ctag_Name, ctag_Content, nin, n

    if .not. XMLGetTag(nTag, @aMember)
      return
    endif

    ctag_Name    := allTrim(aMember[XMLTAG_NAME])
    ctag_Content := CUTF8TOANSI( aMember[XMLTAG_CONTENT] )

    if( nin := ascan( ::pa_ares, { |x| x[1] = ctag_Name } )) <> 0
      if .not. empty(::pa_ares[nin,6])
        ::pa_Ares[nin,3] := SYS_ares_Miss(ctag_Content, ::pa_ares[nin,6])
      else
        ::pa_Ares[nin,3] := ctag_Content
      endif
    endif

    if aMember[XMLTAG_CHILD] != NIL
      for n := 1 TO Len(aMember[XMLTAG_CHILD])
        ::firmy_getAres(aMember[XMLTAG_CHILD][n])
      next
    endif
  return

  inline method firmy_infoAres()
    local  pa := ::pa_Ares, oinfo
    local  x, codp_Ares, cval_Firmy, ninfo := 0

    if ::dm:get(::hd_file +'->nico') <> 0 .and. ::is_czechRep
      for x := 1 to len(pa) step 1
        if isObject(pa[x,4])
          codp_Ares  := isNull(pa[x,3], '')
          cval_Firmy := SYS_ares_allToC( isNull(pa[x,4]:ovar:value, ''), len(codp_Ares) )

          do case
          case        Empty(codp_Ares) .and. Empty(cval_Firmy)
            ninfo := 0
          case  .not. Empty(codp_Ares) .and. Empty(cval_Firmy)
            ninfo := 171  // waring  DRG_ICON_MSGWARN
          case       Equal(codp_Ares, cval_Firmy)
            ninfo := 101  // ok      DRG_ICON_SAVE
          case .not. Equal(codp_Ares, cval_Firmy)
            ninfo := 170  // err     DRG_ICON_MSGERR
          endcase

          oinfo  := pa[x,5]

          if ninfo <> oinfo:caption
            oinfo:setCaption(ninfo)
            oinfo:show()
          endif
        endif
      next
    endif
  return self

endclass