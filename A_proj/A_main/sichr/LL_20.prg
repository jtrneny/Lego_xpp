#include "Xbp.ch"
#include "dll.ch"

#ifdef __LL23__
  #include "..\A_main\cmbtLL23.ch"
  #include "..\A_main\cmbtLS23.ch"
#else
  #include "..\A_main\cmbtLL20.ch"
  #include "..\A_main\cmbtLS20.ch"
#endif

#include "common.ch"
#include "directry.ch"
#include "class.ch"
*
#include "ads.ch"
#include "adsdbe.ch"
*
#include 'bap.ch'
#include "drg.ch"
#include "Fileio.ch"



#xtranslate  .fields    =>  \[1\]
#xtranslate  .value     =>  \[2\]
#xtranslate  .type      =>  \[3\]
#xtranslate  .fieldsFCE =>  \[4\]

#DEFINE  COMPILE(c)            &("{||" + c + "}")
#DEFINE  DBGETVAL(c)     Eval( &("{||" + c + "}"))


#define ADS_COMPOUND             0x00000002
#define WM_USER                  0x0400


STATIC  sName, sNameExt, hJob, cresetKey, xresetKey, llProjType
STATIC  pa_inSections, pa_Function
STATIC  sn_cmLL11 := 0, sn_cmPR11 := 0, sn_cmBR11 := 0, sn_cmCT11 := 0


DLLFUNCTION GetTempPathA(buffsize,@buffer) USING STDCALL FROM KERNEL32.DLL
DLLFUNCTION GetPrivateProfileSectionA(ASection, @ABuffer, ALength, AFileName) USING STDCALL FROM KERNEL32.DLL


/*------------------- INIT/EXIT PROC'S  -------------------*/
INIT PROCEDURE LL_EXTI()
*  sn_cmLL11 := DllLoad("CMLL11.DLL")
*  sn_cmPR11 := DllLoad("CMPR11.DLL")
*  sn_cmBR11 := DllLoad("CMBR11.DLL")
*  sn_cmCT11 := DllLoad("CMCT11.DLL")
RETURN


EXIT PROCEDURE LL_EXTE()
*  DllUnload(sn_cmLL11)
*  DllUnload(sn_cmPR11)
*  DllUnload(sn_cmBR11)
*  DllUnload(sn_cmCT11)
RETURN



*
**
PROCEDURE LL_DefineDesign(isPrint,isdesc, isczech, cond, auto, poini)
  LOCAL  aFILE := {}, oini
  local  nVer_Major, nVer_Minor

  DEFAULT isPrint TO .F., isdesc TO .F., isczech TO .F., auto TO .F.

  sName       := drgINI:dir_USERfitm +userWorkDir() +'\' +FORMS ->cIDForms
  sNameExt    := isNull( FileExt(), '.lst' )
  llProjType  := FORMs ->nTYPPROJ_L
  pa_Function := {}

  #ifdef __LL23__
    LL23ModuleInit()
  #else
    LL20ModuleInit()
  #endif

  if isczech
    hJob := LlJobOpen(CMBTLANG_DEFAULT)  // CMBTLANG_CZECH)
  else
    hJob := LlJobOpen(CMBTLANG_ENGLISH)
  endif

  #ifdef __LL23__
    LlSetOptionString (hJob, LL_OPTIONSTR_LICENSINGINFO, "KQllHQ")
  #else
    LlSetOptionString (hJob, LL_OPTIONSTR_LICENSINGINFO, "UYZLEQ")
  #endif

  LlSetOption(hJob, LL_OPTION_MULTIPLETABLELINES, 1)

  LlDefineVariableStart(hJob)
  if( llProjType = LL_PROJECT_LIST, LlDefineFieldStart(hJob), nil)

  *config je iplicinì v sekci variables*
  DefineConf(.F., 'CONFIGHD')
  if( .not. auto, DefineAsys(), nil)
  DefineLastObdobi()

  *pokud je v mFORMS_LL vzor tak ho LL zpøístupníme*
  IF( .not. Empty(FORMs ->mFORMS_ll), MemoWrit(sName +sNameExt, FORMs ->mFORMS_ll), NIL)

  oini := LLIniFile():new(IsObject(isPrint), isdesc, sName +sNameExt)
  oini:hJob          := hJob
  oini:cMemDesign_LL := sName +sNameExt
  oini:sName         := sName
  oini:sNameExt      := sNameExt

  nVer_Major := LlGetVersion(LL_VERSION_MAJOR)
  nVer_Minor := LlGetVersion(LL_VERSION_MINOR)

  IF IsObject(isPrint)
    ** v návrhu doplníme desc z DBD isdesc = .t.
    if ( .not. Empty(FORMs ->mFORMS_ll), ModifyDesign(.T., isdesc, oini:aRelFor_LL), nil )

    LlSetPrinterDefaultsDir(hJob, MyGetTempPath())
    LlDefineLayout(hJob, SetAppWindow():GetHWND(),"Designer", llProjType +LL_NOSAVEAS, sName)
    *
    LlJobClose(hJob)

    #ifdef __LL23__
      LL23ModuleExit()
    #else
      LL20ModuleExit()
    #endif
    *
    * uložíme vzor výstupu s smažeme podklad pro LL
    IF File(sName +sNameExt)
      * tady by to chtìlo zmìnu,
      * pokud je Empty(FORMs ->mFORMS_ll) tj. nová sestava a soubor LL -ko vytvoøilo, uložit
      * pokud opravuji sestavu a pokud je F_WRITE_DATE-org <> F_WRITE_DATE-new .or. F_WRITE_TIME-old <> F_WRITE_TIME-new uložit

      IF FORMs ->(DbRLock())

        oini:ReadSections(.f.)
        FORMs ->mFORMS_LL := ModifyDesign(.F., isdesc, oini:aRelFor_LL)
        forms ->nFORMS_LL := if('[List description]'  $ forms->mforms_ll .or. ;
                                '[Label description]' $ forms->mforms_ll .or. ;
                                '[Cards description]' $ forms->mforms_ll, 1, 0)

        forms ->nVer_Major := nVer_Major
        forms ->nVer_Minor := nVer_Minor

        FORMs ->(dbcommit(), DbUnlock())
      ENDIF

      aFile := Directory(sName +'.*')
      AEval( aFile, { |a| FErase(drgINI:dir_USERfitm+a[F_NAME]) } )
    ENDIF

    oini:destroy()
  else

    poini := oini
  ENDIF
RETURN


