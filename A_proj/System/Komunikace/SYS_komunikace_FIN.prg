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
**   nemáme  #include "Xb2net.ch"

#include "..\A_main\WinApi_.ch"

#include "activex.ch"
#include "excel.ch"

#include "XbZ_Zip.ch"


#DEFINE  DBGETVAL(c)     Eval( &("{||" + c + "}"))

#pragma Library( "ASINet10.lib" )
**   nemáme #pragma  library ("xb2net.lib")

#xtranslate NTrim(<n>)        =>  LTrim(Str(<n>))

static oExcel
static sName, sNameExt



// Export souhrnné hlášení k výkazu DPH_2009 - formát XML
function DIST000001( oxbp ) // oxbp = drgDialog
  local tm
  local ctm
  local cx
  local nit, ny, cp, cj
  local file
  local nHandle
  local inDir

    ctm  := StrZero(dph_2009->nm,2) + StrZero(dph_2009->nrok,4)
    file := selFILE('DPHSHV_'+ctm,'Xml',,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

    if .not. Empty(file)
      nHandle := FCreate( file )
//      FAttr( file, "H" )
//      nHandle := FOpen( file, FO_READWRITE )

      ny := At( " ", dph_2009->csesjmeno)
      cp := AllTrim( SubStr( dph_2009->csesjmeno, 1, ny-1))
      cj := AllTrim( SubStr( dph_2009->csesjmeno, ny+1))

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
       cx += fVAR(AllTrim(Str(dph_2009->nM,2,0)))
      cx += ' pln_poc_celk='
       cx += fVAR("0")
      cx += ' poc_radku='
       cx += fVAR("0")
      cx += ' poc_stran='
       cx += fVAR("0")
      cx += ' rok='
       cx += fVAR(AllTrim(Str(dph_2009->nrok,4,0)))
      cx += ' shvies_forma='
       cx += fVAR("R")
      cx += ' suma_pln='
       cx += fVAR("0")
      cx += '/>'
       cx += CRLF
      FWrite( nHandle, cx)

      cx := '       <VetaP c_orient='
       cx += fVAR(AllTrim(dph_2009->ccp))
//      cx += ' c_pop='
//       cx += fVAR()
      cx += ' c_ufo='
       cx += fVAR( AllTrim(Str( SysConfig('System:nFINURKRAJ'),3,0)))
      cx += ' c_pracufo='
       cx += fVAR( AllTrim(Str( SysConfig('System:nFINURAD'),4,0)))
      cx += ' dic='
       cx += fVAR( SubStr(AllTrim(dph_2009->cdic),3))
//      cx += ' dodobchjm='
//       cx += fVAR()
//      cx += ' jmeno='
//       cx += fVAR()
      cx += ' naz_obce='
       cx += fVAR(AllTrim(dph_2009->cSidlo))
      cx += ' opr_jmeno='
       cx += fVAR(AllTrim(dph_2009->codposjmen))
      cx += ' opr_postaveni='
       cx += fVAR(AllTrim(dph_2009->codpospost))
      cx += ' opr_prijmeni='
       cx += fVAR(AllTrim(dph_2009->codposprij))
//      cx += ' prijmeni='
//       cx += fVAR()
      cx += ' psc='
       cx += fVAR(AllTrim(dph_2009->cpsc))
      cx += ' sest_jmeno='
       cx += fVAR(cj)
      cx += ' sest_prijmeni='
       cx += fVAR(cp)
      cx += ' sest_telef='
       cx += fVAR(AllTrim(StrTran(dph_2009->csestelef,' ','')))
//      cx += ' titul='
//       cx += fVAR()
      cx += ' typ_ds='
       cx += fVAR(AllTrim(SysConfig('System:cTYPDANSUB')))
      cx += ' ulice='
       cx += fVAR(AllTrim(dph_2009->cUlice))
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
       cx += fVAR(AllTrim(dph_2009->cpraosnaz))
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


return( nil)


// Export výkazu DPH_2009 - formát XML
function DIST000002( oxbp ) // oxbp = drgDialog
  local tm
  local ctm
  local cx
  local nit, ny, cp, cj
  local file
  local nHandle
  local inDir

    ctm  := StrZero(dph_2009->nm,2) + StrZero(dph_2009->nrok,4)
    file := selFILE('DPHDP2_'+ctm,'Xml',,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})
    if .not. Empty(file)
      nHandle := FCreate( file )
//      FAttr( file, "H" )
//      nHandle := FOpen( file, FO_READWRITE )

      ny := At( " ", dph_2009->csesjmeno)
      cp := AllTrim( SubStr( dph_2009->csesjmeno, 1, ny-1))
      cj := AllTrim( SubStr( dph_2009->csesjmeno, ny+1))

      cx := '<?xml version=' + fVAR("1.0")+ ' encoding=' +fVAR("windows-1250")+' standalone='+ fVAR("no")+'?>' + CRLF
//      cx := '<?xml version=' + fVAR("1.0")+ ' encoding=' +fVAR("UTF-8")+' standalone='+ fVAR("no")+'?>' + CRLF
      FWrite( nHandle, cx)

      cx := '<Pisemnost nazevSW='+fVAR("A++")+' verzeSW='+fVAR("1.04.4")+'>' + CRLF
      FWrite( nHandle, cx)
      cx := '  <DPHDP2 verzePis='+fVAR("01.02")+'>' + CRLF
      FWrite( nHandle, cx)

      cx := '       <VetaD'
       cx += ' c_okec='
        cx += fVAR(AllTrim( SysConfig('System:cKodOKEC')))

       if dph_2009->nq > 0
         cx += ' ctvrt='
          cx += fVAR(AllTrim(Str(dph_2009->nq)))
       endif

       cx += ' d_poddp='
        cx += fVAR(dtoc(Date()))
//       cx += ' d_zjist'
//        cx += fVAR( )
       cx += ' dapdph_forma='
        cx += fVAR( if(.not.empty(dph_2009->crp),'B',if(.not.empty(dph_2009->cop),'O';
                         ,'D')))
       cx += ' dokument='
        cx += fVAR('DP2' )
       cx += ' k_uladis='
        cx += fVAR('DPH')
       cx += ' kod_zo='
        cx += fVAR(AllTrim(dph_2009->czo))

       if dph_2009->nm > 0
         cx += ' mesic='
          cx += fVAR(AllTrim(Str(dph_2009->nm)))
       endif

       cx += ' rok='
        cx += fVAR(AllTrim(Str(dph_2009->nrok)))
       cx += ' trans='
        cx += fVAR(AllTrim(dph_2009->cnu))
       cx += ' typ_platce='
        cx += fVAR(if(.not.empty(dph_2009->cpd),'P',if(.not.empty(dph_2009->cio),'I';
                         ,'S')))
//       cx += ' zdobd_do'
//        cx += fVAR( )
//       cx += ' zdobd_od'
//        cx += fVAR( )
      cx += '/>'
       cx += CRLF
      FWrite( nHandle, cx)

      cx := '       <VetaP c_orient='
       cx += fVAR(AllTrim(dph_2009->ccp))
//      cx += ' c_pop='
//       cx += fVAR()
       cx += ' c_telef='
        cx += fVAR(AllTrim(dph_2009->ctelefon))
       cx += ' c_ufo='
        cx += fVAR( AllTrim(Str( SysConfig('System:nFINURAD'),3,0)))
       cx += ' dic='
        cx += fVAR( SubStr(AllTrim(dph_2009->cdic),3))
//      cx += ' dodobchjm='
//       cx += fVAR()
       cx += ' email='
        cx += fVAR(AllTrim(dph_2009->cmail))
//      cx += ' jmeno='
//       cx += fVAR()
       cx += ' naz_obce='
        cx += fVAR(AllTrim(dph_2009->cSidlo))
       cx += ' opr_jmeno='
        cx += fVAR(AllTrim(dph_2009->codposjmen))
       cx += ' opr_postaveni='
        cx += fVAR(AllTrim(dph_2009->codpospost))
       cx += ' opr_prijmeni='
        cx += fVAR(AllTrim(dph_2009->codposprij))
//      cx += ' prijmeni='
//       cx += fVAR()
       cx += ' psc='
        cx += fVAR(AllTrim(dph_2009->cpsc))
       cx += ' sest_jmeno='
        cx += fVAR(AllTrim(cj))
       cx += ' sest_prijmeni='
        cx += fVAR(AllTrim(cp))
       cx += ' sest_telef='
        cx += fVAR(AllTrim(StrTran(dph_2009->csestelef,' ','')))
       cx += ' stat='
        cx += fVAR(AllTrim(dph_2009->cstat))
