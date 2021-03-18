#define  _CARGO ;
{ 'cOBD_OD'  , 'cOBD_DO'  , 'cOBD_PSn', 'cOBD_ODn', 'cOBD_DOn', ;
  'aCFGs'    , ;
  'cUSERABB' , ;
  'cDirEXP'  , 'cPathEXP' , 'cDiskEXP', ;
  'aUCETERRI', 'lIsERRs'  , 'lIsZAL'  , 'nLEVLs', ;
  'lAUTO_NV' , 'lAUTO_VR' , 'lAUTO_SR', 'lAUTO_ZR', 'lIsAUTO', 'lDELAUTO', ;
  'aOBD_AKT' , ;
  'aFILE_EXP', ;
  'nRYO_AUTA', ;
  'nKEY_auto', ;
  'lIsEXCL'  , ;
  'aAUTO_VY' , ;
  'aDENIKY'    }


# xTRANSLATE .text        => pa\[1 \]
# xTRANSLATE .group       => pa\[2 \]
# xTRANSLATE .root        => pa\[3 \]
# xTRANSLATE .sets        => pa\[4 \]
# xTRANSLATE .methods     => pa\[5 \]
# xTRANSLATE .conds       => pa\[6 \]

*
** kontrola dat
# xtranslate .task       =>  pc\[ 1\]
# xtranslate .menu_item  =>  pc\[ 2\]
# xtranslate .menu_name  =>  pc\[ 3\]
# xtranslate .menu_levl  =>  pc\[ 4\]
# xtranslate .file       =>  pc\[ 6, 1, 1\]
# xtranslate .file_tag   =>  pc\[ 6, 1, 2, 1\]
# xtranslate .denik      =>  pc\[ 6, 1, 2, 2\]
# xtranslate .doklad     =>  pc\[ 6, 1, 2, 4\]
# xtranslate .errs       =>  pc\[ 6, 1, 2, 9\]
# xtranslate .file_denik =>  pc\[ 6, 1, 2,10\]



**FINANCE**
#define  _UCTDOKHD  ;
{ "UCTO.EXE"                                                      , ;
    "dle ~Úèetnictví       "                                        , ;
    " ··· pøehled úèetních záznamù modulu ÚÈTO ···"                 , ;
    1                                                               , ;
    NIL                                                             , ;
    { { "UCTDOKHD"                                                , ;
        { "UCTDOKHD,5"                                          , ;
          "UCTO:cDenikUCDO"                                     , ;
          "Úèt _ÚèDOKLAD  "                                     , ;
          "UctDokHD ->nDoklad"                                  , ;
          "UctDokHD ->nCenZakCEL"                               , ;
          "UctDokHD ->nLikCelDOK"                               , ;
          NIL                                                   , ;
          NIL                                                   , ;
          { "UcetERRw ->cULOHA     := UctDokHD ->cULOHA"      , ;
            "UcetERRw ->cOBDOBI    := UctDokHD ->cOBDOBI"     , ;
            "UCETERRw ->nROK       := UCTDOKHD ->nROK"        , ;
            "UCETERRw ->nOBDOBI    := UCTDOKHD ->nOBDOBI"     , ;
            "UcetERRw ->cTASKs     := ('Úèt _ÚèDOKLAD  ')"    , ;
            "UcetERRw ->cDENIK     := UctDokHD ->cDENIK"      , ;
            "UcetERRw ->cDENIK_CFG := ('UCTO:cDenikUCDO')"    , ;
            "UcetERRw ->nDOKLAD    := UctDokHD ->nDOKLAD"     , ;
            "UcetERRw ->cVARSYM    := UctDokHD ->cVARSYM"     , ;
            "UcetERRw ->cTextDOK   := UctDokHD ->cTextDOK"    , ;
            "UcetERRw ->nCenZakCEL := UctDokHD ->nCenZakCEL"  , ;
            "UcetERRw ->nLikCelDOK := UctDokHD ->nLikCelDOK"  , ;
            "UcetERRw ->nKLikvid   := UctDokHD ->nKLikvid"    , ;
            "UcetERRw ->nZLikvid   := UctDokHD ->nZLikvid"    , ;
            "UcetERRw ->nKcMD      := (0)"                    , ;
            "UcetERRw ->nKcDAL     := (0)"                    , ;
            "UcetERRw ->dDATUZV    := DATE()"                 , ;
            "UcetERRw ->cERR       := ('0000000')"              ;
          }                                                   , ;
          "UPPER( UCTDOKHD ->cDENIK)"                           ;
        }                                                       , ;
        "Úèetní záznamy ÚÈTO"                                     ;
      }                                                           ;
    }                                                             , ;
    .T.                                                               ;
  }


