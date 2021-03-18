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
#include "xbtsys.ch"


#DEFINE  DBGETVAL(c)     Eval( &("{||" + c + "}"))

#pragma Library( "ASINet10.lib" )

static oExcel

// export CENZBOZ do KARDEXU v txt formátu
function DIST000077( oxbp ) // oxbp = drgDialog
  local filtr
  local cx
  local m_oDBro, m_File
  local arSelect
  local onLine := .f.

//  drgDBMS:open( 'cenzboz',,,,, 'cenzboze' )

//  filtr     := format( "ccissklad = '101'")
//  cenzboze->( ads_setAof("ccissklad = '101'"),dbgoTop())

  m_oDBro  := oxbp:parent:odBrowse[1]
  m_File   := lower(m_oDBro:cFile)

  arSelect   := aclone(m_oDBro:arSelect)

  if Upper(oxbp:formName) = 'SYS_SELECTKOM_CRD'
    file := retDir(odata_datKom:PathExport) + odata_datKom:FileExport
    rec_m_File := (m_File)->( recNo())
  else
    file := retDir(odata_datKom:PathExport) + 'CEN_'+ AllTrim(cenzbozw->csklpol) +'.CSV'
    rec_m_File := m_oDBro:ncurrRecNo
    onLine := .t.
  endif

  if .not. Empty(file)
    nHandle := FCreate( file )

    do case
    case m_oDBro:is_selAllRec
      (m_File)->( dbgoTop())

      do while .not. (m_File)->(eof())
        if (m_File)->culozsys = 'KAR'
          cx := AllTrim(StrZero( isNull( (m_File)->sid, 0),10))+ ";"+           ;
                  AllTrim((m_File)->csklpol)+ ";"+                 ;
                   AllTrim((m_File)->cnazzbo)+ ";"+                ;
                    AllTrim((m_File)->czkratjedn)+ ";"+            ;
                     AllTrim(Str((m_File)->NMINZBO,13,4)) +CRLF
          FWrite( nHandle, cx)
        endif
        (m_File)->( dbSkip())
      enddo

    otherwise
      if onLine
        aadd( arSelect, rec_m_File)
      else
        if( len(arSelect) = 0, aadd( arSelect, (m_File)->( recNo()) ), nil )
      endif

      for x := 1 to len( arSelect) step 1
        (m_File)->( dbgoTo( arSelect[x]))
        if (m_File)->culozsys = 'KAR'
          cx := AllTrim(StrZero( isNull( (m_File)->sid, 0),10))+ ";"+           ;
                  AllTrim((m_File)->csklpol)+ ";"+                 ;
                   AllTrim((m_File)->cnazzbo)+ ";"+                ;
                    AllTrim((m_File)->czkratjedn)+ ";"+            ;
                     AllTrim(Str((m_File)->NMINZBO,13,4)) +CRLF
          FWrite( nHandle, cx)
        endif
      next
    endcase
//    FWrite( nHandle, Chr( 26), 1)
    FClose( nHandle)
  endif

  if .not. onLine
    drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)
  endif

return( nil)


// Export PVPItem - pøíjmy do KARDEXU v txt formátu
function DIST000078( oxbp ) // oxbp = drgDialog
  local filtr
  local cx
  local m_oDBro, m_File
  local arSelect
  local onLine := .f.