//      cx += ' titul='
//       cx += fVAR()
       cx += ' typ_ds='
        cx += fVAR(AllTrim(SysConfig('System:cTYPDANSUB')))
       cx += ' ulice='
        cx += fVAR(AllTrim(dph_2009->cUlice))
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
        cx += fVAR(AllTrim(dph_2009->cpraosnaz))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)

      cx := '       <Veta1 dan23='
        cx += fVAR( AllTrim(Str(dph_2009->nR001d,14)))
       cx += ' dan5='
        cx += fVAR( AllTrim(Str(dph_2009->nR002d,14)))
       cx += ' dan_dzb23='
        cx += fVAR( AllTrim(Str(dph_2009->nR007d,14)))
       cx += ' dan_dzb5='
        cx += fVAR( AllTrim(Str(dph_2009->nR008d,14)))
       cx += ' dan_pdop_nrg='
        cx += fVAR( AllTrim(Str(dph_2009->nR009d,14)))
       cx += ' dan_psl23_e='
        cx += fVAR( AllTrim(Str(dph_2009->nR005d,14)))
       cx += ' dan_psl23_z='
        cx += fVAR( AllTrim(Str(dph_2009->nR011d,14)) )
       cx += ' dan_psl5_e='
        cx += fVAR( AllTrim(Str(dph_2009->nR006d,14)))
       cx += ' dan_psl5_z='
        cx += fVAR( AllTrim(Str(dph_2009->nR012d,14)))
       cx += ' dan_pzb23='
        cx += fVAR( AllTrim(Str(dph_2009->nR003d,14)))
       cx += ' dan_pzb5='
        cx += fVAR( AllTrim(Str(dph_2009->nR004d,14)))
       cx += ' dan_zlato='
        cx += fVAR( AllTrim(Str(dph_2009->nR010d,14)))
       cx += ' dov_zb23='
        cx += fVAR( AllTrim(Str(dph_2009->nR007z,14)))
       cx += ' dov_zb5='
        cx += fVAR( AllTrim(Str(dph_2009->nR008z,14)))
       cx += ' obrat23='
        cx += fVAR( AllTrim(Str(dph_2009->nR001z,14)))
       cx += ' obrat5='
        cx += fVAR( AllTrim(Str(dph_2009->nR002z,14)))
       cx += ' p_dop_nrg='
        cx += fVAR( AllTrim(Str(dph_2009->nR009z,14)))
       cx += ' p_sl23_e='
        cx += fVAR( AllTrim(Str(dph_2009->nR005z,14)))
       cx += ' p_sl23_z='
        cx += fVAR( AllTrim(Str(dph_2009->nR011z,14)))
       cx += ' p_sl5_e='
        cx += fVAR( AllTrim(Str(dph_2009->nR006z,14)))
       cx += ' p_sl5_z='
        cx += fVAR( AllTrim(Str(dph_2009->nR012z,14)))
       cx += ' p_zb23='
        cx += fVAR( AllTrim(Str(dph_2009->nR003z,14)))
       cx += ' p_zb5='
        cx += fVAR( AllTrim(Str(dph_2009->nR004z,14)))
       cx += ' zlato='
        cx += fVAR( AllTrim(Str(dph_2009->nR010z,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta2 dod_dop_nrg='
        cx += fVAR( AllTrim(Str(dph_2009->nR023p,14)))
       cx += ' dod_zb='
        cx += fVAR( AllTrim(Str(dph_2009->nR020p,14)))
       cx += ' pln_ost='
        cx += fVAR( AllTrim(Str(dph_2009->nR025p,14)))
       cx += ' pln_sluzby='
        cx += fVAR( AllTrim(Str(dph_2009->nR021p,14)))
       cx += ' pln_vyvoz='
        cx += fVAR( AllTrim(Str(dph_2009->nR022p,14)))
       cx += ' pln_zaslani='
        cx += fVAR( AllTrim(Str(dph_2009->nR024p,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta3 tri_dozb='
        cx += fVAR( AllTrim(Str(dph_2009->nR030d,14)))
       cx += ' tri_pozb='
        cx += fVAR( AllTrim(Str(dph_2009->nR030p,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta4 dov_cu23='
        cx += fVAR( AllTrim(Str(dph_2009->nR042z,14)))
       cx += ' dov_cu5='
        cx += fVAR( AllTrim(Str(dph_2009->nR043z,14)))
       cx += ' nar_maj='
        cx += fVAR( AllTrim(Str(dph_2009->nR048z,14)))
       cx += ' nar_zdp23='
        cx += fVAR( AllTrim(Str(dph_2009->nR044z,14)))
       cx += ' nar_zdp5='
        cx += fVAR( AllTrim(Str(dph_2009->nR045z,14)))
       cx += ' od_maj='
        cx += fVAR( AllTrim(Str(dph_2009->nR048d,14)))
       cx += ' od_zdp23='
        cx += fVAR( AllTrim(Str(dph_2009->nR044d,14)))
       cx += ' od_zdp5='
        cx += fVAR( AllTrim(Str(dph_2009->nR045d,14)))
       cx += ' odkr_maj='
        cx += fVAR( AllTrim(Str(dph_2009->nR048r,14)))
       cx += ' odkr_zdp23='
        cx += fVAR( AllTrim(Str(dph_2009->nR044r,14)))
       cx += ' odkr_zdp5='
        cx += fVAR( AllTrim(Str(dph_2009->nR045r,14)))
       cx += ' odp_cu23='
        cx += fVAR( AllTrim(Str(dph_2009->nR042r,14)))
       cx += ' odp_cu23_nar='
        cx += fVAR( AllTrim(Str(dph_2009->nR042d,14)))
       cx += ' odp_cu5='
        cx += fVAR( AllTrim(Str(dph_2009->nR043r,14)))
       cx += ' odp_cu5_nar='
        cx += fVAR( AllTrim(Str(dph_2009->nR043d,14)))
       cx += ' odp_rez_nar='
        cx += fVAR( AllTrim(Str(dph_2009->nR046d,14)))
       cx += ' odp_rezim='
        cx += fVAR( AllTrim(Str(dph_2009->nR046r,14)))
       cx += ' odp_sum_kr='
        cx += fVAR( AllTrim(Str(dph_2009->nR047r,14)))
       cx += ' odp_sum_nar='
        cx += fVAR( AllTrim(Str(  dph_2009->nR047d,14)))
       cx += ' odp_tuz23='
        cx += fVAR( AllTrim(Str(dph_2009->nR040r,14)))
       cx += ' odp_tuz23_nar='
        cx += fVAR( AllTrim(Str(dph_2009->nR040d,14)))
       cx += ' odp_tuz5='
        cx += fVAR( AllTrim(Str(dph_2009->nR041r,14)))
       cx += ' odp_tuz5_nar='
        cx += fVAR( AllTrim(Str(dph_2009->nR041d,14)))
       cx += ' pln23='
        cx += fVAR( AllTrim(Str(dph_2009->nR040z,14)))
       cx += ' pln5='
        cx += fVAR( AllTrim(Str(dph_2009->nR041z,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta5 koef_p20_nov='
        cx += fVAR( AllTrim(Str(dph_2009->nR052k,14)))
       cx += ' koef_p20_vypor='
        cx += fVAR( AllTrim(Str(dph_2009->nR053k,14)))
       cx += ' odp_uprav_kf='
        cx += fVAR( AllTrim(Str(dph_2009->nR052o,14)))
       cx += ' pln_nkf='
        cx += fVAR( AllTrim(Str(dph_2009->nR051s,14)))
       cx += ' plnosv_kf='
        cx += fVAR( AllTrim(Str(dph_2009->nR050p,14)))
       cx += ' plnosv_nkf='
        cx += fVAR( AllTrim(Str(dph_2009->nR051b,14)))
       cx += ' vypor_odp='
        cx += fVAR( AllTrim(Str(dph_2009->nR053o,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta6 dan_vrac='
        cx += fVAR( AllTrim(Str(dph_2009->nR062d,14)))
       cx += ' dan_zocelk='
        cx += fVAR( AllTrim(Str(dph_2009->nR063d,14)))
       cx += ' dano='
        cx += fVAR( AllTrim(Str(dph_2009->nR067d,14)))
       cx += ' dano_da='
        cx += fVAR( AllTrim(Str(dph_2009->nR065d,14)))
       cx += ' dano_no='
        cx += fVAR( AllTrim(Str(dph_2009->nR066o,14)))
       cx += ' odp_zocelk='
        cx += fVAR( AllTrim(Str(dph_2009->nR064o,14)))
       cx += ' uprav_odp='
        cx += fVAR( AllTrim(Str(dph_2009->nR060o,14)))
       cx += ' vyrov_odp='
        cx += fVAR( AllTrim(Str(dph_2009->nR061o,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)

      cx := '  </DPHDP2>' + CRLF
      FWrite( nHandle, cx)
      cx := '</Pisemnost>'
      FWrite( nHandle, cx)

      FClose( nHandle )
      drgMsgBox(drgNLS:msg('XML soubor byl vytvoøen'), XBPMB_INFORMATION)

    endif

return( nil)

// Export evidence k vykazu DPH_2011 - formát XML
function DIST000039( oxbp ) // oxbp = drgDialog
  local tm
  local ctm
  local cx
  local nit, ny, cp, cj
  local file
  local nHandle
  local inDir

    ctm  := dphevdw->typ_vypisu +'_' +StrZero(dph_2011->nm,2) + StrZero(dph_2011->nrok,4)
    file := selFILE('DPHEVD_'+ctm,'Xml',,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

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
      cx := '  <DPHEVD verzePis='+fVAR("01.01")+'>' + CRLF
      FWrite( nHandle, cx)

      cx := '       <VetaD'
//      cx += ' ctvrt='
//       cx += fVAR(AllTrim(Str(dph_2009->nQ,1,0)))
      cx += ' d_poddp='
       cx += fVAR(dtoc(Date()))
      cx += ' dokument='
       cx += fVAR("EVD")
      cx += ' k_uladis='
       cx += fVAR("DPH")
      cx += ' mesic='
       cx += fVAR(AllTrim(Str(dph_2011->nM,2,0)))
      cx += ' rok='
       cx += fVAR(AllTrim(Str(dph_2011->nrok,4,0)))
      cx += ' typ_vypisu='
       cx += fVAR(dphevdw->typ_vypisu)
//      cx += ' zdobd_do='
//       cx += fVAR()
//      cx += ' zdobd_od='
//       cx += fVAR()
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

      do while .not. dphevdw->( Eof())
        cx := '       <VetaE c_radku='
         cx += fVAR(AllTrim(Str(dphevdw->c_radku,6,0)))
        cx += ' d_uskut_pl='
         cx += fVAR(dtoc(dphevdw->d_uskut_pl))
        cx += ' dic_dod='
         cx += fVAR( SubStr( AllTrim( dphevdw->dic_dod),3))
        cx += ' kod_pred_pl='
         cx += fVAR(AllTrim(dphevdw->kod_pred_p))
        cx += ' roz_pl='
         cx += fVAR(AllTrim(Str(dphevdw->roz_pl,16,0)))
        cx += ' roz_pl_j='
         cx += fVAR(AllTrim(dphevdw->roz_pl_j))
        cx += ' zakl_dane='
         cx += fVAR(AllTrim(Str(dphevdw->zakl_dane,16,0)))
//        cx += ' por_c_stran='
//        cx += fVAR(AllTrim(Str(vykdph_sw->nCount,6,0)))
        cx += '/>'
        cx += CRLF
        FWrite( nHandle, cx)

        dphevdw->( dbSkip())
      enddo

      cx := '  </DPHEVD>' + CRLF
      FWrite( nHandle, cx)
      cx := '</Pisemnost>'
      FWrite( nHandle, cx)

      FClose( nHandle )
      drgMsgBox(drgNLS:msg('XML soubor byl vytvoøen'), XBPMB_INFORMATION)
    endif

return( nil)


// Export vykazu DPH_2015 - formát XML
function DIST000101( oxbp ) // oxbp = drgDialog
  local tm
  local ctm
  local cx
  local nit, ny, cp, cj
  local file
  local nHandle
  local inDir

//  drgDBMS:open( 'mzdzavit',,,,, 'mzdzavita' )
//    drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP

  * exportní soubor pro penzijní pojišovnu
  inDir := retDir(odata_datKom:PathExport)
//  ext   := 'hpa'
//  file  := inDir + cX + '.'+ ext
//  file  := selFILE( cX,ext,inDir,'Výbìr souboru pro export',{{"TXT soubory", ext}})
//  recNo := mzdzavhd->(recNo())

  ctm  := StrZero(dph_2015->nm,2) + StrZero(dph_2015->nrok,4)
  file := selFILE('DPHDP3_'+ctm,'Xml',inDir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

  if .not. Empty(file)
    nHandle := FCreate( file )
//      FAttr( file, "H" )
//      nHandle := FOpen( file, FO_READWRITE )

      ny := At( " ", dph_2015->csesjmeno)
      cp := AllTrim( SubStr( dph_2015->csesjmeno, 1, ny-1))
      cj := AllTrim( SubStr( dph_2015->csesjmeno, ny+1))

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

       if dph_2015->nq > 0
         cx += ' ctvrt='
          cx += fVAR(AllTrim(Str(dph_2015->nq)))
       endif

       cx += ' d_poddp='
        cx += fVAR(dtoc(Date()))
//       cx += ' d_zjist'
//        cx += fVAR( )
       cx += ' dapdph_forma='
        cx += fVAR( if(.not.empty(dph_2015->crp),'B',if(.not.empty(dph_2015->cop),'O','D')))
       cx += ' dokument='
        cx += fVAR('DP3' )
       cx += ' k_uladis='
        cx += fVAR('DPH')
       cx += ' kod_zo='
        cx += fVAR(AllTrim(dph_2015->czo))

       if dph_2015->nm > 0
         cx += ' mesic='
          cx += fVAR(AllTrim(Str(dph_2015->nm)))
       endif

       cx += ' rok='
        cx += fVAR(AllTrim(Str(dph_2015->nrok)))
       cx += ' trans='
        cx += fVAR(if(.not.empty(dph_2015->cnu), 'N', 'A'))     /// POZOR je tu chyba naplní se X a podle JT by nemìlo
       cx += ' typ_platce='
        cx += fVAR(AllTrim( SysConfig('Finance:cTypPlaDPH')))
//        cx += fVAR(if(.not.empty(dph_2015->cpd),'P',if(.not.empty(dph_2015->cio),'I';   // úprava JT 28.2.2014
//                         ,'S')))
//       cx += ' zdobd_do'
//        cx += fVAR( )
//       cx += ' zdobd_od'
//        cx += fVAR( )
      cx += '/>'
       cx += CRLF
      FWrite( nHandle, cx)

      cx := '       <VetaP c_orient='
       cx += fVAR(AllTrim(dph_2015->ccp))
//      cx += ' c_pop='
//       cx += fVAR()
       cx += ' c_telef='
        cx += fVAR(AllTrim(dph_2015->ctelefon))
       cx += ' c_ufo='
        cx += fVAR( AllTrim(Str( SysConfig('System:nFINURKRAJ'),3,0)))
       cx += ' c_pracufo='
        cx += fVAR( AllTrim(Str( SysConfig('System:nFINURAD'),4,0)))
       cx += ' dic='
        cx += fVAR( SubStr(AllTrim(dph_2015->cdic),3))
//      cx += ' dodobchjm='
//       cx += fVAR()
       cx += ' email='
        cx += fVAR(AllTrim(dph_2015->cmail))

       cx += ' jmeno='
        cx += fVAR(AllTrim(dph_2015->cfyzosjmen))

       cx += ' naz_obce='
        cx += fVAR(AllTrim(dph_2015->cSidlo))
       cx += ' opr_jmeno='
        cx += fVAR(AllTrim(dph_2015->codposjmen))
       cx += ' opr_postaveni='
        cx += fVAR(AllTrim(dph_2015->codpospost))
       cx += ' opr_prijmeni='
        cx += fVAR(AllTrim(dph_2015->codposprij))

       cx += ' prijmeni='
        cx += fVAR(AllTrim(dph_2015->cfyzosprij))

       cx += ' psc='
        cx += fVAR(AllTrim(dph_2015->cpsc))
       cx += ' sest_jmeno='
        cx += fVAR(AllTrim(cj))
       cx += ' sest_prijmeni='
        cx += fVAR(AllTrim(cp))
       cx += ' sest_telef='
        cx += fVAR(AllTrim(StrTran(dph_2015->csestelef,' ','')))
       cx += ' stat='
        cx += fVAR(AllTrim(dph_2015->cstat))
//      cx += ' titul='
//       cx += fVAR()
       cx += ' typ_ds='
        cx += fVAR(AllTrim(SysConfig('System:cTYPDANSUB')))
       cx += ' ulice='
        cx += fVAR(AllTrim(dph_2015->cUlice))
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
        cx += fVAR(AllTrim(dph_2015->cpraosnaz))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)

      cx := '       <Veta1 dan23='
        cx += fVAR( AllTrim(Str(dph_2015->nR001d,14)))
       cx += ' dan5='
        cx += fVAR( AllTrim(Str(dph_2015->nR002d,14)))
       cx += ' dan_dzb23='
        cx += fVAR( AllTrim(Str(dph_2015->nR007d,14)))
       cx += ' dan_dzb5='
        cx += fVAR( AllTrim(Str(dph_2015->nR008d,14)))
       cx += ' dan_pdop_nrg='
        cx += fVAR( AllTrim(Str(dph_2015->nR009d,14)))
       cx += ' dan_psl23_e='
        cx += fVAR( AllTrim(Str(dph_2015->nR005d,14)))
       cx += ' dan_psl23_z='
        cx += fVAR( AllTrim(Str(dph_2015->nR012d,14)) )
       cx += ' dan_psl5_e='
        cx += fVAR( AllTrim(Str(dph_2015->nR006d,14)))
       cx += ' dan_psl5_z='
        cx += fVAR( AllTrim(Str(dph_2015->nR013d,14)))
       cx += ' dan_pzb23='
        cx += fVAR( AllTrim(Str(dph_2015->nR003d,14)))
       cx += ' dan_pzb5='
        cx += fVAR( AllTrim(Str(dph_2015->nR004d,14)))
       cx += ' dan_rpren23='
        cx += fVAR( AllTrim(Str(dph_2015->nR010d,14)))
       cx += ' dan_rpren5='
        cx += fVAR( AllTrim(Str(dph_2015->nR011d,14)))
       cx += ' dov_zb23='
        cx += fVAR( AllTrim(Str(dph_2015->nR007z,14)))
       cx += ' dov_zb5='
        cx += fVAR( AllTrim(Str(dph_2015->nR008z,14)))
       cx += ' obrat23='
        cx += fVAR( AllTrim(Str(dph_2015->nR001z,14)))
       cx += ' obrat5='
        cx += fVAR( AllTrim(Str(dph_2015->nR002z,14)))
       cx += ' p_dop_nrg='
        cx += fVAR( AllTrim(Str(dph_2015->nR009z,14)))
       cx += ' p_sl23_e='
        cx += fVAR( AllTrim(Str(dph_2015->nR005z,14)))
       cx += ' p_sl23_z='
        cx += fVAR( AllTrim(Str(dph_2015->nR012z,14)))
       cx += ' p_sl5_e='
        cx += fVAR( AllTrim(Str(dph_2015->nR006z,14)))
       cx += ' p_sl5_z='
        cx += fVAR( AllTrim(Str(dph_2015->nR013z,14)))
       cx += ' p_zb23='
        cx += fVAR( AllTrim(Str(dph_2015->nR003z,14)))
       cx += ' p_zb5='
        cx += fVAR( AllTrim(Str(dph_2015->nR004z,14)))
       cx += ' rez_pren23='
        cx += fVAR( AllTrim(Str(dph_2015->nR010z,14)))
       cx += ' rez_pren5='
        cx += fVAR( AllTrim(Str(dph_2015->nR011z,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta2 dod_dop_nrg='
        cx += fVAR( AllTrim(Str(dph_2015->nR023p,14)))
       cx += ' dod_zb='
        cx += fVAR( AllTrim(Str(dph_2015->nR020p,14)))
       cx += ' pln_ost='
        cx += fVAR( AllTrim(Str(dph_2015->nR026p,14)))
       cx += ' pln_rez_pren='
        cx += fVAR( AllTrim(Str(dph_2015->nR025p,14)))
       cx += ' pln_sluzby='
        cx += fVAR( AllTrim(Str(dph_2015->nR021p,14)))
       cx += ' pln_vyvoz='
        cx += fVAR( AllTrim(Str(dph_2015->nR022p,14)))
       cx += ' pln_zaslani='
        cx += fVAR( AllTrim(Str(dph_2015->nR024p,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta3 dov_osv='
        cx += fVAR( AllTrim(Str(dph_2015->nR032p,14)))
       cx += ' opr_dluz='
        cx += fVAR( AllTrim(Str(dph_2015->nR034d,14)))
       cx += ' opr_verit='
        cx += fVAR( AllTrim(Str(dph_2015->nR033d,14)))
       cx += ' tri_dozb='
        cx += fVAR( AllTrim(Str(dph_2015->nR031p,14)))
       cx += ' tri_pozb='
        cx += fVAR( AllTrim(Str(dph_2015->nR030p,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta4 dov_cu='
        cx += fVAR( AllTrim(Str(dph_2015->nR042z,14)))
       cx += ' nar_maj='
        cx += fVAR( AllTrim(Str(dph_2015->nR047z,14)))
       cx += ' nar_zdp23='
        cx += fVAR( AllTrim(Str(dph_2015->nR043z,14)))
       cx += ' nar_zdp5='
        cx += fVAR( AllTrim(Str(dph_2015->nR044z,14)))
       cx += ' od_maj='
        cx += fVAR( AllTrim(Str(dph_2015->nR047d,14)))
       cx += ' od_zdp23='
        cx += fVAR( AllTrim(Str(dph_2015->nR043d,14)))
       cx += ' od_zdp5='
        cx += fVAR( AllTrim(Str(dph_2015->nR044d,14)))
       cx += ' odkr_maj='
        cx += fVAR( AllTrim(Str(dph_2015->nR047r,14)))
       cx += ' odkr_zdp23='
        cx += fVAR( AllTrim(Str(dph_2015->nR043r,14)))
       cx += ' odkr_zdp5='
        cx += fVAR( AllTrim(Str(dph_2015->nR044r,14)))
       cx += ' odp_cu='
        cx += fVAR( AllTrim(Str(dph_2015->nR042r,14)))
       cx += ' odp_cu_nar='
        cx += fVAR( AllTrim(Str(dph_2015->nR042d,14)))
       cx += ' odp_rez_nar='
        cx += fVAR( AllTrim(Str(dph_2015->nR045d,14)))
       cx += ' odp_rezim='
        cx += fVAR( AllTrim(Str(dph_2015->nR045r,14)))
       cx += ' odp_sum_kr='
        cx += fVAR( AllTrim(Str(dph_2015->nR046r,14)))
       cx += ' odp_sum_nar='
        cx += fVAR( AllTrim(Str(  dph_2015->nR046d,14)))
       cx += ' odp_tuz23='
        cx += fVAR( AllTrim(Str(dph_2015->nR040r,14)))
       cx += ' odp_tuz23_nar='
        cx += fVAR( AllTrim(Str(dph_2015->nR040d,14)))
       cx += ' odp_tuz5='
        cx += fVAR( AllTrim(Str(dph_2015->nR041r,14)))
       cx += ' odp_tuz5_nar='
        cx += fVAR( AllTrim(Str(dph_2015->nR041d,14)))
       cx += ' pln23='
        cx += fVAR( AllTrim(Str(dph_2015->nR040z,14)))
       cx += ' pln5='
        cx += fVAR( AllTrim(Str(dph_2015->nR041z,14)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta5 koef_p20_nov='
        cx += fVAR( AllTrim(Str(dph_2015->nR052k,14)))

       if dph_2015->nR053k <> 0
         cx += ' koef_p20_vypor='
          cx += fVAR( AllTrim(Str(dph_2015->nR053k,14)))
       endif

       cx += ' odp_uprav_kf='
        cx += fVAR( AllTrim(Str(dph_2015->nR052o,14)))
       cx += ' pln_nkf='
        cx += fVAR( AllTrim(Str(dph_2015->nR051s,14)))
       cx += ' plnosv_kf='
        cx += fVAR( AllTrim(Str(dph_2015->nR050p,14)))
       cx += ' plnosv_nkf='
        cx += fVAR( AllTrim(Str(dph_2015->nR051b,14)))

       if dph_2015->nR053o <> 0
         cx += ' vypor_odp='
          cx += fVAR( AllTrim(Str(dph_2015->nR053o,14)))
       endif

      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)


      cx := '       <Veta6 dan_vrac='
        cx += fVAR( AllTrim(Str(dph_2015->nR061d,14)))
       cx += ' dan_zocelk='
        cx += fVAR( AllTrim(Str(dph_2015->nR062d,14)))
       cx += ' dano='
        cx += fVAR( AllTrim(Str(dph_2015->nR066d,14)))
       cx += ' dano_da='
        cx += fVAR( AllTrim(Str(dph_2015->nR064d,14)))
       cx += ' dano_no='
        cx += fVAR( AllTrim(Str(dph_2015->nR065o,14)))
       cx += ' odp_zocelk='
        cx += fVAR( AllTrim(Str(dph_2015->nR063o,14)))

       if dph_2015->nR060o <> 0
         cx += ' uprav_odp='
          cx += fVAR( AllTrim(Str(dph_2015->nR060o,14)))
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

return( nil)


// Export souhrnné hlášení k vykazu DPH_2015 - formát XML
function DIST000102( oxbp ) // oxbp = drgDialog
  local tm
  local ctm
  local cx
  local nit, ny, cp, cj
  local file
  local nHandle
  local inDir

  inDir := retDir(odata_datKom:PathExport)

  ctm  := StrZero(dph_2015->nm,2) + StrZero(dph_2015->nrok,4)
  file := selFILE('DPHSHV_'+ctm,'Xml',inDir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

  if .not. Empty(file)
    nHandle := FCreate( file )

    ny := At( " ", dph_2015->csesjmeno)
    cp := AllTrim( SubStr( dph_2015->csesjmeno, 1, ny-1))
    cj := AllTrim( SubStr( dph_2015->csesjmeno, ny+1))

    cx := '<?xml version=' + fVAR("1.0")+ ' encoding=' +fVAR("windows-1250")+' standalone='+ fVAR("no")+'?>' + CRLF
    FWrite( nHandle, cx)

    cx := '<Pisemnost nazevSW='+fVAR("A++")+' verzeSW='+fVAR("1.04.2")+'>' + CRLF
    FWrite( nHandle, cx)
    cx := '  <DPHSHV verzePis='+fVAR("01.01")+'>' + CRLF
    FWrite( nHandle, cx)

    cx := '       <VetaD'
    cx += ' d_poddp='
     cx += fVAR(dtoc(Date()))
    cx += ' dokument='
     cx += fVAR("SHV")
    cx += ' k_uladis='
     cx += fVAR("DPH")
    cx += ' mesic='
     cx += fVAR(AllTrim(Str(dph_2015->nM,2,0)))
    cx += ' pln_poc_celk='
     cx += fVAR("0")
    cx += ' poc_radku='
     cx += fVAR("0")
    cx += ' poc_stran='
     cx += fVAR("0")
    cx += ' rok='
     cx += fVAR(AllTrim(Str(dph_2015->nrok,4,0)))
    cx += ' shvies_forma='
     cx += fVAR("R")
    cx += ' suma_pln='
     cx += fVAR("0")
    cx += '/>'
     cx += CRLF
    FWrite( nHandle, cx)

    cx := '       <VetaP c_orient='
     cx += fVAR(AllTrim(dph_2015->ccp))
    cx += ' c_ufo='
     cx += fVAR( AllTrim(Str( SysConfig('System:nFINURKRAJ'),3,0)))
    cx += ' c_pracufo='
     cx += fVAR( AllTrim(Str( SysConfig('System:nFINURAD'),4,0)))
    cx += ' dic='
     cx += fVAR( SubStr(AllTrim(dph_2015->cdic),3))
    cx += ' naz_obce='
     cx += fVAR(AllTrim(dph_2015->cSidlo))
    cx += ' opr_jmeno='
     cx += fVAR(AllTrim(dph_2015->codposjmen))
    cx += ' opr_postaveni='
     cx += fVAR(AllTrim(dph_2015->codpospost))
    cx += ' opr_prijmeni='
     cx += fVAR(AllTrim(dph_2015->codposprij))
    cx += ' psc='
     cx += fVAR(AllTrim(dph_2015->cpsc))
    cx += ' sest_jmeno='
     cx += fVAR(cj)
    cx += ' sest_prijmeni='
     cx += fVAR(cp)
    cx += ' sest_telef='
     cx += fVAR(AllTrim(StrTran(dph_2015->csestelef,' ','')))
    cx += ' typ_ds='
     cx += fVAR(AllTrim(SysConfig('System:cTYPDANSUB')))
    cx += ' ulice='
     cx += fVAR(AllTrim(dph_2015->cUlice))
    cx += ' zkrobchjm='
     cx += fVAR(AllTrim(dph_2015->cpraosnaz))
    cx += '/>'
     cx += CRLF
    FWrite( nHandle, cx)

    do while .not. vykdph_sw->( Eof())
      cx := '       <VetaR c_vat='
       cx += fVAR(Left(AllTrim(vykdph_sw->cvat_vies),12))
      cx += ' c_rad='
       cx += fVAR(AllTrim(Str(vykdph_sw->nCisRadku,2)))
      cx += ' k_pln_eu='
       cx += fVAR(AllTrim(Str(vykdph_sw->nKodPl_FIN)))
      cx += ' k_stat='
       cx += fVAR(AllTrim(vykdph_sw->cZkratSta2))
      cx += ' pln_hodnota='
       cx += fVAR(AllTrim(Str(vykdph_sw->nCenZakCel,14,0)))
      cx += ' pln_pocet='
       cx += fVAR(AllTrim(Str(vykdph_sw->nCount,6,0)))
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

return( nil)


// Export evidence pro daòové úèely k výkazu DPH_2015 - formát XML
function DIST000103( oxbp ) // oxbp = drgDialog
  local tm
  local ctm
  local cx
  local nit, ny, cp, cj
  local file
  local nHandle
  local inDir

  inDir := retDir(odata_datKom:PathExport)

  ctm  := dphevdw->typ_vypisu +'_' +StrZero(dph_2015->nm,2) + StrZero(dph_2015->nrok,4)
  file := selFILE('DPHEVD_'+ctm,'Xml',inDir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

  if .not. Empty(file)
    nHandle := FCreate( file )

    ny := At( " ", dph_2015->csesjmeno)
    cp := AllTrim( SubStr( dph_2015->csesjmeno, 1, ny-1))
    cj := AllTrim( SubStr( dph_2015->csesjmeno, ny+1))

    cx := '<?xml version=' + fVAR("1.0")+ ' encoding=' +fVAR("windows-1250")+' standalone='+ fVAR("no")+'?>' + CRLF
    FWrite( nHandle, cx)

    cx := '<Pisemnost nazevSW='+fVAR("A++")+' verzeSW='+fVAR("1.04.2")+'>' + CRLF
    FWrite( nHandle, cx)
    cx := '  <DPHEVD verzePis='+fVAR("01.01")+'>' + CRLF
    FWrite( nHandle, cx)

    cx := '       <VetaD'
    cx += ' d_poddp='
     cx += fVAR(dtoc(Date()))
    cx += ' dokument='
     cx += fVAR("EVD")
    cx += ' k_uladis='
     cx += fVAR("DPH")
    cx += ' mesic='
     cx += fVAR(AllTrim(Str(dph_2015->nM,2,0)))
    cx += ' rok='
     cx += fVAR(AllTrim(Str(dph_2015->nrok,4,0)))
    cx += ' typ_vypisu='
     cx += fVAR(dphevdw->typ_vypisu)
    cx += '/>'
     cx += CRLF
    FWrite( nHandle, cx)

    cx := '       <VetaP c_orient='
     cx += fVAR(AllTrim(dph_2015->ccp))
    cx += ' c_ufo='
     cx += fVAR( AllTrim(Str( SysConfig('System:nFINURKRAJ'),3,0)))
    cx += ' c_pracufo='
     cx += fVAR( AllTrim(Str( SysConfig('System:nFINURAD'),4,0)))
    cx += ' dic='
     cx += fVAR( SubStr(AllTrim(dph_2015->cdic),3))
    cx += ' naz_obce='
     cx += fVAR(AllTrim(dph_2015->cSidlo))
    cx += ' opr_jmeno='
     cx += fVAR(AllTrim(dph_2015->codposjmen))
    cx += ' opr_postaveni='
     cx += fVAR(AllTrim(dph_2015->codpospost))
    cx += ' opr_prijmeni='
     cx += fVAR(AllTrim(dph_2015->codposprij))
    cx += ' psc='
     cx += fVAR(AllTrim(dph_2015->cpsc))
    cx += ' sest_jmeno='
     cx += fVAR(cj)
    cx += ' sest_prijmeni='
     cx += fVAR(cp)
    cx += ' sest_telef='
     cx += fVAR(AllTrim(StrTran(dph_2015->csestelef,' ','')))
    cx += ' stat='
     cx += fVAR(AllTrim(dph_2015->cstat))
    cx += ' typ_ds='
     cx += fVAR(AllTrim(SysConfig('System:cTYPDANSUB')))
    cx += ' ulice='
     cx += fVAR(AllTrim(dph_2015->cUlice))
    cx += ' zkrobchjm='
     cx += fVAR(AllTrim(dph_2015->cpraosnaz))
    cx += '/>'
     cx += CRLF
    FWrite( nHandle, cx)

    do while .not. dphevdw->( Eof())
      cx := '       <VetaE c_radku='
       cx += fVAR(AllTrim(Str(dphevdw->c_radku,6,0)))
      cx += ' d_uskut_pl='
       cx += fVAR(dtoc(dphevdw->d_uskut_pl))
      cx += ' dic_dod='
       cx += fVAR( SubStr( AllTrim( dphevdw->dic_dod),3))
      cx += ' kod_pred_pl='
       cx += fVAR(AllTrim(dphevdw->kod_pred_p))
      cx += ' roz_pl='
       cx += fVAR(AllTrim(Str(dphevdw->roz_pl,16,0)))
      cx += ' roz_pl_j='
       cx += fVAR(AllTrim(dphevdw->roz_pl_j))
      cx += ' zakl_dane='
       cx += fVAR(AllTrim(Str(dphevdw->zakl_dane,16,0)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)
      dphevdw->( dbSkip())
    enddo

    cx := '  </DPHEVD>' + CRLF
    FWrite( nHandle, cx)
    cx := '</Pisemnost>'
    FWrite( nHandle, cx)

    FClose( nHandle )
    drgMsgBox(drgNLS:msg('XML soubor byl vytvoøen'), XBPMB_INFORMATION)
  endif

return( nil)



// Export evidence pro daòové úèely od 04/2015 k výkazu DPH_2015 - formát XML
function DIST000106( oxbp ) // oxbp = drgDialog
  local tm
  local ctm
  local cx
  local nit, ny, cp, cj
  local file
  local nHandle
  local inDir

  inDir := retDir(odata_datKom:PathExport)

  ctm  := dphevdw->typ_vypisu +'_' +StrZero(dph_2015->nm,2) + StrZero(dph_2015->nrok,4)
  file := selFILE('DPHEVD_'+ctm,'Xml',inDir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

  if .not. Empty(file)
    nHandle := FCreate( file )

    ny := At( " ", dph_2015->csesjmeno)
    cp := AllTrim( SubStr( dph_2015->csesjmeno, 1, ny-1))
    cj := AllTrim( SubStr( dph_2015->csesjmeno, ny+1))

    cx := '<?xml version=' + fVAR("1.0")+ ' encoding=' +fVAR("windows-1250")+' standalone='+ fVAR("no")+'?>' + CRLF
    FWrite( nHandle, cx)

    cx := '<Pisemnost nazevSW='+fVAR("A++")+' verzeSW='+fVAR("1.04.2")+'>' + CRLF
    FWrite( nHandle, cx)
    cx := '  <DPHEVD verzePis='+fVAR("01.02")+'>' + CRLF
    FWrite( nHandle, cx)

    cx := '       <VetaD'
//    if SysConfig('System:ntypvykdph') = 3
//      cx += ' ctvrt='
//       cx += fVAR(AllTrim(Str(dph_2015->nQ,1,0)))
//    else
      cx += ' mesic='
       cx += fVAR(AllTrim(Str(dph_2015->nM,2,0)))
//    endif
    cx += ' d_poddp='
     cx += fVAR(dtoc(Date()))
    cx += ' dokument='
     cx += fVAR("EVD")
    cx += ' k_uladis='
     cx += fVAR("DPH")
    cx += ' rok='
     cx += fVAR(AllTrim(Str(dph_2015->nrok,4,0)))
    cx += ' typ_vypisu='
     cx += fVAR(dphevdw->typ_vypisu)
    cx += ' zdobd_do='
     cx += fVAR('')
    cx += ' zdobd_od='
     cx += fVAR('')
    cx += '/>'
     cx += CRLF
    FWrite( nHandle, cx)

    cx := '       <VetaP c_orient='
     cx += fVAR(AllTrim(dph_2015->ccp))
    cx += ' c_pop='
     cx += fVAR('0')
    cx += ' c_ufo='
     cx += fVAR( AllTrim(Str( SysConfig('System:nFINURKRAJ'),3,0)))
    cx += ' c_pracufo='
     cx += fVAR( AllTrim(Str( SysConfig('System:nFINURAD'),4,0)))
    cx += ' c_telef='
     cx += fVAR(AllTrim(StrTran(dph_2015->csestelef,' ','')))
    cx += ' dic='
     cx += fVAR( SubStr(AllTrim(dph_2015->cdic),3))
    cx += ' email='
     cx += fVAR( AllTrim( SysConfig('System:cEmail')))
//    cx += ' jmeno='
//     cx += fVAR( Left( AllTrim( SysConfig('System:cPodnik')),20))
    cx += ' naz_obce='
     cx += fVAR(AllTrim(dph_2015->cSidlo))
    cx += ' opr_jmeno='
     cx += fVAR(AllTrim(dph_2015->codposjmen))
    cx += ' opr_postaveni='
     cx += fVAR(AllTrim(dph_2015->codpospost))
    cx += ' opr_prijmeni='
     cx += fVAR(AllTrim(dph_2015->codposprij))
//    cx += ' prijmeni='
//     cx += fVAR('')
    cx += ' psc='
     cx += fVAR(AllTrim(dph_2015->cpsc))
    cx += ' sest_jmeno='
     cx += fVAR(cj)
    cx += ' sest_prijmeni='
     cx += fVAR(cp)
    cx += ' sest_telef='
     cx += fVAR(AllTrim(StrTran(dph_2015->csestelef,' ','')))
    cx += ' stat='
     cx += fVAR(AllTrim(dph_2015->cstat))
//    cx += ' titul='
//     cx += fVAR('')
    cx += ' typ_ds='
     cx += fVAR(AllTrim(SysConfig('System:cTYPDANSUB')))
    cx += ' ulice='
     cx += fVAR(AllTrim(dph_2015->cUlice))
//    cx += ' zast_dat_nar='
//     cx += fVAR('')
//    cx += ' zast_ev_cislo='
//     cx += fVAR('')
//    cx += ' zast_ic='
//     cx += fVAR('')
//    cx += ' zast_jmeno='
//     cx += fVAR('')
//    cx += ' zast_kod='
//     cx += fVAR('')
//    cx += ' zast_nazev='
//     cx += fVAR('')
//    cx += ' zast_prijmeni='
//     cx += fVAR('')
//    cx += ' zast_typ='
//     cx += fVAR('')
    cx += ' zkrobchjm='
     cx += fVAR(AllTrim(dph_2015->cpraosnaz))
    cx += '/>'
     cx += CRLF
    FWrite( nHandle, cx)

    do while .not. dphevdw->( Eof())
      cx := '       <VetaE c_radku='
       cx += fVAR(AllTrim(Str(dphevdw->c_radku,6,0)))
      cx += ' d_uskut_pl='
       cx += fVAR(dtoc(dphevdw->d_uskut_pl))
      cx += ' dic_dod='
       cx += fVAR( SubStr( AllTrim( dphevdw->dic_dod),3))
      cx += ' kod_pred_pl='
       cx += fVAR(AllTrim(dphevdw->kod_pred_p))
      cx += ' roz_pl='
       cx += fVAR(AllTrim(Str(dphevdw->roz_pl,16,0)))
      cx += ' roz_pl_j='
       cx += fVAR(AllTrim(dphevdw->roz_pl_j))
      cx += ' zakl_dane='
       cx += fVAR(AllTrim(Str(dphevdw->zakl_dane,16,0)))
      cx += '/>'
      cx += CRLF
      FWrite( nHandle, cx)
      dphevdw->( dbSkip())
    enddo

    cx := '  </DPHEVD>' + CRLF
    FWrite( nHandle, cx)
    cx := '</Pisemnost>'
    FWrite( nHandle, cx)

    FClose( nHandle )
    drgMsgBox(drgNLS:msg('XML soubor byl vytvoøen'), XBPMB_INFORMATION)
  endif

return( nil)


// Export kontrolní hlášení k vykazu DPH od 2016 - formát XML
function DIST000108( oxbp ) // oxbp = drgDialog
  local tm
  local ctm
  local cx
  local nit, ny, cp, cj
  local file
  local nHandle
  local inDir

  inDir := retDir(odata_datKom:PathExport)

  ctm  := StrZero(dphkohhd->nm,2) + StrZero(dphkohhd->nrok,4)
  file := selFILE('DPHKH1_'+ctm,'Xml',inDir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

  if .not. Empty(file)

    drgDBMS:open('dphkohit',,,,,'dphkohitx')
    filter := format( "cidHlaseni = '%%'"  ,{ dphkohhd->cidHlaseni } )
    dphkohitx->( ads_setAof( filter ), dbgoTop())
    dphkohitx->( ordsetfocus('DphKohIT01'))

    nHandle := FCreate( file )

    ny := At( " ", dphkohhd->csesjmeno)
    cp := AllTrim( SubStr( dphkohhd->csesjmeno, 1, ny-1))
    cj := AllTrim( SubStr( dphkohhd->csesjmeno, ny+1))

    cx := '<?xml version=' + fVAR("1.0")+ ' encoding=' +fVAR("windows-1250")+'?>' + CRLF
    FWrite( nHandle, cx)

    cx := '<Pisemnost nazevSW='+fVAR("A++")+' verzeSW='+fVAR("1.04.2")+'>' + CRLF
    FWrite( nHandle, cx)
    cx := '  <DPHKH1 verzePis='+fVAR("01.02")+'>' + CRLF
    FWrite( nHandle, cx)

    cx := '       <VetaD'
    if .not. Empty( dphkohhd->cidvyzvy)
      cx += ' c_jed_vyzvy='
       cx += fVAR(AllTrim(dphkohhd->cidvyzvy))
    endif

    if dphkohhd->nQ <> 0
      cx += ' ctvrt='
       cx += fVAR(AllTrim(Str(dphkohhd->nQ,1,0)))
    endif

    cx += ' d_poddp='
     cx += fVAR(dtoc(Date()))

    if .not. Empty( dphkohhd->ddatmduvod)
      cx += ' d_zjist='
       cx += fVAR(dtoc(dphkohhd->ddatmduvod))
    endif

    cx += ' dokument='
     cx += fVAR("KH1")
    cx += ' k_uladis='
     cx += fVAR("DPH")
    cx += ' khdph_forma='
     do case
     case .not. Empty( dphkohhd->cOP) .and. .not. Empty( dphkohhd->cDP)  ;   cx += fVAR("E")
     case .not. Empty( dphkohhd->cRP)  ;   cx += fVAR("B")
     case .not. Empty( dphkohhd->cOP)  ;   cx += fVAR("O")
     case .not. Empty( dphkohhd->cDP)  ;   cx += fVAR("N")
     endcase
    cx += ' mesic='
     cx += fVAR(AllTrim(Str(dphkohhd->nM,2,0)))
    cx += ' rok='
     cx += fVAR(AllTrim(Str(dphkohhd->nrok,4,0)))
    if .not. Empty(AllTrim(dphkohhd->crychodpov))
      cx += ' vyzva_odp='
       cx += fVAR(dphkohhd->crychodpov)
    endif
    if .not. Empty(dphkohhd->ddo)
      cx += ' zdobd_do='
       cx += fVAR(dtoc(dphkohhd->ddo))
    endif
    if .not. Empty(dphkohhd->ddo)
      cx += ' zdobd_do='
       cx += fVAR(dtoc(dphkohhd->ddo))
    endif
    cx += '/>'
     cx += CRLF
    FWrite( nHandle, cx)

    cx := '       <VetaP c_orient='
     cx += fVAR(AllTrim(dphkohhd->ccorient))
    cx += ' c_pop='
     cx += fVAR(AllTrim(dphkohhd->ccp))
    cx += ' c_pracufo='
     cx += fVAR( AllTrim(Str( dphkohhd->npracufo,4,0)))
//     cx += fVAR( AllTrim(Str( SysConfig('System:nFINURAD'),4,0)))
    cx += ' c_ufo='
     cx += fVAR( AllTrim(Str( dphkohhd->nufo,4,0)))
//     cx += fVAR( AllTrim(Str( SysConfig('System:nFINURKRAJ'),3,0)))
    cx += ' dic='
     cx += fVAR( SubStr(AllTrim(dphkohhd->cdic),3))
    cx += ' email='
     cx += fVAR( AllTrim(dphkohhd->cmail))
    cx += ' id_dats='
     cx += fVAR( AllTrim(dphkohhd->ciddatschr))
    cx += ' jmeno='
     cx += fVAR(AllTrim(dphkohhd->cfyzosjmen))
    cx += ' naz_obce='
     cx += fVAR(AllTrim(dphkohhd->cSidlo))
    cx += ' opr_jmeno='
     cx += fVAR(AllTrim(dphkohhd->codposjmen))
    cx += ' opr_postaveni='
     cx += fVAR(AllTrim(dphkohhd->codpospost))
    cx += ' opr_prijmeni='
     cx += fVAR(AllTrim(dphkohhd->codposprij))
    cx += ' prijmeni='
     cx += fVAR(AllTrim(dphkohhd->cfyzosprij))
    cx += ' psc='
     cx += fVAR(AllTrim(dphkohhd->cpsc))
    cx += ' sest_jmeno='
     cx += fVAR(cj)
    cx += ' sest_prijmeni='
     cx += fVAR(cp)
    cx += ' sest_telef='
     cx += fVAR(AllTrim(StrTran(dphkohhd->csestelef,' ','')))
    cx += ' stat='
     cx += fVAR(AllTrim(dphkohhd->cstat))
    cx += ' titul='
     cx += fVAR(AllTrim(dphkohhd->ctitul))
    cx += ' typ_ds='
     cx += fVAR(AllTrim(dphkohhd->cTypDanSub))
//     cx += fVAR(AllTrim(SysConfig('System:cTYPDANSUB')))
    cx += ' ulice='
     cx += fVAR(AllTrim(dphkohhd->cUlice))
    cx += ' zast_dat_nar='
      cx += fVAR(if( .not. Empty(dphkohhd->dzasdatnar),dtoc(dphkohhd->dzasdatnar),''))
    cx += ' zast_ev_cislo='
     cx += fVAR(AllTrim(dphkohhd->czasevcis))
    cx += ' zast_ic='
     cx += fVAR(AllTrim(dphkohhd->czasico))
    cx += ' zast_jmeno='
     cx += fVAR(AllTrim(dphkohhd->czasjmeno))
    cx += ' zast_kod='
     cx += fVAR(AllTrim(dphkohhd->czaskod))
    cx += ' zast_nazev='
     cx += fVAR(AllTrim(dphkohhd->czasnazev))
    cx += ' zast_prijmeni='
     cx += fVAR(AllTrim(dphkohhd->czasprijm))
    cx += ' zast_typ='
     cx += fVAR(AllTrim(dphkohhd->czastyp))
    cx += ' zkrobchjm='
     cx += fVAR(AllTrim(dphkohhd->cpraosnaz))
    cx += '/>'
     cx += CRLF
    FWrite( nHandle, cx)

    do while .not. dphkohitx->( Eof())
      if dphkohitx->nradek > 0 .and. dphkohitx->cOddilKoHl <> 'A5i' .and. dphkohitx->cOddilKoHl <> 'B3i'
        do case
        case dphkohitx->cOddilKoHl = 'A.1'
          cx := '       <VetaA1'
          cx += ' c_evid_dd='
           cx += fVAR(AllTrim(dphkohitx->cdandoklad))
          cx += ' c_radku='
           cx += fVAR(AllTrim(Str(dphkohitx->nradek,6)))
          cx += ' dic_odb='
           cx += fVAR(AllTrim(dphkohitx->cdiczakl))
          cx += ' duzp='
           cx += fVAR(dtoc(dphkohitx->dvystfak))
          cx += ' kod_pred_pl='
           cx += fVAR(AllTrim(dphkohitx->ctyppredan))
          cx += ' zakl_dane1='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakld_dph,13,2)))

        case dphkohitx->cOddilKoHl = 'A.2'
          cx := '       <VetaA2'
          cx += ' c_evid_dd='
           cx += fVAR(AllTrim(dphkohitx->cdandoklad))
          cx += ' c_radku='
           cx += fVAR(AllTrim(Str(dphkohitx->nradek,6)))
          cx += ' dan1='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_2,13,2)))
          cx += ' dan2='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_1,13,2)))
          cx += ' dan3='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_3,13,2)))
          cx += ' dppd='
           cx += fVAR(dtoc(dphkohitx->dvystfak))
          cx += ' k_stat='
           cx += fVAR(AllTrim(dphkohitx->cDicStaKod))
          cx += ' vatid_dod='
           cx += fVAR(AllTrim(dphkohitx->cDicZakl))
          cx += ' zakl_dane1='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_2,13,2)))
          cx += ' zakl_dane2='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_1,13,2)))
          cx += ' zakl_dane3='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_3,13,2)))

         case dphkohitx->cOddilKoHl = 'A.3'
          cx := '       <VetaA3'
          cx += ' c_evid_dd='
           cx += fVAR(AllTrim(dphkohitx->cdandoklad))
          cx += ' c_radku='
           cx += fVAR(AllTrim(Str(dphkohitx->nradek,6)))
          cx += ' d_narozeni='
           cx += fVAR(dtoc(dphkohitx->ddatnaroz))
          cx += ' dup='
           cx += fVAR(dtoc(dphkohitx->dvystfak))
          cx += ' jm_prijm_obch='
           cx += fVAR(AllTrim(dphkohitx->cnazev))
          cx += ' k_stat='
           cx += fVAR(AllTrim(dphkohitx->cDicStaKod))
          cx += ' m_popbytu_sidlo='
           cx += fVAR(Right(AllTrim(dphkohitx->cAdresa),100))
          cx += ' osv_plneni='
           cx += fVAR(AllTrim(Str(dphkohitx->nOsvOdDan,13,2)))
          cx += ' vatid_odb='
           cx += fVAR(AllTrim(dphkohitx->cDicZakl))

        case dphkohitx->cOddilKoHl = 'A.4'
          cx := '       <VetaA4'
          cx += ' c_evid_dd='
           cx += fVAR(AllTrim(dphkohitx->cdandoklad))
          cx += ' c_radku='
           cx += fVAR(AllTrim(Str(dphkohitx->nradek,6)))
          cx += ' dan1='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_2,13,2)))
          cx += ' dan2='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_1,13,2)))
          cx += ' dan3='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_3,13,2)))
          cx += ' dic_odb='
           cx += fVAR(AllTrim(dphkohitx->cDicZakl))
          cx += ' dppd='
           cx += fVAR(dtoc(dphkohitx->dvystfak))
          cx += ' kod_rezim_pl='
           cx += fVAR(AllTrim(Str(dphkohitx->nKodRezPln,1)))
          cx += ' zakl_dane1='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_2,13,2)))
          cx += ' zakl_dane2='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_1,13,2)))
          cx += ' zakl_dane3='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_3,13,2)))
          cx += ' zdph_44='
           cx += fVAR(if( Empty(dphkohitx->cParagr44),'N', AllTrim(dphkohitx->cParagr44)))

        case dphkohitx->cOddilKoHl = 'A.5'
          cx := '       <VetaA5'
          cx += ' dan1='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_2,13,2)))
          cx += ' dan2='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_1,13,2)))
          cx += ' dan3='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_3,13,2)))
          cx += ' zakl_dane1='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_2,13,2)))
          cx += ' zakl_dane2='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_1,13,2)))
          cx += ' zakl_dane3='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_3,13,2)))

        case dphkohitx->cOddilKoHl = 'B.1'
          cx := '       <VetaB1'
          cx += ' c_evid_dd='
           cx += fVAR(AllTrim(dphkohitx->cdandoklad))
          cx += ' c_radku='
           cx += fVAR(AllTrim(Str(dphkohitx->nradek,6)))
          cx += ' dan1='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_2,13,2)))
          cx += ' dan2='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_1,13,2)))
          cx += ' dan3='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_3,13,2)))
          cx += ' dic_dod='
           cx += fVAR(AllTrim(dphkohitx->cDicZakl))
          cx += ' duzp='
           cx += fVAR(dtoc(dphkohitx->dvystfak))
          cx += ' kod_pred_pl='
           cx += fVAR(AllTrim(dphkohitx->ctyppredan))
          cx += ' zakl_dane1='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_2,13,2)))
          cx += ' zakl_dane2='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_1,13,2)))
          cx += ' zakl_dane3='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_3,13,2)))

        case dphkohitx->cOddilKoHl = 'B.2'
          cx := '       <VetaB2'
          cx += ' c_evid_dd='
           cx += fVAR(AllTrim(dphkohitx->cdandoklad))
          cx += ' c_radku='
           cx += fVAR(AllTrim(Str(dphkohitx->nradek,6)))
          cx += ' dan1='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_2,13,2)))
          cx += ' dan2='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_1,13,2)))
          cx += ' dan3='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_3,13,2)))
          cx += ' dic_dod='
           cx += fVAR(AllTrim(dphkohitx->cDicZakl))
          cx += ' dppd='
           cx += fVAR(dtoc(dphkohitx->dvystfak))
          cx += ' pomer='
           cx += fVAR(if(dphkohitx->lPouzPomer,'A','N'))
          cx += ' zakl_dane1='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_2,13,2)))
          cx += ' zakl_dane2='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_1,13,2)))
          cx += ' zakl_dane3='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_3,13,2)))
          cx += ' zdph_44='
           cx += fVAR(if( Empty(dphkohitx->cParagr44),'N', AllTrim(dphkohitx->cParagr44)))

        case dphkohitx->cOddilKoHl = 'B.3'
          cx := '       <VetaB3'
          cx += ' dan1='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_2,13,2)))
          cx += ' dan2='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_1,13,2)))
          cx += ' dan3='
           cx += fVAR(AllTrim(Str(dphkohitx->nsazdan_3,13,2)))
          cx += ' zakl_dane1='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_2,13,2)))
          cx += ' zakl_dane2='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_1,13,2)))
          cx += ' zakl_dane3='
           cx += fVAR(AllTrim(Str(dphkohitx->nzakldan_3,13,2)))

        endcase
        cx += '/>'
        cx += CRLF
        FWrite( nHandle, cx)

      endif
      dphkohitx->( dbSkip())
    enddo

    cx := '      <VetaC'
    cx += ' celk_zd_a2='
     cx += fVAR(AllTrim(Str(dphkohhd->nSumDaP313,13,2)))
    cx += ' obrat23='
     cx += fVAR(AllTrim(Str(dphkohhd->nSumDaP01,13,2)))
    cx += ' obrat5='
     cx += fVAR(AllTrim(Str(dphkohhd->nSumDaP02,13,2)))
    cx += ' pln23='
     cx += fVAR(AllTrim(Str(dphkohhd->nSumDaP40,13,2)))
    cx += ' pln5='
     cx += fVAR(AllTrim(Str(dphkohhd->nSumDaP41,13,2)))
    cx += ' pln_rez_pren='
     cx += fVAR(AllTrim(Str(dphkohhd->nSumDaP25,13,2)))
    cx += ' rez_pren23='
     cx += fVAR(AllTrim(Str(dphkohhd->nSumDaP10,13,2)))
    cx += ' rez_pren5='
     cx += fVAR(AllTrim(Str(dphkohhd->nSumDaP11,13,2)))

    cx += '/>'
    cx += CRLF
    FWrite( nHandle, cx)

    cx := '  </DPHKH1>' + CRLF
    FWrite( nHandle, cx)
    cx := '</Pisemnost>'
    FWrite( nHandle, cx)

    FClose( nHandle )
    drgMsgBox(drgNLS:msg('XML soubor byl vytvoøen'), XBPMB_INFORMATION)
  endif