#define  _FAKPRIHD  ;
{ "FINANCE.EXE"                                                   , ;
    "~Závazky firmy       "                                         , ;
    " ··· pøehled úèetních zázmanù modulu FINANCE_Závazky ···"      , ;
    2                                                               , ;
    NIL                                                             , ;
    { { "FAKPRIHD"                                              , ;
        { "FakPriHD,17"                                         , ;
          "FINANCE:cDenikFAPR"                                  , ;
          "Fin _ZÁVAZKY   "                                     , ;
          "FakPriHD ->nCisFAK"                                  , ;
          "FakPriHD ->nCenZakCEL"                               , ;
          "FakPriHD ->nLikCelFAK"                               , ;
          NIL                                                   , ;
          NIL                                                   , ;
          { "UcetERRw ->cULOHA     := FakPriHD ->cULOHA"      , ;
            "UcetERRw ->cOBDOBI    := FakPriHD ->cOBDOBI"     , ;
            "UCETERRw ->nROK       := FAKPRIHD ->nROK"        , ;
            "UCETERRw ->nOBDOBI    := FAKPRIHD ->nOBDOBI"     , ;
            "UcetERRw ->cTASKs     := ('Fin _ZÁVAZKY   ')"    , ;
            "UcetERRw ->cDENIK     := FakPriHD ->cDENIK"      , ;
            "UcetERRw ->cDENIK_CFG := ('FINANCE:cDenikFAPR')" , ;
            "UcetERRw ->nDOKLAD    := FakPriHD ->nCISFAK"     , ;
            "UcetERRw ->cVARSYM    := FakPriHD ->cVARSYM"     , ;
            "UcetERRw ->cTextDOK   := FakPriHD ->cTextFAKT"   , ;
            "UcetERRw ->nCenZakCEL := FakPriHD ->nCenZakCEL"  , ;
            "UcetERRw ->nLikCelDOK := FakPriHD ->nLikCelFAK"  , ;
            "UcetERRw ->nKLikvid   := FakPriHD ->nKLikvid"    , ;
            "UcetERRw ->nZLikvid   := FakpriHD ->nZLikvid"    , ;
            "UcetERRw ->nKcMD  := (0)"                        , ;
            "UcetERRw ->nKcDAL := (0)"                        , ;
            "UcetERRw ->dDatUZV := DATE()"                    , ;
            "UcetERRw ->cERR := ('0000000')"                    ;
          }                                                   , ;
          "UPPER( FAKPRIHD ->cDENIK)"                           ;
        }                                                       , ;
        "Úèetní záznamy FINANCE_Závazky"                          ;
      }                                                           ;
    }                                                             , ;
    .T.                                                               ;
  }


#define  _FAKVYSHD  ;
{ "FINANCE.EXE"                                                  , ;
    "p~Ohledávky firmy    "                                        , ;
    " ··· pøehled úèetních zázmanù modulu FINANCE_Pohledávky ···"  , ;
    3                                                              , ;
    NIL                                                            , ;
    { { "FAKVYSHD"                                             , ;
        { "FakVysHD,19"                                        , ;
          "FINANCE:cDenikFAVY"                                 , ;
          "Fin _POHLEDÁVKY"                                    , ;
          "FakVysHD ->nCisFAK"                                 , ;
          "FakVysHD ->nCenZakCEL"                              , ;
          "FakVysHD ->nLikCelFAK"                              , ;
          NIL                                                  , ;
          NIL                                                  , ;
          { "UcetERRw ->cULOHA     := FakVysHD ->cULOHA"     , ;
            "UcetERRw ->cOBDOBI    := FakVysHD ->cOBDOBI"    , ;
            "UCETERRw ->nROK       := FAKVYSHD ->nROK"       , ;
            "UCETERRw ->nOBDOBI    := FAKPRIHD ->nOBDOBI"    , ;
            "UcetERRw ->cTASKs     := ('Fin _POHLEDÁVKY')"   , ;
            "UcetERRw ->cDENIK     := FakVysHD ->cDENIK"     , ;
            "UcetERRw ->cDENIK_CFG := ('FINANCE:cDenikFAVY')", ;
            "UcetERRw ->nDOKLAD    := FakVysHD ->nCISFAK"    , ;
            "UcetERRw ->cVARSYM    := FakVysHD ->cVARSYM"    , ;
            "UcetERRw ->cTextDOK   := FakVysHD ->cNAZEV"     , ;
            "UcetERRw ->nCenZakCEL := FakVysHD ->nCenZakCEL" , ;
            "UcetERRw ->nLikCelDOK := FakVysHD ->nLikCelFAK" , ;
            "UcetERRw ->nKLikvid   := FakVysHD ->nKLikvid"   , ;
            "UcetERRw ->nZLikvid   := FakVysHD ->nZLikvid"   , ;
            "UcetERRw ->nKcMD  := (0)"                       , ;
            "UcetERRw ->nKcDAL := (0)"                       , ;
            "UcetERRw ->dDatUZV := DATE()"                   , ;
            "UcetERRw ->cERR := ('0000000')"                   ;
          }                                                  , ;
          "UPPER( FAKVYSHD ->cDENIK)"                          ;
        }                                                      , ;
        "Úèetní záznamy FINANCE_Pohledávky"                      ;
      }                                                          ;
    }                                                            , ;
    .T.                                                              ;
  }