*
**
PROCEDURE LL_PrintDesign(isdesc, typ, cond, auto, cPrinter, nCopies)
  local  ncount, nakt := 0, nret, mainTabe
  local  variables, fields, pa, x, bp, file, field_name, adata := {}
  *
  local  lenBuff := 40960, buffer := space(lenBuff)
  local  print, txt, oini, pa_Rel := {}, npos
  *
  local  cPreviewTempPath := StrTran(MyGetTempPath(), Chr(0), '') +UserWorkDir() +'\'
  local  ncallBack
  local  xret, cBuffer := space(255), nBuffer := 255


  default typ  to "PRV", auto to .f., cPrinter to '', nCopies to 0


  LL_DefineDesign( .T., isdesc, .T., cond, auto, @oini)
  mainTable := oini:file


  * po nìjakém výbìru nemá pokraèovat
  if .not. oini:lcan_continue
     LlJobClose(oini:hJob)

     #ifdef __LL23__
       LL23ModuleExit()
     #else
       LL20ModuleExit()
     #endif

     oini:destroy()
     RemoveDir(cPreviewTempPath)
     return
  endif


  * naèteme ze sekece UsedIdentifiers Fields, pro vlastní TISK pøedáme jen tyto položky *
  GetPrivateProfileStringA('UsedIdentifiers', 'Variables', '', @buffer, lenBuff, sName +sNameExt)
  variables := substr(buffer,1,len(trim(buffer))-1)

  pa := ListAsArray(variables,';')
  if .not. Empty(pa[1])
    for x := 1 to len(pa) step 1
      pb         := ListAsArray(pa[x],'.')
      file       := pb[len(pb) -1]
      field_name := pb[len(pb)   ]

      if IsObject( odbd := drgDBMS:dbd:getByKey(file))
        if IsObject(odrgrf := odbd:getFieldDesc(field_name))
          AAdd(adata, {pa[x],file +'->' +field_name,odrgrf:type})
        endif
      endif
    next
  endif

  * naèteme ze sekece UsedIdentifiers Fields, pro vlastní TISK pøedáme jen tyto položky *
  buffer := space(lenBuff)
  GetPrivateProfileStringA('UsedIdentifiers', 'Fields', '', @buffer, lenBuff, sName +sNameExt)
  fields := substr(buffer,1,len(trim(buffer))-1)

  * relaèní soubory mohou mít jiné ALIASy mají délku 6
  *                                                          5 soubor
  *                                                                6 alias
  aeval( oini:aRELFor_LL, { |x| if( len(x) = 6, aadd( pa_Rel, { x[5], x[6] }), nil ) })

  pa := ListAsArray(fields,';')
  if .not. Empty(pa[1])
    for x := 1 to len(pa) step 1
      pb         := ListAsArray(pa[x],'.')
      file       := pb[len(pb) -1]
      field_name := pb[len(pb)   ]

      * jedná se o relaèní soubor a má jiný alias
      if( npos := ascan( pa_Rel, { |x| lower(x[2]) = lower(file) })) <> 0
        file := pa_Rel[npos,1]
      endif

      if IsObject( odbd := drgDBMS:dbd:getByKey(file))
        if IsObject(odrgrf := odbd:getFieldDesc(field_name))
          AAdd(adata, {pa[x],if( npos = 0, file, pa_Rel[npos,2] ) +'->' +field_name,odrgrf:type})
        endif
      endif

      if upper(pb[1]) = 'FCE'
        if( npos := ascan( pa_Function, { |x| lower(x[3]) = lower(pb[2]) })) <> 0
          AAdd(adata, { pa_Function[npos,3], pa_Function[npos,1], pa_Function[npos,2], 'FCE.' +pa_Function[npos,3] })
        endif
      endif

    next
  endif

  ncount := (mainTable) ->(Ads_GetRecordCount())
  nakt   := 0
  (mainTable) ->(DbGoTop())

  do case
  case typ == "PRN"  ; ( print := LL_PRINT_NORMAL,     txt := 'Tisk')
  case typ == "SEL"  ; ( print := LL_PRINT_USERSELECT, txt := 'Pøímý tisk')
  case typ == "FIL"  ; ( print := LL_PRINT_FILE,       txt := 'Tisk do souboru')
  case typ == "EXP"  ; ( print := LL_PRINT_EXPORT,     txt := 'Export')
  otherwise          ; ( print := LL_PRINT_PREVIEW,    txt := 'Náhled')
  endcase


  LlSetPrinterDefaultsDir(hJob, MyGetTempPath())

  *
  ** možnost nastavit tiskárnu jinou než je default ve Win
  if .not. empty(cPrinter)
    Aret := LlSetPrinterInPrinterFile( hJob            , ;
                                       llProjType      , ;
                                       sName +sNameExt , ;
                                       -1              , ;
                                       cPrinter        , 0 )
  endif


  nret := LlPrintWithBoxStart(oini:hJob,                ;
                              llProjType,               ;
                              sName +sNameExt,          ;
                              print,                    ;
                              LL_BOXTYPE_NORMALMETER,   ;
                              SetAppWindow():GetHWND(), ;
                              txt)

  if typ = 'EXP'
    LlSetOptionString(hJob, LL_OPTIONSTR_EXPORTS_ALLOWED, ;
    "PRV;HTML;RTF;PDF;MHTML;XML;PICTURE_JPEG;PICTURE_EMF;PICTURE_BMP;PICTURE_TIFF;PICTURE_MULTITIFF;XLS;TTY;TXT" )

    xret := LlPrintOptionsDialog( oini:hJob, SetAppWindow():GetHWND(), 'Export ... ')

    if xret = LL_ERR_USER_ABORTED
      LlJobClose(oini:hJob)

      #ifdef __LL23__
        LL23ModuleExit()
      #else
        LL20ModuleExit()
      #endif

      oini:destroy()
      RemoveDir(cPreviewTempPath)
      RETURN
    endif

    LlPrintGetOptionString( oini:hJob, LL_PRNOPTSTR_EXPORT, @cBuffer, @nBuffer)
    if ( nPos := AT( CHR(0), cBuffer ) ) > 0
      cBuffer := SUBSTR(cBuffer, 1, nPos-1 )
    endif
    cBuffer := TRIM(cBuffer)

    if cBuffer <> 'PRV'
       LlXSetParameter(hJob, LL_LLX_EXTENSIONTYPE_EXPORT, cBuffer, "Export.ShowResult","1")
    endif
  endif

  if nCopies <> 0 .and. typ = 'PRN'
    Bret := LlPrintSetOption(hJob,LL_PRNOPT_COPIES,nCopies)
  endif

  MyCreateDir(cPreviewTempPath)
  LlPreviewSetTempPath(hJob, cPreviewTempPath)

  if( llProjType = LL_PROJECT_LIST,  nret := LlPrint(oini:hJob), nil)

  (mainTable) ->(DbGoTop())
  *
  * smyèka zpracování základního souboru *
  do while (ncount > 0) .AND. (nret = 0) .AND. .not. (mainTable) ->(Eof())

    if llProjType = LL_PROJECT_LIST
      Print_DefineData(adata,.f.)
      nRet := LlPrintFields(oini:hJob)

      do while nRet=LL_WRN_REPEAT_DATA
        LlPrint(oini:hJob)
        nRet:=LlPrintFields(oini:hJob)
      enddo

    else
      Print_DefineData(adata,.t.)
      nret := LlPrint(oini:hJob)
    endif

    (mainTable) ->(dbSkip())
    *
    if(.not. empty(cresetKey), LL_ResetKey(mainTable,adata), nil )
    *
    nAkt := nAkt + 1
    LlPrintSetBoxText(hJob, "Zpracování výstupu pro tisk ...", ( (100*nakt)/ncount ))
  end do

  if llProjType = LL_PROJECT_LIST
    nRet:=LlPrintFieldsEnd(oini:hJob)

    do while nRet=LL_WRN_REPEAT_DATA
      nRet:=LlPrintFieldsEnd(oini:hJob)
    enddo
  endif

  LlPrintEnd(oini:hJob, 0)

  if nRet = 0 .or. nRet = LL_ERR_USER_ABORTED
    if print = LL_PRINT_PREVIEW
      #ifdef __LL23__
        LS23ModuleInit()
      #else
        LS20ModuleInit()
      #endif
    endif

    nCallBack := BaCallBack("LL_PreviewButtonPressed", BA_CB_GENERIC4)
    nRetx     := LlSetNotificationCallback(hJob,nCallBack)

    LlPreviewDisplay(oini:hJob, oini:sName, cPreviewTempPath, SetAppWindow():GetHWND())
    LlPreviewDeleteFiles(oini:hJob, oini:sName, cPreviewTempPath)

    LlSetNotificationCallback(hJob,0)

    if print = LL_PRINT_PREVIEW
      #ifdef __LL23__
        LS23ModuleExit()
      #else
        LS20ModuleExit()
      #endif
    endif
  endif
  *
  ** pokud si nastaví jinou tiskárnu, musíme ji vrátit na DEFAULT, jinak si to pamatuje
  if .not. empty(cPrinter)
    LLsetPrinterToDefault( hJob, llProjType, sName +sNameExt )
  endif

  LlJobClose(hJob)

  #ifdef __LL23__
    LL23ModuleExit()
  #else
    LL20ModuleExit()
  #endif

  oini:destroy()
  RemoveDir(cPreviewTempPath)
