/*
   Program..: DCDIALOG.CH
   Author...: Roger Donnay
   Notice...: (c) DONNAY Software Designs 1987-2007
   Date.....: Dec 23, 2007
   Notes....: Special Dialog commands for eXPress++
*/

#include 'xbp.ch'
#include 'gra.ch'
#include 'memvar.ch'

//#ifndef HKEY_LOCAL_MACHINE
//  #include "dcreg.ch"
//#endif

#ifndef  DCGUI_GETLIST
  #define DCGUI_GETLIST    GetList
#endif

#ifndef _DCDIALOG_CH

#ifndef MOUSE_ENTER
  #define   MOUSE_ENTER   97
#endif
/*
#define   FORCEVALID    OPTION 101
#define   PICKLIST      OPTION 102
#define   READPROTECT   OPTION 106
#define   CAPFIRST      OPTION 107
#define   DOUBLEPICK    OPTION 112
#define   HIDEIT        OPTION 113
#define   CODEBLOCK     OPTION 114
*/
#define   PICKPOINTER   116

// inspired by Brian Wolfsohn
#define   _ALPHABET     "abcdefghijklmnopqrstuvwxyz"
#define   _alphabet     _ALPHABET
#define   _ALPHANUM     "abcdefghijklmnopqrstuvwxyz0123456789"
#define   _ALPHANUMERIC _ALPHANUM

#translate NOEXITVALID <cb> =>  VALID {|o,lExit|iif(!lExit,Eval(<cb>,o),TRUE)}

#define BS_PUSHBUTTON       0x0000
#define BS_DEFPUSHBUTTON    0x0001
#define BS_CHECKBOX         0x0002
#define BS_AUTOCHECKBOX     0x0003
#define BS_RADIOBUTTON      0x0004
#define BS_3STATE           0x0005
#define BS_AUTO3STATE       0x0006
#define BS_GROUPBOX         0x0007
#define BS_USERBUTTON       0x0008
#define BS_AUTORADIOBUTTON  0x0009
#define BS_OWNERDRAW        0x000B
#define BS_LEFTTEXT         0x0020
#define BS_TEXT             0x0000
#define BS_ICON             0x0040
#define BS_BITMAP           0x0080
#define BS_LEFT             0x0100
#define BS_RIGHT            0x0200
#define BS_CENTER           0x0300
#define BS_TOP              0x0400
#define BS_BOTTOM           0x0800
#define BS_VCENTER          0x0C00
#define BS_PUSHLIKE         0x1000
#define BS_MULTILINE        0x2000
#define BS_NOTIFY           0x4000
#define BS_FLAT             0x8000
#define BS_CB_ENTRY         0x540000003
#define BS_RV_ENTRY         0x540000009

#define BS_RIGHTBUTTON      BS_LEFTTEXT

#define GWL_STYLE         -16
#define GWL_EXSTYLE       -20
#define WS_MAXIMIZEBOX    0x10000
#define WS_MINIMIZEBOX    0x20000
#define WS_EX_CONTEXTHELP 0x400
#define WS_SYSMENU        0x80000

#define DC_BUTTON_REMOVEALL             WS_MAXIMIZEBOX + WS_MINIMIZEBOX + WS_SYSMENU            // I used DC to not conflict with current DLG for testing
#define DC_BUTTON_DISABLEMINIMIZE       WS_MINIMIZEBOX
#define DC_BUTTON_DISABLEMAXIMIZE       WS_MAXIMIZEBOX
#define DC_BUTTON_REMOVEMINMAX          WS_MAXIMIZEBOX + WS_MINIMIZEBOX
#define DC_BUTTON_ADDHELP               WS_EX_CONTEXTHELP

#define DCSQL_CARGO_INIT   { 'eXpress++', '', .f., nil, .f. }

#define DCSQL_CARGO_NAME          1
#define DCSQL_CARGO_SORTNAME      2
#define DCSQL_CARGO_SORTDESCEND   3
#define DCSQL_CARGO_SORTBLOCK     4
#define DCSQL_CARGO_FOUND         5

#define DCSQL_CARGO_LEN           5

#define DCSQL_CONNECT_TYPE_READWRITE    1
#define DCSQL_CONNECT_TYPE_READONLY     2


* ------------------- *

#define   SAYRIGHT        SAYOPTION XBPSTATIC_TEXT_RIGHT
#define   SAYLEFT         SAYOPTION XBPSTATIC_TEXT_LEFT
#define   SAYRIGHTBOTTOM  SAYOPTION XBPSTATIC_TEXT_RIGHT + XBPSTATIC_TEXT_BOTTOM
#define   SAYLEFTBOTTOM   SAYOPTION XBPSTATIC_TEXT_LEFT + XBPSTATIC_TEXT_BOTTOM
#define   SAYCENTERBOTTOM SAYOPTION XBPSTATIC_TEXT_CENTER + XBPSTATIC_TEXT_BOTTOM
#define   SAYRIGHTCENTER  SAYOPTION XBPSTATIC_TEXT_RIGHT + XBPSTATIC_TEXT_VCENTER
#define   SAYLEFTCENTER   SAYOPTION XBPSTATIC_TEXT_LEFT + XBPSTATIC_TEXT_VCENTER
#define   SAYRIGHTTOP     SAYOPTION XBPSTATIC_TEXT_RIGHT + XBPSTATIC_TEXT_TOP
#define   SAYLEFTTOP      SAYOPTION XBPSTATIC_TEXT_LEFT + XBPSTATIC_TEXT_TOP
#define   SAYCENTER       SAYOPTION XBPSTATIC_TEXT_CENTER
#define   SAYHCENTER      SAYOPTION XBPSTATIC_TEXT_CENTER
#define   SAYBOTTOM       SAYOPTION XBPSTATIC_TEXT_BOTTOM
#define   SAYBOTTOMLEFT   SAYOPTION XBPSTATIC_TEXT_LEFT + XBPSTATIC_TEXT_BOTTOM
#define   SAYBOTTOMRIGHT  SAYOPTION XBPSTATIC_TEXT_RIGHT + XBPSTATIC_TEXT_BOTTOM
#define   SAYTOP          SAYOPTION XBPSTATIC_TEXT_TOP
#define   SAYTOPCENTER    SAYOPTION XBPSTATIC_TEXT_TOP + XBPSTATIC_TEXT_CENTER
#define   SAYVCENTER      SAYOPTION XBPSTATIC_TEXT_VCENTER
#define   SAYHVCENTER     SAYOPTION XBPSTATIC_TEXT_VCENTER + XBPSTATIC_TEXT_CENTER
#define   SAYWORDBREAK    SAYOPTION XBPSTATIC_TEXT_WORDBREAK

#define   sayright        SAYRIGHT
#define   sayleft         SAYLEFT
#define   sayrightbottom  SAYRIGHTBOTTOM
#define   sayleftbottom   SAYLEFTBOTTOM
#define   saycenterbottom SAYCENTERBOTTOM
#define   sayrightcenter  SAYRIGHTCENTER
#define   sayleftcenter   SAYLEFTCENTER
#define   sayrighttop     SAYRIGHTTOP
#define   saylefttop      SAYLEFTTOP
#define   saycenter       SAYCENTER
#define   sayhcenter      SAYHCENTER
#define   saybottom       SAYBOTTOM
#define   saytop          SAYTOP
#define   saytopcenter    SAYTOPCENTER
#define   sayvcenter      SAYVCENTER
#define   sayhvcenter     SAYHVCENTER

#define   TOOLBAR_TOP                1
#define   TOOLBAR_LEFT               2
#define   TOOLBAR_BOTTOM             3
#define   TOOLBAR_RIGHT              4
#define   TOOLBAR_TOP_LEFT           1
#define   TOOLBAR_LEFT_TOP           2
#define   TOOLBAR_BOTTOM_LEFT        3
#define   TOOLBAR_RIGHT_TOP          4
#define   TOOLBAR_TOP_RIGHT          5
#define   TOOLBAR_BOTTOM_RIGHT       6
#define   TOOLBAR_LEFT_BOTTOM        7
#define   TOOLBAR_RIGHT_BOTTOM       8

#define   DCGUI_ALIGN_TOP            1
#define   DCGUI_ALIGN_LEFT           2
#define   DCGUI_ALIGN_BOTTOM         3
#define   DCGUI_ALIGN_RIGHT          4
#define   DCGUI_ALIGN_CENTER         5

#define   DCGUI_RESIZE_BLOCK         {|x,y,o|{o:currentSize()[1]+x,o:currentSize()[2]+y}}
#define   DCGUI_REPOS_BLOCK          {|x,y,o|{o:currentPos()[1]+x,o:currentPos()[2]+y}}
#define   DCGUI_REPOSX_BLOCK         {|x,y,o|{o:currentPos()[1]+x,o:currentPos()[2]}}
#define   DCGUI_REPOSY_BLOCK         {|x,y,o|{o:currentPos()[1],o:currentPos()[2]+y}}
#define   DCGUI_RESIZEX_BLOCK        {|x,y,o|{o:currentSize()[1]+x,o:currentSize()[2]}}
#define   DCGUI_RESIZEY_BLOCK        {|x,y,o|{o:currentSize()[1],o:currentSize()[2]+y}}
#define   DCGUI_REPOS_CENTER_BLOCK   {|x,y,o|{(o:setParent():currentSize()[1]-o:currentSize()[1])/2,(o:setParent():currentSize()[2]-o:currentSize()[2])/2}}
#define   DCGUI_REPOS_CENTER_X_BLOCK {|x,y,o|{(o:setParent():currentSize()[1]-o:currentSize()[1])/2,o:currentPos()[2]}}
#define   DCGUI_REPOS_CENTER_Y_BLOCK {|x,y,o|{o:currentPos()[1],(o:setParent():currentSize()[2]-o:currentSize()[2])/2}}
#define   DCGUI_RESIZE_AUTO_BLOCK    {|x,y,o,x1,y1,x2,y2|{x1*x2,y1*y2}}
#define   DCGUI_REPOS_AUTO_BLOCK     {|x,y,o,x1,y1,x2,y2|{x1*x2,y1*y2}}

#define   DCGUI_RESIZE_RESIZEONLY     { nil, DCGUI_RESIZE_BLOCK, .f. }
#define   DCGUI_RESIZE_REPOSONLY      { DCGUI_REPOS_BLOCK, nil, .f. }
#define   DCGUI_RESIZE_REPOSONLY_X    { DCGUI_REPOSX_BLOCK, nil, .f. }
#define   DCGUI_RESIZE_REPOSONLY_Y    { DCGUI_REPOSY_BLOCK, nil, .f. }
#define   DCGUI_RESIZE_RESIZEONLY_X   { nil, DCGUI_RESIZEX_BLOCK, .f. }
#define   DCGUI_RESIZE_RESIZEONLY_Y   { nil, DCGUI_RESIZEY_BLOCK, .f. }
#define   DCGUI_RESIZE_BOTH           { nil, DCGUI_RESIZE_BLOCK, .f. }
#define   DCGUI_REPOS_BOTH            { DCGUI_REPOS_BLOCK, nil, .f. }
#define   DCGUI_RESIZE_REPOS          { DCGUI_REPOS_BLOCK, DCGUI_RESIZE_BLOCK, .f. }
#define   DCGUI_RESIZE_NONE           { nil, nil, .f. }
#define   DCGUI_RESIZE_CENTER         { DCGUI_REPOS_CENTER_BLOCK, nil, .f. }
#define   DCGUI_RESIZE_CENTERONLY_X   { DCGUI_REPOS_CENTER_X_BLOCK, nil, .f. }
#define   DCGUI_RESIZE_CENTERONLY_Y   { DCGUI_REPOS_CENTER_Y_BLOCK, nil, .f. }
#define   DCGUI_RESIZE_REPOSY_RESIZEX { DCGUI_REPOSY_BLOCK, DCGUI_RESIZEX_BLOCK, .f. }
#define   DCGUI_RESIZE_REPOSX_RESIZEY { DCGUI_REPOSX_BLOCK, DCGUI_RESIZEY_BLOCK, .f. }
#define   DCGUI_RESIZE_AUTORESIZE     { DCGUI_REPOS_AUTO_BLOCK, DCGUI_RESIZE_AUTO_BLOCK, .f. }
#define   DCGUI_RESIZE_AUTORESIZE_SCALEFONT { DCGUI_REPOS_AUTO_BLOCK, DCGUI_RESIZE_AUTO_BLOCK, .t. }

#define   DCGUI_TAGMODE_CLEAR        0
#define   DCGUI_TAGMODE_SET          1

#define   BROWSE_ARRAY               1
#define   BROWSE_DATABASE            2
#define   BROWSE_SQLEXPRESS          3
#define   BROWSE_DATAOBJECT          4
#define   BROWSE_ACESERVER           5
#define   BROWSE_ADSHANDLE           6

#define   MESSAGEBOX_TOP             1
#define   MESSAGEBOX_BOTTOM          2

#define   DCGUI_DRAG_ENTIRE_OBJECT   1    // POINTER_ARROW_L
#define   DCGUI_DRAG_RIGHT_TOP       2    // POINTER_SIZE1_1
#define   DCGUI_DRAG_LEFT_BOTTOM     3    // POINTER_SIZE1_1
#define   DCGUI_DRAG_LEFT_TOP        4    // POINTER_SIZE2_1
#define   DCGUI_DRAG_RIGHT_BOTTOM    5    // POINTER_SIZE2_1
#define   DCGUI_DRAG_LEFT            6    // POINTER_SIZE3_1
#define   DCGUI_DRAG_RIGHT           7    // POINTER_SIZE3_1
#define   DCGUI_DRAG_TOP             8    // POINTER_SIZE4_1
#define   DCGUI_DRAG_BOTTOM          9    // POINTER_SIZE4_1

#define   DCGUI_REGION_OCTAGON       1
#define   DCGUI_REGION_DIAMOND       2
#define   DCGUI_REGION_ELLIPSE       3

#define   DCGUI_NONE            1    // Handle Default Event
#define   DCGUI_IGNORE          2    // Ignore Event
#define   DCGUI_CLEAR           3    // Ignore Event and Clear Queue
#define   DCGUI_EXIT            4    // Exit GUI Reader
#define   DCGUI_EXIT_ABORT      5    // Exit GUI Reader WITH .FALSE. and ;
                                     // restore all memvars
#define   DCGUI_EXIT_OK         6    // Exit GUI Reader WITH .TRUE.
#define   DCGUI_MOVE_UP         7    // Set Focus to previous item in GetList
#define   DCGUI_MOVE_DOWN       8    // Set Focus to next item in Getlist
#define   DCGUI_MOVE_TOP        9    // Set Focus to first item in Getlist
#define   DCGUI_MOVE_BOTTOM     10   // Set Focus to last item in GetList
#define   DCGUI_MOVE_UP_PAR     11   // Set Focus to previous item in Parent
#define   DCGUI_MOVE_DOWN_PAR   12   // Set Focus to next item in Parent
#define   DCGUI_MOVE_TOP_PAR    13   // Set Focus to first item in Parent
#define   DCGUI_MOVE_BOTTOM_PAR 14   // Set Focus to last item in Parent
#define   DCGUI_NOHOTKEY        15   // Don't activate any hotkey associated with current event

#define   DCGUI_TAB_SELECT_NEXT     1    // Select Next Tab Page
#define   DCGUI_TAB_SELECT_PREVIOUS 2    // Select Previous Tab Page
#define   DCGUI_TAB_SELECT_FIRST    3    // Select First Tab Page
#define   DCGUI_TAB_SELECT_LAST     4    // Select Last Tab Page

#define   DCGUI_DEBUG_CREATE        1    // Turn on debugging during creation
#define   DCGUI_DEBUG_EVENTS        2    // Turn on Event Spy debugging in Event Loop
#define   DCGUI_DEBUG_VALIDATE      4    // Turn on debugging when validating

#define   DCGUI_HELP_REQUEST        1    // Array element of :helpLink that holds F1 Help Request Object
#define   DCGUI_HELP_TOOLTIP        2    // Array element of :helpLink that holds Tooltip Object

#define   DCGUI_ROW                 -10000
#define   DCGUI_COL                 -10000
#define   DCGUI_PARENTWIDTH         -10000
#define   DCGUI_PARENTHEIGHT        -10000

#define   DCGETREFRESH_ID_INCLUDE     1    // Only refresh included IDs
#define   DCGETREFRESH_ID_EXCLUDE     2    // Only refresh excluded IDs
#define   DCGETREFRESH_TYPE_INCLUDE   3    // Only refresh included Types
#define   DCGETREFRESH_TYPE_EXCLUDE   4    // Only refresh excluded Types
#define   DCGETREFRESH_IDTYPE_INCLUDE 5    // Only refresh included IDs and Types
#define   DCGETREFRESH_IDTYPE_EXCLUDE 6    // Only refresh excluded IDs and Types


#define   DCGUI_BROWSE_EDITEXIT     0    // Exit cell editing after ENTER

#define   DCGUI_BROWSE_EDITACROSS   1    // Move across columns during browse edit after ENTER

#define   DCGUI_BROWSE_EDITDOWN     2    // Move down columns during browse edit after ENTER

#define   DCGUI_BROWSE_INSERT       3    // Insert a new array element or record in browse

#define   DCGUI_BROWSE_DELETE       4    // Delete array element or record in browse

#define   DCGUI_BROWSE_EDITACROSSDOWN  ;
                                    5    // Move across and then down

#define   DCGUI_BROWSE_APPEND       6    // Add a new array element or record in browse

#define   DCGUI_BROWSE_EDITACROSSDOWN_APPEND  ;
                                    7    // Move across and then down.  Append new element or record
                                         // if hit bottom.

#define   DCGUI_BROWSE_SUBMODE_1    1    // Don't allow movement to move to new row
#define   DCGUI_BROWSE_SUBMODE_2    2    // Allow movement to new row

#define   DCGUI_BROWSEFRAME_THICK                  131
#define   DCGUI_BROWSEFRAME_THICK_RAISED            -1
#define   DCGUI_BROWSEFRAME_THICK_RECESSED          33
#define   DCGUI_BROWSEFRAME_VERYTHICK_RECESSED     163
#define   DCGUI_BROWSEFRAME_THICK_OUTLINE          129
#define   DCGUI_BROWSEFRAME_THIN_RAISED             -2 //17
#define   DCGUI_BROWSEFRAME_THIN_BLACK_RECESSED      1
#define   DCGUI_BROWSEFRAME_THIN_GREY_RECESSED      32
#define   DCGUI_BROWSEFRAME_VERYTHIN_RECESSED        3
#define   DCGUI_BROWSEFRAME_VERYTHICK_RAISED       503

#define   DCGUI_BUTTON_OK           1    // Add OK Button
#define   DCGUI_BUTTON_CANCEL       2    // Add CANCEL Button
#define   DCGUI_BUTTON_EXIT         4    // Add EXIT Button
#define   DCGUI_BUTTON_HELP         8    // Add HELP Button
#define   DCGUI_BUTTON_YES         16    // Add YES Button
#define   DCGUI_BUTTON_NO          32    // Add NO Button
#define   DCGUI_BUTTON_CUSTOM    1024    // Add CUSTOM Button

#define   DCGUI_BUTTONALIGN_LEFT    0    // Align Buttons Left
#define   DCGUI_BUTTONALIGN_CENTER  1    // Align Buttons Center
#define   DCGUI_BUTTONALIGN_RIGHT   2    // Align Buttons Right

#define   DCGUI_POPUPSTYLE_OUTSIDE  0    // Popup Button is outside of GET
#define   DCGUI_POPUPSTYLE_IMBEDDED 1    // Popup Button is imbedded in GET

// Events  ( 2000 - 2999 reserved by eXPress++ )

#define   DCGUI_EVENT_BROWSE_REFRESH  xbeP_User + 2000
#define   DCGUI_HELP_LOOKUP           xbeP_User + 2001
#define   DCGUI_HELP_BUILD_TREE       xbeP_User + 2002
#define   DCGUI_EVENT_DRAGDROP        xbeP_User + 2003
#define   DCGUI_EVENT_ACTION          xbeP_User + 2004

#define   DCGUI_WINMENU_DESTROYMODE_EXIT   0
#define   DCGUI_WINMENU_DESTROYMODE_CLOSE  1

#define   DCGETLISTVALIDATE_ID_INCLUDE   1    // Only validate included IDs
#define   DCGETLISTVALIDATE_ID_EXCLUDE   2    // Only validate excluded IDs
#define   DCGETLISTVALIDATE_TYPE_INCLUDE 3    // Only validate included Types
#define   DCGETLISTVALIDATE_TYPE_EXCLUDE 4    // Only validate excluded Types

#define   DCGUI_MENUTYPE_PULLDOWN        0
#define   DCGUI_MENUTYPE_TREEVIEW        1
#define   DCGUI_MENUTYPE_TOOLBAR         2

#define   DCGUI_SPLITBAR_VERTICAL        0
#define   DCGUI_SPLITBAR_HORIZONTAL      1

* ------------------- *

#define GETLIST_STATIC           1
#define GETLIST_GET              2
#define GETLIST_MLE              3
#define GETLIST_3STATE           4
#define GETLIST_CHECKBOX         5
#define GETLIST_COMBOBOX         6
#define GETLIST_LISTBOX          7
#define GETLIST_SLE              8
#define GETLIST_PUSHBUTTON      10
#define GETLIST_RADIOBUTTON     11
#define GETLIST_SAY             12
#define GETLIST_SAY_OPT         12.1
#define GETLIST_ADDBUTTON       13
#define GETLIST_SPINBUTTON      14

#define GETLIST_MXPUSHBUTTON    15
#define GETLIST_MXADDBUTTON     16
#define GETLIST_XPPUSHBUTTON    17
#define GETLIST_XPADDBUTTON     18

#define GETLIST_GROUPBOX        19
#define GETLIST_TABPAGE         20
#define GETLIST_SCROLLBAR       21
#define GETLIST_BITMAP          22
#define GETLIST_METAFILE        23
#define GETLIST_TOOLBAR         24
#define GETLIST_TOOLBAR_OPT     24.1
#define GETLIST_MENUBAR         25
#define GETLIST_SUBMENU         26
#define GETLIST_MENUITEM        27
#define GETLIST_BROWSE          28
#define GETLIST_BROWSECOL       29

#define GETLIST_MESSAGEBOX      30
#define GETLIST_MESSAGEBOX_OPT  30.1
#define GETLIST_CUSTOM          31
#define GETLIST_APPCRT          32
#define GETLIST_PICKLIST        33
#define GETLIST_PROGRESS        34
#define GETLIST_STATUSBAR       35
#define GETLIST_HOTKEY          36
#define GETLIST_QUICKBROWSE     37
#define GETLIST_PANEL           38
#define GETLIST_SPLITBAR        39

#define GETLIST_APPEDIT         40
#define GETLIST_APPBROWSE       41
#define GETLIST_APPFIELD        42

#define GETLIST_DIRTREE         50

#define GETLIST_TREEARRAY       60
#define GETLIST_DIALOG          61
#define GETLIST_TREEROOT        62
#define GETLIST_TREEITEM        63

#define GETLIST_GRASTRING       70
#define GETLIST_GRALINE         71
#define GETLIST_GRABOX          72
#define GETLIST_GRAPROC         73

#define GETLIST_BARGRAPH        75
#define GETLIST_RMCHART         76
#define GETLIST_RMCHARTREGION   77

#define GETLIST_OBJECT          80
#define GETLIST_EVAL            81
#define GETLIST_ACTIVEX         82
#define GETLIST_HTMLVIEWER      83
#define GETLIST_RTF             84
#define GETLIST_GENERIC         85

#define GETLIST_USEREVENT       92
#define GETLIST_SETSAYOPTION    93
#define GETLIST_SETCOLOR        94
#define GETLIST_SETFONT         95
#define GETLIST_SETRESIZE       96
#define GETLIST_SETGROUP        97
#define GETLIST_SETPARENT       98
#define GETLIST_DATASTORE       99
#define GETLIST_CLICK           100

* -- 110 thru 149 are defined in DCHTML.CH -- *

* -- 200 thru 499 are reserved for third party support -- *
#define GETLIST_3P_START        200
#define GETLIST_KLMLE           200

#define GETLIST_3P_END          499

#define GETLIST_USER            1000

#define nGETLIST_TYPE            1
#define nGETLIST_SUBTYPE         2
#define cGETLIST_CAPTION         3
#define bGETLIST_VAR             4
#define nGETLIST_STARTROW        5
#define nGETLIST_STARTCOL        6
#define nGETLIST_ENDROW          7
#define nGETLIST_ENDCOL          8
#define nGETLIST_WIDTH           9
#define nGETLIST_HEIGHT         10
#define cGETLIST_FONT           11
#define cGETLIST_PICTURE        12
#define bGETLIST_WHEN           13
#define bGETLIST_VALID          14
#define cGETLIST_TOOLTIP        15
#define xGETLIST_CARGO          16
#define aGETLIST_PRESENTATION   17
#define bGETLIST_ACTION         18
#define oGETLIST_OBJECT         19
#define xGETLIST_ORIGVALUE      20
#define xGETLIST_OPTIONS        21
#define aGETLIST_COLOR          22
#define cGETLIST_MESSAGE        23
#define cGETLIST_HELPCODE       24
#define cGETLIST_VARNAME        25
#define bGETLIST_READVAR        26
#define bGETLIST_DELIMVAR       27
#define bGETLIST_GROUP          28
#define nGETLIST_POINTER        29
#define bGETLIST_PARENT         30
#define bGETLIST_REFVAR         31
#define bGETLIST_PROTECT        32
#define lGETLIST_PIXEL          33
#define nGETLIST_CURSOR         34
#define bGETLIST_EVAL           35
#define bGETLIST_RELATIVE       36
#define xGETLIST_OPTIONS2       37
#define xGETLIST_OPTIONS3       38
#define xGETLIST_OPTIONS4       39
#define xGETLIST_OPTIONS5       40
#define xGETLIST_OPTIONS6       41
#define xGETLIST_OPTIONS7       42
#define xGETLIST_OPTIONS8       43
#define xGETLIST_OPTIONS9       44
#define cGETLIST_LEVEL          45
#define cGETLIST_TITLE          46
#define cGETLIST_ACCESS         47
#define bGETLIST_COMPILE        48
#define cGETLIST_ID             49
#define dGETLIST_REVDATE        50
#define cGETLIST_REVTIME        51
#define cGETLIST_REVUSER        52
#define bGETLIST_HIDE           53
#define nGETLIST_ACCELKEY       54
#define bGETLIST_GOTFOCUS       55
#define bGETLIST_LOSTFOCUS      56
#define lGETLIST_TABSTOP        57
#define nGETLIST_TABGROUP       58
#define lGETLIST_VISIBLE        59
#define cGETLIST_GETGROUP       60
#define lGETLIST_FLAG           61
#define aGETLIST_PROC           62
#define bGETLIST_PREEVAL        63
#define bGETLIST_POSTEVAL       64  // Added for HTML stuff
#define bGETLIST_CLASS          65  // Added for HTML stuff
#define aGETLIST_RESIZE         66
#define aGETLIST_DRAGDROP       67
#define oGETLIST_CONFIG         68
#define cGETLIST_SUBCLASS       69

#define nGET_ARRAY_SIZE         69

#define cGETOPT_NAME              1
#define cGETOPT_TITLE             2
#define nGETOPT_WNDHEIGHT         3
#define nGETOPT_WNDWIDTH          4
#define nGETOPT_ROWSPACE          5
#define nGETOPT_SAYWIDTH          6
#define cGETOPT_SAYFONT           7
#define cGETOPT_GETFONT           8
#define nGETOPT_GETHEIGHT         9
#define aGETOPT_BUTTONS          10
#define nGETOPT_WNDROW           11
#define nGETOPT_WNDCOL           12
#define nGETOPT_ROWOFFSET        13
#define nGETOPT_COLOFFSET        14
#define lGETOPT_DESIGN           15
#define cGETOPT_MENU             16
#define lGETOPT_PIXEL            17
#define xGETOPT_SPARE            18
#define nGETOPT_ICON             19
#define lGETOPT_CHECKGET         20
#define cGETOPT_HELPFILE         21
#define lGETOPT_VISIBLE          22
#define lGETOPT_TRANSLATE        23
#define lGETOPT_SAYRIGHT         24
#define nGETOPT_BITMAP           25
#define aGETOPT_PRESENT          26
#define nGETOPT_BGCOLOR          27
#define nGETOPT_SAYOPT           28
#define bGETOPT_EVAL             29
#define nGETOPT_MODALSTATE       30
#define nGETOPT_SAYHEIGHT        31
#define lGETOPT_MINBUTTON        32
#define lGETOPT_MAXBUTTON        33
#define lGETOPT_TABSTOP          34
#define lGETOPT_ABORTQUERY       35
#define nGETOPT_ROWPIXELS        36
#define nGETOPT_COLPIXELS        37
#define lGETOPT_ESCAPEKEY        38
#define cGETOPT_SOURCECODE       39
#define aGETOPT_TOOLCOLOR        40
#define nGETOPT_BORDER           41
#define lGETOPT_EXVALID          42
#define lGETOPT_CLOSEQUERY       43
#define lGETOPT_NOTASKLIST       44
#define aGETOPT_MINSIZE          45
#define aGETOPT_MAXSIZE          46
#define lGETOPT_NORESIZE         47
#define lGETOPT_NOTITLEBAR       48
#define lGETOPT_NOMOVE           49
#define nGETOPT_ORIGIN           50
#define nGETOPT_HILITECOLOR      51
#define lGETOPT_SUPERVISE        52
#define lGETOPT_HIDEDIALOG       53
#define lGETOPT_NOBUSY           54
#define cGETOPT_BUSYMSG          55
#define nGETOPT_DESIGNKEY        56
#define lGETOPT_CASCADE          57
#define lGETOPT_AUTORESIZE       58
#define aGETOPT_COLORGETS        59
#define lGETOPT_CONFIRM          60
#define nGETOPT_FITPAD           61
#define nGETOPT_BUTTONALIGN      62
#define lGETOPT_EXITQUERY        63
#define nGETOPT_DISABLEDCOLOR    64
#define lGETOPT_ENTERTAB         65
#define bGETOPT_PREEVAL          66
#define cGETOPT_FONT             67
#define bGETOPT_EDITPROTECT      68
#define oGETOPT_MESSAGEINTO      69
#define bGETOPT_NOEDITNAVKEYS    70
#define aGETOPT_BUTTONSOUND      71
#define lGETOPT_MESSAGECLEAR     72
#define cGETOPT_HELPCODE         73
#define lGETOPT_AUTOWINMENU      74
#define cGETOPT_KEYBOARD         75
#define lGETOPT_NOWINMENU        76
#define lGETOPT_QUITQUERY        77
#define cGETOPT_TOOLFONT         78
#define nGETOPT_TOOLTIME         79
#define lGETOPT_AUTOFOCUS        80
#define lGETOPT_COMPATIBLE       81
#define lGETOPT_RESIZE           82
#define aGETOPT_SCALEFACTOR      83
#define cGETOPT_FONTDEFAULT      84
#define aGETOPT_RESIZEDEFAULT    85
#define lGETOPT_NOTABSTOP        86
#define lGETOPT_ALWAYSONTOP      87
#define bGETOPT_ONCLICK          88
#define lGETOPT_ENTEREXIT        89
#define lGETOPT_RESTDEFBUTT      90
#define nGETOPT_SCROLLBARS       91
#define cGETOPT_GETTEMPLATE      92
#define bGETOPT_EDITPROTECTSAFE  93
#define lGETOPT_LOCKTOOWNER      94

