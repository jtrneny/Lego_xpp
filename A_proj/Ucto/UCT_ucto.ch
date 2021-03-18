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

#include "ASystem++.ch"
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


// BACHA POU�ITO ve FINANCE - pak vystr�it n�kam v� mimo �lohu //
# Define   DBGetVal(c)     Eval( &("{||" + c + "}"))
# Define   DBPutVal(c,x)   ( &(c) := x )
# Define   COMPILE(c)      &("{||" + c + "}")
# xTranslate CMPItem( <nVal>, <cPic>) => Val( TransForm( <nVal>, <cPic>))
**/


// N�HRADA pro INFO_SCR
#define   _UCT_main  ;
  { {'UCTDOKHD', { "UCTDOKHD ->nDOKLAD"                           , ;
                   "UCTDOKHD ->nCENZAKCEL"                        , ;
                   "UCTDOKHD ->nCENZAKCEL"                        , ;
                   "UCTDOKHD ->dDATTISK"                          , ;
                   "UPPER( UCTDOKHD ->cOBDOBIDAN)"                , ;
                   "UCTDOKHD ->nLIKCELDOK"                        , ;
                   "UPPER( UCTDOKHD ->cULOHA +UCTDOKHD ->cOBDOBI)", ;
                   "      "                                       , ;
                   "? ?  ?"                                       , ;
                   "SYSCONFIG('UCTO:nRANGEUCDO')"                 , ;
                   "1"                                              } }, ;
    {'UCETPOLA', { "UCETPOLA ->nDOKLAD"                           , ;
                   "UCETPOLA ->nKCmd"                             , ;
                   "UCETPOLA ->nKCdal"                            , ;
                   "('')"                                         , ;
                   "UPPER( UCETPOLA ->cOBDOBIDAN)"                , ;
                   "('')"                                         , ;
                   "UPPER( UCETPOLA ->cULOHA +UCETPOLA ->cOBDOBI)", ;
                   "    "                                         , ;
                   "? ? "                                         , ;
                   "SYSCONFIG('UCTO:nRANGEUCDO')"                 , ;
                   "4"                                              } }, ;
    {'UCETKUM', { "UCETKUM ->nROK"                                , ;
                  "('')"                                          , ;
                  "('')"                                          , ;
                  "('')"                                          , ;
                  "UPPER( UCETKUM ->cOBDOBI)"                     , ;
                  "('')"                                          , ;
                  "UPPER( 'U' +UCETKUM ->cOBDOBI)"                , ;
                  "  "                                            , ;
                  NIL                                             , ;
                  NIL                                             , ;
                  NIL                                               } } }

// BACHA JE TO STEJN� DEFINICE JAKO VE FINANCE - pak vystr�it n�kam v� mimo �lohu //
# xTranslate  .pKEY   =>  \[ 1\]
# xTranslate  .pCEL   =>  \[ 2\]
              # xTranslate  .pDEB    =>  \[ 2\]
# xTranslate  .pUHR   =>  \[ 3\]
              # xTranslate  .pKRE    =>  \[ 3\]
# xTranslate  .pPRIK   =>  \[ 4\]
              # xTranslate  .pTISK   =>  \[ 4\]
# xTranslate  .pDUZ   =>  \[ 5\]
              # xTranslate  .pLIKDEB =>  \[ 5\]
# xTranslate  .pLIK   =>  \[ 6\]
              # xTranslate  .pLIKKRE =>  \[ 6\]
# xTranslate  .pUUZ   =>  \[  7\]
# xTranslate  .pDEF   =>  \[  8\]
# xTranslate  .pKEYm  =>  \[ 10\]
# xTranslate  .pTAGm  =>  \[ 11\]