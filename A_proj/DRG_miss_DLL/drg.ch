//////////////////////////////////////////////////////////////////////
//
//  DRG.CH
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      Directives for the drg default object definitions and
//      drg specific constants definitions.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

// drg.ch is not included
#ifndef  _DRG_CH

// Used very often
#ifndef  ESC
#define ESC        Chr(27)
#endif

#ifndef  CRLF
#define CRLF       Chr(13) + Chr(10)
#endif

#ifndef  TAB
#define TAB        Chr(09)
#endif


*
** konstatny pro WinApi
#define SW_SHOWNORMAL       1
#define SW_SHOWMINIMIZED    2
#define SW_SHOWMAXIMIZED    3



/***********************************************************
 * DRGEVENT_* constants
 ***********************************************************/
// #define xbeP_User                  134217728
#define drgP_User                     140000000
#define drgEVENT_EXIT                 (0    + drgP_User)
#define drgEVENT_SAVE                 (1    + drgP_User)
#define drgEVENT_QUIT                 (2    + drgP_User)
#define drgEVENT_PREV                 (3    + drgP_User)
#define drgEVENT_NEXT                 (4    + drgP_User)
#define drgEVENT_TOP                  (5    + drgP_User)
#define drgEVENT_BOTTOM               (6    + drgP_User)
#define drgEVENT_APPEND               (7    + drgP_User)
#define drgEVENT_APPEND2              (8    + drgP_User)
#define drgEVENT_FIND                 (9    + drgP_User)
#define drgEVENT_DELETE               (10   + drgP_User)
#define drgEVENT_HELP                 (12   + drgP_User)
#define drgEVENT_ACTION               (13   + drgP_User)
#define drgEVENT_EDIT                 (14   + drgP_User)
#define drgEVENT_PRINT                (15   + drgP_User)
#define drgEVENT_FINDNXT              (16   + drgP_User)
#define drgEVENT_REFRESH              (17   + drgP_User)
#define drgEVENT_DOCNEW               (18   + drgP_User)
#define drgEVENT_DOCVIEW              (19   + drgP_User)
#define drgEVENT_DOCDEL               (20   + drgP_User)
#define drgEVENT_SELECT               (21   + drgP_User)
#define drgEVENT_OBDOBICHANGED        (24   + drgP_User)
#define drgEVENT_STABLEBLOCK          (26   + drgP_User)

#define drgEVENT_MSG                  (30   + drgP_User)

#define drgEVENT_OBJEXIT              (50   + drgP_User)
#define drgEVENT_OBJENTER             (51   + drgP_User)
#define drgEVENT_FORMDRAWN            (55   + drgP_User)
#define drgDIALOG_START               (56   + drgP_User)
#define drgDIALOG_END                 (57   + drgP_User)
#define drgEVENT_ACTIVATE             (59   + drgP_User)

#define drgEVENT_MIN                  (0    + drgP_User)
#define drgEVENT_MAX                  (100  + drgP_User)

/***********************************************************
 * MISEVENT_* constants
 ***********************************************************/
#define misEVENT_FILTER               (200  + drgP_User)
#define misEVENT_KILLFILTER           (201  + drgP_User)
#define misEVENT_DOCUMENTS            (202  + drgP_User)
#define misEVENT_DATACOM              (206  + drgP_User)
#define misEVENT_SWHELP               (207  + drgP_User)  
#define misEVENT_SORT                 (208  + drgP_User)   
#define misEVENT_BROREFRESH           (209  + drgP_User)   



/***********************************************************
 * ERROR types
 ***********************************************************/
#define DRG_MSG_INFO                  1
#define DRG_MSG_ERROR                 2
#define DRG_MSG_WARNING               3

/***********************************************************
 * Default presentation parameters fot drgPP
 ***********************************************************/

#DEFINE drgPP_SIZE                  15

#DEFINE drgPP_PP_BROWSE1             1
#DEFINE drgPP_PP_BROWSE2             2
#DEFINE drgPP_PP_BROWSE3             3

#DEFINE drgPP_PP_BROWSE4             4
#DEFINE drgPP_PP_BROWSE5             5
#DEFINE drgPP_PP_BROWSE6                    6

#DEFINE drgPP_PP_BROWSE7             7
#DEFINE drgPP_PP_BROWSE8             8
#DEFINE drgPP_PP_BROWSE9             9

#DEFINE drgPP_PP_EDIT1              10
#DEFINE drgPP_PP_EDIT2              11
#DEFINE drgPP_PP_EDIT3              12