return( nil)


// Export tržeb - finanèní pokladna - EET od 12/2016  - formát ServiceSOAP - XML
function DIST000112( oxbp, filein) // oxbp = drgDialog
  local tm
  local ctm
  local cx
  local ok
  local nit, ny, cp, cj
  local file
  local nHandle
  local nPlainText
  local nBodyText
  local inDir
  local cdic

  local  oEet

  local adresa_HTTPS
  local name_cert
  local path_cert
  local file_cert
  local pass_cert
  local out_cert
  local typ_zprac

  local cid_signature
  local cid_reference
  local cid_keyinfo

  local crun, cparam
  local cpublkey
  local cx_body, cbodySign
  local nbeg, nend
  local nkeypem, ckeycrt
  local npkp, nbkp
  local cpkp, cbkp, cfik, lprvnizas
  local cidprovoz, cidpokl
  local cdat_prij, cdat_trzby, cdat_odesl
  local mError
  local aDPH := {0,0,0,0,0,0,0}

  adresa_HTTPS := AllTrim(odata_datKom:AdresaHTTPS)
  name_cert    := AllTrim(odata_datKom:NazevCert)
  path_cert    := AllTrim(retDir(odata_datKom:PathCert))
  file_cert    := AllTrim(odata_datKom:FileCert)
  pass_cert    := AllTrim(odata_datKom:PassCert)
  time_out     := AllTrim(odata_datKom:TimeOut)
  typ_zprac    := AllTrim(odata_datKom:typZprac)
  cidprovoz    := AllTrim(odata_datKom:OznProvozu)
  cidpokl      := AllTrim(odata_datKom:OznZarizeni)

