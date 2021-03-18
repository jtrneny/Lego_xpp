//////////////////////////////////////////////////////////////////////
//
//  Personal.CH
//
//  Copyright:
//           , (c) 2003. All rights reserved.
//
//  Contents:
//           Resource ID definitions for the Personal program
//
//////////////////////////////////////////////////////////////////////

#include "..\Asystem++\Asystem++.ch"
// #include "ASystem++.ch"
/*
 * ICONS
 */

/***
#DEFINE  ICON_REBATE      10
#DEFINE  ICON_SEARCH      11
#DEFINE  ICON_PAY         12
#DEFINE  ICON_BASKET      13

#DEFINE  MIS_ICON_OK     300
#DEFINE  MIS_ICON_ERR    301
#DEFINE  MIS_BOOK        302
#DEFINE  MIS_BOOKOPEN    303
#DEFINE  MIS_PLUS        304
#DEFINE  MIS_MINUS       305
#DEFINE  MIS_EQUAL       314
#DEFINE  MIS_EDIT        315

#DEFINE  BANVYPIT_1      306
#DEFINE  BANVYPIT_2      307
#DEFINE  BANVYPIT_3      308
#DEFINE  BANVYPIT_4      309
#DEFINE  BANVYPIT_5      310
#DEFINE  BANVYPIT_6      311
#DEFINE  BANVYPIT_7      312
#DEFINE  BANVYPIT_8      313

// pro INFO
#DEFINE  H_big           320
#DEFINE  H_low           321
#DEFINE  P_big           322
#DEFINE  P_low           323
#DEFINE  D_big           324
#DEFINE  L_big           325
#DEFINE  L_low           326
#DEFINE  U_big           327
#DEFINE  U_low           328
#DEFINE  T_big           329


// POU�ITO z DOSu
# Define   DBGetVal(c)     Eval( &("{||" + c + "}"))
# Define   DBPutVal(c,x)   ( &(c) := x )
# Define   COMPILE(c)      &("{||" + c + "}")
# xTranslate CMPItem( <nVal>, <cPic>) => Val( TransForm( <nVal>, <cPic>))
# Translate  Equal( < cStr_1 >, < cStr_2>) => ;
             ( Upper( AllTrim( < cStr_1>) ) == Upper( AllTrim( < cStr_2>) ) )
***/