//  filtr     := format( "ccissklad = '101'")
//  cenzboze->( ads_setAof("ccissklad = '101'"),dbgoTop())

  m_oDBro  := oxbp:parent:odBrowse[1]
  m_File   := lower(m_oDBro:cFile)

  arSelect   := aclone(m_oDBro:arSelect)

  if Upper(oxbp:formName) = 'SYS_SELECTKOM_CRD'
    file := retDir(odata_datKom:PathExport) + odata_datKom:FileExport
    rec_m_File := (m_File)->( recNo())
  else
    file := retDir(odata_datKom:PathExport) + 'PRI_'+ AllTrim(Str(pvpheadw->ndoklad)) +'.CSV'
    rec_m_File := m_oDBro:ncurrRecNo
    onLine := .t.
  endif

  if .not. Empty(file)
    nHandle := FCreate( file )
    drgDBMS:open( 'pvpitem',,,,, 'pvpiteme' )

    do case
    case m_oDBro:is_selAllRec
      (m_File)->( dbgoTop())

      do while .not. (m_File)->(eof())
        filtr := format( "ndoklad = %% and culozsys = 'KAR'", { (m_File)->ndoklad} )
        pvpiteme->( ads_setAof(filtr),dbgoTop())
         do while .not. pvpiteme->(Eof())
           cx := AllTrim(pvpiteme->csklpol)+ ";"+                    ;
                  AllTrim(Str(pvpiteme->nmnozdokl1,13,4)) + ";"+     ;
                    AllTrim(Str(pvpiteme->ndoklad,10,0)) +CRLF
           FWrite( nHandle, cx)
           pvpiteme->( dbSkip())
         enddo
        pvpiteme->( ads_clearAof())
        (m_File)->( dbSkip())
      enddo

    otherwise
      if onLine
        aadd( arSelect, rec_m_File)
      else
        if( len(arSelect) = 0, aadd( arSelect, (m_File)->( recNo()) ), nil )
      endif

      for x := 1 to len( arSelect) step 1
        (m_File)->( dbgoTo( arSelect[x]))

        filtr := format( "ndoklad = %% and culozsys = 'KAR'", { (m_File)->ndoklad} )
        pvpiteme->( ads_setAof(filtr),dbgoTop())
         do while .not. pvpiteme->(Eof())
           cx := AllTrim(Str(pvpiteme->ndoklad,10,0))  + ";"+     ;
                 AllTrim(pvpiteme->csklpol)+ ";"+                 ;
                  AllTrim(Str(pvpiteme->nmnozdokl1,13,4)) +CRLF
           FWrite( nHandle, cx)
           pvpiteme->( dbSkip())
         enddo
        pvpiteme->( ads_clearAof())
      next
    endcase
//    FWrite( nHandle, Chr( 26), 1)
    FClose( nHandle)
  endif

  if .not. onLine
    drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)
  endif

return( nil)


// Import PVPItem - výdejky z KARDEXU v txt formátu
function DIST000079( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, inDir
  local j, n := 0
  local line, aline
  local afiles := {}
  *
  local oThread, lview := .not. empty(oxbp)

  drgDBMS:open( 'pvpterm',,,,, 'pvptermi' )
  drgDBMS:open( 'cenzboz',,,,, 'cenzbozi' )


  if lview
    m_oDBro  := oxbp:parent:odBrowse[1]
    m_File   := lower(m_oDBro:cFile)

    arSelect   := aclone(m_oDBro:arSelect)
    inDir := retDir(odata_datKom:PathImport)   // + odata_datKom:FileImport

    if Upper(oxbp:formName) = 'SYS_SELECTKOM_CRD'
      file := selFILE('VYD_','CSV',inDir,'Výbìr souborù',{{"CSV soubory", "*.CSV"}})
      AAdd( afiles, file)
    else
      afiles := FileInDirs( inDir, 'VYD_*.csv', .t.)
    endif
  else

    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      return 0
    else
      odata_datKom := oThread:odata_datKom
    endif

    inDir  := retDir(odata_datKom:PathImport)
    afiles := FileInDirs( inDir, 'VYD_*.csv', .t.)
  endif


  for j := 1 to len( afiles)
    nHandle  := FOpen( afiles[j], FO_READ )
    cBuffer  := FReadStr(nHandle,128)

    do while cBuffer <> ''
      do while ( n := At( CRLF, cBuffer)) > 0
        line := SubStr( cBuffer,1,n-1)

        aline  := ListAsArray( line,';')
//        key := Padr('101',8)+aline[2]          // hledání podle sklad+sklpol
        key := aline[2]                              // hledání podle sklpol
//        if cenzbozi->( dbSeek( key,,'CENIK18'))      // hledání podle sklad+sklpol
        if cenzbozi->( dbSeek( key,,'CENIK16'))      // hledání podle sklpol
  //        pvptermi->(dbAppend())
          mh_copyFld('cenzbozi','pvptermi',.t.)
          pvptermi->ctypimport := 'K'
//          pvptermi->csklpol    := aline[2]
          pvptermi->nmnozdokl1 := Val(aline[3])
          pvptermi->ncenadokl1 := cenzbozi->ncenaszbo
          pvptermi->ncenadokl  := cenzbozi->ncenaszbo * pvptermi->nmnozdokl1
          pvptermi->cmjdokl1   := cenzbozi->czkratjedn
          pvptermi->cstredisko := aline[4]
          pvptermi->czakazka   := aline[1]

          pvptermi->ctyppohybu := if( Left(aline[1],1) > '3', '60', '62')
          pvptermi->ntyppvp    := 2
          pvptermi->lincenzboz := .t.
          pvptermi->( dbCommit())
        endif
        cBuffer := SubStr( cBuffer,n+2)
      enddo
      cBuffer := cBuffer +FReadStr(nHandle, 128)  // result: 4
    enddo

    FClose( nHandle)

  next

  if lview
    drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)
  endif