#define nGETOPT_ARRAY_SIZE       94

* ------------------------------- *


#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
     <uVar1> := IIF(Valtype(<uVar1>)==Valtype(<uVal1>).OR.<uVal1>==NIL,<uVar1>,<uVal1>) ;;
   [ <uVarN> := IIF(Valtype(<uVarN>)==Valtype(<uValN>).OR.<uValN>==NIL,<uVarN>,<uValN>); ]

* ------------------------------- *

#xcommand LOGICDEFAULT <uVar> := <uVal>  => ;
          <uVar> := IIF(Valtype(<uVar>)=='L',<uVar>, ;
                    IIF(Valtype(<uVal>)=='L',<uVal>,.f.))

* ------------------------------- *

#command  @ <nRow> [,<nCol>] DCDIALOG <oObject>                             ;
                [DRAWINGAREA <oDrawingArea>]                                ;
                [FONT <cFont>]                                              ;
                [<c:CAPTION,TITLE> <cTitle>]                                ;
                [BITMAP <nBitMap>]                                          ;
                [RESTYPE <cResType>]                                        ;
                [RESFILE <cResFile>]                                        ;
                [ICON <nIcon>]                                              ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [PRESENTATION <aPres>]                                      ;
                [CARGO <xCargo>]                                            ;
                [CURSOR <nCursor>]                                          ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [RELATIVE <oRel>]                                           ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [TITLE <cTitle>]                                            ;
                [ID <cId>]                                                  ;
                [TOOLTIP <cToolTip>]                                        ;
                [<lModal:MODAL>] [_MODAL <_modal>]                          ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [<lNoMin:NOMINBUTTON,NOMINIMIZE>] [_NOMINBUTTON <_nomin>]   ;
                [<lNoMax:NOMAXBUTTON,NOMAXIMIZE>] [_NOMAXBUTTON <_nomax>]   ;
                [GROUP <cGroup>]                                            ;
                [BORDER <nBorder>]                                          ;
                [<lNoTitleBar:NOTITLEBAR>] [_NOTITLEBAR <_notitlebar>]      ;
                [<lNoReSize:NORESIZE>] [_NORESIZE <_noresize>]              ;
                [<lNoTaskList:NOTASKLIST>] [_NOTASKLIST <_notasklist>]      ;
                [<lOverride:NOAUTORESTORE>] [_NOAUTORESTORE <_override>]    ;
                [MINSIZE <nMinCol>, <nMinRow>]                              ;
                [MAXSIZE <nMaxCol>, <nMaxRow>]                              ;
                [MENU <acMenu> [MSGBOX <oMsgBox>]]                          ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lAutoResize:AUTORESIZE>] [_AUTORESIZE <_autoresize>]      ;
                [<lFit:FIT> [_FIT <_fit>] [FITPAD <nFitPad>]]               ;
                [<lSetAppWindow:SETAPPWINDOW>]                              ;
                [_SETAPPWINDOW <_setappwindow>]                             ;
                [CLASS <bcClass>]                                           ;
                [SUBCLASS <cSubClass>]                                      ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [SCALE <aScaleFactor>]                                      ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [SCROLLBARS <nScrollbars>]                                  ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
    { GETLIST_DIALOG,                           /* nGETLIST_TYPE         */ ;
      nil,                                      /* nGETLIST_SUBTYPE      */ ;
      <cTitle>,                                 /* cGETLIST_CAPTION      */ ;
      nil,                                      /* bGETLIST_VAR          */ ;
      <nRow>,                                   /* nGETLIST_STARTROW     */ ;
      <nCol>,                                   /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      <nWidth>,                                 /* nGETLIST_WIDTH        */ ;
      <nHeight>,                                /* nGETLIST_HEIGHT       */ ;
      <cFont>,                                  /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      <bWhen>,                                  /* bGETLIST_WHEN         */ ;
      nil,                                      /* bGETLIST_VALID        */ ;
      <cToolTip>,                               /* cGETLIST_TOOLTIP      */ ;
      <xCargo>,                                 /* xGETLIST_CARGO        */ ;
      <aPres>,                                  /* aGETLIST_PRESENTATION */ ;
      nil,                                      /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      { <nIcon>,<nBitMap>,!<.lNoMin.> [.AND. !<_nomin>],                    ;
        !<.lNoMax.> [.AND. !<_nomax>],                                      ;
        <.lModal.> [.OR. <_modal>],<nBorder>,                               ;
        !<.lNoTitleBar.> [.AND. !<_notitlebar>],                            ;
        <.lNoReSize.> [.OR. <_noresize>],                                   ;
        [{<nMinCol>, <nMinRow>}],[{<nMaxCol>, <nMaxRow>}],                  ;
        <.lNoTaskList.> [.OR. <_notasklist>],<.lFit.> [.OR. <_fit>],        ;
        <nFitPad>,                                                          ;
        <.lSetAppWindow.> [.OR. <_setappwindow>],                           ;
        <.lOverride.> [.OR. <_override>] },                                 ;
                                                /* xGETLIST_OPTIONS      */ ;
      [{<ncFgC>,<ncBgC>}],                      /* aGETLIST_COLOR        */ ;
      nil,                                      /* cGETLIST_MESSAGE      */ ;
      nil,                                      /* cGETLIST_HELPCODE     */ ;
      nil,                                      /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [DC_GetAnchorCB(@<oObject>,'O')],         /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),<(oParent)>,'O'}][<cPID>],           ;
                                                /* bGETLIST_PARENT       */ ;
      [{DC_GetAnchorCB(@<oDrawingArea>,'O'),<(oDrawingArea)>,'O'}],         ;
                                                /* bGETLIST_REFVAR       */ ;
      nil,                                      /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      <nCursor>,                                /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),<(oRel)>,'O'}],                         ;
                                                /* bGETLIST_RELATIVE     */ ;
      [{<acMenu>,<oMsgBox>}],                   /* xGETLIST_OPTIONS2     */ ;
      <.lAutoResize.>,                          /* xGETLIST_OPTIONS3     */ ;
      [{<(cResType)>,<cResFile>}],              /* xGETLIST_OPTIONS4     */ ;
      [<nScrollbars>],                          /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      nil,                                      /* nGETLIST_ACCELKEY     */ ;
      <bGotFocus>,                              /* bGETLIST_GOTFOCUS     */ ;
      <bLostFocus>,                             /* bGETLIST_LOSTFOCUS    */ ;
      .f.,                                      /* lGETLIST_TABSTOP      */ ;
      nil,                                      /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
      [<aReSize>],                              /* aGETLIST_RESIZE       */ ;
      nil,                                      /* aGETLIST_DRAGDROP     */ ;
      nil,                                      /* oGETLIST_CONFIG       */ ;
      <cSubClass>,                              /* cGETLIST_SUBCLASS     */ ;
    } )                                                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]

* ------------------------ *

#command   @ <nRow> [,<nCol>] DCSAY [<cText>]                               ;
                [SAYVAR <uSayVar>]                                          ;
                [<font:FONT,SAYFONT> <cFont>]                               ;
                [PICTURE <cPict>]                                           ;
                [<color:COLOR,SAYCOLOR> <ncFgC> [,<ncBgC>] ]                ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [<option:OPTIONS,SAYOPTIONS> <nOpt>]                        ;
                [<size:SIZE,SAYSIZE> <nWidth> [,<nHeight>]]                 ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [PRESENTATION <aPres>]                                      ;
                [<tool:TOOLTIP,SAYTOOLTIP> <cToolTip>]                      ;
                [MESSAGE <cMessage>]                                        ;
                [<object:OBJECT,SAYOBJECT> <oObject>]                       ;
                [CARGO <xCargo>]                                            ;
                [CURSOR <nCursor>]                                          ;
                [<eval:EVAL,SAYEVAL> <bEval>]                               ;
                [<preeval:PREEVAL,SAYPREEVAL> <bPreEval>]                   ;
                [<posteval:POSTEVAL,SAYPOSTEVAL> <bPostEval>]               ;
                [RELATIVE <oRel>]                                           ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [HELPCODE <cHelpCode>]                                      ;
                [TITLE <cTitle>]                                            ;
                [<id:ID,SAYID> <cId>]                                       ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [_INVISIBLE <_invis>]              ;
                [GROUP <cGroup>]                                            ;
                [<lGraString:GRASTRING>] [_GRASTRING <_grastring>]          ;
                [CLASS <bcClass>]                                           ;
                [HYPERLINK <bHyperLink>]                                    ;
                [RESIZE <aReSize> [<sf:SCALEFONT>]]                         ;
                [<lAlignRight:ALIGNRIGHT>] [_ALIGNRIGHT <_alignright>]      ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [<config:CONFIG,SAYCONFIG> <oConfig>]                       ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST, DC_GetTemplate(GETLIST_SAY, XBPSTATIC_TYPE_TEXT) )  ;
     ;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cText>)                 ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                             ;
              DC_GetAnchorCB(@<uSayVar>,'C'))]                              ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                   ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_PICTURE,<cPict>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                   ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,<cMessage>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,{<nOpt>})]               ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]        ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                           ;
          DC_GetAnchorCB(@<oObject>,'O'))]                                  ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                          ;
          DC_GetAnchorCB(@<oParent>,'O'))]                                  ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                  ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                    ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                   ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                        ;
          DC_GetAnchorCb(@<oRel>,'O'))]                                     ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<.lGraString.>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<_grastring>)]          ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,<.lAlignRight.>)]       ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,<_alignright>)]         ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS9,<bHyperLink>)]          ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                       ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                   ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                        ;
      {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]       ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]           ;

* ------------------------------- *

#command  @ <nSayRow> [,<nSayCol>] DCSAY [<cText>]                          ;
                GET <uVar>                                                  ;
                [GETPOS <nGetRow> [,<nGetCol>] ]                            ;
                [DATALINK <bLink>]                                          ;
                [SAYVAR <uSayVar>]                                          ;
                [<color:COLOR,SAYCOLOR> <ncSayFgC> [,<ncSayBgC>] ]          ;
                [GETCOLOR <ncGetFgC> [,<ncGetBgC>] ]                        ;
                [OPTION <option>]                                           ;
                [<lGraString:GRASTRING>] [_GRASTRING <_grastring>]          ;
                [SAYSIZE <nSayWidth> [,<nSayHeight>]]                       ;
                [GETSIZE <nGetWidth> [,<nGetHeight>]]                       ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [VALID <bValid>]                                            ;
                [SAYOPTION <nSayOpt>]                                       ;
                [SAYHELPCODE <cSayHelpCode>]                                ;
                [<hc:HELPCODE,GETHELPCODE> <cHelpCode>]                     ;
                [PREBLOCK <preblock>]                                       ;
                [POSTBLOCK <postblock>]                                     ;
                [<kb:KEYBLOCK,KEYBOARD> <keyblock>]                         ;
                [PICTURE <cPict>]                                           ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [<u: UNREADABLE>] [_UNREADABLE <_unreadable>]               ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [<noconfirm: NOCONFIRM>] [_NOCONFIRM <_noconfirm>]          ;
                [<confirm: CONFIRM>] [_CONFIRM <_confirm>]                  ;
                [SAYPRESENTATION <aSayPres>]                                ;
                [GETPRESENTATION <aGetPres>]                                ;
                [TOOLTIP <cToolTip>]                                        ;
                [SAYTOOLTIP <cSayToolTip>]                                  ;
                [GETTOOLTIP <cGetToolTip>]                                  ;
                [SAYOBJECT <oSayObject>]                                    ;
                [GETOBJECT <oGetObject>]                                    ;
                [SAYCURSOR <nSayCursor>]                                    ;
                [GETCURSOR <nGetCursor>]                                    ;
                [SAYCARGO <xSayCargo>]                                      ;
                [GETCARGO <xGetCargo>]                                      ;
                [SAYEVAL <bSayEval>]                                        ;
                [SAYPREEVAL <bSayPreEval>]                                  ;
                [SAYPOSTEVAL <bSayPostEval>]                                ;
                [GETEVAL <bGetEval>]                                        ;
                [GETPREEVAL <bGetPreEval>]                                  ;
                [GETPOSTEVAL <bGetPostEval>]                                ;
                [SAYTITLE <cSayTitle>]                                      ;
                [GETTITLE <cGetTitle>]                                      ;
                [SAYFONT <cSayFont>]                                        ;
                [GETFONT <cGetFont>]                                        ;
                [NAME <cVarName>]                                           ;
                [RELATIVE <oRel>]                                           ;
                [SAYID <cSayId>]                                            ;
                [GETID <cGetId>]                                            ;
                [POPUP <bPopUp> [<lPopTab:POPTABSTOP>]                      ;
                   [<d:DROPDOWN>] [POPCAPTION <c>] [POPFONT <f>]            ;
                   [POPWIDTH <w>] [POPHEIGHT <h>]                           ;
                   [POPWHEN <pw>] [POPHIDE <ph>]                            ;
                   [POPSTYLE <s>] [POPKEY <k>] [<g:POPGLOBAL>] ]            ;
                   [POPTOOLTIP <t>]                                         ;
                [<pv:POPVALID>]                                             ;
                [COMBO [HEIGHT <nComboHeight>] [WIDTH <nComboWidth>]        ;
                    [DATA <acbComboData>]                                   ;
                    [<nf:FIELD,ELEMENT> <nbField>] [RETURN <bReturn>]       ;
                    [CAPTION <cComboCaption>] [FONT <cComboFont>]           ;
                    [HOTKEY <nComboHotKey>] [LISTFONT <cListFont>]          ;
                    [<keydrop:KEYDROP>]                                     ;
                    [LISTPRESENTATION <aListPres>] ]                        ;
                [ACCELKEY <nAccel>]                                         ;
                [REFERENCE <xRef>]                                          ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<pass:PASSWORD>] [_PASSWORD <_password>]                   ;
                [PASSCHAR <cPassChar>]                                      ;
                [<proper:PROPER> [PROPOPTIONS <aProperOptions>]]            ;
                [_PROPER <_proper>]                                         ;
                [<ljust:LEFTJUSTIFY>] [_LEFTJUSTIFY <_leftjustify>]         ;
                [RANGE <nStart>, <nEnd>]                                    ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [_INVISIBLE <_invis>]              ;
                [GROUP <cGroup>]                                            ;
                [SAYCLASS <bcSayClass>]                                     ;
                [GETCLASS <bcGetClass>]                                     ;
                [HYPERLINK <bHyperLink>]                                    ;
                [<lCalc:CALCULATOR>] [_CALCULATOR <_calc>]                  ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [SAYRESIZE <aSayReSize> [<sfs:SCALEFONT>]]                  ;
                [GETRESIZE <aGetReSize> [<sfg:SCALEFONT>]]                  ;
                [<lAlignRight:ALIGNRIGHT>] [_ALIGNRIGHT <_alignright>]      ;
                [SAYDRAG <bSDrag> [TYPE <nSDragType>] [DIALOG <bSDD>]]         ;
                [SAYDROP <bSDrop> [TYPE <nSDropType>] [CURSOR <nSDropCursor>]] ;
                [GETDRAG <bGDrag> [TYPE <nGDragType>] [DIALOG <bGDD>]]         ;
                [GETDROP <bGDrop> [TYPE <nGDropType>] [CURSOR <nGDropCursor>]] ;
                [SAYCONFIG <oSayConfig>]                                    ;
                [GETCONFIG <oGetConfig>]                                    ;
                [SAYSUBCLASS <cSaySubClass>]                                ;
                [GETSUBCLASS <cGetSubClass>]                                ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST, DC_GetTemplate(GETLIST_SAY, XBPSTATIC_TYPE_TEXT) )  ;
     ;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cText>)                 ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                             ;
              DC_GetAnchorCB(@<uSayVar>,'C'))]                              ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nSayRow>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nSayCol>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nSayWidth>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nSayHeight>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cSayFont>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cSayToolTip>)]          ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]           ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                         ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xSayCargo>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aSayPres>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,{<nSayOpt>})]            ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncSayFgC>,<ncSayBgC>})]  ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                           ;
          DC_GetAnchorCB(@<oSayObject>,'O'))]                               ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                          ;
          DC_GetAnchorCB(@<oParent>,'O'))]                                  ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                  ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                    ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nSayCursor>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bSayEval>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]           ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                         ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                        ;
          DC_GetAnchorCb(@<oRel>,'O'))]                                     ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cSayHelpCode>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<.lGraString.>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<_grastring>)]          ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,<.lAlignRight.>)]       ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,<_alignright>)]         ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS9,<bHyperLink>)]          ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cSayTitle>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cSayId>)]                    ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bSayPreEval>)]          ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bSayPostEval>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcSayClass>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oSayConfig>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aSayReSize>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sfs.>,3)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSaySubClass>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                        ;
      {<bSDrag>,<nSDragType>,<bSDD>,<bSDrop>,<nSDropType>,<nSDropCursor>})] ;
   ;AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_GET) )                       ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                             ;
      DC_GetAnchorCB(@<uVar>,,<uVar>,<cPict>,<bLink>,,,<(uVar)>))]          ;
     ;DC_GetListSet(DCGUI_GETLIST,nGETLIST_POINTER,Len(DCGUI_GETLIST)-1)    ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nGetRow>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nGetCol>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nGetWidth>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nGetHeight>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cGetFont>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_PICTURE,<cPict>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                   ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VALID,<bValid>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cGetToolTip>)]          ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xGetCargo>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aGetPres>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncGetFgC>,<ncGetBgC>})]  ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]           ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                         ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,{<(uVar)>,<(bLink)>})]   ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<cVarName>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_READVAR,                         ;
         DC_GetAnchorCB(@<xRef>,,<xRef>)]                                   ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                           ;
         DC_GetAnchorCB(@<oGetObject>,'O'))]                                ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                          ;
         DC_GetAnchorCB(@<oParent>,'O'))]                                   ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                  ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_REFVAR,                          ;
         DC_GetAnchorCB(@<uVar>,,<uVar>))]                                  ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT, <bProtect>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                    ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nGetCursor>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bGetEval>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                        ;
         DC_GetAnchorCb(@<oRel>,'O'))]                                      ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                        ;
     {<bPopUp>,,<.lPopTab.>,<.d.>,<.pv.>,<c>,<f>,<w>,<h>,<s>,<k>,<.g.>,     ;
      <t>,<.lCalc.>,<pw>,<ph>})]                                            ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,<.u.>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,<_unreadable>)]         ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,<.noconfirm.>)]         ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,!<.confirm.>)]          ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,{<.pass.>,<cPassChar>})];
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,{<_password>,<cPassChar>})] ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS6,{<.proper.>,<aProperOptions>})] ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS6,{<_proper>,<aProperOptions>})] ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS7,<.ljust.>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS7,<_leftjustify>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS8,{<nStart>,<nEnd>})]     ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS9,<keyblock>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cGetTitle>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,DC_GetIdDefault(<cGetId>,<(uVar)>,'GET_'))] ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                   ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]         ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bGetPreEval>)]          ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bGetPostEval>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcGetClass>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oGetConfig>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aGetReSize>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sfg.>,3)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cGetSubClass>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                        ;
       {<bGDrag>,<nGDragType>,<bGDD>,<bGDrop>,<nGDropType>,<nGDropCursor>})] ;
    [;DC_GetAddOption(DCGUI_GETLIST,<option>)]                              ;
    [;DC_GetAddOption(DCGUI_GETLIST,                                        ;
       { 120, <nComboHeight>, <acbComboData>, <nbField>, <bReturn>,         ;
              <nComboWidth>, <cComboCaption>, <cComboFont>,                 ;
              <nComboHotKey>, <cListFont>, <aListPres>, <.keydrop.> }) ]    ;
    [;DC_GetAddOption(DCGUI_GETLIST,{ 103, <preblock> })]                   ;
    [;DC_GetAddOption(DCGUI_GETLIST,{ 104, <postblock> })]                  ;
    [;DC_GetAddOption(DCGUI_GETLIST,{ 105, <cMsg> })]                       ;
    [;DC_GetAddOption(DCGUI_GETLIST,{ 115, <cHelpCode> })]

* ------------------------------- *

#command  @ <nRow> [,<nCol>] DCGET [<uVar>]                                 ;
                [DATALINK <bLink> ]                                         ;
                [<color:COLOR,GETCOLOR> <ncFgC> [,<ncBgC>] ]                ;
                [<size:SIZE,GETSIZE> <nWidth> [,<nHeight>] ]                ;
                [<font:FONT,GETFONT> <cFont>]                               ;
                [COMBO [HEIGHT <nComboHeight>] [WIDTH <nComboWidth>]        ;
                    [DATA <acbComboData>]                                   ;
                    [<nf:FIELD,ELEMENT> <nbField>] [RETURN <bReturn>]       ;
                    [CAPTION <cComboCaption>] [FONT <cComboFont>]           ;
                    [HOTKEY <nComboHotKey>] [LISTFONT <cListFont>]          ;
                    [<keydrop:KEYDROP>]                                     ;
                    [LISTPRESENTATION <aListPres>] ]                        ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [<n:NAME,VARNAME> <cVarName>]                               ;
                [OPTION <option>]                                           ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [VALID <bValid>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [PREBLOCK <preblock>]                                       ;
                [POSTBLOCK <postblock>]                                     ;
                [<kb:KEYBLOCK,KEYBOARD> <keyblock>]                         ;
                [PICTURE <cPict>]                                           ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [<pp:EDITPROTECT,PROTECT> <bProtect>]                       ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [<u: UNREADABLE>] [_UNREADABLE <_unreadable>]               ;
                [<noconfirm: NOCONFIRM>]                                    ;
                [<confirm: CONFIRM>]                                        ;
                [<pres:PRESENTATION,GETPRESENTATION> <aPres>]               ;
                [<tool:TOOLTIP,GETTOOLTIP> <cToolTip>]                      ;
                [<obj:OBJECT,GETOBJECT> <oObject>]                          ;
                [<cur:CURSOR,GETCURSOR> <nCursor>]                          ;
                [CARGO <xCargo>]                                            ;
                [<eval:EVAL,GETEVAL> <bEval>]                               ;
                [<preeval:PREEVAL,GETPREEVAL> <bPreEval>]                   ;
                [<posteval:POSTEVAL,GETPOSTEVAL> <bPostEval>]               ;
                [POPUP <bPopUp> [<lPopTab:POPTABSTOP>]                      ;
                   [<d:DROPDOWN>] [REFERENCE <xRef>]                        ;
                   [POPCAPTION <c>] [POPFONT <f>]                           ;
                   [POPWIDTH <w>] [POPHEIGHT <h>]                           ;
                   [POPWHEN <pw>] [POPHIDE <ph>]                            ;
                   [POPSTYLE <s>] [POPKEY <k>] [<g:POPGLOBAL>] ]            ;
                   [POPTOOLTIP <t>]                                         ;
                [<pv:POPVALID>]                                             ;
                [RELATIVE <oRel>]                                           ;
                [TITLE <cTitle>]                                            ;
                [<id:ID,GETID> <cId>]                                       ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<pass:PASSWORD>] [_PASSWORD <_password>]                   ;
                [PASSCHAR <cPassChar>]                                      ;
                [<proper:PROPER> [PROPOPTIONS <aProperOptions>]]            ;
                [_PROPER <_proper>]                                         ;
                [<ljust:LEFTJUSTIFY>] [_LEFTJUSTIFY <_leftjustify>]         ;
                [RANGE <nStart>, <nEnd>]                                    ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [<lCellEditor:CELLEDITOR>] [_CELLEDITOR <_celleditor>]      ;
                [CLASS <bcClass>]                                           ;
                [<lCalc:CALCULATOR>] [_CALCULATOR <_calc>]                  ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [CUEBANNER <cuebanner>]                                     ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
            DC_GetTemplate(GETLIST_GET, IIF(<.lCellEditor.>,1,0)) )         ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                             ;
      DC_GetAnchorCB(@<uVar>,,<uVar>,<cPict>,<bLink>,,,<(uVar)>))]          ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                   ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_PICTURE,<cPict>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                   ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VALID,<bValid>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]        ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]           ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                         ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,                         ;
                {<(uVar)>,<(bLink)>})]                                      ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<cVarName>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_READVAR,                         ;
         DC_GetAnchorCB(@<xRef>,,<xRef>))]                                  ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                           ;
         DC_GetAnchorCB(@<oObject>,'O'))]                                   ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                          ;
         DC_GetAnchorCB(@<oParent>,'O'))]                                   ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                  ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_REFVAR,                          ;
         DC_GetAnchorCB(@<uVar>,,<uVar>))]                                  ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT, <bProtect>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                    ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                   ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                        ;
         DC_GetAnchorCb(@<oRel>,'O'))]                                      ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                        ;
     {<bPopUp>,,<.lPopTab.>,<.d.>,<.pv.>,<c>,<f>,<w>,<h>,<s>,<k>,<.g.>,     ;
      <t>,<.lCalc.>,<pw>,<ph>})]                                            ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,<.u.>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,<_unreadable>)]         ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,<.noconfirm.>)]         ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,!<.confirm.>)]          ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,{<.pass.>,<cPassChar>})];
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,{<_password>,<cPassChar>})] ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS6,{<.proper.>,<aProperOptions>})] ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS6,{<_proper>,<aProperOptions>})] ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS7,<.ljust.>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS7,<_leftjustify>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS8,{<nStart>,<nEnd>})]     ;
    [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS9,<keyblock>)]            ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,DC_GetIdDefault(<cId>,<(uVar)>,'GET_'))] ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                   ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]         ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]                 ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]        ;
    [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]              ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]             ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]               ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]                ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]           ;
    [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                        ;
      {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]       ;
    [;DC_GetAddOption(DCGUI_GETLIST,<option>)]                              ;
    [;DC_GetAddOption(DCGUI_GETLIST,                                        ;
       { 120, <nComboHeight>, <acbComboData>, <nbField>, <bReturn>,         ;
              <nComboWidth>, <cComboCaption>, <cComboFont>,                 ;
              <nComboHotKey>, <cListFont>, <aListPres>, <.keydrop.> }) ]    ;
    [;DC_GetAddOption(DCGUI_GETLIST,{ 103, <preblock> })]                   ;
    [;DC_GetAddOption(DCGUI_GETLIST,{ 104, <postblock> })]                  ;
    [;DC_GetAddOption(DCGUI_GETLIST,{ 105, <cMsg> })]                       ;
    [;DC_GetAddOption(DCGUI_GETLIST,{ 106, <cuebanner> })]                  ;
    [;DC_GetAddOption(DCGUI_GETLIST,{ 115, <cHelpCode> })]

* ------------------------ *

#command  @ <nGetRow> [,<nGetCol>] DCCHECKBOX [<uVar>]                      ;
                [OPTIONS <nOptions>]                                        ;
                [DELIMVAR <cDelim>]                                         ;
                [TRANSFORM <aTransform>]                                    ;
                [VALID <bValid>]                                            ;
                [<n:NAME,VARNAME> <cVarName>]                               ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [DATALINK <bLink>]                                          ;
                [ACTION <bAction>]                                          ;
                [FONT <cFont>]                                              ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [CARGO <xCargo>]                                            ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [SIZE <nWidth>[,<nHeight>]]                                 ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [OBJECT <oObject>]                                          ;
                [CURSOR <nCursor>]                                          ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [<prompt: PROMPT,CAPTION> <cPrompt>]                        ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
            DC_GetTemplate(GETLIST_CHECKBOX) )                              ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cPrompt>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
        DC_GetAnchorCB(@<uVar>,,<uVar>,,<bLink>,,<aTransform>,<(uVar)>))]   ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nGetRow>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nGetCol>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VALID,<bValid>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bAction>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,{<(uVar)>,nil})]       ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<cVarName>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_READVAR,                       ;
        {||DC_ReadVar(@<uVar>,,,.t.)})]                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_DELIMVAR,                      ;
           DC_GetAnchorCB(@<cDelim>))]                                      ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
           DC_GetAnchorCB(@<oObject>,'O'))]                                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
           DC_GetAnchorCB(@<oParent>,'O'))]                                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
           DC_GetAnchorCb(@<oRel>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<nOptions>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;

* ------------------------ *

#command  @ <nSayRow> [,<nSayCol>] DCSAY [<cText>]                          ;
                CHECKBOX <uVar>                                             ;
                [TRANSFORM <aTransform>]                                    ;
                [GETPOS <nGetRow> [,<nGetCol>] ]                            ;
                [VALID <bValid>]                                            ;
                [DATALINK <bLink>]                                          ;
                [<color:COLOR,SAYCOLOR> <ncSayFgC> [,<ncSayBgC>] ]          ;
                [GETCOLOR <ncGetFgC> [,<ncGetBgC>] ]                        ;
                [OPTION <option>]                                           ;
                [<lGraString:GRASTRING>] [_GRASTRING <_grastring>]          ;
                [SAYSIZE <nSayWidth> [,<nSayHeight>]]                       ;
                [GETSIZE <nGetWidth> [,<nGetHeight>]]                       ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [SAYOPTION <nSayOpt>]                                       ;
                [HELPCODE <cHelpCode>]                                      ;
                [PREBLOCK <preblock>]                                       ;
                [POSTBLOCK <postblock>]                                     ;
                [<kb:KEYBLOCK,KEYBOARD> <keyblock>]                         ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [SAYPRESENTATION <aSayPres>]                                ;
                [GETPRESENTATION <aGetPres>]                                ;
                [TOOLTIP <cToolTip>]                                        ;
                [SAYTOOLTIP <cSayToolTip>]                                  ;
                [GETTOOLTIP <cGetToolTip>]                                  ;
                [SAYOBJECT <oSayObject>]                                    ;
                [GETOBJECT <oGetObject>]                                    ;
                [SAYCURSOR <nSayCursor>]                                    ;
                [GETCURSOR <nGetCursor>]                                    ;
                [SAYCARGO <xSayCargo>]                                      ;
                [GETCARGO <xGetCargo>]                                      ;
                [SAYEVAL <bSayEval>]                                        ;
                [SAYPREEVAL <bSayPreEval>]                                  ;
                [SAYPOSTEVAL <bSayPostEval>]                                ;
                [GETEVAL <bGetEval>]                                        ;
                [GETPREEVAL <bGetPreEval>]                                  ;
                [GETPOSTEVAL <bGetPostEval>]                                ;
                [SAYTITLE <cSayTitle>]                                      ;
                [GETTITLE <cGetTitle>]                                      ;
                [SAYFONT <cSayFont>]                                        ;
                [GETFONT <cGetFont>]                                        ;
                [RELATIVE <oRel>]                                           ;
                [SAYID <cSayId>]                                            ;
                [GETID <cGetId>]                                            ;
                [ACCELKEY <nAccel>]                                         ;
                [REFERENCE <xRef>]                                          ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<ljust:LEFTJUSTIFY>] [_LEFTJUSTIFY <_leftjustify>]         ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [_INVISIBLE <_invis>]              ;
                [GROUP <cGroup>]                                            ;
                [SAYCLASS <bcSayClass>]                                     ;
                [GETCLASS <bcGetClass>]                                     ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
    { GETLIST_SAY,                              /* nGETLIST_TYPE         */ ;
      XBPSTATIC_TYPE_TEXT,                      /* nGETLIST_SUBTYPE      */ ;
      <cText>,                                  /* cGETLIST_CAPTION      */ ;
      nil,                                      /* bGETLIST_VAR          */ ;
      <nSayRow>,                                /* nGETLIST_STARTROW     */ ;
      <nSayCol>,                                /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      <nSayWidth>,                              /* nGETLIST_WIDTH        */ ;
      <nSayHeight>,                             /* nGETLIST_HEIGHT       */ ;
      <cSayFont>,                               /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      nil,                                      /* bGETLIST_WHEN         */ ;
      nil,                                      /* bGETLIST_VALID        */ ;
      [<cToolTip>][<cSayToolTip>],              /* cGETLIST_TOOLTIP      */ ;
      <xSayCargo>,                              /* xGETLIST_CARGO        */ ;
      <aSayPres>,                               /* aGETLIST_PRESENTATION */ ;
      nil,                                      /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      {<nSayOpt>},                              /* xGETLIST_OPTIONS      */ ;
      [{<ncSayFgC>,<ncSayBgC>}],                /* aGETLIST_COLOR        */ ;
      nil,                                      /* cGETLIST_MESSAGE      */ ;
      nil,                                      /* cGETLIST_HELPCODE     */ ;
      nil,                                      /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [{DC_GetAnchorCB(@<oSayObject>,'O'),                                  ;
                        <(oSayObject)>,'O'}],   /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),                                     ;
                         <(oParent)>,'O'}][<cPID>], /* bGETLIST_PARENT       */ ;
      nil,                                      /* bGETLIST_REFVAR       */ ;
      nil,                                      /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      <nSayCursor>,                             /* nGETLIST_CURSOR       */ ;
      <bSayEval>,                               /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),                                        ;
                        <(oRel)>,'O'}],         /* bGETLIST_RELATIVE     */ ;
      <.lGraString.> [.OR. <_grastring>],       /* xGETLIST_OPTIONS2     */ ;
      nil,                                      /* xGETLIST_OPTIONS3     */ ;
      nil,                                      /* xGETLIST_OPTIONS4     */ ;
      nil,                                      /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cSayTitle>,                              /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cSayId>,                                 /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      nil,                                      /* nGETLIST_ACCELKEY     */ ;
      nil,                                      /* bGETLIST_GOTFOCUS     */ ;
      nil,                                      /* bGETLIST_LOSTFOCUS    */ ;
      .f.,                                      /* lGETLIST_TABSTOP      */ ;
      nil,                                      /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bSayPreEval>,                            /* bGETLIST_PREEVAL      */ ;
      <bSayPostEval>,                           /* bGETLIST_POSTEVAL     */ ;
      <bcSayClass>,                             /* bGETLIST_CLASS        */ ;
      } )  ;
   ; AADD( DCGUI_GETLIST,                                                   ;
    { GETLIST_CHECKBOX,                         /* nGETLIST_TYPE         */ ;
      nil,                                      /* nGETLIST_SUBTYPE      */ ;
      nil,                                      /* cGETLIST_CAPTION      */ ;
      DC_GetAnchorCB(@<uVar>,,<uVar>,,<bLink>,,<aTransform>),               ;
                                                /* bGETLIST_VAR          */ ;
      [<nGetRow>],                              /* nGETLIST_STARTROW     */ ;
      [<nGetCol>],                              /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      <nGetWidth>,                              /* nGETLIST_WIDTH        */ ;
      <nGetHeight>,                             /* nGETLIST_HEIGHT       */ ;
      <cGetFont>,                               /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      <bWhen>,                                  /* bGETLIST_WHEN         */ ;
      <bValid>,                                 /* bGETLIST_VALID        */ ;
      [<cToolTip>][<cGetToolTip>],              /* cGETLIST_TOOLTIP      */ ;
      <xGetCargo>,                              /* xGETLIST_CARGO        */ ;
      <aGetPres>,                               /* aGETLIST_PRESENTATION */ ;
      nil,                                      /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      nil,                                      /* xGETLIST_OPTIONS      */ ;
      [{<ncGetFgC>,<ncGetBgC>}],                /* aGETLIST_COLOR        */ ;
      {<cMsg>,[{DC_GetAnchorCB(@<oMsg>,'O'),<(oMsg)>,'O'}]},                ;
                                                /* cGETLIST_MESSAGE      */ ;
      <cHelpCode>,                              /* cGETLIST_HELPCODE     */ ;
      [{<(uVar)>,<(bLink)>}],                   /* cGETLIST_VARNAME      */ ;
      [{DC_GetAnchorCB(@<xRef>,,<xRef>),                                    ;
                               <(xRef)>}],      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [{DC_GetAnchorCB(@<oGetObject>,'O'),                                  ;
                        <(oGetObject)>,'O'}],   /* bGETLIST_GROUP        */ ;
      LEN(DCGUI_GETLIST),                       /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),                                     ;
                        <(oParent)>,'O'}][<cPID>], /* bGETLIST_PARENT       */ ;
      [{DC_GetAnchorCB(@<uVar>,,<uVar>),                                    ;
                               <(uVar)>}],      /* bGETLIST_REFVAR       */ ;
      <bProtect>,                               /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      <nGetCursor>,                             /* nGETLIST_CURSOR       */ ;
      <bGetEval>,                               /* bGETLIST_EVAL         */ ;
      nil,                                      /* bGETLIST_RELATIVE     */ ;
      nil,                                      /* xGETLIST_OPTIONS2     */ ;
      nil,                                      /* xGETLIST_OPTIONS3     */ ;
      nil,                                      /* xGETLIST_OPTIONS4     */ ;
      nil,                                      /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      [<keyblock>],                             /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cGetTitle>,                              /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cGetId>,                                 /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      <nAccel>,                                 /* nGETLIST_ACCELKEY     */ ;
      <bGotFocus>,                              /* bGETLIST_GOTFOCUS     */ ;
      <bLostFocus>,                             /* bGETLIST_LOSTFOCUS    */ ;
      DC_LogicTest([<.lTabStop.>],[<_tab>],[<.lNoTabStop.>],[<_notab>]),    ;
                                                /* lGETLIST_TABSTOP      */ ;
      <nTabGroup>,                              /* nGETLIST_TABGROUP     */ ;
                                                /* lGETLIST_VISIBLE      */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bGetPreEval>,                            /* bGETLIST_PREEVAL      */ ;
      <bGetPostEval>,                           /* bGETLIST_POSTEVAL     */ ;
      <bcGetClass>,                             /* bGETLIST_CLASS        */ ;
   } )