RETURN


function LL_PreviewButtonPressed (xl0,xl1,xl2,xl3)
  local nBtn

  if xl0 = LL_NTFY_VIEWERBTNCLICKED
    do case
    case xl1 = 112 .or. xl1 = 113    // 112 -Tisk aktuální stránky...  113 -Tisk všech stránek...1
      lprinted := .t.
    case xl1 = 115                   // 115 -Poslat komu ...
      lsend_email   := .t.
    endcase
  endif
return 0


*
** STATIC PROCEDURE/FUNCTION ***************************************************
static procedure LL_ResetKey(mainTable,adata)
  local wresetKey := DBGETVAL(cresetKey)

  if wresetKey <> xresetKey .and. .not. (mainTable) ->(eof())
    nRet:=LlPrintFieldsEnd(hJob)

    if llProjType = LL_PROJECT_LIST
      do while nRet=LL_WRN_REPEAT_DATA
        nRet:=LlPrintFieldsEnd(hJob)
      enddo
    endif

    LlPrintResetProjectState(hJob)

    *config je iplicinì v sekci variables*
    DefineConf(.F., 'CONFIGHD')

    Print_DefineData( adata, .t. )
    Print_DefineData( adata, .f. )

    nret := LlPrint(hJob)
    xresetKey := wresetKey
  endif
return


static procedure Print_DefineData(adata, isVariable)
  local  x, type, value, DateBuffer,lexpr
  local  FldContent, FldType

  for x := 1 to len(adata) step 1
    type       := upper( adata[x].type )
    value      := DBGETVAL(adata[x].value)
    DateBuffer := Replicate(chr(0),255)

    do case
    case type == 'I' .or. type == 'F' .or. type == 'N'
      FldType    := LL_NUMERIC
      FldContent := Str(value)

    case type == "D"
      FldType := LL_DATE
      lexpr   := LlExprParse(hJob,"DateToJulian(DATE("+chr(34)+DTOC(value)+chr(34)+"))", .F.)

      LlExprEvaluate(hJob, lExpr, @DateBuffer, 255)
      LlExprFree(hJob, lExpr)

      FldContent := DateBuffer

    case type == "L"
      FldType    := LL_BOOLEAN
      FldContent := if(value, 'TRUE', 'FALSE')

    case type == "C"
      FldType    := LL_TEXT
      FldContent := Trim(value)

    case type == "M"
      FldType    := LL_TEXT
      FldContent := value
    endcase

    if isVariable
      LlDefineVariableExt(hJob, if( len(adata[x]) = 4, adata[x].fieldsFCE, adata[x].fields ), FldContent, FldType, 0 )
    else
      LlDefineFieldExt(hJob, if( len(adata[x]) = 4, adata[x].fieldsFCE, adata[x].fields ), FldContent, FldType, 0 )
    endif
  next
return

*
**
STATIC PROCEDURE DefineData(isVariable, filem, filer, inDesign, isdesc, cdbd_File)
  LOCAL  FldType, FldContent, DateBuffer, lExpr
  *
  LOCAL  fldCout, type, value, file, fields, field_desc
  LOCAL  aField, aType, aLen, aDec
  LOCAL  odbd, odrgrf
  *
  local  cvarName, npos

  if IsNull(filer)
    file     := filem
    fldCount := (filem) ->(Fcount())
  else
    file     := filer
    fldCount := (filer) ->(Fcount())
  endif

  aField   := Array(fldCount)
  aType    := Array(fldCount)
  aLen     := Array(fldCount)
  aDec     := Array(fldCount)
  (file) ->( AFields(aField, aType, aLen, aDec))
  *
  odbd := drgDBMS:dbd:getByKey( if( .not. empty(cdbd_File), cdbd_File, file) )

  FOR i := 1 to fldCount STEP 1
     type  := aType[i]
    value := (file) ->(FieldGet(i))

    DateBuffer = Replicate(chr(0), 255)

    DO CASE
    CASE type == "I" .or. type == "F" .or. type == "N"
      FldType    := LL_NUMERIC
      FldContent := Str(value)

    CASE type == "D"
      FldType := LL_DATE
      lExpr   := LlExprParse(hJob,"DateToJulian(DATE("+chr(34)+DTOC(value)+chr(34)+"))", .F.)

      LlExprEvaluate(hJob, lExpr, @DateBuffer, 255)
      LlExprFree(hJob, lExpr)

      FldContent := DateBuffer

    CASE type == "L"
      FldType    := LL_BOOLEAN
      FldContent := IF(value, 'TRUE', 'FALSE')

    CASE type == "C"
      FldType    := LL_TEXT
      FldContent := Trim(value)

    CASE type == "M"
      FldType    := LL_TEXT
      FldContent := value
    END CASE

    fields     := filem +If(IsCHARACTER(filer), '.'+filer, '')
    if isdesc
      field_desc := if( IsObject(odrgrf := odbd:getFieldDesc(aField[i])), odrgrf:desc, '')
      field_desc := if( isNull(field_desc),'', field_desc_mod(field_desc))
    else
      field_desc := ''
    endif

    cvarName := fields +'.' +upper(aField[i])

    if isVariable
      LlDefineVariableExt(hJob, cvarName +if( empty(field_desc), '', '__') +field_desc, FldContent, FldType, 0 )

    elseif .not. isVariable
      LlDefineFieldExt(hJob, cvarName +if( empty(field_desc), '', '__') +field_desc, FldContent, FldType, 0 )
    endif
  NEXT I