#DEFINE drgPP_PP_TEXT1              13
#DEFINE drgPP_PP_TEXT2              14
#DEFINE drgPP_PP_TEXT3              15

* Definitions for drgAction keyword ATYPE

#DEFINE drgACTION_IC16                1
#DEFINE drgACTION_IC16LEFT              2
#DEFINE drgACTION_IC16UP                3
#DEFINE drgACTION_NOICON                4
#DEFINE drgACTION_IC32                8
#DEFINE drgACTION_IC32LEFT              9
#DEFINE drgACTION_IC32UP                10

* Old IconBar look
#DEFINE drgICONBAR_OLD                1
* Windows XP IconBar look
#DEFINE drgICONBAR_XP                2


* Preprocessed DRG FORM definition commands
/***********************************************************
 * DRGFORM
 ***********************************************************/
#command DRGFORM INTO     <oFC>  ;
              [ POS       <posX> [, <posY>] ] ;
              [ SIZE      <sizeX> [, <sizeY>] ] ;
              [ DTYPE     <dType> ] ;
              [ TITLE     <title> ] ;
              [ GUILOOK   <guilook> ] ;
              [ CARGO     <cargo> ] ;
              [ FILE      <file> ] ;
              [ PRINT     <print> ] ;
              [ PGM       <pgm> ] ;
              [ BORDER    <border> ] ;
              [ PRE       <pre> ] ;
              [ POST      <post> ] ;
              [ <readonly: READONLY>] ;
=> ;
  oDrg := _drgDrgForm():new();
  [; oDrg:pos     := {<posX>,<posY>}];
  [; oDrg:size    := {<sizeX>,<sizeY>}];
  [; oDrg:dType   := <dType> ];
  [; oDrg:title   := <title>];
  [; oDrg:dType   := <dType>];
  [; oDrg:guilook := <guilook>];
  [; oDrg:cargo   := <cargo>];
  [; oDrg:file    := <file>];
  [; oDrg:print   := <print>];
  [; oDrg:pgm     := <pgm>];
  [; oDrg:border  := <border>];
  [; oDrg:pre     := <pre>];
  [; oDrg:post    := <post>];
  [; oDrg:isReadonly := <.readonly.>];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGEND
 ***********************************************************/
#command DRGEND INTO     <oFC>  ;
=> ;
  oDrg := _drgEnd():new();
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGTREEVIEW
 ***********************************************************/
#command DRGTREEVIEW INTO     <oFC>  ;
              [ FPOS          <fposX> [, <fposY>] ] ;
              [ SIZE          <sizeX> [, <sizeY>] ] ;
              [ TREEINIT      <treeInit> ] ;
              [ ITEMSELECTED  <itemSelected> ] ;
              [ ITEMMARKED    <itemMarked> ] ;
              [ CONTEXT       <context> ] ;
              [ PRE           <pre> ] ;
              [ POST          <post> ] ;
              [ <lines: HASLINES>] ;
              [ <buttons: HASBUTTONS>] ;
              [ RESIZE    <resize>  ] ;
              [ TIPTEXT   <tiptext> ] ;
=> ;
  oDrg := _drgTreeView():new();
  [; oDrg:fPos        := {<fposX>,<fposY>} ];
  [; oDrg:size        := {<sizeX>,<sizeY>} ];
  [; oDrg:treeInit    := <treeInit> ];
  [; oDrg:itemSelected:= <itemSelected> ];
  [; oDrg:itemMarked  := <itemMarked> ];
  [; oDrg:context     := <context>];
  [; oDrg:pre         := <pre>];
  [; oDrg:post        := <post>];
  [; oDrg:hasLines    := <.lines.>];
  [; oDrg:hasButtons  := <.buttons.>];
  [; oDrg:resize      := <resize> ];
  [; oDrg:tipText     := <tiptext> ];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGGET
 ***********************************************************/
#command DRGGET <name> INTO <oFC>  ;
              [ FPOS      <fposX> [, <fposY>] ] ;
              [ FLEN      <fLen> ] ;
              [ FILE      <file> ] ;
              [ PICTURE   <picture> ] ;
              [ FCAPTION  <fcaption> ] ;
              [ CPOS      <cposX> [, <cposY>] ] ;
              [ CLEN      <cLen> ] ;
              [ CTYPE     <ctype> ] ;
              [ PRE       <pre> ] ;
              [ POST      <post> ] ;
              [ POSTEVAL  <posteval> ] ;
              [ PP        <pp> ] ;
              [ TIPTEXT   <tiptext> ] ;
              [ PUSH      <push>    ] ;