* ------------------------------- *

#command  @ <nRow> [,<nCol>] DCRADIOBUTTON [<uVar>]                         ;
                [VALUE <xVal>]                                              ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [<n:NAME,VARNAME> <cVarName>]                               ;
                [<prompt: PROMPT,CAPTION> <cPrompt>]                        ;
                [DELIMVAR <cDelim>]                                         ;
                [DATALINK <bLink>]                                          ;
                [FONT <cFont>]                                              ;
                [ACTION <bAction>]                                          ;
                [OBJECT <oObject>]                                          ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [CARGO <xCargo>]                                            ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [<b:PROTECT,EDITPROTECT> <bProtect>]                        ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [CURSOR <nCursor>]                                          ;
                [TITLE <cTitle>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [OPTIONS <nOptions>]                                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
            DC_GetTemplate(GETLIST_RADIOBUTTON) )                           ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cPrompt>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
         DC_GetAnchorCB(@<uVar>,,<uVar>,,<bLink>,<xVal>,,<(uVar)>))]        ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bAction>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,{<xVal>})]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<(uVar)>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<cVarName>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_READVAR,                       ;
        {||DC_ReadVar(@<uVar>,,<xVal>,.f.)}) ]                              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_DELIMVAR,                      ;
        DC_GetAnchorCB(@<cDelim>))]                                         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oObject>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
        DC_GetAnchorCb(@<oRel>,'O'))]                                       ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,cTitle>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<nOptions>)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;

* ------------------------------- *

#xcommand DCMULTILINE [<options,...>] => @ DCMULTILINE [<options>]

#command  @ [<nRow>,<nCol>] DCMULTILINE [<uVar>]                            ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [<n:NAME,VARNAME> <cVarName>]                               ;
                [VALID <bValid>]                                            ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [FONT <cFont>]                                              ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [HELPCODE <cHelpCode>]                                      ;
                [DATALINK <bLink>]                                          ;
                [OBJECT <oObject>]                                          ;
                [CARGO <xCargo>]                                            ;
                [<lNoWW:NOWORDWRAP>] [_NOWORDWRAP <_noww>]                  ;
                [<lNoB:NOBORDER>] [_NOBORDER <_nob>]                        ;
                [<lNoV:NOVERTSCROLL,NOVSCROLL>] [_NOVSCROLL <_nov>]         ;
                [<lNoH:NOHORIZSCROLL,NOHSCROLL>] [_NOHSCROLL <_noh>]        ;
                [<lIgT:IGNORETAB>] [_IGNORETAB <_ignoretab>]                ;
                [<lRO:READONLY>] [_READONLY <_ro>]                          ;
                [MAXLINES <nMaxLines> [MESSAGE <cMessage1>]]                ;
                [LINELENGTH <nLineLength> [MESSAGE <cMessage2>]]            ;
                [MAXCHARS <nMaxChars> [MESSAGE <cMessage3>]]                ;
                [EXITKEY <nExitKey>]                                        ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [<lCompat:COMPATIBILE,COMPATABILE,COMPATABLE,COMPATIBLE >]  ;
                   [_COMPAT <_compat>]                                      ;
                [<lGoBott:GOBOTTOM>] [_GOBOTTOM <_gobott>]                  ;
                [CURSOR <nCursor>]                                          ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize> [<sf:SCALEFONT>]]                         ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_MLE) )                        ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
         DC_GetAnchorCB(@<uVar>,,,,<bLink>,,,<(uVar)>))]                    ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VALID,<bValid>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
         {<.lNoWW.>,<.lNoB.>,<.lNoV.>,<.lNoH.>,<.lIgT.>,<.lCompat.>,        ;
          <.lRO.>,<nExitKey>,<.lGoBott.>})                                  ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_noww>,1)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_nob>,2)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_nov>,3)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_noh>,4)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_ignoretab>,5)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_compat>,6)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_ro>,7)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_gobott>,9)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
        DC_GetAnchorCB(@<oMsg>,'O'),2)]                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<(uVar)>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<cVarName>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oObject>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
        DC_GetAnchorCb(@<oRel>,'O'))]                                       ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
        {<nMaxLines>,<cMessage1>})]                                         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,                      ;
        {<nLineLength>,<cMessage2>})]                                       ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,                      ;
        {<nMaxChars>,<cMessage3>})]                                         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,cTitle>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;

* -----------------------

#command  @ [<nRow>,<nCol>] DCSLE [<uVar>]                                  ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [<n:NAME,VARNAME> <cVarName>]                               ;
                [BUFFERLENGTH <nBufferLen>]                                 ;
                [VALID <bValid>]                                            ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [FONT <cFont>]                                              ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [HELPCODE <cHelpCode>]                                      ;
                [DATALINK <bLink>]                                          ;
                [OBJECT <oObject>]                                          ;
                [CARGO <xCargo>]                                            ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_SLE) )                        ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
         DC_GetAnchorCB(@<uVar>,,,,<bLink>,,,<(uVar)>))]                    ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VALID,<bValid>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
        DC_GetAnchorCB(@<oMsg>,'O'),2)]                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<(uVar)>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<cVarName>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oObject>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
        DC_GetAnchorCb(@<oRel>,'O'))]                                       ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,cTitle>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<nBufferLen>)]        ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;

* ------------------------------- *

#command  @ <nRow> [,<nCol>] DCLISTBOX [<uVar>]                             ;
                [LIST <aList>]                                              ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [<n:NAME,VARNAME> <cVarName>]                               ;
                [SIZE <nWidth>,<nHeight>]                                   ;
                [FONT <cFont>]                                              ;
                [PRESENTATION <aPres>]                                      ;
                [MARKMODE <nMarkMode>]                                      ;
                [SELECT <aSelect>]                                          ;
                [<lH:HORIZSCROLL>] [_HORIZSCROLL <_horizscroll>]            ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [DATALINK <bLink>]                                          ;
                [ITEMMARKED <bItemMarked>]                                  ;
                [ITEMSELECTED <bItemSelected>]                              ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [OBJECT <oObject>]                                          ;
                [CARGO <xCargo>]                                            ;
                [HIDE <bHide>]                                              ;
                [WHEN <bWhen>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [VALID <bValid>]                                            ;
                [CURSOR <nCursor>]                                          ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [<lMultiColumn:MULTICOLUMN>] [_MULTICOLUMN <_multicolumn>]  ;
                [HELPCODE <cHelpCode>]                                      ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_LISTBOX) )                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
         DC_GetAnchorCB(@<uVar>,,,,<bLink>,,,<(uVar)>))]                    ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VALID,<bValid>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
        {<.lH.>,<nMarkMode>,<aSelect>,<.lMultiColumn.>,                     ;
         <bItemMarked>,<bItemSelected>})                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,_horizscroll,1)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,_multicolumn,4)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
        DC_GetAnchorCB(@<oMsg>,'O'),2)]                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<(uVar)>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<cVarName>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oObject>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_REFVAR,                        ;
        DC_GetAnchorCB(@<aList>,'A'))]                                      ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
        DC_GetAnchorCb(@<oRel>,'O'))]                                       ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;


* ------------------------------- *

#command @ <nRow> [, <nCol>] DCPUSHBUTTONXP                                 ;
                [<text:CAPTION,PROMPT> <cText> [OFFSET <nCapOffset>]]       ;
                [CAPTIONARRAY <aCaption>]                                   ;
                [BITMAP <xBitMap>                                           ;
                  [ALIGN <nBMAlign>] [OFFSET <nBMOffset>] [SCALE <nBmpScale>]] ;
                [TILEBITMAP <xTile>]                                        ;
                [RESTYPE <cResType>]                                        ;
                [RESFILE <cResFile>]                                        ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [<action:ACTION,ACTIVATE> <bAction>]                        ;
                [<menuaction:MENUACTION> <bMenuAction>]                     ;
                [WHEN <bWhen>]                                              ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [COLOR <ncFgC> [,<ncBgC>]]                                  ;
                [MOUSECOLOR <ncFgCMouse> [,<ncBgCMouse>]]                   ;
                [MOUSESOUND <abMouseSound>]                                 ;
                [MOUSESCALE <nMouseScale>]                                  ;
                [MOUSEFONT <cMouseFont>]                                    ;
                [DISABLEDCOLOR <nDisabledFGColor> [,<nDisabledBGColor>]]    ;
                [<grayBmp:GRAYBITMAP>]                                      ;
                [CLICKCOLOR <ncFgCClick> [,<ncBgCClick>]]                   ;
                [GRADIENT <nGradStep> [<gRev:REVERSE>] [STYLE <nGradStyle>] ;
                         [LEVEL <nGradLevel>]]                              ;
                [FOCUSRECT <nFocusRectStyle> [COLOR <nFocusRectColor>]]     ;
                [<outline:OUTLINE>]                                         ;
                [BORDERCOLOR <nBorderColor>]                                ;
                [RADIUS <nRadius>]                                          ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [HELPCODE <cHelpCode>]                                      ;
                [FONT <cFont>]                                              ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [OBJECT <oObject>]                                          ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [CARGO <xCargo>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [TITLE <cTitle> ]                                           ;
                [RELATIVE <oRel> ]                                          ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [SOUND <abSound>]                                           ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [<s:SELECTED>] [_SELECTED <_s>]                             ;
                [<se:SELECTENABLE>]                                         ;
                [SELECTCOLOR <ncFgCSelect> [,<ncBgCSelect>]]                ;
                [<static:STATIC>]                                           ;
                [SHADOW <nShadowType>]                                      ;
                [<tr:TRANSPARENT>]                                          ;
                [<ts:TEXTSHADOW> [COLOR <tsColor>] [OFFSET <tsOffset>]]     ;
                [SUBCLASS <subclass>]                                       ;
=>                                                                          ;
   AADD( DCGUI_GETLIST,                                                     ;
            DC_GetTemplate(GETLIST_XPPUSHBUTTON) )                          ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cText>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bAction>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
          DC_GetAnchorCB(@<oMsg>,'O'),2)]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
          DC_GetAnchorCB(@<oObject>,'O'))]                                  ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
          DC_GetAnchorCB(@<oParent>,'O'))]                                  ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
         DC_GetAnchorCb(@<oRel>,'O'))]                                      ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<abSound>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS8,                      ;
         {<(cResType)>,<cResFile>})]                                        ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS9,                      ;
         {<bMenuAction>,<.outline.>,<nCapOffset>,<nRadius>,<xBitMap>,       ;
          <ncFgCMouse>,<ncBgCMouse>, <ncFgCClick>,<ncBgCClick>,             ;
          <nGradStep>,<.gRev.>,<nGradStyle>, <aCaption>,                    ;
          <nBMAlign>,<nBMOffset>,<xTile>,<nBmpScale>,                       ;
          <abMouseSound>,<nMouseScale>,<cMouseFont>,                        ;
          <nDisabledBGColor>,<ncFgCSelect>,<ncBgCSelect>,                   ;
          <.se.>,<.s.> [.OR. <_s>],<nDisabledFGColor>,<.grayBmp.>,          ;
          <nBorderColor>,<.static.>,<nFocusRectStyle>,<nFocusRectColor>,    ;
          <nShadowType>, <nGradLevel>,IIF(<.tr.>,.t.,nil),                  ;
          IIF(<.ts.>,.t.,nil),<tsColor>,<tsOffset>})                        ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPreEval>)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<subclass>)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]

* ------------------------------- *

#command DCADDBUTTONXP                                                      ;
                [<text:CAPTION,PROMPT> <cText> [OFFSET <nCapOffset>]]       ;
                [CAPTIONARRAY <aCaption>]                                   ;
                [BITMAP <xBitMap>                                           ;
                  [ALIGN <nBMAlign>] [OFFSET <nBMOffset>] [SCALE <nBmpScale>]] ;
                [TILEBITMAP <xTile>]                                        ;
                [RESTYPE <cResType>]                                        ;
                [RESFILE <cResFile>]                                        ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [<action:ACTION,ACTIVATE> <bAction>]                        ;
                [<menuaction:MENUACTION> <bMenuAction>]                     ;
                [WHEN <bWhen>]                                              ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [COLOR <ncFgC> [,<ncBgC>]]                                  ;
                [MOUSECOLOR <ncFgCMouse> [,<ncBgCMouse>]]                   ;
                [CLICKCOLOR <ncFgCClick> [,<ncBgCClick>]]                   ;
                [MOUSESOUND <abMouseSound>]                                 ;
                [MOUSESCALE <nMouseScale>]                                  ;
                [MOUSEFONT <cMouseFont>]                                    ;
                [DISABLEDCOLOR <nDisabledFGColor> [,<nDisabledBGColor>]]    ;
                [<grayBmp:GRAYBITMAP>]                                      ;
                [GRADIENT <nGradStep> [<gRev:REVERSE>] [STYLE <nGradStyle>] ;
                         [LEVEL <nGradLevel>]]                              ;
                [FOCUSRECT <nFocusRectStyle> [COLOR <nFocusRectColor>]]     ;
                [<outline:OUTLINE>]                                         ;
                [BORDERCOLOR <nBorderColor>]                                ;
                [RADIUS <nRadius>]                                          ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [HELPCODE <cHelpCode>]                                      ;
                [FONT <cFont>]                                              ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [OBJECT <oObject>]                                          ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [CARGO <xCargo>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [TITLE <cTitle> ]                                           ;
                [RELATIVE <oRel> ]                                          ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [SOUND <abSound>]                                           ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [<se:SELECTENABLE>]                                         ;
                [<s:SELECTED>] [_SELECTED <_s>]                             ;
                [<static:STATIC>]                                           ;
                [SELECTCOLOR <ncFgCSelect> [,<ncBgCSelect>]]                ;
                [SHADOW <nShadowType>]                                      ;
                [<tr:TRANSPARENT>]                                          ;
                [<ts:TEXTSHADOW> [COLOR <tsColor>] [OFFSET <tsOffset>]]     ;
                [SUBCLASS <subclass>]                                       ;
=>                                                                          ;
   AADD( DCGUI_GETLIST,                                                     ;
            DC_GetTemplate(GETLIST_XPADDBUTTON) )                           ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cText>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bAction>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
          DC_GetAnchorCB(@<oMsg>,'O'),2)]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
          DC_GetAnchorCB(@<oObject>,'O'))]                                  ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
          DC_GetAnchorCB(@<oParent>,'O'))]                                  ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
         DC_GetAnchorCb(@<oRel>,'O'))]                                      ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<abSound>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS8,                      ;
         {<(cResType)>,<cResFile>})]                                        ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS9,                      ;
         {<bMenuAction>,<.outline.>,<nCapOffset>,<nRadius>,<xBitMap>,       ;
          <ncFgCMouse>,<ncBgCMouse>, <ncFgCClick>,<ncBgCClick>,             ;
          <nGradStep>,<.gRev.>,<nGradStyle>, <aCaption>,                    ;
          <nBMAlign>,<nBMOffset>,<xTile>,<nBmpScale>,                       ;
          <abMouseSound>,<nMouseScale>,<cMouseFont>,                        ;
          <nDisabledBGColor>,<ncFgCSelect>,<ncBgCSelect>,                   ;
          <.se.>,<.s.> [.OR. <_s>],<nDisabledFGColor>,<.grayBmp.>,          ;
          <nBorderColor>,<.static.>,<nFocusRectStyle>,<nFocusRectColor>,    ;
          <nShadowType>, <nGradLevel>, IIF(<.tr.>,.t.,nil),                 ;
          IIF(<.ts.>,.t.,nil),<tsColor>,<tsOffset>})                        ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPreEval>)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<subclass>)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]

* ------------------------------- *

#command @ <nRow> [, <nCol>] DCPUSHBUTTON                                   ;
                [<text:CAPTION,PROMPT> <cText>]                             ;
                [RESTYPE <cResType>]                                        ;
                [RESFILE <cResFile>]                                        ;
                [<fancy:FANCY>] [_FANCY <_fancy>]                           ;
                [<static:STATIC>] [_STATIC <_static>]                       ;
                  [FOCUSCOLOR <nTextColor>[,<nFrameColor>]]                 ;
                  [BITMAP <nBMUp> [,<nBMDn> [,<nBMNu> [,<nBMFl>]]]]         ;
                  [FLASH <nFiter> [,<nFDelay>]]                             ;
                  [REGION <aRegion>]                                        ;
                [<graphics:GRAPHICS>] [_GRAPHICS <_graphics>]               ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [TEXTOFFSET <nHoriz>, <nVert>]                              ;
                [TEXTHEIGHT <nTextHeight>]                                  ;
                [<action:ACTION,ACTIVATE> <bAction>]                        ;
                [WHEN <bWhen>]                                              ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [COLOR <ncFgC> [,<ncBgC>]]                                  ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [HELPCODE <cHelpCode>]                                      ;
                [FONT <cFont>]                                              ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [OBJECT <oObject>]                                          ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [CARGO <xCargo>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [TITLE <cTitle> ]                                           ;
                [RELATIVE <oRel> ]                                          ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [SOUND <abSound>]                                           ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [ALIGNCAPTION <nAlignCaption>]                              ;
                [<scalebitmap:SCALEBITMAP>] [_SCALEBITMAP <_scalebitmap>]   ;
                [<excludeXP:EXCLUDEXP>] [_EXCLUDEXP <_excludeXP>]           ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [BORDER <nBorder>]                                          ;
                [CONFIG <oConfig>]                                          ;
=>                                                                          ;
   AADD( DCGUI_GETLIST,                                                     ;
            DC_GetTemplate(GETLIST_PUSHBUTTON) )                            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cText>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bAction>)]             ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
        {<nHoriz>,<nVert>,<nTextHeight>,<.fancy.>,<.graphics.>,             ;
         <.static.>,<.scalebitmap.>,<.excludeXP.>})                         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_fancy>,4)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_graphics>,5)]        ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_static>,6)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_scalebitmap>,7)]     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_excludeXP>,8)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
          DC_GetAnchorCB(@<oMsg>,'O'),2)]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
          DC_GetAnchorCB(@<oObject>,'O'))]                                  ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
          DC_GetAnchorCB(@<oParent>,'O'))]                                  ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
         DC_GetAnchorCb(@<oRel>,'O'))]                                      ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<abSound>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,                      ;
         {<nBMUp>,<nBMDn>,<nBMNu>,<nBMFl>})]                                ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,                      ;
         {<nTextColor>,<nFrameColor>,<nBorder>})]                           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,<aRegion>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS6,                      ;
         {<nFiter>,<nFDelay>})]                                             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS7,<nAlignCaption>)]     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS8,                      ;
         {<(cResType)>,<cResFile>})]                                        ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPreEval>)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]

* ------------------------------- *

#command  @ <nSRow>,<nSCol>,<nERow>,<nECol> DCBOX [<cBox>]                  ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [CAPTION <cText>]                                           ;
                [GROUP <oGroup>]                                            ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [SUBCLASS <cSubClass>]                                      ;
 =>                                                                         ;
   AADD( DCGUI_GETLIST,                                                     ;
     { GETLIST_STATIC,                          /* nGETLIST_TYPE         */ ;
      XBPSTATIC_TYPE_GROUPBOX,                  /* nGETLIST_SUBTYPE      */ ;
      <cText>,                                  /* cGETLIST_CAPTION      */ ;
      nil,                                      /* bGETLIST_VAR          */ ;
      <nSRow>,                                  /* nGETLIST_STARTROW     */ ;
      <nSCol>,                                  /* nGETLIST_STARTCOL     */ ;
      <nERow>,                                  /* nGETLIST_ENDROW       */ ;
      <nECol>,                                  /* nGETLIST_ENDCOL       */ ;
      nil,                                      /* nGETLIST_WIDTH        */ ;
      nil,                                      /* nGETLIST_HEIGHT       */ ;
      nil,                                      /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      nil,                                      /* bGETLIST_WHEN         */ ;
      nil,                                      /* bGETLIST_VALID        */ ;
      <cToolTip>,                               /* cGETLIST_TOOLTIP      */ ;
      <cBox>,                                   /* xGETLIST_CARGO        */ ;
      <aPres>,                                  /* aGETLIST_PRESENTATION */ ;
      nil,                                      /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      DC_ReadOptions(GETLIST_STATIC,{}),        /* xGETLIST_OPTIONS      */ ;
      [{<ncFgC>,<ncBgC>}],                      /* aGETLIST_COLOR        */ ;
      nil,                                      /* cGETLIST_MESSAGE      */ ;
      nil,                                      /* cGETLIST_HELPCODE     */ ;
      nil,                                      /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [{DC_GetAnchorCB(@<oGroup>,'O'),                                      ;
                        <(oGroup)>,'O'}],       /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [DC_GetAnchorCB(@<oParent>,'O'),                                      ;
                       <(oParent)>,'O'}][<cPID>],  /* bGETLIST_PARENT       */ ;
      nil,                                      /* bGETLIST_REFVAR       */ ;
      nil,                                      /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      <nCursor>,                                /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),                                        ;
                        <(oRel)>,'O'}],         /* bGETLIST_RELATIVE     */ ;
      nil,                                      /* xGETLIST_OPTIONS2     */ ;
      nil,                                      /* xGETLIST_OPTIONS3     */ ;
      nil,                                      /* xGETLIST_OPTIONS4     */ ;
      nil,                                      /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      <nAccel>,                                 /* nGETLIST_ACCELKEY     */ ;
      <bGotFocus>,                              /* bGETLIST_GOTFOCUS     */ ;
      <bLostFocus>,                             /* bGETLIST_LOSTFOCUS    */ ;
      DC_LogicTest([<.lTabStop.>],[<_tab>],[<.lNoTabStop.>],[<_notab>]),    ;
                                                /* lGETLIST_TABSTOP      */ ;
      <nTabGroup>,                              /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
      nil, ;
      nil, ;
      nil, ;
      <cSubClass>                               /* cGETLIST_SUBCLASS     */ ;
    } )                                                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor> })]

* ----------------------------- *

