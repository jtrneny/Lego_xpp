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


#include "XbZ_Zip.ch"


#DEFINE  DBGETVAL(c)     Eval( &("{||" + c + "}"))

#pragma Library( "ASINet10.lib" )

/*
*
** vnitøní formát èísla úètu u KB  - .gpc
# xTranslate  .c_n1   => SubStr(cbank_uct_int,11,1)
# xTranslate  .c_n2   => SubStr(cbank_uct_int,12,1)
# xTranslate  .c_n3   => SubStr(cbank_uct_int,13,1)
# xTranslate  .c_n4   => SubStr(cbank_uct_int,14,1)
# xTranslate  .c_n5   => SubStr(cbank_uct_int,15,1)
# xTranslate  .c_n6   => SubStr(cbank_uct_int,16,1)
# xTranslate  .c_n7   => SubStr(cbank_uct_int, 5,1)
# xTranslate  .c_n8   => SubStr(cbank_uct_int, 6,1)
# xTranslate  .c_n9   => SubStr(cbank_uct_int, 7,1)
# xTranslate  .c_n10  => SubStr(cbank_uct_int, 8,1)
# xTranslate  .c_n11  => SubStr(cbank_uct_int, 9,1)
# xTranslate  .c_n12  => SubStr(cbank_uct_int, 4,1)
# xTranslate  .c_n13  => SubStr(cbank_uct_int,10,1)
# xTranslate  .c_n14  => SubStr(cbank_uct_int, 2,1)
# xTranslate  .c_n15  => SubStr(cbank_uct_int, 3,1)
# xTranslate  .c_n16  => SubStr(cbank_uct_int, 1,1)
*/


STATIC  sName, sNameExt


**  Výbìr z typù komunikací v nabídce v programu
** CLASS for SYS_komunikace_SEL *********************************************
CLASS SYS_komunikace_ FROM drgUsrClass

EXPORTED:
  METHOD  init, drgDialogStart
  *

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected(.F.)
      Return .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
        RETURN .F.
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR  key, typcom

ENDCLASS


METHOD SYS_komunikace_:init(parent)

  ::drgUsrClass:init(parent)
  ::key    := ''
  ::typcom := .T.

  drgDBMS:open('DATKOMHD')
  drgDBMS:open('KOMUSERS',,,,,'KOMUSERSc')

RETURN self



METHOD SYS_komunikace_:drgDialogStart()
  if( .not. DATKOMHD->(dbSeek(Upper(KOMUSERS->cIddatkom),, AdsCtag(1) )), DATKOMHD->(DbGoTop()), nil)
RETURN SELF


function newIDdatkom(typ)
  local newID, filtr

  drgDBMS:open('datkomhd',,,,,'datkomhda')
  datkomhdA->(dbclearFilter(), dbgoTop())

  filtr := Format("cIDdatkom = '%%'", {typ})
  datkomhdA->( AdsSetOrder(1), dbSetFilter(COMPILE(filtr)), dbgoBottom())

  datkomhdW->cID := typ
  datkomhdW->nID := val(subStr(datkomhdA->cIDdatkom,5,6))+1
  datkomhdW->cIDdatkom := datkomhdW->cid +strZero(datkomhdW->nID,6)
return .t.


function ASYs_komunik_int(cidDATkom, drgDialog, is_Eet)
  local  ok_datKom, ok_datUser
  *
  local  pa_mDatkom_us, x, pa, pa_items := {}, pa_data := {}, oClass, odata
  local  mdefin_Kom

  default is_Eet to .f.

  if( select('datkomHd') = 0, drgDBMS:open( 'datKomhd'), nil )
  if( select('komUsers') = 0, drgDBMS:open( 'komUsers'), nil )

  ok_datKom := datKomHd->( dbseek( upper(cidDatKom),,'DATKOMH01'))

  if is_Eet
    ok_datUser := .t.
    mdefin_kom := pokladms->mdefin_Kom
  else
    ok_datUser := komUsers->( dbseek( datKomHd->cidDatKom,,'KOMUSERS04'))
    mdefin_Kom := komUsers->mDatkom_us
  endif


  if ok_datKom .and. ok_datUser
    *
    ** ::odata se použijí pøi volání ASYS_Komunik
    pa_mDatkom_us := listAsArray( memoTran( mdefin_Kom,,''),';')
    for x := 1 to len(pa_mDatkom_us) step 1
      pa := listAsArray( pa_mDatkom_us[x], '=' )

      if len(pa) = 2
        aadd( pa_items, pa[1] )
        aadd( pa_data , pa[2] )
      endif
    next

    oClass  := RecordSet():createClass( "selectkom_crd_" +cidDATkom, pa_items )
    odata := oClass:new( { ARRAY(LEN(pa_items)) } )

    for x := 1 to len(pa_data) step 1
      odata:putVar( x, pa_data[x] )
    next

    drgDialog:odata_datKom := odata

    ASys_Komunik( 'a', drgDialog)
  endif
return .t.


*
** obecná funkce pro komunikaci oxbp = drgDialog
FUNCTION ASys_Komunik(typ, oXbp)
  local file, nHandle
  local cx, ctm, n, m
  local aFILE  := {}
  local ausrDB := {}
  local oini
  local ny, cp, cj
  local cPATHelco, ncom
  local n_zaklDan, n_procDan, n_sazDan, nkoe
  local new, filtr
  local ozip
  local afile_e, afile_i
  local inp,out
  local dtime, dbold, idfile
  local dbOdes, dbPrij
  local ok
  *
  local  cbank_uct_int, cbank_uct
  local  cpath_kom, cfile_kom, istuz
  local  ctmp_dic
  local  countrec
  *
  ** pro nìkteré datové komunikace se pracuje s výbìrem oznaèení na základním oDBro na parentovi
  local  npos, pa, o_mainDBro, cmainFile
  *
  ** naète definièní soubor
  local cdirW
  local lenBuff := 40960, buffer := space(lenBuff)

  PUBLIC  odata_datKom

  cmainFile    := lower( allTrim( datKomHd->cmainFile))
  odata_datKom := ''

  oini := COMIniFile():new()

  cdirW      := drgINI:dir_USERfitm +userWorkDir()
  sName      := cdirW +'\' +datkomhd->cid
  sNameExt   := '.csv'  //    isNull( FileExt(), '.csv' )

  if isObject(oxbp) .and. oxbp:className() = "drgDialog"
    odata_datKom := oxbp:odata_datKom
  endif

  if cmainfile <> 'c_bankuc'
    if .not. Empty(komusers->mDefin_kom)
      MemoWrit(sName +sNameExt, komusers->mDefin_kom)
    else
      if( .not. Empty(datkomhd->mDefin_kom), MemoWrit(sName +sNameExt, datkomhd->mDefin_kom), nil)
    endif
  endif

*  if( .not. Empty(datkomhd->mDefin_kom), MemoWrit(sName +sNameExt, datkomhd->mDefin_kom), nil)
  buffer := space(lenBuff)

* naèteme ze sekece UsedIdentifiers Fields, pro vlastní TISK pøedáme jen tyto položky *
**    GetPrivateProfileStringA('Ftp', 'Server', '',   @buffer, lenBuff,  sName +sNameExt)
**    cftpserver := substr(buffer,1,len(trim(buffer))-1)


  do case
  case datkomhd->cIdDatKom = 'DIST000001'
    DIST000001( oXbp )

  case datkomhd->cIdDatKom = 'DIST000002'
    DIST000002( oXbp )

  case datkomhd->cIdDatKom = 'DIST000003'

//    GetPrivateProfileStringA('Export', 'Smlouva', '',   @buffer, lenBuff,  sName +sNameExt)
//    cX := substr(buffer,1,len(trim(buffer))-1)

//    file := selFILE('POHLEDAVKY','Ckm',,'Výbìr souboru pro export',{{"CKM soubory", "*.CKM"}})

    file := retDir(odata_datKom:PathExport) + odata_datKom:FileExport

    if .not. Empty(file)
      nHandle := FCreate( file )

      n  := 0
      ny := 0
      cx := 'HO' +Space(9) +SubStr( DtoS(Date()), 3) +Padr( odata_datKom:Smlouva,20) +Space(186)
      cx += CRLF
      FWrite( nHandle, cx)

      do while .not. fakvyshd ->( Eof())

        ctm := ''
        for j := 1 to Len(fakvyshd->cvarsym)
          if Val(Substr(fakvyshd->cvarsym,j,1)) > 0 .or. Substr(fakvyshd->cvarsym,j,1) = '0'
            ctm += Substr(fakvyshd->cvarsym,j,1)
          endif
        next
        ctm := StrZero( Val( ctm),10)

        cx := '42' + StrZero( n, 5) +AllTrim(fakvyshd->czkratstat) +Padr( Substr(fakvyshd->cdic,2,10),20) +SubStr(fakvyshd->cnazev,1,50) ;
               + ctm +Str(fakvyshd->ndoklad, 20)    ;
                + SubStr( DtoS(fakvyshd->dsplatfak), 3) + SubStr( DtoS(fakvyshd->dvystfak), 3);
                 + StrTran(StrZero(fakvyshd->ncenzakcel,16, 2),'.','') ;
                  + fakvyshd->czkratmeny +Padr("smlouva – dle faktury",70) +Space(14)
        cx += CRLF
        FWrite( nHandle, cx)
        ny += fakvyshd ->ncenzakcel
        fakvyshd ->( dbSkip())
        n++
      enddo

      cx := 'TO' +Space(9) +SubStr( DtoS(Date()), 3)                   ;
              +StrZero(n,6) +StrTran(StrZero(ny,19,2),'.','')              ;
               +Space(182)
      cx += CRLF
      FWrite( nHandle, cx)

//      FWrite( nHandle, Chr( 26), 1)
      FClose( nHandle)
      drgMsgBox(drgNLS:msg('soubor pro banku byl vytvoøen'), XBPMB_INFORMATION)
    endif


  case datkomhd->cIdDatKom = 'DIST000004'

    cPATHelco := AllTrim(SysConfig("Prodej:cPathRegPo"))
    nCOM      := SysConfig("Prodej:nComRegPo")

    if Right( cPATHelco,1)=="\"
      cPATHelco := SubStr( cPATHelco, 1, Len( cPATHelco)-1)
    endif

    drgDBMS:open('cenzboz')

    file := cPATHelco +"\TPLU.PRS"
    cTm  := AllTrim( SysConfig("Prodej:cCisSklRP"))

    if .not. Empty(file)
      nHandle := FCreate( file )

      do while .not.cenzboz ->( Eof())
        if Val(CenZboz ->cCisSklad) = Val(cTm)
          cKeyDPH := if( CenZboz ->nKlicDPH == 2 .or. CenZboz ->nKlicDPH == 4 ;
                         .or. CenZboz ->nKlicDPH == 7, "2", Str( CenZboz ->nKlicDPH, 1))

          cx := AllTrim( CenZboz ->cSklPol) + ";"+ StrTran( SubStr( CenZboz ->cNazZbo, 1, 14), ";", ",") ;
                 +";"+ AllTrim( Str( CenZboz ->nCenaMZbo *100, 0))                      ;
                   +";"+ "001111"+ Str( CenZboz ->nZboziKat, 1) + "38" ;
                    +cKeyDPH +"00" +";"     ;
                     + "00000000000000" +";" +AllTrim( Str( CenZboz ->nMnozDZbo, 10, 3))
          cx += CRLF
          FWrite( nHandle, cx)
        endif
        CenZboz ->( dbSkip())
      enddo
      CenZboz ->( dbCloseArea())

      FWrite( nHandle, Chr( 26), 1)
      FClose( nHandle)

      cPATHold := CurDrive() + ':\'+CurDir( CurDrive())
      cexe     := cPATHelco +"\TxtAlpha.exe"
      cline    := " 3 " +AllTrim( Str( nCOM, 1))

      CurDir( cPATHelco)