RETURN
*
**
STATIC PROCEDURE DefineFce(isVariable, bfce, filer, ctype, caption, isDesc)
  LOCAL  FldType, FldContent, DateBuffer, lExpr
  *
  LOCAL  fldCout, value, file, fields, field_desc
  LOCAL  aField, aType, aLen, aDec, type
  LOCAL  odbd, odrgrf
  *
  local  cvarName, npos

    type  := Upper(ctype)
    value := DBGETVAL( bfce)

    DateBuffer = Replicate(chr(0), 255)

    DO CASE
    CASE type == "I" .or. type == "F" .or. type == "N"
      FldType    := LL_NUMERIC
      FldContent := Str(value)

    CASE type == "D"
      FldType := LL_DATE
      lExpr   := LlExprParse(hJob,"DateToJulian(DATE("+chr(34)+DTOC(value)+chr(34)+"))", .F.)

      LlExprEvaluate(hJob, lExpr, @DateBuffer, 255)
      LlExprFree(hJob, lExpr)

      FldContent := DateBuffer

    CASE type == "L"
      FldType    := LL_BOOLEAN
      FldContent := IF(value, 'TRUE', 'FALSE')

    CASE type == "C"
      FldType    := LL_TEXT
      FldContent := Trim(value)

    CASE type == "M"
      FldType    := LL_TEXT
      FldContent := value
    END CASE

    fields     := 'fce' +If(IsCHARACTER(filer), '.'+filer, '')
    if isdesc
      field_desc := caption
    else
      field_desc := ''
    endif

    cvarName := fields

    if isVariable
      LlDefineVariableExt(hJob, cvarName +if( empty(field_desc), '', '__') +field_desc, FldContent, FldType, 0 )
    elseif .not. isVariable
      LlDefineFieldExt(hJob, cvarName +if( empty(field_desc), '', '__') +field_desc, FldContent, FldType, 0 )
    endif
RETURN
*
**
STATIC PROCEDURE DefineConf(bAsField, filem)
  LOCAL FldType, FldContent, DateBuffer, lExpr
  *
  LOCAL fldCout, type, value, file, prom, filema
  LOCAL aField, aType, aLen, aDec
  *

  filema := filem +'a'
  drgDBMS:open(filem,,,,,filema)
              (filema) ->(DbGoTop())
  fldCount := (filema) ->(Fcount())

  aField   := Array(fldCount)
  aType    := Array(fldCount)
  aLen     := Array(fldCount)
  aDec     := Array(fldCount)
  (filema) ->( AFields(aField, aType, aLen, aDec))

  DO WHILE .not. (filema)->(Eof())
    DateBuffer = Replicate(chr(0), 255)

    cfgItem  := StrTran('Konfigurace.' +(filema)->cTask+ '.' +(filema)->cItem, ' ', '')
    cfgType  := (filema)->cTyp
    cfgLen   := Len((filema)->cPicture)
    prom     := AllTrim((filema)->cTask)+ ':' +AllTrim((filema)->cItem)

    do case
    case Upper(prom) == "SYSTEM:CUSERNAM"
      cfgValue := logOsoba
    otherwise
      cfgValue := SysConfig(prom)
    endcase

    if ValType( cfgValue) = 'A'
      cfgValue := Str( cfgValue[1]) + '__' +Str( cfgValue[2])
      cfgType  := 'C'
    endif

    DO CASE
    CASE cfgType = 'I' .or. cfgType = 'F' .or. cfgType = 'N'
      FldType    := LL_NUMERIC
      FldContent := Str(cfgValue)

    CASE cfgType = "D"
      FldType := LL_DATE
      lExpr   := LlExprParse(hJob,"DateToJulian(DATE("+chr(34)+cfgValue+chr(34)+"))", .F.)

      LlExprEvaluate(hJob, lExpr, @DateBuffer, 255)
      LlExprFree(hJob, lExpr)
      FldContent = DateBuffer

    CASE cfgType == "L"
      FldType    := LL_BOOLEAN
      FldContent := IF( cfgValue, 'TRUE', 'FALSE')

    CASE cfgType == "C"
      if Left(Upper(prom),16) == "SYSTEM:CPATHLOGO"
        FldType    := LL_DRAWING
      else
        FldType    := LL_TEXT
      endif
      FldContent := Trim(cfgValue)

    CASE cfgType == "M"
      FldType    := LL_TEXT
      FldContent := cfgValue
    END CASE

    DO CASE
    CASE bAsField==.F.
      LlDefineVariableExt(hJob, cfgItem, FldContent, FldType, 0 )
    CASE bAsField==.T.
      LlDefineFieldExt(hJob, cfgItem, FldContent, FldType, 0 )
    END CASE

    (filema) ->(DbSKip())
  ENDDO

RETURN


