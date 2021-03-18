//////////////////////////////////////////////////////////////////////
//
//  Asystem++_login.PRG
//
//  Copyright:
//       MISS Software, s.r.o., (c) 2005. All rights reserved.
//
//  Contents:
//       Login Asystem++Dialog.
//
//  Remarks:
//
//
//////////////////////////////////////////////////////////////////////


#include "appevent.ch"

#include "bap.ch"

#include "Common.ch"
#include "directry.ch"
#include "dac.ch"
#include "dmlb.ch"
#include "font.ch"
#include "gra.ch"
#include "xbp.ch"
#include "drg.ch"

#include "ads.ch"
#include "adsdbe.ch"

#include "drgRes.ch"

#include "DLL.ch"
#include "XbZ_Zip.ch"
#include "ot4xb.ch"

// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"
#include "..\A_main\ace.ch"





//#include "XbZLib.ch"


**  Verze systému
** CLASS for SYS_verze_CRD *********************************************
CLASS SYS_verze_IN FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  onSave
  METHOD  getForm
  METHOD  dir
  METHOD  sestVer

  method  ebro_beforeAppend, ebro_afterAppend, ebro_saveEditRow


  METHOD  destroy

  VAR     paswordCheck
  VAR     newRec


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::onSave()
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
      RETURN .t.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR typ, dm, msg

ENDCLASS


METHOD SYS_verze_IN:init(parent)

  drgDBMS:open('ASYSVER')
  ::drgUsrClass:init(parent)

RETURN self


METHOD SYS_verze_IN:getForm()
  LOCAL drgFC, cParm, oDrg

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 85,25 DTYPE '10' TITLE 'Zmìny v plánovaní a distribuci verzí systému' GUILOOK 'All:Y,Border:Y,Action:Y'

  DRGAction INTO drgFC CAPTION '~SestavVer' EVENT 'sestVer'  TIPTEXT 'Sestavení distribuèní verze'// ICON1 101 ICON2 201 ATYPE 3
*  DRGAction INTO drgFC CAPTION '~DistrLic' EVENT 'distrLic'  TIPTEXT 'Vytvoøení distribuèního licenèního souboru'// ICON1 101 ICON2 201 ATYPE 3

*    odrg:resize := 'yx'

    DRGEBROWSE INTO drgFC FPOS .5,0.1 SIZE 84.0,11.4 FILE 'ASYSVER'          ;
               SCROLL 'ny' CURSORMODE 3 PP 7 GUILOOK 'sizecols:n,headmove:n' ;
               ITEMMARKED 'itemMarked'
      _drgEBrowse := oDrg
      _drgEBrowse:popupMenu := 'yy'


      DRGGET      asysver->cverze     INTO drgFC CLEN  10 FCAPTION 'Verze'
      DRGGET      asysver->dVznikVer  INTO drgFC CLEN  11 FCAPTION 'Vznik KDY'
      DRGGET      asysver->dPlanVer   INTO drgFC CLEN  11 FCAPTION 'Plán KDY'
      DRGCOMBOBOX asysver->nTypVer    INTO drgFC FLEN  15 FCAPTION 'Typ verze'  ;
                    VALUES '0:plánovaná,1:vývoj,2:distribuèní,3:archivní,4:aktuální'
      DRGMLE      asysver->mPopisPlan INTO drgFC CLEN 17 SIZE 26,10
      DRGMLE      asysver->mPopisVer  INTO drgFC CLEN 17 SIZE 26,10

      DRGGET      asysver->nverze     INTO drgFC CLEN  10 FCAPTION 'Verze num'
      DRGGET      asysver->cverzeDB   INTO drgFC CLEN  10 FCAPTION 'Verze_DB'
      DRGGET      asysver->nverzeDB   INTO drgFC CLEN  10 FCAPTION 'Verze_DBn'
      DRGGET      asysver->dStazVer   INTO drgFC CLEN  11 FCAPTION 'Dat_staz_ver'
      DRGGET      asysver->cUsrInsVer INTO drgFC CLEN  10 FCAPTION 'Kdo_inst_ver'
      DRGGET      asysver->dInstalVer INTO drgFC CLEN  11 FCAPTION 'Dat_inst_ver'
      DRGGET      asysver->nDistrib   INTO drgFC CLEN  10 FCAPTION 'Verze'
      DRGGET      asysver->cVerzeFi   INTO drgFC CLEN  10 FCAPTION 'Verze_FI'
      DRGGET      asysver->nVerzeFi   INTO drgFC CLEN  10 FCAPTION 'Verze_FIn'
      DRGGET      asysver->dVerzeFi   INTO drgFC CLEN  11 FCAPTION 'Verze_FIsest'
      DRGGET      asysver->cVerzeDBfi INTO drgFC CLEN  10 FCAPTION 'Verze_DBc'
      DRGGET      asysver->nVerzeDBfi INTO drgFC CLEN  10 FCAPTION 'Verze_DBn'
      DRGGET      asysver->dVerzeDBfi INTO drgFC CLEN  11 FCAPTION 'Verze_DBd'
      DRGGET      asysver->cSestUSER  INTO drgFC CLEN  10 FCAPTION 'Verzi_sest'
      DRGGET      asysver->dSestVerze INTO drgFC CLEN  11 FCAPTION 'Verzi_sest'

