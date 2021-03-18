#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "dmlb.ch"
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"
#include "Fileio.ch"
#include "class.ch"

#include "Deldbe.ch"
#include "Sdfdbe.ch"
#include "DbStruct.ch"
#include "Directry.ch"

#include "..\A_main\WinApi_.ch"

#include "activex.ch"
#include "excel.ch"

#include "XbZ_Zip.ch"


#DEFINE  DBGETVAL(c)     Eval( &("{||" + c + "}"))

#pragma Library( "ASINet10.lib" )

static oExcel


// Aktualizace pøipomínek na distribuèní databází A++  --
function DIST000014( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, inDir
  local j, n := 0
  local line, aline
  local afiles := {}
  local cDBadis, cUSRadis, cPASWadis
  local cConnect
  local oSession_dbfi
  local lExc := Set(_SET_EXCLUSIVE), lReadOnly := .f.
  local obox
  local lview

  *
  local  oBook, oSheet
  local  nRow, nCol, contRows
  local  oThread

  lview := .not. Empty(oxbp)

  if lview
    m_oDBro   := oxbp:parent:odBrowse[1]
    m_File    := lower(m_oDBro:cFile)
    arSelect  := aclone(m_oDBro:arSelect)
  endif

  if Empty(arSelect)
    drgMsgBox(drgNLS:msg('Nejsou vybrány žádné pøipomínky k synchronizaci !!!'))
    return nil
  endif

  drgDBMS:open( 'ASYSPRHD',,,,, 'ASYSPRHD_f' )
  drgDBMS:open( 'ASYSPRIT',,,,, 'ASYSPRIT_f' )

// connect to the ADS uživatelská podpora A++
//    cDBasys         := AllTrim(SysConfig('System:cFtpAdrKom'))
//  cDBasys         := '77.95.194.215'
//  cDBasys         := "\\"+ cDBasys +":6263\dataa\A_System\Asystem++\Data\A++\Data\A++_100101.add"
//  cUSRasys        := ";UID=UsrPodpora;PWD=BarUhvezdY;"
//  cConnect        := "DBE=ADSDBE;SERVER="  +cDBasys +";ADS_AIS_SERVER;ADS_COMPRESS_INTERNET" +cUSRasys

// Agrikol
  cDBadis         := AllTrim(odata_datKom:SynAdresDBdis)
  cDBadis         := "\\"+ cDBadis + AllTrim( retDir( odata_datKom:SynPathDBdis)) + AllTrim(odata_datKom:SynNameDBdis)
  cPASWadis       := AllTrim(odata_datKom:SynPasswDBdis)
  cPASWadis       := if( cPASWadis = "*" .and. Len( cPASWadis) = 1, '', cPASWadis)
  cUSRadis        := ";UID=" + AllTrim(odata_datKom:SynUserDBdis) + ";PWD=" + cPASWadis + ";"
  cConnect        := "DBE=ADSDBE;SERVER=" +cDBadis +";ADS_AIS_SERVER;ADS_COMPRESS_INTERNET" +cUSRadis

***

  osession_dbfi  := dacSession():New( cConnect)
  if .not. ( osession_dbfi:isConnected() )
//    if( lview, MsgBox( "Excel nemáte nainstalovaný na poèítaèi" ), nil)
    if( lview, drgMsgBox(drgNLS:msg('Nelze se pøipojit na distribuèní databázi >>' + AllTrim(odata_datKom:SynNameDBdis)+ '<<   !!!')), nil)
    return 0
  endif

  if( lview, obox := sys_moment( 'probíhá pøenos dat'), nil)

  DBUseArea(.T., osession_dbfi, 'ASYSPRHD', 'ASYSPRHD_d' ,!lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'ASYSPRIT', 'ASYSPRIT_d' ,!lExc, lReadOnly)

  osession_dbfi:beginTransaction()

  BEGIN SEQUENCE
    if lview
      for n := 1 to len(arSelect) step 1
        asysprhd_f->( dbgoTo( arSelect[n]))
        if .not. asysprhd_d->( dbSeek(asysprhd_f->cIDpripom,,'ASYSPRHD11'))
          mh_copyFld( 'asysprhd_f', 'asysprhd_d', .t. )
        else

        endif
      next
    else
      filtr     := format( "nStav_KOMU = %%", { 3 })
      asysprhd_f->( ads_setAof(filtr),dbgoTop())

       do while .not. asysprhd_f->( Eof())
         if .not. asysprhd_d->( dbSeek( asysprhd_f->cIDpripom,,'ASYSPRHD11'))
           if asysprhd_f->(Rlock())
             asysprhd_f->nStav_KOMU := 4
             mh_copyFld( 'asysprhd_f', 'asysprhd_d', .t. )
             asysprhd_f->(dbUnLock())
           endif
         else
           if asysprhd_f->(Rlock())
             asysprhd_f->nStav_KOMU := 4
             if asysprhd_d->(Rlock())

             endif
             asysprhd_f->(dbUnLock())
           endif
         endif
         asysprhd_f->( dbSkip())
       enddo
      asysprhd_f->( Ads_ClearAof())
    endif

    asysprhd_d->( dbUnlock(), dbCommit())
    asysprit_d->( dbUnlock(), dbCommit())

    osession_dbfi:commitTransaction()

  RECOVER USING oError
    osession_dbfi:rollbackTransaction()

  END SEQUENCE


  if( isObject(osession_dbfi), osession_dbfi:disconnect(), nil )

  if lview
    obox:destroy()
    drgMsgBox(drgNLS:msg('synchronizace byla dokonèena'), XBPMB_INFORMATION)
  endif

return(NIL)


// Kompletní záloha databáze A++  --
function DIST000114( oxbp, typKom ) // oxbp = drgDialog
  local  file, in_Dir, filtr, nHandle, cx
  local  dir_Bac, dir_Log, dir_Exp, dir_Zip
  local  oThread, lview := .not. Empty(oxbp)
  local  ozip
  *
  local  npoc := 1
  local  count
  local  lok := .f.
  local  ctypBAC, cadsBAC, ctypEXP, ldelZIP
  local  dateTime
  local  ctmDen
  *
  local  cStatement, oStatement

  default typKom to 0
                                                                                                                                                                                                                                                                                                                                                                                                                                            dir_Exp := ''
  dir_Zip := ''

  drgDBMS:open('asysinfo',,,,, 'asysinfoa' )
  drgDBMS:open('asysbac',,,,, 'asysbaca' )
  drgDBMS:open('kalendar',,,,, 'kalendara' )

//  drgDump( 'Start - jsem uvnitø funkce DIST000114 - ' + Time() + ' - ' + cStatement +  CRLF )


  if .not. lview
    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      drgDump( 'Chyba pøi spuštšní DIST000114 - ' + Time() +  CRLF )
      return 0
    else
      odata_datKom := oThread:odata_datKom
    endif
  endif

  ctypBAC := odata_datKom:TypArchive
  dir_Bac := retDir(odata_datKom:PathBackup)

  if .not. Empty( dir_Bac)
    cadsBAC    := if( File( dir_Bac + 'A++_' + AllTrim( Str( usrIDDB)) + '.Add' ), "'Diff'", "''")

    cStatement := "execute procedure sp_BackupDatabase( '" +dir_Bac + "'," + cadsBAC + ")"
    oStatement := AdsStatement():New(cStatement,oSession_data)

    asysbaca->( dbAppend())

    asysbaca->cTask      := 'SYS'
    asysbaca->cIDbackup  := newIDbackup(ctypBAC)
//    asysbaca->cIDDatKom  := AllTrim( if( lview, komusers->ciddatkom, userstsk->cprgobject))   //      datkomhd->cIdDatKom
    asysbaca->cIDDatKom  := 'DIST000114()'
    asysbaca->cZPRAVA    := 'Kompletní záloha databáze'
//    asysbaca->mPOPISZPR  :=
    asysbaca->cTYPbackup := ctypBAC
    asysbaca->cUSER      := usrName
//    asysbaca->cIDprocesu :=
    asysbaca->cTypBegin  := if( lview, 'R', 'A')
    asysbaca->tbeginbac  := Left( mh_DateTime(), 19)
    asysbaca->dVznikZazn := Date()

    if lview
      if oStatement:LastError > 0
        asysbaca->cERRBAC    := 'došlo k chybì pøi vytváøení zálohy DB'
        drgMsgBox(drgNLS:msg('došlo k chybì pøi vytváøení zálohy DB'), XBPMB_WARNING)
        return nil
      endif
      oStatement:Execute( 'test', .f.)
      oStatement:Close()
    else
      if oStatement:LastError > 0
        asysbaca->cERRBAC    := 'došlo k chybì pøi vytváøení zálohy DB'
        asysbaca->tendbac := Left( mh_DateTime(), 19)
        return 0
      endif
      oStatement:Execute( 'test', .f.)
//      drgDump( 'Konec backup ' + CRLF )
      oStatement:Close()
    endif
  endif

  if ctypBAC <> 'PRU'
    dir_Zip := retDir(odata_datKom:PathTmpZip)
    ctypEXP := odata_datKom:TypExport
  endif

  if .not. Empty(ctypEXP)
    ldelZIP := odata_datKom:DelTmpZip = 'ANO' .or. odata_datKom:DelTmpZip = 'YES'
    if( Empty(dir_Zip), dir_Zip := drgChkDirName( drgINI:dir_DATA) + 'Temp\', nil)
    myCreateDir( dir_Zip)

    do case
    case ctypBAC = 'DEN'
      if kalendara->(dbSeek( DtoS(Date()),, 'KALENDAR01'))
        do case
        case kalendara->cZkrNazDne = 'Út'
          ctmDen := 'Ut'
        case kalendara->cZkrNazDne = 'Èt'
          ctmDen := 'Ct'
        case kalendara->cZkrNazDne = 'Pá'
          ctmDen := 'Pa'
        otherwise
          ctmDen := kalendara->cZkrNazDne
        endcase
      endif
      ctypBAC := ctypBAC + '_' +ctmDen
      file := 'BAC_' + ctypBAC + '_A++_' + AllTrim( Str( usrIDDB)) + '.azf'

    case ctypBAC = 'TYD'
      ctypBAC := ctypBAC + if( kalendara->(dbSeek( DtoS(Date()),, 'KALENDAR01')), '_' +StrZero(kalendara->nTyden,2), '' )
      file := 'BAC_' + ctypBAC + '_A++_' + AllTrim( Str( usrIDDB)) + '.azf'

    case ctypBAC = 'MES'
      ctypBAC := ctypBAC + if( kalendara->(dbSeek( DtoS(Date()),, 'KALENDAR01')), '_' +StrZero(kalendara->nMesic,2), '' )
      file := 'BAC_' + ctypBAC + '_A++_' + AllTrim( Str( usrIDDB)) + '.azf'

    endcase

    ozip := XbZLibZip():New( dir_Zip + file)
    ozip:AddDir( '*.*', dir_Bac)
    ozip:Close()

    do case
    case ctypEXP = 'CPY'
      dir_Exp := retDir(odata_datKom:PathExport)
      COPY FILE (dir_Zip + file) TO (dir_Exp+ file)
      lok := .t.

    case ctypEXP = 'FTP'
      lok := ftpComSend( dir_Zip+file,, lview, odata_datKom)

    endcase
  else
    lok := .t.

  endif

  if lview
    if lok
       drgMsgBox(drgNLS:msg('zálohování dat bylo dokonèeno'), XBPMB_INFORMATION)
    else
       drgMsgBox(drgNLS:msg('zálohování dat nebylo dokonèeno'), XBPMB_WARNING)
    endif
  endif

  asysbaca->tendbac := Left( mh_DateTime(), 19)

  if Upper(odata_datKom:DelTmpZip) = 'ANO'
    FErase(dir_Zip + file)
  endif

  asysinfoa->( dbCloseArea())
  asysbaca->( dbCloseArea())
  kalendara->( dbCloseArea())

  oThread:quit()

return nil



FUNCTION newIDbackup(typ)
  local newID
  local filtr

  drgDump('jsem uvnitø newIDbackup - øádek 336 ' + typ )

  drgDBMS:open('asysbac',,,,,'asysbacn')
  filtr := Format("cIDbackup = '%%'", {typ})
  asysbacn->( AdsSetOrder('ASYSBAC01'), ads_setaof(filtr), DBGoBotTom())
  newID := typ + StrZero( Val( SubStr(asysbacn->cIDbackup,5,6))+1, 6)
  asysbacn->(ads_clearaof(), dbCloseArea())

  drgDump('jsem na konci newIDbackup - øádek 344 ' + newID )

RETURN(newID)