=> ;
  oDrg := _drgGet():new();
  ; oDrg:name     := <"name">;
  [; oDrg:fPos    := {<fposX>,<fposY>} ];
  [; oDrg:fLen    := <fLen> ];
  [; oDrg:file    := <file> ];
  [; oDrg:picture := <picture>];
  [; oDrg:fcaption:= <fcaption>];
  [; oDrg:cpos    := {<cposX>,<cposY>}];
  [; oDrg:cLen    := <cLen> ];
  [; oDrg:ctype   := <ctype> ];
  [; oDrg:pre     := <pre> ];
  [; oDrg:post    := <post> ];
  [; oDrg:posteval:= <posteval> ];
  [; oDrg:pp      := <pp> ];
  [; oDrg:tipText := <tiptext> ];
  [; oDrg:push    := <push>    ];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGCHECKBOX
 ***********************************************************/
#command DRGCHECKBOX <name> INTO <oFC>  ;
              [ FPOS      <fposX> [, <fposY>] ] ;
              [ FLEN      <fLen> ] ;
              [ NAME      <name> ] ;
              [ FILE      <file> ] ;
              [ REF       <ref> ] ;
              [ VALUES    <values> ] ;
              [ FCAPTION  <fcaption> ] ;
              [ CAPTION   <caption> ] ;
              [ VALUES    <values> ] ;
              [ CPOS      <cposX> [, <cposY>] ] ;
              [ CLEN      <cLen> ] ;
              [ CTYPE     <ctype> ] ;
              [ PRE       <pre> ] ;
              [ POST      <post> ] ;
              [ POSTEVAL  <posteval> ] ;
              [ PP        <pp> ] ;
              [ TIPTEXT   <tiptext> ] ;
=> ;
  oDrg := _drgCheckBox():new();
  ; oDrg:name     := <"name">;
  [; oDrg:fPos    := {<fposX>,<fposY>} ];
  [; oDrg:fLen    := <fLen> ];
  [; oDrg:file    := <file> ];
  [; oDrg:ref     := <ref> ];
  [; oDrg:values  := <values>];
  [; oDrg:fcaption:= <fcaption>];
  [; oDrg:caption := <caption>];
  [; oDrg:cpos    := {<cposX>,<cposY>}];
  [; oDrg:cLen    := <cLen> ];
  [; oDrg:ctype   := <ctype> ];
  [; oDrg:pre     := <pre> ];
  [; oDrg:post    := <post> ];
  [; oDrg:posteval:= <posteval> ];
  [; oDrg:pp      := <pp> ];
  [; oDrg:tipText := <tiptext> ];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGRADIOBUTTON
 ***********************************************************/
#command DRGRADIOBUTTON <name> INTO <oFC>  ;
              [ FPOS      <fposX> [, <fposY>] ] ;
              [ SIZE      <sizeX> [, <sizeY>] ] ;
              [ NAME      <name> ] ;
              [ FILE      <file> ] ;
              [ REF       <ref> ] ;
              [ VALUES    <values> ] ;
              [ FCAPTION  <fcaption> ] ;
              [ CAPTION   <caption> ] ;
              [ VALUES    <values> ] ;
              [ CPOS      <cposX> [, <cposY>] ] ;
              [ CLEN      <cLen> ] ;
              [ CTYPE     <ctype> ] ;
              [ PRE       <pre> ] ;
              [ POST      <post> ] ;
              [ POSTEVAL  <posteval> ] ;
              [ PP        <pp> ] ;
              [ TIPTEXT   <tiptext> ] ;
=> ;
  oDrg := _drgRadioButton():new();
  ; oDrg:name     := <"name">;
  [; oDrg:fPos    := {<fposX>,<fposY>} ];
  [; oDrg:size    := {<sizeX>,<sizeY>} ];
  [; oDrg:file    := <file> ];
  [; oDrg:ref     := <ref> ];
  [; oDrg:values  := <values>];
  [; oDrg:fcaption:= <fcaption>];
  [; oDrg:caption := <caption>];
  [; oDrg:cpos    := {<cposX>,<cposY>}];
  [; oDrg:cLen    := <cLen> ];
  [; oDrg:ctype   := <ctype> ];
  [; oDrg:pre     := <pre> ];
  [; oDrg:post    := <post> ];
  [; oDrg:posteval:= <posteval> ];
  [; oDrg:pp      := <pp> ];
  [; oDrg:tipText := <tiptext> ];
  ;<oFC>:addLine(oDrg)


/***********************************************************
 * DRGSPINBUTTON
 ***********************************************************/