#command  @ <nRow> [,<nCol>] DCCOMBOBOX [<uVar>]                            ;
                [LIST <aList>]                                              ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [<r:REFRESH>] [_REFRESH <_refresh>]                         ;
                [<i:IMMEDIATE>] [_IMMEDIATE <_immediate>]                   ;
                [<n:NAME,VARNAME> <cVarName>]                               ;
                [ITEMMARKED <bItemMarked>]                                  ;
                [ITEMSELECTED <bItemSelected>]                              ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [VALID <bValid>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [POINTER <nVar>]                                            ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [DATALINK <bLink>]                                          ;
                [WHEN <bWhen>]                                              ;
                [FONT <cFont>]                                              ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [PRESENTATION <aPres>]                                      ;
                [TYPE <nType>]                                              ;
                [OBJECT <oObject>]                                          ;
                [CARGO <xCargo>]                                            ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [TITLE <cTitle>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [CONFIG <oConfig>]                                          ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
            DC_GetTemplate(GETLIST_COMBOBOX,<nType>) )                      ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
        DC_GetAnchorCB(@<uVar>,,<uVar>,,<bLink>,,,<(uVar)>))]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VALID,<bValid>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,{<.r.>,<.i.>})         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_refresh>,1)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_immediate>,2)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<bItemMarked>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,<bItemSelected>)]     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
         DC_GetAnchorCB(@<oObject>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
         DC_GetAnchorCB(@<oParent>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
         DC_GetAnchorCb(@<oRel>,'O'))]                                      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<(uVar)>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<cVarName>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_REFVAR,                        ;
         DC_GetAnchorCB(@<aList>,'A'))]                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
         DC_GetAnchorCB(@<nVar>,'N'))]                                      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;

* ----------------------------- *

#xcommand DCTOOLBAR [<options,...>] => @ DCTOOLBAR [<options>]

#command @ [<nRow>] [, <nCol>] DCTOOLBAR [OBJECT] <oToolBar> [TYPE <nType>] ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [BUTTONSIZE <nBWidth> [,<nBHeight>]]                        ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [RELATIVE <oRel>]                                           ;
                [<fancy:FANCY>] [_FANCY <_fancy>]                           ;
                [PRESENTATION <aPres>]                                      ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [ALIGN <nAlign>]                                            ;
                [CARGO <xCargo>]                                            ;
                [<v:VERTICAL>] [_VERTICAL <_vertical>]                      ;
                [<h:HORIZONTAL>] [_HORIZONTAL <_horizontal>]                ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TITLE <cTitle>]                                            ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [CURSOR <nCursor>]                                          ;
                [ID <cId>]                                                  ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [<noresize:NORESIZE>] [_NORESIZE <_noresize>]               ;
                [SPACE <nSpace>]                                            ;
                [FONT <cFont>]                                              ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [<fit:FIT>] [_FIT <_fit>]                                   ;
                [CONFIG <oConfig>]                                          ;
                [BUTTONCONFIG <oButtonConfig>]                              ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
            DC_GetTemplate(GETLIST_TOOLBAR,<nType>) )                       ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
         {<nAlign>,<nBWidth>,<nBHeight>,<.fancy.>,<.v.>,<.h.>,<nSpace>,     ;
          <.fit.> [.OR. <_fit>]})                                           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<oButtonConfig>)]     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
       ;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
         DC_GetAnchorCB(@<oToolBar>,'O'))                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
         DC_GetAnchorCb(@<oRel>,'O'))]                                      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,IIF(<.noresize.>,{,},nil))] ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,IIF(<_noresize>,{,},nil))] ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;


* ------------------------------- *

#xcommand DCADDBUTTON  [CAPTION <cText>]                                    ;
                [RESTYPE <cResType>]                                        ;
                [RESFILE <cResFile>]                                        ;
                [<fancy:FANCY>] [_FANCY <_fancy>]                           ;
                [TYPE <nType>]                                              ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [<static:STATIC>] [_STATIC <_static>]                       ;
                  [FOCUSCOLOR <nTextColor>[,<nFrameColor>]]                 ;
                  [BITMAP <nBMUp> [,<nBMDn> [,<nBMNu> [,<nBMFl>]]]]         ;
                  [FLASH <nFiter> [,<nFDelay>]]                             ;
                  [REGION <aRegion>]                                        ;
                [<graphics:GRAPHICS>] [_GRAPHICS <_graphics>]               ;
                [TEXTHEIGHT <nTextHeight>]                                  ;
                [TEXTOFFSET <nHoriz>, <nVert>]                              ;
                [ACTION <bAction>]                                          ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [HELPCODE <cHelpCode>]                                      ;
                [COLOR <ncFgC> [,<ncBgC>]]                                  ;
                [FONT <cFont> ]                                             ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [OBJECT <oObject>]                                          ;
                [DRAWINGAREA <oDrawingArea>]                                ;
                [CURSOR <nCursor>]                                          ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [<pr:EDITPROTECT,PROTECT> <bProtect>]                       ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CARGO <xCargo>]                                            ;
                [SOUND <abSound>]                                           ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [ALIGNCAPTION <nAlignCaption>]                              ;
                [<scalebitmap:SCALEBITMAP>] [_SCALEBITMAP <_scalebitmap>]   ;
                [<excludeXP:EXCLUDEXP>] [_EXCLUDEXP <_excludeXP>]           ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [BORDER <nBorder>]                                          ;
                [CONFIG <oConfig>]                                          ;
 =>                                                                         ;
   AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_ADDBUTTON) )                  ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cText>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_SUBTYPE,<nType>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bAction>)]             ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
        {nil,nil,nil,<.fancy.>,<.graphics.>,<.static.>,<.scalebitmap.>,     ;
        <.excludeXP.>})                                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_fancy>,4)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_graphics>,5)]        ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_static>,6)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_scalebitmap>,7)]     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_excludeXP>,8)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
         DC_GetAnchorCB(@<oObject>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
         DC_GetAnchorCB(@<oParent>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_REFVAR,                        ;
         DC_GetAnchorCB(@<oDrawingArea>,'O'))]                              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<abSound>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,                      ;
         {<nBMUp>,<nBMDn>,<nBMNu>,<nBMFl>})]                                ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,                      ;
         {<nTextColor>,<nFrameColor>,<nBorder>})]                           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,<aRegion>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS6,{<nFiter>,<nFDelay>})];
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS7,<nAlignCaption>)]     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS8,                      ;
         {<(cResType)>,<cResFile>})]                                        ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]


* ----------------------------- *

#xcommand DCMESSAGEBOX <oMsgBox> [<options,...>] =>                         ;
          @ DCMESSAGEBOX OBJECT <oMsgBox> [<options>]

#command @ [<nRow>] [,<nCol>] DCMESSAGEBOX                                  ;
                [OBJECT <oMsgBox>]                                          ;
                [TEXTOBJECT <oMsgBoxText>]                                  ;
                [TYPE <nType>]                                              ;
                [SIZE <nWidth> [,<nHeight>] ]                               ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [RELATIVE <oRel>]                                           ;
                [FONT <cFont>]                                              ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [CARGO <xCargo>]                                            ;
                [PRESENTATION <aPres>]                                      ;
                [ALIGN <nAlign>]                                            ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TITLE <cTitle>]                                            ;
                [HIDE <bHide>]                                              ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [<lMotion:MOTION>] [_MOTION <_motion>]                      ;
                [<lClear:CLEAR>] [_CLEAR <_clear>]                          ;
                [ID <cId>]                                                  ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [<option:OPTIONS,SAYOPTIONS> <nOpt>]                        ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
    { GETLIST_MESSAGEBOX,                       /* nGETLIST_TYPE         */ ;
      <nType>,                                  /* nGETLIST_SUBTYPE      */ ;
      nil,                                      /* cGETLIST_CAPTION      */ ;
      nil,                                      /* bGETLIST_VAR          */ ;
      <nRow>,                                   /* nGETLIST_STARTROW     */ ;
      <nCol>,                                   /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      <nWidth>,                                 /* nGETLIST_WIDTH        */ ;
      <nHeight>,                                /* nGETLIST_HEIGHT       */ ;
      <cFont>,                                  /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      nil,                                      /* bGETLIST_WHEN         */ ;
      nil,                                      /* bGETLIST_VALID        */ ;
      nil,                                      /* cGETLIST_TOOLTIP      */ ;
      <xCargo>,                                 /* xGETLIST_CARGO        */ ;
      <aPres>,                                  /* aGETLIST_PRESENTATION */ ;
      nil,                                      /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      {<nAlign>,<.lMotion.> [.OR. <_motion>],<nOpt>,                        ;
       <.lClear.> [.OR. <_clear>] },                                        ;
                                                /* xGETLIST_OPTIONS      */ ;
      [{<ncFgC>,<ncBgC>}],                      /* aGETLIST_COLOR        */ ;
      nil,                                      /* cGETLIST_MESSAGE      */ ;
      <cHelpCode>,                              /* cGETLIST_HELPCODE     */ ;
      nil,                                      /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [{DC_GetAnchorCB(@<oMsgBox>,'O'),<(oMsgBox)>,'O'}],                   ;
                                                /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),<(oParent)>,'O'}][<cPID>],           ;
                                                /* bGETLIST_PARENT       */ ;
      nil,                                      /* bGETLIST_REFVAR       */ ;
      nil,                                      /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      nil,                                      /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),<(oRel)>,'O'}],                         ;
                                                /* bGETLIST_RELATIVE     */ ;
      [{DC_GetAnchorCb(@<oMsgBoxText>,'O'),<(oMsgBoxText)>,'O'}],           ;
                                                /* xGETLIST_OPTIONS2     */ ;
      nil,                                      /* xGETLIST_OPTIONS3     */ ;
      nil,                                      /* xGETLIST_OPTIONS4     */ ;
      nil,                                      /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      nil,                                      /* nGETLIST_ACCELKEY     */ ;
      nil,                                      /* bGETLIST_GOTFOCUS     */ ;
      nil,                                      /* bGETLIST_LOSTFOCUS    */ ;
      .f.,                                      /* lGETLIST_TABSTOP      */ ;
      nil,                                      /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
      <aReSize>                                 /* aGETLIST_RESIZE       */ ;
    } )                                                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;


* ------------------------------- *

#command  @ <nRow> [,<nCol>] DC3STATE [<uVar>]                              ;
                [<prompt: PROMPT,CAPTION> <aVar>]                           ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [HELPCODE <cHelpCode>]                                      ;
                [DATALINK <bLink>]                                          ;
                [FONT <cFont>]                                              ;
                [WHEN <bWhen>]                                              ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [OBJECT <oObject>]                                          ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [CARGO <xCargo>]                                            ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
    { GETLIST_3STATE,                           /* nGETLIST_TYPE         */ ;
      nil,                                      /* nGETLIST_SUBTYPE      */ ;
      nil,                                      /* cGETLIST_CAPTION      */ ;
      [{DC_GetAnchorCB(@<uVar>,'N',,,<bLink>,,,<(uVar)>),                   ;
               <(uVar)>,'N',,,<(bLink)>}],      /* bGETLIST_VAR          */ ;
      <nRow>,                                   /* nGETLIST_STARTROW     */ ;
      <nCol>,                                   /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      <nWidth>,                                 /* nGETLIST_WIDTH        */ ;
      <nHeight>,                                /* nGETLIST_HEIGHT       */ ;
      <cFont>,                                  /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      <bWhen>,                                  /* bGETLIST_WHEN         */ ;
      nil,                                      /* bGETLIST_VALID        */ ;
      <cToolTip>,                               /* cGETLIST_TOOLTIP      */ ;
      <xCargo>,                                 /* xGETLIST_CARGO        */ ;
      <aPres>,                                  /* aGETLIST_PRESENTATION */ ;
      nil,                                      /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      nil,                                      /* xGETLIST_OPTIONS      */ ;
      [{<ncFgC>,<ncBgC>}],                      /* aGETLIST_COLOR        */ ;
      {<cMsg>,[{DC_GetAnchorCB(@<oMsg>,'O'),<(oMsg)>,'O'}]},                ;
                                                /* cGETLIST_MESSAGE      */ ;
      <cHelpCode>,                              /* cGETLIST_HELPCODE     */ ;
      <(uVar)>,                                 /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [{DC_GetAnchorCB(@<oObject>,'O'),                                     ;
                        <(oObject)>,'O'}],      /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),                                     ;
                        <(oParent)>,'O'}][<cPID>], /* bGETLIST_PARENT       */ ;
      [{DC_GetAnchorCB(@<aVar>),<(aVar)>}],     /* bGETLIST_REFVAR       */ ;
      <bProtect>,                               /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      <nCursor>,                                /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),                                        ;
                        <(oRel)>,'O'}],         /* bGETLIST_RELATIVE     */ ;
      nil,                                      /* xGETLIST_OPTIONS2     */ ;
      nil,                                      /* xGETLIST_OPTIONS3     */ ;
      nil,                                      /* xGETLIST_OPTIONS4     */ ;
      nil,                                      /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      <nAccel>,                                 /* nGETLIST_ACCELKEY     */ ;
      <bGotFocus>,                              /* bGETLIST_GOTFOCUS     */ ;
      <bLostFocus>,                             /* bGETLIST_LOSTFOCUS    */ ;
      DC_LogicTest([<.lTabStop.>],[<_tab>],[<.lNoTabStop.>],[<_notab>]),    ;
                                                /* lGETLIST_TABSTOP      */ ;
      <nTabGroup>,                              /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
      <aReSize>,                                /* aGETLIST_RESIZE       */ ;
      nil,                                      /* aGETLIST_DRAGDROP     */ ;
      <oConfig>,                                /* oGETLIST_CONFIG       */ ;
      <cSubClass>                               /* cGETLIST_SUBCLASS     */ ;
    } )                                                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;

* ------------------------------- *

#command  @ <nSRow>,<nSCol> [,<nERow>,<nECol>] DCGROUP <oGroup>             ;
                [BOX <cBox>]                                                ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [SIZE <nWidth>, <nHeight>]                                  ;
                [WIDTH <nWidth2>]                                           ;
                [HEIGHT <nHeight2>]                                         ;
                [CAPTION <cText>]                                           ;
                [FONT <cFont>]                                              ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [HELPCODE <cHelpCode>]                                      ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [CARGO <xCargo>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
        DC_GetTemplate(GETLIST_STATIC,XBPSTATIC_TYPE_GROUPBOX) )            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cText>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nSRow>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nSCol>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ENDROW,<nERow>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ENDCOL,<nECol>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth2>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight2>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,{<cBox>})]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
         DC_GetAnchorCB(@<oGroup>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
         DC_GetAnchorCB(@<oParent>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
         DC_GetAnchorCb(@<oRel>,'O'))]                                      ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;

* ------------------------------- *

#command  @ <nRow> [,<nCol>] DCSTATIC [TYPE <nType>]                        ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [WIDTH <nWidth2>]                                           ;
                [HEIGHT <nHeight2>]                                         ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [OPTIONS <nOptions>]                                        ;
                [OBJECT <ooo>]                                              ;
                [FONT <cFont>]                                              ;
                [CARGO <xCargo>]                                            ;
                [CAPTION <xCaption>]                                        ;
                [RESTYPE <cResType>]                                        ;
                [RESFILE <cResFile>]                                        ;
                [PRESENTATION <aPres>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [HELPCODE <cHelpCode>]                                      ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [<lNoAutoReSize:NOAUTORESIZE>] [_NOAUTORESIZE <_noautoresize>]  ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [VSCROLL <oVStatic>                                         ;
                         RANGE <nVStart>, <nVEnd> [OBJECT <oVScroll>]       ;
                         [INCREMENT <nVIncr>] ]                             ;
                [HSCROLL <oHStatic>                                         ;
                         RANGE <nHStart>, <nHEnd> [OBJECT <oHScroll>]       ;
                         [INCREMENT <nHIncr>] ]                             ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
 =>                                                                         ;
   AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_STATIC,<nType>) )             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<xCaption>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth2>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight2>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,{<nOptions>})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<ooo>,'O'))]                                        ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
         DC_GetAnchorCb(@<oRel>,'O'))]                                      ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
         { nil, <nVStart>, <nVEnd>, nil, <nVIncr> } )                       ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
         DC_GetAnchorCb(@<oVStatic>,'O'),1)]                                ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
         DC_GetAnchorCb(@<oVScroll>,'O'),4)]                                ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
         DC_GetAnchorCb(@<oVScroll>,'O'),4)]                                ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,                      ;
         { nil, <nHStart>, <nHEnd>, nil, <nHIncr> } )                       ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,                      ;
         DC_GetAnchorCb(@<oHStatic>,'O'),1)]                                ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,                      ;
         DC_GetAnchorCb(@<oHScroll>,'O'),4)]                                ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_OPTIONS4,<.lNoAutoReSize.>)]   ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_OPTIONS4,<_noautoresize>)]     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,                      ;
         {<(cResType)>,<cResFile>})]                                        ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;

* ------------------------------- *

#command  @ <nSRow> [,<nSCol>] DCTABPAGE [<oObject1>]                       ;
                [OBJECT <oObject2>]                                         ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [TYPE <nType>]                                              ;
                [TABHEIGHT <nTabH>]                                         ;
                [TABWIDTH <nTabW>]                                          ;
                [PREOFFSET <nPre>]                                          ;
                [POSTOFFSET <nPost>]                                        ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [GROUP <nGroup>]                                            ;
                [FONT <cFont>]                                              ;
                [CAPTION <cText>]                                           ;
                [RESTYPE <cResType>]                                        ;
                [RESFILE <cResFile>]                                        ;
                [CARGO <xCargo>]                                            ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [HELPCODE <cHelpCode>]                                      ;
                [COLOR <ncbColor> [,<ncbDisabled>] ]                        ;
                [DATALINK <bDataLink>]                                      ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [VALID <bValid>]                                            ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [RELATIVE <oRel>]                                           ;
                [TITLE <cTitle>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [PRESENTATION <aPres>]                                      ;
                [GROUP <cGroup>]                                            ;
                [STATICAREA <oStatic>]                                      ;
                [ANGLE <nAngle>]                                            ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize> [<sf:SCALEFONT>]]                         ;
                [MINIMIZEDCOLOR <anMinColorFG>, <anMinColorBG>]             ;
                [MAXIMIZEDCOLOR <anMaxColorFG>, <anMaxColorBG>]             ;
                [MINIMIZEDFONT <cMinFont>]                                  ;
                [MAXIMIZEDFONT <cMaxFont>]                                  ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
 =>                                                                         ;
   AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_TABPAGE) )                    ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_SUBTYPE,<nType>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cText>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nSRow>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nSCol>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VALID,<bValid>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,                        ;
         {<bDataLink>,<(bDataLink)>})]                                      ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
         { <nPre>, <nPost>, <nGroup>, <nTabH>, <nTabW>, <nAngle> } )]       ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
         {<(cResType)>,<cResFile>})]                                        ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,                      ;
         {{<anMinColorFG>,<anMinColorBG>},{<anMaxColorFG>,<anMaxColorBG>}})];
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,                      ;
         {<cMinFont>,<cMaxFont>})]                                          ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,                         ;
         {<ncbColor>,<ncbDisabled>})]                                       ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oObject1>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oObject2>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_REFVAR,                        ;
        DC_GetAnchorCB(@<oStatic>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
        DC_GetAnchorCb(@<oRel>,'O'))]                                       ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;

* ------------------------------- *

#xcommand  DCMENUBAR [OBJECT] <oMenuBar>                                    ;
           [<ownerdraw: OWNERDRAW>] [_OWNERDRAW <_own>]                     ;
           [<m:MENUBARFONT,FONT> <cBarFont>]                                ;
           [<m:MENUBARCOLOR,COLOR> <anBarColorFG>,<anBarColorBG>]           ;
           [<s:SUBBARFONT,SUBVERTBARFONT> <cSubBarFont>]                    ;
           [<s:SUBFGCOLOR,FGCOLOR> <anSubFGColor>]                          ;
           [<s:SUBBGCOLOR,BGCOLOR> <anSubBGColor>]                          ;
           [<s:SUBBARCOLOR,BARCOLOR> <anSubBarColorFG>,<anSubBarColorBG> ]  ;
           [<s:SUBITEMFONT,ITEMFONT> <cSubItemFont>]                        ;
           [<s:CHECKFONT,SUBCHECKFONT> <cSubCheckFont>]                     ;
           [<s:CHECKCHAR,SUBCHECKCHAR> <cSubCheckChar>]                     ;
           [SUBCOLOR <anSubFGClr>,<anSubBGClr>]                             ;
           [PARENT <oParent>]                                               ;
           [PARENTID <cPID>]                                                ;
           [EVAL <bEval>]                                                   ;
           [PREEVAL <bPreEval>]                                             ;
           [POSTEVAL <bPostEval>]                                           ;
           [TITLE <cTitle>]                                                 ;
           [CARGO <xCargo>]                                                 ;
           [ID <cId>]                                                       ;
           [GROUP <cGroup>]                                                 ;
           [HELPCODE <cHelpCode>]                                           ;
           [CLASS <bcClass>]                                                ;
           [BEGINMENU <bBeginMenu>]                                         ;
           [ENDMENU <bEndMenu>]                                             ;
           [ITEMSELECTED <bItemSelected>]                                   ;
           [ITEMMARKED <bItemMarked>]                                       ;
           [ONMENUKEY <bOnMenuKey>]                                         ;
           [<nobitmaps:NOBITMAPS>] [_NOBITMAPS <_nobitmaps>]                ;
           [CONFIG <oConfig>]                                               ;
           [BARBITMAP <bb>]                                                 ;
  =>                                                                        ;
  AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_MENUBAR) )                     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
         DC_GetAnchorCB(@<oMenuBar>,'O'))]                                  ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
         DC_GetAnchorCB(@<oParent>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG, <oConfig>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3, <.ownerdraw.> )]     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3, <_own> )]            ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,                      ;
          {<anSubFGColor>,<anSubBGColor>,<cSubBarFont>,<anSubBarColorFG>,   ;
           <anSubBarColorBG>,<cSubCheckFont>,<cSubCheckChar>,               ;
           <cBarFont>,<anBarColorFG>,<anBarColorBG>,<cSubItemFont>,         ;
           <.nobitmaps.>})]                                                 ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,<_nobitmaps>,12)]     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,<anSubFGClr>,1)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,<anSubBGClr>,2)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,                      ;
         {<bBeginMenu>,<bEndMenu>,<bItemSelected>,<bItemMarked>,            ;
          <bOnMenuKey>})]                                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS6,<bb>)]

* ------------------------------- *

#xcommand  DCSUBMENU <oSubMenu>                                             ;
                [<ownerdraw: OWNERDRAW>]                                    ;
                [<prompt: PROMPT,CAPTION> <cPrompt>]                        ;
                [<bartext: BARTEXT,BARCAPTION> <cBarText>]                  ;
                [BARFONT <cBarFont>]                                        ;
                [FGCOLOR <anFGColor1>]                                      ;
                [BGCOLOR <anBGColor1>]                                      ;
                [COLOR <anFGColor2>, <anBGColor2>]                          ;
                [BARCOLOR <anBarColorFG>,<anBarColorBG> ]                   ;
                [ITEMFONT <cItemFont>]                                      ;
                [TOOLTIP <cToolTip>]                                        ;
                [INDEX <nIndex>]                                            ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [WHEN <bWhen>]                                              ;
                [ACTION <bAction>]                                          ;
                [HELPCODE <cHelpCode>]                                      ;
                [<lCheck:CHECKED>] [_CHECKED <_checked>]                    ;
                [<lSep:SEPARATOR>] [_SEPARATOR <_separator>]                ;
                [<lBreak:COLUMNBREAK>] [_COLUMNBREAK <_cbreak>]             ;
                [<lSelect:SELECT>] [_SELECT <_select>]                      ;
                [STYLE <nStyle>]                                            ;
                [ATTRIBUTE <nAttr>]                                         ;
                [LOCK <cLock>]                                              ;
                [CHECKWHEN <bCheckWhen>]                                    ;
                [PROTECT <bProtect>]                                        ;
                [RETURN <nReturn>]                                          ;
                [CARGO <xCargo>]                                            ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [ID <cId>]                                                  ;
                [PRESENTATION <aPres>]                                      ;
                [TITLE <cTitle>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GROUP <cGroup>]                                            ;
                [BITMAP <nBmUnChecked> [, <nBmChecked>] ]                   ;
                [ICONS <aIcons>]                                            ;
                [CLASS <bcClass>]                                           ;
                [CHECKFONT <cCheckFont>]                                    ;
                [CHECKCHAR <cCheckChar>]                                    ;
                [NAME <nName>]                                              ;
                [ACTIVATEITEM <bActivate>]                                  ;
                [BEGINMENU <bBeginMenu>]                                    ;
                [ENDMENU <bEndMenu>]                                        ;
                [ITEMSELECTED <bItemSelected>]                              ;
                [ITEMMARKED <bItemMarked>]                                  ;
                [ONMENUKEY <bOnMenuKey>]                                    ;
                [<nobitmaps:NOBITMAPS>] [_NOBITMAPS <_nobitmaps>]           ;
                [CONFIG <oConfig>]                                          ;
 =>                                                                         ;
  AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_SUBMENU) )                     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cPrompt>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
         DC_GetAnchorCB(@<nIndex>,'N'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bAction>)]             ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
         {<nReturn>,<cId>,<cLock>,<.lCheck.>,<.lSep.>,                      ;
          <nStyle>,<nAttr>,<.lSelect.>,<bCheckWhen>,<.lBreak.>})            ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,_checked,4)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,_separator,5)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,_separator,8)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,_cbreak,10)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oSubMenu>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT, <bProtect>)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
        {<nBmUnChecked>,<nBmChecked>})]                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3, <.ownerdraw.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,                      ;
          {<cBarText>,<anBGColor1><anBGColor2>,<cBarFont>,<anBarColorFG>,   ;
           <anBarColorBG>,<cCheckFont>,<cCheckChar>,                        ;
           <anFGColor1><anFGColor2>,<cItemFont>,<.nobitmaps.>})]            ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,<_nobitmaps>,12)]     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS7, <aIcons>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5, <nName>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS6, <bActivate>)]        ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS8,                      ;
         {<bBeginMenu>,<bEndMenu>,<bItemSelected>,<bItemMarked>,            ;
          <bOnMenuKey>})]

* ------------------------------- *

#xcommand  DCMENUITEM [[CAPTION][PROMPT] <cPrompt>]                         ;
                [INDEX <nIndex>]                                            ;
                [TOOLTIP <cToolTip>]                                        ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [WHEN <bWhen>]                                              ;
                [CHECKWHEN <bCheckWhen>]                                    ;
                [ACTION <bAction>]                                          ;
                [STYLE <nStyle>]                                            ;
                [ATTRIBUTE <nAttr>]                                         ;
                [HELPCODE <cHelpCode>]                                      ;
                [LOCK <cLock>]                                              ;
                [PROTECT <bProtect>]                                        ;
                [<lCheck:CHECKED>] [_CHECKED <_checked>]                    ;
                [<lSep:SEPARATOR>] [_SEPARATOR <_separator>]                ;
                [<lSelect:SELECT>] [_SELECT <_select>]                      ;
                [<lBreak:COLUMNBREAK>] [_COLUMNBREAK <_cbreak>]             ;
                [RETURN <nReturn>]                                          ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [CARGO <xCargo>]                                            ;
                [ID <cId>]                                                  ;
                [TITLE <cTitle>]                                            ;
                [PRESENTATION <aPres>]                                      ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [ACCELKEY <nAccel>]                                         ;
                [GROUP <cGroup>]                                            ;
                [BITMAP <nBmUnChecked> [, <nBmChecked>] ]                   ;
                [ICONS <aIcons>]                                            ;
                [CLASS <bcClass>]                                           ;
                [NAME <nName>]                                              ;
                [PAD <nPad>]                                                ;
 =>                                                                         ;
  AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_MENUITEM) )                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cPrompt>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
          DC_GetAnchorCB(@<nIndex>,'N',))]                                  ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bAction>)]             ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
         {<nReturn>,<cId>,<cLock>,<.lCheck.>,<.lSep.>,                      ;
         <nStyle>,<nAttr>,<.lSelect.>,<bCheckWhen>,<.lBreak.>})             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,_checked,4)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,_separator,5)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,_separator,8)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,_cbreak,10)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT, <bProtect>)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
        {<nBmUnChecked>,<nBmChecked>})]                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5, <nName>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS6, <nPad>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS7, <aIcons>)]           ;


* ------------------------------- *