//      RunShell( cline, cexe, .T. )
      CurDir( cPATHold)
    endif

  case datkomhd->cIdDatKom = 'DIST000005'
    drgDBMS:open('c_typuhr')
    drgDBMS:open('c_bankuc')
    drgDBMS:open('c_dph')
    drgDBMS:open('cenzboz')

    cPATHelco := AllTrim(SysConfig("Prodej:cPathRegPo"))
    nCOM      := SysConfig("Prodej:nComRegPo")

    if Right( cPATHelco,1)=="\"
      cPATHelco := SubStr( cPATHelco, 1, Len( cPATHelco)-1)
    endif

//    cPATHold := CurDrive() + ':\'+CurDir( CurDrive())
    cFileARC := StrZero( Month( Date()), 2)                       ;
                 +StrZero( Day( Date()), 2)                       ;
                  +SubStr( Time(), 1, 2) + SubStr( Time(), 4, 2)  ;
                   +"." +Right(Str(Year(Date())),2)
    n    := 1
    nkoe := 1

    if File( cPATHelco +"\TxtAlpha.Exe")

      myCreateDir( cPATHelco +'\Archiv')
//      cexe     := cPATHelco +"\TxtAlpha.exe"
//      cline    := " 159 " +AllTrim( Str( nCOM, 1))
//      cline    \s:= Chr(39) + "159 " +AllTrim( Str( nCOM, 1)) + Chr(39)

      CurDir( cPATHelco)