//  drgDump( typ_zprac + ',' + cidprovoz + ',' + cidpokl + ',' + pass_cert)

  cdic         := AllTrim(myFirmaAtr('cdic'))
  cdat_trzby   := mh_DateTimeXML()

  lprvnizas    := .t.

  if Empty(filein)
    filein :=  AllTrim( Lower( oxbp:dbname))
  endif
//  cid_security := xbCreateGuid()
//  file := selFILE('EETServiceSOAP_P_'+ctm,'Xml',inDir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

  if filein = 'pokladhd' .or. filein = 'poklhd'
    drgDBMS:open( filein,,,,,filein +'x' )
    filter := format( "sid = %%", { (filein)->sid})
//        filter := format( "cfic = ''"  ,{} )

    filein := filein +'x'
    (filein)->( ads_setAof( filter ), dbgoTop())
  endif

  aDPH[1] := (filein)->nOsvOdDan
  aDPH[2] := (filein)->nZaklDan_2
  aDPH[3] := (filein)->nSazDan_2
  aDPH[4] := (filein)->nZaklDan_1
  aDPH[5] := (filein)->nSazDan_1
  aDPH[6] := (filein)->nZaklDan_3
  aDPH[7] := (filein)->nSazDan_3

  if filein = 'pokladhdw'
    drgDBMS:open( 'fakvyshd',,,,,'fakvyshdx' )