#define  _BANVYPHD  ;
{ "FINANCE.EXE"                                                  , ;
    "~Bankovní vztahy     "                                        , ;
    " ··· pøehled úèetních zázmanù modulu FINANCE_Banka ···"       , ;
    4                                                              , ;
    NIL                                                            , ;
    { { "BANVYPHD"                                             , ;
        { "BANVYPHD,8"                                         , ;
          "FINANCE:cDenikBAVY"                                 , ;
          "Fin _BANKA"                                         , ;
          "BANVYPHD ->nDoklad"                                 , ;
          "BANVYPHD ->nPRIJEM"                                 , ;
          "BANVYPHD ->nLIKcelPRI"                              , ;
          "BanVypHD ->nVYDEJ"                                  , ;
          "BanVypHD ->nLikCelVYD"                              , ;
          { "UcetERRw ->cULOHA := BanVypHD ->cULOHA"         , ;
            "UcetERRw ->cOBDOBI := BanVypHD ->cOBDOBI"       , ;
            "UCETERRw ->nROK    := BANVYPHD ->nROK"          , ;
            "UCETERRw ->nOBDOBI := BANVYPHD ->nOBDOBI"       , ;
            "UcetERRw ->cTASKs := ('Fin _BANKA     ')"       , ;
            "UcetERRw ->cDENIK := BanVypHD ->cDENIK"         , ;
            "UcetERRw ->cDENIK_CFG := ('FINANCE:cDenikBAVY')", ;
            "UcetERRw ->nDOKLAD := BanVypHD ->nDOKLAD"       , ;
            "UcetERRw ->cVARSYM := ('               ')"      , ;
            "UcetERRw ->cTextDOK := BanVypHD ->cBANK_UCT"    , ;
            "UcetERRw ->nCenZakCEL := (BanVypHD ->nPRIJEM +BanVypHD ->nVYDEJ)", ;
            "UcetERRw ->nLikCelDOK := (BanVypHD ->nLikCelPRI +BanVypHD ->nLikCelVYD)", ;
            "UcetERRw ->nKLikvid   := BanVypHD ->nKLikvid"   , ;
            "UcetERRw ->nZLikvid   := BanVypHD ->nZLikvid"   , ;
            "UcetERRw ->nKcMD  := (0)"                       , ;
            "UcetERRw ->nKcDAL := (0)"                       , ;
            "UcetERRw ->dDatUZV := DATE()"                   , ;
            "UcetERRw ->cERR := ('0000000')"                   ;
          }                                                  , ;
          "UPPER( BANVYPHD ->cDENIK)"                          ;
        }                                                      , ;
        "Úèetní záznamy FINANCE_Banka"                           ;
      }                                                          ;
    }                                                            , ;
    .T.                                                              ;
  }