return( nil)


// export CENZBOZ do KPK v txt formátu
function DIST000087( oxbp ) // oxbp = drgDialog
  local filtr
  local cx
  local koef
  local ckey
  local m_oDBro, m_File
  local arSelect
  local onLine := .f.

//  drgDBMS:open( 'cenzboz',,,,, 'cenzboze' )
  drgDBMS:open( 'c_prepmj',,,,, 'c_prepmje' )

//  filtr     := format( "ccissklad = '101'")
//  cenzboze->( ads_setAof("ccissklad = '101'"),dbgoTop())

  m_oDBro  := oxbp:parent:odBrowse[1]
  m_File   := lower(m_oDBro:cFile)

  arSelect   := aclone(m_oDBro:arSelect)

  if Upper(oxbp:formName) = 'SYS_SELECTKOM_CRD'
    file := retDir(odata_datKom:PathExport) + odata_datKom:FileExport
    rec_m_File := (m_File)->( recNo())
  else
    file := retDir(odata_datKom:PathExport) + 'export.txt'
    rec_m_File := m_oDBro:ncurrRecNo
    onLine := .t.
  endif

  if .not. Empty(file)
    nHandle := FCreate( file )

    do case
    case m_oDBro:is_selAllRec
      (m_File)->( dbgoTop())

      do while .not. (m_File)->(eof())
        koef := 0
        if (m_File)->culozsys = 'KPK'
          if AllTrim( Upper( (m_File)->CZKRATJEDN)) <> "M"
            ckey := UPPER((m_File)->cCisSklad) + UPPER((m_File)->cSklPol) + UPPER("M  ") + UPPER((m_File)->CZKRATJEDN)
            koef := if( c_prepmje->( dbSeek( ckey,,'C_PREPMJ02')), c_prepmje->nKoefPrVC, 0)
          else
            koef := 1
          endif
          cx := AllTrim((m_File)->ccissklad)+ ";"+                    ;
                  AllTrim((m_File)->csklpol)+ ";"+                    ;
                   AllTrim((m_File)->cnazzbo)+ ";"+                   ;
                    AllTrim((m_File)->cjakost)+ ";"+                  ;
                     AllTrim(Str((m_File)->NMINZBO,13,4)) + ";"+      ;
                      AllTrim(Str((m_File)->NMAXZBO,13,4))+ ";"+      ;
                       AllTrim(Str(koef,13,4)) +CRLF
          FWrite( nHandle, cx)
        endif
        (m_File)->( dbSkip())
      enddo

    otherwise
      if onLine
        aadd( arSelect, rec_m_File)
      else
        if( len(arSelect) = 0, aadd( arSelect, (m_File)->( recNo()) ), nil )
      endif

      for x := 1 to len( arSelect) step 1
        (m_File)->( dbgoTo( arSelect[x]))
        koef := 0
        if (m_File)->culozsys = 'KPK'
          if AllTrim( Upper( (m_File)->CZKRATJEDN)) <> "M"
            ckey := UPPER((m_File)->cCisSklad) + UPPER((m_File)->cSklPol) + UPPER("M  ") + UPPER((m_File)->CZKRATJEDN)
            koef := if( c_prepmje->( dbSeek( ckey,,'C_PREPMJ02')), c_prepmje->nKoefPrVC, 0)
          else
            koef := 1
          endif
          cx := AllTrim((m_File)->ccissklad)+ ";"+                    ;
                  AllTrim((m_File)->csklpol)+ ";"+                    ;
                   AllTrim((m_File)->cnazzbo)+ ";"+                   ;
                    AllTrim((m_File)->cjakost)+ ";"+                  ;
                     AllTrim(Str((m_File)->NMINZBO,13,4)) + ";"+      ;
                      AllTrim(Str((m_File)->NMAXZBO,13,4))+ ";"+      ;
                       AllTrim(Str(koef,13,4)) +CRLF
          FWrite( nHandle, cx)
        endif
      next
    endcase