//    drgDBMS:open( 'pokladit',,,,,'pokladitx' )

    pokladitw->( dbGoTop())
    do while .not. pokladitw ->( Eof())
      if pokladitw->ncisfak <> 0
        if fakvyshdx->( dbSeek( pokladitw->ncisfak,,'FODBHD1'))
          aDPH[1] += fakvyshdx->nOsvOdDan
          aDPH[2] += fakvyshdx->nZaklDan_2
          aDPH[3] += fakvyshdx->nSazDan_2
          aDPH[4] += fakvyshdx->nZaklDan_1
          aDPH[5] += fakvyshdx->nSazDan_1
          aDPH[6] += fakvyshdx->nZaklDan_3
          aDPH[7] += fakvyshdx->nSazDan_3
        endif
      endif
      pokladitw->( dbSkip())
    enddo
    pokladitw->( dbGoTop())
  endif

  if .not. Empty((filein)->cbkp) .and. .not. Empty((filein)->cfik)
    lprvnizas := .f.
  endif

  do case
  case typ_zprac = '1'    // zpracování pomocí knihovny JADU
    oEet := CreateObject( "JADU.EET" )
    oEet:SetUrl    := adresa_HTTPS
    oEet:CertHeslo := pass_cert
    oEet:TimeOut   := Val(time_out)
    oEet:Rezim     := (filein)->nRezimEET
    oEet:Overeni   := .f.

    oEet:CertSb    := path_cert + file_cert

    if isWorkVersion
      oEet:DIC       := 'CZ00000019'
      oEet:idprovoz  := AllTrim(cidprovoz)
      oEet:idpokl    := AllTrim(cidpokl)
    else
      oEet:DIC       := cdic
      oEet:idprovoz  := AllTrim(cidprovoz)
      oEet:idpokl    := AllTrim(cidpokl)
    endif

    cx := oEet:Trzba(AllTrim((filein)->cuuid_zpra),    ;
                      lprvnizas,                       ;
                      AllTrim(Str((filein)->ndoklad)), ;
                      cdat_trzby,                      ;
                      ,                                ;
                      (filein)->nCenZakCel,            ;
                      aDPH[1],                         ;
                      aDPH[2],                         ;
                      aDPH[3],                         ;
                      aDPH[4],                         ;
                      aDPH[5],                         ;
                      aDPH[6],                         ;
                      aDPH[7],                         ;
                      (filein)->nCest_Sluz,            ;
                      (filein)->nPouz_Zbo2,            ;
                      (filein)->nPouz_Zbo1,            ;
                      (filein)->nPouz_Zbo3,            ;
                      (filein)->nUrcCerZuc,            ;
                      (filein)->nCerpZuct               )

    cpkp       := oEet:PKP
    cbkp       := oEet:BKP
    if isWorkVersion .and. oEet:FIK = ''
      cfik       := 'test fik'
    else
      cfik       := oEet:FIK
    endif

    cdat_odesl := oEet:EETinOff
    cdat_prij  := oEet:EEToutOff
    mError     := oEet:Chyba_Text
    drgDump( oEet:Zprava )