#define  _POKLADHD  ;
{ "FINANCE.EXE"                                                   , ;
    "~Pokladna            "                                         , ;
    " ··· pøehled úèetních zázmanù modulu FINANCE_Pokladna ···"     , ;
    2                                                               , ;
    NIL                                                             , ;
    { { "POKLADHD"                                              , ;
        { "POKLADHD,9"                                          , ;
          "FINANCE:cDenikFIPO"                                  , ;
          "Fin _POKLADNA  "                                     , ;
          "POKLADHD ->nDOKLAD"                                  , ;
          "POKLADHD ->nCenZakCEL"                               , ;
          "POKLADHD ->nLikCelDOK"                               , ;
          NIL                                                   , ;
          NIL                                                   , ;
          { "UcetERRw ->cULOHA     := PokladHD ->cULOHA"      , ;
            "UcetERRw ->cOBDOBI    := PokladHD ->cOBDOBI"     , ;
            "UCETERRw ->nROK       := POKLADHD ->nROK"        , ;
            "UCETERRw ->nOBDOBI    := POKLADHD ->nOBDOBI"     , ;
            "UcetERRw ->cTASKs     := ('Fin _POKLADNA  ')"    , ;
            "UcetERRw ->cDENIK     := PokladHD ->cDENIK"      , ;
            "UcetERRw ->cDENIK_CFG := ('FINANCE:cDenikFIPO')" , ;
            "UcetERRw ->nDOKLAD    := PokladHD ->nDOKLAD"     , ;
            "UcetERRw ->cVARSYM    := PokladHD ->cVARSYM"     , ;
            "UcetERRw ->cTextDOK   := PokladHD ->cTextDOK"    , ;
            "UcetERRw ->nCenZakCEL := PokladHD ->nCenZakCEL"  , ;
            "UcetERRw ->nLikCelDOK := PokladHD ->nLikCelDOK"  , ;
            "UcetERRw ->nKLikvid   := PokladHD ->nKLikvid"    , ;
            "UcetERRw ->nZLikvid   := PokladHD ->nZLikvid"    , ;
            "UcetERRw ->nKcMD  := (0)"                        , ;
            "UcetERRw ->nKcDAL := (0)"                        , ;
            "UcetERRw ->dDatUZV := DATE()"                    , ;
            "UcetERRw ->cERR := ('0000000')"                    ;
          }                                                   , ;
          "UPPER( POKLADHD ->cDENIK)"                           ;
        }                                                       , ;
        "Úèetní záznamy FINANCE_Pokladna"                         ;
      }                                                           ;
    }                                                             , ;
    .T.                                                               ;
  }


#define  _UCETDOHD  ;
{ "FINANCE.EXE"                                                   , ;
    "úè~Etní doklady        "                                       , ;
    " ··· pøehled úèetních zázmanù modulu FINANCE_ÚèDoklady ···"    , ;
    2                                                               , ;
    NIL                                                             , ;
    { { "UCETDOHD"                                              , ;
        { "UCETDOHD,5"                                          , ;
          "FINANCE:cDenikFIDO"                                  , ;
          "Fin _ÚèDOKLAD  "                                     , ;
          "UCETDOHD ->nDOKLAD"                                  , ;
          "UCETDOHD ->nCenZakCEL"                               , ;
          "UCETDOHD ->nLikCelDOK"                               , ;
          NIL                                                   , ;
          NIL                                                   , ;
          { "UcetERRw ->cULOHA     := UcetDoHD ->cULOHA"      , ;
            "UcetERRw ->cOBDOBI    := UcetDoHD ->cOBDOBI"     , ;
            "UCETERRw ->nROK       := UCETDOHD ->nROK"        , ;
            "UCETERRw ->nOBDOBI    := UCETDOHD ->nOBDOBI"     , ;
            "UcetERRw ->cTASKs     := ('Fin _ÚèDOKLAD  ')"    , ;
            "UcetERRw ->cDENIK     := UcetDoHD ->cDENIK"      , ;
            "UcetERRw ->cDENIK_CFG := ('FINANCE:cDenikFIDO')" , ;
            "UcetERRw ->nDOKLAD    := UcetDoHD ->nDOKLAD"     , ;
            "UcetERRw ->cVARSYM    := UcetDoHD ->cVARSYM"     , ;
            "UcetERRw ->cTextDOK   := UcetDoHD ->cTextDOK"    , ;
            "UcetERRw ->nCenZakCEL := UcetDoHD ->nCenZakCEL"  , ;
            "UcetERRw ->nLikCelDOK := UcetDoHD ->nLikCelDOK"  , ;
            "UcetERRw ->nKLikvid   := UcetDoHD ->nKLikvid"    , ;
            "UcetERRw ->nZLikvid   := UcetDoHD ->nZLikvid"    , ;
            "UcetERRw ->nKcMD      := (0)"                    , ;
            "UcetERRw ->nKcDAL     := (0)"                    , ;
            "UcetERRw ->dDatUZV    := DATE()"                 , ;
            "UcetERRw ->cERR       := ('0000000')"              ;
          }                                                   , ;
          "UPPER( UCETDOHD ->cDENIK)"                           ;
        }                                                       , ;
        "Úèetní záznamy FINANCE_ÚèDoklady"                        ;
      }                                                           ;
    }                                                             , ;
    .T.                                                               ;
  }