#command DRGSPINBUTTON <name> INTO <oFC>  ;
              [ FPOS      <fposX> [, <fposY>] ] ;
              [ FLEN      <fLen> ] ;
              [ FILE      <file> ] ;
              [ REF       <ref> ] ;
              [ VALUES    <values> ] ;
              [ FCAPTION  <fcaption> ] ;
              [ LIMITS    <llimit> [, <hlimit>] ] ;
              [ CPOS      <cposX> [, <cposY>] ] ;
              [ CLEN      <cLen> ] ;
              [ CTYPE     <ctype> ] ;
              [ PRE       <pre> ] ;
              [ POST      <post> ] ;
              [ POSTEVAL  <posteval> ] ;
              [ PP        <pp> ] ;
              [ TIPTEXT   <tiptext> ] ;
=> ;
  oDrg := _drgSpinButton():new();
  ; oDrg:name    := <"name"> ;
  [; oDrg:fPos    := {<fposX>,<fposY>} ];
  [; oDrg:fLen    := <fLen> ];
  [; oDrg:file    := <file> ];
  [; oDrg:ref     := <ref> ];
  [; oDrg:limits  := {<llimit>,<hlimit>}];
  [; oDrg:fcaption:= <fcaption>];
  [; oDrg:cpos    := {<cposX>,<cposY>}];
  [; oDrg:cLen    := <cLen> ];
  [; oDrg:ctype   := <ctype> ];
  [; oDrg:pre     := <pre> ];
  [; oDrg:post    := <post> ];
  [; oDrg:posteval:= <posteval> ];
  [; oDrg:pp      := <pp> ];
  [; oDrg:tipText := <tiptext> ];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGCOMBOBOX
 ***********************************************************/
#command DRGCOMBOBOX <name> INTO <oFC>  ;
              [ FPOS      <fposX> [, <fposY>] ] ;
              [ FLEN      <fLen> ] ;
              [ FILE      <file> ] ;
              [ REF       <ref> ] ;
              [ VALUES    <values> ] ;
              [ FCAPTION  <fcaption> ] ;
              [ VALUES    <values> ] ;
              [ CPOS      <cposX> [, <cposY>] ] ;
              [ CLEN      <cLen> ] ;
              [ CTYPE     <ctype> ] ;
              [ PRE       <pre> ] ;
              [ POST      <post> ] ;
              [ POSTEVAL  <posteval> ] ;
              [ COMBOINIT     <comboInit> ] ;
              [ ITEMSELECTED  <itemSelected> ] ;
              [ ITEMMARKED    <itemMarked> ] ;
              [ PP        <pp> ] ;
              [ TIPTEXT   <tiptext> ] ;
=> ;
  oDrg := _drgComboBox():new();
  ; oDrg:name    := <"name"> ;
  [; oDrg:fPos    := {<fposX>,<fposY>} ];
  [; oDrg:fLen    := <fLen> ];
  [; oDrg:file    := <file> ];
  [; oDrg:ref     := <ref> ];
  [; oDrg:values  := <values>];
  [; oDrg:fcaption:= <fcaption>];
  [; oDrg:cpos    := {<cposX>,<cposY>}];
  [; oDrg:cLen    := <cLen> ];
  [; oDrg:ctype   := <ctype> ];
  [; oDrg:pre     := <pre> ];
  [; oDrg:post    := <post> ];
  [; oDrg:posteval:= <posteval> ];
  [; oDrg:comboInit    := <comboInit> ];
  [; oDrg:itemSelected := <itemSelected> ];
  [; oDrg:itemMarked   := <itemMarked> ];
  [; oDrg:pp      := <pp> ];
  [; oDrg:tipText := <tiptext> ];
  ;<oFC>:addLine(oDrg)


/***********************************************************
 * DRGTEXT
 ***********************************************************/
#command DRGTEXT INTO     <oFC>  ;
              [ CPOS      <cposX> [, <cposY>] ] ;
              [ CLEN      <cLen> ] ;
              [ CAPTION   <caption> ] ;
              [ TIPTEXT   <tiptext> ] ;
              [ NAME      <name> ] ;
              [ FILE      <file> ] ;
              [ FLEN      <fLen> ] ;
              [ PICTURE   <picture> ] ;
              [ CTYPE     <ctype> ] ;
              [ PP        <pp> ] ;
              [ FONT      <font> ] ;
              [ BGND      <bgnd> ] ;
