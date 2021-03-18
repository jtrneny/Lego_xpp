#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*
*
** CLASS MZD_kmenove_SCR *******************************************************
CLASS DOH_osoby_pohyb_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  var     obdobi, nrok, nobdobi
  var     stavem

  method  Init
  method  InFocus
  method  drgDialogStart
  method  InputOfDochazka, AktZOldDat, AktDsPohyby, DelAktDsPoh
  method  Del_dsPohyby_sql

  method  stableBlock

*  method  mzd_doklhrmzdo_scr

  inline access assign method is_Doh_and_idKarty() var is_Doh_and_idKarty
    return if( osoby->nis_DOH = 1 .and. empty(osoby->cidOsKarty), 6002, 0 )  //  msgAttention - 6002

  inline access assign method is_Pritomen() var is_Pritomen
    local  isPritomen := .f.
    local  x_lastin, d_lastin
    local  x_lastout, d_lastout

    x_lastin   := mh_DaTiAMPM_24(osoby->tLastIn)
    x_lastout  := mh_DaTiAMPM_24(osoby->tLastOut)

    d_lastin  := if( isCharacter(x_lastin) , ctod( left( x_lastin , 10 )), ctod('  .  .  ' ) )
    d_lastout := if( isCharacter(x_lastout), ctod( left( x_lastout, 10 )), ctod('  .  .  ' ) )

    if ( d_lastin = date() )
      isPritomen := .t.

      if ( d_lastin = d_lastout )
        isPritomen := isPritomen .and. x_lastin >= x_lastout
      endif
    endif
    return if( isPritomen, 556, 0 )

  inline access assign method is_Stavem_prSml() var is_Stavem_prSml
    return if( prSmlDoh->lStavem,  MIS_ICON_OK, 0)

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local ntabNum

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)

       ::obdobi  := uctOBDOBI:DOH:COBDOBI
       ::nrok    := uctOBDOBI:DOH:NROK
       ::nobdobi := uctOBDOBI:DOH:NOBDOBI

       ::stableBlock(::brow[1]:oxbp)
       for ntabNum = 2 to len(::brow) step 1
         ::brow[ntabNum]:oxbp:refreshAll()
       next

       return .t.
    otherwise
      return .f.
    endcase
  return .f.

  inline method tabSelect(oTabPage,tabnum)
    local  tabBrowse := val(otabPage:tabBrowse)

    ::tabNum := tabNum
    ::stableBlock( ::brow[1]:oxbp )

    if( tabBrowse <> 0, ::brow[tabBrowse]:oxbp:refreshAll(), nil )
  return .t.

hidden:
  var  brow, tabNum
  var  firstDay