//    drgDump( oEet:Exception )

  case typ_zprac = '2'
    nPlainText := FCreate( drgINI:dir_USERfitm +'plaintext.txt' )
    file := 'EETServiceSOAP_P_'+ cdic +'.xml'
    if .not. Empty(drgINI:dir_USERfitm +file)
    endif
  endcase

  if filein = 'pokladhdx' .or. filein = 'poklhdx'
    if (filein)->( dbRlock())
      (filein)->cid_provoz := cidprovoz
      (filein)->cid_pokl   := cidpokl
      (filein)->mpkp       := cpkp
      (filein)->cbkp       := cbkp
      (filein)->cfik       := cfik
      (filein)->cdat_trzby := cdat_trzby
      (filein)->cdat_odesl := cdat_odesl
      (filein)->cdat_prij  := cdat_prij
      (filein)->mErrorEET  := mError
      (filein)->(dbUnlock())
    endif
  else
    (filein)->cid_provoz := cidprovoz
    (filein)->cid_pokl   := cidpokl
    (filein)->mpkp       := cpkp
    (filein)->cbkp       := cbkp
    (filein)->cfik       := cfik
    (filein)->cdat_trzby := cdat_trzby
    (filein)->cdat_odesl := cdat_odesl
    (filein)->cdat_prij  := cdat_prij
    (filein)->mErrorEET  := mError
  endif


