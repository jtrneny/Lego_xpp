#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
#include "dbstruct.ch"
#include "Drgres.ch"
#include "dll.ch"
//
#include "..\Asystem++\Asystem++.ch"


// pøíklad popisu v GROUPS(FAKVYSHD:10:FAKVYSIT:1:STRZERO(FAKVYSHD->nCISFAK):DPH2009_FAV()) //
#xtranslate  _mFILE  =>  pA\[ 1\]        //_ základní soubor       _
#xtranslate  _mTAG   =>  pA\[ 2\]        //_                 tag   _
#xtranslate  _sFILE  =>  pA\[ 3\]        //_ spojený soubor        _
#xtranslate  _sTAG   =>  Val(pA\[ 4\])   //_                 tag   _
#xtranslate  _sSCOPE =>  pA\[ 5\]        //_                 scope _
#xtranslate  _mFUNC  =>  pA\[ 6\]        //_ funkce pro zpracování _
#xtranslate  _oPROC  =>  pA\[ 7\]        //_ objekt pro procento   _
#xtranslate  _oTHERM =>  pA\[ 8\]        //_ objekt pro teplomìr   _



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


static function akc_browseContext(obj, ix, nMENU)
return {|| obj:akc_fromContext( ix, nMENU) }


static function doplnujici_in_pb(oxbp, nkeyCnt, nkeyNo, nsize, nhight)
  local  charInf
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()
  local  ofont    := XbpFont():new():create( "9.Arial CE" )

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  GraGradient( ops             , ;
              {2,2}            , ;
              {{newPos,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

  if newPos < (nSize/2) -20
    GraGradient( ops                , ;
                 { newPos+1,2 }, ;
                 { { nsize -newPos, nhight }}, ;
                 {0,15,0}, GRA_GRADIENT_HORIZONTAL)
  endif

  GraSetFont( oPs, oFont )
  GraStringAt( oPS, {(nSize/2) -20,16}, prc)
  oXbp:unlockPS(oPS)
return .t.


*
** prg je urèen pro doplòující nabídku na stranì akcionáøù
*
** class for akc_doplnujici_in ************************************************
class AKC_doplnujici_in
exported:
  var     m_File

  var     hd_file, it_file


  inline method init(drgDialog)
    local members := drgDialog:oActionBar:members, x

    ::m_Dialog := drgDialog
    ::m_udcp   := drgDialog:udcp
    ::m_DBrow  := drgDialog:dialogCtrl:oBrowse[1]
    ::m_File   := ::m_DBrow:cfile
    ::a_poPup  := { { 'Kontrola nápoètù a hlasù', 'akc_globPrepocet'    }, ;
                    { 'Kontrola rodného èísla  ', 'fin_danUdaje_in'     }  }

    for x := 1 to len(members) step 1
      if  members[x]:ClassName() = 'drgPushButton'
        if( members[x]:event = 'akc_createContext', ::pb_context := members[x], nil )
      endif
    next
  return self


  inline method akc_createContext()
    local  pa    := ::a_popUp
    local  aPos  := ::pb_context:oXbp:currentPos()
    local  aSize := ::pb_context:oXbp:currentSize()

    opopup         := XbpImageMenu():new( ::m_Dialog:dialog )
    opopup:barText := 'Akcionáøi'
    opopup:create()

    for x := 1 to len(pa) step 1
      opopup:addItem( {pa[x,1]                        , ;
                       akc_BrowseContext(self,x,pA[x]), ;
                                                      , ;
                       XBPMENUBAR_MIA_OWNERDRAW         }, ;
                       500                                 )
    next

    opopup:popup( ::pb_context:oxbp:parent, { apos[1] -120, apos[2] } )
  return self

  inline method akc_fromContext(aorder,p_popUp)
    local cformName := p_poPup[2]
    local odialog

    odialog := drgDialog():new( cformName, ::m_Dialog)
    odialog:create(,,.T.)

    odialog:destroy()
    odialog := nil

    setAppFocus( ::m_DBrow:oxbp )
    PostAppEvent(xbeBRW_ItemMarked,,,::m_DBrow:oxbp)

    if( cformName = 'fin_typUhrfak_in', ::m_DBrow:oxbp:refreshCurrent(), nil )
  return self

hidden:
  var     m_Dialog, m_udcp, m_DBrow, pb_context, a_poPup

  var     typ_Dokl, zaklMena

  inline access assign method istuz() var istuz
    local zkrMeny := if(lower(::hd_file) = 'banvyphdw', (::hd_file)->czkratMeny, (::hd_file)->czkratMenz)
  return Equal(::zaklMena, zkrMeny)


  inline method cvarsym_NEU(file_iv,equalMena)
    local  cenzakcel := 0

    if     ::istuz     ;  cenZakCel := (file_iv)->ncenZakCel -(file_iv)->nuhrCelFak
    elseif equalMena   ;  cenZakCel := (file_iv)->ncenZahCel -(file_iv)->nuhrCelFaz
    endif
  return cenzakcel

  inline method cvarsym_LIK(file_iv,equalMena)
    local  likpol := 0

    if ::istuz
      likpol := abs((file_iv)->ncenZakCel -(file_iv)->nuhrCelFak)
    endif
  return likpol

  inline method cvarsym_OBR(file_iv,equalMena)
    local  cenZakCel := 0, retVal

    if     ::istuz     ;  cenZakCel := (file_iv)->ncenZakCel -(file_iv)->nuhrCelFak
    elseif equalMena   ;  cenZakCel := (file_iv)->ncenZahCel -(file_iv)->nuhrCelFaz
    endif

    if Equal(file_iv,'fakprihd')  ;  retVal := if(cenZakCel >= 0,2,1)
    else                          ;  retVal := if(cenZakCel >= 0,1,2)
    endif
  return retVal
endclass


*
** class for akc_globPrepocet *** kontrola nápoètù a hlasù *********************
class akc_globPrepocet from drgUsrClass
exported:
  var     datZprac, stavZprac
  method  zpracuj_podklady


  inline method init(parent)
    ::drgUsrClass:init(parent)

    ::datZprac  := date()
    ::stavZprac := 0

    drgDBMS:open('c_typAkc')                   // typ akcií
    drgDBMS:open('akcionar',,,,,'akcionar_G')   // child of akcionar
    drgDBMS:open('akcie'   ,,,,,'akcie_G'   )   // child of akcie
  return self


  inline method drgDialogStart(drgDialog)
    local x, pA, members  := drgDialog:oForm:aMembers

    ::msg        := drgDialog:oMessageBar             // messageBar
    ::dm         := drgDialog:dataManager             // dataMabanager
    ::dc         := drgDialog:dialogCtrl              // dataCtrl
    ::df         := drgDialog:oForm                   // form
    ::ab         := drgDialog:oActionBar:members      // actionBar
    *
    ::xbp_therm  := drgDialog:oMessageBar:msgStatus
    ::aedits     := {}

    for x := 1 to LEN(members) step 1
     if .not. Empty(members[x]:groups)
       pA  := ListAsArray(members[x]:groups,':')
       nIn := AScan( ::aEDITs,{|X| X[1] = pA[1]})

       if(nIn <> 0, ::aEDITs[nIn,8] := members[x], ;
                    AAdd(::aEDITs, { pA[1], pA[2], pA[3], pA[4], pA[5], pA[6], members[x], NIL }))
      endif
    next

    for x := 1 to len(::ab) step 1
      if isCharacter(::ab[x]:event)
        do case
        case ::ab[x]:event = 'zpracuj_podklady' ;  ::obtn_zpracuj_podklady := ::ab[x]
        endcase
      endif
    next

    if .not. akcionar_G->(flock())
      ::obtn_zpracuj_podklady:oxbp:disable()
    endif
  return self

  inline method drgDialogEnd(drgDialog)
    akcionar_G->( dbUnlock(), dbCommit())

    akcionar_G->( dbcloseArea())
    akcie_G   ->( dbcloseArea())
  return self


hidden:
* sys
  var     msg, dm, dc, df, ab, xbp_therm, obtn_zpracuj_podklady
* datové
  var     aedits

endClass


method akc_globPrepocet:zpracuj_podklady()
  local  x, pa, oXbp, nreccnt, nkeycnt, nkeyno, prc, ops
  *
  local  nAKCIONAR, pocetAkci, hodnotaAk, hodnotaVh
  local  cf := "nAKCIONAR = %%", filter


  for x := 1 to len(::aedits) step 1
    pa      := ::aedits[x]
    oxbp    := _oTHERM:oxbp
    *
    nSize   := oxbp:currentSize()[1]
    nHight  := oxbp:currentSize()[2] -2

    nreccnt := 0
    in_file := lower(_mFILE)
    ctag    := _mTAG

    drgDBMS:open(in_file)
    (in_file) ->(AdsSetOrder(ctag), dbgoTop() )

    nreccnt := (in_file)->(lastRec())
    nkeycnt := nreccnt
    nkeyno  := 1
    nstep   := 0

    do while .not. (in_file)->( eof())
      nAKCIONAR := isNull(akcionar_G->sID, 0)
      pocetAkci := hodnotaAk := hodnotaVh := 0

      filter := format(cf, {nAKCIONAR} )
      akcie_G->( ads_setAof(filter), ;
                 dbgoTop()         , ;
                 dbeval( { || ( c_typakc->( dbseek( akcie_G->czkrTypAkc,,'C_TYPAKC01'))            , ;
                                pocetAkci++                                                        , ;
                                hodnotaAk += if( c_typakc->nzusobNapo = 0, akcie_G->nhodnotaAk, 0 ), ;
                                hodnotaVh += if( c_typakc->lzapocDOvh    , akcie_G->nhodnotaAk, 0 )  ) } ) )


      * modifikace akcionar.npocetAkcii, nhodnaotaAk, nhodnotaVh, npocetHlas
      akcionar_G->npocetAkci := pocetAkci
      akcionar_G->nhodnotaAk := hodnotaAk
      akcionar_G->nhodnotaVh := hodnotaVh
      akcionar_G->npocetHlas := pocetHlasu_cmp( hodnotaVh, pocetAkci )
      akcionar_G->( dbcommit())

      (in_file)->( dbskip())
      nkeyNo++

      doplnujici_in_pb(oxbp,nkeycnt,nkeyno,nsize,nhight)
    enddo
  next

  sleep(150)
  PostAppEvent(xbeP_Close, drgEVENT_QUIT,,oXbp)
return self