#xcommand  @ <nRow> [, <nCol>] DCBROWSE  [OBJECT] <oBrowse>                 ;
                [DATA <xData> [ELEMENT <nElement>]]                         ;
                [ALIAS <cAlias>]                                            ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [INTO <uVar>]                                               ;
                [POINTER <nVar>]                                            ;
                [DATALINK <bLink>]                                          ;
                [PRESENTATION <aPres>]                                      ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [COLOR <bncFgC> [,<ncBgC>]]                                 ;
                [<lZebra:ZEBRA> <baEven> [,<aOdd>] ]                        ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [FONT <cFont>]                                              ;
                [CARGO <xCargo>]                                            ;
                [CURSORMODE <nCursorMode>]                                  ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [EDIT <nEditEvent> [ACTION <bEditAction>]                   ;
                   [MODE <nbEditMode>] [FONT <cEditFont>]                   ;
                   [EXIT <bEditExit>]                                       ;
                   [<lNoAutoLock:NOAUTOLOCK>] [_NOAUTOLOCK <_noautolock>]]  ;
                [INSERT <nInsertEvent> [ACTION <bInsertAction>]             ;
                   [INSMODE <nInsertMode>]                                  ;
                   [EXIT <bInsertExit>] [DEFAULT <abDefault1>]              ;
                   [APPEND <nAppendEvent>] [APPMODE <nAppendMode>] ]        ;
                [DELETE <nDeleteEvent> [ACTION <bDeleteAction>]             ;
                   [EXIT <bDeleteExit>] ]                                   ;
                [DEFAULT <abDefault2>]                                      ;
                [HANDLER <EditHandler> [REFERENCE <xRef>]]                  ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [RELATIVE <oRel>]                                           ;
                [TITLE <cTitle>]                                            ;
                [FREEZELEFT <aFreezeL>]                                     ;
                [FREEZERIGHT <aFreezeR>]                                    ;
                [MARK <nbMark>]                                             ;
                [MKCOLOR <nbMarkEval>, <ncbMFgC> [,<ncMBgC>] ]              ;
                [ITEMMARKED <bItemMarked>]                                  ;
                [ITEMSELECTED <bItemSelected>]                              ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [<lScope:SCOPE>] [_SCOPE <_lScope>]                         ;
                [<lNoV:NOVSCROLL,NOVERTSCROLL>] [_NOVSCROLL <_lNoV>]        ;
                [<lNoH:NOHSCROLL,NOHORIZSCROLL>] [_NOHSCROLL <_lNoH>]       ;
                [<lNoST:NOSOFTTRACK>] [_NOSOFTTRACK <_lNoST>]               ;
                [GROUP <cGroup>]                                            ;
                [THUMBLOCK <nThumbRecs>]                                    ;
                [HEADLINES <nHeadLines> [DELIMITER <cHeadDelim>]]           ;
                [FOOTLINES <nFootLines> [DELIMITER <cFootDelim>]]           ;
                [HEADPRES <aHeadPres>]                                      ;
                [FOOTPRES <aFootPres>]                                      ;
                [EDITPROTECT <bProtect>]                                    ;
                [<lFit:FIT>] [_FIT <_lFit>]                                 ;
                [<lOptimize:OPTIMIZE>] [_OPTIMIZE <_lOptimize>]             ;
                [<lNoSizeCols:NOSIZECOLS>] [_NOSIZECOLS <_lNoSizeCols>]     ;
                [SORTSCOLOR <nSortedColorFG> [,<nSortedColorBG>] ]          ;
                [SORTUCOLOR <nUnSortedColorFG> [,<nUnSortedColorBG>] ]      ;
                [SORTNONCOLOR <nNonsortFG> [,<nNonsortBG>] ]                ;
                [SORTUPBITMAP <nBitmapSortUp>]                              ;
                [SORTDOWNBITMAP <nBitmapSortDown>]                          ;
                [<lDescend:DESCENDING>] [_DESCENDING <_lDescend>]           ;
                [<lNoDesT:NODESCENDTOGGLE>] [_NODESCENDTOGGLE <_lNoDesT>]   ;
                [AUTOREFRESH <nRefreshInterval> [REFRESHBLOCK <bRefresh>]   ;
                                                [WHEN <bRefreshWhen>]]      ;
                [<lRbSelect:RBSELECT>] [_RBSELECT <_lRbSelect>]             ;
                [HELPCODE <cHelpCode>]                                      ;
                [CLASS <bcClass>]                                           ;
                [RBDOWN <bRbDown>]                                          ;
                [FILTER <bFilter>]                                          ;
                [<lOverride:NOAUTORESTORE,NORESTORE>] [_NORESTORE <_override>] ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [<lRC:RESIZECOLUMNS>] [_RESISIZECOLUMNS <_rc>]              ;
                [<lTag:TAGENABLE>] [_TAGENABLE <_tag>]                      ;
                [TAGELEMENT <nTagElement>]                                  ;
                [TAGCOLOR <nTagColorFG>, <nTagColorBG>]                     ;
                [TAGMODE <nTagMode>]                                        ;
                [CONFIG <oConfig>]                                          ;
                [SCROLLBARTOOLTIP <bTipBlock>]                              ;
                [<uv:USEVISUALSTYLE>] [_USEVISUALSTYLE <_uv>]               ;
                [SUBCLASS <cSubClass>]                                      ;
                [OWNERDRAW <bOwnerDraw>]                                    ;
=>                                                                          ;
  AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_BROWSE) )                      ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
        {DC_GetAnchorCB(@<uVar>,,<uVar>),<(uVar)>})]                        ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bLink>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_VARNAME,<cAlias>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS9,<xRef>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
       {<nEditEvent>,<bEditAction>,<nbEditMode>,<cEditFont>,<bEditExit>,    ;
        <.lNoAutoLock.> [.OR. <_noautolock>], <abDefault2>})                ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,                      ;
       {<nInsertEvent>,<bInsertAction>, <abDefault1>,<bInsertExit>,         ;
        <nAppendEvent>,<nInsertMode>,<nAppendMode>})]                       ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,                      ;
       {<nDeleteEvent>,<bDeleteAction>,<bDeleteExit>})]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,<nElement>)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS6,                      ;
       {DC_GetAnchorCB(@<nVar>,'N'),<(nVar)>})]                             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS7,<nCursorMode>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS8,                      ;
       {|a,b,c,d,e,f,g,h|<EditHandler>(a,b,c,d,e,f,@g,h)})]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS9,<bTipBlock>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,                            ;
        iif(<.lZebra.>,{{||<oBrowse>:ZebraColor(<baEven>,<aOdd>)},nil},            ;
                            {<bncFgC>,<ncBgC>}))]                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oBrowse>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_REFVAR,                        ;
       {DC_GetAnchorCB(@<xData>),<(xData)>})]                               ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
          DC_GetAnchorCb(@<oRel>,'O'))]                                     ;
      ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                        ;
      { <nbMark>, <(nbMark)> ,                                              ;
        <nbMarkEval>, <(nbMarkEval)> ,                                      ;
        <ncbMFgC>, <ncMBgC>,                                                ;
        <aFreezeL>, <aFreezeR>,                                             ;
        <.lScope.> [.OR. <_lScope>], <nThumbRecs>,                          ;
        <nHeadLines>, <cHeadDelim>,                                         ;
        <nFootLines>, <cFootDelim>,                                         ;
        <aHeadPres>, <aFootPres>,                                           ;
        <.lNoV.> [.OR. <_lNoV>], <.lNoH.> [.OR. <_lNoH>],                   ;
        <.lNoST.> [.OR. <_lNoST>], <.lFit.> [.OR. <_lFit>],                 ;
        <.lOptimize.> [.OR. <_lOptimize>], <bItemMarked>,                   ;
        <bItemSelected>, <.lNoSizeCols.> [.OR. <_lNoSizeCols>],             ;
        <nSortedColorFG>,<nSortedColorBG>,                                  ;
        <nUnSortedColorFG>,<nUnSortedColorBG>,                              ;
        <nBitmapSortUp>,<nBitmapSortDown>,                                  ;
        <.lDescend.> [.OR. <_lDescend>],                                    ;
        <nRefreshInterval>,                                                 ;
        <.lRbSelect.> [.OR. <_lRbSelect>],                                  ;
        <.lNoDesT.> [.OR. <_lNoDesT>] ,                                     ;
        <bRbDown>,                                                          ;
        <bFilter>, <.lOverride.> [.OR. <_override>],                        ;
        <nNonsortFG>, <nNonsortBG>,                                         ;
        <.lRC.> [.OR. <_rc>] ,                                              ;
        <.lTag.> [.OR. <_tag>],                                             ;
        <nTagElement>, <nTagColorFG>, <nTagColorBG>, <nTagMode>,            ;
        <.uv.> [.OR. <_uv>], <bRefresh>, <bRefreshWhen>, <bOwnerDraw> } )   ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;


* ------------------------------- *

#xcommand DCBROWSECOL                                                       ;
                [DATA <xData>]                                              ;
                [ADSFIELD <adsFld> [CURSOR <adsCursor>] [FORMAT <adsFormat>]];
                [FIELD <fld>]                                               ;
                [PICTURE <cPict>]                                           ;
                [ELEMENT <nPointer>]                                        ;
                [WIDTH <nWidth>]                                            ;
                [<h:HEADER,HEADING> <cHeader>] [HEADPRES <aHeadPres>]       ;
                [<f:FOOTER,FOOTING> <cFooter>] [FOOTPRES <aFootPres>]       ;
                [TYPE <anType>]                                             ;
                [REPRESENTATION <aRep>]                                     ;
                [ALIGN <nAlign>]                                            ;
                [COLOR <bncFgC> [,<ncBgC>] ]                                ;
                [HCOLOR <bncHFgC> [,<ncHBgC>] ]                             ;
                [FCOLOR <bncFFgC> [,<ncFBgC>] ]                             ;
                [HFONT <bcHFont>]                                           ;
                [HHEIGHT <bnHHeight>]                                       ;
                [FFONT <bcFFont>]                                           ;
                [FHEIGHT <bnFHeight>]                                       ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [TOOLTIP <cToolTip>]                                        ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [HELPCODE <cHelpCode>]                                      ;
                [OBJECT <oObject>]                                          ;
                [HIDE <bHide>]                                              ;
                [VALID <bValid> [<always:ALWAYS>] [ALWAYS <_always>]]       ;
                [FONT <cFont>]                                              ;
                [CARGO <xCargo>]                                            ;
                [PRESENTATION <aPres>]                                      ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [WHEN <bWhen>]                                              ;
                [SORT <bSort>                                               ;
                     [<lb:LEFTBUTTON>] [_LEFTBUTTON <_lb>]                  ;
                     [<def:DEFAULT>] [_DEFAULT <_def>]]                     ;
                [TITLE <cTitle>]                                            ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [EDITOR <bcEdit> [EXITKEY <nExitKey>] ]                     ;
                [GROUP <cGroup>]                                            ;
                [<prot: PROTECT, EDITPROTECT> <bProtect>]                   ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [DATATOOLTIP <bTipWhen> [TIPBLOCK <bTipBlock>]]             ;
                [<lNoCreate:NOCREATE>] [_NOCREATE <_noc>]                   ;
                [<lNoResize:NORESIZE>] [_NORESIZE <_nor>]                   ;
                [CLASS <bcClass>]                                           ;
                [<lHide:HIDE>]                                              ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [<lNoAutoResizeColumn:NOAUTORESIZE>]                        ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
                [<lOwnerDraw:OWNERDRAW>] [_OWNERDRAW <_od>]                 ;
 =>                                                                         ;
  AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_BROWSECOL) )                   ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_SUBTYPE,<anType>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_CAPTION,<cHeader>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
         {|a| IIF(a==NIL .OR. <fld>==a, <fld>, <fld>:=a) })]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
         DC_AdsFieldBlock(<adsCursor>,<adsFld>,<adsFormat>))]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_PICTURE,<cPict>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VALID,<bValid>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
        {<bSort>,<(bSort)>,<cFooter>,<bcEdit>,<nExitKey>,                   ;
        <.lb.>,<.lNoCreate.>,<.def.>,<.lNoResize.>,<.lHide.>,               ;
        <.lNoAutoResizeColumn.>, <.always.>, <.lOwnerDraw.>})               ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_lb>,6)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_noc>,7)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_nor>,9)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_def>,8)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_always>,12)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_od>,13)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<bncFgC>,<ncBgC>})]     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oObject>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_POINTER,<nPointer>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_REFVAR,                        ;
        {<xData>,<(xData)>})]                                               ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,<bProtect>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,oGETLIST_CONFIG,<oConfig>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,DC_GetIdDefault(<cId>,<(fld)>,'COL_'))] ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
        {<bncHFgC>,<ncHBgC>,<bcHFont>,<bnHHeight>})]                        ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,<aHeadPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,<aFootPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,<(fld)>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS6,<aRep>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS7,<nAlign>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS8,                      ;
        {<bncFFgC>,<ncFBgC>,<bcFFont>,<bnFHeight>})]                        ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS9,                      ;
        {<bTipWhen>,<bTipBlock>})]                                          ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;


* ------------------------------- *

#xcommand DCBROWSECOL SEPARATOR                                             ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [CLASS <bcClass>]                                           ;
 =>                                                                         ;
  AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_BROWSECOL) )                   ;
       ;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,4)                       ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
       ;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,.t.)                     ;
       ;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PROTECT,{||.t.})               ;
       ;DC_GetListSet(DCGUI_GETLIST,bGETLIST_REFVAR,{||''})                 ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,{,,,,,,,,.t.})

* ------------------------------- *

#xcommand  @ <nRow> [, <nCol>] DCQUICKBROWSE                                ;
                [OBJECT <oBrowse> ]                                         ;
                [ALIAS <cAlias>]                                            ;
                [FIELDS <aFields>]                                          ;
                [DATA <xData>]                                              ;
                [COLUMNS <aColumns>]                                        ;
                [COLTYPE <aColType>]                                        ;
                [COLREPRESENTATION <aColRep>]                               ;
                [COLWIDTH <aColWidth>]                                      ;
                [COLALIGN <aColAlign>]                                      ;
                [HEADERS <aHeaders>]                                        ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [STYLE <nStyle>]                                            ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [INTO <uVar>]                                               ;
                [POINTER <nVar>]                                            ;
                [DATALINK <bLink>]                                          ;
                [PRESENTATION <aPres>]                                      ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [COLOR <bncFgC> [,<ncBgC>]]                                 ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [FONT <cFont>]                                              ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [CARGO <xCargo>]                                            ;
                [CURSORMODE <nCursorMode>]                                  ;
                [EDIT <nEditEvent> [ACTION <bEditAction>]                   ;
                   [MODE <nbEditMode>] [FONT <cEditFont>]                   ;
                   [EXIT <bEditExit>] [<lNoAutoLock:NOAUTOLOCK>] ]          ;
                [INSERT <nInsertEvent> [ACTION <bInsertAction>]             ;
                   [DEFAULT <abDefault>] [EXIT <bInsertExit>]               ;
                   [APPEND <nAppendEvent>] ]                                ;
                [DELETE <nDeleteEvent> [ACTION <bDeleteAction>]             ;
                   [EXIT <bDeleteExit>] ]                                   ;
                [HANDLER <EditHandler> [REFERENCE <xRef>]]                  ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [RELATIVE <oRel>]                                           ;
                [TITLE <cTitle>]                                            ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [<lNoV:NOVSCROLL>] [_NOVSCROLL <_nov>]                      ;
                [<lNoH:NOHSCROLL>] [_NOHSCROLL <_noh>]                      ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [ITEMMARKED <bItemMarked>]                                  ;
                [ITEMSELECTED <bItemSelected>]                              ;
                [HELPCODE <cHelpCode>]                                      ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [SUBCLASS <cSubClass>]                                      ;
 =>                                                                         ;
  AADD( DCGUI_GETLIST,                                                      ;
    { GETLIST_QUICKBROWSE,                      /* nGETLIST_TYPE         */ ;
      nil,                                      /* nGETLIST_SUBTYPE      */ ;
      nil,                                      /* cGETLIST_CAPTION      */ ;
      [{DC_GetAnchorCB(@<uVar>,,<uVar>),                                    ;
                                <(uVar)>}],     /* bGETLIST_VAR          */ ;
      <nRow>,                                   /* nGETLIST_STARTROW     */ ;
      <nCol>,                                   /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      <nWidth>,                                 /* nGETLIST_WIDTH        */ ;
      <nHeight>,                                /* nGETLIST_HEIGHT       */ ;
      <cFont>,                                  /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      <bWhen>,                                  /* bGETLIST_WHEN         */ ;
      nil,                                      /* bGETLIST_VALID        */ ;
      nil,                                      /* cGETLIST_TOOLTIP      */ ;
      <xCargo>,                                 /* xGETLIST_CARGO        */ ;
      <aPres>,                                  /* aGETLIST_PRESENTATION */ ;
      [{<bLink>,<(bLink)>}],                    /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      { <nCursorMode>, <nStyle>,                                            ;
        <.lNoV.> [.OR. <_nov>], <.lNoH.> [.OR. <_noh>],                     ;
        <bItemMarked>, <bItemSelected> } ,                                  ;
                                                /* xGETLIST_OPTIONS      */ ;
      [{<bncFgC>,<ncBgC>}],                     /* aGETLIST_COLOR        */ ;
      {<cMsg>,[{DC_GetAnchorCB(@<oMsg>,'O'),<(oMsg)>,'O'}]},                ;
                                                /* cGETLIST_MESSAGE      */ ;
      <cHelpCode>,                              /* cGETLIST_HELPCODE     */ ;
      <cAlias>,                                 /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [{DC_GetAnchorCB(@<oBrowse>,'O'),                                     ;
                       <(oBrowse)>,'O'}],       /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),                                     ;
                        <(oParent)>,'O'}][<cPID>], /* bGETLIST_PARENT    */ ;
      [{DC_GetAnchorCB(@<xData>),<(xData)>}],   /* bGETLIST_REFVAR       */ ;
      nil,                                      /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      nil,                                      /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),                                        ;
                        <(oRel)>,'O'}],         /* bGETLIST_RELATIVE     */ ;
      [{<nEditEvent>,<bEditAction>,<nbEditMode>,                            ;
        <cEditFont>,<bEditExit>,                                            ;
        <.lNoAutoLock.>}],                      /* xGETLIST_OPTIONS2     */ ;
      [{<nInsertEvent>,<bInsertAction>,                                     ;
        <abDefault>,<bInsertExit>,                                          ;
        <nAppendEvent>}],                       /* xGETLIST_OPTIONS3     */ ;
      [{<nDeleteEvent>,<bDeleteAction>,                                     ;
        <bDeleteExit>}],                        /* xGETLIST_OPTIONS4     */ ;
      [{<aHeaders>,<aColumns>,<aFields>,<aColType>,                         ;
        <aColRep>,<aColWidth>,<aColAlign>}],    /* xGETLIST_OPTIONS5     */ ;
      [{DC_GetAnchorCB(@<nVar>,'N'),<(nVar)>}], /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      [{|a,b,c,d,e,f,g,h|<EditHandler>(a,b,c,d,e,f,@g,h)}],                 ;
                                                /* xGETLIST_OPTIONS8     */ ;
      <xRef>,                                   /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      <nAccel>,                                 /* nGETLIST_ACCELKEY     */ ;
      <bGotFocus>,                              /* bGETLIST_GOTFOCUS     */ ;
      <bLostFocus>,                             /* bGETLIST_LOSTFOCUS    */ ;
      DC_LogicTest([<.lTabStop.>],[<_tab>],[<.lNoTabStop.>],[<_notab>]),    ;
                                                /* lGETLIST_TABSTOP      */ ;
      <nTabGroup>,                              /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
      <aReSize>,                                /* aGETLIST_RESIZE       */ ;
      nil,                                                                  ;
      nil,                                                                  ;
      <cSubClass>                                                           ;
    } )                                                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;

* ------------------------------- *

#xcommand  DCBITMAP <ncbResource>                                           ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [TARGETRECT <nSRow>,<nSCol>,<nERow>,<nECol>]                ;
                [SOURCERECT <a>,<b>,<c>,<d>]                                ;
                [BITS <nB>]                                                 ;
                [HIDE <bHide>]                                              ;
                [PLANES <nP>]                                               ;
                [OBJECT <oObject>]                                          ;
                [CARGO <xCargo>]                                            ;
                [<s: AUTOSCALE>] [_AUTOSCALE <_autoscale> ]                 ;
                [<cen: CENTER>] [_CENTER <_center>]                         ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [GROUP <cGroup>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [POSTEVAL <bPostEval>]                                      ;
                [CLASS <bcClass>]                                           ;
                [SUBCLASS <cSubClass>]                                      ;
 =>                                                                         ;
  AADD( DCGUI_GETLIST,                                                      ;
    { GETLIST_BITMAP,                           /* nGETLIST_TYPE         */ ;
      nil,                                      /* nGETLIST_SUBTYPE      */ ;
      nil,                                      /* cGETLIST_CAPTION      */ ;
      <ncbResource>,                            /* bGETLIST_VAR          */ ;
      <nSRow>,                                  /* nGETLIST_STARTROW     */ ;
      <nSCol>,                                  /* nGETLIST_STARTCOL     */ ;
      <nERow>,                                  /* nGETLIST_ENDROW       */ ;
      <nECol>,                                  /* nGETLIST_ENDCOL       */ ;
      nil,                                      /* nGETLIST_WIDTH        */ ;
      nil,                                      /* nGETLIST_HEIGHT       */ ;
      nil,                                      /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      nil,                                      /* bGETLIST_WHEN         */ ;
      nil,                                      /* bGETLIST_VALID        */ ;
      nil,                                      /* cGETLIST_TOOLTIP      */ ;
      <xCargo>,                                 /* xGETLIST_CARGO        */ ;
      nil,                                      /* aGETLIST_PRESENTATION */ ;
      nil,                                      /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      {<nB>,<nP>,<.s.> [.OR. <_autoscale>],<a>,<b>,<c>,<d>,                 ;
       <.cen.> [.OR. <_center>]},               /* xGETLIST_OPTIONS      */ ;
      nil,                                      /* aGETLIST_COLOR        */ ;
      nil,                                      /* cGETLIST_MESSAGE      */ ;
      <cHelpCode>,                              /* cGETLIST_HELPCODE     */ ;
      nil,                                      /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [{DC_GetAnchorCB(@<oObject>,'O'),                                     ;
                        <(oObject)>,'O'}],      /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),                                     ;
                        <(oParent)>,'O'}][<cPID>],  /* bGETLIST_PARENT       */ ;
      nil,                                      /* bGETLIST_REFVAR       */ ;
      nil,                                      /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      nil,                                      /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),                                        ;
                        <(oRel)>,'O'}],         /* bGETLIST_RELATIVE     */ ;
      nil,                                      /* xGETLIST_OPTIONS2     */ ;
      nil,                                      /* xGETLIST_OPTIONS3     */ ;
      nil,                                      /* xGETLIST_OPTIONS4     */ ;
      nil,                                      /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      nil,                                      /* nGETLIST_ACCELKEY     */ ;
      nil,                                      /* bGETLIST_GOTFOCUS     */ ;
      nil,                                      /* bGETLIST_LOSTFOCUS    */ ;
      .f.,                                      /* lGETLIST_TABSTOP      */ ;
      nil,                                      /* nGETLIST_TABGROUP     */ ;
      nil,                                      /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
      nil,                                                                  ;
      nil,                                                                  ;
      nil,                                                                  ;
      <cSubClass>                                                           ;
   } )

* ----------------------------- *

#command  @ <nRow> [,<nCol>] DCSPINBUTTON [<nVar>]                          ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [VALID <bValid>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [FONT <cFont>]                                              ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [PRESENTATION <aPres>]                                      ;
                [MASTER <oMaster>]                                          ;
                [OBJECT <oObject>]                                          ;
                [CALLBACK <bCallBack>]                                      ;
                [ENDSPIN <bEndSpin>]                                        ;
                [DOWNSPIN <bDownSpin>]                                      ;
                [UPSPIN <bUpSpin>]                                          ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [DATALINK <bLink>]                                          ;
                [<l: LIMITS,RANGE> <nBott>,<nTop>]                          ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [<f: FASTSPIN>] [_FASTSPIN <_fastspin>]                     ;
                [<z: PADZERO>] [_PADZERO <_padzero>]                        ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [CARGO <xCargo>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
    { GETLIST_SPINBUTTON,                       /* nGETLIST_TYPE         */ ;
      nil,                                      /* nGETLIST_SUBTYPE      */ ;
      nil,                                      /* cGETLIST_CAPTION      */ ;
      [{DC_GetAnchorCB(@<nVar>,'N',,<bLink>,,,<(nVar)>),                    ;
                <(nVar)>,'N',,<(bLink)>}],      /* bGETLIST_VAR          */ ;
      <nRow>,                                   /* nGETLIST_STARTROW     */ ;
      <nCol>,                                   /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      <nWidth>,                                 /* nGETLIST_WIDTH        */ ;
      <nHeight>,                                /* nGETLIST_HEIGHT       */ ;
      <cFont>,                                  /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      <bWhen>,                                  /* bGETLIST_WHEN         */ ;
      <bValid>,                                 /* bGETLIST_VALID        */ ;
      <cToolTip>,                               /* cGETLIST_TOOLTIP      */ ;
      <xCargo>,                                 /* xGETLIST_CARGO        */ ;
      <aPres>,                                  /* aGETLIST_PRESENTATION */ ;
      {<bCallBack>,<(bCallBack)>},              /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      {<.f.> [.OR. <_fastspin>],<.z.> [.OR. <_padzero>],                    ;
       <nBott>,<nTop>},                         /* xGETLIST_OPTIONS      */ ;
      [{<ncFgC>,<ncBgC>}],                      /* aGETLIST_COLOR        */ ;
      {<cMsg>,[{DC_GetAnchorCB(@<oMsg>,'O'),<(oMsg)>,'O'}]},                ;
                                                /* cGETLIST_MESSAGE      */ ;
      <cHelpCode>,                              /* cGETLIST_HELPCODE     */ ;
      <(nVar)>,                                 /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [{DC_GetAnchorCB(@<oObject>,'O'),                                     ;
                        <(oObject)>,'O'}],      /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),                                     ;
                        <(oParent)>,'O'}][<cPID>], /* bGETLIST_PARENT       */ ;
      [{DC_GetAnchorCB(@<oMaster>,'O'),                                     ;
                        <(oMaster)>,'O'}],      /* bGETLIST_REFVAR       */ ;
      <bProtect>,                               /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      <nCursor>,                                /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),                                        ;
                        <(oRel)>,'O'}],         /* bGETLIST_RELATIVE     */ ;
      nil,                                      /* xGETLIST_OPTIONS2     */ ;
      [<bEndSpin>],                             /* xGETLIST_OPTIONS3     */ ;
      [<bDownSpin>],                            /* xGETLIST_OPTIONS4     */ ;
      [<bUpSpin>],                              /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      <nAccel>,                                 /* nGETLIST_ACCELKEY     */ ;
      <bGotFocus>,                              /* bGETLIST_GOTFOCUS     */ ;
      <bLostFocus>,                             /* bGETLIST_LOSTFOCUS    */ ;
      DC_LogicTest([<.lTabStop.>],[<_tab>],[<.lNoTabStop.>],[<_notab>]),    ;
                                                /* lGETLIST_TABSTOP      */ ;
      <nTabGroup>,                              /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
      <aReSize>,                                /* aGETLIST_RESIZE       */ ;
      nil,                                      /* aGETLIST_DRAGDROP     */ ;
      <oConfig>,                                /* oGETLIST_CONFIG       */ ;
      <cSubClass>                               /* cGETLIST_SUBCLASS     */ ;
    } )                                                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;

* ----------------------------- *

#command  @ <nRow> [,<nCol>] DCSCROLLBAR                                    ;
                [DATA <uVar>]                                               ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [PRESENTATION <aPres>]                                      ;
                [TYPE <nType>]                                              ;
                [SCROLL <bScroll>]                                          ;
                [OBJECT <oBar>]                                             ;
                [RANGE <nBott>,<nTop>]                                      ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [CARGO <xCargo>]                                            ;
                [HIDE <bHide>]                                              ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [<a :AUTOTRACK>] [_AUTOTRACK <_autotrack>]                  ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
    { GETLIST_SCROLLBAR,                        /* nGETLIST_TYPE         */ ;
      <nType>,                                  /* nGETLIST_SUBTYPE      */ ;
      nil,                                      /* cGETLIST_CAPTION      */ ;
      [{DC_GetAnchorCB(@<uVar>,,<uVar>),                                    ;
                       <(uVar)>}],              /* bGETLIST_VAR          */ ;
      <nRow>,                                   /* nGETLIST_STARTROW     */ ;
      <nCol>,                                   /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      <nWidth>,                                 /* nGETLIST_WIDTH        */ ;
      <nHeight>,                                /* nGETLIST_HEIGHT       */ ;
      nil,                                      /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      nil,                                      /* bGETLIST_WHEN         */ ;
      nil,                                      /* bGETLIST_VALID        */ ;
      <cToolTip>,                               /* cGETLIST_TOOLTIP      */ ;
      <xCargo>,                                 /* xGETLIST_CARGO        */ ;
      <aPres>,                                  /* aGETLIST_PRESENTATION */ ;
      {<bScroll>,<(bScroll)>},                  /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      {<.a.> [.OR. <_autotrack>],<nBott>,<nTop>},                           ;
                                                /* xGETLIST_OPTIONS      */ ;
      nil,                                      /* aGETLIST_COLOR        */ ;
      nil,                                      /* cGETLIST_MESSAGE      */ ;
      <cHelpCode>,                              /* cGETLIST_HELPCODE     */ ;
      nil,                                      /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [{DC_GetAnchorCB(@<oBar>,'O'),                                        ;
                     <(oBar)>,'O'}],            /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),                                     ;
                        <(oParent)>,'O'}][<cPID>], /* bGETLIST_PARENT       */ ;
      nil,                                      /* bGETLIST_REFVAR       */ ;
      nil,                                      /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      <nCursor>,                                /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),                                        ;
                        <(oRel)>,'O'}],         /* bGETLIST_RELATIVE     */ ;
      nil,                                      /* xGETLIST_OPTIONS2     */ ;
      nil,                                      /* xGETLIST_OPTIONS3     */ ;
      nil,                                      /* xGETLIST_OPTIONS4     */ ;
      nil,                                      /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      <nAccel>,                                 /* nGETLIST_ACCELKEY     */ ;
      <bGotFocus>,                              /* bGETLIST_GOTFOCUS     */ ;
      <bLostFocus>,                             /* bGETLIST_LOSTFOCUS    */ ;
      DC_LogicTest([<.lTabStop.>],[<_tab>],[<.lNoTabStop.>],[<_notab>]),    ;
                                                /* lGETLIST_TABSTOP      */ ;
      <nTabGroup>,                              /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
      <aReSize>,                                /* aGETLIST_RESIZE       */ ;
      nil,                                      /* aGETLIST_DRAGDROP     */ ;
      <oConfig>,                                /* oGETLIST_CONFIG       */ ;
      <cSubClass>                               /* cGETLIST_SUBCLASS     */ ;
    } )                                                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;

* ----------------------------- *