**SKLADY**
#define  _PVPHEAD  ;
{ "SKLADY.EXE"                                                    , ;
    "dle ~Skladù          "                                         , ;
    " ··· pøehled úèetních zázmanù modulu SKLADY ···"               , ;
    2                                                               , ;
    NIL                                                             , ;
    { { "PVPHEAD"                                               , ;
        { "PVPHEAD,8"                                           , ;
          "SKLADY:cDENIK"                                       , ;
          "Skl _POHYBY  "                                       , ;
          "PVPHEAD ->nDOKLAD"                                   , ;
          "PVPHEAD ->nCenaDOKL"                                 , ;
          "PVPHEAD ->nLikCelDOK"                                , ;
          NIL                                                   , ;
          NIL                                                   , ;
          { "UcetERRw ->cULOHA     := PvpHEAD ->cULOHA"       , ;
            "UcetERRw ->cOBDOBI    := PvpHEAD ->cOBDPOH"      , ;
            "UCETERRw ->nROK       := PVPHEAD ->nROK"         , ;
            "UCETERRw ->nOBDOBI    := PVPHEAD ->nOBDOBI"      , ;
            "UcetERRw ->cTASKs     := ('Skl_          ')"     , ;
            "UcetERRw ->cDENIK     := PvpHEAD ->cDENIK"       , ;
            "UcetERRw ->cDENIK_CFG := ('SKLADY:cDenik')"      , ;
            "UcetERRw ->nDOKLAD    := PvpHEAD ->nDOKLAD"      , ;
            "UcetERRw ->cVARSYM    := PvpHEAD ->cVARSYM"      , ;
            "UcetERRw ->cTextDOK   := ('               ')"    , ;
            "UcetERRw ->nCenZakCEL := PvpHEAD ->nCenaDOKL"    , ;
            "UcetERRw ->nLikCelDOK := PvpHEAD ->nLikCelDOK"   , ;
            "UcetERRw ->nKLikvid   := PvpHEAD ->nKLikvid"     , ;
            "UcetERRw ->nZLikvid   := PvpHEAD ->nZLikvid"     , ;
            "UcetERRw ->nKcMD      := (0)"                    , ;
            "UcetERRw ->nKcDAL     := (0)"                    , ;
            "UcetERRw ->dDatUZV    := DATE()"                 , ;
            "UcetERRw ->cERR       := ('0000000')"              ;
          }                                                   , ;
          "UPPER( PVPHEAD ->cDENIK)"                            ;
        }                                                       , ;
        "Úèetní záznamy SKLADY_"                                  ;
      }                                                           ;
    }                                                             , ;
    .T.                                                               ;
  }


**MZDY**
#define  _MZDY_HM  ;
{ "MZDY.EXE"                                                      , ;
    "mzdy ~Hrubé mzdy       "                                       , ;
    " ··· pøehled úèetních zázmanù modulu MZDY_hrubé mzdy ···"      , ;
    2                                                               , ;
    NIL                                                             , ;
    { { "MZDY"                                                  , ;
        { "MZDY,1"                                              , ;
          "MZDY:cDENIKMZDY"                                     , ;
          "Mzdy _HRUBÉ MZDY  "                                  , ;
          "MZDY ->nDOKLAD"                                      , ;
          "MZDY ->nMZDA"                                        , ;
          "MZDY ->nLikCelDOK"                                   , ;
          NIL                                                   , ;
          NIL                                                   , ;
          { "UcetERRw ->cULOHA     := MZDY ->cULOHA"          , ;
            "UcetERRw ->cOBDOBI    := UCETPOL ->cOBDOBI"      , ;
            "UCETERRw ->nROK       := UCETPOL ->nROK"         , ;
            "UCETERRw ->nOBDOBI    := UCETPOL ->nOBDOBI"      , ;
            "UcetERRw ->cTASKs     := ('MZDY_hrubé mzdy')"    , ;
            "UcetERRw ->cDENIK     := UCETPOL ->cDENIK"       , ;
            "UcetERRw ->cDENIK_CFG := ('MZDY:cDENIKMZDY')"    , ;
            "UcetERRw ->nDOKLAD    := UCETPOL ->nDOKLAD"      , ;
            "UcetERRw ->cVARSYM    := UCETPOL ->cSYMBOL"      , ;
            "UcetERRw ->cTextDOK   := ('               ')"    , ;
            "UcetERRw ->nCenZakCEL := MZDY ->nMZDA"           , ;
            "UcetERRw ->nLikCelDOK := MZDY ->nLIKcelDOK"      , ;
            "UcetERRw ->nKLikvid   := MZDY ->nKLikvid"        , ;
            "UcetERRw ->nZLikvid   := MZDY ->nZLikvid"        , ;
            "UcetERRw ->nKcMD      := (0)"                    , ;
            "UcetERRw ->nKcDAL     := (0)"                    , ;
            "UcetERRw ->dDatUZV    := DATE()"                 , ;
            "UcetERRw ->cERR       := ('0000000')"              ;
          }                                                   , ;
          "UPPER( SYSCONFIG('MZDY:cDENIKMZDY'))"                ;
        }                                                       , ;
        "Úèetní záznamy MZDY_hrubé mzdy"                          ;
      }                                                           ;
    }                                                             , ;
    .T.                                                               ;
  }


