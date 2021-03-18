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


// Import kusovníkových vazeb -- KOVAR  --
function DIST000050( oxbp ) // oxbp = drgDialog
  *
  local  cpath, in_Dir, cc := 'Umístnìní importovaných dat - kusovníkù...'
  *
  local  odialog, nexit := drgEVENT_QUIT


*  inicializace vazby na excel
  oExcel := CreateObject("Excel.Application")
  if Empty( oExcel )
    MsgBox( "Excel nemáte nainstalovaný na poèítaèi" )
    return 0
  endif

  drgDBMS:open('vyrzak')
  drgDBMS:open('vyrzaki')

  in_Dir := retDir(odata_datKom:PathImport)
  in_Dir := BrowseForFolder( , cc, BIF_USENEWUI, in_Dir)
//  in_Dir := "c:\Asystem++\Users_data\Kovar\Kusovníky\Pokus 90215"
  if .not. empty(in_Dir)
    cpath := in_Dir +if( right( in_Dir, 1) <> '\', '\', '' )
  else
    return .f.
  endif
//  cPath := ConvToAnsiCP( cPath )

*  cPath  := 'c:\Asystem++\Work\Kovar\Kusovníky-pøevod\Data1\'

  afiles := FileInDirs( cpath, '*.xls?', .t.)

  odialog := drgDialog():new('SYS_komunikace_vyr_SEL', oxbp)
  odialog:create(,,.T.)

  odialog:destroy()
  odialog := Nil

  *
  ** smažeme naètené soubory
//  AEval( afiles, { |a| FErase(cpath_kom +a[F_NAME]) } )
*/
  // Quit Excel
  oExcel:Quit()
  oExcel:Destroy()

return(NIL)


Static Function ImpKusov()
  local  afiles, x, file, nHandle, cBuffer, nPointer, n, ny, cx
  * pro kontrolu naètení
  local  cky, lis_ok := .f.
  * pro excel
  local  oBook, oSheet
  local  cCisZakImp, aImpKusov
  local  nRow, nCol, contRows
  local  tmNiz, tmSkl
  local  nvicekusov
  local  newrec
  local  countrec
  local  typKusov

  filew->( ads_setAof( 'select = 1'), dbgoTop())

//  if filew->( Ads_GetKeyCount()) = 0
  countrec := filew->( mh_COUNTREC())
  if countrec = 0
    drgMsgBox(drgNLS:msg( 'Nebyl vybrán žádný soubor pro import !!!'), XBPMB_INFORMATION)
    return 0
  endif

  typKusov     := Left(AllTrim( filew ->File),1)
  cCisZakImp := SubStr(AllTrim( filew ->File),2,5)

// test zda existuje založená zakázka
  do case
  case typKusov = 'Z'
    if .not. vyrzak->(dbSeek( cCisZakImp,,'VYRZAK10'))
      drgMsgBox(drgNLS:msg('Zakázka ' + cCisZakImp + ' není založena v systému. Nelze uskuteènit import !!!'), XBPMB_INFORMATION)
      return 0
    endif
  otherwise

  endcase

  nvicekusov := 0

  drgDBMS:open('kusov',,,,,'kusovj')
  drgDBMS:open('kusovi',.t.,.t.,drgINI:dir_USERgfitm,,,.t.) ; ZAP
  drgDBMS:open('kusovw',.t.,.t.,drgINI:dir_USERfitm,,,.t.) ; ZAP
  drgDBMS:open('vyrpol',,,,,'vyrpoli')
  drgDBMS:open('cenzboz',,,,,'cenzbozi')
  drgDBMS:open('nakpol',,,,,'nakpoli')
  drgDBMS:open('vykresy',,,,,'vykresyi')

  drgServiceThread:progressStart( drgNLS:msg('Importuji XLS soubory...'), countrec )

  filew->( dbgoTop())
  do while .not. filew ->( Eof())
//  for i := 1 to len(afiles)
    oBook    := oExcel:workbooks:Open( filew ->Path_File)
    oSheet   := oBook:ActiveSheet
    contRows := oSheet:usedRange:Rows:Count+1
//    contRows    := oWorkBook:workSheets(1):usedRange:Rows:Count

    for nRow := 5 to contRows
      if nRow >= 5
        if .not. Empty( oSheet:Cells(nRow,1):Value)
          tmNiz := ''
          tmSkl := ''
          kusovi ->( dbAppend())
          if( .not. Empty(oSheet:Cells(2,5):Value),    kusovi ->ckeyimp := oSheet:Cells(2,5):Value, nil)

//          kusovi ->cSubje     :=
          if typKusov = 'Z'
            kusovi ->cCisZakaz  := cCisZakImp
          endif

          if( .not. Empty(oSheet:Cells(2,5):Value), kusovi ->cVysPol := AllTrim(oSheet:Cells(   2,5):Value), nil)
          if .not. Empty(oSheet:Cells(nRow,5):Value)
            kusovi ->nNizVar    := 1
            tmNiz := AllTrim(oSheet:Cells(nRow,5):Value)
            if Len( tmNiz) = 1
              if left(tmNiz,1) = '-'
                tmNiz := ''
              endif
            endif
          endif

          if .not. Empty(oSheet:Cells(nRow,10):Value)
            tmSkl := if( ValType(oSheet:Cells(nRow,10):Value) = 'N',         ;
                           AllTrim(Str(oSheet:Cells(nRow,10):Value,15,0)),   ;
                             AllTrim(oSheet:Cells(nRow,10):Value))
            if len( tmSkl) = 1
              if left(tmSkl,1) = '-'
                tmSkl := ''
              endif
            endif
          endif

          if .not. Empty(tmNiz) .and. .not. Empty(tmSkl)
            kusovi ->cNizPol := tmNiz
            DoplnKusov( oSheet,nRow )
            kusovi ->( dbAppend())
            kusovi ->cVysPol := tmNiz //AllTrim(oSheet:Cells(   2,5):Value)
            kusovi ->cSklPol := tmSkl
            DoplnKusov( oSheet,nRow )
            kusovi ->cText1 := oSheet:Cells( nRow, 4):Value
          else
            kusovi ->cNizPol := tmNiz
            kusovi ->cSklPol := tmSkl
            DoplnKusov( oSheet,nRow )
          endif

        endif
      endif
    next

    oExcel:Quit()

//  next
    filew ->( dbSkip())
    drgServiceThread:progressInc()

  enddo

  drgServiceThread:progressEnd()
  filew ->( Ads_ClearAOF())

  kusovi ->(dbGoTop())
  do while .not. kusovi ->(Eof())

    kusovw ->( dbAppend())
    kusovw ->cSubje     := ''

    if typKusov = 'Z'
      do case
      case vyrzak ->ctypzak = 'EK'
//      case vyrzak ->ctypzak = 'EK' .and. vyrzak ->nmnozplano = 1
        kusovw ->cCisZakaz  := kusovi ->cCisZakaz + '/1'
        nvicekusov := 1
      otherwise
       kusovw ->cCisZakaz  := kusovi ->cCisZakaz
      endcase
    endif

    VyrPolExist( AllTrim(kusovi ->cVysPol) )
    kusovw ->cVysPol    := kusovi ->cVysPol

//    if .not. Empty( kusovi ->cNizPol)
    if (AllTrim( kusovi ->cNizPol) <> '-' .or. .not. Empty( kusovi ->cNizPol))
      if AllTrim( kusovi ->cSklPol) <> '-' .and. .not. Empty( kusovi ->cSklPol)
        VyrPolExist( AllTrim(kusovi ->cNizPol) )
      endif
      kusovw ->cNizPol    := kusovi ->cNizPol
      kusovw ->nNizVar    := 1
    endif

//    if .not. Empty( kusovi ->cSklPol) .or. AllTrim( kusovi ->cSklPol) <> '-'
    if AllTrim( kusovi ->cSklPol) <> '-' .or. .not. Empty( kusovi ->cSklPol)
      SklPolExist( , AllTrim(kusovi ->cSklPol))
      kusovw ->cSklPol := kusovi ->cSklPol
    endif

    kusovw ->nPozice    := kusovi ->nPozice
    kusovw ->nVarPoz    := 1
    kusovw ->dPlaOd     := kusovi ->dPlaOd
//          kusovi ->dPlaDo     :=
//          kusovi ->nCiMno     :=
    kusovw ->nCiMnoVyk  := kusovi ->nCiMnoVyk
    kusovw ->nSpMno     := kusovi ->nSpMno
    kusovw ->cZkratJedn := kusovi ->cZkratJedn
    kusovw ->cMjTpv     := kusovi ->cMjTpv
    kusovw ->cMjSpo     := kusovi ->cMjSpo
//          kusovi ->cKodPoz    :=
//          kusovi ->nCisOper   :=
//          kusovi ->nUkonOper  :=
//          kusovi ->nVarOper   :=
    kusovw ->nRozmA     := kusovi ->nRozmA
    kusovw ->nRozmB     := kusovi ->nRozmB
//          kusovi ->nKusRoz    :=
//          kusovi ->nKusPod    :=
//          kusovi ->nKusRoz    :=
//          kusovi ->nNavysPRC  :=
//          kusovi ->cStav      :=
//          kusovi ->dZapis     :=
//          kusovi ->cZapis     :=
//          kusovi ->dZmenaT    :=
//          kusovi ->cZmenaT    :=
//          kusovi ->dZmenaK    :=
//          kusovi ->cZmenaK    :=
//          kusovi ->cCislObInt :=
//          kusovi ->nCislPolOb :=
//    kusovw ->cText1     :=  kusovi ->cText1
//    kusovw ->cText2     :=  kusovi ->cText2
//          kusovi ->nMnZadVAvp :=
//          kusovi ->mKusov     :=
//          kusovi ->nPridUp    :=
    kusovw ->nVahaMJ    :=  kusovi ->nVahaMJ

//          kusovi ->nSpMnSklHR :=
//          kusovi ->nSpMnSklCI :=
//          kusovi ->cIndexPoz  :=

//          kusovi ->cSklOdp_1  :=
//          kusovi ->cPolOdp_1  :=
//          kusovi ->cNazOdp_1  :=
//          kusovi ->nProcOdp_1 :=
//          kusovi ->nMnozOdp_1 :=
//          kusovi ->cSklOdp_2  :=
//          kusovi ->cPolOdp_2  :=
//          kusovi ->cNazOdp_2  :=
//          kusovi ->nProcOdp_2 :=
//          kusovi ->nMnozOdp_2 :=

//          kusovi ->nCenMAT_MJ :=

//          kusovi ->dVznikZazn :=
//          kusovi ->dZmenaZazn :=
//          kusovi ->mUserZmenR :=

    kusovi ->(dbSkip())
  enddo

  kusovw ->( dbCommit())
  kusovw ->( dbGoTop())

  do while .not. kusovw ->( Eof())
    newrec :=  .not. kusovj ->( dbSeek( UPPER(kusovw->cCisZakaz) +       ;
                                        UPPER(kusovw->cVysPol) +       ;
                                         STRZERO(kusovw->nPozice,3) +  ;
                                          STRZERO(kusovw ->nVarPoz,3),,'KUSOV1'))
    if( .not. newrec, kusovj ->( dbRlock()), nil)
    mh_copyfld( 'kusovw', 'kusovj', newrec)
    kusovj ->( dbUnLock())
    kusovw ->( dbSkip())
  enddo

  MsgBox( "Import kusovníkù skonèil" )

Return( nil)


Static Function DoplnKusov( oShe,nR )
          if( .not. Empty(oShe:Cells(nR,1):Value), kusovi ->nPozice   := oShe:Cells(nR,1):Value, nil)
          kusovi ->nVarPoz    := 1
          if( .not. Empty(oShe:Cells(2,7):Value),  kusovi ->dPlaOd    := oShe:Cells(   2,7):Value, nil)
//          kusovi ->dPlaDo     :=
//          kusovi ->nCiMno     :=
          if( .not. Empty(oShe:Cells(nR,2):Value), kusovi ->nCiMno    := oShe:Cells(nR,2):Value, nil )
          if( .not. Empty(oShe:Cells(nR,2):Value), kusovi ->nCiMnoVyk := oShe:Cells(nR,2):Value, nil )
          if( .not. Empty(oShe:Cells(nR,2):Value), kusovi ->nSpMno    := oShe:Cells(nR,2):Value, nil )
//          kusovi ->nSpMno     :=
//          kusovi ->cZkratJedn :=
          if( .not. Empty(oShe:Cells(nR,3):Value), kusovi ->cMjTpv    := oShe:Cells(nR,3):Value, nil )
//          if( .not. Empty(oSheet:Cells(nRow,3):Value), kusovi ->cMjSpo    := oSheet:Cells(nRow,3):Value, nil )
//          kusovi ->cMjTpv     :=
//          kusovi ->cMjSpo     :=
//          kusovi ->cKodPoz    :=
//          kusovi ->nCisOper   :=
//          kusovi ->nUkonOper  :=
//          kusovi ->nVarOper   :=
          if .not. Empty(oShe:Cells(nR,8):Value)
            do case
            case ValType(oShe:Cells(nR,8):Value) = 'N'
              kusovi ->nRozmA  := oShe:Cells(nR,8):Value
            otherwise
              kusovi ->nRozmA  := Val( oShe:Cells(nR,8):Value)
            endcase
          endif

          if .not. Empty(oShe:Cells(nR,9):Value)
            do case
            case ValType(oShe:Cells(nR,9):Value) = 'N'
              kusovi ->nRozmB  := oShe:Cells(nR,9):Value
            otherwise
              kusovi ->nRozmB  := Val( oShe:Cells(nR,9):Value)
            endcase
          endif

//          kusovi ->nKusRoz    :=
//          kusovi ->nKusPod    :=
//          kusovi ->nKusRoz    :=
//          kusovi ->nNavysPRC  :=
//          kusovi ->cStav      :=
//          kusovi ->dZapis     :=
//          kusovi ->cZapis     :=
//          kusovi ->dZmenaT    :=
//          kusovi ->cZmenaT    :=
//          kusovi ->dZmenaK    :=
//          kusovi ->cZmenaK    :=
//          kusovi ->cCislObInt :=
//          kusovi ->nCislPolOb :=
          if( .not. Empty(oShe:Cells(  2, 4):Value), kusovi ->cText1 := oShe:Cells(   2, 4):Value, nil)
          if( .not. Empty(oShe:Cells( nR,11):Value), kusovi ->cText2 := oShe:Cells(nR,11):Value, nil)
//          kusovi ->nMnZadVAvp :=
//          kusovi ->mKusov     :=
//          kusovi ->nPridUp    :=

          if .not. Empty(oShe:Cells(nR,13):Value)
            do case
            case ValType(oShe:Cells(nR,13):Value) = 'N'
              kusovi ->nVahaMJ  := oShe:Cells(nR,13):Value
            otherwise
              kusovi ->nVahaMJ  := Val( oShe:Cells(nR,13):Value)
            endcase
          endif
//          kusovi ->nSpMnSklHR :=
//          kusovi ->nSpMnSklCI :=
//          kusovi ->cIndexPoz  :=

//          kusovi ->cSklOdp_1  :=
//          kusovi ->cPolOdp_1  :=
//          kusovi ->cNazOdp_1  :=
//          kusovi ->nProcOdp_1 :=
//          kusovi ->nMnozOdp_1 :=
//          kusovi ->cSklOdp_2  :=
//          kusovi ->cPolOdp_2  :=
//          kusovi ->cNazOdp_2  :=
//          kusovi ->nProcOdp_2 :=
//          kusovi ->nMnozOdp_2 :=

//          kusovi ->nCenMAT_MJ :=

//          kusovi ->dVznikZazn :=
//          kusovi ->dZmenaZazn :=
//          kusovi ->mUserZmenR :=

//            if Len( AllTrim(kusovi ->cSklPol)) = 1
//              if left(AllTrim(kusovi ->cSklPol),1) = '-'
//                kusovi ->cSklPol := ''
//              endif
//            endif

Return(nil)

Static Function VyrPolExist( vykres )
//  local

  if .not. vyrpoli ->( dbSeek( Upper(vykres),,'VYRPOL3'))
    vyrpoli ->( dbAppend())

    vyrpoli ->cSubje      := ''
//    vyrpol ->nZakazVP    :=
    vyrpoli ->cCisZakaz   := kusovi ->cCisZakaz
    vyrpoli ->cVyrPol     := vykres
    vyrpoli ->nVarCis     := 1
    vyrpoli ->cVarPop     := ''

    SklPolExist('100',vykres)
    vyrpoli ->cCisSklad   := cenzbozi->ccissklad
    vyrpoli ->cSklPol     := cenzbozi->csklpol

//    vyrpol ->cNazPol2    :=
    vyrpoli ->cTypPol     := if( At('0K', vykres) > 0, 'V', 'PS')
    vyrpoli ->cSkuPol     := ''
    vyrpoli ->cNazev      := kusovi ->cText1
    vyrpoli ->cZkratJEDN  := 'Ks'
    vyrpoli ->cStrVyr     := ''
    vyrpoli ->cStrOdv     := ''

    VykPolExist(vykres)
    vyrpoli ->cCisVyk     := vykres

//    vyrpol ->nEkDav      :=
//    vyrpol ->nCisHm      :=
//    vyrpol ->cStav       :=
//    vyrpol ->cStavRV     :=
//    vyrpol ->nKusyPas    :=
//    vyrpol ->nStrizPl    :=
//    vyrpol ->nMnZadVA    :=
//    vyrpol ->nMnZadVK    :=
//    vyrpol ->cVysPol     :=
//    vyrpol ->cNizPol     :=
//    vyrpol ->mPopisVP    :=
//    vyrpol ->cZmenaK     :=
//    vyrpol ->dZmenaK     :=
//    vyrpol ->cZmenaT     :=
//    vyrpol ->dZmenaT     :=
//    vyrpol ->cZapis      :=
//    vyrpol ->dZapis      :=
//    vyrpol ->nStavKalk   :=
    vyrpoli ->lExistKUS   := .t.
//    vyrpol ->lExistOPE   :=
//    vyrpol ->nCisNabVys  :=
//    vyrpol ->nIntCount   :=
//    vyrpol ->cNazVyk     :=
//    vyrpol ->dVznikZazn  :=
//    vyrpol ->dZmenaZazn  :=
//    vyrpol ->mUserZmenR  :=
  else
//    vyrpoli ->cNazev      := kusovi ->cText1
  endif
  vyrpoli ->( dbCommit())
return( nil )


Static Function SklPolExist( sklad,polozka )
  local key, tag

  if Empty( sklad)
    key := Upper(polozka)
    tag := 'CENIK01'
  else
    key := Upper(Padr(sklad,8))+Upper(polozka)
    tag := 'CENIK12'
  endif

  if .not. cenzbozi ->( dbSeek( key,,tag))
    cenzbozi ->( dbAppend())

    cenzbozi ->CCISSKLAD  := sklad
    cenzbozi ->CSKLPOL    := polozka
//    cenzboz ->NKLICNAZ   :=
//    cenzboz ->NZBOZIKAT  :=
//    cenzboz ->NUCETSKUP  :=
//    cenzboz ->CUCETSKUP  :=
    cenzbozi ->CNAZZBO    :=  kusovi ->cText1
//    cenzboz ->CNAZZBO2   :=
    cenzbozi ->CTYPSKLPOL := 'X'
//    cenzboz ->CKATCZBO   :=
//    cenzboz ->CJKPOV     :=
//    cenzboz ->CDANPZBO   :=
    cenzbozi ->CZKRATJEDN := 'Ks'
//    cenzboz ->NKLICDPH   :=
    cenzbozi ->CZKRATMENY := 'CZK'
    cenzbozi ->CZAHRMENA  := 'CZK'
    cenzbozi ->lAktivni   := .t.
  endif

  cenzbozi ->( dbCommit())
return( nil)


Static Function VykPolExist( vykres )

  if .not. vykresyi ->( dbSeek( Upper(vykres),,'VYKRES3'))
    vykresyi ->( dbAppend())

    vykresyi ->cSubje      := ''
//    vykresy ->nPorVyk     :=
    vykresyi ->cCisVyk     := vykres
//    vykresy ->cModVyk     :=
    vykresyi ->cNazVyk     := kusovi ->cText1
//    vykresy ->cTypVyk     :=
//    vykresy ->cAutor      :=
//    vykresy ->cStred      :=
//    vykresy ->lVyhISO     :=
//    vykresy ->cVypujKdo   :=
//    vykresy ->dVypujDat   :=
//    vykresy ->mPopisVyk   :=
//    vykresy ->dVznikZazn  :=
//    vykresy ->dZmenaZazn  :=
//    vykresy ->mUserZmenR  :=
  endif

  vykresyi ->( dbCommit())
return( nil)

/*
** pøesunuto do spleèného PRG sys_komunikace_dll
Function FileInDirs( path,file,tmpw)
  local  adir, afile, atmp
  local  n := 0
  local  csel

  DEFAULT tmpw TO .F.

  adir := afile := atmp := {}
  adir := dir1( path)

  for n:= 1 to Len( aDir)
    atmp := Directory( aDir[n] +AllTrim(file))
    aEval( atmp, { |X| AAdd( afile, {X[1],aDir[n]})})
  next

  if tmpw
    drgDBMS:open('filew',.t.,.t.,drgINI:dir_USERfitm,,,.t.) ; ZAP
    filew->( OrdSetFocus('FILEw05'))

    for n := 1 to Len( afile)
      csel := Upper( Left( afile[n,1],1))

      if ( csel = 'Z' .or. csel = 'S' .or. csel = 'K') .and.                        ;
          SubStr( afile[n,1],7,1) = '-'
        filew ->( dbAppend())
        filew ->file      :=  Left( afile[n,1], RAt('.',afile[n,1])-1 )
        filew ->path      :=  afile[n,2]
        filew ->ext       :=  SubStr(afile[n,1], RAt('.',afile[n,1])+1 )
        filew ->file_ext  :=  afile[n,1]
        filew ->path_file :=  afile[n,2]+afile[n,1]
        filew ->select    :=  1
      endif
    next
  endif

return( afile)



Function Dir1( path)
  local  adir, afile, atmp
  local  n

  adir := afile := atmp := {}

  AAdd(afile, path)
  adir := Directory( path,'D')

  for n := 1 to len( adir)
    if adir[n,5] = 'D' .and. Left(adir[n,1],1) <> '.'
      atmp  := Dir2( path +adir[n,1]+'\')
      aEval(atmp,{|X| AAdd( afile,X)})
    endif
  next

return( afile)


Function Dir2( path)
  local  adir, afile, atmp
  local  n

  adir := afile := atmp := {}

  AAdd(afile, path)
  adir := Directory( path,'D')

  for n := 1 to len( adir)
    if adir[n,5] = 'D' .and. Left(adir[n,1],1) <> '.'
      atmp  := Dir1( path +adir[n,1]+'\')
      aEval(atmp,{|X| AAdd( afile,X)})
    endif
  next

return( afile)
*/



** výbìr souborù pro pøevzetí do inportu
** CLASS for SYS_komunikace_vyr_SEL ********************************************
CLASS SYS_komunikace_vyr_SEL FROM drgUsrClass
EXPORTED:

  inline access assign method is_select() var is_select
    return if( filew->select = 1, MIS_CHECK_BMP, 0)

  inline method importKusov(parent)
    ImpKusov()
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    return self

  inline method stornoImport(parent)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    return self


  inline method init(parent)
    ::drgUsrClass:init(parent)
    return self

  inline method drgDialogStart(drgDialog)
    local  ocolumn

    ::obro := drgDialog:dialogCtrl:oBrowse[1]

    ocolumn := ::obro:oxbp:getColumn(1)
    ocolumn:heading:tooltipText := 'pøepni - (ALT +CTRL/LButton)'
    return self

  inline method getForm()
    local drgFC := drgFormContainer():new()

    DRGFORM INTO drgFC SIZE 82,13 DTYPE '10' TITLE 'Komunikace - výbìr' ;
                                  GUILOOK 'All:n,Border:Y,Action:Y'     ;


* Browser definition
    DRGDBROWSE INTO drgFC FPOS 0.5,0.057 SIZE 80,13 FILE 'filew'     ;
         FIELDS 'M->is_select::2.6::2,'                            + ;
                'file:soubor:20,'                                  + ;
                'path:cesta k souboru'                               ;
         SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'n'

    DRGAction INTO drgFC CAPTION '~Import'      EVENT 'importKusov'    TIPTEXT 'Import kusovníkových vazeb'
    DRGAction INTO drgFC CAPTION '~Storno'      EVENT 'stornoImport'   TIPTEXT 'Storno importu'

    return drgFC

  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    do case
    case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
      ::setOperand()
      return .t.

    case (nEvent = xbeP_Keyboard)
      if mp1 = xbeK_ALT_ENTER
        ::setOperand()
        return .t.
      endif
    otherwise
      return .f.
    endcase
    RETURN .f.

HIDDEN:
  VAR  oBro

  inline method setOperand()
     local  select := Filew->select

     if( .not. Filew->(eof()))
       Filew->select := if( select = 1, 0, 1)
       ::oBro:oxbp:refreshCurrent()
     endif
     return self
ENDCLASS