*     odrg:isedit_inrev := .f.

     _drgEBrowse:createColumn(drgFC)
    DRGEND INTO drgFC

  DRGMLE asysver->mPopisPlan INTO drgFC FPOS  .5,12.5 SIZE 84,5.8 PP 2 FCAPTION 'Informace o plánovaných zmìnách ve verzi' CPOS 1.5,11.6
  DRGMLE asysver->mPopisVer  INTO drgFC FPOS  .5,19.1 SIZE 84,5.8 PP 2 FCAPTION 'Informace o provedených zmìnách ve verzi' CPOS 1.5,18.2



RETURN drgFC


METHOD SYS_verze_IN:drgDialogStart(drgDialog)
  LOCAL aUsers
  LOCAL n
  LOCAL oSle

  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager

RETURN self


                                 *
*****************************************************************
METHOD SYS_verze_IN:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval

  ** ukládáme pøi zmìnì do tmp **
  if(lOK, ::msg:writeMessage(), NIL)
//  if( changed, ::dm:refresh(.T.), NIL )

RETURN lOk

* ok
method SYS_verze_IN:ebro_beforeAppend(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky

//  do case
//  case (cfile = 'defvykhd')
//    ::stableBlock(o_ebro:oxbp)
*---    ::itemMarked( ,,o_ebro:oxbp)



return .t.


method SYS_verze_IN:ebro_afterAppend(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky


return .t.


method SYS_verze_IN:ebro_saveEditRow(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky

//  do case
//  case (cfile = 'defvykhd')
//    if empty((cfile)->cidvykazu)
//      (cfile)->nid        := ::dm:get("defvykhd->nid")
//      (cfile)->cidvykazu  := ::dm:get("defvykhd->cidvykazu")

return


METHOD SYS_verze_IN:onSave()
  LOCAL aUsers
  LOCAL n

//  ::dm:save()

RETURN .T.



METHOD SYS_verze_IN:dir()
  local  path, n
  local  cfile := AllTrim(drgINI:dir_DATA)

  n     := Rat('\Data\', cfile)
  cfile := SubStr( cfile, 1, n)

  path := selDIR(,cfile )

RETURN .t.



METHOD SYS_verze_IN:sestVer(drgDialog)
  local cver := AllTrim(asysver->cVerze)

  if ( At(cver, verzeAsys[3,2]) > 0)

    DRGDIALOG FORM 'SYS_verze_SESTAV' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

  else

    MsgBox( 'Záznam s verzí ['+ AllTrim(asysver->cVerze)+'] nemùžete sestavovat                                        s verzí exe ['+verzeAsys[3,2]+']',;
     'CHYBA pøi sestavování verze...' )

  endif

RETURN .t.



** END of CLASS ****************************************************************
METHOD SYS_verze_IN:destroy()
  ::drgUsrClass:destroy()

RETURN NIL



**  Verze systému
** CLASS for SYS_verze_CRD *********************************************
CLASS SYS_verze_SESTAV FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  preValidate, postValidate
  METHOD  onSave
  METHOD  getForm
  METHOD  sestVer

  METHOD  destroy

  VAR cadresar, verze, verzeADS, verzeLL, klient, system, runtime, data, setup, konec


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::onSave()
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
      RETURN .t.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR msg, dm

ENDCLASS


METHOD SYS_verze_SESTAV:init(parent)

  ::drgUsrClass:init(parent)

  ::cadresar  := SysConfig('System:cPathDistr')
  ::verze     := 32
  ::verzeADS  := 10
  ::verzeLL   := 20
  ::klient    := 'x'
  ::system    := 'x'
  ::runtime   := 'x'
  ::data      := 'x'
  ::setup     := 'x'
  ::konec     := ''

RETURN self


METHOD SYS_verze_SESTAV:getForm()
  LOCAL drgFC, cParm, oDrg

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 85,21 DTYPE '10' TITLE 'Prubìh sestavení distribuèní verze' GUILOOK 'All:N,Border:N,Action:N' POST 'postValidate'

   DRGSTATIC INTO drgFC FPOS 1.0,0.1 SIZE 83,9.5 STYPE 12

    DRGTEXT INTO drgFC CLEN 32 CAPTION  'Sestavení distribuèní verze - ' CPOS 20,0.7 FONT 7
     DRGTEXT asysver->cverze INTO drgFC CPOS 52,0.7 CLEN 20 FONT 7

    DRGTEXT INTO drgFC CLEN  20 CAPTION  'Cesta pro sestavení'      CPOS 1,2.4 FONT 6
     DRGGET M->cadresar INTO drgFC FPOS 23,2.4 FLEN 50

    DRGTEXT INTO drgFC CLEN  20 CAPTION  'Typ verze' CPOS 1,3.4 FONT 6
     DRGCOMBOBOX M->verze INTO drgFC FPOS 23,3.4 FLEN 31  ;
                  VALUES '32:32 bitová,64:64 bitová'

    DRGTEXT INTO drgFC CLEN  20 CAPTION  'Verze ADS' CPOS 1,4.4 FONT 6
     DRGCOMBOBOX M->verzeADS INTO drgFC FPOS 23,4.4 FLEN 31  ;
                  VALUES '10:verze ADS_10,8:verze ADS_8'

    DRGTEXT INTO drgFC CLEN  20 CAPTION  'Verze LL' CPOS 1,5.4 FONT 6
     DRGCOMBOBOX M->verzeLL INTO drgFC FPOS 23,5.4 FLEN 31  ;
                  VALUES '20:verze LL_20,11:verze LL_11'


    DRGPUSHBUTTON INTO drgFC CAPTION 'Spus vytvoøení verze' POS 23,8.0 SIZE 39,1.2 ;
        EVENT 'sestVer' ICON1 MIS_ICON_APPEND ICON2 gDRG_ICON_QUIT ATYPE 3   ;
          TIPTEXT 'Vytvoøí instalaèní sadu pro A++'


  DRGEnd INTO drgFC


    DRGTEXT INTO drgFC CLEN  30 CAPTION  'Sestavení klienta' CPOS 20,11 FONT 6
     DRGTEXT M->klient INTO drgFC CLEN  15 CPOS 63,11 FONT 6
    DRGTEXT INTO drgFC CLEN  30 CAPTION  'Sestavení systému' CPOS 20,12.5 FONT 6
     DRGTEXT M->system INTO drgFC CLEN  15 CPOS 63,12.5 FONT 6
    DRGTEXT INTO drgFC CLEN  30 CAPTION  'Sestavení runtime' CPOS 20,14 FONT 6
     DRGTEXT M->runtime INTO drgFC CLEN 15 CPOS 63,14 FONT 6
    DRGTEXT INTO drgFC CLEN  30 CAPTION  'Sestavení dist.dat' CPOS 20,15.5 FONT 6
     DRGTEXT M->data INTO drgFC CLEN 15 CPOS 63,15.5 FONT 6
    DRGTEXT INTO drgFC CLEN  30 CAPTION  'Sestavení setup.exe' CPOS 20,17 FONT 6
     DRGTEXT M->setup INTO drgFC CLEN 15 CPOS 63,17 FONT 6


     DRGTEXT M->konec INTO drgFC CLEN 50 CPOS 25,18.5 FONT 7

RETURN drgFC


METHOD SYS_verze_SESTAV:drgDialogStart(drgDialog)
  LOCAL aUsers
  LOCAL n
  LOCAL oSle

  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager

RETURN self

*
*****************************************************************
METHOD SYS_verze_SESTAV:preValidate(drgVar, oXbp)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval


RETURN lOk


*
*****************************************************************
METHOD SYS_verze_SESTAV:postValidate(drgVar, oXbp)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval


//  ::sestVer(AllTrim(value))

  ** ukládáme pøi zmìnì do tmp **
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,oXbp)

//  if(lOK, ::msg:writeMessage(), NIL)

RETURN lOk


METHOD SYS_verze_SESTAV:onSave()
  LOCAL aUsers
  LOCAL n

  ::dm:save()

RETURN .T.


METHOD SYS_verze_SESTAV:sestVer( drgVar)

  local  ozip
//  local  croot := 'c:'
  local  cdirarc, cfilearc
  local  csourcedir, ctargetdir
  local  aRunXBP, aRunADS, n
  local  lok := .t.
//  local  oInfo  := TFileVersionInfo():New()
  local  values := drgDBMS:dbd:values, cfile, fileName, odbd, data_ext
  local  aDirectory
  local  croot

  croot := ::dm:get('M->cadresar')
  croot := retDir( croot)

//  drgdump(  "croot    :  " +croot +CRLF)

  aRunXBP := { "adac20b.dll","adac20c.dll","adsdbe.dll","adsutil.dll"  ;
              ,"asrdbc10.dll","cdxdbe.dll","foxdbe.dll","ot4xb.dll"    ;
              ,"som.dll","xbzlib.dll","xppdbgc.dll","xppnat.dll"       ;
              ,"xpprt1.dll","xpprt2.dll","xppui1.dll","xppui2.dll","xppsys.dll" ;
              ,"xbtbase1.dll" ;
              ,"ascom10.dll","ascom10c.dll","asinet10.dll","asiutl10.dll","asinet1c.dll" ;
              ,"zlib1.dll","bap.dll"  }

  aRunADS := { "ace32.dll","adsloc32.dll","axcws32.dll","adslocal.cfg" ;
              ,"ansi.chr","extend.chr" }

  if .not. Empty( Directory( croot +'Asystem++_distribuce\Verze\A++_ver_'   ;
                  + AllTrim(asysver->cverze)+'\*.*'))
    lok := drgIsYESNO(drgNLS:msg('Verze již existuje sestavit ji znovu ?'))
  end

  if lok
// založí distribuèní adresáø pokud neexistuje
    ::dataManager:set("m->klient",  'provádím')
    cdirarc := croot +'Asystem++_distribuce\Verze\A++_ver_'   ;
                  + AllTrim(asysver->cverze) +'\Tmp'

//    drgdump( "cdirarc   :   " +cdirarc +CRLF)

    myCreateDir( cdirarc )

    AEval( Directory( cdirarc + "\*.*"), { |X| FErase( cdirarc + "\"+X[ F_NAME ] ) } )

    ozip := XbZLibZip():New(cdirarc + '\A++_Binn.azf')
    ozip:AddFile( 'ASYSTEM++.exe', croot +'Asystem++\Binn')
    ozip:AddFile( 'ASYSTEM_1.dll', croot +'Asystem++\Binn')
    ozip:AddFile( 'ADS.ini', croot +'Asystem++\Binn')
    ozip:AddFile( 'A++_service_manager.exe', croot +'Asystem++\Binn')
    ozip:AddFile( 'A++_service_task.exe', croot +'Asystem++\Binn')
    ozip:Close()
    ::dataManager:set("m->klient",  'OK')

    ::dataManager:set("m->system",  'provádím')
    ozip := XbZLibZip():New(cdirarc + '\A++_System.azf')
    ozip:AddDir( '*.*', croot +'Asystem++\System\Resource')
    ozip:Close()
    ::dataManager:set("m->system",  'OK')

    ::dataManager:set("m->runtime",  'provádím')
    ozip := XbZLibZip():New(cdirarc + '\A++_Runtime.azf')

    ozip:AddDir( '*.*', croot +'Asystem++_distribuce\ReDistrib_Ads_' + AllTrim(Str(::verzeADS)) +'_(' +Str(::verze,2)+')')
    ozip:AddDir( '*.*', croot +'Asystem++_distribuce\ReDistrib_LL_' + AllTrim(Str(::verzeLL)) +'_(' +Str(::verze,2)+')')
    ozip:AddDir( '*.*', croot +'Asystem++_distribuce\ReDistrib_Util'+'_(' +Str(::verze,2)+')')
    ozip:AddDir( '*.*', croot +'Asystem++_distribuce\ReDistrib_OCX'+'_(' +Str(::verze,2)+')')
    ozip:AddDir( '*.*', croot +'Asystem++_distribuce\ReDistrib_Plugin'+'_(' +Str(::verze,2)+')')
    ozip:AddDir( '*.*', croot +'Asystem++_distribuce\ReDistrib_Xbp_1_90_355'+'_(' +Str(::verze,2)+')')

    ozip:AddFile( 'ADS.ini', croot +'Asystem++_distribuce\Setup')
    ozip:Close()
    ::dataManager:set("m->runtime",  'OK')


    ::dataManager:set("m->data",  'provádím')
    myCreateDir( cdirarc +'\Dat')

// vykopírování distribuèních souborù
    data_ext  := DbeInfo( COMPONENT_DATA , DBE_EXTENSION    )
    for x := 1 to len(values) step 1
      odbd     := values[x,2]
      if odbd:lIsCheck .and. .not. empty( odbd:distrib )
        cfile    := lower(values[x,1]) +'.' +lower( data_ext )
        fileName := upper(values[x,1])
        if drgDBMS:open(fileName) <> 0
          hObj := (filename) ->( AdsExtGetTableHandle())

          (filename)->(ads_setAof("ndistrib > 0"))

          AdsCopyTable( hObj,,cdirarc +'\Dat\'+ cfile)
          if filename <> "ASYSVER"
            (filename) ->( dbCloseArea())
          else
            (filename)->(ads_clearAof())
          endif
        endif
      endif
    next

    ozip := XbZLibZip():New(cdirarc + '\A++_Data.azf')
    ozip:AddDir( '*.*', cdirarc +'\Dat')
    ozip:Close()

    aDirectory := Directory( cdirarc + '\Dat\*.*')
    AEval( aDirectory, { |a| FErase( cdirarc + '\Dat\' +a[ F_NAME ] ) } )

    ::dataManager:set("m->data",  'OK')

    ::dataManager:set("m->setup",  'provádím')
//    csourcedir := croot+"Asystem++_distribuce\Runtime\"
    csourcedir := croot +'Asystem++_distribuce\ReDistrib_Xbp_1_90_355'+'_(' +Str(::verze,2)+')\'
    ctargetdir := croot+"Asystem++_distribuce\Verze\A++_ver_" + AllTrim(asysver->cverze) +"\Tmp\"

    for n:= 1 to len( aRunXBP)
      COPY FILE (csourcedir+aRunXBP[n]) TO (ctargetdir +aRunXBP[n])
    next

    csourcedir := croot +'Asystem++_distribuce\ReDistrib_Ads_' + AllTrim(Str(::verzeADS)) +'_(' +Str(::verze,2)+')\'
    ctargetdir := croot+"Asystem++_distribuce\Verze\A++_ver_" + AllTrim(asysver->cverze) +"\Tmp\"
    for n:= 1 to len( aRunADS)
      COPY FILE (csourcedir+aRunADS[n]) TO (ctargetdir +aRunADS[n])
    next

    COPY FILE (croot + "Asystem++_distribuce\Setup\ASYSTEM++_SETUP.EXE") TO (ctargetdir + "ASYSTEM++_SETUP.EXE")
    COPY FILE (croot + "Asystem++_distribuce\Setup\Ads.ini") TO (ctargetdir + "Ads.ini")
    COPY FILE (croot + "Asystem++\Binn\ASYSTEM_1.dll") TO (ctargetdir + "ASYSTEM_1.dll")

    cline := ' -o -c -h '                                                ;
             + '"' +croot + 'Asystem++_distribuce\Verze\A++_ver_'       ;
              + AllTrim(asysver->cverze)+'\Tmp'+'" '                     ;
               +'"' + 'ASYSTEM++_SETUP.EXE' + '" '                       ;
                + '"' +croot +'Asystem++_distribuce\Verze\A++_ver_'     ;
                 + AllTrim(asysver->cverze)                              ;
                  + '\A++_setup_'+verzeAsys[3,2]+'_('+Str(::verze,2)+').exe'+'"'

    cexe  := croot +'Asystem++_distribuce\Utility\makesfx.exe'
    RunShell( cline, cexe, .T. )

    if asysver->(dbRLock())
      asysver->cverzefi   := verzeAsys[3,2]
      asysver->nverzefi   := Val(StrTran(verzeAsys[3,2],'.',''))
//      asysver->dverzefi   := Date()
      asysver->cverzedbfi := SpecialBuild
      asysver->nverzedbfi := Val(StrTran(SpecialBuild,'.',''))
//      asysver->dverzedbfi := SpecialBuild
      asysver->csestuser  := usrName
      asysver->dsestverze := Date()
      asysver->(dbUnLock())
    endif
    ::dataManager:set("m->setup",  'OK')

    ::dataManager:set("m->konec",  '---- SESTAVENÍ VERZE DOKONÈENO ----')
  endif

RETURN .t.



** END of CLASS ****************************************************************
METHOD SYS_verze_SESTAV:destroy()
  ::drgUsrClass:destroy()

RETURN NIL