#command  @ <nRow> [,<nCol>] DCCUSTOM <bCustom>                             ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [VAR <uVar>]                                                ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [CAPTION <cCaption>]                                        ;
                [PRESENTATION <aPres>]                                      ;
                [TYPE <nType>]                                              ;
                [OBJECT <oCustom>]                                          ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [OPTIONS <aOptions>]                                        ;
                [DATALINK <bLink>]                                          ;
                [FONT <cFont>]                                              ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [VALID <bValid>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [TOOLTIP <cToolTip>]                                        ;
                [ACTION <bAction>]                                          ;
                [CURSOR <nCursor>]                                          ;
                [CARGO <xCargo>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ ID <cId>]                                                 ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
    { GETLIST_CUSTOM,                           /* nGETLIST_TYPE         */ ;
      <nType>,                                  /* nGETLIST_SUBTYPE      */ ;
      <cCaption>,                               /* cGETLIST_CAPTION      */ ;
      [{DC_GetAnchorCB(@<uVar>,,<uVar>,,<bLink>,,,<(uVar)>),                ;
                <(uVar)>,,,,<(bLink)>}],        /* bGETLIST_VAR          */ ;
      <nRow>,                                   /* nGETLIST_STARTROW     */ ;
      <nCol>,                                   /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      <nWidth>,                                 /* nGETLIST_WIDTH        */ ;
      <nHeight>,                                /* nGETLIST_HEIGHT       */ ;
      <cFont>,                                  /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      <bWhen>,                                  /* bGETLIST_WHEN         */ ;
      <bValid>,                                 /* bGETLIST_VALID        */ ;
      <cToolTip>,                               /* cGETLIST_TOOLTIP      */ ;
      <xCargo>,                                 /* xGETLIST_CARGO        */ ;
      <aPres>,                                  /* aGETLIST_PRESENTATION */ ;
      <bAction>,                                /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      <aOptions>,                               /* xGETLIST_OPTIONS      */ ;
      [{<ncFgC>,<ncBgC>}],                      /* aGETLIST_COLOR        */ ;
      {<cMsg>,[{DC_GetAnchorCB(@<oMsg>,'O'),<(oMsg)>,'O'}]},                ;
                                                /* cGETLIST_MESSAGE      */ ;
      <cHelpCode>,                              /* cGETLIST_HELPCODE     */ ;
      <(bCustom)>,                              /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [{DC_GetAnchorCB(@<oCustom>,'O'),                                     ;
                        <(oCustom)>,'O'}],      /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),                                     ;
                        <(oParent)>,'O'}][<cPID>], /* bGETLIST_PARENT       */ ;
      {<bCustom>,<(bCustom)>},                  /* bGETLIST_REFVAR       */ ;
      <bProtect>,                               /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      <nCursor>,                                /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),                                        ;
                        <(oRel)>,'O'}],         /* bGETLIST_RELATIVE     */ ;
      nil,                                      /* xGETLIST_OPTIONS2     */ ;
      nil,                                      /* xGETLIST_OPTIONS3     */ ;
      nil,                                      /* xGETLIST_OPTIONS4     */ ;
      nil,                                      /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      <nAccel>,                                 /* nGETLIST_ACCELKEY     */ ;
      <bGotFocus>,                              /* bGETLIST_GOTFOCUS     */ ;
      <bLostFocus>,                             /* bGETLIST_LOSTFOCUS    */ ;
      DC_LogicTest([<.lTabStop.>],[<_tab>],[<.lNoTabStop.>],[<_notab>]),    ;
                                                /* lGETLIST_TABSTOP      */ ;
      <nTabGroup>,                              /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
      <aReSize>,                                /* aGETLIST_RESIZE       */ ;
    } )                                                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;

* ----------------------------- *

#command  @ <nRow> [,<nCol>] DCPROGRESS [OBJECT] <oProgress>                ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [TYPE <nType>]                                              ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [PRESENTATION <aPres>]                                      ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [MAXCOUNT <nMaxCount>]                                      ;
                [TOOLTIP <cToolTip>]                                        ;
                [CARGO <xCargo>]                                            ;
                [HIDE <bHide>]                                              ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [EVERY <nCount>]                                            ;
                [<lPercent:PERCENT>] [_PERCENT <_percent>]                  ;
                [PERCENTCOLOR <ncPercentColor>]                             ;
                [FONT <ocFont>]                                             ;
                [RADIUS <nRadius>]                                          ;
                [<lOutline:OUTLINE>] [_OUTLINE <_outline>]                  ;
                [<lDynamic:DYNAMIC>] [_DYNAMIC <_dynamic>]                  ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CURSOR <nCursor>]                                          ;
                [<lVert:VERTICAL>] [_VERTICAL <_vertical>]                  ;
                [<lBroken:BROKEN>] [_BROKEN <_broken>]                      ;
                [HELPCODE <cHelpCode>]                                      ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [CONFIG <oConfig>]                                          ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
    { GETLIST_PROGRESS,                         /* nGETLIST_TYPE         */ ;
      <nType>,                                  /* nGETLIST_SUBTYPE      */ ;
      nil,                                      /* cGETLIST_CAPTION      */ ;
      nil,                                      /* nGETLIST_VAR          */ ;
      <nRow>,                                   /* nGETLIST_STARTROW     */ ;
      <nCol>,                                   /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      <nWidth>,                                 /* nGETLIST_WIDTH        */ ;
      <nHeight>,                                /* nGETLIST_HEIGHT       */ ;
      <ocFont>,                                 /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      nil,                                      /* bGETLIST_WHEN         */ ;
      nil,                                      /* bGETLIST_VALID        */ ;
      <cToolTip>,                               /* cGETLIST_TOOLTIP      */ ;
      <xCargo>,                                 /* xGETLIST_CARGO        */ ;
      <aPres>,                                  /* aGETLIST_PRESENTATION */ ;
      nil,                                      /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      {<nMaxCount>,<.lPercent.> [.OR. <_percent>],<nCount>,                 ;
       <.lVert.> [.OR. <_vertical>],<.lBroken.> [.OR. <_broken>]},          ;
                                                /* xGETLIST_OPTIONS      */ ;
      [{<ncFgC>,<ncBgC>}],                      /* aGETLIST_COLOR        */ ;
      nil,                                      /* cGETLIST_MESSAGE      */ ;
      <cHelpCode>,                              /* cGETLIST_HELPCODE     */ ;
      nil,                                      /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      [{DC_GetAnchorCB(@<oProgress>,'O'),                                   ;
                        <(oProgress)>,'O'}],    /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),                                     ;
                        <(oParent)>,'O'}][<cPID>], /* bGETLIST_PARENT       */ ;
      nil,                                      /* bGETLIST_REFVAR       */ ;
      nil,                                      /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      <nCursor>,                                /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),                                        ;
                        <(oRel)>,'O'}],         /* bGETLIST_RELATIVE     */ ;
      <ncPercentColor>,                         /* xGETLIST_OPTIONS2     */ ;
      <nRadius>,                                /* xGETLIST_OPTIONS3     */ ;
      <.lDynamic.> [.OR. <_dynamic>],           /* xGETLIST_OPTIONS4     */ ;
      <.lOutline.> [.OR. <_outline>],           /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      nil,                                      /* nGETLIST_ACCELKEY     */ ;
      nil,                                      /* bGETLIST_GOTFOCUS     */ ;
      nil,                                      /* bGETLIST_LOSTFOCUS    */ ;
      .f.,                                      /* lGETLIST_TABSTOP      */ ;
      nil,                                      /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
      <aReSize>,                                /* aGETLIST_RESIZE       */ ;
      nil,                                      /* aGETLIST_DRAGDROP     */ ;
      <oConfig>,                                /* oGETLIST_CONFIG       */ ;
      <cSubClass>                               /* cGETLIST_SUBCLASS     */ ;
    } )                                                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;

* ----------------------------- *

#command  @ <nRow> [,<nCol>] DCAPPCRT <oCrt>                                ;
                [SIZE <nHeight> [,<nWidth>]]                                ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [CAPTION <cCaption>]                                        ;
                [TYPE <nType>]                                              ;
                [BORDER <nB>]                                               ;
                [FONT <cFont>]                                              ;
                [FONTSIZE <nFW>,<nFH>]                                      ;
                [ACTION <bAction>]                                          ;
                [CURSOR <nCursor>]                                          ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [CARGO <xCargo>]                                            ;
                [THREAD <oThread>]                                          ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [HIDE <bHide>]                                              ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TITLE <cTitle>]                                            ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
    { GETLIST_APPCRT,                           /* nGETLIST_TYPE         */ ;
      <nType>,                                  /* nGETLIST_SUBTYPE      */ ;
      <cCaption>,                               /* cGETLIST_CAPTION      */ ;
      nil,                                      /* bGETLIST_VAR          */ ;
      <nRow>,                                   /* nGETLIST_STARTROW     */ ;
      <nCol>,                                   /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      <nWidth>,                                 /* nGETLIST_WIDTH        */ ;
      <nHeight>,                                /* nGETLIST_HEIGHT       */ ;
      <cFont>,                                  /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      nil,                                      /* bGETLIST_WHEN         */ ;
      nil,                                      /* bGETLIST_VALID        */ ;
      nil,                                      /* cGETLIST_TOOLTIP      */ ;
      <xCargo>,                                 /* xGETLIST_CARGO        */ ;
      nil,                                      /* aGETLIST_PRESENTATION */ ;
      <bAction>,                                /* bGETLIST_ACTION       */ ;
      nil,                                      /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      {<nFW>,<nFH>,<nB>},                       /* xGETLIST_OPTIONS      */ ;
      [{<ncFgC>,<ncBgC>}],                      /* aGETLIST_COLOR        */ ;
      nil,                                      /* cGETLIST_MESSAGE      */ ;
      nil,                                      /* cGETLIST_HELPCODE     */ ;
      nil,                                      /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      {DC_GetAnchorCB(@<oCrt>,'O'),<(oCrt)>},   /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),                                     ;
                        <(oParent)>,'O'}][<cPID>], /* bGETLIST_PARENT       */ ;
      [{DC_GetAnchorCB(@<oThread>,'O'),                                     ;
                        <(oThread)>,'O'}],      /* bGETLIST_REFVAR       */ ;
      nil,                                      /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      <nCursor>,                                /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),                                        ;
                        <(oRel)>,'O'}],         /* bGETLIST_RELATIVE     */ ;
      nil,                                      /* xGETLIST_OPTIONS2     */ ;
      nil,                                      /* xGETLIST_OPTIONS3     */ ;
      nil,                                      /* xGETLIST_OPTIONS4     */ ;
      nil,                                      /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      <nAccel>,                                 /* nGETLIST_ACCELKEY     */ ;
      <bGotFocus>,                              /* bGETLIST_GOTFOCUS     */ ;
      <bLostFocus>,                             /* bGETLIST_LOSTFOCUS    */ ;
      DC_LogicTest([<.lTabStop.>],[<_tab>],[<.lNoTabStop.>],[<_notab>]),    ;
                                                /* lGETLIST_TABSTOP      */ ;
      <nTabGroup>,                              /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
    } )

* ----------------------------- *

#command  DCHOTKEY <anAccel>                                                ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [WHEN <bWhen>]                                              ;
                [CARGO <xCargo>]                                            ;
                [ACTION <bAction>]                                          ;
                [ID <cID>]                                                  ;
                [TITLE <cTitle>]                                            ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
 =>                                                                         ;
   AAdd( DCGUI_GETLIST, DC_GetTemplate(GETLIST_HOTKEY) )                    ;
     [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                  ;
     [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bAction>)]              ;
     [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                         ;
       {DC_GetAnchorCB(@<oParent>,'O'),<(oParent)>,'O'})]                   ;
     [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                 ;
     [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]                ;
     [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cID>)]                      ;
     [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<anAccel>)]            ;
     [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]                ;
     [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]

* ----------------------------- *

#command  @ <nRow> [,<nCol>] DCOBJECT <oObject>                             ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [EDITPROTECT <bProtect>]                                    ;
                [VALID <bValid>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [TITLE <cTitle>]                                            ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [CARGO <xCargo>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
   =>                                                                       ;
   AADD( DCGUI_GETLIST,                                                     ;
    { GETLIST_OBJECT,                           /* nGETLIST_TYPE         */ ;
      nil,                                      /* nGETLIST_SUBTYPE      */ ;
      nil,                                      /* cGETLIST_CAPTION      */ ;
      nil,                                      /* bGETLIST_VAR          */ ;
      <nRow>,                                   /* nGETLIST_STARTROW     */ ;
      <nCol>,                                   /* nGETLIST_STARTCOL     */ ;
      nil,                                      /* nGETLIST_ENDROW       */ ;
      nil,                                      /* nGETLIST_ENDCOL       */ ;
      nil,                                      /* nGETLIST_WIDTH        */ ;
      nil,                                      /* nGETLIST_HEIGHT       */ ;
      nil,                                      /* cGETLIST_FONT         */ ;
      nil,                                      /* cGETLIST_PICTURE      */ ;
      <bWhen>,                                  /* bGETLIST_WHEN         */ ;
      <bValid>,                                 /* bGETLIST_VALID        */ ;
      <cToolTip>,                               /* cGETLIST_TOOLTIP      */ ;
      <xCargo>,                                 /* xGETLIST_CARGO        */ ;
      nil,                                      /* aGETLIST_PRESENTATION */ ;
      nil,                                      /* bGETLIST_ACTION       */ ;
      <oObject>,                                /* oGETLIST_OBJECT       */ ;
      nil,                                      /* xGETLIST_ORIGVALUE    */ ;
      nil,                                      /* xGETLIST_OPTIONS      */ ;
      nil,                                      /* aGETLIST_COLOR        */ ;
      {<cMsg>,[{DC_GetAnchorCB(@<oMsg>,'O'),<(oMsg)>,'O'}]},                ;
                                                /* cGETLIST_MESSAGE      */ ;
      <cHelpCode>,                              /* cGETLIST_HELPCODE     */ ;
      nil,                                      /* cGETLIST_VARNAME      */ ;
      nil,                                      /* bGETLIST_READVAR      */ ;
      nil,                                      /* bGETLIST_DELIMVAR     */ ;
      <oObject>,                                /* bGETLIST_GROUP        */ ;
      nil,                                      /* nGETLIST_POINTER      */ ;
      [{DC_GetAnchorCB(@<oParent>,'O'),                                     ;
                        <(oParent)>,'O'}][<cPID>], /* bGETLIST_PARENT       */ ;
      nil,                                      /* bGETLIST_REFVAR       */ ;
      <bProtect>,                               /* bGETLIST_PROTECT      */ ;
      <.p.> [.OR. <_pixel>],                    /* lGETLIST_PIXEL        */ ;
      <nCursor>,                                /* nGETLIST_CURSOR       */ ;
      <bEval>,                                  /* bGETLIST_EVAL         */ ;
      [{DC_GetAnchorCb(@<oRel>,'O'),                                        ;
                        <(oRel)>,'O'}],         /* bGETLIST_RELATIVE     */ ;
      nil,                                      /* xGETLIST_OPTIONS2     */ ;
      nil,                                      /* xGETLIST_OPTIONS3     */ ;
      nil,                                      /* xGETLIST_OPTIONS4     */ ;
      nil,                                      /* xGETLIST_OPTIONS5     */ ;
      nil,                                      /* xGETLIST_OPTIONS6     */ ;
      nil,                                      /* xGETLIST_OPTIONS7     */ ;
      nil,                                      /* xGETLIST_OPTIONS8     */ ;
      nil,                                      /* xGETLIST_OPTIONS9     */ ;
      nil,                                      /* cGETLIST_LEVEL        */ ;
      <cTitle>,                                 /* cGETLIST_TITLE        */ ;
      nil,                                      /* cGETLIST_ACCESS       */ ;
      nil,                                      /* bGETLIST_COMPILE      */ ;
      <cId>,                                    /* cGETLIST_ID           */ ;
      nil,                                      /* dGETLIST_REVDATE      */ ;
      nil,                                      /* cGETLIST_REVTIME      */ ;
      nil,                                      /* cGETLIST_REVUSER      */ ;
      <bHide>,                                  /* bGETLIST_HIDE         */ ;
      <nAccel>,                                 /* nGETLIST_ACCELKEY     */ ;
      <bGotFocus>,                              /* bGETLIST_GOTFOCUS     */ ;
      <bLostFocus>,                             /* bGETLIST_LOSTFOCUS    */ ;
      DC_LogicTest([<.lTabStop.>],[<_tab>],[<.lNoTabStop.>],[<_notab>]),    ;
                                                /* lGETLIST_TABSTOP      */ ;
      <nTabGroup>,                              /* nGETLIST_TABGROUP     */ ;
      DC_LogicTest([<.lVisible.>],[<_vis>],[<.lInvisible.>],[<_invis>]),    ;
                                                /* lGETLIST_VISIBLE      */ ;
      <cGroup>,                                 /* cGETLIST_GETGROUP     */ ;
      .f.,                                      /* lGETLIST_FLAG         */ ;
      {ProcName(),ProcLine()},                  /* aGETLIST_PROC         */ ;
      <bPreEval>,                               /* bGETLIST_PREEVAL      */ ;
      <bPostEval>,                              /* bGETLIST_POSTEVAL     */ ;
      <bcClass>,                                /* bGETLIST_CLASS        */ ;
    } )                                                                     ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;

* ----------------------------- *

#command @ <nRow>, <nCol> DCACTIVEXCONTROL <oObject>                        ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [CLSID <cClsID>]                                            ;
                [REGISTER <cIdRegister>,<ocx> [<up:USERPROMPT>] ]           ;
                [LICENSE <cLicense>]                                        ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [OWNER <oOwner>]                                            ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [HELPCODE <cHelpCode>]                                      ;
                [PRESENTATION <aPres>]                                      ;
                [TITLE <cTitle>]                                            ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [CARGO <xCargo>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [SUBCLASS <subclass>]                                       ;
 =>                                                                         ;
   AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_ACTIVEX) )                    ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oObject>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
        DC_GetAnchorCb(@<oRel>,'O'))]                                       ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<cClsID>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,<cLicense>)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS9,                      ;
        {<cIdRegister>,<ocx>,<.up.>})]                                      ;
       ;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<subclass>)           ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]     ;

* ----------------------------- *

#command @ <nRow> [,<nCol>] DCHTMLVIEWER <oObject>                          ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [CLSID <cClsID>]                                            ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [HELPCODE <cHelpCode>]                                      ;
                [PRESENTATION <aPres>]                                      ;
                [TITLE <cTitle>]                                            ;
                [CARGO <xCargo>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [NAVIGATE <navigate>]                                       ;
                [SETHTML <html>]                                            ;
                [BEFORENAVIGATE <beforenav>]                                ;
                [DOCCOMPLETE <doccomplete>]                                 ;
                [NAVCOMPLETE <navcomplete>]                                 ;
                [STATUSTEXTCHANGE <statchange>]                             ;
                [PROGRESSCHANGE <progchange>]                               ;
                [TITLECHANGE <titlechange>]                                 ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [SUBCLASS <cSubClass>]                                      ;
 =>                                                                         ;
   AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_HTMLVIEWER) )                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oObject>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
        DC_GetAnchorCb(@<oRel>,'O'))]                                       ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
        { <cClsID>, <navigate>, <html> })]                                  ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
        { <beforenav>, <doccomplete>, <navcomplete>, <statchange>,          ;
          <progchange>, <titlechange> })]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;

* ----------------------------- *

#command @ <nRow> [,<nCol>]  DCRTF                                          ;
                [VAR <uVar>]                                                ;
                [OBJECT <oObject>]                                          ;
                [SIZE <nWidth> [,<nHeight>]]                                ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [MESSAGE <cMsg> [INTO <oMsg>]]                              ;
                [WHEN <bWhen>]                                              ;
                [HIDE <bHide>]                                              ;
                [HELPCODE <cHelpCode>]                                      ;
                [PRESENTATION <aPres>]                                      ;
                [TITLE <cTitle>]                                            ;
                [TOOLTIP <cToolTip>]                                        ;
                [CURSOR <nCursor>]                                          ;
                [CARGO <xCargo>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [RELATIVE <oRel>]                                           ;
                [ID <cId>]                                                  ;
                [ACCELKEY <nAccel>]                                         ;
                [GOTFOCUS <bGotFocus>]                                      ;
                [LOSTFOCUS <bLostFocus>]                                    ;
                [<lTabStop:TABSTOP>] [_TABSTOP <_tab>]                      ;
                [<lNoTabStop:NOTABSTOP>] [_NOTABSTOP <_notab>]              ;
                [TABGROUP <nTabGroup>]                                      ;
                [<lVisible:VISIBLE>] [_VISIBLE <_vis>]                      ;
                [<lInvisible:INVISIBLE>] [INVISIBLE <_invis>]               ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [RESIZE <aReSize>  [<sf:SCALEFONT>]]                        ;
                [APPEARANCE <nAppearance>]                                  ;
                [MAXLENGTH <nMaxLen>]                                       ;
                [RIGHTMARGIN <nRightMargin>]                                ;
                [SCROLLBARS <nScrollBars>]                                  ;
                [POPUPMENU <oPopupMenu>]                                    ;
                [<lUsePopUp:USEPOPUPMENU>] [_USEPOPUPMENU <_usepopup>]      ;
                [BULLETINDENT <nBulletIndent>]                              ;
                [<lHideSel:HIDESELECTION>] [_HIDESEL <_hidesel>]            ;
                [<lLocked:LOCKED>] [_LOCKED <_locked>]                      ;
                [FILE <cFileName>]                                          ;
                [SELCHANGE <bSelChange>]                                    ;
                [CHANGE <bChange>]                                          ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [SUBCLASS <cSubClass>]                                      ;
 =>                                                                         ;
   AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_RTF) )                        ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_VAR,                           ;
         DC_GetAnchorCB(@<uVar>))]                                          ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_WHEN,<bWhen>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,{<cMsg>,nil})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_MESSAGE,                       ;
         DC_GetAnchorCB(@<oMsg>,'O'),2)]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
        DC_GetAnchorCB(@<oObject>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_RELATIVE,                      ;
        DC_GetAnchorCb(@<oRel>,'O'))]                                       ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_ACCELKEY,<nAccel>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GOTFOCUS,<bGotFocus>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_LOSTFOCUS,<bLostFocus>)]       ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<.lTabStop.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,<_tab>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<.lNoTabStop.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_TABSTOP,!<_notab>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_TABGROUP,<nTabGroup>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<.lVisible.>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,<_vis>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<.lInvisible.>)]      ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_VISIBLE,!<_invis>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<.sf.>,3)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
         {<nAppearance>,<nMaxLen>,<nRightMargin>,<nScrollBars>,             ;
          <nBulletIndent>,<.lHideSel.>,<.lLocked.>,<.lUsePopUp.>})]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_hidesel>,6)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_locked>,7)]          ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<_usepopup>,8)]        ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
                 DC_GetAnchorCb(@<oPopupMenu>,'O'))]                        ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,<cFileName>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS4,<bSelChange>)]        ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS5,<bChange>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;


 * ----------------------------- *

#command  DCSETPARENT [TO] [<oParent>]                                      ;
 =>                                                                         ;
   AAdd( DCGUI_GETLIST, DC_GetTemplate(GETLIST_SETPARENT) )                 ;
   [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                           ;
         {DC_GetAnchorCB(@<oParent>,'O'),<(oParent)>,'O'})]

#command  DCSETPARENT ID [<cPID>]                                           ;
 =>                                                                         ;
   AAdd( DCGUI_GETLIST, DC_GetTemplate(GETLIST_SETPARENT) )                 ;
   [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]


* ----------------------------- *

#command  DCSETGROUP [TO] [<cGroup>]                                        ;
 =>                                                                         ;
   AAdd( DCGUI_GETLIST, DC_GetTemplate(GETLIST_SETGROUP) )                  ;
    [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]

* ----------------------------- *

#command  DCSETRESIZE [TO] [<aResize>]                                      ;
 =>                                                                         ;
   AAdd( DCGUI_GETLIST, DC_GetTemplate(GETLIST_SETRESIZE) )                 ;
    ;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aResize>)

* ----------------------------- *

#command  DCSETFONT [TO] [<cFont>]                                          ;
 =>                                                                         ;
   AAdd( DCGUI_GETLIST, DC_GetTemplate(GETLIST_SETFONT) )                   ;
    ;DC_GetListSet(DCGUI_GETLIST,cGETLIST_FONT,<cFont>)


* ----------------------------- *

#command  DCSETCOLOR [TO] [<ncFgC> [,<ncBgC>]]                              ;
 =>                                                                         ;
   AAdd( DCGUI_GETLIST, DC_GetTemplate(GETLIST_SETCOLOR) )                  ;
    ;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})

* ----------------------------- *

#command  DCSETSAYOPTION [TO] [<nOption>]                                   ;
 =>                                                                         ;
   AAdd( DCGUI_GETLIST, DC_GetTemplate(GETLIST_SETSAYOPTION) )              ;
    ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,<nOption>)

* ------------------------------- *

#command DCSTATUSBAR <oObject>                                              ;
                [TYPE <nType>]                                              ;
                [ALIGN <nAlign>]                                            ;
                [HEIGHT <nHeight>]                                          ;
                [WIDTH <nWidth>]                                            ;
                [SPACING <nSpacing>]                                        ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [CARGO <xCargo>]                                            ;
                [PRESENTATION <aPres>]                                      ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [HIDE <bHide>]                                              ;
                [ID <cId>]                                                  ;
                [GROUP <cGroup>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [CLASS <bcClass>]                                           ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [SUBCLASS <cSubClass>]                                      ;
 =>                                                                         ;
   AAdd( DCGUI_GETLIST, DC_GetTemplate(GETLIST_STATUSBAR,<nType>) )         ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,{<nAlign>,<nSpacing>})];
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
         DC_GetAnchorCB(@<oObject>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
         DC_GetAnchorCB(@<oParent>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
       ;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,.t.)                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLe,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
         {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]    ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;

* ------------------------------- *

#command DCPANEL <oObject>                                                  ;
                [DRAWINGAREA <oDrawingArea>]                                ;
                [TYPE <nType>]                                              ;
                [ALIGN <nAlign>]                                            ;
                [HEIGHT <nHeight>]                                          ;
                [WIDTH <nWidth>]                                            ;
                [BITMAP <nBitMap>]                                          ;
                [BORDER <nBorder>]                                          ;
                [COLOR <ncFgC> [,<ncBgC>] ]                                 ;
                [SPACING <nSpacing>]                                        ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [CARGO <xCargo>]                                            ;
                [PRESENTATION <aPres>]                                      ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [TITLE <cTitle>]                                            ;
                [HIDE <bHide>]                                              ;
                [ID <cId>]                                                  ;
                [GROUP <cGroup>]                                            ;
                [HELPCODE <cHelpCode>]                                      ;
                [CLASS <bcClass>]                                           ;
                [DRAG <bDrag> [TYPE <nDragType>] [DIALOG <bDD>]]            ;
                [DROP <bDrop> [TYPE <nDropType>] [CURSOR <nDropCursor>]]    ;
 =>                                                                         ;
   AAdd( DCGUI_GETLIST, DC_GetTemplate(GETLIST_PANEL,<nType>) )             ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,{<ncFgC>,<ncBgC>})]      ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
         {<nAlign>,<nSpacing>,<nBorder>,<nBitMap>})                         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
         DC_GetAnchorCB(@<oObject>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
         DC_GetAnchorCB(@<oParent>,'O'))]                                   ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_REFVAR,                        ;
         DC_GetAnchorCB(@<oDrawingArea>,'O'))]                              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
       ;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,.t.)                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLe,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_HIDE,<bHide>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_HELPCODE,<cHelpCode>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_DRAGDROP,                      ;
        {<bDrag>,<nDragType>,<bDD>,<bDrop>,<nDropType>,<nDropCursor>})]     ;

* ---------------------------------- *

#command @ <nRow>, <nCol> DCSPLITBAR <oSplitBar>                            ;
                [SIZE <nWidth>,<nHeight>]                                   ;
                [PARENT <oParent>]                                          ;
                [PARENTID <cPID>]                                           ;
                [PRESENTATION <aPres>]                                      ;
                [COLOR <ncBgC>]                                             ;
                [MOVECOLOR <nMoveColor>]                                    ;
                [CARGO <xCargo>]                                            ;
                [ORIENTATION <nOrientation>]                                ;
                [TITLE <cTitle>]                                            ;
                [EVAL <bEval>]                                              ;
                [PREEVAL <bPreEval>]                                        ;
                [POSTEVAL <bPostEval>]                                      ;
                [CURSOR <nCursor>]                                          ;
                [ID <cId>]                                                  ;
                [GROUP <cGroup>]                                            ;
                [CLASS <bcClass>]                                           ;
                [MINSIZE <nMinSize>]                                        ;
                [MAXSIZE <nMaxSize>]                                        ;
                [PREDECESSOR <oPredecessor>]                                ;
                [SUCCESSOR <oSuccessor>]                                    ;
                [<live:LIVEREDRAW>]                                         ;
                [RESIZE <aReSize>]                                          ;
                [<resizeDialog:RESIZEDIALOG>]                               ;
                [<p: PIXEL>] [_PIXEL <_pixel>]                              ;
                [TOOLTIP <cToolTip>]                                        ;
                [SUBCLASS <cSubClass>]                                      ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,                                                     ;
            DC_GetTemplate(GETLIST_SPLITBAR) )                              ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_CARGO,<xCargo>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_PRESENTATION,<aPres>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_COLOR,<ncBgC>)]                ;
       ;DC_GetListSet(DCGUI_GETLIST,bGETLIST_GROUP,                         ;
         DC_GetAnchorCB(@<oSplitBar>,'O'))                                  ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_CURSOR,<nCursor>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTROW,<nRow>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_STARTCOL,<nCol>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_WIDTH,<nWidth>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,nGETLIST_HEIGHT,<nHeight>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,                        ;
        DC_GetAnchorCB(@<oParent>,'O'))]                                    ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PARENT,<cPID>)]                ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_EVAL,<bEval>)]                 ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TITLE,<cTitle>)]               ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_ID,<cId>)]                     ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_GETGROUP,<cGroup>)]            ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_CLASS,<bcClass>)]              ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_PREEVAL,<bPreEval>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_POSTEVAL,<bPostEval>)]         ;
      [;DC_GetListSet(DCGUI_GETLIST,aGETLIST_RESIZE,<aReSize>)]             ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<.p.>)]                  ;
      [;DC_GetListSet(DCGUI_GETLIST,lGETLIST_PIXEL,<_pixel>)]               ;
       ;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS,                       ;
         {<nOrientation>,<nMoveColor>,<nMinSize>,<nMaxSize>,<.live.>,       ;
          <.resizeDialog.>})                                                ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS2,                      ;
         DC_GetAnchorCB(@<oPredecessor>,'O'))]                              ;
      [;DC_GetListSet(DCGUI_GETLIST,xGETLIST_OPTIONS3,                      ;
         DC_GetAnchorCB(@<oSuccessor>,'O'))]                                ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_TOOLTIP,<cToolTip>)]           ;
      [;DC_GetListSet(DCGUI_GETLIST,cGETLIST_SUBCLASS,<cSubClass>)]         ;

* ---------------------------------- *