return( nil)


// Hromadný export tržeb - EET od 12/2016  - formát ServiceSOAP - XML i SERVICE
function DIST000113( oxbp) // oxbp = drgDialog
  local tm
  local ctm
  local cx
  local ok
  local nit, ny, cp, cj, n
  local file
  local nHandle
  local nPlainText
  local nBodyText
  local inDir
  local cdic

  local  oEet

  local adresa_HTTPS
  local name_cert
  local path_cert
  local file_cert
  local pass_cert
  local out_cert
  local typ_zprac

  local cid_signature
  local cid_reference
  local cid_keyinfo

  local crun, cparam
  local cpublkey
  local cx_body, cbodySign
  local nbeg, nend
  local nkeypem, ckeycrt
  local npkp, nbkp
  local cpkp, cbkp, cfik, lprvnizas
  local cidprovoz, cidpokl
  local cdat_prij, cdat_trzby, cdat_odesl
  local mError


  adresa_HTTPS := AllTrim(odata_datKom:AdresaHTTPS)
  name_cert    := AllTrim(odata_datKom:NazevCert)
  path_cert    := AllTrim(retDir(odata_datKom:PathCert))
  file_cert    := AllTrim(odata_datKom:FileCert)
  pass_cert    := AllTrim(odata_datKom:PassCert)
  time_out     := AllTrim(odata_datKom:TimeOut)
  typ_zprac    := AllTrim(odata_datKom:typZprac)

  cdic         := AllTrim(myFirmaAtr('cdic'))