#define  _MZDY_NE  ;
{ "MZDY.EXE"                                                      , ;
    "mzdy ~Nemocenky     "                                          , ;
    " ··· pøehled úèetních zázmanù modulu MZDY_nemocenky ···"       , ;
    2                                                               , ;
    NIL                                                             , ;
    { { "MZDY"                                                  , ;
        { "MZDY,1"                                              , ;
          "MZDY:cDENIKMZDN"                                     , ;
          "Mzdy _NEMOCENKY   "                                  , ;
          "MZDY ->nDOKLAD"                                      , ;
          "MZDY ->nMZDA"                                        , ;
          "MZDY ->nLikCelDOK"                                   , ;
          NIL                                                   , ;
          NIL                                                   , ;
          { "UcetERRw ->cULOHA     := MZDY ->cULOHA"          , ;
            "UcetERRw ->cOBDOBI    := UCETPOL ->cOBDOBI"      , ;
            "UCETERRw ->nROK       := UCETPOL ->nROK"         , ;
            "UCETERRw ->nOBDOBI    := UCETPOL ->nOBDOBI"      , ;
            "UcetERRw ->cTASKs     := ('MZDY_hrubé mzdy')"    , ;
            "UcetERRw ->cDENIK     := UCETPOL ->cDENIK"       , ;
            "UcetERRw ->cDENIK_CFG := ('MZDY:cDENIKMZDN')"    , ;
            "UcetERRw ->nDOKLAD    := UCETPOL ->nDOKLAD"      , ;
            "UcetERRw ->cVARSYM    := UCETPOL ->cSYMBOL"      , ;
            "UcetERRw ->cTextDOK   := ('               ')"    , ;
            "UcetERRw ->nCenZakCEL := MZDY ->nMZDA"           , ;
            "UcetERRw ->nLikCelDOK := MZDY ->nLIKcelDOK"      , ;
            "UcetERRw ->nKLikvid   := MZDY ->nKLikvid"        , ;
            "UcetERRw ->nZLikvid   := MZDY ->nZLikvid"        , ;
            "UcetERRw ->nKcMD      := (0)"                    , ;
            "UcetERRw ->nKcDAL     := (0)"                    , ;
            "UcetERRw ->dDatUZV    := DATE()"                 , ;
            "UcetERRw ->cERR       := ('0000000')"              ;
          }                                                   , ;
          "UPPER( SYSCONFIG('MZDY:cDENIKMZDN'))"                ;
        }                                                       , ;
        "Úèetní záznamy MZDY_nemocenky"                           ;
      }                                                           ;
    }                                                             , ;
    .T.                                                               ;
  }


#define  _MZDY_SR  ;
{ "MZDY.EXE"                                                      , ;
    "mzdy ~Srážky      "                                          , ;
    " ··· pøehled úèetních zázmanù modulu MZDY_srážky ···"        , ;
    2                                                               , ;
    NIL                                                             , ;
    { { "MZDY"                                                  , ;
        { "MZDY,1"                                              , ;
          "MZDY:cDENIKMZDS"                                     , ;
          "Mzdy _SRÁŽKY   "                                     , ;
          "MZDY ->nDOKLAD"                                      , ;
          "MZDY ->nMZDA"                                        , ;
          "MZDY ->nLikCelDOK"                                   , ;
          NIL                                                   , ;
          NIL                                                   , ;
          { "UcetERRw ->cULOHA     := MZDY ->cULOHA"          , ;
            "UcetERRw ->cOBDOBI    := UCETPOL ->cOBDOBI"      , ;
            "UCETERRw ->nROK       := UCETPOL ->nROK"         , ;
            "UCETERRw ->nOBDOBI    := UCETPOL ->nOBDOBI"      , ;
            "UcetERRw ->cTASKs     := ('MZDY_hrubé mzdy')"    , ;
            "UcetERRw ->cDENIK     := UCETPOL ->cDENIK"       , ;
            "UcetERRw ->cDENIK_CFG := ('MZDY:cDENIKMZDS')"    , ;
            "UcetERRw ->nDOKLAD    := UCETPOL ->nDOKLAD"      , ;
            "UcetERRw ->cVARSYM    := UCETPOL ->cSYMBOL"      , ;
            "UcetERRw ->cTextDOK   := ('               ')"    , ;
            "UcetERRw ->nCenZakCEL := MZDY ->nMZDA"           , ;
            "UcetERRw ->nLikCelDOK := MZDY ->nLIKcelDOK"      , ;
            "UcetERRw ->nKLikvid   := MZDY ->nKLikvid"        , ;
            "UcetERRw ->nZLikvid   := MZDY ->nZLikvid"        , ;
            "UcetERRw ->nKcMD      := (0)"                    , ;
            "UcetERRw ->nKcDAL     := (0)"                    , ;
            "UcetERRw ->dDatUZV    := DATE()"                 , ;
            "UcetERRw ->cERR       := ('0000000')"              ;
          }                                                   , ;
          "UPPER( SYSCONFIG('MZDY:cDENIKMZDS'))"                ;
        }                                                       , ;
        "Úèetní záznamy MZDY_srážky"                              ;
      }                                                           ;
    }                                                             , ;
    .T.                                                               ;
  }