//    FWrite( nHandle, Chr( 26), 1)
    FClose( nHandle)
  endif

  if .not. onLine
    drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)
  endif

return( nil)



// Import pøíjmù ze systému KPK  --
function DIST000088( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, in_Dir, in_File, in_Ext
  local j, n := 0
  local line, aline
  local cArcFile
  local afiles    := {}
  local afilesDir := {}
  local lview

  *
  local  oBook, oSheet
  local  nRow, nCol, contRows
  local  oThread


  lview := .not. Empty(oxbp)

*  inicializace vazby na excel
  oExcel := CreateObject("Excel.Application")
  if Empty( oExcel )
    if( lview, MsgBox( "Excel nemáte nainstalovaný na poèítaèi" ), nil)
    return 0
  endif

//  drgDBMS:open( 'pvpitem',,,,, 'pvpiteme' )
  drgDBMS:open( 'pvpterm',,,,, 'pvptermi' )
  drgDBMS:open( 'cenzboz',,,,, 'cenzbozi' )

// !!!!!!!!!!!!!!!!!POZOR JEN PRO TESTY !!!!!!!!!!!!!!!!!!!
//  pvptermi->( dbeval( { ||( RLock(),dbDelete()) }, { || pvptermi->ctypimport = 'P'} ))


  if lview
    m_oDBro  := oxbp:parent:odBrowse[1]
    m_File   := lower(m_oDBro:cFile)

    arSelect   := aclone(m_oDBro:arSelect)
    in_Dir  := retDir(odata_datKom:PathImport)
    in_File := Left( odata_datKom:FileImport, Rat( '.', odata_datKom:FileImport) -1 )
    in_Ext  := SubStr( odata_datKom:FileImport, Rat( '.', odata_datKom:FileImport) +1 )

    if Upper(oxbp:formName) = 'SYS_SELECTKOM_CRD'
      afiles := selFILE(in_File,'XLSX',in_Dir,,{{"XLSX soubory", in_File}},,,,.t.)
    else
      afilesDir := FileInDirs( in_Dir, in_File, .t.)
      aEval( afilesDir, {|X|  AAdd( afiles, X[2]+X[1])})
    endif
  else

    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      return 0
    else
      odata_datKom := oThread:odata_datKom
    endif

    in_Dir := retDir(odata_datKom:PathImport)
    afilesDir := Directory( in_Dir + in_File)
    aEval( afilesDir, {|X|  AAdd( afiles, in_Dir +X[1])})
  endif

  if .not. Empty( afiles)
    for j := 1 to len( afiles)
      oBook    := oExcel:workbooks:Open( afiles[j])
      oSheet   := oBook:ActiveSheet
      contRows := oSheet:usedRange:Rows:Count+1
  //    contRows    := oWorkBook:workSheets(1):usedRange:Rows:Count

      for nRow := 2 to contRows
        if.not. Empty( oSheet:Cells(nRow,4):Value)
          key := Padr( AllTrim( Str(oSheet:Cells(nRow,5):Value,8,0)),8) + AllTrim(Str(oSheet:Cells(nRow,4):Value,15,0))                             // hledání podle sklpol
          if cenzbozi->( dbSeek( key,,'CENIK18'))      // hledání podle sklad+sklpol
    //        if cenzbozi->( dbSeek( key,,'CENIK16'))      // hledání podle sklpol
    //        pvptermi->(dbAppend())
            mh_copyFld('cenzbozi','pvptermi',.t.)

            pvptermi->ndoklad    := isNull( pvptermi->sid, 0)
            pvptermi->norditem   := 1

            pvptermi->ctypimport := 'P'
    //          pvptermi->csklpol    := aline[2]
            pvptermi->nmnozdokl1 := oSheet:Cells(nRow,6):Value
            pvptermi->ncenadokl1 := cenzbozi->ncenaszbo
            pvptermi->ncenadokl  := cenzbozi->ncenaszbo * pvptermi->nmnozdokl1
            pvptermi->cmjdokl1   := cenzbozi->czkratjedn
    //          pvptermi->cstredisko := aline[4]
    //          pvptermi->czakazka   := aline[1]

            pvptermi->ctyppohybu :=  '10' // if( Left(aline[1],1) > '3', '60', '62')
            pvptermi->ntyppvp    := 1
            pvptermi->lincenzboz := .t.
            pvptermi->dVznikZazn := Date()
            pvptermi->dZmenaZazn := CtoD('  .  .    ')
            pvptermi->mUserZmenR := ''
//            pvptermi->( dbCommit())
          endif
        endif
      next
      pvpTerm->( DbUnlockAll(), DbCommit())
      oExcel:Quit()
    next

    oExcel:Quit()
    oExcel:Destroy()

    for j := 1 to len( afiles)
      cArcFile := Substr( afiles[j],1 ,Rat( '\', afiles[j])) + "Arc\" +Substr( afiles[j],Rat( '\', afiles[j])+1)
      frename(afiles[j], cArcFile)
    next

    if lview
      cx :=  if( Empty(afiles), 'pøenos údajù nebyl proveden','pøenos údajù byl dokonèen')
      drgMsgBox(drgNLS:msg(cx , XBPMB_INFORMATION),nil)
    endif
  else
    if( lview, MsgBox( "Nebyl vybrán žádný soubor..." ), nil)
    oExcel:Quit()
    oExcel:Destroy()
    return 0
  endif


return(NIL)


// Import výdejù ze systému KPK  --
function DIST000089( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, in_Dir, in_File, in_Ext
  local j, n := 0
  local line, aline
  local cArcFile
  local afiles := {}
  local afilesDir := {}
  local lview
  *
  local  oBook, oSheet
  local  nRow, nCol, contRows
  local  oThread

  lview := .not. Empty(oxbp)

*  inicializace vazby na excel
  oExcel := CreateObject("Excel.Application")
  if Empty( oExcel )
    if( lview, MsgBox( "Excel nemáte nainstalovaný na poèítaèi" ), nil)
    return 0
  endif

//  drgDBMS:open( 'pvpitem',,,,, 'pvpiteme' )
  drgDBMS:open( 'pvpterm',,,,, 'pvptermi' )
  drgDBMS:open( 'cenzboz',,,,, 'cenzbozi' )

// !!!!!!!!!!!!!!!!!POZOR JEN PRO TESTY !!!!!!!!!!!!!!!!!!!
//  pvptermi->( dbeval( { ||( RLock(),dbDelete()) }, { || pvptermi->ctypimport = 'P'} ))

  if lview
    m_oDBro  := oxbp:parent:odBrowse[1]
    m_File   := lower(m_oDBro:cFile)

    arSelect   := aclone(m_oDBro:arSelect)
    in_Dir  := retDir(odata_datKom:PathImport)
    in_File := Left( odata_datKom:FileImport, Rat( '.', odata_datKom:FileImport) -1 )
    in_Ext  := SubStr( odata_datKom:FileImport, Rat( '.', odata_datKom:FileImport) +1 )
  //  afiles := FileInDirs( in_Dir, 'output_výdej*.xls?', .t.)

    if Upper(oxbp:formName) = 'SYS_SELECTKOM_CRD'
      afiles := selFILE(in_File,'XLSX',in_Dir,,{{"XLSX soubory", in_File}},,,,.t.)
    else
      afilesDir := FileInDirs( in_Dir, in_File, .t.)
      aEval( afilesDir, {|X|  AAdd( afiles, X[2]+X[1])})
    endif
  else
    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      return 0
    else
      odata_datKom := oThread:odata_datKom
    endif

    in_Dir := retDir(odata_datKom:PathImport)
    afilesDir := Directory( in_Dir + in_File)
    aEval( afilesDir, {|X|  AAdd( afiles, in_Dir +X[1])})
  endif

  if .not. Empty( afiles)
    for j := 1 to len( afiles)
      oBook    := oExcel:workbooks:Open( afiles[j])
      oSheet   := oBook:ActiveSheet
      contRows := oSheet:usedRange:Rows:Count+1
  //    contRows    := oWorkBook:workSheets(1):usedRange:Rows:Count

      for nRow := 2 to contRows
        if.not. Empty( oSheet:Cells(nRow,4):Value)
          key := Padr( AllTrim( Str(oSheet:Cells(nRow,5):Value,8,0)),8) + AllTrim(Str(oSheet:Cells(nRow,4):Value,15,0))                             // hledání podle sklpol
          if cenzbozi->( dbSeek( key,,'CENIK18'))      // hledání podle sklad+sklpol
    //        if cenzbozi->( dbSeek( key,,'CENIK16'))      // hledání podle sklpol
      //        pvptermi->(dbAppend())
            mh_copyFld('cenzbozi','pvptermi',.t.)

            pvptermi->ndoklad    := isNull( pvptermi->sid, 0)
            pvptermi->norditem   := 1

            pvptermi->ctypimport := 'P'
    //          pvptermi->csklpol    := aline[2]
            pvptermi->nmnozdokl1 := oSheet:Cells(nRow,6):Value
            pvptermi->ncenadokl1 := cenzbozi->ncenaszbo
            pvptermi->ncenadokl  := cenzbozi->ncenaszbo * pvptermi->nmnozdokl1
            pvptermi->cmjdokl1   := cenzbozi->czkratjedn
            do case
            case ValType(oSheet:Cells(nRow,15):Value) = "C"
              pvptermi->cstredisko := AllTrim(oSheet:Cells(nRow,15):Value)
            case ValType(oSheet:Cells(nRow,15):Value) = "N"
              pvptermi->cstredisko := AllTrim(Str(oSheet:Cells(nRow,15):Value,8,0))
            otherwise
              pvptermi->cstredisko := ''
            endcase

  //          xx := ValType(oSheet:Cells(nRow,9):Value)
            do case
            case ValType(oSheet:Cells(nRow,9):Value) = "C"
              if ( n := at( '/', oSheet:Cells(nRow,9):Value)) > 0
                pvptermi->czakazka   := SubStr(oSheet:Cells(nRow,9):Value,1,n-1)
              else
                pvptermi->czakazka   := AllTrim(oSheet:Cells(nRow,9):Value)
              endif
            case ValType(oSheet:Cells(nRow,9):Value) = "N"
              pvptermi->czakazka := AllTrim(Str(oSheet:Cells(nRow,9):Value,8,0))
            otherwise
              pvptermi->czakazka := ''
            endcase

            pvptermi->cvyrobek   := ''
            pvptermi->ctyppohybu := if( Left(AllTrim(pvptermi->czakazka),1) > '3', '60', '62')
            pvptermi->ntyppvp    := 2
            pvptermi->lincenzboz := .t.
            pvptermi->dVznikZazn := Date()
            pvptermi->dZmenaZazn := CtoD('  .  .    ')
            pvptermi->mUserZmenR := ''
//            pvptermi->( dbCommit())
          endif
        endif
      next

      pvpTerm->( DbUnlockAll(), DbCommit())

      oExcel:Quit()
  //    cArcFile := Substr( afiles[j],1 ,Rat( '\', afiles[j])) + "Arc\" +Substr( afiles[j],Rat( '\', afiles[j])+1)
  //    cx := afiles[j] + ' --> ' + cArcFile
  //    drgdump( 'test', cx)
  //    frename(afiles[j], cArcFile)
  //    FileMove(afiles[j], cArcFile)
    next

    oExcel:Quit()
    oExcel:Destroy()

    for j := 1 to len( afiles)
      cArcFile := Substr( afiles[j],1 ,Rat( '\', afiles[j])) + "Arc\" +Substr( afiles[j],Rat( '\', afiles[j])+1)
      frename(afiles[j], cArcFile)
  //    FileMove(afiles[j], cArcFile)
    next

    if lview
      cx :=  if( Empty(afiles), 'pøenos údajù nebyl proveden','pøenos údajù byl dokonèen')
      drgMsgBox(drgNLS:msg(cx , XBPMB_INFORMATION),nil)
    endif
  else
    if( lview, MsgBox( "Nebyl vybrán žádný soubor..." ), nil)
    oExcel:Quit()
    oExcel:Destroy()
    return 0
  endif

return(NIL)


// Export CENZBOZ (skl.položka, skl.množ.) - TXT
function DIST000105( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, in_Dir, in_File, in_Ext
  local j, n := 0
  local line, aline
  local cArcFile
  local afiles    := {}
  local afilesDir := {}
  local lview

  *
  local  oBook, oSheet
  local  nRow, nCol, contRows
  local  oThread

  lview := .not. Empty(oxbp)

  drgDBMS:open( 'cenzboz',,,,, 'cenzboze' )

  if lview
    m_oDBro  := oxbp:parent:odBrowse[1]
    m_File   := lower(m_oDBro:cFile)

    if Upper(oxbp:formName) = 'SYS_SELECTKOM_CRD'
      file := retDir(odata_datKom:PathExport) + AllTrim(odata_datKom:FileExport)
      rec_m_File := (m_File)->( recNo())
    else
      file := retDir(odata_datKom:PathExport) + AllTrim(odata_datKom:FileExport)
      rec_m_File := m_oDBro:ncurrRecNo
      onLine := .t.
    endif
  else


    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      return 0
    else
      odata_datKom := oThread:odata_datKom
    endif
    m_File := 'cenzboze'
    file   := retDir(odata_datKom:PathExport) + AllTrim(odata_datKom:FileExport)
  endif


  if .not. Empty(file)
    nHandle := FCreate( file )
    cx      := AllTrim(odata_datKom:Sklad)
    cx      := Padr( cX, 8, ' ')
    filtr   := format( "ccissklad = '%%'", { cx})
    (m_File)->( ads_setAof(filtr),dbgoTop())

    do while .not. (m_File)->(eof())
      cx := AllTrim((m_File)->csklpol)+ ";"+                 ;
              AllTrim(Str((m_File)->nmnozdzbo*10000,,0)) +CRLF
      FWrite( nHandle, cx)
      (m_File)->( dbSkip())
    enddo

    (m_File)->( ads_ClearAof())
    (m_File)->( dbCloseArea())
    FClose( nHandle)

    if lview
      drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)
    endif
  else
    if( lview, MsgBox( "Není možné vytvoøit exportní soubor..." ), nil)
    return 0
  endif


return(NIL)


// Export CENZBOZ (skl.položka, hmotnost) - TXT
function DIST000127( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, in_Dir, in_File, in_Ext
  local j, n := 0
  local line, aline
  local cArcFile
  local afiles    := {}
  local afilesDir := {}
  local lview

  *
  local  oBook, oSheet
  local  nRow, nCol, contRows
  local  oThread

  lview := .not. Empty(oxbp)

  drgDBMS:open( 'cenzboz',,,,, 'cenzboze' )

  if lview
    m_oDBro  := oxbp:parent:odBrowse[1]
    m_File   := lower(m_oDBro:cFile)

    if Upper(oxbp:formName) = 'SYS_SELECTKOM_CRD'
      file := retDir(odata_datKom:PathExport) + AllTrim(odata_datKom:FileExport)
      rec_m_File := (m_File)->( recNo())
    else
      file := retDir(odata_datKom:PathExport) + AllTrim(odata_datKom:FileExport)
      rec_m_File := m_oDBro:ncurrRecNo
      onLine := .t.
    endif
  else


    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      return 0
    else
      odata_datKom := oThread:odata_datKom
    endif
    m_File := 'cenzboze'
    file   := retDir(odata_datKom:PathExport) + AllTrim(odata_datKom:FileExport)
  endif


  if .not. Empty(file)
    nHandle := FCreate( file )
    cx      := AllTrim(odata_datKom:Sklad)
    cx      := Padr( cX, 8, ' ')
    filtr   := format( "ccissklad = '%%'", { cx})
    (m_File)->( ads_setAof(filtr),dbgoTop())

    do while .not. (m_File)->(eof())
      cx := AllTrim((m_File)->csklpol)+ ";"+                 ;
              AllTrim( StrTran( Str((m_File)->nhmotnost),'.',',')) +CRLF
      FWrite( nHandle, cx)
      (m_File)->( dbSkip())
    enddo

    (m_File)->( ads_ClearAof())
    (m_File)->( dbCloseArea())
    FClose( nHandle)

    if lview
      drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)
    endif
  else
    if( lview, MsgBox( "Není možné vytvoøit exportní soubor..." ), nil)
    return 0
  endif


return(NIL)