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
static sName, sNameExt



*** export firem
function DIST000006( oxbp ) // oxbp = drgDialog
  local afile_e
  local recNo
  local filtr
  local n, inp, out

      // export FIRMY
//    oterm := drgProgressMB():New(oXbp)

//    oterm:progressStart(3)
    recNo   := firmy->(recNo())
    afile_e := { {'firmy_e',   'firmyw'},  {'firmyVa_e','firmyVaw'} ;
                ,{'firmyDa_e','firmyDaw'}, {'firmyFi_e','firmyFiw'} ;
                ,{'firmySk_e','firmySkw'}, {'firmyUc_e','firmyUcw'} }

    drgDBMS:open( 'firmy',,,,,   'firmy_e' )
    drgDBMS:open( 'firmyDa',,,,, 'firmyDa_e' )
    drgDBMS:open( 'firmyFi',,,,, 'firmyFi_e' )
    drgDBMS:open( 'firmySk',,,,, 'firmySk_e' )
    drgDBMS:open( 'firmyUc',,,,, 'firmyUc_e' )
    drgDBMS:open( 'firmyVa',,,,, 'firmyVa_e' )

    drgDBMS:open('firmyw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('firmyDaw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('firmyFiw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('firmySkw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('firmyUcw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open('firmyVaw',.T.,.T.,drgINI:dir_USERfitm); ZAP

//    oterm:progressInc()

    firmy ->(dbgoTop())

    do while .not. firmy->(eof())
      mh_copyFld( 'firmy', 'firmyw', .t. )

      filtr := format( "nCisFirmy = %%", { firmy->ncisfirmy})

      aeval( afile_e, {|x| (x[1])->(ads_setAOF( filtr ), dbgoTop()) } )

      for n := 2 to len(afile_e)
        inp := afile_e[n,1]
        out := afile_e[n,2]
       (inp)->(dbeval( { || mh_copyFld( inp, out, .t. ) } ))
      next
//    (afile[1])->(dbeval( { || mh_copyFld( afile[1], 'firmyDaw', .t. ) } ))
//    firmyFi_e->(dbeval( { || mh_copyFld( 'firmyFi_e', 'firmyFiw', .t. ) } ))
//    (afile[3])->(dbeval( { || mh_copyFld( afile[3], 'firmySkw', .t. ) } ))
//    (afile[4])->(dbeval( { || mh_copyFld( afile[4], 'firmyUcw', .t. ) } ))
//    (afile[5])->(dbeval( { || mh_copyFld( afile[5], 'firmyVaw', .t. ) } ))


      firmy->(dbskip())
    enddo

//    oterm:progressInc()

    firmy ->(dbgoTo( recNo ))

    clsFileCom( afile_e)

    * picnem to ven
    zipCom( afile_e, 'DIST000006_'+AllTrim(Str(usrIdDB)))
//    oterm:progressInc()

    delFileCom( afile_e)
    drgMsgBox(drgNLS:msg('pøenos tabulek byl dokonèen'), XBPMB_INFORMATION)

//    oterm:progressEnd()
return nil


*** import firem
function DIST000007( oxbp ) // oxbp = drgDialog
  local afile_i
  local recNo
  local filtr

    * firmy adresáø
    unzipCom( 'DIST000006_'+ SubStr(AllTrim(Str(usrIdDB)),1,4)+'??')

    recNo   := firmy->(recNo())

    afile_i := { {'firmy_i',  'firmyw'},   {'firmyVa_i','firmyVaw'} ;
                ,{'firmyDa_i','firmyDaw'}, {'firmyFi_i','firmyFiw'} ;
                ,{'firmySk_i','firmySkw'}, {'firmyUc_i','firmyUcw'} }

    drgDBMS:open( 'firmy',,,,, 'firmy_i' )
    drgDBMS:open( 'firmyDa',,,,, 'firmyDa_i' )
    drgDBMS:open( 'firmyFi',,,,, 'firmyFi_i' )
    drgDBMS:open( 'firmySk',,,,, 'firmySk_i' )
    drgDBMS:open( 'firmyUc',,,,, 'firmyUc_i' )
    drgDBMS:open( 'firmyVa',,,,, 'firmyVa_i' )

    drgDBMS:open('firmyw',.t.,.t.,drgINI:dir_USERfitm,,,.t.)
    drgDBMS:open('firmyfiw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
    drgDBMS:open('firmyucw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
    drgDBMS:open('firmydaw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
    drgDBMS:open('firmyvaw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
    drgDBMS:open('firmyskw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)

    do while .not. firmyw ->(Eof())
      if firmy_i->( dbSeek( firmyw->ncisfirmy,,'FIRMY1'))
        if( firmy_i->( dbRlock()), mh_COPYFLD('firmyw','firmy_i', .f., .t.), nil)
      else
        mh_COPYFLD('firmyw','firmy_i', .t., .t.)
      endif
      firmy_i->( dbUnLock())
      firmyw->( dbSkip())
    enddo

    do while .not. firmyfiw ->(Eof())
      if firmyfi_i->( dbSeek( firmyfiw->ncisfirmy,,'FIRMYFI1'))
        if( firmyfi_i->( dbRlock()), mh_COPYFLD('firmyfiw','firmyfi_i', .f., .t.), nil)
      else
        mh_COPYFLD('firmyfiw','firmyfi_i', .t., .t.)
      endif
      firmyfi_i->( dbUnLock())
      firmyfiw->( dbSkip())
    enddo

    do while .not. firmyucw ->(Eof())
      if firmyuc_i->( dbSeek( StrZero(firmyucw->ncisfirmy,5)+Upper(firmyucw->cUcet),,'FIRMYUC5'))
        if( firmyuc_i->( dbRlock()), mh_COPYFLD('firmyucw','firmyuc_i', .f., .t.), nil)
      else
        mh_COPYFLD('firmyucw','firmyuc_i', .t., .t.)
      endif
      firmyuc_i->( dbUnLock())
      firmyucw->( dbSkip())
    enddo

    do while .not. firmydaw ->(Eof())
      if firmyda_i->( dbSeek( firmydaw->ncisfirdoa,,'FIRMYDA3'))
        if( firmyda_i->( dbRlock()), mh_COPYFLD('firmydaw','firmyda_i', .f., .t.), nil)
      else
        mh_COPYFLD('firmydaw','firmyda_i', .t., .t.)
      endif
      firmyda_i->( dbUnLock())
      firmydaw->( dbSkip())
    enddo

    do while .not. firmyskw ->(Eof())
      if firmysk_i->( dbSeek( STRZERO(firmyskw->nCisFirmy,5) +UPPER(firmyskw->czkr_Skup),,'FIRMYSK02'))
        if( firmysk_i->( dbRlock()), mh_COPYFLD('firmyskw','firmysk_i', .f., .t.), nil)
      else
        mh_COPYFLD('firmyskw','firmysk_i', .t., .t.)
      endif
      firmysk_i->( dbUnLock())
      firmyskw->( dbSkip())
    enddo

    clsFileCom( afile_i)
    delFileCom( afile_i)
    drgMsgBox(drgNLS:msg('pøenos tabulek byl dokonèen'), XBPMB_INFORMATION)

return nil


// Synchronizace firem - jednosmìrná
function DIST000096( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, inDir
  local j, n := 0
  local line, aline
  local afiles := {}
  local cDBafir, cUSRafir, cPASWafir
  local cConnect
  local oSession_dbfi
  local lExc := Set(_SET_EXCLUSIVE), lReadOnly := .f.
  local obox

  m_oDBro   := oxbp:parent:odBrowse[1]
  m_File    := lower(m_oDBro:cFile)
  arSelect  := aclone(m_oDBro:arSelect)

  if Empty(arSelect)
    drgMsgBox(drgNLS:msg('Nejsou vybrány žádné objednávky k synchronizaci !!!'))
    return nil
  endif

  drgDBMS:open( 'cenzboz',,,,,  'cenzboz_e' )
  drgDBMS:open( 'cenprodc',,,,, 'cenprodc_e' )
  drgDBMS:open( 'procenhd',,,,, 'procenhd_e' )
  drgDBMS:open( 'procenit',,,,, 'procenit_e' )
  drgDBMS:open( 'procenho',,,,, 'procenho_e' )

// connect to the ADS uživatelská podpora A++
//    cDBasys         := AllTrim(SysConfig('System:cFtpAdrKom'))
//  cDBasys         := '77.95.194.215'
//  cDBasys         := "\\"+ cDBasys +":6263\dataa\A_System\Asystem++\Data\A++\Data\A++_100101.add"
//  cUSRasys        := ";UID=UsrPodpora;PWD=BarUhvezdY;"
//  cConnect        := "DBE=ADSDBE;SERVER="  +cDBasys +";ADS_AIS_SERVER;ADS_COMPRESS_INTERNET" +cUSRasys

// Agrikol
  cDBafir         := AllTrim(odata_datKom:SynAdresDBfi)
  cDBafir         := "\\"+ cDBafir + AllTrim( retDir( odata_datKom:SynPathDBfi)) + AllTrim(odata_datKom:SynNameDBfi)
  cPASWafir       := AllTrim(odata_datKom:SynPasswDBfi)
  cPASWafir       := if( cPASWafir = "*" .and. Len( cPASWafir) = 1, '', cPASWafir)
  cUSRafir        := ";UID=" + AllTrim(odata_datKom:SynUserDBfi) + ";PWD=" + cPASWafir + ";"
  cConnect        := "DBE=ADSDBE;SERVER=" +cDBafir +";ADS_AIS_SERVER;ADS_COMPRESS_INTERNET" +cUSRafir

***

  osession_dbfi  := dacSession():New( cConnect)
  if .not. ( osession_dbfi:isConnected() )
    drgMsgBox(drgNLS:msg('Nelze se pøipojit na firemní databázi >>' + AllTrim(odata_datKom:SynNameDBfi)+ '<<   !!!'))
    return nil
  endif

  obox := sys_moment( 'probíhá pøenos dat')

  drgDBMS:open( 'firmy',,,,,   'firmy_a' )
  drgDBMS:open( 'firmyDa',,,,, 'firmyDa_a' )
  drgDBMS:open( 'firmyFi',,,,, 'firmyFi_a' )
  drgDBMS:open( 'firmySk',,,,, 'firmySk_a' )
  drgDBMS:open( 'firmyUc',,,,, 'firmyUc_a' )
  drgDBMS:open( 'firmyVa',,,,, 'firmyVa_a' )

  DBUseArea(.T., osession_dbfi, 'firmy',   'firmy_m'  , !lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'firmyDa', 'firmyDa_m', !lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'firmyFi', 'firmyFi_m', !lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'firmySk', 'firmySk_m', !lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'firmyUc', 'firmyUc_m', !lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'firmyVa', 'firmyVa_m', !lExc, lReadOnly)

  osession_dbfi:beginTransaction()

  BEGIN SEQUENCE

    do while .not. firmy_m ->(Eof())
      if firmy_a->( dbSeek( firmy_m->ncisfirmy,,'FIRMY1'))
        if( firmy_a->( dbRlock()), mh_COPYFLD('firmy_m','firmy_a', .f., .t.), nil)
      else
        mh_COPYFLD('firmy_m','firmy_a', .t., .t.)
      endif
      firmy_a->( dbUnLock())
      firmy_m->( dbSkip())
    enddo

    do while .not. firmyfi_m ->(Eof())
      if firmyfi_a->( dbSeek( firmyfi_m->ncisfirmy,,'FIRMYFI1'))
        if( firmyfi_a->( dbRlock()), mh_COPYFLD('firmyfi_m','firmyfi_a', .f., .t.), nil)
      else
        mh_COPYFLD('firmyfi_m','firmyfi_a', .t., .t.)
      endif
      firmyfi_a->( dbUnLock())
      firmyfi_m->( dbSkip())
    enddo

    do while .not. firmyuc_m ->(Eof())
      if firmyuc_a->( dbSeek( StrZero(firmyuc_m->ncisfirmy,5)+Upper(firmyuc_m->cUcet),,'FIRMYUC5'))
        if( firmyuc_a->( dbRlock()), mh_COPYFLD('firmyuc_m','firmyuc_a', .f., .t.), nil)
      else
        mh_COPYFLD('firmyuc_m','firmyuc_a', .t., .t.)
      endif
      firmyuc_a->( dbUnLock())
      firmyuc_m->( dbSkip())
    enddo

    do while .not. firmydaw ->(Eof())
      if firmyda_a->( dbSeek( firmyda_m->ncisfirdoa,,'FIRMYDA3'))
        if( firmyda_a->( dbRlock()), mh_COPYFLD('firmyda_m','firmyda_a', .f., .t.), nil)
      else
        mh_COPYFLD('firmyda_m','firmyda_a', .t., .t.)
      endif
      firmyda_a->( dbUnLock())
      firmyda_m->( dbSkip())
    enddo

    do while .not. firmysk_m ->(Eof())
      if firmysk_a->( dbSeek( STRZERO(firmysk_m->nCisFirmy,5) +UPPER(firmysk_m->czkr_Skup),,'FIRMYSK02'))
        if( firmysk_a->( dbRlock()), mh_COPYFLD('firmysk_m','firmysk_a', .f., .t.), nil)
      else
        mh_COPYFLD('firmysk_m','firmysk_a', .t., .t.)
      endif
      firmysk_a->( dbUnLock())
      firmysk_m->( dbSkip())
    enddo

   osession_dbfi:commitTransaction()

  RECOVER USING oError
    osession_dbfi:rollbackTransaction()

  END SEQUENCE


  if( isObject(osession_dbfi), osession_dbfi:disconnect(), nil )
  obox:destroy()
  drgMsgBox(drgNLS:msg('synchronizace byla dokonèena'), XBPMB_INFORMATION)
return( nil)