**IM**
#define  _ZMAJU  ;
{ "IM.EXE"                                                          , ;
    "dle m~Ajetku -IM-   "                                          , ;
    " ··· pøehled úèetních zázmanù modulu MAJETEK_im ···"           , ;
    2                                                               , ;
    NIL                                                             , ;
    { { "ZMAJU"                                                 , ;
        { "ZMAJU,6"                                             , ;
          "IM:cDENIKIM"                                         , ;
          "Im _majetek   "                                      , ;
          "ZMAJU ->nDOKLAD"                                     , ;
          "ZMAJU ->nUCTodpMES"                                  , ;
          "ZMAJU ->nLikCelDOK"                                  , ;
          NIL                                                   , ;
          NIL                                                   , ;
          { "UcetERRw ->cULOHA     := ZMAJU ->cULOHA"         , ;
            "UcetERRw ->cOBDOBI    := ZMAJU ->cOBDOBI"        , ;
            "UCETERRw ->nROK       := ZMAJU ->nROK"           , ;
            "UCETERRw ->nOBDOBI    := ZMAJU ->nOBDOBI"        , ;
            "UcetERRw ->cTASKs     := ('Im_           ')"     , ;
            "UcetERRw ->cDENIK     := ZMAJU ->cDENIK"         , ;
            "UcetERRw ->cDENIK_CFG := ('IM:cDENIKIM')"        , ;
            "UcetERRw ->nDOKLAD    := ZMAJU ->nDOKLAD"        , ;
            "UcetERRw ->cVARSYM    := ZMAJU ->cVARSYM"        , ;
            "UcetERRw ->cTextDOK   := ('               ')"    , ;
            "UcetERRw ->nCenZakCEL := ZMAJU ->nUCTodpMES"     , ;
            "UcetERRw ->nLikCelDOK := ZMAJU ->nLIKcelDOK"     , ;
            "UcetERRw ->nKLikvid   := ZMAJU ->nKLikvid"       , ;
            "UcetERRw ->nZLikvid   := ZMAJU ->nZLikvid"       , ;
            "UcetERRw ->nKcMD      := (0)"                    , ;
            "UcetERRw ->nKcDAL     := (0)"                    , ;
            "UcetERRw ->dDatUZV    := DATE()"                 , ;
            "UcetERRw ->cERR       := ('0000000')"              ;
          }                                                   , ;
          "UPPER( ZMAJU ->cDENIK)"                              ;
        }                                                       , ;
        "Úèetní záznamy IM _majetek"                              ;
      }                                                           ;
    }                                                             , ;
    .T.                                                               ;
  }