=> ;
  oDrg := _drgText():new();
  [; oDrg:name    := <"name"> ];
  [; oDrg:cPos    := {<cposX>,<cposY>} ];
  [; oDrg:cLen    := <cLen> ];
  [; oDrg:caption := <caption>];
  [; oDrg:tiptext := <tiptext>];
  [; oDrg:file    := <file> ];
  [; oDrg:fLen    := <fLen> ];
  [; oDrg:picture := <picture>];
  [; oDrg:ctype   := <ctype> ];
  [; oDrg:pp      := <pp> ];
  [; oDrg:font    := <font> ];
  [; oDrg:bgnd    := <bgnd> ];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGTEXT
 ***********************************************************/
#xtrans DRGTEXT <name> INTO  <oFC> [<clauses,...>];
        => DRGTEXT INTO <oFC> NAME <name> [<clauses>]

/***********************************************************
 * DRGSTATIC
 ***********************************************************/
#command DRGSTATIC INTO   <oFC>  ;
              [ FPOS      <fposX> [, <fposY>] ] ;
              [ SIZE      <sizeX> [, <sizeY>] ] ;
              [ CAPTION   <caption> ] ;
              [ STYPE     <stype>   ] ;
              [ RESIZE    <resize>  ] ;
              [ TIPTEXT   <tiptext> ] ;
=> ;
  oDrg := _drgStatic():new();
  [; oDrg:fPos    := {<fposX>,<fposY>} ];
  [; oDrg:size    := {<sizeX>,<sizeY>} ];
  [; oDrg:stype   := <stype>  ];
  [; oDrg:caption := <caption>];
  [; oDrg:resize  := <resize> ];
  [; oDrg:tipText := <tiptext>];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGBROWSE
 ***********************************************************/
#command DRGBROWSE INTO       <oFC>  ;
              [ FPOS          <fposX> [, <fposY>] ] ;
              [ SIZE          <sizeX> [, <sizeY>] ] ;
              [ FILE          <file> ] ;
              [ FIELDS        <fields> ] ;
              [ BROWSEINIT    <browseinit> ] ;
              [ ITEMSELECTED  <itemSelected> ] ;
              [ ITEMMARKED    <itemMarked> ] ;
              [ CURSORMODE    <cursorMode> ] ;
              [ INDEXORD      <indexord> ] ;
              [ PRE           <pre> ] ;
              [ POST          <post> ] ;
              [ SCROLL        <scroll> ] ;
              [ LFREEZE       <lfreeze> ] ;
              [ RFREEZE       <rfreeze> ] ;
              [ PP            <pp> ] ;
              [ RESIZE        <resize>  ] ;
              [ TIPTEXT       <tiptext> ] ;
              [ COLORED       <colored> ] ;

=> ;
  oDrg := _drgBrowse():new();
  [; oDrg:fPos          := {<fposX>,<fposY>} ];
  [; oDrg:size          := {<sizeX>,<sizeY>} ];
  [; oDrg:file          := <file> ];
  [; oDrg:fields        := <fields> ];
  [; oDrg:browseinit    := <browseinit> ];
  [; oDrg:itemSelected  := <itemSelected> ];
  [; oDrg:itemMarked    := <itemMarked> ];
  [; oDrg:cursorMode    := <cursorMode> ];
  [; oDrg:indexord      := <indexord> ];
  [; oDrg:pre           := <pre> ];
  [; oDrg:post          := <post> ];
  [; oDrg:scroll        := <scroll>];
  [; oDrg:lfreeze       := <lfreeze>];
  [; oDrg:rfreeze       := <rfreeze>];
  [; oDrg:pp            := <pp> ];
  [; oDrg:resize        := <resize> ];
  [; oDrg:tipText       := <tiptext> ];
  [; oDrg:colored       := <colored> ];
  ;<oFC>:addLine(oDrg)


/***********************************************************
 * DRGEBROWSE
 ***********************************************************/
#command DRGEBROWSE INTO       <oFC>  ;
              [ FPOS          <fposX> [, <fposY>] ] ;
              [ SIZE          <sizeX> [, <sizeY>] ] ;
              [ FILE          <file> ] ;
              [ FIELDS        <fields> ] ;
              [ BROWSEINIT    <browseinit> ] ;
              [ ITEMSELECTED  <itemSelected> ] ;
              [ ITEMMARKED    <itemMarked> ] ;
              [ CURSORMODE    <cursorMode> ] ;
              [ INDEXORD      <indexord> ] ;
              [ PRE           <pre> ] ;
              [ POST          <post> ] ;
              [ SCROLL        <scroll> ] ;
              [ LFREEZE       <lfreeze> ] ;
              [ RFREEZE       <rfreeze> ] ;
              [ PP            <pp> ] ;
              [ RESIZE        <resize>  ] ;
              [ TIPTEXT       <tiptext> ] ;
              [ GUILOOK       <guilook> ] ;