#command DCUSEREVENT <nUserEvent> [ACTION <bAction>]                        ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_USEREVENT,<nUserEvent>) )     ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bAction>)]             ;

* ---------------------------------- *

#command DCEVAL <bAction>                                                   ;
  =>                                                                        ;
   AADD( DCGUI_GETLIST,DC_GetTemplate(GETLIST_EVAL) )                       ;
      [;DC_GetListSet(DCGUI_GETLIST,bGETLIST_ACTION,<bAction>)]             ;

* ------------------------------- *

#command DCGETOPTIONS                                                         ;
                [ NAME <cName>]                                               ;
                [ TITLE <cTitle>]                                             ;
                [ WINDOWHEIGHT <nWndHeight>]                                  ;
                [ WINDOWWIDTH <nWndWidth>]                                    ;
                [ ROWSPACE <nRowSpace>]                                       ;
                [ FONT <cFont> ]                                              ;
                [ SAYFONT <cSayFont>]                                         ;
                [ SAYWIDTH <nSayWidth>]                                       ;
                [ SAYHEIGHT <nSayHeight>]                                     ;
                [ GETHEIGHT <nGetHeight>]                                     ;
                [ GETFONT <cGetFont>]                                         ;
                [ WINDOWROW <nWindowRow>]                                     ;
                [ WINDOWCOL <nWindowCol>]                                     ;
                [ ROWOFFSET <nRowOffset>]                                     ;
                [ COLOFFSET <nColOffset>]                                     ;
                [ <lDesign:DESIGN> [HOTKEY <nDesignHotKey>] ]                 ;
                [ <p:PIXEL>] [_PIXEL <_p>]                                    ;
                [ MENU <acMenu> [MSGBOX <oMsgBox>]                            ;
                       [KEYLIST <cKeyList>] [KEYTYPE <nKeyType>]              ;
                       [WRAPPER <bWrapper>] ]                                 ;
                [ BUTTONS <aButtons>]                                         ;
                [ ICON <nIcon>]                                               ;
                [ <lCheckGet:CHECKGET>] [_CHECKGET <_checkget>]               ;
                [ <lNoCheckGet:NOCHECKGET>] [_NOCHECKGET <_nocheckget>]       ;
                [ <h:HELPFILE,HELPBLOCK> <bcHelp>]                            ;
                [ <lVisible:VISIBLE>] [_VISIBLE <_visible>]                   ;
                [ <lNoTrans:NOTRANSLATE>] [_NOTRANSLATE <_notranslate>]       ;
                [ <lSayRight:SAYRIGHTJUST> ] [_SAYRIGHTJUST <_sayright>]      ;
                [ BITMAP <nBitMap> ]                                          ;
                [ PRESENTATION <aPres> ]                                      ;
                [ COLOR <nBGColor> ]                                          ;
                [ SAYOPTIONS <nSayOpt> ]                                      ;
                [ EVAL <bEval> ]                                              ;
                [ PREEVAL <bPreEval> ]                                        ;
                [ POSTEVAL <bPostEval> ]                                      ;
                [ MODALSTATE <nModalState> ]                                  ;
                [ <lNoMin:NOMINBUTTON> ] [_NOMINBUTTON <_nomin>]              ;
                [ <lNoMax:NOMAXBUTTON> ] [_NOMAXBUTTON <_nomax>]              ;
                [ <lTabStop:TABSTOP> ] [_TABSTOP <_tabstop>]                  ;
                [ <lAbortQuery:ABORTQUERY> [_ABORTQUERY <_abortquery>]        ;
                                           [MSG <bAbortQuery>] ]              ;
                [ <lCloseQuery:CLOSEQUERY> [_CLOSEQUERY <_closequery>]        ;
                                           [MSG <bCloseQuery>] ]              ;
                [ <lExitQuery:EXITQUERY>   [_EXITQUERY <_exitquery>]          ;
                                           [MSG <bExitQuery>] ]               ;
                [ <lQuitQuery:QUITQUERY>   [_QUITQUERY <_quitquery>]          ;
                                           [MSG <bQuitQuery>] ]               ;
                [ ROWPIXELS <nRowPixels> ]                                    ;
                [ COLPIXELS <nColPixels> ]                                    ;
                [ <lNoEscape:NOESCAPEKEY> ] [_NOESCAPEKEY <_noescape>]        ;
                [ <s:SOURCECODE,SOURCEFILE> <cSource> ]                       ;
                [ TOOLTIPCOLOR <nTFg>, <nTBg> ]                               ;
                [ TOOLTIPFONT <cToolTipFont> ]                                ;
                [ TOOLTIPTIME <nToolTipTime> ]                                ;
                [ BORDER <nBorder> ]                                          ;
                [ <lExValid:EXITVALIDATE> ] [_EXITVALIDATE <_exitvalid>]      ;
                [ <lNoTask:NOTASKLIST,NOTASKBAR> ] [_NOTASKLIST <_notask>]    ;
                [ MINSIZE <nMinCol>, <nMinRow> ]                              ;
                [ MAXSIZE <nMaxCol>, <nMaxRow> ]                              ;
                [ <lNoReSize:NORESIZE> ] [_NORESIZE <_noresize>]              ;
                [ <lNoTitle:NOTITLEBAR> ] [_NOTITLEBAR <_notitle>]            ;
                [ <lNoMove:NOMOVEWITHOWNER> ] [_NOMOVEWITHOWNER <_nomove>]    ;
                [ ORIGIN <nOrigin> ]                                          ;
                [ HILITEGETS <nHiliteColor> ]                                 ;
                [ <lNoSuper:NOSUPERVISE> ] [_NOSUPERVISE <_nosuper>]          ;
                [ <lHide:HIDE> ] [_HIDE <_hide>]                              ;
                [ <lNoBusy:NOBUSYPOINTER> ] [_NOBUSYPOINTER <_nobusy>]        ;
                [ BUSYMESSAGE <bcBusyMsg> ]                                   ;
                [ <lCascade:CASCADE> ] [_CASCADE <_cascade>]                  ;
                [ <lAutoResize:AUTORESIZE> ] [_AUTORESIZE <_autoresize>]      ;
                [ <lResize:RESIZE> ] [_RESIZE <_resize>]                      ;
                [ COLORGETS <aColorGets> ]                                    ;
                [ <lNoConfirm:NOCONFIRM> ] [_NOCONFIRM <_noconfirm>]          ;
                [ <lConfirm:CONFIRM> ] [_CONFIRM <_confirm>]                  ;
                [ FITPAD <nFitPad> ]                                          ;
                [ BUTTONALIGN <nButtonAlign> ]                                ;
                [ DISABLEDCOLOR <anDisabledBGClr> ]                           ;
                [ <lEnterTab:ENTERTAB> ] [_ENTERTAB <_entertab>]              ;
                [ EDITPROTECT <bEditProtect> ]                                ;
                [ NOEDITNAVKEYS <bNoEditNavKeys> ]                            ;
                [ MESSAGEINTO <obMessageInto> ]                               ;
                [ BUTTONSOUND <abButtonSound> ]                               ;
                [ HELPCODE <cHelpCode> ]                                      ;
                [ <lMsgClear:MESSAGECLEAR>] [_MESSAGECLEAR <_msgclear>]       ;
                [ <lAWM:AUTOWINDOWMENU,AUTOWINMENU> ] [_AUTOWINDOWMENU <_awm>];
                [ KEYBOARD <cKeyboard> ]                                      ;
                [ <lNWM:NOWINDOWMENU,NOWINMENU> ] [_NOWINDOWMENU <_nwm>]      ;
                [ <lAutoFocus:AUTOFOCUS> ] [_AUTOFOCUS <_autofocus>]          ;
                [ <lCompatible:COMPATIBLE> ] [_COMPATIBLE <_compatible>]      ;
                [ SCALEFACTOR <aScale> ]                                      ;
                [ DEFAULTFONT <cDefFont> ] [FONTDEFAULT <cDefFont>]           ;
                [ RESIZEDEFAULT <aDefaultResize> ]                            ;
                [ <lNoTabStop:NOTABSTOP> ]                                    ;
                [ <lAlways:ALWAYSONTOP> ] [_ALWAYSONTOP <_always>]            ;
                [ ONCLICK <bOnClick> ]                                        ;
                [ <lEnterExit:ENTEREXIT>] [_ENTEREXIT <_enterexit>]           ;
                [ <lRd:RESTOREDEFAULTSBUTTON> ][_RESTOREDEFAULTSBUTTON <_rd>] ;
                [ SCROLLBARS <nScrollBars> ]                                  ;
                [ GETTEMPLATE <cTemplate> ]                                   ;
                [ SAFEEDITPROTECT <bEditProtectSafe> ]                        ;
                [ <lLockToOwner:LOCKWINDOWTOOWNER> ]                          ;
      =>                                                                      ;
   GetOptions :=                                                              ;
     { <cName>,                               /* cGETOPT_NAME          */     ;
       <cTitle>,                              /* cGETOPT_TITLE         */     ;
       <nWndHeight>,                          /* nGETOPT_WNDHEIGHT     */     ;
       <nWndWidth>,                           /* nGETOPT_WNDWIDTH      */     ;
       <nRowSpace>,                           /* nGETOPT_ROWSPACE      */     ;
       <nSayWidth>,                           /* nGETOPT_SAYWIDTH      */     ;
       <cSayFont>,                            /* cGETOPT_SAYFONT       */     ;
       <cGetFont>,                            /* cGETOPT_GETFONT       */     ;
       <nGetHeight>,                          /* nGETOPT_GETHEIGHT     */     ;
       <aButtons>,                            /* aGETOPT_BUTTONS       */     ;
       <nWindowRow>,                          /* nGETOPT_WNDROW        */     ;
       <nWindowCol>,                          /* nGETOPT_WNDCOL        */     ;
       <nRowOffset>,                          /* nGETOPT_ROWOFFSET     */     ;
       <nColOffset>,                          /* nGETOPT_COLOFFSET     */     ;
       IIF(<.lDesign.>,.t.,nil),              /* lGETOPT_DESIGN        */     ;
       [{<acMenu>,<oMsgBox>,<cKeyList>,<nKeyType>,<bWrapper>}],               ;
                                              /* cGETOPT_MENU          */     ;
       [<.p.>][<_p>],                         /* lGETOPT_PIXEL         */     ;
       nil,                                   /* xGETOPT_SPARE         */     ;
       <nIcon>,                               /* nGETOPT_ICON          */     ;
       [<.lCheckGet.>.AND.!<.lNoCheckGet.>],  /* lGETOPT_CHECKGET      */     ;
       <bcHelp>,                              /* cGETOPT_HELPFILE      */     ;
       [<.lVisible.>][<_visible>],            /* lGETOPT_VISIBLE       */     ;
       !<.lNoTrans.> [.AND. !<_notranslate>], /* lGETOPT_TRANSLATE     */     ;
       [<.lSayRight.>][<_sayright>],          /* lGETOPT_SAYRIGHT      */     ;
       <nBitMap>,                             /* nGETOPT_BITMAP        */     ;
       <aPres>,                               /* aGETOPT_PRESENT       */     ;
       <nBGColor>,                            /* nGETOPT_BGCOLOR       */     ;
       <nSayOpt>,                             /* nGETOPT_SAYOPT        */     ;
       <bEval>,                               /* bGETOPT_EVAL          */     ;
       <nModalState>,                         /* nGETOPT_MODALSTATE    */     ;
       <nSayHeight>,                          /* nGETOPT_SAYHEIGHT     */     ;
       !<.lNoMin.> [.AND. !<_nomin>],         /* lGETOPT_MINBUTTON     */     ;
       !<.lNoMax.> [.AND. !<_nomax>],         /* lGETOPT_MAXBUTTON     */     ;
       [<.lTabStop.>] [<_tabstop>],           /* lGETOPT_TABSTOP       */     ;
       {[<.lAbortQuery.>][<_abortquery>],<bAbortQuery>},                      ;
                                              /* lGETOPT_ABORTQUERY    */     ;
       <nRowPixels>,                          /* nGETOPT_ROWPIXELS     */     ;
       <nColPixels>,                          /* nGETOPT_COLPIXELS     */     ;
       !<.lNoEscape.> [.AND. !<_noescape>],   /* lGETOPT_ESCAPEKEY     */     ;
       <cSource>,                             /* cGETOPT_SOURCECODE    */     ;
       [{<nTFg>,<nTBg>}],                     /* aGETOPT_TOOLCOLOR     */     ;
       <nBorder>,                             /* nGETOPT_BORDER        */     ;
       [<.lExValid.>][<_exitvalid>],          /* lGETOPT_EXVALID       */     ;
       {[<.lCloseQuery.>][<_closequery>],<bCloseQuery>},                      ;
                                              /* lGETOPT_CLOSEQUERY    */     ;
       [<.lNoTask.>][<_notask>],              /* lGETOPT_NOTASKLIST    */     ;
       [{<nMinCol>,<nMinRow>}],               /* aGETOPT_MINSIZE       */     ;
       [{<nMaxCol>,<nMaxRow>}],               /* aGETOPT_MAXSIZE       */     ;
       [<.lNoReSize.>][<_noresize>],          /* lGETOPT_NORESIZE      */     ;
       [<.lNoTitle.>][<_notitle>],            /* lGETOPT_NOTITLEBAR    */     ;
       [<.lNoMove.>][<_nomove>],              /* lGETOPT_NOMOVE        */     ;
       <nOrigin>,                             /* nGETOPT_ORIGIN        */     ;
       <nHiliteColor>,                        /* nGETOPT_HILITECOLOR   */     ;
       !(<.lNoSuper.> [.OR. <_nosuper>]),     /* lGETOPT_SUPERVISE     */     ;
       [<.lHide.>][<_hide>],                  /* lGETOPT_HIDEDIALOG    */     ;
       [<.lNoBusy.>][<_nobusy>],              /* lGETOPT_NOBUSY        */     ;
       <bcBusyMsg>,                           /* cGETOPT_BUSYMSG       */     ;
       <nDesignHotKey>,                       /* nGETOPT_DESIGNKEY     */     ;
       [<.lCascade.>][<_cascade>],            /* lGETOPT_CASCADE       */     ;
       [<.lAutoResize.>][<_autoresize>],      /* lGETOPT_AUTORESIZE    */     ;
       <aColorGets>,                          /* aGETOPT_COLORGETS     */     ;
       [!<.lNoConfirm.>][<.lConfirm.>],       /* lGETOPT_CONFIRM       */     ;
       <nFitPad>,                             /* nGETOPT_FITPAD        */     ;
       <nButtonAlign>,                        /* nGETOPT_BUTTONALIGN   */     ;
       {[<.lExitQuery.>][<_exitquery>],<bExitQuery>},                         ;
                                              /* lGETOPT_EXITQUERY     */     ;
       <anDisabledBGClr>,                     /* nGETOPT_DISABLEDCOLOR */     ;
       [<.lEnterTab.>][<_entertab>],          /* lGETOPT_ENTERTAB      */     ;
       <bPreEval>,                            /* bGETOPT_PREEVAL       */     ;
       <cFont>,                               /* cGETOPT_FONT          */     ;
       <bEditProtect>,                        /* bGETOPT_EDITPROTECT   */     ;
       <obMessageInto>,                       /* oGETOPT_MESSAGEINTO   */     ;
       <bNoEditNavKeys>,                      /* bGETOPT_NOEDITNAVKEYS */     ;
       <abButtonSound>,                       /* aGETOPT_BUTTONSOUND   */     ;
       [<.lMsgClear.>][<_msgclear>],          /* lGETOPT_MESSAGECLEAR  */     ;
       <cHelpCode>,                           /* cGETOPT_HELPCODE      */     ;
       [<.lAWM.>][<_awm>],                    /* lGETOPT_AUTOWINMENU   */     ;
       <cKeyboard>,                           /* cGETOPT_KEYBOARD      */     ;
       [<.lNWM.>][<_nwm>],                    /* lGETOPT_NOWINMENU     */     ;
       {[<.lQuitQuery.>][<_quitquery>],<bQuitQuery>},                         ;
                                              /* lGETOPT_QUITQUERY     */     ;
       [<cToolTipFont>],                      /* cGETOPT_TOOLFONT      */     ;
       [<nToolTipTime>],                      /* nGETOPT_TOOLTIME      */     ;
       [<.lAutoFocus.>][<_autofocus>],        /* lGETOPT_AUTOFOCUS     */     ;
       [<.lCompatible.>][<_compatible>],      /* lGETOPT_COMPATIBLE    */     ;
       [<.lResize.>][<_resize>],              /* lGETOPT_RESIZE        */     ;
       [<aScale>],                            /* aGETOPT_SCALEFACTOR   */     ;
       [<cDefFont>],                          /* cGETOPT_FONTDEFAULT   */     ;
       [<aDefaultResize>],                    /* aGETOPT_RESIZEDEFAULT */     ;
       [<.lNoTabStop.>],                      /* lGETOPT_NOTABSTOP     */     ;
       [<.lAlways.>][<_always>],              /* lGETOPT_ALWAYSONTOP   */     ;
       [<bOnClick>],                          /* bGETOPT_ONCLICK       */     ;
       [<.lEnterExit.>][<_enterexit>],        /* lGETOPT_ENTEREXIT     */     ;
       [<.lRd.>][<_rd>],                      /* lGETOPT_RESTDEFBUTT   */     ;
       [<nScrollBars>],                       /* nGETOPT_SCROLLBARS    */     ;
       [<cTemplate>],                         /* cGETOPT_GETTEMPLATE   */     ;
       [<bEditProtectSafe>],                  /* bGETOPT_EDITPROTECTSAFE */   ;
       [<.lLockToOwner.>]                     /* lGETOPT_LOCKTOOWNER   */     ;
    }


#command DCADDGETOPTION                                                       ;
                [ NAME <cName>]                                               ;
                [ TITLE <cTitle>]                                             ;
                [ WINDOWHEIGHT <nWndHeight>]                                  ;
                [ WINDOWWIDTH <nWndWidth>]                                    ;
                [ ROWSPACE <nRowSpace>]                                       ;
                [ FONT <cFont> ]                                              ;
                [ SAYFONT <cSayFont>]                                         ;
                [ SAYWIDTH <nSayWidth>]                                       ;
                [ SAYHEIGHT <nSayHeight>]                                     ;
                [ GETHEIGHT <nGetHeight>]                                     ;
                [ GETFONT <cGetFont>]                                         ;
                [ WINDOWROW <nWindowRow>]                                     ;
                [ WINDOWCOL <nWindowCol>]                                     ;
                [ ROWOFFSET <nRowOffset>]                                     ;
                [ COLOFFSET <nColOffset>]                                     ;
                [ <lDesign:DESIGN> [HOTKEY <nDesignHotKey>] ]                 ;
                [ <p:PIXEL>] [_PIXEL <_p>]                                    ;
                [ MENU <acMenu> [MSGBOX <oMsgBox>]                            ;
                       [KEYLIST <cKeyList>] [KEYTYPE <nKeyType>]              ;
                       [WRAPPER <bWrapper>] ]                                 ;
                [ BUTTONS <aButtons>]                                         ;
                [ ICON <nIcon>]                                               ;
                [ <lCheckGet:CHECKGET>] [_CHECKGET <_CheckGet>]               ;
                [ <lNoCheckGet:NOCHECKGET>] [_NOCHECKGET <_NoCheckGet>]       ;
                [ <h:HELPFILE,HELPBLOCK> <bcHelp>]                            ;
                [ <lVisible:VISIBLE>] [_VISIBLE <_Visible>]                   ;
                [ <lNoTrans:NOTRANSLATE>] [_NOTRANSLATE <_NoTrans>]           ;
                [ <lSayRight:SAYRIGHTJUST> ] [_SAYRIGHTJUST <_SayRight>]      ;
                [ BITMAP <nBitMap> ]                                          ;
                [ PRESENTATION <aPres> ]                                      ;
                [ COLOR <nBGColor> ]                                          ;
                [ SAYOPTIONS <nSayOpt> ]                                      ;
                [ EVAL <bEval> ]                                              ;
                [ PREEVAL <bPreEval> ]                                        ;
                [ POSTEVAL <bPostEval> ]                                      ;
                [ MODALSTATE <nModalState> ]                                  ;
                [ <lNoMin:NOMINBUTTON> ] [_NOMINBUTTON <_NoMin>]              ;
                [ <lNoMax:NOMAXBUTTON> ] [_NOMAXBUTTON <_NoMax>]              ;
                [ <lTabStop:TABSTOP> ] [_TABSTOP <_TabStop>]                  ;
                [ <lAbortQuery:ABORTQUERY> [MSG <bAbortQuery>] ]              ;
                [ <lCloseQuery:CLOSEQUERY> [MSG <bCloseQuery>] ]              ;
                [ <lExitQuery:EXITQUERY> [MSG <bExitQuery>] ]                 ;
                [ ROWPIXELS <nRowPixels> ]                                    ;
                [ COLPIXELS <nColPixels> ]                                    ;
                [ <lNoEscape:NOESCAPEKEY> ] [_NOESCAPEKEY <_NoEscape>]        ;
                [ <s:SOURCECODE,SOURCEFILE> <cSource> ]                       ;
                [ TOOLTIPCOLOR <nTFg>, <nTBg> ]                               ;
                [ BORDER <nBorder> ]                                          ;
                [ <lExValid:EXITVALIDATE> ] [_EXITVALIDATE <_ExValid>]        ;
                [ <lNoTask:NOTASKLIST,NOTASKBAR> ]                            ;
                [ MINSIZE <nMinCol>, <nMinRow> ]                              ;
                [ MAXSIZE <nMaxCol>, <nMaxRow> ]                              ;
                [ <lNoReSize:NORESIZE> ] [_NORESIZE <_NoReSize>]              ;
                [ <lNoTitle:NOTITLEBAR> ]  [_NOTITLEBAR <_NoTitle>]           ;
                [ <lNoMove:NOMOVEWITHOWNER> ] [_NOMOVEWITHOWNER <_NoMove>]    ;
                [ ORIGIN <nOrigin> ]                                          ;
                [ HILITEGETS <nHiliteColor> ]                                 ;
                [ <lNoSuper:NOSUPERVISE> ] [_NOSUPERVISE <_NoSuper>]          ;
                [ <lHide:HIDE> ] [_HIDE <_Hide>]                              ;
                [ <lNoBusy:NOBUSYPOINTER> ] [_NOBUSYPOINTER <_NoBusy>]        ;
                [ BUSYMESSAGE <bcBusyMsg> ]                                   ;
                [ <lCascade:CASCADE> ] [_CASCADE <_Cascade>]                  ;
                [ <lAutoResize:AUTORESIZE> ] [_AUTORESIZE <_AutoResize>]      ;
                [ <lResize:RESIZE> ] [_RESIZE <_resize>]                      ;
                [ COLORGETS <aColorGets> ]                                    ;
                [ <lNoConfirm:NOCONFIRM> ] [_NOCONFIRM <_NoConfirm>]          ;
                [ <lConfirm:CONFIRM> ] [_CONFIRM <_Confirm>]                  ;
                [ FITPAD <nFitPad> ]                                          ;
                [ BUTTONALIGN <nButtonAlign> ]                                ;
                [ DISABLEDCOLOR <anDisabledBGClr> ]                           ;
                [ <lEnterTab:ENTERTAB> ] [_ENTERTAB <_EnterTab>]              ;
                [ EDITPROTECT <bEditProtect> ]                                ;
                [ NOEDITNAVKEYS <bNoEditNavKeys> ]                            ;
                [ MESSAGEINTO <obMessageInto> ]                               ;
                [ BUTTONSOUND <abButtonSound> ]                               ;
                [ HELPCODE <cHelpCode> ]                                      ;
                [ <lMsgClear:MESSAGECLEAR>] [_MESSAGECLEAR <_MsgClear>]       ;
                [ <lAWM:AUTOWINDOWMENU,AUTOWINMENU> ] [_AUTOWINMENU <_AWM>]   ;
                [ KEYBOARD <cKeyboard> ]                                      ;
                [ <lNWM:NOWINDOWMENU,NOWINMENU> ] [_NOWINMENU <_NWM>]         ;
                [ <lAutoFocus:AUTOFOCUS> ] [_AUTOFOCUS <_autofocus>]          ;
                [ <lCompatible:COMPATIBLE> ] [_COMPATIBLE <_compatible>]      ;
                [ SCALEFACTOR <aScale> ]                                      ;
                [ DEFAULTFONT <cDefFont> ] [FONTDEFAULT <cDefFont>]           ;
                [ DEFAULTRESIZE <aDefaultResize> ]                            ;
                [ RESIZEDEFAULT <aDefaultResize> ]                            ;
                [ <lNoTabStop:NOTABSTOP> ]                                    ;
                [ <lAlways:ALWAYSONTOP> ] [_ALWAYSONTOP <_always>]            ;
                [ ONCLICK <bOnClick> ]                                        ;
                [ <lRd:RESTOREDEFAULTSBUTTON> ][_RESTOREDEFAULTSBUTTON <_rd>] ;
                [ SCROLLBARS <nScrollBars> ]                                  ;
                [ GETTEMPLATE <cTemplate> ]                                   ;
                [ SAFEEDITPROTECT <bEditProtectSafe> ]                        ;
      =>                                                                      ;
     ;[DC_ArraySet(GetOptions,cGETOPT_NAME,<cName>)]                          ;
     ;[DC_ArraySet(GetOptions,cGETOPT_TITLE,<cTitle>)]                        ;
     ;[DC_ArraySet(GetOptions,nGETOPT_WNDHEIGHT,<nWndHeight>)]                ;
     ;[DC_ArraySet(GetOptions,nGETOPT_WNDWIDTH,<nWndWidth>)]                  ;
     ;[DC_ArraySet(GetOptions,nGETOPT_ROWSPACE,<nRowSpace>)]                  ;
     ;[DC_ArraySet(GetOptions,nGETOPT_SAYWIDTH,<nSayWidth>)]                  ;
     ;[DC_ArraySet(GetOptions,cGETOPT_SAYFONT,<cSayFont>)]                    ;
     ;[DC_ArraySet(GetOptions,cGETOPT_GETFONT,<cGetFont>)]                    ;
     ;[DC_ArraySet(GetOptions,nGETOPT_GETHEIGHT,<nGetHeight>)]                ;
     ;[DC_ArraySet(GetOptions,aGETOPT_BUTTONS,<aButtons>)]                    ;
     ;[DC_ArraySet(GetOptions,nGETOPT_WNDROW,<nWindowRow>)]                   ;
     ;[DC_ArraySet(GetOptions,nGETOPT_WNDCOL,<nWindowCol>)]                   ;
     ;[DC_ArraySet(GetOptions,nGETOPT_ROWOFFSET,<nRowOffset>)]                ;
     ;[DC_ArraySet(GetOptions,nGETOPT_COLOFFSET,<nColOffset>)]                ;
     ;[DC_ArraySet(GetOptions,lGETOPT_DESIGN,<.lDesign.>)]                    ;
     ;[DC_ArraySet(GetOptions,cGETOPT_MENU,                                   ;
         {<acMenu>,<oMsgBox>,<cKeyList>,<nKeyType>,<bWrapper>})]              ;
     ;[DC_ArraySet(GetOptions,lGETOPT_PIXEL,<.p.>)]                           ;
     ;[DC_ArraySet(GetOptions,lGETOPT_PIXEL,<_p>)]                            ;
     ;[DC_ArraySet(GetOptions,nGETOPT_ICON,<nIcon>)]                          ;
     ;[DC_ArraySet(GetOptions,lGETOPT_CHECKGET,<.lCheckGet.>)]                ;
     ;[DC_ArraySet(GetOptions,lGETOPT_CHECKGET,<_CheckGet>)]                  ;
     ;[DC_ArraySet(GetOptions,lGETOPT_CHECKGET,!<.lNoCheckGet.>)]             ;
     ;[DC_ArraySet(GetOptions,lGETOPT_CHECKGET,!<_NoCheckGet>)]               ;
     ;[DC_ArraySet(GetOptions,cGETOPT_HELPFILE,<bcHelp>)]                     ;
     ;[DC_ArraySet(GetOptions,lGETOPT_VISIBLE,<.lVisible.>)]                  ;
     ;[DC_ArraySet(GetOptions,lGETOPT_VISIBLE,<_Visible>)]                    ;
     ;[DC_ArraySet(GetOptions,lGETOPT_TRANSLATE,!<.lNoTrans.>)]               ;
     ;[DC_ArraySet(GetOptions,lGETOPT_TRANSLATE,!<_NoTrans>)]                 ;
     ;[DC_ArraySet(GetOptions,lGETOPT_SAYRIGHT,<.lSayRight.>)]                ;
     ;[DC_ArraySet(GetOptions,lGETOPT_SAYRIGHT,<_SayRight>)]                  ;
     ;[DC_ArraySet(GetOptions,nGETOPT_BITMAP,<nBitMap>)]                      ;
     ;[DC_ArraySet(GetOptions,aGETOPT_PRESENT,<aPres>)]                       ;
     ;[DC_ArraySet(GetOptions,nGETOPT_BGCOLOR,<nBGColor>)]                    ;
     ;[DC_ArraySet(GetOptions,nGETOPT_SAYOPT,<nSayOpt>)]                      ;
     ;[DC_ArraySet(GetOptions,bGETOPT_EVAL,<bEval>)]                          ;
     ;[DC_ArraySet(GetOptions,nGETOPT_MODALSTATE,<nModalState>)]              ;
     ;[DC_ArraySet(GetOptions,lGETOPT_MINBUTTON,!<.lNoMin.>)]                 ;
     ;[DC_ArraySet(GetOptions,lGETOPT_MINBUTTON,!<_NoMin>)]                   ;
     ;[DC_ArraySet(GetOptions,lGETOPT_MAXBUTTON,!<.lNoMax.>)]                 ;
     ;[DC_ArraySet(GetOptions,lGETOPT_MAXBUTTON,!<_NoMax>)]                   ;
     ;[DC_ArraySet(GetOptions,lGETOPT_TABSTOP,<.lTabStop.>)]                  ;
     ;[DC_ArraySet(GetOptions,lGETOPT_TABSTOP,<_TabStop>)]                    ;
     ;[DC_ArraySet(GetOptions,lGETOPT_ABORTQUERY,                             ;
                                  {<.lAbortQuery.>,<bAbortQuery>})]           ;
     ;[DC_ArraySet(GetOptions,nGETOPT_ROWPIXELS,<nRowPixels>)]                ;
     ;[DC_ArraySet(GetOptions,nGETOPT_COLPIXELS,<nColPixels>)]                ;
     ;[DC_ArraySet(GetOptions,lGETOPT_ESCAPEKEY,!<.lNoEscape.>)]              ;
     ;[DC_ArraySet(GetOptions,lGETOPT_ESCAPEKEY,!<_NoEscape>)]                ;
     ;[DC_ArraySet(GetOptions,cGETOPT_SOURCECODE,<cSource>)]                  ;
     ;[DC_ArraySet(GetOptions,aGETOPT_TOOLCOLOR,{<nTFg>,<nTBg>})]             ;
     ;[DC_ArraySet(GetOptions,nGETOPT_BORDER,<nBorder>)]                      ;
     ;[DC_ArraySet(GetOptions,lGETOPT_EXVALID,<.lExValid.>)]                  ;
     ;[DC_ArraySet(GetOptions,lGETOPT_EXVALID,<_ExValid>)]                    ;
     ;[DC_ArraySet(GetOptions,lGETOPT_CLOSEQUERY,                             ;
                                  {<.lCloseQuery.>,<bCloseQuery>})]           ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NOTASKLIST,<.lNoTask.>)]                ;
     ;[DC_ArraySet(GetOptions,aGETOPT_MINSIZE,{<nMinCol>,<nMinRow>})]         ;
     ;[DC_ArraySet(GetOptions,aGETOPT_MAXSIZE,{<nMaxCol>,<nMaxRow>})]         ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NORESIZE,<.lNoReSize.>)]                ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NORESIZE,<_NoReSize>)]                  ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NOTITLEBAR,<.lNoTitle.>)]               ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NOTITLEBAR,<_NoTitle>)]                 ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NOMOVE,<.lNoMove.>)]                    ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NOMOVE,<_NoMove>)]                      ;
     ;[DC_ArraySet(GetOptions,nGETOPT_ORIGIN,<nOrigin>)]                      ;
     ;[DC_ArraySet(GetOptions,nGETOPT_HILITECOLOR,<nHiliteColor>)]            ;
     ;[DC_ArraySet(GetOptions,lGETOPT_SUPERVISE,!<.lNoSuper.>)]               ;
     ;[DC_ArraySet(GetOptions,lGETOPT_SUPERVISE,!<_NoSuper>)]                 ;
     ;[DC_ArraySet(GetOptions,lGETOPT_HIDEDIALOG,<.lHide.>)]                  ;
     ;[DC_ArraySet(GetOptions,lGETOPT_HIDEDIALOG,<_Hide>)]                    ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NOBUSY,<.lNoBusy.>)]                    ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NOBUSY,<_NoBusy>)]                      ;
     ;[DC_ArraySet(GetOptions,cGETOPT_BUSYMSG,<bcBusyMsg>)]                   ;
     ;[DC_ArraySet(GetOptions,nGETOPT_DESIGNKEY,<nDesignHotKey>)]             ;
     ;[DC_ArraySet(GetOptions,lGETOPT_CASCADE,<.lCascade.>)]                  ;
     ;[DC_ArraySet(GetOptions,lGETOPT_CASCADE,<_Cascade>)]                    ;
     ;[DC_ArraySet(GetOptions,lGETOPT_AUTORESIZE,<.lAutoResize.>)]            ;
     ;[DC_ArraySet(GetOptions,lGETOPT_AUTORESIZE,<_AutoResize>)]              ;
     ;[DC_ArraySet(GetOptions,aGETOPT_COLORGETS,<aColorGets>)]                ;
     ;[DC_ArraySet(GetOptions,lGETOPT_CONFIRM,<.lConfirm.>)]                  ;
     ;[DC_ArraySet(GetOptions,lGETOPT_CONFIRM,!<.lNoConfirm.>)]               ;
     ;[DC_ArraySet(GetOptions,lGETOPT_CONFIRM,!<_Confirm>)]                   ;
     ;[DC_ArraySet(GetOptions,lGETOPT_CONFIRM,!<_NoConfirm>)]                 ;
     ;[DC_ArraySet(GetOptions,nGETOPT_FITPAD,<nFitPad>)]                      ;
     ;[DC_ArraySet(GetOptions,nGETOPT_BUTTONALIGN,<nButtonAlign>)]            ;
     ;[DC_ArraySet(GetOptions,lGETOPT_EXITQUERY,                              ;
                                  {<.lExitQuery.>,<bExitQuery>})]             ;
     ;[DC_ArraySet(GetOptions,nGETOPT_DISABLEDCOLOR,<anDisabledBGClr>)]       ;
     ;[DC_ArraySet(GetOptions,lGETOPT_ENTERTAB,<.lEnterTab.>)]                ;
     ;[DC_ArraySet(GetOptions,lGETOPT_ENTERTAB,<_EnterTab>)]                  ;
     ;[DC_ArraySet(GetOptions,bGETOPT_PREEVAL,<bPreEval>)]                    ;
     ;[DC_ArraySet(GetOptions,cGETOPT_FONT,<cFont>)]                          ;
     ;[DC_ArraySet(GetOptions,bGETOPT_EDITPROTECT,<bEditProtect>)]            ;
     ;[DC_ArraySet(GetOptions,oGETOPT_MESSAGEINTO,<obMessageInto>)]           ;
     ;[DC_ArraySet(GetOptions,bGETOPT_NOEDITNAVKEYS,<bNoEditNavKeys>)]        ;
     ;[DC_ArraySet(GetOptions,aGETOPT_BUTTONSOUND,<abButtonSound>)]           ;
     ;[DC_ArraySet(GetOptions,lGETOPT_MESSAGECLEAR,<.lMsgClear.>)]            ;
     ;[DC_ArraySet(GetOptions,lGETOPT_MESSAGECLEAR,<_MsgClear>)]              ;
     ;[DC_ArraySet(GetOptions,cGETOPT_HELPCODE,<cHelpCode>)]                  ;
     ;[DC_ArraySet(GetOptions,lGETOPT_AUTOWINMENU,<.lAWM.>)]                  ;
     ;[DC_ArraySet(GetOptions,lGETOPT_AUTOWINMENU,<_AWM>)]                    ;
     ;[DC_ArraySet(GetOptions,cGETOPT_KEYBOARD,<cKeyboard>)]                  ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NOWINMENU,<.lNWM.>)]                    ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NOWINMENU,<_NWM>)]                      ;
     ;[DC_ArraySet(GetOptions,lGETOPT_AUTOFOCUS,<.lAutoFocus.>)]              ;
     ;[DC_ArraySet(GetOptions,lGETOPT_AUTOFOCUS,<_autofocus>)]                ;
     ;[DC_ArraySet(GetOptions,lGETOPT_COMPATIBLE,<.lCompatible.>)]            ;
     ;[DC_ArraySet(GetOptions,lGETOPT_COMPATIBLE,<_compatible>)]              ;
     ;[DC_ArraySet(GetOptions,lGETOPT_RESIZE,<_resize>)]                      ;
     ;[DC_ArraySet(GetOptions,lGETOPT_RESIZE,<.lResize.>)]                    ;
     ;[DC_ArraySet(GetOptions,aGETOPT_SCALEFACTOR,<aScale>)]                  ;
     ;[DC_ArraySet(GetOptions,cGETOPT_FONTDEFAULT,<cDefFont>)]                ;
     ;[DC_ArraySet(GetOptions,aGETOPT_RESIZEDEFAULT,<aDefaultResize>)]        ;
     ;[DC_ArraySet(GetOptions,lGETOPT_NOTABSTOP,<.lNoTabStop.>)]              ;
     ;[DC_ArraySet(GetOptions,lGETOPT_ALWAYSONTOP,<.lAlways.>)]               ;
     ;[DC_ArraySet(GetOptions,bGETOPT_ONCLICK,<bOnClick>)]                    ;
     ;[DC_ArraySet(GetOptions,lGETOPT_RESTDEFBUTT,<.lRd.>)]                   ;
     ;[DC_ArraySet(GetOptions,lGETOPT_RESTDEFBUTT,<_rd>)]                     ;
     ;[DC_ArraySet(GetOptions,nGETOPT_SCROLLBARS,<nScrollBars>)]              ;
     ;[DC_ArraySet(GetOptions,cGETOPT_GETTEMPLATE,<cTemplate>)]               ;
     ;[DC_ArraySet(GetOptions,bGETOPT_EDITPROTECTSAFE,<bEditProtectSafe>)]    ;