//  cid_security := xbCreateGuid()
//  file := selFILE('EETServiceSOAP_P_'+ctm,'Xml',inDir,'Výbìr souboru pro export',{{"XML soubory", "*.XML"}})

  for n := 1 to 2
    filein := if( n = 1, 'pokladhd', 'poklhd')
    drgDBMS:open( filein,,,,,filein +'x' )
    filter := format( "nPokladEET = 1 and cfik = ''", {})
//        filter := format( "ndoklad = 1721082"  ,{} )

    filein := filein +'x'
    (filein)->( ads_setAof( filter ), dbgoTop())

    do while .not. (filein)->( Eof())
      lprvnizas  := .t.
//      cdat_trzby := mh_DateTimeXML()

      if .not. Empty((filein)->cbkp) .and. .not. Empty((filein)->cfik)
        lprvnizas := .f.
      endif

      do case
      case typ_zprac = '1'    // zpracování pomocí knihovny JADU
        oEet := CreateObject( "JADU.EET" )
        oEet:SetUrl    := adresa_HTTPS
        oEet:CertHeslo := pass_cert
        oEet:TimeOut   := Val(time_out)
        oEet:Rezim     := (filein)->nRezimEET
        oEet:Overeni   := .f.

        oEet:CertSb    := path_cert + file_cert

        oEet:DIC       := cdic
        oEet:idprovoz  := AllTrim((filein)->cid_provoz)
        oEet:idpokl    := AllTrim((filein)->cid_pokl)

        cx := oEet:Trzba(AllTrim((filein)->cuuid_zpra),    ;
                          lprvnizas,                             ;
                          AllTrim(Str((filein)->ndoklad)), ;
                          AllTrim((filein)->cdat_trzby),   ;
                          AllTrim((filein)->cdat_odesl),   ;
                          (filein)->nCenZakCel,            ;
                          (filein)->nOsvOdDan,             ;
                          (filein)->nZaklDan_2,            ;
                          (filein)->nSazDan_2,             ;
                          (filein)->nZaklDan_1,            ;
                          (filein)->nSazDan_1,             ;
                          (filein)->nZaklDan_3,            ;
                          (filein)->nSazDan_3,             ;
                          (filein)->nCest_Sluz,            ;
                          (filein)->nPouz_Zbo2,            ;
                          (filein)->nPouz_Zbo1,            ;
                          (filein)->nPouz_Zbo3,            ;
                          (filein)->nUrcCerZuc,            ;
                          (filein)->nCerpZuct               )

        cfik       := oEet:FIK

//        cdat_odesl := oEet:EETinOff
//        cdat_prij  := oEet:EEToutOff
        mError     := oEet:Chyba_Text
//        drgDump( oEet:Zprava )
        drgDump( oEet:Exception )

      case typ_zprac = '2'
        nPlainText := FCreate( drgINI:dir_USERfitm +'plaintext.txt' )
        file := 'EETServiceSOAP_P_'+ cdic +'.xml'
        if .not. Empty(drgINI:dir_USERfitm +file)
        endif
      endcase

      if (filein)->( dbRlock())
//        (filein)->mpkp       := cpkp
//        (filein)->cbkp       := cbkp
        (filein)->cfik       := cfik
//        (filein)->cdat_trzby := cdat_trzby
//        (filein)->cdat_odesl := cdat_odesl
        (filein)->cdat_prij  := cdat_prij
        (filein)->mErrorEET  += mError
//        drgDump( oEet:Zprava )
        drgDump( oEet:Exception )
        (filein)->(dbUnlock())
      endif

      (filein)->(dbSkip())
    enddo

    (filein)->( Ads_ClearAof())
    (filein)->( dbCloseArea())
  next

return( nil)