*
**
STATIC PROCEDURE DefineAsys()
  LOCAL ll_cond := ''
  local recNo

  LlDefineVariableExt(hJob, 'Asystem.TiskZaObdobi', obdReport, LL_TEXT, 0 )

  if select('filtritw') <> 0
    recNo := filtritw ->( recNo())
    filtritw ->( dbGoTop())
    do while .not.filtritw ->(eof())
      ll_cond += if(empty(filtritw ->clgate_1),'',alltrim(filtritw ->clgate_1) +' ') +   ;
                  if(empty(filtritw ->clgate_2),'',alltrim(filtritw ->clgate_2) +' ' )+                    ;
                   if(empty(filtritw ->clgate_3),'',alltrim(filtritw ->clgate_3) +' ') +                   ;
                    if(empty(filtritw ->clgate_4),'',alltrim(filtritw ->clgate_4) +' ') +                  ;
                     if(empty(filtritw ->cvyraz_1u),'',alltrim(filtritw ->cvyraz_1u) +' ') +               ;
                      if(empty(filtritw ->crelace),'',alltrim(filtritw ->crelace) +' ') +                  ;
                       if(empty(filtritw ->cvyraz_2u),'',alltrim(filtritw ->cvyraz_2u) +' ') +             ;
                        if(empty(filtritw ->coperand),'',alltrim(filtritw ->coperand) +' ') +              ;
                    if(empty(filtritw ->crgate_1),'',alltrim(filtritw ->crgate_1) +' ') +                  ;
                   if(empty(filtritw ->crgate_2),'',alltrim(filtritw ->crgate_2) +' ') +                   ;
                  if(empty(filtritw ->crgate_3),'',alltrim(filtritw ->crgate_3) +' ') +                    ;
                 if(empty(filtritw ->crgate_4),'',alltrim(filtritw ->crgate_4) +' ') + CRLF
      filtritw ->(DbSkip())
    enddo
    filtritw ->( dbgoTo(recNo))
  endif

  if empty(ll_cond)
    LlDefineVariableExt(hJob, 'Asystem.ExtFilterName'      , '', LL_TEXT, 0 )
    LlDefineVariableExt(hJob, 'Asystem.ExtFilterExpression', '', LL_TEXT, 0 )
  else
    LlDefineVariableExt(hJob, 'Asystem.ExtFilterName', Filtrs->cFltName, LL_TEXT, 0 )
    LlDefineVariableExt(hJob, 'Asystem.ExtFilterExpression', ll_cond, LL_TEXT, 0 )
  endif

  if( select('filrtitw') <> 0, filtritw ->( dbGoTop()), nil )

  LlDefineVariableExt(hJob, 'Asystem.usrName',   usrName, LL_TEXT, 0 )
  LlDefineVariableExt(hJob, 'Asystem.logUser',   logUser, LL_TEXT, 0 )
  LlDefineVariableExt(hJob, 'Asystem.logOsoba',  logUser, LL_TEXT, 0 )
  LlDefineVariableExt(hJob, 'Asystem.formsID',   forms->cIDForms, LL_TEXT, 0 )
  LlDefineVariableExt(hJob, 'Asystem.formsName', forms->cFormName, LL_TEXT, 0 )

RETURN
*
**
STATIC PROCEDURE DefineLastObdobi()
  local  x, pa
  local  ctask, cnazUlohy
  local  nrok, nobdobi, cobdobi, crokObd
  local  o_lastOBD := uctOBDOBI_LAST

  for x := 1 to len(o_lastOBD:aTASK_list) step 1

    pa        := listAsArray( o_lastOBD:aTASK_list[x], ':' )
    ctask     := pa[1]
    cnazUlohy := pa[3]

    nrok      := uctOBDOBI_LAST:&ctask:nrok
    nobdobi   := uctOBDOBI_LAST:&ctask:nobdobi
    cobdobi   := uctOBDOBI_LAST:&ctask:cobdobi
    cobdRok   := strZero( nobdobi,2) +'/' +strZero( nrok,4)

    LlDefineVariableExt(hJob, 'LastObdobi.' +ctask +'.nrok'    , str(nrok)   , LL_NUMERIC, 0 )
    LlDefineVariableExt(hJob, 'LastObdobi.' +ctask +'.nrobdobi', str(nobdobi), LL_NUMERIC, 0 )
    LlDefineVariableExt(hJob, 'LastObdobi.' +ctask +'.cobdobi' , cobdobi     , LL_TEXT   , 0 )
    LlDefineVariableExt(hJob, 'LastObdobi.' +ctask +'.cobdRok' , cobdRok     , LL_TEXT   , 0 )
  next
RETURN

*
**
STATIC FUNCTION MyGetTempPath()
  LOCAL nBuffSize := 1024,sBuffer := Replicate(chr(0),1024)

  GetTempPathA(nBuffsize, @sBuffer)
return sBuffer


*
**
STATIC FUNCTION LLEpresERR()
  LOCAL nBuffSize := 512,sBuffer := Replicate(chr(0),512)

  LlExprError( hJob, @sBuffer, nBuffsize )
return sBuffer


STATIC FUNCTION FileExt()
  LOCAL extFile, typProj := FORMs ->nTYPPROJ_L

  DO CASE
  CASE typProj = LL_PROJECT_LABEL  ;  extFile := '.lbl'
  CASE typProj = LL_PROJECT_LIST   ;  extFile := '.lst'
  CASE typProj = LL_PROJECT_CARD   ;  extFile := '.crd'
  ENDCASE
RETURN(extFile)


static function ModifyDesign(inReadDesign, isdesc, aRelFor_LL)
  local fields, pa, pm := {}, x, pb, npos
  local file, field_name, field_desc, field_temp, field_org
  *
  local cwith_desc, conly_data
  local mFORMS_ll, pa_Rel := {}, isANSI

  * relaèní soubory mohou mít jiné ALIASy mají délku 6
  *                                                          5 soubor
  *                                                                6 alias
  aeval( aRELFor_LL, { |x| if( len(x) = 6, aadd( pa_Rel, { x[5], x[6] }), nil ) })

  * zabezpeèíme shodu položek v sekcích a formuláøi
  *
  ** od verze LL15 je vzor uložen v UTF8, ale naše sestavy byly dìlány verzí LL11 ANSI
  mFORMS_ll := verify_by_UsedIdentifiers( inReadDesign, isdesc )
  isANSI    := ( substr( mFORMS_ll,1,1) = '[' )


  do case
  case       inReadDesign
    * existuje již vytvoøený vzor_naèteme a doplníme popisy dat *
    *
    if isdesc
      pa := field_for_desing( mFORMS_ll, .T. )

      for x := 1 to len(pa) step 1
        file       := pa[x,2]
        field_name := pa[x,3]
        field_temp := pa[x,4]

        * jedná se o relaèní soubor a má jiný alias
        if( npos := ascan( pa_Rel, { |x| lower(x[2]) = lower(file) })) <> 0
          file := pa_Rel[npos,1]
        endif

        if IsObject(odbd := drgDBMS:dbd:getByKey(file))
          field_desc := if( IsObject(odrgrf := odbd:getFieldDesc(field_name)), odrgrf:desc, '')
          field_desc := if( isNull(field_desc),'', field_desc_mod(field_desc))
          mFORMS_ll  := StrTran(mFORMS_ll,pa[x,1], field_temp +if( empty(field_desc), '', '__') +if(isANSI, field_desc, cANSITOUTF8(field_desc)) )
        endif

        if pa[x,2] = 'FCE'
          npos       := ascan( pa_Function, { |x| lower(x[3]) = lower(field_name) } )
          field_desc := if( npos = 0, '',  field_desc_mod(pa_Function[npos,4]) )
          mFORMS_ll  := StrTran(mFORMS_ll,pa[x,1], field_temp +if( empty(field_desc), '', '__') +if(isANSI, field_desc, cANSITOUTF8(field_desc)) )
        endif

      next
    endif

  case .not. inReadDesign
    * pøed uložením do MEMa odstraníme popisy dat *
    pa := field_for_desing( mFORMS_ll, .f. )

    if isdesc
      for x := 1 to len(pa) step 1
        cwith_desc := pa[x,1]                                // položka s popisem
        conly_data := strTran(pa[x,2],'.','»miss«' )         // originál položky bez popisu

        mFORMS_ll  := strTran( mFORMS_ll,         cwith_desc          , conly_data )
        mFORMS_ll  := strTran( mFORMS_ll, strTran(cwith_desc,' ', '_'), conly_data )
      next

      mFORMS_ll    := strTran(mFORMS_ll, '»miss«', '.' )
    endif
  endcase

  * uložíme do souboru pro LL
  MemoWrit( sName +sNameExt, StrTran(mFORMS_ll, '»miss«', '.') )
