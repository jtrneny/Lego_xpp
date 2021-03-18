#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"
#include "..\A_main\WinApi_.ch"

#include "Fileio.ch"

#include "..\A_main\WinApi_.ch"

#include "activex.ch"
#include "excel.ch"

#pragma Library( "XppUI2.LIB" )
#pragma Library( "Ot4xb.LIB" )
#pragma Library( "ASINet10.lib")
#pragma Library( "HrfClass.lib" )


   #define BUFFER_SIZE  2^16

*
** CLASS for FIN_c_bankuc ******************************************************
CLASS HIM_servisCtrlPrep_IN FROM drgUsrClass, drgServiceThread
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  method  postValidate
  method  start
  method  ctrlImpHim
  method  ctrlImpPoz
  method  ctrlImpTmp

  var  obdobi, fileexp
  var  ctrlImpHim
  var  ctrlImpPoz
  var  ctrlImpTmp
/*
  * bro col for c_bankuc
  inline access assign method isMain_uc() var isMain_uc
    return if( c_bankuc->lisMain, 300, 0)


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = xbeBRW_ItemMarked)
     ::dm:refresh()

    case(nevent = drgEVENT_FORMDRAWN)
      if ::lsearch
        postAppEvent(xbeP_Keyboard,xbeK_LEFT,,::brow:oxbp)
        return .t.
      else
        return .f.
      endif

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        ::drgDialog:cargo := &(oXbp:cargo:arDef[1,2])
        return .t.
      endif

    endcase
  return .f.
*/

HIDDEN:
  var    msg, dm, dc, df
  *
ENDCLASS


method HIM_servisCtrlPrep_IN:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
 ::drgUsrClass:init(parent)

// ::obdobi := '  /  '
// ::fileexp := Padr( AllTrim(SysCONFIG('System:cPathExp'))+'\FakVysH.DBf', 100)

  ::ctrlImpHim        := .f.
  ::ctrlImpPoz        := .f.
  ::ctrlImpTmp        := .f.

//  drgDBMS:open('FakVysHD')
//  drgDBMS:open('FakVysHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP

return self


method HIM_servisCtrlPrep_IN:drgDialogInit(drgDialog)

return self


method HIM_servisCtrlPrep_IN:drgDialogStart(drgDialog)

  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form

return


method HIM_servisCtrlPrep_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  ::dataManager:save()
  ::dataManager:refresh()

return .t.


method HIM_servisCtrlPrep_IN:postLastField(drgVar)
return .t.


method HIM_servisCtrlPrep_IN:start(drgVar)
  local  lok, cx

  lok := ::ctrlImpHim

  if( ::ctrlImpHim,      ::ctrlImpHim(), nil)
  if( ::ctrlImpPoz,      ::ctrlImpPoz(), nil)
  if( ::ctrlImpTmp,      ::ctrlImpTmp(), nil)

  if( lok, drgMsgBox( "Pøepoèty byly dokonèeny"), nil)

return .t.