// N�HRADA pro INFO_SCR //
#define   _FIN_main  ;
  { {'FAKPRIHD', {"FAKPRIHD ->nCISFAK"              , ;
                  "FAKPRIHD ->nCENZAKCEL"           , ;
                  "FAKPRIHD ->nUHRCELFAK"           , ;
                  "FAKPRIHD ->nPRIUHRCEL"           , ;
                  "Upper( FAKPRIHD ->cOBDOBIDAN)"   , ;
                  "If( FakPriHD ->nFinTYP == 3 .or. FakPriHD ->nFinTYP == 5,'x', FakPriHD ->nLikCelFAK)", ;
                  "Upper( FakPriHD ->cUloha +FakPriHD ->cObdobi)", ;
                  " "                               , ;
                  "?? ? "                           , ;
                  "SysCONFIG('FINANCE:nRangeFAPR')" , ;
                  "1", ;
                  "FPRIHD19", ;
                  "FAKPRIHP ->nROK"                   } }, ;
    {'FAKVYSHD', {"FAKVYSHD ->nCisFAK"             , ;
                  "FAKVYSHD ->nCenZakCEL"          , ;
                  "FAKVYSHD ->nUhrCelFAK"          , ;
                  "FAKVYSHD ->dDatTISK"            , ;
                  "UPPER(FAKVYSHD ->cObdobiDAN)"   , ;
                  "If(FAKVYSHD ->nFINTYP == 2 .or. FAKVYSHD ->nFINTYP == 4,'�', FAKVYSHD ->nLIKCELFAK)", ;
                  "UPPER(FAKVYSHD ->cULOHA +FAKVYSHD ->cOBDOBI)", ;
                  " "                                  , ;
                  "?? ? "                              , ;
                  "SYSCONFIG('FINANCE:nRANGEFAVY')"    , ;
                  "1"                                  , ;
                  "FODBHD22"                           , ;
                  "FAKVYSHP ->nROK"                      } }, ;
    {'BANVYPHD', {"BanVypHD ->nDOKLAD"   , ;
                  "BanVypHD ->nPRIJEM"   , ;
                  "BanVypHD ->nVYDEJ"    , ;
                  "BanVypHD ->nPOSZUST"  , ;
                  "BanVypHD ->nLIKCELPRI", ;
                  "BanVypHD ->nLIKCELVYD", ;
                  "UPPER( BanVypHD ->cUloha +BanVypHD ->cObdobi)", ;
                  "", ;
                  "? ", ;
                  "SysCONFIG('FINANCE:nRangeBANK')", ;
                  "1"                                } }, ;
    {'POKLADHD', {"PokladHD ->nDOKLAD"   , ;
                  "PokladHD ->nCenZakCEL", ;
                  "PokladHD ->nAKTSTAV"  , ;
                  "PokladHD ->dDATTISK"  , ;
                  "UPPER( PokladHD ->cObdobiDAN)", ;
                  "PokladHD ->nLIKCELDOK", ;
                  "UPPER( PokladHD ->cUloha +PokladHD ->cObdobi)", ;
                  "", ;
                  "? ? ", ;
                  "SysCONFIG('FINANCE:nRangeFIPO')", ;
                  "1", ;
                  "POKLAD11", ;
                  "POKLADHP ->nROK"                  } }, ;
    {'UCETDOHD', {"UcetDOHD ->nDOKLAD"   , ;
                  "UcetDOHD ->nCENZAKCEL", ;
                  "UcetDOHD ->nCENZAKCEL", ;
                  "UcetDOHD ->dDATTISK"  , ;
                  "UPPER( UcetDOHD ->cOBDOBIDAN)", ;
                  "UcetDOHD ->nLIKCELDOK", ;
                  "UPPER( UcetDOHD ->cULOHA +UcetDOHD ->cOBDOBI)", ;
                  "", ;
                  "? ? ", ;
                  "SYSCONFIG('FINANCE:nRangeFIDO')", ;
                  "1", ;
                  "UCETDH_6", ;
                  "UCETDOHP ->nROK"                  } }, ;
    {'FAKVNPHD', {"FAKVNPHD ->nCISFAK" , ;
                  "FAKVNPHD ->nCENZAKCEL", ;
                  "FAKVNPHD ->nCENZAKCEL", ;
                  "FAKVNPHD ->dDATTISK", ;
                  "Upper( FAKVNPHD ->cOBDOBI)", ;
                  "FAKVNPHD ->nLIKCELFAK", ;
                  "Upper( FAKVNPHD ->cULOHA +FAKVNPHD ->cOBDOBI)", ;
                  " ", ;
                  "?? ", ;
                  "SysCONFIG('FINANCE:nRANGEvnpF')", ;
                  "1", ;
                  "FODBHD9", ;
                  "FAKvnpHP ->nROK"                  } }, ;
   {'DODLSTHD',  {"DODLSTHD->ndoklad"                                                               , ;
                  "DODLSTHD->ncenzakcel"                                                            , ;
                  "DODLSTHD->nuhrcelfak"                                                            , ;
                  "DODLSTHD->ddattisk"                                                              , ;
                  "('99/99')"                                                                       , ;
                  "if(DODLSTHD->nfintyp == 2 .or. DODLSTHD->nfintyp == 4,'x', DODLSTHD->nlikcelfak)", ;
                  "('E99/99')"                                                                      , ;
                  "     "                                                                           , ;
                  " "                                                                               , ;
                  "sysconfig('sklady:nrangedoli')"                                                  , ;
                  "1"                                                                                 } }, ;
   {'UCTDOKHD', { "UCTDOKHD ->nDOKLAD"                           , ;
                  "UCTDOKHD ->nCENZAKCEL"                        , ;
                  "UCTDOKHD ->nCENZAKCEL"                        , ;
                  "UCTDOKHD ->dDATTISK"                          , ;
                  ""                                             , ;
                  "UCTDOKHD ->nLIKCELDOK"                        , ;
                  "UPPER( UCTDOKHD ->cULOHA +UCTDOKHD ->cOBDOBI)", ;
                  "      "                                       , ;
                  "? ?  ?"                                       , ;
                  "SYSCONFIG('UCTO:nRANGEUCDO')"                 , ;
                  "1"                                              } } , ;
   {'POKLHD'  , { "POKLHD ->nCisFAK"                             , ;
                  "POKLHD ->nCenZakCEL"                          , ;
                  "POKLHD ->nUhrCelFAK"                          , ;
                  "POKLHD ->dDatTISK"                            , ;
                  "UPPER(POKLHD ->cObdobiDAN)"                   , ;
                  "If(POKLHD ->nFINTYP == 2 .or. POKLHD ->nFINTYP == 4,'�', POKLHD ->nLIKCELFAK)", ;
                  "UPPER(POKLHD ->cULOHA +POKLHD ->cOBDOBI)"     , ;
                  " "                                            , ;
                  "?? ? "                                        , ;
                  "SYSCONFIG('PRODEJ:nRANGEREPO')"              , ;
                  "1"                                            , ;
                  "FODBHD22"                                     , ;
                  "POKLHDw ->nROK"                                 } } }