return mFORMS_ll


*  musíme prohledat vzor, pokud je to v položkách napsáno jinak než je uloženo
*  v sekci Variables, Fileds - musíme napøed pøetransformovat aby tyto prvky
*  byly shodnì jak v položkách tak v sekcích
**
*  po této šílené modifikaci, musí být použité promìnné a promìnné v sekcích shodné
**
static function verify_by_UsedIdentifiers( inReadDesign )
  local  x, pa := {}, npos, ncnt
  local     pb := {}
  local     pc
  local     pe := {}
  *
  local  mFORMS_ll
  local  wFORMS_ll
  local  wsFORMS_ll  , wmFORMS_ll, cvarName, wvarName
  *
  local  cin_Sections, cin_Forms

  mFORMS_ll := if( inReadDesign, FORMs ->mFORMS_ll, MemoRead(sName +sNameExt) )
  wFORMS_ll := lower( mFORMS_ll )

  * je popiska ?
  for x := 1 to len(pa_inSections) step 1
    if at( '__', pa_inSections[x] ) <> 0
      pc  := listAsArray( pa_inSections[x], '__' )
      AAdd( pb, pc[1] )
    else
      AAdd( pb, pa_inSections[x] )
    endif
  next

  pb        := Aclone( pa_inSections )
  ASort( pb,,, {|ax,ay| len(ax) > len(ay) })

  for x := 1 to len( pb ) step 1
    * pøídáme originál ze sekcí
    AAdd( pa, pb[x] )

    wvarName   := lower( pb[x])
    wsFORMS_ll := wFORMS_ll
    wmFORMS_ll := mFORMS_ll

    do while ( npos := at( wvarName, wsFORMS_ll) ) <> 0
      cvarName   := subStr( wmFORMS_ll, npos, len(wvarName))
      wsFORMS_ll := subStr( wsFORMS_ll, npos +1 )
      wmFORMS_ll := subStr( wmFORMS_ll, npos +1 )

      * pokud je to napsané jinak musíme modifikovat
      if AScan( pa, {|o| o == cvarName} ) = 0
        AAdd( pe, { cvarName, pb[x] } )
      endif
    enddo

    mFORMS_ll := strTran( mFORMS_ll, pb[x], strTran( pb[x], '.', '»miss«', 1, 1 ) )
    wFORMS_ll := lower( mFORMS_ll )
  next

  * pøetransformujede dle originálu v sekcích
  ASort(pe,,, {|ax,ay| len(ax[1]) > len(ay[1]) })

  for x := 1 to len(pe) step 1
    cin_Forms    := pe[x,1]
    cin_Sections := strTran( pe[x,2], '.', '»miss«', 1, 1 )

    mFORMS_ll    := strTran( mFORMS_ll, cin_Forms, cin_Sections )
  next

  * vrátíme to do ...teèek..
  mFORMS_ll := strTran( mFORMS_ll, '»miss«', '.' )
return mFORMS_ll


*
** pro doplìní a dostranìné popisek
static function field_for_desing( mFORMS_ll, laddDesc )
  local  x, pa
  local     pb      , file     , field_name
  local     pc
  local     pm := {}
  *
  if laddDesc
    for x := 1 to len(pa_inSections) step 1
      pb         := ListAsArray(pa_inSections[x],'.')
      file       := pb[len(pb) -1]
      field_name := pb[len(pb)   ]

      AAdd(pm,{pa_inSections[x],file,field_name,StrTran(pa_inSections[x], '.', '»miss«', 1, 1 )})
    next

  else
    for x := 1 to len(pa_inSections) step 1
      * je popiska ?
      if at( '__', pa_inSections[x] ) <> 0
        pb         := listAsArray( pa_inSections[x], '__' )
        pc         := ListAsArray( pb[1], '.' )
        field_name := pc[len(pc)   ]

        AAdd( pm, { pa_inSections[x], pb[1], field_name, pa_inSections[x] } )
      endif
    next
  endif

  pa := ASort(pm,,, {|ax,ay| len(ax[3]) > len(ay[3]) })
return pa


static function field_desc_mod(field_desc)
  * tyto znaky LL nemá rád :./-*

  field_desc := StrTran(field_desc,':', '')
  field_desc := StrTran(field_desc,'.', '')
  field_desc := StrTran(field_desc,'/', '')
  field_desc := StrTran(field_desc,'-', '')
  field_desc := StrTran(field_desc,'(', '')
  field_desc := StrTran(field_desc,')', '')
  field_desc := StrTran(field_desc,'§', '')
  field_desc := StrTran(field_desc,'%', '')
  field_desc := StrTran(field_desc,'+', '')
  field_desc := StrTran(field_desc,',', '')
  field_desc := StrTran(field_desc,';', '')
  field_desc := StrTran(field_desc,';', '')
  field_desc := StrTran(field_desc,'  ', '')
  field_desc := StrTran(field_desc,'   ', '')
  *
  field_desc := StrTran(field_desc,' ', '_')
  *
return field_desc

*
**
CLASS LLIniFile
EXPORTED:
  VAR    file, indexName READONLY
  VAR    aRelFor_LL
  VAR    hJob, cMemDesign_LL, sName, snameExt, paopen_Files
  VAR    m_dialog
  VAR    lcan_continue
  METHOD init, destroy, ReadSections

HIDDEN:
  VAR    isVariable, inDesign, isdesc
  VAR    cTagFor_LL, cWorkCdx_LL
  VAR    cdirW
  METHOD SortOrder , Relations  , ResetKey , Functions


  inline method extClass(name)
    local  frmName := substr(name,3)
    local  oxbp    := setAppFocus(), dialog
    local  odialog, nexit

    dialog := if(oxbp:className() = 'xbpBrowse', oxbp:cargo:drgDialog, ;
                if( oxbp:className() = 'XbpImageButton', oxbp:cargo:drgDialog, ;
                  oxbp:parent) )

    if isMemberVar(dialog:parent, 'helpName')
      if dialog:parent:helpName <> frmName
        odialog       := drgDialog():new( frmName, dialog)
        odialog:create(,,.T.)

        if isObject(odialog:udcp)
          if isMemberVar(odialog:udcp, 'lcan_continue' )
            if( isLogical( odialog:udcp:lcan_continue), ::lcan_continue := odialog:udcp:lcan_continue, nil )
          endif
        endif

        odialog:destroy(.T.)
        odialog := NIL
      endif
    endif
  return .t.

ENDCLASS