#xtrans  DCGET OPTIONS               ;
         [WINDOW HEIGHT <WH>]        ;
         [WINDOW WIDTH <WW>]         ;
         [WINDOW ROW <WR>]           ;
         [WINDOW COL <WC>]           ;
         [<clauses,...>]             ;
                               =>    ;
         DCGETOPTIONS                ;
         [WINDOWHEIGHT <WH>]         ;
         [WINDOWWIDTH <WW>]          ;
         [WINDOWROW <WR>]            ;
         [WINDOWCOL <WC>]            ;
         [<clauses>]

#xcommand DCREAD GUI                                                        ;
          [ TO <lVar> ]                                                     ;
          [ TITLE <cTitle> ]                                                ;
          [ OPTIONS <aOptions> ]                                            ;
          [ <lButtons:ADDBUTTONS> ] [_ADDBUTTONS <_addbuttons>]             ;
          [ BUTTONS <nButtons> ]                                            ;
          [ <lHandler:HANDLER> <Handler> ]                                  ;
          [ HANDLERBLOCK <bHandler> ]                                       ;
          [ REFERENCE <xRef> ]                                              ;
          [ PARENT <oParent> ]                                              ;
          [ OWNER <oOwner> ]                                                ;
          [ APPWINDOW <oAppWindow> ]                                        ;
          [ <lExit:EXIT> ] [_EXIT <_lExit>]                                 ;
          [ <lFit:FIT> ] [_FIT <_lFit>]                                     ;
          [ <lModal:MODAL,APPMODAL> ] [_MODAL <_lModal>]                    ;
          [ EVAL <bEval> ]                                                  ;
          [ <lSave:SAVE> ] [_SAVE <_save>]                                  ;
          [ <lEnterExit:ENTEREXIT> ] [_ENTEREXIT <_lEnterExit>]             ;
          [ <lArrayTran:ARRAYTRANSLATE> ] [_ARRAYTRANSLATE <_lArrayTran> ]  ;
          [ SETFOCUS <xSetFocus> ]                                          ;
          [ GROUP <acGroup> ]                                               ;
          [ TIMEOUT <nSeconds> ]                                            ;
          [ WAIT <nWait> ]                                                  ;
          [ <lClearEvents:CLEAREVENTS> ] [_CLEAREVENTS <_clearevents>]      ;
          [ <lNoDestroy:NODESTROY> ] [_NODESTROY <_nodestroy>]              ;
          [ <lSetAppWindow:SETAPPWINDOW> ] [_SETAPPWINDOW <_setappwindow>]  ;
          [ WRITESOURCE <cWriteSource> ]                                    ;
          [ <lExpress:EXPRESS> ] [_EXPRESS <_express>]                      ;
          [ POSTEVENT <nEvent> ]                                            ;
          [ <lMultiLists:MULTILISTS> ] [_MULTILISTS <_multilists>]          ;
          [ <lNoRest:NORESTORE,NOAUTORESTORE> ] [_NOAUTORESTORE <_norest> ] ;
          [ <lRest:RESTORE,AUTORESTORE> ] [_AUTORESTORE <_rest> ]           ;
          [ <lNoEnterExit:NOENTEREXIT> ] [_NOENTEREXIT <_noenterexit>]      ;
  =>                                                                        ;
    [<lVar> := ]                                                            ;
       DC_ReadGui(  DCGUI_GETLIST,                                          ;
                    <cTitle>,                                               ;
                    <aOptions>,                                             ;
                    IIF(<.lButtons.> [.OR. <_addbuttons>],                  ;
                         DCGUI_BUTTON_OK+DCGUI_BUTTON_CANCEL, <nButtons>),  ;
                    IIF(<.lHandler.>,                                       ;
                        [{|a,b,c,d,e,f,g,h|<Handler>(a,b,c,d,e,f,@g,h)}],   ;
                        <bHandler> ),                                       ;
                    <xRef>,                                                 ;
                    <oParent>,                                              ;
                    <.lFit.> [.OR. <_lFit>],                                ;
                    nil,                                                    ;
                    <.lExit.> [.OR. <_lExit>],                              ;
                    <oAppWindow>,                                           ;
                    <.lModal.> [.OR. <_lModal>],                            ;
                    <bEval>,                                                ;
                    [<.lEnterExit.>] [<_lEnterExit>] [!<.lNoEnterExit.>] [!<_noenterexit>], ;
                    <.lArrayTran.> [.OR. <_lArrayTran>],                    ;
                    <oOwner>,                                               ;
                    [<xSetFocus>],                                          ;
                    <acGroup>,                                              ;
                    <nSeconds>,                                             ;
                    <nWait>,                                                ;
                    <.lClearEvents.> [.OR. <_clearevents>],                 ;
                    !<.lNoDestroy.> [.AND. !<_nodestroy>],                  ;
                    <.lSetAppWindow.> [.OR. <_setappwindow>],               ;
                    <cWriteSource>,                                         ;
                    <.lExpress.> [.OR. <_express>],                         ;
                    <nEvent>,                                               ;
                    <.lMultiLists.> [.OR. <_multilists>],                   ;
                    [DC_AutoRest(<.lNoRest.>, <_norest>,                    ;
                                 <.lRest.>, <_rest>)] )                     ;
    ; IF !<.lSave.> [.AND. !<_save>] ; ASize( DCGUI_GETLIST,0 ) ; ENDIF

#xcommand DCREAD [TEXT]                                                     ;
          [ TO <lVar> ]                                                     ;
          [ TITLE <cTitle> ]                                                ;
          [ OPTIONS <aOptions> ]                                            ;
          [ HANDLER <Handler> ]                                             ;
          [ PARENT <oDlg> ]                                                 ;
          [ APPWINDOW <oAppWindow> ]                                        ;
          [ AREA <aReadArea> ]                                              ;
          [ REFERENCE <xRef> ]                                              ;
  =>                                                                        ;
    [<lVar> := ]                                                            ;
       DC_ReadGets( DCGUI_GETLIST,                                          ;
                    <cTitle>,                                               ;
                    <aReadArea>,                                            ;
                    <aOptions>,                                             ;
                    [{|a,b,c,d,e,f,g,h|<Handler>(a,b,c,d,e,f,g,h)}],        ;
                    <xRef>,                                                 ;
                    <oDlg>,                                                 ;
                    <oAppWindow>  )

#command DCQOUT WINDOW [<oCrt>] [EVAL <bEval>] [ <app:APPWINDOW> ]           ;
         => DC_QoutWindow( <oCrt>, <bEval>, <.app.> )

#command DCQOUT [<list,...>]  =>  DC_DebugQout( {<list>} )

#xcommand DCQQOUT [<list,...>]  =>  DC_DebugQQout( {<list>} )

#xcommand DCQQDEBUG [<clauses,...>] => DCQDEBUG <clauses>

#xcommand DCDEBUG <var1> [,<varN>] =>  ;
          DC_DebugQout( {<(var1)> + ':',<var1>} ) [; DC_DebugQout( {<(varN)> + ':',<varN>} ) ]

#xtranslate DCBDEBUG <vars,...> ;
          [WINDOW <nWindow>] ;
          [COLOR <nbFgColor> [,<nBgColor>]] ;
          [PAUSE <bPause>] ;
          [<lPause:PAUSE>] ;
          [WHEN <bWhen>] ;
          [<lAlways:ALWAYSONTOP>] ;
          =>  ;
          DC_DebugBrowse( {<vars>}, {<(vars)>}, <nWindow>, <nbFgColor>, <nBgColor>, ;
                          [<.lPause.>] [<bPause>], [<.lAlways.>], <bWhen> )

#xtranslate WTF <vars,...> ;
          [WINDOW <nWindow>] ;
          [COLOR <nbFgColor> [,<nBgColor>]] ;
          [PAUSE <bPause>] ;
          [<lPause:PAUSE>] ;
          [WHEN <bWhen>] ;
          [<lAlways:ALWAYSONTOP>] ;
          =>  ;
          DC_DebugBrowse( {<vars>}, {<(vars)>}, <nWindow>, <nbFgColor>, <nBgColor>, ;
                          [<.lPause.>] [<bPause>], [<.lAlways.>], <bWhen> )

#xtranslate WTFN [EVENTS <events,...>] [ALIAS <alias>] [FIELDS <fields,...>] ;
            [COLOR <fg> [,<bg>]] [VARS <vars,...>] => ;
            DC_WtfNotify( 1, {<events>}, <(alias)>, {<(fields)>}, <fg>, <bg>, 1, ;
                         {<{vars}>}, {<(vars)>} )

#xtranslate WTFN SUSPEND [ALIAS <alias>] => DC_WtfNotify( 2, , <(alias)>, 1 )

#xtranslate WTFN RESUME [ALIAS <alias>] => DC_WtfNotify( 3, , <(alias)>, 1 )

#xtranslate WTFN DESTROY [ALIAS <alias>] => DC_WtfNotify( 4, , <(alias)>, 1 )

#xcommand DCBDEBUGSAVE [TO <c>] [WINDOW <n>] => DC_DebugBrowseSave( <c>, <n> )

#xcommand DCBDEBUGRESTORE [FROM <c>] [WINDOW <n>] => DC_DebugBrowseRestore( <c>, <n> )

#xcommand WTFSAVE [TO <c>] [WINDOW <n>] => DC_DebugBrowseSave( <c>, <n> )

#xcommand WTFRESTORE [FROM <c>] [WINDOW <n>] => DC_DebugBrowseRestore( <c>, <n> )

#xcommand DCQDEBUG => DC_DebugQOut()

#xcommand DCQDEBUG <var1> [,<varN>] =>  ;
          DC_DebugQout( {<(var1)> + ':',<var1>} ) [; DC_DebugQout( {<(varN)> + ':',<varN>} )]

#xcommand DCQDEBUGQUIET <var1> [,<varN>] =>  ;
          DC_DebugQout( {<(var1)> + ':',<var1>}, .f. ) [; DC_DebugQout( {<(varN)> + ':',<varN>}, .f. ) ]

#xcommand DCQDEBUGOFF <var1> [,<varN>] =>  ;
          DC_DebugQout( {<var1>} ) [; DC_DebugQout( {<varN>} ) ]

#xcommand DCQDEBUGOFFQUIET <var1> [,<varN>] =>  ;
          DC_DebugQout( {<var1>}, .f. ) [; DC_DebugQout( {<varN>}, .f. ) ]

#xtranslate DCLDEBUG <var1> [,<varN>] =>  ;
          DC_DebugLogOut( {<(var1)> + ':',<var1>} ) [; DC_DebugLogOut( {<(varN)> + ':',<varN>} )]

#xtranslate WTLN [EVENTS <events,...>] [FIELDS <fields,...>] [ALIAS <alias>] ;
            [COLOR <fg> [,<bg>]] [VARS <vars,...>] => ;
            DC_WtfNotify( 1, {<events>}, <(alias)>, {<(fields)>}, <fg>, <bg>, 2, ;
                         {<{vars}>}, {<(vars)>} )

#xtranslate WTLN SUSPEND [ALIAS <alias>] => DC_WtfNotify( 2, , <(alias)>, 2 )

#xtranslate WTLN RESUME [ALIAS <alias>] => DC_WtfNotify( 3, , <(alias)>, 2 )

#xtranslate WTLN DESTROY [ALIAS <alias>] => DC_WtfNotify( 4, , <(alias)>, 2 )

#xtranslate WTFL <var1> [,<varN>] =>  ;
          DC_DebugLogOut( {<(var1)> + ':',<var1>} ) [; DC_DebugLogOut( {<(varN)> + ':',<varN>} )]

#xtranslate WTL <vars,...> =>  ;
          DC_DebugLogOut( {<vars>}, {<(vars)>} )

#xcommand DCLDEBUGQUIET <var1> [,<varN>] =>  ;
          DC_DebugLogOut( {<(var1)> + ':',<var1>}, .f. ) [; DC_DebugLogOut( {<(varN)> + ':',<varN>}, .f. ) ]

#xcommand DCLDEBUGOFF <var1> [,<varN>] =>  ;
          DC_DebugLogOut( {<var1>} ) [; DC_DebugLogOut( {<varN>} ) ]

#xcommand DCLDEBUGOFFQUIET <var1> [,<varN>] =>  ;
          DC_DebugLogOut( {<var1>}, .f. ) [; DC_DebugLogOut( {<varN>}, .f. ) ]


#xtranslate DCMSGBOX <list,...>       ;
           [TITLE <cTitle>]        ;
           [TIMEOUT <nSeconds>]    ;
           [<yesno:YESNO>]         ;
           [TO <output>]           ;
           [FONT <cFont>]          ;
           [BUTTONS <aButtons>]    ;
           [CHOICE <nChoice>]      ;
           [HOTKEY <cHotKey>]      ;
           [EVAL <bEval>]          ;
           [ICON <nIcon>]          ;
           [<nr:NOAUTORESTORE>]    ;
           [<always:ALWAYSONTOP>]  ;
           [_ALWAYSONTOP <_always>];
           [BUTTSIZE <nWidth>, <nHeight>] ;
           [<horiz:HORIZONTAL>]    ;
           [COLOR <nColorFG> [,<nColorBG>]]
   =>                              ;
  [<output> := ] ;
    DC_MsgBox(,,{<list>},<cTitle>,,<nSeconds>,<.yesno.>,<nChoice>, ;
              <aButtons>,,,<cHotKey>,<cFont>,<bEval>,<nIcon>,<.nr.>, ;
              <.always.>[.OR.<_always>],[{<nColorFG>,<nColorBG>}], ;
              [{<nWidth>,<nHeight>}],<.horiz.>)

#command DCWAITON <msg>            ;
         <m:MODAL>                 ;
         [TO <output>]             ;
         [TITLE <title>]           ;
         [PARENT <parent>]         ;
         [OWNER <owner>]           ;
   =>                              ;
  [<output> := ] ;
    DC_WaitOn(<msg>,,,,,,<title>,,<parent>,<owner>,<m>)

#command DCGUI ON => DC_Gui(.t.)

#command DCGUI OFF => DC_Gui(.f.)

#command GUI ON => DC_Gui(.t.)

#command GUI OFF => DC_Gui(.f.)

#command @ [<nSRow>, <nSCol>, <nERow>, <nECol>] DCACHOICE <array>     ;
           [TITLE <cTitle>]        ;
           [ELEMENT <nElement>]    ;
           [WINSTART <nWinStart>]  ;
           [OBJECT <oObject>]      ;
           [<lCenter:CENTER>]      ;
           [TO <output>]           ;
           [<lNoDestroy:NODESTROY>];
   =>                              ;
  [<output> := ] ;
    DC_AChoice(<nSRow>,<nSCol>,<nERow>,<nECol>,<array>,,,<nElement>, ;
               <nWinStart>,,{.t.,,<cTitle>,.t.,!<.lNoDestroy.>},,,,<oObject>,<.lCenter.>)

#command @ [<nTop>, <nLeft>] DCAPICK <array>                           ;
           [SIZE <nWidth>, <nHeight>]                                  ;
           [HEADER <acHeader>]                                         ;
           [COLWIDTH <anColWidth>]                                     ;
           [TITLE <cTitle>]                                            ;
           [TAG <anTag> [COLOR <aTagColor>] ]                          ;
           [HANDLER <bHandler>]                                        ;
           [START <nStart>]                                            ;
           [FONT <cFontName>]                                          ;
           [PARENT <oParent>]                                          ;
           [OWNER <oOwner>]                                            ;
           [<lCenter:CENTER>]                                          ;
           [<lMenu:MENU>]                                              ;
           [TO <output>]                                               ;
           [<lNoVScroll:NOVSCROLL>]                                    ;
           [<lNoHScroll:NOHSCROLL>]                                    ;
           [PRESENTATION <aPres>]                                      ;
           [HELPCODE <cHelpCode>]                                      ;
           [AUTOSEEKPICTURE <cAutoSeekPicture>]                        ;
           [<lOverride:NOAUTORESTORE>] [_NORESTORE <_override>]        ;
   =>                                                                  ;
  [<output> := ]                                                       ;
    DC_APick ( <nTop>, <nLeft>, <nWidth>, <nHeight>, <array>,          ;
               <acHeader>, <anColWidth>, <cTitle>, <anTag>,            ;
               <aTagColor>, <bHandler>, <nStart>, <cFontName>,         ;
               <oParent>, <oOwner>, <.lCenter.>, <.lMenu.>,            ;
               <.lNoVScroll.>, <.lNoHScroll.>, <aPres>, <cHelpCode>,   ;
               <cAutoSeekPicture>, <.lOverride.> [.OR. <_override>])


#xcommand DCFINDADDCOL                                                  ;
         [DATA <bData>]                                                 ;
         [ELEMENT <nElement>]                                           ;
         [HEADER <cHeader>]                                             ;
         [WIDTH <nWidth>]                                               ;
         [<t: TAG,ORDER,INDEX,SORT> <bncOrder>]                         ;
         [PROMPT <cPrompt>]                                             ;
         [PREFIX <bcPrefix>]                                            ;
         [SEEK <bSeek>]                                                 ;
         [TO <aArray>]                                                  ;
   =>                                                                   ;
         AAdd( <aArray>, { [<bData>] [<nElement>], <cHeader>, <nWidth>, ;
               <bncOrder>, <cPrompt>, <bcPrefix>, <bSeek> } )

#command @ [<nRow>,<nCol>] DCFINDBROWSE                                        ;
         FIELDS <aFields>                                                      ;
         [PARENT <oParent>]                                                    ;
         [SIZE <nWidth>, <nHeight>]                                            ;
         [TITLE <cTitle>]                                                      ;
         [<lAutoSeek:AUTOSEEK>]                                                ;
         [<lHeaders:HEADERS>]                                                  ;
         [<p: PIXEL>] [_PIXEL <_pixel>]                                        ;
         [DATA <acbData>]                                                      ;
         [POINTER <nPointer>]                                                  ;
         [EVAL <bEval>]                                                        ;
         [PRESENTATION <aPres>]                                                ;
         [<lNoHeaders:NOHEADERS>]                                              ;
         [<lNoHScroll:NOHSCROLL>]                                              ;
         [<lNoVScroll:NOVSCROLL>]                                              ;
         [<lExit:EXIT>]                                                        ;
         [SEEKDELAY <nDelay>]                                                  ;
         [TO <lStatus>]                                                        ;
         [FONT <cFont>]                                                        ;
         [<lb:LEFTBUTTONSORT>]                                                 ;
         [POPUP <bPopUp>]                                                      ;
         [SORT <aSort>]                                                        ;
         [GETLIST <aGetList>]                                                  ;
         [ITEMSELECTED <bItemSelected>]                                        ;
         [SAYINDEXFONT <cSayIndexFont>]                                        ;
   =>                                                                          ;
         [<lStatus> := ] DC_FindBrowse( <aFields>, <oParent>, <nRow>, <nCol>,  ;
                        <nWidth>, <nHeight>, <cTitle>, <.lAutoSeek.>,          ;
                        !<.lNoHeaders.>, <.p.> [.OR. <_pixel>], <acbData>,     ;
                        <nPointer>, <bEval>, <aPres>, !<.lNoHScroll.>,         ;
                        !<.lNoVScroll.>, <.lExit.>, <nDelay>, <cFont>, <.lb.>, ;
                        <bPopUp>, <aSort>, [@<aGetList>], <bItemSelected>,     ;
                        <cSayIndexFont> )


#command GETSETFUNCTION <cFunction> DEFAULT <xDefault> => ;
         FUNCTION <cFunction>( xValue ) ;
         ; STATIC sxValue := <xDefault> ;
         ; LOCAL xOldValue := sxValue ;
         ; IF Valtype(<xDefault>) == Valtype(xValue) ;
         ;   sxValue := xValue ;
         ; ENDIF ;
         ; RETURN xOldValue

#command GETSETTHREADFUNCTION <cFunction> DEFAULT <xDefault> => ;
         FUNCTION <cFunction>( xValue )                         ;
         ; STATIC saValue\[0\]                                  ;
         ; LOCAL i, nThreadID := ThreadID(), xOldValue          ;
         ; IF Len(saValue) \< nThreadID                         ;
         ;   ASize( saValue, nThreadID )                        ;
         ; ENDIF                                                ;
         ; FOR i := 1 TO Len(saValue)                           ;
         ;   IF saValue\[i\]==nil                               ;
         ;     saValue\[i\] := <xDefault>                       ;
         ;   ENDIF                                              ;
         ; NEXT                                                 ;
         ; xOldValue := saValue\[nThreadID\]                    ;
         ; IF PCount()==1                                       ;
         ;   saValue\[nThreadID\] := xValue                     ;
         ; ENDIF                                                ;
         ; RETURN xOldValue

#command DCDOT => ;
           IF !IsFunction('DC_DOT') ;
         ;   DllLoad('DCLIP1.DLL') ;
         ; ENDIF ;
         ; &('DC_Dot()')


#define _DCDIALOG_CH

#endif


/*
#translate _IF <exp>  <IFclauses,...>  _ELSE <ELSEclauses,...> _ENDIF => ;
           IIF( <exp>,(<IFclauses>),(<ELSEclauses>) )

#translate _IF <exp>  <IFclauses,...> _ENDIF  => IIF( <exp>,(<IFclauses>), nil )
*/

#xtranslate DCVARGROUP [TO] <o> [NAME <groupname>] <var1> := <val1> [,<varN> := <valN>] =>  ;
            [<o> :=] DC_VarGroup(<(groupname)>,{{<(var1)>,<val1>} [,{<(varN)>,<valN>}] })

#xtranslate VARGROUP [TO] <o> [NAME <groupname>] <var1> [,<varN>] =>  ;
            [<o> :=] DC_VarGroupOld(<(groupname)>,{<(var1)> [,<(varN)>] }):new()