method HIM_servisCtrlPrep_IN:ctrlImpHim(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok
  local  in_dir, cpath
  local  cc, celkem
  LOCAL  HIM,DIS
  local  aTechZh  := {}
  local  aVypocet := {}

///   agrikol vynulování 30

//  rok := 2016
  cc  := 'Kde jsou importované data ?'

  drgDBMS:open( 'maj',.t.,,,,'maja')
  drgDBMS:open( 'c_danskp')

  in_Dir := BrowseForFolder( , cc, BIF_USENEWUI )

  if .not. empty(in_Dir)
    cpath := RetDir( in_Dir)
  else
    return .f.
  endif

//  cfiltr := Format("ctyppohybu = '%%' and cobdobi = '09/16'", {'17'})
//  pvpitema->(ads_setaof(cfiltr), dbGoTop())

  drgMsgBox( "Start pøepoètu")

  if drgIsYESNO(drgNLS:msg('Zrušit pøedchozí data v MAJ.ADT ?'))
    maja->( dbZap())
  endif

  cx := cpath + 'TechZh.dbf'
  dbUseArea( .T.,'FOXCDX',cX,'techzh',.F.)
  techzh->( dbGoTop())
  do while .not. techzh->( Eof())
    if ( n := aScan( aTechZh, {|x| x[1]=techzh->inv_cislo})) <> 0
      aTechZh[n,2] += techzh->castka
    else
      AAdd( aTechZh,{techzh->inv_cislo, techzh->castka })
    endif
    techzh->( dbSkip())
  enddo


  cx := cpath + 'Vypocet.dbf'
  dbUseArea( .T.,'FOXCDX',cX,'Vypocet',.F.)
  vypocet->( dbGoTop())
  do while .not. vypocet->( Eof())
    AAdd(aVypocet,{vypocet->inv_cislo,vypocet->vstup_cena,vypocet->umesod,vypocet->uopr_cel})
    vypocet->( dbSkip())
  enddo

  cx := cpath + 'Kmen.dbf'
  dbUseArea( .T.,'FOXCDX',cX,'kmen',.F.)

  do while .not. kmen->( Eof())
    celkem := 0
    maja->( dbAppend())

    maja->NINVCIS      := Val(kmen->inv_cislo)

    do case
    case kmen->i_ucet = "022020"
      maja->NTYPMAJ      := 51
      maja->CUCETSKUP    := '51'

    otherwise
      maja->NTYPMAJ      := Val(Substr(kmen->i_ucet,2,2))
      maja->CUCETSKUP    := Substr(kmen->i_ucet,2,2)

    endcase

    maja->LHMOTNYIM    := .t.
//    maja->CTYPSKP
    maja->cTypCZCPA    := kmen->skp
    maja->CODPISKD     := if(Empty(kmen->dodp_skup), '31',Upper(kmen->dodp_skup))
    maja->NODPISKD     := Val(maja->CODPISKD)
    maja->NTYPDODPI    := kmen->dtyp_odp
//    maja->NMESODPID

    if c_danskp->( dbSeek( Upper(kmen->dodp_skup),,'C_DANSKP1'))
      maja->NROKYODPID := c_danskp->NROKYODPIS
    endif
    maja->NODPISK    := maja->NROKYODPID
    maja->CODPISK    := Alltrim(Str(maja->NROKYODPID))

    maja->NTYPUODPI    := 3
//    maja->NMESODPIUZ
    maja->NTYPVYPUO    := 1
    maja->CNAZEV       := kmen->nazev_zp
//    maja->NTROBOR
    maja->NDOKLAD     := kmen->adoklad
    maja->NDRPOHYB    := kmen->apohyb
    maja->CTYPPOHYBU  := Str(kmen->apohyb)
    maja->DDATPOR     := kmen->d_zarazeni
    maja->DDATZAR     := kmen->d_uzivani
    maja->COBDZAR     := mh_OBD_MM_YY( kmen->d_uzivani)
    maja->DDATVYRAZ   := kmen->d_vyrazeni
//    maja->COBDVYRAZ
    maja->DDATZVYS    := kmen->cd_zauc
    if .not. Empty(kmen->cd_zauc)
      maja->COBDZVYS   := mh_OBD_MM_YY( kmen->cd_zauc)
      maja->NROKZVDANO := Int( ( CTOD( '31.12.2016') - kmen->cd_zauc) / 365 )
    endif

//    maja->NROKYDANOD
//    maja->NROKZVDANO
    maja->NKUSY        := 1
//    maja->NMNOZSTVI    := 1
//    maja->CZKRATJEDN   := 'Ks'

    if ( n := aScan( aVypocet, {|x| x[1]=kmen->inv_cislo})) <> 0
      maja->NCENAVSTU  := aVypocet[n,2]
      maja->NUCTODPMES := aVypocet[n,3]
      maja->NOPRUCT    := aVypocet[n,4]

    else
      maja->NCENAVSTU  := kmen->vstup_cena
      maja->NUCTODPMES := kmen->umesod
      maja->NOPRUCT    := kmen->uopr_cel
    endif


    maja->NCENAVSTD    := maja->NCENAVSTU
    maja->NOPRDAN      := kmen->dopr_cel
    maja->NOPRUCTPS    := kmen->uopr_zacr
    maja->NOPRDANPS    := kmen->dopr_zacr
    maja->NDOTACEUCT   := 0
    maja->NDOTACEDAN   := 0
    maja->NCENAPORU    := maja->NCENAVSTU
    maja->NCENAPORD    := maja->NCENAVSTU
    maja->NPROCDANOD   := kmen->dsazba
//    maja->NHODNDANOD
    maja->NDANODPROK   := kmen->dodpis_r
    maja->NPROCUCTOD   := kmen->usazba
    maja->NUCTODPROK   := kmen->uodpis_r
    maja->NROKYODPIU   := maja->NROKYODPID
//    maja->NPOCMESUO
//    maja->NPOCMESUOZ
//    maja->NPOCMESDO
//    maja->NUPLPROC
//    maja->NUPLHODN
    maja->NROKUPL      := kmen->uzn10rok
//    maja->CKLICODMIS
    maja->CKLICSKMIS   := kmen->tumisteni
    maja->CVYRCISIM    := kmen->tvyr_cislo
//    maja->DDATREVIM
//    maja->COBDPOSODP
    maja->CNAZPOL1     := AllTrim(Str(kmen->stredisko))
//    maja->CNAZPOL2
//    maja->CNAZPOL3
//    maja->CNAZPOL4
//    maja->CNAZPOL5
//    maja->CNAZPOL6
    maja->MPOPIS       := kmen->poznamka
//    maja->CKODKLAS
//    maja->CCELEK
//    maja->CVYKRES
//    maja->CUMISTENI
//    maja->CVARSYM
//    maja->NCISFAK
//    maja->NZPUODPIS
//    maja->LPOZDANODP
*
//    maja->CKATUZEMI
//    maja->CCISPARC
    maja->NROZLPARC   := Val(kmen->tplocha)
*
    maja->NZNAKT      := If( maja->NCENAVSTU = maja->NOPRUCT, 2, 0)
    maja->NZNAKTD     := If( maja->NCENAVSTU = maja->NOPRUCT, 2, 0)

    if maja->NCENAVSTU <> maja->NOPRUCT
      maja->cobdposodp := '12/16'
    endif

//    maja->mPoznamka

    kmen->( dbSkip())
  enddo

  drgMsgBox( "Konec pøepoètu")

return .t.



method HIM_servisCtrlPrep_IN:ctrlImpPoz(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok
  local  in_dir, cpath
  local  cc, celkem
  LOCAL  HIM,DIS
  local  aTechZh  := {}
  local  aVypocet := {}

  local  oBook, oSheet
  local  nRow, nCol, contRows, n
  local  oThread
  local  oExcel
  local  aDok := {}
  local  aDokAdr := {}
  local  aDokUct := {}
  local  aRow := {}
  local  aStructure
  local  cRadek

  local cBuffer
  local nBytes, nTarget
  local lView
  local oFrm

///   agrikol vynulování 30

//  rok := 2016
  lView := .t.
  cc    := 'Kde jsou importované data ?'

  drgDBMS:open( 'pozemky',.t.,,,,'pozemkya')
  drgDBMS:open( 'c_danskp')

  in_Dir := BrowseForFolder( , cc, BIF_USENEWUI )

  if .not. empty(in_Dir)
    cpath := RetDir( in_Dir)
  else
    return .f.
  endif

//  cfiltr := Format("ctyppohybu = '%%' and cobdobi = '09/16'", {'17'})
//  pvpitema->(ads_setaof(cfiltr), dbGoTop())

  drgMsgBox( "Start pøepoètu")

  if drgIsYESNO(drgNLS:msg('Zrušit pøedchozí data v POZEMKY.ADT ?'))
    pozemkya->( dbZap())
  endif

*  inicializace vazby na excel
  oExcel := CreateObject("Excel.Application")
  if Empty( oExcel )
    if( lview, MsgBox( "Excel nemáte nainstalovaný na poèítaèi" ), nil)
    return 0
  endif

  SET CHARSET TO ansi

  oBook    := oExcel:workbooks:Open( cpath +'pozemky.xlsx')
  oSheet   := oBook:ActiveSheet
  contRows := oSheet:usedRange:Rows:Count+1
  //    contRows    := oWorkBook:workSheets(1):usedRange:Rows:Count
  oFrm := self:drgDialog

  for nRow := 2 to 3183
    drgMsg( drgNLS:msg("Pøevádím záznam: " + Str(nRow, 6,0) +'/'+Str(contRows, 6,0)),1, oFrm )
    drgDump( Str(nrow) +CRLF)
    pozemkya->( dbAppend())

    pozemkya->nDruhPozem  := 0                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)

    if ValType(oSheet:Cells(nRow,8):Value) = 'C'
      do case
      case At('orná', oSheet:Cells(nRow,8):Value ) > 0
        pozemkya->nDruhPozem  := 2                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
      case At('Orná', oSheet:Cells(nRow,8):Value ) > 0
        pozemkya->nDruhPozem  := 2                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
      case At('osta', oSheet:Cells(nRow,8):Value ) > 0
        pozemkya->nDruhPozem  := 14                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
      case At('man', oSheet:Cells(nRow,8):Value ) > 0
        pozemkya->nDruhPozem  := 14                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
      case At('vodní', oSheet:Cells(nRow,8):Value ) > 0
        pozemkya->nDruhPozem  := 11                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
      case At('parcela', oSheet:Cells(nRow,8):Value ) > 0
        pozemkya->nDruhPozem  := 13                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
      case At('zast', oSheet:Cells(nRow,8):Value ) > 0
        pozemkya->nDruhPozem  := 13                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
      case At('les', oSheet:Cells(nRow,8):Value ) > 0
        pozemkya->nDruhPozem  := 10                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
      case At('ovoc', oSheet:Cells(nRow,8):Value ) > 0
        pozemkya->nDruhPozem  := 6                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
      case At('zahr', oSheet:Cells(nRow,8):Value ) > 0
        pozemkya->nDruhPozem  := 5                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
      case At('trav', oSheet:Cells(nRow,8):Value ) > 0
        pozemkya->nDruhPozem  := 8                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
  //    case At('orná', oSheet:Cells(nRow,8):Value ) > 0
  //      pozemkya->nDruhPozem  := 0                                     //    (Druh pozemku)                    CAPTION(DruhPozem)     FTYPE(n) FLEN( 3) DEC( 0)  RELATETO(C_POZEM) RELATETYPE(1)
      endcase
    endif

    pozemkya->nPozemek    := nRow - 1                                   //    (Èíslo pozemku)                   CAPTION(ÈísloPozem)    FTYPE(n) FLEN(10) DEC( 0)
    pozemkya->cPozemek    := ''                                    //    (Oznaèení pozemku)                CAPTION(OznPozem)      FTYPE(c) FLEN(10) DEC( 0)
    pozemkya->cNazPozem   := oSheet:Cells(nRow,8):Value                                    //    (Název pozemku)                   CAPTION(NázPozem)      FTYPE(c) FLEN(50) DEC( 0)
*
    pozemkya->nListVlast  := oSheet:Cells(nRow,1):Value                                    //    (List vlastnictví - LV)           CAPTION(LV)            FTYPE(n) FLEN(12) DEC( 0)
    pozemkya->cParcCis    := if( Valtype(oSheet:Cells(nRow,2):Value) = 'N', AllTrim(Str(oSheet:Cells(nRow,2):Value,10,0)), oSheet:Cells(nRow,2):Value)                                     //    (Parcelní èíslo)                  CAPTION(ParcÈís)       FTYPE(c) FLEN(20) DEC( 0)
    pozemkya->nParcCis1   := if( Valtype(oSheet:Cells(nRow,3):Value) = 'C', Val(oSheet:Cells(nRow,3):Value), oSheet:Cells(nRow,3):Value)                                    //    (Parcelní èíslo-pøed lomítkem)    CAPTION(ParcÈís1)      FTYPE(n) FLEN(15) DEC( 0)
    pozemkya->nParcCis2   := 0                                    //    (Parcelní èíslo-za lomítkem)      CAPTION(ParcÈís2)      FTYPE(n) FLEN( 5) DEC( 0)
    pozemkya->cParcCisP   := if( Valtype(oSheet:Cells(nRow,4):Value) = 'N', AllTrim(Str(oSheet:Cells(nRow,4):Value,10,0)), oSheet:Cells(nRow,4):Value)                                    //    (Parcelní èíslo-pùvodní)          CAPTION(ParcÈísP)      FTYPE(c) FLEN(20) DEC( 0)
*
    do case
    case Valtype(oSheet:Cells(nRow,9):Value) = 'N'
      pozemkya->nInvCIS := oSheet:Cells(nRow,9):Value
    case Valtype(oSheet:Cells(nRow,9):Value) = 'C'
      pozemkya->nInvCIS := Val(oSheet:Cells(nRow,9):Value)
    otherwise
      pozemkya->nInvCIS := 0
    endcase

//    pozemkya->nInvCIS     := if( Valtype(oSheet:Cells(nRow,9):Value) = 'N', oSheet:Cells(nRow,9):Value, Val(oSheet:Cells(nRow,9):Value))                                    //    (Inventární èíslo majetku)        CAPTION(InvÈíslo)      FTYPE(N) FLEN(15) DEC( 0)
*
    pozemkya->nPodil      := if( Valtype(oSheet:Cells(nRow,6):Value) = 'N', oSheet:Cells(nRow,6):Value,0)                                    //    (Podíl výmìry)                    CAPTION(PodilVým)      FTYPE(n) FLEN(10) DEC( 2)
    pozemkya->cPodil      := if( Valtype(oSheet:Cells(nRow,6):Value) = 'C', AllTrim(oSheet:Cells(nRow,6):Value),'')                                   //    (Podíl výmìry-zlomek)             CAPTION(PodVýmZl)      FTYPE(c) FLEN(10) DEC( 0)
*
    pozemkya->cNazPol1    := ''                                    //    (Støedisko pozemku)               CAPTION(støPozem)      FTYPE(c) FLEN( 8) DEC( 0) RELATETO(CNAZPOL1) RELATETYPE(2)
    pozemkya->cNazPol2    := ''                                    //    (Výrobek)                         CAPTION(Výkon)         FTYPE(c) FLEN( 8) DEC( 0) RELATETO(CNAZPOL2) RELATETYPE(2)
    pozemkya->cNazPol3    := ''                                    //    (Zakázka)                         CAPTION(Zakázka)       FTYPE(c) FLEN( 8) DEC( 0) RELATETO(CNAZPOL3) RELATETYPE(2)
    pozemkya->cNazPol4    := ''                                    //    (Výrobní místo)                   CAPTION(VýrMísto)      FTYPE(c) FLEN( 8) DEC( 0) RELATETO(CNAZPOL4) RELATETYPE(2)
    pozemkya->cNazPol5    := ''                                    //    (Stroj)                           CAPTION(Stroj)         FTYPE(c) FLEN( 8) DEC( 0) RELATETO(CNAZPOL5) RELATETYPE(2)
    pozemkya->cNazPol6    := ''                                    //    (Výrobní operace)                 CAPTION(VýrOper)       FTYPE(c) FLEN( 8) DEC( 0) RELATETO(CNAZPOL6) RELATETYPE(2)
*
    pozemkya->cUlice      := ''                                    //    (Bydlištì - Ulice)               CAPTION(BydlUlice)      FTYPE(c) FLEN(50) DEC( 0)
    pozemkya->cCisPopis   := ''                                    //    (Bydlištì - ÈísPopisné)          CAPTION(BydÈísPopi)     FTYPE(c) FLEN(10) DEC( 0)
    pozemkya->cCisOrien   := ''                                    //    (Bydlištì - ÈísOrientaèní)       CAPTION(BydÈísOrie)     FTYPE(c) FLEN(10) DEC( 0)
    pozemkya->cUlicCisla  := ''                                    //    (Bydlištì - Ulice+èísla)         CAPTION(BydlUlÈisl)     FTYPE(c) FLEN(65) DEC( 0)
    pozemkya->cObec       := ''                                    //    (Bydlištì - Obec)                CAPTION(BydlObec)       FTYPE(c) FLEN(50) DEC( 0)
    pozemkya->cUlicCiPop  := ''                                    //    (Bydlištì - Ulice+èísl.popisné)  CAPTION(BydlUlÈiPo)     FTYPE(c) FLEN(65) DEC( 0)
    pozemkya->cMisto      := ''                                    //    (Bydlištì - Místo)               CAPTION(BydlMisto)      FTYPE(c) FLEN(50) DEC( 0)
    pozemkya->cPsc        := ''                                    //    (Bydlištì - Psè)                 CAPTION(BydlPsc)        FTYPE(c) FLEN( 6) DEC( 0) RELATETO(C_PSC) RELATETYPE(2)
    pozemkya->cZkratStat  := ''                                    //    (Bydlištì - Stát)                CAPTION(BydlStat)       FTYPE(c) FLEN( 3) DEC( 0) RELATETO(C_STATY) RELATETYPE(2)
*
    pozemkya->nCisOsoby   := 0                                    //    (Èíslo osoby-vlastník)           CAPTION(ÈísOsobyVl)     FTYPE(n) FLEN( 6) DEC( 0)
    pozemkya->nCisOsobyP  := 0                                    //    (Èíslo osoby-pùvodní vlastník)   CAPTION(ÈísOsobyPùvVl)  FTYPE(n) FLEN( 6) DEC( 0)
    pozemkya->cOsoba      := ''                                    //    (Osoby - celé jméno)             CAPTION(CelJmOsoby)     FTYPE(c) FLEN(50) DEC( 0)
*
    pozemkya->nCisFirmy   := 0                                    //    (Èíslo firmy-vlastník)           CAPTION(ÈísFirmyVl)     FTYPE(n) FLEN( 5) DEC( 0)
    pozemkya->nCisFirmyP  := 0                                    //    (Èíslo firmy-pùvodní vlastník)   CAPTION(ÈísFirmyPùvVl)  FTYPE(n) FLEN( 5) DEC( 0)
    pozemkya->cNazev      := ''                                    //    (Název firmy)                    CAPTION(NázFirmy)       FTYPE(c) FLEN(100) DEC(0)
*
    pozemkya->cBPEJ       := ''                                    //    (Bonita pùdy)                    CAPTION(BydlPsc)        FTYPE(c) FLEN( 6) DEC( 0)
    pozemkya->nVymera_m2  := if( Valtype(oSheet:Cells(nRow,7):Value) = 'N',oSheet:Cells(nRow,7):Value, 99999999)                                    //    (Výmìra pozemku celkem v m2)     CAPTION(VýmìraPozM2)    FTYPE(n) FLEN(13) DEC( 2)
    pozemkya->nVymera_ha  := 0                                    //    (Výmìra pozemku celkem v ha)     CAPTION(VýmìraPozHa)    FTYPE(n) FLEN(13) DEC( 2)
    pozemkya->nPodVym_m2  := 0                                    //    (Podíl výmìry poz.celkem v m2)   CAPTION(PodVýmPozM2)    FTYPE(n) FLEN(13) DEC( 2)
    pozemkya->nPodVym_ha  := 0                                    //    (Podíl výmìry poz.celkem v ha)   CAPTION(PodVýmPozHa)    FTYPE(n) FLEN(13) DEC( 2)
*
    pozemkya->nCenaPoz    := oSheet:Cells(nRow,10):Value                                    //    (Cena pozemku)                   CAPTION(CenaPozem)      FTYPE(n) FLEN(13) DEC( 2)
    pozemkya->nDanNabPoz  := oSheet:Cells(nRow,11):Value                                    //    (Daò z nabití pozemku)           CAPTION(DaòNabPozem)    FTYPE(n) FLEN(13) DEC( 2)
    pozemkya->nCenaSDaNa  := oSheet:Cells(nRow,12):Value                                    //    (Cena s daní s nabití)           CAPTION(CenaSDanNab)    FTYPE(n) FLEN(13) DEC( 2)
    pozemkya->nCenaZaPod  := 0
    pozemkya->cKatastr    := oSheet:Cells(nRow,13):Value
    pozemkya->mPoznamka   := oSheet:Cells(nRow,14):Value
                                        //    (Cena za podíl na pozemku)       CAPTION(CenaZaPodíl)    FTYPE(n) FLEN(13) DEC( 2)
*
    nStavPozem           := 0                           //    (Stav pozemku)                   CAPTION(Stav pozemku)   FTYPE(n) FLEN( 2) DEC( 0)
    nNewLV               := 0                           //    (Nový list.vlast. LV)            CAPTION(NovéLV)         FTYPE(n) FLEN(15) DEC( 0)

//    xx := oSheet:Cells(nRow,5):Value
//    AAdd( aRow, xx)
//    xx := oSheet:Cells(nRow,7):Value
//    AAdd( aRow, xx)
//    xx := oSheet:Cells(nRow,8):Value
//    AAdd( aRow, xx)
//    xx := oSheet:Cells(nRow,12):Value
//    AAdd( aRow, xx)

//    AAdd( aDok, aRow)
  next

  oExcel:Quit()

  oExcel:Destroy()


  drgMsgBox( "Konec pøepoètu")

return .t.


method HIM_servisCtrlPrep_IN:ctrlImpTmp(drgVar)
  local  lok, cx, ckey
  local  n
  local  czlomek
  local  ncitatel, njmenovatel
  local  recFlt
  local  cFiltr
  local  rok
  local  in_dir, cpath
  local  cc, celkem
  LOCAL  HIM,DIS
  local  aTechZh  := {}
  local  aVypocet := {}

///   agrikol vynulování 30

//  rok := 2016

  drgDBMS:open( 'c_listvl',.t.,,,,'c_listvla')
  drgDBMS:open( 'pozemky',.t.,,,,'pozemkya' )
  drgDBMS:open( 'pozemkit',.t.,,,,'pozemkita' )

  drgMsgBox( "Start pøepoètu")

  if drgIsYESNO(drgNLS:msg('Zrušit pøedchozí data v C_LISTVL.ADT ?'))
    c_listvla->( dbZap())
    pozemkita->( dbZap())
  endif

  pozemkya->( OrdSetFocus('POZEMKY08'), dbGoTop())
  pozemkya->( dbGoTop())
  do while .not. pozemkya->( Eof())
    pozemkya->ctask := 'HIM'
    if .not. c_listvla->( dbSeek( Upper(pozemkya->cku_kod)+StrZero(pozemkya->nListVlast,12),,'C_LISTVL04'))
      mh_CopyFLD( 'pozemkya','c_listvla',.t.)
    endif
    pozemkya->( dbSkip())
  enddo

  pozemkya->( dbGoTop())
  do while .not. pozemkya->( Eof())
    pozemkya->cnazpol6 := ''
    do case
    case (pozemkya->npodil = 0 .and. pozemkya->cpodil = '') .or.   ;
         (pozemkya->npodil = 0 .and. pozemkya->cpodil = '1') .or. ;
            (pozemkya->npodil = 1 .and. pozemkya->cpodil = '')
      pozemkya->npodil := 1
      pozemkya->cpodil := '1'
    case (pozemkya->npodil = 0.5 .and. pozemkya->cpodil = '')
      pozemkya->cpodil := '1/2'

    case (pozemkya->npodil = 0.25 .and. pozemkya->cpodil = '')
      pozemkya->cpodil := '1/4'

    case (pozemkya->npodil = 0.01 .and. pozemkya->cpodil = '')
      pozemkya->cpodil := '1/10'

    otherwise
      if pozemkya->npodil = 0
        czlomek := AllTrim(pozemkya->cpodil)
        if (n := At('/',czlomek)) > 0
          ncitatel    := Val(SubStr(czlomek,1,n-1))
          njmenovatel := Val(SubStr(czlomek,n+1))
          pozemkya->npodil := ncitatel/njmenovatel
        endif
      endif
    endcase
    mh_CopyFLD( 'pozemkya','pozemkita',.t.)
    pozemkya->( dbSkip())
  enddo

  ckey := ''
  pozemkya->( dbGoTop())
  do while .not. pozemkya->( Eof())
    if ckey <> Upper(pozemkya->cku_Kod)+ StrZero(pozemkya->nListVlast,12)+Upper(pozemkya->cParcCis)
      ckey := Upper(pozemkya->cku_Kod)+ StrZero(pozemkya->nListVlast,12)+Upper(pozemkya->cParcCis)
      pozemkya->cnazpol6 := "D"
    endif
    pozemkya->( dbSkip())
  enddo


  pozemkya->( ADS_setAof( "cnazpol6 <> 'D'" ))
   pozemkya->( dbGoTop())
   do while .not. pozemkya->( Eof())
     pozemkya->( dbDelete())
     pozemkya->( dbSkip())
   enddo
  pozemkya->( ADS_ClearAof())

  pozemkita->( OrdSetFocus('POZEMKIT09'), dbGoTop())
  do while .not. pozemkita->( Eof())
    if pozemkya->( dbSeek( Upper(pozemkita->cku_kod)+StrZero(pozemkita->nListVlast,12)+Upper(pozemkita->cParcCis),,'POZEMKY08'))
      pozemkita->npozemek := pozemkya->npozemek
      pozemkita->npozemky := pozemkya->sid
    endif
    pozemkita->nPodVym_m2 := pozemkita->nVymera_m2 * pozemkita->npodil

    pozemkita->( dbSkip())
  enddo

  pozemkita->( dbGoTop())
  npoc   := 1
  ckey   := Upper(pozemkita->cku_Kod)+ StrZero(pozemkita->nListVlast,12)+Upper(pozemkita->cParcCis)
  celkem := 0

  do while .not. pozemkita->( Eof())
    if ckey <> Upper(pozemkita->cku_Kod)+ StrZero(pozemkita->nListVlast,12)+Upper(pozemkita->cParcCis)
      if pozemkya->( dbSeek( ckey,,'POZEMKY08'))
        pozemkya->nPodVym_m2 := celkem
      endif

      ckey := Upper(pozemkita->cku_Kod)+ StrZero(pozemkita->nListVlast,12)+Upper(pozemkita->cParcCis)
      npoc := 1
      celkem := 0
    endif

    celkem += pozemkita->nPodVym_m2
    pozemkita->npolozka := npoc

    npoc++
    pozemkita->( dbSkip())
  enddo

  if pozemkya->( dbSeek( ckey,,'POZEMKY08'))
    pozemkya->nPodVym_m2 := celkem
  endif


  drgMsgBox( "Konec pøepoètu")

return .t.