#xtranslate  .pKEY   =>  \[ 1\]
#xtranslate  .pCEL   =>  \[ 2\]
              #xtranslate  .pDEB    =>  \[ 2\]
#xtranslate  .pUHR   =>  \[ 3\]
              # xtranslate  .pKRE    =>  \[ 3\]
#xtranslate  .pPRIK   =>  \[ 4\]
              # xtranslate  .pTISK   =>  \[ 4\]
#xtranslate  .pDUZ   =>  \[ 5\]
              # xtranslate  .pLIKDEB =>  \[ 5\]
#xtranslate  .pLIK   =>  \[ 6\]
              #xtranslate  .pLIKKRE =>  \[ 6\]
#xtranslate  .pUUZ   =>  \[  7\]
#xtranslate  .pDEF   =>  \[  8\]
#xtranslate  .pKEYm  =>  \[ 10\]
#xtranslate  .pTAGm  =>  \[ 11\]


// N�HRADA pro RANGE //
#define   _FIN_range  ;
{ { "FAKPRIHD"       , "FAKTURY P�IJAT�"           , "NCISFAK"   , "FPRIHD1"                , ;
    "SYSconfig('FINANCE:nRANGEfapr')", "FAKPRIHDw"                                         }, ;
  { "PRIKUHHD"       , "P��KAZY K �HRAD�"          , "NDOKLAD"   ,        1                }, ;
  { "FAKVYSHD"       , "FAKTURY VYSTAVEN�"         , "NCISFAK"   , "FODBHD1"                , ;
    "SYSconfig('FINANCE:nRANGEfavy')", "FAKVYSHDw"                                         }, ;
  { "POKLADHD"       , "POKLADN� DOKLADY"          , "NDOKLAD"   , "POKLADH1"               , ;
    "SYSconfig('FINANCE:nRANGEfipo')", "POKLADHDw"                                         }, ;
  { "UCETDOHD:vd"    , "��ETN� DOKLADY"            , "NDOKLAD"   , "UCETDH_1"               , ;
    "SYSconfig('FINANCE:nRANGEfido')", "UCETDOHDw" ,  4, "SYSconfig('FINANCE:cDENIKfido')" }, ;
  { "UPOMINHD"   , "DOKLADY UPOM�NEK"              , "NCISUPOMIN",        1                }, ;
  { "FAKVNPHD"   , "VNITRO-FAKTURY"                , "NCISFAK"   , "FODBHD1"                , ;
    "SYSconfig('FINANCE:nRANGEvnpf')", "FAKVNPHDw"                                         }, ;
  { "UCETDOHD:pz", "FINAN�N� ��ETN� DOKLADY_pz"    , "NDOKLAD"   , "UCETDH_1"               , ;
    "SYSconfig('FINANCE:nRANGEfdpz')", "UCETDOHDw" ,  4, "SYSconfig('FINANCE:cDENIKfdpz')" }, ;
  { "UCETDOHD:vz", "FINAN�N� ��ETN� DOKLADY_vz"    , "nDoklad"   , "UCETDH_1"               , ;
    "SYSconfig('FINANCE:nRANGEfdvz')", "UCETDOHDw" ,  4, "SYSconfig('FINANCE:cDENIKfdvz')" }, ;
  { "DODLSTHD"       , "DODAC� LISTY VYDAN�"       , "NDOKLAD"   , "DODLHD1"                , ;
    "SYSconfig('SKLADY:nRANGEDOLI')", "DODLSTHDw"                                          }, ;
  { "PVPHEAD"                       , ;
    "POHYBOV� DOKLADY-V�DEJ"        , ;
    "NDOKLAD"                       , ;
    "PVPHEAD01"                     , ;
    "sysconfig('sklady:nrangevypr')", ;
    "PVPHEADw"                      , ;
                                    , ;
                                    , ;
                                    , ;
    "ntyppoh = 2"                                                                          }, ;
  { "UCTDOKHD"       , "��ETN� DOKLADY"            , "NDOKLAD"   , "UCETDH_1"               , ;
    "SYSconfig('UCTO:nRangeUCDO')", "UCTDOKHDw" , 4, "SYSconfig('UCTO:cDenikUCDO')"        }, ;
  { "POKLHD"                        , ;
    "REGISTRA�N� POKLADNA"          , ;
    "NCISFAK"                       , ;
    "POKLHD3"                       , ;
    "SYSconfig('PRODEJ:nRANGEREPO')", ;
    "POKLHDw"                       , ;
                                    , ;
    "SYSCONFIG('PRODEJ:nCISREGPOK')", ;
                                    , ;
                                    , ;
    "nkasa = %%"                                                                           }, ;
  { "OBJHEAD"                       , ;
    "OBJEDN�VKY P�IJAT�"            , ;
    "NDOKLAD"                       , ;
    "OBJHEAD7"                      , ;
    "sysconfig('prodej:nrangeobjp')", ;
    "OBJHEADw"                      , ;
                                    , ;
                                    , ;
                                    , ;
    "nextObj = 1"                                                                          }, ;
  { "OBJVYSHD"                      , ;
    "OBJEDN�VKY VYSTAVEN�"          , ;
    "NDOKLAD"                       , ;
    "OBJDODH6"                      , ;
    "sysconfig('nakup:nrangeobjv')" , ;
    "OBJVYSHDw"                                                                            }, ;
  { "EXPLSTHD"                      , ;
    "EXPEDI�N� LISTY"               , ;
    "NDOKLAD"                       , ;
    "EXPLSTHD01"                    , ;
    "sysconfig('prodej:nrangeexpl')", ;
    "EXPLSTHDw"                                                                            }, ;
  { "NABVYSHD"                      , ;
    "NAB�DKY VYSTAVEN�"             , ;
    "NDOKLAD"                       , ;
    "NABVYSH4"                      , ;
    "sysconfig('prodej:nrangenab')" , ;
    "NAVYSHDW"                                                                             }, ;
  { "NABPRIHD"                      , ;
    "MAB�DKY P�IJAT�"               , ;
    "NDOKLAD"                       , ;
    "NABPRIH4"                      , ;
    "sysconfig('nakup:nrangenab')"  , ;
    "NABPRIHDW"                                                                            }, ;
  { "DODLSTPHD"      , "DODAC� LISTY P�IJAT�"      , "NDOKLAD"   , "DODLHD1"                , ;
    "SYSconfig('NAKUP:nRANGEDOLI')", "DODLSTPHDw"                                          }, ;
  { "MZDDAVHD:mh"                  , ;
    "MZDOV� D�VKY - hrub� mzdy"    , ;
    "NDOKLAD"                      , ;
    "MZDDAVHD11"                   , ;
    "SYSconfig('MZDY:nrangeMZ_H')" , ;
    "MZDDAVHDw"                    , ;
    "MZDDAVHD10"                   , ;
    "SYSconfig('MZDY:cdenikMZ_H')"                                                         }, ;
  { "MZDDAVHD:ms"                  , ;
    "MZDOV� D�VKY - sr�ky"        , ;
    "NDOKLAD"                      , ;
    "MZDDAVHD11"                   , ;
    "SYSconfig('MZDY:nrangeMZ_S')" , ;
    "MZDDAVHDw"                    , ;
    "MZDDAVHD10"                   , ;
    "SYSconfig('MZDY:cdenikMZ_S')"                                                         }, ;
  { "MZDDAVHD:mn"                  , ;
    "MZDOV� D�VKY - nemocenky"     , ;
    "NDOKLAD"                      , ;
    "MZDDAVHD11"                   , ;
    "SYSconfig('MZDY:nrangeMZ_N')" , ;
    "MZDDAVHDw"                    , ;
    "MZDDAVHD10"                   , ;
    "SYSconfig('MZDY:cdenikMZ_N')"                                                         }, ;
  { "MZDDAVHD:vy"                  , ;
    "MZDOV� D�VKY - hrub� mzdy_vyr", ;
    "NDOKLAD"                      , ;
    "MZDDAVHD11"                   , ;
    "SYSconfig('MZDY:nrangeMZ_V')" , ;
    "MZDDAVHDw"                    , ;
    "MZDDAVHD10"                   , ;
    "SYSconfig('MZDY:cdenikMZ_V')"                                                         }  }



#xtranslate  .FILEm  => \[ 1\]       // SOUBOR   MAIN
#xtranslate  .TEXTm  => \[ 2\]       // N�ZEV    SOUBORU
#xtranslate  .KEYm   => \[ 3\]       // KL��     SOUBOR
#xtranslate  .TAGm   => \[ 4\]       // TAG      SOUBORU
#xtranslate  .CFGm   => \[ 5\]       // CONFIG   SOUBORU
#xtranslate  .FILEw  => \[ 6\]       // SOUBOR   TMP
#xtranslate  .TAGr   => \[ 7\]       // TAG      RYO
#xtranslate  .DENIKr => \[ 8\]       // DENIK    RYO
#xtranslate  .KEYp   => \[10\]       // PRIM�RN� KL�� SOUBORU
#xtranslate  .KEYex  => \[11\]       // KL�C     PRO RYO