=> ;
  oDrg := _drgEBrowse():new();
  [; oDrg:fPos          := {<fposX>,<fposY>} ];
  [; oDrg:size          := {<sizeX>,<sizeY>} ];
  [; oDrg:file          := <file> ];
  [; oDrg:fields        := <fields> ];
  [; oDrg:browseinit    := <browseinit> ];
  [; oDrg:itemSelected  := <itemSelected> ];
  [; oDrg:itemMarked    := <itemMarked> ];
  [; oDrg:cursorMode    := <cursorMode> ];
  [; oDrg:indexord      := <indexord> ];
  [; oDrg:pre           := <pre> ];
  [; oDrg:post          := <post> ];
  [; oDrg:scroll        := <scroll>];
  [; oDrg:lfreeze       := <lfreeze>];
  [; oDrg:rfreeze       := <rfreeze>];
  [; oDrg:pp            := <pp> ];
  [; oDrg:resize        := <resize> ];
  [; oDrg:tipText       := <tiptext> ];
  [; oDrg:guilook       := <guilook>];
  ;<oFC>:addLine(oDrg)


/***********************************************************
 * DRGBROWSE
 ***********************************************************/
#command DRGDBROWSE INTO       <oFC>  ;
              [ FPOS          <fposX> [, <fposY>] ] ;
              [ SIZE          <sizeX> [, <sizeY>] ] ;
              [ FILE          <file> ] ;
              [ FIELDS        <fields> ] ;
              [ BROWSEINIT    <browseinit> ] ;
              [ ITEMSELECTED  <itemSelected> ] ;
              [ ITEMMARKED    <itemMarked> ] ;
              [ CURSORMODE    <cursorMode> ] ;
              [ INDEXORD      <indexord> ] ;
              [ PRE           <pre> ] ;
              [ POST          <post> ] ;
              [ SCROLL        <scroll> ] ;
              [ LFREEZE       <lfreeze> ] ;
              [ RFREEZE       <rfreeze> ] ;
              [ PP            <pp> ] ;
              [ RESIZE        <resize>  ] ;
              [ TIPTEXT       <tiptext> ] ;
              [ COLORED       <colored> ] ;
              [ ATSTART       <atstart> ] ;
              [ POPUPMENU     <popup>   ] ;
              [ REST          <rest>    ] ;
              [ HEADMOVE      <headMove>] ;
              [ FOOTER        <footer>  ] ;
              [ GUILOOK       <guilook> ] ;

=> ;
  oDrg := _drgDBrowse():new();
  [; oDrg:fPos          := {<fposX>,<fposY>} ];
  [; oDrg:size          := {<sizeX>,<sizeY>} ];
  [; oDrg:file          := <file> ];
  [; oDrg:fields        := <fields> ];
  [; oDrg:browseinit    := <browseinit> ];
  [; oDrg:itemSelected  := <itemSelected> ];
  [; oDrg:itemMarked    := <itemMarked> ];
  [; oDrg:cursorMode    := <cursorMode> ];
  [; oDrg:indexord      := <indexord> ];
  [; oDrg:pre           := <pre> ];
  [; oDrg:post          := <post> ];
  [; oDrg:scroll        := <scroll>];
  [; oDrg:lfreeze       := <lfreeze>];
  [; oDrg:rfreeze       := <rfreeze>];
  [; oDrg:pp            := <pp> ];
  [; oDrg:resize        := <resize> ];
  [; oDrg:tipText       := <tiptext> ];
  [; oDrg:colored       := <colored> ];
  [; oDrg:atstart       := <atstart> ];
  [; oDrg:popupmenu     := <popup>   ];
  [; oDrg:rest          := <rest>    ];
  [; oDrg:headMove      := <headMove>];
  [; oDrg:footer        := <footer>  ];
  [; oDrg:guilook       := <guilook> ];
  ;<oFC>:addLine(oDrg)


/***********************************************************
 * DRGEDITBROWSE
 ***********************************************************/
#command DRGEDITBROWSE INTO   <oFC>  ;
              [ FPOS          <fposX> [, <fposY>] ] ;
              [ SIZE          <sizeX> [, <sizeY>] ] ;
              [ FILE          <file> ] ;
              [ FIELDS        <fields> ] ;
              [ BROWSEINIT    <browseinit> ] ;
              [ ITEMSELECTED  <itemSelected> ] ;
              [ ITEMMARKED    <itemMarked> ] ;
              [ CURSORMODE    <cursorMode> ] ;
              [ INDEXORD      <indexord> ] ;
              [ PRE           <pre> ] ;
              [ POST          <post> ] ;
              [ SCROLL        <scroll> ] ;
              [ PP            <pp> ] ;
              [ RESIZE        <resize>  ] ;
              [ TIPTEXT       <tiptext> ] ;