**ZVÍØATA**
#define  _ZVZMENHD  ;
{ "ZVIRATA.EXE"                                                   , ;
    "~zvíøata_Zásoby      "                                         , ;
    " ··· pøehled úèetních zázmanù modulu ZVÍØATA_zásoby ···"       , ;
    2                                                               , ;
    NIL                                                             , ;
    { { "ZVZMENHD"                                              , ;
        { "ZVZMENHD,8"                                          , ;
          "ZVIRATA:cDENIKZVZ"                                   , ;
          "ZVIRATA_zásoby  "                                    , ;
          "ZVZMENHD ->nDOKLAD"                                  , ;
          "ZVZMENHD ->nCenaCZV"                                 , ;
          "ZVZMENHD ->nLikCelDOK"                               , ;
          NIL                                                   , ;
          NIL                                                   , ;
          { "UcetERRw ->cULOHA     := ZVZMENHD ->cULOHA"      , ;
            "UcetERRw ->cOBDOBI    := ZVZMENHD ->cOBDOBI"     , ;
            "UCETERRw ->nROK       := ZVZMENHD ->nROK"        , ;
            "UCETERRw ->nOBDOBI    := ZVZMENHD ->nOBDOBI"     , ;
            "UcetERRw ->cTASKs     := ('ZVIRATA_zásoby')"     , ;
            "UcetERRw ->cDENIK     := ZVZMENHD ->cDENIK"      , ;
            "UcetERRw ->cDENIK_CFG := ('ZVIRATA:cDENIKZVZ')"  , ;
            "UcetERRw ->nDOKLAD    := ZVZMENHD ->nDOKLAD"     , ;
            "UcetERRw ->cVARSYM    := ZVZMENHD ->cVARSYM"     , ;
            "UcetERRw ->cTextDOK   := ('               ')"    , ;
            "UcetERRw ->nCenZakCEL := ZVZMENHD ->nCenaCZv"    , ;
            "UcetERRw ->nLikCelDOK := ZVZMENHD ->nLIKcelDOK"  , ;
            "UcetERRw ->nKLikvid   := ZVZMENHD ->nKLikvid"    , ;
            "UcetERRw ->nZLikvid   := ZVZMENHD ->nZLikvid"    , ;
            "UcetERRw ->nKcMD      := (0)"                    , ;
            "UcetERRw ->nKcDAL     := (0)"                    , ;
            "UcetERRw ->dDatUZV    := DATE()"                 , ;
            "UcetERRw ->cERR       := ('0000000')"              ;
          }                                                   , ;
          "UPPER( ZVZMENHD ->cDENIK)"                           ;
        }                                                       , ;
        "Úèetní záznamy ZVÍØATA_zásoby"                           ;
      }                                                           ;
    }                                                             , ;
    .T.                                                               ;
  }


#define  _ZMAJUZ  ;
{ "ZVIRATA.EXE"                                                   , ;
    "z~Víøata_Základní Stádo    "                                   , ;
    " ··· pøehled úèetních zázmanù modulu ZVÍØATA_zákStádo ···"     , ;
    2                                                               , ;
    NIL                                                             , ;
    { { "ZMAJUZ"                                                , ;
        { "ZMAJUZ,6"                                            , ;
          "ZVIRATA:cDENIKZV"                                    , ;
          "ZVIRATA_základí stádo "                              , ;
          "ZMAJUZ ->nDOKLAD"                                    , ;
          "ZMAJUZ ->nUCTodpMES"                                 , ;
          "ZMAJUZ ->nLikCelDOK"                                 , ;
          NIL                                                   , ;
          NIL                                                   , ;
          { "UcetERRw ->cULOHA     := ZMAJUZ ->cULOHA"        , ;
            "UcetERRw ->cOBDOBI    := ZMAJUZ ->cOBDOBI"       , ;
            "UCETERRw ->nROK       := ZMAJUZ ->nROK"          , ;
            "UCETERRw ->nOBDOBI    := ZMAJUZ ->nOBDOBI"       , ;
            "UcetERRw ->cTASKs     := ('ZVIRATA_zákl.s')"     , ;
            "UcetERRw ->cDENIK     := ZMAJUZ ->cDENIK"        , ;
            "UcetERRw ->cDENIK_CFG := ('ZVIRATA:cDENIKZV')"   , ;
            "UcetERRw ->nDOKLAD    := ZMAJUZ ->nDOKLAD"       , ;
            "UcetERRw ->cVARSYM    := ZMAJUZ ->cVARSYM"       , ;
            "UcetERRw ->cTextDOK   := ('               ')"    , ;
            "UcetERRw ->nCenZakCEL := ZMAJUZ ->nUCTodpMES"    , ;
            "UcetERRw ->nLikCelDOK := ZMAJUZ ->nLIKcelDOK"    , ;
            "UcetERRw ->nKLikvid   := ZMAJUZ ->nKLikvid"      , ;
            "UcetERRw ->nZLikvid   := ZMAJUZ ->nZLikvid"      , ;
            "UcetERRw ->nKcMD      := (0)"                    , ;
            "UcetERRw ->nKcDAL     := (0)"                    , ;
            "UcetERRw ->dDatUZV    := DATE()"                 , ;
            "UcetERRw ->cERR       := ('0000000')"              ;
          }                                                   , ;
          "UPPER( ZMAJUZ ->cDENIK)"                             ;
        }                                                       , ;
        "Úèetní záznamy ZVÍØATA_základní stádo"                   ;
      }                                                           ;
    }                                                             , ;
    .T.                                                               ;
  }