//      RunShell( cline, cexe, .F. )

      if File( cPATHelco +"\TPLUSAL.SAL")
        COPY FILE (cPATHelco +'\TPLUSAL.SAL') TO (cPATHelco +'\Archiv\' +cFileARC)
        CurDir( drgINI:dir_USERfitm)
        drgDBMS:open('tmpcomelw',.T.,.T.,drgINI:dir_USERfitm); ZAP
//        DbeLoad( "SDFDBE" )
        APPEND FROM ( cPATHelco +"\TPLUSAL.SAL") VIA SDFDBE

//        tmpcomelw->( DbImport( cPATHelco +"\TPLUSAL.SAL",;
//        tmpcomelw->( DbImport( "c:\comelcom\TPLUSAL.SAL",;
//                    {'C_1','O_1','C_2','O_2','C_3','O_3','C_4','O_4','C_5','O_5','C_6','O_6','C_7','O_7','C_8','O_8' }  ;
//                               ,,,,,,"SDFDBE",{ {SDFDBE_DECIMAL_TOKEN, ","} }))

        pro_poklhd_cpy(,.t.)

        tmpcomelw ->( dbGoTop())
        do while .not.tmpcomelw ->( Eof())
          mh_copyfld('poklhdw','poklitw' ,.t.,.f.)

          poklitw->nintcount  := n
          poklitw->cCisSklad  := AllTrim( SysConfig( "Prodej:cCisSklRP"))
          poklitw->cSklPol    := AllTrim( tmpcomelw ->C_1)
          poklitw->ncejprkdz  := Val( AllTrim( tmpcomelw ->C_3))
          poklitw->ncecprkdz  := Val( AllTrim( tmpcomelw ->C_6))
          poklitw->nfaktmnoz  := Val( AllTrim( tmpcomelw ->C_7))

          poklitw->czkrtypfak := 'FAKVB'
          poklitw->cnazpol1   := '160'
          poklitw->cnazpol2   := '601'

          if cenzboz->( dbSeek( Upper(poklitw ->cCisSklad)+Upper(poklitw ->cSklPol),,'CENIK12' )  )
            poklitw->cNazZbo    := cenzboz->cnazzbo
            poklitw->cpolcen    := cenzboz->cpolcen
            poklitw->ncenaszbo  := cenzboz->ncenaszbo
            poklitw->czkratjedn := cenzboz->czkratjedn
            poklitw->ctypsklpol := cenzboz->ctypsklpol
            poklitw->cucetskup  := cenzboz->cucetskup
            poklitw->nucetskup  := cenzboz->nucetskup

//            poklitw->nklicdph   := cenzboz->nklicdph
            poklitw->nradvykdph := 1
            poklitw ->nprocdph  := 20

            C_DPH ->(mh_SEEK(poklitw ->nPROCDPH,2))
            poklitw->nklicdph  := C_DPH ->nKLICDPH
            poklitw->nnapocet  := C_DPH ->nNAPOCET
            poklitw->cfile_iv  := 'cenzboz'
//            poklitw->nrecs_iv

          endif

          n_zaklDan := poklitw->ncecprkdz    //(ncejprkdz:value * nfaktmnoz:value)
          n_procDan := 20

          n_sazDan := round(round(n_zaklDan * round((n_procDan/(100 +n_procDan)),4),2), 2)

          poklitw->njeddan   := (n_sazDan  / poklitw->nfaktmnoz)
//          poklitw->ncejprkdz := (n_zaklDan / poklitw->nfaktmnoz)
          poklitw->ncejprkbz := (n_zaklDan / poklitw->nfaktmnoz -n_sazDan / poklitw->nfaktmnoz)

          poklitw->ncecprzbz := poklitw->ncejprkbz * poklitw->nfaktmnoz
          poklitw->ncelkslev := poklitw->nhodnslev * poklitw->nfaktmnoz
          poklitw->ncecprkbz := poklitw->ncejprkbz * poklitw->nfaktmnoz
//          poklitw->ncecprkdz := poklitw->ncejprkdz * poklitw->nfaktmnoz
      *
          poklitw->ncenZakCel := poklitw->ncecprzbz * nkoe
          poklitw->nsazDan    := poklitw->ncecprkdz - poklitw->ncecprzbz
          poklitw->ncenZakCed := poklitw->ncecprkdz * nkoe

//           poklitw->ncislodl
//           poklitw->ccislobint
//           poklitw->cciszakazi
//           poklitw->nciszalfak
          *
//           poklitw->ncejprzbz  :=
//           poklitw->nhodnslev  := 0
//           poklitw->nprocslev  := 0
//           poklitw->ncejprkbz  :=
          *
//           poklitw->ncecprzbz  :=
//           poklitw->ncelkslev  :=
//           poklitw->ncecprkbz  :=
          *
//           poklitw->nvypsazdan :=
//           poklitw->njeddan    :=
          *
//           poklitw->cnazpol1
//           poklitw->cnazpol2
//           poklitw->cnazpol3
//           poklitw->cnazpol4
//           poklitw->cnazpol5
//           poklitw->cnazpol6

           poklitw->ncenzahcel := poklitw->ncecprkbz

//          poklitw ->cSkladPol  := tmpcomelw ->C_1 //Token( cLINE, ";", 1)
//          poklitw ->nCenaMZBO
//          poklitw ->nCenaMCZBO

          // pøepoètem hlavièku //
****          FIN_ap_modihd('POKLHDW',.t.)
          n++

          tmpcomelw->( dbSkip())
        enddo

        tmpcomelw ->( dbCloseArea())

        FIN_ap_modihd('POKLHDW',.t.)
        pro_poklhd_wrt(,.t.)

        FErase( cPATHelco +"\TPLUSAL.SAL")
        FErase( cPATHelco +"\TPLUSAL.SDF")

      endif

//      cexe     := cPATHelco +"\TxtAlpha.exe"
//      cline    := " 12 " +AllTrim( Str( nCOM, 1))
//      cline    := Chr(39) +" 12 " +AllTrim( Str( nCOM, 1)) +Chr(39)

//      CurDir( cPATHelco)
//      RunShell( cline, cexe, .T. )

      CurDir( drgINI:dir_USERfitm)
    endif

  * export firem
  case datkomhd->cIdDatKom = 'DIST000006'
    DIST000006( oXbp )

  case datkomhd->cIdDatKom = 'DIST000007'
    DIST000007( oXbp )

  * export objednávek pøijatých
  case datkomhd->cIdDatKom = 'DIST000008'
    DIST000008( oXbp )

  * import objednávek pøijatých
  case datkomhd->cIdDatKom = 'DIST000009'
    DIST000009( oXbp )

  * export prodejních ceníkù
  case datkomhd->cIdDatKom = 'DIST000010'
    DIST000010( oXbp )

  * import prodejních ceníkù
  case datkomhd->cIdDatKom = 'DIST000011'
    DIST000011( oXbp )

  * export prodejních ceníkù pro konkrétní firmy
  case datkomhd->cIdDatKom = 'DIST000012'
    DIST000012( oXbp )

  * import prodejních ceníkù pro konkrétní firmy
  case datkomhd->cIdDatKom = 'DIST000013'
    DIST000013( oXbp )

  * obousmìrná aktualizace pøipomínek A++
  case datkomhd->cIdDatKom = 'DIST000014'
    DIST000014( oXbp )

  * import øipomínky A++
  case datkomhd->cIdDatKom = 'DIST000015'
    afile_i := { {'asysprhd_i','asysprhdw'}, {'asysprit_i','asyspritw'}}
    unzipCom( 'DIST000014_'+ SubStr(AllTrim(Str(usrIdDB)),1,4)+'??')

    recNo   := asysprhd->(recNo())

    drgDBMS:open( 'asysprhd',,,,, 'asysprhd_i' )
    drgDBMS:open( 'asysprit',,,,, 'asysprit_i' )

    drgDBMS:open('asysprhdw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
    drgDBMS:open('asyspritw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)

    do while .not. asysprhdw ->(Eof())
      filtr := format( "nUsrIdDB = %% and cIDpripom = '%%'", { asysprhdw->nUsrIdDB, asysprhdw->cIDpripom})
      asyspritw->(ads_setAof(filtr),dbgoTop())

      if asysprhd_i->( dbSeek( StrZero(asysprhdw->nUsrIdDB,6)+UPPER(asysprhdw->cIDpripom),,'ASYSPRHD05'))
/*
        if drgIsYESNO(drgNLS:msg('Pøepsat existující objednávku èíslo ' + AllTrim( Str(objheadw->ndoklad))+ '  ?'))
          if objhead_i->( dbRlock())
             mh_COPYFLD('objheadw','objhead_i', .f., .t.)
             do while .not. objitemw ->(Eof())
               if objhead_i->( dbSeek( strZero(objheadw->nDoklad,10) +strZero(objheadw->nCislPolOb,5),,'OBJHEAD25'))
                 mh_COPYFLD('objitemw','objitem_i', .f., .t.)
               else
                 mh_COPYFLD('objitemw','objitem_i', .t., .t.)
               endif
             enddo
          endif
        endif
*/
      else
        mh_COPYFLD('asysprhdw','asysprhd_i', .t., .t.)
        dbeval( { || mh_copyFld( asyspritw, 'asysprit_i', .t. ) } )
      endif
      asysprhd_i->( dbUnLock())
      asysprhdw->( dbSkip())
    enddo

   clsFileCom( afile_i)
   delFileCom( afile_i)
   drgMsgBox(drgNLS:msg('import byl dokonèen'), XBPMB_INFORMATION)


  case datkomhd->cIdDatKom = 'DIST000016'
    ApodporaALL( 1)

  case datkomhd->cIdDatKom = 'DIST000017'
    ApodporaALL( 2)

  * export definice výkazù
  case datkomhd->cIdDatKom = 'DIST000018'
    afile_e := { {'defvykhd_e','defvykhdw'}, {'defvykit_e','defvykitw'}}
//    recNo   := objhead->(recNo())

    drgDBMS:open( 'defvykhd',,,,, 'defvykhd_e' )
    drgDBMS:open( 'defvykit',,,,, 'defvykit_e' )
    drgDBMS:open( 'defvykhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open( 'defvykitw',.T.,.T.,drgINI:dir_USERfitm); ZAP

    do while .not. defvykhd ->(Eof())
      mh_COPYFLD('defvykhd','defvykhdw', .t., .t.)
      cx := defvykhd->cidvykazu

      filtr     := format( "cidvykazu = '%%'", { defvykhd->cidvykazu})
      defvykit_e->( ads_setAof(filtr),dbgoTop())

      do while .not. defvykit_e->(Eof())
        mh_COPYFLD('defvykit_e','defvykitw',.t., .t.)
        defvykit_e->( dbSkip())
      enddo

      defvykit_e->(ads_clearAof())
      defvykhd ->( dbSkip())
    enddo

//    defvykhd ->(dbgoTo( recNo ))

    clsFileCom( afile_e)

    * picnem to ven
    zipCom( afile_e, 'DIST000018_'+AllTrim(Str(usrIdDB))+'_'+cx )
    delFileCom( afile_e)
    drgMsgBox(drgNLS:msg('export byl dokonèen'), XBPMB_INFORMATION)


  * import definice výkazù
  case datkomhd->cIdDatKom = 'DIST000019'
    afile_i := { {'defvykhd_i','defvykhdw'}, {'defvykit_i','defvykitw'}}
    unzipCom( 'DIST000018_'+ '*')

    recNo   := defvykhd->(recNo())
    afile_i := { 'defvykhd_i', 'defvykit_i'}

    drgDBMS:open( 'defvykhd',,,,, 'defvykhd_i' )
    drgDBMS:open( 'defvykit',,,,, 'defvykit_i' )

    drgDBMS:open('defvykhdw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
    drgDBMS:open('defvykitw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)

    defvykhdw->(dbgoTop())
    do while .not. defvykhdw ->(Eof())
      filtr := format( "cidvykazu = '%%'", { defvykhdw->cidvykazu})
      defvykitw->(ads_setAof(filtr),dbgoTop())

      if defvykhd_i->( dbSeek( defvykhdw->cidvykazu,,'DEFVYKHD03'))
        if drgIsYESNO(drgNLS:msg('Pøepsat existující definici výkazu ' + AllTrim( defvykhdw->cidvykazu)+ '  ?'))
          if defvykhd_i->( dbRlock())
             mh_COPYFLD('defvykhdw','defvykhd_i', .f., .t.)
             do while .not. defvykitw ->(Eof())
               if defvykit_i->( dbSeek( Upper(defvykitw->cidvykazu)+StrZero(defvykitw->nRadekVyk,4)+StrZero(defvykitw->nSloupVyk,2),,'DEFVYKIT08'))
                 if defvykit_i->( dbRlock())
                   mh_COPYFLD('defvykitw','defvykit_i', .f., .t.)
                   defvykit_i->( dbUnLock())
                 endif
               else
                 mh_COPYFLD('defvykitw','defvykit_i', .t., .t.)
               endif
               defvykitw ->(dbSkip())
             enddo
          endif
        endif
      else
        mh_COPYFLD('defvykhdw','defvykhd_i', .t., .t.)
        defvykhd_i->( dbCommit())

        countrec := defvykitw->( mh_COUNTREC())
        drgServiceThread:progressStart( drgNLS:msg('Importuji položky definice '+ defvykitw->cidvykazu +' ...'), countrec )
        defvykitw->(dbgoTop())
        nX := 0
        do while .not. defvykitw ->(Eof())
          mh_copyFld( 'defvykitw', 'defvykit_i', .t., .t. )

          if nX > 20
            defvykit_i->( dbCommit())
            nX := 0
          endif
          defvykitw ->(dbSkip())
          nX++
          drgServiceThread:progressInc()
        enddo
//        defvykitw->(dbeval( { || mh_copyFld( 'defvykitw', 'defvykit_i', .t., .t. ) } ))
        defvykit_i->( dbCommit())
        drgServiceThread:progressEnd()
      endif
      defvykhd_i->( dbUnLock())
      defvykhdw->( dbSkip())
    enddo

    defvykhd_i->(dbCloseArea())
     defvykit_i->(dbCloseArea())
    defvykhdw->(dbCloseArea())
     defvykitw->(dbCloseArea())

    drgMsgBox(drgNLS:msg('import byl dokonèen'), XBPMB_INFORMATION)
      //
//    clsFileCom( afile_i[1,2])
//    delFileCom( afile_i[1,2])

  case datkomhd->cIdDatKom = 'DIST000020'
    ApodporaALL( 1)
    ApodporaALL( 2)


// Import bankovních výpisù - KB - formát KM - pøípona GPC
  case datkomhd->cIdDatKom = 'DIST000021'
    DIST000021( oXbp )
// Import bankovních výpisù - ÈS - formát KM - pøípona GPC
  case datkomhd->cIdDatKom = 'DIST000025'
    DIST000021( oXbp )
// Import bankovních výpisù - ÈSOB - formát KM - pøípona GPC
  case datkomhd->cIdDatKom = 'DIST000028'
    DIST000028( oXbp )
// Import bankovních výpisù - GM - formát KM - pøípona GPC
  case datkomhd->cIdDatKom = 'DIST000035'
    DIST000021( oXbp )

  case datkomhd->cIdDatKom = 'DIST000037'
    ctm  := StrZero(dph_2011->nm,2) + StrZero(dph_2011->nrok,4)
    file := selFILE('DPHSHV_'+ctm,'Xml',,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

    if .not. Empty(file)
      nHandle := FCreate( file )
//      FAttr( file, "H" )
//      nHandle := FOpen( file, FO_READWRITE )

      ny := At( " ", dph_2011->csesjmeno)
      cp := AllTrim( SubStr( dph_2011->csesjmeno, 1, ny-1))
      cj := AllTrim( SubStr( dph_2011->csesjmeno, ny+1))

      cx := '<?xml version=' + fVAR("1.0")+ ' encoding=' +fVAR("windows-1250")+' standalone='+ fVAR("no")+'?>' + CRLF
//      cx := '<?xml version=' + fVAR("1.0")+ ' encoding=' +fVAR("UTF-8")+' standalone='+ fVAR("no")+'?>' + CRLF
      FWrite( nHandle, cx)

      cx := '<Pisemnost nazevSW='+fVAR("A++")+' verzeSW='+fVAR("1.04.2")+'>' + CRLF
      FWrite( nHandle, cx)
      cx := '  <DPHSHV verzePis='+fVAR("01.01")+'>' + CRLF
      FWrite( nHandle, cx)

      cx := '       <VetaD'
//      cx += ' ctvrt='
//       cx += fVAR(AllTrim(Str(dph_2009->nQ,1,0)))
      cx += ' d_poddp='
       cx += fVAR(dtoc(Date()))
      cx += ' dokument='
       cx += fVAR("SHV")
      cx += ' k_uladis='
       cx += fVAR("DPH")
      cx += ' mesic='
       cx += fVAR(AllTrim(Str(dph_2011->nM,2,0)))
      cx += ' pln_poc_celk='
       cx += fVAR("0")
      cx += ' poc_radku='
       cx += fVAR("0")
      cx += ' poc_stran='
       cx += fVAR("0")
      cx += ' rok='
       cx += fVAR(AllTrim(Str(dph_2011->nrok,4,0)))
      cx += ' shvies_forma='
       cx += fVAR("R")
      cx += ' suma_pln='
       cx += fVAR("0")
      cx += '/>'
       cx += CRLF
      FWrite( nHandle, cx)

      cx := '       <VetaP c_orient='
       cx += fVAR(AllTrim(dph_2011->ccp))
//      cx += ' c_pop='
//       cx += fVAR()
      cx += ' c_ufo='
       cx += fVAR( AllTrim(Str( SysConfig('System:nFINURKRAJ'),3,0)))
      cx += ' c_pracufo='
       cx += fVAR( AllTrim(Str( SysConfig('System:nFINURAD'),4,0)))
      cx += ' dic='
       cx += fVAR( SubStr(AllTrim(dph_2011->cdic),3))
//      cx += ' dodobchjm='
//       cx += fVAR()
//      cx += ' jmeno='
//       cx += fVAR()
      cx += ' naz_obce='
       cx += fVAR(AllTrim(dph_2011->cSidlo))
      cx += ' opr_jmeno='
       cx += fVAR(AllTrim(dph_2011->codposjmen))
      cx += ' opr_postaveni='
       cx += fVAR(AllTrim(dph_2011->codpospost))
      cx += ' opr_prijmeni='
       cx += fVAR(AllTrim(dph_2011->codposprij))
//      cx += ' prijmeni='
//       cx += fVAR()
      cx += ' psc='
       cx += fVAR(AllTrim(dph_2011->cpsc))
      cx += ' sest_jmeno='
       cx += fVAR(cj)
      cx += ' sest_prijmeni='
       cx += fVAR(cp)
      cx += ' sest_telef='
       cx += fVAR(AllTrim(StrTran(dph_2011->csestelef,' ','')))
//      cx += ' titul='
//       cx += fVAR()
      cx += ' typ_ds='
       cx += fVAR(AllTrim(SysConfig('System:cTYPDANSUB')))
      cx += ' ulice='
       cx += fVAR(AllTrim(dph_2011->cUlice))
//      cx += ' zast_dat_nar='
//       cx += fVAR()
//      cx += ' zast_ev_cislo='
//       cx += fVAR()
//      cx += ' zast_ic='
//       cx += fVAR()
//      cx += ' zast_jmeno='
//       cx += fVAR()
//      cx += ' zast_kod='
//       cx += fVAR()
//      cx += ' zast_nazev='
//       cx += fVAR()
//      cx += ' zast_prijmeni='
//       cx += fVAR()
//      cx += ' zast_typ='
//       cx += fVAR()
      cx += ' zkrobchjm='
       cx += fVAR(AllTrim(dph_2011->cpraosnaz))
      cx += '/>'
       cx += CRLF
      FWrite( nHandle, cx)

      do while .not. vykdph_sw->( Eof())
        cx := '       <VetaR c_vat='
         cx += fVAR(Left(AllTrim(vykdph_sw->cvat_vies),12))
        cx += ' c_rad='
         cx += fVAR(AllTrim(Str(vykdph_sw->ncisradku,2)))
        cx += ' k_pln_eu='
         cx += fVAR(AllTrim(Str(vykdph_sw->nKodPl_FIN)))
        cx += ' k_stat='
         cx += fVAR(AllTrim(vykdph_sw->cZkratSta2))
//        cx := ' k_storno='
//        cx += fVAR(Left(AllTrim(vykdph_sw->cdic),12))
        cx += ' pln_hodnota='
         cx += fVAR(AllTrim(Str(vykdph_sw->nCenZakCel,14,0)))
        cx += ' pln_pocet='
         cx += fVAR(AllTrim(Str(vykdph_sw->nCount,6,0)))
//        cx += ' por_c_stran='
//        cx += fVAR(AllTrim(Str(vykdph_sw->nCount,6,0)))
        cx += '/>'
        cx += CRLF
        FWrite( nHandle, cx)

        vykdph_sw->( dbSkip())
      enddo

      cx := '  </DPHSHV>' + CRLF
      FWrite( nHandle, cx)
      cx := '</Pisemnost>'
      FWrite( nHandle, cx)

      FClose( nHandle )
      drgMsgBox(drgNLS:msg('XML soubor byl vytvoøen'), XBPMB_INFORMATION)
    endif

  case datkomhd->cIdDatKom = 'DIST000038'
    ctm  := StrZero(dph_2011->nm,2) + StrZero(dph_2011->nrok,4)
    file := selFILE('DPHDP3_'+ctm,'Xml',,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

    if .not. Empty(file)
      nHandle := FCreate( file )
//      FAttr( file, "H" )
//      nHandle := FOpen( file, FO_READWRITE )

      ny := At( " ", dph_2011->csesjmeno)
      cp := AllTrim( SubStr( dph_2011->csesjmeno, 1, ny-1))
      cj := AllTrim( SubStr( dph_2011->csesjmeno, ny+1))

      cx := '<?xml version=' + fVAR("1.0")+ ' encoding=' +fVAR("windows-1250")+' standalone='+ fVAR("no")+'?>' + CRLF
//      cx := '<?xml version=' + fVAR("1.0")+ ' encoding=' +fVAR("UTF-8")+' standalone='+ fVAR("no")+'?>' + CRLF
      FWrite( nHandle, cx)

      cx := '<Pisemnost nazevSW='+fVAR("A++")+' verzeSW='+fVAR("1.04.4")+'>' + CRLF
      FWrite( nHandle, cx)
      cx := '  <DPHDP3 verzePis='+fVAR("01.02")+'>' + CRLF
      FWrite( nHandle, cx)

      cx := '       <VetaD'
       cx += ' c_okec='
        cx += fVAR(AllTrim( SysConfig('System:cKodOKEC')))

       if dph_2011->nq > 0
         cx += ' ctvrt='
          cx += fVAR(AllTrim(Str(dph_2011->nq)))
       endif

       cx += ' d_poddp='
        cx += fVAR(dtoc(Date()))
//       cx += ' d_zjist'
//        cx += fVAR( )
       cx += ' dapdph_forma='
        cx += fVAR( if(.not.empty(dph_2011->crp),'B',if(.not.empty(dph_2011->cop),'O','D')))
       cx += ' dokument='
        cx += fVAR('DP3' )
       cx += ' k_uladis='
        cx += fVAR('DPH')
       cx += ' kod_zo='
        cx += fVAR(AllTrim(dph_2011->czo))

       if dph_2011->nm > 0
         cx += ' mesic='
          cx += fVAR(AllTrim(Str(dph_2011->nm)))
       endif

       cx += ' rok='
        cx += fVAR(AllTrim(Str(dph_2011->nrok)))
       cx += ' trans='
        cx += fVAR(if(.not.empty(dph_2011->cnu), 'N', 'A'))     /// POZOR je tu chyba naplní se X a podle JT by nemìlo
       cx += ' typ_platce='
        cx += fVAR(AllTrim( SysConfig('Finance:cTypPlaDPH')))
//        cx += fVAR(if(.not.empty(dph_2011->cpd),'P',if(.not.empty(dph_2011->cio),'I';   // úprava JT 28.2.2014
//                         ,'S')))
//       cx += ' zdobd_do'
//        cx += fVAR( )
//       cx += ' zdobd_od'
//        cx += fVAR( )
      cx += '/>'
       cx += CRLF
      FWrite( nHandle, cx)

      cx := '       <VetaP c_orient='
       cx += fVAR(AllTrim(dph_2011->ccp))
//      cx += ' c_pop='
//       cx += fVAR()
       cx += ' c_telef='
        cx += fVAR(AllTrim(dph_2011->ctelefon))
       cx += ' c_ufo='
        cx += fVAR( AllTrim(Str( SysConfig('System:nFINURKRAJ'),3,0)))
       cx += ' c_pracufo='
        cx += fVAR( AllTrim(Str( SysConfig('System:nFINURAD'),4,0)))
       cx += ' dic='
        cx += fVAR( SubStr(AllTrim(dph_2011->cdic),3))
//      cx += ' dodobchjm='
//       cx += fVAR()
       cx += ' email='
        cx += fVAR(AllTrim(dph_2011->cmail))
//      cx += ' jmeno='
//       cx += fVAR()
       cx += ' naz_obce='
        cx += fVAR(AllTrim(dph_2011->cSidlo))
       cx += ' opr_jmeno='
        cx += fVAR(AllTrim(dph_2011->codposjmen))
       cx += ' opr_postaveni='
        cx += fVAR(AllTrim(dph_2011->codpospost))
       cx += ' opr_prijmeni='
        cx += fVAR(AllTrim(dph_2011->codposprij))
//      cx += ' prijmeni='
//       cx += fVAR()
       cx += ' psc='
        cx += fVAR(AllTrim(dph_2011->cpsc))
       cx += ' sest_jmeno='
        cx += fVAR(AllTrim(cj))
       cx += ' sest_prijmeni='
        cx += fVAR(AllTrim(cp))
       cx += ' sest_telef='
        cx += fVAR(AllTrim(StrTran(dph_2011->csestelef,' ','')))
       cx += ' stat='
        cx += fVAR(AllTrim(dph_2011->cstat))
//      cx += ' titul='
//       cx += fVAR()
       cx += ' typ_ds='
        cx += fVAR(AllTrim(SysConfig('System:cTYPDANSUB')))
       cx += ' ulice='
        cx += fVAR(AllTrim(dph_2011->cUlice))
//      cx += ' zast_dat_nar='
//       cx += fVAR()
//      cx += ' zast_ev_cislo='
//       cx += fVAR()
//      cx += ' zast_ic='
//       cx += fVAR()
//      cx += ' zast_jmeno='
//       cx += fVAR()
//      cx += ' zast_kod='
//       cx += fVAR()
//      cx += ' zast_nazev='
//       cx += fVAR()
//      cx += ' zast_prijmeni='
//       cx += fVAR()
//      cx += ' zast_typ='
//       cx += fVAR()
       cx += ' zkrobchjm='
        cx += fVAR(AllTrim(dph_2011->cpraosnaz))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)

      cx := '       <Veta1 dan23='
        cx += fVAR( AllTrim(Str(dph_2011->nR001d,14)))
       cx += ' dan5='
        cx += fVAR( AllTrim(Str(dph_2011->nR002d,14)))
       cx += ' dan_dzb23='
        cx += fVAR( AllTrim(Str(dph_2011->nR007d,14)))
       cx += ' dan_dzb5='
        cx += fVAR( AllTrim(Str(dph_2011->nR008d,14)))
       cx += ' dan_pdop_nrg='
        cx += fVAR( AllTrim(Str(dph_2011->nR009d,14)))
       cx += ' dan_psl23_e='
        cx += fVAR( AllTrim(Str(dph_2011->nR005d,14)))
       cx += ' dan_psl23_z='
        cx += fVAR( AllTrim(Str(dph_2011->nR011d,14)) )
       cx += ' dan_psl5_e='
        cx += fVAR( AllTrim(Str(dph_2011->nR006d,14)))
       cx += ' dan_psl5_z='
        cx += fVAR( AllTrim(Str(dph_2011->nR012d,14)))
       cx += ' dan_pzb23='
        cx += fVAR( AllTrim(Str(dph_2011->nR003d,14)))
       cx += ' dan_pzb5='
        cx += fVAR( AllTrim(Str(dph_2011->nR004d,14)))
       cx += ' dan_rpren23='
        cx += fVAR( AllTrim(Str(dph_2011->nR010d,14)))
       cx += ' dan_rpren5='
        cx += fVAR( AllTrim(Str(dph_2011->nR011d,14)))
       cx += ' dov_zb23='
        cx += fVAR( AllTrim(Str(dph_2011->nR007z,14)))
       cx += ' dov_zb5='
        cx += fVAR( AllTrim(Str(dph_2011->nR008z,14)))
       cx += ' obrat23='
        cx += fVAR( AllTrim(Str(dph_2011->nR001z,14)))
       cx += ' obrat5='
        cx += fVAR( AllTrim(Str(dph_2011->nR002z,14)))
       cx += ' p_dop_nrg='
        cx += fVAR( AllTrim(Str(dph_2011->nR009z,14)))
       cx += ' p_sl23_e='
        cx += fVAR( AllTrim(Str(dph_2011->nR005z,14)))
       cx += ' p_sl23_z='
        cx += fVAR( AllTrim(Str(dph_2011->nR011z,14)))
       cx += ' p_sl5_e='
        cx += fVAR( AllTrim(Str(dph_2011->nR006z,14)))
       cx += ' p_sl5_z='
        cx += fVAR( AllTrim(Str(dph_2011->nR012z,14)))
       cx += ' p_zb23='
        cx += fVAR( AllTrim(Str(dph_2011->nR003z,14)))
       cx += ' p_zb5='
        cx += fVAR( AllTrim(Str(dph_2011->nR004z,14)))
       cx += ' rez_pren23='
        cx += fVAR( AllTrim(Str(dph_2011->nR010z,14)))
       cx += ' rez_pren5='
        cx += fVAR( AllTrim(Str(dph_2011->nR011z,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta2 dod_dop_nrg='
        cx += fVAR( AllTrim(Str(dph_2011->nR023p,14)))
       cx += ' dod_zb='
        cx += fVAR( AllTrim(Str(dph_2011->nR020p,14)))
       cx += ' pln_ost='
        cx += fVAR( AllTrim(Str(dph_2011->nR026p,14)))
       cx += ' pln_rez_pren='
        cx += fVAR( AllTrim(Str(dph_2011->nR025p,14)))
       cx += ' pln_sluzby='
        cx += fVAR( AllTrim(Str(dph_2011->nR021p,14)))
       cx += ' pln_vyvoz='
        cx += fVAR( AllTrim(Str(dph_2011->nR022p,14)))
       cx += ' pln_zaslani='
        cx += fVAR( AllTrim(Str(dph_2011->nR024p,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta3 dov_osv='
        cx += fVAR( AllTrim(Str(dph_2011->nR032p,14)))
       cx += ' opr_dluz='
        cx += fVAR( AllTrim(Str(dph_2011->nR034d,14)))
       cx += ' opr_verit='
        cx += fVAR( AllTrim(Str(dph_2011->nR033d,14)))
       cx += ' tri_dozb='
        cx += fVAR( AllTrim(Str(dph_2011->nR031p,14)))
       cx += ' tri_pozb='
        cx += fVAR( AllTrim(Str(dph_2011->nR030p,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta4 dov_cu='
        cx += fVAR( AllTrim(Str(dph_2011->nR042z,14)))
       cx += ' nar_maj='
        cx += fVAR( AllTrim(Str(dph_2011->nR047z,14)))
       cx += ' nar_zdp23='
        cx += fVAR( AllTrim(Str(dph_2011->nR043z,14)))
       cx += ' nar_zdp5='
        cx += fVAR( AllTrim(Str(dph_2011->nR044z,14)))
       cx += ' od_maj='
        cx += fVAR( AllTrim(Str(dph_2011->nR047d,14)))
       cx += ' od_zdp23='
        cx += fVAR( AllTrim(Str(dph_2011->nR043d,14)))
       cx += ' od_zdp5='
        cx += fVAR( AllTrim(Str(dph_2011->nR044d,14)))
       cx += ' odkr_maj='
        cx += fVAR( AllTrim(Str(dph_2011->nR047r,14)))
       cx += ' odkr_zdp23='
        cx += fVAR( AllTrim(Str(dph_2011->nR043r,14)))
       cx += ' odkr_zdp5='
        cx += fVAR( AllTrim(Str(dph_2011->nR044r,14)))
       cx += ' odp_cu='
        cx += fVAR( AllTrim(Str(dph_2011->nR042r,14)))
       cx += ' odp_cu_nar='
        cx += fVAR( AllTrim(Str(dph_2011->nR042d,14)))
       cx += ' odp_rez_nar='
        cx += fVAR( AllTrim(Str(dph_2011->nR045d,14)))
       cx += ' odp_rezim='
        cx += fVAR( AllTrim(Str(dph_2011->nR045r,14)))
       cx += ' odp_sum_kr='
        cx += fVAR( AllTrim(Str(dph_2011->nR046r,14)))
       cx += ' odp_sum_nar='
        cx += fVAR( AllTrim(Str(  dph_2011->nR046d,14)))
       cx += ' odp_tuz23='
        cx += fVAR( AllTrim(Str(dph_2011->nR040r,14)))
       cx += ' odp_tuz23_nar='
        cx += fVAR( AllTrim(Str(dph_2011->nR040d,14)))
       cx += ' odp_tuz5='
        cx += fVAR( AllTrim(Str(dph_2011->nR041r,14)))
       cx += ' odp_tuz5_nar='
        cx += fVAR( AllTrim(Str(dph_2011->nR041d,14)))
       cx += ' pln23='
        cx += fVAR( AllTrim(Str(dph_2011->nR040z,14)))
       cx += ' pln5='
        cx += fVAR( AllTrim(Str(dph_2011->nR041z,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta5 koef_p20_nov='
        cx += fVAR( AllTrim(Str(dph_2011->nR052k,14)))

       if dph_2011->nR053k <> 0
         cx += ' koef_p20_vypor='
          cx += fVAR( AllTrim(Str(dph_2011->nR053k,14)))
       endif

       cx += ' odp_uprav_kf='
        cx += fVAR( AllTrim(Str(dph_2011->nR052o,14)))
       cx += ' pln_nkf='
        cx += fVAR( AllTrim(Str(dph_2011->nR051s,14)))
       cx += ' plnosv_kf='
        cx += fVAR( AllTrim(Str(dph_2011->nR050p,14)))
       cx += ' plnosv_nkf='
        cx += fVAR( AllTrim(Str(dph_2011->nR051b,14)))

       if dph_2011->nR053o <> 0
         cx += ' vypor_odp='
          cx += fVAR( AllTrim(Str(dph_2011->nR053o,14)))
       endif

      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta6 dan_vrac='
        cx += fVAR( AllTrim(Str(dph_2011->nR061d,14)))
       cx += ' dan_zocelk='
        cx += fVAR( AllTrim(Str(dph_2011->nR062d,14)))
       cx += ' dano='
        cx += fVAR( AllTrim(Str(dph_2011->nR066d,14)))
       cx += ' dano_da='
        cx += fVAR( AllTrim(Str(dph_2011->nR064d,14)))
       cx += ' dano_no='
        cx += fVAR( AllTrim(Str(dph_2011->nR065o,14)))
       cx += ' odp_zocelk='
        cx += fVAR( AllTrim(Str(dph_2011->nR063o,14)))

       if dph_2011->nR060o <> 0
         cx += ' uprav_odp='
          cx += fVAR( AllTrim(Str(dph_2011->nR060o,14)))
       endif
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)

      cx := '  </DPHDP3>' + CRLF
      FWrite( nHandle, cx)
      cx := '</Pisemnost>'
      FWrite( nHandle, cx)

      FClose( nHandle )

      drgMsgBox(drgNLS:msg('XML soubor byl vytvoøen'), XBPMB_INFORMATION)

    endif

  case datkomhd->cIdDatKom = 'DIST000039' .or. datkomhd->cIdDatKom = 'DIST000040'
    DIST000039( oXbp )

  case datkomhd->cIdDatKom = 'DIST000041'

    file := selFILE('CENZBOZ','txt',,'Výbìr souboru pro export',{{"TXT soubory", "*.TXT"}})
    drgDBMS:open('cenzboz',,,,,'cenzboza')
    drgDBMS:open('c_dph')
    drgDBMS:open('c_katzbo')

    if .not. Empty(file)
      nHandle := FCreate( file )

      do while .not.cenzboza ->( Eof())
        if Val( cenzboza ->ccissklad) = 2 .and. cenzboza->cPolCen = 'C'
          c_dph->(dbSeek( cenzboza ->nklicdph,,'C_DPH1'))
          c_katzbo->(dbSeek( cenzboza ->nzbozikat,,'C_DPH1'))
          cx := AllTrim( cenzboza ->cSklPol) + ";"                       ;
                +StrTran( AllTrim( cenzboza ->cNazZbo), ";", ",") +";"   ;
                 +AllTrim( Str( cenzboza ->nZboziKat)) +";"                        ;
                  +StrTran( AllTrim( c_katzbo ->cnazevkat), ";", ",") +";"   ;
                   +AllTrim( Str( cenzboza ->nCenaPZbo,11,2)) +";"       ;
                    +AllTrim( Str( cenzboza ->nCenaMZbo,11,2)) +";"       ;
                     +AllTrim( Str(c_dph->nprocdph,2,0)) +";"              ;
                      +AllTrim( Str( cenzboza ->nMnozDZbo, 10, 3)) +";"   ;
                       +AllTrim( cenzboza ->czkratjedn)
          cx += CRLF
          FWrite( nHandle, cx)
        endif
        cenzboza ->( dbSkip())
      enddo
      cenzboza ->( dbCloseArea())

      FWrite( nHandle, Chr( 26), 1)
      FClose( nHandle)
    endif

  case datkomhd->cIdDatKom = 'DIST000042'

    file := selFILE('FIRMY','txt',,'Výbìr souboru pro export',{{"TXT soubory", "*.TXT"}})
    drgDBMS:open('firmy',,,,,'firmya')

    if .not. Empty(file)
      nHandle := FCreate( file )

      do while .not.firmya ->( Eof())
          cx := +Str( firmya->ncisfirmy, 5) +";"                                    ;
                 +StrTran( AllTrim( firmya ->cNazev), ";", ",") +";"                ;
                  +Str( firmya->nICO, 10) +";"                                      ;
                   +StrTran( AllTrim( firmya ->cDIC), ";", ",") +";"                ;
                    +StrTran( AllTrim( firmya ->cUlicCiPop), ";", ",") +";"         ;
                     +StrTran( AllTrim( firmya ->cSidlo), ";", ",") +";"            ;
                      +StrTran( AllTrim( firmya ->cPSC), ";", ",") +";"             ;
                       +StrTran( AllTrim( firmya ->cZkratStat), ";", ",") +";"      ;
                        +StrTran( AllTrim( firmya ->cZastupce), ";", ",") +";"      ;
                         +StrTran( AllTrim( firmya ->cTelefon), ";", ",") +";"      ;
                          +StrTran( AllTrim( firmya ->cTelefon2), ";", ",") +";"    ;
                          +StrTran( AllTrim( firmya ->cMobilTEL), ";", ",") +";"    ;
                           +StrTran( AllTrim( firmya ->cEmailTEL), ";", ",") +";"   ;
                            +StrTran( AllTrim( firmya ->cZastOBCH), ";", ",")
          cx += CRLF
          FWrite( nHandle, cx)
        firmya ->( dbSkip())
      enddo
      firmya ->( dbCloseArea())

      FWrite( nHandle, Chr( 26), 1)
      FClose( nHandle)
    endif

  case datkomhd->cIdDatKom = 'DIST000043'

    file := selFILE('PROCENHO','txt',,'Výbìr souboru pro export',{{"TXT soubory", "*.TXT"}})
    drgDBMS:open('procenho',,,,,'procenhoa')

    if .not. Empty(file)
      nHandle := FCreate( file )

      do while .not.procenhoa ->( Eof())
        if procenhoa ->ncisfirmy > 0
          cx := +Str( procenhoa->ncisfirmy, 5) +";"                           ;
                  +Str( procenhoa->nzbozikat, 4) +";"                         ;
                   +StrTran( AllTrim( procenhoa ->cCisSklad), ";", ",") +";"  ;
                    +StrTran( AllTrim( procenhoa ->cSklPol), ";", ",") +";"   ;
                     +Str( procenhoa->nprocento, 9,4) +";"
          cx += CRLF
          FWrite( nHandle, cx)
        endif
        procenhoa ->( dbSkip())
      enddo
      procenhoa ->( dbCloseArea())

      FWrite( nHandle, Chr( 26), 1)
      FClose( nHandle)
    endif

  case datkomhd->cIdDatKom = 'DIST000044'

    file := selFILE('C_KATZBO','txt',,'Výbìr souboru pro export',{{"TXT soubory", "*.TXT"}})
    drgDBMS:open('c_katzbo',,,,,'c_katzboa')

    if .not. Empty(file)
      nHandle := FCreate( file )

      do while .not.c_katzboa ->( Eof())
        cx := Str( c_katzboa ->nZboziKat, 4) +";"                          ;
               +StrTran( AllTrim( c_katzboa ->cnazevkat), ";", ",") +";"
        cx += CRLF
        FWrite( nHandle, cx)
        c_katzboa ->( dbSkip())
      enddo
      c_katzboa ->( dbCloseArea())

      FWrite( nHandle, Chr( 26), 1)
      FClose( nHandle)
    endif

  case datkomhd->cIdDatKom = 'DIST000045'

    file := selFILE('POHLEDAVKY_CS','Csv',,'Výbìr souboru pro export',{{"CSV soubory", "*.CSV"}})

//    drgDBMS:open('fakvyshd')


    if .not. Empty(file)
      nHandle := FCreate( file )

      n  := 0
      ny := 0
      cx := DtoC( Date()) +','
       cx += fVAR('ZP/835/05/LCD') +','
       cx += '19.4.2005,'
//       cx += DtoC( Date()) +','
       cx += fVAR('50') +','
       cx += fVAR( AllTrim(SysConfig('System:cPodnik'))) +','
       cx += fVAR( AllTrim(Str(SysConfig('System:nIco')))) +','
       cx += fVAR( AllTrim(SysConfig('System:cUlice'))+', '+AllTrim(SysConfig('System:cSidlo'))+', '+AllTrim(SysConfig('System:cPSC')))
       cx += CRLF
      FWrite( nHandle, cx)

      do while .not. fakvyshd ->( Eof())
        cx := fVAR(AllTrim(fakvyshd->cnazev)) +','
        cx += fVAR(AllTrim(Str(fakvyshd->nico))) +','
        cx += fVAR(AllTrim(fakvyshd->czkratstat)) +','
        cx += fVAR(AllTrim(fakvyshd->csidlo)) +','
        cx += fVAR(AllTrim(fakvyshd->cvarsym)) +','
        cx += fVAR(AllTrim(fakvyshd->czkratmeny)) +','
        cx += AllTrim(Str(fakvyshd->nCENfazCEL,15,2)) +','
        cx += AllTrim(Str(fakvyshd->nCENfazCEL-fakvyshd->nUhrCelFaZ,15,2)) +','
        cx += DtoC( fakvyshd->dvystfak) +','
        cx += DtoC( fakvyshd->dsplatfak)

        cx += CRLF
        FWrite( nHandle, cx)
        ny += fakvyshd ->ncenzakcel
        fakvyshd ->( dbSkip())
        n++
      enddo

//      FWrite( nHandle, Chr( 26), 1)
      FClose( nHandle)
    endif

// Export bankovních platebních pøíkazù - UniCredit Bank - formát MTC - tuzemský
  case datkomhd->cIdDatKom = 'DIST000046'
    DIST000046( oXbp )

// Export bankovních platebních pøíkazù - UniCredit Bank - formát MTC - zahranièní
  case datkomhd->cIdDatKom = 'DIST000047'
    DIST000047( oXbp )

// Import bankovních výpisù - UnCrBa-formát MTC-MT942 struktur - pøípona - STA
  case datkomhd->cIdDatKom = 'DIST000048'
    DIST000048( oXbp )

// Import bankovních výpisù - UnCrBa-formát MTC-MT940 struktur - pøípona - STA
  case datkomhd->cIdDatKom = 'DIST000049'
    DIST000049( oXbp )

// Import kusovníkových vazeb
  case datkomhd->cIdDatKom = 'DIST000050'
    DIST000050( oXbp )

// Export bankovních platebních pøíkazù - KB - formát KM - tuzemský
  case datkomhd->cIdDatKom = 'DIST000051'
    DIST000051( oXbp )

// Export bankovních platebních pøíkazù - KB - formát BEST - tuzemský
  case datkomhd->cIdDatKom = 'DIST000052'
    DIST000052( oXbp )

// Export bankovních platebních pøíkazù - KB - formát BEST - zahranièní
  case datkomhd->cIdDatKom = 'DIST000053'
    DIST000053( oXbp )

// Export bankovních platebních pøíkazù - KB - formát EDI-BEST - tuzemský
  case datkomhd->cIdDatKom = 'DIST000054'
    DIST000054( oXbp )

// Export bankovních platebních pøíkazù - KB - formát EDI-BEST - zahranièní
  case datkomhd->cIdDatKom = 'DIST000055'
    DIST000055( oXbp )

// Export bankovních platebních pøíkazù - KB - formát XML-SEPA
  case datkomhd->cIdDatKom = 'DIST000056'
    DIST000056( oXbp )

// Export bankovních platebních pøíkazù - ÈS - formát KM - tuzemský
  case datkomhd->cIdDatKom = 'DIST000057'
    DIST000057( oXbp )

// Export bankovních platebních pøíkazù - ÈS - formát MTC - tuzemský
  case datkomhd->cIdDatKom = 'DIST000058'
    DIST000058( oXbp )

// Export bankovních platebních pøíkazù - ÈS - formát MTC - zahranièní
  case datkomhd->cIdDatKom = 'DIST000059'
    DIST000059( oXbp )

// Export bankovních platebních pøíkazù - ÈS - formát CSV - zahranièní
  case datkomhd->cIdDatKom = 'DIST000060'
    DIST000060( oXbp )

// Export bankovních platebních pøíkazù - ÈSOB - formát KM - tuzemský
  case datkomhd->cIdDatKom = 'DIST000061'
    DIST000061( oXbp )

// Export bankovních platebních pøíkazù - ÈSOB - formát MTC - tuzemský
  case datkomhd->cIdDatKom = 'DIST000062'
    DIST000062( oXbp )

// Export bankovních platebních pøíkazù - ÈSOB - formát MTC - zahranièní
  case datkomhd->cIdDatKom = 'DIST000063'
    DIST000063( oXbp )

// Import faktur vystavených z úlohy PALEÈek
  case datkomhd->cIdDatKom = 'DIST000064'
    DIST000064( oXbp )

// Export PROCENHO do txt formátu
  case datkomhd->cIdDatKom = 'DIST000065'
    DIST000065( oXbp )

// Export slev za kategorie PROCENHO do txt formátu
  case datkomhd->cIdDatKom = 'DIST000066'
    DIST000066( oXbp )

// Export slev za kategorie PROCENHO do txt formátu
  case datkomhd->cIdDatKom = 'DIST000067'
    DIST000067( oXbp )

// Export slev za kategorie PROCENHO do txt formátu
  case datkomhd->cIdDatKom = 'DIST000068'
    DIST000068( oXbp )

// Export na úhrad - ÈS - ve formátu NFO
  case datkomhd->cIdDatKom = 'DIST000069'
    DIST000069( oXbp )

// Export na penzijní pojišovnu - KB
  case datkomhd->cIdDatKom = 'DIST000070'
    DIST000070( oXbp )

// Export na hlášení o zmìnách na ÈSSZ - formát XML
  case datkomhd->cIdDatKom = 'DIST000071'
    DIST000071( oXbp )

// Export pøehled o výši pojistné.2013 na ÈSSZ v XML
  case datkomhd->cIdDatKom = 'DIST000072'
    DIST000072( oXbp )

// Export pøílohy k žádosti o nem.dávku na ÈSSZ v XML
  case datkomhd->cIdDatKom = 'DIST000073'
    DIST000073( oXbp )

// Export ELDP od roku 2012 na ÈSSZ v XML
  case datkomhd->cIdDatKom = 'DIST000074'
    pa   := oxbp:parent:odBrowse

    if( npos := ascan( pa, { |o| lower(o:cfile) = cmainFile })) <> 0
      o_mainDBro := pa[npos]
      DIST000074( oXbp, o_mainDBro )
    endif

// Export potvrzení o studiu na ÈSSZ v XML
  case datkomhd->cIdDatKom = 'DIST000075'
**    DIST000075( oXbp )

// Export na penzijní pojišovnu - ÈP
  case datkomhd->cIdDatKom = 'DIST000076'
    DIST000076( oXbp )

// Export CENZBOZ do KARDEXU
  case datkomhd->cIdDatKom = 'DIST000077'
    DIST000077( oXbp )

// Export pohybù - pøíjmù z PVPITEM do KARDEXU d
  case datkomhd->cIdDatKom = 'DIST000078'
    DIST000078( oXbp )

// Import pohybù - výdejù z KARDEXU do zásobníku PVPTERM
  case datkomhd->cIdDatKom = 'DIST000079'
    DIST000079( oXbp )

// Export na penzijní pojišovnu - ÈSOB
  case datkomhd->cIdDatKom = 'DIST000080'
    DIST000080( oXbp )

// Export na penzijní pojišovnu - AXA
  case datkomhd->cIdDatKom = 'DIST000081'
    DIST000081( oXbp )

// Export na penzijní pojišovnu - ALIANZ
  case datkomhd->cIdDatKom = 'DIST000082'
    DIST000082( oXbp )

// Export na penzijní pojišovnu - ÈS
  case datkomhd->cIdDatKom = 'DIST000083'
    DIST000083( oXbp )

// Export na penzijní pojišovnu - ÈS
  case datkomhd->cIdDatKom = 'DIST000084'
    DIST000084( oXbp )

// Export na penzijní pojišovnu - ÈS
  case datkomhd->cIdDatKom = 'DIST000085'
    DIST000085( oXbp )

// Export na penzijní pojišovnu - RAIFFEISEN
  case datkomhd->cIdDatKom = 'DIST000086'
    DIST000086( oXbp )

// Export CENZBOZ do KPK
  case datkomhd->cIdDatKom = 'DIST000087'
    DIST000087( oXbp )

// Export pohybù - pøíjmù z KPK do zásobníku PVPTERM
  case datkomhd->cIdDatKom = 'DIST000088'
    DIST000088( oXbp )

// Import pohybù - výdejù z KPK do zásobníku PVPTERM
  case datkomhd->cIdDatKom = 'DIST000089'
    DIST000089( oXbp )

// Export pro ISPV - mzdy
  case datkomhd->cIdDatKom = 'DIST000090'
    DIST000090( oXbp )

// Synchronizace objednávek pøijatý - jednosmìrná
  case datkomhd->cIdDatKom = 'DIST000091'
    DIST000091( oXbp )

// Export bankovních platebních pøíkazù - GM - KB formát KM - tuzemský
  case datkomhd->cIdDatKom = 'DIST000092'
    DIST000092( oXbp )

// Import do podkladù pro obìdy - KOVAR - v CSV ( z XLS tabulky)
  case datkomhd->cIdDatKom = 'DIST000093'
    DIST000093( oXbp )

// Import do podkladù z výroby - KOVAR - v CSV ( z XLS tabulky)
  case datkomhd->cIdDatKom = 'DIST000094'
    DIST000094( oXbp )

// Synchronizace prodejních cen - jednosmìrná
  case datkomhd->cIdDatKom = 'DIST000095'
    DIST000095( oXbp )

// Synchronizace firem - jednosmìrná
  case datkomhd->cIdDatKom = 'DIST000096'
    DIST000096( oXbp )

// Export bankovních platebních pøíkazù - CITIBANK - formát ASCII delimited - pøípona TXT - tuzemský
  case datkomhd->cIdDatKom = 'DIST000097'
    DIST000097( oXbp )

// Export bankovních platebních pøíkazù - CITIBANIK - formát ASCII delimited - pøípona TXT - zahranièní
  case datkomhd->cIdDatKom = 'DIST000098'
    DIST000098( oXbp )

// Import bankovních výpisù - CITIBANK - formát ASCII delimited - pøípona CSV
  case datkomhd->cIdDatKom = 'DIST000099'
    DIST000099( oXbp )

// Export ISDOC v - XML
//  case datkomhd->cIdDatKom = 'DIST000100'
//    DIST000100( oXbp )

// Export DPH_2015 v - XML
  case datkomhd->cIdDatKom = 'DIST000101'
    DIST000101( oXbp )

// Export souhrnné hlášení k výkazu DPH_2015 v - XML
  case datkomhd->cIdDatKom = 'DIST000102'
    DIST000102( oXbp )

// Export EVD_01/2015 k DPH v - XML
  case datkomhd->cIdDatKom = 'DIST000103' .or. datkomhd->cIdDatKom = 'DIST000104'
    DIST000103( oXbp )

// Export CENZBOZ (skl.položka, skl.množ.) - TXT
  case datkomhd->cIdDatKom = 'DIST000105'
    DIST000105( oXbp )

// Export EVD_04/2015 k DPH v - XML
  case datkomhd->cIdDatKom = 'DIST000106' .or. datkomhd->cIdDatKom = 'DIST000107'
    DIST000106( oXbp )

// Export kontrolní hlášení k výkazu DPH od 2016 v - XML
  case datkomhd->cIdDatKom = 'DIST000108'
    DIST000108( oXbp )

// Export bankovních platebních pøíkazù - RAIFFAISEN Bank - ABO formát
  case datkomhd->cIdDatKom = 'DIST000109'
    DIST000051( oXbp )

// Import bankovních výpisù - RAIFFAISEN Bank - formát KM - pøípona GPC
  case datkomhd->cIdDatKom = 'DIST000110'
    DIST000028( oXbp )

// Export pøehled o výši pojistné.2016 na ÈSSZ v XML
  case datkomhd->cIdDatKom = 'DIST000111'
    DIST000111( oXbp )

// Export tržeb na fin.úøad - EET -POKLADHD  (save doklad)
  case datkomhd->cIdDatKom = 'DIST000112'
    DIST000112( oXbp )

// Hromadný export neodeslaných tržeb na fin.úøad - EET -POKLADHD - POKLHD
  case datkomhd->cIdDatKom = 'DIST000113'
    DIST000113()

// Záloha databáze A++    POZOR obsazené až do DIST000120
  case datkomhd->cIdDatKom = 'DIST000114' .or. datkomhd->cIdDatKom = 'DIST000115'  .or. ;
        datkomhd->cIdDatKom = 'DIST000116' .or. datkomhd->cIdDatKom = 'DIST000117'  .or. ;
         datkomhd->cIdDatKom = 'DIST000118' .or. datkomhd->cIdDatKom = 'DIST000119'  .or. ;
          datkomhd->cIdDatKom = 'DIST000120'
    DIST000114( oXbp)

// Export dat do docházkového terminálu SAFESCAN
  case datkomhd->cIdDatKom = 'DIST000121'
    DIST000121(oXbp)

// Import dat z docházkového terminálu SAFESCAN
  case datkomhd->cIdDatKom = 'DIST000122'
    DIST000122(oXbp)

// Export dat - zelená nafta
  case datkomhd->cIdDatKom = 'DIST000123'
    DIST000123(oXbp)

// Aktualizace DB MySQL pro web - prodej
  case datkomhd->cIdDatKom = 'DIST000124'
    DIST000124(oXbp)

// Export pøílohy k žádosti o nem.dávku na ÈSSZ v XML od 2020
  case datkomhd->cIdDatKom = 'DIST000125'
    DIST000125( oXbp )

// Export pøehled o výši pojistné.2020 na ÈSSZ v XML
  case datkomhd->cIdDatKom = 'DIST000126'
    DIST000126( oXbp )

// Export CENZBOZ (skl.položka, hmotnost) - TXT
  case datkomhd->cIdDatKom = 'DIST000127'
    DIST000127( oXbp )


  endcase

  odata_datKom := ''
RETURN(NIL)


Function ApodporaALL( typ)
  local file, nHandle
  local cx, ctm, n, m
  local aFILE  := {}
  local ausrDB := {}
  local oini
  local ny, cp, cj
  local cPATHelco, ncom
  local new, filtr
  local ozip
  local afile_e, afile_i
  local inp,out
  local dtime, dbold, idfile
  local dbOdes, dbPrij
  local ok

  oini := COMIniFile():new()

  do case
  case typ = 1
    * pøipomínky A++ export hromadný
    if .not. ftpCom(0)
      drgMsgBox(drgNLS:msg('FTP server podpory je nedostupný - EXPORT nelze uskuteènit...'))
      return nil
    endif

    afile_e := { {'asysprhd_e','asysprhdw'}, {'asysprit_e','asyspritw'}}

    drgDBMS:open( 'asysprhd',,,,, 'asysprhd_e' )
    drgDBMS:open( 'asysprit',,,,, 'asysprit_e' )
    drgDBMS:open( 'asysprhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open( 'asyspritw',.T.,.T.,drgINI:dir_USERfitm); ZAP

    filtr := format(  "(nStaKomuni = 0 or nStaKomuni = 3) and nUsrIdDB <> 100101", { asysprhd_e->nUsrIdDB})
    asysprhd_e->( ads_setAof(filtr),dbgoTop())
    dbOld  := asysprhd_e ->nUsrIdDB
    dbOdes := StrZero(usrIdDB,6)

    do while .not. asysprhd_e ->(Eof())
      if dbOld <> asysprhd_e ->nUsrIdDB
        dbPrij := if( usrIdDB = 100101, AllTrim(str(dbOld)), '100101')
        file := idFile('DIST000016_' +dbPrij +'-' +dbOdes)
        zipCom( afile_e, file, .f.)
        ftpCom( file+'.Azf', 1)

        drgDBMS:open( 'asysprhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
        drgDBMS:open( 'asyspritw',.T.,.T.,drgINI:dir_USERfitm); ZAP
        dbOld := asysprhd_e ->nUsrIdDB
      endif

      mh_COPYFLD('asysprhd_e','asysprhdw', .t., .t.)

      filtr     := format(  "nUsrIdDB = %% and cIDpripom = '%%'", { asysprhd_e->nUsrIdDB, asysprhd_e->cIDpripom})
      asysprit_e->( ads_setAof(filtr),dbgoTop())

      do while .not. asysprit_e->(Eof())
        mh_COPYFLD('asysprit_e','asyspritw',.t., .t.)
        asysprit_e->( dbSkip())
      enddo

      if asysprhd_e->( dbRlock())
        asysprhd_e->nStaKomuni := 1
        asysprhd_e->( dbUnlock())
      endif
      asysprit_e->(ads_clearAof())
      asysprhd_e ->( dbSkip())
    enddo

    ok := asysprhdw->(LastRec()) <> 0
    asysprhd_e->(ads_clearAof())

    clsFileCom( afile_e)

    * picnem to ven
    if ok
      dbPrij := if( usrIdDB = 100101, AllTrim(str(dbOld)), '100101')
      file := idFile('DIST000016_' +dbPrij +'-' +dbOdes)
      zipCom( afile_e, file, .f.)
      ftpCom( file +'.Azf', 1)
    endif

    delFileCom( afile_e)

  case typ = 2
    * pøipomínky A++ import

    if .not.ftpCom(0)
      drgMsgBox(drgNLS:msg('FTP server podpory je nedostupný - IMPORT nelze uskuteènit...'))
      return nil
    endif

    do case
    case usrIdDB = 100101
      drgDBMS:open( 'licence' )
      licence->( dbGoTop())
      do while .not. licence->( Eof())
        if( licence->nUsrIdDB >= 110000, AAdd( ausrDB,AllTrim(Str(licence->nusrIdDB))),nil)
        licence->(dbSkip())
      enddo
    otherwise
      AAdd( ausrDB, '100101')
    endcase

    for m := 1 to Len( ausrDB)
      dbPrij := AllTrim(Str(usrIdDB))
      aFile := atmFile('DIST000016_'+dbPrij+'-'+ausrDB[m])
      for n := 1 to Len( aFile)
        ftpCom( aFile[n]+'.Azf', 2)
        afile_i := { {'asysprhd_i','asysprhdw'}, {'asysprit_i','asyspritw'}}
        unzipCom( aFile[n], .f.)

        recNo   := asysprhd->(recNo())

        drgDBMS:open( 'asysprhd',,,,, 'asysprhd_i' )
        drgDBMS:open( 'asysprit',,,,, 'asysprit_i' )

        drgDBMS:open('asysprhdw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
        drgDBMS:open('asyspritw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)

        do while .not. asysprhdw ->(Eof())
          filtr := format( "nUsrIdDB = %% and cIDpripom = '%%'", { asysprhdw->nUsrIdDB, asysprhdw->cIDpripom})
          asyspritw->(ads_setAof(filtr),dbgoTop())

          new := .t.
          ok  := .t.
          if asysprhd_i->( dbSeek( StrZero(asysprhdw->nUsrIdDB,6)+UPPER(asysprhdw->cIDpripom),,'ASYSPRHD05'))
            new := .f.
            ok := asysprhd_i->( dbRlock())
          endif

          if ok
            mh_COPYFLD('asysprhdw','asysprhd_i', new, .t.)
            asysprhd_i->nStaKomuni := 2

            do while .not. asyspritw ->(Eof())
              new := .t.
              ok  := .t.
              if asysprit_i->( dbSeek( StrZero(asyspritw->nUsrIdDB,6)+UPPER(asyspritw->cIDpripom)+StrZero(asyspritw->nOrdItem,6),,'ASYSPRIT07'))
                new := .f.
                ok := asysprit_i->( dbRlock())
              endif

              if ok
                 mh_COPYFLD('asyspritw','asysprit_i', new, .t.)
              endif

              asysprit_i->( dbUnlock())
              asyspritw->( dbSkip())
            enddo

            asysprhd_i->( dbUnlock())
          endif

          asysprhdw->( dbSkip())
        enddo

        ftpCom( aFile[n]+'.Azf', 3)
        clsFileCom( afile_i)
        delFileCom( afile_i)

      next
    next
  endcase

Return(nil)

/*
** pøesunuto do spleèného PRG sys_komunikace_dll
FUNCTION zipCom( afile, out, sel)
  local ozip, file, fileAzf, cdirW, n, m
  local aext := { 'adt', 'adm', 'adi'}

  default sel to .t.

  cdirW  := drgINI:dir_USERfitm +userWorkDir()
  if sel
    fileAzf := selFILE( out, 'Azf',,'Výbìr souboru pro export',{{"AZF soubory", "*.AZF"}})
  else
    fileAzf := cdirW +'\' +out+ '.Azf'
  endif

  ozip := XbZLibZip():New( fileAzf)

  for  n := 1 to Len( afile)
    for m := 1 to Len( aext)
      file := AllTrim(afile[n,2]+ '.'+ aext[m])
      if File( cdirW+'\'+file)
        ozip:AddFile( file, cdirW)
      endif
    next
  next

  ozip:Close()

RETURN( nil)


FUNCTION unzipCom( input, sel)
  local ozip, fileAzf, cdirW

  default sel to .t.

  cdirW  := drgINI:dir_USERfitm +userWorkDir()
  if sel
    fileAzf := selFILE( input, 'Azf',,'Vyber souboru pro import',{{"AZF soubory", "*.AZF"}})
  else
    fileAzf := cdirW +'\' +input+ '.Azf'
  endif


  ozip := XbZLibZip():New( fileAzf, XBZ_OPEN_READ)
  ozip:Extract( cdirW, '*.*', .t., XBZ_OVERWRITE_ALL )
  ozip:close()

return( nil)


FUNCTION ftpCom( file, ntyp)
  local cFtpServer
  local cUserName  := "apodpora"
  local cPassword  := "A++_sw1228"
  local oFtp, cContents, cdirW, lok
  local lenBuff := 40960, buffer := space(lenBuff)
  local ftpDir, ftpFile
//  local cFtpServer := "90.182.133.97"
//  local cFtpServer := "192.168.101.213"

  default ntyp to 0

  lok        := .t.
  cdirW      := drgINI:dir_USERfitm +userWorkDir()
  cFtpServer := AllTrim(SysConfig('System:cFtpAdrKom'))
//  ftpDir     :=
  ftpFile    := SubStr(file, rat( '\', file) +1)

  if ntyp = 5
    sName      := cdirW +'\' +datkomhd->cid
    sNameExt   := '.csv'  //    isNull( FileExt(), '.csv' )
    if( .not. Empty(datkomhd->mDefin_kom), MemoWrit(sName +sNameExt, datkomhd->mDefin_kom), nil)
    buffer := space(lenBuff)

* naèteme ze sekece UsedIdentifiers Fields, pro vlastní TISK pøedáme jen tyto položky *
    GetPrivateProfileStringA('Ftp', 'Server', '',   @buffer, lenBuff,  sName +sNameExt)
    cftpserver := substr(buffer,1,len(trim(buffer))-1)
    GetPrivateProfileStringA('Ftp', 'UserName', '', @buffer, lenBuff,  sName +sNameExt)
    cusername  := substr(buffer,1,len(trim(buffer))-1)
    GetPrivateProfileStringA('Ftp', 'Password', '', @buffer, lenBuff,  sName +sNameExt)
    cpassword  := substr(buffer,1,len(trim(buffer))-1)
  endif

  oFtp := FTPClient():new( cFtpServer, cUserName, cPassWord )

  if .not. oFtp:connect()
    lok := .f.
    if ntyp <> 0
       drgMsgBox(drgNLS:msg('Nelze se pøipojit na FTP server podpory...'))
    endif
//    return
  else
    do case
    case ntyp = 1 .or. ntyp = 5
//      if File( cdirW+'\'+file)
      if File( file)
        cContents := Memoread( file )
        oFtp:put( ftpFile, cContents )
      endif

    case ntyp = 2
      cContents := oFtp:get( file )
      Memowrit( cdirW+'\'+file, cContents)

    case ntyp = 3
      oFtp:delete( file )

    case ntyp = 4
      cContents := oFtp:get( file )
      lok := .not.Empty(cContents)

    endcase

    oFtp:disconnect()

  endif

return( lok)
*/

static function idFile( file)
  local n, tmfi

  begin sequence
   for n:= 1 to 999
     tmfi := file + '_'+ StrZero(n,3)
     if .not.ftpCom( tmfi +'.Azf', 4)
       break
     endif
   next
  end sequence

return( tmfi)



static function atmFile( file)
  local n, tmFi, subFi
  local aFile := {}

  subFi := SubStr(file,1,24)

  begin sequence
   for n:= 1 to 999
     tmFi := subFi + '_'+ StrZero(n,3)
     if ftpCom( tmFi +'.Azf', 4)
       AAdd( aFile, tmFi)
     else
       break
     endif
   next
  end sequence

return( aFile)


/*
** pøesunuto do spleèného PRG sys_komunikace_dll
function delFileCom( afile)
  local filew, cdirW, n, m
  local aext := { 'adt', 'adm', 'adi'}

  cdirW  := drgINI:dir_USERfitm +userWorkDir()

  for  n := 1 to Len( afile)
    for m := 1 to Len( aext)
      filew := AllTrim(afile[n,2]+ '.'+ aext[m])
      if File( cdirW+'\'+filew)
        FErase( cdirW+'\'+filew)
      endif
    next
  next
return( nil)



function clsFileCom( afile)
  local inp, out, n

  for n:= 1 to len(afile)
    inp := afile[n,1]
    out := afile[n,2]
    (inp)->(dbCloseArea())
    (out)->(dbCloseArea())
  next

return( nil)
*/


*
**
CLASS COMIniFile
EXPORTED:
  VAR    file, indexName READONLY
  VAR    hJob, cMemDesign_COM, sName, snameExt
  METHOD init, destroy, ReadSections

HIDDEN:
  VAR    isVariable, inDesign, isdesc
  VAR    cTagFor_COM, cWorkCdx_COM
  METHOD SortOrder , Relations  , ResetKey


  inline method extClass(name)
    local  frmName := substr(name,3)
    local  oxbp    := setAppFocus(), dialog

    dialog := if(oxbp:className() = 'xbpBrowse', oxbp:cargo:drgDialog, ;
                if( oxbp:className() = 'XbpImageButton', oxbp:cargo:drgDialog, ;
                  oxbp:parent) )

    if isMemberVar(dialog:parent, 'helpName')
      if dialog:parent:helpName <> frmName
        DRGDIALOG FORM frmName PARENT dialog MODAL DESTROY EXITSTATE nExit
      endif
    endif

    return .t.

ENDCLASS


METHOD COMIniFile:init(inDesign, isdesc, cMemDesign_COM)
  LOCAL  buffer := StrTran(MemoTran(DatKomHD ->mData_Kom,chr(0)), ' ', ''), n, cname
  local  extBlock

  cresetKey        := xresetKey := ''

  ::inDesign       := inDesign
  ::isdesc         := isdesc
  ::cMemDesign_COM := cMemDesign_COM
  ::cTagFor_COM    := ''

//  ::ReadSections()

  while( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
    if Left(buffer,1) = '['
      cname := lower(substr(buffer,2,n -3))

      do case
//      case cname         = 'definevariable'
//        ::isVariable := .T.
//      case cname         = 'definefield'
//        ::isVariable := .F.
      case left(cname,5) ='table'
        ::file := substr(cname,at(':',cname) +1)

        if .not. empty(DatKomHD->mblockkom)
          if substr(upper(::file), len(::file), 1) = 'W'
            if at('::',DatKomHD->mblockkom) = 0 //.and. DatKomHD->ntypzpr <> 3
              drgDBMS:open(::file,.T.,.T.,drgINI:dir_USERfitm); ZAP
            else
              drgDBMS:open(::file,.T.,.T.,drgINI:dir_USERfitm)
            endif
          else
            drgDBMS:open(::file)
          endif

          if at('::',DatKomHD->mblockkom) <> 0
             ::extClass(alltrim(DatKomHD->mblockkom))
          else
            Eval( &("{||" + alltrim(DatKomHD->mblockkom)+ "}"))
          endif

        else
          drgDBMS:open(::file)
        endif

        (::file)->(dbGoTop())
//        DefineData(::isVariable,::file,,::inDesign,::isdesc)
      case IsMethod(self, cNAMe, CLASS_HIDDEN)
        self:&cname(substr(buffer, n +1))
      endcase
    endif
    buffer := substr(buffer, n +1)
  end
RETURN self


*
**
METHOD COMIniFile:SortOrder(buffer)
  LOCAL  pa, isCompound, x, indexKey := '', n
  *
  LOCAL  odesc, type, len, dec, indexDef, tagNo := 0
  LOCAL  oldEXACT
  *
  Local  npos, cc, a_TagNames


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

        indexKey += if(type = 'C', 'Upper(' +pa[x] +')', ;
                     if(type = 'D', 'DToS(' +pa[x] +')', ;
                      if(type = 'N' .and. isCompound, 'StrZero(' +pa[x] +',' +Str(len) +')', pa[x])))
        indexKey += if(isCompound .and. x < len(pa), '+', '')
      endif
    next

    *
    if substr(upper(::file), len(::file), 1) <> 'W'
      ::indexName := (::file) ->(Ads_GetIndexFilename())
      indexDef    := drgDBMS:dbd:getByKey(::file):indexDef

      oldEXACT    := Set(_SET_EXACT, .F.)
      tagNo       := AScan(indexDef, {|X| Upper(StrTran(X:cIndexKey, ' ', '')) = Upper(indexKey)})
      Set(_SET_EXACT, oldEXACT)
    endif

    do case
    case(tagNo <> 0)
      (::file) ->(OrdSetFocus(tagNo))
    case(tagNo =  0 .and. .not. empty(indexKey))

      a_TagNames := (::file)->(OrdList())
      if( npos := AScan( a_TagNames, {|s| 'LLTISK_' $ s} )) <> 0
                  cc := StrZero( Val( SubStr( a_TagNames[npos], 8, 3)), 3, 0 )
        ::cTagFor_COM := 'COMM_' +cc
      else
        ::cTagFor_COM := 'COMM_001'
      endif

      ::cWorkCdx_COM  := drgINI:dir_USERfitm +userWorkDir() +'\Komunik'

      DbSelectArea(::file)

      (::file) ->(Ads_CreateTmpIndex( ::cWorkCdx_COM, ::cTagFor_COM,  indexKey ))
      (::file) ->(OrdSetFocus(::cTagFor_COM))
    endcase
  endif
RETURN self



METHOD COMIniFile:Relations(buffer)
  LOCAL pa, n

  while(asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0)
    if Left(buffer,1) <> '['
      pa := ListAsArray(lower(substr(buffer,1,n -1)),':')
      *
      if substr(upper(pa[5]), len(pa[5]), 1) = 'W'
        drgDBMS:open(pa[5],.T.,.T.,drgINI:dir_USERfitm)
      else
        drgDBMS:open(pa[5])
      endif

      (pa[5]) ->( AdsSetOrder( Val(pa[1]) ) )
      (pa[4]) ->( DbSetRelation(pa[5], COMPILE(pa[3]), pa[3]), dbSkip(0))

//      DefineData(::isVariable,::file,pa[5],::inDesign,::isdesc)
    endif
    buffer := substr(buffer, n +1)
  enddo
RETURN self


METHOD COMIniFile:ResetKey(buffer)
  cresetKey := buffer
  xresetKey := DBGETVAL(cresetKey)
return self


METHOD COMIniFile:ReadSections( writeToFile )
  local  pa, x, cvarName
  local  lenBuff := 40960, buffer := space(lenBuff)

  default writeToFile to .t.

  pa_inSections := {}

/*
  if .not. Empty(FORMs ->mFORMS_ll)
    if writeToFile
      MemoWrit(sName +sNameExt,FORMs ->mFORMS_ll)
    endif

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
*/
return self


METHOD COMIniFile:destroy()
  local  i_ext := DbeInfo( COMPONENT_ORDER, ADSDBE_INDEX_EXT    )

  if .not. Empty(::cTagFor_COM)
    if substr(upper(::file), len(::file), 1) = 'W'
      (::file) ->(OrdListClear())
    else
      (::file) ->(OrdListClear(), OrdListAdd(::indexName), OrdSetFocus(1))
    endif

    FErase(::cWorkCdx_COM +'.' +i_ext)
  endif

* uklidíme si
  FErase(::cMemDesign_COM)

  ::file           := ;
  ::indexName      := ;
  ::isVariable     := ;
  ::inDesign       := ;
  ::isdesc         := ;
  ::cTagFor_COM    := ;
  ::cWorkCdx_COM   := ;
  ::hJob           := ;
  ::cMemDesign_COM := ;
  ::sName          := ;
  ::snameExt       := NIL
RETURN