endclass

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD DOH_osoby_pohyb_SCR:Init(parent)
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr
  LOCAL cX

  ::drgUsrClass:init(parent)

  ::obdobi    := uctOBDOBI:DOH:COBDOBI
  ::nrok      := uctOBDOBI:DOH:NROK
  ::nobdobi   := uctOBDOBI:DOH:NOBDOBI
  ::stavem    := '1'
  ::tabNum    := 1

  ::firstDay := mh_FirstODate( uctOBDOBI:DOH:NROK, uctOBDOBI:DOH:NOBDOBI)

  drgDBMS:open('CNAZPOL4')
  drgDBMS:open('OSOBY')
  drgDBMS:open('MSPRC_MO')
  drgDBMS:open('C_PRACDO')
  drgDBMS:open('OSOBY')
  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('DSPOHYBY')
  drgDBMS:open('DOTERMIN')

  drgDBMS:open('MSPRC_MO',,,,,'MSPRC_MOb')
  drgDBMS:open('prSmlDoh')
  drgDBMS:open('ACTATEK')
  drgDBMS:open('c_infsum')

  * pro DOCH_sum
  drgDBMS:open('dspohyby',,,,,'dspohybys')
  drgDBMS:open('c_prerus',,,,,'c_preruss')
  drgDBMS:open('kalendar',,,,,'kalendars')
  drgDBMS:open('listit',,,,,'listitd')
  drgDBMS:open('osoby',,,,,'osobyf')
  * pro DOCH_sum

  drgDBMS:open('tminfsumw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  tminfsumw->( ADSSetOrder( 'TMInfSUMw1'))

  drgDBMS:open('tmcelsumw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  c_infsum->( dbEVAL( { || mh_copyFld('c_infsum', 'tminfsumw', .T., .t.)}))
  tminfsumw->( dbGoTOP())

  * programový filtr
  cfiltr := Format("nis_doh = 1", {})
  ::drgDialog:set_prg_filter( cfiltr, 'osoby')

  cfiltr := Format("nCISOSOBY= %% .and. cobdobi = '%%' .and. nsayscr = 1", {OSOBY->nCISOSOBY, ::obdobi})
  DSPOHYBY->(ads_setaof(cfiltr), dbGoTop())

RETURN self


METHOD DOH_osoby_pohyb_SCR:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


METHOD DOH_osoby_pohyb_SCR:drgDialogStart(drgDialog)
  local  pa_quick := { ;
  { 'Kompletní seznam                   ', ''              }, ;
  { 'Osoby pøítomné v zamìstnání        ', 'nPritomen = 1' }, ;
  { 'Osoby nepøítomné v zamìstnání v PPV', 'nStavem = 1 and nPritomen = 0' }, ;
  { 'Osoby    v pracovnì právním vztahu ', 'nis_ZAM   = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah  ', 'nis_ZAM   = 0' }, ;
  { 'Osoby    v personální evidenci     ', 'nis_PER   = 1' }, ;
  { 'Osoby mimo personální evidenci     ', 'nis_PER   = 0' }  }

  ::brow := drgDialog:dialogCtrl:oBrowse

  ::quickFiltrs:init( self, pa_quick, 'Osoby' )
RETURN self


method DOH_osoby_pohyb_SCR:stableBlock(oxbp)
  local m_file, s_filter, p_filter,cfiltr

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'osoby' )

        s_filter := dsPohyby->(ads_getAof())
         cfiltr := Format("ncisOsoby = %% .and. cobdobi = '%%' .and. nsayscr = 1", {OSOBY->ncisOsoby, ::obdobi})
//->     cfiltr := Format("cIdOsKarty = '%%' .and. cobdobi = '%%' .and. nsayscr = 1", {OSOBY->cIdOsKarty, ::obdobi})

        if( .not. Equal(s_filter, cfiltr),  DSPOHYBY->(ads_setaof(cfiltr), dbGoTop()), nil )

        s_filter := prSmldoh->(ads_getAof())
          filtr  := Format("nOSOBY = %%", { isNull( osoby->sid, 0) })

        if( .not. Equal(s_filter, cfiltr), prsmldoh->( ads_setaof(filtr), dbGoTop()), nil )


       if ::tabNum = 2
         s_filter := doTermin->(ads_getAof())
           cfiltr := Format("ncisOsoby = %% .and. nrok = %% .and. nmesic = %%", {OSOBY->ncisOsoby, ::nrok, ::nobdobi})
//->       cfiltr := Format("cIdOsKarty= '%%' .and. nrok = %% .and. nmesic = %%", {OSOBY->cIdOsKarty, ::nrok, ::nobdobi})

           if .not. Equal(s_filter, cfiltr)
             doTermin->(ads_setaof(cfiltr), dbGoTop())
             DOCH_sum( OSOBY->nCisOsoby, ::nrok, ::nobdobi, dspohyby->dDatum)
             postAppEvent( xbeBRW_ItemMarked,,,::brow[3]:oxbp )
           endif
        endif

       if ::tabNum = 5
         s_filter := doTermin->(ads_getAof())
           cfiltr := Format("ncisOsoby = %% .and. nrok = %% .and. nmesic = %%", {OSOBY->ncisOsoby, ::nrok, ::nobdobi})
//->       cfiltr := Format("cIdOsKarty= '%%' .and. nrok = %% .and. nmesic = %%", {OSOBY->cIdOsKarty, ::nrok, ::nobdobi})

           if .not. Equal(s_filter, cfiltr)
             doTermin->(ads_setaof(cfiltr), dbGoTop())
//             DOCH_sum( OSOBY->nCisOsoby, ::nrok, ::nobdobi, 'dspohyby')
           endif
        endif

     case( m_file = 'tminfsumw' )
//       aeval( ::brow, { |o| if( o:oxbp = oxbp, nil, o:oxbp:refreshAll() ) })
     endcase
  endif
return self



METHOD DOH_osoby_pohyb_SCR:InputOfDochazka()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'DOH_dochhromadne_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

//  ::brow[2]:oxbp:refreshAll()

//  ::tabSelect(oTabPage,2)

RETURN self



METHOD DOH_osoby_pohyb_SCR:AktZOldDat()
  LOCAL  oDialog
  local  cx
  local  key
  local  akarty

  ::drgDialog:pushArea()                  // Save work area

  cx := AllTrim( SysConfig('Dochazka:cPathTerm'))
//   'c:\A_system\STS.1\DOCHAZKA\DAT\dspohyby.dbf'
  akarty := {186,089,010,060,034,012,206,544,147,692}

  dbUseArea( .T.,'FOXCDX',cX,'Old',.T.)
  old->( ordsetfocus(0))

  drgDBMS:open('osoby',.f.,,,,'osobyd')
  drgDBMS:open('msosb_mo',.f.,,,,'msosb_mod')
  drgDBMS:open('dspohyby',.f.,,,,'dspohybyn')
  drgDBMS:open('c_prerus',.f.,,,,'c_preruss')

  if drgIsYESNO(drgNLS:msg('Pøevést data z pùvodního systému za období '+ ::obdobi + ' ?'))

    drgNLS:msg('Probíhá pøevod dat')

    cfiltr := Format("cobdobi = '%%'", {::obdobi})
    dspohybyn->(ads_setaof(cfiltr), dbGoTop())

    do while .not. dspohybyn->( Eof())
      if Ascan( akarty, val(dspohybyn->cidoskarty) ) = 0
        if dspohybyn->( rlock())
          dspohybyn->( dbDelete())
        endif
      endif
      dspohybyn->( dbSkip())
    enddo
    dspohybyn->( dbUnlock())

    old->( dbGoTop())
    do while .not. old->( Eof())
      if old ->cobdobi = ::obdobi .and. Ascan( akarty, val(old->cidoskarty)) = 0
        mh_CopyFld( 'old', 'dspohybyn',.t.)
        if osobyd->( dbSeek(dspohybyn->cIdOsKarty,,'Osoby22' ))
          dspohybyn->ncisosoby  := osobyd->ncisosoby
          dspohybyn->cjmenorozl := osobyd->cjmenorozl
          dspohybyn->nosoby     := osobyd->sid
          dspohybyn->nporpravzt := osobyd->nporpravzt

          dspohybyn->cRoObCpPPv := StrZero( dspohybyn->nrok, 4) + ;
                                    StrZero( dspohybyn->nobdobi, 2) + ;
                                      StrZero( dspohybyn->noscisprac, 5) + ;
                                       StrZero( dspohybyn->nporpravzt, 3)

          if c_preruss->( dbSeek( 'DOH'+Upper( dspohybyn->cKodPreR),,'C_PRERUS05'))
            dspohybyn->nSayPRN  := c_preruss->nSayPRN
          endif

        endif

        key :=  StrZero(( dspohybyn->nrok *100)+dspohybyn->nobdobi,6) + StrZero(dspohybyn->ncisosoby,6)
        if msosb_mod->( dbSeek( key,,'MSOSB_MO10' ))
          dspohybyn->nmsosb_mo := msosb_mod->sid
        endif
      endif
      old->( dbSkip())
    enddo

    old->( dbCloseArea())
    dspohybyn->( dbCloseArea())
    drgMsgBox(drgNLS:msg('Data byla pøevedena'), XBPMB_INFORMATION)
  endif

  ::drgDialog:popArea()                  // Restore work area

RETURN self


METHOD DOH_osoby_pohyb_SCR:AktDsPohyby()
  LOCAL  oDialog
  local  cx
  local  key

  if drgIsYESNO(drgNLS:msg('Aktualizovat data z teminálù za období '+ ::obdobi + ' ?'))

    AKTdspohyby( 'dspohybya' )

    drgMsgBox(drgNLS:msg('Aktualizace byla provedena'), XBPMB_INFORMATION)
  endif

return .t.


method DOH_osoby_pohyb_SCR:Del_dsPohyby_sql()
  local  m_oDBro, m_File, arSelect
  *
  local  cStatement, oStatement
  local  pa        := { "delete from dsPohyby where cobdobi = '%obd' and "            , ;
                        "update doTermin set nstavAkt = 0 where cObdobi = '%obd' and "  }
  local  stmt      := "", c_in := ''

  m_oDBro  := ::drgDialog:odBrowse[1]
  m_File   := lower(m_oDBro:cFile)
  arSelect := aclone(m_oDBro:arSelect)

  do case
  case m_oDBro:is_selAllRec
    (m_File)->( dbGoTop() , ;
                dbeval( { || c_in += "'" +allTrim((m_file)->cidosKarty) +"'"+',' }, ;
                        { || .not. empty((m_file)->cidosKarty)                   }  ) )
  case len( arSelect ) <> 0
    aeval( arSelect, { |x| ( (m_file)->( dbgoto(x)), ;
                             c_in += if( .not. empty((m_file)->cidosKarty), "'" +allTrim((m_file)->cidosKarty) +"'"+',', '' ) ) } )
  otherwise
    c_in += if( .not. empty((m_file)->cidosKarty), "'" +allTrim((m_file)->cidosKarty) +"'"+',', '' )
  endcase

  if len(c_in) <> 0
    if drgIsYESNO(drgNLS:msg('Zrušit stávající aktualizaci dat z terminálù' + ' ?'))

      c_in := subStr ( c_in, 1, len(c_in)-1 )
      pa[1] += " cidOsKarty IN (" +c_in +") ;"
      pa[2] += " cidOsKarty IN (" +c_in +")"
      stmt  := pa[1] +pa[2]

      cStatement := strTran( stmt, '%obd', uctOBDOBI:DOH:COBDOBI )

      oStatement := AdsStatement():New(cStatement, oSession_data)
      if oStatement:LastError > 0
        *  return .f.
      else
        oStatement:Execute( 'test', .f. )
      endif

      oStatement:Close()
    endif
  endif
return self


METHOD DOH_osoby_pohyb_SCR:DelAktDsPoh()
  local n
  local m_oDBro, m_File, arSelect
  *
  if isWorkVersion
    ::Del_dsPohyby_sql()
    return self
  endif

  ::drgDialog:pushArea()                  // Save work area

  m_oDBro  := ::drgDialog:odBrowse[1]
  m_File   := lower(m_oDBro:cFile)
  arSelect := aclone(m_oDBro:arSelect)

  do case
  case m_oDBro:is_selAllRec
    (m_File)->( dbGoTop())
    do while .not.(m_File)->(Eof())
      AAdd( arSelect, (m_File)->( recNo()))
      (m_File)->( dbSkip())
    enddo
  case len( arSelect ) <> 0
  otherwise
    AAdd( arSelect, (m_File)->( recNo()))
  endcase

  if drgIsYESNO(drgNLS:msg('Zrušit stávající aktualizaci dat z terminálù' + ' ?'))

    drgDBMS:open('osoby',.f.,,,,'osobyr')
    drgDBMS:open('dspohyby',.f.,,,,'dspohybyr')
    drgDBMS:open('dotermin',.f.,,,,'doterminr')

    cfiltr := 'cobdobi = ' + chr(39) + uctOBDOBI:DOH:COBDOBI + chr(39)

    for n := 1 to len( arSelect )
      osobyr ->( dbGoto(arSelect[n]))
      if n = 1
        cfiltr += ' .and. ( cidoskarty = ' + Chr(39) + osobyr ->cidoskarty +  chr(39)
      else
        cfiltr += ' .or. cidoskarty = ' + Chr(39) + osobyr ->cidoskarty +  chr(39)
      endif
    next

    cfiltr += ' )'
    dspohybyr->(ads_setaof(cfiltr), dbGoTop())
    do while .not. dspohybyr->( Eof())
      if dspohybyr->( dbRlock())
        dspohybyr->( dbDelete())
      endif
      dspohybyr->( dbSkip())
    enddo

    doterminr->(ads_setaof(cfiltr), dbGoTop())
    do while .not. doterminr->( Eof())
      if doterminr->( dbRlock())
        doterminr->nStavAkt := 0
      endif
      doterminr->( dbSkip())
    enddo

    dspohybyr->( dbUnlock())
    dspohybyr->( dbCommit())
    dspohybyr->( dbCloseArea())

    doterminr->( dbUnlock())
    doterminr->( dbCommit())
    doterminr->( dbCloseArea())

    osobyr->( dbCloseArea())

    drgMsgBox(drgNLS:msg('Aktualizace byly zrušeny'), XBPMB_INFORMATION)
  endif

  ::drgDialog:popArea()                  // Restore work area

return .t.