METHOD LLIniFile:init(inDesign, isdesc, cMemDesign_LL)
  LOCAL  buffer := StrTran(MemoTran(FORMs ->mDATA_ll,chr(0)), ' ', ''), n, cname
  local  extBlock, userBlock
  local  cfilter
  *
  local  oxbp     := setAppFocus(), m_dialog, lcan_continue

  cresetKey       := xresetKey := ''

  ::inDesign      := inDesign
  ::isdesc        := isdesc
  ::cMemDesign_LL := cMemDesign_LL
  ::cTagFor_LL    := ''
  ::aRelFor_LL    := {}
  ::cdirW         := drgINI:dir_USERfitm +userWorkDir()
  ::m_dialog      := if(oxbp:className() = 'xbpBrowse', oxbp:cargo:drgDialog, ;
                       if( oxbp:className() = 'XbpImageButton', oxbp:cargo:drgDialog, ;
                         oxbp:parent) )
  ::lcan_continue := .t.

  myCreateDir( ::cdirW )

  ::ReadSections()

  while( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
    if Left(buffer,1) = '['
      cname := lower(substr(buffer,2,n -3))

      do case
      case cname         = 'definevariable'
        ::isVariable := .T.
      case cname         = 'definefield'
        ::isVariable := .F.
      case left(cname,5) = 'table'
        ::file := substr(cname,at(':',cname) +1)

        if .not. empty(forms->mblockfrm)
          do case
          case forms->ntypzpr = 10
            drgDBMS:open(::file,.T.,.T.,drgINI:dir_USERfitm)

            cfilter := (::file)->(ads_getAof())
            if( .not. empty(cfilter), (::file)->(Ads_clearAOF(), dbgotop()), nil )

            extBlock := alltrim(forms->mblockfrm)

            m_dialog   := ::m_dialog

            extBlock   := left( extBlock, len( extBlock) -1 )
            extBlock   += ',m_dialog )'
            extBlock   := '{ |m_dialog| ' +extBlock + '}'
            lcan_continue := Eval( &extBlock, m_dialog )
            if( isLogical(lcan_continue), ::lcan_continue := lcan_continue, nil )
            if( .not. empty(cfilter), (::file)->(Ads_setAOF(cfilter), dbgotop()), nil )
          otherwise
            if substr(upper(::file), len(::file), 1) = 'W' .or. substr(upper(::file), len(::file)-1, 2) = 'W2'
              if at('::',forms->mblockfrm) = 0 .and. forms->ntypzpr <> 3
                drgDBMS:open(::file,.T.,.T.,drgINI:dir_USERfitm); ZAP
              else
                drgDBMS:open(::file,.T.,.T.,drgINI:dir_USERfitm)
              endif
            else
              drgDBMS:open(::file)
            endif

            if at('::',forms->mblockfrm) <> 0
               ::extClass(alltrim(forms->mblockfrm))
            else
              *
              ** externì nastavený filtr
              cfilter := (::file)->(ads_getAof())
              if( .not. empty(cfilter), (::file)->(Ads_clearAOF(), dbgotop()), nil )

              extBlock := alltrim(forms->mblockfrm)

              if lower(::file) = 'vykazw' .and. ;
                 ( 'vyk_naplnvyk_in' $ lower(extBlock) .or. 'vyk_naplnvyk2_in' $ lower(extBlock) )

                m_dialog   := ::m_dialog
                *
                ** uživatelem definovaný požadavek pro zpracování
                if .not. empty(userBlock := alltrim(forms->mbloc_user))
                  extBlock := userBlock
                endif

                extBlock   := left( extBlock, len( extBlock) -1 )
                extBlock   += ',m_dialog )'
                extBlock   := '{ |m_dialog| ' +extBlock + '}'
                lcan_continue := Eval( &extBlock, m_dialog )
                if( isLogical(lcan_continue), ::lcan_continue := lcan_continue, nil )

              else
                Eval( &("{||" + +alltrim(forms->mblockfrm)+ "}"))
              endif

              if( .not. empty(cfilter), (::file)->(Ads_setAOF(cfilter), dbgotop()), nil )
            endif
          endcase
        else
          drgDBMS:open(::file)
        endif

        (::file)->(dbGoTop())
        DefineData(::isVariable,::file,,::inDesign,::isdesc)

      case IsMethod(self, cNAMe, CLASS_HIDDEN)
        self:&cname(substr(buffer, n +1))
      endcase
    endif
    buffer := substr(buffer, n +1)
  end
RETURN self


*
**
METHOD LLIniFile:SortOrder(buffer)
  LOCAL  pa, isCompound, x, indexKey := '', n
  *
  LOCAL  odesc, type, len, dec, indexDef, tagNo := 0, tagName := ''
  LOCAL  oldEXACT
  *
  Local  npos, cc, a_TagNames, cdirW, pucCondition


  if( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
    pa         := ListAsArray(substr(buffer,1,n -1))
    isCompound := (Len(pa) > 1)

    *
    for x := 1 to len(pa) step 1
      cc := pa[x]
      if isObject( odesc := drgDBMS:getFieldDesc(::file, pa[x]) )
        type  := odesc:type
        len   := odesc:len
        dec   := odesc:dec

        indexKey += if(type = 'C', "Upper(" +pa[x] +")", ;
                     if(type = 'D', "if( empty(" +pa[x] +"), '        ', dtos(" +pa[x] + "))" , ;
                      if(type = 'N' .and. isCompound, "StrZero(" +pa[x] +"," +Str(len) +")", pa[x])))

        indexKey += if(isCompound .and. x < len(pa), '+', '')
      endif
    next
    *
    ::indexName := ''
    if len( (::file)->(ordList())) <> 0
      ::indexName := (::file) ->(Ads_GetIndexFilename())
    endif
    *
    if substr(upper(::file), len(::file), 1) <> 'W'
      indexDef    := drgDBMS:dbd:getByKey(::file):indexDef

      oldEXACT    := Set(_SET_EXACT, .F.)
      tagNo       := AScan(indexDef, {|X| upper(strTran(X:cIndexKey, ' ', '')) = Upper(strTran( indexKey, ' ', ''))})
      Set(_SET_EXACT, oldEXACT)

      if( tagNo <> 0, tagName := indexDef[tagNo]:cName, nil )
    endif

    do case
    case( .not. empty(tagName)  )
      (::file) ->(OrdSetFocus( tagName ))
    case(tagNo =  0 .and. .not. empty(indexKey))

      a_TagNames := (::file)->(OrdList())
      if( npos := AScan( a_TagNames, {|s| 'LLTISK_' $ s} )) <> 0
                  cc := StrZero( Val( SubStr( a_TagNames[npos], 8, 3)), 3, 0 )
        ::cTagFor_LL := 'LLTISK_' +cc
      else
        ::cTagFor_LL := 'LLTISK_001'
      endif

      ::cWorkCdx_LL  := ::cdirW +'\Tisky'

*      ::cTagFor_LL  := right(userWorkDir(), 10)
*      ::cWorkCdx_LL := ::cdirW +'\' + right(userWorkDir(), 10)

      DbSelectArea(::file)

      * soubor je prázdný - buï je nastaven filtr, nebo oravdu nemá data
      * nebudeme budovat tag
      if (::file)->(eof())
        ::cWorkCdx_LL := ::cTagFor_LL := ''
      else

        if file(::cWorkCdx_LL +'.adi')
          do while FErase(::cWorkCdx_LL +'.adi') = -1
          enddo
        endif

        (::file) ->(Ads_CreateTmpIndex( ::cWorkCdx_LL, ::cTagFor_LL, indexKey ))
        (::file) ->(OrdSetFocus(::cTagFor_LL))
      endif
    endcase
  endif
RETURN self


* struktura relaèní položky
* 1  2  3                     4        5           6
* 6 :1 :OBJVYSIT->NDOKLAD    :OBJVYSIT :ObjVysHd
* 5 :1 :OBJVYSHD->nsSpoTeZpr :OBJVYSHD :Spojeni   :SpojeniA
* 1 TAG pro relaèní soubor --->  5
*    2 nepoužívá se
*       3 relaèní vazba
*                             4 základní soubor
*                                      5 relaèní soubor
*                                                  6 alias relaèního souboru
METHOD LLIniFile:Relations(buffer)
  LOCAL pa, n, crel_Alias

  while(asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0)
    *
    * za sekcí [Relations] mùže být další sekce
    if left(buffer,1) = '['
      return self

    else
      pa         := ListAsArray(lower(substr(buffer,1,n -1)),':')
      crel_Alias := if( len(pa) = 6, pa[6], pa[5] )
      *
      if substr(upper(pa[5]), len(pa[5]), 1) = 'W'
        drgDBMS:open(pa[5],.T.,.T.,drgINI:dir_USERfitm)
      else
        drgDBMS:open(pa[5],,,,, crel_Alias)
      endif

      if( Val(pa[1]) = 0, (crel_Alias)->( AdsSetOrder(     pa[1])) , ;
                          (crel_Alias)->( AdsSetOrder( Val(pa[1])))  )
      (pa[4])     ->( DbSetRelation( crel_Alias, COMPILE(pa[3]), pa[3]), dbSkip(0))

      aadd( ::aRelFor_LL, pa )
      DefineData(::isVariable, ::file, crel_Alias, ::inDesign, ::isdesc, pa[5] )
    endif
    buffer := substr(buffer, n +1)
  enddo
RETURN self

*                                                  6 alias relaèního souboru
METHOD LLIniFile:Functions(buffer)
  LOCAL pa, n, crel_Alias
  local ok := .t.
  *
  local  aSTRu := {}

  while(asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0) .and. ok
    if Left(buffer,1) <> '['
      pa         := ListAsArray(lower(substr(buffer,1,n -1)),':')
      *
      **   fSazTar( )[1]:N:fnhodtar:Hodinový_tarif
      DefineFce(.f., pa[1], upper(pa[3]), pa[2], pa[4], ::isdesc )
      AAdd( pa_Function, { pa[1], pa[2], pa[3], pa[4] } )
      *
      aadd( aSTRu, { pa[3], pa[2], 13, 2 } )
    else
      ok := .f.
    endif
    buffer := substr(buffer, n +1)
  enddo

  if len(aSTRu) <> 0
    if( select( 'FCE' ) <> 0, FCE->( dbcloseArea()), nil )

    DbCreate(::cdirW +'\fce', aSTRu, oSession_free)
    DbUseArea(.t., oSession_free, ::cdirW +'\fce',,.f.,.f.)
  endif
RETURN self


METHOD LLIniFile:ResetKey(buffer)
  cresetKey := buffer
  xresetKey := DBGETVAL(cresetKey)
return self


METHOD LLIniFile:ReadSections( writeToFile )
  local  pa, x, cvarName
  local  lenBuff := 40960, buffer := space(lenBuff)

  default writeToFile to .t.

  pa_inSections := {}

  if file( sName +sNameExt )

    * naèteme ze skece UsedIdentifiers Variables *
    buffer  := space(lenBuff)

    GetPrivateProfileStringA('UsedIdentifiers', 'Variables', '', @buffer, lenBuff, sName +sNameExt)
    fields := substr(buffer,1,len(trim(buffer))-1)

    if .not. empty(fields)
      pa     := ListAsArray(fields,';')
      AEval( pa, {|x| AAdd( pa_inSections, x )} )
    endif

    * naèteme ze skece UsedIdentifiers Fields *
    buffer  := space(lenBuff)

    GetPrivateProfileStringA('UsedIdentifiers', 'Fields', '', @buffer, lenBuff, sName +sNameExt)
    fields := substr(buffer,1,len(trim(buffer))-1)

    if .not. empty(fields)
      pa     := ListAsArray(fields,';')
      *
      * promìnná mùže být jak v sekci Variables, tak v sekci Fields
      * v seznamu ji potøebujeme jen jednou
      *
      for x := 1 to len( pa ) step 1
        cvarName := pa[x]

        if ( npos := AScan( pa_inSections, {|u| lower(u) = lower(cvarName) }) ) = 0
          AAdd( pa_inSections, cvarName )
        endi
      next
    endif

  endif
return self



METHOD LLIniFile:destroy()
  local  i_ext  := DbeInfo( COMPONENT_ORDER, ADSDBE_INDEX_EXT    )
  local  pa_rel := ::aRelFor_LL, x

  * vybudoval tøídìní ?
  if .not. Empty(::cTagFor_LL)

    if substr(upper(::file), len(::file), 1)   = 'W'  .or. ;
       substr(upper(::file), len(::file)-1, 2) = 'W2' .or. ;
       upper(::file) = 'KUSTREE'

      (::file) ->(OrdListClear())
      if( .not. empty(::indexName), (::file)->( OrdListAdd(::indexName), ordSetFocus(1)), nil )
    else
      (::file) ->( dbCloseArea())
      drgDBMS:open( ::file )

    endif

    do while FErase(::cWorkCdx_LL +'.' +i_ext) = -1
    enddo

**    FErase(::cWorkCdx_LL +'.' +i_ext)
  endif

  * vytvoøil relace ?
  for x := 1 to len( pa_rel) step 1
    (pa_rel[x,4])->( DbClearRelation())
  next

  * potøeboval funkce ?
  if select( 'FCE' ) <> 0
    FCE->( dbcloseArea())
    FErase( ::cdirW +'\FCE.adt' )
  endif

  * uklidíme si
  FErase(::cMemDesign_LL)

  ::file          := ;
  ::indexName     := ;
  ::isVariable    := ;
  ::inDesign      := ;
  ::isdesc        := ;
  ::cTagFor_LL    := ;
  ::aRelFor_LL    := ;
  ::cWorkCdx_LL   := ;
  ::hJob          := ;
  ::cMemDesign_LL := ;
  ::sName         := ;
  ::snameExt      := ;
  ::cdirW         := NIL
 RETURN