=> ;
  oDrg := _drgEditBrowse():new();
  [; oDrg:fPos          := {<fposX>,<fposY>} ];
  [; oDrg:size          := {<sizeX>,<sizeY>} ];
  [; oDrg:file          := <file> ];
  [; oDrg:fields        := <fields> ];
  [; oDrg:browseinit    := <browseinit> ];
  [; oDrg:itemSelected  := <itemSelected> ];
  [; oDrg:itemMarked    := <itemMarked> ];
  [; oDrg:cursorMode    := <cursorMode> ];
  [; oDrg:indexord      := <indexord> ];
  [; oDrg:pre           := <pre> ];
  [; oDrg:post          := <post> ];
  [; oDrg:scroll        := <scroll>];
  [; oDrg:pp            := <pp> ];
  [; oDrg:resize        := <resize> ];
  [; oDrg:tipText       := <tiptext> ];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGLISTBROWSE
 ***********************************************************/
#command DRGLISTBROWSE INTO   <oFC>  ;
              [ FPOS          <fposX> [, <fposY>] ] ;
              [ SIZE          <sizeX> [, <sizeY>] ] ;
              [ FIELDS        <fields> ] ;
              [ CURSORMODE    <cursorMode> ] ;
              [ PRE           <pre> ] ;
              [ POST          <post> ] ;
              [ SCROLL        <scroll> ] ;
              [ PP            <pp> ] ;
              [ RESIZE        <resize>  ] ;
              [ TIPTEXT       <tiptext> ] ;

=> ;
  oDrg := _drgListBrowse():new();
  [; oDrg:fPos          := {<fposX>,<fposY>} ];
  [; oDrg:size          := {<sizeX>,<sizeY>} ];
  [; oDrg:fields        := <fields> ];
  [; oDrg:cursorMode    := <cursorMode> ];
  [; oDrg:pre           := <pre> ];
  [; oDrg:post          := <post> ];
  [; oDrg:scroll        := <scroll>];
  [; oDrg:pp            := <pp> ];
  [; oDrg:resize        := <resize> ];
  [; oDrg:tipText       := <tiptext> ];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGACTION
 ***********************************************************/
#command DRGACTION INTO     <oFC>  ;
              [ POS         <posX> [, <posY>] ] ;
              [ SIZE        <sizeX> [, <sizeY>] ] ;
              [ ATYPE       <aType> ] ;
              [ CAPTION     <caption> ] ;
              [ EVENT       <event> ] ;
              [ ICON1       <icon1> ] ;
              [ ICON2       <icon2> ] ;
              [ ICON3       <icon3> ] ;
              [ RES         <res> ] ;
              [ PRE         <pre> ] ;
              [ TIPTEXT     <tiptext> ] ;
=> ;
  oDrg := _drgAction():new();
  [; oDrg:pos         := {<posX>,<posY>} ];
  [; oDrg:size        := {<sizeX>,<sizeY>} ];
  [; oDrg:aType       := <aType> ];
  [; oDrg:caption     := <caption> ];
  [; oDrg:event       := <event> ];
  [; oDrg:icon1       := <icon1>];
  [; oDrg:icon2       := <icon2>];
  [; oDrg:icon3       := <icon3>];
  [; oDrg:pre         := <pre>];
  [; oDrg:res         := <res>];
  [; oDrg:tipText     := <tiptext> ];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGPUSHBUTTON
 ***********************************************************/
#command DRGPUSHBUTTON INTO <oFC>  ;
              [ POS         <posX> [, <posY>] ] ;
              [ SIZE        <sizeX> [, <sizeY>] ] ;
              [ ATYPE       <aType> ] ;
              [ CAPTION     <caption> ] ;
              [ EVENT       <event> ] ;
              [ ICON1       <icon1> ] ;
              [ ICON2       <icon2> ] ;
              [ ICON3       <icon3> ] ;
              [ RESOURCE    <resource> ] ;
              [ PRE         <pre> ] ;
              [ TIPTEXT     <tiptext> ] ;
=> ;
  oDrg := _drgPushButton():new();
  [; oDrg:pos         := {<posX>,<posY>} ];
  [; oDrg:size        := {<sizeX>,<sizeY>} ];
  [; oDrg:aType       := <aType> ];
  [; oDrg:caption     := <caption> ];
  [; oDrg:event       := <event> ];
  [; oDrg:icon1       := <icon1>];
  [; oDrg:icon2       := <icon2>];
  [; oDrg:icon3       := <icon3>];
  [; oDrg:pre         := <pre>];
  [; oDrg:resource    := <resource>];
  [; oDrg:tipText     := <tiptext> ];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGTABPAGE
 ***********************************************************/
