//////////////////////////////////////////////////////////////////////
//
//  ASYSTEM++.CH
//
//////////////////////////////////////////////////////////////////////

// ICONS
#DEFINE  ICON_REBATE      10
#DEFINE  ICON_SEARCH      11
#DEFINE  ICON_PAY         12
#DEFINE  ICON_BASKET      13

#DEFINE  MIS_ICON_MODULE        500    //  +
#DEFINE  MIS_ICON_APPEND        400    //  +
#DEFINE  MIS_ICON_QUIT          401    //  x
#define  MIS_ICON_OPENFOLDER    420
#define  MIS_ICON_CLOSEDFOLDER  421
#define  MIS_DARGDROP_PUNTERO   422
#define  MIS_LEFT_LIGHTBLUE     423
#define  MIS_RIGHT_LIGHTBLUE    424
#define  MIS_ICON_ATTENTION     425
#define  MIS_ICON_PAY           426

// použití na výbìrových formuláøích pro ozanèení a hromadné pøevzetí položek do dokladu
#define   MIS_ICON_CHECK        427
#define  gMIS_ICON_CHECK        428

#define   MIS_ICON_SAVE_AS      429
#define  gMIS_ICON_SAVE_AS      430

// použití na základní lištì dialogu
#define   MIS_ICON_DATCOM1      431
#define  gMIS_ICON_DATCOM1      432
#define   MIS_ICON_SWHELP       433
#define  gMIS_ICON_SWHELP       434
#define   MIS_ICON_SORT         435
#define  gMIS_ICON_SORT         436
#define   MIS_ICON_FILTER       437
#define  gMIS_ICON_FILTER       438
#define   MIS_ICON_KILLFILTER   439
#define  gMIS_ICON_KILLFILTER   440


// POINTER
#define  MIS_HAND        550


// BITMAPS
#DEFINE  MIS_ICON_OK     300
#DEFINE  MIS_ICON_ERR    301
#DEFINE  MIS_BOOK        302
#DEFINE  MIS_BOOKOPEN    303
#DEFINE  MIS_PLUS        304
#DEFINE  MIS_MINUS       305
#DEFINE  MIS_EQUAL       314
#DEFINE  MIS_EDIT        315
#DEFINE  MIS_NO_RUN      316
#DEFINE  MIS_HELP        600   // NEW
#DEFINE  MIS_UNDO        601
#DEFINE  MIS_LIGHT       602
#DEFINE  MIS_PRINTER     603
#DEFINE  MIS_FIND        604
#DEFINE  MIS_RUN         605
#DEFINE  MIS_WIZARD      606



#DEFINE  BANVYPIT_1      306
#DEFINE  BANVYPIT_2      307
#DEFINE  BANVYPIT_3      308
#DEFINE  BANVYPIT_4      309
#DEFINE  BANVYPIT_5      310
#DEFINE  BANVYPIT_6      311
#DEFINE  BANVYPIT_7      312
#DEFINE  BANVYPIT_8      313

#DEFINE  BANVYPITM_1     334
#DEFINE  BANVYPITM_2     335
#DEFINE  BANVYPITM_3     336

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

// pro vrtítko
#DEFINE  MIS_PHASE1      331
#DEFINE  MIS_PHASE2      332
#DEFINE  MIS_PHASE3      333

#DEFINE  MIS_SORT_UP     337
#DEFINE  MIS_SORT_DOWN   338

// tohle by mìlo pøijít ven
#DEFINE  MIS_LGATE       339
#DEFINE  MIS_RGATE       340
//

#DEFINE FILTER_OPT_FULL  341
#DEFINE FILTER_OPT_PART  342
#DEFINE FILTER_OPT_NONE  343

// èervík
#DEFINE  MIS_WORM_PHASE1      344
#DEFINE  MIS_WORM_PHASE2      345
#DEFINE  MIS_WORM_PHASE3      346
#DEFINE  MIS_WORM_PHASE4      347

// vykøièník
#DEFINE  MIS_EXCL_HELP        348
#DEFINE  MIS_EXCL_INFO        349
#DEFINE  MIS_EXCL_WARN        350
#DEFINE  MIS_EXCL_ERR         351


// POUŽITO z DOSu
# Define   DBGetVal(c)     Eval( &("{||" + c + "}"))
# Define   DBPutVal(c,x)   ( &(c) := x )
# Define   COMPILE(c)      &("{||" + c + "}")
# xTranslate CMPItem( <nVal>, <cPic>) => Val( TransForm( <nVal>, <cPic>))
# Translate  Equal( < cStr_1 >, < cStr_2>) => ;
             ( Upper( AllTrim( < cStr_1>) ) == Upper( AllTrim( < cStr_2>) ) )
#xtranslate CopyDBWithScope(<tg>,<cs>,<in>,<ou>) => ( drgDBMS:open(<in>)                                 , ;
                                                      drgDBMS:open(<ou>,.T.,.T.,drgINI:dir_USERfitm)     , ;
                                                      (<ou>) ->(dbzap())                                 , ;
                                                      (<in>) ->(OrdSetFocus(<tg>))                       , ;
                                                      (<in>) ->(DBSetScope(SCOPE_BOTH,<cs>))             , ;
                                                      (<in>) ->(DbGoTop())                               , ;
                                                      (<in>) ->(DbEval( { || mh_COPYFLD(<in>,<ou>,.T.) })) )

*
** vazba na c_typpoh
# define  F_BANKA           'FBANKA         '
# define  F_POHLEDAVKY      'FPOHLEDAVKY    '
# define  F_POHLEDAVKYZAPZ  'FPOHLEDAVKYZAPZ'
# define  F_POKLADNA        'FPOKLADNA      '
# define  F_UCETDOKL        'FUCETDOKL      '
# define  F_VNITROFAK       'FVNITROFAK     '
# define  F_ZAPOCET         'FZAPOCET       '
# define  F_ZAVAZKY         'FZAVAZKY       '
# define  F_ZAVAZKYZAPZ     'FZAVAZKYZAPZ   '
# define  F_UHRADY          'FUHRADY        '

# define  E_DODLISTY        'EDODLISTY      '
# define  E_OBJEDNAVKY      'EOBJEDNAVKY    '         // objednávky pøijaté   OBJHEAD
# define  N_OBJEDNAVKY      'NOBJEDNAVKY    '         // objednávky vystavené OBJVYSHD
# define  E_REGPOKLADNA     'EREGPOKLADNA   '
# define  E_EXPEDICE        'EEXPEDICE'

# define  U_UCETDOKL        'UUCETDOKL      '

# define  S_DOKLADY         'SDOKLADY        '
# define  I_DOKLADY         'IDOKLADY        '
# define  Z_DOKLADY         'ZDOKLADY        '


*
** vazba na drgEBrowse popis ::ardef
#xtranslate  .defCap   =>  \[ 1\]
#xtranslate  .defName  =>  \[ 2\]
#xtranslate  .defLen   =>  \[ 3\]
#xtranslate  .defPict  =>  \[ 4\]
#xtranslate  .defType  =>  \[ 5\]
* add
#xtranslate  .drgBord  =>  \[ 6\]
#xtranslate  .drgEdit  =>  \[ 7\]
#xtranslate  .drgPush  =>  \[ 8\]
#xtranslate  .drgIx    =>  \[ 9\]
#xtranslate  .drgShow  =>  \[10\]
#xtranslate  .drgColum =>  \[11\]


#define      MIS_COLORS   { {'GRA_CLR_BLUE'    , GRA_CLR_BLUE    }, {'GRA_CLR_RED'      , GRA_CLR_RED      }, ;
                            {'GRA_CLR_PINK'    , GRA_CLR_PINK    }, {'GRA_CLR_GREEN'    , GRA_CLR_GREEN    }, ;
                            {'GRA_CLR_CYAN'    , GRA_CLR_CYAN    }, {'GRA_CLR_YELLOW'   , GRA_CLR_YELLOW   }, ;
                            {'GRA_CLR_NEUTRAL' , GRA_CLR_NEUTRAL }, {'GRA_CLR_DARKGRAY' , GRA_CLR_DARKGRAY }, ;
                            {'GRA_CLR_DARKBLUE', GRA_CLR_DARKBLUE}, {'GRA_CLR_DARKRED'  , GRA_CLR_DARKRED  }, ;
                            {'GRA_CLR_DARKPINK', GRA_CLR_DARKPINK}, {'GRA_CLR_DARKGREEN', GRA_CLR_DARKGREEN}, ;
                            {'GRA_CLR_DARKCYAN', GRA_CLR_DARKCYAN}, {'GRA_CLR_BROWN'    , GRA_CLR_BROWN    }, ;
                            {'GRA_CLR_PALEGRAY', GRA_CLR_PALEGRAY}  }