#command DRGTABPAGE INTO <oFC>  ;
              [ FPOS        <posX> [, <posY>] ] ;
              [ SIZE        <sizeX> [, <sizeY>] ] ;
              [ TTYPE       <tType> ] ;
              [ OFFSET      <offPre> [, <offPost>] ] ;
              [ CAPTION     <caption> ] ;
              [ PRE         <pre> ] ;
              [ POST        <post> ] ;
              [ TABHEIGHT   <tabHeight> ] ;
              [ RESIZE      <resize>  ] ;
              [ TIPTEXT     <tiptext> ] ;
              [ SUBTABS     <subTabs> ] ;
              [ SUB         <subs> ] ;
=> ;
  oDrg := _drgTabPage():new();
  [; oDrg:fpos        := {<posX>,<posY>} ];
  [; oDrg:size        := {<sizeX>,<sizeY>} ];
  [; oDrg:tType       := <tType> ];
  [; oDrg:offset      := {<offPre>,<offPost>} ];
  [; oDrg:caption     := <caption> ];
  [; oDrg:pre         := <pre>];
  [; oDrg:post        := <post>];
  [; oDrg:tabHeight   := <tabHeight> ];
  [; oDrg:resize      := <resize> ];
  [; oDrg:tipText     := <tiptext> ];
  [; oDrg:subTabs     := <subTabs> ];
  [; oDrg:subs        := <subs> ];
  ;<oFC>:addLine(oDrg)


/***********************************************************
 * DRGMLE
 ***********************************************************/
#command DRGMLE <name> INTO <oFC>  ;
              [ FPOS      <fposX> [, <fposY>] ] ;
              [ SIZE      <sizeX> [, <sizeY>] ] ;
              [ FILE      <file> ] ;
              [ FCAPTION  <fcaption> ] ;
              [ CPOS      <cposX> [, <cposY>] ] ;
              [ CLEN      <cLen> ] ;
              [ CTYPE     <ctype> ] ;
              [ PRE       <pre> ] ;
              [ POST      <post> ] ;
              [ POSTEVAL  <posteval> ] ;
              [ SCROLL    <scroll> ] ;
              [ <readonly: READONLY>] ;
              [ PP        <pp> ] ;
              [ RESIZE    <resize>  ] ;
              [ TIPTEXT   <tiptext> ] ;
=> ;
  oDrg := _drgMLE():new();
  [; oDrg:name    := <"name"> ];
  [; oDrg:fPos    := {<fposX>,<fposY>} ];
  [; oDrg:size    := {<sizeX>,<sizeY>} ];
  [; oDrg:file    := <file> ];
  [; oDrg:fcaption:= <fcaption>];
  [; oDrg:cpos    := {<cposX>,<cposY>}];
  [; oDrg:cLen    := <cLen> ];
  [; oDrg:ctype   := <ctype> ];
  [; oDrg:pre     := <pre> ];
  [; oDrg:post    := <post> ];
  [; oDrg:posteval:= <posteval> ];
  [; oDrg:scroll  := <scroll>];
  [; oDrg:isReadOnly := <.readonly.>];
  [; oDrg:pp      := <pp> ];
  [; oDrg:resize  := <resize> ];
  [; oDrg:tipText := <tiptext> ];
  ;<oFC>:addLine(oDrg)

/***********************************************************
 * DRGDIALOG
 ***********************************************************/

#command DRGDIALOG ;
              [ FORM      <cForm>   ] ;
              [ PARENT    <oParent> ] ;
              [ CARGO     <mCargo>  ] ;
              [ CARGO_USR <mCargoUsr> ] ;
              [ TITLE     <cTitle>  ] ;
              [ EXITSTATE <nExit>   ] ;
              [ <lModal: MODAL>     ] ;
              [ <lDestroy: DESTROY> ] ;
=> ;
  oDialog := drgDialog():new(<cForm>, <oParent>);
  [; oDialog:cargo  := <mCargo> ];
  [; oDialog:cargo_usr := <mCargoUsr> ];
  ; oDialog:create(<cTitle>,,<.lModal.>) ;
  [; <nExit> := oDialog:exitState ];
  [; oDialog:destroy(<.lDestroy.>); oDialog := NIL ];

#define  _DRG_CH

#endif // #ifndef _DRG_CH